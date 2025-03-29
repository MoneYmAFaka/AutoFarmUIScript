-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local PhysicsService = game:GetService("PhysicsService")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    autoPotions = false,
    autoUpgrade = false,
    upgradeCooldown = 10 -- Cooldown in seconds between upgrade attempts
}

-- Upgrade IDs
local upgradeIds = {
    "LUCK",
    "COOLDOWN_REDUCTION",
    "BORDER_CHANCE"
}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Automation",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutomationConfig",
        FileName = "Config"
    },
    KeySystem = false
})

-- Create Main Tab
local MainTab = Window:CreateTab("Controls")

-- Functions
local function findPotionObjects()
    local potions = {}
    local folder = Workspace:FindFirstChild("Folder")
    
    if not folder then
        warn("Folder not found in Workspace!")
        return potions
    end

    -- Look for objects in Folder
    for _, obj in pairs(folder:GetChildren()) do
        -- Check if the object has a CollectTrigger part
        local collectTrigger = obj:FindFirstChild("CollectTrigger")
        if collectTrigger then
            table.insert(potions, {Object = obj, CollectTrigger = collectTrigger})
        end
    end
    
    return potions
end

local function findSafeTeleportPosition(collectTrigger)
    local basePosition = collectTrigger.Position
    local characterHeight = 5 -- Approximate height of the character
    local characterWidth = 2 -- Approximate width of the character
    local maxAttempts = 5 -- Number of attempts to find a safe position
    local raycastDistance = 50 -- Distance to cast the ray upward to find the surface

    -- Step 1: Cast a ray downward to find the ground
    local rayOrigin = basePosition + Vector3.new(0, raycastDistance, 0)
    local rayDirection = Vector3.new(0, -raycastDistance * 2, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {collectTrigger.Parent, Players.LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    local safePosition = basePosition
    if raycastResult then
        -- Found the ground, adjust the position to be just above it
        safePosition = raycastResult.Position + Vector3.new(0, characterHeight / 2 + 1, 0)
    else
        -- No ground found below, try casting upward to find a ceiling or surface
        rayOrigin = basePosition - Vector3.new(0, raycastDistance, 0)
        rayDirection = Vector3.new(0, raycastDistance * 2, 0)
        raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if raycastResult then
            safePosition = raycastResult.Position - Vector3.new(0, characterHeight / 2 + 1, 0)
        end
    end

    -- Step 2: Check if the position is safe (not inside a wall)
    local regionSize = Vector3.new(characterWidth, characterHeight, characterWidth)
    local region = Region3.new(safePosition - regionSize / 2, safePosition + regionSize / 2)
    local partsInRegion = Workspace:FindPartsInRegion3(region, Players.LocalPlayer.Character, 100)
    local isSafe = true
    for _, part in pairs(partsInRegion) do
        if part ~= collectTrigger and part.CanCollide and not part:IsDescendantOf(collectTrigger.Parent) then
            isSafe = false
            break
        end
    end

    -- Step 3: If the position isn't safe, try nearby positions
    if not isSafe then
        for i = 1, maxAttempts do
            local offset = Vector3.new(
                math.random(-5, 5), -- Random offset in X
                0,
                math.random(-5, 5) -- Random offset in Z
            )
            local testPosition = safePosition + offset
            region = Region3.new(testPosition - regionSize / 2, testPosition + regionSize / 2)
            partsInRegion = Workspace:FindPartsInRegion3(region, Players.LocalPlayer.Character, 100)
            isSafe = true
            for _, part in pairs(partsInRegion) do
                if part ~= collectTrigger and part.CanCollide and not part:IsDescendantOf(collectTrigger.Parent) then
                    isSafe = false
                    break
                end
            end
            if isSafe then
                safePosition = testPosition
                break
            end
        end
    end

    if not isSafe then
        warn("Could not find a safe teleport position near potion: " .. collectTrigger.Parent.Name)
        return nil -- Return nil to indicate no safe position was found
    end

    return safePosition
end

local function collectPotion(potionData)
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("Player character not found!")
        return false
    end
    local rootPart = character.HumanoidRootPart

    local potion = potionData.Object
    local collectTrigger = potionData.CollectTrigger

    -- Skip if the potion object no longer exists (e.g., already collected)
    if not potion.Parent or not collectTrigger.Parent then
        return false
    end

    -- Find a safe teleport position
    local safePosition = findSafeTeleportPosition(collectTrigger)
    if not safePosition then
        warn("Skipping potion " .. potion.Name .. " due to unsafe teleport position.")
        return false
    end

    -- Check if CollectTrigger has a TouchInterest
    local touchInterest = collectTrigger:FindFirstChild("TouchInterest")
    if touchInterest then
        print("Found TouchInterest on CollectTrigger in potion: " .. potion.Name)

        -- Store the original Anchored state of CollectTrigger
        local originalAnchored = collectTrigger.Anchored

        -- Temporarily anchor the CollectTrigger to prevent it from moving
        collectTrigger.Anchored = true

        -- Teleport the player to the safe position
        rootPart.CFrame = CFrame.new(safePosition)
        task.wait(0.1) -- Small delay to ensure the collision is registered

        -- Restore the original Anchored state
        collectTrigger.Anchored = originalAnchored

        print("Teleported to safe position near CollectTrigger in potion: " .. potion.Name)
        return true
    else
        -- Check for ProximityPrompt on CollectTrigger (just in case)
        local prompt = collectTrigger:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            rootPart.CFrame = CFrame.new(safePosition)
            task.wait(0.1)
            fireproximityprompt(prompt)
            print("Triggered ProximityPrompt on CollectTrigger in potion: " .. potion.Name)
            return true
        end

        -- Check for ClickDetector on CollectTrigger (just in case)
        local clickDetector = collectTrigger:FindFirstChildOfClass("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
            print("Triggered ClickDetector on CollectTrigger in potion: " .. potion.Name)
            return true
        end

        -- If no TouchInterest, ProximityPrompt, or ClickDetector, log a warning
        warn("No TouchInterest, ProximityPrompt, or ClickDetector found on CollectTrigger in potion: " .. potion.Name)
        return false
    end
end

local function collectAllPotions()
    local potionObjects = findPotionObjects()
    if #potionObjects == 0 then
        print("No potion objects found in Folder. Waiting for new potions to spawn...")
        return
    end

    print("Found " .. #potionObjects .. " potion objects in Folder. Collecting them one by one...")

    for _, potionData in pairs(potionObjects) do
        local success = collectPotion(potionData)
        if success then
            -- Wait a bit to ensure the potion is collected before moving to the next one
            task.wait(0.5)
        end
    end
end

local function doUpgrades()
    local successCount = 0
    for _, id in pairs(upgradeIds) do
        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("qVL", 9e9):WaitForChild("241a8cb6-dff6-4009-940d-b805e00d9d7e", 9e9):FireServer(id)
        end)
        if success then
            successCount = successCount + 1
        else
            warn("Failed to trigger upgrade " .. id .. ": " .. err)
        end
        task.wait(0.1) -- Small delay to prevent rate limiting
    end
    if successCount > 0 then
        print("Successfully triggered " .. successCount .. " upgrades.")
    end
    return successCount > 0
end

-- Potion Spawn Detection
local function setupPotionSpawnListener()
    local folder = Workspace:FindFirstChild("Folder")
    if not folder then
        warn("Folder not found in Workspace! Cannot set up spawn listener.")
        return
    end

    -- Check for any existing potions when the script starts
    if Config.autoPotions then
        collectAllPotions()
    end

    -- Listen for new potions spawning
    folder.ChildAdded:Connect(function(child)
        if not Config.autoPotions then
            return -- Only process if autoPotions is enabled
        end

        -- Check if the new child has a CollectTrigger part
        local collectTrigger = child:FindFirstChild("CollectTrigger")
        if collectTrigger then
            print("New potion spawned: " .. child.Name)
            -- Collect all potions (including the new one)
            collectAllPotions()
        end
    end)
end

-- UI Components
MainTab:CreateToggle({
    Name = "Auto Collect Potions",
    CurrentValue = Config.autoPotions,
    Flag = "AutoPotionsToggle",
    Callback = function(Value)
        Config.autoPotions = Value
        if Value then
            print("Auto Collect Potions enabled.")
            -- Collect any existing potions when enabling
            collectAllPotions()
        else
            print("Auto Collect Potions disabled.")
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.autoUpgrade,
    Flag = "AutoUpgradeToggle",
    Callback = function(Value)
        Config.autoUpgrade = Value
        if Value then
            print("Auto Upgrade enabled.")
        else
            print("Auto Upgrade disabled.")
        end
    end
})

MainTab:CreateSlider({
    Name = "Upgrade Cooldown (seconds)",
    Range = {1, 60},
    Increment = 1,
    Suffix = "s",
    CurrentValue = Config.upgradeCooldown,
    Flag = "UpgradeCooldown",
    Callback = function(Value)
        Config.upgradeCooldown = Value
        print("Upgrade Cooldown set to " .. Value .. " seconds.")
    end
})

-- Set up the potion spawn listener
setupPotionSpawnListener()

-- Main Loop for Upgrades (Potions are handled by the ChildAdded event)
spawn(function()
    while true do
        if Config.autoUpgrade then
            local success = pcall(doUpgrades)
            if not success then
                warn("Error occurred while performing upgrades.")
            end
            task.wait(Config.upgradeCooldown) -- Wait for the configured cooldown
        else
            task.wait(1) -- If upgrades are disabled, wait a bit before checking again
        end
    end
end)

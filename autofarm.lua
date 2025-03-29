-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

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

    -- Log all items in Folder
    print("Items in Workspace.Folder:")
    for _, obj in pairs(folder:GetChildren()) do
        local collectTrigger = obj:FindFirstChild("CollectTrigger")
        local touchInterest = collectTrigger and collectTrigger:FindFirstChild("TouchInterest")
        local details = {
            "Name: " .. obj.Name,
            "Has CollectTrigger: " .. (collectTrigger and "Yes" or "No"),
            "Has TouchInterest: " .. (touchInterest and "Yes" or "No"),
            "Position: " .. tostring(obj:GetPrimaryPartCFrame().Position)
        }
        print("- " .. table.concat(details, ", "))
        
        if collectTrigger then
            table.insert(potions, {Object = obj, CollectTrigger = collectTrigger})
        end
    end
    
    return potions
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

    -- Check if CollectTrigger has a TouchInterest
    local touchInterest = collectTrigger:FindFirstChild("TouchInterest")
    if touchInterest then
        print("Found TouchInterest on CollectTrigger in potion: " .. potion.Name)

        -- Store the original Anchored state of CollectTrigger
        local originalAnchored = collectTrigger.Anchored

        -- Temporarily anchor the CollectTrigger to prevent it from moving
        collectTrigger.Anchored = true

        -- Teleport the player directly to the CollectTrigger's position
        rootPart.CFrame = CFrame.new(collectTrigger.Position)
        task.wait(0.5) -- Increased delay to ensure the .Touched event fires and the server processes the collection

        -- Restore the original Anchored state
        collectTrigger.Anchored = originalAnchored

        -- Check if the potion was collected (i.e., it no longer exists)
        if not potion.Parent then
            print("Successfully collected potion: " .. potion.Name)
            return true
        else
            -- Retry once if the potion wasn't collected
            print("Potion " .. potion.Name .. " was not collected on the first attempt. Retrying...")
            rootPart.CFrame = CFrame.new(collectTrigger.Position)
            task.wait(0.5)
            if not potion.Parent then
                print("Successfully collected potion after retry: " .. potion.Name)
                return true
            else
                warn("Failed to collect potion after retry: " .. potion.Name)
                return false
            end
        end
    else
        -- Check for ProximityPrompt on CollectTrigger (just in case)
        local prompt = collectTrigger:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            rootPart.CFrame = CFrame.new(collectTrigger.Position + Vector3.new(0, 5, 0))
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

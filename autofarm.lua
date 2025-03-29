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
    potionCooldown = 5, -- Cooldown in seconds between potion collection attempts
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
    local workspaceFolder = Workspace:FindFirstChild("WorkspaceFolder")
    
    if not workspaceFolder then
        warn("WorkspaceFolder not found in Workspace!")
        return potions
    end

    -- Look for objects in WorkspaceFolder
    for _, obj in pairs(workspaceFolder:GetChildren()) do
        -- Check if the object has a CollectTrigger part
        local collectTrigger = obj:FindFirstChild("CollectTrigger")
        if collectTrigger then
            table.insert(potions, {Object = obj, CollectTrigger = collectTrigger})
        end
    end
    
    return potions
end

local function collectPotions()
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("Player character not found!")
        return false
    end
    local rootPart = character.HumanoidRootPart

    local potionObjects = findPotionObjects()
    if #potionObjects == 0 then
        return false -- No potions found, no need to log repeatedly
    end

    print("Found " .. #potionObjects .. " potion objects in WorkspaceFolder. Attempting to collect...")

    for _, potionData in pairs(potionObjects) do
        local potion = potionData.Object
        local collectTrigger = potionData.CollectTrigger

        -- Skip if the potion object no longer exists (e.g., already collected)
        if not potion.Parent or not collectTrigger.Parent then
            continue
        end

        -- Check for ProximityPrompt on CollectTrigger
        local prompt = collectTrigger:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            -- Teleport to the CollectTrigger to trigger the prompt
            rootPart.CFrame = CFrame.new(collectTrigger.Position + Vector3.new(0, 5, 0))
            task.wait(0.1)
            fireproximityprompt(prompt)
            print("Triggered ProximityPrompt on CollectTrigger in potion: " .. potion.Name)
        end

        -- Check for ClickDetector on CollectTrigger
        local clickDetector = collectTrigger:FindFirstChildOfClass("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
            print("Triggered ClickDetector on CollectTrigger in potion: " .. potion.Name)
        end

        -- If no ProximityPrompt or ClickDetector, attempt collision-based collection
        if not prompt and not clickDetector then
            rootPart.CFrame = CFrame.new(collectTrigger.Position)
            print("No ProximityPrompt or ClickDetector found on CollectTrigger, attempted collision-based collection for potion: " .. potion.Name)
        end

        task.wait(0.2) -- Delay between each potion to prevent rate limiting
    end

    return true -- Indicate that potions were found and processed
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

-- UI Components
MainTab:CreateToggle({
    Name = "Auto Collect Potions",
    CurrentValue = Config.autoPotions,
    Flag = "AutoPotionsToggle",
    Callback = function(Value)
        Config.autoPotions = Value
        if Value then
            print("Auto Collect Potions enabled.")
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
    Name = "Potion Cooldown (seconds)",
    Range = {1, 60},
    Increment = 1,
    Suffix = "s",
    CurrentValue = Config.potionCooldown,
    Flag = "PotionCooldown",
    Callback = function(Value)
        Config.potionCooldown = Value
        print("Potion Cooldown set to " .. Value .. " seconds.")
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

-- Main Loop
spawn(function()
    while true do
        if Config.autoPotions then
            local success = pcall(collectPotions)
            if not success then
                warn("Error occurred while collecting potions.")
            end
            task.wait(Config.potionCooldown) -- Wait for the configured cooldown
        end

        if Config.autoUpgrade then
            local success = pcall(doUpgrades)
            if not success then
                warn("Error occurred while performing upgrades.")
            end
            task.wait(Config.upgradeCooldown) -- Wait for the configured cooldown
        end

        if not Config.autoPotions and not Config.autoUpgrade then
            task.wait(1) -- If both are disabled, wait a bit before checking again
        end
    end
end)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    autoUpgrade = false,
    upgradeCooldown = 10 -- Cooldown in seconds between upgrade attempts
}

-- Upgrade IDs
local upgradeIds = {
    "LUCK",
    "COOLDOWN_REDUCTION",
    "BORDER_CHANCE",
    "POTION_DURATION", -- Added POTION_DURATION
    "BOSS_CHANCE"      -- Added BOSS_CHANCE
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
local function doUpgrades()
    local successCount = 0
    for _, id in pairs(upgradeIds) do
        local args = { [1] = id } -- Create the args table for each upgrade ID
        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("qVL", 9e9):WaitForChild("241a8cb6-dff6-4009-940d-b805e00d9d7e", 9e9):FireServer(unpack(args))
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

-- Main Loop for Upgrades
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

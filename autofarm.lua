-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    autoPotions = false,
    autoUpgrade = false
}

-- Potion IDs
local potionIds = {
    "f1408999-81a7-4b33-842f-0d081c6b9b49",
    "fe7222b5-4992-4fbe-a7c0-fd3c5875ac78",
    "5797c8da-17ab-4b6c-b71f-0f9743f59ab6",
    "4ab7d55b-89e8-4c64-bf16-c1c42266b5eb",
    "8b97aa46-4898-4a13-91ad-4e6f15cc1392",
    "ecad6829-1bcc-47df-8cb4-0a3896b0550b",
    "9bc35ac5-ddf4-4b0a-8454-a806ef4795df",
    "fa1a2beb-444c-40ff-8986-423270183adb",
    "1f753097-4a23-4ee7-8e3c-5b9af794a575",
    "61624234-931f-4237-b0cd-6a90d5960ee7",
    "95d4f693-2bf5-482d-81fe-43e310d757bd",
    "a4804133-5d97-4adf-8f15-60521cc6a113",
    "e93eb399-1c2a-4489-a5e3-349d0131dc13",
    "b5e660e8-0bc6-4493-9342-81bd00c636e2",
    "7b84b04c-d564-4b25-bb74-c310f74718a6"
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
local function collectPotions()
    for _, id in pairs(potionIds) do
        local args = { [1] = id }
        ReplicatedStorage:WaitForChild("qVL", 9e9):WaitForChild("4cd3907d-3b30-493c-a19a-f04036e97fe7", 9e9):FireServer(unpack(args))
        task.wait(0.1) -- Small delay to prevent rate limiting
    end
end

local function doUpgrades()
    for _, id in pairs(upgradeIds) do
        local args = { [1] = id }
        ReplicatedStorage:WaitForChild("qVL", 9e9):WaitForChild("241a8cb6-dff6-4009-940d-b805e00d9d7e", 9e9):FireServer(unpack(args))
        task.wait(0.1) -- Small delay to prevent rate limiting
    end
end

-- UI Components
MainTab:CreateToggle({
    Name = "Auto Collect Potions",
    CurrentValue = Config.autoPotions,
    Flag = "AutoPotionsToggle",
    Callback = function(Value)
        Config.autoPotions = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = Config.autoUpgrade,
    Flag = "AutoUpgradeToggle",
    Callback = function(Value)
        Config.autoUpgrade = Value
    end
})

-- Main Loop
RunService.Heartbeat:Connect(function()
    if Config.autoPotions then
        pcall(collectPotions)
    end
    
    if Config.autoUpgrade then
        pcall(doUpgrades)
    end
    
    task.wait(1) -- Loop delay to prevent excessive server calls
end)

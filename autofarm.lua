-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    autoPotionEnabled = false, -- Toggle for auto-potion collection
    collectionRange = 5, -- Distance in studs to auto-collect potions
}

-- Variables
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Utility",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UtilityConfig",
        FileName = "Config"
    },
    KeySystem = false
})

-- Create Main Tab
local MainTab = Window:CreateTab("Auto Potion")

-- Utility Functions
local function collectPotion(potion)
    -- Since this is in-game, we may not have server-side control
    -- Try to destroy the potion directly (client-side)
    pcall(function()
        potion:Destroy()
        print(LocalPlayer.Name .. " collected a " .. potion.Name)
    end)
end

-- UI Components
MainTab:CreateToggle({
    Name = "Enable Auto Potion",
    CurrentValue = Config.autoPotionEnabled,
    Flag = "AutoPotionToggle",
    Callback = function(Value)
        Config.autoPotionEnabled = Value
    end
})

MainTab:CreateSlider({
    Name = "Collection Range",
    Range = {1, 20},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Config.collectionRange,
    Flag = "CollectionRange",
    Callback = function(Value)
        Config.collectionRange = Value
    end
})

-- Main Auto Potion Loop
RunService.Heartbeat:Connect(function()
    if not Config.autoPotionEnabled then
        return
    end

    -- Search for potions in the entire workspace
    for _, potion in pairs(workspace:GetDescendants()) do
        if potion:IsA("Model") and potion.Name:lower():find("potion") and potion:FindFirstChild("PrimaryPart") then
            local primaryPart = potion.PrimaryPart
            local distance = (rootPart.Position - primaryPart.Position).Magnitude
            if distance <= Config.collectionRange then
                collectPotion(potion)
            end
        end
    end
end)

-- Handle character respawn
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

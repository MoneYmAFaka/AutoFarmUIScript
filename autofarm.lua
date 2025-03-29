-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    potionCollectEnabled = false,
    checkInterval = 1, -- Check every 1 second
}

-- Variables
local LocalPlayer = Players.LocalPlayer
local lastCheck = 0
local qVL = ReplicatedStorage:WaitForChild("qVL", 9e9)
local pickupEvent = qVL:WaitForChild("4cd3907d-3b30-493c-a19a-f04036e97fe7", 9e9)
local potionIdsToCollect = {} -- Table to store potion IDs that need to be collected

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Potion Collector",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PotionConfig",
        FileName = "Config"
    },
    KeySystem = false
})

-- Create Main Tab
local MainTab = Window:CreateTab("Potion Settings")

-- Function to Collect Potion
local function collectPotion(potionId)
    local args = {
        [1] = potionId
    }
    pcall(function()
        pickupEvent:FireServer(unpack(args))
    end)
end

-- Function to Check and Collect Potions
local function checkAndCollectPotions()
    if not Config.potionCollectEnabled then return end

    -- Collect all potion IDs that were detected
    for potionId, _ in pairs(potionIdsToCollect) do
        collectPotion(potionId)
    end

    -- Clear the table after collection
    potionIdsToCollect = {}
end

-- Listen for Potion Spawn Events in qVL
for _, event in pairs(qVL:GetChildren()) do
    if event:IsA("RemoteEvent") then
        event.OnClientEvent:Connect(function(data)
            -- Extract potion ID from event data
            local potionId = nil
            if type(data) == "string" then
                potionId = data
            elseif type(data) == "table" and data[1] then
                potionId = data[1]
            end

            -- Add valid potion ID to collection list
            if potionId and type(potionId) == "string" then
                potionIdsToCollect[potionId] = true
                -- Removed the "potion" string.match filter to collect all IDs
                -- If you need specific filtering, add it back here
            end
        end)
    end
end

-- UI Components
MainTab:CreateToggle({
    Name = "Enable Potion Collector",
    CurrentValue = Config.potionCollectEnabled,
    Flag = "PotionToggle",
    Callback = function(Value)
        Config.potionCollectEnabled = Value
        if Value then
            checkAndCollectPotions() -- Collect any pending potions when enabled
        end
    end
})

MainTab:CreateSlider({
    Name = "Check Interval",
    Range = {1, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = Config.checkInterval,
    Flag = "CheckInterval",
    Callback = function(Value)
        Config.checkInterval = Value
    end
})

-- Main Collection Loop
RunService.Heartbeat:Connect(function()
    if not Config.potionCollectEnabled then return end
    
    local currentTime = tick()
    if currentTime - lastCheck >= Config.checkInterval then
        checkAndCollectPotions() -- Collect potions detected via events
        lastCheck = currentTime
    end
end)

-- Initial Notification
Rayfield:Notify({
    Title = "Potion Collector Loaded",
    Content = "Potion collection system is ready to use!",
    Duration = 5,
    Image = 4483362458
})

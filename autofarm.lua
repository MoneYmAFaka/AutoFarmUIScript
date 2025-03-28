-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    rollEnabled = false,
    rollDelay = 0.05, -- Minimum delay, adjust based on server response
    aggressiveMode = false -- Option to ignore local delay entirely
}

-- Variables
local args = {}
local lastRollTime = 0
local isRolling = false

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Auto Roll",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutoRollConfig",
        FileName = "Config"
    },
    KeySystem = false
})

-- Create Tab
local RollTab = Window:CreateTab("Auto Roll")

-- Roll Function
local function performRoll()
    if isRolling then return end -- Prevent overlapping calls
    isRolling = true
    
    local success, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Knit", 9e9)
            :WaitForChild("Services", 9e9)
            :WaitForChild("RollService", 9e9)
            :WaitForChild("RF", 9e9)
            :WaitForChild("PlayerRoll", 9e9)
            :InvokeServer(unpack(args))
    end)
    
    isRolling = false
    if not success then
        warn("Roll failed: " .. result)
    end
    return success
end

-- UI Components
RollTab:CreateToggle({
    Name = "Enable Auto Roll",
    CurrentValue = Config.rollEnabled,
    Flag = "RollToggle",
    Callback = function(Value)
        Config.rollEnabled = Value
    end
})

RollTab:CreateSlider({
    Name = "Roll Delay",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = Config.rollDelay,
    Flag = "RollDelay",
    Callback = function(Value)
        Config.rollDelay = Value
    end
})

RollTab:CreateToggle({
    Name = "Aggressive Mode",
    CurrentValue = Config.aggressiveMode,
    Flag = "AggressiveToggle",
    Callback = function(Value)
        Config.aggressiveMode = Value
    end
})

-- Main Loop
RunService.RenderStepped:Connect(function(deltaTime)
    if not Config.rollEnabled or isRolling then return end
    
    local currentTime = tick()
    if Config.aggressiveMode then
        -- Attempt roll as fast as possible
        performRoll()
    else
        -- Respect configured delay
        if currentTime - lastRollTime >= Config.rollDelay then
            if performRoll() then
                lastRollTime = currentTime
            end
        end
    end
end)

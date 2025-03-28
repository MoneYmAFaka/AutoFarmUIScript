-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    rollEnabled = false,
    rollDelay = 0.1 -- Roll delay in seconds
}

-- Variables
local args = {} -- Arguments for roll function

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
    ReplicatedStorage:WaitForChild("Knit", 9e9)
        :WaitForChild("Services", 9e9)
        :WaitForChild("RollService", 9e9)
        :WaitForChild("RF", 9e9)
        :WaitForChild("PlayerRoll", 9e9)
        :InvokeServer(unpack(args))
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
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = Config.rollDelay,
    Flag = "RollDelay",
    Callback = function(Value)
        Config.rollDelay = Value
    end
})

-- Main Loop
RunService.RenderStepped:Connect(function()
    if Config.rollEnabled then
        pcall(function()
            performRoll()
        end)
        task.wait(Config.rollDelay) -- Wait between rolls
    end
end)

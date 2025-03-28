-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    rollEnabled = false,
    baseDelay = 0.05, -- Starting delay, will adjust based on server response
    autoAdjust = true -- Automatically detect server cooldown
}

-- Variables
local args = {
    [1] = "Equip"
}
local lastRollTime = 0
local isRolling = false
local detectedCooldown = 0.05 -- Will update based on server response
local lastSuccessTime = 0

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
    if isRolling then return false end
    isRolling = true
    
    local success, result = pcall(function()
        game:GetService("ReplicatedStorage").Events.RolledFromClient:FireServer(unpack(args))
        return true -- FireServer doesn't return a value, so we assume success unless it errors
    end)
    
    isRolling = false
    if success then
        lastSuccessTime = tick()
        return true
    else
        warn("Roll failed: " .. result)
        return false
    end
end

-- UI Components
RollTab:CreateToggle({
    Name = "Enable Auto Roll",
    CurrentValue = Config.rollEnabled,
    Flag = "RollToggle",
    Callback = function(Value)
        Config.rollEnabled = Value
        if Value then
            -- Start the rolling loop in a new thread
            task.spawn(function()
                while true do
                    if not Config.rollEnabled then break end
                    
                    local currentTime = tick()
                    local timeSinceLastRoll = currentTime - lastRollTime
                    
                    if timeSinceLastRoll >= detectedCooldown then
                        local success = performRoll()
                        lastRollTime = currentTime
                        
                        if Config.autoAdjust and not success then
                            -- Increase delay if roll fails
                            detectedCooldown = math.min(detectedCooldown + 0.05, 1)
                            RollTab:UpdateLabel("Detected Cooldown: " .. string.format("%.2f", detectedCooldown) .. "s")
                        elseif Config.autoAdjust and success and currentTime - lastSuccessTime < detectedCooldown then
                            -- Decrease delay if roll succeeds faster
                            detectedCooldown = math.max(currentTime - lastSuccessTime, Config.baseDelay)
                            RollTab:UpdateLabel("Detected Cooldown: " .. string.format("%.2f", detectedCooldown) .. "s")
                        end
                    end
                    
                    task.wait(math.max(detectedCooldown - (tick() - lastRollTime), 0)) -- Wait remaining time
                end
            end)
        end
    end
})

RollTab:CreateSlider({
    Name = "Base Delay",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = Config.baseDelay,
    Flag = "BaseDelay",
    Callback = function(Value)
        Config.baseDelay = Value
    end
})

RollTab:CreateToggle({
    Name = "Auto-Adjust Delay",
    CurrentValue = Config.autoAdjust,
    Flag = "AutoAdjustToggle",
    Callback = function(Value)
        Config.autoAdjust = Value
    end
})

RollTab:CreateLabel("Detected Cooldown: " .. string.format("%.2f", detectedCooldown) .. "s")

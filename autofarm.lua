-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    rollEnabled = false
}

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
                    local args = {
                        [1] = "Equip"
                    }
                    game:GetService("ReplicatedStorage").Events.RolledFromClient:FireServer(unpack(args))
                    wait()
                end
            end)
        end
    end
})

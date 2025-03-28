-- Constants
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Wait for Knit packages more reliably
local function waitForPath(parent, name, timeout)
    local start = tick()
    local instance
    
    repeat
        instance = parent:FindFirstChild(name)
        task.wait()
    until instance or (tick() - start) >= (timeout or 30)
    
    return instance
end

-- Get the service more reliably
local Packages = waitForPath(ReplicatedStorage, "Packages")
local Knit = waitForPath(Packages, "Knit")
local Services = waitForPath(Knit, "Services")
local TargetService = Services and Services:GetChildren()[22]
local RemoteEvent = TargetService and waitForPath(TargetService, "RE")
local TargetRE = RemoteEvent and RemoteEvent:GetChildren()[3]

-- Add new remote function path for rebirth
local RebirthService = Services and Services:GetChildren()[6]
local RebirthRF = RebirthService and waitForPath(RebirthService, "RF")
local RebirthRemote = RebirthRF and waitForPath(RebirthRF, "jag känner en bot, hon heter anna, anna heter hon")

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Auto Click",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- Create Tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- Variables
local args = {}
local isClicking = false
local isRebirthing = false
local rebirthCount = 0

-- Main Tab Features
MainTab:CreateToggle({
   Name = "Auto Click",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
        isClicking = Value
        if Value then
            spawn(function()
                while isClicking do
                    if TargetRE then
                        TargetRE:FireServer(unpack(args))
                    end
                    task.wait()
                end
            end)
        end
   end
})

MainTab:CreateInput({
   Name = "Auto Rebirth Amount",
   PlaceholderText = "Enter amount",
   NumbersOnly = true,
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
        rebirthCount = tonumber(Text) or 0
   end,
})

MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle",
   Callback = function(Value)
        isRebirthing = Value
        if Value then
            spawn(function()
                while isRebirthing do
                    if RebirthRemote then
                        local args = {
                            [1] = rebirthCount or 1
                        }
                        -- Using InvokeServer instead of FireServer since it's an RF
                        local success, result = pcall(function()
                            RebirthRemote:InvokeServer(unpack(args))
                        end)
                        if not success then
                            warn("Rebirth failed:", result)
                        end
                    end
                    task.wait(0.1) -- Small delay between rebirths
                end
            end)
        end
   end
})

-- Settings Tab Features
local keybind = "LeftShift"
SettingsTab:CreateDropdown({
   Name = "UI Toggle Key",
   Options = {"LeftShift", "RightShift", "LeftControl", "RightControl", "LeftAlt", "RightAlt"},
   CurrentOption = keybind,
   Flag = "KeybindDropdown",
   Callback = function(Option)
        keybind = Option
   end,
})

-- UI Toggle Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        local keyPressed = input.KeyCode.Name
        if keyPressed == keybind then
            Rayfield:ToggleWindow()
        end
    end
end)

-- Create Status Label
local StatusLabel = MainTab:CreateLabel("Status: Ready")

-- Update status if remote event is not found
if not TargetRE then
    StatusLabel:Set("Status: Error - Remote Event not found!")
end

-- Update status label to include rebirth remote status
if not RebirthRemote then
    StatusLabel:Set("Status: Error - Rebirth Remote not found!")
end 

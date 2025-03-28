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

-- Add new remote function paths
local PrestigeService = Services and Services:GetChildren()[27]
local PrestigeRF = PrestigeService and waitForPath(PrestigeService, "RF")
local PrestigeRemote = PrestigeRF and waitForPath(PrestigeRF, "jag känner en bot, hon heter anna, anna heter hon")

-- Create Window with new name
local Window = Rayfield:CreateWindow({
   Name = "Auto Farm",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AutoFarmConfig",
      FileName = "Config"
   },
   KeySystem = false
})

-- Create Tabs
local MainTab = Window:CreateTab("Main")
local EggsTab = Window:CreateTab("Eggs")
local SettingsTab = Window:CreateTab("Settings")

-- Variables
local args = {}
local isClicking = false
local isRebirthing = false
local isPrestiging = false
local isHatching = false
local hatchMode = "Single"
local rebirthCount = 0

-- Main Tab Features
MainTab:CreateSection("Auto Click")
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

-- Rebirth Section
MainTab:CreateSection("Auto Rebirth")

MainTab:CreateSlider({
   Name = "Rebirth Amount",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Rebirths",
   CurrentValue = 1,
   Flag = "RebirthAmount",
   Callback = function(Value)
        selectedAmount = Value
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
                            [1] = selectedAmount
                        }
                        RebirthRemote:InvokeServer(unpack(args))
                    end
                    task.wait(0.1)
                end
            end)
        end
   end
})

-- Prestige Section
MainTab:CreateSection("Auto Prestige")

MainTab:CreateToggle({
   Name = "Auto Prestige",
   CurrentValue = false,
   Flag = "AutoPrestigeToggle",
   Callback = function(Value)
        isPrestiging = Value
        if Value then
            spawn(function()
                while isPrestiging do
                    if PrestigeRemote then
                        local success = pcall(function()
                            PrestigeRemote:InvokeServer(unpack(args))
                        end)
                        -- Only try again after 5 seconds if not successful
                        task.wait(success and 0.1 or 5)
                    else
                        task.wait(1)
                    end
                end
            end)
        end
   end
})

-- Eggs Tab
EggsTab:CreateSection("Auto Hatch")

-- Egg Type Selection
EggsTab:CreateDropdown({
   Name = "Egg Type",
   Options = {"Basic"},
   CurrentOption = "Basic",
   Flag = "SelectedEgg",
   Callback = function(Option)
        selectedEgg = Option
   end,
})

-- Hatch Mode Selection
EggsTab:CreateDropdown({
   Name = "Hatch Mode",
   Options = {"Single", "Triple"},
   CurrentOption = "Single",
   Flag = "HatchMode",
   Callback = function(Option)
        hatchMode = Option
   end,
})

EggsTab:CreateToggle({
   Name = "Auto Hatch",
   CurrentValue = false,
   Flag = "AutoHatchToggle",
   Callback = function(Value)
        isHatching = Value
        if Value then
            spawn(function()
                while isHatching do
                    -- Replace with actual egg remote when you have it
                    local args = {
                        [1] = selectedEgg,
                        [2] = hatchMode == "Triple"
                    }
                    -- Add egg remote invocation here when you have it
                    task.wait(0.1)
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

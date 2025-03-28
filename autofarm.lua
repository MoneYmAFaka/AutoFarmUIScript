-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isAimbotEnabled = false
local aimPart = "Head"
local sensitivity = 1
local teamCheck = false

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Combat",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- Create Main Tab
local MainTab = Window:CreateTab("Aimbot")

-- Aimbot Toggle
MainTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
        isAimbotEnabled = Value
   end
})

-- Aim Part Selection
MainTab:CreateDropdown({
   Name = "Aim Part",
   Options = {"Head", "HumanoidRootPart", "UpperTorso"},
   CurrentOption = "Head",
   Flag = "AimPartDropdown",
   Callback = function(Option)
        aimPart = Option
   end
})

-- Sensitivity Slider
MainTab:CreateSlider({
   Name = "Sensitivity",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "Sensitivity",
   Callback = function(Value)
        sensitivity = Value
   end
})

-- Team Check Toggle
MainTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = false,
   Flag = "TeamCheck",
   Callback = function(Value)
        teamCheck = Value
   end
})

-- Utility Functions
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(function()
                if player.Character and player.Character:FindFirstChild(aimPart) and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health > 0 then
                        if teamCheck and player.Team == LocalPlayer.Team then return end
                        
                        local part = player.Character[aimPart]
                        local screenPoint = Camera:WorldToScreenPoint(part.Position)
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        
                        if distance < shortestDistance then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
            end)
        end
    end
    
    return closestPlayer
end

-- Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    if isAimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        pcall(function()
            local target = getClosestPlayer()
            if target and target.Character then
                local part = target.Character[aimPart]
                local pos = Camera:WorldToScreenPoint(part.Position)
                local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                local moveVector = (Vector2.new(pos.X, pos.Y) - mousePos) * (sensitivity / 10)
                
                mousemoverel(moveVector.X, moveVector.Y)
            end
        end)
    end
end) 

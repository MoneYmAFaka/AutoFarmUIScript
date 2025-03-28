-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isAimbotEnabled = false
local aimPart = "Head"
local sensitivity = 1
local teamCheck = false
local wallCheck = true
local aimKey = Enum.UserInputType.MouseButton2 -- Right Mouse Button

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Combat Helper",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CombatConfig",
      FileName = "Config"
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
   Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
   CurrentOption = "Head",
   Flag = "AimPartDropdown",
   Callback = function(Option)
        aimPart = Option
   end
})

-- Sensitivity Slider
MainTab:CreateSlider({
   Name = "Aim Sensitivity",
   Range = {0.1, 10},
   Increment = 0.1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "AimSensitivity",
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

-- Wall Check Toggle
MainTab:CreateToggle({
   Name = "Wall Check",
   CurrentValue = true,
   Flag = "WallCheck",
   Callback = function(Value)
        wallCheck = Value
   end
})

-- FOV Slider
local fovSize = 400
MainTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 800},
   Increment = 50,
   Suffix = "px",
   CurrentValue = 400,
   Flag = "FOVSize",
   Callback = function(Value)
        fovSize = Value
   end
})

-- FOV Circle Drawing
local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.NumSides = 48
circle.Radius = fovSize / 2
circle.Filled = false
circle.Transparency = 1
circle.Color = Color3.new(1, 1, 1)
circle.Visible = false

-- Show FOV Toggle
MainTab:CreateToggle({
   Name = "Show FOV",
   CurrentValue = false,
   Flag = "ShowFOV",
   Callback = function(Value)
        circle.Visible = Value
   end
})

-- Utility Functions
local function isVisible(part)
    if not wallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local direction = (part.Position - origin).Unit
    local result = workspace:Raycast(origin, direction * 1000, raycastParams)
    
    return not result or result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = fovSize
    local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild(aimPart) and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then
                    if teamCheck and player.Team == LocalPlayer.Team then continue end
                    
                    local part = player.Character[aimPart]
                    if not isVisible(part) then continue end
                    
                    local screenPoint = Camera:WorldToScreenPoint(part.Position)
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Update FOV Circle
RunService.RenderStepped:Connect(function()
    circle.Position = UserInputService:GetMouseLocation()
end)

-- Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    if isAimbotEnabled and UserInputService:IsMouseButtonPressed(aimKey) then
        local target = getClosestPlayer()
        if target and target.Character then
            local part = target.Character[aimPart]
            local pos = Camera:WorldToScreenPoint(part.Position)
            local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            local moveVector = (Vector2.new(pos.X, pos.Y) - mousePos) * sensitivity
            
            mousemoverel(moveVector.X/10, moveVector.Y/10)
        end
    end
end)

-- Cleanup
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "Combat Helper" then
        circle:Remove()
    end
end) 

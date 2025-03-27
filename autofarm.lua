-- Define the ScreenGui (assuming this is part of a larger UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggHatcherUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Fetch Egg Names from Workspace.Scripted.EggHolder with Error Handling
local eggNames = {}
local scriptedFolder = game.Workspace:FindFirstChild("Scripted")
if scriptedFolder then
    local eggHolder = scriptedFolder:FindFirstChild("EggHolder")
    if eggHolder then
        for _, egg in pairs(eggHolder:GetChildren()) do
            table.insert(eggNames, egg.Name)
        end
        if #eggNames > 0 then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Eggs Loaded",
                Text = "Found " .. #eggNames .. " eggs in Workspace.Scripted.EggHolder!",
                Duration = 3
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "No eggs found in Workspace.Scripted.EggHolder.",
                Duration = 5
            })
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "EggHolder not found in Workspace.Scripted.",
            Duration = 5
        })
    end
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Scripted folder not found in Workspace.",
        Duration = 5
    })
end

-- Create a Dropdown (simplified example)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Parent = screenGui

local dropdownButton = Instance.new("TextButton")
dropdownButton.Size = UDim2.new(0, 180, 0, 40)
dropdownButton.Position = UDim2.new(0, 10, 0, 10)
dropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
dropdownButton.Text = "Select Egg"
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.Parent = mainFrame

local dropdownList = Instance.new("Frame")
dropdownList.Size = UDim2.new(0, 180, 0, 0)
dropdownList.Position = UDim2.new(0, 10, 0, 50)
dropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdownList.Visible = false
dropdownList.Parent = mainFrame

-- Populate Dropdown if Eggs Exist
if #eggNames > 0 then
    dropdownList.Size = UDim2.new(0, 180, 0, #eggNames * 30)
    for i, eggName in ipairs(eggNames) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, 0, 0, 30)
        option.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        option.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        option.Text = eggName
        option.TextColor3 = Color3.fromRGB(255, 255, 255)
        option.Parent = dropdownList
        
        option.MouseButton1Click:Connect(function()
            dropdownButton.Text = eggName
            dropdownList.Visible = false
        end)
    end
end

-- Toggle Dropdown Visibility
dropdownButton.MouseButton1Click:Connect(function()
    dropdownList.Visible = not dropdownList.Visible
end)

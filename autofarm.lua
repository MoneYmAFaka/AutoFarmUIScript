local args = {
    [1] = "Free Case",
    [2] = false
}

-- Create UI
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CaseOpenerUI"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Open Free Case"
toggleButton.Parent = frame

-- Function to handle button click
local isOpen = false
toggleButton.MouseButton1Click:Connect(function()
    if not isOpen then
        isOpen = true
        toggleButton.Text = "Opening..."
        toggleButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
        
        -- Fire the server event
        game:GetService("ReplicatedStorage"):GetChildren()[25]:FireServer(unpack(args))
        
        -- Reset button after a delay (adjust timing as needed)
        wait(2)
        toggleButton.Text = "Open Free Case"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        isOpen = false
    end
end)

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create Main Frame (the window)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200) -- Center of the screen
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 1
mainFrame.Parent = screenGui

-- Add UICorner for rounded edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Add UIStroke for a border
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(100, 100, 100)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Make the frame draggable
local dragging = false
local dragInput
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Create Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Farm UI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.ZIndex = 3
titleLabel.Parent = titleBar

-- Create Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.ZIndex = 3
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Create Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabFrame.BorderSizePixel = 0
tabFrame.ZIndex = 2
tabFrame.Parent = mainFrame

-- Main Tab Button
local mainTabButton = Instance.new("TextButton")
mainTabButton.Size = UDim2.new(0.5, 0, 1, 0)
mainTabButton.Position = UDim2.new(0, 0, 0, 0)
mainTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
mainTabButton.Text = "Main"
mainTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTabButton.TextScaled = true
mainTabButton.Font = Enum.Font.SourceSans
mainTabButton.ZIndex = 3
mainTabButton.Parent = tabFrame

-- Upgrades Tab Button
local upgradesTabButton = Instance.new("TextButton")
upgradesTabButton.Size = UDim2.new(0.5, 0, 1, 0)
upgradesTabButton.Position = UDim2.new(0.5, 0, 0, 0)
upgradesTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
upgradesTabButton.Text = "Upgrades"
upgradesTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradesTabButton.TextScaled = true
upgradesTabButton.Font = Enum.Font.SourceSans
upgradesTabButton.ZIndex = 3
upgradesTabButton.Parent = tabFrame

-- Create Tab Content Frames
local mainTabContent = Instance.new("Frame")
mainTabContent.Size = UDim2.new(1, 0, 1, -60)
mainTabContent.Position = UDim2.new(0, 0, 0, 60)
mainTabContent.BackgroundTransparency = 1
mainTabContent.ZIndex = 2
mainTabContent.Visible = true
mainTabContent.Parent = mainFrame

local upgradesTabContent = Instance.new("Frame")
upgradesTabContent.Size = UDim2.new(1, 0, 1, -60)
upgradesTabContent.Position = UDim2.new(0, 0, 0, 60)
upgradesTabContent.BackgroundTransparency = 1
upgradesTabContent.ZIndex = 2
upgradesTabContent.Visible = false
upgradesTabContent.Parent = mainFrame

-- Tab Switching Logic
mainTabButton.MouseButton1Click:Connect(function()
    mainTabContent.Visible = true
    upgradesTabContent.Visible = false
    mainTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    upgradesTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

upgradesTabButton.MouseButton1Click:Connect(function()
    mainTabContent.Visible = false
    upgradesTabContent.Visible = true
    mainTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    upgradesTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

-- Toggles State
local autoClick, autoAscend, autoUpgrade = false, false, false

-- Function to Create a Toggle
local function createToggle(parent, name, position, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 3
    toggleFrame.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggleFrame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextScaled = true
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.ZIndex = 4
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0.5, -15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.SourceSans
    toggleButton.ZIndex = 4
    toggleButton.Parent = toggleFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = toggleButton

    local isOn = false
    toggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            toggleButton.Text = "OFF"
        end
        callback(isOn)
    end)
end

-- Function to Create a Rebirth Input UI
local function createRebirthInput(parent, name, position, callback)
    local rebirthFrame = Instance.new("Frame")
    rebirthFrame.Size = UDim2.new(1, -20, 0, 40)
    rebirthFrame.Position = position
    rebirthFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    rebirthFrame.BorderSizePixel = 0
    rebirthFrame.ZIndex = 3
    rebirthFrame.Parent = parent

    local rebirthCorner = Instance.new("UICorner")
    rebirthCorner.CornerRadius = UDim.new(0, 5)
    rebirthCorner.Parent = rebirthFrame

    local rebirthLabel = Instance.new("TextLabel")
    rebirthLabel.Size = UDim2.new(0.4, 0, 1, 0)
    rebirthLabel.Position = UDim2.new(0, 10, 0, 0)
    rebirthLabel.BackgroundTransparency = 1
    rebirthLabel.Text = name
    rebirthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rebirthLabel.TextScaled = true
    rebirthLabel.TextXAlignment = Enum.TextXAlignment.Left
    rebirthLabel.Font = Enum.Font.SourceSans
    rebirthLabel.ZIndex = 4
    rebirthLabel.Parent = rebirthFrame

    local rebirthInput = Instance.new("TextBox")
    rebirthInput.Size = UDim2.new(0, 60, 0, 30)
    rebirthInput.Position = UDim2.new(0.5, 0, 0.5, -15)
    rebirthInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    rebirthInput.Text = "1"
    rebirthInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    rebirthInput.TextScaled = true
    rebirthInput.Font = Enum.Font.SourceSans
    rebirthInput.ZIndex = 4
    rebirthInput.Parent = rebirthFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = rebirthInput

    local rebirthButton = Instance.new("TextButton")
    rebirthButton.Size = UDim2.new(0, 60, 0, 30)
    rebirthButton.Position = UDim2.new(1, -70, 0.5, -15)
    rebirthButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    rebirthButton.Text = "Rebirth"
    rebirthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    rebirthButton.TextScaled = true
    rebirthButton.Font = Enum.Font.SourceSans
    rebirthButton.ZIndex = 4
    rebirthButton.Parent = rebirthFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = rebirthButton

    rebirthButton.MouseButton1Click:Connect(function()
        local count = tonumber(rebirthInput.Text)
        if count and count > 0 then
            callback(count)
        end
    end)
end

-- Create Toggles in Main Tab
createToggle(mainTabContent, "Auto Click", UDim2.new(0, 10, 0, 10), function(state)
    autoClick = state
    if autoClick then
        spawn(function()
            while autoClick and task.wait() do
                local event = game:GetService("ReplicatedStorage"):FindFirstChild("Click3") or
                              game:GetService("ReplicatedStorage"):FindFirstChild("ClickEvent") or
                              (game:GetService("ReplicatedStorage"):FindFirstChild("Events") and game:GetService("ReplicatedStorage").Events:FindFirstChild("Click"))
                if event then
                    pcall(function()
                        event:FireServer()
                    end)
                end
            end
        end)
    end
end)

createToggle(mainTabContent, "Auto Ascend", UDim2.new(0, 10, 0, 60), function(state)
    autoAscend = state
    if autoAscend then
        spawn(function()
            while autoAscend and task.wait(1) do
                local func = game:GetService("ReplicatedStorage"):FindFirstChild("IncreaseMastery") or
                             (game:GetService("ReplicatedStorage"):FindFirstChild("Functions") and game:GetService("ReplicatedStorage").Functions:FindFirstChild("IncreaseMastery"))
                if func then
                    pcall(function()
                        func:InvokeServer()
                    end)
                end
            end
        end)
    end
end)

-- Create Rebirth Input in Main Tab
createRebirthInput(mainTabContent, "Auto Rebirth", UDim2.new(0, 10, 0, 110), function(count)
    spawn(function()
        local event = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or
                      game:GetService("ReplicatedStorage"):FindFirstChild("RebirthEvent") or
                      (game:GetService("ReplicatedStorage"):FindFirstChild("Events") and game:GetService("ReplicatedStorage").Events:FindFirstChild("Rebirth"))
        if event then
            local args = { [1] = count, [2] = "bROaINTGueSSIngAllThis1!!frfrfrfrfrfr" }
            pcall(function()
                event:FireServer(unpack(args))
            end)
        end
    end)
end)

-- Create Toggle in Upgrades Tab
createToggle(upgradesTabContent, "Auto Upgrade", UDim2.new(0, 10, 0, 10), function(state)
    autoUpgrade = state
    if autoUpgrade then
        spawn(function()
            local upgrades = {"ClickMulti", "GemChance", "RebirthButtons", "WalkSpeed", "MoreStorage", 
                             "LuckMulti", "CriticalChance", "HatchSpeed", "PetEquip", "GemMulti"}
            while autoUpgrade do
                for _, upgrade in ipairs(upgrades) do
                    if not autoUpgrade then break end
                    local func = game:GetService("ReplicatedStorage"):FindFirstChild("PurchaseUpgrade") or
                                 (game:GetService("ReplicatedStorage"):FindFirstChild("Functions") and game:GetService("ReplicatedStorage").Functions:FindFirstChild("PurchaseUpgrade"))
                    if func then
                        local args = { [1] = "Spawn", [2] = upgrade }
                        pcall(function()
                            func:InvokeServer(unpack(args))
                        end)
                    end
                    task.wait(0.5)
                end
            end
        end)
    end
end)

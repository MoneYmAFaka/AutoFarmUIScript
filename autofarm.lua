-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create Reopen Button (Symbol)
local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.new(0, 50, 0, 50)
reopenButton.Position = UDim2.new(0, 10, 0, 10)
reopenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
reopenButton.Text = "↺"
reopenButton.TextColor3 = Color3.fromRGB(0, 200, 255)
reopenButton.TextScaled = true
reopenButton.Font = Enum.Font.GothamBold
reopenButton.Visible = false
reopenButton.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 25)
reopenCorner.Parent = reopenButton

-- Create Main Frame (the window) - Expanded width to 450
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 450) -- Increased width from 350 to 450
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -225) -- Adjusted position to center
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 1
mainFrame.Parent = screenGui

-- Add UICorner for rounded edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

-- Add UIStroke for a glowing border
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 200, 255)
uiStroke.Thickness = 2
uiStroke.Transparency = 0.3
uiStroke.Parent = mainFrame

-- Add UIGradient for a sleek effect
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50))
}
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

-- Make the frame draggable
local dragging, dragInput, dragStart, startPos
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
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Create Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Farm UI"
titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.ZIndex = 3
titleLabel.Parent = titleBar

-- Create Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 3
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    reopenButton.Visible = true
end)

reopenButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    reopenButton.Visible = false
end)

-- Create Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tabFrame.BorderSizePixel = 0
tabFrame.ZIndex = 2
tabFrame.Parent = mainFrame

-- Main Tab Button
local mainTabButton = Instance.new("TextButton")
mainTabButton.Size = UDim2.new(0.33, 0, 1, 0)
mainTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
mainTabButton.Text = "Main"
mainTabButton.TextColor3 = Color3.fromRGB(0, 200, 255)
mainTabButton.TextScaled = true
mainTabButton.Font = Enum.Font.Gotham
mainTabButton.ZIndex = 3
mainTabButton.Parent = tabFrame

-- Upgrades Tab Button
local upgradesTabButton = Instance.new("TextButton")
upgradesTabButton.Size = UDim2.new(0.33, 0, 1, 0)
upgradesTabButton.Position = UDim2.new(0.33, 0, 0, 0)
upgradesTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
upgradesTabButton.Text = "Upgrades"
upgradesTabButton.TextColor3 = Color3.fromRGB(0, 200, 255)
upgradesTabButton.TextScaled = true
upgradesTabButton.Font = Enum.Font.Gotham
upgradesTabButton.ZIndex = 3
upgradesTabButton.Parent = tabFrame

-- Settings Tab Button
local settingsTabButton = Instance.new("TextButton")
settingsTabButton.Size = UDim2.new(0.34, 0, 1, 0)
settingsTabButton.Position = UDim2.new(0.66, 0, 0, 0)
settingsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
settingsTabButton.Text = "Settings"
settingsTabButton.TextColor3 = Color3.fromRGB(0, 200, 255)
settingsTabButton.TextScaled = true
settingsTabButton.Font = Enum.Font.Gotham
settingsTabButton.ZIndex = 3
settingsTabButton.Parent = tabFrame

-- Create Tab Content Frames
local mainTabContent = Instance.new("Frame")
mainTabContent.Size = UDim2.new(1, 0, 1, -80)
mainTabContent.Position = UDim2.new(0, 0, 0, 80)
mainTabContent.BackgroundTransparency = 1
mainTabContent.ZIndex = 2
mainTabContent.Visible = true
mainTabContent.Parent = mainFrame

local upgradesTabContent = Instance.new("Frame")
upgradesTabContent.Size = UDim2.new(1, 0, 1, -80)
upgradesTabContent.Position = UDim2.new(0, 0, 0, 80)
upgradesTabContent.BackgroundTransparency = 1
upgradesTabContent.ZIndex = 2
upgradesTabContent.Visible = false
upgradesTabContent.Parent = mainFrame

local settingsTabContent = Instance.new("Frame")
settingsTabContent.Size = UDim2.new(1, 0, 1, -80)
settingsTabContent.Position = UDim2.new(0, 0, 0, 80)
settingsTabContent.BackgroundTransparency = 1
settingsTabContent.ZIndex = 2
settingsTabContent.Visible = false
settingsTabContent.Parent = mainFrame

-- Tab Switching Logic
mainTabButton.MouseButton1Click:Connect(function()
    mainTabContent.Visible = true
    upgradesTabContent.Visible = false
    settingsTabContent.Visible = false
    mainTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    upgradesTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    settingsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

upgradesTabButton.MouseButton1Click:Connect(function()
    mainTabContent.Visible = false
    upgradesTabContent.Visible = true
    settingsTabContent.Visible = false
    mainTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    upgradesTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    settingsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

settingsTabButton.MouseButton1Click:Connect(function()
    mainTabContent.Visible = false
    upgradesTabContent.Visible = false
    settingsTabContent.Visible = true
    mainTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    upgradesTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    settingsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
end)

-- Toggles State
local autoClick, autoAscend, autoUpgrade, autoHatch, autoRebirth, autoCraft = false, false, false, false, false, false

-- List of Eggs from the Image
local eggList = {
    "Animal Rune", "Blooming Rune", "Campfire Rune", "Carnival", "Cloud Rune", "Collectors Rune",
    "Crystal Rune", "Demeter Rune", "Developer Rune", "Dryness Rune", "Ethereal Rune", "Flame Rune",
    "Flower Rune", "Fog Rune", "Fruit Rune", "Grinder Rune", "Heavenly Rune", "Igloo Rune",
    "Infernalix Rune", "Lunar Rune", "Nature Rune", "OP Release Rune", "Ore Rune", "Rarity Rune",
    "Sahara Rune", "Snow Rune"
}

-- Function to Create a Toggle
local function createToggle(parent, name, position, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 3
    toggleFrame.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    toggleLabel.TextScaled = true
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.ZIndex = 4
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 70, 0, 35)
    toggleButton.Position = UDim2.new(1, -80, 0.5, -17.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.ZIndex = 4
    toggleButton.Parent = toggleFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton

    local isOn = false
    toggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleButton.Text = "OFF"
        end
        callback(isOn)
    end)
end

-- Function to Create a Toggle with Number Input (for Auto Rebirth)
local function createToggleWithInput(parent, name, position, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 3
    toggleFrame.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.4, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    toggleLabel.TextScaled = true
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.ZIndex = 4
    toggleLabel.Parent = toggleFrame

    local numberInput = Instance.new("TextBox")
    numberInput.Size = UDim2.new(0, 70, 0, 35)
    numberInput.Position = UDim2.new(0.5, -10, 0.5, -17.5)
    numberInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    numberInput.Text = "1"
    numberInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    numberInput.TextScaled = true
    numberInput.Font = Enum.Font.Gotham
    numberInput.ZIndex = 4
    numberInput.Parent = toggleFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = numberInput

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 70, 0, 35)
    toggleButton.Position = UDim2.new(1, -80, 0.5, -17.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.ZIndex = 4
    toggleButton.Parent = toggleFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton

    local isOn = false
    toggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleButton.Text = "OFF"
        end
        callback(isOn, tonumber(numberInput.Text) or 1)
    end)
end

-- Function to Create Hatch Input UI with Dropdown
local function createHatchInputWithDropdown(parent, name, position, callback)
    local hatchFrame = Instance.new("Frame")
    hatchFrame.Size = UDim2.new(1, -20, 0, 50)
    hatchFrame.Position = position
    hatchFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    hatchFrame.BorderSizePixel = 0
    hatchFrame.ZIndex = 3
    hatchFrame.Parent = parent

    local hatchCorner = Instance.new("UICorner")
    hatchCorner.CornerRadius = UDim.new(0, 10)
    hatchCorner.Parent = hatchFrame

    local hatchLabel = Instance.new("TextLabel")
    hatchLabel.Size = UDim2.new(0.3, 0, 1, 0)
    hatchLabel.Position = UDim2.new(0, 15, 0, 0)
    hatchLabel.BackgroundTransparency = 1
    hatchLabel.Text = name
    hatchLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    hatchLabel.TextScaled = true
    hatchLabel.TextXAlignment = Enum.TextXAlignment.Left
    hatchLabel.Font = Enum.Font.Gotham
    hatchLabel.ZIndex = 4
    hatchLabel.Parent = hatchFrame

    -- Dropdown Button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0, 150, 0, 35)
    dropdownButton.Position = UDim2.new(0.3, 10, 0.5, -17.5)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dropdownButton.Text = "Select Egg"
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextScaled = true
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.ZIndex = 4
    dropdownButton.Parent = hatchFrame

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 10)
    dropdownCorner.Parent = dropdownButton

    -- Dropdown List Frame (Hidden by default)
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0, 150, 0, 150)
    dropdownList.Position = UDim2.new(0.3, 10, 0.5, 17.5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    dropdownList.BorderSizePixel = 0
    dropdownList.ZIndex = 5
    dropdownList.Visible = false
    dropdownList.Parent = hatchFrame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = dropdownList

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.ZIndex = 6
    scrollingFrame.Parent = dropdownList

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = scrollingFrame

    -- Search Bar
    local searchBar = Instance.new("TextBox")
    searchBar.Size = UDim2.new(0, 150, 0, 25)
    searchBar.Position = UDim2.new(0.3, 10, 0.5, -47.5)
    searchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    searchBar.Text = "Search..."
    searchBar.TextColor3 = Color3.fromRGB(150, 150, 150)
    searchBar.TextScaled = true
    searchBar.Font = Enum.Font.Gotham
    searchBar.ZIndex = 4
    searchBar.Parent = hatchFrame

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 10)
    searchCorner.Parent = searchBar

    local hatchInput = Instance.new("TextBox")
    hatchInput.Size = UDim2.new(0, 70, 0, 35)
    hatchInput.Position = UDim2.new(0.65, 0, 0.5, -17.5)
    hatchInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    hatchInput.Text = "1"
    hatchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    hatchInput.TextScaled = true
    hatchInput.Font = Enum.Font.Gotham
    hatchInput.ZIndex = 4
    hatchInput.Parent = hatchFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = hatchInput

    local hatchButton = Instance.new("TextButton")
    hatchButton.Size = UDim2.new(0, 70, 0, 35)
    hatchButton.Position = UDim2.new(1, -80, 0.5, -17.5)
    hatchButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    hatchButton.Text = "OFF"
    hatchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hatchButton.TextScaled = true
    hatchButton.Font = Enum.Font.GothamBold
    hatchButton.ZIndex = 4
    hatchButton.Parent = hatchFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = hatchButton

    -- Populate Dropdown
    local function populateDropdown(filter)
        for _, child in pairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, egg in pairs(eggList) do
            if not filter or string.find(string.lower(egg), string.lower(filter)) then
                local eggButton = Instance.new("TextButton")
                eggButton.Size = UDim2.new(1, 0, 0, 30)
                eggButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                eggButton.Text = egg
                eggButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                eggButton.TextScaled = true
                eggButton.Font = Enum.Font.Gotham
                eggButton.ZIndex = 6
                eggButton.Parent = scrollingFrame

                eggButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = egg
                    dropdownList.Visible = false
                end)
            end
        end
    end

    populateDropdown()

    -- Search Bar Logic
    searchBar.FocusLost:Connect(function()
        local filter = searchBar.Text == "Search..." and "" or searchBar.Text
        populateDropdown(filter)
    end)

    searchBar.Focused:Connect(function()
        if searchBar.Text == "Search..." then
            searchBar.Text = ""
            searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    searchBar.FocusLost:Connect(function()
        if searchBar.Text == "" then
            searchBar.Text = "Search..."
            searchBar.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)

    -- Dropdown Toggle
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    local isOn = false
    hatchButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            hatchButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            hatchButton.Text = "ON"
        else
            hatchButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            hatchButton.Text = "OFF"
        end
        callback(isOn, dropdownButton.Text, hatchInput.Text)
    end)
end

-- Function to Create Keybind Input UI
local function createKeybindInput(parent, name, position, defaultKey, callback)
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(1, -20, 0, 50)
    keyFrame.Position = position
    keyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    keyFrame.BorderSizePixel = 0
    keyFrame.ZIndex = 3
    keyFrame.Parent = parent

    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 10)
    keyCorner.Parent = keyFrame

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0.7, 0, 1, 0)
    keyLabel.Position = UDim2.new(0, 15, 0, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = name
    keyLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    keyLabel.TextScaled = true
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.ZIndex = 4
    keyLabel.Parent = keyFrame

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0, 70, 0, 35)
    keyInput.Position = UDim2.new(1, -80, 0.5, -17.5)
    keyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    keyInput.Text = defaultKey
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextScaled = true
    keyInput.Font = Enum.Font.Gotham
    keyInput.ZIndex = 4
    keyInput.Parent = keyFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = keyInput

    keyInput.FocusLost:Connect(function()
        callback(keyInput.Text:upper())
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

createToggle(mainTabContent, "Auto Ascend", UDim2.new(0, 10, 0, 70), function(state)
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

createToggleWithInput(mainTabContent, "Auto Rebirth", UDim2.new(0, 10, 0, 130), function(state, count)
    autoRebirth = state
    if autoRebirth then
        spawn(function()
            while autoRebirth and task.wait(1) do
                local event = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or
                              game:GetService("ReplicatedStorage"):FindFirstChild("RebirthEvent") or
                              (game:GetService("ReplicatedStorage"):FindFirstChild("Events") and game:GetService("ReplicatedStorage").Events:FindFirstChild("Rebirth"))
                if event then
                    local args = { [1] = count, [2] = "bROaINTGueSSIngAllThis1!!frfrfrfrfrfr" }
                    pcall(function()
                        event:FireServer(unpack(args))
                    end)
                end
            end
        end)
    end
end)

createHatchInputWithDropdown(mainTabContent, "Auto Hatch", UDim2.new(0, 10, 0, 190), function(state, selectedEgg, hatchCountText)
    autoHatch = state
    if autoHatch then
        spawn(function()
            while autoHatch and task.wait(0.5) do
                if selectedEgg == "Select Egg" then
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Error",
                        Text = "Please select an egg to hatch!",
                        Duration = 2
                    })
                    return
                end
                local hatchCount = tonumber(hatchCountText) or 1
                local hatchType = hatchCount > 1 and "Triple" or "Single"
                local args = { [1] = selectedEgg, [2] = hatchType }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Functions", 9e9):WaitForChild("Hatch", 9e9):InvokeServer(unpack(args))
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Hatching",
                        Text = "Hatching " .. selectedEgg .. " (" .. hatchType .. ")",
                        Duration = 2
                    })
                end)
            end
        end)
    end
end)

createToggle(mainTabContent, "Auto Craft", UDim2.new(0, 10, 0, 250), function(state)
    autoCraft = state
    if autoCraft then
        spawn(function()
            while autoCraft and task.wait(1) do
                local args = {
                    [1] = {
                        [1] = "D4o93yOe-9t080tfX-ji1NBrck",
                        [2] = "NKvnsGa4-O979u3YX-Q8d1Pe17",
                        [3] = "82dfxp6r-qE222dpH-WXH943K6",
                        [4] = "yj8l6eqN-cSf1swFx-2j71krh4",
                        [5] = "57eZ3KrT-iN86z5nw-1M7IdFD8"
                    }
                }
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Functions", 9e9):WaitForChild("CraftPet", 9e9):InvokeServer(unpack(args))
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Crafting",
                        Text = "Crafting pet with selected IDs!",
                        Duration = 2
                    })
                end)
            end
        end)
    end
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

-- Settings Tab: Keybind for closing UI
local closeKey = "E"
createKeybindInput(settingsTabContent, "Close UI Key", UDim2.new(0, 10, 0, 10), closeKey, function(newKey)
    closeKey = newKey
end)

-- Keybind Logic
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode[closeKey] then
        if mainFrame.Visible then
            mainFrame.Visible = false
            reopenButton.Visible = true
        else
            mainFrame.Visible = true
            reopenButton.Visible = false
        end
    end
end)

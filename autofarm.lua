local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Arguments for the case opening
local args = {
    [1] = "Free Case",
    [2] = false
}

-- Create UI with error handling
local function createUI()
    local success, errorMsg = pcall(function()
        local player = Players.LocalPlayer
        if not player then
            error("LocalPlayer not found")
        end

        local playerGui = player:WaitForChild("PlayerGui", 5) -- 5 second timeout
        if not playerGui then
            error("PlayerGui not found")
        end

        -- Create ScreenGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CaseOpenerUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui

        -- Create Frame
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 100)
        frame.Position = UDim2.new(0.5, -100, 0.5, -50)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.Parent = screenGui

        -- Create Button
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 150, 0, 50)
        toggleButton.Position = UDim2.new(0.5, -75, 0.5, -25)
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.Text = "Open Free Case"
        toggleButton.Parent = frame

        -- Button functionality with error handling
        local isProcessing = false
        toggleButton.MouseButton1Click:Connect(function()
            if isProcessing then return end
            
            local success, err = pcall(function()
                isProcessing = true
                toggleButton.Text = "Opening..."
                toggleButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)

                -- Get the remote event with error checking
                local remoteEvent = ReplicatedStorage:GetChildren()[25]
                if not remoteEvent then
                    error("Remote event not found at index 25")
                end

                -- Fire server with timeout
                local firedSuccessfully = false
                task.spawn(function()
                    remoteEvent:FireServer(unpack(args))
                    firedSuccessfully = true
                end)
                
                wait(2) -- Wait for server response
                if not firedSuccessfully then
                    error("Server request timed out")
                end

                -- Reset button
                toggleButton.Text = "Open Free Case"
                toggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
            end)

            if not success then
                warn("Error opening case: " .. err)
                toggleButton.Text = "Error - Try Again"
                toggleButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
                wait(1) -- Brief error display
                toggleButton.Text = "Open Free Case"
                toggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
            end
            
            isProcessing = false
        end)
    end)

    if not success then
        warn("UI Creation Failed: " .. errorMsg)
        -- Attempt to create a fallback UI or notification
        local player = Players.LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            local fallbackGui = Instance.new("ScreenGui")
            local errorText = Instance.new("TextLabel")
            errorText.Text = "Case Opener Failed to Load"
            errorText.Size = UDim2.new(0, 200, 0, 50)
            errorText.Parent = fallbackGui
            fallbackGui.Parent = player.PlayerGui
        end
    end
end

-- Initial execution with error handling
local success, err = pcall(function()
    createUI()
end)

if not success then
    warn("Script initialization failed: " .. err)
end

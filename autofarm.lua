-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

-- Configuration
local Config = {
    fastRoll = false,
    rollSpeed = 0.1, -- Default reduced timing (seconds)
    autoSkip = false,
    selectedEvent = "dd972176-2e1f-4aaa-9c5e-67ba5c3c3928" -- Default event (original roll event)
}

-- List of events from the screenshot
local AvailableEvents = {
    "cf8236e-c83e-4a2d-8079-924d2b860751a",
    "cf99c2cb-64d7-4508-b355-65e6d6f9004f",
    "d0161428-9333-41b1-82e7-d00c8cd920ee",
    "d4f6cd1d-428b-48a4-898b-ed4b3ece44b3",
    "d8a119c1-2423-4c1b-80cd-48361cd397bc",
    "dd972176-2e1f-4aaa-9c5e-67ba5c3c3928", -- Original event
    "e32a2177-aaa6-4699-af19-bf43b6e522f9",
    "e3db9a33-a8a4-402f-846d-bd51a242526e",
    "edd55bdf-21b5-46b0-81d6-482adeb4b3f5",
    "ef15c3ee-5951-44e2-a98b-f6555d7f2b4f",
    "f07760a7-76e8-416a-8a3d-683b520943ee",
    "f3d84ea0-f19e-4610-931e-85ad0f2dc0bd",
    "f3cfdl1f-479e-4f01-af7a-0b3673d651df",
    "f5de9eb1-d7fc-4620-84a9-d413ef493ffa",
    "00de3412-2b84-4a23-87e5-8ae9e407e80bc",
    "05c8f0d9-3837-46b8-8f18-00ede9263a94",
    "0b611611-0fdd-4564-84b1-d41315d841c",
    "0e4b7ae8-1008-464e-929e-74befbcc7f40",
    "19564aa6-af05-479e-b3d9-10af169f1044",
    "1f253790-781f-4456-a178-1c9afada5b95",
    "215254b9-e9da-4d03-8941-8be56a4d91a7",
    "241a8cb6-dff6-4009-940b-b805e00d97e",
    "2942f9ea-27ab-45ea-b510-d2dd5af730a5",
    "3b5b4c7a-1246-4163-86e1-765aea596ef0",
    "316431e-3674-4dde-99fd-6883960c71dd",
    "41d7a3bf-4307-4be1-a805-b6e642a7fdce",
    "44157352-2412-4152-be80-0705b387fcba",
    "48c56095-dc20-40ed-b9fd-2ecfaaa44442",
    "4c3d907d-3b30-493c-a19a-f04036e97fe7",
    "4e6ddee7-f02e-491a-89ee-6497ce1eebl8",
    "5c17ba6b-fa7a-432c-8526-0fb80a2bd885",
    "5e008b82-e8fc-46d7-ba37-8b8465316835",
    "644729dc-b8be-47c4-b5ff-ae29d96710c4",
    "66114460-9711-4b75-b2be-4bbd9d41e1b1",
    "7184edd5-ed92-4eb1-a677-f5425431a48b",
    "72dec57a-0d6a-4b51-8793-09402241be58"
}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Fast Roll",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FastRollConfig",
        FileName = "Config"
    },
    KeySystem = false
})

-- Create Main Tab
local MainTab = Window:CreateTab("Controls")

-- Function to fire a specific event
local function triggerEvent(eventId)
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("services"):WaitForChild("Network"):WaitForChild(eventId):FireServer()
    end)
    if success then
        print("Successfully triggered event: " .. eventId)
    else
        warn("Failed to trigger event " .. eventId .. ": " .. err)
    end
end

-- Override timing function
local function overrideTimings()
    local runtimeLib = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")
    local cardUnpackModule = require(runtimeLib):import(script, script.Parent.Parent, "card-unpack-ui")
    
    if cardUnpackModule and cardUnpackModule.CardUnpackUI then
        local original = cardUnpackModule.CardUnpackUI
        cardUnpackModule.CardUnpackUI = function()
            local result = original()
            -- Override timing table
            local v_u_22 = {
                playSound = Config.rollSpeed / 3,
                showCard = Config.rollSpeed / 2,
                hideCard = Config.rollSpeed
            }
            return result
        end
    end
end

-- UI Components
MainTab:CreateToggle({
    Name = "Enable Fast Roll",
    CurrentValue = Config.fastRoll,
    Flag = "FastRollToggle",
    Callback = function(Value)
        Config.fastRoll = Value
        if Value then
            overrideTimings()
        end
    end
})

MainTab:CreateSlider({
    Name = "Roll Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = Config.rollSpeed,
    Flag = "RollSpeed",
    Callback = function(Value)
        Config.rollSpeed = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto Skip Animations",
    CurrentValue = Config.autoSkip,
    Flag = "AutoSkipToggle",
    Callback = function(Value)
        Config.autoSkip = Value
    end
})

-- Dropdown to select which event to trigger
MainTab:CreateDropdown({
    Name = "Select Roll Event",
    Options = AvailableEvents,
    CurrentOption = Config.selectedEvent,
    Flag = "SelectedEvent",
    Callback = function(Option)
        Config.selectedEvent = Option
        print("Selected event: " .. Option)
    end
})

-- Main Loop
RunService.Heartbeat:Connect(function()
    if not Config.fastRoll then return end
    
    -- Trigger the selected event
    triggerEvent(Config.selectedEvent)
    
    -- Auto skip animations if enabled
    if Config.autoSkip then
        local instantRollUI = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("vide"):WaitForChild("src"):FindFirstChild("InstantRollUI")
        if instantRollUI then
            local screenData = require(ReplicatedStorage:WaitForChild("TS"):WaitForChild("states")).ScreenData
            if screenData and screenData().InstantRollQueue and #screenData().InstantRollQueue > 0 then
                -- Simulate SKIP_ALL
                local resultPage = instantRollUI:FindFirstChild("ResultPage")
                if resultPage and resultPage.OnFinished then
                    resultPage.OnFinished("SKIP_ALL")
                end
            end
        end
    end
    
    task.wait(Config.rollSpeed)
end)

-- Modify LocalUser settings
local LocalUser = require(ReplicatedStorage:WaitForChild("TS"):WaitForChild("user"):WaitForChild("local"):WaitForChild("local-user")).LocalUser
LocalUser.settings:set("QUICK_ROLL", true)
LocalUser.settings:set("AUTO_ROLL", true)
LocalUser.settings:set("QUICK_ROLL_PREVIEW", true)

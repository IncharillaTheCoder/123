-- Roblox Aimbot Script with Visual Indicator
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled = false
local aimbotKey = Enum.KeyCode.Q

-- Create visual indicator
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "AimbotIndicator"

local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0, 100, 0, 30)
indicator.Position = UDim2.new(0, 10, 0, 10)
indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
indicator.BorderSizePixel = 2
indicator.BorderColor3 = Color3.fromRGB(255, 255, 255)
indicator.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "AIMBOT: OFF"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Parent = indicator

-- Update indicator function
function updateIndicator()
    if aimbotEnabled then
        indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        label.Text = "AIMBOT: ON"
    else
        indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        label.Text = "AIMBOT: OFF"
    end
end

-- Toggle aimbot with Q key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == aimbotKey then
        aimbotEnabled = not aimbotEnabled
        updateIndicator()
        print("Aimbot: " .. (aimbotEnabled and "ENABLED" or "DISABLED"))
    end
end)

-- Find closest player to crosshair
function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local currentCamera = workspace.CurrentCamera
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            
            if humanoidRootPart and head then
                local screenPoint, visible = currentCamera:WorldToScreenPoint(head.Position)
                
                if visible then
                    local mouseLocation = Vector2.new(Mouse.X, Mouse.Y)
                    local targetLocation = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mouseLocation - targetLocation).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aimbot logic
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local targetPlayer = getClosestPlayer()
        
        if targetPlayer and targetPlayer.Character then
            local character = targetPlayer.Character
            local head = character:FindFirstChild("Head")
            
            if head then
                local currentCamera = workspace.CurrentCamera
                currentCamera.CFrame = CFrame.lookAt(currentCamera.CFrame.Position, head.Position)
            end
        end
    end
end)

-- Initialize indicator
updateIndicator()

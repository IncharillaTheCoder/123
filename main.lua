-- Roblox Aimbot Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled = false
local aimbotKey = Enum.KeyCode.Q

-- Toggle aimbot with Q key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == aimbotKey then
        aimbotEnabled = not aimbotEnabled
        print("Aimbot: " .. (aimbotEnabled and "ENABLED" or "DISABLED"))
    end
end)

-- Find closest player to crosshair
local function getClosestPlayer()
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

print("Aimbot script loaded. Press Q to toggle.")

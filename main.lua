-- Enhanced Movement Script
local Player = game:GetService("Players").LocalPlayer
local Character = Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local FlySpeed = 50
local Noclip = false
local Flying = false

local Controls = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

-- Noclip function
local function NoclipLoop()
    if Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end

-- Fly function
local function Fly()
    local BodyGyro = Instance.new("BodyGyro")
    local BodyVelocity = Instance.new("BodyVelocity")
    
    BodyGyro.Parent = HumanoidRootPart
    BodyVelocity.Parent = HumanoidRootPart
    
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = HumanoidRootPart.CFrame
    
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    Flying = true
    
    spawn(function()
        repeat wait()
            if not Flying then break end
            
            if Controls.Left then
                BodyVelocity.velocity = BodyGyro.cframe:VectorToWorldSpace(Vector3.new(-FlySpeed, 0, 0))
            elseif Controls.Right then
                BodyVelocity.velocity = BodyGyro.cframe:VectorToWorldSpace(Vector3.new(FlySpeed, 0, 0))
            end
            
            if Controls.Forward then
                BodyVelocity.velocity = BodyGyro.cframe:VectorToWorldSpace(Vector3.new(0, 0, -FlySpeed))
            elseif Controls.Backward then
                BodyVelocity.velocity = BodyGyro.cframe:VectorToWorldSpace(Vector3.new(0, 0, FlySpeed))
            end
            
            if Controls.Up then
                BodyVelocity.velocity = BodyGyro.cframe:VectorToWorldSpace(Vector3.new(0, FlySpeed, 0))
            elseif Controls.Down then
                BodyVelocity.velocity = BodyGyro.cframe:VectorToWorldSpace(Vector3.new(0, -FlySpeed, 0))
            end
            
            BodyGyro.cframe = Workspace.CurrentCamera.CoordinateFrame
        until not Flying
        
        BodyGyro:Destroy()
        BodyVelocity:Destroy()
    end)
end

-- Input handling
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        Flying = not Flying
        if Flying then
            Fly()
        end
    elseif input.KeyCode == Enum.KeyCode.N then
        Noclip = not Noclip
        if Noclip then
            spawn(function()
                while Noclip do
                    NoclipLoop()
                    wait(0.1)
                end
            end)
        end
    elseif input.KeyCode == Enum.KeyCode.W then
        Controls.Forward = true
    elseif input.KeyCode == Enum.KeyCode.S then
        Controls.Backward = true
    elseif input.KeyCode == Enum.KeyCode.A then
        Controls.Left = true
    elseif input.KeyCode == Enum.KeyCode.D then
        Controls.Right = true
    elseif input.KeyCode == Enum.KeyCode.Space then
        Controls.Up = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        Controls.Down = true
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.W then
        Controls.Forward = false
    elseif input.KeyCode == Enum.KeyCode.S then
        Controls.Backward = false
    elseif input.KeyCode == Enum.KeyCode.A then
        Controls.Left = false
    elseif input.KeyCode == Enum.KeyCode.D then
        Controls.Right = false
    elseif input.KeyCode == Enum.KeyCode.Space then
        Controls.Up = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        Controls.Down = false
    end
end)

-- Noclip loop
spawn(function()
    while true do
        if Noclip then
            NoclipLoop()
        end
        wait(0.1)
    end
end)

print("Movement controls loaded!")
print("F - Toggle Fly")
print("N - Toggle Noclip")
print("WASD - Move")
print("Space - Ascend")
print("Shift - Descend")

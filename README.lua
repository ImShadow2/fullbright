--# fullbright
--this is not mine
-- Fullbright with F1 toggle | Optimized for Executors
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local fullbrightEnabled = false
local connection
local lightInstance

local function applyFullbright()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 1
    Lighting.FogEnd = 1e10
end

local function enableFullbright()
    fullbrightEnabled = true
    applyFullbright()

    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
        end
    end

    if not connection then
        connection = Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
            if fullbrightEnabled then
                applyFullbright()
            end
        end)
    end

    task.spawn(function()
        while fullbrightEnabled do
            task.wait(1)
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") and not character.HumanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                lightInstance = Instance.new("PointLight", character.HumanoidRootPart)
                lightInstance.Brightness = 1
                lightInstance.Range = 60
            end
        end
    end)
end

local function disableFullbright()
    fullbrightEnabled = false
    Lighting.Ambient = Color3.new(0, 0, 0)
    Lighting.Brightness = 1
    Lighting.FogEnd = 1000

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if lightInstance then
        lightInstance:Destroy()
        lightInstance = nil
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F1 then
        if fullbrightEnabled then
            disableFullbright()
            warn("Fullbright disabled")
        else
            enableFullbright()
            warn("Fullbright enabled")
        end
    end
end)

-- [[
--  WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
--]]

local targetHeight = 8 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 1. Загружаем модель Сахура
local Object = game:GetObjects("rbxassetid://137189209569355")[1]
Object.Parent = workspace

-- 2. Масштабируем модель под размер 8
task.wait(0.2)
local cf, size = Object:GetBoundingBox()
if size.Y > 0 then
    local scaleFactor = targetHeight / size.Y
    if Object:IsA("Model") then
        Object:ScaleTo(scaleFactor)
    elseif Object:IsA("BasePart") then
        Object.Size = Object.Size * scaleFactor
    end
end

-- Пересчитываем размер после масштабирования
local _, scaledSize = Object:GetBoundingBox()
local modelHeight = scaledSize.Y

-- Удаляем Humanoid у Сахура
local modelHumanoid = Object:FindFirstChildOfClass("Humanoid")
if modelHumanoid then
    modelHumanoid:Destroy()
end

-- 3. ТЕБЕ ВКЛЮЧАЕМ КОЛЛИЗИЮ ТОЛЬКО НА ROOTPART
for _, part in ipairs(character:GetDescendants()) do
    if part:IsA("BasePart") or part:IsA("MeshPart") then
        part.Transparency = 1
        if part.Name ~= "HumanoidRootPart" then
            part.CanCollide = false
        end
    elseif part:IsA("Decal") then
        part.Transparency = 1
    end
end

humanoidRootPart.CanCollide = true 
humanoidRootPart.Transparency = 1

for _, child in ipairs(character:GetChildren()) do
    if child:IsA("Accessory") then
        for _, p in ipairs(child:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Transparency = 1
                p.CanCollide = false
            end
        end
    end
end

-- 4. САХУРУ ОТКЛЮЧАЕМ КОЛЛИЗИЮ ПОЛНОСТЬЮ
for _, part in ipairs(Object:GetDescendants()) do
    if part:IsA("BasePart") then
        part.CanCollide = false
        part.Anchored = false
    end
end

-- 5. Синхронизируем положение (подняли еще на столько же, коэффициент стал 0.7)
local connection
connection = RunService.RenderStepped:Connect(function()
    if not character or not character.Parent or not humanoidRootPart or not humanoidRootPart.Parent then
        if Object then Object:Destroy() end
        if connection then connection:Disconnect() end
        return
    end
    
    local charCFrame = character:GetPivot()
    
    -- Было 0.85, поднимаем еще выше (уменьшаем коэффициент до 0.7)
    local loweredCFrame = charCFrame + Vector3.new(0, -modelHeight * 0.7, 0)
    
    Object:PivotTo(loweredCFrame)
end)

character.Humanoid.Died:Connect(function()
    if Object then Object:Destroy() end
    if connection then connection:Disconnect() end
end)


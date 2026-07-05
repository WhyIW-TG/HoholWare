-- ========================================================================
-- ENGINE V3: DYNAMIC SLOTS SYSTEM WITH SLIDERS & DROPDOWNS (MOBILE)
-- ========================================================================

if game.CoreGui:FindFirstChild("HvH_Private_Menu") then
    game.CoreGui["HvH_Private_Menu"]:Destroy()
end
-- Очистка старых ESP при переключении тем или перезапуске
if getgenv().ESP_Cache then
    for _, drawingElement in ipairs(getgenv().ESP_Cache) do
        pcall(function()
            drawingElement.Visible = false
            drawingElement:Remove()
        end)
    end
end
getgenv().ESP_Cache = {}


getgenv().Config = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HvH_Private_Menu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 80, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0.05, 0) -- Чуть выше середины
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "Закрыть"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamMedium
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ToggleButton).Color = Color3.fromRGB(50, 50, 50)

-- 2. ТВОЕ МЕНЮ (MAIN FRAME)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Size = UDim2.new(0, 600, 0, 380)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(165, 30, 255) -- Твой фиолетовый неон
ToggleStroke.Thickness = 2 

-- 3. ЛОГИКА ОТКРЫТИЯ/ЗАКРЫТИЯ
local isOpen = true
ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
    ToggleButton.Text = isOpen and "Закрыть" or "Открыть"
end)

local LeftPanel = Instance.new("Frame")
LeftPanel.Parent = MainFrame
LeftPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
LeftPanel.Size = UDim2.new(0, 140, 1, 0)
LeftPanel.BorderSizePixel = 0

local TabContainer = Instance.new("Frame")
TabContainer.Parent = LeftPanel
TabContainer.Size = UDim2.new(1, 0, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
TabContainer.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local ContentPanel = Instance.new("Frame")
ContentPanel.Parent = MainFrame
ContentPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
ContentPanel.Position = UDim2.new(0, 145, 0, 10)
ContentPanel.Size = UDim2.new(1, -155, 1, -20)
ContentPanel.BorderSizePixel = 0

local ScrollContent = Instance.new("ScrollingFrame")
ScrollContent.Parent = ContentPanel
ScrollContent.Size = UDim2.new(1, 0, 1, 0)
ScrollContent.BackgroundTransparency = 1
ScrollContent.BorderSizePixel = 0
ScrollContent.ScrollBarThickness = 4
ScrollContent.CanvasSize = UDim2.new(0, 0, 0, 0)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ScrollContent
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
end)

local Title = Instance.new("TextLabel")
Title.Parent = LeftPanel
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Empaxis Beta"
Title.TextColor3 = Color3.fromRGB(165, 30, 255) -- Фиолетовый неон для текста названия
Title.Font = Enum.Font.GothamBold
Title.FontSize = Enum.FontSize.Size18
Title.BackgroundTransparency = 1

local CreatedTabs = {}
local RegisteredElements = {}

local function CreateTabButton(tabName)
    if CreatedTabs[tabName] then return end
    CreatedTabs[tabName] = true
    RegisteredElements[tabName] = {}

    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab_" .. tabName
    TabButton.Parent = TabContainer
    TabButton.Size = UDim2.new(1, -10, 0, 32)
    TabButton.Position = UDim2.new(0, 5, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    TabButton.Text = "  " .. tabName
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.FontSize = Enum.FontSize.Size14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = TabButton

    TabButton.MouseButton1Click:Connect(function()
        for _, btn in ipairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        TabButton.TextColor3 = Color3.fromRGB(165, 30, 255) -- Фиолетовый неон при клике
        
        for _, obj in ipairs(ScrollContent:GetChildren()) do
            if obj:IsA("Frame") then obj.Parent = nil end
        end
        
        if RegisteredElements[tabName] then
            for _, frame in ipairs(RegisteredElements[tabName]) do
                frame.Parent = ScrollContent
                frame.Visible = true
            end
        end
    end)
end

local function BuildCheckbox(tabName, optionName)
    getgenv().Config[optionName] = false
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Frame.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = optionName
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.FontSize = Enum.FontSize.Size14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Button = Instance.new("TextButton")
    Button.Parent = Frame
    Button.Position = UDim2.new(1, -50, 0, 7)
    Button.Size = UDim2.new(0, 40, 0, 20)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Button.Text = ""
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = Button

    local Indicator = Instance.new("Frame")
    Indicator.Parent = Button
    Indicator.Position = UDim2.new(0, 2, 0, 2)
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(0, 8)
    IndCorner.Parent = Indicator

    Button.MouseButton1Click:Connect(function()
        getgenv().Config[optionName] = not getgenv().Config[optionName]
        if getgenv().Config[optionName] then
            Indicator:TweenPosition(UDim2.new(1, -18, 0, 2), "Out", "Quad", 0.15, true)
            Indicator.BackgroundColor3 = Color3.fromRGB(165, 30, 255) -- Фиолетовый неон при включении
        else
            Indicator:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.15, true)
            Indicator.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        end
    end)

    table.insert(RegisteredElements[tabName], Frame)
end

local function BuildSlider(tabName, optionName, min, max, default)
    getgenv().Config[optionName] = default
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Frame.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.Size = UDim2.new(0.6, 0, 0, 18)
    Label.Text = optionName
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.FontSize = Enum.FontSize.Size14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = Frame
    ValueLabel.Position = UDim2.new(1, -60, 0, 4)
    ValueLabel.Size = UDim2.new(0, 50, 0, 18)
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(165, 30, 255) -- Фиолетовый текст значения
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.FontSize = Enum.FontSize.Size14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.BackgroundTransparency = 1

    local SliderBg = Instance.new("TextButton")
    SliderBg.Parent = Frame
    SliderBg.Position = UDim2.new(0, 10, 0, 26)
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    SliderBg.Text = ""
    SliderBg.AutoButtonColor = false
    local SliderBgCorner = Instance.new("UICorner")
    SliderBgCorner.CornerRadius = UDim.new(0, 3)
    SliderBgCorner.Parent = SliderBg

    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBg
    SliderFill.BackgroundColor3 = Color3.fromRGB(165, 30, 255) -- Фиолетовая шкала слайдера
    local percent = (default - min) / (max - min)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderFill.BorderSizePixel = 0
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 3)
    SliderFillCorner.Parent = SliderFill

    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        getgenv().Config[optionName] = val
        ValueLabel.Text = tostring(val)
    end

    local sliding = false
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            update(input)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    table.insert(RegisteredElements[tabName], Frame)
end

local function BuildDropdown(tabName, optionName, items)
    getgenv().Config[optionName] = items[1]
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Frame.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Text = optionName
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.FontSize = Enum.FontSize.Size14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Parent = Frame
    DropdownBtn.Position = UDim2.new(1, -130, 0, 5)
    DropdownBtn.Size = UDim2.new(0, 120, 0, 25)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    DropdownBtn.Text = items[1] .. " ▼"
    DropdownBtn.TextColor3 = Color3.fromRGB(165, 30, 255) -- Фиолетовый текст кнопки дропдауна
    DropdownBtn.Font = Enum.Font.GothamBold
    DropdownBtn.FontSize = Enum.FontSize.Size12
    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 4)
    DropCorner.Parent = DropdownBtn

    local DropListFrame = Instance.new("Frame")
    DropListFrame.Size = UDim2.new(0, 120, 0, #items * 25)
    DropListFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    DropListFrame.BorderColor3 = Color3.fromRGB(165, 30, 255) -- Фиолетовая рамка списка элементов
    DropListFrame.Visible = false
    DropListFrame.ZIndex = 10

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropListFrame

    for _, itemName in ipairs(items) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Size = UDim2.new(1, 0, 0, 25)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        ItemBtn.Text = itemName
        ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        ItemBtn.Font = Enum.Font.Gotham
        ItemBtn.FontSize = Enum.FontSize.Size12
        ItemBtn.ZIndex = 10
        ItemBtn.Parent = DropListFrame

        ItemBtn.MouseButton1Click:Connect(function()
            getgenv().Config[optionName] = itemName
            DropdownBtn.Text = itemName .. " ▼"
            DropListFrame.Visible = false
            DropListFrame.Parent = nil
        end)
    end

    DropdownBtn.MouseButton1Click:Connect(function()
        if DropListFrame.Visible then
            DropListFrame.Visible = false
            DropListFrame.Parent = nil
        else
            DropListFrame.Parent = ScreenGui
            DropListFrame.Position = UDim2.new(0, DropdownBtn.AbsolutePosition.X, 0, DropdownBtn.AbsolutePosition.Y + 28)
            DropListFrame.Visible = true
        end
    end)

    table.insert(RegisteredElements[tabName], Frame)
end

local Slots = {
    ["ESP_Master"] = function()
        if not getgenv().ESP_Cache then getgenv().ESP_Cache = {} end
        
        -- Функция полной очистки кэша
        getgenv().ClearOldESP = function()
            if getgenv().ESP_Connection then getgenv().ESP_Connection:Disconnect() getgenv().ESP_Connection = nil end
            for _, pData in pairs(getgenv().ESP_Cache) do
                pcall(function() pData.Box:Remove() end)
                pcall(function() pData.Fill:Remove() end)
                pcall(function() pData.Bar:Remove() end)
                pcall(function() pData.Text:Remove() end)
                pcall(function() pData.Line:Remove() end)
            end
            getgenv().ESP_Cache = {}
        end
        getgenv().ClearOldESP()

        local function RemovePlayerESP(player)
            local pData = getgenv().ESP_Cache[player]
            if pData then
                pcall(function() pData.Box:Remove() end)
                pcall(function() pData.Fill:Remove() end)
                pcall(function() pData.Bar:Remove() end)
                pcall(function() pData.Text:Remove() end)
                pcall(function() pData.Line:Remove() end)
                getgenv().ESP_Cache[player] = nil
            end
        end

        local function CreatePlayerESP(player)
            if player == game.Players.LocalPlayer then return end
            if getgenv().ESP_Cache[player] then return end

            local pData = {
                Box = Drawing.new("Square"),
                Fill = Drawing.new("Square"),
                Bar = Drawing.new("Line"),
                Text = Drawing.new("Text"),
                Line = Drawing.new("Line")
            }

            -- Настройки по умолчанию
            pData.Box.Color = Color3.fromRGB(165, 30, 255)
            pData.Box.Thickness = 2
            pData.Box.Filled = false
            pData.Box.Visible = false

            pData.Fill.Color = Color3.fromRGB(165, 30, 255)
            pData.Fill.Thickness = 0
            pData.Fill.Filled = true
            pData.Fill.Transparency = 0.25
            pData.Fill.Visible = false

            pData.Bar.Thickness = 2
            pData.Bar.Visible = false

            pData.Text.Color = Color3.fromRGB(255, 255, 255)
            pData.Text.Size = 16
            pData.Text.Center = true
            pData.Text.Outline = true
            pData.Text.OutlineColor = Color3.fromRGB(0, 0, 0)
            pData.Text.Visible = false

            pData.Line.Color = Color3.fromRGB(165, 30, 255)
            pData.Line.Thickness = 1.5
            pData.Line.Visible = false

            getgenv().ESP_Cache[player] = pData
        end

        -- Инициализация игроков
        for _, p in ipairs(game.Players:GetPlayers()) do CreatePlayerESP(p) end
        game.Players.PlayerAdded:Connect(CreatePlayerESP)
        game.Players.PlayerRemoving:Connect(RemovePlayerESP)

        -- ОДИН ЕДИНСТВЕННЫЙ ОПТИМИЗИРОВАННЫЙ ЦИКЛ НА ВСЕХ
        local Camera = game.Workspace.CurrentCamera
        getgenv().ESP_Connection = game:GetService("RunService").RenderStepped:Connect(function()
            local cfg = getgenv().Config
            local localChar = game.Players.LocalPlayer.Character

            for player, pData in pairs(getgenv().ESP_Cache) do
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum.Health > 0 then
                        local rhrp = char.HumanoidRootPart
                        local vector, onScreen = Camera:WorldToViewportPoint(rhrp.Position)

                        if onScreen then
                            local zDistance = vector.Z
                            local sizeX = 1600 / zDistance
                            local sizeY = 2400 / zDistance
                            local posX = vector.X - sizeX / 2
                            local posY = vector.Y - sizeY / 2

                            -- 1. BOX ESP
                            if cfg["Box"] then
                                pData.Box.Size = Vector2.new(sizeX, sizeY)
                                pData.Box.Position = Vector2.new(posX, posY)
                                pData.Box.Visible = true
                            else pData.Box.Visible = false end

                            -- 2. FILL BOX ESP
                            if cfg["FillBox"] then
                                pData.Fill.Size = Vector2.new(sizeX, sizeY)
                                pData.Fill.Position = Vector2.new(posX, posY)
                                pData.Fill.Visible = true
                            else pData.Fill.Visible = false end

                            -- 3. HEALTHBAR ESP
                            if cfg["HealthBar"] then
                                local healthPercent = hum.Health / hum.MaxHealth
                                local barHeight = sizeY * healthPercent
                                local boxBottomY = vector.Y + sizeY / 2

                                if cfg["GradientHP"] then
                                    pData.Bar.Color = Color3.fromHSV(healthPercent * 0.33, 1, 1)
                                else
                                    pData.Bar.Color = Color3.fromRGB(0, 255, 0)
                                end
                                pData.Bar.From = Vector2.new(posX - 5, boxBottomY)
                                pData.Bar.To = Vector2.new(posX - 5, boxBottomY - barHeight)
                                pData.Bar.Visible = true
                            else pData.Bar.Visible = false end

                            -- 4. NAME ESP
                            if cfg["Name"] then
                                local sizeYName = 3000 / zDistance
                                pData.Text.Position = Vector2.new(vector.X, (vector.Y - sizeYName / 2) - 20)
                                pData.Text.Text = player.Name
                                pData.Text.Visible = true
                            else pData.Text.Visible = false end

                            -- 5. TRACERS ESP
                            if cfg["Tracers"] then
                                pData.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                pData.Line.To = Vector2.new(vector.X, vector.Y)
                                pData.Line.Visible = true
                            else pData.Line.Visible = false end

                        else
                            -- Игрок за экраном
                            pData.Box.Visible = false pData.Fill.Visible = false
                            pData.Bar.Visible = false pData.Text.Visible = false pData.Line.Visible = false
                        end
                    else
                        -- Игрок мертв
                        pData.Box.Visible = false pData.Fill.Visible = false
                        pData.Bar.Visible = false pData.Text.Visible = false pData.Line.Visible = false
                    end
                else
                    -- Персонаж не загружен
                    pData.Box.Visible = false pData.Fill.Visible = false
                    pData.Bar.Visible = false pData.Text.Visible = false pData.Line.Visible = false
                end
            end
        end)
    end,

    ["ESP_Box"] = function() end,
    ["ESP_FillBox"] = function() end,
    ["ESP_HealthBar"] = function() end,
    ["ESP_GradientHP"] = function() end,
    ["ESP_Name"] = function() end,
    ["ESP_Tracers"] = function() end,

    ["AIM_Aimbot"] = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local RunService = game:GetService("RunService")
        
        local FOVCircle = Drawing.new("Circle")
        FOVCircle.Color = Color3.fromRGB(165, 30, 255)
        FOVCircle.Thickness = 1.5
        FOVCircle.Filled = false
        FOVCircle.Transparency = 0.7
        FOVCircle.Visible = false

        local function IsVisible(character, targetPart)
            if not getgenv().Config["Visible"] then return true end 
            local parts = Camera:GetPartsObscuringTarget({targetPart.Position}, {LocalPlayer.Character, character})
            return #parts == 0
        end

        local function GetClosestTarget()
            local closestTarget = nil
            local maxDistance = getgenv().Config["AimRadius"] or 100
            local selectedOption = getgenv().Config["Hitbox"] or "Head"

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local targetPart = player.Character:FindFirstChild(selectedOption) or player.Character:FindFirstChild("HumanoidRootPart")
                    
                    if targetPart then
                        local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                            
                            if distance < maxDistance and IsVisible(player.Character, targetPart) then
                                maxDistance = distance
                                closestTarget = targetPart
                            end
                        end
                    end
                end
            end
            return closestTarget
        end

        RunService.RenderStepped:Connect(function()
            if getgenv().Config["ShowFOV"] and getgenv().Config["AimRadius"] then
                FOVCircle.Radius = getgenv().Config["AimRadius"]
                FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                FOVCircle.Visible = true
            else
                FOVCircle.Visible = false 
            end

            if not getgenv().Config["Aimbot"] then return end

            local targetPart = GetClosestTarget()
            if targetPart then
                local smoothness = (getgenv().Config["Smoothness"] or 5) / 10
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
            end
        end)
    end,

    ["AIM_Hitbox"]     = function() end,
    ["AIM_AimRadius"]        = function() end,
    ["AIM_Visible"]    = function() end,
    ["AIM_Smoothness"] = function() end,
    ["MOVEMENT_BunnyHop"] = function()
        local RunService = game:GetService("RunService")
        local LocalPlayer = game.Players.LocalPlayer
        
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if not getgenv().Config["BunnyHop"] then return end
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                local hrp = char.HumanoidRootPart
                
                if hum:GetState() == Enum.HumanoidStateType.Freefall then
                    local maxLimit = getgenv().Config["BhopMax"] or 100
                    local moveDir = hum.MoveDirection
                    
                    if moveDir.Magnitude > 0 then
                        local currentVel = hrp.Velocity
                        hrp.Velocity = Vector3.new(
                            moveDir.X * maxLimit * 0.5, 
                            currentVel.Y, 
                            moveDir.Z * maxLimit * 0.5
                        )
                    end
                end
            end
        end)
    end,

    ["MOVEMENT_MoonJump"] = function()
        local RunService = game:GetService("RunService")
        local LocalPlayer = game.Players.LocalPlayer
        local Workspace = game:GetService("Workspace")
        local normalGravity = 196.2
        local moonGravity = 80 

        RunService.RenderStepped:Connect(function()
            if not getgenv().Config["MoonJump"] then 
                if Workspace.Gravity ~= normalGravity then Workspace.Gravity = normalGravity end
                return 
            end
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                if hum.FloorMaterial == Enum.Material.Air then
                    Workspace.Gravity = moonGravity
                else
                    Workspace.Gravity = normalGravity
                end
            end
        end)
        LocalPlayer.CharacterRemoving:Connect(function() Workspace.Gravity = normalGravity end)
    end,

    ["VISUALS_SelfChams"] = function()
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer

        -- Кэш для сохранения оригинального вида персонажа
        local originalMaterials = {}
        local originalColors = {}
        local originalTextures = {}

        local ForceFieldColor = Color3.fromRGB(255, 255, 255) -- Белый акцент

        -- Функция для сохранения оригинального состояния деталей
        local function backupPart(part)
            if not originalMaterials[part] then
                originalMaterials[part] = part.Material
                originalColors[part] = part.Color
                
                local mesh = part:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    originalTextures[part] = mesh.TextureId
                end
            end
        end

        RunService.RenderStepped:Connect(function()
            local char = lp.Character
            if not char then return end

            -- ЕСЛИ ЧИТ ВКЛЮЧЕН В МЕНЮ
            if getgenv().Config["SelfChams"] then
                
                -- Функция применения ForceField
                local function applyFF(part)
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        backupPart(part) -- Сохраняем оригинал перед изменением
                        
                        part.Material = Enum.Material.ForceField
                        part.Color = ForceFieldColor
                        
                        local mesh = part:FindFirstChildOfClass("SpecialMesh")
                        if mesh then
                            mesh.TextureId = "" -- Очищаем текстуру одежды/волос
                        end
                    end
                end

                -- Обрабатываем тело и аксессуары
                for _, child in ipairs(char:GetChildren()) do
                    applyFF(child)
                    if child:IsA("Accessory") then
                        local handle = child:FindFirstChild("Handle")
                        if handle then applyFF(handle) end
                    end
                end

                -- Скрываем 2D декали (лицо, принты на футболках), чтобы не баговали
                for _, decal in ipairs(char:GetDescendants()) do
                    if decal:IsA("Decal") or decal:IsA("Texture") then
                        decal.Transparency = 1
                    end
                end

                -- Создаем сквозной рентген-эффект (Highlight)
                if not char:FindFirstChild("My_FF_XRay") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "My_FF_XRay"
                    hl.FillColor = ForceFieldColor
                    hl.FillTransparency = 0.99
                    hl.OutlineTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Adornee = char
                    hl.Parent = char
                end

            -- ЕСЛИ ЧИТ ВЫКЛЮЧЕН В МЕНЮ (Возвращаем все как было)
            else
                if char:FindFirstChild("My_FF_XRay") then 
                    char.My_FF_XRay:Destroy() 
                end

                for part, mat in pairs(originalMaterials) do
                    if part and part.Parent then
                        part.Material = mat
                        part.Color = originalColors[part]
                        
                        local mesh = part:FindFirstChildOfClass("SpecialMesh")
                        if mesh and originalTextures[part] then
                            mesh.TextureId = originalTextures[part] -- Возвращаем волосы/одежду
                        end
                    end
                end
                
                -- Возвращаем видимость лицу и деталям
                for _, decal in ipairs(char:GetDescendants()) do
                    if (decal:IsA("Decal") or decal:IsA("Texture")) and decal.Name ~= "HumanoidRootPart" then
                        decal.Transparency = 0
                    end
                end
                
                -- Очищаем таблицы кэша, если выключили функцию
                table.clear(originalMaterials)
                table.clear(originalColors)
                table.clear(originalTextures)
            end
        end)

        -- Сброс кэша при респавне, чтобы не было багов с новыми шмотками
        lp.CharacterAdded:Connect(function()
            table.clear(originalMaterials)
            table.clear(originalColors)
            table.clear(originalTextures)
        end)
    end,

    ["VISUALS_ThirdPerson"] = function()
        local RunService = game:GetService("RunService")
        local LocalPlayer = game.Players.LocalPlayer
        
        RunService.RenderStepped:Connect(function()
            if getgenv().Config["ThirdPerson"] then
                local distance = getgenv().Config["Distance"] or 25
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
                LocalPlayer.CameraMaxZoomDistance = distance
                LocalPlayer.CameraMinZoomDistance = distance
            else
                if LocalPlayer.CameraMaxZoomDistance == (getgenv().Config["Distance"] or 25) then
                    LocalPlayer.CameraMaxZoomDistance = 128
                    LocalPlayer.CameraMinZoomDistance = 0.5
                end
            end
        end)
    end,

    ["VISUALS_Distance"] = function() end,
    ["VISUALS_KillStreak"] = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local TweenService = game:GetService("TweenService")
        local lp = Players.LocalPlayer

        -- Переменные логики киллстрика
        local currentStreak = 0
        local lastKillTime = 0
        local comboDuration = 3 -- Время комбо (3 секунды)
        
        -- Таблица для хранения истории прицеливания (буфер на 0.4 секунды)
        local aimHistory = {}
        local historyWindow = 0.4 -- Окно задержки из-за интернета

        -- Создаем графический интерфейс для счетчика (Локально)
        local StreakGui = Instance.new("ScreenGui")
        StreakGui.Name = "KillStreak_Display"
        StreakGui.Parent = game.CoreGui
        StreakGui.ResetOnSpawn = false

        -- Главный контейнер (СМЕЩЕН В САМЫЙ НИЗ ЭКРАНА - 85% высоты)
        local MainBox = Instance.new("Frame")
        MainBox.Size = UDim2.new(0, 200, 0, 26)
        MainBox.Position = UDim2.new(0.5, -100, 0, workspace.CurrentCamera.ViewportSize.Y * 0.67)
        MainBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        MainBox.BackgroundTransparency = 1 -- По умолчанию скрыто
        MainBox.BorderSizePixel = 0
        MainBox.Parent = StreakGui
        local BoxCorner = Instance.new("UICorner", MainBox)
        BoxCorner.CornerRadius = UDim.new(0, 4)

        -- Фон полоски времени
        local BarBackground = Instance.new("Frame")
        BarBackground.Size = UDim2.new(0, 140, 0, 3) -- СДЕЛАНА ПОТОНЬШЕ (3 пикселя)
        BarBackground.Position = UDim2.new(0, 10, 0, 18)
        BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        BarBackground.BackgroundTransparency = 1
        BarBackground.BorderSizePixel = 0
        BarBackground.Parent = MainBox
        local BarBgCorner = Instance.new("UICorner", BarBackground)
        BarBgCorner.CornerRadius = UDim.new(0, 2)

        -- Сама тающая линия
        local ProgressBar = Instance.new("Frame")
        ProgressBar.Size = UDim2.new(1, 0, 1, 0)
        ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
        ProgressBar.BackgroundTransparency = 1
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Parent = BarBackground
        local BarCorner = Instance.new("UICorner", ProgressBar)
        BarCorner.CornerRadius = UDim.new(0, 2)

        -- Текст названия "STREAK"
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(0, 140, 0, 16)
        TitleLabel.Position = UDim2.new(0, 10, 0, 1)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = "COMBО STREAK"
        TitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        TitleLabel.TextTransparency = 1
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.TextSize = 11
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = MainBox

        -- Цифра счётчика убийств (справа)
        local CountLabel = Instance.new("TextLabel")
        CountLabel.Size = UDim2.new(0, 40, 0, 26)
        CountLabel.Position = UDim2.new(0, 155, 0, 0)
        CountLabel.BackgroundTransparency = 1
        CountLabel.Text = "0"
        CountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        CountLabel.TextTransparency = 1
        CountLabel.Font = Enum.Font.SourceSansBold
        CountLabel.TextSize = 22
        CountLabel.TextXAlignment = Enum.TextXAlignment.Center
        CountLabel.Parent = MainBox

        -- Анимация появления и таяния линии
        local activeTween = nil
        local function triggerKillVisuals()
            MainBox.BackgroundTransparency = 0.25
            BarBackground.BackgroundTransparency = 0
            ProgressBar.BackgroundTransparency = 0
            TitleLabel.TextTransparency = 0
            CountLabel.TextTransparency = 0
            
            CountLabel.Text = tostring(currentStreak)
            ProgressBar.Size = UDim2.new(1, 0, 1, 0)

            if activeTween then activeTween:Cancel() end

            local tweenInfo = TweenInfo.new(comboDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            activeTween = TweenService:Create(ProgressBar, tweenInfo, {Size = UDim2.new(0, 0, 1, 0)})
            activeTween:Play()
        end

        -- Плавное растворение счетчика
        local function fadeOutVisuals()
            currentStreak = 0
            local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            TweenService:Create(MainBox, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(BarBackground, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(ProgressBar, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(TitleLabel, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(CountLabel, fadeInfo, {TextTransparency = 1}):Play()
        end

        -- Постоянно записываем историю того, куда мы смотрели
        RunService.RenderStepped:Connect(function()
            if not getgenv().Config["KillStreak"] then return end
            
            local camera = workspace.CurrentCamera
            local currentTime = tick()
            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            
            -- Проверяем всех игроков и сохраняем их экранные позиции в историю
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= lp and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    local vector, onScreen = camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local dist = (Vector2.new(vector.X, vector.Y) - screenCenter).Magnitude
                        
                        -- Если навелись на голову (в пределах 160 пикселей) — записываем это событие
                        if dist <= 160 then
                            if not aimHistory[player.Name] then aimHistory[player.Name] = {} end
                            table.insert(aimHistory[player.Name], currentTime)
                        end
                    end
                end
            end
            
            -- Чистим старые записи истории, которые вышли за рамки 0.4 секунд
            for pName, timestamps in pairs(aimHistory) do
                for i = #timestamps, 1, -1 do
                    if currentTime - timestamps[i] > historyWindow then
                        table.remove(timestamps, i)
                    end
                end
                if #timestamps == 0 then aimHistory[pName] = nil end
            end
        end)

        -- Логика отслеживания смертей врагов
        local function monitorPlayer(player)
            if player == lp then return end
            
            player.CharacterAdded:Connect(function(char)
                local humanoid = char:WaitForChild("Humanoid", 5)
                if humanoid then
                    humanoid.Died:Connect(function()
                        if not getgenv().Config["KillStreak"] then return end
                        
                        local currentTime = tick()
                        local wasTargetedRecently = false
                        
                        -- Проверяем буфер: был ли этот игрок в нашем прицеле за последние 0.4 сек
                        if aimHistory[player.Name] and #aimHistory[player.Name] > 0 then
                            for _, timestamp in ipairs(aimHistory[player.Name]) do
                                if currentTime - timestamp <= historyWindow then
                                    wasTargetedRecently = true
                                    break
                                end
                            end
                        end
                        
                        -- Если ты целился в него в пределах 0.4 сек до его смерти — засчитываем твой килл!
                        if wasTargetedRecently then
                            lastKillTime = currentTime
                            currentStreak = currentStreak + 1
                            triggerKillVisuals()
                            -- Очищаем буфер для этого челика, чтобы не сработало дважды
                            aimHistory[player.Name] = nil
                        end
                    end)
                end
            end)
        end

        for _, p in ipairs(Players:GetPlayers()) do monitorPlayer(p) end
        Players.PlayerAdded:Connect(monitorPlayer)

        -- Постоянный чек таймера серии в фоне
        RunService.Heartbeat:Connect(function()
            if currentStreak > 0 and (tick() - lastKillTime) >= comboDuration then
                fadeOutVisuals()
            end
        end)
    end,

    ["AA_VisualJitterBack"] = function()
        local RunService = game:GetService("RunService")
        local LocalPlayer = game.Players.LocalPlayer
        local lastToggle = 0
        local state = false

        RunService.RenderStepped:Connect(function()
            if not getgenv().Config["VisualJitterBack"] then return end
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local cam = workspace.CurrentCamera.CFrame.LookVector
                
                local speed = getgenv().Config["VisualJitterSpeed"] or 2
                local interval = 1 / math.max(speed, 0.1)
                
                if tick() - lastToggle >= interval then
                    state = not state
                    lastToggle = tick()
                end
                
                local range = math.rad(getgenv().Config["VisualJitterRange"] or 15)
                local currentSway = state and range or -range
                
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(cam.X, 0, cam.Z)) 
                             * CFrame.Angles(0, math.rad(180) + currentSway, 0)
            end
        end)
    end,
    ["AA_VisualJitterSpeed"] = function() end,
    ["AA_VisualJitterSpin"] = function()
        local RunService = game:GetService("RunService")
        local LocalPlayer = game.Players.LocalPlayer
        local lastTransform = 0
        local currentAngle = 0

        RunService.RenderStepped:Connect(function()
            if not getgenv().Config["VisualJitterSpin"] then return end
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local cam = workspace.CurrentCamera.CFrame.LookVector
                
                -- Получаем настройки из слайдеров (если их нет, ставим стандартные)
                local delayTime = (getgenv().Config["JitterSpinDelay"] or 50) / 100 -- из ползунка (например, 50 = 0.5 сек)
                local angleStep = getgenv().Config["JitterSpinStep"] or 90 -- шаг поворота в градусах
                
                -- Проверяем, прошло ли нужное время (например, 0.5 секунд) для прыжка направления
                if tick() - lastTransform >= delayTime then
                    currentAngle = (currentAngle + angleStep) % 360
                    lastTransform = tick()
                end
                
                -- Оставляем позицию игрока, но разворачиваем его CFrame относительно камеры на текущий угол
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(cam.X, 0, cam.Z)) 
                             * CFrame.Angles(0, math.rad(currentAngle), 0)
            end
        end)
    end,
    ["AA_JitterSpinDelay"] = function() end,
    ["AA_JitterSpinStep"] = function() end,
    ["WORLD_TextureQuality"] = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then
                obj.Enabled = false 
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end
        workspace.DescendantAdded:Connect(function(obj)
            if getgenv().Config["TextureQuality"] then
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Enabled = false
                elseif obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                end
            end
        end)
    end,
    ["WORLD_SkyColor"] = function()
        local Lighting = game:GetService("Lighting")
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().Config["SkyColor"] then
                Lighting.Ambient = Color3.fromRGB(165, 30, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(165, 30, 255)
                for _, obj in pairs(Lighting:GetChildren()) do
                    if obj:IsA("Sky") then
                        obj.SkyboxBk = ""
                        obj.SkyboxDn = ""
                        obj.SkyboxFt = ""
                        obj.SkyboxLf = ""
                        obj.SkyboxRt = ""
                        obj.SkyboxUp = ""
                    end
                end
            end
        end)
    end,
    ["WORLD_NoFog"] = function()
        local Lighting = game:GetService("Lighting")
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().Config["NoFog"] then
                Lighting.FogEnd = 999999
                Lighting.FogStart = 999999
            end
        end)
    end,
    ["WORLD_DeathParticles"] = function()
        local Players = game:GetService("Players")
        local function CreateTextEffect(char)
            if not getgenv().Config["DeathParticles"] then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local pos = hrp.Position
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Transparency = 1
            part.Anchored = true
            part.CanCollide = false
            part.Position = pos + Vector3.new(0, 3, 0)
            part.Parent = workspace
            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.Adornee = part
            billboard.Parent = part
            local label = Instance.new("TextLabel")
            label.Text = "💀 💀 💀"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextScaled = true
            label.Font = Enum.Font.Code
            label.Parent = billboard
            task.spawn(function()
                for i = 1, 50 do
                    part.Position = part.Position + Vector3.new(0, 0.05, 0)
                    label.TextTransparency = i / 50
                    task.wait(0.08)
                end
                part:Destroy()
            end)
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid").Died:Connect(function()
                    CreateTextEffect(char)
                end)
            end)
        end)
    end,
     ["VISUALS_CameraFOV"] = function()
        local RunService = game:GetService("RunService")
        local Camera = game:GetService("Workspace").CurrentCamera
        RunService.RenderStepped:Connect(function()
            if getgenv().Config["CameraFOV"] then
                Camera.FieldOfView = getgenv().Config["CameraFOV"]
            else
                Camera.FieldOfView = 70
            end
        end)
    end,
    ["AIM_HitboxExpander"] = function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if not getgenv().Config["HitboxExpander"] then return end
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                -- Увеличиваем, если включено
                player.Character.Head.Size = Vector3.new(30, 30, 30)
                player.Character.Head.Transparency = 0.7
                player.Character.Head.CanCollide = false
            end
        end
    end)
end,
    ["MOVEMENT_NoclipFly"] = function()
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        
        local bv = nil -- Физический вектор скорости

        RunService.RenderStepped:Connect(function()
            -- Если чит выключен в меню
            if not getgenv().Config["NoclipFly"] then 
                if bv then 
                    bv:Destroy() 
                    bv = nil 
                end
                return 
            end
            
            local char = lp.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
            
            local hrp = char.HumanoidRootPart
            local hum = char.Humanoid
            local camera = workspace.CurrentCamera
            local speed = getgenv().Config["NoclipFlySpeed"] or 50

            -- 1. ВКЛЮЧАЕМ НОУКЛИП (пролёт сквозь стены)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end

            -- 2. СОЗДАЕМ ВЕКТОР СКОРОСТИ
            if not bv or bv.Parent ~= hrp then
                if bv then bv:Destroy() end
                bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- Даем бесконечную силу, чтобы лететь сквозь всё
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
            end

            -- 3. СЧИТЫВАЕМ ДЖОЙСТИК И НАПРАВЛЕНИЕ КАМЕРЫ
            local moveDir = hum.MoveDirection -- Идеально для мобильного джойстика и WASD

            if moveDir.Magnitude > 0 then
                -- Вектор взгляда камеры (куда наведён прицел/экран)
                local camLook = camera.CFrame.LookVector
                
                -- Базовое направление движения берем от джойстика
                local finalVelocity = moveDir
                
                -- Считаем, насколько джойстик нажат "вперед" относительно взгляда камеры
                local forwardDot = moveDir:Dot(Vector3.new(camLook.X, 0, camLook.Z).Unit)
                
                if forwardDot > 0.5 then
                    -- Если джойстик тянут вперед, плавно добавляем наклон камеры (Y)
                    -- Смотришь вверх — летишь вверх, смотришь вниз — летишь под землю
                    finalVelocity = Vector3.new(moveDir.X, camLook.Y * forwardDot, moveDir.Z)
                elseif forwardDot < -0.5 then
                    -- Если джойстик тянут назад, инвертируем высоту камеры
                    finalVelocity = Vector3.new(moveDir.X, -camLook.Y * math.abs(forwardDot), moveDir.Z)
                end
                
                -- Задаем скорость нашему физическому телу
                bv.Velocity = finalVelocity.Unit * speed
            else
                -- Если джойстик отпущен — персонаж мертво зависает в воздухе и не падает
                bv.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end,
    ["MOVEMENT_NoclipFlySpeed"] = function() end,
    ["AIM_MassKill"] = function()
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer

        RunService.RenderStepped:Connect(function()
            -- Если функция выключена в меню — возвращаем всех на место
            if not getgenv().Config["MassKill"] then 
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.Anchored = false
                    end
                end
                return 
            end
            
            local myChar = lp.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
            
            local camCFrame = workspace.CurrentCamera.CFrame

            -- Каждую миллисекунду стягиваем врагов
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local targetHrp = player.Character.HumanoidRootPart
                    local targetHum = player.Character.Humanoid
                    
                    -- Стягиваем только живых
                    if targetHum.Health > 0 then
                        -- Ставим игроков кучкой в 4 блоках перед камерой, чуть правее и ниже
                        local targetPosition = camCFrame * CFrame.new(2, -1.2, -4)
                        
                        -- ОТКЛЮЧАЕМ КОЛЛИЗИИ ПРАВИЛЬНО (исправлено)
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then 
                                part.CanCollide = false 
                            end
                        end
                        
                        -- Отключаем встроенную физику Humanoid локально, чтобы модельку не штормило
                        targetHum:ChangeState(Enum.HumanoidStateType.Physics)
                        
                        -- Насильно переписываем их позицию на твоем экране
                        targetHrp.CFrame = targetPosition
                        targetHrp.Anchored = true 
                    else
                        -- Если умер — отпускаем труп
                        targetHrp.Anchored = false
                    end
                end
            end
        end)
    end,
        ["AIM_Silent360"] = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local RunService = game:GetService("RunService")

        -- Функция проверки видимости (сквозь стены)
        local function IsVisible(character, targetPart)
            if not getgenv().Config["CheckWall"] then return true end -- Если проверка стен выключена — лупим сквозь них
            local parts = Camera:GetPartsObscuringTarget({targetPart.Position}, {LocalPlayer.Character, character})
            return #parts == 0
        end

        -- Поиск самой близкой жертвы в радиусе 360 градусов
        local function GetClosestPlayer360()
            local closestTarget = nil
            local shortestDistance = math.huge -- Ищем по минимальной дистанции в 3D пространстве

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    -- Наводимся строго в голову, как ты просил
                    local head = player.Character:FindFirstChild("Head")
                    
                    if head then
                        -- Считаем чистое расстояние между тобой и врагом в мире
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                        
                        if distance < shortestDistance and IsVisible(player.Character, head) then
                            shortestDistance = distance
                            closestTarget = head
                        end
                    end
                end
            end
            return closestTarget
        end

        RunService.RenderStepped:Connect(function()
            if not getgenv().Config["Silent360"] then return end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

            local targetHead = GetClosestPlayer360()
            if targetHead then
                -- Полный игнор плавности (Smoothness). Наводка происходит за 1 кадр (мгновенный флик)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            end
        end)
    end,
    ["AIM_CheckWall"] = function() end,
    
        ["ESP_Skeleton"] = function()
        local Players = game:GetService("Players")
        local Camera = workspace.CurrentCamera
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        -- Список пар костей, которые нужно соединить линиями
        local BonePairs = {
            -- Позвоночник / Голова
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            
            -- Левая рука
            {"UpperTorso", "LeftUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"},
            {"LeftLowerArm", "LeftHand"},
            
            -- Правая рука
            {"UpperTorso", "RightUpperArm"},
            {"RightUpperArm", "RightLowerArm"},
            {"RightLowerArm", "RightHand"},
            
            -- Левая нога
            {"LowerTorso", "LeftUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"},
            
            -- Правая нога
            {"LowerTorso", "RightUpperLeg"},
            {"RightUpperLeg", "RightLowerLeg"},
            {"RightLowerLeg", "RightFoot"}
        }

        local function CreateSkeleton(player)
            if player == LocalPlayer then return end
            
            -- Массив для хранения графических линий этого игрока
            local Lines = {}
            for i = 1, #BonePairs do
                local line = Drawing.new("Line")
                -- СРАЗУ ДЕЛАЕМ БЕЛЫМ (потом поменяем на фиолетовый)
                line.Color = Color3.fromRGB(255, 255, 255) 
                line.Thickness = 1.5
                line.Transparency = 1
                line.Visible = false
                table.insert(Lines, line)
            end

            local connection
            connection = RunService.RenderStepped:Connect(function()
                -- Проверка чекбокса в меню
                if not getgenv().Config["Skeleton"] then
                    for _, line in ipairs(Lines) do line.Visible = false end
                    return
                end

                local char = player.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    for id, pair in ipairs(BonePairs) do
                        local partA = char:FindFirstChild(pair[1])
                        local partB = char:FindFirstChild(pair[2])
                        local line = Lines[id]

                        if partA and partB then
                            -- Переводим 3D координаты суставов в 2D экранные координаты
                            local posA, onScreenA = Camera:WorldToViewportPoint(partA.Position)
                            local posB, onScreenB = Camera:WorldToViewportPoint(partB.Position)

                            -- Если обе части тела видны на экране — рисуем кость
                            if onScreenA and onScreenB then
                                line.From = Vector2.new(posA.X, posA.Y)
                                line.To = Vector2.new(posB.X, posB.Y)
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        else
                            line.Visible = false
                        end
                    end
                else
                    -- Если игрок умер или вышел
                    for _, line in ipairs(Lines) do line.Visible = false end
                    if not Players:FindFirstChild(player.Name) then
                        for _, line in ipairs(Lines) do line:Remove() end
                        connection:Disconnect()
                    end
                end
            end)
        end

        -- Запускаем для всех текущих и будущих игроков
        for _, p in ipairs(Players:GetPlayers()) do CreateSkeleton(p) end
        Players.PlayerAdded:Connect(CreateSkeleton)
    end,
    ["VISUALS_FakeLagClone"] = function()
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local LocalPlayer = Players.LocalPlayer
        local lastCloneTime = 0

        game:GetService("RunService").RenderStepped:Connect(function()
            if not getgenv().Config["FakeLagClone"] then return end
            local char = LocalPlayer.Character
            if not char then return end

            local interval = (getgenv().Config["FakeLagInterval"] or 50) / 100
            
            if tick() - lastCloneTime >= interval then
                lastCloneTime = tick()
                
                local soulFolder = Instance.new("Folder")
                soulFolder.Name = "GhostClone"
                soulFolder.Parent = workspace.CurrentCamera

                local trans = (getgenv().Config["FakeLagTransparency"] or 0) / 100

                -- Сканируем АБСОЛЮТНО ВСЕ детали персонажа
                for _, part in ipairs(char:GetDescendants()) do
                    -- Берем только видимые физические части (игнорим невидимый RootPart)
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 1 then
                        local ghostPart = part:Clone()
                        
                        -- 1. Сносим весь дочерний мусор (сварку, рамки, декали)
                        for _, child in ipairs(ghostPart:GetChildren()) do
                            if child:IsA("SpecialMesh") then
                                child.TextureId = "" -- Стираем текстуру с головы/аксессуаров
                            else
                                child:Destroy() 
                            end
                        end

                        -- 2. ВЫЖИГАЕМ ТЕКСТУРЫ ТЕЛА (руки, ноги, тулуб)
                        if ghostPart:IsA("MeshPart") then
                            ghostPart.TextureID = ""
                        end
                        
                        -- 3. Заставляем Union-объекты (некоторые пушки) принимать цвет
                        if ghostPart:IsA("UnionOperation") then
                            ghostPart.UsePartColor = true
                        end

                        -- Отрубаем любую коллизию и физику
                        ghostPart.Anchored = true
                        ghostPart.CanCollide = false
                        ghostPart.CanTouch = false
                        ghostPart.CanQuery = false
                        ghostPart.Massless = true

                        -- ЗАЛИВКА: Чистый фиолетовый неон
                        ghostPart.Material = Enum.Material.Neon
                        ghostPart.Color = Color3.fromRGB(165, 30, 255)
                        ghostPart.Transparency = trans
                        
                        ghostPart.CFrame = part.CFrame
                        ghostPart.Parent = soulFolder
                    end
                end

                -- Анимация затухания
                task.spawn(function()
                    task.wait(0.2)
                    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
                    for _, v in ipairs(soulFolder:GetChildren()) do
                        TweenService:Create(v, tweenInfo, {Transparency = 1}):Play()
                    end
                    task.wait(0.5)
                    soulFolder:Destroy()
                end)
            end
        end)
    end,


    
    -- ПУСТЫШКИ ДЛЯ МЕНЮ (чтобы движок создал слайдеры)
    ["VISUALS_FakeLagInterval"] = function() end,
    ["VISUALS_FakeLagTransparency"] = function() end,


    ["VISUALS_PlayerTrail"] = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local trail = nil
        local att0, att1 = nil, nil

        local function ClearTrail()
            if trail then pcall(function() trail:Destroy() end) trail = nil end
            if att0 then pcall(function() att0:Destroy() end) att0 = nil end
            if att1 then pcall(function() att1:Destroy() end) att1 = nil end
        end

        local function SetupTrail(char)
            ClearTrail()
            if not char then return end
            
            local head = char:WaitForChild("Head", 5)
            local root = char:WaitForChild("HumanoidRootPart", 5)
            if not head or not root then return end

            att0 = Instance.new("Attachment", head)
            att0.Position = Vector3.new(0, 0.5, 0)
            
            att1 = Instance.new("Attachment", root)
            att1.Position = Vector3.new(0, -2, 0) -- Опускаем вниз до конца ног

            trail = Instance.new("Trail")
            trail.Attachment0 = att0
            trail.Attachment1 = att1
            trail.Color = ColorSequence.new(Color3.fromRGB(165, 30, 255))
            trail.LightEmission = 0.8
            trail.Lifetime = 0.6 -- Длина хвоста следа
            trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2), -- Начинается ярким
                NumberSequenceKeypoint.new(1, 1)    -- Плавно исчезает в конце
            })
            
            trail.Parent = root
        end

        task.spawn(function()
            while task.wait(0.5) do
                if getgenv().Config["PlayerTrail"] then
                    if not trail and LocalPlayer.Character then
                        SetupTrail(LocalPlayer.Character)
                    end
                else
                    ClearTrail()
                end
            end
        end)

        LocalPlayer.CharacterAdded:Connect(function(char)
            if getgenv().Config["PlayerTrail"] then SetupTrail(char) end
        end)
    end,

}

for slotName, slotCode in pairs(Slots) do
    if slotCode ~= nil then
        local parsed = string.split(slotName, "_")
        local tab = parsed[1]
        local func = parsed[2]
        
        CreateTabButton(tab)
        
        if func == "AimRadius" then
            BuildSlider(tab, func, 10, 600, 100)
        elseif func == "Smoothness" then
            BuildSlider(tab, func, 1, 30, 5)
        elseif func == "Distance" then
            BuildSlider(tab, func, 5, 100, 25)
        elseif func == "ThemeSelect" then
            BuildDropdown(tab, func, {"Фиолетовая", "Красная", "Синяя", "Зелёная", "Жёлтая", "Черная"})
        elseif func == "VisualJitterSpin" then
            BuildCheckbox(tab, func)
        elseif func == "NoclipFly" then
            BuildCheckbox(tab, func)
        elseif func == "NoclipFlySpeed" then
            BuildSlider(tab, func, 10, 300, 60)
        elseif func == "JitterSpinDelay" then
            BuildSlider(tab, func, 5, 200, 50)
        elseif func == "JitterSpinStep" then
            BuildSlider(tab, func, 15, 180, 90)
        elseif func == "FakeLagInterval" then
            BuildSlider(tab, func, 10, 300, 50) 
        elseif func == "FakeLagTransparency" then
            BuildSlider(tab, func, 0, 95, 40) 
        elseif func == "VisualJitterRange" then
            BuildSlider(tab, func, 5, 45, 15)
        elseif func == "VisualJitterSpeed" then
            BuildSlider(tab, func, 1, 20, 2)
        elseif func == "CameraFOV" then
            BuildSlider(tab, func, 50, 400, 70)
        elseif func == "Hitbox" then
            BuildDropdown(tab, func, {"Head", "HumanoidRootPart", "LowerTorso"})
        else
            BuildCheckbox(tab, func)
        end
        
        task.spawn(slotCode)
    end
end

for tabName, _ in pairs(CreatedTabs) do
    local btn = TabContainer:FindFirstChild("Tab_" .. tabName)
    if btn then
        btn.TextColor3 = Color3.fromRGB(165, 30, 255)
        if RegisteredElements[tabName] then
            for _, frame in ipairs(RegisteredElements[tabName]) do
                frame.Parent = ScrollContent
                frame.Visible = true
            end
        end
        break
    end
end
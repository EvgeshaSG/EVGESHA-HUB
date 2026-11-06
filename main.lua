-- // EVGESHA HUB | Aimbot + ESP + Visuals
-- Автор: EvgeshaSG
-- Поддержка: Solara / Xeno

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ============================================================
-- KEY SYSTEM (Ключи: EVG7 или EVG-7)
-- ============================================================
local VALID_KEYS = { ["EVG7"] = true, ["EVG-7"] = true }

local function showKeySystem(onSuccess)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.IgnoreGuiInset = true
    keyGui.DisplayOrder = 999
    keyGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 360, 0, 220)
    frame.Position = UDim2.new(0.5, -180, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    frame.BorderSizePixel = 0
    frame.Parent = keyGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 90, 255)
    stroke.Thickness = 2
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "🔐 KEY SYSTEM"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -40, 0, 20)
    sub.Position = UDim2.new(0, 20, 0, 55)
    sub.BackgroundTransparency = 1
    sub.Text = "Введите ключ для доступа (TG: t.me/EvgeshaSG)"
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.TextColor3 = Color3.fromRGB(160, 160, 180)
    sub.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -40, 0, 36)
    box.Position = UDim2.new(0, 20, 0, 90)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    box.BorderSizePixel = 0
    box.PlaceholderText = "Введите ключ..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Parent = frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 38)
    btn.Position = UDim2.new(0, 20, 0, 145)
    btn.BackgroundColor3 = Color3.fromRGB(120, 90, 255)
    btn.Text = "АКТИВИРОВАТЬ"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 18)
    status.Position = UDim2.new(0, 20, 0, 190)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.Parent = frame

    btn.MouseButton1Click:Connect(function()
        local key = box.Text:upper():gsub("%s+", "")
        if VALID_KEYS[key] then
            status.TextColor3 = Color3.fromRGB(80, 255, 120)
            status.Text = "✅ Ключ принят!"
            task.wait(0.6)
            keyGui:Destroy()
            onSuccess()
        else
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            status.Text = "❌ Неверный ключ"
        end
    end)
end

-- ============================================================
-- НАСТРОЙКИ
-- ============================================================
local SETTINGS = {
    Aim = { Enabled = false, FOV = 90, Smoothness = 0.55, TeamCheck = true, VisibleCheck = true, ReactionDelay = 0.12, MaxDistance = 500, BodyPart = "Head", Jitter = 0.35, HoldKey = Enum.KeyCode.E },
    ESP = { Enabled = false, TeamCheck = true, ShowTeam = true, ShowName = true, ShowDistance = true, ShowHealth = true, ShowBox = true, MaxDistance = 1000 },
}

-- ============================================================
-- КАСТОМНЫЙ UI
-- ============================================================
local Hub = {}
Hub.__index = Hub

function Hub.new()
    local self = setmetatable({}, Hub)
    self.tabs = {}
    return self
end

function Hub:Create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "CustomHub"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 100
    gui.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 560, 0, 380)
    main.Position = UDim2.new(0.5, -280, 0.5, -190)
    main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(90, 70, 200)
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.3
    mainStroke.Parent = main

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    sidebar.Parent = main
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
    
    local sidebarFix = Instance.new("Frame")
    sidebarFix.Size = UDim2.new(0, 12, 1, 0)
    sidebarFix.Position = UDim2.new(1, -12, 0, 0)
    sidebarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    sidebarFix.Parent = sidebar

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 0, 50)
    logo.BackgroundTransparency = 1
    logo.Text = "⚡ EVGESHA HUB"
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = 16
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.Parent = sidebar

    local tabList = Instance.new("Frame")
    tabList.Size = UDim2.new(1, -20, 1, -60)
    tabList.Position = UDim2.new(0, 10, 0, 60)
    tabList.BackgroundTransparency = 1
    tabList.Parent = sidebar
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabList
    self.tabList = tabList

    local watermark = Instance.new("TextLabel")
    watermark.Size = UDim2.new(0, 150, 0, 20)
    watermark.Position = UDim2.new(1, -160, 1, -26)
    watermark.BackgroundTransparency = 1
    watermark.Text = "by EvgeshaSG"
    watermark.Font = Enum.Font.GothamBold
    watermark.TextSize = 12
    watermark.TextColor3 = Color3.fromRGB(120, 90, 255)
    watermark.TextXAlignment = Enum.TextXAlignment.Right
    watermark.Parent = main

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -150, 1, 0)
    content.Position = UDim2.new(0, 150, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = main
    self.content = content

    local tabTitle = Instance.new("TextLabel")
    tabTitle.Size = UDim2.new(1, -30, 0, 45)
    tabTitle.Position = UDim2.new(0, 20, 0, 10)
    tabTitle.BackgroundTransparency = 1
    tabTitle.Text = ""
    tabTitle.Font = Enum.Font.GothamBold
    tabTitle.TextSize = 20
    tabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabTitle.TextXAlignment = Enum.TextXAlignment.Left
    tabTitle.Parent = content
    self.tabTitle = tabTitle

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -30, 1, -80)
    scroll.Position = UDim2.new(0, 20, 0, 70)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 90, 255)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = content
    self.scroll = scroll

    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 8)
    scrollLayout.Parent = scroll

    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    logo.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Объём
    local baseSize = main.Size
    main.MouseEnter:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.18), { Size = UDim2.new(0, baseSize.X.Offset * 0.985, 0, baseSize.Y.Offset * 0.985) }):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.18), { Transparency = 0, Color = Color3.fromRGB(140, 110, 255) }):Play()
    end)
    main.MouseLeave:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.18), { Size = baseSize }):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.18), { Transparency = 0.3, Color = Color3.fromRGB(90, 70, 200) }):Play()
    end)

    return self
end

function Hub:MakeTab(name)
    local tab = { name = name, elements = {} }
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = "   " .. name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = self.tabList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() self:SelectTab(name) end)
    table.insert(self.tabs, { data = tab, button = btn })
    return tab
end

function Hub:SelectTab(name)
    for _, t in ipairs(self.tabs) do
        local isCurrent = (t.data.name == name)
        TweenService:Create(t.button, TweenInfo.new(0.15), {
            BackgroundColor3 = isCurrent and Color3.fromRGB(120, 90, 255) or Color3.fromRGB(30, 30, 40),
            TextColor3 = isCurrent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
        }):Play()
        for _, el in ipairs(t.data.elements) do if el.frame then el.frame.Visible = isCurrent end end
    end
    self.tabTitle.Text = name
end

function Hub:GetTab(name)
    for _, t in ipairs(self.tabs) do if t.data.name == name then return t.data end end
end

function Hub:AddToggle(tabName, label, default, callback)
    local tab = self:GetTab(tabName); if not tab then return end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34); frame.Visible = false; frame.Parent = self.scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = label; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextColor3 = Color3.fromRGB(220, 220, 230); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 36, 0, 20); toggle.Position = UDim2.new(1, -48, 0.5, -10)
    toggle.BackgroundColor3 = default and Color3.fromRGB(80, 200, 100) or Color3.fromRGB(60, 60, 75)
    toggle.Text = default and "ON" or "OFF"; toggle.Font = Enum.Font.GothamBold; toggle.TextSize = 11; toggle.TextColor3 = Color3.fromRGB(255, 255, 255); toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 4)
    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state; toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and Color3.fromRGB(80, 200, 100) or Color3.fromRGB(60, 60, 75)
        if callback then callback(state) end
    end)
    table.insert(tab.elements, { frame = frame })
end

function Hub:AddSlider(tabName, label, min, max, default, callback)
    local tab = self:GetTab(tabName); if not tab then return end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34); frame.Visible = false; frame.Parent = self.scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18); lbl.Position = UDim2.new(0, 12, 0, 6); lbl.BackgroundTransparency = 1
    lbl.Text = label .. ": " .. string.format("%.2f", default); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextColor3 = Color3.fromRGB(220, 220, 230); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -24, 0, 6); bar.Position = UDim2.new(0, 12, 0, 30); bar.BackgroundColor3 = Color3.fromRGB(50, 50, 65); bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(120, 90, 255); fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local v = min + (max - min) * pos
        lbl.Text = label .. ": " .. string.format("%.2f", v)
        if callback then callback(v) end
    end
    bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    table.insert(tab.elements, { frame = frame })
end

function Hub:AddLabel(tabName, text)
    local tab = self:GetTab(tabName); if not tab then return end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34); frame.Visible = false; frame.Parent = self.scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextColor3 = Color3.fromRGB(180, 180, 200); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextWrapped = true; lbl.Parent = frame
    table.insert(tab.elements, { frame = frame })
end

-- ============================================================
-- ESP ЛОГИКА
-- ============================================================
local espCache = {}
local espLayer = Instance.new("Frame")
espLayer.Size = UDim2.new(1, 0, 1, 0); espLayer.BackgroundTransparency = 1; espLayer.Parent = CoreGui

local function getESP(plr)
    if espCache[plr] then return espCache[plr] end
    local container = Instance.new("Frame"); container.BackgroundTransparency = 1; container.Parent = espLayer
    local box = Instance.new("Frame"); box.BackgroundTransparency = 1; box.BorderSizePixel = 1; box.BorderColor3 = Color3.fromRGB(255, 60, 60); box.Parent = container
    local nameLabel = Instance.new("TextLabel"); nameLabel.BackgroundTransparency = 1; nameLabel.Font = Enum.Font.GothamBold; nameLabel.TextSize = 13; nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255); nameLabel.TextStrokeTransparency = 0.4; nameLabel.Parent = container
    local teamLabel = Instance.new("TextLabel"); teamLabel.BackgroundTransparency = 1; teamLabel.Font = Enum.Font.Gotham; teamLabel.TextSize = 11; teamLabel.TextColor3 = Color3.fromRGB(180, 220, 255); teamLabel.TextStrokeTransparency = 0.4; teamLabel.Parent = container
    local healthBg = Instance.new("Frame"); healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); healthBg.Parent = container
    Instance.new("UICorner", healthBg).CornerRadius = UDim.new(0, 2)
    local healthBar = Instance.new("Frame"); healthBar.BackgroundColor3 = Color3.fromRGB(60, 200, 90); healthBar.Size = UDim2.new(1, 0, 1, 0); healthBar.Parent = healthBg
    Instance.new("UICorner", healthBar).CornerRadius = UDim.new(0, 2)
    local entry = { container = container, box = box, nameLabel = nameLabel, teamLabel = teamLabel, healthBg = healthBg, healthBar = healthBar }
    espCache[plr] = entry
    return entry
end

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        local shouldHide = (plr == player) or (SETTINGS.ESP.TeamCheck and plr.Team and player.Team and plr.Team == player.Team)
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if shouldHide or not hrp or not hum or hum.Health <= 0 then
            if espCache[plr] then espCache[plr].container.Visible = false end
            continue
        end
        
        local e = getESP(plr)
        e.container.Visible = SETTINGS.ESP.Enabled
        if not SETTINGS.ESP.Enabled then continue end

        local dist = (hrp.Position - camera.CFrame.Position).Magnitude
        if dist > SETTINGS.ESP.MaxDistance then e.container.Visible = false; continue end

        local cf, size = char:GetBoundingBox()
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        local anyOnScreen = false
        for x = -0.5, 0.5, 1 do for y = -0.5, 0.5, 1 do for z = -0.5, 0.5, 1 do
            local sp, onScreen = camera:WorldToViewportPoint(cf * Vector3.new(x * size.X, y * size.Y, z * size.Z))
            if onScreen and sp.Z > 0 then
                anyOnScreen = true
                minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y); maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)
            end
        end end end
        if not anyOnScreen then e.container.Visible = false; continue end

        local w, h = math.max(maxX - minX, 1), math.max(maxY - minY, 1)
        e.container.Position = UDim2.fromOffset(minX, minY); e.container.Size = UDim2.fromOffset(w, h)
        e.box.Size = UDim2.new(1, 0, 1, 0); e.box.Visible = SETTINGS.ESP.ShowBox
        e.box.BorderColor3 = Color3.fromRGB(255, 60, 60)
        e.nameLabel.Visible = SETTINGS.ESP.ShowName; e.nameLabel.Text = plr.Name; e.nameLabel.Size = UDim2.new(w, 0, 0, 15); e.nameLabel.Position = UDim2.fromOffset(0, -18)
        e.teamLabel.Visible = SETTINGS.ESP.ShowTeam and plr.Team ~= nil
        if plr.Team then e.teamLabel.TextColor3 = plr.Team.TeamColor.Color end
        e.teamLabel.Size = UDim2.new(w, 0, 0, 14); e.teamLabel.Position = UDim2.fromOffset(0, 14)
        e.healthBg.Visible = SETTINGS.ESP.ShowHealth; e.healthBg.Size = UDim2.fromOffset(w, 3); e.healthBg.Position = UDim2.fromOffset(0, h + 2)
        e.healthBar.Size = UDim2.new(math.clamp(hum.Health / hum.MaxHealth, 0, 1), 0, 1, 0)
        if SETTINGS.ESP.ShowDistance then e.teamLabel.Text = (plr.Team and ("[" .. plr.Team.Name .. "] ") or "") .. string.format("%dm", math.floor(dist)) end
    end
end

-- ============================================================
-- AIMBOT ЛОГИКА
-- ============================================================
local aimState = { lastTarget = nil, lastTargetTime = 0 }
local holdingAim = false

local function isTeammate(plr)
    if plr == player then return true end
    if not SETTINGS.Aim.TeamCheck then return false end
    return plr.Team and player.Team and plr.Team == player.Team
end

local function isVisible(part)
    if not SETTINGS.Aim.VisibleCheck then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {player.Character, part.Parent, CoreGui}
    return Workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position, params) == nil
end

local function getBestTarget()
    local center = camera.ViewportSize / 2
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if isTeammate(plr) then continue end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = char:FindFirstChild(SETTINGS.Aim.BodyPart) or char:FindFirstChild("Head")
        if not part then continue end
        local worldDist = (part.Position - camera.CFrame.Position).Magnitude
        if worldDist > SETTINGS.Aim.MaxDistance then continue end
        local sp, onScreen = camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end
        local screenDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if screenDist > SETTINGS.Aim.FOV then continue end
        if not isVisible(part) then continue end
        local score = screenDist + worldDist * 0.02
        if score < bestDist then best, bestDist = part, score end
    end
    return best
end

UserInputService.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == SETTINGS.Aim.HoldKey then holdingAim = true end end)
UserInputService.InputEnded:Connect(function(input) if input.KeyCode == SETTINGS.Aim.HoldKey then holdingAim = false; aimState.lastTarget = nil end end)

RunService.RenderStepped:Connect(function(dt)
    if SETTINGS.Aim.Enabled and holdingAim then
        local target = getBestTarget()
        if target then
            if aimState.lastTarget ~= target then aimState.lastTarget = target; aimState.lastTargetTime = os.clock() end
            if os.clock() - aimState.lastTargetTime >= SETTINGS.Aim.ReactionDelay then
                local targetCF = CFrame.new(camera.CFrame.Position, target.Position)
                if SETTINGS.Aim.Jitter > 0 then
                    targetCF = targetCF * CFrame.Angles(math.rad((math.random() - 0.5) * SETTINGS.Aim.Jitter), math.rad((math.random() - 0.5) * SETTINGS.Aim.Jitter), 0)
                end
                if SETTINGS.Aim.Smoothness <= 0 then camera.CFrame = targetCF else
                    local alpha = (1 - SETTINGS.Aim.Smoothness) * math.min(dt * 30, 1)
                    camera.CFrame = camera.CFrame:Lerp(targetCF, math.clamp(alpha, 0, 0.4))
                end
            end
        else aimState.lastTarget = nil end
    else aimState.lastTarget = nil end

    if SETTINGS.ESP.Enabled then updateESP() else
        for _, e in pairs(espCache) do if e.container then e.container.Visible = false end end
    end
end)

-- ============================================================
-- ЗАПУСК ХАБА
-- ============================================================
local function loadHub()
    local hub = Hub.new():Create()

    -- 1. Вкладка Aimbot
    hub:MakeTab("Aimbot")
    hub:AddToggle("Aimbot", "Включить AimBot (Hold E)", false, function(v) SETTINGS.Aim.Enabled = v end)
    hub:AddToggle("Aimbot", "TeamCheck (не бить своих)", true, function(v) SETTINGS.Aim.TeamCheck = v end)
    hub:AddToggle("Aimbot", "Visible Check (только видимые)", true, function(v) SETTINGS.Aim.VisibleCheck = v end)
    hub:AddSlider("Aimbot", "FOV", 20, 400, 90, function(v) SETTINGS.Aim.FOV = v end)
    hub:AddSlider("Aimbot", "Smoothness", 0, 1, 0.55, function(v) SETTINGS.Aim.Smoothness = v end)
    hub:AddSlider("Aimbot", "Reaction Delay (сек)", 0, 0.5, 0.12, function(v) SETTINGS.Aim.ReactionDelay = v end)

    -- 2. Вкладка ESP
    hub:MakeTab("ESP")
    hub:AddToggle("ESP", "Включить ESP", false, function(v) SETTINGS.ESP.Enabled = v end)
    hub:AddToggle("ESP", "Скрывать своих (TeamCheck)", true, function(v) SETTINGS.ESP.TeamCheck = v end)
    hub:AddToggle("ESP", "Показывать команду", true, function(v) SETTINGS.ESP.ShowTeam = v end)
    hub:AddToggle("ESP", "Боксы", true, function(v) SETTINGS.ESP.ShowBox = v end)
    hub:AddToggle("ESP", "Здоровье", true, function(v) SETTINGS.ESP.ShowHealth = v end)

    -- 3. Вкладка Info (Твоя новая вкладка)
    hub:MakeTab("Info")
    hub:AddLabel("Info", "Привет! Это EVGESHA HUB.")
    hub:AddLabel("Info", "Автор: EvgeshaSG")
    hub:AddLabel("Info", "ТГК: t.me/EvgeshaSG")
    hub:AddLabel("Info", "Поддержка экзекуторов: Solara, Xeno.")
    
    -- Автоматически открываем первую вкладку
    hub:SelectTab("Aimbot")
end

-- ============================================================
-- СТАРТ (Вызов Key System, затем загрузка хаба)
-- ============================================================
showKeySystem(loadHub)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimbotOn = false
local aimbotRange = 200
local nametagOn = false
local nametags = {}

for _, n in ipairs({"MyLoadingGUI", "MyMenuScript"}) do
    local o = CoreGui:FindFirstChild(n)
    if o then o:Destroy() end
end

local function findTarget(range)
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position
    local closest, closestDist = nil, range
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            if char then
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local dist = (head.Position - myPos).Magnitude
                    if dist < closestDist then
                        closest = head
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

-- ===== NAMETAG =====
local function createNametag(plr)
    if nametags[plr] then
        pcall(function() nametags[plr]:Destroy() end)
        nametags[plr] = nil
    end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TbaoNametag"
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = false
    billboard.Parent = head
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "👤 " .. plr.Name
    label.TextColor3 = Color3.fromRGB(255, 50, 50)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    
    nametags[plr] = billboard
end

local function removeNametag(plr)
    if nametags[plr] then
        pcall(function() nametags[plr]:Destroy() end)
        nametags[plr] = nil
    end
end

local function updateAllNametags()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            if nametagOn then createNametag(plr) else removeNametag(plr) end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if nametagOn then
            task.wait(0.5)
            createNametag(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeNametag(plr)
end)

-- ===== LOADING =====
local LG = Instance.new("ScreenGui")
LG.Name = "MyLoadingGUI"
LG.ResetOnSpawn = false
LG.IgnoreGuiInset = true
LG.Parent = CoreGui

local BG = Instance.new("Frame", LG)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
BG.BorderSizePixel = 0

local Box = Instance.new("Frame", LG)
Box.Size = UDim2.new(0, 320, 0, 160)
Box.Position = UDim2.new(0.5, -160, 0.5, -80)
Box.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Box.BorderSizePixel = 0
Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 14)

local BS = Instance.new("UIStroke", Box)
BS.Color = Color3.fromRGB(0, 120, 215)
BS.Thickness = 2

local LT = Instance.new("TextLabel", Box)
LT.Size = UDim2.new(1, 0, 0, 40)
LT.Position = UDim2.new(0, 0, 0, 15)
LT.BackgroundTransparency = 1
LT.Text = "Tbao"
LT.TextColor3 = Color3.fromRGB(0, 170, 255)
LT.Font = Enum.Font.GothamBold
LT.TextSize = 26

local LS = Instance.new("TextLabel", Box)
LS.Size = UDim2.new(1, 0, 0, 25)
LS.Position = UDim2.new(0, 0, 0, 55)
LS.BackgroundTransparency = 1
LS.Text = "Đang tải..."
LS.TextColor3 = Color3.fromRGB(200, 200, 200)
LS.Font = Enum.Font.Gotham
LS.TextSize = 14

local BB = Instance.new("Frame", Box)
BB.Size = UDim2.new(0, 260, 0, 10)
BB.Position = UDim2.new(0.5, -130, 0, 95)
BB.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
BB.BorderSizePixel = 0
Instance.new("UICorner", BB).CornerRadius = UDim.new(1, 0)

local BF = Instance.new("Frame", BB)
BF.Size = UDim2.new(0, 0, 1, 0)
BF.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
BF.BorderSizePixel = 0
Instance.new("UICorner", BF).CornerRadius = UDim.new(1, 0)

local PT = Instance.new("TextLabel", Box)
PT.Size = UDim2.new(1, 0, 0, 20)
PT.Position = UDim2.new(0, 0, 0, 115)
PT.BackgroundTransparency = 1
PT.Text = "0%"
PT.TextColor3 = Color3.fromRGB(0, 170, 255)
PT.Font = Enum.Font.GothamBold
PT.TextSize = 14

-- ===== MENU =====
local SG = Instance.new("ScreenGui")
SG.Name = "MyMenuScript"
SG.ResetOnSpawn = false
SG.Parent = CoreGui

local TB = Instance.new("TextButton", SG)
TB.Size = UDim2.new(0, 110, 0, 38)
TB.Position = UDim2.new(0, 15, 0, 15)
TB.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TB.TextColor3 = Color3.fromRGB(255, 255, 255)
TB.Text = "⚙️ Tbao"
TB.Font = Enum.Font.GothamBold
TB.TextSize = 14
TB.BorderSizePixel = 0
TB.Visible = false
Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 8)

local F = Instance.new("Frame", SG)
F.Size = UDim2.new(0, 480, 0, 360)
F.Position = UDim2.new(0.5, -240, 0.5, -180)
F.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
F.BorderSizePixel = 0
F.Visible = false
Instance.new("UICorner", F).CornerRadius = UDim.new(0, 14)

local FS = Instance.new("UIStroke", F)
FS.Color = Color3.fromRGB(0, 120, 215)
FS.Thickness = 2

local T = Instance.new("TextLabel", F)
T.Size = UDim2.new(1, 0, 0, 50)
T.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
T.Text = "  ⚙️ Tbao"
T.TextColor3 = Color3.fromRGB(255, 255, 255)
T.Font = Enum.Font.GothamBold
T.TextSize = 20
T.BorderSizePixel = 0
T.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", T).CornerRadius = UDim.new(0, 14)

local TitleFix = Instance.new("Frame", T)
TitleFix.Size = UDim2.new(1, 0, 0, 14)
TitleFix.Position = UDim2.new(0, 0, 1, -14)
TitleFix.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = T

local TPadding = Instance.new("UIPadding", T)
TPadding.PaddingLeft = UDim.new(0, 25)

local CB = Instance.new("TextButton", T)
CB.Size = UDim2.new(0, 32, 0, 32)
CB.Position = UDim2.new(1, -45, 0, 9)
CB.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CB.TextColor3 = Color3.fromRGB(255, 255, 255)
CB.Text = "✕"
CB.Font = Enum.Font.GothamBold
CB.TextSize = 18
CB.BorderSizePixel = 0
Instance.new("UICorner", CB).CornerRadius = UDim.new(0, 8)

local Content = Instance.new("Frame", F)
Content.Size = UDim2.new(1, -40, 1, -80)
Content.Position = UDim2.new(0, 20, 0, 65)
Content.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", Content)
grid.CellSize = UDim2.new(0.5, -8, 0, 50)
grid.CellPadding = UDim2.new(0, 8, 0, 10)
grid.SortOrder = Enum.SortOrder.LayoutOrder

local function mkBtn(txt, callback)
    local b = Instance.new("TextButton", Content)
    b.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = txt
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    b.MouseEnter:Connect(function()
        if not b.Text:find("BẬT") then
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if b.Text:find("BẬT") then
            b.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        else
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(42, 42, 52)}):Play()
        end
    end)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- NÚT AIMBOT
local aimbotBtn = mkBtn("🎯 Aimbot: TẮT", function()
    aimbotOn = not aimbotOn
    if aimbotOn then
        aimbotBtn.Text = "🎯 Aimbot: BẬT"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    else
        aimbotBtn.Text = "🎯 Aimbot: TẮT"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    end
end)

-- NÚT ĐỊNH VỊ
mkBtn("📍 Định vị nhân vật", function()
    local tpGui = Instance.new("ScreenGui")
    tpGui.Name = "MyPlayerTPGui"
    tpGui.ResetOnSpawn = false
    tpGui.Parent = CoreGui
    
    local tpFrame = Instance.new("Frame")
    tpFrame.Size = UDim2.new(0, 300, 0, 420)
    tpFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
    tpFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    tpFrame.BorderSizePixel = 0
    tpFrame.Parent = tpGui
    Instance.new("UICorner", tpFrame).CornerRadius = UDim.new(0, 12)
    
    local tpStroke = Instance.new("UIStroke", tpFrame)
    tpStroke.Color = Color3.fromRGB(0, 170, 255)
    tpStroke.Thickness = 1.5
    
    local tpTitle = Instance.new("TextLabel", tpFrame)
    tpTitle.Size = UDim2.new(1, 0, 0, 38)
    tpTitle.BackgroundTransparency = 1
    tpTitle.Text = "📍 DANH SÁCH NGƯỜI CHƠI"
    tpTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
    tpTitle.Font = Enum.Font.GothamBold
    tpTitle.TextSize = 14
    
    local refreshBtn = Instance.new("TextButton", tpFrame)
    refreshBtn.Size = UDim2.new(0, 110, 0, 30)
    refreshBtn.Position = UDim2.new(0, 25, 0, 42)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Text = "🔄 Làm mới"
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 12
    refreshBtn.BorderSizePixel = 0
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)
    
    local closeBtn = Instance.new("TextButton", tpFrame)
    closeBtn.Size = UDim2.new(0, 110, 0, 30)
    closeBtn.Position = UDim2.new(0, 165, 0, 42)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "❌ Đóng"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    
    local scroll = Instance.new("ScrollingFrame", tpFrame)
    scroll.Size = UDim2.new(0, 260, 0, 310)
    scroll.Position = UDim2.new(0, 20, 0, 82)
    scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    
    local function refreshList()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local order = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                order = order + 1
                local playerBtn = Instance.new("TextButton", scroll)
                playerBtn.Size = UDim2.new(1, -8, 0, 38)
                playerBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
                playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerBtn.Text = "👤 " .. plr.Name
                playerBtn.Font = Enum.Font.Gotham
                playerBtn.TextSize = 13
                playerBtn.BorderSizePixel = 0
                playerBtn.LayoutOrder = order
                Instance.new("UICorner", playerBtn).CornerRadius = UDim.new(0, 6)
                
                playerBtn.MouseEnter:Connect(function()
                    playerBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
                end)
                playerBtn.MouseLeave:Connect(function()
                    playerBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
                end)
                
                playerBtn.MouseButton1Click:Connect(function()
                    local targetChar = plr.Character
                    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        local myChar = LP.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            myChar.HumanoidRootPart.CFrame = CFrame.new(targetChar.HumanoidRootPart.Position + Vector3.new(0, 3, 3))
                        end
                    end
                end)
            end
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end
    
    refreshBtn.MouseButton1Click:Connect(refreshList)
    refreshList()
    closeBtn.MouseButton1Click:Connect(function() tpGui:Destroy() end)
end)

-- NÚT HIỆN TÊN
local nametagBtn = mkBtn("👁️ Hiện tên: TẮT", function()
    nametagOn = not nametagOn
    if nametagOn then
        nametagBtn.Text = "👁️ Hiện tên: BẬT"
        nametagBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    else
        nametagBtn.Text = "👁️ Hiện tên: TẮT"
        nametagBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    end
    updateAllNametags()
end)

mkBtn("❌ Đóng Menu", function()
    F.Visible = false
end)

mkBtn("🔄 Reset nhân vật", function()
    local char = LP.Character
    if char then char:BreakJoints() end
end)

-- ===== VÒNG LẶP AIMBOT =====
RunService.RenderStepped:Connect(function()
    if aimbotOn then
        local target = findTarget(aimbotRange)
        if target then
            pcall(function()
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end)
        end
    end
end)

-- ===== SỰ KIỆN =====
_G.OpenMyMenu = function()
    TB.Visible = true
    F.Visible = true
end

TB.MouseButton1Click:Connect(function() F.Visible = not F.Visible end)
CB.MouseButton1Click:Connect(function() F.Visible = false end)

local d, ds, sp = false, nil, nil
T.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        d = true; ds = i.Position; sp = F.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local dl = i.Position - ds
        F.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        d = false
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then F.Visible = not F.Visible end
end)

-- ===== LOADING =====
TweenService:Create(BF, TweenInfo.new(3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.spawn(function()
    local steps = {
        {0.2, "Đang khởi tạo..."},
        {0.4, "Đang tải module..."},
        {0.6, "Đang kết nối..."},
        {0.8, "Đang chuẩn bị menu..."},
        {1,   "Hoàn tất!"}
    }
    for _, s in ipairs(steps) do
        task.wait(0.6)
        PT.Text = math.floor(s[1] * 100) .. "%"
        LS.Text = s[2]
    end
    task.wait(0.3)
    TweenService:Create(Box, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BS, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(BG, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    for _, o in ipairs(Box:GetDescendants()) do
        if o:IsA("TextLabel") or o:IsA("Frame") then
            pcall(function()
                TweenService:Create(o, TweenInfo.new(0.4), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            end)
        end
    end
    task.wait(0.45)
    LG:Destroy()
    if _G.OpenMyMenu then _G.OpenMyMenu() end
end)

-- ============================================
--  FRUIT SNIPER - CHỌN TRÁI + HOP AN TOÀN
--  Tránh server VIP/đầy, tự động nhặt trái
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- ===== CẤU HÌNH =====
local CONFIG = {
    AutoHop = true,
    HopDelay = 10,          -- Tăng delay để tránh bị chặn
    AutoCollect = true,
    SelectedFruits = {"Dough", "Dragon", "Leopard", "Kitsune", "Venom", "Shadow", "Control", "Spirit"},
    VisitedServers = {},
    MaxPlayersThreshold = 0.9  -- Chỉ vào server còn dưới 90% sức chứa
}

-- Xóa GUI cũ
for _, n in ipairs({"FruitSniperGUI", "MyLoadingGUI"}) do
    local o = CoreGui:FindFirstChild(n)
    if o then o:Destroy() end
end

-- ===== HTTP AN TOÀN (CHO DELTA) =====
local _rawHttp = nil
pcall(function() if request then _rawHttp = request end end)
pcall(function() if not _rawHttp and syn and syn.request then _rawHttp = syn.request end end)

local function safeGet(url)
    if _rawHttp then
        local result, done = nil, false
        task.spawn(function()
            local ok, res = pcall(_rawHttp, {Url = url, Method = "GET"})
            if ok then result = res end
            done = true
        end)
        local t0 = tick()
        while not done and tick() - t0 < 5 do task.wait(0.1) end
        return result and result.Body or ""
    else
        local ok, res = pcall(game.HttpGet, game, url)
        return ok and res or ""
    end
end

-- ===== HÀM TÌM TRÁI =====
local function isSelected(fruitName)
    for _, f in ipairs(CONFIG.SelectedFruits) do
        if fruitName:lower():find(f:lower()) then return true end
    end
    return false
end

local function findFruits()
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Tool") or obj:IsA("Model")) and obj.Name:find("Fruit") then
            if isSelected(obj.Name) then
                table.insert(found, obj)
            end
        end
    end
    return found
end

-- ===== AUTO NHẶT TRÁI =====
local function collectFruit(fruit)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local part = fruit:IsA("Tool") and fruit:FindFirstChild("Handle") or fruit:FindFirstChild("Handle") or fruit
    if part and part:IsA("BasePart") then
        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.3)
        if firetouchinterest then
            pcall(function()
                firetouchinterest(hrp, part, 0)
                task.wait(0.1)
                firetouchinterest(hrp, part, 1)
            end)
        end
    end
end

-- ===== SERVER HOP AN TOÀN =====
local function serverHop()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local body = safeGet(url)
    if body == "" then return false end
    
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or not data or not data.data then return false end
    
    local validServers = {}
    for _, s in ipairs(data.data) do
        -- LỌC KỸ:
        -- 1. Server còn chỗ (không đầy)
        -- 2. Không phải server hiện tại
        -- 3. Chưa từng ghé thăm
        -- 4. Số người chơi dưới ngưỡng (tránh server sắp đầy)
        local fillRatio = s.playing / s.maxPlayers
        if s.playing < s.maxPlayers 
           and s.id ~= game.JobId 
           and not table.find(CONFIG.VisitedServers, s.id)
           and fillRatio < CONFIG.MaxPlayersThreshold
        then
            table.insert(validServers, s.id)
        end
    end
    
    if #validServers > 0 then
        local chosen = validServers[math.random(1, #validServers)]
        table.insert(CONFIG.VisitedServers, chosen)
        
        local success = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen, LP)
        end)
        return success
    end
    return false
end

-- ===== LOADING SCREEN =====
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
LT.Text = "Fruit Sniper"
LT.TextColor3 = Color3.fromRGB(0, 170, 255)
LT.Font = Enum.Font.GothamBold
LT.TextSize = 24

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

-- ===== GUI CHÍNH =====
local SG = Instance.new("ScreenGui")
SG.Name = "FruitSniperGUI"
SG.ResetOnSpawn = false
SG.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton", SG)
ToggleBtn.Size = UDim2.new(0, 130, 0, 38)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "🍎 Fruit Sniper"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local F = Instance.new("Frame", SG)
F.Size = UDim2.new(0, 480, 0, 450)
F.Position = UDim2.new(0.5, -240, 0.5, -225)
F.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
F.BorderSizePixel = 0
F.Visible = false
Instance.new("UICorner", F).CornerRadius = UDim.new(0, 14)

local FS = Instance.new("UIStroke", F)
FS.Color = Color3.fromRGB(0, 120, 215)
FS.Thickness = 2

local Title = Instance.new("TextLabel", F)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "  🍎 FRUIT SNIPER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BorderSizePixel = 0
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 14)

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local Status = Instance.new("TextLabel", F)
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.new(0, 10, 0, 50)
Status.BackgroundTransparency = 1
Status.Text = "Sẵn sàng..."
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", F)
Scroll.Size = UDim2.new(1, -20, 1, -160)
Scroll.Position = UDim2.new(0, 10, 0, 85)
Scroll.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", Scroll).CornerRadius = UDim.new(0, 8)

local GL = Instance.new("UIGridLayout", Scroll)
GL.CellSize = UDim2.new(0.5, -6, 0, 36)
GL.CellPadding = UDim2.new(0, 6, 0, 6)
GL.SortOrder = Enum.SortOrder.LayoutOrder

local Pad = Instance.new("UIPadding", Scroll)
Pad.PaddingTop = UDim.new(0, 8)
Pad.PaddingLeft = UDim.new(0, 8)
Pad.PaddingRight = UDim.new(0, 8)

-- Danh sách trái
local AllFruits = {
    "Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike", "Flame",
    "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light", "Rubber", "Barrier",
    "Magma", "Door", "Quake", "Buddha", "Love", "Spider", "Sound", "Phoenix",
    "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex",
    "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune", "Yeti", "Gas"
}

local fruitBtns = {}
local function createBtn(name)
    local b = Instance.new("TextButton", Scroll)
    b.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = name
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    if isSelected(name) then b.BackgroundColor3 = Color3.fromRGB(0, 170, 80) end
    b.MouseButton1Click:Connect(function()
        local found = false
        for i, f in ipairs(CONFIG.SelectedFruits) do
            if f == name then table.remove(CONFIG.SelectedFruits, i) found = true break end
        end
        if not found then table.insert(CONFIG.SelectedFruits, name) end
        b.BackgroundColor3 = found and Color3.fromRGB(42, 42, 52) or Color3.fromRGB(0, 170, 80)
        Status.Text = "Đã chọn " .. #CONFIG.SelectedFruits .. " trái"
        Status.TextColor3 = Color3.fromRGB(0, 255, 100)
    end)
    fruitBtns[name] = b
end

for _, fruit in ipairs(AllFruits) do createBtn(fruit) end
Scroll.CanvasSize = UDim2.new(0, 0, 0, GL.AbsoluteContentSize.Y + 20)

local CtrlFrame = Instance.new("Frame", F)
CtrlFrame.Size = UDim2.new(1, -20, 0, 50)
CtrlFrame.Position = UDim2.new(0, 10, 1, -60)
CtrlFrame.BackgroundTransparency = 1

local function mkCtrl(txt, x, color, cb)
    local b = Instance.new("TextButton", CtrlFrame)
    b.Size = UDim2.new(0.33, -4, 1, 0)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(cb)
end

mkCtrl("⚡ Hop Ngay", 0, Color3.fromRGB(0, 120, 215), function()
    Status.Text = "Đang hop..."
    Status.TextColor3 = Color3.fromRGB(0, 170, 255)
    if not serverHop() then
        Status.Text = "Hop thất bại"
        Status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

mkCtrl("✅ Chọn tất cả", 0.33, Color3.fromRGB(0, 170, 80), function()
    CONFIG.SelectedFruits = {}
    for _, f in ipairs(AllFruits) do
        table.insert(CONFIG.SelectedFruits, f)
        if fruitBtns[f] then fruitBtns[f].BackgroundColor3 = Color3.fromRGB(0, 170, 80) end
    end
    Status.Text = "Đã chọn tất cả"
    Status.TextColor3 = Color3.fromRGB(0, 255, 100)
end)

mkCtrl("❌ Bỏ chọn", 0.66, Color3.fromRGB(220, 50, 50), function()
    CONFIG.SelectedFruits = {}
    for _, b in pairs(fruitBtns) do b.BackgroundColor3 = Color3.fromRGB(42, 42, 52) end
    Status.Text = "Đã bỏ chọn"
    Status.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- ===== VÒNG LẶP CHÍNH =====
task.spawn(function()
    while task.wait(3) do
        local fruits = findFruits()
        if #fruits > 0 then
            Status.Text = "🍎 Tìm thấy " .. #fruits .. " trái!"
            Status.TextColor3 = Color3.fromRGB(0, 255, 100)
            if CONFIG.AutoCollect then
                for _, f in ipairs(fruits) do
                    collectFruit(f)
                    task.wait(0.5)
                end
            end
        else
            Status.Text = "Không có trái. Đang hop..."
            Status.TextColor3 = Color3.fromRGB(255, 180, 0)
            if CONFIG.AutoHop then
                task.wait(CONFIG.HopDelay)
                serverHop()
            end
        end
    end
end)

-- ===== SỰ KIỆN =====
_G.OpenMyMenu = function()
    ToggleBtn.Visible = true
    F.Visible = true
end

ToggleBtn.MouseButton1Click:Connect(function() F.Visible = not F.Visible end)
CloseBtn.MouseButton1Click:Connect(function() F.Visible = false end)

local d, ds, sp = false, nil, nil
Title.InputBegan:Connect(function(i)
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

print("✅ Fruit Sniper loaded!")

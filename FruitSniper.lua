-- ============================================
--  FRUIT SNIPER - CHỌN TRÁI + AUTO HOP
--  Tự viết, không phụ thuộc hub
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ===== CẤU HÌNH =====
local CONFIG = {
    AutoHop = true,
    HopDelay = 5,
    AutoCollect = true,
    SelectedFruits = {"Dough", "Dragon", "Leopard", "Kitsune", "Venom", "Shadow"},
    AllFruits = {
        "Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike", "Flame",
        "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light", "Rubber", "Barrier",
        "Magma", "Door", "Quake", "Buddha", "Love", "Spider", "Sound", "Phoenix",
        "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex",
        "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune", "Yeti", "Gas"
    }
}

-- Xóa GUI cũ
for _, n in ipairs({"FruitSniperGUI", "FruitESP"}) do
    local o = CoreGui:FindFirstChild(n)
    if o then o:Destroy() end
end

-- ===== HTTP TIMEOUT PATCH (Delta fix) =====
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
        -- Kích hoạt nhặt
        if firetouchinterest then
            pcall(function()
                firetouchinterest(hrp, part, 0)
                task.wait(0.1)
                firetouchinterest(hrp, part, 1)
            end)
        end
    end
end

-- ===== SERVER HOP =====
local function serverHop()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local body = safeGet(url)
    if body == "" then return false end
    
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or not data or not data.data then return false end
    
    local servers = {}
    for _, s in ipairs(data.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            table.insert(servers, s.id)
        end
    end
    
    if #servers > 0 then
        local chosen = servers[math.random(1, #servers)]
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen, LP)
        end)
        return true
    end
    return false
end

-- ===== GUI =====
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
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local F = Instance.new("Frame", SG)
F.Size = UDim2.new(0, 480, 0, 450)
F.Position = UDim2.new(0.5, -240, 0.5, -225)
F.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
F.BorderSizePixel = 0
F.Visible = false
Instance.new("UICorner", F).CornerRadius = UDim.new(0, 14)

local FStroke = Instance.new("UIStroke", F)
FStroke.Color = Color3.fromRGB(0, 120, 215)
FStroke.Thickness = 2

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
Status.Text = "Chọn trái muốn nhặt ↓"
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
    
    -- Kiểm tra đã chọn chưa
    if isSelected(name) then
        b.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    end
    
    b.MouseButton1Click:Connect(function()
        local found = false
        for i, f in ipairs(CONFIG.SelectedFruits) do
            if f == name then
                table.remove(CONFIG.SelectedFruits, i)
                found = true
                break
            end
        end
        if not found then
            table.insert(CONFIG.SelectedFruits, name)
        end
        b.BackgroundColor3 = found and Color3.fromRGB(42, 42, 52) or Color3.fromRGB(0, 170, 80)
        Status.Text = "✅ Đã chọn " .. #CONFIG.SelectedFruits .. " trái"
        Status.TextColor3 = Color3.fromRGB(0, 255, 100)
    end)
    
    fruitBtns[name] = b
end

for _, fruit in ipairs(CONFIG.AllFruits) do
    createBtn(fruit)
end

Scroll.CanvasSize = UDim2.new(0, 0, 0, GL.AbsoluteContentSize.Y + 20)

-- Nút điều khiển
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
    Status.Text = "⚡ Đang hop..."
    Status.TextColor3 = Color3.fromRGB(0, 170, 255)
    if not serverHop() then
        Status.Text = "❌ Hop thất bại"
        Status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

mkCtrl("✅ Chọn tất cả", 0.33, Color3.fromRGB(0, 170, 80), function()
    CONFIG.SelectedFruits = {}
    for _, fruit in ipairs(CONFIG.AllFruits) do
        table.insert(CONFIG.SelectedFruits, fruit)
        if fruitBtns[fruit] then
            fruitBtns[fruit].BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        end
    end
    Status.Text = "✅ Đã chọn tất cả"
    Status.TextColor3 = Color3.fromRGB(0, 255, 100)
end)

mkCtrl("❌ Bỏ chọn", 0.66, Color3.fromRGB(220, 50, 50), function()
    CONFIG.SelectedFruits = {}
    for _, b in pairs(fruitBtns) do
        b.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    end
    Status.Text = "Đã bỏ chọn tất cả"
    Status.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- ===== VÒNG LẶP CHÍNH =====
task.spawn(function()
    while task.wait(2) do
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
            Status.Text = "❌ Không có trái. Đang hop..."
            Status.TextColor3 = Color3.fromRGB(255, 180, 0)
            
            if CONFIG.AutoHop then
                task.wait(CONFIG.HopDelay)
                serverHop()
            end
        end
    end
end)

-- ===== SỰ KIỆN =====
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

print("✅ Fruit Sniper loaded!")

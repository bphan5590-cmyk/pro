-- ============================================
--  BLOX FRUITS - FRUIT SNIPER (CHỌN TRÁI)
--  Chọn trái muốn nhặt + auto hop
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- DANH SÁCH TRÁI TRONG BLOX FRUITS
local FRUIT_LIST = {
    -- Common
    "Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike", "Flame",
    -- Uncommon
    "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light", "Rubber", "Barrier",
    -- Rare
    "Magma", "Door", "Quake", "Buddha", "Love", "Spider", "Sound", "Phoenix",
    -- Legendary
    "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex",
    -- Mythical
    "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune", "Yeti", "Gas"
}

-- Cấu hình
local CONFIG = {
    AutoHop = true,
    HopDelay = 3,
    ShowESP = true,
    SelectedFruits = {} -- Trái bạn muốn nhặt
}

for _, name in ipairs({"FruitSniperGUI", "FruitESP"}) do
    local old = CoreGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- ===== GUI CHÍNH =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitSniperGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Nút mở menu
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 130, 0, 38)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "🍎 Fruit Sniper"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 0
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Khung menu chính
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local FS = Instance.new("UIStroke", MainFrame)
FS.Color = Color3.fromRGB(0, 120, 215)
FS.Thickness = 2

-- Thanh tiêu đề
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "  🍎 FRUIT SNIPER - CHỌN TRÁI"
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

-- Status
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Chưa chọn trái nào"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Scroll chứa danh sách trái
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -150)
Scroll.Position = UDim2.new(0, 10, 0, 85)
Scroll.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", Scroll).CornerRadius = UDim.new(0, 8)

local ListLayout = Instance.new("UIGridLayout", Scroll)
ListLayout.CellSize = UDim2.new(0.5, -6, 0, 36)
ListLayout.CellPadding = UDim2.new(0, 6, 0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Padding = Instance.new("UIPadding", Scroll)
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 8)
Padding.PaddingRight = UDim.new(0, 8)

-- Hàm tạo nút trái
local fruitButtons = {}
local function createFruitBtn(fruitName)
    local btn = Instance.new("TextButton", Scroll)
    btn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = fruitName
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        -- Toggle chọn/bỏ chọn
        local found = false
        for i, f in ipairs(CONFIG.SelectedFruits) do
            if f == fruitName then
                table.remove(CONFIG.SelectedFruits, i)
                found = true
                break
            end
        end
        if not found then
            table.insert(CONFIG.SelectedFruits, fruitName)
        end
        
        -- Cập nhật màu
        if found then
            btn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
        else
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        end
        
        -- Cập nhật status
        if #CONFIG.SelectedFruits > 0 then
            StatusLabel.Text = "✅ Đã chọn: " .. table.concat(CONFIG.SelectedFruits, ", ")
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            StatusLabel.Text = "Chưa chọn trái nào"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    fruitButtons[fruitName] = btn
end

-- Tạo nút cho từng trái
for _, fruit in ipairs(FRUIT_LIST) do
    createFruitBtn(fruit)
end

Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)

-- Nút điều khiển
local ControlFrame = Instance.new("Frame", MainFrame)
ControlFrame.Size = UDim2.new(1, -20, 0, 50)
ControlFrame.Position = UDim2.new(0, 10, 1, -60)
ControlFrame.BackgroundTransparency = 1

local function mkCtrlBtn(txt, xPos, color, callback)
    local b = Instance.new("TextButton", ControlFrame)
    b.Size = UDim2.new(0.33, -4, 1, 0)
    b.Position = UDim2.new(xPos, 0, 0, 0)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
    return b
end

mkCtrlBtn("⚡ Server Hop", 0, Color3.fromRGB(0, 120, 215), function()
    StatusLabel.Text = "⚡ Đang chuyển server..."
    local function hop()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local ok, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if ok and response and response.data then
            local servers = {}
            for _, s in ipairs(response.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LP)
            end
        end
    end
    hop()
end)

mkCtrlBtn("✅ Chọn tất cả", 0.33, Color3.fromRGB(0, 170, 80), function()
    for _, fruit in ipairs(FRUIT_LIST) do
        local found = false
        for _, f in ipairs(CONFIG.SelectedFruits) do
            if f == fruit then found = true break end
        end
        if not found then
            table.insert(CONFIG.SelectedFruits, fruit)
        end
        if fruitButtons[fruit] then
            fruitButtons[fruit].BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        end
    end
    StatusLabel.Text = "✅ Đã chọn tất cả trái"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
end)

mkCtrlBtn("❌ Bỏ chọn", 0.66, Color3.fromRGB(220, 50, 50), function()
    CONFIG.SelectedFruits = {}
    for _, btn in pairs(fruitButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    end
    StatusLabel.Text = "Đã bỏ chọn tất cả"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- ===== ESP TRÁI =====
local espFolder = Instance.new("Folder", ScreenGui)
espFolder.Name = "FruitESP"

local function isFruitSelected(name)
    if #CONFIG.SelectedFruits == 0 then return true end
    for _, f in ipairs(CONFIG.SelectedFruits) do
        if name:lower():find(f:lower()) then return true end
    end
    return false
end

local function createESP(fruit)
    if not fruit:IsA("BasePart") and not fruit:IsA("Tool") then return end
    local part = fruit:IsA("Tool") and fruit:FindFirstChild("Handle") or fruit
    if not part or not part:IsA("BasePart") then return end
    
    if espFolder:FindFirstChild(fruit:GetFullName()) then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = fruit:GetFullName()
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder
    billboard.Adornee = part
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🍎 " .. fruit.Name
    label.TextColor3 = Color3.fromRGB(255, 200, 0)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
end

-- Vòng lặp ESP
task.spawn(function()
    while task.wait(1) do
        if CONFIG.ShowESP then
            -- Xóa ESP cũ
            for _, esp in ipairs(espFolder:GetChildren()) do
                esp:Destroy()
            end
            
            -- Tạo ESP mới cho trái
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name:find("Fruit") and (obj:IsA("Tool") or obj:IsA("Model")) then
                    if isFruitSelected(obj.Name) then
                        createESP(obj)
                    end
                end
            end
        end
    end
end)

-- ===== AUTO HOP =====
task.spawn(function()
    while task.wait(3) do
        if CONFIG.AutoHop and #CONFIG.SelectedFruits > 0 then
            -- Tìm trái trong danh sách đã chọn
            local found = false
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name:find("Fruit") and (obj:IsA("Tool") or obj:IsA("Model")) then
                    if isFruitSelected(obj.Name) then
                        found = true
                        break
                    end
                end
            end
            
            if not found then
                StatusLabel.Text = "🔍 Không có trái. Đang hop..."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
                
                local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                local ok, response = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(url))
                end)
                if ok and response and response.data then
                    local servers = {}
                    for _, s in ipairs(response.data) do
                        if s.playing < s.maxPlayers and s.id ~= game.JobId then
                            table.insert(servers, s.id)
                        end
                    end
                    if #servers > 0 then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LP)
                    end
                end
                task.wait(CONFIG.HopDelay)
            else
                StatusLabel.Text = "✅ Đã tìm thấy trái!"
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                CONFIG.AutoHop = false
            end
        end
    end
end)

-- ===== SỰ KIỆN =====
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Kéo thả
local dragging, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("✅ Fruit Sniper loaded! Chọn trái muốn nhặt trong menu.")

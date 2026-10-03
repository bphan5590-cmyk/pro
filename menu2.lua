local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local autoAttack = false
local attackRange = 20

for _, n in ipairs({"MyLoadingGUI", "MyMenuScript"}) do
    local o = CoreGui:FindFirstChild(n)
    if o then o:Destroy() end
end

local function getHum()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid", 5)
end

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
LT.Text = "🎮 MENU SCRIPT"
LT.TextColor3 = Color3.fromRGB(0, 170, 255)
LT.Font = Enum.Font.GothamBold
LT.TextSize = 22

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
TB.Text = "⚙️ MENU"
TB.Font = Enum.Font.GothamBold
TB.TextSize = 15
TB.BorderSizePixel = 0
TB.Visible = false
Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 8)

local F = Instance.new("Frame", SG)
F.Size = UDim2.new(0, 280, 0, 510)
F.Position = UDim2.new(0.5, -140, 0.5, -255)
F.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
F.BorderSizePixel = 0
F.Visible = false
Instance.new("UICorner", F).CornerRadius = UDim.new(0, 12)

local FS = Instance.new("UIStroke", F)
FS.Color = Color3.fromRGB(0, 120, 215)
FS.Thickness = 1.5

local T = Instance.new("TextLabel", F)
T.Size = UDim2.new(1, 0, 0, 42)
T.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
T.Text = "🎮 MENU SCRIPT"
T.TextColor3 = Color3.fromRGB(255, 255, 255)
T.Font = Enum.Font.GothamBold
T.TextSize = 16
T.BorderSizePixel = 0
Instance.new("UICorner", T).CornerRadius = UDim.new(0, 12)

local CB = Instance.new("TextButton", T)
CB.Size = UDim2.new(0, 30, 0, 30)
CB.Position = UDim2.new(1, -35, 0, 6)
CB.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CB.TextColor3 = Color3.fromRGB(255, 255, 255)
CB.Text = "✕"
CB.Font = Enum.Font.GothamBold
CB.TextSize = 16
CB.BorderSizePixel = 0
Instance.new("UICorner", CB).CornerRadius = UDim.new(0, 6)

local function mkBtn(txt, y, cb)
    local b = Instance.new("TextButton", F)
    b.Size = UDim2.new(0, 240, 0, 40)
    b.Position = UDim2.new(0, 20, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = txt
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(0, 120, 215) end)
    b.MouseLeave:Connect(function()
        if b.Text:find("BẬT") then
            b.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        else
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        end
    end)
    b.MouseButton1Click:Connect(cb)
    return b
end

mkBtn("⚡ Tốc độ x2", 60, function()
    local hum = getHum()
    if hum then hum.WalkSpeed = 32 end
end)

mkBtn("🏃 Tốc độ thường", 110, function()
    local hum = getHum()
    if hum then hum.WalkSpeed = 16 end
end)

mkBtn("🦘 Nhảy cao", 160, function()
    local hum = getHum()
    if hum then hum.JumpPower = 100 end
end)

mkBtn("❤️ Hồi máu", 210, function()
    local hum = getHum()
    if hum then hum.Health = hum.MaxHealth end
end)

-- ===== ĐÁNH =====
local attackBtn = mkBtn("⚔️ Đánh: TẮT", 260, function()
    autoAttack = not autoAttack
    if autoAttack then
        attackBtn.Text = "⚔️ Đánh: BẬT"
        attackBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    else
        attackBtn.Text = "⚔️ Đánh: TẮT"
        attackBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if autoAttack then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local closest, dist = nil, attackRange
                for _, v in ipairs(workspace:GetChildren()) do
                    local enemyHum = v:FindFirstChildOfClass("Humanoid")
                    local enemyRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("UpperTorso") or v:FindFirstChild("Torso")
                    if enemyHum and enemyRoot and v ~= char and enemyHum.Health > 0 then
                        local d = (enemyRoot.Position - hrp.Position).Magnitude
                        if d < dist then
                            closest = enemyRoot
                            dist = d
                        end
                    end
                end
                if closest then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:MoveTo(closest.Position) end
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- ===== ĐỊNH VỊ =====
local function teleportTo(target)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        hrp.CFrame = CFrame.new(target) + Vector3.new(0, 3, 0)
    end)
end

mkBtn("📍 Định vị", 310, function()
    local tpGui = Instance.new("ScreenGui")
    tpGui.Name = "MyTeleportGUI"
    tpGui.ResetOnSpawn = false
    tpGui.Parent = CoreGui
    
    local tpFrame = Instance.new("Frame")
    tpFrame.Size = UDim2.new(0, 260, 0, 220)
    tpFrame.Position = UDim2.new(0.5, -130, 0.5, -110)
    tpFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    tpFrame.BorderSizePixel = 0
    tpFrame.Parent = tpGui
    Instance.new("UICorner", tpFrame).CornerRadius = UDim.new(0, 10)
    
    local tpStroke = Instance.new("UIStroke", tpFrame)
    tpStroke.Color = Color3.fromRGB(0, 170, 255)
    tpStroke.Thickness = 1.5
    
    local tpTitle = Instance.new("TextLabel", tpFrame)
    tpTitle.Size = UDim2.new(1, 0, 0, 35)
    tpTitle.BackgroundTransparency = 1
    tpTitle.Text = "📍 ĐỊNH VỊ"
    tpTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
    tpTitle.Font = Enum.Font.GothamBold
    tpTitle.TextSize = 16
    
    local function mkInput(placeholder, y)
        local box = Instance.new("TextBox", tpFrame)
        box.Size = UDim2.new(0, 220, 0, 35)
        box.Position = UDim2.new(0, 20, 0, y)
        box.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.PlaceholderText = placeholder
        box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        box.Text = ""
        box.Font = Enum.Font.Gotham
        box.TextSize = 13
        box.BorderSizePixel = 0
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        return box
    end
    
    local xBox = mkInput("X (VD: 100)", 45)
    local yBox = mkInput("Y (VD: 50)", 85)
    local zBox = mkInput("Z (VD: 200)", 125)
    
    local tpBtn = Instance.new("TextButton", tpFrame)
    tpBtn.Size = UDim2.new(0, 100, 0, 30)
    tpBtn.Position = UDim2.new(0, 20, 0, 175)
    tpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.Text = "Dịch chuyển"
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 13
    tpBtn.BorderSizePixel = 0
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
    
    local closeTp = Instance.new("TextButton", tpFrame)
    closeTp.Size = UDim2.new(0, 100, 0, 30)
    closeTp.Position = UDim2.new(0, 140, 0, 175)
    closeTp.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeTp.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeTp.Text = "Đóng"
    closeTp.Font = Enum.Font.GothamBold
    closeTp.TextSize = 13
    closeTp.BorderSizePixel = 0
    Instance.new("UICorner", closeTp).CornerRadius = UDim.new(0, 6)
    
    tpBtn.MouseButton1Click:Connect(function()
        local x = tonumber(xBox.Text)
        local y = tonumber(yBox.Text)
        local z = tonumber(zBox.Text)
        if x and y and z then
            teleportTo(Vector3.new(x, y, z))
        end
    end)
    
    closeTp.MouseButton1Click:Connect(function()
        tpGui:Destroy()
    end)
end)

mkBtn("🔄 Reset nhân vật", 360, function()
    local char = LP.Character
    if char then char:BreakJoints() end
end)

mkBtn("❌ Đóng Menu", 410, function()
    F.Visible = false
end)

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

-- Loading
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

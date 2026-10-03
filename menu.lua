local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

for _, n in ipairs({"MyLoadingGUI", "MyMenuScript"}) do
    local o = CoreGui:FindFirstChild(n)
    if o then o:Destroy() end
end

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
F.Size = UDim2.new(0, 280, 0, 380)
F.Position = UDim2.new(0.5, -140, 0.5, -190)
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
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(45, 45, 55) end)
    b.MouseButton1Click:Connect(cb)
end

mkBtn("⚡ Tốc độ x2", 60, function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 32
    end
end)
mkBtn("🏃 Tốc độ thường", 110, function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 16
    end
end)
mkBtn("🦘 Nhảy cao", 160, function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = 100
    end
end)
mkBtn("❤️ Hồi máu", 210, function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
    end
end)
mkBtn("🔄 Reset nhân vật", 260, function()
    if LP.Character then LP.Character:BreakJoints() end
end)
mkBtn("❌ Đóng Menu", 310, function()
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

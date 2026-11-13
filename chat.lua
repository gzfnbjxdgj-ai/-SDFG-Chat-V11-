-- ★ SDFG GLOBAL CHAT V11.0 - MOBILE DELTA FIXED ★
print("════════ [SDFG GLOBAL CHAT V11.0] ════════")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local localPlayer = Players.LocalPlayer

-- حماية وتحديد المكان الأنسب للواجهة في الجوال (لتجنب الحظر أو الإخفاء)
local successGui, guiParent = pcall(function()
    return gethui and gethui() or CoreGui
end)
if not successGui or not guiParent then
    guiParent = localPlayer:WaitForChild("PlayerGui")
end

local lastMsgTime = 0

-- جدول ألوان مميزة لأسماء اللاعبين
local userColors = {"#00FF88", "#FF5555", "#FFFF55", "#FF55FF", "#55FFFF", "#FFAA00", "#FF8800"}
local function getUserColor(name)
    local hash = 0
    for i = 1, #name do
        hash = hash + string.byte(name, i)
    end
    return userColors[(hash % #userColors) + 1]
end

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SDFG_GlobalChat_V11"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false

-- ==================== الزر العائم (مع نظام التنبيهات) ====================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.015, 0, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.TextColor3 = Color3.fromRGB(0, 162, 255)
ToggleButton.Text = "💬"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 20
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

-- إطار الشات الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 260) -- تصغير حجمه قليلاً ليتناسب مع شاشات الجوال
MainFrame.Position = UDim2.new(0.08, 0, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- وظيفة زر الإظهار/الإخفاء
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        ToggleButton.TextColor3 = Color3.fromRGB(0, 162, 255)
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- شريط العنوان
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TitleBar.TextColor3 = Color3.fromRGB(0, 162, 255)
TitleBar.Text = "  ✦ تيم المطورين SDFG ✦"
TitleBar.Font = Enum.Font.GothamBlack
TitleBar.TextSize = 14
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

-- زر مسح الشات
local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0, 55, 0, 24)
ClearBtn.Position = UDim2.new(1, -60, 0, 5)
ClearBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Text = "مسح"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 12
ClearBtn.Parent = TitleBar
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 6)

-- قائمة الرسائل
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -90)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollingFrame

-- حقل الإدخال
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -95, 0, 35)
TextBox.Position = UDim2.new(0, 10, 1, -45)
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "اكتب رسالتك هنا..."
TextBox.Text = ""
TextBox.TextSize = 13
TextBox.Font = Enum.Font.Gotham
TextBox.Parent = MainFrame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)

-- زر الإرسال
local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0, 75, 0, 35)
SendButton.Position = UDim2.new(1, -85, 1, -45)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Text = "إرسال"
SendButton.Font = Enum.Font.GothamBold
SendButton.TextSize = 13
SendButton.Parent = MainFrame
Instance.new("UICorner", SendButton).CornerRadius = UDim.new(0, 8)

-- دالة مسح الشات
local function clearChat()
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

ClearBtn.MouseButton1Click:Connect(clearChat)

-- دالة إضافة رسالة للواجهة
local function addMessageToUI(sender, message, isMe)
    local timeStr = os.date("%H:%M")
    local nameColor = isMe and "#00A2FF" or getUserColor(sender)
    
    if not MainFrame.Visible and not isMe then
        ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        pcall(function()
            local sound = Instance.new("Sound")
            sound

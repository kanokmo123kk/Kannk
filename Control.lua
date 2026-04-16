-- อ้างอิงบริการที่จำเป็น
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- สร้าง UI
local ControlGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")

ControlGui.Name = "ControlGui"
ControlGui.Parent = plr.PlayerGui
ControlGui.ResetOnSpawn = false -- ให้ UI ยังอยู่แม้เราจะตาย

Frame.Parent = ControlGui
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- เปลี่ยนสีให้ดูดีขึ้นหน่อย
Frame.Position = UDim2.new(0, 300, 0, 200)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Active = true
Frame.Draggable = true

TextButton.Parent = Frame
TextButton.Position = UDim2.new(0, 50, 0, 90)
TextButton.Size = UDim2.new(0, 200, 0, 50)
TextButton.Text = "Control"
TextButton.TextSize = 25

TextBox.Parent = Frame
TextBox.Position = UDim2.new(0, 50, 0, 20)
TextBox.Size = UDim2.new(0, 200, 0, 30)
TextBox.Text = "Enter Name"

-- ฟังก์ชันสำหรับสร้าง Weld แบบปลอดภัย
local function createWeld(p0, p1, name)
    if p0 and p1 then
        local w = Instance.new("Weld")
        w.Name = name
        w.Part0 = p0
        w.Part1 = p1
        w.Parent = workspace
        return w
    end
end

TextButton.MouseButton1Click:Connect(function()
    local targetName = TextBox.Text
    local targetChar = workspace:FindFirstChild(targetName)
    local myChar = plr.Character

    if not targetChar or not myChar then 
        warn("ไม่พบตัวละครเป้าหมายหรือตัวเรา")
        return 
    end

    if TextButton.Text == "Control" then
        TextButton.Text = "UnControl"
        
        -- หยุดการขยับของเป้าหมาย
        if targetChar:FindFirstChild("Humanoid") then
            targetChar.Humanoid.PlatformStand = true
        end

        -- เชื่อมส่วนต่างๆ (ตัวอย่างนี้เน้นส่วนหลักๆ)
        local parts = {"Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        for _, partName in pairs(parts) do
            if myChar:FindFirstChild(partName) and targetChar:FindFirstChild(partName) then
                createWeld(myChar[partName], targetChar[partName], "ControlWeld_"..partName)
            end
        end

        -- ทำให้ตัวเราล่องหน
        for _, v in pairs(myChar:GetChildren()) do
            if v:IsA("BasePart") then v.Transparency = 1 
            elseif v:IsA("Accessory") then v.Handle.Transparency = 1 end
        end

    else
        TextButton.Text = "Control"
        
        if targetChar:FindFirstChild("Humanoid") then
            targetChar.Humanoid.PlatformStand = false
        end

        -- ลบ Weld ทั้งหมดที่สร้างไว้
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name:sub(1, 12) == "ControlWeld_" then
                v:Destroy()
            end
        end

        -- ทำให้ตัวเรากลับมามองเห็น
        for _, v in pairs(myChar:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0 
            elseif v:IsA("Accessory") then v.Handle.Transparency = 0 end
        end
    end
end)

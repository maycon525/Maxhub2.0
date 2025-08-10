local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Botão fechar
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn)

-- Botão abrir (inicialmente invisível)
local openBtn = Instance.new("TextButton", gui)
openBtn.Text = "Abrir"
openBtn.Size = UDim2.new(0, 60, 0, 30)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", openBtn)
openBtn.Visible = false

-- Função criar botões
local function criarBotao(txt, y)
    local b = Instance.new("TextButton", frame)
    b.Text = txt
    b.Size = UDim2.new(0.8, 0, 0.12, 0)
    b.Position = UDim2.new(0.1, 0, y, 0)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b)
    return b
end

local p = game.Players.LocalPlayer
local function hum()
    return p.Character and p.Character:FindFirstChildWhichIsA("Humanoid")
end

-- Botões
local bSpeed = criarBotao("Speed", 0.15)
local bJump = criarBotao("Jump", 0.30)
local bFly = criarBotao("Fly", 0.45)
local bClip = criarBotao("NoClip", 0.60)
local bInvis = criarBotao("Invisibility", 0.75)

-- Funções
bSpeed.MouseButton1Click:Connect(function()
    local h = hum()
    if h then
        if h.WalkSpeed == 16 then
            h.WalkSpeed = 50
        else
            h.WalkSpeed = 16
        end
    end
end)

bJump.MouseButton1Click:Connect(function()
    local h = hum()
    if h then
        if h.JumpPower == 50 then
            h.JumpPower = 120
        else
            h.JumpPower = 50
        end
    end
end)

-- Fly
local flying = false
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local bp, bg
bFly.MouseButton1Click:Connect(function()
    flying = not flying
    local char = p.Character
    if flying then
        bp = Instance.new("BodyPosition", char.HumanoidRootPart)
        bp.MaxForce = Vector3.new(4000, 4000, 4000)
        bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.MaxTorque = Vector3.new(4000, 4000, 4000)
        RS:BindToRenderStep("fly", 0, function()
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
            bp.Position = bp.Position + dir * 2
        end)
    else
        RS:UnbindFromRenderStep("fly")
        if bp then bp:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- NoClip
local noclip = false
bClip.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        RS:BindToRenderStep("noclip", 1, function()
            for _, v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        RS:UnbindFromRenderStep("noclip")
    end
end)

-- Invisibilidade
local invis = false
bInvis.MouseButton1Click:Connect(function()
    if not p.Character then return end
    invis = not invis
    for _, part in pairs(p.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = invis and 1 or 0
        elseif part:IsA("Decal") then
            part.Transparency = invis and 1 or 0
        end
    end
end)

-- Fechar e abrir
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)

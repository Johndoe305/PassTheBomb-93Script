Enter-- carregar biblioteca
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- serviços
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- controle do toggle
local touchToggleEnabled = false

-- janela
local Window = Fluent:CreateWindow({
    Title = "Pass The Bomb Hub💣" .. Fluent.Version,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = {}

Tabs.Main = Window:AddTab({ Title = "Main", Icon = "home" })
Tabs.Player = Window:AddTab({ Title = "Player", Icon = "user" })
Tabs.Visual = Window:AddTab({ Title = "Visual", Icon = "eye" })
Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })


-- ===================== MAIN =====================
Tabs.Main:AddParagraph({
    Title = "scripts here",
    Content = "This is a paragraph.\nSecond line!"
})

Tabs.Main:AddButton({
    Title = "Pass The Bomb Mini Gui",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Johndoe305/PasstheBombMinigui/main/script.lua"))()
        end)
        if not success then
            warn("Erro ao executar Mini GUI:", err)
        end
    end
})

Tabs.Main:AddButton({
    Title = "Fe emote Script",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
        end)
        if not success then
            warn("Erro ao executar Mini GUI:", err)
        end
    end
})

Tabs.Main:AddButton({
    Title = "Noclip Gui",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-NOCLIP-GUI-43727"))()
        end)
        if not success then
            warn("Erro ao executar Mini GUI:", err)
        end
    end
})

Tabs.Main:AddButton({
    Title = "Dash Bomb To Player",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Johndoe305/MagneticBombScript/refs/heads/main/script.lua"))()
        end)
        if not success then
            warn("Erro ao executar Mini GUI:", err)
        end
    end
})

-- ===================== PLAYER TAB =====================

Tabs.Player:AddButton({
   Title = "Float",
   Callback = function()
       local success, err = pcall(function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/Johndoe305/Floatscript/main/script.lua"))()
       end)
       if not success then
           warn("Erro ao executar Float:", err)
       end
   end
})

-- ===================== INFINITE JUMP =====================

local UserInputService = game:GetService("UserInputService")

local infiniteJumpEnabled = false
local jumpConnection

Tabs.Player:AddToggle("InfiniteJumpToggle", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infiniteJumpEnabled = state

        if state then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = player.Character
                if not char then return end

                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end
})

-- ===================== VISUAL TAB =====================

-- CONTROLE
local espBombActive = false
local espObjects = {}

-- FUNÇÕES ESP
local function clearESP(tag)
    for _, v in pairs(espObjects) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    table.clear(espObjects)
end

local function createESP(hrp, color, tag)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_" .. tag
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.4
    box.Color3 = color
    box.Parent = hrp

    table.insert(espObjects, box)
end

-- TOGGLE ESP BOMB
Tabs.Visual:AddToggle("ESPBombToggle", {
    Title = "ESP Bomb",
    Default = false,
    Callback = function(state)
        espBombActive = state
        if not state then
            clearESP("bomb")
        end
    end
})

-- LOOP ESP BOMB
task.spawn(function()
    while task.wait(1) do
        if espBombActive then
            clearESP("bomb")

            for _, p in ipairs(Players:GetPlayers()) do
                local char = Workspace:FindFirstChild(p.Name)
                if char and char:FindFirstChild("Bomb") then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        createESP(hrp, Color3.new(1, 0, 0), "bomb")
                        break -- só 1 player com bomb
                    end
                end
            end
        end
    end
end)

-- ===================== ESP PLAYER =====================

local espPlayerActive = false

Tabs.Visual:AddToggle("ESPPlayerToggle", {
    Title = "ESP Player",
    Default = false,
    Callback = function(state)
        espPlayerActive = state
        if not state then
            clearESP("player")
        end
    end
})

-- *** ESP PLAYER FUNCIONAL PARA TODOS OS PLAYERS ***
task.spawn(function()
    while task.wait(0.5) do
        if espPlayerActive then
            clearESP("player")
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    local c = Workspace:FindFirstChild(p.Name)
                    if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") then
                        if c.Humanoid.Health > 0 then
                            createESP(c.HumanoidRootPart, Color3.new(0,1,0), "player")
                        end
                    end
                end
            end
        end
    end
end)

--// Botão flutuante para mobile (corrigido)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HubToggleGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.fromOffset(50, 50)
ToggleButton.Position = UDim2.fromOffset(20, 20)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "rbxassetid://7118978055"  -- Seu ícone
ToggleButton.Parent = ScreenGui

-- Função de toggle usando o método nativo do Fluent
local function toggleHub()
    if Window then
        Window:Minimize()  -- Isso abre e fecha o hub perfeitamente
    end
end

-- Conecta o clique
ToggleButton.MouseButton1Click:Connect(toggleHub)

-- Sistema de arrastar o botão (funciona no mobile e PC)
local dragging = false
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

-- Opcional: Começar com o hub minimizado (só o botão visível ao injetar)
-- Window:Minimize()

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("SpongeHub")
SaveManager:SetFolder("SpongeHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

--remove this⬇️

-- NOTIFICAÇÃO
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Made by Old Scripts";
    Text = "Script loaded";
    Icon = "rbxassetid://288817482"; -- icone de virus so pra dar um pouco de susto kkkk
    Duration = 6;
    Button1 = "OK";
    Callback = callback;
})

-- Somzinho de carregado
task.spawn(function()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://3023237993"
    s.Volume = 0.4
    s.Parent = game:GetService("SoundService")
    s:Play()
    task.delay(3, function() s:Destroy() end)
end)

print("[loaded]")

-- LOADING ANIMATION COM STEPS
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Criar GUI de Loading
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "HubLoadingGui"
LoadingGui.ResetOnSpawn = false
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGui.Parent = game:GetService("CoreGui")
LoadingGui.IgnoreGuiInset = true

-- Melhor versão do Background
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Background.BorderSizePixel = 0
Background.Parent = LoadingGui

-- Container centralizado corretamente
local Container = Instance.new("Frame")
Container.Size = UDim2.new(0.9, 0, 0.5, 0)
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.BackgroundTransparency = 1
Container.Parent = Background

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Pass The Bomb Hub💣"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.Parent = Container

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 60)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Loading..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = Container

local ProgressBarBG = Instance.new("Frame")
ProgressBarBG.Size = UDim2.new(1, 0, 0, 8)
ProgressBarBG.Position = UDim2.new(0, 0, 0, 110)
ProgressBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ProgressBarBG.BorderSizePixel = 0
ProgressBarBG.Parent = Container

local UICornerBG = Instance.new("UICorner")
UICornerBG.CornerRadius = UDim.new(0, 4)
UICornerBG.Parent = ProgressBarBG

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressBarBG

local UICornerBar = Instance.new("UICorner")
UICornerBar.CornerRadius = UDim.new(0, 4)
UICornerBar.Parent = ProgressBar

local ProgressGradient = Instance.new("UIGradient")
ProgressGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 170, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 170, 255))
}
ProgressGradient.Parent = ProgressBar

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, 0, 0, 30)
PercentLabel.Position = UDim2.new(0, 0, 0, 130)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(85, 170, 255)
PercentLabel.TextSize = 20
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.Parent = Container

-- Função para animar cada step
local function animateStep(percent, duration, statusText)
    StatusLabel.Text = statusText
    local tween = TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(percent / 100, 0, 1, 0)
    })
    tween:Play()

    local startPercent = tonumber(PercentLabel.Text:match("%d+")) or 0
    local startTime = tick()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.clamp(elapsed / duration, 0, 1)
        local currentPercent = math.floor(startPercent + (percent - startPercent) * progress)
        PercentLabel.Text = currentPercent .. "%"
        if progress >= 1 then
            connection:Disconnect()
        end
    end)
    tween.Completed:Wait()
end

-- Fade out
local function fadeOut()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    TweenService:Create(Background, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(Title, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(StatusLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(PercentLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(ProgressBarBG, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(ProgressBar, tweenInfo, {BackgroundTransparency = 1}):Play()
    task.wait(0.25)
    LoadingGui:Destroy()
end

-- Sequência de loading com steps
local function runLoadingSequence()
    local steps = {
        {1, 0.3, "Initializing..."},
        {20, 0.6, "Loading libraries..."},
        {40, 0.8, "Setting up interface..."},
        {60, 0.7, "Loading modules..."},
        {80, 0.6, "Finalizing..."},
        {100, 0.5, "Completed!"}
    }

    for _, step in ipairs(steps) do
        animateStep(step[1], step[2], step[3])
        task.wait(0.2)
    end

    TweenService:Create(ProgressBar, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(85, 255, 127)}):Play()
    TweenService:Create(PercentLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(85, 255, 127)}):Play()

    task.wait(0.8)

    -- === AQUI CARREGA O SEU SCRIPT PRINCIPAL ===
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Johndoe305/passthebomb/main/script.lua", true))()
    end)
    if not success then
        warn("Erro ao carregar o hub principal:", err)
    end

    fadeOut()
end

task.spawn(runLoadingSequence)

-- Função global para fechar se necessário
_G.HubLoadingComplete = function()
    if LoadingGui and LoadingGui.Parent then
        fadeOut()
    end
end

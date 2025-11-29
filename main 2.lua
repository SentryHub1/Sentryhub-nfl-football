-- =========================
-- NFL Universe Sentry Hub + Sentry Hub Ultimate Combined
-- Unified GUI, all features included
-- Key: SENTRY
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- SETTINGS
local KEY = "SENTRY"
local activeConnections = {}
local hitboxDefaults = {}

-- PLAYER SETTINGS
local walkSpeed, jumpPower = 20, 70
local flying, autoChase, hitboxExpanded = false, false, false
local flyVelocity = 50
local chaseStep = 5

-- =========================
-- GUI CREATION
-- =========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UnifiedSentryHub"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

-- KEY PANEL
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,300,0,180)
KeyFrame.Position = UDim2.new(0.5,0,0.5,0)
KeyFrame.AnchorPoint = Vector2.new(0.5,0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
local cornerKF = Instance.new("UICorner", KeyFrame)
cornerKF.CornerRadius = UDim.new(0,12)

local KeyLabel = Instance.new("TextLabel", KeyFrame)
KeyLabel.Size = UDim2.new(1,0,0,40)
KeyLabel.Position = UDim2.new(0,0,0,10)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Enter Sentry Hub Key"
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 18
KeyLabel.TextColor3 = Color3.fromRGB(255,255,255)

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0.8,0,0,30)
KeyBox.Position = UDim2.new(0.1,0,0.35,0)
KeyBox.PlaceholderText = "Key Here"
KeyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
local cornerBox = Instance.new("UICorner", KeyBox)
cornerBox.CornerRadius = UDim.new(0,8)

local SubmitButton = Instance.new("TextButton", KeyFrame)
SubmitButton.Size = UDim2.new(0.5,0,0,30)
SubmitButton.Position = UDim2.new(0.25,0,0.65,0)
SubmitButton.Text = "Submit"
SubmitButton.TextColor3 = Color3.fromRGB(255,255,255)
SubmitButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
local cornerSub = Instance.new("UICorner", SubmitButton)
cornerSub.CornerRadius = UDim.new(0,8)

local DiscordButton = Instance.new("TextButton", KeyFrame)
DiscordButton.Size = UDim2.new(0.5,0,0,30)
DiscordButton.Position = UDim2.new(0.25,0,0.8,0)
DiscordButton.Text = "Join Discord"
DiscordButton.Visible = false
DiscordButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
DiscordButton.TextColor3 = Color3.fromRGB(255,255,255)
local cornerDis = Instance.new("UICorner", DiscordButton)
cornerDis.CornerRadius = UDim.new(0,8)
DiscordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/uSJSEF6kh")
    DiscordButton.Text = "Copied!"
end)

-- MAIN HUB PANEL
local MainUI = Instance.new("Frame", ScreenGui)
MainUI.Size = UDim2.new(0,650,0,300)
MainUI.Position = UDim2.new(0.5,0,0.5,0)
MainUI.AnchorPoint = Vector2.new(0.5,0.5)
MainUI.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainUI.Visible = false
local cornerMain = Instance.new("UICorner", MainUI)
cornerMain.CornerRadius = UDim.new(0,20)

local Header = Instance.new("TextLabel", MainUI)
Header.Size = UDim2.new(1,0,0,35)
Header.Position = UDim2.new(0,0,0,0)
Header.BackgroundTransparency = 1
Header.Text = "Unified Sentry Hub"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 22
Header.TextColor3 = Color3.fromRGB(255,255,255)

-- SHOW/HIDE GUI BUTTON
local ShowHideBtn = Instance.new("TextButton", ScreenGui)
ShowHideBtn.Size = UDim2.new(0,120,0,30)
ShowHideBtn.Position = UDim2.new(0.95,-130,0.05,0)
ShowHideBtn.AnchorPoint = Vector2.new(0,0)
ShowHideBtn.Text = "Hide GUI"
ShowHideBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
ShowHideBtn.TextColor3 = Color3.fromRGB(255,255,255)
local cornerSH = Instance.new("UICorner", ShowHideBtn)
cornerSH.CornerRadius = UDim.new(0,8)
ShowHideBtn.MouseButton1Click:Connect(function()
    if MainUI.Visible then
        MainUI.Visible=false
        ShowHideBtn.Text="Show GUI"
    else
        MainUI.Visible=true
        ShowHideBtn.Text="Hide GUI"
    end
end)

-- UTILITY FUNCTIONS
local function TweenObject(obj, propTable, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), propTable)
    tween:Play()
    return tween
end

local function CreateButton(parent,text,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    btn.Parent = parent
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,8)
    btn.MouseEnter:Connect(function() TweenObject(btn,{BackgroundColor3=Color3.fromRGB(50,50,50)},0.2) end)
    btn.MouseLeave:Connect(function() TweenObject(btn,{BackgroundColor3=Color3.fromRGB(30,30,30)},0.2) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(parent,text,callback)
    local state = false
    local btn
    btn = CreateButton(parent,text.." OFF",function()
        state = not state
        btn.Text = text.." "..(state and "ON" or "OFF")
        callback(state)
    end)
    return btn
end

local function CreateSlider(parent,text,min,max,default,callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4,0,1,0)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Text = text.." "..tostring(default)
    label.Parent = frame
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0.55,0,1,0)
    textbox.Position = UDim2.new(0.45,0,0,0)
    textbox.BackgroundColor3 = Color3.fromRGB(50,50,50)
    textbox.TextColor3 = Color3.fromRGB(255,255,255)
    textbox.Text = tostring(default)
    textbox.ClearTextOnFocus = false
    textbox.Font = Enum.Font.GothamBold
    textbox.TextSize = 14
    textbox.Parent = frame
    textbox:GetPropertyChangedSignal("Text"):Connect(function()
        local val = tonumber(textbox.Text)
        if val then
            if val < min then val=min end
            if val > max then val=max end
            label.Text = text.." "..val
            callback(val)
        end
    end)
    return frame
end

-- =========================
-- TABS SETUP
-- =========================
local tabs = {}
local tabNames = {"Player","Chase","Tools","Misc","Cosmetic"}
local tabButtons = {}
local selectedTab = "Player"

for i,name in ipairs(tabNames) do
    local btn = CreateButton(MainUI,name,function()
        selectedTab=name
        for tName,tab in pairs(tabs) do tab.Visible=false end
        tabs[name].Visible=true
    end)
    btn.Size = UDim2.new(0,100,0,25)
    btn.Position = UDim2.new(0,10+(i-1)*110,0,40)
    tabButtons[name] = btn

    local tab = Instance.new("ScrollingFrame",MainUI)
    tab.Size = UDim2.new(1,-20,0.7,0)
    tab.Position = UDim2.new(0,10,0,75)
    tab.BackgroundTransparency = 1
    tab.ScrollBarThickness = 6
    tab.Visible = (i==1)
    tabs[name] = tab
    local layout = Instance.new("UIListLayout",tab)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0,5)
end

-- =========================
-- PLAYER TAB
-- =========================
local playerTab = tabs["Player"]
CreateSlider(playerTab,"WalkSpeed",16,500,walkSpeed,function(val) walkSpeed=val end)
CreateSlider(playerTab,"JumpPower",50,500,jumpPower,function(val) jumpPower=val end)
CreateToggle(playerTab,"Infinite Jump",function(state)
    if state then
        activeConnections.infiniteJumpConn=UIS.JumpRequest:Connect(function()
            if player.Character then
                local hum=player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    else
        if activeConnections.infiniteJumpConn then activeConnections.infiniteJumpConn:Disconnect() end
    end
end)
CreateToggle(playerTab,"Invincible",function(state)
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.MaxHealth = state and math.huge or 100; hum.Health = state and math.huge or 100 end
    end
end)

-- =========================
-- CHASE TAB
-- =========================
local chaseTab = tabs["Chase"]
CreateToggle(chaseTab,"Auto Chase",function(v) autoChase=v end)
CreateSlider(chaseTab,"Chase Speed",1,20,chaseStep,function(v) chaseStep=v end)

-- =========================
-- TOOLS TAB
-- =========================
local toolsTab = tabs["Tools"]
CreateToggle(toolsTab,"Flying",function(v) flying=v end)
CreateSlider(toolsTab,"Hitbox Size",1,10,3,function(size)
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if not hitboxDefaults[plr] then hitboxDefaults[plr] = hrp.Size end
            hrp.Size = Vector3.new(size,size,size)
            hrp.Transparency = 0.5
        end
    end
end)
CreateToggle(toolsTab,"Enable Hitbox Expander",function(state)
    if not state then
        for plr,size in pairs(hitboxDefaults) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.Size = size
                hrp.Transparency = 0
            end
        end
    end
end)
CreateButton(toolsTab,"Reset Character",function() if player.Character then player.Character:BreakJoints() end end)

-- =========================
-- MISC TAB
-- =========================
local miscTab = tabs["Misc"]
CreateSlider(miscTab,"Camera FOV",70,120,70,function(val) if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=val end end)
CreateToggle(miscTab,"Low Gravity",function(state) workspace.Gravity = state and 50 or 196.2 end)

-- =========================
-- COSMETIC TAB
-- =========================
local cosmeticTab = tabs["Cosmetic"]
CreateToggle(cosmeticTab,"Dark Theme",function(state) MainUI.BackgroundColor3 = state and Color3.fromRGB(25,25,25) or Color3.fromRGB(200,200,200) end)
CreateSlider(cosmeticTab,"GUI Transparency",0,1,0,function(val) MainUI.BackgroundTransparency = val end)

-- =========================
-- MAIN LOOP
-- =========================
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.WalkSpeed = walkSpeed
    hum.JumpPower = jumpPower

    if flying then
        if not activeConnections.bodyVel then
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(0,math.huge,0)
            bodyVel.Velocity = Vector3.new(0,0,0)
            bodyVel.Parent = hrp
            activeConnections.bodyVel = bodyVel
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            activeConnections.bodyVel.Velocity = Vector3.new(0,flyVelocity,0)
        else
            activeConnections.bodyVel.Velocity = Vector3.new(0,0,0)
        end
    else
        if activeConnections.bodyVel then activeConnections.bodyVel:Destroy() activeConnections.bodyVel=nil end
    end

    if autoChase then
        local target
        local minDist = math.huge
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = plr
                end
            end
        end
        if target then
            local dir = (target.Character.HumanoidRootPart.Position - hrp.Position)
            local step = math.min(chaseStep, dir.Magnitude)
            hrp.CFrame = hrp.CFrame + dir.Unit*step
        end
    end
end)

-- =========================
-- KEY SYSTEM FUNCTIONALITY
-- =========================
SubmitButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY then
        KeyFrame.Visible=false
        MainUI.Visible=true
    else
        KeyBox.Text="Wrong Key!"
        DiscordButton.Visible=true
    end
end)
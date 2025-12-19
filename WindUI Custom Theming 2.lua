-- V1.0

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")


local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Custom",
    
    Accent = Color3.fromHex("#3498db"),
    Background = Color3.fromHex("#1a1a2e"),
    BackgroundTransparency = 0.05,
    Outline = Color3.fromHex("#2980b9"),
    Text = Color3.fromHex("#ecf0f1"),
    Placeholder = Color3.fromHex("#7f8c8d"),
    Button = Color3.fromHex("#00c3c3"),
    Icon = Color3.fromHex("#3498db"),
    
    Hover = Color3.fromHex("#3498db"),
    
    WindowBackground = Color3.fromHex("#0d1117"),
    WindowShadow = Color3.fromHex("#000000"),
    
    DialogBackground = Color3.fromHex("#1a1a2e"),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromHex("#ecf0f1"),
    DialogContent = Color3.fromHex("#ecf0f1"),
    DialogIcon = Color3.fromHex("#3498db"),
    
    WindowTopbarButtonIcon = Color3.fromHex("#3498db"),
    WindowTopbarTitle = Color3.fromHex("#ecf0f1"),
    WindowTopbarAuthor = Color3.fromHex("#ecf0f1"),
    WindowTopbarIcon = Color3.fromHex("#ecf0f1"),
    
    TabBackground = Color3.fromHex("#ecf0f1"),
    TabTitle = Color3.fromHex("#ecf0f1"),
    TabIcon = Color3.fromHex("#3498db"),
    
    ElementBackground = Color3.fromHex("#ecf0f1"),
    ElementTitle = Color3.fromHex("#ecf0f1"),
    ElementDesc = Color3.fromHex("#ecf0f1"),
    ElementIcon = Color3.fromHex("#3498db"),
    
    PopupBackground = Color3.fromHex("#1a1a2e"),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromHex("#ecf0f1"),
    PopupContent = Color3.fromHex("#ecf0f1"),
    PopupIcon = Color3.fromHex("#3498db"),
})

local function createMainUI()
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    
    WindUI:SetNotificationLower(true)
    
    local themes = {"Custom"}
    local currentThemeIndex = 1
    
    if not getgenv().TransparencyEnabled then
        getgenv().TransparencyEnabled = true
    end
    
    local VirtualUser = game:GetService("VirtualUser")
    local Stats = game:GetService("Stats")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    
    local showFPS, showPing, showPlayers = true, true, false
    local fpsCounter, fpsLastUpdate, fpsValue = 0, tick(), 0
    
    local function createText(yOffset)
        local textObj = Drawing.new("Text")
        textObj.Size = 16
        textObj.Position = Vector2.new(Camera.ViewportSize.X - 110, yOffset)
        textObj.Color = Color3.fromRGB(0, 255, 0)
        textObj.Center = false
        textObj.Outline = true
        textObj.Visible = true
        return textObj
    end
    
    local fpsText = createText(10)
    local msText = createText(30)
    local playersText = createText(50)
    
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        fpsText.Position = Vector2.new(Camera.ViewportSize.X - 110, 10)
        msText.Position = Vector2.new(Camera.ViewportSize.X - 110, 30)
        playersText.Position = Vector2.new(Camera.ViewportSize.X - 110, 50)
    end)
    
    RunService.RenderStepped:Connect(function()
        fpsCounter += 1
    
        if tick() - fpsLastUpdate >= 1 then
            fpsValue = fpsCounter
            fpsCounter = 0
            fpsLastUpdate = tick()
    
            if showFPS then
                fpsText.Text = string.format("FPS: %d", fpsValue)
                fpsText.Color = fpsValue >= 50 and Color3.fromRGB(0, 255, 0)
                    or fpsValue >= 30 and Color3.fromRGB(255, 165, 0)
                    or Color3.fromRGB(255, 0, 0)
                fpsText.Visible = true
            else
                fpsText.Visible = false
            end
    
            if showPing then
                local pingStat = Stats.Network.ServerStatsItem["Data Ping"]
                local ping = pingStat and math.floor(pingStat:GetValue()) or 0
                local color, label = Color3.fromRGB(0, 255, 0), "Wifi Ping: "
    
                if ping > 120 then
                    color, label = Color3.fromRGB(255, 0, 0), "Wifi Ping: "
                elseif ping > 60 then
                    color = Color3.fromRGB(255, 165, 0)
                end
    
                msText.Text = string.format("%s%d ms", label, ping)
                msText.Color = color
                msText.Visible = true
            else
                msText.Visible = false
            end
    
            if showPlayers then
                local currentPlayers = #Players:GetPlayers()
                local maxPlayers = Players.MaxPlayers
                local color = Color3.fromRGB(0, 255, 0) 
                
                if currentPlayers >= maxPlayers - 1 then
                    color = Color3.fromRGB(255, 0, 0) 
                elseif currentPlayers >= maxPlayers - 4 then
                    color = Color3.fromRGB(255, 165, 0) 
                elseif currentPlayers <= 4 then
                    color = Color3.fromRGB(135, 206, 235) 
                end
    
                playersText.Text = string.format("Players: %d/%d", currentPlayers, maxPlayers)
                playersText.Color = color
                playersText.Visible = true
            else
                playersText.Visible = false
            end
        end
    end)
    
    function gradient(text, startColor, endColor)
        local result = ""
        local length = #text
        for i = 1, length do
            local t = (i - 1) / math.max(length - 1, 1)
            local r = math.floor((startColor.R + ((endColor.R - startColor.R) * t)) * 255)
            local g = math.floor((startColor.G + ((endColor.G - startColor.G) * t)) * 255)
            local b = math.floor((startColor.B + ((endColor.B - startColor.B) * t)) * 255)
            local char = text:sub(i, i)
            result = result .. '<font color="rgb(' .. r .. "," .. g .. "," .. b .. ')">' .. char .. "</font>"
        end
        return result
    end
    
    local Window = WindUI:CreateWindow({
        Title = "WindUI Custom",
        Icon = "rbxassetid://104429923156406", 
        Author = gradient("By Elvis", Color3.fromHex("#d5eff9"), Color3.fromHex("#87cefa")),
        Folder = "WindUI",
        Size = UDim2.fromOffset(500, 350),
        Theme = "Custom",
        NewElements = true,
        Transparent = getgenv().TransparencyEnabled,
        Resizable = true,
        SideBarWidth = 150,
        HideSearchBar = false,
        ScrollBarEnabled = true,
    })

do
    local NebulaIcons = loadstring(game:HttpGetAsync("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()
    
    WindUI.Creator.AddIcons("fluency",    NebulaIcons.Fluency)
    
    WindUI.Creator.AddIcons("nebula",    NebulaIcons.nebulaIcons)
    
    local TestSection = Window:Section({
        Title = "Elvis Softworks",
        Icon = "nebula:nebula",
    })
end 
 
    Window:Tag({
        Title = gradient("V1.0", Color3.fromHex("#d5eff9"), Color3.fromHex("#87cefa")),
        Radius = 12,
    })
    
    Window:SetToggleKey(Enum.KeyCode.V)
    
    pcall(function()
        Window:CreateTopbarButton("TransparencyToggle", "eye", function()
            if getgenv().TransparencyEnabled then
                getgenv().TransparencyEnabled = false
                pcall(function() Window:ToggleTransparency(false) end)
                
                WindUI:Notify({
                    Title = "Transparency", 
                    Content = "Transparency disabled",
                    Duration = 3,
                    Icon = "eye"
                })
            else
                getgenv().TransparencyEnabled = true
                pcall(function() Window:ToggleTransparency(true) end)
                
                WindUI:Notify({
                    Title = "Transparency",
                    Content = "Transparency enabled", 
                    Duration = 3,
                    Icon = "eye-off"
                })
            end
            
        end, 990)
    end)
    
    Window:EditOpenButton({
        Title = "Open UI",
        Icon = "zap",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromRGB(95, 225, 250), Color3.fromRGB(0, 0, 255)),
        Draggable = true
    })
    
    local Tabs = {}
    
    Tabs.Home = Window:Tab({
        Title = "Home",
        Icon = "house",
        Desc = ""
    })
    Tabs.Info = Window:Tab({
        Title = "Information",
        Icon = "badge-info",
        Desc = ""
    })
    
    Window:SelectTab(1)
    
    Tabs.Home:Section({
        Title = "Welcome",
        Icon = "info",
    })
   
    do
        local WelcomeSection = Tabs.Home:Section({
            Title = "Welcome to WindUI Custom",
        })
        
        WelcomeSection:Image({
            Image = "https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=800&auto=format&fit=crop",
            AspectRatio = "16:9",
            Radius = 9,
        })
        
        WelcomeSection:Space({ Columns = 3 })
        
        WelcomeSection:Section({
            Title = "Elvis Softworks",
            TextSize = 24,
            FontWeight = Enum.FontWeight.SemiBold,
        })
    
        WelcomeSection:Space()
        
        WelcomeSection:Section({
            Title = [[WindUI is a premium script UI with optimizations and minimal design
            
    - Auto-execute support
    - Always updated
    - Optimized Design
    - User-friendly interface
    - Universal]],
            TextSize = 16,
            TextTransparency = .25,
            FontWeight = Enum.FontWeight.Medium,
        })
        
        Tabs.Home:Space({ Columns = 4 })
        
local StatsSection = Tabs.Home:Section({
    Title = "Game Info",
    Icon = "gamepad-2"
})

StatsSection:Button({
    Title = "Copy Game ID",
    Color = Color3.fromHex("#3498db"),
    Justify = "Center",
    Icon = "copy",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
        WindUI:Notify({
            Title = "Apex Hub",
            Content = "Game ID copied to clipboard!"
        })
    end
})
        
    end
    
    Tabs.Home:Space()
    
    Tabs.Home:Toggle({
        Title = "Anti AFK",
        Icon = "activity",
        Default = true,
        Callback = function(state)
            if state then
                task.spawn(function()
                    while state do
                        if not LocalPlayer then
                            return
                        end
                        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                        task.wait(40)
                    end
                end)
            end
        end
    })
    
    Tabs.Home:Divider()
    
    Tabs.Home:Keybind({
        Title = "Keybind",
        Desc = "Keybind to open and close ui",
        Value = "F",
        Callback = function(v)
            Window:SetToggleKey(Enum.KeyCode[v])
        end
    })
    
    VisualSettings = Tabs.Home:Section({ Title = "Stats", Icon = "settings-2" })
    
    ShowFps = VisualSettings:Toggle({
        Title = "Show Fps",
        Default = false,
        Callback = function(val)
            showFPS = val
            fpsText.Visible = val
        end
    })
    
    ShowPing = VisualSettings:Toggle({
        Title = "Show Ping",
        Default = false,
        Callback = function(val)
            showPing = val
            msText.Visible = val
        end
    })
    
    ShowPlayers = VisualSettings:Toggle({
        Title = "Show Players",
        Default = false,
        Callback = function(val)
            showPlayers = val
            playersText.Visible = val
        end
    })
    
    ShowFps:Set(false)
    ShowPing:Set(false)
    
    Tabs.Home:Paragraph({
        Title = "ChangeLogs - V1.0",
        Desc = [[
    [#] Improved script
        ]]
    })

    if not ui then ui = {} end
    if not ui.Creator then ui.Creator = {} end
    
    local HttpService = game:GetService("HttpService")
    
    local function SafeRequest(requestData)
        local success, result = pcall(function()
            if syn and syn.request then
                local response = syn.request(requestData)
                return {
                    Body = response.Body,
                    StatusCode = response.StatusCode,
                    Success = response.Success
                }
            elseif request and type(request) == "function" then
                local response = request(requestData)
                return {
                    Body = response.Body,
                    StatusCode = response.StatusCode,
                    Success = response.Success
                }
            elseif http and http.request then
                local response = http.request(requestData)
                return {
                    Body = response.Body,
                    StatusCode = response.StatusCode,
                    Success = response.Success
                }
            elseif HttpService.RequestAsync then
                local response = HttpService:RequestAsync({
                    Url = requestData.Url,
                    Method = requestData.Method or "GET",
                    Headers = requestData.Headers or {}
                })
                return {
                    Body = response.Body,
                    StatusCode = response.StatusCode,
                    Success = response.Success
                }
            else
                local body = HttpService:GetAsync(requestData.Url)
                return {
                    Body = body,
                    StatusCode = 200,
                    Success = true
                }
            end
        end)
    
        if success then
            return result
        else
            warn("HTTP Request failed:", result)
            return {
                Body = "{}",
                StatusCode = 0,
                Success = false,
                Error = tostring(result)
            }
        end
    end
    
    local function RetryRequest(requestData, retries)
        retries = retries or 2
        for i = 1, retries do
            local result = SafeRequest(requestData)
            if result.Success and result.StatusCode == 200 then
                return result
            end
            task.wait(1)
        end
        return {
            Success = false, Error = "Max retries reached"
        }
    end
    
    local function ShowError(message)
        Tabs.Info:Paragraph({
            Title = "Error fetching Discord Info",
            Image = "rbxassetid://17862288113",
            ImageSize = 60,
            Color = "Red"
        })
    end
    
    local InviteCode = "7zyT99D7S3"
    local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"
    
    local function LoadDiscordInfo()
        local success, result = pcall(function()
            return HttpService:JSONDecode(RetryRequest({
                Url = DiscordAPI,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "RobloxBot/1.0",
                    ["Accept"] = "application/json"
                }
            }).Body)
        end)
    
        if success and result and result.guild then
            local DiscordInfo = Tabs.Info:Paragraph({
                Title = result.guild.name,
                Desc = ' <font color="#52525b"></font> Member Count : ' .. tostring(result.approximate_member_count) ..
                '\n <font color="#16a34a"></font> Online Count : ' .. tostring(result.approximate_presence_count),
                Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
                ImageSize = 42,
            })
    
            Tabs.Info:Button({
                Title = "Update Info",
                Callback = function()
                    local updated, updatedResult = pcall(function()
                        return HttpService:JSONDecode(RetryRequest({
                            Url = DiscordAPI,
                            Method = "GET",
                        }).Body)
                    end)
    
                    if updated and updatedResult and updatedResult.guild then
                        DiscordInfo:SetDesc(
                            ' <font color="#52525b"></font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                            '\n <font color="#16a34a"></font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                        )
    
                        WindUI:Notify({
                            Title = "Discord Info Updated",
                            Content = "Successfully refreshed Discord statistics",
                            Duration = 2,
                            Icon = "refresh-cw",
                        })
                    else
                        WindUI:Notify({
                            Title = "Update Failed",
                            Content = "Could not refresh Discord info",
                            Duration = 3,
                            Icon = "alert-triangle",
                        })
                    end
                end
            })
    
            Tabs.Info:Button({
                Title = "Copy Discord Invite",
                Callback = function()
                    setclipboard("https://discord.gg/" .. InviteCode)
                    WindUI:Notify({
                        Title = "Copied!",
                        Content = "Discord invite copied to clipboard",
                        Duration = 2,
                        Icon = "clipboard-check",
                    })
                end
            })
    
        else
            ShowError("Failed to fetch Discord Info. " .. (result and result.Error or "Unknown error"))
        end
    end
    
    LoadDiscordInfo()
    
    Tabs.Info:Divider()
    
    Tabs.Info:Paragraph({
        Title = "Elvis Softworks",
        Desc = "Dev - Elvis",
        Thumbnail = "",
        ThumbnailSize = 50,
        Locked = false,
    })
    
end

local Confirmed = false

WindUI:Popup({
    Title = "WindUI",
    Icon = "zap",
    IconThemed = true,
    Theme = "Custom",
    Content = "Welcome To ScriptName. A flexible and powerful script hub for Roblox, designed to enhance your gaming experience with a variety of features.",
    Buttons = {
        {
            Title = "Copy Discord Link",
            Variant = "Primary",
            Callback = function()
                setclipboard("https://discord.gg/7zyT99D7S3")
            end
        },
        {
            Title = "Exit",
            Variant = "Secondary",
            Callback = function()
                game.Players.LocalPlayer:Kick("Get out!")
            end
        },
        {
            Title = "Load",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                Confirmed = true

                loadstring(game:HttpGet("https://paste.rs/phWne"))()

                task.spawn(function()
                    task.wait(3)
                    
                    repeat
                        task.wait()
                    until Confirmed
                    
                    createMainUI()
                end)
            end
        }
    }
})
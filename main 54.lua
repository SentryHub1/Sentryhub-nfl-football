local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local Window = Luna:CreateWindow({
    Name = "SolsticeHub", -- This Is Title Of Your Window
    Subtitle = nil, -- A Gray Subtitle next To the main title.
    LogoID = "rbxassetid://139208186043027", -- Your dragon logo
    LoadingEnabled = true, -- Whether to enable the loading animation. Set to false if you do not want the loading screen or have your own custom one.
    LoadingTitle = "VortexHax", -- Header for loading screen
    LoadingSubtitle = "by VortexHax Team", -- Subtitle for loading screen

    ConfigSettings = {
        RootFolder = nil, -- The Root Folder Is Only If You Have A Hub With Multiple Game Scripts and u may remove it. DO NOT ADD A SLASH
        ConfigFolder = "VortexHax" -- The Name Of The Folder Where Luna Will Store Configs For This Script. DO NOT ADD A SLASH
    },

    KeySystem = true, -- As Of Beta 6, Luna Has officially Implemented A Key System!
    KeySettings = {
        Title = "SolsticeHub Key",
        Subtitle = "Key System",
        Note = "Best Key System Ever! Also, Please Use A HWID Keysystem like Pelican, Luarmor etc. that provide key strings based on your HWID since putting a simple string is very easy to bypass, the key is vortex123!",
        SaveInRoot = false, -- Enabling will save the key in your RootFolder (YOU MUST HAVE ONE BEFORE ENABLING THIS OPTION)
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        Key = {"SOLSTICE"},
        SecondAction = {
            Enabled = true, -- Set to false if you do not want a second action,
            Type = "Discord", -- Link / Discord.
            Parameter = "X2WBMt2pS" -- If Type is Discord, then put your invite link (DO NOT PUT DISCORD.GG/). Else, put the full link of your key system here.
        }
    }
})

Window:CreateHomeTab({
	SupportedExecutors = {
		"Delta",
		"Synapse X",
		"Krnl",
		"Fluxus",
		"Script-Ware",
		"Codex",
		"Electron"
	},
	DiscordInvite = "DzMhjn3JfB",
	Icon = 1
})

local GamesTab = Window:CreateTab({
    Name = "Scripts",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true -- This will determine whether the big header text in the tab will show
})

GamesTab:CreateSection("SolsticeHub")

GamesTab:CreateButton({
    Name = "BloxFruits",
    Description = "bloxfruits script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperHackerYT/Solstice-Hub/refs/heads/main/SolBF.lua"))()
    end
})

GamesTab:CreateButton({
    Name = "prison life",
    Description = "Prison Life",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/SentryHub1/Prison-life-Hub/refs/heads/main/main%2016.lua'))()
    end
})

GamesTab:CreateSection("more sentry hub")
GamesTab:CreateButton({
    Name = "nfl universe football",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/SentryHub1/Sentry-hub-nfl/refs/heads/main/main%2048.lua'))()
    end
})

local ThemeTab = Window:CreateTab({
    Name = "Theme",
    Icon = "palette",
    ImageSource = "Material",
    ShowTitle = true
})

ThemeTab:BuildThemeSection()

local ConfigTab = Window:CreateTab({
    Name = "Config",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

ConfigTab:BuildConfigSection()

Luna:Notification({
    Title = "SolsticeHub Loaded",
    Icon = "notifications_active",
    ImageSource = "Material",
    Content = "Tap the gamepad icon for scripts! discord.gg/DzMhjn3JfB"
})

Luna:LoadAutoloadConfig()
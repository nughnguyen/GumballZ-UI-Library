
local GumballZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/nughnguyen/GumballZ-UI-Library/refs/heads/main/GUI/GumballZ-UI-Lib.luau"))();

local Players = game:GetService("Players")
local Notification = GumballZ:CreateNotifier();

local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local Config = {
	Name = "GumballZ",
	Version = "1.0.12",
	Author = "Nguyen Quoc Hung",
	Description = "A Roblox script for all games",
}

--------------------------------------------------------------------------------
-- VFX System (Monkey Patch)
--------------------------------------------------------------------------------
-- Fully implementing Loader to override remote dependency and control Blur/Particles
function GumballZ:Loader(Config)
    Config = Config or {};
    Config.Name = Config.Name or "GUMBALLZ";
    Config.Duration = Config.Duration or 3.5;
    Config.Scale = Config.Scale or 3;
    -- Defaulting Blur to false if not specified, since user wanted to remove it.
    -- If user specifies Blur=true in config, it will show.
    local useBlur = Config.Blur

    -- Particle Effect Integration
    if Config.Particle then
        task.spawn(function()
            local duration = Config["particle duration"] or Config.Duration or 3
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart", 5)
            if not root then return end
            
            local cleanupObjects = {}
            
            -- 1. Central Energy Burst (High Density)
            local burstAtt = Instance.new("Attachment")
            burstAtt.Parent = root
            table.insert(cleanupObjects, burstAtt)
            
            local burst = Instance.new("ParticleEmitter")
            burst.Parent = burstAtt
            burst.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            burst.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),   -- Cyan
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 85, 255)), -- Purple
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))   -- White
            })
            burst.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(0.5, 0.6),
                NumberSequenceKeypoint.new(1, 0)
            })
            burst.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.7, 0.5),
                NumberSequenceKeypoint.new(1, 1)
            })
            burst.Lifetime = NumberRange.new(0.5, 1)
            burst.Rate = 300 -- Massive amount of particles
            burst.Speed = NumberRange.new(2, 6)
            burst.SpreadAngle = Vector2.new(360, 360) -- Omni-directional
            burst.Drag = 1.5
            burst.LightEmission = 1
            burst.LockedToPart = false
            
            -- 2. Rising Aura (Ground to Air)
            local aura = Instance.new("ParticleEmitter")
            aura.Parent = burstAtt
            aura.Texture = "rbxassetid://1084964344" -- Soft glow
            aura.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
            aura.Size = NumberSequence.new(0.5)
            aura.Rate = 100
            aura.Lifetime = NumberRange.new(1, 1.5)
            aura.Speed = NumberRange.new(4, 6)
            aura.EmissionDirection = Enum.NormalId.Top
            aura.SpreadAngle = Vector2.new(25, 25)
            aura.Acceleration = Vector3.new(0, 5, 0)
            aura.LightEmission = 0.8
            
            -- 3. Chaotic 3D Orbiters
            local function CreateChaoticOrbiter(speedOpts, radius, color)
                local att = Instance.new("Attachment")
                att.Parent = root
                table.insert(cleanupObjects, att)
                
                local trail = Instance.new("ParticleEmitter")
                trail.Parent = att
                trail.Texture = "rbxasset://textures/particles/sparkles_main.dds" 
                trail.Color = ColorSequence.new(color)
                trail.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.4),
                    NumberSequenceKeypoint.new(1, 0)
                })
                trail.Rate = 80
                trail.Lifetime = NumberRange.new(0.3, 0.5)
                trail.Speed = NumberRange.new(0)
                trail.LockedToPart = true
                trail.LightEmission = 1
                
                local t = math.random() * 10
                local speedX, speedY, speedZ = unpack(speedOpts)
                
                local conn = RunService.RenderStepped:Connect(function()
                    if not root or not root.Parent then return end
                    t = t + 0.04
                    -- Lissajous 3D Path
                    local x = math.sin(t * speedX) * radius
                    local y = math.cos(t * speedY) * radius
                    local z = math.sin(t * speedZ) * radius
                    att.Position = Vector3.new(x, y, z)
                end)
                table.insert(cleanupObjects, conn)
            end
            
            -- Spawn multiple orbiters with random intense colors
            for i = 1, 5 do
                local rCol = Color3.fromHSV(math.random(), 0.8, 1)
                CreateChaoticOrbiter({math.random(2,5), math.random(2,5), math.random(2,5)}, 5, rCol)
            end
            
            task.delay(duration, function()
                for _, v in pairs(cleanupObjects) do
                    if typeof(v) == "Instance" then v:Destroy()
                    elseif typeof(v) == "RBXScriptConnection" then v:Disconnect()
                    end
                end
            end)
        end)
    end

    local Blur
    if useBlur then
        Blur = Instance.new('BlurEffect');
        Blur.Size = 0;
        Blur.Parent = game:GetService('Lighting');
        
        GumballZ:CreateAnimation(Blur,1,{
            Size = 60
        })
    end

    local CoreGui = game:GetService("CoreGui") -- Ensure CoreGui usage
    -- Fallback for exploits that don't allow accessing CoreGui directly
    local success, targetGui = pcall(function() return game:GetService("CoreGui") end)
    if not success then targetGui = LocalPlayer:WaitForChild("PlayerGui") end

    local Loader = Instance.new("ScreenGui")
    local center = Instance.new("Frame")
    local texts = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local BlackFrame = Instance.new("Frame")

    Loader.Name = GumballZ:RandomString()
    Loader.Parent = targetGui
    Loader.IgnoreGuiInset = true
    Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global

    center.Name = GumballZ:RandomString()
    center.Parent = Loader
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    center.BackgroundTransparency = 1.000
    center.BorderColor3 = Color3.fromRGB(0, 0, 0)
    center.BorderSizePixel = 0
    center.Position = UDim2.new(0.5, 0, 0.5, 0)

    texts.Name = GumballZ:RandomString()
    texts.Parent = Loader
    texts.AnchorPoint = Vector2.new(0.5, 0.5)
    texts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    texts.BackgroundTransparency = 1.000
    texts.BorderColor3 = Color3.fromRGB(0, 0, 0)
    texts.BorderSizePixel = 0
    texts.Position = UDim2.new(0.5, 0, 0.5, 0)
    texts.Size = UDim2.new(1, 0, 0, 200)

    UIListLayout.Parent = texts
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, Config.Scale * 5)

    BlackFrame.Name = GumballZ:RandomString()
    BlackFrame.Parent = Loader
    BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlackFrame.BackgroundTransparency = 1
    BlackFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BlackFrame.BorderSizePixel = 0
    BlackFrame.Size = UDim2.new(1, 0, 1, 0)

    GumballZ:CreateAnimation(BlackFrame,0.5,{
        BackgroundTransparency = 0.7
    }).Completed:Wait();

    task.wait(0.5);

    local UText = {
        Y = 14,
    };

    local createText = function(TEXT)
        local LIT = Instance.new("Frame")
        local ASCII = Instance.new("TextLabel")
        local UIGradient = Instance.new("UIGradient")
        local UIScale = Instance.new("UIScale")

        LIT.Name = GumballZ:RandomString()
        LIT.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LIT.BackgroundTransparency = 1.000
        LIT.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LIT.BorderSizePixel = 0
        LIT.Size = UDim2.new(0, 56, 0, 100)
        LIT.ZIndex = 8

        ASCII.Name = GumballZ:RandomString()
        ASCII.Parent = LIT
        ASCII.AnchorPoint = Vector2.new(0.5, 0.5)
        ASCII.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ASCII.BackgroundTransparency = 1.000
        ASCII.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ASCII.BorderSizePixel = 0
        ASCII.Position = UDim2.new(0.5, 0, 0.5, 0)
        ASCII.Size = UDim2.new(0, 28, 0, 50)
        ASCII.ZIndex = 8
        ASCII.Font = Enum.Font.GothamBold
        ASCII.Text = TEXT
        ASCII.TextColor3 = Color3.fromRGB(255, 255, 255)
        ASCII.TextSize = 50.000
        ASCII.TextWrapped = true

        local textsize = GumballZ:GetTextSize(ASCII);

        ASCII.Size = UDim2.new(0, textsize.X + 100, 0, 50)
        LIT.Size = UDim2.new(0, (textsize.X * 2.5) + (UText[TEXT] or 0), 0, 100)

        UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 116, 116)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(132, 58, 58))}
        UIGradient.Rotation = 88
        UIGradient.Parent = ASCII

        UIScale.Parent = ASCII
        UIScale.Scale = Config.Scale

        return LIT,ASCII
    end;

    local PosText = {};
    local IsFirst = true;

    string.gsub(Config.Name,'.',function(T)
        local L,A = createText(T);

        L.Parent = texts;
        A.TextTransparency = 1;

        if not IsFirst then
            A.Position = UDim2.new(0.5,0,0.5,200);
        end;

        table.insert(PosText,{
            Frame = L,
            Text = A
        });

        IsFirst = false;
    end);

    do
        local StartText = Instance.new("TextLabel")
        local UIGradient = Instance.new("UIGradient")
        local UIScale = Instance.new("UIScale")

        StartText.Name = GumballZ:RandomString()
        StartText.Parent = Loader
        StartText.AnchorPoint = Vector2.new(0.5, 0.5)
        StartText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        StartText.BackgroundTransparency = 1.000
        StartText.BorderColor3 = Color3.fromRGB(0, 0, 0)
        StartText.BorderSizePixel = 0
        StartText.Position = UDim2.new(0.5, 0, 0.5, 0)
        StartText.Size = UDim2.new(0, 28, 0, 50)
        StartText.ZIndex = 8
        StartText.Font = Enum.Font.GothamBold
        StartText.Text = Config.Name:sub(1,1)
        StartText.TextColor3 = Color3.fromRGB(255, 255, 255)
        StartText.TextSize = 50.000
        StartText.TextWrapped = true
        StartText.TextTransparency = 1;

        local textsize = GumballZ:GetTextSize(StartText);
        local baseSIZX = textsize.X;

        StartText.Size = UDim2.new(0, baseSIZX + 100, 0, 50)

        UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 116, 116)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(132, 58, 58))}
        UIGradient.Rotation = 88
        UIGradient.Parent = StartText

        UIScale.Parent = StartText
        UIScale.Scale = Config.Scale * 4;

        GumballZ:CreateAnimation(StartText,0.45,{
            TextTransparency = 0
        })

        GumballZ:CreateAnimation(UIScale,0.5,{
            Scale = Config.Scale;
        });

        task.wait(0.45);

        GumballZ:CreateAnimation(StartText,0.35,{
            Position = UDim2.fromOffset(PosText[1].Frame.AbsolutePosition.X + (PosText[1].Frame.AbsoluteSize.X / 2),PosText[1].Frame.AbsolutePosition.Y + (PosText[1].Frame.AbsoluteSize.Y / 2) + math.abs(Loader.AbsolutePosition.Y))
        })

        task.wait(0.5);

        for i,v in next , PosText do
            if i > 1 then
                GumballZ:CreateAnimation(v.Text,0.65,{
                    Position = UDim2.new(0.5,0,0.5,0);
                    TextTransparency = 0
                })
            end;
        end;

        task.wait((Config.Duration - 0.5) + 0.65);

        GumballZ:CreateAnimation(StartText,1.5,{
            TextTransparency = 1
        })

        for i,v in next , PosText do
            GumballZ:CreateAnimation(v.Text,1.5,{
                TextTransparency = 1
            })
        end;

        if Blur then
            GumballZ:CreateAnimation(Blur,1.5,{
                Size = 0
            })
        end

        GumballZ:CreateAnimation(BlackFrame,1.5,{
            BackgroundTransparency = 1
        })

        task.wait(1.65);

        Loader:Destroy();
        if Blur then Blur:Destroy() end
    end;
end
--------------------------------------------------------------------------------

GumballZ:Loader({
	Name = "GumballZ",
	Duration = 1,
	Particle = true,
	ParticleDuration = 10,
	ParticleScale = 3,
});

Notification:Notify({
	Title = Config.Name.." | "..Config.Version,
	Content = "Hello, "..LocalPlayer.DisplayName..' Welcome back!',
	Icon = "clipboard",
	Duration = 2
})

local Window = GumballZ.new({
	Name = "GumballZ",
	Expire = "never",
	KeySettings = {
		Title = "GumballZ Key System",
		Subtitle = "Get Key: GumballZ Website",
		Note = "Key Link Copied!",
		FileName = "GumballZKey",
		SaveKey = true,
		GrabKeyFromSite = true, -- Disable list fetching
		Key = function(EnteredKey)
            local RBXAnalytics = game:GetService("RbxAnalyticsService")
            local HWID = RBXAnalytics:GetClientId()
            
            local success, response = pcall(function()
                return game:HttpGet("https://gumballzhub.vercel.app/api/keys/roblox-valid?key=" .. EnteredKey .. "&hwid=" .. HWID)
            end)
            
            if success then
                local data = HttpService:JSONDecode(response)
                if data.valid then
					if data.expires_at then
						local Year, Month, Day = data.expires_at:match("(%d+)-(%d+)-(%d+)")
						KeyExpireDate = Day .. "/" .. Month .. "/" .. Year
					end
                    return true, KeyExpireDate
                else
                    -- Optional: Notify user of specific error
                end
            end
            return false
        end,
		URL = "https://gumballzhub.vercel.app/keys?type=roblox"
	}
});

--------------------------------------------------------------------------------
-- Home Tab
--------------------------------------------------------------------------------
do
	local Home = Window:AddMenu({
		Name = "Home",
		Icon = "home"
	})

	local General = Home:AddSection({
		Position = 'left',
		Name = "",
		Height = 5 
	})

	-- Movement Settings
	General:AddDivider("MOVEMENT")

	General:AddSlider({
		Name = "WalkSpeed",
		Default = 16,
		Min = 16,
		Max = 250,
		Callback = function(v)
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.WalkSpeed = v
			end
		end
	})

	General:AddSlider({
		Name = "JumpPower",
		Default = 50,
		Min = 50,
		Max = 350,
		Callback = function(v)
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.UseJumpPower = true
				LocalPlayer.Character.Humanoid.JumpPower = v
			end
		end
	})

	General:AddSlider({
		Name = "Gravity",
		Default = 196.2,
		Min = 0,
		Max = 200,
		Callback = function(v)
			workspace.Gravity = v
		end
	})
	
	local InfiniteJumpEnabled = false
	game:GetService("UserInputService").JumpRequest:Connect(function()
		if InfiniteJumpEnabled and LocalPlayer.Character then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end)

	General:AddToggle({
		Name = "Infinite Jump",
		Default = false,
		Callback = function(v)
			InfiniteJumpEnabled = v
		end
	})

	-- Visual Settings
	General:AddDivider("VISUAL")

	General:AddSlider({
		Name = "FOV",
		Default = 70,
		Min = 70,
		Max = 120,
		Callback = function(v)
			workspace.CurrentCamera.FieldOfView = v
		end
	})

	General:AddButton({
		Name = "Reset Defaults",
		Callback = function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.WalkSpeed = 16
				LocalPlayer.Character.Humanoid.JumpPower = 50
			end
			workspace.Gravity = 196.2
			workspace.CurrentCamera.FieldOfView = 70
			Notification:Notify({Title = "Home", Content = "Stats Reset!", Duration = 2})
		end
	})
end

--------------------------------------------------------------------------------
-- Legit Tab
--------------------------------------------------------------------------------
do
	local Legit = Window:AddMenu({
		Name = "LEGIT",
		Icon = "target"
	})

	local Aim = Legit:AddSection({ Position = 'left', Name = "AIM", Height = 260 });
	local Rcs = Legit:AddSection({ Position = 'left', Name = "RCS", Height = 180 });
	local Trigger = Legit:AddSection({ Position = 'center', Name = "TRIGGER" });
	local Backtrack = Legit:AddSection({ Position = 'center', Name = "BACKTRACK" });
	local General = Legit:AddSection({ Position = 'right', Name = "GENERAL" });
	
	-- Aim Section
	Aim:AddToggle({ Name = "Aim assist" })
	Aim:AddDropdown({ Name = "Mode", Default = "Adaptive", Values = {"Adaptive","value 1",'Value 2'} })
	Aim:AddDropdown({
		Name = "Hitboxes",
		Multi = true,
		Default = { ["Head"] = true },
		Values = { "Head", 'Neck', 'Arms', 'Legs' }
	})
	Aim:AddSlider({ Name = "Multipoint" })
	Aim:AddSlider({ Name = "Aim fov", Round = 1, Default = 0.1, Type = " deg" })
	Aim:AddSlider({ Name = "Aim speed", Default = 1, Type = "%" })
	Aim:AddSlider({ Name = "Min-damage", Default = 61 })
	Aim:AddToggle({ Name = "Only in scpoe" })
	Aim:AddToggle({ Name = "Autostop" })
	
	-- RCS Section
	Rcs:AddToggle({ Name = "Recoil control" })
	Rcs:AddSlider({ Name = "Speed", Default = 1, Type = "%" })
	Rcs:AddToggle({ Name = "Re-center" })
	Rcs:AddSlider({ Name = "Start bullet", Default = 1 })
	
	-- Trigger Section
	Trigger:AddToggle({ Name = "Triggerbot" })
	Trigger:AddSlider({ Name = "Hit-chance", Default = 100, Type = "%" })
	Trigger:AddToggle({ Name = "Use seed when available" })
	Trigger:AddSlider({ Name = "Min-damage", Default = 0, Type = "%" })
	Trigger:AddSlider({ Name = "Reaction time", Default = 0, Type = "ms" })
	Trigger:AddToggle({ Name = "Wait for aim assist hitgroup" })
	Trigger:AddToggle({ Name = "Only in Scope" })
	
	-- Backtrack Section
	Backtrack:AddSlider({ Name = "Backtrack", Default = 0, Type = "%" })
	
	-- General Section
	General:AddToggle({ Name = "Enabled" })
	General:AddDropdown({ Name = "Disablers", Values = {"d1",'d2'} })
	General:AddToggle({ Name = "Visualize fov"})
	General:AddToggle({ Name = "Autorevolver" })
end

--------------------------------------------------------------------------------
-- Visual Tab
--------------------------------------------------------------------------------
do
	local Visual = Window:AddMenu({
		Name = "VISUAL",
		Icon = "eye"
	})

	local Misc = Visual:AddSection({ Name = "MISC", Position = 'left' })
	local Model = Visual:AddSection({ Name = "MODEL", Position = 'center' })
	
	-- Misc Section
	Misc:AddToggle({ Name = "Thirdperson", Option = true }).Option:AddSlider({ Name = "Distance" });
	Misc:AddToggle({ Name = "Overhead override", Option = true }).Option:AddDropdown({ Name = "Override" });
	Misc:AddToggle({ Name = "Fov override", Option = true }).Option:AddToggle({ Name = "Something" })
	Misc:AddToggle({ Name = "Viewmodel override", Option = true }).Option:AddToggle({ Name = "Something" })
	Misc:AddDropdown({ Name = "Remove scope" })
	
	local pc = Misc:AddToggle({ Name = "Penetration crosshair", Option = true }).Option;
	pc:AddColorPicker({ Name = "Walls", Default = Color3.fromRGB(111, 255, 0) })
	pc:AddColorPicker({ Name = "Can't walls", Default = Color3.fromRGB(255, 0, 4) })
	
	Misc:AddToggle({ Name = "Force crosshair", Option = true }).Option:AddToggle({ Name = "Something" })
	Misc:AddDropdown({ Name = "Spread" })
	Misc:AddToggle({ Name = "Bullet tracer", Option = true }).Option:AddColorPicker({ Name = "Color", Default = Color3.fromRGB(255, 41, 116) })
	
	-- Model Section
	Model:AddDropdown({ Name = "Visible", Default = "Disabled", Values = {"Disabled",'Something'} })
	Model:AddDropdown({ Name = "Invisible", Default = "Disabled", Values = {"Disabled",'Something'} })
	Model:AddDropdown({ Name = "Arms", Default = "Disabled", Values = {"Disabled",'Something'} })
	Model:AddDropdown({ Name = "Viewmodel", Default = "Disabled", Values = {"Disabled",'Something'} })
	Model:AddDropdown({ Name = "Attachments", Default = "Disabled", Values = {"Disabled",'Something'} })
	Model:AddToggle({ Name = 'Glow', Option = true }).Option:AddColorPicker({ Name = "Color" })
	Model:AddKeybind({ Name = "Toggle" })
end

--------------------------------------------------------------------------------
-- Info Tab
--------------------------------------------------------------------------------
do
	local Info = Window:AddMenu({
		Name = "Info",
		Icon = "info"
	})

	local UserInfo = Info:AddSection({
		Position = 'left',
		Name = ""
	});

	local GameInfo = Info:AddSection({
		Position = 'center',
		Name = ""
	});

	local Socials = Info:AddSection({
		Position = 'right',
		Name = ""
	});
	UserInfo:AddDivider("USER")
	
	-- Player Name
	UserInfo:AddButton({
		Name = "Player: " .. LocalPlayer.Name,
		Callback = function()
			setclipboard(LocalPlayer.Name)
			Notification:Notify({Title = "Copied", Content = "Copied Player Name", Icon = "clipboard", Duration = 2})
		end
	})

	UserInfo:AddButton({
		Name = "Display: " .. LocalPlayer.DisplayName,
		Callback = function()
			setclipboard(LocalPlayer.DisplayName)
			Notification:Notify({Title = "Copied", Content = "Copied Display Name", Icon = "clipboard", Duration = 2})
		end
	})

	UserInfo:AddPlayerView({ Height = 260 })

	-- Game Name
	local success, gameInfo = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	local gameName = success and gameInfo.Name or "Unknown Game"

	GameInfo:AddDivider("GAME")
	GameInfo:AddButton({
		Name = "Game: " .. gameName,
		Callback = function()
			setclipboard(gameName)
			Notification:Notify({Title = "Copied", Content = "Copied Game Name", Icon = "clipboard", Duration = 2})
		end
	})
	
	GameInfo:AddButton({
		Name = "Place ID: " .. tostring(game.PlaceId),
		Callback = function()
			setclipboard(tostring(game.PlaceId))
			Notification:Notify({Title = "Copied", Content = "Copied Place ID", Icon = "clipboard", Duration = 2})
		end
	})

	local ServerSizeButton = GameInfo:AddButton({
		Name = "Server Size: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
		Callback = function()
			setclipboard(#Players:GetPlayers() .. "/" .. Players.MaxPlayers)
			Notification:Notify({Title = "Copied", Content = "Copied Server Size", Icon = "clipboard", Duration = 2})
		end
	})

	-- Live update server size
	task.spawn(function()
		while task.wait(1) do
			if ServerSizeButton and ServerSizeButton.SetText then
				ServerSizeButton.SetText("Server Size: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
			end
		end
	end)

	-- Socials
	Socials:AddDivider("OUR COMMUNITY")

	Socials:AddParagraph({
		Title = "JOIN US!",
		Content = "Follow our official channels for the latest updates, giveaways, and community support."
	})

	Socials:AddButton({
		Name = "Discord Server",
		Callback = function()
			local link = "https://dsc.gg/thenoicez" 
			setclipboard(link)
			Notification:Notify({Title = "GumballZ", Content = "Copied Discord Link, paste it in your browser!", Icon = "clipboard", Duration = 2})
		end
	})
	
	Socials:AddButton({
		Name = "YouTube Channel",
		Callback = function()
			local link = "https://youtube.com/@nughnguyen" 
			setclipboard(link)
			Notification:Notify({Title = "GumballZ", Content = "Copied YouTube Link, paste it in your browser!", Icon = "clipboard", Duration = 2})
		end
	})

	Socials:AddButton({
		Name = "Facebook Admin",
		Callback = function()
			local link = "https://facebook.com/hungnq188.2k5" 
			setclipboard(link)
			Notification:Notify({Title = "GumballZ", Content = "Copied Facebook Link, paste it in your browser!", Icon = "clipboard", Duration = 2})
		end
	})
end

--------------------------------------------------------------------------------
-- Showcase Tab (New Features)
--------------------------------------------------------------------------------
do
	local Showcase = Window:AddMenu({
		Name = "Showcase",
		Icon = "star"
	})

	local TextElems = Showcase:AddSection({ Name = "TEXT ELEMENTS", Position = 'left' })
	local VisualElems = Showcase:AddSection({ Name = "VISUAL ELEMENTS", Position = 'center' })
	local InteractElems = Showcase:AddSection({ Name = "INTERACTIVE", Position = 'right' })

	-- Text Elements Section
	TextElems:AddDivider("PARAGRAPHS")
	TextElems:AddParagraph({
		Title = "Welcome User!",
		Content = "This is a paragraph element. It's great for displaying instructions, changelogs, or credits to your users."
	})
	
	TextElems:AddDivider("DIVIDERS")
	TextElems:AddParagraph({
		Title = "Dividers",
		Content = "Dividers (like the one above) helps organize your sections into logical groups."
	})

	-- Visual Elements Section
	VisualElems:AddDivider("PLAYER VIEW")
	VisualElems:AddPlayerView({ Height = 200 })
	VisualElems:AddParagraph({
		Title = "Live Character",
		Content = "The PlayerView element renders a live preview of the local player's character model."
	})

	-- Interactive Section
	InteractElems:AddDivider("COMPLEX TOGGLE")
	local complexToggle = InteractElems:AddToggle({ 
		Name = "Complex Switch", 
		Option = true 
	})
	
	-- Sub-options for the toggle
	local opts = complexToggle.Option
	opts:AddColorPicker({ 
		Name = "Active Color", 
		Default = Color3.fromRGB(0, 255, 255) 
	})
	opts:AddSlider({
		Name = "Intensity",
		Min = 0,
		Max = 100,
		Default = 50
	})
	opts:AddKeybind({
		Name = "Quick Toggle",
		Default = Enum.KeyCode.F
	})

	InteractElems:AddDivider("DROPDOWNS")
	InteractElems:AddDropdown({
		Name = "Multi Select",
		Multi = true,
		Values = {"Option A", "Option B", "Option C"},
		Default = {"Option A", "Option C"}
	})
end

local GumballZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/nughnguyen/GumballZ-UI-Library/refs/heads/main/GUI/GumballZ-UI-Lib.lua"))();
local Notification = GumballZ:CreateNotifier();
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

-- Helper function to open URLs
local function OpenUrl(link)
	if setclipboard then
		setclipboard(link)
	end
	
	-- Try various methods often available in executors
	if rawget(getgenv(), "visit") then 
		pcall(visit, link) 
	elseif rawget(getgenv(), "openurl") then
		pcall(openurl, link)
	else
		local success = pcall(function()
			game:GetService("GuiService"):OpenBrowserWindow(link)
		end)
		
		if not success then
			pcall(function()
				game:GetService("LinkingService"):OpenUrl(link)
			end)
		end
	end
end

GumballZ:Loader({
	Name = "GumballZ",
	Duration = 1,
});

Notification:Notify({
	Title = "GumballZ",
	Content = "Hello, "..LocalPlayer.DisplayName..' Welcome back!',
	Icon = "clipboard"
})

local Window = GumballZ.new({
	Name = "GumballZ",
	Expire = "never",
	KeySettings = {
		Title = "GumballZ Key System",
		Subtitle = "Join Discord to get the key",
		Note = "Discord Link Copied!",
		FileName = "GumballZKey",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"1234", "KeyTest"}, 
		URL = "https://dsc.gg/thenoicez"
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
		Name = "GENERAL",
		Height = 5 -- Give it a bit more initial height
	})

	-- Movement Settings
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
	General:AddDivider("Visuals")

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

	local Aim = Legit:AddSection({ Position = 'left', Name = "AIM" });
	local Rcs = Legit:AddSection({ Position = 'left', Name = "RCS" });
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
	General:AddToggle({ Name = "Visualize fov", Option = true }).Option:AddColorPicker({
		Name = "Color",
		Default = Color3.fromRGB(255, 34, 75)
	})
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
-- Info Tab (Refactored "About")
--------------------------------------------------------------------------------
do
	local Info = Window:AddMenu({
		Name = "Info",
		Icon = "info"
	})

	local UserInfo = Info:AddSection({
		Position = 'left',
		Name = "User Info"
	});

	local GameInfo = Info:AddSection({
		Position = 'center',
		Name = "Game Info"
	});

	local Socials = Info:AddSection({
		Position = 'right',
		Name = "Admin Socials"
	});

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

	-- Game Name
	local success, gameInfo = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	local gameName = success and gameInfo.Name or "Unknown Game"

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

	-- Socials
	Socials:AddButton({
		Name = "Discord Server",
		Callback = function()
			local link = "https://dsc.gg/thenoicez" 
			OpenUrl(link)
			Notification:Notify({Title = "GumballZ", Content = "Opening Discord...", Icon = "globe", Duration = 2})
		end
	})
	
	Socials:AddButton({
		Name = "YouTube Channel",
		Callback = function()
			local link = "https://youtube.com/@nughnguyen" 
			OpenUrl(link)
			Notification:Notify({Title = "GumballZ", Content = "Opening YouTube...", Icon = "globe", Duration = 2})
		end
	})

	Socials:AddButton({
		Name = "Facebook Admin",
		Callback = function()
			local link = "https://facebook.com/hungnq188.2k5" 
			OpenUrl(link)
			Notification:Notify({Title = "GumballZ", Content = "Opening Facebook...", Icon = "globe", Duration = 2})
		end
	})
end
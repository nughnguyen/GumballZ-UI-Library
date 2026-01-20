
local GumballZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/nughnguyen/GumballZ-UI-Library/refs/heads/main/GUI/GumballZ-UI-Lib.lua"))();

local Players = game:GetService("Players")
local Notification = GumballZ:CreateNotifier();

local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Config = {
	Name = "GumballZ",
	Version = "1.0.12",
	Author = "Nguyen Quoc Hung",
	Description = "A Roblox script for all games",
}

GumballZ:Loader({
	Name = "GumballZ",
	Duration = 1,
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
            -- Custom Key Verification Logic with HWID Binding
            local HttpService = game:GetService("HttpService")
            local RBXAnalytics = game:GetService("RbxAnalyticsService")
            local HWID = RBXAnalytics:GetClientId()
            
            local success, response = pcall(function()
                return game:HttpGet("https://gumballzhub.vercel.app/api/keys/roblox-valid?key=" .. EnteredKey .. "&hwid=" .. HWID)
            end)
            
            if success then
                local data = HttpService:JSONDecode(response)
                if data.valid then
					-- Format Date: YYYY-MM-DDTHH:MM:SS -> DD/MM/YYYY
					if data.expires_at then
						local Year, Month, Day = data.expires_at:match("(%d+)-(%d+)-(%d+)")
						KeyExpireDate = Day .. "/" .. Month .. "/" .. Year
					end
                    return true, KeyExpireDate
                else
                    -- Optional: Notify user of specific error (like HWID mismatch)
                    if data.message then
                        -- GumballZ:MakeNotification({Title="Error", Content=data.message, Icon="alert", Time=3})
                        -- Since we are inside the callback, we just return false. 
                        -- The Lib will likely show "Invalid Key".
                    end
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
		Height = 5 -- Give it a bit more initial height
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
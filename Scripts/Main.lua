local NughNguyen = loadstring(game:HttpGet('https://raw.githubusercontent.com/nughnguyen/Roblox/refs/heads/main/GUI_VIP.lua'))()

-- Window
local MainWindow = NughNguyen:CreateWindow({
   Name = "GumballZ |  Hub",
   Icon = 89522050759661,
   LoadingTitle = "Youtube: NughNguyen",
   LoadingSubtitle = "by QuocHung",
   Theme = "Ocean",

   DisableRayfieldPrompts = false, 
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "GumballZ"
   },



   Discord = {
      Enabled = true,
      Invite = "7r4RzRXzT2",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "GumballZ | Key System",
      Subtitle = "Enter your key",
      Note = "Getkey is very easy, you can also join discord for support!\nDiscord link: https://dsc.gg/thenoicez",
      FileName = "NughKey",
      SaveKey = true,
      GrabKeyFromSite = true,
      Key = "https://raw.githubusercontent.com/nughnguyen/Roblox/refs/heads/main/key.txt"
   }
})



-- Notification
NughNguyen:Notify({
   Title = "GumballZ | Hub",
   Content = "Welcome to GumballZ",
   Duration = 5,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "Okay !",
         Callback = function()
            print("Ignored")
         end
      },
   },
})

-- Main Tab
local MainTab = MainWindow:CreateTab("Home", 4034483344)

local Button = MainTab:CreateButton({
   Name = "Auto Detect & Run Script",
   Callback = function()
      local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/nughnguyen/Roblox/refs/heads/main/game_id.lua"))()
      local placeId = game.PlaceId
      local scriptUrl = Games[placeId]

      if scriptUrl then
         NughNguyen:Notify({
            Title = "GumballZ | Hub",
            Content = "Đã tìm thấy script, đang tải...",
            Duration = 2,
            Image = 4483362458,
         })

         -- Load script
         loadstring(game:HttpGet(scriptUrl))()

         NughNguyen:Notify({
            Title = "GumballZ | Hub",
            Content = "Script đã được chạy thành công!",
            Duration = 4,
            Image = 4483362458,
         })
      else
         NughNguyen:Notify({
            Title = "Game Not Supported",
            Content = "Không tìm thấy script hỗ trợ cho game này.",
            Duration = 5,
            Image = 4483362458,
            Actions = {
               Okay = {
                  Name = "OK",
                  Callback = function()
                     print("Game chưa có script trong GameList.")
                  end
               },
            },
         })
      end
   end,
})








local Toggle = MainTab:CreateToggle({
   Name = "Anti Afk",
   Callback = function()
      -- Chức năng chống afk ở đây
      local Player = game.Players.LocalPlayer
      local VirtualUser = game:GetService("VirtualUser")
      Player.Idled:Connect(function()
         VirtualUser:Button1Down(Vector2.new(0, 0))
         wait(1)
         VirtualUser:Button1Up(Vector2.new(0, 0))
      end)
      print("Anti afk đã được kích hoạt")
   end,
})


-- Các button khác


MainTab:CreateButton({
   Name = "Anime Saga",
   Callback = function()
      print('Anime Saga')
   end,
}) 

MainTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      NughNguyen:Notify({
         Title = "GumballZ | Hub",
         Content = "Unloading script...",
         Duration = 2,
         Image = 4483362458,
         Actions = {
            Okay = {
               Name = "OK",
               Callback = function()
 
               end
            },
         },
      })
      wait(3)
      NughNguyen:Destroy()
      
   end,
})


--- Player Tab
local PlayerTab = MainWindow:CreateTab("Player", 18854794412)
local slider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "WalkSpeed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})
local slider = PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 1,
   Suffix = "JumpPower",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})
local slider = PlayerTab:CreateSlider({
   Name = "Fov",
   Range = {70, 120},
   Increment = 1,
   Suffix = "Fov",
   CurrentValue = 70,
   Flag = "Fov",
   Callback = function(Value)
      game.Workspace.CurrentCamera.FieldOfView = Value
   end,
})
local slider = PlayerTab:CreateSlider({
   Name = "Camera",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Camera",
   CurrentValue = 0,
   Flag = "Camera",
   Callback = function(Value)
      game.Players.LocalPlayer.CameraMaxZoomDistance = Value
      game.Players.LocalPlayer.CameraMinZoomDistance = Value
   end,
})
local slider = PlayerTab:CreateSlider({
   Name = "Gravity",
   Range = {0, 200},
   Increment = 1,
   Suffix = "Gravity",
   CurrentValue = 0,
   Flag = "Gravity",
   Callback = function(Value)
      game.Workspace.Gravity = Value
   end,
})


-- Shop Tab
local ShopTab = MainWindow:CreateTab("Sell", 6473525198)
ShopTab:CreateButton({
   Name = "Sell All (1 click)",
   Callback = function()
   end,
})




-- Settings Tab
local SettingsTab = MainWindow:CreateTab("Settings", 9743465390)


SettingsTab:CreateDropdown({
   Name = "Select Theme",
   Options = {"Default", "Amber Glow", "Amethyst", "Bloom", "Dark Blue", "Green", "Light", "Ocean", "Serenity"},
   MultiSelect = false,
   CurrentOption = "Default",
   Callback = function()
     
   end,
})

-- Credits Tab
local CreditsTab = MainWindow:CreateTab("Credits", 18754976792)
CreditsTab:CreateLabel("Made by QuocHung")
CreditsTab:CreateButton({
   Name = "Join my discord server: https://dsc.gg/thenoicez",
   Callback = function()
      setclipboard("https://dsc.gg/thenoicez")
      NughNguyen:Notify({
         Title = "GumballZ | Hub",
         Content = "Đã copy link discord server",
         Duration = 5,
         Image = 84828491431270,
         Actions = {
            Okay = {
               Name = "OK",
               Callback = function()
                  print("Đã copy link discord server")
               end
            },
         },
      })
   end,
})
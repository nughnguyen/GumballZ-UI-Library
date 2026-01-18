local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield UI Demo",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Rayfield Demo"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Rayfield Key",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Main Tab", 4483362458) -- Title, Image

local MainSection = MainTab:CreateSection("Main Elements")

local Button = MainTab:CreateButton({
   Name = "Test Button",
   Callback = function()
      Rayfield:Notify({
         Title = "Notification Title",
         Content = "Notification Content",
         Duration = 6.5,
         Image = 4483362458,
         Actions = { -- Notification Actions
            Ignore = {
               Name = "Okay!",
               Callback = function()
                  print("The user tapped Okay!")
               end
            },
         },
      })
   end,
})

local Toggle = MainTab:CreateToggle({
   Name = "Test Toggle",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      print("Toggle Value:", Value)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Test Slider",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 50,
   Flag = "Slider1", 
   Callback = function(Value)
      print("Slider Value:", Value)
   end,
})

local Input = MainTab:CreateInput({
   Name = "Test Input",
   PlaceholderText = "Input Placeholder",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      print("Input Text:", Text)
   end,
})

local Dropdown = MainTab:CreateDropdown({
   Name = "Test Dropdown",
   Options = {"Option 1", "Option 2", "Option 3"},
   CurrentOption = {"Option 1"},
   MultipleOptions = false,
   Flag = "Dropdown1", 
   Callback = function(Option)
      print("Dropdown Option:", Option)
   end,
})

local MultiDropdown = MainTab:CreateDropdown({
   Name = "Test Multi Dropdown",
   Options = {"Option 1", "Option 2", "Option 3"},
   CurrentOption = {"Option 1", "Option 3"},
   MultipleOptions = true,
   Flag = "MultiDropdown1", 
   Callback = function(Options)
       for i,v in pairs(Options) do
            print("Multi Selection:", v)
       end
   end,
})

local ColorPicker = MainTab:CreateColorPicker({
    Name = "Color Picker",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1", 
    Callback = function(Value)
        print("Color:", Value)
    end
})

local Keybind = MainTab:CreateKeybind({
   Name = "Test Keybind",
   CurrentKeybind = "Q",
   HoldToInteract = false,
   Flag = "Keybind1", 
   Callback = function(Keybind)
      print("Keybind Pressed:", Keybind)
   end,
})

local Label = MainTab:CreateLabel("Test Label")

local Paragraph = MainTab:CreateParagraph({Title = "Test Paragraph", Content = "This is a test paragraph content."})


local SecondTab = Window:CreateTab("Other Tab", 4483362458)
local Section2 = SecondTab:CreateSection("Other Section")

SecondTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})
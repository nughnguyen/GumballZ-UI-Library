--[[
    		GumballZ-Dark Interface

    Author: NGUYEN QUOC HUNG
    License: MIT
    Github: https://github.com/nughnguyen/GumballZ-UI-Library
--]]

-- Export Types --
export type Window = {
	Name: string,
	Keybind: string | Enum.KeyCode,
	Scale: UDim2,
	Expire: string
}

export type Loader = {
	Name: string,
	Duration: number,
	Scale: number,
	Particle: boolean?,
	ParticleDuration: number?,
	ParticleScale: number?,
	["particle duration"]: number?, -- Legacy support
	Blur: boolean?
}

export type Menu = {
	Name: string,
	Icon: string,
	AutoFill: boolean
}

export type Section = {
	Name: string,
	Position: string,
	Height: number,
}

export type Listbox = {
	Name: string,
	Option: boolean,
	Multi: boolean,
	Position: string,
	Flag: string | nil,
	Height: number,
	Default: ValueBase,
	Values: {ValueBase},
	Callback: (values: {ValueBase}) -> any
}

export type Elements = {
	AddToggle: (self,Config: Toggle) -> {
		Option: Elements	
	},
	AddSlider: (self,Config: Slider) -> {
		Option: Elements	
	},
	AddButton: (self,Config: Button) -> {},
	AddColorPicker: (self,Config: ColorPicker) -> {
		Option: Elements	
	},
	AddDropdown: (self,Config: Dropdown) -> {
		Option: Elements	
	},
	AddKeybind: (self,Config: Keybind) -> {
		Option: Elements	
	},
	AddDivider: (self) -> nil,
	AddParagraph: (self,Config: {Title: string, Content: string}) -> nil,
	AddPlayerView: (self,Config: {Height: number}) -> nil,
}

export type Preview = {
	Position: string,
	Height: number
}

export type Toggle = {
	Name: string,
	Default: boolean,
	Callback: (boolean) -> any,
	Risky: boolean,
	Option: boolean,
	Flag: string | nil,
}

export type Slider = {
	Name: string,
	Default: number,
	Min: number,
	Max: number,
	Round: number,
	Type: string,
	Callback: (number) -> any,
	Risky: boolean,
	Flag: string | nil,
	Option: boolean
}

export type Button = {
	Name: string,
	Callback: (number) -> any,
	Risky: boolean,
}

export type ColorPicker = {
	Name: string,
	Default: Color3,
	Transparency: number,
	Callback: (number) -> any,
	Flag: string | nil,
	Option: boolean
}

export type Dropdown = {
	Name: string,
	Default: string | {string},
	Values: {string},
	Callback: (string | {string}) -> any,
	Option: boolean,
	Multi: boolean,
	Flag: string | nil,
	AutoUpdate: boolean
}

export type Keybind = {
	Name: string,
	Default: string | Enum.KeyCode,
	Callback: (string) -> any,
	Flag: string | nil,
	Option: boolean,
}

export type Notify = {
	Title: string,
	Content: string,
	Duration: number,
	Flag: string | nil,
	Icon: string
}

export type Notifier = {
	Notify: (self, Config: Notify) -> nil
}

-- Exploit Environments --
cloneref = cloneref or function(i) return i; end;
clonefunction = clonefunction or function(...) return ...; end;
hookfunction = hookfunction or function(a,b) return a; end;
getgenv = getgenv or getfenv;
protect_gui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;
getgenv().LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(f) return f end;

if game:GetService('RunService'):IsStudio() then
	local BaseWorkspace = Instance.new('Folder',game:GetService("ReplicatedFirst"));

	BaseWorkspace.Name = "WORKSPACE";

	local __get_path_c = function(path)
		return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
	end

	local __get_path = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			block = block[v];
		end;

		return block;
	end;

	getgenv().readfile = function(path)
		local path : StringValue = __get_path(path);

		return path.Value;
	end;

	getgenv().isfile = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and not message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().isfolder = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().writefile = function(path,content)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('StringValue',block);

				c.Name = tostring(v);
				c.Value = content;
			else
				if item:IsA('StringValue') and tostring(item) == v then
					item.Name = tostring(v);
					item.Value = content;
				end;

				block = item;
			end;
		end;
	end;

	getgenv().listfiles = function(path)
		local fold = __get_path(path);
		local pa = {};

		for i,v in next , fold:GetChildren() do
			if v:IsA('StringValue') then
				table.insert(pa,path..'/'..tostring(v));
			end;
		end;

		return pa;
	end;

	getgenv().makefolder = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('Folder',block);

				c.Name = tostring(v);
			else
				block = item;
			end;
		end;
	end;

	getgenv().delfile = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if item and item:IsA('StringValue') then
				item:Destroy();
			else
				block = item;
			end;
		end;
	end;
end;

-- Services --
local TextService = cloneref(game:GetService('TextService'));
local TweenService = cloneref(game:GetService('TweenService'));
local RunService = cloneref(game:GetService('RunService'));
local Players = cloneref(game:GetService('Players'));
local UserInputService = cloneref(game:GetService('UserInputService'));
local Client = Players.LocalPlayer;
local Mouse = Client:GetMouse();
local CurrentCamera = workspace.CurrentCamera;
local _,CoreGui = xpcall(function()
	return (gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui");
end,function()
	return Client.PlayerGui;
end);

-- GumballZ --
local GumballZ = {};

GumballZ.Ascii = "qwertyuiopasdfghjklzxcvbnmQWRTYUIOPASDFGHJKLZXCVBNM";
GumballZ.GLOBAL_ENVIRONMENT = {};
GumballZ.Windows = {};
GumballZ.FontSemiBold = Font.new('rbxasset://fonts/families/GothamSSm.json',Enum.FontWeight.SemiBold,Enum.FontStyle.Normal);
GumballZ.Flags = {};
GumballZ.Colors = {
	Black = Color3.fromRGB(16, 16, 16),
	Main = Color3.fromRGB(0, 255, 255)
};
GumballZ.DragBlacklist = {};
GumballZ.Version = '1.6';
GumballZ.Lucide = {
	["lucide-accessibility"] = "rbxassetid://10709751939",
	["lucide-activity"] = "rbxassetid://10709752035",
	["lucide-air-vent"] = "rbxassetid://10709752131",
	["lucide-airplay"] = "rbxassetid://10709752254",
	["lucide-alarm-check"] = "rbxassetid://10709752405",
	["lucide-alarm-clock"] = "rbxassetid://10709752630",
	["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
	["lucide-alarm-minus"] = "rbxassetid://10709752732",
	["lucide-alarm-plus"] = "rbxassetid://10709752825",
	["lucide-album"] = "rbxassetid://10709752906",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-octagon"] = "rbxassetid://10709753064",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-align-center"] = "rbxassetid://10709753570",
	["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
	["lucide-align-center-vertical"] = "rbxassetid://10709753421",
	["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
	["lucide-align-end-vertical"] = "rbxassetid://10709753808",
	["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
	["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
	["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
	["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
	["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
	["lucide-align-justify"] = "rbxassetid://10709759610",
	["lucide-align-left"] = "rbxassetid://10709759764",
	["lucide-align-right"] = "rbxassetid://10709759895",
	["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
	["lucide-align-start-vertical"] = "rbxassetid://10709760244",
	["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
	["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
	["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
	["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
	["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
	["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
	["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
	["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
	["lucide-anchor"] = "rbxassetid://10709761530",
	["lucide-angry"] = "rbxassetid://10709761629",
	["lucide-annoyed"] = "rbxassetid://10709761722",
	["lucide-aperture"] = "rbxassetid://10709761813",
	["lucide-apple"] = "rbxassetid://10709761889",
	["lucide-archive"] = "rbxassetid://10709762233",
	["lucide-archive-restore"] = "rbxassetid://10709762058",
	["lucide-armchair"] = "rbxassetid://10709762327",
	["lucide-arrow-big-down"] = "rbxassetid://10747796644",
	["lucide-arrow-big-left"] = "rbxassetid://10709762574",
	["lucide-arrow-big-right"] = "rbxassetid://10709762727",
	["lucide-arrow-big-up"] = "rbxassetid://10709762879",
	["lucide-arrow-down"] = "rbxassetid://10709767827",
	["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
	["lucide-arrow-down-left"] = "rbxassetid://10709767656",
	["lucide-arrow-down-right"] = "rbxassetid://10709767750",
	["lucide-arrow-left"] = "rbxassetid://10709768114",
	["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
	["lucide-arrow-left-right"] = "rbxassetid://10709768019",
	["lucide-arrow-right"] = "rbxassetid://10709768347",
	["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
	["lucide-arrow-up"] = "rbxassetid://10709768939",
	["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
	["lucide-arrow-up-down"] = "rbxassetid://10709768538",
	["lucide-arrow-up-left"] = "rbxassetid://10709768661",
	["lucide-arrow-up-right"] = "rbxassetid://10709768787",
	["lucide-asterisk"] = "rbxassetid://10709769095",
	["lucide-at-sign"] = "rbxassetid://10709769286",
	["lucide-award"] = "rbxassetid://10709769406",
	["lucide-axe"] = "rbxassetid://10709769508",
	["lucide-axis-3d"] = "rbxassetid://10709769598",
	["lucide-baby"] = "rbxassetid://10709769732",
	["lucide-backpack"] = "rbxassetid://10709769841",
	["lucide-baggage-claim"] = "rbxassetid://10709769935",
	["lucide-banana"] = "rbxassetid://10709770005",
	["lucide-banknote"] = "rbxassetid://10709770178",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-bar-chart-3"] = "rbxassetid://10709770431",
	["lucide-bar-chart-4"] = "rbxassetid://10709770560",
	["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
	["lucide-barcode"] = "rbxassetid://10747360675",
	["lucide-baseline"] = "rbxassetid://10709773863",
	["lucide-bath"] = "rbxassetid://10709773963",
	["lucide-battery"] = "rbxassetid://10709774640",
	["lucide-battery-charging"] = "rbxassetid://10709774068",
	["lucide-battery-full"] = "rbxassetid://10709774206",
	["lucide-battery-low"] = "rbxassetid://10709774370",
	["lucide-battery-medium"] = "rbxassetid://10709774513",
	["lucide-beaker"] = "rbxassetid://10709774756",
	["lucide-bed"] = "rbxassetid://10709775036",
	["lucide-bed-double"] = "rbxassetid://10709774864",
	["lucide-bed-single"] = "rbxassetid://10709774968",
	["lucide-beer"] = "rbxassetid://10709775167",
	["lucide-bell"] = "rbxassetid://10709775704",
	["lucide-bell-minus"] = "rbxassetid://10709775241",
	["lucide-bell-off"] = "rbxassetid://10709775320",
	["lucide-bell-plus"] = "rbxassetid://10709775448",
	["lucide-bell-ring"] = "rbxassetid://10709775560",
	["lucide-bike"] = "rbxassetid://10709775894",
	["lucide-binary"] = "rbxassetid://10709776050",
	["lucide-bitcoin"] = "rbxassetid://10709776126",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
	["lucide-bluetooth-off"] = "rbxassetid://10709776344",
	["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
	["lucide-bold"] = "rbxassetid://10747813908",
	["lucide-bomb"] = "rbxassetid://10709781460",
	["lucide-bone"] = "rbxassetid://10709781605",
	["lucide-book"] = "rbxassetid://10709781824",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-bookmark"] = "rbxassetid://10709782154",
	["lucide-bookmark-minus"] = "rbxassetid://10709781919",
	["lucide-bookmark-plus"] = "rbxassetid://10709782044",
	["lucide-bot"] = "rbxassetid://10709782230",
	["lucide-box"] = "rbxassetid://10709782497",
	["lucide-box-select"] = "rbxassetid://10709782342",
	["lucide-boxes"] = "rbxassetid://10709782582",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-brush"] = "rbxassetid://10709782758",
	["lucide-bug"] = "rbxassetid://10709782845",
	["lucide-building"] = "rbxassetid://10709783051",
	["lucide-building-2"] = "rbxassetid://10709782939",
	["lucide-bus"] = "rbxassetid://10709783137",
	["lucide-cake"] = "rbxassetid://10709783217",
	["lucide-calculator"] = "rbxassetid://10709783311",
	["lucide-calendar"] = "rbxassetid://10709789505",
	["lucide-calendar-check"] = "rbxassetid://10709783474",
	["lucide-calendar-check-2"] = "rbxassetid://10709783392",
	["lucide-calendar-clock"] = "rbxassetid://10709783577",
	["lucide-calendar-days"] = "rbxassetid://10709783673",
	["lucide-calendar-heart"] = "rbxassetid://10709783835",
	["lucide-calendar-minus"] = "rbxassetid://10709783959",
	["lucide-calendar-off"] = "rbxassetid://10709788784",
	["lucide-calendar-plus"] = "rbxassetid://10709788937",
	["lucide-calendar-range"] = "rbxassetid://10709789053",
	["lucide-calendar-search"] = "rbxassetid://10709789200",
	["lucide-calendar-x"] = "rbxassetid://10709789407",
	["lucide-calendar-x-2"] = "rbxassetid://10709789329",
	["lucide-camera"] = "rbxassetid://10709789686",
	["lucide-camera-off"] = "rbxassetid://10747822677",
	["lucide-car"] = "rbxassetid://10709789810",
	["lucide-carrot"] = "rbxassetid://10709789960",
	["lucide-cast"] = "rbxassetid://10709790097",
	["lucide-charge"] = "rbxassetid://10709790202",
	["lucide-check"] = "rbxassetid://10709790644",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-circle-2"] = "rbxassetid://10709790298",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chef-hat"] = "rbxassetid://10709790757",
	["lucide-cherry"] = "rbxassetid://10709790875",
	["lucide-chevron-down"] = "rbxassetid://10709790948",
	["lucide-chevron-first"] = "rbxassetid://10709791015",
	["lucide-chevron-last"] = "rbxassetid://10709791130",
	["lucide-chevron-left"] = "rbxassetid://10709791281",
	["lucide-chevron-right"] = "rbxassetid://10709791437",
	["lucide-chevron-up"] = "rbxassetid://10709791523",
	["lucide-chevrons-down"] = "rbxassetid://10709796864",
	["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
	["lucide-chevrons-left"] = "rbxassetid://10709797151",
	["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
	["lucide-chevrons-right"] = "rbxassetid://10709797382",
	["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
	["lucide-chevrons-up"] = "rbxassetid://10709797622",
	["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
	["lucide-chrome"] = "rbxassetid://10709797725",
	["lucide-circle"] = "rbxassetid://10709798174",
	["lucide-circle-dot"] = "rbxassetid://10709797837",
	["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
	["lucide-circle-slashed"] = "rbxassetid://10709798100",
	["lucide-citrus"] = "rbxassetid://10709798276",
	["lucide-clapperboard"] = "rbxassetid://10709798350",
	["lucide-clipboard"] = "rbxassetid://10709799288",
	["lucide-clipboard-check"] = "rbxassetid://10709798443",
	["lucide-clipboard-copy"] = "rbxassetid://10709798574",
	["lucide-clipboard-edit"] = "rbxassetid://10709798682",
	["lucide-clipboard-list"] = "rbxassetid://10709798792",
	["lucide-clipboard-signature"] = "rbxassetid://10709798890",
	["lucide-clipboard-type"] = "rbxassetid://10709798999",
	["lucide-clipboard-x"] = "rbxassetid://10709799124",
	["lucide-clock"] = "rbxassetid://10709805144",
	["lucide-clock-1"] = "rbxassetid://10709799535",
	["lucide-clock-10"] = "rbxassetid://10709799718",
	["lucide-clock-11"] = "rbxassetid://10709799818",
	["lucide-clock-12"] = "rbxassetid://10709799962",
	["lucide-clock-2"] = "rbxassetid://10709803876",
	["lucide-clock-3"] = "rbxassetid://10709803989",
	["lucide-clock-4"] = "rbxassetid://10709804164",
	["lucide-clock-5"] = "rbxassetid://10709804291",
	["lucide-clock-6"] = "rbxassetid://10709804435",
	["lucide-clock-7"] = "rbxassetid://10709804599",
	["lucide-clock-8"] = "rbxassetid://10709804784",
	["lucide-clock-9"] = "rbxassetid://10709804996",
	["lucide-cloud"] = "rbxassetid://10709806740",
	["lucide-cloud-cog"] = "rbxassetid://10709805262",
	["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
	["lucide-cloud-fog"] = "rbxassetid://10709805477",
	["lucide-cloud-hail"] = "rbxassetid://10709805596",
	["lucide-cloud-lightning"] = "rbxassetid://10709805727",
	["lucide-cloud-moon"] = "rbxassetid://10709805942",
	["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
	["lucide-cloud-off"] = "rbxassetid://10709806060",
	["lucide-cloud-rain"] = "rbxassetid://10709806277",
	["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
	["lucide-cloud-snow"] = "rbxassetid://10709806374",
	["lucide-cloud-sun"] = "rbxassetid://10709806631",
	["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
	["lucide-cloudy"] = "rbxassetid://10709806859",
	["lucide-clover"] = "rbxassetid://10709806995",
	["lucide-code"] = "rbxassetid://10709810463",
	["lucide-code-2"] = "rbxassetid://10709807111",
	["lucide-codepen"] = "rbxassetid://10709810534",
	["lucide-codesandbox"] = "rbxassetid://10709810676",
	["lucide-coffee"] = "rbxassetid://10709810814",
	["lucide-cog"] = "rbxassetid://10709810948",
	["lucide-coins"] = "rbxassetid://10709811110",
	["lucide-columns"] = "rbxassetid://10709811261",
	["lucide-command"] = "rbxassetid://10709811365",
	["lucide-compass"] = "rbxassetid://10709811445",
	["lucide-component"] = "rbxassetid://10709811595",
	["lucide-concierge-bell"] = "rbxassetid://10709811706",
	["lucide-connection"] = "rbxassetid://10747361219",
	["lucide-contact"] = "rbxassetid://10709811834",
	["lucide-contrast"] = "rbxassetid://10709811939",
	["lucide-cookie"] = "rbxassetid://10709812067",
	["lucide-copy"] = "rbxassetid://10709812159",
	["lucide-copyleft"] = "rbxassetid://10709812251",
	["lucide-copyright"] = "rbxassetid://10709812311",
	["lucide-corner-down-left"] = "rbxassetid://10709812396",
	["lucide-corner-down-right"] = "rbxassetid://10709812485",
	["lucide-corner-left-down"] = "rbxassetid://10709812632",
	["lucide-corner-left-up"] = "rbxassetid://10709812784",
	["lucide-corner-right-down"] = "rbxassetid://10709812939",
	["lucide-corner-right-up"] = "rbxassetid://10709813094",
	["lucide-corner-up-left"] = "rbxassetid://10709813185",
	["lucide-corner-up-right"] = "rbxassetid://10709813281",
	["lucide-cpu"] = "rbxassetid://10709813383",
	["lucide-croissant"] = "rbxassetid://10709818125",
	["lucide-crop"] = "rbxassetid://10709818245",
	["lucide-cross"] = "rbxassetid://10709818399",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-crown"] = "rbxassetid://10709818626",
	["lucide-cup-soda"] = "rbxassetid://10709818763",
	["lucide-curly-braces"] = "rbxassetid://10709818847",
	["lucide-currency"] = "rbxassetid://10709818931",
	["lucide-database"] = "rbxassetid://10709818996",
	["lucide-delete"] = "rbxassetid://10709819059",
	["lucide-diamond"] = "rbxassetid://10709819149",
	["lucide-dice-1"] = "rbxassetid://10709819266",
	["lucide-dice-2"] = "rbxassetid://10709819361",
	["lucide-dice-3"] = "rbxassetid://10709819508",
	["lucide-dice-4"] = "rbxassetid://10709819670",
	["lucide-dice-5"] = "rbxassetid://10709819801",
	["lucide-dice-6"] = "rbxassetid://10709819896",
	["lucide-dices"] = "rbxassetid://10723343321",
	["lucide-diff"] = "rbxassetid://10723343416",
	["lucide-disc"] = "rbxassetid://10723343537",
	["lucide-divide"] = "rbxassetid://10723343805",
	["lucide-divide-circle"] = "rbxassetid://10723343636",
	["lucide-divide-square"] = "rbxassetid://10723343737",
	["lucide-dollar-sign"] = "rbxassetid://10723343958",
	["lucide-download"] = "rbxassetid://10723344270",
	["lucide-download-cloud"] = "rbxassetid://10723344088",
	["lucide-droplet"] = "rbxassetid://10723344432",
	["lucide-droplets"] = "rbxassetid://10734883356",
	["lucide-drumstick"] = "rbxassetid://10723344737",
	["lucide-edit"] = "rbxassetid://10734883598",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-edit-3"] = "rbxassetid://10723345088",
	["lucide-egg"] = "rbxassetid://10723345518",
	["lucide-egg-fried"] = "rbxassetid://10723345347",
	["lucide-electricity"] = "rbxassetid://10723345749",
	["lucide-electricity-off"] = "rbxassetid://10723345643",
	["lucide-equal"] = "rbxassetid://10723345990",
	["lucide-equal-not"] = "rbxassetid://10723345866",
	["lucide-eraser"] = "rbxassetid://10723346158",
	["lucide-euro"] = "rbxassetid://10723346372",
	["lucide-expand"] = "rbxassetid://10723346553",
	["lucide-external-link"] = "rbxassetid://10723346684",
	["lucide-eye"] = "rbxassetid://10723346959",
	["lucide-eye-off"] = "rbxassetid://10723346871",
	["lucide-factory"] = "rbxassetid://10723347051",
	["lucide-fan"] = "rbxassetid://10723354359",
	["lucide-fast-forward"] = "rbxassetid://10723354521",
	["lucide-feather"] = "rbxassetid://10723354671",
	["lucide-figma"] = "rbxassetid://10723354801",
	["lucide-file"] = "rbxassetid://10723374641",
	["lucide-file-archive"] = "rbxassetid://10723354921",
	["lucide-file-audio"] = "rbxassetid://10723355148",
	["lucide-file-audio-2"] = "rbxassetid://10723355026",
	["lucide-file-axis-3d"] = "rbxassetid://10723355272",
	["lucide-file-badge"] = "rbxassetid://10723355622",
	["lucide-file-badge-2"] = "rbxassetid://10723355451",
	["lucide-file-bar-chart"] = "rbxassetid://10723355887",
	["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
	["lucide-file-box"] = "rbxassetid://10723355989",
	["lucide-file-check"] = "rbxassetid://10723356210",
	["lucide-file-check-2"] = "rbxassetid://10723356100",
	["lucide-file-clock"] = "rbxassetid://10723356329",
	["lucide-file-code"] = "rbxassetid://10723356507",
	["lucide-file-cog"] = "rbxassetid://10723356830",
	["lucide-file-cog-2"] = "rbxassetid://10723356676",
	["lucide-file-diff"] = "rbxassetid://10723357039",
	["lucide-file-digit"] = "rbxassetid://10723357151",
	["lucide-file-down"] = "rbxassetid://10723357322",
	["lucide-file-edit"] = "rbxassetid://10723357495",
	["lucide-file-heart"] = "rbxassetid://10723357637",
	["lucide-file-image"] = "rbxassetid://10723357790",
	["lucide-file-input"] = "rbxassetid://10723357933",
	["lucide-file-json"] = "rbxassetid://10723364435",
	["lucide-file-json-2"] = "rbxassetid://10723364361",
	["lucide-file-key"] = "rbxassetid://10723364605",
	["lucide-file-key-2"] = "rbxassetid://10723364515",
	["lucide-file-line-chart"] = "rbxassetid://10723364725",
	["lucide-file-lock"] = "rbxassetid://10723364957",
	["lucide-file-lock-2"] = "rbxassetid://10723364861",
	["lucide-file-minus"] = "rbxassetid://10723365254",
	["lucide-file-minus-2"] = "rbxassetid://10723365086",
	["lucide-file-output"] = "rbxassetid://10723365457",
	["lucide-file-pie-chart"] = "rbxassetid://10723365598",
	["lucide-file-plus"] = "rbxassetid://10723365877",
	["lucide-file-plus-2"] = "rbxassetid://10723365766",
	["lucide-file-question"] = "rbxassetid://10723365987",
	["lucide-file-scan"] = "rbxassetid://10723366167",
	["lucide-file-search"] = "rbxassetid://10723366550",
	["lucide-file-search-2"] = "rbxassetid://10723366340",
	["lucide-file-signature"] = "rbxassetid://10723366741",
	["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
	["lucide-file-symlink"] = "rbxassetid://10723367098",
	["lucide-file-terminal"] = "rbxassetid://10723367244",
	["lucide-file-text"] = "rbxassetid://10723367380",
	["lucide-file-type"] = "rbxassetid://10723367606",
	["lucide-file-type-2"] = "rbxassetid://10723367509",
	["lucide-file-up"] = "rbxassetid://10723367734",
	["lucide-file-video"] = "rbxassetid://10723373884",
	["lucide-file-video-2"] = "rbxassetid://10723367834",
	["lucide-file-volume"] = "rbxassetid://10723374172",
	["lucide-file-volume-2"] = "rbxassetid://10723374030",
	["lucide-file-warning"] = "rbxassetid://10723374276",
	["lucide-file-x"] = "rbxassetid://10723374544",
	["lucide-file-x-2"] = "rbxassetid://10723374378",
	["lucide-files"] = "rbxassetid://10723374759",
	["lucide-film"] = "rbxassetid://10723374981",
	["lucide-filter"] = "rbxassetid://10723375128",
	["lucide-fingerprint"] = "rbxassetid://10723375250",
	["lucide-flag"] = "rbxassetid://10723375890",
	["lucide-flag-off"] = "rbxassetid://10723375443",
	["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
	["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
	["lucide-flame"] = "rbxassetid://10723376114",
	["lucide-flashlight"] = "rbxassetid://10723376471",
	["lucide-flashlight-off"] = "rbxassetid://10723376365",
	["lucide-flask-conical"] = "rbxassetid://10734883986",
	["lucide-flask-round"] = "rbxassetid://10723376614",
	["lucide-flip-horizontal"] = "rbxassetid://10723376884",
	["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
	["lucide-flip-vertical"] = "rbxassetid://10723377138",
	["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
	["lucide-flower"] = "rbxassetid://10747830374",
	["lucide-flower-2"] = "rbxassetid://10723377305",
	["lucide-focus"] = "rbxassetid://10723377537",
	["lucide-folder"] = "rbxassetid://10723387563",
	["lucide-folder-archive"] = "rbxassetid://10723384478",
	["lucide-folder-check"] = "rbxassetid://10723384605",
	["lucide-folder-clock"] = "rbxassetid://10723384731",
	["lucide-folder-closed"] = "rbxassetid://10723384893",
	["lucide-folder-cog"] = "rbxassetid://10723385213",
	["lucide-folder-cog-2"] = "rbxassetid://10723385036",
	["lucide-folder-down"] = "rbxassetid://10723385338",
	["lucide-folder-edit"] = "rbxassetid://10723385445",
	["lucide-folder-heart"] = "rbxassetid://10723385545",
	["lucide-folder-input"] = "rbxassetid://10723385721",
	["lucide-folder-key"] = "rbxassetid://10723385848",
	["lucide-folder-lock"] = "rbxassetid://10723386005",
	["lucide-folder-minus"] = "rbxassetid://10723386127",
	["lucide-folder-open"] = "rbxassetid://10723386277",
	["lucide-folder-output"] = "rbxassetid://10723386386",
	["lucide-folder-plus"] = "rbxassetid://10723386531",
	["lucide-folder-search"] = "rbxassetid://10723386787",
	["lucide-folder-search-2"] = "rbxassetid://10723386674",
	["lucide-folder-symlink"] = "rbxassetid://10723386930",
	["lucide-folder-tree"] = "rbxassetid://10723387085",
	["lucide-folder-up"] = "rbxassetid://10723387265",
	["lucide-folder-x"] = "rbxassetid://10723387448",
	["lucide-folders"] = "rbxassetid://10723387721",
	["lucide-form-input"] = "rbxassetid://10723387841",
	["lucide-forward"] = "rbxassetid://10723388016",
	["lucide-frame"] = "rbxassetid://10723394389",
	["lucide-framer"] = "rbxassetid://10723394565",
	["lucide-frown"] = "rbxassetid://10723394681",
	["lucide-fuel"] = "rbxassetid://10723394846",
	["lucide-function-square"] = "rbxassetid://10723395041",
	["lucide-gamepad"] = "rbxassetid://10723395457",
	["lucide-gamepad-2"] = "rbxassetid://10723395215",
	["lucide-gauge"] = "rbxassetid://10723395708",
	["lucide-gavel"] = "rbxassetid://10723395896",
	["lucide-gem"] = "rbxassetid://10723396000",
	["lucide-ghost"] = "rbxassetid://10723396107",
	["lucide-gift"] = "rbxassetid://10723396402",
	["lucide-gift-card"] = "rbxassetid://10723396225",
	["lucide-git-branch"] = "rbxassetid://10723396676",
	["lucide-git-branch-plus"] = "rbxassetid://10723396542",
	["lucide-git-commit"] = "rbxassetid://10723396812",
	["lucide-git-compare"] = "rbxassetid://10723396954",
	["lucide-git-fork"] = "rbxassetid://10723397049",
	["lucide-git-merge"] = "rbxassetid://10723397165",
	["lucide-git-pull-request"] = "rbxassetid://10723397431",
	["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
	["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
	["lucide-glass"] = "rbxassetid://10723397788",
	["lucide-glass-2"] = "rbxassetid://10723397529",
	["lucide-glass-water"] = "rbxassetid://10723397678",
	["lucide-glasses"] = "rbxassetid://10723397895",
	["lucide-globe"] = "rbxassetid://10723404337",
	["lucide-globe-2"] = "rbxassetid://10723398002",
	["lucide-grab"] = "rbxassetid://10723404472",
	["lucide-graduation-cap"] = "rbxassetid://10723404691",
	["lucide-grape"] = "rbxassetid://10723404822",
	["lucide-grid"] = "rbxassetid://10723404936",
	["lucide-grip-horizontal"] = "rbxassetid://10723405089",
	["lucide-grip-vertical"] = "rbxassetid://10723405236",
	["lucide-hammer"] = "rbxassetid://10723405360",
	["lucide-hand"] = "rbxassetid://10723405649",
	["lucide-hand-metal"] = "rbxassetid://10723405508",
	["lucide-hard-drive"] = "rbxassetid://10723405749",
	["lucide-hard-hat"] = "rbxassetid://10723405859",
	["lucide-hash"] = "rbxassetid://10723405975",
	["lucide-haze"] = "rbxassetid://10723406078",
	["lucide-headphones"] = "rbxassetid://10723406165",
	["lucide-heart"] = "rbxassetid://10723406885",
	["lucide-heart-crack"] = "rbxassetid://10723406299",
	["lucide-heart-handshake"] = "rbxassetid://10723406480",
	["lucide-heart-off"] = "rbxassetid://10723406662",
	["lucide-heart-pulse"] = "rbxassetid://10723406795",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-hexagon"] = "rbxassetid://10723407092",
	["lucide-highlighter"] = "rbxassetid://10723407192",
	["lucide-history"] = "rbxassetid://10723407335",
	["lucide-home"] = "rbxassetid://10723407389",
	["lucide-hourglass"] = "rbxassetid://10723407498",
	["lucide-ice-cream"] = "rbxassetid://10723414308",
	["lucide-image"] = "rbxassetid://10723415040",
	["lucide-image-minus"] = "rbxassetid://10723414487",
	["lucide-image-off"] = "rbxassetid://10723414677",
	["lucide-image-plus"] = "rbxassetid://10723414827",
	["lucide-import"] = "rbxassetid://10723415205",
	["lucide-inbox"] = "rbxassetid://10723415335",
	["lucide-indent"] = "rbxassetid://10723415494",
	["lucide-indian-rupee"] = "rbxassetid://10723415642",
	["lucide-infinity"] = "rbxassetid://10723415766",
	["lucide-info"] = "rbxassetid://10723415903",
	["lucide-inspect"] = "rbxassetid://10723416057",
	["lucide-italic"] = "rbxassetid://10723416195",
	["lucide-japanese-yen"] = "rbxassetid://10723416363",
	["lucide-joystick"] = "rbxassetid://10723416527",
	["lucide-key"] = "rbxassetid://10723416652",
	["lucide-keyboard"] = "rbxassetid://10723416765",
	["lucide-lamp"] = "rbxassetid://10723417513",
	["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
	["lucide-lamp-desk"] = "rbxassetid://10723417016",
	["lucide-lamp-floor"] = "rbxassetid://10723417131",
	["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
	["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
	["lucide-landmark"] = "rbxassetid://10723417608",
	["lucide-languages"] = "rbxassetid://10723417703",
	["lucide-laptop"] = "rbxassetid://10723423881",
	["lucide-laptop-2"] = "rbxassetid://10723417797",
	["lucide-lasso"] = "rbxassetid://10723424235",
	["lucide-lasso-select"] = "rbxassetid://10723424058",
	["lucide-laugh"] = "rbxassetid://10723424372",
	["lucide-layers"] = "rbxassetid://10723424505",
	["lucide-layout"] = "rbxassetid://10723425376",
	["lucide-layout-dashboard"] = "rbxassetid://10723424646",
	["lucide-layout-grid"] = "rbxassetid://10723424838",
	["lucide-layout-list"] = "rbxassetid://10723424963",
	["lucide-layout-template"] = "rbxassetid://10723425187",
	["lucide-leaf"] = "rbxassetid://10723425539",
	["lucide-library"] = "rbxassetid://10723425615",
	["lucide-life-buoy"] = "rbxassetid://10723425685",
	["lucide-lightbulb"] = "rbxassetid://10723425852",
	["lucide-lightbulb-off"] = "rbxassetid://10723425762",
	["lucide-line-chart"] = "rbxassetid://10723426393",
	["lucide-link"] = "rbxassetid://10723426722",
	["lucide-link-2"] = "rbxassetid://10723426595",
	["lucide-link-2-off"] = "rbxassetid://10723426513",
	["lucide-list"] = "rbxassetid://10723433811",
	["lucide-list-checks"] = "rbxassetid://10734884548",
	["lucide-list-end"] = "rbxassetid://10723426886",
	["lucide-list-minus"] = "rbxassetid://10723426986",
	["lucide-list-music"] = "rbxassetid://10723427081",
	["lucide-list-ordered"] = "rbxassetid://10723427199",
	["lucide-list-plus"] = "rbxassetid://10723427334",
	["lucide-list-start"] = "rbxassetid://10723427494",
	["lucide-list-video"] = "rbxassetid://10723427619",
	["lucide-list-x"] = "rbxassetid://10723433655",
	["lucide-loader"] = "rbxassetid://10723434070",
	["lucide-loader-2"] = "rbxassetid://10723433935",
	["lucide-locate"] = "rbxassetid://10723434557",
	["lucide-locate-fixed"] = "rbxassetid://10723434236",
	["lucide-locate-off"] = "rbxassetid://10723434379",
	["lucide-lock"] = "rbxassetid://10723434711",
	["lucide-log-in"] = "rbxassetid://10723434830",
	["lucide-log-out"] = "rbxassetid://10723434906",
	["lucide-luggage"] = "rbxassetid://10723434993",
	["lucide-magnet"] = "rbxassetid://10723435069",
	["lucide-mail"] = "rbxassetid://10734885430",
	["lucide-mail-check"] = "rbxassetid://10723435182",
	["lucide-mail-minus"] = "rbxassetid://10723435261",
	["lucide-mail-open"] = "rbxassetid://10723435342",
	["lucide-mail-plus"] = "rbxassetid://10723435443",
	["lucide-mail-question"] = "rbxassetid://10723435515",
	["lucide-mail-search"] = "rbxassetid://10734884739",
	["lucide-mail-warning"] = "rbxassetid://10734885015",
	["lucide-mail-x"] = "rbxassetid://10734885247",
	["lucide-mails"] = "rbxassetid://10734885614",
	["lucide-map"] = "rbxassetid://10734886202",
	["lucide-map-pin"] = "rbxassetid://10734886004",
	["lucide-map-pin-off"] = "rbxassetid://10734885803",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-maximize-2"] = "rbxassetid://10734886496",
	["lucide-medal"] = "rbxassetid://10734887072",
	["lucide-megaphone"] = "rbxassetid://10734887454",
	["lucide-megaphone-off"] = "rbxassetid://10734887311",
	["lucide-meh"] = "rbxassetid://10734887603",
	["lucide-menu"] = "rbxassetid://10734887784",
	["lucide-message-circle"] = "rbxassetid://10734888000",
	["lucide-message-square"] = "rbxassetid://10734888228",
	["lucide-mic"] = "rbxassetid://10734888864",
	["lucide-mic-2"] = "rbxassetid://10734888430",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-microscope"] = "rbxassetid://10734889106",
	["lucide-microwave"] = "rbxassetid://10734895076",
	["lucide-milestone"] = "rbxassetid://10734895310",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minimize-2"] = "rbxassetid://10734895530",
	["lucide-minus"] = "rbxassetid://10734896206",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-minus-square"] = "rbxassetid://10734896029",
	["lucide-monitor"] = "rbxassetid://10734896881",
	["lucide-monitor-off"] = "rbxassetid://10734896360",
	["lucide-monitor-speaker"] = "rbxassetid://10734896512",
	["lucide-moon"] = "rbxassetid://10734897102",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mountain"] = "rbxassetid://10734897956",
	["lucide-mountain-snow"] = "rbxassetid://10734897665",
	["lucide-mouse"] = "rbxassetid://10734898592",
	["lucide-mouse-pointer"] = "rbxassetid://10734898476",
	["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
	["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
	["lucide-move"] = "rbxassetid://10734900011",
	["lucide-move-3d"] = "rbxassetid://10734898756",
	["lucide-move-diagonal"] = "rbxassetid://10734899164",
	["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
	["lucide-move-horizontal"] = "rbxassetid://10734899414",
	["lucide-move-vertical"] = "rbxassetid://10734899821",
	["lucide-music"] = "rbxassetid://10734905958",
	["lucide-music-2"] = "rbxassetid://10734900215",
	["lucide-music-3"] = "rbxassetid://10734905665",
	["lucide-music-4"] = "rbxassetid://10734905823",
	["lucide-navigation"] = "rbxassetid://10734906744",
	["lucide-navigation-2"] = "rbxassetid://10734906332",
	["lucide-navigation-2-off"] = "rbxassetid://10734906144",
	["lucide-navigation-off"] = "rbxassetid://10734906580",
	["lucide-network"] = "rbxassetid://10734906975",
	["lucide-newspaper"] = "rbxassetid://10734907168",
	["lucide-octagon"] = "rbxassetid://10734907361",
	["lucide-option"] = "rbxassetid://10734907649",
	["lucide-outdent"] = "rbxassetid://10734907933",
	["lucide-package"] = "rbxassetid://10734909540",
	["lucide-package-2"] = "rbxassetid://10734908151",
	["lucide-package-check"] = "rbxassetid://10734908384",
	["lucide-package-minus"] = "rbxassetid://10734908626",
	["lucide-package-open"] = "rbxassetid://10734908793",
	["lucide-package-plus"] = "rbxassetid://10734909016",
	["lucide-package-search"] = "rbxassetid://10734909196",
	["lucide-package-x"] = "rbxassetid://10734909375",
	["lucide-paint-bucket"] = "rbxassetid://10734909847",
	["lucide-paintbrush"] = "rbxassetid://10734910187",
	["lucide-paintbrush-2"] = "rbxassetid://10734910030",
	["lucide-palette"] = "rbxassetid://10734910430",
	["lucide-palmtree"] = "rbxassetid://10734910680",
	["lucide-paperclip"] = "rbxassetid://10734910927",
	["lucide-party-popper"] = "rbxassetid://10734918735",
	["lucide-pause"] = "rbxassetid://10734919336",
	["lucide-pause-circle"] = "rbxassetid://10735024209",
	["lucide-pause-octagon"] = "rbxassetid://10734919143",
	["lucide-pen-tool"] = "rbxassetid://10734919503",
	["lucide-pencil"] = "rbxassetid://10734919691",
	["lucide-percent"] = "rbxassetid://10734919919",
	["lucide-person-standing"] = "rbxassetid://10734920149",
	["lucide-phone"] = "rbxassetid://10734921524",
	["lucide-phone-call"] = "rbxassetid://10734920305",
	["lucide-phone-forwarded"] = "rbxassetid://10734920508",
	["lucide-phone-incoming"] = "rbxassetid://10734920694",
	["lucide-phone-missed"] = "rbxassetid://10734920845",
	["lucide-phone-off"] = "rbxassetid://10734921077",
	["lucide-phone-outgoing"] = "rbxassetid://10734921288",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-piggy-bank"] = "rbxassetid://10734921935",
	["lucide-pin"] = "rbxassetid://10734922324",
	["lucide-pin-off"] = "rbxassetid://10734922180",
	["lucide-pipette"] = "rbxassetid://10734922497",
	["lucide-pizza"] = "rbxassetid://10734922774",
	["lucide-plane"] = "rbxassetid://10734922971",
	["lucide-play"] = "rbxassetid://10734923549",
	["lucide-play-circle"] = "rbxassetid://10734923214",
	["lucide-plus"] = "rbxassetid://10734924532",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-plus-square"] = "rbxassetid://10734924219",
	["lucide-podcast"] = "rbxassetid://10734929553",
	["lucide-pointer"] = "rbxassetid://10734929723",
	["lucide-pound-sterling"] = "rbxassetid://10734929981",
	["lucide-power"] = "rbxassetid://10734930466",
	["lucide-power-off"] = "rbxassetid://10734930257",
	["lucide-printer"] = "rbxassetid://10734930632",
	["lucide-puzzle"] = "rbxassetid://10734930886",
	["lucide-quote"] = "rbxassetid://10734931234",
	["lucide-radio"] = "rbxassetid://10734931596",
	["lucide-radio-receiver"] = "rbxassetid://10734931402",
	["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
	["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
	["lucide-recycle"] = "rbxassetid://10734932295",
	["lucide-redo"] = "rbxassetid://10734932822",
	["lucide-redo-2"] = "rbxassetid://10734932586",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-refrigerator"] = "rbxassetid://10734933465",
	["lucide-regex"] = "rbxassetid://10734933655",
	["lucide-repeat"] = "rbxassetid://10734933966",
	["lucide-repeat-1"] = "rbxassetid://10734933826",
	["lucide-reply"] = "rbxassetid://10734934252",
	["lucide-reply-all"] = "rbxassetid://10734934132",
	["lucide-rewind"] = "rbxassetid://10734934347",
	["lucide-rocket"] = "rbxassetid://10734934585",
	["lucide-rocking-chair"] = "rbxassetid://10734939942",
	["lucide-rotate-3d"] = "rbxassetid://10734940107",
	["lucide-rotate-ccw"] = "rbxassetid://10734940376",
	["lucide-rotate-cw"] = "rbxassetid://10734940654",
	["lucide-rss"] = "rbxassetid://10734940825",
	["lucide-ruler"] = "rbxassetid://10734941018",
	["lucide-russian-ruble"] = "rbxassetid://10734941199",
	["lucide-sailboat"] = "rbxassetid://10734941354",
	["lucide-save"] = "rbxassetid://10734941499",
	["lucide-scale"] = "rbxassetid://10734941912",
	["lucide-scale-3d"] = "rbxassetid://10734941739",
	["lucide-scaling"] = "rbxassetid://10734942072",
	["lucide-scan"] = "rbxassetid://10734942565",
	["lucide-scan-face"] = "rbxassetid://10734942198",
	["lucide-scan-line"] = "rbxassetid://10734942351",
	["lucide-scissors"] = "rbxassetid://10734942778",
	["lucide-screen-share"] = "rbxassetid://10734943193",
	["lucide-screen-share-off"] = "rbxassetid://10734942967",
	["lucide-scroll"] = "rbxassetid://10734943448",
	["lucide-search"] = "rbxassetid://10734943674",
	["lucide-send"] = "rbxassetid://10734943902",
	["lucide-separator-horizontal"] = "rbxassetid://10734944115",
	["lucide-separator-vertical"] = "rbxassetid://10734944326",
	["lucide-server"] = "rbxassetid://10734949856",
	["lucide-server-cog"] = "rbxassetid://10734944444",
	["lucide-server-crash"] = "rbxassetid://10734944554",
	["lucide-server-off"] = "rbxassetid://10734944668",
	["lucide-settings"] = "rbxassetid://10734950309",
	["lucide-settings-2"] = "rbxassetid://10734950020",
	["lucide-share"] = "rbxassetid://10734950813",
	["lucide-share-2"] = "rbxassetid://10734950553",
	["lucide-sheet"] = "rbxassetid://10734951038",
	["lucide-shield"] = "rbxassetid://10734951847",
	["lucide-shield-alert"] = "rbxassetid://10734951173",
	["lucide-shield-check"] = "rbxassetid://10734951367",
	["lucide-shield-close"] = "rbxassetid://10734951535",
	["lucide-shield-off"] = "rbxassetid://10734951684",
	["lucide-shirt"] = "rbxassetid://10734952036",
	["lucide-shopping-bag"] = "rbxassetid://10734952273",
	["lucide-shopping-cart"] = "rbxassetid://10734952479",
	["lucide-shovel"] = "rbxassetid://10734952773",
	["lucide-shower-head"] = "rbxassetid://10734952942",
	["lucide-shrink"] = "rbxassetid://10734953073",
	["lucide-shrub"] = "rbxassetid://10734953241",
	["lucide-shuffle"] = "rbxassetid://10734953451",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-sidebar-close"] = "rbxassetid://10734953715",
	["lucide-sidebar-open"] = "rbxassetid://10734954000",
	["lucide-sigma"] = "rbxassetid://10734954538",
	["lucide-signal"] = "rbxassetid://10734961133",
	["lucide-signal-high"] = "rbxassetid://10734954807",
	["lucide-signal-low"] = "rbxassetid://10734955080",
	["lucide-signal-medium"] = "rbxassetid://10734955336",
	["lucide-signal-zero"] = "rbxassetid://10734960878",
	["lucide-siren"] = "rbxassetid://10734961284",
	["lucide-skip-back"] = "rbxassetid://10734961526",
	["lucide-skip-forward"] = "rbxassetid://10734961809",
	["lucide-skull"] = "rbxassetid://10734962068",
	["lucide-slack"] = "rbxassetid://10734962339",
	["lucide-slash"] = "rbxassetid://10734962600",
	["lucide-slice"] = "rbxassetid://10734963024",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
	["lucide-smartphone"] = "rbxassetid://10734963940",
	["lucide-smartphone-charging"] = "rbxassetid://10734963671",
	["lucide-smile"] = "rbxassetid://10734964441",
	["lucide-smile-plus"] = "rbxassetid://10734964188",
	["lucide-snowflake"] = "rbxassetid://10734964600",
	["lucide-sofa"] = "rbxassetid://10734964852",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-speaker"] = "rbxassetid://10734965419",
	["lucide-sprout"] = "rbxassetid://10734965572",
	["lucide-square"] = "rbxassetid://10734965702",
	["lucide-star"] = "rbxassetid://10734966248",
	["lucide-star-half"] = "rbxassetid://10734965897",
	["lucide-star-off"] = "rbxassetid://10734966097",
	["lucide-stethoscope"] = "rbxassetid://10734966384",
	["lucide-sticker"] = "rbxassetid://10734972234",
	["lucide-sticky-note"] = "rbxassetid://10734972463",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
	["lucide-stretch-vertical"] = "rbxassetid://10734973130",
	["lucide-strikethrough"] = "rbxassetid://10734973290",
	["lucide-subscript"] = "rbxassetid://10734973457",
	["lucide-sun"] = "rbxassetid://10734974297",
	["lucide-sun-dim"] = "rbxassetid://10734973645",
	["lucide-sun-medium"] = "rbxassetid://10734973778",
	["lucide-sun-moon"] = "rbxassetid://10734973999",
	["lucide-sun-snow"] = "rbxassetid://10734974130",
	["lucide-sunrise"] = "rbxassetid://10734974522",
	["lucide-sunset"] = "rbxassetid://10734974689",
	["lucide-superscript"] = "rbxassetid://10734974850",
	["lucide-swiss-franc"] = "rbxassetid://10734975024",
	["lucide-switch-camera"] = "rbxassetid://10734975214",
	["lucide-sword"] = "rbxassetid://10734975486",
	["lucide-swords"] = "rbxassetid://10734975692",
	["lucide-syringe"] = "rbxassetid://10734975932",
	["lucide-table"] = "rbxassetid://10734976230",
	["lucide-table-2"] = "rbxassetid://10734976097",
	["lucide-tablet"] = "rbxassetid://10734976394",
	["lucide-tag"] = "rbxassetid://10734976528",
	["lucide-tags"] = "rbxassetid://10734976739",
	["lucide-target"] = "rbxassetid://10734977012",
	["lucide-tent"] = "rbxassetid://10734981750",
	["lucide-terminal"] = "rbxassetid://10734982144",
	["lucide-terminal-square"] = "rbxassetid://10734981995",
	["lucide-text-cursor"] = "rbxassetid://10734982395",
	["lucide-text-cursor-input"] = "rbxassetid://10734982297",
	["lucide-thermometer"] = "rbxassetid://10734983134",
	["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
	["lucide-thermometer-sun"] = "rbxassetid://10734982771",
	["lucide-thumbs-down"] = "rbxassetid://10734983359",
	["lucide-thumbs-up"] = "rbxassetid://10734983629",
	["lucide-ticket"] = "rbxassetid://10734983868",
	["lucide-timer"] = "rbxassetid://10734984606",
	["lucide-timer-off"] = "rbxassetid://10734984138",
	["lucide-timer-reset"] = "rbxassetid://10734984355",
	["lucide-toggle-left"] = "rbxassetid://10734984834",
	["lucide-toggle-right"] = "rbxassetid://10734985040",
	["lucide-tornado"] = "rbxassetid://10734985247",
	["lucide-toy-brick"] = "rbxassetid://10747361919",
	["lucide-train"] = "rbxassetid://10747362105",
	["lucide-trash"] = "rbxassetid://10747362393",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-tree-deciduous"] = "rbxassetid://10747362534",
	["lucide-tree-pine"] = "rbxassetid://10747362748",
	["lucide-trees"] = "rbxassetid://10747363016",
	["lucide-trending-down"] = "rbxassetid://10747363205",
	["lucide-trending-up"] = "rbxassetid://10747363465",
	["lucide-triangle"] = "rbxassetid://10747363621",
	["lucide-trophy"] = "rbxassetid://10747363809",
	["lucide-truck"] = "rbxassetid://10747364031",
	["lucide-tv"] = "rbxassetid://10747364593",
	["lucide-tv-2"] = "rbxassetid://10747364302",
	["lucide-type"] = "rbxassetid://10747364761",
	["lucide-umbrella"] = "rbxassetid://10747364971",
	["lucide-underline"] = "rbxassetid://10747365191",
	["lucide-undo"] = "rbxassetid://10747365484",
	["lucide-undo-2"] = "rbxassetid://10747365359",
	["lucide-unlink"] = "rbxassetid://10747365771",
	["lucide-unlink-2"] = "rbxassetid://10747397871",
	["lucide-unlock"] = "rbxassetid://10747366027",
	["lucide-upload"] = "rbxassetid://10747366434",
	["lucide-upload-cloud"] = "rbxassetid://10747366266",
	["lucide-usb"] = "rbxassetid://10747366606",
	["lucide-user"] = "rbxassetid://10747373176",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-users"] = "rbxassetid://10747373426",
	["lucide-utensils"] = "rbxassetid://10747373821",
	["lucide-utensils-crossed"] = "rbxassetid://10747373629",
	["lucide-venetian-mask"] = "rbxassetid://10747374003",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-vibrate"] = "rbxassetid://10747374489",
	["lucide-vibrate-off"] = "rbxassetid://10747374269",
	["lucide-video"] = "rbxassetid://10747374938",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-view"] = "rbxassetid://10747375132",
	["lucide-voicemail"] = "rbxassetid://10747375281",
	["lucide-volume"] = "rbxassetid://10747376008",
	["lucide-volume-1"] = "rbxassetid://10747375450",
	["lucide-volume-2"] = "rbxassetid://10747375679",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wallet"] = "rbxassetid://10747376205",
	["lucide-wand"] = "rbxassetid://10747376565",
	["lucide-wand-2"] = "rbxassetid://10747376349",
	["lucide-watch"] = "rbxassetid://10747376722",
	["lucide-waves"] = "rbxassetid://10747376931",
	["lucide-webcam"] = "rbxassetid://10747381992",
	["lucide-wifi"] = "rbxassetid://10747382504",
	["lucide-wifi-off"] = "rbxassetid://10747382268",
	["lucide-wind"] = "rbxassetid://10747382750",
	["lucide-wrap-text"] = "rbxassetid://10747383065",
	["lucide-wrench"] = "rbxassetid://10747383470",
	["lucide-x"] = "rbxassetid://10747384394",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-x-octagon"] = "rbxassetid://10747384037",
	["lucide-x-square"] = "rbxassetid://10747384217",
	["lucide-zoom-in"] = "rbxassetid://10747384552",
	["lucide-zoom-out"] = "rbxassetid://10747384679",
};

GumballZ.WindowFlags = {};

function GumballZ:IsMobile() : boolean
	return UserInputService.TouchEnabled;	
end;

function GumballZ:RandomString() : string
	return string.char(math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102));	
end;

function GumballZ:GetTextSize(Text : TextLabel,CustomFont: Enum.Font) : Vector2
	return TextService:GetTextSize(Text.Text,Text.TextSize,(Text.Font ~= Enum.Font.Unknown and Text.Font) or (CustomFont or Enum.Font.GothamMedium),Vector2.new(math.huge,math.huge));
end;

function GumballZ:IsMouseOverFrame(Frame : Frame) : boolean
	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function GumballZ:GetCalculatePosition(planePos: number, planeNormal: Vector3, rayOrigin: number, rayDirection: Vector3) : number
	local n: Vector3 = planeNormal;
	local d: Vector3 = rayDirection;
	local v: Vector3 = rayOrigin - planePos;

	local num: number = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den: number = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a: number = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function GumballZ:CreateHover(Element : Frame,Callback : (boolean) -> any)
	Element.MouseEnter:Connect(function()
		Callback(true);
	end);

	Element.MouseLeave:Connect(function()
		Callback(false);
	end);
end;

function GumballZ:GetIcon(name : string) : string
	return GumballZ.Lucide['lucide-'..tostring(name)] or GumballZ.Lucide[name] or GumballZ.Lucide[tostring(name)] or "";
end;

function GumballZ:SetIcon(name : string, value : string)
	GumballZ.Lucide[name] = value;
end;

function GumballZ:Rounding(num: number, numDecimalPlaces: number) : number
	local mult: number = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;

function GumballZ:CreateAnimation(Instance: Instance , Time: number , Style : Enum.EasingStyle , Property : {[string] : any}) : Tween
	if not Property then
		if typeof(Style) == 'table' then
			Property = Style;
			Style = nil;
		end;
	end;

	local Tween: Tween = TweenService:Create(Instance,TweenInfo.new(Time or 1 , Style or Enum.EasingStyle.Quint),Property);

	Tween:Play();

	return Tween;
end;

function GumballZ:NewInput(Frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;

	if Callback then
		Button.MouseButton1Click:Connect(Callback);
	end;

	return Button;
end;

function GumballZ:Drag(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;

	local function updateInput(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		GumballZ:CreateAnimation(MoveFrame,Speed,nil,{
			Position = position
		});
	end;

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #GumballZ.DragBlacklist <= 0 then 
			dragToggle = true
			dragStart = input.Position
			startPos = MoveFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch and #GumballZ.DragBlacklist <= 0 then
			if dragToggle then
				updateInput(input)
			end
		else
			if #GumballZ.DragBlacklist > 0 then
				dragToggle = false
			end
		end
	end);
end;

function GumballZ:ScrollSignal(Scroll: ScrollingFrame,UIListLayout: UIListLayout,Type:string)
	if Type == 'X' then
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X,0)
		end)
	else
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
		end)
	end;
end;

function GumballZ:CreateResponse(args: {[string] : (any) -> any})
	local main = {};

	for i,v in next , args do
		if typeof(v) == 'function' then
			main[i] = function(self , ...)
				return v(...);
			end;
		else
			main[i] = v;
		end;
	end;

	return main;
end;

function GumballZ:GetWindowFromElement(Element: GuiObject)
	for i,v in next , GumballZ.Windows do
		if Element:IsDescendantOf(v) then
			return v;
		end;
	end;
end;

function GumballZ:CreateOption(OptionButton: ImageButton): Elements
	GumballZ:CreateHover(OptionButton,function(bool)
		if bool then
			GumballZ:CreateAnimation(OptionButton,0.5,{
				ImageTransparency = 0.3
			})
		else
			GumballZ:CreateAnimation(OptionButton,0.5,{
				ImageTransparency = 0.600
			})
		end;
	end);

	local Bindable = Instance.new('BindableEvent');
	local OwnWindow = GumballZ:GetWindowFromElement(OptionButton);
	local ExtElementFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SpaceBox = Instance.new("Frame")

	GumballZ:ScrollSignal(ScrollingFrame,UIListLayout,'Y');

	ExtElementFrame.Active = true;
	ExtElementFrame.Name = GumballZ:RandomString()
	ExtElementFrame.Parent = OwnWindow
	ExtElementFrame.AnchorPoint = Vector2.new(0.5, 0)
	ExtElementFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ExtElementFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExtElementFrame.BorderSizePixel = 0
	ExtElementFrame.ClipsDescendants = true
	ExtElementFrame.Position = UDim2.new(2, 0, 2, 0)
	ExtElementFrame.Size = UDim2.new(0, 200, 0, 0)
	ExtElementFrame.ZIndex = 100

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ExtElementFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ExtElementFrame

	DropShadow.Name = GumballZ:RandomString()
	DropShadow.Parent = ExtElementFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = ExtElementFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = false
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, 0, 1, -5)
	ScrollingFrame.ZIndex = 109
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	SpaceBox.Name = GumballZ:RandomString()
	SpaceBox.Parent = ScrollingFrame
	SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpaceBox.BorderSizePixel = 0
	SpaceBox.Size = UDim2.new(0, 0, 0, 3)

	local SPAWN_THREAD;

	local ToggleExt = function(bool)
		if bool then
			Bindable:SetAttribute('V',true);
			Bindable:Fire(true);

			local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,200)

			ExtElementFrame.Position = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2))

			GumballZ:CreateAnimation(ExtElementFrame,0.45,{
				Size = UDim2.new(0, 200, 0, size)
			})

			GumballZ:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 0.750
			})

			GumballZ:CreateAnimation(UIStroke,0.45,{
				Transparency = 0
			})

			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait(0.1)
					local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,200)
					local ud = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2));

					GumballZ:CreateAnimation(ExtElementFrame,0.35,{
						Position = ud
					});
				end;
			end)
		else
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			Bindable:SetAttribute('V',false);
			Bindable:Fire(false);

			GumballZ:CreateAnimation(ExtElementFrame,0.45,{
				Size = UDim2.new(0, 200, 0, 0)
			})

			GumballZ:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(UIStroke,0.45,{
				Transparency = 1
			})
		end;
	end;

	Bindable:SetAttribute('V',false);

	ToggleExt(false);

	OptionButton.MouseButton1Click:Connect(function()
		ToggleExt(true);
	end);

	UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not GumballZ:IsMouseOverFrame(ExtElementFrame) and not GumballZ.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER then
				ToggleExt(false);
			end;
		end;
	end);

	local UIElements: Elements = GumballZ:CreateElements(ScrollingFrame,ScrollingFrame.ZIndex,Bindable);

	return UIElements;
end;

function GumballZ:CreateColorPicker(ColorBox: Frame,Transparency, Callback)
	Transparency = Transparency or 0;
	Callback = Callback or function() end;

	local OwnWindow = GumballZ:GetWindowFromElement(ColorBox);
	local ColorPickerFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ColorPickBox = Instance.new("ImageLabel")
	local MouseMovement = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorRedGreenBlue = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local ColorRGBSlide = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local ColorOpc = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local ColorOptSlide = Instance.new("Frame")
	local UIStroke_4 = Instance.new("UIStroke")
	local UIGradient_2 = Instance.new("UIGradient")
	local UIStroke_5 = Instance.new("UIStroke")
	local ColorOpt = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local PasteButton = Instance.new("ImageButton")
	local CopyButton = Instance.new("ImageButton")
	local hexCode = Instance.new("Frame")
	local UICorner_6 = Instance.new("UICorner")
	local HexCodeText = Instance.new("TextLabel")

	local OldCode = 0;
	local CodeH,CodeV = 1, 1;
	local IsPressM1 = false;
	local UI_SPAWN_THREAD;

	local updateColor = function()
		local H , S , V = ColorBox.BackgroundColor3:ToHSV();

		OldCode = H;
		CodeH = S;
		CodeV = V;
	end;

	local VisibleToggle = function(value)
		if value then
			ColorPickBox.BackgroundColor3 = Color3.fromHSV(OldCode,1,1);
			ColorOpc.BackgroundColor3 = ColorBox.BackgroundColor3;

			HexCodeText.Text = "#" .. tostring(ColorPickBox.BackgroundColor3:ToHex())

			ColorPickerFrame.Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);

			updateColor();

			if UI_SPAWN_THREAD then
				task.cancel(UI_SPAWN_THREAD);
				UI_SPAWN_THREAD = nil;
			end;

			UI_SPAWN_THREAD = task.spawn(function()
				while true do task.wait()
					GumballZ:CreateAnimation(ColorPickerFrame,0.35,{
						Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);
					});
				end;
			end);

			GumballZ:CreateAnimation(ColorRGBSlide,0.35,{
				Position = UDim2.new(0.5, 0, OldCode, 0)
			});

			GumballZ:CreateAnimation(MouseMovement,0.35,{
				Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
			})

			GumballZ:CreateAnimation(ColorOptSlide,0.35,{
				Position = UDim2.new(1- Transparency, 0, 0.5, 0)
			})

			GumballZ:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 195),
			});

			GumballZ:CreateAnimation(UIStroke,0.45,{
				Transparency = 0
			});

			GumballZ:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 0.75
			});

			GumballZ:CreateAnimation(ColorPickBox,0.45,{
				ImageTransparency = 0,
				BackgroundTransparency = 0
			});

			GumballZ:CreateAnimation(MouseMovement,0.45,{
				ImageTransparency = 0,
			});

			GumballZ:CreateAnimation(UIStroke_2,0.45,{
				Transparency = 0
			});

			GumballZ:CreateAnimation(ColorRedGreenBlue,0.45,{
				BackgroundTransparency = 0
			});

			GumballZ:CreateAnimation(ColorRGBSlide,0.45,{
				BackgroundTransparency = 0
			});

			GumballZ:CreateAnimation(UIStroke_3,0.45,{
				Transparency = 0.75
			});

			GumballZ:CreateAnimation(ColorOpc,0.45,{
				BackgroundTransparency = 0
			});

			GumballZ:CreateAnimation(ColorOptSlide,0.45,{
				BackgroundTransparency = 0
			});

			GumballZ:CreateAnimation(UIStroke_4,0.45,{
				Transparency = 0.75
			});

			GumballZ:CreateAnimation(UIStroke_5,0.45,{
				Transparency = 0
			});

			GumballZ:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.45
			});

			GumballZ:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.45
			});

			GumballZ:CreateAnimation(hexCode,0.45,{
				BackgroundTransparency = 0.4
			});

			GumballZ:CreateAnimation(HexCodeText,0.45,{
				TextTransparency = 0.45
			});
		else
			if UI_SPAWN_THREAD then
				task.cancel(UI_SPAWN_THREAD);
				UI_SPAWN_THREAD = nil;
			end;

			GumballZ:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 0)
			});

			GumballZ:CreateAnimation(UIStroke,0.45,{
				Transparency = 1
			});

			GumballZ:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 1
			});

			GumballZ:CreateAnimation(ColorPickBox,0.45,{
				ImageTransparency = 1,
				BackgroundTransparency = 1
			});

			GumballZ:CreateAnimation(MouseMovement,0.45,{
				ImageTransparency = 1,
			});

			GumballZ:CreateAnimation(UIStroke_2,0.45,{
				Transparency = 1
			});

			GumballZ:CreateAnimation(ColorRedGreenBlue,0.45,{
				BackgroundTransparency = 1
			});

			GumballZ:CreateAnimation(ColorRGBSlide,0.45,{
				BackgroundTransparency = 1
			});

			GumballZ:CreateAnimation(UIStroke_3,0.45,{
				Transparency = 1
			});

			GumballZ:CreateAnimation(ColorOpc,0.45,{
				BackgroundTransparency = 1
			});

			GumballZ:CreateAnimation(ColorOptSlide,0.45,{
				BackgroundTransparency = 1
			});

			GumballZ:CreateAnimation(UIStroke_4,0.45,{
				Transparency = 1
			});

			GumballZ:CreateAnimation(UIStroke_5,0.45,{
				Transparency = 1
			});

			GumballZ:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 1
			});

			GumballZ:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 1
			});

			GumballZ:CreateAnimation(hexCode,0.45,{
				BackgroundTransparency = 1
			});

			GumballZ:CreateAnimation(HexCodeText,0.45,{
				TextTransparency = 1
			});
		end;
	end;

	ColorPickerFrame.Active = true;
	ColorPickerFrame.Name = GumballZ:RandomString()
	ColorPickerFrame.Parent = OwnWindow
	ColorPickerFrame.AnchorPoint = Vector2.new(0.5, 0)
	ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	ColorPickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerFrame.BorderSizePixel = 0
	ColorPickerFrame.ClipsDescendants = true
	ColorPickerFrame.Position = UDim2.new(4,0,4,0)
	ColorPickerFrame.Size = UDim2.new(0, 175, 0, 195)
	ColorPickerFrame.ZIndex = 200
	GumballZ:AddDragBlacklist(ColorPickerFrame);

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ColorPickerFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ColorPickerFrame

	DropShadow.Name = GumballZ:RandomString()
	DropShadow.Parent = ColorPickerFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 199
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ColorPickBox.Name = GumballZ:RandomString()
	ColorPickBox.Parent = ColorPickerFrame
	ColorPickBox.BackgroundColor3 = Color3.fromRGB(39, 255, 35)
	ColorPickBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickBox.BorderSizePixel = 0
	ColorPickBox.Position = UDim2.new(0, 7, 0, 7)
	ColorPickBox.Size = UDim2.new(0, 135, 0, 135)
	ColorPickBox.ZIndex = 201
	ColorPickBox.Image = "http://www.roblox.com/asset/?id=112554223509763"

	MouseMovement.Name = GumballZ:RandomString()
	MouseMovement.Parent = ColorPickBox
	MouseMovement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MouseMovement.BackgroundTransparency = 1.000
	MouseMovement.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MouseMovement.BorderSizePixel = 0
	MouseMovement.Position = UDim2.new(0.822222233, 0, 0.0592592582, 0)
	MouseMovement.Size = UDim2.new(0, 12, 0, 12)
	MouseMovement.ZIndex = 205
	MouseMovement.Image = "rbxassetid://4805639000"
	MouseMovement.AnchorPoint = Vector2.new(0.5,0.5)

	UICorner_2.CornerRadius = UDim.new(0, 2)
	UICorner_2.Parent = ColorPickBox

	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_2.Parent = ColorPickBox

	ColorRedGreenBlue.Name = GumballZ:RandomString()
	ColorRedGreenBlue.Parent = ColorPickerFrame
	ColorRedGreenBlue.AnchorPoint = Vector2.new(1, 0)
	ColorRedGreenBlue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRedGreenBlue.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRedGreenBlue.BorderSizePixel = 0
	ColorRedGreenBlue.Position = UDim2.new(1, -7, 0, 7)
	ColorRedGreenBlue.Size = UDim2.new(0, 20, 0, 135)
	ColorRedGreenBlue.ZIndex = 206

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Rotation = 90
	UIGradient.Parent = ColorRedGreenBlue

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = ColorRedGreenBlue

	ColorRGBSlide.Name = GumballZ:RandomString()
	ColorRGBSlide.Parent = ColorRedGreenBlue
	ColorRGBSlide.AnchorPoint = Vector2.new(0.5, 0)
	ColorRGBSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRGBSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRGBSlide.BorderSizePixel = 0
	ColorRGBSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorRGBSlide.Size = UDim2.new(1, 5, 0, 2)
	ColorRGBSlide.ZIndex = 207

	UIStroke_3.Transparency = 0.750
	UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_3.Parent = ColorRGBSlide

	ColorOpc.Name = GumballZ:RandomString()
	ColorOpc.Parent = ColorPickerFrame
	ColorOpc.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpc.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpc.BorderSizePixel = 0
	ColorOpc.Position = UDim2.new(0.5, 0, 0, 149)
	ColorOpc.Size = UDim2.new(1, -15, 0, 12)
	ColorOpc.ZIndex = 206

	UICorner_4.CornerRadius = UDim.new(0, 2)
	UICorner_4.Parent = ColorOpc

	ColorOptSlide.Name = GumballZ:RandomString()
	ColorOptSlide.Parent = ColorOpc
	ColorOptSlide.AnchorPoint = Vector2.new(0, 0.5)
	ColorOptSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorOptSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOptSlide.BorderSizePixel = 0
	ColorOptSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorOptSlide.Size = UDim2.new(0, 2, 1, 5)
	ColorOptSlide.ZIndex = 207

	UIStroke_4.Transparency = 0.750
	UIStroke_4.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_4.Parent = ColorOptSlide

	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient_2.Parent = ColorOpc

	UIStroke_5.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_5.Parent = ColorOpc

	ColorOpt.Name = GumballZ:RandomString()
	ColorOpt.Parent = ColorPickerFrame
	ColorOpt.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpt.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpt.BackgroundTransparency = 1.000
	ColorOpt.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpt.BorderSizePixel = 0
	ColorOpt.Position = UDim2.new(0.5, 0, 0, 169)
	ColorOpt.Size = UDim2.new(1, -15, 0, 18)
	ColorOpt.ZIndex = 206

	UICorner_5.CornerRadius = UDim.new(0, 2)
	UICorner_5.Parent = ColorOpt

	PasteButton.Name = GumballZ:RandomString()
	PasteButton.Parent = ColorOpt
	PasteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PasteButton.BackgroundTransparency = 1.000
	PasteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PasteButton.BorderSizePixel = 0
	PasteButton.Size = UDim2.new(1, 0, 1, 0)
	PasteButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	PasteButton.ZIndex = 209
	PasteButton.Image = "rbxassetid://10709799288"
	PasteButton.ImageTransparency = 0.450

	CopyButton.Name = GumballZ:RandomString()
	CopyButton.Parent = ColorOpt
	CopyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CopyButton.BackgroundTransparency = 1.000
	CopyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CopyButton.BorderSizePixel = 0
	CopyButton.Position = UDim2.new(0, 20, 0, 0)
	CopyButton.Size = UDim2.new(1, 0, 1, 0)
	CopyButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	CopyButton.ZIndex = 209
	CopyButton.Image = "rbxassetid://10709798682"
	CopyButton.ImageTransparency = 0.450

	hexCode.Name = GumballZ:RandomString()
	hexCode.Parent = ColorOpt
	hexCode.BackgroundColor3 = GumballZ.Colors.Black
	hexCode.BackgroundTransparency = 0.400
	hexCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
	hexCode.BorderSizePixel = 0
	hexCode.Position = UDim2.new(0, 43, 0, 0)
	hexCode.Size = UDim2.new(1, -43, 1, 0)
	hexCode.ZIndex = 209

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = hexCode

	HexCodeText.Name = GumballZ:RandomString()
	HexCodeText.Parent = hexCode
	HexCodeText.AnchorPoint = Vector2.new(0, 0.5)
	HexCodeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HexCodeText.BackgroundTransparency = 1.000
	HexCodeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HexCodeText.BorderSizePixel = 0
	HexCodeText.Position = UDim2.new(0, 3, 0.5, 0)
	HexCodeText.Size = UDim2.new(1, 0, 0.800000012, 0)
	HexCodeText.ZIndex = 209
	HexCodeText.FontFace = GumballZ.FontSemiBold
	HexCodeText.Text = "#fff"
	HexCodeText.TextColor3 = Color3.fromRGB(255, 255, 255)
	HexCodeText.TextSize = 13.000
	HexCodeText.TextTransparency = 0.450
	HexCodeText.TextXAlignment = Enum.TextXAlignment.Left;

	GumballZ:CreateHover(CopyButton,function(bool)
		if bool then
			GumballZ:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.1
			})
		else
			GumballZ:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.45
			})
		end
	end)	

	GumballZ:CreateHover(PasteButton,function(bool)
		if bool then
			GumballZ:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.1
			})
		else
			GumballZ:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.45
			})
		end
	end)

	PasteButton.MouseButton1Click:Connect(function()
		if GumballZ.GLOBAL_ENVIRONMENT.COLOR_COPY then
			local h,s,v = GumballZ.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHSV();

			Transparency = GumballZ.GLOBAL_ENVIRONMENT.COLOR_COPY.OPC;

			OldCode = h;
			CodeH = s;
			CodeV = v;

			HexCodeText.Text = "#" .. tostring(GumballZ.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHex());

			GumballZ:CreateAnimation(ColorRGBSlide,0.35,{
				Position = UDim2.new(0.5, 0, OldCode, 0)
			});

			GumballZ:CreateAnimation(MouseMovement,0.35,{
				Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
			})

			GumballZ:CreateAnimation(ColorOptSlide,0.35,{
				Position = UDim2.new(1- Transparency, 0, 0.5, 0)
			})

			GumballZ:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 195),
			});

			ColorPickBox.BackgroundColor3 = Color3.fromHSV(h,1,1);

			ColorOpc.BackgroundColor3 = GumballZ.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB;

			Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency);
		end;
	end);

	CopyButton.MouseButton1Click:Connect(function()
		GumballZ.GLOBAL_ENVIRONMENT.COLOR_COPY = {
			RGB = Color3.fromHSV(OldCode,CodeH,CodeV),
			OPC = Transparency,
		};
	end)

	VisibleToggle(false);

	GumballZ:NewInput(ColorBox,function()
		VisibleToggle(true);
	end);

	do
		local SPAWN_THREAD;
		ColorPickerFrame.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				GumballZ.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = true;

				if SPAWN_THREAD then
					task.cancel(SPAWN_THREAD);
					SPAWN_THREAD = nil;
				end;

				SPAWN_THREAD = task.spawn(function()
					while IsPressM1 do task.wait(0)
						Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency);
					end;
				end);
			end;
		end)

		ColorPickerFrame.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = false;
				GumballZ.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = false;

				if SPAWN_THREAD then
					task.cancel(SPAWN_THREAD);
					SPAWN_THREAD = nil;
				end;
			end;
		end)

		UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not GumballZ:IsMouseOverFrame(ColorPickerFrame) then
					VisibleToggle(false);
				end;
			end;
		end)

		ColorRedGreenBlue.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local ColorY = ColorRedGreenBlue.AbsolutePosition.Y
					local ColorYM = ColorY + ColorRedGreenBlue.AbsoluteSize.Y;
					local Value = math.clamp(Mouse.Y, ColorY, ColorYM)
					local Code = ((Value - ColorY) / (ColorYM - ColorY));

					local Color = Color3.fromHSV(Code, CodeH, CodeV);

					GumballZ:CreateAnimation(ColorRGBSlide,0.35,{
						Position = UDim2.new(0.5, 0, Code, 0)
					});

					GumballZ:CreateAnimation(ColorBox,0.5,{
						BackgroundColor3 = Color
					});

					GumballZ:CreateAnimation(ColorOpc,0.35,{
						BackgroundColor3 = Color
					});

					GumballZ:CreateAnimation(ColorPickBox,0.5,{
						BackgroundColor3 = Color3.fromHSV(Code, 1, 1)
					});

					HexCodeText.Text = "#" .. tostring(Color:ToHex())

					OldCode = Code;
				end;
			end;
		end);

		ColorOpc.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local transparency = math.clamp((((Mouse.X) - ColorOpc.AbsolutePosition.X) / ColorOpc.AbsoluteSize.X), 0, 1);

					GumballZ:CreateAnimation(ColorOptSlide,0.35,{
						Position = UDim2.new(transparency, 0, 0.5, 0)
					});

					HexCodeText.Text = "#" .. tostring(ColorBox.BackgroundColor3:ToHex())

					Transparency = (1 - transparency);
				end;
			end;
		end);

		ColorPickBox.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait();
					local PosX = ColorPickBox.AbsolutePosition.X
					local ScaleX = PosX + ColorPickBox.AbsoluteSize.X
					local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), ColorPickBox.AbsolutePosition.Y
					local ScaleY = PosY + ColorPickBox.AbsoluteSize.Y
					local Vals = math.clamp(Mouse.Y, PosY, ScaleY)

					CodeH = (Value - PosX) / (ScaleX - PosX);
					CodeV = (1 - ((Vals - PosY) / (ScaleY - PosY)));

					GumballZ:CreateAnimation(ColorBox,0.5,{
						BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV)
					});

					GumballZ:CreateAnimation(ColorOpc,0.35,{
						BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV)
					});

					HexCodeText.Text = "#" .. tostring(Color3.fromHSV(OldCode, CodeH, CodeV):ToHex())

					GumballZ:CreateAnimation(MouseMovement,0.2,nil,{
						Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
					})
				end
			end
		end)
	end;

	return {
		set_opc = function(v)
			Transparency = v;
		end,
	}
end;

function GumballZ:RandomStr(len: number): string
	local main = "";

	for i = 1 , len do
		local max = #GumballZ.Ascii;
		local rand = math.random(1,max);

		main = main .. GumballZ.Ascii:sub(rand,rand);
	end;

	return main;
end;

function GumballZ:AddDragBlacklist(Frame: Frame)
	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseMovement then
			local finder = table.find(GumballZ.DragBlacklist , Frame);

			if not finder then
				table.insert(GumballZ.DragBlacklist , Frame);
			end;
		end;
	end);

	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseMovement then
			local finder = table.find(GumballZ.DragBlacklist , Frame);

			if finder then
				table.remove(GumballZ.DragBlacklist , finder);
			end;
		end;
	end);
end;

function GumballZ:ProtectText(Label: TextLabel,Text: string)
	Label.RichText = true;

	local MainText = string.gsub(Text,'.',function(t)
		if not string.find(t,"[<>()\"']") then
			return string.format('<font %s="%s">%s</font>',GumballZ:RandomStr(5),GumballZ:RandomStr(5),t)
		end;
		return t;
	end);

	Label.Text = MainText;
end;

function GumballZ:CreateDropdown(Parent: Frame, Default: string | {[string]: boolean}, Multiplier: boolean, AutoUpdate: boolean,Callback: (data: any) -> any)
	local Window = GumballZ:GetWindowFromElement(Parent);
	local Data = {};
	local Selected = (Multiplier and {}) or nil;

	local DropdownItemFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SPAWN_THREAD;

	GumballZ:AddDragBlacklist(DropdownItemFrame);

	local Toggle = function(value)
		if value then
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait()
					local baseSize = UIListLayout.AbsoluteContentSize.Y + 10;

					DropdownItemFrame.Position = UDim2.fromOffset(Parent.AbsolutePosition.X,Parent.AbsolutePosition.Y + (Parent.AbsoluteSize.Y * 5))

					GumballZ:CreateAnimation(DropdownItemFrame,0.35,{
						Size = UDim2.new(0, 175, 0, math.clamp(baseSize,0,200))
					})
				end;
			end)

			GumballZ:CreateAnimation(UIStroke,0.35,{
				Transparency = 0
			})

			GumballZ:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 0.75
			})
		else
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			GumballZ:CreateAnimation(DropdownItemFrame,0.35,{
				Size = UDim2.new(0, 175, 0, 0)
			})

			GumballZ:CreateAnimation(UIStroke,0.35,{
				Transparency = 1
			})

			GumballZ:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 1
			})
		end;
	end;

	Toggle(false);

	DropdownItemFrame.Name = GumballZ:RandomString()
	DropdownItemFrame.Parent = Window
	DropdownItemFrame.AnchorPoint = Vector2.new(0, 0)
	DropdownItemFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	DropdownItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownItemFrame.BorderSizePixel = 0
	DropdownItemFrame.ClipsDescendants = true
	DropdownItemFrame.Position = UDim2.new(4,0,4,0)
	DropdownItemFrame.Size = UDim2.new(0, 175, 0, 100)
	DropdownItemFrame.ZIndex = 100

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = DropdownItemFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = DropdownItemFrame

	DropShadow.Name = GumballZ:RandomString()
	DropShadow.Parent = DropdownItemFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = DropdownItemFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = false
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
	ScrollingFrame.ZIndex = 109
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 4)
	end)

	local new_button = function()
		local db_selected = Instance.new("TextButton")

		db_selected.Name = GumballZ:RandomString()
		db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		db_selected.BackgroundTransparency = 1.000
		db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
		db_selected.BorderSizePixel = 0
		db_selected.Size = UDim2.new(1, 0, 0, 10)
		db_selected.ZIndex = 110
		db_selected.FontFace = GumballZ.FontSemiBold
		db_selected.TextColor3 = GumballZ.Colors.Main
		db_selected.TextSize = 12.000
		db_selected.TextXAlignment = Enum.TextXAlignment.Left

		return db_selected;
	end;

	local func;
	local res = GumballZ:CreateResponse({
		set_data = function(v)
			Data = v;
		end,
		on_toggle = function(cb)
			func = cb;
		end,
		change_default = function(v)
			Default = v;
		end,
		refresh = function()
			for i,v in next , ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					v:Destroy();
				end;
			end;

			local selectedmem;

			for i,v in next , Data do
				local bth = new_button();

				bth.Text = tostring(v);

				bth.Parent = ScrollingFrame;

				if Multiplier then
					if (typeof(Default) == 'table' and (Default[v] or table.find(Default,v))) or Default == v then
						Selected[v] = true
						bth.TextColor3 = GumballZ.Colors.Main;
					else
						bth.TextColor3 = Color3.fromRGB(255, 255, 255);
						Selected[v] = false
					end

					bth.MouseButton1Click:Connect(function()
						Selected[v] = not Selected[v];

						if Selected[v] then
							bth.TextColor3 = GumballZ.Colors.Main;
						else
							bth.TextColor3 = Color3.fromRGB(255, 255, 255);
						end;

						Callback(Selected);
					end)
				else
					if v == Default then
						selectedmem = bth;
						Selected = v;

						bth.TextColor3 = GumballZ.Colors.Main;
					else
						bth.TextColor3 = Color3.fromRGB(255, 255, 255);
					end;

					bth.MouseButton1Click:Connect(function()
						if selectedmem then
							selectedmem.TextColor3 = Color3.fromRGB(255, 255, 255);
						end;

						bth.TextColor3 = GumballZ.Colors.Main;
						selectedmem = bth;
						Selected = v;

						Callback(v);
					end)
				end;
			end;

			Callback(Selected);
		end,
	});

	GumballZ:NewInput(Parent,function()
		if AutoUpdate then
			res:refresh();
		end;

		func(true);
		Toggle(true);
	end);

	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			if not GumballZ:IsMouseOverFrame(DropdownItemFrame) then
				func(false);
				Toggle(false);
			end;
		end;
	end);

	return res;
end;

function GumballZ:CreateElements(Parent : Frame , ZIndex : number , Event : BindableEvent,SearchAPI: {Path: string,Memory : (name:string) -> any}) : Elements
	local elements = {};
	local GumballZWindow = GumballZ:GetWindowFromElement(Parent);

	function elements:AddDivider(Config)
		Config = Config or {}
		if type(Config) == "string" then
			Config = {Text = Config}
		end

		if Config.Text then
			local Container = Instance.new("Frame")
			local Line = Instance.new("Frame")
			local Label = Instance.new("TextLabel")

			Container.Name = GumballZ:RandomString()
			Container.Parent = Parent
			Container.BackgroundTransparency = 1
			Container.Size = UDim2.new(1, -25, 0, 20)
			Container.ZIndex = ZIndex + 1
			GumballZ:AddDragBlacklist(Container)

			Line.Name = GumballZ:RandomString()
			Line.Parent = Container
			Line.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Line.BorderSizePixel = 0
			Line.Size = UDim2.new(1, 0, 0, 1)
			Line.Position = UDim2.new(0, 0, 0.5, 0)
			Line.ZIndex = ZIndex + 1

			Label.Name = GumballZ:RandomString()
			Label.Parent = Container
			Label.Text = Config.Text
			Label.FontFace = GumballZ.FontSemiBold
			Label.TextSize = 12
			Label.TextColor3 = Color3.fromRGB(200, 200, 200)
			Label.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- Match typical section bg
			Label.BorderSizePixel = 0
			Label.AnchorPoint = Vector2.new(0.5, 0.5)
			Label.Position = UDim2.new(0.5, 0, 0.5, 0)
			Label.ZIndex = ZIndex + 2
			
			local TextSize = game:GetService("TextService"):GetTextSize(Label.Text, Label.TextSize, Enum.Font.GothamSemibold, Vector2.new(1000, 100))
			Label.Size = UDim2.new(0, TextSize.X + 8, 1, 0)
		else
			local Divider = Instance.new("Frame")
			
			Divider.Name = GumballZ:RandomString()
			Divider.Parent = Parent
			Divider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Divider.BorderSizePixel = 0
			Divider.Size = UDim2.new(1, -25, 0, 1)
			Divider.ZIndex = ZIndex + 1
			GumballZ:AddDragBlacklist(Divider);
		end
	end;

	function elements:AddParagraph(Config)
		Config = Config or {}
		Config.Title = Config.Title or "Title"
		Config.Content = Config.Content or "Content"

		local Paragraph = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")

		Paragraph.Name = GumballZ:RandomString()
		Paragraph.Parent = Parent
		Paragraph.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
		Paragraph.BackgroundTransparency = 0
		Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Paragraph.BorderSizePixel = 0
		Paragraph.Size = UDim2.new(1, -25, 0, 0) -- Height calculated below
		Paragraph.ZIndex = ZIndex + 1
		GumballZ:AddDragBlacklist(Paragraph)
        
        UICorner.CornerRadius = UDim.new(0, 2)
        UICorner.Parent = Paragraph

        UIStroke.Color = Color3.fromRGB(29, 29, 29)
        UIStroke.Parent = Paragraph

		Title.Name = GumballZ:RandomString()
		Title.Parent = Paragraph
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0, 10, 0, 5)
		Title.Size = UDim2.new(1, -20, 0, 15)
		Title.ZIndex = ZIndex + 2
		Title.FontFace = GumballZ.FontSemiBold
		Title.Text = Config.Title
		Title.TextColor3 = GumballZ.Colors.Main
		Title.TextSize = 13.000
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Content.Name = GumballZ:RandomString()
		Content.Parent = Paragraph
		Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Content.BackgroundTransparency = 1.000
		Content.Position = UDim2.new(0, 10, 0, 25)
		Content.Size = UDim2.new(1, -20, 0, 0) 
		Content.ZIndex = ZIndex + 2
		Content.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		Content.Text = Config.Content
		Content.TextColor3 = Color3.fromRGB(200, 200, 200)
		Content.TextSize = 12.000
		Content.TextWrapped = true
		Content.TextXAlignment = Enum.TextXAlignment.Left
		Content.TextYAlignment = Enum.TextYAlignment.Top

		-- Calculate Height safely
		local parentWidth = Parent.AbsoluteSize.X
		if parentWidth < 50 then parentWidth = 300 end -- Fallback width if not rendered yet
		local limitX = parentWidth - 45
		
		local ContentSize = game:GetService("TextService"):GetTextSize(Content.Text, Content.TextSize, Enum.Font.GothamMedium, Vector2.new(limitX, 10000))
        Content.Size = UDim2.new(1, -20, 0, ContentSize.Y)
        Paragraph.Size = UDim2.new(1, -25, 0, ContentSize.Y + 35)
	end;

	function elements:AddPlayerView(Config)
		Config = Config or {}
		Config.Height = Config.Height or 250

		local Container = Instance.new("Frame")
		local Viewport = Instance.new("ViewportFrame")
		local WorldModel = Instance.new("WorldModel")
		local Camera = Instance.new("Camera")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local InputArea = Instance.new("TextButton") -- Invisible button for input

		Container.Name = GumballZ:RandomString()
		Container.Parent = Parent
		Container.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
		Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Container.BorderSizePixel = 0
		Container.Size = UDim2.new(1, -25, 0, Config.Height)
		Container.ZIndex = ZIndex + 1
		GumballZ:AddDragBlacklist(Container)

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Container

		UIStroke.Color = Color3.fromRGB(29, 29, 29)
		UIStroke.Parent = Container
		
		-- Use a button for easier input handling
		InputArea.Parent = Container
		InputArea.Size = UDim2.new(1,0,1,0)
		InputArea.BackgroundTransparency = 1
		InputArea.Text = ""
		InputArea.ZIndex = ZIndex + 10

		Viewport.Parent = Container
		Viewport.BackgroundTransparency = 1
		Viewport.Size = UDim2.new(1, 0, 1, 0)
		Viewport.CurrentCamera = Camera
		Viewport.ZIndex = ZIndex + 2
		Viewport.Active = false

		WorldModel.Parent = Viewport
		Camera.Parent = Viewport
		Camera.FieldOfView = 40 -- Lower FOV = less distortion, better portrait

		local Rotation = 0
		local IsDragging = false
		local LastMouseX = 0

		-- Safe Update Model Function
		local function UpdateModel()
			pcall(function()
				WorldModel:ClearAllChildren()
				local Player = game:GetService("Players").LocalPlayer
				if Player and Player.Character then
					Player.Character.Archivable = true
					local ClonedChar = Player.Character:Clone()
					if ClonedChar then
						ClonedChar.Parent = WorldModel
						
						local PrimaryPart = ClonedChar.PrimaryPart or ClonedChar:FindFirstChild("HumanoidRootPart")
						if PrimaryPart then
							ClonedChar.PrimaryPart = PrimaryPart
							-- Center model at 0, -1, 0 (Raised up to be more central)
							ClonedChar:PivotTo(CFrame.new(Vector3.new(0, -1, 0)) * CFrame.Angles(0, math.rad(Rotation), 0))
						end
					end
				end
			end)
		end
		
		-- Position camera further back for full body
		Camera.CFrame = CFrame.new(Vector3.new(0, 0, -15.5), Vector3.new(0, 0, 0))

		UpdateModel()

		-- Input Handling
		InputArea.MouseButton1Down:Connect(function()
			IsDragging = true
			LastMouseX = game:GetService("Players").LocalPlayer:GetMouse().X
		end)
		
		local UserInputService = game:GetService("UserInputService")
		
		local inputConnection
		inputConnection = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				IsDragging = false
			end
		end)
		
		local moveConnection
		moveConnection = UserInputService.InputChanged:Connect(function(input)
			if IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position.X - LastMouseX
				LastMouseX = input.Position.X
				-- Manual Rotate
				Rotation = Rotation + delta * 1.5
			end
		end)

		-- Render Loop for Rotation + Updates
		local connection
		connection = game:GetService("RunService").RenderStepped:Connect(function(dt)
			if not Container.Parent then 
				if connection then connection:Disconnect() end
				return 
			end
			
			if Config.DisableRotation then return end
			
			-- Auto-rotate if not dragging
			if not IsDragging then
				Rotation = Rotation + dt * 25 -- Auto rotation speed
			end
			
			-- Apply Rotation
			local Char = WorldModel:FindFirstChildOfClass("Model")
			if Char then
				-- We pivot the character at 0,-1,0 (Raised up)
				Char:PivotTo(CFrame.new(Vector3.new(0, -1, 0)) * CFrame.Angles(0, math.rad(Rotation), 0))
			end
		end)

		-- Handle Respawn
		local respawnConnection
		respawnConnection = game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
			task.wait(1)
			UpdateModel()
		end)
		
		-- Cleanup
		Container.Destroying:Connect(function()
			if inputConnection then inputConnection:Disconnect() end
			if moveConnection then moveConnection:Disconnect() end
			if respawnConnection then respawnConnection:Disconnect() end
			if connection then connection:Disconnect() end
		end)
	end;

	function elements:AddToggle(Config: Toggle)
		Config = Config or {};
		Config.Name = Config.Name or "Toggle";
		Config.Default = Config.Default or false;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(bool) end;
		Config.Flag = Config.Flag or nil;

		local Toggle = Instance.new("Frame")
		local Toggle_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local SwitchBall = Instance.new("Frame")
		local SwitchBallCorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Toggle.Name = GumballZ:RandomString()
		Toggle.Parent = Parent
		Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Toggle.BackgroundTransparency = 1.000
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(1, -25, 0, 17)
		Toggle.ZIndex = ZIndex + 1
		GumballZ:AddDragBlacklist(Toggle);

		Toggle_Name.Name = GumballZ:RandomString()
		Toggle_Name.Parent = Toggle
		Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
		Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Toggle_Name.BackgroundTransparency = 1.000
		Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle_Name.BorderSizePixel = 0
		Toggle_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Toggle_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Toggle_Name.ZIndex = ZIndex + 2
		Toggle_Name.FontFace = GumballZ.FontSemiBold;
		Toggle_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Toggle_Name.TextSize = 13.000
		Toggle_Name.TextTransparency = 1
		Toggle_Name.TextXAlignment = Enum.TextXAlignment.Left;

		GumballZ:ProtectText(Toggle_Name,Config.Name);

		ValueFrame.Name = GumballZ:RandomString()
		ValueFrame.Parent = Toggle
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 32, 0, 16)
		ValueFrame.ZIndex = ZIndex + 2
		ValueFrame.BackgroundTransparency = 1;

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = ValueFrame

		SwitchBall.Name = GumballZ:RandomString()
		SwitchBall.Parent = ValueFrame
		SwitchBall.AnchorPoint = Vector2.new(0, 0.5)
		SwitchBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SwitchBall.BackgroundTransparency = 1.000
		SwitchBall.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SwitchBall.BorderSizePixel = 0
		SwitchBall.Position = UDim2.new(0, 2, 0.5, 0)
		SwitchBall.Size = UDim2.new(0, 12, 0, 12)
		SwitchBall.ZIndex = ZIndex + 3

		SwitchBallCorner.CornerRadius = UDim.new(1, 0)
		SwitchBallCorner.Parent = SwitchBall

		OptionButton.Name = GumballZ:RandomString()
		OptionButton.Parent = Toggle
		OptionButton.AnchorPoint = Vector2.new(1, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(1, -40, 0.5, 0)
		OptionButton.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 1
		OptionButton.ZIndex = ZIndex + 4
		OptionButton.Visible = Config.Option;

		local toggleImg = function(value)
			if value then
				GumballZ:CreateAnimation(SwitchBall,0.25,{
					Position = UDim2.new(1, -14, 0.5, 0)
				})

				GumballZ:CreateAnimation(ValueFrame,0.25,{
					BackgroundColor3 = GumballZ.Colors.Main
				})
			else
				GumballZ:CreateAnimation(SwitchBall,0.25,{
					Position = UDim2.new(0, 2, 0.5, 0)
				})

				GumballZ:CreateAnimation(ValueFrame,0.25,{
					BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				})
			end;
		end;

		local OpcToggle = function(value)
			if value then
				GumballZ:CreateAnimation(Toggle_Name,0.45,{
					TextTransparency = 0.200
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0,
				})

				GumballZ:CreateAnimation(SwitchBall,0.45,{
					BackgroundTransparency = 0,
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.600) or 1
				})

				toggleImg(Config.Default)
			else
				GumballZ:CreateAnimation(Toggle_Name,0.45,{
					TextTransparency = 1
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1,
				})

				GumballZ:CreateAnimation(SwitchBall,0.45,{
					BackgroundTransparency = 1,
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))

		toggleImg(Config.Default);

		GumballZ:CreateHover(ValueFrame,function(b)
			if not Config.Default then
				if b then
					GumballZ:CreateAnimation(ValueFrame,0.45,{
						BackgroundColor3 = Color3.fromRGB(70, 70, 70)
					})
				else
					GumballZ:CreateAnimation(ValueFrame,0.45,{
						BackgroundColor3 = Color3.fromRGB(50, 50, 50)
					})
				end;
			end;
		end)

		GumballZ:NewInput(ValueFrame,function()
			Config.Default = not Config.Default;
			toggleImg(Config.Default);
			Config.Callback(Config.Default)
		end);

		local Respons = GumballZ:CreateResponse({
			Rename = function(new_name)
				Toggle_Name.Text = new_name;
				GumballZ:ProtectText(Toggle_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v)
				local IsSame = v == Config.Default;

				Config.Default = v;

				toggleImg(Config.Default);

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and (Config.Flag.."Toggle"),
			Option = (Config.Option and GumballZ:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			GumballZ.WindowFlags[GumballZWindow][Config.Flag.."Toggle"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddSlider(Config: Slider)
		Config = Config or {};
		Config.Name = Config.Name or "Slider";
		Config.Type = Config.Type or "";
		Config.Default = Config.Default or 50;
		Config.Min = Config.Min or 0;
		Config.Max = Config.Max or 100;
		Config.Round = Config.Round or 0;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(number) end;
		Config.Flag = Config.Flag or nil;

		local Slider = Instance.new("Frame")
		local Slider_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local boxli = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Slider.Name = GumballZ:RandomString()
		Slider.Parent = Parent
		Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.Size = UDim2.new(1, -25, 0, 17)
		Slider.ZIndex = ZIndex + 1

		GumballZ:AddDragBlacklist(Slider);

		Slider_Name.Name = GumballZ:RandomString()
		Slider_Name.Parent = Slider
		Slider_Name.AnchorPoint = Vector2.new(0, 0.5)
		Slider_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Slider_Name.BackgroundTransparency = 1.000
		Slider_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider_Name.BorderSizePixel = 0
		Slider_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Slider_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Slider_Name.ZIndex = ZIndex + 2
		Slider_Name.FontFace = GumballZ.FontSemiBold
		Slider_Name.Text = Config.Name
		Slider_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Slider_Name.TextSize = 13.000
		Slider_Name.TextTransparency = 0.200
		Slider_Name.TextXAlignment = Enum.TextXAlignment.Left

		ValueFrame.Name = GumballZ:RandomString()
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = GumballZ.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 85, 0.600000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame


		local UIStroke = Instance.new("UIStroke")
		UIStroke.Color = GumballZ.Colors.Main
		UIStroke.Thickness = 1
		UIStroke.Parent = ValueFrame

		OptionButton.Name = GumballZ:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option;
		OptionButton.ZIndex = ZIndex + 1;

		boxli.Name = GumballZ:RandomString()
		boxli.Parent = ValueFrame
		boxli.BackgroundColor3 = GumballZ.Colors.Main
		boxli.BorderColor3 = Color3.fromRGB(0, 0, 0)
		boxli.BorderSizePixel = 0
		boxli.Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
		boxli.ZIndex = ZIndex + 3

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = boxli

		ValueText.Name = GumballZ:RandomString()
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 4
		ValueText.FontFace = GumballZ.FontSemiBold
		ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));
		ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850;
		ValueText.TextTransparency = 0;

		local OpcToggle = function(value)
			if value then
				GumballZ:CreateAnimation(boxli,0.45,{
					BackgroundTransparency = 0,
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.600) or 1
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0,
				})

				GumballZ:CreateAnimation(Slider_Name,0.45,{
					TextTransparency = 0.200
				})

				GumballZ:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0;
				})
			else
				GumballZ:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1;
				})

				GumballZ:CreateAnimation(Slider_Name,0.45,{
					TextTransparency = 1
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1,
				})

				GumballZ:CreateAnimation(boxli,0.45,{
					BackgroundTransparency = 1,
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))

		local IsHold = false;

		local function update(Input)
			local SizeScale = math.clamp((((Input.Position.X) - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X), 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = GumballZ:Rounding(Main,Config.Round);
			local PositionX = UDim2.fromScale(SizeScale, 1);
			local normalized = (Value - Config.Min) / (Config.Max - Config.Min);

			TweenService:Create(boxli , TweenInfo.new(0.2),{
				Size = UDim2.new(normalized, 0, 1, 0)
			}):Play();

			Config.Default = Value;
			ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));

			Config.Callback(Value)
		end;

		do
			ValueFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					update(Input)
				end
			end)

			ValueFrame.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not GumballZ:IsMouseOverFrame(ValueFrame) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not GumballZ:IsMouseOverFrame(ValueFrame) then
								IsHold = false
							else
								update(Input)
							end;
						else
							update(Input)
						end;
					end;
				end;
			end);
		end;

		local Respons = GumballZ:CreateResponse({
			Rename = function(new_name)
				Slider_Name.Text = new_name
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v)
				local IsSame = v == Config.Default;

				Config.Default = v;

				TweenService:Create(boxli , TweenInfo.new(0.2),{
					Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
				}):Play();

				Config.Default = v;
				ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));

				if not IsSame then
					Config.Callback(v);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."Slider",
			Option = (Config.Option and GumballZ:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			GumballZ.WindowFlags[GumballZWindow][Config.Flag.."Slider"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddButton(Config: Button)
		Config = Config or {};
		Config.Name = Config.Name or "Slider";
		Config.Risky = Config.Risky or false;
		Config.Callback = Config.Callback or function() end;

		local Button = Instance.new("Frame")
		local Button_Name = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Button.Name = GumballZ:RandomString()
		Button.Parent = Parent
		Button.BackgroundColor3 = GumballZ.Colors.Black
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Size = UDim2.new(1, -25, 0, 25)
		Button.ZIndex = ZIndex + 1
		GumballZ:AddDragBlacklist(Button);

		Button_Name.Name = GumballZ:RandomString()
		Button_Name.Parent = Button
		Button_Name.AnchorPoint = Vector2.new(0, 0.5)
		Button_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Button_Name.BackgroundTransparency = 1.000
		Button_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button_Name.BorderSizePixel = 0
		Button_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Button_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Button_Name.ZIndex = ZIndex + 2
		Button_Name.FontFace = GumballZ.FontSemiBold
		Button_Name.Text = Config.Name
		Button_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Button_Name.TextSize = 12.000
		Button_Name.TextTransparency = 0.400
		GumballZ:ProtectText(Button_Name,Config.Name);

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = Button;

		local OpcToggle = function(value)
			if value then
				GumballZ:CreateAnimation(Button_Name,0.45,{
					TextTransparency = 0.4,
				})

				GumballZ:CreateAnimation(Button,0.45,{
					BackgroundTransparency = 0,
				})
			else
				GumballZ:CreateAnimation(Button_Name,0.45,{
					TextTransparency = 1,
				})

				GumballZ:CreateAnimation(Button,0.45,{
					BackgroundTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		GumballZ:CreateHover(Button,function(value)
			if value then
				GumballZ:CreateAnimation(Button,0.45,{
					BackgroundColor3 = Color3.fromRGB(14, 14, 14)
				})
			else
				GumballZ:CreateAnimation(Button,0.45,{
					BackgroundColor3 = GumballZ.Colors.Black
				})
			end;
		end)

		GumballZ:NewInput(Button,function()
			Config.Callback();
		end)

		return GumballZ:CreateResponse({
			Rename = function(new_name)
				Button_Name.Text = new_name
				GumballZ:ProtectText(Button_Name,new_name);
			end,
			SetText = function(text)
				local str = tostring(text or "")
				Button_Name.Text = str
				GumballZ:ProtectText(Button_Name, str)
				Button_Name.TextTransparency = 0.4 -- Ensure visible
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			Fire = Config.Callback,
		})
	end;

	function elements:AddColorPicker(Config: ColorPicker)
		Config = Config or {};
		Config.Name = Config.Name or "Color Picker";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or Color3.fromRGB(255, 255, 255);
		Config.Callback = Config.Callback or function(number) end;
		Config.Transparency = Config.Transparency or 0;
		Config.Flag = Config.Flag or nil;

		local ColorPicker = Instance.new("Frame")
		local ColorPicker_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		ColorPicker.Name = GumballZ:RandomString()
		ColorPicker.Parent = Parent
		ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker.BackgroundTransparency = 1.000
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.Size = UDim2.new(1, -25, 0, 17)
		ColorPicker.ZIndex = ZIndex + 1
		GumballZ:AddDragBlacklist(ColorPicker);

		ColorPicker_Name.Name = GumballZ:RandomString()
		ColorPicker_Name.Parent = ColorPicker
		ColorPicker_Name.AnchorPoint = Vector2.new(0, 0.5)
		ColorPicker_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker_Name.BackgroundTransparency = 1.000
		ColorPicker_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker_Name.BorderSizePixel = 0
		ColorPicker_Name.Position = UDim2.new(0, 0, 0.5, 0)
		ColorPicker_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		ColorPicker_Name.ZIndex = ZIndex + 2
		ColorPicker_Name.FontFace = GumballZ.FontSemiBold
		ColorPicker_Name.Text = Config.Name
		ColorPicker_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker_Name.TextSize = 13.000
		ColorPicker_Name.TextTransparency = 0.200
		ColorPicker_Name.TextXAlignment = Enum.TextXAlignment.Left
		ColorPicker_Name.ZIndex = ZIndex + 2

		ValueFrame.Name = GumballZ:RandomString()
		ValueFrame.Parent = ColorPicker
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Config.Default
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 35, 0.699999988, 0)
		ValueFrame.ZIndex = ZIndex + 3

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = GumballZ:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 7;

		local res = GumballZ:CreateColorPicker(ValueFrame,Config.Transparency,function(rgb,opc)
			ValueFrame.BackgroundColor3 = rgb;
			ValueFrame.BackgroundTransparency = opc;

			task.spawn(Config.Callback,rgb,opc)
		end);

		local OpcToggle = function(value)
			if value then
				GumballZ:CreateAnimation(ColorPicker_Name,0.45,{
					TextTransparency = 0.2,
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					Size = UDim2.new(0, 35, 0.7, 0)
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				GumballZ:CreateAnimation(ColorPicker_Name,0.45,{
					TextTransparency = 1,
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					Size = UDim2.new(0, 35, 0, 0)
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = GumballZ:CreateResponse({
			Rename = function(new_name)
				ColorPicker.Text = new_name
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(rgb,opc)
				local IsSame = ValueFrame.BackgroundColor3 == rgb or ValueFrame.BackgroundTransparency == opc;

				ValueFrame.BackgroundColor3 = rgb; 
				ValueFrame.BackgroundTransparency = opc;
				res.set_opc(opc);

				if not IsSame then
					task.spawn(Config.Callback,rgb,opc)
				end;
			end,
			GetValue = function()
				return {
					Color = ValueFrame.BackgroundColor3,
					Transparency = ValueFrame.BackgroundTransparency
				};
			end,
			Flag = Config.Flag and Config.Flag.."ColorPicker",
			Option = (Config.Option and GumballZ:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			GumballZ.WindowFlags[GumballZWindow][Config.Flag.."ColorPicker"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddDropdown(Config: Dropdown)
		Config = Config or {};
		Config.Name = Config.Name or "Dropdown";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;
		Config.Values = Config.Values or {};
		Config.Multi = Config.Multi or false;

		local DataParser = function(value)
			if not value then return 'None'; end;

			local Out;

			if typeof(value) == 'table' then
				if #value > 0 then
					local x = {};

					for i,v in next , value do
						table.insert(x , tostring(v))
					end;

					Out = table.concat(x,' , ');
				else
					local x = {};

					for i,v in next , value do
						if v == true then
							table.insert(x , tostring(i));
						end			
					end;

					Out = table.concat(x,' , ');
				end;
			else
				Out = tostring(value);
			end;

			return Out;
		end;

		local Dropdown = Instance.new("Frame")
		local Dropdown_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local icon = Instance.new("ImageLabel")
		local Value_Text = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Dropdown.Name = GumballZ:RandomString()
		Dropdown.Parent = Parent
		Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown.BackgroundTransparency = 1.000
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.Size = UDim2.new(1, -25, 0, 17)
		Dropdown.ZIndex = ZIndex + 3
		GumballZ:AddDragBlacklist(Dropdown);

		Dropdown_Name.Name = GumballZ:RandomString()
		Dropdown_Name.Parent = Dropdown
		Dropdown_Name.AnchorPoint = Vector2.new(0, 0.5)
		Dropdown_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown_Name.BackgroundTransparency = 1.000
		Dropdown_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown_Name.BorderSizePixel = 0
		Dropdown_Name.Position = UDim2.new(0, 0, 0, 8)
		Dropdown_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Dropdown_Name.ZIndex = 7
		Dropdown_Name.FontFace = GumballZ.FontSemiBold
		Dropdown_Name.Text = Config.Name
		Dropdown_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown_Name.TextSize = 13.000
		Dropdown_Name.TextTransparency = 0.200
		Dropdown_Name.TextXAlignment = Enum.TextXAlignment.Left
		Dropdown_Name.ZIndex = ZIndex + 4
		GumballZ:ProtectText(Dropdown_Name,Config.Name);

		ValueFrame.Name = GumballZ:RandomString()
		ValueFrame.Parent = Dropdown
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = GumballZ.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.925000012, 0)
		ValueFrame.ZIndex = ZIndex + 4

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame


		local UIStroke = Instance.new("UIStroke")
		UIStroke.Color = GumballZ.Colors.Main
		UIStroke.Thickness = 1
		UIStroke.Parent = ValueFrame

		OptionButton.Name = GumballZ:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0, 7)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 8
		OptionButton.Visible = Config.Option;

		icon.Name = GumballZ:RandomString()
		icon.Parent = ValueFrame
		icon.AnchorPoint = Vector2.new(1, 0)
		icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		icon.BackgroundTransparency = 1.000
		icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		icon.BorderSizePixel = 0
		icon.Position = UDim2.new(1, 0, 0, 0)
		icon.Size = UDim2.new(0,15,0,15)
		icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		icon.ZIndex = ZIndex + 5
		icon.Image = "rbxassetid://10709790948"

		Value_Text.Name = GumballZ:RandomString()
		Value_Text.Parent = ValueFrame
		Value_Text.AnchorPoint = Vector2.new(0, 0.5)
		Value_Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Value_Text.BackgroundTransparency = 1.000
		Value_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value_Text.BorderSizePixel = 0
		Value_Text.Position = UDim2.new(0, 3, 0.5, 0)
		Value_Text.Size = UDim2.new(1, -18, 0.800000012, 0)
		Value_Text.ZIndex = ZIndex + 5
		Value_Text.FontFace = GumballZ.FontSemiBold
		Value_Text.Text = DataParser(Config.Default)
		Value_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
		Value_Text.TextSize = 10.000
		Value_Text.TextTransparency = 0.500
		Value_Text.TextXAlignment = Enum.TextXAlignment.Left
		Value_Text.TextYAlignment = Enum.TextYAlignment.Top
		Value_Text.TextWrapped = true
		Value_Text.TextTruncate = Enum.TextTruncate.SplitWord

		local res;
		res = GumballZ:CreateDropdown(ValueFrame,Config.Default,Config.Multi,Config.AutoUpdate,function(args)
			Config.Default = args;
			Value_Text.Text = DataParser(Config.Default);

			res:change_default(Config.Default);

			Config.Callback(args);
		end);

		res:set_data(Config.Values);
		res:refresh();

		res:on_toggle(function(b)
			if b then
				GumballZ:CreateAnimation(icon,0.35,{
					Rotation = -180,
					ImageColor3 = GumballZ.Colors.Main
				})
			else
				GumballZ:CreateAnimation(icon,0.35,{
					Rotation = 0,
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				})
			end;
		end);

		local OpcToggle = function(value)
			if value then
				GumballZ:CreateAnimation(Dropdown_Name,0.45,{
					TextTransparency = 0.2,
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				GumballZ:CreateAnimation(icon,0.45,{
					ImageTransparency = 0
				})

				GumballZ:CreateAnimation(Value_Text,0.45,{
					TextTransparency = 0.5
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				GumballZ:CreateAnimation(Dropdown_Name,0.45,{
					TextTransparency = 1,
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				GumballZ:CreateAnimation(icon,0.45,{
					ImageTransparency = 1
				})

				GumballZ:CreateAnimation(Value_Text,0.45,{
					TextTransparency = 1
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = GumballZ:CreateResponse({
			Rename = function(new_name)
				Dropdown_Name.Text = new_name
				GumballZ:ProtectText(Dropdown_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)

				Config.Default = def;
				Value_Text.Text = DataParser(Config.Default);
				res:change_default(Config.Default);

				Config.Callback(def);
			end,
			SetData = function(def)
				Config.Values = def;

				res:set_data(Config.Values);

				if not Config.AutoUpdate then
					res:refresh();
				end
			end,
			Flag = Config.Flag and Config.Flag.."Dropdown",
			Option = (Config.Option and GumballZ:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			GumballZ.WindowFlags[GumballZWindow][Config.Flag.."Dropdown"] = Respons;
		end;

		return Respons;
	end;
	
	function elements:AddKeybind(Config: Keybind)
		Config = Config or {};
		Config.Name = Config.Name or "Keybind";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;

		local Keys = {
			One = '1',
			Two = '2',
			Three = '3',
			Four = '4',
			Five = '5',
			Six = '6',
			Seven = '7',
			Eight = '8',
			Nine = '9',
			Zero = '0',
			['Minus'] = "-",
			['Plus'] = "+",
			BackSlash = "\\",
			Slash = "/",
			Period = '.',
			Semicolon = ';',
			Colon = ":",
			LeftControl = "LCtrl",
			RightControl = "RCtrl",
			LeftShift = "LShift",
			RightShift = "RShift",
			Return = "Enter",
			LeftBracket = "[",
			RightBracket = "]",
			Quote = "'",
			Comma = ",",
			Equals = "=",
			LeftSuper = "Super",
			RightSuper = "Super"
		};

		local GetItem = function(item)
			if item then
				if typeof(item) == 'EnumItem' then
					return Keys[item.Name] or item.Name;
				else
					return Keys[tostring(item)] or tostring(item);
				end;
			else
				return 'None';
			end;
		end;

		local Keybind = Instance.new("Frame")
		local Keybind_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Keybind.Name = GumballZ:RandomString()
		Keybind.Parent = Parent
		Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Keybind.BackgroundTransparency = 1.000
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.Size = UDim2.new(1, -25, 0, 17)
		Keybind.ZIndex = ZIndex + 1
		GumballZ:AddDragBlacklist(Keybind);

		Keybind_Name.Name = GumballZ:RandomString()
		Keybind_Name.Parent = Keybind
		Keybind_Name.AnchorPoint = Vector2.new(0, 0.5)
		Keybind_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Keybind_Name.BackgroundTransparency = 1.000
		Keybind_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind_Name.BorderSizePixel = 0
		Keybind_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Keybind_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Keybind_Name.ZIndex = ZIndex + 2
		Keybind_Name.FontFace = GumballZ.FontSemiBold
		Keybind_Name.Text = Config.Name
		Keybind_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		Keybind_Name.TextSize = 13.000
		Keybind_Name.TextTransparency = 0.200
		Keybind_Name.TextXAlignment = Enum.TextXAlignment.Left
		GumballZ:ProtectText(Keybind_Name,Config.Name);

		ValueFrame.Name = GumballZ:RandomString()
		ValueFrame.Parent = Keybind
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = GumballZ.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.850000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = GumballZ:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option or false;

		ValueText.Name = GumballZ:RandomString()
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 3
		ValueText.FontFace = GumballZ.FontSemiBold
		ValueText.Text = GetItem(Config.Default)
		ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850
		ValueText.TextTransparency = 0.400

		local IsBinding = false;
		GumballZ:NewInput(ValueFrame,function()
			if IsBinding then
				return;
			end;

			ValueText.Text = "...";

			local Selected = nil;
			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 then
						Selected = "MouseLeft";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then
						Selected = "MouseRight";
					end;
				end;
			end;

			Config.Default = Selected;

			ValueText.Text = GetItem(Selected);

			IsBinding = false;

			Config.Callback(typeof(Selected) == "string" and Selected or Selected.Name);
		end);

		local OpcToggle = function(value)
			if value then
				GumballZ:CreateAnimation(Keybind_Name,0.45,{
					TextTransparency = 0.2,
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				GumballZ:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0.400
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				GumballZ:CreateAnimation(Keybind_Name,0.45,{
					TextTransparency = 1,
				})

				GumballZ:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				GumballZ:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})

				GumballZ:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = GumballZ:CreateResponse({
			Rename = function(new_name)
				Keybind_Name.Text = new_name
				GumballZ:ProtectText(Keybind_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)
				local IsSame = Config.Default == def;

				Config.Default = def;
				ValueText.Text = GetItem(Config.Default);

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."Keybind",
			Option = (Config.Option and GumballZ:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then

			GumballZ.WindowFlags[GumballZWindow][Config.Flag.."Keybind"] = Respons;
		end;

		return Respons;
	end;

	return elements;
end;

function GumballZ:CreateConfigWindow(Root: ScreenGui , Gum , Button: ImageButton)

	local ConfigWindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local UIListLayout = Instance.new("UIListLayout")
	local SpaceBox = Instance.new("Frame")
	local InputFrame = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_3 = Instance.new("UICorner")
	local TextBox = Instance.new("TextBox")
	local AddConfigButton = Instance.new("ImageButton")
	local UICorner_4 = Instance.new("UICorner")
	local GetConfigButton = Instance.new("ImageButton")
	local UICorner_5 = Instance.new("UICorner")
	local SaveConfigButton = Instance.new("ImageButton")
	local UICorner_6 = Instance.new("UICorner")
	local DeleteButton = Instance.new("ImageButton")
	local UICorner_7 = Instance.new("UICorner")

	GumballZ:ScrollSignal(ScrollingFrame,UIListLayout,"Y");

	GumballZ:AddDragBlacklist(ConfigWindowFrame);

	local UIToggle = false;
	local ElementToggle = function(value)
		UIToggle = value;

		if value then
			ConfigWindowFrame.Position = UDim2.fromOffset(Button.AbsolutePosition.X,Button.AbsolutePosition.Y + (Button.AbsoluteSize.Y * 3));

			GumballZ:CreateAnimation(ConfigWindowFrame,0.3,{
				Size = UDim2.new(0, 185, 0, 195),
			})

			GumballZ:CreateAnimation(UIStroke,0.3,{
				Transparency = 0
			})

			GumballZ:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 0.750
			})

			GumballZ:CreateAnimation(ScrollingFrame,0.3,{
				BackgroundTransparency = 0
			})

			GumballZ:CreateAnimation(UIStroke_2,0.3,{
				Transparency = 0.750
			})

			GumballZ:CreateAnimation(UIStroke_3,0.3,{
				Transparency = 0.750
			})

			GumballZ:CreateAnimation(SpaceBox,0.3,{
				BackgroundTransparency = 0
			})

			GumballZ:CreateAnimation(InputFrame,0.3,{
				BackgroundTransparency = 0
			})

			GumballZ:CreateAnimation(TextBox,0.3,{
				TextTransparency = 0.5
			})

			GumballZ:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			GumballZ:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			GumballZ:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			GumballZ:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0.2500
			})

			GumballZ:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 0.75
			})
		else
			GumballZ:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(ConfigWindowFrame,0.275,{
				Size = UDim2.new(0, 185, 0, 0),
			})

			GumballZ:CreateAnimation(UIStroke,0.3,{
				Transparency = 1
			})

			GumballZ:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(ScrollingFrame,0.3,{
				BackgroundTransparency = 1
			})

			GumballZ:CreateAnimation(UIStroke_2,0.3,{
				Transparency = 1
			})

			GumballZ:CreateAnimation(UIStroke_3,0.3,{
				Transparency = 1
			})

			GumballZ:CreateAnimation(SpaceBox,0.3,{
				BackgroundTransparency = 1
			})

			GumballZ:CreateAnimation(InputFrame,0.3,{
				BackgroundTransparency = 1
			})

			GumballZ:CreateAnimation(TextBox,0.3,{
				TextTransparency = 1
			})

			GumballZ:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 1
			})
		end;
	end;

	ElementToggle(false);

	ConfigWindowFrame.Name = "ConfigWindowFrame"
	ConfigWindowFrame.Parent = Root
	ConfigWindowFrame.AnchorPoint = Vector2.new(0,1)
	ConfigWindowFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ConfigWindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigWindowFrame.BorderSizePixel = 0
	ConfigWindowFrame.ClipsDescendants = true
	ConfigWindowFrame.Position = UDim2.new(2,0,2,0)
	ConfigWindowFrame.Size = UDim2.new(0, 185, 0, 0)
	ConfigWindowFrame.ZIndex = 205

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ConfigWindowFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ConfigWindowFrame

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = ConfigWindowFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 205
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = ConfigWindowFrame
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = GumballZ.Colors.Black
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0, 8, 0, 8)
	ScrollingFrame.Size = UDim2.new(1, -40, 1, -45)
	ScrollingFrame.ZIndex = 207
	ScrollingFrame.ScrollBarThickness = 0

	UICorner_2.CornerRadius = UDim.new(0, 3)
	UICorner_2.Parent = ScrollingFrame

	UIStroke_2.Transparency = 0.750
	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_2.Parent = ScrollingFrame

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	SpaceBox.Name = "SpaceBox"
	SpaceBox.Parent = ScrollingFrame
	SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpaceBox.BorderSizePixel = 0
	SpaceBox.Size = UDim2.new(0, 0, 0, 1)

	InputFrame.Name = "InputFrame"
	InputFrame.Parent = ConfigWindowFrame
	InputFrame.AnchorPoint = Vector2.new(0, 1)
	InputFrame.BackgroundColor3 = GumballZ.Colors.Black
	InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InputFrame.BorderSizePixel = 0
	InputFrame.Position = UDim2.new(0, 8, 1, -9)
	InputFrame.Size = UDim2.new(1, -40, 0, 22)
	InputFrame.ZIndex = 208

	UIStroke_3.Transparency = 0.750
	UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_3.Parent = InputFrame

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = InputFrame

	TextBox.Parent = InputFrame
	TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextBox.Size = UDim2.new(1, -10, 1, -1)
	TextBox.ZIndex = 209
	TextBox.FontFace = GumballZ.FontSemiBold
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 10.000
	TextBox.TextTransparency = 0.500
	TextBox.TextXAlignment = Enum.TextXAlignment.Left

	AddConfigButton.Name = "AddConfigButton"
	AddConfigButton.Parent = InputFrame
	AddConfigButton.AnchorPoint = Vector2.new(0, 0.5)
	AddConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AddConfigButton.BackgroundTransparency = 1.000
	AddConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AddConfigButton.BorderSizePixel = 0
	AddConfigButton.Position = UDim2.new(1, 8, 0.5, 0)
	AddConfigButton.Size = UDim2.new(0, 15, 0, 15)
	AddConfigButton.ZIndex = 209
	AddConfigButton.Image = "rbxassetid://10734923868"
	AddConfigButton.ImageTransparency = 0.500

	UICorner_4.CornerRadius = UDim.new(1, 0)
	UICorner_4.Parent = AddConfigButton

	GetConfigButton.Name = "GetConfigButton"
	GetConfigButton.Parent = ConfigWindowFrame
	GetConfigButton.AnchorPoint = Vector2.new(1, 0)
	GetConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GetConfigButton.BackgroundTransparency = 1.000
	GetConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GetConfigButton.BorderSizePixel = 0
	GetConfigButton.Position = UDim2.new(1, -8, 0, 10)
	GetConfigButton.Size = UDim2.new(0, 15, 0, 15)
	GetConfigButton.ZIndex = 209
	GetConfigButton.Image = "rbxassetid://10723387265"
	GetConfigButton.ImageTransparency = 0.500

	UICorner_5.CornerRadius = UDim.new(1, 0)
	UICorner_5.Parent = GetConfigButton

	SaveConfigButton.Name = "SaveConfigButton"
	SaveConfigButton.Parent = ConfigWindowFrame
	SaveConfigButton.AnchorPoint = Vector2.new(1, 0)
	SaveConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SaveConfigButton.BackgroundTransparency = 1.000
	SaveConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaveConfigButton.BorderSizePixel = 0
	SaveConfigButton.Position = UDim2.new(1, -8, 0, 28)
	SaveConfigButton.Size = UDim2.new(0, 15, 0, 15)
	SaveConfigButton.ZIndex = 209
	SaveConfigButton.Image = "rbxassetid://10734941499"
	SaveConfigButton.ImageTransparency = 0.500

	UICorner_6.CornerRadius = UDim.new(1, 0)
	UICorner_6.Parent = SaveConfigButton

	DeleteButton.Name = "DeleteButton"
	DeleteButton.Parent = ConfigWindowFrame
	DeleteButton.AnchorPoint = Vector2.new(1, 0)
	DeleteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DeleteButton.BackgroundTransparency = 1.000
	DeleteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DeleteButton.BorderSizePixel = 0
	DeleteButton.Position = UDim2.new(1, -8, 0, 55)
	DeleteButton.Size = UDim2.new(0, 15, 0, 15)
	DeleteButton.ZIndex = 209
	DeleteButton.Image = "rbxassetid://10747362393"
	DeleteButton.ImageColor3 = GumballZ.Colors.Main
	DeleteButton.ImageTransparency = 0.250

	UICorner_7.CornerRadius = UDim.new(1, 0)
	UICorner_7.Parent = DeleteButton

	Button.MouseButton1Click:Connect(function()
		ElementToggle(true);
	end);

	GumballZ:CreateHover(DeleteButton,function(bool)
		if bool then
			GumballZ:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0;
			})
		else
			GumballZ:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0.35;
			})
		end;
	end);

	GumballZ:CreateHover(SaveConfigButton,function(bool)
		if bool then
			GumballZ:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			GumballZ:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	GumballZ:CreateHover(GetConfigButton,function(bool)
		if bool then
			GumballZ:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			GumballZ:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	GumballZ:CreateHover(AddConfigButton,function(bool)
		if bool then
			GumballZ:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			GumballZ:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	game:GetService('UserInputService').InputBegan:Connect(function(Input,Typing)
		if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
			if UIToggle and not GumballZ:IsMouseOverFrame(ConfigWindowFrame) then
				ElementToggle(false);
			end;
		end;
	end);

	local new_button = function()
		local db_selected = Instance.new("TextButton")

		db_selected.Name = GumballZ:RandomString()
		db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		db_selected.BackgroundTransparency = 1.000
		db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
		db_selected.BorderSizePixel = 0
		db_selected.Size = UDim2.new(1, 0, 0, 10)
		db_selected.ZIndex = 220
		db_selected.FontFace = GumballZ.FontSemiBold
		db_selected.TextColor3 = Color3.fromRGB(150, 150, 150)
		db_selected.TextSize = 12.000
		db_selected.TextXAlignment = Enum.TextXAlignment.Left

		return db_selected;
	end;

	local Configs = {};
	local import = {
		Name = nil,
		Element = nil;
	};

	local res;
	res = GumballZ:CreateResponse({
		SetFiles = function(configs,bypass)
			local OldLen = #Configs;

			Configs = configs;

			if OldLen ~= #configs and not bypass then
				res:ReloadConfig();
			end;
		end,

		Refresh = function()
			for i,v in next , ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					v:Destroy();
				end;
			end;

			for i,v in next, Configs do
				local button = new_button();

				button.Parent = ScrollingFrame;
				button.Text = " "..tostring(v);

				if tostring(import.Name) == tostring(v) or import.Name == v then
					import.Element = button;
					import.Name = v;
					import.Element.TextColor3 = GumballZ.Colors.Main;
					button.Text = "  "..tostring(v);
				end;

				button.MouseButton1Click:Connect(function()
					if import.Element then
						import.Element.TextColor3 = Color3.fromRGB(150, 150, 150);
						import.Element.Text = " "..import.Name;
					end;

					import.Element = button;
					import.Name = v;
					button.TextColor3 = GumballZ.Colors.Main;
					button.Text = "  "..tostring(v);
				end);
			end;
		end,

		ReloadConfig = function()
			assert(res.ConfigDirectory , "Config directory not found");

			local files = {};

			for i,v in next , listfiles(res.ConfigDirectory) do
				local spl = (string.find(v,'/',1,true) and string.split(v,'/')) or (string.find(v,'\\',1,true) and string.split(v,'\\'));
				local name = spl[#spl];

				table.insert(files,name);
			end;

			res:SetFiles(files,true);
			res:Refresh();
		end,

		DeleteConfig = function(name)
			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			if isfile(path) then
				delfile(path)
			end;
		end,

		SaveConfig = function(name,content)
			if string.find(name,'/',1,true) or string.find(name,'\\',1,true) or string.find(name,':',1,true) then
				return;	
			end;

			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			writefile(path , content);
		end,

		LoadConfig = function(name)

			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			if isfile(path) then
				local decoded = game:GetService('HttpService'):JSONDecode(readfile(path));

				Gum.Notifier:Notify({
					Title = "Config",
					Content = "Loaded config '"..tostring(name).."'",
					Icon = "settings",
					Duration = 4,
				});

				Gum:LoadConfig(decoded);
			end;
		end,

		Init = function(Name: string,Folder: string)
			if not isfolder(Folder or "GumballZ") then
				makefolder(Folder or "GumballZ");	
			end;

			if not isfolder((Folder or "GumballZ").."/Config") then
				makefolder((Folder or "GumballZ").."/Config");	
			end;

			local cfgPath = (Folder or "GumballZ").."/Config/"..tostring(Name);

			if not isfolder(cfgPath) then
				makefolder(cfgPath)
			end;

			res.ConfigDirectory = cfgPath;

			AddConfigButton.MouseButton1Click:Connect(function()
				local configName = TextBox.Text;

				if not configName:byte() then return end;

				local flags = Gum:GetFlagConfig();

				flags.Info = {
					Name = Name,
					Folder = Folder,
					ConfigName = configName,
				};

				local code = game:GetService('HttpService'):JSONEncode(flags);

				res:SaveConfig(configName , code);
				res:ReloadConfig();

				Gum.Notifier:Notify({
					Title = "Config",
					Content = "Saved config '"..tostring(configName).."'",
					Icon = "settings",
					Duration = 4,
				});

				TextBox.Text = "";
			end);

			GetConfigButton.MouseButton1Click:Connect(function()
				if import and import.Name then
					res:LoadConfig(import.Name);
				end;
			end);

			SaveConfigButton.MouseButton1Click:Connect(function()
				if import and import.Name then
					local flags = Gum:GetFlagConfig();
					local configName = import.Name;

					flags.Info = {
						Name = Name,
						Folder = Folder,
						ConfigName = configName,
						Type = "Overwrite"
					};

					Gum.Notifier:Notify({
						Title = "Config",
						Content = "Saved config '"..tostring(configName).."'",
						Icon = "settings",
						Duration = 4,
					});

					local code = game:GetService('HttpService'):JSONEncode(flags);

					res:SaveConfig(configName , code);
					res:ReloadConfig();
				end;
			end);

			DeleteButton.MouseButton1Click:Connect(function()
				if import and import.Name then

					Gum.Notifier:Notify({
						Title = "Config",
						Content = "Deleted config '"..tostring(import.Name).."'",
						Icon = "settings",
						Duration = 4,
					});

					res:DeleteConfig(import.Name);
					res:ReloadConfig();
				end;
			end)
		end,
	});

	return res;
end;

function GumballZ.new(Window: Window)
	local Players = game:GetService("Players")
	local Client = Players.LocalPlayer
	Window = Window or {};
	Window.Name = Window.Name or "GUMBALLZ";
	Window.Scale = Window.Scale or UDim2.new(0, 750, 0, 500);
	Window.Keybind = Window.Keybind or "Insert";
	Window.Expire = Window.Expire or "never";
	Window.KeySettings = Window.KeySettings or {};
	Window.KeySettings.Title = Window.KeySettings.Title or "Key System";
	Window.KeySettings.Subtitle = Window.KeySettings.Subtitle or "Link in description";
	Window.KeySettings.Note = Window.KeySettings.Note or "No Key Note";
	Window.KeySettings.FileName = Window.KeySettings.FileName or "Key";
	Window.KeySettings.SaveKey = Window.KeySettings.SaveKey or false;
	Window.KeySettings.GrabKeyFromSite = Window.KeySettings.GrabKeyFromSite or false;
	Window.KeySettings.Key = Window.KeySettings.Key or {};

	local Gum = {
		Menus = {},
		ElementContents = {},
		MenuSelected = nil,
		Toggle = true,
		Signal = Instance.new('BindableEvent');
	};

	Gum.Notifier = GumballZ.__NOTIFIER_CACHE or GumballZ:CreateNotifier();

	-- Key System Implementation
	if Window.KeySettings and Window.KeySettings.Key and (typeof(Window.KeySettings.Key) == "string" and Window.KeySettings.Key ~= "" or typeof(Window.KeySettings.Key) == "table" and #Window.KeySettings.Key > 0 or typeof(Window.KeySettings.Key) == "function") then
		local KeySettings = Window.KeySettings
		local savedKey = ""
		local success = false
		
		if KeySettings.SaveKey then
			if isfile(KeySettings.FileName..".key") then
				savedKey = readfile(KeySettings.FileName..".key")
			end
		end

		if savedKey ~= "" then
			if typeof(KeySettings.Key) == "table" then
				if table.find(KeySettings.Key, savedKey) then
					success = true
				end
			elseif typeof(KeySettings.Key) == "string" then
				if savedKey == KeySettings.Key then
					success = true
				end
			elseif typeof(KeySettings.Key) == "function" then
				local success_key, expire_date = KeySettings.Key(savedKey)
				if success_key then
					success = true
					if expire_date then
						Window.Expire = expire_date
					end
				end
			end
		end
		
		if success then
			Gum.Notifier:Notify({
				Title = "Key System",
				Content = "Key found from save file!",
				Icon = "key",
				Duration = 5,
			})
		else
			local KeySystemGui = Instance.new("ScreenGui")
			KeySystemGui.Name = GumballZ:RandomString()
			KeySystemGui.Parent = CoreGui
			KeySystemGui.IgnoreGuiInset = true
			
			local verified = false

			local MainFrame = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Subtitle = Instance.new("TextLabel")
			local Note = Instance.new("TextLabel")
			local KeyInput = Instance.new("TextBox")
			local KeyInputCorner = Instance.new("UICorner")
			local KeyInputStroke = Instance.new("UIStroke")
			local CheckKeyButton = Instance.new("TextButton")
			local CheckKeyCorner = Instance.new("UICorner")
			local GetKeyButton = Instance.new("TextButton")
			local GetKeyCorner = Instance.new("UICorner")

			MainFrame.Name = "MainFrame"
			MainFrame.Parent = KeySystemGui
			MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			MainFrame.BorderSizePixel = 0
			MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			MainFrame.Size = UDim2.new(0, 350, 0, 180)

			UIStroke.Color = Color3.fromRGB(45, 45, 45)
			UIStroke.Thickness = 1
			UIStroke.Parent = MainFrame

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = MainFrame

			Title.Name = "Title"
			Title.Parent = MainFrame
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 20, 0, 15)
			Title.Size = UDim2.new(1, -40, 0, 20)
			Title.Font = Enum.Font.GothamBold
			Title.Text = KeySettings.Title
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 18.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			Subtitle.Name = "Subtitle"
			Subtitle.Parent = MainFrame
			Subtitle.BackgroundTransparency = 1.000
			Subtitle.Position = UDim2.new(0, 20, 0, 35)
			Subtitle.Size = UDim2.new(1, -40, 0, 15)
			Subtitle.Font = Enum.Font.Gotham
			Subtitle.Text = KeySettings.Subtitle
			Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
			Subtitle.TextSize = 12.000
			Subtitle.TextXAlignment = Enum.TextXAlignment.Left

			Note.Name = "Note"
			Note.Parent = MainFrame
			Note.BackgroundTransparency = 1.000
			Note.Position = UDim2.new(0, 20, 0, 145)
			Note.Size = UDim2.new(1, -40, 0, 15)
			Note.Font = Enum.Font.Gotham
			Note.Text = KeySettings.Note
			Note.TextColor3 = Color3.fromRGB(100, 100, 100)
			Note.TextSize = 11.000
			Note.TextXAlignment = Enum.TextXAlignment.Center

			KeyInput.Name = "KeyInput"
			KeyInput.Parent = MainFrame
			KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			KeyInput.Position = UDim2.new(0, 20, 0, 65)
			KeyInput.Size = UDim2.new(1, -40, 0, 35)
			KeyInput.Font = Enum.Font.Gotham
			KeyInput.PlaceholderText = "Enter Key..."
			KeyInput.Text = ""
			KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyInput.TextSize = 14.000
			KeyInput.TextXAlignment = Enum.TextXAlignment.Center
			KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)

			KeyInputCorner.CornerRadius = UDim.new(0, 4)
			KeyInputCorner.Parent = KeyInput
			
			KeyInputStroke.Color = Color3.fromRGB(50, 50, 50)
			KeyInputStroke.Thickness = 1
			KeyInputStroke.Parent = KeyInput
			
			KeyInput.Focused:Connect(function()
				GumballZ:CreateAnimation(KeyInputStroke, 0.2, {Color = GumballZ.Colors.Main})
			end)
			
			KeyInput.FocusLost:Connect(function()
				GumballZ:CreateAnimation(KeyInputStroke, 0.2, {Color = Color3.fromRGB(50, 50, 50)})
			end)

			CheckKeyButton.Name = "CheckKeyButton"
			CheckKeyButton.Parent = MainFrame
			CheckKeyButton.BackgroundColor3 = GumballZ.Colors.Main
			CheckKeyButton.Position = UDim2.new(0, 20, 0, 110)
			CheckKeyButton.Size = UDim2.new(0, 150, 0, 30)
			CheckKeyButton.Font = Enum.Font.GothamBold
			CheckKeyButton.Text = "Check Key"
			CheckKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			CheckKeyButton.TextSize = 13.000

			CheckKeyCorner.CornerRadius = UDim.new(0, 4)
			CheckKeyCorner.Parent = CheckKeyButton

			GetKeyButton.Name = "GetKeyButton"
			GetKeyButton.Parent = MainFrame
			GetKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			GetKeyButton.Position = UDim2.new(1, -170, 0, 110)
			GetKeyButton.Size = UDim2.new(0, 150, 0, 30)
			GetKeyButton.Font = Enum.Font.GothamBold
			GetKeyButton.Text = "Get Key"
			GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			GetKeyButton.TextSize = 13.000

			GetKeyCorner.CornerRadius = UDim.new(0, 4)
			GetKeyCorner.Parent = GetKeyButton
			
			local function VerifyKey()
				local inputKey = KeyInput.Text
				local valid = false
				
				if typeof(KeySettings.Key) == "table" then
					if table.find(KeySettings.Key, inputKey) then
						valid = true
					end
				elseif typeof(KeySettings.Key) == "string" then
					if inputKey == KeySettings.Key then
						valid = true
					end
				elseif typeof(KeySettings.Key) == "function" then
					local success_key, expire_date = KeySettings.Key(inputKey)
					if success_key then
						valid = true
						if expire_date then
							Window.Expire = expire_date
						end
					end
				end
				
				if valid then
					if KeySettings.SaveKey then
						writefile(KeySettings.FileName..".key", inputKey)
					end
					
					verified = true
					
					GumballZ:CreateAnimation(MainFrame, 0.5, {Size = UDim2.new(0,0,0,0), Transparency = 1})
					task.wait(0.2)
					KeySystemGui:Destroy()
					
					Gum.Notifier:Notify({
						Title = "Key System",
						Content = "Key Valid! Loading UI...",
						Icon = "check",
						Duration = 3,
					})
				else
					Gum.Notifier:Notify({
						Title = "Key System",
						Content = "Invalid Key!",
						Icon = "x",
						Duration = 3,
					})
					KeyInput.Text = ""
				end
			end
			
			CheckKeyButton.MouseButton1Click:Connect(VerifyKey)
			
			GetKeyButton.MouseButton1Click:Connect(function()
				setclipboard(KeySettings.URL or "")
				Gum.Notifier:Notify({
					Title = "Key System",
					Content = "Link saved to clipboard!",
					Icon = "link",
					Duration = 3,
				})
			end)
			
			repeat task.wait() until verified
		end
	end

	local GumballZwin = Instance.new("ScreenGui")
	local GumFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local DropShadow = Instance.new("ImageLabel")
	local Header = Instance.new("Frame")
	local HeaderLine = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local HeaderText = Instance.new("TextLabel")
	local MenuButtonCont = Instance.new("Frame")
	local tbc = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local UserProfle = Instance.new("Frame")
	local UserIcon = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local User_name = Instance.new("TextLabel")
	local expire_days = Instance.new("TextLabel")
	local HeaderLineShadow = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local MenuFrame = Instance.new("Frame")
	local Bottom = Instance.new("Frame")
	local HeaderLine_2 = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local HeaderLineShadow_2 = Instance.new("Frame")
	local UIGradient_2 = Instance.new("UIGradient")
	local UICorner_6 = Instance.new("UICorner")
	local InfoButton = Instance.new("ImageButton")
	local SearchButton = Instance.new("ImageButton")
	local SaveButton = Instance.new("ImageButton")
	local CloseButton = Instance.new("ImageButton")
	local MinimizeButton = Instance.new("ImageButton")

	GumballZ.WindowFlags[GumballZwin] = {};

	GumballZ:ScrollSignal(tbc,UIListLayout,'X');

	GumFrame:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
		if GumFrame.BackgroundTransparency >= 0.99 then
			GumballZwin.Enabled = false;
		else
			GumballZwin.Enabled = true;
		end;
	end);

	local ToggleUI = function(bool)
		Gum.Signal:Fire(bool);

		if bool then
			for i,v in next , Gum.Menus do
				v.ValueSelect(false);
			end;

			if Gum.MenuSelected then
				Gum.MenuSelected.ValueSelect(true)
			end

			GumFrame.Size = UDim2.new(0,0,0,0)
			GumballZ:CreateAnimation(GumFrame,0.5,Enum.EasingStyle.Quart,{
				Size = Window.Scale,
				BackgroundTransparency = 0,
			})

			GumballZ:CreateAnimation(Header,0.5,{
				BackgroundTransparency = 0,
			})

			GumballZ:CreateAnimation(HeaderLine,0.5,{
				BackgroundTransparency = 0,
			})

			GumballZ:CreateAnimation(Bottom,0.5,{
				BackgroundTransparency = 0,
			})

			GumballZ:CreateAnimation(HeaderLine_2,0.5,{
				BackgroundTransparency = 0,
			})

			GumballZ:CreateAnimation(HeaderLineShadow,0.5,{
				BackgroundTransparency = 0.5,
			})

			GumballZ:CreateAnimation(HeaderLineShadow_2,0.5,{
				BackgroundTransparency = 0.5,
			})

			GumballZ:CreateAnimation(InfoButton,0.25,{
				ImageTransparency = 0.5
			})

			GumballZ:CreateAnimation(SearchButton,0.25,{
				ImageTransparency = 0.5
			})

			GumballZ:CreateAnimation(SaveButton,0.25,{
				ImageTransparency = 0.5
			})

			GumballZ:CreateAnimation(CloseButton,0.25,{
				ImageTransparency = 0.5
			})

			GumballZ:CreateAnimation(MinimizeButton,0.25,{
				ImageTransparency = 0.5
			})

			GumballZ:CreateAnimation(HeaderText,0.35,{
				TextStrokeTransparency = 0.640,
				TextTransparency = 0
			})

			GumballZ:CreateAnimation(UserIcon,0.45,{
				ImageTransparency = 0,
				Position = UDim2.new(1, -10,0.5, 0)
			})

			GumballZ:CreateAnimation(User_name,0.35,{
				TextTransparency = 0,
				Position = UDim2.new(1, -40,0, 5)
			})

			GumballZ:CreateAnimation(expire_days,0.5,{
				TextTransparency = 0,
				Position = UDim2.new(1, -40,0, 20)
			})

			GumballZ:CreateAnimation(UIStroke,0.35,{
				Thickness = 2.500,
				Transparency = 0.900
			})

			GumballZ:CreateAnimation(InfoButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(1, -5,0.5, 0)
			})

			GumballZ:CreateAnimation(SearchButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(0,10,0.5, 0)
			})

			GumballZ:CreateAnimation(SaveButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(0,35,0.5, 0)
			})

			GumballZ:CreateAnimation(CloseButton,0.25,{
				ImageTransparency = 0.5
			})

			GumballZ:CreateAnimation(MinimizeButton,0.25,{
				ImageTransparency = 0.5
			})

			GumballZ:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 0.75
			})
		else
			table.clear(GumballZ.DragBlacklist);

			for i,v in next , Gum.Menus do
				v.ValueSelect(false);
			end;

			GumballZ:CreateAnimation(SaveButton,0.35,{
				Position = UDim2.new(0,35,1, 20)
			})

			GumballZ:CreateAnimation(SearchButton,0.35,{
				Position = UDim2.new(0,10,1, 20)
			})

			GumballZ:CreateAnimation(InfoButton,0.35,{
				Position = UDim2.new(1, -5,1, 20)
			})

			GumballZ:CreateAnimation(UIStroke,0.35,{
				Thickness = 0,
				Transparency = 1
			})

			GumballZ:CreateAnimation(UserIcon,0.35,{
				ImageTransparency = 1,
				Position = UDim2.new(1, -10,0.5, 0)
			})

			GumballZ:CreateAnimation(User_name,0.35,{
				TextTransparency = 1,
				Position = UDim2.new(1, -40,0, 5)
			})

			GumballZ:CreateAnimation(expire_days,0.1,{
				TextTransparency = 1,
				Position = UDim2.new(1, -40,0, 20)
			})

			GumballZ:CreateAnimation(HeaderText,0.35,{
				TextStrokeTransparency = 1,
				TextTransparency = 1
			})

			GumballZ:CreateAnimation(HeaderLineShadow_2,0.5,{
				BackgroundTransparency = 1,
			})

			GumballZ:CreateAnimation(InfoButton,0.35,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(SearchButton,0.35,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(SaveButton,0.35,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(CloseButton,0.35,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(MinimizeButton,0.35,{
				ImageTransparency = 1
			})

			GumballZ:CreateAnimation(HeaderLineShadow,0.5,{
				BackgroundTransparency = 1,
			})

			GumballZ:CreateAnimation(GumFrame,0.5,Enum.EasingStyle.Quart,{
				Size = UDim2.new(0,0,0,0),
				BackgroundTransparency = 1,
			})

			GumballZ:CreateAnimation(Header,0.35,{
				BackgroundTransparency = 1,
			})

			GumballZ:CreateAnimation(HeaderLine,0.35,{
				BackgroundTransparency = 1,
			})

			GumballZ:CreateAnimation(Bottom,0.35,{
				BackgroundTransparency = 1,
			})

			GumballZ:CreateAnimation(HeaderLine_2,0.35,{
				BackgroundTransparency = 1,
			})

			GumballZ:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 1
			})
		end
	end

	GumballZwin.Name = GumballZ:RandomString();
	GumballZwin.Parent = CoreGui;
	GumballZwin.ResetOnSpawn = false;
	GumballZwin.IgnoreGuiInset = true;
	GumballZwin.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	table.insert(GumballZ.Windows,GumballZwin)

	protect_gui(GumballZwin);

	GumFrame.Active = true;
	GumFrame.Name = GumballZ:RandomString()
	GumFrame.Parent = GumballZwin
	GumFrame.AnchorPoint = Vector2.new(0.5, 0)
	GumFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	GumFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GumFrame.BorderSizePixel = 0
	GumFrame.Position = UDim2.new(0.5, 0, 0.2);
	GumFrame.Size = Window.Scale;
	GumFrame.ClipsDescendants = true

	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = GumFrame

	DropShadow.Name = GumballZ:RandomString()
	DropShadow.Parent = GumFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = -1
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 1
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.Rotation = 0.001

	Header.Name = GumballZ:RandomString()
	Header.Parent = GumFrame
	Header.Active = true
	Header.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0, 0, 85)
	Header.ZIndex = 2

	HeaderLine.Name = GumballZ:RandomString()
	HeaderLine.Parent = Header
	HeaderLine.AnchorPoint = Vector2.new(0, 1)
	HeaderLine.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	HeaderLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine.BorderSizePixel = 0
	HeaderLine.Position = UDim2.new(0, 0, 1, 0)
	HeaderLine.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine.ZIndex = 3

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = Header

	HeaderText.Name = GumballZ:RandomString()
	HeaderText.Parent = Header
	HeaderText.AnchorPoint = Vector2.new(0, 0.5)
	HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderText.BackgroundTransparency = 1.000
	HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderText.BorderSizePixel = 0
	HeaderText.Position = UDim2.new(0, 15, 0, 22)
	HeaderText.Size = UDim2.new(0, 100, 0, 20)
	HeaderText.ZIndex = 4
	HeaderText.Font = Enum.Font.GothamBold
	HeaderText.Text = Window.Name
	HeaderText.TextColor3 = Color3.fromRGB(229, 229, 229)
	HeaderText.TextSize = 21.000
	HeaderText.TextStrokeColor3 = Color3.fromRGB(205, 67, 218)
	HeaderText.TextStrokeTransparency = 0.640

	MenuButtonCont.Name = GumballZ:RandomString()
	MenuButtonCont.Parent = Header
	MenuButtonCont.AnchorPoint = Vector2.new(0, 0)
	MenuButtonCont.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuButtonCont.BackgroundTransparency = 1.000
	MenuButtonCont.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuButtonCont.BorderSizePixel = 0
	MenuButtonCont.ClipsDescendants = true
	MenuButtonCont.Position = UDim2.new(0, 10, 0, 48)
	MenuButtonCont.Size = UDim2.new(1, -20, 0, 35)
	MenuButtonCont.ZIndex = 4

	tbc.Name = GumballZ:RandomString()
	tbc.Parent = MenuButtonCont
	tbc.Active = true
	tbc.AnchorPoint = Vector2.new(0.5, 0.5)
	tbc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tbc.BackgroundTransparency = 1.000
	tbc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tbc.BorderSizePixel = 0
	tbc.ClipsDescendants = false
	tbc.Position = UDim2.new(0.5, 0, 0.5, 0)
	tbc.Size = UDim2.new(1, -2, 1, 0)
	tbc.ZIndex = 4
	tbc.CanvasSize = UDim2.new(2, 0, 0, 0)
	tbc.ScrollBarThickness = 0

	UIListLayout.Parent = tbc
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 4)

	UserProfle.Name = GumballZ:RandomString()
	UserProfle.Parent = Header
	UserProfle.AnchorPoint = Vector2.new(1, 0.5)
	UserProfle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserProfle.BackgroundTransparency = 1.000
	UserProfle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserProfle.BorderSizePixel = 0
	UserProfle.Position = UDim2.new(1, -80, 0, 22)
	UserProfle.Size = UDim2.new(0, 150, 0, 40)
	UserProfle.ZIndex = 4

	UserIcon.Name = GumballZ:RandomString()
	UserIcon.Parent = UserProfle
	UserIcon.AnchorPoint = Vector2.new(1, 0.5)
	UserIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserIcon.BackgroundTransparency = 1.000
	UserIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserIcon.BorderSizePixel = 0
	UserIcon.Position = UDim2.new(1, -10, 0.5, 0)
	UserIcon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
	UserIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
	UserIcon.ZIndex = 5
	UserIcon.Image = Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180);

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = UserIcon

	UIStroke.Thickness = 2.500
	UIStroke.Transparency = 0.900
	UIStroke.Parent = UserIcon

	User_name.Name = GumballZ:RandomString()
	User_name.Parent = UserProfle
	User_name.AnchorPoint = Vector2.new(1, 0)
	User_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	User_name.BackgroundTransparency = 1.000
	User_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
	User_name.BorderSizePixel = 0
	User_name.Position = UDim2.new(1, -40, 0, 5)
	User_name.Size = UDim2.new(0, 200, 0, 15)
	User_name.ZIndex = 4
	User_name.Font = Enum.Font.GothamMedium
	User_name.Text = Client.DisplayName;
	User_name.TextColor3 = Color3.fromRGB(255, 255, 255)
	User_name.TextSize = 13.000
	User_name.TextStrokeTransparency = 0.700
	User_name.TextXAlignment = Enum.TextXAlignment.Right

	expire_days.Name = GumballZ:RandomString()
	expire_days.Parent = UserProfle
	expire_days.AnchorPoint = Vector2.new(1, 0)
	expire_days.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	expire_days.BackgroundTransparency = 1.000
	expire_days.BorderColor3 = Color3.fromRGB(0, 0, 0)
	expire_days.BorderSizePixel = 0
	expire_days.Position = UDim2.new(1, -40, 0, 20)
	expire_days.Size = UDim2.new(0, 200, 0, 15)
	expire_days.ZIndex = 4
	expire_days.Font = Enum.Font.GothamMedium
	expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#f53174\">%s</font>",Window.Expire)
	expire_days.TextColor3 = Color3.fromRGB(255, 255, 255)
	expire_days.TextSize = 12.000
	expire_days.TextStrokeTransparency = 0.700
	expire_days.TextXAlignment = Enum.TextXAlignment.Right
	expire_days.RichText = true;

	CloseButton.Name = GumballZ:RandomString()
	CloseButton.Parent = Header
	CloseButton.AnchorPoint = Vector2.new(1, 0.5)
	CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.BackgroundTransparency = 1.000
	CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, -10, 0, 22)
	CloseButton.Size = UDim2.new(0, 20, 0, 20)
	CloseButton.ZIndex = 4
	CloseButton.Image = GumballZ:GetIcon("log-out")
	CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.ImageTransparency = 0.5

	CloseButton.MouseEnter:Connect(function()
		GumballZ:CreateAnimation(CloseButton,0.25,{
			ImageTransparency = 0.2
		})
	end)

	CloseButton.MouseLeave:Connect(function()
		GumballZ:CreateAnimation(CloseButton,0.25,{
			ImageTransparency = 0.5
		})
	end)

	CloseButton.MouseButton1Click:Connect(function()
		local ConfirmFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ConfirmText = Instance.new("TextLabel")
		local YesButton = Instance.new("TextButton")
		local NoButton = Instance.new("TextButton")
		local YesCorner = Instance.new("UICorner")
		local NoCorner = Instance.new("UICorner")

		ConfirmFrame.Name = "ConfirmFrame"
		ConfirmFrame.Parent = GumballZwin
		ConfirmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ConfirmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		ConfirmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		ConfirmFrame.Size = UDim2.new(0, 0, 0, 0) -- Start small
		ConfirmFrame.Transparency = 1
		ConfirmFrame.ZIndex = 110

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = ConfirmFrame

		UIStroke.Color = Color3.fromRGB(40, 40, 40)
		UIStroke.Parent = ConfirmFrame

		ConfirmText.Parent = ConfirmFrame
		ConfirmText.BackgroundTransparency = 1
		ConfirmText.Position = UDim2.new(0.5, 0, 0.2, 0)
		ConfirmText.Size = UDim2.new(1, 0, 0.3, 0)
		ConfirmText.AnchorPoint = Vector2.new(0.5,0)
		ConfirmText.Font = Enum.Font.GothamBold
		ConfirmText.Text = "close menu?"
		ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ConfirmText.TextSize = 16
		ConfirmText.TextTransparency = 1
		ConfirmText.ZIndex = 111

		YesButton.Parent = ConfirmFrame
		YesButton.BackgroundColor3 = GumballZ.Colors.Main
		YesButton.Position = UDim2.new(0.1, 0, 0.6, 0)
		YesButton.Size = UDim2.new(0.35, 0, 0.3, 0)
		YesButton.Font = Enum.Font.GothamMedium
		YesButton.Text = "yes"
		YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		YesButton.TextSize = 14
		YesButton.BackgroundTransparency = 1
		YesButton.TextTransparency = 1
		YesButton.ZIndex = 111

		YesCorner.CornerRadius = UDim.new(0, 4)
		YesCorner.Parent = YesButton

		NoButton.Parent = ConfirmFrame
		NoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		NoButton.Position = UDim2.new(0.55, 0, 0.6, 0)
		NoButton.Size = UDim2.new(0.35, 0, 0.3, 0)
		NoButton.Font = Enum.Font.GothamMedium
		NoButton.Text = "no"
		NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		NoButton.TextSize = 14
		NoButton.BackgroundTransparency = 1
		NoButton.TextTransparency = 1
		NoButton.ZIndex = 111

		NoCorner.CornerRadius = UDim.new(0, 4)
		NoCorner.Parent = NoButton

		-- Animation In
		GumballZ:CreateAnimation(ConfirmFrame, 0.3, Enum.EasingStyle.Back, {
			Size = UDim2.new(0, 200, 0, 100),
			Transparency = 0
		})
		
		task.wait(0.1)
		GumballZ:CreateAnimation(ConfirmText, 0.3, {TextTransparency = 0})
		GumballZ:CreateAnimation(YesButton, 0.3, {BackgroundTransparency = 0, TextTransparency = 0})
		GumballZ:CreateAnimation(NoButton, 0.3, {BackgroundTransparency = 0, TextTransparency = 0})

		YesButton.MouseButton1Click:Connect(function()
			GumballZwin:Destroy()
		end)

		NoButton.MouseButton1Click:Connect(function()
			-- Animation Out
			GumballZ:CreateAnimation(ConfirmText, 0.2, {TextTransparency = 1})
			GumballZ:CreateAnimation(YesButton, 0.2, {BackgroundTransparency = 1, TextTransparency = 1})
			GumballZ:CreateAnimation(NoButton, 0.2, {BackgroundTransparency = 1, TextTransparency = 1})
			GumballZ:CreateAnimation(ConfirmFrame, 0.3, Enum.EasingStyle.Quad, {
				Size = UDim2.new(0, 0, 0, 0),
				Transparency = 1
			})
			task.wait(0.3)
			ConfirmFrame:Destroy()
		end)
	end)

	MinimizeButton.Name = GumballZ:RandomString()
	MinimizeButton.Parent = Header
	MinimizeButton.AnchorPoint = Vector2.new(1, 0.5)
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.BackgroundTransparency = 1.000
	MinimizeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Position = UDim2.new(1, -40, 0, 22)
	MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
	MinimizeButton.ZIndex = 4
	MinimizeButton.Image = GumballZ:GetIcon("minus")
	MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.ImageTransparency = 0.5

	MinimizeButton.MouseEnter:Connect(function()
		GumballZ:CreateAnimation(MinimizeButton,0.25,{
			ImageTransparency = 0.2
		})
	end)

	MinimizeButton.MouseLeave:Connect(function()
		GumballZ:CreateAnimation(MinimizeButton,0.25,{
			ImageTransparency = 0.5
		})
	end)
	
	local isMinimized = false
	MinimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			GumballZ:CreateAnimation(GumFrame, 0.5, Enum.EasingStyle.Quart, {
				Size = UDim2.new(0, Window.Scale.X.Offset, 0, 85)
			})
			MenuFrame.Visible = false
			Bottom.Visible = false
			-- UserProfle.Visible = false -- Optionally hide this if you want
		else
			GumballZ:CreateAnimation(GumFrame, 0.5, Enum.EasingStyle.Quart, {
				Size = Window.Scale
			})
			task.wait(0.2)
			MenuFrame.Visible = true
			Bottom.Visible = true
			-- UserProfle.Visible = true
		end
	end)

	HeaderLineShadow.Name = GumballZ:RandomString()
	HeaderLineShadow.Parent = Header
	HeaderLineShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderSizePixel = 0
	HeaderLineShadow.Size = UDim2.new(1, 0, 1, 10)

	UIGradient.Rotation = 90
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient.Parent = HeaderLineShadow

	UICorner_4.CornerRadius = UDim.new(0, 5)
	UICorner_4.Parent = HeaderLineShadow

	MenuFrame.Name = GumballZ:RandomString()
	MenuFrame.Parent = GumFrame
	MenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuFrame.BackgroundTransparency = 1.000
	MenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuFrame.BorderSizePixel = 0
	MenuFrame.Position = UDim2.new(0, 0, 0, 90)
	MenuFrame.Size = UDim2.new(1, 0, 1, -120)

	Bottom.Name = GumballZ:RandomString()
	Bottom.Parent = GumFrame
	Bottom.Active = true
	Bottom.AnchorPoint = Vector2.new(0, 1)
	Bottom.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Bottom.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Bottom.BorderSizePixel = 0
	Bottom.Position = UDim2.new(0, 0, 1, 0)
	Bottom.Size = UDim2.new(1, 0, 0, 25)
	Bottom.ZIndex = 2

	HeaderLine_2.Name = GumballZ:RandomString()
	HeaderLine_2.Parent = Bottom
	HeaderLine_2.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	HeaderLine_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine_2.BorderSizePixel = 0
	HeaderLine_2.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine_2.ZIndex = 3

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = Bottom

	HeaderLineShadow_2.Name = GumballZ:RandomString()
	HeaderLineShadow_2.Parent = Bottom
	HeaderLineShadow_2.AnchorPoint = Vector2.new(0, 1)
	HeaderLineShadow_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BackgroundTransparency = 0.500
	HeaderLineShadow_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BorderSizePixel = 0
	HeaderLineShadow_2.Position = UDim2.new(0, 0, 1, 0)
	HeaderLineShadow_2.Size = UDim2.new(1, 0, 1, 5)

	UIGradient_2.Rotation = -90
	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient_2.Parent = HeaderLineShadow_2

	UICorner_6.CornerRadius = UDim.new(0, 5)
	UICorner_6.Parent = HeaderLineShadow_2

	GumballZ:Drag(GumFrame,GumFrame,0.1);

	UserInputService.InputBegan:Connect(function(input,istyping)
		if not istyping then
			if input.KeyCode == Window.Keybind or input.KeyCode.Name == Window.Keybind then
				Gum.Toggle = not Gum.Toggle;

				ToggleUI(Gum.Toggle);
			end;
		end
	end)

	function Gum:SetUsername(name: string)
		User_name.Text = name or Client.DisplayName;
	end;

	function Gum:SetProfile(icon: string)
		UserIcon.Image = icon or Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180);
	end;

	function Gum:SetExpire(str: string)
		expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#f53174\">%s</font>",str)
	end;

	function Gum:GetFlags()
		return GumballZ.WindowFlags[GumballZwin];
	end;

	function Gum:AddConfig()
		local ConfigButton = Instance.new("ImageButton")

		ConfigButton.Name = "ConfigButton"
		ConfigButton.Parent = Bottom;
		ConfigButton.AnchorPoint = Vector2.new(0, 0.5)
		ConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ConfigButton.BackgroundTransparency = 1.000
		ConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigButton.BorderSizePixel = 0
		ConfigButton.Position = UDim2.new(0, 57, 0.5, 0)
		ConfigButton.Size = UDim2.new(0, 16, 0, 16)
		ConfigButton.ZIndex = 4
		ConfigButton.Image = "rbxassetid://10723387721"
		ConfigButton.ImageTransparency = 0.500;

		GumballZ:CreateHover(ConfigButton,function(bool)
			if bool then
				GumballZ:CreateAnimation(ConfigButton,0.3,{
					ImageTransparency = 0.2500;
				})
			else
				GumballZ:CreateAnimation(ConfigButton,0.3,{
					ImageTransparency = 0.500;
				})
			end;
		end);

		return GumballZ:CreateConfigWindow(GumballZwin,Gum,ConfigButton);
	end;

	function Gum:LoadConfig(config)

		for i,v in next , config do
			if i ~= "Info" then
				local Element = GumballZ.WindowFlags[GumballZwin][i];

				if Element then

					local Value = v.Value;
					local MainValue;

					task.spawn(function()
						if Value.Type == "String" then
							Element:SetValue(tostring(Value.Value));
						elseif Value.Type == "Boolean" then
							Element:SetValue((typeof(Value.Value) == 'boolean' and Value.Value) or (Value.Value == "true" and true or false));
						elseif Value.Type == "Number" then
							Element:SetValue(Value.Value);
						elseif Value.Type == "Color3" then
							Element:SetValue(Color3.new(Value.Value.R,Value.Value.G,Value.Value.B) , Value.Value.Transparency);
						elseif Value.Type == "Table" then
							Element:SetValue(Value.Value);

						end;
					end);
				end;

			end;
		end;
	end;

	function Gum:GetFlagConfig()
		local Flags = Gum:GetFlags();

		local ConfigElement = {};

		for i,v in next , Flags do
			local ValueData = {};
			local Value = v:GetValue();

			if typeof(Value) == "string" then
				ValueData.Type = "String";
				ValueData.Value = Value;
			elseif typeof(Value) == "boolean" then
				ValueData.Type = "Boolean";
				ValueData.Value = Value;
			elseif typeof(Value) == "number" then
				ValueData.Type = "Number";
				ValueData.Value = Value;
			elseif typeof(Value) == "Color3" then
				ValueData.Type = "Color3";

				local Color = Value.Color;
				local Transparency = Value.Transparency;

				ValueData.Value = {
					R = Color.R,
					G = Color.G,
					B = Color.B,

					Transparency = Transparency
				};
			elseif typeof(Value) == "table" then
				if Value.Color and Value.Transparency then
					ValueData.Type = "Color3";

					local Color = Value.Color;
					local Transparency = Value.Transparency;

					ValueData.Value = {
						R = Color.R,
						G = Color.G,
						B = Color.B,

						Transparency = Transparency
					};
				else
					ValueData.Type = "Table";
					ValueData.Value = Value;
				end;
			else
				ValueData.Type = "Unknow";
				ValueData.Value = nil;
			end;

			rawset(ConfigElement,i,{
				FlagId = v.Flag,
				Value = ValueData,
			})
		end;

		return ConfigElement;
	end;

	function Gum:AddMenu(Menu : Menu)
		Menu = Menu or {};
		Menu.Name = Menu.Name or "EXAMPLE";
		Menu.Icon = Menu.Icon or "eye";
		Menu.AutoFill = (Menu.AutoFill == nil and true) or false;

		local MenuLib = {};
		local MenuButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Icon = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local menu_name = Instance.new("TextLabel")

		MenuButton.Name = GumballZ:RandomString()
		MenuButton.Parent = tbc;
		MenuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		MenuButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuButton.BorderSizePixel = 0
		MenuButton.Size = UDim2.new(0, 90, 0.85, 0)
		MenuButton.ZIndex = 5

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = MenuButton

		UIStroke.Transparency = 0.950
		UIStroke.Parent = MenuButton

		Icon.Name = GumballZ:RandomString()
		Icon.Parent = MenuButton
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 5, 0.5, 0)
		Icon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Icon.ZIndex = 5
		Icon.Image = GumballZ:GetIcon(Menu.Icon);
		Icon.ImageColor3 = GumballZ.Colors.Main
		Icon.ScaleType = Enum.ScaleType.Crop

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Icon

		menu_name.Name = GumballZ:RandomString()
		menu_name.Parent = MenuButton
		menu_name.AnchorPoint = Vector2.new(0, 0.5)
		menu_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		menu_name.BackgroundTransparency = 1.000
		menu_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		menu_name.BorderSizePixel = 0
		menu_name.Position = UDim2.new(0, 28, 0.5, 0)
		menu_name.Size = UDim2.new(1, 0, 1, 0)
		menu_name.ZIndex = 5
		menu_name.Font = Enum.Font.GothamBold
		menu_name.Text = Menu.Name
		menu_name.TextColor3 = Color3.fromRGB(255, 255, 255)
		menu_name.TextSize = 13.000
		menu_name.TextStrokeTransparency = 0.900
		menu_name.TextTransparency = 0.150
		menu_name.TextXAlignment = Enum.TextXAlignment.Left

		local text_size = GumballZ:GetTextSize(menu_name);

		MenuButton.Size = UDim2.new(0, text_size.X + 33, 0.85, 0)

		local MenuLiber = Instance.new("Frame")
		local Left = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local Center = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local Right = Instance.new("ScrollingFrame")
		local UIListLayout_3 = Instance.new("UIListLayout")

		MenuLiber.Name = GumballZ:RandomString()
		MenuLiber.Parent = MenuFrame
		MenuLiber.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MenuLiber.BackgroundTransparency = 1.000
		MenuLiber.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuLiber.BorderSizePixel = 0
		MenuLiber.ClipsDescendants = true
		MenuLiber.Size = UDim2.new(1, 0, 1, 0)
		MenuLiber.ZIndex = 7

		Left.Name = GumballZ:RandomString()
		Left.Parent = MenuLiber
		Left.Active = true
		Left.AnchorPoint = Vector2.new(0.5, 0.5)
		Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Left.BackgroundTransparency = 1.000
		Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Left.BorderSizePixel = 0
		Left.ClipsDescendants = false
		Left.Position = UDim2.new(0.175, 0, 0.5, 0)
		Left.Size = UDim2.new(0.32, 0, 1, -5)
		Left.ScrollBarThickness = 0

		UIListLayout.Parent = Left
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		Center.Name = GumballZ:RandomString()
		Center.Parent = MenuLiber
		Center.Active = true
		Center.AnchorPoint = Vector2.new(0.5, 0.5)
		Center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Center.BackgroundTransparency = 1.000
		Center.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Center.BorderSizePixel = 0
		Center.ClipsDescendants = false
		Center.Position = UDim2.new(0.5, 0, 0.5, 0)
		Center.Size = UDim2.new(0.32, 0, 1, -5)
		Center.ScrollBarThickness = 0

		UIListLayout_2.Parent = Center
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)
		UIListLayout_2.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		Right.Name = GumballZ:RandomString()
		Right.Parent = MenuLiber
		Right.Active = true
		Right.AnchorPoint = Vector2.new(0.5, 0.5)
		Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Right.BackgroundTransparency = 1.000
		Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Right.BorderSizePixel = 0
		Right.ClipsDescendants = false
		Right.Position = UDim2.new(0.825, 0, 0.5, 0)
		Right.Size = UDim2.new(0.32, 0, 1, -5)
		Right.ScrollBarThickness = 0

		UIListLayout_3.Parent = Right
		UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 5)
		UIListLayout_3.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		local BindEvent = Instance.new('BindableEvent',MenuLiber);
		BindEvent.Name = GumballZ:RandomString();

		if not Menu.AutoFill then
			GumballZ:ScrollSignal(Right,UIListLayout_3,'Y');
			GumballZ:ScrollSignal(Center,UIListLayout_2,'Y');
			GumballZ:ScrollSignal(Left,UIListLayout,'Y');
		else
			Right.CanvasSize = UDim2.new(0,0,0,0);
			Left.CanvasSize = UDim2.new(0,0,0,0);
			Center.CanvasSize = UDim2.new(0,0,0,0);
		end;

		Gum.Signal.Event:Connect(function(Bool)
			if Bool then
				GumballZ:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = (MenuLiber.Visible and 0) or 1
				})

				GumballZ:CreateAnimation(UIStroke,0.5,{
					Transparency = 0.950
				})

				GumballZ:CreateAnimation(Left,0.3,{
					Position = UDim2.new(0.175, 0, 0.5, 0)
				})

				GumballZ:CreateAnimation(Center,0.4,{
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})

				GumballZ:CreateAnimation(Right,0.5,{
					Position = UDim2.new(0.825, 0, 0.5, 0)
				})

				GumballZ:CreateAnimation(Icon,0.5,{
					ImageTransparency = (MenuLiber.Visible and 0.15) or 0.5
				})

				GumballZ:CreateAnimation(menu_name,0.5,{
					TextStrokeTransparency = 0.900,
					TextTransparency = (MenuLiber.Visible and 0.15) or 0.5
				})
			else
				GumballZ:CreateAnimation(Left,0.5,{
					Position = UDim2.new(0.175, 0, 0.5, 1)
				})

				GumballZ:CreateAnimation(Center,0.5,{
					Position = UDim2.new(0.5, 0, 0.5, 2)
				})

				GumballZ:CreateAnimation(Right,0.5,{
					Position = UDim2.new(0.825, 0, 0.5, 3)
				})

				GumballZ:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 1
				})

				GumballZ:CreateAnimation(UIStroke,0.5,{
					Transparency = 1
				})

				GumballZ:CreateAnimation(Icon,0.5,{
					ImageTransparency = 1
				})

				GumballZ:CreateAnimation(menu_name,0.5,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})
			end;
		end)

		local ValueSelect = function(val)
			if val then
				MenuLiber.Visible = true;

				GumballZ:CreateAnimation(Icon,0.5,{
					ImageTransparency = 0.15,
					ImageColor3 = GumballZ.Colors.Main
				});

				GumballZ:CreateAnimation(menu_name,0.5,{
					TextTransparency = 0.15
				});

				GumballZ:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 0
				})

				BindEvent:SetAttribute('V',true);
				BindEvent:Fire(true);
			else
				BindEvent:SetAttribute('V',false);
				BindEvent:Fire(false);

				MenuLiber.Visible = false;

				GumballZ:CreateAnimation(Icon,0.5,{
					ImageTransparency = 0.5,
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				});

				GumballZ:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 1
				})

				GumballZ:CreateAnimation(menu_name,0.5,{
					TextTransparency = 0.5
				});
			end;
		end;

		local _B = {
			Root = MenuLiber,
			ValueSelect = ValueSelect,
			Bindable = BindEvent,
		};

		if not Gum.MenuSelected then
			Gum.MenuSelected = _B;

			ValueSelect(true);
		else
			ValueSelect(false);
		end;

		table.insert(Gum.Menus,_B)

		GumballZ:CreateHover(MenuButton,function(bool)
			if Gum.MenuSelected.Root ~= MenuLiber then
				if bool then
					GumballZ:CreateAnimation(Icon,0.5,{
						ImageTransparency = 0.2,
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					});

					GumballZ:CreateAnimation(MenuButton,0.5,{
						BackgroundTransparency = 1
					})

					GumballZ:CreateAnimation(menu_name,0.5,{
						TextTransparency = 0.2
					});
				else
					GumballZ:CreateAnimation(Icon,0.5,{
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					});

					GumballZ:CreateAnimation(MenuButton,0.5,{
						BackgroundTransparency = 1
					})

					GumballZ:CreateAnimation(menu_name,0.5,{
						TextTransparency = 0.5
					});
				end
			end;
		end)

		GumballZ:NewInput(MenuButton,function()
			for i,v in next , Gum.Menus do
				if v.Root == MenuLiber then
					Gum.MenuSelected = v;

					v.ValueSelect(true)
				else
					v.ValueSelect(false)
				end;
			end;
		end);
		
		function MenuLib:AddPreview(Config: Preview)
			Config = Config or {};
			Config.Name = Config.Name or "PREVIEW";
			Config.Position = Config.Position or "left";
			Config.Height = Config.Height or 0;
			
			local Preview = Instance.new("Frame")
			local PreviewName = Instance.new("TextLabel")
			local Main = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local MainBlock = Instance.new("Frame")

			Preview.Name = "Preview"
			Preview.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Preview.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			Preview.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Preview.BorderSizePixel = 0
			Preview.ClipsDescendants = true
			Preview.ZIndex = 15;
			Preview.Size = UDim2.new(1, 0, 0, 25 + Config.Height)
	
			PreviewName.Name = "PreviewName"
			PreviewName.Parent = Preview
			PreviewName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PreviewName.BackgroundTransparency = 1.000
			PreviewName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PreviewName.BorderSizePixel = 0
			PreviewName.Position = UDim2.new(0, 10, 0, 0)
			PreviewName.Size = UDim2.new(1, 0, 0, 15)
			PreviewName.ZIndex = 19
			PreviewName.FontFace = GumballZ.FontSemiBold
			PreviewName.Text = Config.Name
			PreviewName.TextColor3 = Color3.fromRGB(255, 255, 255)
			PreviewName.TextSize = 15.000
			PreviewName.TextStrokeTransparency = 0.750
			PreviewName.TextXAlignment = Enum.TextXAlignment.Left

			Main.Name = "Main"
			Main.Parent = Preview
			Main.AnchorPoint = Vector2.new(0.5, 1)
			Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Main.BorderSizePixel = 0
			Main.Position = UDim2.new(0.5, 0, 1, -1)
			Main.Size = UDim2.new(1, -5, 1, -10)
			Main.ZIndex = 17

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Main

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Main

			MainBlock.Name = "MainBlock"
			MainBlock.Parent = Main
			MainBlock.AnchorPoint = Vector2.new(0.5, 0.5)
			MainBlock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainBlock.BackgroundTransparency = 1.000
			MainBlock.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainBlock.BorderSizePixel = 0
			MainBlock.Position = UDim2.new(0.5, 0, 0.5, 0)
			MainBlock.Size = UDim2.new(1, -5, 1, -5)
			MainBlock.ZIndex = 18
			
			local Toggle = function(v)
				if v then
					GumballZ:CreateAnimation(Preview,0.5,{
						BackgroundTransparency = 0
					})

					GumballZ:CreateAnimation(PreviewName,0.5,{
						TextStrokeTransparency = 0.750,
						TextTransparency = 0
					})
					
					GumballZ:CreateAnimation(Main,0.5,{
						BackgroundTransparency = 0
					})
					
					GumballZ:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})
					
					GumballZ:CreateAnimation(MainBlock,0.5,{
						Size = UDim2.new(1, -5, 1, -5)
					})
				else
					GumballZ:CreateAnimation(Preview,0.5,{
						BackgroundTransparency = 1
					})

					GumballZ:CreateAnimation(PreviewName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})

					GumballZ:CreateAnimation(Main,0.5,{
						BackgroundTransparency = 1
					})

					GumballZ:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					GumballZ:CreateAnimation(MainBlock,0.5,{
						Size = UDim2.new(0,0,0,0)
					})
				end
			end;

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);
			
			return MainBlock;
		end;

		function MenuLib:AddListBox(Config : Listbox)
			Config = Config or {};
			Config.Name = Config.Name or "LIST BOX";
			Config.Position = Config.Position or "left";
			Config.Height = Config.Height or 0;
			Config.Values = Config.Values or {};
			Config.Multi = Config.Multi or false;
			Config.Default = Config.Default or ((Config.Multi and nil) or {});
			Config.Callback = Config.Callback or function() end;

			table.insert(Gum.ElementContents,{
				Name = Config.Name,
				Path = Menu.Name .. " > ".. Config.Name,
				_TAB = _B
			});

			local ListBox = Instance.new("Frame")
			local Elements = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local SearchBox = Instance.new("Frame")
			local TextBox = Instance.new("TextBox")
			local UICorner_2 = Instance.new("UICorner")
			local UIStroke_2 = Instance.new("UIStroke")
			local OptionButton = Instance.new("ImageButton")
			local ScrollingFrame = Instance.new("ScrollingFrame")
			local UICorner_3 = Instance.new("UICorner")
			local UIStroke_3 = Instance.new("UIStroke")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local ListName = Instance.new("TextLabel")

			ListBox.Name = GumballZ:RandomString()
			ListBox.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			ListBox.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			ListBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListBox.BorderSizePixel = 0
			ListBox.ClipsDescendants = true
			ListBox.Size = UDim2.new(1, 0, 0, 350)
			ListBox.ZIndex = 10
			ListBox.ClipsDescendants = true;

			GumballZ:AddDragBlacklist(ScrollingFrame);

			Elements.Name = GumballZ:RandomString()
			Elements.Parent = ListBox
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Elements.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)
			Elements.ZIndex = 10

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Elements

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements

			SearchBox.Name = GumballZ:RandomString()
			SearchBox.Parent = Elements
			SearchBox.BackgroundColor3 = GumballZ.Colors.Black
			SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchBox.BorderSizePixel = 0
			SearchBox.ClipsDescendants = true
			SearchBox.Position = UDim2.new(0, 10, 0, 15)
			SearchBox.Size = UDim2.new(0, 195, 0, 16)
			SearchBox.ZIndex = 10

			TextBox.Parent = SearchBox
			TextBox.BackgroundColor3 = GumballZ.Colors.Black
			TextBox.BackgroundTransparency = 1.000
			TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0, 5, 0, 0)
			TextBox.Size = UDim2.new(1, -10, 0, 16)
			TextBox.ZIndex = 11
			TextBox.ClearTextOnFocus = false
			TextBox.FontFace = GumballZ.FontSemiBold
			TextBox.PlaceholderText = "Start typing..."
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 11.000
			TextBox.TextXAlignment = Enum.TextXAlignment.Left

			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = SearchBox

			UIStroke_2.Transparency = 0.750
			UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
			UIStroke_2.Parent = SearchBox

			OptionButton.Name = GumballZ:RandomString()
			OptionButton.Parent = Elements
			OptionButton.AnchorPoint = Vector2.new(1, 0)
			OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OptionButton.BackgroundTransparency = 1.000
			OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OptionButton.BorderSizePixel = 0
			OptionButton.Position = UDim2.new(1, -10, 0, 16)
			OptionButton.Size = UDim2.new(0, 13, 0, 13)
			OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
			OptionButton.ZIndex = 11
			OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
			OptionButton.ImageTransparency = 0.600
			OptionButton.Visible = Config.Option or false;

			ScrollingFrame.Parent = Elements
			ScrollingFrame.Active = true
			ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
			ScrollingFrame.BackgroundColor3 = GumballZ.Colors.Black
			ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
			ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
			ScrollingFrame.ZIndex = 11
			ScrollingFrame.ScrollBarThickness = 0

			UICorner_3.CornerRadius = UDim.new(0, 3)
			UICorner_3.Parent = ScrollingFrame

			UIStroke_3.Transparency = 0.750
			UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
			UIStroke_3.Parent = ScrollingFrame

			UIListLayout.Parent = ScrollingFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local all = (#ScrollingFrame:GetChildren() - 1);
				local scale = math.clamp((all * (10 + UIListLayout.Padding.Offset)) + (Config.Height + UIListLayout.Padding.Offset),25,400);

				if Menu.AutoFill then
					ListBox.Size = UDim2.new(1,0,0,scale / 2.5);
				else
					ListBox.Size = UDim2.new(1,0,0,scale);
				end;

				ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y);
			end)

			SpaceBox.Name = GumballZ:RandomString()
			SpaceBox.Parent = ScrollingFrame
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 1)

			ListName.Name = GumballZ:RandomString()
			ListName.Parent = ListBox
			ListName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ListName.BackgroundTransparency = 1.000
			ListName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListName.BorderSizePixel = 0
			ListName.Position = UDim2.new(0, 10, 0, 0)
			ListName.Size = UDim2.new(1, 0, 0, 15)
			ListName.ZIndex = 10
			ListName.FontFace = GumballZ.FontSemiBold
			ListName.Text = Config.Name
			ListName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ListName.TextSize = 15.000
			ListName.TextStrokeTransparency = 0.750
			ListName.TextXAlignment = Enum.TextXAlignment.Left

			local new_button = function()
				local db_selected = Instance.new("TextButton")

				db_selected.Name = GumballZ:RandomString()
				db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				db_selected.BackgroundTransparency = 1.000
				db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				db_selected.BorderSizePixel = 0
				db_selected.Size = UDim2.new(1, 0, 0, 10)
				db_selected.ZIndex = 15
				db_selected.FontFace = GumballZ.FontSemiBold
				db_selected.TextColor3 = GumballZ.Colors.Main
				db_selected.TextSize = 12.000
				db_selected.TextTransparency = 0.5;
				db_selected.TextXAlignment = Enum.TextXAlignment.Left

				return db_selected;
			end;

			local Toggle = function(v)
				if v then
					GumballZ:CreateAnimation(ListBox,0.5,{
						BackgroundTransparency = 0
					})

					GumballZ:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})

					GumballZ:CreateAnimation(UIStroke_2,0.5,{
						Transparency = 0.75
					})

					GumballZ:CreateAnimation(UIStroke_3,0.5,{
						Transparency = 0.75
					})

					GumballZ:CreateAnimation(SearchBox,0.5,{
						BackgroundTransparency = 0
					})

					GumballZ:CreateAnimation(TextBox,0.5,{
						TextTransparency = 0
					})

					GumballZ:CreateAnimation(OptionButton,0.45,{
						ImageTransparency = (Config.Option and 0.6) or 1,
					})

					GumballZ:CreateAnimation(ScrollingFrame,0.45,{
						BackgroundTransparency = 0,
						Position = UDim2.new(0.5, 0, 0, 40)
					})

					table.foreach(ScrollingFrame:GetChildren(),function(i,v)
						if v:IsA('TextButton') then
							GumballZ:CreateAnimation(v,0.45,{
								TextTransparency = 0.5
							});
						end;
					end);

					GumballZ:CreateAnimation(ListName,0.5,{
						TextStrokeTransparency = 0.75,
						TextTransparency = 0
					})
				else

					table.foreach(ScrollingFrame:GetChildren(),function(i,v)
						if v:IsA('TextButton') then
							GumballZ:CreateAnimation(v,0.45,{
								TextTransparency = 1
							});
						end;
					end);

					GumballZ:CreateAnimation(ListBox,0.5,{
						BackgroundTransparency = 1
					})

					GumballZ:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					GumballZ:CreateAnimation(UIStroke_2,0.5,{
						Transparency = 1
					})

					GumballZ:CreateAnimation(UIStroke_3,0.5,{
						Transparency = 1
					})

					GumballZ:CreateAnimation(SearchBox,0.5,{
						BackgroundTransparency = 1
					})

					GumballZ:CreateAnimation(TextBox,0.5,{
						TextTransparency = 1
					})

					GumballZ:CreateAnimation(OptionButton,0.45,{
						ImageTransparency = 1
					})

					GumballZ:CreateAnimation(ScrollingFrame,0.45,{
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0, 40)
					})

					GumballZ:CreateAnimation(ListName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})
				end
			end;

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);

			local DearchDelay = tick();

			TextBox:GetPropertyChangedSignal('Text'):Connect(function()
				DearchDelay = tick();

				if not TextBox.Text:byte() then
					for i,v in next , ScrollingFrame:GetChildren() do
						if v:IsA('TextButton') then
							v.Visible = true;
						end;
					end;

					return;
				end;

				task.delay(0.25,function()
					if (tick() - DearchDelay) > 0.25 then
						for i,v in next , ScrollingFrame:GetChildren() do
							if v:IsA('TextButton') then
								if string.find(string.lower(v.Text),string.lower(TextBox.Text),1,true) then
									v.Visible = true;
								else
									v.Visible = false;
								end;
							end;
						end;
					end;
				end)
			end);

			local res;
			res = GumballZ:CreateResponse({
				Refresh = function()
					for i,v in next , ScrollingFrame:GetChildren() do
						if v:IsA('TextButton') then
							v:Destroy();
						end;
					end;

					local selectedmem;

					for i,v in next , Config.Values do
						local bth = new_button();

						bth.Text = string.rep(" ",2)..tostring(v);

						bth.Parent = ScrollingFrame;

						if Config.Multi then
							if (typeof(Config.Default) == 'table' and (Config.Default[v] or table.find(Config.Default,v))) or Config.Default == v then
								Config.Default[v] = true
								bth.TextColor3 = GumballZ.Colors.Main;
								bth.TextTransparency = 0;

							else
								bth.TextColor3 = Color3.fromRGB(255, 255, 255);
								bth.TextTransparency = 0.5;

								Config.Default[v] = false
							end;

							GumballZ:CreateHover(bth,function(bool)
								if not Config.Default[v] then
									if bool then
										GumballZ:CreateAnimation(bth,0.25,{
											TextTransparency = 0;
										})
									else
										GumballZ:CreateAnimation(bth,0.25,{
											TextTransparency = 0.5;
										})
									end;
								end;
							end)

							bth.MouseButton1Click:Connect(function()
								Config.Default[v] = not Config.Default[v];

								if Config.Default[v] then
									bth.TextColor3 = GumballZ.Colors.Main;
									bth.TextTransparency = 0;

								else
									bth.TextColor3 = Color3.fromRGB(255, 255, 255);
									bth.TextTransparency = 0.5;
								end;

								Config.Callback(Config.Default);
							end)
						else
							if v == Config.Default then
								selectedmem = bth;
								Config.Default = v;

								bth.TextColor3 = GumballZ.Colors.Main;
								bth.TextTransparency = 0;

							else
								bth.TextColor3 = Color3.fromRGB(255, 255, 255);
								bth.TextTransparency = 0.5;
							end;

							GumballZ:CreateHover(bth,function(bool)
								if Config.Default ~= v then
									if bool then
										GumballZ:CreateAnimation(bth,0.25,{
											TextTransparency = 0;
										})
									else
										GumballZ:CreateAnimation(bth,0.25,{
											TextTransparency = 0.5;
										})
									end;
								end;
							end)

							bth.MouseButton1Click:Connect(function()
								if selectedmem then
									selectedmem.TextColor3 = Color3.fromRGB(255, 255, 255);
									selectedmem.TextTransparency = 0.5;
								end;

								bth.TextTransparency = 0;
								bth.TextColor3 = GumballZ.Colors.Main;
								selectedmem = bth;
								Config.Default = v;

								Config.Callback(v);
							end)
						end;
					end;

					Config.Callback(Config.Default);
				end,
				SetValues = function(value)
					Config.Values = value;

				end,
				SetDefault = function(value)
					Config.Default = value;
				end,
				GetValue = function()
					return Config.Default;
				end,
				Flag = Config.Flag and Config.Flag.."ListBox",
				SetValue = function(a)

					Config.Default = a;

					res:Refresh();

					Config.Callback(Config.Default);
				end,

				Option = (Config.Option and GumballZ:CreateOption(OptionButton)) or nil;
			});

			res:Refresh();

			if Config.Flag then
				GumballZ.WindowFlags[GumballZwin][Config.Flag.."ListBox"] = res;
			end;

			return res;
		end;

		function MenuLib:AddSection(Config : Section)
			Config = Config or {};
			Config.Name = Config.Name or "SECTION";
			Config.Position = Config.Position or "center";
			Config.Height = Config.Height or 0;

			table.insert(Gum.ElementContents,{
				Name = Config.Name,
				Path = Menu.Name .. " > ".. Config.Name,
				_TAB = _B
			});

			local Section = Instance.new("Frame")
			local Elements = Instance.new("ScrollingFrame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local SectionName = Instance.new("TextLabel")

			local Toggle = function(v)
				if v then
					GumballZ:CreateAnimation(Section,0.5,{
						BackgroundTransparency = 0
					})

					GumballZ:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})

					GumballZ:CreateAnimation(SectionName,0.5,{
						TextStrokeTransparency = 0.750,
						TextTransparency = 0
					})
				else
					GumballZ:CreateAnimation(Section,0.5,{
						BackgroundTransparency = 1
					})

					GumballZ:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					GumballZ:CreateAnimation(SectionName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})
				end
			end;

			Section.Name = GumballZ:RandomString()
			Section.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Section.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, 0)

			Elements.Name = GumballZ:RandomString()
			Elements.Parent = Section
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Elements.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)
			Elements.ScrollBarThickness = 2
			Elements.ScrollBarImageColor3 = GumballZ.Colors.Main
			Elements.CanvasSize = UDim2.new(0, 0, 0, 0)

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Elements

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements

			UIListLayout.Parent = Elements
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			SpaceBox.Name = GumballZ:RandomString()
			SpaceBox.Parent = Elements
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 10)

			SectionName.Name = GumballZ:RandomString()
			SectionName.Parent = Section
			SectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.BackgroundTransparency = 1.000
			SectionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionName.BorderSizePixel = 0
			SectionName.Position = UDim2.new(0, 10, 0, 0)
			SectionName.Size = UDim2.new(1, 0, 0, 15)
			SectionName.FontFace = GumballZ.FontSemiBold;
			SectionName.Text = Config.Name
			SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.TextSize = 15.000
			SectionName.TextStrokeTransparency = 0.750
			SectionName.TextXAlignment = Enum.TextXAlignment.Left


			local function UpdateSize()
				local IsFixedHeight = Config.Height > 20
				local ContentSize = UIListLayout.AbsoluteContentSize.Y + 20 + ((not IsFixedHeight and Config.Height) or 0);
				
				Elements.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

				if IsFixedHeight then
					GumballZ:CreateAnimation(Section,0.25,{
						Size = UDim2.new(1, 0, 0, Config.Height)
					})
				else
					local MainScale = ContentSize;

					if not Menu.AutoFill then
						GumballZ:CreateAnimation(Section,0.25,{
							Size = UDim2.new(1, 0, 0, MainScale)
						})
					else
						Section.Size = UDim2.new(1,0,0,MainScale / 2.5);
					end;
				end
			end;

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(UpdateSize);
			
			-- Force update to ensure height is correct for all static elements
			task.delay(0.1, UpdateSize)

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);

			return GumballZ:CreateElements(Elements,Elements.ZIndex,BindEvent,{
				Path = Menu.Name .. " > ".. Config.Name,
				Memory = function(Name)
					table.insert(Gum.ElementContents,{
						Name = Name,
						Path = Menu.Name .. " > ".. Config.Name .. " > " .. Name,
						_TAB = _B
					});
				end,
			});
		end;

        -- Ensure these are available here in the elements table scope too if needed, 
        -- but CreateElements returns a fresh table with them defined so we rely on that.
        -- If AddSection returns the result of CreateElements, and CreateElements has AddDivider/AddParagraph 
        -- (which we added earlier), then it should work nested.
        -- Let's double check if we missed adding them to the elements table returned by CreateElements.
        -- We did add them to `elements` table in step 129 and 139.
        -- So that part is correct.
        
        -- However, there is a chance UIListLayout AbsoluteContentSize update doesn't trigger for new item types?
        -- The UIListLayout code (lines 6326+) listens to AbsoluteContentSize.
        -- Divider and Paragraph are sized Frames, so UIListLayout should pick them up.
        
        -- One subtle issue: Config.Height in AddSection might be static or not updating correctly?
        -- Or maybe specific ZIndex issues?
        
        -- Let's Verify AddDivider implementation again.
        
		return MenuLib;
	end;

	do
		InfoButton.Name = GumballZ:RandomString()
		InfoButton.Parent = Bottom
		InfoButton.AnchorPoint = Vector2.new(1, 0.5)
		InfoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		InfoButton.BackgroundTransparency = 1.000
		InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InfoButton.BorderSizePixel = 0
		InfoButton.Position = UDim2.new(1, -5, 0.5, 0)
		InfoButton.Size = UDim2.new(0, 16, 0, 16)
		InfoButton.ZIndex = 4
		InfoButton.Image = "rbxassetid://10723415903"
		InfoButton.ImageTransparency = 0.500

		SearchButton.Name = GumballZ:RandomString()
		SearchButton.Parent = Bottom
		SearchButton.AnchorPoint = Vector2.new(0, 0.5)
		SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SearchButton.BackgroundTransparency = 1.000
		SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchButton.BorderSizePixel = 0
		SearchButton.Position = UDim2.new(0, 10, 0.5, 0)
		SearchButton.Size = UDim2.new(0, 16, 0, 16)
		SearchButton.ZIndex = 4
		SearchButton.Image = "rbxassetid://10734943674"
		SearchButton.ImageTransparency = 0.500

		SaveButton.Name = GumballZ:RandomString()
		SaveButton.Parent = Bottom
		SaveButton.AnchorPoint = Vector2.new(0, 0.5)
		SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SaveButton.BackgroundTransparency = 1.000
		SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SaveButton.BorderSizePixel = 0
		SaveButton.Position = UDim2.new(0, 35, 0.5, 0)
		SaveButton.Size = UDim2.new(0, 16, 0, 16)
		SaveButton.ZIndex = 4
		SaveButton.Image = "rbxassetid://10734941499"
		SaveButton.ImageTransparency = 0.500

		GumballZ:CreateHover(SaveButton,function(bool)
			if bool then
				GumballZ:CreateAnimation(SaveButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				GumballZ:CreateAnimation(SaveButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		GumballZ:CreateHover(InfoButton,function(bool)
			if bool then
				GumballZ:CreateAnimation(InfoButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				GumballZ:CreateAnimation(InfoButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		function Gum:AddSave(callback)
			SaveButton.MouseButton1Click:Connect(callback);
		end;

		function Gum:AddInfo(callback)
			InfoButton.MouseButton1Click:Connect(callback);
		end;
	end;

	do
		local SearchFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local DropShadow = Instance.new("ImageLabel")
		local SearchBox = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local searchScale = UDim2.new(0, 295, 0, 295);

		GumballZ:AddDragBlacklist(SearchFrame);

		local SearchToggle = function(value)
			if value then
				SearchFrame.Position = UDim2.fromOffset(SearchButton.AbsolutePosition.X - 5,SearchButton.AbsolutePosition.Y + (SearchButton.AbsoluteSize.Y * 3))

				GumballZ:CreateAnimation(SearchFrame,0.35,{
					Size = searchScale
				})

				GumballZ:CreateAnimation(DropShadow,0.35,{
					ImageTransparency = 0.750
				})

				GumballZ:CreateAnimation(SearchBox,0.35,{
					BackgroundTransparency = 0
				})

				GumballZ:CreateAnimation(UIStroke_2,0.5,{
					Transparency = 0.650
				})

				GumballZ:CreateAnimation(UIStroke,0.5,{
					Transparency = 0
				})

				GumballZ:CreateAnimation(TextBox,0.5,{
					TextTransparency = 0
				})

				GumballZ:CreateAnimation(TextBox,0.5,{
					TextTransparency = 0
				})
			else
				GumballZ:CreateAnimation(UIStroke,0.5,{
					Transparency = 1
				})

				GumballZ:CreateAnimation(SearchFrame,0.35,{
					Size = UDim2.new(searchScale.X.Scale, searchScale.X.Offset, 0, 0)
				})

				GumballZ:CreateAnimation(DropShadow,0.35,{
					ImageTransparency = 1
				})

				GumballZ:CreateAnimation(SearchBox,0.5,{
					BackgroundTransparency = 1
				})

				GumballZ:CreateAnimation(UIStroke_2,0.5,{
					Transparency = 1
				})

				GumballZ:CreateAnimation(TextBox,0.5,{
					TextTransparency = 1
				})

				GumballZ:CreateAnimation(TextBox,0.5,{
					TextTransparency = 1
				})

				table.foreach(ScrollingFrame:GetChildren(),function(i,v)
					if v:IsA('Frame') then
						v:Destroy();
					end;
				end);
			end;
		end;

		SearchFrame.Name = GumballZ:RandomString()
		SearchFrame.Parent = GumballZwin;
		SearchFrame.AnchorPoint = Vector2.new(0, 1)
		SearchFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
		SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchFrame.BorderSizePixel = 0
		SearchFrame.Position = UDim2.new(4,0,4,0)
		SearchFrame.Size = searchScale
		SearchFrame.ZIndex = 100
		SearchFrame.ClipsDescendants = true

		UIStroke.Color = Color3.fromRGB(29, 29, 29)
		UIStroke.Parent = SearchFrame

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = SearchFrame

		DropShadow.Name = GumballZ:RandomString()
		DropShadow.Parent = SearchFrame
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1.000
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Rotation = 0.010
		DropShadow.Size = UDim2.new(1, 47, 1, 47)
		DropShadow.ZIndex = 99
		DropShadow.Image = "rbxassetid://6014261993"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 0.750
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

		SearchBox.Name = GumballZ:RandomString()
		SearchBox.Parent = SearchFrame
		SearchBox.AnchorPoint = Vector2.new(0.5, 0)
		SearchBox.BackgroundColor3 = GumballZ.Colors.Black
		SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchBox.BorderSizePixel = 0
		SearchBox.Position = UDim2.new(0.5, 0, 0, 9)
		SearchBox.Size = UDim2.new(1, -15, 0, 25)
		SearchBox.ZIndex = 101

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = SearchBox

		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
		UIStroke_2.Parent = SearchBox

		TextBox.Parent = SearchBox
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -15, 1, -5)
		TextBox.ZIndex = 102
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = GumballZ.FontSemiBold;
		TextBox.PlaceholderText = "Search"
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 12.000
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		ScrollingFrame.Parent = SearchFrame
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
		ScrollingFrame.Size = UDim2.new(1, -15, 1, -45)
		ScrollingFrame.ZIndex = 102
		ScrollingFrame.ScrollBarThickness = 0

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
		end)

		SearchToggle(false);

		GumballZ:CreateHover(SearchButton,function(bool)
			if bool then
				GumballZ:CreateAnimation(SearchButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				GumballZ:CreateAnimation(SearchButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		local SearchInformation = {};

		local get_button = function(Name,Path,TAB_WARP)
			local ResultFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local FeatureName = Instance.new("TextLabel")
			local FeaturePath = Instance.new("TextLabel")

			ResultFrame.Name = GumballZ:RandomString()
			ResultFrame.Parent = ScrollingFrame;
			ResultFrame.BackgroundColor3 = GumballZ.Colors.Black
			ResultFrame.BackgroundTransparency = 1.000
			ResultFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ResultFrame.BorderSizePixel = 0
			ResultFrame.Size = UDim2.new(1, 0, 0, 42)
			ResultFrame.ZIndex = 103

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = ResultFrame

			FeatureName.Name = GumballZ:RandomString()
			FeatureName.Parent = ResultFrame
			FeatureName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureName.BackgroundTransparency = 1.000
			FeatureName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureName.BorderSizePixel = 0
			FeatureName.Position = UDim2.new(0, 6, 0, 5)
			FeatureName.Size = UDim2.new(1, 0, 0, 15)
			FeatureName.ZIndex = 104
			FeatureName.FontFace = GumballZ.FontSemiBold
			FeatureName.Text = Name
			FeatureName.TextColor3 = Color3.fromRGB(255, 255, 255)
			FeatureName.TextSize = 14.000
			FeatureName.TextXAlignment = Enum.TextXAlignment.Left

			FeaturePath.Name = GumballZ:RandomString()
			FeaturePath.Parent = ResultFrame
			FeaturePath.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeaturePath.BackgroundTransparency = 1.000
			FeaturePath.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeaturePath.BorderSizePixel = 0
			FeaturePath.Position = UDim2.new(0, 6, 0, 22)
			FeaturePath.Size = UDim2.new(1, 0, 0, 15)
			FeaturePath.ZIndex = 104
			FeaturePath.FontFace = GumballZ.FontSemiBold
			FeaturePath.Text = Path
			FeaturePath.TextColor3 = Color3.fromRGB(255, 255, 255)
			FeaturePath.TextSize = 12.000
			FeaturePath.TextTransparency = 0.500
			FeaturePath.TextXAlignment = Enum.TextXAlignment.Left

			local button = GumballZ:NewInput(ResultFrame);

			GumballZ:CreateHover(button,function(bool)
				if bool then
					GumballZ:CreateAnimation(ResultFrame,0.5,{
						BackgroundTransparency = 0
					})
				else
					GumballZ:CreateAnimation(ResultFrame,0.5,{
						BackgroundTransparency = 1
					})
				end	
			end);

			button.MouseButton1Click:Connect(function()
				if TAB_WARP then
					for i,v in next , Gum.Menus do
						if v.Root == TAB_WARP.Root then
							Gum.MenuSelected = v;
							v.ValueSelect(true)
						else
							v.ValueSelect(false)
						end;
					end;
				end;
			end);

			return ResultFrame;
		end

		SearchButton.MouseButton1Click:Connect(function()
			TextBox.Text = "";

			SearchToggle(true);

			table.clear(SearchInformation);

			table.foreach(ScrollingFrame:GetChildren(),function(i,v)
				if v:IsA('Frame') then
					v:Destroy();
				end;
			end);

			table.foreach(Gum.ElementContents,function(i,v)
				local button = get_button(v.Name,v.Path,v._TAB);

				SearchInformation[v.Path.." - "..GumballZ:RandomString()] = {
					root = button,
					callback = function()

					end,
				};
			end);
		end)

		local DearchDelay = tick();

		TextBox:GetPropertyChangedSignal('Text'):Connect(function()
			DearchDelay = tick();

			if not TextBox.Text:byte() then
				for i,v in next , SearchInformation do
					v.root.Visible = true;
				end;

				return;
			end;

			task.delay(0.5,function()
				if (tick() - DearchDelay) > 0.5 then
					for i,v in next , SearchInformation do
						if string.find(tostring(string.lower(i)),string.lower(TextBox.Text),1,true) then
							v.root.Visible = true;
						else
							v.root.Visible = false;
						end;
					end;
				end;
			end)
		end);

		UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if not GumballZ:IsMouseOverFrame(SearchFrame) then
					SearchToggle(false);
				end
			end
		end)
	end;

	function Gum:GetButton()
		local backpack = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")
		local RowLabel = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local StyledTextLabel = Instance.new("TextLabel")
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		local UIPadding = Instance.new("UIPadding")
		local IconHost = Instance.new("Frame")
		local IntegrationIconFrame = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local IntegrationIcon = Instance.new("ImageLabel")
		local SelectedHighlighter = Instance.new("Frame")
		local corner = Instance.new("UICorner")
		local Highlighter = Instance.new("Frame")
		local corner_2 = Instance.new("UICorner")
		local _5 = Instance.new("Frame")

		backpack.Name = "GUMBALLZ"..GumballZ:RandomString();
		backpack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		backpack.BackgroundTransparency = 1.000
		backpack.BorderSizePixel = 0
		backpack.LayoutOrder = 9
		backpack.Size = UDim2.new(1, 0, 0, 56)
		backpack.AutoButtonColor = false

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = backpack

		RowLabel.Name = "RowLabel"
		RowLabel.Parent = backpack
		RowLabel.BackgroundTransparency = 1.000
		RowLabel.BorderSizePixel = 0
		RowLabel.LayoutOrder = 9
		RowLabel.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout.Parent = RowLabel
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 8)

		StyledTextLabel.Name = "StyledTextLabel"
		StyledTextLabel.Parent = RowLabel
		StyledTextLabel.BackgroundTransparency = 1.000
		StyledTextLabel.Size = UDim2.new(1, -52, 1, 0)
		StyledTextLabel.Font = Enum.Font.BuilderSansBold
		StyledTextLabel.Text = Window.Name
		StyledTextLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
		StyledTextLabel.TextScaled = true
		StyledTextLabel.TextSize = 20.000
		StyledTextLabel.TextWrapped = true
		StyledTextLabel.TextXAlignment = Enum.TextXAlignment.Left

		UITextSizeConstraint.Parent = StyledTextLabel
		UITextSizeConstraint.MaxTextSize = 20
		UITextSizeConstraint.MinTextSize = 15

		UIPadding.Parent = RowLabel
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 8)

		IconHost.Name = "IconHost"
		IconHost.Parent = RowLabel
		IconHost.BackgroundTransparency = 1.000
		IconHost.BorderSizePixel = 0
		IconHost.LayoutOrder = 9
		IconHost.Size = UDim2.new(0, 44, 0, 44)
		IconHost.ZIndex = 9

		IntegrationIconFrame.Name = "IntegrationIconFrame"
		IntegrationIconFrame.Parent = IconHost
		IntegrationIconFrame.BackgroundTransparency = 1.000
		IntegrationIconFrame.BorderSizePixel = 0
		IntegrationIconFrame.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout_2.Parent = IntegrationIconFrame
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

		IntegrationIcon.Name = "IntegrationIcon"
		IntegrationIcon.Parent = IntegrationIconFrame
		IntegrationIcon.BackgroundTransparency = 1.000
		IntegrationIcon.Size = UDim2.new(0, 36, 0, 36)
		IntegrationIcon.Image = "http://www.roblox.com/asset/?id=11290237405"
		IntegrationIcon.ImageColor3 = Color3.fromRGB(247, 247, 248)

		SelectedHighlighter.Name = "SelectedHighlighter"
		SelectedHighlighter.Parent = IconHost
		SelectedHighlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		SelectedHighlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SelectedHighlighter.BackgroundTransparency = 0.850
		SelectedHighlighter.BorderSizePixel = 0
		SelectedHighlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		SelectedHighlighter.Size = UDim2.new(0, 36, 0, 36)
		SelectedHighlighter.Visible = false

		corner.CornerRadius = UDim.new(1, 0)
		corner.Name = "corner"
		corner.Parent = SelectedHighlighter

		Highlighter.Name = "Highlighter"
		Highlighter.Parent = IconHost
		Highlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		Highlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Highlighter.BackgroundTransparency = 0.850
		Highlighter.BorderSizePixel = 0
		Highlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		Highlighter.Size = UDim2.new(0, 36, 0, 36)
		Highlighter.Visible = false

		corner_2.CornerRadius = UDim.new(1, 0)
		corner_2.Name = "corner"
		corner_2.Parent = Highlighter

		_5.Name = "5"
		_5.Parent = IconHost
		_5.BackgroundTransparency = 1.000
		_5.Size = UDim2.new(1, 0, 1, 0)
		_5.ZIndex = 2

		backpack.MouseButton1Click:Connect(function()
			Gum.Toggle = not Gum.Toggle;

			ToggleUI(Gum.Toggle);
		end);

		backpack.MouseEnter:Connect(function()
			GumballZ:CreateAnimation(backpack,0.3,nil,{
				BackgroundColor3 = GumballZ.Colors.Main,
				BackgroundTransparency = 0.85
			})
		end)

		backpack.MouseLeave:Connect(function()
			GumballZ:CreateAnimation(backpack,0.3,nil,{
				BackgroundTransparency = 1
			})
		end)

		return backpack;
	end;

	function Gum:SetVisible(b)
		Gum.Toggle = b;
		ToggleUI(b);
	end;

	ToggleUI(true);

	return Gum;
end;

function GumballZ:Loader(Config: Loader)
	Config = Config or {};
	Config.Name = Config.Name or "GUMBALLZ";
	Config.Duration = Config.Duration or 3.5;
	Config.Scale = Config.Scale or 3;

	-- Particle Effect Integration (Advanced 3D VFX)
	if Config.Particle then
		task.spawn(function()
			local SPAWN_RADIUS_VFX = 30
			local duration = Config.ParticleDuration or Config["particle duration"] or Config.Duration or 3
			local density = Config.ParticleScale or 3 -- Number of particles spawning per wave/interval
			
			local char = Client.Character or Client.CharacterAdded:Wait()
			local root = char:WaitForChild("HumanoidRootPart", 5)
			if not root then return end
			
			local cleanupObjects = {}
			local activeParticles = {}
			
			-- Utility: Random Point on Circle (XZ Plane)
			local function randomXZPoint_v(center, radius)
				local angle = math.random() * 2 * math.pi
				local r = math.sqrt(math.random()) * radius -- Uniform distribution in circle
				local x = center.X + r * math.cos(angle)
				local z = center.Z + r * math.sin(angle)
				return Vector3.new(x, center.Y - 2, z) -- Start slightly below/at ground level
			end

			-- Utility: Quadratic Bezier Curve
			local function bezierQuad_v(t, p0, p1, p2)
				return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
			end
			
			-- Utility: Create Impact Effect on Player
			local function spawnHRPEffect_v()
				if not root then return end
				local att = Instance.new("Attachment", root)
				table.insert(cleanupObjects, att)
				
				local emitter = Instance.new("ParticleEmitter")
				emitter.Parent = att
				emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
				emitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 150))
				})
				emitter.Size = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.5),
					NumberSequenceKeypoint.new(1, 0)
				})
				emitter.Lifetime = NumberRange.new(0.5)
				emitter.Rate = 0
				emitter.Speed = NumberRange.new(5, 8)
				emitter.SpreadAngle = Vector2.new(360, 360)
				emitter.LightEmission = 1
				emitter.Emit(emitter, 10) -- Burst
				
				task.delay(1, function() att:Destroy() end)
			end

			-- Main: Spawn a Homing Particle (Replicating exact behavior)
			local function spawnHomingParticle()
				local startPos = randomXZPoint_v(root.Position, SPAWN_RADIUS_VFX)
				
				-- The Flying Part
				local part = Instance.new("Part")
				part.Size = Vector3.new(1, 1, 1) -- Match ref
				part.Transparency = 1
				part.CanCollide = false
				part.Anchored = true
				part.Position = startPos
				part.Parent = workspace
				table.insert(cleanupObjects, part)

				-- Visuals: BillboardGui with Image
				local bb = Instance.new("BillboardGui")
				bb.Size = UDim2.new(3, 0, 3, 0) -- Match ref
				bb.AlwaysOnTop = true
				bb.Parent = part
				
				local img = Instance.new("ImageLabel")
				img.BackgroundTransparency = 1
				img.Size = UDim2.new(1, 0, 1, 0)
				img.AnchorPoint = Vector2.new(0.5,0.5)
				img.Position = UDim2.new(0.5,0.5,0.5,0)
				img.Image = "rbxassetid://112882057182762"
				img.ImageColor3 = Color3.fromRGB(224,74,255) -- Match ref
				img.Parent = bb
				
				-- Visuals: Trail
				local att0 = Instance.new("Attachment", part)
				local att1 = Instance.new("Attachment", part)
				att0.Position = Vector3.new(0, -0.25, 0)
				att1.Position = Vector3.new(0, 0.25, 0)
				
				local trail = Instance.new("Trail")
				trail.Parent = part
				trail.Attachment0 = att0
				trail.Attachment1 = att1
				trail.FaceCamera = true
				trail.MinLength = 1
				trail.MaxLength = 8
				trail.Lifetime = 0.25
				trail.LightInfluence = 1
				trail.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 237, 135))
				})
				trail.WidthScale = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
				trail.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})

				-- Movement Logic: Threaded for simplified Wait() usage (as per reference)
				task.spawn(function()
					local LIFT_AMOUNT = 2
					local LIFT_TIME = 0.45
					local ARC_DELAY = 1
					local ARC_TIME = 0.6
					
					-- Phase 1: Lift Up
					local targetLiftCFrame = part.CFrame * CFrame.new(0, LIFT_AMOUNT, 0)
					local liftTween = TweenService:Create(part, TweenInfo.new(LIFT_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = targetLiftCFrame})
					liftTween:Play()
					
					task.wait(LIFT_TIME + ARC_DELAY)
					
					-- Phase 2: Homing Arc
					if not part.Parent or not root.Parent then return end
					
					local startP = part.Position
					local t0 = tick()
					
					while true do
						if not part.Parent or not root.Parent then break end
						local alpha = (tick() - t0) / ARC_TIME
						if alpha >= 1 then break end

						local currentEnd = root.Position
						local mid = (startP + currentEnd) / 2
						local height = math.max(6, (currentEnd.Y - startP.Y) * 0.5 + 6)
						local control = mid + Vector3.new(0, height, 0) -- Control point

						local pos = bezierQuad_v(alpha, startP, control, currentEnd)
						part.CFrame = CFrame.new(pos)

						RunService.RenderStepped:Wait()
					end
					
					-- Phase 3: Impact
					if part.Parent and root.Parent then
						part.CFrame = CFrame.new(root.Position)
						spawnHRPEffect_v()
						part:Destroy()
					end
				end)
			end
			
			-- Spawner Loop
			local spawning = true
			task.spawn(function()
				while spawning do
					for i=1, density do
						spawnHomingParticle()
						task.wait(math.random(0.1, 0.3))
					end
					task.wait(0.5)
				end
			end)
			
			task.delay(duration, function()
				spawning = false
				for _, v in pairs(cleanupObjects) do
					if typeof(v) == "Instance" then v:Destroy()
					elseif typeof(v) == "RBXScriptConnection" then v:Disconnect()
					end
				end
			end)
		end)
	end

	local Blur
	if Config.Blur then
		Blur = Instance.new('BlurEffect');
		Blur.Size = 0;
		Blur.Parent = game:GetService('Lighting');
		
		GumballZ:CreateAnimation(Blur,1,{
			Size = 60
		})
	end

	local Loader = Instance.new("ScreenGui")
	local center = Instance.new("Frame")
	local texts = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local BlackFrame = Instance.new("Frame")

	Loader.Name = GumballZ:RandomString()
	Loader.Parent = CoreGui
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
end;

function GumballZ:CreateNotifier(): Notifier
	if GumballZ.__NOTIFIER_CACHE then return GumballZ.__NOTIFIER_CACHE; end;

	local Notify = Instance.new("ScreenGui")
	local layout = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notify.Name = GumballZ:RandomString();
	Notify.Parent = CoreGui
	Notify.ResetOnSpawn = false
	Notify.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Notify.IgnoreGuiInset = true;

	layout.Name = GumballZ:RandomString();
	layout.Parent = Notify
	layout.AnchorPoint = Vector2.new(1, 1)
	layout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	layout.BackgroundTransparency = 1.000
	layout.BorderColor3 = Color3.fromRGB(0, 0, 0)
	layout.BorderSizePixel = 0
	layout.Position = UDim2.new(1, -5, 1, -5)
	layout.Size = UDim2.new(0, 150, 1, -10)

	UIListLayout.Parent = layout
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local res = GumballZ:CreateResponse({
		Notify = function(Config: Notify)
			Config = Config or {}
			Config.Icon = Config.Icon or "settings";
			Config.Content = Config.Content or nil;
			Config.Title = Config.Title or "Notification";
			Config.Duration = Config.Duration or 5;

			local notify = Instance.new("Frame")
			local notify_block = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Icon = Instance.new("ImageLabel")
			local HeaderText = Instance.new("TextLabel")
			local BodyText = Instance.new("TextLabel")

			notify.Name = GumballZ:RandomString()
			notify.Parent = layout
			notify.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			notify.BackgroundTransparency = 1.000
			notify.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify.BorderSizePixel = 0
			notify.Size = UDim2.new(0, 0, 0, 0)

			notify_block.Name = GumballZ:RandomString()
			notify_block.Parent = notify
			notify_block.AnchorPoint = Vector2.new(0.5, 0)
			notify_block.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			notify_block.BackgroundTransparency = 1
			notify_block.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify_block.BorderSizePixel = 0
			notify_block.Position = UDim2.new(0.5, 0, -1, 0)
			notify_block.Size = UDim2.new(1, 0, 1, -12)
			notify_block.ClipsDescendants = true
			notify_block.ZIndex = 54

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = notify_block

			UIStroke.Thickness = 1
			UIStroke.Transparency = 1
			UIStroke.Parent = notify_block

			Icon.Name = GumballZ:RandomString()
			Icon.Parent = notify_block
			Icon.BackgroundColor3 = GumballZ.Colors.Main
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 7, 0, 7)
			Icon.Size = UDim2.new(0, 18, 0, 18)
			Icon.Image = GumballZ:GetIcon(Config.Icon);
			Icon.ImageColor3 = GumballZ.Colors.Main
			Icon.ImageTransparency = 1
			Icon.ZIndex = 55

			HeaderText.Name = GumballZ:RandomString()
			HeaderText.Parent = notify_block
			HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderText.BackgroundTransparency = 1.000
			HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HeaderText.BorderSizePixel = 0
			HeaderText.Position = UDim2.new(0, 30, 0, 7)
			HeaderText.Size = UDim2.new(1, 0, 0, 15)
			HeaderText.ZIndex = 55
			HeaderText.FontFace = GumballZ.FontSemiBold
			HeaderText.Text = Config.Title
			HeaderText.TextColor3 = GumballZ.Colors.Main
			HeaderText.TextSize = 13.000
			HeaderText.TextTransparency = 1
			HeaderText.TextXAlignment = Enum.TextXAlignment.Left

			BodyText.Name = GumballZ:RandomString()
			BodyText.Parent = notify_block
			BodyText.AnchorPoint = Vector2.new(0, 1)
			BodyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			BodyText.BackgroundTransparency = 1.000
			BodyText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			BodyText.BorderSizePixel = 0
			BodyText.Position = UDim2.new(0, 10, 1, 0)
			BodyText.Size = UDim2.new(1, -15, 1, -29)
			BodyText.ZIndex = 55
			BodyText.FontFace = GumballZ.FontSemiBold
			BodyText.Text = Config.Content or "";
			BodyText.TextColor3 = Color3.fromRGB(255, 255, 255)
			BodyText.TextSize = 12.000
			BodyText.TextTransparency = 1
			BodyText.TextWrapped = true
			BodyText.TextXAlignment = Enum.TextXAlignment.Left
			BodyText.TextYAlignment = Enum.TextYAlignment.Top

			local updateScale = function()
				local TitleScale = GumballZ:GetTextSize(HeaderText,Enum.Font.GothamBold);
				local ContentScale = GumballZ:GetTextSize(BodyText,Enum.Font.GothamMedium);

				local XScale = (TitleScale.X > ContentScale.X and TitleScale.X) or ContentScale.X;
				local YScale = (TitleScale.Y > ContentScale.Y and TitleScale.Y) or ContentScale.Y;

				notify.Size = UDim2.new(0, XScale + 25, 0, YScale + 50);

				GumballZ:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 0, 0)
				});
			end;

			task.delay(0.1,function()
				GumballZ:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 0.1
				})

				GumballZ:CreateAnimation(UIStroke,0.25,{
					Thickness = 2.500,
					Transparency = 0.900
				})

				GumballZ:CreateAnimation(Icon,0.25,{
					ImageTransparency = 0
				})

				GumballZ:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 0.200
				})

				GumballZ:CreateAnimation(BodyText,0.25,{
					TextTransparency = 0.3
				})
			end);

			updateScale();

			task.delay(Config.Duration + 0.25,function()
				GumballZ:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 1, 0)
				})

				GumballZ:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 1
				})

				GumballZ:CreateAnimation(UIStroke,0.25,{
					Thickness = 1,
					Transparency = 1
				})

				GumballZ:CreateAnimation(Icon,0.25,{
					ImageTransparency = 1
				})

				GumballZ:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 1
				})

				GumballZ:CreateAnimation(BodyText,0.25,{
					TextTransparency = 1
				})

				task.delay(0.35,function()
					GumballZ:CreateAnimation(notify,0.5,{
						Size = UDim2.new(0,0,0,0)
					})

					task.wait(0.5)

					notify:Destroy();
				end);
			end)
		end,
	});

	GumballZ.__NOTIFIER_CACHE = res;

	return res;
end;

GumballZ.GUMBALLZ_PID = GumballZ:RandomString();

return GumballZ;

if _G.BloxFruit_Hub then
    warn("Script đã chạy! Không thể chạy lại.")
    return
end
_G.BloxFruit_Hub = true

--==================================================================================================================--

--load UI
loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/LoadAnimation.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- debug switch (set true để xem log)
local DEBUG = false
local function dprint(...)
	if DEBUG then print("[LoadAnim]", ...) end
end

-- locate GUI pieces
local loadGui = playerGui:WaitForChild("LoadAnimationGui", 5)
if not loadGui then
	warn("LoadAnimationGui not found")
	return
end

local LoadWhiteFrame = loadGui:WaitForChild("LoadWhiteFrame", 5)
if not LoadWhiteFrame then
	warn("LoadWhiteFrame not found")
	return
end

-- LoadFrame is child inside LoadWhiteFrame (contains UIGradient)
local LoadFrame = LoadWhiteFrame:FindFirstChild("LoadFrame", true)
if not LoadFrame then
	warn("LoadFrame not found inside LoadWhiteFrame")
	return
end

-- UIGradient inside LoadFrame (we animate its Offset for percent)
local innerGradient = LoadFrame:FindFirstChildOfClass("UIGradient")
if not innerGradient then
	warn("UIGradient not found inside LoadFrame")
	-- continue, but percent gradient won't animate
end

-- star template in Effect folder
local effectFolder = loadGui:FindFirstChild("Effect")
if not effectFolder then
	warn("Effect folder not found in LoadAnimationGui")
	return
end

local StarTemplate = effectFolder:FindFirstChild("StarEffect")
if not StarTemplate or not StarTemplate:IsA("ImageLabel") then
	warn("StarEffect template missing or not ImageLabel")
	return
end

-- config (tweak durations / curvature here)
local GREEN = Color3.fromRGB(0,255,0)
local START_STAR_COLOR = Color3.fromRGB(208,38,255)
local STAR_ENTRY_POS    = UDim2.new(0.5,0,1.5,0) -- initial offscreen
local STAR_MID_POS      = UDim2.new(0.5,0,0.75,0) -- intermediate stop
local STAR_TARGET_POS   = UDim2.new(0.5,0,0.4,0) -- center target of LoadWhiteFrame
local LOADFRAME_ORIGIN  = UDim2.new(0.5,0,0.4,0) -- authoritative origin for shaking & restore

local entryToMidTime = 0.50   -- "not too fast" entry -> mid
local arcTime        = 0.70   -- arc duration (strong curve)
local starFadeTime   = 0.22
local shakeTime      = 0.08
local gradientTweenTime = 0.5
local sizeTweenTime  = 0.28

-- initialization: set LoadWhiteFrame size 0 and invisible, ensure background transparency 0
LoadWhiteFrame.Size = UDim2.new(0,0,0,0)
LoadWhiteFrame.Visible = false
LoadWhiteFrame.BackgroundTransparency = 0

-- ensure star template anchor/pos per instruction (template hidden)
StarTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
StarTemplate.Position = UDim2.new(0.5, 0, 1000, 0) -- keep template offscreen

-- internal progress state
local currentPercent = 0 -- 0..1
local lock = false -- finish lock
local activeStars = 0 -- count of active star clones in-flight (now counts 3D effects too)
local function clamp01(v) return math.clamp(v or 0, 0, 1) end

-- tween helper
local function tweenObject(obj, props, time, style, dir)
	local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

-- percent -> gradient mapping (0 -> 0.5 ; 1 -> -0.5)
local function percentToOffset(p)
	p = clamp01(p)
	return Vector2.new(0, 0.5 - p * 1.0)
end

local function tweenInnerGradientToPercent(p, ttime)
	if not innerGradient then return end
	local goal = percentToOffset(p)
	local info = TweenInfo.new(ttime or gradientTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local t = TweenService:Create(innerGradient, info, {Offset = goal})
	t:Play()
	return t
end

-- create stronger arc control point (more negative y => stronger curve)
local function makeArcControlPoint(p0, p2)
	local midx = 0.35 + math.random() * 0.3 -- horizontal jitter
	-- place control well above endpoints for a pronounced curve (more negative)
	local top = math.min(p0.Y, p2.Y) - (0.7 + math.random() * 0.17)
	return Vector2.new(midx, top)
end

-- quadratic bezier driver using RunService.Heartbeat
local function driveArc(star, fromUDim2, toUDim2, duration, onComplete)
	local p0 = Vector2.new(fromUDim2.X.Scale, fromUDim2.Y.Scale)
	local p2 = Vector2.new(toUDim2.X.Scale, toUDim2.Y.Scale)
	local p1 = makeArcControlPoint(p0, p2)
	local startTime = tick()
	local conn
	conn = RunService.Heartbeat:Connect(function()
		local t = (tick() - startTime) / duration
		if t >= 1 then t = 1 end
		local omt = 1 - t
		local bx = omt*omt*p0.X + 2*omt*t*p1.X + t*t*p2.X
		local by = omt*omt*p0.Y + 2*omt*t*p1.Y + t*t*p2.Y
		star.Position = UDim2.new(bx, 0, by, 0)
		star.ImageColor3 = START_STAR_COLOR:Lerp(Color3.new(1,1,1), t)
		if t >= 1 then
			conn:Disconnect()
			star.Position = toUDim2
			if type(onComplete) == "function" then
				pcall(onComplete)
			end
		end
	end)
end

-- initial entry: entry -> mid -> strong arc -> delete + tween size
local function initialEntry()
	if LoadWhiteFrame.Visible then return end
	LoadWhiteFrame.Visible = true

	local star = StarTemplate:Clone()
	star.Parent = loadGui
	star.Visible = true
	star.AnchorPoint = Vector2.new(0.5, 0.5)
	star.Position = STAR_ENTRY_POS
	star.ImageColor3 = START_STAR_COLOR

	-- entry -> mid (not too fast)
	local t1 = tweenObject(star, {Position = STAR_MID_POS}, entryToMidTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	t1.Completed:Wait()

	-- arc mid -> target (strong curvature)
	activeStars = activeStars + 1
	driveArc(star, STAR_MID_POS, STAR_TARGET_POS, arcTime, function()
		-- arrived: delete star immediately
		pcall(function() star:Destroy() end)
		-- simultaneously tween LoadWhiteFrame size from zero -> 50x50
		pcall(function()
			tweenObject(LoadWhiteFrame, {Size = UDim2.new(0,50,0,50)}, sizeTweenTime)
		end)
		activeStars = math.max(0, activeStars - 1)
	end)

	-- ensure inner gradient starts at 0%
	if innerGradient then innerGradient.Offset = percentToOffset(0) end
end

-- small shake that restores exact origin
local function shakeLoadFrame()
	local origin = LOADFRAME_ORIGIN
	local ox = (math.random() - 0.5) * 0.02
	local oy = (math.random() - 0.5) * 0.02
	local shakePos = UDim2.new(origin.X.Scale + ox, 0, origin.Y.Scale + oy, 0)
	local t1 = tweenObject(LoadWhiteFrame, {Position = shakePos}, shakeTime)
	t1.Completed:Wait()
	tweenObject(LoadWhiteFrame, {Position = origin}, shakeTime).Completed:Wait()
	LoadWhiteFrame.Position = origin
end

-- =========================
-- BEGIN 3D VFX CODE (direct insertion, preserving all parameters)
-- =========================

-- Ensure we have the character HRP
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- VFX constants (use exactly your provided values)
local DURATION_VFX = 30
local SPAWN_INTERVAL_VFX = 0.25
local SPAWN_RADIUS_VFX = 30
local INITIAL_Y_VFX = -1
local LIFT_AMOUNT_VFX = 2
local LIFT_TIME_VFX = 0.45
local ARC_DELAY_VFX = 1
local ARC_TIME_VFX = 0.6
local HRP_EFFECT_LIVE_VFX = 0.05
local HRP_EFFECT_FADE_VFX = 1.5

-- local helpers reuse your original functions names/style
local function randomXZPoint_v(origin, radius)
	local theta = math.random() * 2 * math.pi
	local r = math.random() * radius
	local dx = math.cos(theta) * r
	local dz = math.sin(theta) * r
	return origin + Vector3.new(dx, 0, dz)
end

local function bezierQuad_v(a, b, c, t)
	local omt = 1 - t
	return a * (omt * omt) + b * (2 * omt * t) + c * (t * t)
end

local function createEffectPart_v(position)
	local Effect = Instance.new("Part")
	Effect.Name = "Effect"
	Effect.TopSurface = Enum.SurfaceType.Smooth
	Effect.BottomSurface = Enum.SurfaceType.Smooth
	Effect.Anchored = true
	Effect.CanCollide = false
	Effect.Size = Vector3.new(1,1,1)
	Effect.Transparency = 1
	Effect.CFrame = CFrame.new(position)
	Effect.Parent = workspace

	-- Attachments for Trail (one above, one below)
	local Att0 = Instance.new("Attachment")
	Att0.Name = "Att0"
	Att0.Position = Vector3.new(0, -0.25, 0)
	Att0.Parent = Effect

	local Att1 = Instance.new("Attachment")
	Att1.Name = "Att1"
	Att1.Position = Vector3.new(0, 0.25, 0)
	Att1.Parent = Effect

	-- Trail
	local Trail = Instance.new("Trail")
	Trail.Name = "EffectTrail"
	Trail.Attachment0 = Att0
	Trail.Attachment1 = Att1
	Trail.FaceCamera = true
	Trail.MinLength = 1
	Trail.MaxLength = 8
	Trail.Lifetime = 0.25
	Trail.LightInfluence = 1
	Trail.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(184,0,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,237,135))
	}
	Trail.WidthScale = NumberSequence.new{ NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0) }
	Trail.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) }
	Trail.Parent = Effect

	-- Billboard GUI with image
	local BillboardGui = Instance.new("BillboardGui")
	BillboardGui.Name = "EffectBillboard"
	BillboardGui.Active = true
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Size = UDim2.new(3,0,3,0)
	BillboardGui.MaxDistance = math.huge
	BillboardGui.Parent = Effect

	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.Size = UDim2.new(1,0,1,0)
	ImageLabel.AnchorPoint = Vector2.new(0.5,0.5)
	ImageLabel.Position = UDim2.new(0.5,0.5,0.5,0)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Image = "rbxassetid://112882057182762"
	ImageLabel.ImageColor3 = Color3.fromRGB(224,74,255)
	ImageLabel.Parent = BillboardGui

	return Effect, Att0, Att1
end

local function spawnHRPEffect_v()
	if not hrp or not hrp.Parent then return end

	-- Attachment gắn trực tiếp vào HRP (follows player)
	local att = Instance.new("Attachment")
	att.Name = "HRP_EffectAttachment"
	-- use the offset you previously used (keep identical)
	att.Position = Vector3.new(0, 1.2, 0)
	att.Parent = hrp

	local pe = Instance.new("ParticleEmitter")
	pe.Name = "HRP_Particles"

	-- === Preserve your exact particle parameters ===
	pe.Lifetime = NumberRange.new(1.75,2)
	pe.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,222,137)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(224,74,255))
	}
	pe.Drag = 50
	pe.LightInfluence = 0
	pe.SpreadAngle = Vector2.new(90,90)
	pe.Speed = NumberRange.new(90,100)
	pe.Texture = "rbxassetid://112882057182762"
	pe.RotSpeed = NumberRange.new(30,60)
	pe.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0,0),
		NumberSequenceKeypoint.new(1,1)
	}
	pe.Size = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(1, 0.5)
	}
	pe.Rate = 50
	pe.Parent = att

	-- Fade out smoothly using exactly your HRP timings
	task.delay(HRP_EFFECT_LIVE_VFX, function()
		local steps = 20
		local startRate = pe.Rate
		for i = 1, steps do
			local frac = i / steps
			pe.Rate = math.floor(startRate * (1 - frac) + 0.5)
			task.wait(HRP_EFFECT_FADE_VFX / steps)
		end
		pe.Rate = 0
		task.delay(0.3, function()
			if att and att.Parent then att:Destroy() end
		end)
	end)
end

-- Single-effect lifecycle (runs independently) - preserves your arc/homing behavior and timings
local function runSingleEffect_v()
	-- spawn position random around player (XZ), Y low
	local basePos = hrp.Position
	local spawnXZ = randomXZPoint_v(basePos, SPAWN_RADIUS_VFX)
	local spawnPos = Vector3.new(spawnXZ.X, basePos.Y + INITIAL_Y_VFX, spawnXZ.Z)

	local effect, att0, att1 = createEffectPart_v(spawnPos)

	-- small upward lift tween (CFrame) (preserve LIFT_TIME/LIFT_AMOUNT)
	local targetLiftCFrame = effect.CFrame * CFrame.new(0, LIFT_AMOUNT_VFX, 0)
	local liftTween = TweenService:Create(effect, TweenInfo.new(LIFT_TIME_VFX, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = targetLiftCFrame})
	liftTween:Play()

	-- After lift completes then wait ARC_DELAY
	task.wait(LIFT_TIME_VFX + (ARC_DELAY_VFX - 0))

	-- dynamic bezier homing (preserve ARC_TIME and homing behavior)
	local startP = effect.Position
	local t0 = tick()

	while true do
		local alpha = (tick() - t0) / ARC_TIME_VFX
		if alpha >= 1 then break end

		-- dynamic target each frame
		local currentEnd = hrp.Position
		local mid = (startP + currentEnd) / 2
		local height = math.max(6, (currentEnd.Y - startP.Y) * 0.5 + 6)
		local control = mid + Vector3.new(0, height, 0)

		local pos = bezierQuad_v(startP, control, currentEnd, alpha)
		effect.CFrame = CFrame.new(pos)

		RunService.RenderStepped:Wait()
	end

	-- ensure final snap to HRP
	if hrp and hrp.Parent then
		effect.CFrame = CFrame.new(hrp.Position)
	end

	-- destroy effect part and spawn HRP effect that follows player
	effect:Destroy()

	if hrp and hrp.Parent then
		spawnHRPEffect_v()
	end
end

-- =========================
-- END 3D VFX CODE
-- =========================

-- NEW spawnStarFly: spawn 3D effect instead of GUI star, keep onArrive callback intact
local function spawnStarFly(onArrive)
	activeStars = activeStars + 1

	-- spawn the 3D effect asynchronously
	task.spawn(function()
		pcall(runSingleEffect_v)

		-- effect finished -> call onArrive to update percent + UI
		pcall(function()
			if type(onArrive) == "function" then
				onArrive()
			end
		end)

		activeStars = math.max(0, activeStars - 1)
	end)
end

local function runFinalSequence()
	-- 1. Đảm bảo không còn star bay
	while activeStars > 0 do
		task.wait()
	end

	-- 2. Đợi đúng 1s
	task.wait(1)
	
	-- 2.1 Bật visible Button trong BloxFruitHubGui
	local bf = playerGui:FindFirstChild("BloxFruitHubGui")
	if bf then
		local btn = bf:FindFirstChild("Button", true)
		if btn then
			btn.Visible = true
		end
	end

	-- 3. Set màu nền sang xanh
	LoadWhiteFrame.BackgroundColor3 = GREEN

	-- 4. Tắt LoadFrame (phần bên trong)
	LoadFrame.Visible = false

	-- 5. Tween transparency LoadWhiteFrame từ 0 -> 1
	LoadWhiteFrame.BackgroundTransparency = 0
	local tween = TweenService:Create(
		LoadWhiteFrame,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1}
	)
	tween:Play()
	tween.Completed:Wait()

	-- 6. Xóa toàn bộ GUI
	loadGui:Destroy()
end

-- main API: shared.load(amount)
shared.load = shared.load or function(amount)
	if type(amount) ~= "number" then return end
	if lock then return end
	amount = clamp01(amount)
	if amount <= 0 then return end

	local alloc = math.min(amount, 1 - currentPercent)
	if alloc <= 0 then return end

	local count = math.random(3, 7)
	local perStar = alloc / count

	for i = 1, count do
		local delta = perStar
		if i == count then delta = alloc - perStar * (count - 1) end

		spawnStarFly(function()
			-- on arrival
			currentPercent = clamp01(currentPercent + delta)
			dprint("Effect arrived; currentPercent=", currentPercent)

			-- shake + tween inner gradient (the one inside LoadFrame) to reflect new percent
			pcall(shakeLoadFrame)
			pcall(function() tweenInnerGradientToPercent(currentPercent, 0.25) end)

			-- finish sequence when reach 100%
			if currentPercent >= 1 and not lock then
				lock = true
				dprint("Reached 100%, locking and spawning final sequence")
				-- run final sequence (safely)
				task.spawn(runFinalSequence)
			end
		end)

		-- small stagger between spawns
		task.wait(0.06 + math.random() * 0.05)
	end
end

-- entry flow
task.spawn(function()
	LoadWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadWhiteFrame.Position = LOADFRAME_ORIGIN

	-- start invisible + size=0 already set above
	initialEntry()

	-- initialize inner gradient to 0% (if exists)
	if innerGradient then innerGradient.Offset = percentToOffset(0) end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/MainUI.lua"))()

print("Main UI 1/10✅")
shared.load(0.025)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Status.lua"))()

print("Status 2/10✅")
shared.load(0.04)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Main.lua"))()

print("Main 3/10✅")
shared.load(0.06)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Raid.lua"))()

print("Raid 4/10✅")
shared.load(0.075)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Fruit.lua"))()

print("Fruit 5/10✅")
shared.load(0.085)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Visual.lua"))()

print("Visual 6/10✅")
shared.load(0.095)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Player%20Setting.lua"))()

print("Player Setting 7/10✅")
shared.load(0.125)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Combat.lua"))()

print("Combat 8/10✅")
shared.load(0.175)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Island.lua"))()

print("Island 9/10✅")
shared.load(0.25)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/Order.lua"))()

print("Order 10/10✅")
shared.load(0.3)

print(">================================================================================================<")
--=== UI SYSTEM ============================================================================================================================--

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/SystemUI.lua"))()

print("UI System 1/2✅")
shared.load(0.35)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM_UI/ToggleUIEffect.lua"))()

print("Toggle UI Effect 2/2✅")
shared.load(0.4)

print(">================================================================================================<")
--=== TAB SYSTEM ============================================================================================================================--

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Status_System.lua"))()

print("Status tab System 1/9✅")
shared.load(0.475)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Main_System.lua"))()

print("Main tab System 2/9✅")
shared.load(0.55)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Raid_System.lua"))()

print("Raid tab System 3/9✅")
shared.load(0.625)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Combat_System.lua"))()

print("Combat tab System 4/9✅")
shared.load(0.7)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Player%20Setting_System.lua"))()

print("Player Setting tab System 5/9✅")
shared.load(0.775)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Island_System.lua"))()

print("Island tab System 6/9✅")
shared.load(0.85)

loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Order_System.lua"))()

print("Order tab System 7/9✅")
shared.load(0.875)


loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Fruit_System.lua"))()

print("Fruit tab System 8/9✅")
shared.load(0.9)

local ok, err = pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/HAPPY-script/BloxFruitHub_NewUI/refs/heads/main/SYSTEM/Visual_System.lua"))()
end)
if not ok then
	warn("[Visual tab]: ", err)
end

print("Visual tab System 9/9✅")
shared.load(0.95)

print("✅COMPLETE✅")

-- se
local BLOX_FRUITS_GAME_ID = 85211729168715
local BLOX_FRUITS_GAME_ID2 = 2753915549

local SECOND_SEA_GAME_ID = 79091703265657
local SECOND_SEA_GAME_ID2 = 4442272183

local THIRD_SEA_GAME_ID = 7449423635
local THIRD_SEA_GAME_ID2 = 100117331123089

local currentGameId = game.PlaceId
if currentGameId == BLOX_FRUITS_GAME_ID or currentGameId == BLOX_FRUITS_GAME_ID2 or currentGameId == SECOND_SEA_GAME_ID or currentGameId == SECOND_SEA_GAME_ID2 or currentGameId == THIRD_SEA_GAME_ID or currentGameId == THIRD_SEA_GAME_ID2 then

    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer

    local blockMain = Instance.new("Part")
    blockMain.Size = Vector3.new(500, 2.1, 500)
    blockMain.Anchored = true
    blockMain.Position = Vector3.new(0, 0, 0)
    blockMain.Transparency = 1
    blockMain.CanCollide = true
    blockMain.Parent = workspace

    local function updateBlockPosition(character)
        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character or not hrp then return end

            local playerPos = hrp.Position

            blockMain.Position = Vector3.new(playerPos.X, -5, playerPos.Z)
            local mainSurfaceY = blockMain.Position.Y + (blockMain.Size.Y / 2)

            if hrp.Position.Y < mainSurfaceY and hrp.Position.Y > blockMain.Position.Y - 250 then
                hrp.CFrame = CFrame.new(hrp.Position.X, mainSurfaceY + 5, hrp.Position.Z)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        player.CharacterRemoving:Connect(function()
            if connection then connection:Disconnect() end
        end)
    end

    player.CharacterAdded:Connect(updateBlockPosition)
    if player.Character then
        updateBlockPosition(player.Character)
    end
    
    print("✅✅ Sea Protection Active (Single Layer) ✅✅")

else
    warn("⚠️ Script Sea Protection chỉ hoạt động trong game Blox Fruits.")
end

shared.load(1)
hãy để chữ gumballz lúc load nhỏ hơn và giảm độ mờ xuống
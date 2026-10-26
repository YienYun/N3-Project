--[[
	N3-Steal-An-Egg.luau v0.2.0 — hub Steal An Egg, rewrite clean-room.
	Referensi logika: Games/Source/StealAnEgg/ChiliSourceV5.luau (baca only).

	ATURAN PROYEK (mandat user):
	1. Clean-room: alur logika chili ditulis ulang; nol copas mentah,
	   nol identifier deobfus (cn3/f32/zr/...), nama themed & maintainable.
	2. Nol hardcode data game: katalog egg/rarity/area ditarik LIVE dari
	   module game (SafeRequire, pola chili); fallback list cuma jaring pengaman.
	3. Kitab utuh satu file, lapisan tegas atas->bawah:
	   [0] CONFIG        — semua konstanta bernama (range, default, kurva value)
	   [1] SAFEBOOT      — handshake + guard pcall
	   [2] GAMEBRIDGE    — KODE GAME: services, root char, module game,
	                       scan egg/zone/guard di Workspace (nol logika farm)
	   [3] FARMCONTROLLER— LOGIKA FARM: pilih target, move, pickup, deliver,
	                       anti-guard (nol sentuh UI)
	   [4] UIBRIDGE      — KODE LIBRARY: window/tab/groupbox/komponen N3V4 LIB,
	                       callback cuma nulis ke FarmState (paling bawah)
	4. State satu pintu: FarmState. Controller baca/tulis hanya di situ.
]]

--[=[ [0] CONFIG ]=]
local EggHub = { Version = "0.2.1", Name = "N3-Steal-An-Egg" }

local Config = {
	LibraryUrl = "https://raw.githubusercontent.com/YienYun/N3-Project/refs/heads/arena/86b8116d-n3-project/Library/N3V3-NoObfus.lua",

	-- Kurva value egg persis chili (baris 30744-30747): scale^1.85,
	-- scale>5 pakai (scale/5)^1.2 * mult.
	ValueCurve = {
		SmallExponent = 1.85,
		BigBase = 5,
		BigExponent = 1.2,
		BigMultiplier = 19.637875755794113,
	},

	SafeZone = { Inset = 6, PartName = "SafeZone" },
	Guard = { Radius = 60, ScanInterval = 0.2, FolderName = "GuardAreas", ModelName = "Guard", StateAttribute = "GuardState", SleepingState = "Sleeping" },
	Carry = { Attribute = "HalloweenCarrying", UidAttribute = "CarryUid" },
	-- Mekanisme pickup game asli (chili 16075-16194): egg field punya
	-- part "SmartPromptPart" berisi ProximityPrompt "CarryAreaEgg";
	-- pickup = fire prompt itu, bukan sekadar injak egg.
	Pickup = { PromptPartName = "SmartPromptPart", PromptName = "CarryAreaEgg", Tries = 4, RetryGap = 0.2 },
	Egg = { UidAttribute = "HalloweenEggUid", SourceAttribute = "PreparedSourceName", ZoneAttribute = "Zone" },

	Move = {
		ArriveSnap = 6,          -- jarak dianggap sampai (chili: >6 = teleport ulang)
		TeleportGap = 3,         -- gap sisa setelah PivotTo (chili: >3 = set CFrame root)
		TeleportRetries = 3,
		StrayPartRadius = 12,    -- part karakter nyasar >12 stud disnap ke root
		BaseWalkSpeed = 16,      -- walkspeed humanoid default buat hitung waktu tween
		CycleInterval = 0.25,
		PickupTimeout = 3,
	},

	-- Fallback kalau module game gagal di-require (jaring pengaman, bukan sumber utama)
	FallbackAreas = {
		"Forest", "Desert", "Snow", "Lake", "Jungle", "Volcano", "Prehistoric",
		"Cosmic", "Abyss Ocean", "Cherry Blossom", "Light Dark", "Titan Temple",
		"Enchanted Forest",
	},
	FallbackRarities = {
		"Common", "Uncommon", "Rare", "Epic", "Legendary",
		"Mythic", "Cosmic", "Secret", "Eternal", "Divine",
	},
	PriorityModes = { "Best Rarity", "Biggest Weight", "Best Mutation", "Highest Value", "Lowest Value" },
	InstantZones = { "Titan Temple", "Light Dark", "Enchanted Forest" },

	Ranges = {
		TweenSpeedPercent = { Min = 50, Max = 120, Default = 100 },
		CarrySpeedPercent = { Min = 80, Max = 120, Default = 100 },
		V2TweenSpeed = { Min = 3000, Max = 4500, Default = 3300 },
		MinStealValue = { Min = 0, Max = 1000000000, Default = 0 },
	},
}

-- State satu pintu: UI nulis di sini, controller baca dari sini.
local FarmState = {
	TargetAreas = {},            -- map nama area -> true (kosong = semua)
	TargetRarity = "Any",        -- nama rarity minimum
	MinStealValue = Config.Ranges.MinStealValue.Default,
	TargetEggs = {},             -- map nama egg -> true (kosong = semua)
	Priority = "Highest Value",
	V2TweenSpeed = Config.Ranges.V2TweenSpeed.Default,
	CarrySpeed = Config.Ranges.CarrySpeedPercent.Default,
	AutoSteal = false,
	InstantSteal = false,
	InstantStealV2 = false,
	TeleportToEgg = false,
	StealMethod = "Teleport",    -- "Teleport" | "Step"
	TweenSpeed = Config.Ranges.TweenSpeedPercent.Default,
	TargetZones = { ["Titan Temple"] = true, ["Light Dark"] = true, ["Enchanted Forest"] = true },
	DropAtSafeZone = false,
	AntiGuardPanel = true,
	AntiGuardEnabled = false,
	AntiGuardBusy = false,       -- diisi loop anti-guard; cycle farm nunggu kalau true
}

--[=[ [1] SAFEBOOT ]=]
print(string.format("[%s] v%s loaded — tab Farm aktif", EggHub.Name, EggHub.Version))

local function Protect(label, fn, ...)
	local ok, result = pcall(fn, ...)
	if not ok then
		warn(string.format("[%s] %s gagal: %s", EggHub.Name, label, tostring(result)))
	end
	return ok, result
end

--[=[ [2] GAMEBRIDGE — kode game: services, character, module game, scan workspace ]=]
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local GameBridge = {}

function GameBridge.Character()
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	return character, root
end

function GameBridge.Root()
	local _, root = GameBridge.Character()
	return root
end

-- Pola chili (baris 11800): require module game lewat pcall, gagal = nil bukan crash.
local function SafeRequire(getter)
	local ok, moduleRef = pcall(getter)
	if not ok or not moduleRef then
		return nil
	end
	local okRequire, loaded = pcall(function()
		return require(moduleRef)
	end)
	return okRequire and loaded or nil
end

local GameModules = {
	EggState = SafeRequire(function()
		return ReplicatedStorage.Client.EggState
	end),
	Assets = SafeRequire(function()
		return ReplicatedStorage.Data.Assets
	end),
	HalloweenPets = SafeRequire(function()
		return ReplicatedStorage.Data.HalloweenPets
	end),
}

-- Katalog area: fallback + augmentasi live dari Record AreaId (chili 14052-14073).
local AreaNames = {}
do
	for _, areaName in ipairs(Config.FallbackAreas) do
		table.insert(AreaNames, areaName)
	end
	local seen = {}
	for _, areaName in ipairs(AreaNames) do
		seen[areaName] = true
	end
	Protect("katalog area", function()
		local eggState = GameModules.EggState
		local readOk, records = pcall(function()
			return eggState and eggState.ReadFieldEggs() or nil
		end)
		local recordList = readOk and type(records) == "table" and records.Records or nil
		if type(recordList) ~= "table" then
			return
		end
		for _, record in pairs(recordList) do
			local areaId = type(record) == "table" and record.AreaId or nil
			if type(areaId) == "string" and not seen[areaId] then
				seen[areaId] = true
				table.insert(AreaNames, areaId)
			end
		end
	end)
end

-- Katalog rarity: rank + nama dari Assets.Directory (chili 14076-14100).
local RarityRankByName = { Any = 0 }
local RarityOptions = { "Any" }
do
	local rankByNumber = {}
	Protect("katalog rarity", function()
		local directory = GameModules.Assets and GameModules.Assets.Directory
		if type(directory) ~= "table" then
			return
		end
		for _, entry in pairs(directory) do
			local rarity = type(entry) == "table" and entry.Rarity or nil
			local rank = type(rarity) == "table" and tonumber(rarity.RarityNumber or rarity.Rank) or nil
			if rank then
				rankByNumber[rank] = rankByNumber[rank] or tostring(rarity.DisplayName or rank)
			end
		end
	end)
	if next(rankByNumber) == nil then
		for rank, rarityName in ipairs(Config.FallbackRarities) do
			rankByNumber[rank] = rarityName
		end
	end
	local numbers = {}
	for rank in pairs(rankByNumber) do
		table.insert(numbers, rank)
	end
	table.sort(numbers)
	for _, rank in ipairs(numbers) do
		table.insert(RarityOptions, rankByNumber[rank])
		RarityRankByName[rankByNumber[rank]] = rank
	end
end

-- Katalog nama egg (buat dropdown Target Spesifik Egg) dari Specs HalloweenPets.
local EggNames = {}
do
	Protect("katalog egg", function()
		local specs = GameModules.HalloweenPets and GameModules.HalloweenPets.Specs
		if type(specs) ~= "table" then
			return
		end
		for specKey, spec in pairs(specs) do
			local displayName = type(spec) == "table" and (spec.DisplayName or spec.Name) or nil
			table.insert(EggNames, tostring(displayName or specKey))
		end
	end)
	table.sort(EggNames)
end

-- Record egg live (uid -> record) buat rarity/scale/area per egg field.
function GameBridge.EggRecords()
	local eggState = GameModules.EggState
	local ok, records = pcall(function()
		return eggState and eggState.ReadFieldEggs() or nil
	end)
	local recordList = ok and type(records) == "table" and records.Records or nil
	return type(recordList) == "table" and recordList or {}
end

-- Instance egg di field: turunan folder Areas yang bawa atribut uid (chili 30722).
function GameBridge.FieldEggs()
	local worldRoot = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
	local areasFolder = worldRoot and worldRoot:FindFirstChild("Areas")
	local eggs = {}
	if not areasFolder then
		return eggs
	end
	for _, descendant in ipairs(areasFolder:GetDescendants()) do
		if descendant:GetAttribute(Config.Egg.UidAttribute) ~= nil then
			table.insert(eggs, descendant)
		end
	end
	return eggs
end

function GameBridge.EggIdentity(eggInstance)
	local uid = eggInstance:GetAttribute(Config.Egg.UidAttribute)
	local sourceName = eggInstance:GetAttribute(Config.Egg.SourceAttribute)
	local zone = eggInstance:GetAttribute(Config.Egg.ZoneAttribute)
	return uid, sourceName, zone
end

-- Part SafeZone + titik drop di dalamnya (chili 30708-30716): clamp posisi egg
-- ke extents safezone minus inset, Y pakai Y egg.
function GameBridge.SafeZoneDropPoint(fromPosition)
	local safeZone = Workspace:FindFirstChild(Config.SafeZone.PartName, true)
	if not safeZone or not safeZone:IsA("BasePart") then
		return nil
	end
	local localPoint = safeZone.CFrame:PointToObjectSpace(fromPosition)
	local halfX = math.max(safeZone.Size.X / 2 - Config.SafeZone.Inset, 0)
	local halfZ = math.max(safeZone.Size.Z / 2 - Config.SafeZone.Inset, 0)
	local clamped = safeZone.CFrame:PointToWorldSpace(Vector3.new(
		math.clamp(localPoint.X, -halfX, halfX),
		localPoint.Y,
		math.clamp(localPoint.Z, -halfZ, halfZ)
	))
	return Vector3.new(clamped.X, fromPosition.Y, clamped.Z), safeZone
end

-- Garis pemisah sisi aman (chili 16540-16546): X > SeparationLine = sisi aman.
function GameBridge.IsSafeSide(position)
	local worldRoot = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
	local areasFolder = worldRoot and worldRoot:FindFirstChild("Areas")
	local separationLine = areasFolder and areasFolder:FindFirstChild("SeparationLine")
	local lineX = separationLine and separationLine:IsA("BasePart") and separationLine.Position.X or 552
	return position.X > lineX
end

-- Guard NPC per area (chili 16621-16627): folder GuardAreas -> child -> Guard.
function GameBridge.ActiveGuardThreats()
	local threats = {}
	local guardFolder = Workspace:FindFirstChild(Config.Guard.FolderName, true)
	if not guardFolder then
		return threats
	end
	for _, areaEntry in ipairs(guardFolder:GetChildren()) do
		local guardModel = areaEntry:FindFirstChild(Config.Guard.ModelName)
		local guardRoot = guardModel and guardModel:FindFirstChild("HumanoidRootPart")
		if guardRoot then
			local guardState = guardModel:GetAttribute(Config.Guard.StateAttribute)
			if guardState ~= Config.Guard.SleepingState then
				table.insert(threats, { Root = guardRoot, State = tostring(guardState) })
			end
		end
	end
	return threats
end

-- Prompt pickup terdekat dari satu posisi (chili 16893-16894).
function GameBridge.NearestPickupPrompt(nearPosition)
	local bestPrompt, bestDistance = nil, math.huge
	for _, child in ipairs(Workspace:GetChildren()) do
		if child.Name == Config.Pickup.PromptPartName and child:IsA("BasePart") then
			local prompt = child:FindFirstChild(Config.Pickup.PromptName)
			if prompt and prompt:IsA("ProximityPrompt") then
				local distance = (child.Position - nearPosition).Magnitude
				if distance < bestDistance then
					bestDistance = distance
					bestPrompt = prompt
				end
			end
		end
	end
	return bestPrompt
end

-- Fire prompt pickup (chili 16194): matikan line-of-sight & hold dulu.
function GameBridge.FirePickupPrompt(prompt)
	if not prompt then
		return false
	end
	pcall(function()
		prompt.RequiresLineOfSight = false
		prompt.HoldDuration = 0
	end)
	if typeof(fireproximityprompt) == "function" then
		return pcall(function()
			fireproximityprompt(prompt)
		end)
	end
	return false
end

function GameBridge.IsCarrying()
	local character, _ = GameBridge.Character()
	local holder = character or LocalPlayer
	return holder:GetAttribute(Config.Carry.Attribute) == true
end

--[=[ [3] FARMCONTROLLER — logika farm (nol UI) ]=]
local FarmController = {}
EggHub.Farm = FarmController
FarmController.State = FarmState

-- Value egg = EarningRate * kurva scale (chili 30744-30747).
function FarmController.EggValue(eggInstance, record)
	local earningRate = type(record) == "table" and tonumber(record.EarningRate) or 0
	local scale = eggInstance:IsA("Model") and eggInstance:GetScale() or 1
	local curve
	if scale > Config.ValueCurve.BigBase then
		curve = (scale / Config.ValueCurve.BigBase) ^ Config.ValueCurve.BigExponent * Config.ValueCurve.BigMultiplier
	else
		curve = scale ^ Config.ValueCurve.SmallExponent
	end
	return earningRate * curve
end

function FarmController.RecordOf(uid, records)
	if uid == nil then
		return nil
	end
	for recordKey, record in pairs(records) do
		if tostring(recordKey) == tostring(uid) or (type(record) == "table" and tostring(record.Uid) == tostring(uid)) then
			return record
		end
	end
	return nil
end

-- Filter + prioritas persis mode chili (Best Rarity/Biggest Weight/Best Mutation/
-- Highest Value/Lowest Value).
function FarmController.PickTarget()
	local records = GameBridge.EggRecords()
	local candidates = {}
	for _, eggInstance in ipairs(GameBridge.FieldEggs()) do
		local uid, sourceName = GameBridge.EggIdentity(eggInstance)
		local record = FarmController.RecordOf(uid, records)
		if type(record) == "table" then
			local areaOk = next(FarmState.TargetAreas) == nil
				or FarmState.TargetAreas[tostring(record.AreaId)] == true
			local rarityName = "Any"
			local catalogEntry = GameModules.Assets and GameModules.Assets.Directory
				and GameModules.Assets.Directory[record.Category or record.AssetKey or ""]
			local rarityInfo = type(catalogEntry) == "table" and catalogEntry.Rarity or nil
			if type(rarityInfo) == "table" then
				rarityName = tostring(rarityInfo.DisplayName or rarityInfo._id or "Any")
			end
			local rarityOk = FarmState.TargetRarity == "Any"
				or (RarityRankByName[rarityName] or 0) >= (RarityRankByName[FarmState.TargetRarity] or 0)
			local value = FarmController.EggValue(eggInstance, record)
			local valueOk = value >= FarmState.MinStealValue
			local eggLabel = tostring(sourceName or record.DisplayName or record.Category or "")
			local specificOk = next(FarmState.TargetEggs) == nil or FarmState.TargetEggs[eggLabel] == true
			if areaOk and rarityOk and valueOk and specificOk then
				table.insert(candidates, {
					Instance = eggInstance,
					Record = record,
					Value = value,
					RarityRank = RarityRankByName[rarityName] or 0,
					Weight = tonumber(record.AssetScale or record.Scale) or 1,
					MutationCount = type(record.Mutations) == "table" and #record.Mutations or 0,
				})
			end
		end
	end
	if #candidates == 0 then
		return nil
	end
	local mode = FarmState.Priority
	table.sort(candidates, function(left, right)
		if mode == "Best Rarity" then
			return left.RarityRank > right.RarityRank
		elseif mode == "Biggest Weight" then
			return left.Weight > right.Weight
		elseif mode == "Best Mutation" then
			return left.MutationCount > right.MutationCount
		elseif mode == "Lowest Value" then
			return left.Value < right.Value
		end
		return left.Value > right.Value
	end)
	return candidates[1]
end

-- Mesin gerak: teleport pivot (chili 16548-16565) atau tween jalan.
local function ZeroVelocities(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			pcall(function()
				part.AssemblyLinearVelocity = Vector3.zero
				part.AssemblyAngularVelocity = Vector3.zero
			end)
		end
	end
end

local function SnapStrayParts(character, root)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part ~= root and (part.Position - root.Position).Magnitude > Config.Move.StrayPartRadius then
			pcall(function()
				part.CFrame = root.CFrame
				part.AssemblyLinearVelocity = Vector3.zero
			end)
		end
	end
end

local function TeleportTo(point)
	for _ = 1, Config.Move.TeleportRetries do
		local character, root = GameBridge.Character()
		if not character or not root then
			return false
		end
		local targetFrame = CFrame.new(point) * root.CFrame.Rotation
		pcall(function()
			character:PivotTo(targetFrame)
		end)
		if (root.Position - point).Magnitude > Config.Move.TeleportGap then
			pcall(function()
				root.CFrame = targetFrame
			end)
		end
		ZeroVelocities(character)
		SnapStrayParts(character, root)
		if (root.Position - point).Magnitude <= Config.Move.ArriveSnap then
			return true
		end
		task.wait(0.1)
	end
	return false
end

local function TweenTo(point, speedPercent)
	local character, root = GameBridge.Character()
	if not character or not root then
		return false
	end
	local distance = (point - root.Position).Magnitude
	if distance <= Config.Move.ArriveSnap then
		return true
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local walkSpeed = (humanoid and humanoid.WalkSpeed) or Config.Move.BaseWalkSpeed
	local effectiveSpeed = math.max(walkSpeed * (speedPercent / 100), 1)
	local tweenInfo = TweenInfo.new(distance / effectiveSpeed, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(root, tweenInfo, { CFrame = CFrame.new(point) * root.CFrame.Rotation })
	tween:Play()
	local deadline = os.clock() + (distance / effectiveSpeed) + 1
	while tween.PlaybackState == Enum.PlaybackState.Playing and os.clock() < deadline do
		task.wait(0.05)
	end
	tween:Cancel()
	return (root.Position - point).Magnitude <= Config.Move.ArriveSnap
end

local function StepTo(point, steps)
	local character, root = GameBridge.Character()
	if not character or not root then
		return false
	end
	local origin = root.Position
	for stepIndex = 1, steps do
		local ratio = stepIndex / steps
		local hopPoint = origin:Lerp(point, ratio)
		pcall(function()
			character:PivotTo(CFrame.new(hopPoint + Vector3.new(0, 0.2, 0)) * root.CFrame.Rotation)
		end)
		task.wait(0.05)
	end
	return TeleportTo(point)
end

function FarmController.MoveTo(point, options)
	options = options or {}
	if FarmState.AntiGuardBusy then
		return false
	end
	local method = options.Method or FarmState.StealMethod
	if options.ForceTeleport or FarmState.TeleportToEgg or method == "Teleport" then
		return TeleportTo(point)
	elseif method == "Step" then
		return StepTo(point, options.Steps or 3)
	end
	return TweenTo(point, options.SpeedPercent or FarmState.TweenSpeed)
end

-- Kirim egg yang lagi dibawa: V2 = tween cepat studs/s, steps = hop pivot,
-- biasa = tween carry speed (chili 14564-14730).
function FarmController.DeliverCarry(destination)
	if FarmState.InstantSteal and FarmState.InstantStealV2 then
		local root = GameBridge.Root()
		if not root then
			return false
		end
		local distance = (destination - root.Position).Magnitude
		local tweenInfo = TweenInfo.new(math.max(distance / FarmState.V2TweenSpeed, 0.05), Enum.EasingStyle.Linear)
		local tween = TweenService:Create(root, tweenInfo, { CFrame = CFrame.new(destination) * root.CFrame.Rotation })
		tween:Play()
		local deadline = os.clock() + (distance / FarmState.V2TweenSpeed) + 1
		while tween.PlaybackState == Enum.PlaybackState.Playing and os.clock() < deadline do
			task.wait(0.05)
		end
		tween:Cancel()
		return true
	elseif FarmState.InstantSteal then
		return StepTo(destination, 3)
	end
	return TweenTo(destination, FarmState.CarrySpeed)
end

-- Loop anti-guard (chili 12987 + 18295-18301): guard bangun & dekat = pause cycle.
task.spawn(function()
	while true do
		task.wait(Config.Guard.ScanInterval)
		Protect("scan guard", function()
			if not FarmState.AntiGuardEnabled then
				FarmState.AntiGuardBusy = false
				return
			end
			local root = GameBridge.Root()
			if not root then
				return
			end
			local busy = false
			local closest = math.huge
			local worstState = ""
			for _, threat in ipairs(GameBridge.ActiveGuardThreats()) do
				local distance = (threat.Root.Position - root.Position).Magnitude
				if distance < Config.Guard.Radius then
					busy = true
					if distance < closest then
						closest = distance
						worstState = threat.State
					end
				end
			end
			FarmState.AntiGuardBusy = busy
			if EggHub.GuardStatusHook then
				EggHub.GuardStatusHook(busy, closest, worstState)
			end
		end)
	end
end)

-- Cycle farm utama: pilih -> jemput -> bawa -> drop, ulang.
task.spawn(function()
	while true do
		task.wait(Config.Move.CycleInterval)
		if FarmState.AutoSteal and not FarmState.AntiGuardBusy then
			Protect("cycle farm", function()
				local root = GameBridge.Root()
				if not root then
					return
				end
				if GameBridge.IsCarrying() then
					local dropPoint = GameBridge.SafeZoneDropPoint(root.Position)
					local destination = dropPoint
					if not FarmState.DropAtSafeZone and not FarmState.InstantSteal then
						if GameBridge.IsSafeSide(root.Position) then
							return -- udah sisi aman tanpa mode drop: tahan egg, cycle lanjut
						end
					end
					if destination then
						FarmController.DeliverCarry(destination)
					end
					return
				end
				local target = FarmController.PickTarget()
				if not target then
					return
				end
				local eggRoot = target.Instance:IsA("Model") and target.Instance:FindFirstChild("HumanoidRootPart", true)
					or (target.Instance:IsA("BasePart") and target.Instance or nil)
				if not eggRoot then
					return
				end
				FarmController.MoveTo(eggRoot.Position + Vector3.new(0, 1, 0))
				for _ = 1, Config.Pickup.Tries do
					if GameBridge.IsCarrying() then
						break
					end
					GameBridge.FirePickupPrompt(GameBridge.NearestPickupPrompt(eggRoot.Position))
					task.wait(Config.Pickup.RetryGap)
				end
			end)
		end
	end
end)

--[=[ [4] UIBRIDGE — kode library N3V4 (paling bawah): window, tab Farm, group Farm Egg ]=]
local Library = loadstring(game:HttpGet(Config.LibraryUrl))()
local MainWindow = Library:CreateWindow({
	Title = "N3 Hub",
	Footer = string.format("%s v%s", EggHub.Name, EggHub.Version),
	Icon = "rbxassetid://117688744510818",
	AutoShow = true,
	ToggleKeybind = Enum.KeyCode.RightControl,
})

local FarmTab = MainWindow:AddTab("Farm", "egg", "Auto steal egg field ala chili, nama komponen versi kita")
local GuardStatusGroup = nil -- forward: diisi AddRightGroupbox di bawah, dibaca callback toggle panel
local FarmGroup = FarmTab:AddLeftGroupbox("Farm Egg", "egg")

FarmGroup:AddDropdown("Farm_TargetAreas", {
	Text = "Target Areas",
	Values = AreaNames,
	Multi = true,
	Default = {},
	Callback = function(selected)
		FarmState.TargetAreas = type(selected) == "table" and selected or {}
	end,
})

FarmGroup:AddDropdown("Farm_TargetRarity", {
	Text = "Target Rarity",
	Values = RarityOptions,
	Default = "Any",
	Callback = function(selected)
		FarmState.TargetRarity = tostring(selected)
	end,
})

FarmGroup:AddSlider("Farm_MinStealValue", {
	Text = "Min Steal Value",
	Default = Config.Ranges.MinStealValue.Default,
	Min = Config.Ranges.MinStealValue.Min,
	Max = Config.Ranges.MinStealValue.Max,
	Rounding = 0,
	Prefix = "$",
	Compact = true,
	Callback = function(value)
		FarmState.MinStealValue = tonumber(value) or 0
	end,
})

FarmGroup:AddDropdown("Farm_TargetEggs", {
	Text = "Target Spesifik Egg",
	Values = EggNames,
	Multi = true,
	Default = {},
	Callback = function(selected)
		FarmState.TargetEggs = type(selected) == "table" and selected or {}
	end,
})

FarmGroup:AddDropdown("Farm_StealPriority", {
	Text = "Steal Priority",
	Values = Config.PriorityModes,
	Default = FarmState.Priority,
	Callback = function(selected)
		FarmState.Priority = tostring(selected)
	end,
})

FarmGroup:AddSlider("Farm_V2TweenSpeed", {
	Text = "Tween Speed",
	Default = Config.Ranges.V2TweenSpeed.Default,
	Min = Config.Ranges.V2TweenSpeed.Min,
	Max = Config.Ranges.V2TweenSpeed.Max,
	Rounding = 0,
	Suffix = " st/s",
	Tooltip = "Kecepatan tween cepat buat Instant Steal V2",
	Callback = function(value)
		FarmState.V2TweenSpeed = tonumber(value) or Config.Ranges.V2TweenSpeed.Default
	end,
})

FarmGroup:AddSlider("Farm_CarrySpeed", {
	Text = "Carry Speed",
	Default = Config.Ranges.CarrySpeedPercent.Default,
	Min = Config.Ranges.CarrySpeedPercent.Min,
	Max = Config.Ranges.CarrySpeedPercent.Max,
	Rounding = 0,
	Suffix = "%",
	Callback = function(value)
		FarmState.CarrySpeed = tonumber(value) or 100
	end,
})

FarmGroup:AddToggle("Farm_AutoSteal", {
	Text = "Auto Steal",
	Default = false,
	Callback = function(enabled)
		FarmState.AutoSteal = enabled == true
	end,
})

local InstantStealToggle = FarmGroup:AddToggle("Farm_InstantSteal", {
	Text = "Instan Steal",
	Default = false,
	Callback = function(enabled)
		FarmState.InstantSteal = enabled == true
	end,
})

-- Item 10: muncul cuma kalau Instan Steal aktif (DependencyBox).
local InstantDepbox = FarmGroup:AddDependencyBox()
InstantDepbox:SetupDependencies({ { InstantStealToggle, true } })
InstantDepbox:AddToggle("Farm_InstantStealV2", {
	Text = "Instan Steal V2",
	Default = false,
	Callback = function(enabled)
		FarmState.InstantStealV2 = enabled == true
	end,
})

FarmGroup:AddToggle("Farm_TeleportToEgg", {
	Text = "Teleport To Egg",
	Default = false,
	Callback = function(enabled)
		FarmState.TeleportToEgg = enabled == true
	end,
})

FarmGroup:AddDropdown("Farm_StealMethod", {
	Text = "Steal Method",
	Values = { "Teleport", "Step" },
	Default = FarmState.StealMethod,
	Callback = function(selected)
		FarmState.StealMethod = tostring(selected)
	end,
})

FarmGroup:AddSlider("Farm_TweenSpeed", {
	Text = "Tween Speed",
	Default = Config.Ranges.TweenSpeedPercent.Default,
	Min = Config.Ranges.TweenSpeedPercent.Min,
	Max = Config.Ranges.TweenSpeedPercent.Max,
	Rounding = 0,
	Suffix = "%",
	Tooltip = "Speed tween jalan/carry; di atas 100% bisa glitch (catatan chili)",
	Callback = function(value)
		FarmState.TweenSpeed = tonumber(value) or 100
	end,
})

FarmGroup:AddDropdown("Farm_TargetZones", {
	Text = "Target Zone",
	Values = Config.InstantZones,
	Multi = true,
	Default = Config.InstantZones,
	Callback = function(selected)
		FarmState.TargetZones = type(selected) == "table" and selected or {}
	end,
})

FarmGroup:AddToggle("Farm_DropAtSafeZone", {
	Text = "Drop Egg At Safe Zone",
	Default = false,
	Callback = function(enabled)
		FarmState.DropAtSafeZone = enabled == true
	end,
})

FarmGroup:AddToggle("Farm_AntiGuardPanel", {
	Text = "Anti Guard Panel",
	Default = true,
	Callback = function(enabled)
		FarmState.AntiGuardPanel = enabled == true
		if GuardStatusGroup then
			if FarmState.AntiGuardPanel then
				GuardStatusGroup:Show()
			else
				GuardStatusGroup:Hide()
			end
		end
	end,
})

-- Panel status guard (isi Anti Guard Panel): group kanan, toggle enable + label live.
GuardStatusGroup = FarmTab:AddRightGroupbox("Guard Status", "shield")
local GuardStatusLabel = GuardStatusGroup:AddLabel("Guard: aman (scan jalan)", true)
local GuardEnableToggle = GuardStatusGroup:AddToggle("Farm_AntiGuardEnabled", {
	Text = "Anti Guard Enabled",
	Default = false,
	Callback = function(enabled)
		FarmState.AntiGuardEnabled = enabled == true
	end,
})

EggHub.GuardStatusHook = function(busy, closestDistance, guardState)
	if not FarmState.AntiGuardPanel or not GuardStatusLabel then
		return
	end
	if busy then
		GuardStatusLabel:SetText(string.format("Guard: %s · %.0f stud — cycle PAUSE", guardState, closestDistance))
	else
		GuardStatusLabel:SetText("Guard: aman (scan jalan)")
	end
end

return EggHub

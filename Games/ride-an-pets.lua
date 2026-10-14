-- =====================================================================
-- N3 HUB - RIDE A PET (OFFICIAL UNIFIED EDITION)
-- UI Engine : N3-Library V3 (Chiyo Minimalist Style)
-- Core Engine : Chili Ride A Pet Core (Full Relay & Volcano)
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local GameRemotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Game")
local ActiveEggsFolder = ReplicatedStorage:WaitForChild("ServerData"):WaitForChild("ActiveEggs")

-- Helper Require Module
local function SafeRequire(pathFunc)
	local ok, res = pcall(function()
		return require(pathFunc())
	end)
	return ok and res or {}
end

local GameData = {
	Eggs = SafeRequire(function()
		return ReplicatedStorage.GameData.Eggs
	end),
	Pets = SafeRequire(function()
		return ReplicatedStorage.GameData.Pets
	end),
	Foods = SafeRequire(function()
		return ReplicatedStorage.GameData.Foods
	end),
	Shop = SafeRequire(function()
		return ReplicatedStorage.GameData.Shop
	end),
	Rebirths = SafeRequire(function()
		return ReplicatedStorage.GameData.Rebirths
	end),
	EggBaskets = SafeRequire(function()
		return ReplicatedStorage.GameData.EggBaskets
	end),
	Mutations = SafeRequire(function()
		return ReplicatedStorage.GameData.Mutations
	end),
	HatchLuck = SafeRequire(function()
		return ReplicatedStorage.GameData.HatchLuck
	end),
	PetAging = SafeRequire(function()
		return ReplicatedStorage.GameServices.PetAging
	end),
}

-- =====================================================================
-- CONFIG & RUNTIME STATE
-- =====================================================================
local FarmConfig = {
	-- Tab 1: Egg Loop
	SelectedEggs = {},
	SelectedRarities = {},
	SelectedMutations = {},
	FilterRule = "Match Any",
	AutoFarmEgg = false,
	AutoVolcanoDip = false,
	DipMinRank = 0,

	-- Tab 1: Egg Placement
	PlaceSelectedEggs = {},
	PlaceSelectedRarities = {},
	PlaceSelectedMutations = {},
	PlaceFilterRule = "Match Any",
	AutoPlaceEggs = false,
	AutoHatch = false,

	-- Tab 1: Server Hop & Plot
	NoTargetDelaySecs = 20,
	AutoHopEggs = false,
	Hop_Mode = "Least Players",
	AutoHopReload = true,
	ScriptURL = "",
	HatchUpgradeMode = "Smart Balance",
	AutoBuyHatchUpgrades = false,
	AutoUnlockNests = false,

	-- Tab 2: Pet Placement & Swap
	PlacePet_Names = {},
	PlacePet_Rarities = {},
	PlacePet_Mutations = {},
	PlacePet_FilterRule = "Match Any",
	AutoPlaceBestPets = false,

	ReplaceWith_Names = {},
	ReplaceWith_Rarities = {},
	ReplaceWith_Mutations = {},
	TargetReplace_Names = {},
	TargetReplace_Rarities = {},
	TargetReplace_Mutations = {},
	Replace_FilterRule = "Match Any",
	MinIncomeGain = 0,
	AutoReplaceLowerPets = false,

	-- Tab 2: Pet Selling
	Sell_Names = {},
	Sell_Rarities = {},
	Sell_Mutations = {},
	Sell_FilterRule = "Match Any",
	MinSellIncome = 0,
	MaxSellIncome = math.huge,
	MinSellWeightKg = 0,
	MaxSellWeightKg = math.huge,
	AutoSellSelected = false,
	AutoSellAllPets = false,

	-- Tab 2: Pet Income & Feed
	AutoCollectPetCash = false,

	Feed_Foods = {},
	Feed_PrioritizeBest = false,
	Feed_MinIncome = 0,
	Feed_MinAge = 0,
	Feed_Rarities = {},
	AutoFeedPets = false,

	-- Tab 3: Progress & Rewards
	Shop_Items = {},
	AutoBuySelectedItems = false,
	Shop_KeepCash = 0,
	AutoClaimSafeRewards = false,
	AutoRebirthWhenReady = false,

	-- Tab 4: ESP & Plot Gear
	ESP_Egg_Enabled = false,
	ESP_Egg_Names = {},
	ESP_Egg_Rarities = {},
	ESP_Egg_Mutations = {},
	ESP_Egg_FilterRule = "Match Any",

	ESP_Pet_Enabled = false,
	ESP_Pet_ShowMine = true,
	ESP_Pet_ShowOthers = false,
	ESP_Pet_Rarities = {},
	ESP_Pet_MinIncome = 0,

	Gear_Radars = {},
	AutoActivateRadar = false,
	Gear_Lanterns = {},
	AutoPlaceLantern = false,

	-- Tab 5: Webhook
	Webhook_URL = "",
	Webhook_Enabled = false,
	Webhook_IntervalMinutes = 5,
	Webhook_PingEveryone = false,
	Webhook_SendSummaryOnInterval = false,
	Webhook_Field_Player = true,
	Webhook_Field_Session = true,
	Webhook_Field_CashProgress = true,
	Webhook_Field_Inventory = true,
	Webhook_Field_PlacedPets = true,
	Webhook_Field_RecentPets = true,
	Webhook_Field_Plot = true,

	Webhook_SendOnClaimedEgg = true,
	Webhook_SendOnRarePet = true,
	Webhook_SendOnLightningMut = true,
	Webhook_SendOnWeather = true,
	Webhook_SendOnDisconnect = true,

	Webhook_Claimed_Eggs = {},
	Webhook_Claimed_Rarities = {},
	Webhook_Claimed_Mutations = {},
	Webhook_Claimed_Rule = "Match Any",
	Webhook_Weather_List = {},
	Webhook_Lightning_Mutations = {},
	Webhook_Pet_Rarities = {},
	Webhook_Always_Send_Pets = {},
	Webhook_MinHatchedIncome = 0,

	Webhook_PetField_Rarity = true,
	Webhook_PetField_Weight = true,
	Webhook_PetField_Income = true,
	Webhook_PetField_Mutations = true,

	-- Tab 1: Collect Priority (parity Chili)
	CollectPriority = "Highest Rarity",

	-- Tab Player (Movement utilities, parity Chili)
	Movement_SpeedBoost = false,
	Movement_BoostSpeed = 60,
	Movement_InfiniteJump = false,
	Movement_Noclip = false,
	InstanPickup = false,

	-- Tab Misc (Performance, parity Chili)
	AntiAFK_Enabled = true,
	FPS_Cap = 240,
	HideOtherPets_Enabled = false,
	Optimizer_Enabled = false,
	Disable3DRendering_Enabled = false,

	-- Engine Settings
	FlySpeed = 1000,
	CruiseHeight = 250,
}

local RuntimeState = {
	IsBusy = false,
	TargetEgg = nil,
	PickupPos = nil,
	LastPickupAt = 0,
	Relaying = false,
	Dipping = false,
	DipRemoteMissing = false,
	Carried = {},
	BlacklistedEggs = {},
	FeedCooldowns = {},
	HatchCooldowns = {},
	SellCooldowns = {},
	CashCooldowns = {},
	ActionCooldowns = {},
	Remotes = {},
	CachedSell = nil,
	CachedCash = nil,
	CachedNests = nil,
	HopServers = nil,
	LastHopAt = 0,
	RadarCooldown = 0,
	LanternCooldown = 0,
	NestCooldown = 0,
	ActiveESP = {},
	MyPlot = nil,
	SessionStartTime = os.clock(),
	LastEggFoundTime = os.clock(),
	LastWebhookSummaryTime = os.clock(),
	NoclipCollisions = {},
	HopBlacklist = {},
	RecentPets = {},
	StatusText = "Idle",
	UserNoclipParts = {},
	ManualEggs = {},
	CurrentEggTarget = nil,
	ShopStock = {},
}

-- List Data Dropdowns
local RARITY_ORDER = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Ethereal" }

local function CollectRarities(source)
	local found, order = {}, {}
	if type(source) ~= "table" then
		return found, order
	end
	for _, entry in pairs(source) do
		if type(entry) == "table" then
			local rarity = tostring(entry.Rarity or "")
			if rarity ~= "" and not found[rarity] then
				found[rarity] = true
				table.insert(order, rarity)
			end
		end
	end
	return found, order
end

local eggRarityFound, eggRarityOrder = CollectRarities(GameData.Eggs)
local petRarityFound, petRarityOrder = CollectRarities(GameData.Pets)

local RarityList = {}
for _, r in ipairs(RARITY_ORDER) do
	table.insert(RarityList, r)
end
local extraRarities = {}
for _, list in ipairs({ eggRarityOrder, petRarityOrder }) do
	for _, r in ipairs(list) do
		local known = false
		for _, existing in ipairs(RarityList) do
			if existing == r then
				known = true
				break
			end
		end
		if not known then
			table.insert(extraRarities, r)
		end
	end
end
table.sort(extraRarities)
for _, r in ipairs(extraRarities) do
	table.insert(RarityList, r)
end

local RarityRanks = {}
for i, r in ipairs(RarityList) do
	RarityRanks[r] = i
end

local RarityChoices = { "Any" }
for _, r in ipairs(RarityList) do
	table.insert(RarityChoices, r)
end

local EggNamesList = {}
for n, _ in pairs(GameData.Eggs) do
	table.insert(EggNamesList, tostring(n))
end
table.sort(EggNamesList)

local PetNamesList = {}
for n, _ in pairs(GameData.Pets) do
	table.insert(PetNamesList, tostring(n))
end
table.sort(PetNamesList)

local MutationList = { "None" }
for n, _ in pairs(GameData.Mutations) do
	table.insert(MutationList, tostring(n))
end
table.sort(MutationList)

local FoodList = {}
for n, _ in pairs(GameData.Foods) do
	table.insert(FoodList, tostring(n))
end
table.sort(FoodList)

local ShopItemList = {}
for category, cat in pairs(GameData.Shop) do
	if type(cat) == "table" then
		for n, entry in pairs(cat) do
			if type(entry) == "table" then
				table.insert(ShopItemList, tostring(n))
			end
		end
	end
end
table.sort(ShopItemList)

-- Map item -> category (buat cek stock di label Stock)
local ShopItemCategoryMap = {}
for category, cat in pairs(GameData.Shop) do
	if type(cat) == "table" then
		for n, entry in pairs(cat) do
			if type(entry) == "table" then
				ShopItemCategoryMap[tostring(n)] = tostring(category)
			end
		end
	end
end

local RadarList = {}
local LanternList = {}
for n, _ in pairs(GameData.Shop.Gears or {}) do
	local low = string.lower(tostring(n))
	if string.find(low, "radar") then
		table.insert(RadarList, tostring(n))
	elseif string.find(low, "lantern") or string.find(low, "lamp") then
		table.insert(LanternList, tostring(n))
	end
end
table.sort(RadarList)
table.sort(LanternList)

-- =====================================================================
-- CHILI ADVANCED ENGINE CORE
-- =====================================================================
local ChiliEngine = {}

function ChiliEngine.GetRoot()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	return (hrp and hrp:IsDescendantOf(Workspace)) and hrp or nil
end

function ChiliEngine.GetHumanoid()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	return (hum and hum.Health > 0) and hum or nil
end

function ChiliEngine.SetNoclip(enabled)
	local char = LocalPlayer.Character
	if not char then
		return
	end

	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			if enabled then
				if RuntimeState.NoclipCollisions[part] == nil then
					RuntimeState.NoclipCollisions[part] = part.CanCollide
				end
				part.CanCollide = false
			elseif RuntimeState.NoclipCollisions[part] ~= nil then
				part.CanCollide = RuntimeState.NoclipCollisions[part]
			end
		end
	end
	if not enabled then
		table.clear(RuntimeState.NoclipCollisions)
	end
end

function ChiliEngine.GetPlot()
	if RuntimeState.MyPlot and RuntimeState.MyPlot.Parent then
		local data = RuntimeState.MyPlot:FindFirstChild("Data")
		local owner = data and data:FindFirstChild("Owner")
		if owner and owner.Value == LocalPlayer then
			return RuntimeState.MyPlot
		end

		local sign = RuntimeState.MyPlot:FindFirstChild("PlotSign")
		sign = sign and sign:FindFirstChild("PlayerPlotSign")
		sign = sign and sign:FindFirstChild("Frame")
		local label = sign and sign:FindFirstChild("PlayerName")
		if label and label:IsA("TextLabel") then
			if
				string.lower(label.Text) == string.lower(LocalPlayer.Name)
				or string.lower(label.Text) == string.lower(LocalPlayer.DisplayName)
			then
				return RuntimeState.MyPlot
			end
		end
	end

	local plots = Workspace:FindFirstChild("Plots")
	if not plots then
		return nil
	end

	local nameCheck = {}
	local best, bestDist = nil, math.huge

	for _, p in ipairs(plots:GetChildren()) do
		local data = p:FindFirstChild("Data")
		local owner = data and data:FindFirstChild("Owner")
		if owner and owner.Value == LocalPlayer then
			RuntimeState.MyPlot = p
			return p
		end

		local sign = p:FindFirstChild("PlotSign")
		sign = sign and sign:FindFirstChild("PlayerPlotSign")
		sign = sign and sign:FindFirstChild("Frame")
		local label = sign and sign:FindFirstChild("PlayerName")

		if label and label:IsA("TextLabel") then
			nameCheck[label.Text] = p
		end

		local ok, cf, size = pcall(function()
			return p:GetBoundingBox()
		end)
		if ok and cf and size then
			local d = (cf.Position - (ChiliEngine.GetRoot() and ChiliEngine.GetRoot().Position or cf.Position)).Magnitude
			if d < bestDist then
				bestDist = d
				best = p
			end
		end
	end

	local mine = nameCheck[string.lower(LocalPlayer.Name)] or nameCheck[string.lower(LocalPlayer.DisplayName)]
	if mine then
		RuntimeState.MyPlot = mine
		return mine
	end

	if best and bestDist <= 250 then
		RuntimeState.MyPlot = best
		return best
	end

	return nil
end

function ChiliEngine.GetPlotBase()
	local p = ChiliEngine.GetPlot()
	local base = p and p:FindFirstChild("Baseplate")
	return (base and base:IsA("BasePart")) and base or nil
end

function ChiliEngine.GetPlotTop()
	local base = ChiliEngine.GetPlotBase()
	if not base then
		return nil
	end
	return base.Position + Vector3.new(0, base.Size.Y / 2, 0)
end

function ChiliEngine.GetPlacedPets()
	local plot = ChiliEngine.GetPlot()
	local pets = plot and plot:FindFirstChild("Pets")
	return (pets and pets:GetChildren()) or {}
end

function ChiliEngine.GetMaxPets()
	local saved = LocalPlayer:FindFirstChild("SavedData")
	local maxP = saved and saved:FindFirstChild("MaxPets") and tonumber(saved.MaxPets.Value)
	return math.max(1, tonumber(LocalPlayer:GetAttribute("MaxPets")) or maxP or 5)
end

function ChiliEngine.GetSavedNumber(field)
	local saved = LocalPlayer:FindFirstChild("SavedData")
	local child = saved and saved:FindFirstChild(field)
	local value = tonumber(child and child.Value)
	if value == nil then
		value = tonumber(LocalPlayer:GetAttribute(field))
	end
	return value or 0
end

function ChiliEngine.GetCash()
	return ChiliEngine.GetSavedNumber("Cash")
end

function ChiliEngine.GetShopEntry(category, item)
	local cat = GameData.Shop[category]
	if type(cat) ~= "table" then
		return nil
	end
	return cat[tostring(item)] or nil
end

function ChiliEngine.FindShopItem(item)
	local needle = string.lower(tostring(item or ""))
	if needle == "" then
		return nil, nil
	end
	for category, cat in pairs(GameData.Shop) do
		if type(cat) == "table" then
			for name, entry in pairs(cat) do
				if type(entry) == "table" and string.lower(tostring(name)) == needle then
					return category, entry
				end
			end
		end
	end
	return nil, nil
end

function ChiliEngine.GetOwnedAmount(item)
	local count = 0
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
	local holders = { backpack, LocalPlayer.Character }
	for _, holder in ipairs(holders) do
		if holder then
			for _, child in ipairs(holder:GetChildren()) do
				if child:IsA("Tool") and string.lower(child.Name) == string.lower(tostring(item)) then
					count += 1
				end
			end
		end
	end
	return count
end

function ChiliEngine.GetShopPrice(category, item)
	local entry = ChiliEngine.GetShopEntry(category, item)
	if type(entry) ~= "table" then
		return nil
	end
	return tonumber(entry.Price or entry.Cost or entry.CashCost)
end

function ChiliEngine.GetRandomPlotPoint(margin, existing, minDist)
	local base = ChiliEngine.GetPlotBase()
	if not base then
		return nil
	end
	local sX = math.max(1, base.Size.X / 2 - (margin or 6))
	local sZ = math.max(1, base.Size.Z / 2 - (margin or 6))
	local topY = base.Position.Y + base.Size.Y / 2
	local rng = Random.new()

	for _ = 1, 24 do
		local offset = Vector3.new(rng:NextNumber(-sX, sX), 0, rng:NextNumber(-sZ, sZ))
		local world = base.CFrame:PointToWorldSpace(offset)
		local candidate = Vector3.new(world.X, topY, world.Z)
		local valid = true

		if existing then
			for _, p in ipairs(existing) do
				if Vector3.new(p.X - candidate.X, 0, p.Z - candidate.Z).Magnitude < (minDist or 5) then
					valid = false
					break
				end
			end
		end
		if valid then
			return candidate
		end
	end
	return Vector3.new(base.Position.X, topY, base.Position.Z)
end

function ChiliEngine.GetBasketCount()
	local b = LocalPlayer:FindFirstChild("Basket")
	return b and #b:GetChildren() or 0
end

function ChiliEngine.GetBasketCapacity()
	local saved = LocalPlayer:FindFirstChild("SavedData")
	local equipped = saved and saved:FindFirstChild("EquippedEggBasket")
	local data = equipped and GameData.EggBaskets[tostring(equipped.Value)]
	local cap = data and tonumber(data.Capacity) or 1
	return math.clamp(cap, 1, 50)
end

function ChiliEngine.GetBasketDeadline()
	local b = LocalPlayer:FindFirstChild("Basket")
	if not b then
		return nil
	end
	local earliest = nil
	for _, child in ipairs(b:GetChildren()) do
		local breakAt = tonumber(child:GetAttribute("BreakAt"))
		if breakAt and (earliest == nil or breakAt < earliest) then
			earliest = breakAt
		end
	end
	return earliest
end

-- Volcano Handling
local VolcanoTop = {
	Center = Vector3.new(-5103, 41405, -3490),
	Half = Vector2.new(150, 156),
	BaseY = 40281,
	BaseRadius = 840,
	DoorCFrame = CFrame.new(
		-4939.84,
		41284.7,
		-3679.98,
		0.746841,
		0.03653,
		-0.663999,
		0.066451,
		0.989393,
		0.129173,
		0.661675,
		-0.140595,
		0.736491
	),
}
function ChiliEngine.GetVolcanoTop()
	local vol = Workspace:FindFirstChild("Volcano")
	local top = vol and vol:FindFirstChild("VolcanoTop")

	if top and top:IsA("BasePart") then
		VolcanoTop.Center = top.Position
		VolcanoTop.Half = Vector2.new(top.Size.X / 2, top.Size.Z / 2)
	end

	return VolcanoTop
end

function ChiliEngine.InVolcanoArea(pos)
	local vt = ChiliEngine.GetVolcanoTop()
	local diff = Vector3.new(pos.X - vt.Center.X, 0, pos.Z - vt.Center.Z)
	if pos.Y >= vt.Center.Y + 20 or pos.Y < vt.BaseY - 40 then
		return false
	end
	local factor = math.clamp((pos.Y - vt.BaseY) / math.max(1, vt.Center.Y - vt.BaseY), 0, 1)
	return diff.Magnitude < vt.BaseRadius + (math.min(vt.Half.X, vt.Half.Y) - vt.BaseRadius) * factor - 30
end

function ChiliEngine.GetVolcanoDoor()
	local vol = Workspace:FindFirstChild("Volcano")
	local ent = vol and vol:FindFirstChild("VolcanoEntrance")

	if (not ent or not ent:IsA("BasePart")) and vol then
		for _, d in ipairs(vol:GetDescendants()) do
			if d:IsA("BasePart") then
				local low = string.lower(d.Name)
				if string.find(low, "entrance") or string.find(low, "door") or string.find(low, "entry") then
					ent = d
					break
				end
			end
		end
	end

	if ent and ent:IsA("BasePart") then
		VolcanoTop.DoorCFrame = ent.CFrame
	end
	local cf = VolcanoTop.DoorCFrame
	local look = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
	if look.Magnitude < 0.01 then
		return nil, nil
	end
	local unit = look.Unit
	return cf.Position + unit * 30, cf.Position - unit * 40
end

function ChiliEngine.GetWaypoints(startPos, targetPos)
	if
		Vector3.new(targetPos.X - startPos.X, 0, targetPos.Z - startPos.Z).Magnitude < 80
		and math.abs(targetPos.Y - startPos.Y) < 30
	then
		return { targetPos }
	end
	local apex = math.max(startPos.Y, targetPos.Y) + FarmConfig.CruiseHeight
	if ChiliEngine.InVolcanoArea(startPos) or ChiliEngine.InVolcanoArea(targetPos) then
		apex = math.max(apex, ChiliEngine.GetVolcanoTop().Center.Y + 60)
	end
	local mid = (startPos + targetPos) / 2
	return { Vector3.new(mid.X, apex, mid.Z), targetPos }
end

local function HoldNoclip()
	ChiliEngine.SetNoclip(true)
	local conn
	conn = RunService.Stepped:Connect(function()
		local char = LocalPlayer.Character
		if not char then
			return
		end
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end)
	return conn
end

function ChiliEngine.ReleaseNoclip(keepalive)
	if keepalive then
		keepalive:Disconnect()
	end
	ChiliEngine.SetNoclip(false)
end

function ChiliEngine.MoveLine(targetPos, speed, breakCond)
	local root = ChiliEngine.GetRoot()
	if not root or typeof(targetPos) ~= "Vector3" then
		return false
	end
	local keepalive = HoldNoclip()

	local startPos = root.Position
	local dur = math.max(0.05, (targetPos - startPos).Magnitude / math.max(tonumber(speed) or 60, 1))
	local elapsed = 0
	local ok = true

	while elapsed < dur do
		if breakCond and breakCond() then
			ok = false
			break
		end
		elapsed += RunService.Heartbeat:Wait()
		root = ChiliEngine.GetRoot()
		if not root then
			ok = false
			break
		end

		local alpha = math.min(1, elapsed / dur)
		pcall(function()
			local rot = root.CFrame.Rotation
			root.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha)) * rot
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	ChiliEngine.ReleaseNoclip(keepalive)
	return ok
end

function ChiliEngine.FlyTo(targetPos, breakCond, threshold)
	local root = ChiliEngine.GetRoot()
	if not root or typeof(targetPos) ~= "Vector3" then
		return false
	end
	local limit = threshold or 3
	if (root.Position - targetPos).Magnitude <= limit then
		return true
	end

	local waypoints = ChiliEngine.GetWaypoints(root.Position, targetPos)
	local dist = 0
	local p = root.Position
	for _, wp in ipairs(waypoints) do
		dist += (wp - p).Magnitude
		p = wp
	end

	local timeout = os.clock() + (dist / math.max(FarmConfig.FlySpeed, 20)) + 6
	local wpIndex = 1
	local success = false

	local keepalive = HoldNoclip()

	while os.clock() < timeout do
		if breakCond and breakCond() then
			break
		end
		local dt = RunService.Heartbeat:Wait()
		root = ChiliEngine.GetRoot()
		if not root then
			break
		end

		local current = waypoints[wpIndex]
		local isLast = (wpIndex == #waypoints)
		local delta = current - root.Position
		local mag = delta.Magnitude

		if mag <= (isLast and limit or 2) then
			if isLast then
				success = true
				break
			else
				wpIndex += 1
			end
		else
			local moveStep = math.min(mag, math.max(FarmConfig.FlySpeed, 20) * dt)
			local flat = Vector3.new(delta.X, 0, delta.Z)
			local look = flat.Magnitude > 0.1 and CFrame.lookAt(Vector3.zero, flat.Unit) or root.CFrame.Rotation

			pcall(function()
				root.CFrame = CFrame.new(root.Position + delta.Unit * moveStep) * look
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end)
		end
	end

	ChiliEngine.ReleaseNoclip(keepalive)
	root = ChiliEngine.GetRoot()
	if root then
		pcall(function()
			root.AssemblyLinearVelocity = Vector3.zero
		end)
		if (root.Position - targetPos).Magnitude <= limit + 1 then
			success = true
		end
	end
	return success
end

function ChiliEngine.VolcanoApproach(targetPos, breakCond, threshold)
	if LocalPlayer:GetAttribute("InVolcano") ~= true or LocalPlayer:GetAttribute("VolcanoValidated") ~= true then
		local outDoor, inDoor = ChiliEngine.GetVolcanoDoor()
		if outDoor and inDoor then
			if not ChiliEngine.FlyTo(outDoor, breakCond, 4) then
				return false
			end
			if not ChiliEngine.MoveLine(inDoor, 40, breakCond) then
				return false
			end
		else
			return ChiliEngine.FlyTo(targetPos, breakCond, threshold)
		end
	end
	ChiliEngine.MoveLine(targetPos, 250, breakCond)
	local root = ChiliEngine.GetRoot()
	return root and (root.Position - targetPos).Magnitude <= (threshold or 3) + 2
end

function ChiliEngine.VolcanoExit(breakCond)
	local outDoor, inDoor = ChiliEngine.GetVolcanoDoor()
	if not outDoor or not inDoor then
		return false
	end
	if not ChiliEngine.MoveLine(inDoor, 250, breakCond) then
		return false
	end
	return ChiliEngine.MoveLine(outDoor, 40, breakCond)
end

-- Volcano Dip (celup telur ke lava buat dapet mutasi)
function ChiliEngine.DipDebug(msg)
	local slot = "DipDebug"
	if (RuntimeState.ActionCooldowns[slot] or 0) > os.clock() then
		return
	end
	RuntimeState.ActionCooldowns[slot] = os.clock() + 10
	print("[N3 HUB] Volcano: " .. msg)
end

function ChiliEngine.GetDipRemote()
	local cached = RuntimeState.Remotes["VolcanoDip"]
	if cached and cached.Parent then
		return cached
	end

	local function scan(root)
		if not root then
			return nil
		end
		local exact = root:FindFirstChild("RE/VolcanoDip")
		if exact then
			return exact
		end
		for _, child in ipairs(root:GetChildren()) do
			if string.find(string.lower(child.Name), "volcanodip", 1, true) then
				return child
			end
		end
		return nil
	end

	local rem = scan(ReplicatedStorage.packages and ReplicatedStorage.packages.Net)
		or scan(ReplicatedStorage.Packages and ReplicatedStorage.Packages.Networking)
		or scan(ReplicatedStorage.Packages and ReplicatedStorage.Packages.Net)
		or scan(ReplicatedStorage.Remotes and ReplicatedStorage.Remotes.Game)

	if rem then
		RuntimeState.Remotes["VolcanoDip"] = rem
		return rem
	end

	if not RuntimeState.DipRemoteMissing then
		RuntimeState.DipRemoteMissing = true
		warn("[N3 HUB] Volcano: RE/VolcanoDip remote not found in packages.Net / Packages.Networking / Remotes.Game")
	end
	return nil
end

function ChiliEngine.DipDiagnose()
	local basket = LocalPlayer:FindFirstChild("Basket")
	local parts = {}
	parts[#parts + 1] = "dipOn=" .. tostring(FarmConfig.AutoVolcanoDip)
	parts[#parts + 1] = "farmOn=" .. tostring(FarmConfig.AutoFarmEgg)
	parts[#parts + 1] = "minRank=" .. tostring(FarmConfig.DipMinRank)
	parts[#parts + 1] = "remote=" .. tostring(ChiliEngine.GetDipRemote() ~= nil)
	parts[#parts + 1] = "plotTop=" .. tostring(ChiliEngine.GetPlotTop() ~= nil)
	parts[#parts + 1] = "hover=" .. tostring(ChiliEngine.GetVolcanoHover())
	parts[#parts + 1] = "root=" .. tostring(ChiliEngine.GetRoot() ~= nil)
	parts[#parts + 1] = "basket=" .. ChiliEngine.GetBasketCount()
	parts[#parts + 1] = "ready=" .. tostring(ChiliEngine.DipCandidateReady())

	if basket then
		for _, child in ipairs(basket:GetChildren()) do
			local attrs = {}
			for name, value in child:GetAttributes() do
				attrs[#attrs + 1] = name .. "=" .. tostring(value)
			end
			parts[#parts + 1] = "  egg[" .. child.Name .. "] {" .. table.concat(attrs, ", ") .. "}"
		end
	end

	print("[N3 HUB] VolcanoDiag: " .. table.concat(parts, " | "))
end

function ChiliEngine.GetVolcanoHover()
	return ChiliEngine.GetVolcanoTop().Center + Vector3.new(0, 60, 0)
end

function ChiliEngine.EggRank(eggType)
	local meta = GameData.Eggs[tostring(eggType)] or {}
	return RarityRanks[tostring(meta.Rarity or "Common")] or 1
end

function ChiliEngine.EggNeedsVolcano(eggType)
	local meta = GameData.Eggs[tostring(eggType)]
	return meta ~= nil and meta.RequiresVolcano == true
end

function ChiliEngine.EggBreakSeconds(eggType)
	local meta = GameData.Eggs[tostring(eggType)]
	return (meta and tonumber(meta.BreakSeconds)) or 30
end

function ChiliEngine.EggLuck(eggType)
	local meta = GameData.Eggs[tostring(eggType)]
	return (meta and tonumber(meta.Luck)) or 0
end

function ChiliEngine.IsEggCollected(eggType)
	local collected = LocalPlayer:GetAttribute("CollectedEggs")
	if type(collected) ~= "string" or collected == "" then
		return false
	end
	return string.find(collected, tostring(eggType) .. ",", 1, true) ~= nil
end

function ChiliEngine.TravelTime(from, to)
	local dist = 0
	local cur = from
	for _, wp in ipairs(ChiliEngine.GetWaypoints(from, to)) do
		dist += (wp - cur).Magnitude
		cur = wp
	end
	return dist / math.max(FarmConfig.FlySpeed, 20)
end

function ChiliEngine.DipCandidateReady()
	local basket = LocalPlayer:FindFirstChild("Basket")
	if not basket then
		return false
	end
	for _, child in ipairs(basket:GetChildren()) do
		local eggType = child:GetAttribute("Egg")
		local ok = child:GetAttribute("VolcanoDipped") ~= true
			and not ChiliEngine.EggNeedsVolcano(eggType)
			and ChiliEngine.EggRank(eggType) >= FarmConfig.DipMinRank
		if ok then
			return true
		end
	end
	return false
end

function ChiliEngine.DipInProgress()
	local basket = LocalPlayer:FindFirstChild("Basket")
	if not basket then
		return false
	end
	for _, child in ipairs(basket:GetChildren()) do
		if child:GetAttribute("VolcanoUntil") ~= nil then
			return true
		end
	end
	return false
end

function ChiliEngine.DipWindowOpen()
	local root = ChiliEngine.GetRoot()
	local plotTop = ChiliEngine.GetPlotTop()
	local deadline = ChiliEngine.GetBasketDeadline()
	if not root or not plotTop or not deadline then
		return true
	end

	local hover = ChiliEngine.GetVolcanoHover()
	local need = ChiliEngine.TravelTime(root.Position, hover) + ChiliEngine.TravelTime(hover, plotTop) + 6

	return (deadline - Workspace:GetServerTimeNow()) >= need
end

function ChiliEngine.VolcanoDip()
	if RuntimeState.Dipping or not FarmConfig.AutoVolcanoDip then
		return false
	end
	if (RuntimeState.ActionCooldowns["Dip"] or 0) > os.clock() then
		return false
	end

	local net = ChiliEngine.GetDipRemote()
	local root = ChiliEngine.GetRoot()
	local plotTop = ChiliEngine.GetPlotTop()
	if not ChiliEngine.DipCandidateReady() then
		return false
	end
	if not net or not root or not plotTop then
		ChiliEngine.DipDiagnose()
		return false
	end

	local hover = ChiliEngine.GetVolcanoHover()
	if not ChiliEngine.DipWindowOpen() then
		ChiliEngine.DipDebug("skip - egg breaks before the round trip")
		return false
	end

	RuntimeState.ActionCooldowns["Dip"] = os.clock() + 5
	RuntimeState.Dipping = true

	local reached = ChiliEngine.FlyTo(hover, function()
		return not FarmConfig.AutoVolcanoDip
	end, 6)
	if not reached then
		RuntimeState.Dipping = false
		ChiliEngine.DipDebug("skip - FlyTo could not reach the hover point")
		return false
	end

	local dipped = false
	for _ = 1, 4 do
		if not ChiliEngine.DipCandidateReady() then
			break
		end
		pcall(function()
			net:FireServer()
		end)

		local t0 = os.clock()
		local confirmed = false
		while (os.clock() - t0) < 14 do
			local r = ChiliEngine.GetRoot()
			if r then
				pcall(function()
					r.CFrame = CFrame.new(hover) * r.CFrame.Rotation
					r.AssemblyLinearVelocity = Vector3.zero
				end)
			end
			RunService.Heartbeat:Wait()

			if ChiliEngine.DipInProgress() then
				confirmed = true
			elseif (os.clock() - t0) > 1.5 then
				break
			end
		end
		dipped = dipped or confirmed
	end

	RuntimeState.Dipping = false

	if dipped then
		ChiliEngine.DipDebug("dip confirmed")
	end

	if LocalPlayer:GetAttribute("InVolcano") == true then
		ChiliEngine.VolcanoExit(nil)
	end

	return dipped
end

-- Relay Re-picking System (Chili fn10)
function ChiliEngine.RelayRepickNearBase(plotBase, plotTop, breakCond)
	local root = ChiliEngine.GetRoot()
	local basket = LocalPlayer:FindFirstChild("Basket")
	if not root or not basket then
		return
	end

	local localPos = plotBase.CFrame:PointToObjectSpace(root.Position)
	local flat = Vector3.new(localPos.X, 0, localPos.Z)
	if flat.Magnitude < 1 then
		flat = Vector3.new(0, 0, 1)
	end

	local hX = plotBase.Size.X / 2
	local hZ = plotBase.Size.Z / 2
	local unit = flat.Unit
	local factor = unit / math.max(math.abs(unit.X) / (hX + 20), math.abs(unit.Z) / (hZ + 20))
	local relayWorld = plotBase.CFrame:PointToWorldSpace(Vector3.new(factor.X, 0, factor.Z))
	local relaySpot = Vector3.new(relayWorld.X, plotTop.Y + 4, relayWorld.Z)

	ChiliEngine.FlyTo(relaySpot, breakCond, 4)
	local r = ChiliEngine.GetRoot()
	if not r or (r.Position - relaySpot).Magnitude > 10 then
		return
	end

	local initialEggs = {}
	for _, child in ipairs(ActiveEggsFolder:GetChildren()) do
		initialEggs[child] = true
	end

	local basketEggs = {}
	for _, child in ipairs(basket:GetChildren()) do
		local eggType = child:GetAttribute("Egg")
		if type(eggType) == "string" then
			table.insert(basketEggs, eggType)
		end
	end

	RuntimeState.Relaying = true
	for _, eggType in ipairs(basketEggs) do
		pcall(function()
			GameRemotes.BasketDrop:FireServer(eggType)
		end)
	end

	local counts = {}
	for _, t in ipairs(basketEggs) do
		counts[t] = (counts[t] or 0) + 1
	end

	local newSpawned = {}
	local scanEnd = os.clock() + 3.0
	while #newSpawned < #basketEggs and os.clock() < scanEnd do
		for _, child in ipairs(ActiveEggsFolder:GetChildren()) do
			if
				not initialEggs[child]
				and child:GetAttribute("OriginPosition") ~= nil
				and typeof(child:GetAttribute("Position")) == "Vector3"
			then
				initialEggs[child] = true
				local eType = child:GetAttribute("Egg")
				if eType and (counts[eType] or 0) > 0 then
					counts[eType] -= 1
					table.insert(newSpawned, child)
				end
			end
		end
		RunService.Heartbeat:Wait()
	end

	for _, eggInst in ipairs(newSpawned) do
		local pos = eggInst:GetAttribute("Position")
		local bCount = ChiliEngine.GetBasketCount()
		local pEnd = os.clock() + 3.0

		while eggInst.Parent ~= nil and ChiliEngine.GetBasketCount() <= bCount and os.clock() < pEnd do
			local currentR = ChiliEngine.GetRoot()
			if typeof(pos) == "Vector3" and currentR and (currentR.Position - pos).Magnitude > 12 then
				ChiliEngine.FlyTo(pos + Vector3.new(0, 3, 0), nil, 5)
			end
			pcall(function()
				GameRemotes.EggPickup:FireServer(eggInst.Name)
			end)
			RunService.Heartbeat:Wait()
			pos = eggInst:GetAttribute("Position") or pos
		end
	end
	RuntimeState.Relaying = false
end

-- Delivery Manager (Chili Deliver)
function ChiliEngine.Deliver(breakCond)
	if ChiliEngine.GetBasketCount() <= 0 then
		return true
	end
	local plotTop = ChiliEngine.GetPlotTop()
	local plotBase = ChiliEngine.GetPlotBase()
	if not plotTop or not plotBase then
		return false
	end

	local root = ChiliEngine.GetRoot()
	local pPos = RuntimeState.PickupPos or (root and root.Position)
	if pPos and (pPos - plotTop).Magnitude > 250 then
		ChiliEngine.RelayRepickNearBase(plotBase, plotTop, breakCond)
	end

	ChiliEngine.FlyTo(plotTop + Vector3.new(0, 4, 0), breakCond, 4)
	local timeout = os.clock() + 3.0
	while ChiliEngine.GetBasketCount() > 0 and os.clock() < timeout do
		RunService.Heartbeat:Wait()
	end

	if ChiliEngine.GetBasketCount() == 0 then
		table.clear(RuntimeState.Carried)
		RuntimeState.PickupPos = nil
	end
	return ChiliEngine.GetBasketCount() == 0
end

function ChiliEngine.EquipTool(tool)
	local hum = ChiliEngine.GetHumanoid()
	local char = LocalPlayer.Character
	if not hum or not tool or not char then
		return false
	end
	if tool.Parent == char then
		return true
	end

	pcall(function()
		hum:EquipTool(tool)
	end)
	local deadline = os.clock() + 1.2
	while tool.Parent ~= char and os.clock() < deadline do
		RunService.Heartbeat:Wait()
	end
	return tool.Parent == char
end

function ChiliEngine.UnequipAll()
	local hum = ChiliEngine.GetHumanoid()
	if hum then
		pcall(function()
			hum:UnequipTools()
		end)
	end
end

-- Scoring & Evaluation
function ChiliEngine.GetMutationMultiplier(mut)
	local mutations = GameData.Mutations
	if type(mutations) == "table" and mut and mutations[tostring(mut)] then
		return 1 + (tonumber(mutations[tostring(mut)].StatMultiplier) or 0) / 100
	end
	return 1
end

function ChiliEngine.CalculatePetScore(name, weight, mut)
	local pData = GameData.Pets[tostring(name)]
	local baseInc = pData and tonumber(pData.Income) or 1
	local w = math.max(tonumber(weight) or 1, 0.1)
	return baseInc * w * ChiliEngine.GetMutationMultiplier(mut)
end

function ChiliEngine.GetPetScore(inst)
	local name = inst:GetAttribute("PetName") or string.gsub(inst.Name, "%s*%[.*$", "")
	local weight = inst:GetAttribute("Weight") or 1
	local mut = inst:GetAttribute("Mutation")
	return ChiliEngine.CalculatePetScore(name, weight, mut)
end

function ChiliEngine.GetTools(tag)
	local list = {}
	for _, holder in ipairs({ LocalPlayer:FindFirstChildOfClass("Backpack"), LocalPlayer.Character }) do
		if holder then
			for _, child in ipairs(holder:GetChildren()) do
				if child:IsA("Tool") and CollectionService:HasTag(child, tag) then
					table.insert(list, child)
				end
			end
		end
	end
	return list
end

function ChiliEngine.FindRemote(candidates)
	for _, name in ipairs(candidates) do
		local rem = GameRemotes:FindFirstChild(name)
		if rem and (rem:IsA("RemoteEvent") or rem:IsA("RemoteFunction")) then
			RuntimeState.Remotes[name] = rem
			return rem
		end
	end
	return nil
end

function ChiliEngine.Remote(path)
	local parts = {}
	for chunk in string.gmatch(path, "[^/]+") do
		parts[#parts + 1] = chunk
	end

	local node = ReplicatedStorage
	for i = 1, #parts do
		node = node:FindFirstChild(parts[i])
		if not node then
			return nil
		end
	end
	return node
end

function ChiliEngine.GetSellRemote()
	return nil
end

function ChiliEngine.GetCashRemote()
	return ChiliEngine.Remote("Remotes/Game/PetCollect")
end

function ChiliEngine.GetNestRemote()
	return ChiliEngine.Remote("Remotes/Game/Plot/Nests")
end

function ChiliEngine.GetRadarRemote()
	return ChiliEngine.Remote("Remotes/Game/ActivateRadar")
end

function ChiliEngine.GetLanternRemote()
	return ChiliEngine.Remote("Remotes/Game/PlaceLantern")
end

function ChiliEngine.GetUpgradeRemote()
	return ChiliEngine.Remote("Remotes/Game/Plot/Upgrades")
end

function ChiliEngine.GetSellPrompt()
	local stall = Workspace:FindFirstChild("Stalls")
	local sell = stall and stall:FindFirstChild("Sell")
	local npc = sell and sell:FindFirstChild("Richie")
	local root = npc and npc:FindFirstChild("HumanoidRootPart")
	local prompt = root and root:FindFirstChildOfClass("ProximityPrompt")
	return prompt
end

function ChiliEngine.FirePrompt(prompt)
	if not prompt or not prompt.Parent then
		return false
	end
	if typeof(fireproximityprompt) == "function" then
		local ok = pcall(fireproximityprompt, prompt)
		if ok then
			return true
		end
	end
	return pcall(function()
		prompt:InputHoldBegin()
		task.wait(prompt.HoldDuration + 0.1)
		prompt:InputHoldEnd()
	end)
end

function ChiliEngine.GetNestData()
	if RuntimeState.CachedNests == nil then
		RuntimeState.CachedNests = SafeRequire(function()
			return ReplicatedStorage.GameData.Nests
		end) or false
	end
	return RuntimeState.CachedNests or nil
end

function ChiliEngine.GetNests()
	local plot = ChiliEngine.GetPlot()
	local nests = plot and plot:FindFirstChild("Nests")
	return (nests and nests:GetChildren()) or {}
end

function ChiliEngine.GetRadarPrice()
	for _, name in ipairs(FarmConfig.Gear_Radars) do
		local _, entry = ChiliEngine.FindShopItem(name)
		if type(entry) == "table" then
			return tonumber(entry.Price or entry.Cost), name
		end
	end
	return nil
end

function ChiliEngine.GetNextLockedNest()
	local data = ChiliEngine.GetNestData()
	local prices = data and data.Prices or nil
	local best, bestPrice = nil, math.huge

	for _, nest in ipairs(ChiliEngine.GetNests()) do
		local id = tonumber(nest.Name)
		if id and nest:GetAttribute("Unlocked") ~= true then
			local price = prices and tonumber(prices[id]) or nil
			if price and price > 0 and price < bestPrice and ChiliEngine.GetCash() >= price then
				bestPrice = price
				best = id
			end
		end
	end
	return best, bestPrice
end

function ChiliEngine.GetLanternTool()
	for _, holder in ipairs({ LocalPlayer:FindFirstChildOfClass("Backpack"), LocalPlayer.Character }) do
		if holder then
			for _, child in ipairs(holder:GetChildren()) do
				if child:IsA("Tool") and string.find(string.lower(child.Name), "lantern", 1, true) then
					return child
				end
			end
		end
	end
	return nil
end

-- Robust Filter Matching (Handles empty selection properly)
local function EvaluateFilter(name, rarity, mut, selNames, selRarities, selMutations, rule)
	local hasNameFilter = (next(selNames) ~= nil)
	local hasRarityFilter = (next(selRarities) ~= nil)
	local hasMutFilter = (next(selMutations) ~= nil)

	-- If no filter selected at all, match everything!
	if not hasNameFilter and not hasRarityFilter and not hasMutFilter then
		return true
	end

	local matchName = not hasNameFilter or (selNames[string.lower(tostring(name))] == true)
	local matchRarity = not hasRarityFilter or (selRarities[string.lower(tostring(rarity))] == true)
	local mutClean = string.lower(tostring(mut or "None"))
	local matchMut = not hasMutFilter or (selMutations[mutClean] == true)

	if rule == "Match All" then
		return matchName and matchRarity and matchMut
	else
		-- Match Any
		local pass = false
		if hasNameFilter and matchName then
			pass = true
		end
		if hasRarityFilter and matchRarity then
			pass = true
		end
		if hasMutFilter and matchMut then
			pass = true
		end
		return pass
	end
end

function ChiliEngine.GetActiveEggCandidates()
	local root = ChiliEngine.GetRoot()
	local pPos = root and root.Position or Vector3.zero
	local plotTop = ChiliEngine.GetPlotTop()
	local list = {}
	local now = os.clock()

	for _, child in ipairs(ActiveEggsFolder:GetChildren()) do
		local eggType = child:GetAttribute("Egg")
		local pos = child:GetAttribute("Position")
		local privateTo = child:GetAttribute("PrivateTo")
		local bl = RuntimeState.BlacklistedEggs[child.Name]

		if
			type(eggType) == "string"
			and typeof(pos) == "Vector3"
			and (privateTo == nil or privateTo == LocalPlayer.UserId)
			and not ChiliEngine.IsEggCollected(eggType)
		then
			if not (bl and bl > now) then
				local meta = GameData.Eggs[eggType] or {}
				local rarity = tostring(meta.Rarity or "Common")
				local mut = tostring(child:GetAttribute("Mutation") or "None")

				if
					EvaluateFilter(
						eggType,
						rarity,
						mut,
						FarmConfig.SelectedEggs,
						FarmConfig.SelectedRarities,
						FarmConfig.SelectedMutations,
						FarmConfig.FilterRule
					)
				then
					local weight = tonumber(child:GetAttribute("Weight")) or 1
					local reachable = true

					if plotTop then
						local budget = ChiliEngine.EggBreakSeconds(eggType) - 5
						reachable = ChiliEngine.TravelTime(pos, plotTop) < budget
					end

					if reachable then
						table.insert(list, {
							Config = child,
							Name = eggType,
							Position = pos,
							Rarity = rarity,
							Rank = RarityRanks[rarity] or 1,
							Luck = ChiliEngine.EggLuck(eggType) * weight,
							Distance = (pos - pPos).Magnitude,
							Weight = weight,
						})
					end
				end
			end
		end
	end

	table.sort(list, function(a, b)
		local prio = tostring(FarmConfig.CollectPriority or "Highest Rarity")

		if prio == "Heaviest" then
			if a.Weight ~= b.Weight then
				return a.Weight > b.Weight
			end
			return a.Distance < b.Distance
		end

		if prio == "Nearest" then
			return a.Distance < b.Distance
		end

		if prio == "Farthest" then
			return a.Distance > b.Distance
		end

		if prio == "Highest Luck" then
			if a.Luck ~= b.Luck then
				return a.Luck > b.Luck
			end
			return a.Distance < b.Distance
		end

		if a.Rank ~= b.Rank then
			return a.Rank > b.Rank
		end
		if a.Luck ~= b.Luck then
			return a.Luck > b.Luck
		end
		return a.Distance < b.Distance
	end)
	return list
end

-- =====================================================================
-- UI BUILDER (N3-LIBRARY V3)
-- =====================================================================
local LibraryLoader =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LuxyG15/N3-Hub/refs/heads/main/Library/N3V3.luau"))()
if not LibraryLoader then
	return
end

local function FetchServers()
	local current = tostring(game.JobId or "")
	local list = {}
	local cursor = nil

	for _ = 1, 6 do
		local url = string.format(
			"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100",
			game.PlaceId
		)
		if cursor and cursor ~= "" then
			url ..= "&cursor=" .. HttpService:UrlEncode(cursor)
		end

		local ok, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)
		if not ok or type(result) ~= "table" then
			break
		end

		for _, server in ipairs(result.data or {}) do
			local id = tostring(server.id or "")
			local playing = tonumber(server.playing) or math.huge
			local maxPlayers = tonumber(server.maxPlayers) or 0
			if id ~= "" and id ~= current and playing < maxPlayers then
				list[#list + 1] = { Id = id, Playing = playing, Room = maxPlayers - playing }
			end
		end

		if #list > 0 then
			break
		end
		cursor = result.nextPageCursor
		if not cursor or cursor == "" then
			break
		end
	end

	return list
end

-- =====================================================================
-- PLAYER & MISC ENGINE
-- Player : Speed Boost / Infinite Jump / Noclip / Instant Pickup (parity Chili)
-- Misc   : Anti AFK / FPS Cap / FPS & Ping / Hide Pets / Optimizer / 3D Render
-- Semua local di dalam do-block biar hemat register.
-- =====================================================================
local N3Misc = {}

do
	local UIS = game:GetService("UserInputService")

	-- ========= INSTANT PICKUP (HoldDuration 0 semua ProximityPrompt) =========
	local PickupPromptCache = {}
	local PickupPromptConns = {}

	local function CacheInstantPrompt(prompt)
		if typeof(prompt) ~= "Instance" or not prompt:IsA("ProximityPrompt") then
			return
		end
		if PickupPromptCache[prompt] == nil then
			PickupPromptCache[prompt] = prompt.HoldDuration
		end
		if prompt.HoldDuration ~= 0 then
			prompt.HoldDuration = 0
		end
	end

	local function RestorePrompts()
		for _, c in ipairs(PickupPromptConns) do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(PickupPromptConns)
		for prompt, duration in pairs(PickupPromptCache) do
			if prompt.Parent then
				pcall(function()
					prompt.HoldDuration = duration
				end)
			end
		end
		table.clear(PickupPromptCache)
	end

	function N3Misc.EnableInstantPickup()
		RestorePrompts()
		for _, d in ipairs(Workspace:GetDescendants()) do
			CacheInstantPrompt(d)
		end
		table.insert(
			PickupPromptConns,
			Workspace.DescendantAdded:Connect(function(d)
				task.defer(function()
					if FarmConfig.InstanPickup then
						CacheInstantPrompt(d)
					end
				end)
			end)
		)
		table.insert(
			PickupPromptConns,
			ProximityPromptService.PromptShown:Connect(function(d)
				if FarmConfig.InstanPickup then
					CacheInstantPrompt(d)
				end
			end)
		)
	end

	function N3Misc.RestoreInstantPickup()
		RestorePrompts()
	end

	-- ========= INFINITE JUMP =========
	UIS.JumpRequest:Connect(function()
		if not FarmConfig.Movement_InfiniteJump or RuntimeState.IsBusy then
			return
		end
		local hum = ChiliEngine.GetHumanoid()
		if hum then
			pcall(function()
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
	end)

	-- ========= SPEED BOOST (velocity, auto-off selama automasi jalan) =========
	RunService.Heartbeat:Connect(function()
		if not FarmConfig.Movement_SpeedBoost or RuntimeState.IsBusy then
			return
		end
		local hum = ChiliEngine.GetHumanoid()
		local root = ChiliEngine.GetRoot()
		if not hum or not root or hum.Sit then
			return
		end
		local dir = hum.MoveDirection
		local flat = Vector3.new(dir.X, 0, dir.Z)
		if flat.Magnitude < 0.05 then
			return
		end
		root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
			+ flat.Unit * FarmConfig.Movement_BoostSpeed
	end)

	-- ========= NOCLIP MANUAL (cache terpisah dari noclip internal automasi) =========
	RunService.Stepped:Connect(function()
		local busy = RuntimeState.IsBusy
		if FarmConfig.Movement_Noclip and not busy then
			local char = LocalPlayer.Character
			if not char then
				return
			end
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					if RuntimeState.UserNoclipParts[part] == nil then
						RuntimeState.UserNoclipParts[part] = part.CanCollide
					end
					part.CanCollide = false
				end
			end
		elseif next(RuntimeState.UserNoclipParts) ~= nil and not busy then
			local char = LocalPlayer.Character
			if char then
				for part, canCollide in pairs(RuntimeState.UserNoclipParts) do
					if part.Parent then
						pcall(function()
							part.CanCollide = canCollide
						end)
					end
					RuntimeState.UserNoclipParts[part] = nil
				end
			else
				table.clear(RuntimeState.UserNoclipParts)
			end
		end
	end)

	-- ========= ANTI AFK =========
	local function GetIdledConnections()
		if type(getconnections) ~= "function" then
			return nil
		end
		local ok, result = pcall(getconnections, LocalPlayer.Idled)
		return ok and type(result) == "table" and result or nil
	end

	local function SetIdled(enabled)
		local conns = GetIdledConnections()
		if not conns then
			return false
		end
		for _, c in ipairs(conns) do
			pcall(function()
				if enabled then
					c:Enable()
				else
					c:Disable()
				end
			end)
		end
		return true
	end

	function N3Misc.SetAntiAfk(enabled)
		return SetIdled(enabled ~= true)
	end

	task.spawn(function()
		while true do
			if FarmConfig.AntiAFK_Enabled then
				SetIdled(false)
			end
			task.wait(30)
		end
	end)

	-- ========= FPS CAP =========
	local fpsCapWarned = false

	function N3Misc.SetFpsCap(value)
		local n = math.clamp(math.floor(tonumber(value) or 240), 30, 1000)
		if type(setfpscap) == "function" then
			pcall(setfpscap, n)
			return true
		end
		if not fpsCapWarned then
			fpsCapWarned = true
			warn("[N3 HUB] Misc: setfpscap tidak tersedia di executor ini")
			N3Misc.Notify("FPS Cap Unavailable", "Executor ini tidak support setfpscap.", 5)
		end
		return false
	end

	-- ========= HIDE OTHER PLAYERS' PETS (FPS gain besar) =========
	local hidePetsFolder = nil
	local movedPets = {}
	local hideConns = {}
	local hideActive = false

	local function HidePet(child)
		if not hideActive or not hidePetsFolder or movedPets[child] then
			return
		end
		movedPets[child] = child.Parent
		pcall(function()
			child.Parent = hidePetsFolder
		end)
	end

	local function WatchPlotPets(plot)
		if plot == ChiliEngine.GetPlot() then
			return
		end
		local pets = plot:FindFirstChild("Pets")
		if not pets then
			return
		end
		for _, child in ipairs(pets:GetChildren()) do
			HidePet(child)
		end
		table.insert(
			hideConns,
			pets.ChildAdded:Connect(function(child)
				task.defer(HidePet, child)
			end)
		)
	end

	local function HideOtherPetsStart()
		hideActive = true
		if not hidePetsFolder then
			hidePetsFolder = Instance.new("Folder")
			hidePetsFolder.Name = "N3Hub_HiddenPets"
		end
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then
			return
		end
		for _, plot in ipairs(plots:GetChildren()) do
			WatchPlotPets(plot)
		end
		table.insert(
			hideConns,
			plots.ChildAdded:Connect(function(child)
				task.wait(1)
				if hideActive then
					WatchPlotPets(child)
				end
			end)
		)
	end

	local function HideOtherPetsStop()
		hideActive = false
		for _, c in ipairs(hideConns) do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(hideConns)
		for child, originalParent in pairs(movedPets) do
			pcall(function()
				if originalParent and originalParent.Parent then
					child.Parent = originalParent
				end
			end)
		end
		table.clear(movedPets)
	end

	function N3Misc.SetHideOtherPets(enabled)
		if enabled then
			HideOtherPetsStart()
		else
			HideOtherPetsStop()
		end
	end

	-- ========= DISABLE 3D RENDERING =========
	function N3Misc.Set3DRendering(enabled)
		pcall(function()
			RunService:Set3dRenderingEnabled(enabled ~= true)
		end)
	end

	-- ========= OPTIMIZER (strip shadow/tekstur/efek, bisa restore) =========
	local Lighting = game:GetService("Lighting")
	local optimizerActive = false
	local optimizerGeneration = 0
	local optBackup = {}
	local propCache = setmetatable({}, { __mode = "k" })
	local optConns = {}
	local pendingParts = {}

	local function TryBackup(getter, setter, newValue)
		local ok, result = pcall(getter)
		if not ok then
			return
		end
		table.insert(optBackup, { Setter = setter, Value = result })
		pcall(setter, newValue)
	end

	local function CacheAndStrip(inst, prop, newValue)
		local props = propCache[inst]
		if not props then
			props = {}
			propCache[inst] = props
		end
		if props[prop] == nil then
			local ok, result = pcall(function()
				return inst[prop]
			end)
			if not ok then
				return
			end
			props[prop] = { Value = result }
		end
		pcall(function()
			inst[prop] = newValue
		end)
	end

	local function StripDescendant(inst)
		if not optimizerActive or not inst.Parent then
			return
		end
		if inst:IsA("ParticleEmitter") then
			CacheAndStrip(inst, "Enabled", false)
			CacheAndStrip(inst, "Rate", 0)
		elseif inst:IsA("Trail") or inst:IsA("Beam") then
			CacheAndStrip(inst, "Enabled", false)
		elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
			CacheAndStrip(inst, "Enabled", false)
			CacheAndStrip(inst, "Brightness", 0)
		elseif inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles") then
			CacheAndStrip(inst, "Enabled", false)
		elseif inst:IsA("Explosion") then
			CacheAndStrip(inst, "Visible", false)
		elseif inst:IsA("SpecialMesh") then
			CacheAndStrip(inst, "TextureId", "")
		elseif inst:IsA("Decal") or inst:IsA("Texture") then
			if not (inst.Name == "face" and inst.Parent and inst.Parent.Name == "Head") then
				CacheAndStrip(inst, "Transparency", 1)
			end
		elseif inst:IsA("MeshPart") then
			CacheAndStrip(inst, "RenderFidelity", Enum.RenderFidelity.Performance)
			CacheAndStrip(inst, "TextureID", "")
			CacheAndStrip(inst, "CastShadow", false)
			CacheAndStrip(inst, "Reflectance", 0)
			CacheAndStrip(inst, "Material", Enum.Material.SmoothPlastic)
		elseif inst:IsA("BasePart") then
			CacheAndStrip(inst, "CastShadow", false)
			CacheAndStrip(inst, "Reflectance", 0)
			CacheAndStrip(inst, "Material", Enum.Material.SmoothPlastic)
		elseif inst:IsA("PostEffect") then
			CacheAndStrip(inst, "Enabled", false)
		elseif inst:IsA("Clouds") then
			CacheAndStrip(inst, "Cover", 0)
			CacheAndStrip(inst, "Density", 0)
		elseif inst:IsA("Atmosphere") then
			CacheAndStrip(inst, "Density", 0)
			CacheAndStrip(inst, "Haze", 0)
			CacheAndStrip(inst, "Glare", 0)
		end
	end

	local function LowerQuality()
		local okR, rendering = pcall(function()
			return settings().Rendering
		end)
		if not okR then
			rendering = nil
		end
		local terrain = Workspace:FindFirstChildOfClass("Terrain")

		local function set(obj, prop, value)
			TryBackup(function()
				return obj[prop]
			end, function(v)
				obj[prop] = v
			end, value)
		end

		set(rendering, "QualityLevel", Enum.QualityLevel.Level01)
		set(rendering, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level01)
		set(rendering, "EditQualityLevel", Enum.QualityLevel.Level01)

		local okU, ugs = pcall(function()
			return UserSettings():GetService("UserGameSettings")
		end)
		if okU and ugs then
			set(ugs, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
		end

		set(Lighting, "GlobalShadows", false)
		set(Lighting, "ShadowSoftness", 0)
		set(Lighting, "FogEnd", 9e9)
		set(Lighting, "Technology", Enum.Technology.Legacy)
		set(Lighting, "EnvironmentDiffuseScale", 0)
		set(Lighting, "EnvironmentSpecularScale", 0)
		if terrain then
			set(terrain, "Decoration", false)
			set(terrain, "WaterWaveSize", 0)
			set(terrain, "WaterWaveSpeed", 0)
			set(terrain, "WaterReflectance", 0)
			set(terrain, "WaterTransparency", 1)
		end
	end

	local function DrainPending()
		if not optimizerActive or #pendingParts == 0 then
			return
		end
		local now = os.clock()
		while #pendingParts > 0 do
			local inst = table.remove(pendingParts)
			StripDescendant(inst)
			if os.clock() - now > 0.003 then
				break
			end
		end
	end

	local function RestoreOptimizer()
		local now = os.clock()
		for inst, props in pairs(propCache) do
			if inst.Parent then
				for prop, data in pairs(props) do
					pcall(function()
						inst[prop] = data.Value
					end)
				end
			end
			propCache[inst] = nil
			if os.clock() - now > 0.003 then
				RunService.Heartbeat:Wait()
				now = os.clock()
			end
		end
	end

	local function StopOptimizer()
		if not optimizerActive then
			return
		end
		optimizerActive = false
		optimizerGeneration += 1
		for _, c in ipairs(optConns) do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(optConns)
		table.clear(pendingParts)
		task.spawn(function()
			RestoreOptimizer()
			for i = #optBackup, 1, -1 do
				local entry = optBackup[i]
				pcall(entry.Setter, entry.Value)
			end
			table.clear(optBackup)
		end)
	end

	local function StartOptimizer()
		if optimizerActive then
			return
		end
		optimizerActive = true
		optimizerGeneration += 1
		local generation = optimizerGeneration
		LowerQuality()

		for _, root in ipairs({ Workspace, Lighting }) do
			table.insert(
				optConns,
				root.DescendantAdded:Connect(function(descendant)
					if optimizerActive and optimizerGeneration == generation then
						table.insert(pendingParts, descendant)
					end
				end)
			)
		end

		local conn
		conn = RunService.Heartbeat:Connect(function()
			if not (optimizerActive and optimizerGeneration == generation) then
				conn:Disconnect()
				return
			end
			DrainPending()
		end)
		table.insert(optConns, conn)

		task.spawn(function()
			for _, root in ipairs({ Workspace, Lighting }) do
				local now = os.clock()
				for _, descendant in ipairs(root:GetDescendants()) do
					if not (optimizerActive and optimizerGeneration == generation) then
						return
					end
					StripDescendant(descendant)
					if os.clock() - now > 0.003 then
						RunService.Heartbeat:Wait()
						now = os.clock()
					end
				end
			end
		end)
	end

	function N3Misc.SetOptimizer(enabled)
		if enabled then
			StartOptimizer()
		else
			task.spawn(StopOptimizer)
		end
	end

	-- ========= NOTIFIKASI POPUP (parity Chili v.Notify) =========
	local TweenService = game:GetService("TweenService")
	local notifGui = nil
	local activeNotifs = {}

	local function EnsureNotifGui()
		if notifGui and notifGui.Parent then
			return notifGui
		end
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "N3Hub_Notifications"
		notifGui.DisplayOrder = 60
		notifGui.IgnoreGuiInset = true
		notifGui.ResetOnSpawn = false
		notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		notifGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		return notifGui
	end

	local function RepositionNotifs()
		local index = 0
		for _, card in ipairs(activeNotifs) do
			if card.Parent then
				index += 1
				TweenService:Create(
					card,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Position = UDim2.new(1, -320, 1, -(index * 78) - 14) }
				):Play()
			end
		end
	end

	function N3Misc.Notify(title, text, duration, color)
		local gui = EnsureNotifGui()

		local card = Instance.new("Frame")
		card.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
		card.BackgroundTransparency = 0.08
		card.BorderSizePixel = 0
		card.Position = UDim2.new(1, 20, 1, -90)
		card.Size = UDim2.fromOffset(300, 70)
		card.Parent = gui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = card

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1.5
		stroke.Color = color or Color3.fromRGB(217, 70, 239)
		stroke.Parent = card

		local titleLbl = Instance.new("TextLabel")
		titleLbl.BackgroundTransparency = 1
		titleLbl.Position = UDim2.fromOffset(12, 8)
		titleLbl.Size = UDim2.new(1, -24, 0, 22)
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextSize = 15
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.TextColor3 = color or Color3.fromRGB(217, 70, 239)
		titleLbl.Text = tostring(title or "")
		titleLbl.Parent = card

		local textLbl = Instance.new("TextLabel")
		textLbl.BackgroundTransparency = 1
		textLbl.Position = UDim2.fromOffset(12, 32)
		textLbl.Size = UDim2.new(1, -24, 0, 30)
		textLbl.Font = Enum.Font.Gotham
		textLbl.TextSize = 12
		textLbl.TextWrapped = true
		textLbl.TextXAlignment = Enum.TextXAlignment.Left
		textLbl.TextYAlignment = Enum.TextXAlignment.Top
		textLbl.TextColor3 = Color3.fromRGB(220, 224, 235)
		textLbl.Text = tostring(text or "")
		textLbl.Parent = card

		table.insert(activeNotifs, card)
		RepositionNotifs()

		task.delay(tonumber(duration) or 4, function()
			local idx = table.find(activeNotifs, card)
			if idx then
				table.remove(activeNotifs, idx)
			end
			pcall(function()
				local tween = TweenService:Create(
					card,
					TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{ Position = UDim2.new(1, 20, card.Position.Y.Scale, card.Position.Y.Offset) }
				)
				tween:Play()
				tween.Completed:Wait()
				card:Destroy()
			end)
			RepositionNotifs()
		end)
	end

	-- ========= SERVER TOOLS MANUAL (parity Chili) =========
	local teleportBusy = false

	local function SetTeleportBusy()
		teleportBusy = true
		task.delay(8, function()
			teleportBusy = false
		end)
	end

	local function ParseJobId(text)
		local match = tostring(text or ""):match("^%s*(.-)%s*$")
		return match:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or match
	end

	function N3Misc.ParseJobId(text)
		return ParseJobId(text)
	end

	function N3Misc.QueueReloadScript()
		local qot = (getgenv and getgenv().queue_on_teleport)
			or (syn and syn.queue_on_teleport)
			or (fluxus and fluxus.queue_on_teleport)
		if typeof(qot) ~= "function" then
			return
		end
		pcall(qot, "")
		local url = tostring(FarmConfig.ScriptURL or "")
		if FarmConfig.AutoHopReload and url ~= "" then
			pcall(
				qot,
				'local ok, s = pcall(function() return game:HttpGet("'
					.. url
					.. '") end) if ok and type(s) == "string" then local chunk = loadstring(s) if chunk then chunk() end end'
			)
		end
	end

	function N3Misc.JoinJobId(text)
		if teleportBusy then
			N3Misc.Notify("Join Job ID Failed", "A teleport is already running, try again shortly.", 4)
			return
		end
		local id = ParseJobId(text)
		if id == "" then
			N3Misc.Notify("Join Job ID Failed", "Paste a valid Job ID first.", 4)
			return
		end
		SetTeleportBusy()
		pcall(N3Misc.QueueReloadScript)
		local ok = pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
		end)
		if not ok then
			teleportBusy = false
			N3Misc.Notify("Join Job ID Failed", "Roblox could not join that server.", 4)
		end
	end

	function N3Misc.CopyJobId()
		local id = tostring(game.JobId or "")
		local clipboard = setclipboard or toclipboard
		local ok = (type(clipboard) == "function") and pcall(clipboard, id) or false
		N3Misc.Notify(ok and "Job ID Copied" or "Job ID Shown", id, 4)
	end

	function N3Misc.RejoinServer()
		if teleportBusy then
			N3Misc.Notify("Rejoin Failed", "A teleport is already running, try again shortly.", 4)
			return
		end
		SetTeleportBusy()
		pcall(N3Misc.QueueReloadScript)
		local ok = pcall(function()
			if game.JobId ~= "" then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
			else
				TeleportService:Teleport(game.PlaceId, LocalPlayer)
			end
		end)
		if not ok then
			teleportBusy = false
			N3Misc.Notify("Rejoin Failed", "Roblox could not rejoin the server.", 4)
		end
	end

	function N3Misc.ServerHopNow()
		if teleportBusy then
			N3Misc.Notify("Server Hop", "A teleport is already running, try again shortly.", 4)
			return
		end
		RuntimeState.StatusText = "Server hopping..."
		local list = FetchServers()
		local now = os.clock()
		local pool = {}
		for _, server in ipairs(list) do
			local bl = RuntimeState.HopBlacklist[server.Id]
			if not bl or bl <= now then
				pool[#pool + 1] = server
			end
		end
		if #pool == 0 then
			N3Misc.Notify("Server Hop", "No server available (all full).", 4)
			RuntimeState.StatusText = "Idle"
			return
		end

		local target
		if FarmConfig.Hop_Mode == "Random" then
			target = pool[math.random(1, #pool)]
		elseif FarmConfig.Hop_Mode == "Most Players" then
			table.sort(pool, function(a, b)
				return a.Playing > b.Playing
			end)
			target = pool[1]
		else
			table.sort(pool, function(a, b)
				return a.Playing < b.Playing
			end)
			target = pool[1]
		end

		SetTeleportBusy()
		pcall(N3Misc.QueueReloadScript)
		local ok = pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, target.Id, LocalPlayer)
		end)
		if not ok then
			teleportBusy = false
			RuntimeState.HopBlacklist[target.Id] = os.clock() + 300
			N3Misc.Notify("Server Hop", "Teleport failed, server di-blacklist 5 menit.", 4)
		else
			N3Misc.Notify("Server Hop", "Hopping to server (" .. tostring(target.Playing) .. " players)...", 4)
		end
		RuntimeState.StatusText = "Idle"
	end

	pcall(function()
		TeleportService.TeleportInitFailed:Connect(function()
			teleportBusy = false
		end)
	end)

	-- ========= INIT (apply default) =========
	task.defer(function()
		pcall(function()
			N3Misc.SetAntiAfk(FarmConfig.AntiAFK_Enabled)
		end)
		pcall(function()
			N3Misc.SetFpsCap(FarmConfig.FPS_Cap)
		end)
	end)
end

-- Formatter weight resmi game (PetAging.InflateEggWeight), dipakai ESP + tracker
local function FormatEggWeight(weight)
	local value = tonumber(weight) or 0
	local petAging = GameData.PetAging
	if type(petAging) == "table" and type(petAging.InflateEggWeight) == "function" then
		local ok, result = pcall(petAging.InflateEggWeight, value)
		if ok and type(result) == "number" then
			value = result
		end
	end
	local units = { "", "K", "M", "B", "T", "Qa" }
	local idx = 1
	while value >= 1000 and idx < #units do
		value /= 1000
		idx += 1
	end
	return string.format("%.2f", math.floor(value * 100 + 0.5) / 100) .. units[idx] .. " KG"
end

local function BuildInterface()
	local MainWindow = LibraryLoader:CreateWindow({
		Title = "N3 HUB",
		Footer = "discord.gg/chiyo | v1.0 | Game: Ride A Pet",
		Icon = "rbxassetid://117688744510818",
		AutoShow = true,
	})

	local function MapSelection(sel)
		local res = {}
		for k, v in pairs(sel) do
			if type(k) == "string" and v == true then
				res[string.lower(k)] = true
			elseif type(v) == "string" then
				res[string.lower(v)] = true
			end
		end
		return res
	end

	-- TAB 1: EGG
	local EggTab = MainWindow:AddTab("Egg", "egg", "Egg Farming, Placement & Hatch Progression")
	local EggLoopGroup = EggTab:AddLeftGroupbox("Egg Loop", "egg")

	EggLoopGroup:AddDropdown("Dropdown_Loop_Eggs", {
		Text = "Eggs",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.SelectedEggs = MapSelection(sel)
		end,
	})
	EggLoopGroup:AddDropdown("Dropdown_Loop_Rarities", {
		Text = "Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.SelectedRarities = MapSelection(sel)
		end,
	})
	EggLoopGroup:AddDropdown("Dropdown_Loop_Mutations", {
		Text = "Mutations",
		Values = MutationList,
		Default = { "None" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.SelectedMutations = MapSelection(sel)
		end,
	})
	EggLoopGroup:AddDropdown("Dropdown_Loop_FilterRule", {
		Text = "Filter Rule",
		Values = { "Match Any", "Match All" },
		Default = "Match Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.FilterRule = v
		end,
	})
	local TogAutoFarmEgg = EggLoopGroup:AddToggle("Toggle_AutoFarmEgg", {
		Text = "Auto Farm Egg",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoFarmEgg = s
		end,
	})
	EggLoopGroup:AddToggle("Toggle_AutoVolcanoDip", {
		Text = "Auto Volcano Dip",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoVolcanoDip = s
		end,
	})
	EggLoopGroup:AddDropdown("Dropdown_DipMinRarity", {
		Text = "Dip Min Rarity",
		Values = RarityChoices,
		Default = "Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.DipMinRank = RarityRanks[tostring(v)] or 0
		end,
	})
	EggLoopGroup:AddDropdown("Dropdown_Loop_Priority", {
		Text = "Collect Priority",
		Values = { "Highest Rarity", "Highest Luck", "Nearest", "Farthest", "Heaviest" },
		Default = "Highest Rarity",
		Multi = false,
		AllowNull = false,
		Tooltip = "Urutan prioritas egg yang dikejar (Chili parity)",
		Callback = function(v)
			FarmConfig.CollectPriority = tostring(v or "Highest Rarity")
		end,
	})
	EggLoopGroup:AddSlider("Slider_Loop_TweenSpeed", {
		Text = "Tween Speed",
		Min = 100,
		Max = 1300,
		Default = 1000,
		Increment = 25,
		Tooltip = "Kecepatan fly buat ngejar egg",
		Callback = function(v)
			FarmConfig.FlySpeed = math.clamp(tonumber(v) or 1000, 100, 1300)
		end,
	})

	local Lbl_LoopStatus = EggLoopGroup:AddLabel("", true)

	task.spawn(function()
		while true do
			task.wait(0.5)
			pcall(function()
				local status = tostring(RuntimeState.StatusText or "Idle")
				if RuntimeState.IsBusy and RuntimeState.StatusText == "Idle" then
					status = "Working..."
				end
				Lbl_LoopStatus:SetText('<font color="#D946EF"><b>Status:</b></font> ' .. status)
			end)
		end
	end)

	-- =====================================================================
	-- MAP EGGS TRACKER (parity Chili)
	-- Panel clone UI tracker game: kartu per-egg (nama, rarity, weight,
	-- jarak), tombol sort (Luck/Rarity/Distance/Weight), tombol Auto (sync
	-- sama toggle Auto Farm Egg), tombol Collect/Cancel manual per egg yang
	-- nembus ke engine (RuntimeState.ManualEggs).
	-- =====================================================================
	do
		local TrackerTween = game:GetService("TweenService")
		local trackerTweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local sortModes = { "Luck", "Rarity", "Distance", "Weight" }
		local sortIndex = 2
		local MAX_CARDS = 9

		local statusColors = {
			Collect = Color3.fromRGB(255, 255, 255),
			Cancel = Color3.fromRGB(255, 120, 120),
			AutoOn = Color3.fromRGB(120, 255, 120),
			AutoOff = Color3.fromRGB(255, 255, 255),
			Busy = Color3.fromRGB(120, 255, 90),
			Queued = Color3.fromRGB(255, 214, 90),
			Auto = Color3.fromRGB(150, 210, 255),
			Carry = Color3.fromRGB(255, 170, 70),
		}

		local trackerRarityColors = {
			Common = Color3.fromRGB(214, 218, 228),
			Rare = Color3.fromRGB(96, 170, 255),
			Epic = Color3.fromRGB(190, 110, 255),
			Legendary = Color3.fromRGB(255, 196, 66),
			Mythic = Color3.fromRGB(255, 82, 90),
			Divine = Color3.fromRGB(255, 240, 150),
			Ethereal = Color3.fromRGB(125, 225, 255),
		}

		local trackerGui = nil
		local panel = nil
		local holder = nil
		local handlerTemplate = nil
		local headerLabel = nil
		local sortLabel = nil
		local autoLabel = nil
		local sidebarButton = nil
		local notifBadge = nil
		local notifCountLabel = nil
		local panelOpen = false
		local cards = {}
		local needsUpdate = true
		local shownPos = UDim2.new(0.99, 0, 0.5, 0)
		local hiddenPos = UDim2.new(1.1, 0, 0.5, 0)

		local function GetTrackerParent()
			local ok, result = pcall(game.GetService, game, "CoreGui")
			if ok and result then
				return result
			end
			return LocalPlayer:FindFirstChildOfClass("PlayerGui")
		end

		local function StripClone(inst)
			for _, d in ipairs(inst:GetDescendants()) do
				if d:IsA("LuaSourceContainer") or d:IsA("BindableEvent") then
					d:Destroy()
				end
			end
		end

		local function EggImageId(eggType)
			local meta = GameData.Eggs[tostring(eggType)]
			if type(meta) == "table" and meta.Image then
				return tostring(meta.Image)
			end
			return ""
		end

		local function EggValid(inst)
			local eggType = inst:GetAttribute("Egg")
			local pos = inst:GetAttribute("Position")
			local privateTo = inst:GetAttribute("PrivateTo")
			local ok = type(eggType) == "string" and typeof(pos) == "Vector3"
			if ok then
				ok = privateTo == nil or privateTo == LocalPlayer.UserId
			end
			return ok
		end

		local function SetText(lbl, text)
			if lbl and lbl.Text ~= text then
				lbl.Text = text
			end
		end

		local function CloneLabel(source, name, position, size, align)
			local lbl = source:Clone()
			lbl.Name = name
			lbl.AnchorPoint = Vector2.new(0, 0)
			lbl.Position = position
			lbl.Size = size
			lbl.TextXAlignment = align or Enum.TextXAlignment.Left
			lbl.TextScaled = true
			lbl.Visible = true
			lbl.Text = ""
			return lbl
		end

		local function CardHeight()
			return math.max(40, math.floor(((holder and holder.AbsoluteSize.X or 0) * 0.888163447) / 2.55))
		end

		local function BuildCard(uid, config)
			local card = handlerTemplate:Clone()
			card.Name = "N3Tracker_" .. tostring(uid)
			card.Visible = true
			card.Size = UDim2.new(0.888163447, 0, 0, CardHeight())

			local cardHolder = card:FindFirstChild("Holder")
			local eggImage = cardHolder and cardHolder:FindFirstChild("EggImage")
			local eggWeight = eggImage and eggImage:FindFirstChild("EggWeight")
			local progress = card:FindFirstChild("Progress")
			local timeLeft = progress and progress:FindFirstChild("TimeLeft")
			local openBtn = card:FindFirstChild("Open")
			local openText = openBtn and openBtn:FindFirstChild("TextLabel")

			if progress then
				progress.Visible = false
			end

			local eggName = timeLeft
				and CloneLabel(timeLeft, "EggName", UDim2.fromScale(0.33, 0.1), UDim2.fromScale(0.64, 0.3))
			local eggInfo = timeLeft
				and CloneLabel(timeLeft, "EggInfo", UDim2.fromScale(0.33, 0.4), UDim2.fromScale(0.64, 0.2))
			local eggStatus = timeLeft
				and CloneLabel(timeLeft, "EggStatus", UDim2.fromScale(0.33, 0.66), UDim2.fromScale(0.3, 0.22))

			for _, lbl in ipairs({ eggName, eggInfo, eggStatus }) do
				if lbl then
					lbl.Parent = card
				end
			end

			if openBtn then
				openBtn.Visible = true
				openBtn.AnchorPoint = Vector2.new(0.5, 0.5)
				openBtn.Position = UDim2.fromScale(0.8, 0.74)
				openBtn.Size = UDim2.fromScale(0.33, 0.38)

				openBtn.Activated:Connect(function()
					local idx = table.find(RuntimeState.ManualEggs, uid)
					if idx then
						table.remove(RuntimeState.ManualEggs, idx)
					else
						table.insert(RuntimeState.ManualEggs, uid)
					end
					needsUpdate = true
				end)
			end

			local eggType = config and config:GetAttribute("Egg") or tostring(uid)
			local meta = GameData.Eggs[tostring(eggType)] or {}
			local rarity = tostring(meta.Rarity or "Common")

			if eggImage then
				eggImage.Image = EggImageId(eggType)
			end
			if eggWeight then
				eggWeight.Text = FormatEggWeight(config and config:GetAttribute("Weight") or 0)
			end
			if eggName then
				eggName.Text = tostring(eggType)
				eggName.TextColor3 = trackerRarityColors[rarity] or Color3.fromRGB(255, 255, 255)
			end
			card.Parent = holder

			return {
				Frame = card,
				Config = config,
				Name = eggType,
				Rarity = rarity,
				Rank = RarityRanks[rarity] or 0,
				Luck = (tonumber(meta.Luck) or 0) * (tonumber(config and config:GetAttribute("Weight")) or 1),
				Info = eggInfo,
				Status = eggStatus,
				Button = openBtn,
				ButtonText = openText,
			}
		end

		local function DestroyCard(uid)
			local card = cards[uid]
			if card then
				cards[uid] = nil
				pcall(function()
					card.Frame:Destroy()
				end)
			end
		end

		local function CardStatus(uid, autoIndex)
			if RuntimeState.Carried[uid] then
				return "Bringing home", statusColors.Carry, nil
			end
			if RuntimeState.CurrentEggTarget == uid then
				return "Collecting...", statusColors.Busy, nil
			end
			local idx = table.find(RuntimeState.ManualEggs, uid)
			if idx then
				return "Queued #" .. idx, statusColors.Queued, "Cancel"
			end
			if autoIndex then
				return "Auto #" .. autoIndex, statusColors.Auto, "Collect"
			end
			return "", statusColors.Collect, "Collect"
		end

		local function UpdateTracker()
			if not holder then
				return
			end
			local root = ChiliEngine.GetRoot()
			local myPos = root and root.Position or Vector3.zero
			local validEggs = {}
			local eggList = {}

			for _, child in ipairs(ActiveEggsFolder:GetChildren()) do
				if EggValid(child) and not (RuntimeState.Relaying and child:GetAttribute("OriginPosition") ~= nil) then
					validEggs[child.Name] = child
					table.insert(eggList, child)
				end
			end

			for name, config in pairs(RuntimeState.Carried) do
				if typeof(config) == "Instance" and not validEggs[name] then
					validEggs[name] = config
				end
			end

			if
				RuntimeState.CurrentEggTarget
				and not validEggs[RuntimeState.CurrentEggTarget]
				and cards[RuntimeState.CurrentEggTarget]
			then
				validEggs[RuntimeState.CurrentEggTarget] = cards[RuntimeState.CurrentEggTarget].Config
			end

			for uid in pairs(cards) do
				if not validEggs[uid] then
					DestroyCard(uid)
				end
			end

			local sortData = {}
			for _, child in ipairs(eggList) do
				local eggType = child:GetAttribute("Egg")
				local pos = child:GetAttribute("Position")
				local meta = GameData.Eggs[tostring(eggType)] or {}
				table.insert(sortData, {
					Uid = child.Name,
					Rank = RarityRanks[tostring(meta.Rarity or "Common")] or 0,
					Luck = (tonumber(meta.Luck) or 0) * (tonumber(child:GetAttribute("Weight")) or 1),
					Distance = (pos - myPos).Magnitude,
					Weight = tonumber(child:GetAttribute("Weight")) or 0,
				})
			end

			local sortMode = sortModes[sortIndex]
			table.sort(sortData, function(a, b)
				if sortMode == "Weight" and a.Weight ~= b.Weight then
					return a.Weight > b.Weight
				end
				if sortMode == "Distance" then
					return a.Distance < b.Distance
				end
				if sortMode == "Rarity" then
					if a.Rank ~= b.Rank then
						return a.Rank > b.Rank
					end
					if a.Luck ~= b.Luck then
						return a.Luck > b.Luck
					end
					return a.Distance < b.Distance
				end
				if a.Luck ~= b.Luck then
					return a.Luck > b.Luck
				end
				return a.Distance < b.Distance
			end)

			local autoOrder = {}
			if FarmConfig.AutoFarmEgg then
				local autoCount = 0
				for _, cand in ipairs(ChiliEngine.GetActiveEggCandidates()) do
					local name = cand.Config.Name
					if not table.find(RuntimeState.ManualEggs, name) and RuntimeState.CurrentEggTarget ~= name then
						autoCount += 1
						autoOrder[name] = autoCount
						if autoCount >= MAX_CARDS then
							break
						end
					end
				end
			end

			local ordered = {}
			local seen = {}

			for name, config in pairs(RuntimeState.Carried) do
				if validEggs[name] then
					seen[name] = true
					table.insert(ordered, name)
				end
			end

			if
				RuntimeState.CurrentEggTarget
				and validEggs[RuntimeState.CurrentEggTarget]
				and not RuntimeState.Carried[RuntimeState.CurrentEggTarget]
			then
				seen[RuntimeState.CurrentEggTarget] = true
				table.insert(ordered, RuntimeState.CurrentEggTarget)
			end

			for _, name in ipairs(RuntimeState.ManualEggs) do
				if validEggs[name] and name ~= RuntimeState.CurrentEggTarget then
					seen[name] = true
					table.insert(ordered, name)
				end
			end

			for _, data in ipairs(sortData) do
				if not seen[data.Uid] then
					seen[data.Uid] = true
					table.insert(ordered, data.Uid)
				end
			end

			local distMap = {}
			for _, data in ipairs(sortData) do
				distMap[data.Uid] = data.Distance
			end

			local shown = {}
			for i, uid in ipairs(ordered) do
				if i > MAX_CARDS then
					break
				end
				shown[uid] = true
				local card = cards[uid]
				if not card then
					card = BuildCard(uid, validEggs[uid])
					if card then
						cards[uid] = card
					end
				end
				if card then
					card.Frame.LayoutOrder = i
					local h = CardHeight()
					if card.Frame.Size.Y.Offset ~= h then
						card.Frame.Size = UDim2.new(0.888163447, 0, 0, h)
					end

					if RuntimeState.Carried[uid] then
						SetText(card.Info, card.Rarity .. "  |  In basket")
					else
						SetText(card.Info, string.format("%s  |  %dm", card.Rarity, math.floor(distMap[uid] or 0)))
					end

					local statusText, statusColor, buttonText = CardStatus(uid, autoOrder[uid])
					SetText(card.Status, statusText)
					if card.Status then
						card.Status.TextColor3 = statusColor
					end

					if card.Button then
						card.Button.Visible = buttonText ~= nil
						if buttonText and card.ButtonText then
							SetText(card.ButtonText, buttonText)
							card.Button.ImageColor3 = (buttonText == "Cancel") and statusColors.Cancel
								or statusColors.Collect
						end
					end
				end
			end

			for uid in pairs(cards) do
				if not shown[uid] then
					DestroyCard(uid)
				end
			end

			if headerLabel then
				SetText(headerLabel, string.format("Map Eggs (%d)", #eggList))
			end
			if sortLabel then
				SetText(sortLabel, "Sort: " .. tostring(sortMode))
			end
			if autoLabel then
				local on = FarmConfig.AutoFarmEgg
				SetText(autoLabel, on and "Auto: ON" or "Auto: OFF")
				if autoLabel.Parent and autoLabel.Parent:IsA("ImageButton") then
					autoLabel.Parent.ImageColor3 = on and statusColors.AutoOn or statusColors.AutoOff
				end
			end
			if notifBadge then
				local count = #RuntimeState.ManualEggs + ((RuntimeState.CurrentEggTarget and 1) or 0)
				notifBadge.Visible = count > 0
				SetText(notifCountLabel, tostring(count))
			end
		end

		local function SetPanelOpen(open)
			panelOpen = open
			if panel then
				TrackerTween:Create(panel, trackerTweenInfo, { Position = open and shownPos or hiddenPos }):Play()
			end
		end

		local function BuildTracker()
			if trackerGui then
				return true
			end
			local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local main = playerGui and playerGui:FindFirstChild("Main")
			local plotEggsTracker = main and main:FindFirstChild("PlotEggsTracker")
			local sideBar = main and main:FindFirstChild("SideBar")
			sideBar = sideBar and sideBar:FindFirstChild("Egg")
			local handler = nil

			if plotEggsTracker then
				handler = plotEggsTracker:FindFirstChild("Handler")
				handler = handler and handler:FindFirstChild("EggFrame")

				if not handler then
					local h = plotEggsTracker:FindFirstChild("Holder")
					for _, child in ipairs(h and h:GetChildren() or {}) do
						if child:IsA("Frame") and child:FindFirstChild("Holder") then
							handler = child
							break
						end
					end
				end
			end

			if not plotEggsTracker or not sideBar or not handler then
				return false
			end

			trackerGui = Instance.new("ScreenGui")
			trackerGui.Name = "N3Hub_MapEggs"
			trackerGui.ResetOnSpawn = false
			trackerGui.IgnoreGuiInset = main.IgnoreGuiInset
			trackerGui.ScreenInsets = main.ScreenInsets
			trackerGui.ZIndexBehavior = main.ZIndexBehavior
			trackerGui.DisplayOrder = main.DisplayOrder + 1

			handlerTemplate = handler:Clone()
			StripClone(handlerTemplate)

			panel = plotEggsTracker:Clone()
			panel.Name = "N3HubMapEggsPanel"
			StripClone(panel)
			panel.Visible = true
			holder = panel:FindFirstChild("Holder")

			for _, child in ipairs(holder:GetChildren()) do
				if not child:IsA("UIListLayout") then
					child:Destroy()
				end
			end

			holder.AutomaticCanvasSize = Enum.AutomaticSize.Y
			holder.CanvasSize = UDim2.new()
			local layout = holder:FindFirstChildOfClass("UIListLayout")
			if layout then
				layout.SortOrder = Enum.SortOrder.LayoutOrder
			end

			panel.Position = hiddenPos

			local header = panel:FindFirstChild("Header")
			headerLabel = header and header:FindFirstChild("Label")
			if headerLabel then
				headerLabel.Text = "Map Eggs"
			end

			local growAll = panel:FindFirstChild("GrowAll")
			if growAll then
				local autoBtn = growAll:Clone()
				growAll.Name = "N3SortBtn"
				autoBtn.Name = "N3AutoBtn"
				growAll.Size = UDim2.new(0.27, 0, growAll.Size.Y.Scale, 0)
				autoBtn.Size = growAll.Size
				growAll.Position = UDim2.new(0.58, 0, growAll.Position.Y.Scale, 0)
				autoBtn.Position = UDim2.new(0.86, 0, growAll.Position.Y.Scale, 0)
				autoBtn.Parent = panel

				for _, btn in ipairs({ growAll, autoBtn }) do
					local lbl = btn:FindFirstChild("TextLabel")
					if lbl then
						lbl.AnchorPoint = Vector2.new(0.5, 0.5)
						lbl.Position = UDim2.fromScale(0.5, 0.5)
						lbl.Size = UDim2.fromScale(0.86, 0.56)
						lbl.TextXAlignment = Enum.TextXAlignment.Center
					end
				end

				sortLabel = growAll:FindFirstChild("TextLabel")
				autoLabel = autoBtn:FindFirstChild("TextLabel")

				growAll.Activated:Connect(function()
					sortIndex = sortIndex % #sortModes + 1
					needsUpdate = true
				end)

				autoBtn.Activated:Connect(function()
					local newState = not FarmConfig.AutoFarmEgg
					FarmConfig.AutoFarmEgg = newState
					if TogAutoFarmEgg and TogAutoFarmEgg.SetValue then
						pcall(TogAutoFarmEgg.SetValue, TogAutoFarmEgg, newState)
					end
					needsUpdate = true
				end)
			end

			local toggleBtn = panel:FindFirstChild("Toggle")
			if toggleBtn and toggleBtn:IsA("GuiButton") then
				toggleBtn.Activated:Connect(function()
					SetPanelOpen(false)
				end)
			end

			sidebarButton = sideBar:Clone()
			sidebarButton.Name = "N3HubMapEggsSideBtn"
			StripClone(sidebarButton)

			local arrow = sidebarButton:FindFirstChild("Arrow")
			local bestLuck, bestEgg = -1, nil
			for name, meta in pairs(GameData.Eggs) do
				if type(meta) == "table" and meta.Image and (tonumber(meta.Luck) or 0) > bestLuck then
					bestLuck = tonumber(meta.Luck)
					bestEgg = name
				end
			end
			if arrow and bestEgg then
				arrow.Image = EggImageId(bestEgg)
				arrow.AnchorPoint = Vector2.new(0.5, 0.5)
				arrow.Position = UDim2.fromScale(0.5, 0.42)
				arrow.Size = UDim2.fromScale(0.74, 0.74)
			end

			sidebarButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			local gradient = Instance.new("UIGradient")
			gradient.Rotation = 90
			gradient.Color = ColorSequence.new(Color3.fromRGB(196, 110, 255), Color3.fromRGB(112, 40, 214))
			gradient.Parent = sidebarButton
			local stroke = sidebarButton:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = Color3.fromRGB(44, 8, 86)
			end

			notifBadge = sidebarButton:FindFirstChild("Notification")
			if notifBadge then
				notifCountLabel = notifBadge:FindFirstChild("Count")
				if notifCountLabel then
					local mapLbl = notifCountLabel:Clone()
					mapLbl.Name = "N3MapLbl"
					mapLbl.AnchorPoint = Vector2.new(0.5, 0.5)
					mapLbl.Position = UDim2.fromScale(0.5, 0.86)
					mapLbl.Size = UDim2.fromScale(0.9, 0.3)
					mapLbl.TextScaled = true
					mapLbl.Text = "MAP"
					mapLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
					mapLbl.ZIndex = 3
					local s2 = mapLbl:FindFirstChildOfClass("UIStroke")
					if s2 then
						s2.Color = Color3.fromRGB(44, 8, 86)
					end
					mapLbl.Parent = notifBadge
				end
				notifBadge.Visible = false
			end

			sidebarButton.AnchorPoint = Vector2.new(0.5, 0.5)
			sidebarButton.Parent = trackerGui

			sidebarButton.Activated:Connect(function()
				SetPanelOpen(not panelOpen)
				needsUpdate = true
			end)

			trackerGui.Parent = GetTrackerParent()
			return true
		end

		local function UpdateSidebarPos()
			if not sidebarButton or not trackerGui then
				return
			end
			local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local main = playerGui and playerGui:FindFirstChild("Main")
			local sideBar = main and main:FindFirstChild("SideBar")
			local eggBtn = sideBar and sideBar:FindFirstChild("Egg")
			if not main or not eggBtn or not main.Enabled or panelOpen then
				sidebarButton.Visible = false
				return
			end
			sidebarButton.Visible = true
			local guiPos = trackerGui.AbsolutePosition
			local size = eggBtn.AbsoluteSize
			sidebarButton.Size = UDim2.fromOffset(size.X, size.Y)
			sidebarButton.Position = UDim2.fromOffset(
				eggBtn.AbsolutePosition.X - guiPos.X - size.X * 1.15,
				eggBtn.AbsolutePosition.Y + size.Y / 2 - guiPos.Y - size.Y / 2
			)
		end

		local trackerConns = {}

		table.insert(
			trackerConns,
			ActiveEggsFolder.ChildAdded:Connect(function()
				needsUpdate = true
			end)
		)
		table.insert(
			trackerConns,
			ActiveEggsFolder.ChildRemoved:Connect(function(child)
				needsUpdate = true
				local idx = table.find(RuntimeState.ManualEggs, child.Name)
				if idx then
					table.remove(RuntimeState.ManualEggs, idx)
				end
			end)
		)

		local trackerElapsed = 0
		table.insert(
			trackerConns,
			RunService.RenderStepped:Connect(function(dt)
				pcall(UpdateSidebarPos)
				trackerElapsed += dt
				if panelOpen and (needsUpdate or trackerElapsed >= 0.3) then
					trackerElapsed = 0
					needsUpdate = false
					pcall(UpdateTracker)
				elseif not panelOpen and trackerElapsed >= 0.5 then
					trackerElapsed = 0
					if notifBadge then
						local count = #RuntimeState.ManualEggs + ((RuntimeState.CurrentEggTarget and 1) or 0)
						notifBadge.Visible = count > 0
						SetText(notifCountLabel, tostring(count))
					end
				end
			end)
		)

		task.spawn(function()
			local deadline = os.clock() + 30
			while not trackerGui and os.clock() < deadline do
				pcall(BuildTracker)
				if not trackerGui then
					task.wait(1)
				end
			end
		end)
	end

	local EggPlaceGroup = EggTab:AddLeftGroupbox("Egg Placement", "package")
	EggPlaceGroup:AddDropdown("Dropdown_Place_Eggs", {
		Text = "Eggs",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.PlaceSelectedEggs = MapSelection(sel)
		end,
	})
	EggPlaceGroup:AddDropdown("Dropdown_Place_Rarities", {
		Text = "Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.PlaceSelectedRarities = MapSelection(sel)
		end,
	})
	EggPlaceGroup:AddDropdown("Dropdown_Place_Mutations", {
		Text = "Mutations",
		Values = MutationList,
		Default = { "None" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.PlaceSelectedMutations = MapSelection(sel)
		end,
	})
	EggPlaceGroup:AddDropdown("Dropdown_Place_FilterRule", {
		Text = "Filter Rule",
		Values = { "Match Any", "Match All" },
		Default = "Match Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.PlaceFilterRule = v
		end,
	})
	EggPlaceGroup:AddToggle("Toggle_AutoPlaceEggs", {
		Text = "Auto Place Eggs",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoPlaceEggs = s
		end,
	})
	EggPlaceGroup:AddToggle("Toggle_AutoHatch", {
		Text = "Auto Hatch Egg",
		Default = false,
		Tooltip = "Kalo ada egg yang udah siap (Ready), langsung di-hatch tanpa delay (parity Chili)",
		Callback = function(s)
			FarmConfig.AutoHatch = s
		end,
	})

	local ProgressGroup = EggTab:AddRightGroupbox("Plot Progress", "flag")
	ProgressGroup:AddDropdown("Dropdown_HatchUpgradeMode", {
		Text = "Hatch Upgrade Mode",
		Values = { "Smart Balance", "Max Possible", "Keep 100k Cash" },
		Default = "Smart Balance",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.HatchUpgradeMode = v
		end,
	})
	ProgressGroup:AddToggle("Toggle_AutoBuyHatchUpgrades", {
		Text = "Auto Buy Hatch Upgrades",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoBuyHatchUpgrades = s
		end,
	})
	ProgressGroup:AddToggle("Toggle_AutoUnlockNests", {
		Text = "Auto Unlock Nests",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoUnlockNests = s
		end,
	})

	-- TAB 2: PETS
	local PetsTab = MainWindow:AddTab("Pets", "paw-print", "Pet Placement, Auto Replacement, Riding & Feeding")
	local PetPlaceGroup = PetsTab:AddLeftGroupbox("Pet Placement", "paw-print")

	PetPlaceGroup:AddDropdown("Dropdown_PetPlace_Names", {
		Text = "Pet Names",
		Values = PetNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.PlacePet_Names = MapSelection(sel)
		end,
	})
	PetPlaceGroup:AddDropdown("Dropdown_PetPlace_Rarities", {
		Text = "Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.PlacePet_Rarities = MapSelection(sel)
		end,
	})
	PetPlaceGroup:AddDropdown("Dropdown_PetPlace_Mutations", {
		Text = "Mutations",
		Values = MutationList,
		Default = { "None" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.PlacePet_Mutations = MapSelection(sel)
		end,
	})
	PetPlaceGroup:AddDropdown("Dropdown_PetPlace_FilterRule", {
		Text = "Filter Rule",
		Values = { "Match Any", "Match All" },
		Default = "Match Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.PlacePet_FilterRule = v
		end,
	})
	PetPlaceGroup:AddToggle("Toggle_AutoPlaceBestPets", {
		Text = "Auto Place Best Pets",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoPlaceBestPets = s
		end,
	})

	local PetReplaceGroup = PetsTab:AddLeftGroupbox("Pet Replacement", "refresh-cw")
	PetReplaceGroup:AddDropdown("Dropdown_ReplaceWith_Names", {
		Text = "Replace With Names",
		Values = PetNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.ReplaceWith_Names = MapSelection(sel)
		end,
	})
	PetReplaceGroup:AddDropdown("Dropdown_ReplaceWith_Rarities", {
		Text = "Replace With Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.ReplaceWith_Rarities = MapSelection(sel)
		end,
	})
	PetReplaceGroup:AddDropdown("Dropdown_ReplaceWith_Mutations", {
		Text = "Replace With Mutations",
		Values = MutationList,
		Default = { "None" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.ReplaceWith_Mutations = MapSelection(sel)
		end,
	})
	PetReplaceGroup:AddDropdown("Dropdown_TargetReplace_Names", {
		Text = "Target Names",
		Values = PetNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.TargetReplace_Names = MapSelection(sel)
		end,
	})
	PetReplaceGroup:AddDropdown("Dropdown_TargetReplace_Rarities", {
		Text = "Target Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.TargetReplace_Rarities = MapSelection(sel)
		end,
	})
	PetReplaceGroup:AddDropdown("Dropdown_TargetReplace_Mutations", {
		Text = "Target Mutations",
		Values = MutationList,
		Default = { "None" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.TargetReplace_Mutations = MapSelection(sel)
		end,
	})
	PetReplaceGroup:AddDropdown("Dropdown_Replace_FilterRule", {
		Text = "Filter Rule",
		Values = { "Match Any", "Match All" },
		Default = "Match Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.Replace_FilterRule = v
		end,
	})
	PetReplaceGroup:AddInput("Input_MinIncomeGain", {
		Text = "Min Income Gain",
		Default = "0",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.MinIncomeGain = tonumber(v) or 0
		end,
	})
	PetReplaceGroup:AddToggle("Toggle_AutoReplaceLowerPets", {
		Text = "Auto Replace Lower Pets",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoReplaceLowerPets = s
		end,
	})

	local PetSellGroup = PetsTab:AddLeftGroupbox("Pet Selling", "dollar-sign")
	PetSellGroup:AddDropdown("Dropdown_Sell_Names", {
		Text = "Pet Names",
		Values = PetNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Sell_Names = MapSelection(sel)
		end,
	})
	PetSellGroup:AddDropdown("Dropdown_Sell_Rarities", {
		Text = "Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Sell_Rarities = MapSelection(sel)
		end,
	})
	PetSellGroup:AddDropdown("Dropdown_Sell_Mutations", {
		Text = "Mutations",
		Values = MutationList,
		Default = { "None" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Sell_Mutations = MapSelection(sel)
		end,
	})
	PetSellGroup:AddDropdown("Dropdown_Sell_FilterRule", {
		Text = "Filter Rule",
		Values = { "Match Any", "Match All" },
		Default = "Match Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.Sell_FilterRule = v
		end,
	})
	PetSellGroup:AddInput("Input_MinSellIncome", {
		Text = "Min Sell Income",
		Default = "",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.MinSellIncome = tonumber(v) or 0
		end,
	})
	PetSellGroup:AddInput("Input_MaxSellIncome", {
		Text = "Max Sell Income",
		Default = "",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.MaxSellIncome = tonumber(v) or math.huge
		end,
	})
	PetSellGroup:AddInput("Input_MinSellWeightKg", {
		Text = "Min Sell Weight Kg",
		Default = "",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.MinSellWeightKg = tonumber(v) or 0
		end,
	})
	PetSellGroup:AddInput("Input_MaxSellWeightKg", {
		Text = "Max Sell Weight Kg",
		Default = "",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.MaxSellWeightKg = tonumber(v) or math.huge
		end,
	})
	PetSellGroup:AddToggle("Toggle_AutoSellSelected", {
		Text = "Auto Sell Selected",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoSellSelected = s
		end,
	})
	PetSellGroup:AddToggle("Toggle_AutoSellAllPets", {
		Text = "Auto Sell All Pets",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoSellAllPets = s
		end,
	})

	local PetIncomeGroup = PetsTab:AddRightGroupbox("Pet Income", "coins")
	PetIncomeGroup:AddToggle("Toggle_AutoCollectPetCash", {
		Text = "Auto Collect Pet Cash",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoCollectPetCash = s
		end,
	})

	local FeedingGroup = PetsTab:AddRightGroupbox("Feeding", "utensils")
	FeedingGroup:AddDropdown("Dropdown_Feed_Foods", {
		Text = "Foods",
		Values = FoodList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Feed_Foods = MapSelection(sel)
		end,
	})
	FeedingGroup:AddToggle("Toggle_Feed_PrioritizeBest", {
		Text = "Prioritize Best Pet",
		Default = false,
		Callback = function(s)
			FarmConfig.Feed_PrioritizeBest = s
		end,
	})
	FeedingGroup:AddInput("Input_Feed_MinIncome", {
		Text = "Minimum Pet $/s",
		Default = "0",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.Feed_MinIncome = tonumber(v) or 0
		end,
	})
	FeedingGroup:AddInput("Input_Feed_MinAge", {
		Text = "Minimum Pet Age",
		Default = "0",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.Feed_MinAge = tonumber(v) or 0
		end,
	})
	FeedingGroup:AddDropdown("Dropdown_Feed_Rarities", {
		Text = "Pet Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Feed_Rarities = MapSelection(sel)
		end,
	})
	FeedingGroup:AddToggle("Toggle_AutoFeedPets", {
		Text = "Auto Feed Pets",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoFeedPets = s
		end,
	})

	-- TAB 3: PROGRESS
	local ProgressTab = MainWindow:AddTab("Progress", "trending-up", "Cash Shop Purchases & Automated Rebirths")
	local CashShopGroup = ProgressTab:AddLeftGroupbox("Cash Shop", "shopping-cart")

	-- Label Stock: list semua item, yang in-stock hijau + [Nx], sisanya putih
	local Lbl_ShopStock = CashShopGroup:AddLabel("", true)

	task.spawn(function()
		while true do
			task.wait(3.0)
			pcall(function()
				local lines = { '<font color="#D946EF"><b>Stock:</b></font>' }
				for i, item in ipairs(ShopItemList) do
					local category = ShopItemCategoryMap[tostring(item)]
					local stockMap = category and RuntimeState.ShopStock[tostring(category)]
					local stockNum = tonumber(stockMap and stockMap[tostring(item)]) or 0
					if stockNum > 0 then
						table.insert(
							lines,
							string.format(
								'<font color="#57F287"><b>%d. %s [%dx]</b></font>',
								i,
								tostring(item),
								stockNum
							)
						)
					else
						table.insert(lines, string.format("%d. %s", i, tostring(item)))
					end
				end
				Lbl_ShopStock:SetText(table.concat(lines, "\n"))
			end)
		end
	end)

	CashShopGroup:AddDropdown("Dropdown_Shop_Items", {
		Text = "Items",
		Values = ShopItemList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Shop_Items = MapSelection(sel)
		end,
	})
	CashShopGroup:AddToggle("Toggle_AutoBuyShopItems", {
		Text = "Auto Buy Selected Items",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoBuySelectedItems = s
		end,
	})
	CashShopGroup:AddInput("Input_Shop_KeepCash", {
		Text = "Keep Cash",
		Default = "0",
		Placeholder = "0",
		Numeric = true,
		Finished = false,
		Tooltip = "Cash minimal yang disisain, auto buy gak bakal nabrak ini",
		Callback = function(v)
			FarmConfig.Shop_KeepCash = tonumber(v) or 0
		end,
	})

	local RewardsGroup = ProgressTab:AddRightGroupbox("Rewards", "gift")
	RewardsGroup:AddToggle("Toggle_AutoClaimSafeRewards", {
		Text = "Auto Claim Safe Rewards",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoClaimSafeRewards = s
		end,
	})
	RewardsGroup:AddToggle("Toggle_AutoRebirthWhenReady", {
		Text = "Auto Rebirth When Ready",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoRebirthWhenReady = s
		end,
	})

	-- TAB 4: ESP
	local ESPTab = MainWindow:AddTab("ESP", "eye", "Visual Map Trackers & Automated Plot Gears")
	local EggESPGroup = ESPTab:AddLeftGroupbox("Egg ESP", "eye")

	EggESPGroup:AddDropdown("Dropdown_ESP_Eggs", {
		Text = "Eggs",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.ESP_Egg_Names = MapSelection(sel)
		end,
	})
	EggESPGroup:AddDropdown("Dropdown_ESP_Rarities", {
		Text = "Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.ESP_Egg_Rarities = MapSelection(sel)
		end,
	})
	EggESPGroup:AddDropdown("Dropdown_ESP_Mutations", {
		Text = "Mutations",
		Values = MutationList,
		Default = { "None" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.ESP_Egg_Mutations = MapSelection(sel)
		end,
	})
	EggESPGroup:AddDropdown("Dropdown_ESP_EggRule", {
		Text = "Filter Rule",
		Values = { "Match Any", "Match All" },
		Default = "Match Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.ESP_Egg_FilterRule = v
		end,
	})
	EggESPGroup:AddToggle("Toggle_EggESP", {
		Text = "Egg ESP",
		Default = false,
		Callback = function(s)
			FarmConfig.ESP_Egg_Enabled = s
		end,
	})

	local PetESPGroup = ESPTab:AddLeftGroupbox("Pet ESP", "paw-print")
	PetESPGroup:AddToggle("Toggle_ESP_ShowMyPets", {
		Text = "Show My Pets",
		Default = true,
		Callback = function(s)
			FarmConfig.ESP_Pet_ShowMine = s
		end,
	})
	PetESPGroup:AddToggle("Toggle_ESP_ShowOthersPets", {
		Text = "Show Other Players' Pets",
		Default = false,
		Callback = function(s)
			FarmConfig.ESP_Pet_ShowOthers = s
		end,
	})
	PetESPGroup:AddDropdown("Dropdown_ESP_PetRarities", {
		Text = "Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.ESP_Pet_Rarities = MapSelection(sel)
		end,
	})
	PetESPGroup:AddInput("Input_ESP_MinIncome", {
		Text = "Minimum $/s",
		Default = "0",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.ESP_Pet_MinIncome = tonumber(v) or 0
		end,
	})
	PetESPGroup:AddToggle("Toggle_PetESP", {
		Text = "Pet ESP",
		Default = false,
		Callback = function(s)
			FarmConfig.ESP_Pet_Enabled = s
		end,
	})

	local PlotGearGroup = ESPTab:AddRightGroupbox("Plot Gear", "scan")
	PlotGearGroup:AddDropdown("Dropdown_Gear_Radars", {
		Text = "Radars",
		Values = RadarList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Gear_Radars = MapSelection(sel)
		end,
	})
	PlotGearGroup:AddToggle("Toggle_AutoActivateRadar", {
		Text = "Auto Activate Radar",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoActivateRadar = s
		end,
	})
	PlotGearGroup:AddDropdown("Dropdown_Gear_Lanterns", {
		Text = "Lanterns",
		Values = LanternList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Gear_Lanterns = MapSelection(sel)
		end,
	})
	PlotGearGroup:AddToggle("Toggle_AutoPlaceLantern", {
		Text = "Auto Place Lantern",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoPlaceLantern = s
		end,
	})

	-- TAB 4B: MISC (Performance + Player dipindah ke sini biar tab rapih)
	local MiscTab = MainWindow:AddTab("Misc", "wrench", "Performance, Movement & FPS Tools")
	local PerfGroup = MiscTab:AddLeftGroupbox("Performance", "activity")

	PerfGroup:AddToggle("Toggle_Misc_AntiAfk", {
		Text = "Anti AFK",
		Default = true,
		Tooltip = "Anti kick 20 menit idle (butuh getconnections)",
		Callback = function(s)
			FarmConfig.AntiAFK_Enabled = s
			pcall(N3Misc.SetAntiAfk, s)
		end,
	})
	PerfGroup:AddSlider("Slider_Misc_FpsCap", {
		Text = "FPS Cap",
		Min = 30,
		Max = 1000,
		Default = 240,
		Increment = 1,
		Tooltip = "Batas FPS (butuh setfpscap)",
		Callback = function(v)
			FarmConfig.FPS_Cap = math.clamp(math.floor(tonumber(v) or 240), 30, 1000)
			pcall(N3Misc.SetFpsCap, FarmConfig.FPS_Cap)
		end,
	})
	local MoveGroup = MiscTab:AddLeftGroupbox("Movement", "move")

	MoveGroup:AddToggle("Toggle_Player_SpeedBoost", {
		Text = "Speed Boost",
		Default = false,
		Tooltip = "Boost kecepatan jalan saat main manual (auto-off selama automasi jalan)",
		Callback = function(s)
			FarmConfig.Movement_SpeedBoost = s
		end,
	})
	MoveGroup:AddSlider("Slider_Player_BoostSpeed", {
		Text = "Boost Speed",
		Min = 16,
		Max = 1300,
		Default = 60,
		Increment = 1,
		Tooltip = "Kecepatan boost (studs/s)",
		Callback = function(v)
			FarmConfig.Movement_BoostSpeed = math.clamp(tonumber(v) or 60, 16, 1300)
		end,
	})
	MoveGroup:AddToggle("Toggle_Player_InfiniteJump", {
		Text = "Infinite Jump",
		Default = false,
		Tooltip = "Bisa lompat lagi di udara",
		Callback = function(s)
			FarmConfig.Movement_InfiniteJump = s
		end,
	})
	MoveGroup:AddToggle("Toggle_Player_Noclip", {
		Text = "Noclip",
		Default = false,
		Tooltip = "Tembus tembok saat main manual (collision dikembalikan otomatis pas toggle off)",
		Callback = function(s)
			FarmConfig.Movement_Noclip = s
		end,
	})
	MoveGroup:AddToggle("Toggle_Player_InstantPickup", {
		Text = "Instant Pickup",
		Default = false,
		Tooltip = "HoldDuration 0 buat semua ProximityPrompt (pickup/interact instan)",
		Callback = function(s)
			FarmConfig.InstanPickup = s
			if s then
				pcall(N3Misc.EnableInstantPickup)
			else
				pcall(N3Misc.RestoreInstantPickup)
			end
		end,
	})

	local FpsBoosterGroup = MiscTab:AddRightGroupbox("FPS Booster", "zap")

	FpsBoosterGroup:AddToggle("Toggle_Misc_HideOtherPets", {
		Text = "Hide Other Players' Pets",
		Default = false,
		Tooltip = "Sembunyikan pet di plot lain (FPS naik besar)",
		Callback = function(s)
			FarmConfig.HideOtherPets_Enabled = s
			pcall(N3Misc.SetHideOtherPets, s)
		end,
	})
	FpsBoosterGroup:AddToggle("Toggle_Misc_Optimizer", {
		Text = "Optimizer",
		Default = false,
		Tooltip = "Strip shadow/tekstur/efek buat FPS tertinggi (bisa di-restore)",
		Callback = function(s)
			FarmConfig.Optimizer_Enabled = s
			pcall(N3Misc.SetOptimizer, s)
		end,
	})
	FpsBoosterGroup:AddToggle("Toggle_Misc_Disable3D", {
		Text = "Disable 3D Rendering",
		Default = false,
		Tooltip = "Matikan render 3D pas AFK, farm tetap jalan",
		Callback = function(s)
			FarmConfig.Disable3DRendering_Enabled = s
			pcall(N3Misc.Set3DRendering, s)
		end,
	})

	-- TAB 5: WEBHOOK
	local NotifTab = MainWindow:AddTab("Webhook", "bell", "Discord Webhook Logging & Remote Notifications")

	local HopGroup = NotifTab:AddRightGroupbox("Server Hop", "globe")
	HopGroup:AddInput("Input_Hop_NoTargetDelay", {
		Text = "No Target Delay Secs",
		Default = "20",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.NoTargetDelaySecs = math.max(5, tonumber(v) or 20)
		end,
	})
	HopGroup:AddToggle("Toggle_AutoHopEggs", {
		Text = "Auto Hop Eggs",
		Default = false,
		Callback = function(s)
			FarmConfig.AutoHopEggs = s
			RuntimeState.LastEggFoundTime = os.clock()
		end,
	})
	HopGroup:AddDropdown("Dropdown_Hop_Mode", {
		Text = "Hop Mode",
		Values = { "Least Players", "Most Players", "Random" },
		Default = "Least Players",
		Multi = false,
		AllowNull = false,
		Tooltip = "Least Players = cari server paling sepi (bagus buat farm egg)",
		Callback = function(v)
			FarmConfig.Hop_Mode = tostring(v or "Least Players")
		end,
	})
	HopGroup:AddToggle("Toggle_Hop_AutoReload", {
		Text = "Auto Reload After Hop",
		Default = true,
		Tooltip = "Queue ulang script ini abis pindah server (isi Script URL di bawah)",
		Callback = function(s)
			FarmConfig.AutoHopReload = s
		end,
	})
	HopGroup:AddInput("Input_Hop_ScriptURL", {
		Text = "Script URL",
		Default = "",
		Placeholder = "URL raw script buat auto reload (optional)",
		Numeric = false,
		Finished = true,
		Tooltip = "Kalau kosong, hub ga auto-reload abis hop",
		Callback = function(v)
			FarmConfig.ScriptURL = tostring(v or "")
		end,
	})

	HopGroup:AddDivider()

	HopGroup:AddButton("Server Hop Now", function()
		pcall(N3Misc.ServerHopNow)
	end)

	local JobIdInput = ""

	HopGroup:AddInput("Input_Server_JobId", {
		Text = "Job ID",
		Default = "",
		Placeholder = "Paste a server Job ID...",
		Numeric = false,
		Finished = false,
		Callback = function(v)
			JobIdInput = tostring(v or "")
		end,
	})

	HopGroup:AddButton("Join Job ID", function()
		pcall(N3Misc.JoinJobId, JobIdInput)
	end)

	HopGroup:AddButton("Copy Current Job ID", function()
		pcall(N3Misc.CopyJobId)
	end)

	HopGroup:AddButton("Rejoin Server", function()
		pcall(N3Misc.RejoinServer)
	end)

	local WebhookConfigGroup = NotifTab:AddLeftGroupbox("Config", "message-square")

	WebhookConfigGroup:AddInput("Input_WebhookURL", {
		Text = "Webhook URL",
		Default = "",
		Placeholder = "Discord webhook URL",
		Finished = true,
		Callback = function(v)
			FarmConfig.Webhook_URL = v
		end,
	})
	WebhookConfigGroup:AddToggle("Toggle_EnableWebhook", {
		Text = "Enable Webhook",
		Default = false,
		Callback = function(s)
			FarmConfig.Webhook_Enabled = s
		end,
	})
	WebhookConfigGroup:AddInput("Input_WebhookInterval", {
		Text = "Interval Minutes",
		Default = "5",
		Numeric = true,
		Finished = false,
		Callback = function(v)
			FarmConfig.Webhook_IntervalMinutes = math.max(1, tonumber(v) or 5)
		end,
	})
	WebhookConfigGroup:AddToggle("Toggle_WebhookPingEveryone", {
		Text = "Ping @everyone",
		Default = false,
		Callback = function(s)
			FarmConfig.Webhook_PingEveryone = s
		end,
	})

	local WebhookCustomizeGroup = NotifTab:AddRightGroupbox("Customize", "sliders")
	local WebhookTabbox = WebhookCustomizeGroup:AddTabbox({ Name = "Webhook Tabs" })
	local SummarySubTab = WebhookTabbox:AddTab("Summary", "bar-chart-2")
	local EventsSubTab = WebhookTabbox:AddTab("Events", "sparkles")

	SummarySubTab:AddToggle("Tog_SendSummaryInterval", {
		Text = "Send Summary on Interval",
		Default = false,
		Callback = function(s)
			FarmConfig.Webhook_SendSummaryOnInterval = s
		end,
	})
	SummarySubTab:AddDivider({ Text = "FIELDS" })
	SummarySubTab:AddToggle("Tog_FieldPlayer", {
		Text = "Player",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_Field_Player = s
		end,
	})
	SummarySubTab:AddToggle("Tog_FieldSession", {
		Text = "Session",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_Field_Session = s
		end,
	})
	SummarySubTab:AddToggle("Tog_FieldCashProgress", {
		Text = "Cash and Progress",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_Field_CashProgress = s
		end,
	})
	SummarySubTab:AddToggle("Tog_FieldInventory", {
		Text = "Inventory",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_Field_Inventory = s
		end,
	})
	SummarySubTab:AddToggle("Tog_FieldPlacedPets", {
		Text = "Placed Pets",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_Field_PlacedPets = s
		end,
	})
	SummarySubTab:AddToggle("Tog_FieldRecentPets", {
		Text = "Recent Pets",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_Field_RecentPets = s
		end,
	})
	SummarySubTab:AddToggle("Tog_FieldPlot", {
		Text = "Plot",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_Field_Plot = s
		end,
	})

	EventsSubTab:AddToggle("Tog_Ev_ClaimedEgg", {
		Text = "Send on Claimed Egg",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_SendOnClaimedEgg = s
		end,
	})
	EventsSubTab:AddToggle("Tog_Ev_RarePet", {
		Text = "Send on Rare Pet",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_SendOnRarePet = s
		end,
	})
	EventsSubTab:AddToggle("Tog_Ev_LightningMut", {
		Text = "Send on Lightning Mutation",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_SendOnLightningMut = s
		end,
	})
	EventsSubTab:AddToggle("Tog_Ev_WeatherStart", {
		Text = "Send on Weather Start",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_SendOnWeather = s
		end,
	})
	EventsSubTab:AddToggle("Tog_Ev_Disconnect", {
		Text = "Send on Disconnect",
		Default = true,
		Callback = function(s)
			FarmConfig.Webhook_SendOnDisconnect = s
		end,
	})

	EventsSubTab:AddDivider({ Text = "FILTERS" })

	EventsSubTab:AddDropdown("Dropdown_Wh_ClaimedEggs", {
		Text = "Claimed Egg Eggs",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Kosong = semua egg ke-notify pas di-claim",
		Callback = function(sel)
			FarmConfig.Webhook_Claimed_Eggs = MapSelection(sel)
		end,
	})
	EventsSubTab:AddDropdown("Dropdown_Wh_ClaimedRarities", {
		Text = "Claimed Egg Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Webhook_Claimed_Rarities = MapSelection(sel)
		end,
	})
	EventsSubTab:AddDropdown("Dropdown_Wh_ClaimedMutations", {
		Text = "Claimed Egg Mutations",
		Values = MutationList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(sel)
			FarmConfig.Webhook_Claimed_Mutations = MapSelection(sel)
		end,
	})
	EventsSubTab:AddDropdown("Dropdown_Wh_ClaimedRule", {
		Text = "Claimed Egg Rule",
		Values = { "Match Any", "Match All" },
		Default = "Match Any",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.Webhook_Claimed_Rule = tostring(v or "Match Any")
		end,
	})
	EventsSubTab:AddDropdown("Dropdown_Wh_PetRarities", {
		Text = "Rare Pet Rarities",
		Values = RarityList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Kosong = semua pet baru ke-notify",
		Callback = function(sel)
			FarmConfig.Webhook_Pet_Rarities = MapSelection(sel)
		end,
	})
	EventsSubTab:AddDropdown("Dropdown_Wh_AlwaysSend", {
		Text = "Always Send Pets",
		Values = PetNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Species ini selalu ke-notify walau rarity filter ga match",
		Callback = function(sel)
			FarmConfig.Webhook_Always_Send_Pets = MapSelection(sel)
		end,
	})
	EventsSubTab:AddDropdown("Dropdown_Wh_Lightning", {
		Text = "Lightning Mutations",
		Values = MutationList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Kosong = deteksi otomatis mutation Lightning",
		Callback = function(sel)
			FarmConfig.Webhook_Lightning_Mutations = MapSelection(sel)
		end,
	})
	EventsSubTab:AddInput("Input_Wh_MinHatchedIncome", {
		Text = "Min Hatched Income",
		Default = "0",
		Numeric = true,
		Finished = false,
		Tooltip = "Pet baru cuma ke-notify kalau $/s >= nilai ini",
		Callback = function(v)
			FarmConfig.Webhook_MinHatchedIncome = tonumber(v) or 0
		end,
	})

	-- TAB 6: SETTINGS
	local SettingsTab = MainWindow:AddTab("Settings", "settings", "Manage Hub Themes & Config Profiles")
	local SaveManager = loadstring(
		game:HttpGet("https://raw.githubusercontent.com/LuxyG15/N3-Hub/refs/heads/main/Manager/SaveManager.lua")
	)()
	local ThemeManager = loadstring(
		game:HttpGet("https://raw.githubusercontent.com/LuxyG15/N3-Hub/refs/heads/main/Manager/ThemeManager.lua")
	)()

	SaveManager:SetLibrary(LibraryLoader)
	SaveManager:SetFolder("N3Hub")
	SaveManager:SetSubFolder("RideAPet")

	ThemeManager:SetLibrary(LibraryLoader)
	ThemeManager:SetFolder("N3Hub")
	SaveManager:IgnoreThemeSettings()

	ThemeManager:ApplyToTab(SettingsTab)
	SaveManager:BuildConfigSection(SettingsTab)
end

BuildInterface()

-- =====================================================================
-- UNIFIED CHILI SINGLE-THREAD AUTOMATION ENGINE (NO CONFLICTS)
-- =====================================================================

local function ExecuteHatching()
	local plot = ChiliEngine.GetPlot()
	local eggsFolder = plot and plot:FindFirstChild("Eggs")
	if not eggsFolder then
		return
	end

	-- PARITY CHILI (fn17/HatchStep): hatch SEMUA egg yang udah siap
	-- (prompt Enabled + Timer "Ready"), tanpa cooldown & tanpa batas jumlah.
	local hatched = 0
	for _, eggModel in ipairs(eggsFolder:GetChildren()) do
		local timer = eggModel:FindFirstChild("Timer", true)
		local prompt = eggModel:FindFirstChild("Hatch", true)

		if
			prompt
			and prompt:IsA("ProximityPrompt")
			and prompt.Enabled
			and timer
			and timer:IsA("TextLabel")
			and timer.Text == "Ready"
		then
			local pos = eggModel:GetPivot().Position
			if not ChiliEngine.FlyTo(pos + Vector3.new(0, 3, 3), nil, 5) then
				continue
			end

			RuntimeState.StatusText = "Hatching " .. tostring(eggModel.Name)
			if typeof(fireproximityprompt) == "function" then
				pcall(fireproximityprompt, prompt)
			else
				pcall(function()
					prompt:InputHoldBegin()
					task.wait(prompt.HoldDuration + 0.1)
					prompt:InputHoldEnd()
				end)
			end

			local deadline = os.clock() + 2.0
			while eggModel.Parent ~= nil and os.clock() < deadline do
				RunService.Heartbeat:Wait()
			end
			if eggModel.Parent == nil then
				hatched += 1
			end
		end
	end

	if hatched > 0 then
		task.wait(0.5)
	end
	ChiliEngine.UnequipAll()
end

local function ExecutePlanting()
	local eggTools = ChiliEngine.GetTools("Egg")
	if #eggTools == 0 then
		return
	end

	for _, tool in ipairs(eggTools) do
		local meta = GameData.Eggs[tool.Name] or {}
		local rarity = tostring(meta.Rarity or "Common")
		local mut = tostring(tool:GetAttribute("Mutation") or "None")

		if
			EvaluateFilter(
				tool.Name,
				rarity,
				mut,
				FarmConfig.PlaceSelectedEggs,
				FarmConfig.PlaceSelectedRarities,
				FarmConfig.PlaceSelectedMutations,
				FarmConfig.PlaceFilterRule
			)
		then
			local plantSpot = ChiliEngine.GetRandomPlotPoint(8, nil, 5)
			if plantSpot and ChiliEngine.EquipTool(tool) then
				pcall(function()
					GameRemotes.EggPlaced:FireServer({ PlantPosition = plantSpot })
				end)
				task.wait(0.4)
				ChiliEngine.UnequipAll()
			end
		end
	end
end

local function ExecutePetPlacing()
	local placed = ChiliEngine.GetPlacedPets()
	local maxPets = ChiliEngine.GetMaxPets()

	if #placed < maxPets then
		local eligible = {}
		for _, tool in ipairs(ChiliEngine.GetTools("Pet")) do
			local pName = tool:GetAttribute("PetName") or string.gsub(tool.Name, "%s*%[.*$", "")
			local meta = GameData.Pets[pName] or {}
			local rarity = tostring(meta.Rarity or "Common")
			local mut = tostring(tool:GetAttribute("Mutation") or "None")

			if
				EvaluateFilter(
					pName,
					rarity,
					mut,
					FarmConfig.PlacePet_Names,
					FarmConfig.PlacePet_Rarities,
					FarmConfig.PlacePet_Mutations,
					FarmConfig.PlacePet_FilterRule
				)
			then
				table.insert(
					eligible,
					{ Tool = tool, Score = ChiliEngine.GetPetScore(tool), Key = tool:GetAttribute("PetKey") }
				)
			end
		end

		table.sort(eligible, function(a, b)
			return a.Score > b.Score
		end)

		if #eligible > 0 then
			local best = eligible[1]
			local spot = ChiliEngine.GetRandomPlotPoint(10, nil, 0)
			if spot and best.Key and ChiliEngine.EquipTool(best.Tool) then
				pcall(function()
					GameRemotes.PlacePet:FireServer(best.Key, spot + Vector3.new(0, 2, 0))
				end)
				task.wait(0.35)
				ChiliEngine.UnequipAll()
			end
		end
	end
end

local function ExecutePetReplacement()
	local placed = ChiliEngine.GetPlacedPets()
	local maxPets = ChiliEngine.GetMaxPets()

	if #placed >= maxPets then
		local worstPlaced, lowestScore = nil, math.huge
		for _, model in ipairs(placed) do
			local pName = model:GetAttribute("PetName") or model.Name
			local meta = GameData.Pets[pName] or {}
			local rarity = tostring(meta.Rarity or "Common")
			local mut = tostring(model:GetAttribute("Mutation") or "None")

			if
				EvaluateFilter(
					pName,
					rarity,
					mut,
					FarmConfig.TargetReplace_Names,
					FarmConfig.TargetReplace_Rarities,
					FarmConfig.TargetReplace_Mutations,
					FarmConfig.Replace_FilterRule
				)
			then
				local s = ChiliEngine.GetPetScore(model)
				if s < lowestScore then
					lowestScore = s
					worstPlaced = model
				end
			end
		end

		local bestTool, highestScore = nil, -1
		for _, tool in ipairs(ChiliEngine.GetTools("Pet")) do
			local tName = tool:GetAttribute("PetName") or string.gsub(tool.Name, "%s*%[.*$", "")
			local meta = GameData.Pets[tName] or {}
			local rarity = tostring(meta.Rarity or "Common")
			local mut = tostring(tool:GetAttribute("Mutation") or "None")

			if
				EvaluateFilter(
					tName,
					rarity,
					mut,
					FarmConfig.ReplaceWith_Names,
					FarmConfig.ReplaceWith_Rarities,
					FarmConfig.ReplaceWith_Mutations,
					FarmConfig.Replace_FilterRule
				)
			then
				local s = ChiliEngine.GetPetScore(tool)
				if s > highestScore then
					highestScore = s
					bestTool = tool
				end
			end
		end

		if worstPlaced and bestTool and (highestScore - lowestScore) >= FarmConfig.MinIncomeGain then
			local wKey = worstPlaced:GetAttribute("PetKey")
			local bKey = bestTool:GetAttribute("PetKey")

			if wKey and bKey then
				pcall(function()
					GameRemotes.PickupPet:FireServer(wKey)
				end)
				local waitEnd = os.clock() + 1.5
				while worstPlaced.Parent ~= nil and os.clock() < waitEnd do
					RunService.Heartbeat:Wait()
				end

				local spot = ChiliEngine.GetRandomPlotPoint(10, nil, 0)
				if spot and ChiliEngine.EquipTool(bestTool) then
					pcall(function()
						GameRemotes.PlacePet:FireServer(bKey, spot + Vector3.new(0, 2, 0))
					end)
					task.wait(0.35)
					ChiliEngine.UnequipAll()
				end
			end
		end
	end
end

local function ExecuteFeeding()
	local foodTools = ChiliEngine.GetTools("Food")
	if #foodTools == 0 then
		return
	end

	local placed = ChiliEngine.GetPlacedPets()
	if FarmConfig.Feed_PrioritizeBest then
		table.sort(placed, function(a, b)
			return ChiliEngine.GetPetScore(a) > ChiliEngine.GetPetScore(b)
		end)
	end

	for _, model in ipairs(placed) do
		local key = model:GetAttribute("PetKey")
		local pName = model:GetAttribute("PetName") or model.Name
		local meta = GameData.Pets[pName] or {}
		local rarity = tostring(meta.Rarity or "Common")
		local inc = ChiliEngine.GetPetScore(model)
		local age = tonumber(model:GetAttribute("Age")) or 0

		local passRarity = (next(FarmConfig.Feed_Rarities) == nil)
			or (FarmConfig.Feed_Rarities[string.lower(rarity)] == true)
		local passIncome = inc >= FarmConfig.Feed_MinIncome
		local passAge = age >= FarmConfig.Feed_MinAge
		local cooldown = (RuntimeState.FeedCooldowns[key] or 0) > os.clock()

		if key and passRarity and passIncome and passAge and not cooldown then
			local selectedFood = nil
			for _, ft in ipairs(foodTools) do
				if (next(FarmConfig.Feed_Foods) == nil) or (FarmConfig.Feed_Foods[string.lower(ft.Name)] == true) then
					selectedFood = ft
					break
				end
			end

			if selectedFood then
				local pos = model:GetPivot().Position
				ChiliEngine.FlyTo(pos + Vector3.new(0, 4, 4), nil, 6)

				if ChiliEngine.EquipTool(selectedFood) then
					local oldAge = age
					pcall(function()
						GameRemotes.FeedPet:FireServer(key, selectedFood.Name)
					end)
					local fEnd = os.clock() + 1.2
					while (tonumber(model:GetAttribute("Age")) or 0) == oldAge and os.clock() < fEnd do
						RunService.Heartbeat:Wait()
					end
					RuntimeState.FeedCooldowns[key] = os.clock() + 2.5
					ChiliEngine.UnequipAll()
					break
				end
			end
		end
	end
end

local function ExecutePetSelling()
	if not (FarmConfig.AutoSellSelected or FarmConfig.AutoSellAllPets) then
		return
	end

	local tools = ChiliEngine.GetTools("Pet")
	if #tools == 0 then
		return
	end

	table.sort(tools, function(a, b)
		return ChiliEngine.GetPetScore(a) < ChiliEngine.GetPetScore(b)
	end)

	local queue = {}
	for _, tool in ipairs(tools) do
		local key = tool:GetAttribute("PetKey")
		if key and (RuntimeState.SellCooldowns[key] or 0) <= os.clock() then
			local name = tool:GetAttribute("PetName") or string.gsub(tool.Name, "%s*%[.*$", "")
			local meta = GameData.Pets[tostring(name)] or {}
			local rarity = tostring(meta.Rarity or "Common")
			local mut = tostring(tool:GetAttribute("Mutation") or "None")
			local weight = tonumber(tool:GetAttribute("Weight")) or 0
			local income = ChiliEngine.GetPetScore(tool)

			local selected = EvaluateFilter(
				name,
				rarity,
				mut,
				FarmConfig.Sell_Names,
				FarmConfig.Sell_Rarities,
				FarmConfig.Sell_Mutations,
				FarmConfig.Sell_FilterRule
			)

			local wanted = FarmConfig.AutoSellAllPets
			if FarmConfig.AutoSellSelected and selected then
				wanted = true
			end

			local inRange = income >= FarmConfig.MinSellIncome
				and income <= FarmConfig.MaxSellIncome
				and weight >= FarmConfig.MinSellWeightKg
				and weight <= FarmConfig.MaxSellWeightKg

			if wanted and inRange then
				queue[#queue + 1] = tool
			end
		end
	end

	if #queue == 0 then
		return
	end

	local prompt = ChiliEngine.GetSellPrompt()
	if not prompt or not prompt.Parent then
		return
	end

	local promptPart = prompt.Parent
	local spot = promptPart and promptPart.Position
	if not spot then
		return
	end

	ChiliEngine.FlyTo(spot + Vector3.new(0, 3, 0), nil, 8)

	local root = ChiliEngine.GetRoot()
	if not root or (root.Position - spot).Magnitude > 30 then
		return
	end

	local sold = 0
	for _, tool in ipairs(queue) do
		if sold >= 5 then
			break
		end
		local key = tool:GetAttribute("PetKey")
		RuntimeState.SellCooldowns[key] = os.clock() + 8
		ChiliEngine.FirePrompt(prompt)
		local t0 = os.clock()
		while tool.Parent ~= nil and (os.clock() - t0) < 1.2 do
			RunService.Heartbeat:Wait()
		end
		if tool.Parent == nil then
			sold += 1
		end
	end
end

local function ExecutePetCashCollection()
	if not FarmConfig.AutoCollectPetCash then
		return
	end

	local remote = ChiliEngine.GetCashRemote()
	if not remote then
		return
	end

	for _, model in ipairs(ChiliEngine.GetPlacedPets()) do
		local key = model:GetAttribute("PetKey")
		if key and (RuntimeState.CashCooldowns[key] or 0) <= os.clock() then
			RuntimeState.CashCooldowns[key] = os.clock() + 5
			pcall(function()
				remote:FireServer(key)
			end)
		end
	end
end

local function FinishBasket()
	if ChiliEngine.GetBasketCount() <= 0 then
		return
	end

	if FarmConfig.AutoVolcanoDip then
		ChiliEngine.VolcanoDip()

		if ChiliEngine.DipCandidateReady() and ChiliEngine.DipWindowOpen() then
			ChiliEngine.DipDebug("basket held - dip retrying next cycle")
			return
		end
	end

	if ChiliEngine.GetBasketCount() > 0 then
		ChiliEngine.Deliver(nil)
	end
end

local function ExecuteServerHop()
	if not FarmConfig.AutoHopEggs then
		return
	end
	if (os.clock() - RuntimeState.LastHopAt) < 15 then
		return
	end

	local idle = (os.clock() - RuntimeState.LastEggFoundTime) >= FarmConfig.NoTargetDelaySecs
	if not idle or ChiliEngine.GetBasketCount() > 0 then
		return
	end

	RuntimeState.LastHopAt = os.clock()

	if not RuntimeState.HopServers then
		RuntimeState.HopServers = FetchServers()
	end

	local now = os.clock()
	local pool = {}
	for _, server in ipairs(RuntimeState.HopServers) do
		local bl = RuntimeState.HopBlacklist[server.Id]
		if (not bl or bl <= now) and server.Room >= 2 then
			pool[#pool + 1] = server
		end
	end
	if #pool == 0 then
		for _, server in ipairs(RuntimeState.HopServers) do
			local bl = RuntimeState.HopBlacklist[server.Id]
			if not bl or bl <= now then
				pool[#pool + 1] = server
			end
		end
	end
	if #pool == 0 then
		RuntimeState.HopServers = FetchServers()
		return
	end

	local target
	if FarmConfig.Hop_Mode == "Random" then
		target = pool[math.random(1, #pool)]
	elseif FarmConfig.Hop_Mode == "Most Players" then
		table.sort(pool, function(a, b)
			return a.Playing > b.Playing
		end)
		target = pool[1]
	else
		table.sort(pool, function(a, b)
			return a.Playing < b.Playing
		end)
		target = pool[1]
	end
	RuntimeState.HopServers = nil

	-- FIX: dulu qot("") CUMA nge-clear queue -> abis hop hub mati dan farm
	-- AFK berhenti. Sekarang queue ulang script ini (Auto Load parity Chili)
	-- kalau user isi Script URL + nyalain Auto Reload.
	local qot = (getgenv and getgenv().queue_on_teleport)
		or (syn and syn.queue_on_teleport)
		or (fluxus and fluxus.queue_on_teleport)
	if typeof(qot) == "function" then
		pcall(qot, "")
		local url = tostring(FarmConfig.ScriptURL or "")
		if FarmConfig.AutoHopReload and url ~= "" then
			pcall(
				qot,
				'local ok, s = pcall(function() return game:HttpGet("'
					.. url
					.. '") end) if ok and type(s) == "string" then local chunk = loadstring(s) if chunk then chunk() end end'
			)
		end
	end

	RuntimeState.StatusText = "Server hopping..."
	local ok = pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, target.Id, LocalPlayer)
	end)
	if not ok then
		RuntimeState.HopBlacklist[target.Id] = os.clock() + 300
	end
	print("[N3 HUB] Hop: " .. tostring(ok) .. " -> " .. tostring(target.Id))
end

local function ExecuteNestUnlock()
	if not FarmConfig.AutoUnlockNests then
		return
	end
	local remote = ChiliEngine.GetNestRemote()
	if not remote then
		return
	end
	if (RuntimeState.NestCooldown or 0) > os.clock() then
		return
	end

	local id, price = ChiliEngine.GetNextLockedNest()
	if not id then
		return
	end

	local plot = ChiliEngine.GetPlot()
	local plotBase = ChiliEngine.GetPlotBase()
	if plot and plotBase then
		ChiliEngine.FlyTo(plotBase.Position + Vector3.new(0, plotBase.Size.Y / 2 + 6, 0), nil, 8)
	end

	RuntimeState.NestCooldown = os.clock() + 4
	pcall(function()
		remote:FireServer(id)
	end)
	print(string.format("[N3 HUB] Nest: unlock request for nest %d ($%s)", id, tostring(price)))
end

local function ExecuteRadarActivate()
	if not FarmConfig.AutoActivateRadar then
		return
	end
	local remote = ChiliEngine.GetRadarRemote()
	if not remote then
		print("[N3 HUB] Radar: ActivateRadar remote missing")
		return
	end
	if (RuntimeState.RadarCooldown or 0) > os.clock() then
		return
	end

	local function ownsRadar()
		local saved = LocalPlayer:FindFirstChild("SavedData")
		for _, field in ipairs({ "Gears", "GearInventory", "Radars", "OwnedGears" }) do
			local node = saved and saved:FindFirstChild(field)
			if node then
				if node:IsA("StringValue") and node.Value ~= "" then
					return true
				elseif node:IsA("Folder") and #node:GetChildren() > 0 then
					return true
				elseif node:IsA("Folder") or node:IsA("Table") then
					return true
				end
			end
		end
		for _, holder in ipairs({ LocalPlayer:FindFirstChildOfClass("Backpack"), LocalPlayer.Character }) do
			if holder then
				for _, child in ipairs(holder:GetChildren()) do
					if child:IsA("Tool") and string.find(string.lower(child.Name), "radar", 1, true) then
						return true
					end
				end
			end
		end
		return false
	end

	if not ownsRadar() then
		return
	end

	RuntimeState.RadarCooldown = os.clock() + 30
	local ok, err = pcall(function()
		remote:FireServer()
	end)
	print("[N3 HUB] Radar: FireServer ok=" .. tostring(ok) .. (ok and "" or (" err=" .. tostring(err))))
end

local function ExecuteLanternPlace()
	if not FarmConfig.AutoPlaceLantern then
		return
	end
	local remote = ChiliEngine.GetLanternRemote()
	local lantern = ChiliEngine.GetLanternTool()
	if not remote or not lantern then
		return
	end
	if (RuntimeState.LanternCooldown or 0) > os.clock() then
		return
	end

	local plot = ChiliEngine.GetPlot()
	local plotBase = ChiliEngine.GetPlotBase()
	if not plot or not plotBase then
		return
	end

	local target = ChiliEngine.GetRandomPlotPoint(14)
	if not target then
		return
	end

	ChiliEngine.FlyTo(target + Vector3.new(0, 4, 0), nil, 8)

	if ChiliEngine.EquipTool(lantern) then
		RuntimeState.LanternCooldown = os.clock() + 5
		pcall(function()
			remote:FireServer(lantern.Name, target)
		end)
	end
	ChiliEngine.UnequipAll()
end

--[[
	ESP Ride A Pet - 100% data & style dari game, tidak ada warna/font/teks hardcode.

	Sumber (semua runtime dari game, bukan tebakan):
	  Nama        : key GameData.Eggs / GameData.Pets
	  Rarity      : entry.Rarity
	  Gambar      : entry.Image (rbxassetid://)
	  Warna       : Assets.RarityGradients.<Rarity>.Color (UIGradient -> ColorSequence)
	  Font        : Assets.Billboards.EggLuck / PetCash -> TextLabel.FontFace
	                (JosefinSans.json untuk egg, ComicNeueAngular.json untuk pet)
	  Angka       : GameServices.PetAging.FormatSpeed (formatter resmi game,
	                dipakai juga oleh EggLuckBillboard)
]]

local AssetsFolder = ReplicatedStorage:FindFirstChild("Assets")
local Billboards = AssetsFolder and AssetsFolder:FindFirstChild("Billboards")
local RarityGradients = AssetsFolder and AssetsFolder:FindFirstChild("RarityGradients")

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "N3HubESP"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Font asli game, diambil dari template billboard game
local function FontFromTemplate(billboardName)
	local tpl = Billboards and Billboards:FindFirstChild(billboardName)
	if tpl then
		for _, d in ipairs(tpl:GetDescendants()) do
			if d:IsA("TextLabel") and d.FontFace then
				return d.FontFace
			end
		end
	end
	return Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
end

local EGG_FONT = FontFromTemplate("EggLuck")
local PET_FONT = FontFromTemplate("PetCash")

-- Formatter angka resmi game (dipakai juga oleh EggLuckBillboard)
local GameNumberFormat = nil
do
	local ok, mod = pcall(function()
		return require(ReplicatedStorage:WaitForChild("GameServices"):WaitForChild("PetAging"))
	end)
	if ok and type(mod) == "table" and type(mod.FormatSpeed) == "function" then
		GameNumberFormat = mod.FormatSpeed
	end
end

local function FormatNumber(value)
	if GameNumberFormat then
		local ok, s = pcall(GameNumberFormat, value)
		if ok and type(s) == "string" and s ~= "" then
			return s
		end
	end
	return tostring(value)
end

-- Warna rarity resmi game (Assets.RarityGradients/<Rarity>.Color)
-- Catatan: ColorSequence TIDAK punya .Lerp, jadi interpolasi dilakukan manual
-- di titik tengah (alpha 0.5) - persis seperti ConvertOneColorToGradient
-- pada Reusable/Satchel/RarityConfig milik game.
local function GradientMidColor(seq)
	if typeof(seq) ~= "ColorSequence" then
		return nil
	end
	local kps = seq.Keypoints
	if #kps == 0 then
		return nil
	end
	if #kps == 1 then
		return kps[1].Value
	end
	local target = 0.5
	for i = 1, #kps - 1 do
		local a, b = kps[i], kps[i + 1]
		if target >= a.Time and target <= b.Time then
			local span = b.Time - a.Time
			local t = 0
			if span > 0 then
				t = (target - a.Time) / span
			end
			return a.Value:Lerp(b.Value, t)
		end
	end
	return kps[#kps].Value
end

local RarityColorCache = {}

local function ESPColor(rarity)
	local key = tostring(rarity)
	local cached = RarityColorCache[key]
	if cached then
		return cached
	end

	local color
	if RarityGradients then
		local grad = RarityGradients:FindFirstChild(key)
		if grad and grad:IsA("UIGradient") then
			color = GradientMidColor(grad.Color)
		end
	end

	if not color then
		for _, source in ipairs({ GameData.Eggs, GameData.Pets }) do
			if type(source) == "table" then
				for _, entry in pairs(source) do
					if type(entry) == "table" and tostring(entry.Rarity) == key then
						color = ESPColor(entry.Rarity)
						break
					end
				end
			end
			if color then
				break
			end
		end
	end

	color = color or Color3.fromRGB(255, 255, 255)
	RarityColorCache[key] = color
	return color
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "N3_ESPAnchors"
ESPFolder.Parent = Workspace

local function MakeESPAnchor()
	local part = Instance.new("Part")
	part.Name = "ESPAnchor"
	part.Size = Vector3.new(0.2, 0.2, 0.2)
	part.Transparency = 1
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Parent = ESPFolder
	return part
end

local function MakeESPBillboard(font)
	local bb = Instance.new("BillboardGui")
	bb.Name = "N3ESP"
	bb.Size = UDim2.fromOffset(310, 76)
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.AlwaysOnTop = true
	bb.MaxDistance = 1500
	bb.LightInfluence = 0

	local backdrop = Instance.new("Frame")
	backdrop.Name = "Backdrop"
	backdrop.Size = UDim2.fromScale(1, 1)
	backdrop.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
	backdrop.BackgroundTransparency = 0.12
	backdrop.BorderSizePixel = 0
	backdrop.Parent = bb

	local backdropCorner = Instance.new("UICorner")
	backdropCorner.CornerRadius = UDim.new(0, 10)
	backdropCorner.Parent = backdrop

	local stroke = Instance.new("UIStroke")
	stroke.Name = "RarityStroke"
	stroke.Thickness = 2
	stroke.Transparency = 0.05
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = backdrop

	local iconHolder = Instance.new("Frame")
	iconHolder.Name = "IconHolder"
	iconHolder.Size = UDim2.fromOffset(58, 58)
	iconHolder.Position = UDim2.fromOffset(9, 9)
	iconHolder.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
	iconHolder.BackgroundTransparency = 0.3
	iconHolder.BorderSizePixel = 0
	iconHolder.Parent = backdrop

	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 8)
	iconCorner.Parent = iconHolder

	local iconStroke = Instance.new("UIStroke")
	iconStroke.Name = "IconStroke"
	iconStroke.Thickness = 1.6
	iconStroke.Transparency = 0.25
	iconStroke.Color = Color3.fromRGB(255, 255, 255)
	iconStroke.Parent = iconHolder

	-- Gambar asli game (GameData.Eggs/Pets .Image)
	local icon = Instance.new("ImageLabel")
	icon.Name = "Art"
	icon.Size = UDim2.fromScale(1, 1)
	icon.BackgroundTransparency = 1
	icon.Image = ""
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = iconHolder

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -80, 0, 27)
	title.Position = UDim2.fromOffset(75, 9)
	title.BackgroundTransparency = 1
	title.FontFace = font
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.TextStrokeTransparency = 1
	title.Text = ""
	title.Parent = backdrop

	local sub = Instance.new("TextLabel")
	sub.Name = "Sub"
	sub.Size = UDim2.new(1, -80, 0, 18)
	sub.Position = UDim2.fromOffset(75, 35)
	sub.BackgroundTransparency = 1
	sub.FontFace = font
	sub.TextSize = 13
	sub.TextColor3 = Color3.fromRGB(235, 238, 245)
	sub.TextTransparency = 0.05
	sub.TextXAlignment = Enum.TextXAlignment.Left
	sub.TextTruncate = Enum.TextTruncate.AtEnd
	sub.TextStrokeTransparency = 1
	sub.Text = ""
	sub.Parent = backdrop

	local detail = Instance.new("TextLabel")
	detail.Name = "Detail"
	detail.Size = UDim2.new(1, -80, 0, 16)
	detail.Position = UDim2.fromOffset(75, 53)
	detail.BackgroundTransparency = 1
	detail.FontFace = font
	detail.TextSize = 12
	detail.TextColor3 = Color3.fromRGB(178, 184, 198)
	detail.TextXAlignment = Enum.TextXAlignment.Left
	detail.TextTruncate = Enum.TextTruncate.AtEnd
	detail.TextStrokeTransparency = 1
	detail.Text = ""
	detail.Parent = backdrop

	return bb, backdrop, iconHolder, icon, title, sub, detail
end

local function ApplyESP(entry, color, imageId, bigText, midText, smallText)
	entry.Title.Text = bigText
	entry.Title.TextColor3 = color
	entry.Sub.Text = midText
	entry.Sub.TextColor3 = color
	entry.Detail.Text = smallText

	local stroke = entry.Backdrop:FindFirstChild("RarityStroke")
	if stroke then
		stroke.Color = color
	end
	local iconStroke = entry.IconHolder and entry.IconHolder:FindFirstChild("IconStroke")
	if iconStroke then
		iconStroke.Color = color
	end

	if entry.Image ~= imageId then
		entry.Image = imageId
		if type(imageId) == "string" and imageId ~= "" then
			entry.Icon.Image = imageId
			entry.IconHolder.Visible = true
		else
			entry.Icon.Image = ""
			entry.IconHolder.Visible = false
		end
	end
end

local function UpdateEggESP()
	local seen = {}

	if FarmConfig.ESP_Egg_Enabled then
		local camPos = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position or Vector3.zero

		for _, child in ipairs(ActiveEggsFolder:GetChildren()) do
			local eggType = child:GetAttribute("Egg")
			local pos = child:GetAttribute("Position")
			local mutation = tostring(child:GetAttribute("Mutation") or "None")
			local weight = tonumber(child:GetAttribute("Weight")) or 0

			if type(eggType) == "string" and typeof(pos) == "Vector3" then
				local meta = GameData.Eggs[eggType]
				if type(meta) ~= "table" then
					meta = {}
				end
				local rarity = tostring(meta.Rarity or "Common")

				if
					EvaluateFilter(
						eggType,
						rarity,
						mutation,
						FarmConfig.ESP_Egg_Names,
						FarmConfig.ESP_Egg_Rarities,
						FarmConfig.ESP_Egg_Mutations,
						FarmConfig.ESP_Egg_FilterRule
					)
				then
					seen[child] = true
					local entry = RuntimeState.ActiveESP[child]

					if not entry then
						local bb, backdrop, holder, icon, title, sub, detail = MakeESPBillboard(EGG_FONT)
						local anchor = MakeESPAnchor()
						bb.Parent = anchor
						entry = {
							Billboard = bb,
							Anchor = anchor,
							Backdrop = backdrop,
							IconHolder = holder,
							Icon = icon,
							Title = title,
							Sub = sub,
							Detail = detail,
							Egg = true,
							EggType = eggType,
							Rarity = rarity,
							Image = false,
						}
						RuntimeState.ActiveESP[child] = entry
					end

					entry.Anchor.CFrame = CFrame.new(pos + Vector3.new(0, 1.6, 0))

					local luck = tonumber(meta.Luck) or 0
					local premium = meta.Premium
					local dist = math.floor((pos - camPos).Magnitude)

					local detailParts = {}
					table.insert(detailParts, string.format("%s studs", FormatNumber(dist)))
					if luck ~= 0 then
						table.insert(detailParts, FormatNumber(luck) .. " luck")
					end
					if weight ~= 0 then
						table.insert(detailParts, FormatEggWeight(weight))
					end
					if premium then
						table.insert(detailParts, "PREMIUM")
					end

					ApplyESP(
						entry,
						ESPColor(rarity),
						meta.Image,
						tostring(eggType),
						string.format(
							"EGG  %s%s",
							rarity:upper(),
							mutation ~= "None" and ("  " .. mutation:upper()) or ""
						),
						table.concat(detailParts, "  |  ")
					)
				end
			end
		end
	end

	for inst, entry in pairs(RuntimeState.ActiveESP) do
		if entry.Egg and not seen[inst] then
			entry.Billboard:Destroy()
			if entry.Anchor then
				entry.Anchor:Destroy()
			end
			RuntimeState.ActiveESP[inst] = nil
		end
	end
end

local function UpdatePetESP()
	local myPlot = ChiliEngine.GetPlot()
	local seen = {}
	local camPos = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position or Vector3.zero

	local function label(model, isMine)
		if not model:IsA("Model") then
			return
		end

		local petName = tostring(model:GetAttribute("PetName") or model.Name)
		local meta = GameData.Pets[petName]
		if type(meta) ~= "table" then
			meta = {}
		end
		local rarity = tostring(meta.Rarity or "Common")
		local mutation = tostring(model:GetAttribute("Mutation") or "None")
		local income = ChiliEngine.GetPetScore(model)

		local ok = true
		if not isMine and not FarmConfig.ESP_Pet_ShowOthers then
			ok = false
		elseif isMine and not FarmConfig.ESP_Pet_ShowMine then
			ok = false
		end
		if
			ok
			and next(FarmConfig.ESP_Pet_Rarities) ~= nil
			and FarmConfig.ESP_Pet_Rarities[string.lower(rarity)] ~= true
		then
			ok = false
		end
		if ok and income < FarmConfig.ESP_Pet_MinIncome then
			ok = false
		end
		if not ok then
			return
		end

		seen[model] = true
		local entry = RuntimeState.ActiveESP[model]
		local color = ESPColor(rarity)

		if not entry then
			local bb, backdrop, holder, icon, title, sub, detail = MakeESPBillboard(PET_FONT)
			bb.Parent = model
			entry = {
				Billboard = bb,
				Backdrop = backdrop,
				IconHolder = holder,
				Icon = icon,
				Title = title,
				Sub = sub,
				Detail = detail,
				Pet = true,
				Image = false,
			}
			RuntimeState.ActiveESP[model] = entry
		end

		entry.Billboard.StudsOffset = Vector3.new(0, 2.6, 0)
		local dist = math.floor((model:GetPivot().Position - camPos).Magnitude)

		local detailParts = {}
		table.insert(detailParts, "$" .. FormatNumber(income) .. "/s")
		table.insert(detailParts, FormatNumber(dist) .. " studs")
		if mutation ~= "None" then
			table.insert(detailParts, mutation:upper())
		end
		if not isMine then
			table.insert(detailParts, "OTHER")
		end

		ApplyESP(
			entry,
			color,
			meta.Image,
			petName,
			string.format("PET  %s", rarity:upper()),
			table.concat(detailParts, "  |  ")
		)
	end

	if FarmConfig.ESP_Pet_Enabled then
		if myPlot then
			local pets = myPlot:FindFirstChild("Pets")
			for _, model in ipairs(pets and pets:GetChildren() or {}) do
				label(model, true)
			end
		end

		if FarmConfig.ESP_Pet_ShowOthers then
			local plots = Workspace:FindFirstChild("Plots")
			for _, plot in ipairs(plots and plots:GetChildren() or {}) do
				if plot ~= myPlot then
					local pets = plot:FindFirstChild("Pets")
					for _, model in ipairs(pets and pets:GetChildren() or {}) do
						label(model, false)
					end
				end
			end
		end
	end

	for inst, entry in pairs(RuntimeState.ActiveESP) do
		if entry.Pet and not seen[inst] then
			entry.Billboard:Destroy()
			RuntimeState.ActiveESP[inst] = nil
		end
	end
end

local function UpdateESP()
	pcall(function()
		UpdateEggESP()
		UpdatePetESP()
	end)
end

local function RawPostJson(url, body)
	local sent = false
	local req = (type(http_request) == "function" and http_request)
		or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
		or (type(request) == "function" and request)
	if type(req) == "function" then
		sent = pcall(req, {
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = body,
		})
	end
	if not sent then
		pcall(function()
			HttpService:RequestAsync({
				Url = url,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = body,
			})
		end)
	end
end

local function SendWebhook(title, description, color, fields)
	local url = tostring(FarmConfig.Webhook_URL or "")
	if not FarmConfig.Webhook_Enabled or url == "" then
		return
	end

	local payload = HttpService:JSONEncode({
		content = FarmConfig.Webhook_PingEveryone and "@everyone" or nil,
		embeds = {
			{
				title = tostring(title),
				description = tostring(description),
				color = color or 9101504,
				fields = fields or {},
				footer = { text = "N3 HUB - Ride A Pet" },
			},
		},
	})

	RawPostJson(url, payload)
end

local function FormatSessionTime(seconds)
	seconds = math.max(0, math.floor(tonumber(seconds) or 0))
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	if h > 0 then
		return string.format("%dh %02dm", h, m)
	end
	return string.format("%dm", m)
end

local function BuildSummaryFields()
	local fields = {}
	if FarmConfig.Webhook_Field_Player then
		table.insert(fields, { name = "Player", value = LocalPlayer.Name, inline = true })
	end
	if FarmConfig.Webhook_Field_Session then
		table.insert(fields, {
			name = "Session",
			value = FormatSessionTime(os.clock() - RuntimeState.SessionStartTime),
			inline = true,
		})
	end
	if FarmConfig.Webhook_Field_CashProgress then
		table.insert(
			fields,
			{ name = "Cash", value = "$" .. tostring(math.floor(ChiliEngine.GetCash())), inline = true }
		)
	end
	if FarmConfig.Webhook_Field_Inventory then
		table.insert(fields, {
			name = "Basket",
			value = string.format("%d/%d", ChiliEngine.GetBasketCount(), ChiliEngine.GetBasketCapacity()),
			inline = true,
		})
	end
	if FarmConfig.Webhook_Field_PlacedPets then
		table.insert(fields, {
			name = "Placed Pets",
			value = string.format("%d/%d", #ChiliEngine.GetPlacedPets(), ChiliEngine.GetMaxPets()),
			inline = true,
		})
	end
	if FarmConfig.Webhook_Field_RecentPets then
		local names = {}
		for _, pet in ipairs(RuntimeState.RecentPets) do
			table.insert(names, tostring(pet.Name))
		end
		table.insert(fields, {
			name = "Recent Pets",
			value = #names > 0 and table.concat(names, ", ") or "-",
			inline = false,
		})
	end
	if FarmConfig.Webhook_Field_Plot then
		local plot = ChiliEngine.GetPlot()
		table.insert(fields, {
			name = "Plot",
			value = plot and plot.Name or "-",
			inline = true,
		})
	end
	return fields
end

-- ==== WEBHOOK EVENTS (dulu cuma config mati, sekarang beneran ke-wire) ====
local lastClaimedNotify = 0

local function NotifyClaimedEgg(eggName, rarity, mutation, weight)
	if not FarmConfig.Webhook_Enabled or not FarmConfig.Webhook_SendOnClaimedEgg then
		return
	end
	if os.clock() - lastClaimedNotify < 3 then
		return
	end
	local pass = EvaluateFilter(
		tostring(eggName),
		tostring(rarity),
		tostring(mutation or "None"),
		FarmConfig.Webhook_Claimed_Eggs,
		FarmConfig.Webhook_Claimed_Rarities,
		FarmConfig.Webhook_Claimed_Mutations,
		FarmConfig.Webhook_Claimed_Rule
	)
	if not pass then
		return
	end
	lastClaimedNotify = os.clock()
	SendWebhook("Egg Claimed", string.format("Got **%s** (%s)", tostring(eggName), tostring(rarity)), 3066993, {
		{ name = "Egg", value = tostring(eggName), inline = true },
		{ name = "Rarity", value = tostring(rarity), inline = true },
		{ name = "Mutation", value = tostring(mutation or "None"), inline = true },
		{ name = "Weight", value = tostring(math.floor(tonumber(weight) or 0)), inline = true },
	})
end

local function NotifyNewPet(model)
	if typeof(model) ~= "Instance" or not model:IsA("Model") then
		return
	end

	local petName = tostring(model:GetAttribute("PetName") or model.Name)
	local meta = GameData.Pets[petName] or {}
	local rarity = tostring(meta.Rarity or "Common")
	local mutation = tostring(model:GetAttribute("Mutation") or "None")
	local income = ChiliEngine.GetPetScore(model)
	local weight = tonumber(model:GetAttribute("Weight")) or 0

	table.insert(RuntimeState.RecentPets, 1, { Name = petName, Rarity = rarity, Mutation = mutation })
	if #RuntimeState.RecentPets > 5 then
		table.remove(RuntimeState.RecentPets)
	end

	if not FarmConfig.Webhook_Enabled then
		return
	end

	local alwaysSend = FarmConfig.Webhook_Always_Send_Pets[string.lower(petName)] == true
	local rarityList = FarmConfig.Webhook_Pet_Rarities
	local rarityPass = (next(rarityList) == nil) or (rarityList[string.lower(rarity)] == true)

	if
		FarmConfig.Webhook_SendOnRarePet
		and (alwaysSend or rarityPass)
		and income >= FarmConfig.Webhook_MinHatchedIncome
	then
		local fields = {}
		if FarmConfig.Webhook_PetField_Rarity then
			table.insert(fields, { name = "Rarity", value = rarity, inline = true })
		end
		if FarmConfig.Webhook_PetField_Weight then
			table.insert(fields, { name = "Weight", value = tostring(math.floor(weight)), inline = true })
		end
		if FarmConfig.Webhook_PetField_Income then
			table.insert(fields, { name = "Income", value = "$" .. FormatNumber(income) .. "/s", inline = true })
		end
		if FarmConfig.Webhook_PetField_Mutations then
			table.insert(fields, { name = "Mutations", value = mutation, inline = true })
		end
		SendWebhook("New Pet", string.format("Got **%s**", petName), 15844367, fields)
	end

	if FarmConfig.Webhook_SendOnLightningMut and mutation ~= "None" then
		local lowerMut = string.lower(mutation)
		local lightningList = FarmConfig.Webhook_Lightning_Mutations
		local matched = false
		if next(lightningList) ~= nil then
			matched = lightningList[lowerMut] == true
		else
			matched = string.find(lowerMut, "lightning", 1, true) ~= nil
		end
		if matched then
			SendWebhook(
				"Lightning Mutation",
				string.format("**%s** got **%s** mutation!", petName, mutation),
				15844367,
				{
					{ name = "Pet", value = petName, inline = true },
					{ name = "Mutation", value = mutation, inline = true },
					{ name = "Rarity", value = rarity, inline = true },
				}
			)
		end
	end
end

local function NotifyWeather(...)
	if not FarmConfig.Webhook_Enabled or not FarmConfig.Webhook_SendOnWeather then
		return
	end
	local payload = ({ ... })[1]
	local weatherName = nil
	if type(payload) == "string" then
		weatherName = payload
	elseif typeof(payload) == "Instance" then
		weatherName = payload.Name
	elseif type(payload) == "table" then
		weatherName = payload.Name or payload.Weather or payload.WeatherType
	end
	if type(weatherName) ~= "string" or weatherName == "" then
		return
	end
	local list = FarmConfig.Webhook_Weather_List
	if next(list) ~= nil and not (list[string.lower(weatherName)] == true) then
		return
	end
	SendWebhook("Weather Started", string.format("Weather: **%s**", weatherName), 15844367, {
		{ name = "Weather", value = weatherName, inline = true },
	})
end

local function ExecuteEggCollection()
	local cap = ChiliEngine.GetBasketCapacity()
	local count = ChiliEngine.GetBasketCount()

	local tries = 0

	while count < cap and (FarmConfig.AutoFarmEgg or #RuntimeState.ManualEggs > 0) do
		RuntimeState.LastEggFoundTime = os.clock()

		local deadline = ChiliEngine.GetBasketDeadline()
		if deadline and (deadline - Workspace:GetServerTimeNow()) < 8 then
			break
		end

		-- MAP EGGS TRACKER: manual target dulu (queue dari kartu tracker),
		-- baru auto candidates (parity Chili fn11).
		local target = nil
		local isManual = false

		while #RuntimeState.ManualEggs > 0 do
			local eggName = RuntimeState.ManualEggs[1]
			local eggInst = eggName and ActiveEggsFolder:FindFirstChild(eggName)
			local eggType = eggInst and eggInst:GetAttribute("Egg")
			local eggPos = eggInst and eggInst:GetAttribute("Position")
			local privateTo = eggInst and eggInst:GetAttribute("PrivateTo")

			if
				type(eggType) == "string"
				and typeof(eggPos) == "Vector3"
				and (privateTo == nil or privateTo == LocalPlayer.UserId)
			then
				local meta = GameData.Eggs[eggType] or {}
				target = {
					Config = eggInst,
					Name = eggType,
					Position = eggPos,
					Rarity = tostring(meta.Rarity or "Common"),
					Rank = RarityRanks[tostring(meta.Rarity or "Common")] or 1,
					Luck = 0,
					Distance = 0,
					Weight = tonumber(eggInst:GetAttribute("Weight")) or 0,
					Manual = true,
				}
				isManual = true
				break
			end
			table.remove(RuntimeState.ManualEggs, 1)
		end

		if not target and FarmConfig.AutoFarmEgg then
			local candidates = ChiliEngine.GetActiveEggCandidates()
			if #candidates == 0 then
				break
			end
			target = candidates[1]
		end

		if not target then
			break
		end

		RuntimeState.StatusText = "Collecting " .. tostring(target.Name)
		RuntimeState.CurrentEggTarget = target.Config.Name

		local meta = GameData.Eggs[target.Name]
		local isVolcano = meta and meta.RequiresVolcano == true
		local method = isVolcano and ChiliEngine.VolcanoApproach or ChiliEngine.FlyTo

		local ok = method(target.Position + Vector3.new(0, 3, 0), function()
			if isManual then
				return target.Config.Parent == nil
			end
			return not FarmConfig.AutoFarmEgg or target.Config.Parent == nil
		end, 5)

		tries += 1

		if ok and target.Config.Parent ~= nil then
			local bBefore = ChiliEngine.GetBasketCount()
			if bBefore == 0 then
				RuntimeState.PickupPos = target.Position
			end

			local grabTimeout = os.clock() + 1.5
			while ChiliEngine.GetBasketCount() == bBefore and os.clock() < grabTimeout do
				if (os.clock() - RuntimeState.LastPickupAt) >= 0.12 then
					RuntimeState.LastPickupAt = os.clock()
					pcall(function()
						GameRemotes.EggPickup:FireServer(target.Config.Name)
					end)
				end
				RunService.Heartbeat:Wait()
			end

			if ChiliEngine.GetBasketCount() > bBefore then
				if isVolcano then
					ChiliEngine.VolcanoExit(nil)
				end
				tries = 0
				RuntimeState.Carried[target.Config.Name] = target.Config
				task.spawn(
					NotifyClaimedEgg,
					target.Name,
					target.Rarity,
					tostring(target.Config:GetAttribute("Mutation") or "None"),
					target.Weight
				)
			else
				RuntimeState.BlacklistedEggs[target.Config.Name] = os.clock() + 20
				tries += 1
			end
		else
			if target.Config.Parent ~= nil then
				RuntimeState.BlacklistedEggs[target.Config.Name] = os.clock() + 20
			end
		end

		if isManual then
			for i, name in ipairs(RuntimeState.ManualEggs) do
				if name == target.Config.Name then
					table.remove(RuntimeState.ManualEggs, i)
					break
				end
			end
		end

		RuntimeState.CurrentEggTarget = nil
		count = ChiliEngine.GetBasketCount()

		if tries >= 6 then
			break
		end
	end

	if ChiliEngine.GetBasketCount() > 0 then
		FinishBasket()
	end
end

-- =====================================================================
-- WEBHOOK EVENT WATCHERS
-- Rare Pet + Lightning : ChildAdded di folder Pets plot
-- Weather              : scan remote *weather* di ReplicatedStorage
-- Disconnect           : LocalPlayer.Parent hilang (kick / keluar)
-- =====================================================================
do
	local hookedPetsFolder = nil
	local hookedPetsConn = nil

	task.spawn(function()
		while true do
			pcall(function()
				local plot = ChiliEngine.GetPlot()
				local pets = plot and plot:FindFirstChild("Pets")
				if pets and pets ~= hookedPetsFolder then
					if hookedPetsConn then
						pcall(function()
							hookedPetsConn:Disconnect()
						end)
					end
					hookedPetsFolder = pets
					hookedPetsConn = pets.ChildAdded:Connect(function(child)
						task.spawn(NotifyNewPet, child)
					end)
				end
			end)
			task.wait(3)
		end
	end)

	task.spawn(function()
		task.wait(5)
		local hookedRemotes = {}

		while true do
			pcall(function()
				for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
					if rem:IsA("RemoteEvent") then
						local low = string.lower(rem.Name)
						if string.find(low, "weather", 1, true) and not hookedRemotes[rem] then
							hookedRemotes[rem] = true
							rem.OnClientEvent:Connect(function(...)
								task.spawn(NotifyWeather, ...)
							end)
						end
					end
				end
			end)
			task.wait(30)
		end
	end)

	LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
		if LocalPlayer.Parent ~= nil then
			return
		end
		pcall(function()
			if not FarmConfig.Webhook_Enabled or not FarmConfig.Webhook_SendOnDisconnect then
				return
			end
			local url = tostring(FarmConfig.Webhook_URL or "")
			if url == "" then
				return
			end
			local payload = HttpService:JSONEncode({
				content = FarmConfig.Webhook_PingEveryone and "@everyone" or nil,
				embeds = {
					{
						title = "Disconnected",
						description = string.format(
							"**%s** left the game after %s",
							LocalPlayer.Name,
							FormatSessionTime(os.clock() - RuntimeState.SessionStartTime)
						),
						color = 16711680,
						footer = { text = "N3 HUB - Ride A Pet" },
					},
				},
			})
			RawPostJson(url, payload)
		end)
	end)
end

-- =====================================================================
-- SHOP STOCK TRACKER (parity Chili: dengerin Restock/ShopStock)
-- Biar auto buy ga spam beli barang yang stoknya udah habis.
-- =====================================================================
do
	local function UpdateStock(payload)
		if type(payload) ~= "table" then
			return
		end
		for category, items in pairs(payload) do
			if type(items) == "table" then
				local map = RuntimeState.ShopStock[category] or {}
				for name, data in pairs(items) do
					map[tostring(name)] = (type(data) == "table" and tonumber(data.Amount))
						or (data == true and 1)
						or tonumber(data)
						or 1
				end
				RuntimeState.ShopStock[category] = map
			end
		end
	end

	task.spawn(function()
		task.wait(3)
		local hooked = {}

		while true do
			pcall(function()
				for _, name in ipairs({ "Restock", "ShopStock" }) do
					local rem = GameRemotes:FindFirstChild(name)
					if rem and rem:IsA("RemoteEvent") and not hooked[rem] then
						hooked[rem] = true
						rem.OnClientEvent:Connect(UpdateStock)
					end
				end
				local stockRemote = GameRemotes:FindFirstChild("ShopStock")
				if stockRemote and stockRemote:IsA("RemoteEvent") then
					stockRemote:FireServer()
				end
			end)
			task.wait(30)
		end
	end)
end

-- MASTER WORKER LOOP
task.spawn(function()
	while true do
		local shouldWork = FarmConfig.AutoFarmEgg
			or FarmConfig.AutoHatch
			or #RuntimeState.ManualEggs > 0
			or FarmConfig.AutoVolcanoDip
			or FarmConfig.AutoPlaceEggs
			or FarmConfig.AutoPlaceBestPets
			or FarmConfig.AutoReplaceLowerPets
			or FarmConfig.AutoFeedPets
			or FarmConfig.AutoSellSelected
			or FarmConfig.AutoSellAllPets
			or FarmConfig.AutoCollectPetCash
			or FarmConfig.AutoUnlockNests
			or FarmConfig.AutoActivateRadar
			or FarmConfig.AutoPlaceLantern
			or FarmConfig.AutoHopEggs
			or FarmConfig.ESP_Egg_Enabled
			or FarmConfig.ESP_Pet_Enabled
			or ChiliEngine.GetBasketCount() > 0

		if shouldWork and ChiliEngine.GetRoot() and ChiliEngine.GetPlot() then
			RuntimeState.IsBusy = true

			local function stage(name, fn)
				RuntimeState.StatusText = name
				local ok, err = pcall(fn)
				if not ok then
					warn("[N3 HUB] stage '" .. name .. "' error: " .. tostring(err))
				end
			end

			stage("Delivering basket", function()
				if ChiliEngine.GetBasketCount() > 0 and not FarmConfig.AutoFarmEgg then
					FinishBasket()
				end
			end)

			if FarmConfig.AutoPlaceEggs then
				stage("Planting eggs", ExecutePlanting)
			end

			if FarmConfig.AutoHatch or FarmConfig.AutoFarmEgg or FarmConfig.AutoPlaceEggs then
				stage("Hatching eggs", ExecuteHatching)
			end

			if FarmConfig.AutoPlaceBestPets then
				stage("Placing pets", ExecutePetPlacing)
			end

			if FarmConfig.AutoReplaceLowerPets then
				stage("Replacing pets", ExecutePetReplacement)
			end

			if FarmConfig.AutoFeedPets then
				stage("Feeding pets", ExecuteFeeding)
			end

			stage("Collecting pet cash", ExecutePetCashCollection)
			stage("Selling pets", ExecutePetSelling)
			stage("Unlocking nests", ExecuteNestUnlock)
			stage("Activating radar", ExecuteRadarActivate)
			stage("Placing lantern", ExecuteLanternPlace)
			stage("Server hopping", ExecuteServerHop)

			if FarmConfig.AutoFarmEgg or #RuntimeState.ManualEggs > 0 then
				stage("Collecting eggs", ExecuteEggCollection)
			end

			ChiliEngine.UnequipAll()
			RuntimeState.IsBusy = false
			RuntimeState.StatusText = "Idle"
		else
			RuntimeState.StatusText = ChiliEngine.GetBasketCount() > 0 and "Delivering basket" or "Idle"
		end
		task.wait(0.15)
	end
end)

-- BACKGROUND TASKS (ESP, Webhook, Shop, Rewards, Plot)
task.spawn(function()
	local lastRebirth = 0
	local lastUpgrade = 0
	local lastReward = 0
	local luckWarned = false

	while true do
		task.wait(0.25)

		if FarmConfig.ESP_Egg_Enabled or FarmConfig.ESP_Pet_Enabled then
			UpdateESP()
		end

		task.wait(2.25)

		if FarmConfig.AutoBuySelectedItems and next(FarmConfig.Shop_Items) ~= nil then
			local shopOpen = false
			for item, ok in pairs(FarmConfig.Shop_Items) do
				if ok then
					local slot = "Shop_" .. tostring(item)
					if (RuntimeState.ActionCooldowns[slot] or 0) <= os.clock() then
						local category, entry = ChiliEngine.FindShopItem(item)
						local price = type(entry) == "table" and tonumber(entry.Price or entry.Cost) or nil
						local cash = ChiliEngine.GetCash()
						local stockMap = category and RuntimeState.ShopStock[category]
						local stock = stockMap and stockMap[item]

						if category and price and stock == 0 then
							RuntimeState.ActionCooldowns[slot] = os.clock() + 30
						elseif category and price and (cash - (FarmConfig.Shop_KeepCash or 0)) >= price then
							local bought = 0
							local attempts = 0
							while
								attempts < 20
								and (ChiliEngine.GetCash() - (FarmConfig.Shop_KeepCash or 0)) >= price
								and bought < 5
							do
								if not shopOpen then
									pcall(function()
										GameRemotes.SetOpenShop:FireServer(category)
									end)
									task.wait(0.15)
									shopOpen = true
								end

								local before = ChiliEngine.GetOwnedAmount(item)
								pcall(function()
									GameRemotes.BuyWithCash:FireServer(category, item)
								end)
								attempts += 1

								local deadline = os.clock() + 0.8
								while os.clock() < deadline and ChiliEngine.GetOwnedAmount(item) <= before do
									task.wait()
								end

								if ChiliEngine.GetOwnedAmount(item) > before then
									bought += 1
									if stockMap and stock then
										stockMap[item] = math.max(0, stock - 1)
										stock = stockMap[item]
									end
									RuntimeState.ActionCooldowns[slot] = os.clock() + 30
									SendWebhook(
										"Auto Buy",
										string.format("Bought %s for $%s", tostring(item), tostring(price)),
										3066993,
										{
											{ name = "Item", value = tostring(item), inline = true },
											{ name = "Price", value = "$" .. tostring(price), inline = true },
										}
									)
								elseif attempts % 5 == 0 then
									RuntimeState.ActionCooldowns[slot] = os.clock() + 5
									break
								end
							end
						else
							RuntimeState.ActionCooldowns[slot] = os.clock() + 10
						end
					end
				end
			end
		end

		if FarmConfig.AutoClaimSafeRewards and (os.clock() - lastReward) > 30 then
			lastReward = os.clock()
			pcall(function()
				GameRemotes.ClaimIndexReward:FireServer()
			end)
		end

		if FarmConfig.AutoRebirthWhenReady and (os.clock() - lastRebirth) > 30 then
			pcall(function()
				local rebirths = ChiliEngine.GetSavedNumber("Rebirths")
				local cash = ChiliEngine.GetCash()
				if type(GameData.Rebirths) == "table" and type(GameData.Rebirths.GetCost) == "function" then
					-- PARITY CHILI: cek Cap dulu, udah mentok ga usah rebirth lagi
					local capRebirth = tonumber(GameData.Rebirths.Cap)
					if capRebirth and rebirths >= capRebirth then
						return
					end
					local cost = tonumber(GameData.Rebirths.GetCost(rebirths)) or math.huge
					if cost < math.huge and cash >= cost then
						lastRebirth = os.clock()
						GameRemotes.Rebirth:FireServer()
					end
				end
			end)
		end

		if FarmConfig.AutoBuyHatchUpgrades and (os.clock() - lastUpgrade) > 5 then
			pcall(function()
				local lvl = ChiliEngine.GetSavedNumber("HatchUpgrades")
				local cash = ChiliEngine.GetCash()
				if type(GameData.HatchLuck) == "table" and type(GameData.HatchLuck.GetPrice) == "function" then
					-- PARITY CHILI: kasi tau user kalau Luck Multiplier di setting game mati
					if LocalPlayer:GetAttribute("Setting_LuckMultiplier") == false then
						if not luckWarned then
							luckWarned = true
							N3Misc.Notify(
								"Auto Upgrade Luck",
								"Turn on the Luck Multiplier setting in the game settings first.",
								5
							)
						end
						return
					end
					local maxBuy = tonumber(GameData.HatchLuck.MaxBuyLimit) or 1000
					if lvl >= maxBuy then
						return
					end
					local cost = tonumber(GameData.HatchLuck.GetPrice(lvl)) or math.huge

					local reserve = 0
					if FarmConfig.HatchUpgradeMode == "Keep 100k Cash" then
						reserve = 100000
					elseif FarmConfig.HatchUpgradeMode == "Smart Balance" then
						reserve = math.min(cash * 0.5, 1000000)
					end

					if cost < math.huge and cash - reserve >= cost then
						local upg = ChiliEngine.GetUpgradeRemote()
						if upg then
							lastUpgrade = os.clock()
							pcall(function()
								upg:FireServer("Purchase")
							end)
						end
					end
				end
			end)
		end

		if FarmConfig.Webhook_Enabled then
			local interval = math.max(1, FarmConfig.Webhook_IntervalMinutes) * 60
			if (os.clock() - RuntimeState.LastWebhookSummaryTime) >= interval then
				RuntimeState.LastWebhookSummaryTime = os.clock()
				if FarmConfig.Webhook_SendSummaryOnInterval then
					SendWebhook(
						"Session Summary",
						string.format("Farm status: %s", tostring(RuntimeState.StatusText or "Idle")),
						9101504,
						BuildSummaryFields()
					)
				end
			end
		end
	end
end)

print("[N3 HUB] Ride A Pet - Full Engine Synchronized & Active.")

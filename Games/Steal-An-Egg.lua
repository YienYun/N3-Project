local Tasks = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer
local LibraryLoader =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ZedFu3/N3-Hub/refs/heads/main/Library/N3V3.luau"))()
if not LibraryLoader then
	return
end
Tasks.Loading = LibraryLoader:CreateLoading({
	Title = "N3 HUB",
	Icon = "rbxassetid://117688744510818",
	TotalSteps = 5,
	CurrentStep = 1,
	ShowSidebar = false,
	AutoResizeHeight = true,
})
Tasks.Loading:SetMessage("Load Engine")
Tasks.Loading:SetDescription("Preparing services, remotes & runtime core...")
Tasks.Loading:SetMessage("Load Data Replica")
Tasks.Loading:SetCurrentStep(2)
Tasks.Loading:SetDescription("Loading game data replicas: EggState, EggRecords, Save, Assets...")
local EggStateModule = nil
pcall(function()
	EggStateModule = require(ReplicatedStorage:WaitForChild("Client", 5):WaitForChild("EggState", 5))
end)
if not EggStateModule then
	pcall(function()
		EggStateModule = require(ReplicatedStorage.Client.EggState)
	end)
end
local AssetItemsModule = nil
pcall(function()
	AssetItemsModule =
		require(ReplicatedStorage:WaitForChild("Shared", 5):WaitForChild("Util", 5):WaitForChild("AssetItems", 5))
end)
if not AssetItemsModule then
	pcall(function()
		AssetItemsModule = require(ReplicatedStorage.Shared.Util.AssetItems)
	end)
end
local EggRecordsModule = nil
pcall(function()
	EggRecordsModule =
		require(ReplicatedStorage:WaitForChild("Shared", 5):WaitForChild("Util", 5):WaitForChild("EggRecords", 5))
end)
if not EggRecordsModule then
	pcall(function()
		EggRecordsModule = require(ReplicatedStorage.Shared.Util.EggRecords)
	end)
end
local SaveModule = nil
pcall(function()
	SaveModule = require(ReplicatedStorage:FindFirstChild("Shared"):FindFirstChild("Save"))
end)
if not SaveModule then
	pcall(function()
		SaveModule = require(ReplicatedStorage.Shared.Save)
	end)
end
local AssetsModule = nil
pcall(function()
	AssetsModule = require(ReplicatedStorage:FindFirstChild("Data"):FindFirstChild("Assets"))
end)
if not AssetsModule then
	pcall(function()
		AssetsModule = require(ReplicatedStorage.Data.Assets)
	end)
end
local AssetEarningsModule = nil
pcall(function()
	AssetEarningsModule =
		require(ReplicatedStorage:WaitForChild("Shared", 5):WaitForChild("Util", 5):WaitForChild("AssetEarnings", 5))
end)
if not AssetEarningsModule then
	pcall(function()
		AssetEarningsModule = require(ReplicatedStorage.Shared.Util.AssetEarnings)
	end)
end
local AreaEggCycleModule = nil
pcall(function()
	AreaEggCycleModule =
		require(ReplicatedStorage:WaitForChild("Shared", 5):WaitForChild("Util", 5):WaitForChild("AreaEggCycle", 5))
end)
if not AreaEggCycleModule then
	pcall(function()
		AreaEggCycleModule = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
	end)
end
local AreaEggResetWallModule = nil
pcall(function()
	AreaEggResetWallModule = require(ReplicatedStorage:WaitForChild("Client", 5):WaitForChild("AreaEggResetWall", 5))
end)
if not AreaEggResetWallModule then
	pcall(function()
		AreaEggResetWallModule = require(ReplicatedStorage.Client.AreaEggResetWall)
	end)
end
local ScrambleTradeInData = nil
pcall(function()
	local dataFolder = ReplicatedStorage:FindFirstChild("Data")
	local mod = dataFolder and dataFolder:FindFirstChild("ScrambleTradeIn")
	if mod and mod:IsA("ModuleScript") then
		ScrambleTradeInData = require(mod)
	end
end)
Tasks.Loading:SetMessage("Load N3 Library")
Tasks.Loading:SetCurrentStep(3)
Tasks.Loading:SetDescription("N3V3 UI Library, SaveManager & ThemeManager...")
local NetFolder = ReplicatedStorage
Tasks.CORE_REMOTES = {
	"RF/EggWorld/AskFieldEggCarry",
	"RF/EggWorld/AskPlaceEgg",
	"RF/EggWorld/AskHatch",
}
do
	local deadline = os.clock() + 20
	repeat
		local pkg = ReplicatedStorage:FindFirstChild("Packages")
		NetFolder = (pkg and pkg:FindFirstChild("Networking"))
			or ReplicatedStorage:FindFirstChild("Network")
			or ReplicatedStorage
		local ready = true
		for _, name in ipairs(Tasks.CORE_REMOTES) do
			if not (NetFolder and NetFolder:FindFirstChild(name, true)) then
				ready = false
				break
			end
		end
		if ready then
			break
		end
		task.wait(0.5)
	until os.clock() > deadline
end
local function FindRemote(PrimaryName: string, ...): Instance?
	local function try(name)
		if name and type(name) == "string" then
			return NetFolder:FindFirstChild(name, true) or ReplicatedStorage:FindFirstChild(name, true)
		end
		return nil
	end
	local Remote = try(PrimaryName)
	if Remote then
		return Remote
	end
	for _, AltName in ipairs({ ... }) do
		Remote = try(AltName)
		if Remote then
			return Remote
		end
	end
	local ShortName = string.match(PrimaryName, "[^/]+$")
	if ShortName then
		Remote = try(ShortName)
		if Remote then
			return Remote
		end
	end
	return nil
end
local Remotes = {}
Remotes.RemoteCarryEgg = FindRemote("RF/EggWorld/AskFieldEggCarry", "AskFieldEggCarry")
Remotes.RemoteEggSnapshot = FindRemote("RF/EggWorld/AskFieldEggSnapshot", "AskFieldEggSnapshot")
	or FindRemote("Eggs: RequestAreaEggSnapshot")
Remotes.RemotePlaceEgg = FindRemote("RF/EggWorld/AskPlaceEgg", "AskPlaceEgg")
Remotes.RemoteLiveSnapshot = FindRemote("RF/EggWorld/AskLiveSnapshot", "AskLiveSnapshot")
Remotes.RemotePlotState = FindRemote("RF/Homestead/AskState", "RF/Plots/AskState") or FindRemote("AskState")
Remotes.RemotePlotUpgrade = FindRemote("RF/Homestead/AskTierRaise", "RF/Plots/AskTierRaise")
	or FindRemote("Plots: RequestUpgrade")
Remotes.RemoteHatch = FindRemote("RF/EggWorld/AskHatch", "AskHatch") or FindRemote("Eggs: RequestHatchEgg")
Remotes.RemoteFinishHatch = FindRemote("RF/EggWorld/AskFinishHatch", "AskFinishHatch")
	or FindRemote("Eggs: RequestCompleteHatchEgg")
Remotes.RemoteWearTool = NetFolder:FindFirstChild("RF/EggWorld/AskWearTool")
	or FindRemote("RF/EggWorld/AskWearTool", "AskWearTool")
Remotes.RemoteWriteFavourite = NetFolder:FindFirstChild("RE/PetSatchel/WriteFavourite", true)
	or FindRemote("RE/PetSatchel/WriteFavourite", "WriteFavourite")
Remotes.RemoteWearBest = NetFolder:FindFirstChild("RF/Haul/WearBest")
	or FindRemote("RF/Haul/WearBest", "WearBest")
	or FindRemote("RF/PenRoster/ConfirmEquipBestBadge")
Remotes.RemoteCodexRedeemAll = FindRemote("RF/Codex/AskRedeemAll", "AskRedeemAll")
Remotes.RemoteCodexRedeemLimited = FindRemote("RF/Codex/AskRedeemLimitedEgg", "AskRedeemLimitedEgg")
Remotes.RemoteAwayEarnings = FindRemote("RF/AwayEarnings/AskCollect", "AskCollect")
Remotes.RemoteFuseLoad = NetFolder:FindFirstChild("RF/Fusery/LoadPet") or FindRemote("RF/Fusery/LoadPet", "LoadPet")
Remotes.RemoteFuseBegin = NetFolder:FindFirstChild("RF/Fusery/BeginFuse")
	or FindRemote("RF/Fusery/BeginFuse", "BeginFuse")
Remotes.RemoteFuseFinish = NetFolder:FindFirstChild("RF/Fusery/FinishReveal")
	or FindRemote("RF/Fusery/FinishReveal", "FinishReveal")
Remotes.RemoteFuseEject = NetFolder:FindFirstChild("RF/Fusery/EjectPet") or FindRemote("RF/Fusery/EjectPet", "EjectPet")
Remotes.RemoteTreadmillWear = FindRemote("RF/Treadmill/AskWearStill", "AskWearStill")
Remotes.RemoteTreadmillSpeedGained = FindRemote("RE/Treadmill/SpeedGained", "SpeedGained")
Remotes.RemoteTreadmillDoff = FindRemote("RF/Treadmill/AskDoff", "AskDoff")
Remotes.RemoteTreadmillUpgrade = FindRemote("RF/Treadmill/AskTierRaise", "Treadmills: RequestUpgrade", "AskTierRaise")
Remotes.RemoteTrailPurchase = FindRemote("RF/Trailwear/AskPurchase", "Trailwear: RequestPurchase", "AskPurchase")
Remotes.RemoteTrailEquip = FindRemote("RF/Trailwear/AskChoose", "Trailwear: RequestEquip", "AskChoose")
Remotes.RemoteScrambleTradeState = NetFolder:FindFirstChild("RF/ScrambleTradeIn/AskState")
	or FindRemote("RF/ScrambleTradeIn/AskState", "ScrambleTradeIn/AskState")
Remotes.RemoteScrambleTradeIn = NetFolder:FindFirstChild("RF/ScrambleTradeIn/AskTradeIn")
	or FindRemote("RF/ScrambleTradeIn/AskTradeIn", "ScrambleTradeIn/AskTradeIn")
Remotes.RemoteScrambleFinishReveal = NetFolder:FindFirstChild("RF/ScrambleTradeIn/AskFinishReveal")
	or FindRemote("RF/ScrambleTradeIn/AskFinishReveal", "ScrambleTradeIn/AskFinishReveal")
Remotes.RemoteScrambleBannerRotated = NetFolder:FindFirstChild("RE/ScrambleTradeIn/BannerRotated")
	or FindRemote("RE/ScrambleTradeIn/BannerRotated", "ScrambleTradeIn/BannerRotated")
Remotes.RemoteScrambleRefresh = NetFolder:FindFirstChild("RF/ScrambleTradeIn/AskRefresh")
	or FindRemote("RF/ScrambleTradeIn/AskRefresh", "ScrambleTradeIn/AskRefresh")
Remotes.RemoteBatSwing = FindRemote("RE/BatSwing/Trigger", "BatSwing")
Remotes.RemoteForestStrike = NetFolder:FindFirstChild("RE/GuardPatrol/ForestStrike")
	or FindRemote("RE/GuardPatrol/ForestStrike", "ForestStrike")
Remotes.RemoteSpeedToll = NetFolder:FindFirstChild("RE/GuardPatrol/SpeedTollOffer")
	or FindRemote("RE/GuardPatrol/SpeedTollOffer", "SpeedTollOffer")
Remotes.RemoteScrambleReq = NetFolder:FindFirstChild("RF/Scramble/Request")
	or FindRemote("RF/Scramble/Request", "RF/DrScramble/Request", "ScrambleRequest")
Remotes.RemoteSellSelection = NetFolder:FindFirstChild("RE/PetSatchel/SellSelection")
	or FindRemote("RE/PetSatchel/SellSelection", "SellSelection")
local FarmConfig = {
	AutoStealEnabled = false,
	StealSettleWait = 6.5,
	TweenSpeed = 600,
	AutoTweenSpeed = 400,
	-- BEGIN BUILTIN VISUAL CONFIG
	SafeZoneVisual = false,
	-- END BUILTIN VISUAL CONFIG
	AntiTreadmill = false,
	AutoEquipBestPet = false,
	AutoStealAll = false,
	AutoStealSelected = false,
	StealAllMode = false,
	SelectedZones = {},
	SelectedEggs = {},
	SelectedRarities = {},
	SelectedMutations = {},
	AutoTreadmill = false,
	AutoUpgradeTreadmill = false,
	AutoUpgradePlot = false,
	CashReserve = 0,
	PlaceMethod = "Every 5",
	AutoPlaceAllEggs = false,
	AutoPlaceSelect = false,
	PlaceSelectedEggs = {},
	PlaceSelectedRarities = {},
	PlaceSelectedMutations = {},
	AutoHatch = false,
	BatchStealCount = 0,
	ClaimOfflineEarnings = false,
	Fav_Rule = "Rarity Only",
	Fav_MinRarity = 7,
	Fav_Mutation = "Any Mutation",
	Fav_MinValue = 0,
	Fav_AlwaysSpecies = {},
	Fav_AutoPets = false,
	Fav_AutoEquipped = false,
	Fav_AutoUnfavEquipped = false,
	AutoEquipBestTrail = false,
	AutoBuyBestTrail = false,
	AutoClaimIndexRewards = false,
	ESP_WorldEgg = false,
	ESP_CarriedDropped = false,
	ESP_Guard = false,
	ESP_Pet = false,
	ESP_Player = false,
	ESP_Machine = false,
	ESP_Plot = false,
	ESP_Distance = 2000,
	ESP_ShowInfo = { Icon = true, Name = true, Rarity = true },
	ESP_MinValue = 0,
	ESP_HighlightMode = "Off",
	ESP_MinRarity = 5,
	Movement_WalkSpeed = 16,
	Movement_JumpPower = 50,
	Movement_Override = false,
	Movement_Noclip = false,
	Movement_SelectedWaypoint = "Base / Plot",
	AutoScrambleSteal = false,
	AutoScrambleSubmit = false,
	ScrambleHoldBack = true,
	Scramble_AutoReroll = false,
	Scramble_LabBanners = {},
	Scramble_LabBannerFilterOn = false,
	Defense_AntiTrap = false,
	Defense_AntiRagdoll = false,
	Defense_AntiGuard = false,
	Defense_InstantSteal = false,
	Defense_InstantStealSteps = 3,
	Perf_FpsCap = 240,
	Perf_Optimizer = false,
	Perf_FpsPing = true,
	Perf_FpsPingSize = 100,
	Perf_Disable3D = false,
	Perf_NoFog = false,
	Perf_FullBright = false,
	Util_AntiAFK = true,
	Util_AutoRejoin = false,
	Race_AutoRace = false,
	Race_Speed = 144,
	Race_PowerUps = true,
	Race_AutoClaim = false,
	Race_AutoEquip = true,
	Race_Racer = "Best Owned",
	Race_AutoBuy = false,
	Race_ShopItems = {},
	InstanInteract = false,
	Index_AutoClaim = false,
	Index_AutoClaimLimited = false,
	Index_PrioritizeMissing = false,
	Index_StealPriority = "Highest Area First",
	Index_SelectedZones = {},
	Webhook_Url = "",
	Webhook_Enabled = false,
	Webhook_Interval = 10,
	Webhook_Ping = false,
	Webhook_Interval_Summary = false,
	Webhook_Field_Player = true,
	Webhook_Field_Server = true,
	Webhook_Field_Session = true,
	Webhook_Field_EventTarget = true,
	Webhook_Field_EventValue = true,
	Webhook_Sum_Cash = true,
	Webhook_Sum_Speed = true,
	Webhook_Sum_Eggs = true,
	Webhook_Sum_Pets = true,
	Webhook_Sum_Upgrades = true,
	Webhook_Sum_Index = true,
	Webhook_Sum_Recent = true,
	Webhook_AutoSendEgg = true,
	Webhook_AutoSendHatch = true,
	Webhook_AutoSendPet = true,
	Webhook_EggSelected = {},
	Webhook_RaritySelected = {},
	Webhook_MutationSelected = {},
}
local RuntimeState = {
	SessionId = 0,
	IsExecuting = false,
	HoldingEggForGuard = false,
	InGuardBounce = false,
	TemporaryBlacklist = {},
	currentTargetModel = nil,
	OnTreadmill = false,
	PlayerPlot = nil,
	PetArea = nil,
	PlotVerified = false,
	TreadmillPad = nil,
	OriginalHumanoid = nil,
	SwapClone = nil,
	SwapLinks = {},
	StealTreadmillShield = false,
	StealCancel = 0,
	ForceAntiTreadmill = false,
	ScrambleReserved = {},
	ScrambleLabCategory = nil,
	ScrambleWanted = {},
}
getgenv().N3Hub_State = getgenv().N3Hub_State or {}
getgenv().N3Hub_State.FarmConfig = FarmConfig
getgenv().N3Hub_State.RuntimeState = RuntimeState
local function RaceOwnsCharacter()
	return Tasks.RaceHoldsCharacter ~= nil and Tasks.RaceHoldsCharacter() == true
end
local function IsStealActive()
	if Tasks.PriorityStealYield and Tasks.PriorityStealYield() then
		return false
	end
	return FarmConfig.AutoStealEnabled or FarmConfig.AutoStealAll or FarmConfig.AutoStealSelected
end
local SafeBaseLineX = 525
local SafeCorridorZ = -360
local RarityRankTable = {
	Admin = 120,
	BrainrotGod = 110,
	Transcendent = 105,
	Prismatic = 100,
	Divine = 95,
	Eternal = 90,
	Secret = 85,
	Celestial = 80,
	Mythical = 75,
	Mythic = 75,
	Cosmic = 65,
	Titan = 55,
	Legendary = 50,
	Superior = 45,
	Exclusive = 40,
	Limited = 38,
	Exotic = 35,
	LightDark = 30,
	Epic = 25,
	SuperRare = 20,
	Rare = 15,
	Uncommon = 10,
	Common = 5,
	Basic = 1,
}
local AreaWeights = {
	["Light Dark"] = 1300,
	["Titan Temple"] = 1100,
	["Cherry Blossom"] = 1000,
	["Cosmic"] = 900,
	["Prehistoric"] = 800,
	["Abyss Ocean"] = 700,
	["Volcano"] = 600,
	["Snow"] = 500,
	["Jungle"] = 400,
	["Desert"] = 300,
	["Lake"] = 200,
	["Forest"] = 100,
}
local AreaNamesList = {
	"Forest",
	"Lake",
	"Desert",
	"Jungle",
	"Snow",
	"Volcano",
	"Abyss Ocean",
	"Prehistoric",
	"Cosmic",
	"Cherry Blossom",
	"Titan Temple",
	"Light Dark",
}
local EggNamesList = {}
local ConfigsFolder = ReplicatedStorage:WaitForChild("Data", 5)
	and ReplicatedStorage.Data:WaitForChild("Areas", 5)
	and ReplicatedStorage.Data.Areas:WaitForChild("Configs", 5)
if ConfigsFolder then
	for _, AreaModule in ipairs(ConfigsFolder:GetChildren()) do
		if AreaModule:IsA("ModuleScript") then
			local Success, AreaData = pcall(require, AreaModule)
			if Success and type(AreaData) == "table" and AreaData.DropTable then
				for _, Entry in ipairs(AreaData.DropTable) do
					local EggName = Entry[1]
					if EggName and not table.find(EggNamesList, EggName) then
						table.insert(EggNamesList, EggName)
					end
				end
			end
		end
	end
	do
		local RankByName = {}
		local Dir = AssetsModule and AssetsModule.Directory or nil
		if type(Dir) == "table" then
			for Key, Entry in pairs(Dir) do
				if type(Entry) == "table" then
					local Rarity = type(Entry.Rarity) == "table"
							and tonumber(Entry.Rarity.RarityNumber or Entry.Rarity.Rank)
						or nil
					if Rarity then
						for _, Name in ipairs({
							tostring(Key),
							tostring(Entry._id or ""),
							tostring(Entry.DisplayName or ""),
						}) do
							if Name ~= "" and RankByName[Name] == nil then
								RankByName[Name] = Rarity
							end
						end
					end
				end
			end
		end
		table.sort(EggNamesList, function(A, B)
			local RA, RB = RankByName[A] or 0, RankByName[B] or 0
			if RA ~= RB then
				return RA > RB
			end
			return A < B
		end)
	end
end
if #EggNamesList == 0 then
	EggNamesList = {
		"Basic Egg",
		"Rare Egg",
		"Epic Egg",
		"Legendary Egg",
		"Mythic Egg",
		"Cosmic Egg",
		"Divine Egg",
		"Secret Egg",
	}
end
local RaritiesList = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Cosmic",
	"Secret",
	"Eternal",
	"Divine",
}
local RankToRarityMap = {
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Epic",
	[5] = "Legendary",
	[6] = "Mythic",
	[7] = "Cosmic",
	[8] = "Secret",
	[9] = "Eternal",
	[10] = "Divine",
	[11] = "Transcendent",
	[12] = "BrainrotGod",
	[13] = "Admin",
}
local function CanonicalRarityKey(InputName)
	local Clean = string.gsub(string.lower(tostring(InputName or "")), "%s", "")
	if Clean == "mythic" or Clean == "mythical" then
		return "mythic"
	end
	return Clean
end
local RarityRankNormalized = {}
local RarityKeyToDisplay = {}
for RarityName, RarityRank in pairs(RarityRankTable) do
	local Key = CanonicalRarityKey(RarityName)
	RarityRankNormalized[Key] = RarityRank
	if not RarityKeyToDisplay[Key] then
		RarityKeyToDisplay[Key] = RarityName
	end
end
local function RarityRankOf(InputName)
	return RarityRankNormalized[CanonicalRarityKey(InputName)] or 1
end
Tasks.MutationAliases = {
	monstrous = "parasite",
	parasite = "monstrous",
	boss = "fractured",
	fractured = "boss",
	sakura = "bloom",
	bloom = "sakura",
	greatbloom = "spirit bloom",
	["spirit bloom"] = "greatbloom",
}
local MutationsList = { "None" }
function Tasks.InitializeMutationsList()
	local CanonicalOrder = { "Golden", "Silver", "Rainbow", "Boss", "Monstrous", "Sakura", "GreatBloom" }
	local AliasCanon = {
		parasite = "monstrous",
		fractured = "boss",
		bloom = "sakura",
		["spirit bloom"] = "greatbloom",
	}
	local function Canon(Name)
		local Key = string.lower(tostring(Name or "")):gsub("%s+", " ")
		return AliasCanon[Key] or Key
	end
	local Seen = { ["none"] = true }
	local Extras = {}
	local function Push(Name)
		local Raw = tostring(Name or "")
		if Raw == "" then
			return
		end
		local Key = Canon(Raw)
		if Seen[Key] then
			return
		end
		Seen[Key] = true
		table.insert(Extras, Raw)
	end
	local CatalogModule = ReplicatedStorage:FindFirstChild("Catalog", true)
		or (
			ReplicatedStorage:FindFirstChild("Shared")
			and ReplicatedStorage.Shared:FindFirstChild("Modules")
			and ReplicatedStorage.Shared.Modules:FindFirstChild("Mutations")
			and ReplicatedStorage.Shared.Modules.Mutations:FindFirstChild("Catalog")
		)
	if CatalogModule and CatalogModule:IsA("ModuleScript") then
		local Success, CatalogData = pcall(require, CatalogModule)
		if Success and type(CatalogData) == "table" then
			for Key, Data in pairs(CatalogData) do
				local Id = type(Data) == "table" and (Data.Id or Data.Label or Key) or tostring(Key)
				Push(Id)
			end
		end
	end
	if #Extras == 0 then
		for _, MutName in ipairs(CanonicalOrder) do
			Push(MutName)
		end
	end
	table.sort(Extras)
	local CanonToRaw = {}
	for _, Raw in ipairs(Extras) do
		CanonToRaw[Canon(Raw)] = Raw
	end
	table.clear(MutationsList)
	table.insert(MutationsList, "None")
	local Used = {}
	for _, Name in ipairs(CanonicalOrder) do
		local Raw = CanonToRaw[Canon(Name)]
		if Raw and not Used[Raw] then
			Used[Raw] = true
			table.insert(MutationsList, Raw)
		end
	end
	for _, Raw in ipairs(Extras) do
		if not Used[Raw] then
			Used[Raw] = true
			table.insert(MutationsList, Raw)
		end
	end
end
Tasks.InitializeMutationsList()
local SCRAMBLE_TRADE_SLOTS = 3
local DefaultRarityColors = {
	["Common"] = Color3.fromRGB(200, 200, 200),
	["Uncommon"] = Color3.fromRGB(87, 242, 135),
	["Rare"] = Color3.fromRGB(70, 150, 255),
	["Epic"] = Color3.fromRGB(180, 70, 255),
	["Legendary"] = Color3.fromRGB(255, 170, 0),
	["Mythic"] = Color3.fromRGB(255, 60, 100),
	["Mythical"] = Color3.fromRGB(255, 60, 100),
	["Cosmic"] = Color3.fromRGB(0, 240, 255),
	["Secret"] = Color3.fromRGB(255, 35, 35),
	["Eternal"] = Color3.fromRGB(255, 215, 0),
	["Divine"] = Color3.fromRGB(255, 255, 255),
}
local RarityCanonKeysByLength = {}
for CanonKey in pairs(RarityRankNormalized) do
	table.insert(RarityCanonKeysByLength, CanonKey)
end
table.sort(RarityCanonKeysByLength, function(A, B)
	return #A > #B
end)
local RarityTierMap = {
	["common"] = 1,
	["basic"] = 1,
	["uncommon"] = 2,
	["rare"] = 3,
	["superrare"] = 3,
	["super rare"] = 3,
	["epic"] = 4,
	["legendary"] = 5,
	["superior"] = 5,
	["mythic"] = 6,
	["mythical"] = 6,
	["cosmic"] = 7,
	["secret"] = 8,
	["eternal"] = 9,
	["divine"] = 10,
	["transcendent"] = 11,
}
local RarityNumberedList = {
	"1. Common",
	"2. Uncommon",
	"3. Rare",
	"4. Epic",
	"5. Legendary",
	"6. Mythic",
	"7. Cosmic",
	"8. Secret",
	"9. Eternal",
	"10. Divine",
}
local SellRuleOptions = { "Rarity Only", "Value Only", "Rarity And Value", "Rarity Or Value" }
local TrailCatalog = {
	"MoonbloomTrail",
	"DivineTrail",
	"EternalTrail",
	"SecretTrail",
	"GalaxyTrail",
	"RedTrail",
	"GoldenTrail",
	"PurpleTrail",
	"BlueTrail",
	"GreenTrail",
	"GreyTrail",
}
Tasks.StealPriorityOptions = {
	"Best Rarity",
	"Biggest Weight",
	"Best Mutation",
	"Highest Value",
	"Lowest Value",
}
local function ParseMultiDropdownSelection(InputData)
	local ResultMap = {}
	if type(InputData) == "table" then
		for Key, Value in pairs(InputData) do
			if type(Key) == "number" and type(Value) == "string" then
				ResultMap[string.lower(Value)] = true
			elseif type(Key) == "string" and (Value == true or type(Value) == "table") then
				ResultMap[string.lower(Key)] = true
			end
		end
	elseif type(InputData) == "string" and InputData ~= "" then
		ResultMap[string.lower(InputData)] = true
	end
	return ResultMap
end
local function CalculateEggIncome(rec: any): number
	if not rec then
		return 0
	end
	local cat = tostring(rec.AssetCategory or rec.Category or rec.Name or "")
	local scale = tonumber(rec.AssetScale or rec.Scale) or 1
	local muts = rec.Mutations or {}
	local item = {
		Category = cat,
		Scale = scale,
		Mutations = muts,
	}
	if AssetEarningsModule then
		local ok, rate = pcall(AssetEarningsModule.LiveRatePerSecond, item, nil, nil, LocalPlayer)
		if ok and type(rate) == "number" and rate > 0 then
			return rate
		end
		local ok2, rate2 = pcall(AssetEarningsModule.MutationOnlyRatePerSecond, item)
		if ok2 and type(rate2) == "number" and rate2 > 0 then
			return rate2
		end
	end
	local dir = AssetsModule and AssetsModule.Directory and AssetsModule.Directory[cat]
	if not dir then
		if type(AssetsModule) == "table" and type(AssetsModule.Directory) == "table" then
			local cleanQuery = string.gsub(string.lower(cat), "[^%a%d]", "")
			for key, val in pairs(AssetsModule.Directory) do
				if type(val) == "table" then
					local testNames = {
						tostring(key),
						tostring(val._id or ""),
						tostring(val.DisplayName or ""),
						(val.Egg and tostring(val.Egg.ModelName or "")) or "",
					}
					for _, nameCandidate in ipairs(testNames) do
						if
							nameCandidate ~= ""
							and string.gsub(string.lower(nameCandidate), "[^%a%d]", "") == cleanQuery
						then
							dir = val
							break
						end
					end
					if dir then
						break
					end
				end
			end
		end
	end
	if not dir then
		return 0
	end
	local baseRate = tonumber(dir.EarningRate) or 0
	local scaleFactor = scale <= 5 and (scale ^ 1.85) or ((scale / 5) ^ 1.2 * 19.637875755794113)
	local mutMult = 1
	pcall(function()
		local MutMod = require(ReplicatedStorage.Shared.Modules.Mutations)
		if MutMod and MutMod.EarningsFor then
			mutMult = MutMod.EarningsFor(muts)
		end
	end)
	return math.max(1, math.round(baseRate * scaleFactor * (tonumber(mutMult) or 1)))
end
local function FormatCash(n: number): string
	n = tonumber(n) or 0
	if n <= 0 then
		return "0"
	end
	local units = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
	for _, u in ipairs(units) do
		if n >= u[1] then
			local v = n / u[1]
			local txt
			if v < 10 then
				txt = string.format("%.1f", v)
				if string.find(txt, "%.0$") then
					txt = string.sub(txt, 1, -3)
				end
			else
				txt = string.format("%.0f", v)
			end
			return txt .. u[2]
		end
	end
	return tostring(math.floor(n))
end
local function ColorToHex(c: Color3): string
	return string.format(
		"#%02X%02X%02X",
		math.clamp(math.floor(c.R * 255 + 0.5), 0, 255),
		math.clamp(math.floor(c.G * 255 + 0.5), 0, 255),
		math.clamp(math.floor(c.B * 255 + 0.5), 0, 255)
	)
end
local function FormatTimeLeft(seconds: number): string
	seconds = math.max(0, math.floor(seconds))
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	if h > 0 then
		return string.format("%dh %02dm", h, m)
	end
	if m > 0 then
		return string.format("%dm %02ds", m, s)
	end
	return string.format("%ds", s)
end
local function ParseWeightInput(InputText: any): number
	if typeof(InputText) == "number" then
		return InputText
	end
	local Raw = string.lower(string.gsub(tostring(InputText or ""), "[,%s]", ""))
	local Multiplier = 1
	if string.find(Raw, "b") then
		Multiplier = 1000000000
		Raw = string.gsub(Raw, "b", "")
	elseif string.find(Raw, "m") then
		Multiplier = 1000000
		Raw = string.gsub(Raw, "m", "")
	elseif string.find(Raw, "k") then
		Multiplier = 1000
		Raw = string.gsub(Raw, "k", "")
	end
	Raw = string.gsub(Raw, "kg", "")
	local CleanNumber = tonumber(string.match(Raw, "[%d%.]+")) or 0
	return CleanNumber * Multiplier
end
local function SetElevated8()
	local Handler = setthreadidentity or set_thread_identity or (syn and syn.set_thread_identity)
	if type(Handler) == "function" then
		pcall(Handler, 8)
	end
end
local function GetToolCategory(tool: Tool, rawName: string?): string
	local Source = rawName or tool.Name
	return tostring(tool:GetAttribute("Category") or Source):gsub("%s*%b()", ""):match("^%s*(.-)%s*$") or Source
end
local function GetToolMutation(tool: Tool): (boolean, string)
	local Attribute = tool:GetAttribute("Mutation")
		or tool:GetAttribute("Mutations")
		or tool:GetAttribute("BaseMutation")
	local HasMutation = false
	local MutationName = "none"
	if type(Attribute) == "string" and Attribute:match("%S") and Attribute:lower() ~= "none" then
		HasMutation = true
		MutationName = Attribute:lower()
	elseif type(Attribute) == "table" and #Attribute > 0 then
		HasMutation = true
		MutationName = tostring(Attribute[1]):lower()
	end
	local lowerName = tool.Name:lower()
	if lowerName:find("golden") then
		HasMutation = true
		MutationName = "golden"
	elseif lowerName:find("silver") then
		HasMutation = true
		MutationName = "silver"
	elseif lowerName:find("rainbow") then
		HasMutation = true
		MutationName = "rainbow"
	end
	return HasMutation, MutationName
end
local N3Restore = {}
function N3Restore.RepointControls(humanoid)
	pcall(function()
		local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
		local module = scripts and scripts:FindFirstChild("PlayerModule")
		if module then
			local controls = require(module):GetControls()
			if type(controls) == "table" then
				controls.humanoid = humanoid
			end
		end
	end)
end
function N3Restore.RestartAnimate(character)
	local animate = character and character:FindFirstChild("Animate")
	if animate and animate:IsA("LocalScript") then
		task.spawn(function()
			pcall(function()
				animate.Enabled = false
			end)
			task.wait()
			pcall(function()
				animate.Enabled = true
			end)
		end)
	end
end
local function ApplyAntiRagdoll(Character: Model?)
	Character = Character or LocalPlayer.Character
	if not Character then
		return
	end
	return
end
local function EnableDesyncGodmode()
	return
end
local function PerformHumanoidSwap()
	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if not Character or not Humanoid or Humanoid.Health <= 0 then
		return false
	end
	if RuntimeState.OriginalHumanoid and RuntimeState.SwapClone and RuntimeState.SwapClone.Parent == Character then
		return true
	end
	local EngineSwap = RuntimeState.StealEngine
	if EngineSwap and EngineSwap.IsGrounded and not EngineSwap.IsGrounded(Humanoid) then
		return false
	end
	pcall(function()
		Humanoid.BreakJointsOnDeath = false
		local ClonedHumanoid = Humanoid:Clone()
		Humanoid.Parent = nil
		ClonedHumanoid.Parent = Character
		RuntimeState.OriginalHumanoid = Humanoid
		RuntimeState.SwapClone = ClonedHumanoid
		pcall(function()
			Humanoid.BreakJointsOnDeath = false
			Humanoid.RequiresNeck = false
		end)
		ClonedHumanoid.WalkSpeed = Humanoid.WalkSpeed
		ClonedHumanoid.JumpPower = Humanoid.JumpPower
		ClonedHumanoid.UseJumpPower = Humanoid.UseJumpPower
		local Camera = Workspace.CurrentCamera
		if Camera then
			Camera.CameraSubject = ClonedHumanoid
		end
		ClonedHumanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		ClonedHumanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
		N3Restore.RepointControls(ClonedHumanoid)
		N3Restore.RestartAnimate(Character)
		RuntimeState.SwapLinks = RuntimeState.SwapLinks or {}
		for _, prop in ipairs({ "WalkSpeed", "JumpPower", "UseJumpPower", "HipHeight" }) do
			local conn = Humanoid:GetPropertyChangedSignal(prop):Connect(function()
				pcall(function()
					ClonedHumanoid[prop] = Humanoid[prop]
				end)
			end)
			table.insert(RuntimeState.SwapLinks, conn)
		end
	end)
	EnableDesyncGodmode()
	return true
end
local function SyncHumanoidSwap()
	local Character = LocalPlayer.Character
	if RuntimeState.SwapClone == nil or RuntimeState.SwapClone.Parent ~= Character then
		return
	end
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local Original = RuntimeState.OriginalHumanoid
	if not Original or not Humanoid or Humanoid == Original then
		return
	end
	pcall(function()
		Humanoid.WalkSpeed = Original.WalkSpeed
		Humanoid.JumpPower = Original.JumpPower
		Humanoid.UseJumpPower = Original.UseJumpPower
	end)
end
local function RestoreCharacter()
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	local Original = RuntimeState.OriginalHumanoid
	local Clone = RuntimeState.SwapClone
	local SwapLive = (Clone ~= nil and Clone.Parent == Character)
	if Original and Original.Parent == nil and SwapLive then
		pcall(function()
			Original.Parent = Character
			local Camera = Workspace.CurrentCamera
			if Camera then
				Camera.CameraSubject = Original
			end
			if Clone and Clone ~= Original and Clone.Parent == Character then
				Clone:Destroy()
			end
		end)
	end
	local States = {
		Enum.HumanoidStateType.Running,
		Enum.HumanoidStateType.Jumping,
		Enum.HumanoidStateType.Climbing,
		Enum.HumanoidStateType.Freefall,
		Enum.HumanoidStateType.Physics,
		Enum.HumanoidStateType.Ragdoll,
		Enum.HumanoidStateType.FallingDown,
		Enum.HumanoidStateType.GettingUp,
		Enum.HumanoidStateType.PlatformStanding,
		Enum.HumanoidStateType.Seated,
		Enum.HumanoidStateType.Dead,
	}
	for _, Humanoid in ipairs({
		Character:FindFirstChildOfClass("Humanoid"),
		Original,
	}) do
		if Humanoid then
			pcall(function()
				for _, State in ipairs(States) do
					Humanoid:SetStateEnabled(State, true)
				end
			end)
			pcall(function()
				local NeckIntact = Humanoid:FindFirstChild("Neck") ~= nil or Humanoid.RigType ~= Enum.HumanoidRigType.R6
				if Humanoid.Health > 0 and NeckIntact then
					Humanoid.RequiresNeck = true
					Humanoid.BreakJointsOnDeath = true
				end
			end)
			pcall(function()
				Humanoid.PlatformStand = false
				Humanoid.Sit = false
				Humanoid.AutoRotate = true
			end)
			N3Restore.RepointControls(Humanoid)
		end
	end
	if RuntimeState.SwapLinks then
		for _, Conn in ipairs(RuntimeState.SwapLinks) do
			pcall(function()
				Conn:Disconnect()
			end)
		end
		table.clear(RuntimeState.SwapLinks)
	end
	RuntimeState.OriginalHumanoid = nil
	RuntimeState.SwapClone = nil
	pcall(function()
		LocalPlayer:Move(Vector3.zero, false)
		local Root = Character:FindFirstChild("HumanoidRootPart")
		if Root then
			Root.AssemblyLinearVelocity = Vector3.zero
			Root.AssemblyAngularVelocity = Vector3.zero
			Root.Anchored = false
		end
	end)
	N3Restore.RestartAnimate(Character)
end
LocalPlayer.CharacterAdded:Connect(function()
	task.defer(function()
		if RuntimeState.SwapLinks then
			for _, Conn in ipairs(RuntimeState.SwapLinks) do
				pcall(function()
					Conn:Disconnect()
				end)
			end
			table.clear(RuntimeState.SwapLinks)
		end
		RuntimeState.OriginalHumanoid = nil
		RuntimeState.SwapClone = nil
	end)
end)
local function IsEggTool(ItemInstance: Instance): boolean
	if not ItemInstance or not ItemInstance:IsA("Tool") then
		return false
	end
	local LowerName = string.lower(ItemInstance.Name)
	if
		string.find(LowerName, "sword")
		or string.find(LowerName, "radar")
		or string.find(LowerName, "basket")
		or string.find(LowerName, "punch")
	then
		return false
	end
	if
		ItemInstance:GetAttribute("EggUid")
		or ItemInstance:GetAttribute("UID")
		or string.find(LowerName, "egg")
		or ItemInstance:GetAttribute("Category")
		or ItemInstance:GetAttribute("ItemType") == "Egg"
	then
		return true
	end
	return false
end
local function GetEquippedEggTool()
	local Character = LocalPlayer.Character
	if Character then
		for _, Child in ipairs(Character:GetChildren()) do
			if IsEggTool(Child) then
				local Uid = Child:GetAttribute("UID") or Child:GetAttribute("EggUid") or Child.Name
				return Child, Uid
			end
		end
	end
	return nil, nil
end
local function UnequipAllTools()
	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local Backpack = LocalPlayer:FindFirstChild("Backpack")
	if Humanoid then
		pcall(function()
			Humanoid:UnequipTools()
		end)
	end
	if Character and Backpack then
		for _, Child in ipairs(Character:GetChildren()) do
			if Child:IsA("Tool") then
				pcall(function()
					Child.Parent = Backpack
				end)
			end
		end
	end
end
local function CreateSafetyFloorPad(TargetPosition: Vector3, Duration: number)
	Duration = Duration or 8
	local SafetyPad = Instance.new("Part")
	SafetyPad.Name = "N3Hub_SafetyPad"
	SafetyPad.Size = Vector3.new(30, 1.5, 30)
	SafetyPad.Position = TargetPosition - Vector3.new(0, 3.2, 0)
	SafetyPad.Anchored = true
	SafetyPad.Transparency = 1
	SafetyPad.CanCollide = true
	SafetyPad.Parent = Workspace
	task.delay(Duration, function()
		pcall(function()
			SafetyPad:Destroy()
		end)
	end)
	return SafetyPad
end
local function IsActivelyCarryingEgg(SpecificUid: string?): boolean
	local CarriedTool, CarriedUid = GetEquippedEggTool()
	if CarriedTool then
		if SpecificUid then
			if CarriedUid == SpecificUid or not CarriedUid then
				return true
			end
		else
			return true
		end
	end
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if RootPart and RootPart.Position.X <= (SafeBaseLineX + 15) then
		return false
	end
	if EggStateModule and EggStateModule.ReadFieldEggs then
		local Success, Result = pcall(EggStateModule.ReadFieldEggs)
		if Success and Result and Result.Records then
			for _, Record in ipairs(Result.Records) do
				local RecordState = Record.State
				local IsCarriedState = (RecordState == "Carried")
					or (RecordState == "GuardCarried")
					or (RecordState == 2)
				if
					IsCarriedState
					and (Record.CarrierUserId == LocalPlayer.UserId or Record.Carrier == LocalPlayer.UserId)
				then
					if SpecificUid then
						if Record.Uid == SpecificUid then
							return true
						end
					else
						return true
					end
				end
			end
		end
	end
	return false
end
RuntimeState.StealEngine = (function()
	local Engine = {}
	RuntimeState.StealEngine = Engine
	Engine.Movement = { Owner = nil }
	local RagdollModule = nil
	do
		local ok, mod = pcall(function()
			return require(ReplicatedStorage.Shared.Modules.Ragdoll)
		end)
		RagdollModule = ok and mod or nil
	end
	Engine.Carry = {
		Enabled = true,
		Height = 70,
		ClimbShare = 0.5,
		CarryRatio = 0.9,
		CarryScale = 1,
		EasyRatio = 1.3,
		SpeedRatio = 1.5,
		ExcessSeconds = 5.5,
		StretchSeconds = 6,
		GuardMargin = 4,
		GuardRatio = 1.06,
		MinRatio = 1.1,
		Mult = 1,
		LightMult = 0.96,
		SameSpeedBigEggs = false,
		GuessMult = 0.93,
		Category = nil,
		Seen = {},
		Approach = "Run",
		RunSpeed = 1.15,
		RunHeight = 50,
		RunWait = 0,
		RunAnimate = true,
		StraightRun = true,
		SpeedJitter = 0.08,
		Wobble = 0,
		LaneOffset = 0,
		PausesPerMinute = 0,
		JumpsPerMinute = 0,
		ReactMin = 0.05,
		ReactMax = 0.2,
		WaitGuard = false,
		BeatGuard = false,
		Blocked = {},
		BaseWait = 6.5,
		WaitRate = 0.9,
		FreeJump = 1500,
		JumpDistance = 0,
		JumpAt = 0,
		RecoverTries = 12,
		SlowUntil = 0,
		SlowFactor = 0.3,
		FloorSpeed = 0,
		PlanOk = true,
		LastSkip = nil,
		ApproachStop = 3,
		ApproachTime = 30,
		TweenScale = 1,
		TweenScaleMin = 50,
		TweenScaleMax = 120,
		CarryScaleMin = 80,
		CarryScaleMax = 120,
		GuardStartWait = 1,
		GuardDodgeWait = 30,
		GuardSettle = 0.2,
		HitBudget = 20,
		HitDropGrace = 1,
		HandSettle = 0.3,
		DropSettle = 1,
		SlotSettle = 0.8,
		StandUpBudget = 6,
		SnapRange = 20,
		AimLift = 3,
		HoldSnap = 6,
		PartTighten = 12,
		GuardStandoff = 3,
		BaitFar = 90,
		ArrivePad = 2.5,
		ScanWait = 0.08,
		BlockSeconds = 5,
		StuckSeconds = 90,
		GrabBudget = 6,
		GrabInterval = 0.08,
		GrabLift = 2.5,
		PromptRange = 14,
		GuardSleepWait = 15,
		PostTpTries = 8,
		PostTpRetryGap = 0.12,
		LineDrop = false,
		LineGap = 12,
		LineWait = 15,
		DirectBudget = 450,
		DirectMargin = 0.3,
		CrossNow = false,
		CrossRatio = 1,
		PickupRatio = 0.667,
		HopRatio = 1.515,
		FarFromLine = 150,
		DropDelay = 0.19,
		ReJump = true,
		ReJumpMax = 40,
		ShakeTime = 0,
		ShakeInside = 1,
		SnapPickup = false,
		Hops = true,
		HopStop = 48,
		HopGap = 0.1,
		HopLift = 42,
		HopStop = 48,
		HopLift = 42,
		GetUp = true,
		LineLift = 3.35,
		LineY = 67.67,
		LineX = 552.2,
		ZClampMin = -425,
		ZClampMax = -300,
		PickupTries = 4,
		HopStep = 350,
		MidDrops = { 0.33, 0.66 },
		BackRunRatio = 15,
		BackRunMax = 2000,
		QuickRegrab = 0.08,
		MidRest = 0.05,
		KeepAliveAt = 0,
		LagGrace = 4,
		SnapLimit = 90,
		CrossSpeed = 231,
		PickupSpeed = 154,
		LineApproach = 0.97,
		LockCamera = false,
		RunStyle = "Velocity",
		CarryStyle = "Velocity",
		CarryReact = 0,
		SkipUnsafe = false,
		SlowUntil = 0,
		SlowFactor = 0.55,
	}
	Engine.State = {
		Carrying = false,
		SignalCarrying = false,
		WeldCarrying = false,
		GuessedDrop = false,
		HeldSeenAt = 0,
		CarryUid = nil,
		CarryAreaId = nil,
		CarryMultiplier = 1,
		LastFinishedAt = 0,
		GrabFails = 0,
		LastDelivered = 0,
		LastFailed = 0,
		BlockList = {},
		Priority = "Highest Value",
		ScramblePriority = false,
		ScrambleNeeds = {},
		IndexPriority = false,
		TargetLocked = nil,
	}
	Engine.AutoCarry = { Carrying = false, CarryUid = nil, CarryAreaId = nil, LastFinishedAt = 0 }
	Engine.UpdateAutoCarry = function(data)
		local carrying = type(data) == "table" and data.IsCarrying == true
		local state = Engine.AutoCarry
		if state.Carrying and not carrying then
			state.LastFinishedAt = os.clock()
		end
		if carrying and type(data.Uid) == "string" then
			state.CarryUid = data.Uid
			state.CarryAreaId = data.AreaId
		end
		state.Carrying = carrying
        if Engine.RecordAutoTrace then Engine.RecordAutoTrace(carrying and "carry-on" or "carry-off", state.CarryUid) end
		if Engine.AutoWake then Engine.AutoWake() end
	end
	Engine.AutoDeliverySerial = 0
	Engine.AutoHandledDeliverySerial = 0
	Engine.Guard = {
		Enabled = false,
		Busy = false,
		BusySince = 0,
		Active = false,
		StealActive = false,
		Indep = false,
		Disguise = nil,
	}
	Engine.CurrentTarget = nil
	Engine.Disposed = false
	Engine.PlanInfo = { Speed = 0, Base = 0, Max = 0, Guard = 0, Floor = 0, Ok = true }
	Engine.SetAntiGuard = function(state)
		state = state == true
		Engine.Guard.Enabled = state
		Engine.Guard.Indep = state
		if not state then
			Engine.Guard.Busy = false
			Engine.Guard.Active = false
			pcall(function()
				Engine.EndDisguise()
			end)
		end
		return Engine.Guard.Enabled
	end
	Engine.SetLineDrop = function(state)
		state = state == true
		Engine.Carry.LineDrop = state
		Engine.Carry.SpeedJitter = state and 0 or 0.08
		Engine.ApplyInstantStealSteps(tonumber(FarmConfig.Defense_InstantStealSteps) or 3)
		if state then
            -- Line Drop suppresses dodges without overwriting the user's toggle.
			Engine.Guard.Busy = false
			Engine.Guard.Active = false
			pcall(function()
				Engine.EndDisguise()
			end)
		end
		return Engine.Carry.LineDrop
	end
	Engine.ApplyInstantStealSteps = function(step)
		step = math.clamp(math.floor(tonumber(step) or 3), 1, 6)
		local midDrops = {}
		for i = 1, step - 1 do
			table.insert(midDrops, i / step)
		end
		Engine.Carry.MidDrops = midDrops
		return midDrops
	end
	Engine.ClaimMovement = function(owner)
		if owner ~= "mech" then
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local pos = root and root.Position
			if LocalPlayer:GetAttribute("InScrambleArena") == true or (pos ~= nil and pos.Y < -200) then
				return false
			end
		end
		local cur = Engine.Movement.Owner
		if cur == nil or cur == owner then
			Engine.Movement.Owner = owner
			return true
		end
		if cur == "treadmill" and owner ~= "treadmill" then
			Engine.Movement.Owner = owner
			return true
		end
		if cur == "scramble" and owner == "steal" then
			Engine.Movement.Owner = owner
			return true
		end
		return false
	end
	Engine.ReleaseMovement = function(owner)
		if Engine.Movement.Owner == owner then
			Engine.Movement.Owner = nil
		end
	end
	Engine.GetWalkSpeed = function()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local base = hum and hum.WalkSpeed or 16
		local original = RuntimeState.OriginalHumanoid
		if original and original.Health > 0 then
			base = math.min(base, original.WalkSpeed)
		end
		pcall(function()
			local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
			local speedStat = leaderstats and leaderstats:FindFirstChild("Speed")
			if speedStat then
				local util = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
				local conv = util.SpeedPowerToWalkSpeed(speedStat.Value)
				if tonumber(conv) and conv > 0 then
					base = math.min(base, conv)
				end
			end
		end)
		return base
	end
	Engine.Root = function()
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root and root:IsDescendantOf(Workspace) then
			return root
		end
		return nil
	end
	Engine.IsGrounded = function(hum)
		if not hum or hum.Health <= 0 then
			return false
		end
		if hum.FloorMaterial == Enum.Material.Air then
			return false
		end
		local st = hum:GetState()
		return st == Enum.HumanoidStateType.Running
			or st == Enum.HumanoidStateType.RunningNoPhysics
			or st == Enum.HumanoidStateType.Landed
	end
	Engine.IsNight = function()
		if AreaEggCycleModule and AreaEggCycleModule.IsNightPhase then
			local ok, res = pcall(AreaEggCycleModule.IsNightPhase, Workspace:GetServerTimeNow())
			return ok and res == true
		end
		return false
	end
	Engine.WallSealed = function()
		if AreaEggResetWallModule and AreaEggResetWallModule.IsSealed then
			local ok, res = pcall(AreaEggResetWallModule.IsSealed)
			return ok and res == true
		end
		return false
	end
	Engine.GetSeparationX = function()
		local world = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
		local areas = world and world:FindFirstChild("Areas")
		local sep = areas and areas:FindFirstChild("SeparationLine")
		if sep and sep:IsA("BasePart") then
			return sep.Position.X
		end
		return 552
	end
	Engine.GetBaseSafeSpot = function()
		local paths = {
			{ Path = { "GearGiver_Slap", "Podium" }, Offset = Vector3.new(-16.415000915527344, 21.07200050354004, -6.105999946594238) },
			{
				Path = { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" },
				Offset = Vector3.new(-26.775999069213867, 1.75, 18.665000915527344),
			},
			{
				Path = { "__OBJECTS", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" },
				Offset = Vector3.new(-26.775999069213867, 1.75, 18.665000915527344),
			},
		}
		for _, item in ipairs(paths) do
			local obj = Workspace
			for _, name in ipairs(item.Path) do
				obj = obj and obj:FindFirstChild(name) or nil
			end
			if obj and obj:IsA("BasePart") then
				return obj.CFrame:PointToWorldSpace(item.Offset)
			end
		end
		return Vector3.new(528.7000122070313, 70.56999969482422, -364.1099853515625)
	end
	Engine.InsideBase = function(pos)
		if pos == nil then
			local root = Engine.Root()
			pos = root and root.Position
		end
		if pos == nil then
			return false
		end
		local world = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
		local areas = world and world:FindFirstChild("Areas")
		local sepLine = areas and areas:FindFirstChild("SeparationLine")
		local threshold = (sepLine and sepLine:IsA("BasePart") and sepLine.Position.X) or 552
		return pos.X < threshold
	end
	Engine.FindGuard = function(areaId)
		if not areaId then
			return nil
		end
		local world = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
		local areas = world and world:FindFirstChild("Areas")
		local guardAreas = areas and areas:FindFirstChild("GuardAreas")
		if not guardAreas then
			return nil
		end
		local area = guardAreas:FindFirstChild(tostring(areaId))
		return area and area:FindFirstChild("Guard") or nil
	end
	Engine.GuardSleeping = function(areaId)
		local guard = Engine.FindGuard(areaId)
		return guard ~= nil and guard:GetAttribute("GuardState") == "Sleeping"
	end
	local GuardsModule = nil
	pcall(function()
		local dataFolder = ReplicatedStorage:FindFirstChild("Data")
		local guards = dataFolder and dataFolder:FindFirstChild("Guards")
		if guards and guards:IsA("ModuleScript") then
			GuardsModule = require(guards)
		end
	end)
	Engine.GuardsModule = GuardsModule
	Engine.GetGuardSpeed = function(areaId)
		if not GuardsModule then
			return 0
		end
		local dir = GuardsModule.Directory
		if type(dir) ~= "table" then
			return 0
		end
		local entry = dir[tostring(areaId)]
		if type(entry) ~= "table" then
			return 0
		end
		return tonumber(entry.WalkSpeed) or 0
	end
	Engine.PlanCarrySpeed = function(areaId, distance, multiplier)
		local carry = Engine.Carry
		local walk = Engine.GetWalkSpeed()
		local mult = tonumber(multiplier) or carry.Mult or 1
		local eff = carry.SameSpeedBigEggs and math.max(mult, carry.LightMult) or mult
		local base = walk * carry.CarryRatio * eff
		local ideal = base * carry.SpeedRatio
		local excess = carry.ExcessSeconds * base
		local safeMax
		if distance and distance > excess then
			safeMax = math.min(ideal, base * distance / (distance - excess))
		else
			safeMax = ideal
		end
		local guardSpeed = Engine.GetGuardSpeed(areaId)
		local floorSpeed = 0
		if not carry.BeatGuard or guardSpeed <= 0 then
			local speed = math.max(math.min(base * carry.EasyRatio, safeMax), base)
			Engine.PlanInfo = { Speed = speed, Base = base, Max = safeMax, Guard = guardSpeed, Floor = 0, Ok = true }
			return speed, true, base, safeMax, guardSpeed, 0
		end
		local minSafe = math.max(guardSpeed + carry.GuardMargin, base * carry.MinRatio)
		local beatTarget = math.max(minSafe, guardSpeed * carry.GuardRatio)
		if safeMax < minSafe then
			local stretch = carry.StretchSeconds * base
			local stretchMax
			if distance and distance > stretch then
				stretchMax = math.min(ideal, base * distance / (distance - stretch))
			else
				stretchMax = ideal
			end
			local fallback = guardSpeed + math.max(carry.GuardMargin, 1)
			if fallback <= stretchMax then
				floorSpeed = math.min(fallback, stretchMax)
				Engine.PlanInfo = {
					Speed = fallback,
					Base = base,
					Max = stretchMax,
					Guard = guardSpeed,
					Floor = floorSpeed,
					Ok = true,
				}
				return fallback, true, base, stretchMax, guardSpeed, floorSpeed
			end
		end
		local final = math.max(math.min(beatTarget, safeMax), base)
		local ok = minSafe <= safeMax
		floorSpeed = math.min(guardSpeed + math.max(carry.GuardMargin, 1), safeMax)
		Engine.PlanInfo = { Speed = final, Base = base, Max = safeMax, Guard = guardSpeed, Floor = floorSpeed, Ok = ok }
		return final, ok, base, safeMax, guardSpeed, floorSpeed
	end
	Engine.Pace = function()
		local scale = tonumber(Engine.Carry.TweenScale) or 1
		return math.max(Engine.GetWalkSpeed() * (tonumber(Engine.Carry.RunSpeed) or 1) * scale, 16)
	end
	Engine.CrossPace = function()
		local scale = tonumber(Engine.Carry.TweenScale) or 1
		return math.max(Engine.GetWalkSpeed() * (tonumber(Engine.Carry.CrossSpeed) or 231) / 1000 * 1000, 16)
	end
	Engine.PickupPace = function()
		local scale = tonumber(Engine.Carry.TweenScale) or 1
		return math.max(Engine.GetWalkSpeed() * (tonumber(Engine.Carry.PickupSpeed) or 154) / 1000 * 1000, 16)
	end
	Engine.React = function(minSec, maxSec)
		local lo = math.max(0, math.min(minSec, maxSec))
		local hi = math.max(minSec, maxSec, 0)
		return lo + math.random() * (hi - lo)
	end
	Engine.NewPacer = function(isCarry)
		local carry = Engine.Carry
		local self = {
			Clock = 0,
			Factor = 1,
			Target = 1,
			NextShift = 0,
			Phase = math.random() * math.pi * 2,
			Period = 2 + math.random() * 2.5,
			PauseUntil = 0,
			Lane = (math.random() * 2 - 1) * (tonumber(carry.LaneOffset) or 0),
		}
		function self:Step(dt, humanoid, grounded)
			self.Clock = self.Clock + dt
			if self.NextShift <= self.Clock then
				self.NextShift = self.Clock + 0.5 + math.random()
				local jitter = math.max(carry.SpeedJitter, 0)
				if isCarry then
					self.Target = 1 - math.random() * jitter
				else
					self.Target = 1 + (math.random() * 2 - 1) * jitter
				end
			end
			self.Factor = self.Factor + (self.Target - self.Factor) * math.min(dt * 3, 1)
			local wobble = math.sin(self.Clock * 2 * math.pi / self.Period + self.Phase) * (tonumber(carry.Wobble) or 0)
			local jumped = false
			if grounded and humanoid and (tonumber(carry.JumpsPerMinute) or 0) > 0 then
				jumped = math.random() < (carry.JumpsPerMinute / 60 * dt)
				if jumped then
					pcall(function()
						humanoid.Jump = true
					end)
				end
			end
			local paused = false
			if not isCarry then
				if self.Clock < self.PauseUntil then
					paused = true
				elseif (tonumber(carry.PausesPerMinute) or 0) > 0 then
					if math.random() < (carry.PausesPerMinute / 60 * dt) then
						self.PauseUntil = self.Clock + 0.3 + math.random() * 0.9
						paused = true
					end
				end
			end
			return self.Factor, self.Lane + wobble, paused
		end
		return self
	end
	local function GetCarryContainers()
		local containers = {}
		local char = LocalPlayer.Character
		if char then
			containers[#containers + 1] = char
		end
		containers[#containers + 1] = Workspace
		local objs = Workspace:FindFirstChild("__OBJECTS")
		if objs then
			containers[#containers + 1] = objs
		end
		local slots = Workspace:FindFirstChild("AreaEggSlotsClient")
		if slots then
			containers[#containers + 1] = slots
		end
		return containers
	end
	Engine.GetCarryContainers = GetCarryContainers
	local function ModelWeldedTo(model, root, maxDist)
		if not model:IsA("Model") then
			return false
		end
		if not model:FindFirstChild("Hitbox", true) then
			return false
		end
		if maxDist then
			local okPos, pivot = pcall(function()
				return model:GetPivot().Position
			end)
			if okPos and (pivot - root.Position).Magnitude > maxDist then
				return false
			end
		end
		for _, desc in ipairs(model:GetDescendants()) do
			if desc:IsA("JointInstance") or desc:IsA("WeldConstraint") or desc:IsA("Motor6D") then
				local ok, p0, p1 = pcall(function()
					return desc.Part0, desc.Part1
				end)
				if ok and (p0 == root or p1 == root) then
					return true
				end
			end
		end
		return false
	end
	local function ScanWeldCarry()
		local root = Engine.Root()
		if not root then
			return nil
		end
		for _, container in ipairs(GetCarryContainers()) do
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Model") and ModelWeldedTo(child, root, 18) then
					return child
				end
			end
		end
		return nil
	end
	Engine.ScanWeldCarry = ScanWeldCarry
	local HeldCache = false
	local HeldCacheAt = 0
	local HeldCacheFor = nil
	Engine.HeldByMe = function()
		local uid = Engine.State.CarryUid
		local char = LocalPlayer.Character
		local now = os.clock()
		if HeldCacheFor == uid and (now - HeldCacheAt) < 0.2 then
			return HeldCache
		end
		local result = false
		if char and type(uid) == "string" then
			local model = nil
			for _, container in ipairs(GetCarryContainers()) do
				model = container and container:FindFirstChild(uid)
				if model then
					break
				end
			end
			if model then
				for _, desc in ipairs(model:GetDescendants()) do
					if desc:IsA("WeldConstraint") or desc:IsA("JointInstance") or desc:IsA("Motor6D") then
						local ok, p0, p1 = pcall(function()
							return desc.Part0, desc.Part1
						end)
						if ok and ((p0 and p0:IsDescendantOf(char)) or (p1 and p1:IsDescendantOf(char))) then
							result = true
							break
						end
					end
				end
			end
		end
		if not result then
			result = ScanWeldCarry() ~= nil
		end
		if not result and type(uid) == "string" then
			local root = Engine.Root()
			if root and root.Position.X > SafeBaseLineX then
				pcall(function()
					result = IsActivelyCarryingEgg(uid) and true or false
				end)
			end
		end
		HeldCacheFor = uid
		HeldCacheAt = now
		HeldCache = result
		return result
	end
	Engine.WrongEgg = function(carryUid)
		local state = Engine.State
		if type(carryUid) ~= "string" or not state.Carrying or state.CarryUid == carryUid then
			return false
		end
		local eggState = EggStateModule
		if type(eggState) == "table" and type(eggState.DropFieldEgg) == "function" then
			pcall(eggState.DropFieldEgg, "PlayerRequest")
		end
		local waited = 0
		while state.Carrying and waited < 1 do
			waited = waited + RunService.Heartbeat:Wait()
		end
		state.Carrying = false
		state.CarryUid = carryUid
		return true
	end
	Engine.StealPlan = function()
		if not IsStealActive() or Engine.IsNight() then
			return {}, nil
		end
		local plan = {}
		local currentUid = Engine.State.CarryUid
		if currentUid then
			table.insert(plan, currentUid)
		end
		local ok, raw = pcall(Engine.CollectRawFieldEggs)
		if ok and type(raw) == "table" then
			for _, rec in ipairs(raw) do
				local u = tostring(rec.Uid or "")
				if u ~= "" and u ~= currentUid then
					table.insert(plan, u)
				end
			end
		end
		return plan, currentUid
	end
	Engine.StealNow = function(targetUid, onceOnly)
		if type(targetUid) ~= "string" or not IsStealActive() then
			return
		end
		local state = Engine.State
		state.BlockList[targetUid] = nil
		if type(state.Blocked) == "table" then
			state.Blocked[targetUid] = nil
		end
		RuntimeState.SessionId = RuntimeState.SessionId + 1
	end
	local function SyncCarrying()
		local state = Engine.State
		local was = state.Carrying
		if state.SignalCarrying or state.WeldCarrying then
			state.HeldSeenAt = os.clock()
			state.Carrying = true
			if not was then
				Engine.OnCarryStart()
			end
		else
			if was and (os.clock() - (state.HeldSeenAt or 0)) < 0.8 then
				return
			end
			if was then
				state.LastFinishedAt = os.clock()
			end
			if state.GuessedDrop and (state.SignalCarrying or state.WeldCarrying) then
				state.GuessedDrop = false
			end
			state.Carrying = false
		end
	end
	Engine.SyncCarrying = SyncCarrying
	local function OnCarryChanged(data)
		Engine.UpdateAutoCarry(data)
		if type(data) ~= "table" then
			return
		end
		local carrying = data.IsCarrying == true
		if carrying and data.GuardDisabled == true then
			carrying = false
		end
		Engine.State.SignalCarrying = carrying
		Engine.State.GuessedDrop = false
		if carrying then
			if type(data.Uid) == "string" then
				Engine.State.CarryUid = data.Uid
			end
			Engine.State.CarryAreaId = data.AreaId
			local mult = tonumber(data.SpeedMultiplier)
			if mult and mult > 0 then
				Engine.Carry.Mult = mult
				Engine.State.CarryMultiplier = mult
				Engine.Carry.Category = data.AssetCategory
				if data.AssetCategory ~= nil then
					local cat = tostring(data.AssetCategory)
					Engine.Carry.Seen[cat] = math.min(Engine.Carry.Seen[cat] or mult, mult)
				end
			end
		else
			Engine.State.CarryAreaId = nil
		end
		SyncCarrying()
	end
	Engine.OnCarryChanged = OnCarryChanged
	Engine.BeginDisguise = function(offset)
		-- BEGIN BUILTIN VISUAL DISGUISE GUARD
		if Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual() then
			return -- The safe-zone dummy already owns presentation, not dodge movement.
		end
		-- END BUILTIN VISUAL DISGUISE GUARD
		if Engine.Guard.Disguise then
			return
		end
		local cam = Workspace.CurrentCamera
		local char = LocalPlayer.Character
		local root = Engine.Root()
		if not cam or not char or not root then
			return
		end
		local disguise = {
			Camera = cam,
			CameraType = cam.CameraType,
			CameraCFrame = cam.CFrame,
			Hidden = {},
			Copies = {},
			BindName = "N3Hub_Disguise_" .. tostring(math.random(1e6, 9e6)),
		}
		Engine.Guard.Disguise = disguise
		local sources = { char }
		local egg = ScanWeldCarry()
		if egg then
			sources[#sources + 1] = egg
		end
		for _, src in ipairs(sources) do
			for _, desc in ipairs(src:GetDescendants()) do
				if desc:IsA("BasePart") or desc:IsA("Decal") or desc:IsA("Texture") then
					disguise.Hidden[#disguise.Hidden + 1] = { Part = desc, Old = desc.LocalTransparencyModifier }
				end
			end
		end
		local function MakeGhost(src)
			local archivable = {}
			for _, desc in ipairs(src:GetDescendants()) do
				archivable[desc] = desc.Archivable
				pcall(function()
					desc.Archivable = true
				end)
			end
			local srcArchivable = src.Archivable
			src.Archivable = true
			local ok, copy = pcall(function()
				return src:Clone()
			end)
			src.Archivable = srcArchivable
			for inst, val in pairs(archivable) do
				pcall(function()
					inst.Archivable = val
				end)
			end
			if not ok or not copy then
				return nil
			end
			copy.Name = "N3Hub_Ghost"
			for _, desc in ipairs(copy:GetDescendants()) do
				if
					desc:IsA("LuaSourceContainer")
					or desc:IsA("Sound")
					or desc:IsA("ForceField")
					or desc:IsA("JointInstance")
					or desc:IsA("Constraint")
					or desc:IsA("WeldConstraint")
					or desc:IsA("BodyMover")
					or desc:IsA("ProximityPrompt")
					or desc:IsA("BillboardGui")
				then
					pcall(function()
						desc:Destroy()
					end)
				elseif desc:IsA("BasePart") then
					pcall(function()
						desc.Anchored = true
						desc.CanCollide = false
						desc.CanQuery = false
						desc.CanTouch = false
					end)
				elseif desc:IsA("Humanoid") then
					pcall(function()
						desc.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						desc.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
					end)
				end
			end
			copy.Parent = Workspace
			return copy
		end
		for _, src in ipairs(sources) do
			local ghost = MakeGhost(src)
			if ghost then
				if offset and offset.Magnitude > 0.01 then
					for _, desc in ipairs(ghost:GetDescendants()) do
						if desc:IsA("BasePart") then
							pcall(function()
								desc.CFrame = desc.CFrame + offset
							end)
						end
					end
				end
				disguise.Copies[#disguise.Copies + 1] = ghost
			end
		end
		local function Tick()
			for _, entry in ipairs(disguise.Hidden) do
				pcall(function()
					entry.Part.LocalTransparencyModifier = 1
				end)
			end
			pcall(function()
				if cam.CameraType ~= Enum.CameraType.Scriptable then
					cam.CameraType = Enum.CameraType.Scriptable
				end
				cam.CFrame = disguise.CameraCFrame
			end)
		end
		Tick()
		if
			not pcall(function()
				RunService:BindToRenderStep(disguise.BindName, Enum.RenderPriority.Last, Tick)
			end)
		then
			disguise.BindName = nil
			disguise.Link = RunService.RenderStepped:Connect(Tick)
		end
		disguise.Beat = RunService.Heartbeat:Connect(Tick)
	end
	Engine.EndDisguise = function()
		local disguise = Engine.Guard.Disguise
		if not disguise then
			return
		end
		Engine.Guard.Disguise = nil
		if disguise.BindName then
			pcall(function()
				RunService:UnbindFromRenderStep(disguise.BindName)
			end)
		end
		if disguise.Link then
			pcall(function()
				disguise.Link:Disconnect()
			end)
		end
		if disguise.Beat then
			pcall(function()
				disguise.Beat:Disconnect()
			end)
		end
		for _, entry in ipairs(disguise.Hidden) do
			pcall(function()
				entry.Part.LocalTransparencyModifier = entry.Old or 0
			end)
		end
		disguise.Hidden = {}
		pcall(function()
			if disguise.Camera and disguise.CameraType then
				disguise.Camera.CameraType = disguise.CameraType
			end
		end)
		for _, copy in ipairs(disguise.Copies) do
			pcall(function()
				copy:Destroy()
			end)
		end
		disguise.Copies = {}
	end
	Engine.IsDisguising = function()
		return Engine.Guard.Disguise ~= nil
	end
	Engine.SetVelocity = function(root, vel)
		if not root or not root.Parent then
			return
		end
		pcall(function()
			root.AssemblyLinearVelocity = vel
			root.AssemblyAngularVelocity = Vector3.zero
		end)
	end
	Engine.StopVelocity = function()
		Engine.SetVelocity(Engine.Root(), Vector3.zero)
	end
	Engine.SnapTo = function(position)
		if Engine.Guard.Busy then
			return false
		end
		local root = Engine.Root()
		if not root then
			return false
		end
		local char = root.Parent
		local ok = pcall(function()
			if char and char:IsA("Model") then
				char:PivotTo(CFrame.new(position) * root.CFrame.Rotation)
			else
				root.CFrame = CFrame.new(position) * root.CFrame.Rotation
			end
		end)
		if not ok then
			ok = pcall(function()
				root.CFrame = CFrame.new(position) * root.CFrame.Rotation
			end)
		end
		Engine.ZeroAllParts()
		return ok
	end
	Engine.IsRagdolled = function()
		local character = LocalPlayer.Character
		if RagdollModule and type(RagdollModule.IsRagdolled) == "function" then
			local ok, result = pcall(RagdollModule.IsRagdolled, character)
			if ok and result == true then
				return true
			end
		end
		local endTime = tonumber(LocalPlayer:GetAttribute("RagdollEndTime"))
		if endTime and endTime > workspace:GetServerTimeNow() then
			return true
		end
		character = character and character:FindFirstChildOfClass("Humanoid")
		if character then
			local state = character:GetState()
			return state == Enum.HumanoidStateType.Physics
				or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown
		end
		return false
	end
	Engine.ZeroAllParts = function()
		local char = LocalPlayer.Character
		if not char then
			return
		end
		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("BasePart") then
				pcall(function()
					d.AssemblyLinearVelocity = Vector3.zero
					d.AssemblyAngularVelocity = Vector3.zero
				end)
			end
		end
	end
	Engine.Cancelled = function(sessionId)
		if not IsStealActive() then
			return true
		end
		return RuntimeState.SessionId ~= sessionId
	end
	Engine.DropAndWait = function(sessionId)
		if EggStateModule and EggStateModule.DropFieldEgg then
			pcall(EggStateModule.DropFieldEgg, "PlayerRequest")
		end
		local waited = 0
		while Engine.State.Carrying and waited < Engine.Carry.DropSettle and not Engine.Cancelled(sessionId) do
			waited = waited + RunService.Heartbeat:Wait()
		end
	end
	Engine.ConfirmHeldEgg = function(uid, sessionId)
		local waited = 0
		while not Engine.State.Carrying and waited < Engine.Carry.HandSettle and not Engine.Cancelled(sessionId) do
			waited = waited + RunService.Heartbeat:Wait()
		end
		if not Engine.State.Carrying then
			return false, "The egg never reached the hand"
		end
		if type(uid) ~= "string" then
			return true
		end
		if Engine.State.CarryUid == uid then
			return true
		end
		Engine.DropAndWait(sessionId)
		return false, "Wrong egg in hand, dropping it"
	end
	Engine.HoldConnection = nil
	Engine.HoldTarget = nil
	Engine.StopHold = function()
		if Engine.HoldConnection then
			Engine.HoldConnection:Disconnect()
			Engine.HoldConnection = nil
		end
		Engine.HoldTarget = nil
		Engine.StopVelocity()
	end
	Engine.HoldPosition = function(sessionId, destination)
		Engine.StopHold()
		Engine.HoldTarget = destination
		Engine.HoldConnection = RunService.Heartbeat:Connect(function()
			if not Engine.HoldTarget or Engine.Cancelled(sessionId) then
				return
			end
			if Engine.IsRagdolled() or Engine.Guard.Busy then
				return
			end
			local root = Engine.Root()
			if not root then
				return
			end
			pcall(function()
				root.CFrame = CFrame.new(Engine.HoldTarget) * root.CFrame.Rotation
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end)
		end)
	end
	Engine.HoldUp = function(destination)
		local carry = Engine.Carry
		if Engine.Guard.Busy then
			return
		end
		local char = LocalPlayer.Character
		local root = Engine.Root()
		if not char or not root or not destination then
			return
		end
		if (root.Position - destination).Magnitude > carry.HoldSnap then
			Engine.SnapTo(destination)
			return
		end
		for _, descendant in ipairs(char:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant ~= root then
				if (descendant.Position - root.Position).Magnitude > carry.PartTighten then
					pcall(function()
						descendant.CFrame = root.CFrame
						descendant.AssemblyLinearVelocity = Vector3.zero
					end)
				end
			end
		end
	end
	Engine.WaitToStandUp = function(sessionId, destination)
		local waited = 0
		local budget = Engine.Carry.StandUpBudget
		while true do
			if not (waited < budget) then
				return not Engine.Cancelled(sessionId)
			end
			if Engine.Cancelled(sessionId) then
				break
			end
			local char = LocalPlayer.Character
			local stuck = Engine.IsRagdolled()
			if not stuck and char then
				for _, descendant in ipairs(char:GetDescendants()) do
					if descendant:IsA("Constraint") and string.find(descendant.Name, "RagdollConstraint", 1, true) then
						stuck = true
						break
					end
				end
			end
			if not stuck then
				return not Engine.Cancelled(sessionId)
			end
			Engine.HoldUp(destination)
			waited = waited + RunService.Heartbeat:Wait()
		end
		return false
	end
	Engine.CollectAllFieldEggs = function()
		local out = {}
		local ok, raw = pcall(Engine.CollectRawFieldEggs)
		if not ok or type(raw) ~= "table" then
			return out
		end
		for _, rec in ipairs(raw) do
			if type(rec) == "table" and rec.Uid and typeof(rec.BoundsCFrame) == "CFrame" then
				table.insert(out, {
					Uid = rec.Uid,
					AreaId = rec.AreaId,
					State = rec.State,
					Category = rec.AssetCategory,
					CFrame = rec.BoundsCFrame,
					Position = rec.BoundsCFrame.Position,
					PhysicalModel = rec.PhysicalModel,
				})
			end
		end
		return out
	end
	Engine.Lift = function(height, baseY)
		local char = LocalPlayer.Character
		local root = Engine.Root()
		if not char or not root or (tonumber(height) or 0) <= 0.5 then
			return
		end
		local targetY = (baseY or root.Position.Y) + height
		if root.Position.Y >= targetY - 2 then
			return
		end
		pcall(function()
			char:PivotTo(CFrame.new(Vector3.new(root.Position.X, targetY, root.Position.Z)) * root.CFrame.Rotation)
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end)
	end
	Engine.RunPace = function(targetPos, opts)
		opts = opts or {}
		local sessionId = opts.Session or RuntimeState.SessionId
		local isCarry = opts.IsCarry == true
		local speed = tonumber(opts.Speed) or Engine.Pace()
		local height = tonumber(opts.Height) or 0
		local stopDist = opts.StopDist or 2.5
		local timeout = opts.Timeout or 20
		local char = LocalPlayer.Character
		local root = Engine.Root()
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then
			return false
		end
		local style = isCarry and (Engine.Carry.CarryStyle or "Velocity") or (Engine.Carry.RunStyle or "Velocity")
		local carryReact = tonumber(Engine.Carry.CarryReact) or 0
		if isCarry and carryReact > 0 then
			task.wait(carryReact * 0.1)
		end
		local lockCam = Engine.Carry.LockCamera == true and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual())
		local camSaved = nil
		local function FreezeRunCam()
			local cam = workspace.CurrentCamera
			if not cam then
				return
			end
			if lockCam and not camSaved then
				camSaved = { Type = cam.CameraType, CFrame = cam.CFrame }
				pcall(function()
					cam.CameraType = Enum.CameraType.Scriptable
					cam.CFrame = camSaved.CFrame
				end)
			end
		end
		local function UnfreezeRunCam()
			local cam = workspace.CurrentCamera
			if not cam or not camSaved then
				return
			end
			local s = camSaved
			camSaved = nil
			pcall(function()
				cam.CameraType = s.Type
			end)
		end
		FreezeRunCam()
		local pacer = Engine.NewPacer(isCarry)
		local lastClock = os.clock()
		local deadline = lastClock + timeout
		local arrived = false
		local cancelAt = opts.Cancel or RuntimeState.StealCancel
		Engine.Lift(height, opts.GroundY)
		if isCarry and Engine.Carry.RunAnimate then
			pcall(function()
				hum.PlatformStand = false
			end)
		end
		while os.clock() < deadline do
			if not IsStealActive() or RuntimeState.SessionId ~= sessionId then
				break
			end
			if RuntimeState.StealCancel ~= cancelAt then
				break
			end
			root = Engine.Root()
			if not root or not root.Parent then
				break
			end
			if Engine.Guard.Busy then
				RunService.Heartbeat:Wait()
				lastClock = os.clock()
				continue
			end
			if isCarry and not Engine.State.Carrying and Engine.State.CarryUid then
				local uid = Engine.State.CarryUid
				if os.clock() - (Engine.Carry.KeepAliveAt or 0) > 0.5 then
					Engine.Carry.KeepAliveAt = os.clock()
					Engine.RequestCarry(uid)
				end
			end
			local dt = RunService.Heartbeat:Wait()
			local now = os.clock()
			dt = math.max(now - lastClock, 1 / 240)
			lastClock = now
			if lockCam and camSaved and workspace.CurrentCamera then
				pcall(function()
					workspace.CurrentCamera.CFrame = camSaved.CFrame
				end)
			end
			local factor, lane, paused = pacer:Step(dt, hum, Engine.IsGrounded(hum))
			local goal = targetPos
			local tz = targetPos.Z
			if opts.LaneMin and opts.LaneMax then
				tz = math.clamp(root.Position.Z + lane, opts.LaneMin, opts.LaneMax)
				goal = Vector3.new(targetPos.X, targetPos.Y, tz)
			end
			if opts.SwitchX and root.Position.X <= (opts.SwitchX + 2) then
				goal = opts.Final or targetPos
			end
			local flat = Vector3.new(goal.X - root.Position.X, 0, goal.Z - root.Position.Z)
			local flatDist = flat.Magnitude
			if flatDist < 2 and not opts.RequireHeight then
				arrived = true
				break
			end
			local groundY = opts.GroundY or goal.Y
			local useArc = height > 0.5
			if useArc and opts.ArcField then
				useArc = root.Position.X > (Engine.GetSeparationX() - 2)
			end
			local targetY = groundY
			if useArc then
				local share = math.clamp(Engine.Carry.ClimbShare, 0.1, 0.9)
				local climbDist = height * math.sqrt(1 - share * share) / share
				local t = math.clamp(flatDist / math.max(climbDist, 1), 0, 1)
				targetY = groundY + height * t
			end
			local spd = speed * factor
			if os.clock() < (Engine.Carry.SlowUntil or 0) then
				spd = spd * (Engine.Carry.SlowFactor or 0.3)
			end
			if paused then
				spd = 0
			end
			local unit = flatDist > 0.01 and flat.Unit or Vector3.zero
			if style == "CFrame" then
				local step = unit * math.min(spd, flatDist / 0.05)
				pcall(function()
					root.CFrame = CFrame.new(root.Position + step) * root.CFrame.Rotation
					root.AssemblyLinearVelocity = Vector3.new(step.X, 0, step.Z)
					root.AssemblyAngularVelocity = Vector3.zero
				end)
			elseif useArc then
				local share = math.clamp(Engine.Carry.ClimbShare, 0.1, 0.9)
				local vy = math.clamp((targetY - root.Position.Y) / 0.12, -spd * share, spd * share)
				local hSpeed = math.sqrt(math.max(spd * spd - vy * vy, 0))
				local step = unit * math.min(hSpeed, flatDist / 0.05)
				pcall(function()
					root.AssemblyLinearVelocity = Vector3.new(step.X, vy, step.Z)
				end)
			else
				local step = unit * math.min(spd, flatDist / 0.05)
				pcall(function()
					root.AssemblyLinearVelocity = Vector3.new(step.X, root.AssemblyLinearVelocity.Y, step.Z)
				end)
				if Engine.Carry.RunAnimate and flatDist > 0.01 then
					pcall(function()
						hum:Move(unit, false)
					end)
				end
			end
			pcall(function()
				if flatDist > 0.1 then
					root.CFrame = CFrame.lookAt(root.Position, root.Position + unit)
				end
			end)
			ApplyAntiRagdoll(char)
			if arrived then
				break
			end
		end
		pcall(function()
			hum:Move(Vector3.zero, false)
		end)
		UnfreezeRunCam()
		Engine.SetVelocity(Engine.Root(), Vector3.zero)
		return arrived
			or (
				(
					root.Parent
					and (
							Vector3.new(root.Position.X, 0, root.Position.Z)
							- Vector3.new(targetPos.X, 0, targetPos.Z)
						).Magnitude
						<= stopDist
				) or false
			)
	end
	Engine.RetreatHome = function(sessionId, timeout)
		local safe = Engine.GetBaseSafeSpot()
		local root = Engine.Root()
		if not root then
			return false
		end
		local speed = math.max(Engine.Pace() * 2.5, 160)
		local ok = Engine.RunPace(safe, {
			Session = sessionId,
			Speed = speed,
			Height = 40,
			GroundY = safe.Y,
			IsCarry = false,
			ArcField = true,
			StopDist = 3,
			Timeout = timeout or 25,
		})
		if not ok then
			pcall(function()
				local char = LocalPlayer.Character
				if char then
					char:PivotTo(CFrame.new(safe) * Engine.Root().CFrame.Rotation)
				end
			end)
			Engine.StopVelocity()
			ok = true
		end
		return ok
	end
	Engine.FlyToPosition = function(targetPos, sessionId, stopDist, maxTime, speedLimit)
		local carry = Engine.Carry
		local pace = math.min(Engine.Pace(), math.max(speedLimit or FarmConfig.TweenSpeed or 400, 16))
		if carry.LockCamera and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()) then
			local cam = workspace.CurrentCamera
			if cam then
				pcall(function()
					cam.CameraType = Enum.CameraType.Scriptable
				end)
			end
		end
		local up = targetPos + Vector3.new(0, math.max((carry.GrabLift or 2.5) - 3, 0) + 3, 0)
		return Engine.RunPace(up, {
			Session = sessionId,
			Speed = pace,
			Height = 3,
			GroundY = up.Y - 3,
			IsCarry = false,
			StopDist = stopDist or 3,
			Timeout = maxTime or 30,
			LockCamera = carry.LockCamera or false,
		})
	end
	Engine.FindCarryPrompt = function(uid, position, maxDist)
		maxDist = maxDist or 14
		local best, bestModel, bestDist = nil, nil, maxDist
		for _, child in ipairs(Workspace:GetChildren()) do
			if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
				local prompt = child:FindFirstChild("CarryAreaEgg")
				if prompt and prompt:IsA("ProximityPrompt") then
					local owner = child:GetAttribute("Uid")
						or child:GetAttribute("UID")
						or child:GetAttribute("EggUid")
						or prompt:GetAttribute("Uid")
						or prompt:GetAttribute("UID")
					if uid == nil or owner == nil or tostring(owner) == tostring(uid) then
						local d = (child.Position - position).Magnitude
						if d < bestDist then
							bestDist = d
							best = prompt
							bestModel = child
						end
					end
				end
			end
		end
		return best, bestModel
	end
	Engine.FirePrompt = function(prompt)
		if not prompt then
			return false
		end
		pcall(function()
			prompt.RequiresLineOfSight = false
			prompt.HoldDuration = 0
		end)
		if typeof(fireproximityprompt) == "function" then
			pcall(fireproximityprompt, prompt)
			return true
		end
		return false
	end
	local GuardSteps = {
		LightDark = {
			Target = "line",
			LineOffset = 8,
			Height = 45,
			OffsetX = -90,
			OffsetZ = -35,
			Jitter = 0,
			Freeze = false,
			StartAt = 0,
			StartRandom = 0,
			HopRandom = 0,
			HoldRandom = 0,
			Steps = {
				{ At = 0.10, To = "home" },
				{ At = 0.33, To = "home" },
				{ At = 0.56, To = "home" },
				{ At = 0.75, To = "start" },
			},
			ReleaseAt = 0.8,
			BusyLimit = 2.5,
		},
		Default = {
			Target = "home",
			LineOffset = 8,
			Height = 0,
			OffsetX = 0,
			OffsetZ = 0,
			Jitter = 0,
			Freeze = true,
			StartAt = 0,
			StartRandom = 0,
			HopRandom = 0.085,
			HoldRandom = 0.395,
			Steps = (function()
				local t = {}
				for i = 1, 25 do
					t[#t + 1] = { At = 0.05 * (i - 1), To = "home" }
				end
				t[#t + 1] = { At = 1.27, To = "start" }
				return t
			end)(),
			ReleaseAt = 1.52,
			BusyLimit = 2.5,
		},
	}
	local function PickGuardSteps(areaId)
		local key = string.gsub(tostring(areaId or ""), "[^%a]", "")
		if string.lower(key) == "lightdark" then
			return GuardSteps.LightDark
		end
		return GuardSteps.Default
	end
	Engine.PickGuardSteps = PickGuardSteps
	local function Jitter(amount)
		amount = math.max(tonumber(amount) or 0, 0)
		if amount <= 0 then
			return 0
		end
		return (math.random() * 2 - 1) * amount
	end
	local function BuildSteps(spec)
		local steps = spec.Steps or {}
		local releaseAt = tonumber(spec.ReleaseAt) or 0
		local startAt = math.max(tonumber(spec.StartAt) or 0, 0)
		local startRand = math.max(tonumber(spec.StartRandom) or 0, 0)
		local hopRand = math.max(tonumber(spec.HopRandom) or 0, 0)
		local holdRand = math.max(tonumber(spec.HoldRandom) or 0, 0)
		if startRand <= 0 and hopRand <= 0 and holdRand <= 0 then
			return steps, releaseAt, startAt
		end
		local firstAt = math.max(startAt + Jitter(startRand), 0)
		local out = {}
		local acc = 0
		local prev = 0
		for i, step in ipairs(steps) do
			local at = math.max(tonumber(step.At) or 0, 0)
			acc = math.max(acc + math.max(at - prev, 0) + Jitter(step.To == "start" and holdRand or hopRand), firstAt)
			out[i] = { At = acc, To = step.To, Glide = step.Glide }
			prev = at
		end
		return out, acc + math.max(releaseAt - prev, 0), firstAt
	end
	local function GetGuardHome(spec, pos)
		if spec.Target == "line" then
			local sepX = Engine.GetSeparationX()
			local side = pos.X >= sepX and -1 or 1
			local off = (spec.LineOffset or 8) * side
			return Vector3.new(sepX + off, pos.Y + 0.5, pos.Z)
				+ Vector3.new(spec.OffsetX or 0, spec.Height or 0, spec.OffsetZ or 0)
		end
		local safe = Engine.GetBaseSafeSpot()
		return safe + Vector3.new(spec.OffsetX or 0, spec.Height or 0, spec.OffsetZ or 0)
	end
	local function RunGuardDodgeBody(sessionId)
		local guard = Engine.Guard
		local char = LocalPlayer.Character
		local root = Engine.Root()
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not root or not hum or hum.Health <= 0 then
			guard.Busy = false
			guard.Active = false
			return
		end
		local spec = PickGuardSteps(Engine.State.CarryAreaId)
		local steps, releaseAt, firstAt = BuildSteps(spec)
		local startPos = root.Position
		local startClock = os.clock()
		local freeze = spec.Freeze ~= false
		local savedPlatform = hum.PlatformStand
		pcall(function()
			hum.BreakJointsOnDeath = false
		end)
		hum.PlatformStand = true
		local homeDest = GetGuardHome(spec, startPos)
		Engine.BeginDisguise(startPos - homeDest)
		for _, step in ipairs(steps) do
			if not guard.Busy or RuntimeState.SessionId ~= sessionId or not (guard.StealActive or guard.Indep) then
				break
			end
			local target = startClock + (step.At or 0)
			while os.clock() < target do
				if not guard.Busy or RuntimeState.SessionId ~= sessionId or not (guard.StealActive or guard.Indep) then
					break
				end
				RunService.Heartbeat:Wait()
				if freeze then
					Engine.SetVelocity(root, Vector3.zero)
				end
			end
			root = Engine.Root()
			if not root or not root.Parent then
				break
			end
			local dest
			if step.To == "start" then
				dest = startPos
			else
				dest = homeDest
			end
			local jitter = Jitter(spec.Jitter)
			if jitter > 0 then
				dest = dest + Vector3.new(jitter, 0, jitter)
			end
			pcall(function()
				char:PivotTo(CFrame.new(dest) * root.CFrame.Rotation)
			end)
			if (root.Position - dest).Magnitude > 3 then
				pcall(function()
					root.CFrame = CFrame.new(dest) * root.CFrame.Rotation
				end)
			end
			if freeze then
				Engine.SetVelocity(root, Vector3.zero)
			end
		end
		while os.clock() < (startClock + releaseAt) do
			if not guard.Busy or RuntimeState.SessionId ~= sessionId or not (guard.StealActive or guard.Indep) then
				break
			end
			RunService.Heartbeat:Wait()
			if freeze then
				Engine.SetVelocity(root, Vector3.zero)
			end
		end
		pcall(function()
			hum.PlatformStand = savedPlatform
		end)
	end
	local function RunGuardDodge(sessionId)
		local guard = Engine.Guard
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		pcall(RunGuardDodgeBody, sessionId)
		Engine.Carry.SlowUntil = os.clock() + 2
		pcall(function()
			if hum and hum.Parent then
				hum.PlatformStand = false
			end
		end)
		if not Engine.AutoCycle and not Engine.Carry.LineDrop and not Engine.State.Carrying and Engine.State.CarryUid and IsStealActive() then
			local uidNow = Engine.State.CarryUid
			local retryAt = os.clock()
			while
				not (Engine.State.Carrying and Engine.State.CarryUid == uidNow)
				and os.clock() - retryAt < 2.5
				and IsStealActive()
			do
				Engine.PickupDroppedEgg(uidNow)
				RunService.Heartbeat:Wait()
			end
		end
		Engine.EndDisguise()
		guard.Active = false
		guard.Busy = false
	end
	Engine.RunGuardDodge = RunGuardDodge
	Engine.TriggerGuardDodge = function(force)
		-- In a normal cycle, Sena's distance policy owns optional guard protection.
		-- If that source module is unavailable, keep N3's existing dodge fallback.
		local cycle = Engine.AutoCycle
		if
			cycle
			and cycle.GuardPolicy
			and cycle.GuardPolicy.ResolveHitDistance == cycle.GuardDistanceHook
			and Engine.Guard.Enabled
		then
			return
		end
		local guard = Engine.Guard
		if not guard.Enabled or guard.Active then
			return
		end
		if Engine.Carry.LineDrop then
			return
		end
		guard.Active = true
		guard.Busy = true
		guard.BusySince = os.clock()
		task.spawn(RunGuardDodge, RuntimeState.SessionId)
	end
	Engine.OnCarryStart = function()
		Engine.TriggerGuardDodge()
	end
	local acc = 0
	local lastRagdoll = tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0
	RunService.Heartbeat:Connect(function(dt)
		if Engine.Disposed or (Engine.AutoCycle and not Engine.Guard.Enabled) then
			return
		end
		local rag = tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0
		if rag > lastRagdoll then
			lastRagdoll = rag
			if Engine.State.Carrying and not Engine.Guard.Active then
				Engine.TriggerGuardDodge(true)
			end
		end
		local spec = PickGuardSteps(Engine.State.CarryAreaId)
		local limit = math.max(spec.BusyLimit or 2.5, (spec.ReleaseAt or 1.5) + 1)
		if Engine.Guard.Busy and os.clock() - Engine.Guard.BusySince > limit then
			Engine.EndDisguise()
			Engine.Guard.Busy = false
			Engine.Guard.Active = false
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.PlatformStand then
				pcall(function()
					hum.PlatformStand = false
				end)
			end
		end
		acc = acc + dt
		if acc < 0.2 then
			return
		end
		acc = 0
		local idle = not Engine.Guard.Indep
			and not IsStealActive()
			and not Engine.State.Carrying
			and not Engine.State.SignalCarrying
			and not Engine.State.WeldCarrying
		if idle then
			return
		end
		local held = Engine.HeldByMe()
		if held ~= Engine.State.WeldCarrying then
			Engine.State.WeldCarrying = held
		end
		SyncCarrying()
	end)
	pcall(function()
		local signal = EggStateModule and EggStateModule.CarryChanged
		if not signal then
			return
		end
		if type(signal) ~= "table" and type(signal) ~= "function" then
			return
		end
		if type(signal.Connect) == "function" then
			Engine.CarryConnection = signal:Connect(OnCarryChanged)
		else
			signal(OnCarryChanged)
		end
	end)
	LocalPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
		if RaceOwnsCharacter() then return end
		if Engine.AutoCycle or Engine.Carry.LineDrop or not Engine.Guard.Enabled then
			return
		end
		local v = tonumber(LocalPlayer:GetAttribute("RagdollEndTime"))
		if not v or v <= Workspace:GetServerTimeNow() then
			return
		end
		pcall(function()
			Engine.StopVelocity()
		end)
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			pcall(function()
				hum.PlatformStand = false
			end)
		end
	end)
	return Engine
end)()
Tasks.TogAntiTreadmill = nil
local ForceAntiTreadmill = nil
local DisableForcedTreadmill = nil
local function RefreshStealState()
	RuntimeState.SessionId = RuntimeState.SessionId + 1
	RuntimeState.IsExecuting = false
	RuntimeState.StealCancel = RuntimeState.StealCancel + 1
	local active = IsStealActive()
	local Engine = RuntimeState.StealEngine
	if active then
		if ForceAntiTreadmill then
			pcall(ForceAntiTreadmill)
		end
		if not FarmConfig.Defense_InstantSteal and Engine and Engine.MaintainAutoShield then
			pcall(Engine.MaintainAutoShield)
		else
			pcall(PerformHumanoidSwap)
		end
		pcall(EnableDesyncGodmode)
	end
	if Engine then
		if Engine.CancelAutoSteal then Engine.CancelAutoSteal() end
		Engine.CurrentTarget = nil
		Engine.Guard.StealActive = false
		Engine.Guard.Busy = false
		Engine.Guard.Active = false
		Engine.State.Carrying = false
		Engine.State.SignalCarrying = false
		Engine.State.WeldCarrying = false
		Engine.State.CarryUid = nil
		Engine.EndDisguise()
		Engine.ReleaseMovement("steal")
	end
	if not active then
		if Engine then
			pcall(Engine.StopHold)
			pcall(Engine.StopVelocity)
		end
		pcall(RestoreCharacter)
		pcall(function()
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:Move(Vector3.zero, false)
				if hum.PlatformStand then
					hum.PlatformStand = false
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end
			end
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end
		end)
		pcall(UnequipAllTools)
		if DisableForcedTreadmill then
			pcall(DisableForcedTreadmill)
		end
	end
end
local CachedAssetInfo = {}
local function ResolveGameAsset(rawCat)
	local strCat = tostring(rawCat or "")
	if CachedAssetInfo[strCat] then
		return CachedAssetInfo[strCat]
	end
	local directory = nil
	pcall(function()
		if AssetsModule and AssetsModule.Directory then
			directory = AssetsModule.Directory
		end
	end)
	local foundEntry = nil
	if type(directory) == "table" then
		foundEntry = directory[strCat]
		if not foundEntry then
			local cleanQuery = string.gsub(string.lower(strCat), "[^%a%d]", "")
			for key, val in pairs(directory) do
				if type(val) == "table" then
					local testNames = {
						tostring(key),
						tostring(val._id or ""),
						tostring(val.DisplayName or ""),
						(val.Egg and tostring(val.Egg.ModelName or "")) or "",
					}
					for _, nameCandidate in ipairs(testNames) do
						if
							nameCandidate ~= ""
							and string.gsub(string.lower(nameCandidate), "[^%a%d]", "") == cleanQuery
						then
							foundEntry = val
							break
						end
					end
				end
				if foundEntry then
					break
				end
			end
		end
	end
	local rarityTable = (type(foundEntry) == "table" and type(foundEntry.Rarity) == "table" and foundEntry.Rarity)
		or nil
	local rarityStr = rarityTable and tostring(rarityTable.DisplayName or rarityTable._id or "Common") or "Common"
	local rarityRank = rarityTable and tonumber(rarityTable.RarityNumber or rarityTable.Rank) or 1
	local colorVal = rarityTable and typeof(rarityTable.Color) == "Color3" and rarityTable.Color
		or Color3.fromRGB(255, 255, 255)
	local finalIconStr = ""
	local finalEggIconStr = ""
	local eggNameStr = ""
	local growthVal = nil
	if type(foundEntry) == "table" then
		local eggInfo = type(foundEntry.Egg) == "table" and foundEntry.Egg or nil
		local rawIcon = foundEntry.Icon or (eggInfo and eggInfo.Icon)
		if rawIcon and tostring(rawIcon) ~= "" then
			local num = tostring(rawIcon):match("%d+")
			finalIconStr = num and ("rbxassetid://" .. num) or tostring(rawIcon)
		end
		local rawEggIcon = eggInfo and eggInfo.Icon or nil
		if rawEggIcon and tostring(rawEggIcon) ~= "" then
			local eggNum = tostring(rawEggIcon):match("%d+")
			finalEggIconStr = eggNum and ("rbxassetid://" .. eggNum) or tostring(rawEggIcon)
		end
		eggNameStr = eggInfo and tostring(eggInfo.DisplayName or "") or ""
		growthVal = eggInfo and tonumber(eggInfo.GrowthTime) or nil
	end
	local infoObj = {
		Name = (type(foundEntry) == "table" and tostring(foundEntry.DisplayName or strCat)) or strCat,
		Category = strCat,
		Rarity = rarityStr,
		RarityRank = rarityRank,
		Color = colorVal,
		EarningRate = (type(foundEntry) == "table" and tonumber(foundEntry.EarningRate)) or 15,
		Icon = finalIconStr,
		EggIcon = finalEggIconStr,
		EggName = eggNameStr,
		GrowthTime = growthVal,
		Area = type(foundEntry) == "table" and tostring(
			foundEntry.Area
				or foundEntry.Zone
				or (type(foundEntry.Egg) == "table" and (foundEntry.Egg.Area or foundEntry.Egg.Zone))
				or ""
		) or "",
		Chance = type(foundEntry) == "table"
				and (foundEntry.ChancePercent or foundEntry.SpawnChancePercent or foundEntry.DropChancePercent or foundEntry.Chance or foundEntry.SpawnChance or foundEntry.DropChance or (type(
					foundEntry.Egg
				) == "table" and (foundEntry.Egg.ChancePercent or foundEntry.Egg.Chance or foundEntry.Egg.DropChance)))
			or nil,
	}
	CachedAssetInfo[strCat] = infoObj
	return infoObj
end
local CachedScrambleState = {}
local CachedScrambleReqs = {}
local GetScrambleTradeStatusFn = nil
local LastScrambleReqFetch = -math.huge
Tasks.LabState = { FetchBusy = false, ActionBusy = false, Revision = 0, NextActionAt = 0, StateAt = -math.huge }
function Tasks.InvalidateLabState()
	Tasks.LabState.Revision += 1
	Tasks.LabState.StateAt = -math.huge
	CachedScrambleState = {}
	CachedScrambleReqs = {}
	LastScrambleReqFetch = -math.huge
	table.clear(RuntimeState.ScrambleWanted)
	table.clear(RuntimeState.ScrambleReserved)
end
local function RefreshScrambleState(forceRefresh)
	local lab, now = Tasks.LabState, os.clock()
	-- Even a forced UI refresh respects the network throttle/single flight.
	if LibraryLoader.Unloaded or lab.FetchBusy or (now - LastScrambleReqFetch) < 1 then
		return CachedScrambleState
	end
	if not Remotes.RemoteScrambleTradeState then
		return CachedScrambleState
	end
	lab.FetchBusy = true
	LastScrambleReqFetch = now
	local revision = lab.Revision
	local ok, state = pcall(function()
		return Remotes.RemoteScrambleTradeState:InvokeServer()
	end)
	lab.FetchBusy = false
	if LibraryLoader.Unloaded or revision ~= lab.Revision then
		return CachedScrambleState
	end
	if ok and type(state) == "table" then
		CachedScrambleState = state
		-- An empty/locked recipe must erase the previous banner's requirements.
		CachedScrambleReqs = type(state.Requirements) == "table" and state.Requirements or {}
		lab.StateAt = os.clock()
		table.clear(RuntimeState.ScrambleWanted)
		table.clear(RuntimeState.ScrambleReserved)
		if GetScrambleTradeStatusFn then pcall(GetScrambleTradeStatusFn) end
	else
		lab.StateAt = -math.huge
	end
	-- Fetching for the UI never trades, rerolls or claims a reveal.
	return CachedScrambleState
end
local function GetScrambleState()
	return CachedScrambleState
end
local function GetScrambleRequirements()
	return CachedScrambleReqs
end
local function ScrambleCleanName(str)
	return string.lower(tostring(str or "")):gsub("%s+", ""):gsub("%b()", "")
end
local DrScramble = {}
function DrScramble.LabBannerAllowed(state)
	if not FarmConfig.Scramble_LabBannerFilterOn then
		return true
	end
	local picked = FarmConfig.Scramble_LabBanners or {}
	local count = 0
	for _ in pairs(picked) do
		count += 1
	end
	if count == 0 then
		return true
	end
	local bannerId = tostring(state.BannerId or "")
	local display = tostring(state.BannerDisplayName or bannerId)
	for name, on in pairs(picked) do
		if on then
			local key = ScrambleCleanName(name)
			if key == ScrambleCleanName(bannerId) or key == ScrambleCleanName(display) then
				return true
			end
		end
	end
	return false
end
DrScramble.LabBannerOptions = { "Unknown" }
do
	local names = {}
	local ok, rotSec = pcall(function()
		if ScrambleTradeInData and ScrambleTradeInData.RotationSeconds then
			return ScrambleTradeInData.RotationSeconds()
		end
		return 10800
	end)
	rotSec = tonumber(rotSec) or 10800
	local period = math.floor(Workspace:GetServerTimeNow() / rotSec)
	for i = 0, 11 do
		local ok2, bannerId = pcall(function()
			if ScrambleTradeInData and ScrambleTradeInData.BannerIdForPeriod then
				return ScrambleTradeInData.BannerIdForPeriod(period + i)
			end
			return nil
		end)
		if ok2 and bannerId then
			local name = tostring(bannerId)
			pcall(function()
				if ScrambleTradeInData and ScrambleTradeInData.GetBannerDisplayName then
					local ok3, display = pcall(ScrambleTradeInData.GetBannerDisplayName, bannerId)
					if ok3 and display then
						name = tostring(display)
					end
				end
			end)
			names[name] = true
		end
	end
	local sorted = {}
	for name in pairs(names) do
		table.insert(sorted, name)
	end
	table.sort(sorted)
	if #sorted > 0 then
		DrScramble.LabBannerOptions = sorted
	end
end
local function ShouldHoldBackScrambleEgg(rawCategory, rawUid)
	-- BEGIN LAB STOCK HOLDBACK
	if DrScramble.HoldStockEgg and DrScramble.HoldStockEgg(rawCategory, rawUid) then return true end
	-- END LAB STOCK HOLDBACK
	if not FarmConfig.ScrambleHoldBack then
		return false
	end
	if not (FarmConfig.AutoScrambleSubmit or FarmConfig.AutoScrambleSteal)
		or not DrScramble.LabBannerAllowed(GetScrambleState()) then
		return false
	end
	if rawUid and RuntimeState.ScrambleReserved[tostring(rawUid)] then
		return true
	end
	local reqs = GetScrambleRequirements()
	if #reqs == 0 then
		return false
	end
	local key = ScrambleCleanName(rawCategory)
	if key == "" then
		return false
	end
	for _, need in ipairs(reqs) do
		if ScrambleCleanName(need) == key then
			return true
		end
	end
	return false
end
local EventEggCategories = {}
pcall(function()
	local mod = require(ReplicatedStorage:FindFirstChild("Data"):FindFirstChild("ScrambleMastery"))
	if type(mod) == "table" and type(mod.BossDropEgg) == "table" then
		EventEggCategories[ScrambleCleanName(mod.BossDropEgg.Category)] = true
	end
end)
pcall(function()
	local mod = require(ReplicatedStorage:FindFirstChild("Data"):FindFirstChild("CaptureTheEgg"))
	if type(mod) == "table" then
		EventEggCategories[ScrambleCleanName(mod.RewardCategory)] = true
		EventEggCategories[ScrambleCleanName(mod.CarryCategory)] = true
	end
end)
pcall(function()
	local mod = require(ReplicatedStorage:FindFirstChild("Data"):FindFirstChild("BossEvent"))
	if type(mod) == "table" and type(mod.BossName) == "string" then
		EventEggCategories[ScrambleCleanName(mod.BossName)] = true
	end
end)
function Tasks.IsEventEgg(rawCategory)
	local key = ScrambleCleanName(rawCategory)
	if key == "" then
		return false
	end
	if EventEggCategories[key] then
		return true
	end
	if RuntimeState.ScrambleLabCategory and ScrambleCleanName(RuntimeState.ScrambleLabCategory) == key then
		return true
	end
	return false
end
pcall(function()
	if Remotes.RemoteScrambleBannerRotated and Remotes.RemoteScrambleBannerRotated:IsA("RemoteEvent") then
		Remotes.RemoteScrambleBannerRotated.OnClientEvent:Connect(function()
			Tasks.InvalidateLabState()
		end)
	end
end)
local function EquipBatTool()
	local Character = LocalPlayer.Character
	if not Character then
		return nil
	end
	for _, tool in ipairs(Character:GetChildren()) do
		if tool:IsA("Tool") and (tool:GetAttribute("IsBat") == true or string.find(tool.Name:lower(), "bat")) then
			return tool
		end
	end
	local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
	if Backpack then
		for _, tool in ipairs(Backpack:GetChildren()) do
			if tool:IsA("Tool") and (tool:GetAttribute("IsBat") == true or string.find(tool.Name:lower(), "bat")) then
				local hum = Character:FindFirstChildOfClass("Humanoid")
				if hum then
					pcall(function()
						hum:EquipTool(tool)
					end)
				end
				return tool
			end
		end
	end
	return nil
end
local function GetPlayerPlot()
	if
		RuntimeState.PlayerPlot
		and RuntimeState.PlayerPlot.Parent
		and RuntimeState.PetArea
		and RuntimeState.PlotVerified
	then
		return RuntimeState.PlayerPlot, RuntimeState.PetArea
	end
	local PlotsFolder = Workspace:FindFirstChild("Plots")
	if not PlotsFolder then
		return nil, nil
	end
	local FoundPlot = nil
	local Verified = false
	local UserId = LocalPlayer.UserId
	local UserName = string.lower(LocalPlayer.Name)
	local DisplayName = string.lower(LocalPlayer.DisplayName)
	for _, Plot in ipairs(PlotsFolder:GetChildren()) do
		for _, Txt in ipairs(Plot:GetDescendants()) do
			if Txt:IsA("TextLabel") and Txt.Text ~= "" then
				local LowerTxt = string.lower(Txt.Text)
				if string.find(LowerTxt, UserName, 1, true) or string.find(LowerTxt, DisplayName, 1, true) then
					FoundPlot = Plot
					Verified = true
					break
				end
			end
		end
		if FoundPlot then
			break
		end
	end
	if not FoundPlot and Remotes.RemoteLiveSnapshot then
		local Success, Res = pcall(function()
			return Remotes.RemoteLiveSnapshot:InvokeServer()
		end)
		if Success and type(Res) == "table" then
			for SlotKey, SlotData in pairs(Res) do
				if
					type(SlotData) == "table"
					and (SlotData.OwnerUserId == UserId or tostring(SlotData.OwnerUserId) == tostring(UserId))
				then
					local SlotNum = tostring(SlotData.Slot or SlotKey)
					FoundPlot = PlotsFolder:FindFirstChild(SlotNum)
					if FoundPlot then
						Verified = true
						break
					end
				end
			end
		end
	end
	if not FoundPlot and Remotes.RemotePlotState then
		local Success, Res = pcall(function()
			return Remotes.RemotePlotState:InvokeServer()
		end)
		if Success and type(Res) == "table" and type(Res.OwnersBySlot) == "table" then
			for Slot, Owner in pairs(Res.OwnersBySlot) do
				if
					Owner == UserId
					or tostring(Owner) == tostring(UserId)
					or string.lower(tostring(Owner)) == UserName
				then
					FoundPlot = PlotsFolder:FindFirstChild(tostring(Slot))
					if FoundPlot then
						Verified = true
						break
					end
				end
			end
		end
	end
	if not FoundPlot then
		for _, Plot in ipairs(PlotsFolder:GetChildren()) do
			local Attr = Plot:GetAttribute("Owner") or Plot:GetAttribute("OwnerUserId") or Plot:GetAttribute("UserId")
			if
				Attr
				and (Attr == UserId or tostring(Attr) == tostring(UserId) or string.lower(tostring(Attr)) == UserName)
			then
				FoundPlot = Plot
				Verified = true
				break
			end
		end
	end
	if FoundPlot then
		RuntimeState.PlayerPlot = FoundPlot
		RuntimeState.PlotVerified = Verified
		local ToUpdate = FoundPlot:FindFirstChild("ToUpdate")
		RuntimeState.PetArea = (ToUpdate and ToUpdate:FindFirstChild("PetArea"))
			or FoundPlot:FindFirstChild("PetArea")
			or FoundPlot:FindFirstChild("CenterPoint")
	end
	return RuntimeState.PlayerPlot, RuntimeState.PetArea
end
function Tasks.DetermineZoneFromPosition(AreaAttribute: any, Position: Vector3, EggCategory: string): string
	local PosX = Position and Position.X or 0
	local AreaString = string.lower(tostring(AreaAttribute or ""))
	local CategoryString = string.lower(tostring(EggCategory or ""))
	if CategoryString ~= "" and CategoryString ~= "egg" then
		if
			string.find(CategoryString, "archangel")
			or string.find(CategoryString, "archdemon")
			or string.find(CategoryString, "angel")
			or string.find(CategoryString, "demon")
			or string.find(CategoryString, "gargoyle")
			or string.find(CategoryString, "razorfang")
			or string.find(CategoryString, "lamb")
			or string.find(CategoryString, "toro")
			or string.find(CategoryString, "dove")
			or string.find(CategoryString, "light dark")
			or string.find(CategoryString, "lightdark")
		then
			return "Light Dark"
		end
		if
			string.find(CategoryString, "spideron")
			or string.find(CategoryString, "crustacia")
			or string.find(CategoryString, "rhinotaur")
			or string.find(CategoryString, "gorilla king")
		then
			return "Titan Temple"
		elseif
			string.find(CategoryString, "crane")
			or string.find(CategoryString, "salamander")
			or string.find(CategoryString, "red panda")
			or string.find(CategoryString, "kitsune")
		then
			return "Cherry Blossom"
		elseif
			string.find(CategoryString, "cosmic")
			or string.find(CategoryString, "saturno")
			or string.find(CategoryString, "lunar dragon")
		then
			return "Cosmic"
		elseif
			string.find(CategoryString, "trex")
			or string.find(CategoryString, "pterodactyl")
			or string.find(CategoryString, "bronto")
		then
			return "Prehistoric"
		elseif
			string.find(CategoryString, "kraken")
			or string.find(CategoryString, "whaleshark")
			or string.find(CategoryString, "beluga")
		then
			return "Abyss Ocean"
		elseif
			string.find(CategoryString, "phoenix")
			or string.find(CategoryString, "lava dragon")
			or string.find(CategoryString, "cerberus")
		then
			return "Volcano"
		elseif
			string.find(CategoryString, "yeti")
			or string.find(CategoryString, "ice dragon")
			or string.find(CategoryString, "polar bear")
		then
			return "Snow"
		elseif
			string.find(CategoryString, "sphinx")
			or string.find(CategoryString, "sand spider")
			or string.find(CategoryString, "camel")
		then
			return "Desert"
		elseif
			string.find(CategoryString, "chimpanzee")
			or string.find(CategoryString, "toucan")
			or string.find(CategoryString, "crocodile")
		then
			return "Jungle"
		elseif
			string.find(CategoryString, "duckling")
			or string.find(CategoryString, "turtle")
			or string.find(CategoryString, "swan")
			or string.find(CategoryString, "axolotl")
		then
			return "Lake"
		elseif
			string.find(CategoryString, "chicken")
			or string.find(CategoryString, "dog")
			or string.find(CategoryString, "fox")
		then
			return "Forest"
		end
	end
	if string.find(AreaString, "light") or string.find(AreaString, "dark") then
		return "Light Dark"
	elseif string.find(AreaString, "titan") then
		return "Titan Temple"
	elseif string.find(AreaString, "cherry") then
		return "Cherry Blossom"
	elseif string.find(AreaString, "cosmic") then
		return "Cosmic"
	elseif string.find(AreaString, "prehistoric") or string.find(AreaString, "dino") then
		return "Prehistoric"
	elseif string.find(AreaString, "abyss") or string.find(AreaString, "ocean") then
		return "Abyss Ocean"
	elseif string.find(AreaString, "volcano") or string.find(AreaString, "lava") then
		return "Volcano"
	elseif string.find(AreaString, "snow") or string.find(AreaString, "ice") then
		return "Snow"
	elseif string.find(AreaString, "jungle") then
		return "Jungle"
	elseif string.find(AreaString, "desert") or string.find(AreaString, "sand") then
		return "Desert"
	elseif string.find(AreaString, "lake") or string.find(AreaString, "water") then
		return "Lake"
	elseif string.find(AreaString, "forest") then
		return "Forest"
	end
	if PosX > 0 then
		if PosX >= 5200 then
			return "Light Dark"
		elseif PosX >= 4750 then
			return "Titan Temple"
		elseif PosX >= 4000 then
			return "Cherry Blossom"
		elseif PosX >= 3350 then
			return "Cosmic"
		elseif PosX >= 2780 then
			return "Prehistoric"
		elseif PosX >= 2250 then
			return "Abyss Ocean"
		elseif PosX >= 1850 then
			return "Volcano"
		elseif PosX >= 1450 then
			return "Snow"
		elseif PosX >= 1150 then
			return "Jungle"
		elseif PosX >= 920 then
			return "Desert"
		elseif PosX >= 720 then
			return "Lake"
		else
			return "Forest"
		end
	end
	return "Forest"
end
local FetchAllFieldEggs
function Tasks.IsAnotherPlayerNearEgg(EggPosition: Vector3, Radius: number): boolean
	if not EggPosition then
		return false
	end
	for _, Plr in ipairs(Players:GetPlayers()) do
		if Plr ~= LocalPlayer then
			local PlrChar = Plr.Character
			if PlrChar then
				local PlrRoot = PlrChar:FindFirstChild("HumanoidRootPart")
				if PlrRoot and PlrRoot.Parent and (PlrRoot.Position - EggPosition).Magnitude <= Radius then
					return true
				end
			end
		end
	end
	return false
end
function Tasks.ResolveEggRarity(Record: any): (string, number)
	local Category = tostring(Record.AssetCategory or Record.Name or "")
	local Model = Record.PhysicalModel
	local function CheckName(sourceName)
		local CleanName = tostring(sourceName or "")
		if CleanName ~= "" and CleanName ~= "Unknown" then
			return CleanName, RarityRankOf(CleanName)
		end
		return nil, 0
	end
	if Model then
		local ResolvedName, ResolvedRank =
			CheckName(Model:GetAttribute("Rarity") or Model:GetAttribute("RarityTier") or Model:GetAttribute("Tier"))
		if ResolvedName then
			return ResolvedName, ResolvedRank
		end
	end
	if AssetsModule and AssetsModule.Directory and AssetsModule.Directory[Category] then
		local RawRarity = AssetsModule.Directory[Category].Rarity
		local RarityLabel = type(RawRarity) == "table"
				and tostring(RawRarity.DisplayName or RawRarity.Name or RawRarity._id or "")
			or tostring(RawRarity or "")
		local ResolvedName, ResolvedRank = CheckName(RarityLabel)
		if ResolvedName then
			return ResolvedName, ResolvedRank
		end
	end
	local FoundRank = 0
	local FoundAssetRarity = nil
	if AssetItemsModule and type(AssetItemsModule) == "table" then
		pcall(function()
			if AssetItemsModule.RarityRankForCategory then
				FoundRank = AssetItemsModule.RarityRankForCategory(Category) or 0
			end
			if AssetItemsModule.Assets and AssetItemsModule.Assets[Category] then
				local Data = AssetItemsModule.Assets[Category]
				FoundAssetRarity = Data.Rarity or (Data.Egg and Data.Egg.Rarity)
			end
		end)
	end
	local ResolvedName, ResolvedRank = CheckName(FoundAssetRarity)
	if ResolvedName then
		return ResolvedName, ResolvedRank
	end
	if FoundRank and FoundRank > 0 and RankToRarityMap[FoundRank] then
		local RName = RankToRarityMap[FoundRank]
		return RName, RarityRankTable[RName] or (FoundRank * 10)
	end
	local SnapRarity = tostring(Record.Rarity or "")
	if SnapRarity ~= "" and SnapRarity ~= "Unknown" and SnapRarity ~= "Common" then
		local SnapName, SnapRank = CheckName(SnapRarity)
		if SnapName then
			return SnapName, SnapRank
		end
	end
	local LowerCategory = string.lower(Category .. " " .. tostring(Record.Uid or ""))
	for _, CanonKey in ipairs(RarityCanonKeysByLength) do
		if string.find(LowerCategory, CanonKey, 1, true) then
			return RarityKeyToDisplay[CanonKey] or "Common", RarityRankNormalized[CanonKey] or 1
		end
	end
	return "Common", 1
end
function Tasks.GetEggOfficialKg(Record: any): number
	if EggRecordsModule then
		local RawScale = tonumber(Record.AssetScale or Record.Scale) or 1
		local SuccessScale, WeightScale = pcall(function()
			return EggRecordsModule.WeightKgForScale(RawScale)
		end)
		if SuccessScale and typeof(WeightScale) == "number" and WeightScale > 0 then
			return WeightScale
		end
		local SuccessRec, WeightRec = pcall(function()
			return EggRecordsModule.WeightKg(Record)
		end)
		if SuccessRec and typeof(WeightRec) == "number" and WeightRec > 0 then
			return WeightRec
		end
	end
	local FallbackScale = tonumber(Record.AssetScale or Record.Scale) or 1
	return math.floor(FallbackScale * 20)
end
function Tasks.GetTrackStartPosition(): Vector3
	local trackStart = Workspace:FindFirstChild("World")
		and Workspace.World:FindFirstChild("Build")
		and Workspace.World.Build:FindFirstChild("MainMap")
		and Workspace.World.Build.MainMap:FindFirstChild("TrackStart", true)
	if not trackStart then
		trackStart = Workspace:FindFirstChild("World") and Workspace.World:FindFirstChild("TrackStart", true)
	end
	if trackStart then
		if trackStart:IsA("BasePart") then
			return trackStart.Position + Vector3.new(0, 3.5, 0)
		elseif trackStart:IsA("Model") then
			return trackStart:GetPivot().Position + Vector3.new(0, 3.5, 0)
		end
	end
	return Vector3.new(SafeBaseLineX + 15, 71, SafeCorridorZ)
end
local function GetNightAndWallStatus()
	local serverTimeNow = Workspace:GetServerTimeNow()
	local isNight = false
	local nextNightIn = math.huge
	local nextResetIn = 0
	local wallSealed = false
	if AreaEggCycleModule then
		pcall(function()
			if AreaEggCycleModule.IsNightPhase then
				isNight = AreaEggCycleModule.IsNightPhase(serverTimeNow) == true
			end
			if AreaEggCycleModule.NextNightTime then
				local nextNight = AreaEggCycleModule.NextNightTime(serverTimeNow)
				if type(nextNight) == "number" then
					nextNightIn = math.max(0, nextNight - serverTimeNow)
				end
			end
			if AreaEggCycleModule.NextResetTime then
				local nextReset = AreaEggCycleModule.NextResetTime(serverTimeNow)
				if type(nextReset) == "number" then
					nextResetIn = math.max(0, nextReset - serverTimeNow)
				end
			end
		end)
	end
	if AreaEggResetWallModule and AreaEggResetWallModule.IsSealed then
		pcall(function()
			wallSealed = AreaEggResetWallModule.IsSealed() == true
		end)
	end
	if not isNight and nextNightIn <= 0 then
		nextNightIn = math.huge
	end
	local shouldRetreat = isNight or wallSealed or (nextNightIn <= 5.0)
	return {
		IsNight = isNight,
		NextNightIn = nextNightIn,
		NextResetIn = nextResetIn,
		WallSealed = wallSealed,
		ShouldRetreat = shouldRetreat,
	}
end
local function GenerateSafePenPosition(PetArea: BasePart, ExistingPositions: table): CFrame?
	if not PetArea then
		return nil
	end
	local AreaSize = PetArea.Size
	local HalfX = math.max(4, AreaSize.X / 2 - 5)
	local HalfZ = math.max(4, AreaSize.Z / 2 - 5)
	for _ = 1, 60 do
		local RandX = math.random(-math.floor(HalfX), math.floor(HalfX))
		local RandZ = math.random(-math.floor(HalfZ), math.floor(HalfZ))
		local WorldCF = PetArea.CFrame * CFrame.new(RandX, AreaSize.Y / 2 + 1, RandZ)
		local IsSafe = true
		for _, Pos in ipairs(ExistingPositions) do
			if (Pos - WorldCF.Position).Magnitude < 5.5 then
				IsSafe = false
				break
			end
		end
		if IsSafe then
			return WorldCF
		end
	end
	return PetArea.CFrame * CFrame.new(math.random(-6, 6), AreaSize.Y / 2 + 1, math.random(-6, 6))
end
local function CountPlayerHeldEggs(): number
	local Total = 0
	local Backpack = LocalPlayer:FindFirstChild("Backpack")
	if Backpack then
		for _, Child in ipairs(Backpack:GetChildren()) do
			if IsEggTool(Child) then
				Total = Total + 1
			end
		end
	end
	local Character = LocalPlayer.Character
	if Character then
		for _, Child in ipairs(Character:GetChildren()) do
			if IsEggTool(Child) then
				Total = Total + 1
			end
		end
	end
	return Total
end
function Tasks.ExecuteDepositEggs(OnlySelected: boolean)
	if GetScrambleTradeStatusFn then pcall(GetScrambleTradeStatusFn) end
	local Plot, PetArea = GetPlayerPlot()
	if not PetArea or not Remotes.RemotePlaceEgg then
		return 0
	end
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if not RootPart or not Humanoid then
		return 0
	end
	local PenTargetPos = PetArea.Position + Vector3.new(0, 3.5, 0)
	CreateSafetyFloorPad(PenTargetPos, 12)
	RootPart.CFrame = CFrame.new(PenTargetPos)
	RootPart.AssemblyLinearVelocity = Vector3.zero
	RootPart.AssemblyAngularVelocity = Vector3.zero
	task.wait(0.1)
	local ExistingPositions = {}
	local PlacedCount = 0
	if Remotes.RemoteLiveSnapshot then
		local Success, Res = pcall(function()
			return Remotes.RemoteLiveSnapshot:InvokeServer()
		end)
		if Success and type(Res) == "table" then
			local MyRecords = {}
			for _, SlotData in pairs(Res) do
				if type(SlotData) == "table" and SlotData.OwnerUserId == LocalPlayer.UserId then
					for UidKey, VRec in pairs(SlotData.Records or {}) do
						MyRecords[UidKey] = VRec
					end
				end
			end
			for UidKey, Rec in pairs(MyRecords) do
				if Rec.Placement and Rec.Placement.LocalCFrame then
					table.insert(ExistingPositions, (PetArea.CFrame * Rec.Placement.LocalCFrame).Position)
				elseif not ShouldHoldBackScrambleEgg(Rec.AssetCategory or Rec.Category, UidKey) then
					local RandCF = GenerateSafePenPosition(PetArea, ExistingPositions)
					if RandCF then
						local LocalCF = PetArea.CFrame:ToObjectSpace(RandCF)
						local PlacedOk = pcall(function()
							return Remotes.RemotePlaceEgg:InvokeServer({ Uid = UidKey, LocalCFrame = LocalCF })
						end)
						if PlacedOk then
							PlacedCount = PlacedCount + 1
							table.insert(ExistingPositions, RandCF.Position)
						end
					end
				end
			end
		end
	end
	local Timeout = os.clock() + 3.0
	while CountPlayerHeldEggs() > 0 and os.clock() < Timeout do
		local EggsToPlace = {}
		if Character then
			for _, Child in ipairs(Character:GetChildren()) do
				if IsEggTool(Child) then
					table.insert(EggsToPlace, Child)
				end
			end
		end
		local Backpack = LocalPlayer:FindFirstChild("Backpack")
		if Backpack then
			for _, Child in ipairs(Backpack:GetChildren()) do
				if IsEggTool(Child) then
					table.insert(EggsToPlace, Child)
				end
			end
		end
		if #EggsToPlace == 0 then
			break
		end
		for _, Tool in ipairs(EggsToPlace) do
			local ToolUid = Tool:GetAttribute("UID") or Tool:GetAttribute("EggUid") or Tool.Name
			local Category = tostring(Tool:GetAttribute("Category") or Tool:GetAttribute("AssetCategory") or Tool.Name)
			local ToolName = Tool.Name:lower()
			local CatName = Category:lower()
			if ToolName:find("rift") or CatName:find("rift") then
				continue
			end
			if ShouldHoldBackScrambleEgg(Category, ToolUid) then
				continue
			end
			local CanPlace = true
			if OnlySelected then
				local ToolCategory =
					tostring(Tool:GetAttribute("Category") or Tool:GetAttribute("AssetCategory") or Tool.Name)
				local ToolRarity = tostring(Tool:GetAttribute("Rarity") or Tool:GetAttribute("RarityTier") or "Common")
				local _, MutationStr = GetToolMutation(Tool)
				local EggPass = (next(FarmConfig.PlaceSelectedEggs) == nil)
					or (FarmConfig.PlaceSelectedEggs[string.lower(ToolCategory)] == true)
				local RarityPass = true
				if next(FarmConfig.PlaceSelectedRarities) ~= nil then
					RarityPass = false
					local ToolRarityKey = CanonicalRarityKey(ToolRarity)
					for SelectedRarity, _ in pairs(FarmConfig.PlaceSelectedRarities) do
						if CanonicalRarityKey(SelectedRarity) == ToolRarityKey then
							RarityPass = true
							break
						end
					end
				end
				local MutPass = (next(FarmConfig.PlaceSelectedMutations) == nil)
					or (FarmConfig.PlaceSelectedMutations[string.lower(MutationStr)] == true)
				CanPlace = (EggPass and RarityPass and MutPass)
			end
			if CanPlace then
				local RandCF = GenerateSafePenPosition(PetArea, ExistingPositions)
				if RandCF then
					local LocalCF = PetArea.CFrame:ToObjectSpace(RandCF)
					local Success = pcall(function()
						return Remotes.RemotePlaceEgg:InvokeServer({ Uid = ToolUid, LocalCFrame = LocalCF })
					end)
					if Success then
						PlacedCount = PlacedCount + 1
						table.insert(ExistingPositions, RandCF.Position)
					end
					task.wait(0.04)
				end
			end
		end
		task.wait(0.06)
	end
	UnequipAllTools()
	return PlacedCount
end
local function ExecuteAutoHatch()
	if not Remotes.RemoteHatch or not Remotes.RemoteFinishHatch or not Remotes.RemoteLiveSnapshot then
		return 0
	end
	local Success, Res = pcall(function()
		return Remotes.RemoteLiveSnapshot:InvokeServer()
	end)
	if not Success or type(Res) ~= "table" then
		return 0
	end
	local MyEggs = {}
	for _, SlotData in pairs(Res) do
		if type(SlotData) == "table" and SlotData.OwnerUserId == LocalPlayer.UserId then
			for UidKey, Rec in pairs(SlotData.Records or {}) do
				MyEggs[UidKey] = Rec
			end
		end
	end
	local HatchedCount = 0
	local ServerNow = Workspace:GetServerTimeNow()
	for UidKey, Rec in pairs(MyEggs) do
		if Rec.Placement then
			local IsReady = false
			if EggStateModule then
				local CheckReady = EggStateModule.IsReadyToHatch or EggStateModule.IsLocalEggReady
				if CheckReady then
					local Ok, ReadyRes = pcall(CheckReady, UidKey)
					if Ok and typeof(ReadyRes) == "boolean" then
						IsReady = ReadyRes
					end
				end
			end
			if not IsReady then
				local PlacedTime = Rec.Placement.PlacedAt or 0
				local GrowthDur = Rec.Placement.GrowthDuration or 30
				if (ServerNow - PlacedTime) >= GrowthDur then
					IsReady = true
				end
			end
			if IsReady then
				task.spawn(function()
					pcall(function()
						if Remotes.RemoteHatch:IsA("RemoteFunction") then
							Remotes.RemoteHatch:InvokeServer(UidKey)
						else
							Remotes.RemoteHatch:FireServer(UidKey)
						end
					end)
					task.wait(0.9)
					pcall(function()
						if Remotes.RemoteFinishHatch:IsA("RemoteFunction") then
							Remotes.RemoteFinishHatch:InvokeServer(UidKey)
						else
							Remotes.RemoteFinishHatch:FireServer(UidKey)
						end
					end)
				end)
				HatchedCount = HatchedCount + 1
				task.wait(0.05)
			end
		end
	end
	return HatchedCount
end
local function GetCurrentCash(): number
	local ls = LocalPlayer:FindFirstChild("leaderstats")
	if ls then
		for _, name in ipairs({ "Money", "Cash", "Coins", "Currency" }) do
			local stat = ls:FindFirstChild(name)
			if stat then
				local val = tonumber(stat.Value) or ParseWeightInput(stat.Value)
				if val and val > 0 then
					return val
				end
			end
		end
	end
	if SaveModule and type(SaveModule.Peek) == "function" then
		local ok, sData = pcall(SaveModule.Peek)
		if ok and type(sData) == "table" then
			local cash = tonumber(sData.Cash) or tonumber(sData.Money) or tonumber(sData.Coins)
			if cash and cash > 0 then
				return cash
			end
			if type(sData.Data) == "table" then
				cash = tonumber(sData.Data.Cash) or tonumber(sData.Data.Money) or tonumber(sData.Data.Coins)
				if cash and cash > 0 then
					return cash
				end
			end
		end
	end
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	if gui then
		for _, obj in ipairs(gui:GetDescendants()) do
			if obj:IsA("TextLabel") or obj:IsA("TextButton") then
				local txt = obj.Text
				local num = tonumber(txt:match("([%d,]+)") or txt:gsub(",", ""))
				if num and num > 0 then
					return num
				end
			end
		end
	end
	return 0
end
local SavedJumpHeight = 50
local DefenseRigRefresh = nil
local DefenseRigPatched = false
local DefenseRigConnections = {}
function Tasks.ResumeRaceRigSync()
	for _, connection in ipairs(DefenseRigConnections) do
		pcall(function() connection:Enable() end)
	end
	table.clear(DefenseRigConnections)
	DefenseRigPatched = false
end
function Tasks.ApplyDefenseAntiTrap()
	if RaceOwnsCharacter() then return end
	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not Humanoid or not RootPart or Humanoid.Health <= 0 then
		return
	end
	if type(Humanoid.JumpHeight) == "number" and Humanoid.JumpHeight > 0.5 then
		SavedJumpHeight = Humanoid.JumpHeight
	end
	local IsTrapped = Character:GetAttribute("IsTrapped") == true
	local Trapped = IsTrapped or RootPart.Anchored or Humanoid.JumpHeight == 0
	if Trapped then
		pcall(function()
			if IsTrapped then
				Character:SetAttribute("IsTrapped", nil)
			end
			RootPart.Anchored = false
			Humanoid.PlatformStand = false
			Humanoid.Sit = false
			if Humanoid.JumpHeight < 0.5 then
				Humanoid.JumpHeight = SavedJumpHeight
			end
			local State = Humanoid:GetState()
			if
				State == Enum.HumanoidStateType.Physics
				or State == Enum.HumanoidStateType.PlatformStanding
				or State == Enum.HumanoidStateType.Seated
			then
				Humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
		pcall(function()
			local TrapBillboard = Character:FindFirstChild("TrapBillboard", true)
			if TrapBillboard then
				TrapBillboard:Destroy()
			end
		end)
	end
end
function Tasks.EnsureDefenseRigSyncOff()
	if RaceOwnsCharacter() or (Tasks.RaceSuppressRagdoll and Tasks.RaceSuppressRagdoll()) then return false end
	if DefenseRigPatched then
		return true
	end
	if not FarmConfig.Defense_AntiRagdoll then
		return false
	end
	local Packages = ReplicatedStorage:FindFirstChild("Packages")
	local Networking = Packages and Packages:FindFirstChild("Networking")
	DefenseRigRefresh = Networking and Networking:FindFirstChild("RE/RigSync/Refresh")
	if not DefenseRigRefresh then
		return false
	end
	if type(getconnections) ~= "function" then
		return false
	end
	local ok, Result = pcall(function()
		return getconnections(DefenseRigRefresh.OnClientEvent)
	end)
	if not ok or type(Result) ~= "table" or #Result == 0 then
		return false
	end
	local Patched = 0
	for _, Conn in ipairs(Result) do
		if Conn.Enabled ~= false then
			local disabled = pcall(function() Conn:Disable() end)
			if disabled then
				table.insert(DefenseRigConnections, Conn)
				Patched += 1
			end
		end
	end
	DefenseRigPatched = Patched > 0
	return DefenseRigPatched
end
function Tasks.ApplyDefenseAntiRagdoll()
	if RaceOwnsCharacter() or (Tasks.RaceSuppressRagdoll and Tasks.RaceSuppressRagdoll()) then return end
	if RuntimeState.StealEngine and RuntimeState.StealEngine.AutoCycle then
		return
	end
	Tasks.EnsureDefenseRigSyncOff()
	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not Humanoid or not RootPart or Humanoid.Health <= 0 then
		return
	end
	local State = Humanoid:GetState()
	local RagdollEndTime = LocalPlayer:GetAttribute("RagdollEndTime")
	local CharAttr = Character and Character:GetAttribute("RagdollEndTime")
	if type(RagdollEndTime) ~= "number" then
		RagdollEndTime = CharAttr
	end
	local RecentlyHit = type(RagdollEndTime) == "number" and RagdollEndTime > workspace:GetServerTimeNow() - 0.05
	if
		State == Enum.HumanoidStateType.Ragdoll
		or State == Enum.HumanoidStateType.FallingDown
		or State == Enum.HumanoidStateType.Physics
		or RecentlyHit
	then
		pcall(function()
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			if not RecentlyHit then
				Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				Humanoid.PlatformStand = false
				Humanoid.Sit = false
			else
				Humanoid.PlatformStand = true
			end
		end)
		if Character then
			pcall(function()
				Character:SetAttribute("RagdollEndTime", 0)
			end)
		end
		pcall(function()
			LocalPlayer:SetAttribute("RagdollEndTime", 0)
		end)
		if RootPart and not RecentlyHit then
			pcall(function()
				local MoveDirection = Humanoid.MoveDirection
				local Speed = Humanoid.WalkSpeed or 0
				RootPart.AssemblyLinearVelocity =
					Vector3.new(MoveDirection.X * Speed, RootPart.AssemblyLinearVelocity.Y, MoveDirection.Z * Speed)
				RootPart.AssemblyAngularVelocity = Vector3.zero
			end)
		end
	else
		pcall(function()
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
			if Humanoid.PlatformStand then
				Humanoid.PlatformStand = false
			end
			if Humanoid.Sit then
				Humanoid.Sit = false
			end
		end)
	end
end
local InstanUtility = {
	conns = {},
}
function InstanUtility:Bind(Connection, Callback)
	local ok, Result = pcall(function()
		local Conn = Connection:Connect(Callback)
		self.conns[Conn] = Conn
		return Conn
	end)
	if ok and Result then
		return Result
	end
	return nil
end
function InstanUtility:Unbind()
	local Patched = 0
	for Conn in pairs(self.conns) do
		pcall(function()
			Conn:Disconnect()
		end)
		Patched = Patched + 1
	end
	self.conns = {}
	return Patched
end
local InstanInteractActive = false
function Tasks.SetupInstanInteract()
	local WantActive = FarmConfig.InstanInteract == true
	if InstanInteractActive == WantActive then
		return
	end
	InstanInteractActive = WantActive
	if not WantActive then
		InstanUtility:Unbind()
		return
	end
	local PromptService = game:GetService("ProximityPromptService")
	local Bound = InstanUtility:Bind(PromptService.PromptButtonHoldBegan, function(ProximityPrompt, Player)
		if Player ~= LocalPlayer then
			return
		end
		if tostring(ProximityPrompt) == "CarryAreaEgg" then
			ProximityPrompt.HoldDuration = 0
		end
	end)
	InstanInteractActive = Bound ~= nil
end
(function()
	local Engine = RuntimeState.StealEngine
	local RawCache = {}
	local RawCacheAt = 0
	local RawCacheTtl = 0.5
	local function CollectRawFieldEggs(forceRefresh)
		local now = os.clock()
		if not forceRefresh and #RawCache > 0 and (now - RawCacheAt) < RawCacheTtl then
			return RawCache
		end
		local list, seen = {}, {}
		if EggStateModule and EggStateModule.ReadFieldEggs then
			local ok, res = pcall(EggStateModule.ReadFieldEggs)
			if ok and type(res) == "table" and type(res.Records) == "table" then
				for key, rec in pairs(res.Records) do
					if type(rec) == "table" and rec.BottomCFrame then
						local uid = rec.Uid or tostring(key)
						local st = tostring(rec.State or "")
						if
							st == "Slot"
							or st == "Dropped"
							or st == "Carried"
							or rec.State == 1
							or rec.State == 2
							or rec.State == 3
						then
							rec.Uid = uid
							rec.BoundsCFrame = rec.BottomCFrame
							seen[uid] = true
							table.insert(list, rec)
						end
					end
				end
			end
		end
		if #list == 0 and Remotes.RemoteEggSnapshot and Remotes.RemoteEggSnapshot:IsA("RemoteFunction") then
			local ok, res = pcall(function()
				return Remotes.RemoteEggSnapshot:InvokeServer()
			end)
			if ok and type(res) == "table" then
				local recs = res.Records or res
				for key, rec in pairs(recs) do
					if type(rec) == "table" and rec.BottomCFrame then
						local uid = rec.Uid or tostring(key)
						if not seen[uid] then
							local st = tostring(rec.State or "")
							if
								st == "Slot"
								or st == "Dropped"
								or st == "Carried"
								or rec.State == 1
								or rec.State == 2
								or rec.State == 3
							then
								rec.Uid = uid
								rec.BoundsCFrame = rec.BottomCFrame
								seen[uid] = true
								table.insert(list, rec)
							end
						end
					end
				end
			end
		end
		if #list > 0 or forceRefresh then
			RawCache = list
			RawCacheAt = now
		end
		return list
	end
	FetchAllFieldEggs = function(forceRefresh)
		return CollectRawFieldEggs(forceRefresh)
	end
	local function MatchZone(zone)
		if next(FarmConfig.SelectedZones) == nil then
			return true
		end
		return FarmConfig.SelectedZones[string.lower(zone)] == true
	end
	local function MatchEggCategory(cat)
		if next(FarmConfig.SelectedEggs) == nil then
			return true
		end
		return FarmConfig.SelectedEggs[string.lower(cat)] == true
	end
	local function MatchRarity(name)
		if next(FarmConfig.SelectedRarities) == nil then
			return true
		end
		local key = CanonicalRarityKey(name)
		for sel in pairs(FarmConfig.SelectedRarities) do
			if CanonicalRarityKey(sel) == key then
				return true
			end
		end
		return false
	end
	local function MatchMutation(rec)
		if next(FarmConfig.SelectedMutations) == nil then
			return true
		end
		local allowNone = FarmConfig.SelectedMutations["none"] == true
		local found = {}
		if type(rec.Mutations) == "table" then
			for _, m in pairs(rec.Mutations) do
				local n = type(m) == "table" and (m.Id or m.Label or m.Name) or tostring(m)
				table.insert(found, string.lower(n))
			end
		end
		if rec.Mutation then
			table.insert(found, string.lower(tostring(rec.Mutation)))
		end
		if #found == 0 then
			return allowNone
		end
		for _, m in ipairs(found) do
			if FarmConfig.SelectedMutations[m] then
				return true
			end
			local alt = Tasks.MutationAliases[m]
			if alt and FarmConfig.SelectedMutations[alt] then
				return true
			end
		end
		return false
	end
	local function GetRarityTier(name)
		local low = string.lower(tostring(name or ""))
		if low:find("divine") or low:find("archangel") or low:find("archdemon") then
			return 6
		elseif low:find("eternal") or low:find("oni tiger") then
			return 5
		elseif low:find("secret") or low:find("dark gargoyle") or low:find("razorfang") or low:find("kraken") then
			return 4
		elseif low:find("cosmic") then
			return 3
		elseif low:find("myth") then
			return 2
		elseif low:find("legend") then
			return 1
		elseif low:find("epic") then
			return 0.5
		elseif low:find("rare") then
			return 0.3
		elseif low:find("uncommon") then
			return 0.1
		end
		return 0
	end
	local function IsScrambleTarget(cat, reqs)
		-- BEGIN LAB STOCK TARGET
		if DrScramble.RefreshStock then DrScramble.RefreshStock() end
		if DrScramble.StockActive and DrScramble.StockActive() and DrScramble.Stock.Wanted[ScrambleCleanName(cat)] then return true end
		-- END LAB STOCK TARGET
		return FarmConfig.AutoScrambleSteal == true
			and #reqs > 0
			and GetScrambleState().Unlocked == true
			and DrScramble.LabBannerAllowed(GetScrambleState())
			and RuntimeState.ScrambleWanted[ScrambleCleanName(cat)] == true
	end
	function Tasks.IsEggUnsafe(pos, rec)
		if pos.X < SafeBaseLineX + 5 then
			return true
		end
		if rec.AreaId then
			local dangerZones = { Forest = true, Desert = true, Snow = true, Jungle = true, Volcano = true }
			if dangerZones[tostring(rec.AreaId or "")] then
				local guards = Workspace:FindFirstChild("__OBJECTS")
					and Workspace.__OBJECTS:FindFirstChild("Areas")
					and Workspace.__OBJECTS.Areas:FindFirstChild(rec.AreaId)
					and Workspace.__OBJECTS.Areas[rec.AreaId]:FindFirstChild("GuardAreas")
				if guards then
					for _, g in ipairs(guards:GetChildren()) do
						local guard = g:FindFirstChild("Guard") or g:FindFirstChild("ForestGuardAuthored")
						if guard and guard:IsA("Model") then
							local guardPos = guard:GetPivot().Position
							if (guardPos - pos).Magnitude < 120 then
								return true
							end
						end
					end
				end
			end
		end
		local guardAreas = Workspace:FindFirstChild("__OBJECTS")
			and Workspace.__OBJECTS:FindFirstChild("Areas")
			and Workspace.__OBJECTS.Areas:FindFirstChild("GuardAreas")
		if guardAreas then
			for _, area in ipairs(guardAreas:GetChildren()) do
				local guard = area:FindFirstChild("Guard") or area:FindFirstChild("ForestGuardAuthored")
				if guard and guard:IsA("Model") then
					local guardPos = guard:GetPivot().Position
					if (guardPos - pos).Magnitude < 150 then
						return true
					end
				end
			end
		end
		return false
	end
	local function CollectCandidates(includeCarried, normal)
		local raw = CollectRawFieldEggs(normal == true)
		if #raw == 0 then
			return {}
		end
		local root = Engine.Root()
		local playerPos = root and root.Position or Vector3.new(SafeBaseLineX, 70, SafeCorridorZ)
		local now = os.clock()
		local list = {}
		local sData = nil
		pcall(function()
			if SaveModule and type(SaveModule.Peek) == "function" then
				sData = SaveModule.Peek()
			end
		end)
		local indexMap = (sData and type(sData.Index) == "table") and sData.Index or {}
		local indexOn = FarmConfig.Index_PrioritizeMissing == true
		local regularOk = true
		local scrambleMode = FarmConfig.AutoScrambleSteal
		local scrambleReqs = scrambleMode and GetScrambleRequirements() or nil
		local wantedCats = RuntimeState.ScrambleWanted or {}
		if not scrambleMode then
			wantedCats = {}
		end
		for _, rec in ipairs(raw) do
			local uid = tostring(rec.Uid or "")
			if uid == "" then
				continue
			end
			local blockExpiry = Engine.State.BlockList[uid]
			if not normal and blockExpiry and now < blockExpiry then
				continue
			elseif not normal and blockExpiry then
				Engine.State.BlockList[uid] = nil
			end
			if not normal and Engine.Carry.Blocked[uid] then
				continue
			end
			local cf = rec.BoundsCFrame or (rec.PhysicalModel and rec.PhysicalModel:GetPivot())
			if not cf then
				continue
			end
			local pos = cf.Position
			if pos.X <= (SafeBaseLineX + 10) then
				continue
			end
			if scrambleMode or Engine.Carry.SkipUnsafe then
				if Tasks.IsEggUnsafe(pos, rec) then
					continue
				end
			end
			local stLower = string.lower(tostring(rec.State or ""))
			local carried = stLower ~= "" and (stLower:find("carri") or stLower:find("taken"))
			local cat = tostring(rec.AssetCategory or rec.Name or "Egg")
			local zone = Tasks.DetermineZoneFromPosition(rec.AreaId, pos, cat)
			local rarityName, rarityRank = Tasks.ResolveEggRarity(rec)
			local kg = Tasks.GetEggOfficialKg(rec)
			local income = CalculateEggIncome(rec)
			local tier = GetRarityTier(rarityName)
			local scrambleTarget = (not carried or includeCarried == true) and IsScrambleTarget(cat, scrambleReqs)
			local scrambleMissing = scrambleTarget and (wantedCats[ScrambleCleanName(cat)] == true)
			local indexMissing = false
			if indexOn and (not carried or includeCarried == true) and indexMap[cat] ~= true then
				local pass = (next(FarmConfig.Index_SelectedZones) == nil)
					or (FarmConfig.Index_SelectedZones[string.lower(zone)] == true)
				if pass then
					indexMissing = true
				end
			end
			local canSelect = false
			if not carried or includeCarried == true then
				if scrambleMode and scrambleTarget then
					canSelect = MatchZone(zone)
				elseif indexMissing then
					canSelect = true
				elseif regularOk then
					if FarmConfig.StealAllMode or FarmConfig.AutoStealAll then
						canSelect = MatchZone(zone)
					elseif FarmConfig.AutoStealSelected then
						local hasFilter = (next(FarmConfig.SelectedZones) ~= nil)
							or (next(FarmConfig.SelectedEggs) ~= nil)
							or (next(FarmConfig.SelectedRarities) ~= nil)
							or (next(FarmConfig.SelectedMutations) ~= nil)
						if hasFilter then
							canSelect = MatchZone(zone)
								and MatchEggCategory(cat)
								and MatchRarity(rarityName)
								and MatchMutation(rec)
						end
					end
				end
			end
			-- BEGIN WISP CANDIDATE
			local nativeSelected = canSelect
			local wispTarget = (not carried or includeCarried == true) and Tasks.WispNeeds and Tasks.WispNeeds(rec) == true
			if wispTarget then canSelect = true end
			-- END WISP CANDIDATE
			if canSelect and (normal or not Tasks.IsAnotherPlayerNearEgg(pos, 9)) then
				table.insert(list, {
					Uid = uid,
					Category = cat,
					Zone = zone,
					ZoneWeight = AreaWeights[zone] or 100,
					Rarity = rarityName,
					RarityRank = rarityRank,
					RarityTier = tier,
					WeightKg = kg,
					Income = income,
					CFrame = cf,
					Position = pos,
					Distance = (playerPos - pos).Magnitude,
					PhysicalModel = rec.PhysicalModel,
					AreaId = rec.AreaId,
					State = rec.State,
					IsScramble = scrambleTarget,
					IsScrambleMissing = scrambleMissing,
					IsIndex = indexMissing,
					-- BEGIN WISP FLAGS
					IsWisp = wispTarget, WispOnly = wispTarget and not nativeSelected,
					-- END WISP FLAGS
					Raw = rec,
				})
			end
		end
		local prio = Engine.State.Priority
		local RankLab = (Tasks.PriorityRank and Tasks.PriorityRank("StealLab")) or 2
		local RankIndex = (Tasks.PriorityRank and Tasks.PriorityRank("StealIndex")) or 3
		local RankFilter = (Tasks.PriorityRank and Tasks.PriorityRank("StealFilter")) or 4
		table.sort(list, function(a, b)
			local ca = a.IsScramble and RankLab or (a.IsIndex and RankIndex or RankFilter)
			local cb = b.IsScramble and RankLab or (b.IsIndex and RankIndex or RankFilter)
			-- BEGIN WISP SORT
			local rankWisp = Tasks.PriorityRank and Tasks.PriorityRank("Wisp") or 7
			if a.IsWisp then ca = a.WispOnly and rankWisp or math.min(ca, rankWisp) end
			if b.IsWisp then cb = b.WispOnly and rankWisp or math.min(cb, rankWisp) end
			-- END WISP SORT
			if ca ~= cb then
				return ca < cb
			end
			if a.IsScrambleMissing ~= b.IsScrambleMissing then
				return a.IsScrambleMissing
			end
			if prio == "Best Rarity" and a.RarityTier ~= b.RarityTier then
				return a.RarityTier > b.RarityTier
			end
			if prio == "Biggest Weight" and a.WeightKg ~= b.WeightKg then
				return a.WeightKg > b.WeightKg
			end
			if prio == "Best Mutation" then
				local am = (a.Raw and type(a.Raw.Mutations) == "table" and #a.Raw.Mutations) or 0
				local bm = (b.Raw and type(b.Raw.Mutations) == "table" and #b.Raw.Mutations) or 0
				if am ~= bm then
					return am > bm
				end
			end
			if prio == "Highest Value" and math.abs(a.Income - b.Income) > 1 then
				return a.Income > b.Income
			end
			if prio == "Lowest Value" and math.abs(a.Income - b.Income) > 1 then
				return a.Income < b.Income
			end
			if a.RarityTier ~= b.RarityTier then
				return a.RarityTier > b.RarityTier
			end
			if a.ZoneWeight ~= b.ZoneWeight then
				return a.ZoneWeight > b.ZoneWeight
			end
			if math.abs(a.Income - b.Income) > 1 then
				return a.Income > b.Income
			end
			return a.Distance < b.Distance
		end)
		return list
	end
	Engine.CollectCandidates = CollectCandidates
	Engine.CollectRawFieldEggs = CollectRawFieldEggs
	local function RequestCarry(uid)
        if EggStateModule and type(EggStateModule.CarryFieldEgg) == "function" then
            return pcall(EggStateModule.CarryFieldEgg, uid)
        end
        return pcall(function()
            local remote = Remotes.RemoteCarryEgg
            if remote and remote:IsA("RemoteFunction") then
                remote:InvokeServer({ Uid = uid })
            elseif remote then
                remote:FireServer({ Uid = uid })
            end
        end)
    end
	Engine.RequestCarry = RequestCarry
	local function GrabEggAtTarget(eggData, sessionId)
		local root = Engine.Root()
		if not root then
			return false
		end
		local targetPos = eggData.CFrame.Position
		local startClock = os.clock()
		local cancelAt = RuntimeState.StealCancel
		RuntimeState.HoldingEggForGuard = true
		local reactAt = startClock
			+ (tonumber(Engine.Carry.RunWait) or 0)
			+ Engine.React(Engine.Carry.ReactMin, Engine.Carry.ReactMax)
		local deadline = startClock + tonumber(Engine.Carry.GrabBudget)
		local lastPrompt = 0
		local guardWait = 0
		while os.clock() < deadline do
			if not IsStealActive() or RuntimeState.SessionId ~= sessionId then
				break
			end
			if RuntimeState.StealCancel ~= cancelAt then
				break
			end
			root = Engine.Root()
			if not root or not root.Parent then
				break
			end
			if Engine.Guard.Busy then
				if guardWait < (tonumber(Engine.Carry.GrabBudget) or 6) * 2 then
					local waitStart = os.clock()
					RunService.Heartbeat:Wait()
					local spent = os.clock() - waitStart
					guardWait = guardWait + spent
					deadline = deadline + spent
					continue
				end
			end
			if Engine.State.Carrying and Engine.State.CarryUid and Engine.State.CarryUid ~= eggData.Uid then
				Engine.WrongEgg(eggData.Uid)
			end
			local holdSettled = (os.clock() - startClock) > Engine.Carry.HandSettle
			if holdSettled and Engine.State.Carrying and Engine.State.CarryUid == eggData.Uid then
				RuntimeState.HoldingEggForGuard = false
				return true
			end
			if Engine.Carry.WaitGuard and os.clock() > reactAt then
				local guard = Engine.FindGuard(eggData.AreaId)
				if guard and guard:GetAttribute("GuardState") ~= "Sleeping" then
					RunService.Heartbeat:Wait()
					if os.clock() > reactAt + Engine.Carry.GuardSleepWait then
						reactAt = 0
					end
					continue
				end
			end
			if os.clock() >= reactAt and os.clock() - lastPrompt > Engine.Carry.GrabInterval then
				lastPrompt = os.clock()
				local prompt = Engine.FindCarryPrompt(eggData.Uid, targetPos, Engine.Carry.PromptRange)
				if prompt then
					Engine.FirePrompt(prompt)
				end
				RequestCarry(eggData.Uid)
			end
			pcall(function()
				root.CFrame = CFrame.new(targetPos + Vector3.new(0, Engine.Carry.GrabLift, 0)) * root.CFrame.Rotation
			end)
			RunService.Heartbeat:Wait()
		end
		RuntimeState.HoldingEggForGuard = false
		local got = Engine.State.Carrying and Engine.State.CarryUid == eggData.Uid
		if not got then
			got = IsActivelyCarryingEgg(eggData.Uid)
		end
		if got then
			Engine.State.Carrying = true
			Engine.State.CarryUid = eggData.Uid
			Engine.State.CarryAreaId = eggData.AreaId or Engine.State.CarryAreaId
			Engine.State.GrabFails = 0
		else
			Engine.State.GrabFails = (Engine.State.GrabFails or 0) + 1
		end
		return got and true or false
	end
	Engine.GrabEggAtTarget = GrabEggAtTarget
	local function SoftResetCarryState()
		pcall(function()
			if EggStateModule and type(EggStateModule.DropFieldEgg) == "function" then
				EggStateModule.DropFieldEgg("PlayerRequest")
			end
		end)
		pcall(function()
			Engine.StopHold()
		end)
		Engine.State.Carrying = false
		Engine.State.CarryUid = nil
	end
	local function RespawnRecover()
		local Character = LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if not Character or not Humanoid then
			return false
		end
		for _ = 1, 2 do
			pcall(function()
				Humanoid:UnequipTools()
			end)
		end
		if type(replicatesignal) == "function" then
			for _ = 1, 2 do
				pcall(replicatesignal, Humanoid.ServerBreakJoints)
			end
		end
		pcall(function()
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			Humanoid.BreakJointsOnDeath = true
			Humanoid.RequiresNeck = true
			Humanoid.Health = 0
		end)
		pcall(function()
			Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
		end)
		pcall(function()
			Character:BreakJoints()
		end)
		local Deadline = os.clock() + 30
		while os.clock() < Deadline do
			local NewChar = LocalPlayer.Character
			local NewHum = NewChar and NewChar:FindFirstChildOfClass("Humanoid")
			if
				NewChar
				and NewChar ~= Character
				and NewHum
				and NewHum.Health > 0
				and NewChar:FindFirstChild("HumanoidRootPart")
			then
				break
			end
			RunService.Heartbeat:Wait()
		end
		task.wait(0.5)
		return true
	end
	Engine.SoftResetCarryState = SoftResetCarryState
	Engine.RespawnRecover = RespawnRecover
	Engine.SuspendGameMovement = function()
		local saved = {}
		if type(getconnections) ~= "function" then
			return saved
		end
		if type(debug) ~= "table" or type(debug.info) ~= "function" then
			return saved
		end
		pcall(function()
			for _, signal in ipairs({ RunService.Heartbeat, RunService.PreSimulation, RunService.PostSimulation }) do
				for _, conn in ipairs(getconnections(signal)) do
					local ok, fn = pcall(function()
						return conn.Function
					end)
					if ok and type(fn) == "function" then
						local ok2, src = pcall(debug.info, fn, "s")
						if ok2 and type(src) == "string" and string.find(src, "UGI", 1, true) then
							local ok3, enabled = pcall(function()
								return conn.Enabled
							end)
							if not ok3 or enabled ~= false then
								if pcall(function()
									conn:Disable()
								end) then
									table.insert(saved, conn)
								end
							end
						end
					end
				end
			end
		end)
		return saved
	end
	Engine.RestoreGameMovement = function(saved)
		for _, conn in ipairs(saved or {}) do
			pcall(function()
				conn:Enable()
			end)
		end
		if type(saved) == "table" then
			table.clear(saved)
		end
	end
	Engine.FindDroppedEgg = function(uid)
		if type(uid) ~= "string" then
			return nil, nil
		end
		local model = Workspace:FindFirstChild(uid)
		if not model then
			local slots = Workspace:FindFirstChild("AreaEggSlotsClient")
			model = slots and slots:FindFirstChild(uid)
		end
		if model then
			local ok, pos = pcall(function()
				return model:GetPivot().Position
			end)
			if ok and typeof(pos) == "Vector3" then
				return pos, "Model"
			end
		end
		if Remotes.RemoteEggSnapshot and Remotes.RemoteEggSnapshot:IsA("RemoteFunction") then
			local ok, result = pcall(function()
				return Remotes.RemoteEggSnapshot:InvokeServer()
			end)
			local records = ok and type(result) == "table" and result.Records or nil
			if type(records) == "table" then
				for _, rec in pairs(records) do
					if type(rec) == "table" and rec.Uid == uid then
						local cf = rec.BottomCFrame or rec.BoundsCFrame or rec.CFrame
						if typeof(cf) == "CFrame" then
							return cf.Position, rec.State or "Snapshot"
						end
						return nil, rec.State or "Unknown"
					end
				end
			end
		end
		for _, rec in ipairs(Engine.CollectAllFieldEggs()) do
			if rec.Uid == uid then
				return rec.Position, rec.State or "Field"
			end
		end
		return nil, nil
	end
	Engine.PickupDroppedEgg = function(uid)
		if type(uid) ~= "string" then
			return
		end
		RequestCarry(uid)
		local root = Engine.Root()
		if root then
			local pos = root.Position
			local prompt = Engine.FindCarryPrompt(uid, pos, Engine.Carry.PromptRange or 14)
			if prompt then
				pcall(Engine.FirePrompt, prompt)
			end
		end
	end
	function Tasks.LineWalkCore(sessionId, target, speed, timeout, doneFn)
		local spent = 0
		local carry = Engine.Carry
		local midDrops = carry.MidDrops or { 0.33, 0.66 }
		local backRunRatio = carry.BackRunRatio or 15
		local backRunMax = carry.BackRunMax or 2000
		local quickRegrab = math.max(tonumber(carry.QuickRegrab) or 0.08, 0.05)
		local nextQuickRegrabAt = 0
		local lagGrace = carry.LagGrace or 4
		local lockCamera = carry.LockCamera or false
		local runStyle = carry.RunStyle or "Velocity"
		local carryStyle = carry.CarryStyle or "Velocity"
		local carryReact = carry.CarryReact or 0
		local function BackRun()
			local root = Engine.Root()
			if not root then
				return
			end
			local sepX = Engine.GetSeparationX()
			local distToLine = math.abs(root.Position.X - sepX)
			if distToLine < carry.LineGap * 2 and ((root.Position.X < sepX) ~= (target.X < sepX)) then
				local backDist = math.min(carry.BackRunMax or 2000, (carry.BackRunRatio or 15) * carry.LineGap)
				local backPos = root.Position
					+ Vector3.new((root.Position.X > Engine.GetSeparationX() and -1 or 1) * backDist, 0, 0)
				Engine.RunPace(backPos, {
					Session = sessionId,
					Speed = Engine.CrossPace(),
					Height = 0,
					GroundY = Engine.Root().Position.Y,
					IsCarry = true,
					StopDist = carry.LineGap,
					Timeout = 5,
				})
			end
		end
		local spent = 0
		while spent < timeout and not Engine.Cancelled(sessionId) do
			local root = Engine.Root()
			if not root then
				return false
			end
			if Engine.Cancelled(sessionId) then
				return false
			end
			if doneFn and doneFn() then
				return true
			end
			if not Engine.State.Carrying and Engine.State.CarryUid and os.clock() >= nextQuickRegrabAt then
				Engine.PickupDroppedEgg(Engine.State.CarryUid)
				nextQuickRegrabAt = os.clock() + quickRegrab
			end
			if carry.LockCamera and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()) then
				local cam = workspace.CurrentCamera
				if cam then
					pcall(function()
						cam.CameraType = Enum.CameraType.Scriptable
						cam.CFrame = CFrame.new(Engine.Root().Position + Vector3.new(0, 20, 20), Engine.Root().Position)
					end)
				end
			end
			if doneFn and doneFn() then
				return true
			end
			local root = Engine.Root()
			if not root then
				return false
			end
			if (carry.BackRunRatio or 0) > 0 then
				local sepX = Engine.GetSeparationX()
				local distToLine = math.abs(root.Position.X - sepX)
				if distToLine < carry.LineGap * 2 and ((root.Position.X < sepX) ~= (target.X < sepX)) then
					local backDist = math.min(carry.BackRunMax or 2000, (carry.BackRunRatio or 15) * carry.LineGap)
					local backPos = root.Position
						+ Vector3.new((root.Position.X > Engine.GetSeparationX() and -1 or 1) * backDist, 0, 0)
					Engine.RunPace(backPos, {
						Session = sessionId,
						Speed = Engine.CrossPace(),
						Height = 0,
						GroundY = Engine.Root().Position.Y,
						IsCarry = true,
						StopDist = carry.LineGap,
						Timeout = 5,
					})
				end
			end
			if doneFn and doneFn() then
				return true
			end
			local root = Engine.Root()
			if not root then
				return false
			end
			local lagGrace = carry.LagGrace or 4
			local lagThreshold = lagGrace * 0.05
			local delta = Vector3.new(target.X - root.Position.X, 0, target.Z - root.Position.Z)
			local arrivalRadius = math.max(tonumber(carry.ArrivePad) or 2.5, 1.5)
			if delta.Magnitude <= arrivalRadius then
				return true
			end
			local carryReact = carry.CarryReact or 0
			local step = delta.Unit * math.min(speed, delta.Magnitude / 0.05)
			if (carry.CarryReact or 0) > 0 then
				step = step * (1 + (carry.CarryReact or 0) * 0.1)
			end
			pcall(function()
				if carry.RunStyle == "CFrame" then
					pcall(function()
						local r = Engine.Root()
						if r then
							r.CFrame = CFrame.new(r.Position + step) * r.CFrame.Rotation
							r.AssemblyLinearVelocity = Vector3.new(step.X, r.AssemblyLinearVelocity.Y, step.Z)
						end
					end)
				else
					pcall(function()
						root.AssemblyLinearVelocity = Vector3.new(step.X, root.AssemblyLinearVelocity.Y, step.Z)
					end)
				end
			end)
			spent = spent + RunService.Heartbeat:Wait()
		end
		return false
	end
	local function LineWalk(sessionId, target, speed, timeout, doneFn)
		local ok, res = pcall(Tasks.LineWalkCore, sessionId, target, speed, timeout, doneFn)
		Engine.StopVelocity()
		return ok and res == true
	end
	Engine.LineDropHome = function(sessionId)
		local carry = Engine.Carry
		local function PingNow()
			local ok, res = pcall(function()
				return LocalPlayer:GetNetworkPing()
			end)
			ok = ok and tonumber(res) or nil
			return ok and math.clamp(ok, 0, 2) or 0.2
		end
		local home = Engine.GetBaseSafeSpot()
		local carryUid = Engine.State.CarryUid
		local root = Engine.Root()
		if type(carryUid) ~= "string" or not home or not root then
			return false
		end
		local sepX = Engine.GetSeparationX()
		local sepPart = Workspace:FindFirstChild("World", true)
			and Workspace:FindFirstChild("World", true):FindFirstChild("Areas")
			and Workspace:FindFirstChild("World", true):FindFirstChild("Areas"):FindFirstChild("SeparationLine")
		local lineX = (sepPart and sepPart:IsA("BasePart")) and sepPart.Position.X or carry.LineX
		local lineY = (sepPart and sepPart:IsA("BasePart")) and sepPart.Position.Y or carry.LineY
		local z = math.clamp(root.Position.Z, carry.ZClampMin, carry.ZClampMax)
		local lineSpot = Vector3.new(lineX + carry.LineGap, lineY + carry.LineLift, z)
		local suspended = Engine.SuspendGameMovement()
		local relocated = false
		local relocateConn = nil
		pcall(function()
			local packages = ReplicatedStorage:FindFirstChild("Packages")
			local networking = packages and packages:FindFirstChild("Networking")
			local refresh = networking and networking:FindFirstChild("RE/RigSync/Refresh")
			if refresh and refresh:IsA("RemoteEvent") then
				relocateConn = refresh.OnClientEvent:Connect(function(payload)
					if type(payload) == "table" and payload.Action == "Relocate" then
						relocated = true
					end
				end)
			end
		end)
		local cam = workspace.CurrentCamera
		local camSaved = nil
		local function FreezeCam()
			if not carry.LockCamera or (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()) or camSaved or not cam then
				return
			end
			camSaved = { Type = cam.CameraType, CFrame = cam.CFrame }
			pcall(function()
				cam.CameraType = Enum.CameraType.Scriptable
				cam.CFrame = camSaved.CFrame
			end)
		end
		local function UnfreezeCam()
			if not camSaved or not cam then
				return
			end
			local s = camSaved
			camSaved = nil
			pcall(function()
				cam.CameraType = s.Type
			end)
		end
		local function FullRestore()
			UnfreezeCam()
			if relocateConn then
				pcall(function()
					relocateConn:Disconnect()
				end)
				relocateConn = nil
			end
			Engine.RestoreGameMovement(suspended)
		end
		local function SnapToLine()
			local r = Engine.Root()
			if not r then
				return
			end
			pcall(function()
				r.CFrame = CFrame.new(lineSpot) * CFrame.Angles(0, math.pi / 2, 0)
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		local function LineDropEgg()
			Engine.State.HeldSeenAt = 0
			if EggStateModule and EggStateModule.DropFieldEgg then
				pcall(EggStateModule.DropFieldEgg, "PlayerRequest")
			end
		end
		local function WaitForLineDropRelease(timeout)
			local deadline = os.clock() + (timeout or math.clamp(1 + PingNow() * 2, 0.55, 3))
			while
				(Engine.State.SignalCarrying or Engine.State.WeldCarrying)
				and os.clock() < deadline
				and IsStealActive()
			do
				RunService.Heartbeat:Wait()
			end
			if not Engine.State.SignalCarrying and not Engine.State.WeldCarrying then
				Engine.State.Carrying = false
				Engine.State.LastFinishedAt = os.clock()
				return true
			end
			return false
		end
		local function RegrabBudget()
			return math.clamp(4 + PingNow() * 4, 4, 10)
		end
		local function RegrabDroppedEgg(expectedUid, blokAt)
			local deadEnd = os.clock() + (blokAt or RegrabBudget())
			local lastRelocate = 0
			local lostSince = nil
			while
				not (Engine.State.Carrying and Engine.State.CarryUid == expectedUid)
				and os.clock() < deadEnd
				and IsStealActive()
			do
				Engine.PickupDroppedEgg(expectedUid)
				local now = os.clock()
				if now - lastRelocate > 0.35 then
					lastRelocate = now
					local pos, state = Engine.FindDroppedEgg(expectedUid)
					if state == "Slot" then
						return false
					end
					if pos then
						lostSince = nil
						local r = Engine.Root()
						if r then
							local v = Vector3.new(pos.X - r.Position.X, 0, pos.Z - r.Position.Z)
							if v.Magnitude > 2.5 then
								LineWalk(sessionId, pos + Vector3.new(0, 3, 0), Engine.PickupPace(), 2.5, function()
									return Engine.State.Carrying and Engine.State.CarryUid == expectedUid
								end)
							end
						end
					else
						lostSince = lostSince or now
						if now - lostSince > 3 then
							return false
						end
					end
				end
				RunService.Heartbeat:Wait()
			end
			local held, _ = Engine.ConfirmHeldEgg(expectedUid, RuntimeState.SessionId)
			if not (Engine.State.Carrying and Engine.State.CarryUid == expectedUid) and held then
				Engine.State.Carrying = true
				Engine.State.CarryUid = expectedUid
			end
			return Engine.State.Carrying and Engine.State.CarryUid == expectedUid
		end
		local ok, result = pcall(function()
			Engine.StopHold()
			Engine.StopVelocity()
			FreezeCam()
			if carry.Hops and Engine.State.Carrying then
				local r = Engine.Root()
				if r then
					local hopSpeed = math.max(Engine.Pace() * carry.HopRatio, 40)
					local lift = r.Position.Y + carry.HopLift
					local curX = r.Position.X
					local midXs = {}
					for _, frac in ipairs(carry.MidDrops or {}) do
						table.insert(midXs, curX - (curX - lineSpot.X) * frac)
					end
					local midIdx = 1
					while curX - hopSpeed > lineSpot.X do
						if not Engine.State.Carrying then
							local uidNow = Engine.State.CarryUid or carryUid
							if not RegrabDroppedEgg(uidNow, RegrabBudget()) then
								break
							end
							local hr = Engine.Root()
							if hr then
								curX = hr.Position.X
							end
						end
						curX = curX - hopSpeed
						local t = 0
						while t < carry.HopGap do
							local h = Engine.Root()
							if h then
								pcall(function()
									h.CFrame = CFrame.new(curX, lift, z) * CFrame.Angles(0, math.pi / 2, 0)
									h.AssemblyLinearVelocity = Vector3.zero
									h.AssemblyAngularVelocity = Vector3.zero
								end)
							end
							t = t + RunService.Heartbeat:Wait()
						end
						local mx = midXs[midIdx]
						if mx and curX <= mx and Engine.State.Carrying then
							midIdx = midIdx + 1
							local hr = Engine.Root()
							if hr then
								pcall(function()
									hr.CFrame = CFrame.new(curX, lineSpot.Y, z) * CFrame.Angles(0, math.pi / 2, 0)
									hr.AssemblyLinearVelocity = Vector3.zero
									hr.AssemblyAngularVelocity = Vector3.zero
								end)
							end
							local pre = os.clock()
							while Engine.State.Carrying and os.clock() - pre < (carry.DropDelay or 0.19) + PingNow() do
								RunService.Heartbeat:Wait()
							end
							LineDropEgg()
							WaitForLineDropRelease()
							if not Engine.State.Carrying and Engine.State.CarryUid then
								local uidNow = Engine.State.CarryUid
								if not RegrabDroppedEgg(uidNow, RegrabBudget()) then
									FullRestore()
									return false
								end
							end
							local nr = Engine.Root()
							if nr then
								curX = nr.Position.X
							end
						end
					end
				end
			end
			SnapToLine()
			if carry.Hops and Engine.State.Carrying then
				local t = 0
				while t < carry.DropDelay + PingNow() and Engine.State.Carrying do
					t = t + RunService.Heartbeat:Wait()
				end
				if Engine.State.Carrying then
					LineDropEgg()
					WaitForLineDropRelease()
				end
			end
			UnfreezeCam()
			if carry.ShakeTime > 0 then
				local inside = Vector3.new(lineX - carry.ShakeInside, lineSpot.Y, z)
				local flip = false
				local t = 0
				while t < carry.ShakeTime and Engine.State.Carrying do
					flip = not flip
					local r = Engine.Root()
					if r then
						pcall(function()
							r.CFrame = CFrame.new(flip and inside or lineSpot) * CFrame.Angles(0, math.pi / 2, 0)
							r.AssemblyLinearVelocity = Vector3.zero
						end)
					end
					t = t + RunService.Heartbeat:Wait()
				end
				SnapToLine()
			end
			local pace = Engine.Pace()
			local carrySpeed = math.max(pace * carry.CarryRatio * (tonumber(carry.Mult) or carry.LightMult), 1)
			local r0 = Engine.Root()
			local magnitude = r0 and Vector3.new(r0.Position.X - lineX, 0, r0.Position.Z - z).Magnitude or 0
			local crossNeed = math.max(0, (magnitude - carry.DirectBudget) / carrySpeed) + carry.DirectMargin
			if carry.CrossNow then
				crossNeed = carry.DirectMargin
			end
			local canCrossNow = crossNeed < carry.LineWait
			local waited = 0
			local resnaps = 0
			while true do
				local go = Engine.State.Carrying and waited < carry.LineWait
				if go then
					go = not (canCrossNow and waited >= crossNeed)
				end
				if not go then
					break
				end
				if relocated and carry.ReJump and resnaps < carry.ReJumpMax and not Engine.IsRagdolled() then
					relocated = false
					resnaps = resnaps + 1
					SnapToLine()
				end
				waited = waited + RunService.Heartbeat:Wait()
			end
			local startClock = os.clock()
			local function Delivered()
				return Engine.State.LastDelivered >= startClock
			end
			if Engine.State.Carrying and canCrossNow and waited >= crossNeed then
				LineWalk(sessionId, home, Engine.CrossPace() * carry.CrossRatio, 6, function()
					return Delivered() or not Engine.State.Carrying
				end)
				if carry.MidRest and carry.MidRest > 0 then
					task.wait(carry.MidRest)
				end
				local t = 0
				while t < 0.25 and not Delivered() and Engine.State.Carrying do
					t = t + RunService.Heartbeat:Wait()
				end
				if Delivered() then
					FullRestore()
					return true
				end
			end
			if Engine.State.Carrying then
				FullRestore()
				local innerX = math.min(home.X - 8, sepX - 8)
				local innerHome = Vector3.new(innerX, home.Y, home.Z)
				local rootNow = Engine.Root()
				if
					rootNow
					and (Vector3.new(rootNow.Position.X, 0, rootNow.Position.Z) - Vector3.new(
							innerHome.X,
							0,
							innerHome.Z
						)).Magnitude
						> 1.5
				then
					Engine.RunPace(innerHome, {
						Session = sessionId,
						Speed = math.max(Engine.CrossPace() * (carry.CrossRatio or 1), Engine.Pace() * 2),
						Height = 0,
						GroundY = innerHome.Y,
						IsCarry = true,
						StopDist = 1.5,
						Timeout = 3,
					})
				end
				local settleAt = os.clock()
				while
					os.clock() - settleAt < 0.35
					and not Delivered()
					and Engine.State.LastFailed < settleAt
					and Engine.State.Carrying
				do
					RunService.Heartbeat:Wait()
				end
				if Delivered() then
					return true
				end
				if Engine.State.Carrying then
					carry.LastSkip = { Reason = "Line Drop: entered save area, egg still carried; kept it held" }
					return false
				end
			end
			if carry.GetUp then
				task.spawn(function()
					local t = 0
					while t < 1.5 do
						local char = LocalPlayer.Character
						local hum = char and char:FindFirstChildOfClass("Humanoid")
						if hum then
							pcall(function()
								hum.PlatformStand = false
								local st = hum:GetState()
								if
									st == Enum.HumanoidStateType.Physics
									or st == Enum.HumanoidStateType.Ragdoll
									or st == Enum.HumanoidStateType.FallingDown
								then
									hum:ChangeState(Enum.HumanoidStateType.GettingUp)
								end
							end)
						end
						t = t + RunService.Heartbeat:Wait()
					end
				end)
			end
			local t = 0
			while not carry.SnapPickup and not carry.GetUp and Engine.IsRagdolled() and t < 6 do
				t = t + RunService.Heartbeat:Wait()
			end
			local tries = 0
			while tries < carry.PickupTries do
				tries = tries + 1
				local pos, state = Engine.FindDroppedEgg(carryUid)
				if state == "Slot" then
					FullRestore()
					carry.LastSkip = { Reason = "Line Drop: the egg went back to its nest" }
					return false
				end
				if not pos then
					FullRestore()
					carry.LastSkip = { Reason = "Line Drop: the egg is gone" }
					return false
				end
				if carry.SnapPickup then
					local r = Engine.Root()
					if r then
						pcall(function()
							r.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) * CFrame.Angles(0, math.pi / 2, 0)
							r.AssemblyLinearVelocity = Vector3.zero
						end)
					end
				else
					LineWalk(sessionId, pos, Engine.PickupPace(), 5)
				end
				local budget = carry.SnapPickup and 5 or 2.5
				local t2 = 0
				while not Engine.State.Carrying and t2 < budget do
					Engine.PickupDroppedEgg(carryUid)
					if carry.SnapPickup then
						local r = Engine.Root()
						if r and Vector3.new(r.Position.X - pos.X, 0, r.Position.Z - pos.Z).Magnitude > 6 then
							pcall(function()
								r.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) * CFrame.Angles(0, math.pi / 2, 0)
							end)
						end
					end
					t2 = t2 + RunService.Heartbeat:Wait()
				end
				local held, _ = Engine.ConfirmHeldEgg(carryUid, sessionId)
				if held then
					break
				end
			end
			if not Engine.State.Carrying then
				FullRestore()
				carry.LastSkip = { Reason = "Line Drop: could not pick the egg up again" }
				return false
			end
			if Engine.State.CarryUid ~= carryUid then
				Engine.DropAndWait(sessionId)
				FullRestore()
				carry.LastSkip = { Reason = "Line Drop: repickup grabbed the wrong egg, dropping it" }
				return false
			end
			local rEnd = Engine.Root()
			if rEnd and rEnd.Position.X - lineX > carry.FarFromLine then
				FullRestore()
				carry.LastSkip = { Reason = "Line Drop: egg ended up far from the line, carrying it home safely" }
				return Engine.DeliverEggToBaseSafe(sessionId)
			end
			if not Engine.State.Carrying and Engine.State.CarryUid then
				Engine.PickupDroppedEgg(Engine.State.CarryUid)
			end
			LineWalk(sessionId, home, Engine.CrossPace() * carry.CrossRatio, 6, function()
				return Delivered() or not Engine.State.Carrying
			end)
			local r2 = Engine.Root()
			if r2 then
				pcall(function()
					r2.AssemblyLinearVelocity = Vector3.new(0, r2.AssemblyLinearVelocity.Y, 0)
				end)
			end
			local t3 = 0
			while t3 < 2 and not Delivered() and Engine.State.Carrying do
				t3 = t3 + RunService.Heartbeat:Wait()
			end
			FullRestore()
			return Delivered()
		end)
		if not ok then
			pcall(function()
				Engine.RestoreGameMovement(suspended)
			end)
			carry.LastSkip = { Reason = "Line Drop failed: " .. tostring(result) }
			return false
		end
		return result == true
	end
	-- Persistent normal-mode swap uses N3's existing character/control helpers.
	-- Sena health preparation is scoped here; it is not an Anti Guard toggle.
	do
		local disposed, characterConnection, heartbeat = false, nil, nil
		local healthHumanoid, healthSaved, healthConnection, healing, elapsed = nil, nil, nil, false, 0
		Engine.AutoShieldWanted = function()
			return not disposed
				and not FarmConfig.Defense_InstantSteal
				and (FarmConfig.AutoStealEnabled or FarmConfig.AutoStealAll or FarmConfig.AutoStealSelected) == true
		end
		Engine.AutoShieldReady = function()
			local character = LocalPlayer.Character
			local clone, original = RuntimeState.SwapClone, RuntimeState.OriginalHumanoid
			return character ~= nil
				and clone ~= nil
				and clone.Parent == character
				and original ~= nil
				and original.Parent == nil
				and character:FindFirstChildOfClass("Humanoid") == clone
		end
		local function ReleaseHealth()
			if healthConnection then
				healthConnection:Disconnect()
				healthConnection = nil
			end
			if healthHumanoid and healthHumanoid.Parent and healthSaved then
				pcall(function()
					healthHumanoid.BreakJointsOnDeath = healthSaved.BreakJointsOnDeath
					healthHumanoid.RequiresNeck = healthSaved.RequiresNeck
					for state, enabled in pairs(healthSaved.States) do
						healthHumanoid:SetStateEnabled(state, enabled)
					end
				end)
			end
			healthHumanoid, healthSaved = nil, nil
		end
		local function MaintainHealth()
			if not Engine.AutoShieldWanted() then
				ReleaseHealth()
				return
			end
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return
			end
			if healthHumanoid ~= humanoid then
				ReleaseHealth()
				healthHumanoid = humanoid
				healthSaved =
					{ BreakJointsOnDeath = humanoid.BreakJointsOnDeath, RequiresNeck = humanoid.RequiresNeck, States = {} }
				for _, state in ipairs({
					Enum.HumanoidStateType.Dead,
					Enum.HumanoidStateType.FallingDown,
					Enum.HumanoidStateType.Ragdoll,
				}) do
					healthSaved.States[state] = humanoid:GetStateEnabled(state)
					humanoid:SetStateEnabled(state, false)
				end
				humanoid.BreakJointsOnDeath, humanoid.RequiresNeck = false, false
				healthConnection = humanoid.HealthChanged:Connect(function()
					if humanoid.Health <= 0 and not healing and Engine.AutoShieldWanted() then
						healing = true
						pcall(function()
							humanoid.Health = math.max(humanoid.MaxHealth, 100)
						end)
						healing = false
					end
				end)
			end
			if humanoid.Health <= 0 and not healing then
				healing = true
				pcall(function()
					humanoid.Health = math.max(humanoid.MaxHealth, 100)
				end)
				healing = false
			end
			if humanoid:GetState() == Enum.HumanoidStateType.Dead then
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
		end
		Engine.ReleaseAutoShield = function(restore)
			ReleaseHealth()
			if restore and Engine.AutoShieldReady() then
				RestoreCharacter()
			end
		end
		Engine.MaintainAutoShield = function()
			if not Engine.AutoShieldWanted() then
				return false
			end
			if LocalPlayer:GetAttribute("InScrambleArena") == true then
				return false
			end
			local root = Engine.Root()
			if root and root.Position.Y < -200 then
				return false
			end
			-- Apply the health keeper to the N3 clone, not the detached original.
			if not Engine.AutoShieldReady() then
				PerformHumanoidSwap()
			end
			if not Engine.AutoShieldReady() then
				return false
			end
			MaintainHealth()
			return Engine.AutoShieldReady()
		end
		heartbeat = RunService.Heartbeat:Connect(function(dt)
			elapsed = elapsed + dt
			if not Engine.AutoShieldWanted() then
				if healthHumanoid then
					Engine.ReleaseAutoShield(not FarmConfig.Defense_InstantSteal)
				end
				return
			end
			if elapsed < 0.1 then
				return
			end
			elapsed = 0
			local ok, failure = pcall(Engine.MaintainAutoShield)
			if not ok then
				warn("[N3 HUB] Normal character preparation: " .. tostring(failure))
			end
		end)
		characterConnection = LocalPlayer.CharacterAdded:Connect(function()
			ReleaseHealth()
			Engine.AutoCarry.Carrying, Engine.AutoCarry.CarryUid, Engine.AutoCarry.CarryAreaId = false, nil, nil
			if Engine.CancelAutoSteal then
				Engine.CancelAutoSteal()
			end
		end)
		pcall(function()
			LibraryLoader:OnUnload(function()
				disposed = true
				heartbeat:Disconnect()
				characterConnection:Disconnect()
				if Engine.CancelAutoSteal then
					Engine.CancelAutoSteal()
				end
				Engine.ReleaseAutoShield(not FarmConfig.Defense_InstantSteal)
			end)
		end)
	end
	Engine.AutoTrace = {}
	Engine.RecordAutoTrace = function(event, uid)
		if not Engine.AutoCycle then
			return
		end
		local root = Engine.Root()
		local state = Engine.AutoCarry
		local row = string.format(
			"%.3f %s uid=%s carry=%s/%s pos=%s velocity=%s guard=%s/%s shield=%s",
			os.clock(),
			event,
			tostring(uid),
			tostring(state.Carrying),
			tostring(state.CarryUid),
			tostring(root and root.Position),
			tostring(root and root.AssemblyLinearVelocity),
			tostring(Engine.Guard.Enabled),
			tostring(Engine.Guard.Busy),
			tostring(Engine.AutoShieldReady())
		)
		local trace = Engine.AutoTrace
		if #trace >= 16 then
			table.remove(trace, 1)
		end
		trace[#trace + 1] = row
	end
	Engine.PrintAutoTrace = function()
		if FarmConfig.Defense_InstantSteal or #Engine.AutoTrace == 0 then
			return
		end
		warn(
			"[N3 HUB] Server reported delivery failed. Actual recent normal-steal events:\n"
				.. table.concat(Engine.AutoTrace, "\n")
		)
	end
	-- Normal Auto Steal: SenaV2 Fly lifecycle, with N3's egg approach.
	-- Reference: Games/Source/StealAnEgg/SenaV2.lua (t46); see docs/auto-steal.md.
	do
		local disposed, workerRunning, generation = false, false, 0
		local connections, records, skippedEggs, carryTimeouts = {}, {}, {}, {}
		local retryUid, resetBlocked, gateOpenAt = nil, false, 0
		local nextTick, wakePending = 0, true
		local safePosition = Vector3.new(544.76, 71.5, -416.48)
		local deliveryDrop = CFrame.new(616.749, 71.667, -395.585)
		local areaEggStates, slotIdentity, ragdollJoints, guardChasePolicy
		pcall(function()
			areaEggStates = require(ReplicatedStorage.Shared.Types.AreaEggs).States
		end)
		pcall(function()
			slotIdentity = require(ReplicatedStorage.Shared.Util.AreaEggSlotIdentity)
		end)
		pcall(function()
			ragdollJoints = require(ReplicatedStorage.Shared.Modules.RagdollJoints)
		end)
		pcall(function()
			guardChasePolicy = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardChasePolicy)
		end)
		local states = areaEggStates or { Slot = "Slot", Dropped = "Dropped", Carried = "Carried", Claimed = "Claimed" }
		local statsService = game:GetService("Stats")
		local treadmill = {
			Snapshot = FindRemote("RF/Treadmill/AskRenderSnapshot", "AskRenderSnapshot"),
			Wear = FindRemote("RF/Treadmill/AskWearStill", "AskWearStill"),
			Doff = FindRemote("RF/Treadmill/AskDoff", "AskDoff"),
		}
		Engine.AutoStatus, Engine.AutoTargetText = "Idle", "None"
		Engine.AutoSpeed = function()
			return math.clamp(tonumber(FarmConfig.AutoTweenSpeed) or 400, 100, 1000)
		end
		local function Enabled()
			return not disposed and not FarmConfig.Defense_InstantSteal and IsStealActive() == true
		end
		local function Connect(signal, callback)
			if signal and type(signal.Connect) == "function" then
				connections[#connections + 1] = signal:Connect(callback)
			end
		end
		local function ReadEgg(uid)
			if EggStateModule and type(EggStateModule.ReadFieldEgg) == "function" then
				-- A nil live read must not be replaced with an old carried record.
				return EggStateModule.ReadFieldEgg(uid)
			end
			return records[uid]
		end
		local function Available(record)
			return type(record) == "table" and (record.State == states.Slot or record.State == states.Dropped)
		end
		local function CarriedByMe(uid)
			local record = ReadEgg(uid)
			return record ~= nil and record.State == states.Carried and record.CarrierUserId == LocalPlayer.UserId
		end
		local function BankRecordGone(uid)
			local record = ReadEgg(uid)
			return record == nil or record.State == states.Claimed
		end
		local function ReplaceSnapshot(snapshot)
			table.clear(records)
			for key, record in pairs(type(snapshot) == "table" and (snapshot.Records or snapshot) or {}) do
				if type(record) == "table" then
					records[record.Uid or key] = record
				end
			end
			wakePending = true
		end
		if EggStateModule and EggStateModule.ReadFieldEggs then
			local ok, snapshot = pcall(EggStateModule.ReadFieldEggs)
			if ok then
				ReplaceSnapshot(snapshot)
			end
		end
		local function Current(cycle)
			return Enabled()
				and Engine.AutoCycle == cycle
				and generation == cycle.Generation
				and RuntimeState.SessionId == cycle.Session
				and RuntimeState.StealCancel == cycle.Cancel
				and LocalPlayer.Character == cycle.Character
				and cycle.Root.Parent == cycle.Character
				and (not cycle.ReturnDeadline or os.clock() < cycle.ReturnDeadline)
		end
		local function WallOpen()
			if resetBlocked or os.clock() < gateOpenAt or Engine.WallSealed() or Engine.IsNight() then
				return false
			end
			local world = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
			local areas = world and world:FindFirstChild("Areas")
			local wall = areas and areas:FindFirstChild("WallStartCollision")
			return not (wall and wall:IsA("BasePart") and wall.CanCollide)
		end
		local function SetStatus(cycle, text)
			if not cycle or Engine.AutoCycle == cycle then
				Engine.AutoStatus = text
			end
		end
		local function FeetOffset(cycle)
			local humanoid, root = cycle.Humanoid, cycle.Root
			return root.Size.Y * 0.5
				+ (humanoid.RigType == Enum.HumanoidRigType.R15 and math.max(humanoid.HipHeight, 0.5) or 2)
		end
		local function EggDestination(cycle, record)
			local bottom = record and (record.BottomCFrame or record.BoundsCFrame)
			return typeof(bottom) == "CFrame" and CFrame.new(bottom.Position + Vector3.new(0, FeetOffset(cycle) + 0.15, 0))
				or nil
		end
		local function GroundY(cycle, x, z)
			local exclusions = { cycle.Character }
			if cycle.HoverPad then
				exclusions[#exclusions + 1] = cycle.HoverPad
			end
			local params = RaycastParams.new()
			params.FilterType, params.IgnoreWater = Enum.RaycastFilterType.Exclude, true
			for _ = 1, 10 do
				params.FilterDescendantsInstances = exclusions
				local hit =
					Workspace:Raycast(Vector3.new(x, cycle.Root.Position.Y + 60, z), Vector3.new(0, -300, 0), params)
				if not hit then
					return nil
				end
				if hit.Instance.CanCollide then
					return hit.Position.Y
				end
				exclusions[#exclusions + 1] = hit.Instance
			end
			return nil
		end
		local function SafeDestination(cycle)
			local ground = GroundY(cycle, safePosition.X, safePosition.Z)
			return CFrame.new(safePosition.X, ground and ground + 3.2 or safePosition.Y, safePosition.Z)
				* cycle.Root.CFrame.Rotation
		end
		local function InSafeArea(cycle)
			local delta = cycle.Root.Position - safePosition
			return Vector2.new(delta.X, delta.Z).Magnitude <= 30 and math.abs(delta.Y) <= 18
		end
		local function SyncHoverPad(cycle, position)
			if not cycle.HoverPad then
				local pad = Instance.new("Part")
				pad.Name = "__N3SenaHoverPad"
				pad.Anchored, pad.CanCollide, pad.CanQuery, pad.CanTouch = true, true, true, false
				pad.CastShadow, pad.Transparency, pad.Size = false, 1, Vector3.new(8, 1, 8)
				cycle.HoverPad = pad
				pad.Parent = Workspace
			end
			cycle.HoverPad.CFrame = CFrame.new(position.X, position.Y - FeetOffset(cycle) - 0.55, position.Z)
		end

		-- Sena v801/v826/v831: cached client-character baseline discovery/update.
		-- N3 keeps a detached original humanoid; the game state can still refer to it.
		local baselineSearch = { Busy = false, NextAt = 0, Misses = 0 }
		local sampleNames = {
			"LastObservedSample",
			"LastSample",
			"LastGoodSample",
			"LastGameplayTrustedSample",
			"LastValidatedSample",
			"LastValidatedGroundedSample",
			"LastConfirmedGroundSample",
			"CandidateGroundedSample",
		}
		local function MatchesBaseline(state, cycle)
			return type(state) == "table"
				and rawget(state, "Player") == LocalPlayer
				and rawget(state, "Character") == cycle.Character
				and rawget(state, "RootPart") == cycle.Root
				and (rawget(state, "Humanoid") == cycle.Humanoid or (cycle.OriginalHumanoid ~= nil and rawget(
					state,
					"Humanoid"
				) == cycle.OriginalHumanoid))
				and type(rawget(state, "SampleHistory")) == "table"
				and type(rawget(state, "Evidence")) == "table"
		end
		local function FindBaseline(cycle)
			local found
			local function Search(value, depth, seen)
				if found or type(value) ~= "table" or depth > 3 or seen[value] then
					return
				end
				seen[value] = true
				if MatchesBaseline(value, cycle) then
					found = value
					return
				end
				local count = 0
				for _, child in pairs(value) do
					count = count + 1
					if count > 128 then
						break
					end
					if type(child) == "table" then
						Search(child, depth + 1, seen)
					end
				end
			end
			if
				type(getcallbackvalue) == "function"
				and type(debug) == "table"
				and type(debug.getupvalue) == "function"
				and type(debug.getinfo) == "function"
			then
				pcall(function()
					local packages = ReplicatedStorage:FindFirstChild("Packages")
					local module = packages and packages:FindFirstChild("Signal")
					local signal = module and require(module)
					local invoked = signal and signal.Invoked("ClientCharacter: GetDebugSnapshot")
					local callback = invoked and getcallbackvalue(invoked, "OnInvoke")
					if type(callback) ~= "function" then
						return
					end
					for index = 1, debug.getinfo(callback).nups or 0 do
						Search(debug.getupvalue(callback, index), 0, {})
						if found then
							break
						end
					end
				end)
			end
			if not found and type(getgc) == "function" then
				local ok, values = pcall(getgc, true)
				if ok and type(values) == "table" then
					for _, value in ipairs(values) do
						if MatchesBaseline(value, cycle) then
							found = value
							break
						end
					end
				end
			end
			return found
		end
		local function UpdateBaseline(cycle, travelVelocity)
			local state = baselineSearch.Found
			if not MatchesBaseline(state, cycle) then
				if not baselineSearch.Busy and os.clock() >= baselineSearch.NextAt then
					baselineSearch.Busy = true
					task.spawn(function()
						task.wait()
						local ok, found = pcall(FindBaseline, cycle)
						if Current(cycle) then
							baselineSearch.Found = ok and found or nil
							Engine.RecordAutoTrace(
								found and "movement-baseline-ready" or "movement-baseline-not-found",
								cycle.Target.Uid
							)
							baselineSearch.Misses = found and 0 or baselineSearch.Misses + 1
							baselineSearch.NextAt = os.clock() + (found and 0.2 or baselineSearch.Misses >= 5 and 10 or 1)
						end
						baselineSearch.Busy = false
					end)
				end
				return
			end
			local speed = math.clamp(Engine.AutoSpeed() * 1.35, 200, 1350)
			local frame = cycle.Root.CFrame
			local function UpdateSample(sample)
				if type(sample) ~= "table" then
					return
				end
				rawset(sample, "WalkSpeed", speed)
				rawset(sample, "CFrame", frame)
				rawset(sample, "Position", frame.Position)
				rawset(sample, "LinearVelocity", travelVelocity or Vector3.zero)
				rawset(sample, "AngularVelocity", Vector3.zero)
			end
			for _, key in ipairs(sampleNames) do
				UpdateSample(rawget(state, key))
			end
			for _, sample in pairs(rawget(state, "SampleHistory") or {}) do
				UpdateSample(sample)
			end
			for _, sample in pairs(rawget(state, "SafeGroundCheckpoints") or {}) do
				UpdateSample(sample)
			end
			local evidence = rawget(state, "Evidence")
			if type(evidence) == "table" then
				evidence.Speed, evidence.Teleport, evidence.Flight = 0, 0, 0
			end
			local impulse = rawget(state, "ImpulseContext")
			if type(impulse) == "table" then
				impulse.MaxHorizontalSpeed = math.max(tonumber(impulse.MaxHorizontalSpeed) or 0, speed)
				impulse.OriginPosition = frame.Position
				local duration = math.max((tonumber(impulse.ExpiresAt) or 0) - (tonumber(impulse.StartedAt) or 0), 0.15)
				impulse.MaxHorizontalDistance =
					math.max(tonumber(impulse.MaxHorizontalDistance) or 0, impulse.MaxHorizontalSpeed * duration + 48)
				UpdateSample(impulse.PreMovementSafeSample)
			end
			if rawget(state, "CorrectionContext") == nil then
				rawset(state, "FirstSuspiciousAt", nil)
				if rawget(state, "ThreatLevel") == "Observing" then
					rawset(state, "ThreatLevel", "Trusted")
				end
			end
		end
		local function StartProtection(cycle)
			-- Sena's hunting/Fly policy, gated by the user's existing Anti Guard toggle.
			-- There is no primer phase and no forced guard hit in normal mode.
			if guardChasePolicy and type(guardChasePolicy.ResolveHitDistance) == "function" then
				local original = guardChasePolicy.ResolveHitDistance
				cycle.GuardPolicy, cycle.SavedGuardDistance = guardChasePolicy, original
				cycle.GuardDistanceHook = function(...)
					if Current(cycle) and Engine.Guard.Enabled then
						return -math.huge
					end
					return original(...)
				end
				guardChasePolicy.ResolveHitDistance = cycle.GuardDistanceHook
			end
			cycle.SavedKillIgnore = cycle.Root:GetAttribute("KillPartIgnore")
			cycle.Root:SetAttribute("KillPartIgnore", true)
			cycle.Protection = RunService.PreSimulation:Connect(function()
				if not Current(cycle) or Engine.Guard.Busy then
					return
				end
				if cycle.ArrivalHold then
					SyncHoverPad(cycle, cycle.ArrivalHold.Position)
					cycle.Root.CFrame = cycle.ArrivalHold
					cycle.Root.AssemblyLinearVelocity, cycle.Root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
				elseif cycle.UseHoverPad then
					SyncHoverPad(cycle, cycle.Root.Position)
				end
				UpdateBaseline(cycle, cycle.TravelVelocity)
			end)
		end
		local function StopMotion(cycle)
			cycle.ArrivalHold, cycle.TravelVelocity, cycle.UseHoverPad = nil, nil, false
			if cycle.Root.Parent then
				cycle.Root.AssemblyLinearVelocity, cycle.Root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			end
			if cycle.Humanoid.Parent then
				cycle.Humanoid:MoveTo(cycle.Root.Position)
				cycle.Humanoid:Move(Vector3.zero, false)
			end
		end
		local function CleanupCycle(cycle)
			if cycle.GuardPolicy and cycle.GuardPolicy.ResolveHitDistance == cycle.GuardDistanceHook then
				cycle.GuardPolicy.ResolveHitDistance = cycle.SavedGuardDistance
			end
			if cycle.Protection then
				cycle.Protection:Disconnect()
				cycle.Protection = nil
			end
			if Engine.AutoCycle == cycle then
				StopMotion(cycle)
				Engine.StopHold()
				Engine.StopVelocity()
				cycle.Root:SetAttribute("KillPartIgnore", cycle.SavedKillIgnore)
				if cycle.Humanoid.Parent then
					cycle.Humanoid.AutoRotate = cycle.SavedAutoRotate
				end
				if cycle.SavedCamera and Workspace.CurrentCamera == cycle.SavedCamera.Camera then
					cycle.SavedCamera.Camera.CameraType = cycle.SavedCamera.Type
				end
			end
			if cycle.HoverPad then
				cycle.HoverPad:Destroy()
				cycle.HoverPad = nil
			end
		end
		local function WaitForGuard(cycle)
			while Current(cycle) and Engine.Guard.Busy do
				RunService.Heartbeat:Wait()
			end
			return Current(cycle)
		end
		-- N3 RunPace/FlyToPosition owns the outward path; no Sena approach tween.
		local function ApproachEgg(cycle, record)
			local bottom = record and (record.BottomCFrame or record.BoundsCFrame)
			if typeof(bottom) ~= "CFrame" or not WaitForGuard(cycle) or not WallOpen() then
				return false
			end
			cycle.ArrivalHold, cycle.UseHoverPad = nil, false
			if cycle.HoverPad then
				cycle.HoverPad:Destroy()
				cycle.HoverPad = nil
			end
			SetStatus(cycle, "Heading to target egg")
			if Engine.InsideBase() and not Engine.InsideBase(bottom.Position) then
				local gate = Tasks.GetTrackStartPosition()
				cycle.Character:PivotTo(CFrame.new(gate) * cycle.Root.CFrame.Rotation)
				Engine.StopVelocity()
			end
			cycle.ApproachActive = true
			local arrived = Engine.FlyToPosition(
				bottom.Position,
				cycle.Session,
				Engine.Carry.ApproachStop,
				math.clamp(
					(cycle.Root.Position - bottom.Position).Magnitude
							/ math.max(math.min(Engine.Pace(), Engine.AutoSpeed()), 16)
							* 2
						+ 8,
					30,
					120
				),
				Engine.AutoSpeed()
			)
			cycle.ApproachActive = false
			if not Current(cycle) or not arrived then
				return false
			end
			Engine.StopHold()
			local destination = EggDestination(cycle, ReadEgg(record.Uid) or record)
			if not destination then
				return false
			end
			cycle.ArrivalHold, cycle.UseHoverPad = destination, true
			SyncHoverPad(cycle, destination.Position)
			cycle.Root.CFrame = destination
			Engine.RecordAutoTrace("egg-arrival", record.Uid)
			return true
		end
		-- Sena _glideRoot is used only for delivery/recovery, never the egg approach.
		local function Glide(cycle, destination, abort)
			if not Current(cycle) then
				return false
			end
			cycle.ArrivalHold, cycle.UseHoverPad = nil, true
			cycle.Humanoid.AutoRotate = false
			local deadline = os.clock()
				+ math.clamp((destination.Position - cycle.Root.Position).Magnitude / 5000 * 1.6 + 6, 15, 120)
			while Current(cycle) and os.clock() < deadline do
				if abort and abort() then
					return false
				end
				if not WaitForGuard(cycle) then
					return false
				end
				local position = cycle.Root.Position
				local delta = destination.Position - position
				if delta.Magnitude <= 1 then
					cycle.Root.CFrame = destination
					cycle.Root.AssemblyLinearVelocity, cycle.Root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
					SyncHoverPad(cycle, destination.Position)
					cycle.TravelVelocity = Vector3.zero
					UpdateBaseline(cycle, Vector3.zero)
					return true
				end
				local dt = math.clamp(RunService.Heartbeat:Wait(), 1 / 240, 0.15)
				if not Current(cycle) then
					return false
				end
				if Engine.Guard.Busy then
					continue
				end
				local nextPosition = position + delta.Unit * math.min(5000 * dt, delta.Magnitude)
				if dt >= 1 / 30 then
					local ground = GroundY(cycle, nextPosition.X, nextPosition.Z)
					if ground then
						nextPosition = Vector3.new(
							nextPosition.X,
							math.max(nextPosition.Y, ground + FeetOffset(cycle)),
							nextPosition.Z
						)
					end
				end
				cycle.Root.CFrame = CFrame.lookAt(nextPosition, nextPosition + delta.Unit)
				cycle.Root.AssemblyLinearVelocity, cycle.Root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
				SyncHoverPad(cycle, nextPosition)
				cycle.TravelVelocity = Vector3.zero
				UpdateBaseline(cycle, Vector3.zero)
			end
			return false
		end
		-- Readable Sena _walkLeg/_walkTo: natural MoveTo, measured braking, no
		-- tween/teleport across the final deposit boundary.
		local function WalkToSafe(cycle, abort)
			if not Current(cycle) then
				return false
			end
			cycle.ArrivalHold, cycle.UseHoverPad = nil, true
			cycle.Humanoid.AutoRotate = true
			local destination = SafeDestination(cycle).Position
			local delta = destination - cycle.Root.Position
			local deadline = os.clock()
				+ math.clamp(
					Vector2.new(delta.X, delta.Z).Magnitude / math.max(cycle.Humanoid.WalkSpeed, 1) * 2 + 8,
					12,
					90
				)
			local lastSpeed, lastAt
			while Current(cycle) and os.clock() < deadline do
				if abort and abort() then
					break
				end
				if not WaitForGuard(cycle) then
					return false
				end
				local position, velocity = cycle.Root.Position, cycle.Root.AssemblyLinearVelocity
				local flat = Vector3.new(destination.X - position.X, 0, destination.Z - position.Z)
				local distance = flat.Magnitude
				local horizontalSpeed = Vector2.new(velocity.X, velocity.Z).Magnitude
				if distance <= 4 and horizontalSpeed <= 20 then
					cycle.Humanoid:MoveTo(position)
					return true
				end
				local towardSpeed = distance > 0.001 and math.max(velocity.X * flat.X + velocity.Z * flat.Z, 0) / distance
					or horizontalSpeed
				local now, goal = os.clock(), position
				if distance <= towardSpeed * towardSpeed / (2 * (cycle.BrakeDecel or 420)) + towardSpeed * 0.06 then
					if lastSpeed and lastAt < now and horizontalSpeed > 20 then
						local measured = (lastSpeed - horizontalSpeed) / (now - lastAt)
						if measured > 20 and measured < 5000 then
							cycle.BrakeDecel = (cycle.BrakeDecel or 420) * 0.8 + measured * 0.93 * 0.2
						end
					end
					lastSpeed, lastAt = horizontalSpeed, now
				else
					lastSpeed = nil
					local stride = math.max(cycle.Humanoid.WalkSpeed * 0.5, 12)
					goal = distance <= stride and Vector3.new(destination.X, position.Y, destination.Z)
						or position + flat.Unit * stride
				end
				cycle.Humanoid:MoveTo(goal)
				RunService.Heartbeat:Wait()
			end
			if Current(cycle) then
				cycle.Humanoid:MoveTo(cycle.Root.Position)
			end
			return false
		end
		-- One outstanding remote per lane; cancellation invalidates the response.
		local function StartCarryRequest(cycle, uid, withSlotKey)
			if cycle.CarryRequest then
				return
			end
			local carryAttempt = {}
			cycle.CarryRequest = carryAttempt
			task.spawn(function()
				if not Current(cycle) then
					return
				end
				local ok, accepted, rejection = pcall(function()
					local payload = { Uid = uid }
					if withSlotKey and slotIdentity and slotIdentity.LooksLikeFirstAreaUid(uid) then
						local record = ReadEgg(uid) or cycle.Target.Raw or cycle.Target
						payload.FirstAreaSlotKey = slotIdentity.SlotKey(record.AreaId, record.NestId)
					end
					return Remotes.RemoteCarryEgg:InvokeServer(payload)
				end)
				if Current(cycle) and cycle.CarryRequest == carryAttempt then
					cycle.CarryRequest = nil
					if not ok or accepted ~= true then
						cycle.LastCarryReject = tostring(not ok and accepted or rejection or "Carry refused")
					else
						cycle.LastCarryReject = nil
					end
				end
			end)
		end
		local function CarryTimeoutSeconds(record)
			local area = string.lower(tostring(record.AreaId or ""))
			local settle, minimum = 8, 3.5
			if area:find("enchanted") then
				settle, minimum = 18, 12
			elseif area:find("light") or area:find("dark") then
				settle, minimum = 16, 10
			elseif area:find("titan") then
				settle, minimum = 10, 8
			end
			return math.max(5, math.max(settle, minimum) + 3)
		end
		local function RequestTargetCarry(cycle, record)
			if not Current(cycle) then
				return false
			end
			local uid, deadline = record.Uid, nil
			cycle.Humanoid:UnequipTools()
			while Current(cycle) do
				if CarriedByMe(uid) then
					carryTimeouts[uid], retryUid = nil, nil
					cycle.ArrivalHold = nil
					Engine.RecordAutoTrace("carry-record-confirmed", uid)
					return true
				end
				if deadline and os.clock() >= deadline then
					local failures = (carryTimeouts[uid] or 0) + 1
					if failures >= 2 then
						carryTimeouts[uid], retryUid, skippedEggs[uid] = nil, nil, os.clock() + 45
					else
						carryTimeouts[uid], retryUid = failures, uid
					end
					SetStatus(
						cycle,
						cycle.LastCarryReject and "Carry refused: " .. cycle.LastCarryReject or "Carry timeout — retrying"
					)
					cycle.ArrivalHold = nil
					Glide(cycle, SafeDestination(cycle))
					return false
				end
				if not WallOpen() then
					SetStatus(cycle, "Wall closed before carry")
					return false
				end
				local live = ReadEgg(uid)
				if not Available(live) then
					SetStatus(cycle, "Target no longer available")
					return false
				end
				local destination = EggDestination(cycle, live)
				if not destination then
					return false
				end
				if (cycle.Root.Position - destination.Position).Magnitude > 10 then
					cycle.ArrivalHold = nil
					if not ApproachEgg(cycle, live) then
						return false
					end
				end
				if not WaitForGuard(cycle) then
					return false
				end
				if not cycle.CarryRequest then
					cycle.Root.AssemblyLinearVelocity, cycle.Root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
					local ping = 0
					pcall(function()
						ping = statsService.Network.ServerStats.Ping:GetValue()
					end)
					task.wait(math.max(0.3, ping * 2.5 / 1000))
					if not Current(cycle) then
						return false
					end
					StartCarryRequest(cycle, uid, true)
					deadline = deadline or os.clock() + CarryTimeoutSeconds(record)
				end
				SetStatus(
					cycle,
					cycle.LastCarryReject and "Waiting for carry · " .. cycle.LastCarryReject
						or "Waiting for carry confirmation"
				)
				task.wait(0.25)
			end
			return false
		end
		local function RegrabBurst(cycle, uid, duration)
			local deadline = os.clock() + duration
			cycle.ArrivalHold = nil
			while Current(cycle) and os.clock() < deadline do
				if CarriedByMe(uid) then
					return true
				end
				local record = ReadEgg(uid)
				if not Available(record) or not WaitForGuard(cycle) then
					return false
				end
				if ragdollJoints and ragdollJoints.Release then
					pcall(ragdollJoints.Release, cycle.Character)
				end
				cycle.Humanoid.PlatformStand, cycle.Humanoid.Sit = false, false
				if cycle.Humanoid:GetState() ~= Enum.HumanoidStateType.Running then
					cycle.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
				local destination = EggDestination(cycle, record)
				if not destination then
					return false
				end
				cycle.Root.CFrame = destination
				cycle.Root.AssemblyLinearVelocity, cycle.Root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
				SyncHoverPad(cycle, destination.Position)
				StartCarryRequest(cycle, uid, false)
				if not cycle.NativeCarryBusy and EggStateModule and EggStateModule.CarryFieldEgg then
					cycle.NativeCarryBusy = true
					task.spawn(function()
						if Current(cycle) then
							pcall(EggStateModule.CarryFieldEgg, uid)
						end
						cycle.NativeCarryBusy = false
					end)
				end
				local slots = Workspace:FindFirstChild("AreaEggSlotsClient")
				local model = slots and slots:FindFirstChild(tostring(uid))
				local prompt = model
					and (
						model:FindFirstChild("CarryAreaEgg", true) or model:FindFirstChildWhichIsA("ProximityPrompt", true)
					)
				if prompt and prompt.Enabled then
					Engine.FirePrompt(prompt)
				end
				task.wait(0.06)
			end
			return Current(cycle) and CarriedByMe(uid)
		end
		local function InvokeTreadmill(cycle, remote)
			if not remote or not Current(cycle) or cycle.TreadmillBusy then
				return nil
			end
			cycle.TreadmillBusy = true
			local done, result = false, nil
			task.spawn(function()
				if not Current(cycle) then
					cycle.TreadmillBusy = false
					done = true
					return
				end
				local ok, response = pcall(function()
					return remote:InvokeServer()
				end)
				if ok then
					result = response
				end
				cycle.TreadmillBusy, done = false, true
			end)
			local deadline = os.clock() + 2
			while Current(cycle) and not done and os.clock() < deadline do
				task.wait(0.02)
			end
			return Current(cycle) and done and result or nil
		end
		local function TreadmillReset(cycle)
			-- Sena _treadmillResetInner fallback, only after the first re-grab fails.
			local plot = select(1, GetPlayerPlot())
			local belt = plot and plot:FindFirstChild("TreadmillBottom")
			if
				not belt
				or not belt:IsA("BasePart")
				or not treadmill.Wear
				or not treadmill.Doff
				or not treadmill.Snapshot
			then
				return false
			end
			local destination = belt.CFrame * CFrame.new(0, belt.Size.Y * 0.5 + FeetOffset(cycle) + 0.05, 0)
			if not Glide(cycle, destination) then
				return false
			end
			local worn, left = false, false
			local deadline = os.clock() + 0.7
			while Current(cycle) and os.clock() < deadline do
				InvokeTreadmill(cycle, treadmill.Wear)
				task.wait(0.08)
				local snapshot = InvokeTreadmill(cycle, treadmill.Snapshot)
				if type(snapshot) == "table" and table.find(snapshot, LocalPlayer.UserId) then
					worn = true
					break
				end
			end
			if worn and Current(cycle) then
				task.wait(0.25)
			end
			deadline = os.clock() + 0.7
			while Current(cycle) and os.clock() < deadline do
				InvokeTreadmill(cycle, treadmill.Doff)
				task.wait(0.08)
				local snapshot = InvokeTreadmill(cycle, treadmill.Snapshot)
				if type(snapshot) == "table" and not table.find(snapshot, LocalPlayer.UserId) then
					left = true
					break
				end
			end
			return worn and left
		end
		local function DeliverSenaEgg(cycle, uid)
			cycle.ArrivalHold = nil
			local deadline = os.clock() + 2.5
			while Current(cycle) and not CarriedByMe(uid) and not BankRecordGone(uid) and os.clock() < deadline do
				task.wait(0.1)
			end
			if not Current(cycle) then
				return false
			end
			if CarriedByMe(uid) then
				SetStatus(cycle, "Bringing egg home")
				cycle.DeliveryDropUid = uid
				Glide(cycle, deliveryDrop, function()
					return not CarriedByMe(uid)
				end)
				local dropped = false
				for _ = 1, 3 do
					if not Current(cycle) or not CarriedByMe(uid) then
						break
					end
					Glide(cycle, deliveryDrop, function()
						return not CarriedByMe(uid)
					end)
					if not Current(cycle) then
						return false
					end
					if CarriedByMe(uid) then
						task.wait(0.15)
						if not Current(cycle) then
							return false
						end
						if CarriedByMe(uid) then
							Engine.RecordAutoTrace("delivery-drop-request", uid)
							pcall(EggStateModule.DropFieldEgg, "PlayerRequest")
						end
						local waitUntil = os.clock() + 0.45
						while Current(cycle) and CarriedByMe(uid) and os.clock() < waitUntil do
							RunService.Heartbeat:Wait()
						end
					end
					local record = ReadEgg(uid)
					if record and record.State == states.Dropped then
						dropped = true
						break
					end
					if not CarriedByMe(uid) then
						break
					end
				end
				if not Current(cycle) then
					return false
				end
				if not dropped then
					cycle.DeliveryDropUid = nil
					SetStatus(cycle, "Drop failed — retrying")
					return false
				end
				local droppedPosition
				deadline = os.clock() + 3
				while Current(cycle) and os.clock() < deadline do
					local record = ReadEgg(uid)
					if record and record.State == states.Dropped then
						local bottom = record.BottomCFrame or record.BoundsCFrame
						droppedPosition = bottom and bottom.Position
						if droppedPosition then
							break
						end
					elseif record and record.State ~= states.Carried then
						break
					end
					task.wait(0.1)
				end
				cycle.DeliveryDropUid = nil
				if not Current(cycle) then
					return false
				end
				Glide(cycle, SafeDestination(cycle))
				if not Current(cycle) then
					return false
				end
				local regrabDestination = droppedPosition and CFrame.new(droppedPosition + Vector3.new(0, 3.2, 0))
					or deliveryDrop
				Glide(cycle, regrabDestination, function()
					return CarriedByMe(uid)
				end)
				if not Current(cycle) then
					return false
				end
				local grabbed = RegrabBurst(cycle, uid, 0.5)
				if not grabbed and not CarriedByMe(uid) and Current(cycle) then
					Glide(cycle, SafeDestination(cycle))
					if not Current(cycle) then
						return false
					end
					TreadmillReset(cycle)
					if not Current(cycle) then
						return false
					end
					Glide(cycle, SafeDestination(cycle))
					if not Current(cycle) then
						return false
					end
					Glide(cycle, regrabDestination, function()
						return CarriedByMe(uid)
					end)
					if not Current(cycle) then
						return false
					end
					grabbed = RegrabBurst(cycle, uid, 0.6)
				end
				if not grabbed and not CarriedByMe(uid) then
					SetStatus(cycle, "Re-grab failed — retrying")
					return BankRecordGone(uid) and InSafeArea(cycle)
				end
			end
			if not Current(cycle) then
				return false
			end
			if CarriedByMe(uid) then
				SetStatus(cycle, "Walking egg into safe area")
				WalkToSafe(cycle, function()
					return not CarriedByMe(uid)
				end)
			end
			SetStatus(cycle, "Waiting for deposit")
			deadline = os.clock() + 8
			while Current(cycle) and not BankRecordGone(uid) and os.clock() < deadline do
				if not InSafeArea(cycle) then
					WalkToSafe(cycle, function()
						return BankRecordGone(uid)
					end)
				end
				task.wait(0.1)
			end
			local deposited = Current(cycle) and BankRecordGone(uid) and InSafeArea(cycle)
			SetStatus(cycle, deposited and "Checking deposit" or "Bank not confirmed — retrying")
			return deposited
		end
		local function RecoverDroppedCarry(cycle, uid)
			SetStatus(cycle, "Re-stealing dropped egg")
			local deadline = os.clock() + 5
			local record
			while Current(cycle) and os.clock() < deadline do
				if CarriedByMe(uid) then
					return true
				end
				record = ReadEgg(uid)
				if Available(record) then
					break
				end
				task.wait(0.03)
			end
			if not Current(cycle) or not Available(record) or not WallOpen() then
				return false
			end
			if RegrabBurst(cycle, uid, 3.5) then
				return true
			end
			if not Current(cycle) then
				return false
			end
			-- The source teleports here; egg travel remains N3-owned in this port.
			if not ApproachEgg(cycle, record) then
				return false
			end
			return RequestTargetCarry(cycle, record)
		end
		local function ChooseTarget()
			local now = os.clock()
			local captureUid = Workspace:GetAttribute("Event_CaptureTheEggUid")
			for uid, untilAt in pairs(skippedEggs) do
				if untilAt <= now then
					skippedEggs[uid] = nil
				end
			end
			local candidates = Engine.CollectCandidates(false, true)
			for _, candidate in ipairs(candidates) do
				local record = ReadEgg(candidate.Uid) or candidate.Raw
				if Available(record) and candidate.Uid ~= captureUid and not skippedEggs[candidate.Uid] then
					if not retryUid or candidate.Uid == retryUid then
						return candidate
					end
				end
			end
			if retryUid then
				retryUid = nil
				for _, candidate in ipairs(candidates) do
					if
						Available(ReadEgg(candidate.Uid) or candidate.Raw)
						and candidate.Uid ~= captureUid
						and not skippedEggs[candidate.Uid]
					then
						return candidate
					end
				end
			end
			return nil
		end
		local function RunSenaCycle(cycle)
			if not Current(cycle) then
				return false
			end
			if cycle.Target.IdleReturn then
				StartProtection(cycle)
				SetStatus(cycle, "No matching eggs — returning to safe area")
				Glide(cycle, SafeDestination(cycle))
				return
			end
			local target, uid = cycle.Target, cycle.Target.Uid
			Engine.CurrentTarget, RuntimeState.currentTargetModel = uid, target.PhysicalModel
			Engine.AutoTargetText = tostring(target.Category or target.AssetCategory or "Egg")
				.. " · "
				.. tostring(target.AreaId or "?")
			Engine.RecordAutoTrace("cycle-start", uid)
			StartProtection(cycle)
			if RuntimeState.OnTreadmill or cycle.Root.Anchored then
				SetStatus(cycle, "Leaving treadmill")
				if Tasks.ExitTreadmill then
					pcall(Tasks.ExitTreadmill)
				end
				local deadline = os.clock() + 8
				while Current(cycle) and cycle.Root.Anchored and os.clock() < deadline do
					InvokeTreadmill(cycle, treadmill.Doff)
					task.wait(0.3)
					if os.clock() + 7 >= deadline then
						cycle.Root.Anchored = false
					end
				end
			end
			if not Current(cycle) then
				return
			end
			if not CarriedByMe(uid) then
				local record = ReadEgg(uid) or target.Raw
				if not Available(record) or not ApproachEgg(cycle, record) or not RequestTargetCarry(cycle, record) then
					return
				end
			end
			-- Sena's watchdog bounds an unchanged carried-target run at 60 seconds.
			-- Apply it after N3's independently bounded approach, not across its path.
			cycle.ReturnDeadline = os.clock() + 60
			while Current(cycle) do
				if DeliverSenaEgg(cycle, uid) then
					-- Sena _reportStolen checks the live field again after 1.5 seconds.
					task.wait(1.5)
					if not Current(cycle) then
						return
					end
					local record = ReadEgg(uid)
					if Available(record) or (record and record.State == states.Carried) then
						SetStatus(cycle, "Delivery failed — retrying")
						Engine.RecordAutoTrace("deposit-recheck-failed", uid)
						return
					end
					Engine.AutoDeliverySerial = Engine.AutoDeliverySerial + 1
					Engine.RecordAutoTrace("deposit-recheck-complete", uid)
					SetStatus(cycle, "Delivered")
					return
				end
				if not Current(cycle) or not WallOpen() then
					return
				end
				if CarriedByMe(uid) then
					task.wait(0.35)
				elseif not RecoverDroppedCarry(cycle, uid) then
					return
				end
			end
		end
		local function Tick()
			if workerRunning then
				return
			end
			if not Enabled() then
				Engine.AutoStatus = "Idle"
				return
			end
			if RuntimeState.IsExecuting or Engine.Guard.Active or Engine.Guard.Busy or Engine.Movement.PlaceWanted then
				return
			end
			if Engine.AutoDeliverySerial > Engine.AutoHandledDeliverySerial then
				return
			end
			local root = Engine.Root()
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not root or not humanoid or humanoid.Health <= 0 then
				return
			end
			if not Engine.AutoShieldReady() then
				pcall(Engine.MaintainAutoShield)
				Engine.AutoStatus = "Waiting for Humanoid Swap"
				return
			end
			local target
			-- Sena schedules delivery before choosing a new field egg.
			for uid, record in pairs(records) do
				if record.State == states.Carried and record.CarrierUserId == LocalPlayer.UserId and CarriedByMe(uid) then
					if uid == Workspace:GetAttribute("Event_CaptureTheEggUid") then
						Engine.AutoStatus = "Event egg held — normal steal waiting"
						return
					end
					target = { Uid = uid, Raw = record, AreaId = record.AreaId, Category = record.AssetCategory }
					break
				end
			end
			if not target and not WallOpen() then
				Engine.AutoStatus = "Waiting for reset wall"
				return
			end
			target = target or ChooseTarget()
			if not target then
				Engine.AutoStatus, Engine.AutoTargetText = "No matching eggs", "None"
				local offset = root.Position - safePosition
				if
					root.Position.X < Engine.GetSeparationX() + 3
					or (Vector2.new(offset.X, offset.Z).Magnitude <= 30 and math.abs(offset.Y) <= 18)
				then
					return
				end
				target = { IdleReturn = true }
			end
			if not Engine.ClaimMovement("steal") then
				Engine.AutoStatus = "Waiting for movement"
				return
			end
			Engine.StopHold()
			local camera = Workspace.CurrentCamera
			local cycle = {
				Generation = generation,
				Session = RuntimeState.SessionId,
				Cancel = RuntimeState.StealCancel,
				Character = character,
				Humanoid = humanoid,
				OriginalHumanoid = RuntimeState.OriginalHumanoid,
				Root = root,
				Target = target,
				SavedAutoRotate = humanoid.AutoRotate,
				SavedCamera = camera and { Camera = camera, Type = camera.CameraType },
			}
			workerRunning, RuntimeState.IsExecuting, Engine.Guard.StealActive = true, true, true
			Engine.Movement.StealFirst, Engine.AutoCycle = false, cycle
			task.spawn(function()
				local ok, failure = pcall(RunSenaCycle, cycle)
				local cleaned, cleanupFailure = pcall(CleanupCycle, cycle)
				if not ok then
					warn("[N3 HUB] Sena Auto Steal: " .. tostring(failure))
					SetStatus(cycle, "Auto steal error")
				end
				if not cleaned then
					warn("[N3 HUB] Sena cleanup: " .. tostring(cleanupFailure))
				end
				if Engine.AutoCycle == cycle then
					Engine.RecordAutoTrace("cycle-finished: " .. Engine.AutoStatus, target.Uid)
					Engine.AutoCycle, Engine.CurrentTarget, RuntimeState.currentTargetModel = nil, nil, nil
					RuntimeState.IsExecuting, Engine.Guard.StealActive = false, false
					Engine.ReleaseMovement("steal")
				end
				workerRunning, wakePending = false, true
				nextTick = os.clock() + 0.35
			end)
		end
		Engine.AutoWake = function()
			wakePending = true
		end
		Engine.UpdateAutoStealSpeed = Engine.AutoWake
		Engine.CancelAutoSteal = function()
			generation = generation + 1
			local cycle = Engine.AutoCycle
			if cycle then
				RuntimeState.StealCancel = RuntimeState.StealCancel + 1
				pcall(CleanupCycle, cycle)
				cycle.Cancelled = true
				-- Keep ownership while N3's approach unwinds its own camera/velocity
				-- cleanup. Other stages release immediately; late async responses
				-- cannot move or clean up a newer automation.
				if Engine.AutoCycle == cycle and not cycle.ApproachActive then
					Engine.RecordAutoTrace("cycle-cancelled", cycle.Target.Uid)
					Engine.AutoCycle, Engine.CurrentTarget, RuntimeState.currentTargetModel = nil, nil, nil
					RuntimeState.IsExecuting, Engine.Guard.StealActive = false, false
					Engine.ReleaseMovement("steal")
				end
			end
			retryUid = nil
			table.clear(carryTimeouts)
			table.clear(skippedEggs)
			wakePending = true
		end
		Engine.RunAutoStealCycle = function()
			wakePending = true
			return false
		end
		if EggStateModule then
			Connect(EggStateModule.FieldRefreshed, ReplaceSnapshot)
			Connect(EggStateModule.FieldShifted, function(record)
				if type(record) == "table" and record.Uid then
					records[record.Uid] = record
					wakePending = true
				end
			end)
			Connect(EggStateModule.FieldGone, function(uid)
				records[uid] = nil
				wakePending = true
			end)
			local function CloseGate()
				resetBlocked, gateOpenAt = true, math.huge
				Engine.CancelAutoSteal()
				Engine.AutoStatus = "Waiting for reset wall"
			end
			Connect(EggStateModule.ResetCountdown, CloseGate)
			Connect(EggStateModule.ResetFade, CloseGate)
		end
		if AreaEggResetWallModule then
			Connect(AreaEggResetWallModule.Changed, function(sealed)
				resetBlocked = sealed == true
				gateOpenAt = os.clock() + (sealed and 0 or 0.2)
				if sealed and Engine.AutoCycle then
					Engine.CancelAutoSteal()
				end
				wakePending = true
			end)
		end
		Connect(RunService.Heartbeat, function()
			if disposed then
				return
			end
			local cycle = Engine.AutoCycle
			if cycle and not Current(cycle) then
				if cycle.ReturnDeadline and os.clock() >= cycle.ReturnDeadline then
					SetStatus(cycle, "Return timed out — retrying")
					Engine.RecordAutoTrace("return-watchdog-timeout", cycle.Target.Uid)
				end
				if not cycle.Cancelled then
					cycle.Cancelled = true
					Engine.CancelAutoSteal()
				end
				return
			end
			if os.clock() < nextTick then
				return
			end
			if not wakePending and workerRunning then
				return
			end
			wakePending, nextTick = false, os.clock() + 0.35
			local ok, failure = pcall(Tick)
			if not ok then
				Engine.AutoStatus = "Scheduler error"
				warn("[N3 HUB] Sena scheduler: " .. tostring(failure))
			end
		end)
		pcall(function()
			LibraryLoader:OnUnload(function()
				disposed = true
				Engine.CancelAutoSteal()
				for _, connection in ipairs(connections) do
					connection:Disconnect()
				end
				baselineSearch.Found = nil
			end)
		end)
	end
	-- BEGIN BUILTIN STEAL VISUAL
	-- Sena t46._showTreadmillDecoy / _hideTreadmillDecoy (7275-7455).
	-- Presentation only: never move the real rig or change carry/deposit remotes.
	do
		local visual, retryAt = nil, 0
		local bindName = "N3SafeZoneVisual_" .. tostring(math.random(1000000, 9999999))
		local safeFrame = CFrame.new(544.76, 71.5, -416.48)

		local function VisualWanted()
			local owner = Engine.Movement.Owner
			return not LibraryLoader.Unloaded
				and not Engine.Disposed
				and FarmConfig.SafeZoneVisual == true
				and IsStealActive() == true
				and not RaceOwnsCharacter()
				and (owner == nil or owner == "steal")
		end

		Engine.IsSafeZoneVisual = function()
			return visual ~= nil
		end

		Engine.StopSafeZoneVisual = function()
			local state = visual
			if not state then
				return
			end
			visual = nil
			RunService:UnbindFromRenderStep(bindName)
			for _, connection in ipairs(state.Connections) do
				connection:Disconnect()
			end
			for instance, saved in pairs(state.Hidden) do
				pcall(function()
					instance[saved.Property] = saved.Value
				end)
			end
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			for camera, saved in pairs(state.Cameras) do
				pcall(function()
					-- Do not replace a camera subject acquired by another system.
					if camera.CameraSubject == state.Humanoid then
						camera.CameraSubject = humanoid or saved.Subject
						if camera.CameraType == Enum.CameraType.Custom then
							camera.CameraType = saved.Type
						end
					end
				end)
			end
			state.Decoy:Destroy()
		end

		local function HideVisual(state, instance)
			if not instance:IsDescendantOf(state.Character) then
				return
			end
			local property, hidden
			if instance:IsA("BasePart") then
				property, hidden = "LocalTransparencyModifier", 1
			elseif instance:IsA("Trail") or instance:IsA("Beam") or instance:IsA("ParticleEmitter") then
				property, hidden = "Enabled", false
			end
			if property then
				if not state.Hidden[instance] then
					state.Hidden[instance] = { Property = property, Value = instance[property], Hidden = hidden }
				end
				instance[property] = hidden
			end
		end

		local function HideStealPopup(state, instance)
			-- Same named popups as Sena, but reversible instead of Destroy().
			if instance:IsA("GuiObject") and (instance.Name == "SpeedGainPopup" or instance.Name == "PlusOne") then
				if not state.Hidden[instance] then
					state.Hidden[instance] = { Property = "Visible", Value = instance.Visible, Hidden = false }
				end
				instance.Visible = false
			end
		end

		local function UpdateVisual()
			local state = visual
			if not state then
				return
			end
			if
				not VisualWanted()
				or LocalPlayer.Character ~= state.Character
				or state.Root.Parent ~= state.Character
				or state.Character:FindFirstChildOfClass("Humanoid") ~= state.RealHumanoid
				or state.RealHumanoid.Health <= 0
				or not state.Decoy.Parent
				or not state.Humanoid.Parent
			then
				Engine.StopSafeZoneVisual()
				return
			end
			-- Cached descendants only; no workspace/GUI traversal or clones per frame.
			for instance, saved in pairs(state.Hidden) do
				if not instance.Parent then
					state.Hidden[instance] = nil
				elseif instance[saved.Property] ~= saved.Hidden then
					instance[saved.Property] = saved.Hidden
				end
			end
			local camera = Workspace.CurrentCamera
			if camera then
				if not state.Cameras[camera] then
					state.Cameras[camera] = { Subject = camera.CameraSubject, Type = camera.CameraType }
				end
				if camera.CameraType ~= Enum.CameraType.Custom then
					camera.CameraType = Enum.CameraType.Custom
				end
				if camera.CameraSubject ~= state.Humanoid then
					camera.CameraSubject = state.Humanoid
				end
			end
		end

		local function CreateVisual(cycle)
			local character = cycle.Character
			local archivable = character.Archivable
			character.Archivable = true
			local ok, decoy = pcall(character.Clone, character)
			character.Archivable = archivable
			if not ok or not decoy then
				return false
			end
			-- Assign ownership before setup so a failed setup can be fully cleaned.
			local state = {
				Character = character,
				Root = cycle.Root,
				RealHumanoid = cycle.Humanoid,
				Decoy = decoy,
				Connections = {},
				Hidden = setmetatable({}, { __mode = "k" }),
				Cameras = setmetatable({}, { __mode = "k" }),
			}
			visual = state
			decoy.Name = "__N3SafeZoneVisual"
			for _, instance in ipairs(decoy:GetDescendants()) do
				if
					instance:IsA("LuaSourceContainer")
					or instance:IsA("Sound")
					or instance:IsA("BillboardGui")
					or instance:IsA("SurfaceGui")
					or instance:IsA("Trail")
					or instance:IsA("Beam")
					or instance:IsA("ParticleEmitter")
					or instance:IsA("ProximityPrompt")
					or instance:IsA("Tool")
					or instance:IsA("Constraint")
					or instance:IsA("BodyMover")
				then
					instance:Destroy()
				elseif instance:IsA("JointInstance") or instance:IsA("WeldConstraint") then
					local part0, part1 = instance.Part0, instance.Part1
					if (part0 and not part0:IsDescendantOf(decoy)) or (part1 and not part1:IsDescendantOf(decoy)) then
						instance:Destroy()
					end
				elseif instance:IsA("BasePart") then
					instance.LocalTransparencyModifier = 0
					instance.Anchored = true
					instance.CanCollide, instance.CanTouch, instance.CanQuery = false, false, false
				end
			end
			local humanoid = decoy:FindFirstChildOfClass("Humanoid")
			local root = decoy:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root then
				Engine.StopSafeZoneVisual()
				return false
			end
			state.Humanoid = humanoid
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
			decoy:PivotTo(safeFrame * cycle.Root.CFrame.Rotation)
			decoy.Parent = Workspace
			for _, instance in ipairs(character:GetDescendants()) do
				HideVisual(state, instance)
			end
			state.Connections[#state.Connections + 1] = character.DescendantAdded:Connect(function(instance)
				if visual == state then
					HideVisual(state, instance)
				end
			end)
			state.Connections[#state.Connections + 1] = cycle.Humanoid.Died:Connect(Engine.StopSafeZoneVisual)
			local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			if gui then
				for _, instance in ipairs(gui:GetDescendants()) do
					HideStealPopup(state, instance)
				end
				state.Connections[#state.Connections + 1] = gui.DescendantAdded:Connect(function(instance)
					if visual == state then
						HideStealPopup(state, instance)
					end
				end)
			end
			-- Before Roblox's camera: retain mouse orbit/zoom instead of freezing CFrame.
			RunService:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value - 1, UpdateVisual)
			UpdateVisual()
			return true
		end

		Engine.StartSafeZoneVisual = function(cycle)
			-- Normal and Instant share this presentation; neither gets a new worker.
			if not cycle then
				local character = LocalPlayer.Character
				cycle = character
						and {
							Character = character,
							Root = character:FindFirstChild("HumanoidRootPart"),
							Humanoid = character:FindFirstChildOfClass("Humanoid"),
						}
					or nil
			end
			if not cycle or not cycle.Root or not cycle.Humanoid or cycle.Humanoid.Health <= 0 then
				return false
			end
			if not VisualWanted() or Engine.Guard.Disguise then
				return false
			end
			if visual and visual.Character == cycle.Character and visual.RealHumanoid == cycle.Humanoid then
				return true -- Reuse across normal/Instant cycles, including return/re-grab.
			end
			Engine.StopSafeZoneVisual()
			if os.clock() < retryAt then
				return false
			end
			local ok, result = pcall(CreateVisual, cycle)
			if not ok or not result then
				retryAt = os.clock() + 5
				Engine.StopSafeZoneVisual()
				warn("[N3 HUB] Safe-zone visual unavailable; steal continues: " .. tostring(result))
				return false
			end
			retryAt = 0
			return true
		end

		-- All accepted steal movement (normal, Instant and carried-egg retry) enters here.
		local claimMovement = Engine.ClaimMovement
		Engine.ClaimMovement = function(owner, ...)
			local accepted = claimMovement(owner, ...)
			if accepted and owner == "steal" then
				Engine.StartSafeZoneVisual()
			end
			return accepted
		end

		local cancelNormalSteal = Engine.CancelAutoSteal
		Engine.CancelAutoSteal = function(...)
			Engine.StopSafeZoneVisual()
			return cancelNormalSteal(...)
		end
		LibraryLoader:OnUnload(Engine.StopSafeZoneVisual)
	end
	-- END BUILTIN STEAL VISUAL
	local DeliverEggToBase
	Engine.DeliverEggToBaseSafe = function(sessionId)
		local prev = Engine.Carry.LineDrop
		Engine.Carry.LineDrop = false
		local ok, res = pcall(DeliverEggToBase, sessionId)
		Engine.Carry.LineDrop = prev
		return ok and res == true
	end
	DeliverEggToBase = function(sessionId)
		if not FarmConfig.Defense_InstantSteal and not Engine.Carry.LineDrop then
			return Engine.RunAutoStealCycle(sessionId, true)
		end
		local carry = Engine.Carry
		local home = Engine.GetBaseSafeSpot()
		local sepX = Engine.GetSeparationX()
		local landX = sepX - 7
		if carry.LineDrop then
			return Engine.LineDropHome(sessionId)
		end
		if Engine.Guard.Enabled then
			local waited = 0
			while not Engine.Guard.Busy and waited < carry.GuardStartWait and IsStealActive() do
				RunService.Heartbeat:Wait()
				waited = waited + 0.05
			end
			local wasBusy = Engine.Guard.Busy
			waited = 0
			while Engine.Guard.Busy and waited < carry.GuardDodgeWait and IsStealActive() do
				RunService.Heartbeat:Wait()
				waited = waited + 0.05
			end
			if wasBusy then
				task.wait(carry.GuardSettle)
			end
		end
		if (tonumber(carry.CarryReact) or 0) > 0 then
			task.wait(tonumber(carry.CarryReact) * 0.1)
		end
		local camSaved = nil
		if carry.LockCamera and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()) then
			local cam = workspace.CurrentCamera
			if cam then
				camSaved = { Type = cam.CameraType, CFrame = cam.CFrame }
				pcall(function()
					cam.CameraType = Enum.CameraType.Scriptable
					cam.CFrame = camSaved.CFrame
				end)
			end
		end
		local function RestoreRunCam()
			local cam = workspace.CurrentCamera
			if cam and camSaved then
				local s = camSaved
				camSaved = nil
				pcall(function()
					cam.CameraType = s.Type
				end)
			end
		end
		local root = Engine.Root()
		if not root then
			return false
		end
		local startClock = os.clock()
		local cancelAt = RuntimeState.StealCancel
		local distance = (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(home.X, 0, home.Z)).Magnitude
			+ (carry.Height or 0) * 2
		local planned, planOk, baseSpeed, safeMax, guardSpeed, floorSpeed =
			Engine.PlanCarrySpeed(Engine.State.CarryAreaId, distance, carry.Mult)
		carry.PlanOk = planOk
		carry.FloorSpeed = floorSpeed
		Engine.PlanInfo.Speed = math.floor(planned * carry.CarryScale + 0.5)
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.AutoRotate = false
			hum.PlatformStand = false
		end
		local recovered = 0
		local paceSession = sessionId
		local walkDeadline = os.clock() + (tonumber(carry.MaxWalkSeconds) or 300)
		while true do
			if not IsStealActive() or RuntimeState.SessionId ~= paceSession then
				return false
			end
			if RuntimeState.StealCancel ~= cancelAt then
				return false
			end
			if not Engine.State.Carrying then
				if Engine.State.LastDelivered >= startClock then
					return true
				end
				if Engine.State.LastFailed >= startClock then
					if Engine.CurrentTarget then
						Engine.State.BlockList[Engine.CurrentTarget] = os.clock() + 30
					end
					return false
				end
				if not carry.PlanOk and Engine.State.CarryUid then
					carry.Blocked[Engine.State.CarryUid] = true
					if Engine.CurrentTarget then
						Engine.State.BlockList[Engine.CurrentTarget] = os.clock() + 30
					end
					return false
				end
				recovered = recovered + 1
				if recovered > (carry.RecoverTries or 12) then
					return false
				end
				local uid = Engine.State.CarryUid
				if not uid then
					return false
				end
				RequestCarry(uid)
				local waited = 0
				while waited < 4 and not Engine.State.Carrying and IsStealActive() do
					RunService.Heartbeat:Wait()
					waited = waited + 0.05
				end
				if not Engine.State.Carrying then
					return false
				end
				planned = Engine.PlanCarrySpeed(Engine.State.CarryAreaId, distance, carry.Mult)
				startClock = math.min(startClock, os.clock())
			end
			local ok = Engine.RunPace(Vector3.new(landX, home.Y, home.Z), {
				Session = paceSession,
				Speed = planned * (carry.CarryScale or 1),
				Height = carry.Height,
				GroundY = home.Y,
				IsCarry = true,
				LaneMin = -425,
				LaneMax = -300,
				SwitchX = landX,
				Final = home,
				StopDist = 2.5,
				Timeout = 45,
			})
			local r = Engine.Root()
			if not r or not r.Parent then
				return false
			end
			if (Vector3.new(r.Position.X, 0, r.Position.Z) - Vector3.new(home.X, 0, home.Z)).Magnitude <= 4 then
				break
			end
			if os.clock() > walkDeadline then
				return false
			end
		end
		r = Engine.Root()
		if r and r.Parent then
			pcall(function()
				r.CFrame = CFrame.new(home) * r.CFrame.Rotation
			end)
		end
		Engine.StopVelocity()
		if hum and hum.Parent then
			hum.AutoRotate = true
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end
		local waited = 0
		local verdictOk = false
		while waited < 2 and IsStealActive() do
			if Engine.State.LastDelivered >= startClock then
				verdictOk = true
				break
			end
			if Engine.State.LastFailed >= startClock then
				break
			end
			if not Engine.State.Carrying then
				break
			end
			RunService.Heartbeat:Wait()
			waited = waited + 0.05
		end
		if Engine.State.Carrying then
			task.wait(0.2)
			pcall(function()
				if EggStateModule and EggStateModule.DropFieldEgg then
					EggStateModule.DropFieldEgg("PlayerRequest")
				end
			end)
		end
		local finalWait = 0
		while finalWait < 1.5 and IsStealActive() do
			if Engine.State.LastDelivered >= startClock then
				verdictOk = true
				break
			end
			if Engine.State.LastFailed >= startClock then
				verdictOk = false
				break
			end
			RunService.Heartbeat:Wait()
			finalWait = finalWait + 0.05
		end
		pcall(UnequipAllTools)
		RestoreRunCam()
		Engine.State.Carrying = false
		Engine.State.CarryUid = nil
		Engine.State.GuessedDrop = false
		if not verdictOk and Engine.State.LastFailed >= startClock and Engine.CurrentTarget then
			Engine.State.BlockList[Engine.CurrentTarget] = os.clock() + 30
		end
		return verdictOk
	end
	Engine.DeliverEggToBase = DeliverEggToBase
	local function RunStealCycle(sessionId)
		if not FarmConfig.Defense_InstantSteal then
			return Engine.RunAutoStealCycle(sessionId)
		end
		if not IsStealActive() then
			return
		end
		if IsActivelyCarryingEgg() or (GetEquippedEggTool() ~= nil) then
			return
		end
		if not Engine.ClaimMovement("steal") then
			return
		end
		Engine.Guard.StealActive = true
		Engine.SetLineDrop(FarmConfig.Defense_InstantSteal == true)
		local ok, err = pcall(function()
			local candidates = Engine.CollectCandidates()
			if #candidates == 0 then
				return
			end
			local target = candidates[1]
			Engine.CurrentTarget = target.Uid
			RuntimeState.currentTargetModel = target.PhysicalModel
			if RuntimeState.OnTreadmill then
				pcall(Tasks.ExitTreadmill)
				task.wait(Engine.Carry.ScanWait)
			end
			local reach = target.Position + Vector3.new(0, Engine.Carry.ArrivePad, 0)
			local char = LocalPlayer.Character
			local rp = Engine.Root()
			if not char or not rp then
				Engine.ReleaseMovement("steal")
				return
			end
			if Engine.InsideBase() and not Engine.InsideBase(target.Position) then
				local gate = Tasks.GetTrackStartPosition()
				pcall(function()
					char:PivotTo(CFrame.new(gate) * rp.CFrame.Rotation)
				end)
				Engine.StopVelocity()
			end
			local arrived = Engine.FlyToPosition(reach, sessionId, Engine.Carry.ApproachStop, Engine.Carry.ApproachTime)
			if not arrived or RuntimeState.SessionId ~= sessionId then
				Engine.State.BlockList[target.Uid] = os.clock() + Engine.Carry.BlockSeconds
				return
			end
			if Engine.Carry.LockCamera and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()) then
				local cam = workspace.CurrentCamera
				if cam then
					pcall(function()
						cam.CameraType = Enum.CameraType.Scriptable
						cam.CFrame = CFrame.new(Engine.Root().Position + Vector3.new(0, 20, 20), Engine.Root().Position)
					end)
				end
			end
			local got = Engine.GrabEggAtTarget(target, sessionId)
			if not got then
				Engine.State.BlockList[target.Uid] = os.clock() + Engine.Carry.BlockSeconds
				local cam = workspace.CurrentCamera
				if cam and Engine.Carry.LockCamera and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()) then
					pcall(function()
						cam.CameraType = Enum.CameraType.Custom
					end)
				end
				return
			end
			if Engine.Carry.LockCamera and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()) then
				local cam = workspace.CurrentCamera
				if cam then
					pcall(function()
						cam.CameraType = Enum.CameraType.Custom
					end)
				end
			end
			Engine.StopHold()
			Engine.DeliverEggToBase(sessionId)
			Engine.StopHold()
			Engine.State.LastFinishedAt = os.clock()
		end)
		Engine.Guard.StealActive = false
		RuntimeState.InGuardBounce = false
		Engine.StopHold()
		Engine.CurrentTarget = nil
		RuntimeState.currentTargetModel = nil
		Engine.ReleaseMovement("steal")
		pcall(UnequipAllTools)
	end
	Engine.RunStealCycle = RunStealCycle
	return true
end)()
local LastBestPetEquip = 0
FarmConfig.Fuse_Priority = FarmConfig.Fuse_Priority or "Lowest Rarity"
FarmConfig.Fuse_PetsToUse = FarmConfig.Fuse_PetsToUse or "All Eligible"
FarmConfig.Fuse_MaxRarity = FarmConfig.Fuse_MaxRarity or 4
FarmConfig.Fuse_SpecificSpecies = FarmConfig.Fuse_SpecificSpecies or {}
FarmConfig.Fuse_SkipMutated = (FarmConfig.Fuse_SkipMutated ~= false)
FarmConfig.Fuse_AutoActive = false
local function EjectAllSlots()
	SetElevated8()
	if not (Remotes.RemoteFuseEject and Remotes.RemoteFuseEject:IsA("RemoteFunction")) then
		return
	end
	for Slot = 1, 3 do
		pcall(function()
			Remotes.RemoteFuseEject:InvokeServer(Slot)
		end)
		task.wait(0.05)
	end
end
local GetEligibleFuseTrios
do
	local _FuseBlacklist, _FuseBlacklistAt = nil, 0
	function GetEligibleFuseTrios()
		SetElevated8()
		if not _FuseBlacklist or (os.clock() - _FuseBlacklistAt) > 5 then
			_FuseBlacklistAt = os.clock()
			local plotBlacklist = {}
			local placedFolder = Workspace:FindFirstChild("PlacedEggRenders")
			if placedFolder then
				local myIdStr = tostring(LocalPlayer.UserId)
				for _, m in ipairs(placedFolder:GetChildren()) do
					if string.find(m.Name, myIdStr) then
						local uid = m.Name:match("_(.+)$") or m.Name
						plotBlacklist[uid] = true
					end
				end
			end
			_FuseBlacklist = plotBlacklist
		end
		local plotBlacklist = _FuseBlacklist
		local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
		local char = LocalPlayer.Character
		local candidateGroups = {}
		local maxTier = tonumber(FarmConfig.Fuse_MaxRarity) or 4
		local skipMut = FarmConfig.Fuse_SkipMutated
		local useMode = FarmConfig.Fuse_PetsToUse or "All Eligible"
		local specFilter = FarmConfig.Fuse_SpecificSpecies or {}
		local function checkPetTool(tool)
			if not (tool and tool:IsA("Tool")) then
				return
			end
			local uid = tool:GetAttribute("UID") or tool:GetAttribute("Uid")
			if not uid then
				return
			end
			local uidStr = tostring(uid)
			if plotBlacklist[uidStr] then
				return
			end
			if tool:GetAttribute("Favorite") == true or tool:GetAttribute("Locked") == true then
				return
			end
			local rawName = tool.Name
			local lowerName = rawName:lower()
			if
				lowerName:find("bat")
				or lowerName:find("trap")
				or lowerName:find("potion")
				or lowerName:find("lantern")
			then
				return
			end
			local cat = GetToolCategory(tool, rawName)
			local cleanLower = cat:lower()
			if useMode == "Specific Species Only" then
				if next(specFilter) ~= nil and not specFilter[cleanLower] and not specFilter[lowerName] then
					return
				end
			end
			local hasMut = GetToolMutation(tool)
			if skipMut and hasMut then
				return
			end
			local tier = ParseRarityTier(cat, nil)
			if tier > maxTier then
				return
			end
			candidateGroups[cat] = candidateGroups[cat] or {}
			table.insert(candidateGroups[cat], {
				Uid = uidStr,
				Name = rawName,
				Tier = tier,
			})
		end
		if bp then
			for _, t in ipairs(bp:GetChildren()) do
				checkPetTool(t)
			end
		end
		if char then
			for _, t in ipairs(char:GetChildren()) do
				checkPetTool(t)
			end
		end
		local trios = {}
		for catName, list in pairs(candidateGroups) do
			if #list >= 3 then
				table.insert(trios, {
					Category = catName,
					Pets = list,
					Count = #list,
					Tier = list[1].Tier or 1,
				})
			end
		end
		local priority = FarmConfig.Fuse_Priority or "Lowest Rarity"
		table.sort(trios, function(a, b)
			if priority == "Lowest Rarity" then
				if a.Tier ~= b.Tier then
					return a.Tier < b.Tier
				end
				return a.Count > b.Count
			elseif priority == "Highest Rarity" then
				if a.Tier ~= b.Tier then
					return a.Tier > b.Tier
				end
				return a.Count > b.Count
			elseif priority == "Most Duplicates" then
				if a.Count ~= b.Count then
					return a.Count > b.Count
				end
				return a.Tier < b.Tier
			end
			return a.Count > b.Count
		end)
		return trios
	end
	local function ExecuteFuseTrio(trio)
		-- BEGIN WISP FUSE WRAP
		local function nativeAction()
		-- END WISP FUSE WRAP
		SetElevated8()
		if not (Remotes.RemoteFuseLoad and Remotes.RemoteFuseBegin and Remotes.RemoteFuseFinish) then
			return false
		end
		if not trio or not trio.Pets or #trio.Pets < 3 then
			return false
		end
		local u1 = trio.Pets[1].Uid
		local u2 = trio.Pets[2].Uid
		local u3 = trio.Pets[3].Uid
		local success = false
		pcall(function()
			EjectAllSlots()
			task.wait(0.08)
			Remotes.RemoteFuseLoad:InvokeServer(1, u1)
			task.wait(0.08)
			Remotes.RemoteFuseLoad:InvokeServer(2, u2)
			task.wait(0.08)
			Remotes.RemoteFuseLoad:InvokeServer(3, u3)
			task.wait(0.12)
			local res = Remotes.RemoteFuseBegin:InvokeServer()
			if res ~= false then
				task.wait(0.9)
				Remotes.RemoteFuseFinish:InvokeServer()
				success = true
			end
		end)
		return success
		-- BEGIN WISP FUSE RETURN
		end
		if Tasks.WispNativeAction then return Tasks.WispNativeAction("fusion", nativeAction) end
		return nativeAction()
		-- END WISP FUSE RETURN
	end
	function Tasks.GetPetResolvedTier(rawCat, rawName)
		local info = ResolveGameAsset(rawCat)
		if not info or not info.RarityRank or info.RarityRank <= 1 then
			local fallbackInfo = ResolveGameAsset(rawName)
			if fallbackInfo and (fallbackInfo.RarityRank or 1) > (info and info.RarityRank or 0) then
				info = fallbackInfo
			end
		end
		local rName = string.lower(info and info.Rarity or "common")
		local tier = RarityTierMap[rName] or (info and tonumber(info.RarityRank)) or 1
		return tier, (info and info.Rarity or "Common")
	end
	local function SetPetFavoriteState(uidStr: string, shouldFav: boolean)
		local reFav = Remotes.RemoteWriteFavourite
		if not reFav or not uidStr or uidStr == "" then
			return false
		end
		pcall(function()
			reFav:FireServer(uidStr, shouldFav)
		end)
		pcall(function()
			reFav:FireServer({ [uidStr] = shouldFav })
		end)
		return true
	end
	local function ScanAndProcessFavorites(onlyEquippedAction: string?)
		local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
		local char = LocalPlayer.Character
		if not bp and not char then
			return 0
		end
		local processedCount = 0
		local minR = tonumber(FarmConfig.Fav_MinRarity) or 7
		local rule = FarmConfig.Fav_Rule or "Rarity Only"
		local valThresh = tonumber(FarmConfig.Fav_MinValue) or 0
		local targetMut = string.lower(FarmConfig.Fav_Mutation or "Any Mutation")
		local alwaysList = FarmConfig.Fav_AlwaysSpecies or {}
		local function evaluateTool(tool, isEquipped)
			if not (tool and tool:IsA("Tool")) then
				return
			end
			local uid = tool:GetAttribute("UID") or tool:GetAttribute("Uid")
			if not uid then
				return
			end
			local uidStr = tostring(uid)
			local isCurrentlyFav = (tool:GetAttribute("Favorite") == true)
			local rawName = tool.Name
			local lowerName = rawName:lower()
			if
				lowerName:find("bat")
				or lowerName:find("trap")
				or lowerName:find("potion")
				or lowerName:find("lantern")
			then
				return
			end
			if onlyEquippedAction == "EquipFav" then
				if isEquipped and not isCurrentlyFav then
					SetPetFavoriteState(uidStr, true)
					processedCount = processedCount + 1
					task.wait(0.06)
				end
				return
			elseif onlyEquippedAction == "EquipUnfav" then
				if isEquipped and isCurrentlyFav then
					SetPetFavoriteState(uidStr, false)
					processedCount = processedCount + 1
					task.wait(0.06)
				end
				return
			end
			if isEquipped then
				if FarmConfig.Fav_AutoEquipped and not isCurrentlyFav then
					SetPetFavoriteState(uidStr, true)
					processedCount = processedCount + 1
					task.wait(0.06)
					return
				elseif FarmConfig.Fav_AutoUnfavEquipped and isCurrentlyFav then
					SetPetFavoriteState(uidStr, false)
					processedCount = processedCount + 1
					task.wait(0.06)
					return
				end
			end
			local cat = GetToolCategory(tool, rawName)
			local cleanCatLower = cat:lower()
			if alwaysList[cleanCatLower] or alwaysList[lowerName] then
				if not isCurrentlyFav then
					SetPetFavoriteState(uidStr, true)
					processedCount = processedCount + 1
					task.wait(0.06)
				end
				return
			end
			local hasMut, mutName = GetToolMutation(tool)
			local mutPass = true
			if targetMut ~= "any mutation" then
				if targetMut == "none" then
					mutPass = not hasMut
				else
					mutPass = (mutName:find(targetMut) ~= nil)
				end
			end
			local petTier, rarityName = Tasks.GetPetResolvedTier(cat, rawName)
			local petIncome = CalculateEggIncome({ Category = cat, Scale = 1, Mutations = {} })
			local rPass = (petTier >= minR)
			local vPass = (valThresh > 0 and petIncome >= valThresh)
			local shouldBeFav = false
			if rule == "Rarity Only" then
				shouldBeFav = rPass and mutPass
			elseif rule == "Value Only" then
				shouldBeFav = vPass and mutPass
			elseif rule == "Rarity And Value" then
				shouldBeFav = rPass and vPass and mutPass
			elseif rule == "Rarity Or Value" then
				shouldBeFav = (rPass or vPass) and mutPass
			end
			if shouldBeFav and not isCurrentlyFav then
				SetPetFavoriteState(uidStr, true)
				processedCount = processedCount + 1
				task.wait(0.06)
			end
		end
		if bp then
			for _, tool in ipairs(bp:GetChildren()) do
				evaluateTool(tool, false)
			end
		end
		if char then
			for _, tool in ipairs(char:GetChildren()) do
				evaluateTool(tool, true)
			end
		end
		return processedCount
	end
	local function ParseRarityTier(rawCat, itemData)
		local info = ResolveGameAsset(tostring(rawCat or ""))
		local rName = string.lower(info.Rarity or "common")
		return RarityTierMap[rName] or (tonumber(info.RarityRank) or 1)
	end
	function Tasks.HasAnyMutation(muts, baseMut)
		if type(muts) == "table" and next(muts) ~= nil then
			for _, m in pairs(muts) do
				if m and tostring(m):lower() ~= "none" and tostring(m) ~= "" then
					return true
				end
			end
		end
		if baseMut and tostring(baseMut):lower() ~= "none" and tostring(baseMut) ~= "" then
			return true
		end
		return false
	end
	function Tasks.GetOfficialPrice(itemData, fallbackIncome)
		local price = 0
		pcall(function()
			local AssetItemsMod = require(ReplicatedStorage.Shared.Util.AssetItems)
			if AssetItemsMod and AssetItemsMod.SalePrice then
				price = tonumber(AssetItemsMod.SalePrice(itemData)) or 0
			end
		end)
		if price == 0 then
			price = (tonumber(fallbackIncome) or 15) * 100
		end
		return price
	end
end
local function GetSellablePets()
	SetElevated8()
	local plotBlacklist = {}
	local placedFolder = Workspace:FindFirstChild("PlacedEggRenders")
	if placedFolder then
		local myIdStr = tostring(LocalPlayer.UserId)
		for _, model in ipairs(placedFolder:GetChildren()) do
			if string.find(model.Name, myIdStr) then
				local uid = model.Name:match("_(.+)$") or model.Name
				plotBlacklist[uid] = true
			end
		end
	end
	local matchedUids = {}
	local totalPrice = 0
	local seenUids = {}
	local rule = FarmConfig.Sell_PetRule or "Rarity Only"
	local maxR = tonumber(FarmConfig.Sell_PetMaxRarity) or 7
	local valThresh = tonumber(FarmConfig.Sell_PetValueThreshold) or 0
	local keepMut = FarmConfig.Sell_KeepMutatedPets
	local blacklist = FarmConfig.Sell_PetBlacklist or {}
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	local char = LocalPlayer.Character
	local function processTool(tool)
		if not (tool and tool:IsA("Tool")) then
			return
		end
		local uid = tool:GetAttribute("UID") or tool:GetAttribute("Uid")
		if not uid then
			return
		end
		local uidStr = tostring(uid)
		if seenUids[uidStr] or plotBlacklist[uidStr] then
			return
		end
		local isFav = tool:GetAttribute("Favorite") == true or tool:GetAttribute("Locked") == true
		if isFav then
			return
		end
		local rawName = tool.Name
		local lowerName = rawName:lower()
		if lowerName:find("bat") or lowerName:find("trap") or lowerName:find("potion") or lowerName:find("lantern") then
			return
		end
		local cleanCat = GetToolCategory(tool, rawName)
		local cleanLower = cleanCat:lower()
		if blacklist[cleanLower] or blacklist[lowerName] then
			return
		end
		local hasMut = GetToolMutation(tool)
		if keepMut and hasMut then
			return
		end
		local petTier = ParseRarityTier(cleanCat, nil)
		local petIncome = CalculateEggIncome({ Category = cleanCat, Scale = 1, Mutations = {} })
		local rPass = (petTier <= maxR)
		local vPass = (valThresh > 0 and petIncome < valThresh)
		local canSell = false
		if rule == "Rarity Only" then
			canSell = rPass
		elseif rule == "Value Only" then
			canSell = vPass
		elseif rule == "Rarity And Value" then
			canSell = (rPass and vPass)
		elseif rule == "Rarity Or Value" then
			canSell = (rPass or vPass)
		end
		if canSell then
			seenUids[uidStr] = true
			table.insert(matchedUids, uidStr)
			totalPrice = totalPrice + (petIncome > 0 and (petIncome * 100) or 1000)
		end
	end
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			processTool(tool)
		end
	end
	if char then
		for _, tool in ipairs(char:GetChildren()) do
			processTool(tool)
		end
	end
	return matchedUids, totalPrice
end
local function GetSellableEggs()
	if GetScrambleTradeStatusFn then pcall(GetScrambleTradeStatusFn) end
	SetElevated8()
	local rawEggs = nil
	pcall(function()
		if EggStateModule and type(EggStateModule.ReadOwnerEggs) == "function" then
			rawEggs = EggStateModule.ReadOwnerEggs(LocalPlayer.UserId)
		end
	end)
	if type(rawEggs) ~= "table" then
		return {}, 0
	end
	local char = LocalPlayer.Character
	local heldTool = char and char:FindFirstChildWhichIsA("Tool")
	local heldUid = heldTool and (heldTool:GetAttribute("UID") or heldTool:GetAttribute("EggUid")) or nil
	local matchedUids = {}
	local totalPrice = 0
	local rule = FarmConfig.Sell_EggRule or "Rarity Only"
	local maxR = tonumber(FarmConfig.Sell_EggMaxRarity) or 3
	local valThresh = tonumber(FarmConfig.Sell_EggValueThreshold) or 0
	local keepMut = FarmConfig.Sell_KeepMutatedEggs
	local blacklist = FarmConfig.Sell_EggBlacklist or {}
	for uidKey, egg in pairs(rawEggs) do
		local uidStr = tostring(uidKey)
		if type(egg) == "table" and egg.Placement == nil and uidStr ~= tostring(heldUid) then
			local cat = tostring(egg.AssetCategory or egg.Category or egg.Name or "")
			local cleanCat = string.lower(cat)
			if
				cleanCat ~= ""
				and not string.find(cleanCat, "rift")
				and not blacklist[cleanCat]
				and not (DrScramble.IsLabRewardEgg and DrScramble.IsLabRewardEgg(egg))
				and not ShouldHoldBackScrambleEgg(cat, uidStr)
			then
				local hasMut = Tasks.HasAnyMutation(egg.Mutations, egg.BaseMutation)
				if not (keepMut and hasMut) then
					local eggTier = ParseRarityTier(cat, egg)
					local eggIncome = CalculateEggIncome(egg)
					local rPass = (eggTier <= maxR)
					local vPass = (valThresh > 0 and eggIncome < valThresh)
					local canSell = false
					if rule == "Rarity Only" then
						canSell = rPass
					elseif rule == "Value Only" then
						canSell = vPass
					elseif rule == "Rarity And Value" then
						canSell = (rPass and vPass)
					elseif rule == "Rarity Or Value" then
						canSell = (rPass or vPass)
					end
					if canSell then
						table.insert(matchedUids, uidStr)
						totalPrice = totalPrice + Tasks.GetOfficialPrice(egg, eggIncome)
					end
				end
			end
		end
	end
	return matchedUids, totalPrice
end
local function ExecuteSellSelection(petUids, eggUids)
	SetElevated8()
	local reSell = Remotes.RemoteSellSelection
	if reSell and reSell:IsA("RemoteEvent") then
		local maxCount = math.max(#petUids, #eggUids)
		local step = 50
		for i = 1, maxCount, step do
			local pChunk = {}
			local eChunk = {}
			for j = i, math.min(i + step - 1, maxCount) do
				if petUids[j] then
					table.insert(pChunk, petUids[j])
				end
				if eggUids[j] then
					table.insert(eChunk, eggUids[j])
				end
			end
			pcall(function()
				reSell:FireServer({ Assets = pChunk, Eggs = eChunk })
			end)
			task.wait(0.2)
		end
	end
end
-- BEGIN SCRAMBLE LAB SELLER
-- Chili V2 6594-6798: identify Lab rewards by banner EggSkin, not egg names.
-- Separate from ordinary eggs; inventory-only, with the existing Lab action lock.
do
	local seller = {
		Skins = {}, PetOptions = {}, PetCategories = {}, Busy = false,
		Generation = 0, NextAt = 0, Disposed = false, Status = "Off", StatusAt = 0,
	}
	DrScramble.LabSeller = seller
	FarmConfig.LabSell_Auto = false
	FarmConfig.LabSell_Rule = "Rarity And Value"
	FarmConfig.LabSell_MaxRarity = 0
	FarmConfig.LabSell_IncomeLimit = 0
	FarmConfig.LabSell_KeepMutated = true
	FarmConfig.LabSell_KeepPets = {}
	for _, banner in pairs((ScrambleTradeInData and ScrambleTradeInData.Banners) or {}) do
		if type(banner) == "table" and banner.EggSkin ~= nil then
			seller.Skins[tostring(banner.EggSkin)] = true
			for _, pet in pairs(type(banner.Pets) == "table" and banner.Pets or {}) do
				if type(pet) == "table" and pet.AssetId ~= nil then
					local category = tostring(pet.AssetId)
					local asset = AssetsModule and AssetsModule.Directory and AssetsModule.Directory[category]
					local label = tostring(type(asset) == "table" and asset.DisplayName or category) .. " [" .. category .. "]"
					if not seller.PetCategories[label] then
						seller.PetCategories[label] = category
						table.insert(seller.PetOptions, label)
					end
				end
			end
		end
	end
	table.sort(seller.PetOptions)
	function DrScramble.IsLabRewardEgg(egg)
		return type(egg) == "table" and egg.EggSkin ~= nil
			and seller.Skins[tostring(egg.EggSkin)] == true
	end
	local function isMutated(egg)
		local function meaningful(value)
			local name = string.lower(tostring(value or ""))
			return name ~= "" and name ~= "none" and name ~= "normal" and name ~= "false"
		end
		if meaningful(egg.BaseMutation) or meaningful(egg.Mutation) then return true end
		if type(egg.Mutations) == "string" then
			for name in egg.Mutations:gmatch("[^,]+") do
				if meaningful(name:match("^%s*(.-)%s*$")) then return true end
			end
		elseif type(egg.Mutations) == "table" then
			for key, value in pairs(egg.Mutations) do
				if type(value) == "table" then
					local name = value.Id or value.Name or value.Label
					if name == nil or meaningful(name) then return true end
				elseif type(value) == "boolean" or type(value) == "number" then
					if value ~= false and value ~= 0 and type(key) == "string" and meaningful(key) then return true end
				elseif meaningful(value) then return true end
			end
		end
		return false
	end
	function DrScramble.CollectSellableLabEggs()
		local result, price = {}, 0
		if seller.Disposed then return result, price end
		SetElevated8()
		if GetScrambleTradeStatusFn then GetScrambleTradeStatusFn() end
		local ok, eggs = pcall(function()
			return EggStateModule and EggStateModule.ReadOwnerEggs(LocalPlayer.UserId)
		end)
		if not ok or type(eggs) ~= "table" then return result, price end
		local character = LocalPlayer.Character
		local tool = character and character:FindFirstChildWhichIsA("Tool")
		local heldUid = tool and (tool:GetAttribute("UID") or tool:GetAttribute("EggUid"))
		for uid, egg in pairs(eggs) do
			if not DrScramble.IsLabRewardEgg(egg) or egg.Placement ~= nil
				or tostring(uid) == tostring(heldUid) or RuntimeState.ScrambleReserved[tostring(uid)] then continue end
			local category = tostring(egg.AssetCategory or egg.Category or "")
			if FarmConfig.LabSell_KeepPets[category]
				or ShouldHoldBackScrambleEgg(category, uid)
				or (FarmConfig.LabSell_KeepMutated and isMutated(egg)) then continue end
			local asset = AssetsModule and AssetsModule.Directory and AssetsModule.Directory[category]
			-- Unknown metadata must not silently become a disposable Common egg.
			if type(asset) ~= "table" then continue end
			local rarity = asset.Rarity
			local tier = type(rarity) == "table" and tonumber(rarity.RarityNumber or rarity.Rank)
				or RarityTierMap[string.lower(tostring(rarity or ""))]
			local income = CalculateEggIncome(egg)
			local rarityPass = tier ~= nil and tier > 0 and tier <= FarmConfig.LabSell_MaxRarity
			local valuePass = FarmConfig.LabSell_IncomeLimit > 0 and income >= 0
				and income < FarmConfig.LabSell_IncomeLimit
			local rule = FarmConfig.LabSell_Rule
			local matches = (rule == "Rarity Only" and rarityPass)
				or (rule == "Value Only" and valuePass)
				or (rule == "Rarity And Value" and rarityPass and valuePass)
				or (rule == "Rarity Or Value" and (rarityPass or valuePass))
			if matches then
				table.insert(result, uid) -- Keep the server's original UID type.
				price += Tasks.GetOfficialPrice(egg, income)
			end
		end
		return result, price
	end
	local function actionAllowed()
		return not seller.Disposed and not LibraryLoader.Unloaded
			and not RaceOwnsCharacter()
			and not (Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal())
	end
	function DrScramble.LabSellSettingsChanged()
		seller.Generation += 1
		seller.NextAt = math.max(seller.NextAt, os.clock() + 3)
	end
	function DrScramble.RunLabSell(manual)
		local lab = Tasks.LabState
		if seller.Disposed or LibraryLoader.Unloaded or (not manual and not FarmConfig.LabSell_Auto) then return end
		if seller.Busy or lab.ActionBusy or lab.FetchBusy then
			seller.Status = "Waiting for the current Lab action"
			return
		end
		if not actionAllowed() then seller.Status = "Paused for Race Rally"; return end
		if os.clock() < seller.NextAt then return end
		if next(seller.Skins) == nil then seller.Status = "Lab banner catalog unavailable; no sale"; return end
		seller.Busy, lab.ActionBusy = true, true
		seller.NextAt = os.clock() + 3
		local generation, revision = seller.Generation, lab.Revision
		local function cancelled()
			return generation ~= seller.Generation or revision ~= lab.Revision or not actionAllowed()
				or (not manual and not FarmConfig.LabSell_Auto)
		end
		local ok, message = pcall(function()
			local remote = Remotes.RemoteSellSelection
			if not remote or not remote:IsA("RemoteEvent") then return "Sell remote unavailable" end
			local selected = DrScramble.CollectSellableLabEggs()
			if cancelled() then return "Paused / settings changed" end
			if #selected == 0 then return "No matching Lab eggs" end
			local submitted = 0
			for offset = 1, #selected, 50 do
				if cancelled() then break end
				-- Re-read placement, equipped UID, filters and recipe reservations per batch.
				local fresh = {}
				for _, uid in ipairs(DrScramble.CollectSellableLabEggs()) do fresh[tostring(uid)] = true end
				if cancelled() then break end
				local batch = {}
				for index = offset, math.min(offset + 49, #selected) do
					local uid = selected[index]
					if fresh[tostring(uid)] then table.insert(batch, uid) end
				end
				if #batch > 0 then
					SetElevated8()
					if cancelled() then break end
					remote:FireServer({ Assets = {}, Eggs = batch })
					submitted += #batch
				end
				if offset + 50 <= #selected then task.wait(0.2) end
			end
			return string.format("Requested %d Lab eggs; awaiting inventory update", submitted)
		end)
		-- No alternate movement worker, respawn, farm-toggle writes or pet sale.
		seller.Busy, lab.ActionBusy = false, false
		seller.Status = ok and message or "Sell request failed; retry after cooldown"
		seller.StatusAt = os.clock()
	end
	function DrScramble.BuildLabSellerUI(group)
		group:AddToggle("Toggle_LabSell_Auto", {
			Text = "Auto Sell Lab Egg", Default = false,
			Callback = function(value)
				FarmConfig.LabSell_Auto = value == true
				DrScramble.LabSellSettingsChanged()
			end,
		})
		group:AddDropdown("Dropdown_LabSell_Rule", {
			Text = "Sell Rule", Values = SellRuleOptions, Default = "Rarity And Value", AllowNull = false,
			Callback = function(value)
				FarmConfig.LabSell_Rule = value
				DrScramble.LabSellSettingsChanged()
			end,
		})
		local rarities = { "Off" }
		for _, label in ipairs(RarityNumberedList) do table.insert(rarities, label) end
		group:AddDropdown("Dropdown_LabSell_MaxRarity", {
			Text = "Max Rarity", Tooltip = "Off = no rarity matches.", Values = rarities, Default = "Off", AllowNull = false,
			Callback = function(value)
				FarmConfig.LabSell_MaxRarity = tonumber(tostring(value):match("^(%d+)")) or 0
				DrScramble.LabSellSettingsChanged()
			end,
		})
		group:AddInput("Input_LabSell_IncomeLimit", {
			Text = "Income Below", Tooltip = "$/s. 0 = disabled.", Default = "0", Numeric = true, Finished = true,
			Callback = function(value)
				local number = tonumber(value) or 0
				FarmConfig.LabSell_IncomeLimit = (number == number and number < math.huge) and math.max(0, number) or 0
				DrScramble.LabSellSettingsChanged()
			end,
		})
		group:AddToggle("Toggle_LabSell_KeepMutated", {
			Text = "Keep Mutation Lab Egg", Default = true,
			Callback = function(value)
				FarmConfig.LabSell_KeepMutated = value == true
				DrScramble.LabSellSettingsChanged()
			end,
		})
		if #seller.PetOptions > 0 then
			group:AddDropdown("Dropdown_LabSell_KeepPets", {
				Text = "Keep Lab Pets", Values = seller.PetOptions,
				Multi = true, Default = {}, AllowNull = true, Searchable = true,
				Callback = function(value)
					local selected, kept = ParseMultiDropdownSelection(value), {}
					for label, category in pairs(seller.PetCategories) do
						if selected[string.lower(label)] then kept[category] = true end
					end
					FarmConfig.LabSell_KeepPets = kept
					DrScramble.LabSellSettingsChanged()
				end,
			})
		end
		group:AddButton({ Text = "Sell Now", DoubleClick = true, Tooltip = "Double-click to confirm.", Func = function()
			task.spawn(DrScramble.RunLabSell, true)
		end })
		if seller.Started then return end
		seller.Started = true
		task.spawn(function()
			while not seller.Disposed and not LibraryLoader.Unloaded do
				if FarmConfig.LabSell_Auto then
					DrScramble.RunLabSell(false)
				elseif os.clock() - seller.StatusAt > 6 then seller.Status = "Off (Sell Now remains available)" end
				task.wait(2)
			end
		end)
	end
	LibraryLoader:OnUnload(function()
		seller.Disposed = true
		seller.Generation += 1
	end)
end
-- END SCRAMBLE LAB SELLER

-- Chili V2 belt discovery: the plot's physical bottom precedes client decoration.
function Tasks.ScanTreadmillInPlot(plot)
	if not plot then return nil end
	local bottom = plot:FindFirstChild("TreadmillBottom", true)
	if bottom and bottom:IsA("BasePart") then return bottom end
	local renders = Workspace:FindFirstChild("__ClientTreadmillRenders")
	local render = renders and renders:FindFirstChild("TreadmillRender_" .. plot.Name)
	if render then
		local pad = render:FindFirstChild("BoundingBoxPart", true)
			or (render:IsA("Model") and render.PrimaryPart)
			or render:FindFirstChildWhichIsA("BasePart", true)
		if pad and pad:IsA("BasePart") then return pad end
	end
	local upgrade = plot:FindFirstChild("TreadmillUpgrade", true)
	return upgrade and upgrade:FindFirstChildWhichIsA("BasePart", true) or nil
end
local GetTreadmillPart
do
	local _TreadmillPadCheckedAt = 0
	function GetTreadmillPart()
		if RuntimeState.TreadmillPad and RuntimeState.TreadmillPad.Parent then
			if (os.clock() - _TreadmillPadCheckedAt) < 2 then
				return RuntimeState.TreadmillPad
			end
			_TreadmillPadCheckedAt = os.clock()
			local CurrentPlot = select(1, GetPlayerPlot())
			if
				CurrentPlot
				and (
					RuntimeState.TreadmillPad:IsDescendantOf(CurrentPlot)
					or string.find(RuntimeState.TreadmillPad:GetFullName(), "TreadmillRender_" .. CurrentPlot.Name)
				)
			then
				return RuntimeState.TreadmillPad
			end
		end
		local Plot = select(1, GetPlayerPlot())
		if not Plot then
			return nil
		end
		local FoundPad = Tasks.ScanTreadmillInPlot(Plot)
		if FoundPad then
			RuntimeState.TreadmillPad = FoundPad
			_TreadmillPadCheckedAt = os.clock()
		end
		return FoundPad
	end
end
Tasks.TreadmillState = { Busy = false, Exiting = false, Generation = 0, LastGainAt = -math.huge, NextCheck = 0 }
local function IsPlayerRunningOnTreadmill(): boolean
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local pad = GetTreadmillPart()
	if not root or not pad then return false end
	local position = pad.CFrame:PointToObjectSpace(root.Position)
	return math.abs(position.X) <= pad.Size.X / 2 + 2
		and math.abs(position.Z) <= pad.Size.Z / 2 + 2
		and position.Y >= -2 and position.Y <= pad.Size.Y / 2 + 8
end
Tasks.AutoStealBelt = GetTreadmillPart
function Tasks.TreadmillMayRun()
	local engine = RuntimeState.StealEngine
	if LibraryLoader.Unloaded or not FarmConfig.AutoTreadmill or RaceOwnsCharacter()
		or (Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal())
		or LocalPlayer:GetAttribute("InScrambleArena") == true
		or RuntimeState.IsExecuting or not engine or engine.AutoCycle
		or (engine.Guard and (engine.Guard.Active or engine.Guard.Busy))
		or (engine.Movement and engine.Movement.PlaceWanted)
		or (Tasks.PriorityStealYield and Tasks.PriorityStealYield()) then return false end
	local owner = engine.Movement.Owner
	if owner ~= nil and owner ~= "treadmill" then return false end
	local state = engine.State
	if state and (state.Carrying or state.SignalCarrying or state.WeldCarrying) then return false end
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root or root.Position.Y < -200 then return false end
	-- Enabled farm toggles alone don't mean a steal is actually in progress.
	-- Reuse the native filtered candidates, never a second egg picker.
	if IsStealActive() and engine.CollectCandidates then
		local belt = Tasks.TreadmillState
		if os.clock() >= (belt.CandidateCheckAt or 0) then
			belt.CandidateCheckAt = os.clock() + 0.3
			local candidates = engine.CollectCandidates(false, not FarmConfig.Defense_InstantSteal)
			belt.HasCandidates = candidates and #candidates > 0
		end
		if belt.HasCandidates then return false end
	end
	return true
end
local function ExitTreadmill()
	local state = Tasks.TreadmillState
	state.Generation += 1
	local wasRiding = RuntimeState.OnTreadmill or IsPlayerRunningOnTreadmill()
	RuntimeState.OnTreadmill = false
	state.LastGainAt, state.NextCheck = -math.huge, 0
	-- Never click arbitrary Leave/Exit buttons or alter another owner's humanoid.
	if not wasRiding or state.Exiting or LibraryLoader.Unloaded
		or LocalPlayer:GetAttribute("RaceId") ~= nil
		or LocalPlayer:GetAttribute("RaceRallyQueued") == true then return end
	state.Exiting = true
	local generation = state.Generation
	local waitUntil = os.clock() + 1
	while state.WearBusy and os.clock() < waitUntil do task.wait(0.05) end
	if state.WearBusy or generation ~= state.Generation or LibraryLoader.Unloaded
		or LocalPlayer:GetAttribute("RaceId") ~= nil
		or LocalPlayer:GetAttribute("RaceRallyQueued") == true then
		state.Exiting = false
		return
	end
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local done = false
	task.spawn(function()
		if generation == state.Generation and not LibraryLoader.Unloaded
			and LocalPlayer.Character == character
			and LocalPlayer:GetAttribute("RaceId") == nil
			and LocalPlayer:GetAttribute("RaceRallyQueued") ~= true then
			pcall(function()
				if Remotes.RemoteTreadmillDoff then Remotes.RemoteTreadmillDoff:InvokeServer() end
			end)
		end
		done, state.Exiting = true, false
	end)
	local deadline = os.clock() + 0.35
	while not done and os.clock() < deadline do task.wait(0.05) end
	if not done then return end
	local engine = RuntimeState.StealEngine
	local owner = engine and engine.Movement.Owner
	if generation == state.Generation and LocalPlayer.Character == character and humanoid and not RaceOwnsCharacter()
		and (owner == nil or owner == "treadmill") and IsPlayerRunningOnTreadmill() then
		humanoid.Jump = true
	end
end
Tasks.ExitTreadmill = ExitTreadmill
local function MountTreadmill()
	local state, engine = Tasks.TreadmillState, RuntimeState.StealEngine
	if state.Busy or state.Exiting or os.clock() < (state.NextAttemptAt or 0)
		or not Tasks.TreadmillMayRun() then return false end
	local onBelt = IsPlayerRunningOnTreadmill()
	if onBelt and os.clock() - state.LastGainAt < 6 then
		RuntimeState.OnTreadmill = true
		return true
	end
	if RuntimeState.OnTreadmill and onBelt and os.clock() < state.NextCheck then return true end
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local pad = GetTreadmillPart()
	if not pad or not root or not humanoid or humanoid.Health <= 0
		or not Remotes.RemoteTreadmillWear or not engine.ClaimMovement("treadmill") then return false end
	state.Busy = true
	state.Generation += 1
	local generation = state.Generation
	local function cancelled()
		return generation ~= state.Generation or LocalPlayer.Character ~= character
			or not root.Parent or not pad.Parent or humanoid.Health <= 0
			or engine.Movement.Owner ~= "treadmill" or not Tasks.TreadmillMayRun()
	end
	local ok, riding = pcall(function()
		local target = pad.Position + Vector3.new(0, pad.Size.Y / 2 + 2, 0)
		local deadline = os.clock() + 6
		while (root.Position - target).Magnitude > 3 do
			local dt = RunService.Heartbeat:Wait()
			if cancelled() or os.clock() >= deadline then return false end
			local delta = target - root.Position
			if delta.Magnitude <= 3 then break end
			local speed = math.max(250, tonumber(FarmConfig.TweenSpeed) or 600)
			root.CFrame = CFrame.new(root.Position + delta.Unit * math.min(delta.Magnitude, speed * dt))
			root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		end
		if cancelled() then return false end
		-- Let the existing humanoid settle. Don't install a second swap or force
		-- AutoRotate/PlatformStand/collision settings that a new owner would inherit.
		local groundedBy = os.clock() + 1.5
		while not engine.IsGrounded(humanoid) and os.clock() < groundedBy do
			task.wait(0.1)
			if cancelled() then return false end
		end
		if cancelled() then return false end
		state.WearBusy = true
		local accepted, result, reason = pcall(function()
			return Remotes.RemoteTreadmillWear:InvokeServer()
		end)
		state.WearBusy = false
		if cancelled() then return false end
		state.NextCheck = os.clock() + 5
		state.LastError = accepted and tostring(reason or "") or tostring(result)
		return accepted and (result ~= false or tostring(reason) == "Already using treadmill"
			or (tostring(reason) == "Not grounded" and os.clock() - state.LastGainAt < 6
				and IsPlayerRunningOnTreadmill()))
	end)
	local checked, current = pcall(function()
		return not cancelled() and IsPlayerRunningOnTreadmill()
	end)
	RuntimeState.OnTreadmill = ok and riding == true and checked and current == true
	engine.ReleaseMovement("treadmill")
	state.Busy = false
	state.NextAttemptAt = os.clock() + (RuntimeState.OnTreadmill and 0 or 1.5)
	return RuntimeState.OnTreadmill
end
-- Preserve the native movement picker. A sent Wear request cannot be recalled;
-- don't hand the character to a new task until that in-flight RPC has unwound.
do
	local engine = RuntimeState.StealEngine
	if engine then
		local nativeClaim = engine.ClaimMovement
		engine.ClaimMovement = function(owner, ...)
			if not LibraryLoader.Unloaded and owner ~= "treadmill" and Tasks.TreadmillState.WearBusy then
				Tasks.TreadmillState.Generation += 1
				return false
			end
			-- Normal steal also claims movement for its no-target return home.
			-- Let idle training stand; real filtered eggs/carry still preempt it.
			if owner == "steal" and (Tasks.TreadmillState.Busy or RuntimeState.OnTreadmill)
				and Tasks.TreadmillMayRun() then return false end
			return nativeClaim(owner, ...)
		end
	end
end
Tasks.TreadmillState.CharacterConnection = LocalPlayer.CharacterAdded:Connect(function()
	local state = Tasks.TreadmillState
	state.Generation += 1
	state.LastGainAt, state.NextCheck, state.NextAttemptAt = -math.huge, 0, 0
	RuntimeState.OnTreadmill = false
end)
if Remotes.RemoteTreadmillSpeedGained and Remotes.RemoteTreadmillSpeedGained:IsA("RemoteEvent") then
	Tasks.TreadmillState.GainConnection = Remotes.RemoteTreadmillSpeedGained.OnClientEvent:Connect(function()
		Tasks.TreadmillState.LastGainAt = os.clock()
	end)
end
LibraryLoader:OnUnload(function()
	Tasks.TreadmillState.Generation += 1
	RuntimeState.OnTreadmill = false
	if Tasks.TreadmillState.GainConnection then Tasks.TreadmillState.GainConnection:Disconnect() end
	Tasks.TreadmillState.CharacterConnection:Disconnect()
end)
local function ApplyTreadmillShield(blockTreadmill: boolean)
	pcall(function()
		local allowQueryAndTouch = not blockTreadmill
		local plots = Workspace:FindFirstChild("Plots")
		if plots then
			for _, plot in ipairs(plots:GetChildren()) do
				local tb = plot:FindFirstChild("TreadmillBottom", true)
				if tb and tb:IsA("BasePart") then
					tb.CanTouch = allowQueryAndTouch
					tb.CanQuery = allowQueryAndTouch
				end
				local tu = plot:FindFirstChild("TreadmillUpgrade", true)
				if tu then
					for _, desc in ipairs(tu:GetDescendants()) do
						if desc:IsA("BasePart") then
							desc.CanTouch = allowQueryAndTouch
							desc.CanQuery = allowQueryAndTouch
						end
					end
				end
			end
		end
		local clientRenders = Workspace:FindFirstChild("__ClientTreadmillRenders")
		if clientRenders then
			for _, render in ipairs(clientRenders:GetChildren()) do
				for _, desc in ipairs(render:GetDescendants()) do
					if desc:IsA("BasePart") then
						desc.CanTouch = allowQueryAndTouch
						desc.CanQuery = allowQueryAndTouch
					end
				end
			end
		end
	end)
end
function Tasks.ExecuteUpgradeTreadmill()
	local state = Tasks.TreadmillState
	if LibraryLoader.Unloaded or not FarmConfig.AutoUpgradeTreadmill or state.UpgradeBusy
		or os.clock() < (state.NextUpgradeAt or 0) or not Remotes.RemoteTreadmillUpgrade then return false end
	state.UpgradeBusy = true
	state.NextUpgradeAt = os.clock() + 3
	local ok, upgraded = pcall(function()
		local save = SaveModule and ((SaveModule.Get and SaveModule.Get()) or (SaveModule.Peek and SaveModule.Peek()))
		local data = ReplicatedStorage:FindFirstChild("Data")
		local module = data and data:FindFirstChild("Treadmills")
		local treadmills = module and require(module)
		if not save or type(treadmills) ~= "table" or type(treadmills.GetByUpgradeLevel) ~= "function" then return false end
		local tier = treadmills.GetByUpgradeLevel((tonumber(save.TreadmillUpgradeLevel) or 0) + 1)
		if type(tier) ~= "table" or type(tier._id) ~= "string" then return false end
		local cash, price = tonumber(save.Money) or 0, tonumber(tier.Price) or math.huge
		if cash - math.max(0, tonumber(FarmConfig.CashReserve) or 0) < price
			or not FarmConfig.AutoUpgradeTreadmill or LibraryLoader.Unloaded then return false end
		return Remotes.RemoteTreadmillUpgrade:InvokeServer(tier._id) ~= false
	end)
	state.UpgradeBusy = false
	return ok and upgraded == true
end
function Tasks.ExecuteUpgradePlot()
	local Plot = select(1, GetPlayerPlot())
	if not Plot then
		return
	end
	if Remotes.RemotePlotUpgrade then
		pcall(function()
			Remotes.RemotePlotUpgrade:InvokeServer()
		end)
	end
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	pcall(function()
		for _, Desc in ipairs(Plot:GetDescendants()) do
			if
				string.find(string.lower(Desc.Name), "plotupgrade") or string.find(string.lower(Desc.Name), "expand")
			then
				if Desc:IsA("ProximityPrompt") and typeof(fireproximityprompt) == "function" then
					fireproximityprompt(Desc)
				elseif Desc:IsA("BasePart") and RootPart and (RootPart.Position - Desc.Position).Magnitude < 15 then
					if typeof(firetouchinterest) == "function" then
						firetouchinterest(RootPart, Desc, 0)
						task.wait(0.02)
						firetouchinterest(RootPart, Desc, 1)
					end
				end
			end
		end
	end)
end
function Tasks.EquipBestTrail()
	local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local Shop = PlayerGui and (PlayerGui:FindFirstChild("TrailShop") or PlayerGui:FindFirstChild("TrailShop", true))
	local Scroller = Shop and Shop:FindFirstChild("ScrollingFrame", true)
	if Scroller then
		for _, Id in ipairs(TrailCatalog) do
			local Frame = Scroller:FindFirstChild(Id, true)
			if Frame then
				for _, Desc in ipairs(Frame:GetDescendants()) do
					if Desc:IsA("GuiButton") or Desc:IsA("TextButton") then
						local Txt = string.lower((Desc:IsA("TextButton") and Desc.Text) or Desc.Name)
						if string.find(Txt, "equip") and not string.find(Txt, "unequip") then
							if typeof(firebutton1click) == "function" then
								firebutton1click(Desc)
							end
							if Remotes.RemoteTrailEquip then
								pcall(function()
									Remotes.RemoteTrailEquip:InvokeServer(Id)
								end)
							end
							return
						end
					end
				end
			end
		end
	end
	if Remotes.RemoteTrailEquip then
		for _, Id in ipairs(TrailCatalog) do
			local Ok = pcall(function()
				return Remotes.RemoteTrailEquip:InvokeServer(Id)
			end)
			if Ok then
				break
			end
		end
	end
end
function Tasks.BuyBestTrail()
	local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local Shop = PlayerGui and (PlayerGui:FindFirstChild("TrailShop") or PlayerGui:FindFirstChild("TrailShop", true))
	local Scroller = Shop and Shop:FindFirstChild("ScrollingFrame", true)
	if Scroller then
		for _, Id in ipairs(TrailCatalog) do
			local Frame = Scroller:FindFirstChild(Id, true)
			if Frame then
				for _, Desc in ipairs(Frame:GetDescendants()) do
					if Desc:IsA("GuiButton") or Desc:IsA("TextButton") then
						local Txt = string.lower((Desc:IsA("TextButton") and Desc.Text) or Desc.Name)
						if string.find(Txt, "buy") or string.find(Txt, "%$") then
							if typeof(firebutton1click) == "function" then
								firebutton1click(Desc)
							end
							if Remotes.RemoteTrailPurchase then
								pcall(function()
									Remotes.RemoteTrailPurchase:InvokeServer(Id)
								end)
							end
							return
						end
					end
				end
			end
		end
	end
end
function Tasks.ClaimOfflineMoney()
	if Remotes.RemoteAwayEarnings then
		pcall(function()
			Remotes.RemoteAwayEarnings:InvokeServer()
		end)
	end
end
local function ClaimIndexRewards(IncludeLimited: boolean)
	if IncludeLimited and Remotes.RemoteCodexRedeemLimited then
		for _, EggId in ipairs({ "LimitedEgg", "BrainrotEgg", "MonsterEgg" }) do
			pcall(function()
				Remotes.RemoteCodexRedeemLimited:InvokeServer(EggId)
			end)
		end
	end
	if Remotes.RemoteCodexRedeemAll then
		pcall(function()
			Remotes.RemoteCodexRedeemAll:InvokeServer()
		end)
	end
end
GetScrambleTradeStatusFn = function()
	local state, reqs = GetScrambleState(), GetScrambleRequirements()
	local wanted, summary, picks, reserved, slots = {}, {}, {}, {}, {}
	RuntimeState.ScrambleWanted, RuntimeState.ScrambleReserved = wanted, reserved
	Tasks.LabState.SlotPicks = slots
	if state.Unlocked ~= true or not DrScramble.LabBannerAllowed(state)
		or state.PendingReward or #reqs == 0 then return wanted, summary, picks, false end
	local ok, save = pcall(function()
		return SaveModule and ((SaveModule.Get and SaveModule.Get()) or (SaveModule.Peek and SaveModule.Peek()))
	end)
	if not ok or type(save) ~= "table" or type(save.EggInventory) ~= "table" then
		return wanted, summary, picks, false
	end
	local placed = {}
	if EggStateModule and type(EggStateModule.ReadOwnerEggs) == "function" then
		local readOk, eggs = pcall(EggStateModule.ReadOwnerEggs, LocalPlayer.UserId)
		if not readOk or type(eggs) ~= "table" then return wanted, summary, picks, false end
		for uid, record in pairs(eggs) do
			if type(record) == "table" and record.Placement ~= nil then placed[tostring(uid)] = true end
		end
	end
	local byCategory = {}
	for uid, record in pairs(save.EggInventory) do
		if type(record) == "table" and record.Placement == nil and not placed[tostring(uid)] then
			local key = ScrambleCleanName(record.AssetCategory or record.Category)
			byCategory[key] = byCategory[key] or {}
			table.insert(byCategory[key], {
				Uid = uid, Scale = tonumber(record.AssetScale) or 0,
				Mutated = (record.BaseMutation ~= nil and record.BaseMutation ~= "Normal")
					or (type(record.Mutations) == "table" and next(record.Mutations) ~= nil),
			})
		end
	end
	for _, eggs in pairs(byCategory) do
		table.sort(eggs, function(a, b)
			if a.Mutated ~= b.Mutated then return not a.Mutated end
			if a.Scale ~= b.Scale then return a.Scale < b.Scale end
			return tostring(a.Uid) < tostring(b.Uid)
		end)
	end
	local used, counts, totals, ready = {}, {}, {}, true
	for _, category in ipairs(reqs) do
		local key = ScrambleCleanName(category)
		totals[key] = (totals[key] or 0) + 1
	end
	for slot, category in ipairs(reqs) do
		local key, selected = ScrambleCleanName(category), nil
		for _, egg in ipairs(byCategory[key] or {}) do
			if not used[tostring(egg.Uid)] then selected = egg; break end
		end
		if selected then
			used[tostring(selected.Uid)] = true
			slots[slot] = selected.Uid
			table.insert(picks, selected.Uid) -- Preserve the server's original UID type.
			if FarmConfig.AutoScrambleSubmit or FarmConfig.AutoScrambleSteal then reserved[tostring(selected.Uid)] = true end
		else
			ready = false
			if FarmConfig.AutoScrambleSteal then wanted[key] = true end
		end
		counts[key] = (counts[key] or 0) + (selected and 1 or 0)
		table.insert(summary, string.format("%s (%d/%d)", tostring(category), counts[key], totals[key]))
	end
	return wanted, summary, picks, ready
end
-- BEGIN LAB STOCK CONTROLLER
-- Chili: StockTargets 8874+, inventory shortfall 75075+, recipe pools 36450+.
-- One quota per category across banners; feed the existing N3 picker only.
do
	local stock = { Wanted = {}, Reserved = {}, Targets = {}, Valid = false, NextAt = 0,
		Banners = {}, BannerOptions = {}, BannerIds = {}, Pools = {}, Pickers = {},
		EggOptions = {}, Categories = {}, Disposed = false, Loading = false, Generation = 0, RecipeWanted = {} }
	DrScramble.Stock = stock
	FarmConfig.LabStock_Banners = {}
	FarmConfig.LabStock_Eggs = {}
	FarmConfig.LabStock_PerEgg = 3
	local function addBanner(id, display)
		if id == nil then return end
		id = tostring(id)
		if stock.Banners[id] then return end
		local label = tostring(display or id)
		if stock.BannerIds[string.lower(label)] then label ..= " (" .. id .. ")" end
		stock.Banners[id] = label
		stock.BannerIds[string.lower(label)] = id
		table.insert(stock.BannerOptions, label)
	end
	for key, banner in pairs((ScrambleTradeInData and ScrambleTradeInData.Banners) or {}) do
		if type(banner) == "table" then
			addBanner(banner.Id or banner._id or (type(key) == "string" and key), banner.DisplayName)
		end
	end
	-- The game's rotation API also supplies canonical IDs when Banners is an array.
	pcall(function()
		local duration = tonumber(ScrambleTradeInData.RotationSeconds()) or 10800
		local period = math.floor(Workspace:GetServerTimeNow() / math.max(1, duration))
		for offset = 0, 11 do
			local id = ScrambleTradeInData.BannerIdForPeriod(period + offset)
			if id ~= nil then addBanner(id, ScrambleTradeInData.GetBannerDisplayName(id)) end
		end
	end)
	table.sort(stock.BannerOptions)
	for category, asset in pairs((AssetsModule and AssetsModule.Directory) or {}) do
		if type(asset) == "table" and asset.Rarity ~= nil and tonumber(asset.EarningRate) then
			local label = tostring(asset.DisplayName or category)
			if stock.Categories[string.lower(label)] then label ..= " [" .. tostring(category) .. "]" end
			stock.Categories[string.lower(label)] = tostring(category)
			table.insert(stock.EggOptions, label)
		end
	end
	table.sort(stock.EggOptions)
	function DrScramble.StockActive()
		return not stock.Disposed and not LibraryLoader.Unloaded
			and FarmConfig.AutoScrambleSteal == true and next(FarmConfig.LabStock_Banners) ~= nil
	end
	local function targets()
		local result = {}
		if not DrScramble.StockActive() then return result end
		for banner in pairs(FarmConfig.LabStock_Banners) do
			local pool = stock.Pools[banner] or {}
			for category in pairs(FarmConfig.LabStock_Eggs[banner] or {}) do
				if pool[category] then result[ScrambleCleanName(category)] = FarmConfig.LabStock_PerEgg end
			end
		end
		return result
	end
	function DrScramble.RefreshStock()
		if stock.Updating or os.clock() < stock.NextAt then return end
		stock.Updating = true
		stock.NextAt = os.clock() + 0.5
		local generation = stock.Generation
		stock.Targets, stock.Wanted, stock.Reserved, stock.Valid = targets(), {}, {}, false
		local ok = pcall(function()
			if next(stock.Targets) == nil then stock.Valid = true; return end
			SetElevated8()
			local save = SaveModule and ((SaveModule.Get and SaveModule.Get()) or (SaveModule.Peek and SaveModule.Peek()))
			if type(save) ~= "table" or type(save.EggInventory) ~= "table"
				or not EggStateModule or type(EggStateModule.ReadOwnerEggs) ~= "function" then return end
			local owned = EggStateModule.ReadOwnerEggs(LocalPlayer.UserId)
			if type(owned) ~= "table" or generation ~= stock.Generation or stock.Disposed then return end
			local placed, byCategory = {}, {}
			for uid, record in pairs(owned) do
				if type(record) == "table" and record.Placement ~= nil then placed[tostring(uid)] = true end
			end
			for uid, record in pairs(save.EggInventory) do
				if type(record) == "table" and record.Placement == nil and not placed[tostring(uid)] then
					local category = ScrambleCleanName(record.AssetCategory or record.Category)
					if stock.Targets[category] then
						byCategory[category] = byCategory[category] or {}
						table.insert(byCategory[category], { Uid = uid, Scale = tonumber(record.AssetScale) or 0,
							Mutated = (record.BaseMutation ~= nil and record.BaseMutation ~= "Normal")
								or (type(record.Mutations) == "table" and next(record.Mutations) ~= nil) })
					end
				end
			end
			for category, quota in pairs(stock.Targets) do
				local eggs = byCategory[category] or {}
				table.sort(eggs, function(a, b)
					if a.Mutated ~= b.Mutated then return not a.Mutated end
					if a.Scale ~= b.Scale then return a.Scale < b.Scale end
					return tostring(a.Uid) < tostring(b.Uid)
				end)
				if #eggs < quota then stock.Wanted[category] = true end
				for index = 1, math.min(quota, #eggs) do stock.Reserved[tostring(eggs[index].Uid)] = true end
			end
			stock.Valid = true
		end)
		if not ok or generation ~= stock.Generation or stock.Disposed then
			stock.Wanted, stock.Reserved, stock.Valid = {}, {}, false
		end
		for category in pairs(stock.Targets) do
			RuntimeState.ScrambleWanted[category] = (stock.Wanted[category] or stock.RecipeWanted[category]) or nil
		end
		stock.Updating = false
	end
	function DrScramble.HoldStockEgg(category, uid)
		if not DrScramble.StockActive() then return false end
		DrScramble.RefreshStock()
		local target = stock.Targets[ScrambleCleanName(category)]
		if not target then return false end
		-- If inventory is unavailable, hold selected materials, but don't steal blindly.
		return not stock.Valid or stock.Wanted[ScrambleCleanName(category)] == true
			or uid == nil or stock.Reserved[tostring(uid)] == true
	end
	local function updatePickers()
		for id, picker in pairs(stock.Pickers) do
			local disabled = {}
			for _, label in ipairs(stock.EggOptions) do
				local category = stock.Categories[string.lower(label)]
				if not (stock.Pools[id] or {})[category] then table.insert(disabled, label) end
			end
			picker:SetDisabledValues(disabled)
			picker:SetVisible(FarmConfig.LabStock_Banners[id] == true)
		end
	end
	function DrScramble.StockSettingsChanged()
		stock.Generation += 1
		stock.Wanted, stock.Reserved, stock.Targets, stock.Valid = {}, {}, targets(), false
		stock.NextAt = 0
		Tasks.LabState.Revision += 1
		if GetScrambleTradeStatusFn then GetScrambleTradeStatusFn() end
		updatePickers()
	end
	function DrScramble.LoadStockPools()
		if stock.Loading or stock.Disposed or LibraryLoader.Unloaded then return end
		stock.Loading = true
		local ok, message = pcall(function()
			SetElevated8()
			local shared = ReplicatedStorage:FindFirstChild("Shared")
			local modules = shared and shared:FindFirstChild("Modules")
			local module = modules and modules:FindFirstChild("ScrambleTradeInRecipes")
			local recipes = module and require(module)
			if type(recipes) ~= "table" or type(recipes.Simulate) ~= "function" then
				return "Recipe pools unavailable"
			end
			for id in pairs(stock.Banners) do
				if stock.Disposed or LibraryLoader.Unloaded then return end
				-- Same official game data API and sample budget as Chili. Not a live test.
				local sampled, result = pcall(recipes.Simulate, id, 4000)
				if stock.Disposed or LibraryLoader.Unloaded then return end
				if sampled and type(result) == "table" and type(result.SlotPicks) == "table" then
					local pool = stock.Pools[id] or {}
					for _, slot in pairs(result.SlotPicks) do
						for category, count in pairs(type(slot) == "table" and slot or {}) do
							if (tonumber(count) or 0) > 0 then pool[tostring(category)] = true end
						end
					end
					stock.Pools[id] = pool
				end
				task.wait()
			end
		end)
		stock.Loading = false
		if stock.Disposed or LibraryLoader.Unloaded then return end
		if not ok or message then
			LibraryLoader:Notify(message or "Recipe pool read failed", 4)
		end
		DrScramble.StockSettingsChanged()
	end
	-- Remember real observed recipes too; don't substitute a fabricated species pool.
	local nativeStatus = GetScrambleTradeStatusFn
	GetScrambleTradeStatusFn = function()
		local wanted, summary, picks, ready = nativeStatus()
		stock.RecipeWanted = table.clone(wanted)
		local state = GetScrambleState()
		if state.BannerId ~= nil and type(state.Requirements) == "table" then
			local id = tostring(state.BannerId)
			stock.Pools[id] = stock.Pools[id] or {}
			for _, category in ipairs(state.Requirements) do stock.Pools[id][tostring(category)] = true end
		end
		DrScramble.RefreshStock()
		if DrScramble.StockActive() then
			for category in pairs(stock.Wanted) do wanted[category] = true end
		end
		return wanted, summary, picks, ready
	end
	function DrScramble.BuildStockUI(group)
		group:AddDropdown("Dropdown_LabStock_Banners", {
			Text = "Stock Banners", Values = stock.BannerOptions, Default = {}, Multi = true, AllowNull = true,
			Callback = function(value)
				local banners = {}
				for label in pairs(ParseMultiDropdownSelection(value)) do
					local id = stock.BannerIds[label]
					if id then banners[id] = true end
				end
				FarmConfig.LabStock_Banners = banners
				DrScramble.StockSettingsChanged()
			end,
		})
		for _, label in ipairs(stock.BannerOptions) do
			local id = stock.BannerIds[string.lower(label)]
			stock.Pickers[id] = group:AddDropdown("Dropdown_LabStock_Eggs_" .. id, {
				Text = label .. " Eggs", Values = stock.EggOptions, Default = {}, Multi = true,
				AllowNull = true, Searchable = true,
				Callback = function(value)
					local selected = {}
					for name in pairs(ParseMultiDropdownSelection(value)) do
						local category = stock.Categories[name]
						if category then selected[category] = true end
					end
					FarmConfig.LabStock_Eggs[id] = selected
					DrScramble.StockSettingsChanged()
				end,
			})
		end
		group:AddSlider("Slider_LabStock_PerEgg", {
			Text = "Stock Per Egg", Min = 1, Max = 30, Default = 3, Rounding = 0,
			Callback = function(value)
				FarmConfig.LabStock_PerEgg = math.clamp(math.floor(tonumber(value) or 3), 1, 30)
				DrScramble.StockSettingsChanged()
			end,
		})
		group:AddButton("Refresh Pools", function() task.spawn(DrScramble.LoadStockPools) end)
		updatePickers()
		task.spawn(DrScramble.LoadStockPools)
	end
	LibraryLoader:OnUnload(function()
		stock.Disposed = true
		stock.Generation += 1
		stock.Wanted, stock.Reserved, stock.Targets = {}, {}, {}
	end)
end
-- END LAB STOCK CONTROLLER

function DrScramble.LabActionAllowed()
	-- Like Chili, this operates on owned inventory, not the character/field carry.
	-- A busy egg farm must not starve a ready recipe; race still has user priority.
	return not LibraryLoader.Unloaded and not RaceOwnsCharacter()
		and not (Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal())
end
function DrScramble.RunLabAction(kind)
	local lab = Tasks.LabState
	local function enabled()
		return (kind == "trade" and FarmConfig.AutoScrambleSubmit)
			or (kind == "reroll" and FarmConfig.Scramble_AutoReroll)
	end
	if lab.FetchBusy or lab.ActionBusy or os.clock() < lab.NextActionAt or not enabled()
		or not DrScramble.LabActionAllowed() then return false end
	lab.ActionBusy = true
	lab.NextActionAt = os.clock() + 1
	local revision = lab.Revision
	local function cancelled()
		return revision ~= lab.Revision or not enabled() or not DrScramble.LabActionAllowed()
	end
	local ok, changed = pcall(function()
		local state = RefreshScrambleState(true)
		if cancelled() or state.Unlocked ~= true or os.clock() - lab.StateAt > 5 then return false end
		local remote, picks
		-- A previously accepted reward belongs to us even if its banner is filtered.
		if state.PendingReward then
			remote = Remotes.RemoteScrambleFinishReveal
		elseif not DrScramble.LabBannerAllowed(state) then
			GetScrambleTradeStatusFn() -- Clear reservations/targets for a disallowed banner.
			return false
		else
			local _, _, selection, ready = GetScrambleTradeStatusFn()
			if kind == "reroll" then
				if ready or (tonumber(state.FreeRefreshesRemaining) or 0) <= 0 then return false end
				remote = Remotes.RemoteScrambleRefresh
			else
				if not ready or #selection ~= #GetScrambleRequirements() or #selection < SCRAMBLE_TRADE_SLOTS then return false end
				remote, picks = Remotes.RemoteScrambleTradeIn, selection
			end
		end
		if not remote or cancelled() then return false end
		local accepted, result, extra = pcall(function()
			if picks then return remote:InvokeServer(picks) end
			return remote:InvokeServer()
		end)
		if accepted and result ~= false then
			-- Never send a follow-up reveal from this task after OFF/race takeover.
			-- The next enabled action reads PendingReward from a fresh state instead.
			if picks and type(extra) == "table" then
				local category = extra.AssetCategory or extra.Category or extra.Name
				if type(category) == "string" and category ~= "" then RuntimeState.ScrambleLabCategory = category end
			end
			Tasks.InvalidateLabState()
			return true
		end
		lab.LastError = tostring(accepted and extra or result)
		return false
	end)
	lab.ActionBusy = false
	lab.NextActionAt = os.clock() + 1
	if not ok then lab.LastError = tostring(changed) end
	return ok and changed == true
end
function DrScramble.AutoRerollLab()
	return DrScramble.RunLabAction("reroll")
end
local function ExecuteScrambleTradeIn()
	return DrScramble.RunLabAction("trade")
end
function Tasks.GetScrambleOverview()
	local state = GetScrambleState()
	local reqs = (type(state.Requirements) == "table" and state.Requirements) or CachedScrambleReqs
	local wantedMap, summaryList, picks, ready = GetScrambleTradeStatusFn()
	local unlockPower = tonumber(state.UnlockSpeedPower) or 0
	local myPower = 0
	pcall(function()
		local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
		local speedStat = leaderstats and leaderstats:FindFirstChild("Speed")
		myPower = tonumber(speedStat and speedStat.Value) or 0
	end)
	return {
		State = state,
		Requirements = reqs,
		Summary = summaryList,
		Picks = picks,
		Ready = ready,
		Wanted = wantedMap,
		BannerName = tostring(state.BannerDisplayName or state.BannerId or "Unknown"),
		BannerIcon = tostring(state.BannerEggIcon or ""),
		SecondsLeft = tonumber(state.SecondsUntilRotation) or 0,
		FreeRefreshes = tonumber(state.FreeRefreshesRemaining) or 0,
		PityCount = tonumber(state.PityCount) or 0,
		PityThreshold = tonumber(state.PityThreshold) or 0,
		Unlocked = state.Unlocked == true,
		SlotPicks = Tasks.LabState.SlotPicks or {},
		UnlockPower = unlockPower,
		MyPower = myPower,
		PetOdds = type(state.PetOdds) == "table" and state.PetOdds or {},
		BannerOdds = type(state.BannerOdds) == "table" and state.BannerOdds or {},
	}
end
local function GetGameEggData(IncludeEventEggs)
	local MyUserId = LocalPlayer.UserId
	local rawEggs = {}
	if EggStateModule and type(EggStateModule.ReadOwnerEggs) == "function" then
		pcall(function()
			local res = EggStateModule.ReadOwnerEggs(MyUserId)
			if type(res) == "table" then
				for uid, rec in pairs(res) do
					if type(rec) == "table" then
						rawEggs[tostring(uid)] = rec
					end
				end
			end
		end)
	end
	if SaveModule and type(SaveModule.Peek) == "function" then
		pcall(function()
			local s = SaveModule.Peek()
			if s and type(s.EggInventory) == "table" then
				for uid, rec in pairs(s.EggInventory) do
					if type(rec) == "table" and not rawEggs[tostring(uid)] then
						rawEggs[tostring(uid)] = rec
					end
				end
			end
		end)
	end
	local serverTimeNow = Workspace:GetServerTimeNow()
	local parsedList = {}
	for uidKey, eggData in pairs(rawEggs) do
		if type(eggData) == "table" then
			local uid = tostring(eggData.Uid or uidKey)
			local cat = tostring(eggData.AssetCategory or eggData.Category or eggData.Name or "Egg")
			if Tasks.IsEventEgg(cat) and IncludeEventEggs ~= true then
				continue
			end
			local scale = tonumber(eggData.AssetScale or eggData.Scale) or 1
			local muts = eggData.Mutations or {}
			if type(muts) ~= "table" then
				muts = {}
			end
			local info = ResolveGameAsset(cat)
			local placementData = type(eggData.Placement) == "table" and eggData.Placement or nil
			local zoneValue = eggData.Zone
				or eggData.Area
				or eggData.AreaId
				or (placementData and (placementData.Zone or placementData.AreaId or placementData.Area))
				or info.Area
			local zoneName = tostring(zoneValue or "Unknown")
			local chanceValue = eggData.ChancePercent
				or eggData.SpawnChancePercent
				or eggData.DropChancePercent
				or eggData.Chance
				or eggData.SpawnChance
				or eggData.DropChance
				or info.Chance
			local sf = scale > 5 and ((scale / 5) ^ 1.2 * 19.637875755794113) or (scale ^ 1.85)
			local finalIncome = 0
			if (info.EarningRate or 0) > 0 then
				local mutMult = 1
				pcall(function()
					local MutMod = require(ReplicatedStorage.Shared.Modules.Mutations)
					if MutMod and MutMod.EarningsFor then
						mutMult = MutMod.EarningsFor(muts)
					end
				end)
				finalIncome = math.max(1, math.floor((info.EarningRate or 0) * sf * (tonumber(mutMult) or 1)))
			end
			local weightKg = 0
			if EggRecordsModule and type(EggRecordsModule.WeightKg) == "function" then
				pcall(function()
					weightKg = EggRecordsModule.WeightKg(eggData)
				end)
			end
			if
				(not weightKg or weightKg == 0)
				and EggRecordsModule
				and type(EggRecordsModule.WeightKgForScale) == "function"
			then
				pcall(function()
					weightKg = EggRecordsModule.WeightKgForScale(cat, scale)
				end)
			end
			if not weightKg or weightKg == 0 then
				weightKg = math.floor(scale * 20)
			end
			local statusType = "Inventory"
			local statusText = "In inventory"
			local isReady = false
			local remainingSeconds = math.huge
			local growthPercent = 0
			if eggData.Placement ~= nil then
				local checkReady = EggStateModule and (EggStateModule.IsReadyToHatch or EggStateModule.IsLocalEggReady)
				if checkReady then
					pcall(function()
						isReady = checkReady(uid)
					end)
				end
				if isReady then
					statusType = "Ready"
					statusText = "Ready to hatch"
					remainingSeconds = 0
					growthPercent = 100
				else
					local placedAt = eggData.Placement.PlacedAt or eggData.Placement.Time or 0
					local growthDur = 30
					if
						AssetsModule
						and AssetsModule.Directory
						and AssetsModule.Directory[cat]
						and AssetsModule.Directory[cat].Egg
					then
						growthDur = tonumber(AssetsModule.Directory[cat].Egg.GrowthTime) or 30
					end
					local mult = math.max(tonumber(eggData.GrowthSpeedMultiplier) or 1, 0.01)
					local remSec = math.max(0, (placedAt + (growthDur / mult)) - serverTimeNow)
					if remSec <= 0 then
						statusType = "Ready"
						statusText = "Ready to hatch"
						isReady = true
						remainingSeconds = 0
						growthPercent = 100
					else
						statusType = "Growing"
						remainingSeconds = remSec
						statusText = FormatTimeLeft(remSec)
						growthPercent = math.clamp(math.floor((1 - (remSec / growthDur)) * 100), 0, 100)
					end
				end
			end
			local mutLabel = ""
			if #muts > 0 and tostring(muts[1]):lower() ~= "none" then
				mutLabel = string.upper(tostring(muts[1]))
			end
			table.insert(parsedList, {
				Uid = uid,
				Category = cat,
				Name = info.Name,
				Rarity = info.Rarity,
				RarityRank = info.RarityRank,
				Scale = scale,
				Weight = weightKg,
				Income = finalIncome,
				StatusType = statusType,
				StatusText = statusText,
				IsReady = isReady,
				Remaining = remainingSeconds,
				Percent = growthPercent,
				Mutation = mutLabel,
				Icon = info.Icon,
				EggIcon = info.EggIcon,
				EggName = info.EggName,
				GrowthTime = info.GrowthTime,
				Zone = zoneName,
				Chance = chanceValue,
			})
		end
	end
	return parsedList
end
local GetPet3DModel, GetTotalGameCatalogPets
do
	local _Pet3DByName = {}
	local function GetPet3DModelRaw(petCategoryName)
		if not petCategoryName or petCategoryName == "" then
			return nil
		end
		local assetModels = ReplicatedStorage:FindFirstChild("AssetModels")
			or (ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Models"))
			or ReplicatedStorage:FindFirstChild("Models")
		if not assetModels then
			return nil
		end
		local cleanTarget = string.gsub(string.lower(tostring(petCategoryName)), "[^%a%d]", "")
		local foundSource = nil
		foundSource = assetModels:FindFirstChild(tostring(petCategoryName))
		if not foundSource then
			for _, child in ipairs(assetModels:GetChildren()) do
				local cleanChild = string.gsub(string.lower(child.Name), "[^%a%d]", "")
				if
					cleanChild == cleanTarget
					or string.find(cleanChild, cleanTarget, 1, true)
					or string.find(cleanTarget, cleanChild, 1, true)
				then
					foundSource = child
					break
				end
			end
		end
		if foundSource then
			local innerModel = foundSource:FindFirstChild("Model") or foundSource:FindFirstChildWhichIsA("Model")
			if innerModel and innerModel:IsA("Model") then
				return innerModel
			elseif foundSource:IsA("Model") or foundSource:IsA("BasePart") then
				return foundSource
			elseif foundSource:IsA("Folder") then
				local tempModel = Instance.new("Model")
				tempModel.Name = foundSource.Name
				for _, ch in ipairs(foundSource:GetChildren()) do
					if ch:IsA("BasePart") or ch:IsA("Model") then
						ch:Clone().Parent = tempModel
					end
				end
				return tempModel
			end
		end
		return nil
	end
	function GetPet3DModel(petCategoryName)
		if not petCategoryName or petCategoryName == "" then
			return nil
		end
		local memo = _Pet3DByName[petCategoryName]
		if memo == nil then
			local ok, res = pcall(GetPet3DModelRaw, petCategoryName)
			memo = (ok and res) or false
			_Pet3DByName[petCategoryName] = memo
		end
		return memo or nil
	end
	local _CatalogCache, _CatalogCacheAt = nil, 0
	function GetTotalGameCatalogPets()
		local now = os.clock()
		if _CatalogCache and (now - _CatalogCacheAt) < 120 then
			return _CatalogCache
		end
		local allCatalog = {}
		local seen = {}
		if AssetsModule and type(AssetsModule.Directory) == "table" then
			for cat, val in pairs(AssetsModule.Directory) do
				if type(val) == "table" and val.Rarity and not seen[cat] then
					seen[cat] = true
					table.insert(allCatalog, {
						Name = cat,
						Area = tostring(val.Area or "World"),
					})
				end
			end
		end
		if #allCatalog == 0 and ConfigsFolder then
			for _, areaMod in ipairs(ConfigsFolder:GetChildren()) do
				if areaMod:IsA("ModuleScript") then
					local ok, data = pcall(require, areaMod)
					if ok and type(data) == "table" and data.DropTable then
						for _, entry in ipairs(data.DropTable) do
							local petName = entry[1]
							if petName and not seen[petName] then
								seen[petName] = true
								table.insert(allCatalog, {
									Name = petName,
									Area = areaMod.Name:gsub("Config", ""),
								})
							end
						end
					end
				end
			end
		end
		_CatalogCache = allCatalog
		_CatalogCacheAt = now
		return allCatalog
	end
end
local function GetIndexStatistics()
	local totalCatalog = GetTotalGameCatalogPets()
	local sData = nil
	if SaveModule and type(SaveModule.Peek) == "function" then
		pcall(function()
			sData = SaveModule.Peek()
		end)
	end
	local indexMap = (sData and type(sData.Index) == "table") and sData.Index or {}
	local claimedMap = (sData and type(sData.IndexClaimedCategories) == "table") and sData.IndexClaimedCategories or {}
	local unlockedCount = 0
	local unclaimedCount = 0
	local missingList = {}
	for _, item in ipairs(totalCatalog) do
		if indexMap[item.Name] == true then
			unlockedCount = unlockedCount + 1
			if claimedMap[item.Name] ~= true then
				unclaimedCount = unclaimedCount + 1
			end
		else
			local info = ResolveGameAsset(item.Name)
			table.insert(missingList, {
				Name = item.Name,
				DisplayName = info.Name,
				Rarity = info.Rarity,
				RarityRank = info.RarityRank,
				Color = info.Color,
				Area = item.Area,
				ZoneWeight = AreaWeights[item.Area] or 50,
				Icon = info.Icon,
			})
		end
	end
	local percent = (#totalCatalog > 0) and math.floor((unlockedCount / #totalCatalog) * 100) or 0
	return unlockedCount, #totalCatalog, percent, unclaimedCount, missingList
end
local function BuildPetDescription(egg)
	local Lines = {
		string.format('<font color="#57F287"><b>%s</b></font>', FormatCash(egg.Income) .. "/s"),
		string.format("<b>%.2fx</b> - <b>%s Kg</b>", egg.Scale or 1, FormatCash(egg.Weight)),
	}
	if egg.Mutation and egg.Mutation ~= "" then
		table.insert(Lines, string.format('<font color="#FFAA00"><b>%s</b></font>', string.upper(egg.Mutation)))
	end
	if egg.StatusText and egg.StatusText ~= "" then
		local StatusColor = egg.IsReady and "#57F287" or (egg.StatusType == "Inventory" and "#38BDF8" or "#FFAA00")
		table.insert(Lines, string.format('<font color="%s"><b>%s</b></font>', StatusColor, egg.StatusText))
	end
	return table.concat(Lines, "\n")
end
local FolderEspMaster = Workspace:FindFirstChild("N3_MasterESP") or Instance.new("Folder", Workspace)
FolderEspMaster.Name = "N3_MasterESP"
local ActiveEspCards = {}
local PlayerAvatarCache = {}
local WaypointLocations = {
	["Base / Plot"] = Vector3.new(464.7, 70.4, -364.0),
	["Forest"] = Vector3.new(596.0, 68.0, -328.0),
	["Lake"] = Vector3.new(744.0, 68.5, -408.0),
	["Desert"] = Vector3.new(948.0, 69.5, -323.0),
	["Jungle"] = Vector3.new(1188.0, 68.5, -408.0),
	["Snow"] = Vector3.new(1492.0, 69.0, -315.0),
	["Volcano"] = Vector3.new(1882.0, 68.0, -398.0),
	["Abyss Ocean"] = Vector3.new(2280.0, 68.0, -326.0),
	["Prehistoric"] = Vector3.new(2812.0, 69.0, -398.0),
	["Cosmic"] = Vector3.new(3390.0, 68.0, -324.0),
	["Cherry Blossom"] = Vector3.new(4028.0, 68.5, -396.0),
	["Titan Temple"] = Vector3.new(4796.0, 69.5, -328.0),
	["Light Dark"] = Vector3.new(5350.0, 70.0, -364.0),
	["Fuse Machine"] = Vector3.new(532.0, 72.0, -283.0),
	["Dr Scramble Event"] = Vector3.new(5931.0, 73.6, -397.2),
}
local WaypointNames = {}
for name in pairs(WaypointLocations) do
	table.insert(WaypointNames, name)
end
table.sort(WaypointNames)
local CardRows = { Icon = 3.2, Name = 1.35, Rarity = 1.2, Mutation = 1, Value = 1.1, Info = 1 }
local function CardSeq(listIn)
	local arr = table.create(#listIn)
	for i = 1, #listIn do
		arr[i] = ColorSequenceKeypoint.new(listIn[i][1], listIn[i][2])
	end
	return ColorSequence.new(arr)
end
local CardGradientByColor = {}
local CardGradientByName = {}
local function CardPaletteFromColor(c)
	local key = tostring(c)
	local hit = CardGradientByColor[key]
	if hit then
		return hit
	end
	local white = Color3.fromRGB(255, 255, 255)
	local black = Color3.fromRGB(0, 0, 0)
	local pal = {
		Text = CardSeq({
			{ 0, c:Lerp(white, 0.5) },
			{ 0.4, c:Lerp(white, 0.1) },
			{ 1, c:Lerp(black, 0.25) },
		}),
		Stroke = CardSeq({
			{ 0, c:Lerp(black, 0.55) },
			{ 0.55, c:Lerp(black, 0.75) },
			{ 1, c:Lerp(black, 0.92) },
		}),
		Outline = c:Lerp(white, 0.25),
		Rotation = 90,
	}
	CardGradientByColor[key] = pal
	return pal
end
Tasks.CardGreen = {
	Text = CardSeq({
		{ 0, Color3.fromRGB(128, 255, 170) },
		{ 0.4, Color3.fromRGB(77, 255, 122) },
		{ 1, Color3.fromRGB(20, 160, 70) },
	}),
	Stroke = CardSeq({
		{ 0, Color3.fromRGB(10, 52, 6) },
		{ 1, Color3.fromRGB(3, 16, 0) },
	}),
	Outline = Color3.fromRGB(58, 255, 55),
	Rotation = 90,
}
local CardSheen = {
	Text = CardSeq({
		{ 0, Color3.fromRGB(255, 255, 255) },
		{ 0.5, Color3.fromRGB(222, 222, 222) },
		{ 1, Color3.fromRGB(255, 255, 255) },
	}),
	Stroke = CardSeq({
		{ 0, Color3.fromRGB(8, 8, 8) },
		{ 1, Color3.fromRGB(8, 8, 8) },
	}),
	Outline = Color3.fromRGB(255, 255, 255),
	Rotation = 90,
}
local function CardRarityGradientByName(rarityName)
	local name = tostring(rarityName or "")
	local hit = CardGradientByName[name]
	if hit then
		return hit
	end
	local res = nil
	pcall(function()
		local rarityGradients = ReplicatedStorage:FindFirstChild("Assets")
		rarityGradients = rarityGradients and rarityGradients:FindFirstChild("UI")
		rarityGradients = rarityGradients and rarityGradients:FindFirstChild("RarityGradients")
		if rarityGradients then
			local rarityFolder = rarityGradients:FindFirstChild(name)
			local gradInst = rarityFolder and rarityFolder:FindFirstChild("RarityGradient")
			if gradInst and gradInst:IsA("UIGradient") then
				res = {
					Text = gradInst.Color,
					Stroke = CardSeq({
						{ 0, Color3.fromRGB(8, 8, 8) },
						{ 1, Color3.fromRGB(8, 8, 8) },
					}),
					Outline = Color3.fromRGB(255, 255, 255),
					Rotation = gradInst.Rotation or 90,
				}
			end
		end
	end)
	if not res then
		local base = DefaultRarityColors[name] or Color3.fromRGB(255, 255, 255)
		res = CardPaletteFromColor(base)
	end
	if string.upper(name) == "SECRET" then
		res = CardPaletteFromColor(Color3.fromRGB(255, 216, 61))
		res.Rotation = 90
	end
	CardGradientByName[name] = res
	return res
end
function InstanUtility.FormatEggLabel(name, rarityName)
	local fname = tostring(name or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	local rtext = string.upper(tostring(rarityName or "")):gsub("&", "&amp;"):gsub("<", "&lt;")
	local hex = "#FFFFFF"
	local pal = CardRarityGradientByName(rarityName)
	if type(pal) == "table" then
		local seq = pal.Text
		if typeof(seq) == "ColorSequence" and seq.Keypoints[1] then
			hex = ColorToHex(seq.Keypoints[1].Value)
		elseif typeof(pal.Outline) == "Color3" then
			hex = ColorToHex(pal.Outline)
		end
	end
	local glow = string.format('<stroke color="%s" thickness="1.6" transparency="0.3" joins="round">', hex)
	return string.format('<b>%s</b>  %s<font color="%s"><b>%s</b></font></stroke>', fname, glow, hex, rtext)
end
local function CardCreateTextRow(parent, layoutOrder)
	local frame = Instance.new("Frame")
	frame.Name = "CardTextRow"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = UDim2.fromScale(1, 1)
	frame.LayoutOrder = layoutOrder
	frame.Parent = parent
	local function mk(z)
		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Size = UDim2.fromScale(1, 1)
		lbl.Text = ""
		lbl.TextScaled = true
		lbl.TextStrokeTransparency = 1
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.TextYAlignment = Enum.TextYAlignment.Center
		lbl.ZIndex = z
		lbl.Font = Enum.Font.GothamBold
		lbl.Parent = frame
		return lbl
	end
	local shadow = mk(2)
	shadow.Position = UDim2.fromOffset(1, 1)
	shadow.TextColor3 = Color3.new(0, 0, 0)
	shadow.TextTransparency = 0.1
	local lbl = mk(3)
	lbl.TextColor3 = Color3.new(1, 1, 1)
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Transparency = 0.05
	pcall(function()
		stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	end)
	stroke.Thickness = 0.05
	stroke.Parent = lbl
	local strokeGrad = Instance.new("UIGradient")
	strokeGrad.Rotation = 90
	strokeGrad.Parent = stroke
	local textGrad = Instance.new("UIGradient")
	textGrad.Rotation = 90
	textGrad.Parent = lbl
	return {
		Holder = frame,
		Shadow = shadow,
		Label = lbl,
		StrokeGradient = strokeGrad,
		TextGradient = textGrad,
		Palette = nil,
	}
end
local function CardSetRow(row, text, palette)
	if row.Label.Text ~= text then
		row.Label.Text = text
		row.Shadow.Text = text
	end
	if row.Palette ~= palette then
		row.Palette = palette
		row.TextGradient.Color = palette.Text
		row.TextGradient.Rotation = palette.Rotation or 90
		if palette.Stroke then
			row.StrokeGradient.Color = palette.Stroke
		end
	end
end
function Tasks.GetEggValue(rec, info)
	local scale = tonumber(rec.AssetScale or rec.Scale) or 1
	local sf = scale > 5 and ((scale / 5) ^ 1.2 * 19.637875755794113) or (scale ^ 1.85)
	local base = (info and info.EarningRate) or 0
	if base <= 0 then
		return 0
	end
	local muts = (type(rec.Mutations) == "table" and rec.Mutations) or {}
	local mult = 1
	pcall(function()
		local MutMod = require(ReplicatedStorage.Shared.Modules.Mutations)
		if MutMod and MutMod.EarningsFor then
			mult = MutMod.EarningsFor(muts)
		end
	end)
	return math.max(1, math.floor(base * sf * (tonumber(mult) or 1)))
end
local function CardFormatNum(num)
	num = tonumber(num) or 0
	local marks = { "", "K", "M", "B", "T", "Qa", "Qi" }
	local idx = 1
	while math.abs(num) >= 1000 and idx < #marks do
		num = num / 1000
		idx = idx + 1
	end
	return string.format(idx == 1 and "%.0f%s" or "%.2f%s", num, marks[idx])
end
local activeEggCards = 0
local function CreateMasterCard()
	local anchor = Instance.new("Part")
	anchor.Name = "EspAnchor"
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = false
	anchor.CanTouch = false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(0.2, 0.2, 0.2)
	anchor.Parent = FolderEspMaster
	local bb = Instance.new("BillboardGui")
	bb.Name = "MasterCardGui"
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = 1e6
	bb.Size = UDim2.fromOffset(120, 6)
	bb.StudsOffset = Vector3.new(0, 3.2, 0)
	bb.Adornee = anchor
	bb.Parent = anchor
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromScale(1, 1)
	frame.ClipsDescendants = true
	frame.Parent = bb
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = frame
	local iconHolder = Instance.new("Frame")
	iconHolder.Name = "CardIconHolder"
	iconHolder.BackgroundTransparency = 1
	iconHolder.BorderSizePixel = 0
	iconHolder.Size = UDim2.fromScale(1, 0)
	iconHolder.Parent = frame
	iconHolder.LayoutOrder = 0
	local icon = Instance.new("ImageLabel")
	icon.Name = "CardIcon"
	icon.AnchorPoint = Vector2.new(0.5, 1)
	icon.BackgroundTransparency = 1
	icon.Position = UDim2.fromScale(0.5, 1)
	icon.Size = UDim2.fromScale(1, 1)
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = iconHolder
	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 1
	aspect.DominantAxis = Enum.DominantAxis.Height
	aspect.Parent = icon
	local nameRow = CardCreateTextRow(frame, 1)
	local rarityRow = CardCreateTextRow(frame, 2)
	local mutationRow = CardCreateTextRow(frame, 3)
	local valueRow = CardCreateTextRow(frame, 4)
	local extraRow = CardCreateTextRow(frame, 5)
	local card = {
		Anchor = anchor,
		Billboard = bb,
		Frame = frame,
		IconHolder = iconHolder,
		Icon = icon,
		NameRow = nameRow,
		RarityRow = rarityRow,
		MutationRow = mutationRow,
		ValueRow = valueRow,
		ExtraRow = extraRow,
		Highlight = nil,
		ShowIcon = false,
		ShowName = true,
		ShowRarity = false,
		ShowMutation = false,
		ShowValue = false,
		ShowExtra = false,
		Width = nil,
		Height = nil,
	}
	local function reframe()
		local total = 0
		local vis = {
			{ iconHolder, CardRows.Icon, card.ShowIcon },
			{ nameRow.Holder, CardRows.Name, card.ShowName },
			{ rarityRow.Holder, CardRows.Rarity, card.ShowRarity },
			{ mutationRow.Holder, CardRows.Mutation, card.ShowMutation },
			{ valueRow.Holder, CardRows.Value, card.ShowValue },
			{ extraRow.Holder, CardRows.Info, card.ShowExtra },
		}
		for _, v in ipairs(vis) do
			if v[3] then
				total = total + v[2]
			end
		end
		total = math.max(total, 1)
		for _, v in ipairs(vis) do
			v[1].Visible = v[3]
			v[1].Size = UDim2.fromScale(1, v[3] and (v[2] / total) or 0)
		end
		local cam = workspace.CurrentCamera
		local rowH = math.max(6, math.floor(math.clamp((cam and cam.ViewportSize.Y or 1080) * 0.014, 13, 19)))
		local h = math.max(1, math.floor(rowH * total))
		bb.Size = UDim2.fromOffset(120, h)
	end
	card.ReLayout = reframe
	reframe()
	return card
end
local function DestroyEggCard(card)
	if card.Highlight then
		pcall(function()
			card.Highlight:Destroy()
		end)
		card.Highlight = nil
	end
	activeEggCards = math.max(0, activeEggCards - 1)
	if card.Anchor then
		pcall(function()
			card.Anchor:Destroy()
		end)
	end
end
function Tasks.CardRenderEggKey(key, rec, info, pos, ctx)
	local seen = ctx.Seen
	local myPos = ctx.MyPos
	local maxDist = ctx.MaxDist
	local cf = typeof(pos) == "CFrame" and pos or CFrame.new(pos)
	local dist = (cf.Position - myPos).Magnitude
	if dist > maxDist then
		return
	end
	if FarmConfig.ESP_MinRarity and FarmConfig.ESP_MinRarity > 0 then
		local rank = RarityRankOf((info and info.Rarity) or "Common")
		if not rank or rank < FarmConfig.ESP_MinRarity then
			return
		end
	end
	local value = Tasks.GetEggValue(rec, info)
	if FarmConfig.ESP_MinValue and FarmConfig.ESP_MinValue > 0 and value < FarmConfig.ESP_MinValue then
		return
	end
	seen[key] = true
	local card = ActiveEspCards[key]
	if not card or not card.Anchor.Parent or not card.EggMode then
		if card and card.Anchor.Parent then
			DestroyEggCard(card)
		end
		card = CreateMasterCard()
		card.EggMode = true
		ActiveEspCards[key] = card
	end
	local showInfo = FarmConfig.ESP_ShowInfo or {}
	local rarityName = tostring((info and info.Rarity) or "Common")
	local rarityPal = CardRarityGradientByName(rarityName)
	local hasIcon = showInfo.Icon and (info.Icon or "") ~= ""
	if hasIcon and card.Icon.Image ~= tostring(info.Icon) then
		card.Icon.Image = tostring(info.Icon)
	end
	local showName = showInfo.Name ~= false
	if showName then
		CardSetRow(card.NameRow, tostring(info.DisplayName or info.Name or "Egg"), CardSheen)
	end
	local showRarity = showInfo.Rarity and rarityName ~= ""
	if showRarity then
		CardSetRow(card.RarityRow, string.upper(rarityName), rarityPal)
	end
	local baseMut = tostring(rec.BaseMutation or "")
	if baseMut == "" and type(rec.Mutations) == "table" and rec.Mutations[1] then
		baseMut = tostring(rec.Mutations[1])
	end
	local showMutation = showInfo.Mutation and baseMut ~= "" and string.lower(baseMut) ~= "none"
	if showMutation then
		CardSetRow(card.MutationRow, string.upper(baseMut), CardRarityGradientByName(baseMut))
	end
	local showValue = showInfo.Value and value > 0
	if showValue then
		CardSetRow(card.ValueRow, "$" .. CardFormatNum(value) .. "/s", Tasks.CardGreen)
	end
	local extras = {}
	if showInfo.Weight and EggRecordsModule and type(EggRecordsModule.WeightKgForScale) == "function" then
		pcall(function()
			local kg = EggRecordsModule.WeightKgForScale(rec.AssetCategory, tonumber(rec.AssetScale) or 1)
			if kg and tonumber(kg) then
				extras[#extras + 1] = CardFormatNum(tonumber(kg)) .. " kg"
			end
		end)
	end
	if showInfo.Size then
		extras[#extras + 1] = string.format("x%.2f", tonumber(rec.AssetScale) or 1)
	end
	if showInfo.Distance then
		extras[#extras + 1] = string.format("%dm", math.floor(dist + 0.5))
	end
	if showInfo.Area and rec.AreaId and rec.AreaId ~= nil then
		extras[#extras + 1] = tostring(rec.AreaId)
	end
	if showInfo.State and rec.State and rec.State ~= "Slot" then
		extras[#extras + 1] = tostring(rec.State)
	end
	local showExtra = #extras > 0
	if showExtra then
		CardSetRow(card.ExtraRow, table.concat(extras, "  |  "), CardSheen)
	end
	if
		card.ShowIcon ~= hasIcon
		or card.ShowName ~= showName
		or card.ShowRarity ~= showRarity
		or card.ShowMutation ~= showMutation
		or card.ShowValue ~= showValue
		or card.ShowExtra ~= showExtra
	then
		card.ShowIcon = hasIcon
		card.ShowName = showName
		card.ShowRarity = showRarity
		card.ShowMutation = showMutation
		card.ShowValue = showValue
		card.ShowExtra = showExtra
		card:ReLayout()
	end
	if FarmConfig.ESP_HighlightMode and FarmConfig.ESP_HighlightMode ~= "Off" and rec.PhysicalModel then
		local want = FarmConfig.ESP_HighlightMode == "All Shown" or FarmConfig.ESP_HighlightMode == "Rare Only"
		if want then
			if not card.Highlight then
				local mk = Instance.new("Highlight")
				mk.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				mk.FillTransparency = 0.82
				mk.OutlineTransparency = 0.05
				mk.FillColor = (info.Color or Color3.fromRGB(255, 255, 255))
				mk.OutlineColor = rarityPal.Outline or Color3.fromRGB(255, 255, 255)
				mk.Parent = FolderEspMaster
				card.Highlight = mk
				activeEggCards = activeEggCards + 1
			end
			if card.Highlight.Adornee ~= rec.PhysicalModel then
				card.Highlight.Adornee = rec.PhysicalModel
			end
		elseif card.Highlight then
			pcall(function()
				card.Highlight:Destroy()
			end)
			card.Highlight = nil
		end
	end
	card.Anchor.CFrame = CFrame.new(cf.Position)
	card.Billboard.Enabled = true
end
local function ResolveAssetImage(catName: string): string
	local dir = nil
	pcall(function()
		if AssetsModule and AssetsModule.Directory then
			dir = AssetsModule.Directory[catName]
		end
	end)
	if dir then
		local iconId = dir.Icon or (dir.Egg and dir.Egg.Icon)
		if iconId and iconId ~= "" then
			local num = tostring(iconId):match("%d+")
			if num then
				return "rbxassetid://" .. num
			end
			return tostring(iconId)
		end
	end
	return "rbxassetid://10747384394"
end
function Tasks.GetPlotItemDetails(eggUid: string, modelInst: Model, ownerRecords: table)
	local rec = (ownerRecords and ownerRecords[eggUid]) or {}
	local cat = tostring(
		rec.AssetCategory
			or rec.Category
			or modelInst:GetAttribute("Category")
			or modelInst:GetAttribute("displayName")
			or ""
	)
	if cat == "" or cat == "nil" or cat:find("^[0-9_]+$") then
		for _, desc in ipairs(modelInst:GetDescendants()) do
			local c = desc:GetAttribute("Category")
				or desc:GetAttribute("displayName")
				or desc:GetAttribute("AssetCategory")
			if c and tostring(c) ~= "" then
				cat = tostring(c)
				break
			end
		end
	end
	if cat == "" or cat == "nil" or cat:find("^[0-9_]+$") then
		cat = "Pet"
	end
	local rarity =
		tostring(rec.Rarity or modelInst:GetAttribute("Rarity") or modelInst:GetAttribute("RarityTier") or "")
	if rarity == "" or rarity == "Unknown" then
		if AssetsModule and AssetsModule.Directory and AssetsModule.Directory[cat] then
			local r = AssetsModule.Directory[cat].Rarity
			if r then
				rarity = type(r) == "table" and (r.DisplayName or r.Name or r._id or "Common") or tostring(r)
			end
		end
	end
	if rarity == "" or rarity == "Unknown" then
		rarity = "Common"
	end
	local iconAsset = ResolveAssetImage(cat)
	local scale = tonumber(rec.AssetScale or rec.Scale or modelInst:GetAttribute("Scale")) or 1
	local petKg = 0
	if EggRecordsModule then
		local ok, w = pcall(function()
			return EggRecordsModule.WeightKg(rec)
		end)
		if ok and type(w) == "number" and w > 0 then
			petKg = w
		else
			local ok2, w2 = pcall(function()
				return EggRecordsModule.WeightKgForScale(scale)
			end)
			if ok2 and type(w2) == "number" and w2 > 0 then
				petKg = w2
			end
		end
	end
	if petKg == 0 then
		if AssetsModule and AssetsModule.Directory and AssetsModule.Directory[cat] then
			local base = tonumber(AssetsModule.Directory[cat].WeightKg or AssetsModule.Directory[cat].Weight) or 20
			petKg = base * scale
		else
			petKg = math.floor(scale * 20)
		end
	end
	local isHatched = (rec.Placement == nil)
	local isReady = false
	local timeLeftStr = ""
	if rec.Placement then
		local placedAt = rec.Placement.PlacedAt or rec.Placement.Time or 0
		local growthDur = 30
		if
			AssetsModule
			and AssetsModule.Directory
			and AssetsModule.Directory[cat]
			and AssetsModule.Directory[cat].Egg
		then
			growthDur = tonumber(AssetsModule.Directory[cat].Egg.GrowthTime) or 30
		end
		local mult = math.max(tonumber(rec.GrowthSpeedMultiplier) or 1, 0.01)
		local serverNow = Workspace:GetServerTimeNow()
		local readyAt = placedAt + (growthDur / mult)
		local left = readyAt - serverNow
		if left <= 0 then
			isReady = true
		else
			timeLeftStr = FormatTimeLeft(left)
		end
		if EggStateModule and EggStateModule.IsReadyToHatch then
			pcall(function()
				if EggStateModule.IsReadyToHatch(eggUid) then
					isReady = true
				end
			end)
		end
	else
		isHatched = true
	end
	local itemForIncome = {
		Category = cat,
		AssetCategory = cat,
		Scale = scale,
		AssetScale = scale,
		Mutations = rec.Mutations or {},
	}
	local income = CalculateEggIncome(itemForIncome)
	if income == 0 then
		income = tonumber(
			modelInst:GetAttribute("perSecond")
				or modelInst:GetAttribute("perSecondDisplay")
				or (rec and (rec.PerSecond or rec.Rate))
		) or 0
	end
	return {
		Category = cat,
		Rarity = rarity,
		Icon = iconAsset,
		Kg = petKg,
		Income = income,
		IsHatched = isHatched,
		IsReady = isReady,
		TimeLeft = timeLeftStr,
	}
end
ForceAntiTreadmill = function()
	RuntimeState.StealTreadmillShield = false
end
DisableForcedTreadmill = function()
	RuntimeState.StealTreadmillShield = false
end
local function AddDiscordBox(TabInstance)
	local CommunityGroup = TabInstance:AddLeftGroupbox("Community", "message-square")
	CommunityGroup:AddLabel(
		'<font color="#D946EF"><b>Join N3 Hub Community</b></font>\n'
			.. "Join our community now to get the latest updates, request new features, and report bugs!",
		true
	)
	CommunityGroup:AddButton("N3 Hub Discord", function()
		local discordLink = "https://discord.gg/EfQ6CAPydw"
		local copied = false
		if type(setclipboard) == "function" then
			copied = pcall(setclipboard, discordLink)
		elseif type(toclipboard) == "function" then
			copied = pcall(toclipboard, discordLink)
		end
		LibraryLoader:Notify({
			Title = copied and "Discord Link Copied" or "Copy Failed",
			TitleColor = copied and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 60, 60),
			Description = copied and "N3 Hub Discord invite copied to clipboard."
				or "Executor clipboard API is unavailable.",
			Time = 3,
		})
	end)
	CommunityGroup:AddButton("Website", function()
		local websiteLink = "https://yourdashboard.com"
		local copied = false
		if type(setclipboard) == "function" then
			copied = pcall(setclipboard, websiteLink)
		elseif type(toclipboard) == "function" then
			copied = pcall(toclipboard, websiteLink)
		end
		LibraryLoader:Notify({
			Title = copied and "Website Link Copied" or "Copy Failed",
			TitleColor = copied and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 60, 60),
			Description = copied and "N3 Hub website link copied to clipboard."
				or "Executor clipboard API is unavailable.",
			Time = 3,
		})
	end)
end
InstanUtility.Webhook = {
	Url = "",
	Enabled = false,
	Interval = 10,
	Ping = false,
	Queue = {},
	Sending = false,
	LastSend = 0,
	Sent = 0,
	Dropped = 0,
	Failed = 0,
	LastError = "Idle",
	SessionStarted = os.time(),
	SessionStartCash = nil,
	NextDue = 0,
	Recent = {},
	KnownUids = {},
	RecentReady = false,
	EggSendKnown = {},
	EggSendReady = false,
	EggSendRetryAt = {},
	EggDropCache = {},
	IconCache = {},
	Names = {},
}
function InstanUtility.Webhook:SafeRequest(options)
	local req = (syn and syn.request)
		or (http and http.request)
		or http_request
		or request
		or (fluxus and fluxus.request)
	if not req then
		return false, "No executor request function"
	end
	return pcall(req, options)
end
function InstanUtility.Webhook:Resolve()
	return function(options)
		local ok, res = InstanUtility.Webhook:SafeRequest(options)
		if ok then
			return res
		else
			return nil
		end
	end
end
function InstanUtility.Webhook:Service()
	local W = InstanUtility.Webhook
	if W.Http then
		return W.Http
	end
	local Ok, Svc = pcall(function()
		return game:GetService("HttpService")
	end)
	if Ok and Svc then
		W.Http = Svc
		return Svc
	end
	return nil
end
function InstanUtility.Webhook:IsValidUrl(Url)
	if type(Url) ~= "string" or Url == "" then
		return false
	end
	Url = Url:match("^%s*(.-)%s*$") or Url
	return Url ~= ""
end
function InstanUtility.Webhook:HttpGet(Link)
	if type(Link) ~= "string" or Link == "" then
		return nil
	end
	local RequestFn = InstanUtility.Webhook:Resolve()
	if RequestFn then
		local Ok, Res = pcall(RequestFn, { Url = Link, Method = "GET" })
		if Ok and type(Res) == "table" then
			local Ok2, Body = pcall(function()
				return Res.Body or Res.body
			end)
			if Ok2 and type(Body) == "string" and #Body > 0 then
				return Body
			end
			if type(Res.StatusCode) == "number" and Res.StatusCode >= 200 and Res.StatusCode < 300 then
				return Res.Body or Res.body
			end
		end
	end
	local Ok3, Body3 = pcall(function()
		return game:HttpGet(Link)
	end)
	if Ok3 and type(Body3) == "string" and #Body3 > 0 then
		return Body3
	end
	return nil
end
function InstanUtility.Webhook:AssetIcon(AssetName, RawIcon)
	local W = InstanUtility.Webhook
	if RawIcon == nil then
		return nil
	end
	local RawText = tostring(RawIcon):match("^%s*(.-)%s*$") or tostring(RawIcon)
	if RawText == "" then
		return nil
	end
	if RawText:match("^https://") then
		local UrlKey = "asset_url_" .. RawText
		if type(W.IconCache[UrlKey]) == "string" then
			return W.IconCache[UrlKey]
		end
		W.IconCache[UrlKey] = RawText
		return RawText
	end
	local AssetId = nil
	if type(RawIcon) == "number" then
		AssetId = tostring(math.floor(RawIcon))
	else
		AssetId = RawText:match("rbxassetid://(%d+)")
			or RawText:match("rbxthumb://[^?]*[?&]id=(%d+)")
			or RawText:match("[?&]id=(%d+)")
			or RawText:match("^(%d+)$")
			or RawText:match("(%d+)")
	end
	if not AssetId then
		return nil
	end
	local Key = "egg_asset_thumbnail_" .. AssetId
	if type(W.IconCache[Key]) == "string" then
		return W.IconCache[Key]
	end
	if W.IconCache[Key] == false then
		return nil
	end
	local Service = W:Service()
	if not Service then
		W.IconCache[Key] = false
		return nil
	end
	local PLACEHOLDER = "e5bef3179d5ce82a42fdc8ddc83a2ba9"
	local function PickUrl(Url)
		if type(Url) ~= "string" or not Url:match("^https://") then
			return nil
		end
		if string.find(Url, PLACEHOLDER, 1, true) then
			return nil
		end
		local Hash = Url:match("rbxcdn%.com/(180DAY%-%x+)$")
		if Hash then
			Url = "https://tr.rbxcdn.com/" .. Hash .. "/420/420/Image/Png/noFilter"
		end
		return Url
	end
	local FoundUrl = nil
	local OkBatch, BatchRes = W:SafeRequest({
		Url = "https://thumbnails.roblox.com/v1/batch",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = Service:JSONEncode({
			{
				requestId = AssetId,
				targetId = tonumber(AssetId),
				type = "Asset",
				size = "420x420",
				format = "Png",
				isCircular = false,
			},
		}),
	})
	if OkBatch and type(BatchRes) == "table" then
		local Body = BatchRes.Body or BatchRes.body
		if type(Body) == "string" and #Body > 0 then
			local OkDec, Data = pcall(function()
				return Service:JSONDecode(Body)
			end)
			local Item = OkDec and type(Data) == "table" and type(Data.data) == "table" and Data.data[1] or nil
			FoundUrl = Item and PickUrl(Item.imageUrl or Item.ImageUrl) or nil
		end
	end
	if not FoundUrl then
		local Body = W:HttpGet(
			"https://thumbnails.roblox.com/v1/assets?assetIds="
				.. AssetId
				.. "&size=420x420&format=Png&isCircular=false"
		)
		if Body then
			local Ok, Data = pcall(function()
				return Service:JSONDecode(Body)
			end)
			local Item = Ok and type(Data) == "table" and type(Data.data) == "table" and Data.data[1] or nil
			FoundUrl = Item and PickUrl(Item.imageUrl or Item.ImageUrl) or nil
		end
	end
	if FoundUrl then
		W.IconCache[Key] = FoundUrl
		return FoundUrl
	end
	return nil
end
function InstanUtility.Webhook:AvatarUrl(UserId)
	local W = InstanUtility.Webhook
	local Key = "avatar_" .. tostring(UserId)
	if W.IconCache[Key] ~= nil then
		return W.IconCache[Key] or nil
	end
	W.IconCache[Key] = false
	local Service = InstanUtility.Webhook:Service()
	local Ok, Decoded = pcall(function()
		local Body = InstanUtility.Webhook:HttpGet(
			"https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
				.. tostring(UserId)
				.. "&size=420x420&format=Png&isCircular=false"
		)
		if not Body then
			return nil
		end
		return Service:JSONDecode(Body)
	end)
	if Ok and type(Decoded) == "table" and type(Decoded.data) == "table" and Decoded.data[1] then
		local Url = Decoded.data[1].imageUrl or Decoded.data[1].ImageUrl
		if type(Url) == "string" and Url ~= "" then
			W.IconCache[Key] = Url
			return Url
		end
	end
	return nil
end
function InstanUtility.Webhook:AssetName(Category)
	local W = InstanUtility.Webhook
	local Key = tostring(Category or "")
	if W.Names[Key] then
		return W.Names[Key]
	end
	local Info = ResolveGameAsset(Key)
	local Name = (type(Info) == "table" and Info.Name) or Key
	W.Names[Key] = Name
	return Name
end
InstanUtility.Webhook.Spacer = "\u{200b}"
function InstanUtility.Webhook:Field(Name, Value, Inline)
	Name = tostring(Name or InstanUtility.Webhook.Spacer)
	Value = tostring(Value == nil and "-" or Value)
	if #Value > 1024 then
		Value = string.sub(Value, 1, 1018) .. "…"
	end
	return {
		name = #Name > 256 and string.sub(Name, 1, 256) or Name,
		value = Value,
		inline = Inline ~= false,
	}
end
function InstanUtility.Webhook:Push(Embed, Name, Value, Inline)
	if not Embed or type(Embed.fields) ~= "table" then
		return
	end
	if #Embed.fields >= 25 then
		return
	end
	table.insert(Embed.fields, InstanUtility.Webhook:Field(Name, Value, Inline))
end
function InstanUtility.Webhook:Timestamp()
	local Ok, Str = pcall(function()
		return DateTime.now():ToIsoDate()
	end)
	if Ok and type(Str) == "string" then
		return Str
	end
	return os.date("!%Y-%m-%dT%H:%M:%SZ")
end
function InstanUtility.Webhook:Color(Hex)
	local Clean = string.gsub(tostring(Hex or ""), "#", "")
	local Ok, Num = pcall(function()
		return tonumber(Clean, 16)
	end)
	if Ok and Num then
		return Num
	end
	return 5793266
end
function InstanUtility.Webhook:RarityColor(RarityName)
	local Base = DefaultRarityColors[tostring(RarityName or "")]
		or DefaultRarityColors[string.lower(tostring(RarityName or ""))]
		or Color3.fromRGB(87, 242, 135)
	local Ok, Hex = pcall(ColorToHex, Base)
	if Ok and type(Hex) == "string" then
		return InstanUtility.Webhook:Color(Hex)
	end
	return 5793266
end
function InstanUtility.Webhook:Bar(Percent, Length)
	Length = math.clamp(tonumber(Length) or 10, 4, 20)
	local Filled = math.clamp(math.floor(((tonumber(Percent) or 0) / 100) * Length + 0.5), 0, Length)
	return string.rep("█", Filled) .. string.rep("▁", Length - Filled)
end
function InstanUtility.Webhook:ParseCompactNumber(Value)
	if type(Value) == "number" then
		return Value
	end
	local Text = string.lower(tostring(Value or ""))
	Text = string.gsub(Text, "[, $]", "")
	Text = string.gsub(Text, "%s+", "")
	if Text == "" then
		return nil
	end
	local Direct = tonumber(Text)
	if Direct ~= nil then
		return Direct
	end
	local NumberText, Suffix = Text:match("^([%+%-]?%d*%.?%d+)([a-z]*)$")
	if not NumberText then
		NumberText, Suffix = Text:match("([%+%-]?%d*%.?%d+)([a-z]*)")
	end
	local Number = tonumber(NumberText)
	if not Number then
		return nil
	end
	local Scale = {
		k = 1e3,
		m = 1e6,
		b = 1e9,
		t = 1e12,
		q = 1e15,
		qa = 1e15,
		qi = 1e18,
		sx = 1e21,
		sp = 1e24,
		oc = 1e27,
		no = 1e30,
		dc = 1e33,
	}
	return Number * (Scale[Suffix or ""] or 1)
end
function InstanUtility.Webhook:GetCash()
	local W = InstanUtility.Webhook
	local BestValue, BestScore = nil, -1
	local function Consider(Value, Score)
		local Number = W:ParseCompactNumber(Value)
		if Number ~= nil and Number >= 0 and Score > BestScore then
			BestValue, BestScore = Number, Score
		end
	end
	local OkCurrent, Current = pcall(GetCurrentCash)
	if OkCurrent then
		Consider(Current, 1)
	end
	local Leaderstats = LocalPlayer:FindFirstChild("leaderstats")
	if Leaderstats then
		for _, Name in ipairs({ "Cash", "Money", "Coins", "Currency", "Gold", "Balance" }) do
			local Stat = Leaderstats:FindFirstChild(Name)
			if Stat then
				Consider(Stat.Value, 6)
			end
		end
	end
	local Saved = nil
	if SaveModule and type(SaveModule.Peek) == "function" then
		local Ok, Result = pcall(SaveModule.Peek)
		if Ok and type(Result) == "table" then
			Saved = Result
		end
	end
	if Saved then
		local Seen = {}
		local function Scan(Node, Path, Depth)
			if type(Node) ~= "table" or Depth > 4 or Seen[Node] then
				return
			end
			Seen[Node] = true
			for Key, Value in pairs(Node) do
				local KeyText = string.lower(tostring(Key))
				local NewPath = Path .. "." .. KeyText
				local LooksLikeCash = KeyText == "cash"
					or KeyText == "money"
					or KeyText == "coins"
					or KeyText == "currency"
					or KeyText == "balance"
					or KeyText == "wallet"
					or KeyText == "cashamount"
					or KeyText == "moneyamount"
				if LooksLikeCash and type(Value) ~= "table" then
					Consider(Value, 7)
				elseif LooksLikeCash and type(Value) == "table" then
					for _, ValueKey in ipairs({ "Value", "Amount", "Balance", "Current" }) do
						if Value[ValueKey] ~= nil then
							Consider(Value[ValueKey], 7)
						end
					end
				end
				if type(Value) == "table" then
					Scan(Value, NewPath, Depth + 1)
				end
			end
		end
		Scan(Saved, "save", 0)
	end
	local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if PlayerGui then
		for _, Object in ipairs(PlayerGui:GetDescendants()) do
			if Object:IsA("TextLabel") or Object:IsA("TextButton") then
				local Name = string.lower(Object.Name)
				local Text = tostring(Object.Text or "")
				local FullName = ""
				pcall(function()
					FullName = string.lower(Object:GetFullName())
				end)
				local CashNamed = Name:find("cash", 1, true)
					or Name:find("money", 1, true)
					or Name:find("coin", 1, true)
					or Name:find("currency", 1, true)
					or FullName:find("cash", 1, true)
					or FullName:find("money", 1, true)
				local HasCurrencyMark = Text:find("$", 1, true) ~= nil
				local PriceText = Name:find("price", 1, true)
					or Name:find("cost", 1, true)
					or Name:find("upgrade", 1, true)
					or Name:find("purchase", 1, true)
					or FullName:find("price", 1, true)
					or FullName:find("cost", 1, true)
					or FullName:find("upgrade", 1, true)
					or FullName:find("purchase", 1, true)
				if not PriceText then
					if CashNamed then
						Consider(Text, 11)
					elseif HasCurrencyMark then
						Consider(Text, 8)
					end
				end
			end
		end
	end
	return BestValue or 0
end
function InstanUtility.Webhook:GetData()
	local W = InstanUtility.Webhook
	local function ReadStat(Keys)
		local Leaderstats = LocalPlayer:FindFirstChild("leaderstats")
		if Leaderstats then
			for _, Key in ipairs(Keys) do
				local Stat = Leaderstats:FindFirstChild(Key)
				if Stat then
					local Number = W:ParseCompactNumber(Stat.Value)
					if Number ~= nil then
						return Number
					end
				end
			end
		end
		local Saved = nil
		if SaveModule and type(SaveModule.Peek) == "function" then
			local Ok, Result = pcall(SaveModule.Peek)
			if Ok and type(Result) == "table" then
				Saved = Result
			end
		end
		if Saved then
			for _, Source in ipairs({ Saved, type(Saved.Data) == "table" and Saved.Data or nil }) do
				if type(Source) == "table" then
					for _, Key in ipairs(Keys) do
						local Number = W:ParseCompactNumber(Source[Key])
						if Number ~= nil then
							return Number
						end
					end
				end
			end
		end
		return 0
	end
	local SessionSeconds = math.max(0, os.time() - (tonumber(W.SessionStarted) or os.time()))
	local JobId = tostring(game.JobId or "")
	if JobId == "" then
		JobId = "Private / unavailable"
	end
	return {
		PlayerName = tostring(LocalPlayer.DisplayName or LocalPlayer.Name or "Player"),
		UserName = tostring(LocalPlayer.Name or "Unknown"),
		UserId = tonumber(LocalPlayer.UserId) or 0,
		PlaceName = tostring(game.Name or "Roblox"),
		PlaceId = tonumber(game.PlaceId) or 0,
		GameId = tonumber(game.GameId) or 0,
		JobId = JobId,
		Cash = W:GetCash(),
		Speed = ReadStat({ "Speed", "WalkSpeed", "MovementSpeed" }),
		SessionSeconds = SessionSeconds,
	}
end
function InstanUtility.Webhook:FormatNumber(Value)
	local Ok, Result = pcall(CardFormatNum, tonumber(Value) or 0)
	if Ok and type(Result) == "string" then
		return Result
	end
	return FormatCash(tonumber(Value) or 0)
end
function InstanUtility.Webhook:AnsiColor(Value, ColorName)
	local Codes = {
		green = "32",
		lime = "32",
		yellow = "33",
		gold = "33",
		orange = "33",
		amber = "33",
		red = "31",
		rose = "31",
		blue = "34",
		cyan = "36",
		aqua = "36",
		purple = "35",
		violet = "35",
		pink = "35",
		magenta = "35",
		white = "37",
		gray = "37",
	}
	local Code = Codes[string.lower(tostring(ColorName or "white"))] or Codes.white
	local Text = tostring(Value == nil and "-" or Value)
	Text = string.gsub(Text, string.char(27), "")
	Text = string.gsub(Text, "[\r\n]", " ")
	return string.char(27) .. "[" .. Code .. "m" .. Text .. string.char(27) .. "[0m"
end
function InstanUtility.Webhook:AnsiLine(Label, Value, ValueColor)
	return self:AnsiColor(Label, "white") .. " " .. self:AnsiColor(Value, ValueColor or "white")
end
function InstanUtility.Webhook:AnsiSegments(Segments)
	local Parts = {}
	for _, Segment in ipairs(Segments or {}) do
		if type(Segment) == "table" then
			table.insert(Parts, self:AnsiColor(Segment[1], Segment[2] or "white"))
		else
			table.insert(Parts, tostring(Segment or ""))
		end
	end
	return table.concat(Parts)
end
function InstanUtility.Webhook:BuildPetAnsiLine(Index, Item)
	local Parts = {}
	if Index ~= nil then
		table.insert(Parts, { tostring(Index) .. ". ", "white" })
	end
	table.insert(Parts, { tostring(Item.Name or Item.Category or "Egg"), "white" })
	table.insert(Parts, { " • ", "white" })
	table.insert(Parts, { tostring(Item.Rarity or "Unknown"), "purple" })
	local Mutation = tostring(Item.Mutation or "")
	if Mutation ~= "" then
		table.insert(Parts, { " • ", "white" })
		table.insert(Parts, { Mutation, "orange" })
	end
	table.insert(Parts, { " • ", "white" })
	local Income = self:ParseCompactNumber(Item.Income) or 0
	table.insert(Parts, { self:FormatNumber(Income) .. "/s", "green" })
	return self:AnsiSegments(Parts)
end
function InstanUtility.Webhook:BuildEquipAnsiLine(Item)
	local Parts = {
		{ tostring(Item.Name or "Pet"), "white" },
		{ " • ", "white" },
		{ tostring(Item.Rarity or "Unknown"), "purple" },
	}
	if tostring(Item.Mutation or "") ~= "" then
		table.insert(Parts, { " • ", "white" })
		table.insert(Parts, { tostring(Item.Mutation), "orange" })
	end
	table.insert(Parts, { " • UID ", "white" })
	table.insert(Parts, { tostring(Item.Uid or "-"), "cyan" })
	return self:AnsiSegments(Parts)
end
function InstanUtility.Webhook:AnsiBox(Lines)
	return "```ansi\n" .. table.concat(Lines or {}, "\n") .. "\n```"
end
function InstanUtility.Webhook:PushAnsi(Embed, Name, Lines, Inline)
	self:Push(Embed, Name, self:AnsiBox(Lines), Inline)
end
function InstanUtility.Webhook:AttachRobloxImages(Embed, UserId, IncludeAvatar)
	local W = InstanUtility.Webhook
	if IncludeAvatar ~= false then
		local OkAvatar, Avatar = pcall(function()
			return W:AvatarUrl(UserId)
		end)
		if OkAvatar and type(Avatar) == "string" and Avatar:match("^https://") then
			Embed.thumbnail = { url = Avatar }
		end
	end
end
function InstanUtility.Webhook:SummaryPets(Eggs)
	local Items, TotalIncome = {}, 0
	if type(Eggs) == "table" then
		for _, Item in ipairs(Eggs) do
			if type(Item) == "table" then
				table.insert(Items, Item)
				TotalIncome = TotalIncome + (tonumber(Item.Income) or 0)
			end
		end
	end
	table.sort(Items, function(A, B)
		return (tonumber(A.Income) or 0) > (tonumber(B.Income) or 0)
	end)
	return { Count = #Items, TotalIncome = TotalIncome, Best = Items[1], Items = Items }
end
function InstanUtility.Webhook:TrackRecent(Eggs)
	local W = InstanUtility.Webhook
	W.KnownUids, W.Recent = W.KnownUids or {}, W.Recent or {}
	if type(Eggs) ~= "table" then
		return
	end
	if not W.RecentReady then
		for _, Item in ipairs(Eggs) do
			if type(Item) == "table" and Item.Uid then
				W.KnownUids[tostring(Item.Uid)] = true
			end
		end
		W.RecentReady = true
		return
	end
	for _, Item in ipairs(Eggs) do
		if type(Item) == "table" then
			local Uid = tostring(Item.Uid or "")
			if Uid ~= "" and not W.KnownUids[Uid] then
				W.KnownUids[Uid] = true
				table.insert(W.Recent, 1, {
					Name = tostring(Item.Name or Item.Category or "Egg"),
					Rarity = tostring(Item.Rarity or "Unknown"),
					Mutation = tostring(Item.Mutation or ""),
					Income = W:ParseCompactNumber(Item.Income) or 0,
				})
			end
		end
	end
	while #W.Recent > 6 do
		table.remove(W.Recent)
	end
end
function InstanUtility.Webhook:GetUpgradeProgress()
	local W = InstanUtility.Webhook
	local function ParseProgress(Value, AllowPlain)
		if Value == nil then
			return nil, nil
		end
		local Text = tostring(Value)
		local Current, Maximum = Text:match("(%d+)%s*/%s*(%d+)")
		if Current then
			return tonumber(Current), tonumber(Maximum)
		end
		Maximum = Text:match("[Mm]ax[%s_%-]*[Ll]evel%s*[:%-]?%s*(%d+)")
			or Text:match("[Mm]ax[%s_%-]*[Tt]ier%s*[:%-]?%s*(%d+)")
		local CurrentText = Text:gsub("[Mm]ax[%s_%-]*[Ll]evel%s*[:%-]?%s*%d+", "")
		CurrentText = CurrentText:gsub("[Mm]ax[%s_%-]*[Tt]ier%s*[:%-]?%s*%d+", "")
		Current = CurrentText:match("[Ll]evel%s*[:%-]?%s*(%d+)") or CurrentText:match("[Tt]ier%s*[:%-]?%s*(%d+)")
		if AllowPlain and not Current and not Maximum then
			local Number = W:ParseCompactNumber(Value)
			if Number and Number >= 0 and Number < 10000 then
				Current = math.floor(Number)
			end
		end
		return Current and tonumber(Current) or nil, Maximum and tonumber(Maximum) or nil
	end
	local function ReadProgress(Object, CurrentNames, MaxNames, TextNeedle)
		if not Object then
			return nil, nil
		end
		local Current, Maximum = nil, nil
		local CurrentSet, MaxSet = {}, {}
		for _, Name in ipairs(CurrentNames) do
			CurrentSet[string.lower(Name)] = true
		end
		for _, Name in ipairs(MaxNames) do
			MaxSet[string.lower(Name)] = true
		end
		local function Take(Value, IsMaximum, AllowPlain)
			local LevelValue, MaxValue = ParseProgress(Value, AllowPlain)
			if IsMaximum then
				if MaxValue and not Maximum then
					Maximum = MaxValue
				elseif LevelValue and not Maximum then
					Maximum = LevelValue
				end
			elseif LevelValue and not Current then
				Current = LevelValue
			end
			if MaxValue and not Maximum then
				Maximum = MaxValue
			end
		end
		for _, Name in ipairs(CurrentNames) do
			local Ok, Value = pcall(function()
				return Object:GetAttribute(Name)
			end)
			if Ok then
				Take(Value, false, true)
			end
			local OkChild, Child = pcall(function()
				return Object:FindFirstChild(Name, true)
			end)
			if OkChild and Child then
				local ValueObject = nil
				pcall(function()
					ValueObject = Child.Value
				end)
				if ValueObject ~= nil then
					Take(ValueObject, false, true)
				end
				local TextValue = nil
				pcall(function()
					TextValue = Child.Text
				end)
				if TextValue ~= nil then
					Take(TextValue, false, false)
				end
			end
		end
		for _, Name in ipairs(MaxNames) do
			local Ok, Value = pcall(function()
				return Object:GetAttribute(Name)
			end)
			if Ok then
				Take(Value, true, true)
			end
			local OkChild, Child = pcall(function()
				return Object:FindFirstChild(Name, true)
			end)
			if OkChild and Child then
				local ValueObject = nil
				pcall(function()
					ValueObject = Child.Value
				end)
				if ValueObject ~= nil then
					Take(ValueObject, true, true)
				end
			end
		end
		local OkDesc, Descendants = pcall(function()
			return Object:GetDescendants()
		end)
		if OkDesc and type(Descendants) == "table" then
			for _, Desc in ipairs(Descendants) do
				local Name = string.lower(tostring(Desc.Name or ""))
				if CurrentSet[Name] or MaxSet[Name] then
					local ValueObject = nil
					pcall(function()
						ValueObject = Desc.Value
					end)
					if ValueObject ~= nil then
						Take(ValueObject, MaxSet[Name] == true, true)
					end
					local TextValue = nil
					pcall(function()
						TextValue = Desc.Text
					end)
					if TextValue ~= nil then
						Take(TextValue, MaxSet[Name] == true, false)
					end
				end
				if Desc:IsA("TextLabel") or Desc:IsA("TextButton") then
					local Text = tostring(Desc.Text or "")
					local LowerText = string.lower(Text)
					local HasRatio = Text:match("%d+%s*/%s*%d+") ~= nil
					local HasLevel = LowerText:find("level", 1, true) or LowerText:find("tier", 1, true)
					local HasContext = TextNeedle
						and (
							LowerText:find(TextNeedle, 1, true)
							or LowerText:find("expand", 1, true)
							or LowerText:find("upgrade", 1, true)
						)
					if HasRatio or HasLevel or HasContext then
						Take(Text, false, false)
					end
				end
			end
		end
		return Current, Maximum
	end
	local function SavedProgress(Keyword)
		local Saved = nil
		if SaveModule and type(SaveModule.Peek) == "function" then
			local Ok, Result = pcall(SaveModule.Peek)
			if Ok and type(Result) == "table" then
				Saved = Result
			end
		end
		if type(Saved) ~= "table" then
			return nil, nil
		end
		local Seen, FoundLevel, FoundMax = {}, nil, nil
		local function Walk(Node, Path, Depth)
			if type(Node) ~= "table" or Depth > 5 or Seen[Node] then
				return
			end
			Seen[Node] = true
			for Key, Value in pairs(Node) do
				local KeyText = string.lower(tostring(Key))
				local NewPath = Path .. "." .. KeyText
				local InSection = NewPath:find(Keyword, 1, true) ~= nil
				if
					InSection
					and (KeyText:find("level", 1, true) or KeyText:find("tier", 1, true) or KeyText == "progress")
				then
					local LevelValue, MaxValue = ParseProgress(Value, type(Value) ~= "table")
					if LevelValue and not FoundLevel then
						FoundLevel = LevelValue
					end
					if MaxValue and not FoundMax then
						FoundMax = MaxValue
					end
				end
				if type(Value) == "table" then
					Walk(Value, NewPath, Depth + 1)
				end
			end
		end
		Walk(Saved, "save", 0)
		return FoundLevel, FoundMax
	end
	local Plot = nil
	pcall(function()
		Plot = select(1, GetPlayerPlot())
	end)
	local Treadmill = Plot and Plot:FindFirstChild("TreadmillUpgrade", true)
	local TreadmillLevel, TreadmillMax = ReadProgress(
		Treadmill,
		{ "TreadmillLevel", "TreadmillTier", "UpgradeLevel", "UpgradeTier", "Level", "Tier" },
		{ "TreadmillMaxLevel", "MaxTreadmillLevel", "MaxUpgradeLevel", "MaxLevel", "MaxTier" },
		"treadmill"
	)
	if not TreadmillLevel then
		TreadmillLevel, TreadmillMax = SavedProgress("treadmill")
	end
	local TreadmillText, TreadmillColor
	if TreadmillLevel then
		local Maximum = TreadmillMax or 9
		if TreadmillLevel >= Maximum then
			TreadmillText, TreadmillColor = string.format("MAX (%d/%d)", Maximum, Maximum), "green"
		else
			TreadmillText, TreadmillColor = string.format("%d/%d", TreadmillLevel, Maximum), "yellow"
		end
	elseif Treadmill then
		TreadmillText, TreadmillColor = "Upgraded • level unavailable", "green"
	else
		TreadmillText, TreadmillColor = "Not detected", "gray"
	end
	local PlotUpgrade = nil
	if Plot then
		for _, Desc in ipairs(Plot:GetDescendants()) do
			local Name = string.lower(tostring(Desc.Name or ""))
			if Name:find("plotupgrade", 1, true) or Name:find("expand", 1, true) then
				PlotUpgrade = Desc
				break
			end
		end
	end
	local PlotProgressObject = PlotUpgrade or Plot
	local PlotCurrentNames = PlotUpgrade
			and { "PlotLevel", "PlotTier", "ExpansionLevel", "UpgradeLevel", "UpgradeTier", "Level", "Tier" }
		or { "PlotLevel", "PlotTier", "PlotExpansionLevel", "ExpansionLevel" }
	local PlotMaxNames =
		{ "PlotMaxLevel", "MaxPlotLevel", "MaxExpansionLevel", "MaxUpgradeLevel", "MaxLevel", "MaxTier" }
	local PlotLevel, PlotMax = ReadProgress(PlotProgressObject, PlotCurrentNames, PlotMaxNames, "plot")
	if not PlotLevel then
		PlotLevel, PlotMax = SavedProgress("plot")
	end
	local PlotVerified = RuntimeState.PlotVerified == true and Plot ~= nil and Plot.Parent ~= nil
	local PlotText, PlotColor
	if not PlotVerified then
		PlotText, PlotColor = "Not verified", "red"
	elseif PlotLevel then
		local Detail
		if PlotMax and PlotMax > 0 then
			Detail = PlotLevel >= PlotMax and string.format("MAX (%d/%d)", PlotMax, PlotMax)
				or string.format("%d/%d", PlotLevel, PlotMax)
		else
			Detail = "Level " .. tostring(PlotLevel)
		end
		PlotText, PlotColor = "Verified • " .. Detail, (PlotMax and PlotLevel >= PlotMax) and "green" or "yellow"
	else
		PlotText, PlotColor = "Verified", "green"
	end
	local Catalog = TrailCatalog or {}
	local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local Shop = PlayerGui and (PlayerGui:FindFirstChild("TrailShop") or PlayerGui:FindFirstChild("TrailShop", true))
	local Saved = nil
	if SaveModule and type(SaveModule.Peek) == "function" then
		local Ok, Result = pcall(SaveModule.Peek)
		if Ok and type(Result) == "table" then
			Saved = Result
		end
	end
	local SavedRoots = {}
	if Saved then
		table.insert(SavedRoots, Saved)
		if type(Saved.Data) == "table" then
			table.insert(SavedRoots, Saved.Data)
		end
	end
	local TrailKeys = { "Trails", "TrailInventory", "OwnedTrails", "TrailsOwned", "UnlockedTrails", "TrailData" }
	local function SavedTrail(Id)
		for _, Root in ipairs(SavedRoots) do
			for _, Key in ipairs(TrailKeys) do
				local Collection = Root[Key]
				if type(Collection) == "table" then
					if Collection[Id] ~= nil then
						local Value = Collection[Id]
						if type(Value) == "table" then
							local Flag = Value.Owned
							if Flag == nil then
								Flag = Value.IsOwned
							end
							if Flag == nil then
								Flag = Value.Purchased
							end
							return Flag == true or Flag == 1 or (Flag == nil and next(Value) ~= nil), true
						end
						return Value == true or Value == 1, true
					end
					local IsOwnedList = Key == "OwnedTrails"
						or Key == "TrailsOwned"
						or Key == "UnlockedTrails"
						or Key == "TrailInventory"
						or #Collection > 0
					for _, Entry in pairs(Collection) do
						if Entry == Id or (type(Entry) == "table" and (Entry.Id == Id or Entry.Name == Id)) then
							return true, true
						end
					end
					if IsOwnedList then
						return false, true
					end
				end
			end
		end
		return false, false
	end
	local function UiTrail(Frame)
		if not Frame then
			return false, false
		end
		local Known, Owned = false, false
		for _, AttributeName in ipairs({ "Owned", "IsOwned", "Purchased", "Unlocked" }) do
			local Ok, Value = pcall(function()
				return Frame:GetAttribute(AttributeName)
			end)
			if Ok and Value ~= nil then
				Known = true
				if Value == true or Value == 1 then
					Owned = true
				end
			end
		end
		local function InspectTrailObject(Desc)
			local Name = string.lower(tostring(Desc.Name or ""))
			if Name == "owned" or Name == "isowned" or Name == "purchased" or Name == "unlocked" then
				local Ok, Value = pcall(function()
					return Desc.Value
				end)
				if Ok and Value ~= nil then
					Known = true
					if Value == true or Value == 1 then
						Owned = true
					end
				end
			end
			if
				Name:find("owned", 1, true)
				or Name:find("purchased", 1, true)
				or Name:find("unlocked", 1, true)
				or Name:find("equipped", 1, true)
			then
				Known, Owned = true, true
			elseif Name:find("buy", 1, true) or Name:find("locked", 1, true) then
				Known = true
			end
			if Desc:IsA("TextLabel") or Desc:IsA("TextButton") then
				local Text = string.lower(tostring(Desc.Text or ""))
				if
					Text:find("owned", 1, true)
					or Text:find("purchased", 1, true)
					or Text:find("unlocked", 1, true)
					or Text:find("equipped", 1, true)
					or Text:find("equip", 1, true)
				then
					Known, Owned = true, true
				elseif Text:find("buy", 1, true) or Text:find("locked", 1, true) then
					Known = true
				end
			end
		end
		InspectTrailObject(Frame)
		for _, Desc in ipairs(Frame:GetDescendants()) do
			InspectTrailObject(Desc)
		end
		return Owned, Known
	end
	local OwnedCount, KnownCount = 0, 0
	for _, Id in ipairs(Catalog) do
		local Owned, Known = UiTrail(Shop and Shop:FindFirstChild(Id, true))
		local SavedOwned, SavedKnown = SavedTrail(Id)
		if SavedKnown then
			Known = true
		end
		if SavedOwned then
			Owned, Known = true, true
		end
		if Known then
			KnownCount = KnownCount + 1
		end
		if Owned then
			OwnedCount = OwnedCount + 1
		end
	end
	local TrailText, TrailColor
	if #Catalog == 0 or KnownCount == 0 then
		TrailText, TrailColor = "Unknown", "gray"
	elseif KnownCount < #Catalog then
		TrailText, TrailColor = string.format("%d/%d owned (partial data)", OwnedCount, #Catalog), "yellow"
	elseif OwnedCount >= #Catalog then
		TrailText, TrailColor = string.format("MAX (%d/%d)", OwnedCount, #Catalog), "green"
	else
		TrailText, TrailColor =
			string.format("%d/%d owned", OwnedCount, #Catalog), OwnedCount > 0 and "yellow" or "gray"
	end
	return {
		Treadmill = TreadmillText,
		TreadmillColor = TreadmillColor,
		Plot = PlotText,
		PlotColor = PlotColor,
		Trails = TrailText,
		TrailsColor = TrailColor,
	}
end
function InstanUtility.Webhook:BuildSummary()
	local W = InstanUtility.Webhook
	local Data = W:GetData()
	local OkEggs, EggResult = pcall(GetGameEggData)
	local Eggs = (OkEggs and type(EggResult) == "table") and EggResult or {}
	pcall(function()
		W:TrackRecent(Eggs)
	end)
	local Pets = W:SummaryPets(Eggs)
	local Upgrades = nil
	if FarmConfig.Webhook_Sum_Upgrades ~= false then
		Upgrades = W:GetUpgradeProgress()
	end
	if W.SessionStartCash == nil then
		W.SessionStartCash = Data.Cash
	end
	local StartCash = tonumber(W.SessionStartCash) or Data.Cash
	local Delta = Data.Cash - StartCash
	local Sign = Delta >= 0 and "+" or "-"
	local Ready, Growing, Inventory = 0, 0, 0
	for _, Egg in ipairs(Eggs) do
		if Egg.StatusType == "Ready" then
			Ready = Ready + 1
		elseif Egg.StatusType == "Growing" then
			Growing = Growing + 1
		else
			Inventory = Inventory + 1
		end
	end
	local Embed = {
		title = "N3 Hub • Session Report",
		description = "Current progress and stats from N3 Hub",
		color = 0x9B59B6,
		fields = {},
		footer = { text = "N3 Hub • Steal An Egg" },
		timestamp = W:Timestamp(),
	}
	local function Add(Name, Lines, Inline)
		W:PushAnsi(Embed, Name, Lines, Inline)
	end
	local function Line(Label, Value, Color)
		return W:AnsiLine(Label, Value, Color)
	end
	if FarmConfig.Webhook_Field_Player ~= false then
		Add("👤 Player", {
			Line("Display name:", Data.PlayerName, "white"),
			Line("Username:", "@" .. Data.UserName, "yellow"),
			Line("User ID:", tostring(Data.UserId), "white"),
		}, false)
	end
	if FarmConfig.Webhook_Field_Server ~= false then
		Add("🌐 Place", {
			Line("Game:", Data.PlaceName, "white"),
			Line("Place ID:", tostring(Data.PlaceId), "white"),
			Line("Job ID:", Data.JobId, "cyan"),
		}, false)
	end
	if FarmConfig.Webhook_Field_Session ~= false then
		Add("⏱️ Session", {
			Line("Playtime:", FormatTimeLeft(Data.SessionSeconds), "yellow"),
			Line("Sent:", tostring(W.Sent or 0), "green"),
			Line("Failed:", tostring(W.Failed or 0), "red"),
		}, false)
	end
	local Zones = {}
	if type(FarmConfig.Index_SelectedZones) == "table" then
		for Key, Value in pairs(FarmConfig.Index_SelectedZones) do
			if type(Key) == "number" and Value ~= nil then
				table.insert(Zones, tostring(Value))
			elseif Value == true then
				table.insert(Zones, tostring(Key))
			end
		end
	end
	table.sort(Zones)
	local Target = #Zones > 0 and table.concat(Zones, ", ")
		or tostring(FarmConfig.Index_StealPriority or "Default priority")
	local Active = RuntimeState.IsExecuting == true
		or FarmConfig.AutoStealEnabled == true
		or FarmConfig.AutoStealAll == true
		or FarmConfig.AutoStealSelected == true
	if FarmConfig.Webhook_Field_EventTarget ~= false then
		Add("🎯 Current target", {
			Line("Target:", Target, "orange"),
			Line("Status:", Active and "Active" or "Idle", Active and "green" or "gray"),
		}, false)
	end
	if FarmConfig.Webhook_Field_EventValue ~= false then
		Add("📈 Snapshot value", {
			Line("Tracked:", tostring(#Eggs), "white"),
			Line("Income:", W:FormatNumber(Pets.TotalIncome) .. "/s", "green"),
		}, false)
	end
	if FarmConfig.Webhook_Sum_Cash ~= false then
		Add("💰 Cash & gain", {
			Line("Balance:", W:FormatNumber(Data.Cash), "green"),
			Line("Session gain:", Sign .. W:FormatNumber(math.abs(Delta)), Delta >= 0 and "green" or "red"),
		}, false)
	end
	if FarmConfig.Webhook_Sum_Speed ~= false then
		Add("⚡ Speed", { Line("Speed:", W:FormatNumber(Data.Speed), "cyan") }, false)
	end
	if FarmConfig.Webhook_Sum_Eggs ~= false then
		local Held = 0
		local OkHeld, HeldValue = pcall(CountPlayerHeldEggs)
		if OkHeld then
			Held = tonumber(HeldValue) or 0
		end
		Add("🥚 Egg status", {
			Line("Total:", tostring(#Eggs), "white"),
			Line("Ready:", tostring(Ready), "green"),
			Line("Growing:", tostring(Growing), "orange"),
			Line("Inventory / carried:", tostring(Inventory) .. " / " .. tostring(Held), "cyan"),
		}, false)
	end
	if FarmConfig.Webhook_Sum_Pets ~= false then
		local Top = {}
		for Index = 1, math.min(3, #Pets.Items) do
			local Item = Pets.Items[Index]
			table.insert(Top, W:BuildPetAnsiLine(Index, Item))
		end
		if #Top == 0 then
			table.insert(Top, Line("Inventory:", "No records found", "gray"))
		end
		Add("🐾 Top inventory", Top, false)
	end
	if FarmConfig.Webhook_Sum_Upgrades ~= false then
		Add("🛠️ Upgrades", {
			Line("Treadmill:", Upgrades.Treadmill, Upgrades.TreadmillColor),
			Line("Plot:", Upgrades.Plot, Upgrades.PlotColor),
			Line("Trail shop:", Upgrades.Trails, Upgrades.TrailsColor),
		}, false)
	end
	if FarmConfig.Webhook_Sum_Index ~= false then
		local IndexText = "Unavailable"
		local OkIndex, Unlocked, Total, Percent, Unclaimed = pcall(GetIndexStatistics)
		if OkIndex then
			Unlocked, Total, Percent, Unclaimed =
				tonumber(Unlocked) or 0, tonumber(Total) or 0, tonumber(Percent) or 0, tonumber(Unclaimed) or 0
			IndexText = string.format("%d/%d • %d%% • %d unclaimed", Unlocked, Total, Percent, Unclaimed)
		end
		Add(
			"📚 Index",
			{ Line("Progress:", IndexText, "white"), Line("Bar:", W:Bar(Percent or 0, 12), "green") },
			false
		)
	end
	if FarmConfig.Webhook_Sum_Recent ~= false then
		local Lines = {}
		for Index = 1, math.min(5, #(W.Recent or {})) do
			table.insert(Lines, W:BuildPetAnsiLine(nil, W.Recent[Index]))
		end
		if #Lines == 0 then
			table.insert(Lines, Line("Recent:", "Nothing new yet", "gray"))
		end
		Add("✨ Recent obtains", Lines, false)
	end
	W:AttachRobloxImages(Embed, Data.UserId, FarmConfig.Webhook_Field_Player ~= false)
	return Embed
end
function InstanUtility.Webhook:BuildInventory()
	local W = InstanUtility.Webhook
	local OkEggs, EggResult = pcall(GetGameEggData)
	local Eggs = (OkEggs and type(EggResult) == "table") and EggResult or {}
	local Summary = W:SummaryPets(Eggs)
	table.sort(Eggs, function(A, B)
		return (tonumber(A.Income) or 0) > (tonumber(B.Income) or 0)
	end)
	local Embed = {
		title = "N3 Hub • Egg & Pet Inventory",
		description = "Highest income records",
		color = 0x9B59B6,
		fields = {},
		footer = { text = "N3 Hub • Steal An Egg" },
		timestamp = W:Timestamp(),
	}
	if FarmConfig.Webhook_Pet_Power ~= false then
		W:PushAnsi(Embed, "📊 Inventory summary", {
			W:AnsiLine("Total records:", tostring(#Eggs), "white"),
			W:AnsiLine("Total income:", W:FormatNumber(Summary.TotalIncome) .. "/s", "green"),
		}, false)
	end
	local Lines = {}
	for Index = 1, math.min(7, #Eggs) do
		table.insert(Lines, W:BuildPetAnsiLine(Index, Eggs[Index]))
	end
	if #Lines == 0 then
		table.insert(Lines, W:AnsiLine("Inventory:", "No records found", "gray"))
	end
	if FarmConfig.Webhook_Pet_Best ~= false then
		W:PushAnsi(Embed, "🥚 Highest income", Lines, false)
	end
	if FarmConfig.Webhook_Pet_Index ~= false then
		local IndexText = "Unavailable"
		local OkIndex, Unlocked, Total, Percent = pcall(GetIndexStatistics)
		if OkIndex then
			IndexText =
				string.format("%d/%d - %d%%", tonumber(Unlocked) or 0, tonumber(Total) or 0, tonumber(Percent) or 0)
		end
		W:PushAnsi(Embed, "Index", { W:AnsiLine("Progress:", IndexText, "white") }, false)
	end
	W:AttachRobloxImages(Embed, LocalPlayer.UserId, FarmConfig.Webhook_Field_Player ~= false)
	return { Embed }
end
function InstanUtility.Webhook:BuildEquip()
	local W = InstanUtility.Webhook
	local Equipped = {}
	local Character = LocalPlayer.Character
	if Character then
		for _, Tool in ipairs(Character:GetChildren()) do
			if Tool:IsA("Tool") then
				local Uid = Tool:GetAttribute("UID") or Tool:GetAttribute("Uid")
				if Uid then
					local Category, Rarity, Mutation = Tool.Name, "Unknown", ""
					pcall(function()
						Category = GetToolCategory(Tool, Tool.Name)
					end)
					pcall(function()
						Rarity = tostring(ResolveGameAsset(Category).Rarity or "Unknown")
					end)
					pcall(function()
						Mutation = tostring(GetToolMutation(Tool) or "")
					end)
					table.insert(
						Equipped,
						{ Name = Tool.Name, Uid = tostring(Uid), Rarity = Rarity, Mutation = Mutation }
					)
				end
			end
		end
	end
	local Embed = {
		title = "N3 Hub • Equipped Pets",
		description = "Pet tools currently on your character",
		color = 0x9B59B6,
		fields = {},
		footer = { text = "N3 Hub • Steal An Egg" },
		timestamp = W:Timestamp(),
	}
	W:PushAnsi(Embed, "⚙️ Equip status", {
		W:AnsiLine("Detected:", tostring(#Equipped), "white"),
		W:AnsiLine(
			"Auto-equip best:",
			FarmConfig.AutoEquipBestPet and "On" or "Off",
			FarmConfig.AutoEquipBestPet and "green" or "red"
		),
	}, false)
	local Lines = {}
	for _, Item in ipairs(Equipped) do
		if #Lines >= 7 then
			break
		end
		table.insert(Lines, W:BuildEquipAnsiLine(Item))
	end
	if #Lines == 0 then
		table.insert(Lines, W:AnsiLine("Equipped:", "No pet tools detected", "gray"))
	end
	W:PushAnsi(Embed, "🐾 Equipped list", Lines, false)
	W:AttachRobloxImages(Embed, LocalPlayer.UserId, FarmConfig.Webhook_Field_Player ~= false)
	return Embed
end
function InstanUtility.Webhook:BuildTest()
	local W = InstanUtility.Webhook
	local Data = W:GetData()
	local Embed = {
		title = "N3 Hub • Webhook Test",
		description = "If this embed appears in Discord, the webhook connection is working.",
		color = 0x9B59B6,
		fields = {},
		footer = { text = "N3 Hub • Steal An Egg" },
		timestamp = W:Timestamp(),
	}
	if FarmConfig.Webhook_Field_Player ~= false then
		W:PushAnsi(Embed, "👤 Player", {
			W:AnsiLine("Display name:", Data.PlayerName, "white"),
			W:AnsiLine("Username:", "@" .. Data.UserName, "yellow"),
			W:AnsiLine("User ID:", tostring(Data.UserId), "white"),
		}, false)
	end
	if FarmConfig.Webhook_Field_Server ~= false then
		W:PushAnsi(Embed, "🌐 Place", {
			W:AnsiLine("Game:", Data.PlaceName, "white"),
			W:AnsiLine("Place ID:", tostring(Data.PlaceId), "white"),
			W:AnsiLine("Job ID:", Data.JobId, "cyan"),
		}, false)
	end
	if FarmConfig.Webhook_Field_Session ~= false then
		W:PushAnsi(Embed, "⏱️ Session", {
			W:AnsiLine("Playtime:", FormatTimeLeft(Data.SessionSeconds), "yellow"),
			W:AnsiLine("Sent:", tostring(W.Sent or 0), "green"),
			W:AnsiLine("Failed:", tostring(W.Failed or 0), "red"),
		}, false)
	end
	W:AttachRobloxImages(Embed, Data.UserId, FarmConfig.Webhook_Field_Player ~= false)
	return Embed
end
function InstanUtility.Webhook:EggDropInfo(Egg)
	local W = InstanUtility.Webhook
	Egg = type(Egg) == "table" and Egg or {}
	local Category = tostring(Egg.Category or Egg.Name or "")
	local DisplayName = tostring(Egg.Name or "")
	local function CleanName(Value)
		return string.gsub(string.lower(tostring(Value or "")), "[^%a%d]", "")
	end
	local function ToPercent(Value, Key)
		if type(Value) == "string" then
			local PercentText = Value:match("([%d%.]+)%s*%%")
			if PercentText then
				return tonumber(PercentText)
			end
		end
		local Number = tonumber(Value)
		if not Number or Number < 0 then
			return nil
		end
		if string.find(string.lower(tostring(Key or "")), "percent", 1, true) then
			return Number
		end
		if Number <= 1 then
			return Number * 100
		end
		return Number
	end
	local function ReadDirectChance(Source)
		if type(Source) ~= "table" then
			return nil
		end
		for _, Key in ipairs({
			"ChancePercent",
			"SpawnChancePercent",
			"DropChancePercent",
			"HatchChancePercent",
			"Chance",
			"SpawnChance",
			"DropChance",
			"HatchChance",
		}) do
			local Result = ToPercent(Source[Key], Key)
			if Result ~= nil then
				return Result
			end
		end
		return nil
	end
	local function IsKnownZone(Value)
		local CandidateClean = CleanName(Value)
		if CandidateClean == "" or CandidateClean == "world" or CandidateClean == "unknown" then
			return false
		end
		for _, AreaName in ipairs(AreaNamesList) do
			local AreaClean = CleanName(AreaName)
			if
				AreaClean ~= ""
				and (CandidateClean == AreaClean or string.find(CandidateClean, AreaClean, 1, true) ~= nil)
			then
				return true
			end
		end
		if ConfigsFolder then
			for _, AreaModule in ipairs(ConfigsFolder:GetChildren()) do
				if AreaModule:IsA("ModuleScript") then
					local AreaName = tostring(AreaModule.Name):gsub("[Cc]onfig", "")
					local AreaClean = CleanName(AreaName)
					if
						AreaClean ~= ""
						and (CandidateClean == AreaClean or string.find(CandidateClean, AreaClean, 1, true) ~= nil)
					then
						return true
					end
				end
			end
		end
		return false
	end
	local function CanonicalZone(Value)
		local CandidateClean = CleanName(Value)
		for _, AreaName in ipairs(AreaNamesList) do
			local AreaClean = CleanName(AreaName)
			if
				AreaClean ~= ""
				and (CandidateClean == AreaClean or string.find(CandidateClean, AreaClean, 1, true) ~= nil)
			then
				return AreaName
			end
		end
		return tostring(Value or "")
	end
	local Zone = tostring(Egg.Zone or "")
	if not IsKnownZone(Zone) or tonumber(Zone) then
		Zone = ""
	end
	local ZoneClean = CleanName(Zone)
	local Info = ResolveGameAsset(Category)
	if Zone == "" and type(Info) == "table" and Info.Area and IsKnownZone(Info.Area) then
		Zone = tostring(Info.Area)
		ZoneClean = CleanName(Zone)
	end
	local RawChanceSeed = Egg.ChancePercent
		or Egg.SpawnChancePercent
		or Egg.DropChancePercent
		or Egg.Chance
		or Egg.SpawnChance
		or Egg.DropChance
		or Info.Chance
	local CacheKey = CleanName(Category) .. "|" .. ZoneClean .. "|" .. tostring(RawChanceSeed or "")
	local Cached = W.EggDropCache[CacheKey]
	if Cached then
		return Cached.Chance, Cached.Zone
	end
	local Chance = ReadDirectChance(Egg) or ReadDirectChance(Info)
	local CategoryClean = CleanName(Category)
	local DisplayClean = CleanName(DisplayName)
	local MatchCount = 0
	local UniqueChance, UniqueArea = nil, nil
	local MatchedAreaChance, MatchedAreaName = nil, nil
	if ConfigsFolder and CategoryClean ~= "" then
		for _, AreaModule in ipairs(ConfigsFolder:GetChildren()) do
			if AreaModule:IsA("ModuleScript") then
				local AreaName = tostring(AreaModule.Name):gsub("[Cc]onfig", "")
				local AreaClean = CleanName(AreaName)
				local ZoneMatches = ZoneClean ~= ""
					and AreaClean ~= ""
					and (ZoneClean == AreaClean or string.find(ZoneClean, AreaClean, 1, true) ~= nil)
				local OkArea, AreaData = pcall(require, AreaModule)
				if OkArea and type(AreaData) == "table" and type(AreaData.DropTable) == "table" then
					local TotalWeight, MatchWeight = 0, nil
					local WeightComplete = true
					local MatchDirectChance = nil
					local HasMatch = false
					for _, Entry in ipairs(AreaData.DropTable) do
						if type(Entry) == "table" then
							local EntryName = Entry[1] or Entry.Name or Entry.Category or Entry.AssetCategory
							local EntryClean = CleanName(EntryName)
							local IsMatch = EntryClean ~= ""
								and (EntryClean == CategoryClean or (DisplayClean ~= "" and EntryClean == DisplayClean))
							local EntryChance = ReadDirectChance(Entry)
							local Weight = tonumber(Entry.Weight or Entry.ChanceWeight or Entry.DropWeight or Entry[2])
							if Weight and Weight > 0 then
								TotalWeight = TotalWeight + Weight
							else
								WeightComplete = false
							end
							if IsMatch then
								HasMatch = true
								MatchWeight = Weight
								MatchDirectChance = EntryChance
							end
						elseif Entry ~= nil then
							WeightComplete = false
						end
					end
					if HasMatch then
						MatchCount = MatchCount + 1
						local CandidateChance = MatchDirectChance
						if CandidateChance == nil and MatchWeight and WeightComplete and TotalWeight > 0 then
							CandidateChance = (MatchWeight / TotalWeight) * 100
						end
						if ZoneClean ~= "" and ZoneMatches then
							MatchedAreaName = AreaName
							MatchedAreaChance = CandidateChance
							break
						elseif ZoneClean == "" and MatchCount == 1 then
							UniqueArea = AreaName
							UniqueChance = CandidateChance
						elseif ZoneClean == "" then
							UniqueArea = nil
							UniqueChance = nil
						end
					end
				end
			end
		end
	end
	local ResolvedZone = Zone
	if MatchedAreaName then
		ResolvedZone = MatchedAreaName
		if MatchedAreaChance ~= nil then
			Chance = MatchedAreaChance
		end
	elseif ZoneClean == "" and MatchCount == 1 then
		ResolvedZone = UniqueArea or ""
		if UniqueChance ~= nil then
			Chance = UniqueChance
		end
	end
	ResolvedZone = CanonicalZone(ResolvedZone)
	W.EggDropCache[CacheKey] = { Chance = Chance, Zone = ResolvedZone }
	return Chance, ResolvedZone
end
function InstanUtility.Webhook:FormatChance(Chance)
	local Number = tonumber(Chance)
	if Number == nil then
		return "Not available in game data"
	end
	local Decimals = Number < 0.0001 and 8 or (Number < 0.01 and 6 or (Number < 1 and 4 or (Number < 10 and 2 or 1)))
	local Text = string.format("%." .. tostring(Decimals) .. "f", Number)
	Text = string.gsub(Text, "0+$", "")
	Text = string.gsub(Text, "%.$", "")
	return Text .. "%"
end
function InstanUtility.Webhook:BuildEggEmbed(Egg)
	local W = InstanUtility.Webhook
	Egg = type(Egg) == "table" and Egg or {}
	local Name = tostring(Egg.Name or "")
	if Name == "" then
		Name = tostring(W:AssetName(Egg.Category) or Egg.Category or "Egg")
	end
	local Rarity = tostring(Egg.Rarity or "Unknown")
	local Mutation = tostring(Egg.Mutation or "")
	if Mutation == "" or string.lower(Mutation) == "none" then
		Mutation = "None"
	end
	local Chance, ResolvedZone = W:EggDropInfo(Egg)
	local Zone = tostring(ResolvedZone or Egg.Zone or "Unknown")
	if Zone == "" then
		Zone = "Unknown"
	end
	local JobId = tostring(game.JobId or "")
	if JobId == "" then
		JobId = "Private / unavailable"
	end
	local Income = W:FormatNumber(tonumber(Egg.Income) or 0) .. "/s"
	local Embed = {
		title = "🥚 You Got a New Egg!",
		color = W:RarityColor(Rarity),
		fields = {},
		footer = { text = "N3 Hub • Egg Webhook" },
		timestamp = W:Timestamp(),
	}
	local function AddEggValueField(FieldName, FieldValue, ValueColor, Inline)
		local BoxedColorValue = W:AnsiBox({ W:AnsiColor(FieldValue, ValueColor) })
		W:Push(Embed, FieldName, BoxedColorValue, Inline)
	end
	local EggLabel = tostring(Egg.EggName or "")
	AddEggValueField("Egg", EggLabel ~= "" and EggLabel or Name, "cyan", true)
	if FarmConfig.Webhook_Egg_Rarity ~= false then
		AddEggValueField("Rarity", Rarity, "purple", true)
	end
	if FarmConfig.Webhook_Egg_Mutation ~= false then
		AddEggValueField("Mutation", Mutation, string.lower(Mutation) == "none" and "gray" or "orange", false)
	end
	if FarmConfig.Webhook_Egg_Value ~= false then
		AddEggValueField("Cash / second", Income, "green", false)
	end
	if FarmConfig.Webhook_Egg_Zone ~= false then
		AddEggValueField("Zone", Zone, "cyan", false)
	end
	AddEggValueField("Place ID", JobId, "gray", false)
	if FarmConfig.Webhook_Egg_Chance ~= false then
		AddEggValueField("Chance", W:FormatChance(Chance), "yellow", false)
	end
	if Name ~= "" then
		AddEggValueField("Grows Into", Name, "green", true)
	end
	local Growth = tonumber(Egg.GrowthTime)
	if Growth and Growth > 0 then
		local G = math.floor(Growth)
		local GrowthText = G >= 3600 and string.format("%dh %dm", G // 3600, (G % 3600) // 60)
			or (G >= 60 and string.format("%dm %ds", G // 60, G % 60) or (tostring(G) .. "s"))
		AddEggValueField("Hatch In", GrowthText, "yellow", true)
	end
	local Category = tostring(Egg.Category or Egg.Name or "")
	local EggConfigIcons, EggConfigModuleName, EggConfigIconSource = nil, nil, nil
	local ConfigNames, SeenConfigNames = {}, {}
	local function AddConfigName(Value)
		local Text = tostring(Value or "")
		if Text == "" then
			return
		end
		local Clean = string.gsub(string.lower(Text), "[^%a%d]", "")
		if Clean ~= "" and not SeenConfigNames[Clean] then
			SeenConfigNames[Clean] = true
			table.insert(ConfigNames, Text)
		end
	end
	AddConfigName(Category)
	AddConfigName(Egg.Name)
	local AssetConfigKey = Category
	local AssetConfigId = Category
	local EntryDisplayName, EntryEggDisplayName, EntryEggModelName = "", "", ""
	pcall(function()
		local Directory = AssetsModule and AssetsModule.Directory
		local Entry = type(Directory) == "table" and Directory[Category]
		local EntryKey = Entry and Category or nil
		local CleanCategory = string.gsub(string.lower(Category), "[^%a%d]", "")
		if not Entry and type(Directory) == "table" and CleanCategory ~= "" then
			for Key, Candidate in pairs(Directory) do
				if type(Candidate) == "table" then
					local EggInfo = type(Candidate.Egg) == "table" and Candidate.Egg or nil
					local Names = {
						tostring(Key),
						tostring(Candidate._id or ""),
						tostring(Candidate.DisplayName or ""),
						EggInfo and tostring(EggInfo.ModelName or "") or "",
						EggInfo and tostring(EggInfo.DisplayName or "") or "",
					}
					for _, CandidateName in ipairs(Names) do
						local CleanCandidate = string.gsub(string.lower(CandidateName), "[^%a%d]", "")
						if CleanCandidate ~= "" and CleanCandidate == CleanCategory then
							Entry = Candidate
							EntryKey = tostring(Key)
							break
						end
					end
					if Entry then
						break
					end
				end
			end
		end
		if type(Entry) == "table" then
			AssetConfigKey = tostring(EntryKey or Category)
			AssetConfigId = tostring(Entry._id or EntryKey or Category)
			EntryDisplayName = tostring(Entry.DisplayName or "")
			if type(Entry.Egg) == "table" then
				EntryEggDisplayName = tostring(Entry.Egg.DisplayName or "")
				EntryEggModelName = tostring(Entry.Egg.ModelName or "")
			end
			AddConfigName(AssetConfigKey)
			AddConfigName(AssetConfigId)
			AddConfigName(EntryDisplayName)
			AddConfigName(EntryEggDisplayName)
			AddConfigName(EntryEggModelName)
		end
	end)
	pcall(function()
		local DataFolder = ReplicatedStorage:FindFirstChild("Data")
		local AssetFolder = DataFolder and DataFolder:FindFirstChild("Assets")
		local ConfigFolder = AssetFolder and AssetFolder:FindFirstChild("Configs")
		if not ConfigFolder then
			return
		end
		local function ReadConfigIcon(Module)
			if not Module or not Module:IsA("ModuleScript") then
				return nil
			end
			local Ok, Data = pcall(require, Module)
			if not Ok or type(Data) ~= "table" then
				return nil
			end
			local Icons = {}
			local function Push(Icon, Source)
				if Icon ~= nil and tostring(Icon) ~= "" then
					table.insert(Icons, { Value = Icon, Source = Source })
				end
			end
			Push(Data.Icon, "Config.Icon")
			local EggInfo = type(Data.Egg) == "table" and Data.Egg or nil
			Push(EggInfo and EggInfo.Icon or nil, "Config.Egg.Icon")
			if #Icons == 0 then
				return nil
			end
			return Icons, Module:GetFullName()
		end
		local function TryConfigModule(ConfigName)
			local Text = tostring(ConfigName or "")
			if Text == "" then
				return false
			end
			local LowerText = string.lower(Text)
			local Stripped = LowerText:sub(1, 7) == "config." and Text:sub(8) or Text
			local Names = { Text, "Config." .. Text }
			if Stripped ~= Text then
				table.insert(Names, Stripped)
			end
			for _, ModuleName in ipairs(Names) do
				local Module = ConfigFolder:FindFirstChild(ModuleName, true)
				local Icons, FullName = ReadConfigIcon(Module)
				if Icons then
					EggConfigIcons = Icons
					EggConfigModuleName = FullName
					EggConfigIconSource = Icons[1] and Icons[1].Source or nil
					return true
				end
			end
			return false
		end
		for _, ConfigName in ipairs({ AssetConfigKey, AssetConfigId, Category, tostring(Egg.Name or "") }) do
			if TryConfigModule(ConfigName) then
				break
			end
		end
		if not EggConfigIcon then
			local CleanTargets = {}
			for _, ConfigName in ipairs(ConfigNames) do
				local Clean = string.gsub(string.lower(ConfigName), "[^%a%d]", "")
				if Clean ~= "" then
					CleanTargets[Clean] = true
					if Clean:sub(-3) == "egg" then
						CleanTargets[Clean:sub(1, -4)] = true
					end
				end
			end
			for _, Module in ipairs(ConfigFolder:GetDescendants()) do
				if Module:IsA("ModuleScript") then
					local CleanModule = string.gsub(string.lower(Module.Name), "[^%a%d]", "")
					local BareModule = string.gsub(CleanModule, "^config", "")
					local Matches = CleanTargets[CleanModule] == true or CleanTargets[BareModule] == true
					if not Matches then
						for Target in pairs(CleanTargets) do
							if
								Target == CleanModule .. "egg"
								or Target == CleanModule .. "pet"
								or Target == BareModule .. "egg"
								or Target == BareModule .. "pet"
							then
								Matches = true
								break
							end
						end
					end
					if Matches then
						local Icons, FullName = ReadConfigIcon(Module)
						if Icons then
							EggConfigIcons = Icons
							EggConfigModuleName = FullName
							EggConfigIconSource = Icons[1] and Icons[1].Source or nil
							break
						end
					end
				end
			end
		end
	end)
	local IconCandidates, SeenIconKeys = {}, {}
	local function AddIconCandidate(Value)
		if Value == nil or tostring(Value) == "" then
			return
		end
		local CandidateText = tostring(Value)
		local CandidateId = type(Value) == "number" and tostring(math.floor(Value))
			or CandidateText:match("rbxassetid://(%d+)")
			or CandidateText:match("[?&]id=(%d+)")
			or CandidateText:match("^(%d+)$")
		local CandidateKey = CandidateId and ("id:" .. CandidateId) or ("url:" .. CandidateText)
		if SeenIconKeys[CandidateKey] then
			return
		end
		SeenIconKeys[CandidateKey] = true
		table.insert(IconCandidates, Value)
	end
	AddIconCandidate(Egg.Icon)
	AddIconCandidate(Egg.EggIcon)
	local Thumbnail = nil
	for _, IconCandidate in ipairs(IconCandidates) do
		local OkThumbnail, CandidateThumbnail = pcall(function()
			return W:AssetIcon(Category, IconCandidate)
		end)
		if OkThumbnail and type(CandidateThumbnail) == "string" and CandidateThumbnail:match("^https://") then
			Thumbnail = CandidateThumbnail
			break
		end
	end
	if not Thumbnail then
		pcall(function()
			Thumbnail = W:AssetIcon("N3 Hub", "rbxassetid://117688744510818")
		end)
	end
	local DebugCandidates = {}
	for _, Candidate in ipairs(IconCandidates) do
		table.insert(DebugCandidates, tostring(Candidate))
	end
	W.LastEggIconDebug = {
		Category = Category,
		ConfigModule = EggConfigModuleName,
		ConfigIcon = EggConfigIcons and EggConfigIcons[1] and EggConfigIcons[1].Value or nil,
		ConfigIconSource = EggConfigIconSource,
		Candidates = DebugCandidates,
		Thumbnail = Thumbnail,
	}
	if Thumbnail and FarmConfig.Webhook_Egg_Image ~= false then
		Embed.thumbnail = { url = Thumbnail }
	end
	return Embed
end
function InstanUtility.Webhook:SendEggNotice(Egg)
	local W = InstanUtility.Webhook
	local Embed = W:BuildEggEmbed(Egg)
	local Ok, Err, MsgId = W:SendEmbeds({ Embed }, true)
	if Ok and W:NeedsImageFollowUp(Embed) then
		W:QueueImageFollowUp(MsgId, Embed, tostring(Egg.Category or Egg.Name or ""), Egg.Icon)
	end
	return Ok, Err
end
function InstanUtility.Webhook:SendToDiscord(embeds, content)
	local W = InstanUtility.Webhook
	local Url = tostring(W.Url or "")
	if Url == "" then
		return false, "Webhook URL empty"
	end
	local Service = W:Service()
	if not Service then
		W.Failed = (W.Failed or 0) + 1
		W.LastError = "HttpService unavailable"
		return false, W.LastError
	end
	local EmbedList = {}
	if type(embeds) == "table" and (embeds.title or embeds.fields) then
		table.insert(EmbedList, embeds)
	elseif type(embeds) == "table" then
		for _, Embed in ipairs(embeds) do
			if type(Embed) == "table" then
				table.insert(EmbedList, Embed)
			end
		end
	end
	if #EmbedList == 0 then
		return false, "Nothing to send"
	end
	if #EmbedList > 10 then
		W.Failed = (W.Failed or 0) + 1
		W.LastError = "Discord allows at most 10 embeds per message"
		return false, W.LastError
	end
	local Ping = W.Ping == true
	local Payload = {
		username = "N3 Hub • Steal An Egg",
		embeds = EmbedList,
		allowed_mentions = { parse = Ping and { "everyone" } or {} },
	}
	if content and tostring(content) ~= "" then
		Payload.content = tostring(content)
	elseif Ping then
		Payload.content = "@everyone"
	end
	local OkEncode, Body = pcall(function()
		return Service:JSONEncode(Payload)
	end)
	if not OkEncode or type(Body) ~= "string" then
		W.Failed = (W.Failed or 0) + 1
		W.LastError = "Failed to encode webhook payload"
		return false, W.LastError
	end
	local function Request(TargetUrl)
		local WaitUrl = TargetUrl
		if not WaitUrl:find("wait=", 1, true) then
			WaitUrl = WaitUrl .. (WaitUrl:find("?", 1, true) and "&" or "?") .. "wait=true"
		end
		return W:SafeRequest({
			Url = WaitUrl,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = Body,
		})
	end
	local function IsSuccessful(Ok, Response)
		if not Ok or Response == false then
			return false
		end
		if type(Response) == "table" then
			local Status = tonumber(Response.StatusCode or Response.Status or Response.status_code)
			if Status and (Status < 200 or Status >= 300) then
				return false
			end
		end
		return true
	end
	local OkRequest, Response = Request(Url)
	local Status = type(Response) == "table"
			and tonumber(Response.StatusCode or Response.Status or Response.status_code)
		or nil
	local ProxyUrl = Url
	ProxyUrl = string.gsub(ProxyUrl, "^https://discord%.com/", "https://hooks.hyra.io/")
	ProxyUrl = string.gsub(ProxyUrl, "^https://discordapp%.com/", "https://hooks.hyra.io/")
	if not IsSuccessful(OkRequest, Response) and ProxyUrl ~= Url then
		OkRequest, Response = Request(ProxyUrl)
		Status = type(Response) == "table" and tonumber(Response.StatusCode or Response.Status or Response.status_code)
			or nil
	end
	if not IsSuccessful(OkRequest, Response) then
		W.Failed = (W.Failed or 0) + 1
		local Detail = ""
		if type(Response) == "table" then
			local ResponseBody = Response.Body or Response.body
			if type(ResponseBody) == "string" and ResponseBody ~= "" then
				Detail = ": " .. string.sub(ResponseBody, 1, 180)
			end
		end
		W.LastError = string.format("HTTP %s%s", tostring(Status or "request failed"), Detail)
		return false, W.LastError
	end
	W.Sent = (W.Sent or 0) + 1
	W.LastSend = os.time()
	W.LastError = "OK"
	local MsgId = nil
	pcall(function()
		local ResponseBody = type(Response) == "table" and (Response.Body or Response.body) or nil
		if type(ResponseBody) == "string" and ResponseBody ~= "" then
			local Decoded = Service:JSONDecode(ResponseBody)
			if type(Decoded) == "table" and Decoded.id then
				MsgId = tostring(Decoded.id)
			end
		end
	end)
	return true, "Sent", MsgId
end
function InstanUtility.Webhook:EditMessage(MsgId, Embeds)
	local W = InstanUtility.Webhook
	if not MsgId or MsgId == "" then
		return false
	end
	local Url = tostring(W.Url or "")
	if Url == "" then
		return false
	end
	local Service = W:Service()
	if not Service then
		return false
	end
	Url = string.gsub(Url, "%?.*$", "") .. "/messages/" .. tostring(MsgId)
	local OkEncode, Body = pcall(function()
		return Service:JSONEncode({ embeds = type(Embeds) == "table" and Embeds or { Embeds } })
	end)
	if not OkEncode then
		return false
	end
	local Ok, Response = W:SafeRequest({
		Url = Url,
		Method = "PATCH",
		Headers = { ["Content-Type"] = "application/json" },
		Body = Body,
	})
	if Ok and type(Response) == "table" then
		local Status = tonumber(Response.StatusCode or Response.Status or Response.status_code)
		if Status and (Status < 200 or Status >= 300) then
			return false
		end
	end
	return true
end
function InstanUtility.Webhook:NeedsImageFollowUp(Embed)
	local W = InstanUtility.Webhook
	local ThumbUrl = Embed and Embed.thumbnail and Embed.thumbnail.url or nil
	if ThumbUrl == nil then
		return true
	end
	local LogoUrl = nil
	pcall(function()
		LogoUrl = W:AssetIcon("N3 Hub", "rbxassetid://117688744510818")
	end)
	return LogoUrl ~= nil and ThumbUrl == LogoUrl
end
function InstanUtility.Webhook:QueueImageFollowUp(MsgId, Embed, AssetName, RawIcon)
	if not MsgId then
		return
	end
	task.spawn(function()
		local W = InstanUtility.Webhook
		for _ = 1, 8 do
			task.wait(12)
			local Ok, Url = pcall(function()
				return W:AssetIcon(AssetName, RawIcon)
			end)
			if Ok and type(Url) == "string" and Url:match("^https://") then
				Embed.thumbnail = { url = Url }
				pcall(function()
					W:EditMessage(MsgId, { Embed })
				end)
				return
			end
		end
	end)
end
function InstanUtility.Webhook:SendEmbeds(Embeds, Force)
	local W = InstanUtility.Webhook
	if not W.Enabled and Force ~= true then
		return false, "Webhook disabled"
	end
	if not W.Url or W.Url == "" then
		return false, "Please enter a webhook URL first!"
	end
	if type(Embeds) ~= "table" or #Embeds == 0 then
		return false, "Nothing to send"
	end
	return InstanUtility.Webhook:SendToDiscord(Embeds)
end
function InstanUtility.Webhook:SendSummary(Force)
	return InstanUtility.Webhook:SendEmbeds({ InstanUtility.Webhook:BuildSummary() }, Force)
end
function InstanUtility.Webhook:SendInventory(Force)
	return InstanUtility.Webhook:SendEmbeds(InstanUtility.Webhook:BuildInventory(), Force)
end
function InstanUtility.Webhook:SendEquip(Force)
	return InstanUtility.Webhook:SendEmbeds({ InstanUtility.Webhook:BuildEquip() }, Force)
end
function InstanUtility.Webhook:SendTest(Force)
	return InstanUtility.Webhook:SendEmbeds({ InstanUtility.Webhook:BuildTest() }, Force)
end
function InstanUtility.Webhook:BuildTestEggImage()
	local W = InstanUtility.Webhook
	local TestEgg = {
		Name = "Finned Thresher",
		Category = "Finned Thresher",
		Rarity = "Rare",
		Mutation = "None",
		Income = 0,
		Zone = "Test",
	}
	local Embed = W:BuildEggEmbed(TestEgg)
	local Debug = W.LastEggIconDebug or {}
	local ImageUrl = type(Debug.Thumbnail) == "string" and Debug.Thumbnail or nil
	Embed.title = "🧪 Test Send Egg — Finned Thresher"
	Embed.description = "N3 config icon image delivery test (Config.Icon preferred)"
		.. "\nConfig: "
		.. tostring(Debug.ConfigModule or "NOT FOUND")
		.. "\nIcon source: "
		.. tostring(Debug.ConfigIconSource or "nil")
		.. "\nIcon: "
		.. tostring(Debug.ConfigIcon or "nil")
	if ImageUrl then
		Embed.thumbnail = { url = ImageUrl }
		Embed.description = Embed.description .. "\nImage URL: " .. ImageUrl
	else
		Embed.description = Embed.description .. "\nNo Config.Icon or Config.Egg.Icon URL resolved."
	end
	return Embed
end
function InstanUtility.Webhook:SendEggImageTest(Force)
	return InstanUtility.Webhook:SendEmbeds({ InstanUtility.Webhook:BuildTestEggImage() }, Force)
end
function InstanUtility.Webhook:ShouldSendEgg(Egg)
	local function MatchesSelection(Selection, Candidates)
		if type(Selection) ~= "table" or next(Selection) == nil then
			return true
		end
		for _, Candidate in ipairs(Candidates) do
			local CandidateText = string.lower(tostring(Candidate or ""))
			local CandidateClean = string.gsub(CandidateText, "[^%a%d]", "")
			for Selected in pairs(Selection) do
				local SelectedText = string.lower(tostring(Selected or ""))
				if CandidateText == SelectedText or CandidateClean == string.gsub(SelectedText, "[^%a%d]", "") then
					return true
				end
			end
		end
		return false
	end
	Egg = type(Egg) == "table" and Egg or {}
	if not MatchesSelection(FarmConfig.Webhook_EggSelected, { Egg.Category, Egg.Name }) then
		return false
	end
	if not MatchesSelection(FarmConfig.Webhook_RaritySelected, { Egg.Rarity }) then
		return false
	end
	local Mutation = tostring(Egg.Mutation or "")
	if Mutation == "" then
		Mutation = "None"
	end
	if not MatchesSelection(FarmConfig.Webhook_MutationSelected, { Mutation }) then
		return false
	end
	return true
end
function InstanUtility.Webhook:PrimeEggSendTracker(Eggs)
	local W = InstanUtility.Webhook
	W.EggSendKnown = {}
	W.EggSendRetryAt = {}
	if type(Eggs) == "table" then
		for _, Egg in ipairs(Eggs) do
			if type(Egg) == "table" then
				local Uid = tostring(Egg.Uid or "")
				if Uid ~= "" then
					W.EggSendKnown[Uid] = true
				end
			end
		end
	end
	W.EggSendReady = true
end
function InstanUtility.Webhook:CheckNewEggs()
	local W = InstanUtility.Webhook
	if FarmConfig.Webhook_AutoSendEgg ~= true or not W.Enabled or not W:IsValidUrl(W.Url) then
		return
	end
	local OkEggs, Eggs = pcall(GetGameEggData, true)
	if not OkEggs or type(Eggs) ~= "table" then
		return
	end
	if not W.EggSendReady then
		W:PrimeEggSendTracker(Eggs)
		return
	end
	W.EggSendKnown = W.EggSendKnown or {}
	W.EggSendRetryAt = W.EggSendRetryAt or {}
	for _, Egg in ipairs(Eggs) do
		if type(Egg) == "table" then
			local Uid = tostring(Egg.Uid or "")
			if Uid ~= "" and not W.EggSendKnown[Uid] then
				if not W:ShouldSendEgg(Egg) then
					W.EggSendKnown[Uid] = true
				else
					local RetryAt = tonumber(W.EggSendRetryAt[Uid]) or 0
					if os.clock() >= RetryAt then
						local OkSend, Sent, SendError = pcall(function()
							return W:SendEggNotice(Egg)
						end)
						if OkSend and Sent == true then
							W.EggSendKnown[Uid] = true
							W.EggSendRetryAt[Uid] = nil
						else
							W.EggSendRetryAt[Uid] = os.clock() + 20
							if not OkSend then
								W.LastError = tostring(Sent)
							elseif SendError then
								W.LastError = tostring(SendError)
							end
						end
					end
				end
			end
		end
	end
end
function InstanUtility.Webhook:BuildHatchEmbed(Egg)
	local W = InstanUtility.Webhook
	Egg = type(Egg) == "table" and Egg or {}
	local Name = tostring(Egg.Name or "Egg")
	local Rarity = tostring(Egg.Rarity or "Unknown")
	local Mutation = tostring(Egg.Mutation or "")
	if Mutation == "" then
		Mutation = "None"
	end
	local Income = W:FormatNumber(tonumber(Egg.Income) or 0) .. "/s"
	local Format = tostring(FarmConfig.Webhook_Hatch_Format or "Detail")
	local Embed = {
		title = "Pet Hatched!",
		description = "A pet just finished growing",
		color = W:RarityColor(Rarity),
		fields = {},
		footer = { text = "N3 Hub - Hatch Webhook" },
		timestamp = W:Timestamp(),
	}
	if FarmConfig.Webhook_Hatch_Pet ~= false then
		W:Push(Embed, "Pet", W:AnsiBox({ W:AnsiColor(Name, "cyan") }), true)
	end
	local FromEgg = tostring(Egg.EggName or "")
	if FromEgg ~= "" then
		W:Push(Embed, "From Egg", W:AnsiBox({ W:AnsiColor(FromEgg, "cyan") }), true)
	end
	if FarmConfig.Webhook_Hatch_Rarity ~= false then
		W:Push(Embed, "Rarity", W:AnsiBox({ W:AnsiColor(Rarity, "purple") }), true)
	end
	if Format ~= "Simple" then
		if FarmConfig.Webhook_Hatch_Value ~= false then
			W:Push(Embed, "Cash / second", W:AnsiBox({ W:AnsiColor(Income, "green") }), true)
		end
		if FarmConfig.Webhook_Hatch_Mutation ~= false and Mutation ~= "None" then
			W:Push(Embed, "Mutation", W:AnsiBox({ W:AnsiColor(Mutation, "orange") }), true)
		end
	end
	if Format == "Full" then
		W:Push(
			Embed,
			"Place ID",
			W:AnsiBox({ W:AnsiColor(tostring(game.JobId ~= "" and game.JobId or "Private"), "gray") }),
			false
		)
	end
	if FarmConfig.Webhook_Hatch_Image ~= false then
		pcall(function()
			for _, Candidate in ipairs({ Egg.Icon, Egg.EggIcon }) do
				if Candidate ~= nil and tostring(Candidate) ~= "" then
					local OkImg, Url = pcall(function()
						return W:AssetIcon(tostring(Egg.Category or Egg.Name or ""), Candidate)
					end)
					if OkImg and type(Url) == "string" and Url:match("^https://") then
						Embed.thumbnail = { url = Url }
						break
					end
				end
			end
			if not Embed.thumbnail then
				local Fallback = W:AssetIcon("N3 Hub", "rbxassetid://117688744510818")
				if type(Fallback) == "string" and Fallback:match("^https://") then
					Embed.thumbnail = { url = Fallback }
				end
			end
		end)
	end
	return Embed
end
function InstanUtility.Webhook:SendHatchNotice(Egg)
	local W = InstanUtility.Webhook
	if not W.Enabled or not W:IsValidUrl(W.Url) then
		return false, "Webhook off"
	end
	local Embed = W:BuildHatchEmbed(Egg)
	local Ok, Err, MsgId = W:SendEmbeds({ Embed }, true)
	if Ok and W:NeedsImageFollowUp(Embed) then
		W:QueueImageFollowUp(MsgId, Embed, tostring(Egg.Category or Egg.Name or ""), Egg.Icon)
	end
	return Ok, Err
end
function InstanUtility.Webhook:CheckHatches()
	local W = InstanUtility.Webhook
	if FarmConfig.Webhook_AutoSendHatch ~= true or not W.Enabled or not W:IsValidUrl(W.Url) then
		return
	end
	local OkEggs, Eggs = pcall(GetGameEggData, true)
	if not OkEggs or type(Eggs) ~= "table" then
		return
	end
	W.HatchKnown = W.HatchKnown or {}
	for _, Egg in ipairs(Eggs) do
		if type(Egg) == "table" then
			local Uid = tostring(Egg.Uid or "")
			if Uid ~= "" then
				local Status = tostring(Egg.StatusType or "")
				local Prev = W.HatchKnown[Uid]
				W.HatchKnown[Uid] = Status
				if Prev ~= nil and Prev ~= "Ready" and Status == "Ready" then
					task.spawn(function()
						pcall(function()
							W:SendHatchNotice(Egg)
						end)
					end)
					if FarmConfig.Webhook_Hatch_Milestone == true then
						local Count = (tonumber(W.HatchCount) or 0) + 1
						W.HatchCount = Count
						if Count % 100 == 0 then
							task.spawn(function()
								pcall(function()
									W:SendAlert("antiafk", "Hatch milestone: " .. tostring(Count) .. " pets hatched")
								end)
							end)
						end
					end
				end
			end
		end
	end
end
function InstanUtility.Webhook:SendAlert(Kind, Message)
	local W = InstanUtility.Webhook
	if not W.Enabled or not W:IsValidUrl(W.Url) then
		return false
	end
	local Level = tostring(FarmConfig.Webhook_Alert_Level or "Important")
	if Level == "Errors Only" and Kind ~= "error" then
		return false
	end
	if Level == "Important" and (Kind == "antiafk") then
		return false
	end
	local Enabled = {
		death = FarmConfig.Webhook_Alert_Death,
		kick = FarmConfig.Webhook_Alert_Kick,
		error = FarmConfig.Webhook_Alert_Error,
		antiafk = FarmConfig.Webhook_Alert_AntiAfk,
	}
	if Enabled[Kind] == false then
		return false
	end
	local Titles = {
		death = "\u{1F480} Character Died",
		kick = "\u{1F50C} Disconnected",
		error = "\u{26A0}\u{FE0F} Script Error",
		antiafk = "\u{2139}\u{FE0F} Info",
	}
	local Colors = {
		death = 0xE74C3C,
		kick = 0xE67E22,
		error = 0xC0392B,
		antiafk = 0x3498DB,
	}
	local Embed = {
		title = Titles[Kind] or "Alert",
		description = tostring(Message or ""),
		color = Colors[Kind] or 0xE74C3C,
		fields = {},
		footer = { text = "N3 Hub - Alerts" },
		timestamp = W:Timestamp(),
	}
	pcall(function()
		local Data = W:GetData()
		W:Push(Embed, "Player", "**" .. tostring(Data.PlayerName or "?") .. "**", true)
		local Job = tostring(Data.JobId or "?")
		W:Push(Embed, "Job ID", "`" .. string.sub(Job, 1, 8) .. "`", true)
		local Avatar = W:AvatarUrl(Data.UserId or LocalPlayer.UserId)
		if type(Avatar) == "string" and Avatar:match("^https://") then
			Embed.thumbnail = { url = Avatar }
		end
	end)
	return W:SendEmbeds({ Embed }, true)
end
function InstanUtility.Webhook:Sync()
	local W = InstanUtility.Webhook
	local WasEnabled = W.Enabled == true
	local RawUrl = tostring(FarmConfig.Webhook_Url or "")
	W.Url = RawUrl:match("^%s*(.-)%s*$") or RawUrl
	W.Enabled = FarmConfig.Webhook_Enabled == true
	if W.Enabled and not WasEnabled and FarmConfig.Webhook_AutoSendEgg == true then
		local OkEggs, Eggs = pcall(GetGameEggData, true)
		if OkEggs and type(Eggs) == "table" then
			W:PrimeEggSendTracker(Eggs)
		end
	end
	W.Interval = math.clamp(tonumber(FarmConfig.Webhook_Interval) or 10, 1, 1440)
	W.Ping = FarmConfig.Webhook_Ping == true
	if W.Enabled and W.SessionStartCash == nil then
		local OkCash, CashValue = pcall(function()
			return W:GetCash()
		end)
		W.SessionStartCash = OkCash and (tonumber(CashValue) or 0) or nil
	end
	if W.Enabled and W.Interval > 0 then
		W.NextDue = os.time() + (W.Interval * 60)
	else
		W.NextDue = 0
	end
end
function InstanUtility.Webhook:IntervalLoop()
	local W = InstanUtility.Webhook
	local Tick = 0
	while true do
		task.wait(2)
		Tick = Tick + 1
		pcall(function()
			if FarmConfig.Webhook_AutoSendEgg == true then
				W:CheckNewEggs()
			end
			if FarmConfig.Webhook_AutoSendHatch == true and Tick % 3 == 0 then
				W:CheckHatches()
			end
			if not FarmConfig.Webhook_Interval_Summary or not W.Enabled then
				W.NextDue = os.time() + ((tonumber(W.Interval) or 10) * 60)
				return
			end
			if InstanUtility.Webhook:IsValidUrl(W.Url) and os.time() >= (W.NextDue or 0) then
				InstanUtility.Webhook:SendSummary(true)
				if FarmConfig.Webhook_AutoSendPet == true then
					pcall(function()
						InstanUtility.Webhook:SendInventory(true)
					end)
					pcall(function()
						InstanUtility.Webhook:SendEquip(true)
					end)
				end
				W.NextDue = os.time() + ((tonumber(W.Interval) or 10) * 60)
			end
		end)
	end
end
task.spawn(InstanUtility.Webhook.IntervalLoop)
task.spawn(function()
	task.wait(3)
	local W = InstanUtility.Webhook
	local Directory = nil
	pcall(function()
		Directory = AssetsModule and AssetsModule.Directory
	end)
	if type(Directory) ~= "table" then
		return
	end
	local Names = {}
	for Name, Entry in pairs(Directory) do
		if type(Entry) == "table" and Entry.Icon ~= nil then
			table.insert(Names, Name)
		end
	end
	table.sort(Names)
	for _, Name in ipairs(Names) do
		local Entry = Directory[Name]
		pcall(function()
			W:AssetIcon(Name, Entry.Icon)
		end)
		task.wait(0.35)
	end
end)
task.spawn(function()
	local LastAlert = {}
	local function Fire(Kind, Msg)
		local Now = os.clock()
		if Now - (LastAlert[Kind] or 0) < 15 then
			return
		end
		LastAlert[Kind] = Now
		task.spawn(function()
			pcall(function()
				InstanUtility.Webhook:SendAlert(Kind, Msg)
			end)
		end)
	end
	local function BindDeath(Char)
		task.spawn(function()
			local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
			if not Hum and Char then
				Hum = Char:WaitForChild("Humanoid", 8)
			end
			if Hum then
				Hum.Died:Connect(function()
					local Pos = "unknown"
					pcall(function()
						local Hrp = Char:FindFirstChild("HumanoidRootPart")
						if Hrp then
							Pos = string.format("%.0f, %.0f, %.0f", Hrp.Position.X, Hrp.Position.Y, Hrp.Position.Z)
						end
					end)
					Fire("death", "**Your character died.** Location: `" .. Pos .. "`")
				end)
			end
		end)
	end
	pcall(function()
		if LocalPlayer.Character then
			BindDeath(LocalPlayer.Character)
		end
		LocalPlayer.CharacterAdded:Connect(BindDeath)
	end)
	pcall(function()
		local Overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
		Overlay = Overlay and Overlay:FindFirstChild("promptOverlay")
		if Overlay then
			Overlay.ChildAdded:Connect(function(Child)
				Fire(
					"kick",
					"**Kicked or disconnected.** Prompt: `" .. tostring(Child and Child.Name or "unknown") .. "`"
				)
			end)
		end
	end)
	pcall(function()
		local LogService = game:GetService("LogService")
		LogService.MessageOut:Connect(function(Message, MessageType)
			if MessageType == Enum.MessageType.MessageError then
				Fire("error", string.sub(tostring(Message), 1, 400))
			end
		end)
	end)
end)
do
	local DEFAULT_ORDER = {
		"Race",
		"StealLab",
		"StealIndex",
		"StealFilter",
		"Star",
		"Butterfly",
		"Wisp",
		"Place",
		"Essence",
		"Treadmill",
	}
	local LABELS = {
		StealFilter = "Steal Filter Eggs",
		Star = "Shooting Star",
		Race = "Racing Event",
		Butterfly = "Butterfly Bloom",
		Wisp = "Steal Wisp Quest Eggs",
		StealIndex = "Steal Missing Index Eggs",
		StealLab = "Steal Missing Lab Eggs",
		Place = "Auto Place Egg",
		Essence = "Auto Mutate",
		Treadmill = "Treadmill",
	}
	local EXCLUSIVE = { Race = true, Star = true, Butterfly = true, Wisp = true, Essence = true }
	Tasks.PriorityDefault = DEFAULT_ORDER
	Tasks.PriorityLabels = LABELS
	Tasks.PriorityOrder = table.clone(DEFAULT_ORDER)
	function Tasks.SaveTaskPriority()
		pcall(function()
			if type(writefile) ~= "function" then
				return
			end
			if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("N3Hub") then
				makefolder("N3Hub")
			end
			writefile(
				"N3Hub/TaskPriority.json",
				game:GetService("HttpService"):JSONEncode({ Order = Tasks.PriorityOrder })
			)
		end)
	end
	pcall(function()
		if type(readfile) ~= "function" then
			return
		end
		local Raw = readfile("N3Hub/TaskPriority.json")
		local Decoded = game:GetService("HttpService"):JSONDecode(Raw)
		if type(Decoded) == "table" and type(Decoded.Order) == "table" then
			local Seen, Clean = {}, {}
			for _, Key in ipairs(Decoded.Order) do
				if LABELS[Key] and not Seen[Key] then
					Seen[Key] = true
					table.insert(Clean, Key)
				end
			end
			for _, Key in ipairs(DEFAULT_ORDER) do
				if not Seen[Key] then
					Seen[Key] = true
					table.insert(Clean, Key)
				end
			end
			Tasks.PriorityOrder = Clean
		end
	end)
	function Tasks.PriorityRank(Key)
		for I, K in ipairs(Tasks.PriorityOrder) do
			if K == Key then
				return I
			end
		end
		return 99
	end
	function Tasks.PriorityCanRun(Key)
		if Key == "Race" then
			return (Tasks.RacePriority and Tasks.RacePriority()) == true
		elseif Key == "StealFilter" then
			return FarmConfig.AutoStealAll == true or FarmConfig.AutoStealSelected == true
		elseif Key == "StealIndex" then
			return FarmConfig.Index_PrioritizeMissing == true
		elseif Key == "StealLab" then
			return FarmConfig.AutoScrambleSteal == true or FarmConfig.AutoScrambleSubmit == true
		elseif Key == "Place" then
			return FarmConfig.AutoPlaceAllEggs == true or FarmConfig.AutoPlaceSelect == true
		elseif Key == "Treadmill" then
			return FarmConfig.AutoTreadmill == true and RuntimeState.OnTreadmill ~= true
		end
		return false
	end
	function Tasks.PriorityOwner()
		for _, Key in ipairs(Tasks.PriorityOrder) do
			if Tasks.PriorityCanRun(Key) then
				return Key
			end
		end
		return nil
	end
	local CacheAt, CacheVal, WaitSince = -1, false, nil
	function Tasks.PriorityStealYield()
		local Now = os.clock()
		if Now - CacheAt < 0.25 then
			return CacheVal
		end
		CacheAt = Now
		local Owner = Tasks.PriorityOwner()
		if Owner == nil or not EXCLUSIVE[Owner] then
			WaitSince = nil
			CacheVal = false
			return false
		end
		if Owner == "Race" and LocalPlayer:GetAttribute("RaceId") ~= nil then
			WaitSince = nil
			CacheVal = true
			return true
		end
		if RuntimeState.IsExecuting then
			if WaitSince == nil then
				WaitSince = Now
			end
			if Now - WaitSince < 8 then
				CacheVal = false
				return false
			end
		else
			WaitSince = nil
		end
		CacheVal = true
		return true
	end
end
local SaveManager = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/LuxyG15/N3-Hub/refs/heads/main/Manager/SaveManager.lua")
)()
local ThemeManager = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/LuxyG15/N3-Hub/refs/heads/main/Manager/ThemeManager.lua")
)()
function Tasks.BuildMainInterface()
	local MainWindow = LibraryLoader:CreateWindow({
		Title = "N3 HUB",
		Footer = "N3 Hub • Steal An Egg",
		Icon = "rbxassetid://117688744510818",
		AutoShow = true,
	})
	local HomeTab = MainWindow:AddTab("Home", "house", "Main Farm & Lifecycle")
	local PetsTab = MainWindow:AddTab("Pets", "paw-print", "Pets Management, Fuse & Auto Sell")
	local ProgressTab = MainWindow:AddTab("Progress", "trending-up", "Treadmill Training, Trails & Rewards")
	local EventTab = MainWindow:AddTab("Event", "sparkles", "Rift Events & Special Automation")
	local PredictorTab = MainWindow:AddTab("Predictor", "hourglass", "Live Egg & Rift Predictions")
	local ESPTab = MainWindow:AddTab("ESP", "eye", "Visual Trackers & Plot Monitoring")
	local SettingsTab = MainWindow:AddTab("Settings", "settings", "System & Configuration")
	SaveManager:SetLibrary(LibraryLoader)
	SaveManager:SetFolder("N3Hub")
	SaveManager:SetSubFolder("StealAnEgg")
	ThemeManager:SetLibrary(LibraryLoader)
	ThemeManager:SetFolder("N3Hub")
	SaveManager:IgnoreThemeSettings()
	local DefenseGroup = HomeTab:AddLeftGroupbox("Defense", "shield")
	DefenseGroup:AddToggle("Toggle_Defense_AntiTrap", {
		Text = "Anti Trap",
		Default = false,
		Tooltip = "Auto escape traps",
		Callback = function(State)
			FarmConfig.Defense_AntiTrap = State
		end,
	})
	DefenseGroup:AddToggle("Toggle_Defense_AntiRagdoll", {
		Text = "Anti Ragdoll",
		Default = false,
		Tooltip = "Block ragdoll & fling",
		Callback = function(State)
			FarmConfig.Defense_AntiRagdoll = State
		end,
	})
	DefenseAntiGuardToggle = DefenseGroup:AddToggle("Toggle_Defense_AntiGuard", {
		Text = "Anti Guard",
		Default = false,
		Tooltip = "Dodge guards",
		Callback = function(State)
			FarmConfig.Defense_AntiGuard = State
			local Engine = RuntimeState.StealEngine
			if Engine and Engine.SetAntiGuard then
				Engine.SetAntiGuard(State)
			end
			if State and Engine and Engine.SetLineDrop then
				Engine.SetLineDrop(false)
				if InstToggle and InstToggle.Set then
					pcall(InstToggle.Set, InstToggle, false)
				end
			end
		end,
	})
	local FarmEggGroup = HomeTab:AddLeftGroupbox("Farm Eggs", "egg")
	FarmEggGroup:AddDropdown("Dropdown_TargetZone", {
		Text = "Zone",
		Values = AreaNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Zone filter",
		Callback = function(SelectedItems)
			FarmConfig.SelectedZones = ParseMultiDropdownSelection(SelectedItems)
		end,
	})
	FarmEggGroup:AddDropdown("Dropdown_TargetEgg", {
		Text = "Egg",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Egg filter",
		Callback = function(SelectedItems)
			FarmConfig.SelectedEggs = ParseMultiDropdownSelection(SelectedItems)
		end,
	})
	FarmEggGroup:AddDropdown("Dropdown_TargetRarity", {
		Text = "Rarity",
		Values = RaritiesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Rarity filter",
		Callback = function(SelectedItems)
			FarmConfig.SelectedRarities = ParseMultiDropdownSelection(SelectedItems)
		end,
	})
	FarmEggGroup:AddDropdown("Dropdown_TargetMutation", {
		Text = "Mutation",
		Values = MutationsList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Mutation filter",
		Callback = function(SelectedItems)
			FarmConfig.SelectedMutations = ParseMultiDropdownSelection(SelectedItems)
		end,
	})
	FarmEggGroup:AddDropdown("Dropdown_StealPriority", {
		Text = "Steal Priority",
		Values = Tasks.StealPriorityOptions,
		Default = "Highest Value",
		Multi = false,
		AllowNull = false,
		Tooltip = "Steal order",
		Callback = function(Selected)
			local Engine = RuntimeState.StealEngine
			if Engine then
				Engine.State.Priority = Selected
			end
		end,
	})
	local Lbl_MainStatus = FarmEggGroup:AddLabel("", true)
	task.spawn(function()
		while true do
			task.wait(0.5)
			pcall(function()
				local status = "Idle"
				if Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal()
					and (FarmConfig.AutoStealEnabled or FarmConfig.AutoStealAll or FarmConfig.AutoStealSelected) then
					status = "Paused for Auto Race"
				elseif RuntimeState.OnTreadmill then
					status = "Training on Treadmill"
				elseif RuntimeState.IsExecuting or (IsStealActive() and not FarmConfig.Defense_InstantSteal) then
					local Engine = RuntimeState.StealEngine
					status = Engine and not FarmConfig.Defense_InstantSteal and Engine.AutoStatus or "Stealing / Moving"
				end
				Lbl_MainStatus:SetText('<font color="#D946EF"><b>Status:</b></font> ' .. status)
			end)
		end
	end)
	local TogStealAll, TogStealSelected
	TogStealAll = FarmEggGroup:AddToggle("Toggle_AutoStealAll", {
		Text = "Auto Steal All",
		Default = false,
		Tooltip = "Steal best eggs",
		Callback = function(State)
			FarmConfig.AutoStealAll = State
			FarmConfig.StealAllMode = State
			if State and TogStealSelected and TogStealSelected.Value then
				TogStealSelected:SetValue(false)
			end
			RefreshStealState()
		end,
	})
	TogStealSelected = FarmEggGroup:AddToggle("Toggle_AutoStealSelected", {
		Text = "Auto Steal Selected",
		Default = false,
		Tooltip = "Steal filtered eggs",
		Callback = function(State)
			FarmConfig.AutoStealSelected = State
			if State then
				FarmConfig.StealAllMode = false
				if TogStealAll and TogStealAll.Value then
					TogStealAll:SetValue(false)
				end
			end
			RefreshStealState()
		end,
	})
	-- BEGIN BUILTIN VISUAL UI
	FarmEggGroup:AddToggle("Toggle_Farm_SafeZoneVisual", {
		Text = "Safe Zone Visual",
		Default = false,
		Tooltip = "Optional local dummy view for normal and Instant steal. Useful for low-end devices. Does not change movement.",
		Callback = function(State)
			FarmConfig.SafeZoneVisual = State == true
			local engine = RuntimeState.StealEngine
			if engine then
				if not State then
					engine.StopSafeZoneVisual()
				elseif engine.Movement.Owner == "steal" then
					engine.StartSafeZoneVisual()
				end
			end
		end,
	})
	-- END BUILTIN VISUAL UI
	FarmEggGroup:AddSlider("Slider_Farm_TweenSpeed", {
		Text = "Tween Speed",
		Min = 100,
		Max = 1000,
		Default = 400,
		Rounding = 0,
		Tooltip = "Normal approach speed cap (N3 pace). Does not change Instant Steal or Sena deposit movement.",
		Callback = function(Value)
			FarmConfig.AutoTweenSpeed = math.clamp(tonumber(Value) or 400, 100, 1000)
            local Engine = RuntimeState.StealEngine
            if Engine and Engine.UpdateAutoStealSpeed then Engine.UpdateAutoStealSpeed() end
		end,
	})
	InstToggle = FarmEggGroup:AddToggle("Toggle_Farm_InstantSteal", {
		Text = "Instant Steal",
		Default = false,
		Tooltip = "Line drop tactic",
		Callback = function(State)
			FarmConfig.Defense_InstantSteal = State
			local Engine = RuntimeState.StealEngine
			if Engine and Engine.SetLineDrop then
				Engine.SetLineDrop(State)
			end
            if Engine and Engine.AutoWake then Engine.AutoWake() end
		end,
	})
	do
		local InstantStealDep = FarmEggGroup:AddDependencyBox()
		InstantStealDep:SetupDependencies({ { InstToggle, true } })
		InstantStealDep:AddSlider("Slider_Farm_InstantStealSteps", {
			Text = "Instant Steal Steps",
			Min = 1,
			Max = 6,
			Default = 3,
			Tooltip = "Split steps",
			Callback = function(Value)
				FarmConfig.Defense_InstantStealSteps = Value
				local Engine = RuntimeState.StealEngine
				if Engine and Engine.ApplyInstantStealSteps then
					Engine.ApplyInstantStealSteps(Value)
				end
			end,
		})
	end
	Tasks.TogAntiTreadmill = FarmEggGroup:AddToggle("Toggle_AntiTreadmill", {
		Text = "Anti Treadmill",
		Default = false,
		Tooltip = "Anti treadmill pull",
		Callback = function(State)
			FarmConfig.AntiTreadmill = State
			if State then
				if not RuntimeState.ForceAntiTreadmill then
					FarmConfig.AutoTreadmill = false
				end
				ApplyTreadmillShield(true)
				if IsPlayerRunningOnTreadmill() then
					ExitTreadmill()
					local char = LocalPlayer.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hrp and not RaceOwnsCharacter() and not RuntimeState.IsExecuting then
						hrp.CFrame = hrp.CFrame * CFrame.new(0, 1, 6)
						hrp.AssemblyLinearVelocity = Vector3.zero
					end
				end
			else
				ApplyTreadmillShield(false)
			end
		end,
	})
	FarmEggGroup:AddToggle("Toggle_Farm_InstanInteract", {
		Text = "Instant Interact",
		Default = false,
		Tooltip = "Instant interact",
		Callback = function(State)
			FarmConfig.InstanInteract = State
		end,
	})
	local EggLifecycleGroup = ProgressTab:AddRightGroupbox("Egg Lifecycle", "box")
	EggLifecycleGroup:AddDropdown("Dropdown_PlaceTargetEgg", {
		Text = "Categories",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Deposit egg filter",
		Callback = function(Selected)
			FarmConfig.PlaceSelectedEggs = ParseMultiDropdownSelection(Selected)
		end,
	})
	EggLifecycleGroup:AddDropdown("Dropdown_PlaceTargetRarity", {
		Text = "Rarity",
		Values = RaritiesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Deposit rarity filter",
		Callback = function(Selected)
			FarmConfig.PlaceSelectedRarities = ParseMultiDropdownSelection(Selected)
		end,
	})
	EggLifecycleGroup:AddDropdown("Dropdown_PlaceTargetMutation", {
		Text = "Mutation",
		Values = MutationsList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Deposit mutation filter",
		Callback = function(Selected)
			FarmConfig.PlaceSelectedMutations = ParseMultiDropdownSelection(Selected)
		end,
	})
	local TogPlaceAll, TogPlaceSelect
	TogPlaceSelect = EggLifecycleGroup:AddToggle("Toggle_AutoPlaceSelect", {
		Text = "Auto Place Selected",
		Default = false,
		Tooltip = "Deposit filtered",
		Callback = function(State)
			FarmConfig.AutoPlaceSelect = State
			if State and TogPlaceAll and TogPlaceAll.Value then
				TogPlaceAll:SetValue(false)
			end
		end,
	})
	TogPlaceAll = EggLifecycleGroup:AddToggle("Toggle_AutoPlaceAll", {
		Text = "Auto Place All",
		Default = false,
		Tooltip = "Deposit all",
		Callback = function(State)
			FarmConfig.AutoPlaceAllEggs = State
			if State and TogPlaceSelect and TogPlaceSelect.Value then
				TogPlaceSelect:SetValue(false)
			end
		end,
	})
	EggLifecycleGroup:AddToggle("Toggle_AutoHatch", {
		Text = "Auto Hatch If Ready",
		Default = false,
		Tooltip = "Auto hatch eggs",
		Callback = function(State)
			FarmConfig.AutoHatch = State
		end,
	})
	-- BEGIN WISP UI
	Tasks.BuildWispUI(HomeTab)
	-- END WISP UI
	local IndexGroup = HomeTab:AddRightGroupbox("Pet Index & Codex", "book-open")
	IndexGroup:AddDropdown("Dropdown_Index_PriorityOrder", {
		Text = "Missing Steal Order",
		Values = { "Highest Area First", "Lowest Area First", "Rarest First" },
		Default = "Highest Area First",
		Multi = false,
		AllowNull = false,
		Tooltip = "Missing hunt order",
		Callback = function(Selected)
			FarmConfig.Index_StealPriority = Selected
		end,
	})
	IndexGroup:AddDropdown("Dropdown_Index_TargetZones", {
		Text = "Target Index Zones",
		Values = AreaNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Index zone filter",
		Callback = function(Selected)
			FarmConfig.Index_SelectedZones = ParseMultiDropdownSelection(Selected)
		end,
	})
	local Lbl_IndexProgress = IndexGroup:AddLabel("Index Progress: Loading...", true)
	local Lbl_IndexRewards = IndexGroup:AddLabel('<font color="#8A8AA2">Checking unclaimed rewards...</font>', true)
	IndexGroup:AddToggle("Toggle_Index_AutoClaim", {
		Text = "Auto Claim Index Rewards",
		Default = false,
		Tooltip = "Auto claim index",
		Callback = function(State)
			FarmConfig.Index_AutoClaim = State
			if State then
				task.spawn(ClaimIndexRewards, true)
			end
		end,
	})
	IndexGroup:AddToggle("Toggle_Index_AutoClaimLimited", {
		Text = "Auto Claim Limited Eggs",
		Default = false,
		Tooltip = "Auto claim limited",
		Callback = function(State)
			FarmConfig.Index_AutoClaimLimited = State
			if State then
				task.spawn(ClaimIndexRewards, true)
			end
		end,
	})
	IndexGroup:AddToggle("Toggle_Index_PrioritizeMissing", {
		Text = "Prioritize Missing in Auto Steal",
		Default = false,
		Tooltip = "Steal missing first",
		Callback = function(State)
			FarmConfig.Index_PrioritizeMissing = State
		end,
	})
	IndexGroup:AddButton("Claim All Index Now", function()
		ClaimIndexRewards(true)
	end)
	task.spawn(function()
		local LastLimitedClaimAt = 0
		while true do
			task.wait(3.0)
			pcall(function()
				local unlocked, total, pct, unclaimed = GetIndexStatistics()
				Lbl_IndexProgress:SetText(
					string.format(
						'<b>Index Progress:</b> <font color="#57F287"><b>%d/%d Pets (%d%%)</b></font>',
						unlocked,
						total,
						pct
					)
				)
				if unclaimed > 0 then
					Lbl_IndexRewards:SetText(
						string.format('<font color="#FFAA00"><b>%d Reward(s) ready to claim!</b></font>', unclaimed)
					)
				else
					Lbl_IndexRewards:SetText('<font color="#8A8AA2">All unlocked rewards claimed.</font>')
				end
				if FarmConfig.Index_AutoClaim and unclaimed > 0 then
					ClaimIndexRewards(true)
				end
				if FarmConfig.Index_AutoClaimLimited and (unclaimed > 0 or (os.clock() - LastLimitedClaimAt) >= 10) then
					LastLimitedClaimAt = os.clock()
					ClaimIndexRewards(true)
				end
			end)
		end
	end)
	do
		local PTGroup = HomeTab:AddRightGroupbox("Task Priority", "list-ordered")
		local PTDrop, PTListLabel
		local function RefreshOrder()
			if not PTListLabel then
				return
			end
			local Lines = { '<font color="#D946EF"><b>Order:</b></font>' }
			for I, Key in ipairs(Tasks.PriorityOrder) do
				Lines[#Lines + 1] = string.format("%d. %s", I, Tasks.PriorityLabels[Key] or Key)
			end
			PTListLabel:SetText(table.concat(Lines, "\n"))
		end
		PTListLabel = PTGroup:AddLabel("Order:", true)
		local TaskNames = {}
		for _, Key in ipairs(Tasks.PriorityOrder) do
			table.insert(TaskNames, Tasks.PriorityLabels[Key] or Key)
		end
		PTDrop = PTGroup:AddDropdown("Dropdown_PriorityTask", {
			Text = "Select Task",
			Values = TaskNames,
			Default = TaskNames[1],
			Multi = false,
			AllowNull = false,
			Tooltip = "Select & reorder",
		})
		local function Move(Delta)
			local Sel = PTDrop and PTDrop.Value
			local Order = Tasks.PriorityOrder
			for I, Key in ipairs(Order) do
				if (Tasks.PriorityLabels[Key] or Key) == Sel then
					local J = I + Delta
					if J >= 1 and J <= #Order then
						Order[I], Order[J] = Order[J], Order[I]
						Tasks.SaveTaskPriority()
						RefreshOrder()
					end
					return
				end
			end
		end
		PTGroup:AddButton({
			Text = "Move Up",
			Func = function()
				Move(-1)
			end,
		})
		PTGroup:AddButton({
			Text = "Move Down",
			Func = function()
				Move(1)
			end,
		})
		PTGroup:AddButton({
			Text = "Reset To Default",
			Func = function()
				Tasks.PriorityOrder = table.clone(Tasks.PriorityDefault)
				Tasks.SaveTaskPriority()
				RefreshOrder()
			end,
		})
		PTGroup:AddLabel(
			"Higher = runs first. While an exclusive task on top is active (e.g. Racing Event), all other features wait until it finishes.",
			true
		)
		RefreshOrder()
	end
	local PetsGroup = PetsTab:AddLeftGroupbox("Pets", "paw-print")
	local FavoriteGroup = PetsTab:AddLeftGroupbox("Favorite", "star")
	FavoriteGroup:AddDropdown("Dropdown_Fav_Rule", {
		Text = "Favorite Rule",
		Values = { "Rarity Only", "Value Only", "Rarity And Value", "Rarity Or Value" },
		Default = "Rarity Only",
		Multi = false,
		AllowNull = false,
		Tooltip = "Auto lock rules",
		Callback = function(v)
			FarmConfig.Fav_Rule = v
		end,
	})
	FavoriteGroup:AddDropdown("Dropdown_Fav_MinRarity", {
		Text = "Favorite Min Rarity",
		Values = RarityNumberedList,
		Default = "7. Cosmic",
		Multi = false,
		AllowNull = false,
		Tooltip = "Min favorite rarity",
		Callback = function(v)
			FarmConfig.Fav_MinRarity = tonumber(v:match("^(%d+)")) or 7
		end,
	})
	FavoriteGroup:AddDropdown("Dropdown_Fav_Mutation", {
		Text = "Favorite Mutation",
		Values = { "Any Mutation", "None", "Golden", "Silver", "Rainbow" },
		Default = "Any Mutation",
		Multi = false,
		AllowNull = false,
		Tooltip = "Lock mutations",
		Callback = function(v)
			FarmConfig.Fav_Mutation = v
		end,
	})
	FavoriteGroup:AddSlider("Slider_Fav_MinValue", {
		Text = "Favorite Min Value",
		Min = 0,
		Max = 1000,
		Default = 0,
		Tooltip = "Min income to keep",
		Callback = function(v)
			local num = tonumber(tostring(v):match("%d+")) or 0
			FarmConfig.Fav_MinValue = num * 1000000
		end,
	})
	FavoriteGroup:AddDropdown("Dropdown_Fav_AlwaysSpecies", {
		Text = "Always Favorite Species",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Always keep species",
		Callback = function(v)
			FarmConfig.Fav_AlwaysSpecies = ParseMultiDropdownSelection(v)
		end,
	})
	FavoriteGroup:AddDivider()
	FavoriteGroup:AddToggle("Toggle_Fav_AutoPets", {
		Text = "Auto Favorite Pets",
		Default = false,
		Tooltip = "Auto favorite pets",
		Callback = function(v)
			FarmConfig.Fav_AutoPets = v
		end,
	})
	local TogFavEquip, TogUnfavEquip
	TogFavEquip = FavoriteGroup:AddToggle("Toggle_Fav_AutoEquipped", {
		Text = "Auto Favorite Equipped",
		Default = false,
		Tooltip = "Lock equipped pet",
		Callback = function(v)
			FarmConfig.Fav_AutoEquipped = v
			if v and TogUnfavEquip and TogUnfavEquip.Value then
				TogUnfavEquip:SetValue(false)
			end
		end,
	})
	TogUnfavEquip = FavoriteGroup:AddToggle("Toggle_Fav_AutoUnfavEquipped", {
		Text = "Auto Unfavorite Equipped",
		Default = false,
		Tooltip = "Unlock equipped pet",
		Callback = function(v)
			FarmConfig.Fav_AutoUnfavEquipped = v
			if v and TogFavEquip and TogFavEquip.Value then
				TogFavEquip:SetValue(false)
			end
		end,
	})
	FavoriteGroup:AddDivider()
	FavoriteGroup:AddButton("Favorite Pets Now", function()
		local total = ScanAndProcessFavorites(nil)
	end)
	FavoriteGroup:AddButton("Favorite Equip Now", function()
		local total = ScanAndProcessFavorites("EquipFav")
	end)
	FavoriteGroup:AddButton("Unfavorite Equip Now", function()
		local total = ScanAndProcessFavorites("EquipUnfav")
	end)
	task.spawn(function()
		while true do
			task.wait(3.0)
			pcall(function()
				if FarmConfig.Fav_AutoPets or FarmConfig.Fav_AutoEquipped or FarmConfig.Fav_AutoUnfavEquipped then
					local el = setthreadidentity or set_thread_identity or (syn and syn.set_thread_identity)
					if type(el) == "function" then
						pcall(el, 8)
					end
					ScanAndProcessFavorites(nil)
				end
			end)
		end
	end)
	PetsGroup:AddToggle("Toggle_Pets_AutoEquipBest", {
		Text = "Auto Equip Best Pets",
		Default = false,
		Tooltip = "Equip best pet",
		Callback = function(State)
			FarmConfig.AutoEquipBestPet = State
			if State and Remotes.RemoteWearBest then
				pcall(function()
					Remotes.RemoteWearBest:InvokeServer()
				end)
			end
		end,
	})
	PetsGroup:AddToggle("Toggle_Pets_ClaimOffline", {
		Text = "Claim Offline Earnings",
		Default = false,
		Tooltip = "Claim offline cash",
		Callback = function(State)
			FarmConfig.ClaimOfflineEarnings = State
			if State and Remotes.RemoteAwayEarnings then
				pcall(function()
					Remotes.RemoteAwayEarnings:InvokeServer()
				end)
			end
		end,
	})
	local FuseGroup = PetsTab:AddRightGroupbox("Fuse Machine", "git-merge")
	local Lbl_FuseStatus = FuseGroup:AddLabel('<font color="#D946EF"><b>Ready Trios:</b></font> Scanning...', true)
	FuseGroup:AddDropdown("Dropdown_Fuse_Priority", {
		Text = "Fuse Priority",
		Values = { "Lowest Rarity", "Highest Rarity", "Most Duplicates" },
		Default = "Lowest Rarity",
		Multi = false,
		AllowNull = false,
		Tooltip = "Fuse order",
		Callback = function(v)
			FarmConfig.Fuse_Priority = v
		end,
	})
	FuseGroup:AddDropdown("Dropdown_Fuse_PetsToUse", {
		Text = "Pets To Use",
		Values = { "All Eligible", "Specific Species Only" },
		Default = "All Eligible",
		Multi = false,
		AllowNull = false,
		Tooltip = "Fuse scope",
		Callback = function(v)
			FarmConfig.Fuse_PetsToUse = v
		end,
	})
	FuseGroup:AddDropdown("Dropdown_Fuse_MaxRarity", {
		Text = "Max Rarity To Fuse",
		Values = RarityNumberedList,
		Default = "4. Epic",
		Multi = false,
		AllowNull = false,
		Tooltip = "Max fuse rarity",
		Callback = function(v)
			FarmConfig.Fuse_MaxRarity = tonumber(v:match("^(%d+)")) or 4
		end,
	})
	FuseGroup:AddDropdown("Dropdown_Fuse_SpecificSpecies", {
		Text = "Specific Species To Fuse",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Fuse whitelist",
		Callback = function(v)
			FarmConfig.Fuse_SpecificSpecies = ParseMultiDropdownSelection(v)
		end,
	})
	FuseGroup:AddToggle("Toggle_Fuse_AutoActive", {
		Text = "Auto Fuse",
		Default = false,
		Tooltip = "Auto fuse pets",
		Callback = function(v)
			FarmConfig.Fuse_AutoActive = v
		end,
	})
	FuseGroup:AddToggle("Toggle_Fuse_SkipMutated", {
		Text = "Skip Mutated Pets",
		Default = true,
		Tooltip = "Skip mutated pets",
		Callback = function(v)
			FarmConfig.Fuse_SkipMutated = v
		end,
	})
	FuseGroup:AddButton("Eject Incomplete Slots", function()
		EjectAllSlots()
	end)
	FuseGroup:AddButton("Fuse 1 Trio Now", function()
		local trios = GetEligibleFuseTrios()
		if #trios > 0 then
			local target = trios[1]
			ExecuteFuseTrio(target)
		else
		end
	end)
	task.spawn(function()
		while true do
			task.wait(1.5)
			pcall(function()
				local trios = GetEligibleFuseTrios()
				if Lbl_FuseStatus and Lbl_FuseStatus.SetText then
					if #trios > 0 then
						local previewText = {}
						for i = 1, math.min(#trios, 3) do
							table.insert(previewText, string.format("%s (%d)", trios[i].Category, trios[i].Count))
						end
						Lbl_FuseStatus:SetText(
							string.format(
								'<font color="#57F287"><b>%d Trios Ready:</b></font> %s',
								#trios,
								table.concat(previewText, ", ")
							)
						)
					else
						Lbl_FuseStatus:SetText('<font color="#8A8AA2">Ready Trios: 0 species available</font>')
					end
				end
				if FarmConfig.Fuse_AutoActive and #trios > 0 then
					ExecuteFuseTrio(trios[1])
					task.wait(0.5)
				end
			end)
		end
	end)
	local SellGroup = PetsTab:AddRightGroupbox("Sell", "dollar-sign")
	local SellTabbox = SellGroup:AddTabbox({ Name = "Sell Tabbox" })
	local SellPetTab = SellTabbox:AddTab("Pets", "paw-print")
	local SellEggTab = SellTabbox:AddTab("Eggs", "egg")
	FarmConfig.Sell_PetRule = FarmConfig.Sell_PetRule or "Rarity Only"
	FarmConfig.Sell_PetMaxRarity = FarmConfig.Sell_PetMaxRarity or 7
	FarmConfig.Sell_PetValueThreshold = FarmConfig.Sell_PetValueThreshold or 0
	FarmConfig.Sell_KeepMutatedPets = (FarmConfig.Sell_KeepMutatedPets ~= false)
	FarmConfig.Sell_PetBlacklist = FarmConfig.Sell_PetBlacklist or {}
	FarmConfig.Sell_EggRule = FarmConfig.Sell_EggRule or "Rarity Only"
	FarmConfig.Sell_EggMaxRarity = FarmConfig.Sell_EggMaxRarity or 3
	FarmConfig.Sell_EggValueThreshold = FarmConfig.Sell_EggValueThreshold or 0
	FarmConfig.Sell_KeepMutatedEggs = (FarmConfig.Sell_KeepMutatedEggs ~= false)
	FarmConfig.Sell_EggBlacklist = FarmConfig.Sell_EggBlacklist or {}
	local Lbl_PetSellPreview = SellPetTab:AddLabel(
		'<font color="#D946EF"><b>Pets Matched:</b></font> <font color="#8A8AA2">Waiting for scan...</font>',
		true
	)
	local Lbl_EggSellPreview = SellEggTab:AddLabel(
		'<font color="#D946EF"><b>Eggs Matched:</b></font> <font color="#8A8AA2">Waiting for scan...</font>',
		true
	)
	local Lbl_PetSellSold =
		SellPetTab:AddLabel('<font color="#D946EF"><b>Pets Sold:</b></font> <font color="#8A8AA2">None</font>', true)
	local Lbl_EggSellSold =
		SellEggTab:AddLabel('<font color="#D946EF"><b>Eggs Sold:</b></font> <font color="#8A8AA2">None</font>', true)
	local SellStats = { Pets = 0, Eggs = 0 }
	SellPetTab:AddButton("Sell Pets Now", function()
		local pUids, _ = GetSellablePets()
		if #pUids > 0 then
			ExecuteSellSelection(pUids, {})
			SellStats.Pets = SellStats.Pets + #pUids
		end
	end)
	SellPetTab:AddDropdown("Dropdown_Sell_PetRule", {
		Text = "Sell Pet Rule",
		Values = SellRuleOptions,
		Default = "Rarity Only",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.Sell_PetRule = v
		end,
	})
	SellPetTab:AddDropdown("Dropdown_Sell_PetMaxRarity", {
		Text = "Pet Max Rarity",
		Values = RarityNumberedList,
		Default = "7. Cosmic",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.Sell_PetMaxRarity = tonumber(v:match("^(%d+)")) or 7
		end,
	})
	SellPetTab:AddSlider("Slider_Sell_PetValueThreshold", {
		Text = "Pet Value Threshold",
		Min = 0,
		Max = 1000,
		Default = 0,
		Callback = function(v)
			local num = tonumber(tostring(v):match("%d+")) or 0
			FarmConfig.Sell_PetValueThreshold = num * 1000000
		end,
	})
	SellPetTab:AddDropdown("Dropdown_Sell_PetBlacklist", {
		Text = "Blacklist Sell Pets",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(v)
			FarmConfig.Sell_PetBlacklist = ParseMultiDropdownSelection(v)
		end,
	})
	SellPetTab:AddToggle("Toggle_Sell_AutoPets", {
		Text = "Auto Sell Pets",
		Default = false,
		Callback = function(v)
			FarmConfig.Sell_AutoPets = v
		end,
	})
	SellPetTab:AddToggle("Toggle_Sell_KeepMutatedPets", {
		Text = "Keep Mutated Pets",
		Default = true,
		Callback = function(v)
			FarmConfig.Sell_KeepMutatedPets = v
		end,
	})
	SellEggTab:AddButton("Sell Eggs Now", function()
		local eUids, _ = GetSellableEggs()
		if #eUids > 0 then
			ExecuteSellSelection({}, eUids)
			SellStats.Eggs = SellStats.Eggs + #eUids
		end
	end)
	SellEggTab:AddDropdown("Dropdown_Sell_EggRule", {
		Text = "Sell Egg Rule",
		Values = SellRuleOptions,
		Default = "Rarity Only",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.Sell_EggRule = v
		end,
	})
	SellEggTab:AddDropdown("Dropdown_Sell_EggMaxRarity", {
		Text = "Egg Max Rarity",
		Values = RarityNumberedList,
		Default = "3. Rare",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			FarmConfig.Sell_EggMaxRarity = tonumber(v:match("^(%d+)")) or 3
		end,
	})
	SellEggTab:AddSlider("Slider_Sell_EggValueThreshold", {
		Text = "Egg Value Threshold",
		Min = 0,
		Max = 1000,
		Default = 0,
		Callback = function(v)
			local num = tonumber(tostring(v):match("%d+")) or 0
			FarmConfig.Sell_EggValueThreshold = num * 1000000
		end,
	})
	SellEggTab:AddDropdown("Dropdown_Sell_EggBlacklist", {
		Text = "Blacklist Sell Eggs",
		Values = EggNamesList,
		Default = {},
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Callback = function(v)
			FarmConfig.Sell_EggBlacklist = ParseMultiDropdownSelection(v)
		end,
	})
	SellEggTab:AddToggle("Toggle_Sell_AutoEggs", {
		Text = "Auto Sell Eggs",
		Default = false,
		Callback = function(v)
			FarmConfig.Sell_AutoEggs = v
		end,
	})
	SellEggTab:AddToggle("Toggle_Sell_KeepMutatedEggs", {
		Text = "Keep Mutated Eggs",
		Default = true,
		Callback = function(v)
			FarmConfig.Sell_KeepMutatedEggs = v
		end,
	})
	task.spawn(function()
		while true do
			task.wait(1.2)
			pcall(function()
				SetElevated8()
				local pUids, pPrice = GetSellablePets()
				if Lbl_PetSellPreview and Lbl_PetSellPreview.SetText then
					Lbl_PetSellPreview:SetText(
						string.format(
							'<font color="#D946EF"><b>Pets Matched:</b></font> <font color="#57F287"><b>%d Pets</b></font> for <b>$%s</b>',
							#pUids,
							FormatCash(pPrice)
						)
					)
				end
				local eUids, ePrice = GetSellableEggs()
				if Lbl_EggSellPreview and Lbl_EggSellPreview.SetText then
					Lbl_EggSellPreview:SetText(
						string.format(
							'<font color="#D946EF"><b>Eggs Matched:</b></font> <font color="#57F287"><b>%d Eggs</b></font> for <b>$%s</b>',
							#eUids,
							FormatCash(ePrice)
						)
					)
				end
				local pToSell = FarmConfig.Sell_AutoPets and pUids or {}
				local eToSell = FarmConfig.Sell_AutoEggs and eUids or {}
				if #pToSell > 0 or #eToSell > 0 then
					ExecuteSellSelection(pToSell, eToSell)
					SellStats.Pets = SellStats.Pets + #pToSell
					SellStats.Eggs = SellStats.Eggs + #eToSell
				end
				if Lbl_PetSellSold and Lbl_PetSellSold.SetText then
					Lbl_PetSellSold:SetText(
						SellStats.Pets > 0
								and string.format(
									'<font color="#D946EF"><b>Pets Sold:</b></font> <font color="#57F287"><b>%d Pets</b></font>',
									SellStats.Pets
								)
							or '<font color="#D946EF"><b>Pets Sold:</b></font> <font color="#8A8AA2">None</font>'
					)
				end
				if Lbl_EggSellSold and Lbl_EggSellSold.SetText then
					Lbl_EggSellSold:SetText(
						SellStats.Eggs > 0
								and string.format(
									'<font color="#D946EF"><b>Eggs Sold:</b></font> <font color="#57F287"><b>%d Eggs</b></font>',
									SellStats.Eggs
								)
							or '<font color="#D946EF"><b>Eggs Sold:</b></font> <font color="#8A8AA2">None</font>'
					)
				end
			end)
		end
	end)
	-- BEGIN AUTO MUTATE UI
	Tasks.BuildAutoMutateUI(PetsTab:AddLeftGroupbox("Mutation", "wand-sparkles"))
	-- END AUTO MUTATE UI
	local TrainingGroup = ProgressTab:AddLeftGroupbox("Training", "dumbbell")
	local Lbl_TrainingStatus = TrainingGroup:AddLabel(
		'<font color="#D946EF"><b>Status:</b></font> <font color="#8A8AA2">Idle</font>\n'
			.. '<font color="#D946EF"><b>Treadmill:</b></font> <font color="#8A8AA2">-</font>\n'
			.. '<font color="#D946EF"><b>Speed:</b></font> <font color="#8A8AA2">-</font>\n'
			.. '<font color="#D946EF"><b>Timer:</b></font> <font color="#8A8AA2">0m 0s/0</font>',
		true
	)
	TrainingGroup:AddToggle("Toggle_Prog_AutoTreadmill", {
		Text = "Auto Treadmill Training",
		Default = false,
		Tooltip = "Auto treadmill",
		Callback = function(State)
			FarmConfig.AutoTreadmill = State
			ApplyTreadmillShield(FarmConfig.AntiTreadmill and not State)
			if State then
				task.spawn(MountTreadmill)
			else
				ExitTreadmill()
			end
		end,
	})
	TrainingGroup:AddToggle("Toggle_Prog_AutoUpgTreadmill", {
		Text = "Auto Treadmill Upgrade",
		Default = false,
		Tooltip = "Auto upgrade run",
		Callback = function(State)
			FarmConfig.AutoUpgradeTreadmill = State
		end,
	})
	TrainingGroup:AddToggle("Toggle_Prog_EquipBestTrail", {
		Text = "Auto Equip Best Trail",
		Default = false,
		Tooltip = "Equip best trail",
		Callback = function(State)
			FarmConfig.AutoEquipBestTrail = State
		end,
	})
	TrainingGroup:AddToggle("Toggle_Prog_AutoBuyTrail", {
		Text = "Auto Buy Best Trail",
		Default = false,
		Tooltip = "Auto buy trail",
		Callback = function(State)
			FarmConfig.AutoBuyBestTrail = State
		end,
	})
	TrainingGroup:AddToggle("Toggle_Prog_EquipBestGear", {
		Text = "Auto Equip Best Gear",
		Default = false,
		Tooltip = "Equip best bat",
		Callback = function(State)
			if State then
				pcall(EquipBatTool)
			end
		end,
	})
	TrainingGroup:AddInput("Input_Prog_CashReserve", {
		Text = "Cash Reserve",
		Default = "0",
		Placeholder = "0",
		Numeric = false,
		Finished = false,
		Tooltip = "Cash reserve",
		Callback = function(Value)
			FarmConfig.CashReserve = ParseWeightInput(Value)
		end,
	})
	local SPEED_UNITS = {
		{ "Qa", 1e15 },
		{ "Qi", 1e18 },
		{ "Sx", 1e21 },
		{ "Sp", 1e24 },
		{ "Oc", 1e27 },
		{ "No", 1e30 },
		{ "Dc", 1e33 },
		{ "T", 1e12 },
		{ "B", 1e9 },
		{ "M", 1e6 },
		{ "K", 1e3 },
	}
	local function ParseSpeedText(txt)
		if type(txt) ~= "string" then
			return 0
		end
		local Clean = txt:gsub("[%$,%s]", "")
		local Num, Suffix = Clean:match("^([%d%.]+)(.*)$")
		local Value = tonumber(Num)
		if not Value then
			return 0
		end
		Suffix = Suffix or ""
		for _, U in ipairs(SPEED_UNITS) do
			if string.sub(Suffix, 1, #U[1]) == U[1] then
				return Value * U[2]
			end
		end
		return Value
	end
	local _HudSpeedValue, _HudSpeedScanAt = nil, 0
	local function GetHudSpeedText()
		local Value = _HudSpeedValue
		if not (Value and Value.Parent) then
			local now = os.clock()
			if now - _HudSpeedScanAt < 2 then
				return nil
			end
			_HudSpeedScanAt = now
			local Pgui = LocalPlayer:FindFirstChild("PlayerGui")
			local Hud = Pgui and Pgui:FindFirstChild("HUD")
			local SpeedFrame = Hud and Hud:FindFirstChild("Speed", true)
			Value = SpeedFrame and SpeedFrame:FindFirstChild("Value", true) or nil
			_HudSpeedValue = Value
		end
		if Value and Value.Text and Value.Text ~= "" then
			return Value.Text
		end
		return nil
	end
	local TREADMILL_STEPS_PER_SECOND = 20
	local _RateText, _RateTextAt = nil, 0
	local function GetTreadmillRateTextRaw()
		local Renders = Workspace:FindFirstChild("__ClientTreadmillRenders")
		if not Renders then
			return nil
		end
		local Char = LocalPlayer.Character
		local RootPart = Char and Char:FindFirstChild("HumanoidRootPart")
		local Best, BestDist
		for _, Render in ipairs(Renders:GetChildren()) do
			local SpPart = Render:FindFirstChild("SpeedPerSecond")
			if SpPart then
				if RootPart then
					local Dist = (SpPart.Position - RootPart.Position).Magnitude
					if not BestDist or Dist < BestDist then
						BestDist = Dist
						Best = SpPart
					end
				elseif not Best then
					Best = SpPart
				end
			end
		end
		if not Best then
			return nil
		end
		for _, Desc in ipairs(Best:GetDescendants()) do
			if Desc:IsA("TextLabel") and Desc.Text and Desc.Text ~= "" then
				local PerStep = tonumber(string.match(Desc.Text:gsub("[%$,]", ""), "([%d%.]+)"))
				if PerStep then
					return FormatCash(PerStep * TREADMILL_STEPS_PER_SECOND) .. "/s"
				end
				return Desc.Text
			end
		end
		return nil
	end
	local function GetTreadmillRateText()
		local now = os.clock()
		if _RateTextAt == 0 or (now - _RateTextAt) >= 1 then
			_RateTextAt = now
			_RateText = GetTreadmillRateTextRaw()
		end
		return _RateText
	end
	local function IsOnTreadmill()
		local ok, result = pcall(IsPlayerRunningOnTreadmill)
		return ok and result and (RuntimeState.OnTreadmill == true
			or os.clock() - Tasks.TreadmillState.LastGainAt < 6)
	end
	local TrainSession = { Active = false, StartTime = 0, StartSpeed = 0 }
	local LastStatusText = ""
	task.spawn(function()
		while true do
			task.wait(0.2)
			pcall(function()
				local OnPad = IsOnTreadmill()
				local SpeedText = GetHudSpeedText()
				local SpeedValue = ParseSpeedText(SpeedText)
				if OnPad and not TrainSession.Active then
					TrainSession.Active = true
					TrainSession.StartTime = os.time()
					TrainSession.StartSpeed = SpeedValue
				elseif not OnPad and TrainSession.Active then
					TrainSession.Active = false
					TrainSession.StartTime = 0
					TrainSession.StartSpeed = 0
				end
				local StatusText = OnPad and '<font color="#57F287"><b>Training</b></font>'
					or '<font color="#8A8AA2">Idle</font>'
				local RateText = GetTreadmillRateText()
				RateText = RateText and ('<font color="#57F287"><b>' .. RateText .. "</b></font>")
					or '<font color="#8A8AA2">-</font>'
				SpeedText = SpeedText and ('<font color="#57F287"><b>' .. SpeedText .. "</b></font>")
					or '<font color="#8A8AA2">-</font>'
				local TimerText
				if TrainSession.Active then
					local Elapsed = os.time() - TrainSession.StartTime
					local Gain = math.max(SpeedValue - TrainSession.StartSpeed, 0)
					TimerText = string.format(
						'<font color="#57F287"><b>%dm %ds/%s</b></font>',
						math.floor(Elapsed / 60),
						Elapsed % 60,
						FormatCash(Gain)
					)
				else
					TimerText = '<font color="#8A8AA2">0m 0s/0</font>'
				end
				local NewText = '<font color="#D946EF"><b>Status:</b></font> '
					.. StatusText
					.. '\n<font color="#D946EF"><b>Treadmill:</b></font> '
					.. RateText
					.. '\n<font color="#D946EF"><b>Speed:</b></font> '
					.. SpeedText
					.. '\n<font color="#D946EF"><b>Timer:</b></font> '
					.. TimerText
				if NewText ~= LastStatusText then
					LastStatusText = NewText
					Lbl_TrainingStatus:SetText(NewText)
				end
			end)
		end
	end)
	local EspGroup = ESPTab:AddLeftGroupbox("ESP", "eye")
	EspGroup:AddToggle("Toggle_Chiyo_WorldEgg", {
		Text = "World Egg ESP",
		Default = false,
		Tooltip = "Show wild eggs",
		Callback = function(State)
			FarmConfig.ESP_WorldEgg = State
		end,
	})
	EspGroup:AddToggle("Toggle_Chiyo_CarryDrop", {
		Text = "Carried And Dropped Egg ESP",
		Default = false,
		Tooltip = "Show carried eggs",
		Callback = function(State)
			FarmConfig.ESP_CarriedDropped = State
		end,
	})
	EspGroup:AddToggle("Toggle_Chiyo_Guard", {
		Text = "Guard ESP",
		Default = false,
		Tooltip = "Show guards",
		Callback = function(State)
			FarmConfig.ESP_Guard = State
		end,
	})
	EspGroup:AddToggle("Toggle_Chiyo_Pet", {
		Text = "Pet ESP",
		Default = false,
		Tooltip = "Show plot pets",
		Callback = function(State)
			FarmConfig.ESP_Pet = State
		end,
	})
	EspGroup:AddToggle("Toggle_Chiyo_Player", {
		Text = "Player ESP",
		Default = false,
		Tooltip = "Show players",
		Callback = function(State)
			FarmConfig.ESP_Player = State
		end,
	})
	EspGroup:AddToggle("Toggle_Chiyo_Machine", {
		Text = "Machine ESP",
		Default = false,
		Tooltip = "Show machines",
		Callback = function(State)
			FarmConfig.ESP_Machine = State
		end,
	})
	EspGroup:AddToggle("Toggle_Chiyo_Plot", {
		Text = "Plot ESP",
		Default = false,
		Tooltip = "Show plot numbers",
		Callback = function(State)
			FarmConfig.ESP_Plot = State
		end,
	})
	EspGroup:AddInput("Input_Chiyo_EspDistance", {
		Text = "ESP Distance",
		Default = "2000",
		Placeholder = "2000",
		Numeric = true,
		Finished = false,
		Tooltip = "Max ESP distance",
		Callback = function(Value)
			FarmConfig.ESP_Distance = tonumber(Value) or 2000
		end,
	})
	EspGroup:AddDropdown("Dropdown_CardShowInfo", {
		Text = "ESP Show Info",
		Values = { "Icon", "Name", "Rarity", "Mutation", "Value", "Weight", "Size", "Distance", "Area", "State" },
		Default = { "Icon", "Name", "Rarity" },
		Multi = true,
		AllowNull = true,
		Searchable = true,
		Tooltip = "Egg card lines",
		Callback = function(SelectedItems)
			local map = ParseMultiDropdownSelection(SelectedItems)
			FarmConfig.ESP_ShowInfo = {
				Icon = map["icon"] ~= nil,
				Name = map["name"] ~= nil,
				Rarity = map["rarity"] ~= nil,
				Mutation = map["mutation"] ~= nil,
				Value = map["value"] ~= nil,
				Weight = map["weight"] ~= nil,
				Size = map["size"] ~= nil,
				Distance = map["distance"] ~= nil,
				Area = map["area"] ~= nil,
				State = map["state"] ~= nil,
			}
		end,
	})
	EspGroup:AddDropdown("Dropdown_CardMinRarity", {
		Text = "ESP Min Rarity",
		Values = RarityNumberedList,
		Default = "5. Legendary",
		Multi = false,
		AllowNull = false,
		Tooltip = "Min ESP rarity",
		Callback = function(v)
			local rname = tostring(v):match("^%d+%.%s*(.+)$") or tostring(v)
			FarmConfig.ESP_MinRarity = RarityRankOf(rname)
		end,
	})
	EspGroup:AddInput("Input_MinStealValue", {
		Text = "ESP Min Value /s",
		Default = "0",
		Placeholder = "0",
		Numeric = true,
		Finished = false,
		Tooltip = "Min ESP income",
		Callback = function(Value)
			FarmConfig.ESP_MinValue = math.max(0, math.floor(tonumber(Value) or 0))
		end,
	})
	EspGroup:AddDropdown("Dropdown_CardHighlight", {
		Text = "ESP Highlight",
		Values = { "Off", "Rare Only", "All Shown" },
		Default = "Off",
		Multi = false,
		AllowNull = false,
		Tooltip = "Rarity color glow",
		Callback = function(v)
			FarmConfig.ESP_HighlightMode = v
		end,
	})
	local MoveGroup = ESPTab:AddRightGroupbox("Movement", "move")
	MoveGroup:AddInput("Input_Chiyo_WalkSpeed", {
		Text = "Walk Speed",
		Default = "16",
		Placeholder = "16",
		Numeric = true,
		Finished = false,
		Tooltip = "Walk speed",
		Callback = function(Value)
			FarmConfig.Movement_WalkSpeed = tonumber(Value) or 16
		end,
	})
	MoveGroup:AddInput("Input_Chiyo_JumpPower", {
		Text = "Jump Power",
		Default = "50",
		Placeholder = "50",
		Numeric = true,
		Finished = false,
		Tooltip = "Jump height",
		Callback = function(Value)
			FarmConfig.Movement_JumpPower = tonumber(Value) or 50
		end,
	})
	MoveGroup:AddToggle("Toggle_Chiyo_OverrideMove", {
		Text = "Override Movement Stats",
		Default = false,
		Tooltip = "Lock speed & jump",
		Callback = function(State)
			FarmConfig.Movement_Override = State
			if not State then
				local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.WalkSpeed = 16
					hum.JumpPower = 50
				end
			end
		end,
	})
	MoveGroup:AddToggle("Toggle_Chiyo_Noclip", {
		Text = "Noclip",
		Default = false,
		Tooltip = "Walk through walls",
		Callback = function(State)
			FarmConfig.Movement_Noclip = State
			if not State then
				local char = LocalPlayer.Character
				if char then
					for _, part in ipairs(char:GetDescendants()) do
						if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
							part.CanCollide = true
						end
					end
				end
			end
		end,
	})
	MoveGroup:AddDropdown("Dropdown_Chiyo_Waypoint", {
		Text = "Waypoint",
		Values = WaypointNames,
		Default = "Base / Plot",
		Multi = false,
		AllowNull = false,
		Tooltip = "Teleport target",
		Callback = function(Selected)
			FarmConfig.Movement_SelectedWaypoint = Selected
		end,
	})
	MoveGroup:AddButton("Teleport To Waypoint", function()
		local targetLocation = WaypointLocations[FarmConfig.Movement_SelectedWaypoint]
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp and targetLocation then
			CreateSafetyFloorPad(targetLocation, 8)
			hrp.CFrame = CFrame.new(targetLocation + Vector3.new(0, 3, 0))
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
		end
	end)
	local RaceRallyGroup = EventTab:AddLeftGroupbox("Race Rally", "flag")
	local Lbl_RaceStatus = RaceRallyGroup:AddLabel('<font color="#D946EF"><b>Status:</b></font> Off', true)
	local Lbl_RaceStats = RaceRallyGroup:AddLabel(
		'<font color="#D946EF"><b>Tokens:</b></font> 0   <font color="#D946EF"><b>Wins:</b></font> 0   <font color="#D946EF"><b>Racer:</b></font> Ostrich',
		true
	)
	task.spawn(function()
		local LastS, LastT = nil, nil
		while not LibraryLoader.Unloaded do
			task.wait(1)
			pcall(function()
				local St = Tasks.RaceState
				if not St then
					return
				end
				local S = '<font color="#D946EF"><b>Status:</b></font> ' .. tostring(St.Status or "Off")
				if S ~= LastS then
					LastS = S
					Lbl_RaceStatus:SetText(S)
				end
				local T = string.format(
					'<font color="#D946EF"><b>Tokens:</b></font> %s   <font color="#D946EF"><b>Wins:</b></font> %s   <font color="#D946EF"><b>Racer:</b></font> %s',
					tostring(St.Tokens or "0"),
					tostring(St.Wins or "0"),
					tostring(St.Racer or "Ostrich")
				)
				if T ~= LastT then
					LastT = T
					Lbl_RaceStats:SetText(T)
				end
			end)
		end
	end)
	local RaceAutoToggle = RaceRallyGroup:AddToggle("Toggle_Race_AutoRace", {
		Text = "Auto Race",
		Default = false,
		Tooltip = "Auto join & race",
		Callback = function(State)
			FarmConfig.Race_AutoRace = State == true
			if Tasks.RaceSettingsChanged then
				Tasks.RaceSettingsChanged("Enabled")
			end
		end,
	})
	local RaceDriveOptions = RaceRallyGroup:AddDependencyBox()
	RaceDriveOptions:SetupDependencies({ { RaceAutoToggle, true } })
	RaceDriveOptions:AddSlider("Slider_Race_Speed", {
		Text = "Race Speed",
		Min = 100,
		Max = 144,
		Default = 144,
		Rounding = 0,
		Tooltip = "N3 race range: 100–144. Lower this if laps or wins do not count.",
		Callback = function(Value)
			FarmConfig.Race_Speed = math.clamp(math.floor(tonumber(Value) or 144), 100, 144)
			if Tasks.RaceSettingsChanged then
				Tasks.RaceSettingsChanged("Speed")
			end
		end,
	})
	RaceDriveOptions:AddToggle("Toggle_Race_PowerUps", {
		Text = "Auto Use Power-Ups",
		Default = true,
		Tooltip = "Grab & use powerups",
		Callback = function(State)
			FarmConfig.Race_PowerUps = State == true
		end,
	})
	RaceRallyGroup:AddToggle("Toggle_Race_AutoClaim", {
		Text = "Auto Claim Race Rewards",
		Default = false,
		Tooltip = "Auto claim rewards",
		Callback = function(State)
			FarmConfig.Race_AutoClaim = State == true
		end,
	})
	local RaceEquipToggle = RaceRallyGroup:AddToggle("Toggle_Race_AutoEquip", {
		Text = "Auto Equip Racer",
		Default = true,
		Tooltip = "Auto equip racer",
		Callback = function(State)
			FarmConfig.Race_AutoEquip = State == true
			if Tasks.RaceSettingsChanged then
				Tasks.RaceSettingsChanged("Racer")
			end
		end,
	})
	local RaceEquipOptions = RaceRallyGroup:AddDependencyBox()
	RaceEquipOptions:SetupDependencies({ { RaceEquipToggle, true } })
	Tasks.RaceRacerDropdown = RaceEquipOptions:AddDropdown("Dropdown_Race_Racer", {
		Text = "Racer",
		Values = { "Best Owned", "Ostrich" },
		Default = "Best Owned",
		Multi = false,
		AllowNull = false,
		Tooltip = "Racer to use",
		Callback = function(Selected)
			FarmConfig.Race_Racer = tostring(Selected or "Best Owned")
			if Tasks.RaceSettingsChanged then
				Tasks.RaceSettingsChanged("Racer")
			end
		end,
	})
	local RaceBuyToggle = RaceRallyGroup:AddToggle("Toggle_Race_AutoBuy", {
		Text = "Auto Buy Race Shop",
		Default = false,
		Tooltip = "Auto buy shop items",
		Callback = function(State)
			FarmConfig.Race_AutoBuy = State == true
		end,
	})
	local RaceShopOptions = RaceRallyGroup:AddDependencyBox()
	RaceShopOptions:SetupDependencies({ { RaceBuyToggle, true } })
	RaceShopOptions:AddDropdown("Dropdown_Race_ShopItems", {
		Text = "Race Shop Items",
		Values = { "Nitro Mutation", "Cash Booster", "Speed Boost", "Treadmill Boost", "Racing Bat" },
		Default = {},
		Multi = true,
		AllowNull = true,
		Tooltip = "Shop items to buy",
		Callback = function(v)
			FarmConfig.Race_ShopItems = ParseMultiDropdownSelection(v)
		end,
	})
	Tasks.LabGroup = EventTab:AddGroupbox({
		Name = "Scramble Lab",
		IconName = "flask-conical",
		Side = 2,
		Visible = true,
		Collapsed = false,
		DisableCollapsing = false,
	})
	Tasks.LabTabbox = Tasks.LabGroup:AddTabbox({ Name = "Lab Tabs" })
	local ScrambleEggGroup = Tasks.LabTabbox:AddTab("Lab Trade", "arrow-left-right")
	DrScramble.BuildLabSellerUI(Tasks.LabTabbox:AddTab("Lab Sell", "badge-dollar-sign"))
	local ScrambleLabUI = {
		Trade = ScrambleEggGroup:AddLabel('<font color="#D946EF"><b>Trade-In:</b></font> 0/3\n1. -\n2. -\n3. -', true),
	}
	ScrambleEggGroup:AddToggle("Toggle_AutoScrambleSteal", {
		Text = "Auto Steal Lab Eggs",
		Default = false,
		Tooltip = "Steal lab wants",
		Callback = function(State)
			FarmConfig.AutoScrambleSteal = State
			Tasks.LabState.Revision += 1
			table.clear(RuntimeState.ScrambleWanted)
			table.clear(RuntimeState.ScrambleReserved)
			FarmConfig.AutoStealEnabled = State
			if State then
				RuntimeState.StealCancel = RuntimeState.StealCancel + 1
				pcall(RefreshScrambleState, true)
				pcall(GetScrambleTradeStatusFn)
				PerformHumanoidSwap()
				EnableDesyncGodmode()
			else
				pcall(RefreshStealState)
			end
		end,
	})
	ScrambleEggGroup:AddToggle("Toggle_AutoScrambleSubmit", {
		Text = "Auto Trade-In",
		Default = false,
		Tooltip = "Auto lab trade-in",
		Callback = function(State)
			FarmConfig.AutoScrambleSubmit = State
			Tasks.LabState.Revision += 1
			table.clear(RuntimeState.ScrambleReserved)
			if State then
				pcall(RefreshScrambleState, true)
			end
		end,
	})
	ScrambleEggGroup:AddToggle("Toggle_Scramble_AutoReroll", {
		Text = "Auto Reroll Recipe",
		Default = false,
		Tooltip = "Auto reroll recipe",
		Callback = function(State)
			FarmConfig.Scramble_AutoReroll = State
			Tasks.LabState.Revision += 1
			if State then
				pcall(RefreshScrambleState, true)
			end
		end,
	})
	ScrambleEggGroup:AddToggle("Toggle_Scramble_LabFilter", {
		Text = "Filter Banners",
		Default = false,
		Tooltip = "Banner filter",
		Callback = function(State)
			FarmConfig.Scramble_LabBannerFilterOn = State
			Tasks.LabState.Revision += 1
			pcall(GetScrambleTradeStatusFn)
		end,
	})
	ScrambleEggGroup:AddDropdown("Dropdown_Scramble_LabBanners", {
		Text = "Lab Banners",
		Multi = true,
		AllowNull = true,
		Values = DrScramble.LabBannerOptions,
		Callback = function(v)
			FarmConfig.Scramble_LabBanners = ParseMultiDropdownSelection(v)
			Tasks.LabState.Revision += 1
			pcall(GetScrambleTradeStatusFn)
		end,
	})
	-- BEGIN LAB STOCK UI
	DrScramble.BuildStockUI(ScrambleEggGroup)
	-- END LAB STOCK UI
	local ScrambleOddsSpotlight = ScrambleEggGroup:AddSpotlightCard("ScrambleOddsSpotlight", {
		Title = "Pet Preview",
		Description = "Click a pet in the odds list.",
		Image = "",
	})
	local ScrambleOddsFeed = ScrambleEggGroup:AddScrollFeed("ScrambleOddsFeed", {
		Height = 190,
	})
	local ScrambleOddsLastBanner = nil
	local ScrambleOddsVisible = true
	local function SetScrambleOddsVisible(Visible)
		ScrambleOddsVisible = Visible and true or false
		pcall(function()
			if ScrambleOddsFeed and ScrambleOddsFeed.Scroll then
				ScrambleOddsFeed.Scroll.Visible = ScrambleOddsVisible
			end
		end)
		pcall(function()
			if ScrambleOddsSpotlight and ScrambleOddsSpotlight.Frame then
				ScrambleOddsSpotlight.Frame.Visible = ScrambleOddsVisible
			end
		end)
	end
	ScrambleEggGroup:AddToggle("Toggle_ToggleScrambleOdds", {
		Text = "Show Odds",
		Default = true,
		Tooltip = "Pet odds panel",
		Callback = function(State)
			SetScrambleOddsVisible(State)
		end,
	})
	local LastOddsSig = nil
	local function RebuildScrambleOdds(info)
		local odds = info.PetOdds
		if #odds == 0 then
			return
		end
		do
			local sigParts = {}
			for _, o in ipairs(odds) do
				sigParts[#sigParts + 1] = tostring(o.AssetId or "?") .. "=" .. tostring(o.Weight or 0)
			end
			local sig = table.concat(sigParts, "|")
			if sig == LastOddsSig then
				return
			end
			LastOddsSig = sig
		end
		local total = 0
		for _, o in ipairs(odds) do
			total = total + (tonumber(o.Weight) or 0)
		end
		local sorted = {}
		for i, o in ipairs(odds) do
			sorted[i] = o
		end
		table.sort(sorted, function(a, b)
			return (tonumber(a.Weight) or 0) > (tonumber(b.Weight) or 0)
		end)
		ScrambleOddsFeed:Clear()
		local first = true
		for pos, o in ipairs(sorted) do
			local assetId = tostring(o.AssetId or "?")
			local meta = AssetsModule and AssetsModule.Directory and AssetsModule.Directory[assetId]
			local displayName = assetId
			local icon = ""
			local rarity = "Common"
			local color = nil
			if type(meta) == "table" then
				if meta.DisplayName and meta.DisplayName ~= "" then
					displayName = tostring(meta.DisplayName)
				end
				icon = tostring(meta.Icon or (meta.Egg and meta.Egg.Icon) or "")
				if type(meta.Rarity) == "table" then
					rarity = tostring(meta.Rarity.DisplayName or meta.Rarity._id or "Common")
				end
				color = meta.Color
			end
			local iconUrl = icon:match("%d+") and ("rbxassetid://" .. icon:match("%d+")) or ""
			local pct = total > 0 and ((tonumber(o.Weight) or 0) / total * 100) or 0
			local hexRarity = ColorToHex(color or DefaultRarityColors[rarity] or Color3.fromRGB(255, 255, 255))
			local model3d = GetPet3DModel(assetId)
			local titleStr = InstanUtility.FormatEggLabel(displayName, rarity)
			ScrambleOddsFeed:AddItem({
				Icon = iconUrl,
				Title = titleStr,
				Detail = string.format('<font color="#FFAA00"><b>%.2f%%</b></font>  chance', pct),
				RightTag = "#" .. pos,
				OnClick = function()
					if ScrambleOddsSpotlight and ScrambleOddsSpotlight.SetData then
						ScrambleOddsSpotlight:SetData(
							titleStr,
							string.format(
								"<b>Odds:</b> %.2f%%\n<b>Rarity:</b> %s\n<b>Asset:</b> %s",
								pct,
								tostring(rarity),
								assetId
							),
							iconUrl,
							model3d
						)
					end
				end,
			})
			if first then
				first = false
				pcall(function()
					if ScrambleOddsSpotlight and ScrambleOddsSpotlight.SetData then
						ScrambleOddsSpotlight:SetData(
							titleStr,
							string.format(
								"<b>Odds:</b> %.2f%%\n<b>Rarity:</b> %s\n<b>Asset:</b> %s",
								pct,
								tostring(rarity),
								assetId
							),
							iconUrl,
							model3d
						)
					end
				end)
			end
		end
	end
	task.spawn(function()
		while true do
			task.wait(1.0)
			pcall(function()
				local info = Tasks.GetScrambleOverview()
				local reqs = info.Requirements
				local filled = #info.Picks
				local lines = {
					string.format(
						'<font color="%s"><b>Trade-In:</b></font> %d/%d',
						info.Ready and "#57F287" or "#D946EF",
						filled,
						SCRAMBLE_TRADE_SLOTS
					),
				}
				for i = 1, SCRAMBLE_TRADE_SLOTS do
					local name = reqs[i]
					if name == nil then
						table.insert(lines, string.format('<font color="#8A8AA2">%d. -</font>', i))
					else
						local isReady = info.SlotPicks[i] ~= nil
						local line = isReady
								and string.format('<font color="#57F287"><b>%d. %s</b></font>', i, tostring(name))
							or string.format("%d. %s", i, tostring(name))
						table.insert(lines, line)
					end
				end
				if not info.Unlocked and info.UnlockPower > 0 then
					table.insert(
						lines,
						string.format(
							'<font color="#FF5C5C"><b>Locked:</b></font> needs %s Speed Power (have %s)',
							FormatCash(info.UnlockPower),
							FormatCash(info.MyPower)
						)
					)
				end
				ScrambleLabUI.Trade:SetText(table.concat(lines, "\n"))
				local bannerId = tostring(info.State.BannerId or "")
				if bannerId ~= ScrambleOddsLastBanner then
					ScrambleOddsLastBanner = bannerId
					RebuildScrambleOdds(info)
					SetScrambleOddsVisible(ScrambleOddsVisible)
				end
			end)
		end
	end)
	local CurrentSortMode = "Value"
	local SearchFilterText = ""
	local CurrentSelectedUid = nil
	local ActiveCategory = "Ready"
	local FuseSizeBrackets = {
		{ min = 0.85, max = 1.05, weight = 2000, color = "#FFFFFF" },
		{ min = 1.45, max = 1.55, weight = 250, color = "#7CFF9E" },
		{ min = 1.90, max = 2.10, weight = 125, color = "#4FE0FF" },
		{ min = 2.85, max = 3.15, weight = 62.5, color = "#6FA0FF" },
		{ min = 3.80, max = 4.20, weight = 31.25, color = "#C08BFF" },
		{ min = 0.30, max = 0.45, weight = 18, color = "#C6CDDA" },
		{ min = 0.10, max = 0.20, weight = 5, color = "#8F98A8" },
		{ min = 5.80, max = 6.20, weight = 15.625, color = "#FF9A3D" },
		{ min = 9.50, max = 12.50, weight = 3, color = "#FF5C5C" },
		{ min = 12.00, max = 17.00, weight = 0.05, color = "#FFD34D" },
		{ min = 20.00, max = 35.00, weight = 0.0001, color = "#FF4DE8" },
	}
	local MainPredictorGroup = PredictorTab:AddLeftGroupbox("Egg Predictor", "egg")
	local Spotlight = MainPredictorGroup:AddSpotlightCard("SpotlightCard", {
		Height = 110,
		Title = "Scanning eggs...",
		Description = "Reading inventory...",
		Image = "",
	})
	do
		local RawSetData = Spotlight.SetData
		local LastModelSource = nil
		Spotlight.SetData = function(self, titleText, descText, imageAsset, modelSource)
			local modeChanged = (modelSource == nil) ~= (LastModelSource == nil)
			if (modelSource ~= nil and modelSource ~= LastModelSource) or modeChanged then
				LastModelSource = modelSource
				RawSetData(self, titleText, descText, imageAsset, modelSource)
			else
				if self.Title and titleText then
					self.Title.Text = titleText
				end
				if self.Desc and descText then
					self.Desc.Text = descText
				end
				if self.Icon and imageAsset and imageAsset ~= "" then
					self.Icon.Image = imageAsset
				end
			end
		end
	end
	MainPredictorGroup:AddButton("Hold egg", function()
		if CurrentSelectedUid and Remotes.RemoteWearTool then
			pcall(function()
				Remotes.RemoteWearTool:InvokeServer(CurrentSelectedUid)
			end)
		end
	end)
	MainPredictorGroup:AddDivider()
	MainPredictorGroup:AddDropdown("Dropdown_CardSort", {
		Text = "Sort By",
		Values = { "Value", "Rarity", "Time Left" },
		Default = "Value",
		Multi = false,
		AllowNull = false,
		Callback = function(v)
			CurrentSortMode = v
		end,
	})
	MainPredictorGroup:AddInput("Input_EggSearch", {
		Text = "Search Eggs",
		Default = "",
		Placeholder = "Search eggs by name, rarity...",
		Callback = function(v)
			SearchFilterText = string.lower(v or "")
		end,
	})
	MainPredictorGroup:AddDivider()
	MainPredictorGroup:AddButton({
		Text = "Ready to Hatch",
		Func = function()
			if ActiveCategory == "Ready" then
				ActiveCategory = nil
			else
				ActiveCategory = "Ready"
			end
		end,
		DoubleClick = false,
	}):AddButton({
		Text = "Growing",
		Func = function()
			if ActiveCategory == "Growing" then
				ActiveCategory = nil
			else
				ActiveCategory = "Growing"
			end
		end,
		DoubleClick = false,
	})
	MainPredictorGroup:AddButton({
		Text = "In Inventory",
		Func = function()
			if ActiveCategory == "Inventory" then
				ActiveCategory = nil
			else
				ActiveCategory = "Inventory"
			end
		end,
		DoubleClick = false,
	})
	local SingleEggFeed = MainPredictorGroup:AddScrollFeed("SingleEggFeed", {
		Height = 220,
	})
	local FusePredictGroup = PredictorTab:AddRightGroupbox("Fuse Machine Predictor", "git-merge")
	local FuseSummaryLbl = FusePredictGroup:AddLabel(
		'<font color="#8A8AA2">Load 3 pets into the Fuse Machine to predict odds.</font>',
		true
	)
	local FuseFeed = FusePredictGroup:AddScrollFeed("FuseFeed", {
		Height = 175,
	})
	task.spawn(function()
		local LastSingleEggSig, LastFuseFeedSig = nil, nil
		while true do
			task.wait(1.0)
			SetElevated8()
			pcall(function()
				local myRealEggs = GetGameEggData()
				local readyList = {}
				local growingList = {}
				local inventoryList = {}
				for _, egg in ipairs(myRealEggs) do
					if egg.StatusType == "Ready" then
						table.insert(readyList, egg)
					elseif egg.StatusType == "Growing" then
						table.insert(growingList, egg)
					else
						table.insert(inventoryList, egg)
					end
				end
				if not ActiveCategory then
					if SingleEggFeed and SingleEggFeed.Scroll then
						SingleEggFeed.Scroll.Visible = false
					end
				else
					if SingleEggFeed and SingleEggFeed.Scroll then
						SingleEggFeed.Scroll.Visible = true
					end
					local currentTargetList = (ActiveCategory == "Ready" and readyList)
						or (ActiveCategory == "Growing" and growingList)
						or inventoryList
					local isGrowingCategory = (ActiveCategory == "Growing")
					local filtered = {}
					for _, item in ipairs(currentTargetList) do
						local pass = true
						if SearchFilterText ~= "" then
							local targetStr = string.lower(item.Name .. " " .. item.Rarity .. " " .. item.Mutation)
							if not string.find(targetStr, SearchFilterText, 1, true) then
								pass = false
							end
						end
						if pass then
							table.insert(filtered, item)
						end
					end
					table.sort(filtered, function(a, b)
						if CurrentSortMode == "Value" then
							return (a.Income or 0) > (b.Income or 0)
						elseif CurrentSortMode == "Rarity" then
							if a.RarityRank ~= b.RarityRank then
								return (a.RarityRank or 0) > (b.RarityRank or 0)
							end
							return (a.Income or 0) > (b.Income or 0)
						elseif CurrentSortMode == "Time Left" then
							return (a.Remaining or 0) < (b.Remaining or 0)
						end
						return (a.Income or 0) > (b.Income or 0)
					end)
					local focus = nil
					if CurrentSelectedUid then
						for _, egg in ipairs(myRealEggs) do
							if egg.Uid == CurrentSelectedUid then
								focus = egg
								break
							end
						end
					end
					if not focus then
						focus = filtered[1] or myRealEggs[1]
						if focus then
							CurrentSelectedUid = focus.Uid
						end
					end
					if focus and Spotlight and Spotlight.SetData then
						local hexRarity = ColorToHex(
							focus.Color or DefaultRarityColors[focus.Rarity] or Color3.fromRGB(255, 255, 255)
						)
						local livePetAnimal3D = GetPet3DModel(focus.Category) or GetPet3DModel(focus.Name)
						local titleStr = InstanUtility.FormatEggLabel(focus.Name, focus.Rarity)
						local descStr = BuildPetDescription(focus)
						Spotlight:SetData(titleStr, descStr, focus.Icon, livePetAnimal3D)
					end
					if SingleEggFeed and SingleEggFeed.Clear and SingleEggFeed.AddItem then
						local sigParts = {
							tostring(ActiveCategory or ""),
							SearchFilterText or "",
							CurrentSortMode or "",
							tostring(#filtered),
						}
						for si = 1, math.min(#filtered, 40) do
							local se = filtered[si]
							sigParts[#sigParts + 1] = tostring(se.Uid) .. ":" .. tostring(se.Percent or 0)
						end
						local sig = table.concat(sigParts, "|")
						if sig ~= LastSingleEggSig then
							LastSingleEggSig = sig
							local lastY = (SingleEggFeed.Scroll and SingleEggFeed.Scroll.CanvasPosition)
									and SingleEggFeed.Scroll.CanvasPosition.Y
								or 0
							SingleEggFeed:Clear()
							for _, egg in ipairs(filtered) do
								local hexRarity = ColorToHex(
									egg.Color or DefaultRarityColors[egg.Rarity] or Color3.fromRGB(255, 255, 255)
								)
								local mutTag = (egg.Mutation and egg.Mutation ~= "")
										and (' · <font color="#FFAA00"><b>' .. egg.Mutation .. "</b></font>")
									or ""
								local detailLine = string.format(
									'<font color="#57F287"><b>%s/s</b></font> · %.2fx · %s Kg%s',
									FormatCash(egg.Income),
									egg.Scale or 1,
									FormatCash(egg.Weight),
									mutTag
								)
								local rightTagText = ""
								if isGrowingCategory then
									rightTagText = string.format(
										'<font color="#FFAA00"><b>%s • %d%%</b></font>',
										egg.StatusText,
										egg.Percent
									)
								end
								local eggTitle = InstanUtility.FormatEggLabel(egg.Name, egg.Rarity)
								SingleEggFeed:AddItem({
									Icon = egg.Icon,
									Title = eggTitle,
									Detail = detailLine,
									RightTag = rightTagText,
									OnClick = function()
										CurrentSelectedUid = egg.Uid
										local rHex = ColorToHex(
											egg.Color
												or DefaultRarityColors[egg.Rarity]
												or Color3.fromRGB(255, 255, 255)
										)
										local petModel3D = GetPet3DModel(egg.Category) or GetPet3DModel(egg.Name)
										if Spotlight and Spotlight.SetData then
											Spotlight:SetData(
												string.format(
													'<b>%s</b>  <font color="%s"><b>%s</b></font>',
													egg.Name,
													rHex,
													string.upper(egg.Rarity)
												),
												BuildPetDescription(egg),
												egg.Icon,
												petModel3D
											)
										end
									end,
								})
							end
							if SingleEggFeed.Scroll then
								SingleEggFeed.Scroll.CanvasPosition = Vector2.new(0, lastY)
							end
						end
					end
				end
				pcall(function()
					local sData = nil
					if SaveModule and type(SaveModule.Peek) == "function" then
						local ok, d = pcall(SaveModule.Peek)
						if ok and type(d) == "table" then
							sData = d
						end
					end
					if not sData then
						return
					end
					local fusionSlots = type(sData.FusionSlots) == "table" and sData.FusionSlots or {}
					local inventory = type(sData.Inventory) == "table" and sData.Inventory or {}
					local loadedPets = {}
					for i = 1, 3 do
						local pUid = fusionSlots[i]
						local petObj = pUid and inventory[pUid]
						if type(petObj) == "table" then
							table.insert(loadedPets, {
								Slot = i,
								Category = tostring(
									petObj.Category or petObj.displayName or petObj.AssetCategory or "Pet"
								),
								Scale = tonumber(petObj.Scale) or 1,
								Mutations = type(petObj.Mutations) == "table" and petObj.Mutations or {},
							})
						end
					end
					if #loadedPets == 0 then
						FuseSummaryLbl:SetText(
							'<font color="#8A8AA2">Machine is empty. Load 3 pets to predict odds.</font>'
						)
						if FuseFeed and FuseFeed.Clear then
							FuseFeed:Clear()
						end
						return
					elseif #loadedPets < 3 then
						local pInfo = ResolveGameAsset(loadedPets[1].Category)
						FuseSummaryLbl:SetText(
							string.format(
								"Loaded <b>%d/3</b> %s pets. Add %d more to see result odds.",
								#loadedPets,
								pInfo.Name,
								3 - #loadedPets
							)
						)
						if FuseFeed and FuseFeed.Clear then
							FuseFeed:Clear()
						end
						return
					end
					local petInfo = ResolveGameAsset(loadedPets[1].Category)
					local scales = { loadedPets[1].Scale, loadedPets[2].Scale, loadedPets[3].Scale }
					local avgScale = (scales[1] + scales[2] + scales[3]) / 3
					local totalWeight = 0
					local bracketChances = {}
					for _, b in ipairs(FuseSizeBrackets) do
						local bias = math.exp(
							math.log(avgScale)
								/ 0.6931471805599453
								* math.log((b.min + b.max) / 2)
								/ 0.6931471805599453
								* 0.6
						)
						local w = b.weight * bias
						totalWeight = totalWeight + w
						table.insert(bracketChances, {
							Min = b.min,
							Max = b.max,
							Color = b.color,
							Weight = w,
						})
					end
					for _, b in ipairs(bracketChances) do
						b.Chance = (totalWeight > 0) and (b.Weight / totalWeight * 100) or 0
					end
					table.sort(bracketChances, function(a, b)
						return a.Weight > b.Weight
					end)
					local topBracket = bracketChances[1]
					local bestBracket = FuseSizeBrackets[#FuseSizeBrackets]
					local estRateMin = math.round(
						(petInfo.EarningRate or 15)
							* (
								topBracket.Min <= 5 and (topBracket.Min ^ 1.85)
								or ((topBracket.Min / 5) ^ 1.2 * 19.637875755794113)
							)
					)
					local estRateMax = math.round(
						(petInfo.EarningRate or 15)
							* (
								topBracket.Max <= 5 and (topBracket.Max ^ 1.85)
								or ((topBracket.Max / 5) ^ 1.2 * 19.637875755794113)
							)
					)
					local bestCaseRate =
						math.round((petInfo.EarningRate or 15) * ((bestBracket.Max / 5) ^ 1.2 * 19.637875755794113))
					FuseSummaryLbl:SetText(
						string.format(
							"<b>Species:</b> %s · <b>Avg:</b> %.2fx\n"
								.. '<font color="#57F287"><b>Est:</b> %s ~ %s/s</font> · <font color="#FFD34D"><b>Best:</b> %s/s</font>',
							petInfo.Name,
							avgScale,
							FormatCash(estRateMin),
							FormatCash(estRateMax),
							FormatCash(bestCaseRate)
						)
					)
					if FuseFeed and FuseFeed.Clear and FuseFeed.AddItem then
						local fuseSigParts = {}
						for _, fp in ipairs(loadedPets) do
							fuseSigParts[#fuseSigParts + 1] = tostring(fp.Slot)
								.. ":"
								.. tostring(fp.Category)
								.. ":"
								.. tostring(fp.Scale)
						end
						local fuseSig = table.concat(fuseSigParts, "|")
						if fuseSig ~= LastFuseFeedSig then
							LastFuseFeedSig = fuseSig
							local lastFY = (FuseFeed.Scroll and FuseFeed.Scroll.CanvasPosition)
									and FuseFeed.Scroll.CanvasPosition.Y
								or 0
							FuseFeed:Clear()
							for _, b in ipairs(bracketChances) do
								if b.Chance >= 0.05 then
									local chanceColor = (b.Chance >= 20 and "#57F287")
										or (b.Chance >= 5 and "#FFAA00")
										or "#8A8AA2"
									FuseFeed:AddItem({
										Icon = petInfo.Icon,
										Title = string.format("<b>%.2fx - %.2fx</b>", b.Min, b.Max),
										Detail = string.format("Expected outcome scale bracket"),
										RightTag = string.format(
											'<font color="%s"><b>%.1f%%</b></font>',
											chanceColor,
											b.Chance
										),
										OnClick = nil,
									})
								end
							end
							if FuseFeed.Scroll then
								FuseFeed.Scroll.CanvasPosition = Vector2.new(0, lastFY)
							end
						end
					end
				end)
			end)
		end
	end)
	do
		local WebhookTab = MainWindow:AddTab("Webhook", "webhook", "Discord Webhook Reports & Customize")
		AddDiscordBox(WebhookTab)
		local WGroup = WebhookTab:AddLeftGroupbox("Webhook", "webhook")
		WGroup:AddInput("Webhook_Url", {
			Text = "Webhook URL",
			Default = FarmConfig.Webhook_Url,
			Placeholder = "https://discord.com/api/webhooks/...",
			ClearTextOnFocus = false,
			MaxLength = 1000,
			AllowEmpty = true,
			Tooltip = "Discord webhook URL",
			Callback = function(Value)
				local Clean = tostring(Value or ""):match("^%s*(.-)%s*$") or ""
				FarmConfig.Webhook_Url = Clean
				InstanUtility.Webhook.Url = Clean
				InstanUtility.Webhook:Sync()
			end,
		})
		WGroup:AddToggle("Webhook_Enabled", {
			Text = "Enable Webhook",
			Default = FarmConfig.Webhook_Enabled,
			Tooltip = "Enable webhook",
			Callback = function(State)
				FarmConfig.Webhook_Enabled = State
				if State then
					InstanUtility.Webhook.SessionStartCash = nil
				end
				InstanUtility.Webhook:Sync()
			end,
		})
		WGroup:AddToggle("Webhook_Ping", {
			Text = "Ping Everyone",
			Default = FarmConfig.Webhook_Ping,
			Tooltip = "Ping @everyone",
			Callback = function(State)
				FarmConfig.Webhook_Ping = State
				InstanUtility.Webhook:Sync()
			end,
		})
		WGroup:AddToggle("Webhook_Interval_Summary", {
			Text = "Auto Send Summary",
			Default = FarmConfig.Webhook_Interval_Summary,
			Tooltip = "Auto send summary",
			Callback = function(State)
				FarmConfig.Webhook_Interval_Summary = State
				InstanUtility.Webhook:Sync()
			end,
		})
		WGroup:AddInput("Webhook_Interval", {
			Text = "Interval (Minutes)",
			Default = tostring(FarmConfig.Webhook_Interval),
			Placeholder = "10",
			Numeric = true,
			Finished = true,
			ClearTextOnFocus = false,
			Tooltip = "Summary interval",
			Callback = function(Value)
				FarmConfig.Webhook_Interval = math.clamp(tonumber(Value) or 10, 1, 1440)
				InstanUtility.Webhook:Sync()
			end,
		})
		WGroup:AddDivider({ Text = "MANUAL SEND", MarginTop = 4, MarginBottom = 4 })
		local function NotifySend(Ok, Msg, Title)
			LibraryLoader:Notify({
				Title = Ok and (Title or "Webhook Sent") or "Webhook Failed",
				TitleColor = Ok and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 60, 60),
				Description = tostring(Msg),
				Time = 3,
			})
		end
		WGroup:AddButton({
			Text = "Send Summary Now",
			Func = function()
				task.spawn(function()
					FarmConfig.Webhook_Enabled = true
					InstanUtility.Webhook.Url = FarmConfig.Webhook_Url
					InstanUtility.Webhook:Sync()
					local CallOk, Ok, Msg = pcall(function()
						return InstanUtility.Webhook:SendSummary(true)
					end)
					NotifySend(CallOk and Ok, CallOk and Msg or Ok)
				end)
			end,
		})
		WGroup:AddButton({
			Text = "Send Inventory Now",
			Func = function()
				task.spawn(function()
					FarmConfig.Webhook_Enabled = true
					InstanUtility.Webhook:Sync()
					local CallOk, Ok, Msg = pcall(function()
						return InstanUtility.Webhook:SendInventory(true)
					end)
					NotifySend(CallOk and Ok, CallOk and Msg or Ok)
				end)
			end,
		})
		WGroup:AddButton({
			Text = "Send Equip Now",
			Func = function()
				task.spawn(function()
					FarmConfig.Webhook_Enabled = true
					InstanUtility.Webhook:Sync()
					local CallOk, Ok, Msg = pcall(function()
						return InstanUtility.Webhook:SendEquip(true)
					end)
					NotifySend(CallOk and Ok, CallOk and Msg or Ok)
				end)
			end,
		})
		WGroup:AddButton({
			Text = "Send Test Now",
			Func = function()
				task.spawn(function()
					FarmConfig.Webhook_Enabled = true
					InstanUtility.Webhook.Url = FarmConfig.Webhook_Url
					InstanUtility.Webhook:Sync()
					local CallOk, Ok, Msg = pcall(function()
						return InstanUtility.Webhook:SendTest(true)
					end)
					NotifySend(CallOk and Ok, CallOk and Msg or Ok)
				end)
			end,
		})
		WGroup:AddButton({
			Text = "Test Egg Image",
			Func = function()
				task.spawn(function()
					local W = InstanUtility.Webhook
					W.Url = tostring(FarmConfig.Webhook_Url or ""):match("^%s*(.-)%s*$") or ""
					local PreviousPing = W.Ping
					W.Ping = false
					local CallOk, Ok, Msg = pcall(function()
						return W:SendEggImageTest(true)
					end)
					W.Ping = PreviousPing
					NotifySend(CallOk and Ok, CallOk and Msg or Ok, "Egg Image Test Sent")
				end)
			end,
		})
		local CustomGroup = WebhookTab:AddGroupbox({
			Name = "Custom",
			IconName = "sliders-horizontal",
			Side = 2,
		})
		local CustomTabbox = CustomGroup:AddTabbox({ Name = "Webhook Embeds" })
		local Sub = CustomTabbox:AddTab("Status", "activity")
		Sub:AddToggle("Webhook_Sum_Cash", {
			Text = "Money",
			Default = true,
			Tooltip = "Money fields",
			Callback = function(State)
				FarmConfig.Webhook_Sum_Cash = State
			end,
		})
		Sub:AddToggle("Webhook_Sum_Speed", {
			Text = "Speed",
			Default = true,
			Tooltip = "Speed fields",
			Callback = function(State)
				FarmConfig.Webhook_Sum_Speed = State
			end,
		})
		Sub:AddToggle("Webhook_Field_Session", {
			Text = "Session",
			Default = true,
			Tooltip = "Session fields",
			Callback = function(State)
				FarmConfig.Webhook_Field_Session = State
			end,
		})
		Sub:AddToggle("Webhook_Field_Player", {
			Text = "Player",
			Default = true,
			Tooltip = "Player fields",
			Callback = function(State)
				FarmConfig.Webhook_Field_Player = State
			end,
		})
		Sub:AddToggle("Webhook_Field_Server", {
			Text = "Server",
			Default = true,
			Tooltip = "Server fields",
			Callback = function(State)
				FarmConfig.Webhook_Field_Server = State
			end,
		})
		Sub:AddToggle("Webhook_Field_EventTarget", {
			Text = "Event / Target",
			Default = true,
			Tooltip = "Event fields",
			Callback = function(State)
				FarmConfig.Webhook_Field_EventTarget = State
			end,
		})
		Sub:AddToggle("Webhook_Field_EventValue", {
			Text = "Snapshot Value",
			Default = true,
			Tooltip = "Value fields",
			Callback = function(State)
				FarmConfig.Webhook_Field_EventValue = State
			end,
		})
		Sub:AddToggle("Webhook_Sum_Eggs", {
			Text = "Egg Status",
			Default = true,
			Tooltip = "Egg count fields",
			Callback = function(State)
				FarmConfig.Webhook_Sum_Eggs = State
			end,
		})
		Sub:AddToggle("Webhook_Sum_Pets", {
			Text = "Top Pets",
			Default = true,
			Tooltip = "Top pet fields",
			Callback = function(State)
				FarmConfig.Webhook_Sum_Pets = State
			end,
		})
		Sub:AddToggle("Webhook_Sum_Upgrades", {
			Text = "Treadmill & Upgrades",
			Default = true,
			Tooltip = "Upgrade fields",
			Callback = function(State)
				FarmConfig.Webhook_Sum_Upgrades = State
			end,
		})
		Sub:AddToggle("Webhook_Sum_Index", {
			Text = "Index",
			Default = true,
			Tooltip = "Index fields",
			Callback = function(State)
				FarmConfig.Webhook_Sum_Index = State
			end,
		})
		Sub:AddToggle("Webhook_Sum_Recent", {
			Text = "Recent",
			Default = true,
			Tooltip = "Recent fields",
			Callback = function(State)
				FarmConfig.Webhook_Sum_Recent = State
			end,
		})
		Sub = CustomTabbox:AddTab("Egg", "egg")
		Sub:AddToggle("Webhook_AutoSendEgg", {
			Text = "Auto Egg Embed",
			Default = true,
			Tooltip = "Embed per egg",
			Callback = function(State)
				FarmConfig.Webhook_AutoSendEgg = State
				if State then
					InstanUtility.Webhook:Sync()
				end
			end,
		})
		Sub:AddDropdown("Webhook_EggSelected", {
			Text = "Egg Filter",
			Values = EggNamesList,
			Default = {},
			Multi = true,
			AllowNull = true,
			Searchable = true,
			Tooltip = "Empty = all eggs",
			Callback = function(Selected)
				FarmConfig.Webhook_EggSelected = ParseMultiDropdownSelection(Selected)
			end,
		})
		Sub:AddDropdown("Webhook_RaritySelected", {
			Text = "Rarity Filter",
			Values = RaritiesList,
			Default = {},
			Multi = true,
			AllowNull = true,
			Searchable = true,
			Tooltip = "Empty = all",
			Callback = function(Selected)
				FarmConfig.Webhook_RaritySelected = ParseMultiDropdownSelection(Selected)
			end,
		})
		Sub:AddDropdown("Webhook_MutationSelected", {
			Text = "Mutation Filter",
			Values = MutationsList,
			Default = {},
			Multi = true,
			AllowNull = true,
			Searchable = true,
			Tooltip = "Empty = all",
			Callback = function(Selected)
				FarmConfig.Webhook_MutationSelected = ParseMultiDropdownSelection(Selected)
			end,
		})
		Sub:AddToggle("Webhook_Egg_Value", {
			Text = "Value",
			Default = true,
			Tooltip = "Egg value total",
			Callback = function(State)
				FarmConfig.Webhook_Egg_Value = State
			end,
		})
		Sub:AddToggle("Webhook_Egg_Rarity", {
			Text = "Rarity",
			Default = true,
			Tooltip = "Show rarity",
			Callback = function(State)
				FarmConfig.Webhook_Egg_Rarity = State
			end,
		})
		Sub:AddToggle("Webhook_Egg_Mutation", {
			Text = "Mutation",
			Default = true,
			Tooltip = "Show mutation",
			Callback = function(State)
				FarmConfig.Webhook_Egg_Mutation = State
			end,
		})
		Sub:AddToggle("Webhook_Egg_Zone", {
			Text = "Zone",
			Default = true,
			Tooltip = "Show zone",
			Callback = function(State)
				FarmConfig.Webhook_Egg_Zone = State
			end,
		})
		Sub:AddToggle("Webhook_Egg_Chance", {
			Text = "Chance",
			Default = true,
			Tooltip = "Show chance",
			Callback = function(State)
				FarmConfig.Webhook_Egg_Chance = State
			end,
		})
		Sub:AddToggle("Webhook_Egg_Image", {
			Text = "Image",
			Default = true,
			Tooltip = "Egg image",
			Callback = function(State)
				FarmConfig.Webhook_Egg_Image = State
			end,
		})
		Sub = CustomTabbox:AddTab("Hatch Egg", "package-open")
		Sub:AddToggle("Webhook_AutoSendHatch", {
			Text = "Auto Hatch Embed",
			Default = true,
			Tooltip = "Embed per hatch",
			Callback = function(State)
				FarmConfig.Webhook_AutoSendHatch = State
			end,
		})
		Sub:AddToggle("Webhook_Hatch_Pet", {
			Text = "Pet Name",
			Default = true,
			Tooltip = "Show pet name",
			Callback = function(State)
				FarmConfig.Webhook_Hatch_Pet = State
			end,
		})
		Sub:AddToggle("Webhook_Hatch_Rarity", {
			Text = "Rarity",
			Default = true,
			Tooltip = "Show rarity",
			Callback = function(State)
				FarmConfig.Webhook_Hatch_Rarity = State
			end,
		})
		Sub:AddToggle("Webhook_Hatch_Value", {
			Text = "Value",
			Default = true,
			Tooltip = "Show value",
			Callback = function(State)
				FarmConfig.Webhook_Hatch_Value = State
			end,
		})
		Sub:AddToggle("Webhook_Hatch_Mutation", {
			Text = "Mutation",
			Default = false,
			Tooltip = "Show mutation",
			Callback = function(State)
				FarmConfig.Webhook_Hatch_Mutation = State
			end,
		})
		Sub:AddToggle("Webhook_Hatch_Milestone", {
			Text = "Milestone",
			Default = true,
			Tooltip = "Hatch milestones",
			Callback = function(State)
				FarmConfig.Webhook_Hatch_Milestone = State
			end,
		})
		Sub:AddToggle("Webhook_Hatch_Image", {
			Text = "Image",
			Default = true,
			Tooltip = "Pet image",
			Callback = function(State)
				FarmConfig.Webhook_Hatch_Image = State
			end,
		})
		Sub:AddDropdown("Webhook_Hatch_Format", {
			Text = "Detail",
			Values = { "Simple", "Detail", "Full" },
			Default = "Detail",
			Multi = false,
			AllowNull = false,
			Tooltip = "Report detail",
			Callback = function(Selected)
				FarmConfig.Webhook_Hatch_Format = tostring(Selected or "Detail")
			end,
		})
		Sub = CustomTabbox:AddTab("Pets", "paw-print")
		Sub:AddToggle("Webhook_AutoSendPet", {
			Text = "Auto Pet Report",
			Default = true,
			Tooltip = "Embed per report",
			Callback = function(State)
				FarmConfig.Webhook_AutoSendPet = State
			end,
		})
		Sub:AddToggle("Webhook_Pet_Inventory", {
			Text = "Inventory",
			Default = true,
			Tooltip = "Pet inventory",
			Callback = function(State)
				FarmConfig.Webhook_Pet_Inventory = State
			end,
		})
		Sub:AddToggle("Webhook_Pet_Equipped", {
			Text = "Equipped",
			Default = true,
			Tooltip = "Equipped pets",
			Callback = function(State)
				FarmConfig.Webhook_Pet_Equipped = State
			end,
		})
		Sub:AddToggle("Webhook_Pet_Power", {
			Text = "Power",
			Default = true,
			Tooltip = "Pet power",
			Callback = function(State)
				FarmConfig.Webhook_Pet_Power = State
			end,
		})
		Sub:AddToggle("Webhook_Pet_Best", {
			Text = "Best Pet",
			Default = true,
			Tooltip = "Best pet",
			Callback = function(State)
				FarmConfig.Webhook_Pet_Best = State
			end,
		})
		Sub:AddToggle("Webhook_Pet_Index", {
			Text = "Index",
			Default = false,
			Tooltip = "Pet index",
			Callback = function(State)
				FarmConfig.Webhook_Pet_Index = State
			end,
		})
		Sub:AddButton({
			Text = "Send Inventory Now",
			Func = function()
				task.spawn(function()
					FarmConfig.Webhook_Enabled = true
					InstanUtility.Webhook:Sync()
					local CallOk, Ok, Msg = pcall(function()
						return InstanUtility.Webhook:SendInventory(true)
					end)
					NotifySend(CallOk and Ok, CallOk and Msg or Ok)
				end)
			end,
		})
		Sub:AddButton({
			Text = "Send Equip Now",
			Func = function()
				task.spawn(function()
					FarmConfig.Webhook_Enabled = true
					InstanUtility.Webhook:Sync()
					local CallOk, Ok, Msg = pcall(function()
						return InstanUtility.Webhook:SendEquip(true)
					end)
					NotifySend(CallOk and Ok, CallOk and Msg or Ok)
				end)
			end,
		})
		Sub = CustomTabbox:AddTab("Disconnected", "wifi-off")
		Sub:AddToggle("Webhook_Alert_Death", {
			Text = "Death Log",
			Default = true,
			Tooltip = "Death log",
			Callback = function(State)
				FarmConfig.Webhook_Alert_Death = State
			end,
		})
		Sub:AddToggle("Webhook_Alert_Kick", {
			Text = "Kick / Disconnect",
			Default = true,
			Tooltip = "Kick log",
			Callback = function(State)
				FarmConfig.Webhook_Alert_Kick = State
			end,
		})
		Sub:AddToggle("Webhook_Alert_Error", {
			Text = "Error Log",
			Default = false,
			Tooltip = "Error log",
			Callback = function(State)
				FarmConfig.Webhook_Alert_Error = State
			end,
		})
		Sub:AddToggle("Webhook_Alert_AntiAfk", {
			Text = "Anti AFK Report",
			Default = false,
			Tooltip = "Anti-AFK log",
			Callback = function(State)
				FarmConfig.Webhook_Alert_AntiAfk = State
			end,
		})
		Sub:AddDropdown("Webhook_Alert_Level", {
			Text = "Alert Level",
			Values = { "All", "Important", "Errors Only" },
			Default = "Important",
			Multi = false,
			AllowNull = false,
			Tooltip = "Alert level",
			Callback = function(Selected)
				FarmConfig.Webhook_Alert_Level = tostring(Selected or "Important")
			end,
		})
	end
	do
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local Lighting = game:GetService("Lighting")
		local Stats = game:GetService("Stats")
		local UserInputService = game:GetService("UserInputService")
		local TeleportService = game:GetService("TeleportService")
		local LocalPlayer = Players.LocalPlayer
		local MiscTab = MainWindow:AddTab("Misc", "gauge", "Performance & Utility")
		local PerfGroup = MiscTab:AddLeftGroupbox("Performance", "gauge")
		local UtilGroup = MiscTab:AddRightGroupbox("Utility", "wrench")
		AddDiscordBox(MiscTab)
		local function ApplyFpsCap(n)
			n = math.clamp(math.floor(tonumber(n) or 240), 30, 1000)
			if type(setfpscap) == "function" then
				pcall(setfpscap, n)
			end
		end
		PerfGroup:AddSlider("Slider_Perf_FpsCap", {
			Text = "FPS Cap",
			Min = 30,
			Max = 1000,
			Default = tonumber(FarmConfig.Perf_FpsCap) or 240,
			Rounding = 0,
			Suffix = " FPS",
			Tooltip = "FPS cap",
			Callback = function(Value)
				FarmConfig.Perf_FpsCap = math.clamp(math.floor(tonumber(Value) or 240), 30, 1000)
				ApplyFpsCap(FarmConfig.Perf_FpsCap)
			end,
		})
		local Opt = {
			Active = false,
			Gen = 0,
			SavedSettings = {},
			SavedProps = setmetatable({}, { __mode = "k" }),
			Queue = {},
			Conns = {},
			Thread = nil,
		}
		local function SaveAndSet(tbl, prop, newValue)
			local ok, old = pcall(function()
				return tbl[prop]
			end)
			if not ok then
				return
			end
			Opt.SavedSettings[#Opt.SavedSettings + 1] = {
				Set = function(v)
					pcall(function()
						tbl[prop] = v
					end)
				end,
				Value = old,
			}
			pcall(function()
				tbl[prop] = newValue
			end)
		end
		local function StripProp(inst, prop, newValue)
			local bag = Opt.SavedProps[inst]
			if not bag then
				bag = {}
				Opt.SavedProps[inst] = bag
			end
			if bag[prop] == nil then
				local ok, old = pcall(function()
					return inst[prop]
				end)
				if not ok then
					return
				end
				bag[prop] = old
			end
			pcall(function()
				inst[prop] = newValue
			end)
		end
		local function StripInstance(inst)
			if not Opt.Active or not inst.Parent then
				return
			end
			if inst:IsA("ParticleEmitter") then
				StripProp(inst, "Enabled", false)
				StripProp(inst, "Rate", 0)
			elseif inst:IsA("Trail") or inst:IsA("Beam") then
				StripProp(inst, "Enabled", false)
			elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
				StripProp(inst, "Enabled", false)
				StripProp(inst, "Brightness", 0)
			elseif inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles") then
				StripProp(inst, "Enabled", false)
			elseif inst:IsA("Explosion") then
				StripProp(inst, "Visible", false)
			elseif inst:IsA("SpecialMesh") then
				StripProp(inst, "TextureId", "")
			elseif inst:IsA("Decal") or inst:IsA("Texture") then
				if not (inst.Name == "face" and inst.Parent and inst.Parent.Name == "Head") then
					StripProp(inst, "Transparency", 1)
				end
			elseif inst:IsA("MeshPart") then
				StripProp(inst, "RenderFidelity", Enum.RenderFidelity.Performance)
				StripProp(inst, "TextureID", "")
				StripProp(inst, "CastShadow", false)
				StripProp(inst, "Reflectance", 0)
				StripProp(inst, "Material", Enum.Material.SmoothPlastic)
			elseif inst:IsA("BasePart") then
				StripProp(inst, "CastShadow", false)
				StripProp(inst, "Reflectance", 0)
				StripProp(inst, "Material", Enum.Material.SmoothPlastic)
			elseif inst:IsA("PostEffect") then
				StripProp(inst, "Enabled", false)
			elseif inst:IsA("Clouds") then
				StripProp(inst, "Cover", 0)
				StripProp(inst, "Density", 0)
			elseif inst:IsA("Atmosphere") then
				StripProp(inst, "Density", 0)
				StripProp(inst, "Haze", 0)
				StripProp(inst, "Glare", 0)
			end
		end
		local function StripTree(root, gen)
			local now = os.clock()
			for _, d in ipairs(root:GetDescendants()) do
				if not Opt.Active or Opt.Gen ~= gen then
					return false
				end
				StripInstance(d)
				if os.clock() - now > 0.003 then
					RunService.Heartbeat:Wait()
					now = os.clock()
				end
			end
			return true
		end
		local function ApplyOptSettings()
			local Rendering = settings().Rendering
			local Terrain = workspace.Terrain
			SaveAndSet(Rendering, "QualityLevel", Enum.QualityLevel.Level01)
			SaveAndSet(Rendering, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level01)
			SaveAndSet(Rendering, "EditQualityLevel", Enum.QualityLevel.Level01)
			pcall(function()
				local Ugs = UserSettings():GetService("UserGameSettings")
				SaveAndSet(Ugs, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
			end)
			SaveAndSet(Lighting, "GlobalShadows", false)
			SaveAndSet(Lighting, "ShadowSoftness", 0)
			SaveAndSet(Lighting, "FogEnd", 9e9)
			SaveAndSet(Lighting, "EnvironmentDiffuseScale", 0)
			SaveAndSet(Lighting, "EnvironmentSpecularScale", 0)
			SaveAndSet(Terrain, "Decoration", false)
			SaveAndSet(Terrain, "WaterWaveSize", 0)
			SaveAndSet(Terrain, "WaterWaveSpeed", 0)
			SaveAndSet(Terrain, "WaterReflectance", 0)
			SaveAndSet(Terrain, "WaterTransparency", 1)
		end
		local function RestoreOpt()
			for _, s in ipairs(Opt.SavedSettings) do
				pcall(s.Set, s.Value)
			end
			table.clear(Opt.SavedSettings)
			local now = os.clock()
			for inst, bag in pairs(Opt.SavedProps) do
				if inst.Parent then
					for prop, old in pairs(bag) do
						pcall(function()
							inst[prop] = old
						end)
					end
				end
				Opt.SavedProps[inst] = nil
				if os.clock() - now > 0.003 then
					RunService.Heartbeat:Wait()
					now = os.clock()
				end
			end
		end
		local function OptEnable()
			if Opt.Active then
				return
			end
			Opt.Active = true
			Opt.Gen = Opt.Gen + 1
			local gen = Opt.Gen
			ApplyOptSettings()
			table.insert(
				Opt.Conns,
				workspace.DescendantAdded:Connect(function(d)
					if Opt.Active and Opt.Gen == gen then
						Opt.Queue[#Opt.Queue + 1] = d
					end
				end)
			)
			table.insert(
				Opt.Conns,
				Lighting.DescendantAdded:Connect(function(d)
					if Opt.Active and Opt.Gen == gen then
						Opt.Queue[#Opt.Queue + 1] = d
					end
				end)
			)
			table.insert(
				Opt.Conns,
				RunService.Heartbeat:Connect(function()
					if not (Opt.Active and Opt.Gen == gen) then
						return
					end
					local now = os.clock()
					while #Opt.Queue > 0 do
						StripInstance(table.remove(Opt.Queue))
						if os.clock() - now > 0.003 then
							break
						end
					end
				end)
			)
			Opt.Thread = task.spawn(function()
				if StripTree(workspace, gen) then
					StripTree(Lighting, gen)
				end
			end)
		end
		local function OptDisable()
			if not Opt.Active then
				return
			end
			Opt.Active = false
			Opt.Gen = Opt.Gen + 1
			for _, c in ipairs(Opt.Conns) do
				pcall(function()
					c:Disconnect()
				end)
			end
			table.clear(Opt.Conns)
			table.clear(Opt.Queue)
			if Opt.Thread then
				pcall(task.cancel, Opt.Thread)
				Opt.Thread = nil
			end
			RestoreOpt()
		end
		PerfGroup:AddToggle("Toggle_Perf_Optimizer", {
			Text = "Optimizer",
			Default = FarmConfig.Perf_Optimizer == true,
			Tooltip = "FPS boost mode",
			Callback = function(State)
				FarmConfig.Perf_Optimizer = State == true
				if State then
					task.spawn(OptEnable)
				else
					task.spawn(OptDisable)
				end
			end,
		})
		local GREEN = Color3.fromRGB(58, 255, 55)
		local YELLOW = Color3.fromRGB(255, 214, 84)
		local RED = Color3.fromRGB(255, 96, 96)
		local GRAY = Color3.fromRGB(150, 150, 158)
		local Hud = {
			Gui = nil,
			FpsLbl = nil,
			PingLbl = nil,
			ScaleObj = nil,
			Conns = {},
			FpsSm = 0,
			NextUpd = 0,
			LastFpsText = nil,
			LastPingText = nil,
			SizePct = math.clamp((tonumber(FarmConfig.Perf_FpsPingSize) or 100) / 100, 0.6, 1.6),
		}
		local function FpsColor(fps)
			if fps >= 100 then
				return GREEN
			elseif fps >= 50 then
				return YELLOW
			end
			return RED
		end
		local function PingColor(ms)
			if ms <= 90 then
				return GREEN
			elseif ms <= 180 then
				return YELLOW
			end
			return RED
		end
		local function MakeHudLabel(parent, x, w, color)
			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Position = UDim2.fromOffset(x, 9)
			lbl.Size = UDim2.fromOffset(w, 16)
			lbl.Text = ""
			lbl.TextColor3 = color
			lbl.TextScaled = true
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Font = Enum.Font.GothamBold
			lbl.Parent = parent
			return lbl
		end
		local function UpdateHudScale()
			if not Hud.ScaleObj then
				return
			end
			local Cam = workspace.CurrentCamera
			local Vs = Cam and Cam.ViewportSize or Vector2.new(1280, 720)
			if Vs.X < 1 then
				Vs = Vector2.new(1280, 720)
			end
			Hud.ScaleObj.Scale = math.clamp(Vs.X * 0.085 / 132, 0.7, 1.4) * Hud.SizePct
		end
		local function DestroyHud()
			for _, c in ipairs(Hud.Conns) do
				pcall(function()
					c:Disconnect()
				end)
			end
			table.clear(Hud.Conns)
			if Hud.Gui then
				pcall(function()
					Hud.Gui:Destroy()
				end)
			end
			Hud.Gui = nil
			Hud.FpsLbl = nil
			Hud.PingLbl = nil
			Hud.ScaleObj = nil
			Hud.FpsSm = 0
			Hud.LastFpsText = nil
			Hud.LastPingText = nil
		end
		local function BuildHud()
			DestroyHud()
			local Gui = Instance.new("ScreenGui")
			Gui.Name = "N3_FpsPing"
			Gui.Archivable = false
			Gui.DisplayOrder = 58
			Gui.IgnoreGuiInset = true
			Gui.ResetOnSpawn = false
			Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			local Frame = Instance.new("Frame")
			Frame.Active = true
			Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
			Frame.BackgroundTransparency = 0.28
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.fromOffset(16, 16)
			Frame.Size = UDim2.fromOffset(132, 34)
			Frame.Parent = Gui
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 12)
			Corner.Parent = Frame
			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.new(1, 1, 1)
			Stroke.Thickness = 1
			Stroke.Transparency = 0.9
			Stroke.Parent = Frame
			local Scale = Instance.new("UIScale")
			Scale.Parent = Frame
			Hud.ScaleObj = Scale
			Hud.FpsLbl = MakeHudLabel(Frame, 12, 34, GREEN)
			MakeHudLabel(Frame, 48, 22, GRAY).Text = "FPS"
			local Divider = Instance.new("Frame")
			Divider.AnchorPoint = Vector2.new(0.5, 0.5)
			Divider.BackgroundColor3 = Color3.new(1, 1, 1)
			Divider.BackgroundTransparency = 0.85
			Divider.BorderSizePixel = 0
			Divider.Position = UDim2.new(0, 74, 0.5, 0)
			Divider.Size = UDim2.fromOffset(1, 14)
			Divider.Parent = Frame
			Hud.PingLbl = MakeHudLabel(Frame, 82, 30, GREEN)
			MakeHudLabel(Frame, 113, 14, GRAY).Text = "ms"
			Gui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
			Hud.Gui = Gui
			UpdateHudScale()
			local Dragging, DragInput, DragStart, StartPos = false, nil, nil, nil
			table.insert(
				Hud.Conns,
				Frame.InputBegan:Connect(function(Input)
					if Input.UserInputState ~= Enum.UserInputState.Begin then
						return
					end
					local IsTouch = Input.UserInputType == Enum.UserInputType.Touch
					if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and not IsTouch then
						return
					end
					Dragging = true
					DragInput = IsTouch and Input or nil
					DragStart = Vector2.new(Input.Position.X, Input.Position.Y)
					StartPos = Frame.Position
				end)
			)
			table.insert(
				Hud.Conns,
				UserInputService.InputChanged:Connect(function(Input)
					if not Dragging or not StartPos then
						return
					end
					if
						not (
							(DragInput and Input == DragInput)
							or (not DragInput and Input.UserInputType == Enum.UserInputType.MouseMovement)
						)
					then
						return
					end
					local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - DragStart
					Frame.Position = UDim2.new(
						StartPos.X.Scale,
						StartPos.X.Offset + Delta.X,
						StartPos.Y.Scale,
						StartPos.Y.Offset + Delta.Y
					)
				end)
			)
			table.insert(
				Hud.Conns,
				UserInputService.InputEnded:Connect(function(Input)
					if not Dragging then
						return
					end
					if
						(DragInput and Input == DragInput)
						or (not DragInput and Input.UserInputType == Enum.UserInputType.MouseButton1)
					then
						Dragging = false
						DragInput = nil
						StartPos = nil
					end
				end)
			)
			local Cam = workspace.CurrentCamera
			if Cam then
				table.insert(Hud.Conns, Cam:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateHudScale))
			end
			table.insert(
				Hud.Conns,
				RunService.RenderStepped:Connect(function(Dt)
					local D = math.clamp(Dt, 0.001, 1)
					local Fps = 1 / D
					if Hud.FpsSm <= 0 then
						Hud.FpsSm = Fps
					else
						Hud.FpsSm = Hud.FpsSm + (Fps - Hud.FpsSm) * (1 - math.exp(-D * 8))
					end
					local Now = os.clock()
					if Now < Hud.NextUpd then
						return
					end
					Hud.NextUpd = Now + 0.2
					local FpsInt = math.floor(Hud.FpsSm + 0.5)
					local FpsText = tostring(FpsInt)
					if FpsText ~= Hud.LastFpsText then
						Hud.LastFpsText = FpsText
						Hud.FpsLbl.Text = FpsText
						Hud.FpsLbl.TextColor3 = FpsColor(FpsInt)
					end
					local Ping = 0
					pcall(function()
						Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
					end)
					local PingInt = math.floor(Ping + 0.5)
					local PingText = tostring(PingInt)
					if PingText ~= Hud.LastPingText then
						Hud.LastPingText = PingText
						Hud.PingLbl.Text = PingText
						Hud.PingLbl.TextColor3 = PingColor(PingInt)
					end
				end)
			)
		end
		PerfGroup:AddToggle("Toggle_Perf_FpsPing", {
			Text = "FPS and Ping",
			Default = FarmConfig.Perf_FpsPing ~= false,
			Tooltip = "FPS/Ping overlay",
			Callback = function(State)
				FarmConfig.Perf_FpsPing = State == true
				if State then
					BuildHud()
				else
					DestroyHud()
				end
			end,
		})
		PerfGroup:AddSlider("Slider_Perf_FpsPingSize", {
			Text = "FPS and Ping Size",
			Min = 60,
			Max = 160,
			Default = tonumber(FarmConfig.Perf_FpsPingSize) or 100,
			Rounding = 0,
			Suffix = "%",
			Tooltip = "Overlay size",
			Callback = function(Value)
				FarmConfig.Perf_FpsPingSize = Value
				Hud.SizePct = math.clamp((tonumber(Value) or 100) / 100, 0.6, 1.6)
				UpdateHudScale()
			end,
		})
		local R3D = { Gui = nil }
		local function Set3DEnabled(Enabled3D)
			pcall(function()
				RunService:Set3dRenderingEnabled(Enabled3D)
			end)
			if Enabled3D then
				if R3D.Gui then
					pcall(function()
						R3D.Gui:Destroy()
					end)
					R3D.Gui = nil
				end
			elseif not R3D.Gui then
				local Gui = Instance.new("ScreenGui")
				Gui.Name = "N3_No3DBackdrop"
				Gui.DisplayOrder = -1000
				Gui.IgnoreGuiInset = true
				Gui.ResetOnSpawn = false
				local Frame = Instance.new("Frame")
				Frame.BackgroundColor3 = Color3.new(0, 0, 0)
				Frame.BorderSizePixel = 0
				Frame.Size = UDim2.fromScale(1, 1)
				Frame.Parent = Gui
				Gui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
				R3D.Gui = Gui
			end
		end
		PerfGroup:AddToggle("Toggle_Perf_Disable3D", {
			Text = "Disable 3D Render",
			Default = FarmConfig.Perf_Disable3D == true,
			Tooltip = "Black screen FPS",
			Callback = function(State)
				FarmConfig.Perf_Disable3D = State == true
				Set3DEnabled(not State)
			end,
		})
		local Fog = { Saved = nil }
		local function SetNoFog(On)
			if On then
				if Fog.Saved then
					return
				end
				Fog.Saved = { FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart }
				Lighting.FogEnd = 9e9
				Lighting.FogStart = 0
			else
				if not Fog.Saved then
					return
				end
				pcall(function()
					Lighting.FogEnd = Fog.Saved.FogEnd
					Lighting.FogStart = Fog.Saved.FogStart
				end)
				Fog.Saved = nil
			end
		end
		PerfGroup:AddToggle("Toggle_Perf_NoFog", {
			Text = "No Fog",
			Default = FarmConfig.Perf_NoFog == true,
			Tooltip = "No fog",
			Callback = function(State)
				FarmConfig.Perf_NoFog = State == true
				SetNoFog(State == true)
			end,
		})
		local Bright = { Saved = nil }
		local function SetFullBright(On)
			if On then
				if Bright.Saved then
					return
				end
				Bright.Saved = {
					Brightness = Lighting.Brightness,
					Ambient = Lighting.Ambient,
					OutdoorAmbient = Lighting.OutdoorAmbient,
				}
				Lighting.Brightness = 2
				Lighting.Ambient = Color3.new(1, 1, 1)
				Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
			else
				if not Bright.Saved then
					return
				end
				pcall(function()
					Lighting.Brightness = Bright.Saved.Brightness
					Lighting.Ambient = Bright.Saved.Ambient
					Lighting.OutdoorAmbient = Bright.Saved.OutdoorAmbient
				end)
				Bright.Saved = nil
			end
		end
		PerfGroup:AddToggle("Toggle_Perf_FullBright", {
			Text = "Full Bright",
			Default = FarmConfig.Perf_FullBright == true,
			Tooltip = "Full bright",
			Callback = function(State)
				FarmConfig.Perf_FullBright = State == true
				SetFullBright(State == true)
			end,
		})
		local Afk = {
			Enabled = true,
			Alive = true,
			Silenced = {},
			Hijacked = {},
			MarkFns = {},
			MarkRetries = 0,
			MarkNextAt = 0,
			StubNextAt = 0,
		}
		local Stub = setmetatable({}, {
			__index = function()
				return function() end
			end,
		})
		local function GetIdledConns()
			if type(getconnections) ~= "function" then
				return {}
			end
			local Ok, Res = pcall(getconnections, LocalPlayer.Idled)
			return (Ok and type(Res) == "table") and Res or {}
		end
		local function SilenceIdled()
			for _, Conn in ipairs(GetIdledConns()) do
				if pcall(function()
					Conn:Disable()
				end) then
					Afk.Silenced[#Afk.Silenced + 1] = Conn
				end
			end
		end
		local function UnsilenceIdled()
			local List = #Afk.Silenced > 0 and Afk.Silenced or GetIdledConns()
			for _, Conn in ipairs(List) do
				pcall(function()
					Conn:Enable()
				end)
			end
			table.clear(Afk.Silenced)
		end
		local function FindAntiAfkStubs()
			local Out = {}
			if type(getgc) ~= "function" or type(debug) ~= "table" or type(debug.getupvalues) ~= "function" then
				return Out
			end
			local Ok, Gc = pcall(getgc, false)
			if not Ok or type(Gc) ~= "table" then
				return Out
			end
			for _, Item in ipairs(Gc) do
				if type(Item) == "function" and islclosure(Item) then
					local Ok2, Src = pcall(debug.info, Item, "s")
					if Ok2 and type(Src) == "string" and string.find(Src, "AntiAFK", 1, true) then
						local Ok3, Ups = pcall(debug.getupvalues, Item)
						if Ok3 and type(Ups) == "table" then
							for K, V in pairs(Ups) do
								if typeof(V) == "Instance" and V.ClassName == "TeleportService" then
									Out[#Out + 1] = { Fn = Item, Index = K, Original = V }
								end
							end
						end
					end
				end
			end
			return Out
		end
		local function FindMarkActive()
			local Out = {}
			if type(getgc) ~= "function" or type(debug) ~= "table" or type(debug.info) ~= "function" then
				return Out
			end
			local Ok, Gc = pcall(getgc, false)
			if not Ok or type(Gc) ~= "table" then
				return Out
			end
			for _, Item in ipairs(Gc) do
				if type(Item) == "function" and islclosure(Item) then
					local Ok2, Src = pcall(debug.info, Item, "s")
					if Ok2 and type(Src) == "string" and string.find(Src, "AntiAFK", 1, true) then
						local Ok3, Name = pcall(debug.info, Item, "n")
						if Ok3 and (Name == "markActive" or Name == "reportActiveFromInput") then
							Out[#Out + 1] = Item
						end
					end
				end
			end
			return Out
		end
		local function CallMarkActive()
			if #Afk.MarkFns == 0 and Afk.MarkRetries < 6 and os.clock() >= Afk.MarkNextAt then
				Afk.MarkRetries = Afk.MarkRetries + 1
				Afk.MarkNextAt = os.clock() + 60
				Afk.MarkFns = FindMarkActive()
			end
			for _, Fn in ipairs(Afk.MarkFns) do
				pcall(Fn)
			end
		end
		local function ApplyAfk()
			SilenceIdled()
			if #Afk.Hijacked == 0 and os.clock() >= Afk.StubNextAt then
				Afk.StubNextAt = os.clock() + 600
				for _, Entry in ipairs(FindAntiAfkStubs()) do
					if pcall(debug.setupvalue, Entry.Fn, Entry.Index, Stub) then
						Afk.Hijacked[#Afk.Hijacked + 1] = Entry
					end
				end
			end
		end
		local function UndoAfk()
			UnsilenceIdled()
			for _, Entry in ipairs(Afk.Hijacked) do
				pcall(debug.setupvalue, Entry.Fn, Entry.Index, Entry.Original)
			end
			table.clear(Afk.Hijacked)
		end
		UtilGroup:AddToggle("Toggle_Util_AntiAFK", {
			Text = "Anti AFK",
			Default = FarmConfig.Util_AntiAFK ~= false,
			Tooltip = "Anti idle kick",
			Callback = function(State)
				FarmConfig.Util_AntiAFK = State == true
				Afk.Enabled = State ~= false
				if Afk.Enabled then
					task.spawn(ApplyAfk)
				else
					task.spawn(UndoAfk)
				end
			end,
		})
		Afk.Conn = LocalPlayer.CharacterAdded:Connect(function()
			task.delay(1, function()
				if Afk.Alive and Afk.Enabled then
					table.clear(Afk.Silenced)
					pcall(ApplyAfk)
				end
			end)
		end)
		pcall(function()
			LibraryLoader:OnUnload(function()
				Afk.Alive = false
				pcall(function()
					Afk.Conn:Disconnect()
				end)
				pcall(UndoAfk)
			end)
		end)
		task.spawn(function()
			while Afk.Alive do
				if Afk.Enabled then
					ApplyAfk()
				end
				task.wait(600)
			end
		end)
		task.spawn(function()
			task.wait(35)
			while Afk.Alive do
				if Afk.Enabled then
					CallMarkActive()
				end
				task.wait(600)
			end
		end)
		local Rj = { Conn = nil, Busy = false }
		local function SetAutoRejoin(On)
			if On then
				if Rj.Conn then
					return
				end
				local Overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
				Overlay = Overlay and Overlay:FindFirstChild("promptOverlay")
				if Overlay then
					Rj.Conn = Overlay.ChildAdded:Connect(function()
						if Rj.Busy then
							return
						end
						Rj.Busy = true
						task.delay(2, function()
							pcall(function()
								TeleportService:Teleport(game.PlaceId, LocalPlayer)
							end)
							Rj.Busy = false
						end)
					end)
				end
			elseif Rj.Conn then
				pcall(function()
					Rj.Conn:Disconnect()
				end)
				Rj.Conn = nil
			end
		end
		UtilGroup:AddToggle("Toggle_Util_AutoRejoin", {
			Text = "Auto Rejoin",
			Default = FarmConfig.Util_AutoRejoin == true,
			Tooltip = "Auto rejoin",
			Callback = function(State)
				FarmConfig.Util_AutoRejoin = State == true
				SetAutoRejoin(State == true)
			end,
		})
		UtilGroup:AddButton({
			Text = "Rejoin Server Now",
			Func = function()
				pcall(function()
					TeleportService:Teleport(game.PlaceId, LocalPlayer)
				end)
			end,
		})
		task.defer(function()
			ApplyFpsCap(FarmConfig.Perf_FpsCap)
			pcall(function()
				InstanUtility.Webhook:Sync()
			end)
			if FarmConfig.Perf_Optimizer then
				task.spawn(OptEnable)
			end
			if FarmConfig.Perf_FpsPing ~= false then
				BuildHud()
			end
			if FarmConfig.Perf_Disable3D then
				Set3DEnabled(false)
			end
			if FarmConfig.Perf_NoFog then
				SetNoFog(true)
			end
			if FarmConfig.Perf_FullBright then
				SetFullBright(true)
			end
			if FarmConfig.Util_AntiAFK ~= false then
				Afk.Enabled = true
				task.spawn(ApplyAfk)
			end
			if FarmConfig.Util_AutoRejoin then
				SetAutoRejoin(true)
			end
		end)
	end
	ThemeManager:ApplyToTab(SettingsTab)
	SaveManager:BuildConfigSection(SettingsTab)
end
SetElevated8()
function Tasks.OnTreadmillPartAdded(desc)
	if FarmConfig.AntiTreadmill and not FarmConfig.AutoTreadmill then
		if
			desc:IsA("BasePart")
			and (desc.Name:find("Treadmill") or (desc.Parent and desc.Parent.Name:find("Treadmill")))
		then
			pcall(function()
				desc.CanTouch = false
				desc.CanQuery = false
			end)
		end
	end
end
Workspace.DescendantAdded:Connect(Tasks.OnTreadmillPartAdded)
function Tasks.MobilityLoop()
	while not LibraryLoader.Unloaded do
		task.wait(1.5)
		pcall(function()
			if RaceOwnsCharacter() then return end
            local Engine = RuntimeState.StealEngine
            if Engine and Engine.AutoCycle then return end
			if FarmConfig.AntiTreadmill and not FarmConfig.AutoTreadmill then
				if IsPlayerRunningOnTreadmill() then
					ExitTreadmill()
					local char = LocalPlayer.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hrp and not RaceOwnsCharacter() and not RuntimeState.IsExecuting then
						hrp.CFrame = hrp.CFrame * CFrame.new(0, 1, 6)
						hrp.AssemblyLinearVelocity = Vector3.zero
					end
				end
			end
			if FarmConfig.AutoEquipBestPet and Remotes.RemoteWearBest then
				if os.clock() - LastBestPetEquip >= 15 then
					LastBestPetEquip = os.clock()
					Remotes.RemoteWearBest:InvokeServer()
				end
			end
		end)
	end
end
task.spawn(Tasks.MobilityLoop)
function Tasks.AutomationLoop()
	while true do
		task.wait(3.0)
		pcall(function()
			if FarmConfig.AutoHatch then
				ExecuteAutoHatch()
			end
			if FarmConfig.AutoClaimIndexRewards then
				ClaimIndexRewards(false)
			end
			if FarmConfig.ClaimOfflineEarnings then
				Tasks.ClaimOfflineMoney()
			end
			if FarmConfig.AutoUpgradePlot then
				Tasks.ExecuteUpgradePlot()
			end
			if FarmConfig.AutoUpgradeTreadmill then
				local currentCash = GetCurrentCash()
				if currentCash > (FarmConfig.CashReserve or 0) then
					Tasks.ExecuteUpgradeTreadmill()
				end
			end
			if FarmConfig.AutoBuyBestTrail then
				Tasks.BuyBestTrail()
			end
			if FarmConfig.AutoEquipBestTrail then
				Tasks.EquipBestTrail()
			end
			if FarmConfig.AutoTreadmill and Tasks.TreadmillMayRun() then
				task.spawn(MountTreadmill)
			end
		end)
	end
end
task.spawn(Tasks.AutomationLoop)
function Tasks.ScrambleTradeLoop()
	while not LibraryLoader.Unloaded do
		task.wait(2)
		pcall(function()
			local live = FarmConfig.AutoScrambleSteal or FarmConfig.AutoScrambleSubmit or FarmConfig.Scramble_AutoReroll
			if live or os.clock() - (RuntimeState.ScrambleStateAt or 0) > 10 then
				RefreshScrambleState()
				RuntimeState.ScrambleStateAt = os.clock()
			end
			GetScrambleTradeStatusFn()
			if FarmConfig.AutoScrambleSubmit then ExecuteScrambleTradeIn() end
			-- Independent of Auto Trade-In; never spends a paid refresh.
			if FarmConfig.Scramble_AutoReroll then DrScramble.AutoRerollLab() end
		end)
	end
end
task.spawn(Tasks.ScrambleTradeLoop)
DrScramble.ArenaAttributeName = "InScrambleArena"
DrScramble.ArenaOrigin = Vector3.new(-15035, -474, 4853)
function DrScramble.IsInsideArena()
	if LocalPlayer:GetAttribute(DrScramble.ArenaAttributeName) == true then
		return true
	end
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root then
		if root.Position.Y > -100 then
			return false
		end
		local ok, inside = pcall(function()
			local pos = root.Position
			local origin = DrScramble.ArenaOrigin
			return math.abs(pos.X - origin.X) < 900
				and math.abs(pos.Y - origin.Y) < 400
				and math.abs(pos.Z - origin.Z) < 900
		end)
		if ok and inside then
			return true
		end
	end
	return false
end
function Tasks.NormalStealPostDelivery()
    local Engine = RuntimeState.StealEngine
    if not Engine or RuntimeState.IsExecuting or Engine.AutoCycle
        or not IsStealActive() or DrScramble.IsInsideArena() then return end
    local count = Engine.AutoDeliverySerial - Engine.AutoHandledDeliverySerial
    if count <= 0 or not Engine.ClaimMovement("place") then return end
    Engine.AutoHandledDeliverySerial = Engine.AutoDeliverySerial
    RuntimeState.IsExecuting = true
    local ok, failure = pcall(function()
        local deposit = false
        if FarmConfig.AutoPlaceAllEggs or FarmConfig.AutoPlaceSelect then
            if FarmConfig.PlaceMethod == "Now" then
                deposit = true
            elseif FarmConfig.PlaceMethod == "Every 5" then
                FarmConfig.BatchStealCount = FarmConfig.BatchStealCount + count
                if FarmConfig.BatchStealCount >= 5 or CountPlayerHeldEggs() >= 5 then
                    FarmConfig.BatchStealCount = 0
                    deposit = true
                end
            end
        end
        if deposit then
            Tasks.ExecuteDepositEggs(not FarmConfig.AutoPlaceAllEggs and FarmConfig.AutoPlaceSelect)
            if FarmConfig.AutoHatch then task.spawn(ExecuteAutoHatch) end
            if FarmConfig.AutoScrambleSubmit then task.spawn(ExecuteScrambleTradeIn) end
        end
    end)
    RuntimeState.IsExecuting = false
    Engine.ReleaseMovement("place")
    if Engine.AutoWake then Engine.AutoWake() end
    if not ok then warn("[N3 HUB] Auto steal post-place: " .. tostring(failure)) end
end
function Tasks.StealLoop()
	while true do
        if not FarmConfig.Defense_InstantSteal then
            Tasks.NormalStealPostDelivery()
            task.wait(0.1)
            continue
        end
		if IsStealActive() and not RuntimeState.IsExecuting
			and not (RuntimeState.StealEngine and RuntimeState.StealEngine.AutoCycle) then
			local Character = LocalPlayer.Character
			local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Engine = RuntimeState.StealEngine
			if RootPart and Engine then
				if DrScramble.IsInsideArena() then
					task.wait(0.25)
					continue
				end
				local nightCheck = GetNightAndWallStatus()
				if nightCheck.ShouldRetreat then
					RuntimeState.StealCancel = RuntimeState.StealCancel + 1
					RuntimeState.IsExecuting = false
					Engine.Guard.StealActive = false
					Engine.Guard.Busy = false
					Engine.Guard.Active = false
					pcall(Engine.EndDisguise)
					Engine.ReleaseMovement("steal")
					pcall(function()
						local hum = Character and Character:FindFirstChildOfClass("Humanoid")
						if hum then
							hum:Move(Vector3.zero, false)
						end
						local r = Character and Character:FindFirstChild("HumanoidRootPart")
						if r then
							r.AssemblyLinearVelocity = Vector3.zero
							r.AssemblyAngularVelocity = Vector3.zero
						end
					end)
					local Waited = 0
					while IsStealActive() and Waited < 90 do
						local live = GetNightAndWallStatus()
						if not live.ShouldRetreat then
							break
						end
						task.wait(0.25)
						Waited = Waited + 0.25
					end
					task.wait(0.2)
					continue
				end
				RuntimeState.IsExecuting = true
				local CurrentSession = RuntimeState.SessionId
				ApplyAntiRagdoll(Character)
				EnableDesyncGodmode()
				if FarmConfig.Defense_InstantSteal then
					pcall(SyncHumanoidSwap)
				end
				local DeliverTries = 0
				while DeliverTries < 6 do
					if Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal() then
						break
					end
					local CarryingNow = IsActivelyCarryingEgg() or Engine.State.Carrying or (GetEquippedEggTool() ~= nil)
					if not CarryingNow or RootPart.Position.X <= SafeBaseLineX then
						break
					end
					local delivered = false
					if Engine.ClaimMovement("steal") then
						local ok, result = pcall(Engine.DeliverEggToBase, CurrentSession)
						delivered = ok and result == true
						Engine.ReleaseMovement("steal")
					end
					DeliverTries = DeliverTries + 1
					task.wait(0.35)
				end
				local canStart = not (IsActivelyCarryingEgg() or (GetEquippedEggTool() ~= nil))
				if canStart then
					pcall(function()
						Engine.RunStealCycle(CurrentSession)
					end)
				end
				if Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal() then
					Engine.Guard.StealActive = false
					Engine.StopHold()
					Engine.ReleaseMovement("steal")
					RuntimeState.IsExecuting = false -- This Instant worker has now unwound.
					task.wait(0.1)
					continue
				end
				local finishedAt = Engine.State.LastFinishedAt
				local idleFor = (finishedAt and finishedAt > 0) and (os.clock() - finishedAt) or math.huge
				local deliveredCount = 1
				local deliveredNow = idleFor < 2
				if deliveredNow then
					Engine.State.GrabFails = 0
				elseif FarmConfig.Defense_InstantSteal then
					local Fails = Engine.State.GrabFails or 0
					if Fails == 2 or Fails == 4 then
						pcall(Engine.SoftResetCarryState)
					end
					if Fails >= 6 then
						Engine.State.GrabFails = 0
						RuntimeState.StealCancel = RuntimeState.StealCancel + 1
						RuntimeState.IsExecuting = false
						Engine.Guard.StealActive = false
						Engine.Guard.Busy = false
						Engine.Guard.Active = false
						pcall(Engine.EndDisguise)
						pcall(function()
							Engine.ReleaseMovement("steal")
						end)
						pcall(Engine.RespawnRecover)
						task.wait(0.3)
						continue
					end
				end
				if deliveredNow then
					local heldCount = CountPlayerHeldEggs()
					local shouldDeposit = false
					if FarmConfig.AutoPlaceAllEggs or FarmConfig.AutoPlaceSelect then
						if FarmConfig.PlaceMethod == "Now" then
							shouldDeposit = true
						elseif FarmConfig.PlaceMethod == "Every 5" then
							FarmConfig.BatchStealCount = FarmConfig.BatchStealCount + deliveredCount
							if FarmConfig.BatchStealCount >= 5 or heldCount >= 5 then
								FarmConfig.BatchStealCount = 0
								shouldDeposit = true
							end
						end
					end
					if shouldDeposit then
						local onlySelected = (not FarmConfig.AutoPlaceAllEggs and FarmConfig.AutoPlaceSelect)
						Tasks.ExecuteDepositEggs(onlySelected)
						task.wait(0.2)
						if FarmConfig.AutoHatch then
							task.spawn(ExecuteAutoHatch)
						end
						if FarmConfig.AutoScrambleSubmit then
							task.spawn(ExecuteScrambleTradeIn)
						end
					end
				else
					if FarmConfig.AutoScrambleSteal or FarmConfig.AutoScrambleSubmit then
						if FarmConfig.AutoHatch then
							task.spawn(ExecuteAutoHatch)
						end
						if FarmConfig.AutoScrambleSubmit then
							task.spawn(ExecuteScrambleTradeIn)
						end
					end
					task.wait(0.3)
				end
				RuntimeState.IsExecuting = false
			end
		end
		task.wait(0.1)
	end
end
task.spawn(Tasks.StealLoop)
task.spawn(function()
	while true do
		task.wait(1)
		pcall(function()
            local Engine = RuntimeState.StealEngine
            if Engine and Engine.AutoCycle then return end
			if RaceOwnsCharacter() then return end
			local live = GetNightAndWallStatus()
			if not live.ShouldRetreat then
				return
			end
			if RuntimeState.IsExecuting then
				RuntimeState.StealCancel = RuntimeState.StealCancel + 1
				RuntimeState.IsExecuting = false
			end
			if LocalPlayer:GetAttribute("RaceId") ~= nil then
				return
			end
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if not hrp then
				return
			end
			pcall(function()
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum:Move(Vector3.zero, false)
				end
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end)
		end)
	end
end)
function Tasks.MobilityRecoveryHeartbeat()
	-- BEGIN QUEST TRANSIT MOBILITY GUARD
	if Tasks.QuestTransitOwnsActor and Tasks.QuestTransitOwnsActor() then return end
	-- END QUEST TRANSIT MOBILITY GUARD
	if RaceOwnsCharacter() then return end
	if RuntimeState.StealEngine and RuntimeState.StealEngine.AutoCycle then
		return
	end
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if not RootPart then
		return
	end
	if Humanoid then
		if Humanoid.Sit then
			Humanoid.Sit = false
			Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
		if Humanoid.PlatformStand then
			Humanoid.PlatformStand = false
			Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end
	if RootPart.Position.Y < 0 and not DrScramble.IsInsideArena() then
		RootPart.CFrame = CFrame.new(RootPart.Position.X, 70, RootPart.Position.Z)
		RootPart.AssemblyLinearVelocity = Vector3.zero
	end
end
RunService.Heartbeat:Connect(Tasks.MobilityRecoveryHeartbeat)
function Tasks.DefenseHeartbeat()
	-- BEGIN QUEST TRANSIT DEFENSE GUARD
	if Tasks.QuestTransitOwnsActor and Tasks.QuestTransitOwnsActor() then return end
	-- END QUEST TRANSIT DEFENSE GUARD
	if RaceOwnsCharacter() then return end
    local Engine = RuntimeState.StealEngine
    if Engine and Engine.AutoCycle then return end
	if FarmConfig.Defense_AntiTrap then
		Tasks.ApplyDefenseAntiTrap()
	end
	if FarmConfig.Defense_AntiRagdoll then
		Tasks.ApplyDefenseAntiRagdoll()
	end
end
RunService.Heartbeat:Connect(Tasks.DefenseHeartbeat)
function Tasks.InstanInteractLoop()
	while true do
		task.wait(0.2)
		Tasks.SetupInstanInteract()
	end
end
task.spawn(Tasks.InstanInteractLoop)
function Tasks.EspRenderLoop()
	while true do
		task.wait(0.35)
		local Character = LocalPlayer.Character
		local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		if RootPart then
			local MyPos = RootPart.Position
			local MaxDist = tonumber(FarmConfig.ESP_Distance) or 2000
			local SeenKeys = {}
			local function ResolveModelImage(modelInst, fallbackImg)
				if typeof(modelInst) == "Instance" then
					local texture = ""
					local ok, found = pcall(function()
						local part = modelInst:IsA("BasePart") and modelInst
							or modelInst:FindFirstChildWhichIsA("BasePart")
						if part then
							if part:IsA("MeshPart") then
								texture = tostring(part.TextureID or "")
							end
							for _, dec in ipairs(part:GetDescendants()) do
								if dec:IsA("Decal") or dec:IsA("Texture") then
									texture = tostring(dec.Texture or "")
									if texture ~= "" then
										return texture
									end
								end
							end
							return texture
						end
						return ""
					end)
					if ok and found ~= "" then
						local num = tostring(found):match("%d+")
						if num then
							return "rbxassetid://" .. num
						end
						return tostring(found)
					end
				end
				return fallbackImg
			end
			local function RenderEggCard(key, pos, rec, info)
				Tasks.CardRenderEggKey(key, rec, info, pos, { Seen = SeenKeys, MyPos = MyPos, MaxDist = MaxDist })
			end
			local function RenderItem(key, pos, name, infoText, color, imageAsset)
				local dist = (pos - MyPos).Magnitude
				if dist > MaxDist then
					return
				end
				SeenKeys[key] = true
				local card = ActiveEspCards[key]
				if not card or not card.Anchor.Parent or card.EggMode then
					if card and card.Anchor.Parent then
						DestroyEggCard(card)
					end
					card = CreateMasterCard()
					card.EggMode = false
					ActiveEspCards[key] = card
				end
				card.Icon.Visible = (imageAsset and imageAsset ~= "") and true or false
				if card.Icon.Visible then
					card.Icon.Image = imageAsset
				end
				CardSetRow(card.NameRow, name, CardSheen)
				CardSetRow(card.ExtraRow, (infoText or "") .. " · " .. math.floor(dist) .. " m", CardSheen)
				if card.ShowIcon ~= card.Icon.Visible or card.ShowName ~= true or card.ShowExtra ~= true then
					card.ShowIcon = card.Icon.Visible
					card.ShowName = true
					card.ShowExtra = true
					card.ShowRarity = false
					card.ShowValue = false
					card.ShowMutation = false
					card:ReLayout()
				end
				card.Anchor.CFrame = CFrame.new(pos)
				card.Billboard.Enabled = true
			end
			if FarmConfig.ESP_WorldEgg then
				local fieldEggs = FetchAllFieldEggs()
				for _, egg in ipairs(fieldEggs or {}) do
					if egg.State == "Slot" or egg.State == 1 or egg.State == "" then
						local cf = egg.BoundsCFrame or (egg.PhysicalModel and egg.PhysicalModel:GetPivot())
						if cf and cf.Position.X >= 530 then
							local cat = tostring(egg.AssetCategory or egg.Name or "Egg")
							RenderEggCard("WORLD_" .. tostring(egg.Uid or cf.Position), cf, egg, ResolveGameAsset(cat))
						end
					end
				end
			end
			if FarmConfig.ESP_CarriedDropped then
				local fieldEggs = FetchAllFieldEggs()
				for _, egg in ipairs(fieldEggs or {}) do
					local st = tostring(egg.State or ""):lower()
					local isCarried = (st == "carried" or egg.State == 2 or egg.CarrierUserId ~= nil)
					local isDropped = (st == "dropped" or egg.State == 3)
					if isCarried or isDropped then
						local cf = egg.BoundsCFrame or (egg.PhysicalModel and egg.PhysicalModel:GetPivot())
						if cf then
							local cat = tostring(egg.AssetCategory or egg.Name or "Egg")
							RenderEggCard("CARRY_" .. tostring(egg.Uid or cf.Position), cf, egg, ResolveGameAsset(cat))
						end
					end
				end
			end
			if FarmConfig.ESP_Guard then
				local detectedGuards = {}
				local guardAreas = Workspace:FindFirstChild("__OBJECTS")
					and Workspace.__OBJECTS:FindFirstChild("Areas")
					and Workspace.__OBJECTS.Areas:FindFirstChild("GuardAreas")
				if guardAreas then
					for _, area in ipairs(guardAreas:GetChildren()) do
						local guard = area:FindFirstChild("Guard")
							or area:FindFirstChild("ForestGuardAuthored")
							or area:FindFirstChildWhichIsA("Model")
						if guard and guard:IsA("Model") and not detectedGuards[guard] then
							detectedGuards[guard] = true
							local pv = guard:GetPivot()
							local gName = (area.Name == "Forest") and "Forest Chicken Guard" or (area.Name .. " Guard")
							local state = tostring(
								guard:GetAttribute("GuardState")
									or guard:GetAttribute("State")
									or (guard:GetAttribute("Sleeping") and "Sleeping")
									or "Patrol"
							)
							local guardIcon = "rbxassetid://10747384394"
							local cat = guard:GetAttribute("Category") or guard:GetAttribute("AssetCategory")
							if cat then
								local realIcon = ResolveAssetImage(tostring(cat))
								if realIcon ~= "" then
									guardIcon = realIcon
								end
							end
							RenderItem(
								"GUARD_" .. area.Name,
								pv.Position,
								"[GUARD] " .. gName,
								"State: " .. state,
								Color3.fromRGB(255, 45, 45),
								guardIcon
							)
						end
					end
				end
				local liveGuards = Workspace:FindFirstChild("_Guards")
				if liveGuards then
					for _, g in ipairs(liveGuards:GetChildren()) do
						if g:IsA("Model") and not detectedGuards[g] then
							detectedGuards[g] = true
							local pv = g:GetPivot()
							local state = tostring(g:GetAttribute("GuardState") or "Patrol")
							RenderItem(
								"LIVEGUARD_" .. g.Name,
								pv.Position,
								"[GUARD] " .. g.Name,
								"State: " .. state,
								Color3.fromRGB(255, 45, 45),
								"rbxassetid://10747384394"
							)
						end
					end
				end
			end
			if FarmConfig.ESP_Pet then
				local placedFolder = Workspace:FindFirstChild("PlacedEggRenders")
				local MyUserId = LocalPlayer.UserId
				local OwnerRecords = {}
				if EggStateModule and EggStateModule.ReadOwnerEggs then
					pcall(function()
						OwnerRecords = EggStateModule.ReadOwnerEggs(MyUserId) or {}
					end)
				end
				if placedFolder then
					for _, petModel in ipairs(placedFolder:GetChildren()) do
						if petModel:IsA("Model") and string.find(petModel.Name, tostring(MyUserId)) then
							local rawName = petModel.Name
							local eggUid = rawName:match("_(.+)$") or rawName
							local pv = petModel:GetPivot()
							local details = Tasks.GetPlotItemDetails(eggUid, petModel, OwnerRecords)
							local rarityColor = DefaultRarityColors[details.Rarity] or Color3.fromRGB(87, 242, 135)
							local tagPrefix = details.IsHatched and "[PET] " or "[EGG] "
							local titleText = tagPrefix .. details.Category
							if details.Kg > 0 then
								titleText = titleText .. string.format(" (%dKg)", math.floor(details.Kg + 0.5))
							end
							local cashStr = details.Income > 0
									and string.format(
										'<font color="#57F287"><b>+$%s/s</b></font> · ',
										FormatCash(details.Income)
									)
								or ""
							local statusText = ""
							if not details.IsHatched then
								statusText = details.IsReady and '<font color="#57F287"><b>Ready!</b></font>'
									or details.TimeLeft
							end
							local infoText = string.format(
								"%s%s%s",
								cashStr,
								details.Rarity,
								(statusText ~= "" and (" · " .. statusText) or "")
							)
							RenderItem(
								"PLOTITEM_" .. rawName,
								pv.Position,
								titleText,
								infoText,
								rarityColor,
								ResolveModelImage(petModel, details.Icon)
							)
						end
					end
				end
			end
			if FarmConfig.ESP_Player then
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						local oHrp = plr.Character:FindFirstChild("HumanoidRootPart")
						if oHrp then
							local avatarImg = PlayerAvatarCache[plr.UserId]
							if not avatarImg then
								task.spawn(function()
									local ok, img = pcall(function()
										return Players:GetUserThumbnailAsync(
											plr.UserId,
											Enum.ThumbnailType.HeadShot,
											Enum.ThumbnailSize.Size100x100
										)
									end)
									if ok and img then
										PlayerAvatarCache[plr.UserId] = img
									end
								end)
								avatarImg = ""
							end
							RenderItem(
								"PLR_" .. plr.Name,
								oHrp.Position,
								plr.DisplayName .. " (@" .. plr.Name .. ")",
								"Player",
								Color3.fromRGB(80, 200, 255),
								avatarImg
							)
						end
					end
				end
			end
			if FarmConfig.ESP_Machine then
				RenderItem(
					"MACH_FUSE",
					Vector3.new(532.0, 72.0, -283.0),
					"[MACHINE] Fuse Machine",
					"Ready to Fuse",
					Color3.fromRGB(180, 70, 255),
					"rbxassetid://10734950309"
				)
				RenderItem(
					"MACH_OFFLINE",
					Vector3.new(545.1, 70.0, -413.4),
					"[OFFLINE] Claim Stand",
					"Offline Earnings",
					Color3.fromRGB(255, 215, 0),
					"rbxassetid://13522871708"
				)
			end
			if FarmConfig.ESP_Plot then
				local plots = Workspace:FindFirstChild("Plots")
				if plots then
					for _, plot in ipairs(plots:GetChildren()) do
						local center = plot:FindFirstChild("CenterPoint") or plot:FindFirstChild("PetArea")
						if center then
							local owner = plot:GetAttribute("Owner") or plot.Name
							RenderItem(
								"PLOT_" .. plot.Name,
								center.Position,
								"Plot " .. plot.Name,
								"Owner: " .. tostring(owner),
								Color3.fromRGB(0, 255, 180),
								"rbxassetid://4562959382"
							)
						end
					end
				end
			end
			for key, card in pairs(ActiveEspCards) do
				if not SeenKeys[key] then
					DestroyEggCard(card)
					ActiveEspCards[key] = nil
				end
			end
		end
	end
end
task.spawn(Tasks.EspRenderLoop)
do
	local _NoclipChar, _NoclipParts, _NoclipScanAt = nil, {}, 0
	function Tasks.MovementStepped()
	if RaceOwnsCharacter() then return end
        local Engine = RuntimeState.StealEngine
        if Engine and Engine.AutoCycle then return end
		local char = LocalPlayer.Character
		if not char then
			return
		end
		if FarmConfig.Movement_Noclip then
			local now = os.clock()
			if _NoclipChar ~= char or (now - _NoclipScanAt) > 1 then
				_NoclipChar = char
				_NoclipScanAt = now
				table.clear(_NoclipParts)
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						_NoclipParts[#_NoclipParts + 1] = part
					end
				end
			end
			for _, part in ipairs(_NoclipParts) do
				if part.CanCollide then
					part.CanCollide = false
				end
			end
		end
		if FarmConfig.Movement_Override then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				local ws = tonumber(FarmConfig.Movement_WalkSpeed) or 16
				local jp = tonumber(FarmConfig.Movement_JumpPower) or 50
				if hum.WalkSpeed ~= ws then
					hum.WalkSpeed = ws
				end
				hum.UseJumpPower = true
				if hum.JumpPower ~= jp then
					hum.JumpPower = jp
				end
			end
		end
	end
end
RunService.Stepped:Connect(Tasks.MovementStepped)
function Tasks.OnCharacterAdded(NewCharacter)
	task.wait(0.6)
	if LocalPlayer.Character ~= NewCharacter or RaceOwnsCharacter() then
		return
	end
	local Engine = RuntimeState.StealEngine
	if Engine and Engine.AutoShieldWanted() then
		pcall(Engine.MaintainAutoShield)
		return
	end
	PerformHumanoidSwap()
	EnableDesyncGodmode()
	ApplyAntiRagdoll(NewCharacter)
	UnequipAllTools()
end
-- Racing Event: semantic port of ChiliSourceV2's Race Rally controller.
-- See docs/race-rally.md for source ranges and N3 integration boundaries.
do
	local CollectionService = game:GetService("CollectionService")
	local engine = RuntimeState.StealEngine
	local race = {
		Action = "Off",
		Status = "Off",
		Tokens = "0",
		Wins = "0",
		Racer = "Ostrich",
		Driving = nil,
		Travelling = false,
		TravelGeneration = 0,
		Disposed = false,
		JoinTriedAt = 0,
		EquipAt = 0,
		RewardAt = 0,
		Drop = 0,
		OwnedRacers = { "Best Owned", "Ostrich" },
		Connections = {},
		ModuleCache = {},
		ModuleRetryAt = {},
		ErrorAt = 0,
	}
	Tasks.RaceState = race

	local function LoadRaceModule(path)
		local key = table.concat(path, "/")
		if race.ModuleCache[key] then
			return race.ModuleCache[key]
		end
		if os.clock() < (race.ModuleRetryAt[key] or 0) then
			return nil
		end
		race.ModuleRetryAt[key] = os.clock() + 2
		local module = ReplicatedStorage
		for _, name in ipairs(path) do
			module = module and module:FindFirstChild(name)
		end
		if not module or not module:IsA("ModuleScript") then
			return nil
		end
		local ok, result = pcall(require, module)
		if ok and type(result) == "table" then
			race.ModuleCache[key] = result
			return result
		end
		return nil
	end
	local function RaceData()
		return LoadRaceModule({ "Data", "RaceRally" })
	end
	local function RaceRemote(name, className)
		-- Exact network names only; do not accidentally pick another minigame's remote.
		local packages = ReplicatedStorage:FindFirstChild("Packages")
		local network = packages and packages:FindFirstChild("Networking")
		local remote = network and network:FindFirstChild(name)
		return remote and remote:IsA(className) and remote or nil
	end
	local function InvokeRace(name, ...)
		-- BEGIN NITRO REFILL SHOP HOOK
		if name == "RF/RaceRally/AskBuy" and Tasks.InvokeRaceShopPurchase then
			return Tasks.InvokeRaceShopPurchase("race", ...)
		end
		-- END NITRO REFILL SHOP HOOK
		local remote = RaceRemote(name, "RemoteFunction")
		if not remote then
			return false
		end
		return pcall(remote.InvokeServer, remote, ...)
	end
	local function ReadRaceSave()
		if not SaveModule then
			return nil
		end
		local reader = SaveModule.Get or SaveModule.Peek
		if type(reader) ~= "function" then
			return nil
		end
		local ok, save = pcall(reader)
		return ok and type(save) == "table" and type(save.RaceRally) == "table" and save.RaceRally or nil
	end
	local function RaceRoot()
		local character = LocalPlayer.Character
		return character and character:FindFirstChild("HumanoidRootPart")
	end
	local function SetRaceAction(message)
		race.Action = message
	end
	local function GetRaceTrack()
		local data = RaceData()
		return Workspace:FindFirstChild(data and data.Track or "RaceTrack")
	end
	local function GetRacePortal()
		local world = Workspace:FindFirstChild("World")
		local portal = world and world:FindFirstChild("RaceRallyPortal")
		local hitbox = portal and portal:FindFirstChild("Hitbox")
		return hitbox and hitbox:IsA("BasePart") and hitbox or nil
	end
	local function RaceJoinOpen()
		local joinEnds = Workspace:GetAttribute("RaceRallyJoinEndsAt")
		return Workspace:GetAttribute("RaceRallyRunning") == true
			and type(joinEnds) == "number"
			and Workspace:GetServerTimeNow() < joinEnds
	end
	local function RaceJoinDelay()
		local ok, ping = pcall(LocalPlayer.GetNetworkPing, LocalPlayer)
		return math.clamp(1.2 + (ok and tonumber(ping) or 0) * 4, 1.2, 6)
	end
	local function RacedThisWindow()
		local flags = LoadRaceModule({ "Shared", "Flags", "RaceRallyFlags" })
		if flags and flags.OneRacePerWindow then
			local ok, enabled = pcall(flags.OneRacePerWindow.Get, flags.OneRacePerWindow)
			if ok and enabled == false then
				return false
			end
		end
		local window, save = Workspace:GetAttribute("RaceRallyWindow"), ReadRaceSave()
		if type(window) == "number" and save and save.LastRacedWindow == window then
			return true
		end
		return race.RacedWindow ~= nil and race.RacedWindow == Workspace:GetAttribute("RaceRallyJoinEndsAt")
	end
	local function InRaceArea()
		local root, track = RaceRoot(), GetRaceTrack()
		if not root then
			return false
		end
		local lineup = track and track:FindFirstChild("PlayerLineUpArea")
		local lineupPosition = lineup and lineup:IsA("BasePart") and lineup.Position or Vector3.new(-3400, 191, 9555)
		if (root.Position - lineupPosition).Magnitude <= 500 then
			return true
		end
		if not track then
			return false
		end
		if race.BoundsTrack ~= track then
			race.BoundsTrack, race.BoundsMin, race.BoundsMax = track, nil, nil
			local minimum, maximum =
				Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
			for _, part in ipairs(track:GetDescendants()) do
				if part:IsA("BasePart") then
					minimum, maximum = minimum:Min(part.Position), maximum:Max(part.Position)
				end
			end
			if minimum.X < maximum.X then
				race.BoundsMin, race.BoundsMax =
					minimum - Vector3.new(500, 1000, 500), maximum + Vector3.new(500, 1000, 500)
			end
		end
		local minimum, maximum, position = race.BoundsMin, race.BoundsMax, root.Position
		return minimum ~= nil
			and position.X >= minimum.X
			and position.X <= maximum.X
			and position.Y >= minimum.Y
			and position.Y <= maximum.Y
			and position.Z >= minimum.Z
			and position.Z <= maximum.Z
	end
	local function EnteredRace()
		return LocalPlayer:GetAttribute("RaceId") ~= nil
			or LocalPlayer:GetAttribute("RaceGridFrame") ~= nil
			or LocalPlayer:GetAttribute("RaceRallyQueued") == true
			or (not RacedThisWindow() and InRaceArea())
	end
	local function InRaceNow()
		if LocalPlayer:GetAttribute("RaceId") ~= nil or LocalPlayer:GetAttribute("RaceRallyQueued") == true then
			return true
		end
		local heat = LocalPlayer:GetAttribute("RaceHeat")
		if type(heat) ~= "string" then
			race.HeldHeat = nil
		elseif race.HeldHeat ~= heat then
			race.HeldHeat, race.HeldSince = heat, os.clock()
		end
		if race.HeldHeat and os.clock() - race.HeldSince < 660 then
			return true
		end
		local joinEnds = Workspace:GetAttribute("RaceRallyJoinEndsAt")
		return type(joinEnds) == "number" and Workspace:GetServerTimeNow() < joinEnds + 25 and EnteredRace()
	end
	local function RaceEligible()
		if os.clock() < (race.EligibilityAt or 0) then
			return race.Eligible, race.Requirement
		end
		race.EligibilityAt = os.clock() + 2
		local eligibility = LoadRaceModule({ "Shared", "Util", "RaceRallyEligibility" })
		local flags = LoadRaceModule({ "Shared", "Flags", "RaceRallyFlags" })
		local ok, eligible, requirement = pcall(function()
			local save = SaveModule and SaveModule.Peek and SaveModule.Peek()
			return save == nil or eligibility.IsEligible(tonumber(save.SpeedPower) or 0),
				flags.SpeedPowerRequirement:Get()
		end)
		race.Eligible, race.Requirement = not ok or eligible ~= false, ok and tonumber(requirement) or nil
		return race.Eligible, race.Requirement
	end
	local function HigherPriorityRaceTask()
		-- Chili HigherFirst (50069-50208), adapted: Auto Race always outranks eggs.
		-- Keep unrelated exclusive-event arbitration, never scan/finish eggs first.
		if
			Tasks.ShootingStarState
			and Tasks.ShootingStarState.Wanted
			and Tasks.PriorityRank("Star") < Tasks.PriorityRank("Race")
		then
			return "Shooting Star"
		end
		if engine and (engine.Movement.CaptureUntil or 0) > os.clock() then
			return "Capture The Egg"
		end
		return nil
	end
	local nativePriorityStealYield = Tasks.PriorityStealYield
	Tasks.PriorityStealYield = function()
		if Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal() then
			return true
		end
		return nativePriorityStealYield()
	end
	Tasks.RaceShouldYieldSteal = function()
		if race.Disposed then
			return false
		end
		if race.Resetting or InRaceNow() or race.Travelling or (engine and engine.Movement.Owner == "race") then
			return true
		end
		return FarmConfig.Race_AutoRace == true and RaceJoinOpen() and not RacedThisWindow() and RaceEligible()
	end
	Tasks.RacePriority = function()
		return not race.Disposed
			and FarmConfig.Race_AutoRace == true
			and (InRaceNow() or race.Travelling or (RaceJoinOpen() and not RacedThisWindow() and RaceEligible()))
	end
	Tasks.RaceHoldsCharacter = function()
		return not race.Disposed
			and (
				race.Resetting == true
				or race.Travelling
				or (engine ~= nil and engine.Movement.Owner == "race")
				or InRaceNow()
			)
	end
	Tasks.RaceSuppressRagdoll = function()
		if race.Disposed then
			return false
		end
		if LocalPlayer:GetAttribute("RaceId") ~= nil then
			return true
		end
		if os.clock() < (race.RagdollResumeAt or 0) then
			return true
		end
		if not RaceJoinOpen() then
			return false
		end
		if Tasks.RaceHoldsCharacter() then
			return true
		end
		local portal, root = GetRacePortal(), RaceRoot()
		return portal ~= nil and root ~= nil and (root.Position - portal.Position).Magnitude <= 40
	end
	local function StopRaceDrive()
		local drive = race.Driving
		race.Driving = nil
		if drive then
			for _, connection in ipairs(drive.Connections) do
				connection:Disconnect()
			end
		end
	end
	local function ReleaseRaceMovement()
		if engine then
			engine.ReleaseMovement("race")
		end
		race.PreparedCharacter = nil
	end
	local function PrepareRaceCharacter()
		local character = LocalPlayer.Character
		if not character or race.PreparedCharacter == character then
			return
		end
		race.PreparedCharacter = character
		-- Undo N3's existing swap once, rather than importing a second swap controller.
		if engine and engine.ReleaseAutoShield then
			engine.ReleaseAutoShield(true)
		end
		if RuntimeState.OriginalHumanoid then
			RestoreCharacter()
		end
		if Tasks.ResumeRaceRigSync then
			Tasks.ResumeRaceRigSync()
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			for _, state in ipairs({
				Enum.HumanoidStateType.Ragdoll,
				Enum.HumanoidStateType.FallingDown,
				Enum.HumanoidStateType.Physics,
				Enum.HumanoidStateType.PlatformStanding,
				Enum.HumanoidStateType.Dead,
			}) do
				humanoid:SetStateEnabled(state, true)
			end
		end
	end
	local function UpdateRaceStealPause()
		local paused = Tasks.RaceShouldYieldSteal()
		if paused == (race.StealPaused == true) then
			return
		end
		race.StealPaused = paused
		if not engine then
			return
		end
		if paused then
			-- Invalidate N3/Instant motion; the old worker keeps ownership until cleanup.
			RuntimeState.StealCancel = RuntimeState.StealCancel + 1
			engine.CancelAutoSteal()
			engine.Guard.StealActive, engine.Guard.Busy = false, false
			-- Guard.Active stays owned by the dodge worker until its final rig restore.
			engine.StopHold()
			engine.EndDisguise()
			engine.AutoStatus = "Paused for Auto Race"
		elseif engine.AutoWake then
			engine.AutoWake() -- Existing enabled normal/Instant schedulers resume, no toggle writes.
		end
	end
	local function ClaimRaceMovement()
		if not engine then
			SetRaceAction("Waiting for movement engine")
			return false
		end
		if engine.AutoCycle or RuntimeState.IsExecuting or engine.Guard.Active or engine.Guard.Busy then
			SetRaceAction("Race open, waiting for the current movement to stop")
			return false
		end
		if engine.ClaimMovement("race") then
			race.WaitSince = nil
			PrepareRaceCharacter()
			return true
		end
		local owner = engine.Movement.Owner
		if owner == "steal" then
			engine.ReleaseMovement("steal")
			if engine.ClaimMovement("race") then
				PrepareRaceCharacter()
				return true
			end
		end
		local keys = {
			steal = "StealFilter",
			place = "Place",
			treadmill = "Treadmill",
			wisp = "Wisp",
			essence = "Essence",
			butterfly = "Butterfly",
			star = "Star",
			scramble = "StealLab",
		}
		local rank = owner == "capture" and 0 or Tasks.PriorityRank(keys[owner] or "Unknown")
		if Tasks.PriorityRank("Race") >= rank then
			race.WaitSince = nil
			SetRaceAction("Race open, " .. tostring(owner or "another task") .. " goes first (Task Priority)")
			return false
		end
		race.WaitSince = race.WaitSince or os.clock()
		if (engine.State and engine.State.Carrying) or os.clock() - race.WaitSince < 8 then
			SetRaceAction("Race open, waiting for " .. tostring(owner) .. " to stop")
			return false
		end
		race.WaitSince, engine.Movement.Owner = nil, "race"
		PrepareRaceCharacter()
		return true
	end
	local function ExitRaceTreadmill()
		for _ = 1, 3 do
			if LocalPlayer:GetAttribute("RaceId") ~= nil or LocalPlayer:GetAttribute("RaceRallyQueued") == true then
				return
			end
			local root = RaceRoot()
			if not (RuntimeState.OnTreadmill or IsPlayerRunningOnTreadmill() or (root and root.Anchored)) then
				return
			end
			SetRaceAction("Getting off the treadmill")
			ExitTreadmill()
			task.wait(0.4)
		end
	end
	local function TeleportRacePosition(position)
		if typeof(position) ~= "Vector3" then
			return false
		end
		local root = RaceRoot()
		if not root then
			return false
		end
		root.CFrame = CFrame.new(position) * root.CFrame.Rotation
		root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		return true
	end
	local function RaceTravelCancelled(generation, character, allowRespawn)
		return race.Disposed
			or generation ~= race.TravelGeneration
			or FarmConfig.Race_AutoRace ~= true
			or (not allowRespawn and character ~= LocalPlayer.Character)
	end
	local function WaitRaceFieldOpen(cancelled, report)
		local heldPosition, waited = nil, false
		while not cancelled() do
			local now = Workspace:GetServerTimeNow()
			if engine.IsNight() and AreaEggCycleModule and AreaEggCycleModule.NextResetTime then
				local ok, nextReset = pcall(AreaEggCycleModule.NextResetTime, now)
				local cycle = LoadRaceModule({ "Shared", "Util", "AreaEggResetCycle" })
				local delay = cycle
						and ((tonumber(cycle.WallCountdownDelayAfterDayStartsSeconds) or 2) + (tonumber(
							cycle.WallCountdownSeconds
						) or 3))
					or 5
				if ok and type(nextReset) == "number" then
					race.FieldOpenAt = nextReset + delay
				end
			end
			local remaining = math.max((race.FieldOpenAt or now) - now, engine.WallSealed() and 0.3 or 0)
			if remaining <= 0 and not engine.IsNight() then
				if waited then
					local deadline = os.clock() + 5
					while os.clock() < deadline do
						if cancelled() then
							return false
						end
						RunService.Heartbeat:Wait()
					end
				end
				return true
			end
			waited = true
			local root = RaceRoot()
			if root then
				heldPosition = heldPosition or root.Position
				if (root.Position - heldPosition).Magnitude > 4 then
					TeleportRacePosition(heldPosition)
				end
				root.AssemblyLinearVelocity = Vector3.zero
			end
			if report then
				report("waiting in the safe zone, field opens in " .. math.ceil(remaining) .. "s")
			end
			RunService.Heartbeat:Wait()
		end
		return false
	end
	local function LeaveRaceBase(cancelled, report)
		local safe, root = engine.GetBaseSafeSpot(), RaceRoot()
		if safe and root and engine.InsideBase() and (root.Position - safe).Magnitude > 69 then
			if report then
				report("leaving the base through the safe zone")
			end
			local target, deadline = safe + Vector3.new(0, 3, 0), os.clock() + 20
			while os.clock() < deadline and not cancelled() do
				root = RaceRoot()
				if not root then
					return false
				end
				local delta = target - root.Position
				if delta.Magnitude <= 4 then
					break
				end
				local dt = RunService.Heartbeat:Wait()
				if cancelled() then
					return false
				end
				TeleportRacePosition(root.Position + delta.Unit * math.min(250 * dt, delta.Magnitude))
			end
			task.wait(0.3)
		end
		return not cancelled()
	end
	local function StepRaceTravel(target, cancelled, report)
		if not LeaveRaceBase(cancelled, report) then
			return false
		end
		if engine.InsideBase() and not WaitRaceFieldOpen(cancelled, report) then
			return false
		end
		local deadline, previousDistance, stalled = os.clock() + 30, math.huge, 0
		while os.clock() < deadline and not cancelled() do
			local root, destination = RaceRoot(), target()
			if not root or not destination then
				return false
			end
			local horizontal = Vector3.new(destination.X - root.Position.X, 0, destination.Z - root.Position.Z)
			local stride = math.max(engine.GetWalkSpeed() * 1.515, 40)
			if horizontal.Magnitude > previousDistance - stride * 0.5 then
				stalled += 1
				if stalled >= 2 then
					return false
				end
			else
				stalled = 0
			end
			previousDistance = horizontal.Magnitude
			if horizontal.Magnitude <= stride then
				TeleportRacePosition(destination)
				task.wait(0.5)
				root, destination = RaceRoot(), target()
				return not cancelled()
					and root ~= nil
					and destination ~= nil
					and Vector3.new(destination.X - root.Position.X, 0, destination.Z - root.Position.Z).Magnitude
						<= stride
			end
			local step = Vector3.new(root.Position.X, destination.Y + 42, root.Position.Z) + horizontal.Unit * stride
			if report then
				report(math.floor(horizontal.Magnitude - stride + 0.5))
			end
			local elapsed = 0
			while elapsed < 0.1 and not cancelled() do
				TeleportRacePosition(step)
				elapsed += RunService.Heartbeat:Wait()
			end
		end
		return false
	end
	local function GlideRaceTravel(target, cancelled, tolerance, report, timeout)
		if engine.InsideBase() and not WaitRaceFieldOpen(cancelled, report) then
			return false
		end
		local root = RaceRoot()
		if not root then
			return false
		end
		local character, position = LocalPlayer.Character, root.Position
		local deadline, pauseUntil, rollbacks = os.clock() + timeout, 0, 0
		while os.clock() < deadline and not cancelled() and LocalPlayer.Character == character do
			local dt = RunService.Heartbeat:Wait()
			if cancelled() then
				return false
			end
			root = RaceRoot()
			local destination = target()
			if not root or not destination then
				return false
			end
			local horizontalDistance =
				Vector3.new(destination.X - root.Position.X, 0, destination.Z - root.Position.Z).Magnitude
			if horizontalDistance <= tolerance then
				return true
			end
			if root.Anchored then
				ExitRaceTreadmill()
				position = root.Position
			end
			if os.clock() < pauseUntil then
				root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
				position = root.Position
				continue
			end
			if (root.Position - position).Magnitude > 25 then
				rollbacks += 1
				pauseUntil, position = os.clock() + math.min(0.25 + 0.25 * rollbacks, 1), root.Position
				if report then
					report("lagged back, waiting a moment (" .. rollbacks .. ")")
				end
				continue
			end
			local speed = math.clamp(tonumber(FarmConfig.AutoTweenSpeed) or 400, 100, 1000)
				* (rollbacks < 2 and 1 or math.max(0.5, 0.8 ^ (rollbacks - 1)))
			local delta = destination - position
			position = delta.Magnitude <= speed * dt and destination or position + delta.Unit * speed * dt
			local facing = Vector3.new(delta.X, 0, delta.Z)
			root.CFrame = CFrame.new(position)
				* (facing.Magnitude > 0.05 and CFrame.lookAt(Vector3.zero, facing.Unit) or root.CFrame.Rotation)
			root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			if report then
				report(math.floor(horizontalDistance + 0.5))
			end
		end
		return false
	end
	local function ReadTravelEgg(uid)
		if EggStateModule and type(EggStateModule.ReadFieldEgg) == "function" then
			local ok, record = pcall(EggStateModule.ReadFieldEgg, uid)
			if ok then
				return record
			end
		end
		return nil
	end
	local function TravelEggHeld(uid)
		local record = ReadTravelEgg(uid)
		return (engine.State.Carrying and engine.State.CarryUid == uid)
			or (record ~= nil and tonumber(record.CarrierUserId) == LocalPlayer.UserId)
	end
	local function SelectTravelEgg(position, excluded)
		if not EggStateModule or type(EggStateModule.ReadFieldEggs) ~= "function" then
			return nil
		end
		local ok, snapshot = pcall(EggStateModule.ReadFieldEggs)
		local records = ok and type(snapshot) == "table" and snapshot.Records
		if type(records) ~= "table" then
			return nil
		end
		local ownPrefix = "FirstAreaEgg_" .. LocalPlayer.UserId
		local models = Workspace:FindFirstChild("AreaEggSlotsClient")
		local nearest, nearestVisible, distance, visibleDistance = nil, nil, math.huge, math.huge
		for key, record in pairs(records) do
			local uid = type(record) == "table" and (record.Uid or key)
			if
				type(uid) ~= "string"
				or excluded[uid]
				or typeof(record.BottomCFrame) ~= "CFrame"
				or (tonumber(record.CarrierUserId) or 0) > 0
				or not (record.State == nil or record.State == "Slot" or record.State == "Dropped")
			then
				continue
			end
			local slot
			if string.sub(uid, 1, 13) == "FirstAreaEgg_" then
				if string.sub(uid, 1, #ownPrefix) == ownPrefix then
					slot = string.match(uid, "_([%w ]+:Slot_%d+)$")
				end
			elseif type(record.AreaId) == "string" and type(record.NestId) == "string" then
				slot = record.AreaId .. ":" .. record.NestId
			end
			local guard = slot and engine.FindGuard(record.AreaId)
			if slot and not guard and string.sub(uid, 1, #ownPrefix) == ownPrefix then
				guard = engine.FindGuard("Forest")
			end
			local guardRoot = guard and guard:FindFirstChild("HumanoidRootPart", true)
			if not slot or not guardRoot or not guardRoot:IsA("BasePart") then
				continue
			end
			local at, model = record.BottomCFrame.Position, models and models:FindFirstChild(uid)
			if model and model:IsA("Model") then
				local modelPosition = model:GetPivot().Position
				at = Vector3.new(modelPosition.X, math.min(modelPosition.Y, at.Y + 6), modelPosition.Z)
			end
			local separation = Vector3.new(at.X - position.X, 0, at.Z - position.Z).Magnitude
			local candidate = { Uid = uid, Slot = slot, Guard = guardRoot, Position = at }
			if model and separation < visibleDistance then
				nearestVisible, visibleDistance = candidate, separation
			end
			if separation < distance then
				nearest, distance = candidate, separation
			end
		end
		return nearestVisible or nearest
	end
	local function RagdollRaceTravel(target, cancelled)
		-- Source portal fallback only. This is NOT the normal Sena steal controller.
		local root = RaceRoot()
		local strike = RaceRemote("RE/GuardPatrol/ForestStrike", "RemoteEvent")
		if not root or not strike or not EggStateModule or type(EggStateModule.CarryFieldEgg) ~= "function" then
			return false
		end
		local taken, excluded = nil, {}
		race.RagdollTravel = true
		local landed, strikeConnection = false, nil
		local ok, result = pcall(function()
			for _ = 1, 3 do
				root = RaceRoot()
				local candidate = root and SelectTravelEgg(root.Position, excluded)
				if not candidate or cancelled() then
					break
				end
				local elapsed = 0
				while not TravelEggHeld(candidate.Uid) and elapsed < 2.5 and not cancelled() do
					TeleportRacePosition(candidate.Position + Vector3.new(0, 3, 0))
					local carried, accepted, reason = pcall(EggStateModule.CarryFieldEgg, candidate.Uid, candidate.Slot)
					if
						carried
						and accepted ~= true
						and type(reason) == "string"
						and elapsed > 0.4
						and not string.find(string.lower(reason), "closer", 1, true)
					then
						break
					end
					elapsed += task.wait()
				end
				if TravelEggHeld(candidate.Uid) then
					taken = candidate
					break
				end
				excluded[candidate.Uid] = true
			end
			if not taken or cancelled() then
				return false
			end
			strikeConnection = LocalPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
				if
					landed
					or cancelled()
					or (tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) <= Workspace:GetServerTimeNow()
				then
					return
				end
				local destination = target()
				if destination then
					landed = true
					TeleportRacePosition(destination)
				end
			end)
			strike:FireServer({ EggUid = taken.Uid, GuardCFrame = taken.Guard.CFrame })
			local deadline = os.clock() + 3
			while not landed and os.clock() < deadline and not cancelled() do
				task.wait()
			end
			if strikeConnection then
				strikeConnection:Disconnect()
				strikeConnection = nil
			end
			if taken and TravelEggHeld(taken.Uid) and type(EggStateModule.DropFieldEgg) == "function" then
				pcall(EggStateModule.DropFieldEgg, "PlayerRequest")
			end
			if not landed then
				return false
			end
			while
				(tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) > Workspace:GetServerTimeNow()
				and not cancelled()
			do
				local destination = target()
				if destination then
					TeleportRacePosition(destination)
				end
				RunService.Heartbeat:Wait()
			end
			return true
		end)
		if strikeConnection then
			strikeConnection:Disconnect()
		end
		if taken and TravelEggHeld(taken.Uid) and type(EggStateModule.DropFieldEgg) == "function" then
			pcall(EggStateModule.DropFieldEgg, "PlayerRequest")
		end
		race.RagdollTravel = false
		return ok and result == true
	end
	local function CurrentRaceSpeed()
		return math.max(math.clamp(tonumber(FarmConfig.Race_Speed) or 144, 100, 144) - race.Drop, 100)
	end
	local function ReduceRaceSpeed(reason)
		if CurrentRaceSpeed() <= 100 then
			return
		end
		race.Drop += 50
		SetRaceAction(reason .. ", racing at " .. CurrentRaceSpeed())
	end
	local function StartRaceDrive(track)
		local root = RaceRoot()
		local attachment = track and track:FindFirstChild("AttachmentTrack")
		local pathModule = LoadRaceModule({ "Shared", "Modules", "RaceTrackPath" })
		if not root or not attachment or not pathModule then
			SetRaceAction("Race started, waiting for character / AttachmentTrack / RaceTrackPath")
			return false
		end
		local ok, path = pcall(pathModule.new, attachment)
		if not ok or not path then
			SetRaceAction("RaceTrackPath could not be built")
			return false
		end
		local halfLength = path.Length / 2
		local progress = path:Project(root.Position, halfLength, halfLength, halfLength)
		local frame = path:FrameAt(progress)
		if (root.Position - frame.Position).Magnitude > 80 then
			SetRaceAction("Waiting for the game to place the racer on the track")
			return false
		end
		local drive = {
			Path = path,
			Track = track,
			Progress = progress,
			Lift = math.max((root.Position - frame.Position):Dot(frame.UpVector), 2),
			Character = LocalPlayer.Character,
			Connections = {},
			CheckAt = 0,
			PowerAt = 0,
		}
		race.Driving = drive
		local function ApplyRaceFrame()
			if
				race.Driving ~= drive
				or race.Disposed
				or FarmConfig.Race_AutoRace ~= true
				or LocalPlayer.Character ~= drive.Character
			then
				return
			end
			local currentRoot = RaceRoot()
			if not currentRoot then
				return
			end
			local currentFrame = path:FrameAt(drive.Progress)
			if os.clock() >= drive.CheckAt then
				drive.CheckAt = os.clock() + 1
				local expected = currentFrame.Position + currentFrame.UpVector * drive.Lift
				if (currentRoot.Position - expected).Magnitude > 40 then
					drive.Progress = path:Project(currentRoot.Position, drive.Progress, 300, 300)
					currentFrame = path:FrameAt(drive.Progress)
					local now = os.clock()
					if drive.PulledAt and now - drive.PulledAt < 6 then
						drive.PulledAt, race.LapAt = nil, now
						ReduceRaceSpeed("Pulled back")
					else
						drive.PulledAt = now
					end
				end
			end
			currentRoot.CFrame = currentFrame + currentFrame.UpVector * drive.Lift
			currentRoot.AssemblyLinearVelocity = currentFrame.LookVector * CurrentRaceSpeed()
			currentRoot.AssemblyAngularVelocity = Vector3.zero
		end
		local powerRemote = RaceRemote("RE/MountRace/PowerUp", "RemoteEvent")
		local function UseRacePowerUps()
			if not powerRemote or FarmConfig.Race_PowerUps ~= true then
				return
			end
			local currentRoot, now = RaceRoot(), Workspace:GetServerTimeNow()
			if not currentRoot then
				return
			end
			local item = LocalPlayer:GetAttribute("RacePowerUp")
			if type(item) == "string" and item ~= "" then
				local rolling = (tonumber(LocalPlayer:GetAttribute("RacePowerUpRollEndsAt")) or 0) > now
				local effect = (tonumber(LocalPlayer:GetAttribute("RacePowerUpEffectEndsAt")) or 0) > now
				local stunned = (tonumber(LocalPlayer:GetAttribute("RacePowerUpStunEndsAt")) or 0) > now
				if not rolling and not effect and not stunned then
					powerRemote:FireServer("Use", currentRoot.Position, path:FrameAt(drive.Progress).LookVector)
				end
				return
			end
			for _, box in ipairs(CollectionService:GetTagged("RacePowerUpSpawn")) do
				if not box:IsDescendantOf(track) then
					continue
				end
				local readyAt = box:GetAttribute("RaceBoxReadyAt")
				local pad = box:FindFirstChild("Pad")
					or (box:IsA("Model") and box.PrimaryPart)
					or box:FindFirstChildWhichIsA("BasePart")
				if
					pad
					and (type(readyAt) ~= "number" or readyAt <= now)
					and (pad.Position - currentRoot.Position).Magnitude <= 30
				then
					powerRemote:FireServer("Pickup", box)
					break
				end
			end
		end
		drive.Connections[1] = RunService.Heartbeat:Connect(function(dt)
			if
				race.Driving ~= drive
				or race.Disposed
				or LocalPlayer.Character ~= drive.Character
				or FarmConfig.Race_AutoRace ~= true
			then
				return
			end
			drive.Progress += CurrentRaceSpeed() * dt
			pcall(ApplyRaceFrame)
			if os.clock() >= drive.PowerAt then
				drive.PowerAt = os.clock() + 0.2
				pcall(UseRacePowerUps)
			end
		end)
		drive.Connections[2] = RunService.PreSimulation:Connect(function()
			if race.Driving == drive then
				pcall(ApplyRaceFrame)
			end
		end)
		return true
	end
	local function NudgeRaceMount()
		local key = tostring(LocalPlayer:GetAttribute("RaceHeat"))
			.. tostring(Workspace:GetAttribute("RaceRallyWindow"))
		if race.NudgeRace ~= key then
			race.NudgeRace, race.NudgeCount = key, 0
		end
		if race.NudgeCount >= 3 then
			return false
		end
		local character, root = LocalPlayer.Character, RaceRoot()
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local ragdolled = (tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) > Workspace:GetServerTimeNow()
		if
			not humanoid
			or not root
			or ragdolled
			or LocalPlayer:GetAttribute("RaceCutscenePlaying") == true
			or (humanoid.PlatformStand and root:FindFirstChild("MountDrive") ~= nil)
		then
			race.OffRacerSince = nil
			return false
		end
		race.OffRacerSince = race.OffRacerSince or os.clock()
		if os.clock() - race.OffRacerSince < 1 or os.clock() < (race.NudgeAt or 0) then
			return true
		end
		race.NudgeAt, race.NudgeCount = os.clock() + 5, race.NudgeCount + 1
		local generation = race.TravelGeneration
		task.spawn(function()
			if RaceTravelCancelled(generation, character) then
				return
			end
			local forward = root.CFrame.LookVector
			pcall(humanoid.Move, humanoid, Vector3.new(forward.X, 0, forward.Z), false)
			humanoid.Jump = true
			task.wait(0.3)
			if not RaceTravelCancelled(generation, character) then
				pcall(humanoid.Move, humanoid, Vector3.zero, false)
			end
		end)
		return true
	end
	local function StartRaceTravel(action)
		if race.Travelling or race.Disposed then
			return false
		end
		race.TravelGeneration += 1
		local generation, character, cancelVersion = race.TravelGeneration, LocalPlayer.Character, race.CancelVersion
		race.Travelling = true
		task.spawn(function()
			local function cancelled(allowRespawn)
				return RaceTravelCancelled(generation, character, allowRespawn) or race.CancelVersion ~= cancelVersion
			end
			local ok, failure = pcall(function()
				if not cancelled() then
					action(cancelled)
				end
			end)
			if generation ~= race.TravelGeneration then
				return
			end
			race.Travelling, race.Resetting = false, false
			if not ok then
				race.LastError = tostring(failure)
				SetRaceAction("Race travel failed: " .. tostring(failure))
				warn("[N3 HUB] Race travel: " .. tostring(failure))
			end
			if race.Disposed or not InRaceNow() then
				ReleaseRaceMovement()
			end
			race.NextTick = 0
		end)
		return true
	end
	local function ResetRaceCharacter(cancelled)
		race.Resetting = true
		StopRaceDrive()
		if engine and engine.ReleaseAutoShield then
			engine.ReleaseAutoShield(true)
		end
		if RuntimeState.OriginalHumanoid then
			RestoreCharacter()
		end
		ExitRaceTreadmill()
		local oldCharacter = LocalPlayer.Character
		local humanoid = oldCharacter and oldCharacter:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(humanoid.UnequipTools, humanoid)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			humanoid.BreakJointsOnDeath, humanoid.RequiresNeck, humanoid.Health = true, true, 0
			pcall(humanoid.ChangeState, humanoid, Enum.HumanoidStateType.Dead)
		end
		if oldCharacter then
			pcall(oldCharacter.BreakJoints, oldCharacter)
		end
		local wipe = RaceRemote("RE/RigSync/AskRigWipe", "RemoteEvent")
		if wipe and oldCharacter then
			pcall(wipe.FireServer, wipe, oldCharacter)
		end
		local deadline = os.clock() + 8
		while
			os.clock() < deadline
			and not cancelled(true)
			and (LocalPlayer.Character == oldCharacter or not RaceRoot())
		do
			SetRaceAction("Race portal: respawning")
			task.wait(0.1)
		end
		race.Resetting = false
		if LocalPlayer.Character == oldCharacter or cancelled(true) then
			return false
		end
		race.PreparedCharacter = nil
		PrepareRaceCharacter()
		task.wait(1)
		return not cancelled(true)
	end
	local function RequestRaceReset(reason)
		local window = Workspace:GetAttribute("RaceRallyWindow") or Workspace:GetAttribute("RaceRallyJoinEndsAt") or 0
		if race.ResetWindow ~= window then
			race.ResetWindow, race.ResetCount = window, 0
		end
		if race.Travelling or race.ResetCount >= 2 or os.clock() < (race.ResetUntil or 0) then
			return false
		end
		race.ResetCount += 1
		race.ResetUntil = os.clock() + 10
		SetRaceAction(reason .. ", resetting to get back")
		return StartRaceTravel(ResetRaceCharacter)
	end
	local function LeaveRace(reason)
		if os.clock() < (race.LeaveAt or 0) then
			return
		end
		race.LeaveAt = os.clock() + 2
		local remote = RaceRemote("RE/MountRace/AskLeave", "RemoteEvent")
		if remote then
			pcall(remote.FireServer, remote)
		end
		SetRaceAction(reason)
	end
	local function PassThroughRacePortal(hitbox, cancelled)
		local deadline = os.clock() + 10
		local function stopped()
			return os.clock() >= deadline or cancelled() or EnteredRace() or not hitbox.Parent
		end
		local function WalkPortalPass(destination, touching, timeout)
			local untilAt = os.clock() + timeout
			while os.clock() < untilAt and not stopped() do
				local root, character = RaceRoot(), LocalPlayer.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				if not root or not humanoid then
					return false
				end
				if root.Anchored then
					ExitRaceTreadmill()
				end
				local delta = Vector3.new(destination.X - root.Position.X, 0, destination.Z - root.Position.Z)
				if delta.Magnitude <= 3 then
					return true
				end
				local speed = math.max(humanoid.WalkSpeed, 16) * 0.95
				root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
					+ delta.Unit * math.min(speed, delta.Magnitude / 0.05)
				humanoid:Move(delta.Unit, false)
				if
					touching
					and type(firetouchinterest) == "function"
					and Vector3.new(hitbox.Position.X - root.Position.X, 0, hitbox.Position.Z - root.Position.Z).Magnitude
						<= 12
				then
					pcall(firetouchinterest, root, hitbox, 0)
					pcall(firetouchinterest, root, hitbox, 1)
				end
				RunService.Heartbeat:Wait()
			end
			return false
		end
		for attempt = 1, 4 do
			if stopped() then
				break
			end
			local forward = hitbox.CFrame.LookVector
			forward = Vector3.new(forward.X, 0, forward.Z)
			forward = forward.Magnitude > 0.01 and forward.Unit or Vector3.new(1, 0, 0)
			local side, distance = attempt % 2 == 1 and 1 or -1, attempt == 1 and 30 or attempt == 2 and 60 or 100
			local origin = hitbox.Position
			local retreat = origin + forward * side * distance
			SetRaceAction(
				string.format("Not in yet, backing off %d studs and going in again (%d/4)", distance, attempt)
			)
			if distance >= 100 then
				local root = RaceRoot()
				if root then
					TeleportRacePosition(Vector3.new(retreat.X, root.Position.Y, retreat.Z))
				end
				task.wait(0.5)
			else
				WalkPortalPass(retreat, false, distance / 40 + 2)
				task.wait(0.2)
			end
			WalkPortalPass(origin - forward * side * 10, true, distance / 40 + 3)
			task.wait(0.3)
		end
		-- Never zero a newly spawned racer's velocity from a late portal worker.
		if not cancelled() and not EnteredRace() then
			local root, character = RaceRoot(), LocalPlayer.Character
			if root then
				root.AssemblyLinearVelocity = Vector3.zero
			end
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:Move(Vector3.zero, false)
			end
		end
		return EnteredRace()
	end
	local function TravelToRacePortal(hitbox, cancelled)
		ExitRaceTreadmill()
		local function stopped()
			return cancelled()
				or not RaceJoinOpen()
				or EnteredRace()
				or RacedThisWindow()
				or HigherPriorityRaceTask() ~= nil
				or not hitbox.Parent
		end
		local function report(message)
			SetRaceAction(
				type(message) == "string" and "Race portal: " .. message
					or "Step TP to the race portal (2/4), " .. message .. " studs"
			)
		end
		if not LeaveRaceBase(stopped, report) then
			return
		end
		if engine.InsideBase() and not WaitRaceFieldOpen(stopped, report) then
			return
		end
		local function destination()
			return hitbox.Parent and hitbox.Position + Vector3.new(0, 3, 0) or nil
		end
		local function confirm(method)
			if EnteredRace() then
				return true
			end
			if stopped() then
				return EnteredRace()
			end
			local root = RaceRoot()
			if root and (root.Position - hitbox.Position).Magnitude <= 30 then
				root.CFrame, root.AssemblyLinearVelocity = hitbox.CFrame, Vector3.zero
				if type(firetouchinterest) == "function" then
					pcall(firetouchinterest, root, hitbox, 0)
					pcall(firetouchinterest, root, hitbox, 1)
				end
			end
			SetRaceAction("Race portal: " .. method .. ", checking the race area")
			local deadline = os.clock() + math.max(3, RaceJoinDelay() + 1)
			while os.clock() < deadline and not stopped() do
				task.wait(0.1)
			end
			return EnteredRace()
		end
		local function farFromPortal()
			local root = RaceRoot()
			return root and (root.Position - hitbox.Position).Magnitude > 15
		end
		if not stopped() then
			SetRaceAction("Race portal: direct TP (1/4)")
			TeleportRacePosition(destination())
			task.wait(0.3)
			if confirm("direct TP") then
				return
			end
		end
		if not stopped() then
			if farFromPortal() then
				StepRaceTravel(destination, stopped, report)
			end
			if confirm("step TP") then
				return
			end
		end
		if not stopped() then
			SetRaceAction("Ragdoll TP to the race portal (3/4)")
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:UnequipTools()
			end
			local function besidePortal()
				if not hitbox.Parent then
					return nil
				end
				local forward = hitbox.CFrame.LookVector
				forward = Vector3.new(forward.X, 0, forward.Z)
				forward = forward.Magnitude > 0.01 and forward.Unit or Vector3.new(1, 0, 0)
				return hitbox.Position + forward * 18 + Vector3.new(0, 3, 0)
			end
			RagdollRaceTravel(besidePortal, stopped)
			local deadline = os.clock() + 4
			while
				os.clock() < deadline
				and not stopped()
				and (tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) > Workspace:GetServerTimeNow()
			do
				SetRaceAction("Race portal: waiting for the ragdoll to end")
				task.wait(0.1)
			end
			if confirm("ragdoll TP") then
				return
			end
		end
		if not stopped() then
			if farFromPortal() then
				GlideRaceTravel(destination, stopped, 15, function(message)
					SetRaceAction(
						type(message) == "string" and "Race portal: " .. message
							or "Flying to the race portal (4/4), " .. message .. " studs"
					)
				end, 30)
			end
			confirm("flying")
		end
	end
	local function RetryRacePortalAfterReset(hitbox, cancelled)
		if not ResetRaceCharacter(cancelled) then
			return
		end
		local character = LocalPlayer.Character
		local function stopped()
			return cancelled(true)
				or LocalPlayer.Character ~= character
				or not RaceJoinOpen()
				or EnteredRace()
				or RacedThisWindow()
				or HigherPriorityRaceTask() ~= nil
				or not hitbox.Parent
		end
		local function destination()
			return hitbox.Parent and hitbox.Position + Vector3.new(0, 3, 0) or nil
		end
		for attempt = 1, 2 do
			local root = RaceRoot()
			if stopped() or not root or (root.Position - hitbox.Position).Magnitude <= 15 then
				break
			end
			StepRaceTravel(destination, stopped, function(message)
				SetRaceAction(
					type(message) == "string" and "Race portal: " .. message
						or string.format(
							"Step TP to the race portal after the reset, %d studs (try %d)",
							message,
							attempt
						)
				)
			end)
		end
	end
	local function ReturnFromRace(cancelled)
		local function stopped()
			return cancelled() or InRaceNow()
		end
		local function destination()
			local safe = engine.GetBaseSafeSpot()
			return safe and safe + Vector3.new(0, 3, 0)
		end
		local function report(message)
			SetRaceAction(
				type(message) == "string" and "Going home: " .. message
					or "Raced this window, going home, " .. message .. " studs"
			)
		end
		if destination() and not StepRaceTravel(destination, stopped, report) and not stopped() then
			GlideRaceTravel(destination, stopped, 15, report, 120)
		end
		if not stopped() and InRaceArea() then
			-- The current travel owns cleanup; schedule the source's bounded reset for the next tick.
			race.ReturnFailed = true
		end
	end
	local raceShop = {
		{ Id = "MutationToken", Name = "Nitro Mutation" },
		{ Id = "CashBooster", Name = "Cash Booster" },
		{ Id = "SpeedBoost", Name = "Speed Boost" },
		{ Id = "TreadmillBoost", Name = "Treadmill Boost" },
		{ Id = "RacingBat", Name = "Racing Bat" },
	}
	local function UpdateOwnedRaceRacers(save, data)
		local owned, names = {}, { "Best Owned" }
		for id, definition in pairs(data.Racers or {}) do
			if (type(save.Racers) == "table" and save.Racers[id] == true) or id == data.DefaultRacer then
				table.insert(owned, { Id = id, Name = definition.DisplayName, Order = definition.Order })
			end
		end
		table.sort(owned, function(left, right)
			return left.Order > right.Order
		end)
		for _, racer in ipairs(owned) do
			table.insert(names, racer.Name)
		end
		race.OwnedRacers = names
		local dropdown, key = Tasks.RaceRacerDropdown, table.concat(names, ",")
		if dropdown and race.OwnedKey ~= key then
			local selected = table.find(names, FarmConfig.Race_Racer) and FarmConfig.Race_Racer or "Best Owned"
			dropdown:SetValues(names)
			if dropdown.Value ~= selected then
				dropdown:SetValue(selected)
			end
			race.OwnedKey = key
		end
		if FarmConfig.Race_AutoEquip == true and os.clock() >= race.EquipAt then
			local desired = owned[1] and owned[1].Id or data.DefaultRacer
			for _, racer in ipairs(owned) do
				if racer.Name == FarmConfig.Race_Racer then
					desired = racer.Id
				end
			end
			local equipped = tostring(save.EquippedRacer or "")
			if equipped == "" then
				equipped = data.DefaultRacer
			end
			if desired ~= equipped then
				race.EquipAt = os.clock() + 2
				InvokeRace("RF/RaceRally/AskEquipRacer", desired)
			end
		end
	end
	local function ClaimAndBuyRaceRewards(save, data)
		if os.clock() < race.RewardAt then
			return
		end
		race.RewardAt = os.clock() + 5
		if FarmConfig.Race_AutoClaim == true then
			local claimed = type(save.Milestones) == "table" and save.Milestones or {}
			for id, definition in pairs(data.Milestones or {}) do
				if race.Disposed then
					return
				end
				if not claimed[id] and (tonumber(save.Wins) or 0) >= definition.Wins then
					InvokeRace("RF/RaceRally/AskClaimMilestone", id)
				end
			end
			if type(data.RepeatsEarned) == "function" then
				local ok, earned = pcall(data.RepeatsEarned, tonumber(save.Wins) or 0)
				if ok and (tonumber(save.Repeats) or 0) < earned then
					InvokeRace("RF/RaceRally/AskClaimMilestone", data.RepeatId)
				end
			end
		end
		if FarmConfig.Race_AutoBuy == true then
			local tokens = tonumber(save.Tokens) or 0
			for _, item in ipairs(raceShop) do
				if race.Disposed then
					return
				end
				local definition = data.Shop and data.Shop[item.Id]
				local picked = FarmConfig.Race_ShopItems or {}
				if picked[string.lower(item.Name)] and definition and tokens >= definition.Price then
					local purchase = type(save.Purchases) == "table" and save.Purchases[item.Id]
					local count = purchase and tonumber(purchase.Count) or 0
					if definition.Limit == 0 or count < definition.Limit then
						local ok, accepted = InvokeRace("RF/RaceRally/AskBuy", item.Id)
						if ok and accepted then
							tokens -= definition.Price
						end
					end
				end
			end
		end
	end
	local function PublishRaceStatus()
		race.EffectiveSpeed = CurrentRaceSpeed()
		if LocalPlayer:GetAttribute("RaceId") == nil then
			race.Heat, race.Phase = LocalPlayer:GetAttribute("RaceHeat"), race.Lined and "Queued" or "Idle"
		end
		local now, joinEnds = Workspace:GetServerTimeNow(), Workspace:GetAttribute("RaceRallyJoinEndsAt")
		local function duration(seconds)
			seconds = math.max(math.ceil(seconds), 0)
			return string.format("%d:%02d", seconds // 60, seconds % 60)
		end
		local scheduleText
		if RaceJoinOpen() then
			scheduleText = "Racing Event open, " .. duration(joinEnds - now) .. " to join"
		else
			local schedule = LoadRaceModule({ "Shared", "Util", "RaceRallySchedule" })
			local ok, nextOpening = false, nil
			if schedule and type(schedule.NextOpening) == "function" then
				ok, nextOpening = pcall(schedule.NextOpening, now)
			end
			if not ok or type(nextOpening) ~= "number" then
				nextOpening = (math.floor(now / 1800) + 1) * 1800
			end
			scheduleText = (
				Workspace:GetAttribute("RaceRallyRunning") == true and "Racing Event running, next in "
				or "Next Racing Event in "
			) .. duration(nextOpening - now)
		end
		if LocalPlayer:GetAttribute("RaceId") ~= nil then
			race.Status = race.Action
		elseif FarmConfig.Race_AutoRace ~= true then
			race.Status = "Off  |  " .. scheduleText
		elseif race.Action ~= "Off" and race.Action ~= "" then
			race.Status = race.Action .. "  |  " .. scheduleText
		else
			race.Status = scheduleText
		end
		local save, data = ReadRaceSave(), RaceData()
		if save then
			race.Tokens, race.Wins = tostring(save.Tokens or 0), tostring(save.Wins or 0)
			local equipped = tostring(save.EquippedRacer or "")
			local definition = data and data.Racers and data.Racers[equipped ~= "" and equipped or data.DefaultRacer]
			race.Racer = definition and definition.DisplayName or "Ostrich"
		end
	end
	local function TickRaceRally()
		UpdateRaceStealPause()
		if
			race.StealPaused
			and engine
			and (engine.AutoCycle or RuntimeState.IsExecuting or engine.Guard.Active or engine.Guard.Busy)
		then
			SetRaceAction("Race priority, waiting for the current worker to release movement")
			return
		end
		if race.Resetting then
			StopRaceDrive()
			return
		end
		if Tasks.RaceSuppressRagdoll() and Tasks.ResumeRaceRigSync then
			Tasks.ResumeRaceRigSync()
		end
		local enabled = FarmConfig.Race_AutoRace == true
		race.InRace = InRaceNow()
		local raceId = LocalPlayer:GetAttribute("RaceId")
		race.Lined = race.InRace and raceId == nil
		race.Wanted = enabled and (race.InRace or (RaceJoinOpen() and not RacedThisWindow() and RaceEligible()))
		if raceId ~= nil then
			race.RacedWindow = Workspace:GetAttribute("RaceRallyJoinEndsAt")
			if not race.WasRacing then
				race.WasRacing, race.FinishedRace, race.FinishedAt = true, false, nil
			end
			local data = RaceData()
			if tostring(raceId) ~= tostring(data and data.Track or "RaceTrack") then
				StopRaceDrive()
				SetRaceAction("In another race, Auto Race does not move you")
				return
			end
			if enabled and engine then
				if engine.AutoCycle then
					engine.CancelAutoSteal()
					SetRaceAction("In the race, waiting for the steal worker to release movement")
					return
				end
				if RuntimeState.IsExecuting then
					SetRaceAction("In the race, waiting for the current task to stop")
					return
				end
				engine.Movement.Owner = "race"
				PrepareRaceCharacter()
			end
			local track = GetRaceTrack()
			local heatName = LocalPlayer:GetAttribute("RaceHeat")
			local heats = track and track:FindFirstChild("RaceHeats")
			local heat = (type(heatName) == "string" and heats and heats:FindFirstChild(heatName)) or track
			race.Heat = heatName
			local phase, goAt = heat and heat:GetAttribute("RacePhase"), heat and heat:GetAttribute("RaceGoAt")
			race.Phase = phase
			local finishPlace = LocalPlayer:GetAttribute("RaceFinishPlace")
			local finished = type(finishPlace) == "number"
			if not finished and enabled and NudgeRaceMount() then
				-- Chili keeps an existing drive alive while the mount recovery runs.
				SetRaceAction(
					string.format("Not on the racer yet, moving and jumping to get back on (%d/3)", race.NudgeCount)
				)
				return
			end
			if finished then
				StopRaceDrive()
				race.FinishedRace, race.FinishedAt = true, race.FinishedAt or os.clock()
				if enabled and os.clock() - race.FinishedAt > 8 and RequestRaceReset("Could not leave the race") then
					return
				end
				if os.clock() >= (race.LeaveAt or 0) then
					LeaveRace("Finished " .. finishPlace .. ", leaving the race")
				else
					SetRaceAction("Finished " .. finishPlace .. ", waiting for results")
				end
				return
			end
			if phase == "Racing" and type(goAt) == "number" and Workspace:GetServerTimeNow() >= goAt then
				local lap = LocalPlayer:GetAttribute("RaceLap")
				if race.Driving and race.Driving.Character ~= LocalPlayer.Character then
					StopRaceDrive()
				end
				if lap ~= race.LapSeen then
					race.LapSeen, race.LapAt = lap, os.clock()
				end
				if
					enabled
					and race.Driving
					and os.clock() - (race.LapAt or os.clock())
						> race.Driving.Path.Length / CurrentRaceSpeed() * 1.5 + 8
				then
					race.LapAt = os.clock()
					StopRaceDrive()
					ReduceRaceSpeed("Lap did not count")
				end
				if enabled and not race.Driving then
					if not StartRaceDrive(track) then
						return
					end
				elseif not enabled then
					StopRaceDrive()
				end
				SetRaceAction(
					string.format(
						"Racing, lap %s/%s, place %s",
						tostring(lap or "?"),
						tostring(heat:GetAttribute("RaceLaps") or track:GetAttribute("RaceLaps") or 3),
						tostring(LocalPlayer:GetAttribute("RacePlace") or "?")
					)
				)
			else
				StopRaceDrive()
				local higher = enabled and HigherPriorityRaceTask()
				if higher then
					LeaveRace("Leaving the race, " .. higher .. " goes first (Task Priority)")
				else
					SetRaceAction("In the race, waiting for the start")
				end
			end
			return
		end
		if race.WasRacing then
			race.WasRacing, race.EndedAt = false, os.clock()
		end
		if race.EndedAt and os.clock() - race.EndedAt >= 1.5 then
			race.EndedAt = nil
			if enabled and not race.FinishedRace and RequestRaceReset("The server did not count the race") then
				return
			end
		end
		if race.Lined then
			StopRaceDrive()
			if enabled and engine and not engine.AutoCycle and not RuntimeState.IsExecuting then
				engine.Movement.Owner = "race"
				PrepareRaceCharacter()
			end
			SetRaceAction(
				RacedThisWindow() and "Race done, waiting for the game to close the heat"
					or RaceJoinOpen() and "In the race area, waiting for the race to start"
					or "In the race area, waiting for the race to place you"
			)
			return
		end
		StopRaceDrive()
		race.LapSeen, race.LapAt, race.Drop = nil, nil, 0
		if not race.Travelling then
			ReleaseRaceMovement()
		end
		local joinEnds = Workspace:GetAttribute("RaceRallyJoinEndsAt")
		local alreadyRaced = RacedThisWindow()
		if enabled and race.ReturnFailed and not race.Travelling then
			race.ReturnFailed = nil
			if RequestRaceReset("Could not get back from the race") then
				return
			end
		end
		if enabled and alreadyRaced and not race.Travelling and InRaceArea() and ClaimRaceMovement() then
			SetRaceAction("Raced this window, going home")
			StartRaceTravel(ReturnFromRace)
			return
		end
		local eligible, requirement = RaceEligible()
		local higher = enabled and RaceJoinOpen() and not race.Travelling and HigherPriorityRaceTask() or nil
		if enabled and RaceJoinOpen() and not eligible then
			SetRaceAction(
				requirement and string.format("Racing Event needs %.1fM Speed Power to join", requirement / 1000000)
					or "Racing Event needs more Speed Power to join"
			)
		elseif enabled and RaceJoinOpen() and alreadyRaced then
			SetRaceAction("Raced this window, waiting for the next Racing Event")
		elseif higher then
			SetRaceAction("Race open, " .. higher .. " goes first (Task Priority)")
		elseif enabled and RaceJoinOpen() then
			local hitbox, root = GetRacePortal(), RaceRoot()
			if hitbox and root and race.Travelling then
				-- The travel worker publishes the exact source recovery stage.
			elseif hitbox and root and (root.Position - hitbox.Position).Magnitude > 80 then
				if ClaimRaceMovement() then
					SetRaceAction("Flying to the race portal")
					StartRaceTravel(function(cancelled)
						TravelToRacePortal(hitbox, cancelled)
					end)
					return
				end
			elseif hitbox and root and os.clock() - race.JoinTriedAt >= RaceJoinDelay() and ClaimRaceMovement() then
				race.JoinTriedAt, race.JoinTries = os.clock(), (race.JoinTries or 0) + 1
				ExitRaceTreadmill()
				if EnteredRace() then
					return
				end
				race.NearSince = race.NearSince or os.clock()
				if os.clock() - race.NearSince < math.max(10, RaceJoinDelay() * 4) then
					SetRaceAction(
						"Joining the race" .. (race.JoinTries > 1 and " (try " .. race.JoinTries .. ")" or "")
					)
					root = RaceRoot()
					if root and hitbox.Parent then
						root.CFrame, root.AssemblyLinearVelocity = hitbox.CFrame, Vector3.zero
						if type(firetouchinterest) == "function" then
							pcall(firetouchinterest, root, hitbox, 0)
							pcall(firetouchinterest, root, hitbox, 1)
						end
					end
					return
				end
				local remaining = type(joinEnds) == "number" and joinEnds - Workspace:GetServerTimeNow() or 0
				if race.PassWindow ~= joinEnds then
					race.PassWindow, race.PassRounds = joinEnds, 0
				end
				if
					race.PassRounds >= 1
					and race.PortalResetWindow ~= joinEnds
					and remaining > 12 + RaceJoinDelay() * 2
				then
					race.PortalResetWindow = joinEnds
					SetRaceAction("Still not in, resetting and stepping to the portal again")
					StartRaceTravel(function(cancelled)
						RetryRacePortalAfterReset(hitbox, cancelled)
						race.NearSince = nil
					end)
				else
					SetRaceAction("Not in yet, backing off and going in again")
					StartRaceTravel(function(cancelled)
						PassThroughRacePortal(hitbox, function()
							return cancelled()
								or not RaceJoinOpen()
								or EnteredRace()
								or RacedThisWindow()
								or HigherPriorityRaceTask() ~= nil
						end)
						race.PassRounds = (race.PassRounds or 0) + 1
					end)
				end
				return
			elseif not hitbox then
				SetRaceAction("Race open, portal not found")
			end
		else
			SetRaceAction("Off")
		end
		if not RaceJoinOpen() then
			race.JoinTries, race.NearSince, race.WaitSince = 0, nil, nil
		end
		local save, data = ReadRaceSave(), RaceData()
		if save and data then
			UpdateOwnedRaceRacers(save, data)
			if not race.Disposed then
				ClaimAndBuyRaceRewards(save, data)
			end
		end
	end
	Tasks.RaceSettingsChanged = function(setting)
		if setting == "Speed" then
			race.Drop = 0
		end
		if setting == "Racer" then
			race.EquipAt, race.OwnedKey = 0, nil
		end
		if setting == "Enabled" then
			race.CancelVersion = (race.CancelVersion or 0) + 1
			if FarmConfig.Race_AutoRace ~= true then
				StopRaceDrive()
				if not race.Travelling then
					ReleaseRaceMovement()
				end
			end
			UpdateRaceStealPause()
		end
		race.NextTick = 0
	end
	-- Keep the working Sena lifecycle intact. Only arbitrate shared movement/rig ownership.
	if engine then
		local nativeShieldWanted, nativeClaimMovement, nativeGuardDodge =
			engine.AutoShieldWanted, engine.ClaimMovement, engine.TriggerGuardDodge
		engine.AutoShieldWanted = function()
			return not Tasks.RaceHoldsCharacter() and nativeShieldWanted()
		end
		engine.ClaimMovement = function(owner)
			if owner ~= "race" and (Tasks.RaceHoldsCharacter() or Tasks.RaceShouldYieldSteal()) then
				return false
			end
			return nativeClaimMovement(owner)
		end
		engine.TriggerGuardDodge = function(force)
			if Tasks.RaceShouldYieldSteal() then
				return
			end
			return nativeGuardDodge(force)
		end
		race.RestoreEngineAdapters = function()
			engine.AutoShieldWanted, engine.ClaimMovement, engine.TriggerGuardDodge =
				nativeShieldWanted, nativeClaimMovement, nativeGuardDodge
		end
	end
	for _, attribute in ipairs({ "RaceId", "RaceHeat", "RaceGridFrame", "RaceRallyQueued", "RaceFinishPlace" }) do
		table.insert(
			race.Connections,
			LocalPlayer:GetAttributeChangedSignal(attribute):Connect(function()
				if attribute == "RaceFinishPlace" and type(LocalPlayer:GetAttribute(attribute)) == "number" then
					race.FinishedRace = true
				end
				if attribute == "RaceId" and LocalPlayer:GetAttribute(attribute) == nil then
					race.RagdollResumeAt = os.clock() + 20
				end
				race.NextTick = 0
			end)
		)
	end
	table.insert(
		race.Connections,
		LocalPlayer.CharacterAdded:Connect(function()
			StopRaceDrive()
			race.PreparedCharacter, race.BoundsTrack, race.NextTick = nil, nil, 0
		end)
	)
	local function DisposeRaceRally()
		race.Disposed = true
		race.CancelVersion = (race.CancelVersion or 0) + 1
		StopRaceDrive()
		for _, connection in ipairs(race.Connections) do
			connection:Disconnect()
		end
		-- An in-flight travel retains ownership until it observes cancellation and unwinds.
		if not race.Travelling then
			ReleaseRaceMovement()
		end
		if race.RestoreEngineAdapters then
			race.RestoreEngineAdapters()
		end
		Tasks.PriorityStealYield = nativePriorityStealYield
		if Tasks.ResumeRaceRigSync then
			Tasks.ResumeRaceRigSync()
		end
	end
	LibraryLoader:OnUnload(DisposeRaceRally)
	task.spawn(function()
		while not race.Disposed do
			if os.clock() >= (race.NextTick or 0) then
				race.NextTick = os.clock() + 0.25
				local ok, failure = pcall(TickRaceRally)
				if not ok then
					StopRaceDrive()
					race.LastError = tostring(failure)
					SetRaceAction("Race error: " .. tostring(failure))
					if os.clock() >= race.ErrorAt then
						race.ErrorAt = os.clock() + 5
						warn("[N3 HUB] Race Rally: " .. tostring(failure))
					end
					if not race.Travelling and not InRaceNow() then
						ReleaseRaceMovement()
					end
				end
				if not race.Disposed then
					pcall(PublishRaceStatus)
				end
			end
			task.wait(0.05)
		end
	end)
end
LocalPlayer.CharacterAdded:Connect(Tasks.OnCharacterAdded)
Tasks.Loading:SetMessage("Load All Requirements")
Tasks.Loading:SetCurrentStep(4)
Tasks.Loading:SetDescription("Building the window, tabs & all N3 Hub features...")
-- BEGIN AUTO MUTATE CONTROLLER
-- Chili 53868-54810: equipped consumable + placed owned UID, no mutation argument.
do
	local engine = RuntimeState.StealEngine
	local state = { Generation = 0, Busy = false, Lease = false, Wanted = false, Disposed = false,
		NextAt = 0, SettleUntil = 0, Refused = {}, Awaiting = {}, Failures = 0, Status = "Off",
		EggOptions = {}, Categories = {}, NoticeAt = 0, InventoryActions = 0, HatchSettleUntil = 0 }
	Tasks.MutateState = state
	local mutationIds = { fractured = "Boss", boss = "Boss", scrambled = "Scrambled", enchanted = "Enchanted", nitro = "Nitro" }
	local mutationOrder = { "Boss", "Scrambled", "Enchanted", "Nitro" }
	FarmConfig.Mutate_Auto = false
	FarmConfig.Mutate_Use = { Boss = true, Scrambled = true, Enchanted = true, Nitro = true }
	FarmConfig.Mutate_MinRarity = 1
	FarmConfig.Mutate_MinIncome = 0
	FarmConfig.Mutate_Targets = {}
	FarmConfig.Mutate_Priority = "Highest Value"
	FarmConfig.Mutate_Delay = 1
	for category, asset in pairs((AssetsModule and AssetsModule.Directory) or {}) do
		if type(asset) == "table" and type(asset.Rarity) == "table" then
			local label = tostring(asset.DisplayName or category)
			if state.Categories[string.lower(label)] then label ..= " [" .. tostring(category) .. "]" end
			state.Categories[string.lower(label)] = tostring(category)
			table.insert(state.EggOptions, label)
		end
	end
	table.sort(state.EggOptions)
	local function canonical(value)
		return mutationIds[string.lower(tostring(value or "")):match("^%s*(.-)%s*$")]
	end
	local function mutations(record)
		local result = {}
		local function add(value)
			local id = canonical(value)
			if id then result[id] = true end
		end
		add(record.BaseMutation)
		add(record.Mutation)
		if type(record.Mutations) == "table" then
			for key, value in pairs(record.Mutations) do
				if type(value) == "table" then add(value.Id or value.Name or value.Label)
				elseif type(value) == "boolean" or type(value) == "number" then
					if value ~= false and value ~= 0 then add(key) end
				else add(value) end
			end
		elseif type(record.Mutations) == "string" then
			for value in record.Mutations:gmatch("[^,]+") do add(value) end
		end
		return result
	end
	local function tools()
		local result = {}
		for _, container in pairs({ LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }) do
			for _, tool in ipairs(container:GetChildren()) do
				if tool:IsA("Tool") and tool:GetAttribute("ItemType") == "MutationConsumable" then
					local id = canonical(tool:GetAttribute("MutationId") or tool:GetAttribute("MutationTemplate") or "Boss")
					local uses = tonumber(tool:GetAttribute("Uses")) or tonumber(tool.Name:match("%[[Xx](%d+)%]")) or 1
					if id and uses > 0 and not result[id] then result[id] = tool end
				end
			end
		end
		return result
	end
	local function ownedEggs()
		SetElevated8()
		if not EggStateModule or type(EggStateModule.ReadOwnerEggs) ~= "function" then return nil end
		local ok, result = pcall(EggStateModule.ReadOwnerEggs, LocalPlayer.UserId)
		return ok and type(result) == "table" and result or nil
	end
	local function eggPosition(uid)
		local folder = Workspace:FindFirstChild("AreaEggSlotsClient")
		local model = folder and folder:FindFirstChild(tostring(uid))
		if not model or not (model:IsA("Model") or model:IsA("BasePart")) then return nil end
		local ok, pivot = pcall(model.GetPivot, model)
		return ok and typeof(pivot) == "CFrame" and pivot.Position or nil
	end
	local function eligible(record, uid, bag)
		if type(record) ~= "table" or record.Placement == nil then return nil end
		local category = tostring(record.AssetCategory or record.Category or "")
		if next(FarmConfig.Mutate_Targets) ~= nil and not FarmConfig.Mutate_Targets[category] then return nil end
		local asset = AssetsModule and AssetsModule.Directory and AssetsModule.Directory[category]
		local rarity = type(asset) == "table" and asset.Rarity
		local tier = type(rarity) == "table" and tonumber(rarity.RarityNumber or rarity.Rank)
		if not tier or tier < FarmConfig.Mutate_MinRarity then return nil end
		local income = CalculateEggIncome(record)
		if income ~= income or income < FarmConfig.Mutate_MinIncome or income >= math.huge then return nil end
		local existing, now = mutations(record), os.clock()
		for _, id in ipairs(mutationOrder) do
			local key = tostring(uid) .. ":" .. id
			if FarmConfig.Mutate_Use[id] and bag[id] and not existing[id]
				and (state.Refused[key] or 0) <= now and (state.Awaiting[key] or 0) <= now then
				local position = eggPosition(uid)
				if position then return { Uid = uid, Mutation = id, Tool = bag[id], Position = position,
					Tier = tier, Income = income, Scale = tonumber(record.AssetScale) or 0 } end
			end
		end
		return nil
	end
	local function pick()
		local records, bag, best = ownedEggs(), tools(), nil
		if not records then return nil end
		for key, record in pairs(records) do
			local uid = type(record) == "table" and (record.Uid or key) or key
			local candidate = eligible(record, uid, bag)
			if candidate then
				local priority = FarmConfig.Mutate_Priority
				local score = priority == "Best Rarity" and candidate.Tier * 1000 + candidate.Scale
					or priority == "Biggest Size" and candidate.Scale or candidate.Income
				if not best or score > best.Score or (score == best.Score and tostring(uid) < tostring(best.Uid)) then
					candidate.Score, best = score, candidate
				end
			end
		end
		return best
	end
	local function fresh(job)
		local records, bag = ownedEggs(), tools()
		for key, record in pairs(records or {}) do
			local uid = type(record) == "table" and (record.Uid or key) or key
			if tostring(uid) == tostring(job.Uid) then
				local candidate = eligible(record, uid, bag)
				if candidate and candidate.Mutation == job.Mutation and candidate.Tool == job.Tool then return candidate end
				return nil
			end
		end
		return nil
	end
	local function raceWanted()
		return RaceOwnsCharacter() or (Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal()) == true
	end
	local function carrying()
		local carry = engine and engine.State
		return (carry and (carry.Carrying or carry.SignalCarrying or carry.WeldCarrying))
			or (engine and engine.AutoCarry and engine.AutoCarry.Carrying)
			or IsActivelyCarryingEgg() or GetEquippedEggTool() ~= nil
	end
	local function busy()
		return not engine or RuntimeState.IsExecuting or engine.AutoCycle
			or state.InventoryActions > 0 or os.clock() < state.HatchSettleUntil
			or engine.Guard.Active or engine.Guard.Busy or carrying()
			or Tasks.TreadmillState.Busy or Tasks.TreadmillState.WearBusy or Tasks.TreadmillState.Exiting
			or LocalPlayer:GetAttribute("InScrambleArena") == true
	end
	local function higherTask()
		if raceWanted() then return true end -- Race always goes first, even if Essence is ranked above it.
		local rank = Tasks.PriorityRank("Essence")
		if engine.Movement.PlaceWanted and Tasks.PriorityRank("Place") < rank then return true end
		if FarmConfig.AutoTreadmill and Tasks.PriorityRank("Treadmill") < rank then return true end
		if os.clock() >= (state.ScanAt or 0) then
			state.ScanAt, state.FarmFirst = os.clock() + 0.75, false
			local ok, candidates = pcall(engine.CollectCandidates, false, not FarmConfig.Defense_InstantSteal)
			if not ok then state.FarmFirst = true; return true end
			if FarmConfig.AutoStealAll or FarmConfig.AutoStealSelected or FarmConfig.AutoScrambleSteal or FarmConfig.Index_PrioritizeMissing then
				for _, candidate in ipairs(candidates or {}) do
					local key = candidate.IsScramble and "StealLab" or candidate.IsIndex and "StealIndex" or "StealFilter"
					if Tasks.PriorityRank(key) < rank then state.FarmFirst = true; break end
				end
			end
		end
		return state.FarmFirst == true
	end
	function Tasks.MutateSettingsChanged()
		state.Generation += 1
		state.Wanted = false
		state.SettleUntil = os.clock() + 3
		state.ScanAt = 0
	end
	local function run(job)
		if busy() or higherTask() or not FarmConfig.Mutate_Auto or state.Disposed then return end
		local owner = engine.Movement.Owner
		if owner ~= nil and owner ~= "treadmill" then return end
		if not engine.ClaimMovement("essence") then return end
		state.Lease, state.Busy, state.Wanted = true, true, true
		engine.Movement.EssenceWanted = true
		local generation, character = state.Generation, LocalPlayer.Character
		local previousTool = character and character:FindFirstChildWhichIsA("Tool")
		local humanoid, root
		local function cancelled()
			return state.Disposed or LibraryLoader.Unloaded or generation ~= state.Generation or not FarmConfig.Mutate_Auto
				or LocalPlayer.Character ~= character or engine.Movement.Owner ~= "essence" or raceWanted()
				or (humanoid and (humanoid.Parent ~= character or humanoid.Health <= 0))
				or (root and (root.Parent ~= character or character:FindFirstChild("HumanoidRootPart") ~= root))
				or (character and character:GetAttribute("InvisApplied") == true)
		end
		local ok, failure = pcall(function()
			SetElevated8()
			Tasks.ExitTreadmill()
			if cancelled() then return end
			-- Reuse N3's own rig restoration; never import another swap or change defense toggles.
			if engine.ReleaseAutoShield then engine.ReleaseAutoShield(true) end
			if RuntimeState.OriginalHumanoid then RestoreCharacter() end
			if cancelled() then return end
			humanoid = character and character:FindFirstChildOfClass("Humanoid")
			root = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root then return end
			local candidate = fresh(job)
			if not candidate or cancelled() then return end
			-- Finite native MoveTo, not the steal-only FlyToPosition or a second fly/swap controller.
			local deadline = os.clock() + 12
			while (root.Position - candidate.Position).Magnitude > 6 do
				if cancelled() or higherTask() or os.clock() >= deadline then return end
				humanoid:MoveTo(candidate.Position)
				task.wait(0.1)
				local position = eggPosition(job.Uid)
				if not position then return end
				candidate.Position = position
			end
			if cancelled() or higherTask() then return end
			humanoid:MoveTo(root.Position)
			candidate = fresh(job)
			if not candidate or cancelled() then return end
			if job.Tool.Parent ~= character then humanoid:EquipTool(job.Tool); task.wait(0.3) end
			if cancelled() or job.Tool.Parent ~= character then return end
			candidate = fresh(job)
			if not candidate or cancelled() or higherTask() or (root.Position - candidate.Position).Magnitude > 6 then return end
			local remote = FindRemote("RF/BossMastery/AskUseMutationConsumable")
			if not remote or not remote:IsA("RemoteFunction") then
				state.NextAt = os.clock() + 10
				if os.clock() >= state.NoticeAt then
					state.NoticeAt = os.clock() + 30
					LibraryLoader:Notify("Mutation remote unavailable", 4)
				end
				return
			end
			if cancelled() then return end
			state.Status = "Applying"
			local answered, reply = pcall(remote.InvokeServer, remote, job.Uid)
			if cancelled() then return end -- A sent consumable RPC cannot be recalled.
			local key = tostring(job.Uid) .. ":" .. job.Mutation
			if not answered or type(reply) ~= "table" then
				state.Status, state.NextAt = "No server answer", os.clock() + 10
			elseif reply.Success == true then
				state.Failures = 0
				if reply.Mutated == true then
					state.Status, state.Awaiting[key] = "Applied", os.clock() + 3
				elseif reply.Mutated == false then state.Status = "Roll failed"
				else state.Status, state.NextAt = "Unknown result", os.clock() + 10 end
			else
				state.Status = tostring(reply.Message or "Refused")
				state.Refused[key] = os.clock() + 120
				state.Failures += 1
				if state.Failures >= 3 then state.Failures, state.NextAt = 0, os.clock() + 15 end
			end
		end)
		-- Touch tools/locomotion only if this job still owns this same character.
		pcall(function()
			if engine.Movement.Owner == "essence" and LocalPlayer.Character == character and not RaceOwnsCharacter() then
				if humanoid and humanoid.Parent == character and root and root.Parent == character then
					humanoid:MoveTo(root.Position)
					if not raceWanted() and character:FindFirstChildWhichIsA("Tool") == job.Tool then
						if previousTool and previousTool ~= job.Tool
							and (previousTool.Parent == character or previousTool.Parent == LocalPlayer:FindFirstChildOfClass("Backpack")) then
							humanoid:EquipTool(previousTool)
						elseif previousTool ~= job.Tool then humanoid:UnequipTools() end
					end
				end
			end
		end)
		engine.Movement.EssenceWanted = false
		engine.ReleaseMovement("essence")
		state.Lease, state.Busy, state.Wanted = false, false, false
		state.NextAt = math.max(state.NextAt, os.clock() + FarmConfig.Mutate_Delay)
		if engine.AutoWake then engine.AutoWake() end
		if not ok then state.Status, state.LastError, state.NextAt = "Stopped", tostring(failure), os.clock() + 3 end
	end
	-- Layer adapters after Race so the live-confirmed race body remains byte-identical.
	local nativeYield, nativeCanRun = Tasks.PriorityStealYield, Tasks.PriorityCanRun
	local nativeShield, nativeDodge = engine.AutoShieldWanted, engine.TriggerGuardDodge
	local nativeDeposit, nativeHatch = Tasks.ExecuteDepositEggs, ExecuteAutoHatch
	local yieldAdapter, canRunAdapter, shieldAdapter, dodgeAdapter, depositAdapter, hatchAdapter
	yieldAdapter = function() return state.Lease or nativeYield() end
	canRunAdapter = function(key)
		if key == "Essence" then return not state.Disposed and FarmConfig.Mutate_Auto and state.Lease end
		return nativeCanRun(key)
	end
	shieldAdapter = function() return not state.Lease and nativeShield() end
	dodgeAdapter = function(...)
		if state.Lease then return end
		return nativeDodge(...)
	end
	local function inventoryAction(action, hatch, ...)
		if state.Lease then return 0 end
		state.InventoryActions += 1
		local reply = table.pack(pcall(action, ...))
		state.InventoryActions -= 1
		if not reply[1] then error(reply[2], 0) end
		-- Native Hatch dispatches asynchronous finish calls; allow their normal delay.
		-- A server call already in flight is still not cancellable or an atomic transaction.
		if hatch and type(reply[2]) == "number" and reply[2] > 0 then state.HatchSettleUntil = os.clock() + 1.5 end
		return table.unpack(reply, 2, reply.n)
	end
	depositAdapter = function(...) return inventoryAction(nativeDeposit, false, ...) end
	hatchAdapter = function(...) return inventoryAction(nativeHatch, true, ...) end
	Tasks.PriorityStealYield, Tasks.PriorityCanRun = yieldAdapter, canRunAdapter
	engine.AutoShieldWanted, engine.TriggerGuardDodge = shieldAdapter, dodgeAdapter
	Tasks.ExecuteDepositEggs, ExecuteAutoHatch = depositAdapter, hatchAdapter
	function Tasks.BuildAutoMutateUI(group)
		group:AddToggle("Toggle_Mutate_Auto", { Text = "Auto Mutate", Default = false, Tooltip = "Placed eggs only.", Callback = function(value)
			FarmConfig.Mutate_Auto = value == true
			Tasks.MutateSettingsChanged()
		end })
		-- BEGIN NITRO REFILL UI
		Tasks.BuildNitroRefillUI(group)
		-- END NITRO REFILL UI
		group:AddDropdown("Dropdown_Mutate_Use", { Text = "Mutations", Values = { "Fractured", "Scrambled", "Enchanted", "Nitro" },
			Multi = true, AllowNull = true, Default = { "Fractured", "Scrambled", "Enchanted", "Nitro" }, Callback = function(value)
				local selected = {}
				for label in pairs(ParseMultiDropdownSelection(value)) do
					local id = canonical(label)
					if id then selected[id] = true end
				end
				FarmConfig.Mutate_Use = selected
				Tasks.MutateSettingsChanged()
			end })
		group:AddDropdown("Dropdown_Mutate_MinRarity", { Text = "Min Rarity", Values = RarityNumberedList, Default = RarityNumberedList[1], AllowNull = false,
			Callback = function(value)
				FarmConfig.Mutate_MinRarity = tonumber(tostring(value):match("^(%d+)")) or 1
				Tasks.MutateSettingsChanged()
			end })
		group:AddInput("Input_Mutate_MinIncome", { Text = "Income Above", Default = "0", Numeric = true, Finished = true, Tooltip = "$/s. 0 = off.",
			Callback = function(value)
				local number = tonumber(value) or 0
				FarmConfig.Mutate_MinIncome = number == number and number < math.huge and math.max(0, number) or 0
				Tasks.MutateSettingsChanged()
			end })
		group:AddDropdown("Dropdown_Mutate_Targets", { Text = "Target Eggs", Values = state.EggOptions, Multi = true, AllowNull = true, Default = {}, Searchable = true,
			Tooltip = "Empty = all placed eggs.", Callback = function(value)
				local selected = {}
				for label in pairs(ParseMultiDropdownSelection(value)) do
					local category = state.Categories[label]
					if category then selected[category] = true end
				end
				FarmConfig.Mutate_Targets = selected
				Tasks.MutateSettingsChanged()
			end })
		group:AddDropdown("Dropdown_Mutate_Priority", { Text = "Priority", Values = { "Highest Value", "Best Rarity", "Biggest Size" },
			Default = "Highest Value", AllowNull = false, Callback = function(value)
				FarmConfig.Mutate_Priority = value
				Tasks.MutateSettingsChanged()
			end })
		group:AddSlider("Slider_Mutate_Delay", { Text = "Delay", Min = 1, Max = 10, Default = 1, Rounding = 0, Callback = function(value)
			FarmConfig.Mutate_Delay = math.clamp(tonumber(value) or 1, 1, 10)
			Tasks.MutateSettingsChanged()
		end })
		if state.Started then return end
		state.Started = true
		task.spawn(function()
			while not state.Disposed and not LibraryLoader.Unloaded do
				-- BEGIN NITRO REFILL TICK
				pcall(Tasks.TickNitroRefill)
				-- END NITRO REFILL TICK
				if FarmConfig.Mutate_Auto and os.clock() >= math.max(state.NextAt, state.SettleUntil) then
					local ok, failure = pcall(function()
						for key, untilAt in pairs(state.Refused) do if untilAt <= os.clock() then state.Refused[key] = nil end end
						for key, untilAt in pairs(state.Awaiting) do if untilAt <= os.clock() then state.Awaiting[key] = nil end end
						if busy() or higherTask() then state.Wanted = false; return end
						local job = pick()
						state.Wanted = job ~= nil
						if job then run(job) end
					end)
					if not ok then state.Wanted, state.LastError, state.NextAt = false, tostring(failure), os.clock() + 3 end
				end
				task.wait(0.5)
			end
		end)
	end
	LibraryLoader:OnUnload(function()
		state.Disposed, state.Wanted = true, false
		state.Generation += 1
		-- Keep an in-flight job's lease until its own cleanup; never clear shared IsExecuting.
		if not state.Busy then engine.ReleaseMovement("essence") end
		if Tasks.PriorityStealYield == yieldAdapter then Tasks.PriorityStealYield = nativeYield end
		if Tasks.PriorityCanRun == canRunAdapter then Tasks.PriorityCanRun = nativeCanRun end
		if engine.AutoShieldWanted == shieldAdapter then engine.AutoShieldWanted = nativeShield end
		if engine.TriggerGuardDodge == dodgeAdapter then engine.TriggerGuardDodge = nativeDodge end
		if Tasks.ExecuteDepositEggs == depositAdapter then Tasks.ExecuteDepositEggs = nativeDeposit end
		if ExecuteAutoHatch == hatchAdapter then ExecuteAutoHatch = nativeHatch end
	end)
end
-- END AUTO MUTATE CONTROLLER

-- BEGIN NITRO REFILL CONTROLLER
-- Chili 54473-54536: no Nitro tool, affordable MutationToken, wait for tool grant.
-- One shared purchase lane for the existing race shop and the optional refill.
do
	local shop = { Busy = false, Disposed = false, Generation = 0, NextAt = {}, PendingNitro = false }
	Tasks.RaceShopState = shop
	FarmConfig.Mutate_BuyNitro = false
	local function hasNitro()
		for _, container in pairs({ LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }) do
			for _, tool in ipairs(container:GetChildren()) do
				if tool:IsA("Tool") and tool:GetAttribute("ItemType") == "MutationConsumable" then
					local id = tostring(tool:GetAttribute("MutationId") or tool:GetAttribute("MutationTemplate") or "Boss")
					local uses = tonumber(tool:GetAttribute("Uses")) or tonumber(tool.Name:match("%[[Xx](%d+)%]")) or 1
					if string.lower(id):match("^%s*(.-)%s*$") == "nitro" and uses > 0 then return true end
				end
			end
		end
		return false
	end
	local function refillEnabled()
		local mutate = Tasks.MutateState
		return not shop.Disposed and not LibraryLoader.Unloaded and FarmConfig.Mutate_BuyNitro == true
			and FarmConfig.Mutate_Auto == true and (FarmConfig.Mutate_Use or {}).Nitro == true
			and mutate ~= nil and not mutate.Disposed and os.clock() >= mutate.SettleUntil
	end
	local function dataAndSave(itemId)
		local dataFolder = ReplicatedStorage:FindFirstChild("Data")
		local module = dataFolder and dataFolder:FindFirstChild("RaceRally")
		if not module or not module:IsA("ModuleScript") then return nil end
		local data = require(module)
		local definition = type(data) == "table" and type(data.Shop) == "table" and data.Shop[itemId]
		local reader = SaveModule and (SaveModule.Get or SaveModule.Peek)
		local save = reader and reader()
		local raceSave = type(save) == "table" and save.RaceRally
		if type(definition) ~= "table" or type(raceSave) ~= "table" then return nil end
		local price, tokens, limit = tonumber(definition.Price), tonumber(raceSave.Tokens), tonumber(definition.Limit)
		if not price or price ~= price or price < 0 or price >= math.huge
			or not tokens or tokens ~= tokens or tokens < 0 or tokens >= math.huge
			or not limit or limit ~= limit or limit < 0 or limit >= math.huge then return nil end
		local purchase = type(raceSave.Purchases) == "table" and raceSave.Purchases[itemId]
		local count = type(purchase) == "table" and tonumber(purchase.Count) or 0
		if not count or count ~= count or count < 0 or count >= math.huge then return nil end
		if limit > 0 and count >= limit then return nil end
		return price, tokens
	end
	local function budget(tokens)
		if shop.Balance == nil then shop.Balance = tokens
		elseif tokens > shop.ObservedTokens then shop.Balance += tokens - shop.ObservedTokens end
		shop.Balance = math.min(shop.Balance, tokens)
		shop.ObservedTokens = tokens
		return shop.Balance
	end
	function Tasks.InvokeRaceShopPurchase(source, itemId)
		if shop.Disposed or LibraryLoader.Unloaded or shop.Busy or type(itemId) ~= "string"
			or os.clock() < (shop.NextAt[itemId] or 0) then return false, false end
		if source ~= "race" and source ~= "refill" then return false, false end
		shop.Busy = true -- Lock before require/save reads or any yielding operation.
		shop.NextAt[itemId] = os.clock() + 2
		local generation, mutateGeneration = shop.Generation, Tasks.MutateState and Tasks.MutateState.Generation
		local function cancelled()
			return shop.Disposed or LibraryLoader.Unloaded
				or (source == "race" and (not Tasks.RaceState or Tasks.RaceState.Disposed or not FarmConfig.Race_AutoBuy
					or not (FarmConfig.Race_ShopItems or {})[string.lower(shop.ItemNames and shop.ItemNames[itemId] or "")]))
				or (source == "refill" and (generation ~= shop.Generation or not refillEnabled()
					or not Tasks.MutateState or mutateGeneration ~= Tasks.MutateState.Generation))
		end
		local ok, result = pcall(function()
			SetElevated8()
			if source == "refill" and itemId ~= "MutationToken" then return table.pack(false, false) end
			local price, tokens = dataAndSave(itemId)
			if not price or cancelled() or budget(tokens) < price then return table.pack(false, false) end
			local outOfStockOnly = itemId == "MutationToken" and (source == "refill" or refillEnabled())
			local nitroOwned = hasNitro()
			if nitroOwned then shop.PendingNitro = false end
			if itemId == "MutationToken" and shop.PendingNitro then return table.pack(false, false) end
			if outOfStockOnly and nitroOwned then return table.pack(false, false) end
			local trackGrant = itemId == "MutationToken" and not nitroOwned
			local packages = ReplicatedStorage:FindFirstChild("Packages")
			local network = packages and packages:FindFirstChild("Networking")
			local remote = network and network:FindFirstChild("RF/RaceRally/AskBuy")
			if not remote or not remote:IsA("RemoteFunction") or cancelled() then return table.pack(false, false) end
			shop.Balance -= price -- Reserve locally until the authoritative save catches up.
			if trackGrant then shop.PendingNitro = true end
			local reply = table.pack(pcall(remote.InvokeServer, remote, itemId))
			-- Preserve the race caller's original pcall return shape; don't invent a purchase result.
			if reply[1] and reply[2] == false then
				shop.Balance = math.min(tokens, shop.Balance + price)
				if trackGrant then shop.PendingNitro = false end
			end
			if source == "refill" and outOfStockOnly and reply[1] and reply[2] then
				local deadline = os.clock() + 1.5
				while not cancelled() and os.clock() < deadline and not hasNitro() do task.wait(0.1) end
			end
			if hasNitro() then shop.PendingNitro = false end
			-- An unknown answer/late grant stays pending: no automatic duplicate Nitro purchase.
			return reply
		end)
		shop.Busy = false
		if not ok then shop.LastError = tostring(result); return false, false end
		return table.unpack(result, 1, result.n)
	end
	-- Same names as the existing race shop; never force its selection/preferences.
	shop.ItemNames = { MutationToken = "Nitro Mutation", CashBooster = "Cash Booster",
		SpeedBoost = "Speed Boost", TreadmillBoost = "Treadmill Boost", RacingBat = "Racing Bat" }
	function Tasks.TickNitroRefill()
		if shop.Disposed or LibraryLoader.Unloaded then return end
		if not shop.PendingNitro and not refillEnabled() then return end
		if hasNitro() then shop.PendingNitro = false; return end
		if not refillEnabled() or shop.PendingNitro or shop.Busy then return end
		Tasks.InvokeRaceShopPurchase("refill", "MutationToken")
	end
	function Tasks.BuildNitroRefillUI(group)
		group:AddToggle("Toggle_Mutate_BuyNitro", {
			Text = "Auto Buy Nitro", Default = false, Tooltip = "Refill with race tokens.",
			Callback = function(value)
				FarmConfig.Mutate_BuyNitro = value == true
				shop.Generation += 1
				Tasks.MutateSettingsChanged()
			end,
		})
	end
	LibraryLoader:OnUnload(function()
		shop.Disposed = true
		shop.Generation += 1
		-- Keep the lock and pending grant for an RPC already sent; it cannot be recalled.
	end)
end
-- END NITRO REFILL CONTROLLER

-- BEGIN QUEST TRANSIT CONTROLLER
-- Shared quest-only transport: Chili FlyTo 13798-13970 / Banjo flight 14990-15210.
-- Runs inside the existing Wisp/Banjo job and movement lease, never a second swap/worker.
do
	local engine = RuntimeState.StealEngine
	local active
	function Tasks.QuestTransitOwnsActor()
		return active ~= nil and active.Owns()
	end
	function Tasks.NewQuestTransit(owner, character, humanoid, root, valid)
		assert(owner == "wisp" or owner == "banjo", "Quest transport owner required")
		local transit = { Active = false }
		local heartbeat, stepped, parts, savedPlatform
		function transit.Owns()
			return LocalPlayer.Character == character and character ~= nil and humanoid ~= nil and root ~= nil
				and humanoid.Parent == character and character:FindFirstChildOfClass("Humanoid") == humanoid
				and humanoid.Health > 0 and root.Parent == character
				and character:FindFirstChild("HumanoidRootPart") == root
				and engine.Movement.Owner == owner and not RaceOwnsCharacter()
		end
		function transit:Stop()
			if heartbeat then heartbeat:Disconnect(); heartbeat = nil end
			if stepped then stepped:Disconnect(); stepped = nil end
			if self.Active and self.Owns() then
				engine.SetVelocity(root, Vector3.zero)
				humanoid.PlatformStand = savedPlatform
				for _, part in ipairs(parts or {}) do
					if part:IsDescendantOf(character) and not FarmConfig.Movement_Noclip then part.CanCollide = true end
				end
			end
			self.Active = false
			parts = nil
			if active == self then active = nil end
		end
		function transit:FlyTo(position, speed, cancel, arrived, mode, seconds, face, onLeg)
			if not self.Owns() or LibraryLoader.Unloaded or not valid() or (cancel and cancel()) then return false end
			if not self.Owns() or not valid() then return false end -- a priority read above may yield
			assert(active == nil, "A quest flight is already active")
			local points = typeof(position) == "Vector3" and { position } or position
			assert(type(points) == "table" and #points > 0, "Quest route is empty")
			local distance, previous = 0, root.Position
			for _, point in ipairs(points) do
				assert(typeof(point) == "Vector3", "Quest route point must be a Vector3")
				distance += (point - previous).Magnitude
				previous = point
			end
			local leg, result, elapsed, cursor = 1, nil, 0, root.Position
			position = points[leg]
			local budget = seconds or distance / math.max(speed, 1) + 3 * #points
			local ok, failure = pcall(function()
				savedPlatform, parts = humanoid.PlatformStand, {}
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then table.insert(parts, part) end
				end
				self.Active, active = true, self
				humanoid:Move(Vector3.zero, false)
				humanoid.PlatformStand = true
				humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
				stepped = RunService.Stepped:Connect(function()
					if not self.Active then return end
					if not self.Owns() or LibraryLoader.Unloaded or not valid() then self:Stop(); result = false; return end
					for _, part in ipairs(parts) do if part:IsDescendantOf(character) then part.CanCollide = false end end
				end)
				heartbeat = RunService.Heartbeat:Connect(function(dt)
					if result ~= nil then return end
					if not self.Owns() or LibraryLoader.Unloaded or not valid() then self:Stop(); result = false; return end
					elapsed += dt
					if arrived and arrived() then result = true; self:Stop(); return end
					if elapsed > budget then result = false; self:Stop(); return end
					humanoid.PlatformStand = true
					local delta = position - root.Position
					if delta.Magnitude <= 0.75 then
						engine.SetVelocity(root, Vector3.zero)
						if leg == #points then result = true; self:Stop(); return end
						-- Keep the same flight/collision scope between legs; never fall into the water here.
						leg += 1
						position, cursor = points[leg], root.Position
						if onLeg then onLeg(leg) end
						return
					end
					local facing = face and Vector3.new(face.X - root.Position.X, 0, face.Z - root.Position.Z) or Vector3.new(delta.X, 0, delta.Z)
					if mode == "tween" then
						-- Chili's FlyTo: small dt-scaled CFrame steps, not a destination PivotTo.
						if (root.Position - cursor).Magnitude > 6 then cursor = root.Position end
						local difference = position - cursor
						cursor += difference.Magnitude <= speed * dt and difference or difference.Unit * speed * dt
						root.CFrame = CFrame.new(cursor) * (facing.Magnitude > 0.05 and CFrame.lookAt(Vector3.zero, facing.Unit) or root.CFrame.Rotation)
						engine.SetVelocity(root, Vector3.zero)
					else
						-- Banjo's own source leg: physical velocity capped by remaining distance / dt.
						engine.SetVelocity(root, delta.Unit * math.min(speed, delta.Magnitude / math.max(dt, 1 / 60)))
						if facing.Magnitude > 0.05 then root.CFrame = CFrame.lookAt(root.Position, root.Position + facing.Unit) end
					end
				end)
				while result == nil do
					if cancel and cancel() then result = false; break end
					if result == nil then RunService.Heartbeat:Wait() end
				end
			end)
			self:Stop()
			if not ok then error(failure, 0) end
			return result == true
		end
		function transit:Approach(position, cancel, arrived)
			-- Chili FlyTo raises first, crosses at max(startY, endY)+30, then descends.
			local function route(target)
				local destination = target + Vector3.new(0, 3, 0)
				local height = math.max(root.Position.Y, destination.Y) + 30
				return self:FlyTo({ Vector3.new(root.Position.X, height, root.Position.Z),
					Vector3.new(destination.X, height, destination.Z), destination }, 120, cancel, arrived, "tween")
			end
			-- Source crossing dependency uses StealHome; map it to N3's existing safe spot.
			local world = Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
			local areas = world and world:FindFirstChild("Areas")
			local line = areas and areas:FindFirstChild("SeparationLine")
			local boundary = line and line:IsA("BasePart") and line.Position.X or 552
			if (root.Position.X < boundary) ~= (position.X < boundary) then
				local home = engine.GetBaseSafeSpot()
				if typeof(home) == "Vector3" and (home - root.Position).Magnitude > 12 and (home - position).Magnitude > 12 then
					if not route(home) then return false end
				end
			end
			return route(position)
		end
		return transit
	end
	LibraryLoader:OnUnload(function() if active then active:Stop() end end)
end
-- END QUEST TRANSIT CONTROLLER

-- BEGIN WISP CONTROLLER
-- Chili V2 41403-42256: WispQuests/Save, native steal inputs, fusion, claims and tree return.
do
	local engine = RuntimeState.StealEngine
	local state = { Generation = 0, Disposed = false, Busy = false, Lease = false, Valid = false,
		NextAt = 0, SettleUntil = 0, ReadAt = 0, Status = "Off", Pools = {}, KeepEggs = {}, KeepPets = {},
		NativeCalls = 0, Threads = {}, PendingEggs = {}, Required = 50000000000, StageCount = 4 }
	Tasks.WispState = state
	FarmConfig.Wisp_Auto = false
	local nativeHold = ShouldHoldBackScrambleEgg
	local function enabled() return not state.Disposed and not LibraryLoader.Unloaded and FarmConfig.Wisp_Auto == true end
	local function raceWanted()
		return RaceOwnsCharacter() or (Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal()) == true
	end
	local function save()
		SetElevated8()
		local reader = SaveModule and (SaveModule.Get or SaveModule.Peek)
		local value = type(reader) == "function" and reader()
		return type(value) == "table" and value or nil
	end
	local function owned()
		if not EggStateModule or type(EggStateModule.ReadOwnerEggs) ~= "function" then return nil end
		local value = EggStateModule.ReadOwnerEggs(LocalPlayer.UserId)
		return type(value) == "table" and value or nil
	end
	local function incomplete(quest, record)
		return type(quest) == "table" and quest.Id ~= nil and type(record) == "table"
			and not (type(record.Claimed) == "table" and record.Claimed[quest.Id] == true)
			and (tonumber(type(record.Progress) == "table" and record.Progress[quest.Id]) or 0) < (tonumber(quest.Target) or 1)
	end
	local function fuseStage()
		return enabled() and state.Valid and state.Quest and state.Quest.Event == "PetFused"
			and incomplete(state.Quest, state.Record)
	end
	local function petGroups(data, pool)
		local equipped, groups = {}, {}
		for key, uid in pairs(type(data.EquippedAssets) == "table" and data.EquippedAssets or {}) do
			equipped[tostring(uid == true and key or uid)] = true
		end
		for uid, pet in pairs(type(data.Inventory) == "table" and data.Inventory or {}) do
			local category = type(pet) == "table" and tostring(pet.Category or "")
			if category and pool[category] and pet.IsFavorite ~= true and not equipped[tostring(uid)] then
				groups[category] = groups[category] or {}
				table.insert(groups[category], { Uid = uid, Value = CalculateEggIncome({
					AssetCategory = category, AssetScale = pet.Scale, Mutations = pet.Mutations }) })
			end
		end
		for _, pets in pairs(groups) do
			table.sort(pets, function(a, b) return a.Value == b.Value and tostring(a.Uid) < tostring(b.Uid) or a.Value < b.Value end)
		end
		return groups
	end
	local function makePlan(data, eggs)
		state.Plan, state.Pool, state.KeepEggs, state.KeepPets, state.StealWanted = nil, {}, {}, {}, false
		local quest = state.Quest
		if not quest or not incomplete(quest, state.Record) then return end
		if quest.Event == "EggSecured" then state.StealWanted = true; return end
		if quest.Event ~= "PetFused" then return end
		if data.FusionLocked == true or state.FusionPhase or next(state.PendingEggs) ~= nil then return end
		local area = type(quest.Match) == "table" and quest.Match.AreaId
		if area == nil then error("Wisp fusion quest has no AreaId") end
		local pool = state.Pools[tostring(area)]
		if not pool then
			local configs = ReplicatedStorage:FindFirstChild("Data")
			configs = configs and configs:FindFirstChild("Areas")
			configs = configs and configs:FindFirstChild("Configs")
			local module = configs and configs:FindFirstChild(tostring(area))
			if not module or not module:IsA("ModuleScript") then error("Wisp area data unavailable") end
			local config = require(module)
			if type(config) ~= "table" or type(config.DropTable) ~= "table" then error("Wisp drop table unavailable") end
			pool = {}
			for _, row in ipairs(config.DropTable) do
				if type(row) == "table" and row[1] ~= nil then pool[tostring(row[1])] = true end
			end
			if next(pool) == nil then error("Wisp drop table empty") end
			state.Pools[tostring(area)] = pool
		end
		state.Pool = pool
		local pets, groups, largest = petGroups(data, pool), {}, 0
		for category in pairs(pool) do groups[category] = { Pets = pets[category] or {}, Eggs = {}, Placed = {} } end
		for key, egg in pairs(eggs) do
			local category = type(egg) == "table" and tostring(egg.AssetCategory or "")
			local group, uid = groups[category], type(egg) == "table" and (egg.Uid or key) or key
			if group and (egg.Placement ~= nil or not nativeHold(category, uid)) then
				local item = { Uid = uid, Record = egg, Value = CalculateEggIncome(egg) }
				table.insert(egg.Placement ~= nil and group.Placed or group.Eggs, item)
			end
		end
		local best
		for category, group in pairs(groups) do
			local total = #group.Pets + #group.Eggs + #group.Placed
			largest = math.max(largest, total)
			for _, list in ipairs({ group.Eggs, group.Placed }) do
				table.sort(list, function(a, b) return a.Value == b.Value and tostring(a.Uid) < tostring(b.Uid) or a.Value < b.Value end)
			end
			if total >= 3 then
				local duration, value = #group.Pets >= 3 and 0 or math.huge, 0
				for _, list in ipairs({ group.Eggs, group.Placed }) do
					for _, egg in ipairs(list) do
						if EggRecordsModule and type(EggRecordsModule.GrowthDuration) == "function" then
							local seconds = tonumber(EggRecordsModule.GrowthDuration(egg.Record))
							if seconds and seconds >= 0 then duration = math.min(duration, seconds) end
						end
					end
				end
				for i = 1, math.min(3, #group.Pets) do value += group.Pets[i].Value end
				if not best or duration < best.Duration or (duration == best.Duration and (value < best.Value
					or (value == best.Value and category < best.Category))) then
					best = { Category = category, Pets = group.Pets, Eggs = group.Eggs, Placed = group.Placed, Duration = duration, Value = value }
				end
			end
		end
		state.Plan, state.StealWanted = best, largest < 3
		-- Protect potential materials before a trio exists, then only the chosen species.
		for category, group in pairs(groups) do
			if not best or category == best.Category then
				for _, pet in ipairs(group.Pets) do state.KeepPets[tostring(pet.Uid)] = true end
				for _, egg in ipairs(group.Eggs) do state.KeepEggs[tostring(egg.Uid)] = true end
			end
		end
	end
	local function refresh()
		state.Valid, state.StealWanted = false, false
		local folder = ReplicatedStorage:FindFirstChild("Data")
		local module = folder and folder:FindFirstChild("WispQuests")
		if not module or not module:IsA("ModuleScript") then error("Wisp quest data unavailable") end
		local config = require(module)
		local data, eggs = save(), owned()
		if type(config) ~= "table" or type(config.List) ~= "table" or not data or not eggs
			or type(data.WispCompanion) ~= "table" then error("Waiting for Wisp save/eggs") end
		state.Required = tonumber(config.RequiredSpeedPower) or 50000000000
		state.StageCount = tonumber(config.StageCount) or 4
		state.Save, state.Eggs, state.Record = data, eggs, data.WispCompanion
		local record = state.Record
		state.Quest = record.Accepted and not record.Unlocked and config.List[tonumber(record.Stage) or 1] or nil
		if data.FusionLocked == true and state.FusionPhase == "begin" then state.FusionPhase = "locked" end
		local finishedQuest = state.FusionQuestId ~= nil and ((type(record.Claimed) == "table" and record.Claimed[state.FusionQuestId] == true)
			or (tonumber(type(record.Progress) == "table" and record.Progress[state.FusionQuestId]) or 0) >= (state.FusionTarget or math.huge))
		if data.FusionLocked ~= true and (state.FusionPhase == "reveal" or finishedQuest) then state.FusionPhase, state.FusionPets = nil, nil end
		makePlan(data, eggs)
		for uid in pairs(state.PendingEggs) do
			local exists = false
			for key, egg in pairs(eggs) do
				if tostring(type(egg) == "table" and (egg.Uid or key) or key) == uid then exists = true; break end
			end
			if not exists and state.PendingEggs[uid].FinishSent then state.PendingEggs[uid] = nil end
		end
		state.Valid, state.ReadAt = true, os.clock()
	end
	function Tasks.WispNeeds(egg)
		if not enabled() or not state.Valid or os.clock() - state.ReadAt > 3 or not state.StealWanted
			or type(egg) ~= "table" then return false end
		local quest = state.Quest
		if not quest or not incomplete(quest, state.Record) then return false end
		if quest.Event == "PetFused" then
			return type(quest.Match) == "table" and tostring(egg.AreaId) == tostring(quest.Match.AreaId)
		end
		if quest.Event ~= "EggSecured" then return false end
		for key, expected in pairs(type(quest.Match) == "table" and quest.Match or {}) do
			if key == "AreaId" then
				if tostring(egg.AreaId) ~= tostring(expected) then return false end
			elseif key == "Rarity" then
				local asset = AssetsModule and AssetsModule.Directory and AssetsModule.Directory[tostring(egg.AssetCategory)]
				local rarity = type(asset) == "table" and asset.Rarity
				if type(rarity) ~= "table" or tostring(rarity.DisplayName or rarity._id or "") ~= tostring(expected) then return false end
			else return false end
		end
		return true
	end
	local function stealWanted()
		local cycle = engine.AutoCycle
		return enabled() and ((state.Valid and state.StealWanted) or state.InstantFlight == true
			or (cycle ~= nil and cycle.Target ~= nil and cycle.Target.IsWisp == true)) == true
	end
	function Tasks.WispProtect(uid, pet)
		if state.PendingEggs[tostring(uid)] or (pet and state.FusionPets and state.FusionPets[tostring(uid)]) then return true end
		if not enabled() then return false end
		if not state.Valid then return true end
		return (pet and state.KeepPets or state.KeepEggs)[tostring(uid)] == true
	end
	local function carrying()
		local tool, uid = GetEquippedEggTool()
		local signal = engine.State.Carrying or engine.State.SignalCarrying or engine.State.WeldCarrying
		if tool and state.Valid and EggStateModule and type(EggStateModule.ReadFieldEgg) == "function" then
			for key, egg in pairs(state.Eggs or {}) do
				if type(egg) == "table" and tostring(egg.Uid or key) == tostring(uid)
					and EggStateModule.ReadFieldEgg(uid) == nil
					and (not signal or tostring(engine.State.CarryUid) == tostring(uid)) then return false end
			end
		end
		return tool ~= nil or signal or IsActivelyCarryingEgg()
	end
	local function idle()
		local mutate, belt = Tasks.MutateState, Tasks.TreadmillState
		return engine and not RuntimeState.IsExecuting and not engine.AutoCycle and not engine.Guard.Active and not engine.Guard.Busy
			and state.NativeCalls == 0 and os.clock() >= state.SettleUntil
			and not (mutate and (mutate.Lease or mutate.InventoryActions > 0 or os.clock() < mutate.HatchSettleUntil))
			and not (belt and (belt.Busy or belt.WearBusy or belt.Exiting))
			and not carrying()
			and LocalPlayer:GetAttribute("InScrambleArena") ~= true
	end
	local function higherTask()
		if raceWanted() then return true end
		local rank = Tasks.PriorityRank("Wisp")
		if engine.Movement.PlaceWanted and Tasks.PriorityRank("Place") < rank then return true end
		if FarmConfig.AutoTreadmill and Tasks.PriorityRank("Treadmill") < rank then return true end
		for _, candidate in ipairs(engine.CollectCandidates(false, not FarmConfig.Defense_InstantSteal)) do
			local key = candidate.IsScramble and "StealLab" or candidate.IsIndex and "StealIndex" or "StealFilter"
			if candidate.WispOnly then key = "Wisp" end
			if Tasks.PriorityRank(key) < rank then return true end
		end
		return false
	end
	local function worldPosition(path)
		local node = Workspace:FindFirstChild("World")
		for _, name in ipairs(path) do node = node and node:FindFirstChild(name) end
		if not node or not (node:IsA("Model") or node:IsA("BasePart")) then return nil end
		return node:GetPivot().Position
	end
	local function run(action)
		if not enabled() or os.clock() < (state.ConfigUntil or 0) or not idle() or higherTask() then return end
		if not engine.ClaimMovement("wisp") then return end
		state.Busy, state.Lease = true, true
		local generation, character = state.Generation, LocalPlayer.Character
		local humanoid, root
		local function cancelled()
			return not enabled() or generation ~= state.Generation or LocalPlayer.Character ~= character
				or engine.Movement.Owner ~= "wisp" or raceWanted()
				or (humanoid and (humanoid.Parent ~= character or humanoid.Health <= 0))
				or (root and (root.Parent ~= character or character:FindFirstChild("HumanoidRootPart") ~= root))
				or (character and character:GetAttribute("InvisApplied") == true)
		end
		local function invoke(name, ...)
			state.LastDispatch = false
			if cancelled() then return false, false end
			local packages = ReplicatedStorage:FindFirstChild("Packages")
			local network = packages and packages:FindFirstChild("Networking")
			local remote = network and network:FindFirstChild(name)
			if not remote or not remote:IsA("RemoteFunction") then return false, "missing remote" end
			state.LastDispatch = true
			return pcall(remote.InvokeServer, remote, ...)
		end
		-- BEGIN QUEST TRANSIT WISP TRAVEL
		local function travel(position, daylight)
			if not position then state.Status = "Quest target not streamed"; return false end
			if cancelled() then return false end
			if daylight and GetNightAndWallStatus().ShouldRetreat then state.Status = "Waiting for daylight"; return false end
			pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, position, 3)
			if cancelled() or (daylight and GetNightAndWallStatus().ShouldRetreat) then return false end
			local transit = Tasks.NewQuestTransit("wisp", character, humanoid, root, function() return not cancelled() end)
			if (root.Position - position).Magnitude > 6 then
				if not transit:Approach(position, function()
					return cancelled() or higherTask() or (daylight and GetNightAndWallStatus().ShouldRetreat)
				end) then state.Status = "Quest travel interrupted"; return false end
			end
			local deadline = os.clock() + 3
			while (root.Position - position).Magnitude > 6 do
				if cancelled() or higherTask() or os.clock() >= deadline then return false end
				humanoid:MoveTo(position)
				task.wait(0.1)
			end
			return not cancelled()
		end
		-- END QUEST TRANSIT WISP TRAVEL
		local ok, failure = pcall(function()
			SetElevated8()
			if RuntimeState.IsExecuting or engine.AutoCycle or state.NativeCalls > 0 or cancelled() then return end
			Tasks.ExitTreadmill()
			if cancelled() then return end
			if engine.ReleaseAutoShield then engine.ReleaseAutoShield(true) end
			if RuntimeState.OriginalHumanoid then RestoreCharacter() end
			if cancelled() then return end
			humanoid = character and character:FindFirstChildOfClass("Humanoid")
			root = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root or humanoid.Health <= 0 then return end
			if GetEquippedEggTool() then
				if carrying() then return end
				humanoid:UnequipTools() -- Only an owned, banked tool; never interrupt a field carry.
			end
			refresh()
			if cancelled() then return end
			action(invoke, travel, cancelled)
		end)
		pcall(function()
			if LocalPlayer.Character == character and engine.Movement.Owner == "wisp" and not RaceOwnsCharacter()
				and humanoid and humanoid.Parent == character and root and root.Parent == character then humanoid:MoveTo(root.Position) end
		end)
		engine.ReleaseMovement("wisp")
		state.Busy, state.Lease, state.NextAt = false, false, os.clock() + 3
		if engine.AutoWake then engine.AutoWake() end
		if not ok then state.Status, state.LastError = "Waiting for quest data", tostring(failure) end
	end
	local function questRequest(invoke, action, id)
		local ok, reply, message = invoke("RF/WispCompanion/Request", action, id)
		state.Status = ok and reply == true and (action .. " sent; waiting for save") or (action .. ": " .. tostring(message or reply or "no answer"))
	end
	local function step(invoke, travel, cancelled)
		local record, quest = state.Record, state.Quest
		for _, pending in pairs(state.PendingEggs) do
			if os.clock() >= pending.At then
				local ok, reply = invoke("RF/EggWorld/AskFinishHatch", pending.Uid)
				pending.FinishSent = state.LastDispatch and ok and reply ~= false
				pending.At = os.clock() + 3
				state.Status = "Waiting for hatch save"
			end
			return
		end
		local data = state.Save
		-- Finish this quest's fusion before claiming/advancing, even if PetFused already progressed.
		if data.FusionLocked == true and (state.FusionPhase ~= nil or fuseStage()) then
			if type(data.FusionEggReward) == "table" and state.FusionPhase ~= "reveal" then
				state.FusionPhase = "reveal"
				local ok, reply = invoke("RF/Fusery/FinishReveal")
				if not state.LastDispatch or (ok and reply == false) then state.FusionPhase = "locked" end
			end
			state.Status = "Waiting for fuse result"; return
		end
		if state.FusionPhase then state.Status = "Waiting for fuse confirmation"; return end
		if record.Unlocked then state.Status = "Done — Enchanted Tree open"; return end
		if not record.Accepted then
			if (tonumber(state.Save.SpeedPower) or 0) < state.Required then state.Status = "Needs " .. FormatCash(state.Required) .. " Speed Power"; return end
			local world = Workspace:FindFirstChild("World")
			local build = world and world:FindFirstChild("Build")
			if not build or build:GetAttribute("EnchantedForestZoneRevealed") ~= true then state.Status = "Enchanted Forest not open"; return end
			state.Status = "Meeting Wisp"
			if travel(worldPosition({ "Build", "EnchantedForestZone", "WispSpawn" }), true) then
				local fresh = save()
				if not cancelled() and fresh and type(fresh.WispCompanion) == "table" and not fresh.WispCompanion.Accepted
					and not fresh.WispCompanion.Unlocked and (tonumber(fresh.SpeedPower) or 0) >= state.Required then questRequest(invoke, "Accept") end
			end
			return
		end
		if quest and not incomplete(quest, record) and not (record.Claimed or {})[quest.Id] then questRequest(invoke, "Claim", quest.Id); return end
		if (tonumber(record.Stage) or 1) >= state.StageCount then
			if not record.Returning then questRequest(invoke, "BeginReturn"); return end
			state.Status = "Returning Wisp to tree"
			if travel(worldPosition({ "Build", "EnchantedForestZone", "Zone13Props", "EnchantedTree", "WispAnchor" }), true) then
				local fresh = save()
				if not cancelled() and fresh and type(fresh.WispCompanion) == "table" and fresh.WispCompanion.Returning
					and not fresh.WispCompanion.Unlocked then questRequest(invoke, "Return") end
			end
			return
		end
		if not quest then state.Status = "Waiting for quest stage"; return end
		if quest.Event ~= "PetFused" then return end
		local plan = state.Plan
		if not plan then state.Status = "Collecting three matching pets/eggs"; return end
		if #plan.Pets < 3 then
			if #plan.Placed > 0 then
				for _, item in ipairs(plan.Placed) do
					local checker = EggStateModule.IsReadyToHatch or EggStateModule.IsLocalEggReady
					if type(checker) == "function" and checker(item.Uid) == true then
						state.PendingEggs[tostring(item.Uid)] = { Uid = item.Uid, At = os.clock() + 0.9 }
						local ok, reply = invoke("RF/EggWorld/AskHatch", item.Uid)
						if not state.LastDispatch or (ok and reply == false) then state.PendingEggs[tostring(item.Uid)] = nil end
						state.Status = "Hatching quest egg"; return
					end
				end
			end
			if #plan.Pets + #plan.Placed < 3 and #plan.Eggs > 0 then
				local _, area = GetPlayerPlot()
				if not area then state.Status = "Plot unavailable"; return end
				if not travel(area.Position + Vector3.new(0, 3.5, 0), false) then return end
				refresh()
				plan = state.Plan
				if cancelled() or not fuseStage() or not plan or #plan.Eggs == 0 or #plan.Pets + #plan.Placed >= 3 then return end
				local positions = {}
				for _, egg in pairs(state.Eggs) do
					if type(egg) == "table" and type(egg.Placement) == "table" and typeof(egg.Placement.LocalCFrame) == "CFrame" then
						table.insert(positions, (area.CFrame * egg.Placement.LocalCFrame).Position)
					end
				end
				local cf = GenerateSafePenPosition(area, positions)
				if cf then invoke("RF/EggWorld/AskPlaceEgg", { Uid = plan.Eggs[1].Uid, LocalCFrame = area.CFrame:ToObjectSpace(cf) }) end
				state.Status = "Placing quest egg"; return
			end
			state.Status = "Waiting for quest eggs to grow"; return
		end
		local selected = {}
		for i = 1, 3 do selected[plan.Pets[i].Uid] = true end
		local slots = type(data.FusionSlots) == "table" and data.FusionSlots or {}
		for i = 1, 3 do
			if slots[i] ~= nil and not selected[slots[i]] then invoke("RF/Fusery/EjectPet", slots[i]); state.Status = "Preparing fuse slots"; return end
		end
		if data.FusionInfoAcknowledged == false then invoke("RF/Fusery/ConfirmBriefing"); return end
		local loaded = {}
		for i = 1, 3 do if slots[i] ~= nil then loaded[slots[i]] = true end end
		for i = 1, 3 do
			local uid = plan.Pets[i].Uid
			if not loaded[uid] then invoke("RF/Fusery/LoadPet", uid); state.Status = "Loading quest pet"; return end
		end
		state.FusionPets, state.FusionQuestId, state.FusionTarget = {}, quest.Id, tonumber(quest.Target) or 1
		for i = 1, 3 do state.FusionPets[tostring(plan.Pets[i].Uid)] = true end
		state.FusionPhase = "begin" -- Set before dispatch; ambiguous consumption is never blindly retried.
		local ok, reply = invoke("RF/Fusery/BeginFuse")
		if not state.LastDispatch or (ok and reply == false) then state.FusionPhase, state.FusionPets = nil, nil end
		state.Status = "Waiting for fuse confirmation"
	end
	-- Shared native action gate tracks in-flight inventory/fusion work before Wisp can claim a lease.
	function Tasks.WispNativeAction(kind, action, ...)
		if state.Disposed or LibraryLoader.Unloaded then return false end
		local thread = coroutine.running()
		if not state.Threads[thread] and (state.Lease or (kind == "fusion" and (fuseStage() or (enabled() and not state.Valid)))) then
			if kind == "fusion" then return false end
			return 0
		end
		state.NativeCalls += 1
		state.Threads[thread] = (state.Threads[thread] or 0) + 1
		local reply = table.pack(pcall(action, ...))
		state.Threads[thread] -= 1
		if state.Threads[thread] == 0 then state.Threads[thread] = nil end
		state.NativeCalls -= 1
		state.SettleUntil = os.clock() + 1.5
		if not reply[1] then error(reply[2], 0) end
		return table.unpack(reply, 2, reply.n)
	end
	local nativeActive, nativeYield, nativeCanRun = IsStealActive, Tasks.PriorityStealYield, Tasks.PriorityCanRun
	local nativeShield, nativeDodge, nativeClaim = engine.AutoShieldWanted, engine.TriggerGuardDodge, engine.ClaimMovement
	local nativeDeposit, nativeHatch, nativeSell, nativeEject = Tasks.ExecuteDepositEggs, ExecuteAutoHatch, ExecuteSellSelection, EjectAllSlots
	local activeAdapter, yieldAdapter, canRunAdapter, shieldAdapter, dodgeAdapter, claimAdapter
	local depositAdapter, hatchAdapter, sellAdapter, ejectAdapter, holdAdapter
	activeAdapter = function()
		if state.Lease or nativeYield() then return false end
		return nativeActive() or stealWanted()
	end
	yieldAdapter = function() return state.Lease or nativeYield() end
	canRunAdapter = function(key) if key == "Wisp" then return enabled() and state.Lease end; return nativeCanRun(key) end
	shieldAdapter = function()
		return not state.Lease and (nativeShield() or (stealWanted()
			and not FarmConfig.Defense_InstantSteal and not raceWanted() and not Tasks.MutateState.Lease))
	end
	dodgeAdapter = function(...) if not state.Lease then return nativeDodge(...) end end
	claimAdapter = function(owner, ...)
		if state.Lease and owner ~= "wisp" and owner ~= "race" then return false end
		if owner == "essence" and enabled() and state.Valid and state.StealWanted
			and Tasks.PriorityRank("Wisp") < Tasks.PriorityRank("Essence") then
			for _, candidate in ipairs(engine.CollectCandidates(false, not FarmConfig.Defense_InstantSteal)) do
				if candidate.IsWisp then return false end
			end
		end
		return nativeClaim(owner, ...)
	end
	depositAdapter = function(...) return Tasks.WispNativeAction("inventory", nativeDeposit, ...) end
	hatchAdapter = function(...)
		if next(state.PendingEggs) ~= nil then return 0 end
		return Tasks.WispNativeAction("inventory", nativeHatch, ...)
	end
	ejectAdapter = function(...) return Tasks.WispNativeAction("fusion", nativeEject, ...) end
	holdAdapter = function(category, uid) return Tasks.WispProtect(uid, false) or nativeHold(category, uid) end
	sellAdapter = function(pets, eggs)
		local cleanPets, cleanEggs = {}, {}
		for _, uid in ipairs(pets) do if not Tasks.WispProtect(uid, true) then table.insert(cleanPets, uid) end end
		for _, uid in ipairs(eggs) do if not Tasks.WispProtect(uid, false) then table.insert(cleanEggs, uid) end end
		if #cleanPets == 0 and #cleanEggs == 0 then return 0 end
		return Tasks.WispNativeAction("inventory", nativeSell, cleanPets, cleanEggs)
	end
	local nativeCycle = engine.RunStealCycle
	local cycleAdapter = function(...)
		state.InstantFlight = enabled() and state.Valid and state.StealWanted == true
		local reply = table.pack(pcall(nativeCycle, ...))
		state.InstantFlight = false
		if not reply[1] then error(reply[2], 0) end
		return table.unpack(reply, 2, reply.n)
	end
	engine.RunStealCycle = cycleAdapter
	IsStealActive, Tasks.PriorityStealYield, Tasks.PriorityCanRun = activeAdapter, yieldAdapter, canRunAdapter
	engine.AutoShieldWanted, engine.TriggerGuardDodge, engine.ClaimMovement = shieldAdapter, dodgeAdapter, claimAdapter
	Tasks.ExecuteDepositEggs, ExecuteAutoHatch, ExecuteSellSelection, EjectAllSlots, ShouldHoldBackScrambleEgg =
		depositAdapter, hatchAdapter, sellAdapter, ejectAdapter, holdAdapter
	function Tasks.BuildWispUI(tab)
		local group = tab:AddGroupbox({ Name = "Quests", IconName = "scroll-text", Side = 2,
			Collapsed = false, DisableCollapsing = false })
		-- BEGIN BANJO QUEST TABS
		local questTabs = group:AddTabbox({ Name = "Quest Tabs" })
		local wisp = questTabs:AddTab("Wisp", "ghost")
		Tasks.BuildBanjoUI(questTabs)
		-- END BANJO QUEST TABS
		wisp:AddToggle("Toggle_Wisp_Auto", { Text = "Auto Wisp", Default = false, Tooltip = "Complete the Wisp quest.", Callback = function(value)
			FarmConfig.Wisp_Auto = value == true
			state.Generation += 1
			state.Valid, state.StealWanted, state.NextAt, state.ReadAt = false, false, 0, 0
			state.ConfigUntil = os.clock() + 3
			if engine.AutoWake then engine.AutoWake() end
		end })
		local label = wisp:AddLabel("Status: Off", true)
		task.spawn(function()
			while not state.Disposed and not LibraryLoader.Unloaded do
				local ok, failure = pcall(function()
					if not enabled() then state.Status = "Off"; return end
					if os.clock() < (state.ConfigUntil or 0) then state.Status = "Loading settings"; return end
					refresh()
					local quest, record = state.Quest, state.Record
					if record.Unlocked and next(state.PendingEggs) == nil and state.FusionPhase == nil then state.Status = "Done — Enchanted Tree open"; return end
					if quest and incomplete(quest, record) then
						state.Status = tostring(quest.Title or quest.Event) .. " " .. tostring((record.Progress or {})[quest.Id] or 0) .. "/" .. tostring(quest.Target or 1)
					end
					local pending = next(state.PendingEggs) ~= nil
					local needsAction = pending or state.FusionPhase ~= nil or not record.Accepted or (tonumber(record.Stage) or 1) >= state.StageCount
						or (quest and not incomplete(quest, record) and not (record.Claimed or {})[quest.Id])
						or (fuseStage() and (state.Plan ~= nil or state.Save.FusionLocked == true or state.FusionPhase ~= nil))
					if needsAction and os.clock() >= state.NextAt then run(step) end
				end)
				if not ok then
					state.Valid, state.StealWanted, state.Status, state.LastError = false, false, "Waiting for quest data", tostring(failure)
					if os.clock() >= (state.NoticeAt or 0) then state.NoticeAt = os.clock() + 30; warn("[N3 HUB] Auto Wisp: " .. tostring(failure)) end
				end
				local text = "Status: " .. tostring(state.Status):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
				if state.Shown ~= text then pcall(label.SetText, label, text); state.Shown = text end
				task.wait(1)
			end
		end)
	end
	LibraryLoader:OnUnload(function()
		state.Disposed, state.Valid, state.StealWanted = true, false, false
		state.Generation += 1
		if engine.RunStealCycle == cycleAdapter then engine.RunStealCycle = nativeCycle end
		if IsStealActive == activeAdapter then IsStealActive = nativeActive end
		if Tasks.PriorityStealYield == yieldAdapter then Tasks.PriorityStealYield = nativeYield end
		if Tasks.PriorityCanRun == canRunAdapter then Tasks.PriorityCanRun = nativeCanRun end
		if engine.AutoShieldWanted == shieldAdapter then engine.AutoShieldWanted = nativeShield end
		if engine.TriggerGuardDodge == dodgeAdapter then engine.TriggerGuardDodge = nativeDodge end
		if engine.ClaimMovement == claimAdapter then engine.ClaimMovement = nativeClaim end
		if Tasks.ExecuteDepositEggs == depositAdapter then Tasks.ExecuteDepositEggs = nativeDeposit end
		if ExecuteAutoHatch == hatchAdapter then ExecuteAutoHatch = nativeHatch end
		if ExecuteSellSelection == sellAdapter then ExecuteSellSelection = nativeSell end
		if EjectAllSlots == ejectAdapter then EjectAllSlots = nativeEject end
		if ShouldHoldBackScrambleEgg == holdAdapter then ShouldHoldBackScrambleEgg = nativeHold end
	end)
end
-- END WISP CONTROLLER

-- BEGIN BANJO CONTROLLER
-- Chili V2 14662-15797 + tree-trip dependency 71960-72421. No Butterfly controller import.
do
	local engine = RuntimeState.StealEngine
	local state = { Generation = 0, Busy = false, Lease = false, Disposed = false, NextAt = 0,
		Status = "Off", Notes = nil, Acks = {}, Serial = 0, Playback = 0, Cleared = 0, Wrong = 0, LastAt = 0 }
	Tasks.BanjoState = state
	FarmConfig.Banjo_Auto = false
	local mushrooms = { Vector3.new(6218.93, 17159.02, 16903.8), Vector3.new(6257.93, 17159.02, 16912.8),
		Vector3.new(6270.93, 17159.02, 16903.8), Vector3.new(6244.93, 17159.02, 16918.8), Vector3.new(6231.93, 17159.02, 16912.8) }
	local center = Vector3.new(6244.93, 17159.02, 16880)
	local roomSpawn, roomExit = Vector3.new(6246.9, 17161, 16887), Vector3.new(6246.9, 17165, 16881.6)
	local leapHint, npcFallback = Vector3.new(5905.63, 17027.3, 15610.83), Vector3.new(6272.46, 17164.04, 16958.18)
	local claimRoute = { Vector3.new(6248.72, 17163, 16928), Vector3.new(6248.72, 17163, 16944) }
	local function enabled() return not state.Disposed and not LibraryLoader.Unloaded and FarmConfig.Banjo_Auto == true end
	local function raceWanted()
		return RaceOwnsCharacter() or (Tasks.RaceShouldYieldSteal and Tasks.RaceShouldYieldSteal()) == true
	end
	local function inTree() return LocalPlayer:GetAttribute("InEnchantedTree") == true end
	local function interior()
		local world = Workspace:FindFirstChild("World")
		local build = world and world:FindFirstChild("Build")
		return build and build:FindFirstChild("EnchantedTreeInterior")
	end
	local function marker(name, fallback)
		local tree = interior()
		local markers = tree and tree:FindFirstChild("Markers")
		local passages = markers and markers:FindFirstChild("Passages")
		local part = (passages and passages:FindFirstChild(name)) or (markers and markers:FindFirstChild(name))
		return part and part:IsA("BasePart") and part.Position or fallback
	end
	local function inRoom()
		local root = engine.Root()
		return inTree() and root ~= nil and (root.Position - marker("SecretRoomSpawn", roomSpawn)).Magnitude <= 120
	end
	local function readSave()
		SetElevated8()
		local reader = SaveModule and (SaveModule.Get or SaveModule.Peek)
		local data = type(reader) == "function" and reader()
		if type(data) ~= "table" then error("Banjo save unavailable") end
		return type(data.BanjoCricket) == "table" and data.BanjoCricket or {}
	end
	local function remote(name, class)
		local packages = ReplicatedStorage:FindFirstChild("Packages")
		local network = packages and packages:FindFirstChild("Networking")
		local found = network and network:FindFirstChild(name)
		return found and found:IsA(class) and found or nil
	end
	local function findBat()
		for _, container in pairs({ LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }) do
			for _, tool in ipairs(container:GetChildren()) do
				if tool:IsA("Tool") and (tool:GetAttribute("IsBat") == true or string.find(tool.Name:lower(), "bat", 1, true)) then return tool end
			end
		end
	end
	local function taggedPosition(tag, index, fallback)
		for _, model in ipairs(game:GetService("CollectionService"):GetTagged(tag)) do
			if index == nil or tonumber(model:GetAttribute("MushroomIndex")) == index then
				local hitbox = model:FindFirstChild("Hitbox") or model:FindFirstChild("Hitbox Part")
				if hitbox and hitbox:IsA("BasePart") then return hitbox.Position end
				if model:IsA("Model") or model:IsA("BasePart") then return model:GetPivot().Position end
			end
		end
		return fallback
	end
	local function playbackSeconds(count)
		local fn = state.Data and state.Data.PlaybackSeconds
		local ok, value = false, nil
		if type(fn) == "function" then ok, value = pcall(fn, count) end
		value = ok and tonumber(value)
		return value and value == value and value >= 0 and value < math.huge and value or count * 0.65 + 0.5
	end
	local function loadData()
		local data = ReplicatedStorage:FindFirstChild("Data")
		local module = data and data:FindFirstChild("BanjoCricket")
		if not module or not module:IsA("ModuleScript") then error("Banjo data unavailable") end
		state.Data = require(module)
		if type(state.Data) ~= "table" then error("Banjo data invalid") end
		local shared = ReplicatedStorage:FindFirstChild("Shared")
		local flags = shared and shared:FindFirstChild("Flags")
		local flagModule = flags and flags:FindFirstChild("BanjoCricketFlags")
		state.Stages = 5 -- Same source fallback; no sequence is manufactured.
		if flagModule and flagModule:IsA("ModuleScript") then
			local config = require(flagModule)
			if type(config) == "table" and config.Stages and type(config.Stages.Get) == "function" then
				local count = tonumber(config.Stages:Get())
				if count and count == count and count >= 1 and count < math.huge then state.Stages = math.floor(count) end
			end
		end
		local effect = remote("RE/BanjoCricket/Effect", "RemoteEvent")
		if not effect or not remote("RE/BanjoCricket/Aim", "RemoteEvent") or not remote("RF/BanjoCricket/AskClaim", "RemoteFunction") then error("Banjo remotes unavailable") end
		if state.Effect ~= effect then
			if state.Connection then state.Connection:Disconnect() end
			state.Effect = effect
			state.Connection = effect.OnClientEvent:Connect(function(message)
				if not enabled() or not state.Lease or engine.Movement.Owner ~= "banjo" or state.JobGeneration ~= state.Generation
					or state.Character ~= LocalPlayer.Character or not inRoom() or type(message) ~= "table" then return end
				state.Serial += 1
				state.LastAt = os.clock()
				local kind = message.Kind
				if kind == "Playback" and type(message.Notes) == "table" then
					local notes = {}
					if #message.Notes == 0 or #message.Notes > 256 then return end
					for _, value in ipairs(message.Notes) do
						local note = tonumber(value)
						if not note or note % 1 ~= 0 or note < 1 or note > 5 then return end
						table.insert(notes, note)
					end
					state.Notes, state.ListenAt, state.Playback = notes, os.clock() + playbackSeconds(#notes), state.Playback + 1
				elseif kind == "Note" then
					table.insert(state.Acks, { Mushroom = tonumber(message.Mushroom), Serial = state.Serial })
					if #state.Acks > 40 then table.remove(state.Acks, 1) end
				elseif kind == "Wrong" then state.Wrong, state.Notes, state.Playback = state.Serial, nil, state.Playback + 1
				elseif kind == "StageComplete" then state.Cleared = tonumber(message.Cleared) or state.Cleared
				elseif kind == "Reset" then state.Notes, state.Cleared, state.Playback = nil, 0, state.Playback + 1
				elseif kind == "Solved" then state.Solved = true end
			end)
		end
	end
	local function higherTask()
		if raceWanted() then return true end
		if os.clock() < (state.PriorityAt or 0) then return state.Higher == true end
		state.PriorityAt, state.Higher = os.clock() + 0.75, false
		local rank = Tasks.PriorityRank("Wisp") -- Chili assigns Banjo to the Wisp quest lane.
		if engine.Movement.PlaceWanted and Tasks.PriorityRank("Place") < rank then state.Higher = true end
		if FarmConfig.AutoTreadmill and Tasks.PriorityRank("Treadmill") < rank then state.Higher = true end
		if Tasks.PriorityRank("Essence") < rank and Tasks.PriorityCanRun("Essence") then state.Higher = true end
		for _, candidate in ipairs(engine.CollectCandidates(false, not FarmConfig.Defense_InstantSteal)) do
			local key = candidate.IsScramble and "StealLab" or candidate.IsIndex and "StealIndex" or "StealFilter"
			if candidate.WispOnly then key = "Wisp" end
			if Tasks.PriorityRank(key) < rank then state.Higher = true; break end
		end
		return state.Higher
	end
	local function idle()
		local wisp, mutate, belt = Tasks.WispState, Tasks.MutateState, Tasks.TreadmillState
		return not RuntimeState.IsExecuting and not engine.AutoCycle and not engine.Guard.Active and not engine.Guard.Busy
			and not (wisp and (wisp.Busy or wisp.Lease or wisp.NativeCalls > 0 or os.clock() < wisp.SettleUntil))
			and not (mutate and (mutate.Lease or mutate.InventoryActions > 0 or os.clock() < mutate.HatchSettleUntil))
			and not (belt and (belt.Busy or belt.WearBusy or belt.Exiting))
			and not IsActivelyCarryingEgg() and not GetEquippedEggTool()
			and not (engine.State.Carrying or engine.State.SignalCarrying or engine.State.WeldCarrying)
			and LocalPlayer:GetAttribute("InScrambleArena") ~= true
	end
	local function run()
		local requestedGeneration = state.Generation
		if not enabled() or os.clock() < (state.ConfigUntil or 0) or not idle() or higherTask() then return end
		-- Candidate/save reads may yield: revalidate settings and idle before the claim.
		if not enabled() or requestedGeneration ~= state.Generation or os.clock() < (state.ConfigUntil or 0) or not idle() then return end
		if not engine.ClaimMovement("banjo") then return end
		state.Busy, state.Lease, state.JobGeneration = true, true, state.Generation
		state.Done = false
		state.Character = LocalPlayer.Character
		state.Notes, state.Acks, state.Solved, state.Cleared, state.LastAt = nil, {}, false, 0, 0
		local character, generation = state.Character, state.JobGeneration
		local previousTool = character and character:FindFirstChildWhichIsA("Tool")
		local humanoid, root, bat, transit, deadline = nil, nil, nil, nil, os.clock() + 420
		local finishing = false
		local function safe()
			return not LibraryLoader.Unloaded and not state.Disposed and LocalPlayer.Character == character
				and engine.Movement.Owner == "banjo" and not raceWanted()
				and (not humanoid or (humanoid.Parent == character and humanoid.Health > 0))
				and (not root or (root.Parent == character and character:FindFirstChild("HumanoidRootPart") == root))
		end
		local function cancelled()
			if not safe() or not enabled() or generation ~= state.Generation or os.clock() >= deadline
				or (character and character:GetAttribute("InvisApplied") == true) then return true end
			local higher = higherTask()
			return higher or not safe() or generation ~= state.Generation or not enabled()
		end
		local function waitFor(seconds, check, cleanup)
			local untilAt = os.clock() + seconds
			repeat
				if cleanup and not safe() or not cleanup and cancelled() then return false end
				if check and check() then return true end
				task.wait(0.05)
			until os.clock() >= untilAt
			return check == nil or check() == true
		end
		local function floor(position)
			local params = RaycastParams.new()
			params.FilterType, params.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, { character }
			local hit = Workspace:Raycast(position + Vector3.new(0, 8, 0), Vector3.new(0, -30, 0), params)
			return hit and Vector3.new(position.X, hit.Position.Y + 3, position.Z) or position
		end
		local function walk(position, seconds, cleanup, arrived)
			-- Tree prompt / exit fallback only. Never walk the water route to Secret Leap.
			local untilAt = os.clock() + seconds
			repeat
				if cleanup and not safe() or not cleanup and cancelled() then return false end
				if arrived and arrived() then humanoid:MoveTo(root.Position); return true end
				if (root.Position - position).Magnitude <= 4 then humanoid:MoveTo(root.Position); return true end
				humanoid:MoveTo(position)
				task.wait(0.05)
			until os.clock() >= untilAt
			if safe() then humanoid:MoveTo(root.Position) end
			return (arrived and arrived()) or (root.Position - position).Magnitude <= 4
		end
		local function fly(position, speed, cleanup, arrived, seconds, face)
			if not transit then return false end
			return transit:FlyTo(position, speed, function() return cleanup and not safe() or not cleanup and cancelled() end,
				arrived, "velocity", seconds, face)
		end
		local function treePrompt()
			local tree = interior()
			local markers = tree and tree:FindFirstChild("Markers")
			local trigger = markers and markers:FindFirstChild("EnterTrigger")
			local entrance = trigger and trigger:FindFirstChild("EnchantedTreeEntrance")
			local prompt = entrance and entrance:FindFirstChild("EnchantedTreePrompt")
			local parent = prompt and prompt.Parent
			local position = parent and (parent:IsA("Attachment") and parent.WorldPosition or parent:IsA("BasePart") and parent.Position)
			return prompt and prompt:IsA("ProximityPrompt") and prompt or nil, position
		end
		local function enterTree()
			if inTree() then return true end
			if GetNightAndWallStatus().ShouldRetreat then state.Status = "Waiting for daylight"; return false end
			local prompt, position = treePrompt()
			if not prompt or not position then state.Status = "Tree entrance unavailable"; return false end
			pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, position, 3)
			if cancelled() or GetNightAndWallStatus().ShouldRetreat then return false end
			state.Status = "Flying to Enchanted Tree entrance"
			if not transit:Approach(position + Vector3.new(0, 3, -12), function()
				return cancelled() or GetNightAndWallStatus().ShouldRetreat
			end, inTree) then state.Status = "Tree approach interrupted"; return false end
			if inTree() then return waitFor(0.5) end
			for attempt = 1, 4 do
				if cancelled() then return false end
				state.Status = "Entering Enchanted Tree"
				if not walk(position, 3, false, inTree) then return false end
				if cancelled() or not prompt.Parent or not prompt.Enabled or (root.Position - position).Magnitude > math.min(8, prompt.MaxActivationDistance) then return false end
				if attempt % 2 == 1 and type(fireproximityprompt) == "function" then pcall(fireproximityprompt, prompt)
				else
					prompt:InputHoldBegin()
					waitFor(math.clamp(tonumber(prompt.HoldDuration) or 0, 0, 10) + 0.1)
					pcall(prompt.InputHoldEnd, prompt)
				end
				if waitFor(4, inTree) then return waitFor(0.5) end
			end
			state.Status = "Tree entry not confirmed"
			return false
		end
		local function enterRoom()
			if inRoom() then return true end
			local tree = interior()
			local hint = tree and tree:FindFirstChild("SecretLeapHint")
			hint = hint and hint:FindFirstChild("Streaks")
			local position = hint and hint:IsA("BasePart") and hint.Position or leapHint
			for _ = 1, 2 do
				if cancelled() or not inTree() then return false end
				local above = position + Vector3.new(0, 18, 0)
				state.Status = "Secret Leap: rising above the water"
				local leapRoute = { Vector3.new(root.Position.X, above.Y, root.Position.Z), above }
				if not transit:FlyTo(leapRoute, 120, function() return cancelled() or not inTree() end,
					inRoom, "velocity", nil, nil, function(leg)
						if leg == 2 then state.Status = "Secret Leap: flying to the hint" end
					end) then return false end
				if cancelled() or not inTree() then return false end
				-- Flight has ended: collisions/platform state restored BEFORE the natural fall.
				state.Status = "Secret Leap: falling through the hint"
				if waitFor(8, inRoom) then return waitFor(1.5) end
			end
			state.Status = "Secret Leap not confirmed"
			return false
		end
		local function hit(index, version)
			local function replaced() return version ~= nil and state.Playback ~= version end
			if cancelled() or replaced() or not inRoom() then return nil end
			local target = taggedPosition("BanjoCricketMushroom", index, mushrooms[index])
			if not target then return nil end
			local offset = Vector3.new(center.X - target.X, 0, center.Z - target.Z)
			local stance = floor(target + (offset.Magnitude > 0.01 and offset.Unit or Vector3.new(0, 0, -1)) * 6.5)
			if not transit:FlyTo(stance, 60, function() return cancelled() or replaced() or not inRoom() end, nil, "velocity", nil, target)
				or cancelled() or replaced() or not inRoom() then return nil end
			bat = EquipBatTool() -- Existing N3 equipment helper; no bat purchase or forced preferences.
			if not bat or not waitFor(0.25) or bat.Parent ~= character then state.Status = "Needs a bat in your bag"; return nil end
			local ready = waitFor(2, function()
				return bat:GetAttribute("CooldownActive") ~= true or Workspace:GetServerTimeNow() >= (tonumber(bat:GetAttribute("CooldownEndTime")) or 0)
			end)
			if not ready or cancelled() or replaced() or bat.Parent ~= character then return nil end
			local aim = remote("RE/BanjoCricket/Aim", "RemoteEvent")
			if not aim then return nil end
			local facing = Vector3.new(target.X, root.Position.Y, target.Z)
			if (facing - root.Position).Magnitude > 0.05 then root.CFrame = CFrame.lookAt(root.Position, facing) end
			engine.SetVelocity(root, Vector3.zero)
			local serial = state.Serial
			aim:FireServer(index)
			-- No yielding priority scan between aim and swing; the full check ran above.
			if not safe() or not enabled() or generation ~= state.Generation or replaced() or bat.Parent ~= character then return nil end
			bat:Activate()
			return serial
		end
		local function acknowledge(index, serial)
			local result
			waitFor(1.6, function()
				if state.Wrong > serial then result = "wrong"; return true end
				for _, ack in ipairs(state.Acks) do
					if ack.Serial > serial and ack.Mushroom == index then ack.Serial = 0; result = "ok"; return true end
				end
				return false
			end)
			return result
		end
		local function solve()
			local untilAt, wakes = os.clock() + 300, 0
			while os.clock() < untilAt and not cancelled() and inRoom() do
				if state.Solved or readSave().Solved == true then return true end
				local notes, version = state.Notes, state.Playback
				if not notes then
					if os.clock() - state.LastAt > 4 then
						wakes += 1
						if wakes > 12 then state.Status = "Mushrooms are not answering"; state.NextAt = os.clock() + 30; return false end
						state.Status = "Waking the mushrooms"
						hit(4)
						state.LastAt = os.clock()
					end
					waitFor(0.1)
				elseif os.clock() < (state.ListenAt or 0) then
					state.Status = string.format("Stage %d/%d: listening (%d notes)", state.Cleared + 1, state.Stages, #notes)
					waitFor(0.05)
				else
					state.Notes = nil
					for i, index in ipairs(notes) do
						if cancelled() or state.Playback ~= version then break end
						state.Status = string.format("Stage %d/%d: note %d/%d", state.Cleared + 1, state.Stages, i, #notes)
						local answer
						for _ = 1, 2 do
							if cancelled() or state.Playback ~= version then break end
							local serial = hit(index, version)
							if not serial then break end
							answer = acknowledge(index, serial)
							if answer or cancelled() then break end
						end
						if answer ~= "ok" then state.Status = "Note not confirmed; waiting for replay"; break end
					end
					state.LastAt, wakes = os.clock(), 0
				end
			end
			return false
		end
		local function claim()
			if not waitFor(5) or not inRoom() then return end
			local npc = taggedPosition("BanjoCricketNpc", nil, npcFallback)
			if (root.Position - npc).Magnitude > 9 then
				state.Status = "Flying to Jitterbug"
				local route = {}
				for _, point in ipairs(claimRoute) do table.insert(route, floor(point)) end
				local offset = Vector3.new(claimRoute[2].X - npc.X, 0, claimRoute[2].Z - npc.Z)
				table.insert(route, floor(npc + (offset.Magnitude > 0.01 and offset.Unit or Vector3.new(0, 0, -1)) * 6))
				if not fly(route, 60, false, nil, nil, npc) then return end
			end
			if cancelled() or not inRoom() or (root.Position - npc).Magnitude > 9 then return end
			if readSave().Claimed == true then state.Done = true; return end
			if cancelled() then return end
			local request = remote("RF/BanjoCricket/AskClaim", "RemoteFunction")
			if not request then state.Status = "Claim remote unavailable"; return end
			state.Status, state.ClaimPending = "Claiming Cricket's Banjo", true
			local ok, reply = pcall(request.InvokeServer, request)
			if ok and reply == false then state.ClaimPending = false end
			if cancelled() then return end
			waitFor(3, function() return readSave().Claimed == true end)
			if not cancelled() and readSave().Claimed == true then state.Done, state.ClaimPending = true, false
			else state.Status = "Waiting for claim save" end
		end
		local function leave()
			if not safe() or not inTree() or not transit then return end
			finishing = true
			if inRoom() then
				state.Status = "Leaving secret room"
				fly(marker("SecretRoomExit", roomExit), 60, true, function() return not inRoom() end)
				if inRoom() then fly(marker("SecretRoomExit", roomExit), 60, true, function() return not inRoom() end, 5) end
				waitFor(5, function() return not inRoom() end, true)
				if safe() and inRoom() then state.ExitFailed = true end
			end
			if not safe() or not inTree() or inRoom() then return end
			state.Status = "Leaving Enchanted Tree"
			local exit = marker("ExitTrigger")
			if exit then
				transit:Approach(exit, function() return not safe() end, function() return not inTree() end)
				waitFor(0.5, function() return not inTree() end, true)
				if safe() and inTree() then walk(exit, 6, true, function() return not inTree() end) end
			end
			-- No raw exterior TP fallback: user requires continuous travel, not a reset loop.
			if safe() and inTree() then state.ExitFailed = true end
		end
		local ok, failure = pcall(function()
			SetElevated8()
			if cancelled() or not idle() then return end
			Tasks.ExitTreadmill()
			if cancelled() then return end
			if engine.ReleaseAutoShield then engine.ReleaseAutoShield(true) end
			if RuntimeState.OriginalHumanoid then RestoreCharacter() end
			if cancelled() then return end
			humanoid = character and character:FindFirstChildOfClass("Humanoid")
			root = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root then return end
			transit = Tasks.NewQuestTransit("banjo", character, humanoid, root, function()
				return safe() and os.clock() < deadline and character:GetAttribute("InvisApplied") ~= true
					and (finishing or (enabled() and generation == state.Generation))
			end)
			state.ExitFailed = false
			if not enterTree() then state.NextAt = math.max(state.NextAt, os.clock() + 10); return end
			if not enterRoom() then
				state.NextAt = math.max(state.NextAt, os.clock() + 15)
				if not cancelled() then state.Status = "Secret Leap not confirmed" end
				return
			end
			if readSave().Solved == true or solve() then claim() end
		end)
		local result = state.Status
		if transit then transit:Stop() end
		pcall(leave) -- Only same-character/same-owner cleanup; never travels over a race handoff.
		pcall(function()
			if not safe() then return end
			humanoid:MoveTo(root.Position)
			engine.SetVelocity(root, Vector3.zero)
			if bat and character:FindFirstChildWhichIsA("Tool") == bat then
				if previousTool and previousTool ~= bat and (previousTool.Parent == character or previousTool.Parent == LocalPlayer:FindFirstChildOfClass("Backpack")) then humanoid:EquipTool(previousTool)
				elseif previousTool ~= bat then humanoid:UnequipTools() end
			end
		end)
		if transit then transit:Stop() end
		engine.ReleaseMovement("banjo")
		state.Busy, state.Lease, state.Character = false, false, nil
		state.NextAt = math.max(state.NextAt, os.clock() + 3)
		state.Status = state.Done and "Done — Cricket's Banjo claimed" or result
		if state.ExitFailed then state.Status ..= " · exit not confirmed" end
		if not ok then state.Status, state.LastError, state.NextAt = "Banjo paused; retrying", tostring(failure), os.clock() + 10 end
		if engine.AutoWake then engine.AutoWake() end
	end
	local nativeActive, nativeYield, nativeCanRun = IsStealActive, Tasks.PriorityStealYield, Tasks.PriorityCanRun
	local nativeShield, nativeDodge, nativeClaim = engine.AutoShieldWanted, engine.TriggerGuardDodge, engine.ClaimMovement
	local nativeAction = Tasks.WispNativeAction
	local activeAdapter = function() return not state.Lease and nativeActive() end
	local yieldAdapter = function() return state.Lease or nativeYield() end
	local canRunAdapter = function(key) if key == "Wisp" and state.Lease then return true end; return nativeCanRun(key) end
	local shieldAdapter = function() return not state.Lease and nativeShield() end
	local dodgeAdapter = function(...) if not state.Lease then return nativeDodge(...) end end
	local claimAdapter = function(owner, ...)
		if state.Lease and owner ~= "banjo" and owner ~= "race" then return false end
		return nativeClaim(owner, ...)
	end
	local actionAdapter = function(kind, action, ...)
		if state.Lease then if kind == "fusion" then return false end; return 0 end
		return nativeAction(kind, action, ...)
	end
	IsStealActive = activeAdapter
	Tasks.PriorityStealYield, Tasks.PriorityCanRun = yieldAdapter, canRunAdapter
	engine.AutoShieldWanted, engine.TriggerGuardDodge, engine.ClaimMovement = shieldAdapter, dodgeAdapter, claimAdapter
	Tasks.WispNativeAction = actionAdapter
	function Tasks.BuildBanjoUI(tabs)
		local group = tabs:AddTab("Banjo", "music")
		group:AddToggle("Toggle_Banjo_Auto", { Text = "Auto Banjo Cricket", Default = false, Tooltip = "Repeat the mushroom melody.", Callback = function(value)
			FarmConfig.Banjo_Auto = value == true
			state.Generation += 1
			state.ConfigUntil, state.NextAt, state.PriorityAt = os.clock() + 3, 0, 0
		end })
		local label = group:AddLabel("Status: Off", true)
		-- A separate label refresh keeps the status live during this bounded, single quest job.
		local connection, elapsed = nil, 0
		connection = RunService.Heartbeat:Connect(function(dt)
			elapsed += dt
			if elapsed < 0.5 then return end
			elapsed = 0
			local text = "Status: " .. tostring(state.Status):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
			if text ~= state.Shown then pcall(label.SetText, label, text); state.Shown = text end
		end)
		state.LabelConnection = connection
		task.spawn(function()
			while not state.Disposed and not LibraryLoader.Unloaded do
				local ok, failure = pcall(function()
					if not enabled() then state.Status = "Off"; return end
					if os.clock() < (state.ConfigUntil or 0) then state.Status = "Loading settings"; return end
					if os.clock() < state.NextAt then return end
					local data = readSave()
					if data.Claimed == true then state.Done, state.ClaimPending, state.Status = true, false, "Done — Cricket's Banjo claimed"; return end
					if state.ClaimPending then state.Status = "Waiting for claim save"; return end
					if LocalPlayer:GetAttribute("EnchantedTreeUnlocked") ~= true then state.Status, state.NextAt = "Finish Wisp; open Enchanted Tree", os.clock() + 10; return end
					if not findBat() then state.Status, state.NextAt = "Needs a bat in your bag", os.clock() + 10; return end
					local char = LocalPlayer.Character
					if char and char:GetAttribute("InvisApplied") == true then state.Status = "Waiting for invisibility to end"; return end
					loadData()
					if not idle() or higherTask() then state.Status = raceWanted() and "Paused for Auto Race" or "Waiting for other tasks"; return end
					run()
				end)
				if not ok then
					state.Status, state.LastError, state.NextAt = "Banjo data unavailable", tostring(failure), os.clock() + 10
					if os.clock() >= (state.NoticeAt or 0) then state.NoticeAt = os.clock() + 30; warn("[N3 HUB] Auto Banjo: " .. tostring(failure)) end
				end
				task.wait(1)
			end
		end)
	end
	LibraryLoader:OnUnload(function()
		state.Disposed = true
		state.Generation += 1
		if state.Connection then state.Connection:Disconnect() end
		if state.LabelConnection then state.LabelConnection:Disconnect() end
		if IsStealActive == activeAdapter then IsStealActive = nativeActive end
		if Tasks.PriorityStealYield == yieldAdapter then Tasks.PriorityStealYield = nativeYield end
		if Tasks.PriorityCanRun == canRunAdapter then Tasks.PriorityCanRun = nativeCanRun end
		if engine.AutoShieldWanted == shieldAdapter then engine.AutoShieldWanted = nativeShield end
		if engine.TriggerGuardDodge == dodgeAdapter then engine.TriggerGuardDodge = nativeDodge end
		if engine.ClaimMovement == claimAdapter then engine.ClaimMovement = nativeClaim end
		if Tasks.WispNativeAction == actionAdapter then Tasks.WispNativeAction = nativeAction end
	end)
end
-- END BANJO CONTROLLER

Tasks.BuildMainInterface()
Tasks.Loading:SetMessage("Verifying")
Tasks.Loading:SetCurrentStep(5)
Tasks.Loading:SetDescription("Verifying the engine, remotes & final configuration...")
do
	local Verdict = FindRemote("RE/EggWorld/FieldEggRedeemVerdict", "FieldEggRedeemVerdict")
	local Alerts = FindRemote("RE/Alerts/Raise", "Alerts/Raise")
	local Engine = RuntimeState.StealEngine
	if Verdict and Verdict:IsA("RemoteEvent") then
		Verdict.OnClientEvent:Connect(function()
			if Engine then
				Engine.State.LastDelivered = os.clock()
			end
		end)
	end
	if Alerts and Alerts:IsA("RemoteEvent") then
		Alerts.OnClientEvent:Connect(function(payload)
			if Engine and type(payload) == "table" and type(payload.Text) == "string" then
				local txt = string.lower(payload.Text)
				if string.find(txt, "delivery failed", 1, true) then
					Engine.State.LastFailed = os.clock()
                    if Engine.PrintAutoTrace then Engine.PrintAutoTrace() end
				end
			end
		end)
	end
end
function Tasks.InitialCharacterSetup()
	task.wait(0.5)
	if RaceOwnsCharacter() then return end
	local Engine = RuntimeState.StealEngine
	if Engine and Engine.AutoShieldWanted() then
		pcall(Engine.MaintainAutoShield)
		return
	end
	pcall(RestoreCharacter)
	pcall(UnequipAllTools)
end
task.spawn(Tasks.InitialCharacterSetup)
function Tasks.NormalPlayWatchdog()
	local IdleSince = os.clock()
	while true do
		task.wait(1)
		pcall(function()
			if RaceOwnsCharacter() then IdleSince = os.clock(); return end
			local Engine = RuntimeState.StealEngine
			local Moving = false
			if Engine and Engine.Guard then
				Moving = Engine.Guard.StealActive == true
			end
			local Busy = IsStealActive()
				or Tasks.TreadmillState.Busy or RuntimeState.OnTreadmill
				or Moving
				or RuntimeState.IsExecuting
				or FarmConfig.AutoStealEnabled
				or FarmConfig.AutoScrambleSteal
				or FarmConfig.Movement_Noclip
				or FarmConfig.Defense_AntiRagdoll
				or (Tasks.PriorityStealYield and Tasks.PriorityStealYield())
			if Busy then
				IdleSince = os.clock()
				return
			end
			if (os.clock() - IdleSince) > 2 then
				if RuntimeState.OriginalHumanoid ~= nil then
					pcall(RestoreCharacter)
				end
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then
					pcall(function()
						if hum.PlatformStand then
							hum.PlatformStand = false
						end
						if hum.Sit then
							hum.Sit = false
						end
						if not hum.AutoRotate then
							hum.AutoRotate = true
						end
						hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
						hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
						hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
						hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
						hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
						hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
						hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
					end)
					N3Restore.RepointControls(hum)
				end
				IdleSince = os.clock()
			end
		end)
	end
end
task.spawn(Tasks.NormalPlayWatchdog)
function Tasks.VoidAndDamageGuard()
	while true do
		task.wait(0.4)
		pcall(function()
			if RaceOwnsCharacter() then return end
			local Busy = IsStealActive()
				or RuntimeState.IsExecuting
				or FarmConfig.AutoStealEnabled
				or FarmConfig.AutoScrambleSteal
				or FarmConfig.Defense_AntiRagdoll
			if not Busy then
				return
			end
			if Tasks.PriorityStealYield and Tasks.PriorityStealYield() then
				return
			end
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoid or humanoid.Health <= 0 then
				return
			end
			for _, hum in ipairs({
				humanoid,
				RuntimeState.OriginalHumanoid,
			}) do
				if hum and hum.Health > 0 then
					pcall(function()
						if hum.Health < hum.MaxHealth then
							hum.Health = hum.MaxHealth
						end
						hum.BreakJointsOnDeath = false
						hum.RequiresNeck = false
					end)
				end
			end
			local root = character:FindFirstChild("HumanoidRootPart")
			if root and root.Position.Y < -80 and not DrScramble.IsInsideArena() then
				pcall(function()
					local safe = character:GetPivot().Position
					if safe.Y < -80 or safe.Y > 5000 then
						safe = Vector3.new(0, 20, 0)
					end
					root.CFrame = CFrame.new(safe + Vector3.new(0, 60, 0)) * root.CFrame.Rotation
					root.AssemblyLinearVelocity = Vector3.zero
					humanoid.Health = humanoid.MaxHealth
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					humanoid.PlatformStand = false
				end)
			end
		end)
	end
end
task.spawn(Tasks.VoidAndDamageGuard)
pcall(function()
	Tasks.Loading:Destroy()
	Tasks.Loading = nil
end)
pcall(function()
	task.spawn(LibraryLoader.Toggle)
end)
print("[N3 HUB] Guard Bounce Warp Bypass & Target Engine Loaded.")

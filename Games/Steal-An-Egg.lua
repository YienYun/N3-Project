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
	Race_Speed = 300,
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
		if Engine.AutoWake then Engine.AutoWake() end
	end
	Engine.AutoDeliverySerial = 0
	Engine.AutoHandledDeliverySerial = 0
	Engine.Guard = {
		Enabled = false,
		Busy = false,
		BusySince = 0,
		HitArms = 0,
		HitArmedAt = 0,
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
			Engine.Guard.HitArms = 0
			Engine.Guard.HitArmedAt = 0
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
			Engine.SetAntiGuard(false)
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
			{ Path = { "GearGiver_Slap", "Podium" }, Offset = Vector3.new(-16.415, 21.072, -6.106) },
			{
				Path = { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" },
				Offset = Vector3.new(-26.776, 1.75, 18.665),
			},
			{
				Path = { "__OBJECTS", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" },
				Offset = Vector3.new(-26.776, 1.75, 18.665),
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
		return Vector3.new(528.7, 70.57, -364.11)
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
		local lockCam = Engine.Carry.LockCamera == true
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
					RequestCarry(uid)
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
	Engine.FlyToPosition = function(targetPos, sessionId, stopDist, maxTime)
		local carry = Engine.Carry
		local pace = math.min(Engine.Pace(), math.max(FarmConfig.TweenSpeed or 400, 16))
		if carry.LockCamera then
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
		if not Engine.State.Carrying and Engine.State.CarryUid and IsStealActive() then
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
	local function HitCooldownActive()
		if Engine.Guard.HitArms <= 0 then
			return false
		end
		if 25 < os.clock() - (Engine.Guard.HitArmedAt or 0) then
			Engine.Guard.HitArms = 0
			return false
		end
		return true
	end
	Engine.TriggerGuardDodge = function(force)
		if Engine.AutoCycle then
			return
		end
		local guard = Engine.Guard
		if not guard.Enabled or guard.Active then
			return
		end
		if Engine.Carry.LineDrop then
			return
		end
		if not force and HitCooldownActive() then
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
		if Engine.Disposed or Engine.AutoCycle then
			return
		end
		if Engine.Guard.HitArms > 0 and os.clock() - Engine.Guard.HitArmedAt > 25 then
			Engine.Guard.HitArms = 0
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
		if Engine.AutoCycle or not Engine.Guard.Enabled then
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
local LastScrambleReqFetch = 0
local function RefreshScrambleState(forceRefresh)
	local now = os.clock()
	if not forceRefresh and next(CachedScrambleState) ~= nil and (now - LastScrambleReqFetch) < 10.0 then
		return CachedScrambleState
	end
	if not Remotes.RemoteScrambleTradeState then
		return CachedScrambleState
	end
	local ok, state = pcall(function()
		return Remotes.RemoteScrambleTradeState:InvokeServer()
	end)
	if ok and type(state) == "table" then
		CachedScrambleState = state
		if type(state.Requirements) == "table" and #state.Requirements > 0 then
			CachedScrambleReqs = state.Requirements
		end
		LastScrambleReqFetch = now
		if state.PendingReward and Remotes.RemoteScrambleFinishReveal then
			pcall(function()
				Remotes.RemoteScrambleFinishReveal:InvokeServer()
			end)
		end
	end
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
	if not FarmConfig.ScrambleHoldBack then
		return false
	end
	if not (FarmConfig.AutoScrambleSubmit or FarmConfig.AutoScrambleSteal) then
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
			CachedScrambleState = {}
			CachedScrambleReqs = {}
			LastScrambleReqFetch = 0
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
				else
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
function Tasks.ApplyDefenseAntiTrap()
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
		pcall(function()
			Conn:Disconnect()
		end)
		Patched = Patched + 1
	end
	DefenseRigPatched = true
	return true
end
function Tasks.ApplyDefenseAntiRagdoll()
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
local GetScrambleTradeStatusFn = nil
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
		if not reqs or #reqs == 0 then
			return false
		end
		local clean = string.lower(tostring(cat)):gsub("%s*egg%s*", ""):gsub("%s", "")
		if clean == "" then
			return false
		end
		for _, w in ipairs(reqs) do
			local cw = string.lower(tostring(w)):gsub("%s*egg%s*", ""):gsub("%s", "")
			if clean == cw then
				return true
			end
		end
		return false
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
		if not uid then
			return
		end
		pcall(function()
			if EggStateModule and type(EggStateModule.CarryFieldEgg) == "function" then
				EggStateModule.CarryFieldEgg(uid)
			end
		end)
		pcall(function()
			if Remotes.RemoteCarryEgg then
				if Remotes.RemoteCarryEgg:IsA("RemoteFunction") then
					Remotes.RemoteCarryEgg:InvokeServer({ Uid = uid })
				else
					Remotes.RemoteCarryEgg:FireServer({ Uid = uid })
				end
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
			if carry.LockCamera then
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
			if not carry.LockCamera or camSaved or not cam then
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
	Engine.AutoShield = { Links = {}, Character = nil, Original = nil, Clone = nil, Clock = 0 }
	Engine.AutoShieldWanted = function()
		return not Engine.AutoShieldDisposed and not FarmConfig.Defense_InstantSteal
			and (FarmConfig.AutoStealEnabled or FarmConfig.AutoStealAll or FarmConfig.AutoStealSelected) == true
	end
	Engine.AutoShieldReady = function()
		local shield = Engine.AutoShield
		local character = LocalPlayer.Character
		return character ~= nil and shield.Character == character
			and shield.Clone ~= nil and shield.Clone.Parent == character
			and shield.Original ~= nil and shield.Original.Parent == nil
			and character:FindFirstChildOfClass("Humanoid") == shield.Clone
	end
	Engine.AutoShieldClearLinks = function()
		for _, link in ipairs(Engine.AutoShield.Links) do
			pcall(function()
				link:Disconnect()
			end)
		end
		table.clear(Engine.AutoShield.Links)
	end
	Engine.ReleaseAutoShield = function(restore)
		local shield = Engine.AutoShield
		Engine.AutoShieldClearLinks()
		if restore and shield.Character == LocalPlayer.Character
			and shield.Clone ~= nil and RuntimeState.SwapClone == shield.Clone then
			RestoreCharacter()
		end
		shield.Character, shield.Original, shield.Clone = nil, nil, nil
		shield.Clock = 0
	end
	do
        -- Chili Humanoid Swap body, with N3 control/animation and restore bindings.
        local localPlayer, workspace = LocalPlayer, Workspace
        local tbl9 = Engine.AutoShield
        local tbl4 = { Grounded = Engine.IsGrounded }
        local fn9, fn10 = N3Restore.RepointControls, N3Restore.RestartAnimate
        local fn11 = Engine.AutoShieldClearLinks
        local function fn8()
            RuntimeState.OriginalHumanoid, RuntimeState.SwapClone = tbl9.Original, tbl9.Clone
        end
        -- BEGIN CHILI HUMANOID SWAP (fn12; unchanged)
    local function fn12()
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            return
        end

        if tbl9.Clone and tbl9.Clone.Parent == character then
            return
        end

        if not tbl4.Grounded(humanoid) then
            return
        end
        local clone = humanoid:Clone()
        humanoid.Parent = nil
        clone.Parent = character
        workspace.CurrentCamera.CameraSubject = clone
        fn9(clone)
        fn10(character)
        local v14 = tbl9
        tbl9.Original = humanoid
        v14.Clone = clone
        fn8()
        local animator = humanoid:FindFirstChildOfClass("Animator")
        local animator2 = clone:FindFirstChildOfClass("Animator")

        if animator and animator2 then
            table.insert(
                tbl9.Links,
                animator.AnimationPlayed:Connect(function(arg)
                    local animation = arg.Animation
                    if not animation or clone.Parent == nil then
                        return
                    end

                    local ok, result = pcall(function()
                        return animator2:LoadAnimation(animation)
                    end)

                    local v15 = result
                    if not ok or not v15 then
                        return
                    end

                    pcall(function()
                        v15.Priority = arg.Priority
                        v15.Looped = arg.Looped
                        local speed = arg.Speed
                        v15:Play(0.05, math.max(arg.WeightTarget, 0.01), speed)
                    end)

                    local connection3 = nil

                    connection3 = arg.Stopped:Connect(function()
                        connection3:Disconnect()

                        pcall(function()
                            v15:Stop(0.1)
                        end)
                    end)
                end)
            )
        end

        table.insert(
            tbl9.Links,
            clone.Died:Connect(function()
                fn11()
                local v15 = tbl9
                tbl9.Original = nil
                v15.Clone = nil
                local character2 = localPlayer.Character

                if character2 and humanoid.Parent == nil then
                    humanoid.Parent = character2
                    workspace.CurrentCamera.CameraSubject = humanoid
                    fn9(humanoid)
                    fn8()
                end

                pcall(function()
                    clone:Destroy()
                end)

                humanoid.Health = 0
            end)
        )
    end

        -- END CHILI HUMANOID SWAP
        Engine.MaintainAutoShield = function()
            if not Engine.AutoShieldWanted() then return false end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then return false end
            local root = Engine.Root()
            if LocalPlayer:GetAttribute("InScrambleArena") == true or (root and root.Position.Y < -200) then
                return false
            end
            if not Engine.AutoShieldReady() and RuntimeState.SwapClone == humanoid
                and RuntimeState.OriginalHumanoid then
                RestoreCharacter()
            end
            fn12()
            tbl9.Character = character
            return Engine.AutoShieldReady()
        end
    end
	Engine.AutoShieldHeartbeat = RunService.Heartbeat:Connect(function(dt)
		local shield = Engine.AutoShield
		if not Engine.AutoShieldWanted() then
			if shield.Clone then
				Engine.ReleaseAutoShield(not FarmConfig.Defense_InstantSteal)
			end
			return
		end
		shield.Clock = shield.Clock + dt
		local interval = Engine.AutoShieldReady() and 3 or 0.25
		if shield.Clock >= interval then
			shield.Clock = 0
			local ok, err = pcall(Engine.MaintainAutoShield)
			if not ok then
				warn("[N3 HUB] Auto steal shield: " .. tostring(err))
			end
		end
	end)
	Engine.AutoShieldCharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
		Engine.ReleaseAutoShield(false)
		Engine.AutoCarry.Carrying = false
		Engine.AutoCarry.CarryUid, Engine.AutoCarry.CarryAreaId = nil, nil
		if Engine.CancelAutoSteal then Engine.CancelAutoSteal() end
		task.spawn(function()
			character:WaitForChild("Humanoid", 10)
			task.wait(1)
			if LocalPlayer.Character == character and Engine.AutoShieldWanted() then
				pcall(Engine.MaintainAutoShield)
			end
		end)
	end)
	pcall(function()
		LibraryLoader:OnUnload(function()
			Engine.AutoShieldDisposed = true
			Engine.AutoShieldHeartbeat:Disconnect()
			Engine.AutoShieldCharacterAdded:Disconnect()
			if Engine.CancelAutoSteal then Engine.CancelAutoSteal() end
			Engine.ReleaseAutoShield(not FarmConfig.Defense_InstantSteal)
		end)
	end)
	-- Normal Auto Steal: literal Chili core, isolated from Instant/Line Drop.
	-- Source: Games/Source/Chili-SourceV1.lua, blob 8d7fa550e7ffd84b7979d2cdb24acad005d85590.
	-- Only the bindings, selector and lifecycle bridge below are N3-specific.
	do
		local localPlayer, workspace, networking = LocalPlayer, Workspace, NetFolder
		local cleanups, disposed = {}, false
		local function fn6(callback)
			table.insert(cleanups, callback)
		end
		local fn3 = function(arg)
			local ok, result = pcall(function()
				return require(arg())
			end)
			if not ok then result = ok end
			return result or nil
		end
		local tbl = {
			EggState = EggStateModule,
			AreaEggCycle = AreaEggCycleModule,
			AreaEggResetWall = AreaEggResetWallModule,
			AreaEggResetCycle = fn3(function() return ReplicatedStorage.Data.AreaEggResetCycle end),
		}
		local tbl4 = {
			Steal = Engine.AutoCarry,
			Movement = Engine.Movement,
			AntiGuard = Engine.Guard,
			Root = Engine.Root,
			IsNight = Engine.IsNight,
			WallSealed = Engine.WallSealed,
			ClaimMovement = Engine.ClaimMovement,
			ReleaseMovement = Engine.ReleaseMovement,
			Plot = function() return select(1, GetPlayerPlot()) end,
			Belt = function() return Tasks.AutoStealBelt and Tasks.AutoStealBelt() end,
			Toggle = function()
				return not disposed and not FarmConfig.Defense_InstantSteal and IsStealActive() == true
			end,
			StopWalking = function()
				local character = localPlayer.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				local root = Engine.Root()
				if humanoid and root then
					pcall(function()
						humanoid:MoveTo(root.Position)
						humanoid:Move(Vector3.zero, false)
					end)
				end
			end,
		}
		Engine.AutoStatus, Engine.AutoTargetText = "Idle", "None"
		Engine.AutoSpeed = function()
			return math.clamp(tonumber(FarmConfig.AutoTweenSpeed) or 400, 100, 1000)
		end
		local n2, n3, n4 = Engine.AutoSpeed(), 27.4, Engine.AutoSpeed()
		local n5, n7 = 0, 20
		local str, str2, flag, v18 = "None", "Idle", false, nil
		local tbl11, tbl12, tbl13, tbl14 = {}, {}, {}, {}
		local v15, v16, v17 = nil, nil, nil
		local function fn12(arg)
			local cycle = Engine.AutoCycle
			return arg ~= n5 or not tbl4.Toggle(v15, false)
				or (cycle ~= nil and (cycle.Session ~= RuntimeState.SessionId
					or cycle.Cancel ~= RuntimeState.StealCancel
					or cycle.Character ~= localPlayer.Character))
		end
		local fn13
local tbl2

do
    local n = 0.35
    local n2 = 5
    local tbl3 = {}
    local flag = true

    tbl2 = {
        Add = function(arg)
            local tbl4 = { Run = arg, Gap = n, Idle = n2, Repeat = false, Hold = 0 }
            table.insert(tbl3, tbl4)
            return tbl4
        end,
        Wake = function()
            flag = true
        end,
        Backoff = function(arg, arg2)
            if arg then
                arg.Hold = tonumber(arg2) or 6
            end
        end,
    }

    local connection = RunService.Heartbeat:Connect(function(arg)
        local v4 = flag
        flag = false

        for _, v5 in ipairs(tbl3) do
            v5.Gap = v5.Gap + arg
            v5.Idle = v5.Idle + arg

            if 0 < v5.Hold then
                v5.Hold = v5.Hold - arg
            elseif v5.Gap >= n and (v4 or v5.Repeat or v5.Idle >= n2) then
                v5.Gap = 0
                v5.Idle = 0
                local ok, result = pcall(v5.Run, v5)
                ok = ok and result == true
                v5.Repeat = ok
            end
        end
    end)

    fn6(function()
        connection:Disconnect()
    end)
end

tbl4.WallOpenDelay = function()
    local areaEggResetCycle = tbl.AreaEggResetCycle
    if type(areaEggResetCycle) ~= "table" then
        return 5
    end
    local n = tonumber(areaEggResetCycle.WallCountdownDelayAfterDayStartsSeconds) or 2
    local n2 = tonumber(areaEggResetCycle.WallCountdownSeconds) or 3
    return n + n2
end

do
    local tbl6 = {}
    local n = 0

    local function fn9()
        local v13 = tbl4.Plot()
        if not v13 then
            return {}
        end
        local tbl7 = {}

        for _, v14 in ipairs({ "TreadmillBottom", "TreadmillUpgrade" }) do
            local v15 = v13:FindFirstChild(v14)

            if v15 then
                if v15:IsA("BasePart") then
                    table.insert(tbl7, v15)
                else
                    for _, descendant in ipairs(v15:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            table.insert(tbl7, descendant)
                        end
                    end
                end
            end
        end

        local clientTreadmillRenders = workspace:FindFirstChild("__ClientTreadmillRenders")
        clientTreadmillRenders = clientTreadmillRenders
            and clientTreadmillRenders:FindFirstChild("TreadmillRender_" .. v13.Name)

        if clientTreadmillRenders then
            for _, descendant in ipairs(clientTreadmillRenders:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    table.insert(tbl7, descendant)
                end
            end
        end

        return tbl7
    end

    local function fn10()
        for _, v13 in ipairs(fn9()) do
            if not tbl6[v13] then
                tbl6[v13] = {
                    CFrame = v13.CFrame,
                    CanTouch = v13.CanTouch,
                    CanCollide = v13.CanCollide,
                    Transparency = v13.Transparency,
                }

                pcall(function()
                    v13.CanTouch = false
                    v13.CanCollide = false
                    v13.Transparency = 1
                    v13.CFrame = v13.CFrame - Vector3.new(0, 120, 0)
                end)
            end
        end
    end

    local function fn11()
        for k, v13 in pairs(tbl6) do
            if k and k.Parent then
                pcall(function()
                    k.CFrame = v13.CFrame
                    k.CanTouch = v13.CanTouch
                    k.CanCollide = v13.CanCollide
                    k.Transparency = v13.Transparency
                end)
            end
        end

        table.clear(tbl6)
    end

    tbl4.HoldBelt = function()
        n = n + 1
        fn10()
    end

    tbl4.ReleaseBelt = function()
        n = math.max(0, n - 1)

        if n == 0 then
            fn11()
        end
    end

    tbl4.BeltHeld = function()
        return n > 0
    end

    tbl4.RefreshBeltHide = function()
        if n > 0 then
            fn10()
        end
    end

    fn6(function()
        n = 0
        fn11()
    end)

    tbl4.LeaveBelt = function()
        local rfTreadmillAskDoff = networking:FindFirstChild("RF/Treadmill/AskDoff")

        if rfTreadmillAskDoff and rfTreadmillAskDoff:IsA("RemoteFunction") then
            pcall(rfTreadmillAskDoff.InvokeServer, rfTreadmillAskDoff)
        end
    end

    tbl4.Treadmill = { Riding = false }

    tbl4.ResetBelt = function()
        n = 0
        fn11()
    end

    tbl4.OnBelt = function()
        local v13 = tbl4.Belt()
        if not v13 or tbl6[v13] then
            return false
        end
        local v14 = tbl4.Root()
        if not v14 then
            return false
        end
        local v15 = v13.CFrame:PointToObjectSpace(v14.Position)
        local n2 = v13.Size.X / 2 + 2
        local flag = math.abs(v15.X) <= n2
        local flag2

        if flag then
            local n3 = v13.Size.Z / 2 + 2
            flag2 = math.abs(v15.Z) <= n3
        else
            flag2 = flag
        end

        flag2 = flag2 and v15.Y >= -2
        flag2 = flag2 and v15.Y <= v13.Size.Y / 2 + 8
        return flag2
    end
end

tbl4.ExitBelt = function()
    tbl4.Treadmill.Riding = false
    tbl4.LeaveBelt()
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        pcall(function()
            humanoid.Jump = true
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end

    task.wait(0.35)
end


        tbl4.Treadmill = setmetatable({}, {
            __index = function(_, key)
                if key == "Riding" then return RuntimeState.OnTreadmill end
            end,
            __newindex = function(_, key, value)
                if key == "Riding" then RuntimeState.OnTreadmill = value end
            end,
        })

tbl4.EndFlight = function()
    tbl4.Flying = false
    local v13 = tbl4.Root()

    if v13 then
        pcall(function()
            v13.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            v13.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
    end

    local character = localPlayer.Character
    character = character and character:FindFirstChildOfClass("Humanoid")

    if character then
        character.PlatformStand = false
    end
end

do
    local tbl6 = {
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.Seated,
        Enum.HumanoidStateType.PlatformStanding,
    }
    local tbl7 = {}
    local flag = false

    tbl4.GodMode = function(arg)
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not humanoid then
            return
        end

        if arg then
            flag = true

            for _, v13 in ipairs(tbl6) do
                pcall(function()
                    humanoid:SetStateEnabled(v13, false)
                end)
            end

            pcall(function()
                humanoid.BreakJointsOnDeath = false
            end)

            for _, descendant in ipairs(character:GetDescendants()) do
                if descendant:IsA("BasePart") and tbl7[descendant] == nil then
                    tbl7[descendant] = descendant.CanCollide

                    pcall(function()
                        descendant.CanCollide = false
                    end)
                end
            end
        elseif flag then
            flag = false

            for _, v13 in ipairs(tbl6) do
                pcall(function()
                    humanoid:SetStateEnabled(v13, true)
                end)
            end

            for k, v13 in pairs(tbl7) do
                if k and k.Parent then
                    pcall(function()
                        k.CanCollide = v13
                    end)
                end
            end

            table.clear(tbl7)
        end
    end
end

    local fn14

    do
        local tbl17 = {}

        local function fn15(arg)
            if type(arg) ~= "number" or tbl17[arg] then
                return
            end
            tbl17[arg] = true

            task.delay(math.max(0, arg - workspace:GetServerTimeNow()) + 0.05, function()
                tbl17[arg] = nil
                tbl2.Wake()
            end)
        end

        local n8 = 0

        fn14 = function()
            local areaEggCycle = tbl.AreaEggCycle
            if type(areaEggCycle) ~= "table" then
                return nil
            end

            local ok, result, result2, result3, result4 = pcall(function()
                local serverTimeNow = workspace:GetServerTimeNow()
                local nextResetTime = areaEggCycle.NextResetTime
                return serverTimeNow,
                    areaEggCycle.IsNightPhase(serverTimeNow),
                    areaEggCycle.NextNightTime(serverTimeNow),
                    nextResetTime(serverTimeNow)
            end)

            if not ok or type(result4) ~= "number" then
                return nil
            end

            if result2 == true then
                n8 = result4 + tbl4.WallOpenDelay()
                fn15(n8)
                return n8, "night", result
            end

            if tbl4.WallSealed() then
                fn15(result + 0.3)
                return math.max(n8, result), "wall", result
            end

            if type(result3) == "number" and result3 > result then
                fn15(result3)
            end

            return nil
        end
    end

    do
        local areaEggResetWall = tbl.AreaEggResetWall
        local changed = type(areaEggResetWall) == "table" and areaEggResetWall.Changed or nil

        if changed and type(changed.Connect) == "function" then
            local ok, result = pcall(function()
                return changed:Connect(function()
                    tbl2.Wake()
                end)
            end)

            ok = ok and result

            if ok then
                fn6(function()
                    pcall(function()
                        result:Disconnect()
                    end)
                end)
            end
        end
    end

    local n8
    n8 = 8
    local v20
    v20 = nil
    local n9
    n9 = 0
    local fn15, fn16

    local function fn17(arg)
        local tbl17 = {}
        local str3 = "FirstAreaEgg_" .. tostring(localPlayer.UserId)
        local eggState = tbl.EggState

        if type(eggState) == "table" and type(eggState.ReadFieldEggs) == "function" then
            task.spawn(function()
                local ok, result = pcall(eggState.ReadFieldEggs)

                if ok and type(result) == "table" and type(result.Records) == "table" then
                    for _, v21 in pairs(result.Records) do
                        local flag3 = type(v21) == "table" and type(v21.Uid) == "string"

                        if flag3 then
                            local flag4 = arg

                            if arg then
                                flag4 = string.sub(v21.Uid, 1, #str3) == str3
                            end

                            flag3 = not flag4
                        end

                        if flag3 then
                            tbl17[v21.Uid] = true
                        end
                    end
                end
            end)
        end

        return tbl17
    end

    fn13 = function()
        local flag3 = v20 ~= nil and os.clock() < n9
        return flag3
    end

    fn15 = function()
        local flag3 = v20

        if v20 then
            flag3 = n9 == math.huge
        end

        if flag3 then
            return
        end
        v20 = fn17(true)
        n9 = math.huge
        table.clear(tbl11)
        table.clear(tbl13)
        table.clear(tbl12)
        table.clear(tbl14)
        v18 = nil
    end

    fn16 = function()
        if not v20 then
            return false
        end

        if n9 <= os.clock() then
            v20 = nil
            return false
        end
        local v21 = fn17()
        if next(v21) == nil then
            return true
        end
        local flag3 = false
        local flag4 = false

        for k in pairs(v21) do
            if v20[k] then
                flag3 = true
            else
                flag4 = true
            end
        end

        if not flag3 then
            v20 = nil
            return false
        end
        return not flag4
    end


        -- Source fn18 adapter: unfiltered starters; filtered targets may include
        -- another player's carried egg. No N3 tombstones or strict UID gate.
        local function fn18(unfiltered, includeCarried)
            local result = {}
            local rows = unfiltered and CollectRawFieldEggs(true)
                or CollectCandidates(includeCarried == true, true)
            for _, row in ipairs(rows) do
                local raw = unfiltered and row or row.Raw
                local uid = raw and raw.Uid
                local state = raw and raw.State
                local cf = raw and (raw.BottomCFrame or raw.BoundsCFrame)
                local ownCarry = tbl4.Steal.Carrying and uid == tbl4.Steal.CarryUid
                local eligible = state == "Slot" or state == "Dropped"
                    or (not unfiltered and includeCarried == true and state == "Carried" and not ownCarry)
                if uid and eligible and typeof(cf) == "CFrame"
                    and (tbl14[uid] or 0) <= os.clock()
                    and not (v20 and v20[uid]) then
                    table.insert(result, {
                        Uid = uid, State = state, CFrame = cf,
                        AreaId = tostring(raw.AreaId),
                        Category = tostring(raw.AssetCategory or row.Category or "Egg"),
                        Scale = tonumber(raw.AssetScale) or 1,
                        Value = row.Income or 0,
                    })
                end
            end
            return result
        end

		-- BEGIN CHILI AUTO STEAL CORE (fn19 through fn57; unchanged)
    local n10
    n10 = 6
    local fn19, fn20, fn21, fn22, fn23

    do
        local v21 = nil
        local connection = nil

        fn19 = function(arg, arg2, arg3, arg4, arg5)
            local n11 = arg2 - arg.Position
            local magnitude = n11.Magnitude
            local n12 = math.max(arg4, 0.004166666666666667)
            local vector = Vector3.new(0, 0, 0)

            if magnitude > 0.01 then
                vector = n11.Unit * math.min(arg3, magnitude / n12)
            end

            local n13 = vector + Vector3.new(0, workspace.Gravity * n12 * 0.5, 0)

            if 2 < magnitude then
                if not arg5.mark then
                    arg5.mark = magnitude
                    arg5.clock = 0
                end

                arg5.clock = arg5.clock + arg4

                if 0.4 <= arg5.clock then
                    if arg5.mark - magnitude < arg3 * 0.1 then
                        pcall(function()
                            arg.CFrame = arg.CFrame + n11.Unit * math.min(magnitude, arg3 * n12)
                        end)
                    end

                    arg5.mark = magnitude
                    arg5.clock = 0
                end
            else
                arg5.mark = nil
            end

            pcall(function()
                arg.AssemblyLinearVelocity = n13
                arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end)

            return magnitude <= 0.5
        end

        fn20 = function()
            local v22 = tbl4.Root()

            if v22 then
                pcall(function()
                    v22.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v22.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end

        local connection2 = nil
        local tbl17 = {}

        fn21 = function()
            v21 = nil

            if connection then
                connection:Disconnect()
                connection = nil
            end

            if connection2 then
                connection2:Disconnect()
                connection2 = nil
            end
        end

        fn22 = function()
            local num = tonumber(localPlayer:GetAttribute("RagdollEndTime"))
            local flag3 = num ~= nil and num > workspace:GetServerTimeNow()
            return flag3
        end

        local flag3 = false

        local function fn24()
            if flag3 then
                return true
            end
            return true
        end

        fn23 = function(arg, arg2)
            v21 = arg
            flag3 = arg2 == true
            local v22 = connection
            local flag4

            if connection then
                flag4 = v22
            else
                flag4 = not arg
            end

            if flag4 then
                return
            end
            tbl17 = {}

            connection = RunService.Heartbeat:Connect(function()
                if not v21 or fn24() or fn22() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = tbl4.Root()
                if not v23 then
                    return
                end

                pcall(function()
                    local rotation = v23.CFrame.Rotation
                    v23.CFrame = CFrame.new(v21) * rotation
                    v23.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v23.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end)

            connection2 = RunService.PreSimulation:Connect(function(arg3)
                if not v21 or not fn24() or fn22() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = tbl4.Root()

                if v23 then
                    fn19(v23, v21, n4, arg3, tbl17)
                end
            end)
        end
    end

    fn6(fn21)
    local fn24

    fn24 = function()
        fn21()
        tbl4.EndFlight()
        tbl4.GodMode(false)
        local character = localPlayer.Character
        character = character and character:FindFirstChildOfClass("Humanoid")

        if character then
            character.PlatformStand = false
        end
    end

    local n11, fn25, fn26

    do
        local n12 = 1.5
        n11 = 0.6

        local function fn27(arg, arg2)
            local x = arg2.X
            return (Vector3.new(arg.X, 0, arg.Z) - Vector3.new(x, 0, arg2.Z)).Magnitude
        end

        local function fn28(arg)
            local ok, result = pcall(function()
                return arg:GetPivot().Position
            end)

            if not ok then
                result = ok
            end

            local v21 = result or nil
            return v21
        end

        fn25 = function(arg, arg2, arg3)
            local v21 = fn27(arg.Position, arg3)
            local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
            if not areaEggSlotsClient then
                return true
            end

            for _, child in ipairs(areaEggSlotsClient:GetChildren()) do
                if child:IsA("Model") and child.Name ~= arg2 then
                    local flag3 = fn28(child)
                    flag3 = flag3 and fn27(flag3, arg.Position) + n12 < v21
                    if flag3 then
                        return false
                    end
                    continue
                end
            end

            return true
        end

        fn26 = function(arg, arg2, arg3)
            local n13 = arg3 or 14
            local v21 = nil
            local v22

            for _, child in ipairs(workspace:GetChildren()) do
                if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
                    local carryAreaEgg = child:FindFirstChild("CarryAreaEgg")

                    if carryAreaEgg and carryAreaEgg:IsA("ProximityPrompt") then
                        local v23 = fn27(child.Position, arg2)

                        if v23 < n13 then
                            n13 = v23
                            v21 = carryAreaEgg
                            v22 = child
                        end
                    end
                end
            end

            if not v21 or not v22 then
                return nil
            end

            if type(arg) == "string" and not fn25(v22, arg, arg2) then
                return nil
            end
            return v21, v22
        end
    end

    local fn27

    fn27 = function(arg)
        local eggState = tbl.EggState

        if
            type(arg) == "string"
            and type(eggState) == "table"
            and type(eggState.CarryFieldEgg) == "function"
        then
            pcall(eggState.CarryFieldEgg, arg)
        end
    end

    local fn28

    do
        local function fn29()
            local carryUid = tbl4.Steal.CarryUid
            local flag3 = type(carryUid) == "string"

            if not flag3 then
                carryUid = flag3
            end

            local v21 = carryUid or nil
            return v21
        end

        local function fn30(arg)
            local v21 = fn29()
            if not v21 or type(arg) ~= "string" then
                return true
            end
            return v21 == arg
        end

        local function fn31(arg)
            if type(arg) ~= "string" then
                return false
            end
            local v21 = fn18(false, true)
            if #v21 == 0 then
                return true
            end

            for _, v22 in ipairs(v21) do
                if v22.Uid == arg then
                    return true
                end
            end

            return false
        end

        local function fn32(arg)
            local eggState = tbl.EggState

            if type(eggState) == "table" and type(eggState.DropFieldEgg) == "function" then
                pcall(eggState.DropFieldEgg, "PlayerRequest")
            end

            local n12 = 0

            while tbl4.Steal.Carrying and n12 < 1 and not fn12(arg) do
                n12 = n12 + RunService.Heartbeat:Wait()
            end
        end

        fn28 = function(arg, arg2)
            local n12 = 0

            while not tbl4.Steal.Carrying and n12 < n11 and not fn12(arg2) do
                n12 = n12 + RunService.Heartbeat:Wait()
            end

            if not tbl4.Steal.Carrying then
                str2 = "The egg never reached the hand"
                return false
            end

            if fn30(arg) then
                return true
            end

            if fn31((fn29())) then
                str2 = "Holding another egg that still matches, delivering it"
                return true
            end
            str2 = "Wrong egg in hand, dropping it"
            fn32(arg2)
            return false
        end
    end

    local fn29

    fn29 = function(arg, arg2)
        local eggState = tbl.EggState
        local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
        if not position then
            return false
        end
        local n12 = 0
        local huge = math.huge
        local n13 = 0

        while n12 < 1.5 do
            if fn12(arg2) then
                return false
            end

            if tbl4.Steal.Carrying then
                return true
            end

            if 0.06 <= huge then
                local v21 = fn26(arg.Uid, position)

                if v21 then
                    pcall(function()
                        v21.HoldDuration = 0
                    end)

                    n13 = 0

                    if typeof(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, v21)
                        n13 = 0
                    end
                else
                    n13 = n13 + 1
                    if 4 <= n13 then
                        return false
                    end

                    if type(eggState) == "table" and type(eggState.CarryFieldEgg) == "function" then
                        pcall(eggState.CarryFieldEgg, arg.Uid)
                    end
                end

                huge = 0
            end

            local result = RunService.Heartbeat:Wait()
            n12 = n12 + result
            huge = huge + result
        end

        return tbl4.Steal.Carrying == true
    end

    local fn30, fn31, n12, n13

    do
        local v21 = fn3(function()
            return ReplicatedStorage.Shared.Modules.Ragdoll
        end)

        local function fn32()
            local character = localPlayer.Character

            if type(v21) == "table" and type(v21.IsRagdolled) == "function" then
                local ok, result = pcall(v21.IsRagdolled, character)
                ok = ok and result == true
                if ok then
                    return true
                end
            end

            local num = tonumber(localPlayer:GetAttribute("RagdollEndTime"))
            num = num and num > workspace:GetServerTimeNow()
            if num then
                return true
            end
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                local state = humanoid:GetState()
                local flag3 = state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown
                return flag3
            end

            return false
        end

        fn30 = function(arg, arg2)
            if tbl4.Steal.Carrying then
                return true
            end
            local rfEggWorldAskFieldEggSnapshot =
                networking:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot")
            if
                not rfEggWorldAskFieldEggSnapshot
                or not rfEggWorldAskFieldEggSnapshot:IsA("RemoteFunction")
            then
                return false
            end
            local n14 = 0

            while n14 < 1 do
                if fn12(arg2) or tbl4.Steal.Carrying then
                    return tbl4.Steal.Carrying == true
                end
                local ok, result =
                    pcall(rfEggWorldAskFieldEggSnapshot.InvokeServer, rfEggWorldAskFieldEggSnapshot)
                ok = ok and type(result) == "table"
                ok = ok and result.Records
                local v22 = ok or nil

                if type(v22) == "table" then
                    local flag3 = false

                    for _, v23 in pairs(v22) do
                        local flag4 = type(v23) == "table" and v23.Uid == arg
                        local flag5

                        if flag4 then
                            flag5 = v23.State == "Slot" or v23.State == "Dropped"
                        else
                            flag5 = flag4
                        end

                        if flag5 then
                            flag3 = true
                            break
                        else
                            flag3 = false
                        end
                    end

                    if not flag3 then
                        return tbl4.Steal.Carrying == true
                    end
                end

                n14 = n14 + task.wait(0.3)
            end

            return tbl4.Steal.Carrying == true
        end

        local function fn33(arg)
            local v22 = tbl4.Root()
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not v22 or not position then
                return math.huge
            end
            return (v22.Position - position).Magnitude
        end

        fn31 = function(arg)
            local huge = math.huge
            local v22 = nil

            for _, v23 in ipairs(arg) do
                local v24 = fn33(v23)

                if v24 < huge then
                    huge = v24
                    v22 = v23
                end
            end

            return v22, huge
        end

        n12 = 20
        n13 = 90
        local n14 = 6

        local function fn34(arg, arg2, arg3, arg4, arg5, arg6)
            fn21()
            local v22 = tbl4.Root()
            if not v22 then
                return false
            end
            local character = localPlayer.Character
            local position = v22.Position
            local tbl17 = {}
            local position2 = nil
            local flag3 = nil
            local str3 = nil
            local n15 = 0

            local function fn34()
                if arg4 ~= nil then
                    return true
                end
                return true
            end

            local function fn35(arg7)
                n15 = n15 + arg7
                if fn12(arg2) then
                    flag3 = false
                    return nil
                end
                local flag4 = arg3

                if arg3 then
                    flag4 = not tbl4.Steal.Carrying
                end

                if flag4 then
                    flag3 = false
                    str3 = "dropped"
                    return nil
                end

                if arg6 then
                    local v23 = arg6()

                    if v23 then
                        flag3 = false
                        str3 = v23
                        return nil
                    end
                end

                local v23 = tbl4.Root()

                if not v23 or n15 >= 25 or localPlayer.Character ~= character then
                    flag3 = false
                    str3 = "respawned"
                    return nil
                end

                return v23
            end

            local connection = RunService.Heartbeat:Connect(function(arg7)
                if flag3 ~= nil or fn34() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = fn35(arg7)
                if not v23 then
                    return
                end

                if (v23.Position - position).Magnitude > n10 then
                    if arg5 then
                        flag3 = false
                        str3 = "displaced"
                        return
                    end

                    position = v23.Position
                end

                local v24 = arg4
                local v25

                if arg4 then
                    v25 = v24
                else
                    v25 = n2
                end

                local n16 = arg - position
                local n17 = v25 * arg7
                local flag4 = n16.Magnitude <= math.max(n17, 0.05)
                local n18 = flag4 and arg or position + n16.Unit * n17
                position = n18
                local vector = Vector3.new(n16.X, 0, n16.Z)
                local cframe = vector.Magnitude > 0.05
                        and CFrame.lookAt(Vector3.new(0, 0, 0), vector.Unit)
                    or v23.CFrame.Rotation

                pcall(function()
                    v23.CFrame = CFrame.new(position) * cframe
                    v23.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v23.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)

                if flag4 then
                    flag3 = true
                end
            end)

            local connection2 = RunService.PreSimulation:Connect(function(arg7)
                if flag3 ~= nil or not fn34() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = fn35(arg7)
                if not v23 then
                    return
                end
                local v24 = arg4

                if not arg4 then
                    v24 = n2
                end

                local flag4 = arg5

                if arg5 then
                    flag4 = position2
                end

                flag4 = flag4 and (v23.Position - position2).Magnitude > n10 + v24 * arg7

                if flag4 then
                    flag3 = false
                    str3 = "displaced"
                    return
                end

                if fn19(v23, arg, v24, arg7, tbl17) then
                    flag3 = true
                end

                position2 = v23.Position
                position = v23.Position
            end)

            while flag3 == nil do
                RunService.Heartbeat:Wait()
            end

            connection:Disconnect()
            connection2:Disconnect()

            if fn34() and not flag3 then
                fn20()
            end

            if flag3 then
                fn23(arg, arg4 ~= nil)
            end

            return flag3, str3
        end

        local tbl17 = {
            {
                Path = { "GearGiver_Slap", "Podium" },
                Offset = Vector3.new(-16.415000915527344, 21.07200050354004, -6.105999946594238),
            },
            {
                Path = { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" },
                Offset = Vector3.new(-26.775999069213867, 1.75, 18.665000915527344),
            },
            {
                Path = {
                    "__OBJECTS",
                    "Machines",
                    "RiftMachine",
                    "Rift",
                    "Meshes/VoidPortal_Cube.003",
                },
                Offset = Vector3.new(-26.775999069213867, 1.75, 18.665000915527344),
            },
        }

        local function fn35()
            for _, v22 in ipairs(tbl17) do
                local v23 = workspace

                for _, v24 in ipairs(v22.Path) do
                    v23 = v23 and v23:FindFirstChild(v24)
                    v23 = v23 or nil
                end

                if v23 and v23:IsA("BasePart") then
                    local cFrame = v23.CFrame
                    return cFrame:PointToWorldSpace(v22.Offset)
                end
            end

            return Vector3.new(528.7000122070313, 70.56999969482422, -364.1099853515625)
        end

        tbl4.StealHome = fn35

        tbl4.InsideBase = function(arg)
            if not arg then
                arg = tbl4.Root()
                arg = arg and arg.Position
            end

            if arg == nil then
                return false
            end
            local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
            world = world and world:FindFirstChild("Areas")
            world = world and world:FindFirstChild("SeparationLine")
            local x = world and world:IsA("BasePart") and world.Position.X or 552
            return arg.X < x
        end

        local function fn36(arg)
            if tbl4.AntiGuard.Busy then
                return false
            end
            local character = localPlayer.Character
            local v22 = tbl4.Root()
            if not character or not v22 then
                return false
            end
            local rotation = v22.CFrame.Rotation
            local n15 = CFrame.new(arg) * rotation

            pcall(function()
                character:PivotTo(n15)
            end)

            if 3 < (v22.Position - arg).Magnitude then
                pcall(function()
                    v22.CFrame = n15
                end)
            end

            for _, descendant in ipairs(character:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    pcall(function()
                        descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end

            return true
        end

        local function fn37(arg)
            if tbl4.AntiGuard.Busy then
                return
            end
            local character = localPlayer.Character
            local v22 = tbl4.Root()
            if not character or not v22 or not arg then
                return
            end

            if 6 < (v22.Position - arg).Magnitude then
                fn36(arg)
                return
            end

            for _, descendant in ipairs(character:GetDescendants()) do
                if
                    descendant:IsA("BasePart")
                    and descendant ~= v22
                    and (descendant.Position - v22.Position).Magnitude > 12
                then
                    pcall(function()
                        descendant.CFrame = v22.CFrame
                        descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end
        end

        local function fn38(arg, arg2)
            local n15 = 0

            while true do
                if not (n15 < n14) then
                    return not fn12(arg)
                else
                    if fn12(arg) then
                        break
                    end
                    local character = localPlayer.Character
                    local flag3 = fn32()
                    local v22

                    if not flag3 and character then
                        for _, descendant in ipairs(character:GetDescendants()) do
                            if
                                descendant:IsA("Constraint")
                                and string.find(descendant.Name, "RagdollConstraint", 1, true)
                            then
                                flag3 = true
                                break
                            end
                        end

                        v22 = flag3
                    else
                        v22 = flag3
                    end

                    if not v22 then
                        return not fn12(arg)
                    end
                    fn37(arg2)
                    n15 = n15 + RunService.Heartbeat:Wait()
                end
            end

            return false
        end

        local function fn39(arg)
            local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
            world = world and world:FindFirstChild("Areas")
            world = world and world:FindFirstChild("GuardAreas")
            local areaId = world and arg and arg.AreaId and world:FindFirstChild(arg.AreaId)
            local guard = areaId and areaId:FindFirstChild("Guard") or nil
            return guard
        end

        local function fn40(arg)
            local v22 = fn39(arg)
            local flag3 = v22 ~= nil and v22:GetAttribute("GuardState") == "Sleeping"
            return flag3
        end

        local n15 = 3

        local function fn41(arg)
            local v22 = fn39(arg)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not v22 or not position then
                return nil, nil
            end

            local ok, result = pcall(function()
                return v22:GetPivot().Position
            end)

            if not ok then
                return nil, nil
            end
            local vector = Vector3.new(position.X - result.X, 0, position.Z - result.Z)
            if vector.Magnitude < 0.1 then
                return nil, nil
            end
            local n16 = result + vector.Unit * n15
            return Vector3.new(n16.X, position.Y + 3, n16.Z), result
        end

        local function fn42(arg, arg2)
            local tbl18 = { Landed = false, Destination = arg2 }
            local antiGuard = tbl4.AntiGuard
            antiGuard.HitArms = antiGuard.HitArms + 1
            tbl4.AntiGuard.HitArmedAt = os.clock()

            tbl18.Link = localPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
                if tbl18.Landed or fn12(arg) then
                    return
                end
                local num = tonumber(localPlayer:GetAttribute("RagdollEndTime"))
                if not num or num <= workspace:GetServerTimeNow() then
                    return
                end
                local v22 = tbl4.Root()
                if not v22 then
                    return
                end
                tbl18.Landed = true
                fn21()

                pcall(function()
                    v22.CFrame = CFrame.new(tbl18.Destination)
                    v22.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end)
            end)

            tbl18.Stop = function()
                if tbl18.Link then
                    tbl18.Link:Disconnect()
                    tbl18.Link = nil
                    tbl4.AntiGuard.HitArms = math.max(0, tbl4.AntiGuard.HitArms - 1)
                end
            end

            return tbl18
        end

        local function fn43(arg, arg2, arg3)
            local character = localPlayer.Character
            character = character and character:FindFirstChildOfClass("Humanoid")

            if character then
                character.PlatformStand = false
            end

            local n16 = 0
            local v22 = nil

            while true do
                if not arg2.Landed and n16 < n12 then
                    if not fn12(arg) then
                        if arg3 then
                            arg3(arg2)
                        end

                        if not tbl4.Steal.Carrying then
                            local v23 = v22 or n16

                            if 1 < n16 - v23 then
                                break
                            else
                                v22 = v23
                                n16 = n16 + RunService.Heartbeat:Wait()
                                continue
                            end
                        else
                            n16 = n16 + RunService.Heartbeat:Wait()
                            continue
                        end
                    end
                end

                break
            end

            arg2.Stop()
            return arg2.Landed
        end

        local n16 = 20

        local function fn44(arg, arg2, arg3, arg4)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not position then
                return false
            end
            local n17 = 0
            local huge = math.huge

            while n17 < arg3 do
                if fn12(arg2) then
                    return false
                end

                if tbl4.Steal.Carrying then
                    return true
                end

                if 0.1 <= huge then
                    local v22 = fn26(arg.Uid, position)

                    if v22 then
                        pcall(function()
                            v22.HoldDuration = 0
                        end)

                        if typeof(fireproximityprompt) == "function" then
                            pcall(fireproximityprompt, v22)
                        end
                    else
                        fn27(arg.Uid)
                    end

                    huge = 0
                end

                if arg4 then
                    fn37(arg4)
                end

                local result = RunService.Heartbeat:Wait()
                n17 = n17 + result
                huge = huge + result
            end

            return tbl4.Steal.Carrying == true
        end

        local function fn45(arg, arg2, arg3, arg4)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not position then
                return false
            end
            local n17 = position + Vector3.new(0, 3, 0)
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid and character:FindFirstChildWhichIsA("Tool") then
                pcall(function()
                    humanoid:UnequipTools()
                end)
            end

            if arg3 then
                fn23(n17, true)
                str2 = "Waiting to stand up"
                if not fn38(arg2, n17) then
                    return false
                end
            else
                str2 = "Jumping to the egg"
                local v22 = tbl4.Root()

                if v22 and (n17 - v22.Position).Magnitude <= n13 then
                    pcall(function()
                        local rotation = v22.CFrame.Rotation
                        v22.CFrame = CFrame.new(n17) * rotation
                        v22.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        v22.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                elseif not fn34(n17, arg2, nil, n4) then
                    return false
                end
            end

            if fn12(arg2) then
                return false
            end
            local flag3 = arg4 and typeof(arg4.CFrame) == "CFrame"
            local v22 = nil

            if flag3 then
                v22 = fn42(arg2, arg4.CFrame.Position + Vector3.new(0, 3, 0))
            end

            local str3 = "FirstAreaEgg_" .. tostring(localPlayer.UserId)
            local flag4 = type(arg.Uid) == "string"
                    and string.sub(arg.Uid, 1, #str3) == str3
                    and string.match(arg.Uid, "_([%w ]+:Slot_%d+)$")
                or nil
            arg4 = arg4 and flag4
            local flag5 = false

            if arg4 then
                local eggState = tbl.EggState
                local flag6 = type(eggState) == "table"
                    and type(eggState.CarryFieldEgg) == "function"
                flag5 = false

                if flag6 then
                    str2 = "Taking the starter egg"

                    task.spawn(function()
                        pcall(eggState.CarryFieldEgg, arg.Uid, flag4)
                    end)

                    local n18 = 0

                    while not tbl4.Steal.Carrying and n18 < 0.8 do
                        if fn12(arg2) then
                            return false
                        end
                        n18 = n18 + RunService.Heartbeat:Wait()
                    end

                    flag5 = tbl4.Steal.Carrying == true
                end
            end

            if not flag5 then
                str2 = "Taking the egg"
                flag5 = fn29(arg, arg2)

                if not flag5 and not fn12(arg2) then
                    fn34(n17, arg2, nil, n4)
                    flag5 = fn29(arg, arg2)
                end
            end

            if not flag5 and not fn30(arg.Uid, arg2) then
                if v22 then
                    v22.Stop()
                end

                tbl14[arg.Uid] = os.clock() + n7
                str2 = "That egg would not come free"
                return false
            end

            if v22 then
                local reGuardPatrolForestStrike =
                    networking:FindFirstChild("RE/GuardPatrol/ForestStrike")
                local v23 = fn39(arg) or fn39({ AreaId = "Forest" })
                local humanoidRootPart = v23 and v23:FindFirstChild("HumanoidRootPart")

                if
                    reGuardPatrolForestStrike
                    and reGuardPatrolForestStrike:IsA("RemoteEvent")
                    and humanoidRootPart
                then
                    str2 = "Calling the guard strike"

                    pcall(function()
                        reGuardPatrolForestStrike:FireServer({
                            EggUid = arg.Uid,
                            GuardCFrame = humanoidRootPart.CFrame,
                        })
                    end)
                end
            end

            tbl4.Steal.LastFinishedAt = os.clock()
            return true, v22
        end

        local n17 = 3
        local n18 = 30

        local function fn46(arg, arg2, arg3)
            local v22 = nil
            local v23 = nil

            for _, child in ipairs(workspace:GetChildren()) do
                if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
                    local carryAreaEgg = child:FindFirstChild("CarryAreaEgg")

                    if carryAreaEgg and carryAreaEgg:IsA("ProximityPrompt") then
                        local magnitude = (child.Position - arg).Magnitude

                        if magnitude < arg2 then
                            arg2 = magnitude
                            v22 = carryAreaEgg
                            v23 = child
                        end
                    end
                end
            end

            if v22 and v23 and type(arg3) == "string" and not fn25(v23, arg3, arg) then
                return nil
            end
            return v22, v23
        end

        local function fn47(arg)
            local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
            local v22 = workspace:FindFirstChild(arg)
                or areaEggSlotsClient and areaEggSlotsClient:FindFirstChild(arg)
            if not v22 then
                return nil
            end

            local ok, result = pcall(function()
                return v22:GetPivot().Position
            end)

            if not ok then
                result = ok
            end

            local v23 = result or nil
            return v23
        end

        local function fn48(arg)
            local rfEggWorldAskFieldEggSnapshot =
                networking:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot")
            if
                not rfEggWorldAskFieldEggSnapshot
                or not rfEggWorldAskFieldEggSnapshot:IsA("RemoteFunction")
            then
                return nil
            end
            local ok, result =
                pcall(rfEggWorldAskFieldEggSnapshot.InvokeServer, rfEggWorldAskFieldEggSnapshot)
            local records = ok and type(result) == "table" and result.Records or nil
            if type(records) ~= "table" then
                return nil
            end

            for _, record in pairs(records) do
                if
                    type(record) == "table"
                    and record.Uid == arg
                    and typeof(record.BottomCFrame) == "CFrame"
                then
                    return record.BottomCFrame.Position
                end
            end

            return nil
        end

        local function fn49(arg)
            local v22 = workspace:FindFirstChild(arg)
            if not v22 then
                return false
            end

            for _, descendant in ipairs(v22:GetDescendants()) do
                if
                    descendant:IsA("JointInstance")
                    or descendant:IsA("WeldConstraint")
                    or descendant:IsA("RigidConstraint")
                then
                    local ok, result, result2 = pcall(function()
                        return descendant.Part0, descendant.Part1
                    end)

                    if ok then
                        for _, v23 in ipairs({ result, result2 }) do
                            if typeof(v23) == "Instance" and not v23:IsDescendantOf(v22) then
                                local model = v23:FindFirstAncestorOfClass("Model")
                                if
                                    model
                                    and model ~= localPlayer.Character
                                    and Players:GetPlayerFromCharacter(model)
                                then
                                    return true
                                end
                                continue
                            end
                        end
                    end
                end
            end

            return false
        end

        local function fn50(arg, arg2)
            local carryUid = arg2 or tbl4.Steal.CarryUid
            if type(carryUid) ~= "string" then
                return false
            end
            fn21()
            str2 = "Following the egg"
            local n19 = nil
            local vector = Vector3.new(0, 0, 0)

            local connection = RunService.PreSimulation:Connect(function(arg3)
                local v22 = tbl4.Root()
                if not v22 or not n19 or tbl4.Steal.Carrying or fn12(arg) then
                    return
                end

                if fn22() then
                    if 2 < (v22.Position - n19).Magnitude then
                        fn36(n19)
                    end

                    return
                end

                local n20 = math.max(arg3, 0.004166666666666667)
                local n21 = vector + (n19 - v22.Position) / math.max(0.08, n20)
                local n22 = n4 + vector.Magnitude

                if n22 < n21.Magnitude then
                    n21 = n21.Unit * n22
                end

                local n23 = n21 + Vector3.new(0, workspace.Gravity * n20 * 0.5, 0)

                pcall(function()
                    v22.AssemblyLinearVelocity = n23
                    v22.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end)

            local n20 = 0
            local huge = math.huge
            local v22 = nil
            local v23 = nil
            local n21 = 0
            local huge2 = math.huge
            local n22 = 0
            local flag3

            while true do
                flag3 = false

                if not (n20 < n18) then
                    break
                else
                    flag3 = false

                    if not fn12(arg) then
                        if tbl4.Steal.Carrying then
                            flag3 = true
                            break
                        else
                            local v24 = tbl4.Root()
                            flag3 = false

                            if v24 then
                                local v25 = fn47(carryUid)
                                local now, flag4, n23, flag5, v26, result

                                if not v25 and huge >= 0.5 then
                                    v25 = fn48(carryUid)
                                    flag3 = false
                                    local n24 = 0

                                    if v25 then
                                        huge = n24

                                        if v25 then
                                            now = os.clock()
                                            flag4 = v22 and v23 and now > v23

                                            if flag4 then
                                                n23 = (v25 - v22)
                                                    / math.max(now - v23, 0.004166666666666667)

                                                if n23.Magnitude < 3000 then
                                                    vector = vector:Lerp(n23, 0.3)
                                                end
                                            end

                                            n19 = v25 + Vector3.new(0, 3, 0)
                                            v22 = v25
                                            v23 = now
                                        end

                                        if n21 >= 0.4 then
                                            n21 = 0

                                            if fn49(carryUid) then
                                                str2 = "Another player took the egg"
                                                flag3 = false
                                                break
                                            else
                                                flag5 = n19
                                                    and (n19 - v24.Position).Magnitude <= n16
                                                    and huge2 >= 0.1

                                                if flag5 then
                                                    v26 = fn46(
                                                        n19 - Vector3.new(0, 3, 0),
                                                        6,
                                                        carryUid
                                                    )

                                                    if v26 then
                                                        pcall(function()
                                                            v26.HoldDuration = 0
                                                        end)

                                                        huge2 = 0
                                                        n22 = 0

                                                        if
                                                            typeof(fireproximityprompt)
                                                            == "function"
                                                        then
                                                            pcall(fireproximityprompt, v26)
                                                            huge2 = 0
                                                            n22 = 0
                                                        end

                                                        result = RunService.Heartbeat:Wait()
                                                        n20 = n20 + result
                                                        huge2 = huge2 + result
                                                        huge = huge + result
                                                        n21 = n21 + result
                                                        continue
                                                    else
                                                        n22 = n22 + 1
                                                        huge2 = 0

                                                        if not (20 <= n22) then
                                                            result = RunService.Heartbeat:Wait()
                                                            n20 = n20 + result
                                                            huge2 = huge2 + result
                                                            huge = huge + result
                                                            n21 = n21 + result
                                                            continue
                                                        else
                                                            flag3 = false
                                                            break
                                                        end
                                                    end
                                                else
                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                end
                                            end
                                        else
                                            flag5 = n19
                                                and (n19 - v24.Position).Magnitude <= n16
                                                and huge2 >= 0.1

                                            if flag5 then
                                                v26 = fn46(n19 - Vector3.new(0, 3, 0), 6, carryUid)

                                                if v26 then
                                                    pcall(function()
                                                        v26.HoldDuration = 0
                                                    end)

                                                    huge2 = 0
                                                    n22 = 0

                                                    if
                                                        typeof(fireproximityprompt) == "function"
                                                    then
                                                        pcall(fireproximityprompt, v26)
                                                        huge2 = 0
                                                        n22 = 0
                                                    end

                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                else
                                                    n22 = n22 + 1
                                                    huge2 = 0

                                                    if not (20 <= n22) then
                                                        result = RunService.Heartbeat:Wait()
                                                        n20 = n20 + result
                                                        huge2 = huge2 + result
                                                        huge = huge + result
                                                        n21 = n21 + result
                                                        continue
                                                    else
                                                        flag3 = false
                                                        break
                                                    end
                                                end
                                            else
                                                result = RunService.Heartbeat:Wait()
                                                n20 = n20 + result
                                                huge2 = huge2 + result
                                                huge = huge + result
                                                n21 = n21 + result
                                                continue
                                            end
                                        end
                                    end
                                else
                                    if v25 then
                                        now = os.clock()
                                        flag4 = v22 and v23 and now > v23

                                        if flag4 then
                                            n23 = (v25 - v22)
                                                / math.max(now - v23, 0.004166666666666667)

                                            if n23.Magnitude < 3000 then
                                                vector = vector:Lerp(n23, 0.3)
                                            end
                                        end

                                        n19 = v25 + Vector3.new(0, 3, 0)
                                        v22 = v25
                                        v23 = now
                                    end

                                    if n21 >= 0.4 then
                                        n21 = 0

                                        if fn49(carryUid) then
                                            str2 = "Another player took the egg"
                                            flag3 = false
                                            break
                                        else
                                            flag5 = n19
                                                and (n19 - v24.Position).Magnitude <= n16
                                                and huge2 >= 0.1

                                            if flag5 then
                                                v26 = fn46(n19 - Vector3.new(0, 3, 0), 6, carryUid)

                                                if v26 then
                                                    pcall(function()
                                                        v26.HoldDuration = 0
                                                    end)

                                                    huge2 = 0
                                                    n22 = 0

                                                    if
                                                        typeof(fireproximityprompt) == "function"
                                                    then
                                                        pcall(fireproximityprompt, v26)
                                                        huge2 = 0
                                                        n22 = 0
                                                    end

                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                else
                                                    n22 = n22 + 1
                                                    huge2 = 0

                                                    if not (20 <= n22) then
                                                        result = RunService.Heartbeat:Wait()
                                                        n20 = n20 + result
                                                        huge2 = huge2 + result
                                                        huge = huge + result
                                                        n21 = n21 + result
                                                        continue
                                                    else
                                                        flag3 = false
                                                        break
                                                    end
                                                end
                                            else
                                                result = RunService.Heartbeat:Wait()
                                                n20 = n20 + result
                                                huge2 = huge2 + result
                                                huge = huge + result
                                                n21 = n21 + result
                                                continue
                                            end
                                        end
                                    else
                                        flag5 = n19
                                            and (n19 - v24.Position).Magnitude <= n16
                                            and huge2 >= 0.1

                                        if flag5 then
                                            v26 = fn46(n19 - Vector3.new(0, 3, 0), 6, carryUid)

                                            if v26 then
                                                pcall(function()
                                                    v26.HoldDuration = 0
                                                end)

                                                huge2 = 0
                                                n22 = 0

                                                if typeof(fireproximityprompt) == "function" then
                                                    pcall(fireproximityprompt, v26)
                                                    huge2 = 0
                                                    n22 = 0
                                                end

                                                result = RunService.Heartbeat:Wait()
                                                n20 = n20 + result
                                                huge2 = huge2 + result
                                                huge = huge + result
                                                n21 = n21 + result
                                                continue
                                            else
                                                n22 = n22 + 1
                                                huge2 = 0

                                                if not (20 <= n22) then
                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                else
                                                    flag3 = false
                                                    break
                                                end
                                            end
                                        else
                                            result = RunService.Heartbeat:Wait()
                                            n20 = n20 + result
                                            huge2 = huge2 + result
                                            huge = huge + result
                                            n21 = n21 + result
                                            continue
                                        end
                                    end
                                end
                            end
                        end
                    end

                    break
                end
            end

            connection:Disconnect()
            fn20()
            local flag4 = flag3 or tbl4.Steal.Carrying == true
            return flag4
        end

        local function fn51(arg, arg2)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not position then
                return false
            end

            if tbl4.InsideBase() and not tbl4.InsideBase(position) then
                local v22 = fn35()

                if v22 then
                    str2 = "Leaving the base through the safe zone"
                    if not fn34(v22 + Vector3.new(0, 3, 0), arg2, nil, n4) then
                        return false
                    end
                end
            end

            str2 = "Flying to the egg"
            if not fn34(position + Vector3.new(0, 3, 0), arg2, nil, n4) then
                return false
            end
            str2 = "Taking the egg"
            local v22 = fn44(arg, arg2, 0.6, nil)

            if not v22 and not fn12(arg2) then
                v22 = fn29(arg, arg2)
            end

            if not v22 and not fn30(arg.Uid, arg2) then
                tbl14[arg.Uid] = os.clock() + n7
                return false
            end
            tbl4.Steal.LastFinishedAt = os.clock()
            return true
        end

        local tbl18 = { Uid = nil, Freed = nil, Token = nil }
        local n19 = 3

        local function fn52()
            local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
            world = world and world:FindFirstChild("Areas")
            local guardAreas = world and world:FindFirstChild("GuardAreas")
            local v22 = tbl4.Root()
            if not guardAreas or not v22 then
                return nil
            end
            local str3 = tostring(localPlayer.UserId)
            local carryAreaId = tbl4.Steal.CarryAreaId
                    and fn39({ AreaId = tostring(tbl4.Steal.CarryAreaId) })
                or nil
            local huge = math.huge
            local v23 = nil

            for _, child in ipairs(guardAreas:GetChildren()) do
                local guard = child:FindFirstChild("Guard")

                if guard then
                    if
                        tostring(guard:GetAttribute("TargetPlayer")) == str3
                        or tostring(guard:GetAttribute("WakeTargetPlayer")) == str3
                    then
                        return guard
                    end

                    local ok, result = pcall(function()
                        return guard:GetPivot().Position
                    end)

                    if ok then
                        local magnitude = (result - v22.Position).Magnitude

                        if magnitude < huge then
                            v23 = guard
                            huge = magnitude
                        end
                    end
                end
            end

            carryAreaId = carryAreaId or v23
            return carryAreaId
        end

        local function fn53(arg, arg2, arg3)
            local v22 = fn52()
            if not v22 then
                return false
            end
            local v23 = fn42(arg, arg3 + Vector3.new(0, 3, 0))
            local n20 = 0

            while true do
                if not v23.Landed and n20 < n12 and not fn12(arg) then
                    local ok, result = pcall(function()
                        return v22:GetPivot().Position
                    end)

                    local v24 = tbl4.Root()

                    if not (not ok or not v24) then
                        if n15 + 5 < (result - v24.Position).Magnitude then
                            local vector =
                                Vector3.new(v24.Position.X - result.X, 0, v24.Position.Z - result.Z)
                            local vector2 = vector.Magnitude > 0.1 and vector.Unit * n15
                                or Vector3.new(0, 0, 0)
                            local n21 = result + vector2

                            fn34(
                                Vector3.new(n21.X, result.Y + 3, n21.Z),
                                arg,
                                nil,
                                n4,
                                true,
                                function()
                                    if v23.Landed then
                                        return "hit"
                                    end
                                    return nil
                                end
                            )
                        end

                        n20 = n20 + RunService.Heartbeat:Wait()
                        continue
                    end
                end

                break
            end

            v23.Stop()
            if not v23.Landed then
                return false
            end
            return fn50(arg, arg2)
        end

        local function fn54(arg)
            local n20 = 0

            while tbl4.AntiGuard.Busy and n20 < 4 and not fn12(arg) do
                str2 = "Anti Guard is slipping past the guard"
                n20 = n20 + RunService.Heartbeat:Wait()
            end

            local n21 = 0

            while not tbl4.Steal.Carrying and n21 < n11 and not fn12(arg) do
                str2 = "Checking the egg in hand"
                n21 = n21 + RunService.Heartbeat:Wait()
            end

            if not tbl4.Steal.Carrying then
                str2 = "The egg is gone, staying to look for it"
                if not fn50(arg) then
                    str2 = "The egg is gone"
                    return false
                end
            end

            local v22 = fn35()
            local v23 = tbl4.Root()
            if not v22 or not v23 then
                return false
            end
            local n22 = math.max(v23.Position.Y, v22.Y) + n3

            local function fn54()
                if tbl18.Uid and tbl18.Freed and tbl4.Steal.Carrying then
                    return "priority"
                end
                return nil
            end

            local flag3 = true
            local n23 = 0

            while true do
                local v24 = tbl4.Root()

                if not v24 then
                    return false
                else
                    str2 = "Flying home"
                    local position = v24.Position
                    local n24 = math.max(n22, position.Y)
                    local v25, v26 = fn34(
                        Vector3.new(
                            position.X + (v22.X - position.X) * 0.25,
                            position.Y + (n24 - position.Y) * 0.7,
                            position.Z + (v22.Z - position.Z) * 0.25
                        ),
                        arg,
                        flag3,
                        nil,
                        nil,
                        fn54
                    )

                    if v25 then
                        local v27, v28 =
                            fn34(Vector3.new(v22.X, n24, v22.Z), arg, flag3, nil, nil, fn54)
                        v25 = v27
                        v26 = v28
                    end

                    local v27

                    if v25 then
                        local v28, v29 = fn34(v22, arg, flag3, nil, nil, fn54)
                        v26 = v29
                        v27 = v28
                    else
                        v27 = v25
                    end

                    if v27 then
                        local character = localPlayer.Character
                        character = character and character:FindFirstChildOfClass("Humanoid")

                        if character then
                            character.PlatformStand = false
                        end

                        task.wait(0.2)
                        if not tbl4.Steal.Carrying then
                            str2 = "Arrived without the egg"
                            return false
                        end
                        local eggState = tbl.EggState

                        if
                            type(eggState) == "table"
                            and type(eggState.DropFieldEgg) == "function"
                        then
                            pcall(eggState.DropFieldEgg, "PlayerRequest")
                        end

                        return true
                    end

                    if v26 == "priority" then
                        local uid = tbl18.Uid
                        local freed = tbl18.Freed
                        local v28 = tbl18
                        tbl18.Uid = nil
                        v28.Freed = nil
                        local v29 = tbl4.Root()
                        if not v29 or not uid or not freed then
                            return false
                        end

                        if (freed - v29.Position).Magnitude <= n4 * n19 then
                            str2 = "Best egg fell nearby, swapping eggs"
                            local eggState = tbl.EggState

                            if
                                type(eggState) == "table"
                                and type(eggState.DropFieldEgg) == "function"
                            then
                                pcall(eggState.DropFieldEgg, "PlayerRequest")
                            end

                            local n25 = 0

                            while tbl4.Steal.Carrying and n25 < 1 do
                                n25 = n25 + RunService.Heartbeat:Wait()
                            end

                            if not fn50(arg, uid) then
                                return false
                            end
                        else
                            str2 = "Best egg fell far away, riding a guard hit to it"
                            if not fn53(arg, uid, freed) then
                                return false
                            end
                        end

                        local v30 = tbl4.Root()
                        flag3 = true
                        n23 = 0

                        if v30 then
                            n22 = math.max(v30.Position.Y, v22.Y) + n3
                            flag3 = true
                            n23 = 0
                        end

                        continue
                    end

                    if v26 == "dropped" and n23 < n17 then
                        n23 = n23 + 1
                        if not fn50(arg) then
                            return false
                        end
                        continue
                    end

                    break
                end
            end

            return false
        end

        local function fn55(arg)
            local n20 = tonumber(arg) or 0
            local tbl19 = { "", "K", "M", "B", "T", "Qa", "Qi" }
            local n21 = 1

            while math.abs(n20) >= 1000 and n21 < #tbl19 do
                n20 = n20 / 1000
                n21 = n21 + 1
            end

            local format = string.format
            local str3 = n21 == 1 and "%.0f%s" or "%.2f%s"
            return format(str3, n20, tbl19[n21])
        end

        local function fn56(arg)
            if not arg then
                return "None"
            end
            local format = string.format
            local str3 = tostring(arg.Category)
            local n20 = tonumber(arg.Scale) or 0
            local v22 = tostring
            local areaId = arg.AreaId
            local str4 =
                format("%s  %.2fx  |  value %s  |  %s", str3, n20, fn55(arg.Value), v22(areaId))

            if arg.State == "Dropped" then
                str4 = str4 .. "  |  dropped"
            elseif arg.State == "Carried" then
                str4 = str4 .. "  |  carried by a player"
            end

            return str4
        end

        local flag3 = false

        local function fn57()
            local v22 = n5
            tbl4.Steal.Active = true
            tbl4.Steal.Carrying = tbl4.Steal.Carrying == true

            if not tbl4.Steal.Carrying then
                tbl4.Steal.CarryUid = nil
            end

            local v23 = nil
            local str3 = nil

            for _, v24 in ipairs((fn18(false, true))) do
                if v24.State == "Carried" then
                    str3 = str3 or v24
                else
                    v23 = v24
                    break
                end
            end

            local tbl19 = { v23 }
            local uid = v23 and v23.Uid or nil
            v18 = uid
            tbl4.Steal.Wanted = v23 ~= nil
            str = fn56(v23)

            if str3 then
                str = str .. "  |  watching " .. tostring(str3.Category)
            end

            if not v23 then
                tbl4.Steal.Active = false
                str3 = str3 and "Best egg is carried, waiting for it"
                str3 = str3 or "No egg matches"
                str2 = str3
                return false
            end

            if not tbl4.ClaimMovement("steal") then
                tbl4.Steal.Active = false
                str2 = "Waiting for Auto Place"
                return false
            end

            if tbl4.Treadmill.Riding or tbl4.OnBelt() then
                tbl4.ExitBelt()
            end

            flag3 = true
            tbl4.HoldBelt()

            local function fn57(arg)
                str2 = arg
                local v24 = fn51(v23, v22)
                local flag4 = false
                local v25 = nil

                if v24 then
                    if fn28(v23.Uid, v22) then
                        v25 = nil
                        flag4 = fn54(v22)
                    else
                        v25 = str2
                        flag4 = false
                    end
                end

                fn24()
                tbl4.Steal.Active = false
                tbl4.Steal.LastFinishedAt = os.clock()
                flag4 = flag4 and "Delivered"
                flag4 = flag4 or v25
                flag4 = flag4 or v24 and "Run ended" or "That egg would not come free"
                str2 = flag4
                return true
            end

            local v24 = tbl4.Root()
            local position = typeof(v23.CFrame) == "CFrame" and v23.CFrame.Position or nil

            if v24 and position then
                local flag4 = (position - v24.Position).Magnitude <= n16
                local areaId = v23.AreaId
                local flag5 = localPlayer:GetAttribute("AreaId") == areaId
                if flag4 or flag5 then
                    return (fn57("Target is right here, taking it"))
                end
            end

            local v25 = fn18(true)
            local str4 = "FirstAreaEgg_" .. tostring(localPlayer.UserId)
            local tbl20 = {}

            for _, v26 in ipairs(v25) do
                local v27 = fn40(v26)
                local flag4

                if v27 then
                    flag4 = v27
                else
                    flag4 = type(v26.Uid) == "string" and string.sub(v26.Uid, 1, #str4) == str4
                end

                if flag4 then
                    table.insert(tbl20, v26)
                end
            end

            if #tbl20 ~= 0 then
                v25 = tbl20
            end

            local v26, v27 = fn31(v25)
            local v28 = v26
            local v29 = v27

            if not v28 then
                tbl4.Steal.Active = false
                str2 = "No egg matches"
                return false
            end

            if v28.Uid == v23.Uid then
                return (fn57("Target is the closest egg, taking it"))
            end
            local v30, v31 = fn41(v28)
            local v32 = v31
            local v33

            if v32 and v24 then
                local v34, v35, v36 = ipairs(v25)
                local huge = math.huge
                v33 = v28

                for _, v37 in v34, v35, v36 do
                    local position2 = typeof(v37.CFrame) == "CFrame" and v37.CFrame.Position or nil

                    if v37.Uid ~= v23.Uid and v37.AreaId == v28.AreaId and position2 then
                        local magnitude = (position2 - v24.Position).Magnitude

                        if n13 < (position2 - v32).Magnitude then
                            magnitude = magnitude + n13
                        end

                        if magnitude < huge then
                            huge = magnitude
                            v33 = v37
                        end
                    end
                end
            else
                v33 = v28
            end

            str2 = string.format("Sleeping guard egg %d studs away", math.floor(v29 + 0.5))

            if not v33 then
                tbl4.Steal.Active = false
                str2 = "No egg matches"
                return false
            end

            local v34, v35 = fn45(v33, v22, false, tbl19[1])
            if not v34 then
                tbl4.Steal.Active = false
                return false
            end
            local uid2 = nil
            local uid3 = v23.Uid
            local n20 = 0

            while true do
                if v35 and not fn12(v22) then
                    str2 = "Holding for the guard hit"

                    if
                        fn43(v22, v35, function(arg)
                            if not uid2 and tbl18.Uid and tbl18.Freed then
                                uid2 = tbl18.Uid
                                arg.Destination = tbl18.Freed + Vector3.new(0, 3, 0)
                                local v36 = tbl18
                                tbl18.Uid = nil
                                v36.Freed = nil
                                str2 = "Best egg fell, jumping to it instead"
                            end
                        end)
                    then
                        n20 = n20 + 1

                        if uid2 then
                            uid3 = uid2
                            fn50(v22, uid2)
                            break
                        else
                            local v36 = tbl19[n20]
                            local v37
                            v37, v35 = fn45(v36, v22, true, tbl19[n20 + 1])

                            if v37 then
                                if v36 and type(v36.Uid) == "string" then
                                    uid3 = v36.Uid
                                end

                                continue
                            end
                        end
                    end
                end

                break
            end

            if not fn28(uid3, v22) then
                local v36 = str2
                fn24()
                tbl4.Steal.Active = false
                tbl4.Steal.LastFinishedAt = os.clock()
                str2 = v36
                return true
            end

            local str5 = fn54(v22)
            fn24()
            tbl4.Steal.Active = false
            tbl4.Steal.LastFinishedAt = os.clock()
            str5 = str5 and "Delivered"
            str5 = str5 or "Run ended"
            str2 = str5
            return true
        end

        local eggState = tbl.EggState

        if type(eggState) == "table" then
            for _, v22 in ipairs({
                "FieldRefreshed",
                "FieldShifted",
                "FieldGone",
                "SnapshotRefreshed",
            }) do
                local v23 = eggState[v22]

                if type(v23) == "table" and type(v23.Connect) == "function" then
                    local ok, result = pcall(v23.Connect, v23, function()
                        tbl2.Wake()
                    end)

                    ok = ok and result

                    if ok then
                        fn6(function()
                            pcall(function()
                                result:Disconnect()
                            end)
                        end)
                    end
                end
            end
        end

		-- END CHILI AUTO STEAL CORE
        tbl2.Add(function()
            local flag4 = nil

            if v16 then
                flag4 = type(v16.Set) == "function"
            end

            if flag4 then
                pcall(v16.Set, nil, str2)
            end

            local flag5 = nil

            if v17 then
                flag5 = type(v17.Set) == "function"
            end

            if flag5 then
                pcall(v17.Set, nil, str)
            end

            Engine.AutoStatus, Engine.AutoTargetText = str2, str
            Engine.CurrentTarget = v18
            if not tbl4.Toggle(v15, false) then
                if flag and tbl4.Steal.Active then Engine.CancelAutoSteal() end
                return false
            end
            local v22, v23, v24 = fn14()
            local v25 = v23

            if v22 then
                if v25 == "night" then
                    fn15()
                end

                tbl4.Movement.StealFirst = true
                tbl4.Steal.Wanted = false

                if flag then
                    n5 = n5 + 1
                    tbl4.Steal.Active = false
                    fn24()
                    tbl4.StopWalking()
                end

                local n20 = math.max(0, math.ceil(v22 - v24))

                if v25 == "wall" then
                    str2 = string.format("Field wall up, %ds", n20)
                else
                    str2 = string.format("Night, going again in %ds", n20)
                end

                return false
            end

            local flag6 = v20

            if v20 then
                flag6 = n9 == math.huge
            end

            if flag6 then
                n9 = os.clock() + n8
            end

            if flag then
                return true
            end

            if fn16() then
                str2 = "Night over, waiting for the field to reset"
                tbl2.Wake()
                return false
            end

            local stealFirst = tbl4.Movement.StealFirst
            local owner = tbl4.Movement.Owner

            if
                tbl4.Movement.PlaceWanted and not stealFirst
                or owner ~= nil
                    and owner ~= "steal"
                    and owner ~= "treadmill"
                    and owner ~= "scramble"
            then
                str2 = "Waiting for Auto Place"

                if stealFirst then
                    tbl2.Wake()
                end

                return true
            end

            -- N3's other automations must finish before this source worker owns movement.
            if RuntimeState.IsExecuting or Engine.Guard.Active or Engine.Guard.Busy then return true end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 or not tbl4.Root() then return false end
            if not Engine.AutoShieldReady() then
                pcall(Engine.MaintainAutoShield)
                str2 = "Waiting for Humanoid Swap"
                return true
            end
            n2, n4 = Engine.AutoSpeed(), Engine.AutoSpeed()
            Engine.StopHold()
            Engine.SetAntiGuard(false)
            Engine.EndDisguise()
            tbl4.Movement.StealFirst = false
            flag = true
            Engine.AutoCycle = {
                Session = RuntimeState.SessionId, Cancel = RuntimeState.StealCancel,
                Character = character, Humanoid = humanoid,
            }
            RuntimeState.IsExecuting = true
            Engine.Guard.StealActive = true

            task.spawn(function()
                local ok, failure = pcall(fn57)

                if flag3 then
                    flag3 = false
                    tbl4.ReleaseBelt()
                end

                if not ok then
                    fn24()
                    tbl4.Steal.Active = false
                    str2 = "Auto steal error"
                    warn("[N3 HUB] Chili Auto Steal: " .. tostring(failure))
                end

                local v26 = v18
                v18 = nil
                local once = v26 and tbl11[v26]
                once = once and once.Once

                if once then
                    tbl11[v26] = nil
                end

                local v27 = tbl18
                local v28 = tbl18
                tbl18.Uid = nil
                v27.Freed = nil
                v28.Token = nil

                if str2 == "Delivered" and not tbl4.IsNight() then
                    tbl4.Movement.StealFirst = true
                end

                tbl4.ReleaseMovement("steal")
                -- This serial means Chili's delivery routine returned true; it is
                -- only a post-place trigger, never a server-acceptance verdict.
                if str2 == "Delivered" then
                    Engine.AutoDeliverySerial = Engine.AutoDeliverySerial + 1
                end
                Engine.AutoStatus, Engine.AutoTargetText = str2, str
                Engine.CurrentTarget = nil
                Engine.AutoCycle = nil
                Engine.Guard.StealActive = false
                RuntimeState.IsExecuting = false
                flag = false
                tbl2.Wake()
            end)

            return false
        end)
    end

        Engine.AutoWake = tbl2.Wake
        Engine.UpdateAutoStealSpeed = function()
            n2, n4 = Engine.AutoSpeed(), Engine.AutoSpeed()
        end
        Engine.CancelAutoSteal = function()
            n5 = n5 + 1
            table.clear(tbl14)
            tbl4.Steal.Active, tbl4.Steal.Wanted = false, false
            tbl4.Movement.StealFirst = false
            fn24()
            tbl4.StopWalking()
            tbl2.Wake()
        end
        -- Public entry points only wake the single source scheduler. The old
        -- normal worker never owns movement or delivers an egg independently.
        Engine.RunAutoStealCycle = function()
            tbl2.Wake()
            return false
        end
        fn6(function()
            Engine.CancelAutoSteal()
            tbl4.ReleaseMovement("steal")
            Engine.AutoCycle = nil
            Engine.Guard.StealActive = false
        end)
        pcall(function()
            LibraryLoader:OnUnload(function()
                disposed = true
                for index = #cleanups, 1, -1 do pcall(cleanups[index]) end
                RuntimeState.IsExecuting = false
            end)
        end)
    end
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
		if carry.LockCamera then
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
		if Engine.Carry.LineDrop then
			Engine.SetAntiGuard(false)
		else
			Engine.SetAntiGuard(FarmConfig.Defense_AntiGuard == true)
		end
		local ok, err = pcall(function()
			local candidates = Engine.CollectCandidates()
			if #candidates == 0 then
				return
			end
			local target = candidates[1]
			Engine.CurrentTarget = target.Uid
			RuntimeState.currentTargetModel = target.PhysicalModel
			if RuntimeState.OnTreadmill then
				pcall(ExitTreadmill)
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
			if Engine.Carry.LockCamera then
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
				if cam and Engine.Carry.LockCamera then
					pcall(function()
						cam.CameraType = Enum.CameraType.Custom
					end)
				end
				return
			end
			if Engine.Carry.LockCamera then
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
function Tasks.ScanTreadmillInPlot(PlotInstance: Instance)
	if not PlotInstance then
		return nil
	end
	local ClientRenders = Workspace:FindFirstChild("__ClientTreadmillRenders")
	if ClientRenders then
		local MyRender = ClientRenders:FindFirstChild("TreadmillRender_" .. PlotInstance.Name)
		if MyRender then
			local Pad = MyRender:FindFirstChild("Belt", true)
				or MyRender:FindFirstChild("RunArea", true)
				or MyRender:FindFirstChild("Pad", true)
				or MyRender:FindFirstChild("Root", true)
				or MyRender:FindFirstChild("BoundingBoxPart", true)
				or MyRender:FindFirstChildWhichIsA("BasePart", true)
			if Pad then
				return Pad
			end
		end
	end
	local Bottom = PlotInstance:FindFirstChild("TreadmillBottom", true)
	if Bottom and Bottom:IsA("BasePart") then
		return Bottom
	end
	local Upgrade = PlotInstance:FindFirstChild("TreadmillUpgrade", true)
	if Upgrade then
		for _, Name in ipairs({ "TreadmillBottom", "Belt", "RunArea", "Platform", "Pad", "Floor", "Base", "Root" }) do
			local Part = Upgrade:FindFirstChild(Name, true)
			if Part and Part:IsA("BasePart") then
				return Part
			end
		end
		local AnyBase = Upgrade:FindFirstChildWhichIsA("BasePart", true)
		if AnyBase then
			return AnyBase
		end
	end
	return nil
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
local function IsPlayerRunningOnTreadmill(): boolean
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not RootPart then
		return false
	end
	local Pad = GetTreadmillPart()
	if not Pad then
		return false
	end
	local HorizDist = (Vector2.new(RootPart.Position.X, RootPart.Position.Z) - Vector2.new(
		Pad.Position.X,
		Pad.Position.Z
	)).Magnitude
	local VertDist = math.abs(RootPart.Position.Y - Pad.Position.Y)
	if HorizDist <= 3.5 and VertDist <= 4 then
		return true
	end
	return false
end
Tasks.AutoStealBelt = GetTreadmillPart
local function ExitTreadmill()
	RuntimeState.OnTreadmill = false
	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if Remotes.RemoteTreadmillDoff then
		task.spawn(function()
			pcall(function()
				Remotes.RemoteTreadmillDoff:InvokeServer()
			end)
		end)
	end
	pcall(function()
		local Pgui = LocalPlayer:FindFirstChild("PlayerGui")
		if Pgui then
			for _, Gui in ipairs(Pgui:GetChildren()) do
				if Gui:IsA("ScreenGui") and Gui.Enabled then
					for _, Btn in ipairs(Gui:GetDescendants()) do
						if (Btn:IsA("TextButton") or Btn:IsA("ImageButton")) and Btn.Visible then
							local Txt = string.lower(Btn:IsA("TextButton") and Btn.Text or Btn.Name)
							if
								string.find(Txt, "get out")
								or string.find(Txt, "doff")
								or string.find(Txt, "exit")
								or string.find(Txt, "leave")
							then
								if typeof(firesignal) == "function" and Btn.Activated then
									firesignal(Btn.Activated)
								elseif typeof(firebutton1click) == "function" then
									firebutton1click(Btn)
								end
								break
							end
						end
					end
				end
			end
			local AnimGui = Pgui:FindFirstChild("SpeedGainAnimation")
			if AnimGui then
				AnimGui:Destroy()
			end
		end
	end)
	if Humanoid then
		pcall(function()
			for _, Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
				local Anim = Track.Animation
				local AnimId = Anim and Anim.AnimationId or ""
				local TrackName = string.lower(Track.Name or "")
				if
					string.find(AnimId, "10921259953")
					or string.find(TrackName, "treadmill")
					or string.find(TrackName, "run")
				then
					Track:Stop(0)
				end
			end
			Humanoid.PlatformStand = false
			Humanoid.Sit = false
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end
	if RootPart then
		RootPart.AssemblyLinearVelocity = Vector3.zero
		RootPart.AssemblyAngularVelocity = Vector3.zero
	end
end
local function MountTreadmill()
	if IsPlayerRunningOnTreadmill() then
		RuntimeState.OnTreadmill = true
		return true
	end
	local Pad = GetTreadmillPart()
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if not Pad or not RootPart or not Humanoid then
		return false
	end
	RootPart.CanTouch = true
	Pad.CanTouch = true
	Pad.CanCollide = true
	local TargetPos = Pad.Position
	if Pad.Name == "BoundingBoxPart" then
		TargetPos = Pad.Position - Vector3.new(0, (Pad.Size.Y / 2) - 1.2, 0)
	else
		TargetPos = Pad.Position + Vector3.new(0, 1.2, 0)
	end
	local Distance = (RootPart.Position - TargetPos).Magnitude
	if Distance > 5 then
		local FlySpeed = math.max(250, FarmConfig.TweenSpeed or 600)
		local Timeout = os.clock() + 6.0
		Humanoid.AutoRotate = false
		while (RootPart.Position - TargetPos).Magnitude > 3.0 and (os.clock() < Timeout) do
			local DeltaTime = RunService.Heartbeat:Wait()
			local CurrentPos = RootPart.Position
			local Delta = (TargetPos - CurrentPos)
			local Step = Delta.Unit * math.min(Delta.Magnitude, FlySpeed * DeltaTime)
			local NextPos = CurrentPos + Step
			RootPart.CFrame =
				CFrame.lookAt(NextPos, NextPos + (Delta.Magnitude > 0.05 and Delta.Unit or RootPart.CFrame.LookVector))
			RootPart.AssemblyLinearVelocity = Vector3.zero
			RootPart.AssemblyAngularVelocity = Vector3.zero
			Humanoid.PlatformStand = false
			Humanoid.Sit = false
			Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
		Humanoid.AutoRotate = true
	end
	RootPart.CFrame = CFrame.new(TargetPos)
	RootPart.AssemblyLinearVelocity = Vector3.zero
	RootPart.AssemblyAngularVelocity = Vector3.zero
	Humanoid.PlatformStand = false
	Humanoid.Sit = false
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
	Humanoid:ChangeState(Enum.HumanoidStateType.Running)
	task.wait(0.05)
	if typeof(firetouchinterest) == "function" then
		firetouchinterest(RootPart, Pad, 0)
		task.wait(0.02)
		firetouchinterest(RootPart, Pad, 1)
	end
	for _, Prompt in ipairs(Pad:GetDescendants()) do
		if Prompt:IsA("ProximityPrompt") and typeof(fireproximityprompt) == "function" then
			fireproximityprompt(Prompt)
		end
	end
	if Pad.Parent then
		for _, Prompt in ipairs(Pad.Parent:GetDescendants()) do
			if Prompt:IsA("ProximityPrompt") and typeof(fireproximityprompt) == "function" then
				fireproximityprompt(Prompt)
			end
		end
	end
	RuntimeState.OnTreadmill = true
	return true
end
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
	local Plot = select(1, GetPlayerPlot())
	if not Plot then
		return
	end
	local UpgradeModel = Plot:FindFirstChild("TreadmillUpgrade", true)
	if not UpgradeModel then
		return
	end
	if Remotes.RemoteTreadmillUpgrade then
		pcall(function()
			Remotes.RemoteTreadmillUpgrade:InvokeServer()
		end)
	end
	local Character = LocalPlayer.Character
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	pcall(function()
		for _, Desc in ipairs(UpgradeModel:GetDescendants()) do
			if Desc:IsA("ProximityPrompt") and Desc.Enabled and typeof(fireproximityprompt) == "function" then
				fireproximityprompt(Desc, 0)
				fireproximityprompt(Desc)
			end
			if Desc:IsA("GuiButton") and Desc.Visible then
				local Txt = string.lower((Desc:IsA("TextButton") and Desc.Text) or Desc.Name)
				if not string.find(Txt, "robux") and (string.find(Txt, "%$") or string.find(Txt, "upgrade")) then
					if typeof(firesignal) == "function" and Desc.Activated then
						firesignal(Desc.Activated)
					elseif typeof(firebutton1click) == "function" then
						firebutton1click(Desc)
					end
				end
			end
			if Desc:IsA("BasePart") and string.find(Desc.Name, "Pad") and RootPart then
				if (RootPart.Position - Desc.Position).Magnitude < 12 and typeof(firetouchinterest) == "function" then
					firetouchinterest(RootPart, Desc, 0)
					task.wait(0.02)
					firetouchinterest(RootPart, Desc, 1)
				end
			end
		end
	end)
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
	local state = GetScrambleState()
	local reqs = (type(state.Requirements) == "table" and state.Requirements) or CachedScrambleReqs
	if type(reqs) ~= "table" or #reqs < 1 then
		return {}, {}, {}, false
	end
	local ok, data = pcall(function()
		return SaveModule.Peek()
	end)
	local inv = (ok and data and type(data.EggInventory) == "table") and data.EggInventory or {}
	local byCat = {}
	for uid, rec in pairs(inv) do
		if type(rec) == "table" and rec.Placement == nil then
			local key = ScrambleCleanName(rec.AssetCategory or rec.Category or "")
			if key ~= "" then
				byCat[key] = byCat[key] or {}
				table.insert(byCat[key], tostring(uid))
			end
		end
	end
	local wantedMap, summaryList, picks = {}, {}, {}
	local ready = true
	for i, need in ipairs(reqs) do
		local key = ScrambleCleanName(need)
		local list = byCat[key]
		local have = list and #list or 0
		local uid = have > 0 and list[1] or nil
		if uid then
			table.insert(picks, uid)
			RuntimeState.ScrambleReserved[uid] = true
		else
			ready = false
			wantedMap[key] = tostring(need)
		end
		table.insert(summaryList, string.format("%s (%d/%d)", tostring(need), have, math.min(i, SCRAMBLE_TRADE_SLOTS)))
	end
	RuntimeState.ScrambleWanted = wantedMap
	return wantedMap, summaryList, picks, ready
end
function DrScramble.AutoRerollLab()
	if not FarmConfig.Scramble_AutoReroll or not Remotes.RemoteScrambleRefresh then
		return false
	end
	local state = GetScrambleState()
	if type(state) ~= "table" or state.Unlocked ~= true then
		return false
	end
	if not DrScramble.LabBannerAllowed(state) then
		return false
	end
	if (tonumber(state.FreeRefreshesRemaining) or 0) <= 0 then
		return false
	end
	if #GetScrambleRequirements() > 0 then
		local _, _, _, ready = GetScrambleTradeStatusFn()
		if ready then
			return false
		end
	end
	local ok, res = pcall(function()
		return Remotes.RemoteScrambleRefresh:InvokeServer()
	end)
	if ok and res ~= false then
		CachedScrambleState = {}
		LastScrambleReqFetch = 0
		pcall(RefreshScrambleState, true)
		return true
	end
	return false
end
local function ExecuteScrambleTradeIn()
	if not Remotes.RemoteScrambleTradeIn then
		return false
	end
	local state = GetScrambleState()
	if type(state) == "table" and not DrScramble.LabBannerAllowed(state) then
		return false
	end
	local reqs = (type(state.Requirements) == "table" and state.Requirements) or CachedScrambleReqs
	if type(reqs) ~= "table" or #reqs < SCRAMBLE_TRADE_SLOTS then
		return false
	end
	local _, _, picks, ready = GetScrambleTradeStatusFn()
	if not ready or #picks < SCRAMBLE_TRADE_SLOTS then
		return false
	end
	local EngineNow = RuntimeState.StealEngine
	local carryingNow = EngineNow
		and EngineNow.State
		and (EngineNow.State.Carrying or EngineNow.State.SignalCarrying or EngineNow.State.WeldCarrying)
	if not carryingNow then
		pcall(UnequipAllTools)
		task.wait(0.1)
	end
	local ok, res, extra = pcall(function()
		return Remotes.RemoteScrambleTradeIn:InvokeServer(picks)
	end)
	if ok and res == true then
		local labCat = nil
		if type(extra) == "table" then
			labCat = extra.AssetCategory or extra.Category or extra.Name
		end
		if type(labCat) == "string" and labCat ~= "" then
			RuntimeState.ScrambleLabCategory = labCat
		end
		CachedScrambleState = {}
		LastScrambleReqFetch = 0
		table.clear(RuntimeState.ScrambleReserved)
		task.wait(0.8)
		if Remotes.RemoteScrambleFinishReveal then
			pcall(function()
				Remotes.RemoteScrambleFinishReveal:InvokeServer()
			end)
		end
		RefreshScrambleState(true)
		return true
	end
	if not ok then
	else
	end
	return false
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
		Unlocked = state.Unlocked ~= false,
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
				if RuntimeState.OnTreadmill then
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
	FarmEggGroup:AddSlider("Slider_Farm_TweenSpeed", {
		Text = "Tween Speed",
		Min = 100,
		Max = 1000,
		Default = 400,
		Rounding = 0,
		Tooltip = "Auto steal approach and delivery speed (studs/s). Does not change Instant Steal.",
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
			if State and DefenseAntiGuardToggle and DefenseAntiGuardToggle.Set then
				pcall(DefenseAntiGuardToggle.Set, DefenseAntiGuardToggle, false)
			end
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
					if hrp then
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
		return (ok and result) or RuntimeState.OnTreadmill == true
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
		'<font color="#D946EF"><b>Trophies:</b></font> 0   <font color="#D946EF"><b>Wins:</b></font> 0   <font color="#D946EF"><b>Racer:</b></font> Ostrich',
		true
	)
	task.spawn(function()
		local LastS, LastT = nil, nil
		while true do
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
					'<font color="#D946EF"><b>Trophies:</b></font> %s   <font color="#D946EF"><b>Wins:</b></font> %s   <font color="#D946EF"><b>Racer:</b></font> %s',
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
	RaceRallyGroup:AddDropdown("Dropdown_Race_Racer", {
		Text = "Racer",
		Values = { "Best Owned", "Ostrich", "Seahorse", "Lizard", "Bird", "Cheetah", "Engine Snail" },
		Default = "Best Owned",
		Multi = false,
		AllowNull = false,
		Tooltip = "Racer to use",
		Callback = function(Selected)
			FarmConfig.Race_Racer = tostring(Selected or "Best Owned")
		end,
	})
	RaceRallyGroup:AddDropdown("Dropdown_Race_ShopItems", {
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
	RaceRallyGroup:AddToggle("Toggle_Race_AutoEquip", {
		Text = "Auto Equip Racer",
		Default = true,
		Tooltip = "Auto equip racer",
		Callback = function(State)
			FarmConfig.Race_AutoEquip = State == true
		end,
	})
	RaceRallyGroup:AddToggle("Toggle_Race_AutoBuy", {
		Text = "Auto Buy Race Shop",
		Default = false,
		Tooltip = "Auto buy shop items",
		Callback = function(State)
			FarmConfig.Race_AutoBuy = State == true
		end,
	})
	RaceRallyGroup:AddSlider("Slider_Race_Speed", {
		Text = "Race Speed",
		Min = 100,
		Max = 400,
		Default = 300,
		Rounding = 0,
		Tooltip = "Track speed",
		Callback = function(Value)
			FarmConfig.Race_Speed = math.clamp(math.floor(tonumber(Value) or 300), 100, 400)
		end,
	})
	RaceRallyGroup:AddToggle("Toggle_Race_AutoRace", {
		Text = "Auto Race",
		Default = false,
		Tooltip = "Auto join & race",
		Callback = function(State)
			FarmConfig.Race_AutoRace = State == true
		end,
	})
	RaceRallyGroup:AddToggle("Toggle_Race_PowerUps", {
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
	local ScrambleEggGroup = EventTab:AddRightGroupbox("Scramble Egg", "flask-conical")
	local ScrambleLabUI = {
		Trade = ScrambleEggGroup:AddLabel('<font color="#D946EF"><b>Trade-In:</b></font> 0/3\n1. -\n2. -\n3. -', true),
	}
	ScrambleEggGroup:AddToggle("Toggle_AutoScrambleSteal", {
		Text = "Auto Steal Lab Eggs",
		Default = false,
		Tooltip = "Steal lab wants",
		Callback = function(State)
			FarmConfig.AutoScrambleSteal = State
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
			pcall(GetScrambleTradeStatusFn)
		end,
	})
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
						local isReady = info.Picks[i] ~= nil
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
	while true do
		task.wait(1.5)
		pcall(function()
            local Engine = RuntimeState.StealEngine
            if Engine and Engine.AutoCycle then return end
			if FarmConfig.AntiTreadmill and not FarmConfig.AutoTreadmill then
				if IsPlayerRunningOnTreadmill() then
					ExitTreadmill()
					local char = LocalPlayer.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hrp then
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
			if FarmConfig.AutoTreadmill and not IsStealActive() and not RuntimeState.IsExecuting then
				MountTreadmill()
			end
		end)
	end
end
task.spawn(Tasks.AutomationLoop)
function Tasks.ScrambleTradeLoop()
	while true do
		task.wait(2.0)
		pcall(function()
			if Tasks.PriorityStealYield and Tasks.PriorityStealYield() then
				return
			end
			local live = FarmConfig.AutoScrambleSteal or FarmConfig.AutoScrambleSubmit
			if live or os.clock() - (RuntimeState.ScrambleStateAt or 0) > 10 then
				RefreshScrambleState()
				RuntimeState.ScrambleStateAt = os.clock()
			end
			if live then
				GetScrambleTradeStatusFn()
			end
			if FarmConfig.AutoScrambleSubmit then
				DrScramble.AutoRerollLab()
				ExecuteScrambleTradeIn()
			end
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
					elseif FarmConfig.AutoTreadmill and not RuntimeState.OnTreadmill then
						MountTreadmill()
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
	if LocalPlayer.Character ~= NewCharacter then
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
do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local CollectionService = game:GetService("CollectionService")
	local LocalPlayer = Players.LocalPlayer
	local St = {
		Driving = nil,
		Travelling = false,
		JoinTriedAt = 0,
		LeaveAt = 0,
		EquipAt = 0,
		ClaimAt = 0,
		PowerAt = 0,
		Drop = 0,
		LapSeen = nil,
		LapAt = nil,
		RemCache = {},
	}
	Tasks.RaceState = { Status = "Off", Tokens = "0", Wins = "0", Racer = "Ostrich" }
	local RaceData, PathMod, Sched = nil, nil, nil
	local function GetRaceData()
		if RaceData ~= nil then
			return RaceData or nil
		end
		local D = ReplicatedStorage:FindFirstChild("Data")
		local M = D and D:FindFirstChild("RaceRally")
		local ok, mod = pcall(function()
			return require(M)
		end)
		RaceData = (ok and mod) and mod or false
		return RaceData or nil
	end
	local function GetPathMod()
		if PathMod ~= nil then
			return PathMod or nil
		end
		local S = ReplicatedStorage:FindFirstChild("Shared")
		local M = S and S:FindFirstChild("Modules")
		local P = M and M:FindFirstChild("RaceTrackPath")
		local ok, mod = pcall(function()
			return require(P)
		end)
		PathMod = (ok and mod) and mod or false
		return PathMod or nil
	end
	local function Rem(FullName, Short)
		local C = St.RemCache[FullName]
		if C == nil then
			C = FindRemote(FullName, Short) or false
			St.RemCache[FullName] = C
		end
		return C or nil
	end
	local function SetStatus(Text)
		Tasks.RaceState.Status = Text
	end
	local function FmtTime(N)
		N = math.max(math.ceil(N), 0)
		return string.format("%d:%02d", N // 60, N % 60)
	end
	local function Root()
		local Char = LocalPlayer.Character
		return Char and Char:FindFirstChild("HumanoidRootPart")
	end
	local function GetTrack()
		return Workspace:FindFirstChild("RaceTrack")
	end
	local function GetPortal()
		local W = Workspace:FindFirstChild("World")
		local P = W and W:FindFirstChild("RaceRallyPortal")
		return (P and P:FindFirstChild("Hitbox")) or nil
	end
	local function JoinOpen()
		if Workspace:GetAttribute("RaceRallyRunning") ~= true then
			return false
		end
		local T = Workspace:GetAttribute("RaceRallyJoinEndsAt")
		return type(T) == "number" and Workspace:GetServerTimeNow() < T
	end
	local function InRace()
		return LocalPlayer:GetAttribute("RaceId") ~= nil
	end
	Tasks.RacePriority = function()
		if FarmConfig.Race_AutoRace ~= true then
			return false
		end
		return InRace() or JoinOpen() or St.Travelling == true
	end
	local function SpeedNow()
		return math.max((tonumber(FarmConfig.Race_Speed) or 300) - (St.Drop or 0), 100)
	end
	local function SlowDown()
		if SpeedNow() <= 100 then
			return
		end
		St.Drop = (St.Drop or 0) + 50
	end
	local function SaveRace()
		if not (SaveModule and type(SaveModule.Peek) == "function") then
			return nil
		end
		local ok, sData = pcall(SaveModule.Peek)
		if ok and type(sData) == "table" and type(sData.RaceRally) == "table" then
			return sData.RaceRally
		end
		return nil
	end
	local function StopDrive()
		local D = St.Driving
		St.Driving = nil
		if D then
			for _, C in ipairs(D.Connections) do
				pcall(function()
					C:Disconnect()
				end)
			end
		end
	end
	local function ApplyDrive()
		local D = St.Driving
		if not D then
			return
		end
		local Hrp = Root()
		if not Hrp then
			return
		end
		local Frame = D.Path:FrameAt(D.Progress)
		if os.clock() >= D.CheckAt then
			D.CheckAt = os.clock() + 1
			local Want = Frame.Position + Frame.UpVector * D.Lift
			if (Hrp.Position - Want).Magnitude > 40 then
				D.Progress = D.Path:Project(Hrp.Position, D.Progress, 300, 300)
				Frame = D.Path:FrameAt(D.Progress)
				local Now = os.clock()
				if D.PulledAt and Now - D.PulledAt < 6 then
					D.PulledAt = nil
					St.LapAt = Now
					SlowDown()
				else
					D.PulledAt = Now
				end
			end
		end
		Hrp.CFrame = Frame + Frame.UpVector * D.Lift
		Hrp.AssemblyLinearVelocity = Frame.LookVector * SpeedNow()
		Hrp.AssemblyAngularVelocity = Vector3.zero
	end
	local function StartDrive(Track)
		if St.Driving then
			return true
		end
		local Hrp = Root()
		local Att = Track and Track:FindFirstChild("AttachmentTrack")
		local P = GetPathMod()
		if not (Hrp and Att and P) then
			return false
		end
		local ok, Path = pcall(P.new, Att)
		if not ok or Path == nil then
			return false
		end
		local ok2, Progress = pcall(Path.Project, Path, Hrp.Position, Path.Length / 2, Path.Length / 2, Path.Length / 2)
		if not ok2 then
			return false
		end
		local Frame = Path:FrameAt(Progress)
		local Lift = math.max((Hrp.Position - Frame.Position):Dot(Frame.UpVector), 2)
		local D = {
			Path = Path,
			Track = Track,
			Progress = Progress,
			Lift = Lift,
			Connections = {},
			CheckAt = 0,
			PulledAt = nil,
			Life = LocalPlayer.Character,
		}
		St.Driving = D
		table.insert(
			D.Connections,
			RunService.Heartbeat:Connect(function(Dt)
				if St.Driving ~= D or LocalPlayer.Character ~= D.Life then
					return
				end
				D.Progress = D.Progress + SpeedNow() * Dt
				pcall(ApplyDrive)
			end)
		)
		table.insert(
			D.Connections,
			RunService.PreSimulation:Connect(function()
				if St.Driving == D then
					pcall(ApplyDrive)
				end
			end)
		)
		return true
	end
	local function DoPowerups()
		if FarmConfig.Race_PowerUps ~= true then
			return
		end
		local Now = Workspace:GetServerTimeNow()
		local Hrp = Root()
		local D = St.Driving
		if not (Hrp and D) then
			return
		end
		local RemP = Rem("RE/MountRace/PowerUp", "PowerUp")
		if not RemP then
			return
		end
		local Item = LocalPlayer:GetAttribute("RacePowerUp")
		if type(Item) == "string" and Item ~= "" then
			local Rolling = (tonumber(LocalPlayer:GetAttribute("RacePowerUpRollEndsAt")) or 0) > Now
			local Effect = (tonumber(LocalPlayer:GetAttribute("RacePowerUpEffectEndsAt")) or 0) > Now
			local Stun = (tonumber(LocalPlayer:GetAttribute("RacePowerUpStunEndsAt")) or 0) > Now
			if not (Rolling or Effect or Stun) then
				local Frame = D.Path:FrameAt(D.Progress)
				pcall(function()
					RemP:FireServer("Use", Hrp.Position, Frame.LookVector)
				end)
			end
			return
		end
		for _, Box in ipairs(CollectionService:GetTagged("RacePowerUpSpawn")) do
			if Box:IsDescendantOf(D.Track or Workspace) then
				local ReadyAt = Box:GetAttribute("RaceBoxReadyAt")
				local Pad = Box:FindFirstChild("Pad") or Box.PrimaryPart or Box:FindFirstChildWhichIsA("BasePart")
				if
					Pad
					and (type(ReadyAt) ~= "number" or ReadyAt <= Now)
					and (Pad.Position - Hrp.Position).Magnitude <= 30
				then
					pcall(function()
						RemP:FireServer("Pickup", Box)
					end)
					break
				end
			end
		end
	end
	local function FlyTo(GetTarget, CancelFn, Speed, Timeout)
		local Start = os.clock()
		while os.clock() - Start < (Timeout or 30) do
			if CancelFn and CancelFn() then
				return false
			end
			local Target = GetTarget()
			if not Target then
				return true
			end
			local Hrp = Root()
			if not Hrp then
				return false
			end
			local Delta = Target - Hrp.Position
			if Delta.Magnitude <= 5 then
				return true
			end
			local Step = math.min(Speed * RunService.Heartbeat:Wait(), Delta.Magnitude)
			pcall(function()
				Hrp.CFrame = CFrame.new(Hrp.Position + Delta.Unit * Step) * Hrp.CFrame.Rotation
				Hrp.AssemblyLinearVelocity = Vector3.zero
			end)
		end
		return false
	end
	local function DoEquip()
		if FarmConfig.Race_AutoEquip ~= true or os.clock() < St.EquipAt then
			return
		end
		local Save, Data = SaveRace(), GetRaceData()
		if not (Save and Data and type(Data.Racers) == "table") then
			return
		end
		local Owned = {}
		for Id, Def in pairs(Data.Racers) do
			if (type(Save.Racers) == "table" and Save.Racers[Id] == true) or Id == Data.DefaultRacer then
				table.insert(Owned, { Id = Id, Name = Def.DisplayName, Order = Def.Order })
			end
		end
		table.sort(Owned, function(A, B)
			return A.Order > B.Order
		end)
		local Want = (Owned[1] and Owned[1].Id) or Data.DefaultRacer
		local Pref = tostring(FarmConfig.Race_Racer or "Best Owned")
		if Pref ~= "Best Owned" then
			for _, R in ipairs(Owned) do
				if R.Name == Pref then
					Want = R.Id
					break
				end
			end
		end
		local Equipped = tostring(Save.EquippedRacer or "")
		if Equipped == "" then
			Equipped = Data.DefaultRacer
		end
		if Want ~= Equipped then
			St.EquipAt = os.clock() + 2
			local R = Rem("RF/RaceRally/AskEquipRacer", "AskEquipRacer")
			if R then
				pcall(function()
					R:InvokeServer(Want)
				end)
			end
		end
	end
	local function DoClaim()
		if FarmConfig.Race_AutoClaim ~= true or os.clock() < St.ClaimAt then
			return
		end
		St.ClaimAt = os.clock() + 5
		local Save, Data = SaveRace(), GetRaceData()
		if not (Save and Data) then
			return
		end
		local R = Rem("RF/RaceRally/AskClaimMilestone", "AskClaimMilestone")
		if not R then
			return
		end
		local Claimed = (type(Save.Milestones) == "table" and Save.Milestones) or {}
		if type(Data.Milestones) == "table" then
			for Id, Def in pairs(Data.Milestones) do
				if not Claimed[Id] and (tonumber(Save.Wins) or 0) >= Def.Wins then
					pcall(function()
						R:InvokeServer(Id)
					end)
					task.wait(0.15)
				end
			end
		end
		if type(Data.Repeat) == "table" and type(Data.RepeatsEarned) == "function" then
			local ok, Earned = pcall(Data.RepeatsEarned, tonumber(Save.Wins) or 0)
			if ok and (tonumber(Save.Repeats) or 0) < Earned then
				pcall(function()
					R:InvokeServer(tostring(Data.RepeatId or "Repeat"))
				end)
			end
		end
	end
	local ShopNames = {
		{ Id = "MutationToken", Name = "Nitro Mutation" },
		{ Id = "CashBooster", Name = "Cash Booster" },
		{ Id = "SpeedBoost", Name = "Speed Boost" },
		{ Id = "TreadmillBoost", Name = "Treadmill Boost" },
		{ Id = "RacingBat", Name = "Racing Bat" },
	}
	local function DoBuy()
		if FarmConfig.Race_AutoBuy ~= true then
			return
		end
		local Save, Data = SaveRace(), GetRaceData()
		if not (Save and Data and type(Data.Shop) == "table") then
			return
		end
		local Picks = FarmConfig.Race_ShopItems or {}
		local Tokens = tonumber(Save.Tokens) or 0
		local R = Rem("RF/RaceRally/AskBuy", "AskBuy")
		if not R then
			return
		end
		for _, Item in ipairs(ShopNames) do
			if Picks[string.lower(Item.Name)] then
				local Def = Data.Shop[Item.Id]
				if Def and Tokens >= Def.Price then
					local Purch = (type(Save.Purchases) == "table" and Save.Purchases[Item.Id]) or nil
					local Count = Purch and tonumber(Purch.Count) or 0
					if Def.Limit == 0 or Count < Def.Limit then
						local ok, Res = pcall(function()
							return R:InvokeServer(Item.Id)
						end)
						if ok and Res then
							Tokens = Tokens - Def.Price
						end
						task.wait(0.15)
					end
				end
			end
		end
	end
	local function StatusIdle()
		local Now = Workspace:GetServerTimeNow()
		local Running = Workspace:GetAttribute("RaceRallyRunning") == true
		local JoinEnds = Workspace:GetAttribute("RaceRallyJoinEndsAt")
		if Running and type(JoinEnds) == "number" and Now < JoinEnds then
			return "Racing Event open, " .. FmtTime(JoinEnds - Now) .. " to join"
		end
		local NextAt = nil
		if Sched == nil then
			local S = ReplicatedStorage:FindFirstChild("Shared")
			local U = S and S:FindFirstChild("Util")
			local M = U and U:FindFirstChild("RaceRallySchedule")
			local ok, mod = pcall(function()
				return require(M)
			end)
			Sched = (ok and mod) and mod or false
		end
		if type(Sched) == "table" and type(Sched.NextOpening) == "function" then
			local ok, T = pcall(Sched.NextOpening, Now)
			if ok and type(T) == "number" then
				NextAt = T
			end
		end
		NextAt = NextAt or ((math.floor(Now / 1800) + 1) * 1800)
		return (Running and "Racing Event running, next in " or "Next Racing Event in ") .. FmtTime(NextAt - Now)
	end
	local function RaceTick()
		local Save = SaveRace()
		if Save then
			local Data = GetRaceData()
			local RS = Tasks.RaceState
			RS.Tokens = tostring(Save.Tokens or 0)
			RS.Wins = tostring(Save.Wins or 0)
			local Eq = tostring(Save.EquippedRacer or "")
			local Def = Data and Data.Racers and Data.Racers[(Eq ~= "" and Eq or (Data and Data.DefaultRacer or ""))]
			RS.Racer = (Def and Def.DisplayName) or "Ostrich"
		end
		local Track = GetTrack()
		if InRace() then
			if FarmConfig.Race_AutoRace ~= true then
				StopDrive()
				SetStatus("Off")
				return
			end
			local Finish = LocalPlayer:GetAttribute("RaceFinishPlace")
			if type(Finish) == "number" then
				StopDrive()
				if os.clock() >= St.LeaveAt then
					St.LeaveAt = os.clock() + 2
					local R = Rem("RE/MountRace/AskLeave", "AskLeave")
					if R then
						pcall(function()
							R:FireServer()
						end)
					end
					SetStatus("Finished " .. tostring(Finish) .. ", leaving the race")
				else
					SetStatus("Finished " .. tostring(Finish) .. ", waiting for results")
				end
				return
			end
			local Phase = Track and Track:GetAttribute("RacePhase")
			local GoAt = Track and Track:GetAttribute("RaceGoAt")
			if Phase == "Racing" and type(GoAt) == "number" and Workspace:GetServerTimeNow() >= GoAt then
				if St.Driving and LocalPlayer.Character ~= St.Driving.Life then
					StopDrive()
				end
				local Lap = LocalPlayer:GetAttribute("RaceLap")
				if Lap ~= St.LapSeen then
					St.LapSeen, St.LapAt = Lap, os.clock()
				end
				if St.Driving then
					local Len = St.Driving.Path.Length
					if os.clock() - (St.LapAt or os.clock()) > Len / SpeedNow() * 1.5 + 8 then
						St.LapAt = os.clock()
						StopDrive()
						SlowDown()
					end
				end
				if St.Driving == nil then
					StartDrive(Track)
				end
				if St.Driving and os.clock() >= St.PowerAt then
					St.PowerAt = os.clock() + 0.2
					pcall(DoPowerups)
				end
				SetStatus(
					string.format(
						"Racing, lap %s/%s, place %s",
						tostring(Lap or "?"),
						tostring((Track and Track:GetAttribute("RaceLaps")) or 3),
						tostring(LocalPlayer:GetAttribute("RacePlace") or "?")
					)
				)
			else
				StopDrive()
				SetStatus("In the race, waiting for the start")
			end
			return
		end
		StopDrive()
		St.LapSeen, St.LapAt = nil, nil
		St.Drop = 0
		pcall(DoEquip)
		pcall(DoClaim)
		pcall(DoBuy)
		if FarmConfig.Race_AutoRace ~= true then
			SetStatus("Off")
			return
		end
		if not JoinOpen() then
			SetStatus(StatusIdle())
			return
		end
		local Hitbox = GetPortal()
		if not Hitbox then
			SetStatus("Race open, portal not found")
			return
		end
		local Hrp = Root()
		if not Hrp then
			return
		end
		if (Hrp.Position - Hitbox.Position).Magnitude > 80 then
			if St.Travelling then
				return
			end
			St.Travelling = true
			SetStatus("Flying to the race portal")
			task.spawn(function()
				pcall(function()
					FlyTo(function()
						local B = GetPortal()
						return B and (B.Position + Vector3.new(0, 3, 0)) or nil
					end, function()
						return InRace() or FarmConfig.Race_AutoRace ~= true
					end, 350, 30)
				end)
				St.Travelling = false
			end)
			return
		end
		if os.clock() - St.JoinTriedAt >= 0.5 then
			St.JoinTriedAt = os.clock()
			SetStatus("Joining the race")
			pcall(function()
				Hrp.CFrame = Hitbox.CFrame
				Hrp.AssemblyLinearVelocity = Vector3.zero
			end)
			if type(firetouchinterest) == "function" then
				pcall(firetouchinterest, Hrp, Hitbox, 0)
				pcall(firetouchinterest, Hrp, Hitbox, 1)
			end
		end
	end
	task.spawn(function()
		while true do
			task.wait(0.25)
			pcall(RaceTick)
		end
	end)
end
LocalPlayer.CharacterAdded:Connect(Tasks.OnCharacterAdded)
Tasks.Loading:SetMessage("Load All Requirements")
Tasks.Loading:SetCurrentStep(4)
Tasks.Loading:SetDescription("Building the window, tabs & all N3 Hub features...")
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
				end
			end
		end)
	end
end
function Tasks.InitialCharacterSetup()
	task.wait(0.5)
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
			local Engine = RuntimeState.StealEngine
			local Moving = false
			if Engine and Engine.Guard then
				Moving = Engine.Guard.StealActive == true
			end
			local Busy = IsStealActive()
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

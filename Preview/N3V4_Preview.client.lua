--[[
	================================================================================
	 N3V4 — PREVIEW KIT   (LocalScript)
	================================================================================

	 APA INI?
	   Preview lengkap SEMUA fitur UI yang ada di library N3 lu.
	   Tujuannya: lu bisa lihat & klik-klik seluruh komponen di Roblox Studio
	   tanpa harus jalanin hub 18.000 baris.

	 CARA PAKAI (3 langkah):
	   1. Library lu  -> ModuleScript di ReplicatedStorage, nama: N3V4
	                     (isi = seluruh kode N3V3-NoObfus.lua, baris terakhir
	                      harus "return Library")
	   2. Script INI  -> LocalScript di StarterPlayer > StarterPlayerScripts
	                     nama rekomendasi: N3V4_Preview
	   3. Game Settings > Security > Allow HTTP Requests = ON
	                     (buat icon lucide + asset library)
	   Tekan Play.

	 CATATAN STUDIO:
	   - writefile/getcustomasset nggak ada di Studio, jadi SaveManager nggak
	     nyimpen config. Itu NORMAL, bukan bug.
	   - Icon nggak muncul? Berarti HTTP Requests masih OFF.
	   - Tiap section dibungkus pcall. Komponen yang gagal NGGAK bikin script
	     mati. Laporan lengkap ke-print di Output.

	 API YANG DIPAKE DISINI 100% HASIL VERIFIKASI DARI SOURCE LU:
	   Notify        -> return Data { ChangeTitle, ChangeDescription, ChangeStep, Resize, Destroy }
	   CreateOverlay -> return Self { SetRow, RemoveRow, ClearRows, SetVisible, Destroy }
	   Dashboard     -> return Self { SetRow, RemoveRow, ClearRows, Destroy }
	   DraggableMenu -> return Holder, Container (raw Instance, tanpa method)
	   DraggableLabel-> return { SetText, SetIcon, SetIconPosition, SetVisible, Destroy }
	   AddKeyBox     -> Callback(Text)
	   AddFooterButton-> (Idx, { Title, Variant, Order, WaitTime, Callback(Dialog) })

	================================================================================
]]

--// SERVICES \\--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

--================================================================================
-- CONFIG — ubah bagian ini aja, nggak usah ngoprek yang bawah
--================================================================================
local CONFIG = {
	-- Nama ModuleScript library lu. Gue cari di ReplicatedStorage dulu; kalau
	-- nggak ketemu, gue scan seluruh DataModel. Jadi mau ditaruh di mana pun kebaca.
	ModuleName = "N3V4",

	-- Identitas window preview
	Title = "N3 HUB",
	Footer = "N3V4 • UI Preview Kit",
	Icon = "rbxassetid://117688744510818",

	-- Asset buat demo Image / SpotlightCard / Dropdown ValueImages / Feed icon
	ImageAsset = "rbxassetid://117688744510818",

	-- Demo Video butuh asset ID VideoFrame punya lu. Kosongin ("") = di-skip.
	VideoAsset = "",

	-- Loading screen pembuka
	ShowLoadingIntro = true,
	LoadingSteps = 5,
	LoadingStepDelay = 0.45,

	-- Keybind toggle UI
	ToggleKey = Enum.KeyCode.RightControl,

	-- Set false kalau lu nggak mau warning error per-komponen di Output
	VerboseErrors = true,
}

--================================================================================
-- 1. REPORT HELPER
--================================================================================
local Report = { OK = {}, Failed = {} }

local function Try(Label, Func)
	local Success, Result = pcall(Func)
	if Success then
		table.insert(Report.OK, Label)
		return true, Result
	end

	table.insert(Report.Failed, string.format("%s  ->  %s", Label, tostring(Result)))
	if CONFIG.VerboseErrors then
		warn(string.format("[N3V4 Preview] GAGAL: %s | %s", Label, tostring(Result)))
	end
	return false, Result
end

local function PrintReport()
	print("===================================================")
	print("  N3V4 PREVIEW KIT — LAPORAN KOMPONEN")
	print("===================================================")
	print(string.format("  ✅ BERHASIL : %d", #Report.OK))
	for _, Name in ipairs(Report.OK) do
		print("      • " .. Name)
	end

	print(string.format("  ❌ GAGAL    : %d", #Report.Failed))
	if #Report.Failed > 0 then
		for _, Name in ipairs(Report.Failed) do
			print("      • " .. Name)
		end
	else
		print("      (nggak ada — semua komponen jalan 🎉)")
	end
	print("===================================================")
end

--================================================================================
-- 2. RESOLVE LIBRARY MODULE
--================================================================================
local function FindModule(Name)
	local Direct = ReplicatedStorage:FindFirstChild(Name)
	if Direct and Direct:IsA("ModuleScript") then
		return Direct
	end

	local Scanned = game:FindFirstChild(Name, true)
	if Scanned and Scanned:IsA("ModuleScript") then
		return Scanned
	end

	return nil
end

local ModuleObject, Waited = nil, 0
while not ModuleObject and Waited < 15 do
	ModuleObject = FindModule(CONFIG.ModuleName)
	if not ModuleObject then
		task.wait(0.25)
		Waited = Waited + 0.25
	end
end

if not ModuleObject then
	error(string.format(
		"[N3V4 Preview] ModuleScript %q nggak ketemu (nunggu 15 detik).\n"
			.. "  -> Bikinn ModuleScript bernama %q di ReplicatedStorage\n"
			.. "  -> Isi = seluruh kode library N3V3-NoObfus.lua",
		CONFIG.ModuleName, CONFIG.ModuleName
	), 0)
end

local Library = require(ModuleObject)

if typeof(Library) ~= "table" or typeof(Library.CreateWindow) ~= "function" then
	error("[N3V4 Preview] Module N3V4 nggak nge-return Library yang valid.\n"
		.. "  -> Pastikan baris terakhir library lu: return Library", 0)
end

print(string.format(
	"[N3V4 Preview] Library OK | Device: %s | Mobile: %s | DPIScale: %s | CornerRadius: %s",
	tostring(Library.DevicePlatform), tostring(Library.IsMobile),
	tostring(Library.DPIScale), tostring(Library.CornerRadius)
))

-- Notify wrapper: icon lucide butuh HTTP. Kalau HTTP off, jangan bikin error.
local function SafeNotify(Info)
	local Success, Err = pcall(function()
		return Library:Notify(Info)
	end)
	if not Success and CONFIG.VerboseErrors then
		warn("[N3V4 Preview] Notify gagal: " .. tostring(Err))
	end
	return Success
end

-- Font resolver: beberapa Enum.Font nggak ada di versi Studio lama
local function GetFontEnum(Name)
	local Success, FontEnum = pcall(function()
		return Enum.Font[Name]
	end)
	if Success and FontEnum then
		return FontEnum
	end
	return nil
end

--================================================================================
-- 3. DEMO ASSETS (dibikin runtime, nggak nyampahin Workspace)
--================================================================================
local function BuildDemoEgg()
	local Model = Instance.new("Model")
	Model.Name = "N3V4_DemoEgg"

	local Egg = Instance.new("Part")
	Egg.Name = "Body"
	Egg.Shape = Enum.PartType.Ball
	Egg.Size = Vector3.new(4, 5.2, 4)
	Egg.CFrame = CFrame.new(0, 0, 0)
	Egg.Color = Color3.fromRGB(218, 98, 255)
	Egg.Material = Enum.Material.Neon
	Egg.Anchored = true
	Egg.CanCollide = false
	Egg.Parent = Model

	local Ring = Instance.new("Part")
	Ring.Name = "Ring"
	Ring.Shape = Enum.PartType.Cylinder
	Ring.Size = Vector3.new(0.35, 7.6, 7.6)
	Ring.CFrame = CFrame.Angles(0, 0, math.rad(90)) * CFrame.Angles(math.rad(18), 0, 0)
	Ring.Color = Color3.fromRGB(90, 220, 255)
	Ring.Material = Enum.Material.Neon
	Ring.Anchored = true
	Ring.CanCollide = false
	Ring.Parent = Model

	local Core = Instance.new("Part")
	Core.Name = "Core"
	Core.Shape = Enum.PartType.Ball
	Core.Size = Vector3.new(1.4, 1.4, 1.4)
	Core.CFrame = CFrame.new(0, 0, 0)
	Core.Color = Color3.fromRGB(255, 255, 255)
	Core.Material = Enum.Material.ForceField
	Core.Transparency = 0.25
	Core.Anchored = true
	Core.CanCollide = false
	Core.Parent = Model

	Model.PrimaryPart = Egg
	-- Parent ke script: aman, nggak muncul di dunia game, tapi tetap bisa di-Clone()
	Model.Parent = script

	return Model
end

local function BuildPassthroughFrame()
	local Holder = Instance.new("Frame")
	Holder.Name = "N3V4_PassthroughDemo"
	Holder.Size = UDim2.fromScale(1, 1)
	Holder.BackgroundTransparency = 1

	local Text = Instance.new("TextLabel")
	Text.Size = UDim2.new(1, 0, 0, 14)
	Text.Position = UDim2.new(0, 0, 0, 0)
	Text.BackgroundTransparency = 1
	Text.Text = "Frame custom lu (UIPassthrough) — 62%"
	Text.TextSize = 12
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.fromRGB(220, 220, 220)
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.Parent = Holder

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(1, 0, 0, 8)
	Bar.Position = UDim2.new(0, 0, 0.5, 2)
	Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Bar.BorderSizePixel = 0
	Bar.Parent = Holder
	Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.fromScale(0.62, 1)
	Fill.BackgroundColor3 = Color3.fromRGB(90, 220, 255)
	Fill.BorderSizePixel = 0
	Fill.Parent = Bar
	Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

	Holder.Parent = script
	return Holder
end

local DemoEgg = BuildDemoEgg()
local PassthroughFrame = BuildPassthroughFrame()

--================================================================================
-- 4. LOADING SCREEN INTRO
--================================================================================
local LoadingMessages = {
	{ "Load Engine", "Preparing services, remotes & runtime core..." },
	{ "Load Data Replica", "Loading game data replicas: EggState, EggRecords, Save..." },
	{ "Load Library", "N3V4 UI Library, SaveManager & ThemeManager..." },
	{ "Build Interface", "Constructing main window, tabs & groupboxes..." },
	{ "Ready", "All systems online. Enjoy the preview." },
}

local function RunLoadingSequence()
	if Library.ActiveLoading then
		Library.ActiveLoading:Destroy()
		task.wait(0.1)
	end

	local Loading = Library:CreateLoading({
		Title = CONFIG.Title,
		Icon = CONFIG.Icon,
		TotalSteps = CONFIG.LoadingSteps,
		CurrentStep = 1,
		ShowSidebar = false,
		AutoResizeHeight = true,
	})

	task.spawn(function()
		for Step = 1, CONFIG.LoadingSteps do
			local Msg = LoadingMessages[Step] or { "Step " .. Step, "Working..." }
			Loading:SetCurrentStep(Step)
			Loading:SetMessage(Msg[1])
			Loading:SetDescription(Msg[2])
			task.wait(CONFIG.LoadingStepDelay)
		end
		task.wait(0.35)
		Loading:Destroy()
	end)
end

if CONFIG.ShowLoadingIntro then
	Try("Loading Screen (intro)", function()
		RunLoadingSequence()
		-- Tunggu intro kelar dulu sebelum bikin window
		task.wait((CONFIG.LoadingStepDelay * CONFIG.LoadingSteps) + 0.7)
	end)
end

--================================================================================
-- 5. MAIN WINDOW
--================================================================================
local Window = Library:CreateWindow({
	Title = CONFIG.Title,
	Footer = CONFIG.Footer,
	Icon = CONFIG.Icon,
	AutoShow = true,
	Center = true,
	Resizable = true,
	ToggleKeybind = CONFIG.ToggleKey,
	Animations = {
		ToggleWindow = true,
		TabSwitch = true,
		Groupbox = true,
		Dropdown = true,
		KeyPicker = true,
	},
})

--================================================================================
-- TAB 1 — OVERVIEW
--================================================================================
local OverviewTab = Window:AddTab("Overview", "layout-dashboard", "Ringkasan elemen visual utama")

Try("Overview: Groupbox kiri (Spotlight + Label + Divider)", function()
	local Box = OverviewTab:AddLeftGroupbox("Selamat Datang", "sparkles")

	local Card = Box:AddSpotlightCard("Spotlight_Hero", {
		Height = 130,
		Title = "N3V4 Preview Kit",
		Description = "Semua komponen library lu, satu window.",
		Image = CONFIG.ImageAsset,
	})

	if Card and Card.SetData then
		Card:SetData(
			"N3V4 Preview Kit",
			"Baseline visual: CornerRadius 4 · Font Code · Accent ungu-pink"
		)
	end

	Box:AddDivider({ Text = "Status Session", Margin = 6 })
	Box:AddLabel('Library: <font color="#5adcff">ONLINE</font>', false)
	Box:AddLabel(string.format("Device: %s", tostring(Library.DevicePlatform or "Studio")), false)
	Box:AddLabel(string.format("Mobile: %s · DPI: %s", tostring(Library.IsMobile), tostring(Library.DPIScale)), false)
	Box:AddLabel("Klik tab di sidebar buat jelajah semua komponen.", true)
end)

Try("Overview: Viewport 3D auto-spin", function()
	local Box = OverviewTab:AddRightGroupbox("Asset 3D", "box")
	local Viewport = Box:AddViewport("Viewport_Egg", {
		Height = 200,
		Spin = true,
		Interactive = false,
	})
	if Viewport and Viewport.SetModel then
		Viewport:SetModel(DemoEgg)
	end
end)

Try("Overview: ScrollFeed", function()
	local Box = OverviewTab:AddRightGroupbox("Activity Feed", "activity")
	local Feed = Box:AddScrollFeed("Feed_Activity", { Height = 215 })

	local Items = {
		{ Title = "Golden Egg hatched", Detail = "Rate 1.2K/s · Scale 1.4 · 62 Kg", RightTag = "98%" },
		{ Title = 'Pet <b>[MYTHIC]</b> diperoleh', Detail = "Rate 840/s · Scale 1.1 · 18 Kg", RightTag = "NEW" },
		{ Title = "Rift event dimulai", Detail = "Zones: Forest, Cave, Sky · 5 menit", RightTag = "LIVE" },
		{ Title = "Auto-sell selesai", Detail = "12 pet terjual · +248.500 coins", RightTag = "DONE" },
		{ Title = "Egg dicuri pemain lain", Detail = "Player: Builderman · Zone: Cave", RightTag = "ALERT" },
	}

	for _, Item in ipairs(Items) do
		Item.Icon = CONFIG.ImageAsset
		Item.OnClick = function()
			SafeNotify({ Title = "Feed item", Description = "Klik: " .. Item.Title, Time = 2 })
		end
		Feed:AddItem(Item)
	end
end)

--================================================================================
-- TAB 2 — COMPONENTS
--================================================================================
local ComponentsTab = Window:AddTab("Components", "shapes", "Button, toggle, slider, dropdown, input, keybind, color")

Try("Components: Buttons", function()
	local Box = ComponentsTab:AddLeftGroupbox("Buttons", "mouse-pointer-click")

	Box:AddButton("Button biasa", function()
		SafeNotify("Button biasa diklik")
	end)

	Box:AddButton({
		Text = "Button + Tooltip",
		Tooltip = "Hover gue buat lihat tooltip.",
		Func = function() end,
	})

	Box:AddButton({
		Text = "Double-click confirm",
		DoubleClick = true,
		Func = function()
			SafeNotify({ Title = "Confirmed", Description = "Klik 2x buat eksekusi.", Time = 2 })
		end,
	})

	Box:AddButton({ Text = "Risky button (merah)", Risky = true, Func = function() end })
	Box:AddButton({ Text = "Disabled button", Disabled = true, DisabledTooltip = "Lagi dimatiin.", Func = function() end })

	local Parent = Box:AddButton("Parent button (punya sub)", function() end)
	if Parent and Parent.AddButton then
		Parent:AddButton("Sub button 1", function() end)
		Parent:AddButton("Sub button 2", function() end)
	end
end)

Try("Components: Toggles + KeyPicker + ColorPicker", function()
	local Box = ComponentsTab:AddLeftGroupbox("Toggles", "toggle-right")

	Box:AddToggle("Toggle_Master", {
		Text = "Master toggle",
		Default = true,
		Tooltip = "Dipakai juga di tab Advanced buat demo dependency.",
		Callback = function(Value)
			print("[Preview] Master toggle ->", Value)
		end,
	})

	local WithKey = Box:AddToggle("Toggle_WithKeybind", { Text = "Toggle + keybind", Default = false })
	if WithKey and WithKey.AddKeyPicker then
		WithKey:AddKeyPicker("KeyPicker_Toggle", {
			Text = "Keybind",
			Default = "None",
			Mode = "Toggle",
			Modes = { "Always", "Toggle", "Hold" },
			SyncToggleState = true,
		})
	end

	local WithColor = Box:AddToggle("Toggle_WithColor", { Text = "Toggle + color picker", Default = false })
	if WithColor and WithColor.AddColorPicker then
		WithColor:AddColorPicker("ColorPicker_Toggle", {
			Title = "Warna aksen",
			Default = Color3.fromRGB(218, 98, 255),
		})
	end

	Box:AddCheckbox("Checkbox_Force", { Text = "Checkbox (bukan switch)", Default = false })
	Box:AddToggle("Toggle_Risky", { Text = "Risky toggle", Default = false, Risky = true })
	Box:AddToggle("Toggle_Disabled", { Text = "Disabled toggle", Default = false, Disabled = true })
end)

Try("Components: Sliders", function()
	local Box = ComponentsTab:AddRightGroupbox("Sliders", "sliders-horizontal")

	Box:AddSlider("Slider_Speed", {
		Text = "Walkspeed", Default = 16, Min = 0, Max = 200,
		Rounding = 0, Suffix = " studs/s", AllowRightClickInput = true,
	})

	Box:AddSlider("Slider_Rate", {
		Text = "Farm rate", Default = 1.5, Min = 0.1, Max = 10, Rounding = 2, Suffix = "x",
	})

	Box:AddSlider("Slider_Money", {
		Text = "Target coins", Default = 250000, Min = 0, Max = 1000000,
		Rounding = 0, Prefix = "$",
	})
end)

Try("Components: Inputs", function()
	local Box = ComponentsTab:AddRightGroupbox("Inputs", "keyboard")

	Box:AddInput("Input_Text", {
		Text = "Text input", Default = "", Placeholder = "Ketik sesuatu...", Finished = true,
	})

	Box:AddInput("Input_Numeric", {
		Text = "Numeric only", Default = "100", Numeric = true, Placeholder = "0",
	})

	Box:AddInput("Input_NoEmpty", {
		Text = "Nggak boleh kosong", Default = "N3", AllowEmpty = false, EmptyReset = "---",
	})

	Box:AddInput("Input_Webhook", {
		Text = "Discord webhook URL", Default = "",
		Placeholder = "https://discord.com/api/webhooks/...", Finished = true,
	})
end)

Try("Components: Dropdowns", function()
	local Box = ComponentsTab:AddRightGroupbox("Dropdowns", "chevron-down")

	Box:AddDropdown("Dropdown_Single", {
		Text = "Single select",
		Values = { "Forest", "Cave", "Sky", "Lava", "Ocean" },
		Default = 1,
		Tooltip = "Dropdown biasa, satu pilihan.",
	})

	Box:AddDropdown("Dropdown_Multi", {
		Text = "Multi select + DragSelect",
		Values = { "Auto Farm", "Auto Hatch", "Auto Sell", "Auto Fuse", "Anti Steal" },
		Default = {},
		Multi = true,
		AllowNull = true,
		DragSelect = true,
		Tooltip = "Tahan & geser buat milih banyak.",
	})

	Box:AddDropdown("Dropdown_Search", {
		Text = "Searchable (20 item)",
		Values = {
			"Golden Egg", "Silver Egg", "Crystal Egg", "Shadow Egg", "Dragon Egg",
			"Frost Egg", "Ember Egg", "Void Egg", "Storm Egg", "Terra Egg",
			"Lunar Egg", "Solar Egg", "Mystic Egg", "Ancient Egg", "Primal Egg",
			"Nova Egg", "Quantum Egg", "Spectral Egg", "Radiant Egg", "Obsidian Egg",
		},
		Default = 1,
		Searchable = true,
		MaxVisibleDropdownItems = 8,
	})

	Box:AddDropdown("Dropdown_Disabled", {
		Text = "Ada item disabled",
		Values = { "Common", "Rare", "Epic", "Legendary", "Mythic" },
		DisabledValues = { "Legendary", "Mythic" },
		Default = 1,
	})

	Box:AddDropdown("Dropdown_Images", {
		Text = "Icon per item (ValueImages)",
		Values = { "Pet A", "Pet B", "Pet C" },
		ValueImages = {
			["Pet A"] = CONFIG.ImageAsset,
			["Pet B"] = CONFIG.ImageAsset,
			["Pet C"] = CONFIG.ImageAsset,
		},
		Default = 1,
	})

	Box:AddDropdown("Dropdown_Players", {
		Text = "Player list (auto)",
		SpecialType = "Player",
		ExcludeLocalPlayer = false,
		EnablePlayerImages = true,
		Default = 1,
	})

	Box:AddDropdown("Dropdown_Teams", {
		Text = "Team list (auto)",
		SpecialType = "Team",
		Default = 1,
	})
end)

--================================================================================
-- TAB 3 — ADVANCED
--================================================================================
local AdvancedTab = Window:AddTab("Advanced", "layers", "Dependency, tabbox, keybox, dialog, passthrough")

Try("Advanced: DependencyBox", function()
	local Box = AdvancedTab:AddLeftGroupbox("Dependency System", "git-branch")

	local Master = Box:AddToggle("Adv_Master", { Text = "Aktifin sub-settings", Default = false })

	local Dep = Box:AddDependencyBox()
	Dep:SetupDependencies({ { Master, true } })

	Dep:AddLabel("Isi box ini cuma muncul kalau master ON", false)
	Dep:AddSlider("Adv_DepSlider", { Text = "Intensity", Default = 50, Min = 0, Max = 100, Suffix = "%" })
	Dep:AddDropdown("Adv_DepDropdown", { Text = "Mode", Values = { "Aggressive", "Balanced", "Safe" }, Default = 1 })
end)

Try("Advanced: DependencyGroupbox", function()
	local Box = AdvancedTab:AddLeftGroupbox("Dependency Groupbox", "box")

	local Master = Box:AddToggle("Adv_MasterGB", { Text = "Munculin groupbox tambahan", Default = false })

	local DepGB = Box:AddDependencyGroupbox()
	DepGB:SetupDependencies({ { Master, true } })

	DepGB:AddLabel("Groupbox ini nempel otomatis di bawah.", false)
	DepGB:AddToggle("Adv_GBToggle", { Text = "Opsi di dalam dep-groupbox", Default = true })
end)

Try("Advanced: Tabbox kiri (sub-tab)", function()
	local Tabbox = AdvancedTab:AddLeftTabbox("Contoh Tabbox")

	local SubA = Tabbox:AddTab("Pets", "paw-print")
	SubA:AddToggle("TB_PetAutoSell", { Text = "Auto sell pets", Default = false })
	SubA:AddSlider("TB_PetMinRate", { Text = "Min rate", Default = 100, Min = 0, Max = 5000, Prefix = "$" })

	local SubB = Tabbox:AddTab("Eggs", "egg")
	SubB:AddToggle("TB_EggAutoHatch", { Text = "Auto hatch", Default = false })
	SubB:AddDropdown("TB_EggZone", { Text = "Zone", Values = { "Forest", "Cave", "Sky" }, Default = 1 })

	local SubC = Tabbox:AddTab("Misc", "wrench")
	SubC:AddLabel("Tabbox juga bisa di dalam groupbox (lihat kanan).", true)
end)

Try("Advanced: Groupbox collapse", function()
	local Box = AdvancedTab:AddLeftGroupbox("Collapse Control", "chevrons-up-down")
	local Target = AdvancedTab:AddLeftGroupbox("Box target (bisa collapse)", "package")
	Target:AddLabel("Klik tombol di bawah, atau klik header box ini.", true)

	Box:AddButton("Toggle collapsed", function()
		if Target.ToggleCollapsed then Target:ToggleCollapsed() end
	end)
	Box:AddButton("Hide total", function()
		if Target.Hide then Target:Hide() end
	end)
	Box:AddButton("Show lagi", function()
		if Target.Show then Target:Show() end
	end)
end)

Try("Advanced: Nested Tabbox dalam Groupbox", function()
	local Box = AdvancedTab:AddRightGroupbox("Nested Tabbox", "folder-tree")
	local Inner = Box:AddTabbox({ Name = "Webhook Embeds" })

	local S1 = Inner:AddTab("Status", "activity")
	S1:AddToggle("Nest_Status", { Text = "Kirim status embed", Default = true })

	local S2 = Inner:AddTab("Egg", "egg")
	S2:AddToggle("Nest_Egg", { Text = "Kirim egg embed", Default = false })
end)

Try("Advanced: UIPassthrough", function()
	local Box = AdvancedTab:AddRightGroupbox("UI Passthrough", "frame")
	Box:AddLabel("Masukin GuiObject buatan lu ke dalam UI library:", true)
	Box:AddUIPassthrough("Passthrough_Demo", {
		Instance = PassthroughFrame,
		Height = 44,
	})
end)

Try("Advanced: KeyBox (execute key)", function()
	AdvancedTab:AddKeyBox(function(KeyText)
		SafeNotify({ Title = "KeyBox", Description = "Key masuk: " .. tostring(KeyText), Time = 3 })
	end)
end)

Try("Advanced: Dialog", function()
	local Box = AdvancedTab:AddRightGroupbox("Dialog", "message-square")

	Box:AddButton("Dialog 3 button variant", function()
		local Dialog = Window:AddDialog("Dialog_Demo", {
			Title = "Konfirmasi Aksi",
			Description = "Dialog modal: overlay gelap, scale-in animation, footer button dengan beberapa variant.",
			AutoDismiss = true,
			OutsideClickDismiss = true,
		})

		Dialog:AddFooterButton("Cancel", {
			Title = "Batal", Variant = "Ghost", Order = 1,
			Callback = function() SafeNotify({ Title = "Dialog", Description = "Lu milih Batal.", Time = 2 }) end,
		})
		Dialog:AddFooterButton("Retry", {
			Title = "Coba lagi", Variant = "Secondary", Order = 2,
			Callback = function() SafeNotify({ Title = "Dialog", Description = "Lu milih Coba lagi.", Time = 2 }) end,
		})
		Dialog:AddFooterButton("Confirm", {
			Title = "Eksekusi", Variant = "Primary", Order = 3,
			Callback = function() SafeNotify({ Title = "Dialog", Description = "Lu milih Eksekusi.", Time = 2 }) end,
		})
	end)

	Box:AddButton("Dialog destructive + wait timer", function()
		local Dialog = Window:AddDialog("Dialog_Destructive", {
			Title = "Reset Semua Config?",
			Description = "Semua setting balik ke default. Nggak bisa di-undo.",
		})
		Dialog:AddFooterButton("No", { Title = "Jangan", Variant = "Secondary", Order = 1 })
		Dialog:AddFooterButton("Yes", { Title = "Ya, reset", Variant = "Destructive", Order = 2, WaitTime = 3 })
	end)

	Box:AddButton("Dialog + komponen di dalamnya", function()
		local Dialog = Window:AddDialog("Dialog_Form", {
			Title = "Form dalam Dialog",
			Description = "Dialog inherit BaseGroupbox, jadi bisa diisi komponen.",
		})
		Dialog:AddToggle("Dlg_Toggle", { Text = "Opsi tambahan", Default = true })
		Dialog:AddSlider("Dlg_Slider", { Text = "Nilai", Default = 50, Min = 0, Max = 100, Suffix = "%" })
		Dialog:AddFooterButton("Ok", { Title = "Simpan", Variant = "Primary", Order = 1 })
	end)
end)

--================================================================================
-- TAB 4 — MEDIA
--================================================================================
local MediaTab = Window:AddTab("Media", "image", "Viewport 3D interaktif, image, video, spotlight, feed")

Try("Media: Viewport interaktif (drag)", function()
	local Box = MediaTab:AddLeftGroupbox("Viewport Interaktif", "rotate-3d")
	Box:AddLabel("Drag mouse di dalam viewport buat muter manual. Spin dimatiin.", true)

	local VP = Box:AddViewport("Media_Viewport", {
		Height = 240, Spin = false, Interactive = true,
	})
	if VP and VP.SetModel then
		VP:SetModel(DemoEgg)
	end

	Box:AddButton("Spawn model baru", function()
		if VP and VP.SetModel then VP:SetModel(BuildDemoEgg()) end
	end)
	Box:AddButton("Focus ulang kamera", function()
		if VP and VP.Focus then VP:Focus() end
	end)
end)

Try("Media: Image + kontrol", function()
	local Box = MediaTab:AddLeftGroupbox("Image Element", "image")

	local Img = Box:AddImage("Media_Image", {
		Image = CONFIG.ImageAsset,
		Height = 180,
		ScaleType = Enum.ScaleType.Fit,
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0,
	})

	Box:AddSlider("Media_ImgHeight", {
		Text = "Tinggi image", Default = 180, Min = 60, Max = 400, Suffix = "px",
		Callback = function(Value)
			if Img and Img.SetHeight then Img:SetHeight(Value) end
		end,
	})

	Box:AddDropdown("Media_ImgScale", {
		Text = "ScaleType",
		Values = { "Fit", "Fill", "Stretch", "Slice", "Crop" },
		Default = 1,
		Callback = function(Value)
			local Map = {
				Fit = Enum.ScaleType.Fit,
				Fill = Enum.ScaleType.Fill,
				Stretch = Enum.ScaleType.Stretch,
				Slice = Enum.ScaleType.Slice,
				Crop = Enum.ScaleType.Crop,
			}
			if Img and Img.SetScaleType and Map[Value] then
				Img:SetScaleType(Map[Value])
			end
		end,
	})

	local TintToggle = Box:AddToggle("Media_ImgTint", { Text = "Tint warna", Default = false })
	if TintToggle and TintToggle.AddColorPicker then
		TintToggle:AddColorPicker("Media_ImgColor", {
			Title = "Warna tint",
			Default = Color3.fromRGB(218, 98, 255),
			Callback = function(Color)
				if Img and Img.SetColor then Img:SetColor(Color) end
			end,
		})
	end
end)

Try("Media: SpotlightCard 2D <-> 3D", function()
	local Box = MediaTab:AddRightGroupbox("Spotlight Card", "star")

	local Card = Box:AddSpotlightCard("Media_Spotlight", {
		Height = 150,
		Title = "Mythic Pet",
		Description = "SpotlightCard bisa nampilin gambar 2D ATAU model 3D.",
	})

	if Card and Card.SetData then
		-- Param ke-4 = modelSource -> otomatis switch ke ViewportFrame 3D
		Card:SetData("Mythic Pet", "Rate 2.4K/s · Scale 1.8 · 96 Kg · Mutasi: Shiny", nil, DemoEgg)
	end

	Box:AddButton("Swap ke gambar 2D", function()
		if Card and Card.SetData then
			Card:SetData("Golden Egg", "Rate 1.2K/s · Scale 1.4 · 62 Kg", CONFIG.ImageAsset, nil)
		end
	end)
	Box:AddButton("Swap ke model 3D", function()
		if Card and Card.SetData then
			Card:SetData("Mythic Pet", "Rate 2.4K/s · Scale 1.8 · 96 Kg · Mutasi: Shiny", nil, DemoEgg)
		end
	end)
end)

Try("Media: Video", function()
	local Box = MediaTab:AddRightGroupbox("Video Element", "video")

	if CONFIG.VideoAsset == "" or not CONFIG.VideoAsset then
		Box:AddLabel("DI-SKIP: CONFIG.VideoAsset masih kosong.", true)
		Box:AddLabel("Isi pakai asset ID VideoFrame punya lu, terus reload preview.", true)
		return
	end

	local Vid = Box:AddVideo("Media_Video", {
		Video = CONFIG.VideoAsset, Height = 200, Looped = true, Playing = true, Volume = 1,
	})

	Box:AddButton("Play", function() if Vid and Vid.Play then Vid:Play() end end)
	Box:AddButton("Pause", function() if Vid and Vid.Pause then Vid:Pause() end end)
	Box:AddSlider("Media_VidVol", {
		Text = "Volume", Default = 100, Min = 0, Max = 100, Suffix = "%",
		Callback = function(V) if Vid and Vid.SetVolume then Vid:SetVolume(V / 100) end end,
	})
end)

Try("Media: ScrollFeed besar + clear", function()
	local Box = MediaTab:AddRightGroupbox("Live Feed", "rss")
	local Feed = Box:AddScrollFeed("Media_Feed", { Height = 260 })

	for i = 1, 12 do
		Feed:AddItem({
			Icon = CONFIG.ImageAsset,
			Title = string.format("Event log #%d", i),
			Detail = string.format("Auto-generated row · %d/s · scale %.1f", 100 * i, 1 + (i % 5) / 10),
			RightTag = tostring(math.random(10, 100)) .. "%",
		})
	end

	Box:AddButton("Clear feed", function()
		if Feed and Feed.Clear then Feed:Clear() end
	end)
end)

--================================================================================
-- TAB 5 — OVERLAYS
--================================================================================
local OverlaysTab = Window:AddTab("Overlays", "bell", "Notification, draggable, overlay, dashboard, context menu")

Try("Overlays: Notifications", function()
	local Box = OverlaysTab:AddLeftGroupbox("Notifications", "bell-ring")

	Box:AddButton("Notify simple (string)", function()
		SafeNotify("Ini notification paling simpel.")
	end)

	Box:AddButton("Notify title + description", function()
		SafeNotify({ Title = "Auto Farm", Description = "Berhasil. 128 egg dikumpulin.", Time = 4 })
	end)

	Box:AddButton("Notify + lucide icon", function()
		SafeNotify({
			Title = "Pet diperoleh!",
			Description = "Mythic Dragon · Shiny mutation",
			Icon = "paw-print",
			IconColor = Color3.fromRGB(218, 98, 255),
			Time = 4,
		})
	end)

	Box:AddButton("Notify big icon + warna custom", function()
		SafeNotify({
			Title = "RIFT EVENT",
			TitleColor = Color3.fromRGB(255, 200, 60),
			Description = "Event dimulai di 3 zona. Sisa 5 menit.",
			DescriptionColor = Color3.fromRGB(220, 220, 220),
			BigIcon = CONFIG.ImageAsset,
			Time = 5,
		})
	end)

	Box:AddButton("Notify + progress steps (persist)", function()
		local Notif = Library:Notify({
			Title = "Hatching...",
			Description = "Step 0 / 5",
			Steps = 5,
			Persist = true,
		})

		if typeof(Notif) ~= "table" then
			return
		end

		task.spawn(function()
			for Step = 1, 5 do
				task.wait(0.7)
				if Notif.ChangeStep then Notif:ChangeStep(Step) end
				if Notif.ChangeDescription then Notif:ChangeDescription("Step " .. Step .. " / 5") end
			end
			task.wait(0.6)
			if Notif.ChangeTitle then Notif:ChangeTitle("Hatching selesai!") end
			task.wait(1)
			if Notif.Destroy then Notif:Destroy() end
		end)
	end)

	Box:AddButton("Spam 5 notify (test stacking)", function()
		for i = 1, 5 do
			task.delay(i * 0.25, function()
				SafeNotify({ Title = "Notif #" .. i, Description = "Stacking test", Time = 4 })
			end)
		end
	end)
end)

Try("Overlays: Draggable label & buttons", function()
	local Box = OverlaysTab:AddLeftGroupbox("Draggable Elements", "move")
	Box:AddLabel("Semua elemen di bawah bisa lu drag keluar window.", true)

	Box:AddButton("Spawn draggable label", function()
		local Label = Library:AddDraggableLabel({
			Text = "N3 HUB • Watermark",
			Icon = "zap",
			IconPosition = "left",
		})
		if Label and Label.SetVisible then Label:SetVisible(true) end
		if Label and Label.SetText then
			task.delay(2, function()
				if Label.SetText then Label:SetText("N3 HUB • Updated") end
			end)
		end
	end)

	Box:AddButton("Spawn draggable button", function()
		Library:AddDraggableButton({
			Text = "Klik gue",
			Func = function()
				SafeNotify({ Title = "Draggable Button", Description = "Diklik!", Time = 2 })
			end,
		})
	end)

	Box:AddButton("Spawn draggable image button", function()
		Library:AddDraggableImageButton({
			Icon = CONFIG.Icon,
			IconSize = 28,
			Func = function()
				SafeNotify({ Title = "Image Button", Description = "Diklik!", Time = 2 })
			end,
		})
	end)
end)

Try("Overlays: Draggable menu (raw Instance API)", function()
	local Box = OverlaysTab:AddLeftGroupbox("Draggable Menu", "menu")
	Box:AddLabel("AddDraggableMenu nge-return (Holder, Container) — raw Instance.", true)
	Box:AddLabel("Isinya lu bangun sendiri. Ini contoh 3 item:", true)

	Box:AddButton("Spawn draggable menu", function()
		local Holder, Container = Library:AddDraggableMenu("Menu Cepat")
		if not Container then
			return
		end

		for i = 1, 3 do
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, 0, 0, 26)
			Btn.BackgroundColor3 = Library.Scheme.MainColor
			Btn.BorderSizePixel = 0
			Btn.AutoButtonColor = false
			Btn.Text = "  Aksi " .. i
			Btn.TextSize = 13
			Btn.Font = Enum.Font.Code
			Btn.TextColor3 = Library.Scheme.FontColor
			Btn.TextXAlignment = Enum.TextXAlignment.Left
			Btn.Parent = Container

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, (Library.CornerRadius or 4) / 2)
			Corner.Parent = Btn

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Library.Scheme.OutlineColor
			Stroke.Thickness = 1
			Stroke.Parent = Btn

			Btn.MouseButton1Click:Connect(function()
				SafeNotify({ Title = "Menu", Description = "Aksi " .. i .. " dijalankan", Time = 2 })
			end)
			Btn.MouseEnter:Connect(function()
				Btn.BackgroundColor3 = Library.Scheme.AccentColor
			end)
			Btn.MouseLeave:Connect(function()
				Btn.BackgroundColor3 = Library.Scheme.MainColor
			end)
		end

		-- Holder & Container dari library pakai AutomaticSize/Scale yang bisa
		-- collapse jadi 0px kalau isinya dibikin manual. Kita set eksplisit aja.
		local MenuWidth = 170
		local ItemHeight = 26
		local ItemPadding = 7
		local ItemCount = 3
		local ContainerHeight = (ItemCount * ItemHeight) + ((ItemCount - 1) * ItemPadding) + (ItemPadding * 2)

		Container.AutomaticSize = Enum.AutomaticSize.None
		Container.Size = UDim2.fromOffset(MenuWidth, ContainerHeight)

		Holder.AutomaticSize = Enum.AutomaticSize.None
		Holder.Size = UDim2.fromOffset(MenuWidth, 35 + ContainerHeight)
	end)
end)

Try("Overlays: Overlay panel (key-value rows)", function()
	local Box = OverlaysTab:AddRightGroupbox("Overlay", "picture-in-picture")
	Box:AddLabel("Overlay = panel stat key-value, API-nya SetRow/RemoveRow.", true)

	local LiveOverlay = nil

	Box:AddButton("Bikin overlay + isi row", function()
		if LiveOverlay then
			LiveOverlay:Destroy()
			LiveOverlay = nil
		end

		LiveOverlay = Library:CreateOverlay({
			Title = "Live Stats",
			Position = UDim2.fromOffset(320, 140),
		})

		LiveOverlay:SetRow("Coins", "1.248.500", Color3.fromRGB(255, 205, 70))
		LiveOverlay:SetRow("Eggs", "37", Color3.fromRGB(140, 230, 255))
		LiveOverlay:SetRow("Pets", "12", Color3.fromRGB(218, 98, 255))
		LiveOverlay:SetRow("Rate/s", "2.480", Color3.fromRGB(140, 255, 170))
	end)

	Box:AddButton("Update row realtime (5 detik)", function()
		if not LiveOverlay then
			SafeNotify({ Title = "Overlay", Description = "Bikin overlay-nya dulu.", Time = 2 })
			return
		end
		task.spawn(function()
			for i = 1, 10 do
				LiveOverlay:SetRow("Coins", tostring(1248500 + (i * 12500)), Color3.fromRGB(255, 205, 70))
				LiveOverlay:SetRow("Rate/s", tostring(2480 + (i * 35)), Color3.fromRGB(140, 255, 170))
				task.wait(0.5)
			end
		end)
	end)

	Box:AddButton("Tutup overlay", function()
		if LiveOverlay then
			LiveOverlay:Destroy()
			LiveOverlay = nil
		end
	end)
end)

Try("Overlays: Dashboard window", function()
	local Box = OverlaysTab:AddRightGroupbox("Live Dashboard", "gauge")
	Box:AddLabel("Window kedua buat monitor stats realtime.", true)

	Box:AddButton("Buka Dashboard", function()
		local Dash = Library:CreateDashboardWindow({
			Title = "N3 Live Dashboard",
			Position = UDim2.fromOffset(25, 120),
		})
		if typeof(Dash) == "table" and Dash.SetRow then
			Dash:SetRow("Status", "FARMING", Color3.fromRGB(140, 255, 170))
			Dash:SetRow("Zone", "Forest", Color3.fromRGB(140, 230, 255))
			Dash:SetRow("Collected", "128 eggs")
		end
	end)
end)

Try("Overlays: Loading error page", function()
	local Box = OverlaysTab:AddRightGroupbox("Loading States", "loader")

	Box:AddButton("Replay loading normal", function()
		RunLoadingSequence()
	end)

	Box:AddButton("Loading + error page", function()
		if Library.ActiveLoading then
			Library.ActiveLoading:Destroy()
			task.wait(0.1)
		end

		local Loading = Library:CreateLoading({
			Title = CONFIG.Title,
			TotalSteps = 3,
			CurrentStep = 1,
			AutoResizeHeight = true,
		})

		Loading:SetCurrentStep(2)
		Loading:SetMessage("Koneksi gagal")
		Loading:SetDescription("Nggak bisa hubungin remote server.")

		if Loading.ShowErrorPage then Loading:ShowErrorPage(true) end
		if Loading.SetErrorMessage then Loading:SetErrorMessage("HTTP 503 — Service Unavailable") end
		if Loading.SetErrorButtons then
			Loading:SetErrorButtons({
				{ Text = "Retry", Callback = function() Loading:ShowErrorPage(false) end },
				{ Text = "Tutup", Callback = function() Loading:Destroy() end },
			})
		end
	end)
end)

Try("Overlays: Context menu (right-click)", function()
	local Box = OverlaysTab:AddRightGroupbox("Context Menu", "list")
	Box:AddLabel("Klik kanan button di bawah.", true)

	local Trigger = Box:AddButton("Right-click gue", function() end)
	local Target = Trigger and (Trigger.Base or Trigger.Holder)

	if typeof(Target) == "Instance" and Target:IsA("GuiObject") and Library.AddContextMenu then
		local Menu = Library:AddContextMenu(Target, UDim2.fromOffset(150, 0))
		if Menu and Menu.AddButton then
			Menu:AddButton("Copy value", function() end)
			Menu:AddButton("Reset ke default", function() end)
		end
	end
end)

--================================================================================
-- TAB 6 — THEME LAB
--================================================================================
local ThemeTab = Window:AddTab("Theme Lab", "palette", "Ganti warna, radius, font, animasi secara realtime")

Try("Theme: Scheme colors + preset", function()
	local Box = ThemeTab:AddLeftGroupbox("Scheme Colors", "droplets")

	local function ApplyColor(Key, Color)
		Library.Scheme[Key] = Color
		Library:UpdateColorsUsingRegistry()
	end

	local Pickers = {
		{ Key = "AccentColor", Label = "Accent color", Idx = "CP_Accent", Title = "AccentColor" },
		{ Key = "BackgroundColor", Label = "Background color", Idx = "CP_BG", Title = "BackgroundColor" },
		{ Key = "MainColor", Label = "Main color", Idx = "CP_Main", Title = "MainColor" },
		{ Key = "OutlineColor", Label = "Outline color", Idx = "CP_Outline", Title = "OutlineColor" },
		{ Key = "FontColor", Label = "Font color", Idx = "CP_Font", Title = "FontColor" },
	}

	for _, Spec in ipairs(Pickers) do
		local T = Box:AddToggle("Theme_" .. Spec.Idx, { Text = Spec.Label, Default = true })
		if T and T.AddColorPicker then
			T:AddColorPicker(Spec.Idx, {
				Title = Spec.Title,
				Default = Library.Scheme[Spec.Key] or Color3.fromRGB(255, 255, 255),
				Callback = function(Color) ApplyColor(Spec.Key, Color) end,
			})
		end
	end

	Box:AddDivider({ Text = "Preset", Margin = 6 })

	Box:AddButton("Preset: Default Obsidian", function()
		Library.IsLightTheme = false
		Library.Scheme.AccentColor = Color3.fromRGB(218, 98, 255)
		Library.Scheme.BackgroundColor = Color3.fromRGB(30, 30, 30)
		Library.Scheme.MainColor = Color3.fromRGB(40, 40, 40)
		Library.Scheme.OutlineColor = Color3.fromRGB(50, 50, 50)
		Library.Scheme.FontColor = Color3.fromRGB(238, 238, 238)
		Library:UpdateColorsUsingRegistry()
	end)

	Box:AddButton("Preset: Midnight Cyan", function()
		Library.IsLightTheme = false
		Library.Scheme.AccentColor = Color3.fromRGB(90, 220, 255)
		Library.Scheme.BackgroundColor = Color3.fromRGB(14, 17, 23)
		Library.Scheme.MainColor = Color3.fromRGB(22, 26, 34)
		Library.Scheme.OutlineColor = Color3.fromRGB(38, 45, 58)
		Library.Scheme.FontColor = Color3.fromRGB(232, 240, 248)
		Library:UpdateColorsUsingRegistry()
	end)

	Box:AddButton("Preset: Light Mode", function()
		Library.IsLightTheme = true
		Library.Scheme.AccentColor = Color3.fromRGB(124, 58, 237)
		Library.Scheme.BackgroundColor = Color3.fromRGB(244, 244, 247)
		Library.Scheme.MainColor = Color3.fromRGB(255, 255, 255)
		Library.Scheme.OutlineColor = Color3.fromRGB(214, 214, 222)
		Library.Scheme.FontColor = Color3.fromRGB(28, 28, 34)
		Library:UpdateColorsUsingRegistry()
	end)
end)

Try("Theme: Geometry & scale", function()
	local Box = ThemeTab:AddLeftGroupbox("Geometry & Scale", "ruler")

	Box:AddSlider("Theme_Radius", {
		Text = "Corner radius (default 4)",
		Default = Library.CornerRadius or 4,
		Min = 0, Max = 20, Rounding = 0, Suffix = "px",
		Callback = function(Value)
			if Window.SetCornerRadius then Window:SetCornerRadius(Value) end
		end,
	})

	Box:AddSlider("Theme_DPI", {
		Text = "DPI scale",
		Default = math.floor((Library.DPIScale or 1) * 100),
		Min = 70, Max = 140, Rounding = 0, Suffix = "%",
		Callback = function(Value)
			Library:SetDPIScale(Value)
		end,
	})

	Box:AddSlider("Theme_Sidebar", {
		Text = "Sidebar width",
		Default = 128, Min = 50, Max = 260, Rounding = 0, Suffix = "px",
		Callback = function(Value)
			if Window.SetSidebarWidth then Window:SetSidebarWidth(Value) end
		end,
	})

	Box:AddToggle("Theme_Compact", {
		Text = "Compact sidebar (icon only)",
		Default = false,
		Callback = function(Value)
			if Window.SetCompact then Window:SetCompact(Value) end
		end,
	})
end)

Try("Theme: Font & background image", function()
	local Box = ThemeTab:AddRightGroupbox("Font & Background", "type")

	Box:AddDropdown("Theme_Font", {
		Text = "Font face",
		Values = {
			"Code", "Gotham", "GothamMedium", "GothamBold",
			"BuilderSans", "Montserrat", "Ubuntu", "Jura", "SourceSans",
		},
		Default = 1,
		Callback = function(Value)
			local FontEnum = GetFontEnum(Value)
			if FontEnum then
				Library:SetFont(FontEnum)
			else
				warn("[N3V4 Preview] Enum.Font." .. Value .. " nggak ada di Studio lu.")
			end
		end,
	})

	Box:AddInput("Theme_BGImage", {
		Text = "Background image (asset ID)",
		Default = "",
		Placeholder = "rbxassetid://0  (kosongin = clear)",
		Finished = true,
		Callback = function(Value)
			Library:SetBackgroundImage(Value or "")
		end,
	})

	Box:AddButton("Clear background image", function()
		Library:SetBackgroundImage("")
	end)
end)

Try("Theme: Animation controls", function()
	local Box = ThemeTab:AddRightGroupbox("Animations", "wind")

	local AnimState = {
		ToggleWindow = true,
		TabSwitch = true,
		Groupbox = true,
		Dropdown = true,
		KeyPicker = true,
	}

	local Specs = {
		{ Key = "ToggleWindow", Label = "Toggle window animation" },
		{ Key = "TabSwitch", Label = "Tab switch animation" },
		{ Key = "Groupbox", Label = "Groupbox animation" },
		{ Key = "Dropdown", Label = "Dropdown animation" },
		{ Key = "KeyPicker", Label = "KeyPicker animation" },
	}

	for _, Spec in ipairs(Specs) do
		Box:AddToggle("Anim_" .. Spec.Key, {
			Text = Spec.Label,
			Default = true,
			Callback = function(Value)
				AnimState[Spec.Key] = Value
				Window:SetAnimations(AnimState)
			end,
		})
	end

	Box:AddDivider({ Text = "Timing", Margin = 6 })

	Box:AddSlider("Anim_TabTime", {
		Text = "Tab transition", Default = 22, Min = 0, Max = 100,
		Rounding = 0, Suffix = " ms",
		Callback = function(Value)
			Window:SetAnimations(nil, Value / 100)
		end,
	})

	Box:AddDropdown("Anim_SwipeFrom", {
		Text = "Swipe direction",
		Values = { "bottom", "top", "left", "right" },
		Default = 1,
		Callback = function(Value)
			Window:SetAnimations(nil, nil, nil, Value)
		end,
	})

	Box:AddSlider("Anim_SwipeOffset", {
		Text = "Swipe offset", Default = 26, Min = 1, Max = 120,
		Rounding = 0, Suffix = "px",
		Callback = function(Value)
			Window:SetAnimations(nil, nil, Value)
		end,
	})
end)

Try("Theme: Window controls & utility", function()
	local Box = ThemeTab:AddRightGroupbox("Window Controls", "settings-2")

	Box:AddDropdown("Theme_NotifySide", {
		Text = "Notification side",
		Values = { "Right", "Left" },
		Default = 1,
		Callback = function(Value)
			Library:SetNotifySide(Value)
		end,
	})

	Box:AddInput("Theme_Title", {
		Text = "Window title", Default = CONFIG.Title, Finished = true,
		Callback = function(Value)
			if Window.ChangeTitle then Window:ChangeTitle(Value) end
		end,
	})

	Box:AddInput("Theme_Footer", {
		Text = "Window footer", Default = CONFIG.Footer, Finished = true,
		Callback = function(Value)
			if Window.SetFooter then Window:SetFooter(Value) end
		end,
	})

	Box:AddDivider({ Text = "Utility", Margin = 6 })

	Box:AddButton("Print laporan ke Output", function()
		PrintReport()
	end)

	Box:AddButton("Toggle UI (atau RightCtrl)", function()
		if Window.Toggle then
			Window:Toggle()
		elseif typeof(Library.Toggle) == "function" then
			Library.Toggle()
		end
	end)

	Box:AddButton({
		Text = "Unload library",
		Risky = true,
		DoubleClick = true,
		DisabledTooltip = "Klik 2x buat beneran unload.",
		Func = function()
			PrintReport()
			Library:Unload()
		end,
	})
end)

--================================================================================
-- 6. FINAL REPORT
--================================================================================
PrintReport()

SafeNotify({
	Title = "Preview siap",
	Description = string.format("%d section OK · %d gagal. Cek Output buat detail.", #Report.OK, #Report.Failed),
	Time = 6,
})


local PREVIEW_ENABLED = true
if not PREVIEW_ENABLED then
	print("[N3V4 Preview] v4.6.10: preview OFF per perintah user. Seting lengkap: N3V4_UISettings. (Set PREVIEW_ENABLED = true buat nyalain showcase lagi.)")
	return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local CONFIG = {
	ModuleName = "N3V4",

	Title = "N3 HUB",
	Footer = "N3V4 • UI Preview Kit v4.28.1",
	Icon = "rbxassetid://117688744510818",

	ImageAsset = "rbxassetid://117688744510818",

	VideoAsset = "",

	ShowLoadingIntro = true,
	LoadingSteps = 5,
	LoadingStepDelay = 0.45,

	ToggleKey = Enum.KeyCode.RightControl,
	VerboseErrors = true,
}


local Report = { OK = {}, Failed = {} }

local Library

local SCALE_TYPES = {}
for _, ScaleItem in Enum.ScaleType:GetEnumItems() do
	SCALE_TYPES[ScaleItem.Name] = ScaleItem
end
SCALE_TYPES.Fill = SCALE_TYPES.Fill or SCALE_TYPES.Crop
SCALE_TYPES.Cover = SCALE_TYPES.Cover or SCALE_TYPES.Crop
SCALE_TYPES.Contain = SCALE_TYPES.Contain or SCALE_TYPES.Fit

local SCALE_TYPE_NAMES = { "Crop", "Fit", "Stretch", "Slice", "Tile" }

local function ResolveScale(Value)
	if typeof(Value) == "EnumItem" then
		return Value
	end
	if typeof(Value) == "string" then
		return SCALE_TYPES[Value] or SCALE_TYPES.Stretch
	end
	return SCALE_TYPES.Stretch
end

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
	print("  N3V4 PREVIEW KIT v3 — LAPORAN KOMPONEN")
	print("===================================================")

	local IconStatus = "library belum ke-load"
	if typeof(Library) == "table" and typeof(Library.GetIcon) == "function" then
		local Resolved = Library:GetIcon("house")
		IconStatus = Resolved ~= nil and "resolve OK (house -> sheet + rect)" or "GAGAL resolve"
	end
	print(string.format("  Icon      : lucide — %s", IconStatus))
	print(string.format("  Radius    : %s", typeof(Library) == "table" and tostring(Library.CornerRadius) or "?"))
	print(string.format("  Animations: %s", typeof(Library) == "table" and tostring(Library.Animations ~= nil) or "?"))
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
	error(string.format("[N3V4 Preview] ModuleScript %q nggak ketemu (nunggu 15 detik).", CONFIG.ModuleName), 0)
end

Library = require(ModuleObject)

if typeof(Library) ~= "table" or typeof(Library.CreateWindow) ~= "function" then
	error("[N3V4 Preview] Module N3V4 nggak nge-return Library yang valid.", 0)
end

print(string.format(
	"[N3V4 Preview] Library OK | Device: %s | Mobile: %s | DPI: %s | Radius: %s | Animations: %s",
	tostring(Library.DevicePlatform), tostring(Library.IsMobile),
	tostring(Library.DPIScale), tostring(Library.CornerRadius),
	Library.Animations and "ON" or "OFF"
))

if type(Library.SetTabAppearance) == "function" and type(Library.TabAppearance) == "table" and Library.TabAppearance.IconCardEnabled ~= nil then
	table.insert(Report.OK, "Library v4.8.4+ (SetTabAppearance + TabAppearance + knob IconCard ada)")
else
	table.insert(Report.Failed, "LIBRARY LAMA: SetTabAppearance/TabAppearance/IconCard nil -> paste ulang ModuleScript N3V4  ->  knob tab mati")
end

local function SafeNotify(Info)
	local Success, Err = pcall(function()
		return Library:Notify(Info)
	end)
	if not Success and CONFIG.VerboseErrors then
		warn("[N3V4 Preview] Notify gagal: " .. tostring(Err))
	end
	return Success
end


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

local function BuildMenuItem(Parent, Text, Scheme, OnClick)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 26)
	Btn.BackgroundColor3 = Scheme.MainColor
	Btn.BorderSizePixel = 0
	Btn.AutoButtonColor = false
	Btn.Text = "  " .. Text
	Btn.TextSize = 13
	Btn.Font = Enum.Font.Code
	Btn.TextColor3 = Scheme.FontColor
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Btn.Parent = Parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, (Library.CornerRadius or 4) / 2)
	Corner.Parent = Btn

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Scheme.OutlineColor
	Stroke.Thickness = 1
	Stroke.Parent = Btn

	Btn.MouseButton1Click:Connect(function()
		if OnClick then OnClick() end
	end)
	Btn.MouseEnter:Connect(function()
		Btn.BackgroundColor3 = Scheme.AccentColor
		Btn.TextColor3 = Color3.fromRGB(20, 20, 20)
	end)
	Btn.MouseLeave:Connect(function()
		Btn.BackgroundColor3 = Scheme.MainColor
		Btn.TextColor3 = Scheme.FontColor
	end)

	return Btn
end

local DemoEgg = BuildDemoEgg()
local PassthroughFrame = BuildPassthroughFrame()

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
		task.wait((CONFIG.LoadingStepDelay * CONFIG.LoadingSteps) + 0.7)
	end)
end

local WindowInfo = {
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
		TabHoverZoom = true,
	},
}

local Window = Library:CreateWindow(WindowInfo)


local OverviewTab = Window:AddTab("Overview", "layout-dashboard", "Ringkasan elemen visual utama")

Try("Overview: L1 Welcome (Spotlight + Label + Divider)", function()
	local Box = OverviewTab:AddLeftGroupbox("Selamat Datang", "sparkles")

	local Card = Box:AddSpotlightCard("Spotlight_Hero", {
		Height = 130,
		Title = "N3V4 Preview Kit",
		Description = "Semua komponen library lu, satu window.",
		Image = CONFIG.ImageAsset,
	})
	if Card and Card.SetData then
		Card:SetData("N3V4 Preview Kit v2", "Icon offline · Layout simetris · Animasi ON")
	end

	Box:AddDivider({ Text = "Selamat Datang", Margin = 6 })
	Box:AddLabel('Library: <font color="#5adcff">ONLINE</font>', false)
	Box:AddLabel("Klik tab di sidebar buat jelajah semua komponen.", true)
	Box:AddLabel("Setting glow/icon anim: tab UI Settings (icon palette paling atas sidebar).", true)
end)

Try("Overview: L2 Session Info", function()
	local Box = OverviewTab:AddLeftGroupbox("Status Session", "activity")
	Box:AddLabel(string.format("Device: %s", tostring(Library.DevicePlatform or "Studio")), false)
	Box:AddLabel(string.format("Mobile: %s", tostring(Library.IsMobile)), false)
	Box:AddLabel(string.format("DPIScale: %s", tostring(Library.DPIScale)), false)
	Box:AddLabel(string.format("CornerRadius: %s", tostring(Library.CornerRadius)), false)
	Box:AddLabel(string.format("Animations: %s", Library.Animations and "ON" or "OFF"), false)
	Box:AddLabel(string.format("Icon lucide resolve: %s", tostring(Library:GetIcon("house") ~= nil)), false)
end)

Try("Overview: R1 Viewport 3D auto-spin", function()
	local Box = OverviewTab:AddRightGroupbox("Asset 3D", "box")
	local Viewport = Box:AddViewport("Viewport_Egg", { Height = 200, Spin = true, Interactive = false })
	if Viewport and Viewport.SetModel then
		Viewport:SetModel(DemoEgg)
	end
end)

Try("Overview: R2 ScrollFeed", function()
	local Box = OverviewTab:AddRightGroupbox("Activity Feed", "rss")
	local Feed = Box:AddScrollFeed("Feed_Activity", { Height = 200 })

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

local ComponentsTab = Window:AddTab("Components", "shapes", "Button, toggle, slider, input, dropdown")

Try("Components: L1 Buttons", function()
	local Box = ComponentsTab:AddLeftGroupbox("Buttons", "mouse-pointer-click")

	Box:AddButton("Button biasa", function()
		SafeNotify("Button biasa diklik")
	end)
	Box:AddButton({ Text = "Button + Tooltip", Tooltip = "Hover gue buat lihat tooltip.", Func = function() end })
	Box:AddButton({
		Text = "Double-click confirm", DoubleClick = true,
		Func = function() SafeNotify({ Title = "Confirmed", Description = "Klik 2x buat eksekusi.", Time = 2 }) end,
	})
	Box:AddButton({ Text = "Risky button (merah)", Risky = true, Func = function() end })
	Box:AddButton({ Text = "Disabled button", Disabled = true, DisabledTooltip = "Lagi dimatiin.", Func = function() end })

	local Parent = Box:AddButton("Parent button (punya sub)", function() end)
	if Parent and Parent.AddButton then
		Parent:AddButton("Sub button 1", function() end)
		Parent:AddButton("Sub button 2", function() end)
	end
end)

Try("Components: L2 Toggles + Addons", function()
	local Box = ComponentsTab:AddLeftGroupbox("Toggles & Addons", "toggle-right")

	Box:AddToggle("Toggle_Master", {
		Text = "Master toggle", Default = true,
		Tooltip = "Dipakai juga di tab Advanced buat demo dependency.",
		Callback = function(Value) print("[Preview] Master toggle ->", Value) end,
	})

	local WithKey = Box:AddToggle("Toggle_WithKeybind", { Text = "Toggle + keybind", Default = false })
	if WithKey and WithKey.AddKeyPicker then
		WithKey:AddKeyPicker("KeyPicker_Toggle", {
			Text = "Keybind", Default = "None", Mode = "Toggle",
			Modes = { "Always", "Toggle", "Hold" }, SyncToggleState = true,
		})
	end

	local WithColor = Box:AddToggle("Toggle_WithColor", { Text = "Toggle + color picker", Default = false })
	if WithColor and WithColor.AddColorPicker then
		WithColor:AddColorPicker("ColorPicker_Toggle", {
			Title = "Warna aksen", Default = Color3.fromRGB(218, 98, 255),
		})
	end

	Box:AddCheckbox("Checkbox_Force", { Text = "Checkbox (bukan switch)", Default = false })
end)

Try("Components: L3 Sliders", function()
	local Box = ComponentsTab:AddLeftGroupbox("Sliders", "sliders-horizontal")

	Box:AddSlider("Slider_Speed", {
		Text = "Walkspeed", Default = 16, Min = 0, Max = 200,
		Rounding = 0, Suffix = " studs/s", AllowRightClickInput = true,
	})
	Box:AddSlider("Slider_Rate", {
		Text = "Farm rate", Default = 1.5, Min = 0.1, Max = 10, Rounding = 2, Suffix = "x",
	})
	Box:AddSlider("Slider_Money", {
		Text = "Target coins", Default = 250000, Min = 0, Max = 1000000, Rounding = 0, Prefix = "$",
	})
end)

Try("Components: R1 Inputs", function()
	local Box = ComponentsTab:AddRightGroupbox("Inputs", "keyboard")

	Box:AddInput("Input_Text", { Text = "Text input", Default = "", Placeholder = "Ketik sesuatu...", Finished = true })
	Box:AddInput("Input_Numeric", { Text = "Numeric only", Default = "100", Numeric = true, Placeholder = "0" })
	Box:AddInput("Input_NoEmpty", { Text = "Nggak boleh kosong", Default = "N3", AllowEmpty = false, EmptyReset = "---" })
	Box:AddInput("Input_Webhook", {
		Text = "Discord webhook URL", Default = "",
		Placeholder = "https://discord.com/api/webhooks/...", Finished = true,
	})
end)

Try("Components: R2 Dropdowns basic", function()
	local Box = ComponentsTab:AddRightGroupbox("Dropdowns — Basic", "chevron-down")

	Box:AddDropdown("Dropdown_Single", {
		Text = "Single select", Values = { "Forest", "Cave", "Sky", "Lava", "Ocean" },
		Default = 1, Tooltip = "Dropdown biasa, satu pilihan.",
	})
	Box:AddDropdown("Dropdown_Multi", {
		Text = "Multi select + DragSelect",
		Values = { "Auto Farm", "Auto Hatch", "Auto Sell", "Auto Fuse", "Anti Steal" },
		Default = {}, Multi = true, AllowNull = true, DragSelect = true,
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
		Default = 1, Searchable = true, MaxVisibleDropdownItems = 8,
	})
end)

Try("Components: R3 Dropdowns special", function()
	local Box = ComponentsTab:AddRightGroupbox("Dropdowns — Special", "list")

	Box:AddDropdown("Dropdown_Disabled", {
		Text = "Ada item disabled",
		Values = { "Common", "Rare", "Epic", "Legendary", "Mythic" },
		DisabledValues = { "Legendary", "Mythic" }, Default = 1,
	})
	Box:AddDropdown("Dropdown_Images", {
		Text = "Icon per item (ValueImages)",
		Values = { "Pet A", "Pet B", "Pet C" },
		ValueImages = { ["Pet A"] = "paw-print", ["Pet B"] = "flame", ["Pet C"] = "gem" },
		Default = 1,
	})
	Box:AddDropdown("Dropdown_Players", {
		Text = "Player list (auto)", SpecialType = "Player",
		ExcludeLocalPlayer = false, EnablePlayerImages = true, Default = 1,
	})
	Box:AddDropdown("Dropdown_Teams", {
		Text = "Team list (auto)", SpecialType = "Team", Default = 1,
	})
end)

local DD2StatusText = "Selected: -"
do
	local Box = ComponentsTab:AddLeftGroupbox("Dropdown V2 — Popup", "list")
	local DD2Status = Box:AddLabel(DD2StatusText)
	Box:AddDropdownV2("DD2_Rarity", {
		Text = "Rarity (multi, max 4, icon per item)",
		Multi = true,
		Max = 4,
		Icon = "sparkles",
		Placeholder = "Belum milih...",
		Values = {
			{ Text = "Common", Icon = "box" },
			{ Text = "Uncommon", Icon = "info" },
			{ Text = "Rare", Icon = "zap" },
			{ Text = "Epic", Icon = "sparkles" },
			{ Text = "Legendary", Icon = "star" },
			{ Text = "Mythic", Icon = "paw-print" },
			"Tradeable",
			{ Text = "Locked", Disabled = true },
		},
		Callback = function(Value)
			DD2StatusText = "Selected: " .. (#Value == 0 and "-" or table.concat(Value, ", "))
			DD2Status:SetText(DD2StatusText)
		end,
	})
	Box:AddButton("SetSelected {Rare, Mythic}", function()
		local DD = Library.Options and Library.Options.DD2_Rarity or nil
		if DD then
			DD:SetSelected({ "Rare", "Mythic" })
			DD2Status:SetText("Selected: " .. table.concat(DD:GetActiveValues(), ", "))
		end
	end)
end
do
	local Box = ComponentsTab:AddRightGroupbox("Dropdown V2 — Single & API", "settings-2")
	local ModeDD = Box:AddDropdownV2("DD2_Mode", {
		Text = "Mode (single, langsung tutup)",
		Icon = "settings-2",
		Placeholder = "pilih mode...",
		Values = {
			{ Text = "Silent", Icon = "info" },
			{ Text = "Loud", Icon = "bell-ring" },
			{ Text = "Chaos", Icon = "zap" },
		},
	})
	Box:AddButton("SetItems baru (A/B/C text-only)", function()
		ModeDD:SetItems({ "A", "B", "C" })
	end)
	Box:AddButton("SetValue \"Chaos\"", function()
		ModeDD:SetValue("Chaos")
	end)
	Box:AddButton("Clear", function()
		ModeDD:Clear()
	end)
end

local AdvancedTab = Window:AddTab("Advanced", "layers", "Dependency, tabbox, dialog, passthrough")

Try("Advanced: L1 Dependency (Box + Groupbox)", function()
	local Box = AdvancedTab:AddLeftGroupbox("Dependency System", "git-branch")

	local Master = Box:AddToggle("Adv_Master", { Text = "Aktifin sub-settings", Default = false })

	local Dep = Box:AddDependencyBox()
	Dep:SetupDependencies({ { Master, true } })
	Dep:AddLabel("Isi box ini cuma muncul kalau master ON", false)
	Dep:AddSlider("Adv_DepSlider", { Text = "Intensity", Default = 50, Min = 0, Max = 100, Suffix = "%" })
	Dep:AddDropdown("Adv_DepDropdown", { Text = "Mode", Values = { "Aggressive", "Balanced", "Safe" }, Default = 1 })

	local MasterGB = Box:AddToggle("Adv_MasterGB", { Text = "Munculin dep-groupbox", Default = false })
	local DepGB = Box:AddDependencyGroupbox()
	DepGB:SetupDependencies({ { MasterGB, true } })
	DepGB:AddLabel("Groupbox ini nempel otomatis di bawah.", false)
	DepGB:AddToggle("Adv_GBToggle", { Text = "Opsi di dalam dep-groupbox", Default = true })
end)

Try("Advanced: L2 Tabbox kiri (3 sub-tab)", function()
	local Tabbox = AdvancedTab:AddLeftTabbox("Contoh Tabbox")

	local SubA = Tabbox:AddTab("Pets", "list")
	SubA:AddToggle("TB_PetAutoSell", { Text = "Auto sell pets", Default = false })
	SubA:AddSlider("TB_PetMinRate", { Text = "Min rate", Default = 100, Min = 0, Max = 5000, Prefix = "$" })

	local SubB = Tabbox:AddTab("Eggs", "chevron-down")
	SubB:AddToggle("TB_EggAutoHatch", { Text = "Auto hatch", Default = false })
	SubB:AddDropdown("TB_EggZone", { Text = "Zone", Values = { "Forest", "Cave", "Sky" }, Default = 1 })

	local SubC = Tabbox:AddTab("Misc", "info")
	SubC:AddLabel("Tabbox juga bisa di dalam groupbox (lihat kanan).", true)
	SubC:AddButton("Contoh button di sub-tab", function() end)
end)

Try("Advanced: L3 Collapse control", function()
	local Box = AdvancedTab:AddLeftGroupbox("Collapse Control", "chevrons-up-down")
	Box:AddLabel("Target-nya = groupbox 'Dependency System' di kiri atas.", true)

	local function GetTarget()
		return AdvancedTab.Groupboxes and AdvancedTab.Groupboxes["Dependency System"]
	end

	Box:AddButton("Toggle collapsed", function()
		local T = GetTarget()
		if T and T.ToggleCollapsed then T:ToggleCollapsed() end
	end)
	Box:AddButton("Hide total", function()
		local T = GetTarget()
		if T and T.Hide then T:Hide() end
	end)
	Box:AddButton("Show lagi", function()
		local T = GetTarget()
		if T and T.Show then T:Show() end
	end)
	Box:AddButton("Resize", function()
		local T = GetTarget()
		if T and T.Resize then T:Resize() end
	end)
end)

Try("Advanced: R1 Nested Tabbox dalam Groupbox", function()
	local Box = AdvancedTab:AddRightGroupbox("Nested Tabbox", "layers")
	local Inner = Box:AddTabbox({ Name = "Webhook Embeds" })

	local S1 = Inner:AddTab("Status", "gauge")
	S1:AddToggle("Nest_Status", { Text = "Kirim status embed", Default = true })

	local S2 = Inner:AddTab("Egg", "chevron-down")
	S2:AddToggle("Nest_Egg", { Text = "Kirim egg embed", Default = false })

	local S3 = Inner:AddTab("Pets", "list")
	S3:AddToggle("Nest_Pets", { Text = "Kirim pets embed", Default = false })
end)

Try("Advanced: R2 UIPassthrough", function()
	local Box = AdvancedTab:AddRightGroupbox("UI Passthrough", "frame")
	Box:AddLabel("Masukin GuiObject buatan lu ke dalam UI library:", true)
	Box:AddUIPassthrough("Passthrough_Demo", { Instance = PassthroughFrame, Height = 44 })
	Box:AddLabel("Frame di atas dibangun manual pakai Instance.new().", true)
end)

Try("Advanced: R3 Dialog", function()
	local Box = AdvancedTab:AddRightGroupbox("Dialog", "message-square")

	Box:AddButton("Dialog 3 button variant", function()
		local Dialog = Window:AddDialog("Dialog_Demo", {
			Title = "Konfirmasi Aksi",
			Description = "Dialog modal: overlay gelap, scale-in animation, footer button 4 variant.",
			Icon = "info",
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
			Icon = "zap", IconColor = Color3.fromRGB(255, 90, 90),
		})
		Dialog:AddFooterButton("No", { Title = "Jangan", Variant = "Secondary", Order = 1 })
		Dialog:AddFooterButton("Yes", { Title = "Ya, reset", Variant = "Destructive", Order = 2, WaitTime = 3 })
	end)

	Box:AddButton("Dialog + komponen di dalamnya", function()
		local Dialog = Window:AddDialog("Dialog_Form", {
			Title = "Form dalam Dialog",
			Description = "Dialog inherit BaseGroupbox, jadi bisa diisi komponen. Tanpa Info.Icon = tanpa icon (opsi NO-ICON).",
		})
		Dialog:AddToggle("Dlg_Toggle", { Text = "Opsi tambahan", Default = true })
		Dialog:AddSlider("Dlg_Slider", { Text = "Nilai", Default = 50, Min = 0, Max = 100, Suffix = "%" })
		Dialog:AddFooterButton("Ok", { Title = "Simpan", Variant = "Primary", Order = 1 })
	end)
end)

Try("Advanced: KeyBox (execute key)", function()
	if typeof(Window.AddKeyTab) ~= "function" then
		warn("[N3V4 Preview] AddKeyTab nggak ada di library ini — paste ulang Library/N3V3-NoObfus.lua terbaru.")
		return
	end
	local KeyTab = Window:AddKeyTab("Execute", "key", "Demo KeyTab + AddKeyBox")
	KeyTab:AddKeyBox(function(KeyText)
		SafeNotify({ Title = "KeyBox", Description = "Key masuk: " .. tostring(KeyText), Time = 3 })
	end)
end)

local MediaTab = Window:AddTab("Media", "image", "Viewport 3D, image, video, spotlight, feed")

Try("Media: L1 Viewport interaktif", function()
	local Box = MediaTab:AddLeftGroupbox("Viewport Interaktif", "rotate-3d")
	Box:AddLabel("Klik kanan + drag di dalam viewport buat muter manual.", true)

	local VP = Box:AddViewport("Media_Viewport", { Height = 220, Spin = false, Interactive = true })
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

Try("Media: L2 Image + kontrol", function()
	local Box = MediaTab:AddLeftGroupbox("Image Element", "image")

	local Img = Box:AddImage("Media_Image", {
		Image = CONFIG.ImageAsset, Height = 160,
		ScaleType = Enum.ScaleType.Fit, Color = Color3.fromRGB(255, 255, 255), Transparency = 0,
	})

	Box:AddSlider("Media_ImgHeight", {
		Text = "Tinggi image", Default = 160, Min = 60, Max = 400, Suffix = "px",
		Callback = function(Value) if Img and Img.SetHeight then Img:SetHeight(Value) end end,
	})
	Box:AddDropdown("Media_ImgScale", {
		Text = "ScaleType", Values = SCALE_TYPE_NAMES, Default = 2,
		Tooltip = "Fit / Crop / Stretch / Slice / Tile — member asli Enum.ScaleType",
		Callback = function(Value)
			if Img and Img.SetScaleType then
				Img:SetScaleType(ResolveScale(Value))
			end
		end,
	})

	local Tint = Box:AddToggle("Media_ImgTint", { Text = "Tint warna", Default = false })
	if Tint and Tint.AddColorPicker then
		Tint:AddColorPicker("Media_ImgColor", {
			Title = "Warna tint", Default = Color3.fromRGB(218, 98, 255),
			Callback = function(Color) if Img and Img.SetColor then Img:SetColor(Color) end end,
		})
	end
end)

Try("Media: L3 Video", function()
	local Box = MediaTab:AddLeftGroupbox("Video Element", "video")

	if CONFIG.VideoAsset == "" or not CONFIG.VideoAsset then
		Box:AddLabel("CONFIG.VideoAsset masih kosong.", true)
		Box:AddLabel("Isi pakai asset ID VideoFrame punya lu, terus reload.", true)
		Box:AddLabel("VideoFrame nggak bisa pakai decal biasa.", true)
		return
	end

	local Vid = Box:AddVideo("Media_Video", {
		Video = CONFIG.VideoAsset, Height = 180, Looped = true, Playing = true, Volume = 1,
	})
	Box:AddButton("Play", function() if Vid and Vid.Play then Vid:Play() end end)
	Box:AddButton("Pause", function() if Vid and Vid.Pause then Vid:Pause() end end)
	Box:AddSlider("Media_VidVol", {
		Text = "Volume", Default = 100, Min = 0, Max = 100, Suffix = "%",
		Callback = function(V) if Vid and Vid.SetVolume then Vid:SetVolume(V / 100) end end,
	})
end)

Try("Media: R1 SpotlightCard 2D <-> 3D", function()
	local Box = MediaTab:AddRightGroupbox("Spotlight Card", "star")

	local Card = Box:AddSpotlightCard("Media_Spotlight", {
		Height = 150, Title = "Mythic Pet",
		Description = "SpotlightCard bisa nampilin gambar 2D ATAU model 3D.",
	})
	if Card and Card.SetData then
		Card:SetData("Mythic Pet", "Rate 2.4K/s · Scale 1.8 · 96 Kg · Mutasi: Shiny", nil, DemoEgg)
	end
	if Card and Card.SetLines then
		Card:SetLines({
			{ Label = "Rarity", Value = "Mythic", Color = Color3.fromRGB(255, 210, 30) },
			{ Label = "Mutasi", Value = "Shiny", Color = Color3.fromRGB(0, 220, 255) },
		})
	end
	if Card and Card.SetImageGradient then
		Card:SetImageGradient({ Preset = "Gold", Rotation = -90 })
	end

	local CardNT = Box:AddSpotlightCard("Media_NoText", {
		Height = 90,
		NoText = true,
		Image = CONFIG.ImageAsset,
	})
	if CardNT then
		CardNT:SetData(nil, nil, CONFIG.ImageAsset, nil)
	end
	Box:AddLabel("Kartu bawah = mode no-text (gambar full).", true)

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

Try("Media: R2 ScrollFeed besar", function()
	local Box = MediaTab:AddRightGroupbox("Live Feed", "rss")
	local Feed = Box:AddScrollFeed("Media_Feed", { Height = 220 })

	for i = 1, 12 do
		Feed:AddItem({
			Icon = CONFIG.ImageAsset,
			Title = string.format("Event log #%d", i),
			Detail = string.format("Auto-generated row · %d/s · scale %.1f", 100 * i, 1 + (i % 5) / 10),
			RightTag = tostring(math.random(10, 100)) .. "%",
		})
	end

	Box:AddButton("Clear feed", function() if Feed and Feed.Clear then Feed:Clear() end end)
end)

Try("Media: R3 Asset info", function()
	local Box = MediaTab:AddRightGroupbox("Asset Dipakai", "info")
	Box:AddLabel("Icon = nama lucide, di-resolve library (offline-ready).", true)
	Box:AddDivider({ Text = "Spritesheet lucide", Margin = 4 })
	Box:AddLabel("Sheet 1  rbxassetid://136111683851629", false)
	Box:AddLabel("Sheet 2  rbxassetid://135883070486325", false)
	Box:AddLabel("117 icon offline di Library:GetIcon fallback", false)
	Box:AddDivider({ Text = "Gambar polos", Margin = 4 })
	Box:AddLabel("ImageAsset  " .. CONFIG.ImageAsset, false)
	Box:AddLabel(string.format("VideoAsset  %s", CONFIG.VideoAsset == "" and "(kosong)" or CONFIG.VideoAsset), false)
	Box:AddDivider({ Text = "Catatan", Margin = 4 })
	Box:AddLabel("ScrollFeed itemData.Icon TIDAK apply ImageRect,", true)
	Box:AddLabel("jadi harus gambar polos — bukan nama lucide.", true)
end)

local OverlaysTab = Window:AddTab("Overlays", "bell", "Notification, draggable, overlay, dashboard")

Try("Overlays: L1 Notifications", function()
	local Box = OverlaysTab:AddLeftGroupbox("Notifications", "bell-ring")

	Box:AddButton("Notify simple (string)", function()
		SafeNotify("Ini notification paling simpel.")
	end)
	Box:AddButton("Notify title + description", function()
		SafeNotify({ Title = "Auto Farm", Description = "Berhasil. 128 egg dikumpulin.", Time = 4 })
	end)
	Box:AddButton("Notify + icon", function()
		SafeNotify({
			Title = "Pet diperoleh!", Description = "Mythic Dragon · Shiny mutation",
			Icon = "paw-print", IconColor = Color3.fromRGB(218, 98, 255), Time = 4,
		})
	end)
	Box:AddButton("Notify big icon + warna custom", function()
		SafeNotify({
			Title = "RIFT EVENT", TitleColor = Color3.fromRGB(255, 200, 60),
			Description = "Event dimulai di 3 zona. Sisa 5 menit.",
			DescriptionColor = Color3.fromRGB(220, 220, 220),
			BigIcon = CONFIG.ImageAsset, Time = 5,
		})
	end)
	Box:AddButton("Notify + progress steps (persist)", function()
		local Notif = Library:Notify({
			Title = "Hatching...", Description = "Step 0 / 5", Steps = 5, Persist = true,
		})
		if typeof(Notif) ~= "table" then return end

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

Try("Overlays: L2 Draggable label & button", function()
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
			Func = function() SafeNotify({ Title = "Draggable Button", Description = "Diklik!", Time = 2 }) end,
		})
	end)

	Box:AddButton("Spawn draggable image button", function()
		Library:AddDraggableImageButton({
			Icon = CONFIG.ImageAsset,
			IconSize = 28,
			Func = function() SafeNotify({ Title = "Image Button", Description = "Diklik!", Time = 2 }) end,
		})
	end)
end)

Try("Overlays: L3 Draggable menu", function()
	local Box = OverlaysTab:AddLeftGroupbox("Draggable Menu", "menu")
	Box:AddLabel("AddDraggableMenu nge-return (Holder, Container) — raw Instance.", true)
	Box:AddLabel("Nggak ada method AddButton, isinya dibangun manual.", true)

	Box:AddButton("Spawn draggable menu", function()
		local Holder, Container = Library:AddDraggableMenu("Menu Cepat")
		if typeof(Container) ~= "Instance" then return end

		for i = 1, 3 do
			BuildMenuItem(Container, "Aksi " .. i, Library.Scheme, function()
				SafeNotify({ Title = "Menu", Description = "Aksi " .. i .. " dijalankan", Time = 2 })
			end)
		end

		local MenuWidth, ItemH, ItemPad, Count = 170, 26, 7, 3
		local ContainerH = (Count * ItemH) + ((Count - 1) * ItemPad) + (ItemPad * 2)

		Container.AutomaticSize = Enum.AutomaticSize.None
		Container.Size = UDim2.fromOffset(MenuWidth, ContainerH)
		Holder.AutomaticSize = Enum.AutomaticSize.None
		Holder.Size = UDim2.fromOffset(MenuWidth, 35 + ContainerH)
	end)
end)

Try("Overlays: R1 Overlay panel (SetRow)", function()
	local Box = OverlaysTab:AddRightGroupbox("Overlay Panel", "picture-in-picture")
	Box:AddLabel("Overlay = panel stat key-value. API: SetRow / RemoveRow / ClearRows.", true)

	local LiveOverlay = nil

	Box:AddButton("Bikin overlay + isi row", function()
		if LiveOverlay then LiveOverlay:Destroy() LiveOverlay = nil end

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

	Box:AddButton("RemoveRow + ClearRows", function()
		if not LiveOverlay then return end
		LiveOverlay:RemoveRow("Pets")
		task.delay(1, function()
			if LiveOverlay and LiveOverlay.ClearRows then LiveOverlay:ClearRows() end
		end)
	end)

	Box:AddButton("Tutup overlay", function()
		if LiveOverlay then LiveOverlay:Destroy() LiveOverlay = nil end
	end)
end)

Try("Overlays: R2 Dashboard + Loading states", function()
	local Box = OverlaysTab:AddRightGroupbox("Dashboard & Loading", "gauge")

	Box:AddButton("Buka Dashboard window", function()
		local Dash = Library:CreateDashboard({
			Title = "N3 Live Dashboard",
			Position = UDim2.fromOffset(25, 120),
		})
		Dash:AddStat("Fps", { Title = "FPS", Icon = "gauge", Suffix = " fps", Default = 60 })
		Dash:AddStat("Player", { Title = "Players", Icon = "list", Default = 12 })
		Dash:AddStat("Cash", { Title = "Cash", Icon = "sparkles", Suffix = " k", Default = 128, Details = { { Label = "Session", Value = 41 }, { Label = "Bank", Value = 87 } } })
		Dash:AddMeter("Cpu", { Title = "CPU", Icon = "zap", Default = 35 })
		Dash:AddMeter("Mem", { Title = "Memory", Icon = "droplets", Default = 62 })
		Dash:AddMeter("Egg", { Title = "Eggs", Icon = "image", Min = 0, Max = 500, Default = 128, Suffix = "/500", Details = { { Label = "Mythic", Value = 12 }, { Label = "Rare", Value = 84 }, { Label = "Epic", Value = 32 } } })
		task.spawn(function()
			while Dash.Frame.Parent do
				task.wait(1)
				Dash:SetStat("Fps", 55 + math.random(0, 10))
				Dash:SetStat("Cash", 128 + math.random(0, 40))
				Dash:SetMeter("Cpu", 20 + math.random(0, 60))
				Dash:SetMeter("Mem", 40 + math.random(0, 50))
				Dash:SetMeter("Egg", math.min(500, 128 + math.random(0, 60)))
				Dash:SetDetails("Egg", {
					{ Label = "Mythic", Value = math.random(5, 40) },
					{ Label = "Rare", Value = math.random(200, 400) },
					{ Label = "Epic", Value = math.random(20, 60) },
				})
				Dash:SetDetails("Cash", {
					{ Label = "Session", Value = math.random(20, 60) },
					{ Label = "Bank", Value = math.random(60, 120) },
				})
			end
		end)
	end)

	Box:AddDivider({ Text = "Loading", Margin = 4 })

	Box:AddButton("Replay loading normal", function()
		RunLoadingSequence()
	end)

	Box:AddButton("Loading + error page", function()
		if Library.ActiveLoading then
			Library.ActiveLoading:Destroy()
			task.wait(0.1)
		end

		local Loading = Library:CreateLoading({
			Title = CONFIG.Title, TotalSteps = 3, CurrentStep = 1, AutoResizeHeight = true,
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

Try("Overlays: R3 Context menu (right-click)", function()
	local Box = OverlaysTab:AddRightGroupbox("Context Menu", "list")
	Box:AddLabel("Klik KANAN button di bawah.", true)

	local Trigger = Box:AddButton("Right-click gue", function()
		SafeNotify({ Title = "Context Menu", Description = "Klik kiri = callback biasa", Time = 2 })
	end)

	local Target = Trigger and Trigger.Base
	if typeof(Target) ~= "Instance" or not Target:IsA("GuiObject") then
		Box:AddLabel("Trigger.Base nggak ketemu — skip.", true)
		return
	end

	local Ctx = Library:AddContextMenu(
		Target,
		UDim2.fromOffset(160, 0),
		function() return { 0, Target.AbsoluteSize.Y + 2 } end,
		1
	)

	if typeof(Ctx) ~= "table" or typeof(Ctx.Menu) ~= "Instance" then
		Box:AddLabel("AddContextMenu gagal — skip.", true)
		return
	end

	local MenuItems = {
		{ "Copy value", function() SafeNotify({ Title = "Context", Description = "Copy value", Time = 2 }) end },
		{ "Reset ke default", function() SafeNotify({ Title = "Context", Description = "Reset", Time = 2 }) end },
		{ "Set max", function() SafeNotify({ Title = "Context", Description = "Set max", Time = 2 }) end },
		{ "Disable", function() SafeNotify({ Title = "Context", Description = "Disable", Time = 2 }) end },
	}

	for _, Spec in ipairs(MenuItems) do
		BuildMenuItem(Ctx.Menu, Spec[1], Library.Scheme, function()
			Spec[2]()
			if Ctx.Close then Ctx:Close() end
		end)
	end

	Target.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton2 then
			if Ctx.Toggle then Ctx:Toggle() end
		end
	end)

	Box:AddButton("Buka manual (kiri)", function()
		if Ctx.Toggle then Ctx:Toggle() end
	end)
end)

pcall(function()
	local Mod = ReplicatedStorage:FindFirstChild("N3V4_UISettings")
	if Mod then
		local SettingsModule = require(Mod)
		if SettingsModule and SettingsModule.Attach then
			SettingsModule:Attach(Library, Window)
		end
	end
end)

task.spawn(function()
	for _ = 1, 30 do
		if shared.N3V4_UISettings_Attached then
			return
		end
		local SettingsModule = shared.N3V4_UISettings
		if SettingsModule and SettingsModule.Attach then
			SettingsModule:Attach(Library, Window)
			return
		end
		task.wait(0.1)
	end
end)

PrintReport()

SafeNotify({
	Title = "Preview v2 siap",
	Description = string.format("%d section OK · %d gagal · icon lucide offline-ready", #Report.OK, #Report.Failed),
	Icon = "circle-check",
	Time = 6,
})

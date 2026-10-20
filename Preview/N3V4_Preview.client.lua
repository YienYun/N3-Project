--[[
	================================================================================
	 N3V4 — PREVIEW KIT v4   (LocalScript)
	================================================================================

	 CHANGELOG v4.5 — PREVIEW BERSIH:
	   • SEMUA setingan UI DIHAPUS dari preview (Theme Lab + Wallpaper tab).
	     Preview sekarang MURNI showcase komponen: button, toggle, dropdown,
	     slider, image, viewport, feed, notify, dialog, dll.
	   • Setingan desain pindah ke FILE BARU: Preview/N3V4_UISettings.module.lua
	     (ModuleScript "N3V4_UISettings"). Preview auto-require kalau ada ->
	     tab "UI Settings" + "Wallpaper & Surface" muncul sendiri.
	   • Wallpaper & surface NGGAK di-set di preview lagi: default-nya udah
	     di LIBRARY (resep user), jadi begitu require langsung aktif.
	   • Game script (N3-SAE.lua) dibalikin original — fokus UI, bukan script game.

	 FIX (v4.4.2) — PICKER AKHIRNYA BENERAN MUNCUL:
	   • BUG: AddColorPicker di library ini HARUS nempel ke object yang punya
	     .TextLabel (Toggle / Button). Gue sempat nempel-in ke GROUPBOX ->
	     TextLabel nil -> crash runtime -> groupbox WARNA isinya label doang,
	     picker-nya nggak ke-render. (Keliatan di screenshot user.)
	   • Sekarang tiap warna punya TOGGLE sendiri sebagai host:
	     "Tint aktif" / "Overlay aktif" / "Canvas warna custom" /
	     "Group warna custom". Toggle OFF = ikut bawaan/theme, ON = pakai
	     warna lu. Klik kotak warna di kanan baris = picker.
	   • Toggle & warna overlay pindah dari box Overlay ke box WARNA
	     (biar semua warna satu tempat). Box Overlay sisa slider + reset.

	 CHANGELOG v4.4.1:
	   • Groupbox BARU "WARNA — custom lengkap" (kiri): SEMUA color picker
	     dikumpulin di satu tempat biar nggak mungkin kelewat — tint wallpaper,
	     warna overlay, warna canvas, warna kartu group + tombol reset per warna.
	   • Groupbox BARU "Master" (kanan): RESET SEMUA / Wallpaper OFF /
	     Wallpaper ON + cara cek versi copy-an lu lewat footer.
	   • Overlay default OFF — scrim hitam inilah yang bikin wallpaper keliatan
	     ABU-ABU/kusam waktu nyala. Nyala-in manual kalau butuh.
	   • Footer window = v4.4: kalau footer lu belum v4.4, copy-an lu LAMA.

	 CHANGELOG v4.4 — WALLPAPER STUDIO LENGKAP:
	   • Default BALIK ke wallpaper keliatan (canvas 100%) tapi kartu group
	     SOLID pakai warna ASLI theme (contrast 0) — nggak diabu-abuin lagi.
	   • COLOR PICKER langsung (nggak disembunyiin di toggle):
	     tint wallpaper, warna overlay, warna canvas, warna kartu group.
	   • Tiap picker punya tombol reset / "ikut theme lagi".
	   • Groupbox L4 dijelasin ATURAN LAYER biar nggak bingung kenapa
	     "group transparency kayak ga ngaruh" (jawabannya: cuma keliatan
	     kalau canvas-nya transparan).
	   • Preset baru "Kartu nongol (contrast 15)"; preset lama contrast-nya
	     di-nol-in biar nggak maksa grey.
	   • Print resep sekarang ikut nyertain GroupColor/CanvasColor override.

	 FIX (v4.3) — BALIKIN NORMAL:
	   • BUG KRITIS: ClampTransparency didefinisiin DI BAWAH Library:SetSurface.
	     Di Lua, local yang dideklarasinya belakangan nggak keliatan dari function
	     di atasnya -> jadi global nil -> "attempt to call a nil value".
	     Efeknya SEMUA slider/button surface "ga work". Helper block udah
	     dipindah ke ATAS Library:SetBackgroundImage di library.
	   • Default Surface BALIK NORMAL: Canvas 0 (solid), Group 0 (solid),
	     Contrast 0 (warna kartu sama kayak semula, nggak diabu-abuin).
	   • Tombol reset diganti: "BALIKIN NORMAL (semula)" + "Coba: wallpaper
	     keliatan". Preset "Matiin semua" -> "Matiin semua (balik normal)".
	   • Live Info tambah baris status: nge-warn kalau image GAGAL load
	     (yang nembus itu game-nya, bukan wallpaper).
	   • Sekarang LU yang atur angka lewat slider — default nggak maksa tampilan.

	 FIX (v4.2) — SURFACE SYSTEM:
	   • Wallpaper mode "back" dulu NGGAK keliatan karena Container (area konten)
	     SOLID nutupin dia. Sekarang ada Canvas transparency -> set 100%.
	   • Mode "front" bikin button/dropdown/slider/text keliatan TEMBUS — itu
	     karena wallpaper digambar DI ATAS komponen (ZIndex 999). Buat
	     wallpaper-as-background, pakai "back" + canvas 100%.
	   • Kartu group sekarang SOLID default + GroupContrast (default 10%) biar
	     kebaca sebagai kartu di atas wallpaper, beda dari background window.
	   • Groupbox baru: "Canvas & Kartu Group" (kiri) + "Resep Aktif" (kanan).
	     Tombol "Print resep Lua" nge-print SetWallpaper+SetSurface siap paste.
	   • CONFIG.Surface baru: CanvasTransparency=1, GroupTransparency=0,
	     GroupContrast=10.

	 FIX (v4.1):
	   • Enum.ScaleType.Fill itu NGGAK ADA di Roblox — bikin seluruh library
	     gagal di-require. Member asli cuma: Stretch, Slice, Tile, Fit, Crop.
	   • Sekarang tabel ScaleType dibangun dari GetEnumItems() (nggak mungkin
	     ngarang lagi) + alias Fill/Cover -> Crop, Contain -> Fit
	   • Dropdown ScaleType di tab Media juga kena bug yang sama (crash pas
	     dipilih). Udah dibenerin lewat ResolveScale()

	 CHANGELOG v4 (WALLPAPER):
	   • Tab baru "Wallpaper" — 3 groupbox kiri / 3 kanan (simetris)
	   • Kontrol: Asset ID (paste), transparency, tint, ScaleType, Layer
	     (back/front), Overlay/scrim (toggle + warna + transparency)
	   • 6 preset: Wallpaper gue / Subtle / Bold / Wash / Accent tint / Off
	   • Live Info pakai Window:GetWallpaperInfo()
	   • ID wallpaper lu (111593326989465) jadi default di CONFIG.Wallpaper
	   • SEMUA kontrol manggil API LIBRARY (Library:SetWallpaper), bukan hack
	     preview -> yang lu lihat di sini = yang bakal hub lu dapet
	   • Grup "Font & Background" di Theme Lab dirampingin jadi "Font"
	     (kontrol background pindah ke tab Wallpaper, nggak dobel)

	 CHANGELOG v3 (revisi icon):
	   • Icon balik ke NAMA LUCIDE — sama persis kayak hub lu ("house", "paw-print",
	     "egg", "settings", ...). Bukan rbxassetid tambangan lagi.
	   • v2 gue salah: gue pakai asset ID dari Games/Source/*.lua yang ternyata
	     PRIVATE punya game -> "The experience doesn't have access permission".
	   • Solusinya di LIBRARY, bukan di preview: gue tambahin OfflineLucideIcons
	     (117 icon, spritesheet PUBLIK) + mirror GitHub. Jadi lucide tetep muncul
	     walaupun HTTP off / gitlab down.
	   • Corner radius default 4 -> 10 (lu approve lewat slider Theme Lab)

	 CHANGELOG v2:
	   • FIX: AddDraggableLabel error "Icon must be a valid Roblox asset..."
	   • FIX: AddContextMenu error "AddButton is not a valid member of Frame"
	   • Layout SIMETRIS: groupbox kiri = kanan di tiap tab
	   • Animasi library di-nyalain dari default (Library/N3V3-NoObfus.lua)

	 CARA PAKAI:
	   1. ReplicatedStorage > ModuleScript "N3V4"  = isi N3V3-NoObfus.lua
	      ^ WAJIB copy ulang, library-nya berubah (icon fallback + animasi + radius)
	   2. StarterPlayer > StarterPlayerScripts > LocalScript "N3V4_Preview" = file ini
	   3. Game Settings > Security > Allow HTTP Requests = ON  ->  OPSIONAL.
	      Icon udah punya fallback offline, jadi HTTP nggak dibutuhin lagi.
	   Tekan Play.

	================================================================================
]]

--// SERVICES \\--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

--================================================================================
-- CONFIG
--================================================================================
local CONFIG = {
	ModuleName = "N3V4",

	Title = "N3 HUB",
	Footer = "N3V4 • UI Preview Kit v4.5",
	Icon = "rbxassetid://117688744510818", -- N3 logo

	-- Asset buat demo Image / SpotlightCard / Feed / ValueImages
	ImageAsset = "rbxassetid://117688744510818",

	-- VideoFrame butuh asset ID punya lu. Kosong = section-nya nunjukin notice.
	VideoAsset = "",

	ShowLoadingIntro = true,
	LoadingSteps = 5,
	LoadingStepDelay = 0.45,

	ToggleKey = Enum.KeyCode.RightControl,
	VerboseErrors = true,
}

--================================================================================
-- ICON
--================================================================================
-- Preview ini pakai NAMA LUCIDE langsung, sama persis kayak hub lu
-- (N3-SAE.lua pakai "house", "paw-print", "egg", "settings", ...).
--
-- Icon-nya DIJAMIN muncul tanpa HTTP, karena library sekarang punya
-- OfflineLucideIcons fallback (117 icon, spritesheet publik rbxassetid://
-- 136111683851629 & 135883070486325) yang di-extract dari lucide-roblox-direct.
--
-- Chain di Library:GetIcon -> gitlab -> mirror GitHub -> data offline.
--
-- PENTING: ScrollFeed.itemData.Icon TIDAK apply ImageRectOffset/Size
-- (Library line 5134: `Image = itemData.Icon or ""`). Jadi di situ harus pakai
-- gambar polos (CONFIG.ImageAsset), BUKAN nama lucide — kalau nggak yang
-- ke-render seluruh spritesheet.

--================================================================================
-- REPORT HELPER
--================================================================================
local Report = { OK = {}, Failed = {} }

-- FORWARD DECLARATION — wajib.
-- PrintReport() didefinisiin SEBELUM library di-require. Tanpa ini, `Library`
-- di dalam PrintReport nangkep GLOBAL (nil), karena library set getgenv().Library
-- yang di Studio fallback ke `shared`, bukan `_G`.
-- Error yang muncul: "attempt to index nil with 'GetIcon'"
local Library

-- Enum.ScaleType member ASLI Roblox cuma: Stretch, Slice, Tile, Fit, Crop.
-- "Fill" NGGAK ADA — dan nyentuh Enum.ScaleType.Fill langsung bikin error
-- "<name> is not a valid member of Enum.ScaleType". Kalau itu kejadian di top
-- level module, seluruh script gagal load. Makanya tabel ini dibangun dari
-- GetEnumItems() (dijamin cuma berisi member yang beneran ada), plus alias.
local SCALE_TYPES = {}
for _, ScaleItem in Enum.ScaleType:GetEnumItems() do
	SCALE_TYPES[ScaleItem.Name] = ScaleItem
end
SCALE_TYPES.Fill = SCALE_TYPES.Fill or SCALE_TYPES.Crop -- CSS cover
SCALE_TYPES.Cover = SCALE_TYPES.Cover or SCALE_TYPES.Crop
SCALE_TYPES.Contain = SCALE_TYPES.Contain or SCALE_TYPES.Fit -- CSS contain

-- Urutan buat dropdown: Crop paling enak buat wallpaper (kayak CSS cover)
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

	-- Defensive: kalau Library belum ke-assign (require gagal), jangan meledak
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

--================================================================================
-- RESOLVE LIBRARY
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
	error(string.format("[N3V4 Preview] ModuleScript %q nggak ketemu (nunggu 15 detik).", CONFIG.ModuleName), 0)
end

Library = require(ModuleObject) -- assign ke forward-declared local di atas (BUKAN `local`)

if typeof(Library) ~= "table" or typeof(Library.CreateWindow) ~= "function" then
	error("[N3V4 Preview] Module N3V4 nggak nge-return Library yang valid.", 0)
end

print(string.format(
	"[N3V4 Preview] Library OK | Device: %s | Mobile: %s | DPI: %s | Radius: %s | Animations: %s",
	tostring(Library.DevicePlatform), tostring(Library.IsMobile),
	tostring(Library.DPIScale), tostring(Library.CornerRadius),
	Library.Animations and "ON" or "OFF"
))

local function SafeNotify(Info)
	local Success, Err = pcall(function()
		return Library:Notify(Info)
	end)
	if not Success and CONFIG.VerboseErrors then
		warn("[N3V4 Preview] Notify gagal: " .. tostring(Err))
	end
	return Success
end


--================================================================================
-- DEMO ASSETS
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

-- Builder item menu manual (dipakai DraggableMenu & ContextMenu, dua-duanya
-- nge-return raw Instance / table tanpa method AddButton)
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

--================================================================================
-- LOADING SCREEN
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
		task.wait((CONFIG.LoadingStepDelay * CONFIG.LoadingSteps) + 0.7)
	end)
end

--================================================================================
-- MAIN WINDOW
--================================================================================
local WindowInfo = {
	Title = CONFIG.Title,
	Footer = CONFIG.Footer,
	Icon = CONFIG.Icon,
	AutoShow = true,
	Center = true,
	Resizable = true,
	ToggleKeybind = CONFIG.ToggleKey,
	-- Explicit, biar tetap ON walaupun default library berubah
	Animations = {
		ToggleWindow = true,
		TabSwitch = true,
		Groupbox = true,
		Dropdown = true,
		KeyPicker = true,
	},
}

-- Wallpaper & surface NGGAK di-set di sini: default-nya udah ada di LIBRARY
-- (Templates.Window + Library.Surface = resep user). Setingan desain semuanya
-- ada di file terpisah: Preview/N3V4_UISettings.module.lua
local Window = Library:CreateWindow(WindowInfo)

--================================================================================
-- TAB 1 — OVERVIEW   (2 kiri / 2 kanan — simetris)
--================================================================================
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

--================================================================================
-- TAB 2 — COMPONENTS   (3 kiri / 3 kanan — simetris)
--================================================================================
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

--================================================================================
-- TAB 3 — ADVANCED   (3 kiri / 3 kanan — simetris)
--================================================================================
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

	-- Ambil reference lewat Tab.Groupboxes (diisi otomatis sama library tiap AddGroupbox)
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

-- KeyBox = elemen level Tab (muncul di area atas tab), nggak ngaruh simetri kiri/kanan
Try("Advanced: KeyBox (execute key)", function()
	AdvancedTab:AddKeyBox(function(KeyText)
		SafeNotify({ Title = "KeyBox", Description = "Key masuk: " .. tostring(KeyText), Time = 3 })
	end)
end)

--================================================================================
-- TAB 4 — MEDIA   (3 kiri / 3 kanan — simetris)
--================================================================================
local MediaTab = Window:AddTab("Media", "image", "Viewport 3D, image, video, spotlight, feed")

Try("Media: L1 Viewport interaktif", function()
	local Box = MediaTab:AddLeftGroupbox("Viewport Interaktif", "rotate-3d")
	Box:AddLabel("Drag mouse di dalam viewport buat muter manual.", true)

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
			-- Dulu di sini ada `Fill = Enum.ScaleType.Fill` yang bikin crash
			-- tiap kali dropdown dipilih. Sekarang lewat ResolveScale (aman).
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

--================================================================================
-- TAB 5 — OVERLAYS   (3 kiri / 3 kanan — simetris)
--================================================================================
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

	-- FIX v2: icon HARUS rbxassetid / URL valid. Nama lucide ("zap") bikin
	-- assert error di Library:2023 kalau HTTP fetch lucide gagal.
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

		-- Holder & Container pakai AutomaticSize/Scale yang bisa collapse jadi 0px
		-- kalau isinya dibikin manual. Set eksplisit biar pasti keliatan.
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

	-- FIX v2: AddContextMenu nge-return TABLE { Open, Close, Toggle, SetSize,
	-- Destroy, Menu, Holder, Active } — BUKAN object dengan AddButton.
	-- Item harus dibikin manual ke Ctx.Menu. List=1 -> library bikinin
	-- UIListLayout + AutomaticSize.Y di Menu.
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

	-- Library nggak auto-bind right-click, kita bind sendiri
	Target.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton2 then
			if Ctx.Toggle then Ctx:Toggle() end
		end
	end)

	Box:AddButton("Buka manual (kiri)", function()
		if Ctx.Toggle then Ctx:Toggle() end
	end)
end)

--================================================================================
-- OPSIONAL: FILE SETTINGS TERPISAH
--================================================================================
-- Preview ini NGGAK punya setingan UI. Kalau ModuleScript "N3V4_UISettings"
-- ada di ReplicatedStorage, dia di-require di sini dan nambah tab setting
-- sendiri ("UI Settings" + "Wallpaper & Surface"). Kalau nggak ada, ya nggak
-- muncul — preview tetep jalan normal.
pcall(function()
	local Mod = ReplicatedStorage:FindFirstChild("N3V4_UISettings")
	if Mod then
		local SettingsModule = require(Mod)
		if SettingsModule and SettingsModule.Attach then
			SettingsModule:Attach(Library, Window)
		end
	end
end)

--================================================================================
-- FINAL REPORT
--================================================================================
PrintReport()

SafeNotify({
	Title = "Preview v2 siap",
	Description = string.format("%d section OK · %d gagal · icon lucide offline-ready", #Report.OK, #Report.Failed),
	Icon = "circle-check",
	Time = 6,
})

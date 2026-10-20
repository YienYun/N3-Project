--[[
	================================================================================
	 N3V4 — PREVIEW KIT v4   (LocalScript)
	================================================================================

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
	Footer = "N3V4 • UI Preview Kit v4.4.2",
	Icon = "rbxassetid://117688744510818", -- N3 logo

	-- Asset buat demo Image / SpotlightCard / Feed / ValueImages
	ImageAsset = "rbxassetid://117688744510818",

	-- VideoFrame butuh asset ID punya lu. Kosong = section-nya nunjukin notice.
	VideoAsset = "",

	--// WALLPAPER \\--
	-- ID wallpaper lu, dipakai sebagai default pas window dibikin.
	-- Semua field ini sekarang beneran dibaca sama library (bukan cuma preview):
	-- Templates.Window.BackgroundImage* + BackgroundOverlay*
	-- RACIKAN USER — DISETUJUI 2026-10-20 ("nih brok ini bagus jir").
	-- Persis dari output Print resep Lua yang user paste balik.
	-- Ini sekarang DEFAULT permanen preview + kepasang di Games/N3-SAE.lua.
	Wallpaper = {
		Image = "111593326989465",
		Transparency = 0.70,
		ScaleType = "Stretch",
		Color = Color3.fromRGB(55, 55, 55),
		Layer = "front",
		Overlay = true,
		OverlayColor = Color3.fromRGB(46, 46, 46),
		OverlayTransparency = 0.90,
	},

	-- Kalau lu mau eksperimen lagi, member ScaleType asli:
	-- Stretch | Slice | Tile | Fit | Crop  ("Fill" cuma alias -> Crop)

	--// SURFACE \\--
	-- Default = wallpaper KELIATAN sebagai background kartu, tapi kartu group
	-- SOLID pakai warna ASLI theme (nggak diabu-abuin, nggak dipaksa).
	-- Semua angka & warna di bawah cuma titik awal — lu yang atur lewat
	-- slider + color picker di tab Wallpaper.
	Surface = {
		CanvasTransparency = 0.64,
		GroupTransparency = 0.11,
		GroupContrast = 11,
		GroupColor = Color3.fromRGB(0, 0, 0),
		CanvasColor = Color3.fromRGB(0, 0, 0),
	},

	-- false = mulai tanpa wallpaper (buat bandingin sebelum/sesudah)
	ApplyWallpaperOnStart = true,

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

-- Wallpaper di-pass langsung ke CreateWindow (field-nya sekarang ada di
-- Templates.Window, jadi ke-validate & ke-apply otomatis)
if CONFIG.ApplyWallpaperOnStart then
	local W = CONFIG.Wallpaper
	WindowInfo.BackgroundImage = W.Image
	WindowInfo.BackgroundImageTransparency = W.Transparency
	WindowInfo.BackgroundImageScaleType = W.ScaleType
	WindowInfo.BackgroundImageColor = W.Color
	WindowInfo.BackgroundImageLayer = W.Layer
	WindowInfo.BackgroundOverlayEnabled = W.Overlay
	WindowInfo.BackgroundOverlayColor = W.OverlayColor
	WindowInfo.BackgroundOverlayTransparency = W.OverlayTransparency
end

-- Surface: tanpa ini wallpaper mode "back" ketutup Container yang solid
if CONFIG.ApplyWallpaperOnStart then
	local S = CONFIG.Surface
	WindowInfo.ContentTransparency = S.CanvasTransparency
	WindowInfo.GroupTransparency = S.GroupTransparency
	WindowInfo.GroupContrast = S.GroupContrast
end

local Window = Library:CreateWindow(WindowInfo)

-- Override warna surface (nil = di-skip sama SetSurface, jadi aman)
Library:SetSurface({
	GroupColor = CONFIG.Surface.GroupColor,
	CanvasColor = CONFIG.Surface.CanvasColor,
})

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
-- TAB 6 — THEME LAB   (3 kiri / 3 kanan — simetris)
--================================================================================
local ThemeTab = Window:AddTab("Theme Lab", "palette", "Ganti warna, radius, font, animasi realtime")

Try("Theme: L1 Scheme colors", function()
	local Box = ThemeTab:AddLeftGroupbox("Scheme Colors", "droplets")

	local function ApplyColor(Key, Color)
		Library.Scheme[Key] = Color
		Library:UpdateColorsUsingRegistry()
	end

	local Pickers = {
		{ Key = "AccentColor", Label = "Accent color", Idx = "CP_Accent" },
		{ Key = "BackgroundColor", Label = "Background color", Idx = "CP_BG" },
		{ Key = "MainColor", Label = "Main color", Idx = "CP_Main" },
		{ Key = "OutlineColor", Label = "Outline color", Idx = "CP_Outline" },
		{ Key = "FontColor", Label = "Font color", Idx = "CP_Font" },
	}

	for _, Spec in ipairs(Pickers) do
		local T = Box:AddToggle("Theme_" .. Spec.Idx, { Text = Spec.Label, Default = true })
		if T and T.AddColorPicker then
			T:AddColorPicker(Spec.Idx, {
				Title = Spec.Key,
				Default = Library.Scheme[Spec.Key] or Color3.fromRGB(255, 255, 255),
				Callback = function(Color) ApplyColor(Spec.Key, Color) end,
			})
		end
	end
end)

Try("Theme: L2 Presets", function()
	local Box = ThemeTab:AddLeftGroupbox("Theme Presets", "palette")

	Box:AddButton("Default Obsidian", function()
		Library.IsLightTheme = false
		Library.Scheme.AccentColor = Color3.fromRGB(218, 98, 255)
		Library.Scheme.BackgroundColor = Color3.fromRGB(30, 30, 30)
		Library.Scheme.MainColor = Color3.fromRGB(40, 40, 40)
		Library.Scheme.OutlineColor = Color3.fromRGB(50, 50, 50)
		Library.Scheme.FontColor = Color3.fromRGB(238, 238, 238)
		Library:UpdateColorsUsingRegistry()
	end)

	Box:AddButton("Midnight Cyan", function()
		Library.IsLightTheme = false
		Library.Scheme.AccentColor = Color3.fromRGB(90, 220, 255)
		Library.Scheme.BackgroundColor = Color3.fromRGB(14, 17, 23)
		Library.Scheme.MainColor = Color3.fromRGB(22, 26, 34)
		Library.Scheme.OutlineColor = Color3.fromRGB(38, 45, 58)
		Library.Scheme.FontColor = Color3.fromRGB(232, 240, 248)
		Library:UpdateColorsUsingRegistry()
	end)

	Box:AddButton("Light Mode", function()
		Library.IsLightTheme = true
		Library.Scheme.AccentColor = Color3.fromRGB(124, 58, 237)
		Library.Scheme.BackgroundColor = Color3.fromRGB(244, 244, 247)
		Library.Scheme.MainColor = Color3.fromRGB(255, 255, 255)
		Library.Scheme.OutlineColor = Color3.fromRGB(214, 214, 222)
		Library.Scheme.FontColor = Color3.fromRGB(28, 28, 34)
		Library:UpdateColorsUsingRegistry()
	end)

	Box:AddButton("N3 Purple (brand)", function()
		Library.IsLightTheme = false
		Library.Scheme.AccentColor = Color3.fromRGB(218, 98, 255)
		Library.Scheme.BackgroundColor = Color3.fromRGB(20, 16, 26)
		Library.Scheme.MainColor = Color3.fromRGB(32, 26, 42)
		Library.Scheme.OutlineColor = Color3.fromRGB(58, 46, 76)
		Library.Scheme.FontColor = Color3.fromRGB(240, 234, 248)
		Library:UpdateColorsUsingRegistry()
	end)
end)

Try("Theme: L3 Geometry & scale", function()
	local Box = ThemeTab:AddLeftGroupbox("Geometry & Scale", "ruler")

	Box:AddSlider("Theme_Radius", {
		Text = "Corner radius (default 4)",
		Default = Library.CornerRadius or 4, Min = 0, Max = 20, Rounding = 0, Suffix = "px",
		Callback = function(Value) if Window.SetCornerRadius then Window:SetCornerRadius(Value) end end,
	})
	Box:AddSlider("Theme_DPI", {
		Text = "DPI scale",
		Default = math.floor((Library.DPIScale or 1) * 100), Min = 70, Max = 140, Rounding = 0, Suffix = "%",
		Callback = function(Value) Library:SetDPIScale(Value) end,
	})
	Box:AddSlider("Theme_Sidebar", {
		Text = "Sidebar width", Default = 128, Min = 50, Max = 260, Rounding = 0, Suffix = "px",
		Callback = function(Value) if Window.SetSidebarWidth then Window:SetSidebarWidth(Value) end end,
	})
	Box:AddToggle("Theme_Compact", {
		Text = "Compact sidebar (icon only)", Default = false,
		Callback = function(Value) if Window.SetCompact then Window:SetCompact(Value) end end,
	})
end)

Try("Theme: R1 Font", function()
	local Box = ThemeTab:AddRightGroupbox("Font", "type")

	Box:AddDropdown("Theme_Font", {
		Text = "Font face",
		Values = { "Code", "Gotham", "GothamMedium", "GothamBold", "BuilderSans", "Montserrat", "Ubuntu", "Jura", "SourceSans" },
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

	Box:AddButton("Reset ke Code", function()
		Library:SetFont(Enum.Font.Code)
	end)

	Box:AddDivider({ Text = "Wallpaper", Margin = 4 })
	Box:AddLabel("Kontrol background image pindah ke tab WALLPAPER.", true)
	Box:AddLabel("Di sana ada: ID, transparency, tint, scaletype, layer, overlay.", true)
end)

Try("Theme: R2 Animations", function()
	local Box = ThemeTab:AddRightGroupbox("Animations", "wind")

	local AnimState = {
		ToggleWindow = true, TabSwitch = true, Groupbox = true, Dropdown = true, KeyPicker = true,
	}

	for _, Spec in ipairs({
		{ Key = "ToggleWindow", Label = "Toggle window" },
		{ Key = "TabSwitch", Label = "Tab switch" },
		{ Key = "Groupbox", Label = "Groupbox" },
		{ Key = "Dropdown", Label = "Dropdown" },
		{ Key = "KeyPicker", Label = "KeyPicker" },
	}) do
		Box:AddToggle("Anim_" .. Spec.Key, {
			Text = Spec.Label, Default = true,
			Callback = function(Value)
				AnimState[Spec.Key] = Value
				Window:SetAnimations(AnimState)
			end,
		})
	end

	Box:AddDivider({ Text = "Timing", Margin = 4 })

	Box:AddSlider("Anim_TabTime", {
		Text = "Tab transition", Default = 22, Min = 0, Max = 100, Rounding = 0, Suffix = " ms",
		Callback = function(Value) Window:SetAnimations(nil, Value / 100) end,
	})
	Box:AddDropdown("Anim_SwipeFrom", {
		Text = "Swipe direction", Values = { "bottom", "top", "left", "right" }, Default = 1,
		Callback = function(Value) Window:SetAnimations(nil, nil, nil, Value) end,
	})
	Box:AddSlider("Anim_SwipeOffset", {
		Text = "Swipe offset", Default = 26, Min = 1, Max = 120, Rounding = 0, Suffix = "px",
		Callback = function(Value) Window:SetAnimations(nil, nil, Value) end,
	})
end)

Try("Theme: R3 Window controls", function()
	local Box = ThemeTab:AddRightGroupbox("Window Controls", "settings-2")

	Box:AddDropdown("Theme_NotifySide", {
		Text = "Notification side", Values = { "Right", "Left" }, Default = 1,
		Callback = function(Value) Library:SetNotifySide(Value) end,
	})
	Box:AddInput("Theme_Title", {
		Text = "Window title", Default = CONFIG.Title, Finished = true,
		Callback = function(Value) if Window.ChangeTitle then Window:ChangeTitle(Value) end end,
	})
	Box:AddInput("Theme_Footer", {
		Text = "Window footer", Default = CONFIG.Footer, Finished = true,
		Callback = function(Value) if Window.SetFooter then Window:SetFooter(Value) end end,
	})

	Box:AddDivider({ Text = "Utility", Margin = 4 })

	Box:AddButton("Print laporan ke Output", function() PrintReport() end)
	Box:AddButton("Toggle UI (atau RightCtrl)", function()
		if Window.Toggle then
			Window:Toggle()
		elseif typeof(Library.Toggle) == "function" then
			Library.Toggle()
		end
	end)
	Box:AddButton({
		Text = "Unload library", Risky = true, DoubleClick = true,
		Func = function()
			PrintReport()
			Library:Unload()
		end,
	})
end)

--================================================================================
-- TAB 7 — WALLPAPER   (3 kiri / 3 kanan — simetris)
--================================================================================
local WallpaperTab = Window:AddTab("Wallpaper", "image", "Background image, overlay, tint, layering")

-- State wallpaper sekarang (dipakai bareng sama semua kontrol di bawah)
local WP = {
	Image = CONFIG.Wallpaper.Image,
	Transparency = CONFIG.Wallpaper.Transparency,
	ScaleType = CONFIG.Wallpaper.ScaleType,
	Color = CONFIG.Wallpaper.Color,
	Layer = CONFIG.Wallpaper.Layer,
	Overlay = CONFIG.Wallpaper.Overlay,
	OverlayColor = CONFIG.Wallpaper.OverlayColor,
	OverlayTransparency = CONFIG.Wallpaper.OverlayTransparency,

	-- Surface: latar konten & kartu group (terpisah dari wallpaper)
	CanvasTransparency = CONFIG.Surface.CanvasTransparency,
	GroupTransparency = CONFIG.Surface.GroupTransparency,
	GroupContrast = CONFIG.Surface.GroupContrast,
	-- nil/false = ikut theme. Color3 = override manual dari color picker
	GroupColor = CONFIG.Surface.GroupColor,
	CanvasColor = CONFIG.Surface.CanvasColor,
}

-- Satu jalur apply: selalu lewat Library:SetWallpaper (API library, bukan hack preview)
local function ApplyWallpaper()
	local Success, Err = Library:SetWallpaper({
		Image = WP.Image,
		Transparency = WP.Transparency,
		ScaleType = WP.ScaleType,
		Color = WP.Color,
		Layer = WP.Layer,
		Overlay = WP.Overlay,
		OverlayColor = WP.OverlayColor,
		OverlayTransparency = WP.OverlayTransparency,
	})
	if not Success and CONFIG.VerboseErrors then
		warn("[N3V4 Preview] SetWallpaper gagal: " .. tostring(Err))
	end

	-- Surface di-apply bareng biar wallpaper & kartu group selalu sinkron
	Library:SetSurface({
		CanvasTransparency = WP.CanvasTransparency,
		GroupTransparency = WP.GroupTransparency,
		GroupContrast = WP.GroupContrast,
		GroupColor = WP.GroupColor,
		CanvasColor = WP.CanvasColor,
	})

	return Success
end

Try("Wallpaper: L1 Image source", function()
	local Box = WallpaperTab:AddLeftGroupbox("Wallpaper", "image")

	Box:AddInput("WP_Id", {
		Text = "Asset ID wallpaper (paste di sini)",
		Default = tostring(WP.Image),
		Placeholder = "111593326989465  atau  rbxassetid://...",
		Finished = true,
		Callback = function(Value)
			WP.Image = (Value == "" or Value == nil) and "" or Value
			ApplyWallpaper()
		end,
	})

	Box:AddButton("Apply wallpaper gue", function()
		WP.Image = CONFIG.Wallpaper.Image
		ApplyWallpaper()
		SafeNotify({ Title = "Wallpaper", Description = "ID: " .. tostring(WP.Image), Icon = "image", Time = 3 })
	end)

	Box:AddButton("Clear wallpaper", function()
		WP.Image = ""
		ApplyWallpaper()
	end)

	Box:AddSlider("WP_Transparency", {
		Text = "Image transparency",
		Default = math.floor(WP.Transparency * 100),
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "0% = gambar penuh · 100% = ilang total",
		Callback = function(Value)
			WP.Transparency = Value / 100
			ApplyWallpaper()
		end,
	})

end)

Try("Wallpaper: L2 Overlay (scrim)", function()
	local Box = WallpaperTab:AddLeftGroupbox("Overlay / Scrim", "square-check")

	Box:AddLabel("Overlay = lapisan warna di atas wallpaper.", true)
	Box:AddLabel("Gunanya biar teks tetep kebaca waktu", true)
	Box:AddLabel("wallpaper lu terang/rame.", true)
	Box:AddLabel("Toggle ON/OFF + warna-nya ada di box WARNA.", true)

	Box:AddSlider("WP_OverlayTransparency", {
		Text = "Overlay transparency",
		Default = math.floor(WP.OverlayTransparency * 100),
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "0% = overlay nutupin penuh\n100% = overlay ilang",
		Callback = function(Value)
			WP.OverlayTransparency = Value / 100
			ApplyWallpaper()
		end,
	})

	Box:AddButton("Overlay: reset hitam 45%", function()
		WP.OverlayColor = Color3.fromRGB(0, 0, 0)
		WP.OverlayTransparency = 0.45
		ApplyWallpaper()
	end)
end)

Try("Wallpaper: L3 Rendering", function()
	local Box = WallpaperTab:AddLeftGroupbox("Rendering", "ruler")

	Box:AddDropdown("WP_ScaleType", {
		Text = "ScaleType",
		Values = SCALE_TYPE_NAMES,
		Default = (function()
			for i, v in ipairs(SCALE_TYPE_NAMES) do
				if v == WP.ScaleType then
					return i
				end
			end
			return 1
		end)(),
		Tooltip = "Crop = kayak CSS background-size: cover (nutupin penuh, ratio dijaga) — paling umum buat wallpaper\nFit = muat semua tapi bisa ada sisi kosong\nStretch = dipaksa nutupin, bisa gepeng\nSlice = 9-slice (buat gambar ber-frame)\nTile = diulang sesuai TileSize",
		Callback = function(Value)
			WP.ScaleType = Value
			ApplyWallpaper()
		end,
	})

	Box:AddDropdown("WP_Layer", {
		Text = "Layer mode",
		Values = { "back", "front" },
		Default = WP.Layer == "front" and 2 or 1,
		Tooltip = "back = wallpaper di belakang konten (ZIndex -2)\nfront = wash di atas konten (ZIndex 999, perilaku lama library)",
		Callback = function(Value)
			WP.Layer = Value
			ApplyWallpaper()
		end,
	})

	Box:AddDivider({ Text = "ZIndex yang dipakai", Margin = 4 })
	Box:AddLabel("back  -> image -2, overlay -1, konten 1+", false)
	Box:AddLabel("front -> image 999, overlay 998", false)
	Box:AddLabel("Background MainFrame selalu di belakang semua child,", true)
	Box:AddLabel("jadi ZIndex negatif tetep keliatan.", true)
end)

Try("Wallpaper: R1 Presets", function()
	local Box = WallpaperTab:AddRightGroupbox("Presets", "wand-sparkles")

	local function LoadPreset(Name, P)
		WP.Image = P.Image
		WP.Transparency = P.Transparency
		WP.ScaleType = P.ScaleType
		WP.Color = P.Color or Color3.fromRGB(255, 255, 255)
		WP.Layer = P.Layer or "back"
		WP.Overlay = P.Overlay
		WP.OverlayColor = P.OverlayColor or Color3.fromRGB(0, 0, 0)
		WP.OverlayTransparency = P.OverlayTransparency
		WP.CanvasTransparency = P.Canvas ~= nil and P.Canvas or CONFIG.Surface.CanvasTransparency
		WP.GroupTransparency = P.Group ~= nil and P.Group or CONFIG.Surface.GroupTransparency
		WP.GroupContrast = P.Contrast ~= nil and P.Contrast or CONFIG.Surface.GroupContrast
		WP.GroupColor = P.GroupColor ~= nil and P.GroupColor or false
		WP.CanvasColor = P.CanvasColor ~= nil and P.CanvasColor or false
		ApplyWallpaper()
		SafeNotify({ Title = "Preset", Description = Name, Icon = "sparkles", Time = 2 })
	end

	Box:AddButton("RESEP USER (yang disetujui)", function()
		LoadPreset("Resep user", {
			Image = CONFIG.Wallpaper.Image, Transparency = 0.70, ScaleType = "Stretch",
			Color = Color3.fromRGB(55, 55, 55), Layer = "front",
			Overlay = true, OverlayColor = Color3.fromRGB(46, 46, 46), OverlayTransparency = 0.90,
			Canvas = 0.64, Group = 0.11, Contrast = 11,
			GroupColor = Color3.fromRGB(0, 0, 0), CanvasColor = Color3.fromRGB(0, 0, 0),
		})
	end)

	Box:AddButton("Subtle ( wallpaper tipis )", function()
		LoadPreset("Subtle", {
			Image = CONFIG.Wallpaper.Image, Transparency = 0.72, ScaleType = "Crop",
			Layer = "back", Overlay = true, OverlayTransparency = 0.30,
			Canvas = 1, Group = 0, Contrast = 0,
		})
	end)

	Box:AddButton("Bold (wallpaper kuat)", function()
		LoadPreset("Bold", {
			Image = CONFIG.Wallpaper.Image, Transparency = 0.10, ScaleType = "Crop",
			Layer = "back", Overlay = true, OverlayTransparency = 0.60,
			Canvas = 1, Group = 0, Contrast = 0,
		})
	end)

	Box:AddButton("Wash (layer front)", function()
		LoadPreset("Wash", {
			Image = CONFIG.Wallpaper.Image, Transparency = 0.82, ScaleType = "Stretch",
			Layer = "front", Overlay = false, OverlayTransparency = 0.5,
			Canvas = 0, Group = 0, Contrast = 10,
		})
	end)

	Box:AddButton("Accent tint (ungu N3)", function()
		LoadPreset("Accent tint", {
			Image = CONFIG.Wallpaper.Image, Transparency = 0.45, ScaleType = "Crop",
			Color = Color3.fromRGB(218, 98, 255), Layer = "back",
			Overlay = true, OverlayColor = Color3.fromRGB(20, 8, 30), OverlayTransparency = 0.40,
			Canvas = 1, Group = 0, Contrast = 0,
		})
	end)

	Box:AddButton("Kartu nongol (contrast 15)", function()
		LoadPreset("Kartu nongol", {
			Image = CONFIG.Wallpaper.Image, Transparency = 0.35, ScaleType = "Crop",
			Layer = "back", Overlay = true, OverlayTransparency = 0.45,
			Canvas = 1, Group = 0, Contrast = 15,
		})
	end)

	Box:AddButton("Matiin semua (balik normal)", function()
		LoadPreset("Off + normal", {
			Image = "", Transparency = 0.75, ScaleType = "Crop",
			Layer = "back", Overlay = false, OverlayTransparency = 0.5,
			Canvas = 0, Group = 0, Contrast = 0,
		})
	end)
end)

Try("Wallpaper: R2 Live info", function()
	local Box = WallpaperTab:AddRightGroupbox("Live Info", "info")

	local Labels = {}
	local Fields = {
		{ "Image", function(I) return tostring(I.Image) end },
		{ "Visible", function(I) return tostring(I.Visible) end },
		{ "Transparency", function(I) return string.format("%.2f", I.Transparency) end },
		{ "ScaleType", function(I) return tostring(I.ScaleType) end },
		{ "Layer", function(I) return tostring(I.Layer) end },
		{ "ZIndex", function(I) return tostring(I.ZIndex) end },
		{ "Overlay", function(I) return tostring(I.OverlayEnabled) end },
		{ "OverlayTransp", function(I) return string.format("%.2f", I.OverlayTransparency) end },
	}

	for _, Spec in ipairs(Fields) do
		Labels[Spec[1]] = Box:AddLabel(string.format("%s: -", Spec[1]), false)
	end

	Labels["WARN"] = Box:AddLabel("status: -", true)

	local function Refresh()
		if typeof(Window.GetWallpaperInfo) ~= "function" then
			return
		end
		local Info = Window:GetWallpaperInfo()
		for _, Spec in ipairs(Fields) do
			local L = Labels[Spec[1]]
			if L and L.SetText then
				L:SetText(string.format("%s: %s", Spec[1], Spec[2](Info)))
			end
		end

		local Warn = Labels["WARN"]
		if Warn and Warn.SetText then
			if Info.Visible == false and tostring(Info.Image) ~= "" then
				Warn:SetText("⚠ IMAGE GAGAL LOAD — yang nembus itu GAME-nya, bukan wallpaper lu. Cek ID / permission asset.")
			elseif tostring(Info.Image) == "" then
				Warn:SetText("Wallpaper kosong (belum di-set).")
			else
				Warn:SetText("OK — wallpaper ke-load.")
			end
		end
	end

	Box:AddDivider({ Text = "Snapshot dari library", Margin = 4 })
	Box:AddButton("Refresh info", Refresh)
	Box:AddButton("Print ke Output", function()
		if typeof(Window.GetWallpaperInfo) == "function" then
			print("[N3V4 Wallpaper] ", Window:GetWallpaperInfo())
		end
	end)

	Refresh()
end)

Try("Wallpaper: R3 Catatan", function()
	local Box = WallpaperTab:AddRightGroupbox("Catatan", "book-open")

	Box:AddLabel("Semua kontrol di tab ini manggil API LIBRARY", true)
	Box:AddLabel("(Library:SetWallpaper / Window:SetBackground*),", true)
	Box:AddLabel("bukan hack di sisi preview. Jadi hasil yang lu lihat", true)
	Box:AddLabel("di sini = hasil yang bakal hub lu dapet.", true)

	Box:AddDivider({ Text = "Layer mode", Margin = 4 })
	Box:AddLabel("back  : wallpaper di belakang konten. Keliatan di", true)
	Box:AddLabel("        area padding & elemen yang transparan.", true)
	Box:AddLabel("front : wash di atas semua konten (ZIndex 999).", true)
	Box:AddLabel("        Lebih keliatan, tapi nutupin teks sedikit.", true)

	Box:AddDivider({ Text = "Kenapa dulu 'back' nggak keliatan?", Margin = 4 })
	Box:AddLabel("Container (area konten) dulu SOLID nutupin", true)
	Box:AddLabel("wallpaper. Sekarang ada Canvas transparency", true)
	Box:AddLabel("di groupbox 'Canvas & Kartu Group' -> set 100%.", true)

	Box:AddDivider({ Text = "Kenapa 'front' bikin komponen tembus?", Margin = 4 })
	Box:AddLabel("front = wallpaper digambar DI ATAS semua", true)
	Box:AddLabel("komponen (ZIndex 999). Kalau mau wallpaper", true)
	Box:AddLabel("jadi background kartu, pakai 'back' + canvas 100%.", true)

	Box:AddDivider({ Text = "Kalau yang keliatan langit / game?", Margin = 4 })
	Box:AddLabel("Berarti asset ID wallpaper lu GAGAL load", true)
	Box:AddLabel("(private / salah ID). Yang nembus itu GAME-nya,", true)
	Box:AddLabel("bukan wallpaper. Cek groupbox 'Live Info':", true)
	Box:AddLabel("baris status harus 'OK — wallpaper ke-load'.", true)

	Box:AddDivider({ Text = "Format ID yang diterima", Margin = 4 })
	Box:AddLabel("111593326989465          (angka polos)", false)
	Box:AddLabel("rbxassetid://111593...   (prefix)", false)
	Box:AddLabel("https://...  (URL, di-download)", false)
end)

Try("Wallpaper: L4 Canvas & kartu group", function()
	local Box = WallpaperTab:AddLeftGroupbox("Canvas & Kartu Group", "layers")

	Box:AddLabel("ATURAN LAYER (baca dulu biar nggak bingung):", true)
	Box:AddLabel("1. Wallpaper ada DI BELAKANG canvas (area konten).", true)
	Box:AddLabel("2. Canvas solid = wallpaper ketutup -> naikin Canvas", true)
	Box:AddLabel("   transparency biar wallpaper keliatan.", true)
	Box:AddLabel("3. Group transparency cuma KELIATAN kalau canvas-nya", true)
	Box:AddLabel("   transparan. Kalau canvas solid, kartu transparan cuma", true)
	Box:AddLabel("   nunjukin warna canvas -> keliatannya \"ga ngaruh\".", true)

	Box:AddDivider({ Text = "Latar / canvas", Margin = 4 })
	Box:AddSlider("WP_Canvas", {
		Text = "Canvas transparency",
		Default = math.floor(WP.CanvasTransparency * 100),
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "Area konten + sidebar.\n100% = wallpaper keliatan sebagai background kartu\n0% = solid (wallpaper ketutup)",
		Callback = function(Value)
			WP.CanvasTransparency = Value / 100
			ApplyWallpaper()
		end,
	})

	Box:AddDivider({ Text = "Kartu group", Margin = 4 })
	Box:AddSlider("WP_GroupTransparency", {
		Text = "Group transparency",
		Default = math.floor(WP.GroupTransparency * 100),
		Min = 0,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "Kartu groupbox/tabbox/depbox.\n0% = SOLID: button/dropdown/slider/text nggak tembus\nIngat: efeknya cuma keliatan kalau canvas transparan",
		Callback = function(Value)
			WP.GroupTransparency = Value / 100
			ApplyWallpaper()
		end,
	})

	Box:AddSlider("WP_GroupContrast", {
		Text = "Group contrast (auto)",
		Default = math.floor(WP.GroupContrast),
		Min = 0,
		Max = 40,
		Rounding = 0,
		Suffix = "%",
		Tooltip = "Dipakai cuma kalau warna group = ikut theme.\n10% = kartu ~10% lebih terang (dark theme)\n0% = warna asli theme persis",
		Callback = function(Value)
			WP.GroupContrast = Value
			ApplyWallpaper()
		end,
	})

	Box:AddDivider({ Text = "Cepat", Margin = 4 })
	Box:AddButton("BALIKIN NORMAL (semula)", function()
		WP.CanvasTransparency = 0
		WP.GroupTransparency = 0
		WP.GroupContrast = 0
		WP.GroupColor = false
		WP.CanvasColor = false
		ApplyWallpaper()
		SafeNotify({ Title = "Surface", Description = "Semua balik ke tampilan semula.", Icon = "rotate-3d", Time = 3 })
	end)

	Box:AddButton("Resep: wallpaper keliatan", function()
		WP.CanvasTransparency = 1
		WP.GroupTransparency = 0
		WP.GroupContrast = 0
		WP.GroupColor = false
		WP.CanvasColor = false
		ApplyWallpaper()
		SafeNotify({ Title = "Surface", Description = "Wallpaper jadi background, kartu solid warna asli.", Icon = "image", Time = 4 })
	end)
end)

Try("Wallpaper: L5 Warna custom", function()
	-- PENTING: di library ini AddColorPicker HARUS nempel ke object yang punya
	-- .TextLabel (Toggle/Button). Nempel ke groupbox = TextLabel nil = crash
	-- runtime & picker-nya nggak ke-render. Makanya tiap warna punya toggle.
	local Box = WallpaperTab:AddLeftGroupbox("WARNA — custom lengkap", "palette")

	Box:AddLabel("Tiap warna nempel di toggle-nya.", true)
	Box:AddLabel("Toggle OFF = ikut bawaan / theme.", true)
	Box:AddLabel("Toggle ON  = pakai warna pilihan lu.", true)
	Box:AddLabel("Klik KOTAK WARNA di kanan baris buat milih.", true)

	Box:AddDivider({ Text = "1 · Tint wallpaper", Margin = 4 })
	local LastTint = WP.Color
	local TintTog = Box:AddToggle("WP_TintToggle", {
		Text = "Tint aktif",
		Default = WP.Color ~= Color3.fromRGB(255, 255, 255),
		Callback = function(On)
			WP.Color = On and LastTint or Color3.fromRGB(255, 255, 255)
			ApplyWallpaper()
		end,
	})
	TintTog:AddColorPicker("WP_Tint", {
		Title = "Tint wallpaper",
		Default = WP.Color,
		Tooltip = "Putih = warna asli gambar.\nWarna lain = gambar di-tint.",
		Callback = function(Color)
			LastTint = Color
			if TintTog.Value then
				WP.Color = Color
				ApplyWallpaper()
			end
		end,
	})
	Box:AddButton("Tint: matiin + reset putih", function()
		LastTint = Color3.fromRGB(255, 255, 255)
		TintTog:SetValue(false)
		WP.Color = LastTint
		ApplyWallpaper()
	end)

	Box:AddDivider({ Text = "2 · Overlay / scrim", Margin = 4 })
	local OvTog = Box:AddToggle("WP_OverlayToggle", {
		Text = "Overlay aktif",
		Default = WP.Overlay,
		Callback = function(On)
			WP.Overlay = On
			ApplyWallpaper()
		end,
	})
	OvTog:AddColorPicker("WP_OverlayColor", {
		Title = "Warna overlay",
		Default = WP.OverlayColor,
		Tooltip = "Hitam = scrim gelap (teks kebaca).\nWarna lain = tint suasana.",
		Callback = function(Color)
			WP.OverlayColor = Color
			ApplyWallpaper()
		end,
	})

	Box:AddDivider({ Text = "3 · Warna canvas", Margin = 4 })
	local LastCanvas = WP.CanvasColor or Color3.fromRGB(32, 32, 32)
	local CanTog = Box:AddToggle("WP_CanvasToggle", {
		Text = "Canvas warna custom",
		Default = typeof(WP.CanvasColor) == "Color3",
		Callback = function(On)
			WP.CanvasColor = On and LastCanvas or false
			ApplyWallpaper()
		end,
	})
	CanTog:AddColorPicker("WP_CanvasColor", {
		Title = "Warna canvas",
		Default = LastCanvas,
		Tooltip = "Warna latar konten + sidebar\n(keliatan waktu wallpaper mati/transparan).",
		Callback = function(Color)
			LastCanvas = Color
			if CanTog.Value then
				WP.CanvasColor = Color
				ApplyWallpaper()
			end
		end,
	})
	Box:AddButton("Canvas: ikut theme lagi", function()
		CanTog:SetValue(false)
		WP.CanvasColor = false
		ApplyWallpaper()
	end)

	Box:AddDivider({ Text = "4 · Warna kartu group", Margin = 4 })
	local LastGroup = WP.GroupColor or Color3.fromRGB(30, 30, 30)
	local GrpTog = Box:AddToggle("WP_GroupToggle", {
		Text = "Group warna custom",
		Default = typeof(WP.GroupColor) == "Color3",
		Callback = function(On)
			WP.GroupColor = On and LastGroup or false
			ApplyWallpaper()
		end,
	})
	GrpTog:AddColorPicker("WP_GroupColor", {
		Title = "Warna kartu group",
		Default = LastGroup,
		Tooltip = "Warna kartu groupbox / tabbox / depbox.\nON = contrast slider di-ignore.",
		Callback = function(Color)
			LastGroup = Color
			if GrpTog.Value then
				WP.GroupColor = Color
				ApplyWallpaper()
			end
		end,
	})
	Box:AddButton("Group: ikut theme lagi", function()
		GrpTog:SetValue(false)
		WP.GroupColor = false
		WP.GroupContrast = 0
		ApplyWallpaper()
	end)

	Box:AddDivider({ Text = "Sapu jagat", Margin = 4 })
	Box:AddButton("SEMUA WARNA: balik bawaan", function()
		LastTint = Color3.fromRGB(255, 255, 255)
		LastCanvas = Color3.fromRGB(32, 32, 32)
		LastGroup = Color3.fromRGB(30, 30, 30)
		WP.OverlayColor = Color3.fromRGB(0, 0, 0)
		TintTog:SetValue(false)
		CanTog:SetValue(false)
		GrpTog:SetValue(false)
		WP.Color = LastTint
		WP.CanvasColor = false
		WP.GroupColor = false
		ApplyWallpaper()
		SafeNotify({ Title = "Warna", Description = "Semua warna balik bawaan.", Icon = "palette", Time = 3 })
	end)
end)

Try("Wallpaper: R4 Resep aktif", function()
	local Box = WallpaperTab:AddRightGroupbox("Resep Aktif", "copy")

	Box:AddLabel("Angka yang lagi aktif sekarang. Tombol di bawah", true)
	Box:AddLabel("nge-print resep Lua yang tinggal lu paste ke gue.", true)

	local function BuildResep()
		local C = WP.OverlayColor
		local T = WP.Color

		return table.concat({
			"Library:SetWallpaper({",
			string.format('\tImage = "%s",', tostring(WP.Image)),
			string.format("\tTransparency = %.2f,", WP.Transparency),
			string.format('\tScaleType = "%s",', tostring(WP.ScaleType)),
			string.format("\tColor = Color3.fromRGB(%d, %d, %d),", math.floor(T.R * 255 + 0.5), math.floor(T.G * 255 + 0.5), math.floor(T.B * 255 + 0.5)),
			string.format('\tLayer = "%s",', tostring(WP.Layer)),
			string.format("\tOverlay = %s,", tostring(WP.Overlay == true)),
			string.format("\tOverlayColor = Color3.fromRGB(%d, %d, %d),", math.floor(C.R * 255 + 0.5), math.floor(C.G * 255 + 0.5), math.floor(C.B * 255 + 0.5)),
			string.format("\tOverlayTransparency = %.2f,", WP.OverlayTransparency),
			"})",
			"Library:SetSurface({",
			string.format("\tCanvasTransparency = %.2f,", WP.CanvasTransparency),
			string.format("\tGroupTransparency = %.2f,", WP.GroupTransparency),
			string.format("\tGroupContrast = %d,", math.floor(WP.GroupContrast + 0.5)),
			(typeof(WP.GroupColor) == "Color3")
				and string.format("\tGroupColor = Color3.fromRGB(%d, %d, %d),", math.floor(WP.GroupColor.R * 255 + 0.5), math.floor(WP.GroupColor.G * 255 + 0.5), math.floor(WP.GroupColor.B * 255 + 0.5))
				or "\tGroupColor = false, -- ikut theme",
			(typeof(WP.CanvasColor) == "Color3")
				and string.format("\tCanvasColor = Color3.fromRGB(%d, %d, %d),", math.floor(WP.CanvasColor.R * 255 + 0.5), math.floor(WP.CanvasColor.G * 255 + 0.5), math.floor(WP.CanvasColor.B * 255 + 0.5))
				or "\tCanvasColor = false, -- ikut theme",
			"})",
		}, "\n")
	end

	local function ShowResep()
		local Resep = BuildResep()
		print("[N3V4 RESEP] paste ini balik ke gue:\n" .. Resep)

		if typeof(Window.GetWallpaperInfo) == "function" then
			print("[N3V4 Wallpaper] ", Window:GetWallpaperInfo())
		end

		SafeNotify({
			Title = "Resep di-print",
			Description = "Cek Output — copy & paste balik ke gue.",
			Icon = "copy",
			Time = 4,
		})
	end

	Box:AddDivider({ Text = "Kirim balik ke gue", Margin = 4 })
	Box:AddButton("Print resep Lua + info", ShowResep)
	Box:AddButton("Print info doang", function()
		if typeof(Window.GetWallpaperInfo) == "function" then
			print("[N3V4 Wallpaper] ", Window:GetWallpaperInfo())
		end
	end)

	Box:AddDivider({ Text = "Cara pakai di hub", Margin = 4 })
	Box:AddLabel("Dua panggilan di atas bisa lu taro persis", true)
	Box:AddLabel("habis CreateWindow() di hub lu. Nggak perlu", true)
	Box:AddLabel("ngubah apapun lagi — semua udah API library.", true)
end)

Try("Wallpaper: R5 Master", function()
	local Box = WallpaperTab:AddRightGroupbox("Master", "settings-2")

	Box:AddLabel("Tombol sapu jagat buat balik cepet", true)
	Box:AddLabel("kalau settingan lu kebablasan.", true)

	Box:AddButton("RESET SEMUA (semula total)", function()
		WP.Image = ""
		WP.Transparency = 0.75
		WP.ScaleType = "Crop"
		WP.Color = Color3.fromRGB(255, 255, 255)
		WP.Layer = "back"
		WP.Overlay = false
		WP.OverlayColor = Color3.fromRGB(0, 0, 0)
		WP.OverlayTransparency = 0.5
		WP.CanvasTransparency = 0
		WP.GroupTransparency = 0
		WP.GroupContrast = 0
		WP.GroupColor = false
		WP.CanvasColor = false
		ApplyWallpaper()
		SafeNotify({ Title = "Master", Description = "Semua balik ke semula total.", Icon = "rotate-3d", Time = 3 })
	end)

	Box:AddButton("Wallpaper OFF (surface tetep)", function()
		WP.Image = ""
		ApplyWallpaper()
	end)

	Box:AddButton("Wallpaper ON (ID gue + canvas)", function()
		WP.Image = CONFIG.Wallpaper.Image
		WP.CanvasTransparency = 1
		WP.Overlay = false
		ApplyWallpaper()
	end)

	Box:AddDivider({ Text = "Cek versi copy-an lu", Margin = 4 })
	Box:AddLabel("Footer window HARUS tertulis v4.4.2.", true)
	Box:AddLabel("Kalau masih v4 / v4.2 / v4.3 / v4.4 berarti", true)
	Box:AddLabel("LocalScript lu copy-an LAMA — copy ulang", true)
	Box:AddLabel("file Preview/N3V4_Preview.client.lua.", true)
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

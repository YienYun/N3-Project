--================================================================================
-- N3V4 — UI SETTINGS   (file setingan desain UI)
--================================================================================
-- SEMUA setingan desain ada DI SINI. Preview utama nggak punya setingan.
--
-- DUAL MODE — dua-duanya jalan:
--   A) Paste sebagai LOCALSCRIPT  (misal StarterPlayerScripts > "N3V4_UISettings")
--      -> dia nempel SENDIRI: nunggu library & window siap, terus nambah tab.
--   B) Paste sebagai MODULESCRIPT (ReplicatedStorage > "N3V4_UISettings")
--      -> preview auto-require, atau manual: Settings:Attach(Library, Window)
--
-- Default = RESEP USER v2 yang disetujui 2026-10-20 (yang lu seting sendiri
-- terus bilang "gas implementasikan ke code utama"). Sama persis kayak
-- default di LIBRARY, jadi buka Studio = langsung tampilan lu, tanpa seting.
--
-- v4.8.3: RESEP v7 + RESEP TAB v2 user DIBAKE (print 00:41-00:46):
--        main 36, outline 65-62-62, radius 10, tint 148, overlay 0.40,
--        group 0.5, canvas 119; tab: stroke 1.5/0.53 hitam, aktif 0.60
--        hitam, zoom 1.25/1.25. Semua lewat default = nol hardcode.
-- v4.7.8: durasi buka/tutup = 10% (0.10s) DIBAKE — user: "10% bagus!".
-- v4.7.7: animasi BUKA/TUTUP WINDOW dibenerin di library (fade barengan =
--        total waktu persis durasi, nol "layar hitam", tween di-cache =
--        nol hitch, reversal mulus). Knob baru ST_AnimTime (Font & Animasi)
--        + durasi ikut ke-print di RESEP THEMA.
-- v4.7.6: RESEP TAB user DIBAKE (print 18:21) + refactor nol-duplikasi:
--        halo+UIScale sekarang satu helper Library:CreateTabIconStroke,
--        zoom satu helper Library:TweenTabZoom (UIScale = mulus), blok
--        duplikat di AddTab/AddKeyTab dihapus -> file library mengecil.
-- v4.7.5: PATCH TAB MASUK KE FUNGSI YANG BENER (Window:AddTab). v4.7.0-7.4
--        salah masuk AddKeyTab -> rec=0 & zoom/stroke mati di tab sidebar.
--        DEBUG activeTab sekarang print boolean bener.
-- v4.7.4: TEST ikut nyalain toggle stroke/bg-aktif + TabHoverZoom; gate zoom
--        nil-safe di library; CreateWindow auto-apply + print tabVisuals.
-- v4.7.3: FIX BUG BESAR: local TabRec kedelep di dalam do-block library ->
--        AddTab error tiap tab = semua efek tab (stroke/bg/zoom) MATI diam-diam
--        walau library baru. Sekarang scope bener + stroke pakai halo ImageLabel
--        (bukan UIStroke) + zoom pakai tween Size (bukan UIScale) = nol quirk.
--        + tombol DEBUG dump tab visuals buat ground truth.
-- v4.7.2: label slider transparency dijelasin ("100% = ILANG") + tombol TEST
--        efek keliatan. Library print versi sendiri di Output tiap require.
-- v4.7.1: stale-paste detector LIBRARY di Attach (warn kalau N3V4 lama).
-- v4.7.0: UPGRADE TAB sidebar (borongan): stroke glyph icon (UIStroke), bg
--        dikit di semua tab, bg accent tipis tab aktif, zoom hover + zoom
--        aktif (UIScale + tween). Knob lengkap di tab UI Settings (box baru
--        4/4 simetris). Print LENGKAP sekarang include RESEP TAB.
-- v4.6.11: nested box (tabbox/groupbox/depbox di dalam kartu) ikut transparan:
--         lapis double dihapus lewat Library:IsInsideSurfaceCard().
-- v4.6.10: PREVIEW OFF TOTAL (state wallpaper/surface GLOBAL -> preview
--         theme-only v4.6.9 nyetomp window user jadi 0/0 = jelek). Window
--         default 0.90 -> 1 ("window dan canvas harusnya 100").
-- v4.6.9: FIX bug STOMP: CreateWindow dulu seed Surface unconditional dari
--        Templates.Window -> resep group 0.35/contrast 40 ke-reset jadi 0/30
--        tiap paste baru ("group kok ga transparan padahal udah gue setting").
--        Sekarang seed cuma kalau caller eksplisit ngirim field-nya.
--        THEME v6: main 45 / outline 65 (print user). PREVIEW: wallpaper
--        DIMATIIN (showcase theme doang, perintah user).
-- v4.6.8: RESEP v5 USER DIBAKE (print LENGKAP 2026-10-20): wallpaper FULL
--        (transparency 0) + scrim 0.55, tint 195, window 0.90, canvas 1,
--        group 0.35 (pilihan user sendiri di layer back), contrast 40, kartu
--        hitam, canvas 156, scheme bg15/main36/outline59. PLUS FIX: corner
--        navbar bawah sekarang bottom-only (radius diutak-atik nggak bablas).
-- v4.6.7: SEMUA preset & combo sekarang layer "back" (preset "Wash (front)" &
--        combo "Stretch + front" = jebakan: front = veil nutup kartu -> kartu
--        kebaca transparan walau Group 0). Preset juga nggak lagi matiin
--        GroupColor/CanvasColor custom user. Front masih bisa via dropdown
--        Layer kalau emang mau (dengan konsekuensi kartu ke-veil).
-- v4.6.6: WALLPAPER LAYER "back" + window/canvas full transparan -> kartu group
--        100% SOLID ("ga transparan" kata user). Overlay scrim ON 0.50 biar teks
--        kebaca di atas wallpaper. User bakal seting persen-nya sendiri terus
--        kirim print balik -> bake lagi nanti.
-- v4.6.5: GROUP BALIK HITAM (revert AUTO abu-abu v4.6.4 — user: "gue group
--        warna hitam anj!"). Contrast 30 tetep disimpen sebagai baseline lu,
--        kepake kalau "Group custom" OFF.
-- v4.6.4: GROUP 30% LEBIH JELAS (user: "dulukan 10% sekarang coba bikin 30%").
--        GroupColor override hitam dihapus biar GroupContrast BENERAN
--        kepake; toggle "Group custom" mulai OFF (= auto).
-- v4.6.3: Reset scheme = theme v4 user (bg 18, main 33, outline 61).
--        NGGAK ada fitur baru — cuma ganti angka default, sesuai perintah.
-- v4.6.2: DEFAULTS = RESEP v3 user (theme hitam-ungu + radius 15 + wallpaper v3).
--        FIX BUG: state S dulu dibaca SETELAH BuildResep didefinisiin ->
--        S ke-resolve global nil -> "attempt to index nil with 'Image'".
--        State sekarang di-inisialisasi SEBELUM semua helper.
-- v4.6.1: DEFAULTS = RESEP v2 user (sama persis kayak default library).
-- v4.6: tombol PRINT/COPY RESEP THEMA (scheme colors + font + radius + DPI +
--       animasi) di tab "UI Settings", dan "Print resep LENGKAP" (thema +
--       wallpaper + surface) di kedua tab. Copy pakai setclipboard kalau ada.
--================================================================================

local Settings = {}

Settings.DEFAULTS = {
	Image = "111593326989465",
	Transparency = 0,
	ScaleType = "Stretch",
	Color = Color3.fromRGB(148, 148, 148), -- tint (dump user v7, 0.58)
	Layer = "back",
	Overlay = true,
	OverlayColor = Color3.fromRGB(0, 0, 0),
	OverlayTransparency = 0.40, -- v4.8.3: dump user v7

	Window = 1, -- transparency dasar window (v4.6.10: 100% kata user)
	Canvas = 1,
	Group = 0.5, -- v4.8.3: dump user v7
	Contrast = 40,
	Tab = { -- v4.8.3 = RESEP TAB USER v2 TERKUNCI (print 00:46)
		IconStrokeThickness = 1.5,
		IconStrokeTransparency = 0.53,
		IconStrokeColor = Color3.fromRGB(0, 0, 0),
		TabBackgroundTransparency = 1,
		ActiveBackgroundTransparency = 0.60,
		ActiveBackgroundColor = Color3.fromRGB(0, 0, 0),
		HoverZoom = 1.25,
		ActiveZoom = 1.25,
		ZoomTime = 0.20,
	},
	TabHoverZoom = true,
	AnimTime = 0.10, -- v4.7.8: RESEP USER TERKUNCI ("10% bagus!") = 0.10s buka/tutup window
	GroupColor = Color3.fromRGB(0, 0, 0), -- HITAM (user v4.6.5: balik hitam)
	CanvasColor = Color3.fromRGB(119, 119, 119), -- dump user v7 (0.465)
}

function Settings:Attach(Library, Window, Options)
	if shared.N3V4_UISettings_Attached then
		return false
	end
	shared.N3V4_UISettings_Attached = true

	-- v4.7.1: STALE-PASTE DETECTOR buat LIBRARY. Kalau ModuleScript N3V4 di
	-- ReplicatedStorage belum v4.7.0+, knob Tab (stroke/bg/zoom) manggil
	-- fungsi yang nggak ada -> slider gerak tapi NIR efek + error di Output.
	if type(Library.SetTabAppearance) ~= "function" or type(Library.TabAppearance) ~= "table" then
		warn("[N3V4 Settings] LIBRARY LAMA terdeteksi (SetTabAppearance/TabAppearance nil)! Paste ulang Library/N3V3-NoObfus.lua ke ModuleScript N3V4 di ReplicatedStorage, kalau nggak knob Tab Stroke/Bg/Zoom nggak akan ngaruh.")
	end

	Options = Options or {}
	local DEFAULTS = Settings.DEFAULTS

	local function Try(Label, Func)
		local OK, Err = pcall(Func)
		if not OK then
			warn("[N3V4 Settings] " .. Label .. ": " .. tostring(Err))
		end
		return OK
	end

	local function SafeNotify(Info)
		pcall(function()
			Library:Notify(Info)
		end)
	end

	local SCALE_TYPE_NAMES = { "Crop", "Fit", "Stretch", "Slice", "Tile" }
	local function ResolveScale(Value)
		if typeof(Value) == "EnumItem" then
			return Value
		end
		if typeof(Value) == "string" then
			for _, Item in Enum.ScaleType:GetEnumItems() do
				if Item.Name == Value then
					return Item
				end
			end
		end
		return Enum.ScaleType.Stretch
	end

	local function GetFontEnum(Name)
		local OK, Font = pcall(function()
			return Enum.Font[Name]
		end)
		return OK and Font or nil
	end

	--// state awal: baca yang lagi aktif, fallback ke DEFAULTS \\--
	local Info0 = nil
	pcall(function()
		if typeof(Window.GetWallpaperInfo) == "function" then
			Info0 = Window:GetWallpaperInfo()
		end
	end)

	local S = {
		Image = (Info0 and Info0.Image ~= "" and Info0.Image) or DEFAULTS.Image,
		Transparency = (Info0 and Info0.Transparency) or DEFAULTS.Transparency,
		ScaleType = (Info0 and Info0.ScaleTypeName) or DEFAULTS.ScaleType,
		Color = (Info0 and Info0.Color) or DEFAULTS.Color,
		Layer = (Info0 and Info0.Layer) or DEFAULTS.Layer,
		Overlay = (Info0 and Info0.OverlayEnabled ~= nil) and Info0.OverlayEnabled or DEFAULTS.Overlay,
		OverlayColor = (Info0 and Info0.OverlayColor) or DEFAULTS.OverlayColor,
		OverlayTransparency = (Info0 and Info0.OverlayTransparency) or DEFAULTS.OverlayTransparency,

		Window = (Info0 and Info0.WindowTransparency) or DEFAULTS.Window,
		Canvas = (Info0 and Info0.CanvasTransparency) or DEFAULTS.Canvas,
		Group = (Info0 and Info0.GroupTransparency) or DEFAULTS.Group,
		Contrast = (Info0 and Info0.GroupContrast) or DEFAULTS.Contrast,
		GroupColor = (Info0 and Info0.GroupColorOverride) or DEFAULTS.GroupColor,
		CanvasColor = (Info0 and Info0.CanvasColorOverride) or DEFAULTS.CanvasColor,
	}

	local LastTint = S.Color
	local LastCanvas = S.CanvasColor
	local LastGroup = (typeof(S.GroupColor) == "Color3") and S.GroupColor or Color3.fromRGB(0, 0, 0)

	--//========================================================================
	-- RESEP / PRINT  (dipakai dua tab: tema + wallpaper)
	--//========================================================================
	local function RGB(C)
		if typeof(C) ~= "Color3" then
			return "Color3.fromRGB(0, 0, 0)"
		end
		return string.format(
			"Color3.fromRGB(%d, %d, %d)",
			math.floor(C.R * 255 + 0.5),
			math.floor(C.G * 255 + 0.5),
			math.floor(C.B * 255 + 0.5)
		)
	end

	local function CopyClip(Text)
		if setclipboard then
			pcall(function()
				setclipboard(Text)
			end)
			return true
		end
		return false
	end

	-- Baca satu nilai dari library tanpa pernah error (API lama/baru aman).
	local function Pick(Obj, Keys, Fallback)
		if type(Obj) ~= "table" then
			return Fallback
		end
		for _, K in ipairs(Keys) do
			local OK, V = pcall(function()
				return Obj[K]
			end)
			if OK and V ~= nil then
				return V
			end
		end
		return Fallback
	end

	local SCHEME_KEYS = {
		{ "AccentColor", "AccentColor" },
		{ "BackgroundColor", "BackgroundColor" },
		{ "MainColor", "MainColor" },
		{ "OutlineColor", "OutlineColor" },
		{ "FontColor", "FontColor" },
	}

	local ANIM_KEYS = { "ToggleWindow", "TabSwitch", "Groupbox", "Dropdown", "KeyPicker" }

	-- Resep THEMA: scheme colors + font + radius + DPI + animasi.
	-- Ini yang diminta user: "kasih print juga di theme".
	local function BuildTema()
		local lines = { "--[[ N3V4 RESEP THEMA — paste balik ke script lu ]]" }

		for _, Pair in ipairs(SCHEME_KEYS) do
			local Key = Pair[1]
			local Color = Library.Scheme and Library.Scheme[Key]
			if typeof(Color) == "Color3" then
				table.insert(lines, string.format("Library.Scheme.%s = %s", Key, RGB(Color)))
			end
		end
		table.insert(lines, "Library:UpdateColorsUsingRegistry()")

		local Font = Pick(Library.Scheme, { "Font" }, nil)
		local FontName = nil
		pcall(function()
			FontName = Font and Font.Name
		end)
		if type(FontName) == "string" and FontName ~= "" then
			table.insert(lines, string.format("Library:SetFont(Enum.Font.%s)", FontName))
		end

		local Radius = tonumber(Library.CornerRadius)
		if Radius then
			table.insert(lines, string.format("Window:SetCornerRadius(%d)", math.floor(Radius + 0.5)))
		end

		local DPI = tonumber(Library.DPIScale)
		if DPI then
			table.insert(lines, string.format("Library:SetDPIScale(%d)", math.floor(DPI * 100 + 0.5)))
		end

		for _, Key in ipairs(ANIM_KEYS) do
			local On = true
			if Library.Animations and Library.Animations[Key] ~= nil then
				On = Library.Animations[Key] and true or false
			end
			table.insert(lines, string.format("Library.Animations.%s = %s", Key, tostring(On)))
		end

		local AnimTime = Library.WindowAnimationInfo and tonumber(Library.WindowAnimationInfo.Time)
		if AnimTime then
			table.insert(lines, string.format("Library.WindowAnimationInfo = TweenInfo.new(%.2f, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)", AnimTime))
		end

		return table.concat(lines, "\n")
	end

	-- Resep WALLPAPER + SURFACE (transparansi, warna kartu/latar).
	local function BuildResep()
		local lines = {
			"--[[ N3V4 RESEP WALLPAPER + SURFACE ]]",
			"Library:SetWallpaper({",
			string.format('\tImage = "%s",', tostring(S.Image)),
			string.format("\tTransparency = %.2f,", S.Transparency),
			string.format('\tScaleType = "%s",', tostring(S.ScaleType)),
			string.format("\tColor = %s,", RGB(S.Color)),
			string.format('\tLayer = "%s",', tostring(S.Layer)),
			string.format("\tOverlay = %s,", tostring(S.Overlay == true)),
			string.format("\tOverlayColor = %s,", RGB(S.OverlayColor)),
			string.format("\tOverlayTransparency = %.2f,", S.OverlayTransparency),
			"})",
			"Library:SetSurface({",
			string.format("\tWindowTransparency = %.2f,", S.Window),
			string.format("\tCanvasTransparency = %.2f,", S.Canvas),
			string.format("\tGroupTransparency = %.2f,", S.Group),
			string.format("\tGroupContrast = %d,", math.floor(S.Contrast + 0.5)),
			(typeof(S.GroupColor) == "Color3")
				and ("\tGroupColor = " .. RGB(S.GroupColor) .. ",")
				or "\tGroupColor = false, -- ikut theme",
			(typeof(S.CanvasColor) == "Color3")
				and ("\tCanvasColor = " .. RGB(S.CanvasColor) .. ",")
				or "\tCanvasColor = false, -- ikut theme",
			"})",
		}
		return table.concat(lines, "\n")
	end

	local function BuildTab()
		local T = Library.TabAppearance or {}
		local lines = {
			"--[[ N3V4 RESEP TAB ]]",
			"Library:SetTabAppearance({",
			string.format("\tIconStrokeThickness = %.2f,", T.IconStrokeThickness or 0),
			string.format("\tIconStrokeTransparency = %.2f,", T.IconStrokeTransparency or 0),
			string.format("\tIconStrokeColor = %s,", RGB(T.IconStrokeColor or Color3.fromRGB(0, 0, 0))),
			string.format("\tTabBackgroundTransparency = %.2f,", T.TabBackgroundTransparency or 0),
			string.format("\tActiveBackgroundTransparency = %.2f,", T.ActiveBackgroundTransparency or 0),
			string.format("\tActiveBackgroundColor = %s,", RGB(T.ActiveBackgroundColor or Color3.fromRGB(218, 68, 255))),
			string.format("\tHoverZoom = %.2f,", T.HoverZoom or 1),
			string.format("\tActiveZoom = %.2f,", T.ActiveZoom or 1),
			string.format("\tZoomTime = %.2f,", T.ZoomTime or 0.15),
			"})",
			string.format("Library.Animations.TabHoverZoom = %s", tostring(Library.Animations and Library.Animations.TabHoverZoom == true)),
		}
		return table.concat(lines, "\n")
	end

	local function Apply()
		pcall(function()
			Library:SetWallpaper({
				Image = S.Image,
				Transparency = S.Transparency,
				ScaleType = S.ScaleType,
				Color = S.Color,
				Layer = S.Layer,
				Overlay = S.Overlay,
				OverlayColor = S.OverlayColor,
				OverlayTransparency = S.OverlayTransparency,
			})
		end)
		pcall(function()
			Library:SetSurface({
				WindowTransparency = S.Window,
				CanvasTransparency = S.Canvas,
				GroupTransparency = S.Group,
				GroupContrast = S.Contrast,
				GroupColor = S.GroupColor,
				CanvasColor = S.CanvasColor,
			})
		end)
	end

	--============================================================================
	-- TAB: UI SETTINGS   (4 kiri / 4 kanan — v4.7.0: box Tab Stroke & Bg + Tab Aktif & Zoom)
	--============================================================================
	local T1 = Window:AddTab("UI Settings", "palette", "Warna scheme, font, radius, animasi")

	Try("Settings: scheme", function()
		local Box = T1:AddLeftGroupbox("Scheme Colors", "droplets")

		local function SchemeRow(Key, Label)
			local Orig = Library.Scheme[Key]
			local Last = Orig
			local Tog = Box:AddToggle("SX_" .. Key, {
				Text = Label,
				Default = false,
				Callback = function(On)
					Library.Scheme[Key] = On and Last or Orig
					Library:UpdateColorsUsingRegistry()
				end,
			})
			Tog:AddColorPicker("SXC_" .. Key, {
				Title = Label,
				Default = Orig,
				Callback = function(Color)
					Last = Color
					if Tog.Value then
						Library.Scheme[Key] = Color
						Library:UpdateColorsUsingRegistry()
					end
				end,
			})
		end

		SchemeRow("AccentColor", "Accent")
		SchemeRow("BackgroundColor", "Background")
		SchemeRow("MainColor", "Main")
		SchemeRow("OutlineColor", "Outline")
		SchemeRow("FontColor", "Font / teks")

		Box:AddButton("Reset scheme", function()
			Library.Scheme.AccentColor = Color3.fromRGB(218, 68, 255)
			Library.Scheme.BackgroundColor = Color3.fromRGB(15, 15, 15)
			Library.Scheme.MainColor = Color3.fromRGB(36, 36, 36)
			Library.Scheme.OutlineColor = Color3.fromRGB(65, 62, 62)
			Library.Scheme.FontColor = Color3.fromRGB(255, 255, 255)
			Library:UpdateColorsUsingRegistry()
		end)
	end)

	Try("Settings: presets theme", function()
		local Box = T1:AddLeftGroupbox("Theme Presets", "wand-sparkles")

		local function Load(Name, C)
			Library.Scheme.AccentColor = C.Accent
			Library.Scheme.BackgroundColor = C.BG
			Library.Scheme.MainColor = C.Main
			Library.Scheme.OutlineColor = C.Outline
			Library.Scheme.FontColor = C.Font
			Library:UpdateColorsUsingRegistry()
			SafeNotify({ Title = "Theme", Description = Name, Icon = "sparkles", Time = 2 })
		end

		Box:AddButton("Default Obsidian", function()
			Load("Obsidian", {
				Accent = Color3.fromRGB(218, 98, 255), BG = Color3.fromRGB(30, 30, 30),
				Main = Color3.fromRGB(40, 40, 40), Outline = Color3.fromRGB(50, 50, 50),
				Font = Color3.fromRGB(238, 238, 238),
			})
		end)
		Box:AddButton("Midnight Cyan", function()
			Load("Midnight", {
				Accent = Color3.fromRGB(34, 211, 238), BG = Color3.fromRGB(15, 23, 42),
				Main = Color3.fromRGB(30, 41, 59), Outline = Color3.fromRGB(51, 65, 85),
				Font = Color3.fromRGB(226, 232, 240),
			})
		end)
		Box:AddButton("Light Mode", function()
			Load("Light", {
				Accent = Color3.fromRGB(124, 58, 237), BG = Color3.fromRGB(245, 245, 245),
				Main = Color3.fromRGB(255, 255, 255), Outline = Color3.fromRGB(210, 210, 210),
				Font = Color3.fromRGB(30, 30, 30),
			})
		end)
		Box:AddButton("N3 Purple (brand)", function()
			Load("N3", {
				Accent = Color3.fromRGB(190, 60, 255), BG = Color3.fromRGB(20, 10, 30),
				Main = Color3.fromRGB(35, 20, 50), Outline = Color3.fromRGB(70, 40, 100),
				Font = Color3.fromRGB(245, 235, 255),
			})
		end)
	end)

	Try("Settings: geometry", function()
		local Box = T1:AddLeftGroupbox("Geometry & Scale", "ruler")

		Box:AddSlider("ST_Radius", {
			Text = "Corner radius", Default = Library.CornerRadius or 10, Min = 0, Max = 20, Rounding = 0, Suffix = "px",
			Callback = function(Value)
				pcall(function() Window:SetCornerRadius(Value) end)
			end,
		})
		Box:AddSlider("ST_DPI", {
			Text = "UI scale", Default = 100, Min = 60, Max = 150, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				pcall(function() Library:SetDPIScale(Value) end)
			end,
		})
		Box:AddToggle("ST_Compact", {
			Text = "Compact mode", Default = false,
			Callback = function(On)
				pcall(function() Window:SetCompact(On) end)
			end,
		})
	end)

	Try("Settings: font & animasi", function()
		local Box = T1:AddLeftGroupbox("Tab Stroke & Bg", "sparkles")

		-- v4.7.0: stroke icon + background semua tab (sidebar). Baseline dari
		-- Library.TabAppearance; user seting manual dulu, print, baru dibake.
		local TA0 = Library.TabAppearance or {}
		local LastStrokeT = TA0.IconStrokeThickness or 1
		local StrokeTog = Box:AddToggle("TB_StrokeOn", {
			Text = "Stroke icon tab", Default = (TA0.IconStrokeThickness or 0) > 0,
			Callback = function(On)
				if On then
					Library:SetTabAppearance({ IconStrokeThickness = LastStrokeT })
				else
					Library:SetTabAppearance({ IconStrokeThickness = 0 })
				end
			end,
		})
		StrokeTog:AddColorPicker("TB_StrokeC", {
			Title = "Stroke color",
			Default = TA0.IconStrokeColor or Color3.fromRGB(0, 0, 0),
			Callback = function(Color)
				Library:SetTabAppearance({ IconStrokeColor = Color })
			end,
		})
		local Sl_StrokeT = Box:AddSlider("TB_StrokeT", {
			Text = "Tebal stroke", Default = TA0.IconStrokeThickness or 1, Min = 0, Max = 3, Rounding = 1, Suffix = "px",
			Callback = function(Value)
				LastStrokeT = Value
				Library:SetTabAppearance({ IconStrokeThickness = Value })
			end,
		})
		local Sl_StrokeTr = Box:AddSlider("TB_StrokeTr", {
			Text = "Stroke transparency (100% = ILANG)", Default = math.floor((TA0.IconStrokeTransparency or 0.4) * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetTabAppearance({ IconStrokeTransparency = Value / 100 })
			end,
		})
		local Sl_BgAll = Box:AddSlider("TB_BgAll", {
			Text = "Bg semua tab (100% = ILANG)", Default = math.floor((TA0.TabBackgroundTransparency or 0.7) * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetTabAppearance({ TabBackgroundTransparency = Value / 100 })
			end,
		})

		local Box = T1:AddRightGroupbox("Font & Animasi", "type")

		Box:AddDropdown("ST_Font", {
			Text = "Font", Values = { "Code", "Gotham", "GothamMedium", "GothamBold", "BuilderSans", "Montserrat", "Ubuntu", "Jura", "SourceSans" }, Default = 1,
			Callback = function(Value)
				local F = GetFontEnum(Value)
				if F then
					Library:SetFont(F)
				end
			end,
		})

		for _, Key in ipairs({ "ToggleWindow", "TabSwitch", "Groupbox", "Dropdown", "KeyPicker" }) do
			Box:AddToggle("ST_Anim_" .. Key, {
				Text = Key, Default = Library.Animations and Library.Animations[Key] ~= false,
				Callback = function(On)
					if Library.Animations then
						Library.Animations[Key] = On
					end
				end,
			})
		end

		-- v4.7.7: durasi animasi buka/tutup WINDOW (library default 0.20s).
		-- Nilai = persen dari 1 detik (20% = 0.20s). Dial di sini, terus
		-- print RESEP THEMA — durasi pilihan lu ikut ke-print buat dibake.
		Box:AddSlider("ST_AnimTime", {
			Text = "Durasi buka/tutup window (% dari 1 detik)",
			Default = math.floor(((Library.WindowAnimationInfo and Library.WindowAnimationInfo.Time) or DEFAULTS.AnimTime) * 100 + 0.5),
			Min = 5, Max = 60, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library.WindowAnimationInfo = TweenInfo.new(Value / 100, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end,
		})
	end)

	Try("Settings: window", function()
		local Box = T1:AddRightGroupbox("Window", "settings-2")

		Box:AddInput("ST_Title", {
			Text = "Title", Default = "", Placeholder = "judul baru (kosongin = skip)", Finished = true,
			Callback = function(Value)
				if Value and Value ~= "" then
					pcall(function() Window:ChangeTitle(Value) end)
				end
			end,
		})
		Box:AddInput("ST_Footer", {
			Text = "Footer", Default = "", Placeholder = "footer baru (kosongin = skip)", Finished = true,
			Callback = function(Value)
				if Value and Value ~= "" then
					pcall(function() Window:SetFooter(Value) end)
				end
			end,
		})
		Box:AddButton("Toggle UI (RightCtrl)", function()
			pcall(function()
				if Window.Toggle then
					Window:Toggle()
				end
			end)
		end)
	end)

	Try("Settings: info", function()
		local Box = T1:AddRightGroupbox("Resep Tema", "copy")

		-- yang diminta user: print resep THEME (accent/outline/main/font/bg)
		Box:AddButton("Print resep tema", function()
			print("[N3V4 RESEP THEMA] paste ini balik:\n" .. BuildTema())
			SafeNotify({ Title = "Resep tema", Description = "Cek Output.", Icon = "copy", Time = 3 })
		end)
		Box:AddButton("Copy resep tema", function()
			local Text = BuildTema()
			if CopyClip(Text) then
				SafeNotify({ Title = "Resep tema", Description = "Copied ke clipboard.", Icon = "clipboard-check", Time = 3 })
			else
				print("[N3V4 RESEP THEMA]\n" .. Text)
				SafeNotify({ Title = "Resep tema", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
			end
		end)
		Box:AddButton("Print SEMUA (tema+wallpaper)", function()
			print("[N3V4 RESEP LENGKAP]\n" .. BuildTema() .. "\n\n" .. BuildResep() .. "\n\n" .. BuildTab())
			SafeNotify({ Title = "Resep", Description = "LENGKAP di Output.", Icon = "copy", Time = 4 })
		end)

		Box:AddLabel("Setingan desain semua di file ini.", true)
		Box:AddLabel("Preview = showcase komponen aja.", true)
	end)

	--============================================================================
	-- TAB: WALLPAPER & SURFACE   (4 kiri / 4 kanan)
	--============================================================================
		local Box = T1:AddRightGroupbox("Tab Aktif & Zoom", "zap")

		local TA1 = Library.TabAppearance or {}
		local LastActiveBgT = TA1.ActiveBackgroundTransparency or 0.55
		local ActiveTog = Box:AddToggle("TB_ActiveOn", {
			Text = "Bg accent tab aktif", Default = (TA1.ActiveBackgroundTransparency or 1) < 1,
			Callback = function(On)
				if On then
					Library:SetTabAppearance({ ActiveBackgroundTransparency = LastActiveBgT })
				else
					Library:SetTabAppearance({ ActiveBackgroundTransparency = 1 })
				end
			end,
		})
		ActiveTog:AddColorPicker("TB_ActiveC", {
			Title = "Warna bg aktif",
			Default = TA1.ActiveBackgroundColor or Color3.fromRGB(218, 68, 255),
			Callback = function(Color)
				Library:SetTabAppearance({ ActiveBackgroundColor = Color })
			end,
		})
		local Sl_BgAct = Box:AddSlider("TB_BgAct", {
			Text = "Bg tab aktif (100% = ILANG)", Default = math.floor((TA1.ActiveBackgroundTransparency or 0.55) * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				LastActiveBgT = Value / 100
				Library:SetTabAppearance({ ActiveBackgroundTransparency = Value / 100 })
			end,
		})
		local Sl_ZoomH = Box:AddSlider("TB_ZoomH", {
			Text = "Zoom hover", Default = math.floor((TA1.HoverZoom or 1.12) * 100 + 0.5), Min = 100, Max = 150, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetTabAppearance({ HoverZoom = Value / 100 })
			end,
		})
		local Sl_ZoomA = Box:AddSlider("TB_ZoomA", {
			Text = "Zoom tab aktif", Default = math.floor((TA1.ActiveZoom or 1.08) * 100 + 0.5), Min = 100, Max = 150, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetTabAppearance({ ActiveZoom = Value / 100 })
			end,
		})
		Box:AddSlider("TB_ZoomT", {
			Text = "Durasi zoom (x0.01s)", Default = math.floor((TA1.ZoomTime or 0.15) * 100 + 0.5), Min = 5, Max = 50, Rounding = 0, Suffix = "",
			Callback = function(Value)
				Library:SetTabAppearance({ ZoomTime = Value / 100 })
			end,
		})
		Box:AddToggle("TB_ZoomOn", {
			Text = "Animasi zoom hover", Default = Library.Animations and Library.Animations.TabHoverZoom ~= false,
			Callback = function(On)
				if Library.Animations then
					Library.Animations.TabHoverZoom = On
				end
			end,
		})
		Box:AddButton("TEST: bikin efek KELIATAN", function()
			-- v4.7.2: tombol panik buat buktiin sistemnya jalan: set nilai yang
			-- PASTI keliatan (stroke pekat, bg jelas, zoom gede) + sync slider.
			pcall(function()
				Library:SetTabAppearance({
					IconStrokeThickness = 1.5,
					IconStrokeTransparency = 0,
					TabBackgroundTransparency = 0.35,
					ActiveBackgroundTransparency = 0.45,
					HoverZoom = 1.25,
					ActiveZoom = 1.15,
				})
			end)
			pcall(function()
				if Library.Animations then
					Library.Animations.TabHoverZoom = true
				end
			end)
			pcall(function() StrokeTog:SetValue(true) end)
			pcall(function() ActiveTog:SetValue(true) end)
			pcall(function() Sl_StrokeT:SetValue(1.5) end)
			pcall(function() Sl_StrokeTr:SetValue(0) end)
			pcall(function() Sl_BgAll:SetValue(35) end)
			pcall(function() Sl_BgAct:SetValue(45) end)
			pcall(function() Sl_ZoomH:SetValue(125) end)
			pcall(function() Sl_ZoomA:SetValue(115) end)
			pcall(function()
				Library:Notify({ Title = "TEST tab", Description = "Nilai diset KELIATAN: stroke 1.5px pekat, bg 35%/45%, zoom 125%/115%. Sekarang hover tab sidebar!", Time = 4 })
			end)
		end)
		Box:AddButton("DEBUG: dump tab visuals", function()
			-- v4.7.3: ground-truth dump kalau efek tab dikira mati lagi:
			-- jumlah rec, size icon (zoom), halo stroke (warna/transp/visible).
			local TV = Library.TabVisuals or {}
			print(string.format("[N3V4 DEBUG TAB] rec=%d activeTab=%s", #TV, tostring(Library.ActiveTab ~= nil)))
			for I, Rec in ipairs(TV) do
				local Icon = Rec.Icon
				local St = Rec.Stroke
				print(string.format(
					"  tab%d | icon size=%s z=%s | halo=%s transp=%s thick-size=%s vis=%s | isActive=%s",
					I,
					tostring(Icon and Icon.Size), tostring(Icon and Icon.ZIndex),
					tostring(St and St.Name or "NIL"),
					tostring(St and St.ImageTransparency), tostring(St and St.Size), tostring(St and St.Visible),
					tostring(Rec.Tab ~= nil and Library.ActiveTab == Rec.Tab)
				))
				if I >= 4 then
					print("  ... (" .. (#TV - 4) .. " lagi)")
					break
				end
			end
		end)
		Box:AddButton("Print resep tab", function()
			print("[N3V4 RESEP TAB]\n" .. BuildTab())
		end)

	local T2 = Window:AddTab("Wallpaper & Surface", "image", "Wallpaper, warna, transparansi")

	Try("WP: source", function()
		local Box = T2:AddLeftGroupbox("Wallpaper", "image")

		Box:AddInput("WP_Id", {
			Text = "Asset ID", Default = tostring(S.Image), Placeholder = "111593326989465", Finished = true,
			Callback = function(Value)
				S.Image = (Value == "" or Value == nil) and "" or Value
				Apply()
			end,
		})
		Box:AddButton("Pakai ID default", function()
			S.Image = DEFAULTS.Image
			Apply()
		end)
		Box:AddButton("Clear", function()
			S.Image = ""
			Apply()
		end)
		Box:AddSlider("WP_Transparency", {
			Text = "Image transparency", Default = math.floor(S.Transparency * 100), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				S.Transparency = Value / 100
				Apply()
			end,
		})
		Box:AddDropdown("WP_ScaleType", {
			Text = "ScaleType", Values = SCALE_TYPE_NAMES,
			Default = (function()
				for i, v in ipairs(SCALE_TYPE_NAMES) do
					if v == S.ScaleType then return i end
				end
				return 3
			end)(),
			Callback = function(Value)
				S.ScaleType = Value
				Apply()
			end,
		})
		Box:AddDropdown("WP_Layer", {
			Text = "Layer", Values = { "back", "front" }, Default = S.Layer == "front" and 2 or 1,
			Callback = function(Value)
				S.Layer = Value
				Apply()
			end,
		})
	end)

	Try("WP: warna", function()
		local Box = T2:AddLeftGroupbox("WARNA", "palette")

		local TintTog = Box:AddToggle("WP_TintToggle", {
			Text = "Tint wallpaper", Default = S.Color ~= Color3.fromRGB(255, 255, 255),
			Callback = function(On)
				S.Color = On and LastTint or Color3.fromRGB(255, 255, 255)
				Apply()
			end,
		})
		TintTog:AddColorPicker("WP_Tint", {
			Title = "Tint wallpaper", Default = S.Color,
			Callback = function(Color)
				LastTint = Color
				if TintTog.Value then
					S.Color = Color
					Apply()
				end
			end,
		})

		local OvTog = Box:AddToggle("WP_OverlayToggle", {
			Text = "Overlay", Default = S.Overlay,
			Callback = function(On)
				S.Overlay = On
				Apply()
			end,
		})
		OvTog:AddColorPicker("WP_OverlayColor", {
			Title = "Warna overlay", Default = S.OverlayColor,
			Callback = function(Color)
				S.OverlayColor = Color
				Apply()
			end,
		})

		local CanTog = Box:AddToggle("WP_CanvasToggle", {
			Text = "Canvas custom", Default = typeof(S.CanvasColor) == "Color3",
			Callback = function(On)
				S.CanvasColor = On and LastCanvas or false
				Apply()
			end,
		})
		CanTog:AddColorPicker("WP_CanvasColor", {
			Title = "Warna canvas", Default = typeof(S.CanvasColor) == "Color3" and S.CanvasColor or Color3.fromRGB(32, 32, 32),
			Callback = function(Color)
				LastCanvas = Color
				if CanTog.Value then
					S.CanvasColor = Color
					Apply()
				end
			end,
		})

		local GrpTog = Box:AddToggle("WP_GroupToggle", {
			Text = "Group custom", Default = typeof(S.GroupColor) == "Color3",
			Callback = function(On)
				S.GroupColor = On and LastGroup or false
				Apply()
			end,
		})
		GrpTog:AddColorPicker("WP_GroupColor", {
			Title = "Warna kartu group", Default = typeof(S.GroupColor) == "Color3" and S.GroupColor or Color3.fromRGB(30, 30, 30),
			Callback = function(Color)
				LastGroup = Color
				if GrpTog.Value then
					S.GroupColor = Color
					Apply()
				end
			end,
		})

		Box:AddButton("Semua warna: bawaan", function()
			-- v4.6.7: "bawaan" = DEFAULTS user (tint abu 0.59, canvas 0.045,
			-- kartu HITAM) — BUKAN warna pabrikan library. Kartu hitam lu
			-- harus bertahan dimanapun lu klik reset.
			LastTint = DEFAULTS.Color
			LastCanvas = (typeof(DEFAULTS.CanvasColor) == "Color3") and DEFAULTS.CanvasColor or Color3.fromRGB(32, 32, 32)
			LastGroup = (typeof(DEFAULTS.GroupColor) == "Color3") and DEFAULTS.GroupColor or Color3.fromRGB(0, 0, 0)
			S.Color = LastTint
			S.OverlayColor = DEFAULTS.OverlayColor
			S.CanvasColor = DEFAULTS.CanvasColor
			S.GroupColor = DEFAULTS.GroupColor
			TintTog:SetValue(S.Color ~= Color3.fromRGB(255, 255, 255))
			CanTog:SetValue(typeof(S.CanvasColor) == "Color3")
			GrpTog:SetValue(typeof(S.GroupColor) == "Color3")
			Apply()
		end)
	end)

	Try("WP: transparansi", function()
		local Box = T2:AddLeftGroupbox("Transparansi", "sliders-horizontal")

		local sliders = {
			{ "WP_Window", "Window", S.Window, function(v) S.Window = v end },
			{ "WP_Canvas", "Canvas / latar", S.Canvas, function(v) S.Canvas = v end },
			{ "WP_Group", "Kartu group", S.Group, function(v) S.Group = v end },
			{ "WP_OverlayT", "Overlay", S.OverlayTransparency, function(v) S.OverlayTransparency = v end },
		}
		for _, Spec in ipairs(sliders) do
			Box:AddSlider(Spec[1], {
				Text = Spec[2], Default = math.floor(Spec[3] * 100), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
				Callback = function(Value)
					Spec[4](Value / 100)
					Apply()
				end,
			})
		end

		Box:AddSlider("WP_Contrast", {
			Text = "Group contrast", Default = math.floor(S.Contrast), Min = 0, Max = 40, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				S.Contrast = Value
				Apply()
			end,
		})

		Box:AddButton("Solid semua (0%)", function()
			S.Window = 0
			S.Canvas = 0
			S.Group = 0
			Apply()
		end)
	end)

	Try("WP: cepat", function()
		local Box = T2:AddLeftGroupbox("Cepat", "zap")

		Box:AddButton("RESEP USER (disetujui)", function()
			S.Image = DEFAULTS.Image
			S.Transparency = DEFAULTS.Transparency
			S.ScaleType = DEFAULTS.ScaleType
			S.Color = DEFAULTS.Color
			S.Layer = DEFAULTS.Layer
			S.Overlay = DEFAULTS.Overlay
			S.OverlayColor = DEFAULTS.OverlayColor
			S.OverlayTransparency = DEFAULTS.OverlayTransparency
			S.Window = DEFAULTS.Window
			S.Canvas = DEFAULTS.Canvas
			S.Group = DEFAULTS.Group
			S.Contrast = DEFAULTS.Contrast
			S.GroupColor = DEFAULTS.GroupColor
			S.CanvasColor = DEFAULTS.CanvasColor
			Apply()
			pcall(function()
				Library:SetTabAppearance(DEFAULTS.Tab)
				if Library.Animations then
					Library.Animations.TabHoverZoom = DEFAULTS.TabHoverZoom ~= false
				end
				Library.WindowAnimationInfo = TweenInfo.new(DEFAULTS.AnimTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end)
			SafeNotify({ Title = "Wallpaper", Description = "Resep user dipasang.", Icon = "sparkles", Time = 3 })
		end)

		Box:AddButton("BALIK NORMAL (semula)", function()
			S.Image = ""
			S.Window = 0
			S.Canvas = 0
			S.Group = 0
			S.Contrast = 0
			S.GroupColor = false
			S.CanvasColor = false
			S.Overlay = false
			Apply()
		end)

		Box:AddButton("Wallpaper ON + canvas", function()
			S.Image = DEFAULTS.Image
			S.Canvas = 1
			S.Layer = "back"
			S.Overlay = false
			Apply()
		end)

		Box:AddButton("Wallpaper OFF", function()
			S.Image = ""
			Apply()
		end)
	end)

	Try("WP: presets", function()
		local Box = T2:AddRightGroupbox("Presets", "wand-sparkles")

		local function Load(Name, P)
			S.Image = P.Image
			S.Transparency = P.Transparency
			S.ScaleType = P.ScaleType
			S.Color = P.Color or Color3.fromRGB(255, 255, 255)
			S.Layer = P.Layer or "back"
			S.Overlay = P.Overlay
			S.OverlayColor = P.OverlayColor or Color3.fromRGB(0, 0, 0)
			S.OverlayTransparency = P.OverlayTransparency
			if P.Window ~= nil then
				S.Window = P.Window
			end
			S.Canvas = P.Canvas
			S.Group = P.Group
			S.Contrast = P.Contrast
			-- v4.6.7: preset NGGAK boleh matiin warna custom user (kartu hitam
			-- "group warna hitam anj!") — GroupColor/CanvasColor dibiarin apa adanya.
			Apply()
			SafeNotify({ Title = "Preset", Description = Name, Icon = "sparkles", Time = 2 })
		end

		Box:AddButton("Subtle (tipis)", function()
			Load("Subtle", { Image = DEFAULTS.Image, Transparency = 0.78, ScaleType = "Crop", Layer = "back", Overlay = true, OverlayTransparency = 0.30, Canvas = 1, Group = 0, Contrast = 0 })
		end)
		Box:AddButton("Bold (kuat)", function()
			Load("Bold", { Image = DEFAULTS.Image, Transparency = 0.12, ScaleType = "Crop", Layer = "back", Overlay = true, OverlayTransparency = 0.60, Canvas = 1, Group = 0, Contrast = 0 })
		end)
		Box:AddButton("Wash (back terang)", function()
			-- dulu "Wash (front)": layer front = veil nutup SEMUA termasuk kartu ->
			-- kartu kebaca transparan walau Group 0. User marah (v4.6.7) -> back.
			Load("Wash", { Image = DEFAULTS.Image, Transparency = 0.82, ScaleType = "Stretch", Layer = "back", Overlay = true, OverlayTransparency = 0.50, Canvas = 1, Window = 1, Group = 0, Contrast = 0 })
		end)
		Box:AddButton("Accent tint ungu", function()
			Load("Accent", { Image = DEFAULTS.Image, Transparency = 0.45, ScaleType = "Crop", Color = Color3.fromRGB(218, 98, 255), Layer = "back", Overlay = true, OverlayColor = Color3.fromRGB(20, 8, 30), OverlayTransparency = 0.40, Canvas = 1, Group = 0, Contrast = 0 })
		end)
		Box:AddButton("Glass (group tembus)", function()
			Load("Glass", { Image = DEFAULTS.Image, Transparency = 0.25, ScaleType = "Crop", Layer = "back", Overlay = true, OverlayTransparency = 0.55, Canvas = 1, Group = 0.35, Contrast = 0 })
		end)
		Box:AddButton("Kartu nongol (15%)", function()
			Load("Nongol", { Image = DEFAULTS.Image, Transparency = 0.35, ScaleType = "Crop", Layer = "back", Overlay = true, OverlayTransparency = 0.45, Canvas = 1, Group = 0, Contrast = 15 })
		end)
	end)

	Try("WP: resep", function()
		local Box = T2:AddRightGroupbox("Resep", "copy")

		Box:AddButton("Print resep wallpaper", function()
			print("[N3V4 RESEP WALLPAPER] paste ini balik:\n" .. BuildResep())
			SafeNotify({ Title = "Resep", Description = "Wallpaper + surface di Output.", Icon = "copy", Time = 3 })
		end)
		Box:AddButton("Print resep LENGKAP", function()
			print("[N3V4 RESEP LENGKAP] tema + wallpaper + surface + tab:\n" .. BuildTema() .. "\n\n" .. BuildResep() .. "\n\n" .. BuildTab())
			SafeNotify({ Title = "Resep", Description = "LENGKAP (tema + wallpaper) di Output.", Icon = "copy", Time = 4 })
		end)
		Box:AddButton("Copy resep LENGKAP", function()
			local Text = BuildTema() .. "\n\n" .. BuildResep() .. "\n\n" .. BuildTab()
			if CopyClip(Text) then
				SafeNotify({ Title = "Resep", Description = "Copied ke clipboard.", Icon = "clipboard-check", Time = 3 })
			else
				print("[N3V4 RESEP LENGKAP]\n" .. Text)
				SafeNotify({ Title = "Resep", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
			end
		end)
		Box:AddButton("Print info lengkap", function()
			pcall(function()
				if typeof(Window.GetWallpaperInfo) == "function" then
					print("[N3V4 Wallpaper] ", Window:GetWallpaperInfo())
				end
			end)
		end)
	end)

	Try("WP: live info", function()
		local Box = T2:AddRightGroupbox("Live Info", "info")

		local Rows = {}
		for _, Key in ipairs({ "Image", "Visible", "Layer", "ScaleTypeName", "WindowTransparency", "CanvasTransparency", "GroupTransparency" }) do
			Rows[Key] = Box:AddLabel(Key .. ": -", false)
		end
		local Status = Box:AddLabel("status: -", true)

		local function Refresh()
			pcall(function()
				if typeof(Window.GetWallpaperInfo) ~= "function" then
					return
				end
				local I = Window:GetWallpaperInfo()
				for Key, L in pairs(Rows) do
					if L and L.SetText then
						L:SetText(string.format("%s: %s", Key, tostring(I[Key])))
					end
				end
				if Status and Status.SetText then
					if I.Visible == false and tostring(I.Image) ~= "" then
						Status:SetText("⚠ image gagal load (asset private/salah ID)")
					elseif tostring(I.Image) == "" then
						Status:SetText("wallpaper kosong")
					else
						Status:SetText("OK — wallpaper ke-load")
					end
				end
			end)
		end

		Box:AddButton("Refresh", Refresh)
		Refresh()
	end)

	Try("WP: combo cepat", function()
		local Box = T2:AddRightGroupbox("Combo Cepat", "zap")

		local function Combo(Scale, Layer)
			S.ScaleType = Scale
			S.Layer = Layer
			Apply()
			SafeNotify({ Title = "Combo", Description = Scale .. " + " .. Layer, Icon = "zap", Time = 2 })
		end

		Box:AddButton("Crop + back", function() Combo("Crop", "back") end)
		Box:AddButton("Stretch + back", function() Combo("Stretch", "back") end)
		Box:AddButton("Tile + back", function() Combo("Tile", "back") end)
		Box:AddButton("Fit + back", function() Combo("Fit", "back") end)
	end)

	return true
end

--================================================================================
-- DUAL MODE
--================================================================================
-- Biar preview (LocalScript pertama) bisa nemuin file ini lewat shared.
shared.N3V4_UISettings = Settings

-- Kalau file ini jalan sebagai LOCALSCRIPT: nempel sendiri begitu
-- library & window siap. Kalau di-require sebagai ModuleScript, preview
-- yang manggil Attach — flag attached mencegah double.
task.spawn(function()
	local Library, Window
	for _ = 1, 60 do
		if not shared.N3V4_UISettings_Attached then
			Library = Library or shared.Library
			if Library and Library.Window then
				Window = Library.Window
				break
			end
		else
			return
		end
		task.wait(0.1)
	end
	if Library and Window and not shared.N3V4_UISettings_Attached then
		pcall(function()
			Settings:Attach(Library, Window)
		end)
	end
end)

return Settings

--================================================================================
-- N3V4 — UI SETTINGS   (ModuleScript: "N3V4_UISettings")
--================================================================================
-- SEMUA setingan desain UI ada DI FILE INI: wallpaper, overlay, surface,
-- warna scheme, font, corner radius, animasi, preset, sampe print resep.
--
-- Preview utama (N3V4_Preview.client.lua) NGGAK punya setingan UI — dia murni
-- showcase komponen (button, toggle, dropdown, image, viewport, dll).
-- Kalau ModuleScript ini ada di ReplicatedStorage dengan nama
-- "N3V4_UISettings", preview otomatis require dia dan tab setting muncul.
--
-- PAKAI MANUAL:
--   local Settings = require(ReplicatedStorage.N3V4_UISettings)
--   Settings:Attach(Library, Window)
--
-- Semua default = RESEP USER yang disetujui 2026-10-20.
--================================================================================

local Settings = {}

-- Racikan user ("nih brok ini bagus jir") — jangan diubah tanpa user minta
Settings.DEFAULTS = {
	Image = "111593326989465",
	Transparency = 0.70,
	ScaleType = "Stretch",
	Color = Color3.fromRGB(55, 55, 55),
	Layer = "front",
	Overlay = true,
	OverlayColor = Color3.fromRGB(46, 46, 46),
	OverlayTransparency = 0.90,

	Canvas = 0.64,
	Group = 0.11,
	Contrast = 11,
	GroupColor = Color3.fromRGB(0, 0, 0),
	CanvasColor = Color3.fromRGB(0, 0, 0),
}

function Settings:Attach(Library, Window, Options)
	Options = Options or {}
	local DEFAULTS = Settings.DEFAULTS

	--// helper lokal \--
	local function Try(Label, Func)
		local OK, Err = pcall(Func)
		if not OK then
			warn("[N3V4 Settings] " .. Label .. " gagal: " .. tostring(Err))
		end
		return OK
	end

	local function SafeNotify(Info)
		pcall(function()
			Library:Notify(Info)
		end)
	end

	local function PrintInfo()
		if typeof(Window.GetWallpaperInfo) == "function" then
			print("[N3V4 Settings] ", Window:GetWallpaperInfo())
		end
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

--================================================================================
-- TAB 6 — THEME LAB   (3 kiri / 3 kanan — simetris)
--================================================================================
local ThemeTab = Window:AddTab("UI Settings", "palette", "Semua setingan desain UI: warna, font, radius, animasi")

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
		Text = "Window title", Default = "", Placeholder = "judul baru (kosongin = skip)", Finished = true,
		Callback = function(Value) if Value and Value ~= "" and Window.ChangeTitle then Window:ChangeTitle(Value) end end,
	})
	Box:AddInput("Theme_Footer", {
		Text = "Window footer", Default = "", Placeholder = "footer baru (kosongin = skip)", Finished = true,
		Callback = function(Value) if Value and Value ~= "" and Window.SetFooter then Window:SetFooter(Value) end end,
	})

	Box:AddDivider({ Text = "Utility", Margin = 4 })

	Box:AddButton("Print laporan ke Output", function() PrintInfo() end)
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
			PrintInfo()
			Library:Unload()
		end,
	})
end)

--================================================================================
-- TAB 7 — WALLPAPER   (3 kiri / 3 kanan — simetris)
--================================================================================
local WallpaperTab = Window:AddTab("Wallpaper & Surface", "image", "Wallpaper, overlay, layering, surface")

-- State wallpaper sekarang (dipakai bareng sama semua kontrol di bawah)
local WP = {
	Image = DEFAULTS.Image,
	Transparency = DEFAULTS.Transparency,
	ScaleType = DEFAULTS.ScaleType,
	Color = DEFAULTS.Color,
	Layer = DEFAULTS.Layer,
	Overlay = DEFAULTS.Overlay,
	OverlayColor = DEFAULTS.OverlayColor,
	OverlayTransparency = DEFAULTS.OverlayTransparency,

	-- Surface: latar konten & kartu group (terpisah dari wallpaper)
	CanvasTransparency = DEFAULTS.Canvas,
	GroupTransparency = DEFAULTS.Group,
	GroupContrast = DEFAULTS.Contrast,
	-- nil/false = ikut theme. Color3 = override manual dari color picker
	GroupColor = DEFAULTS.GroupColor,
	CanvasColor = DEFAULTS.CanvasColor,
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
	if not Success and true then
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
		WP.Image = DEFAULTS.Image
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
		WP.CanvasTransparency = P.Canvas ~= nil and P.Canvas or DEFAULTS.Canvas
		WP.GroupTransparency = P.Group ~= nil and P.Group or DEFAULTS.Group
		WP.GroupContrast = P.Contrast ~= nil and P.Contrast or DEFAULTS.Contrast
		WP.GroupColor = P.GroupColor ~= nil and P.GroupColor or false
		WP.CanvasColor = P.CanvasColor ~= nil and P.CanvasColor or false
		ApplyWallpaper()
		SafeNotify({ Title = "Preset", Description = Name, Icon = "sparkles", Time = 2 })
	end

	Box:AddButton("RESEP USER (yang disetujui)", function()
		LoadPreset("Resep user", {
			Image = DEFAULTS.Image, Transparency = 0.70, ScaleType = "Stretch",
			Color = Color3.fromRGB(55, 55, 55), Layer = "front",
			Overlay = true, OverlayColor = Color3.fromRGB(46, 46, 46), OverlayTransparency = 0.90,
			Canvas = 0.64, Group = 0.11, Contrast = 11,
			GroupColor = Color3.fromRGB(0, 0, 0), CanvasColor = Color3.fromRGB(0, 0, 0),
		})
	end)

	Box:AddButton("Subtle ( wallpaper tipis )", function()
		LoadPreset("Subtle", {
			Image = DEFAULTS.Image, Transparency = 0.72, ScaleType = "Crop",
			Layer = "back", Overlay = true, OverlayTransparency = 0.30,
			Canvas = 1, Group = 0, Contrast = 0,
		})
	end)

	Box:AddButton("Bold (wallpaper kuat)", function()
		LoadPreset("Bold", {
			Image = DEFAULTS.Image, Transparency = 0.10, ScaleType = "Crop",
			Layer = "back", Overlay = true, OverlayTransparency = 0.60,
			Canvas = 1, Group = 0, Contrast = 0,
		})
	end)

	Box:AddButton("Wash (layer front)", function()
		LoadPreset("Wash", {
			Image = DEFAULTS.Image, Transparency = 0.82, ScaleType = "Stretch",
			Layer = "front", Overlay = false, OverlayTransparency = 0.5,
			Canvas = 0, Group = 0, Contrast = 10,
		})
	end)

	Box:AddButton("Accent tint (ungu N3)", function()
		LoadPreset("Accent tint", {
			Image = DEFAULTS.Image, Transparency = 0.45, ScaleType = "Crop",
			Color = Color3.fromRGB(218, 98, 255), Layer = "back",
			Overlay = true, OverlayColor = Color3.fromRGB(20, 8, 30), OverlayTransparency = 0.40,
			Canvas = 1, Group = 0, Contrast = 0,
		})
	end)

	Box:AddButton("Kartu nongol (contrast 15)", function()
		LoadPreset("Kartu nongol", {
			Image = DEFAULTS.Image, Transparency = 0.35, ScaleType = "Crop",
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
		WP.Image = DEFAULTS.Image
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


	return true
end

return Settings

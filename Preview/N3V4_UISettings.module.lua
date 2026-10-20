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
-- Default = RESEP USER yang disetujui 2026-10-20.
--================================================================================

local Settings = {}

Settings.DEFAULTS = {
	Image = "111593326989465",
	Transparency = 0.70,
	ScaleType = "Stretch",
	Color = Color3.fromRGB(55, 55, 55),
	Layer = "front",
	Overlay = true,
	OverlayColor = Color3.fromRGB(46, 46, 46),
	OverlayTransparency = 0.90,

	Window = 0, -- transparency dasar window
	Canvas = 0.64,
	Group = 0.11,
	Contrast = 11,
	GroupColor = Color3.fromRGB(0, 0, 0),
	CanvasColor = Color3.fromRGB(0, 0, 0),
}

function Settings:Attach(Library, Window, Options)
	if shared.N3V4_UISettings_Attached then
		return false
	end
	shared.N3V4_UISettings_Attached = true

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
	local LastGroup = S.GroupColor

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
	-- TAB: UI SETTINGS   (3 kiri / 3 kanan)
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
			Library.Scheme.AccentColor = Color3.fromRGB(218, 98, 255)
			Library.Scheme.BackgroundColor = Color3.fromRGB(30, 30, 30)
			Library.Scheme.MainColor = Color3.fromRGB(40, 40, 40)
			Library.Scheme.OutlineColor = Color3.fromRGB(50, 50, 50)
			Library.Scheme.FontColor = Color3.fromRGB(238, 238, 238)
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
		local Box = T1:AddRightGroupbox("Info", "info")
		Box:AddLabel("File ini = semua setingan desain.", true)
		Box:AddLabel("Preview = showcase komponen aja.", true)
		Box:AddLabel("Tab sebelah: wallpaper & surface.", true)
	end)

	--============================================================================
	-- TAB: WALLPAPER & SURFACE   (4 kiri / 4 kanan)
	--============================================================================
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
			LastTint = Color3.fromRGB(255, 255, 255)
			LastCanvas = Color3.fromRGB(32, 32, 32)
			LastGroup = Color3.fromRGB(30, 30, 30)
			S.Color = LastTint
			S.OverlayColor = Color3.fromRGB(0, 0, 0)
			S.CanvasColor = false
			S.GroupColor = false
			TintTog:SetValue(false)
			CanTog:SetValue(false)
			GrpTog:SetValue(false)
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
			S.Canvas = P.Canvas
			S.Group = P.Group
			S.Contrast = P.Contrast
			S.GroupColor = false
			S.CanvasColor = false
			Apply()
			SafeNotify({ Title = "Preset", Description = Name, Icon = "sparkles", Time = 2 })
		end

		Box:AddButton("Subtle (tipis)", function()
			Load("Subtle", { Image = DEFAULTS.Image, Transparency = 0.78, ScaleType = "Crop", Layer = "back", Overlay = true, OverlayTransparency = 0.30, Canvas = 1, Group = 0, Contrast = 0 })
		end)
		Box:AddButton("Bold (kuat)", function()
			Load("Bold", { Image = DEFAULTS.Image, Transparency = 0.12, ScaleType = "Crop", Layer = "back", Overlay = true, OverlayTransparency = 0.60, Canvas = 1, Group = 0, Contrast = 0 })
		end)
		Box:AddButton("Wash (front)", function()
			Load("Wash", { Image = DEFAULTS.Image, Transparency = 0.82, ScaleType = "Stretch", Layer = "front", Overlay = false, OverlayTransparency = 0.5, Canvas = 0, Group = 0, Contrast = 0 })
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

		local function BuildResep()
			local C = S.OverlayColor
			local T = S.Color
			local lines = {
				"Library:SetWallpaper({",
				string.format('\tImage = "%s",', tostring(S.Image)),
				string.format("\tTransparency = %.2f,", S.Transparency),
				string.format('\tScaleType = "%s",', tostring(S.ScaleType)),
				string.format("\tColor = Color3.fromRGB(%d, %d, %d),", math.floor(T.R * 255 + 0.5), math.floor(T.G * 255 + 0.5), math.floor(T.B * 255 + 0.5)),
				string.format('\tLayer = "%s",', tostring(S.Layer)),
				string.format("\tOverlay = %s,", tostring(S.Overlay == true)),
				string.format("\tOverlayColor = Color3.fromRGB(%d, %d, %d),", math.floor(C.R * 255 + 0.5), math.floor(C.G * 255 + 0.5), math.floor(C.B * 255 + 0.5)),
				string.format("\tOverlayTransparency = %.2f,", S.OverlayTransparency),
				"})",
				"Library:SetSurface({",
				string.format("\tWindowTransparency = %.2f,", S.Window),
				string.format("\tCanvasTransparency = %.2f,", S.Canvas),
				string.format("\tGroupTransparency = %.2f,", S.Group),
				string.format("\tGroupContrast = %d,", math.floor(S.Contrast + 0.5)),
				(typeof(S.GroupColor) == "Color3")
					and string.format("\tGroupColor = Color3.fromRGB(%d, %d, %d),", math.floor(S.GroupColor.R * 255 + 0.5), math.floor(S.GroupColor.G * 255 + 0.5), math.floor(S.GroupColor.B * 255 + 0.5))
					or "\tGroupColor = false, -- ikut theme",
				(typeof(S.CanvasColor) == "Color3")
					and string.format("\tCanvasColor = Color3.fromRGB(%d, %d, %d),", math.floor(S.CanvasColor.R * 255 + 0.5), math.floor(S.CanvasColor.G * 255 + 0.5), math.floor(S.CanvasColor.B * 255 + 0.5))
					or "\tCanvasColor = false, -- ikut theme",
				"})",
			}
			return table.concat(lines, "\n")
		end

		Box:AddButton("Print resep Lua", function()
			print("[N3V4 RESEP] paste ini balik:\n" .. BuildResep())
			SafeNotify({ Title = "Resep", Description = "Cek Output.", Icon = "copy", Time = 3 })
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
		Box:AddButton("Stretch + front", function() Combo("Stretch", "front") end)
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

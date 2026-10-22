
local Settings = {}

Settings.DEFAULTS = {
	Image = "111593326989465",
	Transparency = 0,
	ScaleType = "Stretch",
	Color = Color3.fromRGB(148, 148, 148),
	Layer = "back",
	Overlay = true,
	OverlayColor = Color3.fromRGB(0, 0, 0),
	OverlayTransparency = 0.40,

	Window = 1,
	Canvas = 1,
	Group = 0.5,
	Contrast = 40,
	Tab = {
		IconCardEnabled = true,
		IconCardPadding = 2,
		IconCardThickness = 1,
		IconCardTransparency = 0.00,
		IconCardRadius = 5,
		TabBackgroundTransparency = 0.85,
		ActiveBackgroundTransparency = 0.60,
		ActiveBackgroundColor = Color3.fromRGB(0, 0, 0),
		HoverZoom = 1.25,
		ActiveZoom = 1.25,
		ZoomTime = 0.20,
	},
	TabHoverZoom = true,
	AnimTime = 0.10,
	GroupColor = Color3.fromRGB(0, 0, 0),
	CanvasColor = Color3.fromRGB(119, 119, 119),
	Glow = {
		Enabled = true,
		Color = Color3.fromRGB(255, 255, 255),
		Size = 400,
		Intensity = 10,
		Smooth = 5,
	},
	IconAnim = {
		Enabled = true,
		Zoom = 15,
		Tilt = 10,
		Speed = 0.30,
	},
}

function Settings:Attach(Library, Window, Options)
	if shared.N3V4_UISettings_Attached then
		return false
	end
	shared.N3V4_UISettings_Attached = true

	if type(Library.SetTabAppearance) ~= "function" or type(Library.TabAppearance) ~= "table" or Library.TabAppearance.IconCardEnabled == nil then
		warn("[N3V4 Settings] LIBRARY LAMA terdeteksi (SetTabAppearance/TabAppearance/knob IconCard nil)! Paste ulang Library/N3V3-NoObfus.lua ke ModuleScript N3V4 di ReplicatedStorage, kalau nggak knob Tab Card/Bg/Zoom nggak akan ngaruh.")
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

	local function BuildGlow()
		local G = Library.CursorGlow or {}
		return table.concat({
			"--[[ N3V4 CURSOR GLOW ]]",
			"Library:SetCursorGlow({",
			string.format("\tEnabled = %s,", tostring(G.Enabled ~= false)),
			(typeof(G.Color) == "Color3") and ("\tColor = " .. RGB(G.Color) .. ",") or "\tColor = false, -- ikut accent theme",
			string.format("\tSize = %d,", G.Size or 400),
			string.format("\tIntensity = %d,", G.Intensity or 10),
			string.format("\tSmooth = %d,", G.Smooth or 5),
			"})",
		}, "\n")
	end

	local function BuildIconAnim()
		local A = Library.IconAnim or {}
		return table.concat({
			"--[[ N3V4 ICON ANIM ]]",
			"Library:SetIconAnim({",
			string.format("\tEnabled = %s,", tostring(A.Enabled ~= false)),
			string.format("\tZoom = %d,", A.Zoom or 15),
			string.format("\tTilt = %d,", A.Tilt or 10),
			string.format("\tSpeed = %.2f,", A.Speed or 0.30),
			"})",
		}, "\n")
	end

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
			"",
			BuildGlow(),
		}
		return table.concat(lines, "\n")
	end

	local function BuildTab()
		local T = Library.TabAppearance or {}
		local lines = {
			"--[[ N3V4 RESEP TAB ]]",
			"Library:SetTabAppearance({",
			string.format("\tIconCardEnabled = %s,", tostring(T.IconCardEnabled ~= false)),
			string.format("\tIconCardPadding = %.2f,", T.IconCardPadding or 0),
			string.format("\tIconCardThickness = %.2f,", T.IconCardThickness or 0),
			string.format("\tIconCardTransparency = %.2f,", T.IconCardTransparency or 0),
			string.format("\tIconCardRadius = %.2f,", T.IconCardRadius or 0),
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
		local Box = T1:AddLeftGroupbox("Tab Card & Bg", "sparkles")

		local TA0 = Library.TabAppearance or {}
		local CardTog = Box:AddToggle("TB_CardOn", {
			Text = "Card outline icon tab", Default = TA0.IconCardEnabled ~= false,
			Callback = function(On)
				Library:SetTabAppearance({ IconCardEnabled = On })
			end,
		})
		local Sl_CardT = Box:AddSlider("TB_CardT", {
			Text = "Tebal garis card", Default = TA0.IconCardThickness or 1.5, Min = 0, Max = 3, Rounding = 1, Suffix = "px",
			Callback = function(Value)
				Library:SetTabAppearance({ IconCardThickness = Value })
			end,
		})
		local Sl_CardTr = Box:AddSlider("TB_CardTr", {
			Text = "Card transparency (100% = ILANG)", Default = math.floor((TA0.IconCardTransparency or 0.3) * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetTabAppearance({ IconCardTransparency = Value / 100 })
			end,
		})
		Box:AddSlider("TB_CardPad", {
			Text = "Napas card ke icon (simetris)", Default = TA0.IconCardPadding or 4, Min = 0, Max = 10, Rounding = 0, Suffix = "px",
			Callback = function(Value)
				Library:SetTabAppearance({ IconCardPadding = Value })
			end,
		})
		Box:AddSlider("TB_CardRad", {
			Text = "Radius sudut card", Default = TA0.IconCardRadius or 6, Min = 0, Max = 16, Rounding = 0, Suffix = "px",
			Callback = function(Value)
				Library:SetTabAppearance({ IconCardRadius = Value })
			end,
		})
		local Sl_BgAll = Box:AddSlider("TB_BgAll", {
			Text = "Bg semua tab (100% = ILANG)", Default = math.floor((TA0.TabBackgroundTransparency or 0.7) * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetTabAppearance({ TabBackgroundTransparency = Value / 100 })
			end,
		})
		Box:AddButton("Print resep tab", function()
			print("[N3V4 RESEP TAB] paste ini balik:\n" .. BuildTab())
			SafeNotify({ Title = "Resep tab", Description = "Cek Output.", Icon = "copy", Time = 3 })
		end)
		Box:AddButton("Copy resep tab", function()
			local Text = BuildTab()
			if CopyClip(Text) then
				SafeNotify({ Title = "Resep tab", Description = "Copied ke clipboard.", Icon = "clipboard-check", Time = 3 })
			else
				print("[N3V4 RESEP TAB]\n" .. Text)
				SafeNotify({ Title = "Resep tab", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
			end
		end)

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

		Box:AddSlider("ST_AnimTime", {
			Text = "Durasi buka/tutup window (% dari 1 detik)",
			Default = math.floor(((Library.WindowAnimationInfo and Library.WindowAnimationInfo.Time) or DEFAULTS.AnimTime) * 100 + 0.5),
			Min = 5, Max = 60, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library.WindowAnimationInfo = TweenInfo.new(Value / 100, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end,
		})

		local IA0 = Library.IconAnim or {}
		Box:AddToggle("IA_On", {
			Text = "Animasi icon group", Default = IA0.Enabled ~= false,
			Callback = function(On)
				Library:SetIconAnim({ Enabled = On })
			end,
		})
		Box:AddSlider("IA_Zoom", {
			Text = "Zoom icon saat hover", Default = IA0.Zoom or 15, Min = 0, Max = 40, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetIconAnim({ Zoom = Value })
			end,
		})
		Box:AddSlider("IA_Tilt", {
			Text = "Kemiringan icon saat hover", Default = IA0.Tilt or 10, Min = 0, Max = 20, Rounding = 0, Suffix = "°",
			Callback = function(Value)
				Library:SetIconAnim({ Tilt = Value })
			end,
		})
		Box:AddSlider("IA_Speed", {
			Text = "Durasi animasi icon", Default = IA0.Speed or 0.30, Min = 0.05, Max = 0.6, Rounding = 2, Suffix = "s",
			Callback = function(Value)
				Library:SetIconAnim({ Speed = Value })
			end,
		})
		Box:AddButton("Print resep icon anim", function()
			print("[N3V4 RESEP ICON ANIM] paste ini balik:\n" .. BuildIconAnim())
		end)
		Box:AddButton("Copy resep icon anim", function()
			local Text = BuildIconAnim()
			if CopyClip(Text) then
				SafeNotify({ Title = "Resep icon anim", Description = "Copied ke clipboard.", Icon = "clipboard-check", Time = 3 })
			else
				print("[N3V4 RESEP ICON ANIM]\n" .. Text)
				SafeNotify({ Title = "Resep icon anim", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
			end
		end)
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

	Try("Settings: cursor glow", function()
		local CG0 = Library.CursorGlow or {}
		local Box = T1:AddLeftGroupbox("Cursor Glow", "sparkles")

		local GlowTog = Box:AddToggle("GW_On", {
			Text = "Cursor glow aktif", Default = CG0.Enabled ~= false,
			Callback = function(On)
				Library:SetCursorGlow({ Enabled = On })
			end,
		})
		GlowTog:AddColorPicker("GW_C", {
			Title = "Warna glow (preset 'ikut accent' buat balik)",
			Default = (typeof(CG0.Color) == "Color3" and CG0.Color) or (Library.Scheme and Library.Scheme.AccentColor) or Color3.fromRGB(218, 68, 255),
			Callback = function(Color)
				Library:SetCursorGlow({ Color = Color })
			end,
		})
		Box:AddSlider("GW_Size", {
			Text = "Lebar glow (diameter)", Default = CG0.Size or 400, Min = 60, Max = 600, Rounding = 0, Suffix = "px",
			Callback = function(Value)
				Library:SetCursorGlow({ Size = Value })
			end,
		})
		Box:AddSlider("GW_Int", {
			Text = "Kejelasan tengah glow (0% = invisible)", Default = CG0.Intensity or 10, Min = 0, Max = 100, Rounding = 0, Suffix = "%",
			Callback = function(Value)
				Library:SetCursorGlow({ Intensity = Value })
			end,
		})
		Box:AddSlider("GW_Smooth", {
			Text = "Kelembutan trail (ngikut cursor)", Default = CG0.Smooth or 5, Min = 1, Max = 30, Rounding = 0, Suffix = "/s",
			Callback = function(Value)
				Library:SetCursorGlow({ Smooth = Value })
			end,
		})

		Box:AddButton("Print resep glow", function()
			print("[N3V4 RESEP GLOW] paste ini balik:\n" .. BuildGlow())
		end)
		Box:AddButton("Copy resep glow", function()
			local Text = BuildGlow()
			if CopyClip(Text) then
				SafeNotify({ Title = "Resep glow", Description = "Copied ke clipboard.", Icon = "clipboard-check", Time = 3 })
			else
				print("[N3V4 RESEP GLOW]\n" .. Text)
				SafeNotify({ Title = "Resep glow", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
			end
		end)
	end)

	Try("Settings: glow presets", function()
		if type(Library.DividerAppearance) == "table" and type(Library.SetDividerTransparency) == "function" then
			local Box = T1:AddLeftGroupbox("Section Divider", "minus")
			Box:AddSlider("SD_LT", {
				Text = "Transparansi garis (outline)", Default = math.floor(Library.DividerAppearance.LineTransparency * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
				Callback = function(Value)
					Library:SetDividerTransparency(Value / 100, nil)
				end,
			})
			Box:AddDivider("Contoh garis")
			Box:AddButton("Print setingan divider", function()
				print(("[N3V4 DIVIDER] LineTransparency = %s | TextTransparency = %s"):format(Library.DividerAppearance.LineTransparency, Library.DividerAppearance.TextTransparency))
				SafeNotify({ Title = "Setingan divider", Description = "Cek Output.", Icon = "info", Time = 3 })
			end)
			Box:AddButton("Copy setingan divider", function()
				local Text = ("Library:SetDividerTransparency(%s, %s)"):format(Library.DividerAppearance.LineTransparency, Library.DividerAppearance.TextTransparency)
				if CopyClip(Text) then
					SafeNotify({ Title = "Setingan divider", Description = "Copied ke clipboard.", Icon = "copy", Time = 3 })
				else
					print("[N3V4 DIVIDER] paste ini balik:\n" .. Text)
					SafeNotify({ Title = "Setingan divider", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
				end
			end)

			local Box = T1:AddRightGroupbox("Section Text", "type")
			Box:AddSlider("SD_TT", {
				Text = "Transparansi text section", Default = math.floor(Library.DividerAppearance.TextTransparency * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
				Callback = function(Value)
					Library:SetDividerTransparency(nil, Value / 100)
				end,
			})
			Box:AddDivider("Contoh text")
			Box:AddButton("Print setingan divider", function()
				print(("[N3V4 DIVIDER] LineTransparency = %s | TextTransparency = %s"):format(Library.DividerAppearance.LineTransparency, Library.DividerAppearance.TextTransparency))
				SafeNotify({ Title = "Setingan divider", Description = "Cek Output.", Icon = "info", Time = 3 })
			end)
			Box:AddButton("Copy setingan divider", function()
				local Text = ("Library:SetDividerTransparency(%s, %s)"):format(Library.DividerAppearance.LineTransparency, Library.DividerAppearance.TextTransparency)
				if CopyClip(Text) then
					SafeNotify({ Title = "Setingan divider", Description = "Copied ke clipboard.", Icon = "copy", Time = 3 })
				else
					print("[N3V4 DIVIDER] paste ini balik:\n" .. Text)
					SafeNotify({ Title = "Setingan divider", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
				end
			end)
		else
			print("[N3V4 UI SETTINGS] Library yang ke-require MASIH VERSI LAMA (DividerAppearance / SetDividerTransparency ga ada, N3V4Version = " .. tostring(Library.N3V4Version) .. ") — paste ulang Library/N3V3-NoObfus.lua v4.12.8 biar box Section Divider + Section Text muncul")
		end

		local Box = T1:AddRightGroupbox("Preset Glow", "wand-sparkles")

		local function SyncKnobs()
			local G = Library.CursorGlow or {}
			pcall(function() Library.Options.GW_On:SetValue(G.Enabled ~= false) end)
			pcall(function() Library.Options.GW_Size:SetValue(tostring(G.Size)) end)
			pcall(function() Library.Options.GW_Int:SetValue(tostring(G.Intensity)) end)
			pcall(function() Library.Options.GW_Smooth:SetValue(tostring(G.Smooth)) end)
		end
		local function Preset(Name, Info)
			Box:AddButton(Name, function()
				Library:SetCursorGlow(Info)
				SyncKnobs()
				SafeNotify({ Title = "Cursor Glow", Description = "Preset: " .. Name, Icon = "sparkles", Time = 3 })
			end)
		end

		Preset("Samar (bawaan: 10%, 400px)", { Enabled = true, Intensity = 10, Size = 400, Smooth = 5 })
		Preset("Halus (5%, 260px)", { Enabled = true, Intensity = 5, Size = 260 })
		Preset("Jernih (25%, 320px)", { Enabled = true, Intensity = 25, Size = 320 })
		Preset("Matikan glow", { Enabled = false })
		Preset("Warna ikut accent lagi", { Color = false })
	end)

	Try("Settings: info", function()
		local Box = T1:AddRightGroupbox("Resep Tema", "copy")

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

		if type(Library.ButtonGradient) == "table" and type(Library.SetButtonGradient) == "function" then
			local function RGB(C)
				return math.floor(C.R * 255 + 0.5), math.floor(C.G * 255 + 0.5), math.floor(C.B * 255 + 0.5)
			end
			local function Dump()
				local G = Library.ButtonGradient
				local T1r, T1g, T1b = RGB(G.ColorTop)
				local T2r, T2g, T2b = RGB(G.ColorMiddle)
				local T3r, T3g, T3b = RGB(G.ColorBottom)
				return string.format("Library:SetButtonGradient({ Enabled = %s, Rotation = %s, MiddlePosition = %s, MiddleTransparency = %s, Offset = %s, ColorTop = Color3.fromRGB(%d, %d, %d), ColorMiddle = Color3.fromRGB(%d, %d, %d), ColorBottom = Color3.fromRGB(%d, %d, %d) })",
					tostring(G.Enabled), G.Rotation, G.MiddlePosition, G.MiddleTransparency, G.Offset,
					T1r, T1g, T1b, T2r, T2g, T2b, T3r, T3g, T3b)
			end

			local Box = T1:AddLeftGroupbox("Button Gradient", "sparkles")
			local TogGrad = Box:AddToggle("BG_ON", {
				Text = "Gradient 3D aktif", Default = Library.ButtonGradient.Enabled,
				Callback = function(Value)
					Library:SetButtonGradient({ Enabled = Value })
				end,
			})
			TogGrad:AddColorPicker("BG_C1", {
				Title = "Atas", Default = Library.ButtonGradient.ColorTop,
				Callback = function(Color)
					Library:SetButtonGradient({ ColorTop = Color })
				end,
			})
			TogGrad:AddColorPicker("BG_C2", {
				Title = "Tengah", Default = Library.ButtonGradient.ColorMiddle,
				Callback = function(Color)
					Library:SetButtonGradient({ ColorMiddle = Color })
				end,
			})
			TogGrad:AddColorPicker("BG_C3", {
				Title = "Bawah", Default = Library.ButtonGradient.ColorBottom,
				Callback = function(Color)
					Library:SetButtonGradient({ ColorBottom = Color })
				end,
			})
			Box:AddSlider("BG_ROT", {
				Text = "Rotasi gradient", Default = Library.ButtonGradient.Rotation, Min = -180, Max = 180, Rounding = 0, Suffix = "deg",
				Callback = function(Value)
					Library:SetButtonGradient({ Rotation = Value })
				end,
			})
			Box:AddSlider("BG_POS", {
				Text = "Posisi stop tengah", Default = math.floor(Library.ButtonGradient.MiddlePosition * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
				Callback = function(Value)
					Library:SetButtonGradient({ MiddlePosition = math.clamp(Value / 100, 0.02, 0.98) })
				end,
			})
			Box:AddSlider("BG_TR", {
				Text = "Transparansi tengah", Default = math.floor(Library.ButtonGradient.MiddleTransparency * 100 + 0.5), Min = 0, Max = 100, Rounding = 0, Suffix = "%",
				Callback = function(Value)
					Library:SetButtonGradient({ MiddleTransparency = Value / 100 })
				end,
			})
			Box:AddSlider("BG_OFF", {
				Text = "Offset gradient", Default = math.floor(Library.ButtonGradient.Offset * 100 + 0.5), Min = -100, Max = 100, Rounding = 0, Suffix = "%",
				Callback = function(Value)
					Library:SetButtonGradient({ Offset = Value / 100 })
				end,
			})

			local Box = T1:AddRightGroupbox("Sample Gradient", "copy")
			Box:AddButton("SAMPLE: button gradasi 3D", function()
				SafeNotify({ Title = "Button gradient", Description = "Button biasa + gradient 3 stop.", Icon = "info", Time = 3 })
			end)
			Box:AddButton("Print setingan gradient", function()
				local G = Library.ButtonGradient
				local T1r, T1g, T1b = RGB(G.ColorTop)
				local T2r, T2g, T2b = RGB(G.ColorMiddle)
				local T3r, T3g, T3b = RGB(G.ColorBottom)
				print(string.format("[N3V4 BUTTON GRADIENT] Enabled = %s | Rotation = %s | MiddlePosition = %s | MiddleTransparency = %s | Offset = %s | Top = %d,%d,%d | Middle = %d,%d,%d | Bottom = %d,%d,%d",
					tostring(G.Enabled), G.Rotation, G.MiddlePosition, G.MiddleTransparency, G.Offset,
					T1r, T1g, T1b, T2r, T2g, T2b, T3r, T3g, T3b))
				SafeNotify({ Title = "Button gradient", Description = "Cek Output.", Icon = "info", Time = 3 })
			end)
			Box:AddButton("Copy setingan gradient", function()
				local Text = Dump()
				if CopyClip(Text) then
					SafeNotify({ Title = "Button gradient", Description = "Copied ke clipboard.", Icon = "copy", Time = 3 })
				else
					print("[N3V4 BUTTON GRADIENT] paste ini balik:\n" .. Text)
					SafeNotify({ Title = "Button gradient", Description = "setclipboard ga ada — cek Output.", Icon = "copy", Time = 3 })
				end
			end)
		else
			print("[N3V4 UI SETTINGS] Library yang ke-require MASIH VERSI LAMA (ButtonGradient / SetButtonGradient ga ada, N3V4Version = " .. tostring(Library.N3V4Version) .. ") — paste ulang Library/N3V3-NoObfus.lua v4.14.1 biar box Button Gradient + Sample Gradient muncul")
		end

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
			pcall(function()
				Library:SetTabAppearance({
					IconCardEnabled = true,
					IconCardThickness = 1.5,
					IconCardTransparency = 0,
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
			pcall(function() CardTog:SetValue(true) end)
			pcall(function() ActiveTog:SetValue(true) end)
			pcall(function() Sl_CardT:SetValue(1.5) end)
			pcall(function() Sl_CardTr:SetValue(0) end)
			pcall(function() Sl_BgAll:SetValue(35) end)
			pcall(function() Sl_BgAct:SetValue(45) end)
			pcall(function() Sl_ZoomH:SetValue(125) end)
			pcall(function() Sl_ZoomA:SetValue(115) end)
			pcall(function()
				Library:Notify({ Title = "TEST tab", Description = "Nilai diset KELIATAN: card 1.5px pekat, bg 35%/45%, zoom 125%/115%. Sekarang hover tab sidebar!", Time = 4 })
			end)
		end)
		Box:AddButton("DEBUG: dump tab visuals", function()
			local TV = Library.TabVisuals or {}
			print(string.format("[N3V4 DEBUG TAB] rec=%d activeTab=%s", #TV, tostring(Library.ActiveTab ~= nil)))
			for I, Rec in ipairs(TV) do
				local Icon = Rec.Icon
				local Cd = Rec.Card
				local St = Cd and Cd:FindFirstChildOfClass("UIStroke")
				print(string.format(
					"  tab%d | icon size=%s z=%s | card=%s size=%s vis=%s | stroke transp=%s thick=%s | isActive=%s",
					I,
					tostring(Icon and Icon.Size), tostring(Icon and Icon.ZIndex),
					tostring(Cd and Cd.Name or "NIL"),
					tostring(Cd and Cd.Size), tostring(Cd and Cd.Visible),
					tostring(St and St.Transparency), tostring(St and St.Thickness),
					tostring(Rec.Tab ~= nil and Library.ActiveTab == Rec.Tab)
				))
				if I >= 4 then
					print("  ... (" .. (#TV - 4) .. " lagi)")
					break
				end
			end
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
				Library:SetCursorGlow(DEFAULTS.Glow)
				Library:SetIconAnim(DEFAULTS.IconAnim)
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

shared.N3V4_UISettings = Settings

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

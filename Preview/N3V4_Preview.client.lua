local LIB_URL = "https://raw.githubusercontent.com/YienYun/N3-Project/refs/heads/arena/c5a10c06-n3-project/Library/N3V3-NoObfus.lua"
local MOD_URL = "https://raw.githubusercontent.com/YienYun/N3-Project/refs/heads/arena/c5a10c06-n3-project/Preview/N3V4_UISettings.module.lua"

local Library = loadstring(game:HttpGet(LIB_URL))()

if typeof(Library) ~= "table" or typeof(Library.CreateWindow) ~= "function" then
	error("[N3V4 Preview] LIB dari URL bukan Library yang valid.", 0)
end

print(string.format("[N3V4 Preview] LIB v%s loaded dari URL git.", tostring(Library.N3V4Version)))

local Window = Library:CreateWindow({
	Title = "N3 HUB",
	Footer = "N3V4 • UI Preview Kit v4.42.0",
	Icon = "rbxassetid://117688744510818",
	AutoShow = true,
	Center = true,
	Resizable = true,
	ToggleKeybind = Enum.KeyCode.RightControl,
	Animations = {
		ToggleWindow = true,
		TabSwitch = true,
		Groupbox = true,
		Dropdown = true,
		KeyPicker = true,
		TabHoverZoom = true,
	},
})

local ApiTab = Window:AddTab("API", "book-open", "Tanda tangan API library")

local Box = ApiTab:AddLeftGroupbox("Window, Tab & Loading", "settings-2")
Box:AddLabel("Library:CreateWindow({ Title, Footer, Icon, AutoShow, Center, Resizable, ToggleKeybind, Animations })", true)
Box:AddLabel("Library:CreateLoading({ Title, Icon, TotalSteps, CurrentStep, ShowSidebar, AutoResizeHeight })", true)
Box:AddLabel("Loading:SetMessage · SetDescription · SetCurrentStep · SetTotalSteps · Destroy", true)
Box:AddLabel("Window:AddTab(Name, Icon, Description) · Window:Toggle(Force) · Window:Destroy()", true)
Box:AddLabel("Tab:AddLeftGroupbox(Title, Icon) · Tab:AddRightGroupbox(Title, Icon)", true)
Box:AddLabel("Library:Notify({ Title, Description, Icon, Time }) · Library:OnUnload(Callback)", true)

local Box = ApiTab:AddRightGroupbox("Komponen Groupbox", "list")
Box:AddLabel("Box:AddToggle(Idx, { Text, Default, Callback, Tooltip }) · Box:AddCheckbox(...)", true)
Box:AddLabel("Box:AddSlider(Idx, { Text, Default, Min, Max, Rounding, Suffix, Callback })", true)
Box:AddLabel("Box:AddDropdown(Idx, { Text, Values, Default, Multi, ItemIcons, Callback }) · Box:AddDropdownV(...)", true)
Box:AddLabel("Box:AddButton(Text, Callback) · Box:AddLabel(Text, Center) · Box:AddDivider(...)", true)
Box:AddLabel("Box:AddInput(Idx, { Text, Default, Callback }) · Box:AddKeyPicker(Idx, { Text, Default, Callback })", true)
Box:AddLabel("Box:AddColorPicker(Idx, { Text, Default, Callback })", true)
Box:AddLabel("Box:AddImage · AddVideo · AddScrollFeed · AddDependencyBox · AddDependencyGroupbox · AddUIPassthrough", true)

local PanelTab = Window:AddTab("Panel", "layout-dashboard", "API panel item in-game")

local Box = PanelTab:AddLeftGroupbox("Panel API", "package")
Box:AddLabel("Library:CreatePanel({ Title, Width, Height, HeaderButton }) · Library.Panels", true)
Box:AddLabel("Panel:AddTab(Name, Icon) · Panel:AddChip(Label, { Default, Callback })", true)
Box:AddLabel("Panel:SetHeaderButton(Text, Callback) · Panel:SetTab(Tab) · Panel:SetVisible(On)", true)
Box:AddLabel("Panel:Toggle() · Panel:Restyle() · Panel:Destroy()", true)
Box:AddLabel("PanelTab:AddItem({ Image, Icon, Text, TextColor, Subtext, SubtextColor, Meta, MetaColor, GlowColor, ButtonText, ButtonColor, IconButton, IconButtonCallback, Callback })", true)
Box:AddLabel("PanelTab:Clear()", true)

local Box = PanelTab:AddRightGroupbox("Handle AddItem & Resep", "refresh-cw")
Box:AddLabel("local Handle = PanelTab:AddItem({ ... })", true)
Box:AddLabel("Handle.Row · Handle:SetText(Value) · Handle:SetSubtext(Value)", true)
Box:AddLabel("Handle:SetMeta(Value) — nil atau kosong = meta sembunyi", true)
Box:AddLabel("Handle:SetGlow(Color3) · Handle:SetTextColor(Color3) — restart pulse", true)
Box:AddLabel("Handle:Destroy() — batal pulse + hapus record", true)
Box:AddLabel("Library:SetPanelStyle({ ... }) · Library.PanelStyle · Library.PanelRarity", true)

local OverlayTab = Window:AddTab("Overlay", "layers", "Menu, dashboard & permukaan")

local Box = OverlayTab:AddLeftGroupbox("Menu, Overlay & Dashboard", "menu")
Box:AddLabel("Library:AddDraggableMenu · AddDraggableButton · AddDraggableLabel · AddDraggableImageButton", true)
Box:AddLabel("Library:AddContextMenu({ ... }) · Library:CreateOverlay({ ... })", true)
Box:AddLabel("Library:CreateDashboard({ ... }) · Library:SetDashboardStyle({ ... })", true)
Box:AddLabel("Library:AddOutline · AddOutlineSpin({ Preset, ... }) · Library.StrokeStyles", true)
Box:AddLabel("Library:SetCardGradient({ Enabled, Preset, Rotation, OffsetSpeed, RotationSpeed, ColorTop, ColorMiddle, ColorBottom })", true)
Box:AddLabel("Library:SampleCardGradient(Preset) → ColorTop, ColorMiddle, ColorBottom", true)

local Box = OverlayTab:AddRightGroupbox("Ikon (URL git) & Media", "image")
Box:AddLabel("Icon = nama lucide (zap, droplets, sparkles, ...) — di-fetch dari URL lucide-roblox-direct", true)
Box:AddLabel("Icon = rbxassetid:// · rbxthumb:// · content:// · URL kustom = langsung pakai", true)
Box:AddLabel("Library:GetIcon(Name) → { Url, Id, ImageRectOffset, ImageRectSize }", true)
Box:AddLabel("Library:GetCustomIcon(NameOrUrl) — asset kustom dulu, baru lucide", true)
Box:AddLabel("Library:SetIconModule(Module) — ganti sumber ikon runtime", true)
Box:AddLabel("Box:AddViewport(Idx, { Object = model, Camera, Interactive, AutoFocus }) — wajib Object", true)

local OkSettings, SettingsModule = pcall(function()
	return loadstring(game:HttpGet(MOD_URL))()
end)

if OkSettings and typeof(SettingsModule) == "table" and typeof(SettingsModule.Attach) == "function" then
	SettingsModule:Attach(Library, Window)
else
	print("[N3V4 Preview] MOD settings gagal di-fetch dari URL — knob settings ga muncul.")
end

print("[N3V4 Preview] v4.42.0 siap | LIB standalone satu file | ikon via URL git | nol replica")

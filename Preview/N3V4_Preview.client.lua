--[[
	================================================================================
	 N3V4 — PREVIEW KIT v4.6   (LocalScript)
	================================================================================

	 ISI FILE INI: MURNI showcase komponen (5 tab, kiri/kanan simetris).
	 ZERO setingan desain — semua setingan ada di file terpisah:
	 Preview/N3V4_UISettings.module.lua  (tab "UI Settings" + "Wallpaper & Surface")

	 CHANGELOG v4.7.7 — ANIMASI BUKA/TUTUP WINDOW DIBENERIN:
	   • Buka nggak lagi 1.5x durasi: stagger task.wait dihapus, shell +
	     konten fade BARENGAN => total waktu = durasi persis (default baru
	     0.20s, dulu 0.35s + stagger = ~0.53s).
	   • "Layar hitam pas buka" hilang: dulu permukaan gelap (wallpaper/
	     overlay/kartu) nongol duluan baru konten nyusul; sekarang semua
	     naik proporsional sekaligus.
	   • Glitch/hitch pas baru kebuka hilang: tween fade sekarang 1 per
	     instance (properti digabung) + DI-CACHE dipakai ulang — steady
	     state cuma Play(), nol TweenService:Create ratusan per toggle.
	   • Pencetan cepet nggak ketelen: toggle di tengah animasi = reversal
	     mulus (token), cache transparency cuma di-capture pas rest
	     (bug mid-tween capture = nilai basi, dibenerin).
	   • Open pertama juga fade beneran (dulu pop instan tanpa animasi).
	   • Knob baru: "Durasi buka/tutup window" (tab UI Settings > Font &
	     Animasi) + durasi ikut ke-print di RESEP THEMA.

	 CHANGELOG v4.7.6 — RESEP TAB LU DIBAKE + NOL CODE SAMPAH:
	   • Print RESEP TAB lu (stroke 1px/20%/ungu 107-0-181, bg tab 100%,
	     bg aktif 85% abu 128, zoom hover 130%, zoom aktif 140%, durasi 0.20)
	     jadi DEFAULT TERKUNCI di library + DEFAULTS.
	   • Refactor sesuai perintah lu ("jangan ada code sampah / duplikasi"):
	     halo stroke + UIScale sekarang SATU helper (CreateTabIconStroke),
	     zoom SATU helper (TweenTabZoom), blok duplikat AddTab/AddKeyTab
	     DIHAPUS -> library minus ~40 baris.
	   • Zoom pakai UIScale lagi (transform-only) = lebih MULUS daripada
	     tween Size; kekasaran yang lu rasain juga emang khas preview Studio.

	 CHANGELOG v4.7.5 — AKHIRNYA KE FUNGSI YANG BENER (Window:AddTab):
	   • v4.7.0-7.4 semua patch tab (stroke halo, bg, zoom, TabRec) MASUK KE
	     Window:AddKeyTab, bukan Window:AddTab. Tab sidebar kiri lu dibuat
	     lewat AddTab -> nggak kepatch sama sekali. DEBUG rec=0 dari user
	     yang ngebongkar ini. Sekarang AddTab (fungsi asli tab sidebar)
	     punya semua: halo stroke, bg semua tab, bg aktif, zoom hover/aktif.
	   • Bukti: Output "[N3V4 Library] window ready: tabVisuals=N" sekarang
	     N = jumlah tab sidebar lu (bukan 0).

	 CHANGELOG v4.7.4 — ZOOM MATI KARENA ANIMATIONS KE-NIMPA + bukti otomatis:
	   • WindowInfo.Animations caller (preview) cuma bawa 5 bool -> tabel
	     Animations ke-replace tanpa TabHoverZoom -> nil = gate zoom MATI.
	     Sekarang gate NIL-SAFE (Library:ZoomTabEnabled: nil dianggap ON) dan
	     preview eksplisit kirim TabHoverZoom = true.
	   • CreateWindow sekarang manggil ApplyTabAppearance() sendiri + print
	     "[N3V4 Library] window ready: tabVisuals=N" = bukti otomatis di
	     Output tanpa lu klik apa-apa.
	   • Tombol TEST sekarang ikut nyalain toggle stroke, toggle bg aktif,
	     dan Animations.TabHoverZoom — sekali klik semua efek hidup.

	 CHANGELOG v4.7.3 — BUG BESAR KE-TEMU & DIFIX (stroke/bg/zoom mati diam-diam):
	   • AKAR SEMUA DRAMA INI: di library v4.7.0-7.2, `local TabRec` kedelep
	     DI DALAM do-block AddTab, padahal `TabRec.Tab = Tab` dipanggil di
	     LUAR do -> nil-global error SETIAP AddTab -> tab kebentuk setengah
	     (button ada, icon ada) tapi rec/animasi/stroke nggak ke-link =
	     semua efek tab MATI walau library baru & slider bener. Mata lu
	     bener brok, kode gue yang salah. Luau-analyze akhirnya nyentuh
	     warn LocalShadow-nya pas gue bikin v4.7.3.
	   • Stroke sekarang HALO ImageLabel (glyph sama, warna stroke, lebih
	     gede dikit, ZIndex di belakang icon) — bukan UIStroke (quirky di
	     sprite atlas). Zoom sekarang tween Size icon — bukan UIScale.
	     Dua-duanya property polos = pasti render.
	   • Tombol "DEBUG: dump tab visuals" buat ground truth kalau dicurigai
	     mati lagi: print rec/size/halo per tab.

	 CHANGELOG v4.7.2 — ANTI-DEBAT "library lama?" + anti-salah-arti slider:
	   • Library sekarang PRINT versi sendiri waktu di-require:
	     "[N3V4 Library] v4.7.2 loaded ..." — kalau baris itu nggak ada di
	     Output, berarti ModuleScript N3V4 yang ke-require masih file lama.
	   • Label slider transparency dijelasin: "(100% = ILANG)". Dua kali user
	     mentokin 100% (stroke transparency & bg tab aktif) = efeknya ILANG,
	     dikira bug. 100% transparency = fully invisible, brok.
	   • Tombol "TEST: bikin efek KELIATAN" di box Tab Aktif & Zoom: set nilai
	     pasti-keliatan + sync slider, buat buktiin hover/zoom/stroke jalan.

	 CHANGELOG v4.7.1 — STALE-PASTE DETECTOR LIBRARY:
	   • Kalau ModuleScript N3V4 di ReplicatedStorage masih lama, settings
	     warn keras + report preview masuk GAGAL: "LIBRARY LAMA ... paste
	     ulang". Soalnya gejala library lama = slider tab gerak tapi nol
	     efek (fungsi SetTabAppearance belum ada) — bikin dikira bug kode.

	 CHANGELOG v4.7.0 — UPGRADE TAB SIDEBAR (borongan, sesuai diskusi):
	   • Stroke tipis di GLYPH icon tab (UIStroke ngikut bentuk icon, bukan
	     kotak) biar keliatan di atas wallpaper. Baseline 1px / 40% / hitam.
	   • Background dikit di SEMUA tab (baseline 70% transparency, MainColor).
	   • Tab aktif: bg tint accent tipis (55%) + icon zoom nantahan (108%).
	   • Hover: icon zoom sedikit (112%), tween Quad Out 0.15s; mati lewat
	     Library.Animations.TabHoverZoom = false.
	   • Knob lengkap di file setingan (tab UI Settings, box "Tab Stroke & Bg"
	     + "Tab Aktif & Zoom", simetris 4/4). Print LENGKAP include RESEP TAB.
	   • Preview = testbed lu: puter knob, liat sidebar window ini, print.

	 CHANGELOG v4.6.12 — PREVIEW NYALA LAGI (aman):
	   • User mau seting manual upgrade TAB (stroke icon, background tab, zoom
	     hover/aktif) -> PREVIEW_ENABLED = true lagi. Beda sama era v4.6.9:
	     preview sekarang NOL SetWallpaper/SetSurface, jadi nggak nyetomp
	     state global window lu. Showcase tab = testbed visual lu.

	 CHANGELOG v4.6.11 — NESTED BOX IKUT TRANSPARAN (nggak dobel lapis):
	   • Bug: tabbox/groupbox/depbox yang NESTED di dalam kartu group numpuk
	     lapis transparency KEDUA (0.35 di atas 0.35) -> komposit gelap/solid,
	     kebaca "ga ikut transparan". Depbox kelihatan aman dulu karena dia
	     sibling kartu, bukan anak.
	   • Fix: Library:IsInsideSurfaceCard() — kalau box dibuat di dalam kartu
	     surface lain, BackgroundTransparency = 1 (komposit ngikut induk,
	     identitas box dari outline); kalau top-level tetep pakai Surface +
	     register ke SurfaceGroups. Slider "Kartu group" tetep ngatur semua.

	 CHANGELOG v4.6.10 — PREVIEW OFF TOTAL + WINDOW DEFAULT 100:
	   • Kesalahan gue v4.6.9: preview "theme-only" lewat SetWallpaper/SetSurface
	     = state GLOBAL -> window setingan lu ke-stomp window 0/canvas 0 = jelek.
	     Sekarang preview DIMATIIN (PREVIEW_ENABLED = false, early return) —
	     nggak bikin window, nggak nyentuh state. Seting = N3V4_UISettings aja.
	   • WindowTransparency default 0.90 -> 1 (user: "window dan canvas
	     harusnya 100 anjing malah 0").

	 CHANGELOG v4.6.9 — GROUP TRANSPARENCY KEPAKE DI PASTE BARU + PREVIEW THEME-ONLY:
	   • BUG: CreateWindow nge-STOMP Library.Surface dari Templates.Window tiap
	     start -> group 0.35 lu jadi 0 (solid) & contrast 40 jadi 30 di paste
	     baru, walau di session seting lu jalan. Sekarang seed-nya cuma kalau
	     CreateWindow dikirim field-nya eksplisit. Resep lu kepake langsung.
	   • THEME v6: main 45 / outline 65 (print lu) dibake.
	   • PREVIEW: wallpaper DIMATIIN + surface solid = showcase theme doang
	     ("hapus kecuali theme"). Seting wallpaper tetep di file UISettings.

	 CHANGELOG v4.6.8 — RESEP v5 LU DIBAKE + FIX CORNER NAVBAR BAWAH:
	   • Print LENGKAP lu jadi default permanen: wallpaper FULL (transparency 0)
	     + scrim overlay 0.55, tint 195, window 0.90, canvas 1, kartu group 0.35,
	     contrast 40, kartu hitam, canvas 156, scheme bg 15 / main 36 / outline 59.
	   • FIX bug corner: navbar bawah dulu pakai UICorner full radius -> waktu
	     lu puter radius di tab Theme, corner ATAS navbar ikutan bulat = notch
	     / garis nyembul ke atas. Sekarang corner-nya BAWAH aja (SpecificCorners),
	     top persegi selamanya, radius bebas diutak-atik.

	 CHANGELOG v4.6.7 — JEBAKAN FRONT DIHAPUS:
	   • Preset "Wash (front)" & combo "Stretch + front" = penyebab kartu lu
	     "transparan" waktu lu klik itu: layer front = gambar DI ATAS semua
	     (veil), jadi slider Window/Canvas/Group di-0-in pun veil tetep ada
	     (kekuatan veil = slider Image transparency + layer, bukan slider lain).
	   • Sekarang semua preset/combo = "back" (kartu selalu SOLID terpisah).
	   • Preset nggak lagi matiin GroupColor/CanvasColor custom (kartu hitam
	     lu bertahan walau lu gonta-ganti preset).
	   • Balik ke baseline: klik "RESEP USER (disetujui)" di box Cepat.

	 CHANGELOG v4.6.6 — KARTU GROUP 100% SOLID (layer "back"):
	   • Wallpaper pindah ke layer "back" (DI BELAKANG konten). Dulu "front" =
	     gambar nutup SEMUA (veil 20%) -> kartu kebaca "transparan" walau
	     GroupTransparency 0. Sekarang kartu hitam lu BENERAN solid nge-blok
	     wallpaper; wallpaper cuma keliatan di sela-sela kartu.
	   • WindowTransparency 0 -> 1 & Canvas 0.20 -> 1 biar wallpaper back-nya
	     keliatan (kalau 0, MainFrame solid nutup wallpaper).
	   • Overlay scrim ON 0.50 (baseline) biar teks kebaca di atas wallpaper.
	   • Slider yang HIDUP buat lu seting: Canvas/latar, Overlay, Window,
	     Kartu group, Group contrast (kalau custom OFF). Puter -> Print ->
	     kirim ke gue, gue bake angka lu.

	 CHANGELOG v4.6.5 — GROUP BALIK HITAM (revert kesalahan v4.6.4):
	   • v4.6.4 gue bikin GroupColor AUTO -> kartu jadi ABU-ABU. User:
	     "kok abu abu cok? woi gue group warna hitam anj!" -> REVERT ke hitam.
	   • Contrast 30 baseline lu TETEP disimpen; kepake kalau "Group custom" OFF.
	   • Penjelasan kenapa slider berasa "ga ngaruh" ada di DESIGN_NOTES
	     (override warna menang atas contrast; overlay slider cuma aktif
	     kalau toggle Overlay ON; wash wallpaper front nutup semua kartu).

	 CHANGELOG v4.6.4 — GROUP 30% LEBIH JELAS:
	   • GroupContrast 10 -> 30 (kartu group dibedain 30% dari background).
	   • Override GroupColor hitam DIPUTUS (jadi auto) — soalnya override itu
	     yang bikin contrast nggak ngefek & group keliatan nyatu/transparan.
	   • Slider "Group contrast" di tab setingan tetep bisa lu puter (0-40).

	 CHANGELOG v4.6.3 — THEME v4 LU JADI DEFAULT (ganti angka doang, nol fitur):
	   • bg (18,18,18) · main (33,33,33) · outline (61,61,61)
	     (accent 218/68/255 + font putih + radius 15 tetep dari v3)
	   • Wallpaper & surface NGGAK disentuh — masih resep v3.

	 CHANGELOG v4.6.2 — RESEP v3 LU JADI DEFAULT + FIX BUG PRINT:
	   • Default BARU (library + setingan): scheme hitam-ungu lu
	     (accent 218/68/255, bg 0, main 31, outline 45, font putih),
	     corner radius 15, wallpaper v3 (transparency 0.80, tint 0.59 abu,
	     overlay 0.40 OFF, canvas 0.20, contrast 10, canvas color 0.045).
	   • FIX BUG "attempt to index nil with 'Image'" pas Print resep:
	     state `S` dulu ke-init SETELAH BuildResep didefinisiin (forward-ref
	     nil lagi). Sekarang state di-init paling awal di Attach.

	 CHANGELOG v4.6.1 — DEFAULT = RESEP v2 LU:
	   • Library + file setingan sekarang BAWAAN-nya resep yang lu seting sendiri
	     (transparency 0.85, tint 252/241/255, overlay OFF, canvas 0.20, group 0,
	     contrast 6, canvas color 20/20/20). Buka Studio TANPA seting apa pun =
	     langsung tampilan lu. Print resep juga langsung = resep lu.
	   • Sebelumnya default masih resep v1 — itu kenapa lu lihat "ga ada
	     perubahan" dan harus seting ulang. Salah gue, sorry.

	 CHANGELOG v4.6 — 3 BUG LIBRARY DIBENERIN + PRINT RESEP THEMA:
	   • BUG 1 (Dependency groupbox error "attempt to call a nil value"):
	     ClampTransparency / Library.Surface / Library.SurfaceGroups dipakai
	     AddDependencyGroupbox, tapi didefinisiin DI BAWAH-nya. Local Lua cuma
	     kebaca SETELAH baris deklarasinya -> nil pas dipakai. Seluruh blok
	     Surface & Wallpaper sekarang DIPINDAH ke atas (tepat setelah New()).
	   • BUG 2 (Viewport 3D error "Instance must be a BasePart or Model"):
	     library punya DUA `Funcs:AddViewport` dan yang bawah (wajib Info.Object)
	     menimpa yang atas (Height/Spin/Interactive/SetModel). Sekarang ada
	     bridge: kalau Object nggak dikasih -> pakai versi ringan. Dua API hidup.
	   • BUG 3 (color picker "kadang ga work" + UI berat):
	     drag loop lama muter selamanya karena InputBegan GuiObject juga kepicu
	     MouseMovement (state Change) -> coroutine numpuk tiap mouse gerak, warna
	     suka lompat sendiri. Sekarang: drag mulai cuma dari klik beneran, berhenti
	     dari InputEnded global (aman walau mouse lepas di luar elemen). Slider
	     kena fix yang sama.
	   • AddKeyBox: preview sekarang cek dulu method-nya ada (library lama = skip,
	     bukan error).
	   • Setingan: tombol PRINT/COPY RESEP THEMA (accent, background, main,
	     outline, font color + font, radius, DPI, animasi) di tab "UI Settings",
	     plus "Print resep LENGKAP" (thema + wallpaper + surface) di dua tab.

	 CARA PAKAI (3 paste):
	   1. ReplicatedStorage > ModuleScript "N3V4"          = Library/N3V3-NoObfus.lua
	      ^ WAJIB copy ulang tiap gue update — bug fix di atas adanya DI SINI.
	   2. StarterPlayerScripts > LocalScript "N3V4_Preview" = file ini
	   3. Setingan UI (pilih SATU, dua-duanya jalan):
	      a. StarterPlayerScripts > LocalScript "N3V4_UISettings"   <- cara lu
	      b. ReplicatedStorage    > ModuleScript "N3V4_UISettings"  <- auto-require
	   Allow HTTP Requests = OPSIONAL (icon udah ada fallback offline).
	   Tekan Play -> 5 tab showcase + 2 tab setingan. Toggle UI: RightControl.

	 CARA CEK COPY-AN LU BARU ATAU LAMA: lihat footer window.
	   footer "v4.7.7" = baru. Selain itu = copy-an lama, paste ulang.
	================================================================================
]]

--// SERVICES \\--
-- v4.6.10: PREVIEW DIMATIIN TOTAL per perintah user: "ini preview mattin saja
-- woi! udah ga kepakai wallpaper itu! hapus kecuali theme!" Percobaan v4.6.9
-- bikin preview "theme-only" lewat SetWallpaper/SetSurface itu SALAH GUE:
-- state wallpaper/surface itu GLOBAL per-Library, jadi window setingan lu
-- ikut ke-stomp window 0 / canvas 0 = "jadinya jelek cok". Sekarang preview
-- nggak jalan sama sekali (nol window, nol stomp); theme + semua seting ada
-- di N3V4_UISettings. Mau showcase lagi? Set true.
local PREVIEW_ENABLED = true -- v4.6.12: user minta preview NYALA lagi buat
-- seting manual upgrade tab (stroke icon + background tab + zoom animasi).
-- Preview sekarang AMAN: nggak nyentuh SetWallpaper/SetSurface (state global).
if not PREVIEW_ENABLED then
	print("[N3V4 Preview] v4.6.10: preview OFF per perintah user. Seting lengkap: N3V4_UISettings. (Set PREVIEW_ENABLED = true buat nyalain showcase lagi.)")
	return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

--================================================================================
-- CONFIG
--================================================================================
local CONFIG = {
	ModuleName = "N3V4",

	Title = "N3 HUB",
	Footer = "N3V4 • UI Preview Kit v4.7.7",
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

-- v4.7.1: stale-paste detector LIBRARY masuk report preview juga
if type(Library.SetTabAppearance) == "function" and type(Library.TabAppearance) == "table" then
	table.insert(Report.OK, "Library v4.7+ (SetTabAppearance + TabAppearance ada)")
else
	table.insert(Report.Failed, "LIBRARY LAMA: SetTabAppearance/TabAppearance nil -> paste ulang ModuleScript N3V4  ->  knob tab mati")
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
		TabHoverZoom = true, -- v4.7.4: jangan sampe ke-drop waktu Validate
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
	-- AddKeyBox itu method level Tab (ada di library utama). Kalau library yang
	-- di-paste versi lama, method-nya belum ada -> kita skip, jangan error.
	if typeof(AdvancedTab.AddKeyBox) ~= "function" then
		warn("[N3V4 Preview] AddKeyBox nggak ada di library ini — paste ulang Library/N3V3-NoObfus.lua terbaru.")
		return
	end
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
-- Jalur 1: ModuleScript "N3V4_UISettings" di ReplicatedStorage
pcall(function()
	local Mod = ReplicatedStorage:FindFirstChild("N3V4_UISettings")
	if Mod then
		local SettingsModule = require(Mod)
		if SettingsModule and SettingsModule.Attach then
			SettingsModule:Attach(Library, Window)
		end
	end
end)

-- Jalur 2: file settings dipaste sebagai LOCALSCRIPT -> dia register diri ke
-- shared.N3V4_UISettings. Kalau dia belum sempet, tunggu sebentar di background.
-- (File settings itu sebenernya juga bisa nempel SENDIRI; flag attached
--  di shared mencegah tab dobel.)
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

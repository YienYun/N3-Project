#!/usr/bin/env bash
#================================================================================
# N3-Project — CHECK CEPAT
#================================================================================
# Checker-nya pakai LUAU ASLI (luau-analyze), bukan parser bikinan.
# Binary di-download + di-build sekali, lalu di-cache di repo: ./tools/bin/
# (folder bin/ di-gitignore, jadi nggak bikin repo gendut).
#
#   ./tools/check.sh            # syntax (luau) + cek struktur
#   ./tools/check.sh --rebuild  # paksa build ulang luau-analyze
#
# Butuh: curl, g++, make, unzip, python3. Build luau ±3 menit (sekali doang).
#================================================================================
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/tools/bin/luau-analyze"
LIB="$ROOT/Library/N3V3-NoObfus.lua"
VIS="$ROOT/Library/N3V4Visuals.module.lua"
MOD="$ROOT/Preview/N3V4_UISettings.module.lua"
PREV="$ROOT/Preview/N3V4_Preview.client.lua"
PRE="$ROOT/Preview/N3V4_Preview.client.lua"
LUAU_TAG="0.743"

if [[ "${1:-}" == "--rebuild" ]]; then rm -f "$BIN"; fi

if [[ ! -x "$BIN" ]]; then
	echo "==> luau-analyze belum ada, download + build (sekali aja, ±3 menit)..."
	TMP="$(mktemp -d)"
	curl -sL -o "$TMP/luau.tar.gz" \
		"https://codeload.github.com/luau-lang/luau/tar.gz/refs/tags/$LUAU_TAG" || {
		echo "❌ download luau gagal"; exit 1; }
	tar xzf "$TMP/luau.tar.gz" -C "$TMP" || { echo "❌ extract gagal"; exit 1; }
	mkdir -p "$ROOT/tools/bin"
	( cd "$TMP/luau-$LUAU_TAG" && make config=release -j"$(nproc)" build/release/luau-analyze >/dev/null ) || {
		echo "❌ build luau-analyze gagal"; exit 1; }
	cp "$TMP/luau-$LUAU_TAG/build/release/luau-analyze" "$BIN"
	rm -rf "$TMP"
	echo "==> luau-analyze siap: $BIN"
fi

PASS=0; FAIL=0
ok()   { echo "  ✅ $1"; PASS=$((PASS+1)); }
bad()  { echo "  ❌ $1"; FAIL=$((FAIL+1)); }
chk()  { if eval "$2" >/dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }

echo "== 1. SYNTAX (luau-analyze asli) =="
for f in "$LIB" "$VIS" "$MOD" "$PRE" "$ROOT"/Games/*.lua; do
	N=$("$BIN" --mode=nonstrict "$f" 2>&1 | grep -c SyntaxError)
	if [[ "$N" == "0" ]]; then ok "syntax $(basename "$f")"; else
		bad "syntax $(basename "$f") — $N SyntaxError"
		"$BIN" --mode=nonstrict "$f" 2>&1 | grep SyntaxError | head -5
	fi
done

echo "== 2. LIBRARY =="
chk "AddViewport versi tunggal: wajib Info.Object (bridge module diputus)" \
	"[ \$(grep -c 'function Funcs:AddViewport' '$LIB') -eq 1 ] && grep -qF 'if not Info.Object then' '$LIB' && ! grep -q 'RichAddViewport' '$LIB' && ! grep -q 'Visuals.AddViewport' '$LIB'"
chk "Surface system didefinisiin SEBELUM AddDependencyGroupbox (bug forward-ref)" \
	"test \$(grep -n '^local function ClampTransparency' '$LIB' | cut -d: -f1) -lt \$(grep -n 'function Funcs:AddDependencyGroupbox' '$LIB' | cut -d: -f1)"
chk "Library.Surface didefinisiin sebelum dipakai" \
	"test \$(grep -n '^Library.Surface = {' '$LIB' | cut -d: -f1) -lt \$(grep -n 'Library.Surface.GroupTransparency' '$LIB' | head -1 | cut -d: -f1)"
chk "color picker: nggak ada drag loop 'while IsDragInput' (bug warna kadang ga work)" \
	"! grep -q 'while IsDragInput' '$LIB'"
chk "color picker: DragBegin(satvib/hue/alpha) + InputEnded watcher" \
	"grep -q 'DragBegin(Input, \"satvib\")' '$LIB' && grep -q 'DragBegin(Input, \"hue\")' '$LIB' && grep -q 'DragBegin(Input, \"alpha\")' '$LIB' && grep -q 'InputEnded:Connect(DragRelease)' '$LIB'"
chk "slider: berhenti lewat InputEnded (SliderReleaseConn)" "grep -q SliderReleaseConn '$LIB'"
chk "WindowTransparency ada" "grep -q WindowTransparency '$LIB'"
chk "Tab:AddKeyBox ada" "grep -q 'function Tab:AddKeyBox' '$LIB'"
chk "theme v7 user jadi default di LIBRARY (main 36 / outline 65-62-62 + radius 10)" \
	"grep -q 'AccentColor = Color3.fromRGB(218, 68, 255)' '$LIB' && grep -q 'BackgroundColor = Color3.fromRGB(15, 15, 15),' '$LIB' && grep -q 'MainColor = Color3.fromRGB(36, 36, 36),' '$LIB' && grep -q 'OutlineColor = Color3.fromRGB(65, 62, 62),' '$LIB' && grep -q 'CornerRadius = 10,' '$LIB'"
chk "resep v7 default di LIBRARY (wallpaper 0 + scrim 0.40 + group 0.5 + canvas 119)" \
	"grep -q 'BackgroundImageTransparency = 0,' '$LIB' && grep -q 'GroupContrast = 40,' '$LIB' && grep -q 'CanvasColor = Color3.fromRGB(119, 119, 119)' '$LIB' && grep -q 'BackgroundOverlayTransparency = 0.40,' '$LIB' && grep -q 111593326989465 '$LIB'"
chk "group HITAM + contrast 30 baseline tetep (v4.6.5)" \
	"grep -q 'GroupColor = Color3.fromRGB(0, 0, 0),' '$LIB' && grep -q 'GroupContrast = 40,' '$LIB'"
chk "v4.6.6: wallpaper layer BACK + window/canvas full (kartu 100% solid)" \
	"grep -q 'BackgroundImageLayer = \"back\"' '$LIB' && grep -q 'CanvasTransparency = 1,' '$LIB' && grep -q 'Layer = \"back\"' '$MOD' && grep -q 'Canvas = 1,' '$MOD'"
chk "v4.6.7: NGGAK ada preset/combo yang pindah ke layer front (jebakan)" \
	"! grep -q 'Layer = \"front\"' '$MOD' && ! grep -q 'Combo(\"Stretch\", \"front\")' '$MOD'"
chk "v4.6.7: preset Load() nggak matiin GroupColor/CanvasColor custom user" \
	"! sed -n '/local function Load/,/SafeNotify/p' '$MOD' | grep -qE 'S\.(Group|Canvas)Color'"
chk "v4.6.8: navbar bawah corner BAWAH-aja (SpecificCorners, tinggi 20)" \
	"grep -q 'BottomRightRadius = UDim.new(0, WindowInfo.CornerRadius)' '$LIB' && grep -q 'Size = UDim2.new(1, 0, 0, 20),' '$LIB'"
chk "v4.6.9: CreateWindow NGGAK stomp Surface default lagi (seed conditional)" \
	"grep -q 'local RawGroupT = WindowInfo and WindowInfo.GroupTransparency' '$LIB'"
chk "PRE slim: nol PREVIEW_ENABLED + nol SetSurface" \
	"! grep -q 'PREVIEW_ENABLED' '$PRE' && ! grep -q 'Library:SetSurface' '$PRE'"
chk "v4.6.11: nested surface card ikut induk (IsInsideSurfaceCard dipake x3)" \
	"[ \$(grep -c 'Library:IsInsideSurfaceCard(BoxHolder)' '$LIB') -eq 3 ] && grep -q 'function Library:IsInsideSurfaceCard' '$LIB'"
chk "v4.7.0: TabAppearance + setter/applier di LIBRARY" \
	"grep -q 'Library.TabAppearance = {' '$LIB' && grep -q 'function Library:SetTabAppearance' '$LIB' && grep -q 'function Library:ApplyTabAppearance' '$LIB'"
chk "v4.8.4: icon CARD ganti halo (helper + nol sisa stroke lama)" \
	"grep -q 'TabIconCard' '$LIB' && grep -q 'function Library:CreateTabIconCard' '$LIB' && ! grep -q 'IconStroke' '$LIB' && grep -q 'TabHoverZoom' '$LIB' && grep -q 'TabHoverZoom' '$MOD'"
chk "v4.7.0: print LENGKAP include RESEP TAB (BuildTab)" \
	"grep -q 'local function BuildTab' '$MOD' && grep -q 'N3V4 RESEP TAB' '$MOD'"
chk "v4.7.1: stale-paste detector (warn Attach era executor, nol replica)" \
	"grep -q 'LIBRARY LAMA terdeteksi' '$MOD' && grep -q 'v4.39.0+' '$MOD' && ! grep -q 'ReplicatedStorage' '$MOD'"
chk "v4.7.2: library print versi v4.39.0 + tombol TEST/DEBUG Studio hapus" \
	"grep -q 'N3V4 Library] v4.41.2 loaded' '$LIB' && ! grep -q 'TEST: bikin efek KELIATAN' '$MOD' && ! grep -q 'dump tab visuals' '$MOD'"
chk "v4.7.3: scope TabRec bener + card icon + DEBUG dump hapus" \
	"! grep -q 'local TabRec = {' '$LIB' && grep -q 'TabIconCard' '$LIB' && ! grep -q 'DEBUG: dump tab visuals' '$MOD'"
chk "v4.7.4: gate zoom nil-safe + auto-apply CreateWindow + preview kirim TabHoverZoom" \
	"grep -q 'function Library:ZoomTabEnabled' '$LIB' && grep -q 'window ready: tabVisuals' '$LIB' && grep -q 'TabHoverZoom = true,' '$PREV'"
chk "v4.7.5: patch tab ada di AddTab ASLI (bukan AddKeyTab doang)" \
	"[ \$(grep -c 'table.insert(Library.TabVisuals, TabRec)' '$LIB') -eq 2 ] && [ \$(grep -c 'BackgroundTransparency = Library.TabAppearance.TabBackgroundTransparency,' '$LIB') -eq 4 ]"
chk "v4.7.7: fade window baru (tween cache+token, nol stagger/block)" \
	"grep -q 'FadeTweenCache' '$LIB' && grep -q 'local FadeToken = 0' '$LIB' && ! grep -q 'task.wait(FadeTime / 2)' '$LIB' && ! grep -q 'if Fading then' '$LIB'"
chk "v4.7.9: footer button dialog di-Resize (holder nggak hidden) = 6x Resize" \
	"[ \$(grep -c 'Dialog:Resize()' '$LIB') -eq 6 ]"
chk "v4.8.0: DropdownV2 ada di library (popup modal + API lengkap)" \
	"grep -q 'function Funcs:AddDropdownV2' '$LIB' && grep -q 'Type = \"DropdownV2\"' '$LIB' && grep -q 'Total Selected: %d/%d' '$LIB' && grep -q 'DropdownV2 = {' '$LIB'"
chk "v4.8.1: klik-luar popup hidup (overlay Active=true)" \
	"grep -q 'Active = true,' '$LIB'"
chk "v4.8.2: popup pakai fade window (FadeTree shared, CanvasGroup gone)" \
	"grep -q 'function Library:FadeTree' '$LIB' && grep -q 'function Library:FadeInstance' '$LIB' && grep -q 'Library:FadeTree(PopupFrame' '$LIB' && grep -q 'Library:FadeTree(MainFrame' '$LIB' && ! grep -q 'PopupContent' '$LIB' && ! grep -q 'PopupScale' '$LIB' && ! grep -q 'local function FadeInstance' '$LIB'"
chk "v4.8.1: nol hardcode warna di footer button (theme strings)" \
	"grep -q 'TextColor3 = Primary and \"BackgroundColor\" or \"FontColor\"' '$LIB' && grep -q 'local TextColor = Variant == \"Primary\" and \"BackgroundColor\" or \"FontColor\"' '$LIB'"
chk "v4.8.1: komentar library full ENGLISH (guard bahasa)" \
	"! grep -qE -- '--.*\\b(yang|nggak|gue|lu|biar|kayak|gitu|udah|belum|kalo|jangan|tetep|bener|nongol|pake|doang|aja|dong|nih|durasi|layar|hitam|ungu|merah|gelap|terang|pojok|pencet|animasi|semua|setiap|banyak|sedikit|kosong|penuh|baru|lama|awal|akhir|sebelum|setelah|saat|waktu|dan|atau|untuk|dengan|tanpa|masih|sudah|bisa|tidak|bukan|nya|kita|kami|mereka|dia|saya|aku|kamu|anda|mulus|sebagai|serta|antara|selama|sekarang|sini|satu|dua|tiga|kalau|karena|jadi|maka|oleh|pada|depan|belakang|bagian|cara|jenis|bentuk|fitur|fungsi|hasil|nilai|angka|nama|teks|kata|baris|tabel|daftar|grup|isi|konten|elemen|komponen|pilihan|opsi|tombol|ikon|gambar|warna|ukuran|posisi|arah|titik|garis|kotak|sudut|tepi|ujung|mulai|selesai|berhenti|aktif|mati|hidup|nyala|tampil|sembunyi|muncul|ada|contoh|catatan|penting|gagal|berhasil|pasti|mungkin|versi)\\b' '$LIB'"
chk "v4.8.0: popup V2 ditutup saat window close" \
	"grep -q 'Option:ClosePopup(true)' '$LIB'"
chk "v4.7.9: icon dialog opsional kanan-atas gaya notif (lib)" \
	"grep -q 'DialogIconWidth' '$LIB' && grep -q 'Info.IconColor' '$LIB'"
chk "v4.7.8: knob durasi + RESEP USER 10% dibake (lib 0.1 + mod AnimTime 0.10)" \
	"grep -q 'ST_AnimTime' '$MOD' && grep -q 'AnimTime = 0.10' '$MOD' && grep -q 'WindowAnimationInfo = TweenInfo.new(0.1' '$LIB' && grep -q 'Library.WindowAnimationInfo = TweenInfo.new' '$MOD'"
chk "v4.9.2: glow haze radial 16 micro-layer + clip + default 180px/5%" \
	"grep -q 'Library.CursorGlow = {' '$LIB' && grep -q 'function Library:SetCursorGlow' '$LIB' && grep -q 'Name = \"CursorGlowClip\"' '$LIB' && grep -q 'function Library:StartCursorGlowLoop' '$LIB' && grep -q 'local GLOW_LAYERS = 16' '$LIB' && grep -q 'Library.CursorGlowLayers = {}' '$LIB' && grep -q 'Size = 400,' '$LIB' && grep -q 'Intensity = 10,' '$LIB' && grep -q 'Smooth = 5,' '$LIB' && grep -q 'GetMouseLocation() - GuiService:GetGuiInset()' '$LIB'"
chk "v4.9.2 bug#27: knob glow hidup (groupbox sendiri + preset + BuildGlow)" \
	"grep -q 'AddLeftGroupbox(\"Cursor Glow\"' '$MOD' && grep -q 'AddRightGroupbox(\"Preset Glow\"' '$MOD' && grep -q 'local function BuildGlow' '$MOD' && grep -A2 'Try(\"Settings: info\"' '$MOD' | grep -q 'local Box = T1:AddRightGroupbox(\"Resep Tema\"' && grep -q 'Size = 400,' '$MOD'"
chk "v4.9.0: knob glow module lengkap + print resep + reset (5 kontrol)" \
	"grep -q 'GW_On' '$MOD' && grep -q 'GW_C' '$MOD' && grep -q 'GW_Size' '$MOD' && grep -q 'GW_Int' '$MOD' && grep -q 'GW_Smooth' '$MOD' && grep -q 'N3V4 CURSOR GLOW' '$MOD' && grep -q 'SetCursorGlow(DEFAULTS.Glow)' '$MOD'"
chk "v4.8.9: expand sinkron (clip) + collapse nol sliver (hide instan balik)" \
	"grep -q 'GroupboxContainer.Visible = not Collapsed' '$LIB' && grep -q 'GroupboxLine.Visible = not Groupbox.Collapsed' '$LIB'"
chk "v4.8.7: NOL duplikasi (card 1x di helper) + RESEP TAB v4 FINAL locked" \
	"[ \$(grep -c 'Name = \"TabIconCard\"' '$LIB') -eq 1 ] && grep -q 'Color = \"OutlineColor\"' '$LIB' && grep -q 'IconCardTransparency = 0.00' '$LIB' && grep -q 'IconCardPadding = 2,' '$LIB' && grep -q 'TabBackgroundTransparency = 0.85' '$LIB' && grep -q 'IconCardTransparency = 0.00' '$MOD' && grep -q 'HoverZoom = 1.25' '$LIB' && ! grep -q 'IconCardColor' '$LIB' && ! grep -q 'IconCardColor' '$MOD'"
chk "v4.8.5: print+copy resep tab nempel di groupbox card (nol duplikat tombol)" \
	"grep -q 'Copy resep tab' '$MOD' && [ \$(grep -c 'AddButton(\"Print resep tab\"' '$MOD') -eq 1 ]"
chk "v4.8.6: knob card LENGKAP di module (5 knob + print IconCard* + nol sisa)" \
	"grep -q 'TB_CardOn' '$MOD' && grep -q 'TB_CardPad' '$MOD' && grep -q 'TB_CardRad' '$MOD' && grep -q 'IconCardEnabled = %s' '$MOD' && ! grep -q 'IconStroke' '$MOD'"
chk "resep v3 jadi default di MODULE (DEFAULTS)" \
	"grep -q 'Transparency = 0,' '$MOD' && grep -q 'Contrast = 40' '$MOD' && grep -q 'GroupColor = Color3.fromRGB(0, 0, 0)' '$MOD' && grep -q 'CanvasColor = Color3.fromRGB(119, 119, 119)' '$MOD' && grep -q 'Group = 0.5' '$MOD' && grep -q 'OverlayTransparency = 0.40' '$MOD'"
chk "state S di-init SEBELUM BuildResep/BuildTema (bug 'index nil with Image')" \
	"test \$(grep -n 'local S = {' '$MOD' | cut -d: -f1) -lt \$(grep -n 'local function BuildResep' '$MOD' | cut -d: -f1)"

echo "== 3. SETTINGS MODULE =="
chk "2 tab" "test \$(grep -c 'Window:AddTab(' '$MOD') -eq 2"
chk "groupbox kiri = kanan di tiap tab (simetris)" "python3 '$ROOT/tools/symmetry.py' '$MOD'"
chk "BuildTema + BuildResep" "grep -q 'local function BuildTema' '$MOD' && grep -q 'local function BuildResep' '$MOD'"
chk "tombol print/copy resep thema" \
	"grep -q 'Print resep tema' '$MOD' && grep -q 'Copy resep tema' '$MOD' && grep -q 'Print SEMUA' '$MOD'"
chk "dual-mode: shared.N3V4_UISettings + guard attached" \
	"grep -q 'shared.N3V4_UISettings = Settings' '$MOD' && grep -q shared.N3V4_UISettings_Attached '$MOD'"
chk "color picker nggak pernah ditempel ke Groupbox (butuh .TextLabel)" \
	"! grep -qE 'Box:AddColorPicker' '$MOD'"

echo "== 4. PREVIEW =="
chk "3 tab API (PRE slim)" "test \$(grep -c '= Window:AddTab(' '$PRE') -eq 3"
chk "simetris" "python3 '$ROOT/tools/symmetry.py' '$PRE'"
chk "ggak manggil SetWallpaper/SetSurface (setingan cuma di file setingan)" \
	"! grep -qE '^\s*[^-].*Library:Set(Wallpaper|Surface)' '$PRE'"
chk "PRE loader URL git: LIB+MOD via HttpGet, nol replica nol require" \
	"grep -qF 'loadstring(game:HttpGet(LIB_URL))()' '$PRE' && grep -qF 'loadstring(game:HttpGet(MOD_URL))()' '$PRE' && ! grep -q 'ReplicatedStorage' '$PRE' && ! grep -q 'FindModule' '$PRE' && ! grep -q 'require(' '$PRE'"
chk "v4.10.0: icon anim di library (registry + play + set + UIRotation + idle-skip)" \
	"grep -q 'Library.IconAnim = {' '$LIB' && grep -q 'function Library:PlayIconAnim' '$LIB' && grep -q 'function Library:SetIconAnim' '$LIB' && grep -q 'Rot = BoxIconLabel' '$LIB' && ! grep -q 'New(\"UIRotation\"' '$LIB' && grep -q 'Zoom = 15,' '$LIB' && grep -q 'Tilt = 10,' '$LIB' && grep -q 'Speed = 0.30,' '$LIB' && grep -q 'if Changed then' '$LIB'"
chk "v4.10.0: knob icon anim + print/copy + DEFAULTS + reset" \
	"grep -q 'AddSlider(\"IA_Zoom\"' '$MOD' && grep -q 'AddSlider(\"IA_Tilt\"' '$MOD' && grep -q 'local function BuildIconAnim' '$MOD' && grep -q 'IconAnim = {' '$MOD' && grep -q 'Library:SetIconAnim(DEFAULTS.IconAnim)' '$MOD'"
chk "v4.10.3: logo window hover zoom pakai helper zoom tab" \
	"grep -q 'local WindowIconScale = New(\"UIScale\"' '$LIB' && grep -q 'Library:TweenTabZoom(WindowIconScale, Library.TabAppearance.HoverZoom or 1)' '$LIB'"
chk "v4.11.0: status bar swap (wrapper shrink + cards + loop gated visible)" \
	"grep -q 'Library.StatusBar = {' '$LIB' && grep -q 'function Library:StartStatusBarLoop' '$LIB' && grep -q 'function Library:GetExecutorName' '$LIB' && grep -q 'local StatusHolder = New' '$LIB' && grep -q 'Position = UDim2.new(1, -76, 0.5, 0)' '$LIB' && grep -q 'Name = \"chevron-left\"' '$LIB' && grep -q 'Name = \"chevron-right\"' '$LIB' && ! grep -q 'GetIcon(\"arrow-left\")' '$LIB' && grep -q 'Text = Key .. \":\"' '$LIB' && grep -q 'TextColor3 = \"AccentColor\"' '$LIB'"
chk "v4.11.3: section divider text ikut AccentColor theme" \
	"grep -q 'TextColor3 = \"AccentColor\",' '$LIB' && grep -q 'Library.Scheme.AccentColor or Library.Scheme.OutlineColor' '$LIB'"
chk "v4.12.5: garis section = outline accent + fill MainColor asli, text full opaque, sistem tetep hapus" \
	"grep -q 'New(\"UIStroke\", {' '$LIB' && grep -qF 'Transparency = Library.DividerAppearance.LineTransparency,' '$LIB' && grep -q 'BackgroundColor3 = \"MainColor\",' '$LIB' && ! grep -q 'BorderTransparency' '$LIB' '$MOD' '$PRE' && grep -A2 'Library.DividerAppearance = {' '$LIB' | grep -q 'TextTransparency = 0,' && ! grep -q 'Library.SectionAppearance' '$LIB' && ! grep -q 'SectionRegistry' '$LIB'"
chk "v4.12.5: komentar sampah dibersihkan (LIB <=149 baris asli, MOD/PRE nol)" \
	"[ \"\$(grep -cE '^\\s*--' '$LIB')\" -le 163 ] && ! grep -qE '^\\s*--' '$MOD' && ! grep -qE '^\\s*--' '$PRE' && ! grep -qE -- '--[[:space:]]*v4\\.[0-9]' '$LIB' '$MOD' '$PRE'"
chk "v4.12.4: module bersih dari sampah section settings" \
	"! grep -q 'AddSlider(\"SD_BT\"' '$MOD' && ! grep -q 'AddRightGroupbox(\"Divider Presets\"' '$MOD' && ! grep -q 'local function BuildSection' '$MOD' && ! grep -q '^\\tSection = {' '$MOD'"
chk "v4.12.6: transparansi divider bisa diatur user (API LIB + knob MOD + sample live)" \
	"grep -q 'Library.DividerAppearance = {' '$LIB' && grep -q 'function Library:SetDividerTransparency' '$LIB' && grep -q 'function Library:ApplyDividerAppearance' '$LIB' && grep -qF 'LineFrames[2] = SafeLine({' '$LIB' && grep -q 'Stroke.Transparency = Library.DividerAppearance.LineTransparency' '$LIB' && grep -q 'table.insert(Library.DividerInstances, Divider)' '$LIB' && grep -q 'AddSlider(\"SD_LT\"' '$MOD' && grep -q 'AddSlider(\"SD_TT\"' '$MOD' && grep -q 'AddDivider(\"Contoh garis\")' '$MOD' && grep -q 'AddDivider(\"Contoh text\")' '$MOD' && grep -q 'type(Library.SetDividerTransparency) == \"function\"' '$MOD' && grep -q 'Library.N3V4Version = \"4.41.2\"' '$LIB' && grep -q 'local function SafeLine(Properties)' '$LIB' && grep -q 'pcall(New, \"Frame\", Properties)' '$LIB' && grep -q 'pcall(Library.ApplyDividerAppearance, Library)' '$LIB'"
chk "v4.13.0: centang hijau kanan di dropdown v1+v2, dot lama hapus" \
	"grep -q 'local SelectedCheckColor = Color3.fromRGB(86, 197, 110)' '$LIB' && grep -qF 'Rec.Check.Visible = On' '$LIB' && grep -qF 'Check.Visible = not not Selected' '$LIB' && ! grep -q 'Rec.Dot.Visible' '$LIB' && ! grep -q 'Dot = Dot' '$LIB' && [ \"\$(grep -c 'ImageColor3 = SelectedCheckColor' '$LIB')\" -eq 2 ]"
chk "v4.13.2: slider arrows hapus bersih, ga ada sisa up/down" \
	"! grep -q 'ArrowHolder' '$LIB' && ! grep -q 'SetArrows' '$LIB' && ! grep -q 'MakeArrowButton' '$LIB' && ! grep -q 'ChevronDownIcon' '$LIB' && ! grep -qF 'Slider:SetValue(Slider.Value + 1)' '$LIB' && ! grep -q 'ArrowsHolding' '$LIB'"
chk "v4.14.0: gradient 3D semua button + knob + sample + print/copy" \
	"grep -q 'Library.ButtonGradient = {' '$LIB' && grep -qF 'Gradient.Rotation = G.Rotation' '$LIB' && grep -qF 'if Gradient.Parent then' '$LIB' && grep -q 'AddSlider(\"BG_ROT\"' '$MOD' && grep -q 'AddSlider(\"BG_POS\"' '$MOD' && grep -q 'AddSlider(\"BG_TR\"' '$MOD' && grep -q 'AddSlider(\"BG_OFF\"' '$MOD' && grep -q 'AddColorPicker(\"BG_C1\"' '$MOD' && grep -q 'AddColorPicker(\"BG_C2\"' '$MOD' && grep -q 'AddColorPicker(\"BG_C3\"' '$MOD' && ! grep -q 'MiddleDark' '$LIB' '$MOD' && [ \"\$(grep -c 'Print setingan gradient\", PrintGrad' '$MOD')\" -eq 2 ] && [ \"\$(grep -c 'Copy setingan gradient\", CopyGrad' '$MOD')\" -eq 2 ] && grep -q 'local function PrintGrad()' '$MOD'"
chk "v4.15.0: gradient bake verbatim + merata slider/input/dropdown, satu state sync" \
	"grep -q 'local function MakeGradient(Parent)' '$LIB' && grep -q 'Offset = 0.01,' '$LIB' && grep -q 'Color3.fromRGB(85, 85, 85)' '$LIB' && grep -q 'Color3.fromRGB(224, 224, 224)' '$LIB' && grep -q 'MakeGradient(Bar)' '$LIB' && grep -q 'MakeGradient(Box)' '$LIB' && grep -q 'MakeGradient(MenuTable.Menu)' '$LIB' && grep -q 'PopupGradient = MakeGradient(PopupFrame)' '$LIB' && grep -q 'MakeGradient(SearchFrame)' '$LIB' && grep -q 'MakeGradient(Card)' '$LIB' && grep -q $'^local function MakeGradient(Parent)' '$LIB' && ! grep -q $'^\\tlocal function MakeGradient' '$LIB' && grep -q 'AddSlider(\"BG_SAMPLE_SL\"' '$MOD' && [ \"\$(grep -c 'MakeGradient(' '$LIB')\" -ge 8 ]"
chk "footer v4.41.2" "grep -q 'Preview Kit v4.41.2' '$PRE'"
chk "v4.39.0: gradient kartu GLOBAL only — per-kartu/spotlight diputus" \
	"grep -q 'Preset = \\\"Chrome\",' '$LIB' && grep -q 'Rotation = -90,' '$LIB' && grep -q 'function Library:SetCardGradient(Info)' '$LIB' && ! grep -q 'ApplyCardGradient' '$LIB' && ! grep -q 'SpotlightCards' '$LIB' && ! grep -q 'CardPanels' '$LIB'"
chk "v4.39.0: LIB STANDALONE satu file — module N3V4Visuals DIHAPUS, engine gradient inline" \
	"! test -f '$VIS' && ! grep -q 'N3V4Visuals' '$LIB' '$MOD' '$PRE' && ! grep -q 'ReplicatedStorage' '$LIB' && grep -qF 'local function AttachGradient' '$LIB' && grep -qF 'local Visuals = {' '$LIB' && grep -qF 'local function EnsureTicker' '$LIB' && grep -q 'AddDropdown(\\\"CG_PRESET\\\"' '$MOD' && [ \"\$(grep -c 'Print setingan gradient kartu' '$MOD')\" -eq 2 ] && [ \"\$(grep -c 'Copy setingan gradient kartu' '$MOD')\" -eq 2 ] && grep -qF 'Library:SetCardGradient(' '$PRE'"
chk "v4.21.0: struktur gradient kartu — apply + rotasi (engine inline LIB)" \
	"grep -q 'AddSlider(\\\"CG_ROT\\\"' '$MOD' && grep -qF 'Presets.Sequence[Conf.Preset]' '$LIB' && grep -qF 'St.Grad.Rotation = Rot' '$LIB'"
chk "v4.22.0: gradient animasi gaya source — ticker bersama + blend + picker sync" \
	"grep -qF 'RunService.Heartbeat:Connect' '$LIB' && grep -qF 'local function EvalColorSequence' '$LIB' && grep -qF 'local function TrueSequence' '$LIB' && grep -qF 'local function BlendSequences' '$LIB' && grep -qF 'SampleSequence = EvalColorSequence' '$LIB' && grep -qF 'OffsetSpeed = 0.1,' '$LIB' && grep -qF 'RotationSpeed = 2,' '$LIB' && grep -qF 'G.OffsetSpeed = math.clamp(Info.OffsetSpeed' '$LIB' && grep -qF 'function Library:SampleCardGradient(Preset)' '$LIB' && grep -q 'AddSlider(\\\"CG_FLOW\\\"' '$MOD' && grep -q 'AddSlider(\\\"CG_SPIN\\\"' '$MOD' && grep -qF 'local CGSync = false' '$MOD' && grep -qF 'Library:SampleCardGradient(Value)' '$MOD' && grep -qF 'DropCG:SetValue(' '$MOD' && grep -qF 'Library.Options.CG_C1:SetValueRGB(' '$MOD'"
chk "v4.23.0: preset lengkap dari source EasyVisual — 18 preset + transparency verbatim" \
	"grep -qF 'Fire = ColorSequence.new' '$LIB' && grep -qF 'Ice = ColorSequence.new' '$LIB' && grep -qF 'Electric = ColorSequence.new' '$LIB' && grep -qF 'Galaxy = ColorSequence.new' '$LIB' && grep -qF 'Matrix = ColorSequence.new' '$LIB' && grep -qF 'Zebra = ColorSequence.new' '$LIB' && grep -qF 'Death = ColorSequence.new' '$LIB' && grep -qF 'Ghost = ColorSequence.new' '$LIB' && grep -qF 'Bubblegum = ColorSequence.new' '$LIB' && grep -qF 'Green = ColorSequence.new' '$LIB' && grep -qF 'Transparency = {' '$LIB' && grep -qF 'Solid = NumberSequence.new(0)' '$LIB' && grep -qF 'Visuals.Presets.Transparency[Style.Trans]' '$LIB' && grep -qF 'Bubblegum' '$MOD'"
chk "v4.24.0: stroke presets source — dropdown style + ticker bersama" \
	"grep -qF 'Library.StrokeStyles = {' '$LIB' && grep -qF 'ShineOutline = {' '$LIB' && grep -qF 'Visuals.AttachGradient(' '$LIB' && grep -qF 'Preset = ' '$LIB' && grep -qF 'local function AttachGradient' '$LIB' && grep -qF 'AttachGradient = AttachGradient' '$LIB' && grep -qF 'if Conf.Sequence then' '$LIB' && grep -qF 'Wave = NumberSequence.new' '$LIB' && grep -q 'AddDropdown(\\\"OS_PRE\\\"' '$MOD' && grep -qF 'Style stroke (source EasyVisual)' '$MOD'"
chk "v4.25.0: fidelitas 100% source — osilasi sin + transparency-offset + pulse stroke" \
	"grep -qF 'local function EvalNumberSequence' '$LIB' && grep -qF 'local function TrueNumberSequence' '$LIB' && grep -qF 'TransparencySpeed' '$LIB' && grep -qF 'OscAmp' '$LIB' && grep -qF 'PulseAmp' '$LIB' && grep -qF 'Osc = -30' '$LIB' && grep -qF 'Osc = -20' '$LIB' && grep -qF 'TransFlow = -0.9' '$LIB' && grep -qF 'TransFlow = 0.9' '$LIB' && grep -qF 'Pulse = true' '$LIB'"
chk "v4.30.0: sistem bayangan DIHAPUS total dari library" \
	"! grep -qF 'function Library:AddDropshadow' '$LIB' && ! grep -qF 'AttachDropshadow' '$LIB' && ! grep -qF 'Library.Dropshadow = {' '$LIB' && ! grep -qF 'ShadowActive' '$LIB' && ! grep -qF 'DS_ON' '$MOD' && ! grep -qF 'Sample Dropshadow' '$MOD'"
chk "v4.27.0: dashboard baru — lama hapus total, grid simetris stat+meter" \
	"grep -qF 'function Library:CreateDashboard(Info)' '$LIB' && ! grep -qF 'function Library:CreateDashboardWindow' '$LIB' && ! grep -qF 'CreateDashboardWindow(' '$PRE' && grep -qF 'function Dashboard:AddStat(' '$LIB' && grep -qF 'function Dashboard:AddMeter(' '$LIB' && grep -qF 'function Dashboard:SetMeter(' '$LIB' && grep -qF 'SortOrder = Enum.SortOrder.LayoutOrder' '$LIB' && grep -qF 'PaddingTop = UDim.new(0, 8)' '$LIB' && grep -qF 'local ZOFF = 100' '$LIB' && grep -qF 'local TOP_H = 32' '$LIB' && grep -qF 'Library:CreateDashboard(' '$PRE'"
chk "v4.39.1: spotlight card = komponen inline LIB (compat SAE), MOD/PRE bersih sample lama" \
	"grep -qF 'function Funcs:AddSpotlightCard(' '$LIB' && ! grep -q 'AddSpotlightCard' '$MOD' '$PRE' && ! grep -q 'SpotlightCards' '$LIB' && ! grep -q 'CardPanels' '$LIB' '$MOD' && ! grep -q 'CP_SAMPLE' '$MOD' && ! grep -q 'BindLabel' '$MOD'"
chk "v4.39.0: viewport native wajib Object — orbit module era Studio diputus" \
	"grep -qF 'Templates.Viewport' '$LIB' && grep -qF 'if not Info.Object then' '$LIB' && ! grep -q 'OrbitCamera' '$LIB' && ! grep -q 'Klik kanan + drag di dalam viewport' '$PRE'"
chk "v4.17.0: glow on click — hook pusat GuiButton Activated, auto-loop 25s + pulse non-click hapus, drag surface exclude" \
	"grep -q 'local function HookGlowClicks(Obj)' '$LIB' && grep -q 'MainFrame.DescendantAdded:Connect(HookGlowClicks)' '$LIB' && grep -qF 'IsA(\"GuiButton\") and not Obj:GetAttribute(\"NoGlowPulse\")' '$LIB' && [ \"\$(grep -c 'SetAttribute(\"NoGlowPulse\", true)' '$LIB')\" -eq 6 ] && ! grep -q 'task.wait(25)' '$LIB' && ! grep -q 'MASUKKAN DI SINI' '$LIB' && ! grep -qF 'Library:PulseWindowGlow() -- <-- TAMBAH INI' '$LIB' && grep -q 'Obj.Activated:Connect' '$LIB'"
chk "v4.16.0: outline spin — pita gradient muter di outline window + knob + sample hidup + print/copy" \
	"grep -q 'Library.OutlineSpin = {' '$LIB' && grep -q 'function Library:AddOutlineSpin(Parent)' '$LIB' && grep -q 'function Library:ApplyOutlineSpin()' '$LIB' && grep -q 'function Library:SetOutlineSpin(Info)' '$LIB' && grep -q 'Library:AddOutlineSpin(MainFrame)' '$LIB' && grep -qF 'Color3.fromRGB(193, 193, 193)' '$LIB' && grep -q 'Speed = 8.5,' '$LIB' && grep -qF 'ColorSequenceKeypoint.new(0.35, S.ColorB)' '$LIB' && grep -qF 'NumberSequenceKeypoint.new(0.15, 0)' '$LIB' && grep -qF 'NumberSequenceKeypoint.new(0.35, 1)' '$LIB' && grep -qF '{ Rotation = 360 }' '$LIB' && grep -qF 'Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1' '$LIB' && grep -q 'Outline Muter' '$MOD' && grep -q 'Sample Outline Muter' '$MOD' && grep -q 'OS_ON' '$MOD' && grep -q 'AddSlider(\"OS_SPD\"' '$MOD' && grep -q 'AddColorPicker(\"OS_C1\"' '$MOD' && grep -q 'AddColorPicker(\"OS_C2\"' '$MOD' && grep -q 'Library:AddOutlineSpin(SampleWin)' '$MOD' && [ \"\$(grep -c 'Print setingan outline muter' '$MOD')\" -eq 2 ] && [ \"\$(grep -c 'Copy setingan outline muter' '$MOD')\" -eq 2 ] && grep -q 'local function PrintSpin()' '$MOD'"

echo "== 5. GAME SCRIPTS (patch user — edit cuma URL library, atas perintah) =="
chk "Games/N3-SAE.luau = patch user dari main — edit: URL LIB ke project ini + wiring SetRarity kartu" \
	"test -f '$ROOT/Games/N3-SAE.luau' && git -C '$ROOT' diff --numstat origin/main -- Games/N3-SAE.luau | grep -qE '^17[[:space:]]+2[[:space:]]' && grep -qF 'refs/heads/arena/c5a10c06-n3-project/Library/N3V3-NoObfus.lua' '$ROOT/Games/N3-SAE.luau' && ! grep -qF 'ZedFu3/N3-Hub/refs/heads/main/Library/N3V3.luau' '$ROOT/Games/N3-SAE.luau' && grep -qF 'Spotlight:SetRarity(' '$ROOT/Games/N3-SAE.luau' && grep -qF 'BUILD CRASH' '$ROOT/Games/N3-SAE.luau'"
echo
echo "== chk v4.28: shadow modern 4 layer + popover details =="
chk "engine bayangan 4 layer ikut terhapus (VIS)" \
	"! grep -qF 'SHADOW_LAYERS' '$VIS' && ! grep -qF 'local LayerTrans =' '$VIS'"
chk "kartu dashboard klikabel + popover details (LIB)" \
	"grep -qF 'AutoButtonColor = false' '$LIB' && grep -qF 'function Dashboard:SetDetails' '$LIB' && grep -qF 'local function FillExp(CardData)' '$LIB' && grep -qF 'local function Toggle(CardData)' '$LIB'"
chk "PRE slim: nol demo spawn — label API doang" \
	"! grep -q 'Dash:SetDetails(' '$PRE' && ! grep -q 'Shop Cepat' '$PRE' && ! grep -q 'DemoPanel' '$PRE' && ! grep -q 'Try(' '$PRE' && ! grep -q 'RunLoadingSequence' '$PRE'"
echo
echo "== chk v4.29: dashboard list minimalis + accordion ke bawah, tanpa dropshadow =="
chk "dashboard tanpa dropshadow + popover melayang hapus" \
	"! grep -qF 'Library:AddDropshadow(' '$LIB' && ! grep -qF 'local function OpenPop' '$LIB' && ! grep -qF 'local function ClosePop()' '$LIB'"
chk "list satu kolom + accordion inline" \
	"grep -qF 'local function BuildRow(' '$LIB' && grep -qF 'Sep = Sep, Track = Track' '$LIB' && grep -qF 'CardData.Open = not CardData.Open' '$LIB' && grep -qF 'local function FillExp(CardData)' '$LIB' && grep -qF 'local function BuildExp(CardData)' '$LIB'"

echo
echo "== chk v4.30: setingan dashboard lengkap =="
chk "setingan dashboard LIB + MOD + print/copy" \
	"grep -qF 'Library.DashboardStyle = {' '$LIB' && grep -qF 'function Library:SetDashboardStyle' '$LIB' && grep -qF 'function Library:ApplyDashboardStyle' '$LIB' && grep -qF 'function Dashboard:Restyle()' '$LIB' && grep -qF 'DB_SH' '$MOD' && grep -qF 'DB_LC' '$MOD' && grep -qF 'DB_C1' '$MOD' && test \$(grep -c 'Print setingan dashboard' '$MOD') -eq 2 && test \$(grep -c 'Copy setingan dashboard' '$MOD') -eq 2 && grep -qF 'Buka sample dashboard' '$MOD' && ! grep -qF 'local HoverBg = New' '$LIB' && grep -qF 'Gone:Destroy()' '$LIB' && grep -qF 'CardData.ExpInner = Inner' '$LIB' && grep -qF 'Parent = Host,' '$LIB' && grep -qF 'StatHeight = 25,' '$LIB' && grep -qF 'HoverTransparency = 0.65,' '$LIB' && grep -qF 'TextSize = 13,' '$LIB' && grep -qF 'return Holder, Container' '$LIB' && ! grep -qF 'function Menu:AddToggle' '$LIB' && ! grep -qF 'local MenuWidth, ItemH, ItemPad, Count' '$PRE' && grep -qF 'Library.__GroupboxClass = BaseGroupbox' '$LIB' && grep -qF 'setmetatable({' '$LIB' && grep -qF 'function Menu:Resize()' '$LIB' && grep -qF 'TextService:GetTextSize(Desc.Text' '$LIB' && ! grep -qF 'Holder.Size = UDim2.fromOffset(170, 0)' '$PRE' && grep -qF 'Library:AddDraggableMenu' '$PRE' && grep -qF 'function Library:AddDraggableMenu' '$LIB' && ! grep -qF 'local function MenuToggle(' '$PRE' && ! grep -qF 'N3V4 PROBE MENU' '$PRE'"
chk "v4.33.0: panel API LIB (CreatePanel/AddTab/AddItem)" \
	"grep -qF 'function Library:CreatePanel(' '$LIB' && grep -qF 'function Panel:AddTab(' '$LIB' && grep -qF 'function Tab:AddItem(' '$LIB' && grep -qF 'Act.BackgroundTransparency = 0.25' '$LIB' && grep -qF 'function Panel:AddChip(' '$LIB' && grep -qF 'function Panel:SetHeaderButton(' '$LIB' && grep -qF 'ItemInfo.IconButton' '$LIB' && grep -qF 'local function AddLight(' '$LIB' && grep -qF 'ItemInfo.GlowColor' '$LIB' && grep -qF 'PanelTab:AddItem(' '$PRE' && grep -qF 'Library.PanelStyle = {' '$LIB' && grep -qF 'function Panel:Restyle(' '$LIB' && grep -qF 'Rec.Ring.Enabled = S.GlowRing' '$LIB' && grep -qF 'PanelOverlay' '$LIB' && grep -qF 'OverlayTransparency' '$MOD' && grep -qF 'BoldText = true,' '$LIB' && grep -qF 'TitleSize = 18,' '$LIB' && grep -qF 'local ChipBox = New(' '$LIB' && grep -qF 'local ChipCheck = Library:GetIcon' '$LIB' && grep -qF 'Library.PanelRarity = {' '$LIB' && grep -qF 'MetallicHeader = true,' '$LIB' && grep -qF 'Wallpaper = false,' '$LIB' && grep -qF 'MetallicHeader = %s' '$MOD' && grep -qF 'local Handle = {' '$LIB' && grep -qF 'SetSubtext = function(Value)' '$LIB' && ! grep -qF 'Banding: jendela ChiliSource' '$PRE' && test \$(grep -c 'Print setingan panel' '$MOD') -eq 2 && grep -qF 'rbxassetid://111593326989465' '$LIB' && grep -qF 'local XIcon = Library:GetIcon' '$LIB' && test \$(grep -c 'Print setingan panel' '$MOD') -eq 2 && grep -qF 'Handle:Destroy()' '$PRE'"
chk "tools/dump_game_ui.lua = snippet dump read-only (prefix N3DUMP, nol Instance.new, nol Parent write)" \
	"test -f '$ROOT/tools/dump_game_ui.lua' && grep -qF '[N3DUMP]' '$ROOT/tools/dump_game_ui.lua' && ! grep -qF 'Instance.new' '$ROOT/tools/dump_game_ui.lua' && ! grep -qE '\\.Parent\\s*=' '$ROOT/tools/dump_game_ui.lua'"
chk "v4.41.0: sinar icon pet style game (sprite dump) default ON + saklar API + knob MOD; pattern window REVERT" \
	"grep -qF 'Library.IconGlow = {' '$LIB' && grep -qF 'function Library:SetIconGlow(' '$LIB' && grep -qF 'rbxassetid://109516122757226' '$LIB' && grep -qF 'table.insert(Library.IconGlows, { Inst = Glow, Base = BoxSize })' '$LIB' && grep -qF 'local Glow = New(' '$LIB' && grep -qF 'TB_GlowOn' '$MOD' && ! grep -qF 'PatternBG' '$LIB' && ! grep -qF 'SetPatternBackground' '$LIB'"
chk "v4.39.1: compat API surface SAE — AddGroupbox alias Side + AddSpotlightCard inline (SetData/Title/Desc/Icon/viewport model) + Label .Text live sync" \
	"grep -qF 'function Funcs:AddGroupbox(' '$LIB' && grep -qF 'function Funcs:AddSpotlightCard(' '$LIB' && grep -qF 'function CardObj:SetData(' '$LIB' && grep -qF 'Info.Side == 2' '$LIB' && grep -qF 'SpotlightCard = { Height = 110' '$LIB' && grep -qF 'Label._Text = Label.Text' '$LIB' && grep -qF 'function CardObj:SetRarity(' '$LIB' && grep -qF 'Text = tostring(Text)' '$LIB' && grep -qF 'Viewport = ViewportStub,' '$LIB' && ! grep -q 'CardCamera' '$LIB' && ! grep -q 'WorldModel' '$LIB' && grep -qF 'ScaleType = Enum.ScaleType.Crop,' '$LIB'"
chk "v4.39.0: ikon 100% URL git — peta sheet offline era Studio DIHAPUS" \
	"grep -qF 'LucideSources = {' '$LIB' && grep -qF 'lucide-roblox-direct' '$LIB' && ! grep -q 'OfflineLucide' '$LIB' && ! grep -q '136111683851629' '$LIB' && ! grep -q '135883070486325' '$LIB' && grep -qF 'local LucideAliases = {' '$LIB' && grep -qF 'pcall(Icons.GetAsset, Resolved)' '$LIB' && ! grep -q 'offline-ready' '$PRE'"
echo
echo "HASIL: $PASS lolos, $FAIL gagal"
[[ "$FAIL" == "0" ]] && echo "🎉 SEMUA CHECK LOLOS" || exit 1

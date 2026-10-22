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
for f in "$LIB" "$MOD" "$PRE" "$ROOT"/Games/*.lua; do
	N=$("$BIN" --mode=nonstrict "$f" 2>&1 | grep -c SyntaxError)
	if [[ "$N" == "0" ]]; then ok "syntax $(basename "$f")"; else
		bad "syntax $(basename "$f") — $N SyntaxError"
		"$BIN" --mode=nonstrict "$f" 2>&1 | grep SyntaxError | head -5
	fi
done

echo "== 2. LIBRARY =="
chk "AddViewport: 2 versi + bridge (Height/Spin TETEP jalan)" \
	"test \$(grep -c 'function Funcs:AddViewport' '$LIB') -eq 2 && grep -q RichAddViewport '$LIB'"
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
chk "v4.6.10: preview OFF total (nggak nyetomp state global lagi)" \
	"grep -q 'local PREVIEW_ENABLED = true' '$PREV' && ! grep -q 'Library:SetSurface' '$PREV'"
chk "v4.6.11: nested surface card ikut induk (IsInsideSurfaceCard dipake x3)" \
	"[ \$(grep -c 'Library:IsInsideSurfaceCard(BoxHolder)' '$LIB') -eq 3 ] && grep -q 'function Library:IsInsideSurfaceCard' '$LIB'"
chk "v4.7.0: TabAppearance + setter/applier di LIBRARY" \
	"grep -q 'Library.TabAppearance = {' '$LIB' && grep -q 'function Library:SetTabAppearance' '$LIB' && grep -q 'function Library:ApplyTabAppearance' '$LIB'"
chk "v4.8.4: icon CARD ganti halo (helper + nol sisa stroke lama)" \
	"grep -q 'TabIconCard' '$LIB' && grep -q 'function Library:CreateTabIconCard' '$LIB' && ! grep -q 'IconStroke' '$LIB' && grep -q 'TabHoverZoom' '$LIB' && grep -q 'TabHoverZoom' '$MOD'"
chk "v4.7.0: print LENGKAP include RESEP TAB (BuildTab)" \
	"grep -q 'local function BuildTab' '$MOD' && grep -q 'N3V4 RESEP TAB' '$MOD'"
chk "v4.7.1: stale-paste detector LIBRARY (warn di Attach + report preview)" \
	"grep -q 'LIBRARY LAMA terdeteksi' '$MOD' && grep -q 'LIBRARY LAMA: SetTabAppearance' '$PREV'"
chk "v4.7.2: library print versi sendiri + tombol TEST efek keliatan" \
	"grep -q 'N3V4 Library] v4.15.0 loaded' '$LIB' && grep -q 'TEST: bikin efek KELIATAN' '$MOD'"
chk "v4.7.3: scope TabRec bener (local di luar do-block) + card icon + DEBUG dump" \
	"! grep -q 'local TabRec = {' '$LIB' && grep -q 'TabIconCard' '$LIB' && grep -q 'DEBUG: dump tab visuals' '$MOD'"
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
chk "v4.8.0: popup V2 ditutup saat window close + demo preview simetris" \
	"grep -q 'Option:ClosePopup(true)' '$LIB' && grep -q 'AddDropdownV2(\"DD2_Rarity\"' '$PRE' && grep -q 'AddDropdownV2(\"DD2_Mode\"' '$PRE'"
chk "v4.7.9: icon dialog opsional kanan-atas gaya notif (lib + demo preview)" \
	"grep -q 'DialogIconWidth' '$LIB' && grep -q 'Info.IconColor or \"AccentColor\"' '$LIB' && grep -q 'Icon = \"info\"' '$PRE' && grep -q 'Icon = \"zap\"' '$PRE'"
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
chk "5 tab showcase" "test \$(grep -c 'Window:AddTab(' '$PRE') -eq 5"
chk "simetris" "python3 '$ROOT/tools/symmetry.py' '$PRE'"
chk "ggak manggil SetWallpaper/SetSurface (setingan cuma di file setingan)" \
	"! grep -qE '^\s*[^-].*Library:Set(Wallpaper|Surface)' '$PRE'"
chk "AddKeyBox di-guard typeof" "grep -q 'typeof(AdvancedTab.AddKeyBox)' '$PRE'"
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
	"grep -q 'Library.DividerAppearance = {' '$LIB' && grep -q 'function Library:SetDividerTransparency' '$LIB' && grep -q 'function Library:ApplyDividerAppearance' '$LIB' && grep -qF 'LineFrames[2] = SafeLine({' '$LIB' && grep -q 'Stroke.Transparency = Library.DividerAppearance.LineTransparency' '$LIB' && grep -q 'table.insert(Library.DividerInstances, Divider)' '$LIB' && grep -q 'AddSlider(\"SD_LT\"' '$MOD' && grep -q 'AddSlider(\"SD_TT\"' '$MOD' && grep -q 'AddDivider(\"Contoh garis\")' '$MOD' && grep -q 'AddDivider(\"Contoh text\")' '$MOD' && grep -q 'type(Library.SetDividerTransparency) == \"function\"' '$MOD' && grep -q 'Library.N3V4Version = \"4.15.0\"' '$LIB' && grep -q 'local function SafeLine(Properties)' '$LIB' && grep -q 'pcall(New, \"Frame\", Properties)' '$LIB' && grep -q 'pcall(Library.ApplyDividerAppearance, Library)' '$LIB'"
chk "v4.13.0: centang hijau kanan di dropdown v1+v2, dot lama hapus" \
	"grep -q 'local SelectedCheckColor = Color3.fromRGB(86, 197, 110)' '$LIB' && grep -qF 'Rec.Check.Visible = On' '$LIB' && grep -qF 'Check.Visible = not not Selected' '$LIB' && ! grep -q 'Rec.Dot.Visible' '$LIB' && ! grep -q 'Dot = Dot' '$LIB' && [ \"\$(grep -c 'ImageColor3 = SelectedCheckColor' '$LIB')\" -eq 2 ]"
chk "v4.13.2: slider arrows hapus bersih, ga ada sisa up/down" \
	"! grep -q 'ArrowHolder' '$LIB' && ! grep -q 'SetArrows' '$LIB' && ! grep -q 'MakeArrowButton' '$LIB' && ! grep -q 'ChevronDownIcon' '$LIB' && ! grep -qF 'Slider:SetValue(Slider.Value + 1)' '$LIB' && ! grep -q 'ArrowsHolding' '$LIB'"
chk "v4.14.0: gradient 3D semua button + knob + sample + print/copy" \
	"grep -q 'Library.ButtonGradient = {' '$LIB' && grep -qF 'Gradient.Rotation = G.Rotation' '$LIB' && grep -qF 'if Gradient.Parent then' '$LIB' && grep -q 'AddSlider(\"BG_ROT\"' '$MOD' && grep -q 'AddSlider(\"BG_POS\"' '$MOD' && grep -q 'AddSlider(\"BG_TR\"' '$MOD' && grep -q 'AddSlider(\"BG_OFF\"' '$MOD' && grep -q 'AddColorPicker(\"BG_C1\"' '$MOD' && grep -q 'AddColorPicker(\"BG_C2\"' '$MOD' && grep -q 'AddColorPicker(\"BG_C3\"' '$MOD' && ! grep -q 'MiddleDark' '$LIB' '$MOD' && [ \"\$(grep -c 'Print setingan gradient' '$MOD')\" -eq 2 ] && [ \"\$(grep -c 'Copy setingan gradient' '$MOD')\" -eq 2 ] && grep -q 'local function PrintGrad()' '$MOD'"
chk "v4.15.0: gradient bake verbatim + merata slider/input/dropdown, satu state sync" \
	"grep -q 'local function MakeGradient(Parent)' '$LIB' && grep -q 'Offset = 0.01,' '$LIB' && grep -q 'Color3.fromRGB(85, 85, 85)' '$LIB' && grep -q 'Color3.fromRGB(224, 224, 224)' '$LIB' && grep -q 'MakeGradient(Bar)' '$LIB' && grep -q 'MakeGradient(Box)' '$LIB' && grep -q 'MakeGradient(MenuTable.Menu)' '$LIB' && grep -q 'PopupGradient = MakeGradient(PopupFrame)' '$LIB' && grep -q 'AddSlider(\"BG_SAMPLE_SL\"' '$MOD' && [ \"\$(grep -c 'MakeGradient(' '$LIB')\" -ge 8 ]"
chk "footer v4.15.0" "grep -q 'Preview Kit v4.15.0' '$PRE'"

echo "== 5. GAME SCRIPTS (HARAM disentuh) =="
chk "Games/*.lua identik dengan baseline ec0f3a1" \
	"test -z \"\$(cd '$ROOT' && git diff ec0f3a1 -- Games/)\""

echo
echo "HASIL: $PASS lolos, $FAIL gagal"
[[ "$FAIL" == "0" ]] && echo "🎉 SEMUA CHECK LOLOS" || exit 1

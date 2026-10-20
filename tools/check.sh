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
chk "theme v4 user jadi default di LIBRARY (bg 18 / main 33 / outline 61 + radius 15)" \
	"grep -q 'AccentColor = Color3.fromRGB(218, 68, 255)' '$LIB' && grep -q 'BackgroundColor = Color3.fromRGB(15, 15, 15),' '$LIB' && grep -q 'MainColor = Color3.fromRGB(45, 45, 45),' '$LIB' && grep -q 'OutlineColor = Color3.fromRGB(65, 65, 65),' '$LIB' && grep -q 'CornerRadius = 15,' '$LIB'"
chk "resep v5 default di LIBRARY (wallpaper 0 + scrim 0.55 + group 0.35 + contrast 40)" \
	"grep -q 'BackgroundImageTransparency = 0,' '$LIB' && grep -q 'GroupContrast = 40,' '$LIB' && grep -q 'CanvasColor = Color3.fromRGB(156, 156, 156)' '$LIB' && grep -q 111593326989465 '$LIB'"
chk "group HITAM + contrast 30 baseline tetep (v4.6.5)" \
	"grep -q 'GroupColor = Color3.fromRGB(0, 0, 0), -- override warna kartu = HITAM' '$LIB' && grep -q 'GroupContrast = 40,' '$LIB'"
chk "v4.6.6: wallpaper layer BACK + window/canvas full (kartu 100% solid)" \
	"grep -q 'BackgroundImageLayer = \"back\"' '$LIB' && grep -q 'CanvasTransparency = 1,' '$LIB' && grep -q 'Layer = \"back\"' '$MOD' && grep -q 'Canvas = 1,' '$MOD'"
chk "v4.6.7: NGGAK ada preset/combo yang pindah ke layer front (jebakan)" \
	"! grep -q 'Layer = \"front\"' '$MOD' && ! grep -q 'Combo(\"Stretch\", \"front\")' '$MOD'"
chk "v4.6.7: preset Load() nggak matiin GroupColor/CanvasColor custom user" \
	"! sed -n '/local function Load/,/SafeNotify/p' '$MOD' | grep -qE 'S\.(Group|Canvas)Color'"
chk "v4.6.8: navbar bawah corner BAWAH-aja (SpecificCorners, tinggi 20)" \
	"grep -q 'BottomRightRadius = UDim.new(0, WindowInfo.CornerRadius)' '$LIB' && grep -q 'Size = UDim2.new(1, 0, 0, 20), -- v4.6.8' '$LIB'"
chk "v4.6.9: CreateWindow NGGAK stomp Surface default lagi (seed conditional)" \
	"grep -q 'local RawGroupT = WindowInfo and WindowInfo.GroupTransparency' '$LIB'"
chk "v4.6.10: preview OFF total (nggak nyetomp state global lagi)" \
	"grep -q 'local PREVIEW_ENABLED = true' '$PREV' && ! grep -q 'Library:SetSurface' '$PREV'"
chk "v4.6.11: nested surface card ikut induk (IsInsideSurfaceCard dipake x3)" \
	"[ \$(grep -c 'Library:IsInsideSurfaceCard(BoxHolder)' '$LIB') -eq 3 ] && grep -q 'function Library:IsInsideSurfaceCard' '$LIB'"
chk "v4.7.0: TabAppearance + setter/applier di LIBRARY" \
	"grep -q 'Library.TabAppearance = {' '$LIB' && grep -q 'function Library:SetTabAppearance' '$LIB' && grep -q 'function Library:ApplyTabAppearance' '$LIB'"
chk "v4.7.0/7.6: stroke halo + zoom icon sidebar (TabHoverZoom lib+mod)" \
	"grep -q 'TabIconStrokeHalo' '$LIB' && grep -q 'function Library:CreateTabIconStroke' '$LIB' && grep -q 'TabHoverZoom' '$LIB' && grep -q 'TabHoverZoom' '$MOD'"
chk "v4.7.0: print LENGKAP include RESEP TAB (BuildTab)" \
	"grep -q 'local function BuildTab' '$MOD' && grep -q 'N3V4 RESEP TAB' '$MOD'"
chk "v4.7.1: stale-paste detector LIBRARY (warn di Attach + report preview)" \
	"grep -q 'LIBRARY LAMA terdeteksi' '$MOD' && grep -q 'LIBRARY LAMA: SetTabAppearance' '$PREV'"
chk "v4.7.2: library print versi sendiri + tombol TEST efek keliatan" \
	"grep -q 'N3V4 Library] v4.7.9 loaded' '$LIB' && grep -q 'TEST: bikin efek KELIATAN' '$MOD'"
chk "v4.7.3: scope TabRec bener (local di luar do-block) + halo stroke + DEBUG dump" \
	"! grep -q 'local TabRec = {' '$LIB' && grep -q 'TabIconStrokeHalo' '$LIB' && grep -q 'DEBUG: dump tab visuals' '$MOD'"
chk "v4.7.4: gate zoom nil-safe + auto-apply CreateWindow + preview kirim TabHoverZoom" \
	"grep -q 'function Library:ZoomTabEnabled' '$LIB' && grep -q 'window ready: tabVisuals' '$LIB' && grep -q 'TabHoverZoom = true, -- v4.7.4' '$PREV'"
chk "v4.7.5: patch tab ada di AddTab ASLI (bukan AddKeyTab doang)" \
	"[ \$(grep -c 'table.insert(Library.TabVisuals, TabRec)' '$LIB') -eq 2 ] && [ \$(grep -c 'BackgroundTransparency = Library.TabAppearance.TabBackgroundTransparency,' '$LIB') -eq 4 ]"
chk "v4.7.7: fade window baru (tween cache+token, nol stagger/block)" \
	"grep -q 'FadeTweenCache' '$LIB' && grep -q 'local FadeToken = 0' '$LIB' && ! grep -q 'task.wait(FadeTime / 2)' '$LIB' && ! grep -q 'if Fading then' '$LIB'"
chk "v4.7.9: footer button dialog di-Resize (holder nggak hidden) = 6x Resize" \
	"[ \$(grep -c 'Dialog:Resize()' '$LIB') -eq 6 ]"
chk "v4.7.9: icon dialog opsional kanan-atas gaya notif (lib + demo preview)" \
	"grep -q 'DialogIconWidth' '$LIB' && grep -q 'Info.IconColor or \"AccentColor\"' '$LIB' && grep -q 'Icon = \"info\"' '$PRE' && grep -q 'Icon = \"zap\"' '$PRE'"
chk "v4.7.8: knob durasi + RESEP USER 10% dibake (lib 0.1 + mod AnimTime 0.10)" \
	"grep -q 'ST_AnimTime' '$MOD' && grep -q 'AnimTime = 0.10' '$MOD' && grep -q 'WindowAnimationInfo = TweenInfo.new(0.1' '$LIB' && grep -q 'Library.WindowAnimationInfo = TweenInfo.new' '$MOD'"
chk "v4.7.6: NOL duplikasi (halo dibuat 1x di helper) + RESEP TAB locked lib+mod" \
	"[ \$(grep -c 'Name = \"TabIconStrokeHalo\"' '$LIB') -eq 1 ] && grep -q 'IconStrokeColor = Color3.fromRGB(107, 0, 181)' '$LIB' && grep -q 'IconStrokeColor = Color3.fromRGB(107, 0, 181)' '$MOD' && grep -q 'HoverZoom = 1.30' '$LIB'"
chk "resep v3 jadi default di MODULE (DEFAULTS)" \
	"grep -q 'Transparency = 0,' '$MOD' && grep -q 'Contrast = 40' '$MOD' && grep -q 'GroupColor = Color3.fromRGB(0, 0, 0)' '$MOD' && grep -q 'CanvasColor = Color3.fromRGB(156, 156, 156)' '$MOD'"
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
chk "footer v4.7.9" "grep -q 'Preview Kit v4.7.9' '$PRE'"

echo "== 5. GAME SCRIPTS (HARAM disentuh) =="
chk "Games/*.lua identik dengan baseline ec0f3a1" \
	"test -z \"\$(cd '$ROOT' && git diff ec0f3a1 -- Games/)\""

echo
echo "HASIL: $PASS lolos, $FAIL gagal"
[[ "$FAIL" == "0" ]] && echo "🎉 SEMUA CHECK LOLOS" || exit 1

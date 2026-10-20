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
	"grep -q 'AccentColor = Color3.fromRGB(218, 68, 255)' '$LIB' && grep -q 'BackgroundColor = Color3.fromRGB(18, 18, 18),' '$LIB' && grep -q 'MainColor = Color3.fromRGB(33, 33, 33),' '$LIB' && grep -q 'OutlineColor = Color3.fromRGB(61, 61, 61),' '$LIB' && grep -q 'CornerRadius = 15,' '$LIB'"
chk "wallpaper v3 default di LIBRARY (0.80 + canvas 0.045) + GROUP 30% (v4.6.4)" \
	"grep -q 'BackgroundImageTransparency = 0.80' '$LIB' && grep -q 'GroupContrast = 30,' '$LIB' && grep -q 'CanvasColor = Color3.new(0.045' '$LIB' && grep -q 111593326989465 '$LIB'"
chk "group HITAM + contrast 30 baseline tetep (v4.6.5)" \
	"grep -q 'GroupColor = Color3.fromRGB(0, 0, 0), -- override warna kartu = HITAM' '$LIB' && grep -q 'GroupContrast = 30,' '$LIB'"
chk "v4.6.6: wallpaper layer BACK + window/canvas full (kartu 100% solid)" \
	"grep -q 'BackgroundImageLayer = \"back\"' '$LIB' && grep -q 'CanvasTransparency = 1,' '$LIB' && grep -q 'Layer = \"back\"' '$MOD' && grep -q 'Canvas = 1,' '$MOD'"
chk "v4.6.7: NGGAK ada preset/combo yang pindah ke layer front (jebakan)" \
	"! grep -q 'Layer = \"front\"' '$MOD' && ! grep -q 'Combo(\"Stretch\", \"front\")' '$MOD'"
chk "v4.6.7: preset Load() nggak matiin GroupColor/CanvasColor custom user" \
	"! sed -n '/local function Load/,/SafeNotify/p' '$MOD' | grep -qE 'S\.(Group|Canvas)Color'"
chk "resep v3 jadi default di MODULE (DEFAULTS)" \
	"grep -q 'Transparency = 0.80' '$MOD' && grep -q 'Contrast = 30' '$MOD' && grep -q 'GroupColor = Color3.fromRGB(0, 0, 0)' '$MOD' && grep -q 'CanvasColor = Color3.new(0.045' '$MOD'"
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
chk "footer v4.6" "grep -q 'Preview Kit v4.6' '$PRE'"

echo "== 5. GAME SCRIPTS (HARAM disentuh) =="
chk "Games/*.lua identik dengan baseline ec0f3a1" \
	"test -z \"\$(cd '$ROOT' && git diff ec0f3a1 -- Games/)\""

echo
echo "HASIL: $PASS lolos, $FAIL gagal"
[[ "$FAIL" == "0" ]] && echo "🎉 SEMUA CHECK LOLOS" || exit 1

# N3V4 — Design Notes

Catatan keputusan desain + temuan teknis. **Baca ini dulu sebelum lanjut kerja.**

---

## 🎯 v4.8.2 — POPUP BUKA/TUTUP = RASA WINDOW (sempurna atau tidak sama sekali)

User: "gue mau kayak buka tutup window loh ... ini jelek banget atau jangan
ada animasinya pas hilang ... kalo emang lu bisa sempurna ya lu benerin".
Verdict v4.8.1: fade CanvasGroup + scale-down saat tutup masih terbaca jelek
(mengecil sambil memudar ≠ bahasa visual window). Pilihan user dikasih dua
(sempurna atau hapus animasi tutup) — gue ambil jalur SEMPURNA: popup sekarang
pakai sistem fade yang SAMA PERSIS sama window open/close.

Implementasi (nol duplikasi, sesuai aturan code-sampah):
- FadeInstance (lokal CreateWindow sejak v4.7.7) DIPROMOSI jadi
  Library:FadeInstance (module level, ~L2453) + helper baru Library:FadeTree
  (klasifikasi GuiObject/Image/Text/ScrollingFrame/UIStroke + loop subtree).
- Window:Toggle sekarang satu baris: Library:FadeTree(MainFrame, Opening,
  CanCapture, TopBar). Loop + tabel properti lokal lama DIHAPUS.
- Popup V2: CanvasGroup (PopupContent) & UIScale (PopupScale) DIHAPUS total.
  Buka = Dropdown:Refresh() dulu (state selected jadi rest value) lalu
  Library:FadeTree(PopupFrame, true, true). Tutup = FadeTree(false, true) +
  overlay fade + destroy setelah WindowAnimationInfo.Time. Durasi otomatis
  sama dengan window (knob ST_AnimTime / resep 0.10s user).
- Bonus: ScrollingFrame ikut ke-fade (ScrollBarImageTransparency) biar
  scrollbar nggak nongol duluan.

Sweep bahasa pass-3: komentar INLINE (setelah kode) Indonesia di library
(36 baris) diterjemahkan; guard bahasa check.sh diganti pola '--.*\b(...)\b'
biar komentar inline ikut ke-scan (pass 1-2 dulu cuma scan komentar
awal-baris).

## 🎯 v4.8.1 — POPUP V2 MULUS, WARNA IKUT THEME, CODE ENGLISH

Tiga keluhan user atas v4.8.0, tiga akar:
1. "Animasi kaku / ga mulus": popup cuma nge-tween scale + overlay; frame &
   isi nongol INSTAN (pop-in) dan hilang INSTAN (pop-out). Fix: isi popup
   dibungkus CanvasGroup (PopupContent) — GroupTransparency 1->0 (buka) /
   0->1 (tutup) + BackgroundTransparency frame + UIScale + overlay, empat
   tween serentak di Library.TweenInfo; destroy SETELAH tween kelar.
   CanvasGroup = satu properti buat fade seluruh subtree = mulus & murah.
2. "Ada bug": klik luar nggak nutup popup. Penyebab: overlay TextButton
   ke-set Active=false (copas pola dialog upstream) => MouseButton1Click
   mati total. Fix: Active=true. (Catatan: dialog upstream punya pola sama;
   OutsideClickDismiss dialog juga kena — belum disentuh, bukan keluhan.)
3. "Jangan hardcode color": footer button popup & dialog make TextColor3 =
   Library.Scheme.* PAS DIBUAT = snapshot Color3 = ganti theme nggak ikut.
   Fix: string theme ("BackgroundColor"/"FontColor") yang ke-register di
   color registry => UpdateColorsUsingRegistry() ikut ngubah. Jawaban buat
   user: YA sekarang selected dot (AccentColor), row (MainColor), icon
   (FontColor/AccentColor), button, scrollbar (OutlineColor), overlay
   (DarkColor), frame (BackgroundColor) SEMUA ikut theme.

Aturan baru user: KODE = INGGRIS (komentar + string UI library), obrolan
gue-lu tetap Indonesia. v4.8.1 nerjemahin SELURUH komentar Indonesia di
Library/N3V3-NoObfus.lua (±235 baris, 2 pass, line-stable) + string UI
(Bersihkan/Selesai -> Clear/Done, placeholder "Select..."). check.sh punya
guard bahasa: komentar library nggak boleh kena kosakata Indonesia inti.
Preview/module = testbed berdua → label UI & changelog tetap Indo (keputusan
gue, user boleh veto).

## 🎯 v4.8.0 — DROPDOWN V2 = versi POPUP (V1 tidak disentuh)

Request user: dropdown model popup/dialog, V1 tetap ada (nama API
AddDropdownV2), selected tampil di popup sebagai summary, list scrollable di
bawahnya, versi image/text-only, lengkap & tanpa bug.

Desain (dengan masukan, bukan yesman): popup = modal TERPUSAT (bukan menu
anchored) biar list panjang nggak overflow window; bahasa visual pakai pola
dialog yang udah ada (overlay gelap 0.5, scale-in, corner+outline theme);
summary dirapihin dari contoh user: baris 1 "Total Selected: n/limit"
(limit = Max kalau Multi+Max, else jumlah item), baris 2 "List Selected:",
baris 3 nama-nama digabung " - " (wrapped); apply LANGSUNG saat klik (bukan
confirm button) biar nggak ada state basi, footer cuma [Bersihkan][Selesai];
single-select auto-close setelah milih (standar dropdown); indikator selected
= dot accent + row MainColor 0.55 (bukan glyph, biar nggak tergantung nama
icon); item disabled = text redup + nggak clickable; Max ditegakkan diam-diam
(pencetan lewat batas diabaikan).

Item: string = text-only; table { Text, Icon?, Disabled? } = versi icon
(lucide per item via Library:GetCustomIcon). Info.ItemIcons = map text->icon
buat yang malas nulis table. Info.Icon = icon header popup kanan-atas
(gaya dialog v4.7.9). Info: Multi, Max, ListHeight, Placeholder, Tooltip.

API element: SetValue(v), SetSelected(list) [multi], SetItems(list, icons?),
GetActiveValues(retCount), Clear(), OpenPopup/ClosePopup(instant),
SetDisabled/SetVisible/SetText/OnChanged/Destroy. Registry: Options[Idx],
Type = "DropdownV2", masuk Groupbox.Elements (ikut dependency/resize).

Integrasi penting: Window:Toggle(close) nutup semua popup V2 DULUAN sebelum
fade (biar instance popup nggak ke-capture TransparencyCache = glitch buka
berikutnya). Parent popup dicari dengan walk-up dari Container sampai anak
Library.ScreenGui (= MainFrame window itu), jadi aman multi-window.
ZIndex: overlay 9100 / frame 9101 / isi 9102 (di atas dialog 9000-an).

Lokasi: Templates.DropdownV2 (~L546), NormalizeDropdownItem +
Funcs:AddDropdownV2 (~L8352+, sebelum bridge AddViewport), integrasi Toggle
(~L12995). Preview: 2 box demo di tab Components (simetri 4/4 dijaga).

## 🎯 v4.7.9 — DIALOG: BUTTON CONFIRM KELIATAN + ICON OPSIONAL

Bug (screenshot user: dialog "Konfirmasi Aksi" & "Reset Semua Config?" tanpa
button): AddFooterButton nggak manggil Dialog:Resize(). Resize awal (akhir
AddDialog) jalan saat FooterButtonsList masih kosong => ButtonsHolder dan
separator di-set Visible=false, dan tombol yang ditambah setelah itu masuk
holder hidden. Library EMANG udah punya mekanisme button lengkap
(AddFooterButton + Variant Primary/Secondary/Destructive/Ghost + WaitTime +
progress bar) — cuma visibility-nya yang bocor. Fix: AddFooterButton &
RemoveFooterButton manggil Dialog:Resize() (total panggilan Resize = 6).

Icon dialog (request user: "opsi no icons dan icons di pojok kanan atas mirip
notif"): Info.Icon = nama lucide => ImageLabel 18x18, ImageColor3 =
Info.IconColor or AccentColor, LayoutOrder 2 di TitleRow (kanan); TitleLabel
LayoutOrder 1 dengan Size 1,-24 biar nggak ketabrak. Info.Icon nil/false =
tanpa icon. Preview demo 3 varian: with-icon accent, with-icon custom color,
no-icon.

## 🐛 v4.10.1 — BUG #29: UIRotation itu kelas HALU (UI rusak total)

Log user: `Unable to create an Instance of type "UIRotation"` dari
New() di AddGroupbox -> groupbox PERTAMA gagal ke-build -> seluruh
UI preview rusak ("lah rusak co"). Gue yang salah: nulis v4.10.0
pakai kelas "UIRotation" yang GA ADA di Roblox (gue kira pasangan
UIScale). Buktinya ada di library sendiri: rotate GUI itu properti
NATIVE `GuiObject.Rotation` (panah collapse pakai Rotation = 180).

Fix: Anim.Rot = ImageLabel icon itu sendiri; tween property
`Rotation` (derajat) langsung. Nol instance tambahan, perilaku
animasi identik (zoom via UIScale, tilt via Rotation). Checker
sekarang nge-pin `Rot = BoxIconLabel` DAN nge-ban `New("UIRotation"`
di library biar halusinasi kelas gini ga lolos lagi.

Lesson: nama kelas Roblox harus diverifikasi terhadap pemakaian di
library / docs, jangan dari ingetan.

## ✨ v4.10.0 — ICON ANIM: icon group zoom + miring saat hover

Request user: "ketika cursor gue mengarah ke group maka icons group
itu kayak sedikit zoom cuma sedikit miring, kalo keluar cursor gue
dari group itu maka jadi semula" + "gue mau setup visualnya seting
manual".

Implementasi library:
- Tiap icon groupbox (AddGroupbox, covers kiri/kanan/nested) dapet
  pasangan UIScale (Scale 1) + UIRotation (Angle 0) di ImageLabel icon.
- Area hover = GroupboxHolder (kartu group seluruhnya), MouseEnter /
  MouseLeave -> Library:PlayIconAnim(Anim, Hover).
- PlayIconAnim: cancel tween lama, bikin 2 tween Quint-out durasi
  IconAnim.Speed ke Scale = 1 + Zoom/100 dan Angle = Tilt (hover),
  atau 1 / 0 (leave). Registry Library.IconAnimRegistry buat reset
  massal saat SetIconAnim({Enabled=false}).
- Guard Anim.Scale.Parent nil = icon udah di-destroy (registry stale
  aman).
- API: Library.IconAnim {Enabled, Zoom=12, Tilt=6, Speed=0.18} +
  Library:SetIconAnim(tbl).

Setup manual (module, groupbox "Font & Animasi" kanan T1 — nempel di
box existing biar simetri tetep 5/5): toggle IA_On, slider IA_Zoom
0-40%, IA_Tilt 0-20°, IA_Speed 0.05-0.6s (Rounding 2), + print & copy
resep icon anim (BuildIconAnim, aturan v4.8.5). DEFAULTS.IconAnim +
Reset scheme manggil SetIconAnim(DEFAULTS.IconAnim).

FPS (user nanya "ramah fps kan?"):
- Glow: tetep SATU koneksi RenderStepped; v4.10.0 nambah idle-skip —
  kalau nilai fade nggak bergerak (cursor di luar window / glow udah
  full fade) nol property write per frame. Write cuma terjadi saat
  fade ramp atau cursor di dalam window.
- Icon anim: tween fire-and-forget (TweenService), biaya hanya saat
  hover enter/leave, bukan per frame. Nggak nambah koneksi stepped.

## 🎯 v4.9.3 — GLOW v4: posisi pas di cursor (bug #28) + bake print user

### Bug #28: glow ~36px di bawah cursor
`UserInputService:GetMouseLocation()` return koordinat WINDOW-space
(termasuk inset topbar ~36px), sedangkan `GuiObject.AbsolutePosition`
itu gui-space (origin di bawah topbar). Holder di-set pakai selisih
dua space yang beda -> offset konstan +inset.Y = glow nongol di bawah
cursor, dan test inside-window juga geser pakai inset yang sama.
Fix satu baris: `GetMouseLocation() - GuiService:GetGuiInset()`
(GuiService sekarang di-require di header library).

### Bake print user (aturan print = bake verbatim)
RESEP GLOW dia: Enabled true, Color putih (255,255,255), Size 400,
Intensity 10, Smooth 5 -> kebake di: Library.CursorGlow defaults,
DEFAULTS.Glow module, fallback BuildGlow, preset "Samar (bawaan)".
Konsekuensi: default glow sekarang putih pinned (bukan ikut accent);
preset "Warna ikut accent lagi" tetep ada buat balik ke Color=false.
Slider GW_Size max dinaikin 400 -> 600 biar default ga mentok tepi.
Preset lain disesuaikan: Halus 5%/260px, Jernih 25%/320px.

## 🔧 v4.9.2 — GLOW v3 (haze radial samar) + BUG #27 (knob mati runtime)

### Bug #27 (memalukan, murni salah gue)
Knob glow v4.9.0/4.9.1 gue sisipkan di dalam `Try("Settings: info")`
TAPI sebelum `local Box = ...` box itu sendiri -> callback ngeref
upvalue `Box` yang NIL -> `nil:AddToggle` error -> `Try` = pcall nelan
error (cuma warn di Output yang ga dibaca user) -> SELURUH isi Try mati:
knob glow GA PERNAH render DAN box "Resep Tema" (print/copy tema) ikut
hilang. Gejala dari user: "kasih tombol seting gue jir biar gue yang
atur cok. buset dah ga ngerti tadi tadi anjir" — settingnya emang ga ada.
Pelajaran: grep-check text doang ga nangkep nil-runtime; sekarang checker
nge-pin `grep -A2 'Try("Settings: info"'` harus langsung ketemu
`local Box =` nya sendiri, dan knob pindah ke Try mandiri.

### Visual (teriakan user: terlalu bulat, lebih samar, pudar->jelas di
tengah, jangan terlalu lebar)
- Roblox GUI TIDAK punya radial gradient primitive; asset image external
  ga bisa diverifikasi offline. Solusi: 16 micro-circle, falloff kuadrat
  w(t)=(1-t)^2 ternormalisasi (sum weight = 1 => opacity tengah persis
  Intensity%). Step alpha antar layer di default 5% = ~0.2% => haze
  kontinu, bukan ring (v4.9.0 jelek karena 6 layer step 34%->3%).
- Size default 280 -> 180 px; slider 60-400.
- Clip container CursorGlowClip tetep (v4.9.1).

### Setting yang beneran hidup (permintaan "tombol seting gue")
- T1 kiri groupbox baru "Cursor Glow": toggle GW_On, picker GW_C,
  slider GW_Size (60-400, default 180), GW_Int (kejelasan tengah,
  default 5), GW_Smooth; ditutup print + copy resep glow (aturan v4.8.5,
  builder BuildGlow() dipakai juga oleh BuildResep biar single source).
- T1 kanan groupbox baru "Preset Glow": 5 tombol preset (Samar 5/180,
  Halus 10/220, Jernih 20/260, Matikan, Warna ikut accent lagi) +
  SyncKnobs via Library.Options.*:SetValue biar slider ga stale.
- Simetri T1: 4/4 -> 5/5.

## 😤 v4.9.1 — GLOW v2: 1 circle, opacity 5%, di-clip dalam window

Screenshot user v4.9.0: glow BOCOR keluar window (MainFrame nggak punya
ClipsDescendants -> circle 280px nongol di luar border) dan stack 6
lingkaran keliatan sebagai RING bertingkat = "jelek banget cok".
Perintah user: "cukup 1 saja woi", "transparansi dikit saja cok 5%
saja", "kok keluar window sih?".

Fix total:
- Stack 6 layer DIHAPUS -> SATU Frame circle (CursorGlowFrame).
- Semantik Intensity diubah: persen OPASITAS langsung (alpha =
  Intensity/100 x Fade). Default 5 (alpha 0.05) = pool cahaya subtle.
- Container clip "CursorGlowClip" seukuran MainFrame (ZIndex 0,
  ClipsDescendants + UICorner radius window) -> glow ke-potong persis
  di rect window termasuk sudut bulet; shadow/neon stroke MainFrame
  tetep aman karena clip-nya di container sendiri, bukan MainFrame.
- Holder (penumpang posisi cursor) sekarang anak clip container.
- UpdateColorsUsingRegistry recolor single frame. Knob module tetep 5
  (label intensity diperjelas "/ opacity", default slider 5).

## ✨ v4.9.0 — CURSOR GLOW (fitur baru, request user)

Request: "kalo masuk ke window gue kayak ada visual effect... di
background di belakang semua group button toggle dll ada cahaya visual
effect yang sesuai gerakan cursor gue". Warna "bisa gue seting nanti".

Implementasi:
- Holder Frame "CursorGlow" parent MainFrame, ZIndex 0 = slot antara
  wallpaper back (Image -2 / Overlay -1) dan semua konten (>= 1) ->
  glow di BELAKANG group card/button/toggle/sidebar, keliatan lewat
  card semi-transparan (GroupTransparency 0.5) & canvas transparan.
- Nol asset eksternal: 6 lingkaran bertumpuk (UICorner scale 0.5),
  diameter frac {0.33..1} x Size, alpha table {0.34..0.03} x Intensity
  -> falloff halus tanpa banding kasar di bg gelap.
- Satu koneksi RenderStepped se-session (GiveSignal): posisi glow
  lerp eksponensial ke cursor (knob Smooth /s) = trail lembut; fade
  in/out 10/s pas cursor masuk/keluar rect window; MouseEnabled false
  (mobile) = glow off otomatis.
- Warna default IKUT AccentColor (pola v4.8.6: Color = false berarti
  follow theme; UpdateColorsUsingRegistry recolor tiap ganti theme).
  Color picker di module = override Color3.
- Knob (Library.CursorGlow + SetCursorGlow): Enabled / Color / Size
  (80-600) / Intensity (0-100%) / Smooth (1-30). Module: groupbox
  Window (simetri groupbox tetap 4/4), DEFAULTS.Glow, Reset scheme,
  print masuk BuildResep (RESEP WALLPAPER+SURFACE + blok CURSOR GLOW).

## 🐛 Bug #26 — sliver "bocor" pas collapse (regression v4.8.8, FIXED v4.8.9)

Screenshot user: group collapsed (Status Session, Activity Feed)
nampilin strip setengah glyph di bawah title selagi frame shrink.
Root cause: v4.8.8 ikut nghapus flip `GroupboxContainer.Visible = not
Collapsed` — padahal flip itu yang BENER buat arah collapse. Tanpanya,
selama tween shrink 0.2s isi statis ke-clip makan dari bawah -> tepi
clip nyisain band tipis puncak elemen pertama = sliver bocor. (Tinggi
sliver beda-beda di screenshot = frame mid-tween, bukan stuck.)

Kombinasi final (v4.8.9): ClipsDescendants TETEP di holder groupbox +
tabbox (kunci sync expand: isi ke-reveal bareng tepi frame turun, nol
numpah); flip Visible instan BALIK untuk collapse (container + garis
title) -> nggak ada isi yang hidup selagi shrink = nol sliver. Dua arah,
dua perlakuan, masing-masing yang paling bener.

## 🐛 Bug #25 — collapse/expand groupbox desync (FIXED v4.8.8)

Laporan user: "gue buka group text di dalamnya ga singkron, isinya dulu
yang ke bawah sedangkan groupnya telat dikit" — ketemu pas buka-tutup
panah collapse group (yang bentuknya mirip dropdown; bukan dropdown
select element).

Root cause: Groupbox:Resize tween Size GroupboxHolder 0.2s Quad Out,
TAPI (a) holder nggak punya ClipsDescendants, dan (b) SetCollapsed flip
GroupboxContainer.Visible INSTAN + Resize flip GroupboxLine.Visible
INSTAN. Expand: isi langsung render di layout final bahkan numpah ke
luar frame yang masih pendek -> frame nyusul 0.2s kemudian = desync.
Collapse: isi ngilang instan, frame shrink sendirian.

Fix (satu mekanisme): ClipsDescendants = true di holder groupbox DAN
holder tabbox (keluarga bug yang sama: isi tab switch juga pernah
numpah saat frame tween); hapus kedua flip Visible instan (container +
garis title). Isi ke-clip persis di tepi bawah frame sepanjang tween ->
reveal & hide gerak BARENG tepi frame (satu tween = sinkron). Garis
title sembunyi sendiri saat holder 34px (ke-clip); title + panah tetep
keliatan (di dalam 34px). Hit-test Roblox respect clip, jadi elemen di
group collapsed nggak bisa kepencet invisibly. Outline aman: AddOutline
= UIStroke (Border, tepi dalam) = render milik holder sendiri, bukan
descendant yang ke-clip. Popup dropdown/colorpicker/tooltip aman:
parent-nya window/ScreenGui, bukan holder. Checker pin: 2 clip ada +
dua flip instan hilang.

## 🔒 v4.8.7 — RESEP TAB v4 = FINAL TERKUNCI (print user 16:55)

IconCardEnabled true · Padding 2 · Thickness 1 · Transparency 0.00
(garis SOLID; warna tetap ikut OutlineColor theme per v4.8.6) ·
Radius 5 · TabBackgroundTransparency 0.85 · ActiveBackground 0.60
hitam · HoverZoom 1.25 · ActiveZoom 1.25 · ZoomTime 0.20 ·
TabHoverZoom true.

User: "oke terakhir bro ini resep yang pas bro" -> dikunci sebagai
default di Library.TabAppearance + Settings.DEFAULTS.Tab; checker pin
nilai v4 (lib+mod). Resep v3 (v4.8.5: padding 3 / 0.36 / 0.90) resmi
digantikan.

## 🎨 v4.8.6 — WARNA GARIS CARD IKUT OUTLINE THEME (knob warna dihapus)

User: "collornya biar ikut outline saja bro! jangan bikin susah pas mau
banyak theme ke depan!" — IconCardColor (knob Color3) DIHAPUS total dari
library + module + print RESEP TAB. UIStroke card sekarang
Color = "OutlineColor" (theme string; FillInstance daftarin ke registry
-> UpdateColorsUsingRegistry recolor otomatis tiap ganti theme).
ApplyTabAppearance nggak nyetel Color lagi (registry yang urus).
Catatan jujur: angka 135,135,135 resep v3 kemarin jadi tidak dipakai —
mulai v4.8.6 garis ikut outline theme (65,62,62 di RESEP v7), persis
permintaan user. Knob card sisa 5: on/off, tebal, transparansi, napas,
radius.

## 🔒 v4.8.5 — RESEP TAB v3 = TERKUNCI (screenshot user + warna dari chat)

Card recipe v2 (menggantikan baseline v4.8.4): tebal 1px · transparansi
0.36 · napas 3px · radius 5px · garis Color3.fromRGB(135,135,135) ·
bg semua tab 0.90. (Zoom/aktif tetep: 0.60 hitam, 1.25/1.25, 0.20.)
Bake di Library.TabAppearance + Settings.DEFAULTS.Tab; checker dikunci
ke nilai v3 (lib+mod).

Fix UX (user: "gimana gue mau copy anj?"): tombol print resep tab
sebelumnya nyelip di BAWAH TEST/DEBUG di groupbox kanan ("Tab Aktif &
Zoom"), dan tab nggak punya tombol copy padahal tema & wallpaper punya
pasangan print+copy. Sekarang print+copy resep tab nempel DI groupbox
"Tab Card & Bg" (sebelah knob card); copy pakai CopyClip (setclipboard +
fallback Output) — pola yang sama persis kayak Copy resep tema. Tombol
print lama di groupbox kanan DIHAPUS (pindah, bukan duplikat).

## 🎯 v4.8.4 — TAB ICON CARD (halo stroke DIGANTI garis kotak simetris)

Request user ("bukan stroke jelek jir!"): icon tab jangan di-halo glyph,
tapi dikasih GARIS KOTAK SIMETRIS (card outline) di seputar ICON doang —
bukan box full tab — transparansi ±30%. User bilang "gas" tanpa jawab 2
pertanyaan desain -> gue yang putusin (alasan di bawah), dia tinggal dial
di preview kalau mau geser.

Keputusan desain:
- Card = Frame kosong (BackgroundTransparency 1) + UICorner + UIStroke mode
  Border. Cuma GARIS tanpa isi ("garis kotak" kata user, "bukan full").
- Card = ANAK TabIcon (anchor+position 0.5/0.5) -> ikut UIScale zoom
  hover/aktif: napas card tetap simetris di semua level zoom. Kalau card
  diam sementara icon zoom 1.25, gap berubah = nggak simetris = melanggar
  aturan simetris user.
- Halo stroke glyph DIHAPUS TOTAL (bukan disimpen mati): satu implementasi,
  nol code sampah. Nilai TAB v2 v4.8.3 untuk stroke (1.5/0.53/hitam)
  digantikan; tebal 1.5 + warna hitam dipindah jadi default card.
- Default: Enabled true · Padding 4px (napas) · Thickness 1.5px ·
  Transparency 0.30 (angka user) · Radius 6px · Color hitam.

Knob baru: IconCardEnabled / Padding / Thickness / Transparency / Radius /
Color di Library.TabAppearance (+ SetTabAppearance otomatis support).
Knob stroke lama DIHAPUS di lib+module+print RESEP TAB. Detector
library-lama (module+preview) sekarang juga cek IconCardEnabled.

Lokasi: helper Library:CreateTabIconCard (pengganti CreateTabIconStroke),
ApplyTabAppearance blok Rec.Card, TabRec.Card (AddTab+AddKeyTab), module
DEFAULTS.Tab + groupbox "Tab Card & Bg" (toggle+warna+tebal+transparansi+
napas+radius) + tombol TEST/DEBUG/Print diupdate. Preview: changelog +
footer v4.8.4. Checker: 57 cek (halo negative-grep + knob card lengkap).

## 🔒 v4.8.3 — RESEP v7 + RESEP TAB v2 = TERKUNCI (print user 00:41-00:46)

THEMA v7:
  Accent 218,68,255 · Background 15,15,15 · Main 36,36,36 · Outline 65,62,62 ·
  Font 255,255,255 · radius 10 · DPI 100 · animasi ON · durasi 0.10s (tetep)
WALLPAPER/SURFACE v7:
  Image 111593326989465 · Transparency 0 · Stretch · tint 148,148,148 (0.58) ·
  Layer back · Overlay ON hitam 0.40 · Window 1 · Canvas 1 · Group 0.5 ·
  Contrast 40 · GroupColor hitam · CanvasColor 119,119,119 (0.465)
TAB v2:
  stroke 1.5px / 0.53 / hitam · bg tab 1 · bg aktif 0.60 hitam ·
  HoverZoom 1.25 · ActiveZoom 1.25 · ZoomTime 0.20 · TabHoverZoom true

Konversi float dump -> fromRGB: 0.58*255=147.9->148; 0.465*255=118.6->119
(selisih <0.002 = tak terlihat; print balik bakal stabil di integer ini).
Bake di: Library.Scheme/Templates/WindowInfo defaults, Library.Surface,
Library.TabAppearance, Settings.DEFAULTS (+ tombol Reset scheme module).
Checker mengunci nilai v7 (check theme/resep/tab di-update).

Antrian "card outline icon tab" (request di atas) SUDAH dieksekusi -> v4.8.4.

## 🔒 v4.7.8 — RESEP DURASI BUKA/TUTUP = TERKUNCI (user: "10% bagus!")

Library.WindowAnimationInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
DEFAULTS.AnimTime = 0.10 (slider ST_AnimTime = 10%)

## 🎯 v4.7.7 — ANIMASI BUKA/TUTUP WINDOW (fix, bukan fitur)

Keluhan user: buka terlalu lama, kadang glitch pas baru kebuka, "biasanya ada
layar hitam" pas buka. Root cause di Window:Toggle + FadeInstance lama:
1. Buka = 1.5x FadeTime: FadeInstance(MainFrame) duluan, task.wait(FadeTime/2)
   nge-block, konten baru fade setelahnya => shell/permukaan gelap nongol
   duluan = fase LAYAR HITAM.
2. TweenService:Create per properti per instance, ratusan tiap toggle, dibuat
   ulang setiap kali => hitch/frame drop pas baru kebuka.
3. `if Fading then return` nelan pencetan cepet; Fading dilepas di FadeTime
   padahal konten masih fade sampai 1.5x => close di jendela itu nge-capture
   nilai MID-TWEEN ke TransparencyCache => rest value basi => glitch abis buka.
4. Open pertama: cache kosong => semua skip => window POP instan tanpa fade.

Fix (rewrite FadeInstance + blok animasi Toggle, tetap 1 implementasi):
- Fade BARENGAN semua elemen (buka & tutup), total = FadeTime persis.
- 1 tween gabungan per instance, di-cache di FadeTweenCache (weak key) dan
  dipakai ulang; Sig = TweenInfo + target props => ganti durasi via knob
  langsung invalidate tween lama. Steady state = cuma Play() (mulai dari
  nilai sekarang => reversal mid-fade mulus).
- FadeToken: finalizer (Visible/Fading) cuma jalan utk toggle terakhir.
- Cache rest HANYA di-capture pas rest (CanCapture = not Reverse); elemen
  pertama ketemu di-capture + di-set 1 tanpa jeda frame => open pertama fade.
- Default WindowAnimationInfo 0.35 -> 0.20 (L218). Knob ST_AnimTime di
  module (Font & Animasi, 5-60% detik), ikut ke-print di RESEP THEMA,
  DEFAULTS.AnimTime = 0.20, dipulihkan tombol RESEP USER (disetujui).
Lokasi: FadeInstance+Toggle ~L12864+ (CreateWindow), FadeToken L10491,
FadeTweenCache L2434, clear di Unload L14542, print versi v4.7.7 L1635.

## 🔒 RESEP TAB = TERKUNCI (print user 18:21, v4.7.6)

Library:SetTabAppearance({
	IconStrokeThickness = 1, IconStrokeTransparency = 0.20,
	IconStrokeColor = Color3.fromRGB(107, 0, 181),
	TabBackgroundTransparency = 1, ActiveBackgroundTransparency = 0.85,
	ActiveBackgroundColor = Color3.fromRGB(128, 128, 128),
	HoverZoom = 1.30, ActiveZoom = 1.40, ZoomTime = 0.20,
})
Library.Animations.TabHoverZoom = true

Refactor v4.7.6 (perintah user: "jangan ada code sampah / duplikasi, biar file
nggak besar"): halo stroke + UIScale = SATU helper Library:CreateTabIconStroke;
zoom = SATU helper Library:TweenTabZoom; blok inline duplikat di AddTab dan
AddKeyTab DIHAPUS (library -40 baris). Zoom lewat UIScale (transform-only,
lebih mulus dari tween Size).

## 🎯 v4.7.0 — UPGRADE TAB SIDEBAR (baseline, BELUM locked — nunggu print user)

Diskusi user: stroke di icon (biar keliatan), background dikit di semua tab,
zoom hover + zoom tab aktif. Scope: SIDEBAR tabs aja (pilihan user), borongan
sekali paste (pilihan user), bg tab aktif = tint accent (pilihan user).

Baseline (Library.TabAppearance + Settings.DEFAULTS.Tab):
  IconStrokeThickness 1 px | IconStrokeTransparency 0.40 | IconStrokeColor hitam
  TabBackgroundTransparency 0.70 (semua tab, MainColor)
  ActiveBackgroundTransparency 0.55 | ActiveBackgroundColor accent 218,68,255
  HoverZoom 1.12 | ActiveZoom 1.08 | ZoomTime 0.15s (Quad Out)
  Matinya: Library.Animations.TabHoverZoom = false

KESALAHAN PALING BODOH (v4.7.5): semua patch tab v4.7.0-7.4 masuk ke
Window:AddKeyTab (fungsi tab key-picker), BUKAN Window:AddTab (pembuat tab
sidebar kiri). Gejala: rec=0 di DEBUG, zoom/stroke/bg mati total di tab
sidebar walau library baru. User bener terus dari awal; gue yang salah
baca struktur file (dua fungsi AddTab* dengan bentuk kode mirip, beda
indent). v4.7.5: AddTab asli kepatch penuh; AddKeyTab tetep kepatch juga
(konsisten). Pelajaran: verifikasi fungsi target pakai boundary function,
bukan kemiripan blok kode.

v4.7.4: gate zoom dulu `Library.Animations.TabHoverZoom` langsung — tabel
Animations bisa ke-REPLACE sama WindowInfo.Animations caller (preview cuma
bawa 5 bool) -> key ilang -> nil -> zoom mati. Sekarang Library:ZoomTabEnabled()
(nil = ON), preview eksplisit kirim TabHoverZoom=true, CreateWindow manggil
ApplyTabAppearance() + print "window ready: tabVisuals=N" sebagai bukti
otomatis, dan tombol TEST ikut nyalain toggle stroke/bg-aktif/animasi.

BUG PALING MEMALUKAN (v4.7.3, permintaan maaf terbuka ke user):
v4.7.0-7.2 punya `local TabRec = {...}` DI DALAM do-block AddTab, sedangkan
`TabRec.Tab = Tab` ada di luar do -> nil-global runtime error SETIAP AddTab.
Efek: tab kebentuk setengah (button+icon render) tapi rec nggak ke-link ke
Tab object -> hover/show/hide zoom & apply stroke jalan ke objek yang
setengah mati = SEMUA efek tab kelihatan "ga work" walau library baru,
slider bener, dan user nggak salah apa-apa. Ketahuan dari warn Luau
LocalShadow pas ngerjain v4.7.3. Fix: local TabRec di scope luar do.
Sekaligus stroke diganti halo ImageLabel (bukan UIStroke sprite-atlas) dan
zoom diganti tween Size (bukan UIScale) = nol quirk render.

CATATAN UX (v4.7.2): user DUA KALI mentokin slider transparency ke 100%
(stroke transparency, bg tab aktif) lalu marah "ga work" — 100% transparency
= ILANG. Label slider sekarang "(100% = ILANG)" + ada tombol TEST efek
keliatan + library print versi sendiri di Output tiap require (anti-debat
"lu paste nggak sih"). Arah knob: makin KECIL transparency = makin KELIATAN.

Mekanik: UIStroke di ImageLabel icon ngikut alpha glyph (outline bentuk icon,
bukan kotak). UIScale per icon buat zoom. Library.TabVisuals = rec per tab;
ApplyTabAppearance() sync stroke/bg/scale semua tab (dipanggil SetTabAppearance
+ Show/Hide). Print LENGKAP sekarang nambah section RESEP TAB.

## 🔒 RESEP v5 = DEFAULT TERKUNCI (print LENGKAP user, 2026-10-20, v4.6.8)

```lua
Library.Scheme.BackgroundColor = Color3.fromRGB(15, 15, 15)
Library.Scheme.MainColor = Color3.fromRGB(45, 45, 45)   -- v6 (print user 15:42)
Library.Scheme.OutlineColor = Color3.fromRGB(65, 65, 65) -- v6
-- accent 218,68,255 / font 255 / radius 15 tetep
Library:SetWallpaper({
	Image = "111593326989465", Transparency = 0, ScaleType = "Stretch",
	Color = Color3.fromRGB(195, 195, 195), Layer = "back",
	Overlay = true, OverlayColor = Color3.fromRGB(0, 0, 0), OverlayTransparency = 0.55,
})
Library:SetSurface({
	WindowTransparency = 0.90, CanvasTransparency = 1.00,
	GroupTransparency = 0.35, GroupContrast = 40,
	GroupColor = Color3.fromRGB(0, 0, 0), CanvasColor = Color3.fromRGB(156, 156, 156),
})
```
Catatan: group 0.35 = PILIHAN user sendiri via slider di layer back (bukan veil
front) — menimpa baseline lama "group solid 0". Resep v4 (bg18/main33/outline61,
wallpaper 0.80) = sejarah, ada di bagian bawah.

FIX v4.6.9: CreateWindow dulu seed Library.Surface UNCONDITIONAL dari
Templates.Window (GroupTransparency 0 / GroupContrast 30) -> resep user
(0.35/40) ke-stomp tiap paste baru = "group kok ga transparan padahal udah
gue setting". Sekarang seed conditional ( cuma kalau caller eksplisit ngirim
field ). Templates.Window disync ke angka v5 sebagai double-safety.
PREVIEW v4.6.9->v4.6.10: percobaan "theme-only" lewat SetWallpaper/SetSurface
di preview itu SALAH: state wallpaper/surface GLOBAL per-Library -> window
setingan user ke-stomp window 0/canvas 0 ("jadinya jelek cok"). v4.6.10:
preview OFF TOTAL (PREVIEW_ENABLED=false, early return; nol window nol stomp).
"hapus kecuali theme" = yang hidup cuma N3V4_UISettings (theme+wallpaper).
WindowTransparency default jadi 1 (user: "window dan canvas harusnya 100").

FIX v4.6.11: kartu surface yang NESTED (tabbox di dalam groupbox, dst) dulu
numpuk lapis transparency kedua -> komposit gelap = "nested box ga ikut
transparan". Sekarang Library:IsInsideSurfaceCard(): nested = transparency 1
(ngikut induk, identitas dari outline), top-level = Surface + SurfaceGroups.
Depbox dulu kelihatan aman karena parent-nya sibling kartu (BoxHolder),
bukan di dalam kartu.

FIX v4.6.8: navbar bawah (BottomBackground) dulu UICorner FULL radius + tinggi
20+radius -> corner atas ikutan bulat = notch/garis "bablas ke atas" waktu radius
diputer dari tab Theme. Sekarang: tinggi 20 + UICorner bottom-only lewat
Library.SpecificCorners (SetCornerRadius tetep update bottom, top persegi).

## 🎯 Preferensi user (yang udah diucapin eksplisit)

| Preferensi | Detail | Status |
|---|---|---|
| **SIMETRIS** | "gue suka ui yang simteris banget ok? simteris." | 🔒 HARD RULE — lihat catatan penting di bawah |
| **Corner radius** | 10 dulu ("ini bagus!"), terus user seting ulang ke **15** di resep v3 | ✅ **15 sekarang** (library + templates) |
| **Group 30% lebih jelas** | "dulukan 10% sekarang coba bikin 30% lebih jelas biar ga terlalu aneh ... dan ingat itu ya" | 🔒 **GroupContrast 30 + GroupColor AUTO** |
| **Motion level** | Balanced — spring + micro-interaction; efek mahal (blur/glow/ripple) opsional & auto-off di mobile | 🔒 Kekunci |
| **Icon = lucide** | "pake icons yang ada di library gue jir. di situ ada link iconsnya kan?" | ✅ **Udah dibenerin** |
| **Arah visual** | Belum diputusin ("abaikan dulu") | ⏳ Pending |
| **Jangan merge** | Semua di branch `arena/c5a10c06-n3-project` | 🔒 Kekunci |
| **API tetap** | `N3-SAE.lua` & `ride-an-pets.lua` harus jalan tanpa diedit | 🔒 Kekunci |

---

## 🐛 v4.6 — 3 BUG LIBRARY (ketemu dari log Studio user, 2026-10-20)

Log user waktu itu: `✅ 26 / ❌ 4`. Empat gagalnya bukan "komponen nggak ada",
tapi **bug beneran di library**. Ketiganya udah dibenerin di
`Library/N3V3-NoObfus.lua`.

### 1. `AddDependencyGroupbox` → "attempt to call a nil value"

`AddDependencyGroupbox` bikin frame dengan:

```lua
BackgroundColor3 = function() return Library:GetGroupSurfaceColor() end,
BackgroundTransparency = ClampTransparency(Library.Surface.GroupTransparency),
...
Library.SurfaceGroups[DepGroupboxContainer] = true
```

Masalahnya `ClampTransparency` itu **local function** yang dideklarasikan
±200 baris DI BAWAH pemakaian. Di Lua, local cuma kelihatan **setelah** baris
deklarasinya — jadi di baris pemakaian namanya ke-resolve sebagai **global nil**
→ `attempt to call a nil value`. (`FillInstance` langsung manggil function
property, makanya error-nya kejadian pas komponen dibuat.)

**Fix:** seluruh blok *Surface & Wallpaper system* (`WallpaperScaleTypes`,
`ResolveScaleType`, `ResolveWallpaperLayer`, `ClampTransparency`,
`Library.Surface*`, `GetCanvasColor`, `GetGroupSurfaceColor`, `ApplySurfaces`,
`SetBackgroundImage`, `SetWallpaper`, `SetSurface`) **dipindah ke atas**, tepat
setelah `New()` / sebelum instance pertama dibuat. Isi blok nggak diubah, cuma
posisinya.

> Ini bug class yang sama kayak v4.3 dulu. Aturannya sekarang: **helper surface
> HARUS di atas semua pembuat komponen.** `tools/check.sh` ngecek urutan ini.

### 2. Viewport 3D → "Instance must be a BasePart or Model."

Di file ada **DUA** `function Funcs:AddViewport`:

| Baris (lama) | API | Nasib |
|---|---|---|
| ~4734 | `Height` / `Spin` / `Interactive` + `SetModel()` (WorldModel) | **ketimpa** |
| ~7899 | `Object` / `Camera` / `Clone` / `AutoFocus` + `assert(Object)` | menang |

Karena dua-duanya nulis ke key tabel yang sama, yang bawah menang → setiap
panggilan tanpa `Info.Object` kena `assert` → komponen gagal dibuat.

**Fix:** bridge. Sebelum definisi yang kedua, versi pertama di-capture:

```lua
local RichAddViewport = Funcs.AddViewport

function Funcs:AddViewport(Idx, Info)
    ...
    Info = Library:Validate(Info, Templates.Viewport)
    if not Info.Object and RichAddViewport then
        return RichAddViewport(self, Idx, Info)   -- API ringan
    end
    ...                                            -- API Object/Camera tetap jalan
```

Dua API hidup bareng, nggak ada yang dihapus.

### 3. Color picker "kadang ga work" + UI makin berat

Handler drag lama:

```lua
SatVipMap.InputBegan:Connect(function(Input)
    while IsDragInput(Input) and not ColorPicker.Destroyed do ... end
end)
```

`IsDragInput` nerima state `Begin` **atau `Change`**, dan `InputBegan` GuiObject
**juga kepicu MouseMovement** (state Change). Akibatnya:

- tiap mouse gerak di atas picker → **coroutine baru** yang nggak pernah mati
  (InputObject-nya nggak pernah "End" buat movement) → numpuk tiap frame;
- coroutine-coroutine itu semua manggil `Update()` → warna **lompat-lompat
  sendiri** walau mouse cuma numpang lewat → "kadang ga work";
- makin lama makin berat.

**Fix:** satu blok drag per picker:

- mulai **cuma** dari klik beneran (`IsClickInput`);
- satu drag aktif per picker (`DragActive`);
- berhenti dari **`UserInputService.InputEnded`** (bukan InputEnded GuiObject),
  jadi tetap berhenti walaupun mouse dilepas di luar elemen;
- guard `Max > Min` biar nggak ada bagi-nol kalau ukuran belum ke-layout.

Slider (`Bar.InputBegan`) dapat fix yang sama (`SliderReleaseConn`).
`IsDragInput` sekarang nggak dipakai lagi tapi **sengaja nggak dihapus** — API
internal, siapa tau ada yang nyantol.

### Bonus: `AddKeyBox` "missing method"

Method-nya **ADA** di library (`function Tab:AddKeyBox`, level Tab). Error di
log user artinya library yang di-paste **versi lama**. Preview sekarang
nge-guard:

```lua
if typeof(AdvancedTab.AddKeyBox) ~= "function" then
    warn("...paste ulang library terbaru.")
    return
end
```

---

## 🖨️ v4.6 — Print resep THEMA (yang diminta user)

Sebelumnya cuma wallpaper + surface yang bisa di-print. Sekarang
`Preview/N3V4_UISettings.module.lua` punya `BuildTema()` (attach scope, dipakai
dua tab):

```lua
--[[ N3V4 RESEP THEMA — paste balik ke script lu ]]
Library.Scheme.AccentColor = Color3.fromRGB(218, 98, 255)
Library.Scheme.BackgroundColor = Color3.fromRGB(30, 30, 30)
Library.Scheme.MainColor = Color3.fromRGB(40, 40, 40)
Library.Scheme.OutlineColor = Color3.fromRGB(50, 50, 50)
Library.Scheme.FontColor = Color3.fromRGB(238, 238, 238)
Library:UpdateColorsUsingRegistry()
Library:SetFont(Enum.Font.Code)
Window:SetCornerRadius(10)
Library:SetDPIScale(100)
Library.Animations.ToggleWindow = true
... (TabSwitch, Groupbox, Dropdown, KeyPicker)
```

Tombolnya:

| Tab | Box | Tombol |
|---|---|---|
| UI Settings | **Resep Tema** (kanan bawah) | `Print resep tema` · `Copy resep tema` · `Print SEMUA (tema+wallpaper)` |
| Wallpaper & Surface | **Resep** | `Print resep wallpaper` · `Print resep LENGKAP` · `Copy resep LENGKAP` · `Print info lengkap` |

`Copy` pakai `setclipboard` kalau ada (executor), kalau nggak → fallback print.
Semua nilai dibaca **live** dari `Library.Scheme` / `Library.Animations` /
`Library.CornerRadius` / `Library.DPIScale` + state wallpaper `S`, jadi yang
ke-print = yang beneran lagi aktif.

---

## ⚠️ CATATAN PENTING SOAL SIMETRI

**Simetri itu BUKAN properti library. Itu properti layout di HUB.**

Library cuma nyediain dua kolom: `AddLeftGroupbox()` dan `AddRightGroupbox()`.
Simetris atau nggak = tergantung **berapa kali hub manggil masing-masing**.

Kondisi sekarang:

| Tempat | Kiri | Kanan | Simetris? |
|---|---|---|---|
| `Preview/N3V4_Preview.client.lua` | 2/3/3/3/3/3 | 2/3/3/3/3/3 | ✅ **YA** (per tab) |
| `Games/N3-SAE.lua` (hub lu) | **12** | **9** | ❌ **NGGAK — selisih 3** |
| `Games/ride-an-pets.lua` | belum dihitung | | |

**Jadi jawaban "kenapa UI gue nggak simetris?":** karena hub lu manggil
`AddLeftGroupbox` 12x tapi `AddRightGroupbox` cuma 9x. Nggak ada yang bisa
dibenerin di library — harus **rebalance di N3-SAE.lua**.

👉 **UPDATE: rebalance hub DIBATALIN sama user** ("ga usah woi kita fokus ui
bukan script game anj!") — `Games/*.lua` haram disentuh. Tabel di atas cuma
penjelasan kenapa hub lu nggak simetris, bukan kerjaan yang akan dikerjain.

Kalau mau, gue audit per-tab mana yang berat sebelah
terus gue usulin pemindahannya.

---

## 🖼️ Icon — KRONOLOGI & SOLUSI FINAL

### Yang salah (v2)
Gue tambang `rbxassetid://` dari `Games/Source/StealAnEgg/*.lua` (ChiliSource, SenaV2).
Ternyata itu **asset PRIVATE punya game** → Studio nolak:
```
The experience doesn't have access permission to use asset id 123258464128459
```
**Pelajaran:** asset ID dari source game orang lain ≠ asset publik. Jangan diulang.

### Yang bener (v3) — fix di LIBRARY, bukan di preview
Library lu ambil icon dari:
```
https://gitlab.com/upio/lucide-roblox-direct/-/raw/main/source.lua
```
Kalau fetch gagal (HTTP off / repo pindah / rate limit) → `Library:GetIcon()` return `nil`
→ **icon kosong semua**, dan `AddDraggableLabel` malah **assert error keras**.

Gue bongkar source lucide-nya (lewat mirror GitHub `notpoiu/lucide-roblox-direct`,
karena gitlab nggak kejangkau dari sandbox gue) dan nemu strukturnya:

```lua
icons[1] = iconIndices   -- 1866 nama icon
icons[2] = idIndices     -- 2 spritesheet PUBLIK:
                         --   [1] = rbxassetid://136111683851629
                         --   [2] = rbxassetid://135883070486325
icons[3] = iconRegistry  -- { [48] = { [iconIndex] = { sheetIdx, {24,24}, {x,y} } } }
```

**Spritesheet-nya asset PUBLIK** → bisa dipakai tanpa HTTP, tanpa permission.

### Implementasi (3 lapis di `Library:GetIcon`)
```
1. gitlab   (repo asli, 1866 icon)
2. GitHub   (mirror notpoiu/lucide-roblox-direct)
3. OFFLINE  (117 icon hardcoded, spritesheet publik)  <- selalu jalan
```

Yang ditambahin ke `Library/N3V3-NoObfus.lua`:
- `OfflineLucideSheets` — 2 spritesheet ID
- `OfflineLucideIcons` — **117 icon** `{ sheetIdx, rectX, rectY }`, rect 24×24
- `OfflineLucideAliases` — **13 nama lama → baru**
- `GetOfflineLucideIcon()` — resolver
- `LucideSources` + loop fallback (gitlab → GitHub)
- `Library:GetIcon` di-rewrite jadi chain 3 lapis

**Isi 117 icon** = semua icon yang dipakai `N3-SAE.lua` + `ride-an-pets.lua` (43 nama),
plus icon UI umum buat development. Semua **diverifikasi ada** di daftar 1866 lucide.

### Bug icon yang gue temuin di repo lu
Nama lucide lama yang udah di-rename upstream → **icon-nya diem-diem gagal**:

| File | Line | Nama salah | Harusnya |
|---|---|---|---|
| `Games/ride-an-pets.lua` | 4044 | `"sliders"` | `sliders-horizontal` |
| `Games/ride-an-pets.lua` | 4046 | `"bar-chart-2"` | `chart-column` |
| `Games/Source/.../SenaV2.lua` | — | `"chat"` | `message-square` |
| `Games/Source/.../SenaV2.lua` | — | `"forum"` | `messages-square` |
| `Games/Source/.../SenaV2.lua` | — | `"donator"` | (bukan lucide) `crown` |

`N3-SAE.lua` (hub utama) **bersih** — semua 43 icon-nya valid.
Sekarang alias-nya di-handle otomatis di library, jadi yang lama tetep muncul.

### ⚠️ Jebakan: ScrollFeed TIDAK apply ImageRect
```lua
-- Library line 5134
Image = itemData.Icon or "",     -- cuma Image, tanpa ImageRectOffset/Size!
```
Jadi `AddScrollFeed():AddItem({ Icon = ... })` **harus gambar polos**.
Kalau dikasih nama lucide → yang ke-render **seluruh spritesheet**.

Semua konsumen lain aman (apply rect dengan bener):
`AddTab`, `AddGroupbox`, `Notify.Icon`, `Notify.BigIcon`, `Dropdown.ValueImages`,
`AddDraggableLabel`, `AddDraggableImageButton`, `ChangeCursorIcon`.

---

## 🎬 Animasi — udah ada di library, cuma default-nya OFF

**Ini jawaban "buset ini animasi udah ada di library? apa masih di preview?"**

Animasinya **100% udah ada di library dari dulu**. Masalahnya default mati semua:

```lua
-- SEBELUM
Animations = { ToggleWindow=false, TabSwitch=false, Groupbox=false, Dropdown=false, KeyPicker=false }
```

Hub lu manggil `CreateWindow({ Title, Footer, Icon, AutoShow })` — nggak ngoper
`Animations` → dapet default false semua → **UI kaku**.

Preview gue keliatan GG karena gue nyalain eksplisit. **Sekarang udah gue flip di
library**, jadi bukan cuma preview.

### Propagation (keverifikasi)
```
Templates.Window.Animations
  → Library:Validate(WindowInfo, Templates.Window)
  → Library.Animations = WindowInfo.Animations      (line ~9368)
  → Table.Animated() / PlayTabAnimation / dll
```

**Efek: `N3-SAE.lua` & `ride-an-pets.lua` langsung dapet animasi tanpa disentuh.** ✅

---

## 📝 RINGKASAN: apa aja yang gue ubah di LIBRARY

Semua di `Library/N3V3-NoObfus.lua` — permanen (bukan preview-only), jadi hub lu
kebagian semuanya begitu library-nya di-copy ulang:

| # | Perubahan | Lokasi | Efek |
|---|---|---|---|
| 1 | Animasi default `false` → `true` | `Library.Animations` + `Templates.Window.Animations` | Hub dapet animasi otomatis, termasuk Loading screen |
| 2 | `CornerRadius` `4` → `10` | `Library.CornerRadius` + `Templates.Window.CornerRadius` | UI nggak boxy lagi. Clamp max tetap 20 |
| 3 | Offline lucide fallback (117 icon) + GitHub mirror | blok sebelum `Library:GetIcon` + rewrite `GetIcon` | Icon **selalu** muncul, tanpa HTTP |
| 4 | Alias 13 nama lucide lama | `OfflineLucideAliases` | `sliders`/`bar-chart-2`/`home`/`chat` dll tetep resolve |
| 5 | **Wallpaper system** — 7 template field, 5 helper, 7 method | `Templates.Window` + sebelum `CreateWindow` + `BackgroundImage`/`BackgroundOverlay` + setters | Wallpaper configurable penuh: transparency, tint, scaletype, layer, overlay/scrim |
| 6 | **FIX** `Window:SetBackgroundImage` nggak handle number | awal fungsi | Paste angka ID sekarang jalan (dulu diem-diem gagal) |
| 7 | **Surface system** — canvas/group/window transparency + override warna | blok di atas (sekarang tepat setelah `New()`) | Wallpaper beneran jadi background; kartu group tetap solid & bisa dibedain |
| 8 | **Resep user jadi default** | `Templates.Window` + `Library.Surface` | Wallpaper + surface aktif tanpa seting apa pun |
| 9 | `Surface.WindowTransparency` + `Library.SurfaceWindow` | `ApplySurfaces`, `GetWallpaperInfo`, `Templates.Window` | Transparansi dasar MainFrame bisa diatur (default 0 = solid) |
| 10 | **FIX v4.6** blok Surface/Wallpaper dipindah ke atas | setelah `New()`, sebelum instance pertama | `AddDependencyGroupbox` nggak crash "attempt to call a nil value" lagi |
| 11 | **FIX v4.6** bridge dua `Funcs:AddViewport` | sebelum definisi AddViewport kedua | Viewport `Height/Spin/Interactive/SetModel` jalan lagi; API `Object/Camera` tetap hidup |
| 12 | **FIX v4.6** drag color picker + slider | `Funcs:AddColorPicker`, `Funcs:AddSlider` | Warna nggak lompat sendiri, coroutine nggak numpuk, UI nggak makin berat |

**Yang BELUM di library:** simetri (itu urusan hub), design tokens, warna/font baru,
motion system tambahan, wallpaper di Loading/Dashboard/Notification.
Nunggu keputusan arah visual.

---

## 🖼️ WALLPAPER SYSTEM (fitur baru, full di library)

### Kondisi sebelumnya
Library udah punya `BackgroundImage`, tapi **hampir semuanya hardcoded** dan
**nggak pernah dipakai** hub lu (`grep BackgroundImage Games/*.lua` = kosong):

```lua
BackgroundImage = New("ImageLabel", {
    ScaleType        = Enum.ScaleType.Stretch,  -- hardcoded
    ZIndex           = 999,                      -- hardcoded, DI ATAS konten
    ImageTransparency = 0.75,                    -- hardcoded
    -- nggak ada ImageColor3 (tint)
    -- nggak ada overlay/scrim sama sekali
})
```

### 🐛 Bug asli yang ketemu & di-fix
`Library:SetBackgroundImage` di-assert nerima `string | number`, tapi
`Window:SetBackgroundImage` cuma nge-handle `typeof(Image) == "string"`.
→ **paste angka ID (misal `111593326989465`) diem-diem gagal**, wallpaper nggak
muncul, dan **nggak ada error**. Udah dinormalisasi ke `rbxassetid://%d`.

### Yang ditambahin
**Template (`Templates.Window`)** — 7 field baru:
| Field | Default | Fungsi |
|---|---|---|
| `BackgroundImageTransparency` | `0.75` | 0 = gambar penuh, 1 = ilang |
| `BackgroundImageScaleType` | `"Stretch"` | member asli: Stretch / Slice / Tile / Fit / Crop + alias Fill,Cover→Crop, Contain→Fit |
| `BackgroundImageColor` | putih | tint (`ImageColor3`) |
| `BackgroundImageLayer` | `"back"` | `"back"` = wallpaper beneran, `"front"` = wash (perilaku lama) |
| `BackgroundOverlayEnabled` | `false` | scrim gelap |
| `BackgroundOverlayColor` | hitam | warna scrim |
| `BackgroundOverlayTransparency` | `0.5` | kekuatan scrim |

**Helper module-level** (didefinisiin sebelum `CreateWindow`):
`WallpaperScaleTypes`, `ResolveScaleType()`, `WallpaperLayers`,
`ResolveWallpaperLayer()`, `ClampTransparency()`

**Layering / ZIndex** — ScreenGui library pakai `ZIndexBehavior` **Legacy**
(nggak di-set), jadi ZIndex cuma berlaku antar sibling. Wallpaper & overlay
dua-duanya child `MainFrame`, dan background MainFrame sendiri selalu di
belakang semua child → ZIndex negatif tetep keliatan.

| Mode | Image ZIndex | Overlay ZIndex | Konten |
|---|---|---|---|
| `back` | **-2** | **-1** | 1+ (di atas semua) |
| `front` | 999 | 998 | 1+ (wallpaper nutupin) |

**Method baru:**
```
Window:SetBackgroundImageTransparency(n)
Window:SetBackgroundImageScaleType(t)     -- EnumItem atau string
Window:SetBackgroundImageColor(Color3)
Window:SetBackgroundImageLayer("back"|"front")
Window:SetBackgroundOverlay(Enabled?, Color?, Transparency?)   -- semua opsional
Window:GetWallpaperInfo()                 -- snapshot state, buat debug/display
Library:SetWallpaper({...})               -- one-shot, semua field opsional
```

Semua setter **nyimpen ke `WindowInfo`** juga, biar state konsisten.

### Contoh pakai di hub
```lua
Library:SetWallpaper({
    Image = "111593326989465",
    Transparency = 0.35,
    ScaleType = "Fill",
    Layer = "back",
    Overlay = true,
    OverlayColor = Color3.fromRGB(0, 0, 0),
    OverlayTransparency = 0.45,
})
```
Atau langsung di `CreateWindow({ BackgroundImage = ..., BackgroundImageLayer = ..., ... })`.

### 🏆 RESEP USER YANG DISETUJUI — **v4 (theme), DEFAULT SEKARANG** (2026-10-20)
v4 = **theme doang** yang diganti ("sementar itu dulu ... jangan nambah fitur
apapun itu cuma ganti jadi gitu saja dulu"): bg `(18,18,18)`, main `(33,33,33)`,
outline `(61,61,61)`. Accent `(218,68,255)`, font putih, radius 15, DPI 100,
dan SEMUA wallpaper/surface = **tetep v3** di bawah.

### 🗄️ Resep v3 (theme sebelumnya; wallpaper/surface-nya MASIH default)
User seting ulang lewat slider + color picker, paste balik output
**"Print resep thema"** + dump `GetWallpaperInfo`, dan bilang
**"mantap terapin nih brok ke library"**. Jadi v3 ini default di LIBRARY
(`Library.Scheme`, `Library.CornerRadius`, `Templates.Window`, `Library.Surface`)
DAN di `Settings.DEFAULTS`. VERBATIM, jangan diubah tanpa user minta:

```lua
-- THEMA
Library.Scheme.AccentColor = Color3.fromRGB(218, 68, 255)
Library.Scheme.BackgroundColor = Color3.fromRGB(18, 18, 18)   -- v4
Library.Scheme.MainColor = Color3.fromRGB(33, 33, 33)         -- v4
Library.Scheme.OutlineColor = Color3.fromRGB(61, 61, 61)      -- v4
Library.Scheme.FontColor = Color3.fromRGB(255, 255, 255)
Window:SetCornerRadius(15)
Library:SetDPIScale(100)
-- (animasi semua true — udah default dari v0.5)

-- WALLPAPER + SURFACE
Library:SetWallpaper({
	Image = "111593326989465",
	Transparency = 0.80,
	ScaleType = "Stretch",
	Color = Color3.new(0.59, 0.59, 0.59),
	Layer = "front",
	Overlay = false,
	OverlayColor = Color3.fromRGB(0, 0, 0),
	OverlayTransparency = 0.40,
})
Library:SetSurface({
	WindowTransparency = 0.00,
	CanvasTransparency = 0.20,
	GroupTransparency = 0.00,
	GroupContrast = 30,        -- baseline user v4.6.4 (kepake kalau custom OFF)
	GroupColor = Color3.fromRGB(0, 0, 0),  -- v4.6.5: BALIK HITAM (auto abu = salah)
	CanvasColor = Color3.new(0.045, 0.045, 0.045),
})

-- v4.6.6: LAYER BACK — kartu group 100% SOLID ("ga transparan" kata user).
-- Wallpaper sekarang DI BELAKANG konten; yang keliatan cuma sela-sela kartu.
Library:SetWallpaper({ Layer = "back", Overlay = true, OverlayTransparency = 0.50 })
Library:SetSurface({ WindowTransparency = 1.00, CanvasTransparency = 1.00 })
-- ^ angka persen canvas/overlay/window = BASELINE; user mau seting sendiri
--   terus kirim print balik. JANGAN dikunci sampe print user datang.

-- v4.6.7: ATURAN BARU (user marah kedua kali soal kartu transparan):
--   Layer "front" = VEIL di atas SEMUA -> kartu group nggak akan pernah bisa
--   solid/terpisah selagi front. Maka: semua preset & combo di file setingan
--   WAJIB "back"; front cuma lewat dropdown Layer kalau user sadar konsekuensinya.
--   Preset juga dilarang matiin GroupColor/CanvasColor custom (kartu hitam).
```

Catatan: tint & canvas color disimpan sebagai `Color3.new(float)` biar SAMA
PERSIS sama dump user (0.59 / 0.045 bukan hasil pembulatan fromRGB). Tombol
"Reset scheme" di file setingan sekarang balikin ke warna v3 ini.

### 🗄️ Resep v2 (sebelumnya)
```lua
-- wallpaper: Transparency 0.85, tint (252,241,255), overlay OFF 0.21
-- surface  : Canvas 0.20, Group 0, Contrast 6, CanvasColor (20,20,20)
-- theme    : masih scheme obsidian bawaan, radius 10
```

### 🗄️ Resep v1 (SEBELUMNYA, udah diganti)
```lua
-- wallpaper: Transparency 0.70, Color (55,55,55), Overlay true 0.90 (46,46,46)
-- surface  : Canvas 0.64, Group 0.11, Contrast 11, Group/CanvasColor (0,0,0)
```
Masih bisa dipanggil manual lewat preset / `Library:SetWallpaper`. Kalau user
balik minta v1, angka-angkanya ada di atas.

Catatan rasa v2: tint hampir putih (252,241,255) + transparency 0.85 = wallpaper
jadi wash TERANG tipis di atas konten; overlay MATI (warna cuma disimpan buat
kalau dinyalain lagi); canvas 20% + warna (20,20,20) = area konten gelap tapi
wallpaper masih kebaca samar; kartu group SOLID hitam (contrast 6). Ini kombinasi
yang user suka — BUKAN resep "back + canvas 100%" yang gue rekomendasiin dulu.
**Selera user menang.**

**Terpasang di:**
- **`Library/N3V3-NoObfus.lua`** → `Templates.Window` + `Library.Surface`
  = resep user. Artinya wallpaper **AKTIF OTOMATIS** begitu library di-require,
  tanpa seting apa-apa. Tetep bisa di-override per-window / lewat setter.
- **`Preview/N3V4_UISettings.module.lua`** → `Settings.DEFAULTS` + semua
  kontrol buat ngubah-ubahnya.
- **NGGAK di game script.** User tegas: "fokus ui bukan script game".
  Percobaan gue masang ke `N3-SAE.lua` udah gue **revert** (file balik original).

**⚠️ Hub load library dari raw URL repo LAIN:**
`https://raw.githubusercontent.com/ZedFu3/N3-Hub/refs/heads/main/Library/N3V3.luau`
(N3-SAE.lua line 8-9). Perubahan library gue ada di repo INI
(YienYun/N3-Project). Wallpaper di hub baru NYALA setelah library baru
ke-push ke URL itu (atau URL loader-nya diganti). Itu urusan deployment user.

---

### 🐛 Bug class: hardcoded member Enum yang nggak ada
**Sempat kejadian:** `Fill = Enum.ScaleType.Fill` di top-level →
`Fill is not a valid member of "Enum.ScaleType"` → **seluruh library gagal
di-require**. `Enum.ScaleType` aslinya cuma punya:
`Stretch · Slice · Tile · Fit · Crop` — **`Fill` nggak ada.**

Dua tempat kena: helper wallpaper di library, dan peta ScaleType dropdown Image
di tab Media preview (yang ini di dalam callback, jadi crash-nya pas dropdown
dipilih, bukan pas load).

**Fix permanen:** tabel dibangun dari `GetEnumItems()`, bukan literal.
```lua
local WallpaperScaleTypes = {}
for _, Item in Enum.ScaleType:GetEnumItems() do
    WallpaperScaleTypes[Item.Name] = Item      -- dijamin cuma member asli
end
WallpaperScaleTypes.Fill = WallpaperScaleTypes.Fill or WallpaperScaleTypes.Crop
```
Alias di-assign lewat **indexing tabel** (aman), bukan `Enum.X.Y` (bisa crash).

**Aturan ke depannya:** jangan pernah nulis `Enum.<Type>.<Member>` buat nilai
yang nggak 100% pasti ada. Bangun dari `GetEnumItems()`, atau bungkus pcall.
Validator `.cache/luacheck/enums.js` sekarang nge-check ini + audit semua
referensi Enum di library & preview.

**Soal nama:** `Fill` / `Cover` yang orang maksud biasanya = CSS
`background-size: cover` = **Roblox `Crop`** (nutupin penuh, ratio dijaga,
lebihannya kebuang). `Fit` = CSS `contain` (muat semua, bisa ada sisi kosong).

---

### 🎯 Surface system — bikin wallpaper BENERAN jadi background kartu
**(ditambah setelah user tes: "wallpaper nggak keliatan" + "komponen jadi tembus")**

Dua akar masalah yang ketemu dari source:

1. **`Container`** (seluruh area konten tab) dibuat **SOLID** —
   `BackgroundColor3 = GetBetterColor(BackgroundColor, 1)`, tanpa
   `BackgroundTransparency`. Wallpaper mode `back` ada DI BELAKANG dia →
   **ketutup total**. Keliatannya "nggak ngapa-ngapain".
2. **Kartu groupbox/tabbox/depbox** pakai `BackgroundColor3 = "BackgroundColor"` —
   **warna yang sama persis** sama background window → group nggak kebaca
   sebagai kartu. User minta group **tetep solid** dan **~10% beda** dari bg.

Bonus masalah dari mode `front`: wallpaper digambar **DI ATAS semua komponen**
(ZIndex 999) → button/dropdown/slider/text keliatan "tembus pandang". Itu
**bukan** transparency komponen, itu wallpaper yang nutupin.

**Solusi: `Library.Surface`** — kontrol latar & kartu, terpisah dari wallpaper:

| Field | Default | Fungsi |
|---|---|---|
| `CanvasTransparency` | `0` | Container **+ sidebar**. `1` = wallpaper keliatan penuh di latar |
| `GroupTransparency` | `0` | Kartu group/tabbox/depbox. `0` = **SOLID** (isinya nggak ikutan tembus) |
| `GroupContrast` | `0` | persen 0–100: kartu group dibedain dari bg window (dark: lebih terang) |
| `GroupColor` | `nil` | override `Color3` kartu. `false` = balik ke auto |
| `CanvasColor` | `nil` | override `Color3` latar (Container+sidebar) via `Library:GetCanvasColor()`. `false` = ikut theme |

Tracking instance: `Library.SurfaceCanvas` (Container, Tabs) &
`Library.SurfaceGroups` (GroupboxHolder, TabboxHolder, DepGroupboxContainer).
Warna kartu di-register ke **Registry sebagai function**
(`Library:GetGroupSurfaceColor()`), jadi **theme change & contrast change
dua-duanya ke-apply** lewat `UpdateColorsUsingRegistry()`.

```lua
Library:SetSurface({ CanvasTransparency = 1, GroupTransparency = 0, GroupContrast = 10 })
```
Atau lewat `CreateWindow({ ContentTransparency, GroupTransparency, GroupContrast })`.

**Default preview (v4.4):** `CanvasTransparency = 1` (wallpaper keliatan sebagai
background kartu), `GroupTransparency = 0` (kartu solid), `GroupContrast = 0`
(kartu pakai warna ASLI theme — user kesel waktu contrast maksa kartu jadi
abu-abu). Tombol "BALIKIN NORMAL (semula)" ada buat balik ke canvas solid.

**Overlay default OFF** — scrim (apalagi warna terang) bikin wallpaper kusam/abu-abu.

**Control lengkap di preview:** 4 color picker langsung (tint wallpaper,
overlay, canvas, kartu group) + tombol reset/"ikut theme lagi" per picker,
5 slider (image/overlay/canvas/group transparency + group contrast),
2 dropdown (ScaleType, Layer), 7 preset, print resep.

**Aturan layer yang wajib dijelasin ke user** (dulu bikin bingung):
group transparency cuma KELIATAN kalau canvas transparan. Kalau canvas solid,
kartu yang ditransparankan cuma nunjukin warna canvas di belakangnya ->
keliatannya "slider-nya ga ngaruh".

`Window:GetWallpaperInfo()` sekarang juga nge-report `ScaleTypeName` (string
polos, bukan `Enum.ScaleType.Crop`), `CanvasTransparency`, `GroupTransparency`,
`GroupContrast`, `GroupSurfaceColor` — biar user bisa paste snapshot-nya balik
dan kita tau persis konfigurasi aktif.

### ⚠️ Keterbatasan yang harus diinget
**Wallpaper belum di-apply ke:** Loading screen, Dashboard window, Notification,
Overlay panel, Draggable elements. Semua itu ScreenGui/Frame terpisah. Kalau mau
konsisten, itu kerjaan lanjutan.

**`GroupContrast` ngaruh global** ke semua kartu group/tabbox/depbox, termasuk
pas wallpaper mati. Default `0` = perilaku lama persis, jadi hub yang nggak
nyetel apa-apa nggak berubah tampilan.

---

## ⚠️ Jebakan API (hasil verifikasi source, jangan diulang)

| API | Return | Jebakan |
|---|---|---|
| `Funcs:AddColorPicker(Idx, Info)` | `ColorPicker` | **HARUS nempel ke object yang punya `.TextLabel`** = Toggle / Button. Nempel ke **groupbox = crash runtime** (`Parent = nil`) dan picker nggak ke-render. Pernah kejadian v4.4 → fix v4.4.2 (host = toggle) |
| `Library:SetBackgroundImage(img)` | — | **Dulu bug**: assert-nya nerima `string \| number` tapi `Window:SetBackgroundImage` cuma handle string → angka ID diem-diem gagal. **Udah di-fix** (normalisasi ke `rbxassetid://%d`) |
| `Library:Notify(...)` | `Data` table | `ChangeTitle`/`ChangeDescription`/`ChangeStep`/`Resize`/`Destroy`. **BUKAN** `SetStep`/`Dismiss` |
| `Library:CreateOverlay(Info)` | `Self` | Panel **key-value**: `SetRow(K,V,Color)`/`RemoveRow`/`ClearRows`/`SetVisible`/`Destroy`. Nggak ada `AddLabel`/`AddButton` |
| `Library:CreateDashboardWindow(Info)` | `Self` | Row API sama kayak Overlay |
| `Library:AddDraggableMenu(Name)` | `Holder, Container` | **Raw Instance**, 2 return value, tanpa method |
| `Library:AddContextMenu(Holder, Size, Offset, List, ...)` | `Table` | `{Open, Close, Toggle, SetSize, Destroy, Menu, Holder, Active}`. **NGGAK ada `AddButton`** — item manual ke `Ctx.Menu`. Library **nggak auto-bind right-click**. `List=1` → UIListLayout + AutomaticSize.Y |
| `Funcs:AddViewport(Idx, Info)` | `ViewportObj` | `Info.Object` **NGGAK** di-auto-apply → panggil `SetModel()` manual. Ada `Info.Spin` (default ON) & `Info.Interactive` |
| `Funcs:AddSpotlightCard(Idx, Info)` | `CardObj` | `SetData(title, desc, imageAsset, modelSource)` — param ke-4 switch kiri card ke ViewportFrame 3D |
| `Funcs:AddScrollFeed(Idx, Info)` | `FeedObj` | `AddItem({Icon, Title, Detail, RightTag, OnClick})` + `Clear()`. **Icon harus gambar polos** |
| `Window:AddDialog(Idx, Info)` | `Dialog` | `AddFooterButton(Idx, {Title, Variant, Order, WaitTime, Callback})` — key **`Title`** bukan `Text`. Variant: Primary/Secondary/Destructive/Ghost. Inherit `BaseGroupbox` |
| `Library:AddDraggableLabel(...)` | `DraggableLabel` | **Ada `assert` di icon** (line ~2029) → icon invalid = error keras |
| `Tab:AddKeyBox(Callback)` | — | `Callback(Text)`. Elemen level Tab |
| `Library:SetDPIScale(n)` | — | Param = **persen** (dibagi 100 di dalam). `100` = skala 1.0 |
| `Window:SetCornerRadius(r)` | — | Clamp max **20** |

### Struktur metatable
```
BaseGroupbox.__index = Funcs     -- Groupbox, Tab, Depbox, DepGroupbox, Dialog inherit semua
BaseAddons.__index   = Funcs     -- Toggle/Button dapet AddKeyPicker & AddColorPicker
Tab.Groupboxes[Name] = Groupbox  -- reference otomatis, bisa collapse/hide dari jauh
```

### 🐛 Bug class: forward reference ke `Library`
**Sempat kejadian di preview v3** — error `attempt to index nil with 'GetIcon'`.

Penyebab: function didefinisiin **sebelum** `local Library = require(...)`, jadi
`Library` di dalam body-nya nangkep **GLOBAL**, bukan upvalue local.

```lua
local function PrintReport()
    Library:GetIcon("house")   -- ❌ global Library = nil
end
local Library = require(Mod)   -- deklarasinya di SINI, kelewat
```

Kenapa global-nya nil padahal library melakukan `getgenv().Library = Library`?
Karena di Studio `getgenv` fallback ke **`shared`**, bukan `_G`:
```lua
local getgenv = getgenv or function() return shared end
```
Jadi `shared.Library` keisi, `_G.Library` tetap nil.

**Fix (udah diterapkan):** forward declaration.
```lua
local Library                  -- deklarasi dulu
local function PrintReport() ... Library:GetIcon(...) ... end
Library = require(ModuleObject) -- assign TANPA `local`
```

**Aturan buat ke depannya:** helper function apa pun yang nyentuh `Library`
harus didefinisiin **setelah** require, ATAU pakai forward declaration.
Validator `validate4.js` punya `SCOPE CHECK` khusus buat ini.

### 🐛 Bug class saudara: local helper dideklarasinya DI BAWAH pemakainya
**Sempat kejadian (v4.2):** `ClampTransparency` didefinisiin di blok helper
sebelum `CreateWindow` (~line 9430), padahal `Library:SetSurface` ada di
~line 9145 — **di atasnya**. Di Lua, local cuma keliatan ke kode **di bawah**
deklarasinya. Jadi di dalam `SetSurface`, `ClampTransparency(...)` resolve ke
**global = nil** → `attempt to call a nil value` pas runtime → **semua slider
& button surface mati**.

Beda sama bug `PrintReport` dulu: yang ini bukan soal require-order, tapi
**urutan deklarasi local di satu file yang sama**.

**Fix:** seluruh blok helper N3V4 (Wallpaper helpers + Surface system) dipindah
ke **atas** `Library:SetBackgroundImage`. Aturan: *helper module-level harus
didefinisiin sebelum function module-level mana pun yang manggil dia.*
Check `SCOPE` di `.cache/luacheck/check.js` sekarang nge-verify decl < pakai
buat semua helper N3V4.

### Format icon yang diterima `GetCustomIcon` (tanpa HTTP)
`rbxassetid://<id>` · `rbxasset://textures/...` · `content://...` · `rbxthumb://type=...`
· `roblox.com/asset/?id=...` · angka polos · **nama lucide** (via chain 3 lapis)

---

## 🧱 ARSITEKTUR PREVIEW vs SETTINGS (v4.5 → v4.6, permintaan user)
User: *"bersihin ui previewnya jangan ada setingan color dll ... bikin 1 file
lagi namanya setting ui ... di preview hanya preview gambaran image button dll
... setingan ui itu harusnya full di file baru, nanti kita panggil di preview
utama biar muncul tab baru."*

| File | Isi |
|---|---|
| `Preview/N3V4_Preview.client.lua` | **MURNI showcase komponen** (5 tab): button, toggle, dropdown, slider, image, viewport, feed, notify, dialog, dll. **NOL setingan UI.** |
| `Preview/N3V4_UISettings.module.lua` | **SEMUA setingan desain** (2 tab: "UI Settings" 3/3 + "Wallpaper & Surface" 4/4): wallpaper, overlay, surface, warna scheme, font, radius, animasi, preset, **print/copy resep thema + wallpaper** |
| `Library/N3V3-NoObfus.lua` | Engine + **default resep user** (wallpaper aktif otomatis) |

**DUAL MODE** (v4.5.1, setelah user paste sebagai LocalScript dan tab-nya
nggak muncul — detektor gue dulu cuma cari ModuleScript):
- **LocalScript**: file register diri ke `shared.N3V4_UISettings` lalu
  `task.spawn` nunggu `shared.Library` + `Library.Window` siap → **nempel
  sendiri**, tanpa di-call siapa-siapa.
- **ModuleScript**: preview `require` dia, atau manual `Settings:Attach(Library, Window)`.
- Preview juga punya jalur cadangan: retry `shared.N3V4_UISettings` di background.
- Flag `shared.N3V4_UISettings_Attached` mencegah tab dobel kalau dua jalur
  kepake bareng.

---

## 📐 Peta file

```
N3-Project/
├── Library/N3V3-NoObfus.lua       14.547 baris — engine UI (fork Obsidian) ← DIUBAH
├── Games/                         ← HARAM DISENTUH (user: "fokus ui bukan script game")
│   ├── N3-SAE.lua                 18.659 baris — hub Steal An Egg
│   ├── ride-an-pets.lua            6.128 baris — hub kedua
│   └── Source/StealAnEgg/         source lama
├── Preview/
│   ├── N3V4_Preview.client.lua     1.196 baris — showcase 5 tab (v4.6) ← DIUBAH
│   ├── N3V4_UISettings.module.lua    834 baris — setingan desain, dual-mode ← DIUBAH
│   └── README.md
├── tools/
│   ├── check.sh                    syntax (luau-analyze asli) + cek struktur
│   ├── symmetry.py                 kiri == kanan per tab
│   └── bin/                        cache binary luau-analyze (di-gitignore)
├── .gitignore
└── DESIGN_NOTES.md                 ← file ini
```

---

## 🗺️ Roadmap

- [x] **Phase 0** — Preview Kit
- [x] **Phase 0.5** — Animasi ON, CornerRadius 10, offline icon fallback (semua di library)
- [x] **Phase 0.6** — Wallpaper + Surface system ✅ + **resep user dikunci jadi default library**
      (pasang ke `N3-SAE.lua` **di-revert** — user: *"ga usah woi kita fokus ui bukan script game anj!"*)
- [x] **Phase 0.7** — Setingan dipisah ke file sendiri + preview jadi showcase murni (v4.5)
- [x] **Phase 0.8** — **v4.6**: 3 bug library dibenerin (dependency / viewport / color drag)
      + print & copy **resep thema** + checker luau asli (`tools/check.sh`)
- [ ] ~~Rebalance simetri `N3-SAE.lua`~~ — **DIBATALIN** (game script haram disentuh)
- [ ] **Phase 1** — Design tokens: tarik semua angka visual ke satu tabel `Design`
- [ ] **Phase 2** — Chrome: window, sidebar, tab + sliding indicator, groupbox, footer
- [ ] **Phase 3** — Komponen: button, toggle, slider, dropdown, keybind, colorpicker, input
- [ ] **Phase 4** — Motion system: spring util, hover/press state, stagger reveal
- [ ] **Phase 5** — Loading, Dashboard, Notification, Draggable
- [ ] **Phase 6** — Icon set lengkap (kalau butuh > 117 icon offline)
- [ ] **Phase 6.5** — Wallpaper di Loading screen / Dashboard / Notification (sekarang cuma main window)
- [ ] **Phase 7** — Theme presets bawaan library

**Belum diputusin:** arah visual (glass / brutalist / cyber / minimal), accent & font final.

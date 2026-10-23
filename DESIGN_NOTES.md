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

## ↩️ v4.12.4 — SECTION REVERT: eksperimen dihapus, desain asli balik

Putusan user setelah rangkaian v4.11.3->v4.12.3: "balikin ke semula
saja bro jangan ada coloran anj malah jelek... hapus. nambah sampah
anj. balikin cok ke semula cuma color textnya lu pertahanin."

Eksekusi:
- LIB: Library.SectionAppearance, SectionRegistry,
  ApplySectionAppearance, SetSectionAppearance, hook theme section =
  DIHAPUS. AddDivider text-branch = kode ASLI library verbatim lagi:
  SizeX = X//2 + 10, dua Frame fill MainColor + BorderColor3
  OutlineColor + BorderSizePixel 1, Size 0.5,-SizeX,0,2.
- MOD: dua groupbox section, BuildSection, DEFAULTS.Section, baris
  reset, semua knob SD_* = DIHAPUS. T1 5/5.
- DIPERTAHANKAN sesuai permintaan: TextLabel divider TextColor3
  "AccentColor" + TextTransparency 0.5 (perubahan v4.11.3 yang dia
  minta keep).
- Checker: pin garis desain asli + text accent + ABSENSI total
  SectionAppearance/SectionRegistry/SD_BT/BuildSection biar gue atau
  siapa pun ga bisa ngidupin lagi sampah ini tanpa sadar.

Lesson buat gue: request "section ikut color theme" dia maksudkan
untuk TEXT-nya (dia tulis dari awal: "----- Selamat datang ---- gue
mau jadi ngikutin color theme"); gue over-engineer garisnya sampe 5
iterasi. Baca request harfiah dulu, tawarkan minimal, biar dia yang
minta lebih.

## 🎯 v4.12.3 — SECTION v5: garis opaque lerp, pincang mati secara fisik

Screenshot user v4.12.2 bersih: divider tetep kiri-ungu/kanan-hitam.
Root cause desain: border 1px dengan BorderTransparency di frame
setinggi 2px = seluruh pixel garis adalah pixel border semi-transparan;
di atas group card transparency 0.5 yang ditembus wallpaper, hasil
visualnya tergantung backdrop setempat -> dua sisi kebaca beda walau
property identik.

Solusi v4.12.3: buang border sepenuhnya. Garis = BackgroundColor3
OPAQUE hasil `Scheme.BackgroundColor:Lerp(Target, Strength)` dengan
Target AccentColor (atau OutlineColor kalau AccentBorder false).
Warna opaque tidak terpengaruh backdrop => kiri/kanan IDENTIK secara
fisik, dan sinkron theme lewat hook recolor existing. Knob SD_BT
ganti semantik: "Kekuatan warna garis" 0-100% (default 60% = kalem
tapi jelas); preset Soft 60 / Solid 100 / Ghost 30 / Netral outline.
BuildSection print Strength.

Plus: label petunjuk di box demo Selamat Datang yang nunjuk lokasi
setting (tab UI Settings, icon palette, box Section Divider #2 kiri)
— user beberapa kali rage dari tab DEMO karena mengira itu tab setting.

## 📐 v4.12.2 — box section naik atas + garis simetris by construction

Keluh user: "settinganya mana anjir? kok kanan hitam kiri unggu?
konsepnya jelek banget".

Fakta: kolom tab = ScrollingFrame; box Section Divider sebelumnya
box ke-6 kolom kiri => knob ADA tapi di bawah lipatan window. UX
buruk = salah gue walau teknisnya "bisa di-scroll". Fix posisi:
Try "section divider" dipindah sebelum "presets theme" (kiri #2),
Try "divider presets" sebelum "window" (kanan #2).

Soal asimetri kiri-ungu/kanan-hitam: kombinasi itu tidak cocok dengan
versi bersih mana pun (v4.12.0 maupun v4.12.1) => indikasi paste
library frankenstein di sisi user. Tetap gue kerasin library:
- dua garis divider dibuat dari SATU loop (AnchorX 0 dan 1) =>
  parameter identik, pincang hanya mungkin kalau ada code luar yang
  nyentuh salah satu frame;
- ApplySectionAppearance dibungkus pcall per section => glitch section
  tidak bisa meng-abort pemanggil (pola bug #27: satu assign buruk
  pernah membunuh seluruh groupbox).
Instruksi ke user: paste library FULL + cek print v4.12.2; kalau masih
asetri -> curigai ModuleScript N3V4 duplikat.

## 🐛 v4.12.1 — BUG #31 (BorderColor3 string) + sample section dalam box

Error user: `Unable to assign property BorderColor3. Color3 expected,
got string` dari ApplySectionAppearance. Akar: theme-string ("AccentColor")
hanya di-resolve oleh wrapper New() saat create (+ registry recolor);
assign property langsung di runtime harus Color3 asli. Fix:
ApplySectionAppearance pakai Library.Scheme.AccentColor /
OutlineColor langsung, plus hook di akhir UpdateColorsUsingRegistry
yang me-re-apply semua section tiap theme berubah (sync terjaga).
Frame garis sekarang dibuat TANPA BorderColor3 string; apply perdana
langsung setelah create.

Request kedua user: "sectionya mana? taruh di group seting section
dong" -> groupbox "Section Divider" kini memuat sample divider LIVE
(AddDivider "Preview section") di atas knob-knobnya; karena divider
ikut SectionRegistry, semua slider/preset mengubah sample itu right
there, depan mata.

## 🎚️ v4.12.0 — SECTION SETTINGS: preview setingan manual + preset

User: v4.11.4 masih "terlalu mencolok", mau atur sendiri simetris +
transparansi warna, minta preview setingan, dan minta gue kontribusi
desain (jangan yesman).

Diagnosa teknis (kenapa masih mencolok): garis section tinggi 2px;
border 1px inset makan pixel atas+bawah -> fill MainColor tidak
kelihatan sama sekali; border AccentColor transparency 0 = seluruh
garis kebaca accent solid (visual sama dgn v4.11.3 yang ditolak).
Kunci kelembutan bukan warna/fill melainkan TRANSPARANSI border.

Kontribusi desain gue:
- Default BorderTransparency 0.45 = outline accent kalem, bukan bar.
- Knob jarak text-garis SATU nilai untuk dua sisi => simetri kiri/
  kanan dijamin oleh konstruksi, tidak mungkin pincang (user suka
  simetris).
- Registry section di library => semua dial LIVE ke section existing.
- Preset mood (Soft/Solid/Ghost/Netral) biar eksplorasi cepat tanpa
  gerakin 5 slider.

Implementasi:
- LIB: Library.SectionAppearance {AccentBorder, BorderTransparency
  0.45, TextTransparency 0.5, Gap 10, Thickness 2} + SectionRegistry
  + ApplySectionAppearance + SetSectionAppearance (retune border
  color/transparency, gap, thickness, text transparency live).
  AddDivider mendaftarkan {Text, Lines, HalfX} lalu apply.
- MOD: groupbox kiri T1 "Section Divider" (toggle SD_Acc, slider
  SD_BT/SD_TT/SD_Gap/SD_Th, print+copy BuildSection sesuai aturan
  v4.8.5) dan kanan "Divider Presets" (4 preset + SyncKnobs via
  Library.Options). DEFAULTS.Section + Reset scheme apply.
  Simetri T1 5/5 -> 6/6.

## ↩️ v4.11.4 — SECTION v2: desain garis balik ke asli, cuma border yang sync

Salah gue di v4.11.3: request "garisnya juga ikut color" gue eksekusi
dengan MENGGANTI DESAIN garis (fill jadi AccentColor solid, border
dihapus) -> kelihatan bar neon tebal, user protes keras: "jangan
ngubah desainya astaga ini jelek co! cukup garis luar saja".

v4.11.4: struktur garis divider bertext DIPULIHKAN persis bawaan
library: BackgroundColor3 "MainColor" + BorderSizePixel 1. Satu-satunya
perubahan warna = BorderColor3 "OutlineColor" -> "AccentColor"
(theme-string, sync otomatis). Fill, ketebalan 2px, border 1px,
layout = identik bawaan. Text divider tetap AccentColor half-soft
sejak v4.11.3. Plain divider tetap netral.

Lesson (nambah aturan lama "jangan silent change semantics"): kalau
user minta ganti WARNA, jangan sentuh STRUKTUR/DESAIN instance-nya.

## 🌈 v4.11.3 — SECTION ikut color theme (text + garis)

Request user: divider bertext ("----- Selamat Datang -----") harus
ikut color theme yang di-sync; "jangan cuma text yang ikutin color
tapi juga garis section itu juga".

- TextLabel divider: TextColor3 = "AccentColor" (theme-string ->
  registry recolor otomatis tiap UpdateColorsUsingRegistry).
- Dua Frame garis sisi: BackgroundColor3 "AccentColor",
  BorderSizePixel 0 (sebelumnya fill MainColor + border OutlineColor
  1px yang bikin garis kelihatan abu-abu). Hasil: garis 2px accent
  bersih, sinkron sama accent picker / print tema.
- TextTransparency 0.5 dipertahankan (kelembutan existing; user ga
  minta ubah alpha) — garis solid, text half-soft.
- Divider polos (tanpa Text) TETAP netral: separator biasa bukan
  section header; accent di tiap pemisah = spam visual.

## ➡️ v4.11.2 — BUG #30: icon bolong (salah sumber verifikasi) + panah per sisi

User: "iconsnya mana? kok ga ada iconsnya? pake arrow kiri kanan bro!"

Root cause: rantai Library:GetIcon = atlas ONLINE (mirror lucide,
load async di runtime) -> fallback tabel subset OFFLINE yang embed
di file library. "arrow-left" cuma ada di atlas online; di env user
saat CreateWindow jalan, yang pasti tersedia subset offline ->
GetIcon("arrow-left") nil -> ImageButton image kosong. Verifikasi gue
kemarin lari ke tarball mirror repo (source.lua main branch), BUKAN
ke tabel embed library = sumber salah (varian baru pelajaran bug #29:
verifikasi terhadap SUMBER YANG DIPAKAI RUNTIME, bukan repo upstream).

Fix v4.11.2:
- Button kiri = "chevron-left", kanan = "chevron-right": dua nama ini
  ADA di tabel subset offline library (baris embed chevron-left /
  chevron-right) -> dijamin render online maupun offline.
- Identitas icon per sisi KONSTAN selamanya (tidak ada swap image).
- Animasi swap diganti slide: panel masuk (StatusHolder / SearchFrame)
  di-set Position offset Dir*24 lalu tween ke 0 (Quint-out 0.2s) =
  slide dari sisi button yang diklik. Spin Rotation dihapus.
- Checker nge-pin kedua nama chevron + nge-ban GetIcon("arrow-left").

## 🎨 v4.11.1 — STATUS BAR v2: warna prefix theme + icon konstan spin

Protes user: (1) prefix label card harus warna theme yang udah di-
sync, nilainya tetep putih; (2) icon button jangan ganti identitas
(zap<->search ditolak), harus panah kiri dengan animasi swap sesuai
sisi yang diklik, dan jangan kegedean.

- Card = 2 TextLabel via UIListLayout horizontal center: prefix
  `Key .. ":"` TextColor3 "AccentColor" (theme-string, ikut sync),
  nilai TextColor3 "FontColor" (putih). UpdateStatusBar sekarang cuma
  nulis label nilai -> prefix ga kedip-kedip.
- Icon button = "arrow-left" KONSTAN. Nama icon kali ini DIVERIFIKASI
  langsung dari tarball mirror lucide (source.lua icon array +
  codepoints) sebelum dipakai — pelajaran bug #29.
- Animasi swap: tween Rotation Btn +Dir*180 per klik (Dir = -1 tombol
  kiri / +1 tombol kanan) Quint-out 0.25s. Paritas rotasi = mode:
  genap = panah kiri (search), ganjil = panah kanan (status).
- Ukuran icon 24 -> 18px.

## 🔁 v4.11.0 — STATUS BAR SWAP (search bar <-> strip status card)

Request user: search bar atas diciputin kiri-kanan sedikit; di dua
sisinya button icon yang bisa diklik; klik kiri = search bar swap
jadi status "Fps: 50 Ping: 30 Server: V3.2 Executor: Delta" dengan
"card di setiap status itu".

Keputusan desain (kontribusi gue, anti-bengkak):
- Wrapper search bar dipangkas 32px per sisi (Position -44 -> -76,
  width offset -55 -> -119) = ruang button tanpa ngubah layout lain.
- Dua ImageButton (kiri+kanan wrapper) toggle state yang SAMA; icon
  nyebut mode: zap (=klik buat status) <-> search (=klik buat balik).
  Icon zap/search keduanya sudah terbukti ada di atlas lucide library.
- StatusHolder seat di slot yang sama (anak RightWrapper, Size 1,1,
  Visible flip). 4 card: UIListLayout horizontal padding 6, card
  Size 0.25,-6; resep card = resep search frame (MainColor solid +
  UIStroke OutlineColor theme-string + UICorner radius window via
  Library.Corners biar ikut dial radius).
- Loop status: task.spawn + RenderStepped frame counter, update teks
  2x/detik; START cuma saat strip visible, STOP saat swap balik =
  nol biaya saat sembunyi (aturan ramah fps).
- Ping = Players.LocalPlayer:GetNetworkPing() * 1000 (pcall).
  Executor = identifyexecutor() pcall, fallback "Studio"; keduanya
  bisa di-override: Library.StatusBar.Server / .Executor.
- Nol knob module baru (rilis library murni, module tidak berubah).

## 🔍 v4.10.3 — LOGO HOVER ZOOM (library langsung, tanpa preview dial)

Request user: logo window pojok kiri atas zoom saat cursor hover,
"mirip tab gitu lah pokoknya", dan "gausah preview langsung di
library saja" + jaga biar code ga bengkak.

Implementasi paling ramping: WindowIcon (ImageLabel/TextLabel di
TitleHolder TopBar) dapet satu UIScale + 2 koneksi mouse yang manggil
helper TAB yang udah ada: Library:TweenTabZoom(WindowIconScale,
TabAppearance.HoverZoom) saat enter, 1 saat leave. Konsekuensi desain
(disengaja): rasa zoom logo = rasa zoom tab SELALU (satu sumber
setting), dan dial manualnya numpang knob zoom tab yang udah ada di
groupbox "Tab Aktif & Zoom" — nol knob baru, nol kode tween baru.
TweenTabZoom sendiri udah gate: kalo zoom tab dimatiin, scale di-set
instant (konsisten sama perilaku tab).

## 📌 v4.10.2 — Bake print ICON ANIM (rilis ramping)

Print user: Zoom 15, Tilt 10, Speed 0.30 -> kebake verbatim di
Library.IconAnim defaults, DEFAULTS.IconAnim, fallback BuildIconAnim,
default slider IA_*. Nol kode/fitur baru (pesan user: jangan nambah
sampah, biar code ga bengkak). Checker nge-pin ketiga angka di LIB.

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

## v4.12.5 — OUTLINE ACCENT + PURGE KOMENTAR SAMPAH
Keputusan user (setelah reject v4.12.4 revert polos): "gue mau di section
garisnya itu di OUTLINE-nya yang berwarna, bukan semuanya berwarna" +
"text di section terlalu ga kelihatan" + "bersihin semua komentar di semua
code, sampah banget kalo banyak komentar ga penting".

- Garis divider: fill TETAP MainColor (desain asli library), yang berwarna
  cuma OUTLINE: BorderColor3 = "AccentColor" (frame 2px tinggi + border 1px
  = yang kebaca mata emang border-nya, fill nggak kelihatan). Struktur &
  geometri tidak disentuh sama sekali — cuma ganti string warna.
- Text divider: TextTransparency 0.5 -> 0 (full opaque, biar kebaca).
- Purge komentar: LIB 503 -> 149 baris komentar (149 itu komentar ASLI
  library dari baseline ec0f3a1, semua komentar gue hapus), MOD 218 -> 0,
  PRE 114 -> 0 (blok header 618 baris ikut lenyap). Total -1303 baris:
  LIB 16099->15745, MOD 1392->1174, PRE 1855->1124. Trailing comment
  tag versi (-- v4.x.x) di strip dari baris kode, baris kode utuh.
- Pelajaran: komentar penjelasan panjang itu SAMPAH buat user ini.
  Cukup kode yang jelas + DESIGN_NOTES + commit message sebagai memori.
  Checker sekarang pin: MOD/PRE nol baris komentar, LIB <=163 (komentar
  asli), dan nol tag "-- v4.x" di ketiga file.

## v4.12.6 — KNOB TRANSPARANSI DIVIDER (request user, bukan inisiatif gue)
User setelah v4.12.5: "jangan terlalu terang jir... terlalu mencolok.
kasih gue ui seting gue mau atur transparansinya sesuai keinginan gue
yang lengkap." Jadi KALI INI settings ada karena DIA yang minta.

- LIB: Library.DividerAppearance = { LineTransparency = 0.4 (default
  kalem, user bilang 0% terlalu mencolok), TextTransparency = 0 } +
  Library.DividerInstances (registry divider hidup, skip yang Destroyed)
  + Library:ApplyDividerAppearance() + Library:SetDividerTransparency
  (Line, Text) — nil = jangan ubah sisi itu. Clamp 0-1.
- Garis divider: BorderTransparency ikut DividerAppearance (border =
  outline accent yang kebaca; fill MainColor tetep). Text divider:
  TextTransparency ikut DividerAppearance.
- MOD tab UI Settings: box KIRI "Section Divider" (slider SD_LT 0-100%
  + sample AddDivider live di dalam box + print/copy) dan box KANAN
  "Section Text" (slider SD_TT 0-100% + print/copy). Simetri T1 6/6.
- Icons dicek ke subset offline: minus & type ada; printer/clipboard-check
  NGGAK ada jadi notify pakai info/copy.
- Pelajaran: user reject sistem section v4.12.0-4.12.3 karena gue yang
  inisiatif tanpa diminta; begitu DIA yang minta settings, ya dibuat.
  Bedanya request vs inisiatif.

## v4.12.7 — FIX divider v4.12.6 yang pecah di run user
Simptom di screenshot user v4.12.6: garis kiri pucat, garis kanan ILANG,
konten box setelah AddDivider pertama mati (box "Asset Dipakai" kepotong),
box settings divider cuma kebentuk satu => error runtime DI DALAM proses
create frame divider, instance setengah jadi (FillInstance loop property
ke-potong = property ketimpa acak => warna pucat).

Root cause perlakuan: v4.12.6 naruh field BARU (BorderTransparency dari
DividerAppearance) DI DALAM table New() yang diproses FillInstance +
theme-registry (generalized iteration, urutan property nggak dijamin).
Sekecil apa pun gangguan di jalur itu = instance setengah konfigurasi.

Fix (bisect ke jalur terbukti): table New() divider BALIK PERSIS bentuk
v4.12.5 (AnchorPoint/BackgroundColor3/BorderColor3/BorderSizePixel/
Position/Size/Parent doang). Transparansi garis & text di-assign SETELAH
instance jadi, angka langsung ke property (LineFrames[n].BorderTransparency,
TextLabel.TextTransparency) — nggak lewat FillInstance/registry sama sekali.
Default garis 0.4 -> 0.3 (user: 40% kebaca putih/pudar, 0% terlalu mencolok).
Pelajaran: JANGAN tambah key baru ke table New() komponen core yang lewat
FillInstance theme-registry; assign property numerik setelah instance lahir.

## v4.12.8 — HANDSHAKE VERSI + sample realtime di dua box
Report user v4.12.7: slider digeser GA ada perubahan, box kanan
("Section Text") hilang, dan "harusnya section lu taruh di tempat seting
biar gue bisa lihat secara realtime gue geser-geser".

Diagnosa pola gejala (slider mati + box kanan ga kebentuk + sample ga
keliatan) = module settings jalan melawan LIBRARY versi lama di run dia
(DividerAppearance/SetDividerTransparency nil => error saat box kiri
kebentuk => semua setelahnya mati). Bukan kode v4.12.7 yang salah jalur
(create frame udah bisect ke bentuk terbukti), tapi versi file di run
dia yang campur.

Fix:
- LIB: field Library.N3V4Version = "4.12.8" (handshake).
- MOD: dua box divider dibungkus guard
  `if type(Library.DividerAppearance) == "table" and type(Library.SetDividerTransparency) == "function"`
  — kalau library lama, box dilewati DAN print diagnostik jelas di Output
  (sebut N3V4Version yang kebaca), bukan error bisu yang matikan sisa UI.
- Sample divider REALTIME sekarang di DUA box: "Contoh garis" di box kiri
  (sebelah slider garis) dan "Contoh text" di box kanan (sebelah slider
  text) — persis request user: geser slider, contoh di sebelah tangan lu
  berubah detik itu juga.
- Pelajaran: fitur module-yang-butuh-API-library baru WAJIB pakai guard
  versi + pesan diagnostik, biar mismatch versi file di run user nggak
  pernah lagi tampil sebagai "UI rusak / gue ngetroll".

## v4.12.9 — DIVIDER ANTI-MATI + instrumen error ASLI
Screenshot Studio user (v4.12.8, Output bersih, library BARU ter-load):
box setting kiri mati tepat setelah slider (sample "Contoh garis" ga
sempat lahir), box kanan hilang, box PRE kepotong di divider pertama.
Titik mati di MOD vs PRE BEDA (MOD: sebelum frame pertama, kemungkinan
di callback default slider -> SetDividerTransparency -> Apply;
PRE: setelah frame kiri). Error yang titik-nya beda-beda = nggak bisa
gue tembak buta lagi tanpa log asli.

Keputusan desain: UI nggak boleh bisa MATI karena divider.
- AddDivider: create frame garis lewat SafeLine = pcall(New, "Frame",
  props). Gagal => warn("[N3V4] divider line gagal dibikin: <error ASLI>")
  dan return nil; box + konten setelahnya TETAP HIDUP. Assign
  BorderTransparency di-guard nil. Apply loop skip nil.
- SetDividerTransparency: ApplyDividerAppearance di-pcall; gagal =>
  warn error asli. Jadi callback default slider nggak bisa lagi
  matikan pembangunan box setting.
- Efek samping sengaja: kalau flake-nya masih ada, Output user sekarang
  bawa pesan error PERSIS (warn) => round berikutnya sniper, bukan nebak.

## v4.12.10 — ROOT CAUSE SEBENARNYA: BorderTransparency GA ADA di Roblox modern
User kirim console lengkap v4.12.9: TIGA komponen GAGAL semua dengan
pesan SAMA: "BorderTransparency is not a valid member of Frame".
Property itu memang SUDAH DIHAPUS Roblox (border legacy diganti
UIStroke); yang masih hidup cuma BorderColor3/BorderSizePixel
(deprecated). Jadi semua round v4.12.6-4.12.9 mati di assign property
hantu — titik matinya kelihatan "berpindah-pindah" karena assign-nya
gue pindah-pindah (dalam table New -> pasca-create -> di-guard nil),
padahal biangnya satu: property tidak eksis.

Kenapa lolos gates gue: luau-analyze --mode=nonstrict nggak flag
unknown member assignment, dan gue cuma grep SyntaxError. Pelajaran:
property Roblox yang dipakai WAJIB diverifikasi eksis (docs/API), dan
checker sekarang pin `! grep BorderTransparency` di LIB/MOD/PRE.

Fix bener: outline garis = UIStroke child (ApplyStrokeMode Border,
Color "AccentColor" theme string, Thickness 1, Transparency =
DividerAppearance.LineTransparency) — pixel IDENTIK border 1px desain
asli (frame 2px, stroke 1px atas+bawah), tapi Transparency-nya property
ASLI jadi knob 0-100% akhirnya beneran berfungsi. Frame garis:
BorderSizePixel 0, fill MainColor tetep. SafeLine return stroke-nya;
Divider.Lines = daftar stroke; ApplyDividerAppearance fade via
Stroke.Transparency. Assign transparansi pasca-create DIHAPUS semua.

## v4.12.11 — BAKE dump user: LineTransparency 0.4 / TextTransparency 0
User confirm v4.12.10 sehat ("nah gitu dong mantap") dan dump resep
lewat tombol Print: "[N3V4 DIVIDER] LineTransparency = 0.4 |
TextTransparency = 0". Sesuai aturan standing: print user = bake
verbatim. Default Library.DividerAppearance.LineTransparency 0.3 ->
0.4; TextTransparency tetep 0. Slider MOD baca default dari LIB jadi
ikut otomatis.

## v4.13.0 — DROPDOWN CHECK (diskusi dulu, baru kode — sesuai aturan)
Request user (diskusi -> GO): "ketika gue select listnya harusnya ada
icons kecil centang/checklist... warna hijau... di kanan nya", berlaku
v1 DAN v2, multi = semua baris yang ke-select (konsisten v2).

Keputusan diskusi yang user kunci: (1) dot bulat accent v2 DIGANTI
centang (satu penanda, bukan dua), (2) hijau = usul gue RGB(86,197,110)
(user nggak kasih hex lain => konstanta semantic, bukan theme string,
bukan knob/box baru = nol sampah), (3) v1 multi konsisten v2.

Implementasi:
- CheckIcon = Library:GetIcon("check") UDAH ADA top-level (line ~3698,
  di-reresolve di SetIconModule) — dipakai, bukan bikin baru.
- local SelectedCheckColor = Color3.fromRGB(86, 197, 110) top-level.
- V1 (AddDropdown, menu context): ImageLabel check 14px anchor kanan
  offset -7 (nyamain UIPadding baris) per row; toggle di
  Table:UpdateButton() (kepanggil saat klik, drag-select, build).
- V2 (AddDropdownV2): Dot Frame+UICorner (2 instance) DIGANTI ImageLabel
  check 14px offset -10 (slot dot lama) = lean -1 instance/baris;
  RowRecs.Dot -> RowRecs.Check; Refresh toggle Rec.Check.Visible.
- Preview: Dropdown_Single demo udah Default = 1 jadi centang langsung
  keliatan pas list dibuka — user minta "pengen lihat previewnya".
- Checker: pin warna konstan + kedua toggle + absensi Dot lama +
  jumlah ImageColor3 SelectedCheckColor == 2 (v1+v2, nggak lebih).

## v4.13.1 — SLIDER ARROWS +/-1 (diskusi -> GO, rekomendasi gue dipakai semua)
Keputusan user: stacked atas-bawah di kolom 14px (rekomendasi), step
+/-1 satuan value mentah (rekomendasi), release + masih hover = muncul
lagi (rekomendasi). Animasi/durasi KONSTANTA internal dulu — knob
setting menyusul KALAU user minta (pola divider: dia yang request).

- Track Bar dipendekin 16px (Size 1,-16); kolom ArrowHolder 14x15px
  anchor kanan-bawah nempel 2px di samping track (tinggi = tinggi
  track, ga makan tempat vertikal).
- Dua TextButton stacked 14x7: up (chevron-up, pakai ArrowIcon top-level
  yang udah ada) + down (ChevronDownIcon top-level BARU, di-reresolve
  di SetIconModule). Icon 8px, ImageColor3 theme string "FontColor",
  hover panah = AccentColor (assign Color3 asli, aman bug #31).
- Klik = Slider:SetValue(Value +/- 1) => clamp Min/Max + Display +
  RunChanged (Callback/Changed/dependency nyala sama kayak drag).
- Show/hide: Holder.MouseEnter -> SetArrows(true) tween fade 0.12s ke
  transparency 0.45; MouseLeave -> fade ke 1. Selama drag/hold track:
  ArrowsHolding = true + SetArrows(false) (suppress); InputEnded release
  -> kalau ArrowsHover masih true, muncul lagi.
- SetDisabled: arrow buttons ikut Active=false + panah disembunyiin.
- Semua connection masuk Slider.Connections (cleanup Destroy aman).
- Checker pin: ChevronDownIcon top-level, SetArrows, kedua SetValue
  +/-1, ArrowsHolding, Size track -16. 73 checks.

## v4.13.2 — SLIDER ARROWS DIHAPUS BERSIH (verdict user: "jelek")
User setelah lihat v4.13.1 di preview: "hapus saja deh jir gue ga suka.
jelek soalnya. hapus bro sampai bersih biar ga ada up down lagi."
Revert total: ArrowHolder + 2 button + icons + SetArrows +
MakeArrowButton + state hover/holding + hook drag-hold + SetDisabled
arrow + ChevronDownIcon top-level + track -16px => SEMUA lenyap;
slider balik persis perilaku pra-v4.13.1. Checker pin ABSENSI enam
nama biar fitur ini nggak hidup lagi diam-diam.
Pelajaran (sama kayak section saga): fitur visual yang udah diskusi +
GO pun masih bisa ditolak mata user saat lihat render aslinya — revert
bersih adalah fitur juga. Dan: print/changelog JANGAN sebut literal
nama yang di-pin absensi (self-pin trap, ketiga kalinya).

## v4.14.0 — BUTTON GRADIENT 3D (spec user langsung + GO)
User: "semua button harus kita upgrade visualnya... gradian biar kayak
3d... di tengah itu sedikit hitam di atas bawah putih. jadinya ada 3
bro... kasih tombol setingan biar gue bisa print nanti selera gue
gimana dll. gasken bro!"

- Implementasi: UIGradient child di Base setiap button (CreateButton =
  bottleneck tunggal SEMUA button elemen, termasuk pasangan double-
  click). ColorSequence 3 keypoint: 0 = putih, 0.5 = abu gelap
  (1 - MiddleDark), 1 = putih. Sebagai MULTIPLIER warna background:
  atas/bawah = warna asli button, tengah = sedikit hitam = bevel 3D.
  Theme-safe: gradient nggak nyentuh warna tema, cuma modulasi.
- State: Library.ButtonGradient { Enabled = true, MiddleDark = 0.35 }
  + registry ButtonGradientInstances (skip yang Parent-nya udah
  Destroyed) + ApplyButtonGradient + SetButtonGradient(Enabled,
  MiddleDark) di-pcall (pola v4.12.9).
- MOD tab UI Settings: box KIRI "Button Gradient" (toggle BG_ON +
  slider BG_MD 0-100%) dan box KANAN "Sample Gradient" (button sample
  live + Print + Copy snippet Library:SetButtonGradient(...)) — pola
  divider: user geser, lihat sample realtime, Print dump, gue bake
  kemudian. Guard versi handshake sama kayak box divider.
- Simetri T1 6/6 -> 7/7. Block dipasang SESUDAH box Resep Tema (pin
  chk v4.9.2 konteks Try("Settings: info") -> Resep Tema harus utuh).
- Scope jujur: button ELEMEN (AddButton). Tab/footer/display dropdown
  nggak disentuh — kalau mau melar, user yang minta.

## v4.14.1 — GRADIENT FIX + SETINGAN LENGKAP (tiga kesalahan gue di v4.14.0)
User rage valid, tiga bug/kekurangan v4.14.0:
1. ROTASI KELUPAAN: UIGradient default Rotation 0 = gradient jalan
   KIRI-KANAN, padahal spec asli dia "atas putih tengah hitam bawah
   putih" = vertikal. Dia yang harusing ingat-inatin "-90 derajat".
2. SLIDER GA NGARUH: loop ApplyButtonGradient cek
   `Gradient.Parent.Destroyed` — Parent itu INSTANCE Roblox, property
   Destroyed GA ADA => baca member hantu = error runtime => pcall nelan
   => apply mati total => semua knob jadi patung. (Pola hantu yang sama
   kayak BorderTransparency v4.12.6! Beda bentuk: baca vs tulis.)
3. SETINGAN KEMISKINAN: 1 toggle + 1 slider, padahal dia minta "lengkap
   transparansi, jarak, dll" + warna atas/tengah/bawah bisa dipilih.

Fix v4.14.1:
- Default Rotation = -90 (vertikal: atas-tengah-bawah bener).
- Liveness loop: `if Gradient.Parent then` (Parent nil setelah
  destroy) — nol property hantu.
- State lengkap: Enabled, Rotation, MiddlePosition, MiddleTransparency,
  Offset, ColorTop, ColorMiddle, ColorBottom. API diganti table:
  Library:SetButtonGradient({ Key = Value, ... }) dengan guard tipe
  per-key (pola SetTabAppearance).
- CreateButton build gradient dari state penuh (ColorSequence 3 stop
  warna pilihan + NumberSequence transparansi tengah + Rotation +
  Offset Vector2).
- MOD box kiri "Button Gradient": toggle BG_ON + TIGA ColorPicker
  addon di toggle itu (Atas/Tengah/Bawah — ColorPicker library ini
  emang harus nempel toggle jadi addon) + 4 slider: BG_ROT -180..180,
  BG_POS posisi stop tengah %, BG_TR transparansi tengah %, BG_OFF
  offset %. Box kanan "Sample Gradient": sample + Print dump penuh +
  Copy snippet SetButtonGradient({...}) lengkap buat dia dump -> gue
  bake kemudian.
- Pelajaran ganda: (a) property/anggota Roblox WAJIB diverifikasi eksis
  — baca ATAU tulis; (b) "kasih tombol setingan" dari user artinya
  LENGKAP sesuai kalimat dia (transparansi, jarak, dll), bukan versi
  minimal gue.

## v4.14.2 — PRINT/COPY DI BOX KIRI GRADIENT (standing rule kelewat)
User: "printnya mana cok? gue udah buat cuma print nya mana? gue mau
print hasil gue ga bisa!" — dia geser knob di box KIRI "Button
Gradient", tapi Print/Copy cuma ada di box kanan "Sample Gradient".
Standing rule v4.8.5: TIAP settings groupbox nutup pakai print+copy —
gue langgar pas v4.14.1 (box kiri gue akhiri di slider).

Fix: fungsi PrintGrad/CopyGrad jadi local shared (single
implementation), dipanggil button di DUA box: box kiri nutup pakai
Print+Copy sekarang, box kanan tetep. Checker pin: jumlah string
'Print setingan gradient' & 'Copy setingan gradient' di MOD harus
persis 2-2 + PrintGrad ada.
Pelajaran: standing rule list itu DIPAKAI saat nulis box baru, bukan
diingat sesudah user nagih.

## v4.15.0 — GRADIENT BAKE VERBATIM + MERATA KE SLIDER/INPUT/DROPDOWN
Dump user (print v4.14.2) dibake VERBATIM sesuai standing rule:
Enabled true | Rotation -90 | MiddlePosition 0.5 | MiddleTransparency 0
| Offset 0.01 | Top 85,85,85 | Middle 224,224,224 | Bottom 85,85,85.
(Rasa dia: tengah TERANG, tepi gelap = band glow di tengah button.)

Request lanjut: "terapin ini ke slider, dropdown, input juga... di
slider itu bukan yang unggunya/bar slidernya tapi di slider nya...
harus sinkron jangan hardcode."
- Slider: gradient di BODY track (Bar TextButton MainColor), BUKAN di
  Fill ungu — sesuai klarifikasi dia.
- Input: body TextBox (AddInput).
- Dropdown v1: DisplayContainer + frame menu (MenuTable.Menu).
- Dropdown v2: DisplayContainer + PopupFrame; gradient popup di-
  remove dari registry saat ClosePopup (bocor memori dicegah).
- Sinkron: SATU helper local MakeGradient(Parent) + SATU state
  Library.ButtonGradient + SATU loop apply + SATU registry => semua
  elemen ikut knob yang sama realtime, nol hardcode per elemen.
- MOD: box kiri rename "Gradient 3D", toggle "(semua elemen)"; box
  kanan dapet sample slider + sample input biar semua jenis elemen
  keliatan live saat tuning. Print/Copy tetep di dua box.
- Checker: pin bake (Offset 0.01 + RGB 85/224/85) + pin MakeGradient
  di semua call site + count >= 8.

## v4.15.1 — GRADIENT NAVBAR (search bar + kartu status)
User: "gue lupa harusnya lu bikin juga di search bar navbar atas itu...
sama fps ping dll."
- SearchFrame (bar search MainColor di TopBar) + 4 kartu status
  Fps/Ping/Server/Executor (dibuat sekali saat window => registry
  aman, tanpa cleanup khusus) ikut MakeGradient yang SAMA => sync
  penuh ke semua knob Gradient 3D, nol hardcode.
- Pin checker: MakeGradient(SearchFrame) + MakeGradient(Card).

## v4.15.2 — FIX SCOPE MakeGradient (error nil di CreateWindow)
Error user v4.15.1: "ReplicatedStorage.N3V4:11427: attempt to call a
nil value" di CreateWindow. Root cause: MakeGradient gue definisi
sebagai local DI DALAM do-block komponen (±5850); call site elemen
(AddButton/AddSlider/AddDropdown/AddInput) ada di do-block yang sama =
aman, tapi CreateWindow (navbar search + kartu status, ±11427) ada DI
LUAR block itu => MakeGradient nil di sana.
Kenapa gates lolos: gate analyze gue cuma grep SyntaxError; local out
of scope = dipanggil sebagai global nil = runtime error, bukan syntax.
Fix: MakeGradient jadi local TOP-LEVEL (kolom 0) tepat setelah
definisi New() => kelihatan seluruh file. Checker pin penempatan:
harus ada '^local function MakeGradient(Parent)' dan NOT ada versi
indent-tab.
Pelajaran: helper yang dipakai lintas blok WAJIB top-level; dan gate
analyze patut di-grep juga untuk "Unknown global '<nama helper gue>'"
buat call site lintas scope.

## v4.16.0 — OUTLINE SPIN: pita cahaya muter di outline window (opsi A radar sweep)
Request user: outline window dikasih gradient warna yang MUTER TERUS
(loop infinite), tapi cuma SETENGAH keliling yang nyala ("setengah
saja jangan full"). Diskusi dulu (dia minta konfirmasi paham), dia
pilih A = radar sweep (bukan B uler-pinggir 4 stroke), warna default
putih cahaya silver, minta knob warna + speed + dll.
Kenapa overlay Holder sendiri (bukan nempel NeonWindowStroke): stroke
itu udah punya UIGradient yang DIKELOLA glow engine (OuterGradients +
GetSolidSequence + PulseWindowGlow) — numpang di sana = nabrak resep
glow v1 yang locked. Holder transparan (pola InnerBorderFrame:
AnchorPoint tengah, ZIndex parent+2, corner 10) + UIStroke putih 1.8
Border + UIGradient sendiri = nol interferensi.
Visual: ColorSequence A(putih)→B(silver)→A; Transparency 0 s/d 0.3
lalu fade ke 1 di 0.5 → setengah keliling nyala, setengah hilang;
Rotation 0→360 tween Linear repeat -1 = muter terus.
Sinkron pola gradient button: satu state Library.OutlineSpin +
registry OutlineSpinObjects + ApplyOutlineSpin loop (liveness
Grad.Parent) + SetOutlineSpin(Info) guarded per-key. API = member
Library (BUKAN local) → kebal bug scope v4.15.2.
CreateWindow: Library:AddOutlineSpin(MainFrame) setelah OuterGradients
solid-sequence loop. MOD T1 8/8: kiri "Outline Muter" (refresh-cw) =
OS_ON toggle + OS_C1/OS_C2 picker + OS_SPD slider 1–20s Rounding 1 +
Print/Copy (ATURAN v4.14.2: dipasang SAAT NULIS); kanan "Sample
Outline Muter" (loader) = mini window RAW (Instance.new, MainColor +
stroke accent) didaftarkan AddOutlineSpin(SampleWin) → sample muter
BENERAN dan ikut semua knob lewat registry yang sama.
Default bake: Enabled true, Speed 4, ColorA fromRGB(255,255,255),
ColorB fromRGB(192,196,204). Gates: 76 checks, symmetry 8/8+4/4,
0 SyntaxError, 0 unknown-global nama baru.

## v4.16.1 — FIX TWEENINFO ARG ORDER (outline spin error saat lahir)
Error user: "TweenInfo.new third argument expects Enum.EasingDirection
input" di ApplyOutlineSpin. Salah gue: signature TweenInfo.new =
(time, easingStyle, EASINGDIRECTION, repeatCount, reverses, delay) —
gue taro -1 (repeatCount) di posisi ketiga. Fix: (speed, Linear,
Enum.EasingDirection.InOut, -1). Checker pin urutan argumen ini biar
gak keulang (grep -qF 'Enum.EasingStyle.Linear,
Enum.EasingDirection.InOut, -1').
Pelajaran: argumen posisional API Roblox yang opsional-di-tengah
(gini) wajib dicek urutannya satu-satu; luau-analyze nonstrict TANPA
defs gak ngecek arity/tipe argumen → blind spot kedua setelah
unknown-member.

## v4.16.2 — OUTLINE SPIN TUNING: bake dump user + pita dipendekkin
Dump user (bake verbatim, protokol v4.12.11/v4.15.0): Speed = 5.5,
ColorB = Color3.fromRGB(193, 193, 193) (silver murni pilihan dia);
ColorA 255,255,255 & Enabled true udah sama.
Request: "panjangnya jangan terlalu panjang, sedikit lebih pendek."
Curve lama: transparency 0 s/d 0.3 lalu fade ke 1 di 0.5 (setengah
keliling nyala). Baru: 0 s/d 0.15, fade beres di 0.35 — pita ±30%
lebih pendek.
Penyesuaian wajib (root-cause, bukan kosmetik): keypoint ColorB di
ColorSequence digeser 0.5 → 0.35. Kalau nggak, ekor silver jatuh di
zona yang udah fully transparent = warna pilihannya gak pernah
keliatan. Sekarang fade warna persis nutup fade alpha: kepala putih
→ ekor silver → hilang.
MOD gak disentuh (knob baca state otomatis, Rounding 1 muat 5.5).
Checker: pin bake baru (Speed 5.5 / 193,193,193) + pin 3 keypoint
curve (0.35 ColorB, 0.15/0 alpha) + version/footer 4.16.2.

## v4.17.0 — GLOW ON CLICK: pulse RGB cuma dipicu click kontrol
Keputusan user (diskusi 4 poin): (1) auto-pulse 25 detik HAPUS;
(2) trigger = click kontrol (button/toggle/tab/dll), BUKAN click
sembarang objek window; (3) slider/input NGGAK ikut ("button-button
saja"); (4) gasken.
Arsitektur: SATU hook pusat di CreateWindow (menggantikan loop 25s):
HookGlowClicks(Obj) — kalau Obj GuiButton DAN nggak punya attribute
NoGlowPulse → Obj.Activated:Connect(PulseWindowGlow). Dipasang lewat
MainFrame:GetDescendants() awal + MainFrame.DescendantAdded → semua
kontrol yang udah ada DAN yang dibikin nanti (tab, toggle, button,
dropdown display+row, swatch picker, keybox, kartu, panah) kecover
otomatis. Mesin PulseWindowGlow + resep glow TIDAK disentuh.
Exclude via SetAttribute("NoGlowPulse", true) di 6 drag/click-catcher
surface: slider Bar (TextButton!), PopupOverlay + PopupFrame v2
(TextButton click-catcher, parent MainFrame), SatVipMap +
TransparencySelector (ImageButton drag), HueSelector (TextButton
drag). Pelajaran: kelas GuiButton nggak selalu = tombol diskrit —
drag surface di lib ini banyak yang TextButton, makanya exclude-nya
per-object attribute, bukan per-class.
Dua call site ad-hoc lama dicabut (single implementation): pulse di
Button.Base.MouseButton1Click (dobel sama Activated) dan pulse di
Toggle:SetValue (kepicu non-click: keybind/script — user minta strict
click). Klik close/minimize: PulseWindowGlow punya guard
Unloaded/Toggled/Parent → aman.
Checker: chk v4.17.0 (hook + DescendantAdded + guard attribute +
count SetAttribute == 6 + absensi task.wait(25)/MASUKKAN DI SINI/
call ad-hoc). Sempat merah 1x: count-pin kelebihan backslash
(file bytes \\" = nutup double-quote bash di tengah string) →
konvensi escape chk: literal quote di pattern = \" (satu backslash).

## v4.17.1 — FIX VIEWPORT 3D: kamera kabur eksponensial + orbit bener + klik kanan
User report: (1) viewport interaktif geser-geser ga work, klik kiri
malah model menjauh; (2) Asset 3D baru muncul udah hilang sendiri
tanpa diklik. Dua-duanya BUG, satu akar:
Spin loop & drag handler AddViewport menghitung `dist` dari POSISI
KAMERA SAAT INI lalu menaruh kamera baru di (sin*dist, 0.25*dist,
cos*dist) — magnitudo vektor itu dist*sqrt(1+0.0625) = dist*1.0308 →
jarak NAIK 3.08% TIAP FRAME. Spin 60fps = kamera kabur x6/detik →
model lenyap dalam detik (Asset 3D). Drag = sama, makanya "klik kiri
malah menjauh". AngleX vertikal juga dead code (deklar doang).
Fix di AddViewport: CameraDistance KONSTAN (diset AutoFocus dari
bounding box, gak pernah dihitung ulang dari kamera), orbit spherical
bener: offset = (sin az * cos el, sin el, cos az * cos el) * dist;
AngleX hidup + clamp -75..75 (drag vertikal sekarang miringin view);
putar manual pindah ke MouseButton2 (klik kanan) + Touch sesuai
request user, klik kiri di viewport sekarang diem.
Scope check: 2 copy rumus mirip di AddSpotlightCard (5715) &
CreateDashboardWindow (14707) TIDAK kabur — dist mereka dari
bounding box model (konstan), bukan dari kamera → dibiarkan (lean).
Pin checker v4.17.1: OrbitCamera + CameraDistance konstan + clamp
AngleX + MouseButton2 + absensi dist-dari-kamera + label PRE "Klik
kanan + drag...". Sempat 2x merah: (a) absence pin kegedean (kena 2
copy aman) → dipersempit ke signature kabur aslinya; (b) pin pakai
BRE padahal pattern punya `*` literal → pindah -qF.

## v4.18.0 — SPOTLIGHT CARD UPGRADE: dua panel ber-frame pisah (image/3D + text)
Request user: upgrade komponen YANG UDAH ADA (bukan komponen baru):
image kiri + text kanan "kayak dikasih cut/dipisah", image punya
frame sendiri, text punya frame sendiri, isi text opsional (impor
TextLabel game / manual baris berwarna kayak Rarity-Name / no-text =
full kayak dulu), jalan buat sisi image MAUPUN 3D, setingan lengkap.
Struktur baru AddSpotlightCard: CardFrame > ImagePanel (frame:
MainColor + corner registry + UIStroke OutlineColor) > MediaBox
(inset 3, clip) > IconImg/Viewport3D; CardFrame > TextPanel (frame
sama) > UIListLayout+UIPadding > TitleLabel(autoY) + DescLabel
(autoY) + baris SetLines (RichText <font color> label berwarna +
nilai putih) + BindMirror (autoY, live mirror TextLabel sumber via
GetPropertyChangedSignal("Text")).
Mode: HasText = (not Info.NoText) and (Title/Description/Lines/
BindLabel ada); SetData(title/desc) menyalakan mode text kecuali
NoTextLocked; Relayout() ngatur size/posisi dua panel pakai math
scale+offset (imageW = (W-8)*frac - gap/2 dst) jadi ikut resize
otomatis tanpa signal tambahan.
State global Library.CardPanels {Gap 6, ImageWidth 40, Outline true,
FrameTransparency 0.5, TextSize 12} + ApplyCardPanels (loop registry
SpotlightCards, liveness Frame.Parent) + SetCardPanels guarded per
key + clamp — pola kembar OutlineSpin/ButtonGradient.
API kartu: CardObj:SetLines(list {Label,Value,Color}), CardObj:
BindLabel(instance) live mirror + disconnect conn lama, CardObj:
Relayout(). SetData lama tetap kompatibel.
MOD T1 9/9: kiri "Kartu Media" (layout-dashboard) = CP_GAP/CP_WID/
CP_TR/CP_TS slider + CP_OUT toggle + Print/Copy; kanan "Sample
Kartu" (list) = kartu sample Lines berwarna + bind live TextLabel
(counter detik via task.spawn) + Print/Copy. Sampah dibuang sebelum
commit: picker CP_CC callback kosong + local TogOut nganggur.
PRE: Media_Spotlight + SetLines Rarity/Mutasi berwarna; kartu baru
Media_NoText (NoText=true) demo mode full; label penjelasan.
Checker: chk v4.18.0 21 pin (state/API/registry/panel names/knob/
sample/print-copy count==2/NoText/SetLines di PRE/BindLabel di MOD).
Sempat merah 1x: pin BindLabel salah file (PRE vs MOD) → dipindah.

## v4.19.0 — CARD GRADIENT: background gradient 3 stop di ImagePanel + bake dump
Bake dump user verbatim ke Library.CardPanels: Gap = 8,
FrameTransparency = 0.7, TextSize = 14 (ImageWidth 40 & Outline true
tetap).
Fitur: ImagePanel punya UIGradient di BACKGROUND-nya (gradient
berwarna di belakang image/3D). State global Library.CardGradient
{Enabled true, Rotation -90, MiddlePosition 0.5, MiddleTransparency 0,
Offset 0.01, Top 38/38/44, Middle 110/110/122, Bottom 38/38/44} +
SetCardGradient guarded + ApplyCardGradient loop registry.
PER-KARTU override (flow rarity dari script game user):
Card:SetImageGradient(Info) — pertama kali table.clone(global) lalu
merge guarded; kartu yang punya GradientConf DILEWATI apply global
(jadi knob settings gak nimpah warna rarity). Card:ClearImageGradient
balik ke global. Jawaban "3 ok?" = 3 stop warna (atas/tengah/bawah)
pola kembar gradient button.
Detail penting: UIGradient MULTIPLY pixel background — base MainColor
gelap bikin warna rarity mati. ApplyImageGradient set
BackgroundColor3 = putih pas Enabled (warna gradient keluar murni),
balik Library.Scheme.MainColor pas disabled.
MOD T1 10/10: kiri "Gradient Kartu" = CG_ON + CG_C1/2/3 + CG_ROT/
CG_POS/CG_TR/CG_OFF + Print/Copy; kanan "Sample Gradient Kartu" =
kartu NoText live (ikut knob global) + Print/Copy.
PRE: Media_Spotlight di-override gradient emas mythic (demo rarity).
Checker: 2 merah dulu — (a) label baru "Print setingan gradient kartu"
mengandung substring pin lama count==2 → pin lama diperketat ke
signature lengkap '...", PrintGrad'; (b) pin GradientConf salah prefix
(Card. vs CardObj.) → dipotong prefixnya. Sekarang 80 checks.

## v4.20.0 — MODULAR VISUALS: N3V4Visuals ModuleScript + engine gradient EasyVisuals
Keputusan user (4 poin): modular GO; module hilang = fitur mati +
print instruksi (bukan fallback); preset kurasi 8 (Gold Silver
Chrome Rainbow Neon Sunset Oceanic Lava); knob 3-stop v4.19 jadi
preset "Custom" (tetap hidup).
Arsitektur: file BARU Library/N3V4Visuals.module.lua (= ModuleScript
"N3V4Visuals" di ReplicatedStorage, SEBELAH ModuleScript N3V4; user
bikin manual di Studio, paste isi file ini). Isinya: (1) engine
Gradient adaptasi EasyVisuals source user — Heartbeat loop: Offset
MENGALIR (OffsetSpeed*dt, warna di-sample ulang tiap frame jadi pita
warna jalan), RotationSpeed (spin), blend morph (SetColorSequence
seq+blendRate: keypoint di-lerp bertahap), auto-Destroy pas parent
mati, Pause/Resume; (2) Presets.Order + Presets.Sequence (8 sequence
multi-keypoint ditranskrip verbatim dari preset source user);
(3) SELURUH body AddViewport + AddSpotlightCard pindah ke sini
sebagai local function(Env, Groupbox, Idx, Info), Env = {New,
Library, Options} di-inject dari LIB biar closure deps aman.
LIB: require guard di atas (script.Parent:FindFirstChild
("N3V4Visuals") + pcall + validasi tipe; gagal/hilang = print
VisualsMissing sekali); AddViewport/AddSpotlightCard jadi delegate
tipis (return nil + print kalau Visuals nil); wrapper legacy
RichAddViewport (Info.Object) TETAP di LIB dan nge-chain ke delegate
✓. Neto LIB -520 baris (16314 → 15794).
CardGradient reshape: {Enabled, Preset="Custom", OffsetSpeed=0.3,
RotationSpeed=0, ColorTop/Middle/Bottom}; knob v4.19 (ROT/POS/TR/OFF)
DIGANTI dropdown CG_PRESET (9 opsi) + CG_FLOW (0-200%) + CG_SPIN
(-180..180 deg/s); picker Custom CG_C1/2/3 tetap. ApplyImageGradient
(engine): disable = base balik Scheme.MainColor; enable = base putih
+ Gradient.new(ImagePanel, seq preset/custom, 0) + SetOffsetSpeed +
SetRotationSpeed; GradientConf per-kartu tetap skip apply global.
PRE: kartu 3D demo SetImageGradient({Preset="Gold", OffsetSpeed=0.35}).
Checker: $VIS masuk loop syntax + pin v4.17.1/4.18.0/4.19.0 dipindah
ke $VIS (kode组件 udah di sana, string Env.Library dst); chk v4.20.0
baru. Merah dulu: (a) komentar delegate INDONESIAN kena guard v4.8.1
→ English; (b) escape pin 3-byte \\" nutup string bash (27 tempat) →
4-byte; (c) absence pin World3D salah (legacy viewport Object path
memang tetap di LIB) → diganti absence Name="ImagePanel" di LIB.

## v4.20.1 — FIX ENGINE: ColorSequence wajib end di t=1
Error user spam: "ColorSequence must end at time=1.0" di N3V4Visuals
line 68 (Heartbeat engine). Salah gue: loop sampling output cuma
bikin keypoint t = 0..7/8 (SAMPLES-1) — ColorSequence Roblox WAJIB
punya keypoint terakhir di time 1.0. Fix: kedua loop (blend + output)
jadi `for i = 0, SAMPLES do` → 9 keypoint, t=1 di-sample lewat wrap
modulo jadi warnanya sama dengan t=0 = flow seamless DAN legal.
Checker pin: count loop baru == 2 + absensi loop lama.
Pelajaran escape chk (ketiga kalinya): count-pin di dalam double
quote wajib `\$(` (nunda substitution ke eval), bukan `$(` (ke-
substitute pas parse baris). Byte persis: `\"` quote + `\$` dollar.

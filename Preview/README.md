# N3V4 — Preview Kit (v4)

Preview lengkap semua fitur UI library N3, buat dites di **Roblox Studio**.

> Keputusan desain, kronologi icon, jebakan API, dan roadmap ada di **`../DESIGN_NOTES.md`**.

---

## Setup

### 1. ModuleScript library ⚠️ **WAJIB COPY ULANG**

```
ReplicatedStorage
└── N3V4          <- ModuleScript
```

Isi = **seluruh kode** `Library/N3V3-NoObfus.lua`.

> **Library-nya berubah** (icon fallback + animasi ON + radius 10).
> Kalau lu masih pakai copy lama, icon-nya tetep nggak muncul.

### 2. LocalScript preview

```
StarterPlayer
└── StarterPlayerScripts
    └── N3V4_Preview   <- LocalScript
```

Isi = **seluruh kode** `N3V4_Preview.client.lua`. Nama bebas, yang wajib tipenya
**LocalScript** dan lokasinya di **StarterPlayerScripts**.

### 3. HTTP Requests — sekarang beneran **OPSIONAL**

`File > Game Settings > Security > Allow HTTP Requests`

Icon lucide punya **fallback offline di dalam library**, jadi:

| HTTP | Hasil |
|---|---|
| **OFF** | ✅ Semua icon muncul (117 icon offline, spritesheet publik) |
| **ON** | ✅ Semua icon muncul (1866 icon penuh dari gitlab / mirror GitHub) |

---

## Yang baru di v4 — WALLPAPER 🖼️

Fitur baru, **full di library** (bukan preview-only):

| Kontrol | Detail |
|---|---|
| **Asset ID** | Paste angka polos (`111593326989465`), `rbxassetid://...`, atau URL |
| **Transparency** | 0–100% |
| **Tint** | ColorPicker (`ImageColor3`) |
| **ScaleType** | Crop / Fit / Stretch / Slice / Tile — **member asli Roblox** (`Fill` nggak ada, tapi gue bikinin alias `Fill`/`Cover` → `Crop`) |
| **Layer** | `back` (wallpaper di belakang konten) / `front` (wash di atas, perilaku lama) |
| **Overlay / Scrim** | toggle + warna + transparency — biar teks tetep kebaca |
| **6 Preset** | Wallpaper gue / Subtle / Bold / Wash / Accent tint / Off |
| **Live Info** | snapshot `Window:GetWallpaperInfo()` |
| **Canvas transparency** | area konten + sidebar. `100%` = wallpaper keliatan sebagai background kartu |
| **Group transparency** | kartu group. `0%` = **SOLID** — button/dropdown/slider/text nggak ikutan tembus |
| **Group contrast** | % kartu group dibedain dari background window (10% = kebaca sebagai kartu) |
| **Resep Aktif** 🆕 | tombol **Print resep Lua** — nge-print `SetWallpaper` + `SetSurface` siap paste balik |
| **WARNA — custom lengkap** 🆕 | 4 color picker di SATU tempat: tint wallpaper · overlay · canvas · kartu group (+ reset per warna) |
| **Master** 🆕 | RESET SEMUA · Wallpaper OFF · Wallpaper ON · cek versi lewat footer |

Plus **fix bug asli library**: `Window:SetBackgroundImage` nggak handle angka,
jadi paste ID polos diem-diem gagal tanpa error.

Tab baru: **Wallpaper** (3 groupbox kiri / 3 kanan, simetris).

> ⚠️ **Default sekarang = NORMAL/semula** (canvas solid, warna kartu asli).
> Kalau mau wallpaper keliatan sebagai background kartu: naikin
> **Canvas transparency = 100%** di groupbox "Canvas & Kartu Group",
> atau pencet tombol "Coba: wallpaper keliatan".
> Kalau yang nembus malah **langit/game** (bukan wallpaper lu), berarti asset
> ID-nya gagal load — cek baris status di groupbox "Live Info".
> (groupbox "Canvas & Kartu Group"). Tanpa itu Container yang solid nutupin
> wallpaper. Jangan pakai mode `front` buat wallpaper-as-background — mode itu
> ngegambar wallpaper DI ATAS komponen, jadi komponen keliatan tembus.

---

## Yang baru di v3

| Perubahan | Detail |
|---|---|
| **Icon balik ke lucide** | Preview pakai nama lucide (`house`, `paw-print`, `sparkles`...) — sama persis kayak hub lu. **Bukan** rbxassetid tambangan lagi. |
| **v2 gue salah** | Gue pakai asset ID dari `Games/Source/*.lua` yang ternyata **private punya game** → `The experience doesn't have access permission`. Maaf. |
| **Fix-nya di LIBRARY** | Gue tambahin `OfflineLucideIcons` (117 icon) + spritesheet **publik** + mirror GitHub. Jadi lucide jalan tanpa HTTP. |
| **Alias nama lama** | 13 nama lucide yang udah di-rename upstream (`sliders`→`sliders-horizontal`, `bar-chart-2`→`chart-column`, `home`→`house`, dll) di-resolve otomatis. |
| **CornerRadius 10** | Default library 4 → 10 (lu approve lewat slider Theme Lab). |

---

## Rantai resolusi icon (di `Library:GetIcon`)

```
1. gitlab.com/upio/lucide-roblox-direct        (repo asli, 1866 icon)
        ↓ gagal
2. raw.githubusercontent.com/notpoiu/...       (mirror GitHub)
        ↓ gagal
3. OfflineLucideIcons                          (117 icon, PASTI jalan)
```

Spritesheet-nya asset **publik**:
- `rbxassetid://136111683851629` (sheet 1)
- `rbxassetid://135883070486325` (sheet 2)
- pitch 25px, rect 24×24

---

## ⚠️ Jebakan ScrollFeed

```lua
-- Library line 5134
Image = itemData.Icon or "",     -- cuma Image, tanpa ImageRectOffset/Size
```

`AddScrollFeed():AddItem({ Icon = ... })` **harus gambar polos** (`CONFIG.ImageAsset`).
Kalau dikasih nama lucide → yang ke-render **seluruh spritesheet**.

Semua konsumen lain aman (apply rect bener): `AddTab`, `AddGroupbox`, `Notify.Icon`,
`Notify.BigIcon`, `Dropdown.ValueImages`, `AddDraggableLabel`, `AddDraggableImageButton`.

---

## Jalanin

Tekan **Play**:

1. Loading screen intro (5 step, ±3 detik)
2. Main window muncul di tengah, corner radius 10, **animasi ON**
3. Laporan komponen ke-print di **Output**

Toggle UI: `RightCtrl`

---

## Isi (7 tab, semua simetris)

| Tab | Kiri | Kanan |
|---|---|---|
| **Overview** | Selamat Datang (SpotlightCard, Divider, Label) · Status Session | Asset 3D (Viewport auto-spin) · Activity Feed (ScrollFeed clickable) |
| **Components** | Buttons (biasa/tooltip/double-click/risky/disabled/sub) · Toggles & Addons (KeyPicker, ColorPicker, Checkbox) · Sliders (suffix/prefix/decimal) | Inputs (text/numeric/no-empty/webhook) · Dropdowns Basic (single/multi+DragSelect/searchable 20 item) · Dropdowns Special (disabled-values/ValueImages/Player/Team) |
| **Advanced** | Dependency System (Box + Groupbox) · Tabbox 3 sub-tab · Collapse Control | Nested Tabbox · UI Passthrough · Dialog (4 variant + WaitTime + form) |
| **Media** | Viewport Interaktif (drag) · Image Element (height/scaletype/tint live) · Video | Spotlight Card (swap 2D↔3D) · Live Feed (12 row + clear) · Asset Dipakai |
| **Overlays** | Notifications (6 varian + progress steps) · Draggable Label/Button/ImageButton · Draggable Menu | Overlay Panel (SetRow realtime) · Dashboard + Loading states · Context Menu (right-click) |
| **Theme Lab** | Scheme Colors (5 picker live) · Theme Presets (4) · Geometry & Scale | Font (9 font) · Animations (5 toggle + timing) · Window Controls |
| **Wallpaper** 🆕 | Wallpaper (ID/transparency/tint) · Overlay-Scrim (toggle/color/transparency) · Rendering (scaletype/layer/ZIndex) · Canvas & Kartu Group (canvas/group transparency + contrast) | Presets (6) · Live Info (GetWallpaperInfo) · Catatan · Resep Aktif (print resep Lua) |

**Simetri:** tiap tab groupbox kiri = kanan (2/2, 3/3, 3/3, 3/3, 3/3, 3/3, 5/5).

> 🔎 **Cek versi copy-an lu:** footer window harus tertulis **v4.4.2**.
> Kalau masih v4/v4.2/v4.3 berarti LocalScript lu copy-an lama — copy ulang.

> ⚠️ Hub lu (`Games/N3-SAE.lua`) **belum** simetris: 12 `AddLeftGroupbox` vs
> 9 `AddRightGroupbox`. Simetri itu urusan layout di hub, bukan library.

---

## Config

| Key | Default | Fungsi |
|---|---|---|
| `ModuleName` | `"N3V4"` | Nama ModuleScript library |
| `Title` / `Footer` / `Icon` | — | Identitas window |
| `ImageAsset` | N3 logo | Gambar polos buat Image / Spotlight / **ScrollFeed** |
| `VideoAsset` | `""` | Asset VideoFrame. Kosong = section nunjukin notice |
| `Wallpaper` | tabel | `Image`, `Transparency`, `ScaleType`, `Color`, `Layer`, `Overlay`, `OverlayColor`, `OverlayTransparency` |
| `ApplyWallpaperOnStart` | `true` | `false` = mulai tanpa wallpaper (buat bandingin) |
| `ShowLoadingIntro` | `true` | Loading screen pembuka |
| `LoadingSteps` / `LoadingStepDelay` | `5` / `0.45` | Jumlah step & jeda |
| `ToggleKey` | `RightControl` | Keybind toggle UI |
| `VerboseErrors` | `true` | Warning per-section gagal di Output |

Mau ganti icon? Langsung tulis nama lucide-nya di tempatnya
(misal `AddLeftGroupbox("Judul", "rocket")`). Daftar 117 nama yang dijamin
resolve offline ada di `Library/N3V3-NoObfus.lua` → `OfflineLucideIcons`.

---

## Arti log pembuka

```
[N3V4 Preview] Library OK | Device: nil | Mobile: false | DPI: 1 | Radius: 10 | Animations: ON
```

| Field | Arti | Normal? |
|---|---|---|
| `Device: nil` | `Library.DevicePlatform` cuma di-set kalau **bukan** Studio (`UserInputService:GetPlatform()` ada di cabang `else`). Di Studio nilainya memang `nil`. | ✅ **NORMAL** |
| `Mobile: false` | Studio + mouse → bukan mobile | ✅ Normal |
| `DPI: 1` | Default scale 1.0 | ✅ Normal |
| `Radius: 10` | **Corner radius baru ke-apply** (dari 4) | ✅ Bukti fix library jalan |
| `Animations: ON` | **Animasi ke-apply** | ✅ Bukti fix library jalan |

Kalau `Radius: 4` atau `Animations: nil` → berarti ModuleScript `N3V4` lu
**belum di-copy ulang** dari `Library/N3V3-NoObfus.lua`.

---

## Catatan Studio

- `writefile` / `getcustomasset` / `isfile` nggak ada di Studio → SaveManager nggak nyimpen. **Normal.**
- `protectgui` / `cloneref` / `gethui` punya fallback, aman.
- UI di-parent ke `PlayerGui` (bukan CoreGui) di Studio.

## Laporan komponen

Tiap section dibungkus `pcall`. Yang gagal cuma di-skip + dicatat, script tetep jalan.
Lihat ulang: **Theme Lab → Window Controls → "Print laporan ke Output"**.

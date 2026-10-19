# N3V4 — Preview Kit (v2)

Preview lengkap semua fitur UI library N3, buat dites langsung di **Roblox Studio**.

> Keputusan desain & temuan teknis ada di **`../DESIGN_NOTES.md`** — baca itu dulu.

---

## Setup (3 langkah)

### 1. ModuleScript library

```
ReplicatedStorage
└── N3V4          <- ModuleScript
```

Isi = **seluruh kode** `Library/N3V3-NoObfus.lua`.
Baris terakhir harus tetap `return Library`.

> Nama bisa diganti — sesuaikan `CONFIG.ModuleName`. Kalau nggak ada di
> ReplicatedStorage, script scan seluruh DataModel.

### 2. LocalScript preview

```
StarterPlayer
└── StarterPlayerScripts
    └── N3V4_Preview   <- LocalScript
```

Isi = **seluruh kode** `N3V4_Preview.client.lua`.

Nama bebas. Yang wajib: tipenya **LocalScript** dan lokasinya di **StarterPlayerScripts**.

### 3. HTTP Requests — sekarang **OPSIONAL**

`File > Game Settings > Security > Allow HTTP Requests`

| Keadaan | Efek |
|---|---|
| **OFF** | ✅ Icon tetep muncul (pakai `rbxassetid` manual). Asset library pakai fallback ID. |
| **ON** | Sama aja, kecuali lu set `CONFIG.UseLucideIcons = true` |

---

## Yang baru di v2

| Perubahan | Kenapa |
|---|---|
| **Icon pakai `rbxassetid` manual** (31 ID) | Lucide butuh HTTP ke gitlab. Kalau gagal → icon kosong semua, dan `AddDraggableLabel` malah **error keras** (assert). ID-nya ditambang dari repo lu sendiri, artinya terkonfirmasi dari source. |
| **FIX** `AddDraggableLabel` icon assert | Ganti `"zap"` (lucide) → `ICONS.Star` (rbxassetid) |
| **FIX** `AddContextMenu` | Ternyata nge-return **table** `{Open, Close, Toggle, SetSize, Destroy, Menu}` — **nggak ada `AddButton`**. Item sekarang dibangun manual ke `Ctx.Menu`, dan right-click di-bind manual (library nggak auto-bind) |
| **Layout simetris** | Tiap tab: groupbox kiri = kanan (2/2, 3/3, 3/3, 3/3, 3/3, 3/3) |
| **Animasi ON dari library** | Default `Templates.Window.Animations` di-flip `false` → `true`. Hub lu dapet animasi **tanpa diedit** |

---

## Jalanin

Tekan **Play**:

1. Loading screen intro (5 step, ±3 detik)
2. Main window muncul di tengah
3. Laporan komponen ke-print di **Output**

Toggle UI: `RightCtrl`

---

## Isi (6 tab, 33 section, semua simetris)

| Tab | Kiri | Kanan |
|---|---|---|
| **Overview** | Selamat Datang (SpotlightCard, Divider, Label) · Status Session | Asset 3D (Viewport auto-spin) · Activity Feed (ScrollFeed clickable) |
| **Components** | Buttons (biasa/tooltip/double-click/risky/disabled/sub) · Toggles & Addons (KeyPicker, ColorPicker, Checkbox) · Sliders (suffix/prefix/decimal) | Inputs (text/numeric/no-empty/webhook) · Dropdowns Basic (single/multi+DragSelect/searchable 20 item) · Dropdowns Special (disabled-values/ValueImages/Player auto/Team auto) |
| **Advanced** | Dependency System (DependencyBox + DependencyGroupbox) · Tabbox 3 sub-tab · Collapse Control | Nested Tabbox dalam Groupbox · UI Passthrough · Dialog (4 variant + WaitTime + form) |
| **Media** | Viewport Interaktif (drag) · Image Element (height/scaletype/tint live) · Video | Spotlight Card (swap 2D↔3D) · Live Feed (12 row + clear) · Asset Dipakai (daftar ID) |
| **Overlays** | Notifications (6 varian + progress steps) · Draggable Label/Button/ImageButton · Draggable Menu (manual build) | Overlay Panel (SetRow/RemoveRow/ClearRows realtime) · Dashboard + Loading states (incl. error page) · Context Menu (right-click) |
| **Theme Lab** | Scheme Colors (5 picker live) · Theme Presets (4) · Geometry & Scale (radius/DPI/sidebar/compact) | Font & Background (9 font + bg image) · Animations (5 toggle + timing/swipe/direction) · Window Controls (notify side/title/footer/report/unload) |

---

## Config cepat

Blok `CONFIG` di paling atas:

| Key | Default | Fungsi |
|---|---|---|
| `ModuleName` | `"N3V4"` | Nama ModuleScript library |
| `Title` / `Footer` / `Icon` | — | Identitas window |
| `ImageAsset` | N3 logo | Asset buat Image / Spotlight / Feed |
| `VideoAsset` | `""` | Asset VideoFrame. Kosong = section nunjukin notice |
| `UseLucideIcons` | `false` | `true` = pakai nama lucide (butuh HTTP ON) |
| `ShowLoadingIntro` | `true` | Loading screen pembuka |
| `LoadingSteps` / `LoadingStepDelay` | `5` / `0.45` | Jumlah step & jeda |
| `ToggleKey` | `RightControl` | Keybind toggle UI |
| `VerboseErrors` | `true` | Warning per-section gagal di Output |

Ganti icon? Edit tabel **`ICONS`** (ID) atau **`UI_ICON`** (slot → ID). 41 slot.

---

## Catatan Studio

- `writefile` / `getcustomasset` / `isfile` nggak ada di Studio → SaveManager nggak nyimpen. **Normal.**
- `protectgui` / `cloneref` / `gethui` punya fallback di library, aman.
- UI di-parent ke `PlayerGui` (bukan CoreGui) kalau di Studio.

## Laporan komponen

Tiap section dibungkus `pcall`. Yang gagal cuma di-skip + dicatat, script tetep jalan.

Lihat ulang kapan aja: **Theme Lab → Window Controls → "Print laporan ke Output"**.

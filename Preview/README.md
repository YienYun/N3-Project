# N3V4 — Preview Kit

Preview lengkap semua fitur UI library N3, buat dites langsung di **Roblox Studio**.

## Setup (3 langkah)

### 1. ModuleScript library

```
ReplicatedStorage
└── N3V4          <- ModuleScript
```

Isi ModuleScript-nya = **seluruh kode** dari `Library/N3V3-NoObfus.lua`.
Baris terakhir harus tetap `return Library` (udah ada di file aslinya).

> Nama modul bisa diganti — tinggal sesuaikan `CONFIG.ModuleName` di script preview.
> Kalau nggak ketemu di ReplicatedStorage, script bakal scan seluruh DataModel.

### 2. LocalScript preview

```
StarterPlayer
└── StarterPlayerScripts
    └── N3V4_Preview   <- LocalScript
```

Isi = **seluruh kode** dari `Preview/N3V4_Preview.client.lua`.

**Nama LocalScript-nya bebas.** Rekomendasi: `N3V4_Preview`.
Yang penting tipenya **LocalScript** (bukan Script / ModuleScript) dan
ditaruh di **StarterPlayerScripts**.

### 3. Nyalakan HTTP

`File > Game Settings > Security > Allow HTTP Requests = ON`

Dibutuhkan buat:
- Icon **lucide** (`gitlab.com/upio/lucide-roblox-direct`)
- Asset bawaan library (LoadingIcon, CheckIcon, TransparencyTexture, SaturationMap)

Kalau OFF, UI tetap jalan — cuma icon-icon-nya kosong.

---

## Jalanin

Tekan **Play**. Urutannya:

1. Loading screen intro (5 step, ±3 detik)
2. Main window muncul di tengah layar
3. Laporan komponen ke-print di **Output**

Toggle UI: `RightCtrl`

---

## Isi Preview (6 tab, 33 section)

| Tab | Isi |
|---|---|
| **Overview** | SpotlightCard, Label, Divider, Viewport 3D auto-spin, ScrollFeed |
| **Components** | Button (biasa/tooltip/double-click/risky/disabled/sub-button), Toggle + KeyPicker + ColorPicker, Checkbox, Slider, Input, Dropdown (single/multi/searchable/disabled/values-images/player/team) |
| **Advanced** | DependencyBox, DependencyGroupbox, Tabbox kiri, Nested Tabbox dalam Groupbox, Groupbox collapse, UIPassthrough, KeyBox, Dialog (3 variant + destructive + form) |
| **Media** | Viewport interaktif (drag), Image + kontrol realtime, SpotlightCard 2D↔3D, Video, ScrollFeed besar |
| **Overlays** | Notification (6 varian termasuk progress steps), Draggable Label/Button/ImageButton/Menu, Overlay panel (SetRow), Dashboard window, Loading error page, Context menu |
| **Theme Lab** | 5 color picker scheme, 3 preset tema, corner radius, DPI scale, sidebar width, compact sidebar, font face, background image, 5 animation toggle + timing/swipe control, notify side, title/footer, unload |

---

## Catatan Studio

- `writefile` / `getcustomasset` / `isfile` **nggak ada** di Studio
  → SaveManager nggak bisa nyimpen config. **Normal, bukan bug.**
- `protectgui` / `cloneref` / `gethui` punya fallback di library, jadi aman.
- UI di-parent ke `PlayerGui` (bukan CoreGui) kalau jalan di Studio.

## Laporan komponen

Setiap section dibungkus `pcall`. Kalau ada yang gagal, script **tetep jalan** —
yang gagal cuma di-skip dan dicatat.

Lihat laporan kapan aja: tab **Theme Lab** → groupbox *Window Controls* →
**"Print laporan ke Output"**.

```
===================================================
  N3V4 PREVIEW KIT — LAPORAN KOMPONEN
===================================================
  ✅ BERHASIL : 33
      • Overview: Groupbox kiri (Spotlight + Label + Divider)
      ...
  ❌ GAGAL    : 0
      (nggak ada — semua komponen jalan 🎉)
===================================================
```

## Config cepat

Semua yang mungkin mau lu ubah ada di blok `CONFIG` paling atas:

| Key | Fungsi |
|---|---|
| `ModuleName` | Nama ModuleScript library (default `N3V4`) |
| `Title` / `Footer` / `Icon` | Identitas window |
| `ImageAsset` | Asset buat demo Image / Spotlight / Feed icon |
| `VideoAsset` | Asset VideoFrame. **Kosong = section Video di-skip** |
| `ShowLoadingIntro` | Nyalain/matiin loading screen pembuka |
| `LoadingSteps` / `LoadingStepDelay` | Jumlah step & jeda loading |
| `ToggleKey` | Keybind toggle UI |
| `VerboseErrors` | Warning per-komponen gagal di Output |

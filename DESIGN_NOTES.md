# N3V4 — Design Notes

Catatan keputusan desain + temuan teknis. **Baca ini dulu sebelum lanjut kerja.**

---

## 🎯 Preferensi user (yang udah diucapin eksplisit)

| Preferensi | Detail | Status |
|---|---|---|
| **SIMETRIS** | "gue suka ui yang simteris banget ok? simteris." — layout harus seimbang kiri/kanan | 🔒 **HARD RULE** |
| **Motion level** | Balanced — spring + micro-interaction di semua komponen; efek mahal (blur/glow/ripple) opsional & auto-off di mobile | 🔒 Kekunci |
| **Arah visual** | Belum diputusin. User: "abaikan dulu" | ⏳ Pending |
| **Jangan merge** | Semua kerjaan di branch `arena/c5a10c06-n3-project`. User yang push ke repo utama | 🔒 Kekunci |
| **API tetap** | `N3-SAE.lua` (18.659 baris) & `ride-an-pets.lua` (6.128 baris) harus jalan tanpa diedit | 🔒 Kekunci |
| **Workflow** | Hasil di-copy → paste ke Roblox Studio buat preview cepat | 🔒 Kekunci |

**Aturan simetri yang dipakai di preview:** tiap tab punya jumlah groupbox kiri = kanan.
Cek otomatis ada di validator (`📐 SIMETRI LAYOUT`).

---

## 🎬 TEMUAN PENTING: animasi udah ada di library, cuma default-nya OFF

Ini jawaban dari "buset ini animasi udah ada di library? apa masih di preview?"

**Animasinya 100% udah ada di library.** Masalahnya default-nya mati semua:

```lua
-- Library/N3V3-NoObfus.lua, Templates.Window (SEBELUM)
Animations = {
    ToggleWindow = false,
    TabSwitch    = false,
    Groupbox     = false,
    Dropdown     = false,
    KeyPicker    = false,
},
```

Hub lu manggil:
```lua
LibraryLoader:CreateWindow({ Title = "N3 HUB", Footer = "...", Icon = "...", AutoShow = true })
```
→ nggak ngoper `Animations`, jadi dapet default = **semua false**. Makanya hub lu kaku.

**Udah gue fix** — default di-flip ke `true` di `Library/N3V3-NoObfus.lua`.

Propagation-nya keverifikasi:
```
Templates.Window.Animations
  → Library:Validate(WindowInfo, Templates.Window)   -- CreateWindow
  → Library.Animations = WindowInfo.Animations       -- line 9181
  → dipakai Table.Animated(), PlayTabAnimation, dll
```

**Efek: hub lu langsung dapet animasi tanpa disentuh sama sekali.** ✅

Yang masih bisa di-tune (belum gue ubah, nunggu keputusan lu):
- `TabTransitionTime = 0.22` — easing masih `Quad`. Kandidat: ganti ke spring-ish
- `TabSwipeOffset = 26`, `TabSwipeFrom = "bottom"`
- `CornerRadius = 4` — ini yang bikin kesan boxy/tua
- `Font = Enum.Font.Code` — monospace di semua tempat

---

## 🖼️ Strategi icon

**Masalah:** library ambil icon lucide lewat
`game:HttpGet("https://gitlab.com/upio/lucide-roblox-direct/-/raw/main/source.lua")`.
Kalau HTTP off / gitlab nggak kejangkau → `Library:GetIcon()` return `nil` → **icon kosong semua**.

Parahnya: `AddDraggableLabel` punya `assert(Icon, ...)` di line 2023 → **bikin error beneran**,
bukan cuma icon ilang.

**Solusi sekarang (sementara, atas request user):**
Preview pakai `rbxassetid://` manual. **Nggak butuh HTTP sama sekali.**

ID-nya **ditambang dari repo lu sendiri**, artinya dikonfirmasi dari nama key / konteks source:

| Sumber | Isi |
|---|---|
| `Games/Source/StealAnEgg/ChiliSourceV4.lua:43885` | Named stat icon map (Money/Speed/Eggs/Pets/Night/Index/Shop/Fights/Lab/Race/Wins/Star) |
| `Games/Source/StealAnEgg/ChiliSourceV4.lua:12534` | Feature icon map (Star/StealFilter/StealIndex/Place/Treadmill/Butterfly/Essence/StealWisp/Train/Halloween) — dikonfirmasi dari field `Sub` |
| `Games/Source/StealAnEgg/SenaV2.lua` | Creature icon (Dragon/Unicorn/Phoenix/ArchAngel/Kitsune/Pegasus/Gargoyle/Godzilla/TRex) + Treadmill variants |
| `Library/N3V3-NoObfus.lua` | `LoadingIcon` 97544096941083, `CheckIcon` 97682394690683 |
| `Games/N3-SAE.lua` | N3 logo 117688744510818 (dipakai `ToggleBtnTexture`) |

Total **31 icon ID terverifikasi**, dipetakan ke **41 slot UI** lewat tabel `UI_ICON`.

⚠️ **Jujur:** ini icon game-specific (pet/item/stat), **bukan** icon UI generik.
Dipakai sebagai placeholder biar preview ada icon-nya. Pas upgrade visual nanti
ini harus diganti icon set yang proper (bikinn spritesheet sendiri, atau bikin
fallback icon map di dalam library).

**Switch:** `CONFIG.UseLucideIcons = true` → balik ke nama lucide (butuh HTTP ON).

### Format icon yang diterima library (tanpa HTTP)
Dari `IsValidCustomIcon` / `IsCustomAssetIcon`:
- `rbxassetid://<id>` ✅
- `rbxasset://textures/...` ✅
- `content://...` ✅
- `rbxthumb://type=...` ✅
- `roblox.com/asset/?id=...` ✅
- angka polos (`12345`) ✅ — otomatis di-format jadi `rbxassetid://`

---

## ⚠️ Jebakan API (hasil verifikasi, jangan diulang)

Semua ini **beda dari asumsi awal** dan udah dikonfirmasi dari source:

| API | Return | Jebakan |
|---|---|---|
| `Library:Notify(...)` | `Data` table | Method-nya `ChangeTitle` / `ChangeDescription` / `ChangeStep` / `Resize` / `Destroy`. **BUKAN** `SetStep`/`Dismiss` |
| `Library:CreateOverlay(Info)` | `Self` table | Panel **key-value**: `SetRow(Key, Value, Color)` / `RemoveRow` / `ClearRows` / `SetVisible` / `Destroy`. **BUKAN** container bebas, nggak ada `AddLabel`/`AddButton` |
| `Library:CreateDashboardWindow(Info)` | `Self` table | Row API yang sama kayak Overlay |
| `Library:AddDraggableMenu(Name)` | `Holder, Container` | **Raw Instance**, dua return value. Nggak ada method sama sekali — isi dibangun manual |
| `Library:AddContextMenu(Holder, Size, Offset, List, ...)` | `Table` | `{ Open, Close, Toggle, SetSize, Destroy, Menu, Holder, Active }`. **NGGAK ada `AddButton`** — item dibangun manual ke `Ctx.Menu`. Library juga **nggak auto-bind right-click**, harus bind sendiri. `List = 1` → library bikinin UIListLayout + AutomaticSize.Y |
| `Funcs:AddViewport(Idx, Info)` | `ViewportObj` | `Info.Object` **NGGAK** di-auto-apply. Harus panggil `Viewport:SetModel(model)` manual. Punya `Info.Spin` (auto-rotate, default ON) & `Info.Interactive` (drag) |
| `Funcs:AddSpotlightCard(Idx, Info)` | `CardObj` | `SetData(title, desc, imageAsset, modelSource)` — param ke-4 kalau diisi otomatis switch kiri card ke ViewportFrame 3D |
| `Funcs:AddScrollFeed(Idx, Info)` | `FeedObj` | `AddItem({ Icon, Title, Detail, RightTag, OnClick })` + `Clear()` |
| `Window:AddDialog(Idx, Info)` | `Dialog` | `AddFooterButton(ButtonIdx, { Title, Variant, Order, WaitTime, Callback })` — key-nya **`Title`** bukan `Text`. Variant: `Primary`/`Secondary`/`Destructive`/`Ghost`. Dialog inherit `BaseGroupbox` → bisa diisi komponen |
| `Library:AddDraggableLabel(...)` | `DraggableLabel` | `SetText/SetIcon/SetIconPosition/SetVisible/Destroy`. **Ada `assert` di icon** → nama lucide yang gagal fetch = error keras |
| `Tab:AddKeyBox(Callback)` | — | `Callback(Text)`. Elemen level Tab, muncul di area atas tab |
| `Library:SetDPIScale(n)` | — | Param = **persen** (di-dibagi 100 di dalam). `100` = skala 1.0 |
| `Window:SetCornerRadius(r)` | — | Di-clamp max **20** |
| `Library:SetFont(face)` | — | Terima `EnumItem` atau `Font`. Aman |

### Struktur metatable
```
BaseGroupbox.__index = Funcs     -- Groupbox, Tab, Depbox, DepGroupbox, Dialog semua inherit
BaseAddons.__index   = Funcs     -- Toggle/Button dapet AddKeyPicker & AddColorPicker
Tab.Groupboxes[Name] = Groupbox  -- reference otomatis, bisa dipakai buat collapse/hide dari jauh
```
Artinya: `Tab` juga punya semua method Groupbox.

---

## 📐 Peta file

```
N3-Project/
├── Library/
│   └── N3V3-NoObfus.lua      13.860 baris — engine UI (fork Obsidian)
├── Games/
│   ├── N3-SAE.lua            18.659 baris — hub Steal An Egg (8 tab)
│   ├── ride-an-pets.lua       6.128 baris — hub kedua
│   └── Source/StealAnEgg/   200.515 baris — 4 source lama, bahan tambang
├── Preview/
│   ├── N3V4_Preview.client.lua  ← LocalScript preview (v2)
│   └── README.md
└── DESIGN_NOTES.md           ← file ini
```

---

## 🗺️ Roadmap (belum dimulai, nunggu go)

- [x] **Phase 0** — Preview Kit + flip animation default
- [ ] **Phase 1** — Design tokens: tarik semua angka visual (warna, radius, spacing, easing, durasi) ke satu tabel `Design`
- [ ] **Phase 2** — Chrome: window frame, sidebar, tab + sliding indicator, groupbox, footer, searchbar
- [ ] **Phase 3** — Komponen: button, toggle, slider, dropdown, keybind, colorpicker, input
- [ ] **Phase 4** — Motion system: spring util, hover/press state, stagger reveal
- [ ] **Phase 5** — Loading screen, Dashboard, Notification, Draggable
- [ ] **Phase 6** — Icon set proper (ganti placeholder tambangan)
- [ ] **Phase 7** — Theme presets bawaan library

**Yang belum diputusin user:** arah visual (glass / brutalist / cyber / minimal), accent & font final.

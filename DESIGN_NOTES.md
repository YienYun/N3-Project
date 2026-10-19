# N3V4 — Design Notes

Catatan keputusan desain + temuan teknis. **Baca ini dulu sebelum lanjut kerja.**

---

## 🎯 Preferensi user (yang udah diucapin eksplisit)

| Preferensi | Detail | Status |
|---|---|---|
| **SIMETRIS** | "gue suka ui yang simteris banget ok? simteris." | 🔒 HARD RULE — lihat catatan penting di bawah |
| **Corner radius 10px** | "gue di preview di slider ke di 10px cornernya. ini bagus!" | ✅ **Udah di-apply ke library** |
| **Motion level** | Balanced — spring + micro-interaction; efek mahal (blur/glow/ripple) opsional & auto-off di mobile | 🔒 Kekunci |
| **Icon = lucide** | "pake icons yang ada di library gue jir. di situ ada link iconsnya kan?" | ✅ **Udah dibenerin** |
| **Arah visual** | Belum diputusin ("abaikan dulu") | ⏳ Pending |
| **Jangan merge** | Semua di branch `arena/c5a10c06-n3-project` | 🔒 Kekunci |
| **API tetap** | `N3-SAE.lua` & `ride-an-pets.lua` harus jalan tanpa diedit | 🔒 Kekunci |

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

👉 Ini kerjaan terpisah. Kalau mau, gue audit per-tab mana yang berat sebelah
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

Semua di `Library/N3V3-NoObfus.lua`. **4 perubahan**, semua permanen (bukan preview-only):

| # | Perubahan | Lokasi | Efek |
|---|---|---|---|
| 1 | Animasi default `false` → `true` | `Library.Animations` (~line 225) + `Templates.Window.Animations` (~line 406) | Hub dapet animasi otomatis, termasuk Loading screen |
| 2 | `CornerRadius` `4` → `10` | `Library.CornerRadius` (line 264) + `Templates.Window.CornerRadius` (line 376) | UI nggak boxy lagi. Clamp max tetap 20 |
| 3 | Offline lucide fallback (117 icon) + GitHub mirror | blok baru sebelum `Library:GetIcon` (~line 1180) + rewrite `GetIcon` | Icon **selalu** muncul, tanpa HTTP |
| 4 | Alias 13 nama lucide lama | `OfflineLucideAliases` | `sliders`/`bar-chart-2`/`home`/`chat` dll tetep resolve |

**Yang BELUM di library:** simetri (itu urusan hub), design tokens, warna/font baru,
motion system tambahan. Nunggu keputusan arah visual.

---

## ⚠️ Jebakan API (hasil verifikasi source, jangan diulang)

| API | Return | Jebakan |
|---|---|---|
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

### Format icon yang diterima `GetCustomIcon` (tanpa HTTP)
`rbxassetid://<id>` · `rbxasset://textures/...` · `content://...` · `rbxthumb://type=...`
· `roblox.com/asset/?id=...` · angka polos · **nama lucide** (via chain 3 lapis)

---

## 📐 Peta file

```
N3-Project/
├── Library/N3V3-NoObfus.lua     14.058 baris — engine UI (fork Obsidian) ← DIUBAH
├── Games/
│   ├── N3-SAE.lua               18.659 baris — hub Steal An Egg (8 tab)
│   ├── ride-an-pets.lua          6.128 baris — hub kedua (2 icon broken)
│   └── Source/StealAnEgg/      200.515 baris — 4 source lama
├── Preview/
│   ├── N3V4_Preview.client.lua   1.308 baris — LocalScript preview v3 ← DIUBAH
│   └── README.md
└── DESIGN_NOTES.md               ← file ini
```

---

## 🗺️ Roadmap

- [x] **Phase 0** — Preview Kit
- [x] **Phase 0.5** — Animasi ON, CornerRadius 10, offline icon fallback (semua di library)
- [ ] **Phase 0.6** — Rebalance simetri `N3-SAE.lua` (12 kiri vs 9 kanan) ← *butuh go dari lu*
- [ ] **Phase 1** — Design tokens: tarik semua angka visual ke satu tabel `Design`
- [ ] **Phase 2** — Chrome: window, sidebar, tab + sliding indicator, groupbox, footer
- [ ] **Phase 3** — Komponen: button, toggle, slider, dropdown, keybind, colorpicker, input
- [ ] **Phase 4** — Motion system: spring util, hover/press state, stagger reveal
- [ ] **Phase 5** — Loading, Dashboard, Notification, Draggable
- [ ] **Phase 6** — Icon set lengkap (kalau butuh > 117 icon offline)
- [ ] **Phase 7** — Theme presets bawaan library

**Belum diputusin:** arah visual (glass / brutalist / cyber / minimal), accent & font final.

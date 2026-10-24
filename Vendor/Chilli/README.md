# Vendor/Chilli — part mentah library Chilli (referensi + copy user)

File di folder ini SALINAN mentah dari repo publik `tienkhanh1/spicy`
(branch main), ditarik via API GitHub + tarball codeload buat keperluan
forensik visual v4.33.1–v4.34.2 (bedah resep tile/button/panel Chilli).
Bukan bagian dari library N3, tidak di-require apa pun, tidak masuk
gates check.sh.

## Isi
- `ChilliLibraryEngine.lua` — VM Luraph v15 obfuscated (engine generasi 1)
- `ChilliLibraryEngine2.lua` — VM Luraph v15 obfuscated (engine generasi 2)
- `ChilliLibraryCore2.lua` — closure factory ter-deobfuscate:
  `return function(C0, Opts)`; berisi resep visual (tile plate+stroke,
  canvas primitives Frame/Text/Button/Image/Bar, search bar, responsive
  rows) yang jadi rujukan port visual panel N3

File terkait lain di repo sumber (tidak ikut disalin): `ChilliLibraryCore`
dan `Chilli Library` (core generasi lama, duplikat), `Chilli.lua` (router
URL per-game ke payload remote luarmor/Chilli-Hub), `JoinScript.lua`
(VM Luraph v14), payload game (`Steal-a-Brainrot`, `Grow-a-Garden`).

## Verdict forensik: kenapa Chilli standalone TIDAK bisa dirakit dari file ini
Patch perakit (function `return function(arg, arg2)` dengan
`assert(arg[1] == 1129531443)` + string checksum 45 char) membutuhkan
array 47 entry (table Library, closure factory, class table) plus string
checksum khusus. Masalahnya: magic number `1129531443` dan string
checksum itu TIDAK ADA di file mana pun — grep ke SELURUH isi tarball
repo sumber hasilnya kosong. Keduanya hidup hanya sebagai konstanta di
dalam bytecode VM Luraph obfuscated, jadi urutan perakitan
(engine -> core -> patch -> Library table) tidak bisa direkonstruksi
sebagai ModuleScript plain. Konsekuensi:
- ModuleScript `ChiliSource` di Studio yang return **function** = patch
  mentah; tanpa VM yang memanggilnya dengan argumen benar, ia tidak
  pernah jadi Library.
- Chilli yang "hidup" (screenshot Steal Panel) hanya ada sebagai payload
  remote per-game yang dieksekusi executor, bukan module reusable.
- Rute banding live yang masuk akal: jalanin payload Chilli in-game via
  executor berdampingan dengan preview Studio N3 (mode Banding di
  preview tetap mencoba require ChiliSource kalau suatu saat ada module
  yang return table Library siap pakai).

## Keamanan
Source leak obfuscated = permukaan backdoor. Jangan pernah require/
eksekusi file-folder ini di akun utama Roblox; pakai akun alt atau
cukup baca sebagai referensi visual seperti yang dilakukan forensik N3.

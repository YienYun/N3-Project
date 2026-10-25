--[[
	N3-Steal-An-Egg.luau — KERANGKA (status: kosong, logika nyusul pasca-diskusi)

	Hub Steal An Egg tulis ulang dari nol. Referensi logika:
	Games/Source/StealAnEgg/ChiliSourceV5.luau (hasil deobfus, BACA ONLY).

	Aturan proyek (mandat user):
	1. Clean-room: logika chili dipelajari alurnya, ditulis ulang rapih.
	   DILARANG copas mentah block deobfus, DILARANG pakai identifier
	   hasil deobfus (cn3, f32, zr, Ar, dst). Semua nama themed
	   Steal-An-Egg dan bisa di-maintain.
	2. Nol hardcode: angka/warna/data diambil dari game saat runtime
	   (katalog live), konstanta wajib lewat tabel Config bernama.
	3. Satu file "kitab utuh": section ber-index, nol global bocor,
	   nol state liar, nol bentrok sama script lain.
	4. Tiap feature = satu controller table sendiri, masuk lewat
	   registry feature biar enable/disable gak saling injak.

	RENCANA SECTION (isi setelah keputusan diskusi):
	  [0] Config        — semua konstanta bernama (warna, interval, threshold)
	  [1] SafeBoot      — crash-catcher + handshake print
	  [2] DataService   — baca katalog egg/rarity/warna dari game (live + fallback)
	  [3] FormatService — FormatRate / FormatWeight / FormatCash gaya chili
	  [4] UiBridge      — jembatan ke UI (keputusan diskusi: LIB / UI sendiri)
	  [5+] Controllers  — Farm, Predictor, Inventory, Server, Misc, dst per fase
]]

print("[N3-Steal-An-Egg] v0.1.0 kerangka loaded — logika masuk per fase atas perintah user")

return function()
	-- Entry point hub: diisi fase pertama begitu user nunjuk feature/tab mana dulu.
end

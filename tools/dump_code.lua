--!nocheck
--[[
	[N3DUMP5] — baca SOURCE code module, BUKAN scan instance runtime.
	Target: font asset game + style cash topbar (TopbarPlus) + tabel rarity,
	langsung dari code ReplicatedStorage/StarterGui/StarterPack/StarterPlayer.
	READ-ONLY: cuma baca .Source, nol instance baru, nol tulis, nol execute code game.
	Paste hasil Output apa adanya ke chat, jangan diringkas.
]]

local out = {}
local function L(line)
	table.insert(out, line)
	print("[N3DUMP5] " .. line)
end

local function pathOf(inst)
	local parts = {}
	local cur = inst
	local guard = 0
	while cur and guard < 14 do
		table.insert(parts, 1, cur.Name)
		cur = cur.Parent
		guard += 1
	end
	return table.concat(parts, "/")
end

local roots = {}
for _, name in ipairs({ "ReplicatedStorage", "StarterGui", "StarterPack", "StarterPlayer" }) do
	local ok, svc = pcall(function()
		return game:GetService(name)
	end)
	if ok and svc then
		table.insert(roots, svc)
	end
end

local scripts = {}
for _, root in ipairs(roots) do
	local ok, desc = pcall(function()
		return root:GetDescendants()
	end)
	if ok then
		for _, d in ipairs(desc) do
			if d:IsA("LuaSourceContainer") then
				table.insert(scripts, d)
			end
		end
	end
end
L(string.format("SCAN CODE: %d script/module (ReplicatedStorage+StarterGui+StarterPack+StarterPlayer)", #scripts))

local FONT_PAT = {
	"Font%.new%s*%(", "rbxassetid://%d+", "rbxasset://fonts", "FontFace",
	"%.Font%s*=", "FontWeight", "Gotham", "BuilderSans", "IndieFlower", "SourceSans",
}
local CASH_PAT = { "Topbar", "topbar", "TopBar", "Cash", "cash", "Money", "Balance", "Coins" }
local RAR_WORDS = { "Secret", "Legendary", "Mythic", "Cosmic", "Eternal", "Divine", "Rainbow", "Mutation" }
local RAR_COL = { "Color3", "fromRGB", "ColorSequence", "Keypoint", "Gradient", "Stroke", "Color" }

local function matchAny(line, pats)
	for _, p in ipairs(pats) do
		if line:find(p) then
			return p
		end
	end
	return nil
end

local fontLines, cashBlocks, rarLines = {}, {}, {}
for _, sc in ipairs(scripts) do
	local ok, src = pcall(function()
		return sc.Source
	end)
	if ok and type(src) == "string" then
		local p = pathOf(sc)
		local lines = {}
		for line in src:gmatch("[^\n]*") do
			table.insert(lines, line)
		end
		for i, line in ipairs(lines) do
			local trim = line:match("^%s*(.-)%s*$")
			if #trim > 0 and #trim < 220 then
				if matchAny(trim, FONT_PAT) and #fontLines < 70 then
					table.insert(fontLines, string.format("[FONT] %s:%d: %s", p, i, trim))
				end
				if matchAny(trim, CASH_PAT) and #cashBlocks < 45 then
					local blk = { string.format("[CASH] %s:%d: %s", p, i, trim) }
					for j = i + 1, math.min(i + 3, #lines) do
						local t2 = lines[j]:match("^%s*(.-)%s*$")
						if #t2 > 0 and #t2 < 220 then
							table.insert(blk, string.format("       +%d: %s", j - i, t2))
						end
					end
					table.insert(cashBlocks, table.concat(blk, "\n"))
				end
				if matchAny(trim, RAR_WORDS) and matchAny(trim, RAR_COL) and #rarLines < 45 then
					table.insert(rarLines, string.format("[RARITY] %s:%d: %s", p, i, trim))
				end
			end
		end
	end
end

L("== FONT CODE (baris code soal font) ==")
if #fontLines == 0 then
	L("FONT CODE: kosong")
else
	for _, l in ipairs(fontLines) do
		L(l)
	end
end
L(string.format("FONT CODE: %d baris", #fontLines))

L("== CASH/TOPBAR CODE (baris + 3 baris konteks) ==")
if #cashBlocks == 0 then
	L("CASH CODE: kosong")
else
	for _, b in ipairs(cashBlocks) do
		L(b)
	end
end
L(string.format("CASH CODE: %d blok", #cashBlocks))

L("== RARITY CODE (baris warna/gradient per rarity) ==")
if #rarLines == 0 then
	L("RARITY CODE: kosong")
else
	for _, l in ipairs(rarLines) do
		L(l)
	end
end
L(string.format("RARITY CODE: %d baris", #rarLines))

local clip = string.format("==[N3DUMP5]==\n%s\n==[/N3DUMP5]==", table.concat(out, "\n"))
local okC = pcall(function()
	(setclipboard or toclipboard or copy)(clip)
end)
print("[N3DUMP5] SELESAI — clipboard: " .. tostring(okC) .. " — paste semuanya ke chat")
print("[N3DUMP5] kalau SCAN CODE: 0 atau semua Source gagal: executor lu blok baca source.")
print("[N3DUMP5] fallback manual via Dex: buka ReplicatedStorage.Client + ReplicatedStorage.Shared + ReplicatedStorage.TopbarPlusReference, paste source-nya.")

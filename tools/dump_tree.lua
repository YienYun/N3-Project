--!nocheck
--[[
	[N3DUMP6] — print NAMA doang, nol baca isi/source.
	Workflow: list nama ke-print -> user buka file yang ditunjuk via Dex -> paste isinya.
	READ-ONLY: cuma Name/ClassName/Parent, nol instance baru, nol tulis, nol .Source.
	Packages dibates 2 level biar paste gak ribuan baris.
	Paste hasil Output apa adanya ke chat, jangan diringkas.
]]

local out = {}
local function L(line)
	table.insert(out, line)
	print("[N3DUMP6] " .. line)
end

local CODE_TAG = { ModuleScript = "M", LocalScript = "L", Script = "S" }
local CODE_CAP = 450
local FOLDER_CAP = 350

local roots = {}
for _, name in ipairs({ "ReplicatedStorage", "StarterGui", "StarterPack", "StarterPlayer" }) do
	local ok, svc = pcall(function()
		return game:GetService(name)
	end)
	if ok and svc then
		table.insert(roots, svc)
	end
end

local function pathOf(inst)
	local parts = {}
	local cur = inst
	local guard = 0
	while cur and guard < 20 do
		table.insert(parts, 1, cur.Name)
		cur = cur.Parent
		guard += 1
	end
	return table.concat(parts, "/")
end

local function depthBelowPackages(inst)
	local lvl = 0
	local cur = inst.Parent
	while cur and cur.Name ~= "Packages" do
		lvl += 1
		cur = cur.Parent
	end
	if cur == nil then
		return nil
	end
	return lvl
end

local rs = game:GetService("ReplicatedStorage")
L("== ROOT ReplicatedStorage (anak langsung + tipe) ==")
local okRC, rc = pcall(function()
	return rs:GetChildren()
end)
if okRC then
	for _, c in ipairs(rc) do
		L(string.format("%s %s", c.ClassName, c.Name))
	end
end

for _, root in ipairs(roots) do
	L("== FOLDERS di " .. root.Name .. " ==")
	local folderCount = 0
	local ok, desc = pcall(function()
		return root:GetDescendants()
	end)
	if ok then
		for _, d in ipairs(desc) do
			if (d:IsA("Folder") or d:IsA("Configuration")) and folderCount < FOLDER_CAP then
				local pk = depthBelowPackages(d)
				if pk == nil or pk <= 1 then
					folderCount += 1
					L(string.format("[%s] %s", d.ClassName, pathOf(d)))
				end
			end
		end
	end
	L(string.format("FOLDERS %s: %d", root.Name, folderCount))
end

L("== CODE (M=Module L=Local S=Script; Packages max 2 level) ==")
local codeCount = 0
local capped = false
for _, root in ipairs(roots) do
	local ok2, desc = pcall(function()
		return root:GetDescendants()
	end)
	if ok2 then
		for _, d in ipairs(desc) do
			local tag = CODE_TAG[d.ClassName]
			if tag then
				if codeCount >= CODE_CAP then
					capped = true
				else
					local pk = depthBelowPackages(d)
					if pk == nil or pk <= 1 then
						codeCount += 1
						L(string.format("[%s] %s", tag, pathOf(d)))
					end
				end
			end
		end
	end
end
L(string.format("CODE: %d baris ke-print", codeCount))
if capped then
	L("CODE: CAP 450 kepake — sisa file gak ke-print, bilang kalau butuh lanjutan")
end

local clip = string.format("==[N3DUMP6]==\n%s\n==[/N3DUMP6]==", table.concat(out, "\n"))
local okC = pcall(function()
	(setclipboard or toclipboard or copy)(clip)
end)
print("[N3DUMP6] SELESAI — clipboard: " .. tostring(okC) .. " — paste semuanya ke chat, gue tunjuk file mana yang lu buka")

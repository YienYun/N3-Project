--!nocheck
--[[
	[N3DUMP7] — lanjutan [N3DUMP6] yang kepake CAP sebelum nyampe folder penting.
	Scope SEMPIIT: ReplicatedStorage/Client, /Controllers, /Shared, /Packages doang.
	Print NAMA file code doang (M/L/S), nol baca isi, nol baca source.
	Packages dibates 2 level (library dalem _Index gak relevan).
	Paste hasil Output apa adanya ke chat — abis ini gue tunjuk file persis buat dibuka di Dex.
]]

local out = {}
local function L(line)
	table.insert(out, line)
	print("[N3DUMP7] " .. line)
end

local CODE_TAG = { ModuleScript = "M", LocalScript = "L", Script = "S" }
local CAP = 700

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

local rs = game:GetService("ReplicatedStorage")
local SUBS = { "Client", "Controllers", "Shared", "Packages" }
local total = 0
local capped = false

for _, sub in ipairs(SUBS) do
	local folder = rs:FindFirstChild(sub)
	L("== CODE di ReplicatedStorage/" .. sub .. " ==")
	if folder then
		local ok, desc = pcall(function()
			return folder:GetDescendants()
		end)
		if ok then
			local localCount = 0
			for _, d in ipairs(desc) do
				local tag = CODE_TAG[d.ClassName]
				if tag then
					if total >= CAP then
						capped = true
					else
						local skip = false
						if sub == "Packages" then
							local lvl = 0
							local cur = d.Parent
							while cur and cur ~= folder do
								lvl += 1
								cur = cur.Parent
							end
							if lvl > 1 then
								skip = true
							end
						end
						if not skip then
							total += 1
							localCount += 1
							L(string.format("[%s] %s", tag, pathOf(d)))
						end
					end
				end
			end
			L(string.format("CODE %s: %d file", sub, localCount))
		else
			L("GetDescendants gagal di " .. sub)
		end
	else
		L("FOLDER GAK KETEMU: " .. sub)
	end
end

L(string.format("TOTAL: %d file code", total))
if capped then
	L("CAP 700 kepake — bilang kalau butuh lanjutan")
end

local clip = string.format("==[N3DUMP7]==\n%s\n==[/N3DUMP7]==", table.concat(out, "\n"))
local okC = pcall(function()
	(setclipboard or toclipboard or copy)(clip)
end)
print("[N3DUMP7] SELESAI — clipboard: " .. tostring(okC) .. " — paste semuanya, gue tunjuk file mana yang lu buka di Dex")

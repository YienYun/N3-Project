--!nocheck
--[[
	[N3DUMP4] — font asli game + text cash hijau topbar
	READ-ONLY: cuma baca property, nol instance baru, nol tulis.
	Bug [N3DUMP3] FONT kosong: baca Family lewat prop Font lama (Enum) — yang bener d.FontFace.
	Scan: PlayerGui + workspace + CoreGui (topbar game sering bukan di PlayerGui).
	Paste hasil Output apa adanya ke chat, jangan diringkas.
]]

local out = {}
local function L(line)
	table.insert(out, line)
	print("[N3DUMP4] " .. line)
end

local function rgb(c)
	return string.format("%d,%d,%d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function pathOf(inst)
	local parts = {}
	local cur = inst
	local guard = 0
	while cur and guard < 12 do
		table.insert(parts, 1, cur.Name)
		cur = cur.Parent
		guard += 1
	end
	return table.concat(parts, "/")
end

local function collectGuiDescendants()
	local found = {}
	local roots = {}
	local services = { "PlayerGui", "CoreGui", "Workspace" }
	for _, name in services do
		local ok, svc = pcall(function()
			return game:GetService(name)
		end)
		if ok and svc then
			table.insert(roots, svc)
		end
	end
	for _, root in roots do
		local ok, desc = pcall(function()
			return root:GetDescendants()
		end)
		if ok then
			for _, d in desc do
				if d:IsA("GuiObject") or d:IsA("LayerCollector") then
					table.insert(found, d)
				end
			end
		end
	end
	return found
end

local isText = function(d)
	return d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")
end

local function strokeOf(d)
	local ok, st = pcall(function()
		return d:FindFirstChildOfClass("UIStroke")
	end)
	if ok and st then
		return string.format("Stroke(%s th%.2f)", rgb(st.Color), st.Thickness)
	end
	return "Stroke(none)"
end

local function gradOf(d)
	local ok, g = pcall(function()
		return d:FindFirstChildOfClass("UIGradient")
	end)
	if ok and g then
		local pts = {}
		for _, kp in ipairs(g.Color.Keypoints) do
			table.insert(pts, string.format("%.2f:%s", kp.Time, rgb(kp.Value)))
		end
		return string.format("Grad[Rot%.0f %s]", g.Rotation, table.concat(pts, " "))
	end
	return "Grad(none)"
end

local all = collectGuiDescendants()
L(string.format("SCAN: %d gui objects (PlayerGui+CoreGui+Workspace)", #all))

-- ============ SECTION 1: FONT (FontFace API yang bener) ============
L("== FONT (kombinasi FontFace unik) ==")
local seenFont = {}
local fontCount = 0
for _, d in ipairs(all) do
	if isText(d) then
		local famStr, wStr, sStr, legacy = "?", "?", "?", "?"
		local okF = pcall(function()
			local ff = d.FontFace
			famStr = tostring(ff.Family)
			local okN, n = pcall(function()
				return ff.Family.Name
			end)
			if okN then
				famStr = famStr .. "|" .. tostring(n)
			end
			wStr = tostring(ff.Weight)
			sStr = tostring(ff.Style)
		end)
		pcall(function()
			legacy = tostring(d.Font)
		end)
		if okF or legacy ~= "?" then
			local key = famStr .. "|" .. wStr .. "|" .. sStr .. "|" .. legacy
			if not seenFont[key] then
				seenFont[key] = true
				fontCount += 1
				local sz, txt = "?", ""
				pcall(function()
					sz = tostring(d.TextSize)
					txt = string.sub(tostring(d.Text), 1, 24)
				end)
				L(string.format("F%d Family=%s Weight=%s Style=%s LegacyFont=%s size=%s ex=\"%s\" path=%s",
					fontCount, famStr, wStr, sStr, legacy, sz, txt, pathOf(d)))
			end
		end
	end
end
L(string.format("FONT: %d kombinasi unik", fontCount))

-- ============ SECTION 2: CASH3 (text cash hijau topbar) ============
L("== CASH3 (text angka size>=14 di PlayerGui/CoreGui/Workspace) ==")
local cashCount = 0
for _, d in ipairs(all) do
	if cashCount >= 10 then
		break
	end
	if isText(d) then
		local txt, sz = "", 0
		local okT = pcall(function()
			txt = tostring(d.Text)
			sz = d.TextSize
		end)
		if okT and sz >= 14 and txt:match("^%$?%d") then
			cashCount += 1
			local col = "?"
			pcall(function()
				col = rgb(d.TextColor3)
			end)
			L(string.format("CASH%d \"%s\" size=%d col=%s bold=%s %s %s path=%s",
				cashCount, string.sub(txt, 1, 20), sz, col, tostring((function()
					local okB, w = pcall(function()
						return d.FontFace.Weight
					end)
					if okB then
						return tostring(w)
					end
					return tostring(d.Font)
				end)()), strokeOf(d), gradOf(d), pathOf(d)))
		end
	end
end
L(string.format("CASH3: %d kandidat (max 10)", cashCount))

-- ============ copy ============
local clip = string.format("==[N3DUMP4]==\n%s\n==[/N3DUMP4]==", table.concat(out, "\n"))
local okC = pcall(function()
	(setclipboard or toclipboard or copy)(clip)
end)
print("[N3DUMP4] SELESAI — clipboard: " .. tostring(okC) .. " — paste semuanya ke chat")

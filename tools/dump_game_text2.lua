local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

local LINE_CAP = 260
local lines = 0

local function out(text)
	if lines >= LINE_CAP then
		return
	end
	lines = lines + 1
	print("[N3DUMP3] " .. text)
end

local function fmtColor(c)
	if typeof(c) ~= "Color3" then
		return tostring(c)
	end
	return string.format("RGB(%d,%d,%d)", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function fmtSeq(seq)
	local parts = {}
	for _, kp in ipairs(seq.Keypoints or {}) do
		table.insert(parts, string.format("%.2f:%s", kp.Time, fmtColor(kp.Value)))
	end
	return table.concat(parts, ",")
end

local function trunc(s, n)
	s = tostring(s):gsub("[\r\n]+", " ")
	if #s > n then
		s = s:sub(1, n) .. ".."
	end
	return s
end

local function fontInfo(label)
	local f = ""
	pcall(function()
		local fo = label.Font
		f = " | FontFamily=" .. tostring(fo.Family) .. " | FontW=" .. tostring(fo.Weight.Name) .. " | FontS=" .. tostring(fo.Style.Name)
	end)
	return f
end

local function fullStyle(d)
	local line = ""
	pcall(function()
		line = line .. "TxtC=" .. fmtColor(d.TextColor3) .. " | TxtS=" .. tostring(d.TextSize)
	end)
	line = line .. fontInfo(d)
	pcall(function()
		for _, ch in ipairs(d:GetChildren()) do
			if ch.ClassName == "UIStroke" then
				line = line .. " | Stroke=" .. fmtColor(ch.Color) .. " | StrokeT=" .. string.format("%.2f", ch.Thickness)
				for _, ch2 in ipairs(ch:GetChildren()) do
					if ch2.ClassName == "UIGradient" then
						line = line .. " | StrokeSeq=" .. fmtSeq(ch2.Color) .. " | StrokeRot=" .. string.format("%.1f", ch2.Rotation)
					end
				end
			elseif ch.ClassName == "UIGradient" then
				line = line .. " | FillSeq=" .. fmtSeq(ch.Color) .. " | FillRot=" .. string.format("%.1f", ch.Rotation)
			end
		end
	end)
	return line
end

local function isOurs(inst)
	local cur = inst
	while cur and cur ~= game do
		if cur.Name:match("N3") or cur.Name:match("Obsidian") then
			return true
		end
		cur = cur.Parent
	end
	return false
end

out("=== FONT ASSETS PlayerGui ===")
local seenFont = {}
pcall(function()
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if (d.ClassName == "TextLabel" or d.ClassName == "TextButton") and not isOurs(d) then
			pcall(function()
				local fam = d.Font.Family
				local key = fam .. "|" .. d.Font.Weight.Name .. "|" .. d.Font.Style.Name
				if not seenFont[key] then
					seenFont[key] = true
					out("FONT " .. key .. " | contoh=" .. d:GetFullName():gsub("Players%..-%.PlayerGui%.?", "") .. " | Text=\"" .. trunc(d.Text, 18) .. "\" | TxtS=" .. tostring(d.TextSize))
				end
			end)
		end
	end
end)

out("=== CASH TOPBAR / COUNTER STYLE ===")
pcall(function()
	local n = 0
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if n >= 15 then
			break
		end
		if (d.ClassName == "TextLabel" or d.ClassName == "TextButton") and not isOurs(d) then
			local hit = false
			pcall(function()
				if d.Text:match("^%$?[%d%,%.]+%s*[KMBTQa][a-z]?$") or d.Name:match("Cash|Money|Coin|Currency|Value") then
					hit = true
				end
			end)
			if hit and d.Text ~= "" then
				n = n + 1
				out("CASH2 " .. d:GetFullName():gsub("Players%..-%.PlayerGui%.?", "") .. " | Text=\"" .. trunc(d.Text, 20) .. "\"" .. fullStyle(d))
			end
		end
	end
end)

out("=== RARITY / MUTATION NAME LABELS ===")
local WANT = {
	SECRET = 1, COSMIC = 1, RAINBOW = 1, MYTHIC = 1, LEGENDARY = 1, EPIC = 1,
	RARE = 1, UNCOMMON = 1, COMMON = 1, GOLDEN = 1, MUTANT = 1, DIVINE = 1,
	ETERNAL = 1, ANCIENT = 1, HALLOWEEN = 1,
}
pcall(function()
	local n = 0
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if n >= 30 then
			break
		end
		if (d.ClassName == "TextLabel" or d.ClassName == "TextButton") and not isOurs(d) then
			local up = ""
			pcall(function()
				up = d.Text:upper():match("^%s*([A-Z ]+)%s*$") or ""
			end)
			if WANT[up] == 1 then
				n = n + 1
				out("RARNAME " .. d:GetFullName():gsub("Players%..-%.PlayerGui%.?", "") .. " | Text=\"" .. d.Text .. "\"" .. fullStyle(d))
			end
		end
	end
end)

out("=== GAME PET/EGG CARD UI TREE ===")
local targets = {}
pcall(function()
	for _, g in ipairs(PlayerGui:GetChildren()) do
		if g.ClassName == "ScreenGui" and not isOurs(g) and g.Name:match("Egg|Pet|Boost|Fuse|Card|Popup|Preview") then
			table.insert(targets, g)
		end
	end
end)
for _, g in ipairs(targets) do
	out("TREE " .. g.Name)
	local function walk(inst, depth)
		if depth > 4 then
			return
		end
		for _, ch in ipairs(inst:GetChildren()) do
			if ch.ClassName == "TextLabel" or ch.ClassName == "TextButton" then
				out(string.rep("..", depth) .. ch.ClassName .. " " .. ch.Name .. " | Text=\"" .. trunc(ch.Text, 22) .. "\"" .. fullStyle(ch))
				walk(ch, depth + 1)
			elseif ch.ClassName == "ImageLabel" or ch.ClassName == "Frame" then
				local extra = ""
				pcall(function()
					if ch.ClassName == "ImageLabel" and ch.Image ~= "" then
						extra = " | Image=" .. ch.Image .. " | ImgT=" .. string.format("%.2f", ch.ImageTransparency)
					end
				end)
				out(string.rep("..", depth) .. ch.ClassName .. " " .. ch.Name .. extra)
				walk(ch, depth + 1)
			end
		end
	end
	walk(g, 1)
end

out("=== END total=" .. lines .. " ===")

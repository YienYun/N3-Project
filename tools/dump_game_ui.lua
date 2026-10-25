local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

local LINE_CAP = 420
local lines = 0

local function out(text)
	if lines >= LINE_CAP then
		return
	end
	lines = lines + 1
	print("[N3DUMP] " .. text)
end

local function fmtColor(c)
	if typeof(c) ~= "Color3" then
		return tostring(c)
	end
	return string.format("RGB(%d,%d,%d)", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function fmtSeq(seq, isColor)
	local parts = {}
	for _, kp in ipairs(seq.Keypoints or {}) do
		if isColor then
			table.insert(parts, string.format("%.2f:%s", kp.Time, fmtColor(kp.Value)))
		else
			table.insert(parts, string.format("%.2f:%.2f", kp.Time, kp.Value))
		end
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

local function props(inst)
	local bag = {}
	local function put(k, v)
		table.insert(bag, k .. "=" .. v)
	end
	pcall(function()
		put("Bg", fmtColor(inst.BackgroundColor3))
		put("BgT", string.format("%.2f", inst.BackgroundTransparency))
	end)
	pcall(function()
		put("Size", tostring(inst.Size))
	end)
	local cls = inst.ClassName
	if cls == "ImageLabel" or cls == "ImageButton" then
		pcall(function()
			put("Image", inst.Image)
		end)
		pcall(function()
			put("ImgC", fmtColor(inst.ImageColor3))
		end)
		pcall(function()
			put("ImgT", string.format("%.2f", inst.ImageTransparency))
		end)
		pcall(function()
			put("Scale", inst.ScaleType.Name)
		end)
		pcall(function()
			put("Tile", tostring(inst.TileSize))
		end)
		pcall(function()
			put("Slice", tostring(inst.SliceCenter))
		end)
	elseif cls == "TextLabel" or cls == "TextButton" then
		pcall(function()
			put("Text", '"' .. trunc(inst.Text, 32) .. '"')
		end)
		pcall(function()
			put("TxtC", fmtColor(inst.TextColor3))
		end)
		pcall(function()
			put("TxtT", string.format("%.2f", inst.TextTransparency))
		end)
		pcall(function()
			put("Font", inst.Font.Name)
		end)
		pcall(function()
			put("TxtS", tostring(inst.TextSize))
		end)
	elseif cls == "UIStroke" then
		pcall(function()
			put("Color", fmtColor(inst.Color))
		end)
		pcall(function()
			put("Thick", string.format("%.2f", inst.Thickness))
		end)
		pcall(function()
			put("Trans", string.format("%.2f", inst.Transparency))
		end)
		pcall(function()
			put("On", tostring(inst.Enabled))
		end)
		pcall(function()
			put("Mode", inst.ApplyStrokeMode.Name)
		end)
	elseif cls == "UICorner" then
		pcall(function()
			put("Radius", tostring(inst.CornerRadius))
		end)
	elseif cls == "UIGradient" then
		pcall(function()
			put("Color", fmtSeq(inst.Color, true))
		end)
		pcall(function()
			put("Alpha", fmtSeq(inst.Transparency, false))
		end)
		pcall(function()
			put("Rot", string.format("%.1f", inst.Rotation))
		end)
		pcall(function()
			put("Off", tostring(inst.Offset))
		end)
		pcall(function()
			put("On", tostring(inst.Enabled))
		end)
	elseif cls == "UIListLayout" then
		pcall(function()
			put("Pad", tostring(inst.Padding))
		end)
		pcall(function()
			put("Sort", inst.SortOrder.Name)
		end)
		pcall(function()
			put("Fill", inst.FillDirection.Name)
		end)
	elseif cls == "UIAspectRatioConstraint" then
		pcall(function()
			put("Ratio", string.format("%.3f", inst.AspectRatio))
		end)
	elseif cls == "UISizeConstraint" then
		pcall(function()
			put("Min", tostring(inst.MinSize))
			put("Max", tostring(inst.MaxSize))
		end)
	elseif cls == "ScrollingFrame" then
		pcall(function()
			put("Bar", tostring(inst.ScrollBarThickness))
		end)
		pcall(function()
			put("Auto", tostring(inst.AutomaticCanvasSize.Name))
		end)
	end
	return table.concat(bag, " | ")
end

local SKIP = {
	CoreGui = true,
}

local function walk(inst, depth)
	for _, ch in ipairs(inst:GetChildren()) do
		if not SKIP[ch.ClassName] then
			out(string.rep("..", depth) .. ch.ClassName .. " " .. ch.Name .. " | " .. props(ch))
			if depth < 7 then
				walk(ch, depth + 1)
			end
		end
	end
end

out("=== HEADER game=" .. game.GameId .. " player=" .. LocalPlayer.Name .. " ===")

local pets = PlayerGui and PlayerGui:FindFirstChild("ActivePets")
if pets then
	out("=== TREE ActivePets ===")
	walk(pets, 0)
else
	out("=== ActivePets NOT FOUND (buka panel pets dulu di game) ===")
end

out("=== IMAGE SCAN PlayerGui ===")
local imgCount = 0
pcall(function()
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if imgCount >= 80 then
			break
		end
		if (d.ClassName == "ImageLabel" or d.ClassName == "ImageButton") and d.Image ~= "" then
			imgCount = imgCount + 1
			local abs = ""
			pcall(function()
				abs = tostring(d.AbsoluteSize)
			end)
			out("IMG " .. d:GetFullName():gsub("Players%..-%.PlayerGui%.?", "") .. " | " .. props(d) .. " | Abs=" .. abs)
		end
	end
end)

out("=== RARITY PROBE modules ===")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modPaths = {
	{ "Shared", "Util", "EggRecords" },
	{ "Shared", "Util", "AssetItems" },
	{ "Shared", "Util", "AssetEarnings" },
	{ "Client", "EggState" },
}
for _, path in ipairs(modPaths) do
	pcall(function()
		local node = ReplicatedStorage
		for _, seg in ipairs(path) do
			node = node:FindFirstChild(seg, true) or node:WaitForChild(seg, 2)
		end
		local mod = require(node)
		if type(mod) == "table" then
			local seen = 0
			local function scan(t, prefix, depth)
				if depth > 2 or seen > 40 then
					return
				end
				for k, v in pairs(t) do
					if seen > 40 then
						return
					end
					local key = tostring(k)
					if typeof(v) == "Color3" then
						seen = seen + 1
						out("RAR " .. table.concat(path, ".") .. " " .. prefix .. key .. " = " .. fmtColor(v))
					elseif type(v) == "table" and depth < 2 then
						scan(v, prefix .. key .. ".", depth + 1)
					end
				end
			end
			scan(mod, "", 0)
		end
	end)
end

out("=== TEXTLABEL SCAN ActivePets (rarity lewat text) ===")
pcall(function()
	if not pets then
		return
	end
	local n = 0
	for _, d in ipairs(pets:GetDescendants()) do
		if n >= 40 then
			break
		end
		if d.ClassName == "TextLabel" or d.ClassName == "TextButton" then
			n = n + 1
			out("TXT " .. d.Name .. " | " .. props(d))
		end
	end
end)

out("=== END total=" .. lines .. " ===")

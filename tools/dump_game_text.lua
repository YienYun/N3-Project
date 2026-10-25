local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

local LINE_CAP = 400
local lines = 0

local function out(text)
	if lines >= LINE_CAP then
		return
	end
	lines = lines + 1
	print("[N3DUMP2] " .. text)
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

local RARITY_HINT = "[Rr]arity|[Tt]ier|[Qq]uality"

local function scanTable(t, prefix, depth, srcName, seen)
	if depth > 3 or seen.n > 60 then
		return
	end
	for k, v in pairs(t) do
		if seen.n > 60 then
			return
		end
		local key = tostring(k)
		local vt = typeof(v)
		if vt == "ColorSequence" then
			seen.n = seen.n + 1
			out("SEQ " .. srcName .. " " .. prefix .. key .. " = " .. fmtSeq(v, true))
		elseif vt == "Color3" then
			seen.n = seen.n + 1
			out("COL " .. srcName .. " " .. prefix .. key .. " = " .. fmtColor(v))
		elseif type(v) == "table" and depth < 3 then
			local isRar = key:match(RARITY_HINT) ~= nil
			if isRar then
				seen.n = seen.n + 1
				out("RARTBL " .. srcName .. " " .. prefix .. key .. " keys=" .. trunc(table.concat((function()
					local ks = {}
					for k2 in pairs(v) do
						table.insert(ks, tostring(k2))
					end
					return ks
				end)(), "/"), 90))
			end
			scanTable(v, prefix .. key .. ".", depth + 1, srcName, seen)
		end
	end
end

out("=== MODULE SCAN ReplicatedStorage ===")
local modCount = 0
local function tryModule(mod)
	if modCount >= 26 then
		return
	end
	modCount = modCount + 1
	pcall(function()
		local data = require(mod)
		if type(data) == "table" then
			scanTable(data, "", 0, mod.Name, { n = 0 })
		end
	end)
end
for _, rootName in ipairs({ "Shared", "Data", "Client" }) do
	pcall(function()
		local root = ReplicatedStorage:FindFirstChild(rootName)
		if not root then
			return
		end
		local n = 0
		for _, d in ipairs(root:GetDescendants()) do
			if n >= 10 then
				break
			end
			if d.ClassName == "ModuleScript" then
				n = n + 1
				tryModule(d)
			end
		end
	end)
end

out("=== TEXT STYLE SCAN PlayerGui (gradient + anim sample) ===")
local samples = {}
pcall(function()
	local n = 0
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if n >= 50 then
			break
		end
		if d.ClassName == "TextLabel" or d.ClassName == "TextButton" then
			local grad = nil
			local gradOnStroke = false
			pcall(function()
				for _, ch in ipairs(d:GetChildren()) do
					if ch.ClassName == "UIGradient" then
						grad = ch
					elseif ch.ClassName == "UIStroke" then
						for _, ch2 in ipairs(ch:GetChildren()) do
							if ch2.ClassName == "UIGradient" then
								grad = ch2
								gradOnStroke = true
							end
						end
					end
				end
			end)
			if grad then
				n = n + 1
				local path = d:GetFullName():gsub("Players%..-%.PlayerGui%.?", "")
				local line = "TXT " .. path .. " | Text=\"" .. trunc(d.Text, 24) .. "\""
				pcall(function()
					line = line .. " | TxtC=" .. fmtColor(d.TextColor3) .. " | Font=" .. d.Font.Name .. " | TxtS=" .. tostring(d.TextSize)
				end)
				pcall(function()
					line = line .. " | OnStroke=" .. tostring(gradOnStroke)
				end)
				pcall(function()
					line = line .. " | Rot=" .. string.format("%.1f", grad.Rotation) .. " | Off=" .. tostring(grad.Offset)
				end)
				pcall(function()
					line = line .. " | Seq=" .. fmtSeq(grad.Color, true)
				end)
				out(line)
				table.insert(samples, grad)
			end
		end
	end
end)

out("=== ANIM SAMPLE (offset/rot delta 0.4s) ===")
if #samples > 0 then
	local before = {}
	for i, g in ipairs(samples) do
		pcall(function()
			before[i] = { Off = g.Offset, Rot = g.Rotation }
		end)
	end
	task.wait(0.4)
	for i, g in ipairs(samples) do
		pcall(function()
			local b = before[i]
			local dOff = g.Offset - b.Off
			local dRot = g.Rotation - b.Rot
			if dOff.Magnitude > 0.0001 or math.abs(dRot) > 0.01 then
				out("ANIM #" .. i .. " dOff=" .. tostring(dOff) .. " dRot=" .. string.format("%.2f", dRot))
			end
		end)
	end
	out("ANIM sampled=" .. #samples)
else
	out("ANIM no gradient text found")
end

out("=== CASH TEXT SCAN (Text match $) ===")
pcall(function()
	local n = 0
	for _, d in ipairs(PlayerGui:GetDescendants()) do
		if n >= 20 then
			break
		end
		if (d.ClassName == "TextLabel" or d.ClassName == "TextButton") and d.Text:match("%$") then
			n = n + 1
			local line = "CASH " .. d.Name .. " | Text=\"" .. trunc(d.Text, 24) .. "\""
			pcall(function()
				line = line .. " | TxtC=" .. fmtColor(d.TextColor3) .. " | Font=" .. d.Font.Name .. " | TxtS=" .. tostring(d.TextSize)
			end)
			pcall(function()
				for _, ch in ipairs(d:GetChildren()) do
					if ch.ClassName == "UIStroke" then
						line = line .. " | Stroke=" .. fmtColor(ch.Color)
						for _, ch2 in ipairs(ch:GetChildren()) do
							if ch2.ClassName == "UIGradient" then
								line = line .. " | StrokeSeq=" .. fmtSeq(ch2.Color, true) .. " | StrokeRot=" .. string.format("%.1f", ch2.Rotation)
							end
						end
					elseif ch.ClassName == "UIGradient" then
						line = line .. " | FillSeq=" .. fmtSeq(ch.Color, true) .. " | FillRot=" .. string.format("%.1f", ch.Rotation)
					end
				end
			end)
			out(line)
		end
	end
end)

out("=== END total=" .. lines .. " ===")

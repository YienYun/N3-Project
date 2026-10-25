--!nocheck
--[[
	[N3DUMP8] — dump TERTARGET style cash topbar + font UI game.
	Buktinya dari code (ronde 2 Dex): MoneyUpdateController cuma nulis .Text ke
	Hud.Get("Money") + Hud.Every("MoneyValue") (label punya anak "Shadow");
	warna hijau/font/stroke = property instance ScreenGui "HUD" (StarterGui),
	bukan di code. Registry Client/GUI nunjuk nama screen: HUD, TopbarStandard,
	SakuraCrystalCounter (counter pembanding style).
	READ-ONLY: baca property doang, nol instance baru, nol tulis.
	Paste hasil Output apa adanya ke chat.
]]

local out = {}
local function L(line)
	table.insert(out, line)
	print("[N3DUMP8] " .. line)
end

local function rgb(c)
	return string.format("%d,%d,%d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function gradOf(inst)
	local ok, g = pcall(function()
		return inst:FindFirstChildOfClass("UIGradient")
	end)
	if ok and g then
		local pts = {}
		for _, kp in ipairs(g.Color.Keypoints) do
			table.insert(pts, string.format("%.2f:%s", kp.Time, rgb(kp.Value)))
		end
		return string.format("Grad[Rot%.0f %s]", g.Rotation, table.concat(pts, " "))
	end
	return nil
end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
if not pg then
	L("PlayerGui gak ketemu")
	return
end

local TARGETS = { "HUD", "TopbarStandard", "SakuraCrystalCounter" }
local CAP_PER = 40

for _, name in ipairs(TARGETS) do
	local gui = pg:FindFirstChild(name)
	L("== TARGET " .. name .. " ==")
	if not gui then
		L("TARGET GAK ADA di PlayerGui: " .. name)
	else
		local count = 0
		local ok, desc = pcall(function()
			return gui:GetDescendants()
		end)
		if ok then
			for _, d in ipairs(desc) do
				if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) and count < CAP_PER then
					count += 1
					local rel = {}
					local cur = d
					while cur and cur ~= gui do
						table.insert(rel, 1, cur.Name)
						cur = cur.Parent
					end
					local txt, sz, col, tr = "", "?", "?", "?"
					pcall(function()
						txt = string.sub(tostring(d.Text), 1, 24)
						sz = tostring(d.TextSize)
						col = rgb(d.TextColor3)
						tr = string.format("%.2f", d.TextTransparency)
					end)
					local fam, wgt, legacy = "?", "?", "?"
					pcall(function()
						fam = tostring(d.FontFace.Family)
						wgt = tostring(d.FontFace.Weight)
					end)
					pcall(function()
						legacy = tostring(d.Font)
					end)
					local stroke = "Stroke(none)"
					pcall(function()
						local st = d:FindFirstChildOfClass("UIStroke")
						if st then
							local sg = gradOf(st) or ""
							stroke = string.format("Stroke[%s th%.2f tr%.2f%s]", rgb(st.Color), st.Thickness, st.Transparency, sg ~= "" and " " .. sg or "")
						end
					end)
					local g = gradOf(d) or "Grad(none)"
					L(string.format("%s | \"%s\" size=%s col=%s tr=%s font=%s/%s legacy=%s %s %s",
						table.concat(rel, "/"), txt, sz, col, tr, fam, wgt, legacy, stroke, g))
				end
			end
		end
		L(string.format("TARGET %s: %d text label", name, count))
	end
end

local clip = string.format("==[N3DUMP8]==\n%s\n==[/N3DUMP8]==", table.concat(out, "\n"))
local okC = pcall(function()
	(setclipboard or toclipboard or copy)(clip)
end)
print("[N3DUMP8] SELESAI — clipboard: " .. tostring(okC) .. " — paste semuanya, abis ini v4.44.0 bake font + cash hijau asli")

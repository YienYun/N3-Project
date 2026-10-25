local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)

local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local GuiService: GuiService = cloneref(game:GetService("GuiService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))
local function C3(r, g, b)
	return Color3.new(r, g, b)
end

local Presets = {
	Order = { "Custom", "Gold", "Silver", "Chrome", "Rainbow", "Neon", "Sunset", "Oceanic", "Lava", "Fire", "Ice", "Electric", "Galaxy", "Matrix", "Zebra", "Death", "Ghost", "Bubblegum", "Green" },
	Sequence = {
		Gold = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(0.8353, 0.6824, 0.2196)),
			ColorSequenceKeypoint.new(0.2205, C3(0.8353, 0.6824, 0.2196)),
			ColorSequenceKeypoint.new(0.3681, C3(0.7804, 0.5961, 0.0471)),
			ColorSequenceKeypoint.new(0.4983, C3(0.851, 0.698, 0.0118)),
			ColorSequenceKeypoint.new(0.5035, C3(1, 0.9255, 0.5059)),
			ColorSequenceKeypoint.new(0.6927, C3(0.8353, 0.6824, 0.2196)),
			ColorSequenceKeypoint.new(0.7917, C3(0.8353, 0.6824, 0.2196)),
			ColorSequenceKeypoint.new(1, C3(0.8353, 0.6824, 0.2196)),
		}),
		Silver = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(0.8353, 0.8353, 0.8353)),
			ColorSequenceKeypoint.new(0.2847, C3(0.7333, 0.7843, 0.8353)),
			ColorSequenceKeypoint.new(0.4983, C3(0.3333, 0.3333, 0.4392)),
			ColorSequenceKeypoint.new(0.5035, C3(1, 1, 1)),
			ColorSequenceKeypoint.new(0.7153, C3(0.7333, 0.7843, 0.8353)),
			ColorSequenceKeypoint.new(1, C3(0.8353, 0.8353, 0.8353)),
		}),
		Chrome = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(0, 0.0627, 0.3529)),
			ColorSequenceKeypoint.new(0.0677, C3(0.6863, 0.7882, 0.8353)),
			ColorSequenceKeypoint.new(0.1719, C3(0.8784, 0.9412, 1)),
			ColorSequenceKeypoint.new(0.3177, C3(1, 0.7059, 1)),
			ColorSequenceKeypoint.new(0.467, C3(0.2667, 0, 0.498)),
			ColorSequenceKeypoint.new(0.4983, C3(0.0196, 0.0039, 0.0353)),
			ColorSequenceKeypoint.new(0.5035, C3(1, 1, 1)),
			ColorSequenceKeypoint.new(0.7188, C3(0.7059, 1, 0.9529)),
			ColorSequenceKeypoint.new(0.941, C3(0.152, 0.6227, 0.6861)),
			ColorSequenceKeypoint.new(1, C3(0, 0.0627, 0.3529)),
		}),
		Rainbow = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.151, C3(0.6157, 0, 1)),
			ColorSequenceKeypoint.new(0.3073, C3(0.0667, 0, 1)),
			ColorSequenceKeypoint.new(0.4965, C3(0, 1, 1)),
			ColorSequenceKeypoint.new(0.6649, C3(0.0157, 1, 0)),
			ColorSequenceKeypoint.new(0.8385, C3(1, 1, 0)),
			ColorSequenceKeypoint.new(1, C3(1, 0, 0)),
		}),
		Neon = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(1, 0, 1)),
			ColorSequenceKeypoint.new(0.2, C3(0, 1, 1)),
			ColorSequenceKeypoint.new(0.4, C3(1, 0, 1)),
			ColorSequenceKeypoint.new(0.6, C3(1, 0, 0.5882)),
			ColorSequenceKeypoint.new(0.8, C3(0, 1, 1)),
			ColorSequenceKeypoint.new(1, C3(1, 0, 1)),
		}),
		Sunset = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(1, 0.3686, 0.302)),
			ColorSequenceKeypoint.new(0.25, C3(1, 0.6039, 0)),
			ColorSequenceKeypoint.new(0.5, C3(1, 0.7529, 0.7961)),
			ColorSequenceKeypoint.new(0.75, C3(1, 0.0784, 0.5765)),
			ColorSequenceKeypoint.new(1, C3(1, 0.3686, 0.302)),
		}),
		Oceanic = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(0, 0.451, 1)),
			ColorSequenceKeypoint.new(0.125, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.2552, C3(0, 0.451, 1)),
			ColorSequenceKeypoint.new(0.3767, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.5, C3(0, 0.451, 1)),
			ColorSequenceKeypoint.new(0.6198, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.7375, C3(0, 0.451, 1)),
			ColorSequenceKeypoint.new(0.8681, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(1, C3(0, 0.451, 1)),
		}),
		Lava = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.125, C3(1, 0.7843, 0)),
			ColorSequenceKeypoint.new(0.2552, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.3767, C3(1, 0.7843, 0)),
			ColorSequenceKeypoint.new(0.5, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.6198, C3(1, 0.7843, 0)),
			ColorSequenceKeypoint.new(0.7378, C3(1, 0, 0)),
			ColorSequenceKeypoint.new(0.8681, C3(1, 0.7843, 0)),
			ColorSequenceKeypoint.new(1, C3(1, 0, 0)),
		}),
		Fire = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 0.917647, 0)),
			ColorSequenceKeypoint.new(0.1510416716337204, Color3.new(1, 0.917647, 0)),
			ColorSequenceKeypoint.new(0.3072916567325592, Color3.new(1, 0.6, 0)),
			ColorSequenceKeypoint.new(0.4965277910232544, Color3.new(0.545098, 0.368627, 0.035294)),
			ColorSequenceKeypoint.new(0.6649305820465088, Color3.new(1, 0.666666, 0)),
			ColorSequenceKeypoint.new(0.8385416865348816, Color3.new(0.678431, 0.490196, 0.113725)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 0.917647, 0)),
		}),
		Ice = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(109, 210, 212)),
			ColorSequenceKeypoint.new(0.171875, Color3.new(0.8784313797950745, 0.9411764740943909, 1)),
			ColorSequenceKeypoint.new(0.3177083432674408, Color3.fromRGB(140, 208, 209)),
			ColorSequenceKeypoint.new(0.4670138955116272, Color3.fromRGB(109, 210, 212)),
			ColorSequenceKeypoint.new(0.4982638955116272, Color3.fromRGB(109, 210, 212)),
			ColorSequenceKeypoint.new(0.5034722089767456, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.71875, Color3.new(0.7058823704719543, 1, 0.9529411792755127)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(109, 210, 212)),
		}),
		Electric = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
			ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.3, Color3.fromRGB(100, 200, 255)),
			ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 200, 255)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.9, Color3.fromRGB(50, 150, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255)),
		}),
		Galaxy = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 0, 130)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(138, 43, 226)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 112)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(72, 61, 139)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130)),
		}),
		Matrix = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.243137, 0.937254, 0.007843)),
			ColorSequenceKeypoint.new(0.015625, Color3.new(0.243137, 0.937254, 0.007843)),
			ColorSequenceKeypoint.new(0.1458333283662796, Color3.new(0.243137, 0.937254, 0.007843)),
			ColorSequenceKeypoint.new(0.2482638955116272, Color3.new(0.243137, 0.937254, 0.007843)),
			ColorSequenceKeypoint.new(0.3559027910232544, Color3.new(0.243137, 0.937254, 0.007843)),
			ColorSequenceKeypoint.new(0.4970000088214874, Color3.new(0.243137, 0.937254, 0.007843)),
			ColorSequenceKeypoint.new(0.503000020980835, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.647569477558136, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.7829861044883728, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.890625, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.9774305820465088, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
		}),
		Zebra = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.015625, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.1458333283662796, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.2482638955116272, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.3559027910232544, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.4970000088214874, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.503000020980835, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.647569477558136, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.7829861044883728, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.890625, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.9774305820465088, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
		}),
		Death = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.6, 0, 0)),
			ColorSequenceKeypoint.new(0.125, Color3.new(1, 0, 0)),
			ColorSequenceKeypoint.new(0.2552083432674408, Color3.new(0.411764, 0, 0)),
			ColorSequenceKeypoint.new(0.3767361044883728, Color3.new(0.3, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.new(0.690196, 0, 0)),
			ColorSequenceKeypoint.new(0.6197916865348816, Color3.new(0.3, 0, 0)),
			ColorSequenceKeypoint.new(0.7378472089767456, Color3.new(1, 0, 0)),
			ColorSequenceKeypoint.new(0.8680555820465088, Color3.new(0.3, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.new(0.6, 0, 0)),
		}),
		Ghost = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, Color3.new(0.7098039388656616, 0.7215686440467834, 0.7372549176216125)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
		}),
		Bubblegum = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.9529411792755127, 0.3960784375667572, 0.6941176652908325)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.6549019813537598, 0.8901960849761963)),
			ColorSequenceKeypoint.new(1, Color3.new(0.9529411792755127, 0.3960784375667572, 0.6941176652908325)),
		}),
		Green = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0)),
		}),
	},
	Transparency = {
		Ghost = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.09894459694623947, 0),
			NumberSequenceKeypoint.new(0.5, 1),
			NumberSequenceKeypoint.new(0.8997361660003662, 0),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Bubblegum = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.09894459694623947, 0),
			NumberSequenceKeypoint.new(0.5, 1),
			NumberSequenceKeypoint.new(0.8997361660003662, 0),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Green = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.7, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Wave = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.25, 1),
			NumberSequenceKeypoint.new(0.5, 1),
			NumberSequenceKeypoint.new(0.75, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
	},
	Solid = NumberSequence.new(0),
}

--// GENERIC 3D VIEWPORT COMPONENT (RICH ORBIT + MANUAL DRAG)
local BLEND_TIME = 0.5

local function EvalColorSequence(keypoints, time)
	local sequence = {}
	time += 1
	for x = 0, 2 do
		for i = 1, #keypoints do
			table.insert(sequence, { Time = keypoints[i].Time + x, Value = keypoints[i].Value })
		end
	end
	for i = 1, #sequence - 1 do
		local thisKeypoint = sequence[i]
		local nextKeypoint = sequence[i + 1]
		if time >= thisKeypoint.Time and time < nextKeypoint.Time then
			local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time)
			return Color3.new(
				(nextKeypoint.Value.R - thisKeypoint.Value.R) * alpha + thisKeypoint.Value.R,
				(nextKeypoint.Value.G - thisKeypoint.Value.G) * alpha + thisKeypoint.Value.G,
				(nextKeypoint.Value.B - thisKeypoint.Value.B) * alpha + thisKeypoint.Value.B
			)
		end
	end
	return keypoints[#keypoints].Value
end

local function TrueSequence(Sequence, Offset)
	if Offset == 0 then
		return Sequence
	end
	local shifted = {}
	for i, v in ipairs(Sequence.Keypoints) do
		local t = v.Time + Offset
		if t > 1 or t < 0 then
			t = t % 1
		end
		shifted[i] = ColorSequenceKeypoint.new(t, v.Value)
	end
	table.sort(shifted, function(a, b)
		return a.Time < b.Time
	end)
	if shifted[1].Time ~= 0 then
		table.insert(shifted, 1, ColorSequenceKeypoint.new(0, EvalColorSequence(shifted, 0)))
	end
	if shifted[#shifted].Time ~= 1 then
		table.insert(shifted, ColorSequenceKeypoint.new(1, EvalColorSequence(shifted, 1)))
	end
	return ColorSequence.new(shifted)
end

local function EvalNumberSequence(keypoints, time)
	local sequence = {}
	time += 1
	for x = 0, 2 do
		for i = 1, #keypoints do
			table.insert(sequence, { Time = keypoints[i].Time + x, Value = keypoints[i].Value })
		end
	end
	for i = 1, #sequence - 1 do
		local thisKeypoint = sequence[i]
		local nextKeypoint = sequence[i + 1]
		if time >= thisKeypoint.Time and time < nextKeypoint.Time then
			local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time)
			return thisKeypoint.Value + (nextKeypoint.Value - thisKeypoint.Value) * alpha
		end
	end
	return keypoints[#keypoints].Value
end

local function TrueNumberSequence(Sequence, Offset)
	if Offset == 0 then
		return Sequence
	end
	local shifted = {}
	for i, v in ipairs(Sequence.Keypoints) do
		local t = v.Time + Offset
		if t > 1 or t < 0 then
			t = t % 1
		end
		shifted[i] = NumberSequenceKeypoint.new(t, v.Value)
	end
	table.sort(shifted, function(a, b)
		return a.Time < b.Time
	end)
	if shifted[1].Time ~= 0 then
		table.insert(shifted, 1, NumberSequenceKeypoint.new(0, EvalNumberSequence(shifted, 0)))
	end
	if shifted[#shifted].Time ~= 1 then
		table.insert(shifted, NumberSequenceKeypoint.new(1, EvalNumberSequence(shifted, 1)))
	end
	return NumberSequence.new(shifted)
end

local function BlendSequences(From, To, Alpha)
	local kpA = To.Keypoints
	local kpB = From.Keypoints
	local newkeypoints = {}
	if #kpA ~= #kpB then
		for i, v in ipairs(kpA) do
			newkeypoints[i] = ColorSequenceKeypoint.new(v.Time, EvalColorSequence(kpB, v.Time))
		end
	else
		for i, v in ipairs(kpA) do
			local sample = EvalColorSequence(kpB, v.Time)
			newkeypoints[i] = ColorSequenceKeypoint.new(v.Time, sample:Lerp(v.Value, Alpha))
		end
	end
	return ColorSequence.new(newkeypoints)
end

local function TargetSequence(Conf)
	if Conf.Sequence then
		return Conf.Sequence
	end
	if Conf.Preset == "Custom" then
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, Conf.ColorTop),
			ColorSequenceKeypoint.new(0.5, Conf.ColorMiddle),
			ColorSequenceKeypoint.new(1, Conf.ColorBottom),
		})
	end
	return Presets.Sequence[Conf.Preset] or Presets.Sequence.Gold
end

local GradActive = {}
local Ticker = nil

local function EnsureTicker()
	if Ticker then
		return
	end
	Ticker = RunService.Heartbeat:Connect(function(dt)
		for i = #GradActive, 1, -1 do
			local St = GradActive[i]
			if St.Dead or not St.Grad.Parent then
				table.remove(GradActive, i)
			else
				local Conf = St.GetConf()
				if not Conf.Enabled then
					St.Dead = true
					table.remove(GradActive, i)
				else
					if St.BlendT < 1 then
						St.BlendT = math.min(1, St.BlendT + dt / BLEND_TIME)
						if St.BlendT >= 1 then
							St.Current = St.Target
						else
							St.Current = BlendSequences(St.Current, St.Target, St.BlendT)
						end
					end
					St.Speed = St.Speed + (Conf.OffsetSpeed - St.Speed) * dt
					if Conf.OffsetSpeed == 0 and math.abs(St.Speed) < 0.002 then
						St.Speed = 0
					end
					St.Offset += St.Speed * dt
					if St.Offset > 1 or St.Offset < -1 then
						St.Offset = St.Offset % 1
					end
					if Conf.RotationSpeed ~= 0 then
						St.Spin = (St.Spin + Conf.RotationSpeed * dt) % 360
					end
					local TSpeed = Conf.TransparencySpeed or 0
					local TransOn = TSpeed ~= 0 and Conf.Transparency ~= nil
					if TransOn then
						St.TransOffset += TSpeed * dt
						if St.TransOffset > 1 or St.TransOffset < -1 then
							St.TransOffset = St.TransOffset % 1
						end
					end
					local OscAmp = Conf.OscAmp or 0
					if OscAmp ~= 0 then
						St.OscPhase += (Conf.OscRate or 0) * dt
					end
					local Pulsing = (Conf.PulseAmp or 0) ~= 0
					if Pulsing then
						St.PulsePhase += (Conf.PulseRate or 0) * dt
					end
					local Moving = St.Speed ~= 0 or Conf.RotationSpeed ~= 0 or St.BlendT < 1 or TransOn or OscAmp ~= 0 or Pulsing
					if Moving or not St.Painted then
						St.Grad.Color = TrueSequence(St.Current, St.Offset)
						local Rot = Conf.Rotation + St.Spin
						if OscAmp ~= 0 then
							Rot = Rot + math.sin(St.OscPhase) * OscAmp
						end
						St.Grad.Rotation = Rot
						if TransOn then
							St.Grad.Transparency = TrueNumberSequence(Conf.Transparency, St.TransOffset)
						end
						if Pulsing then
							local Par = St.Grad.Parent
							if Par and Par:IsA("UIStroke") then
								Par.Thickness = Conf.PulseBase * (1 + Conf.PulseAmp * (math.sin(St.PulsePhase) * 0.5 + 0.5))
							end
						end
						St.Painted = not Moving
					end
				end
			end
		end
		if #GradActive == 0 then
			Ticker:Disconnect()
			Ticker = nil
		end
	end)
end

local function AttachGradient(Grad, GetConf)
	local Conf = GetConf()
	local Target = TargetSequence(Conf)
	local St = {
		Grad = Grad,
		GetConf = GetConf,
		Current = Target,
		Target = Target,
		BlendT = 1,
		Offset = 0,
		Speed = 0,
		Spin = 0,
		TransOffset = 0,
		OscPhase = 0,
		PulsePhase = 0,
		Painted = false,
		Dead = false,
	}
	table.insert(GradActive, St)
	EnsureTicker()
	return St
end

local Visuals = {
	Presets = Presets,
	SampleSequence = EvalColorSequence,
	AttachGradient = AttachGradient,
}

local getgenv = getgenv or function()
	return shared
end
local setclipboard = setclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
	return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}
local Tooltips = {}

local BaseURL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local CustomImageManager = {}
local CustomImageManagerAssets = {
	TransparencyTexture = {
		RobloxId = 139785960036434,
		Path = "Obsidian/assets/TransparencyTexture.png",
		URL = BaseURL .. "assets/TransparencyTexture.png",

		Id = nil,
	},

	SaturationMap = {
		RobloxId = 4155801252,
		Path = "Obsidian/assets/SaturationMap.png",
		URL = BaseURL .. "assets/SaturationMap.png",

		Id = nil,
	},

	LoadingIcon = {
		RobloxId = 97544096941083,
		Path = "Obsidian/assets/LoadingIcon.png",
		URL = BaseURL .. "assets/LoadingIcon.png",

		Id = nil,
	},

	CheckIcon = {
		RobloxId = 97682394690683,
		Path = "Obsidian/assets/CheckIcon.png",
		URL = BaseURL .. "assets/CheckIcon.png",

		Id = nil,
	},
}
do
	local function RecursiveCreatePath(Path: string, IsFile: boolean?)
		if not isfolder or not makefolder then
			return
		end

		local Segments = Path:split("/")
		local TraversedPath = ""

		if IsFile then
			table.remove(Segments, #Segments)
		end

		for _, Segment in ipairs(Segments) do
			if not isfolder(TraversedPath .. Segment) then
				makefolder(TraversedPath .. Segment)
			end

			TraversedPath = TraversedPath .. Segment .. "/"
		end

		return TraversedPath
	end

	function CustomImageManager.AddAsset(
		AssetName: string,
		RobloxAssetId: number,
		URL: string,
		ForceRedownload: boolean?
	)
		if CustomImageManagerAssets[AssetName] ~= nil then
			error(string.format("Asset %q already exists", AssetName))
		end

		assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

		CustomImageManagerAssets[AssetName] = {
			RobloxId = RobloxAssetId,
			Path = string.format("Obsidian/custom_assets/%s", AssetName),
			URL = URL,

			Id = nil,
		}

		CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
	end

	function CustomImageManager.GetAsset(AssetName: string)
		if not CustomImageManagerAssets[AssetName] then
			return nil
		end

		local AssetData = CustomImageManagerAssets[AssetName]
		if AssetData.Id then
			return AssetData.Id
		end

		local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

		if getcustomasset then
			local Success, NewID = pcall(getcustomasset, AssetData.Path)

			if Success and NewID then
				AssetID = NewID
			end
		end

		AssetData.Id = AssetID
		return AssetID
	end

	function CustomImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
		if not getcustomasset or not writefile or not isfile then
			return false, "missing functions"
		end

		local AssetData = CustomImageManagerAssets[AssetName]

		RecursiveCreatePath(AssetData.Path, true)

		if ForceRedownload ~= true and isfile(AssetData.Path) then
			return true, nil
		end

		local success, errorMessage = pcall(function()
			writefile(AssetData.Path, game:HttpGet(AssetData.URL))
		end)

		return success, errorMessage
	end

	for AssetName, _ in CustomImageManagerAssets do
		CustomImageManager.DownloadAsset(AssetName)
	end
end

local Library = {
	LocalPlayer = LocalPlayer,
	IsRobloxFocused = true,

	--// Device \\--
	DevicePlatform = nil,
	IsMobile = false,

	--// Obsidian Windows \\--
	ScreenGui = nil,
	Window = nil,
	WindowContainer = nil,

	--// Search \\--
	SearchText = "",
	Searching = false,
	GlobalSearch = false,
	LastSearchTab = nil,

	--// Tabs \\--
	ActiveTab = nil,
	Tabs = {},
	TabButtons = {},

	--// Dependency Boxes \\--
	DependencyBoxes = {},

	--// Keybinds Frame \\--
	KeybindFrame = nil,
	KeybindContainer = nil,
	KeybindToggles = {},

	--// Notifications \\--
	Notifications = {},
	NotifySide = "Right",
	NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	--// Dialogues \\--
	Dialogues = {},
	ActiveDialog = nil,

	--// Loading Window \\--
	ActiveLoading = nil,

	--// Corners \\--
	Corners = {},
	SpecificCorners = {},

	--// Animations \\--
	TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	TabSwipeOffset = 26,
	TabSwipeFrom = "bottom",

	WindowAnimationInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	DropdownTransitionInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	GroupboxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	RotatingChevronTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

	Animations = {
		ToggleWindow = true,
		TabSwitch = true,
		Groupbox = true,
		Dropdown = true,
		KeyPicker = true,
		TabHoverZoom = true,
	},

	--// States \\--
	Toggled = false,
	Unloaded = false,

	--// Elements \\--
	Labels = Labels,
	Buttons = Buttons,
	Toggles = Toggles,
	Options = Options,

	--// Options \\--
	ToggleKeybind = Enum.KeyCode.RightControl,
	ShowToggleFrameInKeybinds = true,

	NotifyOnError = false,
	ShowCustomCursor = true,
	ForceCheckbox = false,

	CantDragForced = false,
	DraggableElements = {},

	--// Signals \\--
	Signals = {},
	UnloadSignals = {},

	OriginalMinSize = Vector2.new(480, 360),
	MinSize = Vector2.new(480, 360),
	DPIScale = 1,
	CornerRadius = 10,

	--// Scheme \\--
	IsLightTheme = false,
	Scheme = {
		BackgroundColor = Color3.fromRGB(15, 15, 15),
		MainColor = Color3.fromRGB(36, 36, 36),
		AccentColor = Color3.fromRGB(218, 68, 255),
		OutlineColor = Color3.fromRGB(65, 62, 62),
		FontColor = Color3.fromRGB(255, 255, 255),
		Font = Font.fromEnum(Enum.Font.Code),

		RedColor = Color3.fromRGB(255, 50, 50),
		DestructiveColor = Color3.fromRGB(220, 38, 38),
		DarkColor = Color3.new(0, 0, 0),
		WhiteColor = Color3.new(1, 1, 1),

		BackgroundImage = "",
	},

	--// Registry \\--
	Registry = {},
	Scales = {},
	ScalesOffset = {},

	--// Misc \\--
	ImageManager = CustomImageManager,
	ShowCursorBinding = string.sub(tostring({}), 10),

	Notify = nil,
	Toggle = nil, -- we love luau lsp
}

if RunService:IsStudio() then
	if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
		Library.IsMobile = true
		Library.OriginalMinSize = Vector2.new(480, 240)
	else
		Library.IsMobile = false
		Library.OriginalMinSize = Vector2.new(480, 360)
	end
else
	pcall(function()
		Library.DevicePlatform = UserInputService:GetPlatform()
	end)

	Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
	Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
end

local Templates = {
	SpotlightCard = { Height = 110, Title = "", Description = "", Image = "" },
	--// UI \\--
	Frame = {
		BorderSizePixel = 0,
	},
	ImageLabel = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	},
	ImageButton = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
	},
	ScrollingFrame = {
		BorderSizePixel = 0,
	},
	TextLabel = {
		BorderSizePixel = 0,
		FontFace = "Font",
		RichText = true,
		TextColor3 = "FontColor",
	},
	TextButton = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		FontFace = "Font",
		RichText = true,
		TextColor3 = "FontColor",
	},
	TextBox = {
		BorderSizePixel = 0,
		FontFace = "Font",
		PlaceholderColor3 = function()
			local H, S, V = Library.Scheme.FontColor:ToHSV()
			return Color3.fromHSV(H, S, V / 2)
		end,
		Text = "",
		TextColor3 = "FontColor",
	},
	UIListLayout = {
		SortOrder = Enum.SortOrder.LayoutOrder,
	},
	UIStroke = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	},

	--// Library \\--
	Window = {
		Title = "No Title",
		Footer = "No Footer",

		Position = UDim2.fromOffset(6, 6),
		Size = UDim2.fromOffset(720, 600),
		IconSize = UDim2.fromOffset(36, 36),

		AutoShow = true,
		Center = true,
		Resizable = true,

		SearchbarSize = UDim2.fromScale(1, 1),
		GlobalSearch = false,

		CornerRadius = 10,
		NotifySide = "Right",
		ShowCustomCursor = true,

		Font = Enum.Font.Code,
		ToggleKeybind = Enum.KeyCode.RightControl,

		ShowMobileButtons = true,
		MobileButtonsSide = "Left",

		UnlockMouseWhileOpen = true,

		EnableSidebarResize = false,
		EnableCompacting = true,
		DisableCompactingSnap = false,
		SidebarCompacted = false,
		MinContainerWidth = 256,

		--// Snapping \\--
		MinSidebarWidth = 128,
		SidebarCompactWidth = 48,
		SidebarCollapseThreshold = 0.5,

		--// Dragging \\--
		CompactWidthActivation = 128,

		BackgroundImage = "111593326989465",
		BackgroundImageTransparency = 0,
		BackgroundImageScaleType = "Stretch",
		BackgroundImageColor = Color3.fromRGB(148, 148, 148),
		BackgroundImageLayer = "back",

		BackgroundOverlayEnabled = true,
		BackgroundOverlayColor = Color3.fromRGB(0, 0, 0),
		BackgroundOverlayTransparency = 0.40,

		WindowTransparency = 1,
		ContentTransparency = 1,
		GroupTransparency = 0.5,
		GroupContrast = 40,

		--// Animations \\--
		Animations = {
			ToggleWindow = true,
			TabSwitch = true,
			Groupbox = true,
			Dropdown = true,
			KeyPicker = true,
		TabHoverZoom = true,
		},

		TabTransitionTime = 0.22,
		TabSwipeOffset = 26,
		TabSwipeFrom = "bottom",
	},
	Dialog = {
		Title = "Dialog",
		Description = "Description",
		AutoDismiss = true,
		OutsideClickDismiss = true,
		FooterButtons = {},
	},
	Loading = {
		Title = "mspaint",
		Icon = 95816097006870,
		IconSize = UDim2.fromOffset(36, 36),

		LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
		LoadingIconColor = nil,
		LoadingIconTweenTime = 1,

		CurrentStep = 0,
		TotalSteps = 10,

		ShowSidebar = false,
		AutoResizeHeight = false,

		WindowWidth = 450,
		WindowHeight = 275,

		ContentWidth = 450,
		SidebarWidth = 250,
	},
	Toggle = {
		Text = "Toggle",
		Default = false,

		Callback = function() end,
		Changed = function() end,

		Risky = false,
		Disabled = false,
		Visible = true,
	},
	Input = {
		Text = "Input",
		Default = "",
		Finished = false,
		Numeric = false,
		ClearTextOnFocus = true,
		ClearTextOnBlur = false,
		Placeholder = "",
		AllowEmpty = true,
		EmptyReset = "---",

		Callback = function() end,
		Changed = function() end,
		VerifyValue = nil,

		Disabled = false,
		Visible = true,
	},
	Slider = {
		Text = "Slider",
		Default = 0,
		Min = 0,
		Max = 100,
		Rounding = 0,

		Prefix = "",
		Suffix = "",

		Callback = function() end,
		Changed = function() end,

		Disabled = false,
		Visible = true,

		AllowRightClickInput = true,
	},
	Dropdown = {
		Values = {},
		DisabledValues = {},
		ValueImages = {},

		Multi = false,
		DragSelect = false,
		MaxVisibleDropdownItems = 8,

		Callback = function() end,
		Changed = function() end,

		Disabled = false,
		Visible = true,
	},
	DropdownV2 = {
		Values = {},
		DisabledValues = {},
		ItemIcons = {},

		Multi = false,
		Max = 0,
		ListHeight = 200,

		Icon = nil,
		Placeholder = "Select...",

		Callback = function() end,
		Changed = function() end,

		Disabled = false,
		Visible = true,
	},
	Viewport = {
		Object = nil,
		Camera = nil,
		Clone = true,
		AutoFocus = true,
		Interactive = false,
		Height = 200,
		Visible = true,
	},
	Image = {
		Image = "",
		Transparency = 0,
		BackgroundTransparency = 0,
		Color = Color3.new(1, 1, 1),
		RectOffset = Vector2.zero,
		RectSize = Vector2.zero,
		ScaleType = Enum.ScaleType.Fit,
		Height = 200,
		Visible = true,
	},
	Video = {
		Video = "",
		Looped = false,
		Playing = false,
		Volume = 1,
		Height = 200,
		Visible = true,
	},
	UIPassthrough = {
		Instance = nil,
		Height = 24,
		Visible = true,
	},

	--// Addons \\-
	KeyPicker = {
		Text = "KeyPicker",

		Default = "None",
		DefaultModifiers = {},

		Blacklisted = {},
		BlacklistedModifiers = {},
		Whitelisted = {},
		WhitelistedModifiers = {},

		Mode = "Toggle",
		Modes = { "Always", "Toggle", "Hold" },
		SyncToggleState = false,

		Callback = function() end,
		ChangedCallback = function() end,
		Changed = function() end,
		Clicked = function() end,
	},
	ColorPicker = {
		Default = Color3.new(1, 1, 1),

		Callback = function() end,
		Changed = function() end,
	},
}

local Places = {
	Bottom = { 0, 1 },
	Right = { 1, 0 },
}
local Sizes = {
	Left = { 0.5, 1 },
	Right = { 0.5, 1 },
}

--// Scheme Functions \\--
local SchemeReplaceAlias = {
	RedColor = "Red",
	WhiteColor = "White",
	DarkColor = "Dark",
}

local SchemeAlias = {
	Red = "RedColor",
	White = "WhiteColor",
	Dark = "DarkColor",
}

local function GetSchemeValue(Index)
	if not Index then
		return nil
	end

	local ReplaceAliasIndex = SchemeReplaceAlias[Index]
	if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
		Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
		Library.Scheme[ReplaceAliasIndex] = nil

		return Library.Scheme[Index]
	end

	local AliasIndex = SchemeAlias[Index]
	if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
		warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
		return Library.Scheme[AliasIndex]
	end

	return Library.Scheme[Index]
end

--// Basic Functions \\--
local function WaitForEvent(Event, Timeout, Condition)
	local Bindable = Instance.new("BindableEvent")
	local Connection = Event:Once(function(...)
		if not Condition or typeof(Condition) == "function" and Condition(...) then
			Bindable:Fire(true)
		else
			Bindable:Fire(false)
		end
	end)
	task.delay(Timeout, function()
		Connection:Disconnect()
		Bindable:Fire(false)
	end)

	local Result = Bindable.Event:Wait()
	Bindable:Destroy()

	return Result
end

local function IsMouseInput(Input: InputObject, IncludeM2: boolean?)
	return Input.UserInputType == Enum.UserInputType.MouseButton1
		or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
		or Input.UserInputType == Enum.UserInputType.Touch
end
local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
	return IsMouseInput(Input, IncludeM2)
		and Input.UserInputState == Enum.UserInputState.Begin
		and Library.IsRobloxFocused
end
local function IsHoverInput(Input: InputObject)
	return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
		and Input.UserInputState == Enum.UserInputState.Change
end
local function IsDragInput(Input: InputObject, IncludeM2: boolean?)
	return IsMouseInput(Input, IncludeM2)
		and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
		and Library.IsRobloxFocused
end
local function IsMouseClickInput(Input: InputObject)
	return Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.MouseButton2
		or Input.UserInputType == Enum.UserInputType.MouseButton3
end
local function IsMovementInput(Input: InputObject)
	return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
		and Library.IsRobloxFocused
end

local function GetTableSize(Table: { [any]: any })
	local Size = 0

	for _, _ in Table do
		Size += 1
	end

	return Size
end
local function StopTween(Tween: TweenBase, Destroy: boolean?)
	if not Tween then
		return
	end

	if Tween.PlaybackState == Enum.PlaybackState.Playing then
		Tween:Cancel()
	end

	if Destroy == true then
		pcall(Tween.Destroy, Tween)
	end
end
local function Trim(Text: string)
	return Text:match("^%s*(.-)%s*$")
end
local function Round(Value, Rounding)
	assert(Rounding >= 0, "Invalid rounding number.")

	if Rounding == 0 then
		return math.floor(Value)
	end

	return tonumber(string.format("%." .. Rounding .. "f", Value))
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
	local PlayerList = Players:GetPlayers()

	if ExcludeLocalPlayer then
		local Idx = table.find(PlayerList, LocalPlayer)
		if Idx then
			table.remove(PlayerList, Idx)
		end
	end

	table.sort(PlayerList, function(Player1, Player2)
		return Player1.Name:lower() < Player2.Name:lower()
	end)

	return PlayerList
end
local function GetTeams()
	local TeamList = Teams:GetTeams()

	table.sort(TeamList, function(Team1, Team2)
		return Team1.Name:lower() < Team2.Name:lower()
	end)

	return TeamList
end

function Library:UpdateDependencyBoxes()
	for _, Depbox in Library.DependencyBoxes do
		Depbox:Update(true)
	end

	if Library.Searching then
		Library:UpdateSearch(Library.SearchText)
	end
end

local function CheckDepbox(Box, Search)
	local VisibleElements = 0

	for _, ElementInfo in Box.Elements do
		if ElementInfo.Type == "Divider" then
			ElementInfo.Holder.Visible = false
			continue
		elseif ElementInfo.SubButton then
			--// Check if any of the Buttons Name matches with Search
			local Visible = false

			--// Check if Search matches Element's Name and if Element is Visible
			if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
				Visible = true
			else
				ElementInfo.Base.Visible = false
			end
			if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
				Visible = true
			else
				ElementInfo.SubButton.Base.Visible = false
			end
			ElementInfo.Holder.Visible = Visible
			if Visible then
				VisibleElements += 1
			end

			continue
		end

		--// Check if Search matches Element's Name and if Element is Visible
		if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
			ElementInfo.Holder.Visible = true
			VisibleElements += 1
		else
			ElementInfo.Holder.Visible = false
		end
	end

	for _, Depbox in Box.DependencyBoxes do
		if not Depbox.Visible then
			continue
		end

		VisibleElements += CheckDepbox(Depbox, Search)
	end

	Box.Holder.Visible = VisibleElements > 0
	return VisibleElements
end
local function RestoreDepbox(Box)
	for _, ElementInfo in Box.Elements do
		ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

		if ElementInfo.SubButton then
			ElementInfo.Base.Visible = ElementInfo.Visible
			ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
		end
	end

	Box:Resize()
	Box.Holder.Visible = true

	for _, Depbox in Box.DependencyBoxes do
		if not Depbox.Visible then
			continue
		end

		RestoreDepbox(Depbox)
	end
end

local function ApplySearchToTab(Tab, Search)
	if not Tab then
		return
	end

	local HasVisible = false

	--// Loop through Groupboxes to get Elements Info
	for _, Groupbox in Tab.Groupboxes do
		if Groupbox.Visible == false then
			continue
		end

		local VisibleElements = 0
		for _, ElementInfo in Groupbox.Elements do
			if ElementInfo.Type == "Divider" then
				ElementInfo.Holder.Visible = false
				continue
			elseif ElementInfo.SubButton then
				--// Check if any of the Buttons Name matches with Search
				local Visible = false

				--// Check if Search matches Element's Name and if Element is Visible
				if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
					Visible = true
				else
					ElementInfo.Base.Visible = false
				end
				if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
					Visible = true
				else
					ElementInfo.SubButton.Base.Visible = false
				end
				ElementInfo.Holder.Visible = Visible

				if Visible then
					VisibleElements += 1
				end

				continue
			end

			--// Check if Search matches Element's Name and if Element is Visible
			if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
				ElementInfo.Holder.Visible = true
				VisibleElements += 1
			else
				ElementInfo.Holder.Visible = false
			end
		end

		for _, Depbox in Groupbox.DependencyBoxes do
			if not Depbox.Visible then
				continue
			end

			VisibleElements += CheckDepbox(Depbox, Search)
		end

		--// Update Groupbox Size and Visibility if found any element
		if VisibleElements > 0 then
			Groupbox:Resize()
			HasVisible = true
		end
		Groupbox.BoxHolder.Visible = VisibleElements > 0
	end

	for _, Tabbox in Tab.Tabboxes do
		local VisibleTabs = 0
		local VisibleElements = {}

		for _, SubTab in Tabbox.Tabs do
			VisibleElements[SubTab] = 0

			for _, ElementInfo in SubTab.Elements do
				if ElementInfo.Type == "Divider" then
					ElementInfo.Holder.Visible = false
					continue
				elseif ElementInfo.SubButton then
					--// Check if any of the Buttons Name matches with Search
					local Visible = false

					--// Check if Search matches Element's Name and if Element is Visible
					if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
						Visible = true
					else
						ElementInfo.Base.Visible = false
					end
					if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
						Visible = true
					else
						ElementInfo.SubButton.Base.Visible = false
					end
					ElementInfo.Holder.Visible = Visible
					if Visible then
						VisibleElements[SubTab] += 1
					end

					continue
				end

				--// Check if Search matches Element's Name and if Element is Visible
				if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
					ElementInfo.Holder.Visible = true
					VisibleElements[SubTab] += 1
				else
					ElementInfo.Holder.Visible = false
				end
			end

			for _, Depbox in SubTab.DependencyBoxes do
				if not Depbox.Visible then
					continue
				end

				VisibleElements[SubTab] += CheckDepbox(Depbox, Search)
			end
		end

		for SubTab, Visible in VisibleElements do
			SubTab.ButtonHolder.Visible = Visible > 0
			if Visible > 0 then
				VisibleTabs += 1
				HasVisible = true

				if Tabbox.ActiveTab == SubTab then
					SubTab:Resize()
				elseif Tabbox.ActiveTab and VisibleElements[Tabbox.ActiveTab] == 0 then
					SubTab:Show()
				end
			end
		end

		--// Update Tabbox Visibility if any visible
		Tabbox.BoxHolder.Visible = VisibleTabs > 0
	end

	return HasVisible
end
local function ResetTab(Tab)
	if not Tab then
		return
	end

	for _, Groupbox in Tab.Groupboxes do
		for _, ElementInfo in Groupbox.Elements do
			ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

			if ElementInfo.SubButton then
				ElementInfo.Base.Visible = ElementInfo.Visible
				ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
			end
		end

		for _, Depbox in Groupbox.DependencyBoxes do
			if not Depbox.Visible then
				continue
			end

			RestoreDepbox(Depbox)
		end

		Groupbox:Resize()
		Groupbox.BoxHolder.Visible = Groupbox.Visible ~= false
	end

	for _, Tabbox in Tab.Tabboxes do
		for _, SubTab in Tabbox.Tabs do
			for _, ElementInfo in SubTab.Elements do
				ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

				if ElementInfo.SubButton then
					ElementInfo.Base.Visible = ElementInfo.Visible
					ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
				end
			end

			for _, Depbox in SubTab.DependencyBoxes do
				if not Depbox.Visible then
					continue
				end

				RestoreDepbox(Depbox)
			end

			SubTab.ButtonHolder.Visible = true
		end

		if Tabbox.ActiveTab then
			Tabbox.ActiveTab:Resize()
		end
		Tabbox.BoxHolder.Visible = true
	end
end

function Library:UpdateSearch(SearchText)
	Library.SearchText = SearchText

	local TabsToReset = {}

	if Library.GlobalSearch then
		for _, Tab in Library.Tabs do
			if typeof(Tab) == "table" and not Tab.IsKeyTab then
				table.insert(TabsToReset, Tab)
			end
		end
	elseif Library.LastSearchTab and typeof(Library.LastSearchTab) == "table" then
		table.insert(TabsToReset, Library.LastSearchTab)
	end

	for _, Tab in ipairs(TabsToReset) do
		ResetTab(Tab)
	end

	local Search = SearchText:lower()
	if Trim(Search) == "" then
		Library.Searching = false
		Library.LastSearchTab = nil
		return
	end
	if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then
		Library.Searching = false
		Library.LastSearchTab = nil
		return
	end

	Library.Searching = true

	local TabsToSearch = {}

	if Library.GlobalSearch then
		TabsToSearch = TabsToReset
		if #TabsToSearch == 0 then
			for _, Tab in Library.Tabs do
				if typeof(Tab) == "table" and not Tab.IsKeyTab then
					table.insert(TabsToSearch, Tab)
				end
			end
		end
	elseif Library.ActiveTab then
		table.insert(TabsToSearch, Library.ActiveTab)
	end

	local FirstVisibleTab = nil
	local ActiveHasVisible = false

	for _, Tab in ipairs(TabsToSearch) do
		local HasVisible = ApplySearchToTab(Tab, Search)
		if HasVisible then
			if not FirstVisibleTab then
				FirstVisibleTab = Tab
			end
			if Tab == Library.ActiveTab then
				ActiveHasVisible = true
			end
		end
	end

	if Library.GlobalSearch then
		if ActiveHasVisible and Library.ActiveTab then
			Library.ActiveTab:RefreshSides()
		elseif FirstVisibleTab then
			local SearchMarker = SearchText
			task.defer(function()
				if Library.SearchText ~= SearchMarker then
					return
				end

				if Library.ActiveTab ~= FirstVisibleTab then
					FirstVisibleTab:Show()
				end
			end)
		end
		Library.LastSearchTab = nil
	else
		Library.LastSearchTab = Library.ActiveTab
	end
end

function Library:AddToRegistry(Instance, Properties)
	Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
	Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
	for Instance, Properties in Library.Registry do
		for Property, Index in Properties do
			local SchemeValue = GetSchemeValue(Index)

			if SchemeValue or typeof(Index) == "function" then
				Instance[Property] = SchemeValue or Index()
			end
		end
	end

	if Library.CursorGlowLayers and typeof(Library.CursorGlow.Color) ~= "Color3" then
		local Color = Library.Scheme.AccentColor
		for _, Layer in ipairs(Library.CursorGlowLayers) do
			Layer.Frame.BackgroundColor3 = Color
		end
	end
end

function Library:SetDPIScale(DPIScale: number)
	Library.DPIScale = DPIScale / 100
	Library.MinSize = Library.OriginalMinSize * Library.DPIScale

	for _, UIScale in Library.Scales do
		UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
	end

	for _, Option in Options do
		if Option.Type == "Dropdown" then
			Option:RecalculateListSize()
		end
	end

	for _, Notification in Library.Notifications do
		Notification:Resize()
	end

	Library:UpdateNotificationPositions(true)
end

function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
	local ConnectionType = typeof(Connection)
	if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
		table.insert(Library.Signals, Connection)
	end

	return Connection
end

function IsValidCustomIcon(Icon: string)
	return typeof(Icon) == "string"
		and (
			Icon:match("^rbxasset://textures/")
			or Icon:match("roblox%.com/asset/%?id=")
			or Icon:match("rbxthumb://type=")
		)
end

local function IsCustomAssetIcon(Icon: string, IncludeAssetId: boolean)
	return typeof(Icon) == "string"
		and (
			Icon:match("^content://")
			or Icon:match("^rbxasset://%x+/")
			or (IncludeAssetId == true and Icon:match("^rbxassetid://"))
		)
end

type Icon = {
	Url: string,
	Id: number,
	IconName: string,
	ImageRectOffset: Vector2,
	ImageRectSize: Vector2,
}

type IconModule = {
	Icons: { string },
	GetAsset: (Name: string) -> Icon?,
}

local LucideSources = {
	"https://gitlab.com/upio/lucide-roblox-direct/-/raw/main/source.lua",
	"https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/main/source.lua",
}

local FetchIcons: boolean = false
local Icons: IconModule? = nil

for _, SourceURL in LucideSources do
	local Success, Result = pcall(function()
		return (loadstring(game:HttpGet(SourceURL)) :: () -> IconModule)()
	end)

	if Success and typeof(Result) == "table" and typeof(Result.GetAsset) == "function" then
		FetchIcons = true
		Icons = Result
		break
	end
end

local LucideAliases = {
	["alert-triangle"] = "triangle-alert",
	["bar-chart-2"] = "chart-column",
	["chat"] = "message-square",
	["check-circle"] = "circle-check",
	["check-square"] = "square-check",
	["donator"] = "crown",
	["edit"] = "pencil",
	["forum"] = "messages-square",
	["home"] = "house",
	["sliders"] = "sliders-horizontal",
	["trash-2"] = "trash",
	["unlock"] = "lock-open",
	["x-circle"] = "circle-x",
}

function Library:GetIcon(IconName: string)
	if typeof(IconName) ~= "string" or not (FetchIcons and Icons) then
		return nil
	end

	local Resolved = LucideAliases[IconName] or IconName
	local Success, Icon = pcall(Icons.GetAsset, Resolved)
	if Success and Icon then
		return Icon
	end

	return nil
end

function Library:GetCustomIcon(IconName: string): any
	if not IconName then
		return nil
	end

	if tonumber(IconName) then
		IconName = string.format("rbxassetid://%s", tostring(IconName))
	end

	if IsCustomAssetIcon(IconName, true) then
		return {
			Url = IconName,
			ImageRectOffset = Vector2.zero,
			ImageRectSize = Vector2.zero,
		}
	elseif IsValidCustomIcon(IconName) then
		return {
			Url = IconName,
			ImageRectOffset = Vector2.zero,
			ImageRectSize = Vector2.zero,
			Custom = true,
		}
	end

	local LucideIcon = Library:GetIcon(IconName)
	if LucideIcon then
		return LucideIcon
	end

	return nil
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
	if typeof(Table) ~= "table" then
		return Template
	end

	for k, v in Template do
		if typeof(k) == "number" then
			continue
		end

		if typeof(v) == "table" then
			Table[k] = Library:Validate(Table[k], v)
		elseif Table[k] == nil then
			Table[k] = v
		end
	end

	return Table
end

--// Creator Functions \\--
local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
	local ThemeProperties = Library.Registry[Instance] or {}

	for key, value in Table do
		if key ~= "Text" then
			local SchemeValue = GetSchemeValue(value)

			if SchemeValue or typeof(value) == "function" then
				ThemeProperties[key] = value
				value = SchemeValue or value()
			else
				ThemeProperties[key] = nil
			end
		end

		Instance[key] = value
	end

	if GetTableSize(ThemeProperties) > 0 then
		Library.Registry[Instance] = ThemeProperties
	end
end

local function New(ClassName: string, Properties: { [string]: any }): any
	local Instance = Instance.new(ClassName)

	if Templates[ClassName] then
		FillInstance(Templates[ClassName], Instance)
	end
	FillInstance(Properties, Instance)

	if Properties["Parent"] and not Properties["ZIndex"] then
		pcall(function()
			Instance.ZIndex = Properties.Parent.ZIndex
		end)
	end

	return Instance
end

local function MakeGradient(Parent)
	local G = Library.ButtonGradient
	local Pos = math.clamp(G.MiddlePosition, 0.02, 0.98)
	local Gradient = New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, G.ColorTop),
			ColorSequenceKeypoint.new(Pos, G.ColorMiddle),
			ColorSequenceKeypoint.new(1, G.ColorBottom),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(Pos, G.MiddleTransparency),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Enabled = G.Enabled,
		Rotation = G.Rotation,
		Offset = Vector2.new(G.Offset, 0),
		Parent = Parent,
	})
	table.insert(Library.ButtonGradientInstances, Gradient)
	return Gradient
end

Library.OutlineSpin = {
	Enabled = true,
	Speed = 8.5,
	ColorA = Color3.fromRGB(255, 255, 255),
	ColorB = Color3.fromRGB(193, 193, 193),
	Preset = "RainbowOutline",
}

Library.StrokeStyles = {
	Chrome = { Sequence = "Chrome", Rot = -89, Flow = 0.58, Spin = 0 },
	Gold = { Sequence = "Gold", Rot = 75, Flow = -1, Spin = 0 },
	Silver = { Sequence = "Silver", Rot = -79, Flow = 0.56, Spin = 0 },
	Fire = { Sequence = "Fire", Rot = 75, Flow = -1, Spin = 0 },
	Ice = { Sequence = "Ice", Rot = -61, Flow = 0.23, Spin = 0 },
	Neon = { Sequence = "Neon", Rot = -45, Flow = -0.7, Spin = 0 },
	Death = { Sequence = "Death", Rot = -85, Flow = -1, Spin = 0 },
	Galaxy = { Sequence = "Galaxy", Rot = -90, Flow = -0.3, Spin = -15 },
	Electric = { Sequence = "Electric", Rot = 60, Flow = -2, Spin = 0, Osc = -30, OscRate = 2.25, Pulse = true },
	Sunset = { Sequence = "Sunset", Rot = 60, Flow = -0.6, Spin = 0, Osc = -20, OscRate = 2 },
	Rainbow = { Sequence = "Rainbow", Rot = 0, Flow = -1, Spin = 0 },
	Lava = { Sequence = "Lava", Rot = 0, Flow = -1, Spin = 0 },
	Oceanic = { Sequence = "Oceanic", Rot = 0, Flow = -1, Spin = 0 },
	Ghost = { Sequence = "Ghost", Trans = "Ghost", Rot = 0, Flow = -0.9, Spin = 0, TransFlow = -0.9 },
	Wave = { Trans = "Wave", Rot = 0, Flow = 1, Spin = 0, TransFlow = 0.9, Build = function(Base)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, Base),
			ColorSequenceKeypoint.new(0.5, Base),
			ColorSequenceKeypoint.new(1, Base),
		})
	end },
	GreenOutline = { Sequence = "Green", Trans = "Green", Rot = 5, Flow = 0, Spin = 1 },
	RainbowOutline = { Sequence = "Rainbow", Rot = 5, Flow = 0, Spin = 1 },
	ShineOutline = { Rot = 0.75, Flow = 0, Spin = 1, Build = function(Base)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, Base),
			ColorSequenceKeypoint.new(0.5, Base:Lerp(Color3.new(1, 1, 1), 0.6)),
			ColorSequenceKeypoint.new(1, Base),
		})
	end },
}

Library.OutlineSpinObjects = {}

function Library:AddOutlineSpin(Parent)
	local Holder = New("Frame", {
		Name = "OutlineSpin",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = Parent.ZIndex + 2,
		Parent = Parent,
	})
	table.insert(Library.Corners, New("UICorner", {
		CornerRadius = UDim.new(0, 10),
		Parent = Holder,
	}))
	local Stroke = New("UIStroke", {
		Color = Color3.fromRGB(255, 255, 255),
		Thickness = 1.8,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = Holder,
	})
	local Grad = New("UIGradient", {
		Parent = Stroke,
	})
	table.insert(Library.OutlineSpinObjects, { Stroke = Stroke, Grad = Grad, Tween = nil })
	Library:ApplyOutlineSpin()
	return Holder
end

function Library:ApplyOutlineSpin()
	local S = Library.OutlineSpin
	local Style = nil
	if S.Preset ~= "Classic" then
		Style = Library.StrokeStyles[S.Preset]
	end
	for _, Obj in ipairs(Library.OutlineSpinObjects) do
		if Obj.Grad.Parent then
			Obj.Stroke.Enabled = S.Enabled
			Obj.Stroke.Thickness = 1.8
			if Obj.Tween then
				Obj.Tween:Cancel()
				Obj.Tween = nil
			end
			if Obj.GState and (not S.Enabled or not Style) then
				Obj.GState.Dead = true
				Obj.GState = nil
			end
			if not S.Enabled then
				continue
			end
			if not Style then
				Obj.Grad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, S.ColorA),
					ColorSequenceKeypoint.new(0.35, S.ColorB),
					ColorSequenceKeypoint.new(1, S.ColorA),
				})
				Obj.Grad.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.15, 0),
					NumberSequenceKeypoint.new(0.35, 1),
					NumberSequenceKeypoint.new(1, 1),
				})
				Obj.Grad.Rotation = 0
				Obj.Tween = TweenService:Create(Obj.Grad, TweenInfo.new(math.clamp(S.Speed, 0.5, 20), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 })
				Obj.Tween:Play()
			else
				local Seq = nil
				if Style.Build then
					Seq = Style.Build(S.ColorA)
				elseif Visuals then
					Seq = Visuals.Presets.Sequence[Style.Sequence]
				end
				if not Seq then
					Seq = ColorSequence.new({
						ColorSequenceKeypoint.new(0, S.ColorA),
						ColorSequenceKeypoint.new(1, S.ColorA),
					})
				end
				Obj.Seq = Seq
				local TransSeq = NumberSequence.new(0)
				if Visuals then
					TransSeq = (Style.Trans and Visuals.Presets.Transparency[Style.Trans]) or Visuals.Presets.Solid
				end
				Obj.Trans = TransSeq
				Obj.Grad.Transparency = TransSeq
				if Obj.GState then
					Obj.GState.Target = Seq
					Obj.GState.BlendT = 0
					Obj.GState.Painted = false
				elseif Visuals and type(Visuals.AttachGradient) == "function" then
					Obj.GState = Visuals.AttachGradient(Obj.Grad, function()
						local Cur = Library.StrokeStyles[Library.OutlineSpin.Preset]
						local Sp = Library.OutlineSpin.Speed
						return {
							Enabled = Library.OutlineSpin.Enabled,
							Sequence = Obj.Seq,
							Rotation = Cur and Cur.Rot or 0,
							OffsetSpeed = Cur and Sp * Cur.Flow or 0,
							RotationSpeed = Cur and Sp * Cur.Spin or 0,
							Transparency = Obj.Trans,
							TransparencySpeed = Cur and Sp * (Cur.TransFlow or 0) or 0,
							OscAmp = Cur and Cur.Osc or 0,
							OscRate = Cur and Sp * (Cur.OscRate or 0) or 0,
							PulseBase = Cur and Cur.Pulse and 1.8 or 0,
							PulseAmp = Cur and Cur.Pulse and 0.4 or 0,
							PulseRate = Cur and Sp * (Cur.Pulse and 3 or 0) or 0,
						}
					end)
				else
					Obj.Grad.Color = Seq
					Obj.Grad.Rotation = Style.Rot
				end
			end
		end
	end
end

function Library:SetOutlineSpin(Info)
	if typeof(Info) ~= "table" then
		return
	end
	local S = Library.OutlineSpin
	if typeof(Info.Enabled) == "boolean" then
		S.Enabled = Info.Enabled
	end
	if typeof(Info.Speed) == "number" then
		S.Speed = math.clamp(Info.Speed, 0.5, 20)
	end
	if typeof(Info.ColorA) == "Color3" then
		S.ColorA = Info.ColorA
	end
	if typeof(Info.ColorB) == "Color3" then
		S.ColorB = Info.ColorB
	end
	if typeof(Info.Preset) == "string" then
		if Info.Preset == "Classic" or Library.StrokeStyles[Info.Preset] then
			S.Preset = Info.Preset
		end
	end
	Library:ApplyOutlineSpin()
end

Library.DashboardStyle = {
	StatHeight = 25,
	MeterHeight = 34,
	DividerTransparency = 0.5,
	HoverTransparency = 0.65,
	TextSize = 13,
	CustomLabelColor = false,
	LabelColor = Color3.fromRGB(255, 255, 255),
}

Library.Dashboards = {}

function Library:ApplyDashboardStyle()
	for _, Dash in ipairs(Library.Dashboards) do
		if Dash.Frame.Parent and type(Dash.Restyle) == "function" then
			Dash:Restyle()
		end
	end
end

function Library:SetDashboardStyle(Info)
	if typeof(Info) ~= "table" then
		return
	end
	local S = Library.DashboardStyle
	if typeof(Info.StatHeight) == "number" then
		S.StatHeight = math.clamp(math.floor(Info.StatHeight), 16, 48)
	end
	if typeof(Info.MeterHeight) == "number" then
		S.MeterHeight = math.clamp(math.floor(Info.MeterHeight), 24, 60)
	end
	if typeof(Info.DividerTransparency) == "number" then
		S.DividerTransparency = math.clamp(Info.DividerTransparency, 0, 1)
	end
	if typeof(Info.HoverTransparency) == "number" then
		S.HoverTransparency = math.clamp(Info.HoverTransparency, 0, 1)
	end
	if typeof(Info.TextSize) == "number" then
		S.TextSize = math.clamp(math.floor(Info.TextSize), 9, 20)
	end
	if typeof(Info.CustomLabelColor) == "boolean" then
		S.CustomLabelColor = Info.CustomLabelColor
	end
	if typeof(Info.LabelColor) == "Color3" then
		S.LabelColor = Info.LabelColor
	end
	Library:ApplyDashboardStyle()
end

Library.CardGradient = {
	Enabled = true,
	Preset = "Chrome",
	Rotation = -90,
	OffsetSpeed = 0.1,
	RotationSpeed = 2,
	ColorTop = Color3.fromRGB(38, 38, 44),
	ColorMiddle = Color3.fromRGB(110, 110, 122),
	ColorBottom = Color3.fromRGB(38, 38, 44),
}

function Library:SetCardGradient(Info)
	if typeof(Info) ~= "table" then
		return
	end
	local G = Library.CardGradient
	if typeof(Info.Enabled) == "boolean" then
		G.Enabled = Info.Enabled
	end
	if typeof(Info.Preset) == "string" then
		G.Preset = Info.Preset
	end
	if typeof(Info.Rotation) == "number" then
		G.Rotation = math.clamp(Info.Rotation, -360, 360)
	end
	if typeof(Info.OffsetSpeed) == "number" then
		G.OffsetSpeed = math.clamp(Info.OffsetSpeed, -4, 4)
	end
	if typeof(Info.RotationSpeed) == "number" then
		G.RotationSpeed = math.clamp(Info.RotationSpeed, -360, 360)
	end
	if typeof(Info.ColorTop) == "Color3" then
		G.ColorTop = Info.ColorTop
	end
	if typeof(Info.ColorMiddle) == "Color3" then
		G.ColorMiddle = Info.ColorMiddle
	end
	if typeof(Info.ColorBottom) == "Color3" then
		G.ColorBottom = Info.ColorBottom
	end
end

function Library:SampleCardGradient(Preset)
	if Preset == "Custom" then
		local G = Library.CardGradient
		return G.ColorTop, G.ColorMiddle, G.ColorBottom
	end
	if not Visuals or type(Visuals.SampleSequence) ~= "function" then
		return nil
	end
	local Seq = Visuals.Presets and Visuals.Presets.Sequence and Visuals.Presets.Sequence[Preset]
	if not Seq then
		return nil
	end
	return Visuals.SampleSequence(Seq.Keypoints, 0), Visuals.SampleSequence(Seq.Keypoints, 0.5), Visuals.SampleSequence(Seq.Keypoints, 1)
end

local WallpaperScaleTypes = {}
for _, ScaleItem in Enum.ScaleType:GetEnumItems() do
	WallpaperScaleTypes[ScaleItem.Name] = ScaleItem
end

local function SafeScaleType(Name: string)
	return WallpaperScaleTypes[Name]
end

for AliasName, TargetName in {
	Fill = "Crop",
	Cover = "Crop",
	Contain = "Fit",
} do
	local Target = SafeScaleType(TargetName)
	if Target and WallpaperScaleTypes[AliasName] == nil then
		WallpaperScaleTypes[AliasName] = Target
	end
end

local function ResolveScaleType(Value: any): Enum.ScaleType
	if typeof(Value) == "EnumItem" then
		return Value :: Enum.ScaleType
	end
	if typeof(Value) == "string" then
		return WallpaperScaleTypes[Value] or WallpaperScaleTypes.Stretch or Enum.ScaleType.Stretch
	end
	return Enum.ScaleType.Stretch
end

local WallpaperLayers = {
	back = { Image = -2, Overlay = -1 },
	front = { Image = 999, Overlay = 998 },
}

local function ResolveWallpaperLayer(Value: any): { Image: number, Overlay: number }
	if typeof(Value) == "string" and WallpaperLayers[Value:lower()] then
		return WallpaperLayers[Value:lower()]
	end
	return WallpaperLayers.back
end

local function ClampTransparency(Value: any): number
	local N = tonumber(Value)
	if not N then
		return 0.75
	end
	return math.clamp(N, 0, 1)
end

Library.Surface = {
	CanvasTransparency = 1,
	GroupTransparency = 0.5,
	GroupContrast = 40,
	GroupColor = Color3.fromRGB(0, 0, 0),
	CanvasColor = Color3.fromRGB(119, 119, 119),
	WindowTransparency = 1,
}
Library.SurfaceWindow = nil
Library.SurfaceCanvas = {}
Library.SurfaceGroups = {}

Library.TabAppearance = {
	IconCardEnabled = true,
	IconCardPadding = 2,
	IconCardThickness = 1,
	IconCardTransparency = 0.00,
	IconCardRadius = 5,
	TabBackgroundTransparency = 0.85,
	ActiveBackgroundTransparency = 0.60,
	ActiveBackgroundColor = Color3.fromRGB(0, 0, 0),
	HoverZoom = 1.25,
	ActiveZoom = 1.25,
	ZoomTime = 0.20,
}
Library.TabVisuals = {}

Library.CursorGlow = {
	Enabled = true,
	Color = Color3.fromRGB(255, 255, 255),
	Size = 400,
	Intensity = 10,
	Smooth = 5,
}
Library.CursorGlowLayers = {}
Library.CursorGlowFade = 0

function Library:GetCursorGlowColor(): Color3
	if typeof(Library.CursorGlow.Color) == "Color3" then
		return Library.CursorGlow.Color
	end
	return Library.Scheme.AccentColor
end

function Library:UpdateCursorGlowTransparency(Fade: number)
	local Target = math.clamp(Library.CursorGlow.Intensity, 0, 100) / 100 * Fade
	for _, Layer in ipairs(Library.CursorGlowLayers) do
		Layer.Frame.BackgroundTransparency = 1 - math.clamp(Target * Layer.Weight, 0, 0.9)
	end
	if Library.CursorGlowHolder then
		Library.CursorGlowHolder.Visible = Library.CursorGlow.Enabled ~= false and Fade > 0.01
	end
end

function Library:ApplyCursorGlow()
	local Color = Library:GetCursorGlowColor()
	for _, Layer in ipairs(Library.CursorGlowLayers) do
		Layer.Frame.BackgroundColor3 = Color
		Layer.Frame.Size = UDim2.fromOffset(Library.CursorGlow.Size * Layer.Frac, Library.CursorGlow.Size * Layer.Frac)
	end
	Library:UpdateCursorGlowTransparency(Library.CursorGlowFade)
end

function Library:SetCursorGlow(Info: { [string]: any })
	for Key, Val in pairs(Info or {}) do
		if Library.CursorGlow[Key] ~= nil then
			Library.CursorGlow[Key] = Val
		end
	end
	Library:ApplyCursorGlow()
end

Library.StatusBar = {
	Server = "V3.2",
	Executor = false,
}
Library.StatusBarLabels = {}
Library.StatusBarLoop = false
Library.ExecutorName = "Studio"

function Library:GetExecutorName(): string
	if typeof(Library.StatusBar.Executor) == "string" then
		return Library.StatusBar.Executor
	end
	local OK, Name = pcall(function()
		return (identifyexecutor :: () -> string)()
	end)
	if OK and typeof(Name) == "string" then
		return Name
	end
	return "Studio"
end

function Library:UpdateStatusBar(Fps: number, Ping: number)
	local Labels = Library.StatusBarLabels
	if Labels.Fps then
		Labels.Fps.Text = tostring(Fps)
	end
	if Labels.Ping then
		Labels.Ping.Text = tostring(Ping)
	end
	if Labels.Server then
		Labels.Server.Text = tostring(Library.StatusBar.Server)
	end
	if Labels.Executor then
		Labels.Executor.Text = Library.ExecutorName
	end
end

function Library:StopStatusBarLoop()
	Library.StatusBarLoop = false
end

function Library:StartStatusBarLoop()
	if Library.StatusBarLoop then
		return
	end
	Library.StatusBarLoop = true
	task.spawn(function()
		local Frames = 0
		local Conn = RunService.RenderStepped:Connect(function()
			Frames += 1
		end)
		while Library.StatusBarLoop do
			task.wait(0.5)
			local Fps = Frames * 2
			Frames = 0
			local Ping = 0
			pcall(function()
				local Player = Players.LocalPlayer
				if Player then
					Ping = math.floor(Player:GetNetworkPing() * 1000 + 0.5)
				end
			end)
			Library:UpdateStatusBar(Fps, Ping)
		end
		Conn:Disconnect()
	end)
end

Library.IconAnim = {
	Enabled = true,
	Zoom = 15,
	Tilt = 10,
	Speed = 0.30,
}
Library.IconAnimRegistry = {}

function Library:PlayIconAnim(Anim, Hover: boolean)
	if not Anim or not Anim.Scale.Parent then
		return
	end
	for _, Tween in ipairs(Anim.Tweens) do
		Tween:Cancel()
	end
	local Config = Library.IconAnim
	local Info = TweenInfo.new(math.clamp(Config.Speed, 0.02, 2), Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	Anim.Tweens = {
		TweenService:Create(Anim.Scale, Info, {
			Scale = Hover and (1 + math.clamp(Config.Zoom, 0, 100) / 100) or 1,
		}),
		TweenService:Create(Anim.Rot, Info, {
			Rotation = Hover and math.clamp(Config.Tilt, -45, 45) or 0,
		}),
	}
	for _, Tween in ipairs(Anim.Tweens) do
		Tween:Play()
	end
end

function Library:SetIconAnim(Options: { [string]: any })
	for Key, Val in pairs(Options or {}) do
		if Library.IconAnim[Key] ~= nil then
			Library.IconAnim[Key] = Val
		end
	end
	if Library.IconAnim.Enabled == false then
		for _, Anim in ipairs(Library.IconAnimRegistry) do
			Library:PlayIconAnim(Anim, false)
		end
	end
end

function Library:StartCursorGlowLoop()
	if Library.CursorGlowLoop then
		return
	end
	local Pos = Vector2.new(0, 0)
	local Fade = 0
	local LastFade = 0
	Library.CursorGlowLoop = Library:GiveSignal(RunService.RenderStepped:Connect(function(Dt)
		local Holder = Library.CursorGlowHolder
		if not Holder or not Holder.Parent then
			return
		end
		local Main = Holder.Parent
		local Inside = false
		if Library.CursorGlow.Enabled ~= false and UserInputService.MouseEnabled then
			local Mouse = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
			local Rect = Main.AbsolutePosition
			local Area = Main.AbsoluteSize
			Inside = Mouse.X >= Rect.X and Mouse.X <= Rect.X + Area.X and Mouse.Y >= Rect.Y and Mouse.Y <= Rect.Y + Area.Y
			if Inside then
				Pos = Pos:Lerp(Vector2.new(Mouse.X - Rect.X, Mouse.Y - Rect.Y), math.min(1, Dt * Library.CursorGlow.Smooth))
				Holder.Position = UDim2.fromOffset(Pos.X, Pos.Y)
			end
		end
		Fade = Fade + ((Inside and 1 or 0) - Fade) * math.min(1, Dt * 10)
		Library.CursorGlowFade = Fade
		local Changed = Fade ~= LastFade
		LastFade = Fade
		if Changed then
			Library:UpdateCursorGlowTransparency(Fade)
		end
	end))
end
print("[N3V4 Library] v4.43.0 loaded — STANDALONE SATU FILE: module visual eksternal DIPUTUS TOTAL, engine gradient (ticker bersama + blend + 18 preset + AttachGradient) sekarang INLINE di file ini, nol replica nol dependensi eksternal; ikon lucide 100% dari URL git (lucide-roblox-direct, gitlab + github fallback) — peta sheet offline era debugging Studio DIHAPUS, alias nama lama tetep dinormalkan, asset/URL kustom lewat GetCustomIcon; spotlight card + knob kartu media lama + viewport-tanpa-Object (fitur module era Studio) DICABUT; Games/N3-SAE.luau sekarang load LIB ini via URL raw project ini; (kalau baris ini NGGAK ada di Output, LIB yang ke-load masih lama)")

function Library:GetCanvasColor(): Color3
	if typeof(Library.Surface.CanvasColor) == "Color3" then
		return Library.Surface.CanvasColor
	end
	return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
end

function Library:GetGroupSurfaceColor(): Color3
	if typeof(Library.Surface.GroupColor) == "Color3" then
		return Library.Surface.GroupColor
	end

	local Base = Library.Scheme.BackgroundColor
	local Percent = math.clamp(tonumber(Library.Surface.GroupContrast) or 0, 0, 100) / 100

	if Percent <= 0 then
		return Base
	end

	local Target = Library.IsLightTheme and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	return Base:Lerp(Target, Percent)
end

function Library:ApplySurfaces()
	local CanvasT = ClampTransparency(Library.Surface.CanvasTransparency)
	local GroupT = ClampTransparency(Library.Surface.GroupTransparency)

	if Library.SurfaceWindow and Library.SurfaceWindow.Parent then
		Library.SurfaceWindow.BackgroundTransparency =
			ClampTransparency(Library.Surface.WindowTransparency)
	end

	for CanvasInstance in pairs(Library.SurfaceCanvas) do
		if CanvasInstance.Parent then
			CanvasInstance.BackgroundTransparency = CanvasT
		end
	end

	for GroupInstance in pairs(Library.SurfaceGroups) do
		if GroupInstance.Parent then
			GroupInstance.BackgroundTransparency = GroupT
		end
	end

	Library:UpdateColorsUsingRegistry()
end

function Library:IsInsideSurfaceCard(Obj: GuiObject?): boolean
	local Cur = Obj
	while Cur do
		if Library.SurfaceGroups[Cur] then
			return true
		end
		Cur = Cur.Parent
	end
	return false
end

function Library:CreateTabIconCard(TabIcon: ImageLabel): (Frame, UIScale)
	TabIcon.ZIndex = 3
	local T = Library.TabAppearance
	local Card = New("Frame", {
		Name = "TabIconCard",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 2 * T.IconCardPadding, 1, 2 * T.IconCardPadding),
		Visible = T.IconCardEnabled ~= false,
		ZIndex = 2,
		Parent = TabIcon,
	})
	New("UICorner", {
		CornerRadius = UDim.new(0, T.IconCardRadius),
		Parent = Card,
	})
	New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "OutlineColor",
		Thickness = T.IconCardThickness,
		Transparency = T.IconCardTransparency,
		Parent = Card,
	})
	local Scale = New("UIScale", {
		Scale = 1,
		Parent = TabIcon,
	})
	return Card, Scale
end

function Library:TweenTabZoom(ScaleObj: UIScale?, Zoom: number)
	if not ScaleObj then
		return
	end
	if Library:ZoomTabEnabled() then
		TweenService:Create(ScaleObj, Library:GetZoomTweenInfo(), { Scale = Zoom }):Play()
	else
		ScaleObj.Scale = Zoom
	end
end

function Library:GetZoomTweenInfo(): TweenInfo
	local T = Library.TabAppearance
	return TweenInfo.new(math.clamp(T.ZoomTime, 0.02, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function Library:ZoomTabEnabled(): boolean
	local A = Library.Animations
	return not A or A.TabHoverZoom ~= false
end

function Library:SetTabAppearance(Info: { [string]: any })
	local T = Library.TabAppearance
	for Key, Val in pairs(Info or {}) do
		if T[Key] ~= nil then
			T[Key] = Val
		end
	end
	Library:ApplyTabAppearance()
end

function Library:ApplyTabAppearance()
	local T = Library.TabAppearance
	for _, Rec in ipairs(Library.TabVisuals) do
		if Rec.Card and Rec.Card.Parent then
			Rec.Card.Visible = T.IconCardEnabled ~= false
			Rec.Card.Size = UDim2.new(1, 2 * T.IconCardPadding, 1, 2 * T.IconCardPadding)
			local Corner = Rec.Card:FindFirstChildOfClass("UICorner")
			if Corner then
				Corner.CornerRadius = UDim.new(0, T.IconCardRadius)
			end
			local Stroke = Rec.Card:FindFirstChildOfClass("UIStroke")
			if Stroke then
				Stroke.Thickness = T.IconCardThickness
				Stroke.Transparency = T.IconCardTransparency
			end
		end
		if Rec.Button and Rec.Button.Parent then
			local Active = Rec.Tab ~= nil and Library.ActiveTab == Rec.Tab
			Rec.Button.BackgroundColor3 = Active and T.ActiveBackgroundColor or Library.Scheme.MainColor
			Rec.Button.BackgroundTransparency = Active and T.ActiveBackgroundTransparency or T.TabBackgroundTransparency
		end
		if Rec.Scale and Rec.Scale.Parent then
			local Active = Rec.Tab ~= nil and Library.ActiveTab == Rec.Tab
			Rec.Scale.Scale = Active and T.ActiveZoom or 1
		end
	end
end

function Library:SetBackgroundImage(Image: string | number)
	assert(typeof(Image) == "string" or typeof(Image) == "number", "Expected string/number got " .. typeof(Image))

	Library.Scheme.BackgroundImage = Image
	if Library.Window then
		Library.Window:SetBackgroundImage(Image)
	end

	Library:UpdateColorsUsingRegistry()
end

function Library:SetWallpaper(Info: { [string]: any })
	if typeof(Info) ~= "table" then
		return false, "Info must be a table"
	end

	local Window = Library.Window
	if not Window then
		return false, "No active window (panggil setelah CreateWindow)"
	end

	if Info.Image ~= nil then
		Library:SetBackgroundImage(Info.Image)
	end
	if Info.Transparency ~= nil then
		Window:SetBackgroundImageTransparency(Info.Transparency)
	end
	if Info.ScaleType ~= nil then
		Window:SetBackgroundImageScaleType(Info.ScaleType)
	end
	if Info.Color ~= nil then
		Window:SetBackgroundImageColor(Info.Color)
	end
	if Info.Layer ~= nil then
		Window:SetBackgroundImageLayer(Info.Layer)
	end
	if Info.Overlay ~= nil or Info.OverlayColor ~= nil or Info.OverlayTransparency ~= nil then
		Window:SetBackgroundOverlay(Info.Overlay, Info.OverlayColor, Info.OverlayTransparency)
	end

	return true
end

function Library:SetSurface(Info: { [string]: any })
	if typeof(Info) ~= "table" then
		return false, "Info must be a table"
	end

	if Info.CanvasTransparency ~= nil then
		Library.Surface.CanvasTransparency = ClampTransparency(Info.CanvasTransparency)
	end
	if Info.GroupTransparency ~= nil then
		Library.Surface.GroupTransparency = ClampTransparency(Info.GroupTransparency)
	end
	if Info.GroupContrast ~= nil then
		Library.Surface.GroupContrast = math.clamp(tonumber(Info.GroupContrast) or 0, 0, 100)
	end
	if Info.GroupColor ~= nil then
		if Info.GroupColor == false then
			Library.Surface.GroupColor = nil
		elseif typeof(Info.GroupColor) == "Color3" then
			Library.Surface.GroupColor = Info.GroupColor
		end
	end
	if Info.CanvasColor ~= nil then
		if Info.CanvasColor == false then
			Library.Surface.CanvasColor = nil
		elseif typeof(Info.CanvasColor) == "Color3" then
			Library.Surface.CanvasColor = Info.CanvasColor
		end
	end
	if Info.WindowTransparency ~= nil then
		Library.Surface.WindowTransparency = ClampTransparency(Info.WindowTransparency)
	end

	Library:ApplySurfaces()
	return true
end

--// Main Instances \\-
local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
	local success, _error = pcall(function()
		if not Parent then
			Parent = CoreGui
		end

		local DestinationParent
		if typeof(Parent) == "function" then
			DestinationParent = Parent()
		else
			DestinationParent = Parent
		end

		Instance.Parent = DestinationParent
	end)

	if not (success and Instance.Parent) then
		Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
	end
end

local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
	local playerGui = Library.LocalPlayer:WaitForChild("PlayerGui", 10)
	if playerGui then
		UI.Parent = playerGui
	else
		SafeParentUI(UI, gethui or CoreGui)
	end
end

local ScreenGui = New("ScreenGui", {
	Name = "Obsidian",
	DisplayOrder = 998,
	ResetOnSpawn = false,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui

ScreenGui.DescendantRemoving:Connect(function(Instance)
	Library:RemoveFromRegistry(Instance)
end)

local ModalElement = New("TextButton", {
	BackgroundTransparency = 1,
	Modal = false,
	Size = UDim2.fromScale(0, 0),
	AnchorPoint = Vector2.zero,
	Text = "",
	ZIndex = -999,
	Parent = ScreenGui,
})

--// Cursor
local Cursor, CursorCustomImage
do
	Cursor = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "WhiteColor",
		Size = UDim2.fromOffset(9, 1),
		Visible = false,
		ZIndex = 11000,
		Parent = ScreenGui,
	})
	New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "DarkColor",
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 2, 1, 2),
		ZIndex = 10999,
		Parent = Cursor,
	})

	local CursorV = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "WhiteColor",
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(1, 9),
		ZIndex = 11000,
		Parent = Cursor,
	})
	New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "DarkColor",
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 2, 1, 2),
		ZIndex = 10999,
		Parent = CursorV,
	})

	CursorCustomImage = New("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(20, 20),
		ZIndex = 11000,
		Visible = false,
		Parent = Cursor,
	})
end

--// Notification \\--
local NotificationArea
local NotifyOrder = {}
do
	NotificationArea = New("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -6, 0, 6),
		Size = UDim2.new(0, 300, 1, -6),
		Parent = ScreenGui,
	})
	table.insert(
		Library.Scales,
		New("UIScale", {
			Parent = NotificationArea,
		})
	)
end

--// Lib Functions \\--
function Library:ResetCursorIcon()
	CursorCustomImage.Visible = false
	CursorCustomImage.Size = UDim2.fromOffset(20, 20)
end

function Library:ChangeCursorIcon(ImageId: string)
	if not ImageId or ImageId == "" then
		Library:ResetCursorIcon()
		return
	end

	local Icon = Library:GetCustomIcon(ImageId)
	assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

	CursorCustomImage.Visible = true
	CursorCustomImage.Image = Icon.Url
	CursorCustomImage.ImageRectOffset = Icon.ImageRectOffset
	CursorCustomImage.ImageRectSize = Icon.ImageRectSize
end

function Library:ChangeCursorIconSize(Size: UDim2)
	assert(typeof(Size) == "UDim2", "UDim2 expected.")
	CursorCustomImage.Size = Size
end

--// SOUND ENGINE //--
function Library:PlaySound(SoundId: string | number, Volume: number?, Pitch: number?)
	task.spawn(function()
		local id = tostring(SoundId)
		if tonumber(id) then
			id = "rbxassetid://" .. id
		end
		local sound = Instance.new("Sound")
		sound.SoundId = id
		sound.Volume = Volume or 1.5
		sound.PlaybackSpeed = Pitch or 1
		sound.PlayOnRemove = true
		sound.Parent = SoundService
		sound:Destroy()
	end)
end

function Library:PlayClickSound()
	Library:PlaySound("rbxassetid://9113876339", 1.2, 1)
end

function Library:GetBetterColor(Color: Color3, Add: number): Color3
	Add = Add * (Library.IsLightTheme and -4 or 2)
	return Color3.fromRGB(
		math.clamp(Color.R * 255 + Add, 0, 255),
		math.clamp(Color.G * 255 + Add, 0, 255),
		math.clamp(Color.B * 255 + Add, 0, 255)
	)
end

function Library:GetLighterColor(Color: Color3): Color3
	local H, S, V = Color:ToHSV()
	return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
end

function Library:GetDarkerColor(Color: Color3): Color3
	local H, S, V = Color:ToHSV()
	return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
	if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
		return string.char(KeyCode.Value)
	end

	return KeyCode.Name
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
	local Params = Instance.new("GetTextBoundsParams")
	Params.Text = Text
	Params.RichText = true
	Params.Font = Font
	Params.Size = Size
	Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32

	local Bounds = TextService:GetTextBoundsAsync(Params)
	return Bounds.X, Bounds.Y
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return Mouse.X >= AbsPos.X
		and Mouse.X <= AbsPos.X + AbsSize.X
		and Mouse.Y >= AbsPos.Y
		and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:IsInsideFrame(ParentFrame: GuiObject, Frame: GuiObject)
	local GuiPos = Frame.AbsolutePosition
	local GuiSize = Frame.AbsoluteSize

	local FramePos = ParentFrame.AbsolutePosition
	local FrameSize = ParentFrame.AbsoluteSize

	return GuiPos.X >= FramePos.X
		and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
		and GuiPos.Y >= FramePos.Y
		and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
	if not (Func and typeof(Func) == "function") then
		return
	end

	local Result = table.pack(xpcall(Func, function(Error)
		task.defer(error, debug.traceback(Error, 2))
		if Library.NotifyOnError and Library.Notify then
			Library:Notify(Error)
		end

		return Error
	end, ...))

	if not Result[1] then
		return nil
	end

	return table.unpack(Result, 2, Result.n)
end

function GetOverlappingDraggable(UI: GuiObject, TargetPos: Vector2?)
	local Pos1 = TargetPos or UI.AbsolutePosition
	local Size1 = UI.AbsoluteSize

	for _, Other in ipairs(Library.DraggableElements) do
		if Other == UI or not Other.Visible or not Other.Parent then
			continue
		end

		local Pos2 = Other.AbsolutePosition
		local Size2 = Other.AbsoluteSize

		if
			Pos1.X < Pos2.X + Size2.X
			and Pos1.X + Size1.X > Pos2.X
			and Pos1.Y < Pos2.Y + Size2.Y
			and Pos1.Y + Size1.Y > Pos2.Y
		then
			return Other
		end
	end

	return nil
end

function GetNonOverlappingPosition(UI: GuiObject, StartPos: UDim2?)
	local ScreenSize = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080))
		- Vector2.new(100, 100)
	local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset) or Vector2.new(6, 6)
	local Padding = 6

	local CurrentX = Start.X
	local CurrentY = Start.Y

	local Size = UI.AbsoluteSize
	if Size.X == 0 and Size.Y == 0 then
		RunService.RenderStepped:Wait()
		Size = UI.AbsoluteSize
	end

	if Size.X == 0 then
		Size = Vector2.new(150, 40)
	end

	local MaxXInColumn = Size.X

	while true do
		local Obstacle = GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
		if not Obstacle then
			break
		end

		if Obstacle.AbsoluteSize.X > MaxXInColumn then
			MaxXInColumn = Obstacle.AbsoluteSize.X
		end

		local NextY = Obstacle.AbsolutePosition.Y + Obstacle.AbsoluteSize.Y + Padding
		if NextY + Size.Y > ScreenSize.Y - Padding then
			local NextX = CurrentX + MaxXInColumn + Padding

			if NextX + Size.X > ScreenSize.X - Padding then
				break
			end

			CurrentY = Start.Y
			CurrentX = NextX
			MaxXInColumn = Size.X
		else
			CurrentY = NextY
		end
	end

	return UDim2.fromOffset(CurrentX, CurrentY)
end

function PositionDraggable(UI: GuiObject, StartPos: UDim2?)
	UI.Position = GetNonOverlappingPosition(UI, StartPos)
end

function Library:MakeDraggable(UI: GuiObject, DragFrame: GuiObject, IgnoreToggled: boolean?, IsMainWindow: boolean?)
	local StartPos
	local FramePos
	local Dragging = false
	local Changed
	local InputBegan
	local InputChanged

	InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
		if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
			return
		end

		StartPos = Input.Position
		FramePos = UI.Position
		Dragging = true

		Changed = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end
		end)
	end)

	InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
		if
			(not IgnoreToggled and not Library.Toggled)
			or (IsMainWindow and Library.CantDragForced)
			or not (ScreenGui and ScreenGui.Parent)
		then
			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end

			return
		end

		if Dragging and IsHoverInput(Input) then
			local Delta = Input.Position - StartPos
			UI.Position =
				UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
		end
	end)

	Library:GiveSignal(InputChanged)
	Library:GiveSignal(InputBegan)

	UI.Destroying:Once(function()
		if InputChanged and InputChanged.Connected then
			InputChanged:Disconnect()
		end

		if InputBegan and InputBegan.Connected then
			InputBegan:Disconnect()
		end

		if Changed and Changed.Connected then
			Changed:Disconnect()
		end

		local IdxChanged = table.find(Library.Signals, InputChanged)
		if IdxChanged then
			table.remove(Library.Signals, IdxChanged)
		end

		local IdxBegan = table.find(Library.Signals, InputBegan)
		if IdxBegan then
			table.remove(Library.Signals, IdxBegan)
		end
	end)
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
	local StartPos
	local FrameSize
	local Dragging = false
	local Changed
	local InputBegan
	local InputChanged

	InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
		if not IsClickInput(Input) then
			return
		end

		StartPos = Input.Position
		FrameSize = UI.Size
		Dragging = true

		Changed = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end
		end)
	end)

	InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
		if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
			Dragging = false
			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end

			return
		end

		if Dragging and IsHoverInput(Input) then
			local Delta = Input.Position - StartPos
			UI.Size = UDim2.new(
				FrameSize.X.Scale,
				math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
				FrameSize.Y.Scale,
				math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
			)
			if Callback then
				Library:SafeCallback(Callback)
			end
		end
	end)

	Library:GiveSignal(InputChanged)
	Library:GiveSignal(InputBegan)

	UI.Destroying:Once(function()
		if InputChanged and InputChanged.Connected then
			InputChanged:Disconnect()
		end

		if InputBegan and InputBegan.Connected then
			InputBegan:Disconnect()
		end

		if Changed and Changed.Connected then
			Changed:Disconnect()
		end

		local IdxChanged = table.find(Library.Signals, InputChanged)
		if IdxChanged then
			table.remove(Library.Signals, IdxChanged)
		end

		local IdxBegan = table.find(Library.Signals, InputBegan)
		if IdxBegan then
			table.remove(Library.Signals, IdxBegan)
		end
	end)
end

function Library:MakeCover(Holder: GuiObject, Place: string)
	local Pos = Places[Place] or { 0, 0 }
	local Size = Sizes[Place] or { 1, 0.5 }

	local Cover = New("Frame", {
		AnchorPoint = Vector2.new(Pos[1], Pos[2]),
		BackgroundColor3 = Holder.BackgroundColor3,
		Position = UDim2.fromScale(Pos[1], Pos[2]),
		Size = UDim2.fromScale(Size[1], Size[2]),
		Parent = Holder,
	})

	return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
	local Line = New("Frame", {
		AnchorPoint = Info.AnchorPoint or Vector2.zero,
		BackgroundColor3 = "OutlineColor",
		Position = Info.Position,
		Size = Info.Size,
		ZIndex = Info.ZIndex or Frame.ZIndex,
		Parent = Frame,
	})

	return Line
end

function Library:AddOutline(Frame: GuiObject)
	local OutlineStroke = New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1,
		ZIndex = 2,
		Parent = Frame,
	})
	local ShadowStroke = New("UIStroke", {
		Color = "DarkColor",
		Thickness = 1.5,
		ZIndex = 1,
		Parent = Frame,
	})
	return OutlineStroke, ShadowStroke
end

function Library:AddBlank(Frame: GuiObject, Size: UDim2)
	return New("Frame", {
		BackgroundTransparency = 1,
		Size = Size or UDim2.fromScale(0, 0),
		Parent = Frame,
	})
end

--// Animations \\--
local TransparencyCache = {}
local FadeTweenCache = setmetatable({}, { __mode = "k" })
local FadeGuiProperties = { "BackgroundTransparency" }
local FadeImageProperties = { "BackgroundTransparency", "ImageTransparency" }
local FadeTextProperties = { "BackgroundTransparency", "TextTransparency" }
local FadeStrokeProperties = { "Transparency" }
local FadeScrollProperties = { "BackgroundTransparency", "ScrollBarImageTransparency" }

function Library:FadeInstance(Desc, Properties, Opening, CanCapture)
	local Cache = TransparencyCache[Desc]
	if not Cache then
		Cache = {}
		TransparencyCache[Desc] = Cache
	end

	local Info = Library.WindowAnimationInfo
	local Goals = {}
	local Sig = Info.Time .. "|" .. Info.EasingStyle.Name .. "|" .. Info.EasingDirection.Name .. "|"

	for _, Prop in Properties do
		local Rest = Cache[Prop]

		if Rest == nil then
			Rest = Desc[Prop]
			Cache[Prop] = Rest
			if Opening and Rest ~= 1 then
				Desc[Prop] = 1
			end
		elseif not Opening and CanCapture then
			Rest = Desc[Prop]
			Cache[Prop] = Rest
		end

		if Rest ~= nil and Rest ~= 1 then
			local Target = if Opening then Rest else 1
			Goals[Prop] = Target
			Sig ..= Prop .. "=" .. Target .. ";"
		end
	end

	if next(Goals) == nil then
		return
	end

	local Dir = if Opening then "in" else "out"
	local Tweens = FadeTweenCache[Desc]
	if not Tweens then
		Tweens = {}
		FadeTweenCache[Desc] = Tweens
	end

	if Tweens[Dir] == nil or Tweens[Dir .. "Sig"] ~= Sig then
		Tweens[Dir] = TweenService:Create(Desc, Info, Goals)
		Tweens[Dir .. "Sig"] = Sig
	end
	Tweens[Dir]:Play()
end

function Library:FadeTree(Root, Opening, CanCapture, Skip)
	local Queue = { Root }
	for _, Desc in ipairs(Root:GetDescendants()) do
		table.insert(Queue, Desc)
	end

	for _, Instance in Queue do
		if Instance == Skip then
			continue
		end

		if Instance:IsA("GuiObject") then
			local ClassName = Instance.ClassName
			if ClassName == "ImageLabel" or ClassName == "ImageButton" then
				Library:FadeInstance(Instance, FadeImageProperties, Opening, CanCapture)
			elseif ClassName == "TextLabel" or ClassName == "TextBox" or ClassName == "TextButton" then
				Library:FadeInstance(Instance, FadeTextProperties, Opening, CanCapture)
			elseif ClassName == "ScrollingFrame" then
				Library:FadeInstance(Instance, FadeScrollProperties, Opening, CanCapture)
			else
				Library:FadeInstance(Instance, FadeGuiProperties, Opening, CanCapture)
			end
		elseif Instance.ClassName == "UIStroke" then
			Library:FadeInstance(Instance, FadeStrokeProperties, Opening, CanCapture)
		end
	end
end
local ActiveTabTweens = setmetatable({}, { __mode = "k" })

function Library:PlayTabAnimation(TabCanvas: CanvasGroup, Showing: boolean, OnComplete: (() -> ())?)
	if not TabCanvas then
		if OnComplete then
			OnComplete()
		end

		return
	end

	local Existing = ActiveTabTweens[TabCanvas]
	if Existing then
		StopTween(Existing, true)
		ActiveTabTweens[TabCanvas] = nil
	end

	local BaseZIndex = TabCanvas.ZIndex
	if not (Library.Animations and Library.Animations.TabSwitch) then
		TabCanvas.Visible = Showing
		TabCanvas.GroupTransparency = Showing and 0 or 1
		TabCanvas.Position = UDim2.fromScale(0, 0)
		TabCanvas.ZIndex = BaseZIndex

		if OnComplete then
			OnComplete()
		end

		return
	end

	if Showing then
		local TweenInfo = Library.TabTransitionInfo
			or TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local Offset = Library.TabSwipeOffset or 26
		local SwipeFrom = string.lower(Library.TabSwipeFrom or "bottom")
		local StartPosition

		if SwipeFrom == "left" then
			StartPosition = UDim2.fromOffset(-Offset, 0)
		elseif SwipeFrom == "top" then
			StartPosition = UDim2.fromOffset(0, -Offset)
		elseif SwipeFrom == "right" then
			StartPosition = UDim2.fromOffset(Offset, 0)
		else -- bottom (Default)
			StartPosition = UDim2.fromOffset(0, Offset)
		end

		TabCanvas.ZIndex = BaseZIndex + 1
		TabCanvas.GroupTransparency = 1
		TabCanvas.Position = StartPosition
		TabCanvas.Visible = true

		local Tween = TweenService:Create(TabCanvas, TweenInfo, {
			GroupTransparency = 0,
			Position = UDim2.fromScale(0, 0),
		})

		ActiveTabTweens[TabCanvas] = Tween
		Tween:Play()

		local Connection
		Connection = Tween.Completed:Connect(function(PlaybackState)
			if Connection then
				Connection:Disconnect()
			end

			if ActiveTabTweens[TabCanvas] == Tween then
				ActiveTabTweens[TabCanvas] = nil
			end

			if PlaybackState == Enum.PlaybackState.Cancelled then
				return
			end

			TabCanvas.ZIndex = BaseZIndex
			if OnComplete then
				OnComplete()
			end
		end)
	else
		TabCanvas.GroupTransparency = 1
		TabCanvas.Visible = false
		TabCanvas.Position = UDim2.fromScale(0, 0)
		TabCanvas.ZIndex = BaseZIndex

		if OnComplete then
			OnComplete()
		end
	end
end

--// Deprecated \\--
function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
	warn("Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.")
	local Holder = New("Frame", {
		BackgroundColor3 = "DarkColor",
		Position = UDim2.fromOffset(-2, -2),
		Size = UDim2.new(1, 4, 1, 4),
		ZIndex = ZIndex,
		Parent = Frame,
	})

	local Outline = New("Frame", {
		BackgroundColor3 = "OutlineColor",
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(1, -2, 1, -2),
		ZIndex = ZIndex,
		Parent = Holder,
	})

	if Corner and Corner > 0 then
		New("UICorner", {
			CornerRadius = UDim.new(0, Corner + 1),
			Parent = Holder,
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, Corner),
			Parent = Outline,
		})
	end

	return Holder, Outline
end

function Library:AddDraggableLabel(...)
	local Params = select(1, ...)
	local Text
	local Icon
	local IconPosition = "left"

	if typeof(Params) == "table" then
		Text = Params.Text
		Icon = Params.Icon
		IconPosition = Params.IconPosition or "left"
	elseif typeof(Params) == "string" then
		Text = Params
		Icon = select(2, ...)
		IconPosition = select(3, ...) or "left"
	end

	if typeof(IconPosition) ~= "string" then
		IconPosition = "left"
	end

	IconPosition = string.lower(IconPosition)
	assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

	local DraggableLabel = {
		Connections = {},
		Destroyed = false,
	}

	local IconImage
	local Label = New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = "BackgroundColor",
		Size = UDim2.fromOffset(0, 0),
		Position = UDim2.fromOffset(6, 6),
		Text = Text,
		TextSize = 15,
		ZIndex = 10,
		Parent = ScreenGui,
	})

	table.insert(
		Library.Corners,
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Label,
		})
	)

	local Padding = New("UIPadding", {
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		PaddingTop = UDim.new(0, 6),
		Parent = Label,
	})
	table.insert(
		Library.Scales,
		New("UIScale", {
			Parent = Label,
		})
	)

	Library:AddOutline(Label)
	Library:MakeDraggable(Label, Label, true)

	function DraggableLabel:SetText(Text: string)
		Label.Text = Text
	end

	function DraggableLabel:SetIcon(NewIcon: string)
		Icon = NewIcon

		local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
		if IsNotEmpty then
			local CustomIcon = Library:GetCustomIcon(Icon)
			assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

			IconImage = IconImage
				or New("ImageLabel", {
					BackgroundTransparency = 1,
					ImageColor3 = "FontColor",
					Size = UDim2.fromOffset(16, 16),
					ZIndex = 11,
					Parent = Label,
				})

			IconImage.Image = CustomIcon.Url
			IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
			IconImage.ImageRectSize = CustomIcon.ImageRectSize
		end

		if IconImage then
			IconImage.Visible = IsNotEmpty
		end
		DraggableLabel:SetIconPosition(IconPosition)
	end

	function DraggableLabel:SetIconPosition(NewPosition: string)
		IconPosition = string.lower(NewPosition)
		assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

		local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
		Padding.PaddingLeft = UDim.new(0, (IsNotEmpty and IconPosition == "left") and 34 or 12)
		Padding.PaddingRight = UDim.new(0, (IsNotEmpty and IconPosition == "right") and 34 or 12)

		if IconImage then
			if IconPosition == "left" then
				IconImage.AnchorPoint = Vector2.new(0, 0.5)
				IconImage.Position = UDim2.new(0, -22, 0.5, 0)
			else
				IconImage.AnchorPoint = Vector2.new(1, 0.5)
				IconImage.Position = UDim2.new(1, 22, 0.5, 0)
			end
		end
	end

	function DraggableLabel:SetVisible(Visible: boolean)
		Label.Visible = Visible
	end

	DraggableLabel:SetIcon(Icon)
	DraggableLabel.Label = Label

	if not table.find(Library.DraggableElements, Label) then
		table.insert(Library.DraggableElements, Label)
	end

	PositionDraggable(Label, Label.Position)

	function DraggableLabel:Destroy()
		DraggableLabel.Destroyed = true

		if DraggableLabel.Connections then
			for _, connection in DraggableLabel.Connections do
				connection:Disconnect()
			end
		end

		local ElemIdx = table.find(Library.DraggableElements, Label)
		if ElemIdx then
			table.remove(Library.DraggableElements, ElemIdx)
		end

		if Label then
			Label:Destroy()
		end
	end

	return DraggableLabel
end

function Library:AddDraggableButton(...)
	local Params = select(1, ...)

	local Text
	local Func
	local ExcludeScaling
	local ExcludeDragging

	if typeof(Params) == "table" then
		Text = Params.Text
		Func = Params.Callback or Params.Func
		ExcludeScaling = Params.ExcludeScaling
		ExcludeDragging = Params.ExcludeDragging
	elseif typeof(Params) == "string" then
		Text = Params
		Func = select(2, ...)
		ExcludeScaling = select(3, ...)
		ExcludeDragging = select(4, ...)
	end

	local DraggableButton = {
		Connections = {},
		Destroyed = false,
	}

	local Button = New("TextButton", {
		BackgroundColor3 = "BackgroundColor",
		Position = UDim2.fromOffset(6, 6),
		TextSize = 16,
		ZIndex = 10,
		Parent = ScreenGui,
	})
	table.insert(
		Library.Corners,
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Button,
		})
	)
	if not ExcludeScaling then
		table.insert(
			Library.Scales,
			New("UIScale", {
				Parent = Button,
			})
		)
	end
	Library:AddOutline(Button)

	local DragThreshold = if ExcludeDragging then 0.25 else math.huge
	Button.InputBegan:Connect(function(Input: InputObject)
		if not IsClickInput(Input) then
			return
		end

		local Start = tick()

		local Changed
		Changed = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			local IsLikelyDragging = tick() - Start > DragThreshold
			if IsLikelyDragging then
				return
			end

			Library:SafeCallback(Func, DraggableButton)

			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end
		end)
	end)

	function DraggableButton:SetText(Text: string)
		local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

		Button.Text = Text
		Button.Size = UDim2.fromOffset(X * 2, Y * 2)
	end

	Library:MakeDraggable(Button, Button, true)
	DraggableButton:SetText(Text)
	DraggableButton.Button = Button

	if not table.find(Library.DraggableElements, Button) then
		table.insert(Library.DraggableElements, Button)
	end

	PositionDraggable(Button, Button.Position)

	function DraggableButton:Destroy()
		DraggableButton.Destroyed = true

		if DraggableButton.Connections then
			for _, connection in DraggableButton.Connections do
				connection:Disconnect()
			end
		end

		local ElemIdx = table.find(Library.DraggableElements, Button)
		if ElemIdx then
			table.remove(Library.DraggableElements, ElemIdx)
		end

		if Button then
			Button:Destroy()
		end
	end

	return DraggableButton
end

function Library:AddDraggableMenu(Name: string)
	local Holder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = "BackgroundColor",
		Position = UDim2.fromOffset(6, 6),
		Size = UDim2.fromOffset(0, 0),
		ZIndex = 10,
		Parent = ScreenGui,
	})
	table.insert(
		Library.Corners,
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Holder,
		})
	)
	table.insert(
		Library.Scales,
		New("UIScale", {
			Parent = Holder,
		})
	)
	Library:AddOutline(Holder)

	Library:MakeLine(Holder, {
		Position = UDim2.fromOffset(0, 34),
		Size = UDim2.new(1, 0, 0, 1),
	})

	local Label = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34),
		Text = Name,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Holder,
	})
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		Parent = Label,
	})

	local Container = New("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 35),
		Size = UDim2.new(1, 0, 1, -35),
		Parent = Holder,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 7),
		Parent = Container,
	})
	New("UIPadding", {
		PaddingBottom = UDim.new(0, 7),
		PaddingLeft = UDim.new(0, 7),
		PaddingRight = UDim.new(0, 7),
		PaddingTop = UDim.new(0, 7),
		Parent = Container,
	})

	Library:MakeDraggable(Holder, Label, true)

	if not table.find(Library.DraggableElements, Holder) then
		table.insert(Library.DraggableElements, Holder)
	end

	PositionDraggable(Holder, Holder.Position)

	local Menu = setmetatable({
		Holder = Holder,
		Container = Container,
		Elements = {},
		Destroyed = false,
		Type = "DraggableMenu",
	}, Library.__GroupboxClass or {})

	function Menu:Resize()
		local Widest = 170
		for _, Desc in ipairs(Container:GetDescendants()) do
			if (Desc:IsA("TextLabel") or Desc:IsA("TextButton")) and Desc.Text ~= "" then
				local Measured = TextService:GetTextSize(Desc.Text, Desc.TextSize, Desc.Font, Vector2.new(10000, 10000))
				local Slack = 32
				if Desc:IsA("TextLabel") and Desc.TextXAlignment == Enum.TextXAlignment.Left then
					Slack = 76
				end
				Widest = math.max(Widest, Measured.X + Slack)
			end
		end
		Holder.Size = UDim2.fromOffset(math.min(340, math.ceil(Widest)), Holder.Size.Y.Offset)
	end

	function Menu:Destroy()
		Menu.Destroyed = true
		Holder:Destroy()
	end

	return Holder, Container, Menu
end

function Library:AddDraggableImageButton(...)
	local Params = select(1, ...)

	local Icon
	local IconSize
	local Func
	local ExcludeScaling
	local ExcludeDragging

	if typeof(Params) == "table" then
		Icon = Params.Icon
		IconSize = Params.IconSize or 24
		Func = Params.Callback or Params.Func
		ExcludeScaling = Params.ExcludeScaling
		ExcludeDragging = Params.ExcludeDragging
	elseif typeof(Params) == "string" or typeof(Params) == "number" then
		Icon = Params
		IconSize = select(2, ...)
		Func = select(3, ...)
		ExcludeScaling = select(4, ...)
		ExcludeDragging = select(5, ...)
	end

	local DraggableImageButton = {}

	local Button = New("TextButton", {
		BackgroundColor3 = "BackgroundColor",
		Position = UDim2.fromOffset(6, 6),
		Size = UDim2.fromOffset(IconSize + 12, IconSize + 12),
		Text = "",
		ZIndex = 10,
		Parent = ScreenGui,
	})

	local IconImage = New("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(IconSize, IconSize),
		ImageColor3 = "FontColor",
		ZIndex = 11,
		Parent = Button,
	})

	table.insert(
		Library.Corners,
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Button,
		})
	)
	if not ExcludeScaling then
		table.insert(
			Library.Scales,
			New("UIScale", {
				Parent = Button,
			})
		)
	end
	Library:AddOutline(Button)

	local DragThreshold = if ExcludeDragging then 0.25 else math.huge
	Button.InputBegan:Connect(function(Input: InputObject)
		if not IsClickInput(Input) then
			return
		end

		local Start = tick()

		local Changed
		Changed = Input.Changed:Connect(function()
			if Input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			local IsLikelyDragging = tick() - Start > DragThreshold
			if IsLikelyDragging then
				return
			end

			Library:SafeCallback(Func, DraggableImageButton)

			if Changed and Changed.Connected then
				Changed:Disconnect()
				Changed = nil
			end
		end)
	end)

	function DraggableImageButton:SetIcon(NewIcon: string)
		Icon = NewIcon or Icon

		local CustomIcon = Library:GetCustomIcon(Icon)
		assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

		IconImage.Image = CustomIcon.Url
		IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
		IconImage.ImageRectSize = CustomIcon.ImageRectSize
	end

	function DraggableImageButton:SetIconSize(NewSize: number)
		IconSize = NewSize
		IconImage.Size = UDim2.fromOffset(IconSize, IconSize)
		Button.Size = UDim2.fromOffset(IconSize + 12, IconSize + 12)
	end

	Library:MakeDraggable(Button, Button, true)
	DraggableImageButton:SetIcon(Icon)
	DraggableImageButton.Button = Button

	if not table.find(Library.DraggableElements, Button) then
		table.insert(Library.DraggableElements, Button)
	end

	PositionDraggable(Button, Button.Position)

	return DraggableImageButton
end

--// Watermark - Deprecated \\--
do
	local WatermarkLabel = Library:AddDraggableLabel("")
	WatermarkLabel:SetVisible(false)

	function Library:SetWatermark(Text: string)
		warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
		WatermarkLabel:SetText(Text)
	end

	function Library:SetWatermarkVisibility(Visible: boolean)
		warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
		WatermarkLabel:SetVisible(Visible)
	end
end

--// Context Menu \\--
local CurrentMenu
function Library:AddContextMenu(
	Holder: GuiObject,
	Size: UDim2 | () -> (),
	Offset: { [number]: number } | () -> {},
	List: number?,
	ActiveCallback: (Active: boolean) -> ()?,
	IgnoreCornerRadius: boolean?,
	SpecificCornersOnly: ("top" | "bottom" | "no_left" | "no_top_left")?, -- stupid way of doing this
	AnimationType: ("Dropdown" | "KeyPicker" | "none")?
)
	local Menu
	local ParentGui = Holder:FindFirstAncestorOfClass("ScreenGui")
	local MenuZIndex = math.max(10, Holder.ZIndex + 1)
	if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
		ParentGui = ScreenGui
	end

	if List then
		Menu = New("ScrollingFrame", {
			AutomaticCanvasSize = List == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
			AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
			BackgroundColor3 = "BackgroundColor",
			BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollBarImageColor3 = "OutlineColor",
			ScrollBarThickness = List == 2 and 2 or 0,
			Size = typeof(Size) == "function" and Size() or Size,
			TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			Visible = false,
			ZIndex = MenuZIndex,
			Parent = ParentGui,
		})
	else
		Menu = New("Frame", {
			BackgroundColor3 = "BackgroundColor",
			Size = typeof(Size) == "function" and Size() or Size,
			Visible = false,
			ZIndex = MenuZIndex,
			Parent = ParentGui,
		})
	end
	table.insert(
		Library.Scales,
		New("UIScale", {
			Parent = Menu,
		})
	)

	New("UIStroke", {
		Color = "OutlineColor",
		Parent = Menu,
	})

	local Corner
	if IgnoreCornerRadius ~= true then
		if SpecificCornersOnly == "top" then
			Corner = New("UICorner", {
				TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
				TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
				BottomRightRadius = UDim.new(0, 0),
				BottomLeftRadius = UDim.new(0, 0),
				Parent = Menu,
			})
			table.insert(Library.SpecificCorners, Corner)
		elseif SpecificCornersOnly == "bottom" then
			Corner = New("UICorner", {
				TopLeftRadius = UDim.new(0, 0),
				TopRightRadius = UDim.new(0, 0),
				BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
				BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = Menu,
			})
			table.insert(Library.SpecificCorners, Corner)
		elseif SpecificCornersOnly == "no_left" then
			Corner = New("UICorner", {
				TopLeftRadius = UDim.new(0, 0),
				TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
				BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
				BottomLeftRadius = UDim.new(0, 0),
				Parent = Menu,
			})
			table.insert(Library.SpecificCorners, Corner)
		elseif SpecificCornersOnly == "no_top_left" then
			Corner = New("UICorner", {
				TopLeftRadius = UDim.new(0, 0),
				TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
				BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
				BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = Menu,
			})
			table.insert(Library.SpecificCorners, Corner)
		else
			Corner = New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = Menu,
			})
			table.insert(Library.Corners, Corner)
		end
	end

	local Table = {
		Connections = {},
		Destroyed = false,

		Active = false,
		Holder = Holder,
		Menu = Menu,
		List = nil,
		Signal = nil,

		Size = Size,

		AutoSizeY = List == 1,
		OpenCloseTween = nil,
		Animated = function()
			if not AnimationType or AnimationType == "none" then
				return false
			end

			if not (Library.Animations and Library.Animations[AnimationType] == true) then
				return false
			end

			return true,
				Library[string.format("%sTransitionInfo", AnimationType)] or TweenInfo.new(
					0.18,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.Out
				)
		end,
	}

	if List then
		Table.List = New("UIListLayout", {
			Parent = Menu,
		})
	end

	function Table:Open()
		if CurrentMenu == Table then
			return
		elseif CurrentMenu then
			CurrentMenu:Close()
		end

		CurrentMenu = Table
		Table.Active = true

		if typeof(Offset) == "function" then
			Menu.Position = UDim2.fromOffset(
				math.floor(Holder.AbsolutePosition.X + Offset()[1]),
				math.floor(Holder.AbsolutePosition.Y + Offset()[2])
			)
		else
			Menu.Position = UDim2.fromOffset(
				math.floor(Holder.AbsolutePosition.X + Offset[1]),
				math.floor(Holder.AbsolutePosition.Y + Offset[2])
			)
		end

		local TargetSize = typeof(Table.Size) == "function" and Table.Size() or Table.Size

		if typeof(ActiveCallback) == "function" then
			Library:SafeCallback(ActiveCallback, true)
		end

		if Table.OpenCloseTween then
			StopTween(Table.OpenCloseTween, true)
			Table.OpenCloseTween = nil
		end

		local IsAnimated, TweenInfo = Table.Animated()
		if IsAnimated == true then
			local OpenSize = TargetSize
			if Table.AutoSizeY then
				local FullHeight = Menu.AbsoluteSize.Y

				Menu.AutomaticSize = Enum.AutomaticSize.None
				OpenSize = UDim2.new(TargetSize.X.Scale, TargetSize.X.Offset, 0, FullHeight)
			end

			Menu.Size = UDim2.new(OpenSize.X.Scale, OpenSize.X.Offset, 0, 0)
			Menu.Visible = true

			local Tween = TweenService:Create(Menu, TweenInfo, { Size = OpenSize })
			Table.OpenCloseTween = Tween

			local Connection
			Connection = Library:GiveSignal(Tween.Completed:Once(function()
				if Connection then
					Connection:Disconnect()
				end

				if Table.OpenCloseTween == Tween then
					StopTween(Table.OpenCloseTween, true)
					Table.OpenCloseTween = nil

					if Table.AutoSizeY then
						Menu.AutomaticSize = Enum.AutomaticSize.Y
					end
				end
			end))

			Tween:Play()
		else
			Menu.Size = TargetSize
			Menu.Visible = true
		end

		Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if typeof(Offset) == "function" then
				Menu.Position = UDim2.fromOffset(
					math.floor(Holder.AbsolutePosition.X + Offset()[1]),
					math.floor(Holder.AbsolutePosition.Y + Offset()[2])
				)
			else
				Menu.Position = UDim2.fromOffset(
					math.floor(Holder.AbsolutePosition.X + Offset[1]),
					math.floor(Holder.AbsolutePosition.Y + Offset[2])
				)
			end

			if not Library:IsInsideFrame(Library.WindowContainer, Holder) and Table.Active then
				Table:Close()
			end
		end)
	end

	function Table:Close()
		if CurrentMenu ~= Table then
			return
		end

		if Table.Signal then
			Table.Signal:Disconnect()
			Table.Signal = nil
		end

		Table.Active = false
		CurrentMenu = nil

		if typeof(ActiveCallback) == "function" then
			Library:SafeCallback(ActiveCallback, false)
		end

		if Table.OpenCloseTween then
			StopTween(Table.OpenCloseTween, true)
			Table.OpenCloseTween = nil
		end

		local IsAnimated, TweenInfo = Table.Animated()
		if IsAnimated == true then
			if Table.AutoSizeY then
				Menu.AutomaticSize = Enum.AutomaticSize.None
			end

			local CurrentSize = Menu.Size
			local CollapsedSize = UDim2.new(CurrentSize.X.Scale, CurrentSize.X.Offset, 0, 0)

			local Tween = TweenService:Create(Menu, TweenInfo, { Size = CollapsedSize })
			Table.OpenCloseTween = Tween

			local Connection
			Connection = Library:GiveSignal(Tween.Completed:Once(function(PlaybackState)
				if Connection then
					Connection:Disconnect()
				end

				if Table.OpenCloseTween == Tween then
					StopTween(Table.OpenCloseTween, true)
					Table.OpenCloseTween = nil

					Menu.Visible = false
					if Table.AutoSizeY then
						Menu.AutomaticSize = Enum.AutomaticSize.Y
					end
				end
			end))

			Tween:Play()
		else
			Menu.Visible = false
		end
	end

	function Table:Toggle()
		if Table.Active then
			Table:Close()
		else
			Table:Open()
		end
	end

	function Table:SetSize(Size)
		Table.Size = Size
		Menu.Size = typeof(Size) == "function" and Size() or Size
	end

	function Table:Destroy()
		Table.Destroyed = true

		if Table.Connections then
			for _, Connection in Table.Connections do
				Connection:Disconnect()
			end
		end

		if CurrentMenu == Table then
			Table:Close()
		end

		if Table.OpenCloseTween then
			StopTween(Table.OpenCloseTween, true)
			Table.OpenCloseTween = nil
		end

		if Menu then
			Menu:Destroy()
		end
	end

	return Table
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
	if Library.Unloaded then
		return
	end

	if IsClickInput(Input, true) then
		local Location = Input.Position

		if
			CurrentMenu
			and not (
				Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
				or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
			)
		then
			CurrentMenu:Close()
		end
	end
end))

--// Tooltip \\--
local TooltipLabel = New("TextLabel", {
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = "BackgroundColor",
	TextSize = 14,
	TextWrapped = true,
	Visible = false,
	ZIndex = 20,
	Parent = ScreenGui,
})
New("UIPadding", {
	PaddingBottom = UDim.new(0, 2),
	PaddingLeft = UDim.new(0, 4),
	PaddingRight = UDim.new(0, 4),
	PaddingTop = UDim.new(0, 2),
	Parent = TooltipLabel,
})
table.insert(
	Library.Scales,
	New("UIScale", {
		Parent = TooltipLabel,
	})
)
New("UIStroke", {
	Color = "OutlineColor",
	Parent = TooltipLabel,
})
table.insert(
	Library.Corners,
	New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius / 2),
		Parent = TooltipLabel,
	})
)
TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	if Library.Unloaded then
		return
	end

	local X, _ = Library:GetTextBounds(
		TooltipLabel.Text,
		TooltipLabel.FontFace,
		TooltipLabel.TextSize,
		(workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8) / Library.DPIScale
	)

	TooltipLabel.Size = UDim2.fromOffset(X + 8, 0)
end)

local CurrentHoverInstance
function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
	local TooltipTable = {
		Disabled = false,
		Hovering = false,
		Signals = {},
	}

	local function DoHover()
		if
			CurrentHoverInstance == HoverInstance
			or Library.ActiveDialog
			or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
			or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
			or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
		then
			return
		end
		CurrentHoverInstance = HoverInstance

		local ParentGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
		if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
			ParentGui = ScreenGui
		end
		TooltipLabel.Parent = ParentGui

		TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
		TooltipLabel.Visible = true

		while
			(Library.Toggled or Library.ActiveLoading)
			and not Library.ActiveDialog
			and Library:MouseIsOverFrame(HoverInstance, Mouse)
			and not (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
		do
			TooltipLabel.Position = UDim2.fromOffset(
				Mouse.X + (Library.ShowCustomCursor and 8 or 14),
				Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
			)

			RunService.RenderStepped:Wait()
		end

		TooltipLabel.Visible = false
		CurrentHoverInstance = nil
	end

	local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
		local ConnectionType = typeof(Connection)
		if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
			table.insert(TooltipTable.Signals, Connection)
		end

		return Connection
	end

	GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
	GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
	GiveSignal(HoverInstance.MouseLeave:Connect(function()
		if CurrentHoverInstance ~= HoverInstance then
			return
		end

		TooltipLabel.Visible = false
		CurrentHoverInstance = nil
	end))

	function TooltipTable:Destroy()
		for Index = #TooltipTable.Signals, 1, -1 do
			local Connection = table.remove(TooltipTable.Signals, Index)
			if Connection and Connection.Connected then
				Connection:Disconnect()
			end
		end

		if CurrentHoverInstance == HoverInstance then
			if TooltipLabel then
				TooltipLabel.Visible = false
			end

			CurrentHoverInstance = nil
		end
	end

	table.insert(Tooltips, TooltipLabel)
	return TooltipTable
end

function Library:OnUnload(Callback)
	table.insert(Library.UnloadSignals, Callback)
end

local CheckIcon = Library:GetIcon("check")
local SelectedCheckColor = Color3.fromRGB(86, 197, 110)
local ArrowIcon = Library:GetIcon("chevron-up")
local ResizeIcon = Library:GetIcon("move-diagonal-2")
local KeyIcon = Library:GetIcon("key")
local MoveIcon = Library:GetIcon("move")

function Library:SetIconModule(module: IconModule)
	FetchIcons = true
	Icons = module

	-- Top ten fixes 🚀
	CheckIcon = Library:GetIcon("check")
	ArrowIcon = Library:GetIcon("chevron-up")
	ResizeIcon = Library:GetIcon("move-diagonal-2")
	KeyIcon = Library:GetIcon("key")
	MoveIcon = Library:GetIcon("move")
end

local BaseAddons = {}
do
	local Funcs = {}

	function Funcs:AddKeyPicker(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.KeyPicker)

		local ParentObj = self
		local ToggleLabel = ParentObj.TextLabel

		if ParentObj.Type == "Button" or ParentObj.Type == "SubButton" then
			assert(Info.Mode == "Press", "KeyPicker on Buttons can only be applied with the 'Press' mode.")

			ToggleLabel = ParentObj.Base
		end

		local KeyPicker = {
			Connections = {},

			Text = Info.Text,
			Value = Info.Default, -- Key
			Modifiers = Info.DefaultModifiers, -- Modifiers
			DisplayValue = Info.Default, -- Picker Text

			Blacklisted = Info.Blacklisted,
			BlacklistedModifiers = Info.BlacklistedModifiers,
			Whitelisted = Info.Whitelisted,
			WhitelistedModifiers = Info.WhitelistedModifiers,

			Toggled = false,
			Mode = Info.Mode,
			SyncToggleState = Info.SyncToggleState,

			Callback = Info.Callback,
			ChangedCallback = Info.ChangedCallback,
			Changed = Info.Changed,
			Clicked = Info.Clicked,

			Type = "KeyPicker",
		}

		if KeyPicker.Mode == "Press" then
			assert(
				ParentObj.Type == "Label" or ParentObj.Type == "Button" or ParentObj.Type == "SubButton",
				"KeyPicker with the mode 'Press' can be only applied on Labels and Buttons."
			)

			KeyPicker.SyncToggleState = false
			Info.Modes = { "Press" }
			Info.Mode = "Press"
		end

		if KeyPicker.SyncToggleState then
			Info.Modes = { "Toggle", "Hold" }

			if not table.find(Info.Modes, Info.Mode) then
				Info.Mode = "Toggle"
			end
		end

		local Picking = false
		local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"

		-- Special Keys
		local SpecialKeys = {
			["MB1"] = Enum.UserInputType.MouseButton1,
			["MB2"] = Enum.UserInputType.MouseButton2,
			["MB3"] = Enum.UserInputType.MouseButton3,
		}

		local SpecialKeysInput = {
			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3",
		}

		-- Modifiers
		local Modifiers = {
			["LAlt"] = Enum.KeyCode.LeftAlt,
			["RAlt"] = Enum.KeyCode.RightAlt,

			["LCtrl"] = Enum.KeyCode.LeftControl,
			["RCtrl"] = Enum.KeyCode.RightControl,

			["LShift"] = Enum.KeyCode.LeftShift,
			["RShift"] = Enum.KeyCode.RightShift,

			["Tab"] = Enum.KeyCode.Tab,
			["CapsLock"] = Enum.KeyCode.CapsLock,
		}

		local ModifiersInput = {
			[Enum.KeyCode.LeftAlt] = "LAlt",
			[Enum.KeyCode.RightAlt] = "RAlt",

			[Enum.KeyCode.LeftControl] = "LCtrl",
			[Enum.KeyCode.RightControl] = "RCtrl",

			[Enum.KeyCode.LeftShift] = "LShift",
			[Enum.KeyCode.RightShift] = "RShift",

			[Enum.KeyCode.Tab] = "Tab",
			[Enum.KeyCode.CapsLock] = "CapsLock",
		}

		local IsModifierInput = function(Input)
			return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
		end

		local GetActiveModifiers = function()
			local ActiveModifiers = {}

			for Name, Input in Modifiers do
				if table.find(ActiveModifiers, Name) then
					continue
				end
				if not UserInputService:IsKeyDown(Input) then
					continue
				end

				table.insert(ActiveModifiers, Name)
			end

			return ActiveModifiers
		end

		local AreModifiersHeld = function(Required)
			if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
				return true
			end

			local ActiveModifiers = GetActiveModifiers()
			local Holding = true

			for _, Name in Required do
				if table.find(ActiveModifiers, Name) then
					continue
				end

				Holding = false
				break
			end

			return Holding
		end

		local IsInputDown = function(Input)
			if not Input then
				return false
			end

			if SpecialKeysInput[Input.UserInputType] ~= nil then
				return UserInputService:IsMouseButtonPressed(Input.UserInputType)
					and not UserInputService:GetFocusedTextBox()
			elseif Input.UserInputType == Enum.UserInputType.Keyboard then
				return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox()
			else
				return false
			end
		end

		local ConvertToInputModifiers = function(CurrentModifiers)
			local InputModifiers = {}

			for _, name in CurrentModifiers do
				table.insert(InputModifiers, Modifiers[name])
			end

			return InputModifiers
		end

		local VerifyModifiers = function(CurrentModifiers)
			if typeof(CurrentModifiers) ~= "table" then
				return {}
			end

			local ValidModifiers = {}

			for _, name in CurrentModifiers do
				if not Modifiers[name] then
					continue
				end

				table.insert(ValidModifiers, name)
			end

			return ValidModifiers
		end

		KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

		local SlideOverflow = true
		local MaxPickerWidth = 75
		local SlidingLabel

		local LastPickerWidth = 0
		local SlideForwardTween
		local SlideBackTween
		local HandleForwardTween = function(State)
			if State ~= Enum.PlaybackState.Completed then
				return
			end

			task.wait(1.5)
			if SlideBackTween then
				SlideBackTween:Play()
			end
		end

		local HandleBackTween = function(State)
			if State ~= Enum.PlaybackState.Completed then
				return
			end

			task.wait(1.5)
			if SlideForwardTween then
				SlideForwardTween:Play()
			end
		end

		local CancelSlidingTweens = function()
			if SlideForwardTween then
				StopTween(SlideForwardTween, true)
				SlideForwardTween = nil
			end

			if SlideBackTween then
				SlideForwardTween(SlideBackTween, true)
				SlideBackTween = nil
			end
		end

		local Picker = New("TextButton", {
			BackgroundColor3 = "MainColor",
			Size = UDim2.fromOffset(18, 18),
			Text = (IsForButton and SlideOverflow) and "" or KeyPicker.Value,
			TextSize = 14,
			Parent = ToggleLabel,
		})

		if IsForButton and SlideOverflow then
			Picker.ClipsDescendants = true

			SlidingLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = KeyPicker.Value,
				TextSize = 14,
				FontFace = Picker.FontFace,
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = Picker,
			})

			Library:AddToRegistry(SlidingLabel, {
				TextColor3 = "FontColor",
			})
		end

		New("UIStroke", {
			Color = "OutlineColor",
			Parent = Picker,
		})

		local PickerCorner = New("UICorner", {
			TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = Picker,
		})
		table.insert(Library.SpecificCorners, PickerCorner)

		if IsForButton then
			local Holder = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 21),
				Parent = ToggleLabel.Parent,
			})

			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = UDim.new(0, 9),
				Parent = Holder,
			})

			ToggleLabel.Parent = Holder
			Picker.Parent = Holder

			Picker.Size = UDim2.new(0, 18, 1, 0)
		end

		local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
		do
			local Holder = New("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 16),
				Text = "",
				Visible = not Info.NoUI,
				Parent = Library.KeybindContainer,
			})

			local Label = New("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 1),
				Text = "",
				TextSize = 14,
				TextTransparency = 0.5,
				Parent = Holder,
			})

			local Checkbox = New("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = "MainColor",
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromOffset(14, 14),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Parent = Holder,
			})
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius / 2),
					Parent = Checkbox,
				})
			)
			New("UIStroke", {
				Color = "OutlineColor",
				Parent = Checkbox,
			})

			local CheckImage = New("ImageLabel", {
				Image = CheckIcon and CheckIcon.Url or "",
				ImageColor3 = "FontColor",
				ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
				ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
				ImageTransparency = 1,
				Position = UDim2.fromOffset(2, 2),
				Size = UDim2.new(1, -4, 1, -4),
				Parent = Checkbox,
			})

			function KeybindsToggle:Display(State)
				Label.TextTransparency = State and 0 or 0.5
				CheckImage.ImageTransparency = State and 0 or 1
			end

			function KeybindsToggle:SetText(Text)
				Label.Text = Text
			end

			function KeybindsToggle:SetVisibility(Visibility)
				Holder.Visible = Visibility
			end

			function KeybindsToggle:SetNormal(Normal)
				KeybindsToggle.Normal = Normal

				Holder.Active = not Normal
				Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22, 0)
				Checkbox.Visible = not Normal
			end

			KeyPicker.DoClick = function(...) end --// make luau lsp shut up
			Holder.MouseButton1Click:Connect(function()
				if KeybindsToggle.Normal then
					return
				end

				KeyPicker.Toggled = not KeyPicker.Toggled
				KeyPicker:DoClick()
			end)

			KeybindsToggle.Holder = Holder
			KeybindsToggle.Label = Label
			KeybindsToggle.Checkbox = Checkbox
			KeybindsToggle.Loaded = true
			table.insert(Library.KeybindToggles, KeybindsToggle)
		end

		local ModeButtons = {}
		local TotalModeButtons = GetTableSize(Info.Modes)
		local MenuTable = Library:AddContextMenu(
			Picker,
			UDim2.fromOffset(62, 0),
			function()
				return { Picker.AbsoluteSize.X + 1.5, 0.5 }
			end,
			1,
			function(Active: boolean)
				PickerCorner.TopRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
				PickerCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
			end,
			false,
			if TotalModeButtons == 1 then "no_left" else "no_top_left",
			"KeyPicker"
		)
		KeyPicker.Menu = MenuTable

		for Index, Mode in Info.Modes do
			local ModeButton = {}

			local Button = New("TextButton", {
				BackgroundColor3 = "MainColor",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, IsForButton and 21 or (TotalModeButtons == 1 and 18 or 19)),
				Text = Mode,
				TextSize = 14,
				TextTransparency = 0.5,
				Parent = MenuTable.Menu,
			})

			if Index == 1 and TotalModeButtons == 1 then
				table.insert(
					Library.SpecificCorners,
					New("UICorner", {
						TopLeftRadius = UDim.new(0, 0),
						TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
						BottomLeftRadius = UDim.new(0, 0),
						BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
						Parent = Button,
					})
				)
			elseif Index == 1 then
				table.insert(
					Library.SpecificCorners,
					New("UICorner", {
						TopLeftRadius = UDim.new(0, 0),
						TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
						BottomLeftRadius = UDim.new(0, 0),
						BottomRightRadius = UDim.new(0, 0),
						Parent = Button,
					})
				)
			elseif Index == TotalModeButtons then
				table.insert(
					Library.SpecificCorners,
					New("UICorner", {
						TopLeftRadius = UDim.new(0, 0),
						TopRightRadius = UDim.new(0, 0),
						BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
						BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
						Parent = Button,
					})
				)
			end

			function ModeButton:Select()
				for _, Button in ModeButtons do
					Button:Deselect()
				end

				KeyPicker.Mode = Mode

				Button.BackgroundTransparency = 0
				Button.TextTransparency = 0

				MenuTable:Close()
			end

			function ModeButton:Deselect()
				KeyPicker.Mode = nil

				Button.BackgroundTransparency = 1
				Button.TextTransparency = 0.5
			end

			Button.MouseButton1Click:Connect(function()
				ModeButton:Select()
			end)

			if KeyPicker.Mode == Mode then
				ModeButton:Select()
			end

			ModeButtons[Mode] = ModeButton
		end

		function KeyPicker:Display(PickerText)
			if Library.Unloaded then
				return
			end

			local DisplayText = PickerText or KeyPicker.DisplayValue
			if IsForButton and SlideOverflow then
				if LastPickerWidth == Picker.AbsoluteSize.X then
					return
				end

				local X, _Y = Library:GetTextBounds(DisplayText, Picker.FontFace, Picker.TextSize, 10000)

				SlidingLabel.Text = DisplayText

				local OffsetScale = X + 9
				local PickerWidth = math.min(OffsetScale, MaxPickerWidth)
				Picker.Size = UDim2.new(0, PickerWidth, 1, 0)

				if OffsetScale > PickerWidth then
					SlidingLabel.TextXAlignment = Enum.TextXAlignment.Left
					SlidingLabel.Size = UDim2.new(0, OffsetScale, 1, 0)
					SlidingLabel.Position = UDim2.fromOffset(4.5, 0)

					RunService.RenderStepped:Wait()

					local RealPickerWidth = Picker.AbsoluteSize.X
					if RealPickerWidth <= 0 then
						RealPickerWidth = PickerWidth
					end

					LastPickerWidth = RealPickerWidth

					local OverflowDistance = OffsetScale - RealPickerWidth - 4.5
					if OverflowDistance > 0 then
						CancelSlidingTweens()

						local Duration = OverflowDistance / 25
						local TweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

						SlideForwardTween = TweenService:Create(SlidingLabel, TweenInfo, {
							Position = UDim2.fromOffset(-OverflowDistance, 0),
						})

						SlideBackTween = TweenService:Create(SlidingLabel, TweenInfo, {
							Position = UDim2.fromOffset(4.5, 0),
						})

						SlideForwardTween:Play()

						SlideForwardTween.Completed:Connect(HandleForwardTween)
						SlideBackTween.Completed:Connect(HandleBackTween)
					else
						CancelSlidingTweens()

						SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
						SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
						SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
					end
				else
					CancelSlidingTweens()

					SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
					SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
					SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
				end
			else
				local X, Y =
					Library:GetTextBounds(DisplayText, Picker.FontFace, Picker.TextSize, ToggleLabel.AbsoluteSize.X)
				Picker.Text = DisplayText
				Picker.Size = IsForButton and UDim2.new(0, X + 9, 1, 0) or UDim2.fromOffset((X + 9), (Y + 4))
			end
		end

		function KeyPicker:Update()
			KeyPicker:Display()

			if Info.NoUI then
				return
			end

			if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
				KeybindsToggle:SetVisibility(false)
				return
			end

			local State = KeyPicker:GetState()
			local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

			if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
				ParentObj:SetValue(State)
			end

			if KeybindsToggle.Loaded then
				if ShowToggle then
					KeybindsToggle:SetNormal(false)
				else
					KeybindsToggle:SetNormal(true)
				end

				KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode))
				KeybindsToggle:SetVisibility(true)
				KeybindsToggle:Display(State)
			end
		end

		function KeyPicker:GetState()
			if KeyPicker.Mode == "Always" then
				return true
			elseif KeyPicker.Mode == "Hold" then
				local Key = KeyPicker.Value
				if Key == "None" then
					return false
				end

				if not AreModifiersHeld(KeyPicker.Modifiers) then
					return false
				end

				if Picking then
					return false
				end

				if SpecialKeys[Key] ~= nil then
					if Library.Toggled then
						return false
					end

					return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
						and not UserInputService:GetFocusedTextBox()
				else
					return UserInputService:IsKeyDown(Enum.KeyCode[Key] :: any)
						and not UserInputService:GetFocusedTextBox()
				end
			else
				return KeyPicker.Toggled
			end
		end

		function KeyPicker:OnChanged(Func)
			KeyPicker.Changed = Func
		end

		function KeyPicker:OnClick(Func)
			KeyPicker.Clicked = Func
		end

		function KeyPicker:DoClick()
			if Picking then
				return
			end

			if KeyPicker.Mode == "Press" then
				if KeyPicker.Toggled and Info.WaitForCallback == true then
					return
				end

				KeyPicker.Toggled = true
			end

			Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
			Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

			if IsForButton then
				Library:SafeCallback(ParentObj.Func, KeyPicker.Toggled)
			end

			if Library.ToggleKeybind == KeyPicker and Library.Toggle then
				Library:Toggle()
			end

			if KeyPicker.Mode == "Press" then
				KeyPicker.Toggled = false
			end
		end

		function KeyPicker:RunChanged(IsKeyValid, KeyCode)
			if IsKeyValid == nil or KeyCode == nil then
				IsKeyValid, KeyCode = pcall(function()
					if KeyPicker.Value == "None" then
						return nil
					end

					if SpecialKeys[KeyPicker.Value] == nil then
						return Enum.KeyCode[KeyPicker.Value]
					end

					return SpecialKeys[KeyPicker.Value]
				end)
			end

			local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
			Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
			Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)
		end

		function KeyPicker:SetValue(Data)
			local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

			local IsKeyValid, KeyCode = pcall(function()
				if Key == "None" then
					Key = nil
					return nil
				end

				if SpecialKeys[Key] == nil then
					return Enum.KeyCode[Key]
				end

				return SpecialKeys[Key]
			end)

			if Key == nil then
				KeyPicker.Value = "None"
			elseif IsKeyValid then
				KeyPicker.Value = Key
			else
				KeyPicker.Value = "Unknown"
			end

			KeyPicker.Modifiers =
				VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
			KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
				then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
				else KeyPicker.Value

			if ModeButtons[Mode] then
				ModeButtons[Mode]:Select()
			end

			KeyPicker:Update()
			KeyPicker:RunChanged(IsKeyValid, KeyCode)
		end

		function KeyPicker:SetText(Text)
			KeybindsToggle:SetText(Text)
			KeyPicker:Update()
		end

		local SetPickingState = function(State)
			Picking = State
			Library.IsPicking = State

			if ParentObj then
				ParentObj.AnyKeyPickerPicking = Picking
			end

			if IsForButton then
				ToggleLabel.Visible = not Picking
				RunService.RenderStepped:Wait()
			end

			KeyPicker:Update()
		end

		Picker.MouseButton1Click:Connect(function()
			if Picking or Library.IsPicking then
				return
			end

			SetPickingState(true)

			if IsForButton and SlideOverflow then
				KeyPicker:Display("...")
			else
				Picker.Text = "..."
				Picker.Size = IsForButton and UDim2.new(0, 29, 1, 0) or UDim2.fromOffset(29, 18)
			end

			-- Wait for any input --
			local ActiveModifiers = {}
			local CurrentInput = nil

			local IsValidInput = function(InputObj)
				if InputObj.KeyCode == Enum.KeyCode.Escape then
					return true
				end

				local IsMod = IsModifierInput(InputObj)
				local KeyName
				if SpecialKeysInput[InputObj.UserInputType] ~= nil then
					KeyName = SpecialKeysInput[InputObj.UserInputType]
				elseif InputObj.UserInputType == Enum.UserInputType.Keyboard then
					if IsMod then
						KeyName = ModifiersInput[InputObj.KeyCode]
					else
						KeyName = InputObj.KeyCode.Name
					end
				end

				if KeyName then
					if IsMod then
						if
							KeyPicker.WhitelistedModifiers
							and #KeyPicker.WhitelistedModifiers > 0
							and not table.find(KeyPicker.WhitelistedModifiers, KeyName)
						then
							return false
						end

						if KeyPicker.BlacklistedModifiers and table.find(KeyPicker.BlacklistedModifiers, KeyName) then
							return false
						end
					else
						if
							KeyPicker.Whitelisted
							and #KeyPicker.Whitelisted > 0
							and not table.find(KeyPicker.Whitelisted, KeyName)
						then
							return false
						end

						if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
							return false
						end
					end
				end

				return true
			end

			-- Wait for the first valid InputBegan --
			while true do
				local InputObj = UserInputService.InputBegan:Wait()
				if UserInputService:GetFocusedTextBox() ~= nil then
					SetPickingState(false)
					return
				end

				if IsValidInput(InputObj) then
					CurrentInput = InputObj
					break
				end
			end

			-- If it's a modifier key, we wait for either its release or another input --
			while IsModifierInput(CurrentInput) do
				if CurrentInput.KeyCode == Enum.KeyCode.Escape then
					break
				end

				-- Display the current state including the current modifier key --
				local ModName = ModifiersInput[CurrentInput.KeyCode]
				if ModName then
					local text = if #ActiveModifiers > 0
						then table.concat(ActiveModifiers, " + ") .. " + " .. ModName .. " + ..."
						else ModName .. " + ..."
					KeyPicker:Display(text)
				end

				local NextInput = nil
				local Released = false

				local BeganConn
				local EndedConn

				BeganConn = UserInputService.InputBegan:Connect(function(InputObj)
					if UserInputService:GetFocusedTextBox() ~= nil then
						return
					end
					if IsValidInput(InputObj) then
						NextInput = InputObj
					end
				end)

				EndedConn = UserInputService.InputEnded:Connect(function(InputObj)
					if InputObj.KeyCode == CurrentInput.KeyCode then
						Released = true
					end
				end)

				repeat
					task.wait()
				until Released or NextInput or UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded

				if BeganConn then
					BeganConn:Disconnect()
				end
				if EndedConn then
					EndedConn:Disconnect()
				end

				if UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded then
					SetPickingState(false)
					return
				end

				if Released then
					break -- Use modifier key as bind
				elseif NextInput then
					-- Add another modifier or continue to normal key
					local OldModName = ModifiersInput[CurrentInput.KeyCode]
					if OldModName and not table.find(ActiveModifiers, OldModName) then
						ActiveModifiers[#ActiveModifiers + 1] = OldModName
					end

					CurrentInput = NextInput
					if CurrentInput.KeyCode == Enum.KeyCode.Escape then
						break
					end
				end
			end

			local Key = "Unknown"
			if SpecialKeysInput[CurrentInput.UserInputType] ~= nil then
				Key = SpecialKeysInput[CurrentInput.UserInputType]
			elseif CurrentInput.UserInputType == Enum.UserInputType.Keyboard then
				Key = CurrentInput.KeyCode == Enum.KeyCode.Escape and "None" or CurrentInput.KeyCode.Name
			end

			ActiveModifiers = if CurrentInput.KeyCode == Enum.KeyCode.Escape or Key == "Unknown"
				then {}
				else ActiveModifiers

			KeyPicker.Toggled = if ParentObj.Type == "Toggle" then ParentObj.Value else false
			KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

			repeat
				task.wait()
			until not IsInputDown(CurrentInput) or UserInputService:GetFocusedTextBox()

			SetPickingState(false)
		end)
		Picker.MouseButton2Click:Connect(MenuTable.Toggle)

		table.insert(
			KeyPicker.Connections,
			UserInputService.InputBegan:Connect(function(Input: InputObject)
				if Library.Unloaded then
					return
				end

				local IsMouse = IsMouseClickInput(Input)
				if
					KeyPicker.Mode == "Always"
					or KeyPicker.Value == "Unknown"
					or KeyPicker.Value == "None"
					or Picking
					or Library.IsPicking
					or UserInputService:GetFocusedTextBox()
					or (IsMouse and Library.Toggled)
				then
					return
				end

				local Key = KeyPicker.Value
				local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
				local HoldingKey = false

				if
					Key
					and HoldingModifiers == true
					and (
						SpecialKeysInput[Input.UserInputType] == Key
						or (Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key)
					)
				then
					HoldingKey = true
				end

				if KeyPicker.Mode == "Toggle" then
					if HoldingKey then
						KeyPicker.Toggled = not KeyPicker.Toggled
						KeyPicker:DoClick()
					end
				elseif KeyPicker.Mode == "Press" then
					if HoldingKey then
						KeyPicker:DoClick()
					end
				end

				KeyPicker:Update()
			end)
		)

		table.insert(
			KeyPicker.Connections,
			UserInputService.InputEnded:Connect(function(Input: InputObject)
				if Library.Unloaded then
					return
				end

				local IsMouse = IsMouseClickInput(Input)
				if
					KeyPicker.Value == "Unknown"
					or KeyPicker.Value == "None"
					or Picking
					or Library.IsPicking
					or UserInputService:GetFocusedTextBox()
					or (IsMouse and Library.Toggled)
				then
					return
				end

				KeyPicker:Update()
			end)
		)

		KeyPicker:Update()

		if ParentObj.Addons then
			table.insert(ParentObj.Addons, KeyPicker)
		end

		KeyPicker.Default = KeyPicker.Value
		KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

		function KeyPicker:Destroy()
			KeyPicker.Destroyed = true

			if KeyPicker.Connections then
				for _, Connection in KeyPicker.Connections do
					Connection:Disconnect()
				end
			end

			if KeybindsToggle and KeybindsToggle.Loaded then
				if KeybindsToggle.Holder then
					KeybindsToggle.Holder:Destroy()
				end
				local KTIdx = table.find(Library.KeybindToggles, KeybindsToggle)
				if KTIdx then
					table.remove(Library.KeybindToggles, KTIdx)
				end
			end

			if MenuTable then
				MenuTable:Destroy()
			end

			if IsForButton and SlideOverflow then
				if SlideForwardTween then
					SlideForwardTween:Destroy()
				end

				if SlideBackTween then
					SlideBackTween:Destroy()
				end
			end

			if Picker then
				Picker:Destroy()
			end

			if ParentObj and ParentObj.Addons then
				local AddonIdx = table.find(ParentObj.Addons, KeyPicker)

				if AddonIdx then
					table.remove(ParentObj.Addons, AddonIdx)
				end
			end

			Options[Idx] = nil
		end

		Options[Idx] = KeyPicker

		return self
	end

	local HueSequenceTable = {}
	for Hue = 0, 1, 0.1 do
		table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
	end
	function Funcs:AddColorPicker(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.ColorPicker)

		local ParentObj = self
		local ToggleLabel = ParentObj.TextLabel

		local ColorPicker = {
			Connections = {},
			Destroyed = false,

			Value = Info.Default,

			Transparency = Info.Transparency or 0,
			Title = Info.Title,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Type = "ColorPicker",
		}
		ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

		local Holder = New("TextButton", {
			BackgroundColor3 = ColorPicker.Value,
			Size = UDim2.fromOffset(18, 18),
			Text = "",
			Parent = ToggleLabel,
		})

		local HolderStroke = New("UIStroke", {
			Color = Library:GetDarkerColor(ColorPicker.Value),
			Parent = Holder,
		})

		local ColorPickerCorner = New("UICorner", {
			TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = Holder,
		})
		table.insert(Library.SpecificCorners, ColorPickerCorner)

		local HolderTransparency = New("ImageLabel", {
			Image = CustomImageManager.GetAsset("TransparencyTexture"),
			ImageTransparency = (1 - ColorPicker.Transparency),
			ScaleType = Enum.ScaleType.Tile,
			Position = UDim2.new(0, -1, 0, -1),
			Size = UDim2.new(1, 2, 1, 2),
			TileSize = UDim2.fromOffset(9, 9),
			Parent = Holder,
		})

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = HolderTransparency,
			})
		)

		--// Color Menu \\--
		local ColorMenu = Library:AddContextMenu(
			Holder,
			UDim2.fromOffset(Info.Transparency and 256 or 234, 0),
			function()
				return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
			end,
			1,
			function(Active: boolean)
				ColorPickerCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
				ColorPickerCorner.BottomLeftRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
			end,
			false,
			"no_top_left"
		)
		ColorMenu.List.Padding = UDim.new(0, 8)
		ColorPicker.ColorMenu = ColorMenu

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			Parent = ColorMenu.Menu,
		})

		if typeof(ColorPicker.Title) == "string" then
			New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 8),
				Text = ColorPicker.Title,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = ColorMenu.Menu,
			})
		end

		local ColorHolder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 200),
			Parent = ColorMenu.Menu,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 6),
			Parent = ColorHolder,
		})

		--// Sat Map
		local SatVipMap = New("ImageButton", {
			BackgroundColor3 = ColorPicker.Value,
			Image = CustomImageManager.GetAsset("SaturationMap"),
			Size = UDim2.fromOffset(200, 200),
			Parent = ColorHolder,
		})
		SatVipMap:SetAttribute("NoGlowPulse", true)

		local SatVibCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = "WhiteColor",
			Size = UDim2.fromOffset(6, 6),
			Parent = SatVipMap,
		})
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = SatVibCursor,
		})
		New("UIStroke", {
			Color = "DarkColor",
			Parent = SatVibCursor,
		})

		--// Hue
		local HueSelector = New("TextButton", {
			Size = UDim2.fromOffset(16, 200),
			Text = "",
			Parent = ColorHolder,
		})
		HueSelector:SetAttribute("NoGlowPulse", true)
		New("UIGradient", {
			Color = ColorSequence.new(HueSequenceTable),
			Rotation = 90,
			Parent = HueSelector,
		})

		local HueCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = "WhiteColor",
			BorderColor3 = "DarkColor",
			BorderSizePixel = 1,
			Position = UDim2.fromScale(0.5, ColorPicker.Hue),
			Size = UDim2.new(1, 2, 0, 1),
			Parent = HueSelector,
		})

		--// Alpha
		local TransparencySelector, TransparencyColor, TransparencyCursor
		if Info.Transparency then
			TransparencySelector = New("ImageButton", {
				Image = CustomImageManager.GetAsset("TransparencyTexture"),
				ScaleType = Enum.ScaleType.Tile,
				Size = UDim2.fromOffset(16, 200),
				TileSize = UDim2.fromOffset(8, 8),
				Parent = ColorHolder,
			})
			TransparencySelector:SetAttribute("NoGlowPulse", true)

			TransparencyColor = New("Frame", {
				BackgroundColor3 = ColorPicker.Value,
				Size = UDim2.fromScale(1, 1),
				Parent = TransparencySelector,
			})
			New("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Parent = TransparencyColor,
			})

			TransparencyCursor = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = "WhiteColor",
				BorderColor3 = "DarkColor",
				BorderSizePixel = 1,
				Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
				Size = UDim2.new(1, 2, 0, 1),
				Parent = TransparencySelector,
			})
		end

		local InfoHolder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			Parent = ColorMenu.Menu,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = UDim.new(0, 8),
			Parent = InfoHolder,
		})

		local HueBox = New("TextBox", {
			BackgroundColor3 = "MainColor",
			ClearTextOnFocus = false,
			Size = UDim2.fromScale(1, 1),
			Text = "#??????",
			TextSize = 14,
			Parent = InfoHolder,
		})

		New("UIStroke", {
			Color = "OutlineColor",
			Parent = HueBox,
		})

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = HueBox,
			})
		)

		local RgbBox = New("TextBox", {
			BackgroundColor3 = "MainColor",
			ClearTextOnFocus = false,
			Size = UDim2.fromScale(1, 1),
			Text = "?, ?, ?",
			TextSize = 14,
			Parent = InfoHolder,
		})

		New("UIStroke", {
			Color = "OutlineColor",
			Parent = RgbBox,
		})

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = RgbBox,
			})
		)

		--// Context Menu \\--
		local ContextMenu = Library:AddContextMenu(
			Holder,
			UDim2.fromOffset(93, 0),
			function()
				return { Holder.AbsoluteSize.X + 1.5, 0.5 }
			end,
			1,
			function(Active: boolean)
				ColorPickerCorner.TopRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
				ColorPickerCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
			end,
			false,
			"no_top_left"
		)
		ColorPicker.ContextMenu = ContextMenu
		ContextMenu.List.Padding = UDim.new(0, 6)
		do
			local function CreateButton(Text, Func)
				local Button = New("TextButton", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 21),
					Text = Text,
					TextSize = 14,
					Parent = ContextMenu.Menu,
				})

				Button.MouseButton1Click:Connect(function()
					Library:SafeCallback(Func)
					ContextMenu:Close()
				end)
			end

			CreateButton("Copy color", function()
				Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
			end)

			ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
			CreateButton("Paste color", function()
				ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
			end)

			if setclipboard then
				CreateButton("Copy Hex", function()
					setclipboard(tostring(ColorPicker.Value:ToHex()))
				end)

				CreateButton("Copy RGB", function()
					setclipboard(table.concat({
						math.floor(ColorPicker.Value.R * 255),
						math.floor(ColorPicker.Value.G * 255),
						math.floor(ColorPicker.Value.B * 255),
					}, ", "))
				end)
			end
		end

		--// End \\--
		function ColorPicker:SetHSVFromRGB(Color)
			ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
		end

		function ColorPicker:Display()
			if Library.Unloaded then
				return
			end

			ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

			Holder.BackgroundColor3 = ColorPicker.Value
			HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
			HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

			SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
			if TransparencyColor then
				TransparencyColor.BackgroundColor3 = ColorPicker.Value
			end

			SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
			HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
			if TransparencyCursor then
				TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
			end

			HueBox.Text = "#" .. ColorPicker.Value:ToHex()
			RgbBox.Text = table.concat({
				math.floor(ColorPicker.Value.R * 255),
				math.floor(ColorPicker.Value.G * 255),
				math.floor(ColorPicker.Value.B * 255),
			}, ", ")
		end

		function ColorPicker:RunChanged()
			Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
			Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
		end

		function ColorPicker:Update()
			ColorPicker:Display()
			ColorPicker:RunChanged()
		end

		function ColorPicker:OnChanged(Func)
			ColorPicker.Changed = Func
		end

		function ColorPicker:SetValue(HSV, Transparency)
			if typeof(HSV) == "Color3" then
				ColorPicker:SetValueRGB(HSV, Transparency)
				return
			end

			local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
			ColorPicker.Transparency = Info.Transparency and Transparency or 0
			ColorPicker:SetHSVFromRGB(Color)
			ColorPicker:Update()
		end

		function ColorPicker:SetValueRGB(Color, Transparency)
			ColorPicker.Transparency = Info.Transparency and Transparency or 0
			ColorPicker:SetHSVFromRGB(Color)
			ColorPicker:Update()
		end

		table.insert(ColorPicker.Connections, Holder.MouseButton1Click:Connect(ColorMenu.Toggle))
		table.insert(ColorPicker.Connections, Holder.MouseButton2Click:Connect(ContextMenu.Toggle))

		do
			local DragKind = nil
			local DragActive = false

			local function DragRelease(Input: InputObject)
				if DragKind and Input.UserInputType == DragKind then
					DragActive = false
					DragKind = nil
				end
			end

			local function DragBegin(Input: InputObject, Kind: string)
				if not IsClickInput(Input) or ColorPicker.Destroyed then
					return
				end
				if DragActive then
					return
				end

				DragActive = true
				DragKind = Input.UserInputType

				task.spawn(function()
					while DragActive and not ColorPicker.Destroyed do
						if Kind == "satvib" then
							local MinX = SatVipMap.AbsolutePosition.X
							local MaxX = MinX + SatVipMap.AbsoluteSize.X
							local LocationX = math.clamp(Mouse.X, MinX, MaxX)

							local MinY = SatVipMap.AbsolutePosition.Y
							local MaxY = MinY + SatVipMap.AbsoluteSize.Y
							local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

							local OldSat = ColorPicker.Sat
							local OldVib = ColorPicker.Vib
							ColorPicker.Sat = (MaxX > MinX) and ((LocationX - MinX) / (MaxX - MinX)) or ColorPicker.Sat
							ColorPicker.Vib = (MaxY > MinY) and (1 - ((LocationY - MinY) / (MaxY - MinY))) or ColorPicker.Vib

							if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
								ColorPicker:Update()
							end
						elseif Kind == "hue" then
							local Min = HueSelector.AbsolutePosition.Y
							local Max = Min + HueSelector.AbsoluteSize.Y
							local Location = math.clamp(Mouse.Y, Min, Max)

							local OldHue = ColorPicker.Hue
							ColorPicker.Hue = (Max > Min) and ((Location - Min) / (Max - Min)) or ColorPicker.Hue

							if ColorPicker.Hue ~= OldHue then
								ColorPicker:Update()
							end
						elseif Kind == "alpha" and TransparencySelector then
							local Min = TransparencySelector.AbsolutePosition.Y
							local Max = Min + TransparencySelector.AbsoluteSize.Y
							local Location = math.clamp(Mouse.Y, Min, Max)

							local OldTransparency = ColorPicker.Transparency
							ColorPicker.Transparency = (Max > Min) and ((Location - Min) / (Max - Min)) or ColorPicker.Transparency

							if ColorPicker.Transparency ~= OldTransparency then
								ColorPicker:Update()
							end
						end

						RunService.RenderStepped:Wait()
					end

					DragActive = false
					DragKind = nil
				end)
			end

			table.insert(ColorPicker.Connections, SatVipMap.InputBegan:Connect(function(Input: InputObject)
				DragBegin(Input, "satvib")
			end))
			table.insert(ColorPicker.Connections, HueSelector.InputBegan:Connect(function(Input: InputObject)
				DragBegin(Input, "hue")
			end))
			if TransparencySelector then
				table.insert(ColorPicker.Connections, TransparencySelector.InputBegan:Connect(function(Input: InputObject)
					DragBegin(Input, "alpha")
				end))
			end
			table.insert(ColorPicker.Connections, UserInputService.InputEnded:Connect(DragRelease))
		end


		table.insert(
			ColorPicker.Connections,
			HueBox.FocusLost:Connect(function(Enter)
				if not Enter then
					return
				end

				local Success, Color = pcall(Color3.fromHex, HueBox.Text)
				if Success and typeof(Color) == "Color3" then
					ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
				end

				ColorPicker:Update()
			end)
		)

		table.insert(
			ColorPicker.Connections,
			RgbBox.FocusLost:Connect(function(Enter)
				if not Enter then
					return
				end

				local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
				if R and G and B then
					ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
				end

				ColorPicker:Update()
			end)
		)

		ColorPicker:Display()

		if ParentObj.Addons then
			table.insert(ParentObj.Addons, ColorPicker)
		end

		ColorPicker.Default = ColorPicker.Value

		function ColorPicker:Destroy()
			ColorPicker.Destroyed = true

			if ColorPicker.Connections then
				for _, Connection in ColorPicker.Connections do
					Connection:Disconnect()
				end
			end

			if ColorMenu then
				ColorMenu:Destroy()
			end

			if ContextMenu then
				ContextMenu:Destroy()
			end

			if Holder then
				Holder:Destroy()
			end

			if ParentObj and ParentObj.Addons then
				local AddonIdx = table.find(ParentObj.Addons, ColorPicker)

				if AddonIdx then
					table.remove(ParentObj.Addons, AddonIdx)
				end
			end

			Options[Idx] = nil
		end

		Options[Idx] = ColorPicker

		return self
	end

	BaseAddons.__index = Funcs
	BaseAddons.__namecall = function(_, Key, ...)
		return Funcs[Key](...)
	end
end

local BaseGroupbox = {}
do
	local Funcs = {}

	--// COMPONENT: Clean 2-Line Scroll Feed (Persis Chilli Asli: Anti-Bocor & Lega)
	function Funcs:AddGroupbox(Info)
		if self.Destroyed then
			return nil
		end
		if typeof(Info) ~= "table" then
			return nil
		end
		if Info.Side == 2 then
			return self:AddRightGroupbox(Info.Name or "", Info.IconName)
		end
		return self:AddLeftGroupbox(Info.Name or "", Info.IconName)
	end

	function Funcs:AddSpotlightCard(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.SpotlightCard)

		local Groupbox = self
		local Container = Groupbox.Container
		local Height = Info.Height

		local Card = New("Frame", {
			BackgroundColor3 = "MainColor",
			BackgroundTransparency = 0.3,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, Height),
			Parent = Container,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius),
				Parent = Card,
			})
		)
		New("UIStroke", {
			Color = "OutlineColor",
			Thickness = 1,
			Parent = Card,
		})

		local BoxSize = Height - 12
		local Icon = New("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 6, 0.5, 0),
			Size = UDim2.new(0, BoxSize, 0, BoxSize),
			Image = Info.Image or "",
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 2,
			Parent = Card,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, 6),
				Parent = Icon,
			})
		)
		local Glow = New("ImageLabel", {
			Name = "IconGlow",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 6 + BoxSize / 2, 0.5, 0),
			Size = UDim2.new(0, BoxSize * Library.IconGlow.Scale, 0, BoxSize * Library.IconGlow.Scale),
			Image = Library.IconGlow.Image,
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = Library.IconGlow.Transparency,
			ScaleType = Enum.ScaleType.Stretch,
			Visible = Library.IconGlow.Enabled,
			ZIndex = 1,
			Parent = Card,
		})
		table.insert(Library.IconGlows, { Inst = Glow, Base = BoxSize })

		local Title = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, BoxSize + 14, 0, 6),
			Size = UDim2.new(1, -BoxSize - 116, 0, 16),
			Text = Info.Title or "",
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Card,
		})
		New("UIStroke", {
			Name = "N3GameStroke",
			Color = Color3.new(0, 0, 0),
			Thickness = 1.5,
			Parent = Title,
		})
		local Rarity = New("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -8, 0, 7),
			Size = UDim2.new(0, 96, 0, 16),
			Text = "",
			TextColor3 = "AccentColor",
			TextSize = 13,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Visible = false,
			Parent = Card,
		})
		local Mutation = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, BoxSize + 14, 0, 24),
			Size = UDim2.new(1, -BoxSize - 22, 0, 14),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 12,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Visible = false,
			Parent = Card,
		})
		local Rate = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, BoxSize + 14, 0, 40),
			Size = UDim2.new(1, -BoxSize - 22, 0, 15),
			Text = "",
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 13,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Card,
		})
		local Desc = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, BoxSize + 14, 0, 57),
			Size = UDim2.new(1, -BoxSize - 22, 1, -65),
			Text = Info.Description or "",
			TextColor3 = "FontColor",
			TextTransparency = 0.25,
			TextSize = 11,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Parent = Card,
		})

		local ViewportStub = setmetatable({}, {
			__index = function(t, k)
				local Noop = function()
				end
				rawset(t, k, Noop)
				return Noop
			end,
			__newindex = rawset,
			__call = function()
			end,
		})

		local CardObj = {
			Frame = Card,
			Title = Title,
			Desc = Desc,
			Icon = Icon,
			Rarity = Rarity,
			RarityColor = nil,
			RarityTween = nil,
			Viewport = ViewportStub,
			ModelSource = nil,
			Destroyed = false,
			Type = "SpotlightCard",
		}

		function CardObj:SetRarity(Text, Color)
			if self.Destroyed then
				return
			end
			if self.RarityTween then
				self.RarityTween:Cancel()
				self.RarityTween = nil
			end
			if not Text or Text == "" then
				Rarity.Visible = false
				self.RarityColor = nil
				return
			end
			Text = tostring(Text)
			local Base = Color
			if typeof(Base) ~= "Color3" then
				Base = Library.PanelRarity[Text] or Library.Scheme.AccentColor
			end
			self.RarityColor = Base
			Rarity.Visible = true
			Rarity.Text = Text
			local GradName = nil
			if Library.GameText.RarityMode == "gradient" then
				if Library:ResolveGameGradient(Text) then
					GradName = Text
				elseif Library:ResolveGameGradient(Color) then
					GradName = Color
				end
			end
			if GradName then
				Library:ApplyGameText(Rarity, GradName)
			else
				pcall(function()
					Rarity:FindFirstChild("N3GameGradient"):Destroy()
				end)
				if not Rarity:FindFirstChild("N3GameStroke") then
					New("UIStroke", {
						Name = "N3GameStroke",
						Color = Library.GameText.StrokeColor,
						Thickness = 1.5,
						Parent = Rarity,
					})
				end
				Rarity.TextColor3 = Base
				if Library.PanelStyle.AnimateText then
					local Tw = TweenService:Create(Rarity, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
						TextColor3 = Library:GetBetterColor(Base, 18),
					})
					Tw:Play()
					self.RarityTween = Tw
				end
			end
		end

		function CardObj:SetFields(Fields)
			if self.Destroyed or type(Fields) ~= "table" then
				return
			end
			if Fields.Name then
				Title.Text = tostring(Fields.Name)
			end
			if Fields.Rarity then
				self:SetRarity(Fields.Rarity, Fields.RarityColor)
			end
			if Fields.Mutation ~= nil then
				local Mut = tostring(Fields.Mutation)
				Mutation.Visible = Mut ~= ""
				Mutation.Text = Mut
				if not Library:ApplyGameText(Mutation, Mut) then
					pcall(function()
						Mutation:FindFirstChild("N3GameGradient"):Destroy()
					end)
					Mutation.TextColor3 = Color3.new(1, 1, 1)
					Mutation.TextTransparency = 0.15
				end
			end
			if Fields.Rate then
				Rate.Text = tostring(Fields.Rate)
				Library:ApplyGameText(Rate, "Cash")
			end
			if Fields.Meta then
				Desc.Text = tostring(Fields.Meta)
			end
		end

		function CardObj:SetData(TitleText, DescText, ImageAsset, ModelSource)
			if self.Destroyed then
				return
			end
			if TitleText then
				Title.Text = tostring(TitleText)
			end
			if DescText then
				Desc.Text = tostring(DescText)
			end
			if typeof(ImageAsset) == "string" and ImageAsset ~= "" then
				Icon.Image = ImageAsset
			end
			self.ModelSource = ModelSource
		end

		function CardObj:Destroy()
			self.Destroyed = true
			if self.RarityTween then
				self.RarityTween:Cancel()
			end
			Card:Destroy()
			local ElemIdx = table.find(Groupbox.Elements, Card)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end
			Groupbox:Resize()
			Options[Idx] = nil
		end

		table.insert(Groupbox.Elements, Card)
		Groupbox:Resize()
		Options[Idx] = CardObj
		return CardObj
	end

	function Funcs:AddScrollFeed(Idx, Info)
		if self.Destroyed then
			return nil
		end

		local Groupbox = self
		local Container = Groupbox.Container

		local FeedScroll = New("ScrollingFrame", {
			BackgroundColor3 = "MainColor",
			BackgroundTransparency = 0.7,
			Size = UDim2.new(1, 0, 0, Info.Height or 230),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = "OutlineColor",
			Parent = Container,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius),
				Parent = FeedScroll,
			})
		)
		New("UIStroke", {
			Color = "OutlineColor",
			Thickness = 1,
			Parent = FeedScroll,
		})

		local FeedLayout = New("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 4),
			Parent = FeedScroll,
		})
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4),
			Parent = FeedScroll,
		})

		local function UpdateCanvas()
			FeedScroll.CanvasSize = UDim2.fromOffset(0, FeedLayout.AbsoluteContentSize.Y + 8)
		end
		FeedLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

		local ItemsPool = {}
		local FeedObj = {
			Scroll = FeedScroll,
			Items = ItemsPool,
			Type = "ScrollFeed",
		}

		function FeedObj:Clear()
			for _, item in ipairs(ItemsPool) do
				if item.Frame then
					item.Frame:Destroy()
				end
			end
			table.clear(ItemsPool)
			UpdateCanvas()
		end

		function FeedObj:AddItem(itemData)
			-- itemData = { Icon = "", Title = "", Detail = "", RightTag = "", OnClick = func }
			local RowBtn = New("TextButton", {
				BackgroundColor3 = "BackgroundColor",
				BackgroundTransparency = 0.35,
				Size = UDim2.new(1, 0, 0, 44),
				Text = "",
				AutoButtonColor = true,
				ClipsDescendants = true,
				Parent = FeedScroll,
			})
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius / 1.5),
					Parent = RowBtn,
				})
			)
			New("UIStroke", {
				Color = "OutlineColor",
				Thickness = 1,
				Parent = RowBtn,
			})

			-- Icon Pet / Telur
			local RowIcon = New("ImageLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(34, 34),
				Image = itemData.Icon or "",
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 2,
				Parent = RowBtn,
			})
			local RowGlow = New("ImageLabel", {
				Name = "IconGlow",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromOffset(22, 22),
				Size = UDim2.fromOffset(34 * Library.IconGlow.Scale, 34 * Library.IconGlow.Scale),
				Image = Library.IconGlow.Image,
				ImageColor3 = Color3.new(1, 1, 1),
				ImageTransparency = Library.IconGlow.Transparency,
				ScaleType = Enum.ScaleType.Stretch,
				Visible = Library.IconGlow.Enabled,
				ZIndex = 1,
				Parent = RowBtn,
			})
			table.insert(Library.IconGlows, { Inst = RowGlow, Base = 34 })

			local RowTitle = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(46, 4),
				Size = UDim2.new(1, -125, 0, 16),
				Text = itemData.Title or "",
				TextSize = 13,
				RichText = false,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = RowBtn,
			})
			if itemData.Rarity then
				RowTitle.Text = (itemData.Title or "") .. "  " .. string.upper(tostring(itemData.Rarity))
				if not Library:ApplyGameText(RowTitle, itemData.Rarity) then
					Library:ClearGameText(RowTitle)
					New("UIStroke", {
						Name = "N3GameStroke",
						Color = Color3.new(0, 0, 0),
						Thickness = 1.2,
						Parent = RowTitle,
					})
					RowTitle.TextColor3 = Color3.new(1, 1, 1)
				end
			end

			-- Baris 2: Rate $/s · Scale · Berat Kg · Mutasi (1 Baris Horizontal Rapi)
			local RowDetail = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(46, 22),
				Size = UDim2.new(1, -125, 0, 16),
				Text = itemData.Detail or "",
				TextSize = 11,
				RichText = true,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = RowBtn,
			})

			if itemData.RightTag and itemData.RightTag ~= "" then
				local RowRight = New("TextLabel", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.fromOffset(85, 20),
					Text = itemData.RightTag,
					TextSize = 11,
					RichText = true,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = RowBtn,
				})
			end

			if itemData.OnClick then
				RowBtn.MouseButton1Click:Connect(itemData.OnClick)
			end

			table.insert(ItemsPool, { Frame = RowBtn })
			UpdateCanvas()
		end

		Groupbox:Resize()
		table.insert(Groupbox.Elements, FeedObj)
		if Idx then
			Options[Idx] = FeedObj
		end

		return FeedObj
	end

	Library.N3V4Version = "4.43.0"

	Library.ButtonGradient = {
		Enabled = true,
		Rotation = -90,
		MiddlePosition = 0.5,
		MiddleTransparency = 0,
		Offset = 0.01,
		ColorTop = Color3.fromRGB(85, 85, 85),
		ColorMiddle = Color3.fromRGB(224, 224, 224),
		ColorBottom = Color3.fromRGB(85, 85, 85),
	}

	Library.ButtonGradientInstances = {}

	function Library:ApplyButtonGradient()
		local G = Library.ButtonGradient
		local Pos = math.clamp(G.MiddlePosition, 0.02, 0.98)
		local Sequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, G.ColorTop),
			ColorSequenceKeypoint.new(Pos, G.ColorMiddle),
			ColorSequenceKeypoint.new(1, G.ColorBottom),
		})
		local Trans = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(Pos, G.MiddleTransparency),
			NumberSequenceKeypoint.new(1, 0),
		})
		for _, Gradient in ipairs(Library.ButtonGradientInstances) do
			if Gradient.Parent then
				Gradient.Enabled = G.Enabled
				Gradient.Color = Sequence
				Gradient.Transparency = Trans
				Gradient.Rotation = G.Rotation
				Gradient.Offset = Vector2.new(G.Offset, 0)
			end
		end
	end

	function Library:SetButtonGradient(Info)
		if type(Info) == "table" then
			for Key, Value in Info do
				local Current = Library.ButtonGradient[Key]
				if Current ~= nil and type(Current) == type(Value) then
					Library.ButtonGradient[Key] = Value
				end
			end
		end
		local Ok, Err = pcall(Library.ApplyButtonGradient, Library)
		if not Ok then
			warn("[N3V4] apply button gradient gagal: " .. tostring(Err))
		end
	end


	Library.DividerAppearance = {
		LineTransparency = 0.4,
		TextTransparency = 0,
	}

	Library.DividerInstances = {}

	function Library:ApplyDividerAppearance()
		for _, D in ipairs(Library.DividerInstances) do
			if not D.Destroyed then
				for _, Stroke in ipairs(D.Lines or {}) do
					if Stroke then
						Stroke.Transparency = Library.DividerAppearance.LineTransparency
					end
				end
				if D.Label then
					D.Label.TextTransparency = Library.DividerAppearance.TextTransparency
				end
			end
		end
	end

	function Library:SetDividerTransparency(LineTransparency, TextTransparency)
		if type(LineTransparency) == "number" then
			Library.DividerAppearance.LineTransparency = math.clamp(LineTransparency, 0, 1)
		end
		if type(TextTransparency) == "number" then
			Library.DividerAppearance.TextTransparency = math.clamp(TextTransparency, 0, 1)
		end
		local Ok, Err = pcall(Library.ApplyDividerAppearance, Library)
		if not Ok then
			warn("[N3V4] apply divider appearance gagal: " .. tostring(Err))
		end
	end

	function Funcs:AddDivider(...)
		if self.Destroyed then
			return nil
		end

		local Params = select(1, ...)
		local Text
		local MarginTop = 0
		local MarginBottom = 0

		if typeof(Params) == "table" then
			Text = Params.Text
			MarginTop = Params.MarginTop or Params.Margin or 0
			MarginBottom = Params.MarginBottom or Params.Margin or 0
		elseif typeof(Params) == "string" then
			Text = Params
		end

		local Groupbox = self
		local Container = Groupbox.Container
		local LineFrames = {}
		local TextLabel = nil

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
			Parent = Container,
		})

		local InnerHolder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Holder,
		})

		New("UIPadding", {
			PaddingTop = UDim.new(0, MarginTop),
			PaddingBottom = UDim.new(0, MarginBottom),
			Parent = Holder,
		})

		local function SafeLine(Properties)
			local Ok, Frame = pcall(New, "Frame", Properties)
			if not Ok then
				warn("[N3V4] divider line gagal dibikin: " .. tostring(Frame))
				return nil
			end
			return New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = "AccentColor",
				Thickness = 1,
				Transparency = Library.DividerAppearance.LineTransparency,
				Parent = Frame,
			})
		end

		if Text then
			TextLabel = New("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				Text = Text,
				TextColor3 = "AccentColor",
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = InnerHolder,
			})
			TextLabel.TextTransparency = Library.DividerAppearance.TextTransparency

			local X, _ = Library:GetTextBounds(Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
			local SizeX = X // 2 + 10

			LineFrames[1] = SafeLine({
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = "MainColor",
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.new(0.5, -SizeX, 0, 2),
				Parent = InnerHolder,
			})
			LineFrames[2] = SafeLine({
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = "MainColor",
				BorderSizePixel = 0,
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.new(0.5, -SizeX, 0, 2),
				Parent = InnerHolder,
			})
		else
			LineFrames[1] = SafeLine({
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = "MainColor",
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.new(1, 0, 0, 2),
				Parent = InnerHolder,
			})
		end

		Groupbox:Resize()

		local Divider = {
			Connections = {},
			Destroyed = false,

			Holder = Holder,
			Text = Text,
			MarginTop = MarginTop,
			MarginBottom = MarginBottom,
			Type = "Divider",
		}

		Divider.Lines = LineFrames
		Divider.Label = TextLabel
		table.insert(Library.DividerInstances, Divider)

		function Divider:SetVisible(Value)
			Holder.Visible = Value == true
			Groupbox:Resize()
		end

		function Divider:Destroy()
			Divider.Destroyed = true

			if Divider.Connections then
				for _, Connection in Divider.Connections do
					Connection:Disconnect()
				end
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Divider)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
		end

		table.insert(Groupbox.Elements, Divider)
		return Divider
	end

	function Funcs:AddLabel(...)
		if self.Destroyed then
			return nil
		end

		local Data = {}
		local Addons = {}

		local First = select(1, ...)
		local Second = select(2, ...)

		if typeof(First) == "table" or typeof(Second) == "table" then
			local Params = typeof(First) == "table" and First or Second

			Data.Text = Params.Text or ""
			Data.DoesWrap = Params.DoesWrap or false
			Data.Size = Params.Size or 14
			Data.Visible = Params.Visible or true
			Data.Idx = typeof(Second) == "table" and First or nil
		else
			Data.Text = First or ""
			Data.DoesWrap = Second or false
			Data.Size = 14
			Data.Visible = true
			Data.Idx = select(3, ...) or nil
		end

		local Groupbox = self
		local Container = Groupbox.Container

		local Label = {
			Connections = {},
			Destroyed = false,

			Text = Data.Text,
			DoesWrap = Data.DoesWrap,

			Addons = Addons,

			Visible = Data.Visible,
			Type = "Label",
		}

		local TextLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Text = Label.Text,
			TextSize = Data.Size,
			TextWrapped = Label.DoesWrap,
			TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
			Parent = Container,
		})

		function Label:Display()
			if not Label.DoesWrap then
				return
			end

			local Width = TextLabel.AbsoluteSize.X
			if Width <= 0 then
				return
			end

			local _, Y = Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, Width)
			TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
		end

		function Label:SetVisible(Visible: boolean)
			Label.Visible = Visible

			TextLabel.Visible = Label.Visible
			Groupbox:Resize()
		end

		function Label:SetText(Text: string)
			Label.Text = Text
			TextLabel.Text = Text

			Label:Display()
			Groupbox:Resize()
		end

		Label._Text = Label.Text
		Label.Text = nil
		setmetatable(Label, {
			__index = function(T, Key)
				if Key == "Text" then
					return rawget(T, "_Text")
				end
				return nil
			end,
			__newindex = function(T, Key, Value)
				if Key == "Text" then
					rawset(T, "_Text", Value)
					TextLabel.Text = Value
					T:Display()
					Groupbox:Resize()
					return
				end
				rawset(T, Key, Value)
			end,
		})

		if Label.DoesWrap then
			Label:Display()

			local Last = TextLabel.AbsoluteSize
			TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if TextLabel.AbsoluteSize == Last then
					return
				end

				Label:Display()
				Last = TextLabel.AbsoluteSize

				Groupbox:Resize()
			end)
		else
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 6),
				Parent = TextLabel,
			})
		end

		Groupbox:Resize()

		Label.TextLabel = TextLabel
		Label.Container = Container
		if not Data.DoesWrap then
			setmetatable(Label, BaseAddons)
		end

		Label.Holder = TextLabel
		table.insert(Groupbox.Elements, Label)

		if Data.Idx then
			Labels[Data.Idx] = Label
		else
			table.insert(Labels, Label)
		end

		function Label:Destroy()
			Label.Destroyed = true

			if Label.Connections then
				for _, Connection in Label.Connections do
					Connection:Disconnect()
				end
			end

			if Label.Addons then
				for Index = #Label.Addons, 1, -1 do
					local Addon = table.remove(Label.Addons, Index)
					if Addon and Addon.Destroy then
						Addon:Destroy()
					end
				end
			end

			if TextLabel then
				TextLabel:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Label)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()

			if Data.Idx then
				Labels[Data.Idx] = nil
			else
				local LblIdx = table.find(Labels, Label)

				if LblIdx then
					table.remove(Labels, LblIdx)
				end
			end
		end

		return Label
	end

	function Funcs:AddButton(...)
		if self.Destroyed then
			return nil
		end

		local function GetInfo(...)
			local Info = {}

			local First = select(1, ...)
			local Second = select(2, ...)

			if typeof(First) == "table" or typeof(Second) == "table" then
				local Params = typeof(First) == "table" and First or Second

				Info.Text = Params.Text or ""
				Info.Func = Params.Func or Params.Callback or function() end
				Info.DoubleClick = Params.DoubleClick

				Info.Tooltip = Params.Tooltip
				Info.DisabledTooltip = Params.DisabledTooltip

				Info.Risky = Params.Risky or false
				Info.Disabled = Params.Disabled or false
				Info.Visible = Params.Visible or true
				Info.Idx = typeof(Second) == "table" and First or nil
			else
				Info.Text = First or ""
				Info.Func = Second or function() end
				Info.DoubleClick = false

				Info.Tooltip = nil
				Info.DisabledTooltip = nil

				Info.Risky = false
				Info.Disabled = false
				Info.Visible = true
				Info.Idx = select(3, ...) or nil
			end

			return Info
		end
		local Info = GetInfo(...)

		local Groupbox = self
		local Container = Groupbox.Container

		local Button = {
			Connections = {},
			Destroyed = false,

			Text = Info.Text,
			Func = Info.Func,
			DoubleClick = Info.DoubleClick,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Risky = Info.Risky,
			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Tween = nil,
			Type = "Button",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 21),
			Parent = Container,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = UDim.new(0, 9),
			Parent = Holder,
		})

		local function CreateButton(Button)
			local Base = New("TextButton", {
				Active = not Button.Disabled,
				BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
				Size = UDim2.fromScale(1, 1),
				Text = Button.Text,
				TextSize = 14,
				TextTransparency = 0.4,
				Visible = Button.Visible,
				Parent = Holder,
			})

			local Stroke = New("UIStroke", {
				Color = "OutlineColor",
				Transparency = Button.Disabled and 0.5 or 0,
				Parent = Base,
			})

			MakeGradient(Base)

			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius / 2),
					Parent = Base,
				})
			)

			return Base, Stroke
		end

		local function InitEvents(Button)
			Button.Base.MouseEnter:Connect(function()
				if Button.Disabled then
					return
				end

				Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
					TextTransparency = 0,
				})
				Button.Tween:Play()
			end)
			Button.Base.MouseLeave:Connect(function()
				if Button.Disabled then
					return
				end

				Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
					TextTransparency = 0.4,
				})
				Button.Tween:Play()
			end)

			Button.Base.MouseButton1Click:Connect(function()
				if Button.Disabled or Button.Locked then
					return
				end
				Library:PlayClickSound()

				if Button.DoubleClick then
					Button.Locked = true

					Button.Base.Text = "Are you sure?"
					Button.Base.TextColor3 = Library.Scheme.AccentColor
					Library.Registry[Button.Base].TextColor3 = "AccentColor"

					local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

					Button.Base.Text = Button.Text
					Button.Base.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
					Library.Registry[Button.Base].TextColor3 = Button.Risky and "RedColor" or "FontColor"

					if Clicked then
						Library:SafeCallback(Button.Func)
					end

					RunService.RenderStepped:Wait() --// Mouse Button fires without waiting (i hate roblox)
					Button.Locked = false
					return
				end

				Library:SafeCallback(Button.Func)
			end)
		end

		Button.Base, Button.Stroke = CreateButton(Button)
		InitEvents(Button)

		function Button:AddButton(...)
			local Info = GetInfo(...)

			local SubButton = {
				Connections = {},
				Destroyed = false,

				Text = Info.Text,
				Func = Info.Func,
				DoubleClick = Info.DoubleClick,

				Tooltip = Info.Tooltip,
				DisabledTooltip = Info.DisabledTooltip,
				TooltipTable = nil,

				Risky = Info.Risky,
				Disabled = Info.Disabled,
				Visible = Info.Visible,

				Tween = nil,
				Type = "SubButton",
			}

			Button.SubButton = SubButton
			SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
			InitEvents(SubButton)

			function SubButton:UpdateColors()
				if Library.Unloaded then
					return
				end

				StopTween(SubButton.Tween)

				SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor
					or Library.Scheme.MainColor
				SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
				SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

				Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
					or "MainColor"
			end

			function SubButton:SetDisabled(Disabled: boolean)
				SubButton.Disabled = Disabled

				if SubButton.TooltipTable then
					SubButton.TooltipTable.Disabled = SubButton.Disabled
				end

				SubButton.Base.Active = not SubButton.Disabled
				SubButton:UpdateColors()
			end

			function SubButton:SetVisible(Visible: boolean)
				SubButton.Visible = Visible

				SubButton.Base.Visible = SubButton.Visible
				Groupbox:Resize()
			end

			function SubButton:SetText(Text: string)
				SubButton.Text = Text
				SubButton.Base.Text = Text
			end

			if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
				SubButton.TooltipTable =
					Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
				SubButton.TooltipTable.Disabled = SubButton.Disabled
			end

			if SubButton.Risky then
				SubButton.Base.TextColor3 = Library.Scheme.RedColor
				Library.Registry[SubButton.Base].TextColor3 = "RedColor"
			end

			SubButton:UpdateColors()

			if Info.Idx then
				Buttons[Info.Idx] = SubButton
			else
				table.insert(Buttons, SubButton)
			end

			SubButton.AddKeyPicker = BaseAddons.__index.AddKeyPicker

			function SubButton:Destroy()
				SubButton.Destroyed = true

				if SubButton.TooltipTable then
					SubButton.TooltipTable:Destroy()
				end

				if SubButton.Tween then
					SubButton.Tween:Destroy()
				end

				if SubButton.Base then
					SubButton.Base:Destroy()
				end

				if Info.Idx then
					Buttons[Info.Idx] = nil
				else
					local BIdx = table.find(Buttons, SubButton)

					if BIdx then
						table.remove(Buttons, BIdx)
					end
				end
			end

			return SubButton
		end

		function Button:UpdateColors()
			if Library.Unloaded then
				return
			end

			StopTween(Button.Tween)

			Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor
				or Library.Scheme.MainColor
			Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
			Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

			Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
		end

		function Button:SetDisabled(Disabled: boolean)
			Button.Disabled = Disabled

			if Button.TooltipTable then
				Button.TooltipTable.Disabled = Button.Disabled
			end

			Button.Base.Active = not Button.Disabled
			Button:UpdateColors()
		end

		function Button:SetVisible(Visible: boolean)
			Button.Visible = Visible

			Holder.Visible = Button.Visible
			Groupbox:Resize()
		end

		function Button:SetText(Text: string)
			Button.Text = Text
			Button.Base.Text = Text
		end

		if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
			Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
			Button.TooltipTable.Disabled = Button.Disabled
		end

		if Button.Risky then
			Button.Base.TextColor3 = Library.Scheme.RedColor
			Library.Registry[Button.Base].TextColor3 = "RedColor"
		end

		Button:UpdateColors()
		Groupbox:Resize()

		Button.Holder = Holder
		table.insert(Groupbox.Elements, Button)

		if Info.Idx then
			Buttons[Info.Idx] = Button
		else
			table.insert(Buttons, Button)
		end

		Button.AddKeyPicker = BaseAddons.__index.AddKeyPicker

		function Button:Destroy()
			Button.Destroyed = true

			if Button.TooltipTable then
				Button.TooltipTable:Destroy()
			end

			if Button.Tween then
				Button.Tween:Destroy()
			end

			if Button.SubButton then
				Button.SubButton:Destroy()
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Button)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()

			if Info.Idx then
				Buttons[Info.Idx] = nil
			else
				local BIdx = table.find(Buttons, Button)

				if BIdx then
					table.remove(Buttons, BIdx)
				end
			end
		end

		return Button
	end

	function Funcs:AddCheckbox(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.Toggle)

		local Groupbox = self
		local Container = Groupbox.Container

		local Toggle = {
			Connections = {},
			Destroyed = false,

			Text = Info.Text,
			Value = Info.Default,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Risky = Info.Risky,
			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Addons = {},
			AnyKeyPickerPicking = false,

			Variant = "Checkbox",
			Type = "Toggle",
		}

		local Button = New("TextButton", {
			Active = not Toggle.Disabled,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Text = "",
			Visible = Toggle.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(26, 0),
			Size = UDim2.new(1, -26, 1, 0),
			Text = Toggle.Text,
			TextSize = 14,
			TextTransparency = 0.4,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Button,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 6),
			Parent = Label,
		})

		local Checkbox = New("Frame", {
			BackgroundColor3 = "MainColor",
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Parent = Button,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = Checkbox,
			})
		)

		local CheckboxStroke = New("UIStroke", {
			Color = "OutlineColor",
			Parent = Checkbox,
		})

		local CheckImage = New("ImageLabel", {
			Image = CheckIcon and CheckIcon.Url or "",
			ImageColor3 = "FontColor",
			ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
			ImageTransparency = 1,
			Position = UDim2.fromOffset(2, 2),
			Size = UDim2.new(1, -4, 1, -4),
			Parent = Checkbox,
		})

		function Toggle:UpdateColors()
			Toggle:Display()
		end

		function Toggle:Display()
			if Library.Unloaded then
				return
			end

			CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

			if Toggle.Disabled then
				Label.TextTransparency = 0.8
				CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

				Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
				Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

				return
			end

			TweenService:Create(Label, Library.TweenInfo, {
				TextTransparency = Toggle.Value and 0 or 0.4,
			}):Play()
			TweenService:Create(CheckImage, Library.TweenInfo, {
				ImageTransparency = Toggle.Value and 0 or 1,
			}):Play()

			Checkbox.BackgroundColor3 = Library.Scheme.MainColor
			Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
		end

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
		end

		function Toggle:RunChanged()
			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end

		function Toggle:SetValue(Value)
			if Toggle.Disabled then
				return
			end

			Toggle.Value = Value
			Toggle:Display()

			for _, Addon in Toggle.Addons do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon.Toggled = Toggle.Value
					Addon:Update()
				end
			end

			Library:UpdateDependencyBoxes()

			if not Toggle.AnyKeyPickerPicking then
				Toggle:RunChanged()
			end
		end

		function Toggle:SetDisabled(Disabled: boolean)
			Toggle.Disabled = Disabled

			if Toggle.TooltipTable then
				Toggle.TooltipTable.Disabled = Toggle.Disabled
			end

			for _, Addon in Toggle.Addons do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon:Update()
				end
			end

			Button.Active = not Toggle.Disabled
			Toggle:Display()
		end

		function Toggle:SetVisible(Visible: boolean)
			Toggle.Visible = Visible

			Button.Visible = Toggle.Visible
			Groupbox:Resize()
		end

		function Toggle:SetText(Text: string)
			Toggle.Text = Text
			Label.Text = Text
		end

		table.insert(
			Toggle.Connections,
			Button.MouseButton1Click:Connect(function()
				if Toggle.Disabled then
					return
				end
				Library:PlayClickSound() -- <-- TAMBAH INI
				Toggle:SetValue(not Toggle.Value)
			end)
		)

		if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
			Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
			Toggle.TooltipTable.Disabled = Toggle.Disabled
		end

		if Toggle.Risky then
			Label.TextColor3 = Library.Scheme.RedColor
			Library.Registry[Label].TextColor3 = "RedColor"
		end

		Toggle:Display()
		Groupbox:Resize()

		Toggle.TextLabel = Label
		Toggle.Container = Container
		setmetatable(Toggle, BaseAddons)

		Toggle.Holder = Button
		table.insert(Groupbox.Elements, Toggle)

		Toggle.Default = Toggle.Value

		Toggles[Idx] = Toggle

		function Toggle:Destroy()
			Toggle.Destroyed = true

			if Toggle.Connections then
				for _, Connection in Toggle.Connections do
					Connection:Disconnect()
				end
			end

			if Toggle.TooltipTable then
				Toggle.TooltipTable:Destroy()
			end

			if Button then
				Button:Destroy()
			end

			if Toggle.Addons then
				for Index = #Toggle.Addons, 1, -1 do
					local Addon = table.remove(Toggle.Addons, Index)
					if Addon and Addon.Destroy then
						Addon:Destroy()
					end
				end
			end

			local ElemIdx = table.find(Groupbox.Elements, Toggle)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Toggles[Idx] = nil
		end

		return Toggle
	end

	function Funcs:AddToggle(Idx, Info)
		if self.Destroyed then
			return nil
		end

		if Library.ForceCheckbox then
			return Funcs.AddCheckbox(self, Idx, Info)
		end

		Info = Library:Validate(Info, Templates.Toggle)

		local Groupbox = self
		local Container = Groupbox.Container

		local Toggle = {
			Connections = {},
			Destroyed = false,

			Text = Info.Text,
			Value = Info.Default,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Risky = Info.Risky,
			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Addons = {},
			AnyKeyPickerPicking = false,

			Variant = "Switch",
			Type = "Toggle",
		}

		local Button = New("TextButton", {
			Active = not Toggle.Disabled,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Text = "",
			Visible = Toggle.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -40, 1, 0),
			Text = Toggle.Text,
			TextSize = 14,
			TextTransparency = 0.4,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Button,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 6),
			Parent = Label,
		})

		local Switch = New("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = "MainColor",
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(32, 18),
			Parent = Button,
		})
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = Switch,
		})
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2),
			PaddingTop = UDim.new(0, 2),
			Parent = Switch,
		})
		local SwitchStroke = New("UIStroke", {
			Color = "OutlineColor",
			Parent = Switch,
		})

		local Ball = New("Frame", {
			BackgroundColor3 = "FontColor",
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Parent = Switch,
		})
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = Ball,
		})

		function Toggle:UpdateColors()
			Toggle:Display()
		end

		function Toggle:Display()
			if Library.Unloaded then
				return
			end

			local Offset = Toggle.Value and 1 or 0

			Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
			SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

			Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
			SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

			Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
			Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

			if Toggle.Disabled then
				Label.TextTransparency = 0.8
				Ball.AnchorPoint = Vector2.new(Offset, 0)
				Ball.Position = UDim2.fromScale(Offset, 0)

				Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
				Library.Registry[Ball].BackgroundColor3 = function()
					return Library:GetDarkerColor(Library.Scheme.FontColor)
				end

				return
			end

			TweenService:Create(Label, Library.TweenInfo, {
				TextTransparency = Toggle.Value and 0 or 0.4,
			}):Play()
			TweenService:Create(Ball, Library.TweenInfo, {
				AnchorPoint = Vector2.new(Offset, 0),
				Position = UDim2.fromScale(Offset, 0),
			}):Play()

			Ball.BackgroundColor3 = Library.Scheme.FontColor
			Library.Registry[Ball].BackgroundColor3 = "FontColor"
		end

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
		end

		function Toggle:RunChanged()
			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end

		function Toggle:SetValue(Value)
			if Toggle.Disabled then
				return
			end

			Toggle.Value = Value
			Toggle:Display()

			for _, Addon in Toggle.Addons do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon.Toggled = Toggle.Value
					Addon:Update()
				end
			end

			Library:UpdateDependencyBoxes()

			if not Toggle.AnyKeyPickerPicking then
				Toggle:RunChanged()
			end
		end

		function Toggle:SetDisabled(Disabled: boolean)
			Toggle.Disabled = Disabled

			if Toggle.TooltipTable then
				Toggle.TooltipTable.Disabled = Toggle.Disabled
			end

			for _, Addon in Toggle.Addons do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon:Update()
				end
			end

			Button.Active = not Toggle.Disabled
			Toggle:Display()
		end

		function Toggle:SetVisible(Visible: boolean)
			Toggle.Visible = Visible

			Button.Visible = Toggle.Visible
			Groupbox:Resize()
		end

		function Toggle:SetText(Text: string)
			Toggle.Text = Text
			Label.Text = Text
		end

		table.insert(
			Toggle.Connections,
			Button.MouseButton1Click:Connect(function()
				if Toggle.Disabled then
					return
				end
				Library:PlayClickSound() -- <-- TAMBAH INI
				Toggle:SetValue(not Toggle.Value)
			end)
		)

		if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
			Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
			Toggle.TooltipTable.Disabled = Toggle.Disabled
		end

		if Toggle.Risky then
			Label.TextColor3 = Library.Scheme.RedColor
			Library.Registry[Label].TextColor3 = "RedColor"
		end

		Toggle:Display()
		Groupbox:Resize()

		Toggle.TextLabel = Label
		Toggle.Container = Container
		setmetatable(Toggle, BaseAddons)

		Toggle.Holder = Button
		table.insert(Groupbox.Elements, Toggle)

		Toggle.Default = Toggle.Value

		Toggles[Idx] = Toggle

		function Toggle:Destroy()
			Toggle.Destroyed = true

			if Toggle.Connections then
				for _, Connection in Toggle.Connections do
					Connection:Disconnect()
				end
			end

			if Toggle.TooltipTable then
				Toggle.TooltipTable:Destroy()
			end

			if Button then
				Button:Destroy()
			end

			if Toggle.Addons then
				for Index = #Toggle.Addons, 1, -1 do
					local Addon = table.remove(Toggle.Addons, Index)
					if Addon and Addon.Destroy then
						Addon:Destroy()
					end
				end
			end

			local ElemIdx = table.find(Groupbox.Elements, Toggle)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Toggles[Idx] = nil
		end

		return Toggle
	end

	function Funcs:AddInput(Idx, Info)
		if self.Destroyed then
			return nil
		end

		if typeof(Info) == "table" and (typeof(Info.VerifyValue) == "function" and Info.Finished ~= true) then
			Info.Finished = true
		end

		Info = Library:Validate(Info, Templates.Input)

		local Groupbox = self
		local Container = Groupbox.Container

		local Input = {
			Connections = {},
			Destroyed = false,

			Text = Info.Text,
			Value = Info.Default,

			Finished = Info.Finished,
			Numeric = Info.Numeric,
			ClearTextOnFocus = Info.ClearTextOnFocus,
			ClearTextOnBlur = Info.ClearTextOnBlur,
			Placeholder = Info.Placeholder,
			AllowEmpty = Info.AllowEmpty,
			EmptyReset = Info.EmptyReset,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,
			VerifyValue = Info.VerifyValue,

			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Type = "Input",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 39),
			Visible = Input.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			Text = Input.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Holder,
		})

		local Box = New("TextBox", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
			PlaceholderText = Input.Placeholder,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 21),
			Text = Input.Value,
			TextEditable = not Input.Disabled,
			TextScaled = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Holder,
		})

		MakeGradient(Box)

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 3),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 4),
			Parent = Box,
		})

		New("UIStroke", {
			Color = "OutlineColor",
			Parent = Box,
		})

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = Box,
			})
		)

		function Input:UpdateColors()
			if Library.Unloaded then
				return
			end

			Label.TextTransparency = Input.Disabled and 0.8 or 0
			Box.TextTransparency = Input.Disabled and 0.8 or 0
		end

		function Input:OnChanged(Func)
			Input.Changed = Func
		end

		function Input:RunChanged()
			Library:SafeCallback(Input.Callback, Input.Value)
			Library:SafeCallback(Input.Changed, Input.Value)
		end

		function Input:SetValue(Text)
			if not Input.AllowEmpty and Trim(Text) == "" then
				Text = Input.EmptyReset
			end

			if Info.MaxLength and #Text > Info.MaxLength then
				Text = Text:sub(1, Info.MaxLength)
			end

			if Input.Numeric then
				if #tostring(Text) > 0 and not tonumber(Text) then
					Text = Input.Value
				end
			end

			if
				typeof(Info.VerifyValue) == "function"
				and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true)
			then
				Text = Input.EmptyReset
			end

			Input.Value = Text
			Box.Text = Text

			if not Input.Disabled then
				Input:RunChanged()
			end
		end

		function Input:SetDisabled(Disabled: boolean)
			Input.Disabled = Disabled

			if Input.TooltipTable then
				Input.TooltipTable.Disabled = Input.Disabled
			end

			Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
			Box.TextEditable = not Input.Disabled
			Input:UpdateColors()
		end

		function Input:SetVisible(Visible: boolean)
			Input.Visible = Visible

			Holder.Visible = Input.Visible
			Groupbox:Resize()
		end

		function Input:SetText(Text: string)
			Input.Text = Text
			Label.Text = Text
		end

		if Input.Finished then
			table.insert(
				Input.Connections,
				Box.FocusLost:Connect(function(Enter)
					if not Enter then
						if Input.ClearTextOnBlur then
							Box.Text = Input.Value
						end

						return
					end

					Input:SetValue(Box.Text)
				end)
			)
		else
			table.insert(
				Input.Connections,
				Box:GetPropertyChangedSignal("Text"):Connect(function()
					if Box.Text == Input.Value then
						return
					end

					Input:SetValue(Box.Text)
				end)
			)
		end

		if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
			Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
			Input.TooltipTable.Disabled = Input.Disabled
		end

		Groupbox:Resize()

		Input.Holder = Holder
		table.insert(Groupbox.Elements, Input)

		Input.Default = Input.Value
		if
			typeof(Info.VerifyValue) == "function"
			and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true)
		then
			Input:SetValue(Input.EmptyReset)
			Input.Default = Input.EmptyReset
		end

		Options[Idx] = Input

		function Input:Destroy()
			Input.Destroyed = true

			if Input.Connections then
				for _, Connection in Input.Connections do
					Connection:Disconnect()
				end
			end

			if Input.TooltipTable then
				Input.TooltipTable:Destroy()
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Input)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Input
	end

	function Funcs:AddSlider(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.Slider)

		local Groupbox = self
		local Container = Groupbox.Container

		local Slider = {
			Connections = {},
			Destroyed = false,

			Text = Info.Text,
			Value = Info.Default,

			Min = Info.Min,
			Max = Info.Max,

			Prefix = Info.Prefix,
			Suffix = Info.Suffix,
			Compact = Info.Compact,
			Rounding = Info.Rounding,
			HideMax = Info.HideMax,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Disabled = Info.Disabled,
			Visible = Info.Visible,

			AllowRightClickInput = Info.AllowRightClickInput,

			Type = "Slider",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
			Visible = Slider.Visible,
			Parent = Container,
		})

		local SliderLabel
		if not Info.Compact then
			SliderLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 14),
				Text = Slider.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Holder,
			})
		end

		local Bar = New("TextButton", {
			Active = not Slider.Disabled,
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 15),
			Text = "",
			Parent = Holder,
		})
		Bar:SetAttribute("NoGlowPulse", true)

		New("UIStroke", {
			Color = "OutlineColor",
			Parent = Bar,
		})
		MakeGradient(Bar)


		local DisplayLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			TextSize = 14,
			ZIndex = Bar.ZIndex + 2,
			Parent = Bar,
		})
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Color = "DarkColor",
			LineJoinMode = Enum.LineJoinMode.Miter,
			Parent = DisplayLabel,
		})

		local InputTextBox
		if Info.AllowRightClickInput then
			InputTextBox = New("TextBox", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = "",
				TextSize = 14,
				ZIndex = Bar.ZIndex + 3,
				Visible = false,
				ClearTextOnFocus = false,
				Parent = Bar,
			})
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				Color = "DarkColor",
				LineJoinMode = Enum.LineJoinMode.Miter,
				Parent = InputTextBox,
			})
		end

		local Fill = New("Frame", {
			BackgroundColor3 = "AccentColor",
			Size = UDim2.fromScale(0.5, 1),
			ZIndex = Bar.ZIndex + 1,
			Parent = Bar,
		})

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = Bar,
			})
		)

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius / 2),
				Parent = Fill,
			})
		)

		function Slider:UpdateColors()
			if Library.Unloaded then
				return
			end

			if SliderLabel then
				SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
			end
			DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0

			if Info.AllowRightClickInput then
				InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
			end

			Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
			Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
		end

		function Slider:Display()
			if Library.Unloaded then
				return
			end

			local CustomDisplayText = nil
			if Info.FormatDisplayValue then
				CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
			end

			if CustomDisplayText then
				DisplayLabel.Text = tostring(CustomDisplayText)
			else
				if Info.Compact then
					DisplayLabel.Text =
						string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
				elseif Info.HideMax then
					DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
				else
					DisplayLabel.Text = string.format(
						"%s%s%s/%s%s%s",
						Slider.Prefix,
						Slider.Value,
						Slider.Suffix,
						Slider.Prefix,
						Slider.Max,
						Slider.Suffix
					)
				end
			end

			local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
			Fill.Size = UDim2.fromScale(X, 1)
		end

		function Slider:OnChanged(Func)
			Slider.Changed = Func
		end

		function Slider:SetMax(Value)
			assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

			Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
			Slider.Max = Value
			Slider:Display()
		end

		function Slider:SetMin(Value)
			assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

			Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
			Slider.Min = Value
			Slider:Display()
		end

		function Slider:RunChanged()
			Library:SafeCallback(Slider.Callback, Slider.Value)
			Library:SafeCallback(Slider.Changed, Slider.Value)
		end

		function Slider:SetValue(Str)
			if Slider.Disabled then
				return
			end

			local Num = tonumber(Str)
			if not Num or Num == Slider.Value then
				return
			end

			Num = math.clamp(Num, Slider.Min, Slider.Max)

			Slider.Value = Num
			Slider:Display()

			Slider:RunChanged()
		end

		function Slider:SetDisabled(Disabled: boolean)
			Slider.Disabled = Disabled

			if Slider.TooltipTable then
				Slider.TooltipTable.Disabled = Slider.Disabled
			end

			Bar.Active = not Slider.Disabled
			Slider:UpdateColors()
		end

		function Slider:SetVisible(Visible: boolean)
			Slider.Visible = Visible

			Holder.Visible = Slider.Visible
			Groupbox:Resize()
		end

		function Slider:SetText(Text: string)
			Slider.Text = Text
			if SliderLabel then
				SliderLabel.Text = Text
				return
			end
			Slider:Display()
		end

		function Slider:SetPrefix(Prefix: string)
			Slider.Prefix = Prefix
			Slider:Display()
		end

		function Slider:SetSuffix(Suffix: string)
			Slider.Suffix = Suffix
			Slider:Display()
		end

		if Info.AllowRightClickInput then
			local LastValidText = ""
			table.insert(
				Slider.Connections,
				InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
					local Text = InputTextBox.Text
					local AsNum = tonumber(Text)

					if #tostring(Text) > 0 and not AsNum and Text ~= "-" then
						InputTextBox.Text = LastValidText
					else
						if Slider.Rounding == 0 and Text:find("%.") then
							InputTextBox.Text = LastValidText
							return
						end

						local DecimalPos = Text:find("%.")
						if DecimalPos and Slider.Rounding > 0 then
							local Decimals = #Text - DecimalPos
							if Decimals > Slider.Rounding then
								InputTextBox.Text = LastValidText
								return
							end
						end

						LastValidText = Text

						if AsNum then
							if AsNum > Slider.Max then
								InputTextBox.Text = tostring(Slider.Max)
							elseif AsNum < Slider.Min then
								InputTextBox.Text = tostring(Slider.Min)
							end
						end
					end
				end)
			)

			table.insert(
				Slider.Connections,
				InputTextBox.FocusLost:Connect(function()
					InputTextBox.Visible = false
					DisplayLabel.Visible = true

					local Num = tonumber(InputTextBox.Text)
					if not Num then
						return
					end

					Num = Round(Num, Slider.Rounding)
					Slider:SetValue(Num)
				end)
			)
		end

		local LastTap = 0
		table.insert(
			Slider.Connections,
			Bar.InputBegan:Connect(function(Input: InputObject)
				local ValidInput = IsClickInput(Input) or Input.UserInputType == Enum.UserInputType.MouseButton2
				if not ValidInput or Slider.Disabled then
					return
				end

				if Info.AllowRightClickInput then
					local IsRightClick = Input.UserInputType == Enum.UserInputType.MouseButton2
					local IsDoubleTap = false

					if Library.IsMobile and Input.UserInputType == Enum.UserInputType.Touch then
						if tick() - LastTap < 0.3 then
							IsDoubleTap = true
						end

						LastTap = tick()
					end

					if IsRightClick or IsDoubleTap then
						InputTextBox.Text = tostring(Slider.Value)
						InputTextBox.Visible = true
						DisplayLabel.Visible = false

						task.spawn(InputTextBox.CaptureFocus, InputTextBox)
						return
					end
				end

				if not IsClickInput(Input) then
					return
				end

				if Library.ActiveTab then
					for _, Side in Library.ActiveTab.Sides do
						Side.ScrollingEnabled = false
					end
				end

				if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
					Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = false
				end

				local SliderDragging = true
				local SliderDragKind = Input.UserInputType

				local SliderReleaseConn = nil
				SliderReleaseConn = UserInputService.InputEnded:Connect(function(EndInput: InputObject)
					if EndInput.UserInputType == SliderDragKind then
						SliderDragging = false
						if SliderReleaseConn then
							SliderReleaseConn:Disconnect()
							SliderReleaseConn = nil
						end
					end
				end)
				table.insert(Slider.Connections, SliderReleaseConn)

				while SliderDragging and not Slider.Destroyed do
					local Location = Mouse.X
					local BarWidth = Bar.AbsoluteSize.X
					local Scale = (BarWidth > 0)
						and math.clamp((Location - Bar.AbsolutePosition.X) / BarWidth, 0, 1)
						or 0

					local OldValue = Slider.Value
					Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding)

					Slider:Display()
					if Slider.Value ~= OldValue then
						Slider:RunChanged()
					end

					RunService.RenderStepped:Wait()
				end

				SliderDragging = false
				if SliderReleaseConn then
					SliderReleaseConn:Disconnect()
					SliderReleaseConn = nil
				end

				if Library.ActiveTab then
					for _, Side in Library.ActiveTab.Sides do
						Side.ScrollingEnabled = true
					end
				end

				if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
					Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = true
				end
			end)
		)

		if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
			Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
			Slider.TooltipTable.Disabled = Slider.Disabled
		end

		Slider:UpdateColors()
		Slider:Display()
		Groupbox:Resize()

		Slider.Holder = Holder
		table.insert(Groupbox.Elements, Slider)

		Slider.Default = Slider.Value

		Options[Idx] = Slider

		function Slider:Destroy()
			Slider.Destroyed = true

			if Slider.Connections then
				for _, Connection in Slider.Connections do
					Connection:Disconnect()
				end
			end

			if Slider.TooltipTable then
				Slider.TooltipTable:Destroy()
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Slider)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Slider
	end

	function Funcs:AddDropdown(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.Dropdown)

		local Groupbox = self
		local Container = Groupbox.Container

		if Info.SpecialType == "Player" then
			Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
			Info.AllowNull = true
		elseif Info.SpecialType == "Team" then
			Info.Values = GetTeams()
			Info.AllowNull = true
		end

		local Dropdown = {
			Connections = {},
			Destroyed = false,

			Text = typeof(Info.Text) == "string" and Info.Text or nil,

			Value = Info.Multi and {} or nil,
			Values = Info.Values,
			DisabledValues = Info.DisabledValues,
			ValueImages = Info.ValueImages,

			Multi = Info.Multi,
			DragSelect = Info.Multi and not Library.IsMobile and Info.DragSelect == true,

			SpecialType = Info.SpecialType,
			ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
			EnablePlayerImages = Info.EnablePlayerImages,

			Tooltip = Info.Tooltip,
			DisabledTooltip = Info.DisabledTooltip,
			TooltipTable = nil,

			Callback = Info.Callback,
			Changed = Info.Changed,

			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Type = "Dropdown",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
			Visible = Dropdown.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			Text = Dropdown.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = not not Info.Text,
			ZIndex = 3,
			Parent = Holder,
		})

		local DisplayContainer = New("TextButton", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 21),
			Text = "",
			TextTransparency = 1,
			ZIndex = 2,
			Parent = Holder,
		})

		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 4),
			Parent = DisplayContainer,
		})

		New("UIStroke", {
			Color = "OutlineColor",
			Parent = DisplayContainer,
		})

		MakeGradient(DisplayContainer)
		local DropdownCorner = New("UICorner", {
			TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = DisplayContainer,
		})
		table.insert(Library.SpecificCorners, DropdownCorner)

		local DisplayImage = New("ImageLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(-4, 3),
			Size = UDim2.fromOffset(16, 16),
			Image = "",
			ImageTransparency = 1,
			ZIndex = 2,
			Parent = DisplayContainer,
		})

		local DisplayButton = New("TextButton", {
			Active = not Dropdown.Disabled,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 21),
			Text = "---",
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
			Parent = DisplayContainer,
		})

		local ArrowImage = New("ImageLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Image = ArrowIcon and ArrowIcon.Url or "",
			ImageColor3 = "FontColor",
			ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
			ImageTransparency = 0.5,
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.fromOffset(16, 16),
			Parent = DisplayContainer,
		})

		local SearchBox
		if Info.Searchable then
			SearchBox = New("TextBox", {
				BackgroundTransparency = 1,
				PlaceholderText = "Search...",
				Position = UDim2.fromOffset(-8, 0),
				Size = UDim2.new(1, -12, 1, 0),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false,
				Parent = DisplayButton,
			})
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				Parent = SearchBox,
			})
		end

		local GetValueImage = function(Value)
			if not Value then
				return nil
			end

			local ValueImage = nil
			if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
				if typeof(Value) == "Instance" and Value:IsA("Player") then
					ValueImage = {
						Url = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48", tostring(Value.UserId)),
					}
				end
			else
				if Info.ValueImages and Info.ValueImages[Value] then
					ValueImage = Library:GetCustomIcon(Info.ValueImages[Value])
				end
			end

			return ValueImage
		end

		local MenuTable = Library:AddContextMenu(
			DisplayContainer,
			function()
				return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), 0)
			end,
			function()
				return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
			end,
			2,
			function(Active: boolean)
				DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0

				ArrowImage.ImageTransparency = Active and 0 or 0.5
				ArrowImage.Rotation = Active and 180 or 0

				if SearchBox then
					SearchBox.Text = ""
					SearchBox.Visible = Active
				end

				DropdownCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
				DropdownCorner.BottomLeftRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
			end,
			false,
			"bottom",
			"Dropdown"
		)
		Dropdown.Menu = MenuTable
		MakeGradient(MenuTable.Menu)

		function Dropdown:RecalculateListSize(Count)
			local Y = math.clamp((Count or GetTableSize(Dropdown.Values)) * 21, 0, Info.MaxVisibleDropdownItems * 21)

			MenuTable:SetSize(function()
				return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), Y)
			end)
		end

		function Dropdown:UpdateColors()
			if Library.Unloaded then
				return
			end

			Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
			DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
			DisplayImage.ImageTransparency = Dropdown.Disabled and 0.8 or 0
			ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5
		end

		function Dropdown:Display()
			if Library.Unloaded then
				return
			end

			local Str = ""
			local ValueImage = nil

			if Info.Multi then
				for _, Value in Dropdown.Values do
					if Dropdown.Value[Value] then
						if not ValueImage then
							ValueImage = GetValueImage(Value)
						end

						Str = Str
							.. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(Value)) or tostring(Value))
							.. ", "
					end
				end

				Str = Str:sub(1, #Str - 2)
			else
				ValueImage = GetValueImage(Dropdown.Value)
				Str = Dropdown.Value and tostring(Dropdown.Value) or ""

				if Str ~= "" and Info.FormatDisplayValue then
					Str = tostring(Info.FormatDisplayValue(Str))
				end
			end

			if #Str > 25 then
				Str = Str:sub(1, 22) .. "..."
			end

			DisplayButton.Text = (Str == "" and "---" or Str)

			if ValueImage then
				DisplayImage.Image = ValueImage.Url
				DisplayImage.ImageRectOffset = ValueImage.ImageRectOffset or Vector2.zero
				DisplayImage.ImageRectSize = ValueImage.ImageRectSize or Vector2.zero
				DisplayImage.ImageTransparency = 0
			else
				DisplayImage.Image = ""
				DisplayImage.ImageTransparency = 1
			end

			DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
			DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0)
		end

		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
		end

		function Dropdown:GetActiveValues(ReturnCount)
			local Table = {}

			if Info.Multi then
				for Value, _ in Dropdown.Value do
					table.insert(Table, Value)
				end
			else
				if Dropdown.Value then
					table.insert(Table, Dropdown.Value)
				end
			end

			return ReturnCount == true and GetTableSize(Table) or Table
		end

		local Buttons = {}
		local DragSelecting = false
		local DragStartIndex = nil
		local DragInitialValues = {}
		local DragInputEndedConn = nil
		local DragInputChangedConn = nil

		local function StopDragSelect()
			DragSelecting = false
			DragStartIndex = nil
			table.clear(DragInitialValues)

			if DragInputEndedConn then
				DragInputEndedConn:Disconnect()
				DragInputEndedConn = nil
			end

			if DragInputChangedConn then
				DragInputChangedConn:Disconnect()
				DragInputChangedConn = nil
			end
		end

		local function UpdateDrag(CurrentIndex)
			local Min = math.min(DragStartIndex, CurrentIndex)
			local Max = math.max(DragStartIndex, CurrentIndex)

			for OtherButton, OtherTable in Buttons do
				local InRange = OtherTable.Index >= Min and OtherTable.Index <= Max
				local Try = DragInitialValues[OtherTable.Value]
				if InRange then
					Try = not Try
				end

				if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
					Dropdown.Value[OtherTable.Value] = Try and true or nil
				end

				OtherTable:UpdateButton()
			end

			Dropdown:Display()
		end

		function Dropdown:BuildDropdownList()
			local Values = Dropdown.Values
			local DisabledValues = Dropdown.DisabledValues

			StopDragSelect()

			for Button, _ in Buttons do
				if not (Button and Button.Parent) then
					continue
				end

				Button.Parent:Destroy()
			end
			table.clear(Buttons)

			local Count = 0
			local ProcessedCount = 0
			local TotalLen = GetTableSize(Values) + GetTableSize(DisabledValues)

			for _, Value in Values do
				ProcessedCount += 1

				local FormattedValue = tostring(Info.FormatListValue and Info.FormatListValue(Value) or Value)
				if SearchBox and not FormattedValue:lower():match(SearchBox.Text:lower()) then
					continue
				end

				Count += 1

				local IsDisabled = table.find(DisabledValues, Value)
				local Table = {}
				local ValueImage = GetValueImage(Value)

				local Container = New("Frame", {
					BackgroundColor3 = "MainColor",
					BackgroundTransparency = 1,
					LayoutOrder = IsDisabled and 1 or 0,
					Size = UDim2.new(1, 0, 0, 21),
					Parent = MenuTable.Menu,
				})

				if ProcessedCount == TotalLen then
					local Corner = New("UICorner", {
						TopLeftRadius = UDim.new(0, 0),
						TopRightRadius = UDim.new(0, 0),
						BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
						BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
						Parent = Container,
					})
					table.insert(Library.SpecificCorners, Corner)
				end

				local Image = ValueImage
					and New("ImageLabel", {
						BackgroundTransparency = 1,
						Image = ValueImage.Url,
						ImageRectOffset = ValueImage.ImageRectOffset,
						ImageRectSize = ValueImage.ImageRectSize,
						ImageTransparency = 0.5,
						Size = UDim2.fromOffset(16, 16),
						Position = UDim2.fromOffset(4, 3),
						Parent = Container,
					})

				local Button = New("TextButton", {
					BackgroundTransparency = 1,
					Size = ValueImage and UDim2.new(1, -18, 0, 21) or UDim2.new(1, 0, 0, 21),
					Position = ValueImage and UDim2.fromOffset(18, 0) or UDim2.fromOffset(0, 0),
					Text = FormattedValue,
					TextSize = 14,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = Container,
				})
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 7),
					PaddingRight = UDim.new(0, 7),
					Parent = Button,
				})

				local Check = New("ImageLabel", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Image = CheckIcon and CheckIcon.Url or "",
					ImageColor3 = SelectedCheckColor,
					ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
					ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
					Position = UDim2.new(1, -7, 0.5, 0),
					Size = UDim2.fromOffset(14, 14),
					Visible = false,
					Parent = Container,
				})

				local Selected
				if Info.Multi then
					Selected = Dropdown.Value[Value]
				else
					Selected = Dropdown.Value == Value
				end

				function Table:UpdateButton()
					if Info.Multi then
						Selected = Dropdown.Value[Value]
					else
						Selected = Dropdown.Value == Value
					end

					Container.BackgroundTransparency = Selected and 0 or 1
					Button.TextTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
					Check.Visible = not not Selected

					if Image then
						Image.ImageTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
					end
				end

				Table.Index = Count
				Table.Value = Value

				if not IsDisabled then
					Button.MouseButton1Click:Connect(function()
						if DragSelecting then
							return
						end
						Library:PlayClickSound() -- <-- TAMBAH INI
						local Try = not Selected
						if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
							Selected = Try
							if Info.Multi then
								Dropdown.Value[Value] = Selected and true or nil
							else
								Dropdown.Value = Selected and Value or nil
							end

							for _, OtherButton in Buttons do
								OtherButton:UpdateButton()
							end
						end

						Table:UpdateButton()
						Dropdown:Display()

						Library:UpdateDependencyBoxes()
						Dropdown:RunChanged()
					end)

					if Info.Multi and Dropdown.DragSelect and not Library.IsMobile then
						Button.InputBegan:Connect(function(StartInput)
							if not IsMouseInput(StartInput) then
								return
							end

							DragSelecting = true
							DragStartIndex = Table.Index
							table.clear(DragInitialValues)

							for OtherButton, OtherTable in Buttons do
								DragInitialValues[OtherTable.Value] = Dropdown.Value[OtherTable.Value]
							end

							UpdateDrag(Table.Index)

							if DragInputEndedConn then
								DragInputEndedConn:Disconnect()
							end
							if DragInputChangedConn then
								DragInputChangedConn:Disconnect()
							end

							DragInputChangedConn =
								Library:GiveSignal(UserInputService.InputChanged:Connect(function(ChangeInput)
									if not IsMovementInput(ChangeInput) and ChangeInput ~= StartInput then
										return
									end

									local Pos = ChangeInput.Position
									for OtherButton, OtherTable in Buttons do
										if Library:MouseIsOverFrame(OtherButton, Pos) then
											UpdateDrag(OtherTable.Index)
											break
										end
									end
								end))

							DragInputEndedConn =
								Library:GiveSignal(UserInputService.InputEnded:Connect(function(EndInput)
									if
										EndInput ~= StartInput
										and not (
											IsMouseInput(EndInput)
											and EndInput.UserInputType == StartInput.UserInputType
										)
									then
										return
									end

									Library:UpdateDependencyBoxes()
									Dropdown:RunChanged()

									StopDragSelect()
								end))

							table.insert(Dropdown.Connections, DragInputEndedConn)
							table.insert(Dropdown.Connections, DragInputChangedConn)
						end)
					end
				end

				Table:UpdateButton()
				Dropdown:Display()

				Buttons[Button] = Table
			end

			Dropdown:RecalculateListSize(Count)
		end

		function Dropdown:RunChanged()
			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end

		function Dropdown:SetValue(Value)
			if Info.Multi then
				local Table = {}

				for Val, Active in Value or {} do
					if typeof(Active) ~= "boolean" then
						Table[Active] = true
					elseif Active and table.find(Dropdown.Values, Val) then
						Table[Val] = true
					end
				end

				Dropdown.Value = Table
			else
				if table.find(Dropdown.Values, Value) then
					Dropdown.Value = Value
				elseif not Value then
					Dropdown.Value = nil
				end
			end

			Dropdown:Display()
			for _, Button in Buttons do
				Button:UpdateButton()
			end

			if not Dropdown.Disabled then
				Library:UpdateDependencyBoxes()
				Dropdown:RunChanged()
			end
		end

		function Dropdown:SetValues(Values)
			Dropdown.Values = Values
			Dropdown:BuildDropdownList()
		end

		function Dropdown:AddValues(Values)
			if typeof(Values) == "table" then
				for _, val in Values do
					table.insert(Dropdown.Values, val)
				end
			elseif typeof(Values) == "string" then
				table.insert(Dropdown.Values, Values)
			else
				return
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:SetDisabledValues(DisabledValues)
			Dropdown.DisabledValues = DisabledValues
			Dropdown:BuildDropdownList()
		end

		function Dropdown:AddDisabledValues(DisabledValues)
			if typeof(DisabledValues) == "table" then
				for _, val in DisabledValues do
					table.insert(Dropdown.DisabledValues, val)
				end
			elseif typeof(DisabledValues) == "string" then
				table.insert(Dropdown.DisabledValues, DisabledValues)
			else
				return
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:SetValueImages(ValueImages)
			if typeof(ValueImages) ~= "table" then
				return
			end

			Dropdown.ValueImages = ValueImages
			Dropdown:BuildDropdownList()
		end

		function Dropdown:AddValueImages(ValueImages)
			if typeof(ValueImages) ~= "table" then
				return
			end

			for key, val in ValueImages do
				Dropdown.ValueImages[key] = val
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:SetDisabled(Disabled: boolean)
			Dropdown.Disabled = Disabled

			if Dropdown.TooltipTable then
				Dropdown.TooltipTable.Disabled = Dropdown.Disabled
			end

			MenuTable:Close()
			DisplayButton.Active = not Dropdown.Disabled
			Dropdown:UpdateColors()
		end

		function Dropdown:SetVisible(Visible: boolean)
			Dropdown.Visible = Visible

			Holder.Visible = Dropdown.Visible
			Groupbox:Resize()
		end

		function Dropdown:SetText(Text: string)
			Dropdown.Text = Text
			Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

			Label.Text = Text and Text or ""
			Label.Visible = not not Text
		end

		function Dropdown:SetDragSelect(Value: boolean)
			if not Info.Multi or Library.IsMobile then
				Value = false
			end

			Dropdown.DragSelect = Value == true
			Dropdown:BuildDropdownList()
		end

		local ToggleDropdown = function()
			if Dropdown.Disabled then
				return
			end
			Library:PlayClickSound() -- <-- TAMBAH INI
			MenuTable:Toggle()
		end

		table.insert(Dropdown.Connections, DisplayContainer.MouseButton1Click:Connect(ToggleDropdown))
		table.insert(Dropdown.Connections, DisplayButton.MouseButton1Click:Connect(ToggleDropdown))

		if SearchBox then
			table.insert(
				Dropdown.Connections,
				SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList)
			)
		end

		local Defaults = {}
		if typeof(Info.Default) == "string" then
			local Index = table.find(Dropdown.Values, Info.Default)
			if Index then
				table.insert(Defaults, Index)
			end
		elseif typeof(Info.Default) == "table" then
			for _, Value in next, Info.Default do
				local Index = table.find(Dropdown.Values, Value)
				if Index then
					table.insert(Defaults, Index)
				end
			end
		elseif Dropdown.Values[Info.Default] ~= nil then
			table.insert(Defaults, Info.Default)
		end

		if next(Defaults) then
			for i = 1, #Defaults do
				local Index = Defaults[i]
				if Info.Multi then
					Dropdown.Value[Dropdown.Values[Index]] = true
				else
					Dropdown.Value = Dropdown.Values[Index]
				end

				if not Info.Multi then
					break
				end
			end
		end

		if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
			Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
			Dropdown.TooltipTable.Disabled = Dropdown.Disabled
		end

		Dropdown:UpdateColors()
		Dropdown:Display()
		Dropdown:BuildDropdownList()
		Groupbox:Resize()

		Dropdown.Holder = Holder
		table.insert(Groupbox.Elements, Dropdown)

		Dropdown.Default = Defaults
		Dropdown.DefaultValues = Dropdown.Values

		Options[Idx] = Dropdown

		function Dropdown:Destroy()
			Dropdown.Destroyed = true

			StopDragSelect()

			if Dropdown.Connections then
				for _, Connection in Dropdown.Connections do
					Connection:Disconnect()
				end
			end

			if Dropdown.TooltipTable then
				Dropdown.TooltipTable:Destroy()
			end

			if MenuTable then
				MenuTable:Destroy()
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Dropdown)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Dropdown
	end

	local function NormalizeDropdownItem(Entry, ItemIcons, DisabledValues)
		local Text, Icon, Disabled
		if type(Entry) == "table" then
			Text = tostring(Entry.Text or Entry.Name or Entry[1] or "?")
			Icon = Entry.Icon or ItemIcons[Text]
			Disabled = Entry.Disabled == true or table.find(DisabledValues, Text) ~= nil
		else
			Text = tostring(Entry)
			Icon = ItemIcons[Text]
			Disabled = table.find(DisabledValues, Text) ~= nil
		end
		return { Text = Text, Icon = Icon, Disabled = Disabled }
	end

	function Funcs:AddDropdownV2(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.DropdownV2)

		local Groupbox = self
		local Container = Groupbox.Container

		local Dropdown = {
			Destroyed = false,
			PopupOpen = false,

			Text = typeof(Info.Text) == "string" and Info.Text or nil,
			Placeholder = typeof(Info.Placeholder) == "string" and Info.Placeholder or "Select...",

			Items = {},
			Multi = Info.Multi == true,
			Max = tonumber(Info.Max) or 0,
			ListHeight = tonumber(Info.ListHeight) or 200,

			Value = nil,
			SelectedSet = {},

			Callback = Info.Callback,
			Changed = Info.Changed,

			Disabled = Info.Disabled,
			Visible = Info.Visible,

			Type = "DropdownV2",
		}
		if Dropdown.Multi then
			Dropdown.Value = {}
		end

		local function NormalizeAll()
			Dropdown.Items = {}
			for _, Entry in Info.Values do
				table.insert(Dropdown.Items, NormalizeDropdownItem(Entry, Info.ItemIcons, Info.DisabledValues))
			end
		end
		NormalizeAll()

		local function IsSelected(Text)
			if Dropdown.Multi then
				return Dropdown.SelectedSet[Text] == true
			end
			return Dropdown.Value == Text
		end

		local function SelectedList()
			if Dropdown.Multi then
				return Dropdown.Value
			end
			return Dropdown.Value ~= nil and { Dropdown.Value } or {}
		end

		local function Limit()
			if Dropdown.Multi and Dropdown.Max > 0 then
				return Dropdown.Max
			end
			return #Dropdown.Items
		end

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
			Visible = Dropdown.Visible,
			Parent = Container,
		})

		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			Text = Dropdown.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = not not Info.Text,
			ZIndex = 3,
			Parent = Holder,
		})

		local DisplayContainer = New("TextButton", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 21),
			Text = "",
			TextTransparency = 1,
			Active = not Dropdown.Disabled,
			ZIndex = 2,
			Parent = Holder,
		})
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 4),
			Parent = DisplayContainer,
		})
		New("UIStroke", {
			Color = "OutlineColor",
			Parent = DisplayContainer,
		})
		MakeGradient(DisplayContainer)
		local DisplayCorner = New("UICorner", {
			TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
			BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
			Parent = DisplayContainer,
		})
		table.insert(Library.SpecificCorners, DisplayCorner)

		local DisplayLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -26, 1, 0),
			Text = Dropdown.Placeholder,
			TextSize = 14,
			TextTransparency = Dropdown.Disabled and 0.6 or 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 3,
			Parent = DisplayContainer,
		})

		local ChevronIcon = Library:GetCustomIcon("chevron-down")
		if ChevronIcon then
			New("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -6, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				Image = ChevronIcon.Url,
				ImageColor3 = "FontColor",
				ImageTransparency = 0.4,
				ImageRectOffset = ChevronIcon.ImageRectOffset,
				ImageRectSize = ChevronIcon.ImageRectSize,
				ZIndex = 3,
				Parent = DisplayContainer,
			})
		end

		local PopupOverlay, PopupFrame, PopupGradient
		local SummaryTotal, SummaryList
		local RowRecs = {}

		function Dropdown:Refresh()
			local Sel = SelectedList()

			for _, Rec in RowRecs do
				local On = IsSelected(Rec.Item.Text)
				Rec.Check.Visible = On
				Rec.Row.BackgroundTransparency = On and 0.55 or 1
				Rec.Label.TextTransparency = Rec.Item.Disabled and 0.65 or (On and 0 or 0.35)
			end

			if SummaryTotal then
				SummaryTotal.Text = string.format("Total Selected: %d/%d", #Sel, Limit())
			end
			if SummaryList then
				SummaryList.Text = #Sel == 0 and "-" or table.concat(Sel, " - ")
			end

			if Dropdown.Multi then
				if #Sel == 0 then
					DisplayLabel.Text = Dropdown.Placeholder
				elseif #Sel <= 2 then
					DisplayLabel.Text = table.concat(Sel, ", ")
				else
					DisplayLabel.Text = string.format("%s, %s +%d", Sel[1], Sel[2], #Sel - 2)
				end
			else
				DisplayLabel.Text = Dropdown.Value or Dropdown.Placeholder
			end
		end

		function Dropdown:ClosePopup(Instant)
			if not Dropdown.PopupOpen then
				return
			end
			Dropdown.PopupOpen = false

			local Overlay, Frame = PopupOverlay, PopupFrame
			PopupOverlay, PopupFrame = nil, nil
			SummaryTotal, SummaryList = nil, nil
			table.clear(RowRecs)

			if PopupGradient then
				local GradIdx = table.find(Library.ButtonGradientInstances, PopupGradient)
				if GradIdx then
					table.remove(Library.ButtonGradientInstances, GradIdx)
				end
				PopupGradient = nil
			end

			if Instant then
				if Overlay then
					Overlay:Destroy()
				end
				return
			end
			if Frame then
				Library:FadeTree(Frame, false, true)
			end
			if Overlay then
				TweenService:Create(Overlay, Library.WindowAnimationInfo, { BackgroundTransparency = 1 }):Play()
				task.delay(Library.WindowAnimationInfo.Time, function()
					Overlay:Destroy()
				end)
			end
		end

		function Dropdown:SelectItem(Text)
			if Dropdown.Destroyed or Dropdown.Disabled then
				return
			end
			local Item
			for _, It in Dropdown.Items do
				if It.Text == Text then
					Item = It
					break
				end
			end
			if not Item or Item.Disabled then
				return
			end

			if Dropdown.Multi then
				if IsSelected(Text) then
					Dropdown.SelectedSet[Text] = nil
					local Pos = table.find(Dropdown.Value, Text)
					if Pos then
						table.remove(Dropdown.Value, Pos)
					end
				else
					if Dropdown.Max > 0 and #Dropdown.Value >= Dropdown.Max then
						return
					end
					Dropdown.SelectedSet[Text] = true
					table.insert(Dropdown.Value, Text)
				end
			else
				Dropdown.Value = Text
			end

			Dropdown:Refresh()
			Dropdown.Callback(Dropdown.Value)
			Dropdown.Changed(Dropdown.Value)

			if not Dropdown.Multi then
				Dropdown:ClosePopup()
			end
		end

		function Dropdown:Clear()
			if Dropdown.Multi then
				Dropdown.Value = {}
				table.clear(Dropdown.SelectedSet)
			else
				Dropdown.Value = nil
			end
			Dropdown:Refresh()
			Dropdown.Callback(Dropdown.Value)
			Dropdown.Changed(Dropdown.Value)
		end

		function Dropdown:OpenPopup()
			if Dropdown.Destroyed or Dropdown.Disabled or Dropdown.PopupOpen then
				return
			end

			local Root = Container
			while Root.Parent and Root.Parent ~= Library.ScreenGui do
				Root = Root.Parent
			end
			if not Root.Parent then
				return
			end
			local MainFrame = Root

			Dropdown.PopupOpen = true

			PopupOverlay = New("TextButton", {
				AutoButtonColor = false,
				BackgroundColor3 = "DarkColor",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = "",
				Active = true,
				ZIndex = 9100,
				Parent = MainFrame,
			})
			PopupOverlay:SetAttribute("NoGlowPulse", true)
			TweenService:Create(PopupOverlay, Library.WindowAnimationInfo, {
				BackgroundTransparency = 0.5,
			}):Play()
			PopupOverlay.MouseButton1Click:Connect(function()
				Dropdown:ClosePopup()
			end)

			PopupFrame = New("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = "BackgroundColor",
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(math.min(380, MainFrame.AbsoluteSize.X * 0.8), 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 9101,
				Parent = PopupOverlay,
			})
			PopupFrame:SetAttribute("NoGlowPulse", true)
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius),
					Parent = PopupFrame,
				})
			)
			Library:AddOutline(PopupFrame)
			PopupGradient = MakeGradient(PopupFrame)

			local Inner = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 9102,
				Parent = PopupFrame,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = Inner,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				PaddingTop = UDim.new(0, 12),
				Parent = Inner,
			})

			local HeaderIcon = Info.Icon and Library:GetCustomIcon(Info.Icon) or nil
			local HeaderRow = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 20),
				LayoutOrder = 1,
				ZIndex = 9102,
				Parent = Inner,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = HeaderRow,
			})
			New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, HeaderIcon and -24 or 0, 0, 20),
				Text = Dropdown.Text or "Pilih",
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				ZIndex = 9102,
				Parent = HeaderRow,
			})
			if HeaderIcon then
				New("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(18, 18),
					Image = HeaderIcon.Url,
					ImageColor3 = "AccentColor",
					ImageRectOffset = HeaderIcon.ImageRectOffset,
					ImageRectSize = HeaderIcon.ImageRectSize,
					LayoutOrder = 2,
					ZIndex = 9102,
					Parent = HeaderRow,
				})
			end

			local SummaryBox = New("Frame", {
				BackgroundColor3 = "MainColor",
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 2,
				ZIndex = 9102,
				Parent = Inner,
			})
			table.insert(
				Library.SpecificCorners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius / 2),
					Parent = SummaryBox,
				})
			)
			New("UIListLayout", {
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = SummaryBox,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 8),
				Parent = SummaryBox,
			})
			SummaryTotal = New("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 14),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				ZIndex = 9102,
				Parent = SummaryBox,
			})
			New("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 13),
				Text = "List Selected:",
				TextSize = 13,
				TextTransparency = 0.4,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2,
				ZIndex = 9102,
				Parent = SummaryBox,
			})
			SummaryList = New("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 13),
				TextSize = 13,
				TextTransparency = 0.25,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				LayoutOrder = 3,
				ZIndex = 9102,
				Parent = SummaryBox,
			})

			local ListScroll = New("ScrollingFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Dropdown.ListHeight),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = "OutlineColor",
				ScrollBarImageTransparency = 0.4,
				LayoutOrder = 3,
				ZIndex = 9102,
				Parent = Inner,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = ListScroll,
			})

			for Order, Item in ipairs(Dropdown.Items) do
				local Row = New("TextButton", {
					BackgroundColor3 = "MainColor",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 26),
					Text = "",
					AutoButtonColor = false,
					LayoutOrder = Order,
					ZIndex = 9102,
					Parent = ListScroll,
				})
				table.insert(
					Library.SpecificCorners,
					New("UICorner", {
						CornerRadius = UDim.new(0, Library.CornerRadius / 2),
						Parent = Row,
					})
				)

				local RowIcon = Item.Icon and Library:GetCustomIcon(Item.Icon) or nil
				if RowIcon then
					New("ImageLabel", {
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(8, 5),
						Size = UDim2.fromOffset(16, 16),
						Image = RowIcon.Url,
						ImageColor3 = "FontColor",
						ImageTransparency = 0.3,
						ImageRectOffset = RowIcon.ImageRectOffset,
						ImageRectSize = RowIcon.ImageRectSize,
						ZIndex = 9102,
						Parent = Row,
					})
				end
				local RowLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					Position = RowIcon and UDim2.fromOffset(30, 0) or UDim2.fromOffset(10, 0),
					Size = UDim2.new(1, RowIcon and -52 or -30, 1, 0),
					Text = Item.Text,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					ZIndex = 9102,
					Parent = Row,
				})
				local Check = New("ImageLabel", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Image = CheckIcon and CheckIcon.Url or "",
					ImageColor3 = SelectedCheckColor,
					ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
					ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
					Position = UDim2.new(1, -10, 0.5, 0),
					Size = UDim2.fromOffset(14, 14),
					Visible = false,
					ZIndex = 9102,
					Parent = Row,
				})

				table.insert(RowRecs, { Item = Item, Row = Row, Label = RowLabel, Check = Check })

				if not Item.Disabled then
					Row.MouseEnter:Connect(function()
						if not IsSelected(Item.Text) then
							TweenService:Create(Row, Library.TweenInfo, { BackgroundTransparency = 0.75 }):Play()
						end
					end)
					Row.MouseLeave:Connect(function()
						if not IsSelected(Item.Text) then
							TweenService:Create(Row, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
						end
					end)
					Row.MouseButton1Click:Connect(function()
						Dropdown:SelectItem(Item.Text)
					end)
				end
			end

			local FooterRow = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 26),
				LayoutOrder = 4,
				ZIndex = 9102,
				Parent = Inner,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = FooterRow,
			})

			local function MakeFooterButton(Title, Primary, Order, OnClick)
				local Btn = New("TextButton", {
					BackgroundColor3 = Primary and "FontColor" or "MainColor",
					Size = UDim2.fromOffset(0, 26),
					Text = Title,
					TextColor3 = Primary and "BackgroundColor" or "FontColor",
					TextSize = 14,
					AutoButtonColor = false,
					LayoutOrder = Order,
					ZIndex = 9102,
					Parent = FooterRow,
				})
				table.insert(
					Library.Corners,
					New("UICorner", {
						CornerRadius = UDim.new(0, Library.CornerRadius),
						Parent = Btn,
					})
				)
				Library:AddOutline(Btn)
				local X = Library:GetTextBounds(Title, Library.Scheme.Font, 14, 250)
				Btn.Size = UDim2.fromOffset(X + 24, 26)
				Btn.MouseButton1Click:Connect(OnClick)
			end

			MakeFooterButton("Clear", false, 1, function()
				Dropdown:Clear()
			end)
			MakeFooterButton("Done", true, 2, function()
				Dropdown:ClosePopup()
			end)

			Dropdown:Refresh()
			Library:FadeTree(PopupFrame, true, true)
		end

		DisplayContainer.MouseButton1Click:Connect(function()
			if Dropdown.Disabled or Dropdown.Destroyed then
				return
			end
			if Dropdown.PopupOpen then
				Dropdown:ClosePopup()
			else
				Dropdown:OpenPopup()
			end
		end)

		function Dropdown:SetValue(Value)
			if Dropdown.Multi then
				Dropdown.Value = {}
				table.clear(Dropdown.SelectedSet)
				if Value ~= nil then
					local T = tostring(Value)
					Dropdown.SelectedSet[T] = true
					table.insert(Dropdown.Value, T)
				end
			else
				Dropdown.Value = Value ~= nil and tostring(Value) or nil
			end
			Dropdown:Refresh()
		end

		function Dropdown:SetSelected(Values)
			if not Dropdown.Multi then
				return Dropdown:SetValue(Values)
			end
			Dropdown.Value = {}
			table.clear(Dropdown.SelectedSet)
			if type(Values) == "table" then
				for _, V in Values do
					local T = tostring(V)
					if Dropdown.Max > 0 and #Dropdown.Value >= Dropdown.Max then
						break
					end
					if not Dropdown.SelectedSet[T] then
						Dropdown.SelectedSet[T] = true
						table.insert(Dropdown.Value, T)
					end
				end
			end
			Dropdown:Refresh()
		end

		function Dropdown:SetItems(Values, ItemIcons)
			if Values then
				Info.Values = Values
			end
			if ItemIcons then
				Info.ItemIcons = ItemIcons
			end
			NormalizeAll()

			if Dropdown.Multi then
				local Keep, KeepSet = {}, {}
				for _, T in Dropdown.Value do
					for _, It in Dropdown.Items do
						if It.Text == T and not KeepSet[T] then
							KeepSet[T] = true
							table.insert(Keep, T)
							break
						end
					end
				end
				Dropdown.Value, Dropdown.SelectedSet = Keep, KeepSet
			else
				local Exists = false
				for _, It in Dropdown.Items do
					if It.Text == Dropdown.Value then
						Exists = true
						break
					end
				end
				if not Exists then
					Dropdown.Value = nil
				end
			end

			if Dropdown.PopupOpen then
				Dropdown:ClosePopup(true)
				Dropdown:OpenPopup()
			else
				Dropdown:Refresh()
			end
		end

		function Dropdown:GetActiveValues(ReturnCount)
			local Sel = SelectedList()
			if ReturnCount then
				return Sel, #Sel
			end
			return Sel
		end

		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
		end

		function Dropdown:SetDisabled(Disabled)
			Dropdown.Disabled = Disabled
			DisplayContainer.Active = not Disabled
			DisplayLabel.TextTransparency = Disabled and 0.6 or 0
			if Disabled then
				Dropdown:ClosePopup(true)
			end
		end

		function Dropdown:SetVisible(Visible)
			Dropdown.Visible = Visible
			Holder.Visible = Visible
			Groupbox:Resize()
		end

		function Dropdown:SetText(Text)
			Dropdown.Text = Text
			Label.Text = Text
			Label.Visible = Text ~= nil and Text ~= ""
			Holder.Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21)
			Groupbox:Resize()
		end

		if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
			Dropdown.TooltipTable = Library:AddTooltip(Info.Tooltip, Info.DisabledTooltip, DisplayContainer)
			Dropdown.TooltipTable.Disabled = Dropdown.Disabled
		end

		Dropdown:Refresh()
		Groupbox:Resize()

		Dropdown.Holder = Holder
		table.insert(Groupbox.Elements, Dropdown)
		Options[Idx] = Dropdown

		function Dropdown:Destroy()
			Dropdown.Destroyed = true
			Dropdown:ClosePopup(true)

			if Dropdown.TooltipTable then
				Dropdown.TooltipTable:Destroy()
			end
			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Dropdown)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end
			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Dropdown
	end

	function Funcs:AddViewport(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.Viewport)

		if not Info.Object then
			return nil
		end

		local Groupbox = self
		local Container = Groupbox.Container

		local Dragging, Pinching = false, false
		local LastMousePos, LastPinchDist = nil, 0

		local ViewportObject = Info.Object
		if Info.Clone and typeof(Info.Object) == "Instance" then
			if Info.Object.Archivable then
				ViewportObject = ViewportObject:Clone()
			else
				Info.Object.Archivable = true
				ViewportObject = ViewportObject:Clone()
				Info.Object.Archivable = false
			end
		end

		local Viewport = {
			Connections = {},
			Destroyed = false,

			Object = ViewportObject :: PVInstance,
			Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
			Interactive = Info.Interactive,
			AutoFocus = Info.AutoFocus,
			Visible = Info.Visible,
			Type = "Viewport",
		}

		assert(
			typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
			"Instance must be a BasePart or Model."
		)

		assert(
			typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
			"Camera must be a valid Camera instance."
		)

		local function GetModelSize(model)
			if model:IsA("BasePart") then
				return model.Size
			end

			return select(2, model:GetBoundingBox())
		end

		local function FocusCamera()
			local ModelSize = GetModelSize(Viewport.Object)
			local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
			local CameraDistance = MaxExtent * 2
			local ModelPosition = (Viewport.Object :: PVInstance):GetPivot().Position

			Viewport.Camera.CFrame =
				CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
		end

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Info.Height),
			Visible = Viewport.Visible,
			Parent = Container,
		})

		local Box = New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 1),
			Parent = Holder,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 3),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 4),
			Parent = Box,
		})

		local ViewportFrame = New("ViewportFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Parent = Box,
			CurrentCamera = Viewport.Camera,
			Active = Viewport.Interactive,
		})

		table.insert(
			Viewport.Connections,
			ViewportFrame.MouseEnter:Connect(function()
				if not Viewport.Interactive then
					return
				end

				for _, Side in Groupbox.Tab.Sides do
					Side.ScrollingEnabled = false
				end
			end)
		)

		table.insert(
			Viewport.Connections,
			ViewportFrame.MouseLeave:Connect(function()
				if not Viewport.Interactive then
					return
				end

				for _, Side in Groupbox.Tab.Sides do
					Side.ScrollingEnabled = true
				end
			end)
		)

		table.insert(
			Viewport.Connections,
			ViewportFrame.InputBegan:Connect(function(input)
				if not Viewport.Interactive then
					return
				end

				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					Dragging = true
					LastMousePos = input.Position
				elseif input.UserInputType == Enum.UserInputType.Touch and not Pinching then
					Dragging = true
					LastMousePos = input.Position
				end
			end)
		)

		table.insert(
			Viewport.Connections,
			UserInputService.InputEnded:Connect(function(input)
				if Library.Unloaded then
					return
				end

				if not Viewport.Interactive then
					return
				end

				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					Dragging = false
				elseif input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
				end
			end)
		)

		table.insert(
			Viewport.Connections,
			UserInputService.InputChanged:Connect(function(input)
				if Library.Unloaded then
					return
				end

				if not Viewport.Interactive or not Dragging or Pinching then
					return
				end

				if
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				then
					local MouseDelta = input.Position - LastMousePos
					LastMousePos = input.Position

					local Position = (Viewport.Object :: PVInstance):GetPivot().Position
					local Camera = Viewport.Camera

					local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
					Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

					local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.01)
					local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

					if PitchedCFrame.UpVector.Y > 0.1 then
						Camera.CFrame = PitchedCFrame
					end
				end
			end)
		)

		table.insert(
			Viewport.Connections,
			ViewportFrame.InputChanged:Connect(function(input)
				if not Viewport.Interactive then
					return
				end

				if input.UserInputType == Enum.UserInputType.MouseWheel then
					local ZoomAmount = input.Position.Z * 2
					Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
				end
			end)
		)

		table.insert(
			Viewport.Connections,
			UserInputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
				if Library.Unloaded then
					return
				end

				if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
					return
				end

				if state == Enum.UserInputState.Begin then
					Pinching = true
					Dragging = false
					LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
				elseif state == Enum.UserInputState.Change then
					local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
					local delta = (currentDist - LastPinchDist) * 0.1
					LastPinchDist = currentDist
					Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
				elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
					Pinching = false
				end
			end)
		);
		(Viewport.Object :: PVInstance).Parent = ViewportFrame
		if Viewport.AutoFocus then
			FocusCamera()
		end

		function Viewport:SetObject(Object: Instance, Clone: boolean?)
			assert(Object, "Object cannot be nil.")

			if Clone then
				Object = Object:Clone()
			end

			if Viewport.Object then
				Viewport.Object:Destroy()
			end

			Viewport.Object = Object;
			(Viewport.Object :: PVInstance).Parent = ViewportFrame

			Groupbox:Resize()
		end

		function Viewport:SetHeight(Height: number)
			assert(Height > 0, "Height must be greater than 0.")

			Holder.Size = UDim2.new(1, 0, 0, Height)
			Groupbox:Resize()
		end

		function Viewport:Focus()
			if not Viewport.Object then
				return
			end

			FocusCamera()
		end

		function Viewport:SetCamera(Camera: Instance)
			assert(
				Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
				"Camera must be a valid Camera instance."
			)

			Viewport.Camera = Camera
			ViewportFrame.CurrentCamera = Camera
		end

		function Viewport:SetInteractive(Interactive: boolean)
			Viewport.Interactive = Interactive
			ViewportFrame.Active = Interactive
		end

		function Viewport:SetVisible(Visible: boolean)
			Viewport.Visible = Visible

			Holder.Visible = Viewport.Visible
			Groupbox:Resize()
		end

		Groupbox:Resize()

		Viewport.Holder = Holder
		table.insert(Groupbox.Elements, Viewport)

		Options[Idx] = Viewport

		function Viewport:Destroy()
			Viewport.Destroyed = true

			if Viewport.Connections then
				for _, Connection in Viewport.Connections do
					Connection:Disconnect()
				end
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Viewport)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Viewport
	end

	function Funcs:AddImage(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.Image)

		local Groupbox = self
		local Container = Groupbox.Container

		local Image = {
			Connections = {},
			Destroyed = false,

			Image = Info.Image,
			Color = Info.Color,
			RectOffset = Info.RectOffset,
			RectSize = Info.RectSize,
			Height = Info.Height,
			ScaleType = Info.ScaleType,
			Transparency = Info.Transparency,
			BackgroundTransparency = Info.BackgroundTransparency,

			Visible = Info.Visible,
			Type = "Image",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Info.Height),
			Visible = Image.Visible,
			Parent = Container,
		})

		local Box = New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			BackgroundTransparency = Image.BackgroundTransparency,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 1),
			Parent = Holder,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 3),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 4),
			Parent = Box,
		})

		local ImageProperties = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = Image.Image,
			ImageTransparency = Image.Transparency,
			ImageColor3 = Image.Color,
			ImageRectOffset = Image.RectOffset,
			ImageRectSize = Image.RectSize,
			ScaleType = Image.ScaleType,
			Parent = Box,
		}

		local Icon = Library:GetCustomIcon(ImageProperties.Image)
			or {
				Url = "rbxassetid://95816097006870",
				ImageRectOffset = Vector2.zero,
				ImageRectSize = Vector2.zero,
			}

		ImageProperties.Image = Icon.Url
		ImageProperties.ImageRectOffset = Icon.ImageRectOffset
		ImageProperties.ImageRectSize = Icon.ImageRectSize

		local ImageLabel = New("ImageLabel", ImageProperties)

		function Image:SetHeight(Height: number)
			assert(Height > 0, "Height must be greater than 0.")

			Image.Height = Height
			Holder.Size = UDim2.new(1, 0, 0, Height)
			Groupbox:Resize()
		end

		function Image:SetImage(NewImage: string)
			assert(typeof(NewImage) == "string", "Image must be a string.")

			local Icon = Library:GetCustomIcon(NewImage)
			assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

			NewImage = Icon.Url
			Image.RectOffset = Icon.ImageRectOffset
			Image.RectSize = Icon.ImageRectSize

			ImageLabel.Image = NewImage
			Image.Image = NewImage
		end

		function Image:SetColor(Color: Color3)
			assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

			ImageLabel.ImageColor3 = Color
			Image.Color = Color
		end

		function Image:SetRectOffset(RectOffset: Vector2)
			assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

			ImageLabel.ImageRectOffset = RectOffset
			Image.RectOffset = RectOffset
		end

		function Image:SetRectSize(RectSize: Vector2)
			assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

			ImageLabel.ImageRectSize = RectSize
			Image.RectSize = RectSize
		end

		function Image:SetScaleType(ScaleType: Enum.ScaleType)
			assert(
				typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
				"ScaleType must be a valid Enum.ScaleType."
			)

			ImageLabel.ScaleType = ScaleType
			Image.ScaleType = ScaleType
		end

		function Image:SetTransparency(Transparency: number)
			assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
			assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

			ImageLabel.ImageTransparency = Transparency
			Image.Transparency = Transparency
		end

		function Image:SetVisible(Visible: boolean)
			Image.Visible = Visible

			Holder.Visible = Image.Visible
			Groupbox:Resize()
		end

		Groupbox:Resize()

		Image.Holder = Holder
		table.insert(Groupbox.Elements, Image)

		Options[Idx] = Image

		function Image:Destroy()
			Image.Destroyed = true

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Image)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Image
	end

	function Funcs:AddVideo(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.Video)

		local Groupbox = self
		local Container = Groupbox.Container

		local Video = {
			Connections = {},
			Destroyed = false,

			Video = Info.Video,
			Looped = Info.Looped,
			Playing = Info.Playing,
			Volume = Info.Volume,
			Height = Info.Height,
			Visible = Info.Visible,

			Type = "Video",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Info.Height),
			Visible = Video.Visible,
			Parent = Container,
		})

		local Box = New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
			BorderSizePixel = 1,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 1),
			Parent = Holder,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 3),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 4),
			Parent = Box,
		})

		local VideoFrameInstance = New("VideoFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Video = Video.Video,
			Looped = Video.Looped,
			Volume = Video.Volume,
			Parent = Box,
		})

		VideoFrameInstance.Playing = Video.Playing

		function Video:SetHeight(Height: number)
			assert(Height > 0, "Height must be greater than 0.")

			Video.Height = Height
			Holder.Size = UDim2.new(1, 0, 0, Height)
			Groupbox:Resize()
		end

		function Video:SetVideo(NewVideo: string)
			assert(typeof(NewVideo) == "string", "Video must be a string.")

			VideoFrameInstance.Video = NewVideo
			Video.Video = NewVideo
		end

		function Video:SetLooped(Looped: boolean)
			assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

			VideoFrameInstance.Looped = Looped
			Video.Looped = Looped
		end

		function Video:SetVolume(Volume: number)
			assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

			VideoFrameInstance.Volume = Volume
			Video.Volume = Volume
		end

		function Video:SetPlaying(Playing: boolean)
			assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

			VideoFrameInstance.Playing = Playing
			Video.Playing = Playing
		end

		function Video:Play()
			VideoFrameInstance.Playing = true
			Video.Playing = true
		end

		function Video:Pause()
			VideoFrameInstance.Playing = false
			Video.Playing = false
		end

		function Video:SetVisible(Visible: boolean)
			Video.Visible = Visible

			Holder.Visible = Video.Visible
			Groupbox:Resize()
		end

		Groupbox:Resize()

		Video.Holder = Holder
		Video.VideoFrame = VideoFrameInstance
		table.insert(Groupbox.Elements, Video)

		Options[Idx] = Video

		function Video:Destroy()
			Video.Destroyed = true

			if Video.Connections then
				for _, Connection in Video.Connections do
					Connection:Disconnect()
				end
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Video)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Video
	end

	function Funcs:AddUIPassthrough(Idx, Info)
		if self.Destroyed then
			return nil
		end

		Info = Library:Validate(Info, Templates.UIPassthrough)

		local Groupbox = self
		local Container = Groupbox.Container

		assert(Info.Instance, "Instance must be provided.")
		assert(
			typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
			"Instance must inherit from GuiBase2d."
		)
		assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

		local Passthrough = {
			Connections = {},
			Destroyed = false,

			Instance = Info.Instance,
			Height = Info.Height,
			Visible = Info.Visible,

			Type = "UIPassthrough",
		}

		local Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Info.Height),
			Visible = Passthrough.Visible,
			Parent = Container,
		})

		Passthrough.Instance.Parent = Holder

		Groupbox:Resize()

		function Passthrough:SetHeight(Height: number)
			assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

			Passthrough.Height = Height
			Holder.Size = UDim2.new(1, 0, 0, Height)
			Groupbox:Resize()
		end

		function Passthrough:SetInstance(Instance: Instance)
			assert(Instance, "Instance must be provided.")
			assert(
				typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
				"Instance must inherit from GuiBase2d."
			)

			if Passthrough.Instance then
				Passthrough.Instance.Parent = nil
			end

			Passthrough.Instance = Instance
			Passthrough.Instance.Parent = Holder
		end

		function Passthrough:SetVisible(Visible: boolean)
			Passthrough.Visible = Visible

			Holder.Visible = Passthrough.Visible
			Groupbox:Resize()
		end

		Passthrough.Holder = Holder
		table.insert(Groupbox.Elements, Passthrough)

		Options[Idx] = Passthrough

		function Passthrough:Destroy()
			Passthrough.Destroyed = true

			if Passthrough.Connections then
				for _, Connection in Passthrough.Connections do
					Connection:Disconnect()
				end
			end

			if Holder then
				Holder:Destroy()
			end

			local ElemIdx = table.find(Groupbox.Elements, Passthrough)
			if ElemIdx then
				table.remove(Groupbox.Elements, ElemIdx)
			end

			Groupbox:Resize()
			Options[Idx] = nil
		end

		return Passthrough
	end

	function Funcs:AddDependencyBox()
		if self.Destroyed then
			return nil
		end

		local Groupbox = self
		local Container = Groupbox.Container

		local DepboxContainer
		local DepboxList

		do
			DepboxContainer = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Visible = false,
				Parent = Container,
			})

			DepboxList = New("UIListLayout", {
				Padding = UDim.new(0, 8),
				Parent = DepboxContainer,
			})
		end

		local Depbox = {
			Connections = {},
			Destroyed = false,

			Visible = false,
			Dependencies = {},

			Holder = DepboxContainer,
			Container = DepboxContainer,

			Elements = {},
			DependencyBoxes = {},
		}

		function Depbox:Resize()
			DepboxContainer.Size = UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
			Groupbox:Resize()
		end

		function Depbox:Update(CancelSearch)
			for _, Dependency in Depbox.Dependencies do
				local Element = Dependency[1]
				local Value = Dependency[2]

				if Element.Type == "Toggle" and Element.Value ~= Value then
					DepboxContainer.Visible = false
					Depbox.Visible = false
					return
				elseif Element.Type == "Dropdown" then
					if typeof(Element.Value) == "table" then
						if not Element.Value[Value] then
							DepboxContainer.Visible = false
							Depbox.Visible = false
							return
						end
					else
						if Element.Value ~= Value then
							DepboxContainer.Visible = false
							Depbox.Visible = false
							return
						end
					end
				end
			end

			Depbox.Visible = true
			DepboxContainer.Visible = true
			if not Library.Searching then
				task.defer(function()
					Depbox:Resize()
				end)
			elseif not CancelSearch then
				Library:UpdateSearch(Library.SearchText)
			end
		end

		DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if not Depbox.Visible then
				return
			end

			Depbox:Resize()
		end)

		function Depbox:SetupDependencies(Dependencies)
			for _, Dependency in Dependencies do
				assert(typeof(Dependency) == "table", "Dependency should be a table.")
				assert(Dependency[1] ~= nil, "Dependency is missing element.")
				assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
			end

			Depbox.Dependencies = Dependencies
			Depbox:Update()
		end

		DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
			Depbox:Resize()
		end)

		setmetatable(Depbox, BaseGroupbox)

		table.insert(Groupbox.DependencyBoxes, Depbox)
		table.insert(Library.DependencyBoxes, Depbox)

		function Depbox:Destroy()
			Depbox.Destroyed = true

			if Depbox.Connections then
				for _, Connection in Depbox.Connections do
					Connection:Disconnect()
				end
			end

			for _, Element in Depbox.Elements do
				if Element.Destroy then
					Element:Destroy()
				end
			end

			for _, SubDepbox in Depbox.DependencyBoxes do
				if SubDepbox.Destroy then
					SubDepbox:Destroy()
				end
			end

			if DepboxContainer then
				DepboxContainer:Destroy()
			end

			local ElemIdx = table.find(Groupbox.DependencyBoxes, Depbox)
			if ElemIdx then
				table.remove(Groupbox.DependencyBoxes, ElemIdx)
			end

			local LibIdx = table.find(Library.DependencyBoxes, Depbox)
			if LibIdx then
				table.remove(Library.DependencyBoxes, LibIdx)
			end
		end

		return Depbox
	end

	function Funcs:AddDependencyGroupbox()
		if self.Destroyed then
			return nil
		end

		local Groupbox = self
		local Tab = Groupbox.Tab
		local BoxHolder = Groupbox.BoxHolder

		local DepGroupboxContainer
		local DepGroupboxList

		do
			local Nested = Library:IsInsideSurfaceCard(BoxHolder)
			DepGroupboxContainer = New("Frame", {
				BackgroundColor3 = function()
					return Library:GetGroupSurfaceColor()
				end,
				BackgroundTransparency = Nested and 1 or ClampTransparency(Library.Surface.GroupTransparency),
				Size = UDim2.fromScale(1, 0),
				Visible = false,
				Parent = BoxHolder,
			})
			if not Nested then
				Library.SurfaceGroups[DepGroupboxContainer] = true
			end
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius),
					Parent = DepGroupboxContainer,
				})
			)
			Library:AddOutline(DepGroupboxContainer)

			DepGroupboxList = New("UIListLayout", {
				Padding = UDim.new(0, 8),
				Parent = DepGroupboxContainer,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 7),
				PaddingLeft = UDim.new(0, 7),
				PaddingRight = UDim.new(0, 7),
				PaddingTop = UDim.new(0, 7),
				Parent = DepGroupboxContainer,
			})
		end

		local DepGroupbox = {
			Connections = {},
			Destroyed = false,

			Visible = false,
			Dependencies = {},

			BoxHolder = BoxHolder,
			Holder = DepGroupboxContainer,
			Container = DepGroupboxContainer,

			Tab = Tab,
			Elements = {},
			DependencyBoxes = {},
		}

		function DepGroupbox:Resize()
			DepGroupboxContainer.Size =
				UDim2.new(1, 0, 0, (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 18)
		end

		function DepGroupbox:Update(CancelSearch)
			for _, Dependency in DepGroupbox.Dependencies do
				local Element = Dependency[1]
				local Value = Dependency[2]

				if Element.Type == "Toggle" and Element.Value ~= Value then
					DepGroupboxContainer.Visible = false
					DepGroupbox.Visible = false
					return
				elseif Element.Type == "Dropdown" then
					if typeof(Element.Value) == "table" then
						if not Element.Value[Value] then
							DepGroupboxContainer.Visible = false
							DepGroupbox.Visible = false
							return
						end
					else
						if Element.Value ~= Value then
							DepGroupboxContainer.Visible = false
							DepGroupbox.Visible = false
							return
						end
					end
				end
			end

			DepGroupbox.Visible = true
			if not Library.Searching then
				DepGroupboxContainer.Visible = true
				DepGroupbox:Resize()
			elseif not CancelSearch then
				Library:UpdateSearch(Library.SearchText)
			end
		end

		function DepGroupbox:SetupDependencies(Dependencies)
			for _, Dependency in Dependencies do
				assert(typeof(Dependency) == "table", "Dependency should be a table.")
				assert(Dependency[1] ~= nil, "Dependency is missing element.")
				assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
			end

			DepGroupbox.Dependencies = Dependencies
			DepGroupbox:Update()
		end

		setmetatable(DepGroupbox, BaseGroupbox)

		table.insert(Tab.DependencyGroupboxes, DepGroupbox)
		table.insert(Library.DependencyBoxes, DepGroupbox :: any)

		function DepGroupbox:Destroy()
			DepGroupbox.Destroyed = true

			if DepGroupbox.Connections then
				for _, Connection in DepGroupbox.Connections do
					Connection:Disconnect()
				end
			end

			for _, Element in DepGroupbox.Elements do
				if Element.Destroy then
					Element:Destroy()
				end
			end

			for _, SubDepbox in DepGroupbox.DependencyBoxes do
				if SubDepbox.Destroy then
					SubDepbox:Destroy()
				end
			end

			if DepGroupboxContainer then
				DepGroupboxContainer:Destroy()
			end

			local ElemIdx = table.find(Tab.DependencyGroupboxes, DepGroupbox)
			if ElemIdx then
				table.remove(Tab.DependencyGroupboxes, ElemIdx)
			end

			local LibIdx = table.find(Library.DependencyBoxes, DepGroupbox)
			if LibIdx then
				table.remove(Library.DependencyBoxes, LibIdx)
			end
		end

		return DepGroupbox
	end

	BaseGroupbox.__index = Funcs
	Library.__GroupboxClass = BaseGroupbox
	BaseGroupbox.__namecall = function(_, Key, ...)
		return Funcs[Key](...)
	end
end

function Library:SetFont(FontFace)
	if typeof(FontFace) == "EnumItem" then
		FontFace = Font.fromEnum(FontFace :: any)
	end

	Library.Scheme.Font = FontFace
	Library:UpdateColorsUsingRegistry()
end

function Library:UpdateNotificationPositions(Snap: boolean?)
	local IsLeft = Library.NotifySide:lower() == "left"
	local XScale = IsLeft and 0 or 1
	local RunningY = 0

	for _, FakeBackground in NotifyOrder do
		local Data = Library.Notifications[FakeBackground]
		if not (Data and FakeBackground.Parent) then
			continue
		end

		local Target = UDim2.new(XScale, 0, 0, RunningY)
		if Snap or not Data.PositionInitialized then
			FakeBackground.Position = Target
			Data.PositionInitialized = true
		elseif FakeBackground.Position ~= Target then
			TweenService:Create(FakeBackground, Library.NotifyTweenInfo, {
				Position = Target,
			}):Play()
		end

		RunningY = RunningY + FakeBackground.AbsoluteSize.Y + 8
	end
end

function Library:SetNotifySide(Side: string)
	Library.NotifySide = Side

	local IsLeft = Side:lower() == "left"
	if IsLeft then
		NotificationArea.AnchorPoint = Vector2.new(0, 0)
		NotificationArea.Position = UDim2.fromOffset(6, 6)
	else
		NotificationArea.AnchorPoint = Vector2.new(1, 0)
		NotificationArea.Position = UDim2.new(1, -6, 0, 6)
	end

	for FakeBackground in Library.Notifications do
		if not (FakeBackground and FakeBackground.Parent) then
			continue
		end
		FakeBackground.AnchorPoint = if IsLeft then Vector2.new(0, 0) else Vector2.new(1, 0)
	end

	Library:UpdateNotificationPositions(true)
end

function Library:Notify(...)
	local Data = {}
	local Info = select(1, ...)

	if typeof(Info) == "table" then
		Data.Title = tostring(Info.Title)
		Data.TitleColor = Info.TitleColor

		Data.Description = tostring(Info.Description)
		Data.DescriptionColor = Info.DescriptionColor

		Data.Time = Info.Time or 5
		Data.SoundId = Info.SoundId or "rbxassetid://92972986635552"
		Data.Steps = Info.Steps
		Data.Persist = Info.Persist

		Data.Icon = Info.Icon
		Data.BigIcon = Info.BigIcon
		Data.IconColor = Info.IconColor

		Data.Volume = tonumber(Info.Volume) or 3
	else
		Data.Description = tostring(Info)
		Data.Time = select(2, ...) or 5
		Data.SoundId = select(3, ...) or "rbxassetid://92972986635552"
		Data.Volume = select(4, ...) or 3
	end
	Data.Destroyed = false

	local DeletedInstance = false
	local DeleteConnection = nil
	if typeof(Data.Time) == "Instance" then
		DeleteConnection = Data.Time.Destroying:Connect(function()
			DeletedInstance = true

			DeleteConnection:Disconnect()
			DeleteConnection = nil
		end)
	end

	local FakeBackground = New("Frame", {
		AnchorPoint = Library.NotifySide:lower() == "left" and Vector2.new(0, 0) or Vector2.new(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		Visible = false,
		Parent = NotificationArea,
	})

	local Holder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = "MainColor",
		Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
		Size = UDim2.fromScale(1, 1),
		ZIndex = 5,
		Parent = FakeBackground,
	})
	table.insert(
		Library.Corners,
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Holder,
		})
	)
	New("UIListLayout", {
		Padding = UDim.new(0, 4),
		Parent = Holder,
	})
	New("UIPadding", {
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 8),
		Parent = Holder,
	})
	Library:AddOutline(Holder)

	local ContentContainer = New("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(1, 0),
		Parent = Holder,
	})

	if Data.BigIcon then
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Parent = ContentContainer,
		})
	end

	local BigIconLabel
	if Data.BigIcon then
		local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
		if ParsedIcon then
			BigIconLabel = New("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(24, 24),
				Image = ParsedIcon.Url,
				ImageColor3 = Data.IconColor or "AccentColor",
				ImageRectOffset = ParsedIcon.ImageRectOffset,
				ImageRectSize = ParsedIcon.ImageRectSize,
				Parent = ContentContainer,
			})
		end
	end

	local TextContainer = New("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0, 0),
		Parent = ContentContainer,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 4),
		Parent = TextContainer,
	})

	local TitleContainer
	if Data.Title then
		TitleContainer = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0, 0),
			Parent = TextContainer,
		})
	end

	local IconLabel
	if Data.Icon and TitleContainer then
		local ParsedIcon = Library:GetCustomIcon(Data.Icon)
		if ParsedIcon then
			IconLabel = New("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 1),
				Size = UDim2.fromOffset(15, 15),
				Image = ParsedIcon.Url,
				ImageColor3 = Data.IconColor or "FontColor",
				ImageRectOffset = ParsedIcon.ImageRectOffset,
				ImageRectSize = ParsedIcon.ImageRectSize,
				Parent = TitleContainer,
			})
		end
	end

	local Title
	local Desc
	local TitleX = 0
	local DescX = 0

	local TimerFill

	if Data.Title then
		Title = New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.None,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, (Data.Icon and 21 or 0), 0.5, 0),
			Size = UDim2.fromScale(0, 0),
			Text = Data.Title,
			TextColor3 = Data.TitleColor or "FontColor",
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true,
			Parent = TitleContainer,
		})
	end

	if Data.Description then
		Desc = New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.None,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0, 0),
			Text = Data.Description,
			TextColor3 = Data.DescriptionColor or "FontColor",
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Parent = TextContainer,
		})
	end

	function Data:Resize()
		local ExtraWidth = BigIconLabel and 32 or 0
		local IconWidth = IconLabel and 21 or 0

		if Title then
			local X, Y = Library:GetTextBounds(
				Title.Text,
				Title.FontFace,
				Title.TextSize,
				(NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - IconWidth
			)
			Title.Size = UDim2.fromOffset(X, Y)
			TitleX = X + IconWidth
			TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
		end

		if Desc then
			local X, Y = Library:GetTextBounds(
				Desc.Text,
				Desc.FontFace,
				Desc.TextSize,
				(NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth
			)
			Desc.Size = UDim2.fromOffset(X, Y)
			DescX = X
		end

		FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth, 0)

		if Library.Notifications[FakeBackground] then
			Library:UpdateNotificationPositions()
		end
	end

	function Data:ChangeTitle(Text)
		if Title then
			Data.Title = tostring(Text)
			Title.Text = Data.Title
			Data:Resize()
		end
	end

	function Data:ChangeDescription(Text)
		if Desc then
			Data.Description = tostring(Text)
			Desc.Text = Data.Description
			Data:Resize()
		end
	end

	function Data:ChangeStep(NewStep)
		if TimerFill and Data.Steps then
			NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
			TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
		end
	end

	function Data:Destroy()
		Data.Destroyed = true

		if typeof(Data.Time) == "Instance" then
			pcall(Data.Time.Destroy, Data.Time)
		end

		if DeleteConnection then
			DeleteConnection:Disconnect()
		end

		if FakeBackground then
			local Idx = table.find(NotifyOrder, FakeBackground)
			if Idx then
				table.remove(NotifyOrder, Idx)
			end
		end

		Library:UpdateNotificationPositions()

		TweenService:Create(Holder, Library.NotifyTweenInfo, {
			Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
		}):Play()

		task.delay(Library.NotifyTweenInfo.Time, function()
			Library.Notifications[FakeBackground] = nil
			FakeBackground:Destroy()
		end)
	end

	Data:Resize()

	local TimerHolder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 7),
		Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance") or typeof(Data.Steps) == "number",
		Parent = Holder,
	})
	local TimerBar = New("Frame", {
		BackgroundColor3 = "BackgroundColor",
		BorderColor3 = "OutlineColor",
		BorderSizePixel = 1,
		Position = UDim2.fromOffset(0, 3),
		Size = UDim2.new(1, 0, 0, 2),
		Parent = TimerHolder,
	})
	TimerFill = New("Frame", {
		BackgroundColor3 = "AccentColor",
		Size = UDim2.fromScale(1, 1),
		Parent = TimerBar,
	})

	if typeof(Data.Time) == "Instance" then
		TimerFill.Size = UDim2.fromScale(0, 1)
	end
	if Data.SoundId then
		local SoundId = Data.SoundId
		if typeof(SoundId) == "number" then
			SoundId = string.format("rbxassetid://%d", SoundId)
		end

		New("Sound", {
			SoundId = SoundId,
			Volume = tonumber(Data.Volume) or 3,
			PlayOnRemove = true,
			Parent = SoundService,
		}):Destroy()
	end

	Data.Holder = Holder

	table.insert(NotifyOrder, FakeBackground)
	Library.Notifications[FakeBackground] = Data

	Library:UpdateNotificationPositions()

	FakeBackground.Visible = true
	TweenService:Create(Holder, Library.NotifyTweenInfo, {
		Position = UDim2.fromOffset(0, 0),
	}):Play()

	task.delay(Library.NotifyTweenInfo.Time, function()
		if Data.Persist then
			return
		elseif typeof(Data.Time) == "Instance" then
			repeat
				task.wait()
			until DeletedInstance or Data.Destroyed
		else
			TweenService
				:Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
					Size = UDim2.fromScale(0, 1),
				})
				:Play()
			task.wait(Data.Time)
		end

		if not Data.Destroyed then
			Data:Destroy()
		end
	end)

	return Data
end


Library.IconGlow = {
	Enabled = true,
	Image = "rbxassetid://109516122757226",
	Transparency = 0.3,
	Scale = 3.5,
}
Library.IconGlows = {}

function Library:SetIconGlow(Enabled, Options)
	local IG = Library.IconGlow
	if Enabled ~= nil then
		IG.Enabled = not not Enabled
	end
	if type(Options) == "table" then
		if typeof(Options.Image) == "string" and Options.Image ~= "" then
			IG.Image = Options.Image
		end
		if type(Options.Transparency) == "number" then
			IG.Transparency = math.clamp(Options.Transparency, 0, 1)
		end
		if type(Options.Scale) == "number" then
			IG.Scale = math.clamp(Options.Scale, 1, 6)
		end
	end
	for _, Rec in ipairs(Library.IconGlows) do
		pcall(function()
			Rec.Inst.Visible = IG.Enabled
			Rec.Inst.Image = IG.Image
			Rec.Inst.ImageTransparency = IG.Transparency
			Rec.Inst.Size = UDim2.new(0, Rec.Base * IG.Scale, 0, Rec.Base * IG.Scale)
		end)
	end
	return IG.Enabled
end

Library.GameText = {
	RarityMode = "gradient",
	StrokeColor = Color3.new(0, 0, 0),
	Gradients = {
		Rainbow12 = {
			Rotation = -90,
			Keypoints = {
				{ 0, 16, 73, 124 }, { 0.02, 0, 16, 90 }, { 0.02, 0, 16, 90 }, { 0.09, 175, 201, 213 },
				{ 0.2, 224, 240, 255 }, { 0.34, 255, 180, 255 }, { 0.49, 68, 0, 127 }, { 0.52, 5, 1, 9 },
				{ 0.53, 255, 255, 255 }, { 0.74, 180, 255, 243 }, { 0.96, 39, 159, 175 }, { 1, 16, 73, 124 },
			},
		},
		Silver14 = {
			Rotation = 90,
			Keypoints = {
				{ 0, 255, 255, 255 }, { 0.03, 255, 255, 255 }, { 0.14, 255, 255, 255 }, { 0.54, 255, 255, 255 },
				{ 0.55, 0, 0, 0 }, { 0.61, 97, 97, 97 }, { 0.65, 97, 97, 97 }, { 0.71, 97, 97, 97 },
				{ 0.76, 97, 97, 97 }, { 0.87, 97, 97, 97 }, { 0.91, 255, 255, 255 }, { 0.91, 255, 255, 255 },
				{ 0.93, 255, 255, 255 }, { 1, 255, 255, 255 },
			},
		},
		Purple3 = {
			Rotation = 0,
			Keypoints = { { 0, 183, 0, 255 }, { 0.48, 255, 99, 213 }, { 1, 149, 0, 255 } },
		},
		NameShine = {
			Rotation = 90,
			Keypoints = { { 0, 255, 255, 255 }, { 0.53, 255, 255, 255 }, { 0.57, 202, 202, 202 }, { 1, 255, 255, 255 } },
		},
		Ready = {
			Rotation = 90,
			Keypoints = { { 0, 255, 255, 0 }, { 1, 21, 255, 0 } },
		},
		Missing = {
			Rotation = 90,
			Keypoints = { { 0, 245, 245, 245 }, { 1, 126, 132, 134 } },
		},
		HeaderBlue = {
			Rotation = 90,
			Keypoints = { { 0, 0, 179, 229 }, { 1, 0, 80, 229 } },
		},
		Legendary = {
			Rotation = -35,
			Keypoints = {
				{ 0, 255, 170, 1 }, { 0.26, 255, 255, 0 }, { 0.33, 255, 200, 0 }, { 0.42, 255, 255, 0 },
				{ 0.52, 255, 255, 127 }, { 0.6, 255, 255, 0 }, { 0.66, 255, 217, 0 }, { 0.78, 255, 255, 0 },
				{ 1, 255, 170, 0 },
			},
		},
		Mythic = {
			Rotation = -35,
			Keypoints = {
				{ 0, 170, 0, 0 }, { 0.23, 255, 0, 0 }, { 0.4, 255, 0, 0 }, { 0.63, 255, 0, 0 },
				{ 0.8, 255, 0, 0 }, { 1, 170, 0, 0 },
			},
		},
		Cosmic = {
			Rotation = 0,
			Keypoints = { { 0, 128, 0, 154 }, { 1, 116, 0, 217 } },
		},
		Secret = {
			Rotation = 90,
			Keypoints = {
				{ 0, 255, 255, 255 }, { 0.03, 255, 255, 255 }, { 0.14, 255, 255, 255 }, { 0.54, 255, 255, 255 },
				{ 0.55, 0, 0, 0 }, { 0.61, 97, 97, 97 }, { 0.65, 97, 97, 97 }, { 0.71, 97, 97, 97 },
				{ 0.76, 97, 97, 97 }, { 0.87, 97, 97, 97 }, { 0.91, 255, 255, 255 }, { 0.91, 255, 255, 255 },
				{ 0.93, 255, 255, 255 }, { 1, 255, 255, 255 },
			},
		},
		Eternal = {
			Rotation = -90,
			Keypoints = {
				{ 0, 16, 73, 124 }, { 0.02, 0, 16, 90 }, { 0.02, 0, 16, 90 }, { 0.09, 175, 201, 213 },
				{ 0.2, 224, 240, 255 }, { 0.34, 255, 180, 255 }, { 0.49, 68, 0, 127 }, { 0.52, 5, 1, 9 },
				{ 0.53, 255, 255, 255 }, { 0.74, 180, 255, 243 }, { 0.96, 39, 159, 175 }, { 1, 16, 73, 124 },
			},
		},
		Cash = {
			Rotation = 90,
			Keypoints = { { 0, 255, 255, 0 }, { 1, 21, 255, 0 } },
		},
	},
	Aliases = {
		Rainbow = "Rainbow12",
		Silver = "Silver14",
		Mutant = "Silver14",
	},
}

function Library:ResolveGameGradient(Name)
	if type(Name) ~= "string" then
		return nil
	end
	local G = Library.GameText.Gradients[Name]
	if G then
		return G
	end
	local Alias = Library.GameText.Aliases[Name]
	return Alias and Library.GameText.Gradients[Alias] or nil
end

function Library:ApplyGameText(Label, Name, Options)
	Options = Options or {}
	local G = Library:ResolveGameGradient(Name)
	if not Label or not G then
		return false
	end
	local kps = {}
	for _, kp in ipairs(G.Keypoints) do
		table.insert(kps, ColorSequenceKeypoint.new(kp[1], Color3.fromRGB(kp[2], kp[3], kp[4])))
	end
	Label.TextColor3 = Color3.new(1, 1, 1)
	local Grad = Label:FindFirstChild("N3GameGradient")
	if not Grad then
		Grad = New("UIGradient", {
			Name = "N3GameGradient",
			Parent = Label,
		})
	end
	Grad.Color = ColorSequence.new(kps)
	Grad.Rotation = G.Rotation
	if Options.Stroke ~= false then
		local Stroke = Label:FindFirstChild("N3GameStroke")
		if not Stroke then
			Stroke = New("UIStroke", {
				Name = "N3GameStroke",
				Parent = Label,
			})
		end
		Stroke.Color = Library.GameText.StrokeColor
		Stroke.Thickness = 1
	end
	return true
end

function Library:ClearGameText(Label)
	if not Label then
		return
	end
	pcall(function()
		Label:FindFirstChild("N3GameGradient"):Destroy()
	end)
	pcall(function()
		Label:FindFirstChild("N3GameStroke"):Destroy()
	end)
end

function Library:CreateWindow(WindowInfo)
	local RawWindowT = WindowInfo and WindowInfo.WindowTransparency
	local RawContentT = WindowInfo and WindowInfo.ContentTransparency
	local RawGroupT = WindowInfo and WindowInfo.GroupTransparency
	local RawContrast = WindowInfo and WindowInfo.GroupContrast
	WindowInfo = Library:Validate(WindowInfo, Templates.Window)
	if RawWindowT ~= nil then
		Library.Surface.WindowTransparency = ClampTransparency(RawWindowT)
	end
	if RawContentT ~= nil then
		Library.Surface.CanvasTransparency = ClampTransparency(RawContentT)
	end
	if RawGroupT ~= nil then
		Library.Surface.GroupTransparency = ClampTransparency(RawGroupT)
	end
	if RawContrast ~= nil then
		Library.Surface.GroupContrast = math.clamp(tonumber(RawContrast) or 0, 0, 100)
	end
	local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
	if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
		repeat
			ViewportSize = workspace.CurrentCamera.ViewportSize
			task.wait()
		until ViewportSize.X > 5 and ViewportSize.Y > 5
	end

	local MaxX = ViewportSize.X - 64
	local MaxY = ViewportSize.Y - 64

	Library.OriginalMinSize =
		Vector2.new(math.min(Library.OriginalMinSize.X, MaxX), math.min(Library.OriginalMinSize.Y, MaxY))
	Library.MinSize = Library.OriginalMinSize

	WindowInfo.Size = UDim2.fromOffset(
		math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
		math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
	)
	if typeof(WindowInfo.Font) == "EnumItem" then
		WindowInfo.Font = Font.fromEnum(WindowInfo.Font :: any)
	end
	WindowInfo.CornerRadius = math.min(WindowInfo.CornerRadius, 20)

	--// Old Naming \\--
	if WindowInfo.Compact ~= nil then
		WindowInfo.SidebarCompacted = WindowInfo.Compact
	end
	if WindowInfo.SidebarMinWidth ~= nil then
		WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
	end
	WindowInfo.MinSidebarWidth = math.max(50, WindowInfo.MinSidebarWidth)
	WindowInfo.SidebarCompactWidth = math.max(50, WindowInfo.SidebarCompactWidth)
	WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
	WindowInfo.CompactWidthActivation = math.max(50, WindowInfo.CompactWidthActivation)

	Library.CornerRadius = WindowInfo.CornerRadius
	Library:SetNotifySide(WindowInfo.NotifySide)
	Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
	Library.Scheme.Font = WindowInfo.Font
	Library.ToggleKeybind = WindowInfo.ToggleKeybind
	Library.GlobalSearch = WindowInfo.GlobalSearch

	Library.Animations = WindowInfo.Animations
	Library.TabTransitionInfo = TweenInfo.new(
		math.max(0, WindowInfo.TabTransitionTime or 0.22),
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)
	Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
	Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

	local IsDefaultSearchbarSize = WindowInfo.SearchbarSize == UDim2.fromScale(1, 1)
	local MainFrame
	local DividerLine
	local TitleHolder
	local WindowTitle
	local WindowIcon
	local RightWrapper
	local SearchBox
	local CurrentTabInfo
	local CurrentTabLabel
	local CurrentTabDescription
	local ResizeButton
	local Tabs
	local Container
	local BackgroundImage
	local BackgroundOverlay
	local BottomBackground
	local FooterLabel
	local TopBar

	local InitialLeftWidth = 52
	local IsCompact = WindowInfo.SidebarCompacted
	local LastExpandedWidth = InitialLeftWidth

	do
		Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu("Keybinds")
		Library.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
		Library.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
		Library.KeybindFrame.Visible = false

		MainFrame = New("TextButton", {
			BackgroundColor3 = function()
				return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
			end,
			Name = "Main",
			Text = "",
			Position = WindowInfo.Position,
			Size = WindowInfo.Size,
			Visible = false,
			Parent = ScreenGui,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
				Parent = MainFrame,
			})
		)
		table.insert(
			Library.Scales,
			New("UIScale", {
				Parent = MainFrame,
			})
		)
		Library:AddOutline(MainFrame)

		--// 1. NEON BORDER WINDOW LUAR (KETEBALAN KONSTAN 1.8px) \\--
		local MainStroke = New("UIStroke", {
			Name = "NeonWindowStroke",
			Color = "AccentColor",
			Thickness = 1.8,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = MainFrame,
		})

		--// INNER LASER CONTAINER (DEFAULT 100% MATI / BERSIH SAAT NORMAL) \\--
		local InnerBorderFrame = New("Frame", {
			Name = "InnerCollisionLaser",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -2, 1, -2),
			ZIndex = MainFrame.ZIndex + 2,
			Visible = false,
			Parent = MainFrame,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, math.max(0, WindowInfo.CornerRadius - 1)),
				Parent = InnerBorderFrame,
			})
		)

		local InnerStroke = New("UIStroke", {
			Color = Color3.fromRGB(255, 255, 255),
			Thickness = 1.4,
			Transparency = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = InnerBorderFrame,
		})

		local InnerGrad = Instance.new("UIGradient")
		InnerGrad.Rotation = -45
		InnerGrad.Parent = InnerStroke

		--// 2. 6-LAYER GLOW RAMPING LUAR \\--
		local GlowLayers = {
			{ Thickness = 1, Transparency = 0.15 },
			{ Thickness = 1.5, Transparency = 0.35 },
			{ Thickness = 2, Transparency = 0.55 },
			{ Thickness = 3, Transparency = 0.72 },
			{ Thickness = 4.5, Transparency = 0.85 },
			{ Thickness = 6.5, Transparency = 0.94 },
		}

		local OuterStrokes = { MainStroke }

		for i, layer in ipairs(GlowLayers) do
			local GlowFrame = New("Frame", {
				Name = "ChiyoGlowLayer_" .. i,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, layer.Thickness * 2, 1, layer.Thickness * 2),
				ZIndex = MainFrame.ZIndex - i,
				Parent = MainFrame,
			})
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, WindowInfo.CornerRadius + layer.Thickness),
					Parent = GlowFrame,
				})
			)
			local Stroke = New("UIStroke", {
				Color = "AccentColor",
				Thickness = layer.Thickness,
				Transparency = layer.Transparency,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = GlowFrame,
			})
			table.insert(OuterStrokes, Stroke)
		end

		local OuterGradients = {}
		for _, stroke in ipairs(OuterStrokes) do
			local Grad = Instance.new("UIGradient")
			Grad.Rotation = -45
			Grad.Parent = stroke
			table.insert(OuterGradients, Grad)
		end

		-- PALET WARNA DASAR
		local CyanBlue = Color3.fromRGB(0, 220, 255)
		local RadiantGold = Color3.fromRGB(255, 210, 30)
		local PureWhite = Color3.fromRGB(255, 255, 255)

		local function GetSolidSequence(accentColor)
			return ColorSequence.new(accentColor, accentColor)
		end

		for _, grad in ipairs(OuterGradients) do
			grad.Color = GetSolidSequence(Library.Scheme.AccentColor)
		end

		Library:AddOutlineSpin(MainFrame)

		--// 3. FLUID LERP ENGINE: SATU ALIRAN PENUH TANPA JEDA & TANPA KEJUT \\--
		local PulseGeneration = 0

		function Library:PulseWindowGlow()
			if Library.Unloaded or not MainFrame or not MainFrame.Parent or not Library.Toggled then
				return
			end

			PulseGeneration = PulseGeneration + 1
			local curGen = PulseGeneration

			task.spawn(function()
				local curAccent = Library.Scheme.AccentColor
				InnerBorderFrame.Visible = true

				local timeline = Instance.new("NumberValue")
				timeline.Value = 0

				local animTween = TweenService:Create(
					timeline,
					TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
					{ Value = 1.0 }
				)

				local animConn = timeline:GetPropertyChangedSignal("Value"):Connect(function()
					local t = timeline.Value

					if t < 0.60 then
						local crawl = t / 0.60
						local reach = math.clamp(0.03 + crawl * 0.46, 0.03, 0.49)

						InnerStroke.Transparency = math.clamp(1 - (t / 0.15) * 0.9, 0.1, 1)

						local seq = ColorSequence.new({
							ColorSequenceKeypoint.new(0.00, PureWhite),
							ColorSequenceKeypoint.new(math.clamp(reach * 0.5, 0.01, 0.24), RadiantGold),
							ColorSequenceKeypoint.new(reach, curAccent),
							ColorSequenceKeypoint.new(math.clamp(1.00 - reach, 0.51, 0.98), curAccent),
							ColorSequenceKeypoint.new(math.clamp(1.00 - reach * 0.5, 0.76, 0.99), CyanBlue),
							ColorSequenceKeypoint.new(1.00, PureWhite),
						})

						for _, grad in ipairs(OuterGradients) do
							if grad and grad.Parent then
								grad.Color = seq
							end
						end
						InnerGrad.Color = seq
					else
						-- [FASE 2]: KETEMU DI TENGAH & LANGSUNG MELEBUR HILANG (t = 0.60 s/d 1.0)
						local dissolve = (t - 0.60) / 0.40

						InnerStroke.Transparency = math.clamp(0.1 + dissolve * 0.9, 0.1, 1)

						local goldFade = RadiantGold:Lerp(curAccent, dissolve)
						local blueFade = CyanBlue:Lerp(curAccent, dissolve)
						local whiteCenter = PureWhite:Lerp(curAccent, dissolve)

						local seq = ColorSequence.new({
							ColorSequenceKeypoint.new(0.00, whiteCenter),
							ColorSequenceKeypoint.new(0.24, goldFade),
							ColorSequenceKeypoint.new(0.48, whiteCenter),
							ColorSequenceKeypoint.new(0.52, whiteCenter),
							ColorSequenceKeypoint.new(0.76, blueFade),
							ColorSequenceKeypoint.new(1.00, whiteCenter),
						})

						for _, grad in ipairs(OuterGradients) do
							if grad and grad.Parent then
								grad.Color = seq
							end
						end
						InnerGrad.Color = seq
					end
				end)

				animTween:Play()
				animTween.Completed:Wait()
				animConn:Disconnect()
				timeline:Destroy()

				if curGen == PulseGeneration then
					InnerBorderFrame.Visible = false
					InnerStroke.Transparency = 1

					local solidSeq = GetSolidSequence(Library.Scheme.AccentColor)
					for _, grad in ipairs(OuterGradients) do
						if grad and grad.Parent then
							grad.Color = solidSeq
						end
					end
				end
			end)
		end

		local function HookGlowClicks(Obj)
			if Obj:IsA("GuiButton") and not Obj:GetAttribute("NoGlowPulse") then
				Obj.Activated:Connect(function()
					Library:PulseWindowGlow()
				end)
			end
		end

		for _, Obj in ipairs(MainFrame:GetDescendants()) do
			HookGlowClicks(Obj)
		end

		MainFrame.DescendantAdded:Connect(HookGlowClicks)

		Library:MakeLine(MainFrame, {
			Position = UDim2.fromOffset(0, 48),
			Size = UDim2.new(1, 0, 0, 1),
		})

		DividerLine = New("Frame", {
			BackgroundColor3 = "OutlineColor",
			Position = UDim2.fromOffset(InitialLeftWidth, 0),
			Size = UDim2.new(0, 1, 1, -21),
			Parent = MainFrame,
			ZIndex = 2,
		})

		local BackgroundIcon = Library:GetCustomIcon(WindowInfo.BackgroundImage)
		local WallpaperLayer = ResolveWallpaperLayer(WindowInfo.BackgroundImageLayer)

		BackgroundImage = New("ImageLabel", {
			Image = BackgroundIcon and BackgroundIcon.Url or "",
			ImageRectOffset = BackgroundIcon and BackgroundIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = BackgroundIcon and BackgroundIcon.ImageRectSize or Vector2.zero,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			ScaleType = ResolveScaleType(WindowInfo.BackgroundImageScaleType),
			ZIndex = WallpaperLayer.Image,
			BackgroundTransparency = 1,
			ImageColor3 = WindowInfo.BackgroundImageColor,
			ImageTransparency = ClampTransparency(WindowInfo.BackgroundImageTransparency),
			Visible = BackgroundIcon ~= nil,
			Parent = MainFrame,
		})

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
				Parent = BackgroundImage,
			})
		)

		BackgroundOverlay = New("Frame", {
			BackgroundColor3 = WindowInfo.BackgroundOverlayColor,
			BackgroundTransparency = ClampTransparency(WindowInfo.BackgroundOverlayTransparency),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			ZIndex = WallpaperLayer.Overlay,
			Visible = WindowInfo.BackgroundOverlayEnabled == true,
			Parent = MainFrame,
		})

		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
				Parent = BackgroundOverlay,
			})
		)

		local GlowClip = New("Frame", {
			Name = "CursorGlowClip",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			ZIndex = 0,
			Parent = MainFrame,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
				Parent = GlowClip,
			})
		)
		Library.CursorGlowHolder = New("Frame", {
			Name = "CursorGlow",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(0, 0),
			Visible = false,
			ZIndex = 0,
			Parent = GlowClip,
		})
		local GLOW_LAYERS = 16
		local WeightSum = 0
		for Index = 1, GLOW_LAYERS do
			WeightSum += (1 - Index / GLOW_LAYERS) ^ 2
		end
		Library.CursorGlowLayers = {}
		for Index = 1, GLOW_LAYERS do
			local Frac = Index / GLOW_LAYERS
			local Layer = {
				Frac = Frac,
				Weight = ((1 - Frac) ^ 2) / WeightSum,
				Frame = New("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Library:GetCursorGlowColor(),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(0, 0),
					ZIndex = 0,
					Parent = Library.CursorGlowHolder,
				}),
			}
			table.insert(Library.CursorGlowLayers, Layer)
			New("UICorner", {
				CornerRadius = UDim.new(0.5, 0),
				Parent = Layer.Frame,
			})
		end
		Library:ApplyCursorGlow()
		Library:StartCursorGlowLoop()

		if WindowInfo.Center then
			MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
		end

		--// Top Bar \\-
		TopBar = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 48),
			Parent = MainFrame,
		})
		Library:MakeDraggable(MainFrame, TopBar, false, true)

		--// Title \\--
		TitleHolder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, InitialLeftWidth, 1, 0),
			Parent = TopBar,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
			Parent = TitleHolder,
		})

		if WindowInfo.Icon then
			local Icon = Library:GetCustomIcon(WindowInfo.Icon)
			WindowIcon = New("ImageLabel", {
				Image = Icon.Url,
				ImageRectOffset = Icon.ImageRectOffset,
				ImageRectSize = Icon.ImageRectSize,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = WindowInfo.IconSize,
				Parent = TitleHolder,
			})
		else
			WindowIcon = New("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Size = WindowInfo.IconSize,
				Text = WindowInfo.Title:sub(1, 1),
				TextScaled = true,
				Visible = false,
				Parent = TitleHolder,
			})
		end

		local WindowIconScale = New("UIScale", { Scale = 1, Parent = WindowIcon })
		WindowIcon.MouseEnter:Connect(function()
			Library:TweenTabZoom(WindowIconScale, Library.TabAppearance.HoverZoom or 1)
		end)
		WindowIcon.MouseLeave:Connect(function()
			Library:TweenTabZoom(WindowIconScale, 1)
		end)

		local X = Library:GetTextBounds(
			WindowInfo.Title,
			Library.Scheme.Font,
			20,
			TitleHolder.AbsoluteSize.X - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0) - 12
		)
		WindowTitle = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, X, 1, 0),
			Text = WindowInfo.Title,
			TextSize = 20,
			Visible = false,
			Parent = TitleHolder,
		})

		--// Top Right Bar (Search Bar Panjang Lebar Penuh Ala Chiyo) \\--
		RightWrapper = New("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -76, 0.5, 0),
			Size = UDim2.new(1, -InitialLeftWidth - 119, 0, 34),
			Parent = TopBar,
		})

		local SearchFrame = New("Frame", {
			BackgroundColor3 = "MainColor",
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			Visible = not (WindowInfo.DisableSearch or false),
			Parent = RightWrapper,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
				Parent = SearchFrame,
			})
		)
		New("UIStroke", {
			Color = "OutlineColor",
			Parent = SearchFrame,
		})
		MakeGradient(SearchFrame)

		-- Icon Search Kiri
		local SearchIcon = Library:GetIcon("search")
		if SearchIcon then
			New("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Image = SearchIcon.Url,
				ImageColor3 = "FontColor",
				ImageRectOffset = SearchIcon.ImageRectOffset,
				ImageRectSize = SearchIcon.ImageRectSize,
				ImageTransparency = 0.4,
				Position = UDim2.new(0, 12, 0.5, 0),
				Size = UDim2.fromOffset(18, 18),
				Parent = SearchFrame,
			})
		end

		-- Input Search Tengah
		SearchBox = New("TextBox", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			PlaceholderText = "Search",
			Position = UDim2.new(0, 36, 0.5, 0),
			Size = UDim2.new(1, -48, 1, 0),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = SearchFrame,
		})

		Library:GiveSignal(SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
			Library:UpdateSearch(SearchBox.Text)
		end))

		local StatusHolder = New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			Parent = RightWrapper,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 6),
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Parent = StatusHolder,
		})
		Library.StatusBarLabels = {}
		for _, Key in ipairs({ "Fps", "Ping", "Server", "Executor" }) do
			local Card = New("Frame", {
				BackgroundColor3 = "MainColor",
				Size = UDim2.new(0.25, -6, 1, 0),
				Parent = StatusHolder,
			})
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
					Parent = Card,
				})
			)
			New("UIStroke", {
				Color = "OutlineColor",
				Parent = Card,
			})
			MakeGradient(Card)
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 4),
				Parent = Card,
			})
			New("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 16),
				Text = Key .. ":",
				TextColor3 = "AccentColor",
				TextSize = 13,
				Parent = Card,
			})
			Library.StatusBarLabels[Key] = New("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 16),
				Text = "-",
				TextColor3 = "FontColor",
				TextSize = 13,
				Parent = Card,
			})
		end

		local StatusButtons = {}
		local StatusMode = false
		local function SetStatusMode(On: boolean, Dir: number)
			StatusMode = On
			SearchFrame.Visible = not On and not (WindowInfo.DisableSearch or false)
			StatusHolder.Visible = On
			local Incoming = On and StatusHolder or SearchFrame
			Incoming.Position = UDim2.fromOffset(Dir * 24, 0)
			local Slide = TweenService:Create(
				Incoming,
				TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{ Position = UDim2.fromOffset(0, 0) }
			)
			Slide:Play()
			if On then
				Library.ExecutorName = Library:GetExecutorName()
				Library:StartStatusBarLoop()
			else
				Library:StopStatusBarLoop()
			end
		end
		for _, Slot in ipairs({
			{ Anchor = Vector2.new(1, 0.5), Position = UDim2.new(0, -6, 0.5, 0), Dir = -1, Name = "chevron-left" },
			{ Anchor = Vector2.new(0, 0.5), Position = UDim2.new(1, 6, 0.5, 0), Dir = 1, Name = "chevron-right" },
		}) do
			local SlotIcon = Library:GetIcon(Slot.Name)
			local Btn = New("ImageButton", {
				AnchorPoint = Slot.Anchor,
				BackgroundTransparency = 1,
				Image = SlotIcon and SlotIcon.Url or "",
				ImageColor3 = "FontColor",
				ImageRectOffset = SlotIcon and SlotIcon.ImageRectOffset or Vector2.zero,
				ImageRectSize = SlotIcon and SlotIcon.ImageRectSize or Vector2.zero,
				Position = Slot.Position,
				Size = UDim2.fromOffset(18, 18),
				Parent = RightWrapper,
			})
			table.insert(StatusButtons, Btn)
			Btn.MouseButton1Click:Connect(function()
				SetStatusMode(not StatusMode, Slot.Dir)
			end)
		end
		if MoveIcon then
			New("ImageLabel", {
				AnchorPoint = Vector2.new(1, 0.5),
				Image = MoveIcon.Url,
				ImageColor3 = "OutlineColor",
				ImageRectOffset = MoveIcon.ImageRectOffset,
				ImageRectSize = MoveIcon.ImageRectSize,
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(28, 28),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Parent = TopBar,
			})
		end

		--// Bottom Bar \\--
		BottomBackground = New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = function()
				return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
			end,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 20),
			Parent = MainFrame,
		})
		Library:MakeLine(MainFrame, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, -20),
			Size = UDim2.new(1, 0, 0, 1),
		})

		local BottomBar = New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 20),
			Parent = MainFrame,
		})
		table.insert(
			Library.SpecificCorners,
			New("UICorner", {
				TopLeftRadius = UDim.new(0, 0),
				TopRightRadius = UDim.new(0, 0),
				BottomRightRadius = UDim.new(0, WindowInfo.CornerRadius),
				BottomLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
				Parent = BottomBackground,
			})
		)

		--// Footer \\-
		FooterLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = WindowInfo.Footer,
			TextSize = 14,
			TextTransparency = 0.5,
			Parent = BottomBar,
		})

		--// Resize Button \\--
		if WindowInfo.Resizable then
			ResizeButton = New("TextButton", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Text = "",
				Parent = BottomBar,
			})

			Library:MakeResizable(MainFrame, ResizeButton, function()
				for _, Tab in Library.Tabs do
					Tab:Resize(true)
				end
			end)
		end

		New("ImageLabel", {
			Image = ResizeIcon and ResizeIcon.Url or "",
			ImageColor3 = "FontColor",
			ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2.zero,
			ImageTransparency = 0.5,
			Position = UDim2.fromOffset(2, 2),
			Size = UDim2.new(1, -4, 1, -4),
			Parent = ResizeButton,
		})

		--// Tabs \\--
		Tabs = New("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = function()
				return Library:GetCanvasColor()
			end,
			CanvasSize = UDim2.fromScale(0, 0),
			Position = UDim2.fromOffset(0, 49),
			ScrollBarThickness = 0,
			Size = UDim2.new(0, InitialLeftWidth, 1, -70),
			Parent = MainFrame,
		})
		Tabs.BackgroundTransparency = ClampTransparency(Library.Surface.CanvasTransparency)
		Library.SurfaceCanvas[Tabs] = true
		New("UIListLayout", {
			Parent = Tabs,
		})

		--// Container \\--
		Container = New("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = function()
				return Library:GetCanvasColor()
			end,
			ClipsDescendants = true,
			Name = "Container",
			Position = UDim2.new(1, 0, 0, 49),
			Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
			Parent = MainFrame,
		})
		Container.BackgroundTransparency = ClampTransparency(Library.Surface.CanvasTransparency)
		Library.SurfaceCanvas[Container] = true
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 0),
			Parent = Container,
		})

		Library.WindowContainer = Container
		Library.SurfaceWindow = MainFrame
		MainFrame.BackgroundTransparency = ClampTransparency(Library.Surface.WindowTransparency)
	end

	--// Window Table \\--
	local Window = {}
	local Fading = false
	local FadeToken = 0

	local function SetUICorner(UICorner, Corner, HalfCurrent, HalfValue, Value)
		local Current = UICorner[Corner]
		if Current.Offset == 0 and Current.Scale == 0 then
			return
		end

		UICorner[Corner] = Current.Offset == HalfCurrent and HalfValue or Value
	end

	function Window:ChangeTitle(title)
		assert(typeof(title) == "string", "Expected string for title got: " .. typeof(title))

		WindowTitle.Text = title
		WindowInfo.Title = title
	end

	function Window:SetBackgroundImage(Image: string)
		local ValidIcon = false

		if typeof(Image) == "number" then
			Image = string.format("rbxassetid://%d", Image)
		end

		if typeof(Image) == "string" then
			local BackgroundIcon = Library:GetCustomIcon(Image)

			if BackgroundIcon then
				ValidIcon = true

				BackgroundImage.Image = BackgroundIcon.Url
				BackgroundImage.ImageRectOffset = BackgroundIcon.ImageRectOffset
				BackgroundImage.ImageRectSize = BackgroundIcon.ImageRectSize
				BackgroundImage.Visible = true
			elseif Image:match("http://") or Image:match("https://") then
				local RawFileName = Image:match("(.+)%..+$")
				local _, Domain = Image:match("^(https?://)([^/]+)")

				if RawFileName and Domain then
					local Extention = string.sub(Image, #RawFileName + 1, #Image)
					local FileNamePos = RawFileName:gsub("\\", "/"):find("/[^/]*$")
					local FileName = FileNamePos and Image:sub(FileNamePos + 1) or nil

					if FileName then
						ValidIcon = true

						local AssetName = Domain .. FileName
						if #AssetName > 255 then
							local NewLength = 255 - #Domain - #Extention
							if NewLength < 0 then
								AssetName = Domain .. Extention
							else
								AssetName = Domain
									.. string.sub(FileName:sub(1, #FileName - #Extention), 1, NewLength)
									.. Extention
							end
						end

						if CustomImageManagerAssets[FileName] == nil then
							CustomImageManager.AddAsset(FileName, 0, Image)
						else
							CustomImageManager.DownloadAsset(FileName, true)
						end

						BackgroundImage.Image = CustomImageManager.GetAsset(FileName)
						BackgroundImage.ImageRectOffset = Vector2.zero
						BackgroundImage.ImageRectSize = Vector2.zero
						BackgroundImage.Visible = true
					end
				end
			end
		end

		if not ValidIcon then
			BackgroundImage.Image = ""
			BackgroundImage.ImageRectOffset = Vector2.zero
			BackgroundImage.ImageRectSize = Vector2.zero
			BackgroundImage.Visible = false
		end

		WindowInfo.BackgroundImage = Image
	end


	function Window:SetBackgroundImageTransparency(Transparency: number)
		BackgroundImage.ImageTransparency = ClampTransparency(Transparency)
		WindowInfo.BackgroundImageTransparency = BackgroundImage.ImageTransparency
	end

	function Window:SetBackgroundImageScaleType(ScaleType: Enum.ScaleType | string)
		BackgroundImage.ScaleType = ResolveScaleType(ScaleType)
		WindowInfo.BackgroundImageScaleType = ScaleType
	end

	function Window:SetBackgroundImageColor(Color: Color3)
		assert(typeof(Color) == "Color3", "Expected Color3 for wallpaper tint got: " .. typeof(Color))
		BackgroundImage.ImageColor3 = Color
		WindowInfo.BackgroundImageColor = Color
	end

	function Window:SetBackgroundImageLayer(Layer: string)
		local Resolved = ResolveWallpaperLayer(Layer)
		BackgroundImage.ZIndex = Resolved.Image
		BackgroundOverlay.ZIndex = Resolved.Overlay
		WindowInfo.BackgroundImageLayer = (Layer:lower() == "front") and "front" or "back"
	end

	function Window:SetBackgroundOverlay(Enabled: boolean?, Color: Color3?, Transparency: number?)
		if Enabled ~= nil then
			BackgroundOverlay.Visible = Enabled == true
			WindowInfo.BackgroundOverlayEnabled = Enabled == true
		end

		if Color ~= nil then
			assert(typeof(Color) == "Color3", "Expected Color3 for overlay got: " .. typeof(Color))
			BackgroundOverlay.BackgroundColor3 = Color
			WindowInfo.BackgroundOverlayColor = Color
		end

		if Transparency ~= nil then
			BackgroundOverlay.BackgroundTransparency = ClampTransparency(Transparency)
			WindowInfo.BackgroundOverlayTransparency = BackgroundOverlay.BackgroundTransparency
		end
	end

	function Window:GetWallpaperInfo()
		local ScaleEnum = tostring(BackgroundImage.ScaleType)

		return {
			Image = WindowInfo.BackgroundImage,
			Visible = BackgroundImage.Visible,
			Transparency = BackgroundImage.ImageTransparency,
			ScaleType = BackgroundImage.ScaleType,
			ScaleTypeName = ScaleEnum:match("%.(%w+)$") or ScaleEnum,
			Color = BackgroundImage.ImageColor3,
			Layer = WindowInfo.BackgroundImageLayer,
			ZIndex = BackgroundImage.ZIndex,
			OverlayEnabled = BackgroundOverlay.Visible,
			OverlayColor = BackgroundOverlay.BackgroundColor3,
			OverlayTransparency = BackgroundOverlay.BackgroundTransparency,

			CanvasTransparency = Library.Surface.CanvasTransparency,
			GroupTransparency = Library.Surface.GroupTransparency,
			GroupContrast = Library.Surface.GroupContrast,
			GroupSurfaceColor = Library:GetGroupSurfaceColor(),
			GroupColorOverride = Library.Surface.GroupColor,
			CanvasColor = Library:GetCanvasColor(),
			CanvasColorOverride = Library.Surface.CanvasColor,
			WindowTransparency = Library.Surface.WindowTransparency,
		}
	end

	function Window:SetSurface(Info: { [string]: any })
		return Library:SetSurface(Info)
	end

	function Window:SetFooter(Footer: string)
		assert(typeof(Footer) == "string", "Expected string for footer got: " .. typeof(Footer))

		FooterLabel.Text = Footer
		WindowInfo.Footer = Footer
	end

	function Window:SetCornerRadius(Radius: number)
		assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
		Radius = math.min(Radius, 20)

		local RadiusHalf = UDim.new(0, Radius / 2)
		local RadiusUDim = UDim.new(0, Radius)
		local HalfCurrent = Library.CornerRadius / 2

		for _, UICorner in Library.Corners do
			if UICorner.CornerRadius.Offset == HalfCurrent then
				UICorner.CornerRadius = RadiusHalf
			else
				UICorner.CornerRadius = RadiusUDim
			end
		end

		for _, UICorner in Library.SpecificCorners do
			SetUICorner(UICorner, "TopRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
			SetUICorner(UICorner, "TopLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
			SetUICorner(UICorner, "BottomRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
			SetUICorner(UICorner, "BottomLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
		end

		Library.CornerRadius = Radius
		WindowInfo.CornerRadius = Radius

		ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
		BottomBackground.Size = UDim2.new(1, 0, 0, 20 + Radius)

		for _, Tab in Library.Tabs do
			if Tab.IsKeyTab then
				continue
			end

			for _, Tabbox in Tab.Tabboxes do
				Tabbox:UpdateCorners()
			end
		end
	end

	function Window:SetAnimations(
		Animations: { [string]: boolean }?,
		TabTransitionTime: number?,
		TabSwipeOffset: number?,
		TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?
	)
		if typeof(Animations) == "table" then
			WindowInfo.Animations = Animations
			Library.Animations = Animations
		end

		if typeof(TabTransitionTime) == "number" then
			local TweenInfo =
				TweenInfo.new(math.max(0, TabTransitionTime or 0.22), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			WindowInfo.TabTransitionInfo = TweenInfo
			Library.TabTransitionInfo = TweenInfo
		end

		if typeof(TabSwipeOffset) == "number" then
			TabSwipeOffset = math.max(1, TabSwipeOffset)

			WindowInfo.TabSwipeOffset = TabSwipeOffset
			Library.TabSwipeOffset = TabSwipeOffset
		end

		if typeof(TabSwipeFrom) == "string" then
			TabSwipeFrom = string.lower(TabSwipeFrom)

			WindowInfo.TabSwipeFrom = TabSwipeFrom
			Library.TabSwipeFrom = TabSwipeFrom
		end
	end

	local function ApplyCompact()
		for _, Button in Library.TabButtons do
			if not Button.Icon then
				continue
			end

			Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 6 or 11)
			Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 6 or 12)
			Button.Padding.PaddingRight = UDim.new(0, IsCompact and 6 or 12)
			Button.Padding.PaddingTop = UDim.new(0, IsCompact and 6 or 11)
		end
	end

	function Window:IsSidebarCompacted()
		return IsCompact
	end

	function Window:SetCompact(State)
		Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
	end

	function Window:GetSidebarWidth()
		return Tabs.Size.X.Offset
	end

	function Window:SetSidebarWidth(Width)
		Width = math.clamp(Width, 50, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

		DividerLine.Position = UDim2.fromOffset(Width, 0)

		TitleHolder.Size = UDim2.new(0, Width, 1, 0)
		RightWrapper.Size = UDim2.new(1, -Width - 55, 0, 34)
		Tabs.Size = UDim2.new(0, Width, 1, -70)
		Container.Size = UDim2.new(1, -Width - 1, 1, -70)

		if WindowInfo.EnableCompacting then
			ApplyCompact()
		end
		if not IsCompact then
			LastExpandedWidth = Width
		end
	end

	function Window:ShowTabInfo(Name, Description)
		if CurrentTabInfo and CurrentTabLabel and CurrentTabDescription then
			CurrentTabLabel.Text = Name
			CurrentTabDescription.Text = Description
			CurrentTabInfo.Visible = true
		end
	end

	function Window:HideTabInfo()
		if CurrentTabInfo then
			CurrentTabInfo.Visible = false
		end
	end

	function Window:AddTab(...)
		local Name = nil
		local Icon = nil
		local Description = nil

		if select("#", ...) == 1 and typeof(...) == "table" then
			local Info = select(1, ...)
			Name = Info.Name or "Tab"
			Icon = Info.Icon
			Description = Info.Description
		else
			Name = select(1, ...)
			Icon = select(2, ...)
			Description = select(3, ...)
		end

		local TabButton: TextButton
		local TabLabel
		local TabIcon
		local TabIconCard
		local TabIconScale
		local TabRec

		local TabContainer
		local TabCanvas
		local TabLeft
		local TabRight

		Icon = Library:GetCustomIcon(Icon)
		do
			TabButton = New("TextButton", {
				BackgroundColor3 = "MainColor",
				BackgroundTransparency = Library.TabAppearance.TabBackgroundTransparency,
				Size = UDim2.new(1, 0, 0, 44),
				Text = "",
				Parent = Tabs,
			})
			local ButtonPadding = New("UIPadding", {
				PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
				PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
				PaddingRight = UDim.new(0, IsCompact and 6 or 12),
				PaddingTop = UDim.new(0, IsCompact and 6 or 11),
				Parent = TabButton,
			})

			TabLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -30, 1, 0),
				Text = Name,
				TextSize = 16,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false,
				Parent = TabButton,
			})

			if Icon then
				TabIcon = New("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = Icon.Url,
					ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
					ImageRectOffset = Icon.ImageRectOffset,
					ImageRectSize = Icon.ImageRectSize,
					ImageTransparency = 0.5,
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromOffset(24, 24),
					Parent = TabButton,
				})
				TabIconCard, TabIconScale = Library:CreateTabIconCard(TabIcon)
			end

			table.insert(Library.TabButtons, {
				Label = TabLabel,
				Padding = ButtonPadding,
				Icon = TabIcon,
			})

			TabRec = { Button = TabButton, Icon = TabIcon, Card = TabIconCard, Scale = TabIconScale }
			table.insert(Library.TabVisuals, TabRec)

			--// Tab Canvas \\--
			TabCanvas = New("CanvasGroup", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				GroupTransparency = 0,
				Size = UDim2.fromScale(1, 1),
				Visible = false,
				Parent = Container,
			})

			--// Tab Container \\--
			TabContainer = New("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 1),
				Visible = true,
				Parent = TabCanvas,
			})

			TabLeft = New("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarImageTransparency = 1,
				ScrollBarThickness = 0,
				Size = UDim2.new(0.5, -3, 1, 0),
				Parent = TabContainer,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 2),
				Parent = TabLeft,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 2),
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 2),
				Parent = TabLeft,
			})
			do
				New("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = -1,
					Parent = TabLeft,
				})
				New("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Parent = TabLeft,
				})
			end

			TabRight = New("ScrollingFrame", {
				AnchorPoint = Vector2.new(1, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 0),
				Position = UDim2.fromScale(1, 0),
				ScrollBarImageTransparency = 1,
				ScrollBarThickness = 0,
				Size = UDim2.new(0.5, -3, 1, 0),
				Parent = TabContainer,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 2),
				Parent = TabRight,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 2),
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 2),
				Parent = TabRight,
			})
			do
				New("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = -1,
					Parent = TabRight,
				})
				New("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Parent = TabRight,
				})
			end
		end

		--// Warning Box \\--
		local WarningBoxHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 7),
			Size = UDim2.fromScale(1, 0),
			Visible = false,
			Parent = TabContainer,
		})

		local WarningBox
		local WarningBoxOutline
		local WarningBoxShadowOutline
		local WarningBoxScrollingFrame
		local WarningTitle
		local WarningStroke
		local WarningText
		do
			WarningBox = New("Frame", {
				BackgroundColor3 = "BackgroundColor",
				Position = UDim2.fromOffset(2, 0),
				Size = UDim2.new(1, -5, 0, 0),
				Parent = WarningBoxHolder,
			})
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
					Parent = WarningBox,
				})
			)
			WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)

			WarningBoxScrollingFrame = New("ScrollingFrame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 3,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Parent = WarningBox,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
				PaddingTop = UDim.new(0, 4),
				Parent = WarningBoxScrollingFrame,
			})

			WarningTitle = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -4, 0, 14),
				Text = "",
				TextColor3 = Color3.fromRGB(255, 50, 50),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = WarningBoxScrollingFrame,
			})

			WarningStroke = New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				Color = Color3.fromRGB(169, 0, 0),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Parent = WarningTitle,
			})

			WarningText = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 16),
				Size = UDim2.new(1, -4, 0, 0),
				Text = "",
				TextSize = 14,
				TextWrapped = true,
				Parent = WarningBoxScrollingFrame,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			})

			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				Color = "DarkColor",
				LineJoinMode = Enum.LineJoinMode.Miter,
				Parent = WarningText,
			})
		end

		--// Tab Table \\--
		local Tab = {
			Description = Description,

			Connections = {},
			Destroyed = false,

			Window = Window,
			Canvas = TabCanvas,
			Sides = {
				TabLeft,
				TabRight,
			},
			WarningBox = {
				IsNormal = false,
				LockSize = false,
				Visible = false,
				Title = "WARNING",
				Text = "",
			},

			Groupboxes = {},
			Tabboxes = {},
			DependencyGroupboxes = {},
		}

		function Tab:UpdateWarningBox(Info)
			if typeof(Info.IsNormal) == "boolean" then
				Tab.WarningBox.IsNormal = Info.IsNormal
			end
			if typeof(Info.LockSize) == "boolean" then
				Tab.WarningBox.LockSize = Info.LockSize
			end
			if typeof(Info.Visible) == "boolean" then
				Tab.WarningBox.Visible = Info.Visible
			end
			if typeof(Info.Title) == "string" then
				Tab.WarningBox.Title = Info.Title
			end
			if typeof(Info.Text) == "string" then
				Tab.WarningBox.Text = Info.Text
			end

			WarningBoxHolder.Visible = Tab.WarningBox.Visible
			WarningTitle.Text = Tab.WarningBox.Title
			WarningText.Text = Tab.WarningBox.Text
			Tab:Resize(true)

			WarningBox.BackgroundColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor
				or Color3.fromRGB(127, 0, 0)

			WarningBoxShadowOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor
				or Color3.fromRGB(85, 0, 0)
			WarningBoxOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
				or Color3.fromRGB(255, 50, 50)

			WarningTitle.TextColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor
				or Color3.fromRGB(255, 50, 50)
			WarningStroke.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
				or Color3.fromRGB(169, 0, 0)

			if not Library.Registry[WarningBox] then
				Library:AddToRegistry(WarningBox, {})
			end
			if not Library.Registry[WarningBoxShadowOutline] then
				Library:AddToRegistry(WarningBoxShadowOutline, {})
			end
			if not Library.Registry[WarningBoxOutline] then
				Library:AddToRegistry(WarningBoxOutline, {})
			end
			if not Library.Registry[WarningTitle] then
				Library:AddToRegistry(WarningTitle, {})
			end
			if not Library.Registry[WarningStroke] then
				Library:AddToRegistry(WarningStroke, {})
			end

			Library.Registry[WarningBox].BackgroundColor3 = function()
				return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
			end

			Library.Registry[WarningBoxShadowOutline].Color = function()
				return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor or Color3.fromRGB(85, 0, 0)
			end

			Library.Registry[WarningBoxOutline].Color = function()
				return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
			end

			Library.Registry[WarningTitle].TextColor3 = function()
				return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
			end

			Library.Registry[WarningStroke].Color = function()
				return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
			end
		end

		function Tab:RefreshSides()
			local Offset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
			for _, Side in Tab.Sides do
				Side.Position = UDim2.new(Side.Position.X.Scale, 0, 0, Offset)
				Side.Size = UDim2.new(0.5, -3, 1, -Offset)
			end
		end

		function Tab:Resize(ResizeWarningBox: boolean?)
			if ResizeWarningBox then
				local MaximumSize = math.floor(TabContainer.AbsoluteSize.Y / 3.25)
				local _, YText = Library:GetTextBounds(
					WarningText.Text,
					Library.Scheme.Font,
					WarningText.TextSize,
					WarningText.AbsoluteSize.X
				)

				local YBox = 24 + YText
				if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
					WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
					YBox = MaximumSize
				else
					WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
				end

				WarningText.Size = UDim2.new(1, -4, 0, YText)
				WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
			end

			Tab:RefreshSides()
		end

		local function AddTabbox(self, Info)
			local ParentObj = self

			local BoxHolder = New("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				Parent = if ParentObj.Type == "Groupbox"
					then ParentObj.Container
					else (Info.Side == 1 and TabLeft or TabRight),
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				Parent = BoxHolder,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 4),
				PaddingTop = UDim.new(0, 4),
				Parent = BoxHolder,
			})

			local TabboxHolder
			local TabboxButtons

			do
				local Nested = Library:IsInsideSurfaceCard(BoxHolder)
				TabboxHolder = New("Frame", {
					BackgroundColor3 = function()
						return Library:GetGroupSurfaceColor()
					end,
					BackgroundTransparency = Nested and 1 or ClampTransparency(Library.Surface.GroupTransparency),
					ClipsDescendants = true,
					Size = UDim2.fromScale(1, 0),
					Parent = BoxHolder,
				})
				if not Nested then
					Library.SurfaceGroups[TabboxHolder] = true
				end
				table.insert(
					Library.Corners,
					New("UICorner", {
						CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
						Parent = TabboxHolder,
					})
				)
				Library:AddOutline(TabboxHolder)

				TabboxButtons = New("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 34),
					Parent = TabboxHolder,
				})
				New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Parent = TabboxButtons,
				})
			end

			local TotalTabs = 0
			local FirstTab
			local LastTab

			local Tabbox = {
				Connections = {},
				Destroyed = false,

				ActiveTab = nil,

				BoxHolder = BoxHolder,
				Holder = TabboxHolder,
				Tabs = {},
			}

			function Tabbox:UpdateCorners()
				for _, Tab in Tabbox.Tabs do
					Tab:UpdateCorners()
				end
			end

			function Tabbox:AddTab(Name, IconName)
				TotalTabs = TotalTabs + 1
				local TabIndex = TotalTabs

				LastTab = TabIndex
				if not FirstTab then
					FirstTab = TabIndex
				end

				local IsNameEmpty = Name == nil or Trim(tostring(Name)) == ""
				local TabStoringIndex = IsNameEmpty and tostring(TabIndex) or Name

				local Button = New("TextButton", {
					BackgroundColor3 = "MainColor",
					BackgroundTransparency = 0,
					Size = UDim2.fromOffset(0, 34),
					Text = "",
					Parent = TabboxButtons,
				})

				local ButtonCorner = New("UICorner", {
					TopLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
					TopRightRadius = UDim.new(0, WindowInfo.CornerRadius),
					BottomRightRadius = UDim.new(0, 0),
					BottomLeftRadius = UDim.new(0, 0),
					Parent = Button,
				})
				table.insert(Library.SpecificCorners, ButtonCorner)

				local ButtonContent = New("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(0, 16),
					Parent = Button,
				})
				New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 8),
					Parent = ButtonContent,
				})

				local ButtonIcon
				local BoxIcon = Library:GetCustomIcon(IconName)
				if BoxIcon then
					ButtonIcon = New("ImageLabel", {
						Image = BoxIcon.Url,
						ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
						ImageRectOffset = BoxIcon.ImageRectOffset,
						ImageRectSize = BoxIcon.ImageRectSize,
						ImageTransparency = 0.5,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(24, 24),
						Parent = Button,
					})
				end

				local ButtonLabel
				if false then --// Icon-only subtab mode
					ButtonLabel = New("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(0, 16),
						Text = Name,
						TextSize = 15,
						TextTransparency = 0.5,
						Parent = ButtonContent,
					})
				end

				local Line = Library:MakeLine(Button, {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, 1),
					Size = UDim2.new(1, 0, 0, 1),
				})
				local ActiveLine = Library:MakeLine(Button, {
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.fromScale(0.5, 1),
					Size = UDim2.new(0.5, 0, 0, 2),
				})
				ActiveLine.Visible = false

				local Container = New("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(0, 35),
					Size = UDim2.new(1, 0, 1, -35),
					Visible = false,
					Parent = TabboxHolder,
				})
				local List = New("UIListLayout", {
					Padding = UDim.new(0, 8),
					Parent = Container,
				})
				New("UIPadding", {
					PaddingBottom = UDim.new(0, 7),
					PaddingLeft = UDim.new(0, 7),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 7),
					Parent = Container,
				})

				local Tab = {
					Connections = {},
					Destroyed = false,

					ButtonHolder = Button,
					Container = Container,
					ButtonCorner = ButtonCorner,
					ActiveLine = ActiveLine,

					Tab = Tab,
					Elements = {},
					DependencyBoxes = {},
				}

				function Tab:Show()
					if Tabbox.ActiveTab then
						Tabbox.ActiveTab:Hide()
					end

					Button.BackgroundTransparency = 1

					if ActiveLine then
						ActiveLine.Visible = true
					end
					if ButtonIcon then
						ButtonIcon.ImageTransparency = 0
					end

					Line.Visible = false

					Container.Visible = true

					Tabbox.ActiveTab = Tab
					Tab:Resize()
				end

				function Tab:Hide()
					Button.BackgroundTransparency = 0

					if ActiveLine then
						ActiveLine.Visible = false
					end
					if ButtonIcon then
						ButtonIcon.ImageTransparency = 0.5
					end
					Line.Visible = true
					Container.Visible = false

					Tabbox.ActiveTab = nil
				end

				function Tab:Resize()
					if Tabbox.ActiveTab ~= Tab then
						return
					end

					TabboxHolder.Size = UDim2.new(1, 0, 0, (List.AbsoluteContentSize.Y / Library.DPIScale) + 49)
					if ParentObj.Type == "Groupbox" then
						ParentObj:Resize()
					end
				end

				function Tab:UpdateCorners()
					local Radius = WindowInfo.CornerRadius

					ButtonCorner.TopLeftRadius = UDim.new(0, TabIndex == FirstTab and Radius or 0)
					ButtonCorner.TopRightRadius = UDim.new(0, TabIndex == LastTab and Radius or 0)
				end

				function Tab:Destroy()
					Tab.Destroyed = true

					if Tab.Connections then
						for _, Connection in Tab.Connections do
							Connection:Disconnect()
						end
					end

					for _, Element in Tab.Elements do
						if Element.Destroy then
							Element:Destroy()
						end
					end

					for _, SubDepbox in Tab.DependencyBoxes do
						if SubDepbox.Destroy then
							SubDepbox:Destroy()
						end
					end

					if Container then
						Container:Destroy()
					end

					if Button then
						Button:Destroy()
					end
				end

				--// Execution \\--
				if not Tabbox.ActiveTab then
					Tab:Show()
				end

				Button.MouseButton1Click:Connect(Tab.Show)

				setmetatable(Tab, BaseGroupbox)

				Tabbox.Tabs[TabStoringIndex] = Tab
				Tabbox:UpdateCorners()

				return Tab, TabStoringIndex
			end

			function Tabbox:Destroy()
				Tabbox.Destroyed = true

				if Tabbox.Connections then
					for _, Connection in Tabbox.Connections do
						Connection:Disconnect()
					end
				end

				for _, Tab in Tabbox.Tabs do
					if Tab.Destroy then
						Tab:Destroy()
					end
				end

				if TabboxHolder then
					TabboxHolder:Destroy()
				end

				if BoxHolder then
					BoxHolder:Destroy()
				end
			end

			if Info.Name then
				Tab.Tabboxes[Info.Name] = Tabbox
			else
				table.insert(Tab.Tabboxes, Tabbox)
			end

			return Tabbox
		end

		Tab.AddTabbox = AddTabbox

		function Tab:AddLeftTabbox(Name)
			return Tab:AddTabbox({ Side = 1, Name = Name })
		end

		function Tab:AddRightTabbox(Name)
			return Tab:AddTabbox({ Side = 2, Name = Name })
		end

		function Tab:AddGroupbox(Info)
			local BoxHolder = New("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				Parent = Info.Side == 1 and TabLeft or TabRight,
			})
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				Parent = BoxHolder,
			})
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 4),
				PaddingTop = UDim.new(0, 4),
				Parent = BoxHolder,
			})

			local GroupboxHolder
			local GroupboxLabel

			local GroupboxContainer
			local GroupboxList

			local GroupboxCollapseArrow
			local GroupboxLine

			do
				local Nested = Library:IsInsideSurfaceCard(BoxHolder)
				GroupboxHolder = New("Frame", {
					BackgroundColor3 = function()
						return Library:GetGroupSurfaceColor()
					end,
					BackgroundTransparency = Nested and 1 or ClampTransparency(Library.Surface.GroupTransparency),
					ClipsDescendants = true,
					Size = UDim2.fromScale(1, 0),
					Parent = BoxHolder,
				})
				if not Nested then
					Library.SurfaceGroups[GroupboxHolder] = true
				end
				table.insert(
					Library.Corners,
					New("UICorner", {
						CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
						Parent = GroupboxHolder,
					})
				)
				Library:AddOutline(GroupboxHolder)

				GroupboxLine = Library:MakeLine(GroupboxHolder, {
					Position = UDim2.fromOffset(0, 34),
					Size = UDim2.new(1, 0, 0, 1),
				})

				local BoxIcon = Library:GetCustomIcon(Info.IconName)
				if BoxIcon then
					local BoxIconLabel = New("ImageLabel", {
						Image = BoxIcon.Url,
						ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
						ImageRectOffset = BoxIcon.ImageRectOffset,
						ImageRectSize = BoxIcon.ImageRectSize,
						Position = UDim2.fromOffset(6, 6),
						Size = UDim2.fromOffset(22, 22),
						Parent = GroupboxHolder,
					})
					local Anim = {
						Scale = New("UIScale", { Scale = 1, Parent = BoxIconLabel }),
						Rot = BoxIconLabel,
						Tweens = {},
					}
					table.insert(Library.IconAnimRegistry, Anim)
					GroupboxHolder.MouseEnter:Connect(function()
						if Library.IconAnim.Enabled ~= false then
							Library:PlayIconAnim(Anim, true)
						end
					end)
					GroupboxHolder.MouseLeave:Connect(function()
						Library:PlayIconAnim(Anim, false)
					end)
				end

				GroupboxLabel = New("TextLabel", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(BoxIcon and 24 or 0, 0),
					Size = UDim2.new(1, 0, 0, 34),
					Text = Info.Name,
					TextSize = 15,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = GroupboxHolder,
				})
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
					Parent = GroupboxLabel,
				})

				if Info.DisableCollapsing ~= true then
					GroupboxCollapseArrow = New("ImageButton", {
						Image = ArrowIcon and ArrowIcon.Url or "",
						ImageColor3 = "WhiteColor",
						ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
						ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
						BackgroundTransparency = 1,
						Rotation = 180,
						Position = UDim2.new(1, -(22 + 6), 0, 6),
						Size = UDim2.fromOffset(22, 22),
						Parent = GroupboxHolder,
					})
				end

				GroupboxContainer = New("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(0, 35),
					Size = UDim2.new(1, 0, 1, -35),
					Parent = GroupboxHolder,
				})

				GroupboxList = New("UIListLayout", {
					Padding = UDim.new(0, 8),
					Parent = GroupboxContainer,
				})
				New("UIPadding", {
					PaddingBottom = UDim.new(0, 7),
					PaddingLeft = UDim.new(0, 7),
					PaddingRight = UDim.new(0, 7),
					PaddingTop = UDim.new(0, 7),
					Parent = GroupboxContainer,
				})
			end

			local Groupbox = {
				Type = "Groupbox",

				Connections = {},
				Destroyed = false,

				Visible = true,
				Collapsed = false,

				BoxHolder = BoxHolder,
				Holder = GroupboxHolder,
				Container = GroupboxContainer,

				Tab = Tab,
				DependencyBoxes = {},
				Elements = {},
			}

			local ResizeTween
			local CollapseArrowTween

			function Groupbox:Resize()
				if ResizeTween then
					StopTween(ResizeTween, true)
					ResizeTween = nil
				end

				local TargetSize = UDim2.new(
					1,
					0,
					0,
					if Groupbox.Collapsed then 34 else (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 49
				)

				GroupboxLine.Visible = not Groupbox.Collapsed
				if Library.Animations and Library.Animations.Groupbox then
					local TweenInfo = Library.GroupboxTweenInfo
						or TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					local Tween = TweenService:Create(GroupboxHolder, TweenInfo, { Size = TargetSize })
					ResizeTween = Tween

					local Connection
					Connection = Library:GiveSignal(Tween.Completed:Once(function()
						if Connection then
							Connection:Disconnect()
						end

						if ResizeTween == Tween then
							StopTween(ResizeTween, true)
							ResizeTween = nil
						end
					end))

					Tween:Play()
				else
					GroupboxHolder.Size = TargetSize
				end
			end

			function Groupbox:SetCollapsed(Collapsed: boolean)
				if Info.DisableCollapsing == true then
					return
				end
				Groupbox.Collapsed = Collapsed

				if CollapseArrowTween then
					StopTween(CollapseArrowTween, true)
					CollapseArrowTween = nil
				end

				local TargetRotation = if Collapsed then 0 else 180

				GroupboxContainer.Visible = not Collapsed
				if Library.Animations and Library.Animations.Groupbox then
					local TweenInfo = Library.GroupboxTweenInfo
						or TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
					local Tween = TweenService:Create(GroupboxCollapseArrow, TweenInfo, { Rotation = TargetRotation })
					CollapseArrowTween = Tween

					local Connection
					Connection = Library:GiveSignal(Tween.Completed:Connect(function()
						if Connection then
							Connection:Disconnect()
						end

						if CollapseArrowTween == Tween then
							StopTween(CollapseArrowTween, true)
							CollapseArrowTween = nil
						end
					end))

					Tween:Play()
				else
					GroupboxCollapseArrow.Rotation = TargetRotation
				end

				Groupbox:Resize()
			end

			function Groupbox:ToggleCollapsed()
				if Info.DisableCollapsing == true then
					return
				end
				Groupbox:SetCollapsed(not Groupbox.Collapsed)
			end

			function Groupbox:Destroy()
				Groupbox.Destroyed = true

				if ResizeTween then
					StopTween(ResizeTween, true)
					ResizeTween = nil
				end

				if CollapseArrowTween then
					StopTween(CollapseArrowTween, true)
					CollapseArrowTween = nil
				end

				if Groupbox.Connections then
					for _, Connection in Groupbox.Connections do
						Connection:Disconnect()
					end
				end

				for _, Element in Groupbox.Elements do
					if Element.Destroy then
						Element:Destroy()
					end
				end
				table.clear(Groupbox.Elements)

				for _, SubDepbox in Groupbox.DependencyBoxes do
					if SubDepbox.Destroy then
						SubDepbox:Destroy()
					end
				end
				table.clear(Groupbox.DependencyBoxes)

				if GroupboxHolder then
					GroupboxHolder:Destroy()
				end

				if BoxHolder then
					BoxHolder:Destroy()
				end
			end

			function Groupbox:SetVisible(Visible: boolean)
				Groupbox.Visible = Visible
				BoxHolder.Visible = Visible

				if Visible == true and Library.Searching then
					Library:UpdateSearch(Library.SearchText)
				end
			end

			function Groupbox:Show()
				Groupbox:SetVisible(true)
			end

			function Groupbox:Hide()
				Groupbox:SetVisible(false)
			end

			if Info.DisableCollapsing ~= true then
				GroupboxCollapseArrow.MouseButton1Click:Connect(function()
					Groupbox:ToggleCollapsed()
				end)
			end

			Groupbox.AddTabbox = AddTabbox
			setmetatable(Groupbox, BaseGroupbox)

			Groupbox:Resize()
			Tab.Groupboxes[Info.Name] = Groupbox

			if Info.Visible == false then
				Groupbox:Hide()
			end

			if Info.DisableCollapsing ~= true and Info.Collapsed == true then
				Groupbox:SetCollapsed(true)
			end

			return Groupbox
		end

		function Tab:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
			return Tab:AddGroupbox({
				Side = 1,
				Name = Name,
				IconName = IconName,
				Visible = Visible,
				Collapsed = Collapsed,
				DisableCollapsing = DisableCollapsing,
			})
		end

		function Tab:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
			return Tab:AddGroupbox({
				Side = 2,
				Name = Name,
				IconName = IconName,
				Visible = Visible,
				Collapsed = Collapsed,
				DisableCollapsing = DisableCollapsing,
			})
		end

		function Tab:Hover(Hovering)
			if Library.ActiveTab == Tab then
				return
			end

			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = Hovering and 0.25 or 0.5,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = Hovering and 0.25 or 0.5,
				}):Play()
			end
			Library:TweenTabZoom(TabIconScale, Hovering and Library.TabAppearance.HoverZoom or 1)
		end

		function Tab:Show()
			if Library.ActiveTab == Tab then
				return
			end

			if Library.ActiveTab then
				Library.ActiveTab:Hide()
			end

			TabButton.BackgroundColor3 = Library.TabAppearance.ActiveBackgroundColor
			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = Library.TabAppearance.ActiveBackgroundTransparency,
			}):Play()
			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0,
				}):Play()
			end
			Library:TweenTabZoom(TabIconScale, Library.TabAppearance.ActiveZoom)

			if Description then
				Window:ShowTabInfo(Name, Description)
			end

			Library:PlayTabAnimation(TabCanvas, true)
			Tab:RefreshSides()

			Library.ActiveTab = Tab

			if Library.Searching then
				Library:UpdateSearch(Library.SearchText)
			end
		end

		function Tab:Hide()
			TabButton.BackgroundColor3 = Library.Scheme.MainColor
			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = Library.TabAppearance.TabBackgroundTransparency,
			}):Play()

			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0.5,
			}):Play()

			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0.5,
				}):Play()
			end
			Library:TweenTabZoom(TabIconScale, 1)

			Library:PlayTabAnimation(TabCanvas, false)
			Window:HideTabInfo()

			Library.ActiveTab = nil
		end

		function Tab:SetVisible(Visible: boolean)
			TabButton.Visible = Visible

			if not Visible and Library.ActiveTab == Tab then
				Tab:Hide()
			end
		end

		function Tab:Destroy()
			Tab.Destroyed = true

			if Tab.Connections then
				for _, Connection in Tab.Connections do
					Connection:Disconnect()
				end
			end

			for _, Groupbox in Tab.Groupboxes do
				if Groupbox.Destroy then
					Groupbox:Destroy()
				end
			end
			table.clear(Tab.Groupboxes)

			for _, Tabbox in Tab.Tabboxes do
				if Tabbox.Destroy then
					Tabbox:Destroy()
				end
			end
			table.clear(Tab.Tabboxes)

			for _, DepGroupbox in Tab.DependencyGroupboxes do
				if DepGroupbox.Destroy then
					DepGroupbox:Destroy()
				end
			end

			if TabCanvas then
				TabCanvas:Destroy()
			elseif TabContainer then
				TabContainer:Destroy()
			end

			if TabButton then
				for Index, Entry in Library.TabButtons do
					if typeof(Entry) == "table" and Entry.Button == TabButton then
						table.remove(Library.TabButtons, Index)
						break
					end
				end

				TabButton:Destroy()
			end

			Library.Tabs[Name] = nil
		end

		--// Execution \\--
		if not Library.ActiveTab then
			Tab:Show()
		end

		TabButton.MouseEnter:Connect(function()
			Tab:Hover(true)
		end)
		TabButton.MouseLeave:Connect(function()
			Tab:Hover(false)
		end)
		TabButton.MouseButton1Click:Connect(function()
			Library:PlayClickSound() -- <-- GANTI JADI INI
			Tab:Show()
		end)

		TabRec.Tab = Tab
		Library.Tabs[Name] = Tab

		return Tab
	end

	function Window:AddKeyTab(...)
		local Name = nil
		local Icon = nil
		local Description = nil

		if select("#", ...) == 1 and typeof(...) == "table" then
			local Info = select(1, ...)
			Name = Info.Name or "Tab"
			Icon = Info.Icon
			Description = Info.Description
		else
			Name = select(1, ...) or "Tab"
			Icon = select(2, ...)
			Description = select(3, ...)
		end

		Icon = Icon or "key"

		local TabButton: TextButton
		local TabLabel
		local TabIcon
		local TabIconCard
		local TabIconScale
		local TabRec

		local TabCanvas
		local TabContainer

		Icon = if Icon == "key" then KeyIcon else Library:GetCustomIcon(Icon)
		do
			TabButton = New("TextButton", {
				BackgroundColor3 = "MainColor",
				BackgroundTransparency = Library.TabAppearance.TabBackgroundTransparency,
				Size = UDim2.new(1, 0, 0, 44),
				Text = "",
				Parent = Tabs,
			})
			local ButtonPadding = New("UIPadding", {
				PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
				PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
				PaddingRight = UDim.new(0, IsCompact and 6 or 12),
				PaddingTop = UDim.new(0, IsCompact and 6 or 11),
				Parent = TabButton,
			})

			TabLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -30, 1, 0),
				Text = Name,
				TextSize = 16,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false,
				Parent = TabButton,
			})

			if Icon then
				TabIcon = New("ImageLabel", {
					Image = Icon.Url,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
					ImageRectOffset = Icon.ImageRectOffset,
					ImageRectSize = Icon.ImageRectSize,
					ImageTransparency = 0.5,
					Size = UDim2.fromOffset(24, 24),
					Parent = TabButton,
				})
				TabIconCard, TabIconScale = Library:CreateTabIconCard(TabIcon)
			end

			table.insert(Library.TabButtons, {
				Label = TabLabel,
				Padding = ButtonPadding,
				Icon = TabIcon,
			})

			TabRec = { Button = TabButton, Icon = TabIcon, Card = TabIconCard, Scale = TabIconScale }
			table.insert(Library.TabVisuals, TabRec)

			--// Tab Canvas \\--
			TabCanvas = New("CanvasGroup", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				GroupTransparency = 0,
				Size = UDim2.fromScale(1, 1),
				Visible = false,
				Parent = Container,
			})

			--// Tab Container \\--
			TabContainer = New("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarThickness = 0,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 1),
				Visible = true,
				Parent = TabCanvas,
			})
			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Parent = TabContainer,
			})
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 1),
				PaddingRight = UDim.new(0, 1),
				Parent = TabContainer,
			})
		end

		--// Tab Table \\--
		local Tab = {
			Description = Description,
			IsKeyTab = true,

			Elements = {},

			Window = Window,
			Canvas = TabCanvas,
		}

		function Tab:AddKeyBox(Callback)
			assert(typeof(Callback) == "function", "Callback must be a function")

			local Holder = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.75, 0, 0, 21),
				Parent = TabContainer,
			})

			local Box = New("TextBox", {
				BackgroundColor3 = "MainColor",
				PlaceholderText = "Key",
				Size = UDim2.new(1, -71, 1, 0),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Holder,
			})
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				Parent = Box,
			})
			New("UIStroke", {
				Color = "OutlineColor",
				Parent = Box,
			})
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius / 2),
					Parent = Box,
				})
			)

			local Button = New("TextButton", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = "MainColor",
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.new(0, 63, 1, 0),
				Text = "Execute",
				TextSize = 14,
				Parent = Holder,
			})
			New("UIStroke", {
				Color = "OutlineColor",
				Parent = Button,
			})
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius / 2),
					Parent = Button,
				})
			)

			Button.InputBegan:Connect(function(Input)
				if not IsClickInput(Input) then
					return
				end

				if not Library:MouseIsOverFrame(Button, Input.Position) then
					return
				end

				Callback(Box.Text)
			end)
		end

		function Tab:Destroy()
			if TabCanvas then
				TabCanvas:Destroy()
			elseif TabContainer then
				TabContainer:Destroy()
			end

			if TabButton then
				for Index, Entry in Library.TabButtons do
					if typeof(Entry) == "table" and Entry.Button == TabButton then
						table.remove(Library.TabButtons, Index)
						break
					end
				end

				TabButton:Destroy()
			end

			Library.Tabs[Name] = nil
		end

		function Tab:RefreshSides() end
		function Tab:Resize() end
		function Tab:UpdateCorners() end

		function Tab:Hover(Hovering)
			if Library.ActiveTab == Tab then
				return
			end

			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = Hovering and 0.25 or 0.5,
			}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = Hovering and 0.25 or 0.5,
				}):Play()
			end
			Library:TweenTabZoom(TabIconScale, Hovering and Library.TabAppearance.HoverZoom or 1)
		end

		function Tab:Show()
			if Library.ActiveTab == Tab then
				return
			end

			if Library.ActiveTab then
				Library.ActiveTab:Hide()
			end

			TabButton.BackgroundColor3 = Library.TabAppearance.ActiveBackgroundColor
			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = Library.TabAppearance.ActiveBackgroundTransparency,
			}):Play()

			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0,
			}):Play()

			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0,
				}):Play()
			end
			Library:TweenTabZoom(TabIconScale, Library.TabAppearance.ActiveZoom)

			Library:PlayTabAnimation(TabCanvas, true)

			if Description then
				Window:ShowTabInfo(Name, Description)
			end

			Tab:RefreshSides()

			Library.ActiveTab = Tab

			if Library.Searching then
				Library:UpdateSearch(Library.SearchText)
			end
		end

		function Tab:Hide()
			TabButton.BackgroundColor3 = Library.Scheme.MainColor
			TweenService:Create(TabButton, Library.TweenInfo, {
				BackgroundTransparency = Library.TabAppearance.TabBackgroundTransparency,
			}):Play()

			TweenService:Create(TabLabel, Library.TweenInfo, {
				TextTransparency = 0.5,
			}):Play()

			if TabIcon then
				TweenService:Create(TabIcon, Library.TweenInfo, {
					ImageTransparency = 0.5,
				}):Play()
			end
			Library:TweenTabZoom(TabIconScale, 1)

			Library:PlayTabAnimation(TabCanvas, false)
			Window:HideTabInfo()

			Library.ActiveTab = nil
		end

		function Tab:SetVisible(Visible: boolean)
			TabButton.Visible = Visible

			if not Visible and Library.ActiveTab == Tab then
				Tab:Hide()
			end
		end

		--// Execution \\--
		if not Library.ActiveTab then
			Tab:Show()
		end

		TabButton.MouseEnter:Connect(function()
			Tab:Hover(true)
		end)
		TabButton.MouseLeave:Connect(function()
			Tab:Hover(false)
		end)
		TabButton.MouseButton1Click:Connect(Tab.Show)

		Tab.Container = TabContainer
		setmetatable(Tab, BaseGroupbox)

		TabRec.Tab = Tab
		Library.Tabs[Name] = Tab

		return Tab
	end

	function Window:AddDialog(Idx, Info)
		Info = Library:Validate(Info, Templates.Dialog)

		local DialogFrame
		local DialogOverlay
		local DialogContainer
		local ButtonsHolder
		local FooterButtonsList = {}

		DialogOverlay = New("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = "DarkColor",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			Active = false,
			ZIndex = 9000,
			Visible = true,
			Parent = MainFrame,
		})
		TweenService:Create(DialogOverlay, Library.TweenInfo, {
			BackgroundTransparency = 0.5,
		}):Play()

		DialogFrame = New("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = "BackgroundColor",
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(300, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 9001,
			Parent = DialogOverlay,
		})
		table.insert(
			Library.Corners,
			New("UICorner", {
				CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
				Parent = DialogFrame,
			})
		)
		Library:AddOutline(DialogFrame)

		local InnerContainer = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 9002,
			Parent = DialogFrame,
		})
		local DialogScale = New("UIScale", {
			Scale = 0.95,
			Parent = DialogFrame,
		})
		TweenService:Create(DialogScale, Library.TweenInfo, {
			Scale = 1,
		}):Play()
		local _InnerPadding = New("UIPadding", {
			PaddingBottom = UDim.new(0, 15),
			PaddingLeft = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 15),
			PaddingTop = UDim.new(0, 15),
			Parent = InnerContainer,
		})
		local _InnerLayout = New("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = InnerContainer,
		})

		local HeaderContainer = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			ZIndex = 9002,
			Parent = InnerContainer,
		})
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = HeaderContainer,
		})
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 5),
			Parent = HeaderContainer,
		})

		local TitleRow = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			ZIndex = 9002,
			Parent = HeaderContainer,
		})
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = TitleRow,
		})

		local DialogIconWidth = 0
		if Info.Icon then
			local ParsedIcon = Library:GetCustomIcon(Info.Icon)
			if ParsedIcon then
				DialogIconWidth = 24
				New("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(18, 18),
					Image = ParsedIcon.Url,
					ImageColor3 = Info.IconColor or "AccentColor",
					ImageRectOffset = ParsedIcon.ImageRectOffset,
					ImageRectSize = ParsedIcon.ImageRectSize,
					LayoutOrder = 2,
					ZIndex = 9002,
					Parent = TitleRow,
				})
			end
		end

		local TitleLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -DialogIconWidth, 0, 18),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = Info.Title,
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			ZIndex = 9002,
			Parent = TitleRow,
		})
		if Info.TitleColor then
			TitleLabel.TextColor3 = Info.TitleColor
		end

		local DescriptionLabel = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = Info.Description,
			TextSize = 14,
			TextTransparency = Info.DescriptionColor and 0 or 0.2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			LayoutOrder = 2,
			ZIndex = 9002,
			Parent = HeaderContainer,
		})
		if Info.DescriptionColor then
			DescriptionLabel.TextColor3 = Info.DescriptionColor
		end

		DialogContainer = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 4,
			ZIndex = 9002,
			Parent = InnerContainer,
		})
		local _DialogContainerLayout = New("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = DialogContainer,
		})
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 5),
			Parent = DialogContainer,
		})

		local _Sep2 = New("Frame", {
			BackgroundColor3 = "OutlineColor",
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = 5,
			ZIndex = 9002,
			Parent = InnerContainer,
		})

		ButtonsHolder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 6,
			ZIndex = 9002,
			Parent = InnerContainer,
		})
		New("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Wraps = true,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ButtonsHolder,
		})
		New("UIPadding", {
			PaddingTop = UDim.new(0, 5),
			Parent = ButtonsHolder,
		})

		local Dialog = {
			Destroyed = false,
			Elements = {},
			Container = DialogContainer,
		}

		function Dialog:Resize()
			local MaxWidth = MainFrame.AbsoluteSize.X * 0.75
			local MinWidth = 400

			local TotalButtonWidth = 0
			local ButtonCount = 0
			local HasButtons = false

			for _, BtnWrap in FooterButtonsList do
				HasButtons = true
				ButtonCount = ButtonCount + 1
				TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
			end

			local TargetWidth = MinWidth
			if HasButtons then
				local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
				TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
			end

			DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)

			local _DescX, DescY =
				Library:GetTextBounds(DescriptionLabel.Text, Library.Scheme.Font, 14, TargetWidth - 30)
			DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

			local HasElements = false
			for _, v in DialogContainer:GetChildren() do
				if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
					HasElements = true
					break
				end
			end
			DialogContainer.Visible = HasElements

			ButtonsHolder.Visible = HasButtons
			_Sep2.Visible = HasButtons
		end

		function Dialog:SetTitle(Title)
			TitleLabel.Text = Title
			Dialog:Resize()
		end

		function Dialog:SetDescription(Description)
			DescriptionLabel.Text = Description
			Dialog:Resize()
		end

		function Dialog:Dismiss()
			if Dialog.Destroyed then
				return
			end

			Dialog.Destroyed = true

			if Library.ActiveDialog == Dialog then
				Library.ActiveDialog = nil
			end

			for Index = #Dialog.Elements, 1, -1 do
				local Element = Dialog.Elements[Index]
				if Element and Element.Destroy then
					Element:Destroy()
				end
			end
			table.clear(Dialog.Elements)

			local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
			TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
			CloseTween:Play()

			task.delay(Library.TweenInfo.Time, function()
				DialogOverlay:Destroy()
			end)
			Library.Dialogues[Idx] = nil
		end

		DialogOverlay.MouseButton1Click:Connect(function()
			if Info.OutsideClickDismiss then
				Dialog:Dismiss()
			end
		end)

		function Dialog:RemoveFooterButton(ButtonIdx)
			if FooterButtonsList[ButtonIdx] then
				FooterButtonsList[ButtonIdx].Container:Destroy()
				FooterButtonsList[ButtonIdx] = nil
				Dialog:Resize()
			end
		end

		function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
			if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
				FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
			end
		end

		function Dialog:SetButtonOrder(ButtonIdx, Order)
			if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
				FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
			end
		end

		function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
			Dialog:RemoveFooterButton(ButtonIdx)

			local WaitTime = ButtonInfo.WaitTime or 0

			local ButtonContainer = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 26),
				LayoutOrder = ButtonInfo.Order or 0,
				ZIndex = 9002,
				Parent = ButtonsHolder,
			})

			local BtnColor = "MainColor"
			local BtnOutline = "OutlineColor"
			local Variant = ButtonInfo.Variant or "Primary"

			if Variant == "Primary" then
				BtnColor = "FontColor"
				BtnOutline = "FontColor"
			elseif Variant == "Secondary" then
				BtnColor = "MainColor"
				BtnOutline = "OutlineColor"
			elseif Variant == "Destructive" then
				BtnColor = "DestructiveColor"
				BtnOutline = "DestructiveColor"
			elseif Variant == "Ghost" then
				BtnColor = "BackgroundColor"
				BtnOutline = "BackgroundColor"
			end

			local TextBtn = New("TextButton", {
				BackgroundColor3 = BtnColor,
				BorderColor3 = BtnOutline,
				BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
				Size = UDim2.fromOffset(0, 26),
				Text = "",
				AutoButtonColor = false,
				ZIndex = 9002,
				Parent = ButtonContainer,
			})
			Library:AddOutline(TextBtn)
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius),
					Parent = TextBtn,
				})
			)

			local _BtnPadding = New("UIPadding", {
				PaddingLeft = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 15),
				Parent = TextBtn,
			})

			local TextColor = Variant == "Primary" and "BackgroundColor" or "FontColor"

			local BtnLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = ButtonInfo.Title or ButtonIdx,
				TextColor3 = TextColor,
				TextTransparency = WaitTime > 0 and 0.5 or 0,
				TextSize = 14,
				ZIndex = 9002,
				Parent = TextBtn,
			})

			local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
			ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
			TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

			local ProgressBar
			if WaitTime > 0 then
				ProgressBar = New("Frame", {
					BackgroundColor3 = "AccentColor",
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 1, -2),
					Size = UDim2.new(0, 0, 0, 2),
					ZIndex = 2,
					Parent = TextBtn,
				})
				table.insert(
					Library.Corners,
					New("UICorner", {
						CornerRadius = UDim.new(0, Library.CornerRadius),
						Parent = ProgressBar,
					})
				)
			end

			local IsActive = WaitTime <= 0

			local ButtonWrap = {
				Container = ButtonContainer,
				SetDisabled = function(self, Disabled)
					IsActive = not Disabled
					if Disabled then
						TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
						TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 }):Play()
					else
						TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
						TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 }):Play()
					end
				end,
			}

			local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
			local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor
				or Library:GetBetterColor(ActiveColor, 10)

			TextBtn.MouseEnter:Connect(function()
				if not IsActive then
					return
				end
				TweenService:Create(TextBtn, Library.TweenInfo, {
					BackgroundColor3 = HoverColor,
				}):Play()
			end)
			TextBtn.MouseLeave:Connect(function()
				if not IsActive then
					return
				end
				TweenService:Create(TextBtn, Library.TweenInfo, {
					BackgroundColor3 = ActiveColor,
				}):Play()
			end)

			TextBtn.MouseButton1Click:Connect(function()
				if not IsActive then
					return
				end
				if ButtonInfo.Callback then
					ButtonInfo.Callback(Dialog)
				end
				if Info.AutoDismiss then
					Dialog:Dismiss()
				end
			end)

			if WaitTime > 0 then
				TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
					Size = UDim2.new(1, 0, 0, 2),
				}):Play()

				task.delay(WaitTime, function()
					ButtonWrap:SetDisabled(false)
					if ProgressBar then
						TweenService:Create(ProgressBar, Library.TweenInfo, {
							BackgroundTransparency = 1,
						}):Play()
					end
				end)
			end

			FooterButtonsList[ButtonIdx] = ButtonWrap

			Dialog:Resize()
		end

		for BIdx, BInfo in Info.FooterButtons do
			if type(BIdx) == "number" and BInfo.Id then
				BIdx = BInfo.Id
			end
			Dialog:AddFooterButton(BIdx, BInfo)
		end

		setmetatable(Dialog, BaseGroupbox)
		Library.Dialogues[Idx] = Dialog

		Dialog:Resize()

		Library.ActiveDialog = Dialog
		return Dialog
	end

	function Window:Toggle(Value: boolean?)
		if Library.ActiveLoading then
			if Value == true then
				return
			end
		end

		if typeof(Value) == "boolean" then
			Library.Toggled = Value
		else
			Library.Toggled = not Library.Toggled
		end

		if not Library.Toggled then
			for _, Option in Library.Options do
				if Option.Type == "DropdownV2" and Option.PopupOpen then
					Option:ClosePopup(true)
				end
			end
		end

		if Library.Animations and Library.Animations.ToggleWindow == true then
			local FadeTime = Library.WindowAnimationInfo.Time
			local Reverse = Fading
			local CanCapture = not Reverse
			Fading = true
			FadeToken += 1
			local Token = FadeToken
			local Opening = Library.Toggled

			if Opening then
				MainFrame.Visible = true
			end

			Library:FadeTree(MainFrame, Opening, CanCapture, TopBar)

			task.delay(FadeTime, function()
				if Token ~= FadeToken then
					return
				end
				MainFrame.Visible = Library.Toggled
				Fading = false
			end)
		else
			MainFrame.Visible = Library.Toggled
		end


		if WindowInfo.UnlockMouseWhileOpen then
			ModalElement.Modal = Library.Toggled
		end

		if Library.Toggled and not Library.IsMobile then
			local OldMouseIconEnabled = UserInputService.MouseIconEnabled
			local ShowCursorBinding = Library.ShowCursorBinding
			pcall(function()
				RunService:UnbindFromRenderStep(ShowCursorBinding)
			end)
			RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Last.Value, function()
				UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

				Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
				Cursor.Visible = Library.ShowCustomCursor

				if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
					UserInputService.MouseIconEnabled = OldMouseIconEnabled
					Cursor.Visible = false
					RunService:UnbindFromRenderStep(ShowCursorBinding)
				end
			end)
		elseif not Library.Toggled then
			TooltipLabel.Visible = false

			for _, Option in Library.Options do
				if Option.Type == "ColorPicker" then
					Option.ColorMenu:Close()
					Option.ContextMenu:Close()
				elseif Option.Type == "Dropdown" or Option.Type == "KeyPicker" then
					Option.Menu:Close()
				end
			end
		end
	end

	function Library:Toggle(Value: boolean?)
		return Window:Toggle(Value)
	end

	do
		local ToggleBtnTexture = "rbxassetid://117688744510818"
		local ToggleBtnSize = 46
		local ToggleBtnIconSize = 45
		local ToggleBtnFrame = New("ImageButton", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = "BackgroundColor",
			Position = UDim2.new(0.5, 0, 0, 15),
			Size = UDim2.fromOffset(ToggleBtnSize, ToggleBtnSize),
			AutoButtonColor = false,
			ZIndex = 10,
			Parent = ScreenGui,
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, 10),
			Parent = ToggleBtnFrame,
		})
		local ToggleBtnOutline = New("UIStroke", {
			Color = Library.Toggled and "AccentColor" or "OutlineColor",
			Thickness = 1,
			ZIndex = 2,
			Parent = ToggleBtnFrame,
		})
		New("UIStroke", {
			Color = "DarkColor",
			Thickness = 1.5,
			ZIndex = 1,
			Parent = ToggleBtnFrame,
		})
		local ToggleBtnIcon = New("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = ToggleBtnTexture,
			ImageColor3 = Color3.new(1, 1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(ToggleBtnIconSize, ToggleBtnIconSize),
			ZIndex = 10,
			Parent = ToggleBtnFrame,
		})

		local ToggleBtnAnimInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local ToggleBtnFadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local function UpdateToggleButton(SkipAnim)
			local IsOpen = Library.Toggled
			Library.Registry[ToggleBtnOutline].Color = IsOpen and "AccentColor" or "OutlineColor"
			local TargetOutlineColor = GetSchemeValue(IsOpen and "AccentColor" or "OutlineColor")
			if SkipAnim then
				ToggleBtnOutline.Color = TargetOutlineColor
				ToggleBtnOutline.Thickness = IsOpen and 1.5 or 1
			else
				TweenService:Create(ToggleBtnOutline, ToggleBtnFadeInfo, {
					Color = TargetOutlineColor,
					Thickness = IsOpen and 1.5 or 1,
				}):Play()
				ToggleBtnIcon.Rotation = -90
				ToggleBtnIcon.Size = UDim2.fromOffset(0, 0)
				TweenService:Create(ToggleBtnIcon, ToggleBtnAnimInfo, {
					Rotation = 0,
					Size = UDim2.fromOffset(ToggleBtnIconSize, ToggleBtnIconSize),
				}):Play()
			end
		end

		ToggleBtnFrame.MouseButton1Click:Connect(function()
			Library:Toggle()
		end)
		Library:MakeDraggable(ToggleBtnFrame, ToggleBtnFrame, true)

		-- Hide floating button while loading is active
		Library.FloatingToggle = ToggleBtnFrame
		ToggleBtnFrame.Visible = not Library.ActiveLoading

		-- Sync toggle state animation with window toggle
		local OrigToggle = Library.Toggle
		function Library:Toggle(Value)
			OrigToggle(Library, Value)
			UpdateToggleButton(false)
			if Library.FloatingToggle then
				Library.FloatingToggle.Visible = not Library.ActiveLoading
			end
		end

		UpdateToggleButton(true)
	end

	if WindowInfo.EnableSidebarResize then
		local Threshold = (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth)
			* WindowInfo.SidebarCollapseThreshold
		local StartPos, StartWidth
		local Dragging = false
		local Changed

		local SidebarGrabber = New("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(0, 8, 1, 0),
			Text = "",
			Parent = DividerLine,
		})
		SidebarGrabber.MouseEnter:Connect(function()
			TweenService:Create(DividerLine, Library.TweenInfo, {
				BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
			}):Play()
		end)
		SidebarGrabber.MouseLeave:Connect(function()
			if Dragging then
				return
			end
			TweenService:Create(DividerLine, Library.TweenInfo, {
				BackgroundColor3 = Library.Scheme.OutlineColor,
			}):Play()
		end)

		SidebarGrabber.InputBegan:Connect(function(Input: InputObject)
			if not IsClickInput(Input) then
				return
			end

			Library.CantDragForced = true

			StartPos = Input.Position
			StartWidth = Window:GetSidebarWidth()
			Dragging = true

			Changed = Input.Changed:Connect(function()
				if Input.UserInputState ~= Enum.UserInputState.End then
					return
				end

				Library.CantDragForced = false
				TweenService:Create(DividerLine, Library.TweenInfo, {
					BackgroundColor3 = Library.Scheme.OutlineColor,
				}):Play()

				Dragging = false
				if Changed and Changed.Connected then
					Changed:Disconnect()
					Changed = nil
				end
			end)
		end)

		Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
			if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
				Dragging = false
				if Changed and Changed.Connected then
					Changed:Disconnect()
					Changed = nil
				end

				return
			end

			if Dragging and IsHoverInput(Input) then
				local Delta = Input.Position - StartPos
				local Width = StartWidth + Delta.X

				if WindowInfo.DisableCompactingSnap then
					Window:SetSidebarWidth(Width)
					return
				end

				if Width > Threshold then
					Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
				else
					Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
				end
			end
		end))
	end
	if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then
		Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
	end
	if WindowInfo.AutoShow and not Library.ActiveLoading then
		task.spawn(Library.Toggle)
	end

	if Library.IsMobile then
		local ToggleButton = Library:AddDraggableButton("Toggle", function()
			Library:Toggle()
		end, true, true)

		local LockButton = Library:AddDraggableButton("Lock", function(self)
			Library.CantDragForced = not Library.CantDragForced
			self:SetText(Library.CantDragForced and "Unlock" or "Lock")
		end, true, true)

		if WindowInfo.MobileButtonsSide == "Right" then
			ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)
			ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)

			LockButton.Button.AnchorPoint = Vector2.new(1, 0)
			LockButton.Button.Position = UDim2.new(1, -(ToggleButton.Button.Size.X.Offset + 12), 0, 6)
		else
			ToggleButton.Button.AnchorPoint = Vector2.new(0, 0)
			ToggleButton.Button.Position = UDim2.fromOffset(6, 6)

			LockButton.Button.AnchorPoint = Vector2.new(0, 0)
			LockButton.Button.Position = UDim2.fromOffset(ToggleButton.Button.Size.X.Offset + 12, 6)
		end
		ToggleButton.Button.Visible = false
		LockButton.Button.Visible = false
	end

	if WindowInfo.ShowMobileButtons == false then
		ToggleButton.Button.Visible = false
		LockButton.Button.Visible = false
	end
	Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
		if Library.Unloaded then
			return
		end

		if UserInputService:GetFocusedTextBox() then
			return
		end

		if Input.KeyCode == Library.ToggleKeybind then
			Library:Toggle()
		end
	end))

	Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
		Library.IsRobloxFocused = true
	end))
	Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
		Library.IsRobloxFocused = false
	end))

	Library:ApplyTabAppearance()
	print(string.format("[N3V4 Library] window ready: tabVisuals=%d (0 padahal ada tab = dump DEBUG di setingan)", #Library.TabVisuals))

	Library.Window = Window
	return Window
end

--// SECONDARY COMPANION WINDOW: N3 LIVE DASHBOARD (IDENTIK DENGAN WINDOW UTAMA)
function Library:CreateDashboard(Info)
	Info = Info or {}
	local TitleText = Info.Title or "N3 Dashboard"
	local WIN_W = Info.Width or 260
	local TOP_H = 32
	local GAP = 2
	local PAD = 8
	local ZOFF = 100

	local WinFrame = New("Frame", {
		Name = "Dashboard",
		BackgroundColor3 = function()
			return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
		end,
		Position = Info.Position or UDim2.new(0, 25, 0, 120),
		Size = UDim2.fromOffset(WIN_W, 200),
		Active = true,
		ClipsDescendants = true,
		ZIndex = ZOFF,
		Parent = Library.ScreenGui or Library.LocalPlayer:WaitForChild("PlayerGui"),
	})
	table.insert(Library.Corners, New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius),
		Parent = WinFrame,
	}))
	New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1.2,
		Parent = WinFrame,
	})
	Library:AddOutlineSpin(WinFrame)

	local TopBar = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, TOP_H),
		ZIndex = ZOFF + 1,
		Parent = WinFrame,
	})
	New("ImageLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 4),
		Size = UDim2.fromOffset(24, 24),
		Image = "rbxassetid://117688744510818",
		ZIndex = ZOFF + 1,
		Parent = TopBar,
	})
	local TopTitle = New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(38, 0),
		Size = UDim2.new(1, -104, 1, 0),
		Text = TitleText,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.fromRGB(240, 240, 245),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = ZOFF + 1,
		Parent = TopBar,
	})
	New("Frame", {
		BackgroundColor3 = "OutlineColor",
		BackgroundTransparency = 0.55,
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = ZOFF + 1,
		Parent = TopBar,
	})
	local MinBtn = New("TextButton", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -30, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		Text = "-",
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.fromRGB(180, 180, 190),
		ZIndex = ZOFF + 1,
		Parent = TopBar,
	})
	local CloseBtn = New("TextButton", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		Text = "x",
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.fromRGB(180, 180, 190),
		ZIndex = ZOFF + 1,
		Parent = TopBar,
	})
	for _, Btn in ipairs({ MinBtn, CloseBtn }) do
		Btn.MouseEnter:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextColor3 = Library.Scheme.AccentColor }):Play()
		end)
		Btn.MouseLeave:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextColor3 = Color3.fromRGB(180, 180, 190) }):Play()
		end)
	end

	do
		local Dragging, DragInput, DragStart, StartPos
		TopBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPos = WinFrame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		TopBar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				local delta = input.Position - DragStart
				WinFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
			end
		end)
	end

	local Container = New("ScrollingFrame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, TOP_H),
		Size = UDim2.new(1, 0, 1, -TOP_H),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = "OutlineColor",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ZIndex = ZOFF + 1,
		Parent = WinFrame,
	})
	local List = New("UIListLayout", {
		Padding = UDim.new(0, GAP),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Container,
	})
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		Parent = Container,
	})
	List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Container.CanvasSize = UDim2.fromOffset(0, List.AbsoluteContentSize.Y + 16)
	end)

	local Dashboard = {
		Frame = WinFrame,
		Container = Container,
		Type = "Dashboard",
		Cards = {},
	}
	local Order = 0
	local FullSize = UDim2.fromOffset(WIN_W, 200)
	local IsMinimized = false

	local function Resize(Animate)
		local Total = 0
		local Count = 0
		for _, CardData in pairs(Dashboard.Cards) do
			Count += 1
			Total += CardData.Height
			if CardData.Open then
				Total += CardData.ExpHeight + GAP
			end
		end
		Total += math.max(0, Count - 1) * GAP + PAD * 2 + TOP_H
		FullSize = UDim2.fromOffset(WIN_W, math.max(TOP_H + 16, Total))
		if not IsMinimized then
			if Animate then
				TweenService:Create(WinFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = FullSize }):Play()
			else
				WinFrame.Size = FullSize
			end
		end
	end

	local function BuildRow(Height, TextH)
		Order += 1
		local RowOrder = Order * 2
		local Row = New("TextButton", {
			BackgroundColor3 = "BackgroundColor",
			BackgroundTransparency = 1,
			LayoutOrder = RowOrder,
			Size = UDim2.new(1, 0, 0, Height),
			Transparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = ZOFF + 1,
			Parent = Container,
		})
		table.insert(Library.Corners, New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Row,
		}))
		local Icon = New("ImageLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(8, (TextH - 14) / 2),
			Size = UDim2.fromOffset(14, 14),
			ImageColor3 = "AccentColor",
			ZIndex = ZOFF + 2,
			Parent = Row,
		})
		local Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(28, 0),
			Size = UDim2.new(1, -36, 0, TextH),
			Text = "",
			TextSize = Library.DashboardStyle.TextSize,
			Font = Enum.Font.Gotham,
			TextColor3 = function()
				local St = Library.DashboardStyle
				if St.CustomLabelColor then
					return St.LabelColor
				end
				return Library.Scheme.AccentColor
			end,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = ZOFF + 2,
			Parent = Row,
		})
		local ValueLbl = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -8, 0, TextH),
			Text = "0",
			TextSize = Library.DashboardStyle.TextSize,
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = ZOFF + 2,
			Parent = Row,
		})
		local Sep = New("Frame", {
			BackgroundColor3 = "OutlineColor",
			BackgroundTransparency = Library.DashboardStyle.DividerTransparency,
			Position = UDim2.new(0, 8, 1, -1),
			Size = UDim2.new(1, -16, 0, 1),
			ZIndex = ZOFF + 1,
			Parent = Row,
		})
		TweenService:Create(Row, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, Order * 0.03), { Transparency = 0 }):Play()
		Row.MouseEnter:Connect(function()
			TweenService:Create(Row, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = Library.DashboardStyle.HoverTransparency }):Play()
		end)
		Row.MouseLeave:Connect(function()
			TweenService:Create(Row, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
		end)
		return Row, Icon, Label, ValueLbl, Sep, RowOrder
	end

	local function FillExp(CardData)
		local Host = CardData.ExpInner
		if not Host then
			return
		end
		for _, Kid in ipairs(Host:GetChildren()) do
			if Kid:IsA("Frame") then
				Kid:Destroy()
			end
		end
		local Rows = CardData.Details or {}
		for i, RowData in ipairs(Rows) do
			local Line = New("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = i,
				Size = UDim2.new(1, 0, 0, 16),
				ZIndex = ZOFF + 2,
				Parent = Host,
			})
			New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(28, 0),
				Size = UDim2.new(0.55, -28, 1, 0),
				Text = tostring(RowData.Label),
				TextSize = 11,
				Font = Enum.Font.Gotham,
				TextColor3 = "AccentColor",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = ZOFF + 2,
				Parent = Line,
			})
			New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -8, 1, 0),
				Text = tostring(RowData.Value),
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = ZOFF + 2,
				Parent = Line,
			})
		end
		CardData.ExpHeight = 4 + #Rows * 17
	end

	local function BuildExp(CardData)
		local Exp = New("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = CardData.RowOrder + 1,
			Size = UDim2.new(1, 0, 0, 0),
			ZIndex = ZOFF + 1,
			Parent = Container,
		})
		local Inner = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 1000),
			ZIndex = ZOFF + 1,
			Parent = Exp,
		})
		New("UIListLayout", {
			Padding = UDim.new(0, 1),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Inner,
		})
		CardData.ExpInner = Inner
		CardData.Exp = Exp
		FillExp(CardData)
		return Exp
	end

	local function Toggle(CardData)
		if not CardData.Details or #CardData.Details == 0 then
			return
		end
		CardData.Open = not CardData.Open
		if CardData.Open and not CardData.Exp then
			BuildExp(CardData)
		end
		if CardData.Exp then
			local Target = UDim2.new(1, 0, 0, 0)
			if CardData.Open then
				Target = UDim2.new(1, 0, 0, CardData.ExpHeight)
			else
				local Gone = CardData.Exp
				task.delay(0.2, function()
					if Gone.Parent and not CardData.Open then
						Gone:Destroy()
						if CardData.Exp == Gone then
							CardData.Exp = nil
							CardData.ExpInner = nil
						end
					end
				end)
			end
			TweenService:Create(CardData.Exp, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = Target }):Play()
		end
		Resize(true)
	end

	function Dashboard:AddStat(Idx, Conf)
		Conf = Conf or {}
		local Style = Library.DashboardStyle
		local Row, Icon, Label, ValueLbl, Sep, RowOrder = BuildRow(Style.StatHeight, Style.StatHeight)
		Label.Text = Conf.Title or tostring(Idx)
		local IconData = Library:GetCustomIcon(Conf.Icon or "gauge")
		if IconData then
			Icon.Image = IconData.Url
			Icon.ImageRectOffset = IconData.ImageRectOffset
			Icon.ImageRectSize = IconData.ImageRectSize
		end
		local Suffix = Conf.Suffix or ""
		local Dec = Conf.Decimals or 0
		local Holder = Instance.new("NumberValue")
		Holder.Value = Conf.Default or 0
		local function Paint()
			ValueLbl.Text = string.format("%." .. Dec .. "f", Holder.Value) .. Suffix
		end
		Paint()
		Holder:GetPropertyChangedSignal("Value"):Connect(Paint)
		local CardData = { Kind = "Stat", Holder = Holder, Height = Style.StatHeight, RowOrder = RowOrder, Details = Conf.Details, Open = false, ExpHeight = 0, Row = Row, Icon = Icon, Label = Label, ValueLbl = ValueLbl, Sep = Sep }
		Dashboard.Cards[Idx] = CardData
		Row.MouseButton1Click:Connect(function()
			Toggle(CardData)
		end)
		Resize()
	end

	function Dashboard:SetStat(Idx, Value)
		local CardData = Dashboard.Cards[Idx]
		if not CardData or typeof(Value) ~= "number" then
			return
		end
		TweenService:Create(CardData.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Value = Value }):Play()
	end

	function Dashboard:AddMeter(Idx, Conf)
		Conf = Conf or {}
		local Style = Library.DashboardStyle
		local Row, Icon, Label, ValueLbl, Sep, RowOrder = BuildRow(Style.MeterHeight, math.min(24, Style.MeterHeight - 10))
		Label.Text = Conf.Title or tostring(Idx)
		local IconData = Library:GetCustomIcon(Conf.Icon or "gauge")
		if IconData then
			Icon.Image = IconData.Url
			Icon.ImageRectOffset = IconData.ImageRectOffset
			Icon.ImageRectSize = IconData.ImageRectSize
		end
		local Track = New("Frame", {
			BackgroundColor3 = "MainColor",
			BackgroundTransparency = 0.2,
			Position = UDim2.fromOffset(28, Style.MeterHeight - 8),
			Size = UDim2.new(1, -36, 0, 4),
			ZIndex = ZOFF + 2,
			Parent = Row,
		})
		table.insert(Library.Corners, New("UICorner", {
			CornerRadius = UDim.new(0, 2),
			Parent = Track,
		}))
		local Fill = New("Frame", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(0, 0, 1, 0),
			ZIndex = ZOFF + 3,
			Parent = Track,
		})
		table.insert(Library.Corners, New("UICorner", {
			CornerRadius = UDim.new(0, 2),
			Parent = Fill,
		}))
		local FillGrad = New("UIGradient", {
			Parent = Fill,
		})
		if Visuals and type(Visuals.AttachGradient) == "function" then
			Visuals.AttachGradient(FillGrad, function()
				local G = Library.CardGradient
				local Seq = nil
				if G.Preset == "Custom" then
					Seq = ColorSequence.new({
						ColorSequenceKeypoint.new(0, G.ColorTop),
						ColorSequenceKeypoint.new(0.5, G.ColorMiddle),
						ColorSequenceKeypoint.new(1, G.ColorBottom),
					})
				else
					Seq = Visuals.Presets.Sequence[G.Preset]
				end
				return {
					Enabled = true,
					Sequence = Seq or Visuals.Presets.Sequence.Gold,
					Rotation = 0,
					OffsetSpeed = G.OffsetSpeed,
					RotationSpeed = 0,
				}
			end)
		end
		local Min = Conf.Min or 0
		local Max = Conf.Max or 100
		local Suffix = Conf.Suffix or "%"
		local Holder = Instance.new("NumberValue")
		Holder.Value = Conf.Default or Min
		local function Paint()
			local T = math.clamp((Holder.Value - Min) / (Max - Min), 0, 1)
			Fill.Size = UDim2.new(T, 0, 1, 0)
			ValueLbl.Text = string.format("%.0f", Holder.Value) .. Suffix
		end
		Paint()
		Holder:GetPropertyChangedSignal("Value"):Connect(Paint)
		local CardData = { Kind = "Meter", Holder = Holder, Height = Style.MeterHeight, RowOrder = RowOrder, Details = Conf.Details, Open = false, ExpHeight = 0, Row = Row, Icon = Icon, Label = Label, ValueLbl = ValueLbl, Sep = Sep, Track = Track }
		Dashboard.Cards[Idx] = CardData
		Row.MouseButton1Click:Connect(function()
			Toggle(CardData)
		end)
		Resize()
	end

	function Dashboard:SetMeter(Idx, Value)
		local CardData = Dashboard.Cards[Idx]
		if not CardData or typeof(Value) ~= "number" then
			return
		end
		TweenService:Create(CardData.Holder, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Value = Value }):Play()
	end

	function Dashboard:SetDetails(Idx, Rows)
		local CardData = Dashboard.Cards[Idx]
		if not CardData or type(Rows) ~= "table" then
			return
		end
		CardData.Details = Rows
		if CardData.Exp then
			FillExp(CardData)
			if CardData.Open then
				TweenService:Create(CardData.Exp, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, CardData.ExpHeight) }):Play()
				Resize(true)
			end
		end
	end

	function Dashboard:Restyle()
		local S = Library.DashboardStyle
		for _, CardData in pairs(Dashboard.Cards) do
			local IsMeter = CardData.Kind == "Meter"
			CardData.Height = IsMeter and S.MeterHeight or S.StatHeight
			local TextH = IsMeter and math.min(24, S.MeterHeight - 10) or S.StatHeight
			CardData.Row.Size = UDim2.new(1, 0, 0, CardData.Height)
			CardData.Icon.Position = UDim2.fromOffset(8, (TextH - 14) / 2)
			CardData.Label.Size = UDim2.new(1, -36, 0, TextH)
			CardData.Label.TextSize = S.TextSize
			CardData.ValueLbl.Size = UDim2.new(1, -8, 0, TextH)
			CardData.ValueLbl.TextSize = S.TextSize
			CardData.Sep.BackgroundTransparency = S.DividerTransparency
			if CardData.Track then
				CardData.Track.Position = UDim2.fromOffset(28, S.MeterHeight - 8)
			end
		end
		Resize()
	end

	table.insert(Library.Dashboards, Dashboard)

	function Dashboard:SetTitle(Text)
		if typeof(Text) == "string" then
			TitleText = Text
			TopTitle.Text = Text
		end
	end

	function Dashboard:Destroy()
		for i = #Library.Dashboards, 1, -1 do
			if Library.Dashboards[i] == Dashboard then
				table.remove(Library.Dashboards, i)
			end
		end
		WinFrame:Destroy()
		for i = #Library.OutlineSpinObjects, 1, -1 do
			if not Library.OutlineSpinObjects[i].Grad.Parent then
				table.remove(Library.OutlineSpinObjects, i)
			end
		end
	end

	MinBtn.MouseButton1Click:Connect(function()
		IsMinimized = not IsMinimized
		if IsMinimized then
			TweenService:Create(WinFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(WIN_W, TOP_H) }):Play()
			MinBtn.Text = "+"
		else
			TweenService:Create(WinFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = FullSize }):Play()
			MinBtn.Text = "-"
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		Dashboard:Destroy()
	end)

	Resize()
	return Dashboard
end

Library.PanelStyle = {
	RowHeight = 72,
	TileSize = 48,
	GlowTransparency = 0.5,
	PlateTransparency = 0,
	RowTransparency = 0.3,
	OverlayTransparency = 0.38,
	ChipHeight = 25,
	TabPillHeight = 25,
	Wallpaper = false,
	GlowRing = true,
	BoldText = true,
	TitleSize = 18,
	InfoSize = 12,
	MetallicHeader = true,
	AnimateText = true,
}

Library.PanelRarity = {
	Common = Color3.fromRGB(205, 205, 210),
	Rare = Color3.fromRGB(120, 160, 255),
	Mythic = Color3.fromRGB(255, 70, 70),
	Money = Color3.fromRGB(70, 190, 100),
}
Library.Panels = {}

function Library:SetPanelStyle(Info)
	Info = Info or {}
	local S = Library.PanelStyle
	local function Num(Key, Lo, Hi)
		if typeof(Info[Key]) == "number" then
			S[Key] = math.clamp(Info[Key], Lo, Hi)
		end
	end
	Num("RowHeight", 48, 72)
	Num("TileSize", 24, 48)
	Num("GlowTransparency", 0, 1)
	Num("PlateTransparency", 0, 1)
	Num("RowTransparency", 0, 1)
	Num("OverlayTransparency", 0, 1)
	Num("ChipHeight", 16, 28)
	Num("TabPillHeight", 20, 32)
	Num("TitleSize", 12, 20)
	Num("InfoSize", 10, 16)
	if Info.BoldText ~= nil then
		S.BoldText = Info.BoldText == true
	end
	if Info.Wallpaper ~= nil then
		S.Wallpaper = Info.Wallpaper == true
	end
	if Info.GlowRing ~= nil then
		S.GlowRing = Info.GlowRing == true
	end
	if Info.MetallicHeader ~= nil then
		S.MetallicHeader = Info.MetallicHeader == true
	end
	if Info.AnimateText ~= nil then
		S.AnimateText = Info.AnimateText == true
	end
	Library:ApplyPanelStyle()
end

function Library:ApplyPanelStyle()
	for _, P in ipairs(Library.Panels) do
		if not P.Destroyed and type(P.Restyle) == "function" then
			P:Restyle()
		end
	end
end

function Library:CreatePanel(Info)
	Info = Info or {}
	local TitleText = Info.Title or "Panel"
	local Width = math.clamp(Info.Width or 280, 200, 420)
	local Height = math.clamp(Info.Height or 380, 240, 720)
	local TOP_H = 32
	local TAB_H = 34
	local CHIP_H = 26
	local ZOFF = 60

	local function AddLight(Obj)
		New("UIGradient", {
			Rotation = -90,
			Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(115, 115, 135)),
			Parent = Obj,
		})
	end

	local Panel = {
		Title = TitleText,
		Tabs = {},
		Chips = {},
		ActiveTab = nil,
		Visible = true,
		Destroyed = false,
		Type = "Panel",
	}

	local Wrapper = New("Frame", {
		Name = "PanelWrapper",
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = Info.Position or UDim2.new(1, -24, 0.5, 0),
		Size = UDim2.fromOffset(Width + 20, Height),
		ZIndex = ZOFF,
		Parent = Library.ScreenGui or Library.LocalPlayer:WaitForChild("PlayerGui"),
	})

	local Handle = New("TextButton", {
		Name = "PanelHandle",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = function()
			return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
		end,
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(14, 56),
		Text = "",
		ZIndex = ZOFF + 1,
		Parent = Wrapper,
	})
	New("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = Handle,
	})
	New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1.2,
		Parent = Handle,
	})
	Library:AddOutlineSpin(Handle)
	local HandleIcon = Library:GetCustomIcon("list")
	local HandleImage = New("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Image = HandleIcon and HandleIcon.Url or "",
		ImageRectOffset = HandleIcon and HandleIcon.ImageRectOffset or nil,
		ImageRectSize = HandleIcon and HandleIcon.ImageRectSize or nil,
		ImageColor3 = HandleIcon and HandleIcon.Custom and "WhiteColor" or "FontColor",
		ImageTransparency = 0.35,
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(10, 10),
		ZIndex = ZOFF + 2,
		Parent = Handle,
	})
	Handle.MouseEnter:Connect(function()
		HandleImage.ImageTransparency = 0
	end)
	Handle.MouseLeave:Connect(function()
		HandleImage.ImageTransparency = 0.35
	end)
	Handle.MouseButton1Click:Connect(function()
		Panel:Toggle()
	end)

	local WinFrame = New("Frame", {
		Name = "Panel",
		BackgroundColor3 = function()
			return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
		end,
		Position = UDim2.fromOffset(18, 0),
		Size = UDim2.new(1, -18, 1, 0),
		Active = true,
		ClipsDescendants = true,
		ZIndex = ZOFF + 1,
		Parent = Wrapper,
	})
	table.insert(Library.Corners, New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius),
		Parent = WinFrame,
	}))
	New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1.2,
		Parent = WinFrame,
	})
	Library:AddOutlineSpin(WinFrame)

	local Wallpaper = New("ImageLabel", {
		Name = "PanelWallpaper",
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		Image = function()
			local Bg = Library.Scheme.BackgroundImage
			if typeof(Bg) == "number" then
				return string.format("rbxassetid://%d", Bg)
			end
			if typeof(Bg) == "string" and Bg ~= "" then
				return Bg
			end
			return "rbxassetid://111593326989465"
		end,
		ScaleType = Enum.ScaleType.Stretch,
		ImageColor3 = Color3.fromRGB(148, 148, 148),
		ZIndex = ZOFF + 1,
		Parent = WinFrame,
	})
	table.insert(Library.Corners, New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius),
		Parent = Wallpaper,
	}))

	local PanelOverlay = New("Frame", {
		Name = "PanelOverlay",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = Library.PanelStyle.OverlayTransparency,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = ZOFF + 1,
		Parent = WinFrame,
	})
	table.insert(Library.Corners, New("UICorner", {
		CornerRadius = UDim.new(0, Library.CornerRadius),
		Parent = PanelOverlay,
	}))

	local TopBar = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, TOP_H),
		ZIndex = ZOFF + 2,
		Parent = WinFrame,
	})
	local TopPlate = New("Frame", {
		Name = "MetallicBar",
		BackgroundColor3 = Color3.fromRGB(240, 240, 245),
		Size = UDim2.new(1, 0, 1, 0),
		Visible = Library.PanelStyle.MetallicHeader,
		ZIndex = ZOFF + 2,
		Parent = TopBar,
	})
	local Shine = New("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 110, 118)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(250, 250, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 110, 118)),
		}),
		Offset = Vector2.new(-0.6, 0),
		Parent = TopPlate,
	})
	local ShineTween = TweenService:Create(Shine, TweenInfo.new(2.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
		Offset = Vector2.new(0.6, 0),
	})
	ShineTween:Play()
	New("ImageLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 4),
		Size = UDim2.fromOffset(24, 24),
		Image = "rbxassetid://117688744510818",
		ZIndex = ZOFF + 2,
		Parent = TopBar,
	})
	local TopTitle = New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(38, 0),
		Size = UDim2.new(1, -46, 1, 0),
		Text = TitleText,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextColor3 = Library.PanelStyle.MetallicHeader and Color3.fromRGB(20, 20, 20) or Library.Scheme.FontColor,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = ZOFF + 2,
		Parent = TopBar,
	})
	New("Frame", {
		BackgroundColor3 = "OutlineColor",
		BackgroundTransparency = 0.55,
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = ZOFF + 2,
		Parent = TopBar,
	})
	local HdrBtn = New("TextButton", {
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = "AccentColor",
		Position = UDim2.new(1, -34, 0.5, 0),
		Size = UDim2.fromOffset(60, 22),
		Text = "",
		Visible = false,
		ZIndex = ZOFF + 2,
		Parent = TopBar,
	})
	table.insert(Library.Corners, New("UICorner", {
		CornerRadius = UDim.new(0, math.floor(Library.CornerRadius / 2)),
		Parent = HdrBtn,
	}))
	New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1,
		Parent = HdrBtn,
	})
	AddLight(HdrBtn)
	local HdrText = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextColor3 = "FontColor",
		ZIndex = ZOFF + 3,
		Parent = HdrBtn,
	})
	local HdrCallback = nil
	HdrBtn.MouseEnter:Connect(function()
		HdrBtn.BackgroundTransparency = 0.12
	end)
	HdrBtn.MouseLeave:Connect(function()
		HdrBtn.BackgroundTransparency = 0
	end)
	HdrBtn.MouseButton1Down:Connect(function()
		HdrBtn.BackgroundTransparency = 0.25
	end)
	HdrBtn.MouseButton1Up:Connect(function()
		HdrBtn.BackgroundTransparency = 0.12
	end)
	HdrBtn.MouseButton1Click:Connect(function()
		if HdrCallback then
			Library:SafeCallback(HdrCallback)
		end
	end)

	function Panel:SetHeaderButton(Text, Callback)
		HdrCallback = Callback
		if not Text then
			HdrBtn.Visible = false
			TopTitle.Size = UDim2.new(1, -46, 1, 0)
			return
		end
		HdrText.Text = Text
		HdrBtn.Size = UDim2.fromOffset(math.clamp(TextService:GetTextSize(Text, 11, Enum.Font.GothamBold, Vector2.new(10000, 10000)).X + 20, 60, 150), 22)
		HdrBtn.Visible = true
		TopTitle.Size = UDim2.new(1, -(HdrBtn.Size.X.Offset + 46), 1, 0)
	end
	if Info.HeaderButton then
		Panel:SetHeaderButton(Info.HeaderButton.Text, Info.HeaderButton.Callback)
	end

	local CloseBtn = New("TextButton", {
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = Library.PanelStyle.PlateTransparency,
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		Text = "",
		ZIndex = ZOFF + 2,
		Parent = TopBar,
	})
	local ClosePlate = CloseBtn
	table.insert(Library.Corners, New("UICorner", {
		CornerRadius = UDim.new(0, math.floor(Library.CornerRadius / 2)),
		Parent = CloseBtn,
	}))
	New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1,
		Parent = CloseBtn,
	})
	local XIcon = Library:GetIcon("x")
	New("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Image = XIcon and XIcon.Url or "",
		ImageRectOffset = XIcon and XIcon.ImageRectOffset or Vector2.zero,
		ImageRectSize = XIcon and XIcon.ImageRectSize or Vector2.zero,
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(12, 12),
		ImageColor3 = Color3.fromRGB(180, 180, 190),
		ZIndex = ZOFF + 3,
		Parent = CloseBtn,
	})
	CloseBtn.MouseEnter:Connect(function()
		CloseBtn.BackgroundTransparency = math.max(0, Library.PanelStyle.PlateTransparency - 0.12)
	end)
	CloseBtn.MouseLeave:Connect(function()
		CloseBtn.BackgroundTransparency = Library.PanelStyle.PlateTransparency
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		Panel:SetVisible(false)
	end)

	local ChipBar = New("ScrollingFrame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, TOP_H),
		Size = UDim2.new(1, 0, 0, CHIP_H),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.new(),
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = "OutlineColor",
		ScrollBarImageTransparency = 0.6,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = ZOFF + 2,
		Parent = WinFrame,
	})
	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = ChipBar,
	})
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 3),
		Parent = ChipBar,
	})

	local TabScroll = New("ScrollingFrame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, TOP_H),
		Size = UDim2.new(1, 0, 0, TAB_H),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.new(),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = "OutlineColor",
		ScrollBarImageTransparency = 0.6,
		ZIndex = ZOFF + 2,
		Parent = WinFrame,
	})
	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = TabScroll,
	})
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 5),
		Parent = TabScroll,
	})
	local TabDivider = New("Frame", {
		BackgroundColor3 = "OutlineColor",
		BackgroundTransparency = 0.55,
		Position = UDim2.new(0, 0, 0, TOP_H + TAB_H - 1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = ZOFF + 2,
		Parent = WinFrame,
	})

	local Body = New("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.new(0, 0, 0, TOP_H + TAB_H),
		Size = UDim2.new(1, 0, 1, -(TOP_H + TAB_H)),
		ZIndex = ZOFF + 2,
		Parent = WinFrame,
	})

	local function Relayout()
		local Off = ChipBar.Visible and (Library.PanelStyle.ChipHeight + 6) or 0
		TabScroll.Position = UDim2.new(0, 0, 0, TOP_H + Off)
		TabDivider.Position = UDim2.new(0, 0, 0, TOP_H + Off + TAB_H - 1)
		Body.Position = UDim2.new(0, 0, 0, TOP_H + Off + TAB_H)
		Body.Size = UDim2.new(1, 0, 1, -(TOP_H + Off + TAB_H))
	end
	Relayout()

	function Panel:AddChip(LabelText, ChipInfo)
		ChipInfo = ChipInfo or {}
		local State = ChipInfo.Default == true
		local Chip = { Label = LabelText, State = State }
		local S = Library.PanelStyle
		local function LabelWidth()
			return TextService:GetTextSize(LabelText, S.InfoSize, S.BoldText and Enum.Font.GothamBold or Enum.Font.Code, Vector2.new(10000, 10000)).X
		end
		local function BoxSize()
			return math.clamp(S.ChipHeight - 7, 12, 24)
		end
		Chip.Button = New("TextButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(LabelWidth() + BoxSize() + 8, S.ChipHeight),
			Text = "",
			ZIndex = ZOFF + 3,
			Parent = ChipBar,
		})
		Chip.Text = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -BoxSize() - 8, 1, 0),
			Text = LabelText,
			TextSize = S.InfoSize,
			Font = S.BoldText and Enum.Font.GothamBold or Enum.Font.Code,
			TextColor3 = "FontColor",
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = ZOFF + 4,
			Parent = Chip.Button,
		})
		local ChipBox = New("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = "MainColor",
			BackgroundTransparency = S.PlateTransparency,
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(BoxSize(), BoxSize()),
			ZIndex = ZOFF + 4,
			Parent = Chip.Button,
		})
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
			Parent = ChipBox,
		})
		New("UIStroke", {
			Color = "OutlineColor",
			Thickness = 1,
			Parent = ChipBox,
		})
		local ChipCheck = Library:GetIcon("check")
		local CheckIcon = New("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = ChipCheck and ChipCheck.Url or "",
			ImageRectOffset = ChipCheck and ChipCheck.ImageRectOffset or Vector2.zero,
			ImageRectSize = ChipCheck and ChipCheck.ImageRectSize or Vector2.zero,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(BoxSize() - 8, BoxSize() - 8),
			ImageColor3 = Color3.fromRGB(86, 197, 110),
			ZIndex = ZOFF + 5,
			Parent = ChipBox,
		})
		local function Paint()
			Chip.State = State
			CheckIcon.Visible = State
		end
		local function RelayoutChip()
			Chip.Button.Size = UDim2.fromOffset(LabelWidth() + BoxSize() + 8, S.ChipHeight)
			Chip.Text.Size = UDim2.new(1, -BoxSize() - 8, 1, 0)
			Chip.Text.TextSize = S.InfoSize
			Chip.Text.Font = S.BoldText and Enum.Font.GothamBold or Enum.Font.Code
			ChipBox.Size = UDim2.fromOffset(BoxSize(), BoxSize())
			ChipBox.BackgroundTransparency = S.PlateTransparency
			CheckIcon.Size = UDim2.fromOffset(BoxSize() - 8, BoxSize() - 8)
		end
		Paint()
		Chip.Repaint = Paint
		Chip.Relayout = RelayoutChip
		Chip.Button.MouseButton1Click:Connect(function()
			State = not State
			Paint()
			if ChipInfo.Callback then
				Library:SafeCallback(ChipInfo.Callback, State)
			end
		end)
		function Chip:SetState(Value)
			State = Value == true
			Paint()
		end
		ChipBar.Visible = true
		Relayout()
		table.insert(Panel.Chips, Chip)
		return Chip
	end

	function Panel:SetTab(Target)
		for _, Tab in ipairs(Panel.Tabs) do
			local Active = Tab == Target
			Tab.Scroll.Visible = Active
			Tab.Button.BackgroundTransparency = Active and 0 or 1
			Tab.Label.TextTransparency = Active and 0 or 0.5
			if Tab.Icon then
				Tab.Icon.ImageTransparency = Active and 0 or 0.5
			end
		end
		Panel.ActiveTab = Target
	end

	function Panel:AddTab(Name, IconName)
		local Tab = { Name = Name, Items = {} }
		local Icon = Library:GetCustomIcon(IconName)
		local Measured = TextService:GetTextSize(Name, 12, Enum.Font.Code, Vector2.new(10000, 10000))
		Tab.Button = New("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = "MainColor",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(Measured.X + (Icon and 36 or 18), Library.PanelStyle.TabPillHeight),
			Text = "",
			Parent = TabScroll,
		})
		table.insert(Library.Corners, New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Tab.Button,
		}))
		AddLight(Tab.Button)
		if Icon then
			Tab.Icon = New("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 9, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				Image = Icon.Url,
				ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
				ImageRectOffset = Icon.ImageRectOffset,
				ImageRectSize = Icon.ImageRectSize,
				ImageTransparency = 0.5,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = ZOFF + 3,
				Parent = Tab.Button,
			})
		end
		Tab.Label = New("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(Icon and 27 or 9, 0),
			Size = UDim2.new(1, Icon and -36 or -18, 1, 0),
			Text = Name,
			TextSize = 12,
			Font = Enum.Font.Code,
			TextColor3 = "FontColor",
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextTransparency = 0.5,
			ZIndex = ZOFF + 3,
			Parent = Tab.Button,
		})
		Tab.Button.MouseEnter:Connect(function()
			if Panel.ActiveTab ~= Tab then
				Tab.Button.BackgroundTransparency = 0.6
			end
		end)
		Tab.Button.MouseLeave:Connect(function()
			Tab.Button.BackgroundTransparency = Panel.ActiveTab == Tab and 0 or 1
		end)
		Tab.Button.MouseButton1Click:Connect(function()
			Panel:SetTab(Tab)
		end)
		Tab.Scroll = New("ScrollingFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(),
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = "OutlineColor",
			ScrollBarImageTransparency = 0.4,
			Visible = false,
			ZIndex = ZOFF + 2,
			Parent = Body,
		})
		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Tab.Scroll,
		})
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
			Parent = Tab.Scroll,
		})

		function Tab:AddItem(ItemInfo)
			ItemInfo = ItemInfo or {}
			local Row = New("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 56),
				ZIndex = ZOFF + 3,
				Parent = Tab.Scroll,
			})
			table.insert(Library.Corners, New("UICorner", {
				CornerRadius = UDim.new(0, Library.CornerRadius),
				Parent = Row,
			}))
			New("UIStroke", {
				Color = "OutlineColor",
				Thickness = 1,
				Transparency = 0.25,
				Parent = Row,
			})
			local Glow = ItemInfo.GlowColor or "AccentColor"
			local NameColor = ItemInfo.TextColor or nil
			local SubColor = ItemInfo.SubtextColor or Color3.fromRGB(86, 197, 110)
			local TileIcon = ItemInfo.Image and nil or Library:GetCustomIcon(ItemInfo.Icon)
			local HasTile = ItemInfo.Image ~= nil or TileIcon ~= nil
			local Tile = New("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Glow,
				BackgroundTransparency = 0.55,
				Position = UDim2.new(0, 7, 0.5, 0),
				Size = UDim2.fromOffset(32, 32),
				Image = ItemInfo.Image or (TileIcon and TileIcon.Url or ""),
				ImageRectOffset = TileIcon and TileIcon.ImageRectOffset or nil,
				ImageRectSize = TileIcon and TileIcon.ImageRectSize or nil,
				ImageColor3 = "WhiteColor",
				ScaleType = ItemInfo.Image and Enum.ScaleType.Stretch or Enum.ScaleType.Fit,
				Visible = HasTile,
				ZIndex = ZOFF + 4,
				Parent = Row,
			})
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
				Parent = Tile,
			})
			New("UIGradient", {
				Rotation = -90,
				Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(75, 75, 95)),
				Parent = Tile,
			})
			local Ring = New("UIStroke", {
				Color = Glow,
				Thickness = 1,
				Transparency = 0.35,
				Parent = Tile,
			})
			local TextX = HasTile and (14 + Library.PanelStyle.TileSize) or 8
			local IconW = ItemInfo.IconButton and (math.clamp(Library.PanelStyle.RowHeight - 30, 20, 30) + 5) or 0
			local Act, IB, RecAct, RecIB
			local BtnW = 0
			if ItemInfo.ButtonText then
				BtnW = math.clamp(TextService:GetTextSize(ItemInfo.ButtonText, 12, Enum.Font.Code, Vector2.new(10000, 10000)).X + 20, 44, 90)
			end
			local TitleLab = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(TextX, 5),
				Size = UDim2.new(1, -TextX - BtnW - IconW - 14, 0, 16),
				Text = ItemInfo.Text or "",
				TextSize = Library.PanelStyle.TitleSize,
				TextColor3 = NameColor or "FontColor",
				Font = Library.PanelStyle.BoldText and Enum.Font.GothamBold or Enum.Font.Code,
				TextColor3 = "FontColor",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = ZOFF + 4,
				Parent = Row,
			})
			local SubLab = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(TextX, 21),
				Size = UDim2.new(1, -TextX - BtnW - IconW - 14, 0, 13),
				Text = ItemInfo.Subtext or "",
				TextSize = Library.PanelStyle.InfoSize,
				Font = Library.PanelStyle.BoldText and Enum.Font.GothamBold or Enum.Font.Code,
				TextColor3 = SubColor,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Visible = ItemInfo.Subtext ~= nil,
				ZIndex = ZOFF + 4,
				Parent = Row,
			})
			local MetaLab = New("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(TextX, 36),
				Size = UDim2.new(1, -TextX - BtnW - IconW - 14, 0, 13),
				Text = ItemInfo.Meta or "",
				TextSize = Library.PanelStyle.InfoSize,
				Font = Library.PanelStyle.BoldText and Enum.Font.GothamBold or Enum.Font.Code,
				TextColor3 = ItemInfo.MetaColor or Color3.fromRGB(90, 140, 255),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Visible = ItemInfo.Meta ~= nil,
				ZIndex = ZOFF + 4,
				Parent = Row,
			})
			if ItemInfo.ButtonText then
				Act = New("TextButton", {
					AutoButtonColor = false,
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = ItemInfo.ButtonColor or "AccentColor",
					Position = UDim2.new(1, -7 - IconW, 0.5, 0),
					Size = UDim2.fromOffset(BtnW, 24),
					Text = ItemInfo.ButtonText,
					TextSize = 12,
					Font = Enum.Font.Code,
					TextColor3 = "FontColor",
					ZIndex = ZOFF + 4,
					Parent = Row,
				})
				table.insert(Library.Corners, New("UICorner", {
					CornerRadius = UDim.new(0, math.floor(Library.CornerRadius / 2)),
					Parent = Act,
				}))
				New("UIStroke", {
					Color = "OutlineColor",
					Thickness = 1,
					Parent = Act,
				})
				AddLight(Act)
				RecAct = Act
				Act.MouseEnter:Connect(function()
					Act.BackgroundTransparency = 0.12
				end)
				Act.MouseLeave:Connect(function()
					Act.BackgroundTransparency = 0
				end)
				Act.MouseButton1Down:Connect(function()
					Act.BackgroundTransparency = 0.25
				end)
				Act.MouseButton1Up:Connect(function()
					Act.BackgroundTransparency = 0.12
				end)
				Act.MouseButton1Click:Connect(function()
					if ItemInfo.Callback then
						Library:SafeCallback(ItemInfo.Callback, ItemInfo)
					end
				end)
			end

			if ItemInfo.IconButton then
				local IBI = Library:GetCustomIcon(ItemInfo.IconButton)
				IB = New("TextButton", {
					AutoButtonColor = false,
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.35,
					Position = UDim2.new(1, -7, 0.5, 0),
					Size = UDim2.fromOffset(26, 26),
					Text = "",
					ZIndex = ZOFF + 4,
					Parent = Row,
				})
				table.insert(Library.Corners, New("UICorner", {
					CornerRadius = UDim.new(0, math.floor(Library.CornerRadius / 2)),
					Parent = IB,
				}))
				New("UIStroke", {
					Color = "OutlineColor",
					Thickness = 1,
					Parent = IB,
				})
				New("ImageLabel", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = IBI and IBI.Url or "",
					ImageRectOffset = IBI and IBI.ImageRectOffset or nil,
					ImageRectSize = IBI and IBI.ImageRectSize or nil,
					ImageColor3 = IBI and IBI.Custom and "WhiteColor" or "FontColor",
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromOffset(13, 13),
					ZIndex = ZOFF + 5,
					Parent = IB,
				})
				RecIB = IB
				IB.MouseEnter:Connect(function()
					IB.BackgroundTransparency = 0.23
				end)
				IB.MouseLeave:Connect(function()
					IB.BackgroundTransparency = 0.35
				end)
				IB.MouseButton1Click:Connect(function()
					if ItemInfo.IconButtonCallback then
						Library:SafeCallback(ItemInfo.IconButtonCallback, ItemInfo)
					end
				end)
			end
			Row.MouseEnter:Connect(function()
				TweenService:Create(Row, Library.TweenInfo, { BackgroundTransparency = 0.3 }):Play()
			end)
			Row.MouseLeave:Connect(function()
				TweenService:Create(Row, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
			end)
			table.insert(Tab.Items, {
				Row = Row,
				Tile = Tile,
				Ring = Ring,
				Title = TitleLab,
				Sub = SubLab,
				Meta = MetaLab,
				Act = RecAct,
				IB = RecIB,
				HasTile = HasTile,
				NameColor = NameColor,
				SubColor = SubColor,
				Pulses = {},
			})
			local Rec = Tab.Items[#Tab.Items]
			local function StartPulses()
				for _, Tw in ipairs(Rec.Pulses) do
					Tw:Cancel()
				end
				table.clear(Rec.Pulses)
				if not Library.PanelStyle.AnimateText then
					TitleLab.TextColor3 = NameColor or Library.Scheme.FontColor
					SubLab.TextColor3 = SubColor
					return
				end
				if NameColor then
					local Tw = TweenService:Create(TitleLab, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
						TextColor3 = Library:GetBetterColor(NameColor, 18),
					})
					Tw:Play()
					table.insert(Rec.Pulses, Tw)
				end
				local MoneyTw = TweenService:Create(SubLab, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
					TextColor3 = Library:GetBetterColor(SubColor, 18),
				})
				MoneyTw:Play()
				table.insert(Rec.Pulses, MoneyTw)
			end
			StartPulses()
			Rec.StartPulses = StartPulses

			local Handle = {
				Row = Row,
				SetText = function(Value)
					TitleLab.Text = tostring(Value)
				end,
				SetSubtext = function(Value)
					SubLab.Text = tostring(Value)
				end,
				SetMeta = function(Value)
					MetaLab.Text = tostring(Value)
					MetaLab.Visible = Value ~= nil and Value ~= ""
				end,
				SetGlow = function(Color)
					Tile.BackgroundColor3 = Color
					Ring.Color = Color
				end,
				SetTextColor = function(Color)
					NameColor = Color
					Rec.NameColor = Color
					TitleLab.TextColor3 = Color
					StartPulses()
				end,
				Destroy = function()
					for _, Tw in ipairs(Rec.Pulses) do
						Tw:Cancel()
					end
					for Index = #Tab.Items, 1, -1 do
						if Tab.Items[Index] == Rec then
							table.remove(Tab.Items, Index)
						end
					end
					Row:Destroy()
				end,
			}
			return Handle
		end

		function Tab:Clear()
			for _, Rec in ipairs(Tab.Items) do
				for _, Tw in ipairs(Rec.Pulses) do
					Tw:Cancel()
				end
				Rec.Row:Destroy()
			end
			table.clear(Tab.Items)
		end

		table.insert(Panel.Tabs, Tab)
		if not Panel.ActiveTab then
			Panel:SetTab(Tab)
		end
		return Tab
	end

	function Panel:Restyle()
		local S = Library.PanelStyle
		Wallpaper.Visible = S.Wallpaper
		PanelOverlay.Visible = S.Wallpaper
		PanelOverlay.BackgroundTransparency = S.OverlayTransparency
		TopPlate.Visible = S.MetallicHeader
		ShineTween:Cancel()
		if S.MetallicHeader then
			ShineTween:Play()
		end
		TopTitle.TextColor3 = S.MetallicHeader and Color3.fromRGB(20, 20, 20) or Library.Scheme.FontColor
		ChipBar.Size = UDim2.new(1, 0, 0, S.ChipHeight + 6)
		ClosePlate.BackgroundTransparency = S.PlateTransparency
		for _, Chip in ipairs(Panel.Chips) do
			Chip.Relayout()
			Chip.Repaint()
		end
		for _, Tab in ipairs(Panel.Tabs) do
			Tab.Button.Size = UDim2.fromOffset(Tab.Button.Size.X.Offset, S.TabPillHeight)
			for _, Rec in ipairs(Tab.Items) do
				Rec.Row.Size = UDim2.new(1, 0, 0, S.RowHeight)
				Rec.Row.BackgroundTransparency = S.RowTransparency
				Rec.Tile.Size = UDim2.fromOffset(S.TileSize, S.TileSize)
				local TX = Rec.HasTile and (14 + S.TileSize) or 8
				Rec.Title.Position = UDim2.fromOffset(TX, Rec.Title.Position.Y.Offset)
				Rec.Sub.Position = UDim2.fromOffset(TX, Rec.Sub.Position.Y.Offset)
				Rec.Meta.Position = UDim2.fromOffset(TX, Rec.Meta.Position.Y.Offset)
				Rec.Title.Font = S.BoldText and Enum.Font.GothamBold or Enum.Font.Code
				Rec.Sub.Font = S.BoldText and Enum.Font.GothamBold or Enum.Font.Code
				Rec.Meta.Font = S.BoldText and Enum.Font.GothamBold or Enum.Font.Code
				Rec.Title.TextSize = S.TitleSize
				Rec.Sub.TextSize = S.InfoSize
				Rec.Meta.TextSize = S.InfoSize
				Rec.StartPulses()
				Rec.Tile.BackgroundTransparency = S.GlowTransparency
				Rec.Ring.Enabled = S.GlowRing
				Rec.Sub.Position = UDim2.fromOffset(Rec.Sub.Position.X.Offset, math.floor(S.RowHeight * 0.375))
				Rec.Meta.Position = UDim2.fromOffset(Rec.Meta.Position.X.Offset, math.floor(S.RowHeight * 0.64))
				local BtnH = math.clamp(S.RowHeight - 30, 20, 30)
				if Rec.Act then
					Rec.Act.Size = UDim2.fromOffset(Rec.Act.Size.X.Offset, BtnH)
				end
				if Rec.IB then
					Rec.IB.Size = UDim2.fromOffset(BtnH, BtnH)
					Rec.IB.BackgroundTransparency = S.PlateTransparency
				end
			end
		end
		Relayout()
	end

	function Panel:SetVisible(State)
		Panel.Visible = State and true or false
		TweenService:Create(Wrapper, Library.NotifyTweenInfo, {
			Position = UDim2.new(1, Panel.Visible and -24 or Width + 4, 0.5, 0),
		}):Play()
	end

	function Panel:Toggle()
		Panel:SetVisible(not Panel.Visible)
	end

	function Panel:Destroy()
		Panel.Destroyed = true
		ShineTween:Cancel()
		for _, Tab in ipairs(Panel.Tabs) do
			for _, Rec in ipairs(Tab.Items) do
				for _, Tw in ipairs(Rec.Pulses) do
					Tw:Cancel()
				end
			end
		end
		for Index = #Library.Panels, 1, -1 do
			if Library.Panels[Index] == Panel then
				table.remove(Library.Panels, Index)
			end
		end
		Wrapper:Destroy()
	end

	table.insert(Library.Panels, Panel)
	return Panel
end

function Library:CreateLoading(LoadingInfo)
	if Library.ActiveLoading then
		warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
		return Library.ActiveLoading
	end

	LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)

	local Loading = {
		CurrentStep = LoadingInfo.CurrentStep,
		TotalSteps = LoadingInfo.TotalSteps,

		ShowSidebar = LoadingInfo.ShowSidebar,
		AutoResizeHeight = LoadingInfo.AutoResizeHeight,
		IsError = false,
		Destroyed = false,

		WindowWidth = LoadingInfo.WindowWidth,
		WindowHeight = LoadingInfo.WindowHeight,
		BaseWindowHeight = LoadingInfo.WindowHeight,
		WindowErrorHeight = LoadingInfo.WindowHeight,

		ContentWidth = LoadingInfo.ContentWidth,
		SidebarWidth = LoadingInfo.SidebarWidth,
	}

	--// ScreenGui \\--
	local ScreenGui = New("ScreenGui", {
		Name = "ObsidianLoading",
		DisplayOrder = 999,
		ResetOnSpawn = false,
	})
	ParentUI(ScreenGui)
	Loading.ScreenGui = ScreenGui

	ScreenGui.DescendantRemoving:Connect(function(Instance)
		Library:RemoveFromRegistry(Instance)
	end)

	--// Main Frame \\--
	local MainFrame = New("TextButton", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = function()
			return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
		end,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(
			Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth,
			Loading.WindowHeight
		),
		ClipsDescendants = true,
		Text = "",
		AutoButtonColor = false,
		Parent = ScreenGui,
	})
	Library:AddOutline(MainFrame)

	table.insert(
		Library.Corners,
		New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame })
	)

	local MainScale = New("UIScale", {
		Scale = Library.IsMobile and 0.8 or 1,
		Parent = MainFrame,
	})
	table.insert(Library.Scales, MainScale)
	Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

	--// Layout Containers \\--
	local Container = New("Frame", {
		Name = "Content",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
		Parent = MainFrame,
	})

	local SideBar = New("Frame", {
		Name = "SideBar",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(Loading.ContentWidth, 0),
		Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
		ClipsDescendants = true,
		Visible = Loading.ShowSidebar,
		Parent = MainFrame,
	})
	local SidebarCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
	table.insert(Library.Corners, SidebarCorner)

	Library:AddOutline(SideBar)

	local SidebarDivider = New("Frame", {
		BackgroundColor3 = "OutlineColor",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Visible = Loading.ShowSidebar,
		Parent = SideBar,
	})

	--// Top Bar \\--
	local TopBar = New("Frame", {
		Name = "TopBar",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 48),
		ZIndex = 2,
		Parent = Container,
	})
	Library:MakeDraggable(MainFrame, TopBar, true, true)

	local TitleHolder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = TopBar,
	})
	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 6),
		Parent = TitleHolder,
	})
	New("UIPadding", {
		PaddingLeft = UDim.new(0, 12),
		Parent = TitleHolder,
	})

	if LoadingInfo.Icon then
		local Icon = Library:GetCustomIcon(LoadingInfo.Icon)
		local _WindowIcon = New("ImageLabel", {
			Image = Icon.Url,
			ImageRectOffset = Icon.ImageRectOffset,
			ImageRectSize = Icon.ImageRectSize,
			Size = LoadingInfo.IconSize,
			Parent = TitleHolder,
		})
	else
		local _WindowIcon = New("TextLabel", {
			BackgroundTransparency = 1,
			Size = LoadingInfo.IconSize,
			Text = LoadingInfo.Title:sub(1, 1),
			TextScaled = true,
			Visible = false,
			Parent = TitleHolder,
		})
	end

	local TitleX = Library:GetTextBounds(
		LoadingInfo.Title,
		Library.Scheme.Font,
		20,
		TitleHolder.AbsoluteSize.X - (LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0) - 12
	)
	local _WindowTitle = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, TitleX, 1, 0),
		Text = LoadingInfo.Title,
		TextSize = 20,
		Parent = TitleHolder,
	})

	Library:MakeLine(Container, {
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.new(1, 0, 0, 1),
	})

	--// Loading Content Elements \\--
	local InnerContent = New("Frame", {
		Name = "InnerContent",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 49),
		Size = UDim2.new(1, 0, 1, -49),
		Parent = Container,
	})

	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 12),
		Parent = InnerContent,
	})

	local IconHolder = New("Frame", {
		Name = "IconHolder",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(64, 64),
		Parent = InnerContent,
	})

	local LoaderIcon = Library:GetCustomIcon(LoadingInfo.LoadingIcon)
	local LoadingIcon = New("ImageLabel", {
		Name = "LoaderIcon",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Image = LoaderIcon.Url,
		ImageRectOffset = LoaderIcon.ImageRectOffset,
		ImageRectSize = LoaderIcon.ImageRectSize,
		ImageColor3 = LoadingInfo.LoadingIconColor
			or ((LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor" or "WhiteColor"),
		Parent = IconHolder,
	})

	local RotationTween
	if LoadingInfo.LoadingIconTweenTime > 0 then
		RotationTween = TweenService:Create(
			LoadingIcon,
			TweenInfo.new(LoadingInfo.LoadingIconTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
			{ Rotation = 360 }
		)
		RotationTween:Play()
	end

	local MessageLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
		Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
		Text = "",
		TextSize = 18,
		TextWrapped = Loading.AutoResizeHeight,
		Parent = InnerContent,
	})

	local DescriptionLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
		Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
		Text = "",
		TextSize = 14,
		TextTransparency = 0.5,
		TextWrapped = Loading.AutoResizeHeight,
		Parent = InnerContent,
	})

	--// Progress Bar \\--
	local SliderBar = New("Frame", {
		BackgroundColor3 = "MainColor",
		Size = UDim2.new(0.7, 0, 0, 15),
		Parent = InnerContent,
	})
	Library:AddOutline(SliderBar)
	table.insert(
		Library.Corners,
		New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderBar })
	)

	local SliderFill = New("Frame", {
		BackgroundColor3 = "AccentColor",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0, 1),
		Parent = SliderBar,
	})
	table.insert(
		Library.Corners,
		New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderFill })
	)

	local ProgressLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		TextSize = 14,
		ZIndex = 2,
		Parent = SliderBar,
	})
	New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
		Color = "DarkColor",
		LineJoinMode = Enum.LineJoinMode.Miter,
		Parent = ProgressLabel,
	})

	--// Sidebar Object \\--
	local SidebarScrolling = New("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Size = UDim2.fromScale(1, 1),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = "OutlineColor",
		Parent = SideBar,
	})
	local SidebarList = New("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = SidebarScrolling,
	})
	New("UIPadding", {
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		PaddingTop = UDim.new(0, 12),
		Parent = SidebarScrolling,
	})

	local SidebarObject = {
		Elements = {},
		DependencyBoxes = {},
		Tabboxes = {},

		BoxHolder = SidebarScrolling,
		Container = SidebarScrolling,

		Resize = function(self)
			SidebarScrolling.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
		end,
		Tab = {
			Elements = {},
			DependencyBoxes = {},
			DependencyGroupboxes = {},
			Tabboxes = {},
		},
	}

	SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SidebarObject:Resize()
	end)

	setmetatable(SidebarObject, BaseGroupbox)
	Loading.Sidebar = SidebarObject

	--// Error Frame \\--
	local ErrorFrame = New("Frame", {
		Name = "Error",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 49),
		Size = UDim2.new(1, 0, 1, -49),
		ClipsDescendants = true,
		Visible = false,
		Parent = Container,
	})

	local _ErrorTitle = New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(15, 15),
		Size = UDim2.new(1, -30, 0, 18),
		Text = "Error",
		TextColor3 = "RedColor",
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = ErrorFrame,
	})

	local ErrorLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(15, 39),
		Size = UDim2.new(1, -30, 1, -90),
		Text = "Error Message",
		TextSize = 14,
		TextTransparency = 0.2,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = ErrorFrame,
	})

	local ErrorButtonsDivider = New("Frame", {
		BackgroundColor3 = "OutlineColor",
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 1, -48),
		Size = UDim2.new(1, -30, 0, 1),
		Visible = false,
		Parent = ErrorFrame,
	})

	local ErrorButtonsHolder = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 42),
		Visible = false,
		Parent = ErrorFrame,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 8),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = ErrorButtonsHolder,
	})
	New("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 15),
		PaddingRight = UDim.new(0, 15),
		Parent = ErrorButtonsHolder,
	})

	function Loading:UpdateLayout()
		if Loading.IsError then
			Loading:RecalculateErrorHeight()
		end

		local ShowSidebar = Loading.ShowSidebar
		local FinalWidth = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth
		local FinalHeight = Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight

		if ShowSidebar then
			SideBar.Visible = true
			SidebarDivider.Visible = true
		end

		TweenService:Create(MainFrame, Library.TweenInfo, { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }):Play()
		TweenService:Create(SideBar, Library.TweenInfo, {
			Position = UDim2.fromOffset(Loading.ContentWidth, 0),
			Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
		}):Play()
		TweenService:Create(
			Container,
			Library.TweenInfo,
			{ Size = UDim2.new(0, ShowSidebar and Loading.ContentWidth or Loading.WindowWidth, 1, 0) }
		):Play()

		if not ShowSidebar then
			task.delay(Library.TweenInfo.Time, function()
				if not Loading.ShowSidebar then
					SideBar.Visible = false
					SidebarDivider.Visible = false
				end
			end)
		end
	end

	--// Content Page \\--
	function Loading:RecalculateLoadingHeight()
		if not Loading.AutoResizeHeight then
			return
		end

		local RequiredHeight = 49 -- TopBar
			+ 48 -- Padding
			+ InnerContent.UIListLayout.AbsoluteContentSize.Y

		Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
	end

	function Loading:SetMessage(Text)
		MessageLabel.Text = Text

		if Loading.AutoResizeHeight then
			Loading:RecalculateLoadingHeight()
			Loading:UpdateLayout()
		end
	end

	function Loading:SetDescription(Text)
		DescriptionLabel.Text = Text

		if Loading.AutoResizeHeight then
			Loading:RecalculateLoadingHeight()
			Loading:UpdateLayout()
		end
	end

	function Loading:SetLoadingIcon(Icon)
		local IconData = Library:GetCustomIcon(Icon)
		LoadingIcon.Image = IconData.Url
		LoadingIcon.ImageRectOffset = IconData.ImageRectOffset
		LoadingIcon.ImageRectSize = IconData.ImageRectSize
	end

	function Loading:SetLoadingIconTweenTime(TweenTime)
		if RotationTween then
			StopTween(RotationTween, true)
			RotationTween = nil
		end

		if TweenTime > 0 then
			RotationTween = TweenService:Create(
				LoadingIcon,
				TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
				{ Rotation = 360 }
			)
			RotationTween:Play()
		else
			LoadingIcon.Rotation = 0
		end
	end

	function Loading:SetLoadingIconColor(Color)
		LoadingIcon.ImageColor3 = Color
	end

	function Loading:SetCurrentStep(Step)
		Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

		local Progress = Loading.CurrentStep / Loading.TotalSteps
		TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) }):Play()

		ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
	end

	function Loading:SetTotalSteps(Steps)
		Loading.TotalSteps = Steps
		Loading:SetCurrentStep(Loading.CurrentStep)
	end

	--// Size \\--
	function Loading:SetWindowHeight(Height)
		Loading.WindowHeight = Height
		Loading:UpdateLayout()
	end

	function Loading:SetWindowWidth(Width)
		Loading.WindowWidth = Width
		Loading:UpdateLayout()
	end

	function Loading:SetContentWidth(Width)
		Loading.ContentWidth = Width
		Loading:UpdateLayout()
	end

	function Loading:SetSidebarWidth(Width)
		Loading.SidebarWidth = Width
		Loading:UpdateLayout()
	end

	--// Sidebar \\--
	function Loading:ShowSidebarPage(Bool)
		Loading.ShowSidebar = Bool
		Loading:UpdateLayout()
	end

	--// Error Page \\--
	function Loading:ShowErrorPage(Enabled)
		Loading.IsError = Enabled
		InnerContent.Visible = not Enabled
		ErrorFrame.Visible = Enabled

		if Loading.ShowSidebar then
			Loading:ShowSidebarPage(not Enabled)
		else
			Loading:UpdateLayout()
		end
	end

	function Loading:RecalculateErrorHeight()
		local TargetWidth = (Loading.ShowSidebar and Loading.ContentWidth or Loading.WindowWidth) - 30
		local _, ErrorY = Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

		ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

		local HasButtons = ErrorButtonsHolder.Visible
		local RequiredHeight = 49 -- TopBar
			+ 15 -- Padding Top
			+ 18 -- Title Height
			+ 6 -- Padding between Title and Label
			+ ErrorY -- Label Height
			+ 15 -- Padding between Label and Buttons
			+ (HasButtons and 48 or 0) -- Buttons Area

		Loading.WindowErrorHeight = RequiredHeight -- math.max(Loading.WindowHeight, RequiredHeight)
	end

	function Loading:SetErrorMessage(Text)
		ErrorLabel.Text = Text
		Loading:UpdateLayout()
	end

	function Loading:SetErrorButtons(Buttons)
		assert(typeof(Buttons) == "table", "Buttons must be a table")

		for _, button in ErrorButtonsHolder:GetChildren() do
			if button:IsA("Frame") then
				button:Destroy()
			end
		end

		local HasButtons = GetTableSize(Buttons) > 0
		ErrorButtonsHolder.Visible = HasButtons
		ErrorButtonsDivider.Visible = HasButtons

		for Idx, ButtonInfo in Buttons do
			local ButtonContainer = New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 26),
				Parent = ErrorButtonsHolder,
			})

			local BtnColor = "MainColor"
			local BtnOutline = "OutlineColor"
			local Variant = ButtonInfo.Variant or "Primary"

			if Variant == "Primary" then
				BtnColor = "FontColor"
				BtnOutline = "FontColor"
			elseif Variant == "Secondary" then
				BtnColor = "MainColor"
				BtnOutline = "OutlineColor"
			elseif Variant == "Destructive" then
				BtnColor = "DestructiveColor"
				BtnOutline = "DestructiveColor"
			elseif Variant == "Ghost" then
				BtnColor = "BackgroundColor"
				BtnOutline = "BackgroundColor"
			end

			local TextBtn = New("TextButton", {
				BackgroundColor3 = BtnColor,
				BorderColor3 = BtnOutline,
				Size = UDim2.fromOffset(0, 26),
				Text = "",
				AutoButtonColor = false,
				Parent = ButtonContainer,
			})
			Library:AddOutline(TextBtn)
			table.insert(
				Library.Corners,
				New("UICorner", {
					CornerRadius = UDim.new(0, Library.CornerRadius),
					Parent = TextBtn,
				})
			)

			New("UIPadding", {
				PaddingLeft = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 15),
				Parent = TextBtn,
			})

			local TextColor = Variant == "Primary" and "BackgroundColor" or "FontColor"

			local BtnLabel = New("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = ButtonInfo.Title or Idx,
				TextColor3 = TextColor,
				TextSize = 14,
				Parent = TextBtn,
			})

			local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
			ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
			TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

			local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
			local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor
				or Library:GetBetterColor(ActiveColor, 10)

			TextBtn.MouseEnter:Connect(function()
				TweenService:Create(TextBtn, Library.TweenInfo, {
					BackgroundColor3 = HoverColor,
				}):Play()
			end)
			TextBtn.MouseLeave:Connect(function()
				TweenService:Create(TextBtn, Library.TweenInfo, {
					BackgroundColor3 = ActiveColor,
				}):Play()
			end)

			TextBtn.MouseButton1Click:Connect(function()
				if ButtonInfo.Callback then
					ButtonInfo.Callback(Loading)
				end
			end)
		end

		Loading:UpdateLayout()
	end

	--// Destroy/Continue \\--
	function Loading:Destroy()
		if RotationTween then
			StopTween(RotationTween, true)
			RotationTween = nil
		end

		ScreenGui:Destroy()
		Loading.Destroyed = true
		Library.ActiveLoading = nil

		-- Show floating toggle again after loading finishes
		if Library.FloatingToggle then
			Library.FloatingToggle.Visible = true
		end

		if Library.Toggle and Library.Toggled == false and Library.Unloaded ~= true then
			Library:Toggle(true)
		end
	end

	Loading.Continue = Loading.Destroy

	if Library.Toggle and Library.Toggled and Library.Unloaded ~= true then
		Library:Toggle(false)
	end

	-- Hide floating toggle while loading is active (in case CreateWindow ran first)
	if Library.FloatingToggle then
		Library.FloatingToggle.Visible = false
	end

	Loading:SetCurrentStep(Loading.CurrentStep)

	Library.ActiveLoading = Loading
	return Loading
end

local function OnPlayerChange()
	if Library.Unloaded then
		return
	end

	local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
	for _, Dropdown in Options do
		if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
			Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
		end
	end
end

local function OnTeamChange()
	if Library.Unloaded then
		return
	end

	local TeamList = GetTeams()
	for _, Dropdown in Options do
		if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
			Dropdown:SetValues(TeamList)
		end
	end
end

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

function Library:Unload()
	Library.Unloaded = true

	--// Disconnect connections
	for Index = #Library.Signals, 1, -1 do
		local Connection = table.remove(Library.Signals, Index)

		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end

	--// Run Unload Callbacks
	for _ = 1, #Library.UnloadSignals do
		local Callback = table.remove(Library.UnloadSignals, 1)

		if Callback then
			Library:SafeCallback(Callback)
		end
	end

	--// Destroy elements
	for Index = #Library.Tabs, 1, -1 do
		local Tab = table.remove(Library.Tabs, Index)

		if Tab and Tab.Destroy then
			Library:SafeCallback(Tab.Destroy, Tab)
		end
	end

	for Index = #Tooltips, 1, -1 do
		local Tooltip = table.remove(Tooltips, Index)

		if Tooltip and Tooltip.Destroy then
			Library:SafeCallback(Tooltip.Destroy, Tooltip)
		end
	end

	if Library.ActiveLoading then
		Library.ActiveLoading:Destroy()
	end

	if ScreenGui then
		ScreenGui:Destroy()
	end

	--// Clear tables
	table.clear(Library.Registry)

	table.clear(Options)
	table.clear(Toggles)
	table.clear(Buttons)
	table.clear(Labels)
	table.clear(Tooltips)

	table.clear(Library.Tabs)
	table.clear(Library.TabButtons)

	table.clear(Library.Scales)
	table.clear(Library.ScalesOffset)

	table.clear(Library.Corners)
	table.clear(Library.SpecificCorners)

	table.clear(Library.Notifications)
	table.clear(Library.Dialogues)
	table.clear(Library.DraggableElements)
	table.clear(Library.KeybindToggles)
	table.clear(Library.DependencyBoxes)

	table.clear(TransparencyCache)
	table.clear(FadeTweenCache)
	table.clear(ActiveTabTweens)

	Library.Toggle = function(...) end
	Library.ScreenGui = nil
	Library.WindowContainer = nil
	Library.KeybindFrame = nil
	Library.KeybindContainer = nil

	getgenv().Library = nil
end

--[[ Library:CreateOverlay(Info) ]]
function Library:CreateOverlay(Info: { [string]: any }): { [string]: any }
	Info = Info or {}
	local Title = Info.Title or "Overlay"
	local StartPos = Info.Position or UDim2.fromOffset(300, 120)
	local CW = 200

	local Holder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = "BackgroundColor",
		Position = StartPos,
		Size = UDim2.fromOffset(0, 0),
		ZIndex = 10,
		Parent = ScreenGui,
	})
	table.insert(
		Library.Corners,
		New("UICorner", {
			CornerRadius = UDim.new(0, Library.CornerRadius),
			Parent = Holder,
		})
	)
	table.insert(
		Library.Scales,
		New("UIScale", {
			Parent = Holder,
		})
	)
	Library:AddOutline(Holder)

	New("UIPadding", {
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10),
		Parent = Holder,
	})

	New("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Holder,
	})

	local Header = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(CW, 24),
		LayoutOrder = 1,
		Parent = Holder,
	})
	New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Header,
	})
	local TitleLabel = New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(0, 24),
		Text = Title,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(220, 220, 220),
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Header,
	})
	New("ImageLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		Image = "rbxassetid://95816097006870",
		Parent = Header,
	})

	local Divider = New("Frame", {
		BackgroundColor3 = Color3.fromRGB(80, 80, 90),
		Size = UDim2.fromOffset(CW, 1),
		LayoutOrder = 2,
		Parent = Holder,
	})

	local Body = New("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromOffset(CW, 0),
		LayoutOrder = 3,
		Parent = Holder,
	})
	local BodyList = New("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Body,
	})

	local FooterLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(CW, 16),
		Text = "Luxy Hub",
		TextSize = 11,
		TextColor3 = Color3.fromRGB(220, 220, 220),
		TextTransparency = 0.5,
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.Gotham,
		LayoutOrder = 4,
		Parent = Holder,
	})

	-- Keep header/divider/footer in sync with the widest row
	local function ResizeToFit()
		local ContentW = BodyList.AbsoluteContentSize.X
		local TargetW = math.max(CW, ContentW + 8)
		Header.Size = UDim2.fromOffset(TargetW, 24)
		Divider.Size = UDim2.fromOffset(TargetW, 1)
		Body.Size = UDim2.fromOffset(TargetW, 0)
		FooterLabel.Size = UDim2.fromOffset(TargetW, 16)
	end
	BodyList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(ResizeToFit)

	local Rows = {}
	local RowOrder = {}

	Library:MakeDraggable(Holder, Header, true)
	PositionDraggable(Holder, StartPos)
	if not table.find(Library.DraggableElements, Holder) then
		table.insert(Library.DraggableElements, Holder)
	end

	local Self = {}

	function Self:SetVisible(State)
		if State == nil then
			State = not Holder.Visible
		end
		Holder.Visible = State
	end

	function Self:SetRow(Key: string, Value: any, ValueColor: Color3?)
		local Row = Rows[Key]
		if Row then
			Row.Value.Text = tostring(Value)
			Row.Value.TextColor3 = ValueColor or Color3.new(1, 1, 1)
			return
		end
		local RowFrame = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 20),
			LayoutOrder = #RowOrder + 1,
			Parent = Body,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = RowFrame,
		})
		local K = New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 20),
			Text = tostring(Key) .. ":",
			TextSize = 13,
			TextColor3 = Color3.fromRGB(220, 220, 220),
			TextTransparency = 0.3,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = RowFrame,
		})
		local V = New("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 20),
			Text = tostring(Value),
			TextSize = 13,
			TextColor3 = ValueColor or Color3.new(1, 1, 1),
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = RowFrame,
		})
		table.insert(RowOrder, Key)
		Rows[Key] = { Frame = RowFrame, Key = K, Value = V }
	end

	function Self:RemoveRow(Key: string)
		local Row = Rows[Key]
		if Row then
			Row.Frame:Destroy()
			Rows[Key] = nil
			for i, k in ipairs(RowOrder) do
				if k == Key then
					table.remove(RowOrder, i)
					break
				end
			end
		end
	end

	function Self:ClearRows()
		for _, Row in pairs(Rows) do
			Row.Frame:Destroy()
		end
		table.clear(Rows)
		table.clear(RowOrder)
	end

	function Self:Destroy()
		Self:ClearRows()
		Holder:Destroy()
	end

	return Self
end

getgenv().Library = Library
return Library

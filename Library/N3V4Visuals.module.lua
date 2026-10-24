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
local RunService = game:GetService("RunService")
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

local Active = {}
local ShadowActive = {}
local SHADOW_LAYERS = 4
local Ticker = nil

local function EnsureTicker()
	if Ticker then
		return
	end
	Ticker = RunService.Heartbeat:Connect(function(dt)
		for i = #Active, 1, -1 do
			local St = Active[i]
			if St.Dead or not St.Grad.Parent then
				table.remove(Active, i)
			else
				local Conf = St.GetConf()
				if not Conf.Enabled then
					St.Dead = true
					table.remove(Active, i)
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
		for i = #ShadowActive, 1, -1 do
			local St = ShadowActive[i]
			local Conf = St.GetConf()
			local Alive = not St.Dead and St.Target.Parent ~= nil and Conf.Enabled
			if Alive then
				for _, L in ipairs(St.Layers) do
					if not L.Inst.Parent then
						Alive = false
						break
					end
				end
			end
			if not Alive then
				St.Dead = true
				for _, L in ipairs(St.Layers) do
					L.Inst:Destroy()
				end
				table.remove(ShadowActive, i)
			else
				St.Color = St.Color:Lerp(Conf.Color, math.min(1, dt))
				St.Trans = St.Trans + (Conf.Transparency - St.Trans) * math.min(1, dt)
				St.Depth = St.Depth + (Conf.Offset - St.Depth) * math.min(1, dt)
				local dR = St.Color.R - Conf.Color.R
				local dG = St.Color.G - Conf.Color.G
				local dB = St.Color.B - Conf.Color.B
				local Moving = dR * dR + dG * dG + dB * dB > 0.000016 or math.abs(St.Trans - Conf.Transparency) > 0.002 or math.abs(St.Depth - Conf.Offset) > 0.05
				local LayerTrans = math.pow(math.clamp(St.Trans, 0, 1), 1 / SHADOW_LAYERS)
				for _, L in ipairs(St.Layers) do
					if Moving or not St.Painted then
						L.Inst.BackgroundColor3 = St.Color
						L.Inst.BackgroundTransparency = LayerTrans
					end
					local E = L.Expand
					local D = St.Depth * (E / SHADOW_LAYERS)
					L.Inst.Position = St.Target.Position + UDim2.new(0, -E, 0, D - E)
					L.Inst.Size = St.Target.Size + UDim2.new(0, 2 * E, 0, 2 * E)
					L.Inst.ZIndex = St.Target.ZIndex - 1
				end
				St.Painted = not Moving
			end
		end
		if #Active == 0 and #ShadowActive == 0 then
			Ticker:Disconnect()
			Ticker = nil
		end
	end)
end

local function AddViewport(Env, Groupbox, Idx, Info)
	if Groupbox.Destroyed then
		return nil
	end

	local Container = Groupbox.Container

	local ViewportFrame = Env.New("ViewportFrame", {
		BackgroundColor3 = "MainColor",
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, Info.Height or 140),
		LightColor = Color3.fromRGB(255, 255, 255),
		LightDirection = Vector3.new(-1, 2, -1),
		Ambient = Color3.fromRGB(180, 180, 180),
		Parent = Container,
	})
	table.insert(
		Env.Library.Corners,
		Env.New("UICorner", {
			CornerRadius = UDim.new(0, Env.Library.CornerRadius),
			Parent = ViewportFrame,
		})
	)
	Env.New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1,
		Parent = ViewportFrame,
	})

	local Camera = Instance.new("Camera")
	Camera.FieldOfView = 50
	Camera.Parent = ViewportFrame
	ViewportFrame.CurrentCamera = Camera

	local WorldModel = Instance.new("WorldModel")
	WorldModel.Parent = ViewportFrame

	local CurrentModel = nil
	local AngleX = 14
	local AngleY = 0
	local CameraDistance = 10
	local Dragging = false
	local LastMousePos = Vector2.zero

	local function OrbitCamera()
		if not CurrentModel then
			return
		end
		local cf = CurrentModel:IsA("Model") and CurrentModel:GetBoundingBox() or CurrentModel.CFrame
		local az = math.rad(AngleY)
		local el = math.rad(AngleX)
		local off = Vector3.new(math.sin(az) * math.cos(el), math.sin(el), math.cos(az) * math.cos(el)) * CameraDistance
		Camera.CFrame = CFrame.new(cf.Position + off, cf.Position)
	end

	local function AutoFocus(targetInstance)
		if not targetInstance then
			return
		end
		local cf, size
		if targetInstance:IsA("Model") then
			cf, size = targetInstance:GetBoundingBox()
		else
			cf, size = targetInstance.CFrame, targetInstance.Size
		end
		local maxDim = math.max(size.X, size.Y, size.Z)
		CameraDistance = maxDim / (2 * math.tan(math.rad(Camera.FieldOfView / 2))) * 1.35
		AngleY = 0
		AngleX = 14
		OrbitCamera()
	end

	local ViewportObj = {
		Frame = ViewportFrame,
		Camera = Camera,
		WorldModel = WorldModel,
		Type = "Viewport",
	}

	function ViewportObj:SetModel(modelSource)
		WorldModel:ClearAllChildren()
		CurrentModel = nil
		if not modelSource then
			return
		end

		local clone = modelSource:Clone()
		if clone:IsA("Model") or clone:IsA("BasePart") then
			for _, desc in ipairs(clone:GetDescendants()) do
				if desc:IsA("LuaSourceContainer") or desc:IsA("Sound") then
					desc:Destroy()
				elseif desc:IsA("BasePart") then
					desc.Anchored = true
					desc.CanCollide = false
				end
			end
			if clone:IsA("BasePart") then
				clone.Anchored = true
			end

			clone.Parent = WorldModel
			CurrentModel = clone
			AutoFocus(clone)
		end
	end

	-- AUTO ROTATE & INTERACTIVE DRAG
	local SpinConnection = nil
	if Info.Spin ~= false then
		SpinConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
			if not Dragging and CurrentModel then
				AngleY = (AngleY + dt * 40) % 360
				OrbitCamera()
			end
		end)
	end

	if Info.Interactive then
		ViewportFrame.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton2
				or input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				LastMousePos = Vector2.new(input.Position.X, input.Position.Y)
			end
		end)
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton2
				or input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = false
			end
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if
				Dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				local curPos = Vector2.new(input.Position.X, input.Position.Y)
				local delta = curPos - LastMousePos
				LastMousePos = curPos
				AngleY = (AngleY - delta.X * 0.8) % 360
				AngleX = math.clamp(AngleX + delta.Y * 0.5, -75, 75)
				OrbitCamera()
			end
		end)
	end

	Groupbox:Resize()
	table.insert(Groupbox.Elements, ViewportObj)
	if Idx then
		Env.Options[Idx] = ViewportObj
	end

	return ViewportObj
end

--// SPOTLIGHT CARD: FRAMED IMAGE/3D PANEL + FRAMED TEXT PANEL (CUT GAP, NO-TEXT MODE)
local function AddSpotlightCard(Env, Groupbox, Idx, Info)
	if Groupbox.Destroyed then
		return nil
	end

	local Container = Groupbox.Container

	local CardFrame = Env.New("Frame", {
		BackgroundColor3 = "MainColor",
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, Info.Height or 120),
		Parent = Container,
	})
	table.insert(
		Env.Library.Corners,
		Env.New("UICorner", {
			CornerRadius = UDim.new(0, Env.Library.CornerRadius),
			Parent = CardFrame,
		})
	)
	Env.New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1,
		Parent = CardFrame,
	})

	local ImagePanel = Env.New("Frame", {
		Name = "ImagePanel",
		BackgroundColor3 = "MainColor",
		Position = UDim2.fromOffset(4, 4),
		Parent = CardFrame,
	})
	table.insert(
		Env.Library.Corners,
		Env.New("UICorner", {
			CornerRadius = UDim.new(0, Env.Library.CornerRadius),
			Parent = ImagePanel,
		})
	)
	local ImageStroke = Env.New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1,
		Parent = ImagePanel,
	})

	local ImageGrad = Env.New("UIGradient", {
		Parent = ImagePanel,
	})

	local MediaBox = Env.New("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.new(1, -6, 1, -6),
		Parent = ImagePanel,
	})
	table.insert(
		Env.Library.Corners,
		Env.New("UICorner", {
			CornerRadius = UDim.new(0, Env.Library.CornerRadius),
			Parent = MediaBox,
		})
	)

	local IconImg = Env.New("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Image = Info.Image or "",
		ScaleType = Enum.ScaleType.Fit,
		Parent = MediaBox,
	})

	local Viewport3D = Env.New("ViewportFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		LightColor = Color3.fromRGB(255, 255, 255),
		Ambient = Color3.fromRGB(190, 190, 190),
		LightDirection = Vector3.new(-1, 2, -1),
		Visible = false,
		Parent = MediaBox,
	})
	local Cam3D = Instance.new("Camera")
	Cam3D.FieldOfView = 48
	Cam3D.Parent = Viewport3D
	Viewport3D.CurrentCamera = Cam3D
	local World3D = Instance.new("WorldModel")
	World3D.Parent = Viewport3D

	local TextPanel = Env.New("Frame", {
		Name = "TextPanel",
		BackgroundColor3 = "MainColor",
		ClipsDescendants = true,
		Parent = CardFrame,
	})
	table.insert(
		Env.Library.Corners,
		Env.New("UICorner", {
			CornerRadius = UDim.new(0, Env.Library.CornerRadius),
			Parent = TextPanel,
		})
	)
	local TextStroke = Env.New("UIStroke", {
		Color = "OutlineColor",
		Thickness = 1,
		Parent = TextPanel,
	})
	Env.New("UIListLayout", {
		Padding = UDim.new(0, 2),
		Parent = TextPanel,
	})
	Env.New("UIPadding", {
		PaddingBottom = UDim.new(0, 5),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
		PaddingTop = UDim.new(0, 5),
		Parent = TextPanel,
	})

	local TitleLabel = Env.New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Text = Info.Title or "",
		TextSize = 13,
		RichText = true,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = TextPanel,
	})
	local DescLabel = Env.New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Text = Info.Description or "",
		TextSize = 11,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TextPanel,
	})
	local BindMirror = Env.New("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Text = "",
		TextSize = 11,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Visible = false,
		Parent = TextPanel,
	})

	local CardObj = {
		Frame = CardFrame,
		Icon = IconImg,
		Viewport = Viewport3D,
		Title = TitleLabel,
		Desc = DescLabel,
		Type = "SpotlightCard",
		TextLabels = { TitleLabel, DescLabel, BindMirror },
		NoTextLocked = Info.NoText == true,
		HasText = false,
	}
	if not CardObj.NoTextLocked and (Info.Title or Info.Description or Info.Lines or Info.BindLabel) then
		CardObj.HasText = true
	end

	local LinesHolder = {}

	function CardObj:Relayout()
		local P = Env.Library.CardPanels
		TextPanel.Visible = CardObj.HasText
		ImageStroke.Transparency = P.Outline and 0 or 1
		TextStroke.Transparency = P.Outline and 0 or 1
		ImagePanel.BackgroundTransparency = P.FrameTransparency
		TextPanel.BackgroundTransparency = P.FrameTransparency
		for _, Lbl in ipairs(CardObj.TextLabels) do
			if Lbl.Parent then
				Lbl.TextSize = Lbl == TitleLabel and P.TextSize + 1 or P.TextSize
			end
		end
		local frac = math.clamp(P.ImageWidth, 20, 70) / 100
		local gap = math.clamp(P.Gap, 0, 24)
		if CardObj.HasText then
			ImagePanel.Size = UDim2.new(frac, -8 * frac - gap / 2, 1, -8)
			TextPanel.Position = UDim2.new(frac, 4 - 8 * frac + gap / 2, 0, 4)
			TextPanel.Size = UDim2.new(1 - frac, -8 * (1 - frac) - gap / 2, 1, -8)
		else
			ImagePanel.Size = UDim2.new(1, -8, 1, -8)
		end
	end

	function CardObj:SetLines(Lines)
		for _, Lbl in ipairs(LinesHolder) do
			Lbl:Destroy()
		end
		table.clear(LinesHolder)
		CardObj.TextLabels = { TitleLabel, DescLabel, BindMirror }
		if type(Lines) == "table" then
			for _, Row in ipairs(Lines) do
				local C = Row.Color or Env.Library.Scheme.AccentColor
				local Lbl = Env.New("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					RichText = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = string.format(
						'<font color="rgb(%d, %d, %d)">%s</font>: %s',
						math.floor(C.R * 255 + 0.5), math.floor(C.G * 255 + 0.5), math.floor(C.B * 255 + 0.5),
						tostring(Row.Label or ""), tostring(Row.Value or "")
					),
					Parent = TextPanel,
				})
				table.insert(LinesHolder, Lbl)
				table.insert(CardObj.TextLabels, Lbl)
			end
		end
		CardObj:Relayout()
	end

	local BindConn = nil

	function CardObj:BindLabel(Source)
		if BindConn then
			BindConn:Disconnect()
			BindConn = nil
		end
		if Source and pcall(function()
			return Source.Text
		end) then
			BindMirror.Visible = true
			BindMirror.Text = tostring(Source.Text)
			BindConn = Source:GetPropertyChangedSignal("Text"):Connect(function()
				BindMirror.Text = tostring(Source.Text)
			end)
		else
			BindMirror.Visible = false
			BindMirror.Text = ""
		end
		CardObj:Relayout()
	end

	local GradState = nil

	function CardObj:ApplyImageGradient()
		local Conf = CardObj.GradientConf or Env.Library.CardGradient
		ImageGrad.Enabled = Conf.Enabled
		if not Conf.Enabled then
			ImagePanel.BackgroundColor3 = Env.Library.Scheme.MainColor
			if GradState then
				GradState.Dead = true
				GradState = nil
			end
			return
		end
		ImagePanel.BackgroundColor3 = Color3.new(1, 1, 1)
		local Target = TargetSequence(Conf)
		if not GradState then
			GradState = {
				Grad = ImageGrad,
				GetConf = function()
					return CardObj.GradientConf or Env.Library.CardGradient
				end,
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
			table.insert(Active, GradState)
			EnsureTicker()
		else
			GradState.Target = Target
			GradState.BlendT = 0
		end
		ImageGrad.Color = TrueSequence(GradState.Current, GradState.Offset)
		ImageGrad.Rotation = Conf.Rotation + GradState.Spin
		if Conf.Preset == "Custom" then
			ImageGrad.Transparency = Presets.Solid
		else
			ImageGrad.Transparency = Presets.Transparency[Conf.Preset] or Presets.Solid
		end
	end

	function CardObj:SetImageGradient(Info)
		if typeof(Info) ~= "table" then
			return
		end
		if not CardObj.GradientConf then
			CardObj.GradientConf = table.clone(Env.Library.CardGradient)
		end
		local C = CardObj.GradientConf
		if typeof(Info.Enabled) == "boolean" then
			C.Enabled = Info.Enabled
		end
		if typeof(Info.Preset) == "string" then
			C.Preset = Info.Preset
		end
		if typeof(Info.Rotation) == "number" then
			C.Rotation = math.clamp(Info.Rotation, -360, 360)
		end
		if typeof(Info.OffsetSpeed) == "number" then
			C.OffsetSpeed = math.clamp(Info.OffsetSpeed, -4, 4)
		end
		if typeof(Info.RotationSpeed) == "number" then
			C.RotationSpeed = math.clamp(Info.RotationSpeed, -360, 360)
		end
		if typeof(Info.ColorTop) == "Color3" then
			C.ColorTop = Info.ColorTop
		end
		if typeof(Info.ColorMiddle) == "Color3" then
			C.ColorMiddle = Info.ColorMiddle
		end
		if typeof(Info.ColorBottom) == "Color3" then
			C.ColorBottom = Info.ColorBottom
		end
		CardObj:ApplyImageGradient()
	end

	function CardObj:ClearImageGradient()
		CardObj.GradientConf = nil
		CardObj:ApplyImageGradient()
	end

	local CurSpinAngle = 0
	game:GetService("RunService").RenderStepped:Connect(function(dt)
		local petModel = World3D:FindFirstChildWhichIsA("Model") or World3D:FindFirstChildWhichIsA("BasePart")
		if Viewport3D.Visible and petModel then
			CurSpinAngle = (CurSpinAngle + dt * 45) % 360
			local cf, size
			if petModel:IsA("Model") then
				cf, size = petModel:GetBoundingBox()
			else
				cf, size = petModel.CFrame, petModel.Size
			end
			local maxDim = math.max(size.X, size.Y, size.Z)
			local dist = maxDim / (2 * math.tan(math.rad(Cam3D.FieldOfView / 2))) * 1.35
			local rad = math.rad(CurSpinAngle)
			Cam3D.CFrame = CFrame.new(
				cf.Position + Vector3.new(math.sin(rad) * dist, dist * 0.25, math.cos(rad) * dist),
				cf.Position
			)
		end
	end)

	function CardObj:SetData(titleText, descText, imageAsset, modelSource)
		if titleText then
			TitleLabel.Text = titleText
		end
		if descText then
			DescLabel.Text = descText
		end
		if (titleText or descText) and not CardObj.NoTextLocked then
			CardObj.HasText = true
		end

		if modelSource then
			World3D:ClearAllChildren()
			local clone = modelSource:Clone()
			for _, desc in ipairs(clone:GetDescendants()) do
				if desc:IsA("BasePart") then
					desc.Anchored = true
					desc.CanCollide = false
				end
				if desc:IsA("LuaSourceContainer") or desc:IsA("Sound") then
					desc:Destroy()
				end
			end
			if clone:IsA("BasePart") then
				clone.Anchored = true
			end
			clone.Parent = World3D

			Viewport3D.Visible = true
			IconImg.Visible = false
		else
			Viewport3D.Visible = false
			IconImg.Visible = true
			if imageAsset and imageAsset ~= "" then
				IconImg.Image = imageAsset
			end
		end
		CardObj:Relayout()
	end

	if Info.Lines then
		CardObj:SetLines(Info.Lines)
	end
	if Info.BindLabel then
		CardObj:BindLabel(Info.BindLabel)
	end
	CardObj:Relayout()
	CardObj:ApplyImageGradient()

	table.insert(Env.Library.SpotlightCards, CardObj)
	Groupbox:Resize()
	table.insert(Groupbox.Elements, CardObj)
	if Idx then
		Env.Options[Idx] = CardObj
	end

	return CardObj
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
	table.insert(Active, St)
	EnsureTicker()
	return St
end

local function AttachDropshadow(Target, GetConf)
	local Conf = GetConf()
	local Radius = nil
	local SrcCorner = Target:FindFirstChildWhichIsA("UICorner")
	if SrcCorner then
		Radius = SrcCorner.CornerRadius
	end
	local Layers = {}
	for i = 1, SHADOW_LAYERS do
		local Inst = Target:Clone()
		Inst:ClearAllChildren()
		Inst.Name = "Dropshadow" .. i
		if Radius then
			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(Radius.Scale, Radius.Offset + i)
			Corner.Parent = Inst
		end
		Inst.BackgroundColor3 = Conf.Color
		Inst.BackgroundTransparency = 1
		Inst.ZIndex = Target.ZIndex - 1
		Inst.Size = Target.Size + UDim2.new(0, 2 * i, 0, 2 * i)
		Inst.Position = Target.Position + UDim2.new(0, -i, 0, Conf.Offset * (i / SHADOW_LAYERS) - i)
		Inst.Parent = Target.Parent
		table.insert(Layers, { Inst = Inst, Expand = i })
	end
	local St = {
		Layers = Layers,
		Target = Target,
		GetConf = GetConf,
		Color = Conf.Color,
		Trans = Conf.Transparency,
		Depth = Conf.Offset,
		Painted = false,
		Dead = false,
	}
	table.insert(ShadowActive, St)
	EnsureTicker()
	return St
end

return {
	Presets = Presets,
	SampleSequence = EvalColorSequence,
	AttachGradient = AttachGradient,
	AttachDropshadow = AttachDropshadow,
	AddViewport = AddViewport,
	AddSpotlightCard = AddSpotlightCard,
}

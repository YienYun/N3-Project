local function C3(r, g, b)
	return Color3.new(r, g, b)
end

local Presets = {
	Order = { "Custom", "Gold", "Silver", "Chrome", "Rainbow", "Neon", "Sunset", "Oceanic", "Lava" },
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
	},
}

--// GENERIC 3D VIEWPORT COMPONENT (RICH ORBIT + MANUAL DRAG)
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

	function CardObj:ApplyImageGradient()
		local Conf = CardObj.GradientConf or Env.Library.CardGradient
		ImageGrad.Enabled = Conf.Enabled
		if not Conf.Enabled then
			ImagePanel.BackgroundColor3 = Env.Library.Scheme.MainColor
			return
		end
		ImagePanel.BackgroundColor3 = Color3.new(1, 1, 1)
		if Conf.Preset == "Custom" then
			ImageGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Conf.ColorTop),
				ColorSequenceKeypoint.new(0.5, Conf.ColorMiddle),
				ColorSequenceKeypoint.new(1, Conf.ColorBottom),
			})
		else
			ImageGrad.Color = Presets.Sequence[Conf.Preset] or Presets.Sequence.Gold
		end
		ImageGrad.Rotation = Conf.Rotation
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

return {
	Presets = Presets,
	AddViewport = AddViewport,
	AddSpotlightCard = AddSpotlightCard,
}

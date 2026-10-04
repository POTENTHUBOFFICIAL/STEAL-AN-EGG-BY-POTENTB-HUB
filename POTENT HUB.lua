-- ============================================================
-- POTENT HUB - SIMPLE UI (TABBED) - SOLO COMBAT + FARM
-- Solo se ejecuta en el PlaceId 107778070777162 (Steal An Egg)
-- ============================================================

local PLACE_ID = 107778070777162

if game.PlaceId ~= PLACE_ID then
	return
end

if not shared then shared = {} end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local CONFIG = {
	LogoId = "117299981730743",
	Window = { Width = 340, Height = 260 },
}

local Base = {
	Bg       = Color3.fromRGB(15, 16, 22),
	BgTop    = Color3.fromRGB(22, 23, 32),
	Panel    = Color3.fromRGB(26, 27, 36),
	PanelHov = Color3.fromRGB(38, 39, 52),
	Stroke   = Color3.fromRGB(54, 55, 72),
	Text     = Color3.fromRGB(240, 240, 245),
	TextDim  = Color3.fromRGB(150, 152, 168),
	On       = Color3.fromRGB(0, 200, 110),
	Off      = Color3.fromRGB(58, 58, 72),
	Good     = Color3.fromRGB(0, 210, 110),
	Bad      = Color3.fromRGB(230, 70, 70),
}

local THEMES = {
	{ name = "Gold",        a1 = Color3.fromRGB(255, 200, 50),  a2 = Color3.fromRGB(255, 140, 20),  a3 = Color3.fromRGB(255, 240, 120) },
	{ name = "Neon Purple", a1 = Color3.fromRGB(168, 85, 247),  a2 = Color3.fromRGB(236, 72, 153),  a3 = Color3.fromRGB(99, 102, 241)  },
	{ name = "Cyan",        a1 = Color3.fromRGB(34, 211, 238),  a2 = Color3.fromRGB(59, 130, 246),  a3 = Color3.fromRGB(125, 211, 252) },
	{ name = "Emerald",     a1 = Color3.fromRGB(16, 185, 129),  a2 = Color3.fromRGB(34, 197, 94),   a3 = Color3.fromRGB(163, 230, 53)  },
	{ name = "Crimson",     a1 = Color3.fromRGB(239, 68, 68),   a2 = Color3.fromRGB(249, 115, 22),  a3 = Color3.fromRGB(244, 63, 94)   },
	{ name = "Ocean",       a1 = Color3.fromRGB(56, 189, 248),  a2 = Color3.fromRGB(45, 212, 191),  a3 = Color3.fromRGB(59, 130, 246)  },
}

local currentTheme = 1
local alive = true
local Unloaders = {}
local Themed = {}

local function buildSequence(t)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, t.a1),
		ColorSequenceKeypoint.new(0.50, t.a2),
		ColorSequenceKeypoint.new(1.00, t.a3),
	})
end

local BrandColor = buildSequence(THEMES[currentTheme])
local function accentColor() return THEMES[currentTheme].a1 end

local function bindTheme(fn)
	table.insert(Themed, fn)
	pcall(fn, THEMES[currentTheme])
end

local function onUnload(fn) table.insert(Unloaders, fn) end

local getHui = gethui or function() return CoreGui end

local function mountGui(g)
	local ok = pcall(function() g.Parent = getHui() end)
	if not ok then
		local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
		g.Parent = pg
	end
end

local spinning = {}
local function makeSpin(g, s)
	table.insert(spinning, { g = g, s = s })
end

local spinConn = RunService.RenderStepped:Connect(function(dt)
	for i = #spinning, 1, -1 do
		local it = spinning[i]
		if it.g and it.g.Parent then
			it.g.Rotation = (it.g.Rotation + it.s * dt) % 360
		else
			table.remove(spinning, i)
		end
	end
end)
onUnload(function() spinConn:Disconnect() end)

local function cleanup()
	local containers = {}
	pcall(function() table.insert(containers, getHui()) end)
	pcall(function() table.insert(containers, CoreGui) end)
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if pg then table.insert(containers, pg) end

	local junk = {
		"PotentSimpleUI", "PotentUnsupported", "PotentKeySystem",
		"WindUI", "POTENTHUB", "Footagesus",
		"WzeusHubScreen", "WzeusESPFolder", "PotentESPFolder",
		"RENHUBGui", "LevonHubGui",
	}

	for _, c in ipairs(containers) do
		if c then
			for _, child in ipairs(c:GetChildren()) do
				if child:IsA("ScreenGui") or child:IsA("Folder") then
					for _, name in ipairs(junk) do
						if child.Name == name or child.Name:find(name, 1, true) then
							pcall(function() child:Destroy() end)
							break
						end
					end
				end
			end
		end
	end
end

pcall(cleanup)

local gui = Instance.new("ScreenGui")
gui.Name = "PotentSimpleUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
mountGui(gui)

local function corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Color = color
	s.Thickness = thickness or 1
	s.Parent = parent
	return s
end

local function panelGradient(parent)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Base.PanelHov),
		ColorSequenceKeypoint.new(1, Base.Panel),
	})
	g.Rotation = 90
	g.Parent = parent
	return g
end

local WHITE = Color3.fromRGB(255, 255, 255)

local function makeDraggable(handle, target, scaleObj, threshold)
	local state = { Moved = false }
	local dragging, startMouse, startPos = false, nil, nil

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			state.Moved = false
			startMouse = Vector2.new(input.Position.X, input.Position.Y)
			startPos = target.Position
		end
	end)

	local c1 = UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local sc = scaleObj and scaleObj.Scale or 1
		local d = (Vector2.new(input.Position.X, input.Position.Y) - startMouse) / sc
		if d.Magnitude > (threshold or 0) then state.Moved = true end
		if state.Moved then
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)

	local c2 = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	onUnload(function() c1:Disconnect() c2:Disconnect() end)
	return state
end

local win = Instance.new("Frame")
win.Name = "Main"
win.Size = UDim2.fromOffset(CONFIG.Window.Width, CONFIG.Window.Height)
win.Position = UDim2.fromOffset(20, 20)
win.BackgroundColor3 = Base.Bg
win.BorderSizePixel = 0
win.Active = true
win.ZIndex = 2
win.Parent = gui

local uiscale = Instance.new("UIScale")
uiscale.Scale = 1
uiscale.Parent = win

corner(win, 12)

do
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Base.BgTop),
		ColorSequenceKeypoint.new(1, Base.Bg),
	})
	g.Rotation = 90
	g.Parent = win

	local s = stroke(win, accentColor(), 1.4)
	s.Transparency = 0.1
	local sg = Instance.new("UIGradient")
	sg.Color = BrandColor
	sg.Parent = s
	makeSpin(sg, 55)
	bindTheme(function(t) s.Color = t.a1 sg.Color = BrandColor end)
end

local HEADER_H = 52

do
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, HEADER_H)
	header.BackgroundTransparency = 1
	header.Active = true
	header.ZIndex = 3
	header.Parent = win

	makeDraggable(header, win, uiscale, 0)

	local logoFrame = Instance.new("Frame")
	logoFrame.Size = UDim2.fromOffset(34, 34)
	logoFrame.Position = UDim2.new(0, 12, 0.5, -17)
	logoFrame.BackgroundTransparency = 1
	logoFrame.ZIndex = 4
	logoFrame.Parent = header

	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromScale(1, 1)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://" .. CONFIG.LogoId
	logo.ZIndex = 4
	logo.Parent = logoFrame
	corner(logo, 17)

	task.spawn(function()
		while alive and logo.Parent do
			local s = math.sin(tick() * 2) * 0.04
			logo.Size = UDim2.new(1 + s, 0, 1 + s, 0)
			logo.Position = UDim2.new(-s / 2, 0, -s / 2, 0)
			RunService.RenderStepped:Wait()
		end
	end)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -60, 0, 18)
	title.Position = UDim2.new(0, 54, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "POTENT HUB"
	title.TextColor3 = WHITE
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 4
	title.Parent = header

	local tg = Instance.new("UIGradient")
	tg.Color = BrandColor
	tg.Parent = title
	makeSpin(tg, 45)
	bindTheme(function() tg.Color = BrandColor end)

	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, -60, 0, 12)
	subtitle.Position = UDim2.new(0, 54, 0, 28)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Steal An Egg"
	subtitle.TextColor3 = Base.TextDim
	subtitle.Font = Enum.Font.GothamMedium
	subtitle.TextSize = 10
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.ZIndex = 4
	subtitle.Parent = header

	local sep = Instance.new("Frame")
	sep.Size = UDim2.new(1, -20, 0, 1)
	sep.Position = UDim2.new(0, 10, 0, HEADER_H)
	sep.BackgroundColor3 = WHITE
	sep.BorderSizePixel = 0
	sep.ZIndex = 3
	sep.Parent = win

	local sg = Instance.new("UIGradient")
	sg.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	sg.Color = BrandColor
	sg.Parent = sep
	bindTheme(function() sg.Color = BrandColor end)
end

local tabBarScroll = Instance.new("ScrollingFrame")
tabBarScroll.Size = UDim2.new(1, -20, 0, 28)
tabBarScroll.Position = UDim2.new(0, 10, 0, HEADER_H + 6)
tabBarScroll.BackgroundTransparency = 1
tabBarScroll.BorderSizePixel = 0
tabBarScroll.ScrollBarThickness = 0
tabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
tabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
tabBarScroll.ZIndex = 3
tabBarScroll.Parent = win

do
	local l = Instance.new("UIListLayout")
	l.FillDirection = Enum.FillDirection.Horizontal
	l.Padding = UDim.new(0, 4)
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Parent = tabBarScroll
end

local tabsContainer = Instance.new("Frame")
tabsContainer.Size = UDim2.new(1, -20, 1, -HEADER_H - 46)
tabsContainer.Position = UDim2.new(0, 10, 0, HEADER_H + 40)
tabsContainer.BackgroundTransparency = 1
tabsContainer.ClipsDescendants = true
tabsContainer.ZIndex = 3
tabsContainer.Parent = win

local pages = {}
local tabButtons = {}
local activeTab = nil

local function selectTab(name)
	for tabName, page in pairs(pages) do
		page.Visible = (tabName == name)
	end
	local ti = TweenInfo.new(0.2)
	for tabName, b in pairs(tabButtons) do
		local on = (tabName == name)
		TweenService:Create(b.btn, ti, {
			BackgroundColor3 = on and Base.PanelHov or Base.Panel,
			TextColor3 = on and WHITE or Base.TextDim,
		}):Play()
		TweenService:Create(b.stroke, ti, { Color = on and accentColor() or Base.Stroke }):Play()
		b.ind.Visible = on
	end
	activeTab = name
end

local function createTab(name, width)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(width or 62, 28)
	btn.BackgroundColor3 = Base.Panel
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = Base.TextDim
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.ZIndex = 4
	btn.Parent = tabBarScroll
	corner(btn, 7)
	local s = stroke(btn, Base.Stroke, 1)

	local ind = Instance.new("Frame")
	ind.Size = UDim2.new(1, -14, 0, 2)
	ind.Position = UDim2.new(0, 7, 1, -4)
	ind.BackgroundColor3 = WHITE
	ind.BorderSizePixel = 0
	ind.Visible = false
	ind.ZIndex = 5
	ind.Parent = btn
	corner(ind, 2)
	local ig = Instance.new("UIGradient")
	ig.Color = BrandColor
	ig.Parent = ind
	bindTheme(function() ig.Color = BrandColor end)

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = accentColor()
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.ZIndex = 3
	page.Parent = tabsContainer
	bindTheme(function(t) page.ScrollBarImageColor3 = t.a1 end)

	local pl = Instance.new("UIListLayout")
	pl.SortOrder = Enum.SortOrder.LayoutOrder
	pl.Padding = UDim.new(0, 4)
	pl.Parent = page

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 2)
	pad.PaddingBottom = UDim.new(0, 6)
	pad.PaddingLeft = UDim.new(0, 1)
	pad.PaddingRight = UDim.new(0, 6)
	pad.Parent = page

	btn.Activated:Connect(function() selectTab(name) end)
	btn.MouseEnter:Connect(function()
		if activeTab ~= name then
			TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Base.PanelHov }):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if activeTab ~= name then
			TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Base.Panel }):Play()
		end
	end)

	tabButtons[name] = { btn = btn, stroke = s, ind = ind }
	pages[name] = page
	return page
end

local toastHolder = Instance.new("Frame")
toastHolder.AnchorPoint = Vector2.new(1, 1)
toastHolder.Size = UDim2.new(0, 240, 1, -32)
toastHolder.Position = UDim2.new(1, -12, 1, -12)
toastHolder.BackgroundTransparency = 1
toastHolder.ZIndex = 6000
toastHolder.Parent = gui

do
	local l = Instance.new("UIListLayout")
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Padding = UDim.new(0, 5)
	l.FillDirection = Enum.FillDirection.Vertical
	l.VerticalAlignment = Enum.VerticalAlignment.Bottom
	l.HorizontalAlignment = Enum.HorizontalAlignment.Right
	l.Parent = toastHolder
end

local toastOrder = 0
local function toast(text, color)
	if not toastHolder.Parent then return end
	color = color or accentColor()

	local kids = toastHolder:GetChildren()
	local count = 0
	for _, k in ipairs(kids) do if k:IsA("Frame") then count += 1 end end
	if count >= 5 then
		for _, k in ipairs(kids) do
			if k:IsA("Frame") then k:Destroy() break end
		end
	end

	toastOrder += 1
	local slot = Instance.new("Frame")
	slot.Size = UDim2.new(1, 0, 0, 36)
	slot.BackgroundTransparency = 1
	slot.LayoutOrder = toastOrder
	slot.ZIndex = 6001
	slot.Parent = toastHolder

	local t = Instance.new("Frame")
	t.Size = UDim2.fromScale(1, 1)
	t.Position = UDim2.new(1.3, 0, 0, 0)
	t.BackgroundColor3 = Base.Panel
	t.BorderSizePixel = 0
	t.ZIndex = 6002
	t.Parent = slot
	corner(t, 7)
	panelGradient(t)
	stroke(t, color, 1.1)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 3, 1, -10)
	bar.Position = UDim2.new(0, 5, 0, 5)
	bar.BackgroundColor3 = color
	bar.BorderSizePixel = 0
	bar.ZIndex = 6003
	bar.Parent = t
	corner(bar, 2)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -22, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Base.Text
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextWrapped = true
	lbl.ZIndex = 6003
	lbl.Parent = t

	TweenService:Create(t, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0),
	}):Play()

	task.delay(3, function()
		if not slot.Parent then return end
		local out = TweenService:Create(t, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1.3, 0, 0, 0),
		})
		out:Play()
		out.Completed:Wait()
		slot:Destroy()
	end)
end

local function toggleToast(name, state)
	toast(name .. (state and " enabled" or " disabled"), state and Base.Good or Base.Bad)
end

local function createSection(parent, label)
	local sec = Instance.new("TextLabel")
	sec.Size = UDim2.new(1, 0, 0, 16)
	sec.BackgroundTransparency = 1
	sec.Text = label:upper()
	sec.TextColor3 = accentColor()
	sec.Font = Enum.Font.GothamBold
	sec.TextSize = 10
	sec.TextXAlignment = Enum.TextXAlignment.Left
	sec.ZIndex = 4
	sec.Parent = parent
	bindTheme(function(t) sec.TextColor3 = t.a1 end)

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 4)
	pad.Parent = sec
	return sec
end

local function toggleRow(parent, label)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 34)
	row.BackgroundColor3 = Base.Panel
	row.BorderSizePixel = 0
	row.ZIndex = 4
	row.Parent = parent
	corner(row, 7)
	panelGradient(row)
	local rs = stroke(row, Base.Stroke, 1)

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -60, 1, 0)
	txt.Position = UDim2.fromOffset(12, 0)
	txt.BackgroundTransparency = 1
	txt.Text = label
	txt.TextColor3 = Base.Text
	txt.Font = Enum.Font.GothamSemibold
	txt.TextSize = 12
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.ZIndex = 5
	txt.Parent = row

	local track = Instance.new("TextButton")
	track.Size = UDim2.fromOffset(40, 20)
	track.Position = UDim2.new(1, -50, 0.5, -10)
	track.BackgroundColor3 = Base.Off
	track.BorderSizePixel = 0
	track.Text = ""
	track.AutoButtonColor = false
	track.ZIndex = 5
	track.Parent = row
	corner(track, 10)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(14, 14)
	dot.Position = UDim2.fromOffset(3, 3)
	dot.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
	dot.BorderSizePixel = 0
	dot.ZIndex = 6
	dot.Parent = track
	corner(dot, 7)

	return row, track, dot, rs
end

local function setToggle(track, dot, strokeObj, state)
	local ti = TweenInfo.new(0.18)
	if state then
		TweenService:Create(track, ti, { BackgroundColor3 = Base.On }):Play()
		TweenService:Create(dot, ti, { Position = UDim2.new(1, -17, 0, 3) }):Play()
		TweenService:Create(strokeObj, ti, { Color = Base.On }):Play()
	else
		TweenService:Create(track, ti, { BackgroundColor3 = Base.Off }):Play()
		TweenService:Create(dot, ti, { Position = UDim2.fromOffset(3, 3) }):Play()
		TweenService:Create(strokeObj, ti, { Color = Base.Stroke }):Play()
	end
end

local function addToggle(parent, label, default, callback)
	local _, track, dot, rs = toggleRow(parent, label)
	local state = default and true or false
	if state then setToggle(track, dot, rs, true) end
	track.Activated:Connect(function()
		state = not state
		setToggle(track, dot, rs, state)
		callback(state)
	end)
	return {
		Set = function(v)
			state = v and true or false
			setToggle(track, dot, rs, state)
		end,
	}
end

local function getChar()
	local char = LocalPlayer.Character
	return char, char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildWhichIsA("Humanoid")
end

-- ============================================================
-- TAB: COMBAT
-- ============================================================
do
	local combatPage = createTab("Combat", 62)
	createSection(combatPage, "Protection")

	local antiHit = false
	local promptBusy = false

	local TP_PATH = {
		Vector3.new(500.62, 241.28, -366.64),
		Vector3.new(504.45, 155.80, -366.35),
		Vector3.new(508.30,  70.28, -366.03),
		Vector3.new(513.86,  70.28, -366.25),
		Vector3.new(519.43,  70.28, -366.47),
		Vector3.new(524.32,  70.28, -366.59),
		Vector3.new(529.22,  70.28, -366.71),
		Vector3.new(538.01,  70.28, -365.55),
		Vector3.new(546.80,  70.28, -364.40),
	}

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
	overlay.BackgroundTransparency = 1
	overlay.Visible = false
	overlay.ZIndex = 4000
	overlay.Parent = gui

	local overlayTitle = Instance.new("TextLabel")
	overlayTitle.AnchorPoint = Vector2.new(0.5, 0)
	overlayTitle.Position = UDim2.new(0.5, 0, 0.52, 8)
	overlayTitle.Size = UDim2.fromOffset(300, 26)
	overlayTitle.BackgroundTransparency = 1
	overlayTitle.Text = "POTENT HUB loading..."
	overlayTitle.TextColor3 = WHITE
	overlayTitle.Font = Enum.Font.GothamBold
	overlayTitle.TextSize = 15
	overlayTitle.ZIndex = 4001
	overlayTitle.Parent = overlay

	local barBg = Instance.new("Frame")
	barBg.AnchorPoint = Vector2.new(0.5, 0)
	barBg.Position = UDim2.new(0.5, 0, 0.58, 10)
	barBg.Size = UDim2.fromOffset(200, 4)
	barBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 4001
	barBg.Parent = overlay
	corner(barBg, 2)

	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = WHITE
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 4002
	barFill.Parent = barBg
	corner(barFill, 2)

	local barGrad = Instance.new("UIGradient")
	barGrad.Color = BrandColor
	barGrad.Parent = barFill
	bindTheme(function() barGrad.Color = BrandColor end)

	local function resetOverlay()
		overlay.Visible = false
		overlay.BackgroundTransparency = 1
		barFill.Size = UDim2.new(0, 0, 1, 0)
		overlayTitle.Text = "POTENT HUB loading..."
	end

	local function runTP(character)
		if not antiHit or not character then return end
		if not character.Parent then return end

		overlay.Visible = true
		overlay.BackgroundTransparency = 0
		barFill.Size = UDim2.new(0, 0, 1, 0)
		overlayTitle.Text = "POTENT HUB loading..."

		local total = #TP_PATH
		for i, pos in ipairs(TP_PATH) do
			TweenService:Create(
				barFill,
				TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Size = UDim2.new(i / total, 0, 1, 0) }
			):Play()
			character:PivotTo(CFrame.new(pos))
			RunService.Heartbeat:Wait()
		end

		overlayTitle.Text = "POTENT HUB loaded!"
		task.wait(0.25)

		local fin = TweenService:Create(
			barFill,
			TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Size = UDim2.new(1, 0, 1, 0) }
		)
		fin:Play()
		fin.Completed:Wait()

		resetOverlay()
	end

	local promptConn = ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
		if player ~= LocalPlayer then return end
		if not antiHit or promptBusy then return end

		local char = LocalPlayer.Character
		if not char then return end

		promptBusy = true
		local ok = pcall(runTP, char)
		promptBusy = false
		if not ok then resetOverlay() end
	end)
	onUnload(function() promptConn:Disconnect() end)

	addToggle(combatPage, "Anti-Hit", false, function(s)
		antiHit = s
		toggleToast("Anti-Hit", s)
	end)

	local instantOn = false
	local RANGE = 15
	local prompts = setmetatable({}, { __mode = "k" })

	task.spawn(function()
		for _, d in ipairs(Workspace:GetDescendants()) do
			if d:IsA("ProximityPrompt") then prompts[d] = true end
		end
	end)
	local addC = Workspace.DescendantAdded:Connect(function(d)
		if d:IsA("ProximityPrompt") then prompts[d] = true end
	end)
	onUnload(function() addC:Disconnect() end)

	local function promptPart(p)
		local par = p.Parent
		if not par then return nil end
		if par:IsA("BasePart") then return par end
		if par:IsA("Attachment") then return par.Parent end
		if par:IsA("Model") then return par.PrimaryPart or par:FindFirstChildWhichIsA("BasePart") end
		return nil
	end

	local function promptPos(p)
		local par = p.Parent
		if not par then return nil end
		if par:IsA("Attachment") then return par.WorldPosition end
		local part = promptPart(p)
		return part and part.Position or nil
	end

	local function nearPlayer(p)
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return false end
		local pos = promptPos(p)
		if not pos then return false end
		return (pos - hrp.Position).Magnitude <= RANGE
	end

	local function visibleToPlayer(p)
		local cam = Workspace.CurrentCamera
		if not cam then return false end
		local pos = promptPos(p)
		if not pos then return false end
		local sp, onScreen = cam:WorldToViewportPoint(pos)
		if not onScreen or sp.Z <= 0 then return false end

		local part = promptPart(p)
		if part then
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			local list = { part }
			if LocalPlayer.Character then table.insert(list, LocalPlayer.Character) end
			params.FilterDescendantsInstances = list
			local hit = Workspace:Raycast(cam.CFrame.Position, pos - cam.CFrame.Position, params)
			if hit then return false end
		end
		return true
	end

	local function makeInstant(p)
		if not p or not p.Parent then return end
		pcall(function()
			if p:GetAttribute("OriginalHoldDuration") == nil then
				p:SetAttribute("OriginalHoldDuration", p.HoldDuration)
				p:SetAttribute("OriginalMaxDist", p.MaxActivationDistance)
			end
			p.HoldDuration = 0
			p.MaxActivationDistance = math.huge
			p.Enabled = true
		end)
	end

	local function restorePrompts()
		for p in pairs(prompts) do
			pcall(function()
				local h = p:GetAttribute("OriginalHoldDuration")
				local m = p:GetAttribute("OriginalMaxDist")
				if h ~= nil then p.HoldDuration = h end
				if m ~= nil then p.MaxActivationDistance = m end
				p:SetAttribute("OriginalHoldDuration", nil)
				p:SetAttribute("OriginalMaxDist", nil)
			end)
		end
	end
	onUnload(restorePrompts)

	task.spawn(function()
		while alive do
			task.wait(0.35)
			if instantOn then
				for p in pairs(prompts) do
					if p.Parent and nearPlayer(p) and visibleToPlayer(p) then
						makeInstant(p)
					end
				end
			end
		end
	end)

	addToggle(combatPage, "Instant Prompt", false, function(s)
		instantOn = s
		if not s then restorePrompts() end
		toggleToast("Instant Prompt", s)
	end)
end

-- ============================================================
-- TAB: FARM
-- ============================================================
do
	local farmPage = createTab("Farm", 52)
	createSection(farmPage, "Treadmill")

	local treadmill = { Riding = false, Enabled = false, Staying = true }
	local treadmillConn = nil
	local cachedBelt, lastScan, requesting = nil, 0, false

	local function findBelt()
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then return nil end

		local plot = nil
		for _, child in ipairs(plots:GetChildren()) do
			local sign = child:FindFirstChild("PlotSign")
			sign = sign and sign:FindFirstChild("PlayerPlotSign")
			sign = sign and sign:FindFirstChild("Frame")
			sign = sign and sign:FindFirstChild("PlayerName")
			if sign and sign:IsA("TextLabel") then
				local t = string.lower(sign.Text)
				if t == string.lower(LocalPlayer.Name) or t == string.lower(LocalPlayer.DisplayName) then
					plot = child
					break
				end
			end
		end

		if not plot then return nil end
		return plot:FindFirstChild("TreadmillBottom") or plot:FindFirstChild("TreadmillUpgrade")
	end

	local function getBelt()
		if cachedBelt and cachedBelt.Parent then return cachedBelt end
		if os.clock() - lastScan < 1 then return nil end
		lastScan = os.clock()
		cachedBelt = findBelt()
		return cachedBelt
	end

	local function requestTreadmill()
		local net = ReplicatedStorage:FindFirstChild("Packages")
		net = net and net:FindFirstChild("Networking")
		local rf = net and net:FindFirstChild("RF/Treadmill/AskWearStill")
		if rf and rf:IsA("RemoteFunction") then
			local ok, res = pcall(function() return rf:InvokeServer() end)
			return ok and res ~= false
		end
		return false
	end

	local function stopTreadmill()
		if treadmillConn then treadmillConn:Disconnect() treadmillConn = nil end
	end
	onUnload(stopTreadmill)

	local function startTreadmillLoop()
		stopTreadmill()
		treadmillConn = RunService.Heartbeat:Connect(function()
			if not treadmill.Enabled then return end
			local _, root, hum = getChar()
			if not root or not hum then return end

			local belt = getBelt()
			if not belt or not belt:IsA("BasePart") then return end

			local target = belt.Position + Vector3.new(0, belt.Size.Y / 2 + 3, 0)
			local dist = (root.Position - target).Magnitude

			if dist > 5 then
				root.CFrame = CFrame.new(target)
			elseif treadmill.Staying then
				root.AssemblyLinearVelocity = Vector3.zero
				if not requesting then
					requesting = true
					task.spawn(function()
						treadmill.Riding = requestTreadmill()
						task.wait(0.2)
						requesting = false
					end)
				end
			end
		end)
	end

	addToggle(farmPage, "Auto Treadmill", false, function(s)
		treadmill.Enabled = s
		toggleToast("Auto Treadmill", s)
		if s then startTreadmillLoop() else stopTreadmill() end
	end)

	addToggle(farmPage, "Stay On Treadmill", true, function(s)
		treadmill.Staying = s
		toggleToast("Stay On Treadmill", s)
	end)
end

-- ============================================================
-- INIT
-- ============================================================
selectTab("Combat")

win.Position = UDim2.fromOffset(-380, 20)
TweenService:Create(win, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Position = UDim2.fromOffset(20, 20),
}):Play()

task.defer(function()
	toast("POTENT HUB loaded")
end)

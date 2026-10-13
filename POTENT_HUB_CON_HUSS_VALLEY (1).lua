-- Check for table that is shared between executions.
if not shared then
	return warn("No shared, no script.")
end

-- ============================================================
-- POTENT HUB - MULTI GAME HUB (WindUI v2.1 Edition)
-- 1. Speed Monkey Escape (114697347887839 / 72858062353423)
-- 2. Murder Mystery 2 (142823291)
-- 3. Kitten Farm (77813828595591)
-- 4. Speed Keyboard Escape (118941584817777 / 93411036959889)
-- 5. One Tap (90568084448279)
-- 6. Huss Valley (107535308163741)
-- ============================================================

local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local workspaceService = game:GetService("Workspace")
local collectionService = game:GetService("CollectionService")
local virtualUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")
local coreGui = game:GetService("CoreGui")
local httpService = game:GetService("HttpService")
local teleportService = game:GetService("TeleportService")
local guiService = game:GetService("GuiService")

local customRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local customGetHui = gethui or function() return coreGui end
local customSetClipboard = setclipboard or toclipboard or function(...) end
local customFireTouch = firetouchinterest or function() end
local customFireProximity = fireproximityprompt or function() end

local function customHttpGet(url)
	local ok, res = pcall(function()
		return game:HttpGet(url)
	end)
	if ok and res and res ~= "" then
		return res
	end

	if customRequest then
		local response = customRequest({ Url = url, Method = "GET" })
		if response and response.Body then return response.Body end
	end
	return ""
end

local function customHttpPost(url, body, contentType)
	if customRequest then
		return customRequest({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = contentType or "application/json" },
			Body = body,
		})
	end
	return nil
end

local SUPPORTED_PLACES = {
	[114697347887839] = true,
	[72858062353423]  = true,
	[142823291]       = true,
	[77813828595591]  = true,
	[118941584817777] = true,
	[93411036959889]  = true,
	[90568084448279]  = true,
	[107535308163741] = true, -- Huss Valley / Chicken or Hero
}

local ONETAP_PLACE_ID = 90568084448279

local DISCORD_URL = "https://discord.gg/X7Y4NzuC67"

local Palette = {
	Gold   = Color3.fromRGB(255, 200, 50),
	Purple = Color3.fromRGB(168, 85, 247),
	Blue   = Color3.fromRGB(59, 130, 246),
	Dark   = Color3.fromRGB(14, 14, 18),
}

local BrandGradient = ColorSequence.new({
	ColorSequenceKeypoint.new(0.0, Palette.Gold),
	ColorSequenceKeypoint.new(0.5, Palette.Purple),
	ColorSequenceKeypoint.new(1.0, Palette.Blue),
})

local BACKGROUND_ID = "72427773287138"
local LOGO_ID = "117299981730743"

local animGradients = {}
local visualApplied = false

local function spinGradient(gradient, speed)
	table.insert(animGradients, { g = gradient, s = speed or 40 })
end

runService.RenderStepped:Connect(function(dt)
		for i = #animGradients, 1, -1 do
			local element = animGradients[i]
			if element.g and element.g.Parent then
				element.g.Rotation = (element.g.Rotation + element.s * dt) % 360
			else
				table.remove(animGradients, i)
			end
		end
	end)

local function getGuiContainer()
	local ok, target = pcall(customGetHui)
	if ok and target then return target end
	local localPlayer = playersService.LocalPlayer
	local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
	if playerGui then return playerGui end
	return coreGui
end

local function findHubGui()
	local pools = {}
	pcall(function() table.insert(pools, customGetHui()) end)
	pcall(function() table.insert(pools, coreGui) end)
	local localPlayer = playersService.LocalPlayer
	local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
	if playerGui then table.insert(pools, playerGui) end

	for _, pool in ipairs(pools) do
		for _, gui in ipairs(pool:GetChildren()) do
			if gui:IsA("ScreenGui") then
				local guiName = gui.Name
				if guiName:find("WindUI") or guiName:find("POTENTHUB") or guiName:find("Footagesus") then
					return gui
				end
			end
		end
	end
end

local function findBackground(gui)
	for _, desc in ipairs(gui:GetDescendants()) do
		if desc:IsA("ImageLabel") and tostring(desc.Image):find(BACKGROUND_ID) then
			return desc
		end
	end
end

local function removeStrokes(root)
	if not root then return end
	for _, desc in ipairs(root:GetDescendants()) do
		if desc:IsA("UIStroke") then
			local parent = desc.Parent
			if parent and not parent.Name:find("Open") and not parent.Name:find("Float") then
				pcall(function() desc:Destroy() end)
			end
		elseif desc:IsA("Frame") and desc.Name:find("Outline") then
			pcall(function() desc:Destroy() end)
		elseif desc:IsA("ImageLabel") and (desc.Name:find("Outline") or desc.Name:find("Border")) then
			pcall(function() desc.Visible = false end)
		end
	end
end

local function applyVisuals()
	if visualApplied then return end
	local gui = findHubGui()
	if not gui then return end
	local bg = findBackground(gui)
	if not bg then return end
	visualApplied = true

	bg.ImageColor3 = Color3.fromRGB(120, 120, 140)
	bg.ImageTransparency = 0.35
	bg.ZIndex = 0

	local oldOverlay = bg:FindFirstChild("PotentDarkOverlay")
	if oldOverlay then oldOverlay:Destroy() end

	local overlay = Instance.new("Frame")
	overlay.Name = "PotentDarkOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 0
	overlay.Parent = bg

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = overlay

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.0, 0.35),
		NumberSequenceKeypoint.new(1.0, 0.05),
	})
	gradient.Rotation = 90
	gradient.Parent = overlay

	tweenService:Create(overlay, TweenInfo.new(0.6), { BackgroundTransparency = 0.25 }):Play()

	local container = bg.Parent or bg
	for _, desc in ipairs(container:GetDescendants()) do
		if desc ~= overlay and desc:IsA("GuiObject") and desc.ZIndex < 2 then
			pcall(function() desc.ZIndex = 2 end)
		end
	end

	container.DescendantAdded:Connect(function(desc)
		if desc:IsA("GuiObject") and desc ~= overlay and not desc:IsDescendantOf(overlay) then
			task.defer(function()
				if desc.Parent and desc.ZIndex < 2 then
					pcall(function() desc.ZIndex = 2 end)
				end
			end)
		end
	end)

	task.defer(function()
		removeStrokes(container)
	end)
end

local function setupMinimizeAnimation()
	local gui = findHubGui()
	if not gui then return end
	local bg = findBackground(gui)
	if not bg then return end
	local container = bg.Parent or bg
	if not container or not container:IsA("GuiObject") then return end

	local minimizeBtn = nil
	for _, desc in ipairs(container:GetDescendants()) do
		if desc:IsA("TextButton") or desc:IsA("ImageButton") then
			local txt = (desc:IsA("TextButton") and desc.Text) or ""
			local name = desc.Name:lower()
			if txt == "–" or txt == "-" or txt == "—" or name:find("minimize") or name:find("min") then
				minimizeBtn = desc
				break
			end
		end
	end

	local openBtn = nil
	for _, desc in ipairs(gui:GetDescendants()) do
		if (desc:IsA("TextButton") or desc:IsA("ImageButton")) and desc.Name:find("Open") then
			openBtn = desc
			break
		end
	end

	local origPos = container.Position
	local origSize = container.Size

	local function minimize()
		local targetPos = UDim2.new(origPos.X.Scale, origPos.X.Offset, origPos.Y.Scale, origPos.Y.Offset + 40)
		tweenService:Create(container, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 60, 0, 60),
			Position = targetPos,
			BackgroundTransparency = 0.3,
		}):Play()
		task.wait(0.4)
		tweenService:Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 0, 0, 0),
		}):Play()
		task.wait(0.3)
		container.Visible = false
	end

	local function restore()
		container.Visible = true
		container.Size = UDim2.new(0, 60, 0, 60)
		container.Position = origPos
		container.BackgroundTransparency = 0
		tweenService:Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 100, 0, 100),
		}):Play()
		task.wait(0.15)
		tweenService:Create(container, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = origSize,
			Position = origPos,
		}):Play()
	end

	if minimizeBtn then
		pcall(function()
			minimizeBtn.MouseButton1Click:Connect(function() minimize() end)
		end)
	end

	if openBtn then
		pcall(function()
			openBtn.MouseButton1Click:Connect(function()
				task.wait(0.05)
				restore()
			end)
		end)
	end
end

local function getWindUILibrary()
	local rawCode = customHttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
	if rawCode == "" then
		rawCode = customHttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
	end
	local windUI = loadstring(rawCode)()

	pcall(function()
		windUI:AddTheme({
			Name        = "PotentGold",
			Accent      = Palette.Gold,
			Outline     = Color3.fromRGB(255, 180, 40),
			Text        = Color3.fromRGB(255, 255, 255),
			Placeholder = Color3.fromRGB(175, 175, 190),
			Background  = Palette.Dark,
			Button      = Color3.fromRGB(32, 32, 40),
			Icon        = Color3.fromRGB(255, 205, 70),
		})
		windUI:SetTheme("PotentGold")
	end)

	return windUI
end

local function createPotentWindow(windUI, folder, gameName)
	visualApplied = false

	local window = windUI:CreateWindow({
		Title = "⚡ POTENT HUB",
		Icon = "rbxassetid://" .. LOGO_ID,
		Author = gameName or "👑 MADE BY POTENT HUB",
		Folder = folder,
		Background = "rbxassetid://" .. BACKGROUND_ID,
		Size = UDim2.fromOffset(640, 490),
		MinSize = Vector2.new(440, 340),
		Resizable = true,
		Transparent = false,
		Theme = "PotentGold",
		User = { Enabled = true, Anonymous = false },
		OpenButton = {
			Title = "POTENT HUB",
			Icon = "rbxassetid://" .. LOGO_ID,
			CornerRadius = UDim.new(0, 16),
			StrokeThickness = 2,
			Color = BrandGradient,
			OnlyMobile = false,
			Enabled = true,
			Draggable = true,
		},
	})

	pcall(function()
		window:Tag({ Title = "v2.1", Icon = "terminal", Color = Palette.Gold })
	end)

	task.spawn(function()
		for _ = 1, 20 do
			pcall(applyVisuals)
			if visualApplied then
				task.wait(0.3)
				pcall(setupMinimizeAnimation)
				pcall(removeStrokes, findHubGui())
				break
			end
			task.wait(0.2)
		end
	end)

	task.spawn(function()
		task.wait(1)
		pcall(function()
			local gui = findHubGui()
			if not gui then return end
			for _, desc in ipairs(gui:GetDescendants()) do
				if desc:IsA("UIStroke") then
					local grad = desc:FindFirstChildOfClass("UIGradient")
					if grad then spinGradient(grad, 70) end
				end
			end
		end)
	end)

	return window
end

-- ============================================================
-- ========== UNSUPPORTED SCREEN ==========
-- ============================================================
local function showUnsupportedScreen()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PotentUnsupported"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 9999
	screenGui.IgnoreGuiInset = true

	local ok = pcall(function() screenGui.Parent = getGuiContainer() end)
	if not ok then screenGui.Parent = playersService.LocalPlayer:WaitForChild("PlayerGui") end

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.new(0, 0, 0)
	bg.BorderSizePixel = 0
	bg.ZIndex = 1
	bg.Parent = screenGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 520, 0, 320)
	main.Position = UDim2.new(0.5, -260, 0.5, -160)
	main.BackgroundTransparency = 1
	main.ZIndex = 2
	main.Parent = screenGui

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -40, 0, 140)
	label.Position = UDim2.new(0, 20, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "THIS GAME IS NOT COMPATIBLE\nIF YOU WANT TO KNOW WHICH GAMES IT SUPPORTS, JOIN THE DISCORD SERVER"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 22
	label.TextWrapped = true
	label.ZIndex = 3
	label.Parent = main

	local supportLabel = Instance.new("TextLabel")
	supportLabel.Size = UDim2.new(1, -40, 0, 60)
	supportLabel.Position = UDim2.new(0, 20, 0, 145)
	supportLabel.BackgroundTransparency = 1
	supportLabel.Text = "🟢 Support:\nSpeed Monkey Escape, Murder Mystery 2, Kitten Farm, Speed Keyboard Escape, One Tap"
	supportLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
	supportLabel.Font = Enum.Font.GothamBold
	supportLabel.TextSize = 13
	supportLabel.TextWrapped = true
	supportLabel.ZIndex = 3
	supportLabel.Parent = main

	local discordBtn = Instance.new("TextButton")
	discordBtn.Size = UDim2.new(0, 320, 0, 50)
	discordBtn.Position = UDim2.new(0.5, -160, 0, 215)
	discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	discordBtn.BorderSizePixel = 0
	discordBtn.Text = "💬 JOIN POTENT HUB DISCORD"
	discordBtn.TextColor3 = Color3.new(1, 1, 1)
	discordBtn.Font = Enum.Font.GothamBold
	discordBtn.TextSize = 14
	discordBtn.AutoButtonColor = false
	discordBtn.ZIndex = 3
	discordBtn.Parent = main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = discordBtn

	local status = Instance.new("TextLabel")
	status.Size = UDim2.new(1, -40, 0, 20)
	status.Position = UDim2.new(0, 20, 0, 275)
	status.BackgroundTransparency = 1
	status.Text = ""
	status.TextColor3 = Color3.fromRGB(0, 200, 100)
	status.Font = Enum.Font.GothamBold
	status.TextSize = 12
	status.ZIndex = 3
	status.Parent = main

	discordBtn.MouseButton1Click:Connect(function()
		customSetClipboard(DISCORD_URL)
		status.Text = "✅ DISCORD LINK COPIED!"
		task.delay(5, function() if status and status.Parent then status.Text = "" end end)
	end)

	task.delay(15, function() if screenGui and screenGui.Parent then screenGui:Destroy() end end)
	return screenGui
end

-- ============================================================
-- ========== JUEGO 1: SPEED MONKEY ESCAPE ==========
-- ============================================================
local function runSpeedMonkeyEscape()
	local Remotes = replicatedStorage:WaitForChild("Remotes", 10)
	local LocalPlayer = playersService.LocalPlayer
	local Data = LocalPlayer:WaitForChild("Data", 10)
	local GameName = "+1 Speed Monkey Escape"
	pcall(function() GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

	local WindUI = getWindUILibrary()
	local window = createPotentWindow(WindUI, "POTENTHUB_SPEED_MONKEY", GameName)

	local UpgradesCfg = {
		{WinsRequirement=0, Multi=1, Skin="Basic"},
		{Multi=2, Skin="Grey", WinsRequirement=3},
		{Multi=4, Skin="Tiger", WinsRequirement=15},
		{Multi=8, Skin="Curly", WinsRequirement=100},
		{Multi=16, Skin="Rainbow", WinsRequirement=500},
		{Multi=32, Skin="Golden", WinsRequirement=2500},
		{Multi=64, Skin="Magma", WinsRequirement=15000},
		{Multi=128, Skin="Frozen", WinsRequirement=50000},
		{Multi=256, Skin="Devil", WinsRequirement=250000},
		{Multi=512, Skin="Night", WinsRequirement=1000000},
		{Multi=1000, Skin="Inferno", WinsRequirement=1000000},
		{Multi=2000, Skin="Verdant", WinsRequirement=5000000},
		{Multi=4000, Skin="Abyss", WinsRequirement=25000000},
		{Multi=8000, Skin="Arcane", WinsRequirement=100000000},
		{Multi=16000, Skin="Divine", WinsRequirement=500000000},
		{Multi=32000, Skin="Crimson", WinsRequirement=3000000000},
	}
	local TreadmillCfg = {Multis = {Reward=1.5, Golden=3, Diamond=9, Galaxy=25, Emerald=100, Void=100, Celestial=1000, Sunken=2, Quantum=10, Basic=1}}
	local TeleportPositions = {
		World1 = {Normal = Vector3.new(-9458.70, 389.70, -256.30), VIP = Vector3.new(-9457.38, 388.69, -187.92)},
		World2 = {Normal = Vector3.new(-3607.87, 155.87, -9375.29), VIP = Vector3.new(-3672.35, 154.64, -9382.89)},
		World3 = {Normal = Vector3.new(-8080.83, 283.18, 2741.99), VIP = Vector3.new(-8102.40, 281.96, 2741.95)},
		World4 = {Normal = Vector3.new(-7759.89, 21.91, 5741.03), VIP = Vector3.new(-7778.27, 19.57, 5740.98)},
		World5 = {Normal = Vector3.new(-7599.19, 287.17, 8359.99), VIP = Vector3.new(-7616.64, 286.82, 8360.72)},
	}
	local Loops = {}
	local ActiveFarmWins = {}
	local function safeFire(remote, ...)
		if not remote then return false end
		local ok, err
		local cn = remote.ClassName
		if cn == "RemoteEvent" then ok, err = pcall(function(...) remote:FireServer(...) end, ...)
		elseif cn == "RemoteFunction" then ok, err = pcall(function(...) return remote:InvokeServer(...) end, ...)
		else ok, err = pcall(function(...) remote:FireServer(...) end, ...) end
		return ok
	end
	local function runLoop(id, isActive, fn, interval)
		if Loops[id] then task.cancel(Loops[id]) Loops[id] = nil end
		Loops[id] = task.spawn(function()
			while isActive() do
				pcall(fn)
				task.wait(interval or 0.5)
			end
			Loops[id] = nil
		end)
	end
	local function stopLoop(id) if Loops[id] then task.cancel(Loops[id]) Loops[id] = nil end end
	local function isTreadmillUnlocked(ttype)
		if not Data then return false end
		if ttype == "Sunken" then
			local s = Data:FindFirstChild("CollectedShards")
			if not s or #s:GetChildren() < 9 then return false end
		end
		if ttype == "Quantum" then return false end
		local paidList = {Golden=true, Diamond=true, Galaxy=true, Void=true, Celestial=true}
		if not paidList[ttype] then return true end
		local passes = Data:FindFirstChild("Passes")
		return passes and passes:FindFirstChild(ttype) ~= nil
	end
	local function getTreadmillPart(preferred)
		local best, bestMulti = nil, -1
		for _, part in collectionService:GetTagged("Treadmill") do
			if part:IsA("BasePart") and part:IsDescendantOf(workspaceService) then
				local ttype = part:GetAttribute("Type") or part.Name
				if not isTreadmillUnlocked(ttype) then continue end
				local multi = TreadmillCfg.Multis[ttype] or 0
				if preferred and ttype:lower() == preferred:lower() then return part end
				if not preferred and multi > bestMulti then bestMulti = multi best = part end
			end
		end
		if best then return best end
		for _, part in collectionService:GetTagged("Treadmill") do
			if part:IsA("BasePart") and part:IsDescendantOf(workspaceService) then
				local ttype = part:GetAttribute("Type") or part.Name
				if isTreadmillUnlocked(ttype) then return part end
			end
		end
		return nil
	end
	local function getBestAffordableLocked()
		if not Data then return nil end
		local BN = nil
		pcall(function() BN = require(replicatedStorage.Util.BigNum) end)
		if not BN then BN = {GreaterEqual = function(a, b) return (a and a.Value or 0) >= b end} end
		local best, bestReq = nil, -1
		local unlocked = Data:FindFirstChild("UnlockedUpgrades")
		local wins = Data:FindFirstChild("Wins")
		for idx, cfg in ipairs(UpgradesCfg) do
			local req = cfg and cfg.WinsRequirement
			if cfg and unlocked and not unlocked:FindFirstChild(tostring(idx)) and req then
				local affordable = false
				if BN.GreaterEqual and wins then affordable = BN.GreaterEqual(wins, req)
				else affordable = (wins and wins.Value or 0) >= req end
				if affordable and req > bestReq then bestReq = req best = idx end
			end
		end
		return best
	end
	local function getBestOwned()
		local maxIdx = 1
		local unlocked = Data and Data:FindFirstChild("UnlockedUpgrades")
		if unlocked then
			for _, v in unlocked:GetChildren() do
				local n = tonumber(v.Name)
				if n and n > maxIdx then maxIdx = n end
			end
		end
		return maxIdx
	end
	local function farmWinsFluid(id, isActive, pos, brickName)
		if Loops[id] then Loops[id]:Disconnect() Loops[id] = nil end
		local cachedButton, lastButtonSearch = nil, 0
		local function findButton()
			local now = tick()
			if cachedButton and cachedButton.Parent and (now - lastButtonSearch) < 5 then return cachedButton end
			lastButtonSearch = now
			local bestPart, bestDist = nil, 80
			for _, v in workspaceService:GetDescendants() do
				if v:IsA("BasePart") and v.Name == "Button" then
					local bc = v.BrickColor.Name
					if bc == brickName or (brickName == "Really Red" and (bc == "Really Red" or bc == "Bright red")) then
						local d = (v.Position - pos).Magnitude
						if d < bestDist then bestDist = d bestPart = v end
					end
				end
			end
			cachedButton = bestPart
			return bestPart
		end
		ActiveFarmWins[id] = true
		local time, renderConn = 0, nil
		renderConn = runService.RenderStepped:Connect(function(dt)
			if not isActive() then
				renderConn:Disconnect()
				ActiveFarmWins[id] = nil
				Loops[id] = nil
				return
			end
			local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			time = time + dt * 15
			local bounce = math.abs(math.sin(time)) * 6
			hrp.CFrame = CFrame.new(pos + Vector3.new(0, bounce, 0))
			hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			local button = findButton()
			if button then pcall(function() customFireTouch(hrp, button, 0) customFireTouch(hrp, button, 1) end) end
		end)
		Loops[id] = { Disconnect = function() if renderConn then renderConn:Disconnect() end ActiveFarmWins[id] = nil end }
	end
	local AntiAFKConn
	local function setAntiAFK(state)
		if state then
			if AntiAFKConn then AntiAFKConn:Disconnect() end
			AntiAFKConn = LocalPlayer.Idled:Connect(function()
				virtualUser:Button2Down(Vector2.new(0,0), workspaceService.CurrentCamera.CFrame)
				task.wait(1)
				virtualUser:Button2Up(Vector2.new(0,0), workspaceService.CurrentCamera.CFrame)
			end)
		elseif AntiAFKConn then AntiAFKConn:Disconnect() AntiAFKConn = nil end
	end
	task.spawn(function()
		while true do
			task.wait(1)
			local hasActiveFarm = false
			for _ in pairs(ActiveFarmWins) do hasActiveFarm = true break end
			for _, obj in workspaceService:GetDescendants() do
				if obj:IsA("SpawnLocation") then
					if hasActiveFarm then if obj.Enabled then obj.Enabled = false end
					elseif not obj.Enabled then obj.Enabled = true end
				end
			end
		end
	end)

	local mainTab = window:Tab({ Title = "🏠 Main", Icon = "house" })
	local farmingTab = window:Tab({ Title = "🚜 Farming", Icon = "tractor" })
	local inventoryTab = window:Tab({ Title = "🎒 Inventory", Icon = "backpack" })
	local rebirthTab = window:Tab({ Title = "🔄 Rebirth", Icon = "refresh-cw" })
	local settingsTab = window:Tab({ Title = "⚙️ Settings", Icon = "settings" })

	mainTab:Section({ Title = "ℹ️ Info" })
	mainTab:Paragraph({ Title = "Game", Desc = GameName })
	mainTab:Paragraph({ Title = "PlaceId", Desc = tostring(game.PlaceId) })
	mainTab:Button({
		Title = "📋 Copy Game Name",
		Callback = function()
			customSetClipboard(GameName)
			WindUI:Notify({Title = "Copied!", Content = GameName, Duration = 3})
		end
	})

	farmingTab:Section({ Title = "🏃 Train" })
	local selectedTreadmill = "Basic"
	farmingTab:Dropdown({
		Title = "Manual Treadmill",
		Values = {"Basic","Golden","Diamond","Galaxy","Void","Celestial","Sunken","Quantum","Reward","Emerald"},
		Value = "Basic",
		Callback = function(value) selectedTreadmill = value end
	})
	local autoTrainEnabled = false
	farmingTab:Toggle({
		Title = "Auto Train on Treadmill", Value = false,
		Callback = function(state)
			autoTrainEnabled = state
			if state then
				runLoop("AutoTrain", function() return autoTrainEnabled end, function()
					local part = getTreadmillPart(selectedTreadmill)
					if not part then return end
					local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if not hrp then return end
					pcall(function() customFireTouch(hrp, part, 0) end)
					hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
					task.wait(0.15)
					pcall(function() customFireTouch(hrp, part, 1) end)
				end, 5)
			else stopLoop("AutoTrain") end
		end
	})

	farmingTab:Section({ Title = "🪙 Wins" })
	local worlds = {"World1", "World2", "World3", "World4", "World5"}
	for _, world in ipairs(worlds) do
		local normalActive = false
		local normalId = "AutoWins_" .. world
		farmingTab:Toggle({
			Title = world:gsub("World", "WORLD ") .. " - Normal", Value = false,
			Callback = function(state)
				normalActive = state
				if state then farmWinsFluid(normalId, function() return normalActive end, TeleportPositions[world].Normal, "New Yeller")
				elseif Loops[normalId] and type(Loops[normalId]) == "table" then Loops[normalId]:Disconnect() Loops[normalId] = nil
				else stopLoop(normalId) end
			end
		})
		local vipActive = false
		local vipId = "AutoFarmVip_" .. world
		farmingTab:Toggle({
			Title = world:gsub("World", "WORLD ") .. " - Farm Win VIP", Value = false,
			Callback = function(state)
				vipActive = state
				if state then farmWinsFluid(vipId, function() return vipActive end, TeleportPositions[world].VIP, "Really Red")
				elseif Loops[vipId] and type(Loops[vipId]) == "table" then Loops[vipId]:Disconnect() Loops[vipId] = nil
				else stopLoop(vipId) end
			end
		})
	end

	farmingTab:Section({ Title = "🪙 Wins Chapter2" })
	local normalActiveCh2 = false
	local normalIdCh2 = "AutoWinsCh2_World1"
	local Ch2NormalPos = Vector3.new(-3548.34, 112.44, -255.17)
	farmingTab:Toggle({
		Title = "WORLD 1 - Normal", Value = false,
		Callback = function(state)
			normalActiveCh2 = state
			if state then farmWinsFluid(normalIdCh2, function() return normalActiveCh2 end, Ch2NormalPos, "New Yeller")
			elseif Loops[normalIdCh2] and type(Loops[normalIdCh2]) == "table" then Loops[normalIdCh2]:Disconnect() Loops[normalIdCh2] = nil
			else stopLoop(normalIdCh2) end
		end
	})
	local vipActiveCh2 = false
	local vipIdCh2 = "AutoFarmVipCh2_World1"
	local Ch2VipPos = Vector3.new(-3566.30, 112.68, -254.38)
	farmingTab:Toggle({
		Title = "WORLD 1 - Farm Win VIP", Value = false,
		Callback = function(state)
			vipActiveCh2 = state
			if state then farmWinsFluid(vipIdCh2, function() return vipActiveCh2 end, Ch2VipPos, "Really Red")
			elseif Loops[vipIdCh2] and type(Loops[vipIdCh2]) == "table" then Loops[vipIdCh2]:Disconnect() Loops[vipIdCh2] = nil
			else stopLoop(vipIdCh2) end
		end
	})

	farmingTab:Section({ Title = "🍌 Collecting" })
	local autoBananas = false
	farmingTab:Toggle({
		Title = "Auto Collect Bananas", Value = false,
		Callback = function(state)
			autoBananas = state
			if state then
				runLoop("AutoCollectBananas", function() return autoBananas end, function()
					for _, v in workspaceService:GetDescendants() do
						if v.Name:lower():find("banana") and v:IsA("BasePart") and LocalPlayer.Character then
							local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
							if hrp then pcall(function() customFireTouch(hrp, v, 0) task.wait(0.05) customFireTouch(hrp, v, 1) end) end
						end
					end
					for _, p in workspaceService:GetDescendants() do
						if p:IsA("ProximityPrompt") and p.ObjectText:lower():find("banana") then
							pcall(function() customFireProximity(p) end)
						end
					end
				end, 0.5)
			else stopLoop("AutoCollectBananas") end
		end
	})
	local autoShards = false
	farmingTab:Toggle({
		Title = "Auto Collect Sunken Shards", Value = false,
		Callback = function(state)
			autoShards = state
			if state then
				runLoop("AutoCollectShards", function() return autoShards end, function()
					for i = 1, 9 do
						if Remotes and Remotes:FindFirstChild("CollectShard") then safeFire(Remotes.CollectShard, "Shard" .. i) end
					end
				end, 0.8)
			else stopLoop("AutoCollectShards") end
		end
	})

	farmingTab:Section({ Title = "🎁 Rewards" })
	local autoClaimFree = false
	farmingTab:Toggle({
		Title = "Auto Claim Free Reward", Value = false,
		Callback = function(state)
			autoClaimFree = state
			if state then runLoop("AutoClaimFreeReward", function() return autoClaimFree end, function()
				if Remotes and Remotes:FindFirstChild("ClaimFreeReward") then safeFire(Remotes.ClaimFreeReward) end
			end, 5) else stopLoop("AutoClaimFreeReward") end
		end
	})
	local autoClaimStreak = false
	farmingTab:Toggle({
		Title = "Auto Claim Streak Reward", Value = false,
		Callback = function(state)
			autoClaimStreak = state
			if state then runLoop("AutoClaimStreakReward", function() return autoClaimStreak end, function()
				if Remotes and Remotes:FindFirstChild("ClaimStreakReward") then safeFire(Remotes.ClaimStreakReward) end
			end, 5) else stopLoop("AutoClaimStreakReward") end
		end
	})
	local autoClaimOffline = false
	farmingTab:Toggle({
		Title = "Auto Claim Offline Earnings", Value = false,
		Callback = function(state)
			autoClaimOffline = state
			if state then runLoop("AutoClaimOfflineEarnings", function() return autoClaimOffline end, function()
				if Remotes and Remotes:FindFirstChild("ClaimOfflineEarnings") then safeFire(Remotes.ClaimOfflineEarnings) end
			end, 5) else stopLoop("AutoClaimOfflineEarnings") end
		end
	})
	local autoSpinWheel = false
	farmingTab:Toggle({
		Title = "Auto Spin Wheel", Value = false,
		Callback = function(state)
			autoSpinWheel = state
			if state then runLoop("AutoSpinWheel", function() return autoSpinWheel end, function()
				if Remotes and Remotes:FindFirstChild("SpawnWheel") then safeFire(Remotes.SpawnWheel) end
				if Remotes and Remotes:FindFirstChild("PlayLootBoxSpin") then safeFire(Remotes.PlayLootBoxSpin) end
			end, 3) else stopLoop("AutoSpinWheel") end
		end
	})

	inventoryTab:Section({ Title = "🐵 Tails" })
	local autoBuyTails = false
	inventoryTab:Toggle({
		Title = "Auto Buy Best Tail", Value = false,
		Callback = function(state)
			autoBuyTails = state
			if state then runLoop("AutoBuyTails", function() return autoBuyTails end, function()
				local best = getBestAffordableLocked()
				local selected = Data and Data:FindFirstChild("SelectedUpgrade")
				if best and selected and best ~= selected.Value and Remotes then safeFire(Remotes.SelectUpgrade, best) end
			end, 1) else stopLoop("AutoBuyTails") end
		end
	})
	local autoEquipTails = false
	inventoryTab:Toggle({
		Title = "Auto Equip Best Owned Tail", Value = false,
		Callback = function(state)
			autoEquipTails = state
			if state then runLoop("AutoEquipBestTails", function() return autoEquipTails end, function()
				local best = getBestOwned()
				local selected = Data and Data:FindFirstChild("SelectedUpgrade")
				if selected and best ~= selected.Value and Remotes then safeFire(Remotes.SelectUpgrade, best) end
			end, 1) else stopLoop("AutoEquipBestTails") end
		end
	})

	inventoryTab:Section({ Title = "✨ Trails" })
	local Trails = {"Red","Blue","Green","Rainbow","Galaxy","Divine","Fairy","Spectral","Yin Yang","Bloodmoon","Sakura","Flash","Void","Steampunk"}
	local autoBuyTrail = false
	inventoryTab:Toggle({
		Title = "Auto Buy Next Trail", Value = false,
		Callback = function(state)
			autoBuyTrail = state
			if state then runLoop("AutoBuyTrail", function() return autoBuyTrail end, function()
				local unlocked = Data and Data:FindFirstChild("UnlockedTrails")
				if not unlocked then return end
				for _, name in ipairs(Trails) do
					if not unlocked:FindFirstChild(name) then
						if Remotes and Remotes:FindFirstChild("BuyTrail") then safeFire(Remotes.BuyTrail, name) end
						break
					end
				end
			end, 1) else stopLoop("AutoBuyTrail") end
		end
	})
	local autoEquipTrail = false
	inventoryTab:Toggle({
		Title = "Auto Equip Best Trail", Value = false,
		Callback = function(state)
			autoEquipTrail = state
			if state then runLoop("AutoEquipBestTrail", function() return autoEquipTrail end, function()
				local unlocked = Data and Data:FindFirstChild("UnlockedTrails")
				if not unlocked then return end
				local best = nil
				for i = #Trails, 1, -1 do
					if unlocked:FindFirstChild(Trails[i]) then best = Trails[i] break end
				end
				if best and Remotes and Remotes:FindFirstChild("EquipTrail") then safeFire(Remotes.EquipTrail, best) end
			end, 1) else stopLoop("AutoEquipBestTrail") end
		end
	})

	inventoryTab:Section({ Title = "🌟 Auras" })
	local Auras = {"Amber","Ice Cold","Nature","Rainbow","Lunar","Sparkle","Fairy","Spectral","Yin Yang","Bloodmoon","Sakura","Electric","Void","Steampunk"}
	local autoBuyAura = false
	inventoryTab:Toggle({
		Title = "Auto Buy Next Aura", Value = false,
		Callback = function(state)
			autoBuyAura = state
			if state then runLoop("AutoBuyAura", function() return autoBuyAura end, function()
				local unlocked = Data and Data:FindFirstChild("UnlockedAuras")
				if not unlocked then return end
				for _, name in ipairs(Auras) do
					if not unlocked:FindFirstChild(name) then
						if Remotes and Remotes:FindFirstChild("BuyAura") then safeFire(Remotes.BuyAura, name) end
						break
					end
				end
			end, 1) else stopLoop("AutoBuyAura") end
		end
	})
	local autoEquipAura = false
	inventoryTab:Toggle({
		Title = "Auto Equip Best Aura", Value = false,
		Callback = function(state)
			autoEquipAura = state
			if state then runLoop("AutoEquipAura", function() return autoEquipAura end, function()
				local unlocked = Data and Data:FindFirstChild("UnlockedAuras")
				if not unlocked then return end
				local best = nil
				for i = #Auras, 1, -1 do
					if unlocked:FindFirstChild(Auras[i]) then best = Auras[i] break end
				end
				if best and Remotes and Remotes:FindFirstChild("EquipAura") then safeFire(Remotes.EquipAura, best) end
			end, 1) else stopLoop("AutoEquipAura") end
		end
	})

	inventoryTab:Section({ Title = "🔮 Charms" })
	local autoBuyAllCharms = false
	inventoryTab:Toggle({
		Title = "Auto Buy All Charms", Value = false,
		Callback = function(state)
			autoBuyAllCharms = state
			if state then runLoop("AutoBuyAllCharms", function() return autoBuyAllCharms end, function()
				local worldShop = Data and Data:FindFirstChild("CharmShop")
				local curWorld = Data and Data:FindFirstChild("World")
				if not worldShop or not curWorld then return end
				local worldFolder = worldShop:FindFirstChild("World" .. tostring(curWorld.Value))
				if not worldFolder then return end
				for i = 1, 3 do
					local slot = worldFolder:FindFirstChild("Slot" .. i)
					local bought = worldFolder:FindFirstChild("Bought" .. i)
					if slot and slot:IsA("StringValue") and bought and not bought.Value then
						if Remotes and Remotes:FindFirstChild("BuyCharm") then
							safeFire(Remotes.BuyCharm, i)
							task.wait(0.4)
						end
					end
				end
			end, 1) else stopLoop("AutoBuyAllCharms") end
		end
	})
	local autoEquipCharms = false
	inventoryTab:Toggle({
		Title = "Auto Equip Best Charms", Value = false,
		Callback = function(state)
			autoEquipCharms = state
			if state then runLoop("AutoEquipBestCharms", function() return autoEquipCharms end, function()
				if Remotes and Remotes:FindFirstChild("EquipBestCharms") then safeFire(Remotes.EquipBestCharms, "Wins") end
			end, 1) else stopLoop("AutoEquipBestCharms") end
		end
	})
	local autoFuseCharms = false
	inventoryTab:Toggle({
		Title = "Auto Fuse Charms", Value = false,
		Callback = function(state)
			autoFuseCharms = state
			if state then runLoop("AutoFuseCharms", function() return autoFuseCharms end, function()
				local charmsFolder = Data and Data:FindFirstChild("Charms")
				if not charmsFolder then return end
				local byKey = {}
				for _, c in ipairs(charmsFolder:GetChildren()) do
					local charmName = c:GetAttribute("CharmName") or c:GetAttribute("Name") or ""
					if charmName == "" then continue end
					if c:GetAttribute("Locked") then continue end
					local starVal = c:GetAttribute("Stars")
					if type(starVal) ~= "number" then starVal = 0 end
					if starVal >= 3 then continue end
					local k = charmName .. "_" .. tostring(starVal)
					byKey[k] = byKey[k] or {}
					table.insert(byKey[k], c.Name)
				end
				for k, ids in pairs(byKey) do
					if #ids >= 3 then
						local toFuse = {ids[1], ids[2], ids[3]}
						if Remotes and Remotes:FindFirstChild("FuseCharms") then safeFire(Remotes.FuseCharms, toFuse) end
						return
					end
				end
			end, 1) else stopLoop("AutoFuseCharms") end
		end
	})

	inventoryTab:Section({ Title = "🧪 Potions" })
	local Potions = {"Speed 10m","Speed 30m","Speed 1h","Wins 10m","Wins 30m","Wins 1h"}
	for _, potion in ipairs(Potions) do
		local id = "AutoUsePotion_" .. potion:gsub(" ", ""):gsub("10m", "10"):gsub("30m", "30"):gsub("1h", "60")
		local active = false
		inventoryTab:Toggle({
			Title = "Auto Use: " .. potion, Value = false,
			Callback = function(state)
				active = state
				if state then runLoop(id, function() return active end, function()
					if Remotes and Remotes:FindFirstChild("UsePotion") then safeFire(Remotes.UsePotion, potion) end
				end, 2) else stopLoop(id) end
			end
		})
	end

	rebirthTab:Section({ Title = "🔄 Auto Rebirth" })
	local autoRebirth = false
	rebirthTab:Toggle({
		Title = "Auto Rebirth", Value = false,
		Callback = function(state)
			autoRebirth = state
			if state then runLoop("AutoRebirth", function() return autoRebirth end, function()
				if Remotes and Remotes:FindFirstChild("Rebirth") then safeFire(Remotes.Rebirth) end
			end, 1) else stopLoop("AutoRebirth") end
		end
	})
	rebirthTab:Button({
		Title = "🔄 Rebirth Now",
		Callback = function() if Remotes and Remotes:FindFirstChild("Rebirth") then safeFire(Remotes.Rebirth) end end
	})
	rebirthTab:Section({ Title = "📊 Status" })
	local rebirthsVal = Data and Data:FindFirstChild("Rebirths")
	local levelVal = Data and Data:FindFirstChild("Level")
	rebirthTab:Paragraph({ Title = "Rebirths", Desc = tostring(rebirthsVal and rebirthsVal.Value or 0) })
	rebirthTab:Paragraph({ Title = "Level", Desc = tostring(levelVal and levelVal.Value or 1) })

	settingsTab:Section({ Title = "⚙️ System" })
	settingsTab:Toggle({
		Title = "Anti-AFK", Value = true,
		Callback = function(state) setAntiAFK(state) end
	})
	setAntiAFK(true)
	settingsTab:Button({
		Title = "🗑️ Unload GUI",
		Callback = function()
			for id, loop in pairs(Loops) do
				if type(loop) == "table" and loop.Disconnect then loop:Disconnect()
				elseif type(loop) == "thread" then task.cancel(loop) end
			end
			if AntiAFKConn then AntiAFKConn:Disconnect() end
			window:Destroy()
		end
	})
	WindUI:Notify({ Title = "⚡ POTENT HUB", Content = "✅ GUI loaded for " .. GameName, Duration = 4 })
end

-- ============================================================
-- ========== JUEGO 3: MURDER MYSTERY 2 ==========
-- ============================================================
local function runMM2()
	local CONFIG_FILE = "potent_hub_mm2_config.json"

	local function loadConfig()
		if not isfile or not readfile or not isfile(CONFIG_FILE) then return {} end
		local ok, data = pcall(function() return httpService:JSONDecode(readfile(CONFIG_FILE)) end)
		if ok and type(data) == "table" then
			local defaults = {
				espAll = false, espGun = false,
				killAura = false, killAuraRange = 15,
				autoShoot = false, autoGrabGun = false,
				autoKnifeThrow = false,
				notifyMurderer = false, notifySheriff = false,
				gunSilentAim = false,
				hitboxExpand = false, hitboxSize = 4, hitboxVisible = false,
				instantRole = false,
				antiSilentAim = false,
				autoFarmCoins = false,
				godmode = false,
				speedEnabled = false, speedValue = 20,
				jumpEnabled = false, jumpValue = 50,
				noclipEnabled = false,
			}
			for key, default in pairs(defaults) do
				if data[key] == nil then data[key] = default end
			end
			return data
		end
		return {}
	end
	local function saveConfig(tbl)
		if not writefile then return end
		pcall(function() writefile(CONFIG_FILE, httpService:JSONEncode(tbl)) end)
	end
	local savedConfig = loadConfig()

	local localPlayer = playersService.LocalPlayer
	local flags = {
		espAll = savedConfig.espAll == true,
		espGun = savedConfig.espGun == true,
		killAura = savedConfig.killAura == true,
		killAuraRange = savedConfig.killAuraRange or 15,
		autoShoot = savedConfig.autoShoot == true,
		autoGrabGun = savedConfig.autoGrabGun == true,
		autoKnifeThrow = savedConfig.autoKnifeThrow == true,
		notifyMurderer = savedConfig.notifyMurderer == true,
		notifySheriff = savedConfig.notifySheriff == true,
		gunSilentAim = savedConfig.gunSilentAim == true,
		hitboxExpand = savedConfig.hitboxExpand == true,
		hitboxSize = savedConfig.hitboxSize or 4,
		hitboxVisible = savedConfig.hitboxVisible == true,
		instantRole = savedConfig.instantRole == true,
		antiSilentAim = savedConfig.antiSilentAim == true,
		autoFarmCoins = savedConfig.autoFarmCoins == true,
		godmode = savedConfig.godmode == true,
		speedEnabled = savedConfig.speedEnabled == true,
		speedValue = savedConfig.speedValue or 20,
		jumpEnabled = savedConfig.jumpEnabled == true,
		jumpValue = savedConfig.jumpValue or 50,
		noclipEnabled = savedConfig.noclipEnabled == true,
	}
	local function saveAll()
		saveConfig({
			espAll = flags.espAll, espGun = flags.espGun,
			killAura = flags.killAura, killAuraRange = flags.killAuraRange,
			autoShoot = flags.autoShoot, autoGrabGun = flags.autoGrabGun,
			autoKnifeThrow = flags.autoKnifeThrow,
			notifyMurderer = flags.notifyMurderer, notifySheriff = flags.notifySheriff,
			gunSilentAim = flags.gunSilentAim,
			hitboxExpand = flags.hitboxExpand, hitboxSize = flags.hitboxSize,
			hitboxVisible = flags.hitboxVisible,
			instantRole = flags.instantRole,
			antiSilentAim = flags.antiSilentAim,
			autoFarmCoins = flags.autoFarmCoins,
			godmode = flags.godmode,
			speedEnabled = flags.speedEnabled, speedValue = flags.speedValue,
			jumpEnabled = flags.jumpEnabled, jumpValue = flags.jumpValue,
			noclipEnabled = flags.noclipEnabled,
		})
	end

	local highlights = {}
	local tagCache = {}
	local gunEsp = {}
	local autoFarmRunning, autoFarmThread = false, nil
	local hitboxOriginal = {}
	local godmodeConnection = nil

	localPlayer.Idled:Connect(function()
		virtualUser:CaptureController()
		virtualUser:ClickButton2(Vector2.new())
	end)

	local function getRoot(player)
		local char = player and player.Character
		return char and char:FindFirstChild("HumanoidRootPart")
	end
	local function getHumanoid(player)
		local char = player and player.Character
		return char and char:FindFirstChildOfClass("Humanoid")
	end
	local function hasTool(player, search)
		local char = player.Character
		if char then
			for _, v in ipairs(char:GetDescendants()) do
				if v:IsA("Tool") and string.find(string.lower(v.Name), search) then return true end
			end
		end
		local backpack = player:FindFirstChild("Backpack")
		if backpack then
			for _, v in ipairs(backpack:GetChildren()) do
				if v:IsA("Tool") and string.find(string.lower(v.Name), search) then return true end
			end
		end
		return false
	end
	local function getPlayerRole(player)
		if not player.Character then return nil end
		if hasTool(player, "knife") then return "Murderer"
		elseif hasTool(player, "gun") or hasTool(player, "revolver") then return "Sheriff" end
		return "Innocent"
	end
	local function findMurderer()
		for _, plr in ipairs(playersService:GetPlayers()) do
			if plr ~= localPlayer then
				local bp = plr:FindFirstChild("Backpack")
				if bp and bp:FindFirstChild("Knife") then return plr end
				if plr.Character and plr.Character:FindFirstChild("Knife") then return plr end
			end
		end
		return nil
	end
	local function findSheriff()
		for _, plr in ipairs(playersService:GetPlayers()) do
			if plr ~= localPlayer then
				local bp = plr:FindFirstChild("Backpack")
				if bp and bp:FindFirstChild("Gun") then return plr end
				if plr.Character and plr.Character:FindFirstChild("Gun") then return plr end
			end
		end
		return nil
	end
	local function findMap()
		for _, o in ipairs(workspaceService:GetChildren()) do
			if o:FindFirstChild("CoinContainer") and o:FindFirstChild("Spawns") then return o end
		end
		return nil
	end
	local function removeHighlight(player)
		if highlights[player] then
			pcall(highlights[player].Destroy, highlights[player])
			highlights[player] = nil
		end
	end
	local function removeTag(player)
		if tagCache[player] then
			pcall(tagCache[player].Destroy, tagCache[player])
			tagCache[player] = nil
		end
	end
	local function createRoleTag(player, role)
		local char = player.Character
		if not char then return end
		local head = char:FindFirstChild("Head")
		if not head then return end
		removeTag(player)
		if role ~= "Murderer" and role ~= "Sheriff" then return end
		local colors = { Murderer = Color3.fromRGB(255, 0, 0), Sheriff = Color3.fromRGB(0, 100, 255) }
		local emojis = { Murderer = "🔪", Sheriff = "🔫" }
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "POTENT_ROLE_TAG"
		billboard.Size = UDim2.new(0, 180, 0, 35)
		billboard.StudsOffset = Vector3.new(0, 2.8, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = head
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bg.BackgroundTransparency = 0.6
		bg.Parent = billboard
		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, 0, 1, 0)
		text.BackgroundTransparency = 1
		text.Text = emojis[role] .. " " .. role
		text.TextColor3 = colors[role]
		text.TextScaled = true
		text.Font = Enum.Font.GothamBold
		text.Parent = bg
		tagCache[player] = billboard
	end
	local function updateESP()
		for player, _ in pairs(highlights) do
			if not player or not player.Parent then removeHighlight(player) removeTag(player) end
		end
		if not flags.espAll then
			for player, _ in pairs(highlights) do removeHighlight(player) removeTag(player) end
			return
		end
		for _, player in ipairs(playersService:GetPlayers()) do
			if player == localPlayer then removeHighlight(player) removeTag(player) continue end
			local role = getPlayerRole(player)
			local hl = highlights[player] or Instance.new("Highlight")
			hl.Name = "POTENT_ESP"
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.FillTransparency = 0.4
			hl.OutlineTransparency = 0
			if role == "Murderer" then
				hl.FillColor = Color3.fromRGB(255, 0, 0)
				hl.OutlineColor = Color3.fromRGB(255, 0, 0)
				hl.Adornee = player.Character
				hl.Parent = player.Character
				hl.Enabled = true
				highlights[player] = hl
				createRoleTag(player, "Murderer")
			elseif role == "Sheriff" then
				hl.FillColor = Color3.fromRGB(0, 100, 255)
				hl.OutlineColor = Color3.fromRGB(0, 100, 255)
				hl.Adornee = player.Character
				hl.Parent = player.Character
				hl.Enabled = true
				highlights[player] = hl
				createRoleTag(player, "Sheriff")
			elseif role == "Innocent" then
				hl.FillColor = Color3.fromRGB(0, 255, 0)
				hl.OutlineColor = Color3.fromRGB(0, 255, 0)
				hl.Adornee = player.Character
				hl.Parent = player.Character
				hl.Enabled = true
				highlights[player] = hl
				removeTag(player)
			else
				removeHighlight(player)
				removeTag(player)
			end
		end
	end
	local function updateGunESP()
		for obj, hl in pairs(gunEsp) do
			if not obj or not obj.Parent then pcall(hl.Destroy, hl) gunEsp[obj] = nil end
		end
		if not flags.espGun then
			for obj, hl in pairs(gunEsp) do pcall(hl.Destroy, hl) gunEsp[obj] = nil end
			return
		end
		for _, desc in ipairs(workspaceService:GetDescendants()) do
			if desc.Name == "GunDrop" and desc:IsA("BasePart") and not gunEsp[desc] then
				local hl = Instance.new("Highlight")
				hl.Name = "POTENT_GunHighlight"
				hl.Adornee = desc
				hl.FillColor = Color3.fromRGB(0, 255, 255)
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = desc
				gunEsp[desc] = hl
			end
		end
	end
	task.spawn(function() while true do pcall(updateESP) task.wait(0.2) end end)
	task.spawn(function() while true do pcall(updateGunESP) task.wait(0.5) end end)

	local function applyGodmode(state)
		if godmodeConnection then pcall(godmodeConnection.Disconnect, godmodeConnection) godmodeConnection = nil end
		if state then
			local function setupGodmode(character)
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					godmodeConnection = humanoid.HealthChanged:Connect(function(newHealth)
						if flags.godmode and newHealth < humanoid.MaxHealth then
							humanoid.Health = humanoid.MaxHealth
						end
					end)
				end
			end
			if localPlayer.Character then setupGodmode(localPlayer.Character) end
		end
	end
	local function coinsReach(state)
		for _, obj in pairs(workspaceService:GetDescendants()) do
			if obj.Name == "Coin_Server" and obj:IsA("BasePart") then
				if not hitboxOriginal[obj] then hitboxOriginal[obj] = obj.Size end
				if state then obj.Size = hitboxOriginal[obj] * 4
				else obj.Size = hitboxOriginal[obj] end
			end
		end
	end
	local function findCoinContainer()
		local map = findMap()
		if map then return map:FindFirstChild("CoinContainer") or map:FindFirstChild("Coins") end
		return nil
	end
	local function getNearestCoin()
		local container = findCoinContainer()
		if not container then return nil end
		local root = getRoot(localPlayer)
		if not root then return nil end
		local nearest, nearestDist = nil, math.huge
		for _, coin in ipairs(container:GetChildren()) do
			if coin:IsA("BasePart") then
				local visual = coin:FindFirstChild("CoinVisual")
				if visual and not visual:GetAttribute("Collected") then
					local dist = (root.Position - coin.Position).Magnitude
					if dist < nearestDist then nearestDist = dist nearest = coin end
				end
			end
		end
		return nearest
	end
	local function autoFarmLoop()
		while flags.autoFarmCoins and autoFarmRunning do
			local root = getRoot(localPlayer)
			local humanoid = getHumanoid(localPlayer)
			if not root or not humanoid or humanoid.Health <= 0 then autoFarmRunning = false break end
			local coin = getNearestCoin()
			if coin then
				local dist = (root.Position - coin.Position).Magnitude
				local duration = dist / 30
				if duration > 0.05 then
					humanoid:ChangeState(Enum.HumanoidStateType.Physics)
					local tween = tweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
					tween:Play()
					tween.Completed:Wait()
				else root.CFrame = coin.CFrame end
				task.wait(0.1)
			else task.wait(0.5) end
		end
	end
	local function startAutoFarm()
		if autoFarmRunning then return end
		autoFarmRunning = true
		autoFarmThread = task.spawn(autoFarmLoop)
	end
	local function stopAutoFarm()
		autoFarmRunning = false
		if autoFarmThread then task.cancel(autoFarmThread) autoFarmThread = nil end
	end
	local function getPredictedPosition(target)
		if not target or not target.Character then return Vector3.new(0,0,0) end
		local hrp = target.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return Vector3.new(0,0,0) end
		local vel = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.new(0,0,0)
		return hrp.Position + vel * 0.028
	end
	local function gunSilentAim()
		local char = localPlayer.Character
		if not char then return end
		local target = findMurderer()
		if not target or not target.Character then return end
		local mHRP = target.Character:FindFirstChild("HumanoidRootPart")
		local lHRP = char:FindFirstChild("HumanoidRootPart")
		if not mHRP or not lHRP then return end
		if not char:FindFirstChild("Gun") then
			local backpack = localPlayer:FindFirstChild("Backpack")
			if backpack then
				local gun = backpack:FindFirstChild("Gun")
				if gun then
					local humanoid = getHumanoid(localPlayer)
					if humanoid then pcall(function() humanoid:EquipTool(gun) end) task.wait(0.1) end
				end
			end
		end
		local gun = char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
		if not gun then return end
		local predPos = getPredictedPosition(target)
		local args = { CFrame.new(lHRP.Position, predPos), CFrame.new(predPos) }
		if gun:FindFirstChild("Shoot") then pcall(function() gun.Shoot:FireServer(unpack(args)) end) end
	end
	local function grabGun()
		local root = getRoot(localPlayer)
		if not root then return end
		local map = findMap()
		if not map then return end
		local gunDrop = map:FindFirstChild("GunDrop")
		if gunDrop and gunDrop:IsA("BasePart") and firetouchinterest then
			pcall(function()
				firetouchinterest(gunDrop, root, 1)
				firetouchinterest(gunDrop, root, 0)
			end)
		end
	end
	local function executeThrowAtNearest()
		local char = localPlayer.Character
		local humanoid = getHumanoid(localPlayer)
		if not char or not humanoid then return end
		local knife = char:FindFirstChild("Knife")
		if not knife then
			local backpack = localPlayer:FindFirstChild("Backpack")
			if backpack and backpack:FindFirstChild("Knife") then
				humanoid:EquipTool(backpack.Knife)
				task.wait(0.1)
				knife = char:FindFirstChild("Knife")
			end
		end
		if not knife or not knife:FindFirstChild("Throw") then return end
		local myRoot = getRoot(localPlayer)
		if not myRoot then return end
		local target, dist = nil, 1000
		for _, v in ipairs(playersService:GetPlayers()) do
			if v ~= localPlayer then
				local enemyRoot = getRoot(v)
				if enemyRoot then
					local h = getHumanoid(v)
					if h and h.Health > 0 then
						local mag = (myRoot.Position - enemyRoot.Position).Magnitude
						if mag < dist then dist = mag target = enemyRoot end
					end
				end
			end
		end
		if target then
			local prediction = target.Position + (target.AssemblyLinearVelocity * 0.05 * (dist / 100))
			local throwCFrame = CFrame.new(myRoot.Position, prediction)
			knife.Throw:FireServer(throwCFrame, prediction)
		end
	end
	local function killAll()
		local char = localPlayer.Character
		local humanoid = getHumanoid(localPlayer)
		if not char or not humanoid then return end
		local knife = char:FindFirstChild("Knife")
		if not knife then
			local backpack = localPlayer:FindFirstChild("Backpack")
			if backpack and backpack:FindFirstChild("Knife") then
				humanoid:EquipTool(backpack.Knife)
				task.wait(0.1)
				knife = char:FindFirstChild("Knife")
			end
		end
		if not knife or not knife:IsA("Tool") then return end
		local handle = knife:FindFirstChild("Handle")
		local stab = knife:FindFirstChild("Stab")
		if not handle then return end
		for _, v in ipairs(playersService:GetPlayers()) do
			if v ~= localPlayer then
				local enemyRoot = getRoot(v)
				if enemyRoot then
					pcall(function()
						firetouchinterest(handle, enemyRoot, 1)
						firetouchinterest(handle, enemyRoot, 0)
						if stab then stab:FireServer(enemyRoot.Position) end
					end)
					task.wait(0.1)
				end
			end
		end
	end
	local function killAura()
		local root = getRoot(localPlayer)
		local char = localPlayer.Character
		if not root or not char then return end
		local knife = char:FindFirstChild("Knife")
		if not knife then
			local backpack = localPlayer:FindFirstChild("Backpack")
			if backpack and backpack:FindFirstChild("Knife") then
				local humanoid = getHumanoid(localPlayer)
				if humanoid then humanoid:EquipTool(backpack.Knife) task.wait(0.1) knife = char:FindFirstChild("Knife") end
			end
		end
		if not knife or not knife:IsA("Tool") then return end
		local handle = knife:FindFirstChild("Handle")
		if not handle then return end
		local range = flags.killAuraRange or 15
		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= localPlayer then
				local targetRoot = getRoot(player)
				if targetRoot and (root.Position - targetRoot.Position).Magnitude <= range then
					pcall(function()
						knife:Activate()
						if firetouchinterest then
							firetouchinterest(handle, targetRoot, 1)
							firetouchinterest(targetRoot, handle, 0)
						end
					end)
				end
			end
		end
	end
	local function applyHitbox()
		for _, plr in ipairs(playersService:GetPlayers()) do
			if plr ~= localPlayer and plr.Character then
				local root = plr.Character:FindFirstChild("HumanoidRootPart")
				if root then
					if flags.hitboxExpand then
						root.Size = Vector3.new(flags.hitboxSize, flags.hitboxSize, flags.hitboxSize)
						root.Transparency = flags.hitboxVisible and 0.5 or 1
						root.CanCollide = false
					else
						root.Size = Vector3.new(2, 2, 1)
						root.Transparency = 1
						root.CanCollide = false
					end
				end
			end
		end
	end
	task.spawn(function()
		while true do
			if flags.hitboxExpand then pcall(applyHitbox) end
			task.wait(0.2)
		end
	end)
	local function applyMovement()
		local humanoid = getHumanoid(localPlayer)
		if not humanoid then return end
		pcall(function()
			if flags.speedEnabled then humanoid.WalkSpeed = math.max(16, math.min(50, flags.speedValue))
			else humanoid.WalkSpeed = 16 end
		end)
		pcall(function()
			if flags.jumpEnabled then humanoid.JumpPower = math.max(50, math.min(120, flags.jumpValue))
			else humanoid.JumpPower = 50 end
		end)
	end
	local noclipConnection
	local function toggleNoclip(state)
		if noclipConnection then pcall(noclipConnection.Disconnect, noclipConnection) noclipConnection = nil end
		if state then
			noclipConnection = runService.Stepped:Connect(function()
				local char = localPlayer.Character
				if char then
					for _, part in ipairs(char:GetDescendants()) do
						if part:IsA("BasePart") then part.CanCollide = false end
					end
				end
			end)
		end
	end
	task.spawn(function()
		while true do
			if flags.killAura then pcall(killAura) end
			if flags.autoShoot then pcall(gunSilentAim) end
			if flags.autoGrabGun then pcall(grabGun) end
			if flags.autoKnifeThrow and getPlayerRole(localPlayer) == "Murderer" then pcall(executeThrowAtNearest) end
			pcall(applyMovement)
			task.wait(0.15)
		end
	end)
	localPlayer.CharacterAdded:Connect(function()
		task.wait(0.5)
		if flags.noclipEnabled then toggleNoclip(true) end
		if flags.godmode then applyGodmode(true) end
	end)
	playersService.PlayerRemoving:Connect(function(player)
		removeHighlight(player)
		removeTag(player)
	end)

	local WindUI = getWindUILibrary()
	local window = createPotentWindow(WindUI, "POTENTHUB_MM2", "Murder Mystery 2")

	local visualsTab = window:Tab({ Title = "👁️ Visuals", Icon = "eye" })
	local farmTab = window:Tab({ Title = "🪙 Farm", Icon = "coins" })
	local combatTab = window:Tab({ Title = "⚔️ Combat", Icon = "swords" })
	local teleportTab = window:Tab({ Title = "🌀 Teleports", Icon = "map-pin" })
	local playerTab = window:Tab({ Title = "👤 Player", Icon = "user" })
	local creditsTab = window:Tab({ Title = "📜 Credits", Icon = "info" })

	visualsTab:Section({ Title = "🎯 ESP" })
	visualsTab:Toggle({
		Title = "⚡ ESP ALL", Desc = "🔴 Murderer | 🔵 Sheriff | 🟢 Innocent",
		Value = flags.espAll,
		Callback = function(state)
			flags.espAll = state
			saveAll()
			if not state then
				for player, _ in pairs(highlights) do removeHighlight(player) removeTag(player) end
			end
		end
	})
	visualsTab:Toggle({
		Title = "🔫 Gun Drop ESP", Desc = "Resalta la pistola caída",
		Value = flags.espGun,
		Callback = function(state) flags.espGun = state saveAll() end
	})
	visualsTab:Section({ Title = "🔔 Notificaciones" })
	visualsTab:Toggle({
		Title = "🔪 Notify Murderer", Desc = "Notifica cuando aparece el asesino",
		Value = flags.notifyMurderer,
		Callback = function(state) flags.notifyMurderer = state saveAll() end
	})
	visualsTab:Toggle({
		Title = "🔫 Notify Sheriff", Desc = "Notifica cuando aparece el sheriff",
		Value = flags.notifySheriff,
		Callback = function(state) flags.notifySheriff = state saveAll() end
	})
	visualsTab:Toggle({
		Title = "🎭 Instant Role Reveal", Desc = "Muestra tu rol al inicio de la ronda",
		Value = flags.instantRole,
		Callback = function(state) flags.instantRole = state saveAll() end
	})

	farmTab:Section({ Title = "💰 Auto Farm" })
	farmTab:Toggle({
		Title = "🪙 Auto Farm Coins (Mejorado)", Desc = "Farmea monedas automáticamente",
		Value = flags.autoFarmCoins,
		Callback = function(state)
			flags.autoFarmCoins = state
			saveAll()
			if state then coinsReach(true) startAutoFarm()
			else stopAutoFarm() coinsReach(false) end
		end
	})

	combatTab:Section({ Title = "🔪 Murderer" })
	combatTab:Toggle({
		Title = "💀 Knife Kill Aura", Desc = "Ataca a jugadores cercanos",
		Value = flags.killAura,
		Callback = function(state) flags.killAura = state saveAll() end
	})
	local rangeLabel = combatTab:Paragraph({ Title = "📊 Kill Aura Range", Desc = "Current: " .. tostring(flags.killAuraRange) })
	combatTab:Button({ Title = "➕ Range", Callback = function()
		if flags.killAuraRange < 50 then flags.killAuraRange = flags.killAuraRange + 1 saveAll() rangeLabel:SetDesc("Current: " .. tostring(flags.killAuraRange)) end
	end })
	combatTab:Button({ Title = "➖ Range", Callback = function()
		if flags.killAuraRange > 5 then flags.killAuraRange = flags.killAuraRange - 1 saveAll() rangeLabel:SetDesc("Current: " .. tostring(flags.killAuraRange)) end
	end })
	combatTab:Button({ Title = "💀 Kill All", Callback = function() killAll() end })
	combatTab:Toggle({
		Title = "🔪 Auto Knife Throw", Desc = "Lanza el cuchillo al más cercano",
		Value = flags.autoKnifeThrow,
		Callback = function(state) flags.autoKnifeThrow = state saveAll() end
	})

	combatTab:Section({ Title = "🔫 Sheriff" })
	combatTab:Toggle({
		Title = "🎯 Gun Silent Aim", Desc = "Dispara al asesino sin mover la cámara",
		Value = flags.gunSilentAim,
		Callback = function(state) flags.gunSilentAim = state saveAll() end
	})
	combatTab:Toggle({
		Title = "🎯 Auto Shoot Murderer", Desc = "Dispara automáticamente al asesino",
		Value = flags.autoShoot,
		Callback = function(state) flags.autoShoot = state saveAll() end
	})
	combatTab:Toggle({
		Title = "🤚 Auto Grab Gun", Desc = "Recoge la pistola automáticamente",
		Value = flags.autoGrabGun,
		Callback = function(state) flags.autoGrabGun = state saveAll() end
	})

	combatTab:Section({ Title = "📦 Hitbox Expander" })
	combatTab:Toggle({
		Title = "📦 Hitbox Expand", Desc = "Expande el hitbox de los jugadores",
		Value = flags.hitboxExpand,
		Callback = function(state) flags.hitboxExpand = state saveAll() end
	})
	local hitboxLabel = combatTab:Paragraph({ Title = "📊 Hitbox Size", Desc = "Current: " .. tostring(flags.hitboxSize) })
	combatTab:Button({ Title = "➕ Hitbox Size", Callback = function()
		if flags.hitboxSize < 20 then flags.hitboxSize = flags.hitboxSize + 1 saveAll() hitboxLabel:SetDesc("Current: " .. tostring(flags.hitboxSize)) end
	end })
	combatTab:Button({ Title = "➖ Hitbox Size", Callback = function()
		if flags.hitboxSize > 1 then flags.hitboxSize = flags.hitboxSize - 1 saveAll() hitboxLabel:SetDesc("Current: " .. tostring(flags.hitboxSize)) end
	end })
	combatTab:Toggle({
		Title = "📦 Hitbox Visible", Desc = "Muestra el hitbox expandido",
		Value = flags.hitboxVisible,
		Callback = function(state) flags.hitboxVisible = state saveAll() end
	})

	teleportTab:Section({ Title = "🚀 Quick TP" })
	teleportTab:Button({ Title = "⬇️ Teleport to Gun Drop", Callback = function()
		local root = getRoot(localPlayer)
		if not root then return end
		for _, desc in ipairs(workspaceService:GetDescendants()) do
			if desc.Name == "GunDrop" and desc:IsA("BasePart") then
				root.CFrame = desc.CFrame + Vector3.new(0, 3, 0)
				WindUI:Notify({ Title = "Teleport", Content = "✅ Teleported to gun", Duration = 2 })
				return
			end
		end
		WindUI:Notify({ Title = "Teleport", Content = "❌ No gun drop", Duration = 2 })
	end })
	teleportTab:Button({ Title = "🔴 Teleport to Murderer", Callback = function()
		local target = findMurderer()
		local root = getRoot(localPlayer)
		local targetRoot = target and getRoot(target)
		if root and targetRoot then
			root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
			WindUI:Notify({ Title = "Teleport", Content = "✅ Teleported to murderer", Duration = 2 })
		else WindUI:Notify({ Title = "Teleport", Content = "❌ Murderer not found", Duration = 2 }) end
	end })
	teleportTab:Button({ Title = "🔵 Teleport to Sheriff", Callback = function()
		local target = findSheriff()
		local root = getRoot(localPlayer)
		local targetRoot = target and getRoot(target)
		if root and targetRoot then
			root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
			WindUI:Notify({ Title = "Teleport", Content = "✅ Teleported to sheriff", Duration = 2 })
		else WindUI:Notify({ Title = "Teleport", Content = "❌ Sheriff not found", Duration = 2 }) end
	end })

	playerTab:Section({ Title = "🏃 Movement" })
	playerTab:Toggle({
		Title = "⚡ Custom WalkSpeed (Max: 50)", Value = flags.speedEnabled,
		Callback = function(state) flags.speedEnabled = state saveAll() pcall(applyMovement) end
	})
	local speedLabel = playerTab:Paragraph({ Title = "📊 WalkSpeed Value", Desc = "Current: " .. tostring(flags.speedValue) })
	playerTab:Button({ Title = "➕ WalkSpeed", Callback = function()
		if flags.speedValue < 50 then flags.speedValue = flags.speedValue + 1 saveAll() speedLabel:SetDesc("Current: " .. tostring(flags.speedValue)) if flags.speedEnabled then pcall(applyMovement) end end
	end })
	playerTab:Button({ Title = "➖ WalkSpeed", Callback = function()
		if flags.speedValue > 16 then flags.speedValue = flags.speedValue - 1 saveAll() speedLabel:SetDesc("Current: " .. tostring(flags.speedValue)) if flags.speedEnabled then pcall(applyMovement) end end
	end })
	playerTab:Toggle({
		Title = "🚀 Custom JumpPower", Value = flags.jumpEnabled,
		Callback = function(state) flags.jumpEnabled = state saveAll() pcall(applyMovement) end
	})
	local jumpLabel = playerTab:Paragraph({ Title = "📊 JumpPower Value", Desc = "Current: " .. tostring(flags.jumpValue) })
	playerTab:Button({ Title = "➕ JumpPower", Callback = function()
		if flags.jumpValue < 120 then flags.jumpValue = flags.jumpValue + 1 saveAll() jumpLabel:SetDesc("Current: " .. tostring(flags.jumpValue)) if flags.jumpEnabled then pcall(applyMovement) end end
	end })
	playerTab:Button({ Title = "➖ JumpPower", Callback = function()
		if flags.jumpValue > 50 then flags.jumpValue = flags.jumpValue - 1 saveAll() jumpLabel:SetDesc("Current: " .. tostring(flags.jumpValue)) if flags.jumpEnabled then pcall(applyMovement) end end
	end })

	playerTab:Section({ Title = "👻 God Mode" })
	playerTab:Toggle({
		Title = "🌀 Noclip", Desc = "Atraviesa paredes",
		Value = flags.noclipEnabled,
		Callback = function(state) flags.noclipEnabled = state saveAll() toggleNoclip(state) end
	})
	playerTab:Toggle({
		Title = "❤️ Godmode", Desc = "Restaura tu vida automáticamente",
		Value = flags.godmode,
		Callback = function(state) flags.godmode = state saveAll() applyGodmode(state) end
	})
	playerTab:Section({ Title = "🛡️ Protección" })
	playerTab:Toggle({
		Title = "🛡️ Anti Silent Aim", Desc = "Protege contra silent aim",
		Value = flags.antiSilentAim,
		Callback = function(state) flags.antiSilentAim = state saveAll() end
	})

	creditsTab:Section({ Title = "⚡ POTENT HUB" })
	creditsTab:Paragraph({ Title = "👑 Owner", Desc = "POTENT HUB" })
	creditsTab:Paragraph({ Title = "🎮 Game", Desc = "Murder Mystery 2" })

	WindUI:Notify({ Title = "⚡ POTENT HUB", Content = "✅ Murder Mystery 2 loaded!", Duration = 4 })
end

-- ============================================================
-- ========== JUEGO 4: KITTEN FARM ==========
-- ============================================================
local function runKittenFarm()
	local LocalPlayer = playersService.LocalPlayer
	local TARGET_PLACE_ID = 77813828595591

	local Loops = {}
	local antiAfkConn = nil

	local sessionStart = tick()
	local sessionStartMoney = 0
	local sessionStartYarn = 0
	local lastRebirthNotified = -1
	local webhookUrl = ""

	local function getOwnPlot()
		local plots = workspaceService:FindFirstChild("Plots")
		if not plots then return nil end
		for _, p in ipairs(plots:GetChildren()) do
			if p:GetAttribute("Owner") == LocalPlayer.UserId then
				return p
			end
		end
		return nil
	end

	local function getHRP()
		local char = LocalPlayer.Character
		return char and char:FindFirstChild("HumanoidRootPart")
	end

	local function pressButton(name)
		local plot = getOwnPlot()
		if not plot then return false end
		local buttons = plot:FindFirstChild("Buttons")
		local btn = buttons and buttons:FindFirstChild(name)
		local press = btn and btn:FindFirstChild("Press")
		local hrp = getHRP()
		if not press or not hrp then return false end
		pcall(function()
			customFireTouch(hrp, press, 1)
			task.wait(0.08)
			customFireTouch(hrp, press, 0)
		end)
		return true
	end

	local function runAutoLoop(id, isActive, fn, interval)
		if Loops[id] then task.cancel(Loops[id]) Loops[id] = nil end
		Loops[id] = task.spawn(function()
			while isActive() do
				pcall(fn)
				task.wait(interval or 1)
			end
			Loops[id] = nil
		end)
	end

	local function stopLoop(id)
		if Loops[id] then task.cancel(Loops[id]) Loops[id] = nil end
	end

	local function setAntiAFK(state)
		if state then
			if antiAfkConn then antiAfkConn:Disconnect() end
			pcall(function()
				if getconnections then
					for _, c in ipairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
				end
			end)
			antiAfkConn = LocalPlayer.Idled:Connect(function()
				pcall(function()
					virtualUser:CaptureController()
					virtualUser:ClickButton2(Vector2.new())
				end)
			end)
		else
			if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
		end
	end

	local function getMoney()
		local m = LocalPlayer:FindFirstChild("Money")
		return m and m.Value or 0
	end

	local function getYarn()
		local y = LocalPlayer:FindFirstChild("Yarn")
		return y and y.Value or 0
	end

	local function getRebirths()
		local r = LocalPlayer:FindFirstChild("Rebirths") or LocalPlayer:FindFirstChild("Prestige")
		return r and r.Value or 0
	end

	local function sendWebhook(title, description, color)
		if not webhookUrl or webhookUrl == "" then return end
		local payload = {
			username = "Potent Hub",
			embeds = {{
				title = title,
				description = description,
				color = color or 16766720,
				footer = { text = "Potent Hub | Kitten Farm" },
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			}},
		}
		pcall(function()
			customHttpPost(webhookUrl, httpService:JSONEncode(payload), "application/json")
		end)
	end

	local WindUI = getWindUILibrary()
	local window = createPotentWindow(WindUI, "POTENTHUB_KITTEN_FARM", "Kitten Farm")

	local mainTab = window:Tab({ Title = "🏠 Main", Icon = "house" })
	local farmingTab = window:Tab({ Title = "🚜 Farming", Icon = "tractor" })
	local inventoryTab = window:Tab({ Title = "🎒 Inventory", Icon = "backpack" })
	local rebirthTab = window:Tab({ Title = "🔄 Rebirth", Icon = "refresh-cw" })
	local serverTab = window:Tab({ Title = "🌐 Server", Icon = "globe" })
	local webhookTab = window:Tab({ Title = "🔔 Webhook", Icon = "bell" })
	local settingsTab = window:Tab({ Title = "⚙️ Settings", Icon = "settings" })

	mainTab:Section({ Title = "ℹ️ Game Info" })
	mainTab:Paragraph({ Title = "Game", Desc = "Kitten Farm" })
	mainTab:Paragraph({ Title = "PlaceId", Desc = tostring(TARGET_PLACE_ID) })

	local uptimeParagraph = mainTab:Paragraph({ Title = "⏱️ Uptime", Desc = "0s" })
	local statusParagraph = mainTab:Paragraph({ Title = "📊 Status", Desc = "Loading..." })

	mainTab:Section({ Title = "📈 Session Stats" })
	local moneyPerHourParagraph = mainTab:Paragraph({ Title = "💰 Money / Hour", Desc = "Calculating..." })
	local yarnPerHourParagraph = mainTab:Paragraph({ Title = "🧶 Yarn / Hour", Desc = "Calculating..." })
	local totalGainedParagraph = mainTab:Paragraph({ Title = "📊 Total Gained", Desc = "Money: 0 | Yarn: 0" })

	mainTab:Button({
		Title = "🔄 Reset Session Stats",
		Callback = function()
			sessionStart = tick()
			sessionStartMoney = getMoney()
			sessionStartYarn = getYarn()
			WindUI:Notify({ Title = "Stats Reset", Content = "Session stats reset", Duration = 2 })
		end,
	})

	task.spawn(function()
		task.wait(1.5)
		sessionStartMoney = getMoney()
		sessionStartYarn = getYarn()
		lastRebirthNotified = getRebirths()

		while true do
			task.wait(1)
			pcall(function()
				local elapsed = math.floor(tick() - sessionStart)
				uptimeParagraph:SetDesc(string.format("%dh %dm %ds",
					math.floor(elapsed / 3600),
					math.floor((elapsed % 3600) / 60),
					elapsed % 60
				))

				local plot = getOwnPlot()
				local curMoney = getMoney()
				local curYarn = getYarn()

				statusParagraph:SetDesc(string.format(
					"Plot: %s | Cash: %s | Yarn: %s",
					plot and plot.Name or "?",
					tostring(curMoney),
					tostring(curYarn)
				))

				local hoursElapsed = math.max((tick() - sessionStart) / 3600, 0.001)
				local moneyGained = curMoney - sessionStartMoney
				local yarnGained = curYarn - sessionStartYarn
				local moneyRate = math.floor(moneyGained / hoursElapsed)
				local yarnRate = math.floor(yarnGained / hoursElapsed)

				moneyPerHourParagraph:SetDesc(tostring(moneyRate) .. " /hr")
				yarnPerHourParagraph:SetDesc(tostring(yarnRate) .. " /hr")
				totalGainedParagraph:SetDesc(string.format("Money: %d | Yarn: %d", moneyGained, yarnGained))
			end)
		end
	end)

	farmingTab:Section({ Title = "🧶 Resource Collecting" })
	local autoCollectYarn = false
	farmingTab:Toggle({
		Title = "Auto Collect Yarn",
		Desc = "Fires Yarn.Collect remote for nearby yarn every 1s",
		Value = false,
		Callback = function(state)
			autoCollectYarn = state
			if state then
				runAutoLoop("AutoCollectYarn", function() return autoCollectYarn end, function()
					local folder = workspaceService:FindFirstChild("Yarn")
					local remotes = replicatedStorage:FindFirstChild("Remotes")
					local yarnRemote = remotes and remotes:FindFirstChild("Yarn")
					local collect = yarnRemote and yarnRemote:FindFirstChild("Collect")
					if not folder or not collect then return end
					for _, m in ipairs(folder:GetChildren()) do
						if not autoCollectYarn then break end
						pcall(function() collect:FireServer(m.Name) end)
					end
				end, 1)
			else
				stopLoop("AutoCollectYarn")
			end
		end,
	})

	local autoCollectMoney = false
	farmingTab:Toggle({
		Title = "Auto Collect Money",
		Desc = "Touches CollectCash button on your plot every 1s",
		Value = false,
		Callback = function(state)
			autoCollectMoney = state
			if state then
				runAutoLoop("AutoCollectMoney", function() return autoCollectMoney end, function()
					pressButton("CollectCash")
				end, 1)
			else
				stopLoop("AutoCollectMoney")
			end
		end,
	})

	farmingTab:Section({ Title = "💰 Selling" })
	local autoDepositYarn = false
	farmingTab:Toggle({
		Title = "Auto Deposit Yarn",
		Desc = "Touches DepositYarn button on your plot every 1s",
		Value = false,
		Callback = function(state)
			autoDepositYarn = state
			if state then
				runAutoLoop("AutoDepositYarn", function() return autoDepositYarn end, function()
					pressButton("DepositYarn")
				end, 1)
			else
				stopLoop("AutoDepositYarn")
			end
		end,
	})

	farmingTab:Section({ Title = "🎁 Daily Rewards" })
	local autoClaimDaily = false
	farmingTab:Toggle({
		Title = "Auto Claim Daily Rewards",
		Desc = "Attempts to claim any daily / streak / login reward",
		Value = false,
		Callback = function(state)
			autoClaimDaily = state
			if state then
				runAutoLoop("AutoClaimDaily", function() return autoClaimDaily end, function()
					local remotes = replicatedStorage:FindFirstChild("Remotes")
					if not remotes then return end
					local candidates = {
						"ClaimDaily", "ClaimDailyReward", "DailyReward",
						"ClaimStreak", "ClaimStreakReward",
						"ClaimLogin", "ClaimLoginReward",
						"ClaimFreeReward", "ClaimReward",
					}
					for _, remoteName in ipairs(candidates) do
						local remote = remotes:FindFirstChild(remoteName)
						if remote then
							pcall(function()
								if remote:IsA("RemoteEvent") then
									remote:FireServer()
								elseif remote:IsA("RemoteFunction") then
									remote:InvokeServer()
								end
							end)
						end
					end
				end, 60)
			else
				stopLoop("AutoClaimDaily")
			end
		end,
	})

	farmingTab:Button({
		Title = "🎁 Claim Daily Now",
		Callback = function()
			local remotes = replicatedStorage:FindFirstChild("Remotes")
			if not remotes then
				WindUI:Notify({ Title = "Daily", Content = "❌ Remotes folder not found", Duration = 3 })
				return
			end
			local claimed = 0
			local candidates = {
				"ClaimDaily", "ClaimDailyReward", "DailyReward",
				"ClaimStreak", "ClaimStreakReward",
				"ClaimLogin", "ClaimLoginReward",
				"ClaimFreeReward", "ClaimReward",
			}
			for _, remoteName in ipairs(candidates) do
				local remote = remotes:FindFirstChild(remoteName)
				if remote then
					local ok = pcall(function()
						if remote:IsA("RemoteEvent") then remote:FireServer()
						elseif remote:IsA("RemoteFunction") then remote:InvokeServer() end
					end)
					if ok then claimed = claimed + 1 end
				end
			end
			WindUI:Notify({
				Title = "Daily",
				Content = claimed > 0 and ("✅ Fired " .. claimed .. " reward remotes") or "⚠️ No known reward remotes",
				Duration = 3,
			})
		end,
	})

	inventoryTab:Section({ Title = "🐱 Kitten Purchasing" })
	local autoBuy1, autoBuy5, autoBuy25, autoBuy100 = false, false, false, false

	inventoryTab:Toggle({
		Title = "Auto Buy 1 Kitten", Value = false,
		Callback = function(state)
			autoBuy1 = state
			if state then runAutoLoop("AutoBuy1", function() return autoBuy1 end, function() pressButton("Buy1") end, 1)
			else stopLoop("AutoBuy1") end
		end,
	})

	inventoryTab:Toggle({
		Title = "Auto Buy 5 Kittens", Value = false,
		Callback = function(state)
			autoBuy5 = state
			if state then runAutoLoop("AutoBuy5", function() return autoBuy5 end, function() pressButton("Buy5") end, 1)
			else stopLoop("AutoBuy5") end
		end,
	})

	inventoryTab:Toggle({
		Title = "Auto Buy 25 Kittens", Value = false,
		Callback = function(state)
			autoBuy25 = state
			if state then runAutoLoop("AutoBuy25", function() return autoBuy25 end, function() pressButton("Buy25") end, 1)
			else stopLoop("AutoBuy25") end
		end,
	})

	inventoryTab:Toggle({
		Title = "Auto Buy 100 Kittens", Value = false,
		Callback = function(state)
			autoBuy100 = state
			if state then runAutoLoop("AutoBuy100", function() return autoBuy100 end, function() pressButton("Buy100") end, 1)
			else stopLoop("AutoBuy100") end
		end,
	})

	inventoryTab:Section({ Title = "📈 Stat Upgrades" })
	local autoUpgradeYarnRate = false
	inventoryTab:Toggle({
		Title = "Auto Upgrade Yarn Rate", Desc = "Touches UpgradeYarnRate button every 1s", Value = false,
		Callback = function(state)
			autoUpgradeYarnRate = state
			if state then runAutoLoop("AutoUpgradeYarnRate", function() return autoUpgradeYarnRate end, function() pressButton("UpgradeYarnRate") end, 1)
			else stopLoop("AutoUpgradeYarnRate") end
		end,
	})

	local autoUpgradeBuyTier = false
	inventoryTab:Toggle({
		Title = "Auto Upgrade Buy Tier", Desc = "Touches UpgradeBuyTier button every 1s", Value = false,
		Callback = function(state)
			autoUpgradeBuyTier = state
			if state then runAutoLoop("AutoUpgradeBuyTier", function() return autoUpgradeBuyTier end, function() pressButton("UpgradeBuyTier") end, 1)
			else stopLoop("AutoUpgradeBuyTier") end
		end,
	})

	inventoryTab:Section({ Title = "📦 Misc" })
	local autoMerge = false
	inventoryTab:Toggle({
		Title = "Auto Merge", Desc = "Touches Merge button on your plot every 1s", Value = false,
		Callback = function(state)
			autoMerge = state
			if state then runAutoLoop("AutoMerge", function() return autoMerge end, function() pressButton("Button") end, 1)
			else stopLoop("AutoMerge") end
		end,
	})

	rebirthTab:Section({ Title = "🔄 Auto Rebirth" })
	local autoRebirth = false
	rebirthTab:Toggle({
		Title = "Auto Rebirth", Desc = "Checks Prestige price, rebirths when affordable (1s)", Value = false,
		Callback = function(state)
			autoRebirth = state
			if state then
				runAutoLoop("AutoRebirth", function() return autoRebirth end, function()
					local remotes = replicatedStorage:FindFirstChild("Remotes")
					local prestige = remotes and remotes:FindFirstChild("Prestige")
					local money = LocalPlayer:FindFirstChild("Money")
					if not prestige or not money then return end

					local ok, data = pcall(function() return prestige:InvokeServer("GetData") end)
					if not ok or type(data) ~= "table" then return end
					if data.Maxed then return end
					if typeof(data.Price) == "number" and money.Value >= data.Price then
						pcall(function() prestige:InvokeServer("Prestige") end)
					end
				end, 1)
			else
				stopLoop("AutoRebirth")
			end
		end,
	})

	rebirthTab:Button({
		Title = "🔄 Rebirth Now",
		Callback = function()
			local remotes = replicatedStorage:FindFirstChild("Remotes")
			local prestige = remotes and remotes:FindFirstChild("Prestige")
			if prestige then
				local ok = pcall(function() prestige:InvokeServer("Prestige") end)
				WindUI:Notify({ Title = "Rebirth", Content = ok and "✅ Rebirth fired" or "❌ Failed", Duration = 3 })
			end
		end,
	})

	settingsTab:Section({ Title = "⚙️ System" })
	settingsTab:Toggle({
		Title = "Anti-AFK", Value = true,
		Callback = function(state) setAntiAFK(state) end
	})
	setAntiAFK(true)

	settingsTab:Button({
		Title = "🗑️ Unload GUI",
		Callback = function()
			for id, loop in pairs(Loops) do
				if type(loop) == "thread" then task.cancel(loop) end
			end
			table.clear(Loops)
			if antiAfkConn then antiAfkConn:Disconnect() end
			window:Destroy()
		end,
	})

	WindUI:Notify({ Title = "⚡ POTENT HUB", Content = "✅ Kitten Farm loaded!", Duration = 4 })
end

-- ============================================================
-- ========== JUEGO 5: SPEED KEYBOARD ESCAPE ==========
-- ============================================================
local function runSpeedKeyboardEscape()
	local EXACT_NAMES = {
		LavaBottom = true, LavaCollide = true, LavaPart = true, LavaTop = true,
		Decorations = true, Tsunami1 = true, Tsunami = true, TsunamiEnd = true,
		TsunamiSpawn = true, MovingWalls = true,
		MovingWall1 = true, MovingWall2 = true, MovingWall3 = true,
		MovingWall4 = true, MovingWall5 = true, MovingWall6 = true,
		Ball1 = true, Arrows = true, FanEffects = true,
		Lava_Stage3 = true, Trap_Stage13 = true, Lava = true, Wind = true,
		Twomps = true, Twomp = true, Cracks = true,
	}

	local WIN1_NAMES = {
		NPC_Zone5 = true, NPC5_AttackZone = true, Sol = true, SpawnNpc5 = true,
	}

	local function shouldRemove(name, selectedRoute)
		if EXACT_NAMES[name] then return true end
		if selectedRoute then
			local isWin1 = selectedRoute == "1.25B" or selectedRoute == "2B" or
				selectedRoute == "3.5B" or selectedRoute == "5.5B" or
				selectedRoute == "8.5B" or selectedRoute == "16B" or
				selectedRoute == "25B" or selectedRoute == "40B" or
				selectedRoute == "65B" or selectedRoute == "100B" or
				selectedRoute == "200B" or selectedRoute == "1T"
			if isWin1 and WIN1_NAMES[name] then return true end
		end
		return false
	end

	local function removeObstacles(selectedRoute)
		for _, d in ipairs(workspaceService:GetDescendants()) do
			if shouldRemove(d.Name, selectedRoute) then
				pcall(function() d:Destroy() end)
			end
		end
	end

	-- ============================================================
	-- ROUTES WORLD 2 (COMPLETAS)
	-- ============================================================
	local RAW_W2 = {
		["150K"] = {
			-397.56, 506.15, -51.07,  -401.05, 505.25, 62.40,  -402.06, 505.25, 127.12,
			-398.16, 501.32, 186.94,  -413.71, 503.32, 189.34,
		},
		["400K"] = {
			-397.22, 506.15, -42.89,  -401.83, 505.25, 63.62,  -401.77, 504.97, 125.04,
			-397.71, 501.32, 187.41,  -397.13, 501.32, 434.70,  -415.54, 503.32, 432.77,
		},
		["600K"] = {
			-396.23, 506.15, -40.54,  -401.96, 505.25, 64.27,  -402.36, 505.06, 126.37,
			-396.47, 501.32, 193.79,  -395.29, 501.32, 433.07,  -348.99, 505.74, 493.54,
			-349.08, 528.25, 579.91,  -457.30, 528.25, 578.07,  -453.95, 555.25, 460.06,
			-349.19, 555.25, 465.78,  -347.64, 582.32, 577.99,  -455.45, 582.32, 574.65,
			-450.83, 609.32, 463.34,  -395.87, 609.32, 466.69,  -400.53, 609.11, 607.75,
			-418.13, 611.05, 607.19,
		},
		["1M"] = {
			-397.92, 506.15, -41.16,  -401.17, 505.25, 63.32,  -403.80, 505.25, 131.83,
			-397.73, 501.32, 189.43,  -395.36, 501.32, 433.75,  -350.04, 501.91, 481.39,
			-347.63, 528.25, 580.01,  -453.45, 528.25, 576.23,  -454.15, 555.25, 460.92,
			-345.26, 555.25, 465.84,  -348.25, 582.32, 574.76,  -453.42, 582.32, 574.23,
			-451.02, 609.32, 465.54,  -396.64, 609.32, 468.94,  -400.33, 609.11, 604.41,
			-400.65, 609.11, 677.73,  -382.37, 609.11, 707.32,  -381.79, 609.11, 739.28,
			-399.59, 609.11, 782.25,  -400.40, 608.67, 841.49,  -417.27, 610.61, 842.39,
		},
		["1.5M"] = {
			-396.53, 506.15, -40.06,  -400.38, 505.02, 60.98,  -405.59, 505.25, 123.49,
			-396.93, 501.32, 191.84,  -397.04, 501.32, 435.37,  -349.90, 503.68, 487.02,
			-346.67, 528.25, 579.61,  -451.00, 528.25, 574.09,  -450.17, 555.25, 464.37,
			-348.02, 555.25, 468.05,  -351.86, 582.32, 580.75,  -456.47, 582.32, 578.57,
			-451.47, 609.32, 461.42,  -400.10, 609.32, 466.43,  -399.98, 609.11, 605.61,
			-400.85, 609.11, 672.28,  -381.99, 609.11, 708.88,  -381.63, 609.11, 735.49,
			-402.89, 609.11, 782.55,  -400.91, 608.67, 842.79,  -399.07, 652.07, 891.53,
			-396.95, 658.99, 1106.06, -402.38, 656.77, 1206.64, -401.64, 664.01, 1242.18,
			-400.91, 608.67, 1264.36, -417.18, 610.61, 1261.27,
		},
		["2.5M"] = {
			-398.80, 506.15, -40.85,  -404.38, 505.25, 122.56, -395.82, 501.32, 200.48,
			-397.37, 501.32, 436.04,  -349.33, 505.04, 491.33, -347.94, 528.25, 581.98,
			-452.57, 528.25, 577.30,  -454.68, 555.25, 463.47, -346.09, 555.25, 464.80,
			-347.40, 582.32, 579.84,  -452.08, 582.32, 576.42, -453.29, 609.32, 463.41,
			-401.98, 609.32, 467.31,  -398.54, 609.11, 612.87, -402.04, 608.67, 844.75,
			-394.25, 668.72, 906.62,  -398.43, 666.48, 1203.63,-398.78, 608.64, 1267.88,
			-401.98, 608.67, 1293.02, -400.94, 619.99, 1331.66,-402.64, 608.67, 1439.09,
			-366.04, 628.93, 1540.43, -364.37, 629.46, 1598.64,-360.39, 606.55, 1712.95,
			-364.49, 617.12, 1788.75, -398.10, 608.67, 1886.83,-404.40, 608.67, 2061.99,
			-398.28, 608.67, 2246.25, -400.31, 624.61, 2398.69,-400.78, 624.61, 2414.63,
			-417.00, 626.38, 2415.71,
		},
		["4M"] = {
			-396.34, 506.15, -41.57,  -401.28, 505.25, 58.81,  -397.87, 501.32, 195.77,
			-395.26, 501.32, 433.73,  -347.59, 505.53, 492.88, -348.63, 528.25, 583.82,
			-453.27, 528.25, 578.26,  -453.85, 555.25, 465.17, -346.82, 555.25, 465.54,
			-347.85, 582.32, 579.89,  -457.86, 582.32, 578.46, -454.50, 609.32, 463.49,
			-397.10, 609.32, 463.26,  -401.19, 609.11, 613.23, -402.02, 609.11, 800.85,
			-400.29, 608.67, 846.57,  -313.22, 608.67, 1000.25,-402.66, 609.53, 1226.30,
			-403.33, 608.67, 1269.90, -402.91, 618.68, 1327.69,-395.92, 608.67, 1448.47,
			-371.12, 629.26, 1541.48, -364.42, 606.55, 1719.86,-366.25, 616.48, 1786.80,
			-401.43, 608.67, 1898.83, -399.98, 608.67, 2064.30,-399.48, 619.71, 2137.65,
			-401.35, 608.67, 2256.11, -400.76, 620.29, 2316.98,-399.85, 624.61, 2411.24,
			-401.12, 624.56, 2653.54, -416.85, 626.56, 2650.08,
		},
		["6M"] = {
			-397.25, 506.15, -40.28,  -398.78, 505.25, 65.14,  -394.47, 501.32, 188.15,
			-396.21, 501.32, 433.42,  -351.76, 503.06, 485.05, -351.09, 528.25, 581.20,
			-458.46, 528.25, 578.68,  -456.19, 555.25, 462.29, -343.94, 555.25, 469.61,
			-349.88, 582.32, 577.78,  -452.74, 582.32, 578.78, -450.30, 609.32, 459.77,
			-401.90, 609.32, 471.41,  -401.06, 609.11, 611.22, -400.96, 609.11, 789.44,
			-400.59, 608.67, 850.24,  -290.45, 609.00, 998.96, -388.84, 609.19, 1256.77,
			-391.24, 608.67, 1450.20, -363.72, 629.46, 1562.38,-365.04, 606.55, 1728.39,
			-364.90, 615.76, 1784.63, -392.87, 608.67, 1904.14,-398.03, 619.19, 1955.17,
			-401.72, 608.67, 2073.83, -402.28, 619.56, 2137.17,-401.72, 608.67, 2261.35,
			-401.64, 620.69, 2318.43, -401.66, 624.61, 2410.60,-400.58, 624.56, 2647.28,
			-400.99, 624.59, 3160.69, -417.34, 626.38, 3158.17,
		},
		["10M"] = {
			-396.85, 506.15, -43.66,  -397.79, 501.32, 191.99, -395.31, 501.32, 438.44,
			-347.26, 507.10, 497.85,  -347.12, 528.25, 574.66, -452.43, 528.25, 573.53,
			-450.80, 555.25, 466.38,  -346.80, 555.25, 469.79, -348.17, 582.32, 575.06,
			-456.96, 582.32, 577.16,  -447.32, 609.32, 464.97, -391.00, 609.32, 474.67,
			-401.62, 609.11, 606.76,  -399.48, 608.67, 844.03, -400.50, 608.67, 1262.01,
			-399.16, 619.74, 1330.92, -395.81, 608.67, 1455.99,-360.86, 629.46, 1546.56,
			-360.52, 606.55, 1731.41, -369.57, 616.70, 1787.49,-397.07, 608.67, 1900.11,
			-399.26, 620.59, 1959.82, -399.84, 608.67, 2071.64,-405.92, 618.24, 2133.19,
			-400.81, 608.67, 2264.26, -401.46, 618.52, 2311.65,-400.35, 624.61, 2418.86,
			-400.52, 624.56, 2654.82, -399.89, 624.59, 3164.33,-397.51, 624.59, 3321.25,
			-178.01, 624.59, 3330.83, -169.29, 624.59, 3210.65,-102.24, 624.59, 3227.09,
			-122.66, 624.59, 3421.92, -258.82, 624.59, 3446.75,-266.19, 624.59, 3629.02,
			-549.61, 624.59, 3638.24, -546.54, 624.59, 3787.04,-123.01, 624.59, 3803.17,
			-130.94, 624.59, 3878.74, -63.36, 624.65, 3866.58, -60.23, 626.38, 3883.20,
		},
		["15M"] = {
			-395.96, 506.15, -36.15,  -399.63, 501.32, 197.37, -396.13, 501.32, 434.31,
			-338.06, 510.19, 507.66,  -346.45, 528.25, 578.81, -454.74, 528.25, 575.09,
			-453.27, 555.25, 462.82,  -349.37, 555.25, 464.85, -346.80, 582.32, 573.29,
			-456.64, 582.32, 568.00,  -452.93, 609.32, 460.80, -394.86, 609.32, 471.19,
			-401.80, 609.11, 607.74,  -401.49, 608.67, 849.94, -401.29, 608.67, 1255.58,
			-398.10, 619.35, 1329.72, -395.35, 608.67, 1453.82,-363.35, 629.46, 1544.08,
			-373.17, 608.43, 1762.46, -404.01, 608.67, 1903.99,-409.34, 608.67, 2074.07,
			-405.61, 618.22, 2133.13, -409.93, 620.49, 2317.59,-400.36, 624.61, 2403.06,
			-402.71, 624.56, 2653.96, -398.45, 624.59, 3159.32,-401.37, 624.59, 3333.39,
			-189.94, 624.59, 3329.75, -181.90, 624.59, 3235.26,-108.12, 624.59, 3242.44,
			-114.80, 624.59, 3417.17, -256.04, 624.59, 3486.37,-333.24, 624.59, 3631.83,
			-519.80, 624.59, 3664.53, -505.52, 624.59, 3807.56,-181.10, 624.59, 3819.08,
			-58.48, 624.65, 3866.03,  1185.86, 624.82, 3867.16, 1229.76, 626.74, 3909.11,
		},
		["25M"] = {
			-398.01, 506.15, -41.04,  -397.94, 501.32, 185.77, -394.87, 501.32, 432.87,
			-354.72, 503.40, 486.12,  -346.29, 528.25, 576.34, -452.48, 528.25, 575.63,
			-452.27, 555.25, 467.82,  -348.67, 556.49, 483.02, -361.25, 582.32, 576.54,
			-450.85, 582.92, 562.83,  -443.47, 609.32, 470.75, -390.94, 609.32, 473.53,
			-401.14, 609.11, 610.19,  -401.89, 608.67, 846.03, -400.50, 608.67, 1261.14,
			-399.32, 618.25, 1326.41, -400.79, 608.67, 1450.33,-365.48, 629.46, 1544.27,
			-362.42, 610.88, 1769.88, -368.92, 617.60, 1790.20,-403.24, 608.67, 1886.37,
			-402.33, 618.78, 1953.92, -403.73, 608.67, 2059.96,-400.77, 620.70, 2140.89,
			-401.36, 608.67, 2234.49, -398.58, 619.29, 2313.96,-401.07, 624.61, 2411.98,
			-400.53, 624.56, 2647.19, -401.39, 624.59, 3152.19,-402.73, 624.59, 3322.10,
			-202.84, 624.59, 3311.41, -113.28, 624.59, 3283.08,-125.15, 624.59, 3426.17,
			-268.75, 624.59, 3504.29, -314.82, 624.59, 3619.71,-527.62, 624.59, 3669.60,
			-498.88, 624.59, 3780.48, -71.59, 624.65, 3853.16, -51.52, 624.65, 3866.95,
			1210.88, 624.85, 3868.11, 1297.67, 624.89, 3866.78,1325.73, 614.96, 3865.35,
			1335.37, 667.93, 3862.09, 1547.01, 630.47, 3796.61,1750.39, 635.66, 3947.19,
			1953.63, 637.49, 3801.63, 2101.14, 638.53, 3964.90,2305.41, 630.33, 3866.94,
			2383.63, 628.86, 3872.10, 2396.52, 628.86, 3872.00,2400.81, 630.69, 3888.76,
		},
		["40M"] = {
			-396.08, 506.15, -36.82,  -396.12, 501.32, 191.72, -396.79, 501.32, 438.39,
			-351.09, 503.03, 484.96,  -346.18, 528.25, 565.52, -447.25, 528.25, 565.17,
			-444.12, 555.25, 469.77,  -337.13, 555.25, 464.23, -353.50, 582.32, 577.69,
			-449.50, 582.32, 576.16,  -451.15, 609.32, 459.82, -396.40, 609.32, 465.93,
			-401.26, 609.11, 612.24,  -399.69, 608.67, 855.20, -402.48, 608.67, 1274.66,
			-400.09, 618.58, 1327.41, -399.44, 608.67, 1449.65,-366.09, 629.46, 1543.85,
			-360.63, 607.68, 1760.19, -367.98, 618.30, 1792.33,-403.90, 608.67, 1898.76,
			-403.08, 619.63, 1956.48, -400.79, 608.67, 2086.75,-401.50, 619.88, 2138.15,
			-403.80, 618.00, 2310.07, -400.66, 624.61, 2415.07,-400.49, 624.56, 2651.30,
			-400.91, 624.59, 3155.08, -403.40, 624.59, 3339.57,-119.64, 624.59, 3284.05,
			-151.24, 624.59, 3458.09, -268.68, 624.59, 3487.22,-340.75, 624.59, 3660.40,
			-569.89, 624.59, 3668.16, -489.55, 624.59, 3799.60,-59.35, 625.56, 3850.75,
			1219.89, 624.85, 3866.75, 1284.32, 624.89, 3866.94,1286.06, 665.44, 3867.09,
			2292.79, 677.94, 3879.76, 2400.52, 628.86, 3868.66,2486.91, 639.53, 3869.72,
			2550.28, 640.78, 3869.41, 2681.08, 635.78, 3873.00,2739.68, 640.82, 3867.08,
			2739.68, 576.78, 3867.08, 2839.74, 577.89, 3870.93,2887.44, 595.52, 3869.69,
			2916.85, 605.82, 3871.14, 2978.85, 577.76, 3867.98,3048.89, 593.04, 3871.82,
			3182.50, 582.81, 3875.77, 3211.69, 593.44, 3871.68,3264.79, 593.78, 3871.91,
			3269.49, 595.78, 3888.77,
		},
		["60M"] = {
			-397.33, 506.15, -35.80,  -397.35, 501.32, 188.90, -397.08, 501.32, 429.52,
			-344.07, 509.28, 504.76,  -349.62, 528.25, 569.40, -463.72, 528.25, 568.95,
			-463.32, 555.25, 460.69,  -336.13, 555.25, 456.17, -337.20, 582.32, 585.60,
			-463.96, 582.32, 587.29,  -463.83, 609.32, 456.33, -389.89, 609.32, 456.22,
			-400.12, 609.11, 611.69,  -401.23, 608.67, 841.74, -400.22, 608.67, 1262.85,
			-401.34, 620.06, 1331.87, -401.77, 608.67, 1462.42,-363.49, 629.46, 1544.65,
			-362.30, 629.46, 1601.72, -358.97, 606.55, 1724.01,-362.12, 618.39, 1792.98,
			-399.98, 608.67, 1863.71, -401.84, 620.41, 1958.86,-401.36, 619.90, 2138.20,
			-400.57, 619.99, 2316.09, -399.49, 624.61, 2412.01,-401.65, 624.56, 2651.59,
			-399.46, 624.59, 3161.75, -403.65, 624.59, 3339.24,-95.43, 624.59, 3279.85,
			-167.38, 624.59, 3458.25, -257.94, 624.59, 3511.95,-380.92, 624.59, 3660.42,
			-545.07, 624.59, 3669.43, -495.24, 624.59, 3810.68,-63.71, 624.65, 3856.78,
			1217.90, 624.85, 3868.90, 1318.72, 622.75, 3865.82,1545.85, 631.10, 3797.11,
			1757.11, 638.47, 3948.35, 1947.14, 637.01, 3803.98,2104.09, 642.01, 3962.74,
			2298.19, 630.28, 3867.19, 2395.77, 628.86, 3870.35,2484.46, 638.72, 3870.29,
			2699.98, 635.78, 3871.53, 2739.82, 633.65, 3871.07,2739.82, 576.78, 3871.07,
			2846.61, 579.41, 3870.98, 2918.92, 606.44, 3870.91,2962.88, 577.76, 3872.23,
			3049.11, 593.12, 3870.46, 3189.61, 585.40, 3874.17,3268.12, 593.78, 3871.69,
			3290.56, 593.78, 3872.13, 3334.82, 705.95, 3843.62,3351.97, 706.48, 5159.45,
			4586.86, 706.48, 5144.25, 4646.06, 568.89, 5139.01,4634.53, 570.89, 5159.41,
		},
	}

	-- ============================================================
	-- ROUTES WORLD 3 (COMPLETAS)
	-- ============================================================
	local RAW_W3 = {
		["300M"] = {
			-1433.89, -159.52, -871.89, -1426.37, -154.24, -827.45, -1423.97, -124.16, -732.65,
			-1423.64, -89.19, -621.45,  -1427.91, -67.75, -524.57, -1482.27, -66.50, -515.24,
		},
		["500M"] = {
			-1432.86, -159.32, -872.44, -1428.03, -157.01, -836.28, -1426.70, -124.44, -732.69,
			-1429.19, -91.26, -627.20,  -1430.14, -68.39, -532.61, -1453.68, -68.39, -492.80,
			-1455.52, -56.93, -392.63,  -1454.35, -56.14, -20.18,  -1480.98, -54.26, -15.66,
		},
		["800M"] = {
			-1431.91, -158.92, -873.08, -1431.48, -155.53, -831.55, -1426.88, -124.41, -732.60,
			-1429.44, -91.57, -628.17,  -1427.49, -68.39, -531.84, -1454.33, -68.39, -490.71,
			-1453.24, -65.88, -428.40,  -1455.70, -56.88, -392.43, -1455.69, -55.89, -323.22,
			-1453.33, -56.14, -8.73,    -1454.43, -55.89, 83.49,   -1454.03, 90.70, 87.25,
			-1475.95, 91.11, 92.38,     -1474.50, 216.42, 96.89,   -1469.55, 224.45, 179.03,
			-1468.68, 224.76, 228.53,   -1467.31, 215.87, 335.16,  -1481.27, 217.75, 331.78,
		},
		["1.25B"] = {
			-1431.28, -159.52, -871.10, -1428.23, -155.12, -830.25, -1424.72, -122.48, -726.47,
			-1424.74, -87.52, -615.22,  -1424.48, -68.39, -534.38, -1453.99, -68.39, -492.30,
			-1453.82, -56.61, -391.32,  -1456.01, -55.89, -308.73, -1454.34, -56.14, -4.47,
			-1454.12, -53.46, 84.69,    -1453.73, 90.70, 87.30,   -1475.20, 216.23, 98.87,
			-1475.37, 224.47, 179.10,   -1464.36, 215.87, 351.88,  -1457.70, 215.84, 627.31,
			-1457.70, 369.89, 627.31,   -1453.66, 361.87, 583.43,  -1354.24, 360.67, 495.31,
			-1246.91, 335.51, 493.27,   -1240.09, 329.71, 660.76,  -1219.02, 347.41, 839.73,
			-1369.12, 365.36, 841.68,   -1403.13, 371.52, 753.85,  -1402.78, 374.86, 724.21,
			-1401.32, 546.36, 728.39,   -1430.47, 535.77, 759.87,
		},
		["2B"] = {
			-1431.49, -159.52, -870.66, -1426.25, -155.57, -831.70, -1426.50, -124.99, -734.44,
			-1427.32, -91.07, -626.58,  -1428.38, -68.39, -531.65, -1451.58, -68.39, -493.83,
			-1458.05, -57.60, -395.31,  -1454.06, -55.90, 84.25,   -1453.39, 216.11, 101.03,
			-1452.85, 224.06, 177.54,   -1454.76, 223.63, 232.80,  -1454.17, 215.87, 349.81,
			-1453.54, 215.80, 627.38,   -1456.03, 367.37, 627.45,  -1453.96, 361.87, 610.04,
			-1457.23, 361.87, 577.12,   -1457.51, 361.07, 498.31,  -1339.56, 361.69, 492.54,
			-1237.99, 329.71, 680.03,   -1218.08, 346.78, 833.47,  -1364.74, 364.94, 841.81,
			-1402.77, 374.52, 724.52,   -1402.77, 552.01, 724.52,  -1404.75, 533.88, 774.48,
			-1403.51, 533.88, 1333.85,  -1431.49, 535.76, 1329.84,
		},
		["3.5B"] = {
			-1432.42, -158.67, -873.54, -1425.42, -155.40, -831.15, -1423.45, -123.18, -729.52,
			-1424.09, -89.99, -623.98,  -1425.54, -68.39, -533.96, -1456.70, -57.79, -396.05,
			-1451.99, -55.89, -287.24,  -1454.36, -55.90, 83.96,   -1454.20, 216.11, 98.65,
			-1452.87, 224.14, 177.83,   -1453.40, 224.56, 229.27,  -1452.67, 215.87, 355.44,
			-1449.89, 215.81, 627.29,   -1450.14, 361.87, 608.74,  -1453.59, 361.07, 486.24,
			-1327.15, 363.83, 504.57,   -1239.51, 329.71, 668.51,  -1210.96, 347.49, 842.50,
			-1367.33, 365.19, 843.88,   -1406.65, 374.86, 726.22,  -1406.03, 553.15, 725.06,
			-1403.44, 533.88, 762.18,   -1403.28, 533.88, 1333.28, -1404.87, 533.87, 1443.51,
			-1442.29, 533.87, 1446.10,  -1454.47, 509.87, 1446.66, -2034.36, 509.87, 1446.50,
			-2063.52, 445.76, 1459.55,
		},
		["5.5B"] = {
			-1431.87, -158.67, -873.48, -1424.96, -152.82, -822.06, -1424.77, -121.32, -722.79,
			-1426.29, -88.58, -618.65,  -1427.16, -68.39, -536.15, -1461.72, -57.30, -394.10,
			-1453.87, -55.93, 84.82,    -1454.98, 216.11, 99.75,   -1453.68, 224.88, 180.66,
			-1456.63, 223.76, 232.30,   -1452.24, 215.87, 626.62,  -1452.46, 366.93, 627.78,
			-1452.92, 361.87, 579.11,   -1453.96, 361.07, 504.08,  -1331.20, 364.35, 514.36,
			-1241.33, 329.71, 677.98,   -1216.42, 347.54, 844.06,  -1368.92, 365.35, 836.69,
			-1402.75, 376.90, 724.85,   -1402.75, 539.30, 724.85,  -1405.38, 533.88, 1350.50,
			-1404.88, 533.87, 1445.64,  -1441.26, 533.87, 1445.75, -1446.52, 509.87, 1446.35,
			-2035.74, 509.87, 1446.68,  -2094.89, 443.87, 1481.56, -2165.62, 451.52, 1484.86,
			-2549.40, 466.44, 1490.01,  -2697.74, 443.87, 1489.95, -2729.62, 452.05, 1487.99,
			-2867.48, 468.49, 1486.04,  -2867.48, 521.11, 1486.04, -2928.40, 526.79, 1485.65,
			-2928.40, 595.25, 1485.65,  -2958.89, 609.93, 1485.07, -3008.75, 603.78, 1483.10,
			-3008.75, 668.29, 1483.10,  -3054.34, 673.39, 1488.47, -3212.13, 673.39, 1485.09,
			-3217.26, 675.27, 1459.30,
		},
		["8.5B"] = {
			-1433.02, -159.52, -869.67, -1428.59, -154.05, -826.85, -1427.78, -123.95, -731.15,
			-1428.42, -90.20, -623.81,  -1428.93, -67.41, -522.14, -1452.20, -68.80, -440.25,
			-1453.14, -57.08, -393.24,  -1454.25, -55.89, -267.37, -1454.18, -55.91, 84.47,
			-1454.45, 216.11, 100.26,   -1453.58, 223.98, 177.26,  -1454.73, 224.03, 231.27,
			-1453.55, 215.87, 626.52,   -1452.86, 365.71, 627.28,  -1454.23, 361.87, 579.40,
			-1456.08, 361.07, 498.32,   -1336.42, 363.37, 508.42,  -1238.99, 329.71, 685.68,
			-1218.30, 346.96, 834.93,   -1367.36, 365.20, 844.13,  -1403.20, 375.59, 724.21,
			-1403.19, 540.90, 724.99,   -1402.99, 533.88, 761.45,  -1405.64, 533.87, 1443.05,
			-1447.26, 509.87, 1445.79,  -2034.52, 509.87, 1446.22, -2085.23, 443.87, 1488.17,
			-2163.88, 451.06, 1486.92,  -2359.77, 448.87, 1488.98, -2548.55, 466.12, 1490.73,
			-2731.79, 452.62, 1489.71,  -2862.77, 452.32, 1485.76, -2933.65, 544.98, 1483.74,
			-2940.32, 599.28, 1484.15,  -3001.40, 604.86, 1486.42, -3001.40, 672.88, 1486.42,
			-3053.83, 673.39, 1487.86,  -3230.28, 673.39, 1484.38, -3654.96, 617.72, 1486.37,
			-3657.42, 619.61, 1458.92,
		},
		["16B"] = {
			-1431.72, -159.12, -872.69, -1428.06, -153.11, -824.02, -1426.08, -122.31, -725.91,
			-1427.13, -88.54, -618.53,  -1426.74, -68.39, -534.98, -1452.66, -56.84, -392.25,
			-1455.37, -55.88, 84.21,    -1453.53, 216.11, 99.57,   -1451.46, 224.36, 178.70,
			-1453.51, 224.55, 229.31,   -1453.04, 215.84, 627.21,  -1453.04, 367.44, 627.21,
			-1456.30, 361.87, 581.04,   -1455.61, 361.07, 492.69,  -1330.21, 364.43, 514.23,
			-1238.15, 329.71, 685.43,   -1219.41, 347.42, 840.05,  -1369.37, 365.39, 841.88,
			-1403.97, 377.39, 725.16,   -1402.54, 551.73, 724.95,  -1403.45, 533.88, 774.07,
			-1405.88, 533.88, 1337.24,  -1402.31, 533.87, 1444.93, -1461.29, 509.87, 1445.25,
			-2036.55, 509.87, 1445.69,  -2087.49, 443.87, 1486.65, -2165.76, 451.56, 1488.19,
			-2264.04, 439.87, 1489.49,  -2344.50, 448.87, 1487.88, -2413.29, 440.20, 1489.55,
			-2547.27, 465.65, 1490.39,  -2731.97, 452.62, 1487.08, -2850.23, 446.46, 1487.22,
			-2850.23, 523.62, 1487.22,  -2901.95, 520.39, 1487.17, -2934.32, 527.92, 1481.75,
			-2938.09, 595.92, 1481.87,  -2977.82, 596.39, 1482.81, -2997.56, 595.91, 1484.26,
			-2997.56, 675.90, 1484.26,  -3050.17, 673.39, 1486.26, -3236.83, 673.39, 1485.30,
			-3655.32, 617.72, 1486.84,  -4129.89, 617.72, 1485.43, -4130.41, 619.61, 1457.34,
		},
		["25B"] = {
			-1431.31, -159.32, -872.31, -1429.99, -153.83, -826.17, -1434.67, -68.34, -540.67,
			-1453.40, -57.19, -393.66,  -1455.61, -55.90, 84.65,   -1456.38, 216.12, 101.43,
			-1456.07, 224.37, 178.70,   -1455.89, 224.04, 231.25,  -1458.94, 216.12, 267.89,
			-1454.79, 215.67, 464.94,   -1454.44, 215.87, 627.58,  -1454.44, 371.15, 627.58,
			-1453.81, 361.87, 578.47,   -1454.58, 361.07, 497.03,  -1328.32, 364.85, 517.14,
			-1218.48, 347.46, 841.29,   -1365.69, 365.03, 842.21,  -1404.04, 374.89, 725.22,
			-1403.50, 540.36, 724.54,   -1404.01, 533.87, 1444.92, -1455.63, 509.87, 1446.72,
			-2035.57, 509.87, 1446.86,  -2080.43, 443.87, 1480.52, -2168.08, 452.17, 1486.14,
			-2357.67, 448.87, 1487.47,  -2550.53, 466.77, 1490.38, -2731.52, 452.55, 1486.04,
			-2863.78, 450.34, 1484.93,  -2863.78, 524.58, 1484.93, -2925.02, 529.89, 1485.10,
			-2925.02, 601.39, 1485.10,  -2999.70, 596.11, 1486.59, -2999.70, 672.74, 1486.59,
			-3053.52, 673.39, 1487.78,  -3235.87, 673.39, 1486.06, -3634.26, 617.72, 1486.90,
			-4154.83, 617.72, 1485.66,  -4171.81, 616.57, 1485.02, -4625.86, 617.56, 1444.29,
			-4971.36, 617.73, 1488.09,  -4968.73, 619.62, 1458.22,
		},
		["40B"] = {
			-1432.21, -158.67, -873.61, -1428.62, -153.51, -825.13, -1426.02, -122.02, -724.99,
			-1425.09, -88.67, -618.93,  -1424.79, -68.39, -536.73, -1452.83, -57.63, -395.43,
			-1452.72, -56.01, 84.52,    -1453.85, 216.11, 100.95,  -1453.13, 224.65, 179.77,
			-1457.74, 224.62, 229.05,   -1455.66, 215.87, 353.34,  -1454.41, 215.86, 626.87,
			-1454.41, 367.99, 626.87,   -1456.93, 361.87, 577.47,  -1327.27, 364.87, 516.38,
			-1241.65, 329.71, 685.19,   -1215.39, 347.40, 839.46,  -1371.24, 365.46, 837.88,
			-1404.74, 374.88, 724.18,   -1404.74, 542.18, 724.18,  -1403.99, 533.88, 781.93,
			-1404.26, 533.87, 1444.32,  -1449.70, 509.87, 1446.36, -2034.65, 509.87, 1446.48,
			-2084.12, 443.87, 1487.32,  -2167.33, 451.97, 1485.82, -2362.14, 448.87, 1488.96,
			-2547.68, 465.80, 1489.24,  -2731.44, 452.53, 1487.93, -2845.96, 448.50, 1485.86,
			-2938.11, 519.52, 1485.11,  -2938.11, 594.82, 1485.11, -2989.22, 679.22, 1483.49,
			-3219.92, 673.39, 1485.31,  -3660.67, 617.72, 1483.97, -4131.78, 617.72, 1485.15,
			-4172.54, 616.59, 1484.84,  -4615.42, 616.80, 1444.20, -4967.89, 617.73, 1484.25,
			-5073.06, 625.98, 1485.00,  -5173.10, 676.88, 1482.77, -5356.93, 735.73, 1483.69,
			-5535.50, 794.97, 1486.48,  -5717.14, 852.74, 1486.76, -5740.81, 854.63, 1459.78,
		},
		["65B"] = {
			-1431.96, -158.92, -873.16, -1426.15, -155.09, -830.16, -1429.48, -68.34, -540.94,
			-1451.93, -57.59, -395.26,  -1453.70, -55.89, -278.98, -1453.25, -55.91, 84.79,
			-1452.48, 216.11, 98.46,   -1452.48, 224.52, 179.30,  -1451.44, 224.41, 229.85,
			-1452.21, 215.87, 356.37,  -1454.23, 215.85, 627.62,  -1454.23, 367.26, 627.62,
			-1455.69, 361.87, 581.01,  -1446.29, 361.07, 485.03,  -1339.20, 363.47, 512.27,
			-1241.68, 329.71, 682.80,  -1216.63, 347.20, 837.34,  -1368.56, 365.31, 844.51,
			-1406.61, 374.72, 724.47,  -1406.04, 552.10, 725.04,  -1404.26, 533.88, 758.94,
			-1402.04, 533.87, 1444.76, -1450.33, 509.87, 1446.58, -2033.83, 509.87, 1447.41,
			-2084.75, 443.87, 1486.14, -2169.31, 452.50, 1490.18, -2546.41, 465.32, 1492.77,
			-2727.13, 451.39, 1485.06, -2864.75, 456.90, 1486.13, -2864.75, 525.85, 1486.13,
			-2929.10, 521.47, 1488.71, -2929.10, 597.79, 1488.71, -3011.30, 603.32, 1486.91,
			-3011.30, 675.99, 1486.91, -3055.52, 673.39, 1484.17, -3242.61, 673.39, 1486.13,
			-3656.64, 617.72, 1486.22, -4139.87, 617.72, 1484.30, -4607.34, 617.00, 1442.07,
			-4829.65, 616.95, 1553.17, -4967.82, 617.73, 1484.50, -5179.13, 676.73, 1485.06,
			-5256.07, 685.72, 1488.08, -5357.59, 735.73, 1486.86, -5434.85, 744.46, 1488.08,
			-5534.48, 795.23, 1484.71, -5612.79, 802.92, 1484.40, -5715.81, 853.06, 1486.45,
			-5760.78, 852.74, 1486.77, -5942.59, 851.48, 1439.41, -6076.44, 851.48, 1469.20,
			-6294.50, 851.48, 1525.87, -6370.42, 851.48, 1448.65, -6658.79, 852.75, 1484.75,
			-6662.08, 854.64, 1460.21,
		},
		["100B"] = {
			-1432.21, -158.67, -873.61, -1428.62, -153.51, -825.13, -1426.02, -122.02, -724.99,
			-1425.09, -88.67, -618.93,  -1424.79, -68.39, -536.73, -1452.83, -57.63, -395.43,
			-1452.72, -56.01, 84.52,    -1453.85, 216.11, 100.95,  -1453.13, 224.65, 179.77,
			-1457.74, 224.62, 229.05,   -1455.66, 215.87, 353.34,  -1454.41, 215.86, 626.87,
			-1454.41, 367.99, 626.87,   -1456.93, 361.87, 577.47,  -1327.27, 364.87, 516.38,
			-1241.65, 329.71, 685.19,   -1215.39, 347.40, 839.46,  -1371.24, 365.46, 837.88,
			-1404.74, 374.88, 724.18,   -1404.74, 542.18, 724.18,  -1403.99, 533.88, 781.93,
			-1404.26, 533.87, 1444.32,  -1449.70, 509.87, 1446.36, -2034.65, 509.87, 1446.48,
			-2084.12, 443.87, 1487.32,  -2167.33, 451.97, 1485.82, -2362.14, 448.87, 1488.96,
			-2547.68, 465.80, 1489.24,  -2731.44, 452.53, 1487.93, -2845.96, 448.50, 1485.86,
			-2938.11, 519.52, 1485.11,  -2938.11, 594.82, 1485.11, -2989.22, 679.22, 1483.49,
			-3219.92, 673.39, 1485.31,  -3660.67, 617.72, 1483.97, -4131.78, 617.72, 1485.15,
			-4172.54, 616.59, 1484.84,  -4615.42, 616.80, 1444.20, -4967.89, 617.73, 1484.25,
			-5073.06, 625.98, 1485.00,  -5173.10, 676.88, 1482.77, -5356.93, 735.73, 1483.69,
			-5535.50, 794.97, 1486.48,  -5717.14, 852.74, 1486.76, -5740.40, 852.74, 1485.79,
			-5862.51, 851.48, 1482.00,  -6069.16, 851.48, 1480.36, -6212.12, 851.48, 1604.95,
			-6429.98, 851.48, 1365.79,  -6547.52, 851.48, 1481.12, -6687.09, 852.75, 1487.40,
			-6691.49, 935.17, 1526.34,  -7278.52, 935.17, 1527.35, -7478.82, 934.84, 1615.06,
			-7544.61, 935.17, 1679.40,  -8043.85, 935.17, 1680.06, -8156.35, 935.17, 1682.50,
			-8315.41, 935.17, 1525.50,  -9296.99, 935.17, 1526.07, -9344.72, 852.75, 1508.12,
			-9513.96, 852.76, 1484.80,  -9515.00, 854.64, 1458.11,
		},
		["200B"] = {
			-1431.96, -158.92, -873.16, -1426.15, -155.09, -830.16, -1429.48, -68.34, -540.94,
			-1451.93, -57.59, -395.26,  -1453.70, -55.89, -278.98, -1453.25, -55.91, 84.79,
			-1452.48, 216.11, 98.46,   -1452.48, 224.52, 179.30,  -1451.44, 224.41, 229.85,
			-1452.21, 215.87, 356.37,  -1454.23, 215.85, 627.62,  -1454.23, 367.26, 627.62,
			-1455.69, 361.87, 581.01,  -1446.29, 361.07, 485.03,  -1339.20, 363.47, 512.27,
			-1241.68, 329.71, 682.80,  -1216.63, 347.20, 837.34,  -1368.56, 365.31, 844.51,
			-1406.61, 374.72, 724.47,  -1406.04, 552.10, 725.04,  -1404.26, 533.88, 758.94,
			-1402.04, 533.87, 1444.76, -1450.33, 509.87, 1446.58, -2033.83, 509.87, 1447.41,
			-2084.75, 443.87, 1486.14, -2169.31, 452.50, 1490.18, -2546.41, 465.32, 1492.77,
			-2727.13, 451.39, 1485.06, -2864.75, 456.90, 1486.13, -2864.75, 525.85, 1486.13,
			-2929.10, 521.47, 1488.71, -2929.10, 597.79, 1488.71, -3011.30, 603.32, 1486.91,
			-3011.30, 675.99, 1486.91, -3055.52, 673.39, 1484.17, -3242.61, 673.39, 1486.13,
			-3656.64, 617.72, 1486.22, -4139.87, 617.72, 1484.30, -4607.34, 617.00, 1442.07,
			-4829.65, 616.95, 1553.17, -4967.82, 617.73, 1484.50, -5179.13, 676.73, 1485.06,
			-5256.07, 685.72, 1488.08, -5357.59, 735.73, 1486.86, -5434.85, 744.46, 1488.08,
			-5534.48, 795.23, 1484.71, -5612.79, 802.92, 1484.40, -5715.81, 853.06, 1486.45,
			-5760.78, 852.74, 1486.77, -5942.59, 851.48, 1439.41, -6076.44, 851.48, 1469.20,
			-6294.50, 851.48, 1525.87, -6370.42, 851.48, 1448.65, -6658.79, 852.75, 1484.75,
			-6688.07, 852.90, 1522.44, -6693.09, 935.17, 1527.54, -7274.96, 935.17, 1526.68,
			-7463.34, 935.17, 1597.91, -7544.07, 935.17, 1679.60, -8044.28, 934.65, 1679.06,
			-8158.95, 935.17, 1680.90, -8315.85, 935.17, 1526.05, -9297.00, 935.17, 1525.68,
			-9383.17, 852.75, 1497.72, -9513.67, 852.76, 1484.61, -9616.35, 860.15, 1486.68,
			-9815.02, 861.33, 1486.92, -9956.88, 852.76, 1489.17, -10152.35, 852.76, 1478.86,
			-10207.42, 860.86, 1481.97, -10352.44, 852.76, 1488.02,-10402.05, 861.58, 1485.28,
			-10511.38, 852.76, 1489.48, -10704.16, 861.09, 1493.10,-10804.40, 852.75, 1484.35,
			-10806.13, 854.64, 1459.29,
		},
		["1T"] = {
			-1431.96, -158.92, -873.16, -1426.15, -155.09, -830.16, -1429.48, -68.34, -540.94,
			-1451.93, -57.59, -395.26,  -1453.70, -55.89, -278.98, -1453.25, -55.91, 84.79,
			-1452.48, 216.11, 98.46,   -1452.48, 224.52, 179.30,  -1451.44, 224.41, 229.85,
			-1452.21, 215.87, 356.37,  -1454.23, 215.85, 627.62,  -1454.23, 367.26, 627.62,
			-1455.69, 361.87, 581.01,  -1446.29, 361.07, 485.03,  -1339.20, 363.47, 512.27,
			-1241.68, 329.71, 682.80,  -1216.63, 347.20, 837.34,  -1368.56, 365.31, 844.51,
			-1406.61, 374.72, 724.47,  -1406.04, 552.10, 725.04,  -1404.26, 533.88, 758.94,
			-1402.04, 533.87, 1444.76, -1450.33, 509.87, 1446.58, -2033.83, 509.87, 1447.41,
			-2084.75, 443.87, 1486.14, -2169.31, 452.50, 1490.18, -2546.41, 465.32, 1492.77,
			-2727.13, 451.39, 1485.06, -2864.75, 456.90, 1486.13, -2864.75, 525.85, 1486.13,
			-2929.10, 521.47, 1488.71, -2929.10, 597.79, 1488.71, -3011.30, 603.32, 1486.91,
			-3011.30, 675.99, 1486.91, -3055.52, 673.39, 1484.17, -3242.61, 673.39, 1486.13,
			-3656.64, 617.72, 1486.22, -4139.87, 617.72, 1484.30, -4607.34, 617.00, 1442.07,
			-4829.65, 616.95, 1553.17, -4967.82, 617.73, 1484.50, -5179.13, 676.73, 1485.06,
			-5256.07, 685.72, 1488.08, -5357.59, 735.73, 1486.86, -5434.85, 744.46, 1488.08,
			-5534.48, 795.23, 1484.71, -5612.79, 802.92, 1484.40, -5715.81, 853.06, 1486.45,
			-5760.78, 852.74, 1486.77, -5942.59, 851.48, 1439.41, -6076.44, 851.48, 1469.20,
			-6294.50, 851.48, 1525.87, -6370.42, 851.48, 1448.65, -6658.79, 852.75, 1484.75,
			-6688.07, 852.90, 1522.44, -6693.09, 935.17, 1527.54, -7274.96, 935.17, 1526.68,
			-7463.34, 935.17, 1597.91, -7544.07, 935.17, 1679.60, -8044.28, 934.65, 1679.06,
			-8158.95, 935.17, 1680.90, -8315.85, 935.17, 1526.05, -9297.00, 935.17, 1525.68,
			-9383.17, 852.75, 1497.72, -9513.67, 852.76, 1484.61, -9616.35, 860.15, 1486.68,
			-9815.02, 861.33, 1486.92, -9956.88, 852.76, 1489.17, -10152.35, 852.76, 1478.86,
			-10207.42, 860.86, 1481.97, -10352.44, 852.76, 1488.02,-10402.05, 861.58, 1485.28,
			-10511.38, 852.76, 1489.48, -10704.16, 861.09, 1493.10,-10804.40, 852.75, 1484.35,
			-10807.14, 852.75, 1484.99, -10832.41, 852.75, 1521.11,-10832.41, 992.81, 1521.11,
			-10906.71, 850.74, 1484.42, -12578.12, 850.63, 1487.01,-12609.93, 850.63, 1449.07,
			-12875.68, 897.62, 1443.87,-13377.35, 987.81, 1445.84,-13683.93, 1027.44, 1449.26,
			-14334.57, 1029.46, 1458.59,-14508.47, 1041.37, 1486.16,-14878.42, 1042.12, 1503.89,
			-15250.37, 1043.28, 1486.07,-15409.18, 1029.46, 1485.63,-15845.32, 1015.44, 1486.26,
			-17176.03, 1015.45, 1493.41,-17416.55, 1015.43, 1734.10,-17869.25, 1015.43, 1261.14,
			-18345.84, 1015.43, 1744.44,-18793.70, 1015.43, 1268.23,-19052.30, 1015.45, 1518.14,
			-19214.49, 1015.45, 1517.26,-19546.52, 953.54, 1585.88,-19874.57, 898.67, 1413.42,
			-20207.19, 844.81, 1594.38,-20566.63, 782.59, 1428.02,-20952.81, 733.79, 1519.97,
			-21346.33, 735.41, 1515.16,-21548.93, 721.93, 1519.85,-22096.87, 672.25, 1518.28,
			-23275.21, 674.64, 1516.50,
		},
	}

	local function buildRoutes(raw)
		local out = {}
		for name, flat in pairs(raw) do
			local list = {}
			for i = 1, #flat, 3 do
				table.insert(list, Vector3.new(flat[i], flat[i + 1], flat[i + 2]))
			end
			out[name] = list
		end
		return out
	end

	local ROUTES_W2 = buildRoutes(RAW_W2)
	local ROUTES_W3 = buildRoutes(RAW_W3)

	local ROUTE_ORDER_W2 = { "150K", "400K", "600K", "1M", "1.5M", "2.5M", "4M", "6M", "10M", "15M", "25M", "40M", "60M" }
	local ROUTE_ORDER_W3 = { "300M", "500M", "800M", "1.25B", "2B", "3.5B", "5.5B", "8.5B", "16B", "25B", "40B", "65B", "100B", "200B", "1T" }

	local function makeFarmModule(routes, defaultRoute)
		local state = {
			selectedRoute = defaultRoute,
			autoFarm = false,
			flySpeed = 120,
			flyConn = nil,
			removeConn = nil,
			noclipConn = nil,
		}

		local function stopFly()
			if state.flyConn then state.flyConn:Disconnect() state.flyConn = nil end
		end
		local function stopRemove()
			if state.removeConn then state.removeConn:Disconnect() state.removeConn = nil end
		end
		local function stopNoclip()
			if state.noclipConn then state.noclipConn:Disconnect() state.noclipConn = nil end
		end

		local function startNoclip()
			stopNoclip()
			state.noclipConn = runService.Stepped:Connect(function()
				local char = playersService.LocalPlayer.Character
				if not char then return end
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = false end
				end
			end)
		end

		local function startFly()
			stopFly()
			local waypoints = routes[state.selectedRoute]
			if not waypoints or #waypoints == 0 then return end

			local idx = 1
			state.flyConn = runService.Heartbeat:Connect(function(dt)
				if not state.autoFarm then return end
				local char = playersService.LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if not root then return end
				local target = waypoints[idx]
				if not target then idx = 1 target = waypoints[1] end
				if not target then return end

				local dist = (target - root.Position).Magnitude
				if dist < 0.5 then
					root.CFrame = CFrame.new(target)
					root.AssemblyLinearVelocity = Vector3.zero
					root.AssemblyAngularVelocity = Vector3.zero
					idx = idx + 1
					if idx > #waypoints then idx = 1 end
					return
				end

				local step = math.min(state.flySpeed * dt, dist)
				local dir = (target - root.Position).Unit
				local newPos = root.Position + dir * step
				root.CFrame = CFrame.new(newPos, newPos + dir)
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end)
		end

		state.toggle = function(on)
			state.autoFarm = on
			if on then
				removeObstacles(state.selectedRoute)
				state.removeConn = workspaceService.DescendantAdded:Connect(function(desc)
					if state.autoFarm and shouldRemove(desc.Name, state.selectedRoute) then
						task.defer(function() pcall(function() desc:Destroy() end) end)
					end
				end)
				startNoclip()
				startFly()
			else
				stopRemove()
				stopNoclip()
				stopFly()
			end
		end

		state.setRoute = function(name)
			state.selectedRoute = name
			if state.autoFarm then stopFly() startFly() end
		end

		state.setSpeed = function(v) state.flySpeed = v end

		state.stopAll = function()
			stopRemove()
			stopNoclip()
			stopFly()
		end

		state.getRouteListOrdered = function(order)
			local out = {}
			for _, name in ipairs(order) do
				if routes[name] then table.insert(out, name) end
			end
			return out
		end

		return state
	end

	local WindUI = getWindUILibrary()
	local window = createPotentWindow(WindUI, "POTENTHUB_KEYBOARD_ESCAPE", "+1 Speed Keyboard Escape")

	local tabW2 = window:Tab({ Title = "🌍 WORLD 2", Icon = "globe" })
	local tabW3 = window:Tab({ Title = "🌍 WORLD 3", Icon = "globe" })
	local tabExtra = window:Tab({ Title = "⚙️ Extra", Icon = "settings" })

	local farmW2 = makeFarmModule(ROUTES_W2, ROUTE_ORDER_W2[1])
	local farmW3 = makeFarmModule(ROUTES_W3, ROUTE_ORDER_W3[1])

	tabW2:Section({ Title = "🏆 AUTO FARM WIN" })
	tabW2:Toggle({
		Title = "Auto Farm Win",
		Desc = "Removes obstacles, enables noclip and flies through the route.",
		Value = false,
		Callback = function(state)
			if state and farmW2.selectedRoute == "" then
				WindUI:Notify({ Title = "⚡ POTENT HUB", Content = "Select a Win first!", Duration = 2 })
				return
			end
			farmW2.toggle(state)
		end,
	})
	tabW2:Dropdown({
		Title = "Select Win",
		Desc = "Choose a win route to farm.",
		Values = farmW2.getRouteListOrdered(ROUTE_ORDER_W2),
		Value = ROUTE_ORDER_W2[1],
		Callback = function(value) farmW2.setRoute(value) end,
	})
	tabW2:Slider({
		Title = "Fly Speed",
		Desc = "Adjust the flight speed.",
		Step = 10,
		Value = { Min = 20, Max = 500, Default = 120 },
		Callback = function(value) farmW2.setSpeed(value) end,
	})

	tabW3:Section({ Title = "🏆 AUTO FARM WIN" })
	tabW3:Toggle({
		Title = "Auto Farm Win",
		Desc = "Removes obstacles, enables noclip and flies through the route.",
		Value = false,
		Callback = function(state)
			if state and farmW3.selectedRoute == "" then
				WindUI:Notify({ Title = "⚡ POTENT HUB", Content = "Select a Win first!", Duration = 2 })
				return
			end
			farmW3.toggle(state)
		end,
	})
	tabW3:Dropdown({
		Title = "Select Win",
		Desc = "Choose a win route to farm.",
		Values = farmW3.getRouteListOrdered(ROUTE_ORDER_W3),
		Value = ROUTE_ORDER_W3[1],
		Callback = function(value) farmW3.setRoute(value) end,
	})
	tabW3:Slider({
		Title = "Fly Speed",
		Desc = "Adjust the flight speed.",
		Step = 10,
		Value = { Min = 20, Max = 500, Default = 120 },
		Callback = function(value) farmW3.setSpeed(value) end,
	})

	local SOUND_PACKS = {
		"Premium", "Water", "Bubble", "Christmas",
		"Lava", "Honey", "Snow", "Slime",
	}

	local CONFIG_FILE = "PotentHub/extra_config.json"
	local ExtraConfig = { SoundPack = "Lava" }

	local function saveExtraConfig()
		pcall(function()
			if not writefile then return end
			local HttpService = game:GetService("HttpService")
			local data = {}
			if isfile and isfile(CONFIG_FILE) then
				data = HttpService:JSONDecode(readfile(CONFIG_FILE)) or {}
			end
			if type(data) ~= "table" then data = {} end
			data.SoundPack = ExtraConfig.SoundPack
			if not isfolder or not isfolder("PotentHub") then
				if makefolder then pcall(makefolder, "PotentHub") end
			end
			writefile(CONFIG_FILE, HttpService:JSONEncode(data))
		end)
	end

	local function loadExtraConfig()
		pcall(function()
			if isfile and isfile(CONFIG_FILE) then
				local data = game:GetService("HttpService"):JSONDecode(readfile(CONFIG_FILE))
				if type(data) == "table" and type(data.SoundPack) == "string" then
					ExtraConfig.SoundPack = data.SoundPack
				end
			end
		end)
	end

	loadExtraConfig()

	tabExtra:Section({ Title = "🔓 Admin" })
	tabExtra:Toggle({
		Title = "Unlock Admin (Visual Only)",
		Desc = "Sets HasCmdr / HasAdminAccess attributes (no real admin)",
		Value = false,
		Callback = function(state)
			pcall(function()
				playersService.LocalPlayer:SetAttribute("HasCmdr", state)
				playersService.LocalPlayer:SetAttribute("HasAdminAccess", state)
			end)
		end,
	})

	tabExtra:Section({ Title = "🔊 Sound Changer" })
	tabExtra:Dropdown({
		Title = "Sound Changer",
		Desc = "Change the equipped sound pack",
		Values = SOUND_PACKS,
		Value = ExtraConfig.SoundPack,
		Callback = function(pack)
			ExtraConfig.SoundPack = pack
			saveExtraConfig()
			pcall(function()
				playersService.LocalPlayer:SetAttribute("EquippedSoundPack", pack)
			end)
		end,
	})

	pcall(function()
		playersService.LocalPlayer:SetAttribute("EquippedSoundPack", ExtraConfig.SoundPack)
	end)

	local OLD_SOUND = "rbxassetid://88881892060452"
	local NEW_SOUND = "rbxassetid://138132180123464"

	local function replacePiegesSound()
		pcall(function()
			local pieges = workspaceService:FindFirstChild("Pieges & Lava")
			local twomps = pieges and pieges:FindFirstChild("Twomps")
			if not twomps then return end
			for _, obj in ipairs(twomps:GetDescendants()) do
				if obj:IsA("Sound") and obj.SoundId == OLD_SOUND then
					obj.SoundId = NEW_SOUND
				end
			end
		end)
	end

	replacePiegesSound()

	tabExtra:Section({ Title = "🗝️ Key Finder" })

	local KEY_NAMES = {
		SpecialKey_Normal = true,
		SpecialKey_Secret = true,
	}

	local function findNearestSpecialKey(hrp)
		local roots = {}
		local folder = workspaceService:FindFirstChild("SpecialKeys")
		if folder then
			table.insert(roots, folder)
		else
			table.insert(roots, workspaceService)
		end

		local closest, dist = nil, math.huge
		for _, root in ipairs(roots) do
			for _, obj in ipairs(root:GetDescendants()) do
				if KEY_NAMES[obj.Name] then
					local part
					if obj:IsA("BasePart") then
						part = obj
					elseif obj:IsA("Model") then
						part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
					end
					if part then
						local d = (part.Position - hrp.Position).Magnitude
						if d < dist then
							closest, dist = part, d
						end
					end
				end
			end
		end
		return closest
	end

	local autoTP = false

	task.spawn(function()
		while true do
			if autoTP then
				pcall(function()
					local char = playersService.LocalPlayer.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hrp then
						local target = findNearestSpecialKey(hrp)
						if target then
							hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
						end
					end
				end)
				task.wait(0.2)
			else
				task.wait(0.1)
			end
		end
	end)

	tabExtra:Toggle({
		Title = "Auto TP to Special/Secret Key",
		Desc = "Teleports to the nearest special or secret key",
		Value = false,
		Callback = function(state)
			autoTP = state
		end,
	})

	tabExtra:Section({ Title = "🪙 Coin Farm" })

	local coinFarm = false

	task.spawn(function()
		while true do
			if coinFarm then
				local char = playersService.LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local closest, dist = nil, math.huge
					for _, obj in ipairs(workspaceService:GetDescendants()) do
						if obj.Name == "SummerCoin" then
							local part
							if obj:IsA("BasePart") then
								part = obj
							elseif obj:IsA("Model") then
								part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
							end
							if part then
								local d = (part.Position - hrp.Position).Magnitude
								if d < dist then
									closest, dist = part, d
								end
							end
						end
					end
					if closest then
						hrp.CFrame = closest.CFrame + Vector3.new(0, 2, 0)
					end
				end
				task.wait(0.3)
			else
				task.wait(0.1)
			end
		end
	end)

	tabExtra:Toggle({
		Title = "Coin Farm",
		Desc = "Teleports to nearest SummerCoin",
		Value = false,
		Callback = function(state)
			coinFarm = state
		end,
	})

	tabExtra:Section({ Title = "ℹ️ Info" })
	tabExtra:Button({
		Title = "📋 Copy Discord Link",
		Callback = function()
			customSetClipboard(DISCORD_URL)
			WindUI:Notify({ Title = "⚡ POTENT HUB", Content = "✅ Discord link copied!", Duration = 2 })
		end,
	})

	WindUI:Notify({ Title = "⚡ POTENT HUB", Content = "✅ +1 Speed Keyboard Escape loaded!", Duration = 4 })
end

-- ============================================================
-- ========== JUEGO 6: ONE TAP ==========
-- ============================================================
local function runOneTap()
	local LocalPlayer = playersService.LocalPlayer

	local function deepCopy(value)
		if type(value) ~= "table" then return value end
		local result = {}
		for key, item in pairs(value) do
			result[deepCopy(key)] = deepCopy(item)
		end
		return result
	end

	local function currentCamera()
		return workspace.CurrentCamera
	end

	local function screenCenter()
		local camera = currentCamera()
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		return Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
	end

	local function normalizeAutoShootButton(value)
		value = tostring(value or "RMB"):upper()
		return value == "LMB" and "LMB" or "RMB"
	end

	local DefaultConfig = {
		AimMode = "Custom",
		Aim = {
			Enabled = false,
			HoldRMB = true,
			AimPoint = "Head",
			AutoShoot = false,
			AutoShootButton = "RMB",
			AutoShootRadius = 8,
			AutoShootDelay = 0.00,
			FOV = 180,
			SmoothSpeed = 40,
			MaxDistance = 1500,
			StickyTarget = false,
			StickyMultiplier = 1.35,
			Prediction = false,
			BulletSpeed = 3850,
			PredictionExtra = 0.00,
			PredictionSmoothing = 0.72,
			MaxPredictionOffset = 18,
			AdaptiveSmoothing = false,
			MicroSnapRadius = 1.5,
			TargetPriority = "Hybrid",
			SwitchDelay = 0.05,
			SwitchThreshold = 0.10,
			LockGrace = 0.16,
			ShowFOV = false,
		},
		ESP = {
			Enabled = false,
			Boxes = false,
			Names = false,
			Health = false,
			Distance = false,
			Tracers = false,
			Chams = false,
			MaxDistance = 1500,
		},
	}

	local Config = deepCopy(DefaultConfig)

	local NativeWeaponClient = nil
	local NativeWeaponStatus = "Not scanned"

	local function resolveNativeWeaponClient()
		NativeWeaponClient = nil
		NativeWeaponStatus = "Native WeaponClient unavailable • mouse fallback"

		local playerScripts = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
		local startScript = playerScripts and playerScripts:FindFirstChild("Start")
		local gameFolder = startScript and startScript:FindFirstChild("Game")
		local module = gameFolder and gameFolder:FindFirstChild("WeaponClient")

		if not (module and module:IsA("ModuleScript")) then
			return false
		end

		local okRequire, result = pcall(require, module)
		if okRequire and type(result) == "table" and type(result.fire) == "function" then
			NativeWeaponClient = result
			NativeWeaponStatus = "Native WeaponClient.fire ready"
			return true
		end

		return false
	end

	resolveNativeWeaponClient()

	local function localCharacter()
		return LocalPlayer and LocalPlayer.Character or nil
	end

	local function localCombatReady()
		local character = localCharacter()
		if not character or not character.Parent then
			return false
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return false
		end
		if character:GetAttribute("deployed") ~= true then
			return false
		end
		return true
	end

	local function isMouseHeld(button)
		local inputType = button == "LMB"
			and Enum.UserInputType.MouseButton1
			or Enum.UserInputType.MouseButton2
		local ok, held = pcall(function()
			return userInputService:IsMouseButtonPressed(inputType)
		end)
		return ok and held or false
	end

	local function aimActive()
		if not Config.Aim.Enabled or not localCombatReady() then
			return false
		end
		if Config.Aim.HoldRMB then
			return isMouseHeld("RMB")
		end
		return true
	end

	local function autoShootActive()
		if not Config.Aim.AutoShoot or not localCombatReady() then
			return false
		end
		return isMouseHeld(normalizeAutoShootButton(Config.Aim.AutoShootButton))
	end

	local function isEnemyCharacter(character)
		if not character or character == localCharacter() or not character.Parent then
			return false
		end
		if not collectionService:HasTag(character, "Character") then
			return false
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return false
		end
		if character:FindFirstChildOfClass("ForceField") then
			return false
		end
		return true
	end

	local function iterateEnemies(callback)
		for _, character in ipairs(collectionService:GetTagged("Character")) do
			if isEnemyCharacter(character) then
				callback(character)
			end
		end
	end

	local function getPlayerFromCharacter(character)
		local ok, player = pcall(playersService.GetPlayerFromCharacter, playersService, character)
		return ok and player or nil
	end

	local function getDisplayName(character)
		local player = getPlayerFromCharacter(character)
		if player then
			if player.DisplayName and player.DisplayName ~= "" then
				return player.DisplayName
			end
			return player.Name
		end
		return character and character.Name or "Enemy"
	end

	local function getHealth(character)
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return 0, 100
		end
		return humanoid.Health, math.max(humanoid.MaxHealth, 1)
	end

	local function worldToScreen(position)
		local camera = currentCamera()
		if not camera then
			return Vector2.zero, false, -1
		end
		local point, onScreen = camera:WorldToViewportPoint(position)
		return Vector2.new(point.X, point.Y), onScreen and point.Z > 0, point.Z
	end

	local function getCandidateParts(character)
		local parts = {}
		local names = {
			"Head", "Hitbox_Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart",
		}
		local seen = {}
		for _, name in ipairs(names) do
			local part = character:FindFirstChild(name)
			if part and part:IsA("BasePart") and not seen[part] then
				seen[part] = true
				table.insert(parts, part)
			end
		end
		return parts
	end

	local function getAimPart(character)
		local mode = tostring(Config.Aim.AimPoint or "Head")

		if mode == "Head" then
			local part = character:FindFirstChild("Head") or character:FindFirstChild("Hitbox_Head")
			if part and part:IsA("BasePart") then
				return part
			end
		elseif mode == "Torso" then
			local part = character:FindFirstChild("Torso")
				or character:FindFirstChild("UpperTorso")
				or character:FindFirstChild("HumanoidRootPart")
			if part and part:IsA("BasePart") then
				return part
			end
		elseif mode == "Closest Part" then
			local center = screenCenter()
			local bestPart = nil
			local bestDistance = math.huge
			for _, part in ipairs(getCandidateParts(character)) do
				local screen, onScreen = worldToScreen(part.Position)
				if onScreen then
					local distance = (screen - center).Magnitude
					if distance < bestDistance then
						bestDistance = distance
						bestPart = part
					end
				end
			end
			if bestPart then
				return bestPart
			end
		end

		local fallback = character:FindFirstChild("Torso")
			or character:FindFirstChild("HumanoidRootPart")
			or character:FindFirstChild("Head")
		return fallback and fallback:IsA("BasePart") and fallback or nil
	end

	local velocityCache = setmetatable({}, {__mode = "k"})

	local function getSmoothedVelocity(character, part)
		local raw = part and part.AssemblyLinearVelocity or Vector3.zero
		local entry = velocityCache[character]
		local smoothing = math.clamp(tonumber(Config.Aim.PredictionSmoothing) or 0, 0, 0.98)
		if not entry then
			entry = {Velocity = raw}
			velocityCache[character] = entry
			return raw
		end
		entry.Velocity = entry.Velocity:Lerp(raw, 1 - smoothing)
		return entry.Velocity
	end

	local function predictPosition(character, part, rawPosition, worldDistance)
		if not Config.Aim.Prediction then
			return rawPosition
		end
		local bulletSpeed = math.max(tonumber(Config.Aim.BulletSpeed) or 3850, 100)
		local extra = math.clamp(tonumber(Config.Aim.PredictionExtra) or 0, 0, 0.25)
		local travelTime = math.clamp(worldDistance / bulletSpeed + extra, 0, 0.35)
		local velocity = getSmoothedVelocity(character, part)
		local offset = velocity * travelTime
		local maxOffset = math.max(tonumber(Config.Aim.MaxPredictionOffset) or 0, 0)
		if maxOffset > 0 and offset.Magnitude > maxOffset then
			offset = offset.Unit * maxOffset
		end
		return rawPosition + offset
	end

	local function isVisible(character, position)
		local camera = currentCamera()
		local localChar = localCharacter()
		if not camera or not localChar then
			return false
		end
		local ignore = {localChar, character}
		local effects = workspace:FindFirstChild("Effects")
		if effects then
			table.insert(ignore, effects)
		end
		local viewmodel = camera:FindFirstChildWhichIsA("Model")
		if viewmodel then
			table.insert(ignore, viewmodel)
		end
		local ok, obscuring = pcall(function()
			return camera:GetPartsObscuringTarget({position}, ignore)
		end)
		return ok and #obscuring == 0
	end

	local lockedTarget = nil
	local lockedTargetLastInfo = nil
	local lockedTargetLastValidAt = 0
	local lastTargetSwitchAt = 0

	local function scoreTarget(screenDistance, worldDistance, health, maxHealth)
		local fov = math.max(tonumber(Config.Aim.FOV) or 1, 1)
		local maxDistance = math.max(tonumber(Config.Aim.MaxDistance) or 1, 1)
		local screenNorm = math.clamp(screenDistance / fov, 0, 2)
		local worldNorm = math.clamp(worldDistance / maxDistance, 0, 2)
		local healthNorm = math.clamp(health / math.max(maxHealth, 1), 0, 1)
		local priority = tostring(Config.Aim.TargetPriority or "Hybrid")
		if priority == "Distance" then
			return worldNorm
		elseif priority == "Low Health" then
			return healthNorm + screenNorm * 0.15
		elseif priority == "Crosshair" then
			return screenNorm
		end
		return screenNorm * 0.72 + worldNorm * 0.18 + healthNorm * 0.10
	end

	local function targetInfo(character, fovMultiplier)
		if not isEnemyCharacter(character) then
			return nil
		end
		local camera = currentCamera()
		if not camera then
			return nil
		end
		local part = getAimPart(character)
		if not part then
			return nil
		end
		local rawPosition = part.Position
		local worldDistance = (rawPosition - camera.CFrame.Position).Magnitude
		if worldDistance > math.max(tonumber(Config.Aim.MaxDistance) or 0, 1) then
			return nil
		end
		local position = predictPosition(character, part, rawPosition, worldDistance)
		local screenPosition, onScreen = worldToScreen(position)
		if not onScreen then
			return nil
		end
		local screenDistance = (screenPosition - screenCenter()).Magnitude
		local allowedFOV = math.max(tonumber(Config.Aim.FOV) or 0, 1) * (fovMultiplier or 1)
		if screenDistance > allowedFOV then
			return nil
		end
		if not isVisible(character, position) then
			return nil
		end
		local health, maxHealth = getHealth(character)
		return {
			Entity = character,
			Part = part,
			RawPosition = rawPosition,
			Position = position,
			ScreenPosition = screenPosition,
			ScreenDistance = screenDistance,
			WorldDistance = worldDistance,
			Health = health,
			MaxHealth = maxHealth,
			Score = scoreTarget(screenDistance, worldDistance, health, maxHealth),
		}
	end

	local function clearTarget()
		lockedTarget = nil
		lockedTargetLastInfo = nil
		lockedTargetLastValidAt = 0
	end

	local function acquireTarget()
		local now = os.clock()
		local stickyScale = Config.Aim.StickyTarget
			and math.max(tonumber(Config.Aim.StickyMultiplier) or 1, 1)
			or 1

		local lockedInfo = nil
		if lockedTarget then
			lockedInfo = targetInfo(lockedTarget, stickyScale)
			if lockedInfo then
				lockedTargetLastInfo = lockedInfo
				lockedTargetLastValidAt = now
			end
		end

		local bestInfo = nil
		iterateEnemies(function(character)
			local info = targetInfo(character, 1)
			if info and (not bestInfo or info.Score < bestInfo.Score) then
				bestInfo = info
			end
		end)

		if not lockedTarget then
			if bestInfo then
				lockedTarget = bestInfo.Entity
				lockedTargetLastInfo = bestInfo
				lockedTargetLastValidAt = now
				lastTargetSwitchAt = now
			end
			return bestInfo
		end

		if lockedInfo then
			if not bestInfo or bestInfo.Entity == lockedTarget then
				return lockedInfo
			end

			if not Config.Aim.StickyTarget then
				lockedTarget = bestInfo.Entity
				lockedTargetLastInfo = bestInfo
				lockedTargetLastValidAt = now
				lastTargetSwitchAt = now
				return bestInfo
			end

			local switchDelay = math.max(tonumber(Config.Aim.SwitchDelay) or 0, 0)
			if now - lastTargetSwitchAt < switchDelay then
				return lockedInfo
			end

			local threshold = math.clamp(tonumber(Config.Aim.SwitchThreshold) or 0, 0, 0.95)
			local requiredScore = lockedInfo.Score * (1 - threshold)
			if bestInfo.Score < requiredScore then
				lockedTarget = bestInfo.Entity
				lockedTargetLastInfo = bestInfo
				lockedTargetLastValidAt = now
				lastTargetSwitchAt = now
				return bestInfo
			end

			return lockedInfo
		end

		local grace = math.max(tonumber(Config.Aim.LockGrace) or 0, 0)
		if lockedTargetLastInfo and isEnemyCharacter(lockedTarget)
			and now - lockedTargetLastValidAt <= grace
		then
			return lockedTargetLastInfo
		end

		if bestInfo then
			lockedTarget = bestInfo.Entity
			lockedTargetLastInfo = bestInfo
			lockedTargetLastValidAt = now
			lastTargetSwitchAt = now
			return bestInfo
		end

		clearTarget()
		return nil
	end

	local lastAutoShootTarget = nil
	local lastAutoShotAttemptAt = 0
	local lastAutoShotAt = 0

	local function fireNativeOrFallback()
		if not NativeWeaponClient then
			resolveNativeWeaponClient()
		end
		if NativeWeaponClient and type(NativeWeaponClient.fire) == "function" then
			local ok = pcall(NativeWeaponClient.fire)
			if ok then
				return true
			end
			NativeWeaponClient = nil
		end
		if type(mouse1click) == "function" then
			return pcall(mouse1click)
		end
		return false
	end

	local function tryAutoShoot(info)
		if not autoShootActive() or not info or not info.Entity then
			return
		end
		if lockedTarget ~= info.Entity or not isEnemyCharacter(info.Entity) then
			return
		end
		local fresh = targetInfo(info.Entity, math.max(tonumber(Config.Aim.StickyMultiplier) or 1, 1))
		if not fresh then
			return
		end
		local screenPosition, onScreen = worldToScreen(fresh.Position)
		if not onScreen then
			return
		end
		local errorPixels = (screenPosition - screenCenter()).Magnitude
		local radius = math.clamp(tonumber(Config.Aim.AutoShootRadius) or 8, 1, 50)
		if errorPixels > radius then
			return
		end
		local now = os.clock()
		local delay = math.max(tonumber(Config.Aim.AutoShootDelay) or 0, 0)
		if lastAutoShootTarget ~= info.Entity then
			lastAutoShootTarget = info.Entity
			lastAutoShotAttemptAt = 0
		end
		if now - lastAutoShotAttemptAt < math.max(delay, 0.02) then
			return
		end
		lastAutoShotAttemptAt = now
		if fireNativeOrFallback() then
			lastAutoShotAt = now
		end
	end

	local function applyAim(dt)
		local shouldAim = aimActive()
		local shouldShoot = autoShootActive()

		if not shouldAim and not shouldShoot then
			if not localCombatReady() or (not Config.Aim.Enabled and not Config.Aim.AutoShoot) then
				clearTarget()
			end
			return
		end

		local info = acquireTarget()
		if not info then
			return
		end

		local camera = currentCamera()
		if not camera then
			return
		end

		if shouldAim then
			local current = camera.CFrame
			local desired = CFrame.lookAt(current.Position, info.Position)
			local speed = math.max(tonumber(Config.Aim.SmoothSpeed) or 0.01, 0.01)

			if Config.Aim.AdaptiveSmoothing then
				local normalized = math.clamp(info.ScreenDistance / math.max(Config.Aim.FOV, 1), 0, 1)
				speed = speed * (0.58 + math.sqrt(normalized) * 1.42)
			end

			local snapRadius = math.max(tonumber(Config.Aim.MicroSnapRadius) or 0, 0)
			local alpha = 1 - math.exp(-speed * math.max(dt, 0))
			if snapRadius > 0 and info.ScreenDistance <= snapRadius then
				alpha = 1
			end

			camera.CFrame = current:Lerp(desired, math.clamp(alpha, 0, 1))
		end

		if shouldShoot then
			tryAutoShoot(info)
		end
	end

	local function getOverlayParent()
		if type(gethui) == "function" then
			local ok, parent = pcall(gethui)
			if ok and typeof(parent) == "Instance" then
				return parent
			end
		end
		local okCore = pcall(function() return coreGui.Name end)
		if okCore then
			return coreGui
		end
		return LocalPlayer:WaitForChild("PlayerGui")
	end

	local OverlayParent = getOverlayParent()
	local oldOverlay = OverlayParent:FindFirstChild("POTENT_Overlay")
	if oldOverlay then
		oldOverlay:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "POTENT_Overlay"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 999999
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = OverlayParent

	local OverlayFolder = Instance.new("Frame")
	OverlayFolder.Name = "ESP"
	OverlayFolder.Size = UDim2.fromScale(1, 1)
	OverlayFolder.BackgroundTransparency = 1
	OverlayFolder.BorderSizePixel = 0
	OverlayFolder.Parent = ScreenGui

	local espObjects = {}

	local function makeStroke(parent, thickness)
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = thickness or 1
		stroke.Color = Color3.fromRGB(255, 78, 78)
		stroke.Transparency = 0
		stroke.Parent = parent
		return stroke
	end

	local function makeText(parent)
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Font = Enum.Font.GothamMedium
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		label.TextStrokeTransparency = 0.35
		label.TextSize = 13
		label.ZIndex = 10
		label.Parent = parent
		return label
	end

	local function createESP(character)
		if espObjects[character] then
			return espObjects[character]
		end

		local holder = Instance.new("Frame")
		holder.Name = "EntityESP"
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.Visible = false
		holder.ZIndex = 5
		holder.Parent = OverlayFolder

		local box = Instance.new("Frame")
		box.Name = "Box"
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 0
		box.Size = UDim2.fromScale(1, 1)
		box.ZIndex = 5
		box.Parent = holder
		local boxStroke = makeStroke(box, 1.5)

		local nameLabel = makeText(holder)
		nameLabel.Name = "Name"
		nameLabel.AnchorPoint = Vector2.new(0.5, 1)
		nameLabel.Position = UDim2.new(0.5, 0, 0, -3)
		nameLabel.Size = UDim2.new(1.8, 0, 0, 18)
		nameLabel.TextXAlignment = Enum.TextXAlignment.Center

		local infoLabel = makeText(holder)
		infoLabel.Name = "Info"
		infoLabel.AnchorPoint = Vector2.new(0.5, 0)
		infoLabel.Position = UDim2.new(0.5, 0, 1, 3)
		infoLabel.Size = UDim2.new(1.9, 0, 0, 18)
		infoLabel.TextXAlignment = Enum.TextXAlignment.Center

		local hpBack = Instance.new("Frame")
		hpBack.Name = "HealthBack"
		hpBack.AnchorPoint = Vector2.new(1, 0)
		hpBack.Position = UDim2.new(0, -4, 0, 0)
		hpBack.Size = UDim2.new(0, 4, 1, 0)
		hpBack.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		hpBack.BorderSizePixel = 0
		hpBack.ZIndex = 6
		hpBack.Parent = holder

		local hpFill = Instance.new("Frame")
		hpFill.Name = "Health"
		hpFill.AnchorPoint = Vector2.new(0, 1)
		hpFill.Position = UDim2.new(0, 0, 1, 0)
		hpFill.Size = UDim2.fromScale(1, 1)
		hpFill.BackgroundColor3 = Color3.fromRGB(85, 255, 110)
		hpFill.BorderSizePixel = 0
		hpFill.ZIndex = 7
		hpFill.Parent = hpBack

		local tracer = Instance.new("Frame")
		tracer.Name = "Tracer"
		tracer.AnchorPoint = Vector2.new(0, 0.5)
		tracer.BackgroundColor3 = Color3.fromRGB(255, 78, 78)
		tracer.BorderSizePixel = 0
		tracer.Size = UDim2.fromOffset(0, 1)
		tracer.Visible = false
		tracer.ZIndex = 3
		tracer.Parent = OverlayFolder

		local highlight = Instance.new("Highlight")
		highlight.Name = "POTENT_Highlight"
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.FillColor = Color3.fromRGB(255, 60, 60)
		highlight.FillTransparency = 0.82
		highlight.OutlineColor = Color3.fromRGB(255, 115, 115)
		highlight.OutlineTransparency = 0
		highlight.Enabled = false
		highlight.Parent = workspace

		local object = {
			Holder = holder,
			Box = box,
			BoxStroke = boxStroke,
			Name = nameLabel,
			Info = infoLabel,
			HealthBack = hpBack,
			HealthFill = hpFill,
			Tracer = tracer,
			Highlight = highlight,
		}

		espObjects[character] = object
		return object
	end

	local function hideESPObject(object)
		if not object then return end
		object.Holder.Visible = false
		object.Tracer.Visible = false
		object.Highlight.Enabled = false
	end

	local function removeESP(character)
		local object = espObjects[character]
		if not object then return end
		for _, instance in pairs(object) do
			if typeof(instance) == "Instance" then
				pcall(function() instance:Destroy() end)
			end
		end
		espObjects[character] = nil
	end

	local function getBounds(character)
		if not character or not character:IsA("Model") then
			return nil
		end
		local ok, cf, size = pcall(character.GetBoundingBox, character)
		if not ok or typeof(cf) ~= "CFrame" or typeof(size) ~= "Vector3" then
			return nil
		end
		size = size + Vector3.new(0.25, 0.35, 0.25)
		local half = size * 0.5
		local corners = {
			Vector3.new(-half.X, -half.Y, -half.Z),
			Vector3.new(-half.X, -half.Y,  half.Z),
			Vector3.new(-half.X,  half.Y, -half.Z),
			Vector3.new(-half.X,  half.Y,  half.Z),
			Vector3.new( half.X, -half.Y, -half.Z),
			Vector3.new( half.X, -half.Y,  half.Z),
			Vector3.new( half.X,  half.Y, -half.Z),
			Vector3.new( half.X,  half.Y,  half.Z),
		}
		local minX, minY = math.huge, math.huge
		local maxX, maxY = -math.huge, -math.huge
		local anyInFront = false
		local camera = currentCamera()
		if not camera then
			return nil
		end
		for _, localCorner in ipairs(corners) do
			local worldCorner = cf:PointToWorldSpace(localCorner)
			local point = camera:WorldToViewportPoint(worldCorner)
			if point.Z > 0 then
				anyInFront = true
				minX = math.min(minX, point.X)
				minY = math.min(minY, point.Y)
				maxX = math.max(maxX, point.X)
				maxY = math.max(maxY, point.Y)
			end
		end
		if not anyInFront or minX == math.huge then
			return nil
		end
		local width = maxX - minX
		local height = maxY - minY
		if width < 2 or height < 2 then
			return nil
		end
		return minX, minY, width, height
	end

	local function updateTracer(frame, from, to)
		local delta = to - from
		frame.Position = UDim2.fromOffset(from.X, from.Y)
		frame.Size = UDim2.fromOffset(delta.Magnitude, 1)
		frame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	end

	local function updateESP()
		if not Config.ESP.Enabled or not localCombatReady() then
			for _, object in pairs(espObjects) do
				hideESPObject(object)
			end
			return
		end
		local camera = currentCamera()
		if not camera then
			return
		end
		local seen = {}
		iterateEnemies(function(character)
			seen[character] = true
			local part = getAimPart(character)
				or character:FindFirstChild("HumanoidRootPart")
				or character:FindFirstChild("Torso")
				or character:FindFirstChild("Head")
			if not (part and part:IsA("BasePart")) then
				local old = espObjects[character]
				if old then hideESPObject(old) end
				return
			end
			local distance = (part.Position - camera.CFrame.Position).Magnitude
			if distance > math.max(tonumber(Config.ESP.MaxDistance) or 1, 1) then
				local old = espObjects[character]
				if old then hideESPObject(old) end
				return
			end
			local object = createESP(character)
			local minX, minY, width, height = getBounds(character)
			local locked = character == lockedTarget
			local mainColor = locked
				and Color3.fromRGB(100, 255, 125)
				or Color3.fromRGB(255, 78, 78)
			object.BoxStroke.Color = mainColor
			object.Tracer.BackgroundColor3 = mainColor
			object.Highlight.FillColor = mainColor
			object.Highlight.OutlineColor = mainColor
			object.Highlight.Adornee = character
			object.Highlight.Enabled = Config.ESP.Chams
			if minX then
				object.Holder.Visible = true
				object.Holder.Position = UDim2.fromOffset(minX, minY)
				object.Holder.Size = UDim2.fromOffset(width, height)
				object.Box.Visible = Config.ESP.Boxes
				object.Name.Visible = Config.ESP.Names
				object.Name.Text = getDisplayName(character)
				local health, maxHealth = getHealth(character)
				local ratio = math.clamp(health / math.max(maxHealth, 1), 0, 1)
				object.HealthBack.Visible = Config.ESP.Health
				object.HealthFill.Size = UDim2.fromScale(1, ratio)
				local info = {}
				if Config.ESP.Health then
					table.insert(info, ("%d HP"):format(math.max(0, math.floor(health + 0.5))))
				end
				if Config.ESP.Distance then
					table.insert(info, ("%d studs"):format(math.floor(distance + 0.5)))
				end
				object.Info.Visible = #info > 0
				object.Info.Text = table.concat(info, "  •  ")
				if Config.ESP.Tracers then
					local from = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y - 2)
					local to = Vector2.new(minX + width * 0.5, minY + height)
					updateTracer(object.Tracer, from, to)
					object.Tracer.Visible = true
				else
					object.Tracer.Visible = false
				end
			else
				object.Holder.Visible = false
				object.Tracer.Visible = false
			end
		end)
		for character in pairs(espObjects) do
			if not seen[character] or not isEnemyCharacter(character) then
				removeESP(character)
			end
		end
	end

	local FOVRing = Instance.new("Frame")
	FOVRing.Name = "FOV"
	FOVRing.AnchorPoint = Vector2.new(0.5, 0.5)
	FOVRing.BackgroundTransparency = 1
	FOVRing.BorderSizePixel = 0
	FOVRing.ZIndex = 2
	FOVRing.Parent = ScreenGui

	local FOVCorner = Instance.new("UICorner")
	FOVCorner.CornerRadius = UDim.new(1, 0)
	FOVCorner.Parent = FOVRing

	local FOVStroke = Instance.new("UIStroke")
	FOVStroke.Thickness = 1
	FOVStroke.Transparency = 0.25
	FOVStroke.Color = Color3.fromRGB(255, 255, 255)
	FOVStroke.Parent = FOVRing

	local function updateFOV()
		local center = screenCenter()
		local diameter = math.max(tonumber(Config.Aim.FOV) or 1, 1) * 2
		FOVRing.Position = UDim2.fromOffset(center.X, center.Y)
		FOVRing.Size = UDim2.fromOffset(diameter, diameter)
		FOVRing.Visible = Config.Aim.ShowFOV and Config.Aim.Enabled and localCombatReady()
		FOVStroke.Color = lockedTarget
			and Color3.fromRGB(100, 255, 125)
			or Color3.fromRGB(255, 255, 255)
	end

	local WindUI = getWindUILibrary()
	local window = createPotentWindow(WindUI, "POTENTHUB_ONETAP", "+1 One Tap")

	local combatTab = window:Tab({ Title = "⚔️ Combat", Icon = "swords" })
	local legitTab = window:Tab({ Title = "🎯 Legit", Icon = "crosshair" })
	local rageTab = window:Tab({ Title = "💀 Rage", Icon = "skull" })
	local visualTab = window:Tab({ Title = "👁️ Visuals", Icon = "eye" })
	local settingsTab = window:Tab({ Title = "⚙️ Settings", Icon = "settings" })

	local UIControls = {}
	local syncUIFromConfig
	local LegitModeLabel
	local RageModeLabel
	local BackendStatusLabel
	local cleanup
	local running = true

	local function backendStatusText()
		local tagged = #collectionService:GetTagged("Character")
		return ("Backend • Character tag: %d • %s"):format(tagged, NativeWeaponStatus)
	end

	combatTab:Section({ Title = "🔗 Game Integration" })
	BackendStatusLabel = combatTab:Paragraph({ Title = "Backend Status", Desc = backendStatusText() })
	combatTab:Paragraph({ Title = "Info", Desc = "Targets use Character tag + Head/Torso rigs. Aimbot only locks onto visible enemies." })

	combatTab:Section({ Title = "🎯 Auto Aim" })
	UIControls.AimEnabled = combatTab:Toggle({
		Title = "Enable Auto Aim",
		Value = Config.Aim.Enabled,
		Callback = function(value)
			Config.Aim.Enabled = value
			if not value then clearTarget() end
		end,
	})

	UIControls.AimActivation = combatTab:Dropdown({
		Title = "Aim Activation",
		Values = {"Hold RMB", "Always On"},
		Value = Config.Aim.HoldRMB and "Hold RMB" or "Always On",
		Callback = function(value)
			Config.Aim.HoldRMB = value ~= "Always On"
			Config.AimMode = "Custom"
			clearTarget()
		end,
	})

	combatTab:Section({ Title = "🔫 Auto Shoot" })
	UIControls.AutoShoot = combatTab:Toggle({
		Title = "Enable Auto Shoot",
		Value = Config.Aim.AutoShoot,
		Callback = function(value)
			Config.Aim.AutoShoot = value
			lastAutoShootTarget = nil
			lastAutoShotAttemptAt = 0
		end,
	})

	UIControls.AutoShootButton = combatTab:Dropdown({
		Title = "Auto Shoot Button",
		Values = {"RMB", "LMB"},
		Value = normalizeAutoShootButton(Config.Aim.AutoShootButton),
		Callback = function(value)
			Config.Aim.AutoShootButton = normalizeAutoShootButton(value)
			lastAutoShootTarget = nil
		end,
	})

	UIControls.AutoShootRadius = combatTab:Slider({
		Title = "Shoot Radius (px)",
		Step = 1,
		Value = { Min = 2, Max = 30, Default = Config.Aim.AutoShootRadius },
		Callback = function(value) Config.Aim.AutoShootRadius = value end,
	})

	UIControls.AutoShootDelay = combatTab:Slider({
		Title = "Extra Shot Delay (s)",
		Step = 0.01,
		Value = { Min = 0, Max = 0.50, Default = Config.Aim.AutoShootDelay },
		Callback = function(value) Config.Aim.AutoShootDelay = value end,
	})

	combatTab:Paragraph({ Title = "Auto Shoot", Desc = "Uses the native WeaponClient.fire when available." })

	combatTab:Section({ Title = "🎯 Aim Point / Lock" })
	UIControls.AimPoint = combatTab:Dropdown({
		Title = "Aim Point",
		Values = {"Head", "Torso", "Closest Part"},
		Value = Config.Aim.AimPoint,
		Callback = function(value)
			Config.Aim.AimPoint = value or "Head"
			Config.AimMode = "Custom"
			clearTarget()
		end,
	})

	UIControls.StickyTarget = combatTab:Toggle({
		Title = "Sticky Target",
		Value = Config.Aim.StickyTarget,
		Callback = function(value)
			Config.Aim.StickyTarget = value
			if not value then clearTarget() end
		end,
	})

	combatTab:Section({ Title = "🎯 FOV / Response" })
	UIControls.ShowFOV = combatTab:Toggle({
		Title = "Show FOV Circle",
		Value = Config.Aim.ShowFOV,
		Callback = function(value) Config.Aim.ShowFOV = value end,
	})

	UIControls.FOV = combatTab:Slider({
		Title = "FOV Radius (px)",
		Step = 5,
		Value = { Min = 40, Max = 700, Default = Config.Aim.FOV },
		Callback = function(value)
			Config.Aim.FOV = value
			Config.AimMode = "Custom"
		end,
	})

	UIControls.AimSpeed = combatTab:Slider({
		Title = "Aim Speed",
		Step = 1,
		Value = { Min = 4, Max = 140, Default = Config.Aim.SmoothSpeed },
		Callback = function(value)
			Config.Aim.SmoothSpeed = value
			Config.AimMode = "Custom"
		end,
	})

	UIControls.AimDistance = combatTab:Slider({
		Title = "Aim Max Distance (studs)",
		Step = 25,
		Value = { Min = 100, Max = 1500, Default = Config.Aim.MaxDistance },
		Callback = function(value)
			Config.Aim.MaxDistance = value
			clearTarget()
		end,
	})

	combatTab:Section({ Title = "🧠 Advanced Targeting" })
	UIControls.TargetPriority = combatTab:Dropdown({
		Title = "Target Priority",
		Values = {"Crosshair", "Distance", "Low Health", "Hybrid"},
		Value = Config.Aim.TargetPriority,
		Callback = function(value)
			Config.Aim.TargetPriority = value or "Hybrid"
			clearTarget()
		end,
	})

	UIControls.Prediction = combatTab:Toggle({
		Title = "Projectile Prediction",
		Value = Config.Aim.Prediction,
		Callback = function(value) Config.Aim.Prediction = value end,
	})

	UIControls.BulletSpeed = combatTab:Slider({
		Title = "Projectile Speed (studs/s)",
		Step = 50,
		Value = { Min = 500, Max = 6000, Default = Config.Aim.BulletSpeed },
		Callback = function(value) Config.Aim.BulletSpeed = value end,
	})

	UIControls.PredictionExtra = combatTab:Slider({
		Title = "Extra Prediction (s)",
		Step = 0.005,
		Value = { Min = 0, Max = 0.20, Default = Config.Aim.PredictionExtra },
		Callback = function(value) Config.Aim.PredictionExtra = value end,
	})

	UIControls.PredictionSmoothing = combatTab:Slider({
		Title = "Prediction Stability",
		Step = 0.01,
		Value = { Min = 0, Max = 0.95, Default = Config.Aim.PredictionSmoothing },
		Callback = function(value) Config.Aim.PredictionSmoothing = value end,
	})

	UIControls.MaxPredictionOffset = combatTab:Slider({
		Title = "Max Prediction Offset (studs)",
		Step = 1,
		Value = { Min = 0, Max = 30, Default = Config.Aim.MaxPredictionOffset },
		Callback = function(value) Config.Aim.MaxPredictionOffset = value end,
	})

	UIControls.AdaptiveSmoothing = combatTab:Toggle({
		Title = "Adaptive Smoothing",
		Value = Config.Aim.AdaptiveSmoothing,
		Callback = function(value) Config.Aim.AdaptiveSmoothing = value end,
	})

	UIControls.MicroSnap = combatTab:Slider({
		Title = "Micro Snap Radius (px)",
		Step = 0.5,
		Value = { Min = 0, Max = 10, Default = Config.Aim.MicroSnapRadius },
		Callback = function(value) Config.Aim.MicroSnapRadius = value end,
	})

	UIControls.SwitchDelay = combatTab:Slider({
		Title = "Target Switch Delay (s)",
		Step = 0.01,
		Value = { Min = 0, Max = 0.30, Default = Config.Aim.SwitchDelay },
		Callback = function(value) Config.Aim.SwitchDelay = value end,
	})

	UIControls.SwitchThreshold = combatTab:Slider({
		Title = "Switch Improvement Required",
		Step = 0.01,
		Value = { Min = 0, Max = 0.50, Default = Config.Aim.SwitchThreshold },
		Callback = function(value) Config.Aim.SwitchThreshold = value end,
	})

	UIControls.LockGrace = combatTab:Slider({
		Title = "Target Lock Grace (s)",
		Step = 0.01,
		Value = { Min = 0, Max = 0.50, Default = Config.Aim.LockGrace },
		Callback = function(value) Config.Aim.LockGrace = value end,
	})

	local function updateAimModeLabels()
		local text = "Current mode • " .. tostring(Config.AimMode or "Custom")
		if LegitModeLabel and LegitModeLabel.SetDesc then LegitModeLabel:SetDesc(text) end
		if RageModeLabel and RageModeLabel.SetDesc then RageModeLabel:SetDesc(text) end
	end

	local function applyAimPreset(name, values, notification)
		Config.AimMode = name
		for key, value in pairs(values or {}) do
			if Config.Aim[key] ~= nil then
				Config.Aim[key] = value
			end
		end
		clearTarget()
		if syncUIFromConfig then syncUIFromConfig() end
		updateAimModeLabels()
		WindUI:Notify({ Title = name, Content = notification or (name .. " applied"), Duration = 2.2 })
	end

	legitTab:Section({ Title = "🎯 Legit Aim" })
	LegitModeLabel = legitTab:Paragraph({ Title = "Current Mode", Desc = "Current mode • " .. tostring(Config.AimMode) })

	legitTab:Button({
		Title = "Legit • Subtle",
		Callback = function()
			applyAimPreset("Legit • Subtle", {
				Enabled = true, HoldRMB = true, AimPoint = "Head",
				FOV = 75, SmoothSpeed = 12, StickyTarget = true, StickyMultiplier = 1.15,
				Prediction = true, BulletSpeed = 3850, PredictionExtra = 0,
				PredictionSmoothing = 0.84, MaxPredictionOffset = 10, AdaptiveSmoothing = true,
				MicroSnapRadius = 0.5, TargetPriority = "Hybrid",
				SwitchDelay = 0.12, SwitchThreshold = 0.22, LockGrace = 0.24, ShowFOV = false,
			}, "Hold RMB • 75px FOV • smooth visible-target aim")
		end,
	})

	legitTab:Button({
		Title = "Legit • Balanced",
		Callback = function()
			applyAimPreset("Legit • Balanced", {
				Enabled = true, HoldRMB = true, AimPoint = "Head",
				FOV = 120, SmoothSpeed = 22, StickyTarget = true, StickyMultiplier = 1.22,
				Prediction = true, BulletSpeed = 3850, PredictionExtra = 0,
				PredictionSmoothing = 0.78, MaxPredictionOffset = 14, AdaptiveSmoothing = true,
				MicroSnapRadius = 1, TargetPriority = "Hybrid",
				SwitchDelay = 0.08, SwitchThreshold = 0.18, LockGrace = 0.21, ShowFOV = true,
			}, "Hold RMB • 120px FOV • balanced response")
		end,
	})

	legitTab:Button({
		Title = "Legit • Strong",
		Callback = function()
			applyAimPreset("Legit • Strong", {
				Enabled = true, HoldRMB = true, AimPoint = "Head",
				FOV = 190, SmoothSpeed = 38, StickyTarget = true, StickyMultiplier = 1.30,
				Prediction = true, BulletSpeed = 3850, PredictionExtra = 0,
				PredictionSmoothing = 0.72, MaxPredictionOffset = 18, AdaptiveSmoothing = true,
				MicroSnapRadius = 1.5, TargetPriority = "Crosshair",
				SwitchDelay = 0.05, SwitchThreshold = 0.12, LockGrace = 0.17, ShowFOV = true,
			}, "Hold RMB • 190px FOV • fast visible-target response")
		end,
	})

	rageTab:Section({ Title = "💀 Rage Aim" })
	RageModeLabel = rageTab:Paragraph({ Title = "Current Mode", Desc = "Current mode • " .. tostring(Config.AimMode) })

	rageTab:Button({
		Title = "Rage • Visible",
		Callback = function()
			applyAimPreset("Rage • Visible", {
				Enabled = true, HoldRMB = false, AimPoint = "Head",
				FOV = 520, SmoothSpeed = 100, StickyTarget = true, StickyMultiplier = 1.50,
				Prediction = true, BulletSpeed = 3850, PredictionExtra = 0,
				PredictionSmoothing = 0.60, MaxPredictionOffset = 22, AdaptiveSmoothing = false,
				MicroSnapRadius = 5, TargetPriority = "Crosshair",
				SwitchDelay = 0, SwitchThreshold = 0.06, LockGrace = 0.12, ShowFOV = true,
			}, "Always On • large FOV • fast • visible targets only")
		end,
	})

	rageTab:Button({
		Title = "Rage • Max",
		Callback = function()
			applyAimPreset("Rage • Max", {
				Enabled = true, HoldRMB = false, AimPoint = "Closest Part",
				FOV = 700, SmoothSpeed = 140, StickyTarget = true, StickyMultiplier = 1.65,
				Prediction = true, BulletSpeed = 3850, PredictionExtra = 0,
				PredictionSmoothing = 0.52, MaxPredictionOffset = 25, AdaptiveSmoothing = false,
				MicroSnapRadius = 10, TargetPriority = "Crosshair",
				SwitchDelay = 0, SwitchThreshold = 0.02, LockGrace = 0.10, ShowFOV = true,
			}, "Always On • max FOV / response • visible targets only")
		end,
	})

	rageTab:Section({ Title = "🛠️ Helpers" })
	rageTab:Button({
		Title = "Always On",
		Callback = function()
			Config.AimMode = "Rage • Custom"
			Config.Aim.Enabled = true
			Config.Aim.HoldRMB = false
			clearTarget()
			if syncUIFromConfig then syncUIFromConfig() end
		end,
	})

	rageTab:Button({
		Title = "Head Only",
		Callback = function()
			Config.AimMode = "Rage • Custom"
			Config.Aim.AimPoint = "Head"
			clearTarget()
			if syncUIFromConfig then syncUIFromConfig() end
		end,
	})

	visualTab:Section({ Title = "👁️ ESP" })
	UIControls.ESPEnabled = visualTab:Toggle({
		Title = "Enable ESP",
		Value = Config.ESP.Enabled,
		Callback = function(value)
			Config.ESP.Enabled = value
			if not value then
				for _, object in pairs(espObjects) do
					hideESPObject(object)
				end
			end
		end,
	})

	UIControls.Boxes = visualTab:Toggle({
		Title = "Boxes",
		Value = Config.ESP.Boxes,
		Callback = function(value) Config.ESP.Boxes = value end,
	})

	UIControls.Names = visualTab:Toggle({
		Title = "Names",
		Value = Config.ESP.Names,
		Callback = function(value) Config.ESP.Names = value end,
	})

	UIControls.Health = visualTab:Toggle({
		Title = "Health",
		Value = Config.ESP.Health,
		Callback = function(value) Config.ESP.Health = value end,
	})

	UIControls.Distance = visualTab:Toggle({
		Title = "Distance",
		Value = Config.ESP.Distance,
		Callback = function(value) Config.ESP.Distance = value end,
	})

	UIControls.Chams = visualTab:Toggle({
		Title = "Chams",
		Value = Config.ESP.Chams,
		Callback = function(value) Config.ESP.Chams = value end,
	})

	UIControls.Tracers = visualTab:Toggle({
		Title = "Tracers",
		Value = Config.ESP.Tracers,
		Callback = function(value) Config.ESP.Tracers = value end,
	})

	visualTab:Section({ Title = "📏 ESP Range" })
	UIControls.ESPDistance = visualTab:Slider({
		Title = "ESP Max Distance (studs)",
		Step = 50,
		Value = { Min = 100, Max = 3000, Default = Config.ESP.MaxDistance },
		Callback = function(value) Config.ESP.MaxDistance = value end,
	})

	visualTab:Paragraph({ Title = "Info", Desc = "The current aim target is highlighted green; other enemies stay red." })

	syncUIFromConfig = function()
		local function safeSet(control, value)
			if control and control.Set then
				pcall(function() control:Set(value) end)
			end
		end

		safeSet(UIControls.AimEnabled, Config.Aim.Enabled)
		safeSet(UIControls.AimActivation, Config.Aim.HoldRMB and "Hold RMB" or "Always On")
		safeSet(UIControls.AutoShoot, Config.Aim.AutoShoot)
		safeSet(UIControls.AutoShootButton, normalizeAutoShootButton(Config.Aim.AutoShootButton))
		safeSet(UIControls.AutoShootRadius, Config.Aim.AutoShootRadius)
		safeSet(UIControls.AutoShootDelay, Config.Aim.AutoShootDelay)
		safeSet(UIControls.AimPoint, Config.Aim.AimPoint)
		safeSet(UIControls.StickyTarget, Config.Aim.StickyTarget)
		safeSet(UIControls.ShowFOV, Config.Aim.ShowFOV)
		safeSet(UIControls.FOV, Config.Aim.FOV)
		safeSet(UIControls.AimSpeed, Config.Aim.SmoothSpeed)
		safeSet(UIControls.AimDistance, Config.Aim.MaxDistance)
		safeSet(UIControls.TargetPriority, Config.Aim.TargetPriority)
		safeSet(UIControls.Prediction, Config.Aim.Prediction)
		safeSet(UIControls.BulletSpeed, Config.Aim.BulletSpeed)
		safeSet(UIControls.PredictionExtra, Config.Aim.PredictionExtra)
		safeSet(UIControls.PredictionSmoothing, Config.Aim.PredictionSmoothing)
		safeSet(UIControls.MaxPredictionOffset, Config.Aim.MaxPredictionOffset)
		safeSet(UIControls.AdaptiveSmoothing, Config.Aim.AdaptiveSmoothing)
		safeSet(UIControls.MicroSnap, Config.Aim.MicroSnapRadius)
		safeSet(UIControls.SwitchDelay, Config.Aim.SwitchDelay)
		safeSet(UIControls.SwitchThreshold, Config.Aim.SwitchThreshold)
		safeSet(UIControls.LockGrace, Config.Aim.LockGrace)
		safeSet(UIControls.ESPEnabled, Config.ESP.Enabled)
		safeSet(UIControls.Boxes, Config.ESP.Boxes)
		safeSet(UIControls.Names, Config.ESP.Names)
		safeSet(UIControls.Health, Config.ESP.Health)
		safeSet(UIControls.Distance, Config.ESP.Distance)
		safeSet(UIControls.Chams, Config.ESP.Chams)
		safeSet(UIControls.Tracers, Config.ESP.Tracers)
		safeSet(UIControls.ESPDistance, Config.ESP.MaxDistance)

		clearTarget()
		updateAimModeLabels()
	end

	settingsTab:Section({ Title = "🎮 Info" })
	settingsTab:Paragraph({ Title = "Place ID", Desc = tostring(game.PlaceId) })

	settingsTab:Button({
		Title = "Re-scan Native Weapon Client",
		Callback = function()
			resolveNativeWeaponClient()
			if BackendStatusLabel and BackendStatusLabel.SetDesc then
				BackendStatusLabel:SetDesc(backendStatusText())
			end
			WindUI:Notify({ Title = "POTENT", Content = NativeWeaponStatus, Duration = 2 })
		end,
	})

	settingsTab:Button({
		Title = "Reset Aim + ESP Defaults",
		Callback = function()
			Config = deepCopy(DefaultConfig)
			clearTarget()
			velocityCache = setmetatable({}, {__mode = "k"})
			if syncUIFromConfig then syncUIFromConfig() end
			WindUI:Notify({ Title = "POTENT", Content = "Aim and ESP defaults restored", Duration = 2 })
		end,
	})

	settingsTab:Button({
		Title = "Unload Script",
		Callback = function()
			if cleanup then cleanup() end
		end,
	})

	syncUIFromConfig()

	local renderConnection
	local statusAccumulator = 0

	renderConnection = runService.RenderStepped:Connect(function(dt)
		if not running then return end
		applyAim(dt)
		updateESP()
		updateFOV()
		statusAccumulator = statusAccumulator + dt
		if statusAccumulator >= 1 then
			statusAccumulator = 0
			if BackendStatusLabel and BackendStatusLabel.SetDesc then
				BackendStatusLabel:SetDesc(backendStatusText())
			end
		end
	end)

	cleanup = function()
		if not running then return end
		running = false
		if renderConnection then
			pcall(function() renderConnection:Disconnect() end)
			renderConnection = nil
		end
		clearTarget()
		for character in pairs(espObjects) do
			removeESP(character)
		end
		if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
		if window and type(window.Destroy) == "function" then
			pcall(function() window:Destroy() end)
		end
	end

	WindUI:Notify({
		Title = "⚡ POTENT HUB",
		Content = "One Tap loaded • enable options manually",
		Duration = 3,
	})
end

-- ============================================================
-- ========== JUEGO 6: HUSS VALLEY ==========
-- ============================================================
local function runHussValley()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Shared state for the loader (kept in one table to stay under Luau's 200-local limit)
local Hub = {
    genv = (getgenv and getgenv()) or _G,
    registry = {},
    cleaned = false,
}
-- Re-executing the script cleanly unloads the previous copy first
if Hub.genv.HussValleyUnload then
    pcall(Hub.genv.HussValleyUnload)
end

local LocalPlayer = Players.LocalPlayer
local COH = ReplicatedStorage:WaitForChild("ChickenOrHero")
local Movement = COH:WaitForChild("Movement")
local MovementProfiles = require(Movement:WaitForChild("MovementProfiles"))
local BoostInput = require(Movement:WaitForChild("BoostInput"))
local Game = COH:WaitForChild("Game")
local Session = Game:WaitForChild("Session")
local MapVoteState = Game:WaitForChild("MapVoteState")
local MapVoteEvent = Game:WaitForChild("MapVoteEvent")
local ContactCatchConfig = require(Game:WaitForChild("ContactCatchConfig"))
local TacklePrediction = require(Game:WaitForChild("TacklePrediction"))
local MeleeEvent = Game:WaitForChild("MeleeEvent")
local RescueConfig = require(Game:WaitForChild("RescueConfig"))
local RESCUE_RANGE = math.max(3, tonumber(RescueConfig.Range) or 6) - 0.25
local RESCUE_HOLD = math.max(0.1, tonumber(RescueConfig.HoldSeconds) or 1.2)
local RESCUE_FINISH_GRACE = math.max(0.1, tonumber(RescueConfig.FinishGrace) or 0.5)
local RescueEvent = Game:WaitForChild("RescueEvent")
local Gear = COH:WaitForChild("Gear")
local GearCatalog = require(Gear:WaitForChild("GearCatalog"))
local ArmoryEvent = COH:WaitForChild("Weapons"):WaitForChild("ArmoryEvent")
local SpinWheelEvent = COH:WaitForChild("SpinWheelEvent")
local JourneyConfig = require(COH:WaitForChild("Progression"):WaitForChild("JourneyConfig"))
local JourneyEvent = COH:WaitForChild("Progression"):WaitForChild("JourneyEvent")
local PlayerPreferences = COH:WaitForChild("Game"):WaitForChild("PlayerPreferences")
local Presentation = COH:WaitForChild("Presentation")
local HudNavigation = require(Presentation:WaitForChild("HudNavigation"))
local WindUI

local SETTINGS = {
    runnerEnabled = true,
    strategy = "Hero",
    customSpeed = false,
    speedMultiplier = 1.0,
    autoGems = true,
    gemScanInterval = 0.25,
    gemMaxDistance = 220,
    gemCollectDistance = 4.5,
    autoRevive = true,
    reviveBeforeGems = true,
    reviveMaxDistance = 220,
    avoidCatchers = true,
    predictionTime = 0.65,
    avoidStrength = 2.2,
    panicDistance = 15,
    safezoneDepthRatio = 0.52,
    safezoneValidationRatio = 0.44,
    safezoneEdgeMargin = 4.5,
    edgeRayHeight = 12,
    edgeRayDepth = 52,
    edgeLookAhead = 14,
    edgeSecondLookAhead = 28,
    autoDash = true,
    dashCooldown = 0.85,
    dashDistance = 48,
    dashClosingSpeed = 10,
    smoothMovement = true,
    turnRate = 9,
    emergencySafeZone = true,
    showThreats = true,
    showGoal = true,
    corridorEnabled = true,
    corridorMinWidth = 4.25,
    corridorCenterRange = 26,
    corridorLockTime = 1.65,
    corridorPassDistance = 20,
    corridorApproachDistance = 60,
    sideGapEnabled = true,
    sideGapAngles = {18, 30, 42, 54, 68, 82},
    sideGapMinClearance = 3.5,
    sideGapCommitTime = 0.8,
    sideGapForwardBias = 6.5,

    catcherChase = true,
    catcherCustomSpeed = false,
    catcherSpeedMultiplier = 1.0,
    catcherPrediction = 0.45,
    catcherSmoothing = 6,
    smartPriority = true,
    catcherAttackPriority = "Smart",
    autoTackle = true,
    tackleRange = 12,
    tackleCooldown = 1.2,
    autoMelee = true,
    meleeRange = 9,
    meleeCooldown = 0.35,
    smoothTurn = true,
    turnRateCatcher = 14,
    followTarget = true,

    showHitboxes = true,
    showGoalUtility = true,
    showThreatUtility = false,
    showDebugUI = false,
    cameraFollow = true,
    cameraResponse = 0.25,
    autoSpinWheel = false,
    wheelSpinInterval = 6,
    wheelMinimumCredits = 1,
    wheelAnnounce = true,
    autoClaimJourneyRewards = false,
    journeyClaimAnnounce = true,
    autoMapVote = false,
    mapVoteAnnounce = true,
    mapVoteSelections = {},
    disableBuiltinAFK = false,
}

local runtime = {
    profile = nil,
    profileRole = nil,
    runnerTick = 0,
    runnerPlanAt = -math.huge,
    runnerPlanDirection = Vector3.zero,
    runnerPlanGoal = Vector3.zero,
    catcherTick = 0,
    utilityTick = 0,
    lastMove = os.clock(),
    lastMovePosition = nil,
    moveCommandAt = -math.huge,
    stuck = false,
    path = Vector3.zero,
    goal = nil,
    goalMode = "SafeZone",
    goalSide = nil,
    assistMode = nil,
    assistTarget = nil,
    assistSince = -math.huge,
    gemTarget = nil,
    gemIgnored = {},
    gemScanAt = -math.huge,
    reviveTarget = nil,
    reviveStarted = false,
    reviveStartAt = 0,
    reviveInputToken = 0,
    catchers = {},
    catcherCacheAt = 0,
    threats = {},
    threatAt = 0,
    threatHistory = {},
    dashAt = -math.huge,
    dashStatus = "idle",
    dashLastRequestAt = -math.huge,
    dashLastCount = nil,
    ping = 0,
    pingAt = 0,
    armory = {loaded = false, abilities = {}},
    armoryAt = -math.huge,
    catcherTargets = {},
    catcherTargetAt = 0,
    catcherTarget = nil,
    edgeRisk = false,
    edgeDirection = Vector3.zero,
    catcherPath = Vector3.zero,
    catcherVelocity = {},
    meleeId = 0,
    lastMelee = -math.huge,
    lastTackle = -math.huge,
    mapCacheAt = -math.huge,
    mapCache = nil,
    edgeCheckAt = -math.huge,
    edgeCheckPosition = nil,
    edgeCheckDirection = Vector3.zero,
    edgeCheckGoal = Vector3.zero,
    edgeRecoveryAt = -math.huge,
    edgeRecoveryDirection = Vector3.zero,
    edgeRecoveryUntil = -math.huge,
    stuckRecoveryUntil = -math.huge,
    stuckRecoveryDirection = Vector3.zero,
    safeCheckAt = -math.huge,
    safeCheckPosition = nil,
    safeCheckA = false,
    safeCheckB = false,
    routeActive = false,
    routeComplete = false,
    routeStartSide = nil,
    routeTargetSide = nil,
    routeCompletePosition = nil,
    routeCompleteAt = -math.huge,
    corridorActive = false,
    corridorGoal = Vector3.zero,
    corridorCenter = Vector3.zero,
    corridorAxis = Vector3.zero,
    corridorGapWidth = 0,
    corridorStartedAt = -math.huge,
    sideGapDirection = Vector3.zero,
    sideGapUntil = -math.huge,
    sideGapReason = "",
    wheelScanAt = -math.huge,
    wheelActionAt = -math.huge,
    wheelStatus = "disabled",
    wheelLastButton = nil,
    wheelSpinCount = 0,
    wheelCredits = 0,
    wheelNextFreeAt = 0,
    wheelPurchasesAvailable = false,
    wheelDiscountAvailable = false,
    wheelStateRequestAt = -math.huge,
    wheelSpinRequestAt = -math.huge,
    wheelEventReady = false,
    wheelSpinning = false,
    wheelLastStateAt = -math.huge,
    wheelStatusAt = -math.huge,
    wheelNextAttemptAt = -math.huge,
    wheelMinimumCredits = 1,
    afkOverrideStatus = "disabled",
    afkOverrideLastRequestAt = -math.huge,
    afkOverrideRequestInterval = 2.0,
    afkOverrideInLobby = false,
    afkOverrideRequestCount = 0,
    journeyScanAt = -math.huge,
    journeyStatus = "disabled",
    journeyClaimCount = 0,
    journeyLastClaimAt = -math.huge,
    journeyClaimedButtons = {},
    journeyLoaded = false,
    journeySeasonId = nil,
    journeyRequestAt = -math.huge,
    journeyClaimInFlight = false,
    journeyLastStateAt = -math.huge,
    journeyTier = 1,
    journeyPremium = false,
    journeyClaims = {},
    journeyLastClaimResultAt = -math.huge,
    mapVoteScanAt = -math.huge,
    mapVoteStatus = "disabled",
    mapVoteOptions = {},
    mapVoteLastActionAt = -math.huge,
    mapVoteOpen = false,
    mapVotePhase = "Waiting",
    mapVoteToken = nil,
    mapVoteOptionIds = {},
    mapVoteLastStateAt = -math.huge,
    debugLastError = nil,
    debugLastErrorAt = -math.huge,
    debugEnabled = false,
    debugGui = nil,
    debugLabel = nil,
    debugPanelAt = -math.huge,
    journeyNextClaimAt = -math.huge,
    journeyManualPending = false,
}

local safezone = {
    map = nil,
    a = nil,
    b = nil,
    cached = false,
}

local visuals = {
    goal = nil,
    threats = {},
    hitboxes = {},
}

local MAP_VOTE_SLOT_IDS = {
    "Map 1",
    "Map 2",
    "Map 3",
}

local MapVoteDropdown

local function flat(v)
    return Vector3.new(v.X, 0, v.Z)
end

local function getCharacter(player)
    return (player or LocalPlayer).Character
end

local function getHumanoid(player)
    local c = getCharacter(player)
    return c and c:FindFirstChildOfClass("Humanoid") or nil
end

local function getRoot(player)
    local c = getCharacter(player)
    return c and c:FindFirstChild("HumanoidRootPart") or nil
end

local function getRole()
    return LocalPlayer:GetAttribute("GameRole") or "Lobby"
end

local function getRunState()
    return LocalPlayer:GetAttribute("RunState") or "Idle"
end

local function isRunnerActive()
    if LocalPlayer:GetAttribute("InMatch") ~= true then
        return false
    end
    local role = getRole()
    if role ~= "Runner" then
        return false
    end
    return getRunState() == "Active"
end

local function isCatcherActive()
    if LocalPlayer:GetAttribute("InMatch") ~= true then
        return false
    end
    if getRole() ~= "Catcher" then
        return false
    end
    return getRunState() == "Active"
end

local function canMove()
    if LocalPlayer:GetAttribute("ClientReady") ~= true then
        return false
    end
    if Session:GetAttribute("GlobalPaused") == true then
        return false
    end
    if Session:GetAttribute("MapChanging") == true then
        return false
    end
    local c = getCharacter()
    if not c then
        return false
    end
    if c:GetAttribute("Ragdolled") == true then
        return false
    end
    if c:GetAttribute("GearMotion") == true then
        return false
    end
    if c:GetAttribute("MovementLocked") == true then
        return false
    end
    local h = getHumanoid()
    if not h or h.Health <= 0 then
        return false
    end
    if h.PlatformStand or h.Sit then
        return false
    end
    return true
end

local function getBaseSpeed(role)
    role = role or getRole()
    if runtime.profile and runtime.profileRole == role then
        return runtime.profile.MaxSpeed or 16
    end
    local ok, profile = pcall(MovementProfiles.get, role, LocalPlayer)
    if ok and profile then
        runtime.profile = profile
        runtime.profileRole = role
        return profile.MaxSpeed or 16
    end
    return 16
end

local function getRunnerSpeed()
    local speed = math.max(getBaseSpeed("Runner"), 1)
    if SETTINGS.customSpeed then
        speed *= math.clamp(SETTINGS.speedMultiplier, 1, 2)
    end
    return speed
end

local function getCatcherSpeed()
    local speed = math.max(getBaseSpeed("Catcher"), 1)
    if SETTINGS.catcherCustomSpeed then
        speed *= math.clamp(SETTINGS.catcherSpeedMultiplier, 1, 2)
    end
    return speed
end

local function restoreNativeWalkSpeed()
    local hum = getHumanoid()
    local character = getCharacter()
    if not hum or not character then
        return
    end
    local native = tonumber(character:GetAttribute("MovementSpeed"))
    if native and native > 0 then
        hum.WalkSpeed = native
    end
end

local function refreshPing(now)
    if now - runtime.pingAt < 0.5 then
        return
    end
    runtime.pingAt = now
    local value = 0
    pcall(function()
        value = LocalPlayer:GetNetworkPing() * 0.5
    end)
    runtime.ping = math.max(value, 0)
end

local function getMap()
    local now = os.clock()
    if now - runtime.mapCacheAt < 0.35 then
        return runtime.mapCache
    end
    runtime.mapCacheAt = now
    local handle = Game:FindFirstChild("ActiveMap")
    if handle and handle:IsA("ObjectValue") and handle.Value and handle.Value:IsDescendantOf(workspace) then
        runtime.mapCache = handle.Value
        return runtime.mapCache
    end
    local found = nil
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:FindFirstChild("Field") then
            found = obj
            break
        end
    end
    runtime.mapCache = found
    return found
end

local edgeRayCache = {
    map = nil,
    field = nil,
    invisWall = nil,
    params = nil,
    wallParams = nil,
}

local function resolveActiveField(map)
    if not map then
        return nil
    end
    local field = map:FindFirstChild("Field")
    if field then
        return field
    end
    return map:FindFirstChild("Field", true)
end

local function resolveActiveInvisWall(field)
    if not field then
        return nil
    end
    return field:FindFirstChild("InvisWall", true)
end

local function refreshEdgeRayCache()
    local map = getMap()
    local field = resolveActiveField(map)
    local wall = resolveActiveInvisWall(field)
    local include = field or map

    if edgeRayCache.map == map
        and edgeRayCache.field == field
        and edgeRayCache.invisWall == wall
        and edgeRayCache.params then
        return
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = include and {include} or {}
    params.IgnoreWater = true

    edgeRayCache.map = map
    edgeRayCache.field = field
    edgeRayCache.invisWall = wall
    edgeRayCache.params = params
    edgeRayCache.wallParams = nil
end

local function getEdgeRayParams()
    refreshEdgeRayCache()
    return edgeRayCache.params
end

local function getInvisWallParams()
    refreshEdgeRayCache()
    local wall = edgeRayCache.invisWall
    if not wall or not wall:IsDescendantOf(workspace) then
        edgeRayCache.invisWall = nil
        edgeRayCache.wallParams = nil
        return nil
    end
    if edgeRayCache.wallParams then
        return edgeRayCache.wallParams
    end
    local wallParams = RaycastParams.new()
    wallParams.FilterType = Enum.RaycastFilterType.Include
    wallParams.FilterDescendantsInstances = {wall}
    wallParams.IgnoreWater = true
    edgeRayCache.wallParams = wallParams
    return wallParams
end

local function invisWallHit(position, direction, distance)
    local dir = flat(direction)
    if dir.Magnitude < 0.05 then
        return nil
    end
    local params = getInvisWallParams()
    if not params then
        return nil
    end
    dir = dir.Unit
    local origin = Vector3.new(position.X, position.Y + 2.5, position.Z)
    return workspace:Raycast(origin, dir * distance, params)
end

local function floorRay(point, y)
    local map = getMap()
    if not map then
        return true
    end
    local params = getEdgeRayParams()
    if not params or #params.FilterDescendantsInstances == 0 then
        return false
    end
    local origin = Vector3.new(point.X, math.max(y + 12, point.Y + 10), point.Z)
    local direction = Vector3.new(0, -(SETTINGS.edgeRayHeight + SETTINGS.edgeRayDepth), 0)
    local hit = workspace:Raycast(origin, direction, params)
    return hit ~= nil and hit.Normal.Y >= 0.35
end

local function hasFloorAt(point, y)
    return floorRay(point, y)
end

local function getPlayfieldCenter()
    if safezone.a and safezone.b then
        return (safezone.a.center + safezone.b.center) * 0.5
    end
    if safezone.a then
        return safezone.a.center
    end
    if safezone.b then
        return safezone.b.center
    end
    return nil
end

local function groundSupportScore(position, direction, y)
    local dir = flat(direction)
    if dir.Magnitude < 0.05 then
        return 0
    end
    dir = dir.Unit
    local side = Vector3.new(-dir.Z, 0, dir.X)
    local score = 0
    if hasFloorAt(position + dir * 6, y) then score += 2 end
    if hasFloorAt(position + dir * 14, y) then score += 2 end
    if hasFloorAt(position + dir * 24, y) then score += 1 end
    if hasFloorAt(position + dir * 14 + side * 3, y) then score += 1 end
    if hasFloorAt(position + dir * 14 - side * 3, y) then score += 1 end
    return score
end

local function boundaryInwardDirection(position, y)
    local dirs = {
        Vector3.new(1, 0, 0),
        Vector3.new(-1, 0, 0),
        Vector3.new(0, 0, 1),
        Vector3.new(0, 0, -1),
    }
    local outward = Vector3.zero
    local missing = 0
    for _, dir in ipairs(dirs) do
        local wallHit = invisWallHit(position, dir, 9)
        if wallHit or not hasFloorAt(position + dir * 7, y) then
            outward += dir
            missing += 1
        end
    end
    if missing == 0 or outward.Magnitude < 0.05 then
        return Vector3.zero
    end
    local inward = flat(-outward)
    if inward.Magnitude < 0.05 then
        return Vector3.zero
    end
    inward = inward.Unit
    if groundSupportScore(position, inward, y) < 3 then
        return Vector3.zero
    end
    return inward
end

local function edgeDirectionClear(position, direction, y, distance)
    local dir = flat(direction)
    if dir.Magnitude < 0.05 then
        return false
    end
    dir = dir.Unit
    if invisWallHit(position, dir, math.max(8, distance)) then
        return false
    end
    local score = groundSupportScore(position, dir, y)
    if distance <= 14 then
        return score >= 4
    end
    return score >= 5
end

local function edgeRiskForDirection(position, direction, y)
    local dir = flat(direction)
    if dir.Magnitude < 0.05 then
        return true
    end
    dir = dir.Unit
    return not edgeDirectionClear(position, dir, y, SETTINGS.edgeLookAhead)
        or not edgeDirectionClear(position, dir, y, SETTINGS.edgeSecondLookAhead)
end

local function rotateEdge(dir, angle)
    local r = math.rad(angle)
    local c = math.cos(r)
    local s = math.sin(r)
    return Vector3.new(dir.X * c - dir.Z * s, 0, dir.X * s + dir.Z * c)
end

local function chooseEdgeDirection(position, desired, goal, y)
    local dir = flat(desired)
    if dir.Magnitude < 0.05 then
        return Vector3.zero, false
    end
    dir = dir.Unit

    local now = os.clock()
    if runtime.edgeCheckPosition and runtime.edgeCheckDirection.Magnitude > 0.05
        and now - runtime.edgeCheckAt < 0.055
        and flat(position - runtime.edgeCheckPosition).Magnitude < 2.5
        and runtime.edgeCheckDirection:Dot(dir) > 0.96
        and runtime.edgeCheckGoal.Magnitude > 0.05
        and flat(goal - runtime.edgeCheckGoal).Magnitude < 8 then
        return runtime.edgeDirection, runtime.edgeRisk
    end

    local boundary = boundaryInwardDirection(position, y)
    local desiredRisk = edgeRiskForDirection(position, dir, y)
    local nearBoundary = boundary.Magnitude > 0.05 and boundary:Dot(dir) < 0.35

    runtime.edgeCheckAt = now
    runtime.edgeCheckPosition = position
    runtime.edgeCheckDirection = dir
    runtime.edgeCheckGoal = flat(goal)

    if not desiredRisk and not nearBoundary then
        runtime.edgeDirection = dir
        runtime.edgeRisk = false
        return dir, false
    end

    local toGoal = flat(goal - position)
    if toGoal.Magnitude < 0.05 then
        toGoal = dir
    else
        toGoal = toGoal.Unit
    end

    local inward = boundary
    if inward.Magnitude < 0.05 then
        local center = getPlayfieldCenter()
        if center then
            inward = flat(center - position)
            if inward.Magnitude > 0.05 then
                inward = inward.Unit
            end
        end
    end

    local candidates = {}
    local function addCandidate(v)
        v = flat(v)
        if v.Magnitude < 0.05 then
            return
        end
        v = v.Unit
        for _, item in ipairs(candidates) do
            if item:Dot(v) > 0.985 then
                return
            end
        end
        candidates[#candidates + 1] = v
    end

    addCandidate(inward)
    addCandidate(toGoal)
    addCandidate(dir)
    local base = inward.Magnitude > 0.05 and inward or dir
    for _, angle in ipairs({-35, 35, -70, 70, 90, -90, 135, -135, 180}) do
        addCandidate(rotateEdge(base, angle))
    end

    local best = nil
    local bestScore = -math.huge
    for _, candidate in ipairs(candidates) do
        local support = groundSupportScore(position, candidate, y)
        if support >= 6 then
            local score = support * 4.5 + candidate:Dot(toGoal) * 5
            if inward.Magnitude > 0.05 then
                score += candidate:Dot(inward) * (nearBoundary and 10 or 5)
            end
            if candidate:Dot(dir) > 0 then
                score += 2
            end
            if score > bestScore then
                bestScore = score
                best = candidate
            end
        end
    end

    if best then
        runtime.edgeDirection = best
        runtime.edgeRisk = true
        runtime.edgeRecoveryAt = now
        return best, true
    end

    if inward.Magnitude > 0.05 then
        runtime.edgeDirection = inward
        runtime.edgeRisk = true
        runtime.edgeRecoveryAt = now
        return inward, true
    end

    runtime.edgeDirection = -dir
    runtime.edgeRisk = true
    runtime.edgeRecoveryAt = now
    return -dir, true
end

local function findZone(parent, names)
    for _, name in ipairs(names) do
        local direct = parent:FindFirstChild(name)
        if direct then
            return direct
        end
    end
    for _, obj in ipairs(parent:GetDescendants()) do
        local lower = obj.Name:lower()
        for _, name in ipairs(names) do
            if lower == name:lower() then
                return obj
            end
        end
    end
    return nil
end

local function getBounds(instance)
    if not instance then
        return nil
    end
    local minP = Vector3.new(math.huge, math.huge, math.huge)
    local maxP = Vector3.new(-math.huge, -math.huge, -math.huge)
    local found = false
    local function add(part)
        local p = part.Position
        local h = part.Size * 0.5
        minP = Vector3.new(
            math.min(minP.X, p.X - h.X),
            math.min(minP.Y, p.Y - h.Y),
            math.min(minP.Z, p.Z - h.Z)
        )
        maxP = Vector3.new(
            math.max(maxP.X, p.X + h.X),
            math.max(maxP.Y, p.Y + h.Y),
            math.max(maxP.Z, p.Z + h.Z)
        )
        found = true
    end
    if instance:IsA("BasePart") then
        add(instance)
    end
    for _, obj in ipairs(instance:GetDescendants()) do
        if obj:IsA("BasePart") then
            add(obj)
        end
    end
    if not found then
        return nil
    end
    return minP, maxP
end

local function buildZone(instance)
    local minP, maxP = getBounds(instance)
    if not minP then
        return nil
    end
    return {
        instance = instance,
        name = instance.Name,
        min = minP,
        max = maxP,
        center = (minP + maxP) * 0.5,
    }
end

local function refreshSafezones()
    local map = getMap()
    if safezone.cached and safezone.map == map
        and safezone.a and safezone.b
        and safezone.a.instance and safezone.a.instance.Parent
        and safezone.b.instance and safezone.b.instance.Parent then
        return
    end
    safezone.map = map
    safezone.a = nil
    safezone.b = nil
    safezone.cached = true
    local field = map and map:FindFirstChild("Field")
    if not field then
        return
    end
    local a = findZone(field, {"SafezoneASide", "SafeZoneASide"})
    local b = findZone(field, {"SafezoneBSide", "SafeZoneBSide"})
    safezone.a = buildZone(a)
    safezone.b = buildZone(b)
end

local function inZone(position, zone)
    if not zone then
        return false
    end
    return position.X >= zone.min.X
        and position.X <= zone.max.X
        and position.Z >= zone.min.Z
        and position.Z <= zone.max.Z
        and position.Y >= zone.min.Y - 8
        and position.Y <= zone.max.Y + 8
end

local function currentZone(position)
    if inZone(position, safezone.a) then
        return safezone.a
    end
    if inZone(position, safezone.b) then
        return safezone.b
    end
    return nil
end

local function zoneInwardDirection(zone, other)
    if not zone then
        return Vector3.zero
    end
    local delta = other and flat(zone.center - other.center) or Vector3.zero
    if delta.Magnitude > 0.05 then
        if math.abs(delta.X) >= math.abs(delta.Z) then
            return Vector3.new(delta.X >= 0 and 1 or -1, 0, 0)
        end
        return Vector3.new(0, 0, delta.Z >= 0 and 1 or -1)
    end
    if zone.instance and zone.instance:IsA("BasePart") then
        local look = flat(zone.instance.CFrame.LookVector)
        if look.Magnitude > 0.05 then
            if math.abs(look.X) >= math.abs(look.Z) then
                return Vector3.new(look.X >= 0 and 1 or -1, 0, 0)
            end
            return Vector3.new(0, 0, look.Z >= 0 and 1 or -1)
        end
    end
    return Vector3.zero
end

local function zoneAxisHalfExtent(zone, inward)
    if not zone then
        return 0
    end
    local size = zone.max - zone.min
    if math.abs(inward.X) >= math.abs(inward.Z) then
        return math.abs(size.X) * 0.5
    end
    return math.abs(size.Z) * 0.5
end

local function zoneDeepPoint(zone, other, y)
    if not zone then
        return nil
    end
    local inward = zoneInwardDirection(zone, other)
    local half = zoneAxisHalfExtent(zone, inward)
    local edgeMargin = math.min(SETTINGS.safezoneEdgeMargin, math.max(0, half - 0.75))
    local depth = math.min(math.max(0, half - edgeMargin), half * SETTINGS.safezoneDepthRatio)
    local xMargin = math.min(edgeMargin, math.max(0, (zone.max.X - zone.min.X) * 0.5 - 0.75))
    local zMargin = math.min(edgeMargin, math.max(0, (zone.max.Z - zone.min.Z) * 0.5 - 0.75))
    local ratios = {SETTINGS.safezoneDepthRatio, 0.46, 0.40, 0.34}
    for _, ratio in ipairs(ratios) do
        local candidateDepth = math.min(math.max(0, half - edgeMargin), half * ratio)
        local point = zone.center + inward * candidateDepth
        point = Vector3.new(
            math.clamp(point.X, zone.min.X + xMargin, zone.max.X - xMargin),
            y,
            math.clamp(point.Z, zone.min.Z + zMargin, zone.max.Z - zMargin)
        )
        if edgeDirectionClear(point, inward, y, 6) and edgeDirectionClear(point, -inward, y, 4) then
            return point
        end
    end
    local point = zone.center + inward * depth
    return Vector3.new(
        math.clamp(point.X, zone.min.X + xMargin, zone.max.X - xMargin),
        y,
        math.clamp(point.Z, zone.min.Z + zMargin, zone.max.Z - zMargin)
    )
end

local function inValidatedZone(position, zone, other)
    if not zone or not inZone(position, zone) then
        return false
    end
    local inward = zoneInwardDirection(zone, other)
    if inward.Magnitude < 0.05 then
        return false
    end
    local half = zoneAxisHalfExtent(zone, inward)
    local margin = math.min(SETTINGS.safezoneEdgeMargin, math.max(0, half - 0.75))
    local xOk = position.X >= zone.min.X + margin and position.X <= zone.max.X - margin
    local zOk = position.Z >= zone.min.Z + margin and position.Z <= zone.max.Z - margin
    if not xOk or not zOk then
        return false
    end
    local depth = flat(position - zone.center):Dot(inward)
    local required = math.min(math.max(0, half - margin), half * SETTINGS.safezoneValidationRatio)
    return depth >= required and hasFloorAt(position, position.Y)
end

local function zoneCenter(zone, y)
    if not zone then
        return nil
    end
    return Vector3.new(zone.center.X, y, zone.center.Z)
end

local function detectRoundStartZone(position, a, b)
    local inA = inZone(position, a)
    local inB = inZone(position, b)
    if inA and not inB then
        return a
    end
    if inB and not inA then
        return b
    end
    local da = flat(position - a.center).Magnitude
    local db = flat(position - b.center).Magnitude
    return da <= db and a or b
end

local function beginRunnerRound(position)
    refreshSafezones()
    local a = safezone.a
    local b = safezone.b
    if not a or not b then
        runtime.routeActive = false
        runtime.routeComplete = false
        runtime.routeStartSide = nil
        runtime.routeTargetSide = nil
        runtime.routeCompletePosition = nil
        runtime.routeCompleteAt = -math.huge
        runtime.goalSide = nil
        runtime.goal = nil
        return nil, nil
    end

    local start = detectRoundStartZone(position, a, b)
    local target = start == a and b or a

    runtime.routeActive = true
    runtime.routeComplete = false
    runtime.routeStartSide = start.name
    runtime.routeTargetSide = target.name
    runtime.routeCompletePosition = nil
    runtime.routeCompleteAt = -math.huge
    runtime.goalSide = target.name
    runtime.goal = zoneDeepPoint(target, start, position.Y) or zoneCenter(target, position.Y)
    runtime.safeCheckAt = -math.huge
    runtime.safeCheckPosition = nil
    return runtime.goal, target
end

local function chooseSafeGoal(position)
    refreshSafezones()
    local a = safezone.a
    local b = safezone.b
    if not a or not b then
        runtime.goal = nil
        runtime.goalSide = nil
        runtime.routeActive = false
        runtime.routeComplete = false
        runtime.routeStartSide = nil
        runtime.routeTargetSide = nil
        runtime.routeCompletePosition = nil
        runtime.routeCompleteAt = -math.huge
        return nil, nil
    end

    if not runtime.routeActive or not runtime.routeTargetSide then
        return beginRunnerRound(position)
    end

    if runtime.routeComplete then
        return nil, nil
    end

    local now = os.clock()
    if not runtime.safeCheckPosition
        or now - runtime.safeCheckAt >= 0.08
        or flat(position - runtime.safeCheckPosition).Magnitude >= 2.0 then
        runtime.safeCheckAt = now
        runtime.safeCheckPosition = position
        runtime.safeCheckA = inValidatedZone(position, a, b)
        runtime.safeCheckB = inValidatedZone(position, b, a)
    end

    local target = runtime.routeTargetSide == a.name and a or b
    local other = target == a and b or a

    if (target == a and runtime.safeCheckA) or (target == b and runtime.safeCheckB) then
        runtime.routeComplete = true
        runtime.routeCompletePosition = position
        runtime.routeCompleteAt = now
        runtime.goal = nil
        runtime.goalSide = target.name
        return nil, target
    end

    runtime.goalSide = target.name
    if not runtime.goal then
        runtime.goal = zoneDeepPoint(target, other, position.Y) or zoneCenter(target, position.Y)
    else
        runtime.goal = Vector3.new(runtime.goal.X, position.Y, runtime.goal.Z)
    end

    return runtime.goal, target
end

local function getSafeFallback(position)
    refreshSafezones()
    local a = safezone.a
    local b = safezone.b
    if not a or not b then
        return nil
    end
    local target
    if runtime.routeTargetSide == a.name then
        target = a
    elseif runtime.routeTargetSide == b.name then
        target = b
    elseif runtime.goalSide == a.name then
        target = a
    elseif runtime.goalSide == b.name then
        target = b
    elseif inZone(position, a) and not inZone(position, b) then
        target = b
    elseif inZone(position, b) and not inZone(position, a) then
        target = a
    else
        target = b
    end
    return zoneDeepPoint(target, target == a and b or a, position.Y) or zoneCenter(target, position.Y)
end

local function isGemObject(obj)
    local name = obj.Name:lower()
    return obj:IsA("BasePart") and (
        name:sub(1, 4) == "gem_"
        or name == "gem"
        or name == "gems"
        or name:find("gempickup", 1, true) ~= nil
    )
end

local function refreshGems(now, position)
    if now - runtime.gemScanAt < SETTINGS.gemScanInterval then
        return
    end
    runtime.gemScanAt = now
    local folder = workspace:FindFirstChild("LocalRunnerGems")
    local best, bestDistance
    if folder then
        for _, obj in ipairs(folder:GetChildren()) do
            if isGemObject(obj) and obj.Parent then
                local d = flat(obj.Position - position).Magnitude
                local ignored = runtime.gemIgnored[obj]
                if d <= SETTINGS.gemMaxDistance and (not ignored or now >= ignored) then
                    if not bestDistance or d < bestDistance then
                        best = obj
                        bestDistance = d
                    end
                end
            end
        end
    end
    if not best then
        local generic = workspace:FindFirstChild("Gems") or workspace:FindFirstChild("Gem")
        if generic then
            for _, obj in ipairs(generic:GetDescendants()) do
                if isGemObject(obj) and obj.Parent then
                    local d = flat(obj.Position - position).Magnitude
                    local ignored = runtime.gemIgnored[obj]
                    if d <= SETTINGS.gemMaxDistance and (not ignored or now >= ignored) then
                        if not bestDistance or d < bestDistance then
                            best = obj
                            bestDistance = d
                        end
                    end
                end
            end
        end
    end
    runtime.gemTarget = best
end

local function findDownedPlayer(position)
    local best, bestDistance
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Parent then
            local c = player.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root and c:GetAttribute("RescueAvailable") == true and c:GetAttribute("Ragdolled") == true then
                local helper = c:GetAttribute("RescueHelperId")
                if helper == nil or helper == LocalPlayer.UserId then
                    local d = flat(root.Position - position).Magnitude
                    if d <= SETTINGS.reviveMaxDistance and (not bestDistance or d < bestDistance) then
                        best = player
                        bestDistance = d
                    end
                end
            end
        end
    end
    return best
end

local function cancelRevive()
    if runtime.reviveTarget and runtime.reviveStarted then
        pcall(function()
            RescueEvent:FireServer("Cancel", runtime.reviveTarget.UserId)
        end)
    end
    runtime.reviveTarget = nil
    runtime.reviveStarted = false
    runtime.reviveStartAt = 0
end

local function hasReviveLineOfSight(target)
    local myRoot = getRoot()
    local targetRoot = target and getRoot(target)
    if not myRoot or not targetRoot then
        return false
    end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {myRoot.Parent, targetRoot.Parent}
    params.RespectCanCollide = true
    local ok, result = pcall(function()
        return workspace:Raycast(myRoot.Position, targetRoot.Position - myRoot.Position, params)
    end)
    return ok and result == nil
end

local function updateRevive(now, position)
    if not SETTINGS.autoRevive then
        cancelRevive()
        return nil
    end
    local target = runtime.reviveTarget
    local root = target and getRoot(target)
    if not target or not target.Parent or not root or target.Character:GetAttribute("RescueAvailable") ~= true or target.Character:GetAttribute("Ragdolled") ~= true then
        cancelRevive()
        target = nil
    end
    if not target then
        target = findDownedPlayer(position)
        if not target then
            return nil
        end
        runtime.reviveTarget = target
    end
    root = getRoot(target)
    if not root then
        cancelRevive()
        return nil
    end
    runtime.goalMode = "Revive"
    local distance = flat(root.Position - position).Magnitude
    if distance > math.max(RESCUE_RANGE, SETTINGS.reviveMaxDistance) then
        cancelRevive()
        return nil
    end
    if distance <= RESCUE_RANGE then
        if not runtime.reviveStarted and now < runtime.reviveStartAt then
            return root.Position
        end
        if hasReviveLineOfSight(target) then
            if not runtime.reviveStarted then
                runtime.reviveStarted = true
                runtime.reviveStartAt = now
                pcall(function()
                    RescueEvent:FireServer("Begin", target.UserId)
                end)
            elseif now - runtime.reviveStartAt >= RESCUE_HOLD then
                pcall(function()
                    RescueEvent:FireServer("Finish", target.UserId)
                end)
                runtime.reviveStarted = false
                runtime.reviveStartAt = now + RESCUE_FINISH_GRACE + 0.5
            end
        end
    else
        if runtime.reviveStarted then
            cancelRevive()
        end
    end
    return root.Position
end

local function refreshCatchers(now)
    if now - runtime.catcherCacheAt < 0.12 then
        return
    end
    runtime.catcherCacheAt = now
    local list = runtime.catchers
    table.clear(list)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Parent and player:GetAttribute("GameRole") == "Catcher" and player:GetAttribute("RunState") == "Active" then
            local c = player.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if h and h.Health > 0 and r and c:GetAttribute("Ragdolled") ~= true and c:GetAttribute("MovementLocked") ~= true then
                list[#list + 1] = player
            end
        end
    end
end

local function updateThreats(now, position)
    if now - runtime.threatAt < 0.045 then
        return runtime.threats
    end
    runtime.threatAt = now
    table.clear(runtime.threats)
    local runRoot = getRoot()
    local runVelocity = runRoot and flat(runRoot.AssemblyLinearVelocity) or Vector3.zero
    local runSpeed = math.max(getRunnerSpeed(), 1)
    if runVelocity.Magnitude < 3 and runtime.path.Magnitude > 0.05 then
        runVelocity = runtime.path.Unit * runSpeed
    end

    local nowServer = 0
    pcall(function()
        nowServer = workspace:GetServerTimeNow()
    end)

    for _, player in ipairs(runtime.catchers) do
        local root = getRoot(player)
        if root then
            local current = flat(root.Position)
            local offset = current - position
            local distance = offset.Magnitude
            if distance <= 105 then
                local velocity = flat(root.AssemblyLinearVelocity)
                local history = runtime.threatHistory[player]
                if not history then
                    history = {position = current, velocity = velocity, time = now}
                    runtime.threatHistory[player] = history
                end
                local historyDt = now - history.time
                local acceleration = Vector3.zero
                if historyDt > 0.025 and historyDt < 0.25 then
                    acceleration = (velocity - history.velocity) / historyDt
                    if acceleration.Magnitude > 70 then
                        acceleration = acceleration.Unit * 70
                    end
                end
                history.position = current
                history.velocity = velocity
                history.time = now

                local relative = current - position
                local relativeVelocity = velocity - runVelocity
                local relSpeedSq = relativeVelocity:Dot(relativeVelocity)
                local closestTime = 0
                if relSpeedSq > 0.25 then
                    closestTime = math.clamp(-relative:Dot(relativeVelocity) / relSpeedSq, 0, 1.8)
                end

                local prediction = math.clamp(SETTINGS.predictionTime + runtime.ping * 0.85, 0.28, 1.15)
                local velocityFactor = math.clamp(velocity.Magnitude / math.max(runSpeed, 1), 0.65, 1.25)
                prediction = math.clamp(prediction * velocityFactor, 0.28, 1.15)
                local character = player.Character
                local tackle = character and character:GetAttribute("TackleActive") == true
                local tackleDirection = character and character:GetAttribute("TackleDirection")
                if typeof(tackleDirection) ~= "Vector3" then
                    tackleDirection = Vector3.zero
                end
                tackleDirection = flat(tackleDirection)
                if tackleDirection.Magnitude < 0.05 then
                    tackleDirection = velocity
                end
                if tackleDirection.Magnitude < 0.05 then
                    tackleDirection = flat(root.CFrame.LookVector)
                end
                if tackleDirection.Magnitude > 0.05 then
                    tackleDirection = tackleDirection.Unit
                end

                if tackle then
                    prediction = math.min(1.8, prediction + 0.32)
                end

                local relativeFuture = relative + relativeVelocity * prediction + acceleration * (0.5 * prediction * prediction)
                local futureDistance = relativeFuture.Magnitude

                local danger = math.max(8, tonumber(ContactCatchConfig.MinForward) or 0)
                    + math.max(0, tonumber(ContactCatchConfig.HandRadius) or 0)
                    + math.max(0, tonumber(ContactCatchConfig.ContactPadding) or 0)
                    + math.max(0, tonumber(ContactCatchConfig.RunnerRadius) or 0)
                if tackle then
                    local reach = tonumber(character:GetAttribute("TackleReach")) or 0
                    danger += 8 + math.min(reach, 8)
                elseif velocity.Magnitude > runSpeed * 0.8 then
                    danger += 2
                end

                local closing = 0
                if distance > 0.05 then
                    closing = math.max(0, velocity:Dot(-offset.Unit))
                end
                local timeToDanger = math.huge
                if closing > 0.5 then
                    timeToDanger = math.max(0, (distance - danger) / closing)
                elseif distance <= danger then
                    timeToDanger = 0
                end

                local interceptTime = math.min(closestTime, prediction)
                if timeToDanger < interceptTime then
                    interceptTime = timeToDanger
                end

                local interceptCatcher = current + velocity * interceptTime + acceleration * (0.5 * interceptTime * interceptTime)
                local interceptRunner = position + runVelocity * interceptTime
                local interceptGap = flat(interceptCatcher - interceptRunner).Magnitude
                local predicted = current + velocity * prediction + acceleration * (0.5 * prediction * prediction)

                if tackle and tackleDirection.Magnitude > 0.05 then
                    local duration = tonumber(character:GetAttribute("TackleDuration")) or 0.45
                    local started = tonumber(character:GetAttribute("TackleStartedAt")) or 0
                    local elapsed = nowServer > 0 and math.max(0, nowServer - started) or 0
                    local activeTime = math.clamp(duration - elapsed, 0, prediction)
                    local dashSpeed = math.max(velocity.Magnitude, runSpeed * 2.2)
                    local tackleTravel = math.min(dashSpeed * activeTime, danger + 18)
                    predicted = current + tackleDirection * tackleTravel
                    local tackleTime = math.min(interceptTime, activeTime)
                    interceptCatcher = current + tackleDirection * math.min(dashSpeed * tackleTime, danger + 18)
                    interceptGap = flat(interceptCatcher - interceptRunner).Magnitude
                end

                local collisionRisk = timeToDanger <= math.min(prediction + 0.04, 0.72)
                    or interceptGap <= danger * 1.35
                    or (tackle and interceptGap <= danger * 2.15)
                local preTackle = closing >= math.max(6.5, runSpeed * 0.34) and distance <= 50
                runtime.threats[#runtime.threats + 1] = {
                    player = player,
                    root = root,
                    position = current,
                    velocity = velocity,
                    acceleration = acceleration,
                    distance = distance,
                    closing = closing,
                    predicted = predicted,
                    intercept = interceptCatcher,
                    interceptRunner = interceptRunner,
                    interceptTime = math.max(0, interceptTime),
                    interceptGap = interceptGap,
                    danger = danger,
                    tackle = tackle,
                    collisionRisk = collisionRisk,
                    preTackle = preTackle,
                    timeToDanger = timeToDanger,
                }
            end
        end
    end

    table.sort(runtime.threats, function(a, b)
        if a.collisionRisk ~= b.collisionRisk then
            return a.collisionRisk
        end
        if a.timeToDanger ~= b.timeToDanger then
            return a.timeToDanger < b.timeToDanger
        end
        if a.tackle ~= b.tackle then
            return a.tackle
        end
        if a.interceptGap ~= b.interceptGap then
            return a.interceptGap < b.interceptGap
        end
        return a.distance < b.distance
    end)

    for player, history in pairs(runtime.threatHistory) do
        if not player.Parent or now - history.time > 1.2 then
            runtime.threatHistory[player] = nil
        end
    end
    return runtime.threats
end

local function rotate(dir, angle)
    local r = math.rad(angle)
    local c = math.cos(r)
    local s = math.sin(r)
    return Vector3.new(dir.X * c - dir.Z * s, 0, dir.X * s + dir.Z * c)
end

local function routeClear(position, direction, threats)
    if direction.Magnitude < 0.05 then
        return -math.huge
    end
    local dir = direction.Unit
    local speed = math.max(getRunnerSpeed(), 1)
    local clearance = math.huge
    local samples = {0.10, 0.22, 0.36, 0.52, 0.70, 0.90}
    for _, t in ipairs(samples) do
        local runner = position + dir * speed * t
        for _, threat in ipairs(threats) do
            local catchPos
            if threat.tackle and flat(threat.intercept - threat.position).Magnitude > 0.05 then
                local tackleDir = flat(threat.intercept - threat.position).Unit
                local tackleTime = math.min(t, math.max(threat.interceptTime, 0.12))
                local tackleSpeed = math.max(threat.velocity.Magnitude, speed * 2.2)
                catchPos = threat.position + tackleDir * math.min(tackleSpeed * tackleTime, threat.danger + 18)
            else
                catchPos = threat.position + threat.velocity * t + threat.acceleration * (0.5 * t * t)
            end
            local safe = flat(runner - catchPos).Magnitude - threat.danger
            if safe < clearance then
                clearance = safe
            end
        end
    end
    return clearance
end

local function addDirection(list, direction)
    direction = flat(direction)
    if direction.Magnitude < 0.05 then
        return
    end
    direction = direction.Unit
    for _, item in ipairs(list) do
        if item:Dot(direction) > 0.985 then
            return
        end
    end
    list[#list + 1] = direction
end

local function corridorAxes(position, goal)
    refreshSafezones()
    local a = safezone.a
    local b = safezone.b
    if not a or not b then
        return nil, nil, nil
    end
    local axis = flat(b.center - a.center)
    if axis.Magnitude < 0.05 then
        return nil, nil, nil
    end
    if math.abs(axis.X) >= math.abs(axis.Z) then
        axis = Vector3.new(axis.X >= 0 and 1 or -1, 0, 0)
    else
        axis = Vector3.new(0, 0, axis.Z >= 0 and 1 or -1)
    end
    local toGoal = flat(goal - position)
    if toGoal.Magnitude > 0.05 and axis:Dot(toGoal) < 0 then
        axis = -axis
    end
    local lateral = Vector3.new(-axis.Z, 0, axis.X)
    local center = (a.center + b.center) * 0.5
    return axis, lateral, center
end

local function clearCorridorLock()
    runtime.corridorActive = false
    runtime.corridorGoal = Vector3.zero
    runtime.corridorCenter = Vector3.zero
    runtime.corridorAxis = Vector3.zero
    runtime.corridorGapWidth = 0
    runtime.corridorStartedAt = -math.huge
end

local function findCorridorGoal(position, goal, threats, now)
    if not SETTINGS.corridorEnabled or #threats < 2 then
        clearCorridorLock()
        return nil
    end

    local axis, lateral, center = corridorAxes(position, goal)
    if not axis then
        clearCorridorLock()
        return nil
    end

    local forwardDistance = (center - position):Dot(axis)
    if forwardDistance < -12 or forwardDistance > SETTINGS.corridorApproachDistance then
        clearCorridorLock()
        return nil
    end

    local lineLat = center:Dot(lateral)
    local blockers = {}
    for _, threat in ipairs(threats) do
        local longitudinal = math.abs((threat.position - center):Dot(axis))
        local lateralPos = (threat.position - center):Dot(lateral)
        if longitudinal <= SETTINGS.corridorCenterRange and threat.distance <= 100 then
            blockers[#blockers + 1] = {
                threat = threat,
                lateral = lateralPos,
                buffer = math.clamp(threat.danger * 0.38, 2.25, 5.25),
            }
        end
    end
    if #blockers < 2 then
        if runtime.corridorActive and now - runtime.corridorStartedAt <= SETTINGS.corridorLockTime then
            return runtime.corridorGoal
        end
        clearCorridorLock()
        return nil
    end

    table.sort(blockers, function(x, y)
        return x.lateral < y.lateral
    end)

    local bestCenter = nil
    local bestWidth = -math.huge
    local bestScore = -math.huge
    local low = math.huge
    local high = -math.huge
    for _, item in ipairs(blockers) do
        low = math.min(low, item.lateral - item.buffer)
        high = math.max(high, item.lateral + item.buffer)
    end

    local gaps = {}
    for i = 1, #blockers - 1 do
        local left = blockers[i].lateral + blockers[i].buffer
        local right = blockers[i + 1].lateral - blockers[i + 1].buffer
        if right > left then
            gaps[#gaps + 1] = {left = left, right = right, center = (left + right) * 0.5}
        end
    end

    local lateralMin = math.min(low - 9, lineLat - 28)
    local lateralMax = math.max(high + 9, lineLat + 28)
    if blockers[1].lateral - blockers[1].buffer > lateralMin then
        gaps[#gaps + 1] = {
            left = lateralMin,
            right = blockers[1].lateral - blockers[1].buffer,
            center = (lateralMin + blockers[1].lateral - blockers[1].buffer) * 0.5,
        }
    end
    if blockers[#blockers].lateral + blockers[#blockers].buffer < lateralMax then
        gaps[#gaps + 1] = {
            left = blockers[#blockers].lateral + blockers[#blockers].buffer,
            right = lateralMax,
            center = (blockers[#blockers].lateral + blockers[#blockers].buffer + lateralMax) * 0.5,
        }
    end

    for _, gap in ipairs(gaps) do
        local width = gap.right - gap.left
        if width >= SETTINGS.corridorMinWidth then
            local lateralOffset = gap.center - lineLat
            local linePoint = center + lateral * lateralOffset
            local aheadPoint = linePoint + axis * SETTINGS.corridorPassDistance
            local entryPoint = linePoint - axis * math.min(12, math.max(6, forwardDistance * 0.15))
            local entryClear = routeClear(position, flat(entryPoint - position), threats)
            local passClear = routeClear(position, flat(aheadPoint - position), threats)
            local edgeSafe = edgeDirectionClear(linePoint - axis * 4, axis, position.Y, 8)
            local centrality = 1 - math.min(math.abs(lateralOffset) / 28, 1)
            local score = width * 2.8 + centrality * 6 + math.min(passClear, 15) * 1.4 + math.min(entryClear, 10)
            if edgeSafe then
                score += 4
            else
                score -= 6
            end
            if passClear < -1.5 or entryClear < -1.5 then
                score -= 20
            end
            if score > bestScore then
                bestScore = score
                bestCenter = gap.center
                bestWidth = width
            end
        end
    end

    if not bestCenter then
        if runtime.corridorActive and now - runtime.corridorStartedAt <= SETTINGS.corridorLockTime then
            local lockedProgress = (position - runtime.corridorCenter):Dot(runtime.corridorAxis)
            if lockedProgress > -8 and lockedProgress < SETTINGS.corridorPassDistance + 10 then
                return runtime.corridorGoal
            end
        end
        clearCorridorLock()
        return nil
    end

    if runtime.corridorActive then
        local sameAxis = runtime.corridorAxis:Dot(axis) > 0.98
        local sameCenter = math.abs((runtime.corridorCenter - center):Dot(lateral) - (bestCenter - lineLat)) <= 5
        local progress = (position - runtime.corridorCenter):Dot(runtime.corridorAxis)
        if sameAxis and sameCenter and progress > -10 and progress < SETTINGS.corridorPassDistance + 12 then
            return runtime.corridorGoal
        end
    end

    local gapOffset = bestCenter - lineLat
    local linePoint = center + lateral * gapOffset
    local passPoint = linePoint + axis * SETTINGS.corridorPassDistance
    runtime.corridorActive = true
    runtime.corridorGoal = Vector3.new(passPoint.X, position.Y, passPoint.Z)
    runtime.corridorCenter = linePoint
    runtime.corridorAxis = axis
    runtime.corridorGapWidth = bestWidth
    runtime.corridorStartedAt = now
    return runtime.corridorGoal
end

local function corridorDirection(position, goal, threats)
    local desired = flat(goal - position)
    if desired.Magnitude < 0.05 then
        return Vector3.zero
    end
    desired = desired.Unit
    local candidates = {}
    if runtime.sideGapDirection.Magnitude > 0.05 and os.clock() < runtime.sideGapUntil then
        addDirection(candidates, runtime.sideGapDirection)
    end
    addDirection(candidates, desired)
    for _, angle in ipairs({12, -12, 24, -24, 38, -38, 52, -52, 70, -70, 90, -90}) do
        addDirection(candidates, rotate(desired, angle))
    end
    local best = desired
    local bestScore = -math.huge
    for _, candidate in ipairs(candidates) do
        local progress = candidate:Dot(desired)
        if progress >= -0.05 then
            local clearance = routeClear(position, candidate, threats)
            local score = progress * 8 + math.min(clearance, 16) * 2.2
            if clearance < 0 then
                score -= math.abs(clearance) * 16
            elseif clearance < 4 then
                score -= (4 - clearance) * 7
            end
            if score > bestScore then
                bestScore = score
                best = candidate
            end
        end
    end
    return best.Unit
end

local function chooseSideGapDirection(position, desired, threats)
    if not SETTINGS.sideGapEnabled or #threats == 0 then
        return nil, nil, -math.huge
    end
    local front = flat(desired)
    if front.Magnitude < 0.05 then
        return nil, nil, -math.huge
    end
    front = front.Unit
    local lateral = Vector3.new(-front.Z, 0, front.X)

    local nearest = nil
    local nearestDistance = math.huge
    for _, threat in ipairs(threats) do
        local rel = flat(threat.predicted - position)
        if rel.Magnitude > 0.05 then
            local forward = rel:Dot(front)
            local lateralOffset = math.abs(rel:Dot(lateral))
            if forward > 0 and forward <= 34 and lateralOffset <= 16 and threat.distance < nearestDistance then
                nearest = threat
                nearestDistance = threat.distance
            end
        end
    end
    if not nearest then
        return nil, nil, -math.huge
    end

    local rel = flat(nearest.predicted - position)
    local forwardGap = rel:Dot(front)
    local lateralOffset = rel:Dot(lateral)
    local frontBlocked = forwardGap > 0 and forwardGap < math.max(12, nearest.danger * 2.2)
        and math.abs(lateralOffset) < 13
    if not frontBlocked then
        return nil, nil, -math.huge
    end

    local candidates = {}
    for _, angle in ipairs(SETTINGS.sideGapAngles) do
        local rad = math.rad(angle)
        local c = math.cos(rad)
        local sn = math.sin(rad)
        local leftDir = (front * c + lateral * sn)
        local rightDir = (front * c - lateral * sn)
        candidates[#candidates + 1] = {dir = leftDir.Unit, side = "left"}
        candidates[#candidates + 1] = {dir = rightDir.Unit, side = "right"}
    end

    local best, bestScore, bestSide = nil, -math.huge, nil
    for _, item in ipairs(candidates) do
        local candidate = item.dir
        local clearance = routeClear(position, candidate, threats)
        local support = groundSupportScore(position, candidate, position.Y)
        local wallBlocked = invisWallHit(position, candidate, 16) ~= nil
        if not wallBlocked and support >= 3 and clearance >= -1 then
            local forwardProgress = candidate:Dot(front)
            local sideProgress = math.abs(candidate:Dot(lateral))
            local score = forwardProgress * SETTINGS.sideGapForwardBias
                + sideProgress * 7
                + math.min(clearance, 14) * 3.2
                + support * 1.4
            local towardCatcher = rel:Dot(lateral)
            local away = item.side == "left" and -towardCatcher or towardCatcher
            score += math.clamp(away / 10, -1, 1) * 4
            if clearance >= SETTINGS.sideGapMinClearance then
                score += 5
            end
            if score > bestScore then
                best = candidate
                bestScore = score
                bestSide = item.side
            end
        end
    end

    if best then
        return best, bestSide, bestScore
    end
    return nil, nil, -math.huge
end

local function chooseRunnerDirection(position, goal, threats)
    local desired = flat(goal - position)
    if desired.Magnitude < 0.05 then
        return Vector3.zero
    end
    desired = desired.Unit

    local sideGap, sideName = chooseSideGapDirection(position, desired, threats)
    if sideGap then
        runtime.sideGapDirection = sideGap
        runtime.sideGapUntil = os.clock() + SETTINGS.sideGapCommitTime
        runtime.sideGapReason = "front-blocked:" .. tostring(sideName)
        return sideGap
    elseif runtime.sideGapDirection.Magnitude > 0.05 and os.clock() < runtime.sideGapUntil then
        local clear = routeClear(position, runtime.sideGapDirection, threats)
        if clear >= 0 and not invisWallHit(position, runtime.sideGapDirection, 14) then
            return runtime.sideGapDirection
        end
    else
        runtime.sideGapDirection = Vector3.zero
        runtime.sideGapReason = ""
    end

    if not SETTINGS.avoidCatchers or #threats == 0 then
        runtime.sideGapDirection = Vector3.zero
        runtime.sideGapUntil = -math.huge
        runtime.sideGapReason = ""
        return desired
    end

    local candidates = {}
    addDirection(candidates, desired)

    for _, angle in ipairs({
        10, -10, 22, -22, 34, -34, 48, -48, 62, -62, 76, -76, 88, -88
    }) do
        addDirection(candidates, rotate(desired, angle))
    end

    local blocker = threats[1]
    local nearestScore = math.huge
    for _, threat in ipairs(threats) do
        local toThreat = flat(threat.position - position)
        local ahead = toThreat:Dot(desired)
        local distance = toThreat.Magnitude
        if ahead > 0 and distance < nearestScore then
            nearestScore = distance
            blocker = threat
        end
    end

    if blocker then
        local toBlocker = flat(blocker.position - position)
        if toBlocker.Magnitude > 0.05 then
            local lateral = Vector3.new(-desired.Z, 0, desired.X)
            local side = toBlocker:Dot(lateral) >= 0 and -1 or 1
            addDirection(candidates, (desired + lateral * side * 0.55).Unit)
            addDirection(candidates, (desired + lateral * side * 0.95).Unit)
            addDirection(candidates, (desired - lateral * side * 0.55).Unit)
            addDirection(candidates, (desired - lateral * side * 0.95).Unit)
        end
    end

    if runtime.stuck then
        local lateral = Vector3.new(-desired.Z, 0, desired.X)
        addDirection(candidates, lateral)
        addDirection(candidates, -lateral)
        local center = getPlayfieldCenter()
        if center then
            addDirection(candidates, flat(center - position))
        end
    end

    local best = desired
    local bestScore = -math.huge
    local emergency = false
    for _, threat in ipairs(threats) do
        if threat.collisionRisk or threat.tackle
            or (threat.preTackle and threat.closing > 0) then
            emergency = true
            break
        end
    end

    for _, candidate in ipairs(candidates) do
        local progress = candidate:Dot(desired)
        local clearance = routeClear(position, candidate, threats)
        local wallBlocked = invisWallHit(position, candidate, 18) ~= nil
        if wallBlocked then
            continue
        end

        if not emergency and progress < 0.04 then
            continue
        end

        local score = progress * 10
        score += math.min(clearance, 20) * 2.4 * SETTINGS.avoidStrength

        if clearance < 0 then
            score -= math.abs(clearance) * 18 * SETTINGS.avoidStrength
        elseif clearance < 5 then
            score -= (5 - clearance) * 5 * SETTINGS.avoidStrength
        end

        if progress > 0.18 and math.abs(candidate:Dot(desired)) < 0.96 then
            score += math.min(math.max(clearance, 0), 8) * 1.15
        end

        for _, threat in ipairs(threats) do
            local away = flat(position - threat.intercept)
            if away.Magnitude > 0.05 then
                local urgency = math.clamp(
                    1 - math.min(
                        threat.interceptGap,
                        threat.timeToDanger * math.max(threat.closing, 1)
                    ) / math.max(threat.danger * 3, 1),
                    0,
                    1
                )
                local weight = (threat.collisionRisk and 14 or 4.5) * SETTINGS.avoidStrength
                if threat.tackle then
                    weight *= 1.45
                end
                score += candidate:Dot(away.Unit) * urgency * weight
            end
        end

        if runtime.edgeRisk then
            local inward = runtime.edgeDirection
            if inward.Magnitude > 0.05 then
                score += candidate:Dot(inward.Unit) * 7
            end
        end

        if score > bestScore then
            bestScore = score
            best = candidate
        end
    end

    if best.Magnitude < 0.05 then
        return desired
    end
    return best.Unit
end

local function chooseDashDirection(position, direction, threats)
    local desired = flat(direction)
    local root = getRoot()
    if desired.Magnitude < 0.05 and root then
        desired = flat(root.CFrame.LookVector)
    end
    if desired.Magnitude < 0.05 then
        return Vector3.zero
    end
    desired = desired.Unit

    local candidates = {}
    addDirection(candidates, desired)
    for _, angle in ipairs({
        18, -18, 32, -32, 48, -48, 64, -64, 82, -82, 90, -90
    }) do
        addDirection(candidates, rotate(desired, angle))
    end

    if runtime.edgeRisk and runtime.edgeDirection.Magnitude > 0.05 then
        addDirection(candidates, runtime.edgeDirection)
        addDirection(candidates, rotate(runtime.edgeDirection, 28))
        addDirection(candidates, rotate(runtime.edgeDirection, -28))
    end

    local awaySum = Vector3.zero
    for i = 1, math.min(6, #threats) do
        local threat = threats[i]
        local away = flat(position - threat.predicted)
        if away.Magnitude > 0.05 then
            local weight = math.clamp(1 - threat.distance / 60, 0.2, 1)
            if threat.tackle then
                weight *= 2.2
            elseif threat.preTackle then
                weight *= 1.5
            end
            awaySum += away.Unit * weight
        end
    end
    if awaySum.Magnitude > 0.05 then
        addDirection(candidates, awaySum.Unit)
        addDirection(candidates, rotate(awaySum.Unit, 28))
        addDirection(candidates, rotate(awaySum.Unit, -28))
    end

    local best = desired
    local bestScore = -math.huge
    for _, candidate in ipairs(candidates) do
        local clearance = routeClear(position, candidate, threats)
        local progress = candidate:Dot(desired)
        local score = progress * 4.5 + math.min(clearance, 20) * 5.0

        if progress < -0.05 then
            score -= 18
        end

        if clearance < 0 then
            score -= math.abs(clearance) * 22
        elseif clearance < 5 then
            score -= (5 - clearance) * 5
        end

        if awaySum.Magnitude > 0.05 then
            score += candidate:Dot(awaySum.Unit) * 7
        end

        if runtime.edgeRisk and runtime.edgeDirection.Magnitude > 0.05 then
            score += candidate:Dot(runtime.edgeDirection.Unit) * 10
        end

        for _, threat in ipairs(threats) do
            local predicted = threat.predicted
            local dashPoint = position + candidate * math.min(getRunnerSpeed() * 0.45, 11)
            local gap = flat(dashPoint - predicted).Magnitude
            if gap <= threat.danger * (threat.tackle and 1.55 or 1.2) then
                score -= threat.tackle and 14 or 8
            end
        end

        if score > bestScore then
            bestScore = score
            best = candidate
        end
    end

    return best.Unit
end

local function getAbilityKey()
    local state = runtime.armory
    if type(state) ~= "table" or state.loaded ~= true then
        return nil
    end

    local candidates = {}
    local function add(value)
        if type(value) ~= "string" or value == "" then
            return
        end
        for i = 1, #candidates do
            if candidates[i] == value then
                return
            end
        end
        candidates[#candidates + 1] = value
    end

    local ok, value = pcall(GearCatalog.equippedForRole, state, "Runner")
    if ok then add(value) end
    ok, value = pcall(GearCatalog.equippedForRole, "Runner", state)
    if ok then add(value) end
    ok, value = pcall(GearCatalog.equippedForRole, "Runner")
    if ok then add(value) end

    add(state.equippedAbility)
    add(state.RunnerAbility)
    add(state.runnerAbility)

    local equipped = state.equipped or state.Equipped or state.loadout or state.Loadout
    if type(equipped) == "table" then
        add(equipped.Runner)
        add(equipped.runner)
        add(equipped.Ability)
        add(equipped.ability)
    end

    for i = 1, #candidates do
        local key = candidates[i]
        local okDef, def = pcall(GearCatalog.get, key)
        if okDef and def and def.Kind == "Ability" then
            if (not def.UseRole or def.UseRole == "Runner")
                and type(state.abilities) == "table"
                and state.abilities[key] == true then
                return key
            end
        end
    end
    return nil
end

local function requestDash(direction, now)
    if not SETTINGS.autoDash or not isRunnerActive() then
        return false
    end

    local character = getCharacter()
    local root = getRoot()
    if not character or not root then
        runtime.dashStatus = "no-character"
        return false
    end

    local okAvailable, available = pcall(BoostInput.available, LocalPlayer)
    if not okAvailable then
        runtime.dashStatus = "available-error: " .. tostring(available)
        return false
    end
    if available ~= true then
        local cooldownUntil = tonumber(character:GetAttribute("DashCooldownUntil")) or 0
        runtime.dashStatus = cooldownUntil > os.clock() and "cooldown" or "not-available"
        return false
    end

    local cooldownUntil = tonumber(character:GetAttribute("DashCooldownUntil")) or 0
    if os.clock() < cooldownUntil then
        runtime.dashStatus = "cooldown"
        return false
    end

    if now - runtime.dashAt < SETTINGS.dashCooldown then
        runtime.dashStatus = "local-cooldown"
        return false
    end

    local hum = getHumanoid()
    local dir = hum and flat(hum.MoveDirection) or Vector3.zero
    if dir.Magnitude < 0.05 then
        dir = flat(direction)
    end
    if dir.Magnitude < 0.05 then
        dir = flat(root.CFrame.LookVector)
    end
    if dir.Magnitude < 0.05 then
        runtime.dashStatus = "no-direction"
        return false
    end

    local beforeCount = tonumber(character:GetAttribute("DashCount")) or 0
    local okRequest, result = pcall(BoostInput.request, nil)
    runtime.dashLastRequestAt = now
    runtime.dashLastCount = beforeCount

    if not okRequest then
        runtime.dashStatus = "request-error: " .. tostring(result)
        return false
    end
    if result == false then
        runtime.dashStatus = "request-rejected"
        return false
    end

    runtime.dashAt = now
    runtime.dashStatus = "requested:waiting-game-client"
    return true
end

local function shouldDash(position, threats, goalDistance)
    if not SETTINGS.autoDash or not isRunnerActive() then
        return false
    end

    local now = os.clock()
    if now - runtime.dashAt < 0.28 then
        return false
    end

    if #threats == 0 then
        return false
    end

    local nearestDistance = math.huge
    local nearestThreat = nil
    local immediateDanger = false
    local hardBlock = false
    local imminentTime = math.huge

    for _, threat in ipairs(threats) do
        if threat.distance < nearestDistance then
            nearestDistance = threat.distance
            nearestThreat = threat
        end
        local gap = tonumber(threat.interceptGap) or math.huge
        local danger = math.max(tonumber(threat.danger) or 4, 4)
        imminentTime = math.min(imminentTime, tonumber(threat.timeToDanger) or math.huge)

        if threat.tackle and (
            gap <= danger * 1.12
            or (threat.timeToDanger or math.huge) <= 0.38
            or threat.distance <= 10
        ) then
            immediateDanger = true
        elseif threat.preTackle and (
            gap <= danger * 1.05
            and (threat.timeToDanger or math.huge) <= 0.48
        ) then
            immediateDanger = true
        elseif threat.collisionRisk and (
            gap <= danger * 1.02
            and (threat.timeToDanger or math.huge) <= 0.42
        ) then
            immediateDanger = true
        end
    end

    local currentPath = runtime.path
    if currentPath.Magnitude > 0.05 then
        local pathClearance = routeClear(position, currentPath, threats)
        if pathClearance < -2.0 and nearestDistance <= 18 then
            hardBlock = true
        end
    end

    if runtime.sideGapDirection.Magnitude > 0.05
        and os.clock() < runtime.sideGapUntil
        and nearestDistance <= 14 then
        local sideClearance = routeClear(position, runtime.sideGapDirection, threats)
        if sideClearance >= SETTINGS.sideGapMinClearance and imminentTime <= 0.55 then
            return true
        end
    end

    if immediateDanger then
        return true
    end

    if hardBlock and nearestDistance <= 15 and imminentTime <= 0.55 then
        return true
    end

    if nearestThreat and nearestDistance <= 9 and imminentTime <= 0.45 then
        return true
    end

    return false
end
local function runnerGoal(position, now)
    runtime.goalMode = "SafeZone"
    local goal = select(1, chooseSafeGoal(position))
    if not goal and SETTINGS.emergencySafeZone then
        goal = getSafeFallback(position)
    end
    runtime.goal = goal
    return goal
end

local function routeDistance(position, goal, target)
    local a = flat(position)
    local b = flat(goal)
    local p = flat(target)
    local line = b - a
    local lengthSquared = line:Dot(line)
    if lengthSquared < 0.01 then
        return (p - a).Magnitude, 0
    end
    local t = math.clamp((p - a):Dot(line) / lengthSquared, 0, 1)
    local closest = a + line * t
    return (p - closest).Magnitude, t
end

local function validReviveTarget(target)
    if not target or not target.Parent then
        return false
    end
    local character = target.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end
    if character:GetAttribute("RescueAvailable") ~= true or character:GetAttribute("Ragdolled") ~= true then
        return false
    end
    local helper = character:GetAttribute("RescueHelperId")
    return helper == nil or helper == LocalPlayer.UserId
end

local function chooseAssistTarget(position, safeGoal, now)
    if not safeGoal then
        runtime.assistMode = nil
        runtime.assistTarget = nil
        return nil, nil
    end

    local currentAssist = runtime.assistTarget
    if runtime.assistMode == "Revive" then
        if validReviveTarget(currentAssist) then
            local targetRoot = getRoot(currentAssist)
            if targetRoot then
                local distance = flat(targetRoot.Position - position).Magnitude
                local lateral = routeDistance(position, safeGoal, targetRoot.Position)
                if runtime.reviveStarted or distance <= SETTINGS.reviveMaxDistance and (lateral <= 24 or distance <= RESCUE_RANGE + 5) then
                    return currentAssist, "Revive"
                end
            end
        end
        if runtime.reviveStarted then
            return currentAssist, "Revive"
        end
        runtime.assistMode = nil
        runtime.assistTarget = nil
    elseif runtime.assistMode == "Gem" then
        if currentAssist and currentAssist.Parent then
            local distance = flat(currentAssist.Position - position).Magnitude
            local lateral = routeDistance(position, safeGoal, currentAssist.Position)
            if distance <= SETTINGS.gemMaxDistance and lateral <= 18 then
                return currentAssist, "Gem"
            end
        end
        runtime.assistMode = nil
        runtime.assistTarget = nil
    end

    local reviveCandidate
    if SETTINGS.autoRevive then
        local target = findDownedPlayer(position)
        if target then
            local targetRoot = getRoot(target)
            if targetRoot then
                local distance = flat(targetRoot.Position - position).Magnitude
                local lateral, t = routeDistance(position, safeGoal, targetRoot.Position)
                if distance <= SETTINGS.reviveMaxDistance and t <= 1.05 and (lateral <= 24 or distance <= RESCUE_RANGE + 5) then
                    reviveCandidate = target
                end
            end
        end
    end

    local gemCandidate
    if SETTINGS.autoGems then
        refreshGems(now, position)
        local gem = runtime.gemTarget
        if gem and gem.Parent then
            local distance = flat(gem.Position - position).Magnitude
            local lateral, t = routeDistance(position, safeGoal, gem.Position)
            if distance <= SETTINGS.gemMaxDistance and t <= 1.05 and lateral <= 18 then
                gemCandidate = gem
            end
        end
    end

    if SETTINGS.reviveBeforeGems and reviveCandidate then
        runtime.assistMode = "Revive"
        runtime.assistTarget = reviveCandidate
        runtime.assistSince = now
        return reviveCandidate, "Revive"
    end
    if gemCandidate then
        runtime.assistMode = "Gem"
        runtime.assistTarget = gemCandidate
        runtime.assistSince = now
        return gemCandidate, "Gem"
    end
    if reviveCandidate then
        runtime.assistMode = "Revive"
        runtime.assistTarget = reviveCandidate
        runtime.assistSince = now
        return reviveCandidate, "Revive"
    end

    return nil, nil
end

local function handleGemArrival(position, now)
    local gem = runtime.gemTarget
    if not gem or not gem.Parent then
        return
    end
    if flat(gem.Position - position).Magnitude <= SETTINGS.gemCollectDistance then
        runtime.gemIgnored[gem] = now + 0.7
        runtime.gemTarget = nil
    end
end

local function movementStuck(now, position)
    local previous = runtime.lastMovePosition
    if not previous then
        runtime.lastMovePosition = position
        runtime.lastMove = now
        runtime.stuck = false
        return
    end
    if flat(position - previous).Magnitude >= 0.5 then
        runtime.lastMovePosition = position
        runtime.lastMove = now
        runtime.stuck = false
    elseif now - runtime.lastMove > 0.55 then
        runtime.stuck = true
        runtime.lastMove = now
        runtime.lastMovePosition = position
    end
end

local function runnerStep(now, dt)

    local role = getRole()
    local state = getRunState()

    if role ~= "Runner" or state ~= "Active" then
        runtime.path = Vector3.zero
        runtime.runnerPlanAt = -math.huge
        runtime.runnerPlanDirection = Vector3.zero
        runtime.runnerPlanGoal = Vector3.zero
        runtime.goal = nil
        runtime.goalSide = nil
        runtime.goalMode = "SafeZone"
        runtime.routeActive = false
        runtime.routeComplete = false
        runtime.routeStartSide = nil
        runtime.routeTargetSide = nil
        runtime.routeCompletePosition = nil
        runtime.routeCompleteAt = -math.huge
        clearCorridorLock()
        runtime.edgeRisk = false
        runtime.edgeDirection = Vector3.zero
        runtime.sideGapDirection = Vector3.zero
        runtime.sideGapUntil = -math.huge
        runtime.sideGapReason = ""
        runtime.assistMode = nil
        runtime.assistTarget = nil
        if runtime.reviveStarted then
            cancelRevive()
        end
        return
    end

    if not SETTINGS.runnerEnabled then
        return
    end

    local root = getRoot()
    local hum = getHumanoid()
    if not root or not hum then
        return
    end

    if not canMove() then
        runtime.path = Vector3.zero
        return
    end

    refreshPing(now)
    refreshSafezones()
    refreshCatchers(now)
    local position = root.Position

    local baseGoal = runnerGoal(position, now)
    if runtime.routeComplete then
        local targetZone = runtime.routeTargetSide == (safezone.a and safezone.a.name) and safezone.a or safezone.b
        local movedFromCompletion = runtime.routeCompletePosition and flat(position - runtime.routeCompletePosition).Magnitude or 0
        local newRoundPosition = targetZone and inZone(position, targetZone) and movedFromCompletion >= 5 and now - runtime.routeCompleteAt >= 0.25
        if newRoundPosition then
            runtime.routeActive = false
            runtime.routeComplete = false
            runtime.routeStartSide = nil
            runtime.routeTargetSide = nil
            runtime.routeCompletePosition = nil
            runtime.routeCompleteAt = -math.huge
            runtime.goal = nil
            runtime.goalSide = nil
            baseGoal = runnerGoal(position, now)
        end
        if runtime.routeComplete then
            clearCorridorLock()
            runtime.path = Vector3.zero
            runtime.goalMode = "SafeZone"
            runtime.assistMode = nil
            runtime.assistTarget = nil
            if runtime.reviveStarted then
                cancelRevive()
            end
            hum:Move(Vector3.zero, false)
                            return
        end
    end
    if not baseGoal then
        local fallback = getSafeFallback(position)
        if fallback then
            baseGoal = fallback
            runtime.goal = fallback
            runtime.goalMode = "SafeZone"
        else
            local forward = flat(root.CFrame.LookVector)
            if forward.Magnitude > 0.05 then
                baseGoal = position + forward.Unit * 40
            end
        end
    end

    if not baseGoal then
        hum:Move(Vector3.zero, false)
        runtime.path = Vector3.zero
        return
    end

    local assistTarget, assistMode = chooseAssistTarget(position, baseGoal, now)
    local movementGoal = baseGoal

    if assistTarget and assistMode == "Revive" then
        runtime.reviveTarget = assistTarget
        local targetRoot = getRoot(assistTarget)
        if targetRoot then
            local targetPosition = targetRoot.Position
            local distance = flat(targetPosition - position).Magnitude
            if distance <= RESCUE_RANGE + 0.75 or runtime.reviveStarted then
                updateRevive(now, position)
            end
            if not runtime.reviveStarted and distance > RESCUE_RANGE then
                movementGoal = targetPosition
            elseif runtime.reviveStarted then
                movementGoal = targetPosition
            end
        end
    elseif assistTarget and assistMode == "Gem" and assistTarget.Parent then
        movementGoal = assistTarget.Position
        runtime.goalMode = "Gem"
    else
        runtime.goalMode = "SafeZone"
    end

    if runtime.reviveStarted then
        local targetRoot = runtime.reviveTarget and getRoot(runtime.reviveTarget)
        if targetRoot then
            local reviveDistance = flat(targetRoot.Position - position).Magnitude
            if reviveDistance > RESCUE_RANGE + 1.25 then
                cancelRevive()
            else
                hum:Move(Vector3.zero, false)
                runtime.path = Vector3.zero
                                        return
            end
        else
            cancelRevive()
        end
    end

    movementStuck(now, position)
    local threats = updateThreats(now, position)

    local distanceToGoal = flat(movementGoal - position).Magnitude
    local arriveDistance = runtime.goalMode == "Gem" and SETTINGS.gemCollectDistance or 2.5

    if distanceToGoal <= arriveDistance then
        if runtime.goalMode == "Gem" then
            handleGemArrival(position, now)
            runtime.assistMode = nil
            runtime.assistTarget = nil
            runtime.goalMode = "SafeZone"
            movementGoal = baseGoal
        elseif runtime.goalMode == "SafeZone" then
            local nextGoal = select(1, chooseSafeGoal(position))
            if runtime.routeComplete then
                hum:Move(Vector3.zero, false)
                runtime.path = Vector3.zero
                                        return
            end
            movementGoal = nextGoal or baseGoal
            runtime.goal = movementGoal
        end
    end

    if not movementGoal then
        hum:Move(Vector3.zero, false)
        runtime.path = Vector3.zero
        return
    end

    local direction = flat(movementGoal - position)
    if direction.Magnitude < 0.05 then
        hum:Move(Vector3.zero, false)
        runtime.path = Vector3.zero
        return
    end
    if runtime.goalMode == "SafeZone" and runtime.goal then
        movementGoal = Vector3.new(runtime.goal.X, position.Y, runtime.goal.Z)
        direction = flat(movementGoal - position)
        if direction.Magnitude < 0.05 then
            local nextGoal = select(1, chooseSafeGoal(position))
            movementGoal = nextGoal or movementGoal
            runtime.goal = movementGoal
            direction = flat(movementGoal - position)
            if direction.Magnitude < 0.05 then
                hum:Move(Vector3.zero, false)
                runtime.path = Vector3.zero
                return
            end
        end
    end
    direction = direction.Unit

    local corridorGoal = nil
    if runtime.goalMode == "SafeZone" and SETTINGS.avoidCatchers and #threats >= 2 then
        corridorGoal = findCorridorGoal(position, movementGoal, threats, now)
        if corridorGoal then
            movementGoal = corridorGoal
            direction = flat(corridorGoal - position)
            if direction.Magnitude > 0.05 then
                direction = corridorDirection(position, corridorGoal, threats)
            end
        end
    elseif runtime.corridorActive then
        clearCorridorLock()
    end

    if SETTINGS.avoidCatchers and #threats > 0 and not (corridorGoal and direction.Magnitude > 0.05) then
        direction = chooseRunnerDirection(position, movementGoal, threats)
    elseif SETTINGS.avoidCatchers and #threats > 0 and corridorGoal then
        direction = chooseRunnerDirection(position, movementGoal, threats)
        if runtime.corridorActive then
            direction = corridorDirection(position, movementGoal, threats)
        end
    end

    if runtime.corridorActive then
        local axis = runtime.corridorAxis
        local progress = (position - runtime.corridorCenter):Dot(axis)
        if progress >= SETTINGS.corridorPassDistance + 3 then
            clearCorridorLock()
        end
    end

    local hardThreat = threats[1]
    local hardDodge = false
    if SETTINGS.avoidCatchers and hardThreat and (hardThreat.collisionRisk or hardThreat.tackle or hardThreat.preTackle and hardThreat.closing > 0) then
        local escape = flat(position - hardThreat.intercept)
        if escape.Magnitude > 0.05 then
            local escapeDir = escape.Unit
            local candidates = {escapeDir, rotate(escapeDir, 35), rotate(escapeDir, -35), rotate(escapeDir, 70), rotate(escapeDir, -70)}
            if runtime.corridorActive then
                local forward = flat(runtime.corridorGoal - position)
                if forward.Magnitude > 0.05 then
                    local keep = {}
                    for _, candidate in ipairs(candidates) do
                        if candidate:Dot(forward.Unit) > 0.05 then
                            keep[#keep + 1] = candidate
                        end
                    end
                    candidates = keep
                end
            end
            local best = direction
            local bestClearance = routeClear(position, direction, threats)
            local forward = flat(movementGoal - position)
            local forwardUnit = forward.Magnitude > 0.05 and forward.Unit or direction
            local nearestGap = hardThreat.interceptGap
            local allowReverse = nearestGap <= hardThreat.danger * 0.52
            local foundForward = false

            for _, candidate in ipairs(candidates) do
                local progress = candidate:Dot(forwardUnit)
                if progress >= 0.08 then
                    foundForward = true
                elseif not allowReverse then
                    continue
                end
                local clear = routeClear(position, candidate, threats)
                local adjusted = clear + progress * 2.5
                local bestAdjusted = bestClearance + best:Dot(forwardUnit) * 2.5
                if adjusted > bestAdjusted then
                    best = candidate
                    bestClearance = clear
                end
            end
            local emergency = hardThreat.interceptGap <= hardThreat.danger * (runtime.corridorActive and 1.05 or 1.35)
            if emergency or bestClearance < 3 then
                direction = best
                hardDodge = true
            elseif foundForward then
                hardDodge = false
            end
        end
    end

    local nearestThreat
    local nearestDistance = math.huge
    for _, threat in ipairs(threats) do
        if threat.distance < nearestDistance then
            nearestDistance = threat.distance
            nearestThreat = threat
        end
    end

    if SETTINGS.emergencySafeZone and nearestThreat and nearestDistance <= SETTINGS.panicDistance and runtime.stuck then
        local fallback = getSafeFallback(position)
        if fallback then
            local safeDirection = flat(fallback - position)
            if safeDirection.Magnitude > 0.05 then
                direction = safeDirection.Unit
                movementGoal = fallback
                runtime.goalMode = "SafeZone"
                runtime.assistMode = nil
                runtime.assistTarget = nil
            end
        end
    end

    local nowEdge = now
    local edgeDirection, edgeRisk = chooseEdgeDirection(position, direction, movementGoal, position.Y)
    runtime.edgeRisk = edgeRisk
    runtime.edgeDirection = edgeDirection
    if edgeRisk and edgeDirection.Magnitude > 0.05 then
        if runtime.edgeRecoveryDirection.Magnitude < 0.05
            or nowEdge >= runtime.edgeRecoveryUntil
            or runtime.edgeRecoveryDirection:Dot(edgeDirection) < 0.92 then
            runtime.edgeRecoveryDirection = edgeDirection.Unit
            runtime.edgeRecoveryAt = nowEdge
            runtime.edgeRecoveryUntil = nowEdge + 0.72
        end
        direction = runtime.edgeRecoveryDirection
        hardDodge = true
    elseif nowEdge >= runtime.edgeRecoveryUntil then
        runtime.edgeRecoveryDirection = Vector3.zero
    end

    if runtime.stuck and movementGoal then
        local center = getPlayfieldCenter()
        local recovery = center and flat(center - position) or flat(movementGoal - position)
        if recovery.Magnitude > 0.05 then
            recovery = recovery.Unit
            if runtime.stuckRecoveryDirection.Magnitude < 0.05
                or nowEdge >= runtime.stuckRecoveryUntil
                or runtime.stuckRecoveryDirection:Dot(recovery) < 0.75 then
                local candidates = {
                    recovery,
                    rotateEdge(recovery, 35),
                    rotateEdge(recovery, -35),
                    rotateEdge(recovery, 70),
                    rotateEdge(recovery, -70),
                }
                local best = recovery
                local bestScore = -math.huge
                for _, candidate in ipairs(candidates) do
                    local support = groundSupportScore(position, candidate, position.Y)
                    local progress = candidate:Dot(recovery)
                    local score = support * 5 + progress * 4
                    if score > bestScore then
                        bestScore = score
                        best = candidate.Unit
                    end
                end
                runtime.stuckRecoveryDirection = best
                runtime.stuckRecoveryUntil = nowEdge + 0.85
            end
            direction = runtime.stuckRecoveryDirection
            hardDodge = true
        end
    elseif nowEdge >= runtime.stuckRecoveryUntil then
        runtime.stuckRecoveryDirection = Vector3.zero
    end

    if SETTINGS.smoothMovement and not hardDodge and runtime.path.Magnitude > 0.05 and not runtime.stuck then
        local alpha = math.clamp(SETTINGS.turnRate * math.clamp(dt or (1 / 60), 0.001, 0.1), 0, 1)
        local blended = flat(runtime.path:Lerp(direction, alpha))
        if blended.Magnitude > 0.05 then
            direction = blended.Unit
        end
    end

    runtime.path = direction

    if hum.AutoRotate ~= true then
        hum.AutoRotate = true
    end
    hum:Move(direction, false)

    local character = getCharacter()
    local dashCount = character and tonumber(character:GetAttribute("DashCount")) or nil
    if dashCount and runtime.dashLastCount ~= nil and dashCount ~= runtime.dashLastCount then
        runtime.dashStatus = "active:count " .. tostring(dashCount)
        runtime.dashLastCount = dashCount
    elseif runtime.dashLastRequestAt > 0 and now - runtime.dashLastRequestAt > 0.35
        and now - runtime.dashAt > 0.35 and runtime.dashStatus == "requested:waiting-game-client" then
        runtime.dashStatus = "no-dash-state-change"
    end

    local goalDistance = flat(movementGoal - position).Magnitude
    if shouldDash(position, threats, goalDistance) then
        local dashDir = chooseDashDirection(position, direction, threats)
        if runtime.sideGapDirection.Magnitude > 0.05 and os.clock() < runtime.sideGapUntil then
            dashDir = runtime.sideGapDirection
        elseif runtime.edgeRisk and runtime.edgeRecoveryDirection.Magnitude > 0.05 then
            dashDir = runtime.edgeRecoveryDirection
        elseif runtime.stuck and runtime.stuckRecoveryDirection.Magnitude > 0.05 then
            dashDir = runtime.stuckRecoveryDirection
        end
        requestDash(dashDir, now)
    end

end
local function refreshRunnerTargets(now)
    if now - runtime.catcherTargetAt < 0.15 then
        return
    end
    runtime.catcherTargetAt = now
    table.clear(runtime.catcherTargets)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Parent and player:GetAttribute("GameRole") == "Runner" and player:GetAttribute("RunState") == "Active" then
            local c = player.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if h and h.Health > 0 and r and c:GetAttribute("Ragdolled") ~= true then
                runtime.catcherTargets[#runtime.catcherTargets + 1] = player
            end
        end
    end
end

local function catcherVelocity(player, now)
    local root = getRoot(player)
    if not root then
        return Vector3.zero
    end
    local data = runtime.catcherVelocity[player]
    if not data then
        data = {velocity = flat(root.AssemblyLinearVelocity), time = now}
        runtime.catcherVelocity[player] = data
        return data.velocity
    end
    local raw = flat(root.AssemblyLinearVelocity)
    local dt = math.clamp(now - data.time, 0.01, 0.25)
    local alpha = math.clamp(dt * SETTINGS.catcherSmoothing, 0, 1)
    data.velocity = data.velocity:Lerp(raw, alpha)
    data.time = now
    return data.velocity
end

local function runnerSafeForCatcher(player)
    refreshSafezones()
    local root = getRoot(player)
    return root and currentZone(root.Position) ~= nil and (
        inZone(root.Position, safezone.a) or inZone(root.Position, safezone.b)
    )
end

local function selectCatcherTarget(now, myPosition)
    refreshRunnerTargets(now)
    local best, bestScore
    local currentScore
    local currentTarget = runtime.catcherTarget
    local chaseSpeed = math.max(getCatcherSpeed(), 1)

    for _, player in ipairs(runtime.catcherTargets) do
        local root = getRoot(player)
        if root then
            local position = root.Position
            local velocity = catcherVelocity(player, now)
            local predicted = position + velocity * SETTINGS.catcherPrediction
            local distance = flat(position - myPosition).Magnitude
            local predictedDistance = flat(predicted - myPosition).Magnitude
            local safe = runnerSafeForCatcher(player)
            local timeToReach = predictedDistance / chaseSpeed
            local score = predictedDistance + math.min(timeToReach * 10, 30) + distance * 0.05
            if SETTINGS.smartPriority and velocity.Magnitude >= 4 then
                score -= 6
            end
            if safe then
                score += 18
            end
            if player == currentTarget then
                currentScore = score
            end
            if not bestScore or score < bestScore then
                best = player
                bestScore = score
            end
        end
    end

    if currentTarget and currentScore and bestScore and currentTarget ~= best and currentScore <= bestScore + 8 then
        best = currentTarget
    end

    runtime.catcherTarget = best
    return best
end

local function catcherDirection(root, predicted, dt)
    local direction = flat(predicted - root.Position)
    if direction.Magnitude < 0.05 then
        return Vector3.zero
    end
    direction = direction.Unit
    if SETTINGS.smoothTurn and runtime.catcherPath and runtime.catcherPath.Magnitude > 0.05 then
        local alpha = math.clamp(1 - math.exp(-math.max(SETTINGS.turnRateCatcher, 1) * math.max(dt, 0.01)), 0, 1)
        local blended = runtime.catcherPath:Lerp(direction, alpha)
        if blended.Magnitude > 0.05 then
            direction = blended.Unit
        end
    end
    runtime.catcherPath = direction
    return direction
end

local function tackleRunning()
    local c = getCharacter()
    return c and c:GetAttribute("TackleActive") == true
end

local function catcherAttack(target, now, root)
    if not target or not root or tackleRunning() then
        return
    end
    local targetRoot = getRoot(target)
    if not targetRoot then
        return
    end

    local targetVelocity = catcherVelocity(target, now)
    local meleeLead = (ContactCatchConfig.Windup or 0.15) + (ContactCatchConfig.ActiveDuration or 0.1) * 0.5 + runtime.ping
    local meleePos = targetRoot.Position + targetVelocity * meleeLead
    local tacklePos = targetRoot.Position + targetVelocity * runtime.ping

    local meleeReady = SETTINGS.autoMelee and now - runtime.lastMelee >= SETTINGS.meleeCooldown
        and flat(meleePos - root.Position).Magnitude <= SETTINGS.meleeRange
    local tackleReady = SETTINGS.autoTackle and now - runtime.lastTackle >= SETTINGS.tackleCooldown
        and flat(tacklePos - root.Position).Magnitude <= SETTINGS.tackleRange

    if SETTINGS.catcherAttackPriority == "Tackle First" then
        if tackleReady then
            pcall(TacklePrediction.request)
            runtime.lastTackle = now
            return
        end
        if meleeReady then
            runtime.meleeId += 1
            pcall(MeleeEvent.FireServer, MeleeEvent, runtime.meleeId)
            runtime.lastMelee = now
        end
    elseif SETTINGS.catcherAttackPriority == "Melee First" then
        if meleeReady then
            runtime.meleeId += 1
            pcall(MeleeEvent.FireServer, MeleeEvent, runtime.meleeId)
            runtime.lastMelee = now
            return
        end
        if tackleReady then
            pcall(TacklePrediction.request)
            runtime.lastTackle = now
        end
    else
        if targetVelocity.Magnitude >= 5 and tackleReady then
            pcall(TacklePrediction.request)
            runtime.lastTackle = now
        elseif meleeReady then
            runtime.meleeId += 1
            pcall(MeleeEvent.FireServer, MeleeEvent, runtime.meleeId)
            runtime.lastMelee = now
        elseif tackleReady then
            pcall(TacklePrediction.request)
            runtime.lastTackle = now
        end
    end
end

local function catcherStep(now, dt)
    if not isCatcherActive() then
        runtime.catcherTarget = nil
        runtime.catcherPath = Vector3.zero
        return
    end
    local root = getRoot()
    local hum = getHumanoid()
    if not root or not hum or hum.Health <= 0 or hum.PlatformStand or hum.Sit then
        return
    end
    refreshPing(now)
    local needsTarget = SETTINGS.catcherChase or SETTINGS.autoTackle or SETTINGS.autoMelee or SETTINGS.followTarget
    if not needsTarget then
        runtime.catcherTarget = nil
        runtime.catcherPath = Vector3.zero
        return
    end

    local target = selectCatcherTarget(now, root.Position)
    if not target then
        runtime.catcherTarget = nil
        return
    end
    local targetRoot = getRoot(target)
    if not targetRoot then
        runtime.catcherTarget = nil
        return
    end

    local velocity = catcherVelocity(target, now)
    local predicted = targetRoot.Position + velocity * SETTINGS.catcherPrediction
    local direction = catcherDirection(root, predicted, dt)

    if SETTINGS.catcherChase and direction.Magnitude > 0.05 then
        hum.AutoRotate = true
        hum:Move(direction, false)
    end

    if SETTINGS.autoTackle or SETTINGS.autoMelee then
        catcherAttack(target, now, root)
    end

    if SETTINGS.followTarget then
        local camera = workspace.CurrentCamera
        if camera then
            camera.CFrame = camera.CFrame:Lerp(
                CFrame.lookAt(camera.CFrame.Position, predicted + Vector3.new(0, 1.5, 0)),
                math.clamp(SETTINGS.cameraResponse, 0.01, 1)
            )
        end
    end
end

local function ensurePart(store, key, size, color, transparency)
    local part = store[key]
    if part and part.Parent then
        return part
    end
    part = Instance.new("Part")
    part.Name = "CoH_Utility"
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(size, size, size)
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Material = Enum.Material.ForceField
    part.Color = color
    part.Transparency = transparency
    part.Parent = workspace
    store[key] = part
    return part
end

local function cleanupVisuals()
    if visuals.goal and visuals.goal.Parent then
        visuals.goal:Destroy()
    end
    visuals.goal = nil
    for key, part in pairs(visuals.threats) do
        if part.Parent then
            part:Destroy()
        end
        visuals.threats[key] = nil
    end
    for key, part in pairs(visuals.hitboxes) do
        if part.Parent then
            part:Destroy()
        end
        visuals.hitboxes[key] = nil
    end
end

local function getGuiText(gui)
    if not gui then
        return ""
    end
    local ok, value = pcall(function()
        if gui:IsA("TextButton") or gui:IsA("TextLabel") then
            return gui.Text or ""
        end
        return gui:GetAttribute("Text") or ""
    end)
    return ok and tostring(value or "") or ""
end

local function wheelNameScore(gui, mode)
    if not gui or not gui:IsA("GuiButton") then
        return -math.huge
    end
    local name = string.lower(gui.Name or "")
    local text = string.lower(getGuiText(gui))
    local all = name .. " " .. text
    local score = 0

    if mode == "spin" then
        if all:find("spin", 1, true) then score += 100 end
        if all:find("free", 1, true) then score += 20 end
        if all:find("roll", 1, true) then score += 12 end
        if all:find("claim", 1, true) then score -= 25 end
        if all:find("close", 1, true) then score -= 80 end
        if all:find("back", 1, true) then score -= 60 end
    else
        if all:find("spin", 1, true) then score += 90 end
        if all:find("wheel", 1, true) then score += 70 end
        if all:find("daily", 1, true) then score += 10 end
        if all:find("emote", 1, true) then score -= 100 end
        if all:find("close", 1, true) then score -= 50 end
    end

    if not gui.Visible then score -= 100 end
    if not gui.Active then score -= 20 end
    return score
end

local function findWheelButton(mode)
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then
        return nil
    end

    local best, bestScore = nil, -math.huge
    local ok, descendants = pcall(function()
        return playerGui:GetDescendants()
    end)
    if not ok then
        return nil
    end

    for _, gui in ipairs(descendants) do
        if gui:IsA("GuiButton") and gui.Visible and gui.Active then
            local score = wheelNameScore(gui, mode)
            if score > bestScore then
                best, bestScore = gui, score
            end
        end
    end

    if bestScore >= (mode == "spin" and 90 or 70) then
        return best
    end

    return nil
end


local function guiContextText(gui, depth)
    local parts = {}
    local current = gui
    local levels = depth or 5
    for _ = 1, levels do
        if not current then
            break
        end
        local name = tostring(current.Name or "")
        local text = getGuiText(current)
        if name ~= "" then
            table.insert(parts, name)
        end
        if text ~= "" then
            table.insert(parts, text)
        end
        current = current.Parent
    end
    return string.lower(table.concat(parts, " "))
end

local function getGuiLabelText(gui)
    local direct = getGuiText(gui)
    if direct ~= "" then
        return direct
    end

    local ok, descendants = pcall(function()
        return gui:GetDescendants()
    end)
    if not ok then
        return ""
    end

    for index = 1, math.min(#descendants, 12) do
        local child = descendants[index]
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            local text = tostring(child.Text or "")
            if text ~= "" then
                return text
            end
        end
    end

    return ""
end

local function requestJourneyState(force)
    local now = os.clock()
    if not force and now - runtime.journeyRequestAt < 1.5 then
        return false
    end
    runtime.journeyRequestAt = now
    local ok = pcall(function()
        JourneyEvent:FireServer("Get")
    end)
    if not ok then
        runtime.journeyStatus = "Journey state request failed"
        return false
    end
    return true
end

local function journeyClaimableCount()
    if not runtime.journeyLoaded then
        return 0
    end

    local trackId = JourneyConfig.TrackId
    local tier = math.max(1, tonumber(runtime.journeyTier) or 1)
    local premium = runtime.journeyPremium == true
    local claims = runtime.journeyClaims or {}
    local count = 0

    for index = 1, tier do
        local rewardTier = JourneyConfig.Rewards[index]
        if rewardTier then
            local freeReward = rewardTier.Free
            if freeReward and claims[trackId .. ":" .. tostring(freeReward.Key)] ~= true then
                count += 1
            end
            if premium then
                local premiumReward = rewardTier.Premium
                if premiumReward and claims[trackId .. ":" .. tostring(premiumReward.Key)] ~= true then
                    count += 1
                end
            end
        end
    end

    return count
end

local function journeyClaimOnce(manual)
    if not SETTINGS.autoClaimJourneyRewards and not manual then
        runtime.journeyStatus = "disabled"
        return false
    end

    if LocalPlayer:GetAttribute("InMatch") == true then
        runtime.journeyStatus = "waiting for lobby"
        return false
    end

    local now = os.clock()
    if now < (runtime.journeyNextClaimAt or -math.huge) then
        return false
    end

    if runtime.journeyClaimInFlight then
        runtime.journeyStatus = "claim request pending"
        return false
    end

    if not runtime.journeyLoaded then
        runtime.journeyManualPending = manual == true or runtime.journeyManualPending
        runtime.journeyStatus = "loading journey state"
        requestJourneyState(true)
        return false
    end

    local seasonId = runtime.journeySeasonId or JourneyConfig.SeasonId
    if type(seasonId) ~= "string" or seasonId == "" then
        runtime.journeyStatus = "season unavailable"
        return false
    end

    local available = journeyClaimableCount()
    if available <= 0 and not manual then
        runtime.journeyStatus = "no claimable rewards"
        runtime.journeyNextClaimAt = now + 2.5
        return false
    end

    runtime.journeyClaimInFlight = true
    runtime.journeyManualPending = false
    runtime.journeyLastClaimAt = now
    runtime.journeyNextClaimAt = now + 2.5
    runtime.journeyStatus = available > 0 and string.format("claiming %d reward%s", available, available == 1 and "" or "s") or "claiming available rewards"

    local fired = pcall(function()
        JourneyEvent:FireServer("ClaimAll", nil, seasonId)
    end)

    if not fired then
        runtime.journeyClaimInFlight = false
        runtime.journeyStatus = "claim request failed"
        runtime.journeyNextClaimAt = now + 1
        return false
    end

    task.delay(1.25, function()
        if runtime.journeyClaimInFlight then
            runtime.journeyClaimInFlight = false
            runtime.journeyStatus = "waiting for confirmation"
            requestJourneyState(true)
        end
    end)

    return true
end

local function getSelectedMapSlot()
    local selections = SETTINGS.mapVoteSelections or {}
    local selected = selections[1]
    if selected and table.find(MAP_VOTE_SLOT_IDS, selected) then
        return selected
    end
    return nil
end

local function setDebugError(value)
    runtime.debugLastError = tostring(value or "")
    runtime.debugLastErrorAt = os.clock()
end

local function getDebugGui()
    if runtime.debugGui and runtime.debugGui.Parent and runtime.debugLabel and runtime.debugLabel.Parent then
        return runtime.debugGui, runtime.debugLabel
    end

    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    if not playerGui then
        return nil, nil
    end

    local old = playerGui:FindFirstChild("CoH_FullDebug")
    if old then
        old:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CoH_FullDebug"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Enabled = false
    gui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "Panel"
    frame.Size = UDim2.fromOffset(470, 360)
    frame.Position = UDim2.fromOffset(10, 70)
    frame.BackgroundTransparency = 0.12
    frame.BackgroundColor3 = Color3.fromRGB(10, 14, 22)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = "Status"
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.fromOffset(10, 10)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(235, 240, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.TextWrapped = false
    label.Text = "Huss Valley | FULL DEBUG"
    label.Parent = frame

    runtime.debugGui = gui
    runtime.debugLabel = label
    return gui, label
end

local function updateDebugPanel(now)
    if not runtime.debugEnabled then
        if runtime.debugGui then
            runtime.debugGui.Enabled = false
        end
        return
    end

    local gui, label = getDebugGui()
    if not gui or not label then
        return
    end

    gui.Enabled = true

    local character = getCharacter()
    local humanoid = getHumanoid()
    local root = getRoot()
    local position = root and root.Position or Vector3.zero
    local goalDistance = runtime.goal and flat(runtime.goal - position).Magnitude or -1
    local speed = humanoid and humanoid.WalkSpeed or -1
    local health = humanoid and humanoid.Health or -1
    local safeA = safezone.a and safezone.a.name or "nil"
    local safeB = safezone.b and safezone.b.name or "nil"
    local threat = runtime.threats[1]
    local errorText = runtime.debugLastError ~= nil and runtime.debugLastError ~= "" and runtime.debugLastError or "none"
    local errorAge = runtime.debugLastErrorAt > 0 and math.max(0, now - runtime.debugLastErrorAt) or -1
    local wheelStateAge = runtime.wheelLastStateAt > 0 and math.max(0, now - runtime.wheelLastStateAt) or -1
    local journeyAge = runtime.journeyLastStateAt > 0 and math.max(0, now - runtime.journeyLastStateAt) or -1
    local mapAge = runtime.mapVoteLastStateAt > 0 and math.max(0, now - runtime.mapVoteLastStateAt) or -1
    local selectedMap = getSelectedMapSlot() or "none"
    local path = runtime.path or Vector3.zero

    label.Text = table.concat({
        "Huss Valley | FULL DEBUG",
        string.format("Role=%s | RunState=%s | InMatch=%s | ClientReady=%s", tostring(getRole()), tostring(getRunState()), tostring(LocalPlayer:GetAttribute("InMatch")), tostring(LocalPlayer:GetAttribute("ClientReady"))),
        string.format("MovementLocked=%s | Ragdolled=%s | GearMotion=%s | HP=%.1f | WalkSpeed=%.1f", tostring(character and character:GetAttribute("MovementLocked")), tostring(character and character:GetAttribute("Ragdolled")), tostring(character and character:GetAttribute("GearMotion")), health, speed),
        string.format("Position=%.1f, %.1f, %.1f | GoalMode=%s | GoalDistance=%.1f", position.X, position.Y, position.Z, tostring(runtime.goalMode), goalDistance),
        string.format("SafeA=%s | SafeB=%s | Cached=%s", safeA, safeB, tostring(safezone.cached)),
        string.format("Route=%s -> %s | Complete=%s | Stuck=%s | EdgeRisk=%s", tostring(runtime.routeStartSide or "none"), tostring(runtime.routeTargetSide or "none"), tostring(runtime.routeComplete), tostring(runtime.stuck), tostring(runtime.edgeRisk)),
        string.format("Assist=%s | Revive=%s | Gem=%s | SideGap=%s", tostring(runtime.assistMode or "none"), runtime.reviveStarted and "started" or "idle", runtime.gemTarget and runtime.gemTarget.Parent and runtime.gemTarget.Name or "none", runtime.sideGapReason ~= "" and runtime.sideGapReason or "none"),
        string.format("Threats=%d | Threat0=%s", #runtime.threats, threat and string.format("d=%.1f gap=%.1f t=%.2f risk=%s", threat.distance or -1, threat.interceptGap or -1, threat.interceptTime or -1, tostring(threat.collisionRisk)) or "none"),
        string.format("Dash=%s | DashCount=%s | Path=%.2f, %.2f", tostring(runtime.dashStatus), tostring(runtime.dashLastCount), path.X, path.Z),
        string.format("CatcherTarget=%s | Chase=%s | Tackle=%s | Melee=%s", runtime.catcherTarget and runtime.catcherTarget.Name or "none", tostring(SETTINGS.catcherChase), tostring(SETTINGS.autoTackle), tostring(SETTINGS.autoMelee)),
        string.format("Wheel=%s | Credits=%d | Spins=%d | Spinning=%s | StateAge=%.2fs", tostring(runtime.wheelStatus), math.floor(tonumber(runtime.wheelCredits) or 0), tonumber(runtime.wheelSpinCount) or 0, tostring(runtime.wheelSpinning), wheelStateAge),
        string.format("Journey=%s | Loaded=%s | Tier=%d | Claims=%d | StateAge=%.2fs", tostring(runtime.journeyStatus), tostring(runtime.journeyLoaded), tonumber(runtime.journeyTier) or 1, tonumber(runtime.journeyClaimCount) or 0, journeyAge),
        string.format("MapVote=%s | Phase=%s | Selected=%s | StateAge=%.2fs", tostring(runtime.mapVoteStatus), tostring(runtime.mapVotePhase), selectedMap, mapAge),
        string.format("AutoRun=%s | AutoSpin=%s | AutoClaim=%s | AutoVote=%s", tostring(SETTINGS.runnerEnabled), tostring(SETTINGS.autoSpinWheel), tostring(SETTINGS.autoClaimJourneyRewards), tostring(SETTINGS.autoMapVote)),
        string.format("Ping=%d ms | LastErrorAge=%.2fs | LastError=%s", math.floor((tonumber(runtime.ping) or 0) * 1000 + 0.5), errorAge, errorText),
    }, "\n")
end


local function readMapVoteState()
    if not MapVoteState or not MapVoteState:IsA("StringValue") then
        runtime.mapVoteOpen = false
        runtime.mapVotePhase = "Unavailable"
        return nil
    end

    local ok, state = pcall(function()
        return HttpService:JSONDecode(MapVoteState.Value)
    end)
    if not ok or type(state) ~= "table" then
        runtime.mapVoteOpen = false
        runtime.mapVotePhase = "Waiting"
        return nil
    end

    local options = type(state.options) == "table" and state.options or {}
    local ids = {}
    for index = 1, math.min(#options, #MAP_VOTE_SLOT_IDS) do
        local option = options[index]
        if type(option) == "table" then
            ids[index] = option.id or option.Id or option.key or option.Key
        end
    end

    runtime.mapVoteOptionIds = ids
    runtime.mapVoteToken = state.token
    runtime.mapVotePhase = tostring(state.phase or "Waiting")
    runtime.mapVoteOpen = runtime.mapVotePhase == "Voting"
    runtime.mapVoteLastStateAt = os.clock()
    return state
end

local function mapVoteOnce(manual)
    if not SETTINGS.autoMapVote and not manual then
        runtime.mapVoteStatus = "disabled"
        return false
    end

    if LocalPlayer:GetAttribute("InMatch") == true then
        runtime.mapVoteStatus = "waiting for lobby"
        return false
    end

    if LocalPlayer:GetAttribute("ClientReady") ~= true then
        runtime.mapVoteStatus = "waiting for client"
        return false
    end

    if LocalPlayer:GetAttribute("AFK") == true then
        runtime.mapVoteStatus = "waiting - AFK"
        return false
    end

    if Session:GetAttribute("GlobalPaused") == true then
        runtime.mapVoteStatus = "paused"
        return false
    end

    local state = readMapVoteState()
    if not state or runtime.mapVotePhase ~= "Voting" then
        runtime.mapVoteStatus = "waiting for vote"
        return false
    end

    local selected = getSelectedMapSlot()
    if not selected then
        runtime.mapVoteStatus = "choose Map 1, Map 2, or Map 3"
        return false
    end

    local index = table.find(MAP_VOTE_SLOT_IDS, selected)
    local optionId = index and runtime.mapVoteOptionIds[index]
    if optionId == nil then
        runtime.mapVoteStatus = selected .. " is unavailable"
        return false
    end

    local token = runtime.mapVoteToken
    if token == nil then
        runtime.mapVoteStatus = "vote token unavailable"
        return false
    end

    local votes = type(state.votes) == "table" and state.votes or nil
    local currentVote = votes and (votes[tostring(LocalPlayer.UserId)] or votes[LocalPlayer.UserId]) or nil
    if currentVote == optionId then
        runtime.mapVoteStatus = selected .. " already selected"
        return true
    end

    local now = os.clock()
    if now - runtime.mapVoteLastActionAt < 0.75 then
        return false
    end

    local fired = pcall(function()
        MapVoteEvent:FireServer("Vote", optionId, token)
    end)

    if not fired then
        runtime.mapVoteStatus = "vote request failed"
        return false
    end

    runtime.mapVoteLastActionAt = now
    runtime.mapVoteStatus = selected .. " vote sent"
    if SETTINGS.mapVoteAnnounce then
        pcall(function()
            WindUI:Notify({
                Title = "Map Vote",
                Content = selected .. " selected.",
                Duration = 2.5,
                Icon = "map",
            })
        end)
    end
    return true
end

local function wheelServerNow()
    local ok, value = pcall(function()
        return workspace:GetServerTimeNow()
    end)
    if ok and type(value) == "number" then
        return value
    end
    return os.time()
end

local function wheelCooldownRemaining()
    local nextFreeAt = tonumber(runtime.wheelNextFreeAt) or 0
    if nextFreeAt <= 0 then
        return 0
    end
    if nextFreeAt < 100000000 then
        return math.max(0, nextFreeAt)
    end
    return math.max(0, nextFreeAt - wheelServerNow())
end

local function wheelUpdateStatus(status)
    runtime.wheelStatus = tostring(status or runtime.wheelStatus or "waiting")
    runtime.wheelStatusAt = os.clock()
end

local function wheelRequestState(now, force)
    if not force and now - runtime.wheelStateRequestAt < 1.25 then
        return false
    end

    runtime.wheelStateRequestAt = now
    local ok = pcall(function()
        SpinWheelEvent:FireServer("State")
    end)
    runtime.wheelEventReady = ok

    if ok then
        return true
    end

    wheelUpdateStatus("state request failed")
    return false
end

local function wheelApplyState(payload)
    if type(payload) ~= "table" then
        return
    end
    runtime.wheelCredits = tonumber(payload.credits) or 0
    runtime.wheelNextFreeAt = tonumber(payload.nextFreeAt) or 0
    runtime.wheelPurchasesAvailable = payload.purchasesAvailable == true
    runtime.wheelDiscountAvailable = payload.discountAvailable == true
end

local function wheelCanSpinNow(manual)
    if not SETTINGS.autoSpinWheel and not manual then
        return false, "disabled"
    end

    if LocalPlayer:GetAttribute("InMatch") == true then
        return false, "cannot spin in match"
    end

    if runtime.wheelSpinning then
        return false, "spinning"
    end

    local now = os.clock()
    local nextAttempt = tonumber(runtime.wheelNextAttemptAt) or -math.huge
    if now < nextAttempt then
        return false, string.format("cooldown %.1fs", nextAttempt - now)
    end

    local minimum = math.max(1, math.floor(tonumber(SETTINGS.wheelMinimumCredits) or 1))
    local credits = math.floor(tonumber(runtime.wheelCredits) or 0)
    if credits < minimum then
        return false, string.format("not enough credits (%d/%d)", credits, minimum)
    end

    return true, "ready"
end

local function wheelNotify(title, content, icon)
    if not SETTINGS.wheelAnnounce then
        return
    end
    pcall(function()
        WindUI:Notify({
            Title = title,
            Content = content,
            Duration = 2.5,
            Icon = icon or "circle-dot",
        })
    end)
end

local function wheelSpinOnce(manual)
    local allowed, reason = wheelCanSpinNow(manual)
    if not allowed then
        wheelUpdateStatus(reason)
        return false
    end

    local now = os.clock()
    local delay = math.clamp(tonumber(SETTINGS.wheelSpinInterval) or 6, 5.5, 30)
    runtime.wheelSpinning = true
    runtime.wheelSpinRequestAt = now
    runtime.wheelNextAttemptAt = now + delay
    runtime.wheelActionAt = now
    runtime.wheelSpinCount += 1
    wheelUpdateStatus("spin requested")

    local fired = pcall(function()
        SpinWheelEvent:FireServer("Spin")
    end)

    if not fired then
        runtime.wheelSpinning = false
        runtime.wheelNextAttemptAt = now + 1
        wheelUpdateStatus("spin request failed")
        return false
    end

    if manual then
        wheelNotify("Wheel", "Spin request sent.", "zap")
    else
        wheelNotify("Auto Spin", string.format("Spin #%d fired.", runtime.wheelSpinCount), "circle-dot")
    end

    task.delay(0.85, function()
        runtime.wheelSpinning = false
        wheelRequestState(os.clock(), true)
    end)

    return true
end

local function autoSpinWheelStep(now)
    if not SETTINGS.autoSpinWheel then
        wheelUpdateStatus("disabled")
        return
    end

    wheelRequestState(now, false)

    local allowed, reason = wheelCanSpinNow(false)
    if allowed then
        wheelSpinOnce(false)
        return
    end

    wheelUpdateStatus(reason)
end

local function utilityStep(now)
    if now - runtime.utilityTick < 0.25 then
        return
    end
    runtime.utilityTick = now
    if SETTINGS.autoSpinWheel then
        autoSpinWheelStep(now)
    end
    if SETTINGS.showThreats or SETTINGS.showThreatUtility then
        if isRunnerActive() then
            local root = getRoot()
            local threats = root and updateThreats(now, root.Position) or {}
            for i = 1, math.min(#threats, 8) do
                local threat = threats[i]
                local part = ensurePart(visuals.threats, i, threat.danger * 2, Color3.fromRGB(255, 90, 90), 0.82)
                part.CFrame = CFrame.new(threat.position)
            end
            for i = #threats + 1, #visuals.threats do
                local part = visuals.threats[i]
                if part and part.Parent then
                    part:Destroy()
                end
                visuals.threats[i] = nil
            end
        end
    else
        for i, part in pairs(visuals.threats) do
            if part.Parent then
                part:Destroy()
            end
            visuals.threats[i] = nil
        end
    end

    local goalEnabled = SETTINGS.showGoal and SETTINGS.showGoalUtility
    if goalEnabled and runtime.goal then
        local part = visuals.goal
        if not part or not part.Parent then
            part = Instance.new("Part")
            part.Name = "CoH_Goal"
            part.Shape = Enum.PartType.Ball
            part.Size = Vector3.new(2.5, 2.5, 2.5)
            part.Anchored = true
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.CastShadow = false
            part.Material = Enum.Material.ForceField
            part.Color = Color3.fromRGB(80, 200, 255)
            part.Transparency = 0.45
            part.Parent = workspace
            visuals.goal = part
        end
        part.CFrame = CFrame.new(runtime.goal)
    elseif visuals.goal then
        if visuals.goal.Parent then
            visuals.goal:Destroy()
        end
        visuals.goal = nil
    end

    if SETTINGS.showHitboxes then
        local role = getRole()
        local seen = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Parent then
                local targetRole = player:GetAttribute("GameRole")
                local relevant = (role == "Runner" and targetRole == "Catcher") or (role == "Catcher" and targetRole == "Runner")
                local root = relevant and getRoot(player) or nil
                if root then
                    seen[player] = true
                    local part = visuals.hitboxes[player]
                    if not part or not part.Parent then
                        part = Instance.new("Part")
                        part.Name = "CoH_Hitbox"
                        part.Shape = Enum.PartType.Ball
                        part.Anchored = true
                        part.CanCollide = false
                        part.CanTouch = false
                        part.CanQuery = false
                        part.CastShadow = false
                        part.Material = Enum.Material.ForceField
                        part.Color = Color3.fromRGB(255, 180, 80)
                        part.Transparency = 0.75
                        part.Parent = workspace
                        visuals.hitboxes[player] = part
                    end
                    local radius = ContactCatchConfig.RunnerRadius * 2
                    part.Size = Vector3.new(radius, radius, radius)
                    part.CFrame = CFrame.new(root.Position)
                end
            end
        end
        for player, part in pairs(visuals.hitboxes) do
            if not seen[player] then
                if part.Parent then
                    part:Destroy()
                end
                visuals.hitboxes[player] = nil
            end
        end
    else
        for player, part in pairs(visuals.hitboxes) do
            if part.Parent then
                part:Destroy()
            end
            visuals.hitboxes[player] = nil
        end
    end
end

ArmoryEvent.OnClientEvent:Connect(function(kind, state)
    if kind == "State" and type(state) == "table" then
        runtime.armory = state
        runtime.armory.abilities = runtime.armory.abilities or {}
    end
end)

RescueEvent.OnClientEvent:Connect(function(kind, id)
    if kind == "Cancelled" and runtime.reviveTarget and runtime.reviveTarget.UserId == id then
        runtime.reviveStarted = false
        runtime.reviveStartAt = 0
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    runtime.profile = nil
    runtime.profileRole = nil
    runtime.lastMovePosition = nil
    runtime.moveCommandAt = -math.huge
    runtime.goal = nil
    runtime.goalMode = "SafeZone"
    runtime.goalSide = nil
    runtime.routeActive = false
    runtime.routeComplete = false
    runtime.routeStartSide = nil
    runtime.routeTargetSide = nil
    runtime.routeCompletePosition = nil
    runtime.routeCompleteAt = -math.huge
    runtime.gemTarget = nil
    runtime.reviveTarget = nil
    runtime.reviveStarted = false
    runtime.reviveStartAt = 0
    runtime.threatHistory = {}
    runtime.threats = {}
    runtime.catchers = {}
    runtime.catcherTargets = {}
    runtime.dashAt = -math.huge
    runtime.dashStatus = "idle"
    runtime.dashLastRequestAt = -math.huge
    runtime.dashLastCount = nil
    runtime.edgeRecoveryDirection = Vector3.zero
    runtime.edgeRecoveryUntil = -math.huge
    runtime.stuckRecoveryDirection = Vector3.zero
    runtime.stuckRecoveryUntil = -math.huge
    runtime.armoryAt = -math.huge
    runtime.armory = {loaded = false, abilities = {}}
    runtime.wheelScanAt = -math.huge
    runtime.wheelActionAt = -math.huge
    runtime.wheelStatus = SETTINGS.autoSpinWheel and "starting" or "disabled"
    runtime.wheelLastButton = nil
    runtime.wheelCredits = 0
    runtime.wheelNextFreeAt = 0
    runtime.wheelPurchasesAvailable = false
    runtime.wheelDiscountAvailable = false
    runtime.wheelStateRequestAt = -math.huge
    runtime.wheelSpinRequestAt = -math.huge
    runtime.wheelNextAttemptAt = -math.huge
    runtime.wheelEventReady = false
    runtime.wheelSpinning = false
    runtime.wheelLastStateAt = -math.huge
    runtime.wheelStatusAt = -math.huge
    runtime.wheelMinimumCredits = 1
end)

do
    local handle = Game:FindFirstChild("ActiveMap")
    if handle and handle:IsA("ObjectValue") then
        handle.Changed:Connect(function()
            safezone.cached = false
            safezone.map = nil
            runtime.mapCache = nil
            runtime.mapCacheAt = -math.huge
            runtime.safeCheckAt = -math.huge
            runtime.safeCheckPosition = nil
            edgeRayCache.map = nil
            edgeRayCache.params = nil
            runtime.goal = nil
            runtime.goalSide = nil
            runtime.routeActive = false
            runtime.routeComplete = false
            runtime.routeStartSide = nil
            runtime.routeTargetSide = nil
            runtime.routeCompletePosition = nil
            runtime.routeCompleteAt = -math.huge
        end)
    end
end

pcall(function()
    ArmoryEvent:FireServer("Get")
end)

task.spawn(function()
    pcall(function()
        local GemEvent = COH:WaitForChild("Collectibles"):WaitForChild("GemEvent")
        GemEvent:FireServer("Sync")
    end)
end)

SpinWheelEvent.OnClientEvent:Connect(function(kind, payload)
    if kind == "State" and type(payload) == "table" then
        wheelApplyState(payload)
        runtime.wheelLastStateAt = os.clock()
        if payload.result or payload.message then
            runtime.wheelSpinning = false
        end
        if SETTINGS.autoSpinWheel then
            local credits = tonumber(runtime.wheelCredits) or 0
            local minimum = math.max(1, math.floor(tonumber(SETTINGS.wheelMinimumCredits) or 1))
            if credits >= minimum then
                wheelUpdateStatus("ready")
            else
                wheelUpdateStatus(string.format("waiting - credits %d/%d", math.floor(credits), minimum))
            end
            task.defer(function()
                if SETTINGS.autoSpinWheel and LocalPlayer:GetAttribute("InMatch") ~= true then
                    autoSpinWheelStep(os.clock())
                end
            end)
        end
        return
    end

    if kind == "PromptProduct" then
        runtime.wheelPurchasesAvailable = true
        wheelUpdateStatus("free credits unavailable")
        return
    end

    if type(kind) == "table" and payload == nil then
        wheelApplyState(kind)
        if SETTINGS.autoSpinWheel then
            wheelUpdateStatus("state refreshed")
            task.defer(function()
                autoSpinWheelStep(os.clock())
            end)
        end
    end
end)

local function isLobbyForAFKOverride()
    return SETTINGS.disableBuiltinAFK and LocalPlayer:GetAttribute("InMatch") ~= true
end

local function forceBuiltinAFKOff(reason)
    if not isLobbyForAFKOverride() then
        runtime.afkOverrideInLobby = false
        if not SETTINGS.disableBuiltinAFK then
            runtime.afkOverrideStatus = "disabled"
        end
        return false
    end

    runtime.afkOverrideInLobby = true

    local now = os.clock()
    if reason ~= "attribute" and now - runtime.afkOverrideLastRequestAt < runtime.afkOverrideRequestInterval then
        return false
    end

    local ok, err = pcall(function()
        PlayerPreferences:FireServer("SetAFK", false)
    end)

    runtime.afkOverrideLastRequestAt = now

    if ok then
        runtime.afkOverrideRequestCount = (runtime.afkOverrideRequestCount or 0) + 1
        runtime.afkOverrideStatus = "AFK OFF"
        return true
    end

    runtime.afkOverrideStatus = "request failed"
    return false
end

LocalPlayer:GetAttributeChangedSignal("AFK"):Connect(function()
    if not SETTINGS.disableBuiltinAFK then
        runtime.afkOverrideStatus = "disabled"
        return
    end

    if LocalPlayer:GetAttribute("InMatch") == true then
        runtime.afkOverrideInLobby = false
        runtime.afkOverrideStatus = "in match"
        return
    end

    if LocalPlayer:GetAttribute("AFK") == true then
        forceBuiltinAFKOff("attribute")
    else
        runtime.afkOverrideStatus = "AFK OFF confirmed"
    end
end)

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(function()
    if not SETTINGS.disableBuiltinAFK then
        return
    end

    if LocalPlayer:GetAttribute("InMatch") == true then
        runtime.afkOverrideInLobby = false
        runtime.afkOverrideStatus = "in match"
    else
        runtime.afkOverrideInLobby = true
        runtime.afkOverrideLastRequestAt = -math.huge
        forceBuiltinAFKOff("lobby")
    end
end)

task.spawn(function()
    while LocalPlayer.Parent do
        task.wait(0.5)
        if SETTINGS.disableBuiltinAFK then
            if LocalPlayer:GetAttribute("InMatch") == true then
                runtime.afkOverrideInLobby = false
                runtime.afkOverrideStatus = "in match"
            else
                runtime.afkOverrideInLobby = true
                forceBuiltinAFKOff("poll")
            end
        end
    end
end)

WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Huss Valley",
    Icon = "bird",
    Author = "https://rscripts.net/@_LSS",
    Folder = "HussValley",
    Size = UDim2.fromOffset(520, 860),
    Transparent = true,
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,
})

Window:Tag({Title = "Huss Valley", Color = Color3.fromRGB(110, 190, 255)})

-- Notification gate (controlled from Settings tab)
SETTINGS.notifications = true
Hub.rawNotify = WindUI.Notify
WindUI.Notify = function(self, opts)
    if SETTINGS.notifications == false then
        return
    end
    return Hub.rawNotify(self, opts)
end

-- Element registry: every Toggle/Slider/Dropdown/... is recorded so the Settings tab
-- can save/load configs and reset everything to defaults.
function Hub.register(key, element, default)
    if element ~= nil then
        table.insert(Hub.registry, {key = key, element = element, default = default})
    end
end

function Hub.trackTab(tab, tabName)
    local TRACKED_KINDS = {"Toggle", "Slider", "Dropdown", "Input", "Keybind", "Colorpicker"}
    local used = {}
    for _, kind in ipairs(TRACKED_KINDS) do
        local original = tab[kind]
        if type(original) == "function" then
            tab[kind] = function(self, cfg)
                local element = original(self, cfg)
                if type(cfg) == "table" and type(cfg.Title) == "string" and element ~= nil then
                    local base = tabName .. "_" .. cfg.Title
                    local key, n = base, 1
                    while used[key] do
                        n = n + 1
                        key = base .. "_" .. n
                    end
                    used[key] = true
                    local default = cfg.Value
                    if kind == "Slider" then
                        default = type(default) == "table" and default.Default or nil
                    elseif kind == "Colorpicker" then
                        default = cfg.Default
                    end
                    Hub.register(key, element, default)
                end
                return element
            end
        end
    end
    return tab
end

Hub.rawTab = Window.Tab
Window.Tab = function(self, cfg)
    local tab = Hub.rawTab(self, cfg)
    return Hub.trackTab(tab, type(cfg) == "table" and cfg.Title or "Tab")
end

local RunnerTab = Window:Tab({Title = "Runner", Icon = "footprints"})

local RunnerStatusParagraph = RunnerTab:Paragraph({
    Title = "Runner Status",
    Desc = "Role: Lobby\nState: Idle\nGoal: None",
})

RunnerTab:Section({Title = "Movement"})

RunnerTab:Toggle({
    Title = "Auto Run",
    Desc = "Automatically travel between Safe Zones with threat and edge checks.",
    Icon = "play",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.runnerEnabled = v == true
        if not SETTINGS.runnerEnabled then
            runtime.path = Vector3.zero
            runtime.goal = nil
            runtime.assistMode = nil
            runtime.assistTarget = nil
            runtime.sideGapDirection = Vector3.zero
            runtime.sideGapUntil = -math.huge
            cancelRevive()
        end
    end,
})

RunnerTab:Toggle({
    Title = "Auto Revive Players",
    Desc = "Move to a downed Runner and complete the real revive hold before continuing.",
    Icon = "heart-pulse",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoRevive = v == true
        if not v then
            cancelRevive()
        end
    end,
})

RunnerTab:Toggle({
    Title = "Runner Speed Override",
    Desc = "Multiply the game's current Runner movement speed without replacing its acceleration or dash system.",
    Icon = "gauge",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.customSpeed = v == true
        if not SETTINGS.customSpeed then
            restoreNativeWalkSpeed()
        end
    end,
})

RunnerTab:Slider({
    Title = "Runner Speed Multiplier",
    Desc = "1.0x keeps the native speed; maximum is 2.0x.",
    Step = 0.05,
    Value = {Min = 1.0, Max = 2.0, Default = 1.0},
    Callback = function(v)
        SETTINGS.speedMultiplier = math.clamp(tonumber(v) or 1, 1, 2)
    end,
})

RunnerTab:Section({Title = "Collection and Safety"})

RunnerTab:Toggle({
    Title = "Revive Before Gems",
    Desc = "Prioritize downed players before collecting Gems.",
    Icon = "list-checks",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.reviveBeforeGems = v == true
    end,
})

RunnerTab:Toggle({
    Title = "Auto Collect Gems",
    Desc = "Collect visible Runner Gems, then return to the Safe Zone route when none remain.",
    Icon = "gem",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoGems = v == true
        if not v then
            runtime.gemTarget = nil
        end
    end,
})

RunnerTab:Toggle({
    Title = "Avoid Catchers",
    Desc = "Predict nearby Catchers and bend the route away from their projected path.",
    Icon = "shield",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.avoidCatchers = v == true
    end,
})

RunnerTab:Toggle({
    Title = "Auto Dash",
    Desc = "Use the equipped Runner ability before a Catcher reaches the predicted collision area.",
    Icon = "zap",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoDash = v == true
    end,
})

RunnerTab:Slider({
    Title = "Runner Threat Prediction",
    Desc = "How far ahead Catcher movement is predicted for Runner avoidance.",
    Step = 0.05,
    Value = {Min = 0.25, Max = 1.1, Default = 0.65},
    Callback = function(v)
        SETTINGS.predictionTime = math.clamp(tonumber(v) or 0.65, 0.25, 1.1)
    end,
})

RunnerTab:Slider({
    Title = "Emergency Threat Distance",
    Desc = "Distance at which emergency avoidance becomes more aggressive.",
    Step = 1,
    Value = {Min = 8, Max = 25, Default = 15},
    Callback = function(v)
        SETTINGS.panicDistance = math.clamp(tonumber(v) or 15, 8, 25)
    end,
})

RunnerTab:Section({Title = "Movement"})

RunnerTab:Toggle({
    Title = "Smooth Direction Changes",
    Desc = "Blend turns to reduce sudden movement changes.",
    Icon = "rotate-cw",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.smoothMovement = v == true
    end,
})

RunnerTab:Toggle({
    Title = "Emergency Safe Zone",
    Desc = "When movement stalls under heavy pressure, temporarily favor the nearest Safe Zone.",
    Icon = "life-buoy",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.emergencySafeZone = v == true
    end,
})

RunnerTab:Slider({
    Title = "Avoidance Strength",
    Desc = "How strongly the route moves away from projected Catcher paths.",
    Step = 0.1,
    Value = {Min = 0.5, Max = 2.5, Default = 1.8},
    Callback = function(v)
        SETTINGS.avoidStrength = math.clamp(tonumber(v) or 1.8, 0.5, 2.5)
    end,
})

local CatcherTab = Window:Tab({Title = "Catcher", Icon = "crosshair"})

local CatcherStatusParagraph = CatcherTab:Paragraph({
    Title = "Catcher Status",
    Desc = "Role: Lobby\nState: Idle\nTarget: None",
})

CatcherTab:Section({Title = "Targeting and Combat"})

CatcherTab:Toggle({
    Title = "Auto Chase",
    Desc = "Automatically move toward the best active Runner.",
    Icon = "move",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.catcherChase = v == true
        if not SETTINGS.catcherChase then
            runtime.catcherTarget = nil
            runtime.catcherPath = Vector3.zero
        end
    end,
})

CatcherTab:Dropdown({
    Title = "Attack Priority",
    Desc = "Choose whether Smart, Tackle, or Melee is preferred when attacking.",
    Values = {"Smart", "Tackle First", "Melee First"},
    Value = "Smart",
    Multi = false,
    Callback = function(v)
        if type(v) == "table" then
            v = v[1]
        end
        if v == "Smart" or v == "Tackle First" or v == "Melee First" then
            SETTINGS.catcherAttackPriority = v
        end
    end,
})

CatcherTab:Toggle({
    Title = "Smart Targeting",
    Desc = "Prefer active targets that can be intercepted instead of simply choosing the nearest Runner.",
    Icon = "brain",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.smartPriority = v == true
    end,
})

CatcherTab:Toggle({
    Title = "Auto Tackle",
    Desc = "Automatically tackle a Runner when the predicted position enters tackle range.",
    Icon = "zap",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoTackle = v == true
        if not SETTINGS.autoTackle then
            runtime.lastTackle = -math.huge
        end
    end,
})

CatcherTab:Slider({
    Title = "Tackle Range",
    Desc = "Distance used before an automatic tackle is attempted.",
    Step = 0.5,
    Value = {Min = 5, Max = 25, Default = 12},
    Callback = function(v)
        SETTINGS.tackleRange = math.clamp(tonumber(v) or 12, 5, 25)
    end,
})

CatcherTab:Toggle({
    Title = "Auto Melee",
    Desc = "Automatically melee a Runner when the predicted position enters melee range.",
    Icon = "sword",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoMelee = v == true
        if not SETTINGS.autoMelee then
            runtime.lastMelee = -math.huge
        end
    end,
})

CatcherTab:Slider({
    Title = "Melee Range",
    Desc = "Distance used before an automatic melee attack is attempted.",
    Step = 0.5,
    Value = {Min = 3, Max = 15, Default = 9},
    Callback = function(v)
        SETTINGS.meleeRange = math.clamp(tonumber(v) or 9, 3, 15)
    end,
})

CatcherTab:Slider({
    Title = "Target Prediction",
    Desc = "How far ahead the Catcher predicts the selected Runner.",
    Step = 0.05,
    Value = {Min = 0.1, Max = 1.0, Default = 0.45},
    Callback = function(v)
        SETTINGS.catcherPrediction = math.clamp(tonumber(v) or 0.45, 0.1, 1.0)
    end,
})

CatcherTab:Section({Title = "Movement"})

CatcherTab:Toggle({
    Title = "Catcher Speed Override",
    Desc = "Multiply the game's current Catcher movement speed without replacing its acceleration or dash system.",
    Icon = "gauge",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.catcherCustomSpeed = v == true
        if not SETTINGS.catcherCustomSpeed then
            restoreNativeWalkSpeed()
        end
    end,
})

CatcherTab:Slider({
    Title = "Catcher Speed Multiplier",
    Desc = "1.0x keeps the native speed; maximum is 2.0x.",
    Step = 0.05,
    Value = {Min = 1.0, Max = 2.0, Default = 1.0},
    Callback = function(v)
        SETTINGS.catcherSpeedMultiplier = math.clamp(tonumber(v) or 1, 1, 2)
    end,
})

CatcherTab:Toggle({
    Title = "Smooth Turning",
    Desc = "Rotate toward the predicted Runner position without snapping.",
    Icon = "rotate-cw",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.smoothTurn = v == true
    end,
})

CatcherTab:Slider({
    Title = "Turn Response",
    Desc = "How quickly the Catcher turns toward the predicted target.",
    Step = 1,
    Value = {Min = 5, Max = 30, Default = 14},
    Callback = function(v)
        SETTINGS.turnRateCatcher = math.clamp(tonumber(v) or 14, 5, 30)
    end,
})

local WheelTab = Window:Tab({Title = "Wheel", Icon = "rotate-cw"})

WheelTab:Section({Title = "Status"})

local WheelStatusParagraph = WheelTab:Paragraph({
    Title = "Wheel Ready",
    Desc = "Credits: 0 | Spins: 0\nFree spin: Ready | Match: No | Spinning: No",
})

local function updateWheelStatusUI()
    local credits = math.floor(tonumber(runtime.wheelCredits) or 0)
    local minimum = math.max(1, math.floor(tonumber(SETTINGS.wheelMinimumCredits) or 1))
    local free = wheelCooldownRemaining()
    local freeText = free > 0 and string.format("%d:%02d", math.floor(free / 60), math.floor(free % 60)) or "ready"
    local stateAge = runtime.wheelLastStateAt > 0 and math.max(0, os.clock() - runtime.wheelLastStateAt) or math.huge
    local stateText = stateAge < math.huge and string.format("%.1fs ago", stateAge) or "not received"
    local title = string.format("%s | Credits %d/%d", tostring(runtime.wheelStatus or "waiting"), credits, minimum)
    local desc = string.format(
        "Spins: %d | Free spin: %s\nMatch: %s | Spinning: %s | State: %s",
        tonumber(runtime.wheelSpinCount) or 0,
        freeText,
        LocalPlayer:GetAttribute("InMatch") == true and "Yes" or "No",
        runtime.wheelSpinning and "Yes" or "No",
        stateText
    )
    pcall(function()
        WheelStatusParagraph:SetTitle(title)
        WheelStatusParagraph:SetDesc(desc)
    end)
end

WheelTab:Section({Title = "Automatic Spin"})

WheelTab:Toggle({
    Title = "Enable Auto Spin",
    Desc = "Automatically spin when you have enough credits and are in the lobby.",
    Icon = "play",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoSpinWheel = v == true
        runtime.wheelSpinning = false
        runtime.wheelSpinRequestAt = -math.huge
        runtime.wheelNextAttemptAt = -math.huge
        if SETTINGS.autoSpinWheel then
            runtime.wheelStatus = "refreshing state"
            wheelRequestState(os.clock(), true)
            pcall(function()
                WindUI:Notify({Title = "Auto Spin", Content = "Started.", Duration = 2, Icon = "check"})
            end)
        else
            runtime.wheelStatus = "disabled"
            pcall(function()
                WindUI:Notify({Title = "Auto Spin", Content = "Stopped.", Duration = 2, Icon = "pause"})
            end)
        end
        updateWheelStatusUI()
    end,
})

WheelTab:Slider({
    Title = "Delay Between Spins",
    Desc = "Seconds to wait between automatic spin requests.",
    Step = 0.5,
    Value = {Min = 5.5, Max = 30, Default = 6},
    Callback = function(v)
        SETTINGS.wheelSpinInterval = math.clamp(tonumber(v) or 6, 5.5, 30)
        updateWheelStatusUI()
    end,
})

WheelTab:Slider({
    Title = "Minimum Credits",
    Desc = "Do not spin unless the wheel has at least this many credits.",
    Step = 1,
    Value = {Min = 1, Max = 50, Default = 1},
    Callback = function(v)
        SETTINGS.wheelMinimumCredits = math.max(1, math.floor(tonumber(v) or 1))
        runtime.wheelMinimumCredits = SETTINGS.wheelMinimumCredits
        updateWheelStatusUI()
    end,
})

WheelTab:Toggle({
    Title = "Spin Notifications",
    Desc = "Show a notification when an automatic spin is sent.",
    Icon = "bell",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.wheelAnnounce = v == true
    end,
})

WheelTab:Divider()
WheelTab:Section({Title = "Manual Controls"})

WheelTab:Button({
    Title = "Spin Once Now",
    Desc = "Send one normal Spin request when the wheel is available.",
    Icon = "zap",
    Callback = function()
        task.spawn(function()
            wheelRequestState(os.clock(), true)
            task.wait(0.1)
            wheelSpinOnce(true)
            updateWheelStatusUI()
        end)
    end,
})

WheelTab:Button({
    Title = "Refresh Wheel State",
    Desc = "Request the latest credits and free-spin timer from the game.",
    Icon = "refresh-cw",
    Callback = function()
        wheelRequestState(os.clock(), true)
        task.delay(0.2, updateWheelStatusUI)
    end,
})

task.spawn(function()
    while WheelStatusParagraph and WheelStatusParagraph.Parent do
        task.wait(0.5)
        if SETTINGS.autoSpinWheel then
            local allowed, reason = wheelCanSpinNow(false)
            if runtime.wheelSpinning then
                runtime.wheelStatus = "spinning"
            elseif allowed then
                runtime.wheelStatus = "ready"
            else
                runtime.wheelStatus = reason
            end
        end
        updateWheelStatusUI()
    end
end)

local JourneyTab = Window:Tab({Title = "Journey", Icon = "gift"})
JourneyTab:Section({Title = "Rewards"})

local JourneyStatusParagraph = JourneyTab:Paragraph({
    Title = "Journey Status",
    Desc = "State: Loading\nAvailable rewards: 0",
})

JourneyTab:Toggle({
    Title = "Auto Claim Rewards",
    Desc = "Automatically claim all unlocked Journey rewards while you are in the lobby.",
    Icon = "gift",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoClaimJourneyRewards = v == true
        runtime.journeyClaimInFlight = false
        runtime.journeyNextClaimAt = -math.huge
        if SETTINGS.autoClaimJourneyRewards then
            runtime.journeyStatus = "checking rewards"
            requestJourneyState(true)
        else
            runtime.journeyManualPending = false
            runtime.journeyStatus = "disabled"
        end
    end,
})

JourneyTab:Toggle({
    Title = "Announce Claims",
    Desc = "Show a notification after Journey rewards are claimed.",
    Icon = "bell",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.journeyClaimAnnounce = v == true
    end,
})

JourneyTab:Button({
    Title = "Claim Rewards Now",
    Desc = "Claim all currently unlocked rewards once for the current season.",
    Icon = "gift",
    Callback = function()
        journeyClaimOnce(true)
    end,
})

JourneyEvent.OnClientEvent:Connect(function(action, data)
    if action ~= "State" or type(data) ~= "table" then
        return
    end

    local seasonId = data.seasonId or JourneyConfig.SeasonId
    if JourneyConfig.SeasonId and seasonId ~= JourneyConfig.SeasonId then
        return
    end

    local wasClaiming = runtime.journeyClaimInFlight
    runtime.journeyLoaded = data.loaded == true
    runtime.journeySeasonId = seasonId
    runtime.journeyTier = tonumber(data.tier) or 1
    runtime.journeyPremium = data.premium == true
    runtime.journeyClaims = type(data.claims) == "table" and data.claims or {}
    runtime.journeyLastStateAt = os.clock()

    if wasClaiming then
        runtime.journeyClaimInFlight = false
        runtime.journeyClaimCount += 1
        runtime.journeyLastClaimResultAt = os.clock()
    end

    if data.message and tostring(data.message) ~= "" then
        runtime.journeyStatus = tostring(data.message)
    elseif runtime.journeyLoaded then
        local remaining = journeyClaimableCount()
        runtime.journeyStatus = remaining > 0 and string.format("%d reward%s available", remaining, remaining == 1 and "" or "s") or "ready"
    else
        runtime.journeyStatus = "loading journey state"
    end

    if (SETTINGS.autoClaimJourneyRewards or runtime.journeyManualPending) and runtime.journeyLoaded and LocalPlayer:GetAttribute("InMatch") ~= true and not runtime.journeyClaimInFlight then
        local remaining = journeyClaimableCount()
        if remaining > 0 or runtime.journeyManualPending then
            local manualPending = runtime.journeyManualPending == true
            task.delay(0.15, function()
                if (SETTINGS.autoClaimJourneyRewards or manualPending) and LocalPlayer:GetAttribute("InMatch") ~= true then
                    journeyClaimOnce(manualPending)
                end
            end)
        end
    end
end)

task.spawn(function()
    requestJourneyState(true)
    while task.wait(1.5) do
        if LocalPlayer:GetAttribute("InMatch") ~= true then
            requestJourneyState(false)
            if SETTINGS.autoClaimJourneyRewards and runtime.journeyLoaded and not runtime.journeyClaimInFlight then
                journeyClaimOnce(false)
            end
        end
    end
end)

local function updateRoleStatusUI()
    local role = getRole()
    local state = getRunState()
    local goal = runtime.goalMode or "None"
    local assist = runtime.assistMode or "None"
    local target = runtime.catcherTarget and runtime.catcherTarget.Name or "None"
    pcall(function()
        RunnerStatusParagraph:SetTitle("Runner: " .. tostring(role))
        RunnerStatusParagraph:SetDesc(string.format("State: %s\nGoal: %s | Assist: %s", tostring(state), tostring(goal), tostring(assist)))
        CatcherStatusParagraph:SetTitle("Catcher: " .. tostring(role))
        CatcherStatusParagraph:SetDesc(string.format("State: %s\nTarget: %s", tostring(state), tostring(target)))
    end)
end

task.spawn(function()
    while RunnerStatusParagraph and RunnerStatusParagraph.Parent do
        task.wait(0.35)
        updateRoleStatusUI()
    end
end)

local MapVoteTab = Window:Tab({Title = "Map Vote", Icon = "map"})

MapVoteTab:Section({Title = "Voting"})

local MapVoteStatusParagraph = MapVoteTab:Paragraph({
    Title = "Map Vote",
    Desc = "Phase: Waiting\nSelection: Map 1\nStatus: Ready",
})

MapVoteDropdown = MapVoteTab:Dropdown({
    Title = "Preferred Map",
    Desc = "Choose Map 1, Map 2, or Map 3.",
    Values = MAP_VOTE_SLOT_IDS,
    Value = MAP_VOTE_SLOT_IDS[1],
    Multi = false,
    AllowNone = false,
    SearchBarEnabled = false,
    Callback = function(value)
        local selected = value
        if type(value) == "table" then
            selected = value[1] or value.Title or value.Name or value.Value
        end
        selected = tostring(selected or "")
        if table.find(MAP_VOTE_SLOT_IDS, selected) then
            SETTINGS.mapVoteSelections = {selected}
            runtime.mapVoteStatus = selected .. " selected"
            if SETTINGS.autoMapVote then
                task.defer(function()
                    mapVoteOnce(false)
                end)
            end
        end
    end,
})

SETTINGS.mapVoteSelections = {MAP_VOTE_SLOT_IDS[1]}

local function updateMapVoteStatusUI()
    local selected = getSelectedMapSlot() or "None"
    local phase = runtime.mapVotePhase or "Waiting"
    local status = runtime.mapVoteStatus or "ready"
    pcall(function()
        MapVoteStatusParagraph:SetTitle("Map Vote: " .. phase)
        MapVoteStatusParagraph:SetDesc(string.format("Selection: %s\nStatus: %s", selected, status))
    end)
end

MapVoteTab:Toggle({
    Title = "Auto Vote",
    Desc = "Automatically send the selected Map 1, Map 2, or Map 3 vote when voting begins.",
    Icon = "check",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.autoMapVote = v == true
        runtime.mapVoteLastActionAt = -math.huge
        if SETTINGS.autoMapVote then
            runtime.mapVoteStatus = "starting"
            readMapVoteState()
            task.defer(function()
                mapVoteOnce(false)
            end)
        else
            runtime.mapVoteStatus = "disabled"
        end
        updateMapVoteStatusUI()
    end,
})

MapVoteTab:Toggle({
    Title = "Vote Notifications",
    Desc = "Show a notification after a vote is sent.",
    Icon = "bell",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.mapVoteAnnounce = v == true
    end,
})

MapVoteTab:Button({
    Title = "Vote Selected Map",
    Desc = "Send one vote immediately using the game's normal MapVoteEvent.",
    Icon = "check-check",
    Callback = function()
        mapVoteOnce(true)
        updateMapVoteStatusUI()
    end,
})

if MapVoteState and MapVoteState:IsA("StringValue") then
    MapVoteState.Changed:Connect(function()
        readMapVoteState()
        if SETTINGS.autoMapVote then
            task.defer(function()
                mapVoteOnce(false)
            end)
        end
        updateMapVoteStatusUI()
    end)
end

readMapVoteState()
updateMapVoteStatusUI()

task.spawn(function()
    while MapVoteStatusParagraph and MapVoteStatusParagraph.Parent do
        task.wait(0.5)
        readMapVoteState()
        if SETTINGS.autoMapVote then
            mapVoteOnce(false)
        end
        updateMapVoteStatusUI()
    end
end)

local UtilitiesTab = Window:Tab({Title = "Utilities", Icon = "wrench"})

UtilitiesTab:Section({Title = "Camera"})

UtilitiesTab:Toggle({
    Title = "Follow Target",
    Desc = "Smoothly point the camera toward the active Catcher target.",
    Icon = "camera",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.followTarget = v == true
        SETTINGS.cameraFollow = SETTINGS.followTarget
    end,
})

UtilitiesTab:Slider({
    Title = "Camera Follow Speed",
    Desc = "How quickly the camera follows the target.",
    Step = 0.05,
    Value = {Min = 0.05, Max = 1.0, Default = 0.25},
    Callback = function(v)
        SETTINGS.cameraResponse = v
    end,
})

UtilitiesTab:Section({Title = "Lobby"})

local AFKStatusParagraph = UtilitiesTab:Paragraph({
    Title = "Built-in AFK Status",
    Desc = "Game AFK: OFF\nLobby: No\nRemote Requests: 0",
})

UtilitiesTab:Toggle({
    Title = "Disable Anti AFK Flag",
    Desc = "Turns off the game's built-in AFK state while you are in the lobby and reapplies it if the game turns AFK back on.",
    Icon = "user-round-x",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.disableBuiltinAFK = v
        runtime.afkOverrideLastRequestAt = -math.huge

        if v then
            if LocalPlayer:GetAttribute("InMatch") == true then
                runtime.afkOverrideStatus = "in match"
                runtime.afkOverrideInLobby = false
            else
                runtime.afkOverrideStatus = "starting"
                forceBuiltinAFKOff("toggle")
            end
        else
            runtime.afkOverrideInLobby = false
            runtime.afkOverrideStatus = "disabled"
        end
    end,
})

task.spawn(function()
    while AFKStatusParagraph and AFKStatusParagraph.Parent do
        task.wait(0.5)
        pcall(function()
            local afk = LocalPlayer:GetAttribute("AFK") == true
            local remoteState = afk and "ON" or "OFF"
            local status = runtime.afkOverrideStatus or "disabled"
            AFKStatusParagraph:SetTitle(string.format("Game AFK: %s", remoteState))
            AFKStatusParagraph:SetDesc(string.format(
                "Override: %s\nLobby: %s\nRemote Requests: %d",
                status,
                runtime.afkOverrideInLobby and "Yes" or "No",
                tonumber(runtime.afkOverrideRequestCount) or 0
            ))
        end)
    end
end)

UtilitiesTab:Section({Title = "Debug"})

UtilitiesTab:Toggle({
    Title = "Full Debug Panel",
    Desc = "Show the detailed Runner, Catcher, Wheel, Journey, Map Vote, movement, and error panel.",
    Icon = "bug",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        runtime.debugEnabled = v == true
        SETTINGS.showDebugUI = runtime.debugEnabled
        if not runtime.debugEnabled and runtime.debugGui then
            runtime.debugGui.Enabled = false
        elseif runtime.debugEnabled then
            updateDebugPanel(os.clock())
        end
    end,
})

UtilitiesTab:Section({Title = "Visual Helpers"})

UtilitiesTab:Toggle({
    Title = "Show Goal",
    Desc = "Show the current Gem, revive target, or Safe Zone destination.",
    Icon = "target",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.showGoal = v == true
        SETTINGS.showGoalUtility = SETTINGS.showGoal
        if not SETTINGS.showGoal then
            if visuals.goal and visuals.goal.Parent then visuals.goal:Destroy() end
            visuals.goal = nil
        end
    end,
})

UtilitiesTab:Toggle({
    Title = "Show Threats",
    Desc = "Show the danger areas used by Runner prediction and avoidance.",
    Icon = "circle-alert",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.showThreats = v == true
        SETTINGS.showThreatUtility = SETTINGS.showThreats
        if not SETTINGS.showThreats then
            for key, part in pairs(visuals.threats) do
                if part.Parent then part:Destroy() end
                visuals.threats[key] = nil
            end
        end
    end,
})

UtilitiesTab:Toggle({
    Title = "Show Hitboxes",
    Desc = "Show simple visual spheres around players relevant to your current role.",
    Icon = "box",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        SETTINGS.showHitboxes = v == true
        if not SETTINGS.showHitboxes then
            for player, part in pairs(visuals.hitboxes) do
                if part.Parent then part:Destroy() end
                visuals.hitboxes[player] = nil
            end
        end
    end,
})

-- =====================================================================
-- Settings tab (always the last tab)
-- =====================================================================
do
    local SettingsTab = Hub.rawTab(Window, {Title = "Settings", Icon = "settings"})
    Hub.SettingsTab = SettingsTab

    local function toast(title, content, icon)
        pcall(function()
            Hub.rawNotify(WindUI, {Title = title, Content = content, Duration = 3, Icon = icon or "info"})
        end)
    end

    local hasFS = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"

    -- ---------------------------------------------------------------
    -- Interface
    -- ---------------------------------------------------------------
    SettingsTab:Section({Title = "Interface"})

    local themeNames = {}
    pcall(function()
        for name in pairs(WindUI:GetThemes()) do
            table.insert(themeNames, name)
        end
    end)
    table.sort(themeNames)
    if #themeNames == 0 then
        themeNames = {"Dark", "Light"}
    end

    local ThemeDropdown = SettingsTab:Dropdown({
        Title = "Theme",
        Desc = "Change the window colors.",
        Values = themeNames,
        Value = "Dark",
        Callback = function(v)
            pcall(function() WindUI:SetTheme(v) end)
        end,
    })
    Hub.register("Settings_Theme", ThemeDropdown, "Dark")

    local TransparencyToggle = SettingsTab:Toggle({
        Title = "Window Transparency",
        Desc = "Make the window background translucent.",
        Icon = "layers",
        Type = "Checkbox",
        Value = true,
        Callback = function(v)
            pcall(function() Window:ToggleTransparency(v == true) end)
        end,
    })
    Hub.register("Settings_Transparency", TransparencyToggle, true)

    local ScaleSlider = SettingsTab:Slider({
        Title = "UI Scale",
        Desc = "Resize the whole window (needs a WindUI version that supports scaling).",
        Step = 0.05,
        Value = {Min = 0.7, Max = 1.3, Default = 1.0},
        Callback = function(v)
            pcall(function() Window:SetUIScale(tonumber(v) or 1) end)
        end,
    })
    Hub.register("Settings_UIScale", ScaleSlider, 1.0)

    local toggleKeys = {"RightShift", "LeftAlt", "RightAlt", "RightControl", "Insert", "Home", "End", "Delete", "K", "F6", "F7", "F8"}
    local KeyDropdown = SettingsTab:Dropdown({
        Title = "Toggle UI Key",
        Desc = "Key used to show or hide this window.",
        Values = toggleKeys,
        Value = "RightShift",
        Callback = function(v)
            local key = typeof(v) == "EnumItem" and v or Enum.KeyCode[tostring(v)]
            if key then
                pcall(function() Window:SetToggleKey(key) end)
            end
        end,
    })
    Hub.register("Settings_ToggleKey", KeyDropdown, "RightShift")

    local NotifyToggle = SettingsTab:Toggle({
        Title = "Notifications",
        Desc = "Show pop-up notifications (Auto Spin, Wheel, loaded message...).",
        Icon = "bell",
        Type = "Checkbox",
        Value = true,
        Callback = function(v)
            SETTINGS.notifications = v == true
        end,
    })
    Hub.register("Settings_Notifications", NotifyToggle, true)

    -- ---------------------------------------------------------------
    -- Utility
    -- ---------------------------------------------------------------
    SettingsTab:Section({Title = "Utility"})

    local function setAntiIdle(on)
        if Hub.idleConn then
            Hub.idleConn:Disconnect()
            Hub.idleConn = nil
        end
        if on then
            Hub.idleConn = LocalPlayer.Idled:Connect(function()
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end)
        end
    end

    local AntiIdleToggle = SettingsTab:Toggle({
        Title = "Anti Idle Kick",
        Desc = "Prevent Roblox from kicking you after 20 minutes of inactivity.",
        Icon = "timer",
        Type = "Checkbox",
        Value = true,
        Callback = function(v)
            setAntiIdle(v == true)
        end,
    })
    Hub.register("Settings_AntiIdleKick", AntiIdleToggle, true)
    setAntiIdle(true)

    SettingsTab:Button({
        Title = "Rejoin Server",
        Desc = "Teleport back into this same place.",
        Icon = "refresh-cw",
        Callback = function()
            pcall(function()
                local ts = game:GetService("TeleportService")
                if #Players:GetPlayers() <= 1 then
                    ts:Teleport(game.PlaceId, LocalPlayer)
                else
                    ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end
            end)
        end,
    })

    -- ---------------------------------------------------------------
    -- Configuration
    -- ---------------------------------------------------------------
    SettingsTab:Section({Title = "Configuration"})

    local AUTOLOAD_FILE = "HussValley_autoload.txt"
    local selectedConfig = "default"
    local newConfigName = ""

    local function cleanName(name)
        name = tostring(name or ""):gsub("[^%w%-_ ]", "")
        name = name:gsub("^%s+", ""):gsub("%s+$", "")
        return name
    end

    local function listConfigs()
        local out = {}
        local cm = Window.ConfigManager
        if cm and cm.AllConfigs then
            local ok, res = pcall(function() return cm:AllConfigs() end)
            if ok and type(res) == "table" then
                for k, v in pairs(res) do
                    local n = type(v) == "string" and v or (type(k) == "string" and k or nil)
                    if n then
                        table.insert(out, (n:gsub("%.json$", "")))
                    end
                end
            end
        end
        table.sort(out)
        return out
    end

    local function buildConfig(name)
        local cm = Window.ConfigManager
        if not cm then
            toast("Config", "Config manager is not available in this WindUI version.", "triangle-alert")
            return nil
        end
        local ok, cfg = pcall(function() return cm:CreateConfig(name) end)
        if not ok or not cfg then
            toast("Config", "Could not create config '" .. name .. "'.", "triangle-alert")
            return nil
        end
        for _, entry in ipairs(Hub.registry) do
            pcall(function() cfg:Register(entry.key, entry.element) end)
        end
        return cfg
    end

    local initialConfigs = listConfigs()
    if #initialConfigs == 0 then
        initialConfigs = {"default"}
    end

    local ConfigDropdown
    local function refreshConfigs(select)
        local names = listConfigs()
        if #names == 0 then
            names = {"default"}
        end
        pcall(function() ConfigDropdown:Refresh(names) end)
        if select then
            selectedConfig = select
            pcall(function() ConfigDropdown:Select(select) end)
        end
    end

    ConfigDropdown = SettingsTab:Dropdown({
        Title = "Config",
        Desc = "Pick a saved config.",
        Values = initialConfigs,
        Value = initialConfigs[1],
        Callback = function(v)
            selectedConfig = cleanName(v)
        end,
    })
    selectedConfig = initialConfigs[1]

    SettingsTab:Input({
        Title = "New Config Name",
        Desc = "Type a name, then press Create & Save.",
        Placeholder = "my-config",
        Value = "",
        Callback = function(v)
            newConfigName = cleanName(v)
        end,
    })

    SettingsTab:Button({
        Title = "Create & Save",
        Desc = "Save all current settings under the new name.",
        Icon = "file-plus",
        Callback = function()
            if newConfigName == "" then
                toast("Config", "Enter a config name first.", "triangle-alert")
                return
            end
            local cfg = buildConfig(newConfigName)
            if cfg and pcall(function() cfg:Save() end) then
                toast("Config", "Saved '" .. newConfigName .. "'.", "check")
                refreshConfigs(newConfigName)
            end
        end,
    })

    SettingsTab:Button({
        Title = "Save Config",
        Desc = "Overwrite the selected config with the current settings.",
        Icon = "save",
        Callback = function()
            local name = cleanName(selectedConfig)
            if name == "" then
                return
            end
            local cfg = buildConfig(name)
            if cfg and pcall(function() cfg:Save() end) then
                toast("Config", "Saved '" .. name .. "'.", "check")
                refreshConfigs(name)
            end
        end,
    })

    SettingsTab:Button({
        Title = "Load Config",
        Desc = "Apply the selected config to every setting.",
        Icon = "folder-open",
        Callback = function()
            local name = cleanName(selectedConfig)
            if name == "" then
                return
            end
            local cfg = buildConfig(name)
            if cfg then
                if pcall(function() cfg:Load() end) then
                    toast("Config", "Loaded '" .. name .. "'.", "check")
                else
                    toast("Config", "Config '" .. name .. "' was not found.", "triangle-alert")
                end
            end
        end,
    })

    SettingsTab:Button({
        Title = "Delete Config",
        Desc = "Permanently delete the selected config.",
        Icon = "trash-2",
        Callback = function()
            local name = cleanName(selectedConfig)
            if name == "" then
                return
            end
            local cfg = buildConfig(name)
            if cfg and pcall(function() cfg:Delete() end) then
                toast("Config", "Deleted '" .. name .. "'.", "check")
                refreshConfigs()
            end
        end,
    })

    SettingsTab:Toggle({
        Title = "Auto Load Selected Config",
        Desc = "Load the selected config automatically every time the script is executed.",
        Icon = "rotate-ccw",
        Type = "Checkbox",
        Value = hasFS and isfile(AUTOLOAD_FILE) or false,
        Callback = function(v)
            if not hasFS then
                toast("Config", "Your executor has no file access.", "triangle-alert")
                return
            end
            pcall(function()
                if v then
                    writefile(AUTOLOAD_FILE, cleanName(selectedConfig))
                elseif isfile(AUTOLOAD_FILE) and type(delfile) == "function" then
                    delfile(AUTOLOAD_FILE)
                end
            end)
        end,
    })

    SettingsTab:Button({
        Title = "Reset All Settings",
        Desc = "Restore every Runner, Catcher, Wheel, Journey, Map Vote and Utilities option to its default.",
        Icon = "rotate-ccw",
        Callback = function()
            local count = 0
            for _, entry in ipairs(Hub.registry) do
                if entry.default ~= nil then
                    if pcall(function() entry.element:Set(entry.default) end) then
                        count = count + 1
                    end
                end
            end
            toast("Settings", "Reset " .. count .. " options to default.", "check")
        end,
    })

    -- ---------------------------------------------------------------
    -- About
    -- ---------------------------------------------------------------
    SettingsTab:Section({Title = "About"})

    SettingsTab:Paragraph({
        Title = "Huss Valley",
        Desc = "Chicken or Hero helper.\nToggle the window with the key selected above (default: RightShift).",
    })

    SettingsTab:Button({
        Title = "Copy Follow Link",
        Icon = "link",
        Callback = function()
            if type(setclipboard) == "function" then
                pcall(setclipboard, "https://rscripts.net/@_LSS")
                toast("Rscripts", "Link copied to clipboard.", "check")
            else
                toast("Rscripts", "https://rscripts.net/@_LSS", "link")
            end
        end,
    })

    SettingsTab:Button({
        Title = "Unload Script",
        Desc = "Stop everything, remove visuals and close the window.",
        Icon = "power",
        Callback = function()
            if Hub.cleanup then
                Hub.cleanup()
            end
        end,
    })

    -- Auto-load saved config (after every tab and element exists)
    if hasFS then
        local ok, saved = pcall(function()
            if isfile(AUTOLOAD_FILE) then
                return cleanName(readfile(AUTOLOAD_FILE))
            end
        end)
        if ok and type(saved) == "string" and saved ~= "" then
            selectedConfig = saved
            task.delay(1, function()
                if Hub.cleaned then
                    return
                end
                local cfg = buildConfig(saved)
                if cfg and pcall(function() cfg:Load() end) then
                    pcall(function() ConfigDropdown:Select(saved) end)
                    toast("Config", "Auto-loaded '" .. saved .. "'.", "check")
                end
            end)
        end
    end
end

WindUI:Notify({
    Title = "Huss Valley",
    Content = "Loaded. Auto Run is enabled by default.",
    Duration = 4,
    Icon = "wind",
})

local SPEED_RENDER_NAME = "CoH_SpeedOverride"
RunService:UnbindFromRenderStep(SPEED_RENDER_NAME)
RunService:BindToRenderStep(SPEED_RENDER_NAME, Enum.RenderPriority.Input.Value + 2, function()
    local role = getRole()
    local character = getCharacter()
    local hum = getHumanoid()
    if not character or not hum or hum.Health <= 0 then
        return
    end

    local state = character:GetAttribute("MovementState")
    if state == "Dashing" or state == "Boosting" then
        return
    end

    local nativeOutput = tonumber(character:GetAttribute("MovementSpeed"))
    if nativeOutput and nativeOutput > 0 then
        local desiredSpeed = nativeOutput
        if role == "Runner" and SETTINGS.customSpeed and SETTINGS.speedMultiplier > 1.0001 then
            desiredSpeed = nativeOutput * math.clamp(SETTINGS.speedMultiplier, 1, 2)
        elseif role == "Catcher" and SETTINGS.catcherCustomSpeed and SETTINGS.catcherSpeedMultiplier > 1.0001 then
            desiredSpeed = nativeOutput * math.clamp(SETTINGS.catcherSpeedMultiplier, 1, 2)
        end
        if math.abs(hum.WalkSpeed - desiredSpeed) > 0.05 then
            hum.WalkSpeed = desiredSpeed
        end
    end
end)

local RENDER_NAME = "CoH_StableController"
RunService:UnbindFromRenderStep(RENDER_NAME)

RunService:BindToRenderStep(RENDER_NAME, Enum.RenderPriority.Input.Value, function(dt)
    local now = os.clock()
    local ok, err = pcall(runnerStep, now, dt)
    if not ok then
        setDebugError("Runner: " .. tostring(err))
    end

    ok, err = pcall(catcherStep, now, dt)
    if not ok then
        setDebugError("Catcher: " .. tostring(err))
    end

    if now - runtime.utilityTick >= 0.25 then
        runtime.utilityTick = now
        ok, err = pcall(utilityStep, now)
        if not ok then
            setDebugError("Utility: " .. tostring(err))
        end
    end

    if runtime.debugEnabled and now - (runtime.debugPanelAt or -math.huge) >= 0.1 then
        runtime.debugPanelAt = now
        local debugOk, debugErr = pcall(updateDebugPanel, now)
        if not debugOk then
            setDebugError("DebugPanel: " .. tostring(debugErr))
        end
    end
end)

-- NOTE: `script` is nil when running through an executor (loadstring), which caused
-- "attempt to index nil with 'Destroying'". Cleanup is now a plain function that is
-- called from the Settings > Unload button, on window close, and on re-execute.
Hub.cleanup = function()
    if Hub.cleaned then
        return
    end
    Hub.cleaned = true

    -- stop every feature that polls SETTINGS flags
    for key, value in pairs(SETTINGS) do
        if type(value) == "boolean" then
            SETTINGS[key] = false
        end
    end

    pcall(cancelRevive)
    pcall(function() RunService:UnbindFromRenderStep(RENDER_NAME) end)
    pcall(function() RunService:UnbindFromRenderStep(SPEED_RENDER_NAME) end)
    pcall(restoreNativeWalkSpeed)
    pcall(cleanupVisuals)

    if Hub.idleConn then
        pcall(function() Hub.idleConn:Disconnect() end)
        Hub.idleConn = nil
    end

    runtime.mapCache = nil
    runtime.mapCacheAt = -math.huge
    runtime.runnerPlanAt = -math.huge
    runtime.runnerPlanDirection = Vector3.zero
    runtime.runnerPlanGoal = Vector3.zero
    runtime.wheelLastButton = nil
    runtime.wheelStatus = "disabled"
    runtime.wheelSpinning = false
    runtime.wheelNextAttemptAt = -math.huge
    runtime.journeyStatus = "disabled"
    runtime.journeyClaimedButtons = {}
    runtime.journeyLoaded = false
    runtime.journeySeasonId = nil
    runtime.journeyClaimInFlight = false
    runtime.journeyTier = 1
    runtime.journeyPremium = false
    runtime.journeyClaims = {}
    runtime.mapVoteStatus = "disabled"
    runtime.mapVoteOptions = {}
    runtime.mapVoteOpen = false
    runtime.safeCheckAt = -math.huge
    runtime.safeCheckPosition = nil
    edgeRayCache.map = nil
    edgeRayCache.field = nil
    edgeRayCache.params = nil
    edgeRayCache.invisWall = nil
    edgeRayCache.wallParams = nil

    pcall(function()
        if runtime.debugGui then
            runtime.debugGui:Destroy()
        end
    end)

    if Hub.genv.HussValleyUnload == Hub.cleanup then
        Hub.genv.HussValleyUnload = nil
    end

    pcall(function() Window:Destroy() end)
end

Hub.genv.HussValleyUnload = Hub.cleanup
pcall(function()
    Window:OnDestroy(function()
        Hub.cleanup()
    end)
end)

-- Always open on the Runner tab right after execution
function Hub.selectRunnerTab()
    if Hub.cleaned then
        return
    end
    pcall(function() RunnerTab:Select() end)
    pcall(function() Window:SelectTab(1) end)
end
Hub.selectRunnerTab()
task.delay(0.5, Hub.selectRunnerTab)
task.delay(1.5, Hub.selectRunnerTab)
end

-- ============================================================
-- ========== EJECUCIÓN PRINCIPAL ==========
-- ============================================================
if not SUPPORTED_PLACES[game.PlaceId] then
	print("❌ This game is not supported yet. PlaceId: " .. tostring(game.PlaceId))
	showUnsupportedScreen()
	return
end

local function launchGame()
	if game.PlaceId == 114697347887839 or game.PlaceId == 72858062353423 then
		runSpeedMonkeyEscape()
	elseif game.PlaceId == 142823291 then
		runMM2()
	elseif game.PlaceId == 77813828595591 then
		runKittenFarm()
	elseif game.PlaceId == 118941584817777 or game.PlaceId == 93411036959889 then
		runSpeedKeyboardEscape()
	elseif game.PlaceId == ONETAP_PLACE_ID then
		runOneTap()
	elseif game.PlaceId == 107535308163741 then
		runHussValley()
	end
end

launchGame()

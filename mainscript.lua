getgenv().Players = game:GetService("Players")
getgenv().playerData = game:GetService("Players").LocalPlayer:WaitForChild("PlayerData")
getgenv().ReplicatedStorage = game:GetService("ReplicatedStorage")
getgenv().RunService = game:GetService("RunService")
getgenv().MarketplaceService = game:GetService("MarketplaceService")
getgenv().RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
getgenv().TweenService = game:GetService("TweenService")
getgenv().PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Humanoid, Animator
getgenv().player = Players.LocalPlayer
getgenv().purchasedEmotesFolder = playerData:WaitForChild("Purchased"):WaitForChild("Emotes")
getgenv().Remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

--=Hub=

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DEATHSAKEN",
   Icon = 119855670079790,
   LoadingTitle = "Loading DEATHSAKEN...",
   LoadingSubtitle = "by D00M4N1TY (skid, ts is open source)",
   ShowText = "DEATHSAKEN",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DEATHSAKEN",
      FileName = "DEATHSAKEN"
   },
   DiscoHookrd = {
      Enabled = true,
      Invite = "dsc.gg/d4AZD9gCas",
      RememberJoins = true
   },
   KeySystem = True, -- Set this to true to enable key system
   KeySettings = {
      Title = "DEATHSAKEN-SYSTEM",
      Subtitle = "Key System",
      Note = "(dsc.gg/d4AZD9gCas) - Join our discord right now", -- Use this to tell the user how to get a key
      FileName = "deathsakenkey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"SKIDING"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- Tabs
local Combat = Window:CreateTab("Combat", "swords")
local Generators = Window:CreateTab("Generators", "package-2")
local ESP = Window:CreateTab("ESP", "scan-eye")
local StaminaSet = Window:CreateTab("Stamina Settings", "footprints")
local Aimbot = Window:CreateTab("Aimbot", "crosshair")
local Miscs = Window:CreateTab("Misc", "circle-ellipsis")
local AntiSlows = Window:CreateTab("Anti Slow", "accessibility")
local AchieveTab = Window:CreateTab("Achievements", "medal")

-- == Variables ==
local genEnabled = false
local genInterval = 1.25
local re = true
local Check = false
local lt = 0

-- == UI Elements ==
local autoGenToggle = Generators:CreateToggle({
	Name = "Auto Do Generator",
	CurrentValue = genEnabled,
	Flag = "AutoGenToggle",
	Callback = function(Value)
		genEnabled = Value
	end,
})

local genIntervalSlider = Generators:CreateSlider({
	Name = "Do Generator Interval (Seconds)",
	Range = {1, 15},
	Increment = 0.25,
	Suffix = "s",
	CurrentValue = genInterval,
	Flag = "GenIntervalSlider",
	Callback = function(Value)
		genInterval = Value
	end,
})

-- == Hook RF/RE to detect gene input/output + cooldown ==
local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...)
	local Args = { ... }
	local Method = getnamecallmethod()
	if not checkcaller() and typeof(Self) == "Instance" then
		if Method == "InvokeServer" or Method == "FireServer" then
			if tostring(Self) == "RF" then
				if Args[1] == "enter" then
					Check = true
				elseif Args[1] == "leave" then
					Check = false
				end
			elseif tostring(Self) == "RE" then
				lt = os.clock()
			end
		end
	end
	return Old(Self, unpack(Args))
end)

-- == Auto Generator Loop ==
game:GetService("RunService").Stepped:Connect(function()
	if genEnabled and Check and re and os.clock() - lt >= genInterval then
		re = false
		task.spawn(function()
			for _, gen in ipairs(workspace.Map.Ingame:WaitForChild("Map"):GetChildren()) do
				if gen.Name == "Generator" and gen:FindFirstChild("Remotes") then
					gen.Remotes.RE:FireServer()
				end
			end
			task.wait(genInterval)
			re = true
		end)
	end
end)

-- === ESP Toggles ===
local killersESPToggle = false
local survivorsESPToggle = false
local itemESPEnabled = false

ESP:CreateSection("Main ESP")

ESP:CreateToggle({
   Name = "Killers ESP",
   CurrentValue = false,
   Flag = "KillersESP",
   Callback = function(Value)
      killersESPToggle = Value
   end,
})

ESP:CreateToggle({
   Name = "Survivors ESP",
   CurrentValue = false,
   Flag = "SurvivorsESP",
   Callback = function(Value)
      survivorsESPToggle = Value
   end,
})

-- === ESP Logic ===
local camera = workspace.CurrentCamera

local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
local survivorsFolder = workspace:WaitForChild("Players"):WaitForChild("Survivors")

local function attachBillboard(model, color)
	if model:FindFirstChild("ESP_NameBillboard") then return end
	local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
	if not head then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_NameBillboard"
	billboard.Adornee = head
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.Parent = model

	local label = Instance.new("TextLabel")
	label.Name = "NameLabel"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.TextStrokeTransparency = 0
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextScaled = false
	label.TextWrapped = false
	label.ClipsDescendants = true
	label.TextTruncate = Enum.TextTruncate.None
	label.AutomaticSize = Enum.AutomaticSize.X
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextSize = 10
	label.Font = Enum.Font.GothamBold
	label.Text = "Loading..."
	label.Parent = billboard
end

local function updateBillboardText(model)
	local billboard = model:FindFirstChild("ESP_NameBillboard")
	if not billboard then return end

	local label = billboard:FindFirstChild("NameLabel")
	if not label then return end

	local actorText = model:GetAttribute("ActorDisplayName") or "???"
	local skinText = model:GetAttribute("SkinNameDisplay")
	local username = model:GetAttribute("Username") or "Unknown"

	-- Use pre-tagged attribute
	if actorText == "Noli" and model:GetAttribute("IsFakeNoli") == true then
		actorText = actorText .. " (FAKE)"
	end

	local displayText = actorText
	if skinText and tostring(skinText) ~= "" then
		displayText = displayText .. " | " .. skinText
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local hp = math.floor(humanoid.Health)
		local maxhp = math.floor(humanoid.MaxHealth)
		displayText = string.format("%s (HP: %d/%d)", displayText, hp, maxhp)
	end

	label.Text = displayText
end

-- Noli table by username
local noliByUsername = {}

local function clearFakeTags()
    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:GetAttribute("ActorDisplayName") == "Noli" then
            killer:SetAttribute("IsFakeNoli", false)
        end
    end
end

local function scanNolis()
    noliByUsername = {}

    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:GetAttribute("ActorDisplayName") == "Noli" then
            local username = killer:GetAttribute("Username")
            if username then
                if not noliByUsername[username] then
                    noliByUsername[username] = {}
                end
                table.insert(noliByUsername[username], killer)
            end
        end
    end

    for username, models in pairs(noliByUsername) do
        if #models > 1 then
            -- The first noli is real, the later ones are fake.
            for i = 2, #models do
                models[i]:SetAttribute("IsFakeNoli", true)
            end
            models[1]:SetAttribute("IsFakeNoli", false)
        else
            -- Only 1 Noli, then it is not fake
            models[1]:SetAttribute("IsFakeNoli", false)
        end
    end
end

local function updateFakeNolis()
    clearFakeTags()
    scanNolis()
end

local function setupModel(model, isKiller)
	if not model:IsA("Model") or not model:FindFirstChildOfClass("Humanoid") then return end
	local color = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 0)

	attachBillboard(model, color)
	updateBillboardText(model)

	if not model:FindFirstChild("ESP_Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "ESP_Highlight"
		highlight.FillTransparency = 1
		highlight.OutlineTransparency = 0
		highlight.OutlineColor = color
		highlight.Adornee = model
		highlight.Parent = model
	end

	model:GetAttributeChangedSignal("ActorDisplayName"):Connect(function()
		updateBillboardText(model)
	end)
	model:GetAttributeChangedSignal("SkinNameDisplay"):Connect(function()
		updateBillboardText(model)
	end)

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			updateBillboardText(model)
		end)
		humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
			updateBillboardText(model)
		end)
	end

	model.AncestryChanged:Connect(function(_, parent)
		if not parent then
			local bb = model:FindFirstChild("ESP_NameBillboard")
			if bb then bb:Destroy() end

			local hl = model:FindFirstChild("ESP_Highlight")
			if hl then hl:Destroy() end
		end
	end)
end

local function scanFolder(folder, isKiller)
	for _, model in ipairs(folder:GetChildren()) do
		setupModel(model, isKiller)
	end
end

task.spawn(function()
	while true do
		scanFolder(killersFolder, true)
		scanFolder(survivorsFolder, false)
		task.wait(5)
	end
end)

local function handleChildAdded(folder, isKiller)
	folder.ChildAdded:Connect(function(child)
		task.spawn(function()
			repeat task.wait() until child:IsDescendantOf(folder)
			local timeout = 3
			local timer = 0
			while (not child:FindFirstChild("Head") and not child:FindFirstChildWhichIsA("BasePart")) or not child:FindFirstChildOfClass("Humanoid") do
				task.wait(0.1)
				timer += 0.1
				if timer > timeout then return end
			end
			task.wait(0.2) -- to make sure Attribute is assigned
			setupModel(child, isKiller)
		end)
	end)
end

handleChildAdded(killersFolder, true)
handleChildAdded(survivorsFolder, false)
updateFakeNolis()

-- When Noli disappears, scan again
killersFolder.ChildRemoved:Connect(function(removed)
    if removed:GetAttribute("ActorDisplayName") == "Noli" then
        updateFakeNolis()
    end
end)

-- When a new Noli is added, rescan after 0.2s for the attribute to be updated.
killersFolder.ChildAdded:Connect(function(added)
    if added:GetAttribute("ActorDisplayName") == "Noli" then
        task.defer(function()
            task.wait(0.2)
            updateFakeNolis()
        end)
    end
end)

-- Rescan
task.spawn(function()
    while true do
        task.wait(10)
        updateFakeNolis()
    end
end)

RunService.RenderStepped:Connect(function()
	for _, folderData in pairs({
		{folder = killersFolder, toggle = killersESPToggle},
		{folder = survivorsFolder, toggle = survivorsESPToggle},
	}) do
		for _, model in ipairs(folderData.folder:GetChildren()) do
			local bb = model:FindFirstChild("ESP_NameBillboard")
			local hl = model:FindFirstChild("ESP_Highlight")

			if bb then bb.Enabled = folderData.toggle end
			if hl then hl.Enabled = folderData.toggle end

			if folderData.toggle and bb and bb.Adornee then
				local dist = (camera.CFrame.Position - bb.Adornee.Position).Magnitude
				local scale = math.clamp(1 / (dist / 20), 0.5, 2)

				local label = bb:FindFirstChild("NameLabel")
				if label then
					label.TextSize = math.clamp(10 * scale, 12, 20)
					bb.Size = UDim2.new(0, label.TextBounds.X + 20, 0, 50 * scale)
				end
			end
		end
	end
end)

local camera = workspace.CurrentCamera

-- Real generator
local DEFAULT_SIZE = 5
local MIN_SIZE = 3
local MAX_SIZE = 15

-- Fake generator
local FAKE_DEFAULT_SIZE = 10
local FAKE_MIN_SIZE = 5
local FAKE_MAX_SIZE = 20

local trackedGenerators = {}
local partEspName = "NurbsPath"
local espTransparency = 0.5
local partEspTrigger = nil
local espConnection = nil
local generatorESPEnabled = false

-- == % Progress Format ==
local function getProgressPercent(value)
    if value == 0 then return "0%"
    elseif value == 26 then return "25%"
    elseif value == 52 then return "50%"
    elseif value == 78 then return "75%"
    elseif value == 100 then return "100%"
    else
    return ""
    end
end

-- == Scale Calculation ==
local function calculateScale(pos, isFake)
    if not camera then return DEFAULT_SIZE end
    local distance = (camera.CFrame.Position - pos).Magnitude

    local defaultSize = isFake and FAKE_DEFAULT_SIZE or DEFAULT_SIZE
    local minSize = isFake and FAKE_MIN_SIZE or MIN_SIZE
    local maxSize = isFake and FAKE_MAX_SIZE or MAX_SIZE

    local scale = defaultSize * (20 / distance)
    return math.clamp(scale, minSize, maxSize)
end

-- == BillboardGUI ESP ==
local function createOrUpdateProgressESP(model, progressValue)
    if not model or not model:IsA("Model") then return end

    local adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not adornee then return end

    local billboard = model:FindFirstChild("Progress_ESP")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "Progress_ESP"
        billboard.Adornee = adornee
        billboard.Size = UDim2.new(0, DEFAULT_SIZE*10, 0, DEFAULT_SIZE*3)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.AlwaysOnTop = true
        billboard.Parent = model

        local label = Instance.new("TextLabel")
        label.Name = "ProgressLabel"
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard
    end

    local label = billboard:FindFirstChild("ProgressLabel")
    if label then
        if model.Name == "FakeGenerator" then
            label.Text = "Fake Generator"
            label.TextColor3 = Color3.fromRGB(255,0,0)
        else
            label.Text = getProgressPercent(progressValue)
            label.TextColor3 = Color3.fromRGB(255,255,255)
        end
    end

    local isFake = model.Name == "FakeGenerator"
    task.spawn(function()
        while billboard.Parent do
            local scale = calculateScale(adornee.Position, isFake)
            billboard.Size = UDim2.new(0, scale*10, 0, scale*3)
            task.wait(0.1)
        end
    end)
end

-- == BoxHandleAdornment ESP ==
local function attachESP(part)
    if not part or not part:IsA("BasePart") then return end
    if part:FindFirstChild("ESP_Fill") then return end

    local fill = Instance.new("BoxHandleAdornment")
    fill.Name = "ESP_Fill"
    fill.Adornee = part
    fill.AlwaysOnTop = true
    fill.ZIndex = 1
    fill.Size = part.Size
    fill.Transparency = espTransparency

    if part.Parent and part.Parent.Name == "FakeGenerator" then
        fill.Color3 = Color3.fromRGB(255,0,0)
    else
        fill.Color3 = Color3.fromRGB(220,150,255)
    end

    fill.Parent = part
end

local function attachESPForExistingParts()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower() == partEspName:lower() then
            attachESP(v)
        end
    end
end

-- == Update Generators ==
local function updateGenerators()
    local rootMap = workspace:FindFirstChild("Map")
    if not rootMap then return end
    local ingame = rootMap:FindFirstChild("Ingame")
    if not ingame then return end
    local gameMap = ingame:FindFirstChild("Map")
    if not gameMap then return end

    for _, obj in ipairs(gameMap:GetDescendants()) do
        if obj.Name == "Generator" or obj.Name == "FakeGenerator" then
            local progress = obj:FindFirstChild("Progress")
            local lastProgress = trackedGenerators[obj]

            if obj.Name == "Generator" and progress and progress:IsA("ValueBase") then
                if lastProgress ~= progress.Value then
                    createOrUpdateProgressESP(obj, progress.Value)
                    trackedGenerators[obj] = progress.Value
                end
            elseif obj.Name == "FakeGenerator" then
                createOrUpdateProgressESP(obj, 0)
                trackedGenerators[obj] = 0
            elseif lastProgress ~= nil then
                createOrUpdateProgressESP(obj, nil)
                trackedGenerators[obj] = nil
            end
        end
    end
end

-- == Continuous Scale Update ==
local function updateAllESPSizes()
    for gen in pairs(trackedGenerators) do
        local billboard = gen:FindFirstChild("Progress_ESP")
        local adornee = gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")
        if billboard and adornee then
            local isFake = gen.Name == "FakeGenerator"
            local scale = calculateScale(adornee.Position, isFake)
            billboard.Size = UDim2.new(0, scale*10, 0, scale*3)
        end
    end
end

-- == Start/Stop ESP ==
local updateThrottle = 0
local function startGeneratorESP()
    attachESPForExistingParts()
    if not partEspTrigger then
        partEspTrigger = workspace.DescendantAdded:Connect(function(v)
            if v:IsA("BasePart") and v.Name:lower() == partEspName:lower() then
                attachESP(v)
            end
        end)
    end
    if not espConnection then
        espConnection = RunService.RenderStepped:Connect(function(dt)
            if generatorESPEnabled then
                updateThrottle += dt
                if updateThrottle >= 0.5 then
                    updateGenerators()
            		updateAllESPSizes()
                    updateThrottle = 0
                end
            end
        end)
    end
end

local function stopGeneratorESP()
    if partEspTrigger then
        partEspTrigger:Disconnect()
        partEspTrigger = nil
    end
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    for gen in pairs(trackedGenerators) do
        createOrUpdateProgressESP(gen, nil)
    end
    trackedGenerators = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower() == partEspName:lower() then
            local adorn = v:FindFirstChild("ESP_Fill")
            if adorn then adorn:Destroy() end
        end
    end
end

local colorByName = {
	BloxyCola = Color3.fromRGB(255, 140, 0),
	Medkit = Color3.fromRGB(255, 100, 255),
}

local espParts = {}
local partEspTrigger = nil

local function FindInTable(tbl, value)
	for _, v in pairs(tbl) do
		if v == value then return true end
	end
	return false
end

local function createNameTag(part, tagName, color)
	if part:FindFirstChild("ESP_Billboard") then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Billboard"
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.Adornee = part
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.Parent = part

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = color
	textLabel.TextStrokeTransparency = 0
	textLabel.Text = tagName
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = false
	textLabel.TextSize = 10
	textLabel.Parent = billboard
end

local function createBoxESP(part)
	if not part or not part:IsA("BasePart") then return end
	if part.Name ~= "ItemRoot"

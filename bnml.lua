local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()
local Window = Library.CreateLib("bnml hub (version 0.5 beta )", "RJTheme7")
local Tab = Window:NewTab("main")
local Section = Tab:NewSection("тп")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInputService = game:GetService("UserInputService")

local tpEnabled = false -- Переменная состояния

Section:NewToggle("клик тп" ,"ToggleInfo", function(state)
    tpEnabled = state
end)

mouse.Button1Down:Connect(function()
    -- Твой код с проверкой включенного переключателя
    if tpEnabled and userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local targetPosition = mouse.Hit.p
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        end
    end
end)
Section:NewButton("тп на таверы","ButtonInfo",function()
    game:GetService("Workspace")[game:GetService("Players").LocalPlayer.Name].HumanoidRootPart.CFrame = CFrame.new(-667.039612, 1765.47778, -824.368896, -0.629755378, -0.673967361, 0.38623327, -7.32235783e-09, 0.497214884, 0.867627442, -0.77679348, 0.546393037, -0.313123763)
end)
Section:NewButton("тп к вз","ButtonInfo",function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

for _, object in pairs(workspace:GetDescendants()) do
    if object.Name == "Explosive Sniper Giver" then
        hrp.CFrame = object:GetPivot() * CFrame.new(5, 3, 5)
        break
    end
end
end)
local RS = game:GetService("RunService")
local player = game.Players.LocalPlayer
local Section = Tab:NewSection("движения игрока")

Section:NewToggle("Speed Hack (35)", "Увеличивает скорость бега", function(state)
    if state then
        -- Включаем цикл
        _G.WalkSpeedLoop = true
        task.spawn(function()
            while _G.WalkSpeedLoop do
                local char = player.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = 35
                end
                RS.Heartbeat:Wait()
            end
            
            -- Возврат к стандартной скорости при выключении
            local char = player.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    else
        -- Останавливаем цикл
        _G.WalkSpeedLoop = false
    end
end)


-- Бинд на клавиши
Section:NewKeybind("noclip(работает 3 секунды)", "KeybindInfo", Enum.KeyCode.X, function()
	local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local endTime = tick() + 3 -- Устанавливаем время завершения (через 3 секунды)

local connection
connection = RunService.Stepped:Connect(function()
    if tick() < endTime then
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    else
        connection:Disconnect() -- Отключаем скрипт через 3 секунды
    end
end)

end)

Section:NewSlider("быстрый ап", "SliderInfo", 500, 0, function(promt) -- 500 (Макс. значение) | 0 (Мин. значение)
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    prompt.HoldDuration = 0
end)
end)
local Section = Tab:NewSection("old wt")

Section:NewButton("ButtonText", "ButtonInfo", function()
 local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = 124195929639441 -- ID старой карты

local function JoinAvailableServer()
    print("🌑 Void: Поиск нового живого сервера...")

    -- Запрашиваем список всех публичных серверов этого плейса
    local sfUrl = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"

    local success, result = pcall(function()
        return game:HttpGet(sfUrl)
    end)

    if success then
        local data = HttpService:JSONDecode(result)

        if data and data.data then
            for _, server in pairs(data.data) do
                -- Проверяем, что сервер не полный и это не тот, на котором мы (если вдруг мы уже там)
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    print("✅ Void: Сервер найден! ID: " .. server.id)
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                    return
                end
            end
        end

        -- Если публичных серверов нет, пробуем зайти "напролом"
        warn("⚠️ Void: Публичных серверов не найдено. Пробую Force Join...")
        TeleportService:Teleport(PlaceId, Players.LocalPlayer)
    else
        warn("🛑 Ошибка при получении списка серверов: " .. tostring(result))
    end
end

JoinAvailableServer()
end)


local Tab = Window:NewTab("legit")
local Section = Tab:NewSection("лодаут(берется только 2)")
Section:NewKeybind("важно находиться в меню лодаутав", "KeybindInfo", Enum.KeyCode.F, function()
    local A_1 = 1
local Event = game:GetService("ReplicatedStorage").Packages.Knit.Services.LoadoutService.RF.EquipLoadout
Event:InvokeServer(A_1)

wait(1)

local A_1 = 2
local Event = game:GetService("ReplicatedStorage").Packages.Knit.Services.LoadoutService.RF.EquipLoadout
Event:InvokeServer(A_1)
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Holding = false
local AimEnabled = false -- Состояние переключателя из меню

-- Настройки
local FOV_RADIUS = 150 
-- Дистанция (в студах), которую ты просил
local MAX_DISTANCE = 325

local function GetClosestPlayer()
    if not AimEnabled then return nil end -- Если выключено в меню, не ищем цель
    
    local Target = nil
    local ShortestDistance = FOV_RADIUS

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            
            -- Проверка дистанции
            local Magnitude = (LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude
            
            if Magnitude <= MAX_DISTANCE and v.Team ~= LocalPlayer.Team then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                
                if OnScreen then
                    local MousePos = UserInputService:GetMouseLocation()
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    
                    if Distance < ShortestDistance then
                        ShortestDistance = Distance
                        Target = v.Character.Head
                    end
                end
            end
        end
    end
    return Target
end

-- Твой Toggle из UI
Section:NewToggle("Aimbot", "Включить авто-наведение", function(state)
    AimEnabled = state
    if state then
        print("Aimbot Activated")
    else
        print("Aimbot Deactivated")
        Holding = false -- Сбрасываем зажим при выключении
    end
end)

-- Управление зажимом (ПКМ)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

-- Цикл работы
RunService.RenderStepped:Connect(function()
    if AimEnabled and Holding then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)
Section:NewSlider("быстрый ап", "SliderInfo", 500, 0, function(promt) -- 500 (Макс. значение) | 0 (Мин. значение)
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    prompt.HoldDuration = 0
end)
end)


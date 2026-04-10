local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "puso hub",
    LoadingTitle = "by brnl",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local Tab = Window:CreateTab("Главная", 4483362458) 

Tab:CreateSection("тп")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInputService = game:GetService("UserInputService")
local tpEnabled = false

local savedCFrame = nil
local tpKey = Enum.KeyCode.Z -- Клавиша телепортации


local Toggle = Tab:CreateToggle({
   Name = "клик тп",
   CurrentValue = false,
   Flag = "ClickTP",
   Callback = function(state)
      tpEnabled = state
   end,
})


mouse.Button1Down:Connect(function()
    if tpEnabled and userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local targetPosition = mouse.Hit.p
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        end
    end
end)


local positionsHistory = {} 
local tpKey = Enum.KeyCode.Z


Tab:CreateButton({
   Name = "Записать новую точку (Создать запись)",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
          local currentPos = char.HumanoidRootPart.CFrame
          table.insert(positionsHistory, currentPos)
          
          Rayfield:Notify({
             Title = "Записано!",
             Content = "жми на z чтоб тпнуться",
             Duration = 2,
             Image = 4483362458
          })
      end
   end,
})


game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == tpKey then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
       
            if #positionsHistory > 0 then
                local lastIndex = #positionsHistory
                char.HumanoidRootPart.CFrame = positionsHistory[lastIndex]
            else
                Rayfield:Notify({
                   Title = "Пусто",
                   Content = "Нет сохраненных переменных!",
                   Duration = 2
                })
            end
        end
    end
end)





local Button = Tab:CreateButton({
   Name = "тп на товеры",
   Callback = function()
game:GetService("Workspace")[game:GetService("Players").LocalPlayer.Name].HumanoidRootPart.CFrame = CFrame.new(-667.039612, 1765.47778, -824.368896, -0.629755378, -0.673967361, 0.38623327, -7.32235783e-09, 0.497214884, 0.867627442, -0.77679348, 0.546393037, -0.313123763)
   end,
})
local ButtonTP = Tab:CreateButton({
   Name = "Телепорт к Explosive Sniper",
   Callback = function()
      local player = game:GetService("Players").LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")

      local found = false
      for _, object in pairs(workspace:GetDescendants()) do
          if object.Name == "Explosive Sniper Giver" then
              
              hrp.CFrame = object:GetPivot() * CFrame.new(5, 3, 5)
              found = true
              
              Rayfield:Notify({
                 Title = "Телепортация",
                 Content = "Вы успешно перемещены к снайперке!",
                 Duration = 3,
                 Image = 4483362458,
              })
              break
          end
      end

      if not found then
          Rayfield:Notify({
             Title = "Ошибка",
             Content = "Объект 'Explosive Sniper Giver' не найден на карте",
             Duration = 3,
             Image = 4483362458,
          })
      end
   end,
})
Tab:CreateSection("movement")
local Toggle = Tab:CreateToggle({
   Name = "Speed Hack (35)",
   CurrentValue = false,
   Flag = "SpeedHackToggle", -- Уникальный флаг для сохранения настроек
   Callback = function(Value)
      if Value then
          -- Включаем цикл
          _G.WalkSpeedLoop = true
          task.spawn(function()
              local player = game:GetService("Players").LocalPlayer
              local RS = game:GetService("RunService")
              
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
   end,
})

local NoclipConnection = nil

Tab:CreateToggle({
   Name = "Noclip (Сквозь стены)",
   CurrentValue = false,
   Flag = "NoclipToggle", 
   Callback = function(Value)
      if Value then
         -- ВКЛЮЧАЕМ NOCLIP
         NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
            local character = game.Players.LocalPlayer.Character
            if character then
               for _, part in pairs(character:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
               end
            end
         end)
         
         Rayfield:Notify({
            Title = "Noclip",
            Content = "Активирован",
            Duration = 2,
            Image = 4483362458,
         })
      else
         -- ВЫКЛЮЧАЕМ NOCLIP
         if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
         end
         
         -- Возвращаем коллизию (опционально, персонаж сам обновит её через секунду)
         local character = game.Players.LocalPlayer.Character
         if character then
            for _, part in pairs(character:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = true
               end
            end
         end

         Rayfield:Notify({
            Title = "Noclip",
            Content = "Деактивирован",
            Duration = 2,
            Image = 4483362458,
         })
      end
   end,
})

Tab:CreateSection("камера")


-- Устанавливаем начальное значение
getgenv().Resolution = 1

local Slider = Tab:CreateSlider({
   Name = "Resolution (Stretched)",
   Range = {0.1, 2},
   Increment = 0.01,
   Suffix = "Scale",
   CurrentValue = 0.64,
   Flag = "ResSlider", 
   Callback = function(Value)
      getgenv().Resolution = Value
   end,
})

-- Основной цикл работы камеры
local Camera = workspace.CurrentCamera
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().Resolution then
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution, 0, 0, 0, 1)
    end
end)








local Tab = Window:CreateTab("legit", 4483362458) 
local InstantInteract = false

local LoadoutService = game:GetService("ReplicatedStorage").Packages.Knit.Services.LoadoutService.RF.EquipLoadout

local Keybind = Tab:CreateKeybind({
   Name = "лодаут",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "NoclipKeybind", 
   Callback = function(Keybind)
    
 local A_1 = 1
local Event = game:GetService("ReplicatedStorage").Packages.Knit.Services.LoadoutService.RF.EquipLoadout
Event:InvokeServer(A_1)

wait(1)

local A_1 = 2
local Event = game:GetService("ReplicatedStorage").Packages.Knit.Services.LoadoutService.RF.EquipLoadout
Event:InvokeServer(A_1)
      
      Rayfield:Notify({
         Title = "лодаут",
         Content = "важно находиться возле взятия а в 1 раз в менюшке",
         Duration = 2,
         Image = 4483362458,
      })
   end,
})
 
Tab:CreateToggle({
   Name = "быстрый ап",
   CurrentValue = false,
   Flag = "InstantInteract",
   Callback = function(state)
      InstantInteract = state
   end,
})

game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if InstantInteract then
        prompt.HoldDuration = 0
    end
end)
local FOV_RADIUS = 150 
local MAX_DISTANCE = 325
local AimEnabled = false
local Holding = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function GetClosestPlayer()
    if not AimEnabled then return nil end
    local Target = nil
    local ShortestDistance = FOV_RADIUS

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid").Health > 0 then
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

Tab:CreateToggle({
   Name = "Aimbot (ПКМ)",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(state)
      AimEnabled = state
      if not state then
          Holding = false
      end
   end,
})

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

RunService.RenderStepped:Connect(function()
    if AimEnabled and Holding then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)
local Tab = Window:CreateTab("Old WT", 4483362458)
Tab:CreateSection("олд вт")

local Button = Tab:CreateButton({
   Name = "Teleport to Old WT",
   Callback = function()
      -- Сразу выполняем твой код телепортации при нажатии:
      local TeleportService = game:GetService("TeleportService")
      local HttpService = game:GetService("HttpService")
      local Players = game:GetService("Players")

      local PlaceId = 124195929639441

      local function JoinAvailableServer()
          print("🌑 Void: Поиск нового живого сервера...")

          local sfUrl = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"

          local success, result = pcall(function()
              return game:HttpGet(sfUrl)
          end)

          if success then
              local data = HttpService:JSONDecode(result)

              if data and data.data then
                  for _, server in pairs(data.data) do
                      if server.playing < server.maxPlayers and server.id ~= game.JobId then
                          print("✅ Void: Сервер найден! ID: " .. server.id)
                          TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                          return
                      end
                  end
              end

              warn("⚠️ Void: Публичных серверов не найдено. Пробую Force Join...")
              TeleportService:Teleport(PlaceId, Players.LocalPlayer)
          else
              warn("🛑 Ошибка при получении списка серверов: " .. tostring(result))
          end
      end

      JoinAvailableServer()
   end,
})

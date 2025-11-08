local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Residence Massacre ULTIMATE Hub (BETA)",
    LoadingTitle = "RMUH v0.3",
    LoadingSubtitle = "by you don't need know",

    TextColor = Color3.fromRGB(255, 0, 0),
 })
local ConfigTable = {
    -- OTHERS
	["ClassicCameraMode"] = false,
    ["InfiniteStamina"] = false,
    ["FullBright"] = false,
    ["EspPlayers"] = false,
    ["Ant-Frosted"] = false,
    -- NIGHT 1
    ["HighlightLarry"] = false,
    ["Infinite02"] = false,
    ["AutoLight"] = false,
    ["AutoScare"] = false,
    -- NIGHT 2
    ["HighlightLarryNight2"] = false,
    ["HighlightStalker"] = false,
    -- NIGHT 3
    ["HighlightWorker"] = false,
    ["HighlightWorkerHead"] = false,
}

-- Cria a configuração se ainda não existir
local configSettings = game.ReplicatedFirst:FindFirstChild("GameConfig")
if not configSettings then
	configSettings = Instance.new("Configuration")
	configSettings.Name = "GameConfig"
	configSettings.Parent = game.ReplicatedFirst
end

-- Cria BoolValues e conecta atualizações
for name, value in pairs(ConfigTable) do
	local existingValue = configSettings:FindFirstChild(name)
	if not existingValue then
		local newValue = Instance.new("BoolValue")
		newValue.Name = name
		newValue.Value = value
		newValue.Parent = configSettings

		-- Quando o BoolValue mudar no jogo, atualiza a tabela
		newValue.Changed:Connect(function(newVal)
			ConfigTable[name] = newVal
			print("Config atualizada:", name, "=", newVal)
		end)
	else
		-- Se já existe, sincroniza o valor inicial
		ConfigTable[name] = existingValue.Value
	end
end
 local PlayerTab = Window:CreateTab("Others") -- Title, Image
 local Paragraph = PlayerTab:CreateParagraph({Title = "Others Functions", Content = "Safe Spot, Infinite Stamina and others"})
 local Button = PlayerTab:CreateButton({
   Name = "SafeSpot (do not use in tight spaces for you safety)",
   Callback = function()
        local part = Instance.new("Part")
        part.Name = "SafeSpotPartRMUH"
        part.Parent = workspace
        part.Position = game.Players.LocalPlayer.Character.Head.Position + Vector3.new(0, 2, 0)
        part.Size = Vector3.new(50,1,50)
        part.Transparency = 1
        part.Anchored = true
        game.Players.LocalPlayer.Character:MoveTo(part.Position + Vector3.new(0, 5, 0)) 
   end,
 })
local configSettings = game.ReplicatedFirst:WaitForChild("GameConfig")
local ClassicCameraMode = configSettings:WaitForChild("ClassicCameraMode")

 local Toggle = PlayerTab:CreateToggle({
   Name = "Classic Camera Mode",
   CurrentValue = ClassicCameraMode.Value,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(value)
        if value == true then
            local player = game.Players.LocalPlayer
            local camera = workspace.CurrentCamera

            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMinZoomDistance = 0.5
            player.CameraMaxZoomDistance = 128
            ClassicCameraMode.Value = true
        else
            local player = game.Players.LocalPlayer
            local camera = workspace.CurrentCamera

            player.CameraMode = Enum.CameraMode.LockFirstPerson
            player.CameraMinZoomDistance = 0
            player.CameraMaxZoomDistance = 0
            ClassicCameraMode.Value = false
        end
   end, 
 })
local EspPlayers = configSettings:WaitForChild("EspPlayers")
local Toggle = PlayerTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = EspPlayers.Value,
    Flag = "ToggleESP",
    Callback = function(value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        if value then
            EspPlayers.Value = true
            -- Função que aplica ESP em um personagem
            local function applyESP(player)
                if player == LocalPlayer then return end
                local character = player.Character or player.CharacterAdded:Wait()
                local head = character:WaitForChild("Head")

                -- Evita duplicar
                if character:FindFirstChild("ESP_Highlight") then return end

                -- Highlight
                local h = Instance.new("Highlight")
                h.Name = "ESP_Highlight"
                h.FillColor = Color3.fromRGB(0, 255, 0)
                h.OutlineColor = Color3.fromRGB(0, 150, 0)
                h.Adornee = character
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = character

                -- BillboardGui (nome acima da cabeça)
                local b = Instance.new("BillboardGui")
                b.Name = "ESP_NameTag"
                b.Adornee = head
                b.Size = UDim2.new(0, 200, 0, 50)
                b.StudsOffset = Vector3.new(0, 3, 0)
                b.AlwaysOnTop = true
                b.Parent = character

                local t = Instance.new("TextLabel")
                t.Parent = b
                t.Size = UDim2.new(1, 0, 1, 0)
                t.BackgroundTransparency = 1
                t.Text = player.Name
                t.TextColor3 = Color3.fromRGB(0, 255, 0)
                t.TextScaled = true
            end

            -- Aplica o ESP para todos os jogadores atuais
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    applyESP(plr)
                end
            end

            -- Aplica em novos jogadores que entrarem
            Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function()
                    applyESP(plr)
                end)
            end)

            -- Reaplica caso um jogador respawn
            for _, plr in ipairs(Players:GetPlayers()) do
                plr.CharacterAdded:Connect(function()
                    applyESP(plr)
                end)
            end

        else
            EspPlayers.Value = false
            -- Remove todos os ESPs
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr.Character then
                    if plr.Character:FindFirstChild("ESP_Highlight") then
                        plr.Character.ESP_Highlight:Destroy()
                    end
                    if plr.Character:FindFirstChild("ESP_NameTag") then
                        plr.Character.ESP_NameTag:Destroy()
                    end
                end
            end
        end
    end,
})
local InfiniteStamina = configSettings:WaitForChild("InfiniteStamina")
  local Toggle = PlayerTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = InfiniteStamina.Value,
   Flag = "Toggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(value)
        if value == true then
            game.Players.LocalPlayer.Character.Sprint.Overdrive.Value = 99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
            InfiniteStamina.Value = true
        else
            game.Players.LocalPlayer.Character.Sprint.Overdrive.Value = 0
            InfiniteStamina.Value = false
        end
   end,
 })
local FullBright = configSettings:WaitForChild("FullBright")
  local Toggle = PlayerTab:CreateToggle({
   Name = "Full Bright (Made by my friend)",
   CurrentValue = FullBright.Value,
   Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(value)
        if value == true then
            game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
            game:GetService("Lighting").OutdoorAmbient = Color3.new(1, 1, 1)
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").GlobalShadows = false

            game:GetService("Lighting").FogEnd = 100000
            FullBright.Value = true     
        else
            game:GetService("Lighting").Ambient = Color3.fromRGB(128, 128, 128)
            game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").GlobalShadows = true

            game:GetService("Lighting").FogEnd = 1000
            FullBright.Value = false    
        end
   end,
 })

local gameState = game.ReplicatedStorage:WaitForChild("GameState")

local blizzard = gameState:FindFirstChild("Blizzard")
local infinite = gameState:FindFirstChild("Infinite")

if (blizzard and blizzard.Value) or (infinite and infinite.Value) then
    local Paragraph = PlayerTab:CreateParagraph({Title = "Blizzard", Content = "This only appears in Blizzard or Endless."})
    local AntFrosted = configSettings:WaitForChild("Ant-Frosted")
    local Toggle = PlayerTab:CreateToggle({
        Name = "Ant-Frosted",
        CurrentValue = AntFrosted.Value,
        Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
            if value == true then
                game.Players.LocalPlayer.Character.Temperature.Disabled = true
                AntFrosted.Value = true
                if game.Players.LocalPlayer.Character.Temperature.Disabled == false then 
                    game.Players.LocalPlayer.Character.Temperature.Disabled = true
                end
            else
                game.Players.LocalPlayer.Character.Temperature.Disabled = false
                AntFrosted.Value = false
                if game.Players.LocalPlayer.Character.Temperature.Disabled == true then 
                    game.Players.LocalPlayer.Character.Temperature.Disabled = false
                end
            end
        end,
    })
end

local noite = gameState:FindFirstChild("Night")
if noite and noite.Value == 1 and not gameState:FindFirstChild("Repairing") then
    local PosTab = {
        ["Generator"] = Vector3.new(-81, 4, -131),
        ["Power"] = Vector3.new(-3, 4, -96),
        ["Entrance"] = Vector3.new(-8, 7, -49),
        ["StairRoom"] = Vector3.new(-7, 7, -64),
        ["BedRoom"] = Vector3.new(-34, 23, -77),
    }
    local larry = game.ReplicatedStorage:FindFirstChild("Mutant") or game.workspace:FindFirstChild("Mutant")
    local PlayerTab = Window:CreateTab("Night 1") -- Title, Image
    local HighlightLarry = configSettings:WaitForChild("HighlightLarry")
    local Paragraph = PlayerTab:CreateParagraph({Title = "Night", Content = "Night 1 scripts"})
    local Toggle = PlayerTab:CreateToggle({
        Name = "Highlight Larry",
        CurrentValue = HighlightLarry.Value,
        Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
            if value then
                HighlightLarry.Value = true
                for _,MutantParts in ipairs(larry:GetChildren()) do
                    if MutantParts:IsA("BasePart") then
                        Instance.new("Highlight").Parent = MutantParts
                    end
                end
            else
                HighlightLarry.Value = false
                for _,MutantParts in ipairs(larry:GetChildren()) do
                    if MutantParts:IsA("BasePart") and MutantParts:FindFirstChild("Highlight") then
                        MutantParts.Highlight:Destroy()
                    end
                end
            end
        end,
    })
    local connection
    local InfiniteO2 = configSettings:WaitForChild("Infinite02")
     local Toggle = PlayerTab:CreateToggle({
        Name = "Infinite O2",
        CurrentValue = InfiniteO2.Value,
        Flag = "Toggle5", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
            if value then
                InfiniteO2.Value = true
                local plr = game.Players.LocalPlayer
                local RunService = game:GetService("RunService")

                -- variável de controle
                local activated = true -- defina isso em outro lugar do script se quiser controlar quando ativa

                connection = RunService.RenderStepped:Connect(function()
                    local character = plr.Character
                    if not character then return end

                    local breath = character:FindFirstChild("Breath")
                    if not breath or not breath:IsA("NumberValue") then return end

                    if activated and breath.Value <= 19.9 then
                        breath.Value = 20
                    end
                end)
            else
                InfiniteO2.Value = false
                connection:Disconnect()
            end
        end,
    })
    local AutoLight = configSettings:WaitForChild("AutoLight")
    local Paragraph = PlayerTab:CreateParagraph({Title = "Auto", Content = "Automatics scripts"})
    local connection
    local Toggle = PlayerTab:CreateToggle({
        Name = "Auto Light",
        CurrentValue = AutoLight.Value,
        Flag = "Toggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
            local db = false
            if value then
                AutoLight.Value = true
                local remotes = game.ReplicatedStorage.Remotes
                local fuseBox = game.workspace.FuseBox
                if fuseBox.Status.Open then
                    for _,fios in ipairs(fuseBox.Wires:GetChildren()) do 
                        if fios:IsA("BasePart") and fios.Highlight:IsA("Highlight") then
                            connection = fios.Highlight:GetPropertyChangedSignal("Enabled"):Connect(function()
                                if fios.Highlight.Enabled == true then
                                    if db then return end
                                    db = true
                                    remotes.ClickWire:FireServer(fios)
                                    wait(.2)
                                    db = false
                                end    
                            end)
                            if fios.Highlight.Enabled == true then
                                remotes.ClickWire:FireServer(fios)
                            end
                        end
                    end
                end
            else
                AutoLight.Value = false
                connection:Disconnect()
            end
        end,
    })
    local AutoScare = configSettings:WaitForChild("AutoScare")
    local Toggle = PlayerTab:CreateToggle({
        Name = "Auto Scare (Don't Press Esc/Roblox Menu)",
        CurrentValue = AutoScare.Value,
        Flag = "Toggle6",
        Callback = function(value)
            local player = game.Players.LocalPlayer
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local windowsFolder = workspace:WaitForChild("Windows")
            local lightsFolder = workspace:WaitForChild("Lights")

            local PosTab = {
                ["LivingRoom"] = Vector3.new(-24, 7, -53),
                ["BottomCorridor"] = Vector3.new(-24, 7, -84),
                ["Entrance"] = Vector3.new(-7, 7, -36),
                ["Ladder"] = Vector3.new(-1, 7, -62),
                ["TopCorridor"] = Vector3.new(-8, 23, -76),
                ["TopCorridor2"] = Vector3.new(-28, 23, -41),
                ["Bathroom"] = Vector3.new(-29, 23, -48),
                ["Bedroom"] = Vector3.new(-16, 23, -75),
            }

            -- encerra o sistema anterior
            if Toggle._workspaceConnection then
                Toggle._workspaceConnection:Disconnect()
                Toggle._workspaceConnection = nil
            end
            Toggle._stop = true
            task.wait(0.2)
            Toggle._stop = false

            if value == true then
                AutoScare.Value = true
                print("[Auto Scare] ✅ Ativado")

                local db = false

                Toggle._workspaceConnection = workspace.ChildAdded:Connect(function(child)
                    if Toggle._stop or child.Name ~= "Mutant" then return end
                    task.wait(0.5)
                    if db or Toggle._stop then return end

                    local larryModel = child
                    if not larryModel.PrimaryPart then return end

                    local config = larryModel:FindFirstChild("Config")
                    local wandering = config and config:FindFirstChild("Wandering")
                    if not wandering or wandering.Value ~= false then return end

                    for _, window in ipairs(windowsFolder:GetChildren()) do
                        if Toggle._stop then return end
                        local part = window:FindFirstChildWhichIsA("BasePart")
                        if not part then continue end

                        local dist = (larryModel.PrimaryPart.Position - part.Position).Magnitude
                        if dist >= 12 then continue end

                        local roomName = window.RoomName.Value
                        for _, light in ipairs(lightsFolder:GetChildren()) do
                            if Toggle._stop then return end
                            if roomName ~= light.Status.RoomName.Value then continue end

                            local cd = light.Switch.Detector:FindFirstChildOfClass("ClickDetector")
                            if not cd then continue end

                            db = true
                            local success, err = pcall(function()
                                local char = player.Character
                                if not char then return end
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if not hrp then
                                    char:WaitForChild("HumanoidRootPart", 3)
                                    hrp = char:FindFirstChild("HumanoidRootPart")
                                end
                                if not hrp then return end

                                local plrPos = hrp.Position
                                local targetPos = PosTab[roomName]

                                -- teleportar até a sala
                                task.wait(0.3)
                                if targetPos then
                                    print("[Auto Scare] Indo para:", roomName)
                                    hrp.CFrame = CFrame.new(targetPos)
                                    task.wait(0.25)
                                end

                                local bulb = light.Lamp.Bulb.Attachment:FindFirstChildOfClass("PointLight")
                                if not bulb then return end

                                local initialState = bulb.Enabled
                                local success = false
                                local attempts = 0
                                local maxAttempts = 10

                                -- 🔸 Clique duplo exato (2 cliques) com delay de 0.5s entre eles
                                while attempts < maxAttempts and not success do
                                    if Toggle._stop or not AutoScare.Value then return end

                                    print("[Auto Scare] Tentando clique duplo (tentativa " .. (attempts + 1) .. ")")

                                    -- Primeiro clique
                                    fireclickdetector(cd)
                                    task.wait(0.7) -- espera meio segundo
                                    if bulb.Enabled ~= initialState then
                                        success = true
                                        fireclickdetector(cd)
                                        print("[Auto Scare] ✅ Luz mudou após clique duplo.")
                                    else
                                        attempts += 1
                                    end
                                end

                                if not success then
                                    print("[Auto Scare] ⚠️ Nenhuma mudança após todas as tentativas.")
                                end

                                -- Retorna o jogador à posição original
                                if char and char:FindFirstChild("HumanoidRootPart") then
                                    task.wait(0.2)
                                    char:MoveTo(plrPos)
                                end
                            end)

                            if not success then
                                warn("[Auto Scare] Erro ao executar:", err)
                            end

                            db = false
                        end
                    end
                end)

                -- loop de segurança
                task.spawn(function()
                    while AutoScare.Value and not Toggle._stop do
                        task.wait(1)
                    end
                    print("[Auto Scare] ⛔ Desativado (loop finalizado)")
                end)

            else
                print("[Auto Scare] ⛔ Desativando...")
                AutoScare.Value = false
                Toggle._stop = true

                if Toggle._workspaceConnection then
                    Toggle._workspaceConnection:Disconnect()
                    Toggle._workspaceConnection = nil
                end

                task.delay(1, function()
                    Toggle._stop = false
                    print("[Auto Scare] 🔕 Sistema realmente parado.")
                end)
            end
        end,
    })
    
    local Toggle = PlayerTab:CreateButton({
        Name = "Refil Generator",
        Callback = function(value)
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRoot = character:WaitForChild("HumanoidRootPart")

            local Shack = workspace:WaitForChild("Shack")
            local JerryCan = Shack:WaitForChild("JerryCan")
            local Generator = Shack:WaitForChild("Generator")
            local fuelValue = Generator:WaitForChild("Fuel")
            local originalPos = humanoidRoot.Position

            player.Character:MoveTo(PosTab.Generator)
            fireclickdetector(JerryCan:WaitForChild("ClickDetector"))
            task.wait(1)
            fireclickdetector(Generator:WaitForChild("ClickDetector"))
            player.Character:MoveTo(originalPos)
        end,
    })
    if game.workspace.Halloween then
        local Paragraph = PlayerTab:CreateParagraph({Title = "Halloween", Content = "This only appears in Halloween Event or Halloween + Bloodmoon "})
        for i,RNGPumpkins in ipairs(game.workspace.Halloween.Pumpkins:GetChildren()) do
            RNGPumpkins.Name = "Pumpkin_"..i
        end
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 1",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_1.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 2",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_2.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 3",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_3.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 4",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_4.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 5",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_5.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 6",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_6.Spot.Position) 
        end,
        })
    end
 end
 if gameState:FindFirstChild("Repairing") then
    local PosTab = {
        ["PowerGenerator"] = Vector3.new(-266, 82, 98),
        ["RadioEnergy"] = Vector3.new(-430, 153, -16),
        ["Worker"] = Vector3.new(-324, 82, 95),
        ["Shop"] = Vector3.new(-284, 82, 13),
        ["Entrance"] = Vector3.new(-228, 82, 64),
        ["Minigame1"] = Vector3.new(-251, 82, 21),
        ["Minigame2"] = Vector3.new(-233, 82, -1),
        ["Minigame3"] = Vector3.new(-336, 82, -70),
    }
    local PlayerTab = Window:CreateTab("Night 2") -- Title, Image
    local Paragraph = PlayerTab:CreateParagraph({Title = "Night", Content = "Night 2 scripts"})
    local Highlight = configSettings:WaitForChild("HighlightLarryNight2")
    local Toggle = PlayerTab:CreateToggle({
        Name = "Larry HighLight",
        CurrentValue = Highlight.Value,
        Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
                Highlight.Value = true
                local highlight = Instance.new("Highlight")
                if game.workspace:FindFirstChild("Mutant") then
                    highlight.Parent = game.workspace:FindFirstChild("Mutant")
                    if game.workspace:FindFirstChild("Mutant") then 
                        Rayfield:Notify({
                            Title = "Larry Notification",
                            Content = "Larry In Factory",
                            Duration = 6.5,
                        })
                    end
                else
                    highlight.Parent = game.ReplicatedStorage:FindFirstChild("Mutant")
                end
            else
                Highlight.Value = false
                if game.ReplicatedStorage:FindFirstChild("Mutant") then
                    game.ReplicatedStorage:FindFirstChild("Mutant").Highlight:Destroy()       
                elseif game.workspace:FindFirstChild("Mutant") then
                    game.workspace:FindFirstChild("Mutant").Highlight:Destroy()
                end
            end
        end,
    })
    local Highlight = configSettings:WaitForChild("HighlightStalker")
    local Toggle = PlayerTab:CreateToggle({
        Name = "Stalker HighLight",
        CurrentValue = Highlight.Value,
        Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
                Highlight.Value = true
                local highlight = Instance.new("Highlight")
                if game.workspace:FindFirstChild("Stalker") then
                    highlight.Parent = game.workspace:FindFirstChild("Stalker")
                    if game.workspace:FindFirstChild("Stalker") then 
                        Rayfield:Notify({
                            Title = "Larry Notification",
                            Content = "Larry In House/Outside",
                            Duration = 6.5,
                        })
                    end
                else
                    highlight.Parent = game.ReplicatedStorage:FindFirstChild("Stalker")
                end
            else
                Highlight.Value = false
                if game.ReplicatedStorage:FindFirstChild("Stalker").Highlight then
                    game.ReplicatedStorage:FindFirstChild("Stalker").Highlight:Destroy()       
                elseif game.workspace:FindFirstChild("Stalker").Highlight then
                    game.workspace:FindFirstChild("Stalker").Highlight:Destroy()
                else
                    error("CABEÇA DO WORKER NAO ENCONTRADO")
                end
            end
        end,
    })

    if game.workspace.Halloween then
        local Paragraph = PlayerTab:CreateParagraph({Title = "Halloween", Content = "This only appears in Halloween Event or Halloween + Bloodmoon "})
        for i,RNGPumpkins in ipairs(game.workspace.Halloween.Pumpkins:GetChildren()) do
            RNGPumpkins.Name = "Pumpkin_"..i
        end
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 1",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_1.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 2",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_2.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 3",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_3.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 4",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_4.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 5",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_5.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 6",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_6.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 7",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_7.Spot.Position) 
        end,
        })
    end
 end
 if noite and noite.Value == 3 or gameState:FindFirstChild("Ecologist") then
    local PosTab = {
        ["RightAmmoPile1"] = Vector3.new(-7, 4, -151),
        ["RightAmmoPile4"] = Vector3.new(-45, 4, -69),
        ["LeftAmmoPile1"] = Vector3.new(92, 4, 179),
        ["LeftAmmoPile2"] = Vector3.new(48, 4, 279),
        ["Cabin1"] = Vector3.new(101, 4, -227),
        ["Cabin2"] = Vector3.new(-18, 4, 67),
        ["Cabin3"] = Vector3.new(-58, 4, 267),
        ["Cabin4"] = Vector3.new(231, 4, 226),
        ["Lodge"] = Vector3.new(-228, 17, 50),
    }
    local PlayerTab = Window:CreateTab("Night 3") -- Title, Image.
    local Paragraph = PlayerTab:CreateParagraph({Title = "Night", Content = "Night 3 scripts"})
    local Highlight = configSettings:WaitForChild("HighlightWorker")
    local Toggle = PlayerTab:CreateToggle({
        Name = "Worker/Mutant HighLight",
        CurrentValue = Highlight.Value,
        Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
                Highlight.Value = true
                local highlight = Instance.new("Highlight")
                if game.workspace:FindFirstChild("Mutant") then
                    highlight.Parent = game.workspace.Mutant
                    Rayfield:Notify({
                        Title = "Mutant Notification",
                        Content = "Mutant Spawned",
                        Duration = 6.5,
                    })
                else
                    highlight.Parent = game.ReplicatedStorage:FindFirstChild("Mutant") 
                end
            else
                Highlight.Value = false
                if game.ReplicatedStorage:FindFirstChild("Mutant") and game.ReplicatedStorage.Mutant:FindFirstChild("Highlight") then
                    game.ReplicatedStorage:FindFirstChild("Mutant").Highlight:Destroy()       
                elseif game.workspace:FindFirstChild("Mutant") and game.workspace.Mutant:FindFirstChild("Highlight") then
                    game.workspace:FindFirstChild("Mutant").Highlight:Destroy()
                end
            end
        end,
    })
    local Highlight = configSettings:WaitForChild("HighlightWorkerHead")
    local Toggle = PlayerTab:CreateToggle({
        Name = "Worker/Mutant Head/Spider HighLight",
        CurrentValue = Highlight.Value,
        Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
                Highlight.Value = true
                local highlight = Instance.new("Highlight")
                if game.workspace:FindFirstChild("WorkerHead")  then
                    highlight.Parent = game.workspace.WorkerHead
                    Rayfield:Notify({
                        Title = "Spider Notification",
                        Content = "Spider Spawned",
                        Duration = 6.5,
                    })
                else
                    highlight.Parent = game.ReplicatedStorage:FindFirstChild("WorkerHead")
                end
            else
                Highlight.Value = false
                if game.ReplicatedStorage:FindFirstChild("WorkerHead") and game.ReplicatedStorage.WorkerHead:FindFirstChild("Highlight") then
                    game.ReplicatedStorage:FindFirstChild("WorkerHead").Highlight:Destroy()       
                elseif game.workspace:FindFirstChild("WorkerHead") and game.workspace.WorkerHead:FindFirstChild("Highlight") then
                    game.workspace:FindFirstChild("WorkerHead").Highlight:Destroy()
                else
                    error("CABEÇA DO WORKER NAO ENCONTRADO")
                end
            end
        end,
    })
    local Button = PlayerTab:CreateButton({
        Name = "Get Ammo",
        Callback = function()
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local Shotgun = char:FindFirstChild("Shotgun") or player.Backpack:FindFirstChild("Shotgun")

            if not Shotgun then
                warn("Nenhuma shotgun encontrada.")
                return
            end

            local AmmoPile
            for _, A in ipairs(workspace.AmmoPiles:GetChildren()) do
                if A and A:FindFirstChild("Detector") and A.Detector:FindFirstChild("ClickDetector") then
                    AmmoPile = A
                    break
                end
            end

            if AmmoPile and AmmoPile:FindFirstChild("Detector") and AmmoPile.Detector:FindFirstChild("ClickDetector") then
                local originalPos = root.Position
                local detector = AmmoPile.Detector
                local click = detector.ClickDetector

                -- Move o jogador até o detector
                root.CFrame = CFrame.new(detector.Position + Vector3.new(0, 2, 0))
                task.wait(0.2)

                -- 🔁 Tenta clicar várias vezes até funcionar ou atingir o limite
                local success = false
                for attempt = 1, 5 do
                    fireclickdetector(click)
                    task.wait(0.3)

                    if Shotgun:FindFirstChild("Ammo") and Shotgun.Ammo.Value >= 2 then
                        success = true
                        break
                    end
                end

                if not success then
                    warn("Não foi possível recarregar após várias tentativas.")
                end

                -- Volta o jogador pra posição original
                root.CFrame = CFrame.new(originalPos)
            else
                warn("Nenhuma pilha de munição encontrada.")
            end
        end,
    })

    if game.workspace.Halloween then
        local Paragraph = PlayerTab:CreateParagraph({Title = "Halloween", Content = "This only appears in Halloween Event or Halloween + Bloodmoon "})
        for i,RNGPumpkins in ipairs(game.workspace.Halloween.Pumpkins:GetChildren()) do
            RNGPumpkins.Name = "Pumpkin_"..i
        end
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 1",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_1.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 2",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_2.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 3",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_3.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 4",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_4.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 5",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_5.Spot.Position) 
        end,
        })
        local Button = PlayerTab:CreateButton({
        Name = "Tp Pumpkin 6",
        Callback = function()
            game.Players.LocalPlayer.Character:MoveTo(game.workspace.Halloween.Pumpkins.Pumpkin_6.Spot.Position) 
        end,
        })
    end
 end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Residence Massacre ULTIMATE Hub (BETA)",
    LoadingTitle = "RMUH v0.1",
    LoadingSubtitle = "by you don't need know",

    TextColor = Color3.fromRGB(255, 0, 0),
 })

 local PlayerTab = Window:CreateTab("Others") -- Title, Image

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

 local Toggle = PlayerTab:CreateToggle({
   Name = "Classic Camera Mode",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(value)
        if value == true then
            local player = game.Players.LocalPlayer
            local camera = workspace.CurrentCamera

            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMinZoomDistance = 0.5
            player.CameraMaxZoomDistance = 128
        else
            local player = game.Players.LocalPlayer
            local camera = workspace.CurrentCamera

            player.CameraMode = Enum.CameraMode.LockFirstPerson
            player.CameraMinZoomDistance = 0
            player.CameraMaxZoomDistance = 0
        end
   end, 
 })

local gameState = game.ReplicatedStorage:WaitForChild("GameState")

local blizzard = gameState:FindFirstChild("Blizzard")
local infinite = gameState:FindFirstChild("Infinite")

if (blizzard and blizzard.Value) or (infinite and infinite.Value) then
    local Toggle = PlayerTab:CreateToggle({
    Name = "Ant-Frosted",
    CurrentValue = false,
    Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(value)
        if value == true then
            game.Players.LocalPlayer.Character.Temperature.Disabled = true
            if game.Players.LocalPlayer.Character.Temperature.Disabled == false then 
                game.Players.LocalPlayer.Character.Temperature.Disabled = true
            end
        else
            game.Players.LocalPlayer.Character.Temperature.Disabled = false
            if game.Players.LocalPlayer.Character.Temperature.Disabled == true then 
                game.Players.LocalPlayer.Character.Temperature.Disabled = false
            end
        end
    end,
    })
end

 local Toggle = PlayerTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = false,
   Flag = "Toggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(value)
        if value == true then
            game.Players.LocalPlayer.Character.Sprint.Overdrive.Value = 99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
        else
            game.Players.LocalPlayer.Character.Sprint.Overdrive.Value = 0
        end
   end,
 })

  local Toggle = PlayerTab:CreateToggle({
   Name = "Full Bright (bug timer)",
   CurrentValue = false,
   Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(value)
        if value == true then
            _G.FullBrightExecuted = true
            _G.FullBrightEnabled = true

            local lighting = game:GetService("Lighting")

            -- Salva a iluminação original
            local originalBrightness = lighting.Brightness
            local originalClockTime = lighting.ClockTime
            local originalFogEnd = lighting.FogEnd
            local originalAmbient = lighting.Ambient
            local originalOutdoorAmbient = lighting.OutdoorAmbient

            -- Cria uma coroutine pra monitorar
            task.spawn(function()
                while task.wait(0.1) do
                    if _G.FullBrightEnabled then
                        lighting.Brightness = 2
                        lighting.ClockTime = 12
                        lighting.FogEnd = 1e10
                        lighting.Ambient = Color3.new(1, 1, 1)
                        lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                    else
                        -- Restaura iluminação original
                        lighting.Brightness = originalBrightness
                        lighting.ClockTime = originalClockTime
                        lighting.FogEnd = originalFogEnd
                        lighting.Ambient = originalAmbient
                        lighting.OutdoorAmbient = originalOutdoorAmbient
                    end
                end
            end)
        else
            _G.FullBrightEnabled = false
        end
   end,
 })

local noite = gameState:FindFirstChild("Night")
if noite and noite.Value == 1 and not gameState:FindFirstChild("Repairing") then
    local larry = game.ReplicatedStorage:FindFirstChild("Mutant") or game.workspace:FindFirstChild("Mutant")
    local PlayerTab = Window:CreateTab("Night 1") -- Title, Image
    local Toggle = PlayerTab:CreateToggle({
        Name = "Highlight Larry",
        CurrentValue = false,
        Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
            if value then
                for _,MutantParts in ipairs(larry:GetChildren()) do
                    if MutantParts:IsA("BasePart") then
                        Instance.new("Highlight").Parent = MutantParts
                    end
                end
            else
               for _,MutantParts in ipairs(larry:GetChildren()) do
                    if MutantParts:IsA("BasePart") and MutantParts:FindFirstChild("Highlight") then
                        MutantParts.Highlight:Destroy()
                    end
                end
            end
        end,
    })
    local connection
    local Toggle = PlayerTab:CreateToggle({
        Name = "Auto Night (Need start the night)",
        CurrentValue = false,
        Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
                local RunService = game:GetService("RunService")
                local player = game.Players.LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")

                local windowsFolder = workspace:WaitForChild("Windows")
                local lightsFolder = workspace:WaitForChild("Lights")

                local checkInterval = 0.1

                local function checkLarryTouch()
                    for _, larryPart in ipairs(larry:GetDescendants()) do
                        if larryPart:IsA("BasePart") then
                            for _, touching in ipairs(larryPart:GetTouchingParts()) do
                                local window = touching.Parent
                                if window and window:IsDescendantOf(windowsFolder) and window:FindFirstChild("RoomName") then
                                    for _, light in ipairs(lightsFolder:GetChildren()) do
                                        if light:FindFirstChild("Status") and light.Status:FindFirstChild("RoomName") then
                                            if window.RoomName.Value == light.Status.RoomName.Value then
                                                local detector = light:FindFirstChild("Switch") and light.Switch:FindFirstChild("Detector")
                                                if detector and detector:FindFirstChild("ClickDetector") then
                                                    print("[CLIENT] Larry tocou na janela e ativou: " .. light.Name)
                                                    detector.ClickDetector:fireclickdetector(game.Players.LocalPlayer)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                connection = task.spawn(function()
                    while task.wait(checkInterval) do
                        checkLarryTouch()
                    end
                end)
            else
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end,
    })  
    if game.workspace.Halloween then
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
    local PlayerTab = Window:CreateTab("Night 2") -- Title, Image

    local Toggle = PlayerTab:CreateToggle({
        Name = "Larry HighLight",
        CurrentValue = false,
        Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
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
                if game.ReplicatedStorage:FindFirstChild("Mutant") then
                    game.ReplicatedStorage:FindFirstChild("Mutant").Highlight:Destroy()       
                elseif game.workspace:FindFirstChild("Mutant") then
                    game.workspace:FindFirstChild("Mutant").Highlight:Destroy()
                end
            end
        end,
    })
    local Toggle = PlayerTab:CreateToggle({
        Name = "Stalker HighLight",
        CurrentValue = false,
        Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
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
    local PlayerTab = Window:CreateTab("Night 3") -- Title, Image.

    local Toggle = PlayerTab:CreateToggle({
        Name = "Worker/Mutant HighLight",
        CurrentValue = false,
        Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
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
                if game.ReplicatedStorage:FindFirstChild("Mutant") and game.ReplicatedStorage.Mutant:FindFirstChild("Highlight") then
                    game.ReplicatedStorage:FindFirstChild("Mutant").Highlight:Destroy()       
                elseif game.workspace:FindFirstChild("Mutant") and game.workspace.Mutant:FindFirstChild("Highlight") then
                    game.workspace:FindFirstChild("Mutant").Highlight:Destroy()
                end
            end
        end,
    })
    local Toggle = PlayerTab:CreateToggle({
        Name = "Worker/Mutant Head/Spider HighLight",
        CurrentValue = false,
        Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(value)
        if value == true then
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

    if game.workspace.Halloween then
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

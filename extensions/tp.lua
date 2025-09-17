return function(Window)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("⚡ Teleport", 4483362458)

    local PlayerList = {}
    local SelectedPlayer = ""
    local ModeTP = "Devant"
    local Dropdown
    local AutoTP = false
    local AutoTPConnection

    local function updateDropdown()
        PlayerList = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(PlayerList, p.Name)
            end
        end
        if Dropdown then
            Dropdown:SetOptions(PlayerList)
            -- Si joueur sélectionné n'existe plus, reset à premier joueur
            if not table.find(PlayerList, SelectedPlayer) then
                SelectedPlayer = PlayerList[1] or ""
                Dropdown:SetValue(SelectedPlayer)
            end
        end
    end

    local function findPlayerByName(name)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == name then
                return p
            end
        end
        return nil
    end

    local function doTeleport(target, mode)
        if not (target and target.Character) then return end
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        local pos = hrp.Position
        if mode == "Devant" then
            local look = hrp.CFrame.LookVector
            pos = pos + (look * 5)
        elseif mode == "Derrière" then
            local look = hrp.CFrame.LookVector
            pos = pos - (look * 5)
        elseif mode == "Au-dessus" then
            pos = pos + Vector3.new(0, 5, 0)
        end

        myHrp.CFrame = CFrame.new(pos)
    end

    -- Création du dropdown pour sélectionner le joueur
    updateDropdown() -- initialisation PlayerList avant création dropdown

    Dropdown = Tab:CreateDropdown({
        Name = "Choisir un joueur",
        Options = PlayerList,
        CurrentOption = SelectedPlayer,
        Callback = function(selected)
            SelectedPlayer = selected
        end,
    })

    -- Dropdown pour mode TP
    Tab:CreateDropdown({
        Name = "Mode TP",
        Options = {"Devant", "Derrière", "Au-dessus"},
        CurrentOption = ModeTP,
        Callback = function(mode)
            ModeTP = mode
        end,
    })

    -- Bouton pour TP une fois
    Tab:CreateButton({
        Name = "TP sur joueur",
        Callback = function()
            if SelectedPlayer == "" then return end
            local target = findPlayerByName(SelectedPlayer)
            if target then
                doTeleport(target, ModeTP)
            end
        end,
    })

    -- Toggle Auto TP
    Tab:CreateToggle({
        Name = "Auto TP (toutes les 10ms)",
        CurrentValue = false,
        Callback = function(value)
            AutoTP = value
            if AutoTP then
                -- Connexion répétée
                AutoTPConnection = RunService.Heartbeat:Connect(function(deltaTime)
                    if SelectedPlayer == "" then return end
                    local target = findPlayerByName(SelectedPlayer)
                    if target then
                        doTeleport(target, ModeTP)
                    end
                end)
            else
                -- Déconnexion
                if AutoTPConnection then
                    AutoTPConnection:Disconnect()
                    AutoTPConnection = nil
                end
            end
        end,
    })

    Players.PlayerAdded:Connect(updateDropdown)
    Players.PlayerRemoving:Connect(updateDropdown)
end

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
            if not table.find(PlayerList, SelectedPlayer) then
                SelectedPlayer = PlayerList[1] or ""
                Dropdown:SetValue(SelectedPlayer)
            end
        end
        print("[UpdateDropdown] Joueurs:", table.concat(PlayerList, ", "))
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
        print("[doTeleport] Tentative de TP vers:", target.Name, "Mode:", mode)
        if not (target and target.Character) then
            print("[doTeleport] Cible ou personnage invalide")
            return
        end

        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            print("[doTeleport] HumanoidRootPart cible introuvable")
            return
        end

        local myChar = LocalPlayer.Character
        if not myChar then
            print("[doTeleport] Ton personnage local n'est pas chargé")
            return
        end

        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then
            print("[doTeleport] Ton HumanoidRootPart introuvable")
            return
        end

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
        print("[doTeleport] TP effectué vers", target.Name, "à la position", pos)
    end

    updateDropdown()

    Dropdown = Tab:CreateDropdown({
        Name = "Choisir un joueur",
        Options = PlayerList,
        CurrentOption = SelectedPlayer,
        Callback = function(selected)
            SelectedPlayer = selected
            print("[Dropdown] Joueur sélectionné:", SelectedPlayer)
        end,
    })

    Tab:CreateDropdown({
        Name = "Mode TP",
        Options = {"Devant", "Derrière", "Au-dessus"},
        CurrentOption = ModeTP,
        Callback = function(mode)
            ModeTP = mode
            print("[ModeTP] Mode TP sélectionné:", ModeTP)
        end,
    })

    Tab:CreateButton({
        Name = "TP sur joueur",
        Callback = function()
            print("[Button] TP sur joueur cliqué")
            if SelectedPlayer == "" then
                print("[Button] Aucun joueur sélectionné")
                return
            end
            local target = findPlayerByName(SelectedPlayer)
            if target then
                doTeleport(target, ModeTP)
            else
                print("[Button] Joueur cible non trouvé")
            end
        end,
    })

    Tab:CreateToggle({
        Name = "Auto TP (toutes les 10ms)",
        CurrentValue = false,
        Callback = function(value)
            AutoTP = value
            if AutoTP then
                print("[AutoTP] Activation")
                AutoTPConnection = RunService.Heartbeat:Connect(function()
                    if SelectedPlayer == "" then return end
                    local target = findPlayerByName(SelectedPlayer)
                    if target then
                        doTeleport(target, ModeTP)
                    end
                end)
            else
                print("[AutoTP] Désactivation")
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

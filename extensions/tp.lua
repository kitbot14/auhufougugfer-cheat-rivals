return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("⚡ Teleport", 4483362458)

    local PlayerList = {}
    local SelectedPlayer = nil
    local ModeTP = "Devant"
    local Dropdown

    local function updateDropdown()
        PlayerList = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(PlayerList, p.Name)
            end
        end

        if Dropdown then
            Dropdown:SetOptions(PlayerList)
            -- Si l'ancien joueur sélectionné est plus là, on reset
            if SelectedPlayer == nil or not table.find(PlayerList, SelectedPlayer) then
                SelectedPlayer = PlayerList[1] or nil
                if SelectedPlayer then
                    Dropdown:SetValue(SelectedPlayer)
                end
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

    -- Remplir PlayerList AVANT de créer le dropdown
    updateDropdown()

    Dropdown = Tab:CreateDropdown({
        Name = "Choisir un joueur",
        Options = PlayerList,
        CurrentOption = SelectedPlayer or (PlayerList[1] or ""),
        Callback = function(selected)
            SelectedPlayer = selected
        end,
    })

    Tab:CreateDropdown({
        Name = "Mode TP",
        Options = {"Devant", "Derrière", "Au-dessus"},
        CurrentOption = ModeTP,
        Callback = function(mode)
            ModeTP = mode
        end,
    })

    Tab:CreateButton({
        Name = "TP sur joueur",
        Callback = function()
            if not SelectedPlayer or SelectedPlayer == "" then return end
            local target = findPlayerByName(SelectedPlayer)
            if target then
                doTeleport(target, ModeTP)
            end
        end,
    })

    Players.PlayerAdded:Connect(updateDropdown)
    Players.PlayerRemoving:Connect(updateDropdown)
end

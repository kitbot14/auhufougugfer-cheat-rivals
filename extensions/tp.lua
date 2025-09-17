return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("⚡ Teleport", 4483362458)

    local PlayerList = {}
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
        end
    end

    -- Callback pour teleport
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
            -- devant : devant (face à lui) => on utilise sa CFrame lookVector
            local look = hrp.CFrame.LookVector
            pos = pos + (look * 5) -- 5 studs devant
        elseif mode == "Derrière" then
            local look = hrp.CFrame.LookVector
            pos = pos - (look * 5) -- 5 studs derrière
        elseif mode == "Au-dessus" then
            pos = pos + Vector3.new(0, 5, 0) -- 5 studs au dessus
        end

        -- téléportation
        myHrp.CFrame = CFrame.new(pos)
    end

    Dropdown = Tab:CreateDropdown({
        Name = "Choisir un joueur",
        Options = PlayerList,
        CurrentOption = "",
        Callback = function(selected)
            -- ne fait rien, juste sélectionner
        end,
    })

    Tab:CreateDropdown({
        Name = "Mode TP",
        Options = {"Devant", "Derrière", "Au-dessus"},
        CurrentOption = "Devant",
        Callback = function(mode)
            Tab.ModeTP = mode
        end,
    })

    Tab:CreateButton({
        Name = "TP sur joueur",
        Callback = function()
            local sel = Dropdown.CurrentOption or ""
            if sel == "" then return end
            local target = Players:FindFirstChild(sel)
            if target then
                doTeleport(target, Tab.ModeTP or "Devant")
            end
        end,
    })

    updateDropdown()
    Players.PlayerAdded:Connect(updateDropdown)
    Players.PlayerRemoving:Connect(updateDropdown)
end

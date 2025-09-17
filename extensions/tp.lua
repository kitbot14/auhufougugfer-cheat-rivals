return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("⚡ Teleport", 4483362458)

    local PlayerList = {} -- Liste des noms de joueurs
    local Dropdown -- On déclare le dropdown avant pour y accéder après

    -- Fonction de mise à jour des joueurs
    local function updateDropdown()
        PlayerList = {}

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(PlayerList, p.Name)
            end
        end

        -- Assure que dropdown existe avant de modifier
        if Dropdown then
            Dropdown:SetOptions(PlayerList)
        end
    end

    -- Créer le dropdown après avoir défini la fonction de mise à jour
    Dropdown = Tab:CreateDropdown({
        Name = "Choisir un joueur",
        Options = PlayerList,
        CurrentOption = "",
        Callback = function(selected)
            local target = Players:FindFirstChild(selected)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2)
                end
            end
        end,
    })

    -- Mettre à jour la liste maintenant et à chaque changement
    updateDropdown()
    Players.PlayerAdded:Connect(updateDropdown)
    Players.PlayerRemoving:Connect(updateDropdown)
end

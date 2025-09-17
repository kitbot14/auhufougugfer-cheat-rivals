return function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("⚡ Teleport", 4483362458)

    local dropdown = Tab:CreateDropdown({
        Name = "Choisir un joueur",
        Options = {},
        CurrentOption = "",
        Callback = function(selected)
            local target = Players:FindFirstChild(selected)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
            end
        end,
    })

    -- Remplir la liste des joueurs
    local function updateDropdown()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        dropdown:SetOptions(names)
    end

    updateDropdown()
    Players.PlayerAdded:Connect(updateDropdown)
    Players.PlayerRemoving:Connect(updateDropdown)
end

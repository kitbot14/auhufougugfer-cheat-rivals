return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("🦘 Jump Boost", 4483362458)

    local JumpValue = 50 -- valeur par défaut

    local function applyJumpPower(power)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = power
            end
        end
    end

    Tab:CreateSlider({
        Name = "Puissance du saut",
        Range = {50, 300},
        Increment = 10,
        Suffix = " Power",
        CurrentValue = JumpValue,
        Callback = function(Value)
            JumpValue = Value
            applyJumpPower(JumpValue)
        end,
    })

    -- Appliquer la valeur au chargement du personnage (respawn)
    LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.JumpPower = JumpValue
        end
    end)

    -- Appliquer immédiatement au lancement du script si personnage déjà chargé
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        applyJumpPower(JumpValue)
    end
end

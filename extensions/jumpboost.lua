return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("🦘 Jump Boost", 4483362458)

    local JumpValue = 50 -- Valeur par défaut

    -- 🧠 Fonction pour appliquer la puissance de saut
    local function applyJumpPower(power)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = power
        end
    end

    -- 🕹️ Slider dans le menu
    Tab:CreateSlider({
        Name = "Puissance du saut",
        Range = {50, 300},
        Increment = 10,
        Suffix = "Power",
        CurrentValue = JumpValue,
        Callback = function(Value)
            JumpValue = Value
            applyJumpPower(JumpValue)
        end,
    })

    -- 🔁 Appliquer automatiquement après un reset
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applyJumpPower(JumpValue)
    end)
end

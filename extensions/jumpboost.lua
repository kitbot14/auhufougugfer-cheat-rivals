return function()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Tab = Window:CreateTab("🦘 Jump Boost", 4483362458)

    Tab:CreateSlider({
        Name = "Puissance du saut",
        Range = {50, 300},
        Increment = 10,
        Suffix = "Power",
        CurrentValue = 50,
        Callback = function(Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
            end
        end,
    })
end

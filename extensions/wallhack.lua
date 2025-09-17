return function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local enabled = false

    local Tab = Window:CreateTab("🧱 WallHack", 4483362458)

    Tab:CreateToggle({
        Name = "Activer Wallhack (Highlight)",
        CurrentValue = false,
        Callback = function(Value)
            enabled = Value

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = player.Character:FindFirstChildOfClass("Highlight")
                    if Value and not highlight then
                        highlight = Instance.new("Highlight", player.Character)
                        highlight.FillColor = Color3.new(1, 0, 0)
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                    elseif not Value and highlight then
                        highlight:Destroy()
                    end
                end
            end
        end,
    })
end

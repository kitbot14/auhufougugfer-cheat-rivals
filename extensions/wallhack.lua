return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local enabled = false

    local Tab = Window:CreateTab("🧱 WallHack", 4483362458)

    -- Fonction pour appliquer ou retirer les highlights
    local function updateHighlights()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if enabled and not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Name = "WallHackHighlight"
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                elseif not enabled and highlight then
                    highlight:Destroy()
                end
            end
        end
    end

    -- Toggle Rayfield
    Tab:CreateToggle({
        Name = "Activer Wallhack (Highlight)",
        CurrentValue = false,
        Callback = function(Value)
            enabled = Value
            updateHighlights()
        end,
    })

    -- Réappliquer si un joueur rejoint ou respawn
    local function handleCharacterAdded(player, character)
        if enabled then
            task.wait(1) -- attendre un peu que le personnage charge
            updateHighlights()
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            handleCharacterAdded(player, char)
        end)
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(char)
                handleCharacterAdded(player, char)
            end)
        end
    end
end
return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local enabled = false

    local Tab = Window:CreateTab("🧱 WallHack", 4483362458)

    -- Fonction pour appliquer ou retirer les highlights
    local function updateHighlights()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if enabled and not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Name = "WallHackHighlight"
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                elseif not enabled and highlight then
                    highlight:Destroy()
                end
            end
        end
    end

    -- Toggle Rayfield
    Tab:CreateToggle({
        Name = "Activer Wallhack (Highlight)",
        CurrentValue = false,
        Callback = function(Value)
            enabled = Value
            updateHighlights()
        end,
    })

    -- Réappliquer si un joueur rejoint ou respawn
    local function handleCharacterAdded(player, character)
        if enabled then
            task.wait(1) -- attendre un peu que le personnage charge
            updateHighlights()
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            handleCharacterAdded(player, char)
        end)
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(char)
                handleCharacterAdded(player, char)
            end)
        end
    end
end

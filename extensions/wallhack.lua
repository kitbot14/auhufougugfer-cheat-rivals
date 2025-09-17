return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local enabled = false

    local Tab = Window:CreateTab("🧱 WallHack", 4483362458)

    local highlights = {} -- table pour garder trace des highlights pour chaque joueur

    local function addHighlight(player)
        if player.Character then
            local part = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChildWhichIsA("BasePart")
            if part then
                -- s'il n'y en a pas déjà pour ce joueur
                if not highlights[player] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = player.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = player.Character
                    highlights[player] = hl
                end
            end
        end
    end

    local function removeHighlight(player)
        local hl = highlights[player]
        if hl then
            hl:Destroy()
            highlights[player] = nil
        end
    end

    local function updateAll()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if enabled then
                    addHighlight(player)
                else
                    removeHighlight(player)
                end
            end
        end
    end

    Tab:CreateToggle({
        Name = "Activer Wallhack",
        CurrentValue = false,
        Callback = function(Value)
            enabled = Value
            updateAll()
        end,
    })

    -- Players qui rejoignent ou reset
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            if enabled then
                -- petit délai pour que le personnage charge
                task.wait(1)
                addHighlight(p)
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(p)
        removeHighlight(p)
    end)

    -- Si déjà présents
    for _, p in ipairs(Players:GetPlayers()) do
        p.CharacterAdded:Connect(function()
            if enabled then
                task.wait(1)
                addHighlight(p)
            end
        end)
    end
end

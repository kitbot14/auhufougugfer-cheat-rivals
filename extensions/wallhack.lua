return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local enabled = false
    local Tab = Window:CreateTab("🧱 WallHack", 4483362458)

    local highlights = {} -- Highlight par joueur
    local nametags = {}   -- BillboardGui par joueur

    local MAX_DISTANCE = 50 -- distance max pour changer la couleur

    -- Fonction pour créer ou mettre à jour le highlight + nametag
    local function addHighlight(player)
        if not player.Character then return end

        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        -- Highlight
        if not highlights[player] then
            local hl = Instance.new("Highlight")
            hl.Adornee = char
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = char
            highlights[player] = hl
        end

        -- Nametag BillboardGui
        if not nametags[player] then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "WallHackNametag"
            billboard.Adornee = hrp
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Parent = char

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = player.Name
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextStrokeTransparency = 0
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextScaled = true
            textLabel.Parent = billboard

            nametags[player] = billboard
        end
    end

    local function removeHighlight(player)
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end

        if nametags[player] then
            nametags[player]:Destroy()
            nametags[player] = nil
        end
    end

    local function updateHighlights()
        if not enabled then
            -- Désactiver tous les highlights
            for player, _ in pairs(highlights) do
                removeHighlight(player)
            end
            return
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                addHighlight(player)
            else
                removeHighlight(player)
            end
        end
    end

    -- Change la couleur en fonction de la distance
    local RunService = game:GetService("RunService")
    RunService.Heartbeat:Connect(function()
        if not enabled then return end

        local lpChar = LocalPlayer.Character
        if not lpChar then return end
        local lpHrp = lpChar:FindFirstChild("HumanoidRootPart")
        if not lpHrp then return end

        for player, hl in pairs(highlights) do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (lpHrp.Position - char.HumanoidRootPart.Position).Magnitude
                if dist <= MAX_DISTANCE then
                    hl.FillColor = Color3.fromRGB(0, 255, 0) -- Vert proche
                else
                    hl.FillColor = Color3.fromRGB(255, 0, 0) -- Rouge loin
                end
            end
        end
    end)

    Tab:CreateToggle({
        Name = "Activer Wallhack",
        CurrentValue = false,
        Callback = function(value)
            enabled = value
            if enabled then
                updateHighlights()
            else
                -- Supprimer tous highlights et nametags
                for player, _ in pairs(highlights) do
                    removeHighlight(player)
                end
            end
        end,
    })

    -- Connexions pour gérer les joueurs qui rejoignent/quittent ou respawnent
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if enabled then
                task.wait(1) -- attendre que le perso charge bien
                addHighlight(player)
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(player)
        removeHighlight(player)
    end)

    -- Pour les joueurs déjà présents (au lancement du script)
    for _, player in ipairs(Players:GetPlayers()) do
        player.CharacterAdded:Connect(function()
            if enabled then
                task.wait(1)
                addHighlight(player)
            end
        end)
    end
end

return function(Window)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")

    local enabled = false
    local showNames = false
    local maxDistance = 50
    local colorNear = Color3.fromRGB(0, 255, 0)
    local colorFar = Color3.fromRGB(255, 0, 0)

    local Tab = Window:CreateTab("🧱 WallHack", 4483362458)

    local highlights = {}
    local nametags = {}

    local function createNametag(player)
        if nametags[player] then return end
        if not player.Character then return end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "WallHackNametag"
        billboard.Adornee = hrp
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = player.Character

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

    local function removeNametag(player)
        if nametags[player] then
            nametags[player]:Destroy()
            nametags[player] = nil
        end
    end

    local function addHighlight(player)
        if not player.Character then return end
        if highlights[player] then return end

        local hl = Instance.new("Highlight")
        hl.Adornee = player.Character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillColor = colorFar
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.Parent = player.Character

        highlights[player] = hl

        if showNames then
            createNametag(player)
        end
    end

    local function removeHighlight(player)
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end
        removeNametag(player)
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
                if dist <= maxDistance then
                    hl.FillColor = colorNear
                else
                    hl.FillColor = colorFar
                end
            end
        end
    end)

    -- Toggle WallHack
    Tab:CreateToggle({
        Name = "Activer Wallhack",
        CurrentValue = false,
        Callback = function(value)
            enabled = value
            updateAll()
        end,
    })

    -- Toggle Affichage des noms
    Tab:CreateToggle({
        Name = "Afficher les noms",
        CurrentValue = false,
        Callback = function(value)
            showNames = value
            if not enabled then return end
            if showNames then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        createNametag(player)
                    end
                end
            else
                for player, _ in pairs(nametags) do
                    removeNametag(player)
                end
            end
        end,
    })

    -- Slider Distance max pour couleur verte
    Tab:CreateSlider({
        Name = "Distance max pour couleur verte",
        Range = {10, 200},
        Increment = 5,
        Suffix = "studs",
        CurrentValue = maxDistance,
        Callback = function(value)
            maxDistance = value
        end,
    })

    -- Color picker couleur proche
    Tab:CreateColorPicker({
        Name = "Couleur proche",
        Default = colorNear,
        Callback = function(color)
            colorNear = color
        end,
    })

    -- Color picker couleur loin
    Tab:CreateColorPicker({
        Name = "Couleur loin",
        Default = colorFar,
        Callback = function(color)
            colorFar = color
        end,
    })

    -- Connexion des joueurs
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            if enabled then
                task.wait(1)
                addHighlight(p)
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(p)
        removeHighlight(p)
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        p.CharacterAdded:Connect(function()
            if enabled then
                task.wait(1)
                addHighlight(p)
            end
        end)
    end
end

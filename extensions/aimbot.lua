return function(Window)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")

    local isAimbotEnabled = false
    local aimRadius = 100 -- rayon en pixels autour du centre de l’écran

    local ignoredPlayers = {} -- table pour stocker les noms à ignorer

    -- UI pour blacklist (input textbox + bouton ajouter)
    local Tab = Window:CreateTab("🎯 Aimbot", 4483362458)

    -- Zone circulaire visible au centre
    local circleRadius = aimRadius
    local circleThickness = 2
    local circleColor = Color3.new(1, 0, 0) -- rouge

    -- Création du cercle rond sur l'écran avec Drawing API (si dispo)
    local circle
    if Drawing then
        circle = Drawing.new("Circle")
        circle.Radius = circleRadius
        circle.Color = circleColor
        circle.Thickness = circleThickness
        circle.Transparency = 1
        circle.Filled = false
    else
        warn("Drawing API non dispo, le cercle ne sera pas affiché")
    end

    -- Fonction pour mettre à jour la position du cercle au centre de l'écran
    local function updateCircle()
        if circle then
            circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            circle.Visible = isAimbotEnabled
        end
    end

    -- Fonction pour vérifier si un joueur est ignoré
    local function isIgnored(name)
        for _, v in ipairs(ignoredPlayers) do
            if v:lower() == name:lower() then
                return true
            end
        end
        return false
    end

    -- Trouver la cible la plus proche du centre, dans le rayon et pas blacklistée
    local function getClosestTarget()
        local closest = nil
        local shortestDistance = aimRadius

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not isIgnored(player.Name) and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
                local head = player.Character.Head
                local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude

                    if dist < shortestDistance then
                        shortestDistance = dist
                        closest = head
                    end
                end
            end
        end

        return closest
    end

    -- Faire viser la caméra sur la cible
    local function aimAt(target)
        if target then
            local dir = (target.Position - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir)
        end
    end

    -- UI: Input pour blacklist
    local blacklistInput = Tab:CreateTextbox({
        Name = "Blacklist (sépare par des virgules)",
        Text = "",
        Callback = function(text)
            -- Met à jour la liste des joueurs ignorés
            ignoredPlayers = {}
            for name in string.gmatch(text, "[^,%s]+") do
                table.insert(ignoredPlayers, name)
            end
            print("Blacklist mise à jour:", table.concat(ignoredPlayers, ", "))
        end,
    })

    Tab:CreateToggle({
        Name = "Activer Aimbot",
        CurrentValue = false,
        Callback = function(value)
            isAimbotEnabled = value
            if circle then circle.Visible = value end
        end,
    })

    Tab:CreateSlider({
        Name = "Rayon de visée",
        Min = 50,
        Max = 1000,
        Default = aimRadius,
        Callback = function(value)
            aimRadius = value
            circleRadius = value
            if circle then
                circle.Radius = value
            end
        end,
    })

    -- Mise à jour cercle et aimbot sur chaque frame
    RunService.RenderStepped:Connect(function()
        updateCircle()

        if isAimbotEnabled then
            local target = getClosestTarget()
            aimAt(target)
        end
    end)
end

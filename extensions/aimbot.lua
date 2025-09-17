return function(Window)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    local isAimbotEnabled = false
    local aimRadius = 1000

    local function getClosestTarget()
        local closest = nil
        local shortestDistance = aimRadius

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local touchPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - touchPos).Magnitude

                    if dist < shortestDistance then
                        shortestDistance = dist
                        closest = head
                    end
                end
            end
        end

        return closest
    end

    local function aimAt(target)
        if target then
            local dir = (target.Position - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir)
        end
    end

    -- ✅ Crée l'onglet dans Rayfield avec l'objet "Window" passé en paramètre
    local Tab = Window:CreateTab("🎯 Aimbot", 4483362458)

    Tab:CreateToggle({
        Name = "Activer Aimbot",
        CurrentValue = false,
        Callback = function(Value)
            isAimbotEnabled = Value
        end,
    })

    -- 🔁 Lancer le tracking
    RunService.RenderStepped:Connect(function()
        if isAimbotEnabled then
            local target = getClosestTarget()
            aimAt(target)
        end
    end)
end

return function(Window)
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("⚡ Combat Enhancements", 4483362458)

    local antiRecoilEnabled = false
    local instantReloadEnabled = false
    local rapidFireEnabled = false
    local infiniteAmmoEnabled = false

    -- Fonction pour patcher le recoil dans le client
    local function disableRecoil()
        -- Exemples d'approches :
        -- Chercher un objet Recoil ou une valeur dans le joueur ou les scripts locaux et mettre à 0

        -- Ceci est un exemple générique, tu devras adapter au jeu spécifique

        -- Exemple : désactiver un booléen recoilEnabled dans un script local
        local plrScripts = LocalPlayer:WaitForChild("PlayerScripts", 5)
        if plrScripts then
            for _, child in ipairs(plrScripts:GetChildren()) do
                if child.Name:lower():find("recoil") and child:IsA("ModuleScript") then
                    local success, mod = pcall(require, child)
                    if success and type(mod) == "table" and mod.RecoilEnabled ~= nil then
                        mod.RecoilEnabled = false
                        print("[Anti Recoil] Recoil désactivé dans module", child.Name)
                    end
                end
            end
        end
    end

    -- Fonction pour forcer le rechargement instantané
    local function instantReload()
        -- Exemple générique : patcher la variable reloadTime à 0
        -- ou hook la fonction reload pour la rendre instantanée

        -- Ici on attend que le personnage ait un script de gestion arme
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local weaponScript = char:FindFirstChild("WeaponScript") or char:WaitForChild("WeaponScript", 3)
        if weaponScript and weaponScript:IsA("Script") then
            -- Exemple: on peut tenter de modifier une valeur ReloadTime (à adapter)
            local reloadTimeVal = weaponScript:FindFirstChild("ReloadTime")
            if reloadTimeVal and reloadTimeVal:IsA("NumberValue") then
                reloadTimeVal.Value = 0
                print("[Reload] Rechargement instantané activé")
            end
        end
    end

    -- Fonction pour tirer ultra rapidement (auto fire)
    local function enableRapidFire()
        -- Exemple générique: patcher delay entre tirs à 0

        -- Idem, cherche variable fireRate dans script arme
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local weaponScript = char:FindFirstChild("WeaponScript") or char:WaitForChild("WeaponScript", 3)
        if weaponScript and weaponScript:IsA("Script") then
            local fireRateVal = weaponScript:FindFirstChild("FireRate")
            if fireRateVal and fireRateVal:IsA("NumberValue") then
                fireRateVal.Value = 0
                print("[Rapid Fire] Tir ultra rapide activé")
            end
        end
    end

    -- Fonction pour balles infinies
    local function enableInfiniteAmmo()
        -- Exemple générique: patcher la variable ammo pour qu'elle soit infinie

        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local weaponScript = char:FindFirstChild("WeaponScript") or char:WaitForChild("WeaponScript", 3)
        if weaponScript and weaponScript:IsA("Script") then
            local ammoVal = weaponScript:FindFirstChild("Ammo")
            if ammoVal and ammoVal:IsA("IntValue") then
                ammoVal.Value = math.huge
                print("[Infinite Ammo] Balles infinies activées")
            end
        end
    end

    Tab:CreateToggle({
        Name = "Anti Recul",
        CurrentValue = false,
        Callback = function(value)
            antiRecoilEnabled = value
            if value then disableRecoil() end
        end,
    })

    Tab:CreateToggle({
        Name = "Recharge Instantanée",
        CurrentValue = false,
        Callback = function(value)
            instantReloadEnabled = value
            if value then instantReload() end
        end,
    })

    Tab:CreateToggle({
        Name = "Tir Rapide",
        CurrentValue = false,
        Callback = function(value)
            rapidFireEnabled = value
            if value then enableRapidFire() end
        end,
    })

    Tab:CreateToggle({
        Name = "Balles Infinies",
        CurrentValue = false,
        Callback = function(value)
            infiniteAmmoEnabled = value
            if value then enableInfiniteAmmo() end
        end,
    })

    -- Si tu veux un update continu (au cas où des scripts réinitialisent les valeurs), ajoute un loop:
    RunService.Heartbeat:Connect(function()
        if antiRecoilEnabled then disableRecoil() end
        if instantReloadEnabled then instantReload() end
        if rapidFireEnabled then enableRapidFire() end
        if infiniteAmmoEnabled then enableInfiniteAmmo() end
    end)
end

return function(Window)
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Tab = Window:CreateTab("⚡ Combat Enhancements", 4483362458)
    print("[Module] Onglet Combat Enhancements créé")

    local antiRecoilEnabled = false
    local instantReloadEnabled = false
    local rapidFireEnabled = false
    local infiniteAmmoEnabled = false

    local function disableRecoil()
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
        else
            print("[Anti Recoil] PlayerScripts introuvable")
        end
    end

    local function instantReload()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local weaponScript = char:FindFirstChild("WeaponScript") or char:WaitForChild("WeaponScript", 3)
        if weaponScript and weaponScript:IsA("Script") then
            local reloadTimeVal = weaponScript:FindFirstChild("ReloadTime")
            if reloadTimeVal and reloadTimeVal:IsA("NumberValue") then
                reloadTimeVal.Value = 0
                print("[Reload] Rechargement instantané activé")
            else
                print("[Reload] ReloadTime introuvable ou non NumberValue")
            end
        else
            print("[Reload] WeaponScript introuvable")
        end
    end

    local function enableRapidFire()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local weaponScript = char:FindFirstChild("WeaponScript") or char:WaitForChild("WeaponScript", 3)
        if weaponScript and weaponScript:IsA("Script") then
            local fireRateVal = weaponScript:FindFirstChild("FireRate")
            if fireRateVal and fireRateVal:IsA("NumberValue") then
                fireRateVal.Value = 0
                print("[Rapid Fire] Tir ultra rapide activé")
            else
                print("[Rapid Fire] FireRate introuvable ou non NumberValue")
            end
        else
            print("[Rapid Fire] WeaponScript introuvable")
        end
    end

    local function enableInfiniteAmmo()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local weaponScript = char:FindFirstChild("WeaponScript") or char:WaitForChild("WeaponScript", 3)
        if weaponScript and weaponScript:IsA("Script") then
            local ammoVal = weaponScript:FindFirstChild("Ammo")
            if ammoVal and ammoVal:IsA("IntValue") then
                ammoVal.Value = math.huge
                print("[Infinite Ammo] Balles infinies activées")
            else
                print("[Infinite Ammo] Ammo introuvable ou non IntValue")
            end
        else
            print("[Infinite Ammo] WeaponScript introuvable")
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

    -- Loop pour maintenir les cheats actifs
    RunService.Heartbeat:Connect(function()
        if antiRecoilEnabled then disableRecoil() end
        if instantReloadEnabled then instantReload() end
        if rapidFireEnabled then enableRapidFire() end
        if infiniteAmmoEnabled then enableInfiniteAmmo() end
    end)

    print("[Module] rapidfire.lua chargé et prêt")
end

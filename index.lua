-- Chargement du menu Rayfield
local successRay, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not successRay then
    error("Impossible de charger Rayfield: " .. tostring(Rayfield))
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MY_USERNAME = LocalPlayer.Name

local Window = Rayfield:CreateWindow({
    Name = "📱 Mobile Admin GUI",
    LoadingTitle = "Mobile Aimbot & Tools",
    LoadingSubtitle = "By " .. MY_USERNAME,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MobileAdminGUI",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local BASE_URL = "https://raw.githubusercontent.com/kitbot14/auhufougugfer-cheat-rivals/main/extensions/"

local function loadModule(name)
    print("→ Chargement du module:", name)
    local ok, chunk = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. name .. ".lua"))
    end)
    if not ok or not chunk then
        warn("Erreur HTTP ou loadstring pour:", name, chunk)
        return
    end

    local ok2, moduleFunc = pcall(chunk)
    if not ok2 or type(moduleFunc) ~= "function" then
        warn("Le module '" .. name .. "' ne retourne pas une fonction.", moduleFunc)
        return
    end

    -- Now call it with Window
    local ok3, err = pcall(function()
        moduleFunc(Window)
    end)
    if not ok3 then
        warn("Erreur lors de l'exécution du module '" .. name .. "':", err)
    else
        print("→ Module '" .. name .. "' chargé avec succès.")
    end
end

-- Charger tes modules
loadModule("aimbot")
loadModule("wallhack")
loadModule("jumpboost")
loadModule("tp")

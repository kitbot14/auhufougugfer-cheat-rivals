-- 🧠 Chargement du menu Rayfield
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ton pseudo (automatiquement)
local MY_USERNAME = LocalPlayer.Name

-- 🗂️ Création de la fenêtre principale
local Window = Rayfield:CreateWindow({
    Name = "📱 Mobile Admin GUI",
    LoadingTitle = "Mobile Aimbot & Tools",
    LoadingSubtitle = "By " .. MY_USERNAME,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MobileAdminGUI",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- 📦 Charger les modules (extensions)
local function loadModule(name)
    local success, result = pcall(function()
        local moduleFunc = loadstring(game:HttpGet("https://raw.githubusercontent.com/kitbot14/auhufougugfer-cheat-rivals/main/extensions/" .. name .. ".lua"))
        return moduleFunc()
    end)

    if success and typeof(result) == "function" then
        -- Appelle la fonction retournée avec la fenêtre Rayfield
        result(Window)
    else
        warn("❌ Erreur de chargement du module :", name, result)
    end
end

-- 📥 Chargement des scripts externes
loadModule("aimbot")
loadModule("wallhack")
loadModule("jumpboost")
loadModule("tp")

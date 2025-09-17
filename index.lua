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
    local success, module = pcall(function()
        return loadstring(game:HttpGet("https://yourcdn.domain/extensions/" .. name .. ".lua"))()
    end)
    if not success then
        warn("Erreur de chargement du module:", name, module)
    end
end

-- 📥 Chargement des scripts externes
loadModule("aimbot")
loadModule("wallhack")
loadModule("jumpboost")
loadModule("tp")

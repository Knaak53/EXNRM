Config = {}

--[[ 
    This enables/disables the post-loading animation where camera starts in the clouds, 
    above the city like when switching characters in GTA V Story Mode.
--]]
Config.EnterCityAnimation = false

-- Setting these to false will enable all colors available in the game.
Config.UseNaturalHairColors = true
Config.UseNaturalEyeColors = true

-- Map Locations
Config.EnableClothingShops = true
Config.ClothingShops = {
    vector3(72.3, -1399.1, 28.4),
    vector3(-703.8, -152.3, 36.4),
    vector3(-167.9, -299.0, 38.7),
    vector3(428.7, -800.1, 28.5),
    vector3(-829.4, -1073.7, 10.3),
    vector3(-1447.8, -242.5, 48.8),
    vector3(11.6, 6514.2, 30.9),
    vector3(123.6, -219.4, 53.6),
    vector3(1696.3, 4829.3, 41.1),
    vector3(618.1, 2759.6, 41.1),
    vector3(1190.6, 2713.4, 37.2),
    vector3(-1193.4, -772.3, 16.3),
    vector3(-3172.5, 1048.1, 19.9),
    vector3(-1108.4, 2708.9, 18.1)
}

Config.EnableBarberShops = true
Config.BarberShops = {
    vector3(-814.3, -183.8, 36.6),
    vector3(136.8, -1708.4, 28.3),
    vector3(-1282.6, -1116.8, 6.0),
    vector3(1931.5, 3729.7, 31.8),
    vector3(1212.8, -472.9, 65.2),
    vector3(-32.9, -152.3, 56.1),
    vector3(-278.1, 6228.5, 30.7)
}

--[[ 
    Hospital and City Hall coordinates are all outside, 
    because those buildings don't have interiors by default. 
    They should be replaced with proper interior coordinates.
--]]
Config.EnablePlasticSurgeryUnits = true
Config.PlasticSurgeryUnits = {
    vector3(338.8, -1394.5, 31.5),      -- Central Los Santos Medical Center
    -- vector3(240.2, -1380.0, 33.7),   -- Los Santos General Hospital (Coroner)
    -- vector3(1152.2, -1528.0, 34.8),  -- St Fiacre Hospital for East Los Santos
    vector3(-874.7, -307.5, 38.5),      -- Portola Trinity Medical Center
    vector3(-676.7, 311.5, 82.5),       -- Eclipse Medical Tower
    vector3(-449.8, -341.0, 33.7),      -- Mount Zonah Medical Center
    vector3(298.7, -584.6, 42.2),       -- Pillbox Hill Medical Center
    -- vector3(1839.5, 3672.5, 33.2),   -- Sandy Shores Medical Center
    -- vector3(-246.9, 6330.5, 31.4)    -- The Bay Care Center (Paleto)
}

Config.EnableNewIdentityProviders = true
Config.NewIdentityProviders = {
    -- vector3(233.2, -410.1, 47.3),    -- Los Santos City Hall
    vector3(-544.9, -204.4, 37.5),      -- Rockford Hills City Hall
    -- vector3(328.5, -1581.8, 31.9),   -- Davis City Hall
    -- vector3(-1283.4, -565.1, 31.0)   -- Del Perro City Hall
}

--[[    ESX identity integration

        Follow these instructions if you plan to set Config.EnableESXIdentityIntegration to true:
        1) Uncomment '@esx_identity/server/main.lua', in this resource's fxmanifest.lua

        2) Edit esx_identity/client/main.lua:

            Replace (around line 50):
                EnableGui(true) 
            with
                TriggerEvent('cui_character:open', { 'identity', 'features', 'style', 'apparel' }, false)

            Replace (start around line 54):
                RegisterNUICallback('register', function(data, cb)
                    ESX.TriggerServerCallback('esx_identity:registerIdentity', function(callback)
                        if callback then
                            ESX.ShowNotification(_U('thank_you_for_registering'))
                            EnableGui(false)
                            TriggerEvent('esx_skin:playerRegistered')
                        else
                            ESX.ShowNotification(_U('registration_error'))
                        end
                    end, data)
                end)
            with
                RegisterNUICallback('register', function(data, cb)
                    ESX.TriggerServerCallback('cui_character:updateIdentity', function(callback)
                        if callback then
                            ESX.ShowNotification(_U('thank_you_for_registering'))
                            TriggerEvent('cui_character:setCurrentIdentity', data)
                            TriggerEvent('cui_character:close', true)
                        else
                            ESX.ShowNotification(_U('registration_error'))
                        end
                    end, data)
                end)
]]--
Config.EnableESXIdentityIntegration = true

if Config.EnableESXIdentityIntegration then
    -- To avoid errors, make sure these equal the respective values in your in esx_identity config
    Config.MaxNameLength    = 16
    Config.MinHeight        = 140
    Config.MaxHeight        = 200
    Config.LowestYear       = 1900
    Config.HighestYear      = 2020
end

--[[
    This is extendedmode compatibility, if you use esx v1 final, IGNORE THIS PART.

    If you wish to use extended mode, enable this and MAKE SURE YOU MODIFY SPAWNMANAGER in:
    resources/[managers]/spawnmanager/spawnmanager.lua

    Delete this part (around line 309):

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end

    If you don't do it, you will experience a really weird glitch on character spawn after loading screen.
--]]
Config.ExtendedMode = true
Config.UseSteamID = false

--[[
    This is for servers without the ESX framework. 

    If you wish to use this for a standalone server, enable this and MAKE SURE YOU MODIFY fxmanifest.lua:

    Delete this part (around line 5):
    '@es_extended/locale.lua'

    And delete this part (around line 51):

        dependencies {
            'es_extended'
        }

    If you don't do it, you will receive an error when launching your server.
--]]
Config.StandAlone = false
if Config.StandAlone then
    Config.ExtendedMode = false
    Config.EnableESXIdentityIntegration = false
    Config.EnableNewIdentityProviders = false
end

Config.peds = {
    clothesShops = {
        animation = "",
        model = 'ig_jewelass',
        positions = {
            {coords = vector3(70.65, -1399.75, 28.38), heading = 309.56},
            {coords = vector3(-712.65, -153.97, 36.42), heading = 216.43},
            {coords = vector3(-160.88, -304.4, 38.73), heading = 341.93},
            {coords = vector3(430.37, -799.3, 28.5), heading = 123.43},
            {coords = vector3(-830.72, -1072.82, 10.33), heading = 246.09},
            {coords = vector3(-1452.18, -235.02, 48.8), heading = 133.35},
            {coords = vector3(13.26, 6513.55, 30.89), heading = 83.33},
            {coords = vector3(123.6, -219.4, 53.56), heading = 336.19},
            {coords = vector3(1697.9, 4830.3, 41.07), heading = 139.14},
            {coords = vector3(617.9, 2760.06, 41.09), heading = 179.12},
            {coords = vector3(1189.85, 2715.16, 37.23), heading = 216.93},
            {coords = vector3(-1193.4, -772.3, 16.32), heading = 120.44},
            {coords = vector3(-3172.5, 1048.1, 19.86), heading = 337.21},
            {coords = vector3(-1109.98, 2709.53, 18.12), heading = 264.03}
        }
    },
    accessories = {
        model = 'ig_lacey_jones_02',
        animation = "",
        positions ={
            {coords = vector3(73.97, -1392.85, 28.38), heading = 266.82},
            {coords = vector3(-708.23, -153.05, 36.42), heading = 115.49},
            {coords = vector3(-164.61, -302.0001, 38.73), heading = 246.32},
            {coords = vector3(427.29, -806.2, 28.49), heading = 88.78},
            {coords = vector3(-822.92, -1072.24, 10.33), heading = 207.37},
            {coords = vector3(-1449.98, -239.17, 48.81), heading = 43.36},
            {coords = vector3(5.76, 6511.4, 30.88), heading = 37.8},
            {coords = vector3(126.65, -225.07, 53.56), heading = 66.9},
            {coords = vector3(1695.31, 4823.07, 41.06), heading = 97.74},
            {coords = vector3(613.09, 2761.77, 41.09), heading = 277.69},
            {coords = vector3(1197.01, 2711.63, 37.22), heading = 174.49},
            {coords = vector3(-1193.19, -766.36, 16.32), heading = 210.38},
            {coords = vector3(-3169.75, 1042.43, 19.86), heading = 65.17},
            {coords = vector3(-1102.43, 2711.56, 18.12), heading = 220.35}
        }   
    },
    masks = {
        model = 'u_m_y_pogo_01',
        animation = "",
        positions ={
            {coords = vector3(-1337.16, -1276.87, 3.89), heading = 107.72},
        }
    },
    barbershops = {
        model = 's_f_m_fembarber',
        animation = "",
        positions ={
            {coords = vector3(-811.49, -182.32, 36.57), heading = 113.34},
            {coords = vector3(134.83, -1708.1, 28.29), heading = 138.23},
            {coords = vector3(-1284.17, -1115.32, 5.99), heading = 98.04},
            {coords = vector3(1930.9, 3728.15, 31.84), heading = 206.94},
            {coords = vector3(1211.44, -470.69, 65.21), heading = 72.82},
            {coords = vector3(-30.78, -151.69, 56.08), heading = 338.96},
            {coords = vector3(-278.07, 6230.36, 30.7), heading = 44.86}
        }
    }
}
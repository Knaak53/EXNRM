local thirst, hunger = 0, 0
local hp, armour = 0, 0
local stress = 0
local usingPhone = false

Citizen.CreateThread(function()
    while true do
        Wait(1200)
        if not IsPedInAnyVehicle(PlayerPedId(), false) and not usingPhone then
            DisplayRadar(false)
            SendNUIMessage({
                action = "hideRadar"
            })
        else
            DisplayRadar(true)
            SendNUIMessage({
                action = "showRadar"
            })
        end
    end
end)

RegisterNetEvent("esx_ladderhud:showRadar")
AddEventHandler("esx_ladderhud:showRadar", function()
    usingPhone = true
    SetRadarBigmapEnabled(true, false)
    Wait(1)
    SetRadarBigmapEnabled(false, false)
end)

RegisterNetEvent("esx_ladderhud:hideRadar")
AddEventHandler("esx_ladderhud:hideRadar", function()
    SetRadarBigmapEnabled(true, false)
    Wait(1)
    SetRadarBigmapEnabled(false, false)
    usingPhone = false
end)

Citizen.CreateThread(function ()
    while true do
        local playerPed = PlayerPedId()
        if GetEntityMaxHealth(playerPed) ~= 200 then
            SetEntityMaxHealth(playerPed, 200)
            SetEntityHealth(playerPed, 200)
        end
        hp = ((GetEntityHealth(playerPed) - 100) / GetEntityMaxHealth(playerPed) * 2 * 100) or 0
        armour = GetPedArmour(playerPed) or 0
        Citizen.Wait(333)
        SendNUIMessage({
            show = IsPauseMenuActive(),
            thirst = thirst,
            hunger = hunger,
            hp = hp,
            armour = armour,
            stress = stress
        })
    end
end)

AddEventHandler("esx_ladderhud:updateBasics", function(basics)
    if basics then
        for k,v in pairs(basics) do
            if v.name == "hunger" then
                hunger = v.percent
            elseif v.name == "stress" then
                stress = v.percent
            elseif v.name == "thirst" then
                thirst = v.percent
            end   
        end
    end
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(1)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(1000)
        Citizen.InvokeNative(0xF6E48914C7A8694E, minimap, "SETUP_HEALTH_ARMOUR")
        Citizen.InvokeNative(0xC3D0841A0CC546A6,3)
        Citizen.InvokeNative(0xC6796A8FFA375E53 )
    end
end)
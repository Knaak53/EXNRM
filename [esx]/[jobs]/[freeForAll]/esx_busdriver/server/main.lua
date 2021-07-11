ESX = nil

ESX = exports.extendedmode:getSharedObject()
ExM = exports.extendedmode:getExtendedModeObject()

RegisterServerEvent("gd_jobs_bus:tryStartJob")
AddEventHandler("gd_jobs_bus:tryStartJob", function(location, tier)
        TriggerClientEvent("gd_jobs_bus:startJob", source, location, tier)
end)

RegisterServerEvent("gd_jobs_bus:finishJob")
AddEventHandler("gd_jobs_bus:finishJob", function(total_fares, payment, tier)

    local pay = (150 * payment)
    local money = math.floor((total_fares * pay) / 10)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addAccountMoney('money', money)
    TriggerClientEvent('esx:showNotification', _source, 'Has cobrado ~g~150€~s~ extras por acabar la ruta')
end)

RegisterServerEvent("gd_jobs_bus:pickupJob")
AddEventHandler("gd_jobs_bus:pickupJob", function(fares, payment, tier)
        local pay = (15 * payment) * tier
        local money = math.floor(fares * pay)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.addAccountMoney('money', money)
        TriggerClientEvent('esx:showNotification', _source, 'Has cobrado ~g~15€~s~ a ~y~' .. math.floor(fares) .. '~s~ pasajeros')
end)

RegisterNetEvent("esx_busdriver:getBus")
AddEventHandler("esx_busdriver:getBus", function(coords, heading)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local veh = ExM.Game.SpawnVehicle("bus", coords)  
    while not DoesEntityExist(veh) do
        Wait(75)
    end
    SetEntityHeading(veh, heading)
    xPlayer.removeMoney(250)
    TriggerClientEvent('esx:showNotification', _source, "Se te han retenido ~y~250€~w~ como fianza por el vehiculo")
    TriggerClientEvent("esx_busdriver:sendBusData", _source, NetworkGetNetworkIdFromEntity(veh))
end)
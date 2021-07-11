ESX = exports.extendedmode:getSharedObject()
ExM = exports.extendedmode:getExtendedModeObject()

RegisterServerEvent('esx_garbage:givePayment')
AddEventHandler('esx_garbage:givePayment', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(amount)
end)

RegisterNetEvent("esx_garbage:spawnTruck")
AddEventHandler("esx_garbage:spawnTruck", function(spawncoords)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local veh = ExM.Game.SpawnVehicle("trash", spawncoords)	
    while not DoesEntityExist(veh) do
        Wait(50)
    end
    SetEntityHeading(veh, 265.859)
    xPlayer.removeMoney(Config.fianza)
    TriggerClientEvent('esx:showNotification', _source, "Se te han retenido ~y~" .. Config.fianza .. "€~w~ como fianza por el vehiculo")
    TriggerClientEvent("esx_garbage:warpPedIntoTruck", _source, NetworkGetNetworkIdFromEntity(veh))
end)

RegisterNetEvent("esx_garbage:deleteTruckAndGiveBackMoney")
AddEventHandler("esx_garbage:deleteTruckAndGiveBackMoney", function(netVeh)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicle = NetworkGetEntityFromNetworkId(netVeh)
    xPlayer.addMoney(Config.fianza)
    TriggerClientEvent('esx:showNotification', _source, "~g~Se te ha devuelto la fianza del vehiculo")
    DeleteEntity(vehicle)
end)
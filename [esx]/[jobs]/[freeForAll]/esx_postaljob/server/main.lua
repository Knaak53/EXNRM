ESX = nil
ESX = exports.extendedmode:getSharedObject()
ExM = exports.extendedmode:getExtendedModeObject()

RegisterServerEvent('gopostal_job:pay') -- Pay player at the end of delivery
AddEventHandler('gopostal_job:pay', function(isPackage, quantity)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local finalAmount = 0
	if not isPackage then
		finalAmount = 15 * quantity
		xPlayer.addMoney(finalAmount)
		xPlayer.showNotification("Has recibido ~g~" .. finalAmount .. "€~w~ por entregar ~y~x" .. quantity .. "~w~ cartas.")
	else
		finalAmount = 45 * quantity
		xPlayer.addMoney(finalAmount)
		xPlayer.showNotification("Has recibido ~g~" .. finalAmount .. "€~w~ por entregar ~y~x" .. quantity .. "~w~ paquetes.")
	end
end)

RegisterNetEvent("esx_postaljob:getBoxville")
AddEventHandler("esx_postaljob:getBoxville", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local veh = ExM.Game.SpawnVehicle("boxville2", Config.Zones.VehicleSpawnPoint.Pos)	
    while not DoesEntityExist(veh) do
        Wait(75)
    end
    SetEntityHeading(veh, Config.Zones.VehicleSpawnPoint.Heading)
    xPlayer.removeMoney(Config.fianza)
    TriggerClientEvent('esx:showNotification', _source, "Se te han retenido ~y~" .. Config.fianza .. "€~w~ como fianza por el vehiculo")
    TriggerClientEvent("esx_postaljob:warpPedIntoBoxVille", _source, NetworkGetNetworkIdFromEntity(veh))
end)

RegisterNetEvent("esx_postaljob:deleteBVAndGiveBackMoney")
AddEventHandler("esx_postaljob:deleteBVAndGiveBackMoney", function(netVeh)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicle = NetworkGetEntityFromNetworkId(netVeh)
    xPlayer.addMoney(Config.fianza)
    TriggerClientEvent('esx:showNotification', _source, "~g~Se te ha devuelto la fianza del vehiculo")
    DeleteEntity(vehicle)
end)
ESX = nil
ExM = exports.extendedmode:getExtendedModeObject()
ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent("esx_bike_rental:payRental")
AddEventHandler("esx_bike_rental:payRental", function(bikeName, spawnCoords)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	local bike = {}
	for k, v in pairs(Config.bikes) do
		if v.name == bikeName then
			bike = v
		end
	end
	if xPlayer.getMoney() >= bike.price then
		local vectorCoords = vector3(spawnCoords.coords.x, spawnCoords.coords.y, spawnCoords.coords.z)
		local veh = ExM.Game.SpawnVehicle(bike.name, vectorCoords)	
	    while not DoesEntityExist(veh) do
	        Wait(50)
	    end
	    SetEntityHeading(veh, spawnCoords.heading)
	    xPlayer.removeMoney(bike.price)
	    TriggerClientEvent("esx_bike_rental:warpPedInBike", _source, NetworkGetNetworkIdFromEntity(veh))
	    TriggerClientEvent("esx:showNotification", _source, "Has alquilado una ~y~" .. bike.label .. "~w~ por ~g~" .. bike.price .. "€")
	else
		TriggerClientEvent("esx:showNotification", _source, "~r~NO TIENES SUFICIENTE DINERO")
	end
end)

RegisterServerEvent("esx_bike_rental:returnBike")
AddEventHandler("esx_bike_rental:returnBike", function(netBike, bikeModel)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	for k, v in pairs(Config.bikes) do
		if GetHashKey(v.name) == bikeModel then
			bike = v
		end
	end
	local returnMoney = math.floor(bike.price * 0.6)	
	local vehicle = NetworkGetEntityFromNetworkId(netBike)
    DeleteEntity(vehicle)
    xPlayer.addMoney(returnMoney)
	TriggerClientEvent("esx:showNotification", _source, "Has devuelto la bicicleta y recuperas un 60% del dinero: ~g~" .. returnMoney .. "€")
end)
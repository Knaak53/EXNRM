ESX                			 = nil
local PlayersVente			 = {}

ESX = exports.extendedmode:getSharedObject()
ExM = exports.extendedmode:getExtendedModeObject()

ESX.RegisterServerCallback('esx_cityworks:examine', function(source, cb)
	local _source = source
	math.randomseed(os.time())
	if math.random(1, 100) < 60 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("esx_cityworks:checkRequeriments", function(source, cb)
	local _source = source
	cb(exports.esx_joblisting:checkRequeriments("works", _source))
end)

RegisterServerEvent('esx_cityworks:repare')
AddEventHandler('esx_cityworks:repare', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)   
    xPlayer.addInventoryItem("factura", 1)
end)

RegisterNetEvent("esx_cityworks:getBoxville")
AddEventHandler("esx_cityworks:getBoxville", function(spawncoords)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local veh = ExM.Game.SpawnVehicle("boxville", spawncoords)	
    while not DoesEntityExist(veh) do
        Wait(50)
    end
    xPlayer.removeMoney(Config.fianza)
    TriggerClientEvent('esx:showNotification', _source, "Se te han retenido ~y~" .. Config.fianza .. "€~w~ como fianza por el vehiculo")
    TriggerClientEvent("esx_cityworks:warpPedIntoBoxVille", _source, NetworkGetNetworkIdFromEntity(veh))
end)

RegisterNetEvent("esx_cityworks:deleteBVAndGiveBackMoney")
AddEventHandler("esx_cityworks:deleteBVAndGiveBackMoney", function(netVeh)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicle = NetworkGetEntityFromNetworkId(netVeh)
    xPlayer.addMoney(Config.fianza)
    TriggerClientEvent('esx:showNotification', _source, "~g~Se te ha devuelto la fianza del vehiculo")
    DeleteEntity(vehicle)
end)

RegisterServerEvent('esx_cityworks:pay')
AddEventHandler('esx_cityworks:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local billCount = xPlayer.getInventoryItem("factura").count
    if billCount > 0 then
    	local payAmount = 0
	    math.randomseed(os.time())
	    for i = 1, billCount do
	    	payAmount = payAmount + math.random(50, 75)
	    end
	    xPlayer.addMoney(payAmount)
	    xPlayer.removeInventoryItem("factura", billCount)
	    TriggerClientEvent("esx:showNotification", _source, "Has recibido un pago de ~g~" .. payAmount .. "€~w~ por ~y~" .. billCount .. "~w~ factura/s")
    else
    	TriggerClientEvent("esx:showNotification", _source, "~r~No tienes facturas que cobrar!")
    end
end)
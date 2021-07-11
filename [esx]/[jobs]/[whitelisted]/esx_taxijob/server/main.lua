ESX = nil
local lastPlayerSuccess = {}
ExM = exports.extendedmode:getExtendedModeObject()

ESX = exports.extendedmode:getSharedObject()

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'taxi', 'taxi', 'taxi', {type = 'public'})

RegisterNetEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local timeNow = os.clock()

	if xPlayer.getJob().name == 'taxi' then
		if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
			lastPlayerSuccess[source] = timeNow

			math.randomseed(os.time())
			local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)

			if xPlayer.getJob().grade >= 3 then
				total = total * 2
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'taxi', function(account)
				if account then
					local playerMoney  = ESX.Math.Round(total / 100 * 30)
					local societyMoney = ESX.Math.Round(total / 100 * 70)

					xPlayer.addMoney(playerMoney)
					account.addMoney(societyMoney)

					xPlayer.showNotification(_U('comp_earned', societyMoney, playerMoney))
				else
					xPlayer.addMoney(total)
					xPlayer.showNotification(_U('have_earned', total))
				end
			end)
		end
	else
		print(('[esx_taxijob] [^3WARNING^7] %s attempted to trigger success (cheating)'):format(xPlayer.identifier))
	end
end)

local activeTaximeters = {}

RegisterNetEvent("esx_taxijob:startNewTaximeterGroup")
AddEventHandler("esx_taxijob:startNewTaximeterGroup", function(playersInVehicle)
	local _source = source
	if not activeTaximeters[_source] then
		activeTaximeters[_source] = playersInVehicle
	end
	for k, v in pairs(activeTaximeters[_source]) do
		TriggerClientEvent("esx_taxijob:showTaximeterClient", v, 0)
	end
end)

RegisterNetEvent("esx_taxijob:updateGroupSession")
AddEventHandler("esx_taxijob:updateGroupSession", function(currentSessionAmount)
	local _source = source
	if activeTaximeters[_source] then
		for k, v in pairs(activeTaximeters[_source]) do
			TriggerClientEvent("esx_taxijob:updateTaximeterValueClient", v, currentSessionAmount)
		end
	end
end)

RegisterNetEvent("esx_taxijob:closeTaximeterGroup")
AddEventHandler("esx_taxijob:closeTaximeterGroup", function(currentSessionAmount)
	local _source = source
	if activeTaximeters[_source] then
		for k, v in pairs(activeTaximeters[_source]) do
			TriggerClientEvent("esx_taxijob:closeTaximeterClient", v)
		end
	end
	activeTaximeters[_source] = nil
end)

local spawnedTaxies = {}

RegisterNetEvent("esx_taxijob:spawnTaxi")
AddEventHandler("esx_taxijob:spawnTaxi", function(model)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not spawnedTaxies[_source] then
		print(Config.Zones.VehicleSpawnPoint.Pos, model)
		local veh = ExM.Game.SpawnVehicle(model, Config.Zones.VehicleSpawnPoint.Pos)	
	    while not DoesEntityExist(veh) do
	        Wait(50)
	    end
	    SetEntityHeading(veh, Config.Zones.VehicleSpawnPoint.heading)
	    xPlayer.removeMoney(Config.fianza)
	    TriggerClientEvent("esx_taxijob:warpPedInVehicle", _source, NetworkGetNetworkIdFromEntity(veh))
	else
		TriggerClientEvent("esx:showNotification", _source, "~r~Ya has solicitado un taxi, debes devolverlo o esperar antes de poder solicitar otro.")
	end
end)

RegisterNetEvent('esx_taxijob:deleteTaxiAndGiveBackMoney')
AddEventHandler('esx_taxijob:deleteTaxiAndGiveBackMoney', function(netVeh)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicle = NetworkGetEntityFromNetworkId(netVeh)
    DeleteEntity(vehicle)
    spawnedTaxies[_source] = nil
    xPlayer.addMoney(Config.fianza)
   	TriggerClientEvent("esx:showNotification", _source, "~g~Te han devuelto la fianza!")
end)


--[[RegisterNetEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getJob().name == 'taxi' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
			local item = inventory.getItem(itemName)

			-- is there enough in the society?
			if count > 0 and item.count >= count then
				-- can the player carry the said amount of x item?
				if xPlayer.canCarryItem(itemName, count) then
					inventory.removeItem(itemName, count)
					xPlayer.addInventoryItem(itemName, count)
					xPlayer.showNotification(_U('have_withdrawn', count, item.label))
				else
					xPlayer.showNotification(_U('player_cannot_hold'))
				end
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		end)
	else
		print(('[esx_taxijob] [^3WARNING^7] %s attempted to trigger getStockItem'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getJob().name == 'taxi' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
			local item = inventory.getItem(itemName)

			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				xPlayer.showNotification(_U('have_deposited', count, item.label))
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		end)
	else
		print(('[esx_taxijob] [^3WARNING^7] %s attempted to trigger putStockItems'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)]]--

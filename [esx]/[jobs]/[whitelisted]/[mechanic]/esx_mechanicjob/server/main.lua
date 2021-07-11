ESX                = nil
PlayersHarvesting  = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting    = {}
PlayersCrafting2   = {}
PlayersCrafting3   = {}

ESX = exports.extendedmode:getSharedObject()

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'mechanic', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mechanic', _U('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', "mechanic", "Mecanico", "mechanic", "mechanic", "mechanic", {type = 'private'})

RegisterServerEvent('esx_mechanicjob:buyTool')
AddEventHandler('esx_mechanicjob:buyTool', function(price, item, label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local societyAccount

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		societyAccount = account
	end)

	if price * 3 < societyAccount.money then
		PlayersHarvesting[_source] = true
		Harvest(source, item, price, societyAccount)
		TriggerClientEvent('esx:showNotification', _source, "Reponiendo ~b~" .. label)
	else
		TriggerClientEvent('esx:showNotification', _source, "La empresa no puede permitirse eso...")
	end
end)

function Harvest(source, item, price, societyAccount)
	SetTimeout(4000, function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local FixToolQuantity = xPlayer.getInventoryItem(item).count

		if FixToolQuantity >= 3 then
			TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
		else
			societyAccount.removeMoney(price)
			xPlayer.addInventoryItem(item, 1)
			Harvest(source, item, price, societyAccount)
		end
	end)
end

RegisterServerEvent('esx_mechanicjob:startCraft')
AddEventHandler('esx_mechanicjob:startCraft', function()
	local _source = source
	PlayersCrafting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_blowtorch'))
	Craft(_source)
end)

RegisterServerEvent('esx_mechanicjob:stopCraft')
AddEventHandler('esx_mechanicjob:stopCraft', function()
	local _source = source
	PlayersCrafting[_source] = false
end)

function Craft(source)
	SetTimeout(4000, function()

		local xPlayer = ESX.GetPlayerFromId(source)
		local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

		if GazBottleQuantity <= 0 then
			TriggerClientEvent('esx:showNotification', source, _U('not_enough_gas_can'))
		else
			xPlayer.removeInventoryItem('gazbottle', 1)
			xPlayer.addInventoryItem('blowpipe', 1)
			Craft(source)
		end

	end)
end

function Craft2(source)
	SetTimeout(4000, function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count

		if FixToolQuantity <= 0 then
			TriggerClientEvent('esx:showNotification', source, _U('not_enough_repair_tools'))
		else
			xPlayer.removeInventoryItem('fixtool', 1)
			xPlayer.addInventoryItem('fixkit', 1)
			Craft2(source)
		end
	end)
end

RegisterServerEvent('esx_mechanicjob:startCraft2')
AddEventHandler('esx_mechanicjob:startCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_repair_kit'))
	Craft2(_source)
end)

RegisterServerEvent('esx_mechanicjob:stopCraft2')
AddEventHandler('esx_mechanicjob:stopCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = false
end)

function Craft3(source)
	SetTimeout(4000, function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count

		if CaroToolQuantity <= 0 then
			TriggerClientEvent('esx:showNotification', source, _U('not_enough_body_tools'))
		else
			xPlayer.removeInventoryItem('carotool', 1)
			xPlayer.addInventoryItem('carokit', 1)
			Craft3(source)
		end
	end)
end

RegisterServerEvent('esx_mechanicjob:startCraft3')
AddEventHandler('esx_mechanicjob:startCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_body_kit'))
	Craft3(_source)
end)

RegisterServerEvent('esx_mechanicjob:stopCraft3')
AddEventHandler('esx_mechanicjob:stopCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = false
end)

RegisterServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
AddEventHandler('esx_mechanicjob:onNPCJobMissionCompleted', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total   = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);
	local pped = GetPlayerPed(_source)
	local coords = GetEntityCoords(pped)
	print("distancia: " ..#(coords - (vector3(Config.Zones.VehicleDelivery.Pos.x,Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z))))
	if xPlayer.getJob().name == "mechanic" and #(coords - (vector3(Config.Zones.VehicleDelivery.Pos.x,Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z))) < 20 then
		if xPlayer.getJob().grade <= 2 then
			total = total * 2
		end

		--
		print("eeeee")
		local totali = math.random(0,2)
		if totali ~= 0 then
			xPlayer.addInventoryItem("gazbottle",totali)
		end

		totali = math.random(0,2)
		if totali ~= 0 then
			xPlayer.addInventoryItem("fixtool",totali)
		end

		totali = math.random(0,2)
		if totali ~= 0 then
			xPlayer.addInventoryItem("carotool",totali)
		end

		TriggerEvent('esx_addonaccount:getSharedAccount', xPlayer.getJob().name, function(account)
			account.addMoney(total)
		end)

		TriggerClientEvent("esx:showNotification", _source, _U('your_comp_earned').. total)
	end
end)

--ESX.RegisterUsableItem('blowpipe', function(source)
--	local _source = source
--	local xPlayer  = ESX.GetPlayerFromId(source)
--
--	xPlayer.removeInventoryItem('gazbottle', 1)
--
--	TriggerClientEvent('esx_mechanicjob:onHijack', _source)
--	TriggerClientEvent('esx:showNotification', _source, _U('you_used_blowtorch'))
--end)
--
--ESX.RegisterUsableItem('fixkit', function(source)
--	local _source = source
--	local xPlayer  = ESX.GetPlayerFromId(source)
--
--	xPlayer.removeInventoryItem('fixkit', 1)
--
--	TriggerClientEvent('esx_mechanicjob:onFixkit', _source)
--	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
--end)
--
--ESX.RegisterUsableItem('carokit', function(source)
--	local _source = source
--	local xPlayer  = ESX.GetPlayerFromId(source)
--
--	xPlayer.removeInventoryItem('carokit', 1)
--
--	TriggerClientEvent('esx_mechanicjob:onCarokit', _source)
--	TriggerClientEvent('esx:showNotification', _source, _U('you_used_body_kit'))
--end)

RegisterServerEvent('esx_mechanicjob:getStockItem')
AddEventHandler('esx_mechanicjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
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
			xPlayer.showNotification(_U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mechanicjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_mechanicjob:putStockItems')
AddEventHandler('esx_mechanicjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			xPlayer.showNotification(_U('invalid_quantity'))
		end

		xPlayer.showNotification(_U('have_deposited', count, item.label))
	end)
end)

ESX.RegisterServerCallback('esx_mechanicjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({items = items})
end)

RegisterServerEvent("esx_mechanicjob:onFixOwner")
AddEventHandler("esx_mechanicjob:onFixOwner", function(vehId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem("fixkit").count >= 1 then
		local vehOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(vehId))
		TriggerClientEvent("esx_mechanicjob:onFixOwner", vehOwner, vehId)
		xPlayer.removeInventoryItem('fixkit', 1)
	else
		local vehOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(vehId))
		TriggerClientEvent("esx_mechanicjob:onFixOwner", vehOwner, vehId, true)
		xPlayer.showNotification('No puedes reparar el motor completamente, te faltan ~b~herramientas')
	end
	
end)


RegisterServerEvent("esx_mechanicjob:onCaroOwner")
AddEventHandler("esx_mechanicjob:onCaroOwner", function(vehId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryitem("carokit").count >= 1 then
		local vehOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(vehId))

		TriggerClientEvent("esx_mechanicjob:onCaroOwner", vehOwner, vehId)
		xPlayer.removeInventoryItem('carokit', 1)
	else
		local vehOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(vehId))

		TriggerClientEvent("esx_mechanicjob:onCaroOwner", vehOwner, vehId, true)
		xPlayer.showNotification('No puedes reparar la carrocería completamente, te faltan herramientas ~r~de carrocería')
	end
end)

--[[ ============================================================ ]]--
--[[ |       FIVEM ESX DELIVERY PLUGIN REMAKE BY AKKARIIN       | ]]--
--[[ ============================================================ ]]--

ESX = nil

ESX = exports.extendedmode:getSharedObject()

-- Register events

RegisterServerEvent('esx_deliveries:returnSafe:server')
RegisterServerEvent('esx_deliveries:finishDelivery:server')
RegisterServerEvent('esx_deliveries:removeSafeMoney:server')
RegisterServerEvent('esx_deliveries:getPlayerJob:server')

-- Return safe deposit event

AddEventHandler('esx_deliveries:returnSafe:server', function(deliveryType, safeReturn)
	local xPlayer = ESX.GetPlayerFromId(source)
	if safeReturn then
		local SafeMoney = 4000
		for k, v in pairs(Config.Safe) do
			if k == deliveryType then
				SafeMoney = v
				break
			end
		end
		xPlayer.addAccountMoney("bank", SafeMoney)
		xPlayer.showNotification(_U("safe_deposit_returned"))
	else
		xPlayer.showNotification(_U("safe_deposit_withheld"))
	end
end)

AddEventHandler('esx_deliveries:finishDelivery:server', function(deliveryType)
    local xPlayer = ESX.GetPlayerFromId(source)
	local deliveryMoney = 800
	for k, v in pairs(Config.Rewards) do
		if k == deliveryType then
			deliveryMoney = v
			break
		end
	end
    xPlayer.addMoney(deliveryMoney)
	xPlayer.showNotification(_U("delivery_point_reward") .. tostring(deliveryMoney))
end)

AddEventHandler('esx_deliveries:removeSafeMoney:server', function(deliveryType)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    math.randomseed(os.time())
    local rnd = math.random(1, #Config.ParkingSpawns)
	local SpawnLocation = Config.ParkingSpawns[rnd]
    if xPlayer.getJob().name == "delivery" and #(xPlayer.getCoords(true) - SpawnLocation) < 30 then
		Citizen.CreateThread(function() 
			local owningOptional = isOwningOptionalVehicle(xPlayer, deliveryType)
			print(owningOptional, SpawnLocation)
			if owningOptional then
				local optVeh = ESX.GetVehicleByPlate(owningOptional)
				optVeh.setCoords(SpawnLocation)
				print(optVeh.getCoords())
				if not optVeh.isSpawned() then
					optVeh.spawnVehicle()
				end
				TriggerClientEvent('esx_deliveries:startJob:client', _source, deliveryType, optVeh.netId)
				xPlayer.showNotification('Has solicitado tu propio vehiculo para el transporte.')
			else
				xPlayer.showNotification('~r~No tienes ese vehiculo!')
			end
		end)
	end
end)

AddEventHandler('esx_deliveries:getPlayerJob:server', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_deliveries:setPlayerJob:client', source, xPlayer.getJob().name)
end)

RegisterServerEvent("esx_deliveries:returnVehicle")
AddEventHandler("esx_deliveries:returnVehicle", function(vehId) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "delivery" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
		if vehId then
			local veh = NetworkGetEntityFromNetworkId(vehId)
			if DoesEntityExist(veh) then
				local owner = Entity(veh).state.owner
				local plateOwner = isOwningOptionalVehicle(xPlayer)
				if owner and  owner == xPlayer.getIdentifier() then
					xPlayer.addMoney(fianzaPerPart)
					DeleteEntity(veh)
					xPlayer.showNotification('Se te ha devuelto la fianza del vehiculo')
				elseif plateOwner then
					local xVehicle = ESX.GetVehicleByPlate(plateOwner)
					xVehicle.deSpawn()
					xPlayer.showNotification('Tu camión ha sido guardado')
				else
					xPlayer.showNotification("No puedes devolver este vehículo")
				end
			end
		end
	end
end)

RegisterServerEvent("esx_deliveries:getVehicle")
AddEventHandler("esx_deliveries:getVehicle", function(model) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "delivery" and #(xPlayer.getCoords(true) - Config.ParkingSpawns) < 30 then
		local _source = source
		Citizen.CreateThread(function() 
			local owningOptional = isOwningOptionalVehicle(xPlayer, model)

			if owningOptional then
				local optVeh = ESX.GetVehicleByPlate(owningOptional)
				optVeh.setCoords(Config.vehicleSpawns.trailer)
				if not optVeh.isSpawned() then
					optVeh.spawnVehicle()
				end
				--hauler.setHeading(spawnh)
				xPlayer.showNotification('Has solicitado tu propio vehiculo para el transporte, recibirás un plus en las entregas')
			else
				local plat = ExM.Game.SpawnVehicle(Config.Models[model], Config.vehicleSpawns.trailer)
				while not DoesEntityExist(plat) do
					Wait(500)
				end
				TriggerEvent("garage:addKeys", GetVehicleNumberPlateText(plat), xPlayer.source)
				Wait(5000)
				Entity(plat).state.owner = xPlayer.getIdentifier()
				xPlayer.removeMoney(fianzaPerPart)
				xPlayer.showNotification('Se te ha cobrado una fianza de ~g~'..fianzaPerPart..' $ devuelve el vehiculo para recuperarla')
			end
		end)
	end
end)

function isOwningOptionalVehicle(xPlayer, model)
	local vehicles = xPlayer.get("vehicles")
	local owningVehicle = false
	for k,v in pairs(vehicles) do
		if v.model == Config.Models[model] then
			owningVehicle = v.plate
			break
		end
	end
	return owningVehicle
end
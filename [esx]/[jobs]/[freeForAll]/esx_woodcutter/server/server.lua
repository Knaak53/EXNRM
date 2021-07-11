ESX = nil
peopleCuttingWood = {}
fianzaPerPart = 200

ESX = exports.extendedmode:getSharedObject()
ExM = exports.extendedmode:getExtendedModeObject()

Config.Rewards = {
	deliveryLogs = 100,
	deliveryPallet = 100,
	hachetReward = 50,
	hauletReward = 200,
}

Config.Pallets = {
	[1] = {coords = vector3(603.07, 6461.81, 30.24), heading = 0.0 , pallet = false},
	[2] = {coords = vector3(603.25, 6464.52, 30.196), heading = 0.0, pallet = false},
	[3] = {coords = vector3(603.3, 6467.84, 30.1), heading = 0.0, pallet = false},
	[4] = {coords = vector3(603.46, 6458.828, 30.10), heading = 0.0, pallet = false},
	[5] = {coords = vector3(660.78, 6470.49, 30.10), heading = 0.0, pallet = false},
	--[6] = {coords = vector3(738.021, 6476.0, 28.45), heading = 0.0},
	--[7] = {coords = vector3(720.29, 6477.561, 28.85), heading = 0.0},
	--[8] = {coords = vector3(700.172, 6478.396, 29.25), heading = 0.0},
	--[9] = {coords = vector3(679.982, 6478.194, 30.0), heading = 0.0},
	--[10] = {coords = vector3(660.409, 6478.114, 30.50), heading = 0.0}
}

Config.scriptJobs = {
	woodcutter = true
}

function isValidJob(job)
	if Config.scriptJobs[job] then
		return true
	end
	return false
end

Config.delivercoords = vector3(-575.43, 5318.732, 70.215)

local Trailers = {}
local Forklifts = {}


RegisterServerEvent("palletDevlivered")
AddEventHandler("palletDevlivered", function() 
	local xPlayer = ESX.GetPlayerFromId(source)
	if isValidJob(xPlayer.getJob().name) and #(Config.DropZone.coords - xPlayer.getCoords(true)) < Config.DropZone.area then
		--TODO comprobaciones xtaras SetParticleFxCamInsideNonplayerVehicle(p0, p1)
		xPlayer.addMoney(Config.Rewards.deliveryPallet)
		xPlayer.showNotification('Has recibido ~g~'..Config.Rewards.deliveryPallet.. " $ ~w~ por entregar pallets de madera")
		if isOwningOptionalVehicle(xPlayer) then
			xPlayer.addMoney(Config.Rewards.deliveryPallet)
			xPlayer.showNotification('Has recibido un bonus de ~g~'..Config.Rewards.deliveryPallet.. " $ ~w~ por usar tu propio trailer")
		end
	end
end)

RegisterServerEvent("esx_woodcutter:logsReady")
AddEventHandler("esx_woodcutter:logsReady", function(count, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	print("jobs ".. job .." ".. xPlayer.getJob().name)
	print("num ".. count .." ".. xPlayer.getJob().name)
	local put = false
	if tonumber(count) >= 4 and job == xPlayer.getJob().name then
		for k,v in pairs(Config.Pallets) do
			if not v.pallet then
				Config.Pallets[k].pallet = true
				TriggerClientEvent("esx_woodcutter:logsReady", source, k,  "wood", v.coords)
				--TODO plus reward hatchet
				xPlayer.addMoney(Config.Rewards.deliveryLogs)
				xPlayer.showNotification('Has recibido ~g~'..Config.Rewards.deliveryLogs.. " $ ~w~ por entregar troncos")
				put = true
				break
			end
		end
	end
	if not put then
		xPlayer.showNotification('¡Hay demasiados pallets, recoje alguno!')
	end
end)

RegisterServerEvent("esx_woodcutter:palletPosFree")
AddEventHandler("esx_woodcutter:palletPosFree", function(pos, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	if job == xPlayer.getJob().name and type(pos) == "number" and pos < #Config.Pallets + 1 then
		Config.Pallets[pos].pallet = false
	end
end)

RegisterServerEvent('leñar:doymadera')
AddEventHandler('leñar:doymadera', function(madera)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)	
		xPlayer.addInventoryItem(madera, 1)
end)

RegisterServerEvent("esx_woodcutter:getPlatform")
AddEventHandler("esx_woodcutter:getPlatform", function() 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "woodcutter" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
		local _source = source
		Citizen.CreateThread(function() 
			local plat = ExM.Game.SpawnVehicle("TRFLAT", Config.vehicleSpawns.platform)
			Wait(5000)
			Entity(plat).state.owner = xPlayer.getIdentifier()
			xPlayer.removeMoney(fianzaPerPart)
			xPlayer.showNotification('Se te ha cobrado una fianza de ~g~'..fianzaPerPart..' $ devuelve la plataforma para recuperarla')
		end)
	end
end)

RegisterServerEvent("esx_woodcutter:getForklift")
AddEventHandler("esx_woodcutter:getForklift", function() 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "woodcutter" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
		local _source = source
		Citizen.CreateThread(function() 
			local plat = ExM.Game.SpawnVehicle("forklift", Config.vehicleSpawns.forklift)
			while not DoesEntityExist(plat) or NetworkGetEntityOwner(plat) < 1 do
				Wait(500)
			end
			SetVehicleDoorsLocked(plat, 2)
			print("plate: "..GetVehicleNumberPlateText(plat))
			print("id: "..xPlayer.source)
			TriggerEvent("garage:addKeys", GetVehicleNumberPlateText(plat), xPlayer.source)
			Wait(5000)
			Entity(plat).state.owner = xPlayer.getIdentifier()
			xPlayer.removeMoney(fianzaPerPart)
			xPlayer.showNotification('Se te ha cobrado una fianza de ~g~'..fianzaPerPart..' $ devuelve el toro para recuperarla')
		end)
	end
end)

RegisterServerEvent("esx_woodcutter:returnTrailer")
AddEventHandler("esx_woodcutter:returnTrailer", function(vehId) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "woodcutter" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
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

RegisterServerEvent("esx_woodcutter:returnForklift")
AddEventHandler("esx_woodcutter:returnForklift", function(vehId) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "woodcutter" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
		if vehId then
			local veh = NetworkGetEntityFromNetworkId(vehId)
			if DoesEntityExist(veh) then
				print("hasta aqui llego y tal")
				local owner = Entity(veh).state.owner
				local plateOwner = isOwningOptionalVehicle(xPlayer)
				if owner and owner == xPlayer.getIdentifier() then
					xPlayer.addMoney(fianzaPerPart)
					DeleteEntity(veh)
					xPlayer.showNotification('Se te ha devuelto la fianza del vehiculo')
				else
					xPlayer.showNotification("No puedes devolver este vehículo")
				end
			end
		end
	end
end)

RegisterServerEvent("esx_woodcutter:returnPlatform")
AddEventHandler("esx_woodcutter:returnPlatform", function(vehId) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "woodcutter" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
		if vehId then
			local veh = NetworkGetEntityFromNetworkId(vehId)
			if DoesEntityExist(veh) then
				local owner = Entity(veh).state.owner
		
				if owner and owner == xPlayer.getIdentifier() then
					xPlayer.addMoney(fianzaPerPart)
					DeleteEntity(veh)
					xPlayer.showNotification('Se te ha devuelto la fianza del vehiculo')
				else
					xPlayer.showNotification("No puedes devolver este vehículo")
				end
			end
		end
	end
end)

RegisterServerEvent("esx_woodcutter:getTrailer")
AddEventHandler("esx_woodcutter:getTrailer", function() 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "woodcutter" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
		local _source = source
		Citizen.CreateThread(function() 
			local owningHauler = isOwningOptionalVehicle(xPlayer)

			if owningHauler then
				local hauler = ESX.GetVehicleByPlate(owningHauler)
				hauler.setCoords(Config.vehicleSpawns.trailer)
				if not hauler.isSpawned() then
					hauler.spawnVehicle()
				end
				--hauler.setHeading(spawnh)
				xPlayer.showNotification('Has solicitado tu propio vehiculo para el transporte, recibirás un plus en las entregas')
			else
				local plat = ExM.Game.SpawnVehicle("hauler", Config.vehicleSpawns.trailer)
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

function isOwningOptionalVehicle(xPlayer)
	local vehicles = xPlayer.get("vehicles")
	local owningHauler = false
	for k,v in pairs(vehicles) do
		if v.model == "hauler" then
			owningHauler = v.plate
		end
	end
	return owningHauler
end

AddEventHandler("onResourceStart", function(resourceName)
	if GetCurrentResourceName() == resourceName then
		--Citizen.CreateThread(function() 
		--	for k,v in pairs(Config.platforms) do
		--		Trailers[k] = ExM.Game.SpawnVehicle("TRFLAT", vector3(v.x, v.y, v.z))
		--		Wait(5000)
		--		SetEntityHeading(Trailers[k], v.w)
		--		--exports['enc0ded-forklift-trailer']:SpawnTrailer(v.x, v.y, v.z)
		--		--local forklift = exports['enc0ded-forklift-trailer']:SpawnTrailer()
		--	end
		--	for k,v in pairs(Config.forklift) do
		--		Forklifts[k] = ExM.Game.SpawnVehicle("forklift", vector3(v.x, v.y, v.z))
		--		Wait(5000)
		--		SetEntityHeading(Forklifts[k], v.w)
		--		--exports['enc0ded-forklift-trailer']:SpawnForklift(v.x, v.y, v.z)
		--		--local forklift = exports['enc0ded-forklift-trailer']:SpawnTrailer()
		--	end
		--end)
	end
end)
--RegisterServerEvent("startWoodCutterJob")
--AddEventHandler("startWoodCutterJob", function(job) 
--	local xPlayer = ESX.GetPlayerFromId(source)
--
--	if xPlayer.getJob().name == "woodcutter" and xPlayer.getJob().name == job then
--		local Vehicles = xPlayer.GetVehicles()
--
--		for k,v in pairs(Vehicles) do
--
--		end
--	end
--end)

RegisterServerEvent('leñar:recibodata')
AddEventHandler('leñar:recibodata',function(data)
	maderas = data
	TriggerClientEvent('leñar:recibodatacliente',-1,data)
end)

ESX.RegisterServerCallback("esx_woodcutter:getWoodReward", function(source, cb, min, max)
	math.randomseed(os.time())
	cb(math.random(min, max))
end)

RegisterServerEvent("esx_woodcutter:treeFall")
AddEventHandler("esx_woodcutter:treeFall",function(treeId)
	local _source = source
	for k,v in pairs(peopleCuttingWood) do
		if k ~= _source and v then
			TriggerClientEvent("esx_woodcutter:makeTreeFall", k, treeId)
		end
	end
end)

RegisterServerEvent("esx_woodcutter:startJob")
AddEventHandler("esx_woodcutter:startJob",function()
	local _source = source
	peopleCuttingWood[_source] = true
	print("hola")
end)

RegisterServerEvent("esx_woodcutter:endJob")
AddEventHandler("esx_woodcutter:endJob",function()
	local _source = source
	peopleCuttingWood[_source] = false
	print("adios")
end)

RegisterServerEvent('leñar:quitomad')
AddEventHandler('leñar:quitomad',function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	for i = 1, #xPlayer.inventory,1 do
		if xPlayer.inventory[i].name == "maderag" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(12,17))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
			end
		elseif xPlayer.inventory[i].name == "maderam" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(10,15))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
			end
		elseif xPlayer.inventory[i].name == "maderaf" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(9,12))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
			end
		elseif xPlayer.inventory[i].name == "madera" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(6,9))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
			end
		end
	end
end)






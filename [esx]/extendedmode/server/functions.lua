ESX.Trace = function(msg)
	if Config.EnableDebug then
		print(('[ExtendedMode] [^2TRACE^7] %s^7'):format(msg))
	end
end

ESX.getJobs = function()
	return ESX.Jobs
end

ESX.setJobs = function(Jobs)
	ESX.Jobs = Jobs
end

ESX.getItems = function()
	return ESX.Items
end

ESX.getsData = function()
	return ESX.sData
end

--ESX.getVehicleWeightLimit = function(model)
--
--	return Config.VehicleWeightLimit[]
--end


function ckPlayer(identifier)
	print("eliminando")
	if identifier then
		ESX.exposedDB.getDocument(GetHashKey(identifier), function(result) 
			print("obtenido")
			if result then
				--vehiculos
				print("vamos allá")
				if result.variables.vehicles then
					print("vamos vehiculos")
					for k,v in pairs(result.variables.vehicles) do
						print("vamos vehiculos"..1)
						ESX.exposedDB.deleteDocument(GetHashKey(v.plate), function(result)
							if result then
								print("Vehicle deleted")
							else
								print("eing")
							end
						end)
					end
				end

				if result.variables.house then
					print("vamos casa")
					local houses = ESX.sData.get("bought_houses")
					for k,v in pairs(houses) do
						if v == result.variables.house then
							table.remove(houses,k)
						end
					end
				end

				ESX.exposedDB.deleteDocument(GetHashKey("addon_inventories_" .. result.identifier), function(result) 
					if result then
						print("addon_inventory deleted")
					else
						print("eing")
					end
				end)

				ESX.exposedDB.deleteDocument(GetHashKey("datastore_" .. result.identifier), function(result) 
					if result then
						print("datastore deleted")
					else
						print("eing")
					end
				end)
			ESX.exposedDB.deleteDocument(GetHashKey(identifier), function(r)
				if r then
					print("user deleted")
				end
			end)
			end
		
		end)
	else
		print("FFF")
	end
end

ESX.SetTimeout = function(msec, cb)
	local id = ESX.TimeoutCount + 1

	SetTimeout(msec, function()
		if ESX.CancelledTimeouts[id] then
			ESX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	ESX.TimeoutCount = id

	return id
end
---Sound
ESX.PlaySoundOnAll = function(soundFile,soundVolume)
	TriggerClientEvent('esx:PlaySoundOnPlayer',-1,soundFile,soundVolume)
end

ESX.PlaySoundOnOne = function(source,soundFile,soundVolume)
	TriggerClientEvent('esx:PlaySoundOnPlayer',source,soundFile,soundVolume)
end

ESX.PlayWithinDistance = function(maxDistance,soundFile,soundVolume,targetSource)
	TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, targetSource, maxDistance, soundFile, soundVolume)
end

ESX.getActiveWorkers = function(job)
	if ESX.getActiveWorkers[job] ~= nil then
		return ESX.getActiveWorkers[job]
	else
		return {}
	end
	
end


ESX.RegisterLogCommand = function(adminName, admingroup, commandName, commandReason)
	ESX.exposedDB.getDocument(GetHashKey("commandLog"), function(result) 
		if result then
			if result[adminName] == nil then
				result[adminName] = {}
			end
			table.insert(result[adminName], { admin = adminName , group = admingroup, command = commandName, reason =commandReason})
			if result[commandName] == nil then
				result[commandName] = {}
			end
			table.insert(result[commandName], { admin = adminName , group = admingroup, command = commandName, reason = commandReason})
			ESX.exposedDB.updateDocumentWithRev(GetHashKey("commandLog"),
				result
			,function()
				if not result then
					print("^1Error logging command: "..commandName.. " throwed by "..adminName .. "^7")
				end
			end)
		else
			ESX.exposedDB.updateOrCreateDocument(GetHashKey("commandLog"),
			{ 
				[adminName] = { {admin = adminName , group = admingroup, command = commandName, reason = commandReason}},
				[commandName] = { {admin = adminName , group = admingroup, command = commandName, reason = commandReason}}
			} 
			,function(result)
				if result then
					print("^2 Command logging initialized successfully^7")
				else
					print("^1 Command logging error during setup up^7")
				end
			end)
		end
	end)
end

ESX.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for k,v in pairs(name) do
			ESX.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if ESX.RegisteredCommands[name] then
		print(('[ExtendedMode] [^3WARNING^7] An command "%s" is already registered, overriding command'):format(name))

		if ESX.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then suggestion.arguments = {} end
		if not suggestion.help then suggestion.help = '' end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	ESX.RegisteredCommands[name] = {group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion}

	RegisterCommand(name, function(source, args, rawCommand)
		print("id: "..source)
		local command = ESX.RegisteredCommands[name]

		if not command.allowConsole and source == 0 then
			print(('[ExtendedMode] [^3WARNING^7] %s'):format(_U('commanderror_console')))
		else
			local xPlayer, error
			if source == 0 then
				xPlayer, error = ESX.GetPlayerFromId(args[1]), nil
			else
				xPlayer, error = ESX.GetPlayerFromId(source), nil
			end
			
			--print("Player: "..xPlayer.getName())
			if command.suggestion then
				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments then
						error = _U('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
					end
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k,v in pairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' then targetPlayer = source end

								if targetPlayer then
									local xTargetPlayer = ESX.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = _U('commanderror_invalidplayerid')
									end
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								newArgs[v.name] = args[k]
							elseif v.type == 'item' then
								if ESX.Items[args[k]] then
									newArgs[v.name] = args[k]
								else
									error = _U('commanderror_invaliditem')
								end
							elseif v.type == 'weapon' then
								if ESX.GetWeapon(args[k]) then
									newArgs[v.name] = string.upper(args[k])
								else
									error = _U('commanderror_invalidweapon')
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							end
						end

						if error then break end
					end

					args = newArgs
				end
			end

			if error then
				if source == 0 then
					print(('[ExtendedMode] [^3WARNING^7] %s^7'):format(error))
				else
					xPlayer.triggerEvent('chat:addMessage', {args = {'^1SYSTEM', error}})
				end
			else
				cb(xPlayer or false, args, function(msg)
					if source == 0 then
						print(('[ExtendedMode] [^3WARNING^7] %s^7'):format(msg))
					else
						xPlayer.triggerEvent('chat:addMessage', {args = {'^1SYSTEM', msg}})
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for k,v in pairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.RegisterServerCallback = function(name, cb)
	ESX.ServerCallbacks[name] = cb
end

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ESX.ServerCallbacks[name] then
		ESX.ServerCallbacks[name](source, cb, ...)
	else
		print(('[ExtendedMode] [^3WARNING^7] Server callback "%s" does not exist. Make sure that the server sided file really is loading, an error in that file might cause it to not load.'):format(name))
	end
end

ESX.SavePlayer = function(xPlayer, cb)
	if ExM.DatabaseType == "exm+couchDB" then
		db.updateUser(xPlayer.getIdentifier(), 
			{
				accounts = xPlayer.getAccounts(true),
				job = xPlayer.getJob().name,
				job_grade = xPlayer.getJob().grade,
				group = xPlayer.getGroup(),
				loadout = xPlayer.getLoadout(true),
				position = xPlayer.getCoords(),
				identifier = xPlayer.getIdentifier(),
				inventory = xPlayer.getInventory(true),
				variables = xPlayer.getPlayerVariables()
	}, function(result)
		if result then
			cb(1)
			if Config.EnableDebug then
				print("Actualizado? "..result)
			end
		else
			print("Error Saving Player: ".. xPlayer.getIdentifier())
		end
	end)
	elseif ExM.DatabaseType == "newesx" then
		MySQL.Async.execute('UPDATE users SET accounts = @accounts, job = @job, job_grade = @job_grade, `group` = @group, loadout = @loadout, position = @position, inventory = @inventory WHERE identifier = @identifier', {
			['@accounts'] = json.encode(xPlayer.getAccounts(true)),
			['@job'] = xPlayer.job.name,
			['@job_grade'] = xPlayer.job.grade,
			['@group'] = xPlayer.getGroup(),
			['@loadout'] = json.encode(xPlayer.getLoadout(true)),
			['@position'] = json.encode(xPlayer.getCoords()),
			['@identifier'] = xPlayer.getIdentifier(),
			['@inventory'] = json.encode(xPlayer.getInventory(true))
		}, cb)
	end
end

ESX.SaveVehicle = function(xVehicle, cb)
	print("saving vehicles")
	if ExM.DatabaseType == "exm+couchDB" then
		exposedDB.updateOrCreateDocument(GetHashKey(xVehicle.plate), 
		xVehicle.getSaveableData()
		,function(result)
			if result then
				cb(1)
				if Config.EnableDebug then
					print("Actualizado? Vehicle?"..result)
				end
			else
				print("Error Saving Vehicle: ".. xVehicle.plate)
			end
		end)
	end
end

ESX.SavePlayers = function(finishedCB)
	Citizen.CreateThread(function()
		local savedPlayers = 0
		local playersToSave = #ESX.Players
		local maxTimeout = 20000
		local currentTimeout = 0
	
		-- Save Each player
		for _, xPlayer in pairs(ESX.Players) do
			ESX.SavePlayer(xPlayer, function(rowsChanged)
				if rowsChanged == 1 then
					savedPlayers = savedPlayers	+ 1
				end
			end)
		end

		-- Call the callback when done
		while true do
			Citizen.Wait(500)
			currentTimeout = currentTimeout + 500
			if playersToSave == savedPlayers then
				finishedCB(true)
				break
			elseif currentTimeout >= maxTimeout then
				finishedCB(false)
				break
			end
		end
	end)
end

ESX.SaveVehicles = function(finishedCB)
	Citizen.CreateThread(function()
		local savedVehicles = 0
		local VehiclesToSave = tablelength(ESX.Vehicles)
		local maxTimeout = 30000
		local currentTimeout = 0
	
		-- Save Each Vehicle
		print("Vehicles to save: "..VehiclesToSave)
		for _, xVehicle in pairs(ESX.Vehicles) do
			print("Recorro: "..xVehicle.plate)
			if xVehicle.getPlayerOwner() then
				print("Salvo: "..xVehicle.plate)
				ESX.SaveVehicle(xVehicle, function(rowsChanged)
					if rowsChanged == 1 then
						savedVehicles = savedVehicles	+ 1
					end
				end)
			end
		end

		-- Call the callback when done
		while true do
			Citizen.Wait(500)
			currentTimeout = currentTimeout + 500
			if VehiclesToSave == savedVehicles then
				finishedCB(true)
				break
			elseif currentTimeout >= maxTimeout then
				finishedCB(false)
				break
			end
		end
	end)
end

ESX.StartDBSync = function()
	function saveData()
		ESX.SavePlayers(function(result)
			if result then
				print('[ExtendedMode] [^2INFO^7] Automatically saved all player data')
			else
				print('[ExtendedMode] [^3WARNING^7] Failed to automatically save player data! This may be caused by an internal error on the MySQL server.')
			end
		end)
		ESX.SaveVehicles(function(result)
			if result then
				print('[ExtendedMode] [^2INFO^7] Automatically saved all Vehicles data')
			else
				print('[ExtendedMode] [^3WARNING^7] Failed to automatically save Vehicles data! This may be caused by an internal error on the MySQL server.')
			end
		end)
		ESX.sData.save()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end

ESX.AddVehicle = function(ExtendedCar)
	if ESX.Vehicles[ExtendedCar.plate] == nil then
		ESX.Vehicles[ExtendedCar.plate] = ExtendedCar
	else
		print('[ExtendedMode] [^3WARNING^7] Vehicle with plate '..ExtendedCar.plate..' tried to be created but already exists, spawn it instead?')
	end
end

-- WARNING: THE COST OF THIS FUNCTION IS EXCESIVE, AVOID IT AND USE WITH CAUTION
ESX.GetVehicles = function(owned)
	local vehicles = {}
	
	
	for k,v in pairs(ESX.Vehicles) do
		if owned then
			if v.getPlayerOwner() then
				table.insert(vehicles, v)
			end
		else
			table.insert(vehicles, v)
		end
	end
	return vehicles
end

ESX.GetPlayerFromId = function(source)
	return ESX.Players[tonumber(source)]
end

--HIGHT COST, TRY `GetVehicleByPlate` WHEN POSSIBLE
ESX.GetVehicleByNetId = function(netId)
	local vehicles = ESX.Vehicles

	for k,v in pairs(vehicles) do
		if v.netId == netId then
			return v
		end
	end
end

ESX.GetVehiclesByJob = function(jobname)
	local vehicles = {}
	for k,v in pairs(ESX.Vehicles) do
		if v.getJob() == jobname then
			table.insert(vehicles, v)
		end
	end
	return vehicles
end

-- BEST WAY TO GET A VEHICLE
ESX.GetVehicleByPlate = function(plate)
	if ESX.Vehicles[plate] then
		return ESX.Vehicles[plate]
	end
end

ESX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(ESX.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

ESX.GetPlayerFromPhoneNumber = function(phoneNumber)
	for k,v in pairs(ESX.Players) do
		if v.get("phone_number") == phoneNumber then
			return v
		end
	end
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item)
	ESX.UsableItemsCallbacks[item](source)
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] then
		return ESX.Items[item].label
	end
end

ESX.CreatePickup = function(type, name, count, label, playerId, components, tintIndex,model, serial)
    local pickupId = (ESX.PickupId == 65635 and 0 or ESX.PickupId + 1)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local pedCoords
    
    if ExM.IsInfinity then
        pedCoords = GetEntityCoords(GetPlayerPed(playerId))
    end

    ESX.Pickups[pickupId] = {
        type  = type,
        name  = name,
        count = count,
        label = label,
        coords = xPlayer.getCoords(),
    }
	print("pickup id: creating "..pickupId)
	
	if type == 'item_weapon' then
		print("pickup id: components "..pickupId)
		print("components creating: ".. json.encode(components))
		ESX.Pickups[pickupId].components = components
		print(json.encode(ESX.Pickups[pickupId].components))
		ESX.Pickups[pickupId].tintIndex = tintIndex
		ESX.Pickups[pickupId].serial = serial
	end
	

    TriggerClientEvent('esx:createPickup', -1, pickupId, label, playerId, type, name, components, tintIndex, ExM.IsInfinity, pedCoords, model)
    ESX.PickupId = pickupId
end

ESX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

if ExM.IsOneSync then
	ExM.Game = {}

	AddEventHandler("esx:spawnserversidevehicle", function(model,coords, plate)
		local veh = ExM.Game.SpawnVehicle(model, coords)

		
	end)

	
	AddEventHandler("esx:deleteSVehicle", function(netid) 
		local ent = NetToVeh(netid)
		if DoesEntityExist(ent) then
			DeleteVehicle(ent)
		end
	end)

	local CreateVehicle = GetHashKey('CREATE_AUTOMOBILE')
	ExM.Game.SpawnVehicle = function(model, coords, plate)
		local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0)
		local vehMod = type(model) == "number" and model or type(model) == "string" and GetHashKey(model)
		local veh = Citizen.InvokeNative(CreateVehicle , vehMod, vector.xyzw)
		if plate then
			Citizen.CreateThread(function()
				if not DoesEntityExist(veh) then
					Wait(500)
				end
				SetVehicleNumberPlateText(veh, plate)
			end)
		end
		return veh
	end

	ExM.Game.CreatePed = function(pedModel, pedCoords, pedType)
		local vector = type(pedCoords) == "vector4" and pedCoords or type(pedCoords) == "vector3" and vector4(pedCoords, 0.0)
		pedType = pedType ~= nil and pedType or 4
		return CreatePed(pedType, pedModel, vector.xyzw, true)
	end

	ExM.Game.SpawnObject = function(model, coords, dynamic)
		model = type(model) == 'number' and model or GetHashKey(model)
		dynamic = dynamic ~= nil and true or false
		return CreateObjectNoOffset(model, coords.xyz, true, dynamic)
	end
end
--TODO CUANDO SE COMPRE O VENDA ACTUALIZAR LA CACHE A LA PERSONA
ESX = nil
ExM = nil
ParkingsCache = {} --Cache de los parkings
ESX = exports.extendedmode:getSharedObject()
ExM = exports.extendedmode:getExtendedModeObject()
NeedUpdate = false
PlayersCars = {}
CoordsPositions = {}

WhitelistGarageJobs = 
{
	"mechanic"
}

function isWhiteJob(source, jobname, cb)
	local found = false
	for k,v in pairs(WhitelistGarageJobs) do
		if v == jobname then
			TriggerEvent("esx_service:isPlayerInService", function(inService) 
				if inService then
					found = true
					cb(true)
				else
					found = true
					cb(false)
				end
			end,jobname, source)
		end
	end
	if not found then
		cb(false)
	end
end

Citizen.CreateThread(function()
	while true do
		if NeedUpdate then
			ESX.exposedDB.updateOrCreateDocument(GetHashKey("Parkings"),{parkings = ParkingsCache}, function(result)
				if result then
					NeedUpdate = false
					print("^2 Updated Parkings database^7")
				else
					print("^2 Error updatng parkings^7")
				end
			end)
			
		end
		Citizen.Wait(10000)
	end
end)

RegisterServerEvent('caronte_parkings:takecar')
AddEventHandler('caronte_parkings:takecar', function(properties, coords, heading,plate) 
	--CreateVehicle(model, coords.xyz, heading, isNetwork, p6)
	local vProperties = json.decode(properties)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xVehicle = ESX.GetVehicleByPlate(plate)
	print("vehicle before: "..json.encode(xVehicle))
	VehicleBelognsTo(xPlayer,vProperties.plate, function(result)
		isWhiteJob( xPlayer.source, xPlayer.getJob().name, function(iswhite) 
			print("iswhite: "..json.encode(iswhite))
			--print("vehicle: "..json.encode(xVehicle.plate))
			print("result: ".. json.encode(result))
			if result or (iswhite) then
				Citizen.CreateThread(function() 
					local _source = source
					local _heading = heading
					local xVehicle = ESX.GetVehicleByPlate(vProperties.plate)
					local vector = vector4(coords.x,coords.y,coords.z, _heading)
					xVehicle.setCoords(vector)
					xVehicle.spawnVehicle(true)
					xVehicle.warpPed(GetPlayerPed(xPlayer.source), ESX.VehicleSeats.DRIVER)
					xVehicle.setHeading(vector)
					xVehicle.unparkGarageVehicle()
					--local veh = ExM.Game.SpawnVehicle(vProperties.model, coords)
					--while not DoesEntityExist(veh) do
					--	Wait(400)
					--end
					--SetEntityHeading(veh, _heading)
					--SetVehicleNumberPlateText(veh, vProperties.plate)
					--TaskWarpPedIntoVehicle(GetPlayerPed(_source), veh, -1) -- i think this incudec the crash
					local ownedby = NetworkGetEntityOwner(veh)
					print(ownedby)
					TriggerClientEvent("caronte_parkings:carspawnready", ownedby, NetworkGetNetworkIdFromEntity(veh), json.encode(vProperties))
					print("Warping to id:".. xPlayer.source)
					--TriggerClientEvent("caronte_parkings:warpToVehIfPending", xPlayer.source, NetworkGetNetworkIdFromEntity(veh))
				end)
			end
		end)
	end)
end)

RegisterServerEvent('s2v_parkings:enterParking')
AddEventHandler('s2v_parkings:enterParking',function(CurrentFloor,CurrentParking,playersInVehicle)
	for k,v in pairs(playersInVehicle) do
		TriggerClientEvent('s2v_parkings:enterParkingcl',v,CurrentFloor,CurrentParking)
	end
end)

RegisterServerEvent('s2v_parkings:exitParking')
AddEventHandler('s2v_parkings:exitParking',function(players)
	for k,v in pairs(players) do
		TriggerClientEvent('s2v_parkings:exitParkingcl',v)
	end
end)

ESX.RegisterServerCallback('s2v_parkings:requireConfig',function(source,cb)
	cb(Config.garages)
end)

--Guardado del coche en el parking y sincronizacion
--Comprobamos que el coche sea de la persona si lo es lo guardamos y hacemos lo necesario en cliente si no decimos que no es suyo es mas tenemos
--Que actualizar los markers y hacer que el persistent lo olvide
ESX.RegisterServerCallback('s2v_parkings:parkVehicle',function(source,cb,vehicle,_floor,_parking,_place,heading)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xVehicle = ESX.GetVehicleByPlate(vehicle.plate)
	VehicleBelognsTo(xPlayer,vehicle.plate,function(result)
		-- MANUEEEHH AQUI
		isWhiteJob(source, xPlayer.getJob().name, function(iswhite) 
			if result or (iswhite and xVehicle) then
				if iswhite and xPlayer.get("vehicles")[vehicle.plate] == nil  then
					xVehicle.impoundGarageVehicle()
				else
					xVehicle.parkGarageVehicle()
				end
				TriggerClientEvent('s2v_parkings:QuitMarkerPeopleInFloor',-1,_parking,_floor,_place) --Quita el marker si estas en la plaza
				GetParkingPlace(_parking,_floor,_place).vehicle = vehicle
				GetParkingPlace(_parking,_floor,_place).state = true
				GetParkingPlace(_parking,_floor,_place).heading = heading
				TriggerClientEvent('s2v_parkings:SyncPlaces',-1,json.encode(ParkingsCache)) --Sincronizamos la cache con los clientes
				NeedUpdate = true
				--SaveLastData(ParkingsCache)
				cb(true)
			else
				cb(false)
			end
		end)
	end)
		
end)

ESX.RegisterServerCallback("s2v_parkings:takeVehicle",function(source,cb,vehicle,_floor,_parking,_place)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xVehicle = ESX.GetVehicleByPlate(vehicle.plate)
	VehicleBelognsTo(xPlayer,vehicle.plate,function(result)
		isWhiteJob(source, xPlayer.getJob().name, function(iswhite) 
			if result or (iswhite and xVehicle) then
				--print("Entro aqui")
				TriggerClientEvent('s2v_parkings:AddMarkerPeopleInFloor',-1,_parking,_floor,_place)
				local fuel = GetParkingPlace(_parking,_floor,_place).vehicle.fuel
				--Borrar de cache que esta ese vehiculo y poner el marker disponible
				GetParkingPlace(_parking,_floor,_place).vehicle = {} --Coger de aqui el fuel antes de borrarlo para enviarlo en la cb
				GetParkingPlace(_parking,_floor,_place).state = false
				GetParkingPlace(_parking,_floor,_place).heading = 0.0
				TriggerClientEvent('s2v_parkings:SyncPlaces',-1,json.encode(ParkingsCache))
				NeedUpdate = true
				--SaveLastData(ParkingsCache)
				cb(true,fuel)
			else
				cb(false)
			end
		end)
	end)

end)

--Carga de la base de datos
AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	ESX.exposedDB.getDocument(GetHashKey("Parkings"),function(resultado)
		local tableUpdate = {}
		if not resultado then --Si no existe la tabla parkings la creamos y la seteamos en el documento // resultado devuelve false si no hay datos no un nil //en una sentencia condicional false y nil actuan de la misma forma
			for k,v in pairs(Config.garages) do
				tableUpdate[k] = {}
				for i=1,v.floors,1 do
					tableUpdate[k][i] = {}
					for j = 1,v.capacity,1 do
						tableUpdate[k][i][j] = {}
						tableUpdate[k][i][j]["state"] = false
						tableUpdate[k][i][j]["vehicle"] = {}
						tableUpdate[k][i][j]["heading"] = 0.0
						tableUpdate[k][i][j]["place"] = j
					end
				end
			end
			-- Falta control de errores !!¡¡
			ESX.exposedDB.updateOrCreateDocument(GetHashKey("Parkings"), {parkings = tableUpdate}, function(result)
				if result then
					print('^2 Parkings updated^7')
				else
					print('^1 Error updating parkings^7')
				end
			end)
			--print(json.encode(tableUpdate))
			TriggerEvent('s2vparkings:syncCacheSv',tableUpdate)
		else --Si se añaden nuevos parkigns se pone y se updatea la bd
			local newParkingsInConfig = false
			for k,v in pairs(Config.garages) do
				if resultado.parkings[k] == nil then
					newParkingsInConfig = true
					resultado.parkings[k] = {}
					for i=1,v.floors,1 do
						resultado.parkings[k][i] = {}
						for j=1,v.capacity,1 do
							resultado.parkings[k][i][j] = {}
							resultado.parkings[k][i][j]["state"] = false
							resultado.parkings[k][i][j]["vehicle"] = {}
							resultado.parkings[k][i][j]["heading"] = 0.0
							resultado.parkings[k][i][j]["place"] = j
						end
					end
				end
			end
			if newParkingsInConfig then
				ESX.exposedDB.updateOrCreateDocument(GetHashKey("Parkings"), {parkings = tableUpdate}, function(result)
				end)
			end
			--print(json.encode(tableUpdate))
			TriggerEvent('s2vparkings:syncCacheSv',resultado.parkings)
		end
	end)
		if Config.DebugMode then -- No necesario más que para testeo y debug
			Citizen.CreateThread(function()
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer then
						LoadPlayerCars(xPlayer.source,xPlayer.getIdentifier(),xPlayer)
					end
				end
			end)
		end
	--Comprobar si hay que guardar en la base de datos la cache-recovery
	--print('The resource ' .. resourceName .. ' has been started.')
end)

RegisterServerEvent('s2v_parkings:SyncEnteredWithCar')
AddEventHandler('s2v_parkings:SyncEnteredWithCar',function(plate,parking,floor)
	--print("Voy a avisar a los jugadores que estan en "..parking.." planta con coche "..plate)
	TriggerClientEvent('s2v_parkings:SyncEnteredWithCarCl', -1,plate,parking,floor)
end)

RegisterServerEvent('s2vparkings:syncCacheSv')
AddEventHandler('s2vparkings:syncCacheSv',function(cache)
	Citizen.Wait(200)
	ParkingsCache = cache
	TriggerClientEvent('s2v_parkings:SyncPlaces',-1,json.encode(ParkingsCache))
end)

RegisterServerEvent('s2v_parkings:ReloadClientCars')
AddEventHandler('s2v_parkings:ReloadClientCars',function()
	local xPlayer = ESX.GetPlayerFromId(source)
	PlayersCars[source] = {}
	LoadPlayerCars(source,xPlayer.getIdentifier(),xPlayer)
end)

--Cargar en cache los coches de la persona que entra
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	print("^2[Parkings Cache]^7Cargando los coches del jugador "..xPlayer.getIdentifier().." en cache")
	PlayersCars[source] = {}
	LoadPlayerCars(source,xPlayer.getIdentifier(),xPlayer)
	--Coger los coches de la base de datos
	TriggerClientEvent('s2v_parkings:SyncPlaces',source,json.encode(ParkingsCache))
end)

--Cuando se dropea liberar memoria de los coches de la persona que se va
AddEventHandler('esx:playerDropped',function(source,reason,xPlayer)
	PlayersCars[source] = nil
	print("^2[Liberador de cache]^7Liberando memoria cache del jugador "..xPlayer.getIdentifier())
end)

RegisterServerEvent('s2v_parkings:SyncNoNetworkedCarSv')
AddEventHandler('s2v_parkings:SyncNoNetworkedCarSv',function(properties,pos,heading,CurrentParking,CurrentFloor,place)
	local xVehicle = ESX.GetVehicleByPlate(properties.plate)
	xVehicle.deSpawn()
	TriggerClientEvent('s2v_parkings:SpawnNoNetworkedCar',-1,properties,pos,heading,CurrentParking,CurrentFloor,place,source)
end)

RegisterServerEvent('s2v_parkings:TaskLeaveVehicleSv')
AddEventHandler('s2v_parkings:TaskLeaveVehicleSv',function(playerSources)
	for k,v in pairs(playerSources) do
		TriggerClientEvent('s2v_parkings:TaskLeaveVehicleCl',v)
	end
end)

RegisterServerEvent('s2v_parkings:DeleteTakenVehicleSync')
AddEventHandler('s2v_parkings:DeleteTakenVehicleSync',function(parking,floor,place)
	TriggerClientEvent("s2v_parkings:DeleteTakenVehicle",-1,parking,floor,place)
end)

RegisterServerEvent('WriteCoords')
AddEventHandler('WriteCoords',function(coords)
	table.insert(CoordsPositions,{x=coords.x,y=coords.y,z=coords.z})
	SaveResourceFile(GetCurrentResourceName(), "vehicle-data.json", json.encode(CoordsPositions), -1)
end)
--Si es de compañia lo guarda en la cache de todos los jugdores si no solo en la del player que lo ha comprado --source player that buys, plate of car, if company then all players with company can use car
RegisterNetEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId',function(owner,vehicleprops,model,name,company)
	--Buscamos a todos los players que tienen esa compañia en ese momento y le metemos el coche
	if company then
		local xPlayer = ESX.GetPlayerFromId(owner)
		Citizen.CreateThread(function() 
			for k,v in pairs(ESX.GetPlayers()) do 
				if k % 20 == 0 then
					Wait(0)
				end
				local xPlayer = ESX.GetPlayerFromId(v)
				if xPlayer.getJob().name == company then
					table.insert(PlayersCars[v],vehicleprops.plate)
					TriggerClientEvent("s2v_parkings:syncPlayerCars",v,PlayersCars[v])
					--TriggerEvent("s2v_parkings:syncPlayerCars",PlayersCars)
				end
			end
		end)
	else
		table.insert(PlayersCars[owner],vehicleprops.plate)
		TriggerClientEvent("s2v_parkings:syncPlayerCars",owner,PlayersCars[owner])
		--TriggerEvent("s2v_parkings:syncPlayerCars",PlayersCars)
		--print(json.encode(PlayersCars[owner]))
	end
end)

AddEventHandler("esx_vehicleshop:setVehicleOwnedPlayerIdToGarage", function(plate, company)
	Citizen.CreateThread(function() 
		for k,v in pairs(ESX.GetPlayers()) do 
			if k % 20 == 0 then
				Wait(0)
			end
			local xPlayer = ESX.GetPlayerFromId(v)
			if xPlayer.getJob().name == company then
				table.insert(PlayersCars[v],plate)
				TriggerEvent("garage:addKeys", plate, v)
				TriggerClientEvent("s2v_parkings:syncPlayerCars",v,PlayersCars[v])
				--TriggerEvent("s2v_parkings:syncPlayerCars",PlayersCars)
			end
		end
	end)
end)

RegisterServerEvent('s2v_parkings:QuitCarToPlayerCache')
AddEventHandler('s2v_parkings:QuitCarToPlayerCache',function(owner,plate)
	local xPlayer = ESX.GetPlayerFromId(owner)
	--Buscamos a todos los players que tienen esa compañia en ese momento y le metemos el coche
	if PlayersCars[xPlayer.source] then
		for i=1,#PlayersCars[xPlayer.source], 1 do
			if PlayersCars[xPlayer.source][i] == plate then
				table.remove(PlayersCars[xPlayer.source],i)
			end
		end
	end
end)

RegisterServerEvent('s2v_parkings:CreateParking')---Source
AddEventHandler('s2v_parkings:CreateParking',function(source,Name,Label,Shell,Entercoords,Type,Floors,Capacity,Blip,BlipColour)
	Create = true
	---Comprobaciones previas para evitar errores al crear el parking
	if Config.garages[Name] then Create = false end
	if not Config.GarageSpawns[Shell] then Create = false end
	if Config.GarageSpawns[Shell] then if Capacity  > Config.GarageSpawns[Shell].Capacity then Create = false end end

	--if Create then --Ha pasado los checks y creamos el parking
		local parking = {
			name = Name,
			label = Label,
			shell = Shell,
			enterCoords = Entercoords,
			type = Type,
			floors = Floors,
			capacity = Capacity,
			blip = Blip,
			blipColour = BlipColour,
			enter = true,
			source = nil
		}
		if not ParkingsCache[parking.name] then  ---Si no existe ya es decir si nunca se ha creado entonces se crea y se mete en la bd
			--print("Entro a updatear")
			ParkingsCache[parking.name] = {}
			for i=1,parking.floors,1 do
				ParkingsCache[parking.name][i] = {}
				for j=1,parking.capacity,1 do
					ParkingsCache[parking.name][i][j] = {}
					ParkingsCache[parking.name][i][j]["state"] = false
					ParkingsCache[parking.name][i][j]["vehicle"] = {}
					ParkingsCache[parking.name][i][j]["heading"] = 0.0
					ParkingsCache[parking.name][i][j]["place"] = j
				end
			end
			NeedUpdate = true
		end
	--end
		if Type == "private" then
			parking.source = source
		end
		Config.garages[parking.name] = parking
		--Si el parking ya esta en cache porque ya se ha creado en un momento anterior se lo enviamos a los clientes
		TriggerClientEvent('s2v_parkings:SyncPlaces',-1,json.encode(ParkingsCache)) --Sincronizacion de datos
		TriggerClientEvent('s2v_parkings:getNewParking',-1, parking,source) --Sincronizacion de entrada y menus
	
end)

---Falta hacerlo mejor
RegisterServerEvent('s2v_parkings:DeleteParking')
AddEventHandler('s2v_parkings:DeleteParking', function(source,parking)
	if ParkingsCache[parking] then --Borramos el parking
		ParkingsCache[parking] = nil
		NeedUpdate = true
		TriggerClientEvent('s2v_parkings:SyncPlaces',-1,json.encode(ParkingsCache))
		TriggerClientEvent('s2v_parkings:deleteNewParking',-1,parking)
	end
end)

RegisterCommand('pruebaEncode',function()
	local newTable = {}
	newTable["pepito"] = {name = "Hola",label = {pape="Pepito"}}
	newTable["pepote"] = {name = "Hola",label = {pape="Pepito"}}
	newTable["pepito"] = nil
	--print(json.encode(newTable))
end, false)

-- RegisterCommand('AñadirParking',function(source)
-- 	TriggerEvent('s2v_parkings:CreateParking',source,"PruebaAñadir","Prueba",'shell_warehouse2',vector3(259.95642089844,-958.61889648438,29.307792663574),"public",8,15,267,38)
-- end,false)
-- RegisterCommand('EliminarParking',function(source)
-- 	TriggerEvent('s2v_parkings:DeleteParking',source,"PruebaAñadir")
-- end,false)

-- RegisterCommand("daracceso", function(source,args,raw)
-- 	TriggerClientEvent('s2v_parkings:parkingGiveAccess', source,"Central2",true)
-- end,false)
-- RegisterCommand("quitaracceso", function(source,args,raw)
-- 	TriggerClientEvent('s2v_parkings:parkingGiveAccess', source,"Central2",false)
-- end,false)

ESX.RegisterServerCallback('esx:isVehicleOwnedBySameCompany', function(source,cb, plate) 
	local xVehicle = ESX.GetVehicleByPlate(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(plate)
	print(json.encode(xVehicle))
	if xVehicle then
		isWhiteJob(source, xPlayer.getJob().name, function(iswhite) 
			print("es white: "..json.encode(iswhite))
			if (xPlayer.getJob().name == xVehicle.getJob()) or (iswhite) then
				cb(true)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end)


exports("getParkingVehicles", function() 
	return ParkingsCache
end)


ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	-- Update the door list
	ESX.TriggerServerCallback('esx_doorlock:getDoorInfo', function(doorInfo)
		for doorID,state in pairs(doorInfo) do
			Config.DoorList[doorID].locked = state
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Get objects every second, instead of every frame
Citizen.CreateThread(function()
	while true do
		for _,doorID in ipairs(Config.DoorList) do
			if doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if not v.object or not DoesEntityExist(v.object) then
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objName, false, false, false)
					end
				end
			else
				if not doorID.object or not DoesEntityExist(doorID.object) then
					doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objName, false, false, false)
				end
			end
		end

		Citizen.Wait(3000)
	end
end)

RegisterNetEvent('esx_doorlock:useDoor')
AddEventHandler('esx_doorlock:useDoor', function(coords)
	local found = false
	local playerCoords = GetEntityCoords(PlayerPedId())
	for k,doorID in ipairs(Config.DoorList) do
		local distance
		local objectDistance

		if doorID.doors then
			if #(coords - doorID.doors[1].objCoords) < #(coords - doorID.doors[2].objCoords) then
				objectDistance = #(coords - doorID.doors[1].objCoords)
			else
				objectDistance = #(coords - doorID.doors[2].objCoords)
			end
			distance = #(playerCoords - doorID.doors[1].objCoords)		
		else
			distance = #(playerCoords - doorID.objCoords)
			objectDistance = #(coords - doorID.objCoords)
		end

		local isAuthorized = IsAuthorized(doorID)
		local maxDistance

		
 		local maxDistance = 2.5
		if doorID.distance then
			maxDistance = doorID.distance
		end
		if distance <= maxDistance and objectDistance < 1 then
			found = true
			if isAuthorized then
				doorID.locked = not doorID.locked
				TriggerServerEvent('esx_doorlock:updateState', k, doorID.locked) -- Broadcast new state of the door to everyone
				if doorID.locked then
					ESX.ShowNotification("Has cerrado la puerta.")
				else
					ESX.ShowNotification("Has abierto la puerta.")
				end	
			else
				if doorID.locked then
					ESX.ShowNotification("La puerta esta cerrada.")
				else
					ESX.ShowNotification("No tienes la llave para cerrar esa puerta.")
				end	
			end
		end		
	end	
	if not found then
		ESX.ShowNotification("No puedes usar la puerta desde tan lejos")
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local found = false
		for k,doorID in ipairs(Config.DoorList) do
			local distance

			if doorID.doors then
				distance = #(playerCoords - doorID.doors[1].objCoords)
			else
				distance = #(playerCoords - doorID.objCoords)
			end

			if distance < 50 then
				found = true
				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						FreezeEntityPosition(v.object, doorID.locked)

						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						end
					end
				else
					FreezeEntityPosition(doorID.object, doorID.locked)

					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
					end
				end
			end
		end
		if not found then
			Citizen.Wait(1200)
		end
	end
end)

function IsAuthorized(doorID)
	if ESX.PlayerData.job == nil then
		return false
	end

	for _,job in pairs(doorID.authorizedJobs) do
		if job == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

-- Set state for a door
RegisterNetEvent('esx_doorlock:setState')
AddEventHandler('esx_doorlock:setState', function(doorID, state)
	Config.DoorList[doorID].locked = state
end)
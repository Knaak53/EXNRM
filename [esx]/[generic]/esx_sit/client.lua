ESX = nil
local debugProps, sitting, lastPos, currentSitCoords, currentScenario = {}

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

if Config.Debug then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			for i=1, #debugProps, 1 do
				local coords = GetEntityCoords(debugProps[i])
				local hash = GetEntityModel(debugProps[i])
				local id = coords.x .. coords.y .. coords.z
				local model = 'unknown'

				for i=1, #Config.Interactables, 1 do
					local seat = Config.Interactables[i]

					if hash == GetHashKey(seat) then
						model = seat
						break
					end
				end

				local text = ('ID: %s~n~Hash: %s~n~Model: %s'):format(id, hash, model)

				ESX.Game.Utils.DrawText3D({
					x = coords.x,
					y = coords.y,
					z = coords.z + 2.0
				}, text, 0.5)
			end

			if #debugProps == 0 then
				Citizen.Wait(500)
			end
		end
	end)
end

local sitAction = false
local targetEntity = nil
RegisterNetEvent("esx_sit:sitIn")
AddEventHandler("esx_sit:sitIn", function(entity)
	sitAction = true
	targetEntity = entity
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			wakeup()
		end

		if sitAction and IsPedOnFoot(playerPed) then
			if sitting then
				wakeup()
			else
				local object, distance = ESX.Game.GetClosestObject(Config.Interactables)
				local object = targetEntity
				if Config.Debug then
					table.insert(debugProps, object)
				end

				if distance < 1.5 then
					local hash = GetEntityModel(object)
					print("Silla hash: ".. hash)
					for k,v in pairs(Config.Sitable) do
						if v.hash ~= nil then
							if v.hash == hash then
								sit(object, k, v)
								break
							end
						elseif GetHashKey(k) == hash then
								sit(object, k, v)
								
								break
						end
					end
					for k,v in pairs(Config.SitableAlone) do
						if v.hash ~= nil then
							print("Config hash: ".. v.hash)
							if v.hash == hash then
								print("TEST")
								print("Config hash: ".. v.hash)
								sit(object, k, v, true)
								break
							end
						elseif GetHashKey(k) == hash then
							sit(object, k, v, true)
								
							break
						end
					end
				end
				sitAction = false
			end
		end
	end
end)

AddEventHandler('esx_keymapings:cancelActions', function() 
	if sitting then
		wakeup()
	end
end)

function wakeup()
	local playerPed = PlayerPedId()
	ClearPedTasks(playerPed)

	sitting = false

	--SetEntityCoords(playerPed, lastPos)
	FreezeEntityPosition(playerPed, false)

	TriggerServerEvent('esx_sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
end

function sit(object, modelName, data, alone)
	local pos = GetEntityCoords(object)
	local objectCoords = pos.x .. pos.y .. pos.z

	ESX.TriggerServerCallback('esx_sit:getPlace', function(occupied)
		if occupied then
			ESX.ShowNotification('Cette place est prise...')
		else
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('esx_sit:takePlace', objectCoords)
			FreezeEntityPosition(object, true)
			local playercoords = GetEntityCoords(playerPed)
			currentScenario = data.scenario
			if not alone then
				local relativeCoords = GetOffsetFromEntityGivenWorldCoords(playerPed, pos.x, pos.y, pos.z)
				local rightCords = GetOffsetFromEntityInWorldCoords(object, -relativeCoords.x, 0, 0)
				print(relativeCoords)
				print(rightCords)
				TaskStartScenarioAtPosition(playerPed, currentScenario, rightCords.x , rightCords.y - data.forwardOffset , rightCords.z - data.verticalOffset, GetEntityHeading(object) + 180.0, 0, true, true)
				Citizen.Wait(1000)
				sitting = true
			else
				local rot 
				if data.rotation then
					rot = data.rotation
				else
					rot = 180.0
				end
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y + data.forwardOffset , pos.z - data.verticalOffset, GetEntityHeading(object) + rot, 0, true, true)
				Citizen.Wait(1000)
				sitting = true
			end
		end
	end)
end

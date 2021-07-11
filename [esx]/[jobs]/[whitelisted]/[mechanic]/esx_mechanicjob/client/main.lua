local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false
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
end)

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.Zones.VehicleDelivery.Type = -1

	NPCOnJob = false
	NPCTargetTowable  = nil
	NPCTargetTowableZone = nil
	NPCHasSpawnedTowable = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		--TriggerServerEvent('esx_mechanicjob:onNPCJobCompleted')
	end
end

function OpenMechanicActionsMenu()
	local elements = {
		{label = _U('work_wear'),      value = 'cloakroom'},
		{label = _U('civ_wear'),       value = 'cloakroom2'},
		{label = _U('vehicle_list'),   value = 'vehicle_list'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vehicle_list' then
			if Config.EnableSocietyOwnedVehicles then

				local elements = {}

				ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
					for i=1, #vehicles, 1 do
						table.insert(elements, {
							label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
							value = vehicles[i]
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
						title    = _U('service_vehicle'),
						align    = 'left',
						elements = elements
					}, function(data, menu)
						menu.close()
						local vehicleProps = data.current.value

						ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)

						TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mechanic', vehicleProps)
					end, function(data, menu)
						menu.close()
					end)
				end, 'mechanic')

			else

				local elements = {
					{label = _U('flat_bed'),  value = 'flatbed'},
					{label = _U('tow_truck'), value = 'towtruck'}
				}

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
					title    = _U('service_vehicle'),
					align    = 'left',
					elements = elements
				}, function(data, menu)
					if Config.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)
					else
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if canTakeService then
								ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
									local playerPed = PlayerPedId()
									TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
								end)
							else
								ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
							end
						end, 'mechanic')
					end

					menu.close()
				end, function(data, menu)
					menu.close()
					OpenMechanicActionsMenu()
				end)

			end
		elseif data.current.value == 'cloakroom' then
			menu.close()
			ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
				if canTakeService then
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, Config.uniforms[ESX.PlayerData.job.grade_name].male)
						else
							TriggerEvent('skinchanger:loadClothes', skin,  Config.uniforms[ESX.PlayerData.job.grade_name].female)
						end
					end)
				end
			end, 'mechanic')
		elseif data.current.value == 'cloakroom2' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
				TriggerServerEvent('esx_service:disableService', 'mechanic')
			end)
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

--function OpenMechanicHarvestMenu()
--	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
--		local elements = {
--			{label = _U('gas_can') .. '<span style=\"color: green;\"> 20 €</span>', value = 'gaz_bottle'},
--			{label = _U('repair_tools') .. '<span style=\"color: green;\"> 70 €</span>', value = 'fix_tool'},
--			{label = _U('body_work_tools') .. '<span style=\"color: green;\"> 50 €</span>', value = 'caro_tool'}
--		}
--
--		ESX.UI.Menu.CloseAll()
--
--		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_harvest', {
--			title    = _U('harvest'),
--			align    = 'left',
--			elements = elements
--		}, function(data, menu)
--			menu.close()
--
--			if data.current.value == 'gaz_bottle' then
--				TriggerServerEvent('esx_mechanicjob:buyTool', 20, 'gazbottle', "Botella de gas")
--				FreezeEntityPosition(GetPlayerPed(-1), true)
--				Wait(4000)
--				FreezeEntityPosition(GetPlayerPed(-1), false)
--			elseif data.current.value == 'fix_tool' then
--				TriggerServerEvent('esx_mechanicjob:buyTool', 70, 'fixtool', "Herramientas de reparacion")
--				FreezeEntityPosition(GetPlayerPed(-1), true)
--				Wait(4000)
--				FreezeEntityPosition(GetPlayerPed(-1), false)
--			elseif data.current.value == 'caro_tool' then
--				TriggerServerEvent('esx_mechanicjob:buyTool', 50, 'carotool', "Herramientas de carroceria")
--				FreezeEntityPosition(GetPlayerPed(-1), true)
--				Wait(4000)
--				FreezeEntityPosition(GetPlayerPed(-1), false)
--			end
--		end, function(data, menu)
--			menu.close()
--			CurrentAction     = nil
--			CurrentActionMsg  = _U('harvest_menu')
--			CurrentActionData = {}
--		end)
--	else
--		ESX.ShowNotification(_U('not_experienced_enough'))
--	end
--end

function OpenMechanicCraftMenu()
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('blowtorch'),  value = 'blow_pipe'},
			{label = _U('repair_kit'), value = 'fix_kit'},
			{label = _U('body_kit'),   value = 'caro_kit'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_craft', {
			title    = _U('craft'),
			align    = 'left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'blow_pipe' then
				TriggerServerEvent('esx_mechanicjob:startCraft')
				FreezeEntityPosition(GetPlayerPed(-1), true)
				Wait(4000)
				FreezeEntityPosition(GetPlayerPed(-1), false)
			elseif data.current.value == 'fix_kit' then
				TriggerServerEvent('esx_mechanicjob:startCraft2')
				FreezeEntityPosition(GetPlayerPed(-1), true)
				Wait(4000)
				FreezeEntityPosition(GetPlayerPed(-1), false)
			elseif data.current.value == 'caro_kit' then
				TriggerServerEvent('esx_mechanicjob:startCraft3')
				FreezeEntityPosition(GetPlayerPed(-1), true)
				Wait(4000)
				FreezeEntityPosition(GetPlayerPed(-1), false)
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'mechanic_craft_menu'
			CurrentActionMsg  = _U('craft_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

RegisterNetEvent('esx_mechanicjob:billing_ui')
AddEventHandler('esx_mechanicjob:billing_ui', function(entity)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title = _U('invoice_amount')
	}, function(data, menu)
		local amount = tonumber(data.value)

		if amount == nil or amount < 0 then
			ESX.ShowNotification(_U('amount_invalid'))
		else
			local playerClicked = ESX.Game.GetPlayerServerIdFromPlayerEntity(entity)
			if not playerClicked then
				ESX.ShowNotification("No se ha podido crear la factura")
			else
				menu.close()
				TriggerServerEvent('esx_billing:sendBill', playerClicked, 'society_mechanic', _U('mechanic'), amount)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('esx_mechanicjob:fix_ui')
AddEventHandler('esx_mechanicjob:fix_ui', function(entity)
	local playerPed = PlayerPedId()
	local vehicle   = entity
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end

	if DoesEntityExist(vehicle) then
		isBusy = true
		TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
		Citizen.CreateThread(function()
			Citizen.Wait(20000)

			SetVehicleFixed(vehicle)
			SetVehicleDeformationFixed(vehicle)
			SetVehicleUndriveable(vehicle, false)
			SetVehicleEngineOn(vehicle, true, true)
			ClearPedTasksImmediately(playerPed)

			ESX.ShowNotification(_U('vehicle_repaired'))
			isBusy = false
		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'))
	end
end)

RegisterNetEvent('esx_mechanicjob:toolbox_ui')
AddEventHandler('esx_mechanicjob:toolbox_ui', function()
	local playerPed = PlayerPedId()
	local model   = 'prop_toolchest_01'
	local coords  = GetEntityCoords(playerPed)
	local forward = GetEntityForwardVector(playerPed)
	local x, y, z = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx_mechanicjob:clean_ui')
AddEventHandler('esx_mechanicjob:clean_ui', function(entity)
	local playerPed = PlayerPedId()
	local vehicle   = entity
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end

	if DoesEntityExist(vehicle) then
		isBusy = true
		TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
		Citizen.CreateThread(function()
			Citizen.Wait(10000)

			SetVehicleDirtLevel(vehicle, 0)
			ClearPedTasksImmediately(playerPed)

			ESX.ShowNotification(_U('vehicle_cleaned'))
			isBusy = false
		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'))
	end
end)


RegisterNetEvent('esx_mechanicjob:tow_ui')
AddEventHandler('esx_mechanicjob:tow_ui', function(entity)
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, true)

	local towmodel = GetHashKey('flatbed')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)

	if isVehicleTow then
		local targetVehicle = entity

		if CurrentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerPed, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						CurrentlyTowedVehicle = targetVehicle
						ESX.ShowNotification(_U('vehicle_success_attached'))

						if NPCOnJob then
							if NPCTargetTowable == targetVehicle then
								ESX.ShowNotification(_U('please_drop_off'))
								Config.Zones.VehicleDelivery.Type = 1

								if Blips['NPCTargetTowableZone'] then
									RemoveBlip(Blips['NPCTargetTowableZone'])
									Blips['NPCTargetTowableZone'] = nil
								end

								Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
								SetBlipRoute(Blips['NPCDelivery'], true)
							end
						end
					else
						ESX.ShowNotification(_U('cant_attach_own_tt'))
					end
				end
			else
				ESX.ShowNotification(_U('no_veh_att'))
			end
		else
			AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(CurrentlyTowedVehicle, true, true)

			if NPCOnJob then
				if NPCTargetDeleterZone then

					if CurrentlyTowedVehicle == NPCTargetTowable then
						ESX.Game.DeleteVehicle(NPCTargetTowable)
						TriggerServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
						StopNPCJob()
						NPCTargetDeleterZone = false
					else
						ESX.ShowNotification(_U('not_right_veh'))
					end

				else
					ESX.ShowNotification(_U('not_right_place'))
				end
			end

			CurrentlyTowedVehicle = nil
			ESX.ShowNotification(_U('veh_det_succ'))
		end
	else
		ESX.ShowNotification(_U('imp_flatbed'))
	end
end)

RegisterNetEvent('esx_mechanicjob:onHijack')
AddEventHandler('esx_mechanicjob:onHijack', function(entity)
	local playerPed = PlayerPedId()
	local vehicle = entity
	local chance = math.random(100)
	local alarm  = math.random(100)

	if DoesEntityExist(vehicle) then
		if alarm <= 33 then
			SetVehicleAlarm(vehicle, true)
			StartVehicleAlarm(vehicle)
		end

		TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

		Citizen.CreateThread(function()
			Citizen.Wait(10000)
			if chance <= 66 then
				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_unlocked'))
			else
				ESX.ShowNotification(_U('hijack_failed'))
				ClearPedTasksImmediately(playerPed)
			end
		end)
	end
end)

--RegisterNetEvent('esx_mechanicjob:onCarokit')
--AddEventHandler('esx_mechanicjob:onCarokit', function(entity)
--	local playerPed = PlayerPedId()
--	local vehicle = entity
--
--	if DoesEntityExist(vehicle) then
--		TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
--		Citizen.CreateThread(function()
--			Citizen.Wait(10000)
--			SetVehicleFixed(vehicle)
--			SetVehicleDeformationFixed(vehicle)
--			ClearPedTasksImmediately(playerPed)
--			ESX.ShowNotification(_U('body_repaired'))
--		end)
--	end
--end)
--
--RegisterNetEvent('esx_mechanicjob:onFixkit')
--AddEventHandler('esx_mechanicjob:onFixkit', function(entity)
--	local playerPed = PlayerPedId()
--	local vehicle = entity
--
--	if DoesEntityExist(vehicle) then
--		TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
--		Citizen.CreateThread(function()
--			Citizen.Wait(20000)
--			SetVehicleFixed(vehicle)
--			SetVehicleDeformationFixed(vehicle)
--			SetVehicleUndriveable(vehicle, false)
--			ClearPedTasksImmediately(playerPed)
--			ESX.ShowNotification(_U('veh_repaired'))
--		end)
--	end
--end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_mechanicjob:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_mechanicjob:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mechanicjob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end
end)

AddEventHandler('esx_mechanicjob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('mechanic'),
		number     = 'mechanic',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Pop NPC mission vehicle when inside area
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local found = false
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			if NPCTargetTowableZone and not NPCHasSpawnedTowable then
				found = true
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.Zones[NPCTargetTowableZone]

				if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCSpawnDistance then
					local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

					ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
						NPCTargetTowable = vehicle
					end)

					NPCHasSpawnedTowable = true
				end
			end

			if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.Zones[NPCTargetTowableZone]
				found = true
				if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCNextToDistance then
					ESX.ShowNotification(_U('please_tow'))
					NPCHasBeenNextToTowable = true
				end
			end
			Citizen.Wait(750)
		else
			Citizen.Wait(3000)
		end	
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.MechanicActions.Pos.x, Config.Zones.MechanicActions.Pos.y, Config.Zones.MechanicActions.Pos.z)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.2)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('mechanic'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local found = false
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			local coords = GetEntityCoords(PlayerPedId())

			for k,v in pairs(Config.Zones) do
				if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
					found = true
				end
			end
			if not found then
				Citizen.Wait(750)
			end
		else
			Citizen.Wait(3000)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			local found = false
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					found = true
					currentZone = k
				end
			end
			if found then
				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('esx_mechanicjob:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_mechanicjob:hasExitedMarker', LastZone)
				end
			else
				Citizen.Wait(500)
			end
			
		else
			Citizen.Wait(3000)
		end
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_toolchest_01'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_mechanicjob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_mechanicjob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:actions_ui')
AddEventHandler('esx_mechanicjob:actions_ui', function(action)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
		if action == 'mechanic_menu' then
			OpenMechanicActionsMenu()
		elseif action == 'craft_menu' then
			OpenMechanicCraftMenu()
		end
	else
		ESX.ShowNotification('No eres ~g~MECANICO~w~!')
	end
end)

RegisterNetEvent('esx_mechanicjob:store_ui')
AddEventHandler('esx_mechanicjob:store_ui', function(action)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
		TriggerEvent('esx_generic_inv_ui:openSociety', 'mechanic', 'Almacen del Taller')
	else
		ESX.ShowNotification('No eres ~g~MECANICO~w~!')
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			if CurrentAction then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'delete_vehicle' then

						if Config.EnableSocietyOwnedVehicles then

							local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
							TriggerServerEvent('esx_society:putVehicleInGarage', 'mechanic', vehicleProps)

						else

							if
								GetEntityModel(vehicle) == GetHashKey('flatbed')   or
								GetEntityModel(vehicle) == GetHashKey('towtruck')
							then
								TriggerServerEvent('esx_service:disableService', 'mechanic')
							end

						end

						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

					elseif CurrentAction == 'remove_entity' then
						DeleteEntity(CurrentActionData.entity)
					end

					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, 167) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
				if NPCOnJob then
					if GetGameTimer() - NPCLastCancel > 5 * 60000 then
						StopNPCJob(true)
						NPCLastCancel = GetGameTimer()
					else
						ESX.ShowNotification(_U('wait_five'))
					end
				else
					local playerPed = PlayerPedId()

					if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey('flatbed')) then
						StartNPCJob()
					else
						ESX.ShowNotification(_U('must_in_flatbed'))
					end
				end
			end
		else
			Citizen.Wait(3000)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onCarokit')
AddEventHandler('esx_mechanicjob:onCarokit', function(entity)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = entity

		--if IsPedInAnyVehicle(playerPed, false) then
		--	vehicle = GetVehiclePedIsIn(playerPed, false)
		--else
		--	vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		--end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			TriggerServerEvent("esx_mechanicjob:onCaroOwner", ObjToNet(vehicle))
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				--SetVehicleFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				if GetVehicleBodyHealth(vehicle) ~= 1000.0 then
					--ESX.ShowNotification("La carrocería y el motor no se han reparado completamente", true)
				else
					ESX.ShowNotification("Reparaste correctamente la carrocería")
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onFixkit')
AddEventHandler('esx_mechanicjob:onFixkit', function(entity)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = entity

		--if IsPedInAnyVehicle(playerPed, false) then
		--	vehicle = GetVehiclePedIsIn(playerPed, false)
		--else
		--	vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		--end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			TriggerServerEvent("esx_mechanicjob:onFixOwner", ObjToNet(vehicle))
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				--
				
				--SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
				if GetVehicleBodyHealth(vehicle) ~= 1000.0 then
					ESX.ShowNotification("La carrocería y el motor no se han reparado completamente", true)
				else
					ESX.ShowNotification("Reparaste correctamente el vehiculo")
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjob:onCaroOwner')
AddEventHandler('esx_mechanicjob:onCaroOwner', function(vehId, half)
	Citizen.CreateThread(function()
		local vehIds = vehId
		local vehicle = NetToEnt(vehIds)
		Citizen.Wait(10000)
		--SetVehicleFixed(vehicle)
		
		if half then
			SetVehicleBodyHealth(vehicle, 700.00)
		else
			SetVehicleBodyHealth(vehicle, 1000.00)
			SetVehicleDeformationFixed(vehicle)
		end
		--ESX.ShowNotification(_U('body_repaired'))
	end)
end)


RegisterNetEvent('esx_mechanicjob:onFixOwner')
AddEventHandler('esx_mechanicjob:onFixOwner',function(vehId, half)
	Citizen.CreateThread(function()
		local vehIds = vehId
		local vehicle = NetToEnt(vehIds)
		print(GetVehicleEngineHealth(vehicle))
		SetVehicleUndriveable(vehicle, true)

		Citizen.Wait(20000)

		--SetVehicleDeformationFixed(vehicle)
		SetVehicleUndriveable(vehicle, false)
		print(GetVehicleBodyHealth(vehicle))
		if GetVehicleBodyHealth(vehicle) < 1000.0 or half then
			SetVehicleEngineHealth(vehicle, 700.00)
			--SetVehicleFixed(vehicle)
		else
			SetVehicleFixed(vehicle)
		end
	end)
end)

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)
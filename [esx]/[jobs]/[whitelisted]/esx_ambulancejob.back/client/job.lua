
local LastHospital, LastPart, LastPartNum
local isBusy, deadPlayerBlips, isOnDuty = false, {}, false
deadPlayers = {}
isInShopMenu = false

RegisterNetEvent('esx_ambulancejob:action_ui')
AddEventHandler('esx_ambulancejob:action_ui', function(action, playerEntity)
	local closestPlayer = playerEntity

	if not closestPlayer then
		ESX.ShowNotification(_U('no_players'))
	else
		if action == 'reanimar' then
			revivePlayer(closestPlayer)
		elseif action == 'leve' then
			ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
				if quantity > 0 then
					local closestPlayerPed = GetPlayerPed(closestPlayer)
					local health = GetEntityHealth(closestPlayerPed)
					if health > 0 then
						local playerPed = PlayerPedId()

						isBusy = true
						ESX.ShowNotification(_U('heal_inprogress'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						Citizen.Wait(10000)
						ClearPedTasks(playerPed)

						TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
						TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
						ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
						isBusy = false
					else
						ESX.ShowNotification(_U('player_not_conscious'))
					end
				else
					ESX.ShowNotification(_U('not_enough_bandage'))
				end
			end, 'bandage')

		elseif action == 'grave' then
			ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
				if quantity > 0 then
					local closestPlayerPed = GetPlayerPed(closestPlayer)
					local health = GetEntityHealth(closestPlayerPed)
					print(health)
					if health > 0 then
						local playerPed = PlayerPedId()

						isBusy = true
						ESX.ShowNotification(_U('heal_inprogress'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						Citizen.Wait(10000)
						ClearPedTasks(playerPed)

						TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
						TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
						ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
						isBusy = false
					else
						ESX.ShowNotification(_U('player_not_conscious'))
					end
				else
					ESX.ShowNotification(_U('not_enough_medikit'))
				end
			end, 'medikit')

		elseif action == 'coche' then
			TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
		end
	end
end)

function revivePlayer(closestPlayer)
	isBusy = true

	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)

			if IsPedDeadOrDying(closestPlayerPed, 1) then
				local playerPed = PlayerPedId()
				local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
				ESX.ShowNotification(_U('revive_inprogress'))

				for i=1, 15 do
					Citizen.Wait(900)

					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
				end

				TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
				TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification(_U('player_not_unconscious'))
			end
		else
			ESX.ShowNotification(_U('not_enough_medikit'))
		end
		isBusy = false
	end, 'medikit')
end

RegisterNetEvent('esx_ambulancejob:pharmacy_ui')
AddEventHandler('esx_ambulancejob:pharmacy_ui', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		OpenPharmacyMenu()
	else
		ESX.ShowNotification('No eres ~g~EMS~w~!')
	end
end)

RegisterNetEvent('esx_ambulancejob:storage_ui')
AddEventHandler('esx_ambulancejob:storage_ui', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		TriggerEvent('esx_generic_inv_ui:openSociety', 'ambulance', 'Inventario del Hospital')
	else
		ESX.ShowNotification('No eres ~g~UMC~w~!')
	end
end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:cloakroom_ui')
AddEventHandler('esx_ambulancejob:cloakroom_ui', function()
	if ESX.PlayerData.job.name == 'ambulance' then
		OpenCloakroomMenu()
	else
		ESX.ShowNotification('No eres ~r~EMS~w~!')
	end
end)

RegisterNetEvent('esx_ambulancejob:boss_ui')
AddEventHandler('esx_ambulancejob:boss_ui', function()
	if ESX.PlayerData.job.name == 'ambulance' then
		if ESX.PlayerData.job.grade_name == 'boss' then
			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
			end, {wash = false})
		else
			ESX.ShowNotification('No eres ~r~JEFE DE SERVICIO~w~!')
		end
	else
		ESX.ShowNotification('No eres ~r~EMS~w~!')
	end	
end)

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'left',
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},
	}}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
				isOnDuty = false

				for playerId,v in pairs(deadPlayerBlips) do
					RemoveBlip(v)
					deadPlayerBlips[playerId] = nil
				end
			end)

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if isInService then
					TriggerServerEvent('esx_service:disableService', 'ambulance')
					ESX.ShowNotification("Has salido del servicio")
				end
			end, 'ambulance')
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
				if canTakeService then
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
						else
							TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
						end

						isOnDuty = true
						TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)
						ESX.ShowNotification('¡Has entrado en servicio!')
					end)
				else
					ESX.ShowNotification('¡No puedes entrar en servicio!')
				end
		end, "ambulance")
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title    = _U('pharmacy_menu_title'),
		align    = 'left',
		elements = {
			{label = _U('pharmacy_take', _U('medikit')), item = 'medikit', type = 'slider', value = 1, min = 1, max = 100},
			{label = _U('pharmacy_take', _U('bandage')), item = 'bandage', type = 'slider', value = 1, min = 1, max = 100}
	}}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.item, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if isOnDuty and job ~= 'ambulance' then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		isOnDuty = false
	end
end)

RegisterNetEvent('esx_ambulancejob:setDeadPlayers')
AddEventHandler('esx_ambulancejob:setDeadPlayers', function(_deadPlayers)
	deadPlayers = _deadPlayers

	if isOnDuty then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		for playerId,status in pairs(deadPlayers) do
			if status == 'distress' then
				local player = GetPlayerFromServerId(playerId)
				local playerPed = GetPlayerPed(player)
				local blip = AddBlipForEntity(playerPed)

				SetBlipSprite(blip, 303)
				SetBlipColour(blip, 1)
				SetBlipFlashes(blip, true)
				SetBlipCategory(blip, 7)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('blip_dead'))
				EndTextCommandSetBlipName(blip)

				deadPlayerBlips[playerId] = blip
			end
		end
	end
end)
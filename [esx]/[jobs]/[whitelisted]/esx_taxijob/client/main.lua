local HasAlreadyEnteredMarker, OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, IsDead, CurrentActionData = false, false, false, false, false, false, {}
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone, CurrentAction, CurrentActionMsg

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

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyspinnerOn(type)
		Citizen.Wait(time)

		BusyspinnerOff()
	end)
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	targetCoords              = nil
end

function StartTaxiJob()
	ShowLoadingPromt(_U('taking_service'), 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
	DrawSub('Has terminado el servicio', 5000)
end

function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_cloakroom', {
		title    = _U('cloakroom_menu'),
		align    = 'left',
		elements = {
			{label = _U('wear_citizen'), value = 'wear_citizen'},
			{label = _U('wear_work'),    value = 'wear_work'}
	}}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'wear_work' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

local canTakeTaxi = true

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = _U('spawn_veh'),
		align    = 'left',
		elements = Config.AuthorizedVehicles
	}, function(data, menu)
		if not ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 5.0) then
			ESX.ShowNotification(_U('spawnpoint_blocked'))
			return
		end

		menu.close()
		TriggerServerEvent("esx_taxijob:spawnTaxi", data.current.model)
	end, function(data, menu)

		menu.close()
	end)
end

local currentSpawnedTaxi = nil

function DeleteJobVehicle()
	local playerPed = PlayerPedId()
	print(GetVehiclePedIsIn(playerPed), currentSpawnedTaxi)
	if IsInAuthorizedVehicle() and GetVehiclePedIsIn(playerPed) == currentSpawnedTaxi then
		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'taxi')
		end
		TriggerServerEvent('esx_taxijob:deleteTaxiAndGiveBackMoney', VehToNet(currentSpawnedTaxi))
	else
		ESX.ShowNotification(_U('only_taxi'))
	end
end

RegisterNetEvent("esx_taxijob:warpPedInVehicle")
AddEventHandler("esx_taxijob:warpPedInVehicle", function(netVeh)
	local vehicle = NetToVeh(netVeh)
	local playerPed = PlayerPedId()
	while not DoesEntityExist(vehicle) do 
		vehicle = NetToVeh(netVeh)
		Citizen.Wait(100) 
	end
	currentSpawnedTaxi = vehicle
	TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	ESX.ShowNotification("Te han retenido ~g~" .. Config.fianza .. "€~w~ como fianza por el vehiculo.")
end)

RegisterNetEvent('esx_taxijob:billing_ui')
AddEventHandler('esx_taxijob:billing_ui', function(entity)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title = _U('invoice_amount')
	}, function(data, menu)
		local amount = tonumber(data.value)
		if amount == nil then
			ESX.ShowNotification(_U('amount_invalid'))
		else
			menu.close()
			local closestPlayer = ESX.Game.GetPlayerServerIdFromPlayerEntity(entity)
			if not closestPlayer then
				ESX.ShowNotification(_U('no_players_near'))
			else
				TriggerServerEvent('esx_billing:sendBill', closestPlayer, 'taxi', 'Taxi', amount)
				ESX.ShowNotification(_U('billing_sent'))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('esx_taxijob:start_ui')
AddEventHandler('esx_taxijob:start_ui', function()
	if not OnJob then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			if tonumber(ESX.PlayerData.job.grade) >= 3 then
				StartTaxiJob()
			else
				if IsInAuthorizedVehicle() then
					StartTaxiJob()
				else
					ESX.ShowNotification(_U('must_in_taxi'))
				end
			end
		else
			if tonumber(ESX.PlayerData.job.grade) >= 3 then
				ESX.ShowNotification(_U('must_in_vehicle'))
			else
				ESX.ShowNotification(_U('must_in_taxi'))
			end
		end
	else
		StopTaxiJob()
	end
end)

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	
	return false
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_taxi'),
		number     = 'taxi',
		base64Icon = 'data:image/png;base64,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',
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(911.108,-177.867, 74.283)

	SetBlipSprite (blip, 198)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_taxi'))
	EndTextCommandSetBlipName(blip)
end)

-- Taxi Job
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if OnJob then
			if CurrentCustomer == nil then
				DrawSub(_U('drive_search_pass'), 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000)

					while OnJob and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(60000, 180000)
							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification(_U('customer_found'))
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification(_U('client_unconcious'))

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = #(playerCoords - customerCoords)

					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							local targetDistance = #(playerCoords - targetCoords)

							if targetDistance <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								ESX.ShowNotification(_U('arrive_dest'))

								TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								TriggerServerEvent('esx_taxijob:success')
								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									ESX.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
							end

							if targetCoords then
								DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
							end
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
							local distance = #(playerCoords - targetCoords)
							while distance < Config.MinimumDistance do
								Citizen.Wait(5)

								targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
								distance = #(playerCoords - targetCoords)
							end

							local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg = string.format(_U('take_me_to_near', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2])))
							else
								msg = string.format(_U('take_me_to', GetStreetNameFromHashKey(street[1])))
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									ESX.ShowNotification(_U('close_to_client'))
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
									end
								end
							end
						end
					end
				else
					DrawSub(_U('return_to_veh'), 5000)
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while onJob do
		Citizen.Wait(10000)
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade < 3 then
			if not IsInAuthorizedVehicle() then
				ClearCurrentMission()
				OnJob = false
				ESX.ShowNotification(_U('not_in_taxi'))
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			if #(GetEntityCoords(playerPed) - vector3(Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z)) < 13 then
				DrawMarker(Config.Zones.VehicleDeleter.Type,
				 Config.Zones.VehicleDeleter.Pos.x, 
				 Config.Zones.VehicleDeleter.Pos.y, 
				 Config.Zones.VehicleDeleter.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
				 Config.Zones.VehicleDeleter.Size.x,
				 Config.Zones.VehicleDeleter.Size.y, 
				 Config.Zones.VehicleDeleter.Size.z, 
				 Config.Zones.VehicleDeleter.Color.r, 
				 Config.Zones.VehicleDeleter.Color.g, 
				 Config.Zones.VehicleDeleter.Color.b, 155, false, false, 2, true, nil, nil, false)
				if #(GetEntityCoords(playerPed) - vector3(Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z)) < 3 then
					ESX.ShowHelpNotification("Pulsa ~INPUT_CONTEXT~ para devolver el Taxi")
					if IsControlJustReleased(0, 38) then
						DeleteJobVehicle()
					end
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(2000)
		end	
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	IsDead = false
end)

RegisterNetEvent('esx_taxijob:cloakroom_ui')
AddEventHandler('esx_taxijob:cloakroom_ui', function()
	Citizen.Wait(150)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
		OpenCloakroom()
	else
		ESX.ShowNotification('No eres ~g~TAXISTA~w~!')
	end
end)

RegisterNetEvent('esx_taxijob:vehicle_menu')
AddEventHandler('esx_taxijob:vehicle_menu', function()
	Citizen.Wait(150)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
		OpenVehicleSpawnerMenu()
	else
		ESX.ShowNotification('No eres ~g~TAXISTA~w~!')
	end
end)

RegisterNetEvent('esx_taxijob:open_storage_ui')
AddEventHandler('esx_taxijob:open_storage_ui', function()
	Citizen.Wait(150)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
		TriggerEvent('esx_generic_inv_ui:openSociety', 'taxi', 'Almacen del garaje')
	else
		ESX.ShowNotification('No eres ~g~TAXISTA~w~!')
	end
end)

local taximeterVisible = false
local currentSessionAmount = 0
local currentSessionActive = false
local currentTaxi = nil

RegisterNetEvent('esx_taxijob:open_taximeter_ui')
AddEventHandler('esx_taxijob:open_taximeter_ui', function(entity)
	Citizen.Wait(150)
	local playerPed = PlayerPedId()
	if GetVehiclePedIsIn(playerPed,  false) == entity and IsInAuthorizedVehicle() then
		local playersInVehicle = {}
		for i = 0, 2 do
			local currentSeatPed = GetPedInVehicleSeat(entity, i)
			if currentSeatPed then
				local playerServerId = ESX.Game.GetPlayerServerIdFromPlayerEntity(currentSeatPed)
				if playerServerId then
					table.insert(playersInVehicle, playerServerId)
				end	
			end
		end
		if #playersInVehicle > 0 then
			currentSessionAmount = 0
			taximeterVisible = true
			SendNUIMessage(
			    {
			      action = "open",
			      value = currentSessionAmount
			    }
			)
			TriggerServerEvent("esx_taxijob:startNewTaximeterGroup", playersInVehicle)
		else
			ESX.ShowNotification("~r~No hay pasajeros en el Taxi!")	
		end
	else
		ESX.ShowNotification("~r~Debes estar en un taxi para eso!")
	end
end)

RegisterNetEvent("esx_taxijob:showTaximeterClient")
AddEventHandler("esx_taxijob:showTaximeterClient", function(value)
	taximeterVisible = true
	playerPed = PlayerPedId()
	currentTaxi = GetVehiclePedIsIn(playerPed, false)
	SendNUIMessage(
	    {
	      action = "open",
	      value = value
	    }
	)
	Citizen.CreateThread(function()
		while taximeterVisible do
			Citizen.Wait(1500)
			if currentTaxi and #(GetEntityCoords(playerPed) - GetEntityCoords(currentTaxi)) > 30 or not currentTaxi then
				SendNUIMessage(
				    {
				      action = "close"
				    }
				)
			end
		end
	end)
end)

RegisterNetEvent("esx_taxijob:closeTaximeter")
AddEventHandler("esx_taxijob:closeTaximeter", function()
	taximeterVisible = false
	currentSessionAmount = 0
	SendNUIMessage(
	    {
	      action = "close"
	    }
	)
	TriggerServerEvent("esx_taxijob:closeTaximeterGroup")
end)

RegisterNetEvent("esx_taxijob:closeTaximeterClient")
AddEventHandler("esx_taxijob:closeTaximeterClient", function()
	taximeterVisible = false
	SendNUIMessage(
	    {
	      action = "close"
	    }
	)
end)

RegisterNetEvent("esx_taxijob:stopTaximeter")
AddEventHandler("esx_taxijob:stopTaximeter", function()
	currentSessionActive = false
end)

RegisterNetEvent("esx_taxijob:startGroupTimer")
AddEventHandler("esx_taxijob:startGroupTimer", function(entity)
	local playerPed = PlayerPedId()
	if taximeterVisible and GetVehiclePedIsIn(playerPed,  false) == entity and IsInAuthorizedVehicle() then
		currentSessionActive = true
		Citizen.CreateThread(function()
			while currentSessionActive do
				Citizen.Wait(10000)
				currentSessionAmount = currentSessionAmount + 2
				SendNUIMessage(
				    {
				      action = "open",
				      value = currentSessionAmount
				    }
				)
				if not IsInAuthorizedVehicle() then
					currentSessionActive = false
				end
				TriggerServerEvent("esx_taxijob:updateGroupSession", currentSessionAmount)
			end
		end)
	else
		ESX.ShowNotification("~r~Debes estar en el taxi con el taximetro a la vista para eso!")
	end
end)

RegisterNetEvent("esx_taxijob:updateTaximeterValueClient")
AddEventHandler("esx_taxijob:updateTaximeterValueClient", function(value)
	SendNUIMessage(
	    {
	      action = "open",
	      value = value
	    }
	)
end)

RegisterNetEvent('esx_taxijob:open_boss_menu_ui')
AddEventHandler('esx_taxijob:open_boss_menu_ui', function()
	Citizen.Wait(150)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
		if ESX.PlayerData.job.grade_name == "boss" then
			TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu) end)
		else
			ESX.ShowNotification('No eres ~g~JEFE DE TAXISTAS~w~!')
		end
	else
		ESX.ShowNotification('No eres ~g~TAXISTA~w~!')
	end
end)

function startVehicleTimer()
	Citizen.CreateThread(function()
		canTakeTaxi = false
		Citizen.Wait(900000)
		canTakeTaxi = true
	end)
end


--------------------------------------------------------------------------------------

								--PED GENERATION--

--------------------------------------------------------------------------------------

local peds = {
	{coords = vector3(895.76, -157.14, 75.96), model = 'hc_driver', animation = '', heading = 10.57},
}

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteCharacters()
	end
end)

local pedEntities = {}

DeleteCharacters = function()
    for i=1, #pedEntities do
        local char = pedEntities[i]
        if DoesEntityExist(char) then
            DeletePed(char)
            SetPedAsNoLongerNeeded(char)
        end
    end
end

Citizen.CreateThread(function()
	for i = 1, #peds do
        hash = GetHashKey(peds[i].model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
			Citizen.Wait(10)
		end
        if not DoesEntityExist(pedEntities[i]) then
            pedEntities[i] = CreatePed(4, hash, peds[i].coords.x, peds[i].coords.y, peds[i].coords.z, peds[i].heading)
            SetEntityAsMissionEntity(pedEntities[i])
            SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
            FreezeEntityPosition(pedEntities[i], true)
            SetEntityInvincible(pedEntities[i], true)
            TaskStartScenarioInPlace(pedEntities[i], peds[i].animation, 0, true)
        end
        SetModelAsNoLongerNeeded(hash)
    end
end)
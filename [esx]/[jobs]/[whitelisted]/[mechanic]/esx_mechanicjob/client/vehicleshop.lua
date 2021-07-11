local spawnedVehicles = {}

Citizen.CreateThread(function()
    hash = GetHashKey('mp_m_waremech_01')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
		Wait(0)
	end
    if not DoesEntityExist(pedEntity2) then
        pedEntity2 = CreatePed(4, hash, Config.shopNPC.x, Config.shopNPC.y, Config.shopNPC.z, 68.62)
        SetEntityAsMissionEntity(pedEntity2)
        SetBlockingOfNonTemporaryEvents(pedEntity2, true)
        FreezeEntityPosition(pedEntity2, true)
        SetEntityInvincible(pedEntity2, true)
        --TaskStartScenarioInPlace(pedEntity, "WORLD_HUMAN_SEAT_WALL_TABLET", 0, true)
    end
    SetModelAsNoLongerNeeded(hash)
    --hash = GetHashKey('s_m_y_xmech_01')
    --RequestModel(hash)
    --while not HasModelLoaded(hash) do
	--	Wait(0)
	--end
    --if not DoesEntityExist(pedEntity3) then
    --    pedEntity3 = CreatePed(4, hash, Config.shopNPC.x, Config.shopNPC.y, Config.shopNPC.z, 262.52)
    --    SetEntityAsMissionEntity(pedEntity3)
    --    SetBlockingOfNonTemporaryEvents(pedEntity3, true)
    --    FreezeEntityPosition(pedEntity3, true)
    --    SetEntityInvincible(pedEntity3, true)
    --    --TaskStartScenarioInPlace(pedEntity, "WORLD_HUMAN_SEAT_WALL_TABLET", 0, true)
    --end
    --SetModelAsNoLongerNeeded(hash)
end)


AddEventHandler("BuyIndustrialVehicles", function() 
    local playerCoords = GetEntityCoords(PlayerPedId())
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm1', {
        title    = "¿Es para tí o para tu empresa?",
        align    = 'top-left',
        elements = {
            {label = "Para mí", value = 'me'},
            {label = "Empresa", value = 'company'}
    }}, function(data, menu)
        if data.current.value == "company" then
            local shopElements = {}
			local authorizedVehicles = Config.AuthorizedVehicles[ESX.GetPlayerData().job.name]
			local shopCoords = Config.shopCoords--TODO

			if #authorizedVehicles > 0 then
				for k,vehicle in pairs(authorizedVehicles) do
					if IsModelInCdimage(vehicle.model) then
						local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))

						table.insert(shopElements, {
							label = ('%s - <span style="color:green;">%s</span>'):format(vehicleLabel,  ESX.Math.GroupDigits(vehicle.price).. " €"),
							name  = vehicleLabel,
							model = vehicle.model,
							price = vehicle.price,
							props = vehicle.props,
						})
					end
				end

				if #shopElements > 0 then
					OpenShopMenu(shopElements, playerCoords, shopCoords)
				end
            end
        elseif data.current.value == "me" then
            local shopElements = {}
			local authorizedVehicles = Config.AuthorizedPrivateVehicles
			local shopCoords = Config.shopCoords--TODO

			if #authorizedVehicles > 0 then
				for k,vehicle in pairs(authorizedVehicles) do
					if IsModelInCdimage(vehicle.model) then
						local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))

						table.insert(shopElements, {
							label = ('%s - <span style="color:green;">%s</span>'):format(vehicleLabel, ESX.Math.GroupDigits(vehicle.price).. " €"),
							name  = vehicleLabel,
							model = vehicle.model,
							price = vehicle.price,
							props = vehicle.props,
						})
					end
				end

				if #shopElements > 0 then
					OpenPrivateShopMenu(shopElements, playerCoords, shopCoords)
				end
            end
        end
    end,
    function(data, menu)
        menu.close()
    end)

end)

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = "Vehiculos industriales",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align    = 'top-left',
			elements = {
				{label = "No", value = 'no'},
				{label = "_Sí", value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate
				props.class = GetVehicleClass(vehicle)
                print("EFFF")
				ESX.TriggerServerCallback('esx_vehicleshop:buyVehicleCompany', function(bought)
					if bought then
						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

						isInShopMenu = false
						ESX.UI.Menu.CloseAll()

						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)

						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						ESX.ShowNotification("Tu compañía no puede permitirse ese veículo")
						menu2.close()
					end
				end,data.current.model, props.plate, shopCoords, props, "ambulance", data.current.price)
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)

		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(data.current.model)

			if data.current.props then
				ESX.Game.SetVehicleProperties(vehicle, data.current.props)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(elements[1].model)

		if elements[1].props then
			ESX.Game.SetVehicleProperties(vehicle, elements[1].props)
		end
	end)
end

function OpenPrivateShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = "Vehiculos industriales",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align    = 'top-left',
			elements = {
				{label = "No", value = 'no'},
				{label = "Sí", value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate
				props.class = GetVehicleClass(vehicle)


                --print("props: "..json.encode(props))
                ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(netveh)
                    Citizen.CreateThread(function() 
                        local veh
                        if netveh then
                            veh = NetToVeh(netveh)
                            while not DoesEntityExist(veh) do
                                Wait(400)
                                veh = NetToVeh(netveh)
                                print("no veh")
                            end
                            
                            IsInShopMenu = false
                            menu2.close()
                            menu.close()
                            local vehicleProps = {}
                            vehicleProps = ESX.Game.GetVehicleProperties(veh)
                            vehicleProps.plate = generatedPlate
                            --TriggerServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId', nil, vehicleProps , vehicleData.model, vehicleData.name)
                            isInShopMenu = false
                            ESX.UI.Menu.CloseAll()
    
                            DeleteSpawnedVehicles()
                            FreezeEntityPosition(playerPed, false)
                            SetEntityVisible(playerPed, true)
    
                            ESX.Game.Teleport(playerPed, restoreCoords)
                            --ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones[shop].ShopOutside.Pos, Config.Zones[shop].ShopOutside.Heading, function(vehicle)
                            --SetVehicleNumberPlateText(veh, generatedPlate)
                            --TriggerServerEvent('saveVehicleProperties',netveh, vehicleProps)
                            --end)
                        else
                            ESX.ShowNotification("No puedes permitirte este vehículo")
                        end
                    end)
                end, data.current.model, newPlate, Config.shopOutPos, props, data.current.price)
				--ESX.TriggerServerCallback('esx_vehicleshop:buyVehicleCompany', function(bought)
				--	if bought then
				--		ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))
--
				--		isInShopMenu = false
				--		ESX.UI.Menu.CloseAll()
--
				--		DeleteSpawnedVehicles()
				--		FreezeEntityPosition(playerPed, false)
				--		SetEntityVisible(playerPed, true)
--
				--		ESX.Game.Teleport(playerPed, restoreCoords)
				--	else
				--		ESX.ShowNotification(_U('vehicleshop_money'))
				--		menu2.close()
				--	end
				--end,data.current.model, props.plate, shopCoords, props, "ambulance")
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)

		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(data.current.model)

			if data.current.props then
				ESX.Game.SetVehicleProperties(vehicle, data.current.props)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(elements[1].model)

		if elements[1].props then
			ESX.Game.SetVehicleProperties(vehicle, elements[1].props)
		end
	end)
end


function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName("Cargando vehículo")
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end
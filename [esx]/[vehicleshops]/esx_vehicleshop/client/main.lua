local HasAlreadyEnteredMarker, IsInShopMenu = false, false
local currentDisplayVehicle, CurrentVehicleData = {}, {}
local CurrentActionData, Vehicles, Categories = {}, {}, {}
local cardealerBlip = nil

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(300)
	end
	
	

	Citizen.Wait(10000)

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function(categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vehicles)
		Vehicles = vehicles
	end)
end)

function getVehicleLabelFromModel(model)
	for k,v in pairs(Vehicles) do
		if v.model == model then
			return v.name
		end
	end
	return
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeletePlayer()
		DeleteAuto()
	end
end)

local carProviders = {
	{coords = vector3(129.53, -3219.5, 4.86), heading = 346.83, model = 'ig_avon'},
	{coords = vector3(153.01, -3210.41, 4.91), heading = 57.32, model = 'ig_bankman'},
	{coords = vector3(142.62, -3179.58, 4.86), heading = 175.47, model = 'ig_davenorton'}
}

local autoshops = {
	{coords = vector3(-56.4, -1099.06, 25.4), heading = 20.41},
	{coords = vector3(-42.09, -1673.45, 28.49), heading = 135.98},
	{coords = vector3(-151.62, -591.36, 166.0), heading = 217.87}
}

local pedEntitiesAuto = {}
local pedEntitiesPlayer = {}

DeletePlayer = function()
    for i=1, #pedEntitiesPlayer do
        local cardealer = pedEntitiesPlayer[i]
        if DoesEntityExist(cardealer) then
            DeletePed(cardealer)
            SetPedAsNoLongerNeeded(cardealer)
        end
    end
end

DeleteAuto = function()
    for i=1, #pedEntitiesAuto do
        local cardealer = pedEntitiesAuto[i]
        if DoesEntityExist(cardealer) then
            DeletePed(cardealer)
            SetPedAsNoLongerNeeded(cardealer)
        end
    end
end

function setupAutoMode()
	DeletePlayer()
	Citizen.CreateThread(function()
		for i = 1, #autoshops do
	        hash = GetHashKey('ig_barry')
	        RequestModel(hash)
	        while not HasModelLoaded(hash) do
				Wait(0)
			end
	        if not DoesEntityExist(pedEntitiesAuto[i]) then
	            pedEntitiesAuto[i] = CreatePed(4, hash, autoshops[i].coords.x, autoshops[i].coords.y, autoshops[i].coords.z, autoshops[i].heading)
	            SetEntityAsMissionEntity(pedEntitiesAuto[i])
	            SetBlockingOfNonTemporaryEvents(pedEntitiesAuto[i], true)
	            FreezeEntityPosition(pedEntitiesAuto[i], true)
	            SetEntityInvincible(pedEntitiesAuto[i], true)
	        end
	        SetModelAsNoLongerNeeded(hash)
	    end
	end)
	deleteCardealersBlip()
end

function setupPlayerMode()
	DeleteAuto()
	Citizen.CreateThread(function()
		for i = 1, #carProviders do
	        hash = GetHashKey(carProviders[i].model)
	        RequestModel(hash)
	        while not HasModelLoaded(hash) do
				Wait(0)
			end
	        if not DoesEntityExist(pedEntitiesPlayer[i]) then
	            pedEntitiesPlayer[i] = CreatePed(4, hash, carProviders[i].coords.x, carProviders[i].coords.y, carProviders[i].coords.z, carProviders[i].heading)
	            SetEntityAsMissionEntity(pedEntitiesPlayer[i])
	            SetBlockingOfNonTemporaryEvents(pedEntitiesPlayer[i], true)
	            FreezeEntityPosition(pedEntitiesPlayer[i], true)
	            SetEntityInvincible(pedEntitiesPlayer[i], true)
	        end
	        SetModelAsNoLongerNeeded(hash)
	    end
	end)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
		setupCardealersBlip()
	end
end

function deleteCardealersBlip()
	if DoesBlipExist(cardealerBlip) then
		RemoveBlip(cardealerBlip)
	end
end

function setupCardealersBlip()
	Citizen.CreateThread(function()
		if not DoesBlipExist(cardealerBlip) then		
			cardealerBlip = AddBlipForCoord(vector3(136.51, -3200.45, 5.86))
			
			SetBlipSprite (cardealerBlip, 596)
			SetBlipDisplay(cardealerBlip, 4)
			SetBlipScale  (cardealerBlip, 0.9)
			SetBlipColour  (cardealerBlip, 7)
			SetBlipAsShortRange(cardealerBlip, true)
			
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName('Proveedores de Coches')
			EndTextCommandSetBlipName(cardealerBlip)
		end
	end)
end

function updateShop()
	if Config.EnablePlayerManagement then
		setupPlayerMode()
	else
		setupAutoMode()
	end
end

RegisterNetEvent('esx_vehicleshop:openAutoMenu')
AddEventHandler('esx_vehicleshop:openAutoMenu', function(shop)
	ESX.TriggerServerCallback('esx_license:checkLicense', function(hasDriversLicense)
		if hasDriversLicense then
			OpenShopMenu(shop)
		else
			ESX.ShowNotification(_U('license_missing'))
		end
	end, GetPlayerServerId(PlayerId()), 'drive')
end)

RegisterNetEvent('esx_vehicleshop:openPlayerMenu')
AddEventHandler('esx_vehicleshop:openPlayerMenu', function(shop)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
		OpenShopMenu(shop)
	else
		ESX.ShowNotification('No eres ~g~VENDEDOR DE COCHES~w~!')
	end
end)

RegisterNetEvent('esx_vehicleshop:openBossMenu')
AddEventHandler('esx_vehicleshop:openBossMenu', function(shop)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
		if ESX.PlayerData.job.grade == 0 then
			OpenBossActionsMenu()
		else
			ESX.ShowNotification('No eres ~r~JEFE~w~!')
		end
	else
		ESX.ShowNotification('No eres ~g~VENDEDOR DE COCHES~w~!')
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

	if ESX.PlayerData.job.name == 'cardealer' then
		TriggerServerEvent('plusCardealer')
	end
end)

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function(categories)
	Categories = categories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function(vehicles)
	Vehicles = vehicles
end)

function DeleteDisplayVehicleInsideShop(shop)
	local attempt = 0
	if currentDisplayVehicle[shop] --[[ and DoesEntityExist(currentDisplayVehicle[shop])]] then
		--[[while DoesEntityExist(currentDisplayVehicle[shop]) and not NetworkHasControlOfEntity(currentDisplayVehicle[shop]) and attempt < 100 do -- no networkeado solo local
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(currentDisplayVehicle[shop])
			attempt = attempt + 1
		end]]
		--DeleteVehicle(currentDisplayVehicle[shop])
		--if DoesEntityExist(currentDisplayVehicle[shop]) --[[and NetworkHasControlOfEntity(currentDisplayVehicle[shop])]] then
			ESX.Game.DeleteVehicle(currentDisplayVehicle[shop])
			while DoesEntityExist(currentDisplayVehicle[shop]) do
				Citizen.Wait(500)
			end
			currentDisplayVehicle[shop] = nil
		--end
		
		--TriggerServerEvent("esx:deleteSVehicle", ObjToNet(currentDisplayVehicle[shop]))
	end
	--DeleteVehicle(currentDisplayVehicle[shop])
end

function ReturnVehicleProvider()
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}
		for k,v in pairs(vehicles) do
			local returnPrice = ESX.Math.Round(v.price * 0.75)
			local vehicleLabel = getVehicleLabelFromModel(v.vehicle)

			table.insert(elements, {
				label = ('%s [<span style="color:orange;">%s</span>]'):format(vehicleLabel, _U('generic_shopitem', ESX.Math.GroupDigits(returnPrice))),
				value = v.vehicle
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_provider_menu', {
			title    = _U('return_provider_menu'),
			align    = 'left',
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('esx_vehicleshop:returnProvider', data.current.value)

			Citizen.Wait(300)
			menu.close()
			ReturnVehicleProvider()
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function StartShopRestriction()
	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(0)

			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local tempFix = false
function OpenShopMenu(shop)
	if Vehicles == {} then
		print('[esx_vehicleshop] [^3ERROR^7] No vehicles found')
		return
	end
	IsInShopMenu = true

	StartShopRestriction()
	ESX.UI.Menu.CloseAll()

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	if Config.EnablePlayerManagement then
		SetEntityCoords(playerPed, Config.Zones[shop].playerShopInside.Pos)
	else
		SetEntityCoords(playerPed, Config.Zones[shop].ShopEntering.Pos)
	end

	local vehiclesByCategory = {}
	local elements           = {}

	for k,v in pairs(Categories) do
		vehiclesByCategory[v.name] = {}
	end

	vehicleClass = ''

	if shop == 'low' then
		vehicleClass = 'l'
	elseif shop == 'mid' then
		vehicleClass = 'm'
	else
		vehicleClass = 'h'
	end

	print(json.encode(Vehicles))
	for k,v in pairs(Vehicles) do
		if IsModelInCdimage(GetHashKey(v.model)) then
			if v.class == vehicleClass then -- TODO poner bien no hardcode para test
				print("yeah")
				if Config.EnablePlayerManagement then
					local newveh = {table.unpack(v)}
					newveh.price = v.price * 0.75
					table.insert(vehiclesByCategory[v.category], v)
				else
					table.insert(vehiclesByCategory[v.category], v)
				end		
			end
		else
			print(('[esx_vehicleshop] [^3ERROR^7] Vehicle "%s" does not exist'):format(Vehicles[i].model))
		end
	end

	for k,v in pairs(vehiclesByCategory) do
		table.sort(v, function(a, b)
			return a.name < b.name
		end)
	end
	print(json.encode(Categories))
	for k,v in pairs(Categories) do
		local category         = v
		local categoryVehicles = vehiclesByCategory[category.name]
		local options          = {}

		print(json.encode(categoryVehicles))
		for j,z in pairs(categoryVehicles) do
			local vehicle = z

			table.insert(options, ('%s <span style="color:green;">%s</span>'):format(vehicle.name, _U('generic_shopitem', ESX.Math.GroupDigits(vehicle.price))))
		end
	
		if #options > 0 then
			table.sort(options)
			table.insert(elements, {
				name    = category.name,
				label   = category.label,
				value   = 0,
				type    = 'slider',
				max     = tablelength(v),
				options = options
			})
		end		
	end

	print(json.encode(elements))

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('car_dealer'),
		align    = 'left',
		elements = elements
	}, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
			align = 'left',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then

				if Config.EnablePlayerManagement then
					ESX.TriggerServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(success)
						if success then
							IsInShopMenu = false
							DeleteDisplayVehicleInsideShop(shop)

							CurrentAction     = 'shop_menu'
							CurrentActionMsg  = _U('shop_menu')
							CurrentActionData = {}

							local playerPed = PlayerPedId()
							FreezeEntityPosition(playerPed, false)
							SetEntityVisible(playerPed, true)
							SetEntityCoords(playerPed, Config.Zones[shop].playerShopInside.Pos)

							menu2.close()
							menu.close()
							ESX.ShowNotification(_U('vehicle_purchased'))
						else
							ESX.ShowNotification(_U('broke_company'))
						end
					end, vehicleData.model)
				else
					local generatedPlate = GeneratePlate()
					local vehicleProps = ESX.Game.GetVehicleProperties(currentDisplayVehicle[shop])
					vehicleProps.class = GetVehicleClass(currentDisplayVehicle[shop])
					print("props: "..json.encode(vehicleProps))
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
								DeleteDisplayVehicleInsideShop(shop)
								FreezeEntityPosition(playerPed, false)
								--ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones[shop].ShopOutside.Pos, Config.Zones[shop].ShopOutside.Heading, function(vehicle)
								TaskWarpPedIntoVehicle(playerPed, veh, -1)
								--SetVehicleNumberPlateText(veh, generatedPlate)
								--TriggerServerEvent('saveVehicleProperties',netveh, vehicleProps)
								
								SetEntityVisible(playerPed, true)
								--end)
							else
								ESX.ShowNotification(_U('not_enough_money'))
							end
						end)
					end, vehicleData.model, generatedPlate, Config.Zones[shop].ShopOutside.Pos, vehicleProps)
				end
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
		DeleteDisplayVehicleInsideShop(shop)
		local playerPed = PlayerPedId()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		if Config.EnablePlayerManagement then
			SetEntityCoords(playerPed, Config.Zones[shop].playerShopInside.Pos)
		else
			SetEntityCoords(playerPed, Config.Zones[shop].ShopEntering.Pos)
		end
		

		IsInShopMenu = false
	end, function(data, menu)
		
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()
		DeleteDisplayVehicleInsideShop(shop)
		--DeleteSpawnedVehicles()
		print(json.encode(vehicleData))
		--Citizen.Wait(1000)
		if vehicleData then			
			WaitForVehicleToLoad(vehicleData.model)
			if currentDisplayVehicle[shop] == nil then
				if not tempFix then
					tempFix = true
					if Config.EnablePlayerManagement then
						ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones[shop].playerShopInside.Pos, Config.Zones[shop].playerShopInside.Heading, function(vehicle)
							currentDisplayVehicle[shop] = vehicle
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
							FreezeEntityPosition(vehicle, true)
							SetModelAsNoLongerNeeded(vehicleData.model)
							tempFix = false
						end)
					else
						ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones[shop].ShopInside.Pos, Config.Zones[shop].ShopInside.Heading, function(vehicle)
							currentDisplayVehicle[shop] = vehicle
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
							FreezeEntityPosition(vehicle, true)
							SetModelAsNoLongerNeeded(vehicleData.model)
							tempFix = false
						end)
					end
				end
			end
		end
	end)
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(_U('shop_awaiting_model'))
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

RegisterNetEvent('esx_vehicleshop:pop_vehicle')
AddEventHandler('esx_vehicleshop:pop_vehicle', function(shop)
	OpenPopVehicleMenu(shop)
end)

RegisterNetEvent('esx_vehicleshop:depop_vehicle')
AddEventHandler('esx_vehicleshop:depop_vehicle', function(shop)
	if currentDisplayVehicle[shop] then
		DeleteDisplayVehicleInsideShop(shop)
	else
		ESX.ShowNotification(_U('no_current_vehicle'))
	end
end)

RegisterNetEvent('esx_vehicleshop:give_vehicle')
AddEventHandler('esx_vehicleshop:give_vehicle', function(shop)
	if currentDisplayVehicle[shop] then
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if closestPlayer ~= -1 and closestDistance < 3 then
			local newPlate = GeneratePlate()
			local vehicleProps = ESX.Game.GetVehicleProperties(currentDisplayVehicle[shop])
			vehicleProps.plate = newPlate
			vehicleProps.class = GetVehicleClass(currentDisplayVehicle[shop])
			SetVehicleNumberPlateText(currentDisplayVehicle[shop], newPlate)
			ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function()
				DeleteEntity(currentDisplayVehicle[shop])
				currentDisplayVehicle[shop] = nil
			end, CurrentVehicleData[shop].model, newPlate, Config.Zones[shop].ShopOutside.Pos, vehicleProps, false, GetPlayerServerId(closestPlayer))
			--TriggerServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId', , vehicleProps, CurrentVehicleData[shop].model, CurrentVehicleData[shop].name)
			
		else
			ESX.ShowNotification(_U('no_players'))
		end
	else
		ESX.ShowNotification(_U('no_current_vehicle'))
	end
end)

RegisterNetEvent('esx_vehicleshop:billing_ui')
AddEventHandler('esx_vehicleshop:billing_ui', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance < 3 then
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vehicle_owner_sell_amount', {
			title = _U('invoice_amount')
		}, function(data2, menu2)
			local amount = tonumber(data2.value)

			if amount == nil then
				ESX.ShowNotification(_U('invalid_amount'))
			else
				menu2.close()
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification(_U('no_players'))
				else
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_cardealer', _U('car_dealer'), tonumber(data2.value))
				end
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	else
		ESX.ShowNotification(_U('no_players'))
	end
end)

RegisterNetEvent('esx_vehicleshop:inventory_ui')
AddEventHandler('esx_vehicleshop:inventory_ui', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cardealer' then
		TriggerEvent('esx_generic_inv_ui:openSociety', 'cardealer', 'Almacen')
	else
		ESX.ShowNotification('No eres ~g~VENDEDOR DE COCHES~w~!')
	end
end)

function OpenPopVehicleMenu(shop)
	ESX.TriggerServerCallback('esx_vehicleshop:getCommercialVehicles', function(vehicles)
		local elements = {}

		if shop == 'low' then
			vehicleClass = 'l'
		elseif shop == 'mid' then
			vehicleClass = 'm'
		else
			vehicleClass = 'h'
		end
		print(json.encode(vehicles))
		for k,v in pairs(vehicles) do
			print(v.class, vehicleClass, v.vehicle)
			if v.class == vehicleClass and v.count > 0 then
				local vehicleLabel = getVehicleLabelFromModel(v.vehicle)

				table.insert(elements, {
					label = ('%s [MSRP <span style="color:green;">%s</span>]'):format(vehicleLabel, _U('generic_shopitem', ESX.Math.GroupDigits(v.price))),
					value = v.vehicle
				})
			end			
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'commercial_vehicles', {
			title    = _U('vehicle_dealer'),
			align    = 'left',
			elements = elements
		}, function(data, menu)
			local model = data.current.value
			if currentDisplayVehicle[shop] then
				DeleteDisplayVehicleInsideShop(shop)
			end
			
			ESX.Game.SpawnVehicle(model, Config.Zones[shop].ShopInside.Pos, Config.Zones[shop].ShopInside.Heading, function(vehicle)
				currentDisplayVehicle[shop] = vehicle
				FreezeEntityPosition(currentDisplayVehicle[shop], true)
				for k,v in pairs(Vehicles) do
					if model == v.model then
						CurrentVehicleData[shop] = v
						break
					end
				end
			end, true)
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBossActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reseller',{
		title    = _U('dealer_boss'),
		align    = 'left',
		elements = {
			{label = _U('boss_actions'), value = 'boss_actions'},
			{label = _U('boss_sold'), value = 'sold_vehicles'}
	}}, function(data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'cardealer', function(data2, menu2)
				menu2.close()
		end)
		elseif data.current.value == 'sold_vehicles' then

			ESX.TriggerServerCallback('esx_vehicleshop:getSoldVehicles', function(customers)
				local elements = {
					head = { _U('customer_client'), _U('customer_model'), _U('customer_plate'), _U('customer_soldby'), _U('customer_date') },
					rows = {}
				}

				for i=1, #customers, 1 do
					table.insert(elements.rows, {
						data = customers[i],
						cols = {
							customers[i].client,
							customers[i].model,
							customers[i].plate,
							customers[i].soldby,
							customers[i].date
						}
					})
				end
				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'sold_vehicles', elements, function(data2, menu2)

				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'boss_actions_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if ESX.PlayerData.job.name == 'cardealer' and job.name ~= 'cardealer' then
		TriggerServerEvent('lessCardealer')
	end

	ESX.PlayerData.job = job

	if ESX.PlayerData.job.name == 'cardealer' then
		TriggerServerEvent('plusCardealer')
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Zones['low'].ShopEntering.Pos)
		end

		DeleteDisplayVehicleInsideShop('low')
	end
end)

if Config.EnablePlayerManagement then
	RegisterNetEvent('esx_phone:loaded')
	AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
		local specialContact = {
			name       = _U('dealership'),
			number     = 'cardealer',
			base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAMAAABrrFhUAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAADMzMzszM0M0M0w0M1Q1M101M2U2M242M3Y3M383Moc4MpA4Mpg5MqE5Mqk6MrI6Mro7Mrw8Mr89M71DML5EO8I+NMU/NcBMLshANctBNs5CN8RULMddKsheKs9YLtBCONZEOdlFOtxGO99HPNhMNsplKM1nKM1uJtRhLddiLt5kMNJwJ9B2JNR/IeNIPeVJPehKPuRQOuhSO+lZOOlhNuloM+p3Lep/KupwMMFORsVYUcplXc1waNJ7delUSepgVexrYe12bdeHH9iIH9qQHd2YG+udH+OEJeuGJ+uOJeuVIuChGeSpF+aqGOykHOysGeeyFeuzFuyzFuq6E+27FO+Cee3CEdaGgdqTjvCNhfKYkvOkngAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJezdycAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGHRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4xLjb9TgnoAAAQGElEQVR4Xt2d+WMUtxXHbS6bEGMPMcQQ04aEUnqYo9xJWvC6kAKmQLM2rdn//9+g0uir2Tl0PElPszP7+cnH7Fj6rPTeG2lmvfKld2azk8lk/36L/cnkZDbDIT3Sp4DZ8QS9dTI57tNDTwJOOu+4j/0TvDQz+QXMSG+7mUn+sZBZQELnNROcKhMZBXx+gS4k8+IzTpmBXAJOnqPxTDzPFRKyCODuvSKPgwwC2EZ+lxf4E4xwCzhBU7PBPQx4BWR88+fwDgNGAbMsM9/Ec8bygE3A5966L3nOlhiZBGSf+l2YggGLgBna1DMsE4FBQH9zvw1HLEgX0Evkt5GeEVIFMFztpJF6rZQm4DNasVDSEkKSgIVN/ibP0ZwoEgQsfPTPSZgH8QIG8vYr4gdBrIABvf2K2EEQKWBQb78ichBECRhE8O8SlQ5iBAQvcffFPhoYQoSAAQ5/TcQ0CBYw0OGvCZ4GoQIGF/3bhGaDQAELvfKhERgIwgQMePrPCQsEQQLwFwYPmksiQMCC1n1iCFgooQtYwLJfPPQFQ7KAUfU/wABVwMj6TzdAFDDY6tcOMR3SBIyw/1QDJAGj7D/RAEXA6Oa/hhIHCAJG23+SAb+AEfefYsArYET1nwlvTegVgBONFnTDik8ATjNi0BEbHgGjuP5147k6dgsYaQHQxF0OOAUMfv2LhnOVzCVg4OufdFwrpS4BePkSgA6ZcAhYggCocQRCu4ClCIAaeyC0CliaAKCwhgGrALxwaUC3OtgELFEAUNjCgEXAklQAdSzVgEUAXrRUoGstzAKWbgJIzJPAKGAJJ4DEOAmMAvCCpQPda2ASsJQTQGKa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',
		}

		TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
	end)
end

-- Create Blips
Citizen.CreateThread(function()
	for j,h in pairs(Config.Zones) do
		for i=0, #h do
			local blip = nil
			if j == "high" then
				blip = AddBlipForCoord(vector3(-141.76, -604.64, 166.6))
			else
				blip = AddBlipForCoord(h.ShopEntering.Pos)
			end
			
			SetBlipSprite (blip, h.ShopEntering.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, h.ShopEntering.spriteSize)
			SetBlipColour  (blip, 31)
			SetBlipAsShortRange(blip, true)
			
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(h.ShopEntering.spriteName)
			EndTextCommandSetBlipName(blip)
		end
	end	
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		if #(playerCoords - Config.Zones.mid.ResellVehicle.Pos) < 30.0 then
			DrawMarker(Config.Zones.mid.ResellVehicle.Type, Config.Zones.mid.ResellVehicle.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.mid.ResellVehicle.Size.x, Config.Zones.mid.ResellVehicle.Size.y, Config.Zones.mid.ResellVehicle.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
			if #(playerCoords - Config.Zones.mid.ResellVehicle.Pos) < 3.0 then
				ESX.ShowHelpNotification('Pulsa ~g~E~w~ para vender tu vehiculo')
				if IsControlJustReleased(0, 38) then
					local vehicleToSell = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
					if vehicleToSell then
						ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold)
							if vehicleSold[1] then
								ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
								ESX.ShowNotification(_U('vehicle_sold_for', 'tu vehiculo', ESX.Math.GroupDigits(vehicleSold[2])))
							else
								ESX.ShowNotification(_U('not_yours'))
							end
						end, vehicleToSell.plate, vehicleToSell.model)
					else
						ESX.ShowNotification('Tienes que traer un vehiculo para poder venderlo!')
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15000)
		ESX.TriggerServerCallback('getCardealers', function(cardealers)
			if cardealers > 0 then
				Config.EnablePlayerManagement = true
			else
				Config.EnablePlayerManagement = false
			end
			updateShop()
		end)
	end 
end)
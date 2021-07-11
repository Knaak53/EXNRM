local CurrentAction = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local cont = true
local price = Config.Price
local this_Garage = {}
-- Fin Local

-- Init ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)
-- Fin init ESX

--- Gestion Des blips
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    --PlayerData = xPlayer
    --TriggerServerEvent('esx_jobs:giveBackCautionInCaseOfDrop')
	refreshBlips()
	DecorRegister("car_id",3)
end)

function refreshBlips()
	local zones = {}
	local blipInfo = {}	

	for zoneKey,zoneValues in pairs(Config.Garages)do
		if  zoneValues.Pos.blip then
			local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
			if zoneKey == "Centre" then
			     SetBlipSprite (blip, 290)
			     SetBlipColour (blip, 49)
			     SetBlipScale  (blip, 1.0)
			else
			    SetBlipSprite (blip, Config.BlipInfos.Sprite)
			    SetBlipColour (blip, Config.BlipInfos.Color)
			    SetBlipScale  (blip, 0.8)
			end
			SetBlipDisplay(blip, 4)
			
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(zoneValues.name)
			EndTextCommandSetBlipName(blip)
		end
	end
end
refreshBlips()
-- Fin Gestion des Blips

function OpenMenuGarage(opc,coord,coord1)
	
	
	ESX.UI.Menu.CloseAll()

	

	if opc == nil then
		local elements = {
		{label = "Lista de vehículoss", value = 'list_vehicles'},
		{label = "Recuperar vehículo ("..Config.Price.."€)", value = 'return_vehicle'},
		}
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'garage_menu',
			{
				title    = 'Garaje',
				align    = 'left',
				elements = elements,
			},
			function(data, menu)

				menu.close()
				if(data.current.value == 'list_vehicles') then
					ListVehiclesMenu()
				end
				if(data.current.value == 'stock_vehicle') then
					StockVehicleMenu()
				end
				if(data.current.value == 'return_vehicle') then
					ReturnVehicleMenu()
				end

				local playerPed = GetPlayerPed(-1)
				SpawnVehicle(data.current.value)
				--local coords    = societyConfig.Zones.VehicleSpawnPoint.Pos

			end,
			function(data, menu)
				menu.close()
				--CurrentAction = 'open_garage_action'
			end)
	else
		local elements = {
		{label = "Lista de vehículoss", value = 'list_vehicles'},
		{label = "Recuperar vehículo ("..Config.Price.."€)", value = 'return_vehicle'},
		}
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'garage_menu',
			{
				title    = 'Garaje',
				align    = 'left',
				elements = elements,
			},
			function(data, menu)

				menu.close()
				if(data.current.value == 'list_vehicles') then
					ListVehiclesMenu(opc,coord)
				end
				if(data.current.value == 'return_vehicle') then
					ReturnVehicleMenu(opc,coord)
				end


			end,
			function(data, menu)
				menu.close()
				--CurrentAction = 'open_garage_action'
			end)
	end
end
-- Afficher les listes des vehicules
function ListVehiclesMenu(opc,coord)
	local elements = {}

	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)

		local haveMoney = false

		ESX.TriggerServerCallback('eden_garage:getMoney', function(money)
			haveMoney = money
		end,price)

		for _,v in pairs(vehicles) do

			local hashVehicule = v.vehicle.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
			local labelvehicle
			local id = v.id

    		if(v.state)then
    		labelvehicle = vehicleName..': Dentro'
    		print(v)
    		else
    		labelvehicle = vehicleName..': Fuera'
    		end	
			table.insert(elements, {label =labelvehicle , value = v})
			
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = 'Garaje',
			align    = 'center',
			elements = elements,
		},
		function(data, menu)
			if(data.current.value.state)then
				menu.close()
				if opc == nil then
					SpawnVehicle(data.current.value.vehicle,id)
				else
					SpawnVehicle(data.current.value.vehicle,opc,coord,id)
				end
			else
				TriggerEvent('esx:showNotification', 'Su vehículo ya está fuera')
			end
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end)	
	end)
end
-- Fin Afficher les listes des vehicules

-- Fonction qui permet de rentrer un vehicule
function StockVehicleMenu(opc,coord1)
	if opc == nil then
		local playerPed  = GetPlayerPed(-1)
		if IsAnyVehicleNearPoint(this_Garage.DeletePoint.Pos.x,  this_Garage.DeletePoint.Pos.y,  this_Garage.DeletePoint.Pos.z,  3.5) then

			local vehicle       = GetClosestVehicle(this_Garage.DeletePoint.Pos.x, this_Garage.DeletePoint.Pos.y, this_Garage.DeletePoint.Pos.z, this_Garage.DeletePoint.Size.x, 0, 70)
			local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
			local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
			local engineHealth  = GetVehicleEngineHealth(current)
			local id = DecorGetInt(vehicle,"car_id")

			ESX.TriggerServerCallback('eden_garage:stockv',function(valid)

				if (valid) then
					TriggerServerEvent('eden_garage:modifystate', true, vehicleProps.plate)
					deleteCar(vehicle)
					-------------------------------------------------------
					TriggerEvent('esx:showNotification', 'Su vehículo está en el garaje')
				else
					TriggerEvent('esx:showNotification', 'No puede almacenar este vehículo')
				end
			end,vehicleProps, id)
		else
			TriggerEvent('esx:showNotification', 'No hay vehículo que guardar')
		end
	else
		local playerPed  = GetPlayerPed(-1)
		if IsAnyVehicleNearPoint(coord1.x, coord1.y, coord1.z,  6.5) then
			local vehicle       = GetClosestVehicle(coord1.x, coord1.y, coord1.z, 6.5, 0, 70)
			local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
			local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
			local engineHealth  = GetVehicleEngineHealth(current)
			local id = DecorGetInt(vehicle,"car_id")

			ESX.TriggerServerCallback('eden_garage:stockv',function(valid)
				if (valid) then
					deleteCar(vehicle)
					TriggerEvent('esx:showNotification', 'He borrado')
					TriggerServerEvent('eden_garage:modifystate', true, vehicleProps.plate)
					TriggerEvent('esx:showNotification', 'Su vehículo está en el garaje')
				else
					TriggerEvent('esx:showNotification', 'No puede almacenar este vehículo')
				end
			end,vehicleProps,id)
		else
			TriggerEvent('esx:showNotification', 'No hay vehículo que guardar')
		end
	end
end
-- Fin fonction qui permet de rentrer un vehicule 
--Fin fonction Menu

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end


--Fonction pour spawn vehicule
function SpawnVehicle(vehicle,opc,coord,id)
		print(vehicle.plate)
		if opc == nil then
			local car = GetClosestVehicle(this_Garage.SpawnPoint.Pos.x ,this_Garage.SpawnPoint.Pos.y,this_Garage.SpawnPoint.Pos.z + 1,  3.0,  0,  71)
			if not DoesEntityExist(car) then
				local id = nil
				ESX.Game.SpawnVehicle(vehicle.model, {
					x = this_Garage.SpawnPoint.Pos.x ,
					y = this_Garage.SpawnPoint.Pos.y,
					z = this_Garage.SpawnPoint.Pos.z + 1.5											
					},this_Garage.SpawnPoint.h, function(callback_vehicle)
					if vehicle.neonColor then
						neon = {vehicle.neonColor['1'], vehicle.neonColor['2'], vehicle.neonColor['3']}
						vehicle.neonColor = neon
					end
					if vehicle.tyreSmokeColor then
						tyre = {vehicle.tyreSmokeColor['1'], vehicle.tyreSmokeColor['2'], vehicle.tyreSmokeColor['3']}
						vehicle.tyreSmokeColor = tyre
					end
					
					ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
					SetPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
					exports["LegacyFuel"]:SetFuel(callback_vehicle, 50)
					TriggerServerEvent('eden_garage:modifystate', false, vehicle.plate)
				end)
			else
				ESX.ShowNotification('Ya hay un vehículo en el punto de spawn')
			end
		else
			local car = GetClosestVehicle(coord.x ,coord.y,coord.z + 1,  3.0,  0,  71)
			 if not DoesEntityExist(car) then
				local id
				ESX.Game.SpawnVehicle(vehicle.model, {
					x = coord.x ,
					y = coord.y,
					z = coord.z + 1,											
					},this_Garage.SpawnPoint.h, function(callback_vehicle)
					if vehicle.neonColor then
						neon = {vehicle.neonColor['1'], vehicle.neonColor['2'], vehicle.neonColor['3']}
						vehicle.neonColor = neon
					end
					if vehicle.tyreSmokeColor then
						tyre = {vehicle.tyreSmokeColor['1'], vehicle.tyreSmokeColor['2'], vehicle.tyreSmokeColor['3']}
						vehicle.tyreSmokeColor = tyre
					end
					print(vehicle.plate)
					ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
					SetPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
					exports["LegacyFuel"]:SetFuel(callback_vehicle, 50)
					TriggerServerEvent('eden_garage:modifystate', false, GetVehicleNumberPlateText(callback_vehicle))
					end)
			else
				ESX.ShowNotification('Ya hay un vehículo en el punto de spawn')
			end
		end
end

function ReturnVehicleMenu(opc,coord)
		ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)

			local elements = {}

			for _,v in pairs(vehicles) do

				local hashVehicule = v.model
	    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
	    		local labelvehicle

	    		labelvehicle = vehicleName..': Fuera'
	    	
				table.insert(elements, {label =labelvehicle , value = v})
				
			end
			if opc == nil then

				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'return_vehicle',
				{
					title    = 'Garaje',
					align    = 'center',
					elements = elements,
				},
				function(data, menu)

					ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
						menu.close()
						if hasEnoughMoney then
							if cont then
								contador()
								local car = GetClosestVehicle(this_Garage.SpawnPoint.Pos.x ,this_Garage.SpawnPoint.Pos.y,this_Garage.SpawnPoint.Pos.z + 1,  3.0,  0,  71)
								if not DoesEntityExist(car) then
									TriggerServerEvent('eden_garage:pagoPop')
									SpawnVehicle(data.current.value)
								else
									ESX.ShowNotification('Ya hay un coche en el punto de spawn')
								end
							else
								ESX.ShowNotification('Tienes que esperar un rato para volver a sacar el vehículo')			
							end
						else
							ESX.ShowNotification('No tienes suficiente dinero')						
						end
					end)
				end,
				function(data, menu)
					menu.close()
					--CurrentAction = 'open_garage_action'
				end
				)
			else
				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'return_vehicle',
				{
					title    = 'Garaje',
					align    = 'center',
					elements = elements,
				},
				function(data, menu)

					ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
						if hasEnoughMoney then
							if cont then
								contador()
								local car = GetClosestVehicle(this_Garage.SpawnPoint.Pos.x ,this_Garage.SpawnPoint.Pos.y,this_Garage.SpawnPoint.Pos.z + 1,  3.0,  0,  71)
								if not DoesEntityExist(car) then
									TriggerServerEvent('eden_garage:pay')
									SpawnVehicle(data.current.value)
								else
									ESX.ShowNotification('Ya hay un coche en el punto de spawn')	
								end
							else
								ESX.ShowNotification('Tienes que esperar un rato para volver a sacar el vehículo')			
							end
						else
							ESX.ShowNotification('No tienes suficiente dinero')						
						end
					end)
				end,
				function(data, menu)
					menu.close()
					--CurrentAction = 'open_garage_action'
				end
				)
			end
		end)
end

function contador()
	Citizen.CreateThread(function()
		cont = false
		Citizen.Wait(1000*60*30)
		cont = true
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteWomans()
	end
end)

RegisterNetEvent('esx_eden_garage:openMenu_ui')
AddEventHandler('esx_eden_garage:openMenu_ui', function(coords)
	Citizen.Wait(250)
	for k,v in pairs(Config.Garages) do
		if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 1.0 then
			this_Garage = v
			OpenMenuGarage()
		end
	end
end)

local pedEntities = {}

DeleteWomans = function()
    for i=1, #pedEntities do
        local woman = pedEntities[i]
        if DoesEntityExist(woman) then
           -- DeletePed(woman)
           --SetPedAsNoLongerNeeded(woman)
        end
    end
end

Citizen.CreateThread(function()
	pedsIndex = 1
	for k,v in pairs(Config.Garages) do
        hash = GetHashKey('ig_mrk')
        RequestModel(hash)
        while not HasModelLoaded(hash) do
			Wait(0)
		end
        if not DoesEntityExist(pedEntities[pedsIndex]) then
            pedEntities[pedsIndex] = CreatePed(4, hash, v.Pos.x, v.Pos.y, v.Pos.z - 1.0, v.Heading)
            SetEntityAsMissionEntity(pedEntities[pedsIndex])
            SetBlockingOfNonTemporaryEvents(pedEntities[pedsIndex], true)
            FreezeEntityPosition(pedEntities[pedsIndex], true)
            SetEntityInvincible(pedEntities[pedsIndex], true)
        end
        SetModelAsNoLongerNeeded(hash)
        pedsIndex = pedsIndex + 1
    end
end)

local closestDelete = {}
local close = false

-- Affichage markers
Citizen.CreateThread(function()
	while true do
		Wait(0)		
		local coords = GetEntityCoords(GetPlayerPed(-1))			
		
		for k,v in pairs(Config.Garages) do
			if(GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < Config.DrawDistance) then		
				closestDelete = v.DeletePoint	
				close = true
				break
			else
				close = false
			end		
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if close then
			DrawMarker(closestDelete.Marker, closestDelete.Pos.x, closestDelete.Pos.y, closestDelete.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, closestDelete.Size.x, closestDelete.Size.y, closestDelete.Size.z, closestDelete.Color.r, closestDelete.Color.g, closestDelete.Color.b, 100, false, true, 2, false, false, false, false)	
			if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), closestDelete.Pos.x, closestDelete.Pos.y, closestDelete.Pos.z, true) <= 3) then		
				DrawText3D(closestDelete.Pos.x, closestDelete.Pos.y, closestDelete.Pos.z + 1, "Pulsa E para guardar el vehículo", 255,0,0)
				if IsControlJustReleased(0, 38) then
					if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						StockVehicleMenua()
					else
						TriggerEvent('esx:showNotification', "No hay ningun coche que guardar")
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

function StockVehicleMenua()
		local playerPed  = GetPlayerPed(-1)
		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			SetEntityAsMissionEntity( vehicle, true, true )
			local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
			local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
			local engineHealth  = GetVehicleEngineHealth(current)
			local id = DecorGetInt(vehicle,"car_id")

			ESX.TriggerServerCallback('eden_garage:stockv',function(valid)

			if (valid) then
				deleteCar( vehicle )

				TriggerServerEvent('llaves:removearrayllaves',GetVehicleNumberPlateText(vehicle))
				TriggerServerEvent('eden_garage:modifystate', true,vehicleProps.plate)
					------------------------------------------------------- sauvegarde de l'etat du vehicule
				TriggerEvent('esx:showNotification', 'Su vehículo está en el garaje')
			else
				TriggerEvent('esx:showNotification', 'No puedes almacenar este vehículo')
			end
			end,vehicleProps,id)
		else
			TriggerEvent('esx:showNotification', 'No hay vehículo que guardar')
		end
end
-- Fin affichage markers
function DrawText3D(x,y,z, text, r,g,b) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function deleteCarX(x,y,z)
	Citizen.CreateThread(function ()
		Citizen.Wait(500)
		local vehicleu = GetClosestVehicle(x,y,z, 6.5, 0, 70)
		SetEntityAsMissionEntity( vehicleu, true, true )
		Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( vehicleu ) )
	end)
	
end

-- Fin activer le menu quand player dedans
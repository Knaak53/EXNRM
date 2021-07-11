-- C O N F I G --
interactionDistance = 3.5 --The radius you have to be in to interact with the vehicle.
lockDistance = 25 --The radius you have to be in to lock your vehicle.

--  V A R I A B L E S --
engineoff = false
saved = false
controlsave_bool = false

Citizen.CreateThread(function() 
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)
-- E N G I N E --
IsEngineOn = false

RegisterNetEvent("vehicle-control:putEngineOff")
AddEventHandler("vehicle-control:putEngineOff", function(vehicle) 
	local local_vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	print(local_vehicle .. " =? ".. vehicle)
	if local_vehicle == vehicle then
		IsEngineOn = false
		SetVehicleEngineOn(local_vehicle,false,false,true)
	end
end)
RegisterNetEvent('engine')
AddEventHandler('engine',function() 
	local player = GetPlayerPed(-1)
	
	if (IsPedSittingInAnyVehicle(player)) then 
		local vehicle = GetVehiclePedIsIn(player,false)
		local plate = GetVehicleNumberPlateText(vehicle)
		TriggerEvent("esx:hasKeys", plate, function(haveKeys) 
			--print("Que paza?".. haveKeys)
			if IsEngineOn == true and haveKeys then
				print("APago")
				IsEngineOn = false
				SetVehicleEngineOn(vehicle,false,false,true)
			elseif haveKeys then
				print("Enciendo")
				IsEngineOn = true
				SetVehicleUndriveable(vehicle,false)
				SetVehicleEngineOn(vehicle,true,false,true)
			else
				print("Poh no")
			end
		end)
		
		
		while (IsEngineOn == false) do
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
		end
	end
end)

RegisterNetEvent('engineoff')
AddEventHandler('engineoff',function() 
		local player = GetPlayerPed(-1)

        if (IsPedSittingInAnyVehicle(player)) then 
            local vehicle = GetVehiclePedIsIn(player,false)
			engineoff = true
			ShowNotification("Engine ~r~off~s~.")
			while (engineoff) do
			SetVehicleEngineOn(vehicle,false,false,false)
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
			end
		end
end)
RegisterNetEvent('engineon')
AddEventHandler('engineon',function() 
    local player = GetPlayerPed(-1)

        if (IsPedSittingInAnyVehicle(player)) then 
            local vehicle = GetVehiclePedIsIn(player,false)
			engineoff = false
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
			ShowNotification("Engine ~g~on~s~.")
	end
end)
-- T R U N K --
RegisterNetEvent('trunk')
AddEventHandler('trunk',function() 
	local player = GetPlayerPed(-1)
			if controlsave_bool == true then
				vehicle = saveVehicle
			else
				vehicle = GetVehiclePedIsIn(player,true)
			end
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,5)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			--if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
					print(ObjToNet(vehicle))
					TriggerServerEvent("vehcontrol:opentrunk", ObjToNet(vehicle),5)
				
				else
					print(ObjToNet(vehicle))
					TriggerServerEvent("vehcontrol:closetrunk", ObjToNet(vehicle),5)
				end
			--else
				--ShowNotification("~r~You must be near your vehicle to do that.")
			--end
end)

RegisterNetEvent("vehcontrol:closetrunk")
AddEventHandler("vehcontrol:closetrunk",function(vehId, doornum) 
	local vehicle = NetToEnt(vehId)
	print(ObjToNet(vehicle))
	SetVehicleDoorShut(vehicle,doornum,0,0)
end)

RegisterNetEvent("vehcontrol:opentrunk")
AddEventHandler("vehcontrol:opentrunk",function(vehId, doornum) 
	local vehicle = NetToEnt(vehId)
	print(ObjToNet(vehicle))
	SetVehicleDoorOpen(vehicle,doornum,0,0)
end)
-- R E A R  D O O R S --
RegisterNetEvent('rdoors')
AddEventHandler('rdoors',function(door) 
	local player = GetPlayerPed(-1)
    		if controlsave_bool == true then
				vehicle = saveVehicle
			else
				vehicle = GetVehiclePedIsIn(player,true)
			end
			print("Vehicle: "..type(vehicle))
			door = tonumber(door)
			--print("Door: "..door)
			local isopen = GetVehicleDoorAngleRatio(vehicle, tonumber(door))
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			--if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
					print("OPEN")
					--SetVehicleDoorOpen(vehicle,door,0,0)
					TriggerServerEvent("vehcontrol:opentrunk", ObjToNet(vehicle),door)
				else
					print("CLOSE")
					TriggerServerEvent("vehcontrol:closetrunk", ObjToNet(vehicle),door)
					--SetVehicleDoorShut(vehicle,door,0)
				end
			--else
				--ShowNotification("~r~You must be near your vehicle to do that.")
			--end
end)	

RegisterNetEvent('vehiclecontrol:AsignEntity')
AddEventHandler('vehiclecontrol:AsignEntity', function(vehicle)
	saveVehicle = vehicle
	controlsave_bool = true
end)

-- H O O D --
RegisterNetEvent('hood')
AddEventHandler('hood',function() 
	local player = GetPlayerPed(-1)
    	if controlsave_bool == true then
			vehicle = saveVehicle
		else
			vehicle = GetVehiclePedIsIn(player,true)
		end
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,4)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			--if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
					TriggerServerEvent("vehcontrol:opentrunk", ObjToNet(vehicle),4)
				--SetVehicleDoorOpen(vehicle,4,0,0)
				else
					TriggerServerEvent("vehcontrol:closetrunk", ObjToNet(vehicle),4)
					--SetVehicleDoorShut(vehicle,4,0)
				end
			--else
				--ShowNotification("~r~You must be near your vehicle to do that.")
			--end
end)
-- L O C K --
RegisterNetEvent('lockLights')
AddEventHandler('lockLights',function()
local vehicle = saveVehicle
	StartVehicleHorn(vehicle, 100, 1, false)
	SetVehicleLights(vehicle, 2)
	Wait (200)
	SetVehicleLights(vehicle, 0)
	StartVehicleHorn(vehicle, 100, 1, false)
	Wait (200)
	SetVehicleLights(vehicle, 2)
	Wait (400)
	SetVehicleLights(vehicle, 0)
end)

RegisterNetEvent('lock')
AddEventHandler('lock',function()
	local player = GetPlayerPed(-1)
    local vehicle = saveVehicle
	local islocked = GetVehicleDoorLockStatus(vehicle)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
		if DoesEntityExist(vehicle) then
			--if distanceToVeh <= lockDistance then
				if (islocked == 1)then
				SetVehicleDoorsLocked(vehicle, 2)
				ShowNotification("You have locked your ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~.")
				TriggerEvent('lockLights')
				else
				SetVehicleDoorsLocked(vehicle,1)
				ShowNotification("You have unlocked your ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~.")
				TriggerEvent('lockLights')
				end
			--else
				--ShowNotification("~r~You must be near your vehicle to do that.")
			--end
		else
			ShowNotification("~r~No saved vehicle.")
		end
	end)

function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end
-- S A V E --
RegisterNetEvent('save')
AddEventHandler('save',function() 
	local player = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(player)) then 
		if  saved == true then
			--remove from saved.
			saveVehicle = nil
			RemoveBlip(targetBlip)
			ShowNotification("Saved vehicle ~r~removed~w~.")
			ExecuteCommand('me Desactiva un localizador en el vehiculo')
			saved = false
		else
			RemoveBlip(targetBlip)
			saveVehicle = GetVehiclePedIsIn(player,true)
			local vehicle = saveVehicle
			targetBlip = AddBlipForEntity(vehicle)
			SetBlipSprite(targetBlip,225)
			ShowNotification("This ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ is now your~g~ saved ~w~vehicle.")
			ExecuteCommand('me Activa un localizador en el vehiculo')
			saved = true
		end
	end
end)
-- R E M O T E --
RegisterNetEvent('controlsave')
AddEventHandler('controlsave',function() 
		if controlsave_bool == false then
			controlsave_bool = true
			if saveVehicle == nil then
			ShowNotification("~r~No saved vehicle.")
			else
			ShowNotification("You are no longer controlling your ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(saveVehicle))))
			end
		else
			controlsave_bool = false
			if saveVehicle == nil then
			ShowNotification("~r~No saved vehicle.")
			else
			ShowNotification("You are no longer controlling your ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(saveVehicle))))
			end
		end
end)

--PUSH VEHICLE

local empujar = false
local frenoDeMano = true
local playinganim = false
local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)
Vehicle = {}
Vehicle.vehicle = 0
RegisterNetEvent("vehicle-push:frenoDeMano")
AddEventHandler("vehicle-push:frenoDeMano", function(entity)
    frenoDeMano = not frenoDeMano
    if frenoDeMano then
        ShowNotification("Has puesto el freno de mano")
    else
        ShowNotification("Has quitado el freno de mano")
    end
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local speed = GetEntitySpeed(vehicle)
    print("speeed: ".. speed)
    if speed < 1 then
        FreezeEntityPosition(vehicle, frenoDeMano)
    else
        ShowNotification("Debes estar parado para usar el freno de mano")
    end
end)

RegisterNetEvent("vehicle-push:empujar")
AddEventHandler("vehicle-push:empujar", function(entity)
    if not frenoDeMano then
		empujar = not empujar
		Vehicle.vehicle = entity
		if not empujar then
			Vehicle.vehicle = 0
		else
			Vehicle.Dimensions = GetModelDimensions(GetEntityModel(Vehicle.vehicle), First, Second)
			Citizen.CreateThread(function()
				RequestAnimDict('missfinale_c2ig_11')
				while not HasAnimDictLoaded('missfinale_c2ig_11') do
					Citizen.Wait(500)
				end
				while empujar do 
					Citizen.Wait(5)
					local ped = PlayerPedId()
					if Vehicle.vehicle ~= 0 then
							--if IsVehicleSeatFree(Vehicle.vehicle, -1) and GetVehicleEngineHealth(Vehicle.vehicle) <= 100 then
								--ShowNotification('Pulsa [~g~SHIFT~w~] + [~g~E~w~] para empujar el vehículo')
							--end
							if GetDistanceBetweenCoords(GetEntityCoords(Vehicle.vehicle) + GetEntityForwardVector(Vehicle.vehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(Vehicle.vehicle) + GetEntityForwardVector(Vehicle.vehicle) * -1, GetEntityCoords(ped), true) then
								Vehicle.IsInFront = false
							else
								Vehicle.IsInFront = true
							end
			
						if empujar and IsVehicleSeatFree(Vehicle.vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.vehicle) and not frenoDeMano then
							NetworkRequestControlOfEntity(Vehicle.vehicle)
							local coords = GetEntityCoords(ped)
							if Vehicle.IsInFront then    
								AttachEntityToEntity(PlayerPedId(), Vehicle.vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
							else
								AttachEntityToEntity(PlayerPedId(), Vehicle.vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
							end
			
							TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
							playinganim = true
			
							Citizen.Wait(200)
							 while playinganim do
								Citizen.Wait(5)
								if IsDisabledControlPressed(0, 39) then
									TaskVehicleTempAction(PlayerPedId(), Vehicle.vehicle, 11, 1000)
								end
			
								if IsDisabledControlPressed(0, 9) then
									TaskVehicleTempAction(PlayerPedId(), Vehicle.vehicle, 10, 1000)
								end
			
								if Vehicle.IsInFront then
									SetVehicleForwardSpeed(Vehicle.vehicle, -1.0)
								else
									SetVehicleForwardSpeed(Vehicle.vehicle, 1.0)
								end
			
								if HasEntityCollidedWithAnything(Vehicle.vehicle) then
									SetVehicleOnGroundProperly(Vehicle.vehicle)
								end
			
								if not empujar then
									DetachEntity(ped, false, false)
									StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
									FreezeEntityPosition(ped, false)
									break
								end
							end
						end
					end
				end
			end)
		end
    else
		ShowNotification("El freno de mano sigue activado")
		Vehicle.vehicle = 0
        empujar = false
        playinganim = false
    end
end)


AddEventHandler("vehicleactions:general", function(action, entity) 
		local Entity = entity
        local options = action
        local action = action
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            TriggerEvent("vehiclecontrol:AsignEntity", Entity)
        end
        if options ~= nil then
            if options == "doors" then
                -- TriggerEvent('chatMessage', data.action,nil, '/rdoors')
                --print("Puerta: " .. data.action)
                ----chatMessage
                local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
                --local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
                local vehicle = Entity
                local nearestDoor = -1
                local doorDistance = 1000
                local doorsBones = {
                    "door_dside_f",
                    "door_pside_f",
                    "door_dside_r",
                    "door_pside_r"
                }
                local doorNumbers = GetNumberOfVehicleDoors(vehicle)
                if doorNumbers <= 4 then
                    doorNumbers = 2
                else
                    doorNumbers = 4
                end
                local i = 1
                for i = 1, doorNumbers, 1 do
                    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                        local trunkpos =
                            GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doorsBones[i]))
                        local playerpos = GetEntityCoords(GetPlayerPed(-1), 1)
                        local distanceToTrunk = GetDistanceBetweenCoords(trunkpos, playerpos, 1)
                        print("door distance: " .. doorDistance)
                        print("Door near: " .. nearestDoor)
                        if distanceToTrunk < doorDistance then
                            doorDistance = distanceToTrunk
                            nearestDoor = i - 1
                            print("door distance: " .. doorDistance)
                            print("Door near: " .. nearestDoor)
                        end
                    end
                end
                if not IsPedInAnyVehicle(PlayerPedId(), true) then
                    TriggerEvent("rdoors", nearestDoor)
                else
                    TriggerEvent("rdoors", action)
                end
            elseif action == "lock" then
                print("Envío")
                --TriggerEvent("esx_locksystem:togglelockexternal", Entity)
                TriggerEvent("keys:togglelocks")
            else
                TriggerEvent("" .. action)
            end
        else
            print("Algo ha fallado")
        end
end)


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end




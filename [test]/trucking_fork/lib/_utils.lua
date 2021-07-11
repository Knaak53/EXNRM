Utils = {}
ExM = exports.extendedmode:getExtendedModeObject()
ESX = exports.extendedmode:getSharedObject()

Utils.GetEntInFrontOfEnt = function(entity)
    local Ent = nil
    local CoA = GetEntityCoords(entity, 1)
    local CoB = GetOffsetFromEntityInWorldCoords(entity, 0.0, 5.0, 0.0)
    local RayHandle = CastRayPointToPoint(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, 10, entity, 0)
    local A,B,C,D,Ent = GetRaycastResult(RayHandle)
    return Ent
end

Utils.DisplayHelpText = function(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Utils.DrawText3D = function(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
 
    AddTextComponentString(text)
    DrawText(_x, _y)
 
    local factor = (string.len(text)) / 230
    DrawRect(_x, _y + 0.0250, 0.095 + factor, 0.06, 41, 11, 41, 100)
end

Utils.CreateMissionBlip = function (coords, sprite, colour, text)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.1)
	SetBlipColour(blip, colour)
	SetBlipAsShortRange(blip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
	SetBlipRoute(blip, true) --Add the route to the blip
	return blip
end

Utils.CreatePed = function (model, coords, scenario, networked)
	local hash = GetHashKey( model )
	while not HasModelLoaded( hash ) do
		RequestModel( hash )
		Citizen.Wait(10)
	end

	local _, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
	local ped =  CreatePed(4, hash, coords.x, coords.y, ground, coords.h, networked, false)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	TaskStartScenarioInPlace(ped, scenario, 0, true)
	return ped
end

Utils.Copy = function (table)
	local copy = {}
	for k,v in pairs(table) do
		if type(v) ~= 'function' then
			copy[k] = v
		end
	end
	return copy
end

Utils.takeControlOfEntity = function(entity)
	if not DoesEntityExist(entity) then return end
	local ticks = 0
	while not NetworkHasControlOfEntity(entity) and ticks <= 10 do
			ticks = ticks + 1
			NetworkRequestControlOfEntity(entity)
			Wait(0)
	end
--[[ 	
	local netid = NetworkGetNetworkIdFromEntity(entity)
	ticks = 0
	while not NetworkHasControlOfNetworkId(netid) and ticks <= 10 do
			ticks = ticks + 1
			NetworkRequestControlOfNetworkId(netid)
			Wait(0)
	end ]]
end

Utils.deleteObjects = function(objects)
    for i = 1, #objects do
        while not NetworkHasControlOfEntity(objects[i]) do
            NetworkRequestControlOfEntity(objects[i])
            Wait(100)
        end
        DeleteObject(objects[i])
	end
	
end
Utils.deleteEntities = function(entities)
	for pallet, product in pairs(entities) do
		while not NetworkHasControlOfEntity(product) do
            NetworkRequestControlOfEntity(product)
            Wait(25)
		end
		DeleteObject(product)
		while not NetworkHasControlOfEntity(pallet) do
            NetworkRequestControlOfEntity(pallet)
            Wait(25)
		end
		DeleteObject(pallet)
	end
end
AddTextEntry("HELPTEXT62", '~INPUT_MULTIPLAYER_INFO~ Unload/Load Trailer\n~INPUT_PICKUP~ to release Forklift\n~INPUT_WEAPON_WHEEL_PREV~ Raise Trailer\n~INPUT_WEAPON_WHEEL_NEXT~ Lower Trailer')
Utils.ShowHelp = function(text, n)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(n or 0, false, false, -1)
end

 Utils.ShowFloatingHelp = function(text, pos)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    Utils.ShowHelp(text, 2)
end

Utils.DistanceBetweenCoords = function(coordsA, coordsB)
	return #(vector3(coordsA.x, coordsA.y, coordsA.z).xy - vector3(coordsB.x, coordsB.y, coordsB.z).xy)
end

Utils.StreamingRequestModel = function(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end

Utils.SpawnVehicle = function(modelName, coords, cb)

	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		--Utils.StreamingRequestModel(model)
--
		--local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.h, true, false)
		--local networkId = NetworkGetNetworkIdFromEntity(vehicle)
--
		--SetNetworkIdAlwaysExistsForPlayer(networkId, PlayerId(), true)
		--SetNetworkIdExistsOnAllMachines(networkId, true)
		--SetNetworkIdCanMigrate(networkId, true)
--
		--SetEntityAsMissionEntity(vehicle, true, false)
		--SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		--SetVehicleNeedsToBeHotwired(vehicle, false)
		--SetVehRadioStation(vehicle, 'OFF')
		--SetModelAsNoLongerNeeded(model)
		--RequestCollisionAtCoord(coords.x, coords.y, coords.z)
--
		--local timeout = 0
		--while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
		--	Citizen.Wait(0)
		--	timeout = timeout + 1
		--end
		ESX.TriggerServerCallback('setUpForkLiftVehicle', function(vehNetid)
			while not DoesEntityExist(NetToVeh(vehNetid)) do
				print("no existe")
				Wait(500)
			end
			return cb(NetToVeh(vehNetid))
		end, modelName, coords)
		
	end)
end

Utils.SpawnObject = function(modelName, coords, cb)

	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		Utils.StreamingRequestModel(model)
		local object = CreateObject(model, coords.x, coords.y, coords.z, true, false)
		Wait(0)
		local networkId = ObjToNet(object)

		SetNetworkIdAlwaysExistsForPlayer(networkId, PlayerId(), true)
		SetNetworkIdExistsOnAllMachines(networkId, true)
		SetNetworkIdCanMigrate(networkId, true)

		SetEntityAsMissionEntity(object, true, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		
		local timeout = 0
		while not HasCollisionLoadedAroundEntity(object) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		return cb(object)
	end)
end
Utils = {}

Utils.GetModelInFrontOfEnt = function(entity, model)
    local plyCoords = GetEntityCoords(entity, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(entity, 0.0, 9.0, 0.0)
    local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z+0.4, plyOffset.x, plyOffset.y, plyOffset.z, 0.5, 10, entity, 7)
    local _, _, _, _, result = GetShapeTestResult(rayHandle)

    if GetEntityModel(result) == GetHashKey(Config.trailerModel) then
        return result
    end

    return false
end

Utils.DisplayHelpText = function(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, Config.notificationsBleep, -1)
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
end

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

Utils.SpawnObject = function(modelName, coords, cb, networked, invisible)
    local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

    Citizen.CreateThread(function()
        Utils.StreamingRequestModel(model)
        local object = CreateObject(model, coords.x, coords.y, coords.z, networked, true)
        SetEntityHeading(object,  coords.h)
        
        if invisible then
        SetEntityVisible(object, false)
        SetEntityCollision(object, false, false)
        end

        Wait(250) -- improves chance of getting net id :/
        if networked then
            local networkId = ObjToNet(object)
            if not NetworkDoesNetworkIdExist(networkId) and not NetworkDoesEntityExistWithNetworkId(networkId) then
                DeleteObject(object)
                print('deleted object as OneSync could not allocated it a NetID', modelName)
                return cb(false)
            end

            SetNetworkIdAlwaysExistsForPlayer(networkId, PlayerId(), true)
            SetNetworkIdExistsOnAllMachines(networkId, true)
            SetNetworkIdCanMigrate(networkId, true)
        end

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
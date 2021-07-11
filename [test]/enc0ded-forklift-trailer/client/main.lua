Citizen.CreateThread(function ()
    -- register decors
    DecorRegister('forklift_netid', 3) -- forklift net id attached to forklift
    DecorRegister('product_type', 3) -- product index attached to entity
    DecorRegister('pallet_status', 3) -- 0 = spawned, 1 = picked up, 2 = delivered
    DecorRegister('pallet_owner', 3) -- server pid of owning player
    DecorRegister('trailer_unloading', 3) -- 0 = no, 1 yes
    DecorRegister('trailer_lowered', 3) -- 0 = no, 1 yes
    DecorRegister('netid_slot_1', 3) -- net id of pallet in slot 1 of trailer
    DecorRegister('netid_slot_2', 3)
    DecorRegister('netid_slot_3', 3)
    DecorRegister('netid_slot_4', 3)
    DecorRegister('netid_slot_5', 3)

    local playerPed, trailer, vehicle

    -- main loop
    while true do
        Wait(1000)
        playerPed = PlayerPedId()
        trailer = Utils.GetModelInFrontOfEnt(playerPed, Config.trailerModel)

        if trailer and trailer ~= Trailer.entity then
            if Trailer.entity ~= nil then
                local playerCoords = GetEntityCoords(PlayerPedId())
                local trailerOffset = GetOffsetFromEntityInWorldCoords(trailer, 0.0, -3.0, 0.0)
                local existingTrailerOffset = GetOffsetFromEntityInWorldCoords(Trailer.entity, 0.0, -3.0, 0.0)
                if Utils.DistanceBetweenCoords(playerCoords, trailerOffset) < Utils.DistanceBetweenCoords(playerCoords, existingTrailerOffset) then
                Trailer:initiate(trailer)
                end
            else
                Trailer:initiate(trailer)
            end
        end

        vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle > 0 then
            if vehicle ~= Truck.entity and GetVehicleClass(vehicle) == 20 then
                Truck:enter(vehicle)
            elseif vehicle ~= Forklift.entity and GetEntityModel(vehicle) == GetHashKey('forklift') then
                Forklift:enter(vehicle)
            end
        else
            if Forklift.entity then Forklift:exit() end
            if Truck.entity then Truck:exit() end
        end

        -- remove entities that have been delivered and are not in the players view
        if #Pallet.entities > 0 then
            local playerCoords = GetEntityCoords(playerPed)
            for i = 1, #Pallet.entities do
                
                local palletStatus = DecorGetInt(Pallet.entities[i], 'pallet_status')
                if Pallet.entities[i] and palletStatus and palletStatus == 2 then
                    local coords = GetEntityCoords(Pallet.entities[i])
                    if Utils.DistanceBetweenCoords(playerCoords, coords) > 50 then
                        Utils.takeControlOfEntity(Pallet.entities[i])
                        DeleteEntity(Pallet.entities[i])
                        Pallet.entities[i] = nil
                    end
                end
            end
        end
    end
end)

-- export functions
function SpawnPalletsWithProducts(amount, kind, coords, offsets)
  local owner = GetPlayerServerId(PlayerId())
  return Pallet:spawnRow(tonumber(amount) or 1, kind, coords, offsets, owner)
end

function RemoveAllPallets()
  return Pallet:removeAll() 
end

function GetAllPalletEntities()
    return Pallet.entities 
end

function GetPalletCategoryByIndex(index)
    return Config.productTypes[index].category
end

function SpawnTruck(truckModel, coords, cb)
    Utils.SpawnVehicle(truckModel, coords, cb)
end

function SpawnTrailer(coords, cb)
    Utils.SpawnVehicle('trflat', coords, cb)
end

function SpawnForklift(coords, cb)
    Utils.SpawnVehicle('forklift', coords, cb)
end

function SpawnTruckTrailerAndForklift(truckModel, coords, cb)
    SpawnTruck(truckModel, coords, function(truck)
        SpawnTrailer(coords, function(trailer)
            AttachVehicleToTrailer(truck, trailer, 1.0)
            SpawnForklift(coords, function(forklift)
                AttachForklift(trailer, forklift)
                return cb(truck, trailer, forklift)
            end)
        end)
    end)
end

function AttachForklift(trailer, forklift)
    Utils.takeControlOfEntity(trailer)
    local boneCoords = GetWorldPositionOfEntityBone(forklift, GetEntityBoneIndexByName(forklift, 'forks'))
    AttachEntityToEntity(forklift, trailer, 0, 0.0, -7.58, -0.23, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    SetEntityCollision(forklift, true, false)
    DecorSetInt(trailer, 'forklift_netid', VehToNet(forklift))
end

-- client commands
if Config.enableClientCommands then
    RegisterCommand("spawn-pallets", function(_, args)
        Citizen.CreateThread(function() 
            local categories = {'postal', 'construction', 'industry', 'commercial', 'farming', 'church', 'military'}
            local kind = categories[math.random(1, #categories)]
            local num = 1
        
            if args[1] ~= nil then
                num = args[1]
            end
        
            if args[2] ~= nil then
                kind = args[2]
            end
        
            local offsetFromPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
            local coords = {x = offsetFromPlayer.x, y = offsetFromPlayer.y, z = offsetFromPlayer.z, h = GetEntityHeading(PlayerPedId(-1))}
            SpawnPalletsWithProducts(num, kind, coords, {x=0.0, y=2.5})
        end)
    end)

    RegisterCommand("delete-pallet", function()
        local coords = GetEntityCoords(PlayerPedId(-1))
        local pallet = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.5, GetHashKey(Config.palletModel), true, false, false)
        DeleteEntity(pallet)
    end)

    RegisterCommand("delete-all-pallets", function()
        RemoveAllPallets()
    end)

    RegisterCommand("spawn-truck", function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local coords = {x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, h = GetEntityHeading(PlayerPedId())}
        SpawnTruckTrailerAndForklift('hauler', coords, function (truck)
            TaskWarpPedIntoVehicle(PlayerPedId(), truck, 0)
        end)
    end)
end

-- client events
RegisterNetEvent('enc0ded-forklift-trailer/owner-event')
AddEventHandler('enc0ded-forklift-trailer/owner-event', function(event, netId, ...)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if event == 'attached-pallet' then
        Trailer.PalletLoaded(entity, ...)
    elseif event == 'set-loading' then
        Trailer.SetLoading(entity, ...)
    elseif event == 'attach-forklift' then
        Trailer.SetAttachedTrailer(entity, ...)
    elseif event == 'release-forklift' then
        Trailer.ReleaseForklift(entity)
    elseif event == 'lower-trailer' then
        Trailer.Lower(entity)
    elseif event == 'raise-trailer' then
        Trailer.Raise(entity)
    end
end)

-- local products thread
Citizen.CreateThread(function()
    local countdown = 40
    while true do
        Wait(100)

        -- we want to update the known pallets every ~2 seconds and ensure code doesn't run simultaneously to reattachment/delete loop
        countdown = countdown - 1
        if countdown == 0 then
            UpdateKnownPalletObjects()
            countdown = 40
            Wait(100)
        end
        
        -- ensure product objects stay attached to pallets and delete them if the pallet object no longer exists
        for palletNetId, productEntity in pairs(Pallet.localProducts) do
            local palletEntity = NetToEnt(tonumber(palletNetId))
            if not DoesEntityExist(palletEntity) then
                DeleteEntity(productEntity)
                Pallet.localProducts[palletNetId] = nil

            elseif DecorGetInt(palletEntity, 'pallet_status') == 3 then
                DetachEntity(productEntity)
                Citizen.SetTimeout(5000, function ()
                    DeleteEntity(productEntity)
                end)
            elseif not IsEntityAttached(productEntity) then
                local productConfig = Config.productTypes[DecorGetInt(palletEntity, 'product_type')]
                AttachProductToPallet(palletEntity, productEntity, productConfig)
            end
        end
    end
end)

function UpdateKnownPalletObjects()
    local palletHash = GetHashKey(Config.palletModel)
    local requests = 0
    for object in EnumerateObjects() do

        -- check this object is a pallet with an existing product_type decor
        if GetEntityModel(object) == palletHash and DecorExistOn(object, 'product_type') then
            local spawnKey = tostring(ObjToNet(object))
            
            -- check if we've already spawned a product for this pallet
            if Pallet.localProducts[spawnKey] == nil then

                -- only spawn product if the pallet is close by
                if 150 > Utils.DistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(object)) then
                    local productConfig = Config.productTypes[DecorGetInt(object, 'product_type')]
                    local objectCoords = GetEntityCoords(object)
                    local productCoords = {x = objectCoords.x, y = objectCoords.y, z = objectCoords.z + (productConfig.offset.z or 0), h = GetEntityHeading(object) }
                    Utils.SpawnObject(productConfig.model, productCoords, function(productObject)
                        AttachProductToPallet(palletEntity, productEntity, productConfig)
                        SetEntityCollision(productEntity, true, true)
                        Pallet.localProducts[spawnKey] = productObject
                    end, false)
                end
            
            -- else we have a pallet with a spawned product, we will delete it if it goes out of range
            elseif 200 < Utils.DistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(object)) then
                DeleteEntity(Pallet.localProducts[spawnKey])
                Pallet.localProducts[spawnKey] = nil
            end
        end
    end
end

function AttachProductToPallet(palletEntity, productEntity, product)
  AttachEntityToEntity(productEntity, palletEntity, 0, 0.0 + (product.offset.x or 0), 0.0 + (product.offset.y or 0), 0.00 + (product.offset.z or 0), (product.rotation.x or 0.0), (product.rotation.y or 0.0), (product.rotation.z or 0.0), 1, 0, 0, 1, 0, 1)
  SetEntityNoCollisionEntity(productEntity, palletEntity, false)
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Pallet:removeAll()

    for palletNetId, productEntity in pairs(Pallet.localProducts) do
        local palletEntity = NetToEnt(tonumber(palletNetId))
        DeleteObject(palletEntity)
        DeleteObject(productEntity)
    end

    for vehicle in EnumerateVehicles() do
        if NetworkHasControlOfEntity(vehicle) and DecorExistOn(vehicle, 'forklift_netid') then
            for i = 1, 5 do
                DecorSetInt(vehicle, 'netid_slot_' .. i, 0)
            end
        end
    end
end)

--[[ -- DEVELOPER - Spawn all pallets at the airport
RegisterNetEvent('enc0ded-forklift-trailer/spawn-all-pallets')
AddEventHandler('enc0ded-forklift-trailer/spawn-all-pallets', function()

    print('server says to spawn all')
        -- -1673.094 -2760.197 13.945
    local coords = {x= -1657.979, y=-2763.123, z=12.945, h=60.415}

    for i = 1, #Config.productTypes do
        local testPickUp = Config.productTypes[i]

        coords.y = coords.y + 3.2
        coords.x = coords.x + 1.85

        Pallet:spawnRow(1, i, coords, {x = 0.0, y = 2.5})
        Wait(250)
    end

end)
 ]]
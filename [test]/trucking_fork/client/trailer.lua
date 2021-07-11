Trailer = {
    entity,
    unloading = false,
    legsRaised = false,
}

function Trailer:initiate(entity)
    if not entity or self.entity == entity then return end
    local location, dist, coords, controlCoords, selfCoords, r, g, b, a
    
    self.entity = entity
    self.unloading = DecorGetInt(entity, 'trailer_unloading') > 0
    self.legsRaised = false

    -- just do this once because my pattern is shit
    controlCoords = GetOffsetFromEntityInWorldCoords(self.entity, -1.0, -6.19, 0.32)

    -- handle things that can go in a slower thread
    Citizen.CreateThread(function ()
        while self.entity == entity do

            coords = GetEntityCoords(PlayerPedId(-1))
            selfCoords = GetEntityCoords(self.entity)
            if not DoesEntityExist(self.entity) or 75 < Utils.DistanceBetweenCoords(selfCoords, coords) then
                self:clear()
                break
            end

            if self.unloading then
                r, g, b, a = 55, 255, 55, 215 
            else
                r, g, b, a = 55, 55, 255, 215
            end
            dist = Utils.DistanceBetweenCoords(coords, controlCoords)
            location = GetOffsetFromEntityInWorldCoords(self.entity, 0.0, -7.4, -1.3)
            Trailer:reattachPallets()

            Wait(250)

        end
    end)

    -- draw markers and controls.. fast thread
    Citizen.CreateThread(function ()
        Wait(1000)
        local truck, hasDriver
        while self.entity == entity do

            if self.legsRaised then
                SetTrailerLegsRaised(self.entity)
            end

            truck, hasDriver = Trailer:getAttachedTruck(true)
            if not hasDriver then
                controlCoords = GetOffsetFromEntityInWorldCoords(self.entity, -1.0, -6.19, 0.32)
                DrawMarker(28, controlCoords.x, controlCoords.y, controlCoords.z, 0, 0, 0, 0, 0, 0, 0.05, 0.05, 0.05, r, g, b, a, 0, 0, 0, 0)
    
                -- handle trailer menu input
                if dist < 1.25 and not IsPedInAnyVehicle(PlayerPedId(-1), true) then
                    DisableControlAction(0, 38)
                    DisableControlAction(0, 73)
                    DisableControlAction(0, 38)
                    HudWeaponWheelIgnoreSelection()
                    Utils.ShowFloatingHelp('HELPTEXT62', controlCoords)
                    if IsControlJustPressed(0, 20) then
                        self:toggleUnloading()
                    elseif IsDisabledControlJustPressed(0, 38) then
                        if not self:flatEnough() then
                            Utils.DisplayHelpText('~r~The ground is not flat enough to release forklift')
                        else
                            self:releaseForklift()
                        end
                    elseif IsDisabledControlJustPressed(0, 14)  then
                        self:lower()
                    elseif IsDisabledControlJustPressed(0, 15) then
                        self:raise()
                    end
                end

                -- handle attaching forklift to trailer
                if Forklift.entity and not self:carryingForklift() then
                    local heading = GetEntityHeading(self.entity)
                    DrawMarker(43, location.x, location.y, location.z, 0, 0, 0, 0, 0, heading, 1.2, 2.25, 0.3, 185, 155, 0, 185, 0, 0, 0, 0)
                    dist = Utils.DistanceBetweenCoords(coords, location)

                    if dist < 0.45 then
                        -- check fork height
                        local forkCoords = GetWorldPositionOfEntityBone(Forklift.entity, GetEntityBoneIndexByName(Forklift.entity, 'forks'))
                        local _, ground = GetGroundZFor_3dCoord(forkCoords.x, forkCoords.y, forkCoords.z, 0)
                        if forkCoords.z - ground > 0.7 then
                            Utils.DisplayHelpText('Forks must be lowered to attach forklift')
                        
                        -- check for heading
                        elseif math.abs(GetEntityHeading(self.entity) - GetEntityHeading(Forklift.entity)) > 3 then
                            Utils.DisplayHelpText('Forklift must be facing forward to attach')
                        
                        else
                            Utils.DisplayHelpText('Press ~INPUT_PICKUP~ to attach Forklift')
                            if IsControlJustPressed(0, 38) then
                                self:attachForklift()
                            end
                        end
                    end
                end
            end
            Wait(5)
        end
    end)
end

function Trailer:clear()
    self.entity = nil
    self.unloading = false
    self.legsRaised = false
end

function Trailer:toggleUnloading()
    local truck, hasDriver = Trailer:getAttachedTruck(true)
    if hasDriver then
        return Utils.DisplayHelpText('Truck driver must leave cab to start unloading trailer')
    end
    Utils.takeControlOfEntity(self.entity)
    self.unloading = not self.unloading
    if self.unloading then
        DecorSetInt(self.entity, 'trailer_unloading', 1)
        Utils.DisplayHelpText('~g~Trailer ready for unloading')

        -- add collision to pallet objects
        for i=1, 5 do
            local palletNetId = DecorGetInt(self.entity, 'netid_slot_' .. i)
            local palletEntity = NetworkGetEntityFromNetworkId(palletNetId)
            SetEntityCollision(palletEntity, true, false)
        end

    else
        DecorSetInt(self.entity, 'trailer_unloading', 0)
        Utils.DisplayHelpText('~g~Trailer ready for loading')
    end
end

local locked = false
function Trailer:raise()
    if locked then return end
    locked = true
    Citizen.CreateThread(function()
        self.legsRaised = false
        Wait(250) -- wait for legs to retract
        Utils.takeControlOfEntity(self.entity)
        FreezeEntityPosition(self.entity, false)
        SetEntityCollision(self.entity, true, true)
        locked = false
    end)
end

function Trailer:lower()
    local truck, hasDriver = Trailer:getAttachedTruck(true)
    if hasDriver then
        return Utils.DisplayHelpText('Truck driver must leave cab to lower trailer')
    end

    if self.legsRaised then return end
    self.legsRaised = true

    if not Trailer:flatEnough() then
        return Utils.DisplayHelpText('~r~The ground is not flat enough to lower the trailer')
    end

    Utils.takeControlOfEntity(self.entity)
    local coords = GetEntityCoords(self.entity, true)
    local _, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
    SetEntityCollision(self.entity, true, true)
    FreezeEntityPosition(self.entity, false)
    SetEntityCoords(self.entity, coords.x, coords.y, ground, true, true, false, false)
    FreezeEntityPosition(self.entity, true)
    DisableVehicleWorldCollision(self.entity)

    local truck = GetEntityAttachedTo(self.entity)
    if truck > 0 then
        DetachVehicleFromTrailer(truck)
        DisableVehicleWorldCollision(truck)
        FreezeEntityPosition(truck, true)
    end
end

function Trailer:palletLoaded(id)
    Utils.takeControlOfEntity(self.entity)
    Utils.takeControlOfEntity(Pallet.entity)
    SetEntityCollision(Pallet.entity, false, false)
    AttachEntityToEntity(Pallet.entity, self.entity, 0, 0.0, (id*2.0)-7.1, 0.41, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    DecorSetInt(self.entity, 'netid_slot_' .. id, NetworkGetNetworkIdFromEntity(Pallet.entity))
    DecorSetInt(Pallet.entity, 'pallet_status', 4)
    Pallet.entity = nil
end

function Trailer:countPallets()
    local num = 0
    for i = 1, 5 do
        if DecorGetInt(self.entity, 'netid_slot_' .. i) > 0 then
            num = num + 1
        end
    end
    return num
end

-- fix to stop products detaching from pallets and pallets from the trailer
function Trailer:reattachPallets()
    for i = 1, 5 do
        local netId = DecorGetInt(self.entity, 'netid_slot_' .. i)
        if netId > 0 and NetworkDoesNetworkIdExist(netId) then
            local entity = NetworkGetEntityFromNetworkId(netId)

            if DoesEntityExist(entity) and GetEntityAttachedTo(entity) == 0 then
                Utils.takeControlOfEntity(entity)
                AttachEntityToEntity(entity, self.entity, 0, 0.0, (i*2.0)-7.1, 0.41, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
            end

            local productNetId = DecorGetInt(entity, 'product_attached')
            local productEntity = NetworkGetEntityFromNetworkId(productNetId)

            -- fix collision of invisible block on trucks with slot 1
            if i == 5 and Truck.lastVehicleEntity > 0 then
                SetEntityNoCollisionEntity(Truck.lastVehicleEntity, productEntity, false)
            end

            if DoesEntityExist(productEntity) and GetEntityAttachedTo(productEntity) == 0 then
                local productTypeId = DecorGetInt(entity, 'product_type')
                local product = Config.productTypes[productTypeId]
                Utils.takeControlOfEntity(entity)
                Utils.takeControlOfEntity(productEntity)
                AttachEntityToEntity(productEntity, entity, 0, 0.0 + (product.offset.x or 0), 0.0 + (product.offset.y or 0), 0.00 + (product.offset.z or 0), 0.0, 0.0, 0.0, false, false, false, true, 1, true)
            end
        end
    end
end

function Trailer:carryingForklift()
    return DecorGetInt(self.entity, 'forklift_netid') > 0
end

function Trailer:attachForklift()
    local truck, hasDriver = Trailer:getAttachedTruck(true)
    if hasDriver then
        return Utils.DisplayHelpText('~r~Truck driver must leave cab to attach forklift')
    elseif truck > 0 then
        Utils.takeControlOfEntity(truck)
    end
    
    Citizen.CreateThread(function() 

        TaskLeaveVehicle(PlayerPedId(-1), Forklift.entity, 0)
        local forkliftNetId = NetworkGetNetworkIdFromEntity(Forklift.entity)
        Wait(1250)
        Utils.takeControlOfEntity(self.entity)
        Utils.takeControlOfEntity(Forklift.entity)
        DecorSetInt(self.entity, 'forklift_netid', forkliftNetId)
        SetForkliftForkHeight(Forklift.entity, 0.0)

        local entity
        local num = 0.6
        while num > 0.2 do
            num = num - 0.009
            entity = NetworkGetEntityFromNetworkId(forkliftNetId) -- needed as it seems to lose the entity half way through
            Utils.takeControlOfEntity(self.entity)
            Utils.takeControlOfEntity(entity)
            AttachEntityToEntity(entity, self.entity, 0, 0.0, -7.58, -num, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
            Wait(30)
        end
        SetEntityCollision(entity, true, false)
        Forklift.entity = nil
    end)
end

function Trailer:releaseForklift()

    local forkliftNetId = DecorGetInt(self.entity, 'forklift_netid')
    
    if forkliftNetId == 0 then
        return Utils.DisplayHelpText('~r~No forklift attached to vehicle')
    end

    local forkliftEntity = NetworkGetEntityFromNetworkId(forkliftNetId)

    if not DoesEntityExist(forkliftEntity) then
        return
    end

    local hasTruck = GetEntityAttachedTo(self.entity)
    if hasTruck > 0 then
        if GetPedInVehicleSeat(hasTruck, -1) == 0 and GetPedInVehicleSeat(hasTruck, 0)  == 0 and GetPedInVehicleSeat(hasTruck, 1)  == 0 then
            Utils.takeControlOfEntity(hasTruck)
        else
            return Utils.DisplayHelpText('~r~Truck driver must leave cab to detach forklift') 
        end
    end

    Citizen.CreateThread(function()

        Utils.takeControlOfEntity(self.entity)
        Utils.takeControlOfEntity(forkliftEntity)
        DecorSetInt(self.entity, 'forklift_netid', 0)
        FreezeEntityPosition(self.entity, true)
        local num = 0.2
        while num < 0.6 do
            num = num + 0.015
            AttachEntityToEntity(forkliftEntity, self.entity, 0, 0.0, -7.58, -num, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
            Wait(25)
        end

        SetForkliftForkHeight(forkliftEntity, 0.0)
        DetachEntity(forkliftEntity, true)

        -- bit hacky but sometimes the new position isn't ready and the forklift "collides" with the self.entity even though it's not touching
        local coords = GetEntityCoords(forkliftEntity, true)
        local _, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
        SetEntityCoords(forkliftEntity, coords.x, coords.y, ground)
        SetEntityCollision(forkliftEntity, true, true)
        while HasEntityCollidedWithAnything(forkliftEntity) do
            Utils.takeControlOfEntity(forkliftEntity)
            SetEntityNoCollisionEntity(forkliftEntity, trailer, true)
            Wait(0)
        end
        Wait(10)
        Utils.takeControlOfEntity(self.entity)
        SetEntityCollision(forkliftEntity, true, true)
        FreezeEntityPosition(self.entity, false)
    end)
end

function Trailer:getAttachedTruck(hasDriver)
    local truck = GetEntityAttachedTo(self.entity)
    if truck > 0 then
        if hasDriver then
            return truck, (GetPedInVehicleSeat(truck, -1) > 0 or GetPedInVehicleSeat(truck, 0) > 0 or GetPedInVehicleSeat(truck, 1) > 0)
        end
        return truck, false
    end
    return 0
end

function Trailer:flatEnough() 
    return math.abs( GetEntityRoll(self.entity) ) < 8 and math.abs( GetEntityPitch(self.entity) ) < 25
end

function Trailer.isInFrontOfEntity(entity)
    local plyCoords = GetEntityCoords(entity, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(entity, 0.0, 9.0, 0.0)
    local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 10, entity, 7)
    local _, _, _, _, result = GetShapeTestResult(rayHandle)

    if GetEntityModel(result) == GetHashKey(Config.trailerModel) then
        return result
    end

    return false
end
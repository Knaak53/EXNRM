Trailer = {
    entity,
    unloading = false,
    menu = {}
}

function Trailer:initiate(entity)
    if not entity or self.entity == entity then return end
    
    self.entity = entity
    self.unloading = DecorGetInt(entity, 'trailer_unloading') > 0
    self:updateMenu()

    -- bug fix for invisible collision object on back of truck; we do this here also just incase when player picked up pallet the trailer wasn't initialised
    if Pallet.entity then
        local attachedTruck, hasDriver = Trailer:getAttachedTruck(false)
        local truck = attachedTruck or Truck.lastVehicleEntity
        if truck then
            SetEntityNoCollisionEntity(truck, Pallet.localProducts[Pallet.productKey], false)
            SetEntityNoCollisionEntity(truck, Pallet.entity, false)
        end
    end

    -- create pointers in memory for our variables outside our loop
    local location, dist, coords, controlCoords, selfCoords, r, g, b, a
    controlCoords = GetOffsetFromEntityInWorldCoords(self.entity, -1.0, -6.19, 0.32)
    -- handle things that can go in a slower thread
    Citizen.CreateThread(function()
        while self.entity == entity do

            coords = GetEntityCoords(PlayerPedId(-1))
            selfCoords = GetEntityCoords(self.entity)

            -- clear trailer class if player gets too far from trailer 
            if not DoesEntityExist(entity) or 50 < Utils.DistanceBetweenCoords(selfCoords, coords) then
                self:clear()
                break
            end

            -- update rgb for our loading indicator 
            if self.unloading then
                r, g, b, a = 55, 255, 55, 215 
            else
                r, g, b, a = 55, 55, 255, 215
            end

            -- set distance from control coords
            dist = Utils.DistanceBetweenCoords(coords, controlCoords)

            -- set location of forklift marker
            location = GetOffsetFromEntityInWorldCoords(self.entity, 0.0, -7.4, -1.3)
            
            -- if player owns this trailer, run reAttachment bugfix code
            if NetworkGetEntityOwner(self.entity) == PlayerId() then
                Trailer:reattachPallets()
            end
            Wait(500)
        end
    end)

    -- draw markers and controls.. fast thread
    Citizen.CreateThread(function()
        Wait(250)
        local truck, hasDriver
        while self.entity == entity do
            Wait(5)
            controlCoords = GetOffsetFromEntityInWorldCoords(self.entity, -1.0, -6.19, 0.32)
            DrawMarker(28, controlCoords.x, controlCoords.y, controlCoords.z, 0, 0, 0, 0, 0, 0, 0.05, 0.05, 0.05, r, g, b, a, 0, 0, 0, 0)

            -- handle trailer menu input
            if dist < 1.25 and not IsPedInAnyVehicle(PlayerPedId(-1), true) then
                self:updateMenu()
                DisableControlAction(0, 20)
                DisableControlAction(0, 38)
                DisableControlAction(0, 73)
                HudWeaponWheelIgnoreSelection()
                Utils.ShowFloatingHelp('HELPTEXT62', controlCoords)

                -- Z button press action
                if IsDisabledControlJustPressed(0, 20) then
                    self:toggleUnloading()
                    self:updateMenu()
                -- E button press action
                elseif IsDisabledControlJustPressed(0, 38) then

                if not self:flatEnough() then
                    Utils.DisplayHelpText('~r~The ground is not flat enough to release forklift')
                elseif self:carryingForklift() then
                    if NetworkGetEntityOwner(self.entity) == PlayerId() then
                        self.ReleaseForklift(self.entity)
                        self:updateMenu()
                    else
                        TriggerServerEvent('enc0ded-forklift-trailer/owner-event', 'release-forklift', VehToNet(self.entity))
                    end
                end
                
                -- X to lower/raise trailer
                elseif IsDisabledControlJustPressed(0, 73)  then
                    if DecorGetInt(self.entity, 'trailer_lowered') == 1 then
                        
                        if NetworkGetEntityOwner(self.entity) == PlayerId() then
                            self.Raise(self.entity)
                            self:updateMenu()
                        else
                            TriggerServerEvent('enc0ded-forklift-trailer/owner-event', 'raise-trailer', VehToNet(self.entity))
                        end

                    else

                        if NetworkGetEntityOwner(self.entity) == PlayerId() then
                            self.Lower(self.entity)
                            self:updateMenu()
                        else
                            TriggerServerEvent('enc0ded-forklift-trailer/owner-event', 'lower-trailer', VehToNet(self.entity))
                        end
                    end
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
                    
                    -- allow attachment
                    else
                        Utils.DisplayHelpText('Press ~INPUT_PICKUP~ to attach Forklift')
                        if IsControlJustPressed(0, 38) then
                            local forkliftNetId = NetworkGetNetworkIdFromEntity(Forklift.entity)
                            TaskLeaveVehicle(PlayerPedId(-1), Forklift.entity, 0)
                            Citizen.CreateThread(function()
                                Wait(1200)
                                if NetworkGetEntityOwner(self.entity) == PlayerId() then
                                    self:attachForklift(forkliftNetId)
                                    self:updateMenu()
                                else
                                    Trailer.AttachForkliftNoAnim(forkliftNetId)
                                    --
                                    --Wait(500)
                                    self:updateMenu()
                                end
                            end)
                        end
                    end
                end
            end
        end
    end)
end

-- class functions
function Trailer:updateMenu()
  if self.unloading then
    self.menu[1] = '~INPUT_MULTIPLAYER_INFO~ ' .. Lang['load_trailer'] .. '\n'
  else
    self.menu[1] = '~INPUT_MULTIPLAYER_INFO~ ' .. Lang['unload_trailer'] .. '\n'
  end

  if Trailer:carryingForklift() then
    self.menu[2] = '~INPUT_PICKUP~ ' .. Lang['release_forklift'] .. '\n'
  else
    self.menu[2] = ''
  end
  
  if DecorGetInt(self.entity, 'trailer_lowered') == 1 then
    self.menu[3] = '~INPUT_VEH_DUCK~ ' .. Lang['raise_trailer']
  else
    self.menu[3] = '~INPUT_VEH_DUCK~ ' .. Lang['lower_trailer']
  end
  AddTextEntry("HELPTEXT62", self.menu[1] .. self.menu[2] .. self.menu[3])
end

function Trailer:toggleUnloading(unloading)

    self.unloading = unloading or not self.unloading

    if NetworkGetEntityOwner(self.entity) == PlayerId() then
        self.SetLoading(self.entity, self.unloading)
    else
        TriggerServerEvent('enc0ded-forklift-trailer/owner-event', 'set-loading', ObjToNet(self.entity), self.unloading)
    end

    if self.unloading then
        Utils.DisplayHelpText('~g~' .. Lang['unloading_ready'])
        -- add collision to pallet objects
        for i=1, 5 do
            local palletNetId = DecorGetInt(self.entity, 'netid_slot_' .. i)
            local palletEntity = NetworkGetEntityFromNetworkId(palletNetId)
            SetEntityCollision(palletEntity, true, false)
        end
    else
        --[[for i=1, 5 do
            local palletNetId = DecorGetInt(self.entity, 'netid_slot_' .. i)
            local palletEntity = NetworkGetEntityFromNetworkId(palletNetId)
            local productEntity = GetEntityAttachedTo(palletEntity)
            SetEntityCollision(palletEntity, false, false)
            SetEntityCollision(productEntity, false, false)
        end]]
        Utils.DisplayHelpText('~b~' .. Lang['loading_ready'])
    end
end

-- fix to stop products detaching from pallets and pallets from the trailer
function Trailer:reattachPallets()
  for i = 1, 5 do
    local netId = DecorGetInt(self.entity, 'netid_slot_' .. i)
    if netId > 0 then
      local entity = NetToEnt(netId)
      if DoesEntityExist(entity) and GetEntityAttachedTo(entity) == 0 then
        Utils.takeControlOfEntity(entity)
        AttachEntityToEntity(entity, self.entity, 0, 0.0, (i*2.0)-7.1, 0.41, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
      end
    end
  end
end

function Trailer:carryingForklift()
    return DecorGetInt(self.entity, 'forklift_netid') > 0
end


function Trailer:getAttachedTruck(hasDriver)
    if self.entity == nil then 
        return false
    end
    local truck = GetEntityAttachedTo(self.entity)
    if truck > 0 then
        if hasDriver then
            return truck, (GetPedInVehicleSeat(truck, -1) > 0 or GetPedInVehicleSeat(truck, 0) > 0 or GetPedInVehicleSeat(truck, 1) > 0)
        end
        return truck, false
    end
    return 0
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

function Trailer:flatEnough() 
    return math.abs( GetEntityRoll(self.entity) ) < 8 and math.abs( GetEntityPitch(self.entity) ) < 25
end

function Trailer:attachForklift(forkliftNetId)
    local forkliftEntity = NetToEnt(forkliftNetId)
    local trailerEntity = self.entity
    Utils.takeControlOfEntity(trailerEntity)
    DecorSetInt(trailerEntity, 'forklift_netid', forkliftNetId)
    SetForkliftForkHeight(forkliftEntity, 0.0)
    local num = 0.6
    while num > 0.2 do
        num = num - 0.009
        AttachEntityToEntity(NetToEnt(forkliftNetId), trailerEntity, 0, 0.0, -7.58, -num, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        Wait(30)
    end
    SetEntityCollision(NetToEnt(forkliftNetId), true, false)

    -- check to ensure trailer hasn't changed since the attachment started
    if trailerEntity == self.entity and DecorGetInt(self.entity, 'trailer_lowered') == 1 then
        self.Raise(self.entity)
        self:updateMenu()
    end
end

function Trailer:clear()
    self.entity = nil
    self.unloading = false
end

-- class agnoistic functions
Trailer.SetLoading = function(entity, bool)
    if bool then
        DecorSetInt(entity, 'trailer_unloading', 1)
    else
        DecorSetInt(entity, 'trailer_unloading', 0)
    end
end

Trailer.Raise = function(entity)
    if DecorGetInt(entity, 'trailer_lowered') == 0 then return end

    Citizen.CreateThread(function() 
        Utils.takeControlOfEntity(entity)
        DecorSetInt(entity, 'trailer_lowered', 0)
        FreezeEntityPosition(entity, false)
        SetEntityCollision(entity, true, true)
        SetTrailerLegsRaised(entity)

        local truck = Trailer:getAttachedTruck(false)
        if truck then
            FreezeEntityPosition(truck, false)
        end
    end)

end

Trailer.Lower = function(entity)
    if DecorGetInt(entity, 'trailer_lowered') == 1 then return end

    if not Trailer:flatEnough() then
        return Utils.DisplayHelpText('~r~' .. Lang['ground_not_flat'])
    end
    
    DecorSetInt(entity, 'trailer_lowered', 1)
    Utils.takeControlOfEntity(entity)
    local coords = GetEntityCoords(entity)

    -- catch rare edge case where coords come back wrong
    if coords.x == 0.0 then
        print('enc0ded-forklift-trailer: Could not get coords for trailer; lower function aborted.')
        print('Please try again')
    else
        local _, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
        SetEntityCollision(entity, true, false)
        FreezeEntityPosition(entity, false)
        SetEntityCoords(entity, coords.x, coords.y, ground, true, true, false, false)
        DisableVehicleWorldCollision(entity)
        FreezeEntityPosition(entity, true)
    
        local truck = GetEntityAttachedTo(entity)
        if truck > 0 then
            DetachVehicleFromTrailer(truck)
            DisableVehicleWorldCollision(truck)
            FreezeEntityPosition(truck, true)
        end
    end
end

Trailer.AttachForkliftNoAnim = function(forkliftNetId)
    TriggerServerEvent('enc0ded-forklift-trailer/owner-event', 'attach-forklift', VehToNet(Trailer.entity), forkliftNetId)
    local forkliftEntity = NetToEnt(forkliftNetId)
    AttachEntityToEntity(forkliftEntity, Trailer.entity, 0, 0.0, -7.58, -0.23, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    SetEntityCollision(forkliftEntity, true, false)
end

Trailer.SetAttachedTrailer = function(entity, forkliftNetId) 
    DecorSetInt(entity, 'forklift_netid', forkliftNetId)
end

Trailer.ReleaseForklift = function(entity)
    local forkliftNetId = DecorGetInt(entity, 'forklift_netid')
    
    if not NetworkDoesEntityExistWithNetworkId(forkliftNetId) then
        return
    end

    local forkliftEntity = NetworkGetEntityFromNetworkId(forkliftNetId)
    local trailerCoords = GetEntityCoords(entity)
    Utils.takeControlOfEntity(entity)
    Utils.takeControlOfEntity(forkliftEntity)
    DecorSetInt(entity, 'forklift_netid', 0)

    if Trailer.entity == entity then
        Trailer.Raise(entity)
    end
    
    FreezeEntityPosition(entity, true)

    local num = 0.2
    while num < 0.6 do
        num = num + 0.015
        Utils.takeControlOfEntity(entity)
        Utils.takeControlOfEntity(NetToEnt(forkliftNetId))
        AttachEntityToEntity(NetToEnt(forkliftNetId), entity, 0, 0.0, -7.58, -num, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        Wait(25)
    end

    Utils.takeControlOfEntity(NetToEnt(forkliftNetId))
    forkliftEntity = NetToEnt(forkliftNetId)
    SetForkliftForkHeight(forkliftEntity, 0.0)
    DetachEntity(forkliftEntity, true)
    SetEntityCollision(forkliftEntity, true, true)
    
    -- new position isn't ready and the forklift "collides" with the entity even though it's not touching
    local coords = GetEntityCoords(forkliftEntity, true)
    local _, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
    SetEntityCoords(forkliftEntity, coords.x, coords.y, ground)
    local spacing = 0.00
    while HasEntityCollidedWithAnything(forkliftEntity) do
        spacing = spacing + 0.02
        local offetCoords = GetOffsetFromEntityInWorldCoords(entity, 0.0, spacing, 0.0)
        SetEntityCoords(forkliftEntity, offetCoords.x, offetCoords.y, ground)
        SetEntityNoCollisionEntity(forkliftEntity, entity, true)
        Wait(25)
    end
    SetEntityCollision(forkliftEntity, true, true) -- reset collison with trailer

    if Trailer.entity == entity then
        if Trailer:countPallets() > 0 and not Trailer.unloading then
            Trailer:toggleUnloading(true)
        elseif Trailer.unloading then
            Trailer:toggleUnloading()
        end
        Trailer:updateMenu()
        Trailer.Lower(entity)
    end

end

Trailer.PalletLoaded = function(trailerEntity, slotIndex, palletNetId)
    local palletEntity = NetworkGetEntityFromNetworkId(palletNetId)
    SetEntityCollision(palletEntity, false, false)
    DecorSetInt(trailerEntity, 'netid_slot_' .. slotIndex, palletNetId)
end

function Trailer.PalletUnloaded(entity)


end
Forklift = {
    entity
}

function Forklift:enter(entity)
    self.entity = entity

    SetNetworkIdAlwaysExistsForPlayer(NetworkGetNetworkIdFromEntity(entity), PlayerId(), true)

    Citizen.CreateThread(function ()

        local sleep, forkCoords, pallet, status, palletCoords, dist, palletEntity, netid, trailerCoords

        while self.entity == entity do
            sleep = 250
            forkCoords = GetWorldPositionOfEntityBone(self.entity, GetEntityBoneIndexByName(self.entity, 'forks'))
            pallet = GetClosestObjectOfType(forkCoords.x, forkCoords.y, forkCoords.z, 0.9, GetHashKey(Config.palletModel), true, false, false)
            status = DecorGetInt(pallet, 'pallet_status')
            if pallet and pallet ~= Pallet.entity and status ~= 2 and status ~= 4 then
                palletCoords = GetEntityCoords(pallet)
                dist = Vdist(palletCoords.x, palletCoords.y, palletCoords.z, forkCoords.x, forkCoords.y, forkCoords.z) --Utils.DistanceBetweenCoords(forkCoords, palletCoords)
                if dist < 1.7 and (forkCoords.z >= palletCoords.z - 0.5 and forkCoords.z <= palletCoords.z + 0.75) then --
                    Pallet:initiate(pallet)
                end
            end

            if Trailer.unloading then
                -- unload pallets from trailer
                for i = 1, 5 do
                    netid = DecorGetInt(Trailer.entity, 'netid_slot_' .. i)
                    if netid > 0 then
                        palletEntity = NetworkGetEntityFromNetworkId(netid)
                        palletCoords = GetEntityCoords(palletEntity)
                        forkliftCoords = GetEntityCoords(self.entity)
                        dist = Utils.DistanceBetweenCoords(forkliftCoords, palletCoords)
                        if dist < 2.99 then
                            Utils.takeControlOfEntity(Trailer.entity)
                            DecorSetInt(Trailer.entity, 'netid_slot_' .. i, 0)
                            DecorSetInt(palletEntity, 'pallet_status', 1)
                            Pallet:initiate(palletEntity)
                            break
                        end
                    end

                end
            elseif Pallet.entity then
                -- load pallets on trailer
                sleep = 0
                for i = 1, 5 do
                    if DecorGetInt(Trailer.entity, 'netid_slot_' .. i) < 1 then
                        trailerCoords = GetOffsetFromEntityInWorldCoords(Trailer.entity, 0.0, (i*2.0)-7.1, 0.3)
                        DrawMarker(0, trailerCoords.x, trailerCoords.y, trailerCoords.z+0.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 55, 55, 255, 185, 1, 0, 0, 0)
                        palletCoords = GetEntityCoords(Pallet.entity)
                        dist = Utils.DistanceBetweenCoords(palletCoords, trailerCoords)
                        if dist < 1.0 and palletCoords.z <= trailerCoords.z + 0.15 then
                            Trailer:palletLoaded(i)
                            break
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

function Forklift:exit()
    self.entity = nil
end
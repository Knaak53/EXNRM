Truck = {
    entity,
    lastVehicleEntity = 0
}

function Truck:enter(entity)
    if not entity or self.entity == entity then return end

    self.entity = entity
    self.lastVehicleEntity = entity
    
    Utils.takeControlOfEntity(self.entity)
    SetEntityCollision(self.entity, true, true)
    FreezeEntityPosition(self.entity, false)
    Pallet:clear()

    Citizen.CreateThread(function()
        local hasTrailer, trailer
        repeat
            Wait(1000)
            hasTrailer, trailer = GetVehicleTrailerVehicle(self.entity)
        until self.entity ~= entity or hasTrailer
        Trailer.initiate(trailer)
        Trailer.Raise(trailer)
        FreezeEntityPosition(self.entity, false)
    end)
end

function Truck:exit()
    self.entity = nil
end


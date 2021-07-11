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
  
  local hasTrailer, trailer = GetVehicleTrailerVehicle(self.entity)

  if Trailer.entity or hasTrailer then
      Trailer.initiate(trailer)
      Trailer:raise()
      FreezeEntityPosition(Trailer.entity, false)
      --AttachVehicleToTrailer(self.entity, Trailer.entity, 0.5)
  end
  
  Pallet:clear()

end

function Truck:exit()
  self.entity = nil
end


AddEventHandler('onResourceStop', function(resourceName)
    ESX.UI.Menu.CloseAll()
    if GetCurrentResourceName() == resourceName then
      for k,v in pairs(EnterMarkers) do 
        ESX.Markers.Remove(v)
      end
      if Shell ~= nil then
        DeleteObject(Shell)
      end
      for k,v in pairs(CurrentParkingMarkers) do
        ESX.Markers.Remove(v)
      end
      for k,v in pairs(SpawnedCars) do 
        ESX.Game.DeleteVehicle(v.car)
      end
      for k,v in pairs(PrivateMarkers) do
        ESX.Markers.Remove(v)
      end
    end
end)
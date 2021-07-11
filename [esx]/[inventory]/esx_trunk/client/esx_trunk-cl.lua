ESX = nil
local currentPlate = ''

Citizen.CreateThread(function()
  while ESX == nil do
    ESX = exports.extendedmode:getSharedObject()
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx_trunk:open_trunk_ui')
AddEventHandler('esx_trunk:open_trunk_ui', function(entity)
  local playerPed = PlayerPedId()
  local vehicle   = entity

  if IsPedSittingInAnyVehicle(playerPed) then
    ESX.ShowNotification('No puedes hacer eso desde el vehiculo')
    return
  end

  if DoesEntityExist(vehicle) then
      plate  = GetVehicleNumberPlateText(vehicle)
      local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
      local locked = GetVehicleDoorLockStatus(vehicle)
      local class = GetVehicleClass(vehicle)
      if locked == 1 or class == 15 or class == 16 or class == 14 then
          --ESX.TriggerServerCallback('esx_trunk:canSearchTrunk', function(can)
              --if can then
                  --TriggerServerEvent('esx_trunk:startSearching', plate)
                  TriggerEvent('esx_generic_inv_ui:openTrunk', plate, Config.VehicleLimit[class], NetworkGetNetworkIdFromEntity(vehicle))
              --else
                 -- ESX.ShowNotification('~r~El maletero ya esta siendo usado!') 
              --end
          --end, plate)         
      else
         ESX.ShowNotification('~r~El maletero está cerrado!') 
      end
  else
      ESX.ShowNotification('El vehiculo debe estar frente a ti para hacer eso!')
  end
end)
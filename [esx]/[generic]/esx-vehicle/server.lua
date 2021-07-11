local vehicleKeys = {}
local myVehicleKeys = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
 ESX = obj
end)

local robbableItems = {
 [1] = {chance = 3, id = 0, name = 'Cash', quantity = math.random(30, 75)}, -- really common
 [2] = {chance = 5, id = 1, name = 'Keys', isWeapon = false}, -- rare
}

RegisterServerEvent('garage:searchItem')
AddEventHandler('garage:searchItem', function(plate)
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()

  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 then
    xPlayer.addMoney(item.quantity)
    TriggerClientEvent('notification', source, 'Has encontrado $'..item.quantity)
   elseif item.isWeapon then
    xPlayer.addWeapon(item.id, 50)
    TriggerClientEvent('notification', source, 'Item Added!', 2)
   elseif tonumber(item.id) == 1 then
    TriggerClientEvent('notification', source, 'Has encontrado las llaves del vehiculo!', 1)
    vehicleKeys[plate] = {}
    table.insert(vehicleKeys[plate], {id = ident})
    TriggerClientEvent('garage:updateKeys', source, vehicleKeys[plate], ident, plate)
    TriggerClientEvent('vehicle:start', source)
   else
    xPlayer.addInventoryItem(item.id, item.quantity)
    TriggerClientEvent('notification', source, 'Item Added!', 2)
   end
  end
end)

RegisterServerEvent('garage:giveKey')
AddEventHandler('garage:giveKey', function(target, plate)
 local targetSource = tonumber(target)
 local xPlayer = ESX.GetPlayerFromId(targetSource)
 local ident = xPlayer.getIdentifier()
 local xPlayer2 = ESX.GetPlayerFromId(source)
 local ident2 = xPlayer2.getIdentifier()
 local plate = tostring(plate)

 vehicleKeys[plate] = {}
 table.insert(vehicleKeys[plate], {id = ident})
 TriggerClientEvent('notification', targetSource, 'Has recibido las llaves del vehiculo ~y~' .. plate, 1)
 TriggerClientEvent('garage:updateKeys', targetSource, vehicleKeys[plate], ident, plate)
 TriggerClientEvent('garage:updateKeys', source, vehicleKeys[plate], ident2, plate)
end)

AddEventHandler('esx:playerLoaded', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local myVehs = xPlayer.get("vehicles")
    local _source = source

    if myVehs ~= nil then 
      for k,v in pairs(myVehs) do
        TriggerEvent("garage:addKeys", v.plate, _source)
      end
    end
end)


RegisterCommand("testkeys", function(source) 
  local xPlayer = ESX.GetPlayerFromId(source)
  local myVehs = xPlayer.get("vehicles")
  local _source = source

  for k,v in pairs(myVehs) do
    print("myKeys: "..v.plate)
    TriggerEvent("garage:addKeys", v.plate, _source)
  end
end, false)

RegisterServerEvent('garage:addKeys')
AddEventHandler('garage:addKeys', function(plate , _source, hotwired)
  local __source = tonumber(source)

  if _source then
    __source = tonumber(_source)
  end
 
 local xPlayer = ESX.GetPlayerFromId(__source)
 local ident = xPlayer.getIdentifier()

 if vehicleKeys[plate] ~= nil then
  print("adding key")
  if hotwired then
    table.insert(vehicleKeys[plate], {id = "all"})
    TriggerClientEvent('garage:updateKeys', -1, vehicleKeys[plate], false, plate)
  else
    table.insert(vehicleKeys[plate], {id = ident})
    TriggerClientEvent('garage:updateKeys', __source, vehicleKeys[plate], ident, plate)
  end
  
 else
  print(plate)
  vehicleKeys[plate] = {}
  print(vehicleKeys[plate])
  if hotwired then
    table.insert(vehicleKeys[plate], {id = "all"})
    TriggerClientEvent('garage:updateKeys', -1, vehicleKeys[plate], false, plate)
  else
    table.insert(vehicleKeys[plate], {id = ident})
    TriggerClientEvent('garage:updateKeys', __source, vehicleKeys[plate], ident, plate)
    TriggerClientEvent('vehicle:start', __source)
  end
 end
end)

RegisterServerEvent('garage:removeKeys')
AddEventHandler('garage:removeKeys', function(plate)
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()
 if vehicleKeys[plate] ~= nil then
  for id,v in pairs(vehicleKeys[plate]) do
   if v.id == ident then
    table.remove(vehicleKeys[plate], id)
   end
  end
 end
 TriggerClientEvent('garage:updateKeys', source, vehicleKeys[plate], ident, plate)
end)

RegisterServerEvent('removelockpick')
AddEventHandler('removelockpick', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 if math.random(1, 20) == 1 then
  xPlayer.removeInventoryItem("lockpick", 1)
  TriggerClientEvent('notification', source, 'The lockpick bent out of shape.', 2)
 end
end)

ESX.RegisterUsableItem('lockpick', function(source)
  TriggerClientEvent('lockpick:vehicleUse', source, "lockpick", "Desconocida")
end)

RegisterServerEvent("keys:togglelocks")
AddEventHandler('keys:togglelocks', function(plate, doorState, vehId)
  local xVehicle = ESX.GetVehicleByPlate(plate)
  --print("toggling vehicle slocks comparing: "..xVehicle.getVehicleDoorState() .. "with".. ESX.VehicleLockStatus.Unlocked )
  if xVehicle then
    if xVehicle.getVehicleDoorState() == ESX.VehicleLockStatus.Unlocked then
      xVehicle.setVehicleDoorState(ESX.VehicleLockStatus.Locked)
      --TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "unlock", 0.1)
      --TriggerEvent('notification', 'Vehiculo bloqueado', 1)
      print("closing")
    elseif xVehicle.getVehicleDoorState() == ESX.VehicleLockStatus.Locked then
      --TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "lock", 0.1)
      xVehicle.setVehicleDoorState(ESX.VehicleLockStatus.Unlocked)
      --TriggerEvent('notification', 'Vehiculo desbloqueado', 1)
      --SetVehicleDoorsLocked(vehicle, 1)
      print("opening")
    elseif xVehicle.getVehicleDoorState() == ESX.VehicleLockStatus.None then
      local ans = xVehicle.setVehicleDoorState(ESX.VehicleLockStatus.Locked)
      if ans then
        print("closing")
      else
        print("NOPE closing")
      end
    
    --TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "unlock", 0.1)
    --TriggerEvent('notification', 'Vehiculo bloqueado', 1)
    end
  end
end)

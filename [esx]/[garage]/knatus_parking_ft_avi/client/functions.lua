---Salirse del parking andando
function ExitWalkingGarage()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
    if not EnteredWithVehicle.value then
      if vehicle == 0 then
        DoScreenFadeOut(1500)
        Wait(1500)
        SetEntityCoords(PlayerPedId(),Config.garages[CurrentParking].enterCoords,0,0,0,0,false)
        SetEntityHeading(PlayerPedId(), 161.55)
        DeleteParking()
        Wait(1000)
        DoScreenFadeIn(500)
      else
        ESX.ShowNotification("No puedes salir con el coche por esta puerta", false, true, 6)
      end
    else
      ESX.ShowNotification("El guardia te impide salir hasta que aparques o salgas con tu vehiculo", false, true, 6)
    end
end

---Salirse del parking en el coche
function ExitDrivingGarage()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
    if vehicle == 0 then
        ESX.ShowNotification("Sal por la puerta para personas", false, true, 6)
    else
        TriggerServerEvent('s2v_parkings:SyncEnteredWithCar',ESX.Game.GetVehicleProperties(vehicle).plate,CurrentParking,CurrentFloor)
        DoScreenFadeOut(1500)
        Wait(1500)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        SetEntityCoords(vehicle,Config.garages[CurrentParking].enterCoords,0,0,0,0,false)
        SetEntityHeading(vehicle, 161.55)
        TaskWarpPedIntoVehicle(PlayerPedId(),vehicle,-1)
        DeleteParking()
        Wait(1000)
        DoScreenFadeIn(500)
    end
end
  
---Borrar planta del parking
function DeleteParkingFloor()
    for k,v in pairs(CurrentParkingMarkers) do
      ESX.Markers.Remove(v)
    end
    for k,v in pairs(SpawnedCars) do 
      ESX.Game.DeleteVehicle(v.car)
    end
    local _shell = Shell
    CurrentParkingMarkers = {}
    EnterParkingFloor()
    DeleteObject(_shell)
end

---Borrar Parking
function DeleteParking()
    for k,v in pairs(CurrentParkingMarkers) do
      ESX.Markers.Remove(v)
    end
    for k,v in pairs(SpawnedCars) do 
      ESX.Game.DeleteVehicle(v.car)
    end
    CurrentParkingMarkers = {}
    CurrentFloor = nil
    CurrentParking = nil
    DeleteObject(Shell)
    Shell = nil
end

function GetParkingPlace(_parking,_floor,_place)
  --print(json.encode(ParkingsCache[_parking][_floor]))
  for k,v in pairs(ParkingsCache[_parking][_floor]) do
    if v.place == _place then
     return v
    end
  end
end
---Entrar dentro del garage
function EnterParkingFloor()
    local zcalcule = 0
    if CurrentFloor == nil then zcalcule = 0 else zcalcule = (CurrentFloor-1)*12 end
    ESX.Streaming.RequestModel(GetShell())
    Shell = CreateObject(GetHashKey(GetShell()), vector3(GetShellCoords().x,GetShellCoords().y,GetShellCoords().z+zcalcule), false, false, true)
    FreezeEntityPosition(Shell,true)
    for k,v in pairs(GetShellSpawnCoords()) do
      if GetParkingPlace(CurrentParking,CurrentFloor,v.id).state == false then
        local mark = ESX.Markers.Add(Config.parkMarkerType,GetOffsetFromEntityInWorldCoords(Shell,v.x,v.y,v.ParkingMarkerZ),Config.parkMarkerColour.r,Config.parkMarkerColour.g,Config.parkMarkerColour.b,Config.parkMarkerColour.a,20.0,false,vec(3, 5, 1), v.heading, vec(0, 0, 0), false, nil, nil)
          --table.insert(CurrentParkingMarkers,mark)
          CurrentParkingMarkers[v.id] = mark
      end
    end
    for k,v in pairs(ParkingsCache[CurrentParking][CurrentFloor]) do
      if v.vehicle.model ~= nil then
        ESX.Game.SpawnLocalVehicle(v.vehicle.model,vector3(0,0,-3)+GetOffsetFromEntityInWorldCoords(Shell,GetShellSpawnCoords()[v.place].x,GetShellSpawnCoords()[v.place].y,0), v.heading, function(vehicle)
          ESX.Game.SetVehicleProperties(vehicle,v.vehicle)
          FreezeEntityPosition(vehicle,true)
          IsVehicleOwner(v.vehicle.plate, function(owned) 
            if not owned then
              print(v.vehicle.plate.."Eres owner")
              SetVehicleDoorsLocked(vehicle,2)
              TriggerEvent('s2v_parkings:InserCarInCache',vehicle,false,v.place)
            else
              TriggerEvent('s2v_parkings:InserCarInCache',vehicle,true,v.place)
              print(v.vehicle.plate.."NOO Eres owner")
            end
          end)
        end)
      end
    end
    --Crear los vehiculos aparcados
    local exitWalkingMarker = ESX.Markers.Add(Config.enterMarker,GetOffsetFromEntityInWorldCoords(Shell,GetShellExitWalkingOffset().x,GetShellExitWalkingOffset().y,GetShellExitWalkingOffset().markz), 204, 0, 0, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
    table.insert(CurrentParkingMarkers,exitWalkingMarker)
    local exitDrivingMarker = ESX.Markers.Add(Config.enterMarker,GetOffsetFromEntityInWorldCoords(Shell,GetShellExitDrivingOffset().x,GetShellExitDrivingOffset().y,GetShellExitWalkingOffset().markz), 204, 0, 0, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
    table.insert(CurrentParkingMarkers,exitDrivingMarker)  
    DoScreenFadeOut(1500)
    Wait(1500)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
    if vehicle == 0 then
      SetEntityCoords(PlayerPedId(),GetOffsetFromEntityInWorldCoords(Shell,GetShellExitWalkingOffset().x,GetShellExitWalkingOffset().y,0),0,0,0,false)
      SetEntityHeading(PlayerPedId(), GetShellExitWalkingOffset().heading)
    else
      EnteredWithVehicle.vehicleplate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
      if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then 
        EnteredWithVehicle.value = true
      else
        EnteredWithVehicle.value = false
      end
      SetEntityCoords(vehicle,vector3(0,0,-3)+GetOffsetFromEntityInWorldCoords(Shell,GetShellExitDrivingOffset().x,GetShellExitDrivingOffset().y,0),0,0,0,false)
      SetEntityHeading(vehicle, GetShellExitDrivingOffset().heading)
      TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
    Wait(3000)
    DoScreenFadeIn(500)
end

---Devuelve el source de los players que tienes en el coche para sincronizarlos contigo a la hora de entrar y salir
-- function GetPlayersServerIdInVehicle(vehicle)
--     local players = {}
--     local seats = GetVehicleMaxNumberOfPassengers(vehicle)
--     for i=-1,seats-1,1 do
--       for _, player in pairs(GetActivePlayers()) do
--         if PlayerPedId() ~= GetPlayerPed(player) then
--           if GetPlayerPed(player) == GetPedInVehicleSeat(vehicle,i) then
--             local player = GetPlayerServerId(player)
--             table.insert(players,player)
--           end
--         end
--       end
--     end
--     return players
-- end

function GetPlayersServerIdInVehicle(vehicle)
  local peds = {}
  local serverids = {}
  for i=0,GetVehicleMaxNumberOfPassengers(vehicle)-1, 1 do
    local ped = GetPedInVehicleSeat(vehicle,i)
    if ped > 0 then
      peds[ped] = true
    end
  end
  for _, player in pairs(GetActivePlayers()) do
    local ped = GetPlayerPed(player)
    if peds[ped] then
      local p = GetPlayerServerId(player)
      table.insert(serverids,p)
    end
  end
  return serverids
end

RegisterCommand('playersIn',function()
  local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
  if vehicle > 0 then
    --print(json.encode(GetPlayersServerIdInVehicleV2(vehicle)))
  end
end,false)

--function GetPlayersServerIdNew(vehc)

---Funcion que decide si un usuario esta en el coche y si es conductor para dejarle solo al conductor abrir los menus o darle a la e
function LetOpenMenu()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if vehicle ~= 0 then--Esta en el coche
        if PlayerPedId() == GetPedInVehicleSeat(vehicle,-1) then --Es el conductor entonces devolvemos true
            return true --Esta conduciendo
        else
            return false --Es acompañante
        end
    else
        return true --Esta andando
    end
end

---Funcion que ocurre al darle a la e y aparcar el vehiculo
function ParkCar(_floor,_parking,_place)
  local vehicleProperties = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
  vehicleProperties["fuel"] = exports["LegacyFuel"]:GetFuel(GetVehiclePedIsIn(PlayerPedId()))
  local vehicle = GetVehiclePedIsIn(PlayerPedId())
  local heading = GetEntityHeading(vehicle)
  ESX.TriggerServerCallback("s2v_parkings:parkVehicle",function(result)
    if result then
      TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
      ParkNetworkedCar(vehicle,_place)
    else 
      ESX.ShowNotification("El coche no te pertenece", false, true, 6)
    end
  end,vehicleProperties,_floor,_parking,_place,heading)
end

local pendingOfWarping = false
function TakeCar(_floor,_parking,_place)
  local vehicleProperties = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
  local vehicle = GetVehiclePedIsIn(PlayerPedId())
  local coords = GetEntityCoords(vehicle)
  local heading = GetEntityHeading(vehicle)
  ESX.TriggerServerCallback("s2v_parkings:takeVehicle",function(result,fuel)
    if result then --Despawneo el vehiculo para mi y para todos
      --ESX.Game.DeleteVehicle(vehicle)
      TriggerServerEvent('s2v_parkings:DeleteTakenVehicleSync',_parking,_floor,_place)
      Citizen.Wait(40)
      --Mandarle a los clientes que esten en el parking borrar el vehiculo de la place x
      vehicleProperties.fuel = fuel
      TriggerServerEvent("caronte_parkings:takecar", json.encode(vehicleProperties), coords, heading)
      pendingOfWarping = true
      --ESX.Game.SpawnVehicle(vehicleProperties.model,coords,heading,function(vehiclecb) --Lo espawneo neteorkeado
      --  ESX.Game.SetVehicleProperties(vehiclecb,vehicleProperties)
      --  TaskWarpPedIntoVehicle(PlayerPedId(),vehiclecb,-1)--Me meto dentro
      --  SetVehicleFuelLevel(vehiclecb, 100.0)
      --  exports["LegacyFuel"]:SetFuel(vehiclecb,fuel)
      --  TriggerEvent('persistent-vehicles/register-vehicle', vehiclecb)
      --end,true)
    end
  end,vehicleProperties,_floor,_parking,_place)
end

RegisterNetEvent("caronte_parkings:warpToVehIfPending")
AddEventHandler("caronte_parkings:warpToVehIfPending",function(netveh)
  print("llega evento warp")
  if pendingOfWarping then
    Citizen.CreateThread(function() 
      --local veh = NetToVeh(netveh)
      
      while not DoesEntityExist(netveh) do
        Wait(400)
        veh = NetToVeh(netveh)

      end

      TaskWarpPedIntoVehicle(PlayerPedId(),netveh,-1)--Me meto dentro
      pendingOfWarping = false
    end)
  else
    print("ERROR WARPING")
  end
end)

RegisterNetEvent("caronte_parkings:carspawnready")
AddEventHandler("caronte_parkings:carspawnready", function(vehnet, properties)
  Citizen.CreateThread(function() 
    local veh = NetToVeh(vehnet)
    local vproperties = json.decode(properties)
    while not DoesEntityExist(veh) do
      Wait(400)
    end
    print("cambio cosas")
    --ESX.Game.SetVehicleProperties(NetToVeh(vehnet),vproperties)
    --TaskWarpPedIntoVehicle(PlayerPedId(),vehiclecb,-1)--Me meto dentro
    SetVehicleFuelLevel(veh, 100.0)
    exports["LegacyFuel"]:SetFuel(veh,vproperties.fuel)
    --TaskWarpPedIntoVehicle(PlayerPedId(),NetToVeh(vehnet),-1)
  end)
end)

---Funcion para aparcar un vehiculo recien aparcado hasta que se salga
--SetEntityAsNoLongerNeeded()
function ParkNetworkedCar(vehicle,place)
  TriggerServerEvent('s2v_parkings:SyncEnteredWithCar',ESX.Game.GetVehicleProperties(vehicle).plate,CurrentParking,CurrentFloor)
  FreezeEntityPosition(vehicle,true)
  local pos = GetEntityCoords(vehicle)
  local heading = GetEntityHeading(vehicle)
  local properties = ESX.Game.GetVehicleProperties(vehicle)
  local playersIn = GetPlayersServerIdInVehicle(vehicle)
  TriggerServerEvent('s2v_parkings:TaskLeaveVehicleSv',playersIn,doors)
  TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),64)
  SetVehicleDoorsLocked(vehicle,4)
  TriggerEvent('persistent-vehicles/forget-vehicle',vehicle) ---Forget vehicle
  Citizen.Wait(2100)
  --ESX.Game.DeleteVehicle(vehicle)
  Citizen.Wait(10)
  TriggerServerEvent('s2v_parkings:SyncNoNetworkedCarSv',properties,pos,heading,CurrentParking,CurrentFloor,place)
end

---Funcion que nos dice si el vehiculo es de la persona
function IsVehicleOwner(plate, cb)
  local owned = false
  ESX.TriggerServerCallback('esx:isVehicleOwnedByPlayer', function(ownedP)
    if ownedP then
      owned = true
      cb(owned)
    else
      ESX.TriggerServerCallback("esx:isVehicleOwnedBySameCompany", function(ownedC)
        if ownedC then
          print("ES TRUUEE")
          owned = true
          cb(owned)
        else
          print("POOS NO")
          cb(false)
        end
      end, plate)
    end
  end, plate)
end

---Funcion que devuelve la shell actual
function GetShell()
  return Config.garages[CurrentParking].shell
end
---Function que devuelve las coordenadas de la shell actual
function GetShellCoords()
  return vector3(Config.garages[CurrentParking].enterCoords.x,Config.garages[CurrentParking].enterCoords.y,Config.garages[CurrentParking].enterCoords.z-100)
end

RegisterCommand("getshellcoords",function()
  local coords = vector3(Config.garages["Central2"].enterCoords.x,Config.garages["Central2"].enterCoords.y,-100)
end)

---Funcion que devuelve las coordenadas internas de cada shell
function GetShellSpawnCoords()
  return Config.GarageSpawns[Config.garages[CurrentParking].shell].Spawns
end
---Devuelve la capacidad de la shell que voy a spawnear
function GetShellCapacity()
  return Config.GarageSpawns[Config.garages[CurrentParking].shell].Capacity
end

---Funcion que devuelve el offset a la hora de salir andando
function GetShellExitWalkingOffset()
  return Config.GarageSpawns[Config.garages[CurrentParking].shell].WalkingExitOffset
end

---Function que devuelve el offset a la hora de salir con el coche
function GetShellExitDrivingOffset()
  return Config.GarageSpawns[Config.garages[CurrentParking].shell].DrivingExitOffset
end





---Variables globales
EnterMarkers = {}--Markers de entrada
MapBlips = {} --Blips del mapa
ESX = nil --ESX
Shell = nil --Objeto
CurrentParking = nil --Parking actual
CurrentFloor = nil --Planta actual
CurrentParkingMarkers = {} --Markers que hay 
MenusStates = nil --Estado de los menus 
ParkingsCache = {} --Cache con el estado de los parkings
SpawnedCars = {}
PlayerCars = {}
PlayerData = nil
--Variables auxiliares para hacer la vida mas facil
PrivateBlips = {}
PrivateMarkers = {}

EnteredWithVehicle = {vehicleplate = nil,value = false}

Citizen.CreateThread(function()
  while ESX == nil do
    ESX = exports.extendedmode:getSharedObject()
    Citizen.Wait(0)
  end
  if ESX ~= nil and ESX.GetPlayerData().job then 
    --print("^2Parkings initialized correctly^7")
  else
    while not ESX.GetPlayerData().job do
        Wait(5000)
        --ESX = exports.extendedmode:getSharedObject()
        if ESX.GetPlayerData().job then
            --print("^2Parkings initialized correctly^7")
        end
    end
  end
  ESX.TriggerServerCallback('s2v_parkings:requireConfig',function(config)
    Config.garages = config
    for k,v in pairs(Config.garages) do
      --print(v.type)
      if v.type == "public" then
        --table.insert(MapBlips,blip)
        if type(v.enterCoords) ~= "vector3" then
          v.enterCoords = vector3(v.enterCoords.x , v.enterCoords.y, v.enterCoords.z)
        end
        if not MapBlips[k] then
          local blip = ESX.CreateBlip(v.enterCoords,v.blip,v.blipColour,1.0,v.label,GetCurrentResourceName())
          MapBlips[k] = blip
        end
        --table.insert(EnterMarkers,marker)
        if not EnterMarkers[k] then
          local marker = ESX.Markers.Add(Config.enterMarker, v.enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
          EnterMarkers[k] = marker
        end
      elseif v.type == ESX.GetPlayerData().job.name then
        
        --table.insert(PrivateBlips,blip)
        if not PrivateBlips[k] then
          local blip = ESX.CreateBlip(v.enterCoords,v.blip,v.blipColour,1.0,v.label,GetCurrentResourceName())
          PrivateBlips[k] = blip
        end
        --table.insert(PrivateMarkers,marker)
        if not PrivateMarkers[k] then
          local marker = ESX.Markers.Add(Config.enterMarker, v.enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
          PrivateMarkers[k] = marker
        end
      elseif v.type == "private" and v.source then
        if GetPlayerServerId(PlayerId()) == v.source then
          --table.insert(PrivateBlips,blip)
          if not PrivateBlips[k] then
            local blip = ESX.CreateBlip(v.enterCoords,v.blip,v.blipColour,1.0,v.label,GetCurrentResourceName())
            PrivateBlips[k] = blip
          end
          --table.insert(PrivateMarkers,marker)
          if not PrivateMarkers[k] then
            local marker = ESX.Markers.Add(Config.enterMarker, v.enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
            PrivateMarkers[k] = marker
          end
        end
      end
    end
  end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
  --print(ESX.GetPlayerData().job.name)
  for k,v in pairs(PrivateMarkers) do
    ESX.Markers.Remove(v)
  end
  for k,v in pairs(PrivateBlips) do
    --print(v)
    ESX.DeleteBlip(v,GetCurrentResourceName())
  end
  PrivateMarkers = {}
  PrivateBlips = {}
  for k,v in pairs(Config.garages) do
    if v.type == ESX.GetPlayerData().job.name then
      --table.insert(MapBlips,blip) --Por que coños meto el blip privado en la tabla de blips publicos
      --table.insert(PrivateBlips,blip)
      if not PrivateBlips[k] then
        local blip = ESX.CreateBlip(v.enterCoords,v.blip,v.blipColour,1.0,v.label,GetCurrentResourceName())
        PrivateBlips[k] = blip
      end
      --table.insert(EnterMarkers,marker)
      --table.insert(PrivateMarkers,marker)
      if not PrivateMarkers[k] then
        local marker = ESX.Markers.Add(Config.enterMarker, v.enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
        PrivateMarkers[k] = marker
      end
    end
  end
  TriggerServerEvent('s2v_parkings:ReloadClientCars')
end)
--Variables auxiliares para mejorar rendimiento
local ParkingAux = nil
local FloorsAux = nil
local PlaceAux = nil
--Eventos
RegisterNetEvent('s2v_parkings:enterParkingcl')
RegisterNetEvent('s2v_parkings:exitParkingcl')
RegisterNetEvent('s2v_parkings:SyncPlaces')
RegisterNetEvent('s2v_parkings:QuitMarkerPeopleInFloor')
RegisterNetEvent('s2v_parkings:TaskLeaveVehicleCl')
RegisterNetEvent("s2v_parkings:syncPlayerCars")
RegisterNetEvent("s2v_parkings:DeleteTakenVehicle")
RegisterNetEvent('s2v_parkings:AddMarkerPeopleInFloor')
RegisterNetEvent('s2v_parkings:SyncEnteredWithCarCl')
--Internal Events
RegisterNetEvent('s2v_parkings:InserCarInCache')
RegisterNetEvent('s2v_parkings:SpawnNoNetworkedCar')
--Borrado y Creación dinamica de parkings
RegisterNetEvent('s2v_parkings:getNewParking')
RegisterNetEvent('s2v_parkings:deleteNewParking')
RegisterNetEvent('s2v_parkings:parkingGiveAccess')

AddEventHandler('s2v_parkings:SyncEnteredWithCarCl',function(plate,parking,floor)
  --print("Me llega la info")
  --print(plate)
  --print(parking)   
  --print(floor)
  --print(CurrentParking)   print(CurrentFloor)
  if CurrentParking == parking and CurrentFloor == floor then
    --print("Estoy en la planta")
    --print(EnteredWithVehicle.vehicleplate .." -")
    --print(plate)
    EnteredWithVehicle.vehicleplate = ESX.Math.Trim(EnteredWithVehicle.vehicleplate)
    if EnteredWithVehicle.vehicleplate == plate then
      --print("La matricula es la mia")
      EnteredWithVehicle.vehicleplate = nil
      EnteredWithVehicle.value = false
    end
  end
end)

--Creacion de blips y markers de entrada

AddEventHandler('s2v_parkings:parkingGiveAccess',function(parking,value)
  if Config.garages[parking] then
    if Config.garages[parking].enter ~= value then --Si pasa es que ha habido un cambio en value y no es el mismo de antes
      Config.garages[parking].enter = value
      if Config.garages[parking].enter then ---Creo
        if Config.garages[parking].type == "public" then
          
          if not MapBlips[parking] then
            local blip = ESX.CreateBlip(Config.garages[parking].enterCoords,Config.garages[parking].blip,Config.garages[parking].blipColour,1.0,Config.garages[parking].label,GetCurrentResourceName())
            MapBlips[parking] = blip
          end
          
          if not EnterMarkers[parking] then
            local marker = ESX.Markers.Add(Config.enterMarker, Config.garages[parking].enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
            EnterMarkers[parking] = marker
          end
        elseif Config.garages[parking].type == ESX.GetPlayerData().job.name then
          if not PrivateBlips[parking] then
            local blip = ESX.CreateBlip(Config.garages[parking].enterCoords,Config.garages[parking].blip,Config.garages[parking].blipColour,1.0,Config.garages[parking].label,GetCurrentResourceName())
            PrivateBlips[parking] = blip
          end
          if not PrivateMarkers[parking] then
            local marker = ESX.Markers.Add(Config.enterMarker, Config.garages[parking].enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
            PrivateMarkers[parking] = marker
          end
        elseif Config.garages[parking].type =="private" and Config.garages[parking].source then
          if GetPlayerServerId(PlayerId()) == Config.garages[parking].source then
            
            --table.insert(PrivateBlips,blip)
            if not PrivateBlips[parking] then
              local blip = ESX.CreateBlip(Config.garages[parking].enterCoords,Config.garages[parking].blip,Config.garages[parking].blipColour,1.0,Config.garages[parking].label,GetCurrentResourceName())
              PrivateBlips[parking] = blip
            end
            
            --table.insert(PrivateMarkers,marker)
            if not PrivateMarkers[parking] then
              local marker = ESX.Markers.Add(Config.enterMarker, Config.garages[parking].enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
              PrivateMarkers[parking] = marker
            end
          end
        end
      else --Elimino
        if MapBlips[parking] then
          ESX.DeleteBlip(MapBlips[parking],GetCurrentResourceName())
        end
        if PrivateBlips[parking] then
          ESX.DeleteBlip(PrivateBlips[parking],GetCurrentResourceName())
        end
        if EnterMarkers[parking] then
          ESX.Markers.Remove(EnterMarkers[parking])
        end
        if PrivateMarkers[parking] then
          ESX.Markers.Remove(EnterMarkers[parking])
        end
      end
    end
  end
end)

AddEventHandler('s2v_parkings:getNewParking',function(parking,source)
  --Añadir a la tabla de la config el nuevo parking y despues inicializar ese parking
  --if not Config.garages[parking.name] then
    Config.garages[parking.name] = parking --Añadimos el parking a la config
    Config.garages[parking.name].enter = false
    --print(json.encode(Config.garages[parking.name]))
    --print(Config.garages[parking.name].source)
    if source ~= nil and GetPlayerServerId(PlayerId()) == source then
      Config.garages[parking.name].enter = true
      if parking.type == "public" then
        
        if not MapBlips[parking.name] then
          local blip = ESX.CreateBlip(parking.enterCoords,parking.blip,parking.blipColour,1.0,parking.label,GetCurrentResourceName())
          MapBlips[parking.name] = blip
        end
        
        if not EnterMarkers[parking.name] then
          local marker = ESX.Markers.Add(Config.enterMarker, parking.enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
          EnterMarkers[parking.name] = marker
        end
      elseif parking.type == ESX.GetPlayerData().job.name then
        
        if not PrivateBlips[parking.name] then
          local blip = ESX.CreateBlip(parking.enterCoords,parking.blip,parking.blipColour,1.0,parking.label,GetCurrentResourceName())
          PrivateBlips[parking.name] = blip
        end
        
        if not PrivateMarkers[parking.name] then
          local marker = ESX.Markers.Add(Config.enterMarker, parking.enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
          PrivateMarkers[parking.name] = marker
        end
      elseif parking.type =="private" and parking.source then
        --print("Entro a crear "..parking.source)
        if GetPlayerServerId(PlayerId()) == parking.source then
          
          --table.insert(PrivateBlips,blip)
          if not PrivateBlips[parking.name] then
            local blip = ESX.CreateBlip(parking.enterCoords,parking.blip,parking.blipColour,1.0,parking.label,GetCurrentResourceName())
            PrivateBlips[parking.name] = blip
          end
          
          --table.insert(PrivateMarkers,marker)
          if not PrivateMarkers[parking.name] then
            local marker = ESX.Markers.Add(Config.enterMarker, parking.enterCoords, Config.markerColour.r, Config.markerColour.g, Config.markerColour.b, Config.markerColour.a,15.0, true, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
            PrivateMarkers[parking.name] = marker
          end
        end
      end
    end
  --end
end)


AddEventHandler('s2v_parkings:deleteNewParking',function(parking)
  --Eliminamos toda la información relacionada con el y despues eliminamos los markers y demas
  if Config.garages[parking] then
    Config.garages[parking] = nil
    if MapBlips[parking] then
      ESX.DeleteBlip(MapBlips[parking],GetCurrentResourceName())
    end
    if PrivateBlips[parking] then
      ESX.DeleteBlip(PrivateBlips[parking],GetCurrentResourceName())
    end
    if EnterMarkers[parking] then
      ESX.Markers.Remove(EnterMarkers[parking])
    end
    if PrivateMarkers[parking] then
      ESX.Markers.Remove(EnterMarkers[parking])
    end
  end
end)

AddEventHandler('esx_keymapings:openMenu',function()
     MenusStates = nil
     if CurrentParking ~= nil then
      --print(CurrentParking)
       if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(0,0,-3)+GetOffsetFromEntityInWorldCoords(Shell,GetShellExitWalkingOffset().x,GetShellExitWalkingOffset().y,0),true) <= 2.5 then
        MenusStates = "walkingInteriorMenu"
       end
       if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(0,0,-2.5)+GetOffsetFromEntityInWorldCoords(Shell,GetShellExitDrivingOffset().x,GetShellExitDrivingOffset().y,0),true) <= 2.5 then
        MenusStates = "drivingInteriorMenu"
       end
       for k,v in pairs(GetShellSpawnCoords())do
          if GetParkingPlace(CurrentParking,CurrentFloor,v.id).state == false then
            --print("Entro a aparcar")
              if GetDistanceBetweenCoords(GetEntityCoords(GetVehiclePedIsIn(PlayerPedId(),false)),vector3(0,0,0.0)+GetOffsetFromEntityInWorldCoords(Shell,v.x,v.y,v.z),true) <= 2.0 then
                PlaceAux = v.id
                MenusStates = "parkingPosition"
                --print("Hola")
              end
          end
        end
        for k,v in pairs(SpawnedCars) do
          if v.owner and GetVehiclePedIsIn(PlayerPedId()) == v.car then
            PlaceAux = v.place
            MenusStates = "isInOwnCaR"
          end
        end
     else
       for k,v in pairs(Config.garages) do
         if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),v.enterCoords,true) <= 2.5 then
          if v.enter == true then
            if v.type == "public" then
              ParkingAux = k
              FloorsAux = v.floors
              MenusStates = "enterParking"
            elseif v.type == ESX.GetPlayerData().job.name then
              ParkingAux = k
              FloorsAux = v.floors
              MenusStates = "enterParking"
            elseif v.type == "private" then
              ParkingAux = k
              FloorsAux = v.floors
              MenusStates = "enterParking"
            end
          end
         end
       end
    end
    if MenusStates == "walkingInteriorMenu" then
      CreateInteriorMenu()
    elseif MenusStates == "drivingInteriorMenu" then
      CreateInteriorMenuDriving()
    elseif MenusStates == "parkingPosition" then
      ParkCar(CurrentFloor,CurrentParking,PlaceAux)
    elseif MenusStates == "enterParking" then
      CreateMenuEnter(ParkingAux,FloorsAux)
    elseif MenusStates == "isInOwnCaR" then
      TakeCar(CurrentFloor,CurrentParking,PlaceAux)
    end
end)
--Eventos para sincronizar la entrada y salida del parking en un mismo coche
AddEventHandler('s2v_parkings:enterParkingcl',function(currentParking,currentFloor)
  CurrentParking = currentParking
  CurrentFloor = currentFloor
  EnterParkingFloor()
end)
AddEventHandler('s2v_parkings:exitParkingcl',function()
  DoScreenFadeOut(1500)
  Wait(1500)
  DeleteParking()
  Wait(1000)
  DoScreenFadeIn(500)
end)

--Evento por si hay alguien dentro del parking donde se esta aparcando que le quite el marker y que le deje de aparecer la informacion
AddEventHandler('s2v_parkings:QuitMarkerPeopleInFloor',function(parking,floor,placeId)
  local _placeId = tonumber(placeId)
  local _floor = tonumber(floor)
  if CurrentFloor == _floor and CurrentParking == parking and CurrentParkingMarkers[_placeId] ~= nil then
    ESX.Markers.Remove(CurrentParkingMarkers[_placeId])
    CurrentParkingMarkers[_placeId] = nil
  end
end)

AddEventHandler('s2v_parkings:AddMarkerPeopleInFloor',function(parking,floor,placeId)
  local _placeId = tonumber(placeId)
  local _floor = tonumber(floor)
  if CurrentFloor == _floor and CurrentParking == parking and CurrentParkingMarkers[_placeId] == nil then
    --print("Poniendo markers")
    local mark = ESX.Markers.Add(Config.parkMarkerType,vector3(0,0,-3)+GetOffsetFromEntityInWorldCoords(Shell,GetShellSpawnCoords()[_placeId].x,GetShellSpawnCoords()[_placeId].y,0),Config.parkMarkerColour.r,Config.parkMarkerColour.g,Config.parkMarkerColour.b,Config.parkMarkerColour.a,20.0,false,vec(3, 5, 1), vec(0, 0, 0), vec(0, 0, 0), false, nil, nil)
    CurrentParkingMarkers[_placeId] = mark
  end
end)

AddEventHandler('s2v_parkings:SyncPlaces',function(cache)
  ParkingsCache = json.decode(cache)
end)

AddEventHandler('s2v_parkings:InserCarInCache',function(car,owner,place)
  local newCar = {
    car = car,
    owner = owner,
    place = place
  }
 table.insert(SpawnedCars,newCar)
end)

--Spawnear el vehiculo local que se acaba de dejar
AddEventHandler('s2v_parkings:SpawnNoNetworkedCar',function(properties,pos,heading,currentParking,currentFloor,place,source)
  if currentParking == CurrentParking and currentFloor == CurrentFloor then
    ESX.Game.SpawnLocalVehicle(properties.model, pos, heading,function(vehicle)
      ESX.Game.SetVehicleProperties(vehicle, properties)
      if GetPlayerServerId(PlayerId()) == source then
        TriggerEvent('s2v_parkings:InserCarInCache',vehicle,true,place)
      else
        TriggerEvent('s2v_parkings:InserCarInCache',vehicle,false,place)
        SetVehicleDoorsLocked(vehicle,2)
      end
      FreezeEntityPosition(vehicle,true)
    end)
  end
end)

AddEventHandler("s2v_parkings:syncPlayerCars",function(cars)
  PlayerCars = cars
  --print(json.encode(PlayerCars))
end)

AddEventHandler('s2v_parkings:TaskLeaveVehicleCl',function()
  TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),0)
end)

AddEventHandler("s2v_parkings:DeleteTakenVehicle",function(parking,floor,place)
  local _place = tonumber(place)
  local _floor = tonumber(floor)
  if CurrentParking == parking and CurrentFloor == _floor then
    for k,v in pairs(SpawnedCars) do
      if v.place == _place then
        ESX.Game.DeleteVehicle(SpawnedCars[k].car)
        SpawnedCars[k] = nil
      end
    end
  end 
end)
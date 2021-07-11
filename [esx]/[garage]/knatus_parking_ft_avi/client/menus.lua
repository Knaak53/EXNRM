function AllowCreateMenu() --Estoy dentro del vehiculo y soy conductor, estoy dentro pero no lo soy, estoy andando
  local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
  if vehicle > 0 then
    if GetPedInVehicleSeat(vehicle,-1) == PlayerPedId() then
      return true
    else
      return false
    end
  else
    return true
  end
end
---Menu de la entrada
function CreateMenuEnter(parking,floors)
  if not AllowCreateMenu() then return end
  ESX.UI.Menu.CloseAll()
  local elements = {}
  for i=1,floors,1 do
    table.insert(elements,{label = 'Planta '..i,value = i})
  end
  local data = {
    title = Config.garages[parking].label,
    align = 'centre',
    elements = elements
  }
  ESX.UI.Menu.Open('default',GetCurrentResourceName(),'enterParking',data,function(data,menu)
    if data.current.value ~= nil then 
      CurrentFloor = data.current.value
      CurrentParking = parking
      menu.close()
      local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
      if vehicle > 0 then
        local players = GetPlayersServerIdInVehicle(GetVehiclePedIsIn(PlayerPedId(),false))
        TriggerServerEvent('s2v_parkings:enterParking',CurrentParking,CurrentFloor,players)
      end
      EnterParkingFloor()
    end
  end,function(data,menu)
    menu.close()
  end)
end
  
---Menu desplegable cunado estas dentro del parking y te encuentras andando
function CreateInteriorMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {}
    for i=1,Config.garages[CurrentParking].floors,1 do
      if CurrentFloor ~= i then
        table.insert(elements,{label = 'Planta '..i,value = i})
      end
    end
    table.insert(elements,{label = 'Salir del garage',value = 'exit'})
    local data = {
      title = Config.garages[CurrentParking].label,
      align = 'centre',
      elements = elements
    }
    ESX.UI.Menu.Open('default',GetCurrentResourceName(),'enterParking',data,function(data,menu)
      if data.current.value ~= nil then 
        if data.current.value == 'exit' then
          menu.close()
          ExitWalkingGarage()
        else
          if GetVehiclePedIsIn(PlayerPedId(),false) == 0 then
            menu.close()
            CurrentFloor = data.current.value
            DeleteParkingFloor()
          else
            ESX.ShowNotification("No puedes salir con el coche por esta puerta", false, true, 6)
          end
        end
      end
    end,function(data,menu)
      menu.close()
    end)
  end

--Menu desplegable cuando estas dentro del parking y eres el conductor
  function CreateInteriorMenuDriving()
    if not AllowCreateMenu() then return end
    ESX.UI.Menu.CloseAll()
    local elements = {}
    for i=1,Config.garages[CurrentParking].floors,1 do
      if CurrentFloor ~= i then
        table.insert(elements,{label = 'Planta '..i,value = i})
      end
    end
    table.insert(elements,{label = 'Salir del garage',value = 'exit'})
    local data = {
      title = Config.garages[CurrentParking].label,
      align = 'centre',
      elements = elements
    }
    ESX.UI.Menu.Open('default',GetCurrentResourceName(),'enterParking',data,function(data,menu)
      if data.current.value ~= nil then 
        if data.current.value == 'exit' then
          menu.close()
          TriggerServerEvent('s2v_parkings:exitParking',GetPlayersServerIdInVehicle(GetVehiclePedIsIn(PlayerPedId(),false)))
          ExitDrivingGarage()
        else
          if GetVehiclePedIsIn(PlayerPedId(),false) ~= 0 then
            menu.close()
            CurrentFloor = data.current.value
            --
            local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
            if vehicle ~= 0 then
              local players = GetPlayersServerIdInVehicle(GetVehiclePedIsIn(PlayerPedId(),false))
              TriggerServerEvent('s2v_parkings:enterParking',CurrentParking,CurrentFloor,players)
            end
            DeleteParkingFloor()
          else
            ESX.ShowNotification("No puedes salir andando por aqui", false, true, 6)
          end
        end
      end
    end,function(data,menu)
      menu.close()
    end)
  end
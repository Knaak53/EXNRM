
ESX = nil
Markers = {}

Citizen.CreateThread(function() 
    Wait(50)
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Wait(1000)
    end

    while PlayerPedId() == nil do
        Wait(3000)
    end

    for k,v in pairs(Config.InsuranceCoords) do
        print("añadiendo")
        table.insert(Markers, {marker = ESX.Markers.Add(24, v.coords, 0,0,255,255, 50.0, true, vec(1,1,1), vec(0, 0, 0),vec(0, 0, 0), true), data = v})

        local blipCoord = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
    
        SetBlipSprite (blipCoord, 67)
        SetBlipDisplay(blipCoord, 4)
        SetBlipScale  (blipCoord, 1.0)
        SetBlipColour (blipCoord, 27)
        SetBlipAsShortRange(blipCoord, true)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Seguro de vehiculo")
        EndTextCommandSetBlipName(blipCoord)
    
    end
    
end)

local showingMenu = false
Citizen.CreateThread(function() 
    while true do
        Wait(1500)
        for k,v in pairs(Markers) do
            if ESX.Markers.In(v.marker) then
                if not showingMenu then
                    ESX.ShowHelpNotification("Pulsa ~INPUT_CONTEXT~ para ver tus vehiculos asegurados", false, true, 1500)
                end
            end
        end
    end
end)


RegisterNetEvent("caronte_insurance:warpToVehIfPending")
AddEventHandler("caronte_insurance:warpToVehIfPending",function(netveh)
  print("llega evento warp")
  if pendingOfWarping then
    Citizen.CreateThread(function() 
      --local veh = NetToVeh(netveh)
      
      while not DoesEntityExist(veh) do
        Wait(400)
        veh = NetToVeh(netveh)
        print(veh)
        print(netveh)
      end
      print(veh)
      print(netveh)
      TaskWarpPedIntoVehicle(PlayerPedId(),netveh,-1)--Me meto dentro
      pendingOfWarping = false
    end)
  else
    print("ERROR WARPING")
  end
end)

local markerIn = nil
AddEventHandler("esx_keymapings:openMenu", function() 
    for k,v in pairs(Markers) do
        if ESX.Markers.In(v.marker) then
            markerIn = v
            ESX.TriggerServerCallback("vehicleinsurance:getmyvehicles",function(myvehicles) 
                local elements = {}
                print(json.encode(myvehicles))
                for k,v in pairs(myvehicles) do
                    print(v.finded)
                    table.insert(elements, { label = GetDisplayNameFromVehicleModel(GetHashKey(v.model)), value = v.plate, finded = v.finded, coords = v.coords })
                end
                print(json.encode(elements))

               
                ESX.UI.Menu.Open('default',GetCurrentResourceName(), 'Vehicle_Insurance',
                {
                    title    = 'Vehiculos asegurados<br>500$',
                    align    = 'top-right',
                    elements = elements,
                }
                ,function(data,menu) 
                    if data.current.value then
                        if data.current.finded then
                            print("encontrado")
                        else
                            print("no encontrado")
                        end
                        if not data.current.finded then
                            ESX.TriggerServerCallback('vehicleinsurance:recoverPrice', function(price)
                                ESX.UI.Menu.Open('default',GetCurrentResourceName(), 'Vehicle_Insurance_Price',
                                {
                                    title    = 'Recuperar este vehiculo cuesta: '..price,
                                    align    = 'top-right',
                                    elements = {{label = "Aceptar", value = true}, {label = "Cancelar", value = false}},
                                }
                                , function(data3,menu3)
                                    if data3.current.value then
                                        recoverVehicle(data)
                                        menu3.close()
                                        menu.close()
                                    end
                                end,
                                function(data2,menu3) menu3.close() end)
                            end, data.current.value )
                            --recoverVehicle(data)

                        else
                            ESX.UI.Menu.Open('default',GetCurrentResourceName(), 'Vehicle_Insurance_Lost',
                            {
                                title    = 'Vehiculo encontrado, ¿Localizar?',
                                align    = 'top-right',
                                elements = {{label = "Sí", value = true}, {label = "No", value = false}},
                            }
                            , function(data2,menu2)
                                if data2.current.value then
                                    SetNewWaypoint(data.current.coords.x, data.current.coords.y)
                                    ESX.ShowNotification('Se ha localizado tu vehiculo')
                                    menu2.close()
                                    menu.close()
                                else
                                    ESX.TriggerServerCallback('vehicleinsurance:recoverPrice', function(price)
                                        ESX.UI.Menu.Open('default',GetCurrentResourceName(), 'Vehicle_Insurance_Price',
                                        {
                                            title    = 'Recuperar este vehiculo cuesta: '..price,
                                            align    = 'top-right',
                                            elements = {{label = "Aceptar", value = true}, {label = "Cancelar", value = false}},
                                        }
                                        , function(data3,menu3)
                                            if data3.current.value then
                                                recoverVehicle(data)
                                                menu3.close()
                                                menu.close()
                                            end
                                        end,
                                        function(data3,menu3) menu3.close() end)
                                    end, data.current.value )
                                    menu2.close()
                                    menu.close()
                                end
                            end,
                            function(data2,menu2) menu2.close() end)
                           
                        end
                    end
                end,
                function(data,menu) menu.close() 
                end)

            end)
        end
    end
end)

function recoverVehicle(data)
    pendingOfWarping = true
    ESX.TriggerServerCallback("vehicleinsurance:recoverVehicle",function(hasMoney) 
        if vehicle and hasMoney then
            print(json.encode(markerIn.data.spawnc))
            --ESX.Game.SpawnVehicle(vehicle.model,markerIn.data.spawnc,markerIn.data.spawnh,function(vehiclecb) --Lo espawneo neteorkeado
                --ESX.Game.SetVehicleProperties(vehiclecb,vehicle.props)
                --TaskWarpPedIntoVehicle(PlayerPedId(),vehiclecb,-1)--Me meto dentro
                --SetVehicleFuelLevel(vehiclecb, 100.0)
                --exports["LegacyFuel"]:SetFuel(vehiclecb,vehicle.fuel)
                --TriggerEvent('persistent-vehicles/register-vehicle', vehiclecb)
                menu.close()
            --end,true)
        elseif not hasMoney then
            ESX.ShowNotification('No tienes suficiente dinero (500$)')
        else

        end
    end, data.current.value)
end


--Delete vehicle wherever is it or who owns it
RegisterNetEvent('s2v_insurance/remove-vehicle')
AddEventHandler('s2v_insurance/remove-vehicle', function (netIds)
    for i=1, #netIds do
        DeleteEntity(NetToEnt(netIds[i]))
    end
end)
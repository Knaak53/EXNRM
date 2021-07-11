---Used comands for debugging
local AuxParking = nil
local VehicleProperties = nil
RegisterCommand("CreateHouse",function()
    local coords = GetEntityCoords(PlayerPedId(),true)
    ESX.Game.SpawnObject(GetHashKey('shell_garagel'),coords+vector3(0,0,0),function(object)
        FreezeEntityPosition(object,true)
        AuxParking = object
        local coords = GetOffsetFromEntityInWorldCoords(
        object --[[ Entity ]],
        0.0 --[[ number ]],
        0.0 --[[ number ]],
        4 --[[ number ]]
        )
        --ESX.Game.SpawnVehicle("zentorno",coords,0,function()end,true)
        -- for k,v in pairs(Config.GarageSpawns) do
        --     print("x:"..v.x.." y:"..v.y.." z:"..v.z)
        --     ESX.Game.SpawnVehicle("zentorno",GetOffsetFromEntityInWorldCoords(AuxParking,v.x,v.y,0.5),0,function()end,true)
        -- end
    end,false,true)
end,false)

RegisterCommand("tpCenter",function()
    SetEntityCoords(PlayerPedId(),GetOffsetFromEntityInWorldCoords(AuxParking,0.0,0.0,0.2),0,0,0,false)
end,false)

RegisterCommand("CleanAll",function()
    DeleteObject(AuxParking)
end)


RegisterCommand("OffsetParking",function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('WriteCoords',coords-GetOffsetFromEntityInWorldCoords(AuxParking,0.0,0.0,1))
end)
RegisterCommand("OffsetParkingCar",function()
    local coords = GetEntityCoords(GetVehiclePedIsIn(PlayerPedId()))
    TriggerServerEvent('WriteCoords',coords-GetOffsetFromEntityInWorldCoords(AuxParking,0.0,0.0,1))
end)

RegisterCommand("tp",function(player,args)
    --SetEntityCoords(PlayerPedId(), args[1], args[2], args[3],0, 0, 0, false)
    SetEntityCoords(PlayerPedId(),tonumber(args[1]),tonumber(args[2]),tonumber(args[3]),0, 0, 0, false)
end,false)

function GetPlayersInVehicle(vehicle)
    local players = {}
    local seats = GetVehicleMaxNumberOfPassengers(vehicle)
    for i=-1,seats-1,1 do
      for _, player in pairs(GetActivePlayers()) do
        if GetPlayerPed(player) == GetPedInVehicleSeat(vehicle,i) then
          table.insert(players,GetPlayerServerId(player))
        end
      end
    end
    for k,v in pairs(players) do
      --print(v)
    end
end

RegisterCommand("GetPlayers",function()
    for _, player in pairs(GetActivePlayers()) do
        local ped = GetPlayerServerId(player)
        --print(ped)
        -- do stuff
    end
end)

RegisterCommand("GetSeats",function()
    GetPlayersInVehicle(GetVehiclePedIsIn(PlayerPedId(),false))
end)

RegisterCommand("GetVehicleProperties",function()
    --print(json.encode(ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))))
    VehicleProperties = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
end)

RegisterCommand("SetVehicleProperties",function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    ESX.Game.SetVehicleProperties(vehicle,VehicleProperties)
end)

RegisterCommand("GetPedsInVehicle",function()
    for k,v in pairs(GetPlayersPedInVehicle(GetVehiclePedIsIn(PlayerPedId()))) do
        --print(v)
    end
end)

RegisterCommand("ParkNetCar",function()
    ParkNetworkedCar(GetVehiclePedIsIn(PlayerPedId()))
end)

RegisterCommand("EntityExists",function()
    if DoesEntityExist(Shell) then
        --print("Sigue existiendo no se ha borrado")
    end
end)
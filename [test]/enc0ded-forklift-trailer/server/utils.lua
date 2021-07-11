ESX = exports.extendedmode:getSharedObject()
ExM = exports.extendedmode:getExtendedModeObject()

ESX.RegisterServerCallback('setUpForkLiftVehicle', function(source,cb, modelName, coords) 
    CreateThread(function() 
        print("Modelname :"..modelName)
        print("coords :"..vector3(coords.x, coords.y,coords.z))
        local veh = ExM.Game.SpawnVehicle(modelName, vector3(coords.x, coords.y,coords.z))
        while not DoesEntityExist(veh) do
            Wait(500)
        end
        print("Vehicle ID: "..NetworkGetNetworkIdFromEntity(veh))
        cb(NetworkGetNetworkIdFromEntity(veh))
    end)
end)

RegisterServerEvent("Pallet:initate")
AddEventHandler("Pallet:initate", function(netPallet) 
    TriggerClientEvent("Pallet:initate", NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(netPallet)), netPallet)
end)
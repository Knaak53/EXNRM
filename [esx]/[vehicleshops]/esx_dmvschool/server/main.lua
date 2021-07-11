ESX = nil
ExM = exports.extendedmode:getExtendedModeObject()
ESX = exports.extendedmode:getSharedObject()

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('esx_license:addLicense', _source, type, function()
		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('esx_dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('esx_dmvschool:pay')
AddEventHandler('esx_dmvschool:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', ESX.Math.GroupDigits(price)))
end)

RegisterNetEvent("esx_dmvschool:startDriveTest")
AddEventHandler("esx_dmvschool:startDriveTest", function(testType)	
	print(Config.Zones.VehicleSpawnPoint.Pos)
	local veh = ExM.Game.SpawnVehicle(Config.VehicleModels[testType], Config.Zones.VehicleSpawnPoint.Pos)
    while not DoesEntityExist(veh) do
        Wait(50)
    end
    SetEntityHeading(veh, Config.Zones.VehicleSpawnPoint.heading)
    TriggerClientEvent("esx_dmvschool:startDriveTestClient", source, NetworkGetNetworkIdFromEntity(veh), testType)
end)

RegisterNetEvent("esx_dmvschool:stopDriveTest")
AddEventHandler("esx_dmvschool:stopDriveTest", function(netVeh)
	local _source = source
    local vehicle = NetworkGetEntityFromNetworkId(netVeh)
    print(vehicle)
    DeleteEntity(vehicle)
end)
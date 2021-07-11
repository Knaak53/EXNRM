ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports.extendedmode:getSharedObject()
        Citizen.Wait(0)
    end
end)

local canRentBike = true
local rentedBikeEntity = 0
local rentedBikePrice = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local found = false
        for k in pairs(Config.MarkerZones) do
        	if #(GetEntityCoords(playerPed) - vector3(Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)) < 20.0 then
	            DrawMarker(38, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z + 2, 0, 0, 0, 0, 0, 0, Config.MarkerScale.x, Config.MarkerScale.y, Config.MarkerScale.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, 0, 1, 0, 0)
	        	found = true
	        end    	
		end
		if not found then
			Citizen.Wait(1000)
		end
    end
end)

RegisterNetEvent("esx_bike_rental:openRentalMenu")
AddEventHandler("esx_bike_rental:openRentalMenu", function()
	Citizen.Wait(150)
	if canRentBike and not playerHasBikeToReturn() then
		SendNUIMessage(
	        {
	            action = "open",
	            shopItems = Config.bikes
	        }
	    )
	    SetNuiFocus(true, true)
	else	
		if playerHasBikeToReturn() then
			TriggerServerEvent("esx_bike_rental:returnBike", VehToNet(rentedBikeEntity), GetEntityModel(rentedBikeEntity))
			rentedBikeEntity = 0
			canRentBike = true
		else
			ESX.ShowNotification("Solo puedes alquilar una bicicleta cada 45 minutos, devuelve la que has alquilado o espera...")
		end
	end
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("rentBike", function(data, cb)
    SetNuiFocus(false, false)   
    local spawnPoint = getCurrentBikeRentalPlace()
    print(json.encode(spawnPoint))
    TriggerServerEvent("esx_bike_rental:payRental", data.bike.name, spawnPoint)
end)

RegisterNetEvent("esx_bike_rental:warpPedInBike")
AddEventHandler("esx_bike_rental:warpPedInBike", function(netVeh)
	local vehicle = NetToVeh(netVeh)
	local playerPed = PlayerPedId()
	print(netveh, "hola")
	while not DoesEntityExist(vehicle) do 
		vehicle = NetToVeh(netVeh)
		Citizen.Wait(100) 
	end
	rentedBikeEntity = vehicle
	TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	startRentalTimer()
end)

function playerHasBikeToReturn()
	local rentalplace = getCurrentBikeRentalPlace()
	return #(rentalplace.coords - GetEntityCoords(rentedBikeEntity)) < 8
end

function startRentalTimer()
	Citizen.CreateThread(function()
		canRentBike = false
		Citizen.Wait(60000 * 45)
		canRentBike = true
	end)
end

function getCurrentBikeRentalPlace()
	pedCoords = GetEntityCoords(PlayerPedId())
	for i = 1, #Config.MarkerZones do
		if #(pedCoords - vector3(Config.MarkerZones[i].x, Config.MarkerZones[i].y, Config.MarkerZones[i].z)) < 6 then
			return Config.MarkerZones[i].spawnPoint
		end
	end
end



--------------------------------------------------------------------------------------

								--PED GENERATION--

--------------------------------------------------------------------------------------

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteCharacters()
	end
end)

local pedEntities = {}
local objects = {}

DeleteCharacters = function()
    for i=1, #pedEntities do
        local char = pedEntities[i]
        if DoesEntityExist(char) then
            DeletePed(char)
            SetPedAsNoLongerNeeded(char)
        end
    end
    for i=1, #objects do
        local object = objects[i]
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
    end
end

Citizen.CreateThread(function()	
	for _, info in pairs(Config.BlipZones) do
		local blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(blip, 376)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 3)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Alquiler de Bicicletas")
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #Config.MarkerZones do
        hash = GetHashKey('u_m_m_bikehire_01')
        RequestModel(hash)
        while not HasModelLoaded(hash) do
			Citizen.Wait(10)
		end
        if not DoesEntityExist(pedEntities[i]) then
            pedEntities[i] = CreatePed(4, hash, Config.MarkerZones[i].x, Config.MarkerZones[i].y, Config.MarkerZones[i].z, Config.MarkerZones[i].heading)
            SetEntityAsMissionEntity(pedEntities[i])
            SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
            FreezeEntityPosition(pedEntities[i], true)
            SetEntityInvincible(pedEntities[i], true)
        end
        SetModelAsNoLongerNeeded(hash)
        for k, v in pairs(Config.MarkerZones[i].structure) do
        	RequestModel(v.model)
        	while not HasModelLoaded(v.model) do Citizen.Wait(50) end
    		local currentObject = CreateObject(GetHashKey(v.model), v.coords.x, v.coords.y, v.coords.z, 0, 0, 0)
    		table.insert(objects, currentObject)
    		SetEntityHeading(currentObject, v.heading)
    		SetBlockingOfNonTemporaryEvents(currentObject, true)
    		FreezeEntityPosition(currentObject, true)
    		SetModelAsNoLongerNeeded(v.model)
        end
    end

end)

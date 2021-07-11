ESX = nil
local myJob = "unemployed"
local farmActive = false
local fase1 = false
local fase2 = false
local narcosEntities = {}
local lider = false
local participant = false
local blips = {}

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
	SetEntityInvincible(PlayerPedId(), true)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    myJob = playerData.job.name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
     myJob = job.name
end)

function gotoCoords(coords, running)
	local speed
	if running then speed = 2.0 else speed = 1.0 end
	TaskGoToCoordAnyMeans(
		PlayerPedId() --[[ Ped ]], 
		coords.x --[[ number ]], 
		coords.y --[[ number ]], 
		coords.z --[[ number ]], 
		speed --[[ number ]], 
		0 --[[ Any ]], 
		0 --[[ boolean ]], 
		786603 --[[ integer ]], 
		0 --[[ number ]]
	)
end

local pointToWalk = vector3(3856.66, 4458.19, 1.85)
local narcos = {
 	{coords = vector3(3864.97, 4445.16, 1.25), heading = 22.07, model = "ig_ortega", animation = ""}
 }
 local narcoBoat = vector3(3866.54, 4445.0, 1.85)
 local vehicle = nil
 local bricksEntity = 0
 local narcoBoatEntity = 0

RegisterNetEvent('esx_coke:tryFarmCoke')
AddEventHandler('esx_coke:tryFarmCoke', function()
	if canTakeCoke() then
		if farmActive and not participant then
			participant = true
			createBlipsForParticipants()
			ESX.ShowNotification("~r~Has pasado a formar parte del asalto a los narcos!")
		elseif not farmActive then
			ESX.TriggerServerCallback('vSync:getTime', function(hour)
				ESX.TriggerServerCallback('esx_coke:canTakeCoke', function(cokeInfo)
					SendNUIMessage(
				        {
							action = "openMenu",
							isOverNight = hour >= 21 or hour <= 6,
							canTakeCoke = cokeInfo.canTakeCoke,
							haveCard = cokeInfo.haveCard
				        }
					)
					SetNuiFocus(true, true)
				end)
			end)
		end		
	end
end)

function canTakeCoke()
	return myJob ~= "police" and
			myJob ~= "offpolice" and
			myJob ~= "ambulance" and
			myJob ~= "mechanic" and
			myJob ~= "taxi" and
			myJob ~= "cardealer"
end

RegisterNetEvent('esx_coke:takeBricksFromBoat')
AddEventHandler('esx_coke:takeBricksFromBoat', function()
	if canTakeCoke() then
		TriggerServerEvent("esx_coke:takeBricksFromBoat")
	end
end)

RegisterNetEvent('esx_coke:startChangeBricksBetweenBoats')
AddEventHandler('esx_coke:startChangeBricksBetweenBoats', function()
	if #(GetEntityCoords(vehicle) - GetEntityCoords(narcoBoatEntity)) < 4 then
		local playerPed = PlayerPedId()
		makeEntityFaceEntity(playerPed, weedEntity)
	    RequestAnimDict("anim@amb@business@cfm@cfm_machine_oversee@")
	 	while (not HasAnimDictLoaded("anim@amb@business@cfm@cfm_machine_oversee@")) do Citizen.Wait(0) end
		TaskPlayAnim(playerPed, "anim@amb@business@cfm@cfm_machine_oversee@", "look_scared_operator", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		Citizen.Wait(4000)
		ClearPedTasksImmediately(playerPed)
		TriggerServerEvent("esx_coke:bricksBoatChanged")
		DetachEntity(bricksEntity, false, false)
		AttachEntityToEntity(bricksEntity, vehicle, 0, 0.0, 1.5, 0.35, 7.0, 0.0, 0.0, 1, 1, 1, 1, 0, 1) 
	else
		ESX.ShowNotification("~r~Tu vehiculo está demasiado lejos de la narcolancha!")
	end
end)

function makeEntityFaceEntity( entity1, entity2 )
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

RegisterNetEvent('esx_coke:startReturnToBase')
AddEventHandler('esx_coke:startReturnToBase', function()
	fase1 = false
	fase2 = true
	if participant then
		for k,v in pairs(blips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end
		blips = {}
		ESX.ShowNotification("~y~Devuelve la narcolancha al puerto!")
		blip = AddBlipForCoord(Config.port.x, Config.port.y, Config.port.z)
		SetBlipSprite(blip, 404)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Puerto de San Chianski")
		EndTextCommandSetBlipName(blip)
		table.insert(blips, blip)
	end
end)

RegisterNetEvent('esx_coke:walk_to_boat')
AddEventHandler('esx_coke:walk_to_boat', function(netVehicle)
	local playerPed = PlayerPedId()
	local vehicle = NetToVeh(netVehicle)
	while not DoesEntityExist(vehicle) do
		Citizen.Wait(100)
	end
	gotoCoords(pointToWalk, false)
	while #(GetEntityCoords(playerPed) - pointToWalk) > 1.0 do Citizen.Wait(500) end
	TaskEnterVehicle(playerPed, vehicle, 20000, -1, 1.0, 2, 0)
end)

RegisterNetEvent("esx_coke:attachBricksToBoat")
AddEventHandler("esx_coke:attachBricksToBoat", function(netBricks, netBoat)
	local bricks = NetToObj(netBricks)
	local boat = NetToVeh(netBoat)
	while not DoesEntityExist(bricks) or not DoesEntityExist(boat) do
		Citizen.Wait(100)
	end
	AttachEntityToEntity(bricks, boat, 0, 0.0, 1.5, 0.35, 7.0, 0.0, 0.0, 1, 1, 1, 1, 0, 1) 
end)

RegisterNetEvent("esx_coke:set_boat_anchor")
AddEventHandler("esx_coke:set_boat_anchor", function(netBoat)
	local boat = NetToVeh(netBoat)
	while not DoesEntityExist(boat) do
		Citizen.Wait(100)
	end
	FreezeEntityPosition(boat, true)
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("startCokeFarm", function(data, cb)
    SetNuiFocus(false, false) 
    lider = true
    participant = true
    TriggerServerEvent('esx_coke:startCokeFarm')
    --spawnVehicle()
    --spawnNarcos()
    --[[Citizen.CreateThread(function()
		RequestModel(Config.bricks.model)
		while not HasModelLoaded(Config.bricks.model) do Citizen.Wait(50) end
		bricksEntity = CreateObject(GetHashKey(Config.bricks.model), Config.bricks.coords.x, Config.bricks.coords.y, Config.bricks.coords.z, 1, 0, 0)
		SetEntityHeading(bricksEntity, Config.bricks.heading)
		SetBlockingOfNonTemporaryEvents(bricksEntity, true)	
		SetModelAsNoLongerNeeded(Config.bricks.model)
		AttachEntityToEntity(bricksEntity, narcoBoatEntity, 0, 0.0, 1.5, 0.35, 7.0, 0.0, 0.0, 1, 1, 1, 1, 0, 1) 
	end)]]--
	createBlipsForParticipants()
end)

function createBlipsForParticipants()
	for i = 1, #Config.narcoSpawns do
		blip = AddBlipForCoord(Config.narcoSpawns[i].x, Config.narcoSpawns[i].y, Config.narcoSpawns[i].z)
		SetBlipSprite(blip, 66)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("(?) Reunion de narcos")
		EndTextCommandSetBlipName(blip)
		table.insert(blips, blip)
	end
end

RegisterNUICallback("errorMessage", function(data, cb)
    ESX.ShowNotification(data.message)
end)

function spawnVehicle()
	ESX.Game.SpawnVehicle(Config.vehicle.model, {
		x = Config.vehicle.spawnPoint.x,
		y = Config.vehicle.spawnPoint.y,
		z = Config.vehicle.spawnPoint.z + 1.5											
		},Config.vehicle.heading, function(callback_vehicle)
			vehicle = callback_vehicle		
			gotoCoords(pointToWalk, false)
			while #(GetEntityCoords(PlayerPedId()) - pointToWalk) > 1.0 do Citizen.Wait(500) end
			TaskEnterVehicle(PlayerPedId(), callback_vehicle, 20000, -1, 1.0, 2, 0)
	end, true)
end

function spawnNarcoBoat()
	ESX.Game.SpawnVehicle("dinghy2", {
		x = narcoBoat.x ,
		y = narcoBoat.y,
		z = narcoBoat.z											
		},Config.vehicle.heading, function(callback_vehicle)
			narcoBoatEntity = callback_vehicle	
			Citizen.Wait(5000)
	end, true)
end

function spawnNarcos()
	spawnNarcoBoat()
	Citizen.Wait(2000)
	for i = 1, #narcos do
		Citizen.CreateThread(function()
	        hash = GetHashKey(narcos[i].model)
	        RequestModel(hash)
	        while not HasModelLoaded(hash) do
				Citizen.Wait(10)
			end
	        if not DoesEntityExist(narcosEntities[i]) then
	            narcosEntities[i] = CreatePed(22, hash, narcos[i].coords.x, narcos[i].coords.y, narcos[i].coords.z, narcos[i].heading, true, false)
	            SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(narcosEntities[i]), true)
	  			SetPedAccuracy(narcosEntities[i], 66)
	            GiveWeaponToPed(narcosEntities[i], GetHashKey('WEAPON_ASSAULTRIFLE'), 200, false, true)
	        	SetPedCombatAttributes(narcosEntities[i], 292, true)
	        	SetPedFleeAttributes(narcosEntities[i], 0, 0)
			  	SetPedAsEnemy(narcosEntities[i],true)
			  	SetPedSeeingRange(narcosEntities[i], 50.0)
			  	SetPedMaxHealth(narcosEntities[i], 900)
			  	SetPedAlertness(narcosEntities[i], 3)
			  	SetPedCombatRange(narcosEntities[i], 0)
			  	SetPedConfigFlag(narcosEntities[i], 224, true)
			  	SetPedCombatMovement(narcosEntities[i], 2)
				SetRelationshipBetweenGroups(5, GetHashKey(narcos[i].model), GetHashKey("PLAYER")) 
				SetPedRelationshipGroupHash(narcosEntities[i], GetHashKey("HATES_PLAYER"))
	        end
	    end)
    end
end


RegisterNetEvent('esx_coke:startCokeFarmClient')
AddEventHandler('esx_coke:startCokeFarmClient', function(netBricks)
	fase1 = true
	local bricks = NetToObj(netBricks)
	while not DoesEntityExist(bricks) do
		Citizen.Wait(100)
	end
	Citizen.CreateThread(function()
		if canTakeCoke() then
			farmActive = true
			local playerPed = PlayerPedId()
			while fase1 do
				Citizen.Wait(0)
				local attachedBricksCoords = GetEntityCoords(bricks)
				if #(GetEntityCoords(playerPed) - attachedBricksCoords) < 50 then
					DrawMarker(20, attachedBricksCoords.x, attachedBricksCoords.y, attachedBricksCoords.z + 0.5, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, false)
				else
					Citizen.Wait(2000)
				end
			end
		end
	end)
end)

--------------------------------------------------------------------------------------

								--Ped Generation--

--------------------------------------------------------------------------------------
local peds = {
 	{coords = vector3(3855.91, 4462.05, 0.74), heading = 181.07, model = "ig_ortega", animation = "WORLD_HUMAN_SEAT_WALL"}
 }

local pedEntities = {}

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteCharacters()
	end
end)

DeleteCharacters = function()
	DeleteEntity(bricksEntity)
    for i=1, #pedEntities do
        local char = pedEntities[i]
        if DoesEntityExist(char) then
            DeletePed(char)
            SetPedAsNoLongerNeeded(char)
        end
    end
end

Citizen.CreateThread(function()
	for i = 1, #peds do
        hash = GetHashKey(peds[i].model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
			Citizen.Wait(10)
		end
        if not DoesEntityExist(pedEntities[i]) then
            pedEntities[i] = CreatePed(4, hash, peds[i].coords.x, peds[i].coords.y, peds[i].coords.z, peds[i].heading)
            SetEntityAsMissionEntity(pedEntities[i])
            SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
            FreezeEntityPosition(pedEntities[i], true)
            SetEntityInvincible(pedEntities[i], true)
            TaskStartScenarioInPlace(pedEntities[i], peds[i].animation, 0, true)
        end
    end
    SetModelAsNoLongerNeeded(hash)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if #(GetEntityCoords(PlayerPedId()) - peds[1].coords) < 20.0 then
			DrawMarker(20, peds[1].coords.x, peds[1].coords.y -0.3, peds[1].coords.z + 2.1, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.3, 0.3, 0.3, 255, 50, 0, 100, false, true, 2, true, false, false, false)
		else
			Citizen.Wait(2000)	
		end			
	end
end)
ESX = nil

local weedEntity = 0
local weedSpawned = true
local farmActive = false
local isFarmLider = false
local plantsEntities = {}
local bucketEntity = 0
local fullBucketsEntities = {}
local handlingWeed = false
local currentWeedBranchEntity = 0
local umbspawned = 0
local netid = 0
local farmerEntity = 0
local processActive = false
local bricksEntity = 0
local bricksEntities = {}
local pedEntities = {}
local workbench = 0
local pallet = 0
local processing = false
local myJob = "unemployed"
local peds = {
 	{coords = vector3(1040.34, -3207.1, -39.06), heading = 342.73, model = "cs_wade", animation = "WORLD_HUMAN_DRUG_DEALER_HARD"}
 }
local takingWeedPublic = false


Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    myJob = playerData.job.name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
     myJob = job.name
end)

--------------------------------------------------------------------------------------

								--Weed spawn control--

--------------------------------------------------------------------------------------

RegisterNetEvent('esx_weed:spawnWeed')
AddEventHandler('esx_weed:spawnWeed', function()
	spawnWeed()
end)

RegisterNetEvent('esx_weed:despawnWeed')
AddEventHandler('esx_weed:despawnWeed', function()
	if DoesEntityExist(weedEntity) then
		DeleteEntity(weedEntity)
	end
	weedSpawned = false
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.TriggerServerCallback('esx_weed:get_weed_info', function(weedInfo)
    	print(json.encode(weedInfo))
		if weedInfo.lastHarvest > weedInfo.respawnTime then
			spawnWeed()
		end
	end)
end)

RegisterNetEvent('esx_weed:takeWeed')
AddEventHandler('esx_weed:takeWeed', function(entityCoords, job)
	if not takingWeedPublic then
		if canTakeWeed(job) and #(Config.weed.object.coords - entityCoords) < 3.0 then
			takeWeed()
		end	
	else
		ESX.ShowNotification("~r~Ya estas recogiendo fardos!")
	end
end)

function canTakeWeed(job)
	return job ~= 'police' and
			job ~= 'offpolice' and
			job ~= 'mechanic' and
			job ~= 'ambulance' and
			job ~= 'offambulance' and
			job ~= 'cardealer' and
			job ~= 'taxi'
end

function takeWeed()
	Citizen.CreateThread(function()
		takingWeedPublic = true
		local playerPed = PlayerPedId()
		makeEntityFaceEntity(playerPed, weedEntity)
	    RequestAnimDict("anim@amb@business@cfm@cfm_machine_oversee@")
	 	while (not HasAnimDictLoaded("anim@amb@business@cfm@cfm_machine_oversee@")) do Citizen.Wait(0) end
		TaskPlayAnim(playerPed, "anim@amb@business@cfm@cfm_machine_oversee@", "look_scared_operator", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		Citizen.Wait(4000)
		TriggerServerEvent('esx_weed:takeWeed')
		ClearPedTasksImmediately(playerPed)
		takingWeedPublic = false
	end)
end

function makeEntityFaceEntity( entity1, entity2 )
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

--------------------------------------------------------------------------------------

								--Weed process--

--------------------------------------------------------------------------------------

RegisterNetEvent('esx_weed:processWeed')
AddEventHandler('esx_weed:processWeed', function(entityCoords, job)
	if canTakeWeed(job) then
		local playerPed = PlayerPedId()
		makeEntityFaceEntity(playerPed, weedEntity)
	    RequestAnimDict("anim@amb@business@cfm@cfm_machine_oversee@")
	 	while (not HasAnimDictLoaded("anim@amb@business@cfm@cfm_machine_oversee@")) do Citizen.Wait(0) end
		TaskPlayAnim(playerPed, "anim@amb@business@cfm@cfm_machine_oversee@", "look_scared_operator", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		Citizen.Wait(4000)
		TriggerServerEvent('esx_weed:processWeed')
		ClearPedTasksImmediately(playerPed)
	end	
end)

--------------------------------------------------------------------------------------

								--Weed Lab--

--------------------------------------------------------------------------------------


RegisterNetEvent('esx_weed:weedFarmMenu')
AddEventHandler('esx_weed:weedFarmMenu', function(job)
	if canTakeWeed(job) then
		ESX.TriggerServerCallback('esx_weed:canTakeWeedLab', function(weedLabInfo)
			SendNUIMessage(
		        {
					action = "openMenu",
					canTakeWeed = weedLabInfo.canTakeWeed,
					haveCard = weedLabInfo.haveCard
		        }
			)
			SetNuiFocus(true, true)
		end)
	end	
end)

RegisterNetEvent('esx_weed:startLabFarmClient')
AddEventHandler('esx_weed:startLabFarmClient', function(selectedPlants)
	farmActive = true
	if canTakeWeed(myJob) then
		Citizen.CreateThread(function()
			setSelectedPlantsEntities(selectedPlants)
			RequestModel(Config.bucket.model)
			while not HasModelLoaded(Config.bucket.model) do Citizen.Wait(50) end
			bucketEntity = CreateObject(GetHashKey(Config.bucket.model), Config.bucket.coords.x, Config.bucket.coords.y, Config.bucket.coords.z, 0, 0, 0)
			SetEntityHeading(bucketEntity, Config.bucket.heading)
			SetBlockingOfNonTemporaryEvents(bucketEntity, true)
			FreezeEntityPosition(bucketEntity, true)
			SetModelAsNoLongerNeeded(Config.bucket.model)
		
			if not DoesEntityExist(farmerEntity) then
				local hash = GetHashKey(Config.farmer.model)
		        RequestModel(hash)
		        while not HasModelLoaded(hash) do
					Citizen.Wait(10)
				end
	            farmerEntity = CreatePed(4, hash, Config.farmer.coords.x, Config.farmer.coords.y, Config.farmer.coords.z, Config.farmer.heading)
	            SetEntityAsMissionEntity(farmerEntity)
	            SetBlockingOfNonTemporaryEvents(farmerEntity, true)
	            FreezeEntityPosition(farmerEntity, true)
	            SetEntityInvincible(farmerEntity, true)
	            --TaskStartScenarioInPlace(farmerEntity, Config.farmer.animation, 0, true)
	            SetModelAsNoLongerNeeded(hash)
	        end
	        
			while farmActive do
				Citizen.Wait(0)
				if #(GetEntityCoords(PlayerPedId()) - peds[1].coords) < 50 then
					DrawMarker(20, Config.farmer.coords.x, Config.farmer.coords.y, Config.farmer.coords.z + 2, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 100, false, true, 2, true, false, false, false)
					for i = 1, #plantsEntities do
						DrawMarker(20, plantsEntities[i].coords.x, plantsEntities[i].coords.y, plantsEntities[i].coords.z + 3, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.4, 0.4, 0.4, 0, 255, 0, 100, false, true, 2, true, false, false, false)
					end
				else
					Citizen.Wait(2000)
				end
			end
		end)
	end	
end)

RegisterNetEvent('esx_weed:takeGreenWeedFromLab')
AddEventHandler('esx_weed:takeGreenWeedFromLab', function(entity, job)
	if canTakeWeed(job) and farmActive then
		local plantId = getPlantIdFromEntity(entity)
		if plantId then
			TriggerServerEvent('esx_weed:removePlantFromLab', plantId)
			local playerPed = PlayerPedId()
			makeEntityFaceEntity(playerPed, entity)
		    RequestAnimDict("anim@amb@business@cfm@cfm_machine_oversee@")
		 	while (not HasAnimDictLoaded("anim@amb@business@cfm@cfm_machine_oversee@")) do Citizen.Wait(0) end
			TaskPlayAnim(playerPed, "anim@amb@business@cfm@cfm_machine_oversee@", "look_scared_operator", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Citizen.Wait(4000)
			handlingWeed = true
			putWeedInPlayerHand()
			ClearPedTasksImmediately(playerPed)	
		end
	end	
end)

RegisterNetEvent('esx_weed:takeBlockFromPallet')
AddEventHandler('esx_weed:takeBlockFromPallet', function(entity, job)
	if canTakeWeed(job) then
		local brickId = getBrickIdFromEntity(entity)
		if brickId then
			TriggerServerEvent("esx_weed:takeBlockFromPallet", brickId)
		end
	end	
end)

RegisterNetEvent("esx_weed:removeBlockFromPallet")
AddEventHandler('esx_weed:removeBlockFromPallet', function(blockId)
	if canTakeWeed(job) then
		local entityId = getBrickEntityFromId(blockId)
		if DoesEntityExist(entityId) then
			DeleteEntity(entityId)
		end
	end	
end)

function getBrickEntityFromId(blockId)
	for i = 1, #bricksEntities do
		if blockId == bricksEntities[i].id then
			return bricksEntities[i].entity
		end
	end
	return nil
end

function getBrickIdFromEntity(entity)
	for i = 1, #bricksEntities do
		if entity == bricksEntities[i].entity then
			return bricksEntities[i].id
		end
	end
	return nil
end

function putWeedInPlayerHand()
	local playerPed = PlayerPedId()
	local weed_branch = 3989082015
	local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)
	umbspawned = CreateObject(weed_branch, plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	netid = ObjToNet(umbspawned)
    while not HasModelLoaded(weed_branch) do Citizen.Wait(50) end
    AttachEntityToEntity(umbspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),0.0,0.0,0.0,0.0,0.0,0.0,1,1,0,1,0,1)
end

RegisterNetEvent('esx_weed:putWeedInCase')
AddEventHandler('esx_weed:putWeedInCase', function(job)
	if canTakeWeed(job) and farmActive then
		if handlingWeed then
			DetachEntity(NetToObj(netid), 1, 1)
			DeleteEntity(NetToObj(netid))	    
			DeleteEntity(umbspawned)
			TriggerServerEvent('esx_weed:putWeedInCase')
		else
			ESX.ShowNotification("Para meter ~g~MARIHUANA~w~ en la caja, primero debes recogerla!")
		end	
	end	
end)

RegisterNetEvent('esx_weed:finishFarmPhase')
AddEventHandler('esx_weed:finishFarmPhase', function(job)
	farmActive = false
	if DoesEntityExist(farmerEntity) then
        DeleteEntity(farmerEntity)
    end
    processActive = true
    if canTakeWeed(ESX.PlayerData.job.name) then
		Citizen.CreateThread(function()
			while processActive do
				Citizen.Wait(0)
				if #(GetEntityCoords(PlayerPedId()) - peds[1].coords) < 50 then
					DrawMarker(20, Config.workbench.coords.x, Config.workbench.coords.y, Config.workbench.coords.z + 1.5, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 100, false, true, 2, true, false, false, false)
				else
					Citizen.Wait(2000)
				end
			end
		end)
	end	
end)

RegisterNetEvent('esx_weed:useWorkBench')
AddEventHandler('esx_weed:useWorkBench', function(job)
    if canTakeWeed(job) and processActive then
		TriggerServerEvent('esx_weed:startProcess')			
	end	
end)

RegisterNetEvent('esx_weed:startProcessLider')
AddEventHandler('esx_weed:startProcessLider', function(currentProcess)	
	SendNUIMessage(
        {
			action = "openProgressBar",
			currentProcess = currentProcess,
			secondsToProcess = 0
        }
	)
	local currentLocalProcess = currentProcess
	processing = true
    Citizen.CreateThread(function()
    	local playerPed = PlayerPedId()
    	SetEntityCoords(playerPed, 1040.41, -3198.9, -38.93)
		makeEntityFaceEntity(playerPed, workbench)
	    RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
	 	while (not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@")) do Citizen.Wait(0) end
		TaskPlayAnim(playerPed, "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_coccutter", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
		startCancelCheck()
    	while processing do
    		Citizen.Wait(0)
    		local secondsToProcess = 1
    		while secondsToProcess <= 30 and processing do  			
    			SendNUIMessage(
			        {
						action = "updateProgress",
						secondsToProcess = secondsToProcess,
						currentProcess = currentLocalProcess
			        }
				)
				Citizen.Wait(1000)
				secondsToProcess = secondsToProcess + 1
    		end
    		if processing then
    			currentLocalProcess = currentLocalProcess + 1
    			TriggerServerEvent("esx_weed:processNewWeedBrick")
    		end
    	end
    	ClearPedTasksImmediately(playerPed)
	    SendNUIMessage(
	        {
				action = "closeProgressBar"
	        }
		)
    end)
end)

function startCancelCheck()
	ESX.ShowNotification("Pulsa ~g~E~w~ para cancelar el procesado")
	Citizen.CreateThread(function()
    	while processing do
    		Citizen.Wait(10)
    		if IsControlJustReleased(1, 38) then
    			processing = false
				SendNUIMessage(
			        {
						action = "closeProgressBar"
			        }
				)
				ClearPedTasksImmediately(PlayerPedId())
				TriggerServerEvent("esx_weed:stopProcessing")
    		end
    	end
    end)
end

RegisterNetEvent("esx_weed:finishProcessing")
AddEventHandler("esx_weed:finishProcessing", function()
	processing = false
    for i=1, #fullBucketsEntities do
        local bucket = fullBucketsEntities[i]
        if DoesEntityExist(bucket) then
            DeleteEntity(bucket)
        end
    end
    if DoesEntityExist(bucketEntity) then
    	DeleteEntity(bucketEntity)
    end
	farmActive = false
	isFarmLider = false
	plantsEntities = {}
	bucketEntity = 0
	fullBucketsEntities = {}
	handlingWeed = false
	currentWeedBranchEntity = 0
	umbspawned = 0
	netid = 0
	farmerEntity = 0
	processActive = false
	bricksEntity = 0
end)

RegisterNetEvent("esx_weed:spawnBricks")
AddEventHandler("esx_weed:spawnBricks", function(bricksProcess)
 	RequestModel(Config.bricks.model)
	while not HasModelLoaded(Config.bricks.model) do Citizen.Wait(50) end
	local newBricksEntity = CreateObject(GetHashKey(Config.bricks.model), Config.bricks.locations[bricksProcess].coords.x, Config.bricks.locations[bricksProcess].coords.y, Config.bricks.locations[bricksProcess].coords.z, 0, 0, 0)
	table.insert(bricksEntities, {id = bricksProcess, entity = newBricksEntity})
	SetEntityHeading(newBricksEntity, Config.bricks.locations[bricksProcess].heading)
	SetBlockingOfNonTemporaryEvents(newBricksEntity, true)
	FreezeEntityPosition(newBricksEntity, true)	
	SetModelAsNoLongerNeeded(Config.bricks.model)
end)

RegisterNetEvent('esx_weed:addCaseToPallet')
AddEventHandler('esx_weed:addCaseToPallet', function(caseIndex)
	Citizen.CreateThread(function()
		RequestModel(Config.fullBuckets.model)
		while not HasModelLoaded(Config.fullBuckets.model) do Citizen.Wait(50) end
		local newBucketEntity = CreateObject(GetHashKey(Config.fullBuckets.model), Config.fullBuckets.locations[caseIndex].coords.x, Config.fullBuckets.locations[caseIndex].coords.y, Config.fullBuckets.locations[caseIndex].coords.z, 0, 0, 0)
		table.insert(fullBucketsEntities, newBucketEntity)
		SetEntityHeading(newBucketEntity, Config.fullBuckets.locations[caseIndex].heading)
		SetBlockingOfNonTemporaryEvents(newBucketEntity, true)
		FreezeEntityPosition(newBucketEntity, true)	
		SetModelAsNoLongerNeeded(Config.fullBuckets.model)	
	end)
end)

RegisterNetEvent('esx_weed:removePlantFromLabClient')
AddEventHandler('esx_weed:removePlantFromLabClient', function(plantId)
	for i = 1, #plantsEntities do
		if plantsEntities[i].id == plantId then
			table.remove(plantsEntities, i)
			return
		end
	end
end)

function getPlantIdFromEntity(entity)
	for i = 1, #plantsEntities do
		if entity == plantsEntities[i].entity then
			return plantsEntities[i].id
		end
	end
end

function setSelectedPlantsEntities(selectedPlants)
	local entities = {}
	for i = 1, #selectedPlants do
		entity, distance =  ESX.Game.GetClosestObject(selectedPlants[i].coords)
		if DoesEntityExist(entity) then
			table.insert(entities, {entity = entity, coords = selectedPlants[i].coords, id = selectedPlants[i].id})
		end
	end
	plantsEntities = entities
	print(json.encode(plantsEntities))
end

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("startLabFarm", function(data, cb)
    SetNuiFocus(false, false) 
    TriggerServerEvent('esx_weed:startLabFarm')
end)

RegisterNUICallback("errorMessage", function(data, cb)
    ESX.ShowNotification(data.message)
end)

--------------------------------------------------------------------------------------

								--Object GENERATION--

--------------------------------------------------------------------------------------

function spawnWeed()
	Citizen.CreateThread(function()
		RequestModel(Config.weed.object.model)
		while not HasModelLoaded(Config.weed.object.model) do Citizen.Wait(50) end
		weedEntity = CreateObject(GetHashKey(Config.weed.object.model), Config.weed.object.coords.x, Config.weed.object.coords.y, Config.weed.object.coords.z, 0, 0, 0)
		SetEntityHeading(weedEntity, Config.weed.object.heading)
		SetBlockingOfNonTemporaryEvents(weedEntity, true)
		FreezeEntityPosition(weedEntity, true)
		SetModelAsNoLongerNeeded(Config.weed.object.model)
		weedSpawned = true
		while weedSpawned do
	        Citizen.Wait(0)
    		if #(GetEntityCoords(PlayerPedId()) - Config.weed.object.coords) < 20 then
    			DrawMarker(20, Config.weed.object.coords.x, Config.weed.object.coords.y, Config.weed.object.coords.z + 1.15,0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 50, 0, 100, false, true, 2, true, false, false, false)
    		else
    			Citizen.Wait(1300)
    		end	
	    end
	end)
end

--------------------------------------------------------------------------------------

								--Ped Generation--

--------------------------------------------------------------------------------------

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteCharacters()
	end
end)

DeleteCharacters = function()
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
        SetModelAsNoLongerNeeded(hash)
    end

    RequestModel(Config.workbench.model)
	while not HasModelLoaded(Config.workbench.model) do Citizen.Wait(50) end
	workbench = CreateObject(GetHashKey(Config.workbench.model), Config.workbench.coords.x, Config.workbench.coords.y, Config.workbench.coords.z, 0, 0, 0)
	SetEntityHeading(workbench, Config.workbench.heading)
	SetBlockingOfNonTemporaryEvents(workbench, true)
	FreezeEntityPosition(workbench, true)	
	SetModelAsNoLongerNeeded(Config.workbench.model)

	RequestModel(Config.pallet.model)
	while not HasModelLoaded(Config.pallet.model) do Citizen.Wait(50) end
	pallet = CreateObject(GetHashKey(Config.pallet.model), Config.pallet.coords.x, Config.pallet.coords.y, Config.workbench.coords.z, 0, 0, 0)
	SetEntityHeading(pallet, Config.pallet.heading)
	SetBlockingOfNonTemporaryEvents(pallet, true)
	FreezeEntityPosition(pallet, true)	
	SetModelAsNoLongerNeeded(Config.pallet.model)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if #(GetEntityCoords(PlayerPedId()) - peds[1].coords) < 20.0 then
			DrawMarker(20, peds[1].coords.x, peds[1].coords.y, peds[1].coords.z + 2, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.3, 0.3, 0.3, 255, 50, 0, 100, false, true, 2, true, false, false, false)
		else
			Citizen.Wait(2000)	
		end			
	end
end)
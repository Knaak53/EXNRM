ESX = nil
PlayerData = nil

local isInService = false
local currentServiceVehicle = nil
local bagInHand = false
local currentBagInHand = 0
local canSpawnVehicle = true

--------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function IsJobgarbage()
	if PlayerData ~= nil then
		local isJobgarbage = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'garbage' then
			isJobgarbage = true
		end
		return isJobgarbage
	end
end

local trackedContainerEntities = {}

RegisterNetEvent('esx_garbage:searchContainer')
AddEventHandler('esx_garbage:searchContainer', function(entity, coords)
	local playerCoords = GetEntityCoords(PlayerPedId())
	if #(playerCoords - coords) > 2.1 then
		ESX.ShowNotification("~r~Estas demasiado lejos...")
		return
	end
	if #(playerCoords - vector3(-319.7, -1530.79, 27.56)) > 100 then
		if bagInHand then
			ESX.ShowNotification("Ya llevas una bolsa en la mano...")
			return
		end
		if isInService then
			if isEntityTracked(entity) then
				takeBagFromContainer(entity)
			else
				if #trackedContainerEntities > 45 then
					table.remove(trackedContainerEntities, 1)
				end
				math.randomseed(GetGameTimer())
				local foundBags = math.random(1, 100)
				if foundBags < 60 then
					createContainerBags(entity)
				else
					ESX.ShowNotification("El contenedor esta vacio.")
					table.insert(trackedContainerEntities, {container = entity, bagsCount = nil})
				end
			end
		else
			ESX.ShowNotification("Debes estar de servicio para eso, ve a ponerte el uniforme...")
		end
	else
		ESX.ShowNotification("No puedes recoger basura tan cerca del vertedero")
	end
end)

RegisterNetEvent('esx_garbage:depositTrash')
AddEventHandler('esx_garbage:depositTrash', function(entity, coords)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	if #(playerCoords - coords) > 5.0 then
		ESX.ShowNotification("~r~Estas demasiado lejos...")
		return
	end
	if #(GetEntityCoords(playerPed) - vector3(-319.7, -1530.79, 27.56)) > 100 then
		if isInService then
			if bagInHand then
				if GetEntityModel(entity) == 1917016601 then
					if DoesEntityExist(currentBagInHand) then
						RequestAnimDict("anim@heists@narcotics@trash")
		 				while (not HasAnimDictLoaded("anim@heists@narcotics@trash")) do Citizen.Wait(1) end
						TaskPlayAnim(playerPed, 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
						Citizen.Wait(800)
						DeleteEntity(currentBagInHand)
						Citizen.Wait(100)
						ClearPedTasksImmediately(playerPed)
						local moneyTopay = 23 * (1 + (#playerCoords - vector3(-319.7, -1530.79, 27.56)) / 8000 * 100)
						TriggerServerEvent('esx_garbage:givePayment', moneyTopay)
						ESX.ShowNotification("Has metido la bolsa en el camion de la Basura y has ganado ~g~" .. moneyTopay .. "€")
						bagInHand = false
						currentBagInHand = 0
					else
						ESX.ShowNotification("No llevas ninguna bolsa de basura!")	
					end		
				else
					ESX.ShowNotification("Solo puedes dejar bolsas en el camion de la Basura!")	
				end
			else
				ESX.ShowNotification("No llevas ninguna bolsa de basura!")	
			end
		end
	else
		ESX.ShowNotification("No puedes recoger basura tan cerca del vertedero")
	end
end)

RegisterNetEvent('esx_garbage:cleanTrash')
AddEventHandler('esx_garbage:cleanTrash', function(entity)
	local trunkpos = GetWorldPositionOfEntityBone(entity, GetEntityBoneIndexByName(entity, "platelight"))
	local playerCoords = GetEntityCoords(PlayerPedId())
    local distanceToTrunk = #(playerCoords - trunkpos)
	if distanceToTrunk > 2.1 then
		ESX.ShowNotification("~r~Estas demasiado lejos...")
		return
	end
	if #(GetEntityCoords(PlayerPedId()) - vector3(-319.7, -1530.79, 27.56)) > 100 then
		if isInService then
			if not bagInHand then
				for i = 1, #trackedContainerEntities do
					if trackedContainerEntities[i].container == entity then
						if trackedContainerEntities[i].bagsCount then
							if trackedContainerEntities[i].bagsCount > 0 then
								ESX.ShowNotification("Todavia quedan bolsas de basura por recoger en este contenedor!")
							else
								trackedContainerEntities[i].bagsCount = nil
								TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BUM_WASH", 0, true)				
								Citizen.Wait(4000)
								ClearPedTasks(PlayerPedId())
								TriggerServerEvent('esx_garbage:givePayment', 25)
								ESX.ShowNotification("Has limpiado el contenedor y has cobrado ~g~15€")
							end
						else
							ESX.ShowNotification("Ya has terminado con ese contenedor")
						end
						break
					end
				end
			else
				ESX.ShowNotification("No puedes hacer eso mientras llevas una bolsa de basura!")	
			end
		end
	else
		ESX.ShowNotification("No puedes recoger basura tan cerca del vertedero")
	end
end)

function createContainerBags(entity)
	local bagsFoundRandom = math.random(1, 100)
	local bagsFoundCount
	
	if bagsFoundRandom < 33 then
		bagsFoundCount = 1
	elseif bagsFoundRandom <= 33 and bagsFoundRandom > 10 then
		bagsFoundCount = 2
	else
		bagsFoundCount = 3
	end

	table.insert(trackedContainerEntities, {container = entity, bagsCount = bagsFoundCount})
	takeBagFromContainer(entity)
end

function takeBagFromContainer(entity)
	for i = 1, #trackedContainerEntities do
		if trackedContainerEntities[i].container == entity then
			if trackedContainerEntities[i].bagsCount then
				if trackedContainerEntities[i].bagsCount > 0 then
					trackedContainerEntities[i].bagsCount = trackedContainerEntities[i].bagsCount - 1
					takeBag(trackedContainerEntities[i].container)
				else
					ESX.ShowNotification("Ya has recogido todas las bolsas del contenedor, ahora puedes limpiarlo...")
				end
			else
				ESX.ShowNotification("Ya has terminado con ese contenedor")
			end
			break
		end
	end
end

function takeBag(entity)
	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
	TriggerServerEvent('esx_garbage:bagremoval', platenumb)
	trashcollection = false
	Citizen.Wait(4000)
	ClearPedTasks(PlayerPedId())
	currentBagInHand = CreateObject(GetHashKey("prop_cs_street_binbag_01"), 0, 0, 0, true, false, false) -- creates object
	AttachEntityToEntity(currentBagInHand, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)

	bagInHand = true
end

function isEntityTracked(entity)
	for i = 1, #trackedContainerEntities do
		if trackedContainerEntities[i].container == entity then
			return true
		end
	end
	return false
end

------------------------------------------------- MENUS --------------------------------------------------
RegisterNetEvent('esx_garbage:citizen_wear')
AddEventHandler('esx_garbage:citizen_wear', function()
	isInService = false
	TriggerEvent('esx_trash:endJobGarbage')
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		  local model = nil

		  if skin.sex == 0 then
			model = GetHashKey("mp_m_freemode_01")
		  else
			model = GetHashKey("mp_f_freemode_01")
		  end

		  RequestModel(model)
		  while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(1)
		  end

		  SetPlayerModel(PlayerId(), model)
		  SetModelAsNoLongerNeeded(model)

		  TriggerEvent('skinchanger:loadSkin', skin)
		  ESX.ShowNotification("Ahora estas de ~g~Servicio~w~!")
	end)
end)

RegisterNetEvent('esx_garbage:job_wear')
AddEventHandler('esx_garbage:job_wear', function()
	isInService = true
	TriggerEvent('esx_trash:startJobGarbage')
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)

		RequestModel(model)
		while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(0)
		end

	SetPlayerModel(PlayerId(), model)
	SetModelAsNoLongerNeeded(model)
		end
	end)
end)

RegisterNetEvent('esx_garbage:vehicle')
AddEventHandler('esx_garbage:vehicle', function()
	if isInService then
		if canSpawnVehicle then
			TriggerServerEvent("esx_garbage:spawnTruck", Config.Zones.VehicleSpawnPoint.Pos)
		else
			ESX.ShowNotification('Ya has solicitado un vehiculo hace poco, devuelve el vehiculo o vuelve mas tarde')
		end
	else
		ESX.ShowNotification('Debes ponerte el ~g~UNIFORME~w~ para poder trabajar')
	end
end)

local currentSpawnedTruck = nil

RegisterNetEvent("esx_garbage:warpPedIntoTruck")
AddEventHandler("esx_garbage:warpPedIntoTruck", function(netVeh)
	local vehicle = NetToVeh(netVeh)
	local playerPed = PlayerPedId()
	while not DoesEntityExist(vehicle) do 
		vehicle = NetToVeh(netVeh)
		Citizen.Wait(100) 
	end
	currentSpawnedTruck = vehicle
	TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	startVehicleTimer()
end)

function startVehicleTimer()
	Citizen.CreateThread(function()
		canSpawnVehicle = false
		Citizen.Wait(60000 * 45)
		canSpawnVehicle = true
	end)
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Cloakroom.CloakRoom.Pos.x, Config.Cloakroom.CloakRoom.Pos.y, Config.Cloakroom.CloakRoom.Pos.z)

	SetBlipSprite (blip, 318)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 40)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Vertedero Municipal")
	EndTextCommandSetBlipName(blip)
end)

local deleteVehicleMarkerInfo = {
	coords = vector3(-345.88, -1530.89, 28.565467834473),
	Color = {r = 204, g = 0, b = 0},
	Size  = {x = 3.0, y = 3.0, z = 2.0},
	Type  = 39
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		if IsJobgarbage() and DoesEntityExist(currentSpawnedTruck) then
			if #(GetEntityCoords(playerPed) - deleteVehicleMarkerInfo.coords) < 35 then
				DrawMarker(deleteVehicleMarkerInfo.Type,
				  deleteVehicleMarkerInfo.coords.x,
				  deleteVehicleMarkerInfo.coords.y,
				  deleteVehicleMarkerInfo.coords.z, 0, 0, 1, 0, 0, 0,
				  deleteVehicleMarkerInfo.Size.x, 
				  deleteVehicleMarkerInfo.Size.y,
				  deleteVehicleMarkerInfo.Size.z,
				  deleteVehicleMarkerInfo.Color.r,
				  deleteVehicleMarkerInfo.Color.g, 
				  deleteVehicleMarkerInfo.Color.b, 200, 0, 1, 0, 0)
				if #(GetEntityCoords(playerPed) - deleteVehicleMarkerInfo.coords) < 3 then
				 	AddTextEntry(GetCurrentResourceName(), "Pulsa ~INPUT_CONTEXT~ para devolver el camion")
        			DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
			        EndTextCommandDisplayHelp(0, true, false, 0)
			        if IsControlJustReleased(0, 38) then
			        	deleteJobVehicle()
			        end
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

function deleteJobVehicle()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed)
	if DoesEntityExist(currentSpawnedTruck) and vehicle and vehicle == currentSpawnedTruck then
		TriggerServerEvent("esx_cityworks:deleteBVAndGiveBackMoney", VehToNet(currentSpawnedTruck))
		currentSpawnedTruck = nil
		canSpawnVehicle = true
	else
		ESX.ShowNotification("Solo puedes devolver al vertedero tu Camion de la basura")
	end
end

------ FUNCION DE VER SI HAY AGUA!
--[[function IsFacingWater()
  local ped = PlayerPedId()
  local headPos = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
  local offsetPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 50.0, -25.0)
  local hit, hitPos = TestProbeAgainstWater(headPos.x, headPos.y, headPos.z, offsetPos.x, offsetPos.y, offsetPos.z)
  return hit, hitPos
end]]


------------------------------------ PED GENERATION -----------------------------------------

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteWomans()
	end
end)

local pedEntity = 0

DeleteWomans = function()
    if DoesEntityExist(pedEntity) then
        DeletePed(pedEntity)
        SetPedAsNoLongerNeeded(pedEntity)
    end
end

Citizen.CreateThread(function()

    hash = GetHashKey('s_m_y_garbage')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
		Wait(0)
	end
    if not DoesEntityExist(pedEntity) then
        pedEntity = CreatePed(4, hash, Config.Cloakroom.CloakRoom.Pos.x, Config.Cloakroom.CloakRoom.Pos.y, Config.Cloakroom.CloakRoom.Pos.z, 0.0)
        SetEntityAsMissionEntity(pedEntity)
        SetBlockingOfNonTemporaryEvents(pedEntity, true)
        FreezeEntityPosition(pedEntity, true)
        SetEntityInvincible(pedEntity, true)
        TaskStartScenarioInPlace(pedEntity, "WORLD_HUMAN_SMOKING", 0, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)
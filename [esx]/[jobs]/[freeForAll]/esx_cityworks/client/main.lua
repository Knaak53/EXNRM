ESX                             = nil
local PlayerData                = {}
local onDuty                    = false
local BlipCloakRoom             = nil
local canSpawnVehicle = true

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(20)
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

local canDoJob = false

RegisterNetEvent('esx_cityworks:citizen_wear')
AddEventHandler('esx_cityworks:citizen_wear', function()
	if onDuty then
		local playerPed = GetPlayerPed(-1)
		onDuty = false
	    ESX.ShowNotification(_U('end_service_notif'))
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
		  ClearPedBloodDamage(playerPed)
		  ResetPedVisibleDamage(playerPed)
		  ClearPedLastWeaponDamage(playerPed)
		end)
	else
		ESX.ShowNotification('Ya llevas tu ~g~ROPA~w~!')
	end
end)

RegisterNetEvent('esx:inventoryUpdate')
AddEventHandler('esx:inventoryUpdate', function(item, add)
	if not add and item == "workstool" then
		ESX.TriggerServerCallback("esx_cityworks:checkRequeriments", function(canDoTheJob)
            if canDoTheJob then
				canDoJob = true
			else
				canDoJob = false
			end
        end)
	end
end)

RegisterNetEvent('esx_cityworks:job_wear')
AddEventHandler('esx_cityworks:job_wear', function()
	if not canDoTheJob then
		ESX.TriggerServerCallback("esx_cityworks:checkRequeriments", function(canDoTheJob)
            if canDoTheJob then
				canDoJob = true
				jobWear()
			else
				ESX.ShowNotification("Necesitas ~r~Herramientas de Mantenimiento~w~ para poder hacer el trabajo!")
			end
        end) 
	else
		if not onDuty then
			jobWear()
		else
			ESX.ShowNotification('Ya llevas el ~g~UNIFORME~w~ y estas de ~g~SERVICIO~w~!')
		end
	end
end)

function jobWear()
	local playerPed = PlayerPedId()
	onDuty = true
	ESX.ShowNotification("Estas de ~g~Servicio, ~w~examina mobiliario urbano y dispositivos en busca de averias!")
	setUniform('job_wear', playerPed)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
end

local currentSpawnedTruck = nil

RegisterNetEvent('esx_cityworks:vehicle')
AddEventHandler('esx_cityworks:vehicle', function()
	if not canDoTheJob then
		ESX.TriggerServerCallback("esx_cityworks:checkRequeriments", function(canDoTheJob)
            if canDoTheJob then
				canDoJob = true
				if onDuty then
					if not DoesEntityExist(currentSpawnedTruck) then
						TriggerServerEvent("esx_cityworks:getBoxville", Config.Zones.VehicleSpawnPoint.Pos)
					else
						ESX.ShowNotification('Ya has solicitado un vehiculo de trabajo, devuelvelo para recuperar la fianza.')
					end
				else
					ESX.ShowNotification('Debes estar de ~g~SERVICIO~w~ para solicitar un vehiculo')
				end
			else
				ESX.ShowNotification("Necesitas ~r~Herramientas de Mantenimiento~w~ para poder hacer el trabajo!")
			end
        end) 
	else
		if onDuty then
			TriggerServerEvent("esx_cityworks:getBoxville", Config.Zones.VehicleSpawnPoint.Pos)
		else
			ESX.ShowNotification('Debes estar de ~g~SERVICIO~w~ para solicitar un vehiculo')
		end
	end
end)

RegisterNetEvent("esx_cityworks:warpPedIntoBoxVille")
AddEventHandler("esx_cityworks:warpPedIntoBoxVille", function(netVeh)
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

RegisterNetEvent('esx_cityworks:pay')
AddEventHandler('esx_cityworks:pay', function()
	local playerPed = GetPlayerPed(-1)	
	TriggerServerEvent('esx_cityworks:pay')
end)

local trackedDeviceEntities = {}

RegisterNetEvent('esx_cityworks:examineDevice')
AddEventHandler('esx_cityworks:examineDevice', function(entity)
	if not canDoTheJob then
		ESX.TriggerServerCallback("esx_cityworks:checkRequeriments", function(canDoTheJob)
            if canDoTheJob then
				canDoJob = true
				examine(entity)
			else
				ESX.ShowNotification("Necesitas ~r~Herramientas de Mantenimiento~w~ para poder hacer el trabajo!")
			end
        end) 
	else
		examine(entity)
	end
end)

function examine(entity)
	if onDuty then
		if #trackedDeviceEntities >= 40 then
			table.remove(trackedDeviceEntities, 1)
		end
		if trackedDeviceEntities[entity] ~= nil then
			if trackedDeviceEntities[entity] then
				ESX.ShowNotification("~y~Has encontrado una averia en el dispositivo, puedes repararla!")
			else
				ESX.ShowNotification("~g~El dispositivo ya funciona correctamente...")
			end
	    else
	    	ESX.TriggerServerCallback('esx_cityworks:examine', function(result)
	            if result then
					examineDeviceAnimation()
					ESX.ShowNotification("~g~Has encontrado una averia!")
					trackedDeviceEntities[entity] = true
				else
					examineDeviceAnimation()
					ESX.ShowNotification("No has encontrado nignuna averia, todo parece funcionar correctamente...")
					trackedDeviceEntities[entity] = false
				end
	        end)  
	    end
	else
		ESX.ShowNotification("No estas de ~r~SERVICIO~w~!")
	end
end

function examineDeviceAnimation()
	local playerPed = PlayerPedId()
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
	Citizen.Wait(6000)
	ClearPedTasks(playerPed)
	Citizen.Wait(400)
    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_POLICE_INVESTIGATE", 0, true)
	Citizen.Wait(5000)
	ClearPedTasks(playerPed)
	Citizen.Wait(400)
end

RegisterNetEvent('esx_cityworks:repareDevice')
AddEventHandler('esx_cityworks:repareDevice', function(entity)
	if not canDoTheJob then
		ESX.TriggerServerCallback("esx_cityworks:checkRequeriments", function(canDoTheJob)
            if canDoTheJob then
				canDoJob = true
				repair(entity)
			else
				ESX.ShowNotification("Necesitas ~r~Herramientas de Mantenimiento~w~ para poder hacer el trabajo!")
			end
        end) 
	else
		repair(entity)
	end
end)

function repair(entity)
	local trackedEntityFound = false
	for k, canRepair in pairs(trackedDeviceEntities) do
		if k == entity then
			trackedEntityFound = true
			if canRepair then
				local playerPed = PlayerPedId()
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
			    Citizen.Wait(17000)
			    ClearPedTasks(playerPed)
				Citizen.Wait(400)
				TriggerServerEvent('esx_cityworks:repare')
			else
				ESX.ShowNotification("~g~El dispositivo ya funciona correctamente...")
			end
			break
		end
	end
	if not trackedEntityFound then
		ESX.ShowNotification("Todavia no has ~g~EXAMINADO~w~ este dispositivo...")
	end
end

RegisterNetEvent('esx_cityworks:stopCobrar')
AddEventHandler('esx_cityworks:stopCobrar', function()
	local playerPed = GetPlayerPed(-1)
	ClearPedTasksImmediately(playerPed)
	TriggerServerEvent('esx_cityworks:stopVente')
end)

RegisterNetEvent('esx_cityworks:bossMenu_ui')
AddEventHandler('esx_cityworks:bossMenu_ui', function()
	if PlayerData.job ~= nil and PlayerData.job.name == Config.nameJob then
		CloakRoomMenu()
	else
		ESX.ShowNotification('No eres ~g~TECNICO DE MANTENIMIENTO~w~!')
	end
end)

function deleteVeh()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed)
	if DoesEntityExist(currentSpawnedTruck) and vehicle and vehicle == currentSpawnedTruck then
		TriggerServerEvent("esx_cityworks:deleteBVAndGiveBackMoney", VehToNet(currentSpawnedTruck))
		currentSpawnedTruck = nil
		canSpawnVehicle = true
	else
		ESX.ShowNotification("Solo puedes devolver al tu camion de mantenimiento!")
	end
end

function startVehicleTimer()
	Citizen.CreateThread(function()
		canSpawnVehicle = false
		Citizen.Wait(60000 * 20)
		canSpawnVehicle = true
	end)
end

-- Activation du marker au sol
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == Config.nameJob then
			local coords = GetEntityCoords(PlayerPedId())
			if onDuty then
				if(GetDistanceBetweenCoords(coords, Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z, true) < Config.DrawDistance) then
					found = true
					DrawMarker(39, Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Zones.VehicleDeleter.Size.x, Config.Zones.VehicleDeleter.Size.y, Config.Zones.VehicleDeleter.Size.z, 255, 0, 0, 100, false, true, 2, false, false, false, false)
					if(GetDistanceBetweenCoords(coords, Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z, true) < 3.0) then
						HelpPromt('Pulsa ~g~E~w~ para devolver el vehiculo')
						if IsControlJustReleased(1, 38) then
							deleteVeh()
						end
					end
				else
					Citizen.Wait(1000)
				end
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
    end
  end)
end

function HelpPromt(text)
	Citizen.CreateThread(function()
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, state, 0, -1)

	end)
end

Citizen.CreateThread(function()
    if BlipCloakRoom == nil then
		BlipCloakRoom = AddBlipForCoord(Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z)
		SetBlipSprite(BlipCloakRoom, Config.Zones.Cloakroom.BlipSprite)
		SetBlipColour(BlipCloakRoom, Config.Zones.Cloakroom.BlipColor)
		SetBlipAsShortRange(BlipCloakRoom, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Zones.Cloakroom.BlipName)
		EndTextCommandSetBlipName(BlipCloakRoom)
	end
end)



---------------------------------------------------------------------------------------------------------

------------------------------------- PED GENERATION ----------------------------------------------------

---------------------------------------------------------------------------------------------------------

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

    hash = GetHashKey('s_m_m_lathandy_01')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
		Wait(0)
	end
    if not DoesEntityExist(pedEntity) then
        pedEntity = CreatePed(4, hash, Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z, 275.87)
        SetEntityAsMissionEntity(pedEntity)
        SetBlockingOfNonTemporaryEvents(pedEntity, true)
        FreezeEntityPosition(pedEntity, true)
        SetEntityInvincible(pedEntity, true)
        TaskStartScenarioInPlace(pedEntity, "WORLD_HUMAN_SEAT_WALL_TABLET", 0, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)
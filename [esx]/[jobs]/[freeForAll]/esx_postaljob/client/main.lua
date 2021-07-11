ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
local CurrentDelivery 		  = false -- Le joeur en livraison ?
local DeliveryPoint			  = nil
local Blips 		  		  = {}
local district 		  		  = {}
local progress 		  		  = 1
local isInService 			  = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local vehicleMaxHealth 	      = nil

--------------------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function IsJobTrucker()
	return PlayerData ~= nil and PlayerData.job.name ~= nil and PlayerData.job.name == 'gopostal'
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									CLOAKROOM	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function setUniform(playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms.male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.Uniforms.female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end

function clothes()
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
		TriggerEvent('esx:restoreLoadout')
		isInService = false
	end)
end

function uniform()
	setUniform(PlayerPedId())
	isInService = true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									ZONE
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteBoss()
    end
end)

local pedEntity = nil

DeleteBoss = function()
    if DoesEntityExist(pedEntity) then
       --DeletePed(pedEntity)
        --SetPedAsNoLongerNeeded(pedEntity)
    end
end

Citizen.CreateThread(function()

    hash = GetHashKey('ig_andreas')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    if not DoesEntityExist(pedEntity) then
        pedEntity = CreatePed(4, hash, Config.Zones.CloakRoom.Pos.x, Config.Zones.CloakRoom.Pos.y, Config.Zones.CloakRoom.Pos.z, 67.17)
        SetEntityAsMissionEntity(pedEntity)
        SetBlockingOfNonTemporaryEvents(pedEntity, true)
        FreezeEntityPosition(pedEntity, true)
        SetEntityInvincible(pedEntity, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent('esx_gopostal:civil')
AddEventHandler('esx_gopostal:civil', function()
	if IsJobTrucker() then
		clothes()
	else
		ESX.ShowNotification('No eres ~g~CARTERO~w~!')
	end
end)

RegisterNetEvent('esx_gopostal:job')
AddEventHandler('esx_gopostal:job', function()
	if IsJobTrucker() then
		uniform()
	else
		ESX.ShowNotification('No eres ~g~CARTERO~w~!')
	end
end)

local currentSpawnedTruck = nil

RegisterNetEvent('esx_gopostal:vehicle')
AddEventHandler('esx_gopostal:vehicle', function()
	if IsJobTrucker() then
		if isInService then
			if not DoesEntityExist(currentSpawnedTruck) then
				TriggerServerEvent("esx_postaljob:getBoxville")
			else
				ESX.ShowNotification('Ya has solicitado un vehiculo, debes devolverlo para recuperar la fianza.')
			end	
		else
			ESX.ShowNotification('No llevas el ~y~UNIFORME~w~!')
		end
	else
		ESX.ShowNotification('No eres ~g~CARTERO~w~!')
	end
end)

RegisterNetEvent("esx_postaljob:warpPedIntoBoxVille")
AddEventHandler("esx_postaljob:warpPedIntoBoxVille", function(netVeh)
	local vehicle = NetToVeh(netVeh)
	local playerPed = PlayerPedId()
	while not DoesEntityExist(vehicle) do 
		vehicle = NetToVeh(netVeh)
		Citizen.Wait(100) 
	end
	currentSpawnedTruck = vehicle
	TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end)

function deleteVehicle()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed)
	if DoesEntityExist(currentSpawnedTruck) and vehicle and vehicle == currentSpawnedTruck then
		if CurrentDelivery then
			LivraisonStop(District, true)
			CurrentDelivery = false	
		end
		TriggerServerEvent("esx_postaljob:deleteBVAndGiveBackMoney", VehToNet(currentSpawnedTruck))
		currentSpawnedTruck = nil
	else
		ESX.ShowNotification("Solo puedes devolver al tu camion de mantenimiento!")
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									KEY CONTROLS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)  
        if IsJobTrucker() then
	        if IsControlJustReleased(0, 167) and IsJobTrucker() and isInService and DoesEntityExist(currentSpawnedTruck) then
	        	Livraison()
	        end
	    else
	    	Citizen.Wait(1000)
	    end
    end
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									MARKERS & BLIP
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- CREATE BLIPS
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.CloakRoom.Pos.x, Config.Zones.CloakRoom.Pos.y, Config.Zones.CloakRoom.Pos.z)
  
	SetBlipSprite (blip, 89)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.7)
	SetBlipColour (blip, 25)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_job'))
	EndTextCommandSetBlipName(blip)
end)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 									LIVRAISON
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Livraison()

	District = SelectDistrict()

	if CurrentDelivery then
		LivraisonStop(District, true)
		CurrentDelivery = false
		
	else
		CurrentDelivery = true
		ESX.ShowNotification("Se te ha asignado la ruta de ~g~" .. District.label .. "~w~, dirigete a la ubicacion para realizar el reparto")
		
		LivraisonStart(District)
	end
end

function SelectDistrict() -- Selection du quartier pour la ronde

	for k,v in pairs (Config.Livraisons) do
		local DistrictLong = 0
		for i=1, #Config.Livraisons[k].Pos, 1 do 
			DistrictLong = DistrictLong + 1 
		end

		table.insert(district, {label = _U(k), value = k, long = DistrictLong} )
	end
	district = district[ math.random( #district ) ]
	return district;
end

local letterboxEntities = {}
local currentDistrict = 0

function LivraisonStart(district)
	if CurrentDelivery then
		DeliveryPoint = district.value 
		local zone = Config.Livraisons[district.value]
		letterboxEntities = {}	
		currentDistrict = zone
		local letterId = 1
		for k, v in pairs(zone.Pos) do
			local cartas, paquetes = cartasYPaquetes()	
			RequestModel(Config.letterbox.model)
			while not HasModelLoaded(Config.letterbox.model) do Citizen.Wait(50) end
			local newLetter = CreateObject(GetHashKey(Config.letterbox.model), v.x, v.y, v.z, 0, 0, 0)
			table.insert(letterboxEntities, {id = letterId, entity = newLetter, cartas = cartas, paquetes = paquetes})
			SetEntityHeading(newLetter, v.heading)
			SetBlockingOfNonTemporaryEvents(newLetter, true)
			FreezeEntityPosition(newLetter, true)	
			SetModelAsNoLongerNeeded(Config.letterbox.model)
		end
		Citizen.CreateThread(function()
			while #letterboxEntities > 0  do
				Wait(0)
				local playerCoords = GetEntityCoords(PlayerPedId())
				local letterBoxCoords = GetEntityCoords(letterboxEntities[progress].entity)
				if IsJobTrucker() then
					if #(playerCoords - letterBoxCoords) < 25 then
						DrawMarker(20, letterBoxCoords.x, letterBoxCoords.y, letterBoxCoords.z + 1.6, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 100, false, true, 2, true, false, false, false)
					else
						Citizen.Wait(1000)
					end
				else
					Citizen.Wait(5000)
				end
			end
		end)
		Blips['DeliveryPoint'] = AddBlipForCoord(zone.Pos[progress].x, zone.Pos[progress].y, zone.Pos[progress].z)
		SetBlipRoute(Blips['DeliveryPoint'], true)
		ESX.ShowNotification(_U('join_next'))
	end
end

local carryPackage = nil

RegisterNetEvent("esx_gopostal:takePackage")
AddEventHandler("esx_gopostal:takePackage", function()
	if letterboxEntities[progress].paquetes > 0 then
		if not DoesEntityExist(carryPackage) then
			Citizen.CreateThread(function()
				carryPackage = exports.menuDependencies:spawnAndTakeProp("v_ind_meatboxsml_02")
				if not DoesEntityExist(carryPackage) then
					Citizen.Wait(50)
				end
				ESX.ShowNotification("Entrega el paquete en la direccion indicada")
			end)  
		else
			ESX.ShowNotification("~r~Ya tienes un paquete fuera de la furgoneta!")
		end
	else
		ESX.ShowNotification("La direccion actual no tiene paquetes asignados!")
	end
end)

RegisterNetEvent("esx_gopostal:entrega")
AddEventHandler("esx_gopostal:entrega", function(entity)
	if entity ~= letterboxEntities[progress].entity then
		ESX.ShowNotification("Debes entregar las cartas y paquetes en orden, ve a la direccion indicada")
		return
	end
	local playerPed = PlayerPedId()
	local cartasEntregadas, paquetesEntregados = false, false
	if letterboxEntities[progress].cartas > 0 then
		ESX.ShowNotification("Has entregado ~g~x" .. letterboxEntities[progress].cartas .. " CARTAS~w!~")
		TriggerServerEvent("esx_gopostal:pay", false, letterboxEntities[progress].cartas)
		letterboxEntities[progress].cartas = 0
	end
	if letterboxEntities[progress].paquetes > 0 then
		if DoesEntityExist(carryPackage)  then
			if GetEntityAttachedTo(carryPackage) == playerPed then
				ESX.ShowNotification("Has entregado ~g~x" .. letterboxEntities[progress].paquetes .. " PAQUETES~w!~")
				TriggerServerEvent("esx_gopostal:pay", true, 1)
				letterboxEntities[progress].paquetes = letterboxEntities[progress].paquetes - 1
				if letterboxEntities[progress].paquetes == 0 then
					ESX.ShowNotification("~g~Has entregado todos los paquetes asignados a este buzon!")
				else
					ESX.ShowNotification("Quedan ~g~x" .. letterboxEntities[progress].paquetes .. " ~w~ paquetes...")
				end
				DeleteEntity(carryPackage)
				carryPackage = nil
				ClearPedTasks(PlayerPedId())
			else
				ESX.ShowNotification("~r~Debes entregar el paquete que has retirado de la furgoneta!")
			end
		else
			ESX.ShowNotification("Recoge paquetes de la furgoneta para entregarlos en el buzon")
		end
	end 
	if letterboxEntities[progress].cartas <= 0 and letterboxEntities[progress].paquetes <= 0 then
		if Blips['DeliveryPoint'] ~= nil then
		    RemoveBlip(Blips['DeliveryPoint'])
		    Blips['DeliveryPoint'] = nil
		end
		if cancel then
			ESX.ShowNotification(_U('cancel_delivery'))
			CurrentDelivery = false
			if DoesEntityExist(carryPackage) then
				DeleteEntity(carryPackage)
				carryPackage = nil
				ClearPedTasks(PlayerPedId())
			end
			deleteMailBoxes()
		else
			if progress < district.long then
				progress = progress + 1
				Blips['DeliveryPoint'] = AddBlipForCoord(currentDistrict.Pos[progress].x, currentDistrict.Pos[progress].y, currentDistrict.Pos[progress].z)
				SetBlipRoute(Blips['DeliveryPoint'], true)
				ESX.ShowNotification(_U('join_next'))
			else
				CurrentDelivery = false
				progress = 1
				if DoesEntityExist(carryPackage) then
					DeleteEntity(carryPackage)
					carryPackage = nil
					ClearPedTasks(PlayerPedId())	
				end
				ESX.ShowNotification("~g~Has completado la entrega! ~w~Pulsa ~b~F6~w~ para solicitar una nueva ruta")
				deleteMailBoxes()
			end
		end
	end	
end)

function deleteMailBoxes()
	for k,v in pairs(letterboxEntities) do
		if DoesEntityExist(v.entity) then
			DeleteEntity(v.entity)
		end
	end
	letterboxEntities = {}
end

function LivraisonStop(district, cancel)
	if cancel then
		if Blips['DeliveryPoint'] ~= nil then
		    RemoveBlip(Blips['DeliveryPoint'])
		    Blips['DeliveryPoint'] = nil
		end
		CurrentDelivery = false
		progress = 1
		if DoesEntityExist(carryPackage) then
			DeleteEntity(carryPackage)
			carryPackage = nil
			ClearPedTasks(PlayerPedId())	
		end
		deleteMailBoxes()
		ESX.ShowNotification("~g~Has completado la entrega! ~w~Pulsa ~b~F6~w~ para solicitar una nueva ruta")
	end
end

function cartasYPaquetes()
	local cartas, paquetes
	local zone = Config.Livraisons[district.value]
	if zone.Pos[progress].letter then
		cartas = GetRandomIntInRange(Config.MinLetter, Config.MaxLetter)
	else
		cartas = 0
	end
	if zone.Pos[progress].colis then
		paquetes = GetRandomIntInRange(Config.MinColis, Config.MaxColis)
	else
		paquetes = 0
	end
	return cartas, paquetes
end

function HelpPromt(text)
	Citizen.CreateThread(function()
    	SetTextComponentFormat('STRING')
        AddTextComponentString(text)
       	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsJobTrucker() then
			local coords = GetEntityCoords(GetPlayerPed(-1))		
			if isInService and Config.Zones.VehicleDeleter.Type ~= -1 and GetDistanceBetweenCoords(coords, Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z, true) < Config.DrawDistance then
				DrawMarker(Config.Zones.VehicleDeleter.Type, Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Zones.VehicleDeleter.Size.x, Config.Zones.VehicleDeleter.Size.y, Config.Zones.VehicleDeleter.Size.z, Config.Zones.VehicleDeleter.Color.r, Config.Zones.VehicleDeleter.Color.g, Config.Zones.VehicleDeleter.Color.b, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z, true) < 3 then
					HelpPromt(_U('return_vehicle'))
					if IsControlJustReleased(0, 38) and IsJobTrucker() then
						deleteVehicle()
					end
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)
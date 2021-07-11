--[[ ============================================================ ]]--
--[[ |       FIVEM ESX DELIVERY PLUGIN REMAKE BY AKKARIIN       | ]]--
--[[ ============================================================ ]]--

ESX = nil

local Status = {
	DELIVERY_INACTIVE                 = 0,
	PLAYER_STARTED_DELIVERY           = 1,
	PLAYER_REACHED_VEHICLE_POINT      = 2,
	PLAYER_REMOVED_GOODS_FROM_VEHICLE = 3,
	PLAYER_REACHED_DELIVERY_POINT     = 4,
	PLAYER_RETURNING_TO_BASE          = 5
}

-- Don't touch this, pls :)

local CurrentStatus             = Status.DELIVERY_INACTIVE
local CurrentSubtitle           = nil
local CurrentBlip               = nil
local CurrentType               = nil
local CurrentVehicle            = nil
local CurrentAttachments        = {}
local CurrentVehicleAttachments = {}
local DeliveryLocation          = {}
local DeliveryComplete          = {}
local DeliveryRoutes            = {}
local PlayerJob                 = nil
local FinishedJobs              = 0

-- Make player look like a worker

function LoadWorkPlayerSkin(deliveryType)
	
	local playerPed = GetPlayerPed(-1)
	
	if deliveryType == 'scooter' then
		if IsPedMale(playerPed) then
			for k, v in pairs(Config.OutfitScooter) do
				SetPedComponentVariation(playerPed, k, v.drawables, v.texture, 1)
			end
		else
			for k, v in pairs(Config.OutfitScooterF) do
				SetPedComponentVariation(playerPed, k, v.drawables, v.texture, 1)
			end
		end
	else
		if IsPedMale(playerPed) then
			for k, v in pairs(Config.OutfitVan) do
				SetPedComponentVariation(playerPed, k, v.drawables, v.texture, 1)
			end
		else
			for k, v in pairs(Config.OutfitVanF) do
				SetPedComponentVariation(playerPed, k, v.drawables, v.texture, 1)
			end
		end
	end
end

-- Load the default player skin (for esx_skin)

function LoadDefaultPlayerSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

-- Control the input

function HandleInput()	
	if PlayerJob == "delivery" then
		if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
			DisableControlAction(0, 21, true)
		else
			Citizen.Wait(500)
		end
	else
		Citizen.Wait(1000)
	end
end

-- Main logic handler

function HandleLogic()
	
	if PlayerJob == "delivery" then
		local playerPed = GetPlayerPed(-1)
		local pCoords   = GetEntityCoords(playerPed)
		
		if CurrentStatus ~= Status.DELIVERY_INACTIVE then
			if IsPedDeadOrDying(playerPed, true) then
				FinishDelivery(CurrentType, false)
				return
			elseif GetVehicleEngineHealth(CurrentVehicle) < 20 and CurrentVehicle ~= nil then
				FinishDelivery(CurrentType, false)
				return
			end
		
			if CurrentStatus == Status.PLAYER_STARTED_DELIVERY then
				if not IsPlayerInsideDeliveryVehicle() then
					CurrentSubtitle = _U("get_back_in_vehicle")
				else
					CurrentSubtitle = nil
				end
				
				if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z, true) < 1.5 then
					CurrentStatus = Status.PLAYER_REACHED_VEHICLE_POINT
					CurrentSubtitle = _U("remove_goods_subtext")
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
				end
			end
			
			if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
				if CurrentType == 'van' or CurrentType == 'truck' then
					CurrentSubtitle = _U("deliver_inside_shop")
					if CurrentType == 'van' and not IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "walk", 3) then
						ForceCarryAnimation();
					end
				end
				
				if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, DeliveryLocation.Item2.x, DeliveryLocation.Item2.y, DeliveryLocation.Item2.z, true) < 1.5 then
					
					TriggerServerEvent("esx_deliveries:finishDelivery:server", CurrentType)
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
					FinishedJobs = FinishedJobs + 1
					
					ESX.ShowNotification(_U("finish_job") .. FinishedJobs .. "/" .. #DeliveryRoutes)
					
					if FinishedJobs >= #DeliveryRoutes then
						RemovePlayerProps()
						RemoveBlip(CurrentBlip)
						DeliveryLocation.Item1 = Config.Base.retveh
						DeliveryLocation.Item2 = {x = 0, y = 0, z = 0}
						CurrentBlip            = CreateBlipAt(DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z)
						CurrentSubtitle        = _U("get_back_to_deliveryhub")
						CurrentStatus          = Status.PLAYER_RETURNING_TO_BASE
						return
					else
						RemovePlayerProps()
						GetNextDeliveryPoint(false)
						CurrentStatus = Status.PLAYER_STARTED_DELIVERY
						CurrentSubtitle = _U("drive_next_point")
						PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	else
		Citizen.Wait(1000)
	end
end

-- Handling markers and object status

function HandleMarkers()
	
	if PlayerJob == "delivery" then
		local pCoords = GetEntityCoords(GetPlayerPed(-1))
		local deleter = Config.Base.deleter
		
		if CurrentStatus ~= Status.DELIVERY_INACTIVE then
			DrawMarker(20, deleter.x, deleter.y, deleter.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 249, 38, 114, 150, true, true)
			if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, deleter.x, deleter.y, deleter.z) < 1.5 then
				DisplayHelpText(_U("end_delivery"))
				if IsControlJustReleased(0, 51) then
					EndDelivery()
					return
				end
			end
			
			if CurrentStatus == Status.PLAYER_STARTED_DELIVERY then
				if not IsPlayerInsideDeliveryVehicle() and CurrentVehicle ~= nil then
					local VehiclePos = GetEntityCoords(CurrentVehicle)
					local ArrowHeight = VehiclePos.z
					ArrowHeight = VehiclePos.z + 1.0
					
					if CurrentType == 'van' then
						ArrowHeight = ArrowHeight + 1.0
					elseif CurrentType == 'truck' then
						ArrowHeight = ArrowHeight + 2.0
					end
					
					DrawMarker(20, VehiclePos.x, VehiclePos.y, ArrowHeight, 0, 0, 0, 0, 180.0, 0, 0.8, 0.8, 0.8, 102, 217, 239, 150, true, true)
				else
					local dl = DeliveryLocation.Item1
					if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, dl.x, dl.y, dl.z, true) < 150 then
						DrawMarker(20, dl.x, dl.y, dl.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
					end
				end
			end
			
			if CurrentStatus == Status.PLAYER_REACHED_VEHICLE_POINT then
				if not IsPlayerInsideDeliveryVehicle() then
					TrunkPos = GetEntityCoords(CurrentVehicle)
					TrunkForward = GetEntityForwardVector(CurrentVehicle)
					local ScaleFactor = 1.0
					
					for k, v in pairs(Config.Scales) do
						if k == CurrentType then
							ScaleFactor = v
						end
					end
					
					TrunkPos = TrunkPos - (TrunkForward * ScaleFactor)
					TrunkHeight = TrunkPos.z
					TrunkHeight = TrunkPos.z + 0.7
					
					local ArrowSize = {x = 0.8, y = 0.8, z = 0.8}
					
					if CurrentType == 'scooter' then
						ArrowSize = {x = 0.15, y = 0.15, z = 0.15}
					end
					
					DrawMarker(20, TrunkPos.x, TrunkPos.y, TrunkHeight, 0, 0, 0, 180.0, 0, 0, ArrowSize.x, ArrowSize.y, ArrowSize.z, 102, 217, 239, 150, true, true)
					
					if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, TrunkPos.x, TrunkPos.y, TrunkHeight, true) < 1.0 then
						DisplayHelpText(_U("remove_goods"))
						if IsControlJustReleased(0, 51) then
							PlayTrunkAnimation()
							GetPlayerPropsForDelivery(CurrentType)
							CurrentStatus = Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE
						end
					end
				end
			end
			
			if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
				local dp = DeliveryLocation.Item2
				DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
			end
			
			if CurrentStatus == Status.PLAYER_RETURNING_TO_BASE then
				local dp = Config.Base.deleter
				DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
			end
		else
			Citizen.Wait(500)
		end
	else
		Citizen.Wait(1000)
	end
end

RegisterNetEvent('esx_deliveries:boss_ui')
AddEventHandler('esx_deliveries:boss_ui', function()
	Citizen.Wait(250)
	if PlayerJob == "delivery" then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
		{
			title = 'Jefa de repartidores',
			align = 'left',
			elements = {
				{label = 'Solicitar scooter', value = 'scooter'},
				{label = 'Solicitar furgoneta', value = 'van'},
				{label = 'Solicitar camion', value = 'truck'}
			}
		}, function(data, menu)
			menu.close()
			StartDelivery(data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('No eres ~g~REPARTIDOR~w~!')
	end
end)

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

    hash = GetHashKey('ig_marnie')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
		Wait(0)
	end
    if not DoesEntityExist(pedEntity) then
        pedEntity = CreatePed(4, hash, Config.Base.scooter.x, Config.Base.scooter.y, Config.Base.scooter.z, 181.64)
        SetEntityAsMissionEntity(pedEntity)
        SetBlockingOfNonTemporaryEvents(pedEntity, true)
        FreezeEntityPosition(pedEntity, true)
        SetEntityInvincible(pedEntity, true)
        TaskStartScenarioInPlace(pedEntity, "WORLD_HUMAN_SEAT_WALL", 0, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)

-- The trunk animation when the player remove the goods from the vehicle
function PlayTrunkAnimation()
	Citizen.CreateThread(function()
		if CurrentType == 'truck' then
			if Config.Models.vehDoor.usingTrunkForTruck then
				SetVehicleDoorOpen(CurrentVehicle, 5, false, false)
			else
				SetVehicleDoorOpen(CurrentVehicle, 2, false, false)
				SetVehicleDoorOpen(CurrentVehicle, 3, false, false)
			end
		elseif CurrentType == 'van' then
			if Config.Models.vehDoor.usingTrunkForVan then
				SetVehicleDoorOpen(CurrentVehicle, 5, false, false)
			else
				
			end
			
		end
		Wait(1000)
		if CurrentType == 'truck' then
			if Config.Models.vehDoor.usingTrunkForTruck then
				SetVehicleDoorShut(CurrentVehicle, 5, false)
			else
				SetVehicleDoorShut(CurrentVehicle, 2, false)
				SetVehicleDoorShut(CurrentVehicle, 3, false)
			end
		elseif CurrentType == 'van' then
			if Config.Models.vehDoor.usingTrunkForVan then
				SetVehicleDoorShut(CurrentVehicle, 5, false)
			else
				SetVehicleDoorShut(CurrentVehicle, 2, false)
				SetVehicleDoorShut(CurrentVehicle, 3, false)
			end
		end
	end)
end

-- Create a blip for the location

function CreateBlipAt(x, y, z)
	
	local tmpBlip = AddBlipForCoord(x, y, z)
	
	SetBlipSprite(tmpBlip, 1)
	SetBlipColour(tmpBlip, 66)
	SetBlipAsShortRange(tmpBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U("dst_blip"))
	EndTextCommandSetBlipName(blip)
	SetBlipAsMissionCreatorBlip(tmpBlip, true)
	SetBlipRoute(tmpBlip, true)
	
	return tmpBlip
end

-- Let the player carry something

function ForceCarryAnimation()
	TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
end



--------------------------------------------------------------------------------------------------------

--TRABAJAR AQUI!





function StartDelivery(deliveryType)
	TriggerServerEvent("esx_deliveries:removeSafeMoney:server", deliveryType)
end

-- Check is the player in the delivery vehicle

function IsPlayerInsideDeliveryVehicle()
	if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
		local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if playerVehicle == CurrentVehicle then
			return true
		end
	end
	return false
end

-- Is this checkpoint the last checkpoint?

function IsLastDelivery()
	local isLast = false
	local dp1    = DeliveryLocation.Item2
	local dp2    = DeliveryRoutes[#DeliveryRoutes].Item2
	if dp1.x == dp2.x and dp1.y == dp2.y and dp1.z == dp2.z then
		isLast = true
	end
	return isLast
end

-- Remove all object from the player ped

function RemovePlayerProps()
	for i = 0, #CurrentAttachments do
		DetachEntity(CurrentAttachments[i])
		DeleteEntity(CurrentAttachments[i])
	end
	ClearPedTasks(GetPlayerPed(-1))
	CurrentAttachments = {}
end

-- Spawn an object and attach it to the player

function GetPlayerPropsForDelivery(deliveryType)
	
	RequestAnimDict("anim@heists@box_carry@")
	while not HasAnimDictLoaded("anim@heists@box_carry@") do
		Citizen.Wait(0)
	end
		
	if deliveryType == 'scooter' then
		local ModelHash = GetHashKey("prop_paper_bag_01")
		local PlayerPed = GetPlayerPed(-1)
		local PlayerPos = GetEntityCoords(PlayerPed)
		
		if not HasModelLoaded(ModelHash) then
			
			WaitModelLoad(ModelHash)
			
			local Object = CreateObject(ModelHash, PlayerPos.x, PlayerPos.y, PlayerPos.z, true, true, false)
			
			AttachEntityToEntity(Object, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.25, 0.0, 0.06, 65.0, -130.0, -65.0, true, true, false, true, 0, true)
			table.insert(CurrentAttachments, Object)
		end
	end
	
	if deliveryType == 'van' then
		TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
		
		local Rand      = GetRandomFromRange(1, #Config.VanGoodsPropNames)
		local ModelHash = GetHashKey(Config.VanGoodsPropNames[Rand])
		
		WaitModelLoad(ModelHash)
		
		local PlayerPed = GetPlayerPed(-1)
		local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 0.0, -5.0)
		local Object = CreateObject(ModelHash, PlayerPos.x, PlayerPos.y, PlayerPos.z, true, false, false)
		
		AttachEntityToEntity(Object, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, 0.0, -0.55, 0.0, 0.0, 90.0, true, false, false, true, 1, true)
		table.insert(CurrentAttachments, Object)
	end
	
	if deliveryType == 'truck' then
		TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
		
		local ModelHash = GetHashKey("prop_sacktruck_02b")
		
		WaitModelLoad(ModelHash)
		
		local PlayerPed = GetPlayerPed(-1)
		local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 0.0, -5.0)
		local Object = CreateObject(ModelHash, PlayerPos.x, PlayerPos.y, PlayerPos.z, true, false, false)
		
		AttachEntityToEntity(Object, PlayerPed, GetEntityBoneIndexByName(PlayerPed, "SKEL_Pelvis"), -0.075, 0.90, -0.86, -20.0, -0.5, 181.0, true, false, false, true, 1, true)
		table.insert(CurrentAttachments, Object)
	end
	
	local JobData = (FinishedJobs + 1) / #DeliveryRoutes
	
	if JobData >= 0.5 and #CurrentVehicleAttachments > 2 then
		DetachEntity(CurrentVehicleAttachments[1])
		DeleteEntity(CurrentVehicleAttachments[1])
		table.remove(CurrentVehicleAttachments, 1)
	end
	if JobData >= 1.0 and #CurrentVehicleAttachments > 1 then
		DetachEntity(CurrentVehicleAttachments[1])
		DeleteEntity(CurrentVehicleAttachments[1])
		table.remove(CurrentVehicleAttachments, 1)
	end
end

function SpawnDeliveryVehicle(deliveryType, vehicle)	
	local Rnd           = GetRandomFromRange(1, #Config.ParkingSpawns)
	local SpawnLocation = Config.ParkingSpawns[Rnd]	
	CurrentVehicle = vehicle
	if deliveryType == 'truck' then
		SetVehicleLivery(CurrentVehicle, 2)
	end	
	if deliveryType == 'van' then
		SetVehicleExtra(CurrentVehicle, 2, false)
		SetVehicleLivery(CurrentVehicle, 0)
		SetVehicleColours(CurrentVehicle, 0, 0)
	end
	
	DecorSetInt(CurrentVehicle, "Delivery.Rental", Config.DecorCode)
	SetVehicleOnGroundProperly(CurrentVehicle)
	
	if deliveryType == 'scooter' then
		local ModelHash = GetHashKey("prop_med_bag_01")
		WaitModelLoad(ModelHash)
		local Object = CreateObject(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, true, false, false)
		AttachEntityToEntity(Object, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "misc_a"), 0.0, -0.55, 0.45, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
		table.insert(CurrentVehicleAttachments, Object)
	end
	
	if deliveryType == 'van' then
		local ModelHash1 = GetHashKey("prop_crate_11e")
		local ModelHash2 = GetHashKey("prop_cardbordbox_02a")
		WaitModelLoad(ModelHash1)
		WaitModelLoad(ModelHash2)
		local Object1 = CreateObject(ModelHash1, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, false, false, false)
		local Object2 = CreateObject(ModelHash1, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, false, false, false)
		local Object3 = CreateObject(ModelHash2, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, false, false, false)
		AttachEntityToEntity(Object1, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "chassic"), 0.25, -1.55, -0.12, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
		AttachEntityToEntity(Object2, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "chassic"), -0.26, -1.55, 0.2, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
		AttachEntityToEntity(Object3, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "chassic"), -0.26, -1.55, -0.12, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
		table.insert(CurrentVehicleAttachments, Object1)
		table.insert(CurrentVehicleAttachments, Object2)
		table.insert(CurrentVehicleAttachments, Object3)
	end
end

function GetNextDeliveryPoint(firstTime)
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)
	end
	
	for i = 1, #DeliveryComplete do
		if not DeliveryComplete[i] then
			if not firstTime then
				DeliveryComplete[i] = true
				break
			end
		end
	end
	
	for i = 1, #DeliveryComplete do
		if not DeliveryComplete[i] then
			CurrentBlip = CreateBlipAt(DeliveryRoutes[i].Item1.x, DeliveryRoutes[i].Item1.y, DeliveryRoutes[i].Item1.z)
			DeliveryLocation = DeliveryRoutes[i]
			break
		end
	end
end

-- Create some random destinations

function CreateRoute(deliveryType)
	
	local TotalDeliveries = GetRandomFromRange(Config.Deliveries.min, Config.Deliveries.max)
	local DeliveryPoints = {}
	
	if deliveryType == 'scooter' then
		DeliveryPoints = Config.DeliveryLocationsScooter
	elseif deliveryType == 'van' then
		DeliveryPoints = Config.DeliveryLocationsVan
	else
		DeliveryPoints = Config.DeliveryLocationsTruck
	end
	
	while #DeliveryRoutes < TotalDeliveries do
		Wait(1)
		local PreviousPoint = nil
		if #DeliveryRoutes < 1 then
			PreviousPoint = GetEntityCoords(GetPlayerPed(-1))
		else
			PreviousPoint = DeliveryRoutes[#DeliveryRoutes].Item1
		end
		
		local Rnd             = GetRandomFromRange(1, #DeliveryPoints)
		local NextPoint       = DeliveryPoints[Rnd]
		local HasPlayerAround = false
		
		for i = 1, #DeliveryRoutes do
			local Distance = GetDistanceBetweenCoords(NextPoint.Item1.x, NextPoint.Item1.y, NextPoint.Item1.z, DeliveryRoutes[i].x, DeliveryRoutes[i].y, DeliveryRoutes[i].z, true)
			if Distance < 50 then
				HasPlayerAround = true
			end
		end
		
		if not HasPlayerAround then
			table.insert(DeliveryRoutes, NextPoint)
			table.insert(DeliveryComplete, false)
		end
	end
end

-- Create a blip to tell the player back to the delivery hub

function ReturnToBase(deliveryType)
	CurrentBlip = CreateBlipAt(Config.Base.retveh.x, Config.Base.retveh.y, Config.Base.retveh.z)
end

-- End Delivery, is the player finish or failed?

function EndDelivery()
	local PlayerPed = GetPlayerPed(-1)
	if not IsPedSittingInAnyVehicle(PlayerPed) or GetVehiclePedIsIn(PlayerPed) ~= CurrentVehicle then
		TriggerEvent("MpGameMessage:send", _U("delivery_end"), _U("delivery_failed"), 3500, 'error')
		FinishDelivery(CurrentType, false)
	else
		TriggerEvent("MpGameMessage:send", _U("delivery_end"), _U("delivery_finish"), 3500, 'success')
		ReturnVehicle(CurrentType)
	end
end

-- Return the vehicle to system

function ReturnVehicle(deliveryType)
	SetVehicleAsNoLongerNeeded(CurrentVehicle)
	DeleteEntity(CurrentVehicle)
	ESX.ShowNotification(_U("delivery_vehicle_returned"))
	FinishDelivery(deliveryType, true)
end

-- When the delivery mission finish

function FinishDelivery(deliveryType, safeReturn)
	if CurrentVehicle ~= nil then
		for i = 0, #CurrentVehicleAttachments do
			DetachEntity(CurrentVehicleAttachments[i])
			DeleteEntity(CurrentVehicleAttachments[i])
		end
		CurrentVehicleAttachments = {}
		DeleteEntity(CurrentVehicle)
	end
	
	CurrentStatus    = Status.DELIVERY_INACTIVE
	CurrentVehicle   = nil
	CurrentSubtitle  = nil
	FinishedJobs     = 0
	DeliveryRoutes   = {}
	DeliveryComplete = {}
	DeliveryLocation = {}
	
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)
	end
	
	CurrentBlip = nil
	CurrentType = ''
	
	TriggerServerEvent("esx_deliveries:returnSafe:server", deliveryType, safeReturn)
	
	LoadDefaultPlayerSkin()
end

-- Some helpful functions

function DisplayHelpText(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function GetRandomFromRange(a, b)
	return GetRandomIntInRange(a, b)
end

function WaitModelLoad(name)
	RequestModel(name)
	while not HasModelLoaded(name) do
		Wait(0)
	end
end

function Draw2DTextCenter(x, y, text, scale)
    SetTextFont(0)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
	SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Initialize ESX

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
	Wait(1000)
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(10)
	end
	TriggerServerEvent("esx_deliveries:getPlayerJob:server")
end)

-- Main thread

Citizen.CreateThread(function()
	blip = AddBlipForCoord(Config.Base.coords.x, Config.Base.coords.y, Config.Base.coords.z)
	SetBlipSprite(blip, 568)
	SetBlipColour(blip, 17)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)

-- The other 4 threads

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HandleInput()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HandleLogic()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HandleMarkers()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerJob == "delivery" then
			if CurrentSubtitle ~= nil then
				Draw2DTextCenter(0.5, 0.88, CurrentSubtitle, 0.7)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

-- Register events and handlers

RegisterNetEvent('esx:setJob')
RegisterNetEvent('esx_deliveries:setPlayerJob:client')
RegisterNetEvent('esx_deliveries:startJob:client')

AddEventHandler('esx:setJob', function(job)
	PlayerJob = job.name
end)

AddEventHandler('esx_deliveries:setPlayerJob:client', function(job)
	PlayerJob = job
end)

AddEventHandler('esx_deliveries:startJob:client', function(deliveryType, netVeh)
	TriggerEvent("MpGameMessage:send", _U("delivery_start"), _U("delivery_tips"), 3500, 'success')
	local vehicle = NetToVeh(netVeh)
	while not DoesEntityExist(vehicle) do 
		vehicle = NetToVeh(netVeh)
		Citizen.Wait(100) 
	end
	CurrentVehicle = vehicle
	LoadWorkPlayerSkin(deliveryType)
	local ModelHash = GetHashKey("prop_paper_bag_01")
	WaitModelLoad(ModelHash)
	--SpawnDeliveryVehicle(deliveryType)
	CreateRoute(deliveryType)
	GetNextDeliveryPoint(true)
	CurrentType   = deliveryType
	CurrentStatus = Status.PLAYER_STARTED_DELIVERY
end)

ESX                     = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint, DriveErrors = 0, 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil
local teacherEntity = nil
local canDoTest = false
local imgName = "drive_teacher.png"
local messageTitle = "Autoescuela"
local teacherModel = 'ig_tomepsilon'
showTeacherMessages = false
local controlEnabled = false

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    local teacher = {["x"] = 214.47, ["y"] = -1400.29, ["z"] = 29.58, ["h"] = 320.85}
    local hash = GetHashKey(teacherModel)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(60)
    end
    if not DoesEntityExist(teacherPed) then
        teacherPed = CreatePed(4, hash, teacher["x"], teacher["y"], teacher["z"], teacher["h"])
        teacherEntity = teacherPed
        SetEntityAsMissionEntity(teacherPed)
        SetBlockingOfNonTemporaryEvents(teacherPed, true)
        FreezeEntityPosition(teacherPed, true)
        SetEntityInvincible(teacherPed, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if DoesEntityExist(teacherEntity) then
            DeletePed(teacherEntity)
            SetPedAsNoLongerNeeded(teacherEntity)
        end
    end
end)

Citizen.CreateThread(function()
    local resetSpeedOnEnter = true
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerPed,false)
        if DoesEntityExist(vehicle) then
            if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then

                -- This should only happen on vehicle first entry to disable any old values
                if resetSpeedOnEnter then
                    maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                    resetSpeedOnEnter = false
                end
                -- Disable speed limiter
                if IsControlJustReleased(0,246) then
                    if controlEnabled then
                        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                        SetEntityMaxSpeed(vehicle, maxSpeed)
                        ESX.ShowNotification("Velocidad de crucero desactivada")
                        controlEnabled = false
                    else
                        cruise = GetEntitySpeed(vehicle)
                        SetEntityMaxSpeed(vehicle, cruise)
                        cruise = math.floor(cruise * 3.6 + 0.5)
                        ESX.ShowNotification("Velocidad de crucero establecida en ~g~"..cruise.." km/h.")
                        controlEnabled = true
                    end
                end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	SendNUIMessage({
		openQuestion = true
	})

	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)
end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
		TriggerServerEvent('esx_dmvschool:addLicense', 'dmv')
		TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "testOk")
	else
		ESX.ShowNotification(_U('failed_test'))
	end
	local playerPed = PlayerPedId()

	DisableControlAction(0, 1, false) -- LookLeftRight
	DisableControlAction(0, 2, false) -- LookUpDown
	DisablePlayerFiring(playerPed, false) -- Disable weapon firing
	DisableControlAction(0, 142, false) -- MeleeAttackAlternate
	DisableControlAction(0, 106, false) 
	canDoTest = false
end

RegisterNetEvent("esx_dmvschool:startDriveTestClient")
AddEventHandler("esx_dmvschool:startDriveTestClient", function(netVeh, testType)
	local vehicle = NetToVeh(netVeh)
	while not DoesEntityExist(vehicle) do
		Citizen.Wait(100)
		vehicle = NetToVeh(netVeh)
	end
	StartDriveTest(testType, vehicle)
end)

function StartDriveTest(type, vehicle)
	CurrentTest       = 'drive'
	CurrentTestType   = type
	CurrentCheckPoint = 0
	LastCheckPoint    = -1
	CurrentZoneType   = 'residence'
	DriveErrors       = 0
	IsAboveSpeedLimit = false
	CurrentVehicle    = vehicle
	LastVehicleHealth = GetEntityHealth(CurrentVehicle)

	if CurrentTestType == "drive" then
		showTeacherMessages = true
	else
		showTeacherMessages = false
	end

	local playerPed   = PlayerPedId()
	TaskWarpPedIntoVehicle(playerPed, CurrentVehicle, -1)
	SetVehicleFuelLevel(CurrentVehicle, 100.0)
	DecorSetFloat(CurrentVehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(CurrentVehicle))
	if CurrentTestType ~= "drive_bike" then
		spawnTeacherInCar(CurrentVehicle)
	end
	TriggerServerEvent('esx_dmvschool:pay', Config.Prices[type])
	Citizen.Wait(500)
	if showTeacherMessages then
		TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "hello")
	end
end

local localTeacher = nil

function spawnTeacherInCar(currentVehicle)
	Citizen.CreateThread(function()
	    hash = GetHashKey(teacherModel)
	    RequestModel(hash)
	    local vehCoords = GetEntityCoords(currentVehicle)
	    while not HasModelLoaded(hash) do
			Citizen.Wait(10)
		end
	    if not DoesEntityExist(localTeacher) then
	        localTeacher = CreatePed(4, hash, vehCoords.x, vehCoords.y, vehCoords.z, 0.0)
	        SetEntityAsMissionEntity(localTeacher)
	        SetBlockingOfNonTemporaryEvents(localTeacher, true)
	        FreezeEntityPosition(localTeacher, true)
	        SetEntityInvincible(localTeacher, true)
	    end
	    SetModelAsNoLongerNeeded(hash)
	    TaskWarpPedIntoVehicle(localTeacher, currentVehicle, 0)
	end)
end


function StopDriveTest(success)
	local playerPed = PlayerPedId()
	DoScreenFadeOut(300)
	if DoesEntityExist(localTeacher) then
		DeletePed(localTeacher)
		SetPedAsNoLongerNeeded(localTeacher)
	end
	if DoesEntityExist(CurrentVehicle) then
		TriggerServerEvent("esx_dmvschool:stopDriveTest", VehToNet(CurrentVehicle))
	end
    Citizen.Wait(350)
    ESX.Game.Teleport(playerPed, vector3(219.596, -1389.862, 30.587))
    SetEntityHeading(playerPed, 320.545)
    Citizen.Wait(450)
    DoScreenFadeIn(300)
    if DoesBlipExist(CurrentBlip) then
		RemoveBlip(CurrentBlip)
	end
	if success then
		TriggerServerEvent('esx_dmvschool:addLicense', CurrentTestType)
		if showTeacherMessages then
			TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "practiceSuccess")
		end
	else
		ESX.ShowNotification(_U('failed_test'))
	end

	CurrentTest     = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
CurrentZoneType = type
end

function OpenDMVSchoolMenu()
	local ownedLicenses = {}

	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end

	local elements = {}

	if not ownedLicenses['dmv'] then
		table.insert(elements, {
			label = (('%s: <span style="color:green;">%s</span>'):format(_U('theory_test'), _U('school_item', ESX.Math.GroupDigits(Config.Prices['dmv'])))),
			value = 'theory_test'
		})
	end

	if ownedLicenses['dmv'] then
		if not ownedLicenses['drive'] then
			table.insert(elements, {
				label = (('%s: <span style="color:green;">%s</span>'):format(_U('road_test_car'), _U('school_item', ESX.Math.GroupDigits(Config.Prices['drive'])))),
				value = 'drive_test',
				type = 'drive'
			})
		end

		if not ownedLicenses['drive_bike'] then
			table.insert(elements, {
				label = (('%s: <span style="color:green;">%s</span>'):format(_U('road_test_bike'), _U('school_item', ESX.Math.GroupDigits(Config.Prices['drive_bike'])))),
				value = 'drive_test',
				type = 'drive_bike'
			})
		end

		if not ownedLicenses['drive_truck'] then
			table.insert(elements, {
				label = (('%s: <span style="color:green;">%s</span>'):format(_U('road_test_truck'), _U('school_item', ESX.Math.GroupDigits(Config.Prices['drive_truck'])))),
				value = 'drive_test',
				type = 'drive_truck'
			})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dmvschool_actions', {
		title    = _U('driving_school'),
		elements = elements,
		align    = 'left'
	}, function(data, menu)
		if data.current.value == 'theory_test' then
			if not canDoTest then
				menu.close()
				canDoTest = true
				ESX.ShowNotification("Utiliza cualquier ~g~PUPITRE~w~ del aula para realizar el test")
				TriggerServerEvent('esx_dmvschool:pay', Config.Prices['dmv'])
			else
				menu.close()
				ESX.ShowNotification("Ya has ~g~PAGADO~w~ el test, usa los pupitres del aula para realizar el examen")
			end			
		elseif data.current.value == 'drive_test' then
			menu.close()
			TriggerServerEvent("esx_dmvschool:startDriveTest", data.current.type)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})

	cb()
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb()
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb()
end)

RegisterNetEvent('esx_dmvschool:loadLicenses')
AddEventHandler('esx_dmvschool:loadLicenses', function(licenses)
	Licenses = licenses
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

	SetBlipSprite (blip, 498)
	SetBlipColour(blip, 39)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('driving_school_blip'))
	EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("esx_dmvschool:openMenu_ui")
AddEventHandler("esx_dmvschool:openMenu_ui", function()
	OpenDMVSchoolMenu()
end)

RegisterNetEvent("esx_dmvschool:test_ui")
AddEventHandler("esx_dmvschool:test_ui", function()
	if canDoTest then
		local playerPed = PlayerPedId()

		DisableControlAction(0, 1, true) -- LookLeftRight
		DisableControlAction(0, 2, true) -- LookUpDown
		DisablePlayerFiring(playerPed, true) -- Disable weapon firing
		DisableControlAction(0, 142, true) -- MeleeAttackAlternate
		DisableControlAction(0, 106, true) 
		StartTheoryTest()
	else
		ESX.ShowNotification('No puedes hacer el examen teorico por que no has ~r~PAGADO~w~ o ya lo ~g~TIENES~w~')
	end
end)

-- Drive test
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentTest == 'drive' then
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				ESX.ShowNotification(_U('driving_test_complete'))

				if DriveErrors < Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else

				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 30.0 then
					DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(1000)
		end
	end
end)

-- Speed / Damage control
canPlayDamage = true
canPlaySpeed = true
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentTest == 'drive' then

			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then

				local vehicle      = GetVehiclePedIsIn(playerPed, false)
				local vehicleClass = GetVehicleClass(vehicle)
				local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k,v in pairs(Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true

						if not IsAboveSpeedLimit then
							DriveErrors       = DriveErrors + 1
							IsAboveSpeedLimit = true
							if canPlaySpeed and not Config.PlayingSound then
								if showTeacherMessages then
									TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "speedLimit")
								end
								canPlaySpeed = false
							end
							ESX.ShowNotification(_U('driving_too_fast', v))
							ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors))
						end
					end
				end

				if DriveErrors >= Config.MaxErrors then
					StopDriveTest(false)
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				local health = GetEntityHealth(vehicle)
				if health < LastVehicleHealth then

					DriveErrors = DriveErrors + 1
					if canPlayDamage and not Config.PlayingSound and vehicleClass ~= 13 then
						if showTeacherMessages then
							TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "crash")
						end
						canPlayDamage = false
					end

					ESX.ShowNotification(_U('you_damaged_veh'))
					ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors))

					-- avoid stacking faults
					LastVehicleHealth = health
					Citizen.Wait(1500)
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(1500)
		end
	end
end)

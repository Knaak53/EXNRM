ESX          = nil
local IsDead = false
local IsAnimated = false
local hasInjected = false
local morphineTimer = 0

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

RegisterNetEvent('esx_basicneeds:drinkAlcohol')
AddEventHandler('esx_basicneeds:drinkAlcohol', function(level, prop_name)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		local boneIndex = GetPedBoneIndex(playerPed, 18905)
		AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
		ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

			Citizen.Wait(3000)
			IsAnimated = false
			ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
		Citizen.Wait(30000)
		if level == 0 then

	      RequestAnimSet("move_m@drunk@slightlydrunk")
	      
	      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
	        Citizen.Wait(0)
	      end

	      SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)

	    elseif level == 1 then

	      RequestAnimSet("move_m@drunk@moderatedrunk")
	      
	      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
	        Citizen.Wait(0)
	      end

	      SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)

	    elseif level == 2 then

	      RequestAnimSet("move_m@drunk@verydrunk")
	      
	      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
	        Citizen.Wait(0)
	      end

	      SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)

	    end

	    SetTimecycleModifier("spectator5")
	    SetPedMotionBlur(playerPed, true)
	    SetPedIsDrunk(playerPed, true)
	    Citizen.Wait(120000)

	    DoScreenFadeOut(800)
	    Wait(1000)

	    ClearTimecycleModifier()
	    ResetScenarioTypesEnabled()
	    ResetPedMovementClipset(playerPed, 0)
	    SetPedIsDrunk(playerPed, false)
	    SetPedMotionBlur(playerPed, false)

	    DoScreenFadeIn(800)
	end)	
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('esx_status:loaded', function(status)
	TriggerEvent('esx_status:registerStatus', 'hunger', 700000, '#CFAD0F', function(status)
		return Config.Visible
	end, function(status)
		status.remove(75)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 700000, '#0C98F1', function(status)
		return Config.Visible
	end, function(status)
		status.remove(100)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			if health ~= prevHealth then
				SetEntityHealth(playerPed, health)
			end
		end
	end)
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

------------------------------------------- Start of Binoculars -----------------------------------------------


local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local binoculars = false
local fov = (fov_max+fov_min)*0.5

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed)

		if binoculars then
			binoculars = true
			if not (IsPedSittingInAnyVehicle(playerPed)) then
				Citizen.CreateThread(function()
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
					PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
				end)
			end

			Wait(2000)

			SetTimecycleModifier("default")
			SetTimecycleModifierStrength(0.3)

			local scaleform = RequestScaleformMovie("BINOCULARS")

			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(10)
			end

			local playerPed = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(playerPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(cam, playerPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(playerPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()

			while binoculars and not IsEntityDead(playerPed) and (GetVehiclePedIsIn(playerPed) == vehicle) and true do
				if IsControlJustPressed(0, 38) then -- Toggle binoculars
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ClearPedTasks(GetPlayerPed(-1))
					binoculars = false
				end

				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
				CheckInputRotation(cam, zoomvalue)

				HandleZoom(cam)
				HideHUDThisFrame()

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(5)
			end

			binoculars = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		else
			Citizen.Wait(750)
		end
	end
end)

RegisterNetEvent('esx_extraitems:binoculars')
AddEventHandler('esx_extraitems:binoculars', function()
	binoculars = not binoculars
end)

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
	HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)

	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local playerPed = GetPlayerPed(-1)

	if not (IsPedSittingInAnyVehicle(playerPed)) then
		if IsControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end

		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end

		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end

		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end

		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end

		local current_fov = GetCamFov(cam)

		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end

		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end


------------------------------------------- End of Binoculars -----------------------------------------------



------------------------------------------- start of chaleco antibalas -----------------------------------------------

RegisterNetEvent('esx_extraitems:bulletproof')
AddEventHandler('esx_extraitems:bulletproof', function()
	local playerPed = GetPlayerPed(-1)

	SetPedComponentVariation(playerPed, 9, 27, 9, 2)
	AddArmourToPed(playerPed, 50)
	SetPedArmour(playerPed, 50)
end)

------------------------------------------- End of chaleco antibalass -----------------------------------------------

------------------------------------------- start of  morfina -----------------------------------------------

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

--Morphine
RegisterNetEvent('OurStoryMorphine:inject')
AddEventHandler('OurStoryMorphine:inject', function()
	prop_name = 'p_syringe_01_s'
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		local boneIndex = GetPedBoneIndex(playerPed, 18905)
		AttachEntityToEntity(prop, playerPed, boneIndex, 0.14, 0.03, 0.02, -50.0, 130.0, -.0, true, true, false, true, 1, true)
		loadAnimDict('mp_arresting')
		TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 49, 0, 0, 0, 0)
		SetPedMoveRateOverride(PlayerId(),10.0)
		SetRunSprintMultiplierForPlayer(PlayerId(),1.03)
		SetSwimMultiplierForPlayer(PlayerId(),1.06)
		Citizen.Wait(1200)
		Citizen.Wait(2500)
		ClearPedSecondaryTask(playerPed)
		DeleteObject(prop)
		ClearAllPedProps(prop)
		ClearPedTasks(playerPed)
		if hasInjected == false then
			hasInjected = true
			while morphineTimer < 1800 do -- 1800 seconds
				morphineTimer = morphineTimer + 1
				local HP = GetEntityHealth(PlayerPedId())
				HP = HP + 1
				SetEntityHealth(PlayerPedId(), HP)
				Citizen.Wait(1000)
			end
			if hasInjected == true then
				hasInjected = false
				morphineTimer = 0
				SetPedMoveRateOverride(PlayerId(),10.0)
				SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
				SetSwimMultiplierForPlayer(PlayerId(),1.0)
			end
		else
		end
	end)
end)

------------------------------------------- end of  morfina -----------------------------------------------

------------------------------------------- start of  adrenalina -----------------------------------------------

RegisterNetEvent("esx_optionalneeds:onAdrenaline")
AddEventHandler("esx_optionalneeds:onAdrenaline", function()
	prop_name = 'p_syringe_01_s'
    local playerPed = GetPlayerPed(-1)
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
	local boneIndex = GetPedBoneIndex(playerPed, 18905)
	AttachEntityToEntity(prop, playerPed, boneIndex, 0.14, 0.03, 0.02, -50.0, 130.0, -.0, true, true, false, true, 1, true)
	loadAnimDict('mp_arresting')
	TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 49, 0, 0, 0, 0)
	Citizen.Wait(1200)
	Citizen.Wait(2500)
	ClearPedSecondaryTask(playerPed)
	DeleteObject(prop)
	ClearAllPedProps(prop)
	ClearPedTasks(playerPed)
	TriggerEvent('esx_optionalneeds:adrenaline')
    ESX.ShowNotification('Te has inyectado adrenalina!') -- usage notification // English: "Everything is crystal clear now."
end)

-------------EFEKTLER---------------
local hizliKos = false -- hızlı koşma var // this is for fast run
local yavasKos = false -- yavaş koşma var // this is for slow run



Citizen.CreateThread(function()           -- yavaş koşma için call // check if slow run activated
    while true do
      Citizen.Wait(16)
      local oyavaohizi = false
      if yavasKos then
      	oyavaohizi = true
        SetPedMoveRateOverride(PlayerPedId(), 0.1) -- you can edit this ratio : values above 1.0 make charater move faster / values belowe 1.0 make charater slower / 1.0 is default speed - This makes characters movement faster, which means even your walking speed
      end
      if hizliKos then
      	oyavaohizi = true
        SetPedMoveRateOverride(PlayerPedId(), 1.050) -- you can edit this ratio : values above 1.0 make charater move faster / values belowe 1.0 make charater slower / 1.0 is default speed - This makes characters movement faster, which means even your walking speed
      end
      if not oyavaohizi then
      	Citizen.Wait(750)
      end
    end
  end)

--Agresif ve Sınırsız Stamina
RegisterNetEvent("esx_optionalneeds:adrenaline")
AddEventHandler("esx_optionalneeds:adrenaline", function()
    local count = 0

    SetPedMotionBlur(GetPlayerPed(-1), true) -- Adds very little blur effect
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetTimecycleModifier("underwater_deep")  -- Display filter to make it funnier and realistic
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.35)   -- This ratio is for sprinting speed not movement speed so it will only effective when your character sprints, max is 1.49 / aboe 1.49 won't effect speed
    hizliKos = true  -- activites fast movement (not sprinting speed but overall speed)

    DoScreenFadeIn(1000)
	repeat  -- Start of the cycle
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)   -- Shaking cam effect
    RestorePlayerStamina(PlayerId(), 1.0)   -- This is for resetting stamina
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
    Citizen.Wait(2000)
		count = count  + 1
	until count == 9  -- One cycle takes 10 seconds, if you put 15 in this value adrenaline effect will take 150 seconds
    hizliKos = false  -- deactivates speed
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier() -- clears display filter
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0) -- sets sprint speed to defualt
    SetPedMotionBlur(GetPlayerPed(-1), false) -- removes blur
    count = 0  -- sets cylce count to 0 for next usage
    ESX.ShowNotification('Sientes los efectos secundarios de la adrenalina...') -- sends notification when effect is over // English : "You are exhausted, slowing down..."
    yavasKos = true  -- sets speed to very slow to animiate exhausting effect
    Citizen.Wait(30000)  -- this values determines how long the exhausting effect // value is in miliseconds
    yavasKos = false -- removes slow speed
    ESX.ShowNotification('Ya no sientes los efectos secundarios de la adrenalina.') -- show notification that you are now feeling okay // English : "You are feeling okay."
end)

------------------------------------------- end of  adrenalina -----------------------------------------------
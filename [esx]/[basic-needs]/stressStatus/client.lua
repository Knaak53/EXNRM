ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local sadwalking = false
AddEventHandler('esx_status:loaded', function(status)
    TriggerEvent('esx_status:registerStatus', 'stress', 100, '#cadfff', function(status)
		return false
	end, function(status)
		status.add(5)
	end)

    Citizen.CreateThread(function()
		while true do
            Citizen.Wait(0)
            local ped = PlayerPedId()

            TriggerEvent('esx_status:getStatus', 'stress', function(status)
				StressVal = status.val
            end)

            if StressVal == 1000000 then -- max StressVal
				SetTimecycleModifier("WATER_silty") -- hafif blurlanır ve görüş düşer // a bit blur and vision distance reduce
				SetTimecycleModifierStrength(1)
			else
				ClearExtraTimecycleModifier()
			end

            if StressVal >= 900000 then
				local veh = GetVehiclePedIsUsing(ped)
			  	if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then -- eğer oyuncu araçtaysa ve ayrıca o aracı kullanıyorsa // if ped "driving" a vehicle
					Citizen.Wait(1000)
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15) -- kamera sallanmaları // cam shake
					TaskVehicleTempAction(ped, veh, 7, 250) -- aracı hafif sola kırma // turn left a bit
					Citizen.Wait(500)
					TaskVehicleTempAction(ped, veh, 8, 250) -- aracı hafif sağa kırma // turn right a bit
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
					Citizen.Wait(1000)
                    --ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
                    TaskVehicleTempAction(ped, veh, 8, 250)
                  else
                    DisableControlAction(0, 22, true)
                    if not sadwalking then
                        sadWalk(ped)
                    end
                    --if IsPedJumping(ped) then
                    --    SetPedToRagdoll(ped, 500, 500, 0, 0, 0, 0)
                    --end
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.15)
			  	end
			elseif StressVal >= 800000 then
				local veh = GetVehiclePedIsUsing(ped)
			  	if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
					Citizen.Wait(1000)
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
					TaskVehicleTempAction(ped, veh, 7, 150)
					Citizen.Wait(500)
					
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
					Citizen.Wait(500)
                    --ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
                    TaskVehicleTempAction(ped, veh, 8, 150)
                  else
                    DisableControlAction(0, 22, true)
                    if not sadwalking then
                        sadWalk(ped)
                    end
                    
                    --if IsPedJumping(ped) then
                    --    SetPedToRagdoll(ped, 500, 500, 0, 0, 0, 0)
                    --else
                    --    if not IsEntityPlayingAnim(ped, "timetable@tracy@sleep@", "idle_c", 3) then
                    --        SetPedToRagdoll(ped, 500, 500, 0, 0, 0, 0)
                    --        Citizen.Wait(10000)
                    --    end
                    --end
                    --Citizen.Wait(500)
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.10)
			  	end
			elseif StressVal >= 700000 then
				local veh = GetVehiclePedIsUsing(ped)
			  	if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
					Citizen.Wait(1000)
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
					TaskVehicleTempAction(ped, veh, 7, 100)
					Citizen.Wait(500)
					TaskVehicleTempAction(ped, veh, 8, 100)
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
					Citizen.Wait(500)
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
                  else
                    DisableControlAction(0, 22, true)
                    if not sadwalking then
                        sadWalk(ped)
                    end
                    --if IsPedJumping(ped) then
                    --    SetPedToRagdoll(ped, 500, 500, 0, 0, 0, 0)
                    --    Citizen.Wait(6000)
                    --end
					--Citizen.Wait(500)
					--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
			  	end
			elseif StressVal >= 600000 then -- %60 altındayken araç sürüşüne bir etkisi olmuyor // Below ½60 no effect to driving
				Citizen.Wait(2500) -- sıklık // frequency
				--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.05) -- efekt // effect
			elseif StressVal >= 500000 then
				Citizen.Wait(3500)
				--ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.03)
            else
                sadWalk(ped , false)
                Citizen.Wait(3000)
            end
        end
    end)
end)

function sadWalk(ped, forcestate)
    Citizen.CreateThread(function() 
        sadwalking = not sadwalking
        if (forcestate ~= nil) then
            sadwalking = forcestate
        end
        while sadwalking do
            Wait(1750)
            if IsPedSprinting(ped) then
                ExecuteCommand("walk Armored")
            else
                ExecuteCommand("walk Sad")
            end
        end
    end)
end

Citizen.CreateThread(function() -- DeStress Zones
    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for k,v in pairs(Config.DeStressZones) do
            local distance = #(v.Location - pedCoords)
            if distance < v.Radius then
                TriggerServerEvent("stress:remove", v.StressQuantity)
            end
        end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function() -- Nişan almak // Aiming with a weapon
    while true do
        local ped = PlayerPedId()
        local status = GetPedConfigFlag(ped, 78, 1)

        if status then
            TriggerServerEvent("stress:add", 8000)
            Citizen.Wait(10000)
        else
            Citizen.Wait(50)
        end
    end
end)

Citizen.CreateThread(function() -- Elinde silah tutarken (melee ve patlayıcılar kategorisi hariç) // Holding a weapon (except melee and explosives category)
    while true do
        local ped = PlayerPedId()
        local status = IsPedArmed(ped, 4)

        if status then
            TriggerServerEvent("stress:add", 12000)
            Citizen.Wait(15000)
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function() -- Ateş ederken // While shooting
    while true do
        local ped = PlayerPedId()
        local status = IsPedShooting(ped)
        local silenced = IsPedCurrentWeaponSilenced(ped)

        if status and not silenced then
            TriggerServerEvent("stress:add", 16000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(50)
        end
    end
end)

Citizen.CreateThread(function() -- Silah, yumruk vs sesi duyarsa / çalışmıyor gibi, büyük ihtimal npc lerde çalışan bir şey çünkü sadece npc ler bu tür olaylara tepki veriyor // Heard gunshot, melee hit etc., seems not to work, since player peds don't act like NPC's ?
    while true do
        local ped = PlayerPedId()
        local status = GetPedAlertness(ped)

        if status == 1 then
            TriggerServerEvent("stress:add", 9000)
            Citizen.Wait(10000)
        else
            Citizen.Wait(50)
        end
    end
end)

Citizen.CreateThread(function() -- Yumruk atmak, yumruk yemek veya yakın mesafe silahı ile birine kitlenmek // Aiming with a melee, hitting with a melee or getting hit by a melee
    while true do
        local ped = PlayerPedId()
        local status = IsPedInMeleeCombat(ped)

        if status then
            TriggerServerEvent("stress:add", 7000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(750)
        end
    end
end)


Citizen.CreateThread(function() -- Can 100(yarı) altındayken BUNU DENEYİN, SORUNLU OLABİLİR // While healt is below 100(half) TEST THIS BEFORE USE, CAN GET PROBLEMATIC
    while true do
        local ped = PlayerPedId()
        local amount = (GetEntityHealth(ped)-100)

        if amount <= 50 then
            TriggerServerEvent("stress:add", 30000)
            --exports['mythic_notify']:SendAlert("error", "METİN BURAYA // TEXT HERE") -- Örnek mythic notify // Example mythic notify
            Citizen.Wait(60000)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function() -- Olduğun yerde kalmak veya yürümek // Staying still or walking
    while true do
        local ped = PlayerPedId()
        local status = IsPedStill(ped)
        local status_w = IsPedArmed(ped, 4)
        local status2 = IsPedWalking(ped)
		local status_v = IsPedInAnyVehicle(ped, false)

        if status and not status_w and not status_v and not GetPedStealthMovement(ped) then -- durmak // still
            Citizen.Wait(15000)
            TriggerServerEvent("stress:remove", 30000)
            Citizen.Wait(15000)
        elseif status2 and not status_w and not GetPedStealthMovement(ped) then -- yürümek // walking
            Citizen.Wait(15000)
            TriggerServerEvent("stress:remove", 10000)
            Citizen.Wait(15000)
        else
            Citizen.Wait(500)
        end
    end
end)

--[[Citizen.CreateThread(function() -- Paraşütle skydive // Skydiving with parachute
    while true do
        local ped = PlayerPedId()
        local status = GetPedParachuteState(ped)

        if status == 0 then -- paraşütle dalış // freefall with chute (not falling without it)
            TriggerServerEvent("stress:add", 60000)
            Citizen.Wait(5000)
        elseif status == 1 or status == 2 then -- paraşüt açık // opened chute
            TriggerServerEvent("stress:add", 5000)
            Citizen.Wait(5000)
        else
            Citizen.Wait(5000) -- kontrol hızı düşük çünkü paraşüt atlaması çok olan bir şey değil // refresh rate is low on this one since it's not so common to skydive in RP servers
        end
    end
end)]]--

Citizen.CreateThread(function() -- Gizli moda girmek // Stealth mode
    while true do
        local ped = PlayerPedId()
        local status = GetPedStealthMovement(ped)

        if status then
            TriggerServerEvent("stress:add", 5000)
            Citizen.Wait(8000)
        else
            Citizen.Wait(500) -- refresh rate
        end
    end
end)

--Citizen.CreateThread(function() -- uyuma animasyonu // Sleeping animation || Bunu stres ekleyici veya azaltıcı animasyonlar eklerken template olarak kullanabilirsiniz. // You can use this as a template if you want to make an animation stressful or stress reliever
--    while true do
--        local ped = PlayerPedId()
--        local status = IsEntityPlayingAnim(ped, "timetable@tracy@sleep@", "idle_c", 3)
--
--        if status then
--            Citizen.Wait(20000)
--            TriggerServerEvent("stress:remove", 200000)
--        else
--            Citizen.Wait(500) -- refresh rate
--        end
--    end
--end)


function AddStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:add", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:add", value/seconds)
            count = count + 1
            Citizen.Wait(1000)
        until count == seconds
    end
end

function RemoveStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:remove", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:remove", value/seconds)
            count = count + 1
            Citizen.Wait(1000)
        until count == seconds
    end
end
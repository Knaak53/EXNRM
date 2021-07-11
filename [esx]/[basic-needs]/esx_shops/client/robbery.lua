local robberyActive = false
local activeRobberyStore = nil
local activeRobberyEntity = 0
isThief = false
local canRegister = false
local alreadyRegisteredEntities = {}
local isLider = false
local bigPrizeTaken = false
local cashaTaken = false
local cashbTaken = false

RegisterNetEvent('esx_shops:tryStartRobbery')
AddEventHandler('esx_shops:tryStartRobbery', function()	
	Citizen.Wait(250)
	if not robberyActive then
		if IsPedArmed(PlayerPedId(), 4) then
			ESX.TriggerServerCallback("esx_shops:checkIfCanStartRobbery", function(canStartRobbery)
				if canStartRobbery then
					SendNUIMessage(
				        {
				            action = "startRobbery"
				        }
				    )
				    SetNuiFocus(true, true)  
				else
					ESX.ShowNotification("La empresa todavia no se ha recuperado del ultimo atraco, vuelve luego...")
				end
			end)
		else
			ESX.ShowNotification("Debes ir ~r~ARMADO~w~ para poder realizar un atraco.")
		end	
	else
		ESX.ShowNotification("Ya hay un atraco en curso.")
	end	 
end)

RegisterNUICallback("startRobbery", function(data, cb)
	SetNuiFocus(false, false) 
	isThief = true
	isLider = true
	serverUpdate(true)
end)

RegisterNetEvent('esx_shops:startClientRobbery')
AddEventHandler('esx_shops:startClientRobbery', function(activeRobberyStore)
	robberyActive = true
	canRegister = false
	startRobberyTimer()
	startDistanceCheck()
	if #(vector3(activeRobberyStore.blip.x, activeRobberyStore.blip.y, activeRobberyStore.blip.z) - GetEntityCoords(PlayerPedId())) < 60 then
  		extorsion(activeRobberyStore)
  	end
end)  

local blipTime = 40
local robberyBlip = nil

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("esx_shops:finishRobbery")
AddEventHandler("esx_shops:finishRobbery", function()
	if isThief then
		ESX.ShowNotification("El lider del atraco ha huido, ~r~EL ATRACO HA FINALIZADO~w~!")
	end
	finishRobbery()
end)

function startDistanceCheck()
	if isLider then
		Citizen.CreateThread(function()
			while robberyActive do
				Citizen.Wait(0)
				if #(GetEntityCoords(PlayerPedId()) - vector3(activeRobberyStore.blip.x, activeRobberyStore.blip.y, activeRobberyStore.blip.z)) < 20.0 then
					Citizen.Wait(1000)
				else
					TriggerServerEvent('esx_shops:finishRobbery')
				end			
			end
		end)
	end
end

RegisterNetEvent('esx_shops:stealComputer')
AddEventHandler('esx_shops:stealComputer', function()
	if not bigPrizeTaken then
		bigPrizeTaken = true;
		TriggerServerEvent('esx_shops:stealComputer')
	else
		ESX.ShowNotification("~r~Ya se ha robado la caja fuerte!")
	end
	
end)

RegisterNetEvent("esx_shops:cashTaken")
AddEventHandler('esx_shops:cashTaken', function(cashTaken)
	if cashTaken == "a" then
		cashaTaken = true;
	else
		cashbTaken = true;
	end
end)

RegisterNetEvent("esx_shops:alertCops")
AddEventHandler("esx_shops:alertCops", function(activeRobberyStore)	
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
		local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)

        if street1 ~= nil and street2 ~= nil then
	        ESX.ShowNotification("Han denunciado un atraco a una tienda entre ~r~" .. street1 .. "~w~ y ~r~" .. street2 .. "~w~.")
	    else
	        if street1 ~= nil then
	            ESX.ShowNotification("Han denunciado un atraco en ~r~" .. street1 .. "~w~.")
	        end
	        if street2 ~= nil then
	            ESX.ShowNotification("Han denunciado un atraco en ~r~" .. street2 .. "~w~.")
	        end
	    end

		robberyBlip = AddBlipForCoord(activeRobberyStore.blip.x, activeRobberyStore.blip.y, activeRobberyStore.blip.z)
		SetBlipSprite(robberyBlip,  313)
		SetBlipColour(robberyBlip,  1)
		SetBlipAsShortRange(robberyBlip,  false)
		BeginTextCommandSetBlipName("STRING")
      	AddTextComponentString("Tienda siendo atracada")
      	EndTextCommandSetBlipName(robberyBlip)
	end
end)      

function startRobberyTimer()
	Citizen.CreateThread(function()	
		Citizen.Wait(400000)
		finishRobbery()
	end)
end

function finishRobbery()
	robberyActive = false	
	canRegister = false
	isThief = false
	isLider = false
	bigPrizeTaken = false
	cashaTaken = false
	cashbTaken = false	
	ClearPedTasksImmediately(activeRobberyEntity)
	activeRobberyEntity = 0
	alreadyRegisteredEntities = {}
	shelfsAlreadyTaken = {}
	if DoesBlipExist(robberyBlip) then
		RemoveBlip(robberyBlip)
	end
	activeRobberyStore = nil
end

function startLootMarker()
	Citizen.CreateThread(function()
		while robberyActive and canRegister do
			Citizen.Wait(0)
			if #(GetEntityCoords(PlayerPedId()) - vector3(activeRobberyStore.blip.x, activeRobberyStore.blip.y, activeRobberyStore.blip.z)) < 12.0 then
				if not bigPrizeTaken then
					if activeRobberyStore.loot then
						DrawMarker(20, activeRobberyStore.loot.x, activeRobberyStore.loot.y, activeRobberyStore.loot.z, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.2, 0.2, 0.2, 255, 50, 0, 100, false, true, 2, true, false, false, false)
					end
				end
				if not cashaTaken then
					DrawMarker(20, activeRobberyStore.casha.x, activeRobberyStore.casha.y, activeRobberyStore.casha.z, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.2, 0.2, 0.2, 255, 50, 0, 100, false, true, 2, true, false, false, false)
				end
				if not cashbTaken then
					if activeRobberyStore.cashb then
						DrawMarker(20, activeRobberyStore.cashb.x, activeRobberyStore.cashb.y, activeRobberyStore.cashb.z, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 0.2, 0.2, 0.2, 255, 50, 0, 100, false, true, 2, true, false, false, false)
					end
				end	
			else
				Citizen.Wait(500)	
			end			
		end
	end)
end

RegisterNetEvent("esx_shops:npcSurrender")
AddEventHandler("esx_shops:npcSurrender", function()	
	if isThief then
		canRegister = true
		ESX.ShowNotification("El dependiente se ha rendido, puedes registrar la tienda y robar.")
		RequestAnimDict("random@arrests")
	 	while (not HasAnimDictLoaded("random@arrests")) do Citizen.Wait(0) end
		TaskPlayAnim(activeRobberyEntity, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		startLootMarker()
		SendNUIMessage(
	        {
	            action = "hideNpcLimitBar"
	        }
	    )
	end
end)

function isAbleToSteal(entity)
	for i = 1, #alreadyRegisteredEntities do
		if alreadyRegisteredEntities[i] == entity then
			return false
		end
	end
	return true
end

RegisterNetEvent('esx_shops:cashRegister')
AddEventHandler('esx_shops:cashRegister', function(entity, coords)	
	if isThief and canRegister then
		if isAbleToSteal(entity) then
			if #(vector3(activeRobberyStore.blip.x, activeRobberyStore.blip.y, activeRobberyStore.blip.z) - GetEntityCoords(PlayerPedId())) <= 12 then
				table.insert(alreadyRegisteredEntities, entity)
				stealCashRegister(entity, coords)	
			end
		else
			ESX.ShowNotification("Ya has vaciado esa caja registradora.")
		end	
	end
end)

RegisterNetEvent('esx_shops:openComputer')
AddEventHandler('esx_shops:openComputer', function(entity)	
	if isThief and canRegister and not bigPrizeTaken then
		local playerPed = PlayerPedId()
		makeEntityFaceEntity(playerPed, entity)
		TriggerEvent('esx_shops_codes:computer')
	end
end)

function stealCashRegister(entity, coords)
	Citizen.CreateThread(function()
		local registerNotCompleted = true
		local cashLimit = 0
		local playerPed = PlayerPedId()
		SendNUIMessage(
	        {
	            action = "npcLimitBar",
	            title = "Forzando caja registradora"
	        }
	    )
	    makeEntityFaceEntity(playerPed, entity)
	    RequestAnimDict("anim@amb@business@cfm@cfm_machine_oversee@")
	 	while (not HasAnimDictLoaded("anim@amb@business@cfm@cfm_machine_oversee@")) do Citizen.Wait(0) end
		TaskPlayAnim(playerPed, "anim@amb@business@cfm@cfm_machine_oversee@", "look_scared_operator", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		while registerNotCompleted do
	    	Citizen.Wait(250)
	    	cashLimit = cashLimit + 25
	    	if cashLimit >= 1200 then
	    		registerNotCompleted = false
				if activeRobberyStore.casha and activeRobberyStore.cashb then
					if #(activeRobberyStore.casha - coords) < #(activeRobberyStore.cashb - coords) then
						cashaTaken = true
						TriggerServerEvent("esx_shops:stealCashRegister", "a")
					else
						cashbTaken = true
						TriggerServerEvent("esx_shops:stealCashRegister", "b")
					end
				else
					cashaTaken = true
					TriggerServerEvent("esx_shops:stealCashRegister", "a")
				end		
			else
				SendNUIMessage(
			        {
			            action = "updateLimitBar",
			            current = cashLimit,
			            max = 1200
			        }
			    )
			end
	    end
	    SendNUIMessage(
	        {
	            action = "hideNpcLimitBar"
	        }
	    )
	    ClearPedTasksImmediately(playerPed)
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

function extorsion(activeRobberyStore)
	Citizen.CreateThread(function()	
		local aimed = false
		local npcLimit = 0
		entity, distance =  ESX.Game.GetClosestPed(vector3(activeRobberyStore.cashier.x, activeRobberyStore.cashier.y, activeRobberyStore.cashier.z))
		if DoesEntityExist(entity) then
			activeRobberyEntity = entity
		end
	    while robberyActive and not canRegister do
	    	Citizen.Wait(25)
	    	local aiming, targetEntity = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
	    	if aiming and targetEntity == activeRobberyEntity then
	    		if not aimed then
	    			if not isThief then
	    				isThief = true
	    				TriggerServerEvent("esx_shops:addThief")
	    			end
    				npcLimit = npcLimit + 25
	    			aimed = true
				 	RequestAnimDict("amb@code_human_cower_stand@male@react_cowering")
				 	while (not HasAnimDictLoaded("amb@code_human_cower_stand@male@react_cowering")) do Citizen.Wait(0) end
    				TaskPlayAnim(targetEntity,"amb@code_human_cower_stand@male@react_cowering","base_right",1.0,-1.0, -1, 1, 1, true, true, true)
	    			SendNUIMessage(
				        {
				            action = "npcLimitBar",
				            title = "Cordura del dependiente"
				        }
				    )
	    		else
    				npcLimit = npcLimit + 25
	    			if npcLimit >= 1900 then
	    				TriggerServerEvent("esx_shops:npcSurrenderServer")
	    				break
	    			else
	    				SendNUIMessage(
					        {
					            action = "updateLimitBar",
					            current = npcLimit,
					            max = 1900
					        }
					    )
					    Citizen.Wait(250)
	    			end
	    		end
	    	else
	    		Citizen.Wait(250)
	    	end
	    end
	end)
end

function serverUpdate(isStart)
	Citizen.CreateThread(function()
		if isStart then
			for i = 1, #Config.Locations do
		    	if #(vector3(Config.Locations[i].blip.x, Config.Locations[i].blip.y, Config.Locations[i].blip.z) - GetEntityCoords(PlayerPedId())) <= 12 then
		    		activeRobberyStore = Config.Locations[i]
		    		TriggerServerEvent('esx_shops:startRobbery', activeRobberyStore)
		    	end
		    end
		else
			robberyActive = false;
		end    
	end)
end


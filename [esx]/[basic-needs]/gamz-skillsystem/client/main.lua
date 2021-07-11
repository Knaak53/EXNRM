ESX = nil

Citizen.CreateThread(function()
	Citizen.CreateThread(function()
		while ESX == nil do
			ESX = exports.extendedmode:getSharedObject()
			Citizen.Wait(0)
		end
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)  
    Citizen.CreateThread(function()
    	FetchSkills() 
		Citizen.Wait(1000)
		while true do
			local seconds = Config.UpdateFrequency * 1000
			Citizen.Wait(seconds)
			
			for skill, value in pairs(Config.Skills) do
				UpdateSkill(skill, value["RemoveAmount"])
			end

			TriggerServerEvent("gamz-skillsystem:update", Config.Skills)
		end
	end)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(35000)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(ped)

		if exports.knatus_art_of_guitar:isPlaying() then
			UpdateSkill("Guitarra", 0.5)
		end
		if IsPedRunning(ped) then
			UpdateSkill("Resistencia", 0.3)
		elseif IsPedInMeleeCombat(ped) then
			UpdateSkill("Fuerza", 0.3)
		elseif IsPedSwimmingUnderWater(ped) then
			UpdateSkill("Capacidad Pulmonar", 2)
		elseif IsPedShooting(ped) then
			UpdateSkill("Tiro", 0.5)
		elseif DoesEntityExist(vehicle) then
			local speed = GetEntitySpeed(vehicle) * 3.6

			if GetVehicleClass(vehicle) == 8 or GetVehicleClass(vehicle) == 13 and speed >= 5 then
				local rotation = GetEntityRotation(vehicle)
				if IsControlPressed(0, 210) then
					if rotation.x >= 25.0 then
						UpdateSkill("Manejo", 1.5)
					end 
				end
			end
			if speed >= 80 then
				UpdateSkill("Conduccion", 1.0)
			end
		end
	end
end)
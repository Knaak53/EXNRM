ESX = nil

local resting = false
local membership = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.TriggerServerCallback('esx_gym:getGymMemberInfo', function(gymInfo)
    	membership = gymInfo.planActive
	end)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1200000)
			ESX.TriggerServerCallback('esx_gym:getGymMemberInfo', function(gymInfo)
		    	membership = gymInfo.planActive
			end)
		end
	end)
end)

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)
	
Citizen.CreateThread(function()
	blip = AddBlipForCoord(-1201.2257, -1568.8670, 4.6101)
	SetBlipSprite(blip, 311)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 7)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gimnasio de CityName")
	EndTextCommandSetBlipName(blip)
end)


--------------------------------------------------------------------------------------

								--GYM FUNCTIONS--

--------------------------------------------------------------------------------------

local gym_machines = {
	arms = {
		vector3(-1202.9837,-1565.1718, 4.6115)
	},
	pushup = {
		vector3(-1203.3242,-1570.6184, 4.6115)
	},
	yoga = {
		vector3(-1204.7958,-1560.1906, 4.6115)
	},
	situps = {
		vector3(-1206.1055,-1565.1589, 4.6115)
	},
	chins = {
		vector3(-1200.1284,-1570.9903, 4.6115)
	}
}

Citizen.CreateThread(function()
    while true do
    	local found = false
        Citizen.Wait(0)
        for k, v in pairs(gym_machines) do
        	for i = 1, #v do
        		if #(GetEntityCoords(PlayerPedId()) - v[i]) < 20 then
        			found = true
        			DrawMarker(21, v[i].x, v[i].y, v[i].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 0, 170, 200, 0, 1, 0, 0)
        		end	
        	end  
        end
        if not found then
        	Citizen.Wait(1000)
        end
    end
end)

function getHintToDisplay(machineType)
	if machineType == "arms" then
		return "Pulsa ~INPUT_CONTEXT~ para ejercitar los brazos"
	elseif machineType == "pushup" then
		return "Pulsa ~INPUT_CONTEXT~ para hacer flexiones"
	elseif machineType == "yoga" then
		return "Pulsa ~INPUT_CONTEXT~ para hacer yoga"
	elseif machineType == "situps" then
		return "Pulsa ~INPUT_CONTEXT~ para hacer abdominales"
	elseif machineType == "chins" then
		return "Pulsa ~INPUT_CONTEXT~ para hacer dominadas"
	end
end

function getScenarioForMachine(machineType)
	if machineType == "arms" then
		return "world_human_muscle_free_weights"
	elseif machineType == "pushup" then
		return "world_human_push_ups"
	elseif machineType == "yoga" then
		return "world_human_yoga"
	elseif machineType == "situps" then
		return "world_human_sit_ups"
	elseif machineType == "chins" then
		return "prop_human_muscle_chin_ups"
	end
end

function updateSkills(machineType)
	if machineType == "arms" then
		exports["gamz-skillsystem"]:UpdateSkill("Fuerza", 0.4)
		exports["gamz-skillsystem"]:UpdateSkill("Resistencia", 0.2)
	elseif machineType == "pushup" then
		exports["gamz-skillsystem"]:UpdateSkill("Fuerza", 0.3)
		exports["gamz-skillsystem"]:UpdateSkill("Resistencia", 0.3)
	elseif machineType == "yoga" then
		exports["gamz-skillsystem"]:UpdateSkill("Capacidad Pulmonar", 0.7)
		exports["gamz-skillsystem"]:UpdateSkill("Resistencia", 0.1)
	elseif machineType == "situps" then
		exports["gamz-skillsystem"]:UpdateSkill("Fuerza", 0.3)
		exports["gamz-skillsystem"]:UpdateSkill("Stamina", 0.2)
	elseif machineType == "chins" then
		exports["gamz-skillsystem"]:UpdateSkill("Fuerza", 0.4)
		exports["gamz-skillsystem"]:UpdateSkill("Capacidad Pulmonar", 0.7)
		exports["gamz-skillsystem"]:UpdateSkill("Resistencia", 0.3)
	end
end

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	local lastMachine = ""
    local lastHintMessage = ""
    while true do
        Citizen.Wait(0)
        local found = false
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k, v in pairs(gym_machines) do
        	for i = 1, #v do
        		if #(plyCoords - v[i]) < 0.5 then
        			if k ~= lastMachine then
        				lastHintMessage = getHintToDisplay(k)
        			end
        			hintToDisplay(lastHintMessage)
        			found = true
        			if IsControlJustPressed(0, 38) then
        				if membership then	
        					if resting then
        						ESX.ShowNotification("Necesitas descansar durante ~r~60 segundos ~w~despues de hacer ejercicio!")
        					else
        						local playerPed = GetPlayerPed(-1)
								ESX.ShowNotification("Preparandote para el ~g~Ejercicio~w~...")
								Citizen.Wait(1000)	
								TaskStartScenarioInPlace(playerPed, getScenarioForMachine(k), 0, true)
								Citizen.Wait(30000)
								CheckTraining()
								ClearPedTasksImmediately(playerPed)
								updateSkills(k)
        					end	
						else
							ESX.ShowNotification("Necesitas pagar la membresia del gimnasio para poder usarlo...")
						end
					end		
        		end
        	end
        end
        if not found then
        	Citizen.Wait(500)
        end
    end
end)

function CheckTraining()
	Citizen.CreateThread(function()
		resting = true
		Citizen.Wait(60000)
		resting = false
	end)
end


--------------------------------------------------------------------------------------

								--GYM ADMINISTRATION--

--------------------------------------------------------------------------------------


RegisterNetEvent("esx_gym:openGymMenu")
AddEventHandler("esx_gym:openGymMenu", function()
	Citizen.Wait(150)
	ESX.TriggerServerCallback('esx_gym:getGymMemberInfo', function(gymInfo)
		SendNUIMessage(
	        {
	            action = "openGym",
	            storeItems = Config.storeItems,
	            active = gymInfo.planActive,
	            planInfo = Config.planInfo,
	            playerMoney = gymInfo.playerMoney,
	            playerCurrentWeight = gymInfo.playerCurrentWeight,
	            playerMaxWeight = gymInfo.playerMaxWeight
	        }
	    )
	    SetNuiFocus(true, true)
	end)
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("errorMessage", function(data, cb)
    ESX.ShowNotification(data.message)
end)

RegisterNUICallback("buyMember", function(data, cb)
	membership = true
	TriggerServerEvent("esx_gym:buyMember", data.plan)
end)

RegisterNUICallback("buyItem", function(data, cb)
	membership = true
	TriggerServerEvent("esx_gym:buyItem", data.item)
end)


--------------------------------------------------------------------------------------

								--PED GENERATION--

--------------------------------------------------------------------------------------

local peds = {
 	{coords = vector3(-1195.75, -1577.54, 3.61), heading = 51.71, model = "u_m_y_babyd", animation = "WORLD_HUMAN_MUSCLE_FLEX"}
 }

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteCharacters()
	end
end)

local pedEntities = {}

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
end)
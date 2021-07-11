ESX = nil

noJobProcess = 'no'

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.TriggerServerCallback('esx_joblisting:getJobInProcess', function(jobInProcess)
		if jobInProcess ~= noJobProcess then
			ContinueJobProcess(jobInProcess)						
		end	
	end)
end)

RegisterNetEvent('esx_joblisting:Menu_ui')
AddEventHandler('esx_joblisting:Menu_ui', function()
	ShowJobListingMenu()
end)

function ShowJobListingMenu()
	ESX.TriggerServerCallback('esx_joblisting:getLastJob', function(canTakeJob)
		--if canTakeJob then
			SetNuiFocus(true, true)
    		SendNUIMessage({
				action = "show"
			})
		--[[else
			ESX.TriggerServerCallback('esx_joblisting:getJobInProcess', function(jobInProcess)
				if jobInProcess ~= noJobProcess then
					ESX.ShowNotification('Ya tienes una ~g~solicitud de empleo en proceso~w~, espera a recibir noticias de la oficina!')					
				else
					ESX.ShowNotification('Solo puedes cambiar de empleo ~r~una vez al dia~w~, si tienes una solicitud en proceso, espera!')
				end
			end)		
		end]]
	end)
end

function ContinueJobProcess(job)
	math.randomseed(GetGameTimer())
	Citizen.Wait(math.random(800000, 1200000))
	TriggerEvent("esx_custom_messages:showMessage", "jobListing", false, "contracted")
	Citizen.Wait(11000)
	finishJobProcess(job)
end

RegisterNUICallback("CloseAll", function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = "hide"
	})
end)

RegisterNUICallback("sendCV", function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = "hide"
	})
	TriggerServerEvent("esx_joblisting:checkRequerimentsJobListing", data.job)
end)

RegisterNetEvent("esx_joblisting:continueProcess")
AddEventHandler("esx_joblisting:continueProcess", function(job)
	Citizen.CreateThread(function()
		TriggerServerEvent('esx_joblisting:setJobInProcess', job)
		TriggerServerEvent('esx_joblisting:setLastJob')
		math.randomseed(GetGameTimer())
		Citizen.Wait(math.random(60000, 90000))
		TriggerEvent("esx_custom_messages:showMessage", "jobListing", false, "jobInProcess")
		Citizen.Wait(math.random(600000, 900000))
		TriggerEvent("esx_custom_messages:showMessage", "jobListing", false, "contracted")
		Citizen.Wait(11000)
		finishJobProcess(job)
	end)
end)

RegisterNetEvent("esx_joblisting:startDenyProcess")
AddEventHandler("esx_joblisting:startDenyProcess", function()
	Citizen.Wait(math.random(20000, 40000))
	--TriggerEvent("esx_custom_messages:showMessage", "jobListing", false, "jobFailed")
	ESX.ShowNotification("No cumples los requisitos para este trabajo!")
end)

function finishJobProcess(job)
	TriggerServerEvent('esx_joblisting:setJob', job)
	TriggerServerEvent('esx_joblisting:setJobInProcess', noJobProcess)
	ESX.ShowNotification(_U('new_job'))
end

-- Create blips
Citizen.CreateThread(function()
	for i=1, #Config.Zones, 1 do
		local blip = AddBlipForCoord(vector3(-266.19, -955.34, 31.22))
		SetBlipSprite (blip, 408)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 27)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(_U('job_center'))
		EndTextCommandSetBlipName(blip)
	end
end)


--------------------------------------------------------------------------------------------------------

                                      --PED GENERATION--

--------------------------------------------------------------------------------------------------------


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

    hash = GetHashKey('csb_bryony')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
		Wait(0)
	end
    if not DoesEntityExist(pedEntity) then
        pedEntity = CreatePed(4, hash, Config.Zones[1].x, Config.Zones[1].y, Config.Zones[1].z, 3.14)
        SetEntityAsMissionEntity(pedEntity)
        SetBlockingOfNonTemporaryEvents(pedEntity, true)
        FreezeEntityPosition(pedEntity, true)
        SetEntityInvincible(pedEntity, true)
        --TaskStartScenarioInPlace(pedEntity, "WORLD_HUMAN_SMOKING", 0, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)
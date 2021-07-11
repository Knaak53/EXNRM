ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_shops_codes:openStore')
AddEventHandler('esx_shops_codes:openStore', function()
	ESX.TriggerServerCallback('esx_shops_codes:get_buy_info', function(codeInfo)	
		if codeInfo.currentCode == codeInfo.lastPlayerCode and codeInfo.playerCodeCount > 0 then
			ESX.ShowNotification("Ya tienes el ~g~Codigo actualizado~w~!")
		else
			SendNUIMessage(
		        {
					action = "openStore",
					playerMoney = codeInfo.playerMoney,
					price = 4500
		        }
			)
			SetNuiFocus(true, true)
		end    
	end)
end)

RegisterNetEvent('esx_shops_codes:lookMyCode')
AddEventHandler('esx_shops_codes:lookMyCode', function(playerCode)
	Citizen.Wait(250)
	SendNUIMessage(
        {
			action = "lookCode",
			playerCode = playerCode
        }
	)
	SetNuiFocus(true, true)
end)

RegisterNetEvent('esx_shops_codes:computer')
AddEventHandler('esx_shops_codes:computer', function(playerCode)
	ESX.TriggerServerCallback('esx_shops_codes:getCurrentCode', function(currentCode)
		SendNUIMessage(
	        {
				action = "computer",
				currentCode = currentCode
	        }
		)
		SetNuiFocus(true, true)
	end)
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("buy", function(data, cb)
    SetNuiFocus(false, false) 
    TriggerServerEvent('esx_shops_codes:buyCode')
    ESX.ShowNotification("Has comprado el ultimo codigo de seguridad de tiendas por ~g~4500€")
end)

RegisterNUICallback("noMoney", function(data, cb)
    ESX.ShowNotification("No tienes suficiente ~r~Dinero Negro~w~!")
end)

RegisterNUICallback("stealComputer", function(data, cb)
	TriggerServerEvent('esx_shops_codes:updateShopCode')
    TriggerEvent('esx_shops:stealComputer')
end)








------------------------- PED GENERATION ---------------------------------------

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteCharacters()
	end
end)

local pedEntity = 0

DeleteCharacters = function()
    if DoesEntityExist(pedEntity) then
        DeletePed(pedEntity)
        SetPedAsNoLongerNeeded(pedEntity)
    end
end

Citizen.CreateThread(function()
    hash = GetHashKey('mp_m_weapexp_01')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
		Citizen.Wait(10)
	end
    if not DoesEntityExist(pedEntity) then
        pedEntity = CreatePed(4, hash, 76.04, 3709.15, 38.66, 53.7)
        SetEntityAsMissionEntity(pedEntity)
        SetBlockingOfNonTemporaryEvents(pedEntity, true)
        FreezeEntityPosition(pedEntity, true)
        SetEntityInvincible(pedEntity, true)
        TaskStartScenarioInPlace(pedEntity, 'WORLD_HUMAN_SEAT_LEDGE', 0, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)
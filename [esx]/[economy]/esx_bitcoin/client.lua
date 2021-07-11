ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports.extendedmode:getSharedObject()
        Citizen.Wait(50)
    end
end)

RegisterNetEvent('esx_bitcoin:openExchange')
AddEventHandler('esx_bitcoin:openExchange', function()
    ESX.TriggerServerCallback('esx_bitcoin:getBTCInfo', function(btcInfo)
        print(json.encode(btcInfo))
    	if btcInfo.haveLedger then
    		SendNUIMessage(
	            {
	              action = "open",
	              btc = btcInfo.btc,
	              inversion = btcInfo.inversion,
	              playerMoney = btcInfo.playerMoney,
	              accounts = btcInfo.accounts,
	              account = btcInfo.account
	            }
	        )
	        SetNuiFocus(true, true)  
	    else
	    	ESX.ShowNotification("Necesitas un ~g~Ledger Nano S~w~ para acceder al servicio de bitcoin.")
    	end    
    end)
end)

RegisterNUICallback("buyBitcoin", function(data, cb)
    TriggerServerEvent('esx_bitcoin:buyBitcoin', data.btc, data.price, data.btcPrice)
end)

RegisterNUICallback("sellBitcoin", function(data, cb)
    TriggerServerEvent('esx_bitcoin:sellBitcoin', data.btc, data.price, data.btcPrice)
end)

RegisterNUICallback("sendBitcoin", function(data, cb)
    TriggerServerEvent('esx_bitcoin:sendBitcoin', data.btc, data.price, data.btcSent, data.targetAccount)
end)

RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false) 
end)

------------------------------------ PED GENERATION -----------------------------------------

local pedEntity = 0

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeletePed()
    end
end)

DeletePed = function()
    if DoesEntityExist(pedEntity[i]) then
        DeletePed(pedEntity[i])
        SetPedAsNoLongerNeeded(pedEntity[i])
    end    
end

Citizen.CreateThread(function()
    hash = GetHashKey(Config.npc.model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
    if not DoesEntityExist(pedEntity) then
        pedEntity = CreatePed(4, hash, Config.npc.coords.x, Config.npc.coords.y, Config.npc.coords.z, Config.npc.heading)
        SetEntityAsMissionEntity(pedEntity)
        SetBlockingOfNonTemporaryEvents(pedEntity, true)
        FreezeEntityPosition(pedEntity, true)
        SetEntityInvincible(pedEntity, true)
        TaskStartScenarioInPlace(pedEntity, Config.npc.animation, 0, true)
    end
    SetModelAsNoLongerNeeded(hash)
end)
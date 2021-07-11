TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

ESX.RegisterServerCallback('esx_commerce:getPlayerInvComplete', function(source, cb, targetSrc)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ret = {}
    local targetXPlayer = ESX.GetPlayerFromId(targetSrc)

    ret.accounts = {}
    ret.items = {}
    ret.weapons = {}
    ret.playerMaxWeight = xPlayer.getMaxWeight()
    ret.playerCurrentWeight = xPlayer.getWeight()
    ret.targetMaxWeight = targetXPlayer.getMaxWeight()
    ret.targetCurrentWeight = targetXPlayer.getWeight()
    ret.targetName = targetXPlayer.getName()
    ret.playerMoney = xPlayer.getMoney()
    ret.playerName = xPlayer.getName()
    ret.targetWeaponCount = #targetXPlayer.getLoadout()

    inventory = xPlayer.getInventory()
    loadout = xPlayer.getLoadout()
    accounts = xPlayer.getAccounts()

    for k, v in pairs(inventory) do
        if v.count > 0 then
          v.type = 'item'
          table.insert(ret.items, v)
        end
    end

    for k, v in pairs(loadout) do
        v.type = 'weapon'
        table.insert(ret.weapons, v)
    end

    for k, v in pairs(accounts) do
        if v.name == 'money' or v.name == 'black_money' and v.money > 0 then
            v.type = 'account'
            table.insert(ret.accounts, v)
        end
    end
    
    cb(ret)
end)

RegisterServerEvent("esx_commerce:refreshPlayerOffer")
AddEventHandler("esx_commerce:refreshPlayerOffer", function(targetSrc, playerOffer)
    TriggerClientEvent("esx_commerce:refreshPlayerOffer_client", targetSrc, playerOffer)    
end)

RegisterServerEvent("esx_commerce:cancelCommerce")
AddEventHandler("esx_commerce:cancelCommerce", function(targetSrc)
    TriggerClientEvent("esx_commerce:cancelCommerce_client", targetSrc)    
end)

RegisterServerEvent("esx_commerce:playerDecline")
AddEventHandler("esx_commerce:playerDecline", function(targetSrc)
    TriggerClientEvent("esx_commerce:targetDecline", targetSrc)    
end)

RegisterServerEvent("esx_commerce:playerAccept")
AddEventHandler("esx_commerce:playerAccept", function(targetSrc)
    TriggerClientEvent("esx_commerce:targetAccept", targetSrc)    
end)

RegisterServerEvent("esx_commerce:invite_commerce")
AddEventHandler("esx_commerce:invite_commerce", function(targetSrc)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent("esx_commerce:get_invited_to_commerce", targetSrc, _source, xPlayer.getName())
end)

RegisterServerEvent("esx_commerce:decline_invite_server")
AddEventHandler("esx_commerce:decline_invite_server", function(senderSrc)
    TriggerClientEvent("esx_commerce:decline_invite_client", senderSrc)
end)

RegisterServerEvent("esx_commerce:startCommerce")
AddEventHandler("esx_commerce:startCommerce", function(senderSrc)
    TriggerClientEvent("esx_commerce:startCommerce_client", senderSrc, source)
end)

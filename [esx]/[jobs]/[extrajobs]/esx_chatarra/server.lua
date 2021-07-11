TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

ESX.RegisterServerCallback('esx_chatarra:getPlayerInv', function(source,cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
   
    cb(xPlayer.getInventory())
end)

RegisterNetEvent('esx_chatarra:sellItems')
AddEventHandler('esx_chatarra:sellItems', function(name, price, count)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem(name, count)
    xPlayer.addMoney(price)
end)
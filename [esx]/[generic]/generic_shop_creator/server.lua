TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

ESX.RegisterServerCallback('generic_shop_creator:getPlayerMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cb(xPlayer.getMoney())
end)

RegisterNetEvent('generic_shop_creator:buyItem')
AddEventHandler('generic_shop_creator:buyItem', function(itemData, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local finalPrice = itemData.price * amount
	if xPlayer.getMoney() >= finalPrice then
		if xPlayer.canCarryItem(itemData.name, amount) then
			xPlayer.addInventoryItem(itemData.name, amount)
			xPlayer.removeMoney(finalPrice)
			TriggerClientEvent('esx:showNotification', _source, "Has comprado ~y~x" .. amount .. "~b~ " .. itemData.label .. "~w~ por ~g~" .. finalPrice .. "€")
			TriggerClientEvent('generic_shop_creator:updatePrice', _source, finalPrice)
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~NO TIENES ESPACIO EN EL INVENTARIO!")
		end
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~NO TIENES SUFICIENTE DINERO!")
	end
end)
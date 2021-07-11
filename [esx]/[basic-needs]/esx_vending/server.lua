ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)


RegisterNetEvent("esx_vending:buyProduct")
AddEventHandler("esx_vending:buyProduct", function(product)
 	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.canCarryItem(product.name, 1) then
    	if xPlayer.getAccount("money").money > product.price then
    		xPlayer.addInventoryItem(product.name, 1)
    		xPlayer.removeMoney(product.price)
    		TriggerClientEvent("esx:showNotification", src, 'Has comprado x1 ~g~' .. product.label .. ' ~w~por~g~ ' .. product.price .. "€")
    	else
    		TriggerClientEvent("esx:showNotification", src, 'No tienes ~r~suficiente dinero~w~!')
    	end	
    else
    	TriggerClientEvent("esx:showNotification", src, 'No tienes ~r~ESPACIO~s~ suficiente en el inventario!')
    end
end)

RegisterNetEvent("esx_vending:freeWater")
AddEventHandler("esx_vending:freeWater", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)    
    TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
end)
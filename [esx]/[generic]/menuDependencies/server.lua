ESX = nil
ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent("menuDependencies:tirarBasuraS")
AddEventHandler("menuDependencies:tirarBasuraS", function(itemName, itemCount) 
    if itemCount == nil or itemCount < 1 then
        TriggerClientEvent('esx:showNotification', source, "No tienes más que tirar")
    else

        local xPlayer = ESX.GetPlayerFromId(source)
        local xItem = xPlayer.getInventoryItem(itemName)

        if (itemCount > xItem.count or xItem.count < 1) then
            TriggerClientEvent('esx:showNotification', source, "No tienes más que tirar")
        else
            xPlayer.removeInventoryItem(itemName, itemCount)

            --local pickupLabel = ('~y~%s~s~ [~b~%s~s~]'):format(xItem.label, itemCount)
            --ESX.CreatePickup('item_standard', itemName, itemCount, pickupLabel, _source)
            TriggerClientEvent('esx:showNotification', source, "Tiraste x"..itemCount.." "..xItem.label)
        end

    end
end)

RegisterServerEvent("menuDependencies:getItem")
AddEventHandler("menuDependencies:getItem", function(itemName, itemCount) 
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(itemName, itemCount)
end)

RegisterServerEvent("menuDependencies:getMoney")
AddEventHandler("menuDependencies:getMoney", function(q) 
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(tonumber(q))
end)

RegisterServerEvent("menuDependencies:getWeapon")
AddEventHandler("menuDependencies:getWeapon", function(weapon) 
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weapon,1)
end)

RegisterServerEvent('menuDependencies:darDinero')
AddEventHandler('menuDependencies:darDinero', function(OPlayerId, quantity)
    --print("source ??"..source)
    local xplayer = ESX.GetPlayerFromId(source)
    local oxplayer = ESX.GetPlayerFromId(OPlayerId)
    local money = xplayer.getMoney()
    --print("quantity: "..quantity)
    --print("money: "..money)
    quantity = tonumber(quantity)
    if (money < quantity or quantity < 1) then
        TriggerClientEvent('esx:showNotification', source, "Cantidad no válida")
    elseif OPlayerId  then
        -- body
        xplayer.removeMoney(tonumber(quantity))
        oxplayer.addMoney(tonumber(quantity))
        TriggerClientEvent('esx:showNotification', source, "Has dado "..quantity.." $ a "..oxplayer.getName() , true)
        TriggerClientEvent('esx:showNotification', OPlayerId, "Has recibido "..quantity.." $ de " .. xplayer.getName(), true)
    else
        xplayer.removeMoney(tonumber(quantity))
        TriggerClientEvent('esx:showNotification', source, "Has dado "..quantity.." $ " , true)
    end
    
    --xplayer.addInventoryItem(item,1)
end)

--"menuDependencies:getItem"
--"menuDependencies:getMoney"
--"menuDependencies:getWeapon"
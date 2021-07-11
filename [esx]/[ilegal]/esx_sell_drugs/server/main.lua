ESX = nil
local drugPrices = {weed_pooch = 350, coke_pooch = 560, meth_pooch = 750}

ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent("esx_sell_drugs:sellDrug")
AddEventHandler("esx_sell_drugs:sellDrug", function(drug)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem(drug).count >= 3 then
        math.randomseed(os.time())
        local randomCount = math.random(1, 3)
        xPlayer.removeInventoryItem(drug, randomCount)
        xPlayer.addAccountMoney("black_money", drugPrices[drug] * randomCount)
        xPlayer.showNotification("Has vendido x" .. randomCount .. " ~g~" .. xPlayer.getInventoryItem(drug).label .. " ~w~por ~g~" .. drugPrices[drug] * randomCount .. "€")
    else
        xPlayer.addAccountMoney("black_money", drugPrices[drug] * xPlayer.getInventoryItem(drug).count)
        xPlayer.showNotification("Has vendido x" .. xPlayer.getInventoryItem(drug).count .. " ~g~" .. xPlayer.getInventoryItem(drug).label .. " ~w~por ~g~" .. drugPrices[drug] * xPlayer.getInventoryItem(drug).count .. "€")
        xPlayer.removeInventoryItem(drug, xPlayer.getInventoryItem(drug).count)
    end 
end)

ESX.RegisterServerCallback('esx_sell_drugs:playerHasDrugs', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cb(
    	{
    		weed = xPlayer.getInventoryItem("weed_pooch").count,
    		coke = xPlayer.getInventoryItem("coke_pooch").count,
    		meth = xPlayer.getInventoryItem("meth_pooch").count
    	}
    )
end)

RegisterServerEvent('esx_sell_drugs:callCops')
AddEventHandler('esx_sell_drugs:callCops', function(coords, street1, street2, sex)
    local message
    if sex == "m" then
        message = "Se ha visto a un ~r~Hombre~w~ " 
    else
        message = "Se ha visto a una ~r~Mujer~w~ " 
    end
    if (street1 ~= nil and street1 ~= "") and (street2 ~= nil and street2 ~= "") then
        message = message .. "vendiendo drogas entre ~g~" .. street1 .."~w~ y ~g~" .. street2
    else
        if street1 ~= nil and street1 ~= "" then
            message = message .. "vendiendo drogas cerca de ~g~"..street1
        end
        if street2 ~= nil and street2 ~= "" then
            message = message .. "vendiendo drogas en ~g~" .. street2
        end
    end
    TriggerClientEvent('esx_sell_drugs:notifyCops', -1, coords, message)
end)
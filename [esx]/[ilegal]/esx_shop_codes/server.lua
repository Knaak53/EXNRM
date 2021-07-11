TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

AddEventHandler('esx:dataReady', function()
    TriggerEvent('esx:getSharedObject', function(obj)
      ESX = obj
    end)
end)

ESX.RegisterServerCallback('esx_shops_codes:get_buy_info',function(source, cb)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    --local currentCode = MySQL.Sync.fetchScalar('SELECT shop_code from robbery', {})
    --local lastPlayerCode = MySQL.Sync.fetchScalar('SELECT code from shop_codes where owner = @identifier', {["identifier"] = xPlayer.getIdentifier()})
    local currentCode = ESX.getsData().get("shopRobberyCurrentCode")
    if not currentCode then
        currentCode = getNewRandomCode()
        ESX.getsData().set("shopRobberyCurrentCode", currentCode)
    end

    local lastPlayerCode = xPlayer.get("lastShopRobberyCodeBought")
    ret = {}
    ret.playerCodeCount = xPlayer.getInventoryItem("shop_code").count

    if lastPlayerCode then
        ret.lastPlayerCode = lastPlayerCode
    end
    ret.currentCode = currentCode
    ret.playerMoney = xPlayer.getAccount("black_money").money
    cb(ret)
end)	

ESX.RegisterServerCallback('esx_shops_codes:getCurrentCode', function(source, cb)
    cb(ESX.getsData().get("shopRobberyCurrentCode"))
end)

function getNewRandomCode()
    math.randomseed(os.time())
    local randomCode = math.random(1, 999999);
    return tostring(randomCode)
end

RegisterNetEvent('esx_shops_codes:buyCode')
AddEventHandler('esx_shops_codes:buyCode', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local currentCode = ESX.getsData().get("shopRobberyCurrentCode")
    xPlayer.set("lastShopRobberyCodeBought", currentCode)
    if xPlayer.getInventoryItem("shop_code").count < 1 then
        xPlayer.addInventoryItem("shop_code", 1)
    end 
end)

RegisterNetEvent('esx_shops_codes:updateShopCode')
AddEventHandler('esx_shops_codes:updateShopCode', function()
    ESX.getsData().set("shopRobberyCurrentCode", getNewRandomCode())
end)

ESX.RegisterUsableItem('shop_code', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local lastPlayerCode = xPlayer.get("lastShopRobberyCodeBought")
    if not lastPlayerCode then
        TriggerClientEvent('esx:showNotification', source, "Parece que el codigo de seguridad que tienes se ha borrado parcialmente y no se puede leer...")
    else
        TriggerClientEvent('esx_shops_codes:lookMyCode', source, lastPlayerCode)
    end
end)
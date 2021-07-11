--[[ Gets the ESX library ]]--
ESX = nil 
ESX = exports.extendedmode:getSharedObject()

local currentRobberyThiefCount = 0

RegisterNetEvent('99kr-shops:Cashier')
AddEventHandler('99kr-shops:Cashier', function(price, basket, account)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if canCarryBasketItems(basket, xPlayer) then
        for i=1, #basket do
             xPlayer.addInventoryItem(basket[i]["value"], basket[i]["amount"])
        end
        xPlayer.removeAccountMoney(account, price)
        TriggerClientEvent("esx:showNotification", src, 'Has comprado productos por: ~g~' .. price .. '€~g~</span>')
    else
        TriggerClientEvent("esx:showNotification", src, 'No tienes ~r~ESPACIO~s~ suficiente para todo eso!')
    end
end)

function canCarryBasketItems(basket, xPlayer)
    local weightToAdd = 0
    for i = 1, #basket do
        weightToAdd = weightToAdd + (xPlayer.getInventoryItem(basket[i].value).weight * basket[i].amount)
    end
    if xPlayer.getWeight() + weightToAdd > xPlayer.getMaxWeight() then
        return false
    end
    return true
end

ESX.RegisterServerCallback('99kr-shops:CheckMoney', function(source, cb, price, account)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money
    if account == "cash" then
        money = xPlayer.getMoney()
    else
        money = xPlayer.getAccount(account)["money"]
    end

    if money >= price then
        cb(true)
    end
    cb(false)
end)

local thiefsActive = {}

RegisterNetEvent('esx_shops:startRobbery')
AddEventHandler('esx_shops:startRobbery', function(activeRobberyStore)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    currentRobberyThiefCount = 1
    table.insert(thiefsActive, {player = xPlayer, src = src})
    TriggerClientEvent("esx:showNotification", src, '~r~HAS INICIADO UN ATRACO!')
    TriggerClientEvent("esx_shops:startClientRobbery", -1, activeRobberyStore)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    TriggerClientEvent("esx_shops:alertCops", -1, activeRobberyStore)
    local robberiesCooldowns = ESX.getsData().get("robberiesCoolDowns")
    robberiesCooldowns.shopRobberies = os.time()
    ESX.getsData().set("robberiesCoolDowns", robberiesCooldowns)
end)

RegisterNetEvent("esx_shops:npcSurrenderServer")
AddEventHandler("esx_shops:npcSurrenderServer", function()
    TriggerClientEvent("esx_shops:npcSurrender", -1) 
end)

RegisterNetEvent("esx_shops:stealCashRegister")
AddEventHandler("esx_shops:stealCashRegister", function(cashTaken)
    math.randomseed(os.time())
    local randomMoney = math.floor(math.random(6500, 12500) / currentRobberyThiefCount)
    for i = 1, #thiefsActive do
        thiefsActive[i].player.addMoney(randomMoney)
        TriggerClientEvent("esx_shops:cashTaken", thiefsActive[i].src, cashTaken)
        TriggerClientEvent("esx:showNotification", thiefsActive[i].src, 'Has robado: ~g~' .. randomMoney .. '€~w~ de la caja registradora.')
    end
end)

RegisterNetEvent("esx_shops:addThief")
AddEventHandler("esx_shops:addThief", function()
    currentRobberyThiefCount = currentRobberyThiefCount + 1
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    table.insert(thiefsActive, {player = xPlayer, src = src})
end)

RegisterNetEvent('esx_shops:finishRobbery')
AddEventHandler('esx_shops:finishRobbery', function()
    TriggerClientEvent("esx_shops:finishRobbery", -1) 
end)

RegisterNetEvent("esx_shops:stealProducts")
AddEventHandler("esx_shops:stealProducts", function(products)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if canCarryItems(products, xPlayer) then
        for i = 1, #products do
            xPlayer.addInventoryItem(products[i].item, products[i].count)
        end
        local messageProducts = ""
        for i = 1, #products do
            messageProducts = messageProducts .. "x" .. products[i].count .. " ~g~" .. products[i].label .. "~w~, "
        end
        TriggerClientEvent("esx:showNotification", src, 'Has robado: ' .. messageProducts)
    else
        TriggerClientEvent("esx:showNotification", src, '~r~NO TIENES ESPACIO EN EL INVENTARIO!')
    end   
end)

function canCarryItems(products, xPlayer)
    local weightToAdd = 0
    for i = 1, #products do
        weightToAdd = weightToAdd + (xPlayer.getInventoryItem(products[i].item).weight * products[i].count)
    end
    if xPlayer.getWeight() + weightToAdd > xPlayer.getMaxWeight() then
        return false
    end
    return true
end

RegisterNetEvent('esx_shops:stealComputer')
AddEventHandler('esx_shops:stealComputer', function()
    math.randomseed(os.time())
    local randomMoney = math.floor(math.random(8500, 15750) / currentRobberyThiefCount)
    for i = 1, #thiefsActive do
        thiefsActive[i].player.addMoney(randomMoney)
        TriggerClientEvent("esx:showNotification", thiefsActive[i].src, 'Has robado: ~g~' .. randomMoney .. '€~w~ de la caja fuerte.')
    end
end)

ESX.RegisterServerCallback("esx_shops:checkIfCanStartRobbery", function(source, cb)
    local robberiesCooldowns = ESX.getsData().get("robberiesCoolDowns")
    if not robberiesCooldowns then
        robberiesCooldowns = {}
        ESX.getsData().set("robberiesCoolDowns", robberiesCooldowns)
    end
    if not robberiesCooldowns.shopRobberies then
        robberiesCooldowns.shopRobberies = 1549643682
        ESX.getsData().set("robberiesCoolDowns", robberiesCooldowns)
    end
    if os.time() - robberiesCooldowns.shopRobberies >= 1800 then
        cb(true)
    else
        cb(false)
    end
end)
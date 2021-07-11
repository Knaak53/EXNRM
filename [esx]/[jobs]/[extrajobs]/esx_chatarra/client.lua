ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports.extendedmode:getSharedObject()
        Citizen.Wait(50)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.pedInfo[1].coords)
    SetBlipSprite(blip, 643)
    SetBlipColour(blip, 12)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.pedInfo[1].name)
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('esx_chatarra:openStore')
AddEventHandler('esx_chatarra:openStore', function(isHardware)
    ESX.TriggerServerCallback('esx_chatarra:getPlayerInv', function(inventory)
        local scrapItems
        local npcShortName
        local npcName
        if isHardware then
            scrapItems = getHardwareItems(inventory)
            npcShortName = Config.pedInfo[2].shortName
            npcName = Config.pedInfo[2].name
        else
            scrapItems = getScrapItems(inventory)
            npcShortName = Config.pedInfo[1].shortName
            npcName = Config.pedInfo[1].name
        end

        SendNUIMessage(
            {
              action = "open",
              scrapItems = scrapItems,
              isHardware = isHardware,
              npcName = npcName,
              npcShortName = npcShortName
            }
        )
        SetNuiFocus(true, true)   
    end)
end)

function getHardwareItems(inventory)
    local ret = {}
    for i = 1, #Config.hardware do
        local newScrap = {name = Config.hardware[i].name, label = Config.hardware[i].name, price = Config.hardware[i].price}
        local itemInInventory = false
        for k,v in pairs(inventory) do       
            if v.name == Config.hardware[i].name then
                newScrap.count = v.count
                itemInInventory = true
                break
            end
        end
        if not itemInInventory then newScrap.count = 0 end
        table.insert(ret, newScrap)
    end
    return ret
end

function getScrapItems(inventory)
    local ret = {}
    for i = 1, #Config.items do
        local newScrap = {name = Config.items[i].name, label = Config.items[i].name, price = Config.items[i].price}
        local itemInInventory = false
        for k,v in pairs(inventory) do       
            if v.name == Config.items[i].name then
                newScrap.count = v.count
                itemInInventory = true
                break
            end
        end
        if not itemInInventory then newScrap.count = 0 end
        table.insert(ret, newScrap)
    end
    return ret
end

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("sellItems", function(data, cb)
    TriggerServerEvent('esx_chatarra:sellItems', data.name, data.price, data.count)
    ESX.ShowNotification('Has vendido x' .. data.count .. ' ~y~' .. data.label .. '~w~ por ~g~' .. data.price .. '€')
end)


------------------------------------ PED GENERATION -----------------------------------------

local pedEntity = {}

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeletePed()
    end
end)

DeletePed = function()
    for i = 1, #pedEntity do
        if DoesEntityExist(pedEntity[i]) then
        --DeletePed(pedEntity[i])
        --SetPedAsNoLongerNeeded(pedEntity[i])
        end
    end
    
end

Citizen.CreateThread(function()
    for i = 1, #Config.pedInfo do
        hash = GetHashKey(Config.pedInfo[i].model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(10)
        end
        if not DoesEntityExist(pedEntity[i]) then
            pedEntity[i] = CreatePed(4, hash, Config.pedInfo[i].coords.x, Config.pedInfo[i].coords.y, Config.pedInfo[i].coords.z, Config.pedInfo[i].heading)
            SetEntityAsMissionEntity(pedEntity[i])
            SetBlockingOfNonTemporaryEvents(pedEntity[i], true)
            FreezeEntityPosition(pedEntity[i], true)
            SetEntityInvincible(pedEntity[i], true)
            TaskStartScenarioInPlace(pedEntity[i], Config.pedInfo[i].animation, 0, true)
        end
        SetModelAsNoLongerNeeded(hash)
    end 
end)
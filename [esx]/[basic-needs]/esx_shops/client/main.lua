payAmount = 0
Basket = {}

--[[ Gets the ESX library ]]--
ESX = nil 
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end

    PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('esx:dataReady', function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end

    PlayerData = ESX.GetPlayerData()
end)

--[[ Requests specified model ]]--
_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

--[[ Deletes the cashiers ]]--
DeleteCashier = function()
    for i=1, #Config.Locations do
        local cashier = Config.Locations[i]["cashier"]
        if DoesEntityExist(cashier["entity"]) then
            DeletePed(cashier["entity"])
            SetPedAsNoLongerNeeded(cashier["entity"])
        end
    end
end

Citizen.CreateThread(function()
    local defaultHash = 416176080
    for i=1, #Config.Locations do
        local cashier = Config.Locations[i]["cashier"]
        if cashier then
            cashier["hash"] = cashier["hash"] or defaultHash
            _RequestModel(cashier["hash"])
            if not DoesEntityExist(cashier["entity"]) then
                cashier["entity"] = CreatePed(4, cashier["hash"], cashier["x"], cashier["y"], cashier["z"], cashier["h"])
                SetEntityAsMissionEntity(cashier["entity"])
                SetBlockingOfNonTemporaryEvents(cashier["entity"], true)
                FreezeEntityPosition(cashier["entity"], true)
                SetEntityInvincible(cashier["entity"], true)
            end
            SetModelAsNoLongerNeeded(cashier["hash"])
        end
    end
end)

--[[ Creates cashiers and blips ]]--
Citizen.CreateThread(function()
    for i=1, #Config.Locations do
        local blip = Config.Locations[i]["blip"]

        if blip then
            if not DoesBlipExist(blip["id"]) then
                blip["id"] = AddBlipForCoord(blip["x"], blip["y"], blip["z"])
                SetBlipSprite(blip["id"], 628)
                SetBlipDisplay(blip["id"], 4)
                SetBlipScale(blip["id"], 0.78)
                SetBlipColour(blip["id"], 33)
                SetBlipAsShortRange(blip["id"], true)

                BeginTextCommandSetBlipName("shopblip")
                AddTextEntry("shopblip", "Tienda")
                EndTextCommandSetBlipName(blip["id"])
            end
        end
    end
end)

--[[ Deletes the peds when the resource stops ]]--
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent('esx:clientLog', "[99kr-shops]: Deleting peds...")
        DeleteCashier()
    end
end)
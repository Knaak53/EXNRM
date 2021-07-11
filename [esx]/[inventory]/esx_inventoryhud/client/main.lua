isInInventory = false
ESX = nil
local canOpenInventory = true
local targetInventory = nil

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end
        ExM = exports.extendedmode:getExtendedModeObject()
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
                openInventory()
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if IsControlJustReleased(0, Config.CloseControl) then
			if isInInventory then
                closeInventory()
				end
            end
        end
    end
)

function openInventory()
    if canOpenInventory then
        setCharacterInfo()
        loadPlayerInventory()
        setBillingInfo()
        setNPCInfo()
        TriggerEvent("gamz-skillsystem:getSkills")
        isInInventory = true 
        SendNUIMessage(
            {
                action = "display",
                type = "normal"   
            }
        )    
        SetNuiFocus(true, true) 
    end 
end

RegisterNetEvent("esx_inventoryhud:setSkills")
AddEventHandler("esx_inventoryhud:setSkills", function(skills)
    local stats = {}
    for k, v in pairs(skills) do
        table.insert(stats, {name = k, current = v.Current})
    end
    SendNUIMessage(
        {
            action = "stats",
            stats = stats
        }
    )
end)

function setCharacterInfo()
    Citizen.CreateThread(function()      
        ESX.TriggerServerCallback('esx_inventoryhud:getBasicInfo', function(info)     
            print(json.encode(info))     
            ESX.UI.Menu.CloseAll()-- this also closes any esx menus to prevent from society inventory duping                      
            local hambre = 0
            local sed = 0
            TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                hambre = status.val
            end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                sed = status.val   
            end)  
            SendNUIMessage(
                {
                    action = "characterInfo",
                    characterInfo = info[1]
                }
            )  
        end) 
    end)
end

function setBillingInfo()
    Citizen.CreateThread(function()
        ESX.TriggerServerCallback('esx_billing:getBills', function(bills) 
            local nuiBills = prepareBillsForNui(bills)
            SendNUIMessage(
                {
                    action = "billingInfo",
                    bills = nuiBills
                }
            )    
        end)
    end)  
end

function prepareBillsForNui(bills)
    local nuiBills = {}
    for k, v in pairs(bills) do
        v.id = k
        table.insert(nuiBills, v)
    end
    return nuiBills
end

function setNPCInfo()
    Citizen.CreateThread(function()
        ESX.TriggerServerCallback('esx_inventoryhud:get_npc_player_info', function(npcInfo)
            local questsInfo = getQuestsInfo(npcInfo)
            SendNUIMessage(
                {
                    action = "npcInfo",
                    questsInfo = questsInfo
                }
            )
        end)
    end)  
end

local questsDescriptions = {
    john = {
        {
            name = "Paquete sospechoso",
            description = "Tengo un amigo llamado Jimmy que lleva unos días esperando un paquete mio, mejor no preguntes, llevaselo y te ganaras algo... Vive en una caravana en stab city."
        },
        {
            name = "Saldar una deuda",
            description = "Hay un tio, que vive en una caravana al norte de paleto bay, me debe pasta y me ha dicho que pase a recogerla, estoy hasta arriba de mierda, traemela y te dare unos pavos..."
        },
        {
            name = "Suministros belicos",
            description = "Ha llegado un pedido de armas que hice a los rusos, lo tiene un compi mio, esta en el poligono, en los callejones detras de ammunation, ve a buscarlo."
        }
    },
    daisy = {
        {
            name = "Medicinas para Janette",
            description = "A mi amiga Janette le gusta mucho la vicodina, pero las que le receta el medico no le quitan el mono, yo se las consigo en el mercado negro, seguro que esta en la peluqueria, llevaselas."
        },
        {
            name = "Unos gramos de alegria",
            description = "Mi colega Dave trabaja en la plantacion de maria que hay al noreste... acaba de cortar y me ha dicho me pase a buscar mi parte, no tengo tiempo, asi que traemela y habra comision."
        },
        {
            name = "Rollos en groove street",
            description = "Tengo un pedido de polvo de angel y le he encargado a Big Joe que me lo cocine, ya esta listo, asi que si me lo traes... igual te cae algo como recompensa... por cierto, vive en groove street."
        }
    },
    charles = {
        {
            name = "Videos turbios",
            description = "Hay un colgado que vive en la caseta junto al lago de mirror park, le van unos rollos muy turbios, a mi no me va mucho el tema, pero es pasta, le he conseguido material nuevo, pasaselo."
        },
        {
            name = "Una cuestion organica",
            description = "Estoy metido en un negocio turbio con organos, un pez gordo que vive en una mansion de rockford hills necesita un corazon nuevo, como le han puesto en lista de espera me ha encargado uno, llevaselo con mucha discrecion."
        },
        {
            name = "Criptomonedas al poder",
            description = "Te has enterado ya de que Bitcoin es el futuro? Hace meses que no para de subir y he decidido meterme en el negocio, un compi de burrito heights me ha preparado un monedero fisico, ve a buscarlo, te aviso, en esa casa son unos frikis..."
        }
    }
}

function getQuestsInfo(npcInfo)
    local ret = {}
    for k, v in pairs(npcInfo) do
        if v.isOnQuest then
            table.insert(ret, {
                name = k, 
                currentQuestIsCompleted = v.currentQuestIsCompleted,
                description = questsDescriptions[k][v.currentQuest].description,
                questName = questsDescriptions[k][v.currentQuest].name
            })
        end
    end
    return ret
end

-- sets the id of target
RegisterNetEvent("esx_invnetoryhud:setOpenedPlayerId")
AddEventHandler("esx_invnetoryhud:setOpenedPlayerId", function(target)
    --print(target)
    targetInventory = target
end)

-- disables inventory opening if someone is searching the source
RegisterNetEvent("esx_inventoryhud:disableOpen")
AddEventHandler('esx_inventoryhud:disableOpen', function()
    ESX.UI.Menu.CloseAll() -- this also closes any esx menus to prevent duping using society inventory
    closeInventory()
    canOpenInventory = false
end)

-- enables opening after search is finished
RegisterNetEvent("esx_inventoryhud:enableOpen")
AddEventHandler("esx_inventoryhud:enableOpen", function()
    canOpenInventory = true
end)

--[[RegisterNetEvent("esx_inventoryhud:doClose")
AddEventHandler("esx_inventoryhud:doClose", function()
    closeInventory()
end)--]]

RegisterCommand('closeinv', function(source, args, raw)
    closeInventory()
end)

function closeInventory()
    isInInventory = false
    SendNUIMessage(
        {
            action = "hide"
        }
    )
    SetNuiFocus(false, false)
	TriggerEvent('esx_inventoryhud:closeInventory')
    disableOpen()
end

function disableOpen()
    Citizen.CreateThread(function()
        canOpenInventory = false
        Citizen.Wait(2500)
        canOpenInventory = true
    end)
end

RegisterNetEvent('esx_inventoryhud:doClose')
AddEventHandler('esx_inventoryhud:doClose', function(...) 
	closeInventory(...); 
 end)

RegisterNUICallback(
    "NUIFocusOff",
    function()
        closeInventory()
    end
)

RegisterNUICallback(
    "GetNearPlayers",
    function(data, cb)
        local playerPed = PlayerPedId()
        local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
        local foundPlayers = false
        local elements = {}

        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                foundPlayers = true

                table.insert(
                    elements,
                    {
                        label = GetPlayerName(players[i]),
                        player = GetPlayerServerId(players[i])
                    }
                )
            end
        end

        if not foundPlayers then
        
            ESX.ShowNotification(_U("players_nearby"))
        else
            SendNUIMessage(
                {
                    action = "nearPlayers",
                    foundAny = foundPlayers,
                    players = elements,
                    item = data.item
                }
            )
        end

        cb("ok")
    end
)

RegisterNUICallback(
    "UseItem",
    function(data, cb)
        TriggerServerEvent("esx:useItem", data.item.name)

        if shouldCloseInventory(data.item.name) then
            closeInventory()
        else
            Citizen.Wait(250)
            loadPlayerInventory()
        end

        cb("ok")
    end
)

RegisterNUICallback(
    "DropItem",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            if data.item.type == "item_money" then
                local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
                -- Lets use our new function instead of manually doing it
                ExM.Game.PlayAnim(dict, anim, true, 1000)
				TriggerServerEvent("esx:removeInventoryItem", "item_account", "money", data.number, "bkr_prop_money_unsorted_01")
			else
				TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number, data.item.prop)
			end
        end

        Wait(250)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback(
    "GiveItem",
    function(data, cb)
        local playerPed = PlayerPedId()
        local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
        local foundPlayer = false
        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                if GetPlayerServerId(players[i]) == data.player then
                    foundPlayer = true
                end
            end
        end

        if foundPlayer then
            local count = tonumber(data.number)

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            if data.item.type == "item_money" then
                TriggerServerEvent("esx:giveInventoryItem", data.player, "item_account", "money", count)
                ESX.Actions.giveObjectSynced("prop_anim_cash_note", data.player, nil)
			else
                TriggerServerEvent("esx:giveInventoryItem", data.player, data.item.type, data.item.name, count)
                ESX.Actions.giveObjectSynced(data.item.prop, data.player, nil)
			end
            Wait(250)
            loadPlayerInventory()
        else
        
            ESX.ShowNotification(_U("player_nearby"))
        end
        cb("ok")
    end
)

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end

    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end

    return false
end

RegisterNUICallback(
    "showCard",
    function(data, cb)
        distance = -1
        idCard = ''

        if data.card == 0 then
            idCard = 'dni'
        end
        if data.card == 1 then
            idCard = 'driver'
        end
        if data.card == 2 then
            idCard = 'weapon'
        end
        if data.self then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), idCard)
            
            closeInventory()
        else
            target, distance = ESX.Game.GetClosestPlayer()
            print(target, distance)
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(target), idCard)
            end
        end 
    end
)

RegisterNUICallback(
    "payBill",
    function(data, cb)
        ESX.TriggerServerCallback('esx_billing:payBill', function(paid)  
            if paid then
                SendNUIMessage(
                    {
                        action = "deleteBill",
                        id = data.billId
                    }
                )
            end
        end, data.billId)    
    end
)



RegisterNetEvent("inventory:showCard")
AddEventHandler("inventory:showCard", function(card, self)
    distance = -1
    idCard = ''

    if card == 0 then
        idCard = 'dni'
    end
    if card == 1 then
        idCard = 'drive'
    end
    if card == 2 then
        idCard = 'weapon'
    end

    if self then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), idCard)
    else
        target, distance = ESX.Game.GetClosestPlayer()
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), target, idCard)
    end
end)

function loadPlayerInventory()
    Citizen.CreateThread(function()  
        ESX.TriggerServerCallback(
            "esx_inventoryhud:getPlayerInventory",
            function(data)
                items = {}
                inventory = data.inventory
                accounts = data.accounts
                money = data.money
                weapons = data.weapons
                weight = data.weight
                maxWeight = data.maxWeight

                SendNUIMessage(
                    {
                        action = "setWeight",
                        weight = weight,
                        maxWeight = maxWeight
                    }
                )
                if Config.IncludeCash and money ~= nil and money > 0 then
                    moneyData = {
                        label = _U("cash"),
                        name = "cash",
                        type = "item_money",
                        count = money,
                        usable = false,
                        rare = false,
                        weight = -1,
                        canRemove = true
                    }

                    table.insert(items, moneyData)
                end

                if Config.IncludeAccounts and accounts ~= nil then
                    for key, value in pairs(accounts) do
                        if not shouldSkipAccount(accounts[key].name) then
                            local canDrop = accounts[key].name ~= "bank"

                            if accounts[key].money > 0 then
                                accountData = {
                                    label = accounts[key].label,
                                    count = accounts[key].money,
                                    type = "item_account",
                                    name = accounts[key].name,
                                    usable = false,
                                    rare = false,
                                    weight = -1,
                                    canRemove = canDrop
                                }
                                table.insert(items, accountData)
                            end
                        end
                    end
                end

                if inventory ~= nil then
                    for key, value in pairs(inventory) do
                        if inventory[key].count <= 0 then
                            inventory[key] = nil
                        else
                            inventory[key].type = "item_standard"
                            table.insert(items, inventory[key])
                        end
                    end
                end

                if Config.IncludeWeapons and weapons ~= nil then
                    for key, value in pairs(weapons) do
                        local weaponHash = GetHashKey(weapons[key].name)
                        local playerPed = PlayerPedId()
                        if weapons[key].name ~= "WEAPON_UNARMED" then
                            local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                            table.insert(
                                items,
                                {
                                    label = weapons[key].label,
                                    count = ammo,
                                    weight = -1,
                                    type = "item_weapon",
                                    name = weapons[key].name,
                                    usable = false,
                                    rare = false,
                                    canRemove = true
                                }
                            )
                        end
                    end
                end

                SendNUIMessage(
                    {
                        action = "setItems",
                        itemList = items
                    }
                )
            end,
            GetPlayerServerId(PlayerId())
        )
    end)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            if isInInventory then
                local playerPed = PlayerPedId()
                DisableAllControlActions(0)
                EnableControlAction(0, 47, true)
                EnableControlAction(0, 245, true)
                EnableControlAction(0, 38, true)
            end
            
            if not canOpenInventory then -- if inventory is being searched (can not be opened) - disable open control
                local playerPed = PlayerPedId()
                DisableControlAction(0, Config.OpenControl, true)
            else
                Citizen.Wait(2000)
            end
        end
    end
)
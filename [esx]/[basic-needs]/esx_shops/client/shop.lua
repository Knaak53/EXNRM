Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if payAmount > 0 then
            for shop = 1, #Config.Locations do
                local blip = Config.Locations[shop]["blip"]
                local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), blip["x"], blip["y"], blip["z"], true)
                if dist <= 20.0 then
                    if dist >= 12.0 then
                        ESX.ShowNotification("Has salido de la tienda, se ha vaciado la cesta de la compra!")
                        payAmount = 0
                        Basket = {}
                    end
                end
            end
        end
    end
end)

local title = "Tendero del Badulake"
local text
local imgName = "shop.png"

shelfsAlreadyTaken = {}

RegisterNetEvent('esx_shops:OpenAction')
AddEventHandler('esx_shops:OpenAction', function(action, entity)
    Citizen.Wait(250)
    OpenAction(action, Config.Items[action], entity)
end)

--[[ Check what to do ]]--
OpenAction = function(action, shelf, entity)
    if action == "checkout" then
        if not isThief then
            if payAmount > 0 and #Basket then
                CashRegister()
            else
                ESX.ShowNotification("No tienes nada en la cesta de la compra, usa las ~g~Estanterias~w~ para coger productos!")
            end
        else
            ESX.ShowNotification("No puedes comprar durante un atraco!")
        end     
    else
        if not isThief then
            ShelfMenu(shelf)
        else
            if canStealShelf(entity) then
                stealProducts(shelf)
                table.insert(shelfsAlreadyTaken, entity)
            else
                ESX.ShowNotification("Ya has registrado esa estanteria.")
            end
        end   
    end
end

function canStealShelf(entity)
    for i = 1, #shelfsAlreadyTaken do
        if entity == shelfsAlreadyTaken[i] then
            return false
        end
    end
    return true
end

function stealProducts(shelf)
    math.randomseed(GetGameTimer())
    local randomItemsCount = math.random(1, 100);
    local itemCount = 0
    if randomItemsCount > 30 then
        itemCount = 1
    elseif randomItemsCount <= 30 and randomItemsCount > 10 then
        itemCount = 2
    else
        itemCount = 3
    end

    randomItemsObtained = {}
    for i = 1, itemCount do
        math.randomseed(GetGameTimer())
        local randomItem = math.random(1, #shelf);
        math.randomseed(GetGameTimer())
        local randomItemCount = math.random(1, 100);
        local finalItemCount = 0;
        if randomItemCount > 40 then
            finalItemCount = 1
        elseif randomItemCount <= 40 and randomItemCount > 15 then
            finalItemCount = 2
        else
            finalItemCount = 3
        end
        local itemWithCount = shelf[randomItem]
        itemWithCount.count = finalItemCount
        table.insert(randomItemsObtained, itemWithCount)
        Citizen.Wait(10)
    end
    TriggerServerEvent("esx_shops:stealProducts", randomItemsObtained)
end

RegisterNUICallback("confirm", function(data, cb)
    TriggerEvent('esx_custom_messages:showMessage', "badulakes", true, "ticket")
    Citizen.Wait(4500)

    SendNUIMessage(
	    {
	        action = "pay"
	    }
	)	
end)

RegisterNUICallback("pay", function(data, cb)
	SetNuiFocus(false, false)
	ESX.TriggerServerCallback('99kr-shops:CheckMoney', function(hasMoney)
        if hasMoney then
            TriggerServerEvent('99kr-shops:Cashier', payAmount, Basket, data.method)
            payAmount = 0
            Basket = {}
            TriggerEvent('esx_custom_messages:showMessage', "badulakes", true, "bye")
        else
            ESX.ShowNotification("No tienes suficiente dinero!")
        end
    end, payAmount, data.method)  
end)

--[[ Cash register menu ]]--
CashRegister = function()
    SetNuiFocus(true, true) 
    TriggerEvent('esx_custom_messages:showMessage', "badulakes", true, "hello")
    Citizen.Wait(4500)   	
    
    local elements = {}

    for i=1, #Basket do
        local item = Basket[i]
        table.insert(elements, {
            label = item["label"],
            price = item["price"],
            amount = item["amount"]
        })
    end

    SendNUIMessage(
	    {
	        action = "cashier",
	        total = payAmount,
	        items = elements
	    }
	)
	      
end

--[[ Open shelf menu ]]--
ShelfMenu = function(shelf)
    local elements = {}
    for i=1, #shelf do
        local shelf = shelf[i]
        table.insert(elements, {
            realLabel = shelf["label"],
            label = shelf["label"] .. ' (<span style="color:green">€' .. shelf["price"] .. '</span>)',
            item = shelf["item"],
            price = shelf["price"]
        })
    end

    SendNUIMessage(
        {
            action = "shelf",
            items = elements
        }
    )
    SetNuiFocus(true, true)  
end

RegisterNUICallback("addProduct", function(data, cb)
    local alreadyHave, basketItem = CheckBasketItem(data.item.item)
    if alreadyHave then
        basketItem.amount = basketItem["amount"] + 1
    else
        table.insert(Basket, {
            label = data.item.realLabel,
            value = data.item.item,
            amount = 1,
            price = data.item.price
        })
    end
    payAmount = payAmount + data.item.price   
    ESX.ShowNotification("Pones 1 ~g~" .. data.item.realLabel .. "~w~ en la cesta.")
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

--[[ Check if item already in basket ]]--
CheckBasketItem = function(item)
    for i=1, #Basket do
        if item == Basket[i]["value"] then
            return true, Basket[i]
        end
    end
    return false, nil
end

--[[ Checks if key "L" is pressed ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if IsControlJustPressed(0, 182) then
            OpenBasket()
        end
    end
end)

-- [[ Opens basket menu ]]--
OpenBasket = function()
    if payAmount > 0 and #Basket then
        local elements = {}
        for i=1, #Basket do
            local item = Basket[i]
            table.insert(elements, {
                label = '<span style="color:red">*</span> ' .. item["label"] .. ': ' .. item["amount"] .. ' uds (<span style="color:green">€' .. item["price"] * item["amount"] .. '</span>)',
                value = "item_menu",
                index = i
            })
        end
        table.insert(elements, {label = '<span style="color:red">Vaciar cesta', value = "empty"})

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'basket',
            {
                title    = "Cesta de la compra",
                align    = 'left',
                elements = elements
            },
            function(data, menu)
                if data.current.value == 'empty' then
                    Basket = {}
                    payAmount = 0
                    menu.close()
                    ESX.ShowNotification("Has vaciado la cesta.") 
                end
                if data.current.value == "item_menu" then
                    menu.close()
                    local index = data.current.index
                    local shopItem = Basket[index]

                    -- [[ Opens detailed (kinda) menu about item ]] --
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'basket_detailedmenu',
                        {
                            title    = "Cesta de la compra - " .. shopItem["label"] .. " - " .. shopItem["amount"] .. "uds",
                            align    = 'left',
                            elements = {
                                {label = '<span style="color:red">Sacar objeto</span>', value = "deleteItem"},
                            },
                        },
                        function(data2, menu2)
                            if data2.current["value"] == "deleteItem" then
                                ESX.ShowNotification("Has quitado " .. Basket[index]["amount"] .." ".. Basket[index]["label"] .. " de la cesta.") 
                                payAmount = payAmount - (Basket[index]["amount"] * Basket[index]["price"])
                                table.remove(Basket, index)
                                OpenBasket()
                            end
                        end,
                        function(data2, menu2)
                            menu2.close()
                            OpenBasket()
                        end
                    )
                    
                    -- [[ Back to normal basket menu ]] --
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    else
        ESX.UI.Menu.CloseAll()
    end
end

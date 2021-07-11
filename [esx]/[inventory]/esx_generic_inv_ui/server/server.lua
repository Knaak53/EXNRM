local availablePlates = {}
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
  end)

local vehiclestrunks = {}
AddEventHandler("esx:dataItemsReady", function()
    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end)
end)

--MySQL.ready(function()
--    MySQL.Async.fetchAll(
--        'SELECT plate FROM owned_vehicles',
--        {
--        },
--    function(result)
--        if result ~= nil and #result > 0 then
--            for i = 1, #result do
--              availablePlates[i] = result[i].plate
--            end
--        end
--    end)
--end)


function getItemWeight(item)
    --local weight = 0
    --local itemWeight = 0
    --if item ~= nil then
    --  itemWeight = Config.DefaultWeight
    --  if arrayWeight[item] ~= nil then
    --    itemWeight = arrayWeight[item]
    --  end
    --end
    local weight = ESX.GetWeaponWeight(item)
    if weight then
        return weight
    else
        print(item)
        return ESX.getItems()[item].weight
    end
end

function getInventoryWeight(inventory)
    local weight = 0
    local itemWeight = 0
    if inventory ~= nil then
        for i = 1, #inventory, 1 do
            if inventory[i] ~= nil then
                itemWeight = 1.0
                if getItemWeight(inventory[i].name) ~= nil then
                    itemWeight = getItemWeight(inventory[i].name)
                end
                weight = weight + (itemWeight * (inventory[i].count or 1))
            end
        end
    end
    return weight
end

function getTotalInventoryWeight(plate)
    local total
    TriggerEvent(
        "esx_trunk:getSharedDataStore",
        plate,
        function(store)
            local W_weapons = getInventoryWeight(store.get("weapons") or {})
            local W_coffre = getInventoryWeight(store.get("coffre") or {})
            local W_blackMoney = 0
            local blackAccount = (store.get("black_money")) or 0
            if blackAccount ~= 0 then
                W_blackMoney = blackAccount[1].amount / 10
            end

            local W_cashMoney = 0
            local cashAccount = (store.get("money")) or 0
            if cashAccount ~= 0 then
                W_cashMoney = cashAccount[1].amount / 10
            end
            total = W_weapons + W_coffre + W_blackMoney + W_cashMoney
        end
    )
    return total
end

function IsPlateRegistered(plate)
    for i = 1, #availablePlates do
      return true
    end
    return false
end

SocietyBeingSearch = {}
HouseBeingSearch = {}
TrunkBeingSearch = {}
PlayerBeingSearch = {}

ESX.RegisterServerCallback('esx_generic_inv_ui:getSocietyInv',function(source,cb, dataStoreName)
    TriggerEvent('esx_datastore:getSharedDataStore', dataStoreName, function(store)
        if not SocietyBeingSearch[dataStoreName] then
            SocietyBeingSearch[dataStoreName] = {}
        end
        table.insert(SocietyBeingSearch[dataStoreName], source)
    	print(json.encode(store.getData()))
        local data = {}
        print(json.encode(store.get("accounts")))
        data.accounts = store.get("accounts") or {}
        data.items = store.get("coffre") or {}
        data.weapons = store.get("weapons") or {}
        cb(data)		    
    end)
end)

ESX.RegisterServerCallback('esx_generic_inv_ui:getOtherPlayerInv', function(source,cb, target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(target)
    local ret = {}
    if not PlayerBeingSearch[target] then
        PlayerBeingSearch[target] = {}
    end
    table.insert(PlayerBeingSearch[target], _source)
    ret.accounts = {}
    ret.items = {}
    ret.weapons = {}
    ret.weight = xPlayer.getMaxWeight()
    ret.playerName = xPlayer.get("identity").real.name
    inventory = xPlayer.getInventory()
    loadout = xPlayer.getLoadout()
    accounts = xPlayer.getAccounts()
    for k, v in pairs(inventory) do
        if v.count > 0 then
          v.type = 'item'
          table.insert(ret.items, v)
        end
    end
    for k, v in pairs(loadout) do
        v.type = 'weapon'
        table.insert(ret.weapons, v)
    end
    for k, v in pairs(accounts) do
        if v.name == 'money' or v.name == 'black_money' and v.money > 0 then
            v.type = 'account'
            table.insert(ret.accounts, v)
        end
    end
    cb(ret)
end)

ESX.RegisterServerCallback('esx_generic_inv_ui:getHouseInv',function(source,cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerEvent('esx_datastore:getDataStore', 'housing', xPlayer.getIdentifier(), function(storage)
        if not HouseBeingSearch[xPlayer.getIdentifier()] then
            HouseBeingSearch[xPlayer.getIdentifier()] = {}
        end
        table.insert(HouseBeingSearch[xPlayer.getIdentifier()], source)
        local inventory = storage.get('inventory') or {}
        if inventory.items and inventory.weapons and inventory.accounts then
            cb(inventory)
        else
            local newInventory = {}
            newInventory.accounts = {}
            newInventory.items = {}
            newInventory.weapons = {}
            newInventory.maxWeight = 65
            storage.set('inventory', newInventory)
            cb(newInventory)
        end
    end)
end)

ESX.RegisterServerCallback('esx_generic_inv_ui:getTrunkInv',function(source,cb,plate, vehId)
    GetSharedDataStore(plate,function(trunk) 
        if not TrunkBeingSearch[plate] then
            TrunkBeingSearch[plate] = {}
            TrunkBeingSearch[plate.."Id"] = vehId
        end
        if not (#TrunkBeingSearch > 0) then
            print("vehid:"..vehId)
            local veh = NetworkGetEntityFromNetworkId(vehId)
            local owner = NetworkGetEntityOwner(veh)
            TriggerClientEvent("vehcontrol:opentrunk", owner, TrunkBeingSearch[plate.."Id"], 5)
        end
        table.insert(TrunkBeingSearch[plate], source)
        
        
        print(json.encode(TrunkBeingSearch[plate]))
        --TriggerEvent("esx_trunk:startSearching",plate, source)
        local data = {}
        data.accounts = trunk.get("accounts") or {}
        data.items = trunk.get("coffre") or {}
        data.weapons = trunk.get("weapons") or {}
        cb(data) --TODO Hacer que utilice datos apropiados o reconvertir la estructura
    end)
    --if IsPlateRegistered(plate) then
    --    MySQL.Async.fetchAll(
    --      'SELECT data FROM trunk_inventory WHERE plate = @plate',
    --      {
    --        ['@plate'] = plate
    --      },
    --    function(result)
    --        if result ~= nil and result[1] then
    --            cb(json.decode(result[1].data))
    --        end
    --    end)
    --else
    --    cb(false)
    --end
end)

ESX.RegisterServerCallback('esx_generic_inv_ui:getPlayerInv', function(source,cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ret = {}

    ret.accounts = {}
    ret.items = {}
    ret.weapons = {}
    ret.weight = xPlayer.getMaxWeight()
    ret.currentWeight = xPlayer.getWeight()

    inventory = xPlayer.getInventory()
    loadout = xPlayer.getLoadout()

    for k, v in pairs(inventory) do
        if v.count > 0 then
          v.type = 'item'
          table.insert(ret.items, v)
        end
    end

    for k, v in pairs(loadout) do
        v.type = 'weapon'
        table.insert(ret.weapons, v)
    end
    
    cb(ret)
end)

ESX.RegisterServerCallback('esx_generic_inv_ui:getPlayerInvComplete', function(source,cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ret = {}

    ret.accounts = {}
    ret.items = {}
    ret.weapons = {}
    ret.weight = xPlayer.getMaxWeight()
    ret.currentWeight = xPlayer.getWeight()

    inventory = xPlayer.getInventory()
    loadout = xPlayer.getLoadout()
    accounts = xPlayer.getAccounts()

    for k, v in pairs(inventory) do
        if v.count > 0 then
          v.type = 'item'
          table.insert(ret.items, v)
        end
    end

    for k, v in pairs(loadout) do
        v.type = 'weapon'
        table.insert(ret.weapons, v)
    end

    for k, v in pairs(accounts) do
        if v.name == 'money' or v.name == 'black_money' and v.money > 0 then
            v.type = 'account'
            table.insert(ret.accounts, v)
        end
    end
    
    cb(ret)
end)

RegisterServerEvent('esx_generic_inv_ui:updateSociety')
AddEventHandler('esx_generic_inv_ui:updateSociety', function(societyName, currentData, itemAdds, itemRemoves)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    --removeItems(itemRemoves, xPlayer)
    --addItems(itemAdds, xPlayer)
    
    TriggerEvent('esx_datastore:getSharedDataStore', societyName, function(store)
        --store.set('inventory', currentData)
        updateInventory(store, itemAdds, itemRemoves, xPlayer, SocietyBeingSearch, societyName)
        
    end)
   
end)

RegisterServerEvent('esx_generic_inv_ui:updateHouse')
AddEventHandler('esx_generic_inv_ui:updateHouse', function(currentData, itemAdds, itemRemoves)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    --removeItems(itemRemoves, xPlayer)
    --addItems(itemAdds, xPlayer)
    
    TriggerEvent('esx_datastore:getDataStore', 'housing', xPlayer.getIdentifier(), function(storage)
        --storage.set('inventory', currentData)
        updateInventory(storage, itemAdds, itemRemoves, xPlayer, HouseBeingSearch, xPlayer.getIdentifier())
    end)

end)

invCooldoowns = {}




RegisterServerEvent('esx_generic_inv_ui:updateTrunk')
AddEventHandler('esx_generic_inv_ui:updateTrunk', function(plate, trunkData, itemAdds, itemRemoves)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    

    GetSharedDataStore(plate,function(trunk) 

        --if not TrunkBeingSearch[plate] then
        --    TrunkBeingSearch[plate] = {}
        --end
        --table.insert(TrunkBeingSearch[plate], _source)
        updateInventory(trunk, itemAdds,itemRemoves, xPlayer, TrunkBeingSearch, plate)
    end)
        
    
end)

function updateInventory(inventory, itemAdds, itemRemoves, xPlayer, playerSearching, invIdentifier)
    
    if invIdentifier then
        if invCooldoowns[invIdentifier] then
           xPlayer.showNotification('Se acaba de usar este inventario, espera 1 segundo')
           return
        else
        invCooldoowns[invIdentifier] = true
        end
    end
    

    
    for k,v in pairs(itemAdds) do
        ----------------------------------
        if v.type == "item" then
            local targetItem = xPlayer.getInventoryItem(v.name)
            local tempAdd = {}
            if xPlayer.canCarryItem(v.name, v.amount) then
                -- if targetItem.weight == -1 or ((targetItem.count + count) <= 50) then
                local coffre = (inventory.get("coffre") or {})
                for i = 1, #coffre, 1 do
                    if coffre[i].name == v.name then
                        if (coffre[i].count >= v.amount and v.amount > 0) then
                            table.insert(tempAdd,{name = v.name, amount = v.amount})
                            if (coffre[i].count - v.amount) == 0 then
                                table.remove(coffre, i)
                            else
                                coffre[i].count = coffre[i].count - v.amount
                            end

                            break
                        else
                            --TriggerClientEvent(
                            --    "b1g_notify:client:Notify",
                            --    _source,
                            --    {type = "true", text = _U("invalid_quantity")}
                            --)
                        end
                    end
                end

                inventory.set("coffre", coffre)

                for k,v in pairs(tempAdd) do
                    xPlayer.addInventoryItem(v.name, v.amount)
                end
            else
                TriggerClientEvent(
                    "b1g_notify:client:Notify",
                    _source,
                    {type = "false", text = _U("player_inv_no_space")}
                )
            end
        end
        
        if v.type == "account" then
            print(json.encode(v))
            local playerAccount = xPlayer.getAccount(v.name)
            local playerAccountMoney = playerAccount.money
            local accounts = (inventory.get("accounts") or {})
            local found = false
            for j,z in pairs(accounts) do
                if accounts[j].name == v.name then
                    found = true
                end
            end
            if found then
                for j,z in pairs(accounts) do
                    if z.name == v.name then
                        if (accounts[j].money >= v.amount and v.amount > 0) then
                            local found = false
                            accounts[j].money = accounts[j].money - v.amount
                            xPlayer.addAccountMoney(v.name, v.amount)
                            
                        end
                    end
                end
            end
            inventory.set("accounts", accounts)
        end
        print("type: "..v.type)
        if v.type == "weapon" then
            local storeWeapons = inventory.get("weapons")
            --print(json.encode(storeWeapons))
            if storeWeapons == nil then
                storeWeapons = {}
            end

            local weaponName = nil
            local ammo = nil
            local components = {}
            for i = 1, #storeWeapons, 1 do
                if storeWeapons[i].serial == v.serial then
                    weaponName = storeWeapons[i].name
                    ammo = storeWeapons[i].ammo
                    print(json.encode(storeWeapons[i].components))
                    components = {table.unpack(storeWeapons[i].components)}
                    table.remove(storeWeapons, i)

                    break
                end
            end

            inventory.set("weapons", storeWeapons)

            xPlayer.addWeapon(weaponName, ammo, v.serial)
            
            for k,v in pairs(components) do
                xPlayer.addWeaponComponent(weaponName, v)
                print("NOMBRE ARMA: "..weaponName)
                print("NOMBRE COMPONENTE: "..v)
            end
        end




        --------------------------------------
        --if v.type == 'account' then
        --    if v.amount <= trunk.get(v.name) then
        --        local item = trunk.get(v.name)
        --        trunk.set(v.name, item - v.amount)
        --        xPlayer.addAccountMoney(v.name,v.amount)
        --    else
        --        xPlayer.showNotification('ERROR')
        --    end
        --    --xPlayer.removeAccountMoney(v.name, v.amount)
        --elseif v.type == 'item' then
        --    if v.amount <= trunk.get(v.name) then
        --        local item = trunk.get(v.name)
        --        trunk.set(v.name, item - v.amount)
        --        xPlayer.addInventoryItem(v.name,v.amount)
        --    end
        --    xPlayer.removeInventoryItem(v.name, v.amount)
        --elseif v.type == 'weapon' then
        --    if v.amount <= trunk.get("weapons") then
        --        local weapons = trunk.get("weapons")
        --        trunk.set(v.name, weapon - v.amount)
        --        xPlayer.addWeapon(v.name, weapon.ammo)
        --        if v.components then
        --            for j,z in pairs(v.components) do
        --                xPlayer.addWeaponComponent(v.name, z)
        --            end
        --        end
        --end
        --end
    end

    for k,v in pairs(itemRemoves) do
        if v.type == "item" then
            local playerItemCount = xPlayer.getInventoryItem(v.name).count
            local playerItemlabel = xPlayer.getInventoryItem(v.name).label -- TODO CORREGIR

            if (playerItemCount >= v.amount and v.amount > 0) then
                local found = false
                local coffre = (inventory.get("coffre") or {})

                for i = 1, #coffre, 1 do
                    if coffre[i].name == v.name then
                        coffre[i].count = coffre[i].count + v.amount
                        found = true
                    end
                end
                if not found then
                    table.insert(
                        coffre,
                        {
                            name = v.name,
                            label = playerItemlabel,
                            count = v.amount,
                            type = "item", -- TODO tipo variable, mejor tipo segun la  tabla????
                            weight = getItemWeight(v.name)
                            
                        }
                    )
                end
                --if (getTotalInventoryWeight(plate) + (getItemWeight(v.name) * v.amount)) > max then
                --    TriggerClientEvent(
                --        "b1g_notify:client:Notify",
                --        _source,
                --        {type = "true", text = _U("insufficient_space")}
                --    )
                --else
                    -- MySQL.Async.execute(
                    --   "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
                    --   {
                    --     ["@plate"] = plate,
                    --     ["@owned"] = owned
                    --   }
                    -- )
                    -- Checks passed, storing the item.
                    inventory.set("coffre", coffre)
                    xPlayer.removeInventoryItem(v.name, v.amount)
                --end
            else
                --TriggerClientEvent("b1g_notify:client:Notify", _source, {type = "true", text = _U("invalid_quantity")})
            end
        end

        if v.type == "account" then
            local playerAccount = xPlayer.getAccount(v.name)
            local playerAccountMoney = playerAccount.money
            if (playerAccountMoney >= v.amount and v.amount > 0) then
                local accounts = (inventory.get("accounts") or {})
                local found = false
                for j,z in pairs(accounts) do
                    if accounts[j].name == v.name then
                        found = true
                    end
                end
                if found then
                    for j,z in pairs(accounts) do
                        if z.name == v.name then
                            accounts[j].money = accounts[j].money + v.amount
                        end
                    end
                else
                    --accounts = {}
                    table.insert(accounts, {type = "account", name = v.name, money = v.amount, label = playerAccount.label})
                end

                --if (getTotalInventoryWeight(plate) + blackMoney[1].amount / 10) > max then
                --    TriggerClientEvent(
                --        "b1g_notify:client:Notify",
                --        _source,
                --        {type = "true", text = _U("insufficient_space")}
                --    )
                --else
                    --MySQL.Async.execute(
                    --  "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
                    --  {
                    --    ["@plate"] = plate,
                    --    ["@owned"] = owned
                    --  }
                    --)
                    -- Checks passed. Storing the item.
                    xPlayer.removeAccountMoney(v.name, v.amount)
                    print(json.encode(accounts))
                    inventory.set("accounts", accounts)
                --end
            else
                TriggerClientEvent("b1g_notify:client:Notify", _source, {type = "true", text = _U("invalid_amount")})
            end
        end

        if v.type == "weapon" then
            local storeWeapons = inventory.get("weapons")

            if storeWeapons == nil then
                storeWeapons = {}
            end
            local index,weapon = xPlayer.getWeapon(v.name)
            if weapon then
                --print(json.encode(v))
                table.insert(
                    storeWeapons,
                    {
                        name = v.name,
                        label = ESX.GetWeaponLabel(v.name)..": "..weapon.serial,
                        ammo = weapon.ammo, 
                        components = weapon.components or {},
                        type = "weapon",
                        serial = weapon.serial,
                    }
                )
                --if (getTotalInventoryWeight(plate) + (getItemWeight(v.name))) > max then
                --    TriggerClientEvent(
                --        "b1g_notify:client:Notify",
                --        _source,
                --        {type = "true", text = _U("invalid_amount")}
                --    )
                --else
                    --MySQL.Async.execute(
                    --  "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
                    --  {
                    --    ["@plate"] = plate,
                    --    ["@owned"] = owned
                    --  }
                    --)
                    inventory.set("weapons", storeWeapons)
                    xPlayer.removeWeapon(v.name)
                --end
            end
        end
        --if plate then
            --TriggerEvent("esx_trunk:isBeingSearchedTrunk", function(people)
                --print("BBBB")
                
            --end,plate)
        --end

    end

    local data = {}
    print(json.encode(playerSearching[invIdentifier]))
    local indexToRemove = nil
    for k,v in pairs(playerSearching[invIdentifier]) do
        --if v ~= xPlayer.source then
            print("TTT")
            print(v)
            data.accounts = inventory.get("accounts") or {}
            data.items = inventory.get("coffre") or {}
            data.weapons = inventory.get("weapons") or {}
            print(json.encode(data))
            --print(json.encode(trunkData))
            local xTarget = ESX.GetPlayerFromId(v)
            print("itemadds: "..json.encode(itemAdds))
            for k,v in pairs(itemAdds) do
                xTarget.showNotification(xPlayer.getName() .. " Ha sacado del maletero: "..v.name .. " x ".. v.amount)
            end
            TriggerClientEvent("esx_generic_inv_ui:updateData", v, data)
        --else
            --indexToRemove = k
        --end
    end
    
    SetTimeout(1000, function() 
        invCooldoowns[invIdentifier] = false
    end)
    --trunk.data = trunkData
    --removeItems(itemRemoves, xPlayer)
    --addItems(itemAdds, xPlayer)
end

RegisterServerEvent("esx_generic_inv_ui:cancelSearching")
AddEventHandler("esx_generic_inv_ui:cancelSearching", function(containerName, tipo)
    local _source = source
    local tableToSearch = {}
    if tipo == 'society' then
        tableToSearch = SocietyBeingSearch        
    end
    if tipo == 'trunk' then
        tableToSearch = TrunkBeingSearch
    end
    if tipo == 'house'then
        tableToSearch = HouseBeingSearch
    end
    if tipo == 'player'then
        tableToSearch = PlayerBeingSearch
    end
    if tableToSearch[containerName] then
    	for k, v in pairs(tableToSearch[containerName]) do
	        if v == _source then
                table.remove(tableToSearch[containerName], k)
                if tipo == "trunk" then
                    print("eeh si")
                    if #tableToSearch < 1 then
                        print("eeh si isisis")
                        local veh = NetworkGetEntityFromNetworkId(TrunkBeingSearch[containerName.."Id"])
                        local owner = NetworkGetEntityOwner(veh)
                        
                        TriggerClientEvent("vehcontrol:closetrunk", owner, TrunkBeingSearch[containerName.."Id"], 5)
                    end
                end
	        end
	    end
    end
end)

RegisterServerEvent('esx_generic_inv_ui:takeTrash')
AddEventHandler('esx_generic_inv_ui:takeTrash', function(itemAdds)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    addItems(itemAdds, xPlayer)
end)

function removeItems(items, xPlayer)
    for i = 1, #items do
        if items[i].type == 'account' then
            xPlayer.removeAccountMoney(items[i].name, items[i].amount)
        elseif items[i].type == 'item' then
            xPlayer.removeInventoryItem(items[i].name, items[i].amount)
        else
            xPlayer.removeWeapon(items[i].name)
        end
    end
end

function addItems(items, xPlayer)
    for i = 1, #items do
        if items[i].type == 'account' then
            xPlayer.addAccountMoney(items[i].name, items[i].amount)
        elseif items[i].type == 'item' then
            xPlayer.addInventoryItem(items[i].name, items[i].amount)
        else
            xPlayer.addWeapon(items[i].name, items[i].amount)
            if items[i].components and #items[i].components > 0 then
                for j= 1, #items[i].components do
                    xPlayer.addWeaponComponent(items[i].name, items[i].components[j])
                end
            end
        end
    end
end
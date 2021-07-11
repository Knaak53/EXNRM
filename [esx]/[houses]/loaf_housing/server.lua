ESX = nil


ESX = exports.extendedmode:getSharedObject()
function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

Citizen.CreateThread(function() 
    
    while tablelength(ESX.getsData()) < 1 do
        ESX = exports.extendedmode:getSharedObject()
        Wait(2000)
    end
end)


local instances = {}
local houses = {}

RegisterServerEvent('loaf_housing:enterHouse')
AddEventHandler('loaf_housing:enterHouse', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    --xPlayer.get("")
        --print ("1")
        
    local house = xPlayer.get("house")
    local furniture
    local shared
    --checkeamos si es compartida
    local sfound = false
    local mfurniture
    if house.shared then
        shared = ESX.getsData().get("sharedhouses")
        furniture = shared[""..house.houseId].bought_furniture
        house = shared[""..house.houseId].house
        mfurniture = house.furniture
    else
        furniture = xPlayer.get('bought_furniture')
    end
    
    if furniture == nil then
        furniture = {}
        print("vacia de muebles!!!")
    end
    print(json.encode(furniture))
    if house.shared then
        print("compartida!!!")
    end
    if house.houseId == id and instances[src] == nil then
        for k, v in pairs(Config.HouseSpawns) do
            if not v['taken'] then
                for k,v in pairs(instances) do
                    if house.shared and v.id == id then
                        TriggerEvent('loaf_housing:knockDoor', id, src)
                        sfound = true
                        break
                    end
                end
                if not sfound then
                    if house.shared then
                        TriggerClientEvent('loaf_housing:reloadHouses', src)
                        Wait(2000)
                    end
                    TriggerClientEvent('loaf_housing:spawnHouse', xPlayer.source, v['coords'], furniture)
                    print ("2")
                    instances[src] = {['id'] = id, ['owner'] = src, ['coords'] = v['coords'], ['housespawn'] = k, ['players'] = {}, ['furniture'] = mfurniture}
                    instances[src]['players'][src] = src
                    houses[id] = src
                    v['taken'] = true
                    return
                end
                    --print(json.encode(houses[id]))
            end
        end
    else
        print(('There seems to be some kind of error in the script "%s", #%s tried to enter house %s but he/she doesn\'t own house #%s.'):format(GetCurrentResourceName(), xPlayer.identifier, id, id))
    end
end)

RegisterServerEvent('loaf_housing:buy_furniture')
AddEventHandler('loaf_housing:buy_furniture', function(category, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hadMoney = false
    if Config.Furniture[Config.Furniture['Categories'][category][1]][id] then
        if xPlayer.getAccount('bank').money >= Config.Furniture[Config.Furniture['Categories'][category][1]][id][3] then
            xPlayer.removeAccountMoney('bank', Config.Furniture[Config.Furniture['Categories'][category][1]][id][3])
            hadMoney = true
        else
            if xPlayer.getMoney() >= Config.Furniture[Config.Furniture['Categories'][category][1]][id][3] then
                xPlayer.removeMoney(Config.Furniture[Config.Furniture['Categories'][category][1]][id][3])
                hadMoney = true
            else
                TriggerClientEvent('esx:showNotifciation', xPlayer.source, Strings['no_money'])
            end
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'There seems to be some kind of error in the script, could not buy furniture.')
    end

    if hadMoney then
        local house = xPlayer.get("house")
        local furniture
        if house.shared then
            furniture = ESX.getsData().get("sharedhouses")[""..house.houseId].bought_furniture
        else
            furniture = xPlayer.get("bought_furniture")
        end
         
        if furniture == nil then
            furniture = {}
        end
        if furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]] then 
            furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]]['amount'] = furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]]['amount'] + 1
        else
            furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]] = {['amount'] = 1, ['name'] = Config.Furniture[Config.Furniture['Categories'][category][1]][id][1]}
        end
        if house.shared then
            local sharedHouses = ESX.getsData().get("sharedhouses")
            sharedHouses[""..house.houseId].bought_furniture = furniture
            ESX.getsData().set("sharedhouses",sharedHouses) 
        else
            xPlayer.set("bought_furniture", furniture)
        end
        
        --MySQL.Async.execute("UPDATE users SET bought_furniture=@bought_furniture WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@bought_furniture'] = json.encode(furniture)}) 
        TriggerClientEvent('esx:showNotification', xPlayer.source, (Strings['Bought_Furniture']):format(Config.Furniture[Config.Furniture['Categories'][category][1]][id][1], Config.Furniture[Config.Furniture['Categories'][category][1]][id][3]))
    end
end)

RegisterServerEvent('loaf_housing:leaveHouse')
AddEventHandler('loaf_housing:leaveHouse', function(house)
    local src = source
    if instances[houses[house]]['players'][src] then
        local oldPlayers = instances[houses[house]]['players']
        local newPlayers = {}
        for k, v in pairs(oldPlayers) do
            if v ~= src then
                newPlayers[k] = v
            end
        end
        instances[houses[house]]['players'] = newPlayers
    end
end)

RegisterServerEvent('loaf_housing:deleteInstance')
AddEventHandler('loaf_housing:deleteInstance', function()
    local src = source
    if instances[src] then
        Config.HouseSpawns[instances[src]['housespawn']]['taken'] = false
        for k, v in pairs(instances[src]['players']) do
            TriggerClientEvent('loaf_housing:leaveHouse', v, instances[src]['id'])
        end
        instances[src] = nil
    end
end)

RegisterServerEvent('loaf_housing:letIn')
AddEventHandler('loaf_housing:letIn', function(plr, storage)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    print("dejar entrar")
    if instances[src] then
        print("existe")
        if not instances[src]['players'][plr] then 
            instances[src]['players'][plr] = plr

            local spawnpos = instances[src]['housecoords']
            local furniture = instances[src]['furniture']
            local house = xPlayer.get("house")
            if house.shared then
                house = ESX.getsData().get("sharedhouses")[""..house.houseId].house
                furniture = house.furniture
            else
                furniture = house.furniture
            end
            print("lanzando")
            print(plr)
            TriggerClientEvent('loaf_housing:knockAccept', plr, instances[src]['coords'], instances[src]['id'], storage, spawnpos, furniture, src)
        end
    end
end)

RegisterServerEvent('loaf_housing:unKnockDoor')
AddEventHandler('loaf_housing:unKnockDoor', function(id, _source)
    local src = source
    if instances[houses[id]] then
        TriggerClientEvent('loaf_housing:removeDoorKnock', instances[houses[id]]['owner'], src)
    end
end)

RegisterServerEvent('loaf_housing:knockDoor')
AddEventHandler('loaf_housing:knockDoor', function(id,_source)
    local src
    if _source then
        src = _source
    else
        src = source
    end
    if instances[houses[id]] then
        TriggerClientEvent('loaf_housing:knockedDoor', instances[houses[id]]['owner'], src)
    else
        TriggerClientEvent('esx:showNotification', src, Strings['Noone_Home'])
    end
end)

RegisterServerEvent('loaf_housing:setInstanceCoords')
AddEventHandler('loaf_housing:setInstanceCoords', function(coords, housecoords, prop, placedfurniture)
    local src = source
    if instances[src] then
        instances[src]['coords'] = coords
        instances[src]['housecoords'] = housecoords
        instances[src]['furniture'] = placedfurniture
    end
end)

RegisterServerEvent('loaf_housing:exitHouse')
AddEventHandler('loaf_housing:exitHouse', function(id)
    local src = source
    if instances[src] then
        for k, v in pairs(instances['players']) do
            TriggerEvent('loaf_housing:exitHouse',v, id)
            table.remove(instances, src)
            table.remove(houses, id)
        end
    else
        for k, v in pairs(instances) do
            if v['players'][src] then
                table.remove(v['players'], src)
            end
        end
    end
end)

RegisterServerEvent('loaf_housing:buyHouse')
AddEventHandler('loaf_housing:buyHouse', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    local house = xPlayer.get("house")
    print(xPlayer.get("house"))
    if house ~= nil then
        print(house.houseId)
        if house.houseId == 0 then
            local bought_houses = ESX.getsData().get("bought_houses")
            if bought_houses == nil then
                bought_houses = {}
            end
            print("casas compradas: "..json.encode(bought_houses))
            local newHouse = {owns = false, furniture = {} ,houseId = id}
            if bought_houses[id] == nil then
            
                if xPlayer.getAccount('bank').money >= Config.Houses[id]['price'] then
                    xPlayer.removeAccountMoney('bank', Config.Houses[id]['price'])
                    xPlayer.set("house", newHouse)
                    table.insert(bought_houses, id)
                    ESX.getsData().set("bought_houses", bought_houses)
                    --MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = newHouse}) 
                   -- MySQL.Sync.execute("INSERT INTO bought_houses (houseid) VALUES (@houseid)", {['houseid'] = id})
                else
                    if xPlayer.getMoney() >= Config.Houses[id]['price'] then
                        xPlayer.removeMoney(Config.Houses[id]['price'])
                        xPlayer.set("house", newHouse)
                        table.insert(bought_houses, id)
                        ESX.getsData().set("bought_houses", bought_houses)
                        --MySQL.Sync.execute("INSERT INTO bought_houses (houseid) VALUES (@houseid)", {['houseid'] = id})
                        --MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = newHouse}) 
                    else
                        TriggerClientEvent('esx:showNotification', xPlayer.source, Strings['No_Money'])
                    end
                end

            end
        end
    end

    Wait(1500)
    TriggerClientEvent('loaf_housing:reloadHouses', -1)
end)

RegisterServerEvent('loaf_housing:sellHouse')
AddEventHandler('loaf_housing:sellHouse', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local shared
    local house = xPlayer.get("house")
    if house.shared then
        shared = ESX.getsData().get("sharedhouses")
        house = shared[""..house.houseId].house
    end
    
    if house ~= nil then
        if Config.Houses[house.houseId]['price'] then
            xPlayer.addMoney(Config.Houses[house.houseId]['price'] * (Config.SellPercentage/100))
            TriggerClientEvent('esx:showNotification', xPlayer.source, (Strings['Sold_House']):format(math.floor(Config.Houses[house.houseId]['price'] * (Config.SellPercentage/100))))
            TriggerEvent("s2v_parkings:DeleteParking", xPlayer.source, xPlayer.getIdentifier())
            local bought_houses = ESX.getsData().get("bought_houses")
            print(json.encode(bought_houses))
            table.remove(bought_houses, tablefind(bought_houses, house.houseId))
            --bought_houses[house.houseId] = nil
            
            ESX.getsData().set("bought_houses", bought_houses)
            print(json.encode(bought_houses))
            
           
            if house.shared and shared[""..house.houseId] then
                --table.remove(shared, house.houseId)
                shared[""..house.houseId] = nil
                ESX.getsData().set("sharedhouses", shared)
            end
            house = {owns = false, furniture = {} ,houseId = 0}
            xPlayer.set("house", house)
            TriggerClientEvent("loaf_housing:setPark", source, false)
            --MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = '{"owns":false,"furniture":[],"houseId":0}'}) 
            --MySQL.Async.execute("DELETE FROM bought_houses WHERE houseid=@houseid", {['@houseid'] = house.houseId}) 
        end
    end
    Wait(1500)
    TriggerClientEvent('loaf_housing:reloadHouses', -1)
end)

function tablefind(tab,el)
    for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
end



RegisterServerEvent('loaf_housing:getOwned')
AddEventHandler('loaf_housing:getOwned', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    --MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
        --local house = json.decode(result[1].house)
        --MySQL.Async.fetchAll("SELECT * FROM bought_houses", {}, function(result)
            print("casas:"..json.encode(ESX.getsData().get("bought_houses")))
        if ESX.getsData().get("bought_houses") == nil then
            ESX.getsData().set("bought_houses", {})
        end

        if xPlayer.get("house") == nil then
            xPlayer.set("house",{owns = false, furniture = {} ,houseId = 0})
        end
            
        local house = xPlayer.get("house")
        local bought_houses = ESX.getsData().get("bought_houses")

        if house.shared then
            if ESX.getsData().get("sharedhouses")[""..house.houseId] then
                house = ESX.getsData().get("sharedhouses")[""..house.houseId].house
                print("existeh")
            else
                print("que pacha")
                xPlayer.set("house",{owns = false, furniture = {} ,houseId = 0})
                house = {owns = false, furniture = {} ,houseId = 0}
                xPlayer.showNotification('Tu compañero de vivienda ha vendido la propiedad')
            end
        end
        --print(json.encode(ESX.getsData().get("sharedhouses")))
        --print(json.encode(ESX.getsData().get("bought_houses")))

        --print(json.encode(xPlayer.get("house")))
        --print(json.encode(ESX.getsData().get("bought_houses")))

        TriggerClientEvent('loaf_housing:setHouse', xPlayer.source, house, bought_houses)
        --end)
    --end)
end)

RegisterServerEvent("loaf_housing:HouseSetted")
AddEventHandler("loaf_housing:HouseSetted", function(id, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local house = xPlayer.get("house")
    local identity = xPlayer.get("identity")
    print(coords)
    local nCoords = vec(coords.x, coords.y, coords.z + 1)
    if id == house.houseId and coords ~= false and coords ~= nil then
        TriggerEvent('s2v_parkings:CreateParking', source, xPlayer.getIdentifier(),"Garage de "..identity.real.firstname,'shell_garagem',Config.Houses[house.houseId]['parking'],"private",1,3,267,38)
    else
        print("error")
    end
end)

--RegisterCommand("resethousedata", function(source) 
--    local xPlayer = ESX.GetPlayerFromId(source)
--    xPlayer.set("house",{owns = false, furniture = {} ,houseId = 0})
--    xPlayer.set("bought_furniture", {})
--    ESX.getsData().set("bought_houses", {})
--    ESX.getsData().set("sharedhouses", {})
--end, true)

RegisterServerEvent('loaf_housing:furnish')
AddEventHandler('loaf_housing:furnish', function(house, furniture)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    --print(json.encode(house))
    --print( sharedHouses[house.houseId].house)
    local housed =  xPlayer.get("house")
    
    if housed.shared then
        local sharedHouses = ESX.getsData().get("sharedhouses") 
        sharedHouses[""..house.houseId].house = house
        sharedHouses[""..house.houseId].bought_furniture = furniture
        instances[src]['furniture'] = furniture
        --print( json.encode(sharedHouses[house.houseId].house))
        --print( json.encode(sharedHouses[house.houseId].bought_furniture))
        ESX.getsData().set("sharedhouses", sharedHouses) 
        TriggerClientEvent('loaf_housing:reloadHouses', src)
    else
        instances[src]['furniture'] = furniture
        xPlayer.set("house",house)
        xPlayer.set("bought_furniture", furniture)
    end
   
    --MySQL.Async.execute("UPDATE users SET house=@house WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@house'] = json.encode(house)}) 
    --MySQL.Async.execute("UPDATE users SET bought_furniture=@bought_furniture WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@bought_furniture'] = json.encode(furniture)}) 
end)

ESX.RegisterServerCallback('loaf_housing:hasGuests', function(source, cb)
    local hasGuest = false
    for k, v in pairs(instances[source]['players']) do
        local playerlist = GetPlayers()
        for id, src in pairs(playerlist) do
            if v ~= source and v == tonumber(src) then
                hasGuest = true
                break
            end
        end
    end
    cb(hasGuest)
end)

ESX.RegisterServerCallback('loaf_housing:hostOnline', function(source, cb, host)
    local online = false
    if instances[host] then
        local playerlist = GetPlayers()
        for id, src in pairs(playerlist) do
            if host == tonumber(src) then
                online = true
                break
            end
        end
        if not online then
            Config.HouseSpawns[instances[host]['housespawn']]['taken'] = false
            instances[host] = {}
        end
    end
    cb(online)
end)

ESX.RegisterServerCallback('loaf_housing:getInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    cb({['items'] = xPlayer.getInventory(), ['weapons'] = xPlayer.getLoadout()})
end)

ESX.RegisterServerCallback('loaf_housing:getHouseInv', function(source, cb, owner)
	local xPlayer = ESX.GetPlayerFromId(source)
    local items, weapons = {}, {}
    
    if houses[owner] then
        if instances[houses[owner]] then
            local identifier = ESX.GetPlayerFromId(houses[owner])['identifier']

            TriggerEvent('esx_addoninventory:getInventory', 'housing', identifier, function(inventory)
                --print(json.encode(inventory))
                items = inventory.getItems()
            end)

            TriggerEvent('esx_datastore:getDataStore', 'housing', identifier, function(storage)
                weapons = storage.get('weapons') or {}
            end)

            cb({['items'] = items, ['weapons'] = weapons})
        end
    end
end)

RegisterServerEvent('loaf_housing:withdrawItem')
AddEventHandler('loaf_housing:withdrawItem', function(type, item, amount, owner)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if houses[owner] then
        if instances[houses[owner]] then
            local identifier = ESX.GetPlayerFromId(houses[owner])['identifier']
            if type == 'item' then

                TriggerEvent('esx_addoninventory:getInventory', 'housing', identifier, function(inventory)
                    
                    if inventory.getItem(item)['count'] >= amount then
                        if xPlayer.canCarryItem(item,amount) then
                            TriggerClientEvent('esx:showNotification', src, (Strings['You_Withdrew']):format(amount, inventory.getItem(item)['label']))
                            xPlayer.addInventoryItem(item, amount)
                            inventory.removeItem(item, amount)
                        else
                            TriggerClientEvent('esx:showNotification', src, "No puedes cargar con eso, revisa tu capacidad de inventario")
                        end
                    else
                        TriggerClientEvent('esx:showNotification', src, Strings['Not_Enough_House'])
                    end
                end)

            elseif type == 'weapon' then

                TriggerEvent('esx_datastore:getDataStore', 'housing', identifier, function(weapons)
                    if xPlayer.canCarryWeapon(item) then
                        local loadout = weapons.get('weapons') or {}

                        for i = 1, #loadout do
                            if loadout[i]['name'] == item then
                                print(json.encode(loadout))
                                
                                
                                xPlayer.addWeapon(item, amount)
                                for k,v in pairs(loadout[i].components) do
                                    xPlayer.addWeaponComponent(item, v)
                                end
                                table.remove(loadout, i)
                                weapons.set('weapons', loadout)
                                break
                            end
                        end
                    else
                        TriggerClientEvent('esx:showNotification', src, "No puedes cargar con eso, revisa tu capacidad de inventario")
                    end
                end)
            end
        end

    end
    
end)

RegisterServerEvent('loaf_housing:storeItem')
AddEventHandler('loaf_housing:storeItem', function(type, item, amount, owner)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

    if houses[owner] then
        if instances[houses[owner]] then
            local identifier = ESX.GetPlayerFromId(houses[owner])['identifier']
            if type == 'item' then

                if xPlayer.getInventoryItem(item)['count'] >= amount then
                    TriggerEvent('esx_addoninventory:getInventory', 'housing', identifier, function(inventory)
                        xPlayer.removeInventoryItem(item, amount)
                        inventory.addItem(item, amount)
                        TriggerClientEvent('esx:showNotification', src, (Strings['You_Stored']):format(amount, inventory.getItem(item)['label']))
                    end)
                else
                    TriggerClientEvent('esx:showNotification', src, Strings['Not_Enough'])
                end

            elseif type == 'weapon' then

                local loadout, hasweapon = xPlayer.getLoadout(), false
                for k, v in pairs(loadout) do
                    if v['name'] == item then
                        hasweapon = true
                        break
                    end
                end

                if hasweapon then
                    TriggerEvent('esx_datastore:getDataStore', 'housing', identifier, function(weapons)
                        local storage = weapons.get('weapons') or {}

                        local loadNum, weapon = xPlayer.getWeapon(item)
                        table.insert(storage, weapon)

                        weapons.set('weapons', storage)
                        xPlayer.removeWeapon(item)
                    end)
                else
                    TriggerClientEvent('esx:showNotification', src, Strings['No_Weapon'])
                end
            end
        end

	end
end)


ESX.RegisterServerCallback('esx_property:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason, xPlayer)
    if instances[playerId] then
        local coords = {x = Config.Houses[instances[playerId].id]['door'].x, y = Config.Houses[instances[playerId].id]['door'].y, z = Config.Houses[instances[playerId].id]['door'].z, heading = 0.0}
        xPlayer.setCoords(coords)
        instances[playerId] = nil
        --ESX.SavePlayer(xPlayer, function() end)
    end
end)

RegisterCommand("eliminarcasac", function(source,args)

    local bought_h = ESX.getsData().get("bought_houses")
    for k,v in pairs(bought_h) do
        if v == tonumber(args[1]) then
            bought_h[k] = nil
        end
    end
    ESX.getsData().set("bought_houses", bought_h)
end, true)

RegisterCommand("addcasac", function(source,args)

    local bought_h = ESX.getsData().get("bought_houses")
    local bought_hn = tonumber(args[1])
    if bought_hn then
        table.insert(bought_h,bought_hn)
    end
    ESX.getsData().set("bought_houses", bought_h)
end, true)

--Compartir casas
ESX.RegisterCommand("compartircasa", "user", function(xPlayer,args,showError) 
    --checkeamos que tenga una casa comprada
    if xPlayer.get("house") ~= nil and xPlayer.get("house").houseId > 0 then
        --print("player: "..args.playerId)
        --local xTarget = ESX.GetPlayerFromId(args.playerId)
        --Ahora la casa es compartida asi que los datos deben pasar a ser del servidor
        if args.playerId.get("house").houseId == 0  or args.playerId.get("house").houseId == nil then
            local house =  xPlayer.get("house") 
            if not house.shared then
                house.shared = true
                local sharedHouses

                --inicializamos las casas compartidas
                if ESX.getsData().get("sharedhouses") == nil then
                    sharedHouses = {}
                else
                    sharedHouses = ESX.getsData().get("sharedhouses") 
                end
                --terminamos de coger lo datos necesarios
                local sharedfurniture = {}

                if xPlayer.get("bought_furniture") ~= nil then
                    sharedfurniture = xPlayer.get("bought_furniture")
                end

                
                -- Guardamos todos los datos de la casa en el servidor
                sharedHouses[""..house.houseId] = {house = house, bought_furniture = sharedfurniture}

                --Guardamos en ambos player lo que habia en el primero, con el objetivo de checkear si es compartida y aprovecharlo como backup
                xPlayer.set("house",house)
                args.playerId.set("house",house)

                ESX.getsData().set("sharedhouses",sharedHouses)
                TriggerClientEvent('loaf_housing:reloadHouses', args.playerId.source)
                TriggerClientEvent('loaf_housing:reloadHouses', xPlayer.source)
            else
                xPlayer.showNotification("Ya estás compartiendo tu casa con alguien.")
            end
            else
            args.playerId.showNotification("No pueden compartirte la casa si ya tienes una.")
            xPlayer.showNotification("No puedes compartir tu casa con esa persona.")
        end
    else
        showError("No tienes una casa que dejar")
    end
end, false,
{help = 'Deja las llaves de tu casa a otra persona ¡Tendrá los mismos permisos que tú!', validate = true, arguments = {
{name = 'playerId', help = 'Id del jugador', type = 'player'}
}})
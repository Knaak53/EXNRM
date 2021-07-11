 ESX = nil
 local lastTargets = {}
 local canSearch = true

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports.extendedmode:getSharedObject()
        Citizen.Wait(50)
    end
end)

RegisterNetEvent('esx_trash:updateTrash')
AddEventHandler('esx_trash:updateTrash', function(target, items)
	print(target, json.encode(items))
    for i = 1, #lastTargets do
    	if lastTargets[i].target == target then
    		lastTargets[i].items = items
    	end
    end
end)

RegisterNetEvent('esx_trash:startJobGarbage')
AddEventHandler('esx_trash:startJobGarbage', function(target, items)
    canSearch = false
end)

RegisterNetEvent('esx_trash:endJobGarbage')
AddEventHandler('esx_trash:endJobGarbage', function(target, items)
    canSearch = true
end)


RegisterNetEvent('esx_trash:searchTrash')
AddEventHandler('esx_trash:searchTrash', function(target, hash)
	if canSearch then
		if isNewContainer(target) then
	    	local foundItems = getRandomItems(target)
	    	table.insert(lastTargets, 
	    		{
	    			target = target,
	    			items = foundItems
	    		}
			)
	    	if #lastTargets > 30 then
	    		table.remove(lastTargets, 1)
	    	end
	   else
			local containerItems = getContainerItems(target)
			if containerItems and containerItems.weapons and containerItems.items then
				if #containerItems.weapons > 0 then
					for i = 1, #containerItems.weapons do
						if containerItems.weapons[i].count > 0 then
							TriggerEvent('esx_generic_inv_ui:openTrash', target, containerItems)
							return
						end
					end
				end
				if #containerItems.items > 0 then
					for i = 1, #containerItems.items do
						if containerItems.items[i].count > 0 then
							TriggerEvent('esx_generic_inv_ui:openTrash', target, containerItems)
							return
						end
					end
				end
				ESX.ShowNotification("Ya has cogido todo lo que has encontrado en esa basura!")
			else
				ESX.ShowNotification("Ya has registrado esa basura...")
			end	
	    end
	else
		ESX.ShowNotification("No puedes buscar en la basura mientras realizas el servicio de basuras")
	end
    
end)

function getContainerItems(target)
	for i = 1, #lastTargets do
		if target == lastTargets[i].target then
			return lastTargets[i].items
		end
	end
end

function getRandomItems(target)
	math.randomseed(GetGameTimer())
	local foundSomething = math.random(1, 100) <= 42
	if foundSomething then
		local randomCount = math.random(1, 100)	
		local foundItemsCount
		if randomCount > 40 then
			foundItemsCount = 1
		elseif randomCount <= 40 and randomCount > 15 then
			foundItemsCount = 2
		elseif randomCount <= 15 and randomCount > 3 then
			foundItemsCount = 3
		else
			foundItemsCount = 4
		end
		local randomFoundItems = getRandomFoundItems(foundItemsCount)
		TriggerEvent('esx_generic_inv_ui:openTrash', target, randomFoundItems)
		return randomFoundItems
	else
		ESX.ShowNotification("~r~No has encontrado nada de valor en la basura...")
		return nil
	end
end

function getRandomFoundItems(foundItemsCount)
	local ret = {}
	ret.accounts = {}
	ret.items = {}
	ret.weapons = {}
	for i = 1, foundItemsCount do
		local isTrash = math.random(1, 100) <= 72
		if isTrash then	
			local randomTrash = math.random(1, #Config.trash)
			randomTrashItem = Config.trash[randomTrash]
			local randomCount = math.random(1, 100)	
			if randomCount > 25 then
				randomTrashItem.count = 1
			elseif randomCount <= 25 and randomCount > 5 then
				randomTrashItem.count = 2
			else
				randomTrashItem.count = 3
			end
			local alreadyHaveItem = false
			for i = 1, #ret.items do
				if randomTrashItem.name == ret.items[i].name then
					alreadyHaveItem = true
				end
			end
			if not alreadyHaveItem then
				table.insert(ret.items, randomTrashItem)
			end	
		else
			local prizeItem = getPrizeItem()
			if prizeItem.type == "item" then
				if not prizeItem.count then
					prizeItem.count = 1
				end
				local alreadyHaveItem = false
				for i = 1, #ret.items do
					if prizeItem.name == ret.items[i].name then
						alreadyHaveItem = true
					end
				end
				if not alreadyHaveItem then
					table.insert(ret.items, prizeItem)
				end	
			else
				local alreadyHaveItem = false
				for i = 1, #ret.weapons do
					if prizeItem.name == ret.weapons[i].name then
						alreadyHaveItem = true
					end
				end
				if not alreadyHaveItem then
					prizeItem.ammo = 30
					table.insert(ret.weapons, prizeItem)
				end
			end	
		end
	end
	return ret
end

function getPrizeItem()
	math.randomseed(GetGameTimer())
	local randomItemGroups = math.random(1, 100)
	if randomItemGroups > 30 then
		math.randomseed(GetGameTimer())
		return Config.prizeItems[1][math.random(1, #Config.prizeItems[1])]
	else
		if randomItemGroups > 20 then	
			math.randomseed(GetGameTimer())
			return Config.prizeItems[2][math.random(1, #Config.prizeItems[2])]
		end
		if randomItemGroups > 10 and randomItemGroups <= 20 then	
			math.randomseed(GetGameTimer())
			return Config.prizeItems[3][math.random(1, #Config.prizeItems[3])]
		elseif randomItemGroups > 3 and randomItemGroups <= 10 then	
			math.randomseed(GetGameTimer())
			return Config.prizeItems[4][math.random(1, #Config.prizeItems[4])]
		else	
			math.randomseed(GetGameTimer())
			return Config.prizeItems[5][math.random(1, #Config.prizeItems[5])]
		end
	end
end

function isNewContainer(target)
	for i = 1, #lastTargets do
		if target == lastTargets[i].target then
			return false
		end
	end
	return true
end
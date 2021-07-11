ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.EnableESXService then
	TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'ayuntamiento', 'police', 'police', {type = 'public'})


RegisterNetEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.getJob().name ~= 'police' then
		print(('esx_policejob: %s attempted to confiscate!'):format(xPlayer.identifier))
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				sourceXPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				targetXPlayer.showNotification(_U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end

	elseif itemType == 'item_money' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

		sourceXPlayer.showNotification(_U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		targetXPlayer.showNotification(_U('got_confiscated_account', amount, itemName, sourceXPlayer.name))


	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		sourceXPlayer.showNotification(_U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		targetXPlayer.showNotification(_U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		sourceXPlayer.showNotification(_U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		targetXPlayer.showNotification(_U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if xPlayer.getJob().name == 'police' then
		if xTarget.get("handcuffed") == nil then
			xTarget.set("handcuffed", true)
		else
			local handcuffed = xTarget.get("handcuffed")
			handcuffed = not handcuffed
			xTarget.set("handcuffed", handcuffed)
		end
		TriggerClientEvent('esx_policejob:handcuff', target)
	else
		print(('esx_policejob: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getJob().name == 'police' then
		TriggerClientEvent('esx_policejob:drag', target, source)
	else
		print(('esx_policejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getJob().name == 'police' then
		TriggerClientEvent('esx_policejob:putInVehicle', target)
	else
		print(('esx_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getJob().name == 'police' then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
	else
		print(('esx_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, inventoryItem.label))
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.label))
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if notify then
		xPlayer.showNotification(_U('being_searched'))
	end

	if xPlayer then
		local data = {
			--Avililla a ver como te digo esto me da sida con cancer
			name = xPlayer.get('identity').real.name .. " " .. xPlayer.get('identity').real.firstname .. " " .. xPlayer.get('identity').real.secondname,
			--craack figura mastodonde voy muy fumado pa esta mierda
			job = xPlayer.getJob().label,
			grade = xPlayer.getJob().grade_label,
			money = xPlayer.getMoney(),
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		if Config.EnableESXIdentity then
			data.dob = xPlayer.get('identity').real.dateofbirth
			data.height = xPlayer.get('identity').real.height
			data.validated = xPlayer.get('identity').validated
			if xPlayer.get('identity').sex == 'm' then data.sex = 'male' else data.sex = 'female' end
		end

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end

			if Config.EnableLicenses then
				TriggerEvent('esx_license:getLicenses', target, function(licenses)
					data.licenses = licenses
					cb(data)
				end)
			else
				cb(data)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	cb(fine_types[category])
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	local retrivedInfo = { plate = plate}
	
	ESX.exposedDB.getDocument(GetHashKey(plate), function(result) 
		if result then
			local xPlayer = ESX.GetPlayerFromIdentifier(result.owner)
	
			-- is the owner online?
			if xPlayer then
				retrivedInfo.owner = ('%s %s %s'):format(xPlayer.get("identity").real.name, xPlayer.get("identity").real.firstname,xPlayer.get("identity").real.secondname)
				cb(retrivedInfo)
			elseif Config.EnableESXIdentity then
				ESX.exposedDB.getDocument(GetHashKey(result.owner), function(owner) 
					if owner then
						retrivedInfo.owner = ('%s %s %s'):format(owner.variables.identity.real.name, owner.variables.identity.real.firstname, owner.variables.identity.real.secondname)
						cb(retrivedInfo)
					else
						retrivedInfo.owner = result.owner
						cb(retrivedInfo)
					end
				end)
			else
				cb(retrivedInfo)
			end
		else
			cb(retrivedInfo)
		end
	end)
	-- consulta a couchDB o creación de caché de vehiculos?
	--xPlayer.ShowNotification("")
	--MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
	--	['@plate'] = plate
	--}, function(result)
	--	local retrivedInfo = {plate = plate}
--
	--	if result[1] then
	--		local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)
--
	--		-- is the owner online?
	--		if xPlayer then
	--			retrivedInfo.owner = xPlayer.getName()
	--			cb(retrivedInfo)
	--		elseif Config.EnableESXIdentity then
	--			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
	--				['@identifier'] = result[1].owner
	--			}, function(result2)
	--				if result2[1] then
	--					retrivedInfo.owner = ('%s %s'):format(result2[1].firstname, result2[1].lastname)
	--					cb(retrivedInfo)
	--				else
	--					cb(retrivedInfo)
	--				end
	--			end)
	--		else
	--			cb(retrivedInfo)
	--		end
	--	else
	--		cb(retrivedInfo)
	--	end
	--end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeaponsType', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		print(json.encode(weapons))
		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb, weaponName)
	TriggerEvent('esx_datastore:getSharedDataStore', 'police', function(store)
		local weapons = store.get('weapons')

		if weapons[weaponName] == nil then
			weapons = {}
		end

		print(json.encode(weapons))
		cb(weapons[weaponName], weaponName)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local loadoutNum, weapon
	if removeWeapon and xPlayer.hasWeapon(weaponName) then
		print("hasweapon")
		loadoutNum, weapon = xPlayer.getWeapon(weaponName)
	end
	if weapon then
		TriggerEvent('esx_datastore:getSharedDataStore', 'police', function(store)
			local weapons = store.get('weapons') or {}

			if weapons[weaponName] == nil then
				weapons[weaponName] = {}
				table.insert(weapons[weaponName],weapon)
				xPlayer.removeWeapon(weaponName)
			else
				table.insert(weapons[weaponName],weapon)
				xPlayer.removeWeapon(weaponName)
			end		

			store.set('weapons', weapons)
			cb()
		end)
	end
end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName, pos)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer.hasWeapon(weaponName) then

		TriggerEvent('esx_datastore:getSharedDataStore', 'police', function(store)
			local weapons = store.get('weapons') or {}

			local weapon
			if weapons[weaponName][pos] then
				weapon = weapons[weaponName][pos]
				
				xPlayer.addWeapon(weaponName, weapon.ammo)
				for k,v in pairs(weapon.components) do
					xPlayer.addWeaponComponent(weaponName,v)
				end
				table.remove(weapons[weaponName],pos)
			end

			store.set('weapons', weapons)
			cb()
		end)
	end
end)

ESX.RegisterServerCallback('esx_policejob:buyWeapon', function(source, cb, weaponName, type, componentNum)
	local xPlayer = ESX.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon = Config.AuthorizedWeapons[xPlayer.getJob().grade_name]

	for k,v in pairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('esx_policejob: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	else
		-- Weapon
		TriggerEvent('esx_addonaccount:getSharedAccount', 'ayuntamiento', function(account)
			if type == 1 then
				
					if account.getMoney() >= selectedWeapon.price then
						account.removeMoney(selectedWeapon.price)
						xPlayer.addWeapon(weaponName, 100)

						cb(true)
					else
						cb(false)
					end

			-- Weapon Component
			elseif type == 2 then
				local price = selectedWeapon.components[componentNum]
				local weaponNum, weapon = ESX.GetWeapon(weaponName)
				local component = weapon.components[componentNum]

				if component then
					if account.getMoney() >= price then
						account.removeMoney(price)
						xPlayer.addWeaponComponent(weaponName, component.name)

						cb(true)
					else
						cb(false)
					end
				else
					print(('esx_policejob: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
					cb(false)
				end
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_policejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayerESX.ShowNotification("El vehiculo debe ser comprado en el concesionario")
	--local price = getPriceFromHash(vehicleProps.model, xPlayer.getJob().grade_name, type)
--
	---- vehicle model not found
	--if price == 0 then
	--	print(('esx_policejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
	--	cb(false)
	--else
	--	if xPlayer.getMoney() >= price then
	--		xPlayer.removeMoney(price)
--
	--		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
	--			['@owner'] = xPlayer.identifier,
	--			['@vehicle'] = json.encode(vehicleProps),
	--			['@plate'] = vehicleProps.plate,
	--			['@type'] = type,
	--			['@job'] = xPlayer.getJob().name,
	--			['@stored'] = true
	--		}, function (rowsChanged)
	--			cb(true)
	--		end)
	--	else
	--		cb(false)
	--	end
	--end
end)

ESX.RegisterServerCallback('esx_policejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	--local foundPlate, foundNum
--
	--for k,v in pairs(nearbyVehicles) do
	--	local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
	--		['@owner'] = xPlayer.identifier,
	--		['@plate'] = v.plate,
	--		['@job'] = xPlayer.getJob().name
	--	})
--
	--	if result[1] then
	--		foundPlate, foundNum = result[1].plate, k
	--		break
	--	end
	--end
--
	--if not foundPlate then
	--	cb(false)
	--else
	--	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
	--		['@owner'] = xPlayer.identifier,
	--		['@plate'] = foundPlate,
	--		['@job'] = xPlayer.getJob().name
	--	}, function (rowsChanged)
	--		if rowsChanged == 0 then
	--			print(('esx_policejob: %s has exploited the garage!'):format(xPlayer.identifier))
	--			cb(false)
	--		else
	--			cb(true, foundNum)
	--		end
	--	end)
	--end
	xPlayerESX.ShowNotification("Garage en desarrollo")
end)

function getPriceFromHash(vehicleHash, jobGrade, type)
	local vehicles = Config.AuthorizedVehicles[type][jobGrade]

	for k,v in pairs(vehicles) do
		if GetHashKey(v.model) == vehicleHash then
			return v.price
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'police', function(inventory)
		print("test")
		if inventory.getItems() then
			print("test1")
			cb(inventory.getItems())
		else 
			print("test2")
			cb({})
		end
		
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.getInventory()

	cb({items = items})
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local playerId = source

	-- Did the player ever join?
	if playerId then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		-- Is it worth telling all clients to refresh?
		if xPlayer and xPlayer.getJob().name == 'police' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_policejob:updateBlip', -1)
		end
	end
end)

RegisterNetEvent('esx_policejob:spawned')
AddEventHandler('esx_policejob:spawned', function()
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and xPlayer.getJob().name == 'police' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

RegisterNetEvent('esx_policejob:forceBlip')
AddEventHandler('esx_policejob:forceBlip', function()
	TriggerClientEvent('esx_policejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)


exports('getFineTypes', function()
	return fine_types
end)

ESX.RegisterServerCallback("esx_policejob:retrieveJobVehicles", function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicles = xPlayer.get("vehicles")

    if vehicles then
        cb(vehicles)
    else 
        cb({})
    end
end)


RegisterNetEvent('esx_policejob:getClip')
AddEventHandler('esx_policejob:getClip', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('pistol_clip',1)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	local xPlayer = xPlayer


	if xPlayer.getJob().name == "police" then
		ExecuteCommand("add_ace "..xPlayer.getIdentifier().." inventory.openinventory allow")
	end
end)

AddEventHandler('esx:setJob', function(source, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "police" then
		--print("seteando permsos ".. xPlayer.getIdentifier())
		ExecuteCommand('add_ace identifier.'..xPlayer.getIdentifier()..' "inventory.openinventory" allow')
		--print("add_ace identifier."..xPlayer.getIdentifier().." inventory.openinventory allow")
	end
end)


ESX.RegisterServerCallback('mostrarfoto', function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.get("identity").photo)
end)

RegisterServerEvent('esx_policejob:setIdentityPhoto')
AddEventHandler('esx_policejob:setIdentityPhoto',function(target,data)
	xPlayer = ESX.GetPlayerFromId(target)
	local identity = xPlayer.get("identity")
	identity.photo = data
	identity.validated = true
	xPlayer.set('identity',identity)
end)


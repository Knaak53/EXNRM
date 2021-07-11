ESX = nil
ExM = nil
local cardealers = 0
local categories, vehicles , vehiclesjob= {}, {}, {}
local cardealer_vehicles = {}
local rented_vehicles = {}
local vehicle_sold = {}
--for k, v in pairs(Config.Zones) do
--	cardealer_vehicles[k] = {}
--end

ESX = exports.extendedmode:getSharedObject()

ExM = exports.extendedmode:getExtendedModeObject()


RegisterServerEvent('plusCardealer')
AddEventHandler('plusCardealer', function()
	cardealers = cardealers + 1
end)

RegisterServerEvent('lessCardealer')
AddEventHandler('lessCardealer', function()
	cardealers = cardealers - 1
end)

ESX.RegisterServerCallback('getCardealers', function(source, cb)
	cb(cardealers)
end)

TriggerEvent('esx_society:registerSociety', "cardealer", _U('car_dealer'), "cardealer", "cardealer", "cardealer", {type = 'private'})
TriggerEvent('esx_phone:registerNumber', "cardealer", _U('dealer_customers'), false, false)

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('[esx_vehicleshop] [^3WARNING^7] Plate character count reached, %s/8 characters!'):format(char))
	end
end)

-- para añadir un vehiculo al cardealer ya haya uno con anterioridad o no
function addCardealerVehicle(vehicle,price, class)
	--print(cardealer_vehicles[vehicle])
	--print(vehicle)
	--print(price)
	if cardealer_vehicles[vehicle] == nil or cardealer_vehicles[vehicle] == {} then
		cardealer_vehicles[vehicle] = {}
		cardealer_vehicles[vehicle]["count"] = 1
		cardealer_vehicles[vehicle]["price"] = price
		cardealer_vehicles[vehicle]["vehicle"] = vehicle
		cardealer_vehicles[vehicle]["class"] = class
	else
		cardealer_vehicles[vehicle]["count"] = cardealer_vehicles[vehicle]["count"] + 1
	end
	--print(json.encode(cardealer_vehicles[vehicle]))
end

-- para eliminar un vehiculo al cardealer si solo queda 1 eliminamos de la estructura
function deleteCardealerVehicle(job,vehicle)
	if cardealer_vehicles[vehicle].count == 1 then
		cardealer_vehicles[vehicle] = nil
	else
		cardealer_vehicles[vehicle].count = cardealer_vehicles[vehicle].count - 1
	end
end

function RemoveOwnedVehicle(plate)
	--MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
	--	['@plate'] = plate
	--})
end

AddEventHandler("onResourceStart", function(resource)
	if GetCurrentResourceName() == resource then
		Citizen.CreateThread(function()
			Wait(50)
			--db, row, value, callback
			ESX.exposedDB.getDocument(GetHashKey("vehicles"),function(result)
				if result then
					local count = 0
					for k,v in pairs(result.vehicles_categories.dealer) do
						table.insert(categories, {
							name = v.name,
							label = v.label
						})
						for k2,v2 in pairs(v.vehicles) do
							vehicles[k2] = v2
							vehicles[k2].categoryLabel = v.label
							vehicles[k2].category = v.name
						end
					end
					for k,v in pairs(result.vehicles_categories.jobs) do
						table.insert(categories, {
							name = v.name,
							label = v.label
						})
						for k2,v2 in pairs(v.vehicles) do
							vehiclesjob[k2] = v2
							vehiclesjob[k2].categoryLabel = v.label
							vehiclesjob[k2].category = v.name
						end
					end
					TriggerClientEvent('esx_vehicleshop:sendCategories', -1, categories)
					TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, vehicles)
				else
					ESX.exposedDB.createDocumentWithId(GetHashKey("vehicles") ,
						{
							vehicles_categories = categoriesDump
						},
						function(result, err)
							if not result then
								print("ERROR: "..err)
							end
							categoriesDump = nil
						end
					)
				end
			end)
			--ESX.exposedDB.getDocument(GetHashKey("cardealer_vehicles"),function(result)
			--	if result then
			--		cardealer_vehicles = result
			--	else
--
			--	end
--
			--end)
		end)
	end
end)
--[[MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, function(_categories)
		categories = _categories

		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(_vehicles)
			vehicles = _vehicles

			for k,v in pairs(vehicles) do
				for k2,v2 in pairs(categories) do
					if v2.name == v.category then
						vehicles[k].categoryLabel = v2.label
						break
					end
				end
			end

			-- send information after db has loaded, making sure everyone gets vehicle information
			TriggerClientEvent('esx_vehicleshop:sendCategories', -1, categories)
			TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, vehicles)
		end)
	end)
end)--]]

function getVehicleLabelFromModel(model)
	for k,v in pairs(vehicles) do
		if v.model == model then
			return v.name
		end
	end

	return
end

RegisterNetEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(playerId, vehicleProps, model, label,isCompany, vehId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget
	if playerId ~= nil then
		xTarget = ESX.GetPlayerFromId(playerId)
	end

	local vehOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(vehId))

	TriggerClientEvent("esx_vehicleshop:onsetVehicleOwnedPlayerId", vehOwner, vehId, vehicleProps.plate)


		--[[MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = plate,
			['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
		}, function(rowsChanged)
			xPlayer.showNotification(_U('vehicle_belongs', plate))
			cb(true)
		end)--]]

	if isJobValid(xPlayer.getJob().name) and xTarget then
		local finalOwner
		if isCompany then
			finalOwner = xTarget.getJob().name
		else
			finalOwner = xTarget.getIdentifier()
		end
		local data = 
		{
			owner = finalOwner,
			plate = vehicleProps.plate,
			model = model,
			props = vehicleProps
		}
		local targetVehicles = xTarget.get("vehicles")
		if targetVehicles == nil then
			targetVehicles = {}
		end
		targetVehicles[vehicleProps.plate] = { plate = vehicleProps.plate , model = model }
		xTarget.set("vehicles", targetVehicles)
		ESX.exposedDB.updateOrCreateDocument( GetHashKey(vehicleProps.plate),
			data
		,function(result)
			if result then
				deleteCardealerVehicle(xPlayer.getJob().name, model)
				if isCompany then
					xPlayer.showNotification(_U('vehicle_set_company_owned', vehicleProps.plate, xTarget.getJob().label))
					xTarget.showNotification(_U('vehicle_company_belongs', vehicleProps.plate))
					TriggerEvent("garage:addKeys", vehicleProps.plate, xTarget.source)
				else
					xPlayer.showNotification(_U('vehicle_set_owned', vehicleProps.plate, xTarget.getName()))
					xTarget.showNotification(_U('vehicle_belongs', vehicleProps.plate))
					TriggerEvent("garage:addKeys", vehicleProps.plate, xTarget.source)
				end
				
				local dateNow = os.date('%Y-%m-%d %H:%M')
				local anontable = {}
				anontable[vehicleProps.plate] =
				{
					['client'] = xTarget.getName(),
					['model'] = label,
					['plate'] = vehicleProps.plate,
					['soldby'] = xPlayer.getName(),
					['date'] = dateNow
				}
				if next(vehicle_sold) == nil then
					ESX.exposedDB.getDocumentData(GetHashKey("vehicle_sold".."_"..xPlayer.getJob().name),function(result)
						if result then
							vehicle_sold = result
							vehicle_sold[vehicleProps.plate] = anontable[vehicleProps.plate]
						end
					end
					)
				else
					vehicle_sold[vehicleProps.plate] = anontable[vehicleProps.plate]
				end
				ESX.exposedDB.updateOrCreateDocument( GetHashKey("vehicle_sold".."_"..xPlayer.getJob().name),
					anontable
					,function(result)
						if not result then
							print("ERROR WITH VEHICLE SOLD LOG")
						end
					end
				)
			else
				xPlayer.showNotification('Error en la compra del vehiculo: '.. vehicleProps.plate)
			end
		end)
	elseif xTarget == nil then
		xTarget = xPlayer
		local finalOwner
		finalOwner = xTarget.getIdentifier()

		local data = 
		{
			owner = finalOwner,
			plate = vehicleProps.plate,
			model = model,
			props = vehicleProps
		}
		local targetVehicles = xTarget.get("vehicles")
		if targetVehicles == nil then
			targetVehicles = {}
		end
		targetVehicles[vehicleProps.plate] = { plate = vehicleProps.plate , model = model }
		xTarget.set("vehicles", targetVehicles)
		ESX.exposedDB.updateOrCreateDocument( GetHashKey(vehicleProps.plate),
			data
		,function(result)
			if result then
				--deleteCardealerVehicle(xPlayer.getJob().name, model)
				--xPlayer.showNotification(_U('vehicle_set_owned', vehicleProps.plate, xTarget.getName()))
				xTarget.showNotification(_U('vehicle_belongs', vehicleProps.plate))
				TriggerEvent("garage:addKeys", vehicleProps.plate, xTarget.source)
				
				local dateNow = os.date('%Y-%m-%d %H:%M')
				local anontable = {}
				anontable[vehicleProps.plate] =
				{
					['client'] = xTarget.getName(),
					['model'] = label,
					['plate'] = vehicleProps.plate,
					['soldby'] = xPlayer.getName(),
					['date'] = dateNow
				}
				if next(vehicle_sold) == nil then
					ESX.exposedDB.getDocumentData(GetHashKey("vehicle_sold".."_"..xPlayer.getJob().name),function(result)
						if result then
							vehicle_sold = result
							vehicle_sold[vehicleProps.plate] = anontable[vehicleProps.plate]
						end
					end
					)
				else
					vehicle_sold[vehicleProps.plate] = anontable[vehicleProps.plate]
				end
				ESX.exposedDB.updateOrCreateDocument( GetHashKey("vehicle_sold".."_"..xPlayer.getJob().name),
					anontable
					,function(result)
						if not result then
							print("ERROR WITH VEHICLE SOLD LOG")
						end
					end
				)
			else
				xPlayer.showNotification('Error en la compra del vehiculo: '.. vehicleProps.plate)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getSoldVehicles', function(source, cb)
	if next(vehicle_sold) == nil then
		local xPlayer = ESX.GetPlayerFromId(source)
		print("nil?")
		ESX.exposedDB.getDocumentData(GetHashKey("vehicle_sold".."_"..xPlayer.getJob().name),function(result)
			if result then
				vehicle_sold = result
				--print(json.encode(vehicle_sold))
				cb(vehicle_sold)
			end
		end
		)
	else
		cb(vehicle_sold)
	end
	--print(json.encode(vehicle_sold))

end)

RegisterCommand("blabla", function() end,true)
RegisterNetEvent('esx_vehicleshop:rentVehicle')
AddEventHandler('esx_vehicleshop:rentVehicle', function(vehicle, plate, rentPrice, playerId)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(playerId)
	print("ID 1: "..source.."ID 2: "..playerId)
	if isJobValid(xPlayer.getJob().name) and xTarget then
		if cardealer_vehicles[xPlayer.getJob().name][vehicle] then
			deleteCardealerVehicle(xPlayer.getJob().name, vehicle)
			local anontable = {}
			anontable[plate] =
			{
				vehicle = vehicle,
				plate = plate,
				player_name = xTarget.get("firstName") .. " " .. xTarget.get("lastName"),
				base_price = price,
				rent_price = rentPrice,
				owner = xTarget.getIdentifier()
			}
			rented_vehicles[xPlayer.getJob().name][plate] = anontable[plate]
			print("rented ok")
		end
	end
end)

RegisterNetEvent('esx_vehicleshop:getStockItem')
AddEventHandler('esx_vehicleshop:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', xPlayer.getJob().name, function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, item.label))
			else
				xPlayer.showNotification(_U('player_cannot_hold'))
			end
		else
			xPlayer.showNotification(_U('not_enough_in_society'))
		end
	end)
end)

RegisterNetEvent('esx_vehicleshop:putStockItems')
AddEventHandler('esx_vehicleshop:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', xPlayer.getJob().name, function(inventory)
		local item = xPlayer.getInventoryItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, item.label))
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
	cb(categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
	cb(vehicles)
end)

RegisterNetEvent('saveVehicleProperties')
AddEventHandler('saveVehicleProperties', function(vehNet,vehicle)	
	ESX.exposedDB.updateOrCreateDocument( GetHashKey(vehicle.plate),
		{props = vehicle}
		,function(result)
			if result then
				print("props guardados correctamente")
			else
				print("F props")
			end
		end
	)	
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function(source, cb, model, plate, pos, vehicleprops, fixedprice, target)
	local dealer
	local xDealer
	if target then
		dealer = source
		xDealer = ESX.GetPlayerFromId(dealer)
		source = target
	end

	local xPlayer = ESX.GetPlayerFromId(source)
	local modelPrice

	if (not fixedprice) or fixedprice == nil then
		for k,v in pairs(vehicles) do
			if model == v.model then
				modelPrice = v.price
				break
			end
		end
	else
		modelPrice = fixedprice
	end

	if modelPrice and xPlayer.getMoney() >= modelPrice then
		xPlayer.removeMoney(modelPrice)
		if target then
			deleteCardealerVehicle("cardealer", model)
			local dateNow = os.date('%Y-%m-%d %H:%M')
			local anontable = {}
			anontable[vehicleprops.plate] =
				{
					['client'] = xPlayer.getName(),
					['model'] = getVehicleLabelFromModel(model),
					['plate'] = vehicleprops.plate,
					['soldby'] = xDealer.getName(),
					['date'] = dateNow
				}
				if next(vehicle_sold) == nil then
					ESX.exposedDB.getDocumentData(GetHashKey("vehicle_sold".."_"..xDealer.getJob().name),function(result)
						if result then
							vehicle_sold = result
							vehicle_sold[vehicleprops.plate] = anontable[vehicleprops.plate]
						end
					end
					)
				else
					vehicle_sold[vehicleprops.plate] = anontable[vehicleprops.plate]
				end
				ESX.exposedDB.updateOrCreateDocument( GetHashKey("vehicle_sold".."_"..xDealer.getJob().name),
					anontable
					,function(result)
						if not result then
							print("ERROR WITH VEHICLE SOLD LOG")
						end
					end
				)
		end
		local targetVehicles = xPlayer.get("vehicles")
		if targetVehicles == nil then
			targetVehicles = {}
		end
		targetVehicles[plate] = { plate = plate , model = model }
		xPlayer.set("vehicles", targetVehicles)

		ESX.exposedDB.createDocumentWithId( GetHashKey(plate),
		{
			owner = xPlayer.getIdentifier(),
			plate = plate,
			model = model,
			props = vehicleprops
		},function(result)
			if result then
				Citizen.CreateThread(function()
					xPlayer.showNotification(_U('vehicle_belongs', plate))
					--TriggerEvent("esx:spawnserversidevehicle", model, , plate)
					local veh = exports.extendedmode:CreateExtendedCar(model, vehicleprops.class, plate, source, xPlayer.getIdentifier(),vector3(pos.x,pos.y,pos.z), vehicleprops)
					ESX.AddVehicle(veh)
					local sVehicles = nil
					if ESX.getsData().get("vehicles") == nil then
						sVehicles = {}
					else
						sVehicles = ESX.getsData().get("vehicles")
					end
					sVehicles[plate] = veh.getSaveableData()
					ESX.getsData().set("vehicles", sVehicles)
					TriggerEvent("garage:addKeys", plate, source)
					cb(veh.netId)
				end)
			else
				xPlayer.showNotification('Error en la compra del vehiculo: '.. plate)
			end
		end)


		--[[MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = plate,
			['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
		}, function(rowsChanged)
			xPlayer.showNotification(_U('vehicle_belongs', plate))
			cb(true)
		end)--]]
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicleCompany', function(source, cb, model, plate, pos, vehicleprops, company, fixedprice)
	local xPlayer = ESX.GetPlayerFromId(source)
	local modelPrice

	if fixedprice == nil then
		for k,v in pairs(vehiclesjob) do
			if model == v.model then
				modelPrice = v.price
				break
			end
		end
	else
		modelPrice = fixedprice
	end
	local companyAccount = false
	
	exports.esx_society:getSocietyAccount(company, function(account) 
		companyAccount = account
	end)

	print("llego")
	if companyAccount then
		print(modelPrice, companyAccount.getMoney())
		if modelPrice and companyAccount.getMoney() >= modelPrice then
			companyAccount.removeMoney(modelPrice)

			--local targetVehicles = xPlayer.get("vehicles")
			--if targetVehicles == nil then
			--	targetVehicles = {}
			--end
			--targetVehicles[plate] = { plate = plate , model = model }
			--xPlayer.set("vehicles", targetVehicles)

			ESX.exposedDB.createDocumentWithId( GetHashKey(plate),
			{
				owner = company,
				plate = plate,
				model = model,
				props = vehicleprops
			},function(result)
				if result then
					Citizen.CreateThread(function()
						xPlayer.showNotification(_U('vehicle_company_belongs', plate))
						--TriggerEvent("esx:spawnserversidevehicle", model, , plate)
						local veh = exports.extendedmode:CreateExtendedCar(model, vehicleprops.class, plate, source, company,vector3(pos.x,pos.y,pos.z), vehicleprops, false, company)
						ESX.AddVehicle(veh)
						local sVehicles = nil
						if ESX.getsData().get("vehicles") == nil then
							sVehicles = {}
						else
							sVehicles = ESX.getsData().get("vehicles")
						end
						sVehicles[plate] = veh.getSaveableData()
						ESX.getsData().set("vehicles", sVehicles)
						TriggerEvent("garage:addKeys", plate, source)
						TriggerEvent("esx_vehicleshop:setVehicleOwnedPlayerIdToGarage", plate, company)
						cb(veh.netId)
					end)
				else
					xPlayer.showNotification('Error en la compra del vehiculo: '.. plate)
				end
			end)


			--[[MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
				['@owner']   = xPlayer.identifier,
				['@plate']   = plate,
				['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
			}, function(rowsChanged)
				xPlayer.showNotification(_U('vehicle_belongs', plate))
				cb(true)
			end)--]]
		else
			cb(false)
		end
	end
end)

local firstTime = true
ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function(source, cb)
	--MySQL.Async.fetchAll('SELECT price, vehicle FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function(result)
		--print("numerode coches".. next(cardealer_vehicles))
		local xPlayer = ESX.GetPlayerFromId(source)
		ESX.exposedDB.getDocument(GetHashKey("cardealer_vehicles"),function(result)
			if result then
				for k,v in pairs(result.cardealer_vehicles) do
					cardealer_vehicles[k] = v
				end
			else
				print("^1Error in cardealers vehiclesshop resource, couldnt get vehicle buyed by cardealers^7")
			end
			--print(json.encode(cardealer_vehicles))
			cb(cardealer_vehicles)
		end)
	--end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(source, cb, model)
	local xPlayer = ESX.GetPlayerFromId(source)
	if isJobValid(xPlayer.getJob().name) then
		local modelPrice
		local carClass

		for k,v in pairs(vehicles) do
			if model == v.model then
				modelPrice = v.price
				carClass = v.class
				break
			end
		end

		print("model price gucci! "..modelPrice)
		if modelPrice then
			print(xPlayer.getJob().name)
			TriggerEvent('esx_addonaccount:getSharedAccount', xPlayer.getJob().name, function(account)
				if account.getMoney() >= modelPrice then
					account.removeMoney(modelPrice)
					addCardealerVehicle(model, modelPrice, carClass)
					cb(true)
					--[[MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
						['@vehicle'] = model,
						['@price'] = modelPrice
					}, function(rowsChanged)
						cb(true)
					end)--]]

				else
					cb(false)
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_vehicleshop:returnProvider')
AddEventHandler('esx_vehicleshop:returnProvider', function(vehicleModel)
	local xPlayer = ESX.GetPlayerFromId(source)

	if isJobValid(xPlayer.getJob().name) then
		local price =  cardealer_vehicles[xPlayer.getJob().name][vehicleModel].price
		deleteCardealerVehicle(xPlayer.getJob().name, vehicleModel)
		TriggerEvent('esx_addonaccount:getSharedAccount', xPlayer.getJob().name, function(account)
			local price = ESX.Math.Round(price * 0.75)
			local vehicleLabel = getVehicleLabelFromModel(vehicleModel)
			account.addMoney(price)
			xPlayer.showNotification(_U('vehicle_sold_for', vehicleLabel, ESX.Math.GroupDigits(price)))
		end)
	end
	--	MySQL.Async.fetchAll('SELECT id, price FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
	--		['@vehicle'] = vehicleModel
	--	}, function(result)
	--		if result[1] then
	--			local id = result[1].id
--
--	--			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
	--				['@id'] = id
	--			}, function(rowsChanged)
	--				if rowsChanged == 1 then
	--					TriggerEvent('esx_addonaccount:getSharedAccount', 'cardealer', function(account)
	--						local price = ESX.Math.Round(result[1].price * 0.75)
	--						local vehicleLabel = getVehicleLabelFromModel(vehicleModel)
--
--	--						account.addMoney(price)
	--						xPlayer.showNotification(_U('vehicle_sold_for', vehicleLabel, ESX.Math.GroupDigits(price)))
	--					end)
	--				end
	--			end)
	--		else
	--			print(('[esx_vehicleshop] [^3WARNING^7] %s attempted selling an invalid vehicle!'):format(xPlayer.identifier))
	--		end
	--	end)
	--end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getRentedVehicles', function(source, cb)
	if next(rented_vehicles) == nil then
			ESX.exposedDB.getDocument(GetHashKey("rented_vehicles".."_"..xPlayer.getJob().name),function(result)
				if result then
					for k,v in pairs(result) do
						if k ~= "_id" and k ~= "_rev" then
							rented_vehicles[k] = v
						end
					end
					
				else
					print("^1Error in cardealers vehiclesshop resource, couldnt get vehicle buyed by cardealers^7")
				end
				--print(json.encode(rented_vehicles))
				cb(rented_vehicles)

			end)
		else
		cb(rented_vehicles)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:giveBackVehicle', function(source, cb, plate)
	addCardealerVehicle(rented_vehicles[plate].vehicle, rented_vehicles[plate].base_price)
	rented_vehicles[plate] = nil
	--MySQL.Async.fetchAll('SELECT base_price, vehicle FROM rented_vehicles WHERE plate = @plate', {
	--	['@plate'] = plate
	--}, function(result)
	--	if result[1] then
	--		local vehicle = result[1].vehicle
	--		local basePrice = result[1].base_price
--
	--		MySQL.Async.execute('DELETE FROM rented_vehicles WHERE plate = @plate', {
	--			['@plate'] = plate
	--		}, function(rowsChanged)
	--			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
	--				['@vehicle'] = vehicle,
	--				['@price']   = basePrice
	--			})
--
	--			RemoveOwnedVehicle(plate)
	--			cb(true)
	--		end)
	--	else
	--		cb(false)
	--	end
	--end)
end)


-- Esto es extraño, revisar si es una funcionalidad necesaria o no
ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function(source, cb, plate, model)
	local xPlayer, resellPrice = ESX.GetPlayerFromId(source)

	if isJobValid(xPlayer.getJob().name) then
		-- calculate the resell price
		for i=1, #vehicles, 1 do
			if GetHashKey(vehicles[i].model) == model then
				resellPrice = ESX.Math.Round(vehicles[i].price / 100 * Config.ResellPercentage)
				break
			end
		end

		if not resellPrice then
			print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an unknown vehicle!'):format(xPlayer.getIdentifier()))
			cb(false)
		else
			MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(result)
				if result[1] then -- is it a rented vehicle?
					cb(false) -- it is, don't let the player sell it since he doesn't own it
				else
					MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
						['@owner'] = xPlayer.getIdentifier(),
						['@plate'] = plate
					}, function(result)
						if result[1] then -- does the owner match?
							local vehicle = json.decode(result[1].vehicle)

							if vehicle.model == model then
								if vehicle.plate == plate then
									xPlayer.addMoney(resellPrice)
									RemoveOwnedVehicle(plate)
									cb(true)
								else
									print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.getIdentifier()))
									cb(false)
								end
							else
								print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.getIdentifier()))
								cb(false)
							end
						end
					end)
				end
			end)
		end
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getStockItems', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_addoninventory:getSharedInventory', xPlayer.getJob().name, function(inventory)
		cb(inventory.getItems())
	end)
end)


-- FIX #4 TODO para que cojones queire todo el inventario?
ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.getInventory()

	cb({items = items})
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	ESX.exposedDB.getDocumentByRow( 'plate', plate, function(result)
		cb(result ~= false)
	end)
	--[[MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)--]]
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.getIdentifier(),
		['@type'] = type,
		['@job'] = xPlayer.getJob().name
	}, function(result)
		cb(result)
	end)
end)


function isJobValid(job) 
	if job == "cardealer" then
		return true
	end
end

RegisterNetEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.getJob().name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[esx_vehicleshop] [^3WARNING^7] %s exploited the garage!'):format(xPlayer.getIdentifier()))
		end
	end)
end)

function UnrentVehicleAsync(identifier, plate)
	MySQL.Async.execute('DELETE FROM rented_vehicles WHERE identifier = @identifier AND plate = @plate', {
		['@identifier'] = identifier,
		['@plate'] = plate
	})
end

function PayRent(d, h, m)
	local tasks, timeStart = {}, os.clock()
	print('[esx_vehicleshop] [^2INFO^7] Paying rent cron job started')

	MySQL.Async.fetchAll('SELECT owner, rent_price, plate FROM rented_vehicles', {}, function(result)
		for k,v in pairs(result) do
			table.insert(tasks, function(cb)
				local xPlayer = ESX.GetPlayerFromIdentifier(v.owner)

				if xPlayer then
					if xPlayer.getAccount('bank').money >= v.rent_price then
						xPlayer.removeAccountMoney('bank', v.rent_price)
						xPlayer.showNotification(_U('paid_rental', ESX.Math.GroupDigits(v.rent_price), v.plate))
					else
						xPlayer.showNotification(_U('paid_rental_evicted', ESX.Math.GroupDigits(v.rent_price), v.plate))
						UnrentVehicleAsync(v.owner, v.plate)
					end
				else
					MySQL.Async.fetchScalar('SELECT accounts FROM users WHERE identifier = @identifier', {
						['@identifier'] = v.owner
					}, function(accounts)
						if accounts then
							local playerAccounts = json.decode(accounts)

							if playerAccounts and playerAccounts.bank then
								if playerAccounts.bank >= v.price then
									playerAccounts.bank = playerAccounts.bank - v.price

									MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE identifier = @identifier', {
										['@identifier'] = v.owner,
										['@accounts'] = json.encode(playerAccounts)
									})
								else
									UnrentVehicleAsync(v.owner, v.plate)
								end
							end
						end
					end)
				end

				TriggerEvent('esx_addonaccount:getSharedAccount', xPlayer.getJob().name, function(account)
					account.addMoney(result[i].rent_price)
				end)

				cb()
			end)
		end

		Async.parallelLimit(tasks, 5, function(results) end)

		local elapsedTime = os.clock() - timeStart
		print(('[esx_vehicleshop] [^2INFO^7] Paying rent cron job took %s seconds'):format(elapsedTime))
	end)
end

RegisterCommand("vehicleShopOff", function()
	saveResourceData()
end, true)


function saveResourceData()
	print( GetHashKey("cardealer_vehicles"))
	-- Guardar vehiculos de los vendedores de coches
	ESX.exposedDB.updateOrCreateDocument( GetHashKey("cardealer_vehicles"),
			{cardealer_vehicles = cardealer_vehicles}
		,function(result)
		if result then
			print("Vehicle buyed and updated correctly")
		end
	end)

	-- guardar los vehiculos en renta actualmente
	ESX.exposedDB.updateOrCreateDocument(GetHashKey("rented_vehicles"),
	{
		rented_vehicles
	}, function(result)
		if result then
			print("rented vehicles saved")
		end
	end)
end

-- Thread to ensure the data saving
Citizen.CreateThread(function()
	while true do
		Wait(1800000)
		saveResourceData()
	end
end)

RegisterCommand("vehicleshopoff", function() 
	saveResourceData()
end, true)

exports("getConfigVehicleShop", function() 
	return Config.Zones
end)


TriggerEvent('cron:runAt', 22, 00, PayRent)

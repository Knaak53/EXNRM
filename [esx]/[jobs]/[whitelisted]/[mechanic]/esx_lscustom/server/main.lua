ESX = nil
local Vehicles = {}

ESX = exports.extendedmode:getSharedObject()

AddEventHandler('esx:dataReady', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	ESX.exposedDB.getDocument(GetHashKey("vehicles"),function(result)
		if result then
			for k,v in pairs(result.vehicles_categories.dealer) do
				for k2,v2 in pairs(v.vehicles) do
					table.insert(Vehicles, {
						model = v2.model,
						price = v2.price,
						
					})
				end
			end
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
end)

RegisterServerEvent('esx_lscustom:buyMod')
AddEventHandler('esx_lscustom:buyMod', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)

	if Config.IsMechanicJobOnly then
		local societyAccount

		TriggerEvent('esx_addonaccount:getSharedAccount', 'mechanic', function(account)
			print(json.encode(account))
			societyAccount = account
		end)
		print(price, societyAccount.money)
		if price < societyAccount.getMoney() then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			societyAccount.removeMoney(price)
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end
	else
		if price < xPlayer.getMoney() then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end
	end
end)

---Update vehicle mods in database
RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(carprops)
	ESX.exposedDB.getDocument(GetHashKey(carprops.plate),function(car)
		if car then
			ESX.exposedDB.updateDocument(GetHashKey(carprops.plate),{props = carprops},function(result)
				if not result then
					print("^1Error esx_lscustom:refreshOwnedVehicle update document^7")
				end
			end)
		end
	end)
end)


ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	cb(Vehicles)
end)
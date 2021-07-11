ESX = nil

ESX = exports.extendedmode:getSharedObject()

ESX.RegisterServerCallback('esx_tattooshop:requestPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		--[[MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)	
		end)]]--
		local tattoos = xPlayer.get("tattoos")
		if not tattoos then
			xPlayer.set("tattoos", {})
			cb({})
		else
			cb(tattoos)
		end
	else
		cb()
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:purchaseTattoo', function(source, cb, tattooList, price, tattoo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		table.insert(tattooList, tattoo)
		xPlayer.set("tattoos", tattooList)
		--[[MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
			['@tattoos'] = json.encode(tattooList),
			['@identifier'] = xPlayer.identifier
		})]]--

		TriggerClientEvent('esx:showNotification', source, _U('bought_tattoo', ESX.Math.GroupDigits(price)))
		cb(true)
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', source, _U('not_enough_money', ESX.Math.GroupDigits(missingMoney)))
		cb(false)
	end
end)

ESX = nil
local shopItems = {}

ESX = exports.extendedmode:getSharedObject()

ESX.RegisterServerCallback('weapons:getLicense', function(source, cb)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local userLicense = xPlayer.get("licenses")

	if userLicense["weapon"] then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(source, cb, weaponName, zone, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.hasWeapon(weaponName) then
		xPlayer.showNotification(_U('already_owned'))
		cb(false)
	else
		if zone == 'BlackWeashop' then
			if xPlayer.getAccount('black_money').money >= price then
				xPlayer.removeAccountMoney('black_money', price)
				xPlayer.addWeapon(weaponName, 42)

				cb(true)
			else
				xPlayer.showNotification(_U('not_enough_black'))
				cb(false)
			end
		else
			if xPlayer.getMoney() >= price then
				xPlayer.removeMoney(price)
				xPlayer.addWeapon(weaponName, 42)

				cb(true)
			else
				xPlayer.showNotification(_U('not_enough'))
				cb(false)
			end
		end
	end
end)

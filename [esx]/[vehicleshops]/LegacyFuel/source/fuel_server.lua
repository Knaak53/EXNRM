ESX = nil

ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price, type, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price)

	if type == 'refill' then
		xPlayer.addWeaponAmmo("weapon_petrolcan", ammo)
	end
	if type == 'give' then
		xPlayer.addWeapon("weapon_petrolcan", 4500)
	end
		
	if price > 0 then
		xPlayer.removeMoney(amount)
	end
end)

RegisterServerEvent('fuel:removeAmmo')
AddEventHandler('fuel:removeAmmo', function(ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	local loadoutNum, weapon = xPlayer.getWeapon("weapon_petrolcan")

	if weapon.ammo - ammo >= 0 then
		xPlayer.removeWeaponAmmo("weapon_petrolcan", ammo)
	end
end)

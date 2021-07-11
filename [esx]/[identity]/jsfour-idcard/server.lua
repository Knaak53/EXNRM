local ESX = nil
-- ESX
ESX = exports.extendedmode:getSharedObject()

-- Open ID card
RegisterServerEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(ID, targetID, type)
	local xPlayer = ESX.GetPlayerFromId(ID)
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false
	print(_source, "holaaa")

	--MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	local user = xPlayer.get("identity").real
	local licenses = xPlayer.get("licenses")
	if type ~= nil then
		for k, v in pairs(licenses) do
			if type == 'driver' then
				if k == 'drive' or k == 'drive_bike' or k == 'drive_truck' then
					show = true
				end
			elseif type =='weapon' then
				if k == 'weapon' then
					show = true
				end
			elseif type =='dni' then
				if k == 'dni' then
					show = true
				end
			end
		end
	else
		show = true
	end

	if show then
		local array = {
			user = user,
			licenses = licenses
		}
		TriggerClientEvent('jsfour-idcard:open', _source, array, type)
	end
	--[[function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				
			end)
		end
	end)]]
end)

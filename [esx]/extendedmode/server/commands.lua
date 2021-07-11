ESX.RegisterCommand('setcoords', 'admin', function(xPlayer, args, showError)
	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

ESX.RegisterCommand('setjob', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job, args.grade) then
		args.playerId.setJob(args.job, args.grade)
		ESX.RegisterLogCommand(xPlayer.getIdentifier(), xPlayer.getGroup(), 'setjob', args.reason)
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'},
	{name = 'reason', help = _U('command_setjob__reason'), type = 'string'}
}})

ESX.RegisterCommand('car', {'mod', 'admin','superadmin'}, function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:spawnVehicle', args.car)
end, false, {help = _U('command_car'), validate = false, arguments = {
	{name = 'car', help = _U('command_car_car'), type = 'any'}
}})


ESX.RegisterCommand('ckplayer', 'superadmin', function(xPlayer, args, showError)
	ckPlayer(args.identifier)
end, true, {help = _U('command_car'), validate = false, arguments = {
	{name = 'identifier', help = "identificador del usario fivem:xxxxxx", type = 'any'}
}})

ESX.RegisterCommand({'cardel', 'dv'}, 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:deleteVehicle', args.radius)
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _U('command_cardel_radius'), type = 'any'}
}})

ESX.RegisterCommand('setaccountmoney', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount)
		ESX.RegisterLogCommand(xPlayer.getIdentifier(), xPlayer.getGroup(), 'setaccountmoney', args.reason)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'},
	{name = 'reason', help = _U('command_giveaccountmoney_reason'), type = 'string'}
}})

ESX.RegisterCommand('giveaccountmoney', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount)
		ESX.RegisterLogCommand(xPlayer.getIdentifier(), xPlayer.getGroup(), 'giveaccountmoney', args.reason)
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'},
	{name = 'reason', help = _U('command_giveaccountmoney_reason'), type = 'string'}
}})

ESX.RegisterCommand('giveitem', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	args.playerId.addInventoryItem(args.item, args.count)
	ESX.RegisterLogCommand(xPlayer.getIdentifier(), xPlayer.getGroup(), 'giveitem', args.reason)
end, true, {help = _U('command_giveitem'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
	{name = 'count', help = _U('command_giveitem_count'), type = 'number'},
	{name = 'reason', help = _U('command_giveaccountmoney_reason'), type = 'string'}
}})

ESX.RegisterCommand('giveweapon', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weapon) then
		showError(_U('command_giveweapon_hasalready'))
	else
		xPlayer.addWeapon(args.weapon, args.ammo)
		ESX.RegisterLogCommand(xPlayer.getIdentifier(), xPlayer.getGroup(), 'giveweapon', args.reason)
	end
end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weapon', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'ammo', help = _U('command_giveweapon_ammo'), type = 'number'},
	{name = 'reason', help = _U('command_giveaccountmoney_reason'), type = 'string'}
}})

ESX.RegisterCommand('giveweaponcomponent', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weaponName) then
		local component = ESX.GetWeaponComponent(args.weaponName, args.componentName)

		if component then
			if xPlayer.hasWeaponComponent(args.weaponName, args.componentName) then
				showError(_U('command_giveweaponcomponent_hasalready'))
			else
				xPlayer.addWeaponComponent(args.weaponName, args.componentName)
				ESX.RegisterLogCommand(xPlayer.getIdentifier(), xPlayer.getGroup(), 'giveweaponcomponent', args.reason)
			end
		else
			showError(_U('command_giveweaponcomponent_invalid'))
		end
	else
		showError(_U('command_giveweaponcomponent_missingweapon'))
	end
end, true, {help = _U('command_giveweaponcomponent'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weaponName', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'componentName', help = _U('command_giveweaponcomponent_component'), type = 'string'},
	{name = 'reason', help = _U('command_giveaccountmoney_reason'), type = 'string'}
}})

ESX.RegisterCommand({'clear', 'cls'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = _U('command_clear')})

ESX.RegisterCommand({'clearall', 'clsall'}, {'superadmin', 'admin'}, function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = _U('command_clearall')})

ESX.RegisterCommand('clearinventory', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	for k,v in pairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
		end
	end
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('clearloadout', {'superadmin', 'admin'}, function(xPlayer, args, showError)
	for k,v in pairs(args.playerId.loadout) do
		args.playerId.removeWeapon(v.name)
	end
end, true, {help = _U('command_clearloadout'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('setgroup', 'superadmin', function(xPlayer, args, showError)
	args.playerId.setGroup(args.group)
end, true, {help = _U('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'},
}})

ESX.RegisterCommand('save', 'admin', function(xPlayer, args, showError)
	print(('[ExtendedMode] [^2INFO^7] Manual player data save triggered for "%s"'):format(args.playerId.name))
	--print("ID: "..args.playerId.. "name: "..xPlayer.getName())
	ESX.SavePlayer(args.playerId, function(rowsChanged)
		if rowsChanged ~= 0 then
			print(('[ExtendedMode] [^2INFO^7] Saved player data for "%s"'):format(args.playerId.name))
		else
			print(('[ExtendedMode] [^3WARNING^7] Failed to save player data for "%s"! This may be caused by an internal error on the MySQL server.'):format(args.playerId.name))
		end
	end)
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('saveall', 'superadmin', function(xPlayer, args, showError)
	print('[ExtendedMode] [^2INFO^7] Manual player data save triggered')
	ESX.SavePlayers(function(result)
		if result then
			print('[ExtendedMode] [^2INFO^7] Saved all player data')
		else
			print('[ExtendedMode] [^3WARNING^7] Failed to save player data! This may be caused by an internal error on the MySQL server.')
		end
	end)
	ESX.SaveVehicles(function(result)
		if result then
			print('[ExtendedMode] [^2INFO^7] Saved all Vehicles data')
		else
			print('[ExtendedMode] [^3WARNING^7] Failed to save Vehicles data! This may be caused by an internal error on the MySQL server.')
		end
	end)
end, true, {help = _U('command_saveall')})

ESX.RegisterCommand('prepararkicks', 'superadmin', function(xPlayer, args, showError)
	Citizen.CreateThread(function()
		local seconds = tonumber(args.seconds)
        for i = seconds,0,-5 do 
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"Servidor", "El servidor va a cerrar en " .. i .. " segundos."}
            })
            Citizen.Wait(5000)
        end
        local xPlayers = ESX.GetPlayers()
        for k,v in pairs(xPlayers) do 
            DropPlayer(v, "El servidor esta cerrando para reiniciar.")
            Citizen.Wait(10)
        end
    end)

end, true, {help = "Kickea a todos los jugadores cuando el contador acabe", validate = true, arguments = {
    {name = 'seconds', help = "Segundos para kickear a todos en multiplos de 5", type = 'number'}
}})



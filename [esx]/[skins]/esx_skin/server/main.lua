ESX = nil
local playerSkins = {}

ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local defaultMaxWeight = ESX.GetConfig().MaxWeight
	local backpackModifier = Config.BackpackWeight[skin.bags_1]

	if backpackModifier then
		xPlayer.setMaxWeight(defaultMaxWeight + backpackModifier)
	else
		xPlayer.setMaxWeight(defaultMaxWeight)
	end

	xPlayer.set("skin",skin)
	ESX.exposedDB.SavePlayerExtraData(source, "skin", skin, false)
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() == 'admin' then
		local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

		file:write(json.encode(skin) .. "\n\n")
		file:flush()
		file:close()
	else
		print(('esx_skin: %s attempted saving skin to file'):format(xPlayer.getIdentifier()))
	end
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if playerSkins[xPlayer.getIdentifier()] == nil then
			local skin = xPlayer.get("skin")

			local jobSkin = {
				skin_male   = xPlayer.getJob().skin_male,
				skin_female = xPlayer.getJob().skin_female
			}

			--if skin then
			--	skin = json.decode(skin)
			--end
			
			--playerSkins[xPlayer.getIdentifier()] = skin
			cb(skin, jobSkin)
	end
	--MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
	--	['@identifier'] = xPlayer.identifier
	--}, function(users)
	--	local user, skin = users[1]
--
	--	local jobSkin = {
	--		skin_male   = xPlayer.job.skin_male,
	--		skin_female = xPlayer.job.skin_female
	--	}
--
	--	if user.skin then
	--		skin = json.decode(user.skin)
	--	end
--
	--	cb(skin, jobSkin)
	--end)
end)

ESX.RegisterCommand('skin', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx_skin:openSaveableMenu')
end, false, {help = _U('skin')})

ESX.RegisterCommand('skinsave', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx_skin:requestSaveSkin')
end, false, {help = _U('saveskin')})

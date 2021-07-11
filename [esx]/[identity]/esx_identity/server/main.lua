ESX = nil

ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent('esx_identity:startCreation')
AddEventHandler('esx_identity:startCreation',function(source,type)
	TriggerClientEvent('esx_identity:showRegisterIdentity',source,type)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			local xPlayers = ESX.GetPlayers()

			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

				if xPlayer then
					local identity = xPlayer.get("identity")
					if identity.used then
						xPlayer.setName(('%s %s %s'):format(identity.real.name, identity.real.firstname, identity.real.secondname))
					elseif identity.used ~= nil then
						xPlayer.setName(('%s %s %s'):format(identity.fake.name, identity.fake.firstname, identity.fake.secondname))
					end
				end
			end
		end)
	end
end)

---Cambiar identidad como todo se rige por el getName
RegisterServerEvent('esx_identity:changeIdentity')
AddEventHandler('esx_identity:changeIdentity',function(source,type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identity = xPlayer.get("identity")
	if type then
		xPlayer.setName(('%s %s %s'):format(identity.real.name, identity.real.firstname, identity.real.secondname))
	else
		if identity.fake == {} then
			TriggerClientEvent('esx_identity:showRegisterIdentity',source,false)
		else
			xPlayer.setName(('%s %s %s'):format(identity.fake.name, identity.fake.firstname, identity.fake.secondname))
		end
	end
	print(xPlayer.getName())
end)

RegisterServerEvent('esx_identity:changeFakeIdentity')
AddEventHandler('esx_identity:changeFakeIdentity',function(source)
	TriggerClientEvent('esx_identity:showRegisterIdentity',source,false)
end)

RegisterServerEvent('esx_identity:changeRealIdentity')
AddEventHandler('esx_identity:changeRealIdentity',function(source)
	TriggerClientEvent('esx_identity:showRegisterIdentity',source,true)
end)


-- RegisterCommand("register",function (source, arg1, arg2)
-- 	TriggerClientEvent('esx_identity:showRegisterIdentity',source,false)
-- end,false)

-- RegisterCommand("real",function (arg1, arg2, arg3)
-- 	TriggerEvent('esx_identity:changeIdentity',arg1,true)
-- end)

-- RegisterCommand("fake",function (arg1, arg2, arg3)
-- 	TriggerEvent('esx_identity:changeIdentity',arg1,false)
-- end)

-- RegisterCommand("changefake",function (arg1, arg2, arg3)
-- 	TriggerEvent('esx_identity:changeFakeIdentity',arg1)
-- end)

-- RegisterCommand("changereal",function (arg1, arg2, arg3)
-- 	TriggerEvent('esx_identity:changeRealIdentity',arg1)
-- end)

-- RegisterCommand("myidentity",function(arg1, arg2, arg3)
-- 	local xPlayer = ESX.GetPlayerFromId(arg1)
-- 	print(xPlayer.getName())
-- end)

RegisterServerEvent('esx_identity:validateIdentity')
AddEventHandler('esx_identity:validateIdentity',function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identity = xPlayer.get("identity")
	print(json.encode(identity))
	if identity ~= nil then
		if identity.validated == false then
			identity.validated = true
			xPlayer.set("identity",identity) 
			print("Identity validate done") 
		end
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local myID = {
		steamid = xPlayer.getIdentifier(),
		playerid = playerId
	}

	TriggerClientEvent('esx_identity:saveID', playerId, myID)
		local data = xPlayer.get("identity")
		if data == nil then
			print("identidad nula")
			TriggerClientEvent('esx_identity:identityCheck', playerId, false)
			TriggerClientEvent('esx_identity:showRegisterIdentity', playerId, true)
		else
			if data.used then
				xPlayer.setName(('%s %s %s'):format(data.real.name, data.real.firstname, data.real.secondname))
			elseif data.used ~= nil then
				xPlayer.setName(('%s %s %s'):format(data.fake.name, data.fake.firstname, data.fake.secondname))
			--xPlayer.setName(('%s %s %s'):format(data.name, data.firstname, data.lastname))
			
			--TriggerEvent('esx_identity:characterUpdated', playerId, data)
			end
			TriggerClientEvent('esx_identity:identityCheck', playerId, true)
		end
end)

-- RegisterCommand("validate",function(source,args,raw)
-- 	TriggerEvent('esx_identity:validateIdentity',source)
-- end,false)

RegisterServerEvent('esx_identity:setIdentity')
AddEventHandler('esx_identity:setIdentity',function(data,type)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(json.encode(xPlayer))
	local identity = xPlayer.get("identity")
	if identity == nil then
		identity = {
			real = {},
			fake = {},
			used = type,
			validated = false
		}
		xPlayer.set("identity",identity)
	end
	if type then
		identity.real = {
			name = data.name,
			firstname = data.firstname,
			secondname = data.lastname,
			sex = data.sex,
			height = data.height,
			dateofbirth = data.dateofbirth,
		}
		xPlayer.setName(('%s %s %s'):format(data.name, data.firstname, data.lastname))
	else
		identity.fake = {
			name = data.name,
			firstname = data.firstname,
			secondname = data.lastname,
			sex = data.sex,
			heigh = data.heigh,
			dateofbirth = data.dateofbirth,
		}
		xPlayer.setName(('%s %s %s'):format(data.name, data.firstname, data.lastname))
	end
	xPlayer.set("identity",identity)
	print(xPlayer.getName())
end)
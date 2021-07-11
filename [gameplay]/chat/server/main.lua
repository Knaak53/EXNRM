ESX = nil
Citizen.CreateThread(function() 
    while ESX == nil do
        Wait(1000)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)



function getIdentity(source)
    local xPlayer = ESX.GetPlayerFromId(source)

	
	
	if xPlayer ~= nil then
		local identifier = xPlayer.getIdentifier()
        local identity = xPlayer.get("identity")
		return {
			identifier = identifier,
			name = xPlayer.getName(),
			firstname = identity.real.name,
			lastname = identity.real.firstname,
			dateofbirth = identity.real.dateofbirth,
			sex = identity.real.sex,
			height = identity.real.height,
			job = xPlayer.getJob().name,
			group = xPlayer.getGroup()
		}
	else
		return nil
	end
end



AddEventHandler("chatMessage", function(source, color, message)
    local src = source
    args = stringsplit(message, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
    end
end)

RegisterServerEvent('chat:server:ServerPSA')
AddEventHandler('chat:server:ServerPSA', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message server">SERVER: {0}</div>',
        args = { message }
    })
    CancelEvent()
end)


RegisterServerEvent('911')
AddEventHandler('911', function(source, caller, msg)
    local name = getIdentity(source)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend911', -1, source, fal, msg)
end)

RegisterServerEvent('311')
AddEventHandler('311', function(source, caller, msg)
    local name = getIdentity(source)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend311', -1, source, fal, msg)
end)


RegisterServerEvent('911r')
AddEventHandler('911r', function(target, source, msg)
    local name = getIdentity(source)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend911r', -1, source, fal, msg)
end)

RegisterServerEvent('311r')
AddEventHandler('311r', function(target, source, msg)
    local name = getIdentity(source)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend311r', -1, source, fal, msg)
end)

RegisterServerEvent('chat:server:911source')
AddEventHandler('chat:server:911source', function(source, caller, msg)
    local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message emergency">911 {0} ({1}): {2} </div>',
        args = { fal, caller, msg }
    })
    CancelEvent()
end)

RegisterServerEvent('chat:server:911r')
AddEventHandler('chat:server:911r', function(target, caller, msg)
    local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', target, {
        template = '<div class="chat-message emergency">911r {0} : {1} </div>',
        args = { fal, msg }
    })
    CancelEvent()
    TriggerClientEvent('chat:EmergencySend911', fal, caller, msg)
end)

RegisterServerEvent('chat:server:311r')
AddEventHandler('chat:server:311r', function(target, caller, msg)
    local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', target, {
        template = '<div class="chat-message nonemergency">311r {0}: {1} </div>',
        args = { fal, msg }
    })
    CancelEvent()
end)


RegisterServerEvent('chat:server:311source')
AddEventHandler('chat:server:311source', function(source, caller, msg)
    local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message nonemergency">311 {0} ({1}): {2} </div>',
        args = { fal, caller, msg }
    })
    CancelEvent()
end)




function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
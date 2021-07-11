RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:server:ClearChat')
RegisterServerEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    --print(message)
    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
    end

	local _source = source

	local name = getIdentity(source)
	fal = "["..source.."]"..GetPlayerName(source)--name.firstname .. "  " .. name.lastname

    local meDistance = 15
	local players = ESX.GetPlayers()
	for k,v in pairs(players) do
		if k % 15 == 0 then
			Citizen.Wait(50)
		end

		
		distance = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(GetPlayerPed(_source)))
		if distance < meDistance then
			color = 7
			TriggerClientEvent('chat:addMessage', v, {
				template = '<div class="chat-message advert"><b>OOC de cercanía {0}: </b> {1}</div>',
				args = { fal, message}
			})
		end
	end

    --print(author .. '^7: ' .. message .. '^7')
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

-- command suggestions for clients

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    --refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)

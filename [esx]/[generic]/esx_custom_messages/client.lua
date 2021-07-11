local playingMessage = false
local messageQueue = {}


---------------------------------------------------------------------------------------------

------------------------------- VOICE MESSAGES ----------------------------------------------

---------------------------------------------------------------------------------------------

RegisterNetEvent('esx_custom_messages:showMessage')
AddEventHandler('esx_custom_messages:showMessage', function( group, random, messageName )
	local message = getMessage(group, random, messageName)
	playOrQueueMessage(message, group)	
end)

function getMessage(group, random, messageName)
	math.randomseed(GetGameTimer())
	if random then		
		return Config.messages[group].messages[messageName][messageName .. math.random(1, getMessagesCount(Config.messages[group].messages[messageName]))]
	else
		return Config.messages[group].messages[messageName]
	end
end

function getMessagesCount(messages)
	local count = 0
	for k, v in pairs(messages) do
		count = count + 1
	end
	return count
end

function playOrQueueMessage(message, group)
	if playingMessage then
		table.insert(messageQueue, {message = message, group = group})
	else
		playMessage(message, group)
	end
end

function playMessage(message, group)
	Citizen.CreateThread(function()
		playingMessage = true
		SendNUIMessage({
			action = "show",
			title  = Config.messages[group].title,
			text   = message.message,
			img = Config.messages[group].npcImage,
			audio = message.audio
		})
		Citizen.Wait(message.duration)
		SendNUIMessage({
			action = "hide"
		})
		Citizen.Wait(1000)
		playingMessage = false
		if #messageQueue > 0 then
			playMessage(messageQueue[1].message, messageQueue[1].group)
			table.remove(messageQueue, 1)
			print(#messageQueue)
		end
	end)
end










---------------------------------------------------------------------------------------------

---------------------------------- TEXT MESSAGES --------------------------------------------

---------------------------------------------------------------------------------------------
RegisterCommand("textMessage", function(source)
    playOrQueueTextMessage("Has recibido ~g~x1~b~ Ledger Nano S", "item", "monster", "add")
    TriggerEvent('esx_custom_messages:showMessage', "badulakes", true, "bye")
end)


local showingTextMessage = false
local textMessageQueue = {}

RegisterNetEvent('esx_custom_messages:showTextMessage')
AddEventHandler('esx_custom_messages:showTextMessage', function(message, messageType)
	playOrQueueTextMessage(message, messageType)	
end)

RegisterNetEvent('esx_custom_messages:showInventoryTextMessage')
AddEventHandler('esx_custom_messages:showInventoryTextMessage', function(message, item, movementType)
	playOrQueueTextMessage(message, 'item', item, movementType)	
end)

function playOrQueueTextMessage(message, messageType, item, movementType)
	SendNUIMessage({
		action = "showText",
		message = message,
		messageType = messageType,
		item = item,
		movementType = movementType
	})
end
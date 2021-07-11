
--ESX = nil
--ESX = exports.extendedmode:getSharedObject()

channelMessage = {}
function TchatGetMessageChannel (channel, cb)
  if channelMessage[channel] ~= nil then
    cb(channelMessage[channel])
  else
    ESX.exposedDB.getDocument(GetHashKey("channelMessages"), function(result) 
      if result then
        channelMessage = result
        if channelMessage[channel] then
          cb(channelMessage[channel])
        else
          cb(false)
        end
      else
        cb(false)
      end
    end)
  end
end

function TchatAddMessage (channel, message)
  if channelMessage[channel] == nil then
    channelMessage[channel] = {}
  end

  local messageS = 
  {
    ['channel'] = channel,
    ['message'] = message
  }
  table.insert(channelMessage[channel], messageS)
  
  TriggerClientEvent('gcPhone:tchat_receive', -1, messageS)
end


RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(channel)
  local sourcePlayer = tonumber(source)
  TchatGetMessageChannel(channel, function (messages)
    TriggerClientEvent('gcPhone:tchat_channel', sourcePlayer, channel, messages)
  end)
end)

RegisterServerEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage', function(channel, message)
  TchatAddMessage(channel, message)
end)

RegisterCommand("saveChannelMessages", function() 
  ESX.exposedDB.updateOrCreateDocument(GetHashKey("channelMessages"), channelMessage, function(result)
    if result then
      print("^2 Channel messages saved sucessfully^7")
    else
      print("^1 Error saving channels messages!^7")
    end
  end)
end, true)

--Autosave each x Time
Citizen.CreateThread(function() 
    local x = 1800000 -- 30 minutes
    while true do
      Wait(x)
      ExecuteCommand("saveChannelMessages")
    end
end)
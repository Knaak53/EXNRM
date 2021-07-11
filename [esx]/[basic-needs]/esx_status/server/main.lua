ESX = nil
ESX = exports.extendedmode:getSharedObject()

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local data = xPlayer.get('status')
	TriggerClientEvent('esx_status:load', playerId, data)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)
end)

AddEventHandler('esx_status:getStatus', function(playerId, statusName, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status  = xPlayer.get('status')
	for i=1, #status, 1 do
		if status[i].name == statusName then
			cb(status[i])
			break
		end
	end
end)

RegisterServerEvent('esx_status:update')
AddEventHandler('esx_status:update', function(status)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		xPlayer.set('status', status)
	end
end)
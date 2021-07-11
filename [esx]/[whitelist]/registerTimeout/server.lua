ESX = nil

TriggerEvent(
	"esx:getSharedObject",
	function(obj)
		ESX = obj
	end
)

ESX.RegisterServerCallback('getPlayerHistoryStatus', function(source, cb)
	xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		hasDni =  MySQL.Sync.fetchScalar('select dni from whitelist WHERE identifier = @identifier', {['@identifier'] = string.sub(xPlayer.getIdentifier(), 9)})
		if not hasDni then
			historyTimeout = MySQL.Sync.fetchScalar('select DATEDIFF(now(), entryDate) as diff from whitelist WHERE identifier = @identifier', {['@identifier'] = string.sub(xPlayer.getIdentifier(), 9)})
			if historyTimeout <= 3 then
				TriggerClientEvent('updateDias', source, historyTimeout)
				TriggerClientEvent('updateMostrar', source, true)
			end	
		end	
	end		
end)

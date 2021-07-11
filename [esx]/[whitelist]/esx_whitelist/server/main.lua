ESX, WhiteList = nil, {}

ESX = exports.extendedmode:getSharedObject()

function loadWhiteList(cb)
	Whitelist = {}

	MySQL.Async.fetchAll('SELECT identifier FROM whitelist where historyTimeout = @historyTimeout', {['@historyTimeout'] = 0}, function(result)
		for k,v in ipairs(result) do
			WhiteList[v.identifier] = true
		end

		if cb then
			cb()
		end
	end)
end

MySQL.ready(function()
	loadWhiteList()
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	-- Mark this connection as deferred, this is to prevent problems while checking player identifiers.
	deferrals.defer()

	local playerId, kickReason, identifier = source
	
	-- Letting the user know what's going on.
	deferrals.update(_U('whitelist_check'))
	
	-- Needed, not sure why.
	Citizen.Wait(10)

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end

	if not WhiteList[identifier] then
		userTimeout = MySQL.Sync.fetchScalar('select historyTimeout from users WHERE identifier = @identifier', {['@identifier'] = 'license:' .. identifier})
		if not userTimeout then
			MySQL.Async.execute('INSERT INTO whitelist (identifier, entryDate) VALUES (@identifier, now())', {
				['@identifier'] = identifier
			}, function(rowsChanged)		
			end)
			WhiteList[identifier] = true
		end
	else
		hasDni =  MySQL.Sync.fetchScalar('select dni from whitelist WHERE identifier = @identifier', {['@identifier'] = identifier})
		if not hasDni then
			historyTimeout = MySQL.Sync.fetchScalar('select DATEDIFF(now(), entryDate) as diff from whitelist WHERE identifier = @identifier', {['@identifier'] = identifier})
			if historyTimeout > 3 then
				MySQL.Async.execute('UPDATE whitelist set historyTimeout = @timeout where identifier = @identifier', {
					['@identifier'] = identifier,
					['@timeout'] = 1
				}, function(rowsChanged)
				end)
				MySQL.Async.execute('UPDATE users set historyTimeout = @timeout where identifier like @identifier', {
					['@identifier'] = '%' .. identifier,
					['@timeout'] = 1
				}, function(rowsChanged)
				end)
				WhiteList[identifier] = false
				loadWhiteList()
			end	
		end		
	end

	if ESX.Table.SizeOf(WhiteList) == 0 then
		kickReason = _U('whitelist_empty')
	elseif not identifier then
		kickReason = _U('license_missing')
	elseif not WhiteList[identifier] then
		kickReason = _U('not_whitelisted')
	end

	if kickReason then
		deferrals.done(kickReason)
	else
		deferrals.done()
	end
end)

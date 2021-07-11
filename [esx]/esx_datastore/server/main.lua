DataStores, DataStoresIndex, SharedDataStores = {}, {}, {}
ESX = nil
DebugMode = true

ESX = exports.extendedmode:getSharedObject()


ESX = exports.extendedmode:getSharedObject()
AddEventHandler("onResourceStart", function(resource)
	if GetCurrentResourceName() == resource then
		Citizen.CreateThread(function() 
			Wait(50)
			print("Iniciando")
			ESX.exposedDB.getDocument(GetHashKey("datastore"),function(result)
				if result then

					-- Si hay alguna cuenta nueva la inicializamos y la guardamos
					for k,v in pairs(datastore_dump) do
						if result.datastore[k] == nil then
							result.datastore[k] = v

							ESX.exposedDB.updateDocument(GetHashKey("datastore"), 
									{datastore = result.datastore}
							,function(result) 
								if result == true then
									print("Error during addon account set up")
								else
									if DebugMode then
										print("datastores updated")
									end
								end
							end)

						end
					end

					cached_doc = result.datastore
					--print(json.encode(cached_doc))
					for k,v in pairs(cached_doc) do
						local name   = v.name
						local label  = v.label
						local shared = v.shared
						--local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
							--['@account_name'] = name
						--})
				
						if shared == 0 then

							table.insert(DataStoresIndex, name)
				
						else
							local data = v.data
				
				
							local dataStore    = CreateDataStore(name, nil, data)
							print(name)
							SharedDataStores[name] = dataStore
						end
					end
				else
					print(datastore_dump)
					ESX.exposedDB.createDocumentWithId(GetHashKey("datastore") ,
						{
							datastore = datastore_dump
						},
						function(result, err)
							if not result then
								print("ERROR: "..err)
								print(datastore_dump)
							end
							--addon_account = nil
						end
					)
				end
			end)
		end)
	end
end)
--MySQL.ready(function()
--	local result = MySQL.Sync.fetchAll('SELECT * FROM datastore')
--
--	for i=1, #result, 1 do
--		local name, label, shared = result[i].name, result[i].label, result[i].shared
--		local result2 = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE name = @name', {
--			['@name'] = name
--		})
--
--		if shared == 0 then
--			table.insert(DataStoresIndex, name)
--			DataStores[name] = {}
--
--			for j=1, #result2, 1 do
--				local storeName  = result2[j].name
--				local storeOwner = result2[j].owner
--				local storeData  = (result2[j].data == nil and {} or json.decode(result2[j].data))
--				local dataStore  = CreateDataStore(storeName, storeOwner, storeData)
--
--				table.insert(DataStores[name], dataStore)
--			end
--		else
--			local data
--
--			if #result2 == 0 then
--				MySQL.Sync.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, NULL, \'{}\')', {
--					['@name'] = name
--				})
--
--				data = {}
--			else
--				data = json.decode(result2[1].data)
--			end
--
--			local dataStore = CreateDataStore(name, nil, data)
--			SharedDataStores[name] = dataStore
--		end
--	end
--end)

function GetDataStore(name, owner)
	return DataStores[owner][name]
end

function GetDataStoreOwners(name)
	local identifiers = {}

	for k,v in pairs(DataStores[name]) do
		table.insert(identifiers, DataStores[name][k].owner)
	end

	return identifiers
end

function GetSharedDataStore(name)
	return SharedDataStores[name]
end

AddEventHandler('esx_datastore:getDataStore', function(name, owner, cb)
	cb(GetDataStore(name, owner))
end)

AddEventHandler('esx_datastore:getDataStoreOwners', function(name, cb)
	cb(GetDataStoreOwners(name))
end)

AddEventHandler('esx_datastore:getSharedDataStore', function(name, cb)
	cb(GetSharedDataStore(name))
end)


local function accountsNeedToBeSetUp(datasToCheck)
	local missedDataStores = {}
	if #DataStoresIndex == #datasToCheck then
		return false
	else
		for k,v in pairs(DataStoresIndex) do
			if datasToCheck[v] == nil then
				table.insert(missedDataStores, v)
			end
		end
	end
	return missedDataStores
end

local function loadPlayer(xPlayer)
	local dataStores = {}
	ESX.exposedDB.getDocument(GetHashKey("datastore_"..xPlayer.getIdentifier()), function(result) 
		if result then
			local accountsToSetUp = accountsNeedToBeSetUp(result.datastore)
			if accountsToSetUp then
				for k,v in pairs(accountsToSetUp) do			
					result.datastore[v] = {name = v, data = {}}
				end
				ESX.exposedDB.updateDocument(GetHashKey("datastore_"..xPlayer.getIdentifier()), 
					{datastore = result.datastore}
				,function(result) 
					if result == true then
						print("Error during player datastore set up")
					else
						if DebugMode then
							print("Player datastore updated")
						end
					end
				end)
			end
			for k,v in pairs(result.datastore) do
				
				if DataStores[result.owner] == {} or DataStores[result.owner] == nil then
					DataStores[result.owner] = {}
				elseif DebugMode then
						print("No re-inicialized")
				end
				

				local datastore = CreateDataStore(v.name, result.owner, v.data)
				print("Index: "..v.name)
				--print("Index owner: "..result.owner)
				DataStores[result.owner][v.name] = datastore

				local datastore = GetDataStore(v.name, xPlayer.getIdentifier())
				table.insert(dataStores, datastore)
			end
			xPlayer.set('dataStores', dataStores)
		else
			local datastores = {}
			for i=1, #DataStoresIndex, 1 do
				local name    = DataStoresIndex[i]
				
				datastores[name] = 
				{
					name = name,
					data = {}
				}
				--print("addon account: "..json.encode(account))
				
				if DebugMode then
					print("^2 Addon accounts inizialized for player^7: "..xPlayer.getName().. " ^7")
				end
			end
			ESX.exposedDB.createDocumentWithId(GetHashKey("datastore_"..xPlayer.getIdentifier()),
			{
				datastore = datastores,
				owner = xPlayer.getIdentifier(),
			},function(result, err) 
				if not result then
					print("^8[FATAL ^8ERROR]: ^7the datastores for player: "..xPlayer.getName().." couldnt be initialize")
					print("ERROR CODE:.."..err)
				else
					print("Insertando")
					loadPlayer(xPlayer)
					if DebugMode then
						print("^2 datastores inizialized for player^7: "..xPlayer.getName().. " ^7")
					end
				end
			end)
			
		end
	end)
end

function saveSharedDataStores(forShutdown)
	ESX.exposedDB.getDocument(GetHashKey("datastore"),function(result)
		if result then
			local annonTable = {}
			--print("hash: " .. GetHashKey("addon_inventories"))
			for k, v in pairs(SharedDataStores) do
				--print("Saving datastore: "..json.encode(v))
				if result.datastore[v.getName()].shared == 1 then
					result.datastore[v.getName()].data = v.getData()
				end
			end
			ESX.exposedDB.updateDocument(
				GetHashKey("datastore"),
					result,
				function(result)
					if not forShutdown then
						Citizen.SetTimeout(
							1200000,
							saveSharedDataStores
						)
					end
					if not result then
						print(
							"^8Fatal Error in addon inventories"
						)
					else
						print("datastores saved sucessfully and ready for a shutdown")
					end
				end
			)
		end
	end)
end

AddEventHandler('esx:playerDropped', function(playerId, reason, xPlayer)
	ForgetPlayerDataStore(xPlayer.getIdentifier())
	if DebugMode then
		print("Liberado espacio en cache de datastore del jugador: "..xPlayer.getName())
	end
end)

function ForgetPlayerDataStore(owner)
	local annonTable = {}
	--print("hash: " .. GetHashKey("datastore_" .. self.owner))
	for k, v in pairs(DataStores[owner]) do
		annonTable[v.getName()] = {
			name = v.getName(),
			data = v.getData()
		}
	end

	ESX.exposedDB.updateDocument(
		GetHashKey("datastore_" .. owner),
		{
			datastore = annonTable
		},
		function(result)
			--print("hash: " .. GetHashKey("datastore_" .. self.owner))
			if not result then
				print(
					"^8Fatal Error in addon accounts self saving, unable to save the account: " ..
						" from player: " .. owner
				)
			end
		end
	)
	DataStores[owner] = nil
end

function saveAllPlayerForShutdown()
	for j,i in pairs(DataStores) do
		local annonTable = {}
		for k, v in pairs(DataStores[j]) do
			annonTable[v.getName()] = {
				name = v.getName(),
				data = v.getData()
			}
		end

		ESX.exposedDB.updateDocument(
			GetHashKey("datastore_" .. j),
			{
				datastore = annonTable
			},
			function(result)
				
				if not result then
					print(
						"^8Fatal Error in addon inventories general saving, unable to save the account: " ..
							" from player: " .. j
					)
				end
			end
		)
	end
end

RegisterCommand("addonDataStoreOff", function() 
	saveAllPlayerForShutdown()
	saveSharedDataStores(true)
end, true)


AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	loadPlayer(xPlayer)
end)

Citizen.SetTimeout(
	1200000,
	saveSharedDataStores
)


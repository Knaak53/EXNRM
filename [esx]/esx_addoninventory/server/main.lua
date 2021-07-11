Items = {}
InventoriesIndex, Inventories, SharedInventories = {}, {}, {}
ESX = nil
local DebugMode = true

ESX = exports.extendedmode:getSharedObject()

Citizen.CreateThread(function() 
	Wait(5000)
	ESX = exports.extendedmode:getSharedObject()
end)

AddEventHandler("onResourceStart", function(resource) 
	if GetCurrentResourceName() == resource then
		Citizen.CreateThread(function() 
			Wait(50)
			print("Iniciando")
			ESX.exposedDB.getDocument(GetHashKey("addon_inventories"),function(result)
				if result then

					-- Si hay alguna cuenta nueva la inicializamos y la guardamos
					for k,v in pairs(addon_inventories_dump) do
						if result.addon_inventories[k] == nil then
							result.addon_inventories[k] = v

							ESX.exposedDB.updateDocument(GetHashKey("addon_inventories"), 
									{addon_inventories = result.addon_inventories}
							,function(result) 
								if result == true then
									print("Error during addon account set up")
								else
									if DebugMode then
										print("Accounts updated")
									end
								end
							end)

						end
					end

					cached_doc = result.addon_inventories
					--print(json.encode(cached_doc))
					for k,v in pairs(cached_doc) do
						local name   = v.name
						local label  = v.label
						local shared = v.shared
						--local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
							--['@account_name'] = name
						--})
				
						if shared == 0 then

							table.insert(InventoriesIndex, name)
				
						else
							local items = {}
				
							for k,v in pairs(v.items) do
								items[v.name] = {
									name  = v.name,
									count = v.count,
									label = v.label
								}
							end
				
							local addonInventory    = CreateAddonInventory(name, nil, items)
							SharedInventories[name] = addonInventory
						end
					end
				else
					print(addon_inventories_dump)
					ESX.exposedDB.createDocumentWithId(GetHashKey("addon_inventories") ,
						{
							addon_inventories = addon_inventories_dump
						},
						function(result, err)
							if not result then
								print("ERROR: "..err)
								print(addon_inventories_dump)
							end
							--addon_account = nil
						end
					)
				end
			end)
		end)
	end
end)


--obtiene un inventario en concreto del player
function GetInventory(name, owner)
	return Inventories[owner][name]
end

-- Elimina del caché todos los inventarios que pertenezcan a ese owner/usuario ej: steam:1234567900
function ForgetPlayerInventory(owner)
	local annonTable = {}
	--print("hash: " .. GetHashKey("addon_inventories_" .. self.owner))
	for k, v in pairs(Inventories[owner]) do
		annonTable[v.getName()] = {
			name = v.getName(),
			items = v.getItems()
		}
	end
	ESX.exposedDB.updateDocument(
		GetHashKey("addon_inventories_" .. owner),
		{
			addon_inventories = annonTable
		},
		function(result)
			--print("hash: " .. GetHashKey("addon_account_" .. self.owner))
			if not result then
				print(
					"^8Fatal Error in addon accounts saving, unable to save the account: " ..
						" from player: " .. owner
				)
			end
		end
	)
	Inventories[owner] = nil
end

function GetSharedInventory(name)
	return SharedInventories[name]
end

AddEventHandler('esx_addoninventory:getInventory', function(name, owner, cb)
	cb(GetInventory(name, owner))
end)

AddEventHandler('esx_addoninventory:getSharedInventory', function(name, cb)
	cb(GetSharedInventory(name))
end)

AddEventHandler("esx_addoninventory:createShared", function(e)
	local v = json.decode(e)
	print(v.name)
	if cached_doc[v.name] == nil then
		local name   = v.name
		local label  = v.label
		local shared = 1
		local items = {}
				
		for k,v in pairs(v.items) do
			table.insert(items, {
				name  = v.name,
				count = v.count,
				label = v.label
			})
		end
					
		if v.items == nil or v.items == {} then
			print("Addon account error: The data for "..v.label.." addon account wasnt set up properly")
		else
			items = v.items
		end

		local addonInventory  = CreateAddonInventory(name, nil, items)
		SharedInventories[name] = addonInventory
		print("Añadido: "..SharedInventories[name].getName())
		ESX.exposedDB.getDocument(GetHashKey("addon_inventories"), function(result)
			if result then
				result.addon_inventories[name] = 
				{
					name = name,
					label = label,
					shared = 1,
					items = 
					{
						example = {
							name = "example",
							label = "Example",
							count = 2,
						}
					}
				}
				ESX.exposedDB.updateOrCreateDocument(GetHashKey("addon_inventories"), {addon_inventories = result.addon_inventories}, function(re) if re then print("OK") else print("BAD") end end)
			end
		end)
	end
end)

local function accountsNeedToBeSetUp(accountsToCheck)
	local missedAccounts = {}
	if #InventoriesIndex == #accountsToCheck then
		return false
	else
		for k,v in pairs(InventoriesIndex) do
			if accountsToCheck[v] == nil then
				table.insert(missedAccounts, v)
			end
		end
	end
	return missedAccounts
end

-- función para cargar los inventarios de un usuario en caché
local function loadPlayer(xPlayer)
	local addonInventories = {}
	ESX.exposedDB.getDocument(GetHashKey("addon_inventories_"..xPlayer.getIdentifier()), function(result) 
		print("el result devuelve:".. json.encode(result))
		if result then
			local accountsToSetUp = accountsNeedToBeSetUp(result.addon_inventories)
			if accountsToSetUp then
				for k,v in pairs(accountsToSetUp) do
					result.addon_inventories[v] = {name = v, items = {}}
				end
				ESX.exposedDB.updateDocument(GetHashKey("addon_inventories_"..xPlayer.getIdentifier()), 
					{addon_inventories = result.addon_inventories}
				,function(result) 
					if result == true then
						print("Error during player addon set up")
					else
						if DebugMode then
							print("Player Accounts updated")
						end
					end
				end)
			end
			for k,v in pairs(result.addon_inventories) do
				
				if Inventories[result.owner] == {} or Inventories[result.owner] == nil then
					Inventories[result.owner] = {}
				elseif DebugMode then
						print("No re-inicialized")
				end
				
				local addonInventory = CreateAddonInventory(v.name, result.owner, v.items)
				print("Index: "..v.name)
				print("Index owner: "..result.owner)
				Inventories[result.owner][v.name] = addonInventory

				local account = GetInventory(v.name, xPlayer.getIdentifier()).getAddonInventory()
				addonInventories[account.name] = account
			end
			xPlayer.set('addonInventories', addonInventories)
		else
			local addon_inventories = {}
			for i=1, #InventoriesIndex, 1 do
				local name    = InventoriesIndex[i]
				
				addon_inventories[name] = 
				{
					name = name,
					items = {}
				}
				--print("addon account: "..json.encode(account))
				
				if DebugMode then
					print("^2 Addon accounts inizialized for player^7: "..xPlayer.getName().. " ^7")
				end
			end
			ESX.exposedDB.createDocumentWithId(GetHashKey("addon_inventories_"..xPlayer.getIdentifier()),
			{
				addon_inventories = addon_inventories,
				owner = xPlayer.getIdentifier(),
			},function(result, err) 
				if not result then
					print("^8[FATAL ^8ERROR]: ^7the addon inventory for player: "..xPlayer.getName().." couldnt be initialize")
					print("ERROR CODE:.."..err)
				else
					print("Insertando")
					loadPlayer(xPlayer)
					if DebugMode then
						print("^2 Addon inventory inizialized for player^7: "..xPlayer.getName().. " ^7")
					end
				end
			end)
			
		end
	end)
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	loadPlayer(xPlayer)
end)

-- Limpiar de la caché las cuentas de un usuario que haya desconectado
AddEventHandler('esx:playerDropped', function(playerId, reason, xPlayer)
	ForgetPlayerInventory(xPlayer.getIdentifier())
	if DebugMode then
		print("Liberado espacio en cache de addon_accounts del jugador: "..xPlayer.getName())
	end
end)

function saveSharedInventories(forShutdown)
	ESX.exposedDB.getDocument(GetHashKey("addon_inventories"),function(result)
		if result then
			local annonTable = {}
			--print("hash: " .. GetHashKey("addon_inventories"))
			for k, v in pairs(SharedInventories) do
				print(v.getName())
				if result.addon_inventories[v.getName()].shared == 1 then
					result.addon_inventories[v.getName()].items = v.getItems()
				end
			end
			ESX.exposedDB.updateDocument(
				GetHashKey("addon_inventories"),
					result,
				function(result)
					if not forShutdown then
						Citizen.SetTimeout(
							1200000,
							saveSharedInventories
						)
					end
					if not result then
						print(
							"^8Fatal Error in addon inventories"
						)
					else
						print("addon inventories saved sucessfully and ready for a shutdown")
					end
				end
			)
		end
	end)
end

function saveAllPlayerForShutdown()
	for j,i in pairs(Inventories) do
		local annonTable = {}
		for k, v in pairs(Inventories[j]) do
			print(json.encode(v))
			annonTable[v.getName()] = {
				name = v.getName(),
				items = v.getItems()
			}
		end

		ESX.exposedDB.updateDocument(
			GetHashKey("addon_inventories_" .. j),
			{
				addon_inventories = annonTable
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


RegisterCommand("addoninventoriesOff", function() 
	--saveAllPlayerForShutdown()
	saveSharedInventories(true)
end, true)

Citizen.SetTimeout(
	1200000,
	saveSharedInventories
)

--saveSharedInventories(true)
	
--saveAllPlayerForShutdown()
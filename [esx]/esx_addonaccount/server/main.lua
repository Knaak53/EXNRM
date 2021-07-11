AccountsIndex, Accounts, SharedAccounts = {}, {}, {}
ESX = nil
local DebugMode = false

ESX = exports.extendedmode:getSharedObject()

-- carga en caché las cuentas que son compartidas y se prepara los datos para cuando entre algún usuario
AddEventHandler("onResourceStart", function(resource) 
	if GetCurrentResourceName() == resource then
		Citizen.CreateThread(function() 
			Wait(50)
			ESX.exposedDB.getDocument(GetHashKey("addon_accounts"),function(result)
				if result then
					-- Si hay alguna cuenta nueva la inicializamos y la guardamos
					for k,v in pairs(addon_account_dump) do
						if result.addon_accounts[k] == nil then
							result.addon_accounts[k] = v

							ESX.exposedDB.updateDocument(GetHashKey("addon_accounts"), 
									{addon_accounts = result.addon_accounts}
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

					addon_account_dump = nil
					-- cacheamos el doc para usos posteriores
					cached_doc = result.addon_accounts
					for k,v in pairs(cached_doc) do
						local name   = v.name
						local label  = v.label
						local shared = v.shared
				
				
						if shared == 0 then
							table.insert(AccountsIndex, name)  
						else
							local money = nil
				
							if v.data == nil or v.data == {} then
								print("Addon account error: The data for "..v.label.." addon account wasnt set up properly")
							else
								money = v.data.money
							end
				
							local addonAccount   = CreateAddonAccount(name, nil, money)
							SharedAccounts[name] = addonAccount
						end
					end
				else
					print(addon_account_dump)
					ESX.exposedDB.createDocumentWithId(GetHashKey("addon_accounts") ,
						{
							addon_accounts = addon_account_dump
						},
						function(result, err)
							if not result then
								if DebugMode then
									print("ERROR: "..err)
									print(addon_account_dump)
								end
							end
							addon_account_dump = nil
							--addon_account = nil
						end
					)
				end
			end)
		end)
	end
end)

-- Obtiene una cuenta en concreto del owner/usuario
function GetAccount(name, owner)
	--return Accounts[owner]
	return Accounts[owner][name]
end


-- Elimina del caché todas las cuentas que pertenezcan a ese owner/usuario ej: steam:1234567900
function ForgetPlayerAccount(owner)
	for k,v in pairs(Accounts[owner]) do
		if v.savingState then
			Citizen.SetTimeout(
				1200000, function() 
				Accounts[owner] = nil
			end)
			return
		end
	end
	Accounts[owner] = nil
end

-- Obtiene una cuenta compartida: ej: "oncesionario1"
function GetSharedAccount(name)
	return SharedAccounts[name]
end

-- Obtener los datos de una cuenta en concreto de un owner/usuario desde otro resource, solo serverside
AddEventHandler('esx_addonaccount:getAccount', function(name, owner, cb)
	cb(GetAccount(name, owner))
end)

-- Obtener los datos de una cuenta compartida, solo serverside
AddEventHandler('esx_addonaccount:getSharedAccount', function(name, cb)
	cb(GetSharedAccount(name))
end)

AddEventHandler("esx_addonaccount:createShared", function(e)
	local v = json.decode(e)
	if cached_doc[v.name] == nil then
		local name   = v.name
		local label  = v.label
		local shared = 1
		local money = nil
					
		if v.data == nil or v.data == {} then
			print("Addon account error: The data for "..v.label.." addon account wasnt set up properly")
		else
			money = v.data.money
		end

		local addonAccount   = CreateAddonAccount(name, nil, money)
		SharedAccounts[name] = addonAccount
		ESX.exposedDB.getDocument(GetHashKey("addon_accounts"), function(result)
			if result then
				result.addon_accounts[name] = 
				{
					name = name,
					label = label,
					shared = 1,
					data = 
					{
						money = 100000,
						owner = "steam:12345678900"
					}
				}
				ESX.exposedDB.updateOrCreateDocument(GetHashKey("addon_accounts"), {addon_accounts = result.addon_accounts}, function() end)
			end
		end)
	end
end)

-- chekea si alguna cuenta no ha sido inicializada en este jugador todavía
local function accountsNeedToBeSetUp(accountsToCheck)
	local missedAccounts = {}
	if #AccountsIndex == #accountsToCheck then
		return false
	else
		for k,v in pairs(AccountsIndex) do
			if accountsToCheck[v] == nil then
				table.insert(missedAccounts, v)
			end
		end
	end
	return missedAccounts
end

-- función para cargar las cuentas de un usuario en caché
local function loadPlayer(xPlayer)
	local addonAccounts = {}
	ESX.exposedDB.getDocument(GetHashKey("addon_account_"..xPlayer.getIdentifier()), function(result) 
		if result then
			local accountsToSetUp = accountsNeedToBeSetUp(result.addon_accounts)
			if accountsToSetUp then
				for k,v in pairs(accountsToSetUp) do
					
					result.addon_accounts[v] = { name = v, money = 0, owner = xPlayer.getIdentifier()}
				end
				ESX.exposedDB.updateDocument(GetHashKey("addon_account_"..xPlayer.getIdentifier()), 
					{addon_accounts = result.addon_accounts}
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
			for k,v in pairs(result.addon_accounts) do
				
				if Accounts[result.owner] == {} or Accounts[result.owner] == nil then
					Accounts[result.owner] = {}
				elseif DebugMode then
						print("No re-inicialized")
				end
				
				--Accounts[result.owner][v.name] = {}
				local addonAccount = CreateAddonAccount(v.name, result.owner, v.money)
				print("name de la cuenta: "..v.name)
				Accounts[result.owner][v.name] = addonAccount
				
				local account = GetAccount(v.name, xPlayer.getIdentifier()).getAddonAccount()
				addonAccounts[account.name] = account
			end
			xPlayer.set('addonAccounts', addonAccounts)
		else
			local addon_accounts = {}
			for i=1, #AccountsIndex, 1 do
				local name    = AccountsIndex[i]
				
				addon_accounts[name] = 
				{
					name = name,
					money = 0,
				}
				--print("addon account: "..json.encode(account))
				
				if DebugMode then
					print("^2 Addon accounts inizialized for player^7: "..xPlayer.getName().. " ^7")
				end
			end
			ESX.exposedDB.createDocumentWithId(GetHashKey("addon_account_"..xPlayer.getIdentifier()),
			{
				addon_accounts = addon_accounts,
				owner = xPlayer.getIdentifier()
			},function(result, err) 
				if not result then
					print("^8[FATAL ^8ERROR]: ^7the addon account for player: "..xPlayer.getName().." couldnt be initialize")
					print("ERROR CODE:.."..err)
				else
					if DebugMode then
						print("^2 Addon accounts inizialized for player^7: "..xPlayer.getName().. " ^7")
					end
				end
			end)
			print("Insertando")
			loadPlayer(xPlayer)
		end
	end)
end

-- Cargar las cuentas de usuario en caché cuando conecte ese usuario
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	loadPlayer(xPlayer)
end)


-- Limpiar de la caché las cuentas de un usuario que haya desconectado
AddEventHandler('esx:playerDropped', function(playerId, reason, xPlayer)
	ForgetPlayerAccount(xPlayer.getIdentifier())
	if DebugMode then
		print("Liberado espacio en cache de addon_accounts del jugador: "..xPlayer.getName())
	end
end)

function saveSharedAccounts(forShutdown)
	ESX.exposedDB.getDocument(GetHashKey("addon_accounts"),function(result)
		if result then
			local annonTable = {}
			print("hash: " .. GetHashKey("addon_accounts"))
			for k, v in pairs(SharedAccounts) do
				if result.addon_accounts[v.getName()] ~= nil then
					if result.addon_accounts[v.getName()].shared == 1 then
						result.addon_accounts[v.getName()].data.money = v.getMoney()
					end
				else
					
				end
			end

			ESX.exposedDB.updateDocument(
				GetHashKey("addon_accounts"),
					result,
				function(result)
					if not forShutdown then
						Citizen.SetTimeout(
							1200000,
							saveSharedAccounts
						)
					end
					print("hash: " .. GetHashKey("addon_accounts"))
					if not result then
						print(
							"^8Fatal Error in addon accounts self saving, unable to save the account: " ..
								" from player: " .. self.owner
						)
					end
				end
			)
		end
	end)
end

function saveAllPlayerForShutdown()
	for j,i in pairs(Accounts) do
		local annonTable = {}
		for k, v in pairs(Accounts[j]) do
			--print(json.encode(v))
			annonTable[v.getName()] = {
				name = v.getName(),
				money = v.getMoney()
			}
		end

		ESX.exposedDB.updateDocument(
			GetHashKey("addon_accounts_" .. j),
			{
				addon_accounts = annonTable
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

RegisterCommand("addonaccountsOff", function() 
	saveAllPlayerForShutdown()
	saveSharedAccounts(true)
end, true)

Citizen.SetTimeout(
	1200000,
	saveSharedAccounts
)

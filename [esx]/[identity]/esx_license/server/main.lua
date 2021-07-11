ESX = nil
--Hay que cachear todo tipo de licencias.
--Las licencias van a estar dentro de las caracteristicas de cada player
--Cuando se cambie la licencia se va a hacer directamente sobre bd porque las licencias no se estan cambiando todo el rato lo unico que se quedará cacheado son los jugadores y sus licencias
--para que a la hora de pedirlos no se vaya contra bd si no contra la caché
ESX = exports.extendedmode:getSharedObject()
--Cargar en cache las licencias cuando entra y crear su espacio

-- TODO FIX #1 -> Avililla
-- Aquí asumes que todo jugador tiene un atributo licenses, la primera vez que un jugador entre fallará y nunca se inicializarán las licencias, en el caso de que no tenga ese atributo se debe crear en el player, pista: saveplayerextradata...
function LoadPlayer(source,xPlayer)
	if xPlayer.get("licenses") == nil then
		xPlayer.set("licenses",{})
	end
end 

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	LoadPlayer(source,xPlayer)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
	Citizen.CreateThread(function()
		local xPlayers = ESX.GetPlayers()

			for i=1, #xPlayers, 1 do
	 			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

				if xPlayer then
					LoadPlayer(xPlayer.source,xPlayer)
	 			end
	 		end
	 	end)

	end
end)
--Solo se toca la base de datos al añadir o eliminar nunca al pedir o coger todo eso se hace sobre cache
function AddLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		if Config.licenses[type] ~= nil then
			local playerLicenses = xPlayer.get("licenses")
			if playerLicenses[type] ~= nil then
				playerLicenses[type] = type
			else
				playerLicenses[type] = type
			end
			xPlayer.set("licenses",playerLicenses)
		end
	end
	if cb then
		cb()
	end
end

function RemoveLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		if Config.licenses[type] ~= nil then
			local playerLicenses = xPlayer.get("licenses")
			if playerLicenses[type] ~= nil then
				playerLicenses[type] = nil
			end
			xPlayer.set("licenses",playerLicenses)
		end
	end
end

function GetLicense(type, cb)
	if Config.licenses[type] ~= nil then
		local data = {
			type = Config.licenses[type].type,
			label = Config.licenses[type].label
		}
		cb(data)
	else
		cb()--No se que script lo usa pero para un futuro devuelvo false si la licencia no existe
	end
end

function GetLicenses(target, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	local licenses = {}
	if xPlayer.get("licenses") ~= nil then
		for k,v in pairs(xPlayer.get("licenses")) do
			table.insert(licenses,{
				type = v,
				label = Config.licenses[v].label
			})
		end
		cb(licenses)
	else
		cb()
	end
end

function CheckLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer.get("licenses")[type] == type then
		cb(true)
	else
		cb(false)
	end
end

function GetLicensesList(cb)

	local licenses = {}

	for k,v in pairs(Config.licenses) do
		table.insert(licenses,{
			type = v.type,
			label = v.label
		})
	end
	cb(licenses)
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)


---TEST LICENSE Comands
RegisterCommand("getLicensesList",function()
	GetLicensesList(function(licenses)
		for k,v in pairs(licenses) do
			print(k)
			print(v.type.." ;"..v.label)
		end
	end)
end,false)


RegisterCommand("checkLicense",function(source,args)
	local time = GetGameTimer()
	CheckLicense(source,args[1],function(ok)
		print(ok)
	end)
	print(GetGameTimer()-time.." ms to check")
end, false)

RegisterCommand("getLicenses",function(source)
	local time = GetGameTimer()
	GetLicenses(source,function(licenses)
		if licenses then
			for k,v in pairs(licenses) do
				--print(k)
				print(v.type.." ;"..v.label)
			end
		end
	end)
	print(GetGameTimer()-time.." ms to get")
end, false)

RegisterCommand("mostrarLicencias",function(source,args)
	GetLicense(args[1],function(license)
		if license then
			print(license.type)
			print(license.label)
		else
			print("Esa licencia no existe")
		end
	end)
end, false)

RegisterCommand("mostrar",function (source)
	for k,v in pairs(UserLicenses[source]) do
		print(v)
	end
end, true)

RegisterCommand("addlicense",function(source,args)
	local _source = source
	--print(_source)
	--local time = GetGameTimer()
	AddLicense(_source,args[1],function(cb)

	end)
	--print(GetGameTimer()-time.." ms to addLicense")
end,true)

RegisterCommand("performance",function(source)
	local time = GetGameTimer()
	for i = 1, 1000, 1 do
		RemoveLicense(source,"licencia3",function(cb)end)
	end
	print(GetGameTimer()-time.." ms to add and remove 1000 times")
end,true)

RegisterCommand("removelicense",function(source,args)
	local _source = source
	print(_source)
	print(args[1])
	RemoveLicense(_source,args[1],function(cb)end)
end,true)

RegisterCommand("pdata",function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
	SaveResourceFile(GetCurrentResourceName(), "playerData.json", json.encode(xPlayer.getPlayerVariables()), -1)
end, true)

RegisterCommand("Licencias",function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(json.encode(xPlayer.get("licenses")))
end, true)

exports('getLicenses', function()
	return Config.licenses
end)
ESX                = nil
local InService    = {}
local MaxInService = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetInServiceCount(name)
	local count = 0

	if InService[name] then
		for k,v in pairs(InService[name]) do
			if v == true then
				count = count + 1
			end
		end
	end

	return count
end

RegisterServerEvent('esx_service:getInServiceCount')
AddEventHandler('esx_service:getInServiceCount', function(name, cb)
	cb(GetInServiceCount(name))
end)

AddEventHandler('esx_service:activateService', function(name, max)
	InService[name]    = {}
	MaxInService[name] = max
end)

RegisterServerEvent('esx_service:disableService')
AddEventHandler('esx_service:disableService', function(name)
	InService[name][source] = nil
end)

RegisterServerEvent('esx_service:notifyAllInService')
AddEventHandler('esx_service:notifyAllInService', function(notification, name)
	for k,v in pairs(InService[name]) do
		if v == true then
			TriggerClientEvent('esx_service:notifyAllInService', k, notification, source)
		end
	end
end)

ESX.RegisterServerCallback('esx_service:enableService', function(source, cb, name)
	local inServiceCount = GetInServiceCount(name)

	print("llego")
	if inServiceCount >= MaxInService[name] then
		print("noo?")
		cb(false, MaxInService[name], inServiceCount)
	else
		print("puesto en servicio!")
		InService[name][source] = true
		cb(true, MaxInService[name], inServiceCount)
	end
end)

ESX.RegisterServerCallback('esx_service:isInService', function(source, cb, name)
	local isInService = false

	if InService[name][source] then
		isInService = true
	end

	cb(isInService)
end)

RegisterServerEvent('esx_service:isPlayerInService')
AddEventHandler('esx_service:isPlayerInService', function(cb, name, target)
	local isPlayerInService = false
	local targetXPlayer = ESX.GetPlayerFromId(target)
	print("chekeando")
	if InService[name] then
		if InService[name][targetXPlayer.source] then
			isPlayerInService = true
		end
	end
	
	cb(isPlayerInService)
end)

ESX.RegisterServerCallback('esx_service:isPlayerInService', function(source, cb, name, target)
	local isPlayerInService = false
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if InService[name][targetXPlayer.source] then
		isPlayerInService = true
	end

	cb(isPlayerInService)
end)

ESX.RegisterServerCallback('esx_service:getInServiceList', function(source, cb, name)
	cb(InService[name])
end)

AddEventHandler('playerDropped', function()
	local _source = source
		
	for k,v in pairs(InService) do
		if v[_source] == true then
			v[_source] = nil
		end
	end
end)

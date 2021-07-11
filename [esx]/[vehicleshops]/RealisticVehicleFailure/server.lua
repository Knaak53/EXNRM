------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--


TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

local function checkWhitelist(id)
	for key, value in pairs(RepairWhitelist) do
		if id == value then
			return true
		end
	end	
	return false
end

AddEventHandler('chatMessage', function(source, _, message)
	local msg = string.lower(message)
	local identifier = GetPlayerIdentifiers(source)[1]
	if msg == "/repair" then
		CancelEvent()
		if RepairEveryoneWhitelisted == true then
			TriggerClientEvent('iens:repair', source)
		else
			if checkWhitelist(identifier) then
				TriggerClientEvent('iens:repair', source)
			else
				TriggerClientEvent('iens:notAllowed', source)
			end
		end
	end
end)

RegisterServerEvent("rea:repairvehicle")
AddEventHandler("rea:repairvehicle", function() 
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(5000)
end)

--Menudo melon de persona no dejes que esto se quede en negativo menos si la gente no sabe el precio que es
ESX.RegisterServerCallback('Player:checkMoney', function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getMoney() >= 5000)
end)


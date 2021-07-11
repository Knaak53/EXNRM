-- E N G I N E --
ESX = nil


ESX = exports.extendedmode:getSharedObject()

AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/engine off" then
		CancelEvent()
		--------------
		TriggerClientEvent('engineoff', s)
	elseif message == "/engine on" then
		CancelEvent()
		--------------
		TriggerClientEvent('engineon', s)
	elseif message == "/engine" then
		CancelEvent()
		--------------
		TriggerClientEvent('engine', s)
	end
end)
-- T R U N K --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/trunk" then
		CancelEvent()
		--------------
		TriggerClientEvent('trunk', s)
	end
end)
-- R E A R  D O O R S --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/rdoors" then
		CancelEvent()
		--------------
		TriggerClientEvent('rdoors', s)
	end
end)
--TODO CHECK DELETE
RegisterServerEvent("baseevents:enteredVehicle")
AddEventHandler("baseevents:enteredVehicle", function(vehicle, seat, name) 
	local _source = source
	print("llega")
	if seat == -1 then
		TriggerClientEvent("vehicle-control:putEngineOff", _source, vehicle)
	end
end)


-- H O O D --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/hood" then
		CancelEvent()
		--------------
		TriggerClientEvent('hood', s)
	end
end)
-- L O C K --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/lock" then
		CancelEvent()
		--------------
		TriggerClientEvent('lock', s)
	end
end)
-- S A V E --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/save" then
		CancelEvent()
		--------------
		TriggerClientEvent('save', s)
	end
end)
-- R E M O T E --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/sveh" then
		CancelEvent()
		--------------
		TriggerClientEvent('controlsave', s)
	end
end)

---invento kaos--

--front l door---

AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/fldoor" then
		CancelEvent()
		--------------
		TriggerClientEvent('fldoor', s)
	end
end)

--front r door---

AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/frdoor" then
		CancelEvent()
		--------------
		TriggerClientEvent('frdoor', s)
	end
end)


RegisterServerEvent("vehcontrol:opentrunk")
AddEventHandler("vehcontrol:opentrunk", function(vehId, door) 
	print(vehId)
	if vehId ~= nil and vehId ~= 0 then
		local vehOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(vehId))
		print(vehOwner)
		if vehOwner ~= nil and vehOwner ~= 0 then
			TriggerClientEvent("vehcontrol:opentrunk", vehOwner, vehId, door)
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.showNotification("No puedes abrir nada en este vehiculo",true,nil,70)
		end
	end
end)

RegisterServerEvent("vehcontrol:closetrunk")
AddEventHandler("vehcontrol:closetrunk", function(vehId, door) 
	if vehId ~= nil and vehId ~= 0 then
		local vehOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(vehId))
		print(vehOwner)
		if vehOwner ~= nil and vehOwner ~= 0 then
			TriggerClientEvent("vehcontrol:closetrunk", vehOwner, vehId, door)
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.showNotification("No puedes abrir nada en este vehiculo",true,nil,70)
		end
	end
end)


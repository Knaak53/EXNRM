-- Coded by Xerxes468893#0001 (Peter Greek) For BCDOJRP, released to the public

ESX = nil 
Citizen.CreateThread(function() 
	while ESX == nil do 
		ESX = exports.extendedmode.getSharedObject()
		Citizen.Wait(2000) 
	end 
end)
print('Loaded ARPF by Xerxes468893 (Peter Greek) for BCDOJRP.') -- Do not Remove Pls!
local str = {}
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(5000)
		TriggerClientEvent("ARPF-EMS:stretcherSync", -1,str)	
	end
end)

RegisterNetEvent("ARPF-EMS:server:stretcherSync")
AddEventHandler("ARPF-EMS:server:stretcherSync", function(state,tableID,obj,towhat,sync)
	if tonumber(sync) == 0 or sync == false or sync == nil then 
		if state == 1 then -- add
			if tableID < 0 then 
				str[#str + 1] = { ['obj'] = obj, ['to'] = towhat}
				TriggerClientEvent("ARPF-EMS:stretcherSync", -1,str)
			end 
		elseif state == 2 then -- change
			if tableID > 0 then 
				str[tableID] = { ['obj'] = obj, ['to'] = towhat}
				TriggerClientEvent("ARPF-EMS:stretcherSync", -1,str)
			end
		elseif state == 3 then -- remove 
			if tableID > 0 then
				table.remove(str,tableID)
				TriggerClientEvent("ARPF-EMS:stretcherSync", -1,str)
			end
		end
	elseif tonumber(sync) == 1 or sync == true then -- this is to only force sync all players and not do anything to the table
		TriggerClientEvent("ARPF-EMS:stretcherSync", -1,str)
	end 
end)

RegisterServerEvent("stretcher:leaveThisStret")
AddEventHandler("stretcher:leaveThisStret", function(stretId) 
	local ent = NetworkGetEntityFromNetworkId(stretId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if DoesEntityExist(ent) and #(GetEntityCoords(ent) - xPlayer.getCoords(true)) < 5 and xPlayer.getJob().name == "ambulance" then
		DeleteEntity(ent)
	end
end)



RegisterCommand("spawnstr", function(source, args, raw)
	local player = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" then
		if (player > 0) then
			TriggerClientEvent("ARPF-EMS:spawnstretcher", source)
			CancelEvent()
		end
	end
end, false)
--print("copy")
RegisterCommand("pushstr", function(source, args, raw)
	local player = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" and tonumber(args[1]) > 0 then
		if (player > 0) then
			--print("true")
			TriggerClientEvent("ARPF-EMS:pushstreacherss", source, args[1])
			CancelEvent()
		end
	end
end, false)

RegisterServerEvent("pushstr")
AddEventHandler("pushstr", function(netId) 
	local player = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" and netId > 0 then
		if (player > 0) then
			--print("true")
			TriggerClientEvent("ARPF-EMS:pushstreacherss", source, netId)
			CancelEvent()
		end
	end
end)

RegisterServerEvent("stretIntoAmbulance")
AddEventHandler("stretIntoAmbulance", function(ambulance , value) 
	local ambu = NetworkGetEntityFromNetworkId(ambulance)
	if DoesEntityExist(ambu) then
		Entity(ambu).state.stretcherInto = value
	end
end)


RegisterServerEvent("externalunsit")
AddEventHandler("externalunsit", function(netId, target) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" then
		--print("vamoooh")
		TriggerClientEvent("externalunsit", target, netId)
		local ent = NetworkGetEntityFromNetworkId(netId)
		Entity(ent).state.playerAttached = false
	end
end)


RegisterServerEvent("playerAttachedToStret")
AddEventHandler("playerAttachedToStret", function(netId) 
	local ent = NetworkGetEntityFromNetworkId(netId)
	local ped = GetPlayerPed(source)
	print("source setting: "..source)
	if DoesEntityExist(ent) then
		print("source setted: "..source)
		Entity(ent).state.playerAttached = source
	end
end)



RegisterServerEvent("StreachertoCar")
AddEventHandler("StreachertoCar", function(ambuId, stretId, val) 
	print("id: "..stretId)
	local stretOwn = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(stretId))
	print("sending: ".. stretOwn)
	if stretOwn > 0 then
		TriggerClientEvent("StreachertoCar", stretOwn, ambuId, stretId, val)
	end
end)

RegisterServerEvent("stretcherOut")
AddEventHandler("stretcherOut", function() 
	local ped = GetPlayerPed(source)
	if DoesEntityExist(ped) then
		Entity(ped).state.intoStretcher = false
	end
end)

RegisterServerEvent("moveToOtherStret")
AddEventHandler("moveToOtherStret", function(netId, target) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" then
		TriggerClientEvent("moveToOtherStret", target, netId)
	end
end)

RegisterServerEvent("moveToBed")
AddEventHandler("moveToBed", function(netId, target) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" then
		TriggerClientEvent("moveToBed", target, netId)
		local ent = NetworkGetEntityFromNetworkId(netId)
		Entity(ent).state.playerAttached = false
	end
end)

RegisterCommand("getintostr", function(source, args, raw)
	local player = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	print(tonumber(args[1]))
	print(xPlayer.getJob().name)
	if xPlayer.getJob().name == "ambulance" and tonumber(args[1]) > 0 then
		if (player > 0) then
			local playerPed = GetPlayerPed(args[1])
			Entity(playerPed).state.intoStretcher = true
			TriggerClientEvent("ARPF-EMS:getintostretcher", args[1])
			CancelEvent()
		end
	end
end, false)

RegisterCommand("openbaydoors", function(source, args, raw)
	local player = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" then
		if (player > 0) then
			TriggerClientEvent("ARPF-EMS:opendoors", source)
			CancelEvent()
		end
	end
end, false)

RegisterCommand("togglestr", function(source, args, raw)
	local player = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getJob().name == "ambulance" then
		if (player > 0) then
			TriggerClientEvent("ARPF-EMS:togglestrincar", source)
			CancelEvent()
		end
	end
end, false)


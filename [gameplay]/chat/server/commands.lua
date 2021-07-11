
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local identity = xPlayer.get("identity")

		return {
			identifier = xPlayer.getIdentifier(),
			firstname = identity.real.name,
			lastname = identity.real.firstname,
			dateofbirth = identity.real.dateofbirth,
			sex = identity.real.sex,
			height = identity.real.height,
			job = xPlayer.getJob().name
		}
	else
		return nil
	end
end

--[[ COMMANDS ]]--

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)


RegisterCommand('ayuda', function(source, args, rawCommand)

	local msg = ""
	for k,v in pairs(args) do
		msg = msg .. " "..v
	end
	
	local name = getIdentity(source)
	fal = GetPlayerName(source)
        TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message success"><b>AYUDA ['.. source..'] {0} : </b> {1}</div>',
        args = { fal, msg }
    })
end, false)


RegisterCommand('rr', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	local name = getIdentity(source)
	if name.job == "police" or name.job == "ambulance" then
		Citizen.CreateThread(function() 
			local players = GetPlayers()
			local iden = name
			for k,v in pairs(players) do
				if k % 15 then
					Wait(50)
				end

				
				if iden.job == "police" then
					fal = name.firstname .. "  " .. name.lastname
					TriggerClientEvent('chat:addMessage', v, {
					template = '<div class="chat-message emergencies"><b>Agente {0}:</b> {1}</div>',
					args = { fal, msg }
					})
				end

				if iden.job == "ambulance" then
					fal = name.firstname .. "  " .. name.lastname
					TriggerClientEvent('chat:addMessage', v, {
					template = '<div class="chat-message emergencies"><b>Sanitario {0}:</b> {1}</div>',
					args = { fal, msg }
					})
				end
			end
		end)
	end
end, false)

RegisterCommand('rp', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	local name = getIdentity(source)

	if name.job == "police" then
		Citizen.CreateThread(function() 
			local players = GetPlayers()

			for k,v in pairs(players) do
				if k % 15 then
					Wait(50)
				end
				
				local iden = getIdentity(v).job
				if iden.job == "police"then
					fal = name.firstname .. "  " .. name.lastname
					TriggerClientEvent('chat:addMessage', v, {
					template = '<div class="chat-message emergencies"><b>Agente {0}:</b> {1}</div>',
					args = { fal, msg }
					})
				end
			end
		end)
	end
	
end, false)



RegisterCommand('ra', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	local name = getIdentity(source)
	if name.job == "ambulance" then
		Citizen.CreateThread(function() 
			local players = GetPlayers()

			for k,v in pairs(players) do
				if k % 15 then
					Wait(50)
				end
				
				local iden = getIdentity(v).job
				if iden.job == "ambulance" then
					fal = name.firstname .. "  " .. name.lastname
					TriggerClientEvent('chat:addMessage', v, {
					template = '<div class="chat-message emergencies"><b>Sanitario/a {0}:</b> {1}</div>',
					args = { fal, msg }
					})
				end
			end
		end)
	end
end, false)

local meDistance = 15
RegisterCommand('me', function(source, args, rawCommand)
	local msg = ""
	local _source = source
	for k,v in pairs(args) do
		msg = msg.. " ".. v
	end

	local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname

	local players = ESX.GetPlayers()
	for k,v in pairs(players) do
		if k % 15 == 0 then
			Citizen.Wait(50)
		end

		
		distance = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(GetPlayerPed(_source)))
		if distance < meDistance then
			color = 7
			TriggerClientEvent('chat:addMessage', v, {
				template = '<div class="chat-message me"><b>{0} </b> {1}</div>',
				args = { fal, msg}
			})
		end
	end
end)


local doDistance = 15
RegisterCommand('do', function(source, args, rawCommand)
	local msg = ""
	local _source = source
	for k,v in pairs(args) do
		msg = msg.. " ".. v
	end

	local name = getIdentity(source)
	fal = "Alrededor de "..name.firstname .. "  " .. name.lastname .." : "

	local players = ESX.GetPlayers()
	for k,v in pairs(players) do
		if k % 15 == 0 then
			Citizen.Wait(50)
		end

		
		distance = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(GetPlayerPed(_source)))
		if distance < meDistance then
			color = 7
			TriggerClientEvent('chat:addMessage', v, {
				template = '<div class="chat-message do"><b>{0} </b> {1}</div>',
				args = { fal, msg}
			})
		end
	end
	
end)



local doDistance = 15
RegisterCommand('bug', function(source, args, rawCommand)
	local msg = ""
	local _source = source
	for k,v in pairs(args) do
		msg = msg.. " ".. v
	end

	--local name = getIdentity(source)
	fal = "Bug reportado "..GetPlayerName(source) .. "["..source.."]"

	TriggerClientEvent('chat:addMessage', source, {
		template = '<div class="chat-message emergency"><b>{0} </b> {1}</div>',
		args = { fal, msg}
	})

	local players = ESX.GetPlayers()
	for k,v in pairs(players) do
		if k % 15 == 0 then
			Citizen.Wait(50)
		end
		xPlayer = ESX.GetPlayerFromId(v)

		
		
		isAdmin = xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "mod"
		--print(isAdmin)

		if isAdmin then
			fal = "Bug reportado de "..GetPlayerName(source) .. "["..source.."]"
			TriggerClientEvent('chat:addMessage', v, {
				template = '<div class="chat-message emergency"><b>{0} </b> {1}</div>',
				args = { fal, msg}
			})
		end
	end
	
end)


RegisterCommand('msg', function(source, cm)
	--CancelEvent()
	if #cm > 1 then
		local tPID = tonumber(cm[1])
		if tPID then
			local namesRe = GetPlayerName(tPID)
			if namesRe then
				local namesSender = GetPlayerName(source)
				
				local textmsg = ""
				for i=2, #cm do
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
					--setLog(textmsg,source)
				fal = "Mensaje de "..namesSender .. "[".. source .. "]:  "
				msg = textmsg
				TriggerClientEvent('chat:addMessage', tPID, {
					template = '<div class="chat-message nonemergency"><b>{0} </b> {1}</div>',
					args = { fal, msg}
				})

				fal = "Mensaje enviado a "..namesRe .. "[".. tPID .. "]:  "
				msg = textmsg
				TriggerClientEvent('chat:addMessage', source, {
					template = '<div class="chat-message nonemergency"><b>{0} </b> {1}</div>',
					args = { fal, msg}
				})
			end
		end

		--TriggerClientEvent('mensageprivado', tPID, source, textmsg, namesSender, namesRe,tPID)
		--TriggerClientEvent('mensageprivado:confirmacion', source, tPID, namesRe)
	end
end, false)

local dadosdistance = 15
RegisterCommand('dados', function(source, args, rawCommand)
	local msg = ""
	local _source = source
	
	msg = " saca en los dados un: "..math.random(1,100)

	local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname

	local players = ESX.GetPlayers()
	for k,v in pairs(players) do
		if k % 15 == 0 then
			Citizen.Wait(50)
		end

		
		local distance = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(GetPlayerPed(_source)))
		if distance < dadosdistance then
			color = 7
			TriggerClientEvent('chat:addMessage', v, {
				template = '<div class="chat-message do"><b>{0} </b> {1}</div>',
				args = { fal, msg}
			})
		end
	end
end)

local intentardistance = 15
RegisterCommand('intentar', function(source, args, rawCommand)
	local msg = ""
	local _source = source

	local sucess =  math.random(1,100) >= 50 
	
	if sucess then
		msg = msg .." consigue "
	else
		msg = msg .." falla al intentar "
	end

	for k,v in pairs(args) do
		msg = msg.. " ".. v
	end

	

	local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname

	local players = ESX.GetPlayers()
	for k,v in pairs(players) do
		if k % 15 == 0 then
			Citizen.Wait(50)
		end

		
		local distance = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(GetPlayerPed(_source)))
		if distance < intentardistance then
			color = 7
			TriggerClientEvent('chat:addMessage', v, {
				template = '<div class="chat-message me"><b>{0} </b> {1}</div>',
				args = { fal, msg}
			})
		end
	end
end)




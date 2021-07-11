ESX = nil
CurrentAlerts = {}
BlipAndAlertTime = 10--Tiempo en segundos
CurrentBlip = nil
RegisterNetEvent('911:syncalertsCl')
AddEventHandler('911:syncalertsCl',function(alert)
    if ESX.GetPlayerData().job.name == 'police' then --Inserto en la tabla cuando es policia
        table.insert(CurrentAlerts,alert)
        --print(json.encode(alert))  ---Llamamos a una funcion que intenta poner en funcionamiento la nui si no hay nada ejecutandose
    end
end)

RegisterKeyMapping('selectcurrentalert', 'Selección alerta', 'keyboard', 'm')
RegisterCommand('selectcurrentalert',function()
    if ESX.GetPlayerData().job.name == 'police' and #CurrentAlerts > 0 then
        print("Seleccionando la alerta" ..json.encode(CurrentAlerts[1]))
        --SetBlipRoute(CurrentBlip,true)
        SetNewWaypoint(CurrentAlerts[1].position.x , CurrentAlerts[1].position.y )
    end
end,false)

---Si Executing NUI entonces cogemos y marcamos la posición
Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        if #CurrentAlerts > 0 then
            local data = {
                code = "Llamada 911",
                loc = CurrentAlerts[1].location,
                dist = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(ped), CurrentAlerts[1].position, true),0),
                name = CurrentAlerts[1].msg
            }
            SendNUIMessage({action = 'display', style = 'police', info = data, length = 8000})
            --envio alerta creo bliop y elimino la primera
            CurrentBlip = ESX.CreateBlip(CurrentAlerts[1].position, 84, 48, 1.0,'Aviso a policia',GetCurrentResourceName())
            Citizen.Wait(8000)
            ESX.DeleteBlip(CurrentBlip,GetCurrentResourceName())
            table.remove(CurrentAlerts,1)
        else
            Citizen.Wait(1000)
        end
    end
end)



Citizen.CreateThread(function() 
    while ESX == nil do 
        ESX = exports.extendedmode:getSharedObject() 
        Citizen.Wait(0) 
    end 
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
		--print('Viendo job')
	end
	while ESX.GetPlayerData().job.name == nil do
		Citizen.Wait(500)
    end
end)
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/911', 'Envia una incidencia a la policia', {
    { name="Reporte", help="Detalla tu incidencia" }
})
end)

-- Command -- 

RegisterCommand('911', function(source, args)
    local msg = table.concat(args, ' ')
    if args[1] == nil then
        TriggerEvent('chatMessage', '^5911', {255,255,255}, ' ^7Detalla tu incidencia.')
    else
        local r, g, b = 0, 0x99, 255
        TriggerServerEvent('_chat:messageEntered', GetPlayerName(source), { r, g, b }, "Ha mandado un entorno")
        LlamadaPolicia(msg)
    end
end)

function LlamadaPolicia(msg)
    local ped = GetPlayerPed(PlayerId())
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local coords = GetEntityCoords(ped, true)
    local street = GetStreetNameAtCoord(x, y, z)
    local location = GetStreetNameFromHashKey(street)
    if msg == nil then
        return
    else
        if ESX.GetPlayerData().job.name ~= 'police' then  
            TriggerServerEvent("esx_phone:send", "police", "Llamada al 911 desde " .. location .. '| Reporte: ' .. msg, nil, GetEntityCoords(PlayerPedId()))
            TriggerServerEvent('911:syncalertsSv',{position = GetEntityCoords(PlayerPedId()),location = location, msg = msg})
        end
        --TriggerServerEvent("esx_phone:send", "police", "Llamada al 911 desde " .. location .. '| Reporte: ' .. msg, nil, GetEntityCoords(PlayerPedId()))
    end
end

-- RegisterCommand('prueba', function()
--     exports["911"]:LlamadaPolicia("heyyyyy")
-- end, false)



local meleeHits = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if IsPedTryingToEnterALockedVehicle(playerPed) or IsPedJacking(playerPed) then
            local vehicle = GetVehiclePedIsIn(playerPed, true)
            print("Entro")
            Wait(3000)
            if vehicle > 0 then
                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                local p = promise.new()
                TriggerEvent("esx:hasKeys", plate, function(has) print("Entro") promise:resolve(has) end)
                local hasKeys = Citizen.Await(p)
                if hasKeys then
                    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    vehicleLabel = GetLabelText(vehicleLabel)
                    if ESX.GetPlayerData().job.name ~= 'police' then
                        LlamadaPolicia('Robo de '..vehicleLabel..' con matricula '..plate)
                    end
                end
            end
        elseif IsPedShooting(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and not IsPedInMeleeCombat(playerPed)then
            local weapon = GetSelectedPedWeapon(playerPed)
			Wait(3000)

			local wLabel = ESX.GetWeaponLabel(weapon, true)
			if wLabel == nil then
				wLabel = "Arma desconocida"
            end
			if ESX.GetPlayerData().job.name ~= 'police' then
				LlamadaPolicia('Se estan produciendo disparos con '..wLabel)
			end
        end
	end
end)


RegisterCommand("PrepareAndQuitServer", function()
    ExecuteCommand("saveall")
    ExecuteCommand("addonaccountsOff")
    ExecuteCommand("addonDataStoreOff")
    ExecuteCommand("vehicleshopoff")
    ExecuteCommand("addoninventoriesOff")
    --ExecuteCommand("pv-save-to-file")
    ExecuteCommand("forceSaveServerData")
    
    --Citizen.Wait(120000)
    --ExecuteCommand("quit")
end)
local closeConnections = false
Citizen.CreateThread(function() 
    local resetHours= {8, 16, 20, 4}
    while true do
        Wait(15000)
        local hour = os.date("%H")
        local min = os.date("%M")
        for k,v in pairs(resetHours) do
            if (v - hour) == 1 then
                if (55 - min) <= 0 then
                    print("Guardando datos del servidor")
                    ExecuteCommand("prepararkicks 30")
                    closeConnections = true
                    Wait(60000)
                    ExecuteCommand("PrepareAndQuitServer")
                end
            end
        end
    end
end)


AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    if closeConnections then
        deferrals.done("El servidor se está reiniciando, vuelve a intentarlo más tarde")
    end
end)
--deferrals.done(`Discord no detectado. Asegurate de que Discord está instalado y abierto. Si necesitas ayuda puedes ir a este link - docs.faxes.zone/docs/debugging-discord`)
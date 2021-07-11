ESX = nil
local mostrar = false
local dias = -1

RegisterNetEvent('updateDias')
AddEventHandler('updateDias', function(days)
    dias = days
end)

RegisterNetEvent('updateMostrar')
AddEventHandler('updateMostrar', function(show)
    mostrar = show
end)

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(270000)
            if dias ~= -1 then
                break
            end
            ESX.TriggerServerCallback('getPlayerHistoryStatus', function(info) end)
        end
end)

Citizen.CreateThread(
    function()
        while true do
        Citizen.Wait(300000)
        if mostrar and dias ~= -1 then
            SendNUIMessage(
                {
                    action = "display",
                    type = "normal",
                    historyTimeout = 3 - dias 
                }
            )
            break
        end
    end
end)
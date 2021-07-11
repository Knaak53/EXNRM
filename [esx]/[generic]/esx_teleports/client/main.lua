ESX                           = nil

local PlayerData              = {}
local haveToWait = false

Citizen.CreateThread(function ()
    while ESX == nil do
        ESX = exports.extendedmode:getSharedObject()
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    LoadMarkers()
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function LoadMarkers()
    Citizen.CreateThread(function()
    
        while true do
            Citizen.Wait(5)
            local found = false
            local plyCoords = GetEntityCoords(PlayerPedId())
            for location, val in pairs(Config.Teleporters) do
                local Enter = val['Enter']
                local Exit = val['Exit']
                local JobNeeded = val['Job']
                local dstCheckEnter, dstCheckExit = GetDistanceBetweenCoords(plyCoords, Enter['x'], Enter['y'], Enter['z'], true), GetDistanceBetweenCoords(plyCoords, Exit['x'], Exit['y'], Exit['z'], true)
                if dstCheckEnter <= 15 then
                    found = true
                    if JobNeeded ~= 'none' then
                        if PlayerData.job.name == JobNeeded then
                            DrawM(Enter['Information'], 3, Enter['x'], Enter['y'], Enter['z'])
                            if dstCheckEnter <= 1.2 then
                                if IsControlJustPressed(0, 38) then
                                    Teleport(val, 'enter')     
                                end
                            end
                        end
                    else
                        DrawM(Enter['Information'], 3, Enter['x'], Enter['y'], Enter['z'])
                        if dstCheckEnter <= 1.2 then
                            if IsControlJustPressed(0, 38) then
                                Teleport(val, 'enter') 
                            end
                        end
                    end
                end
                if dstCheckExit <= 15 then
                    found = true
                    if JobNeeded ~= 'none' then
                        if PlayerData.job.name == JobNeeded then
                            DrawM(Exit['Information'], 3, Exit['x'], Exit['y'], Exit['z'])
                            if dstCheckExit <= 1.2 then
                                if IsControlJustPressed(0, 38) then
                                    Teleport(val, 'exit')
                                end
                            end
                        end
                    else
                        DrawM(Exit['Information'], 3, Exit['x'], Exit['y'], Exit['z'])
                        if dstCheckExit <= 1.2 then
                            if IsControlJustPressed(0, 38) then
                                Teleport(val, 'exit')
                            end
                        end
                    end
                end
            end
            if not found then
                Citizen.Wait(1000)
            end
        end
    end)
end

function Teleport(table, location)
    if location == 'enter' then
        DoScreenFadeOut(100)
        Citizen.Wait(750)
        ESX.Game.Teleport(PlayerPedId(), table['Exit'])
        Citizen.Wait(750)
        DoScreenFadeIn(100)
    else
        DoScreenFadeOut(100)
        Citizen.Wait(750)
        ESX.Game.Teleport(PlayerPedId(), table['Enter'])
        Citizen.Wait(750)
        DoScreenFadeIn(100)
    end
end


function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 0, 255, 100, false, true, 2, false, false, false, false)
end

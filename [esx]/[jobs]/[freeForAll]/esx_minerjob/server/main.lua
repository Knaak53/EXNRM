ESX               = nil
ESX = exports.extendedmode:getSharedObject()

RegisterNetEvent("esx_miner:givestone")
AddEventHandler("esx_miner:givestone", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('stones').count < 40 then
                xPlayer.addInventoryItem('stones', 5)
                TriggerClientEvent('esx:showNotification', source, 'Has recibido ~g~x5 PIEDRA')
            end
        end
    end)

    
RegisterNetEvent("esx_miner:washing")
AddEventHandler("esx_miner:washing", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('stones').count > 9 then
                TriggerClientEvent("esx_miner:washing", source)
                Citizen.Wait(15900)
                xPlayer.addInventoryItem('washedstones', 10)
                xPlayer.removeInventoryItem("stones", 10)
            elseif xPlayer.getInventoryItem('stones').count < 10 then
                TriggerClientEvent('esx:showNotification', source, 'No tienes suficienstes ~b~PIEDRAS.')
            end
        end
    end)

RegisterServerEvent("esx_miner:returnRumpo")
AddEventHandler("esx_miner:returnRumpo", function(vehId) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "miner" and #(xPlayer.getCoords(true) - Config.npc[1].coords) < 30 then
        if vehId then
            local veh = NetworkGetEntityFromNetworkId(vehId)
            if DoesEntityExist(veh) then
                local owner = Entity(veh).state.owner
                local plateOwner = isOwningOptionalVehicle(xPlayer)
                if owner and  owner == xPlayer.getIdentifier() then
                    xPlayer.addMoney(fianzaPerPart)
                    DeleteEntity(veh)
                    xPlayer.showNotification('Se te ha devuelto la fianza del vehiculo')
                elseif plateOwner then
                    local xVehicle = ESX.GetVehicleByPlate(plateOwner)
                    xVehicle.deSpawn()
                    xPlayer.showNotification('Tu camión ha sido guardado')
                else
                    xPlayer.showNotification("No puedes devolver este vehículo")
                end
            end
        end
    end
end)
RegisterServerEvent("esx_miner:getRumpo")
AddEventHandler("esx_miner:getRumpo", function() 
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "miner" and #(xPlayer.getCoords(true) - Config.vehicleSpawn.coords) < 30 then
        Citizen.CreateThread(function() 
            local owningOptional = isOwningOptionalVehicle(xPlayer, "rumpo3")
            print(owningOptional, Config.vehicleSpawn.coords)
            if owningOptional then
                local optVeh = ESX.GetVehicleByPlate(owningOptional)
                optVeh.setCoords(Config.vehicleSpawn.coords)
                print(optVeh.getCoords())
                if not optVeh.isSpawned() then
                    optVeh.spawnVehicle()
                end
                xPlayer.showNotification('Has solicitado tu propio vehiculo para el transporte.')
            else
                xPlayer.showNotification('~r~No tienes ese vehiculo!')
            end
        end)
    end
end)

function isOwningOptionalVehicle(xPlayer, model)
    local vehicles = xPlayer.get("vehicles")
    local owningVehicle = false
    for k,v in pairs(vehicles) do
        if v.model == model then
            owningVehicle = v.plate
            break
        end
    end
    return owningVehicle
end

RegisterNetEvent("esx_miner:remelting")
AddEventHandler("esx_miner:remelting", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    math.randomseed(os.time())
    local randomChance = math.random(1, 100)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('washedstones').count > 9 then
                TriggerClientEvent("esx_miner:remelting", source)
                Citizen.Wait(15900)
                if randomChance < 10 then
                    if xPlayer.canCarryItem("diamond", 1) then
                        xPlayer.addInventoryItem("diamond", 1)
                        xPlayer.removeInventoryItem("washedstones", 10)
                        TriggerClientEvent('esx:showNotification', _source, 'Obtienes ~b~1 DIAMANTE ~w~por 10 piedras dragadas')
                    else
                        TriggerClientEvent('esx:showNotification', _source, 'No tienes suficiente ~r~ESPACIO~w~ en el inventario')
                    end
                    
                elseif randomChance > 9 and randomChance < 25 then
                    if xPlayer.canCarryItem("gold", 5) then
                        xPlayer.addInventoryItem("gold", 5)
                        xPlayer.removeInventoryItem("washedstones", 10)
                        TriggerClientEvent('esx:showNotification', _source, 'Obtienes ~y~5 ORO ~w~por 10 piedras dragadas')
                    else
                        TriggerClientEvent('esx:showNotification', _source, 'No tienes suficiente ~r~ESPACIO~w~ en el inventario')
                    end
                    
                elseif randomChance > 24 and randomChance < 50 then
                    if xPlayer.canCarryItem("iron", 8) then
                        xPlayer.addInventoryItem("iron", 8)
                        xPlayer.removeInventoryItem("washedstones", 10)
                        TriggerClientEvent('esx:showNotification', _source, 'Obtienes ~r~8 HIERRO ~w~por 10 piedras dragadas')
                    else
                        TriggerClientEvent('esx:showNotification', _source, 'No tienes suficiente ~r~ESPACIO~w~ en el inventario')
                    end
                    
                elseif randomChance > 49 then
                    if xPlayer.canCarryItem("copper", 10) then
                        xPlayer.addInventoryItem("copper", 10)
                        xPlayer.removeInventoryItem("washedstones", 10)
                        TriggerClientEvent('esx:showNotification', _source, 'Obtienes ~o~10 COBRE ~w~for 10 piedras dragadas')
                    else
                        TriggerClientEvent('esx:showNotification', _source, 'No tienes suficiente ~r~ESPACIO~w~ en el inventario')
                    end
                    
                end
            elseif xPlayer.getInventoryItem('stones').count < 10 then
                TriggerClientEvent('esx:showNotification', source, 'No tienes ~b~PIEDRAS.')
            end
        end
    end)

RegisterNetEvent("esx_miner:selldiamond")
AddEventHandler("esx_miner:selldiamond", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('diamond').count > 0 then
                local pieniadze = Config.DiamondPrice
                xPlayer.removeInventoryItem('diamond', 1)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('esx:showNotification', source, 'Has vendido ~b~1x DIAMANTE.')
            elseif xPlayer.getInventoryItem('diamond').count < 1 then
                TriggerClientEvent('esx:showNotification', source, 'No tienes ~b~DIAMANTES.')
            end
        end
    end)

RegisterNetEvent("esx_miner:sellgold")
AddEventHandler("esx_miner:sellgold", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('gold').count > 4 then
                local pieniadze = Config.GoldPrice * 5
                xPlayer.removeInventoryItem('gold', 5)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('esx:showNotification', source, 'Has vendido ~y~5x ORO.')
            elseif xPlayer.getInventoryItem('gold').count < 5 then
                TriggerClientEvent('esx:showNotification', source, 'No tienes ~b~ORO')
            end
        end
    end)

RegisterNetEvent("esx_miner:selliron")
AddEventHandler("esx_miner:selliron", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('iron').count > 7 then
                local pieniadze = Config.IronPrice * 8
                xPlayer.removeInventoryItem('iron', 8)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('esx:showNotification', source, 'Has vendido ~w~8x HIERRO.')
            elseif xPlayer.getInventoryItem('iron').count < 8 then
                TriggerClientEvent('esx:showNotification', source, 'No tienes ~b~HIERRO.')
            end
        end
    end)

ESX.RegisterServerCallback("esx_miner:checkJobRequeriments", function(source, cb)
    local _source = source
    cb(exports.esx_joblisting:checkRequeriments("miner", _source))
end)

RegisterNetEvent("esx_miner:sellcopper")
AddEventHandler("esx_miner:sellcopper", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('copper').count > 9 then
                local pieniadze = Config.CopperPrice * 10
                xPlayer.removeInventoryItem('copper', 10)
                xPlayer.addMoney(pieniadze)
                TriggerClientEvent('esx:showNotification', source, 'Has vendido ~o~10x COBRE.')
            elseif xPlayer.getInventoryItem('copper').count < 10 then
                TriggerClientEvent('esx:showNotification', source, 'No tienes ~b~COBRE.')
            end
        end
    end)

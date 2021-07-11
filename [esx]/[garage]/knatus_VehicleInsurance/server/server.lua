ESX = nil
recoverPrice = 500
plusDestroyed = 5000
plusImpounded = 2500
JobsWithVehicles = {
    "police",
    "ambulance",
    "mechanic",
    "taxi"
}

function isRecoverableJob(jobname)
    for k,v in pairs(JobsWithVehicles) do
        if jobname == v then
            return true
        end
    end
    return false
end

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local spawnc = vector3(378.01440429688,-1629.4871826172,28.401882171631)
local spawnh = 318.95568847656

ExM = exports.extendedmode:getExtendedModeObject()


ESX.RegisterServerCallback("vehicleinsurance:getmyvehicles", function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicles = xPlayer.get("vehicles")
    print(json.encode(vehicles))
    local detected = false
    for j,i in pairs(vehicles) do
        local xVehicle = ESX.GetVehicleByPlate(j)
        if xVehicle then
            if xVehicle.isSpawned() then
                vehicles[j].finded = true
                vehicles[j].coords = xVehicle.getCoords()
            end
        end
    end
    TriggerEvent("esx_service:isPlayerInService", function(inService) 
        if inService then
            if isRecoverableJob(xPlayer.getJob().name) and xPlayer.getJob().grade <= 1 then
                local jobvehicles = ESX.GetVehiclesByJob(xPlayer.getJob().name)
                for k,v in pairs(jobvehicles) do
                    if v then
                        if v.isSpawned() then
                            table.insert(vehicles, { 
                                plate = v.plate,
                                model = v.getModel(),
                                finded = true,
                                coords = v.getCoords()
                            })
                        else
                            table.insert(vehicles, { 
                                plate = v.plate,
                                model = v.getModel(),
                            })
                        end
                    end
                end
            end
        end
        if vehicles then
            cb(vehicles)
        else 
            cb({})
        end
    end, xPlayer.getJob().name, xPlayer.source)
    
end)

ESX.RegisterServerCallback('vehicleinsurance:recoverPrice', function(source,cb, plate) 
    local xPlayer = ESX.GetPlayerFromId(source)

    print(json.encode(xPlayer.get("vehicles")[plate]).."-")
    local xVehicle = ESX.GetVehicleByPlate(plate)
    if xPlayer.get("vehicles")[plate] ~= nil then    
        local totalPrice = calculatePrice(plate)
        cb(totalPrice)
    elseif xVehicle.getJob() == "police" then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'ayuntamiento', function(account)
            account.removeMoney(recoverPrice)
        end)
        cb(recoverPrice)
    elseif xVehicle.getJob() == "ambulance" then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'ayuntamiento', function(account)
            account.removeMoney(recoverPrice)
        end)
        cb(recoverPrice)
    elseif xVehicle.getJob() == "mechanic" then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'mechanic', function(account)
            account.removeMoney(recoverPrice)
        end)
        cb(recoverPrice)
    elseif xVehicle.getJob() == "taxi" then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'taxi', function(account)
            account.removeMoney(recoverPrice)
        end)
        cb(recoverPrice)
    end
end)



ESX.RegisterServerCallback("vehicleinsurance:recoverVehicle", function(source,cb, plate) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local xVehicle = ESX.GetVehicleByPlate(plate)
    print(json.encode(xPlayer.get("vehicles")[plate]).."-")
    if (xPlayer.get("vehicles")[plate] ~= nil) or (xVehicle.getJob()== xPlayer.getJob().name and xPlayer.getJob().grade <= 1) then
        TriggerEvent("persistent-vehicles/server/forget-vehicle", plate)
        local vehicles = GetAllVehicles()
        local detected = false
        
        if xVehicle.isSpawned() then --Está en la calle
            detected = true
        end
            --Si es vehiculo de trabajo
            if isRecoverableJob(xVehicle.getJob()) then
                if xVehicle.isInPermissiveState() then
                    exports.esx_society:getSocietyAccount(xVehicle.getJob(), function(account) 
                        if account.getMoney() > recoverPrice then
                            account.removeMoney(100)
                            Citizen.CreateThread(function() 
                                xVehicle.setCoords(vector3(spawnc.x,spawnc.y,spawnc.z))
                                --xVehicle.spawnVehicle()
                                if not xVehicle.isSpawned() then
                                    xVehicle.spawnVehicle()
                                end
                                
                                xVehicle.setHeading(spawnh)
                            end)
                            cb(true)  
                        else
                            cb(false)
                        end
                    end)   
                else
                    xPlayer.showNotification('Tu vehiculo no puede ser traido aquí')
                    xPlayer.showNotification('Estado: '..xVehicle.getState())
                end
            else--Si es vehiculo particular
                local totalPrice = calculatePrice(plate)
                if xVehicle.isInPermissiveState() then
                    if xPlayer.getMoney() >= totalPrice then
                        Citizen.CreateThread(function() 
                            local _source = source
                        
                            xVehicle.setCoords(vector3(spawnc.x,spawnc.y,spawnc.z))
                            if not xVehicle.isSpawned() then
                                xVehicle.spawnVehicle()
                            end
                            xVehicle.setHeading(spawnh)
                        end)
                        xPlayer.removeMoney(totalPrice)
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    xPlayer.showNotification('Tu vehiculo no puede ser traido aquí')
                    xPlayer.showNotification('Estado: '..xVehicle.getState())
                end
            end
    else
        xPlayer.showNotification('No tienes ningun vehiculo')
    end
end)



function calculatePrice(plate)
    local xVehicle = ESX.GetVehicleByPlate(plate)
    local totalPrice = 500
    local props = xVehicle.getVehicleProperties()
    if props.modArmor and props.modArmor > 0 then
        totalPrice = totalPrice + (props.modArmor * 500)
    end
    if props.modTurbo and props.modTurbo > 0 then
        totalPrice = totalPrice + (props.modTurbo * 300)
    end
    if props.modEngine and props.modEngine > 0  then
        totalPrice = totalPrice + (props.modEngine * 500)
    end
    if props.modTransmission and props.modTransmission > 0  then
        totalPrice = totalPrice + (props.modTransmission * 500)
    end
    if props.modXenon and props.modXenon > 0  then
        totalPrice = totalPrice + (props.modXenon * 500)
    end
    if props.modSuspension and props.modSuspension > 0  then
        totalPrice = totalPrice + (props.modSuspension * 500)
    end
    if xVehicle.getState == ESX.VehiclesStates.restrictions.DESTROYED then
        totalPrice = totalPrice + plusDestroyed
    elseif xVehicle.getState == ESX.VehiclesStates.restrictions.IMPOUNDED then
        totalPrice = totalPrice + plusImpounded
    end
    return totalPrice
end
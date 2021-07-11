RegisterServerEvent('enc0ded-forklift-trailer/owner-event')
AddEventHandler('enc0ded-forklift-trailer/owner-event', function (event, netId, ...)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local owner = NetworkGetEntityOwner(entity)
    TriggerClientEvent('enc0ded-forklift-trailer/owner-event', owner, event, netId, ...)
end)

-- server export functions
function GetProductConfigOfIndex(index)
    return Config.productTypes[index]
end

function GetRandomProductOfCategory(kind)
    if not tonumber(kind) then
        local thisKind = {}
        for i = 1, #Config.productTypes do
            if kind == Config.productTypes[i].category  then
                thisKind[#thisKind+1] = i
            end
        end
        if #thisKind > 0 then
            math.randomseed(GetGameTimer())
            return thisKind[math.random(1, #thisKind)]
        end
    end
    return tonumber(kind) or 1
end

-- DEV: spawn all pallets for player server id at airport
--[[ 
Citizen.CreateThread(function() 
    Wait(2000)
    local playerServerId = 1
    TriggerClientEvent('enc0ded-forklift-trailer/spawn-all-pallets', playerServerId, '')
end) 
]]

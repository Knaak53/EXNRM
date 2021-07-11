ESX = nil
local vehiclesBeingSearched = {}


TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

--ESX.RegisterServerCallback('esx_trunk:isBeingSearchedTrunk',function(source,cb,plate)
--    cb(vehiclesBeingSearched[plate])
--end)


AddEventHandler('esx_trunk:isBeingSearchedTrunk',function(cb,plate)
    cb(vehiclesBeingSearched[plate])
end)

RegisterServerEvent('esx_trunk:cancelSearching')
AddEventHandler('esx_trunk:cancelSearching', function(plate,source)
    if #vehiclesBeingSearched[plate] == 1 then
        vehiclesBeingSearched[plate] = nil
    else
        for k,v in pairs(vehiclesBeingSearched) do
            if v == source then
                table.remove(vehiclesBeingSearched, k)
            end
        end
    end
end)

RegisterServerEvent('esx_trunk:startSearching')
AddEventHandler('esx_trunk:startSearching', function(plate,source)
    if vehiclesBeingSearched[plate] == nil then
        vehiclesBeingSearched[plate] = {}
    end
    table.insert(vehiclesBeingSearched[plate], source)
end)
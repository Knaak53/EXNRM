ESX.RegisterServerCallback('esx:isVehicleOwnedByPlayer', function(source,cb, plate) 
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.isVehicleOwner(plate))
end)
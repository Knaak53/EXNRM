ESX = nil 
ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent('911:syncalertsSv')
AddEventHandler('911:syncalertsSv',function(alert)
    TriggerClientEvent('911:syncalertsCl',-1,alert)
end)
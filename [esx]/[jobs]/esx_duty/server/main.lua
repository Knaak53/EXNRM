ESX = nil

ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent('duty:onoff')
AddEventHandler('duty:onoff', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.getJob().name
    local grade = xPlayer.getJob().grade
    
    if job == 'police' or job == 'ambulance' or job == 'taxi' or job == 'mechanic' or job == 'cardealer' then
        xPlayer.setJob('off' ..job, grade)
        TriggerClientEvent('esx:showNotification', _source, _U('offduty'))
    elseif job == 'offpolice' then
        xPlayer.setJob('police', grade)
        TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offmechanic' then
        xPlayer.setJob('mechanic', grade)
        TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offtaxi' then
        xPlayer.setJob('taxi', grade)
        TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offambulance' then
        xPlayer.setJob('ambulance', grade)
        TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offcardealer' then
        xPlayer.setJob('cardealer', grade)
        TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    end
end)


RegisterServerEvent("Actions:giveObjectSynced")
AddEventHandler("Actions:giveObjectSynced", function(target, hand) 
    TriggerClientEvent("Actions:GiveObject", source, entityModel, hand)
    TriggerClientEvent("Actions:TakeObject", target, entityModel, hand)
end)

RegisterServerEvent("Actions:SyncedAction")
AddEventHandler("Actions:SyncedAction", function(action,targetAction,entityModel, targetId, hand) 
    local _source = source
    TriggerClientEvent("Actions:"..action, _source, entityModel, hand)
    print(targetId)
    print(entityModel)
    print(hand)
    TriggerClientEvent("Actions:TakeObject", targetId, entityModel, hand)
end)

ESX.RegisterServerCallback('ESX:PlayerCanPay', function(source,cb,quantity)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	cb(xPlayer.getMoney() >= tonumber(quantity))
end)
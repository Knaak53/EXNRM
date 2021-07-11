TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


AddEventHandler("esx:playerLoaded", function(source, xPlayer) 
    local phoneChanged = xPlayer.get("phoneChanged")


    if not phoneChanged then
        xPlayer.set("phone_number", nil)
        xPlayer.set("phone_contacts", nil)
        xPlayer.set("phoneChanged", true)
    end
end)
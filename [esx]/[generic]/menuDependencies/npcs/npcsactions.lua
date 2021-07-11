AddEventHandler("menuDependencies:darDinero", function(isPlayer, entity, quantity) 
    --print("llega??")
    local Entity = entity
    local quantity = quantity
    --print("cantidad ==?? "..quantity )
    if isPlayer then
        

        local oPlayer = GetPlayerFromPed(Entity)
        local oServerId = GetPlayerServerId(oPlayer)
        ESX.Actions.giveObjectSynced("prop_anim_cash_note", oServerId, nil)
        TriggerServerEvent("menuDependencies:darDinero", oServerId, quantity)
    else
        --print("cantidad ==?? 22 "..quantity )
        ESX.Actions.giveObject(false, false, "prop_anim_cash_note")
        ESX.Streaming.RequestAnimDict("amb@world_human_cheering@male_a")
        TaskPlayAnim(Entity, "amb@world_human_cheering@male_a", "base", 8.0, -8, -1, 12, 1, 0, 0, 0)
        --print("cantidad ==?? 33"..quantity )
        TriggerServerEvent("menuDependencies:darDinero", false, quantity)
        --TaskPlayAnim(Entity,"amb@world_human_cheering@male_a", "base", 8.0, -8.0, data.quantity * 100, 0, 0.0, 0, 0, 0)
    end
end)

function GetPlayerFromPed(ped)
    for _,player in pairs(GetActivePlayers()) do
        if GetPlayerPed(player) == ped then
            return player
        end
    end
    return -1
end
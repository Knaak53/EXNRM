ESX.RegisterUsableItem("smg_clip", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local weapons = ESX.GetWeaponsByAmmo("AMMO_SMG")
    local haveWeapon = false
    for k,v in pairs(weapons) do
        if xPlayer.hasWeapon(v) then
            haveWeapon = v
        end
    end

    if haveWeapon then
        xPlayer.addWeaponAmmo(haveWeapon, 50)
        xPlayer.removeInventoryItem("smg_clip", 1)
    else        
        xPlayer.showNotification("No tienes ningún arma para este tipo de munición",true,true,70)
    end
end)

ESX.RegisterUsableItem("pistol_clip", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local weapons = ESX.GetWeaponsByAmmo("AMMO_PISTOL")
    local haveWeapon = false
    for k,v in pairs(weapons) do
        if xPlayer.hasWeapon(v) then
            haveWeapon = v
        end
    end

    if haveWeapon then
        xPlayer.addWeaponAmmo(haveWeapon, 50)
        xPlayer.removeInventoryItem("pistol_clip", 1)
    else        
        xPlayer.showNotification("No tienes ningún arma para este tipo de munición",true,true,70)
    end
end)

ESX.RegisterUsableItem("shotgun_clip", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local weapons = ESX.GetWeaponsByAmmo("AMMO_SHOTGUN")
    local haveWeapon = false
    for k,v in pairs(weapons) do
        if xPlayer.hasWeapon(v) then
            haveWeapon = v
        end
    end

    if haveWeapon then
        xPlayer.addWeaponAmmo(haveWeapon, 50)
        xPlayer.removeInventoryItem("shotgun_clip", 1)
    else        
        xPlayer.showNotification("No tienes ningún arma para este tipo de munición",true,true,70)
    end
end)

ESX.RegisterUsableItem("rifle_clip", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local weapons = ESX.GetWeaponsByAmmo("AMMO_RIFLE")
    local haveWeapon = false
    for k,v in pairs(weapons) do
        if xPlayer.hasWeapon(v) then
            haveWeapon = v
        end
    end

    if haveWeapon then
        xPlayer.addWeaponAmmo(haveWeapon, 50)
        xPlayer.removeInventoryItem("rifle_clip", 1)
    else        
        xPlayer.showNotification("No tienes ningún arma para este tipo de munición",true,true,70)
    end
end)


ESX.RegisterUsableItem("mg_clip", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local weapons = ESX.GetWeaponsByAmmo("AMMO_MG")
    local haveWeapon = false
    for k,v in pairs(weapons) do
        if xPlayer.hasWeapon(v) then
            haveWeapon = v
        end
    end

    if haveWeapon then
        xPlayer.addWeaponAmmo(haveWeapon, 50)
        xPlayer.removeInventoryItem("mg_clip", 1)
    else        
        xPlayer.showNotification("No tienes ningún arma para este tipo de munición",true,true,70)
    end
end)

ESX.RegisterUsableItem("sniper_clip", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local weapons = ESX.GetWeaponsByAmmo("AMMO_SNIPER")
    local haveWeapon = false
    for k,v in pairs(weapons) do
        if xPlayer.hasWeapon(v) then
            haveWeapon = v
        end
    end

    if haveWeapon then
        xPlayer.addWeaponAmmo(haveWeapon, 50)
        xPlayer.removeInventoryItem("sniper_clip", 1)
    else        
        xPlayer.showNotification("No tienes ningún arma para este tipo de munición",true,true,70)
    end
end)

ESX.RegisterUsableItem("meth", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and not xPlayer.get("isCutting") then
        local ran = math.random(4,6)
        local ran2 = math.random(1,100)
        if xPlayer.getInventoryItem('bolsita').count >= ran then
            xPlayer.set("isCutting", true)
            xPlayer.removeInventoryItem('meth', 1)
            Citizen.CreateThread(function() 
                local _ran = ran
                local _ran2 = ran2
                Wait(5000)
                if ran2 >= 50 then
                    xPlayer.addInventoryItem('lsd', 1)
                end
                xPlayer.set("isCutting", false)
                xPlayer.addInventoryItem('meth_pouch', _ran)
                xPlayer.removeInventoryItem('bolsita',_ran)
            end)
        else
            xPlayer.showNotification("Necesitas más bolsitas de plástico", true, true, 6)
        end
    end
end)

ESX.RegisterUsableItem("coke", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and not xPlayer.get("isCutting") then
        local ran = math.random(4,6)
        local ran2 = math.random(1,100)
        if xPlayer.getInventoryItem('bolsita').count >= ran then
            xPlayer.set("isCutting", true)
            xPlayer.removeInventoryItem('coke', 1)
            Citizen.CreateThread(function() 
                local _ran = ran
                local _ran2 = ran2
                Wait(5000)
                if ran2 >= 50 then
                    xPlayer.addInventoryItem('lsd', 1)
                end
                xPlayer.set("isCutting", false)
                xPlayer.addInventoryItem('coke_pouch', _ran)
                xPlayer.removeInventoryItem('bolsita',_ran)
            end)
        else
            xPlayer.showNotification("Necesitas más bolsitas de plástico", true, true, 6)
        end
    end
end)

ESX.RegisterUsableItem("weed", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and not xPlayer.get("isCutting") then
        local ran = math.random(4,6)
        if xPlayer.getInventoryItem('bolsita').count >= ran then
            xPlayer.set("isCutting", true)
            xPlayer.removeInventoryItem('weed', 1)
            Citizen.CreateThread(function() 
                local _ran = ran
                Wait(5000)
                xPlayer.set("isCutting", false)
                xPlayer.addInventoryItem('weed_pouch', _ran)
                xPlayer.removeInventoryItem('bolsita',_ran)
            end)
        else
            xPlayer.showNotification("Necesitas más bolsitas de plástico", true, true, 6)
        end
    end
end)

ESX.RegisterUsableItem("weed_pouch", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and not xPlayer.get("isCutting") then
        local ran = math.random(2,5)
        if xPlayer.getInventoryItem('papers').count >= 1 then
            xPlayer.set("isCutting", true)
            xPlayer.removeInventoryItem('weed_pouch', 1)
            Citizen.CreateThread(function() 
                local _ran = ran
                Wait(5000)
                xPlayer.set("isCutting", false)
                xPlayer.addInventoryItem('joint', _ran)
                xPlayer.removeInventoryItem('papers',1)
            end)
        else
            xPlayer.showNotification("Necesitas papelillos de liar", true, true, 6)
        end
    end
end)

ESX.RegisterUsableItem("lsd", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('lsd',1)
    TriggerClientEvent("acidtrip:init", source, 20000)
    TriggerClientEvent('esx_status:set', source, "stress", 1)
end)

ESX.RegisterUsableItem("joint", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('joint',1)
    TriggerClientEvent('kypo-drug-effect:onWeed', source)
end)

ESX.RegisterUsableItem('bulletproof', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerPed = GetPlayerPed(source)
    if xPlayer then
        if GetPedArmour(playerPed) <= 0 then
            if xPlayer.getInventoryItem('bulletproof').count > 0 then
                xPlayer.removeInventoryItem('bulletproof',1)
                xPlayer.set('armour',100)
                TriggerClientEvent('s2v_bulletproofput',source,100)
            else
                xPlayer.showNotification("No tienes chalecos antibalas", true, true, 6)
            end
        else
            xPlayer.showNotification("Ya llevas puesto un chaleco antibalas", true, true, 6)
        end
    end
end)
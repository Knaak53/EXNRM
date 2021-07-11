ESX = nil 
local canTakeFreeWater = true
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end)

RegisterNetEvent('esx_vending:useMachine')
AddEventHandler('esx_vending:useMachine', function(machine, imgName, entity)
    Citizen.Wait(150)
    local playerPed = PlayerPedId()
 
    if machine == 'gum' then
    	 RequestAnimDict('mp_common')
	    while not HasAnimDictLoaded('mp_common') do Citizen.Wait(0) end
	    TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 1.0, -1.0, 2000, 49, 1, false, false, false)
	    Citizen.Wait(2000)
	    RemoveAnimDict('mp_common')
    	local randomGum = Config.products[machine][math.random(1, #Config.products[machine])]
    	TriggerServerEvent("esx_vending:buyProduct", randomGum)
    elseif machine == 'water' then
    	TriggerServerEvent("esx_vending:buyProduct", {label = "Agua", name = "water", price = 7})
    elseif machine == 'water_free' then
    	if canTakeFreeWater then
    		ClearPedTasksImmediately(playerPed)
    		TriggerServerEvent("esx_vending:freeWater")
    		startFreeWaterTimer()
    		local paper_cup_hash = 1151364435
    		local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)
			local umbspawned = CreateObject(paper_cup_hash, plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
			local netid = ObjToNet(umbspawned)
    		RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a')
		    while not HasAnimDictLoaded('amb@world_human_drinking@coffee@male@idle_a') do Citizen.Wait(0) end
		    TaskPlayAnim(playerPed, "amb@world_human_drinking@coffee@male@idle_a", "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
		    while not HasModelLoaded(paper_cup_hash) do Citizen.Wait(50) end
		    AttachEntityToEntity(umbspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),0.0,0.0,0.0,0.0,0.0,0.0,1,1,0,1,0,1)

		    Citizen.Wait(11000)
		    ClearPedSecondaryTask(playerPed)
			DetachEntity(NetToObj(netid), 1, 1)
			DeleteEntity(NetToObj(netid))	    
			DeleteEntity(umbspawned)
    	else
    		ESX.ShowNotification('Debes esperar un rato para poder volver a usar la fuente.')
    	end  	
    else
    	RequestAnimDict('mp_common')
	    while not HasAnimDictLoaded('mp_common') do Citizen.Wait(0) end
	    TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 1.0, -1.0, 2000, 49, 1, false, false, false)
	    Citizen.Wait(2000)
	    RemoveAnimDict('mp_common')
    	local products = Config.products[machine]
	     SendNUIMessage(
	        {
	            action = "open",
	            shopItems = products,
	            imgName = imgName
	        }
	    )
	    SetNuiFocus(true, true)
    end 
end)

function startFreeWaterTimer()
	Citizen.CreateThread(function()
		canTakeFreeWater = false
		Citizen.Wait(1100000)
		canTakeFreeWater = true
	end)

end

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("buyProduct", function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent("esx_vending:buyProduct", data.product) 
end)
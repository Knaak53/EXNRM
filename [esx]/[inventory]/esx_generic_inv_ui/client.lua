ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_generic_inv_ui:openSociety')
AddEventHandler('esx_generic_inv_ui:openSociety', function(societyName, societyLabel)
	ESX.TriggerServerCallback('esx_generic_inv_ui:getPlayerInv', function(inventory)
      ESX.TriggerServerCallback('esx_generic_inv_ui:getSocietyInv', function(inv)
          SendNUIMessage(
            {
              action = "open",
              inventory = inventory,
              container = inv,
              containerCapacity = 200,
              playerCapacity = inventory.weight,
              playerCurrentWeight = inventory.currentWeight,
              type = "society",
              name = societyName,
              label = societyLabel,
              onlyTake = false
            }
          )
          SetNuiFocus(true, true)
      end, societyName)
    end) 
end)

RegisterNetEvent('esx_generic_inv_ui:openPlayer')
AddEventHandler('esx_generic_inv_ui:openPlayer', function(playerSource)
  ESX.TriggerServerCallback('esx_generic_inv_ui:getPlayerInv', function(inventory)
    ESX.TriggerServerCallback('esx_generic_inv_ui:getOtherPlayerInv', function(otherplayer)
        SendNUIMessage(
          {
            action = "open",
            inventory = inventory,
            container = otherplayer,
            containerCapacity = otherplayer.weight,
            playerCapacity = inventory.weight,
            playerCurrentWeight = inventory.currentWeight,
            type = "player",
            name = playerSource,
            label = otherplayer.playerName,
            onlyTake = true
          }
        )
        SetNuiFocus(true, true)
    end, playerSource)
  end)
end)

RegisterNetEvent('esx_generic_inv_ui:openTrunk')
AddEventHandler('esx_generic_inv_ui:openTrunk', function(plate, vehicleLimit, vehId)
	ESX.TriggerServerCallback('esx_generic_inv_ui:getPlayerInvComplete', function(inventory)
      ESX.TriggerServerCallback('esx_generic_inv_ui:getTrunkInv', function(trunk)
        if trunk then
          SendNUIMessage(
            {
              action = "open",
              inventory = inventory,
              container = trunk,
              containerCapacity = vehicleLimit,
              playerCapacity = inventory.weight,
              playerCurrentWeight = inventory.currentWeight,
   			      type = "trunk",
              name = plate,
              label = 'Maletero',
              onlyTake = false,
            }
          )
          SetNuiFocus(true, true) 
        else
           ESX.ShowNotification('~r~El maletero está cerrado!')
        end
      end, plate, vehId)
    end) 
end)

RegisterNetEvent('esx_generic_inv_ui:updateData')
AddEventHandler('esx_generic_inv_ui:updateData', function(container, inventory)
  SendNUIMessage(
    {
      container = container,
      inventory = inventory,
      action = "update"
    }
  )
end)

RegisterNetEvent('esx_generic_inv_ui:openHouse')
AddEventHandler('esx_generic_inv_ui:openHouse', function()
  ESX.TriggerServerCallback('esx_generic_inv_ui:getPlayerInvComplete', function(inventory)
      ESX.TriggerServerCallback('esx_generic_inv_ui:getHouseInv', function(house)
        SendNUIMessage(
          {
            action = "open",
            inventory = inventory,
            container = house,
            containerCapacity = house.maxWeight,
            playerCapacity = inventory.weight,
            playerCurrentWeight = inventory.currentWeight,
            type = "house",
            name = "house",
            label = 'Armario de casa',
            onlyTake = false
          }
        )
        SetNuiFocus(true, true)
      end)
    end) 
end)

RegisterNetEvent('esx_generic_inv_ui:openTrash')
AddEventHandler('esx_generic_inv_ui:openTrash', function(containerId, foundItems)
  ESX.TriggerServerCallback('esx_generic_inv_ui:getPlayerInv', function(inventory)
        SendNUIMessage(
          {
            action = "open",
            inventory = inventory,
            container = foundItems,
            containerCapacity = 10,
            playerCapacity = inventory.weight,
            playerCurrentWeight = inventory.currentWeight,
            type = "trash",
            name = containerId,
            label = 'Basura',
            onlyTake = true
          }
        )
        SetNuiFocus(true, true)
    end) 
end)

RegisterNUICallback("exit", function(data, cb)
  if data.type ~= "trash" then
      TriggerServerEvent("esx_generic_inv_ui:cancelSearching", data.name, data.type)
  end
  SetNuiFocus(false, false) 
end)

RegisterNUICallback("confirm", function(data, cb)
    if #data.inventoryAdds > 0 or #data.inventoryRemoves > 0 then
    	if data.type == 'society' then
    		TriggerServerEvent('esx_generic_inv_ui:updateSociety', data.name, data.currentData, data.inventoryAdds, data.inventoryRemoves)		
    	end
    	if data.type == 'trunk' then
    		TriggerServerEvent('esx_generic_inv_ui:updateTrunk', data.name, data.currentData, data.inventoryAdds, data.inventoryRemoves)
    	end
  		if data.type == 'house'then
  		  TriggerServerEvent('esx_generic_inv_ui:updateHouse', data.currentData, data.inventoryAdds, data.inventoryRemoves)
  		end
      if data.type == 'player'then
        if #data.inventoryAdds > 0 then
            TriggerServerEvent('esx_policejob:confiscatePlayerItem', data.name, data.inventoryAdds[1].type, data.inventoryAdds[1].name, data.inventoryAdds[1].amount)
        end
      end
  		if data.type == 'trash'then
  		  TriggerServerEvent('esx_generic_inv_ui:takeTrash', data.inventoryAdds)
        TriggerEvent('esx_trash:updateTrash', data.name, data.currentData)
  		end
    end  
end)
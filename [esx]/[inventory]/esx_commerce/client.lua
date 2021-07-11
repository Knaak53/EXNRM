ESX = nil

Citizen.CreateThread(function()
 while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_commerce:interchange')
AddEventHandler('esx_commerce:interchange', function(entity)
  local closestPlayer = ESX.Game.GetPlayerServerIdFromPlayerEntity(entity)
  if not closestPlayer then
      ESX.ShowNotification("~r~No hay nadie cerca con quien comerciar!")
      return
  else
    local targetSrc = closestPlayer
    if targetSrc ~= -1 then
      TriggerServerEvent("esx_commerce:invite_commerce", targetSrc)
    else
      ESX.ShowNotification("~r~No hay nadie cerca con quien comerciar!")
      return
    end
  end
end)

RegisterNetEvent("esx_commerce:get_invited_to_commerce")
AddEventHandler('esx_commerce:get_invited_to_commerce', function(invitation_sender_src, sender_name)
    SendNUIMessage(
      {
        action = "get_invited",
        sender_name = sender_name,
        sender_src = invitation_sender_src
      }
    )
    SetNuiFocus(true, true)
end)

RegisterNetEvent("esx_commerce:decline_invite_client")
AddEventHandler("esx_commerce:decline_invite_client", function()
    ESX.ShowNotification("~r~Tu invitacion a comerciar ha sido rechazada")
end)

RegisterNetEvent("esx_commerce:refreshPlayerOffer_client")
AddEventHandler("esx_commerce:refreshPlayerOffer_client", function(targetOffer)
    SendNUIMessage(
      {
        action = "updateTargetOffer",
        targetOffer = targetOffer
      }
    )
end)

RegisterNetEvent("esx_commerce:targetDecline")
AddEventHandler("esx_commerce:targetDecline", function()
    SendNUIMessage(
      {
        action = "updateTargetOffer",
        targetOffer = targetOffer
      }
    )
end)

RegisterNetEvent("esx_commerce:targetAccept")
AddEventHandler("esx_commerce:targetAccept", function()
    SendNUIMessage(
      {
        action = "updateTargetOffer",
        targetOffer = targetOffer
      }
    )
end)

RegisterNetEvent("esx_commerce:startCommerce_client")
AddEventHandler("esx_commerce:startCommerce_client", function(invitedSrc)
  startCommerce(invitedSrc)
  SetNuiFocus(true, true)
end)

RegisterNetEvent("esx_commerce:cancelCommerce_client")
AddEventHandler("esx_commerce:cancelCommerce_client", function()
  SendNUIMessage(
      {
        action = "cancelCommerce"
      }
    )
end)

RegisterNUICallback("accept_invite", function(data, cb)
  TriggerServerEvent("esx_commerce:startCommerce", data.sender_src)
  startCommerce(data.sender_src)
  SetNuiFocus(true, true)
end)

RegisterNUICallback("exit", function(data, cb)
  SetNuiFocus(false, false)
end)

RegisterNUICallback("cancelCommerce", function(data, cb)
  TriggerServerEvent("esx_commerce:cancelCommerce", data.targetSrc)
  SetNuiFocus(false, false)
end)

RegisterNUICallback("playerdecline", function(data, cb)
  TriggerServerEvent("esx_commerce:playerDecline", data.targetSrc)
end)

RegisterNUICallback("playeraccept", function(data, cb)
  TriggerServerEvent("esx_commerce:playerAccept", data.targetSrc)
end)


RegisterNUICallback("refreshPlayerOffer", function(data, cb)
  TriggerServerEvent("esx_commerce:refreshPlayerOffer", data.targetSrc, data.playerOffer)
end)

RegisterCommand('commerce', function(source, args)
   SetNuiFocus(true, true)
   startCommerce()
end, false)

function startCommerce(src)
  ESX.TriggerServerCallback('esx_commerce:getPlayerInvComplete', function(inventory)
    print(inventory.targetMaxWeight, inventory.targetCurrentWeight)
       SendNUIMessage(
            {
              action = "startCommerce",
              inventory = inventory,
              targetMaxWeight = inventory.targetMaxWeight,
              targetCurrentWeight = inventory.targetCurrentWeight,
              playerMaxWeight = inventory.playerMaxWeight,
              playerCurrentWeight = inventory.playerCurrentWeight,
              targetName = inventory.targetName,
              playerMoney = inventory.playerMoney,
              playerName = inventory.playerName,
              targetWeaponCount = inventory.targetWeaponCount,
              targetSrc = src
            }
          )
    end, src) 
end

RegisterNUICallback("decline_invite", function(data, cb)
    SetNuiFocus(false, false) 
    TriggerServerEvent("esx_commerce:decline_invite_server", data.sender_src)
end)
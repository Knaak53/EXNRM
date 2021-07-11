ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('generic_shop_creator:createShop')
AddEventHandler('generic_shop_creator:createShop', function(items, title)
	ESX.TriggerServerCallback('generic_shop_creator:getPlayerMoney', function(money)
		SendNUIMessage(
	        {
				action = "open",
				items = items,
				title = title,
				playerMoney = money
	        }
		)
		SetNuiFocus(true, true)
	end)
end)

RegisterNetEvent('generic_shop_creator:updatePrice')
AddEventHandler('generic_shop_creator:updatePrice', function(moneySpent)
	SendNUIMessage(
        {
			action = "updateMoney",
			playerMoney = moneySpent
        }
	)
	SetNuiFocus(true, true)
end)

RegisterNUICallback("buyProduct", function(data, cb)
	TriggerServerEvent("generic_shop_creator:buyItem", data.product, data.amount)
end)

RegisterNUICallback("exit", function(data, cb)
	SetNuiFocus(false, false)
end)
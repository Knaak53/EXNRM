--[[ESX = nil
local isDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

function ShowBillsMenu()
	ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
		if #bills > 0 then
			ESX.UI.Menu.CloseAll()
			local elements = {}

			print("entrando")
			for k,v in pairs(bills) do
				table.insert(elements, {
					label  = ('%s - <span style="color:red;">%s</span>'):format(v.label, _U('invoices_item', ESX.Math.GroupDigits(v.amount))),
					billId = k
				})
			end
			print("insertados")

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
				title    = _U('invoices'),
				align    = 'top-right',
				elements = elements
			}, function(data, menu)
				menu.close()
				print("whut?")
				ESX.TriggerServerCallback('esx_billing:payBill', function()
					ShowBillsMenu()
				end, data.current.billId)
			end, function(data, menu)
				menu.close()
			end)
		else
			ESX.ShowNotification(_U('no_invoices'))
		end
	end)
end

RegisterCommand('showbills', function()
	if not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'billing') then
		ShowBillsMenu()
	end
end, false)

RegisterKeyMapping('showbills', _U('keymap_showbills'), 'keyboard', 'F7')

AddEventHandler('esx:onPlayerDeath', function() isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)]]
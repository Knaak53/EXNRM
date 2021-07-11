ESX = nil
Billings = {}
ESX = exports.extendedmode:getSharedObject()

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount, mugshot)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)

	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if xTarget.get("bills") == nil then
				xTarget.set("bills", {})			
			end
			local btarget, target_t
			if account then
				btarget, target_t = sharedAccountName, 'society'
			else
				btarget, target_t = xPlayer.identifier, 'player'
			end
			local bill = {
				identifier = xTarget.identifier,
				sender = xPlayer.identifier,
				target_type = target_t,
				target = btarget,
				label = label,
				amount = amount
			}
			local bills = xTarget.get("bills")
			table.insert(bills, bill)
			xTarget.set("bills",bills)
			xTarget.showNotification("Ha recibido una nueva factura",true,true,40)
		end)
	end
end)


ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get("bills") == nil then
		cb({})
	else
		cb(xPlayer.get("bills"))
	end
	
	--MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
	--	['@identifier'] = xPlayer.identifier
	--}, function(result)
	--	cb(result)
	--end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		cb(xPlayer.get("bills"))
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
		local xPlayer = ESX.GetPlayerFromId(source)
		local playerBills = xPlayer.get("bills")
		if playerBills[billId] then
			local bill = playerBills[billId]
			local amount = bill.amount
			local xTarget = ESX.GetPlayerFromIdentifier(bill.sender)

			if bill.target_type == 'player' then
				if xTarget then
					if xPlayer.getMoney() >= amount then
						table.remove(playerBills,billId)
						xPlayer.removeMoney(amount)
						xTarget.addMoney(amount)

						xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
						xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))

						xPlayer.set("bills", playerBills)
						cb()
					elseif xPlayer.getAccount('bank').money >= amount then
						table.remove(playerBills,billId)
							
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank', amount)

						xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
						xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))

						xPlayer.set("bills", playerBills)
						cb()
					else
						xTarget.showNotification(_U('target_no_money'))
						xPlayer.showNotification(_U('no_money'))
						cb()
					end
				else
					xPlayer.showNotification(_U('player_not_online'))
					cb()
				end
			else
				TriggerEvent('esx_addonaccount:getSharedAccount', bill.target, function(account)
					if xPlayer.getMoney() >= amount then
						table.remove(playerBills, billId)
							
						xPlayer.removeMoney(amount)
						--account.addMoney(amount)

						--TriggerEvent("s2v_taxes:ApplySocietyTaxe", bill.target, bill.target, amount)
						xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
						if xTarget then
							xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
						end

						xPlayer.set("bills", playerBills)
						cb()
					elseif xPlayer.getAccount('bank').money >= amount then
						table.remove(playerBills, billId)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)
						xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))

						if xTarget then
							xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
						end

						xPlayer.set("bills", playerBills)

						cb()
					else
						if xTarget then
							xTarget.showNotification(_U('target_no_money'))
						end

						xPlayer.showNotification(_U('no_money'))
						cb()
					end
				end)
			end
		end
end)

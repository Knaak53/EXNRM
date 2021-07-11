ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

ESX.RegisterServerCallback('esx_gym:getGymMemberInfo',function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerMoney = xPlayer.getMoney()
	local playerCurrentWeight = xPlayer.getWeight()
	local playerMaxWeight = xPlayer.getMaxWeight()
	
	--[[local gymInfo = MySQL.Sync.fetchAll('SELECT TIMESTAMPDIFF(DAY, buy_date, NOW()) as buyDateDayDiff, plan FROM gym_membership WHERE license = @license', 
        {   
            ['@license'] = xPlayer.getIdentifier()
        }
    )]]--
	local gymInfo = xPlayer.get("gymInfo")
    if gymInfo then
    	local planActive = isSubActive(gymInfo.buyDate, gymInfo.plan)
    	cb({planActive = planActive, plan = gymInfo.plan, playerMaxWeight = playerMaxWeight, playerCurrentWeight = playerCurrentWeight, playerMoney = playerMoney})
    else
    	local newGymInfo = {}
    	newGymInfo.buyDate = 1549643682
    	newGymInfo.plan = 0
    	xPlayer.set("gymInfo", newGymInfo)
    	newGymInfo.playerMaxWeight = playerMaxWeight
    	newGymInfo.playerCurrentWeight = playerCurrentWeight
    	newGymInfo.playerMoney = playerMoney
        cb({planActive = false, plan = 0, playerMaxWeight = playerMaxWeight, playerCurrentWeight = playerCurrentWeight, playerMoney = playerMoney})
    end
end)

function isSubActive(buyDate, plan)
	if plan ~= 0 then
		return os.time() - buyDate < getDurationForPlanInDays(plan)
	end
	return false
end

function getDurationForPlanInDays(plan)
	for i = 1, #Config.planInfo do
		if Config.planInfo[i].plan == plan then
			return Config.planInfo[i].duration
		end
	end
end

RegisterServerEvent("esx_gym:buyMember")
AddEventHandler("esx_gym:buyMember", function(plan)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local gymInfo = xPlayer.get("gymInfo")
	gymInfo.plan = plan.plan
	gymInfo.buyDate = os.time()
	xPlayer.set("gymInfo", gymInfo)
	xPlayer.removeMoney(plan.price)
	TriggerClientEvent('esx:showNotification', _source, "Has pagado ~g~" .. plan.price .. '€ ~w~por la suscripcion')
end)

RegisterServerEvent("esx_gym:buyItem")
AddEventHandler("esx_gym:buyItem", function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(item.price)
	xPlayer.addInventoryItem(item.name, item.count)
	TriggerClientEvent('esx:showNotification', _source, "Has comprado ~y~x" .. item.count .. '~b~ ' .. item.label .. '~w~ por ~g~' .. item.price .. '€')
end)

--[[
ESX.RegisterUsableItem('protein_shake', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('protein_shake', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 350000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'You drank a ~g~protein shake')

end)

ESX.RegisterUsableItem('sportlunch', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sportlunch', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'You ate a ~g~sportlunch')

end)

ESX.RegisterUsableItem('powerade', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('powerade', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 700000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'You drank a ~g~powerade')

end)
]]--

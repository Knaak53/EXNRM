TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

--HOURS
local timeBetweenQuests = {
    john = 14400,
    daisy = 21600,
    charles = 28800,
    leyla = 14400
}

local defaultNpcInfo = {
	level = 1,
	currentXP = 0,
	isOnQuest = false,
	currentQuest = 0,
    currentQuestItems = 0,
	currentQuestIsCompleted = false,
    canStartQuest = true,
    currentQuestInfo = {},
    storeItems = nil,
    isStockRestored = true,
    vehicleOwned = false
}

ESX.RegisterServerCallback('esx_daily_quest:get_npc_player_info',function(source, cb, npcName, npcWantedItem)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local npcLastQuestStart = npcName .. "LastQuestStart"
    local npcLastStock = npcName .. "LastStock"
    local npcInfo = xPlayer.get(npcName)
    local npcWantedItemCount = xPlayer.getInventoryItem(npcWantedItem).count
    local characterMoneyType
    local characterInfo 
    for k, v in pairs(Config.Characters) do
        print(v.name.." =? "..npcName)
        print("monmey? "..v.money)
        if v.name == npcName then
            characterMoneyType = v.money
            characterInfo = v
        end
    end
    print("dineo: "..characterMoneyType)
    if not npcInfo then
        defaultNpcInfo.playerMoney = xPlayer.getAccount(characterMoneyType).money
        defaultNpcInfo.weight = xPlayer.getMaxWeight()
        defaultNpcInfo.currentWeight = xPlayer.getWeight()
        defaultNpcInfo.npcWantedItemCount = npcWantedItemCount
        defaultNpcInfo.questItemCount = 0
        xPlayer.set(npcLastQuestStart, 1549643682)
        xPlayer.set(npcLastStock, 1549643682)
    	cb(defaultNpcInfo)
    else
        if npcInfo.currentQuestInfo and npcInfo.currentQuestInfo.questItem then
            print(npcInfo.currentQuestInfo.questItem)
            npcInfo.questItemCount = xPlayer.getInventoryItem(npcInfo.currentQuestInfo.questItem).count
        end
        if os.time() - xPlayer.get(npcLastQuestStart) >= timeBetweenQuests[npcName] then
            npcInfo.canStartQuest = true
        else
            --npcInfo.canStartQuest = false  DESCOMENTAR DESPUES DE TESTING!!
            npcInfo.canStartQuest = true
        end
        if os.time() - xPlayer.get(npcLastStock) >= 604800 then
            npcInfo.isStockRestored = true
            xPlayer.set(npcLastStock, os.time())
        else
            npcInfo.isStockRestored = false
        end
        npcInfo.playerMoney = xPlayer.getAccount(characterMoneyType).money
        npcInfo.weight = xPlayer.getMaxWeight()
        npcInfo.currentWeight = xPlayer.getWeight()
        npcInfo.npcWantedItemCount = npcWantedItemCount
        xPlayer.set(npcName, npcInfo)
		cb(npcInfo)
    end
end)	

RegisterNetEvent('esx_daily_quest:startDeliveryQuest')
AddEventHandler('esx_daily_quest:startDeliveryQuest', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addInventoryItem(item, 1)
end)

RegisterNetEvent('esx_daily_quest:giveWantedItem')
AddEventHandler('esx_daily_quest:giveWantedItem', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem(item.name, 1)
    xPlayer.addAccountMoney("black_money", item.givenMoney)

end)

RegisterNetEvent('esx_daily_quest:buyItem')
AddEventHandler('esx_daily_quest:buyItem', function(item, count, npcName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if item.type == 'item' then
        xPlayer.addInventoryItem(item.name, count)
    elseif item.type == 'weapon' then
        xPlayer.addWeapon(item.name, 5)
    else
    	local plate = GeneratePlate()
        --[[MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, price) VALUES (@owner, @plate, @vehicle, @price)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = plate,
			['@vehicle'] = json.encode({model = GetHashKey(item.name), plate = plate}),
			['@price'] = item.price
		}, function(rowsChanged)
			cb(true)
		end)

		MySQL.Async.execute( 'INSERT INTO trunk_inventory (plate, data) VALUES(@plate, @data)',
	      {
	        ['@plate'] = plate,
	        ['@data'] = '{"weapons" : [], "items": [], "accounts": []}',
	      })]]--
    end
    local moneyType 
    for k,v in pairs(Config.Characters) do
        if v.name == npcName then
            moneyType = v.money
        end
    end
    xPlayer.removeAccountMoney(moneyType, item.price * count)

    TriggerClientEvent('esx:showNotification', source, 'Has comprado x~g~'.. count .. "~w~ " .. item.label .. " por ~r~" .. item.price * count .. "€")
end)

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterNetEvent('esx_daily_quest:giveQuestPayment')
AddEventHandler('esx_daily_quest:giveQuestPayment', function(items, money, npcName, level, questType, item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if questType == "pickup" then
        xPlayer.removeInventoryItem(item, 1)
    end

    for i = 1, #items do
        if items[i].type == 'item' then
            xPlayer.addInventoryItem(items[i].name, items[i].amount)
        else
            xPlayer.addWeapon(items[i].name, items[i].amount)
        end
    end

    local characterMoneyType
    for k, v in pairs(Config.Characters) do
        if v.name == npcName then
            characterMoneyType = v.money
        end
    end
    xPlayer.addAccountMoney(characterMoneyType, math.floor(money * (1 + (level / 10) * 2)))

    local timerName = npcName .. 'LastQuestStart'
    xPlayer.set(timerName, os.time())
end)

RegisterNetEvent('esx_daily_quest:updateInteractionItem')
AddEventHandler('esx_daily_quest:updateInteractionItem', function(questType, item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if questType == "delivery" then
        xPlayer.removeInventoryItem(item, 1)
    elseif questType == "pickup" then
        xPlayer.addInventoryItem(item, 1)
    end
end)

RegisterNetEvent('esx_daily_quest:giveItem')
AddEventHandler('esx_daily_quest:giveItem', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addInventoryItem(item, 1)
end)


RegisterNetEvent('esx_daily_quest:updateCurrentQuest')
AddEventHandler('esx_daily_quest:updateCurrentQuest', function(npcInfo, npcName)
    print(npcInfo.currentQuest)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.set(npcName, npcInfo)
    --[[MySQL.Async.execute(
      'UPDATE daily_quest set ' .. npcName .. ' = @npcInfo WHERE player = @id',
      {
        ['@npcInfo'] = json.encode(npcInfo),
        ['@id'] = xPlayer.getIdentifier()
      },
    function(result)
    end)]]--
end)

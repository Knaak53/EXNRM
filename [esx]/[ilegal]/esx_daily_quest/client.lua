ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_daily_quest:openCharacterMenu')
AddEventHandler('esx_daily_quest:openCharacterMenu', function(charIndex, job)
	if job ~= "police" and 
		job ~= "ambulance" and 
		job ~= "mechanic" and 
		job ~= "taxi" and 
		job ~= "offpolice" and 
		job ~= "cardealer" then
		ESX.TriggerServerCallback('esx_daily_quest:get_npc_player_info', function(npcInfo)
			local currentQuestInfo
			print(npcInfo.currentQuest, npcInfo.isOnQuest)
			if not npcInfo.isOnQuest and npcInfo.currentQuest == 0 and Config.Characters[charIndex].quests then
				currentQuestInfo = getRandomQuest(Config.Characters[charIndex].quests)
				npcInfo.currentQuestItems = currentQuestInfo.currentQuestItems
				npcInfo.currentQuest = currentQuestInfo.currentQuest
				TriggerServerEvent('esx_daily_quest:updateCurrentQuest', npcInfo, Config.Characters[charIndex].name)
			elseif Config.Characters[charIndex].quests then
				currentQuestInfo = {name = Config.Characters[charIndex].quests[npcInfo.currentQuest].name, 
									description = Config.Characters[charIndex].quests[npcInfo.currentQuest].description, 
									possibleItems = Config.Characters[charIndex].quests[npcInfo.currentQuest].possibleItems[npcInfo.currentQuestItems],
									money = Config.Characters[charIndex].quests[npcInfo.currentQuest].money,
									questType = Config.Characters[charIndex].quests[npcInfo.currentQuest].questType,
									questItem = Config.Characters[charIndex].quests[npcInfo.currentQuest].questItem,
									currentQuest = npcInfo.currentQuest,
									currentQuestItems = npcInfo.currentQuestItems}
			end
			local storeItems
			if npcInfo.isStockRestored then
				npcInfo.storeItems = Config.Characters[charIndex].storeItems
			end
	        SendNUIMessage(
		        {
					action = "open",
					name = Config.Characters[charIndex].name,
					surname = Config.Characters[charIndex].surname,
					lvlNeedXP = Config.Characters[charIndex].lvlNeedXP,
					rangeNames = Config.ranges,
					currentXP = npcInfo.currentXP,
					level = npcInfo.level,
					isOnQuest = npcInfo.isOnQuest,
					currentQuestInfo = currentQuestInfo,
					currentQuestIsCompleted = npcInfo.currentQuestIsCompleted,
					canStartQuest = npcInfo.canStartQuest,
					storeItems = npcInfo.storeItems,
					playerMoney = npcInfo.playerMoney,
					playerCapacity = npcInfo.weight,
	              	playerCurrentWeight = npcInfo.currentWeight,
	              	wantedItem = Config.Characters[charIndex].interestItem,
	              	npcWantedItemCount = npcInfo.npcWantedItemCount,
	              	vehicleOwned = npcInfo.vehicleOwned,
	              	questItemCount = npcInfo.questItemCount
		        }
			)
			SetNuiFocus(true, true)
	  	end, Config.Characters[charIndex].name, Config.Characters[charIndex].interestItem.name)	
	end
end)

RegisterNUICallback("exit", function(data, cb)
	local npcInfo = buildNpcInfoFromCallbackData(data)
    TriggerServerEvent('esx_daily_quest:updateCurrentQuest', npcInfo, data.npcName)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("giveItem", function(data, cb)
    TriggerServerEvent('esx_daily_quest:giveItem', data.item)
end)

RegisterNUICallback("startQuest", function(data, cb)
	local npcInfo = buildNpcInfoFromCallbackData(data)
    TriggerServerEvent('esx_daily_quest:updateCurrentQuest', npcInfo, data.npcName)
    for i = 1, #Config.Characters do
    	if data.npcName == Config.Characters[i].name then
    		Config.Characters[i].quests[data.currentQuestInfo.currentQuest].questStart()
    	end
    end
end)

RegisterNUICallback("completeQuest", function(data, cb)
	local npcInfo = buildNpcInfoFromCallbackData(data)
	print(npcInfo.currentQuest, data.currentQuestInfo.currentQuest)
	for i = 1, #Config.Characters do
    	if data.npcName == Config.Characters[i].name then
    		Config.Characters[i].quests[data.currentQuestInfo.currentQuest].questEnd(data.currentQuestInfo.possibleItems, data.currentQuestInfo.money, npcInfo.level)
    	end
    end
    TriggerServerEvent('esx_daily_quest:updateCurrentQuest', npcInfo, data.npcName)
end)

RegisterNUICallback("buyItem", function(data, cb)
	local npcInfo = buildNpcInfoFromCallbackData(data)
	TriggerServerEvent('esx_daily_quest:buyItem', data.item, data.count, data.npcName)
    TriggerServerEvent('esx_daily_quest:updateCurrentQuest', npcInfo, data.npcName)
end)

RegisterNUICallback("giveWantedItem", function(data, cb)
	local npcInfo = buildNpcInfoFromCallbackData(data)
	TriggerServerEvent('esx_daily_quest:giveWantedItem', data.wantedItemInfo)
	TriggerServerEvent('esx_daily_quest:updateCurrentQuest', npcInfo, data.npcName)
end)

RegisterNetEvent('esx_daily_quest:questInteraction')
AddEventHandler('esx_daily_quest:questInteraction', function(charIndex, questIndex)
	ESX.TriggerServerCallback('esx_daily_quest:get_npc_player_info', function(npcInfo)
		if npcInfo.isOnQuest and npcInfo.currentQuest == questIndex then		
			if npcInfo.currentQuestInfo.questType == "pickup" then
				if npcInfo.currentQuestIsCompleted then
					if npcInfo.questItemCount == 0 then
						Config.Characters[charIndex].quests[npcInfo.currentQuest].questInteraction()
					end	
				else
					Config.Characters[charIndex].quests[npcInfo.currentQuest].questInteraction()
					npcInfo.currentQuestIsCompleted = true
				end	
			else
				if npcInfo.questItemCount > 0 then
					Config.Characters[charIndex].quests[npcInfo.currentQuest].questInteraction()
					npcInfo.currentQuestIsCompleted = true
				else
					ESX.ShowNotification("No tienes el objeto necesario, vuelve con " .. Config.Characters[charIndex].name .. " para conseguir otro.")
				end
			end	
			TriggerServerEvent('esx_daily_quest:updateCurrentQuest', npcInfo, Config.Characters[charIndex].name)
		end
  	end, Config.Characters[charIndex].name, Config.Characters[charIndex].interestItem.name)
end)

function buildNpcInfoFromCallbackData(data)
	if data.currentQuestInfo == nil then
		data.currentQuestInfo = {}
	end
	local npcInfo = {
		level = data.level,
		currentXP = data.currentXP, 
		isOnQuest = data.isOnQuest,
		currentQuestIsCompleted = data.currentQuestIsCompleted,
		currentQuestInfo = data.currentQuestInfo,
		canStartQuest = data.canStartQuest,
		currentQuest = data.currentQuestInfo.currentQuest or nil,
		currentQuestItems = data.currentQuestInfo.currentQuestItems or nil,
		storeItems = data.storeItems,
		vehicleOwned = data.vehicleOwned
	}
	return npcInfo
end

function getRandomQuest(quest)
	math.randomseed(GetGameTimer())
	local random = math.random(1, #quest)
	math.randomseed(GetGameTimer())
	local randomItem = math.random(1, 100)
	local itemIndex

	if randomItem >= 40 then
		itemIndex = 1
	elseif randomItem < 40 and randomItem >= 6 then
		itemIndex = 2									
	else
		itemIndex = 3
	end
	print(random)
	return {
				name = quest[random].name, 
				description = quest[random].description, 
				possibleItems = quest[random].possibleItems[itemIndex], 
				money = quest[random].money, 
				currentQuest = random, 
				currentQuestItems = itemIndex,
				questType = quest[random].questType,
				questItem = quest[random].questItem
			}
end




--------------------------------------------------------------------------------------

								--PED GENERATION--

--------------------------------------------------------------------------------------

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteCharacters()
	end
end)

local pedEntities = {}
local npcEntities = {}

DeleteCharacters = function()
    for i=1, #pedEntities do
        local char = pedEntities[i]
        if DoesEntityExist(char) then
            DeleteEntity(char)
            SetPedAsNoLongerNeeded(char)
        end
    end
    for i=1, #npcEntities do
        local char = npcEntities[i]
        if DoesEntityExist(char) then
			DeleteEntity(char)
           	SetPedAsNoLongerNeeded(char)
        end
    end
end

Citizen.CreateThread(function()
	for i = 1, #Config.Characters do
		if Config.Characters[i].model then
			hash = GetHashKey(Config.Characters[i].model)
			RequestModel(hash)
			while not HasModelLoaded(hash) do
				print("intento")
				Citizen.Wait(10)
			end
			if not DoesEntityExist(pedEntities[i]) then
				pedEntities[i] = CreatePed(4, hash, Config.Characters[i].coords.x, Config.Characters[i].coords.y, Config.Characters[i].coords.z, Config.Characters[i].heading)
				SetEntityAsMissionEntity(pedEntities[i])
				SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
				FreezeEntityPosition(pedEntities[i], true)
				SetEntityInvincible(pedEntities[i], true)
				TaskStartScenarioInPlace(pedEntities[i], Config.Characters[i].animation, 0, true)
			end
			SetModelAsNoLongerNeeded(hash)
		end
    end
	print("spawneando")
	for i = 1, #Config.questNPC do
		
        hash = GetHashKey(Config.questNPC[i].model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
			Citizen.Wait(10)
		end
        if not DoesEntityExist(npcEntities[i]) then
            npcEntities[i] = CreatePed(4, hash, Config.questNPC[i].coords.x, Config.questNPC[i].coords.y, Config.questNPC[i].coords.z, Config.questNPC[i].heading)
            SetEntityAsMissionEntity(npcEntities[i])
            SetBlockingOfNonTemporaryEvents(npcEntities[i], true)
            FreezeEntityPosition(npcEntities[i], true)
            SetEntityInvincible(npcEntities[i], true)
            TaskStartScenarioInPlace(npcEntities[i], Config.questNPC[i].animation, 0, true)
        end
        SetModelAsNoLongerNeeded(hash)
    end

end)
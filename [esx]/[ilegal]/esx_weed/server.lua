TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

local weedInfo = {}
local currentWeedCount = 0
local currentWeedSpawned = false
local currentWeedProgress = 0
local processActive = false
local currentProcessWeed = 0
local currentBrickCount = 0
local item_weed = "weed"
local item_weed_pooch = "weed_pooch"
local item_weed_bag = "weed_bag"
local item_weed_block = 'weed_block'
local item_weed_green = "weed_green"

local plants_locations = {
    vector3(1051.343, -3205.271, -40.14793),
    vector3(1053.045, -3205.571, -40.14793),
    vector3(1050.038, -3207.198, -40.14793),
    vector3(1051.532, -3200.698, -40.14793),
    vector3(1053.149, -3199.109, -40.14793),
    vector3(1050.097, -3199.066, -40.14793),
    vector3(1051.409, -3192.943, -40.15198),
    vector3(1052.786, -3192.609, -40.0429),
    vector3(1052.999, -3189.482, -40.0429),
    vector3(1050.136, -3187.767, -40.0429),
    vector3(1062.893, -3192.11, -40.14793),
    vector3(1061.436, -3193.431, -40.14793),
    vector3(1061.354, -3194.94, -40.14793),
    vector3(1064.574, -3195.073, -40.14793),
    vector3(1058.772, -3197.98, -40.05674),
    vector3(1056.153, -3197.546, -40.06199),
    vector3(1055.899, -3200.441, -40.06199),
    vector3(1055.871, -3201.829, -40.08317),
    vector3(1055.871, -3201.829, -40.08317),
    vector3(1057.238, -3202.212, -40.16141),
    vector3(1058.734, -3199.851, -40.06852),
    vector3(1058.734, -3199.851, -40.06852),
    vector3(1057.421, -3200.2, -40.16197),
    vector3(1064.74, -3201.716, -40.0429),
    vector3(1061.995, -3201.573, -40.0429),
    vector3(1061.964, -3203.103, -40.0429),
    vector3(1061.971, -3204.684, -40.0429),
    vector3(1061.949, -3206.385, -40.0429),
    vector3(1063.268, -3206.719, -40.15198)
}

--[[MySQL.ready(function()
	local weed = MySQL.Sync.fetchAll('SELECT TIMESTAMPDIFF(MINUTE, lastHarvest, NOW()) as lastHarvest, respawnTime FROM drugs WHERE drug = @weed', 
        {   
            ['@weed'] = item_weed
        }
    )
    if weed[1] then
    	weedInfo = {lastHarvest = weed[1].lastHarvest, respawnTime = weed[1].respawnTime}
    	if weedInfo.lastHarvest < weedInfo.respawnTime then
    		startWeedTimer(weedInfo.lastHarvest, weedInfo.respawnTime)
    	else
    		startNewWeed()
    	end
    end
end)]]--

AddEventHandler('esx:dataReady', function()
    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end)
    while not ESX do Citizen.Wait(50) end
    local drugsCoolDowns = ESX.getsData().get("drugsCoolDowns")  
    if not drugsCoolDowns then
        drugsCoolDowns = {}
        ESX.getsData().set("drugsCoolDowns", drugsCoolDowns)  
    end
    if not drugsCoolDowns.weed then
        drugsCoolDowns.weed = {lastHarvest = 1549643682, respawnTime = 3600}
        ESX.getsData().set("drugsCoolDowns", drugsCoolDowns) 
    end
    weedInfo = drugsCoolDowns.weed
    if os.time() - weedInfo.lastHarvest < weedInfo.respawnTime then
        startWeedTimer(weedInfo.lastHarvest, weedInfo.respawnTime)
    else
        startNewWeed()
    end
end)


RegisterNetEvent('esx_weed:takeWeed')
AddEventHandler('esx_weed:takeWeed', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if currentWeedSpawned then
    	if currentWeedCount > 0 then
	    	if xPlayer.canCarryItem(item_weed_block, 1) then
		    	xPlayer.addInventoryItem(item_weed_block, 1)
		    	TriggerClientEvent('esx:showNotification', _source, "Has recogido un ~g~FARDO DE MARIA~w~!")
		    	currentWeedCount = currentWeedCount - 1
		    else
		    	TriggerClientEvent('esx:showNotification', _source, "~r~NO PUEDES LLEVAR TANTO PESO!")
		    end
    	else
    		TriggerClientEvent('esx_weed:despawnWeed', -1)
    		currentWeedCount = 0
    		currentWeedSpawned = false
    		TriggerClientEvent('esx:showNotification', source, "~r~NO QUEDAN MAS FARDOS!")
            math.randomseed(os.time())
    		local randomSpawnTime = math.random(3600, 7200)
    		--[[MySQL.Async.execute(
		      'UPDATE drugs set lastHarvest = NOW(), respawnTime = @respawn where drug = @weed',
		      {
		        ['@weed'] = item_weed,
		        ['@respawn'] = randomSpawnTime
		      },
		    function(result)
		    end)]]--
            local newWeedInfo = {lastHarvest = os.time(), respawnTime = randomSpawnTime}
            startWeedTimer(newWeedInfo.lastHarvest, newWeedInfo.respawnTime)
            local drugsCoolDowns = ESX.getsData().get("drugsCoolDowns")
            drugsCoolDowns.weed = newWeedInfo
            ESX.getsData().set("drugsCoolDowns", drugsCoolDowns)
		    --[[local weed = MySQL.Sync.fetchAll('SELECT TIMESTAMPDIFF(MINUTE, lastHarvest, NOW()) as lastHarvest, respawnTime FROM drugs WHERE drug = @weed', 
		        {   
		            ['@weed'] = item_weed
		        }
		    )]]--
    	end
    end
end)

RegisterNetEvent('esx_weed:processWeed')
AddEventHandler('esx_weed:processWeed', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem(item_weed, 2)
    xPlayer.removeInventoryItem(item_weed_bag, 1)
    xPlayer.addInventoryItem(item_weed_pooch, 1)
    TriggerClientEvent('esx:showNotification', _source, "Has creado un ~g~Chivato de Maria~w~")
end)

RegisterNetEvent("esx_weed:takeBlockFromPallet")
AddEventHandler('esx_weed:takeBlockFromPallet', function(brickId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.canCarryItem(item_weed_block, 1) then
        TriggerClientEvent("esx_weed:removeBlockFromPallet", -1, brickId)
        xPlayer.addInventoryItem(item_weed_block, 1)
        TriggerClientEvent('esx:showNotification', _source, "Has recogido un ~g~Fardo de Maria~w~")
    else
        TriggerClientEvent('esx:showNotification', _source, "~r~No puedes llevar tanto peso!")
    end    
end)

RegisterNetEvent('esx_weed:putWeedInCase')
AddEventHandler('esx_weed:putWeedInCase', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    currentWeedProgress = currentWeedProgress + 1
    TriggerClientEvent('esx_weed:addCaseToPallet', -1, currentWeedProgress)
    if currentWeedProgress == 10 then
        TriggerClientEvent('esx_weed:finishFarmPhase', -1)
        currentProcessWeed = 0
        currentBrickCount = 0
    end
end)

RegisterNetEvent('esx_weed:startLabFarm')
AddEventHandler('esx_weed:startLabFarm', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem("weed_card", 1)
    math.randomseed(os.time())
    local randomSpawnTimeLab = math.random(7200, 10800)
    local drugsCoolDowns = ESX.getsData().get("drugsCoolDowns")
    drugsCoolDowns.weedLab = {lastHarvest = os.time(), respawnTime = randomSpawnTimeLab}
    ESX.getsData().set("drugsCoolDowns", drugsCoolDowns)
    --[[MySQL.Async.execute(
      'UPDATE drugs set lastHarvest = NOW(), respawnTime = @respawn where drug = @weedLab',
      {
        ['@weedLab'] = "weedLab",
        ['@respawn'] = randomSpawnTimeLab
      },
    function(result)
    end)]]--
    local selectedPlants = getRandomPlants()
    currentWeedProgress = 0
    TriggerClientEvent('esx_weed:startLabFarmClient', -1, selectedPlants)
end)

RegisterNetEvent("esx_weed:stopProcessing")
AddEventHandler("esx_weed:stopProcessing", function()
    processActive = false
end)

RegisterNetEvent('esx_weed:startProcess')
AddEventHandler('esx_weed:startProcess', function()
    if not processActive then
        processActive = true
        TriggerClientEvent('esx_weed:startProcessLider', source, currentProcessWeed)
    else
        TriggerClientEvent('esx:showNotification', source, "El ~g~PROCESADO~w~ ya esta en curso.")
    end
end)

RegisterNetEvent("esx_weed:processNewWeedBrick")
AddEventHandler("esx_weed:processNewWeedBrick", function()
    currentProcessWeed = currentProcessWeed + 1
    if currentProcessWeed == 20 then
        TriggerClientEvent("esx_weed:finishProcessing", -1)
    else
        currentBrickCount = currentBrickCount + 1
        TriggerClientEvent("esx_weed:spawnBricks", -1, currentBrickCount)  
    end  
end)


RegisterNetEvent('esx_weed:removePlantFromLab')
AddEventHandler('esx_weed:removePlantFromLab', function(plantId)
    TriggerClientEvent('esx_weed:removePlantFromLabClient', -1, plantId)
end)

function getRandomPlants()
    local ret = {}
    local randoms = {}
    math.randomseed(os.time())
    while #ret < 11 do
        local random_plant = math.random(1, #plants_locations)
        if isRandomNotRepeated(random_plant, randoms) then
            table.insert(ret, {coords = plants_locations[random_plant], id = #ret + 1})
            table.insert(randoms, random_plant)
        end
    end
    return ret
end

function isRandomNotRepeated(random_plant, randoms)
    for i = 1, #randoms do
        if random_plant == randoms[i] then
            return false
        end
    end
    return true
end

ESX.RegisterUsableItem(item_weed, function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem(item_weed).count >= 2 then
        if xPlayer.getInventoryItem(item_weed_bag).count > 0 then
            if xPlayer.getInventoryItem(item_weed_bag).count > 0 then
                TriggerClientEvent('esx_weed:processWeed', _source)
            else
                TriggerClientEvent('esx:showNotification', _source, "Necesitas una ~r~Bascula de maria~w~ para pesar la marihuana!")
            end       
        else
            TriggerClientEvent('esx:showNotification', _source, "No tienes suficiente ~r~Bolsitas Vacias~w~!")
        end   
    else
        TriggerClientEvent('esx:showNotification', _source, "No tienes suficiente ~r~Marihuana~w~ para crear un chivato...")
    end 
end)

ESX.RegisterUsableItem(item_weed_block, function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem(item_weed_block, 1)
    xPlayer.addInventoryItem(item_weed, 10)
    TriggerClientEvent('esx:showNotification', _source, "Has abierto el ~g~Fardo de Marihuana~w~!")
end)

ESX.RegisterServerCallback('esx_weed:get_weed_info', function(source, cb)
    if weedInfo then
    	cb(weedInfo)
    else
    	cb(nil)
    end
end)

ESX.RegisterServerCallback('esx_weed:get_weed_card_count', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cb(xPlayer.getInventoryItem("weed_card").count)
end)

ESX.RegisterServerCallback('esx_weed:canTakeWeedLab', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    --[[local weedLab = MySQL.Sync.fetchAll('SELECT TIMESTAMPDIFF(MINUTE, lastHarvest, NOW()) as lastHarvest, respawnTime FROM drugs WHERE drug = @weedLab', 
        {   
            ['@weedLab'] = "weedLab"
        }
    )]]--
    local drugsCoolDowns = ESX.getsData().get("drugsCoolDowns")
    if not drugsCoolDowns.weedLab then
        drugsCoolDowns.weedLab = {lastHarvest = 1549643682, respawnTime = 7200}
        ESX.getsData().set("drugsCoolDowns", drugsCoolDowns)
    end
    local canTakeWeed = os.time() - drugsCoolDowns.weedLab.lastHarvest >= drugsCoolDowns.weedLab.respawnTime
    cb({canTakeWeed = canTakeWeed, haveCard = xPlayer.getInventoryItem("weed_card").count > 0})
end)

function startNewWeed()
	currentWeedCount = 10
	TriggerClientEvent('esx_weed:spawnWeed', -1)
	currentWeedSpawned = true
end

function startWeedTimer(lastHarvest, respawnTime)
	Citizen.CreateThread(function()
        Citizen.Wait((respawnTime - (os.time() - lastHarvest)) * 1000)
        TriggerClientEvent('esx_weed:spawnWeed', -1)
        currentWeedSpawned = true
        currentWeedCount = 10
	end)
end
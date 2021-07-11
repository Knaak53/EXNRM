local farmActive = false
local cokeOnBoat = false
local cokeBeenTaken = false

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

ExM = exports.extendedmode:getExtendedModeObject()

AddEventHandler('esx:dataReady', function(obj)
  TriggerEvent('esx:getSharedObject', function(obj)
      ESX = obj
    end)
end)

ESX.RegisterServerCallback('esx_coke:canTakeCoke', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    --[[local cokeLab = MySQL.Sync.fetchAll('SELECT TIMESTAMPDIFF(MINUTE, lastHarvest, NOW()) as lastHarvest, respawnTime FROM drugs WHERE drug = @coke', 
        {   
            ['@coke'] = "coke"
        }
    )]]--
    local drugsCoolDowns = ESX.getsData().get("drugsCoolDowns")
    if not drugsCoolDowns.coke then
        drugsCoolDowns.coke = {lastHarvest = 1549643682, respawnTime = 8200}
        ESX.getsData().set("drugsCoolDowns", drugsCoolDowns)
    end
    local canTakeCoke = os.time() - drugsCoolDowns.coke.lastHarvest >= drugsCoolDowns.coke.respawnTime
    cb({canTakeCoke = canTakeCoke, haveCard = xPlayer.getInventoryItem("coke_card").count > 0})
end)

RegisterNetEvent('esx_coke:startCokeFarm')
AddEventHandler('esx_coke:startCokeFarm', function()
    local _source = source
	farmActive = true
	weedOnBoat = false
	weedBeenTaken = false
    spawnMainVehicle(_source)
    spawnNarcoVehiclesAndBrick()
end)

function spawnNarcoVehiclesAndBrick()
    math.randomseed(os.time())
    local randCoords = Config.narcoSpawns[math.random(1, #Config.narcoSpawns)]
    local mainNarcoBoat = spawnNarcoBoat(randCoords)
    randCoords2 = vector3(randCoords.x, randCoords.y + 2.5, randCoords.z)
    local secondNarcoBoat = spawnNarcoBoat(randCoords2)
    local bricks = CreateObject(Config.bricks.model, randCoords)
    local bricksOwnedBy = NetworkGetEntityOwner(bricks)
    local mainBoatOwner = NetworkGetEntityOwner(mainNarcoBoat)
    local secondBoatOwner = NetworkGetEntityOwner(secondNarcoBoat)
    --TriggerClientEvent("esx_coke:set_boat_anchor", mainBoatOwner, mainNarcoBoat)
    --TriggerClientEvent("esx_coke:set_boat_anchor", secondBoatOwner, secondNarcoBoat)
    TriggerClientEvent("esx_coke:attachBricksToBoat", bricksOwnedBy, bricks, mainNarcoBoat)
    TriggerClientEvent('esx_coke:startCokeFarmClient', -1, bricks)
end

function spawnNarcoBoat(coords)
    local veh = ExM.Game.SpawnVehicle(Config.vehicle.model, coords)
    while not DoesEntityExist(veh) do
        Wait(400)
    end
    SetEntityHeading(veh, Config.vehicle.heading)
    return veh
end

function spawnMainVehicle(_source)
    local veh = ExM.Game.SpawnVehicle(Config.vehicle.model, Config.vehicle.spawnPoint)
    while not DoesEntityExist(veh) do
        Wait(400)
    end
    SetEntityHeading(veh, Config.vehicle.heading)
    TriggerClientEvent('esx_coke:walk_to_boat', _source, NetworkGetNetworkIdFromEntity(veh))
end

RegisterNetEvent("esx_coke:takeBricksFromBoat")
AddEventHandler("esx_coke:takeBricksFromBoat", function()
	if farmActive and not cokeOnBoat then
		if cokeBeenTaken then
			TriggerClientEvent('esx:showNotification', source, "~r~YA ESTAN RECOGIENDO LOS FARDOS!")
		else
			TriggerClientEvent('esx_coke:startChangeBricksBetweenBoats', source)
		end
	end
end)

RegisterNetEvent("esx_coke:bricksBoatChanged")
AddEventHandler("esx_coke:bricksBoatChanged", function()
    cokeOnBoat = true
    TriggerClientEvent('esx_coke:startReturnToBase', -1)
end)
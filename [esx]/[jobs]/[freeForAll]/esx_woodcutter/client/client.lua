--en la zona de minas: x maderas con un máximo extraíble. Se regenera con el tiempo, si llega a 0 no puedes leñar.
local clicks = 0
local madera = nil
local npcvender = false --false si no quieres el npc que te lo cambia por dinero
local inCuttingZone = false
local logCounts = 0
local mypallets = {}
local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports.extendedmode:getSharedObject()
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        print("job: woodcutter o ke?")
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
    print("job: " .. PlayerData.job.name)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function AbrirMenu()

	local elements = {
		{label = "Si",value = "yes"},
		{label = "No",value = "no"}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'get_job',
		{
			title  = 'Vender toda la madera?',
			align    = 'left',
			elements = elements
		},
		function(data, menu)	
			if data.current.value == 'yes' then
				TriggerServerEvent('leñar:quitomad')
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

--RegisterNetEvent('esx_woodcutter:getTool')
AddEventHandler('esx_woodcutter:getTool', function()
    if PlayerData.job and PlayerData.job.name == "woodcutter" then
        GiveWeaponToPed(GetPlayerPed(-1),"weapon_hatchet",1,false,true)
        TriggerServerEvent("startWoodCutterJob", job)
    else
        ESX.ShowNotification(_U('no_soy_lenador'))
    end
end)

--RegisterNetEvent('esx_woodcutter:sellWood')
AddEventHandler('esx_woodcutter:sellWood', function()
    if PlayerData.job and PlayerData.job.name == "woodcutter" then
        AbrirMenu()
    else
        ESX.ShowNotification(_U('que_haces'))
    end
end)

local blips = {
    {title="Zona de tala", colour=17, id=85, x = Config.npc[1].coords.x, y = Config.npc[1].coords.y, z = Config.npc[1].coords.z},
    {title="Comerciante de maderas", colour=17, id=85, x = -552.38,y = 5327.27,z = 73.6},
}
 
Citizen.CreateThread(function()
    Citizen.Wait(0)
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.9)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

treesEntities = {}
woodEntities = {}

Citizen.CreateThread(function()   
    for k,v in pairs(Config.maderas) do
        treesEntities[k] = spawnTree(k)
    end
    SetModelAsNoLongerNeeded("prop_tree_olive_cr2_test")
end)

function spawnTree(id)
    local treeConfig = Config.maderas[id]
    RequestModel("prop_tree_olive_cr2_test")
    while not HasModelLoaded("prop_tree_olive_cr2_test") do Citizen.Wait(50) end
    local newtree = CreateObject(GetHashKey("prop_tree_olive_cr2_test"), treeConfig.coords.x + 1, treeConfig.coords.y, treeConfig.coords.z - 1.0, false, false, false)
    SetEntityHeading(newtree, treeConfig.heading)
    FreezeEntityPosition(newtree, true)
    return {id = id, entity = newtree, min = treeConfig.min, max = treeConfig.max, isFalling = false}
end

Citizen.CreateThread(function()   
    while true do
        if PlayerData.job and PlayerData.job.name == "woodcutter" then
            local playerPed = PlayerPedId()
            if #(GetEntityCoords(playerPed) - Config.maderas[1].coords) < 150 then
                for k,v in pairs(treesEntities) do
                    print("id: " .. v.id .. " | health: " .. GetEntityHealth(v.entity))
                    if DoesEntityExist(v.entity) and GetEntityHealth(v.entity) <= 0 and not v.isFalling then
                        v.isFalling = true
                        v.treePos = GetEntityCoords(v.entity)
                        destroyTreeAndGiveWood(v)
                    end
                end
                if not inCuttingZone then
                    inCuttingZone = true
                    TriggerServerEvent("esx_woodcutter:startJob")
                end
            end
            Citizen.Wait(500)
        else
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    while true do
        local playerPed = PlayerPedId()
        if PlayerData.job and PlayerData.job.name == "woodcutter" then
            if #(GetEntityCoords(playerPed) - Config.maderas[1].coords) >= 150 then
                local weapon = GetSelectedPedWeapon(playerPed, true)
                if weapon == GetHashKey("weapon_hatchet") then
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("weapon_hatchet"))
                    ESX.ShowNotification(_U('te_has_alejado'))
                end
                if inCuttingZone then
                    inCuttingZone = false
                    TriggerServerEvent("esx_woodcutter:endJob")
                end
            end
            Citizen.Wait(2000)
        else
            Citizen.Wait(5000)
        end
    end
end)

function destroyTreeAndGiveWood(v)
    Citizen.CreateThread(function()     
        FreezeEntityPosition(v.entity, false)
        TriggerServerEvent("esx_woodcutter:treeFall", v.id)
        while true do
            if GetEntityCoords(v.entity).z > v.treePos.z + 1.0 then
                SetEntityCollision(v.entity, false, false)
                RequestNamedPtfxAsset("core")
                Citizen.InvokeNative(0x6C38AF3693A69A91, "core")
                StartParticleFxNonLoopedOnEntity("bang_wood", v.entity, 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 25.0, false, false, false)
                Wait(200)
                RequestNamedPtfxAsset("core")
                Citizen.InvokeNative(0x6C38AF3693A69A91, "core")
                StartParticleFxNonLoopedOnEntity("bang_wood", v.entity, 0.0, 0.0, -0.5, 1.0, 0.0, 0.0, 25.0, false, false, false)
                spawnWood(v.entity, v.min, v.max, v.item)
                DeleteEntity(v.entity)
                setRespawnTimer(v.id)
                break
            else
                Wait(50)
            end
        end 
    end)
end

function destroyTree(v)
    Citizen.CreateThread(function()     
        FreezeEntityPosition(v.entity, false)
        ActivatePhysics(v.entity)
        while true do
            if GetEntityCoords(v.entity).z > v.treePos.z + 1.0 then
                SetEntityCollision(v.entity, false, false)
                RequestNamedPtfxAsset("core")
                Citizen.InvokeNative(0x6C38AF3693A69A91, "core")
                StartParticleFxNonLoopedOnEntity("bang_wood", v.entity, 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 25.0, false, false, false)
                Wait(200)
                RequestNamedPtfxAsset("core")
                Citizen.InvokeNative(0x6C38AF3693A69A91, "core")
                StartParticleFxNonLoopedOnEntity("bang_wood", v.entity, 0.0, 0.0, -0.5, 1.0, 0.0, 0.0, 25.0, false, false, false)
                DeleteEntity(v.entity)
                setRespawnTimer(v.id)
                break
            else
                Wait(50)
            end
        end 
    end)
end

local carryingLog = false

RegisterNetEvent("esx_woodcutter:takeLog")
AddEventHandler("esx_woodcutter:takeLog", function(entity)
    if not carryingLog then
        local entityFound = false
        for k,v in pairs(woodEntities) do
            if v.entity == entity then
                entityFound = true
                carryingLog = true
                local playerPed = PlayerPedId()
                RequestAnimDict("anim@heists@box_carry@")
                while not HasAnimDictLoaded("anim@heists@box_carry@") do
                    Citizen.Wait(100)
                end
                AttachEntityToEntity(entity, playerPed, GetPedBoneIndex(playerPed, 28422), 0.17, 0.0, 0.01, 0, 0, 90.0, true, true, false, true, 1, true)
                Citizen.Wait(10)
                TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
                break
            end
        end
        if not entityFound then
            ESX.ShowNotification("~r~No puedes recoger ese tronco!")
        end
    else
        ESX.ShowNotification("~r~Ya estás cargando un tronco!")
    end
end)

RegisterNetEvent("esx_woodcutter:logsReady")
AddEventHandler("esx_woodcutter:logsReady", function(pos, type, coords) 
    print("PALLLEEEEET VAAAAA")
    mypallets[pos] = {
        entity = exports['enc0ded-forklift-trailer']:SpawnPalletsWithProducts(1, type, {x = coords.x, y = coords.y,z = coords.z}, {x = 0.0, y = 2.5}),
        iniCoords = coords
    }
end)

RegisterCommand("logstest", function() 
    logCounts = 4
end)
RegisterNetEvent("esx_woodcutter:depositLog")
AddEventHandler("esx_woodcutter:depositLog", function()
    if carryingLog then
        local entityFound = false
        local playerPed = PlayerPedId()
        for k,v in pairs(woodEntities) do
            if GetEntityAttachedTo(v.entity) == playerPed then
                entityFound = true
                carryingLog = false
                DeleteEntity(v.entity)
                ClearPedTasks(playerPed)
                table.remove(woodEntities, k)
                ESX.ShowNotification("Has ~g~Dejado~w~ el tronco!")
                logCounts = logCounts + 1
                if logCounts >= 4 then
                    TriggerServerEvent("esx_woodcutter:logsReady", logCounts, job)
                    logCounts = 0
                end
                break
            end
        end
        if not entityFound then
            ESX.ShowNotification("~r~No puedes depositar ese tronco!")
        end
    else
        ESX.ShowNotification("~r~No llevas ningún tronco!")
    end
end)

RegisterNetEvent("esx_woodcutter:makeTreeFall")
AddEventHandler("esx_woodcutter:makeTreeFall", function(id)
    if id then
        if job == "woodcutter" then
            SetEntityHealth(treesEntities[id].entity, 0)
            treesEntities[id].isFalling = true
            treesEntities[id].treePos = GetEntityCoords(treesEntities[id].entity)
            destroyTree(treesEntities[id])
        end
    end
end)

function spawnWood(entity, min, max, item)
    local treeHeight = 10.0
    local random = math.random(min, max)
    local distances = treeHeight / random
    local actualOffset = 0
    for i = 1, random do
        spawnCoords = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, actualOffset)
        actualOffset = actualOffset + distances
        print(GetEntityCoords(entity).x, GetEntityCoords(entity).y, GetEntityCoords(entity).z)
        table.insert(woodEntities, spawnWoodEntity(spawnCoords, item))
    end
end

function spawnWoodEntity(spawnCoords, item)
    RequestModel("prop_log_01")
    while not HasModelLoaded("prop_log_01") do Citizen.Wait(50) end
    local newWood = CreateObject(GetHashKey("prop_log_01"), spawnCoords.x, spawnCoords.y, spawnCoords.z + 1.0, 0, 0, 0)
    while not DoesEntityExist(newWood) do Citizen.Wait(50) end
    ActivatePhysics(newWood)
    return {entity = newWood, item = item}
end

function setRespawnTimer(id)
    Citizen.CreateThread(function()
        Wait(200000)
        treesEntities[id] = spawnTree(id)
    end)
end

Citizen.CreateThread(function()   
    RequestModel("prop_logpile_03")
    while not HasModelLoaded("prop_logpile_03") do Citizen.Wait(50) end
    local logpile = CreateObject(GetHashKey("prop_logpile_03"), Config.woodpile.pos.x, Config.woodpile.pos.y, Config.woodpile.pos.z, 0, 0, 0)
    SetBlockingOfNonTemporaryEvents(logpile, true)
    FreezeEntityPosition(logpile, true)
    while true do
        local playerPed = PlayerPedId()
        Citizen.Wait(0)
        if PlayerData.job and PlayerData.job.name == "woodcutter" then
            if #(GetEntityCoords(playerPed) - Config.woodpile.pos) < 35 and carryingLog then
                DrawMarker(20, Config.woodpile.pos.x + 0.3, Config.woodpile.pos.y, Config.woodpile.pos.z + 2.6, 0.0, 0.0, 0.0, 0, 180.0, 0.0, 1.2, 1.2, 1.2, 0, 255, 0, 100, false, true, 2, true, false, false, false)
            else
                Citizen.Wait(1500)
                for k,v in pairs(mypallets) do
                    if (#(mypallets[k].iniCoords - GetEntityCoords(mypallets[k].entity)) > 5 ) then
                        TriggerServerEvent("esx_woodcutter:palletPosFree", k, job)
                    end
                end
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

AddEventHandler("enc0ded-forklift-trailer/put-down-pallet", function(palletEntity) 
    if DoesEntityExist(palletEntity.entity) then
        if #(GetEntityCoords(palletEntity.entity) - Config.DropZone.coords) < Config.DropZone.area then
            local netId = DecorGetInt(palletEntity.entity,"product_attached")
            local product = NetworkGetEntityFromNetworkId(netId)
            DeleteEntity(product)
            DeleteEntity(palletEntity.entity)
            TriggerServerEvent("palletDevlivered")
        end
    end
end)


----------------------------------------------------------------------------------------------------
--------------------------------PED GENERATION------------------------------------------------------
----------------------------------------------------------------------------------------------------

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteWomans()
    end
end)

local pedEntities = {}

DeleteWomans = function()
    for i=1, #pedEntities do
        local lumberjack = pedEntities[i]
        if DoesEntityExist(lumberjack) then
            --DeletePed(lumberjack)
            SetPedAsNoLongerNeeded(lumberjack)
        end
    end
end

Citizen.CreateThread(function()
    for i = 1, #Config.npc do
        hash = GetHashKey(Config.npc[i].hash)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
        if not DoesEntityExist(pedEntities[i]) then
            pedEntities[i] = CreatePed(4, hash, Config.npc[i].coords.x, Config.npc[i].coords.y, Config.npc[i].coords.z, Config.npc[i].heading)
            SetEntityAsMissionEntity(pedEntities[i])
            SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
            FreezeEntityPosition(pedEntities[i], true)
            SetEntityInvincible(pedEntities[i], true)
        end
        SetModelAsNoLongerNeeded(hash)
    end
end)
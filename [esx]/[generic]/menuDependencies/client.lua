ESX = nil
ESX = exports.extendedmode:getSharedObject()

RegisterNetEvent("menuDependencies:tirarBasura")
AddEventHandler("menuDependencies:tirarBasura", function(entity) 
    takeAnimation(500)
    TriggerServerEvent("menuDependencies:tirarBasuraS","trash",1)
    --print("Tirando server")
end)

local trashes = {}
local searching = false
local alreadySearched = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for key, entity in pairs(trashes) do
            if not DoesEntityExist(entity) then
                table.remove(trashes,key)
            end
        end
    end
end)

local function entityTakeControl(entity)
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) do
        Citizen.Wait(100)
    end
end

local propsTaken = {}
local sizePropsTaken = 0
local maxTotalSizeProp = 2.7

function calculateAverageSizeValue(min,max)
    local result = max - min
    if result.z < 1.0 then
        return result.x + result.y + result.z
    else
        return 5
    end
end

AddEventHandler("menu:takeProp", function(takeType,entity)
    Citizen.CreateThread(function() 
        if takeType == "both" then      
            local min, max  = GetModelDimensions(GetEntityModel(entity))
            local size = calculateAverageSizeValue(min,max)
            if size < maxTotalSizeProp then
                local Erotation = GetEntityRotation(entity)
                local playerPed = PlayerPedId()
                --local netid = ObjToNet(entity)
                local objcoords = GetEntityCoords(entity)
                local duplicatedObject
                local createdObject
                local delete = true
                if not NetworkGetEntityIsNetworked(entity)then
                    duplicatedObject = CreateObject(GetEntityModel(entity), objcoords.x,objcoords.y,objcoords.z, 1, 1, 1)
                    createdObject = ObjToNet(duplicatedObject)
                else
                    delete = false
                    duplicatedObject = entity
                    createdObject = ObjToNet(duplicatedObject)
                end
                Citizen.Wait(100)
                print(size .. " <?".. maxTotalSizeProp)
                print("size object"..size)
                if (sizePropsTaken + size) < maxTotalSizeProp then
                    entityTakeControl(entity)
                    sizePropsTaken = sizePropsTaken + size
                    table.insert(propsTaken, {entity = duplicatedObject, delete = delete})
                    RequestAnimDict("anim@heists@box_carry@")
                    while not HasAnimDictLoaded("anim@heists@box_carry@") do
                        Citizen.Wait(300)
                    end
                    --print("Entity:" ..duplicatedObject)
                    Citizen.Wait(100)
                    AttachEntityToEntity(duplicatedObject, playerPed, GetPedBoneIndex(playerPed,28422), 0.11, -0.02, 0.001, Erotation.x, Erotation.y, Erotation.z, true, true, false, true, 1, true)
                    Citizen.Wait(100)
                    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
                    local entito = GetEntityAttachedTo(playerPed)
                    print("Size: ".. sizePropsTaken)
                    if delete then
                        SetEntityAsMissionEntity(entity)
                        DeleteObject(entity)
                    end
                else
                    AttachEntityToEntity(entity, playerPed, GetPedBoneIndex(playerPed,28422), 0.11, -0.02, 0.001, Erotation.x, Erotation.y, Erotation.z, true, true, false, true, 1, true)
                    Citizen.Wait(100)
                    DetachEntity(entity, true, false)
                    if delete then
                        SetEntityAsMissionEntity(entity)
                        DeleteObject(entity)
                    end
                    print("NOPE")
                end
            end
        -- DetachEntity(entity,true,false)
        elseif takeType == "right" then
            -- body
        elseif takeType == "left" then
        end
    end)
end)

function spawnAndTakeProp(model)
    RequestAnimDict("anim@heists@box_carry@")
    while not HasAnimDictLoaded("anim@heists@box_carry@") do
        Citizen.Wait(100)
    end
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(50) end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local object = CreateObject(GetHashKey(model), playerCoords.x, playerCoords.y, playerCoords.z, 1, 1, 1)
    while not DoesEntityExist(object) do
        Citizen.Wait(50)
    end
    AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, 28422), 0.11, -0.02, 0.001, 0, 0, 0, true, true, false, true, 1, true)
    Citizen.Wait(10)
    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
    print(object)
    return object
end
exports("spawnAndTakeProp", spawnAndTakeProp)

--AddEventHandler("menu:TakeAndPush", function(entity)
--Citizen.CreateThread(function()
--    local playerPed = PlayerPedId()
--    RequestAnimDict("anim@heists@box_carry@")
--    while not HasAnimDictLoaded("anim@heists@box_carry@") do
--        Citizen.Wait(300)
--    end
--    AttachEntityToEntity(entity, playerPed, GetPedBoneIndex(playerPed,28422), 0.11, -0.02, 0.001, -120.0, 0.0, 0.0, true, true, false, true, 1, true)
--    Citizen.Wait(100)
--    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
--end)
--end)


AddEventHandler("menuDependencies:handcuffnpc", function(entity) 
    RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(100)
		end
        ClearPedTasksImmediately(entity)
        ClearPedSecondaryTask(entity)
        TaskPlayAnim(entity, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
        
        SetEnableHandcuffs(entity, true)
        SetCurrentPedWeapon(entity, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        SetPedCanPlayGestureAnims(entity, false)
        
        Citizen.CreateThread(function() 
            Wait(2000)
            SetPedToRagdoll(entity, 20000, 20000, 0, 0, 0, 0)
        end)
end)

AddEventHandler("menuDependencies:handcuffplayer", function(entity) 

end)

RegisterNetEvent("menuDependencies:burnIt")
AddEventHandler("menuDependencies:burnIt", function(entity) 
    print("PRENDIENDO")
    Citizen.CreateThread(function() 
        local cco = GetEntityCoords(entity)
        StartScriptFire(
            cco.x --[[ number ]], 
            cco.y --[[ number ]], 
		    cco.z --[[ number ]], 
            20 --[[ integer ]], 
            true --[[ boolean ]]
	    )
        Wait(5000)
        StopEntityFire(entity)
        AddExplosion(
            cco.x --[[ number ]],   
            cco.y --[[ number ]], 
            cco.z --[[ number ]], 
            "EXPLOSION_STICKYBOMB" --[[ integer ]], 
            8.0 --[[ number ]], 
            true --[[ boolean ]], 
            false --[[ boolean ]], 
            true --[[ number ]]
        )
    end)

end)

local counterTouch=0
RegisterNetEvent("menuDependencies:Electro")
AddEventHandler("menuDependencies:Electro", function(entity) 
    counterTouch = counterTouch + 1
    if counterTouch >= 3 then
        print(counterTouch)
        local ped = PlayerPedId()
        local cco = GetEntityCoords(ped)
        ShootSingleBulletBetweenCoords(cco.x,cco.y,cco.z-.1,cco.x,cco.y,cco.z+.1,25,false,GetHashKey("weapon_stungun"),0,false,false,1.0)
        --ShootSingleBulletBetweenCoords(
        --    cco.x --[[ number ]], 
        --    cco.y --[[ number ]], 
        --    cco.z --[[ number ]], 
        --    cco.x --[[ number ]], 
        --    cco.y --[[ number ]], 
        --    cco.z --[[ number ]], 
        --    20 --[[ integer ]], 
        --    0 --[[ boolean ]], 
        --    GetHashKey("WEAPON_STUNGUN") --[[ Hash ]], 
        --    ped --[[ Ped ]], 
        --    true --[[ boolean ]], 
        --    true --[[ boolean ]], 
        --    8 --[[ number ]]
        --)
        counterTouch = 0
    end
end)

RegisterNetEvent("menuDependencies:buscarBasura")
AddEventHandler("menuDependencies:buscarBasura", function(entity) 
    alreadySearched = false
    if not searching then 
        for key, savedentity in pairs(trashes) do 
            if entity == savedentity then
                alreadySearched = true
            end
        end
    end
    if not searching and not alreadySearched then
    --print(getableObjects)
        searching = true
        Citizen.CreateThread(function()
            --PlayMyAnimation("amb@code_human_in_car_mp_actions@grab_crotch@low@ds@base","idle_a", 5000)
            switchBetweenAnimations("amb@code_human_in_car_mp_actions@grab_crotch@low@ds@base","enter","exit",1000,5000)
            local result = math.random(0,100)
            for item, chance in pairs(getableObjects) do
                if result < chance then
                    if item == "money" then
                        TriggerServerEvent("menuDependencies:getMoney", 50)
                    elseif item == "WEAPON_PISTOL" then
                        TriggerServerEvent("menuDependencies:getWeapon", item)
                    else
                        TriggerServerEvent("menuDependencies:getItem", item, 1)
                    end
                end
            end
            table.insert(trashes,entity)
            searching = false
        end)
        
    else
        if searching then
            ESX.ShowNotification("Ya estás buscando basura")
        elseif alreadySearched then
            ESX.ShowNotification("Ya has rebuscado en esta basura")
        end
    end
end)
--"amb@code_human_in_car_mp_actions@grab_crotch@low@ds@base"
function PlayMyAnimation(dict, name, time) 
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
        
    end

    --TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)
    TaskPlayAnim(PlayerPedId(), dict, name, 8.0, 1.0, -1, 50, 0, 0, 0, 0)
    Citizen.Wait(time)
    ClearPedTasks(PlayerPedId())
end


function switchBetweenAnimations(dict,name1,name2, timebetween,time)
    local going_time = 0
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    while going_time < time do
        TaskPlayAnim(PlayerPedId(), dict, name1, 8.0, 1.0, -1, 50, 0, 0, 0, 0)
        Citizen.Wait(timebetween)
        TaskPlayAnim(PlayerPedId(), dict, name2, 8.0, 1.0, -1, 50, 0, 0, 0, 0)
        going_time = going_time + timebetween
    end
    --TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)
    ClearPedTasks(PlayerPedId())
end

function takeAnimation(time)
    switchBetweenAnimations("amb@code_human_in_car_mp_actions@grab_crotch@low@ds@base","enter","exit",1000,time)
end
local decayTable = {}


RegisterCommand("dropTakenItems", function() 
    Citizen.CreateThread(function() 
        if #propsTaken > 0 then
            for k,v in pairs(propsTaken) do
                DetachEntity(v.entity, true, true)
                local pedCoords = GetEntityCoords(PlayerPedId())
                SetEntityCoords(v.entity, pedCoords.x,  pedCoords.y,  pedCoords.z - 0.95)
                
                Citizen.SetTimeout(120000, setDecay)
                Citizen.Wait(100)
                --FreezeEntityPosition(v, true)
                --Citizen.Wait(100)
                FreezeEntityPosition(v.entity, false)
                Citizen.Wait(100)
                --SetEntityHasGravity(v,true)
                if v.delete then
                    table.insert(decayTable, v)
                end
                table.remove(propsTaken,k)
                sizePropsTaken = 0
                ClearPedTasksImmediately(PlayerPedId())
            end
        end
    end)
end, false)

RegisterKeyMapping("dropTakenItems", "Soltar objetos en las manos", 'keyboard', "x")

function setDecay()
    for k,v in pairs(decayTable) do
        if not IsEntityAttached(v) then
            SetEntityAsMissionEntity(v)
            DeleteObject(v)
        else
            table.remove(decayTable, k)
        end
    end
end


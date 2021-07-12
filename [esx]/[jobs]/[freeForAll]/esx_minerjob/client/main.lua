local PlayerData                = {}
ESX                             = nil

local blip1 = {}
local blips = false
local blipActive = false
local mineActive = false
local washingActive = false
local remeltingActive = false
local firstspawn = false
local impacts = 0
local timer = 0
local locations = {
    { ['x'] = -591.47,  ['y'] = 2076.52,  ['z'] = 131.37},
    { ['x'] = -590.35,  ['y'] = 2071.76,  ['z'] = 131.29},
    { ['x'] = -589.61,  ['y'] = 2069.3,  ['z'] = 131.19},
    { ['x'] = -588.6,  ['y'] = 2064.03,  ['z'] = 130.96},
}

Citizen.CreateThread(function()
    while ESX == nil do
      ESX = exports.extendedmode:getSharedObject()
      Citizen.Wait(0)
    end
end)  

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent("esx_miner:washing")
AddEventHandler("esx_miner:washing", function()
    Washing()
end)

RegisterNetEvent("esx_miner:remelting")
AddEventHandler("esx_miner:remelting", function()
    Remelting()
end)

RegisterNetEvent('esx_miner:timer')
AddEventHandler('esx_miner:timer', function()
    local timer = 0
    local ped = PlayerPedId()
    
    Citizen.CreateThread(function()
		while timer > -1 do
			Citizen.Wait(150)

			if timer > -1 then
				timer = timer + 1
            end
            if timer == 100 then
                break
            end
		end
    end) 

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 5 then
                Draw3DText( Config.WashingX, Config.WashingY, Config.WashingZ, ('Dragado de piedras en progreso ' .. timer .. '%'), 4, 0.1, 0.1)
            end
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 5 then
                Draw3DText( Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, ('Fundicion de minerales en progreso ' .. timer .. '%'), 4, 0.1, 0.1)
            end
            if timer == 100 then
                timer = 0
                break
            end
        end
    end)
end)

RegisterNetEvent('esx_miner:createblips')
AddEventHandler('esx_miner:createblips', function()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(500)
            if blips == true and blipActive == false then
                blip1 = AddBlipForCoord(-597.01, 2091.42, 131.41)
                blip2 = AddBlipForCoord(Config.WashingX, Config.WashingY, Config.WashingZ)
                blip3 = AddBlipForCoord(Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ)
                blip4 = AddBlipForCoord(Config.SellX, Config.SellY, Config.SellZ)
                SetBlipSprite(blip1, 652)
                SetBlipColour(blip1, 5)
                SetBlipAsShortRange(blip1, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Mineria: Mina de CityName")
                EndTextCommandSetBlipName(blip1)   
                SetBlipSprite(blip2, 657)
                SetBlipColour(blip2, 5)
                SetBlipScale(blip2, 0.8)
                SetBlipAsShortRange(blip2, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Mineria: Dragado de piedras")
                EndTextCommandSetBlipName(blip2)   
                SetBlipSprite(blip3, 527)
                SetBlipColour(blip3, 5)
                SetBlipScale(blip3, 0.8)
                SetBlipAsShortRange(blip3, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Mineria: Fundicion y forja")
                EndTextCommandSetBlipName(blip3)
                SetBlipSprite(blip4, 617)
                SetBlipColour(blip4, 15)
                SetBlipScale(blip4, 0.8)
                SetBlipAsShortRange(blip4, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Mineria: Comerciante de minerales")
                EndTextCommandSetBlipName(blip4)    
                blipActive = true
            elseif blips == false and blipActive == false then
                RemoveBlip(blip1)
                RemoveBlip(blip2)
                RemoveBlip(blip3)
            end
        end
    end)
end)

Citizen.CreateThread(function()
    blip1 = AddBlipForCoord(Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ)
    SetBlipSprite(blip1, 85)
    SetBlipColour(blip1, 39)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mineria: Punto de encuentro")
    EndTextCommandSetBlipName(blip1)   
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteMiners()
    end
end)

local pedEntities = {}

DeleteMiners = function()
    for i=1, #pedEntities do
        local miner = pedEntities[i]
        if DoesEntityExist(miner) then
            --DeletePed(miner)
            --SetPedAsNoLongerNeeded(miner)
        end
    end
end

Citizen.CreateThread(function()
    local npcPositionList = {
        {x = Config.CloakroomX,  y = Config.CloakroomY,  z = Config.CloakroomZ, heading = 270.59, hash = 'ig_cletus'},
        {x = Config.WashingX,  y = Config.WashingY,  z = Config.WashingZ, heading = 177.15, hash = 's_m_m_dockwork_01'},
        {x = Config.RemeltingX,  y = Config.RemeltingY,  z = Config.RemeltingZ, heading = 0.0, hash = 's_m_y_construct_01'},
        {x = Config.SellX,  y = Config.SellY,  z =Config.SellZ, heading = 129.0, hash = 'ig_natalia'}
    }
    for i = 1, #npcPositionList do
        hash = GetHashKey(npcPositionList[i].hash)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
        if not DoesEntityExist(pedEntities[i]) then
            pedEntities[i] = CreatePed(4, hash, npcPositionList[i].x, npcPositionList[i].y, npcPositionList[i].z, npcPositionList[i].heading)
            SetEntityAsMissionEntity(pedEntities[i])
            SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
            FreezeEntityPosition(pedEntities[i], true)
            SetEntityInvincible(pedEntities[i], true)
        end
        SetModelAsNoLongerNeeded(hash)
    end
    TaskStartScenarioInPlace(pedEntities[1], "WORLD_HUMAN_SMOKING", 0, true)
end)

local wrongJob = 'No eres ~g~MINERO~w~!'

RegisterNetEvent('esx_miner:wash_ui')
AddEventHandler('esx_miner:wash_ui', function()
    if PlayerData.job.name == 'miner' then
        ESX.TriggerServerCallback("esx_miner:checkJobRequeriments", function(canDoTheJob)
            if canDoTheJob then
                TriggerServerEvent("esx_miner:washing")
            else
                ESX.ShowNotification('Necesitas una furgoneta ~g~RUMPO~w~ y un ~g~PICO~w~ para poder llevar a cabo este trabajo!')
            end
        end)
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

RegisterNetEvent('esx_miner:melt_ui')
AddEventHandler('esx_miner:melt_ui', function()
    if PlayerData.job.name == 'miner' then
        ESX.TriggerServerCallback("esx_miner:checkJobRequeriments", function(canDoTheJob)
            if canDoTheJob then
                TriggerServerEvent("esx_miner:remelting")
            else
                ESX.ShowNotification('Necesitas una furgoneta ~g~RUMPO~w~ y un ~g~PICO~w~ para poder llevar a cabo este trabajo!')
            end
        end)
        
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

Citizen.CreateThread(function()
    while true do
        if PlayerData.job and PlayerData.job.name == 'miner' then
    	    local ped = PlayerPedId()
            local nearLoc = false
            Citizen.Wait(1)
            for i=1, #locations, 1 do
                if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 25 and mineActive == false then
                    nearLoc = true
                    DrawMarker(20, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 100.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                    if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 1 then
                        ESX.ShowHelpNotification("Pulsa ~INPUT_CONTEXT~ Para empezar a picar.")
                        if IsControlJustReleased(1, 51) then
                            Animation()
                            mineActive = true
                        end
                    end
                end
            end
            if not nearLoc then
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('esx_miner:cloak_ui_job')
AddEventHandler('esx_miner:cloak_ui_job', function()
    if PlayerData.job.name == 'miner' then
        ESX.TriggerServerCallback("esx_miner:checkJobRequeriments", function(canDoTheJob)
            if canDoTheJob then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                    else
                        TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                    end
                    blips = true
                    TriggerEvent("esx_miner:createblips")
                end)
            else
                ESX.ShowNotification('Necesitas una furgoneta ~g~RUMPO~w~ y un ~g~PICO~w~ para poder llevar a cabo este trabajo!')
            end
        end)
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

local currentSpawnedRumpo = nil

RegisterNetEvent('esx_miner:cloak_ui_vehicle')
AddEventHandler('esx_miner:cloak_ui_vehicle', function()
    if PlayerData.job.name == 'miner' then
        ESX.TriggerServerCallback("esx_miner:checkJobRequeriments", function(canDoTheJob)
            if canDoTheJob then
                if not DoesEntityExist(currentSpawnedRumpo) then
                    TriggerServerEvent("esx_miner:getRumpo")
                else
                    ESX.ShowNotification('Necesitas una furgoneta ~g~RUMPO~w~ y un ~g~PICO~w~ para poder llevar a cabo este trabajo!')
                end
            else
                ESX.ShowNotification('Necesitas una furgoneta ~g~RUMPO~w~ y un ~g~PICO~w~ para poder llevar a cabo este trabajo!')
            end
        end)
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

RegisterNetEvent('esx_miner:cloak_ui_civil')
AddEventHandler('esx_miner:cloak_ui_civil', function()
    if PlayerData.job.name == 'miner' then
         ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)  
        blips = false
        blipActive = false
        TriggerEvent("esx_miner:createblips")
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

RegisterNetEvent('esx_miner:sell_diamond')
AddEventHandler('esx_miner:sell_diamond', function()
    if PlayerData.job.name == 'miner' then
        TriggerServerEvent("esx_miner:selldiamond")
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

RegisterNetEvent('esx_miner:sell_gold')
AddEventHandler('esx_miner:sell_gold', function()
    if PlayerData.job.name == 'miner' then
        TriggerServerEvent("esx_miner:sellgold")
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

RegisterNetEvent('esx_miner:sell_iron')
AddEventHandler('esx_miner:sell_iron', function()
    if PlayerData.job.name == 'miner' then
        TriggerServerEvent("esx_miner:selliron")
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

RegisterNetEvent('esx_miner:sell_copper')
AddEventHandler('esx_miner:sell_copper', function()
    if PlayerData.job.name == 'miner' then
        TriggerServerEvent("esx_miner:sellcopper")
    else
        ESX.ShowNotification(wrongJob)
    end  
end)

function Animation()
    Citizen.CreateThread(function()
        while impacts < 3 do
            Citizen.Wait(1)
    		local ped = PlayerPedId()	
            RequestAnimDict("melee@large_wpn@streamed_core")
            Citizen.Wait(100)
            TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
            SetEntityHeading(ped, 270.0)
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'pickaxe', 0.5)
            if impacts == 0 then
                pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
            end  
            Citizen.Wait(2500)
            ClearPedTasks(ped)
            impacts = impacts+1
            if impacts == 3 then
                DetachEntity(pickaxe, 1, true)
                DeleteEntity(pickaxe)
                DeleteObject(pickaxe)
                mineActive = false
                impacts = 0
                TriggerServerEvent("esx_miner:givestone")
                break
            end        
        end
    end)
end

function Washing()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    washingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((pedEntities[2]), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    TriggerEvent("esx_miner:timer")
    Citizen.Wait(15900)
    ClearPedTasks(pedEntities[2])
    FreezeEntityPosition(ped, false)
    washingActive = false
end

function Remelting()
    local ped = PlayerPedId()
    remeltingActive = true
    FreezeEntityPosition(ped, true)
    TriggerEvent("esx_miner:timer")
    Citizen.Wait(15900)
    FreezeEntityPosition(ped, false)
    remeltingActive = false
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100 
    SetTextScale(0.35, 0.35)
    SetTextFont(fontId)
    SetTextProportional(0)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()   
end

ESX = exports.extendedmode:getSharedObject()

local npcconf = {
    position = vector3(170.376, -678.582, 42.609),
    heading = 128.706,
    hash = 'ig_djtalaurelia',
    entity = -1,
    animation = {dict = "amb@world_human_musician@guitar@male@idle_a", anim = "idle_b"},
    animation2 = {dict = "timetable@reunited@ig_10", anim = "base_amanda"},
    Prop = 'prop_acc_guitar_01',
    PropBone = 24818,
    PropPlacement = {-0.1, 0.31, 0.1, 0.0, 20.0, 150.0},
}

local playing = false

AddEventHandler("onResourceStop", function() 
    DeleteEntity(prop)
end)

AddEventHandler("artofguitar:openmenu", function() 

    if not isPlaying() then
        local elements = {}
        ESX.TriggerServerCallback('knatus_artofguitar:getmysongs', function(songs, mylevel) 
            for k,v in pairs(songs) do
                table.insert(elements, {
                    label = "Tocar "..v.label,
                    value = {value = v.value, guitar = v.guitar, name = k},
                })
            end
            --table.insert(elements, {label = 'Tocar '..label, value = "empty"})

            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'guitarra',
                {
                    title    = "Mis canciones | Nivel: "..mylevel,
                    align    = 'right',
                    elements = elements
                },
                function(data, menu)
                    --print(json.encode(data.current.value))
                    TriggerServerEvent("knatus_artofguitar:playsong", data.current.value)
                    menu.close()
                end,
                function(data, menu)
                    menu.close()
                end
            )
        end)
    else
        ESX.ShowNotification('¡Ya estás tocando la guitarra!')
    end
end)

function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
      RequestModel(GetHashKey(model))
      Wait(10)
    end
  end

Citizen.CreateThread(function()

        hash = GetHashKey(npcconf.hash)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
			Citizen.Wait(10)
		end
        if not DoesEntityExist(npcconf.entity) then
            npcconf.entity = CreatePed(4, npcconf.hash, npcconf.position.x, npcconf.position.y, npcconf.position.z, npcconf.heading)
            SetEntityAsMissionEntity(npcconf.entity)
            SetBlockingOfNonTemporaryEvents(npcconf.entity, true)
            FreezeEntityPosition(npcconf.entity, true)
            SetEntityInvincible(npcconf.entity, true)
            ESX.Streaming.RequestAnimDict(npcconf.animation.dict, function() 
                ESX.Streaming.RequestAnimDict(npcconf.animation2.dict, function() 
                    TaskPlayAnim(npcconf.entity, npcconf.animation2.dict, npcconf.animation2.anim, 2.0, 2.0, -1, 1, 0, false, false, false)
                    Wait(2000)
                    TaskPlayAnim(npcconf.entity, npcconf.animation.dict, npcconf.animation.anim, 2.0, 2.0, -1, 63, 0, false, false, false)
                    
                    local x,y,z = table.unpack(GetEntityCoords(npcconf.entity))

                    if not HasModelLoaded(npcconf.Prop) then
                        LoadPropDict(npcconf.Prop)
                    end

                    prop = CreateObject(GetHashKey(npcconf.Prop), x, y, z+0.2,  false,  false, false)
                    AttachEntityToEntity(prop, npcconf.entity, GetPedBoneIndex(npcconf.entity, npcconf.PropBone), -0.1, 0.31, 0.1, 0.0, 20.0, 150.0, true, true, false, true, 1, true)
                    --table.insert(PlayerProps, prop)
                    --PlayerHasProp = true
                    --SetModelAsNoLongerNeeded(prop1)
                end)
            end)
            --TaskStartScenarioInPlace(npcconf.entity, peds[i].animation, 0, true)
        end
        SetModelAsNoLongerNeeded(hash)
        --while true do
        --    Wait(5000)
        --    TaskPlayAnim(npcconf.entity, npcconf.animation.dict, npcconf.animation.anim, 2.0, 2.0, -1, 51, 0, false, false, false)
        --    TaskPlayAnim(npcconf.entity, npcconf.animation2.dict, npcconf.animation2.anim, 2.0, 2.0, -1, 1, 0, false, false, false)
        --end
end)


RegisterNetEvent("knatus_artofguitar:playsong")
AddEventHandler("knatus_artofguitar:playsong", function(song)

    ExecuteCommand("e "..song.guitar)
    playing = true
    exports.xsound:setSoundDynamic(song.name, true)
    
    Citizen.CreateThread(function() 
        local _song = song
        print(_song.name)
        while exports.xsound:soundExists(_song.name) and playing do
            Wait(1000)
            print("esta sonando!")
        end
        playing = false
        --TriggerEvent("esx_keymapings:cancelActions")
        ExecuteCommand("e c")
        TriggerServerEvent("knatus_artofguitar:songstopped", _song)
    end)
end)

RegisterNetEvent("knatus_artofguitar:listensong")
AddEventHandler("knatus_artofguitar:listensong", function(song)
    exports.xsound:setSoundDynamic(song.name, true)
end)


AddEventHandler('esx_keymapings:cancelActions', function() 
    print("cancelando!")
    if playing then
        playing = false
        print("cancelado!")
    end
end)

function isPlaying()
    return playing
end


exports('isPlaying', isPlaying)
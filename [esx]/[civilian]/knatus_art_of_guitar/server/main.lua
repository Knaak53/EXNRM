ESX = nil

ESX = exports.extendedmode:getSharedObject()

local playerPlaying = {}
ESX.RegisterServerCallback('knatus_artofguitar:getmysongs', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local songs = xPlayer.get("songs")
    local mylevel = "Dummy"
    for k,v in pairs(Config.levels) do
        if exports["gamz-skillsystem"]:getSkill(source,"Guitarra").Current > v.level then
            mylevel = v.label
        end
    end
    local finalSongs = {}
    if not songs then
        songs = {}
    end
    for k,v in pairs(songs) do
        if xPlayer.getInventoryItem(v.guitar).count > 0 then
            finalSongs[k] = v
        end
    end
    cb(finalSongs, mylevel)
end)

RegisterServerEvent("knatus_artofguitar:playsong")
AddEventHandler("knatus_artofguitar:playsong", function(song) 

    print(json.encode(song))
    playerPlaying[source] = true
    song.name = song.value..source
    exports.xsound:PlayUrlPos(-1, song.name,"sounds/"..song.value , 0.1, GetEntityCoords(GetPlayerPed(source)), false)
	local _source = source
    Citizen.CreateThread(function() 
        local __source = _source
        local _song = song 
		while playerPlaying[_source] do
            Wait(500)
            print("actualizando!")
			exports.xsound:Position(-1, _song.name, GetEntityCoords(GetPlayerPed(__source)))
		end
	end)
	--TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30, smoke_water, 1.0)
    TriggerClientEvent("knatus_artofguitar:playsong", source, song)
    TriggerClientEvent("knatus_artofguitar:listensong", -1, song)


end)

RegisterServerEvent("knatus_artofguitar:songstopped")
AddEventHandler("knatus_artofguitar:songstopped", function(song) 
    exports.xsound:Destroy(-1,song.name)
    playerPlaying[source] = false
end)

ESX.RegisterCommand("addsong", "superadmin", function(xPlayer, args, showError)
    local songs = args.playerId.get("songs")
    if not songs then
        songs = {}
    end
    for k,v in pairs(Config.songs) do
        if k == args.song then
            songs[k] = v
            args.playerId.set("songs", songs)
            print("cancion añadida: "..k)
        else
            --print("ERROR SONG")
        end
    end
end, true, {help = "añadir una cancion a tu repositorio", validate = true, arguments = {
    {name = 'playerId', help = "ID del player", type = 'player'},
    {name = 'song', help = "index de la cancion", type = 'string'}
    }})
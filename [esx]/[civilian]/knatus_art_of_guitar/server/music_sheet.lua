for k,v in pairs(Config.songs) do
    ESX.RegisterUsableItem(k, function(source)
        local i = k
        local j = v
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(i, 1)
    
        print("source? "..xPlayer.source)
        local level = exports["gamz-skillsystem"].getSkill(xPlayer.source, xPlayer.source,"Guitarra")
        for a,w in pairs(Config.levels) do
            for z,x in pairs(w.songs) do
                print(z .. " =? "..i)
                if z == i then
                    if level.Current >= w.level then

                        local songs = xPlayer.get("songs")
                        if not songs then
                            songs = {}
                        end
                        songs[i] = j
                        xPlayer.set("songs", songs)
                        xPlayer.showNotification("~g~¡Enhorabuena!~w~ Has aprendido la canción '".. j.label.."'")

                    else
                        xPlayer.showNotification("No tienes el ~r~nivel~w~ suficiente para aprender la canción '".. j.label.."'")
                    end
                end
            end
        end
    end)
end
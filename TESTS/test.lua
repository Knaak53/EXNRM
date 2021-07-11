ESX = exports.extendedmode:getSharedObject()

ExM = exports.extendedmode:getExtendedModeObject()

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        local p = promise.new()
       -- DoAsyncThingaa(function()
       --     -- This is in the async thing's callback
       --     print("yes?")
       --     p:resolve('whatever')
       -- end)
        print("waiting?")
        Citizen.Await(p)
        print("Everything is ok")
    end
end)


RegisterCommand("adminStressTest", function(source) 
	TriggerClientEvent('esx_status:set', source, "stress", 1)
end, true)


print("Jobs:"..json.encode(ESX.getJobs()))

RegisterCommand("testjobfunc", function(source) 
    print("Jobs:"..json.encode(ESX.getJobs()))
    local Jobs = ESX.getJobs()
    Jobs["Shop_3"].name = "EEhhpa"
    print("HOLA "..json.encode(Jobs["Shop_3"]))
    print("Jobs pol:"..json.encode(ESX.getJobs()["police"].grades))


end, false)

RegisterCommand("testpalletlocal", function() 

end)

RegisterCommand("testserverobject", function(source) 
    local coors = GetEntityCoords(GetPlayerPed(source))
    CreateObject(GetHashKey("prop_beer_box_01"), coors.x, coors.y, coors.z)
end)


RegisterCommand("testluatable", function(source)  
    local table = {}
    table[5] = true
    table[1] = true
    table[2] = nil
    table[37] = true

    for k,v in pairs(table) do
        print("h")
    end

    print(json.encode(table))
end)



RegisterCommand("testmyjpb", function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    print(json.encode(xPlayer.getJob()))

end, false)

RegisterCommand("testjobfuncEXM", function(source) 
	print("Jobs:"..json.encode(ExM.getJobs()))
end, false)


RegisterCommand("tururutest", function(source, args, rawCommand) 
    print("lanzando!")
    TriggerClientEvent("turururuyeah", source)
end, true)

function DoAsyncThing(cb)
    for i=0, 1000, 1 do
        print(i)
    end
    cb()
end


function DoAsyncThingaa(cb)
    Citizen.CreateThread(function(cb) 
        for i=0, 1000, 1 do
            print(i)
        end
        cb()
    end)
end


RegisterServerEvent("playguitartest")
AddEventHandler("playguitartest", function() 
    print("playing guitar")
    --exports.xsound:PlayUrl(source, "melodia_triste", "melodia_triste", 1.0, false)
    TriggerEvent('InteractSound_SV:PlayOnOne', source, "melodia_triste", 1.0)
end)

RegisterServerEvent("playnothingelse")
AddEventHandler("playnothingelse", function() 
    print("playing guitar")
    --exports.xsound:PlayUrl(source, "melodia_triste", "melodia_triste", 1.0, false)
    TriggerEvent('InteractSound_SV:PlayOnOne', source, "nothing_else", 1.0)
end)

RegisterServerEvent("playsmokewater")
AddEventHandler("playsmokewater", function()
    
    --exports.xsound:PlayUrl(source, "melodia_triste", "melodia_triste", 1.0, false)
    --TriggerEvent('InteractSound_SV:PlayOnOne', source, "smoke_water", 1.0)
end)


RegisterCommand("playsmokewater", function(source) 
	--"nui://xsound/html/sounds/smoke_water.ogg"
	--"nui://interact-sound/client/html/sounds/smoke_water.ogg"
	exports.xsound:PlayUrlPos(-1, "smoke_water_"..source,"sounds/smoke_water.ogg" , 1.0, GetEntityCoords(GetPlayerPed(source)), false)
	
    Citizen.CreateThread(function() 
        local _source = source
		local time = 0
		while time < 60 do
			Wait(500)
			exports.xsound:Position(-1, "smoke_water_"..source, GetEntityCoords(GetPlayerPed(_source)))
			time = time + 0.5
		end
	end)
	--TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 30, smoke_water, 1.0)
    TriggerClientEvent("playsmokewater", source)
end, false)


RegisterServerEvent("playcoolguitartest")
AddEventHandler("playcoolguitartest", function() 
    print("playing guitar")
    --exports.xsound:PlayUrl(source, "melodia_triste", "melodia_triste", 1.0, false)
    TriggerEvent('InteractSound_SV:PlayOnOne', source, "cool_guitar", 1.0)
end)

RegisterCommand("luasizetest", function(source, args, rawCommand) 
    print("Gargabge: "..collectgarbage('count'))
end, false)

RegisterCommand("spawnVehFar", function(source, args, rawCommand) 
    ExM.Game.SpawnVehicle("TRFLAT", GetEntityCoords(GetPlayerPed(source)))
    local CreateVehicle = GetHashKey('CREATE_AUTOMOBILE')
    local veh = Citizen.InvokeNative(CreateVehicle , GetHashKey("zentorno"), GetEntityCoords(GetPlayerPed(source)))
end, false)


--RegisterCommand("TestNames", function(source, args, rawCommand) 
--    local _source = source -- ejecutar ingame para que el source sea un jugador valido, si se ejecuta desde consola, será 0 y el test no será valido
--    local xPlayer = ESX.GetPlayerFromId(_source)
--
--    print("El nombre del usuario es: "..xPlayer.get("firstName").. " " ..xPlayer.get("lastName"))
--end, true)

--RegisterCommand("playOnAll",function()
--    ESX.PlaySoundOnAll('demo',0.5)
--end)



--RegisterCommand("jsonHelper",function()
--    local x={
--		title = 'Hola',
--		align = 'top-left',
--		elements = {
--			{label = "No",  value = 'no'},
--			{label = "Yes", value = 'yes'}
--		}
--	}
--    SaveResourceFile(GetCurrentResourceName(), "menus.json", json.encode(x), -1)
--end,false)


function magnitudeVector(vector)
    local magnitude = math.sqrt(vector.x + vector.y + vector.z)
    return magnitude
end

function distanceBetween(vector1, vector2)
    local magnitude1 = magnitudeVector(vector1)
    local magnitude2 = magnitudeVector(vector2)
    return math.abs(vector1 - vector2)
end
PlayerCars = {}
PlayersTest = {}
--local plate = "ABC 346"
--for k,v in pairs(ESX.GetPlayers()) do 
--    if v % 20 == 0 then
--        Wait(0)
--    end
--    local xPlayer = ESX.GetPlayerFromId(v)
--    if xPlayer.getJob().name == company then
--        table.insert(PlayersCars[v],plate)
--        TriggerClientEvent("s2v_parkings:syncPlayerCars",v,PlayersCars[v])
--    end
--end
RegisterCommand("testGetPlayers", function() 
Citizen.CreateThread(function() 
    for k,v in pairs(ESX.GetPlayers()) do
        print("K es: "..k)
        if k % 50 == 0 then
            Wait(0)
        end
        local xPlayer = ESX.GetPlayerFromId(v)
    end
    print("finish")
end)
end, true)


RegisterCommand("inittestGetPlayer", function() 
    for i=1, 1000, 1 do
        PlayersTest[i] = 1
    end
end, true)

RegisterServerEvent('mostrarcomo')
AddEventHandler('mostrarcomo', function(data)
    print(data)
    print(json.encode({collection = "users",query = {Identifier = "Hola"},update = {["$set"]= {Name = "Pepito"}}}))
    print(json.encode(data))
end)

--AddEventHandler("weaponDamageEvent", function(damageType, weaponType, overrideDefaultDamage, hitEntityWeapon) 
--    if hitEntityWeapon then
--        print("dio")
--    else
--        print("no dio")
--    end
--
--end)


--RegisterCommand("niltesting", function() 
--    if not 0 then
--        print("poh si")
--    else
--        print("poh no")
--    end
--end, false)


--RegisterCommand("testingvehiclespa", function(source) 
--    local xPlayer = ESX.GetPlayerFromId(source)
--    ExM.Game.SpawnVehicle(GetHashKey("zentorno"), xPlayer.getCoords(true))
--end, true)

-----Pruebas RPC

--RegisterCommand('RPC',function()
--    print(Citizen.GetFunctionReference(function()
--        return "Hola"
--    end))
--    InvokeRpcEvent(source,Citizen.GetFunctionReference(function()
--        return "Hola"
--    end),{})
--    --print(rawget(, '__cfx_functionReference'))
--    -- Citizen.CreateThread(function()
--    --     InvokeRpcEvent(source,rawget(Hola, '__cfx_functionReference'))
--    -- end)
--end)




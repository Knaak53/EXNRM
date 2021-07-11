------------------
-- CONFIG START --
------------------
ESX = nil

-- Messages
startText = "Pulsa ~g~E ~w~para empezar ~g~Tu ruta ~w~desde ~g~%s~w~"
startTextSpecial = "Pulsa ~g~E ~w~Para empezar una ~g~Ruta express ~w~desde ~g~%s~w~"
pickupText = "Pulsa ~g~E ~w~para recoger ~g~%s ~w~de ~g~%s~w~"
invalidVehicleText = "Necesitas un ~g~BUS ~w~para hacer eso!"
tooLowTierText = "Las rutas express solo pueden realizarse con buses de tipo: ~g~Coaches"
engineRunningText = "Para ~r~COMPLETAMENTE ~w~antes de dejar subir a tus pasajeros!"

xOutOfY = "~w~[~y~%i~w~/~y~%i~w~]"

vehicleFullMessage = "El autobus esta ~r~Lleno~w~"
capacityMessage = "~g~%s actual " .. xOutOfY
continueMessage = "Continua la ruta: ~g~%s" .. xOutOfY

startRouteMessage = "Completa la ruta: ~g~%s"
jobDoneMessage = "Ruta finalizada, vuelve a la central para empezar otra ruta"

-- Methods
engineNeedsToBeOff = true 

-- Map Blips
job_blips = {
    {name = "Servicio de autobus Ciudad de Caronte", x = 454.09, y = -604.43},
    {name = "Servicio de autobus Sandy Shores", x = 1997.38, y = 3779.69},
    {name = "Servicio de autobus Paleto Bay", x = -351.94, y = 6068.86}
}

-- Blip Settings
job_blip_settings = {
    start_blip = {id = 513, color = 38},
    destination_blip = {id = 536, color = 69},
    marker = {r = 180, g = 0, b = 0, a = 200},
    marker_special = {r = 70, g = 255, b = 0, a = 200},
}

-- Locations
ls_routes = {
    {
        {name = "Maze Bank Arena", 		x = -307.695801, y = -1844.940430, z = 23.845625},
        {name = "Strawberry Avenue", 	x = -43.776791, y = -1648.477661, z = 28.033178},
        {name = "Carson Avenue", 		x = 50.928295, y = -1536.593506, z = 28.018265},
        {name = "Adam's Apple Blv", 	x = 98.416206, y = -1055.010620, z = 28.118307},
        {name = "San Andreas Avenue", 	x = 115.008423, y = -784.036377, z = 30.126572},
        {name = "San Vitus Blvd", 		x = -256.629272, y = -330.119690, z = 28.699272},
        {name = "Boulevard Del Perro", 	x = -490.618530, y = 20.407391, z = 43.791027},
        {name = "Strangeways Drive", 	x = -693.450562, y = -5.167409, z = 37.019169},
        {name = "Mad Wayne Thunder Dr", x = -931.669128, y = -126.633087, z = 36.415554},
        {name = "Marathon Avenue", 		x = -1047.878540, y = -389.459473, z = 36.419994},
        {name = "Rockford Hills", 		x = -679.639771, y = -376.881226, z = 33.043865},
        {name = "Ginger Street", 		x = -652.388367, y = -607.065369, z = 32.059444},
        {name = "Vespucci Blvd", 		x = -558.416321, y = -846.186951, z = 26.312037},
        {name = "La Puerta Fwy", 		x = -250.537796, y = -883.167053, z = 29.415934},
    },
    {
        {name = "Textile City", x = 307.135803, y = -766.019043, z = 28.227528},
        {name = "Strawberry Metro Station", x = 261.568085, y = -1217.424927, z = 28.424841},
        {name = "Davis Sherrif's Office", x = 364.583069, y = -1568.484009, z = 28.203512},
        {name = "Billingsgate Motel", x = 574.867859, y = -1734.191040, z = 28.182583},
        {name = "Little Bighorn Ave", x = 774.118408, y = -1752.040039, z = 28.409100},
        {name = "Popular Street", x = 879.431213, y = -1766.265015, z = 28.894323},
        {name = "Amarillo Vista", x = 1303.761475, y = -1648.289551, z = 50.393467},
        {name = "El Burro Heights Gas Station", x = 1191.970215, y = -1421.047852, z = 34.044270},
        {name = "Olympic Fwy", x = 806.741638, y = -1353.140259, z = 25.286720},
        {name = "Popular Street", x = 785.882019, y = -775.321411, z = 25.329002},
        {name = "Occupation Avenue", x = 428.806915, y = -359.720764, z = 46.116802},
        {name = "Power Street", x = 160.195572, y = -372.077209, z = 41.672024},
        {name = "Union Depository", x = 41.333294, y = -706.174377, z = 43.126556},
        {name = "Downtown Parking Garage", x = -335.592316, y = -683.291138, z = 31.849171},
        {name = "Alta Street", x = -86.832825, y = -652.732300, z = 35.105892},
        {name = "Low Power Street", x = 70.441124, y = -627.019653, z = 30.579842},
        {name = "Vespucci Blvd", x = 62.284081, y = -996.830688, z = 28.256859}
    },
    {   
        {name = "Vespucci Beach", x = -1456.489258, y = -967.370056, z = 6.261691},
        {name = "Vespucci Beach", x = -1352.111206, y = -1113.946533, z = 3.407488},
        {name = "Vespucci Beach", x = -1321.315552, y = -1292.585571, z = 3.940287},
        {name = "Vespucci Beach", x = -1286.420532, y = -1396.484009, z = 3.523031},
        {name = "Aguja Street", x = -1167.743652, y = -1472.403931, z = 3.280961},
        {name = "Melanoma Street", x = -1087.516235, y = -1586.963745, z = 3.321031},
        {name = "La Puerta Apartments", x = -944.724731, y = -1527.015015, z = 4.056648},
        {name = "La Puerta Apartments", x = -993.357361, y = -1441.655884, z = 4.072592},
        {name = "Vista Del Mar Apartments", x = -1037.417603, y = -1532.505371, z = 4.053168},
        {name = "The Wiseroy", x = -830.088196, y = -1218.166382, z = 5.931358},
        {name = "La Puerta Marina", x = -800.468201, y = -1332.293945, z = 3.997653},
        {name = "Higgins Helitours", x = -716.186951, y = -1405.214233, z = 3.997248},
        {name = "Little Seoul Gas Station", x = -524.743774, y = -1198.608643, z = 17.541819},
        {name = "Little Seoul Tram Station", x = -521.956665, y = -1302.051392, z = 27.012049},
        {name = "La Puerta Gas Station", x = -322.942200, y = -1443.668823, z = 29.714195},
        {name = "Carson Avenue", x = -21.008894, y = -1378.070068, z = 28.275986}
    }
}

sandy_routes = {
    {
        {name = "Otto's Auto Parts",            x = 1934.254883, y = 3717.046631, z = 31.419857},
        {name = "Sandy Shores EMS Center",      x = 1852.423828, y = 3669.115479, z = 32.922707},
        {name = "Sandy Shores Fire Station",    x = 1708.511719, y = 3584.693359, z = 34.450268},
        {name = "Sandy Shores Motel",           x = 1614.452759, y = 3599.380859, z = 34.141155},
        {name = "Liquor Ace",                   x = 1404.076904, y = 3596.956055, z = 33.878101},
        {name = "Outskirt Liquor Marker",       x = 914.946106, y = 3611.223389, z = 31.777626},
        {name = "Zancudo River",                x = 323.576447, y = 3573.897217, z = 32.566010},
        {name = "Outskirts Market",             x = 461.751740, y = 3574.130371, z = 32.234318},
        {name = "Outskirts Junk Yard",          x = 1276.636353, y = 3636.295166, z = 32.254848},
        {name = "The Boat House",               x = 1537.832153, y = 3769.875000, z = 33.045795},
        {name = "Sandy Shores Ammu-Nation",     x = 1718.996094, y = 3759.021729, z = 33.037987},
        {name = "Sandy Shores St.",             x = 1700.300049, y = 3885.505859, z = 33.810108},
        {name = "Sandy Shores Grocery Store",   x = 1963.717896, y = 3854.875732, z = 30.984299},
        {name = "Sandy Shores Gas Station",     x = 1992.588745, y = 3761.645264, z = 31.175697},
    },
    {
        {name = "Sandy Shores Gas Station",     x = 1991.923950, y = 3760.260986, z = 31.173931},
        {name = "Grapeseed Auto Repairs",       x = 2503.481445, y = 4102.588867, z = 37.249912},
        {name = "Grapeseed Cattle Farm",        x = 2547.243652, y = 4692.306152, z = 32.609898},
        {name = "Grapeseed Substation",         x = 2575.273193, y = 5081.580566, z = 43.642788},
        {name = "Chiliad Trail",                x = 2467.405029, y = 5120.727051, z = 45.637135},
        {name = "Grapeseed Farms",              x = 2285.321045, y = 5032.166016, z = 42.794975},
        {name = "Union Grain",                  x = 2079.138184, y = 5010.342773, z = 39.909019},
        {name = "Grapeseed Gas Station",        x = 1680.080811, y = 4936.329102, z = 41.101730},
        {name = "Grapeseed Centre",             x = 1665.092651, y = 4823.284180, z = 40.986298},
        {name = "Grapeseed Centre",             x = 1690.948608, y = 4683.540527, z = 41.977924},
        {name = "Alamo Fruit Market",           x = 1793.002075, y = 4578.837891, z = 35.839657},
        {name = "McKenzie Field",               x = 2101.956055, y = 4748.267090, z = 40.160950},
        {name = "Grapeseed Fruit Vendor",       x = 2479.939209, y = 4446.204102, z = 34.371422},
        {name = "Grapeseed Liquor Market",      x = 2468.885986, y = 4059.290283, z = 36.595963},
        {name = "Outskirts Underpass",          x = 2314.218262, y = 3840.397217, z = 33.808651},
        {name = "Sandy Shores Substation",      x = 2069.545166, y = 3714.340088, z = 31.904259},
    }
}

paleto_routes = {
    {
        {name = "Paleto Bay Market", x = -389.286926, y = 6057.842285, z = 30.496717},
        {name = "Paleto Bay Bus Stop", x = -331.934662, y = 6192.689453, z = 30.266617},
        {name = "The Hen House", x = -326.344421, y = 6261.967285, z = 30.369061},
        {name = "South Seas Apartments", x = -173.986389, y = 6455.390137, z = 29.879629},
        {name = "Paleto Bay Centre", x = -73.135674, y = 6453.126465, z = 30.274168},
        {name = "Paleto Bay Truck Stop", x = 137.652603, y = 6636.105957, z = 30.627174},
        {name = "Zancudo Grain Growers", x = 425.742310, y = 6555.231934, z = 26.183887},
        {name = "Outskirts Gas Station", x = 1701.486328, y = 6410.923340, z = 31.959030},
        {name = "Up-n-Atom Diner", x = 1584.058472, y = 6440.204102, z = 23.964773},
        {name = "Paleto Bay Warehouses", x = 52.838566, y = 6447.492188, z = 30.351645},
        {name = "Cluckin' Bell Factory", x = -21.842253, y = 6267.696777, z = 30.215376},
        {name = "Paleto Bay Hwy Stop", x = -215.601974, y = 6172.683105, z = 30.216635},
        {name = "Paleto Bay Ammu-Nation", x = -318.693695, y = 6071.897949, z = 30.260986},
    }
}

zancudo_routes = {
    {
        {name = "Shelter 4", x = -2301.510010, y = 3214.237793, z = 32.615788},
        {name = "Aircraft Hangar 1", x = -2157.261475, y = 3314.906982, z = 32.609871},
        {name = "Aircraft Hangar 2", x = -2025.650879, y = 3242.662842, z = 32.609516},
        {name = "Aircraft Hangar 2 Loading Bay", x = -1967.554688, y = 3153.518066, z = 32.610298},
        {name = "Aircraft Hangar 0101", x = -1804.243164, y = 2879.348145, z = 32.607800},
        {name = "Fort Zancudo Fire Station", x = -2087.227051, y = 2841.295410, z = 32.610172},
        {name = "Fuel Station", x = -2439.362305, y = 2994.418945, z = 32.609871},
        {name = "Aircraft Hangar 3499", x = -2459.139648, y = 3345.497314, z = 32.627720},
        {name = "Gate", x = -2284.899170, y = 3375.904541, z = 31.248135},
        {name = "Barracks", x = -1824.799194, y = 3299.621094, z = 32.702354},
        {name = "Barracks", x = -1738.645996, y = 3250.994141, z = 32.670261},
        {name = "Warehouses", x = -1745.656860, y = 3095.125488, z = 32.635269},
        {name = "Gate", x = -1608.623779, y = 2811.175781, z = 17.326830},
        {name = "Parking", x = -1747.514893, y = 2950.079346, z = 32.605946},
        {name = "ATC Tower 2", x = -2420.900391, y = 3277.247314, z = 32.630661},
    }
}

-- Job Start markers
job_starts = {
    {name = "Los Santos Bus Service", x = 453.61, y = -604.43, z = 27.07, tier = 1, routes = ls_routes, hash = 'ig_talina', heading = 257.92},
    {name = "Sandy Shores Bus Service", x = 1997.38, y = 3779.69, z = 31.18, tier = 1, routes = sandy_routes, hash = 'ig_chengsr', heading = 164.15},
    {name = "Paleto Bay Bus Service", x = -351.94, y = 6068.86, z = 30.5, tier = 1, routes = paleto_routes, hash = 'ig_jimmyboston', heading = 38.97}
}

job_ends = {
    {x = 471.31, y = -581.45, z = 28.5},
    {x = 1982.35, y = 3783.02, z = 32.21},
    {x = -365.98, y = 6062.11, z = 32.36}
    --{x = 460.0, y = -625.0, z = 27.5}
}

vehicle_spawns = {
    {x = 477.38, y = -581.5, z = 27.5},
    {x = 1968.79, y = 3768.25, z = 31.2},
    {x = -354.85, y = 6067.59, z = 30.5}
}

vehicle_spawn_points = {
    {x = 461.67, y = -611.53, z = 28.5, h = 208.64},
    {x = 1993.45, y = 3768.84, z = 32.2, h = 239.86},
    {x = -353.86, y = 6078.85, z = 31.47, h = 129.61}
}

-- Vehicles plus tiers
job_vehicles = {
    {name = "BUS", tier = 1}
}

-- Localized names for peds
ped_names = {
    ["default"] = "Pasajeros"
}

-- Payment multiplier for ped
ped_payment = {
    ["default"] = 1.0
}

-- Models peds can use (chosen randomly)
ped_models = {
    "A_M_Y_GenStreet_01",
    "A_M_M_Business_01",
    "A_M_Y_Hiker_01",
}
----------------
-- CONFIG END --
----------------

Citizen.CreateThread(function()
    while ESX == nil do
      ESX = exports.extendedmode:getSharedObject()
      Citizen.Wait(0)
    end
    for k,v in next, job_blips do 
        local blip = AddBlipForCoord(v.x, v.y, 0) 
        SetBlipSprite(blip, job_blip_settings.start_blip.id)
        SetBlipColour(blip, job_blip_settings.start_blip.color)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        setBlipName(blip, v.name)
    end
end)

local debugMarkers = {}

RegisterNetEvent("gd_jobs_bus:startJob")
AddEventHandler("gd_jobs_bus:startJob",
    function(start, tier)
        startJob(start, tier)
    end
)

RegisterNetEvent("bus_stopjob")
AddEventHandler("bus_stopjob", function()
        cancelJob()
end)

function getRandomPedModel()
    local mod = ped_models[math.random(#ped_models)]
    return mod
end

function drawMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    DrawMarker(39, x, y, z, 0,0,0,0,0,0,3.0,3.0,3.0,marker.r,marker.g,marker.b,marker.a,0,1,0,0)
end

function drawJobMarker(x,y,z,s)
    marker = job_blip_settings.marker_special
    DrawMarker(6, x, y, z + 1.5, 0,0,0,0,0,0,3.0,3.0,3.0,marker.r,marker.g,marker.b,marker.a,0,1,0,0)
end


local current_job = {}

function setNewDestination(pos)
--    if DoesBlipExist(current_job.blip) then RemoveBlip(current_job.blip) end
--    current_job.blip = AddBlipForCoord(pos.x, pos.y, pos.z)
--    setBlipName(current_job.blip, pos.name)
--    SetBlipRoute(current_job.blip, true)
end

function setBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip) 
end

function getRandomLocation(tier)
    local loc = 0
    repeat
        loc = job_pickups[math.random(#job_pickups)]
    until loc.tier <= tier
    return loc
end
    
function generateBlipsFromRoute(route)
    for k,v in next, route do
        local blip = AddBlipForCoord(v.x, v.y, 0)
        SetBlipScale(blip, 0.75)
        SetBlipSprite(blip, job_blip_settings.destination_blip.id)
        SetBlipColour(blip, job_blip_settings.destination_blip.color)
        setBlipName(blip, "(Ruta) " .. v.name)
        v.blip = blip
    end
end

function table.clone(org)
  return {table.unpack(org)}
end

function startJob(start, tier)
    if isOnJob() then
        cancelJob()
    end
    current_job.previous = start
    current_job.start = start
    current_job.route = start.routes[math.random(#start.routes)]
    current_job.total_stops = #current_job.route
    generateBlipsFromRoute(current_job.route)
    current_job.cargo = {name = ped_names["default"], pay = ped_payment["default"]}
    if tier == 5 then
        current_job.cargo = {name = ped_names["coach"], pay = ped_payment["coach"]}
    end
    current_job.tier = tier
    current_job.fares = 0
    current_job.peds = {}

    setNewDestination(current_job.marker)
    ESX.ShowNotification('Se te ha asignado una ~g~RUTA')
end

function createPedsThatEnterVehicle(number)
    local peds = {}
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local pos = GetEntityCoords(veh)
    local _model = getRandomPedModel()
    local model = GetHashKey(_model)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(1) end
    
    local _peds = 0
   
    
    for _i = 1, GetVehicleMaxNumberOfPassengers(veh) do
        if _peds >= number then break end
        if not DoesEntityExist(GetPedInVehicleSeat(veh, _i)) then 
            local ped = CreatePed(4, model, pos.x + GetEntityForwardX(veh) * (6 + _peds), pos.y + GetEntityForwardY(veh) * (6 + _peds), pos.z, 0, true, 0)
            TaskEnterVehicle(ped, veh, 1000, _i, 1.0, 3, 0)
            table.insert(peds, ped)
            _peds = _peds + 1
        end
    end  
    return peds
end

function makePedsLeaveTheVehicle(number)
    local _i = 0
    for _i = 1, number do
        if next(current_job.peds) ~= nil then
            local ped = current_job.peds[math.random(#current_job.peds)]
            if DoesEntityExist(ped) then
                TaskLeaveAnyVehicle(ped, 0, 0)
                SetTimeout(3000, function()
                    RemovePedElegantly(ped) 
                end)
            end
        end
    end
end

function pickupJob(id)
    local p = table.remove(current_job.route, id)
    local supply = math.random(p.supply or 3)
    local demand = math.random(p.demand or 5)
    
    makePedsLeaveTheVehicle(demand)
    RemoveBlip(p.blip)
    p.blip = nil
    
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local peds = createPedsThatEnterVehicle(supply)    
    local newpeds = 0
    if next(peds) ~= nil then
        for k,v in next, peds do
            newpeds = newpeds + 1
            table.insert(current_job.peds, v)
        end
    end
    
    current_job.fares = current_job.fares + newpeds
    
    TriggerServerEvent("gd_jobs_bus:pickupJob", newpeds, current_job.cargo.pay, current_job.tier)
    if (#current_job.route > 0) then
        drawMessage(string.format(continueMessage, '', current_job.total_stops - #current_job.route, current_job.total_stops))
    else
        deliverJob()
    end
end

function deliverJob()    
    TriggerServerEvent("gd_jobs_bus:finishJob", current_job.fares, current_job.cargo.pay, current_job.tier)
    drawMessage(string.format(jobDoneMessage, current_job.cargo.name))
    cancelJob()
end

function isOnJob()
    return (next(current_job) ~= nil)
end

function cancelJob()
    -- Remove all blips
    if current_job.route ~= nil and next(current_job.route) ~= nil then
        for k,v in next, current_job.route do
            if DoesBlipExist(v.blip) then
                RemoveBlip(v.blip)
            end
        end
    end
    
    -- Make peds exit vehicle and fuck off
    if current_job.peds ~= nil and next(current_job.peds) ~= nil then
        for k,v in next, current_job.peds do
            if DoesEntityExist(v) then
                TaskLeaveAnyVehicle(v, 0, 0)
                SetTimeout(3000, function()
                    RemovePedElegantly(v) 
                end)
            end
        end
    end

    current_job = {}

    Citizen.Wait(250)
    local pedVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(pedVehicle) and isInValidVehicle() then
        DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    end

    ESX.ShowNotification('Has terminado de trabajar')                                
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

function drawMessage(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 20000, false)
end

function isInValidVehicle()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local validVehicle = false
    for k,v in next, job_vehicles do
        if GetEntityModel(veh) == GetHashKey(v.name) then validVehicle = true break end 
    end
    return validVehicle
end

function promptJob(location)
    startJob(location, 1)        
end

local isBusDriver = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
    if job.name == 'bus' then
        isBusDriver = true
    else
        isBusDriver = true
    end
end)


function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (GetDistanceBetweenCoords(x, y, z, p.x, p.y, p.z) < 4 and zDist < 4) 
end

function nearLittleMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (GetDistanceBetweenCoords(x, y, z, p.x, p.y, p.z) < 1.4 and zDist < 4) 
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

function getCurrentTier()
    local tier = 0
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    if veh then
        for k,v in next, job_vehicles do
             if GetEntityModel(veh) == GetHashKey(v.name) then tier = v.tier break end 
        end
    end
    return tier
end

local hasBus = false
local waiting = false

function spawnVehicle(i)
    if not hasBus then
        ESX.Game.SpawnVehicle(GetHashKey('bus'), vector3(vehicle_spawn_points[i].x, vehicle_spawn_points[i].y, vehicle_spawn_points[i].z), vehicle_spawn_points[i].h, function(callback_vehicle)
            waitForAnotherBus()
        end)
    else
        ESX.ShowNotification('Tienes que ~g~DEVOLVER~w~ el bus actual o ~g~ESPERAR~w~ para poder solicitar otro autobus .')
    end
end

function waitForAnotherBus()
    Citizen.CreateThread(function()
        hasBus = true
        Citizen.Wait(60000 * 30)
        hasBus = false
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    PlayerData = playerData
    if playerData.job.name == 'bus' then
        isBusDriver = true
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteWomans()
    end
end)

RegisterNetEvent('esx_busdriver_route_ui')
AddEventHandler('esx_busdriver_route_ui', function(index)
    Citizen.Wait(250)
    if isBusDriver then
        if isOnJob() then
            ESX.ShowNotification('Ya tienes una ~g~RUTA~w~ asignada!')
        else
            promptJob(job_starts[index])
        end 
    else
        ESX.ShowNotification('No eres ~g~CHOFER DE AUTOBUS~w~!')
    end
end)

local currentSpawnedBus = nil

RegisterNetEvent('esx_busdriver_bus_ui')
AddEventHandler('esx_busdriver_bus_ui', function(index)
    Citizen.Wait(250)
    if isBusDriver then
        if not DoesEntityExist(currentSpawnedBus) or not hasBus then
            TriggerServerEvent("esx_busdriver:getBus", vector3(vehicle_spawn_points[index].x, vehicle_spawn_points[index].y, vehicle_spawn_points[index].z), vehicle_spawn_points[index].h)
        else
            ESX.ShowNotification('Ya has solicitado un autobus! Devuelvelo para recuperar la fianza o espera.')
        end
    else
        ESX.ShowNotification('No eres ~g~CHOFER DE AUTOBUS~w~!')
    end
end)

RegisterNetEvent("esx_busdriver:sendBusData")
AddEventHandler("esx_busdriver:sendBusData", function(netVeh)
    local vehicle = NetToVeh(netVeh)
    local playerPed = PlayerPedId()
    while not DoesEntityExist(vehicle) do 
        vehicle = NetToVeh(netVeh)
        Citizen.Wait(100) 
    end
    currentSpawnedBus = vehicle
    waitForAnotherBus()
end)

local pedEntities = {}

DeleteWomans = function()
    for i=1, #pedEntities do
        local woman = pedEntities[i]
        if DoesEntityExist(woman) then
            --DeletePed(woman)
            --SetPedAsNoLongerNeeded(woman)
        end
    end
end

Citizen.CreateThread(function()
    for i = 1, #job_starts do
        hash = GetHashKey(job_starts[i].hash)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
        if not DoesEntityExist(pedEntities[i]) then
            pedEntities[i] = CreatePed(4, hash, job_starts[i].x, job_starts[i].y, job_starts[i].z, job_starts[i].heading)
            SetEntityAsMissionEntity(pedEntities[i])
            SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
            FreezeEntityPosition(pedEntities[i], true)
            SetEntityInvincible(pedEntities[i], true)
            if i == 1 then
                TaskStartScenarioInPlace(pedEntities[i], "PROP_HUMAN_SEAT_BENCH_FACILITY", 0, true)
            else
                TaskStartScenarioInPlace(pedEntities[i], "WORLD_HUMAN_CLIPBOARD", 0, true)
            end 
        end
        SetModelAsNoLongerNeeded(hash)
    end
end)

Citizen.CreateThread(function()	
    while true do
        Citizen.Wait(0)
        if isBusDriver then
            if isOnJob() then
                local p = GetEntityCoords(GetPlayerPed(-1))
                local found = false
                for k,v in next, current_job.route do
                    local marker = v
                    if GetDistanceBetweenCoords(p, marker.x, marker.y, marker.z, true) < 50.0 then
                        found = true       
                        local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
                        drawJobMarker(marker.x, marker.y, marker.z)
                        if nearMarker(marker.x, marker.y, marker.z) and isInValidVehicle() and getCurrentTier() >= current_job.tier then
                            if GetEntitySpeed(veh) > 0.1 and engineNeedsToBeOff then
                                drawText(string.format(engineRunningText))
                            else
                                drawText(string.format(pickupText, current_job.cargo.name, v.name))
                                if isEPressed() then
                                    pickupJob(k)
                                end
                            end
                        end
                    end
                end
                if not found then
                    Citizen.Wait(500)
                end
            end
        else
            Citizen.Wait(1000)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isBusDriver then
            local coords = GetEntityCoords(PlayerPedId())
            local found = false
            for i=1, #job_ends do
                if GetDistanceBetweenCoords(coords, job_ends[i].x, job_ends[i].y, job_ends[i].z, true) < 30.0 then
                    found = true
                    drawMarker(job_ends[i].x, job_ends[i].y, job_ends[i].z)
                    if nearMarker(job_ends[i].x, job_ends[i].y, job_ends[i].z) then
                        drawText(string.format("~g~[E]~w~ Dejar de trabajar", ""))
                        if isEPressed() then
                            cancelJob()                   
                        end
                    end
                end
            end
            if not found then
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
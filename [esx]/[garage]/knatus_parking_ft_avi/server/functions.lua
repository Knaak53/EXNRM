
---Funcion que determina si un vehiculo pertenece a una persona, hay que probar que funciona de manera correcta
function VehicleBelognsTo(xPlayer,plate,cb)
    local xVehicle = ESX.GetVehicleByPlate(plate)
    if xVehicle.getJob() == xPlayer.getJob().name then
        cb(true)
        return
    end
    ESX.exposedDB.getDocument(GetHashKey(plate),function(resultado)
        if resultado then
            if resultado.owner == xPlayer.getIdentifier() or resultado.owner == xPlayer.getJob().name then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end

--Funcion que guarda cada vez que se hace un movimiento la tabla de la cache en un json por si el servidor crashea al volverlo a arrancar cargarla
function SaveLastData(cacheTable)
    SaveResourceFile(GetCurrentResourceName(), "cache-recover.json", json.encode(cacheTable), -1)
end

function LoadPlayerCars(source,identifier,xPlayer)
    PlayersCars[source] = {}
    local job = xPlayer.getJob().name
    ESX.exposedDB.getDocumentsByRowValuesWithFields("owner",{identifier,job},{"plate"},function(result)
        if result then
            for k,v in pairs(result) do
                if v.plate ~= nil then
                    table.insert(PlayersCars[source],v.plate)
                end
            end
            TriggerClientEvent("s2v_parkings:syncPlayerCars",source,PlayersCars[source])
        end
    end)
end


function RegisterNewParking(player,coords,shell,floors,parkingId)
--Comprobar si el parking ya esta registrado, si lo esta no hacer nada si no lo esta entonces lo registramos correspondientemente en la cache para
--que luego ella sola actualice la bd. Una vez teniendo esto procedemos a enviarle al cliente el nuevo parkingcache y procedemos a enviarle,
--el cambio en la config es decir lo que añade para que se haga de forma automatica
    if ParkingsCache[parkingId] ~= nil then return end --Si pasa de aqui es que el parking no existe entonces lo creamos todo
    ParkingsCache[parkingId] = {}
    for i=1,tonumber(floors),1 do
        ParkingsCache[parkingId][i] ={}
    end
end


function GetParkingPlace(_parking,_floor,_place)
    for k,v in pairs(ParkingsCache[_parking][_floor]) do
      if v.place == _place then
       return v
      end
    end
end
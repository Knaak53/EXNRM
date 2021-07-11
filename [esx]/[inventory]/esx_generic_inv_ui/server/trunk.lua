--ESX = nil
Items = {}
local DataStoresIndex = {}
local DataStores = {}
SharedDataStores = {}
PlayersCars = {}

--local listPlate = Config.VehiclePlate

--TriggerEvent(
--  "esx:getSharedObject",
--  function(obj)
--    ESX = obj
--  end
--)

AddEventHandler("s2v_parkings:syncPlayerCars", function(playerscars)
  PlayersCars = playerscars  
end)

AddEventHandler(
  "onMySQLReady",
  function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM trunk_inventory")
    local data = nil
    if #result ~= 0 then
      for i = 1, #result, 1 do
        local plate = result[i].plate
        local owned = result[i].owned
        local data = (result[i].data == nil and {} or json.decode(result[i].data))
        local dataStore = CreateDataStore(plate, owned, data)
        SharedDataStores[plate] = dataStore
      end
    end
  end
)

function loadInvent(plate,cb)
  print(GetHashKey(plate))
  ESX.exposedDB.getDocument(GetHashKey(plate), function(result) 
    print(json.encode(result))
    if result then
      local data = nil
      local plate = result.plate
      local owned = true
      --print("data"..json.encode(result.data))
      local data = (result.data == nil and {} or result.data)
      local dataStore = CreateDataStore(plate, owned, data)
      SharedDataStores[plate] = dataStore
      --print("DATOS:"..SharedDataStores[plate])
      cb(SharedDataStores[plate])
    end
  end)
end

function getOwnedVehicule(plate, cb)
  local found = false
  local debug = {selector = {["plate"] = plate}, fields = {"plate"}}
  if not found then
  ESX.exposedDB.getDocumentsByRowWithFields("plate", plate, {"plate"}, function(result) 
 
      print(json.encode(result))
      if result then
        cb(true)
      else
        cb(false)
      end
    end)
  end
  return found
end

function MakeDataStore(plate, cb)
  local data = {
    items = {},
    accounts = {},
    weapons = {}
  }
  getOwnedVehicule(plate, function(owned) 
    if owned then
      loadInvent(plate,cb)
    else
      local dataStore = CreateDataStore(plate, owned, data)
      SharedDataStores[plate] = dataStore
      cb(SharedDataStores[plate])
    end
  end)
  
end

function GetSharedDataStore(plate,cb)
  if SharedDataStores[plate] == nil then
    MakeDataStore(plate,cb)
  else
    cb(SharedDataStores[plate])
  end
end

AddEventHandler(
  "esx_trunk:getSharedDataStore",
  function(plate, cb)
    GetSharedDataStore(plate,cb)
  end
)

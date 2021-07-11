ESX = nil
local hasBeenUnlocked = {}
local vehicleHotwired = {}
local drawing = false
local gotKeys = false
local failedAttempt = {}
local vehicleSearched = {}
local disableH = false
local showText = true
local hasKilledNPC = false
local useLockpick = false
local vehicleBlacklist = {
 ['BMX'] = true,
 ['CRUISER'] = true,
 ['FIXTER'] = true,
 ['SCORCHER'] = true,
 ['TRIBIKE'] = true,
 ['TRIBIKE2'] = true,
 ['TRIBIKE3'] = true,
 ['FLATBED'] = true,
 ['BOXVILLE2'] = true,
 ['BENSON'] = true,
 ['PHANTOM'] = true,
 ['RUBBLE'] = true,
 ['RUMPO'] = true,
 ['YOUGA2'] = true,
 ['BOXVILLE'] = true,
 ['TAXI'] = true,
 ['DINGHY'] = true
 }

 Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(100)
  end
  
  while ESX.PlayerData == nil do
    ESX.PlayerData = ESX.GetPlayerData()
    Citizen.Wait(100)
  end
end)


AddEventHandler("esx:setjob", function(job) 
  ESX.PlayerData.job = job
end)
local vehicle
local plate
Citizen.CreateThread(function()
 while true do
  Citizen.Wait(5)


  if disableF then
   DisableControlAction(0, 23, true)
  end

  if disableH then
   DisableControlAction(0, 74, true)
   DisableControlAction(0, 47, true)
  end
 end
end)

Citizen.CreateThread(function()
    while true do
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local pedd = GetPedInVehicleSeat(veh, -1)

            if DoesEntityExist(pedd) and not IsPedAPlayer(pedd) and not IsEntityDead(pedd) then
              --print('cannot enter this door dick')
             SetVehicleDoorsLocked(veh, 2)
             SetPedCanBeDraggedOut(pedd, false)
             TaskVehicleMissionPedTarget(pedd, veh, PlayerPedId(), 8, 50.0, 790564, 300.0, 15.0, 1)
             disableF = true
             Wait(1500)
             disableF = false
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('vehicle:start')
AddEventHandler('vehicle:start', function()
 local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
 SetVehicleEngineOn(vehicle, true, true)
end)

Citizen.CreateThread(function()
 while true do
  Citizen.Wait(5)

  if not IsPedInAnyVehicle(PlayerPedId(), false) then
   showText = true


   -- Exiting
   local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
   if aiming then
    if DoesEntityExist(targetPed) and not IsPedAPlayer(targetPed) and IsPedArmed(PlayerPedId(), 7) and not IsPedArmed(PlayerPedId(), 1) then
     local vehicle = GetVehiclePedIsIn(targetPed, false)
     local plate = GetVehicleNumberPlateText(vehicle)
     local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)

     if distance < 10 and IsPedFacingPed(targetPed, PlayerPedId(), 60.0) then

     SetVehicleForwardSpeed(vehicle, 0)

     hasBeenUnlocked[plate] = false

     SetVehicleForwardSpeed(vehicle, 0)
     TaskLeaveVehicle(targetPed, vehicle, 256)
     TriggerEvent('vehicle:RobbingVehicle')

     while IsPedInAnyVehicle(targetPed, false) do
      Citizen.Wait(5)
     end

     RequestAnimDict('missfbi5ig_22')
     RequestAnimDict('mp_common')

     SetPedDropsWeaponsWhenDead(targetPed,false)
     ClearPedTasks(targetPed)
     TaskTurnPedToFaceEntity(targetPed, GetPlayerPed(-1), 3.0)
     TaskSetBlockingOfNonTemporaryEvents(targetPed, true)
     SetPedFleeAttributes(targetPed, 0, 0)
     SetPedCombatAttributes(targetPed, 17, 1)
     SetPedSeeingRange(targetPed, 0.0)
     SetPedHearingRange(targetPed, 0.0)
     SetPedAlertness(targetPed, 0)
     SetPedKeepTask(targetPed, true)

     TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
     Wait(1500)
     TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
     Wait(2500)

     local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)

     if not IsEntityDead(targetPed) and distance < 12 then
      hasBeenUnlocked[plate] = true
      vehicleHotwired[plate] = true
      TaskPlayAnim(targetPed, "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
      Wait(750)
      exports["esx-taskbar"]:taskBar(2000,"Cogiendo las llaves")
      carAlerts(vehicle)
      --TriggerEvent('chatMessage', '^2You Have Been Given The Keys')
      TriggerEvent('notification', 'Has cogido las llaves!', 1)
      TriggerServerEvent('garage:addKeys', plate)
      Citizen.Wait(500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      Wait(2500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      Wait(2500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      Wait(2500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      end
     end
    end
   end
  end
 end
end)

local engine = false
Citizen.CreateThread(function()
  local plate = GetVehicleNumberPlateText(vehicle)
 while true do
  Citizen.Wait(1000)

  if IsPedShooting(PlayerPedId()) then
   hasKilledNPC = true
  end

  if IsPedInAnyVehicle(PlayerPedId(), false) then
   local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
   local plate = GetVehicleNumberPlateText(vehicle)

    if DoesEntityExist(vehicle) and (not hasVehicleKey(plate)) and (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) and (not vehicleHotwired[plate]) and (not vehicleBlacklist[GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))]) then
      --while not IsPedInAnyVehicle(PlayerPedId(), false) do
      -- Citizen.Wait(5)
      --end
      if IsPedInAnyPoliceVehicle(PlayerPedId()) and not hasVehicleKey(plate) and ESX.PlayerData.job.name == "police" then
        vehicleHotwired[plate] = true
        SetVehicleEngineOn(vehicle, true, true)
        TriggerEvent('notification', 'Llaves recibidas', 1)
        TriggerEvent('notification', 'Motor encendido', 1)
        TriggerServerEvent('garage:addKeys', plate)
        SetVehicleEngineOn(vehicle, true, true)
        Wait(1000)
        return
      end

      if GetEntityModel(vehicle) == GetHashKey("ambulance") and not hasVehicleKey(plate) and ESX.PlayerData.job.name == "ambulance" then
        vehicleHotwired[plate] = true
        SetVehicleEngineOn(vehicle, true, true)
        TriggerEvent('notification', 'Llaves recibidas', 1)
        TriggerEvent('notification', 'Motor encendido', 1)
        TriggerServerEvent('garage:addKeys', plate)
        SetVehicleEngineOn(vehicle, true, true)
        Wait(1000)
        return
      end
    
      local pos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.0, 1.0)
    
    
      if showText and not drawing then
          drawing = true
          Citizen.CreateThread(function() 
            while showText and drawing do
              Wait(5)
              DrawText3Ds(pos["x"],pos["y"],pos["z"], "[H] Hacer un puente / [G] Buscar" )
            end
          end)

        Citizen.CreateThread(function() 
          while not engine do
            --print(engine)
            Wait(10)
            SetVehicleEngineOn(vehicle, false, false)
          end
        end)
      end
    --else
    --  if DoesEntityExist(vehicle) then
    --    vehicleHotwired[plate] = true
    --    showText = false
    --    drawing = false
    --    Wait(1000)
    --  end
    end
  else
    showText = false
    drawing = false
  end
 end
end)


RegisterCommand("hotwire", function() 
Citizen.CreateThread(function() 
  if IsPedInAnyVehicle(PlayerPedId(), false) then
    vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    plate = GetVehicleNumberPlateText(vehicle)
    if showText and GetLastInputMethod(2) and drawing then
      if not failedAttempt[plate] and not vehicleHotwired[plate] then
        TriggerEvent('animation:hotwire', true)
        showText = false
        exports["esx-taskbar"]:taskBar(15000,"Intentando hacer un puente")

        carAlerts(vehicle)
          
        TriggerEvent('animation:hotwire', false)
        if math.random(1, 15) <= 10 then
          vehicleHotwired[plate] = true
          engine = true
          Wait(50)
          SetVehicleEngineOn(vehicle, true, true)
          TriggerServerEvent('garage:addKeys', plate, false, true)
          TriggerEvent('notification', 'Conseguiste hacer un puente', 1)
          showText = true
          engine = false
        else
          TriggerEvent('notification', 'Fallaste al hacer un puente', 2)
          failedAttempt[plate] = true
          showText = true
        end
      elseif failedAttempt[plate] then
      TriggerEvent('notification', 'Este vehiculo ya ha sido puenteado', 2)
      elseif vehicleHotwired[plate] then
      TriggerEvent('notification', 'Parece que esto no va a funcionar', 2)
      else
      TriggerEvent('notification', 'Esto es muy complicado', 2)
      end
    elseif useLockpick then
      useLockpick = true
      TriggerEvent('animation:hotwire', true)
      showText = false
      exports["esx-taskbar"]:taskBar(20000, "Modifying Ignition Stage 1")
      exports["esx-taskbar"]:taskBar(20000, "Modifying Ignition Stage 2")
      exports["esx-taskbar"]:taskBar(20000, "Modifying Ignition Stage 3")
      TriggerEvent('animation:hotwire', false)
      vehicleHotwired[plate] = true
      SetVehicleEngineOn(vehicle, true, true)
      TriggerEvent('notification', 'Llaves recibidas', 1)
      TriggerEvent('notification', 'Motor encendido', 1)
      TriggerServerEvent('garage:addKeys', plate)
      SetVehicleEngineOn(vehicle, true, true)
      showText = true
      SetVehicleEngineOn(vehicle, true, true)
      TriggerServerEvent('removelockpick')
    end
  end
end)
end)

RegisterCommand("vsearch", function() 
  if IsPedInAnyVehicle(PlayerPedId(), false) then
    vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    plate = GetVehicleNumberPlateText(vehicle)
    if not vehicleSearched[plate] and not hasVehicleKey(plate) and showText and not vehicleHotwired[plate] and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
      showText = false
      exports["esx-taskbar"]:taskBar(10000, "Buscando en el vehiculo")
      vehicleSearched[plate] = true
      if not hasVehicleKey(plate) then
        TriggerServerEvent('garage:searchItem', plate)
        showText = true
      end
    elseif vehicleSearched[plate]  then
      TriggerEvent('notification', 'Ya has buscado en este vehiculo', 2)
    end
  end
end)

RegisterCommand("togglelock", function() 
  if GetLastInputMethod(2) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedInAnyHeli(PlayerPedId()) then
    TriggerEvent('keys:togglelocks')
  end
end)

--
RegisterKeyMapping('hotwire', 'Hacer un puente a un vehiculo', 'keyboard', 'h')
RegisterKeyMapping('vsearch', 'Buscar en el interior de un vehiculo', 'keyboard', 'g')

RegisterKeyMapping('togglelock', 'Abrir/Cerrar Vehiculo', 'keyboard', 'l')

AddEventHandler('vehicle:setUnlocked', function(plate)
 hasBeenUnlocked[plate] = true
end)

function DrawText3Ds(x,y,z, text)
 local onScreen,_x,_y=World3dToScreen2d(x,y,z)
 local px,py,pz=table.unpack(GetGameplayCamCoords())
 SetTextScale(0.35, 0.35)
 SetTextFont(4)
 SetTextProportional(1)
 SetTextColour(255, 255, 255, 215)
 SetTextEntry("STRING")
 SetTextCentre(1)
 AddTextComponentString(text)
 DrawText(_x,_y)
 local factor = (string.len(text)) / 370
 DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


AddEventHandler('keys:togglelocks', function()
 local ped = PlayerPedId()
 local coords = GetEntityCoords(ped)
 local vehicle = nil
 if IsPedInAnyVehicle(ped, false) then vehicle = GetVehiclePedIsIn(ped, false) else vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71) end
 if DoesEntityExist(vehicle) then
  Citizen.CreateThread(function()
    local plate = GetVehicleNumberPlateText(vehicle)
   if hasVehicleKey(plate) then

    if not IsPedInAnyVehicle(PlayerPedId(), false) then
     playLockAnimation()
     SetVehicleEngineOn(vehicle, true, true, true)
     SetVehicleLights(vehicle, 2) Wait(200) SetVehicleLights(vehicle, 1) Wait(200) SetVehicleLights(vehicle, 2) Wait(200) SetVehicleLights(vehicle, 1)
     SetVehicleEngineOn(vehicle, false, false, false)
     SetVehicleLights(vehicle, 0)
    end


    if GetVehicleDoorLockStatus(vehicle) == 1 then
      --SetVehicleDoorsLocked(vehicle, 2)
      TriggerServerEvent("keys:togglelocks", plate)
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "unlock", 0.1)
      TriggerEvent('notification', 'Vehiculo bloqueado', 1)

    elseif GetVehicleDoorLockStatus(vehicle) == 2 then
      TriggerServerEvent("keys:togglelocks", plate)
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "lock", 0.1)
      --SetVehicleDoorsLocked(vehicle, 1)
      TriggerEvent('notification', 'Vehiculo desbloqueado', 1)
      SetVehicleDoorsLocked(vehicle, 1)

    elseif GetVehicleDoorLockStatus(vehicle) == 0 then
      TriggerServerEvent("keys:togglelocks", plate)
      --SetVehicleDoorsLocked(vehicle, 2)
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "unlock", 0.1)
      TriggerEvent('notification', 'Vehiculo bloqueado', 1)
    end
   end
  end)
 else
  TriggerEvent('notification', 'No hay ningun vehiculo cerca.', 2)
 end
end)

function playLockAnimation()
 if not IsPedInAnyVehicle(PlayerPedId(), false) then
  RequestAnimDict('anim@heists@keycard@')
  while not HasAnimDictLoaded('anim@heists@keycard@') do
   Citizen.Wait(1)
  end
  TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 24.0, 16.0, 1000, 50, 0, false, false, false)
 end
end

RegisterCommand('darllaves', function(args, source)
  local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
  local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 100.0, 0.0)
  local latestveh = getVehicleInDirection(coordA, coordB)

  if latestveh == nil or not DoesEntityExist(latestveh) then
    TriggerEvent('notification', 'Vehiculo no encontrado', 2)
    return
  end

  if not hasVehicleKey(GetVehicleNumberPlateText(latestveh)) then
      TriggerEvent('notification', 'No tienes las llaves de este vehiculo', 2)
      return
  end

  if GetDistanceBetweenCoords(GetEntityCoords(latestveh), GetEntityCoords(GetPlayerPed(-1), 0)) > 5 then
    TriggerEvent('notification', 'Estas muy lejos del vehiculo!', 2)
    return
  end

  t, distance = ESX.Game.GetClosestPlayer()
  if(distance ~= -1 and distance < 8) then
    TriggerServerEvent('garage:giveKey', GetPlayerServerId(t), GetVehicleNumberPlateText(latestveh))
    TriggerEvent('notification', 'Diste las llaves de tu vehiculo!', 1)
  else
    TriggerEvent('notification', 'No hay jugadores cerca!', 2)
  end
end)


RegisterNetEvent('vehkey')
AddEventHandler('vehkey', function()
  local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
  local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 100.0, 0.0)
  local latestveh = getVehicleInDirection(coordA, coordB)

  if latestveh == nil or not DoesEntityExist(latestveh) then
    TriggerEvent('notification', 'No hay ningún vehiculo cercano', 2)
    return
  end

  if not hasVehicleKey(GetVehicleNumberPlateText(latestveh)) then
      TriggerEvent('notification', 'No tienes las llaves de este vehiculo', 2)
      return
  end

  if GetDistanceBetweenCoords(GetEntityCoords(latestveh), GetEntityCoords(GetPlayerPed(-1), 0)) > 5 then
    TriggerEvent('notification', 'Estas muy lejos del vehiculo', 2)
    return
  end

  t, distance = ESX.Game.GetClosestPlayer()
  if(distance ~= -1 and distance < 8) then
    TriggerServerEvent('garage:giveKey', GetPlayerServerId(t), GetVehicleNumberPlateText(latestveh))
    TriggerEvent('notification', 'Diste las llaves de tu vehiculo', 1)
  else
    TriggerEvent('notification', 'No hay jugadores cerca!', 2)
  end
end)

function getVehicleInDirection(coordFrom, coordTo)
  local offset = 0
  local rayHandle
  local vehicle

  for i = 0, 100 do
    rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GetPlayerPed(-1), 0)
    a, b, c, d, vehicle = GetRaycastResult(rayHandle)

    offset = offset - 1

    if vehicle ~= 0 then break end
  end

  local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))

  if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

local disable = false

RegisterNetEvent('animation:hotwire')
AddEventHandler('animation:hotwire', function(disable)
 local lPed = PlayerPedId()
 ClearPedTasks(lPed)
   ClearPedSecondaryTask(lPed)

 RequestAnimDict("mini@repair")
 while not HasAnimDictLoaded("mini@repair") do
  Citizen.Wait(0)
 end
 if disable ~= nil then
  if not disable then
   lockpicking = false
   return
  else
   lockpicking = true
  end
 end
 while lockpicking do

  if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
   ClearPedSecondaryTask(lPed)
   TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
  end
  Citizen.Wait(1)
 end
 ClearPedTasks(lPed)
end)

-- Start stealing a car
local isLockpicking = false


RegisterNetEvent('lockpick:vehicleUse')
AddEventHandler('lockpick:vehicleUse', function()

 local coords = GetEntityCoords(GetPlayerPed(-1))
 local vehicle = nil
 if IsPedInAnyVehicle(PlayerPedId(), false) then
  vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
 else
  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
 end

  if DoesEntityExist(vehicle) then
   if not IsPedInAnyVehicle(PlayerPedId(), false) then
    if GetVehicleDoorLockStatus(vehicle) ~= 1 then
      carAlerts(vehicle)
     RequestAnimDict("mini@repair")
     while not HasAnimDictLoaded("mini@repair") do
   	  Citizen.Wait(0)
     end

     TriggerEvent('carLockpickAnim')

     Citizen.CreateThread(function()
      exports["esx-taskbar"]:taskBar(20000,"Lockpicking Vehicle")
       isLockpicking = false
       SetVehicleDoorsLocked(vehicle, 1)
       SetVehicleDoorsLockedForAllPlayers(vehicle, false)
       hasBeenUnlocked[GetVehicleNumberPlateText(vehicle)] = true
       TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "lock", 0.1)
       TriggerEvent('notification', 'Vehicle Unlocked', 1)
       SetVehicleEngineOn(vehicle, true, true, true)
       SetVehicleLights(vehicle, 2) Wait(200)
       SetVehicleLights(vehicle, 1) Wait(200)
       SetVehicleLights(vehicle, 2) Wait(200)
       SetVehicleLights(vehicle, 1) Wait(200)
       ClearPedTasksImmediately(GetPlayerPed(-1))
       TriggerServerEvent('removelockpick')

     end)
    end
   else
    local plate = GetVehicleNumberPlateText(vehicle)
    if failedAttempt[plate] or vehicleHotwired[plate] or vehicleSearched[plate] or hasVehicleKey(plate) then
     TriggerEvent('notification', 'You can not work out this hotwire.', 2)
    else
     useLockpick = true
    end
   end
 end
end)

AddEventHandler('carLockpickAnim', function()
 isLockpicking = true
 loadAnimDict('veh@break_in@0h@p_m_one@')
 while isLockpicking do
  if not IsEntityPlayingAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
   TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
   Citizen.Wait(1500)
   ClearPedTasks(PlayerPedId())
  end
  Citizen.Wait(1)
 end
 ClearPedTasks(PlayerPedId())
end)


function loadAnimDict(dict)
 RequestAnimDict(dict)
 while not HasAnimDictLoaded(dict) do
  Citizen.Wait(5)
 end
end


Citizen.CreateThread(function()
 while true do
  Citizen.Wait(50)
  if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil and GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= 0 and not gotKeys then
   local curveh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
   local plate1 = GetVehicleNumberPlateText(curveh)
   if not hasVehicleKey(GetVehicleNumberPlateText(curveh)) then
    local pedDriver = GetPedInVehicleSeat(curveh, -1)
    if DoesEntityExist(pedDriver) and IsEntityDead(pedDriver) and not IsPedAPlayer(pedDriver) and not hasVehicleKey(GetVehicleNumberPlateText(curveh)) and hasKilledNPC then
     hasKilledNPC = false
     gotKeys = true
     Wait(500)
     exports["esx-taskbar"]:taskBar(2000, "Taking Keys")
      Wait(2000)
      TriggerServerEvent('garage:addKeys', plate1)
      Wait(500)
      gotKeys = false
    end
   end
  end
 end
end)

local vehicleKeys = {}
local myCharacterID = 0

RegisterNetEvent("garage:updateKeys")
AddEventHandler("garage:updateKeys", function(data, char_id, plate)
 vehicleKeys[plate] = data
 if char_id then
  myCharacterID = char_id
 end
end)

function hasVehicleKey(plate)
  --print("plate: "..all_trim(plate) .."-")
  --local plate = all_trim(plate)
  local isCompany = false
  local returned = false
 if vehicleKeys[plate] ~= nil then
  for k,v in pairs(vehicleKeys[plate]) do
   if v.id == myCharacterID or v.id == "all" then
    return true
   end
  end
  
  
  ESX.TriggerServerCall("esx:isVehicleOwnedBySameCompany", function(owned) 
    returned = true
    isCompany = owned
  end, plate)
  while not returned do
    Wait(100)
  end
  return isCompany
 else
  --print("ni una sola llaves")
  ESX.TriggerServerCallback("esx:isVehicleOwnedBySameCompany", function(owned) 
    returned = true
    isCompany = owned
  end, plate)
  while not returned do
    Wait(100)
  end
  return isCompany
 end
end


AddEventHandler("esx:hasKeys", function(plate, cb) 
  local result = hasVehicleKey(plate)
  cb(result)
end)

function all_trim(s)
  if s then
    return s:match "^%s*(.*)":match "(.-)%s*$"
  else
    return "noTagProvided"
  end
end

function carAlerts(vehicle)
    local playerCoords = GetEntityCoords(PlayerPedId())

		local streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    streetName = GetStreetNameFromHashKey(streetName)

    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    vehicleLabel = GetLabelText(vehicleLabel)
    local playerGender
    TriggerEvent('skinchanger:getSkin', function(skin)
      playerGender = skin.sex
    end)
    exports["AS911"]:LlamadaPolicia('Robo de '..vehicleLabel..' con matricula '..GetVehicleNumberPlateText(vehicle))
end


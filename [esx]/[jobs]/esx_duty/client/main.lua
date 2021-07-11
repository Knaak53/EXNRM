--- action functions
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil


--- esx
local GUI = {}
ESX                           = nil
GUI.Time                      = 0
local PlayerData              = {}

Citizen.CreateThread(function ()
  while ESX == nil do
    ESX = exports.extendedmode:getSharedObject()
    Citizen.Wait(0)
  PlayerData = ESX.GetPlayerData()
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

----markers
AddEventHandler('esx_duty:hasEnteredMarker', function (zone)
  if zone ~= nil then
    CurrentAction     = 'onoff'
    CurrentActionMsg = _U('duty')
  end
end)

AddEventHandler('esx_duty:hasExitedMarker', function (zone)
  CurrentAction = nil
end)

local jobs = {
    'offambulance',
    'offpolice',
    'offtaxi',
    'offmechanic',
    'offcardealer',
    'taxi',
    'mechanic',
    'police',
    'ambulance',
    'cardealer'
}

RegisterNetEvent('esx_duty:onoff_ui')
AddEventHandler('esx_duty:onoff_ui', function(job)
  for k,v in pairs(jobs) do
      if PlayerData.job.name == v then
        TriggerServerEvent('duty:onoff')
      end
  end
end)

if CurrentAction == 'ambulance_duty' and PlayerData.job.name == "ambulance" and PlayerData.job.name == "offmedic" or
  CurrentAction == 'ambulance_duty' and PlayerData.job.name == "ambulance" and PlayerData.job.name == "offmedic" or
  CurrentAction == 'ambulance_duty' and PlayerData.job.name == "ambulance" and PlayerData.job.name == "offmedic" or
  CurrentAction == 'ambulance_duty' and PlayerData.job.name == "ambulance" and PlayerData.job.name == "offmedic" or
  CurrentAction == 'ambulance_duty' and PlayerData.job.name == "ambulance" and PlayerData.job.name == "offmedic" then

end
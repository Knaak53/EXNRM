Config = {}

-- Script locale (only .Lua)
Config.Locale = 'es'

Config.FixePhone = {
  -- Mission Row
  ['911'] = { 
    name =  'Comisaria', 
    coords = { x = 441.2, y = -979.7, z = 30.58 } 
  },
  
  ['hospital'] = {
    name = 'Hospital',
    coords = { x = 309.42, y = -593.89, z = 43.28 } 
  },
}

-- TEMPORARILY ONLY WORKS IN es_extended 1.1 and older, Fixing this in the next couple of days, forgot something in the code. --

Config.newESX = false -- True = ESX 1.2(v1final), False = ESX 1.1 and older. (NOT WORKING YET, FORGOT SOMETHING IN CODE, HAVE TO FIND IT)

Config.KeyOpenClose = 288 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = false -- Use Frazzle's Mumble-VoIP Resource (Recommended!) https://github.com/FrazzIe/mumble-voip
Config.UseTokoVoIP   = false

Config.ShowNumberNotification = false -- Show Number or Contact Name when you receive new SMS

Config.ShareRealtimeGPSDefaultTimeInMs = 1000 * 90 -- Set default realtime GPS sharing expiration time in milliseconds
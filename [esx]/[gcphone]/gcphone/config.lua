Config = {}

-- Script locale (only .Lua)
Config.Locale = 'es'

Config.AutoFindFixePhones = true -- Automatically add pay phones as they are found by their models.

Config.FixePhone = {
  -- Mission Row
  ['911'] = { 
    name =  _U('mission_row'), 
    coords = { x = 443.49948120117, y = -979.7705078125, z = 30.689323425293} 
  },
  ['mechanic'] = { 
    name =  "Mecánicos", 
    coords = {x = -217.63623046875, y = -1325.8812255859, z = 30.89038848877}
  },
  
--  ['372-9663'] = {
--    name = _U('phone_booth'),
--    coords = { x = 372.305, y = -966.373, z = 28.413 } 
--  },
}

Config.KeyOpenClose = 288 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = true -- Use Frazzle's Mumble-VoIP Resource (Recomended!) https://github.com/FrazzIe/mumble-voip
Config.UseTokoVoIP   = false

Config.ShowNumberNotification = true -- Show Number or Contact Name when you receive new SMS

Config.phoneshopPed = {
	{
		coords = vector3(-656.734, -858.787, 23.503),
		heading = 1.682,
		model = 'ig_tanisha',
		animation = ""
	}
}

Config.shopItems = {
	{name = "phone", label = "Telefono", price = 125}
}
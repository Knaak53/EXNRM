Config                 = {}
Config.MaxErrors       = 4
Config.SpeedMultiplier = 3.6
Config.Locale          = 'es'
Config.PlayingSound = false

Config.Prices = {
	dmv         = 600,
	drive       = 2800,
	drive_bike  = 3500,
	drive_truck = 5000
}

Config.VehicleModels = {
	drive       = 'blista',
	drive_bike  = 'sanchez',
	drive_truck = 'mule3'
}

Config.SpeedLimits = {
	residence = 40,
	town      = 80,
	freeway   = 120
}

Config.Zones = {

	DMVSchool = {
		Pos   = {x = 214.22, y = -1400.83, z = 30.58},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos   = vector3(249.409, -1407.230, 30.4094),
		heading = 317.0,
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = -1
	}

}

Config.messageTitle = "Examinador"
Config.imgName = "drive_teacher.png"

Config.CheckPoints = {

	{
		Pos = {x = 255.139, y = -1400.731, z = 29.537},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				Config.PlayingSound = true
				if showTeacherMessages then
					TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "zoneSpeed")
				end
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(7000)
				FreezeEntityPosition(vehicle, false)
				Config.PlayingSound = false
			end)
		end
	},

	{
		Pos = {x = 271.874, y = -1370.574, z = 30.932},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 234.907, y = -1345.385, z = 29.542},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				Config.PlayingSound = true
				if showTeacherMessages then
					TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "stop")
				end
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(5000)
				FreezeEntityPosition(vehicle, false)
				Config.PlayingSound = false
			end)
		end
	},

	{
		Pos = {x = 217.821, y = -1410.520, z = 28.292},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				Config.PlayingSound = true
				if showTeacherMessages then
					TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "ceda")
				end
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)
				FreezeEntityPosition(vehicle, false)
				Config.PlayingSound = false
			end)
		end
	},

	{
		Pos = {x = 178.550, y = -1401.755, z = 27.725},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Config.PlayingSound = true
			if showTeacherMessages then
				TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "continue")
			end
			Citizen.Wait(5200)
			Config.PlayingSound = false
		end
	},

	{
		Pos = {x = 113.160, y = -1365.276, z = 27.725},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -73.542, y = -1364.335, z = 27.789},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			Config.PlayingSound = true
			if showTeacherMessages then
				TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "midZone")
			end
			Citizen.Wait(5000)
			Config.PlayingSound = false
		end
	},

	{
		Pos = {x = -355.143, y = -1420.282, z = 27.868},
		Action = function(playerPed, vehicle, setCurrentZoneType)	
			DrawMissionText(_U('go_next_point'), 5000)	
		end
	},

	{
		Pos = {x = -439.148, y = -1417.100, z = 27.704},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)		
		end
	},

	{
		Pos = {x = -453.790, y = -1444.726, z = 27.665},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')
			Config.PlayingSound = true
			if showTeacherMessages then
				TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "highway")
			end
			Citizen.Wait(5000)
			Config.PlayingSound = false
		end
	},

	{
		Pos = {x = -463.237, y = -1592.178, z = 37.519},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -900.647, y = -1986.28, z = 26.109},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Config.PlayingSound = true
			if showTeacherMessages then
				TriggerEvent('esx_custom_messages:showMessage', "dmv", false, "nextPoint")
			end
			Citizen.Wait(6000)
			Config.PlayingSound = false
		end
	},

	{
		Pos = {x = 1225.759, y = -1948.792, z = 38.718},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('in_town_speed', Config.SpeedLimits['town']), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			
		end
	},

	{
		Pos = {x = 1225.759, y = -1948.792, z = 38.718},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 1163.603, y = -1841.771, z = 35.679},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('gratz_stay_alert'), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},

	{
		Pos = {x = 235.283, y = -1398.329, z = 28.921},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			ESX.Game.DeleteVehicle(vehicle)
		end
	}

}

Config                            = {}
Config.Locale                     = 'en'

Config.DrawDistance               = 30.0 -- How close you need to be in order for the markers to be drawn (in GTA units).
Config.MaxInService               = 8
Config.EnablePlayerManagement     = true -- Enable society managing.
Config.EnableSocietyOwnedVehicles = false

Config.NPCSpawnDistance           = 500.0
Config.NPCNextToDistance          = 25.0
Config.NPCJobEarnings             = { min = 15, max = 40 }

Config.Vehicles = {
	'adder',
	'asea',
	'asterope',
	'banshee',
	'buffalo',
	'sultan',
	'baller3'
}


Config.shopCoords = vector3(-165.5943145752,-1304.7878417969,31.311277389526)
Config.shopOutPos = vector3(-157.78175354004,-1297.5512695312,31.064205169678)
Config.shopNPC = vector3(-178.64585876465,-1311.2730712891,30.300895690918)
Config.AuthorizedVehicles = {
	mechanic = {
		{model = "flatbed", price = 45000}
	},
}

Config.AuthorizedPrivateVehicles = {
	{model = "hauler", price = 48000},
	{model = "mule2", price = 28500},
	{model = "rumpo3", price = 34800},
}

Config.Zones = {

	MechanicActions = {
		Pos   = { x = -200.93, y = -1315.65, z = 31.09 },
		Size  = { x = 1.0, y = 1.0, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	},

	VehicleSpawnPoint = {
		Pos   = { x = -164.47, y = -1302.7, z = 31.31 },
		Size  = { x = 0.0, y = 0.0, z = 0.0 },
		Color = { r = 204, g = 0, b = 0 },
		Type  = 39
	},

	VehicleDeleter = {
		Pos   = { x = -182.69, y = -1326.3, z = 31.21 },
		Size  = { x = 2.0, y = 2.0, z = 2.0 },
		Color = { r = 204, g = 0, b = 0 },
		Type  = 39
	},

	VehicleDelivery = {
		Pos   = { x = -186.41, y = -1287.31, z = 30.3 },
		Size  = { x = 15.0, y = 15.0, z = 0.3 },
		Color = { r = 204, g = 0, b = 0 },
		Type  = 1
	}
}

Config.Towables = {
	vector3(-2480.9, -212.0, 17.4),
	vector3(-2723.4, 13.2, 15.1),
	vector3(-3169.6, 976.2, 15.0),
	vector3(-3139.8, 1078.7, 20.2),
	vector3(-1656.9, -246.2, 54.5),
	vector3(-1586.7, -647.6, 29.4),
	vector3(-1036.1, -491.1, 36.2),
	vector3(-1029.2, -475.5, 36.4),
	vector3(75.2, 164.9, 104.7),
	vector3(-534.6, -756.7, 31.6),
	vector3(487.2, -30.8, 88.9),
	vector3(-772.2, -1281.8, 4.6),
	vector3(-663.8, -1207.0, 10.2),
	vector3(719.1, -767.8, 24.9),
	vector3(-971.0, -2410.4, 13.3),
	vector3(-1067.5, -2571.4, 13.2),
	vector3(-619.2, -2207.3, 5.6),
	vector3(1192.1, -1336.9, 35.1),
	vector3(-432.8, -2166.1, 9.9),
	vector3(-451.8, -2269.3, 7.2),
	vector3(939.3, -2197.5, 30.5),
	vector3(-556.1, -1794.7, 22.0),
	vector3(591.7, -2628.2, 5.6),
	vector3(1654.5, -2535.8, 74.5),
	vector3(1642.6, -2413.3, 93.1),
	vector3(1371.3, -2549.5, 47.6),
	vector3(383.8, -1652.9, 37.3),
	vector3(27.2, -1030.9, 29.4),
	vector3(229.3, -365.9, 43.8),
	vector3(-85.8, -51.7, 61.1),
	vector3(-4.6, -670.3, 31.9),
	vector3(-111.9, 92.0, 71.1),
	vector3(-314.3, -698.2, 32.5),
	vector3(-366.9, 115.5, 65.6),
	vector3(-592.1, 138.2, 60.1),
	vector3(-1613.9, 18.8, 61.8),
	vector3(-1709.8, 55.1, 65.7),
	vector3(-521.9, -266.8, 34.9),
	vector3(-451.1, -333.5, 34.0),
	vector3(322.4, -1900.5, 25.8)
}

for k,v in ipairs(Config.Towables) do
	Config.Zones['Towable' .. k] = {
		Pos   = v,
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
end

Config.uniforms = {
	aprendiz = {
		male = {-- TODO set properly
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 65,   torso_2 = 2,
			decals_1 = 0,   decals_2 = 0,
			arms = 42,
			pants_1 = 38,   pants_2 = 2,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0
		},
		-- TODO female uniform
		female = {
				tshirt_1 = 14,  tshirt_2 = 0,
				torso_1 = 59,   torso_2 = 2,
				decals_1 = 0,   decals_2 = 0,
				arms = 36,
				pants_1 = 38,   pants_2 = 2,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = -1,     ears_2 = 0
		}
	},
	mecanico = {
		male = {-- TODO set properly
			tshirt_1 = 155,  tshirt_2 = 0,
			torso_1 = 65,   torso_2 = 1,
			decals_1 = 0,   decals_2 = 0,
			arms = 42,
			pants_1 = 38,   pants_2 = 2,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0
		},
		-- TODO female uniform
		female = {
				tshirt_1 = 191,  tshirt_2 = 0,
				torso_1 = 59,   torso_2 = 1,
				decals_1 = 0,   decals_2 = 0,
				arms = 36,
				pants_1 = 97,   pants_2 = 2,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 24,
				chain_1 = -1,    chain_2 = 0,
				ears_1 = 0,     ears_2 = 0
		}
	},
	oficial = {
		male = {-- TODO set properly
			tshirt_1 = 140,  tshirt_2 = 0,
			torso_1 = 247,   torso_2 = 1,
			decals_1 = 0,   decals_2 = 0,
			arms = 52,
			pants_1 = 98,   pants_2 = 22,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = 10,  helmet_2 = 3,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		-- TODO female uniform
		female = {
				tshirt_1 = 86,  tshirt_2 = 1,
				torso_1 = 255,   torso_2 = 1,
				decals_1 = 0,   decals_2 = 0,
				arms = 57,
				pants_1 = 101,   pants_2 = 2,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = -1,    chain_2 = 0,
				ears_1 = 0,     ears_2 = 0
		}
	},
	boss = {
		male = {-- TODO set properly
			tshirt_1 = 140,  tshirt_2 = 0,
			torso_1 = 247,   torso_2 = 1,
			decals_1 = 0,   decals_2 = 0,
			arms = 52,
			pants_1 = 98,   pants_2 = 23,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = 1,  helmet_2 = 2,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		-- TODO female uniform
		female = {
				tshirt_1 = 86,  tshirt_2 = 1,
				torso_1 = 255,   torso_2 = 6,
				decals_1 = 0,   decals_2 = 0,
				arms = 57,
				pants_1 = 101,   pants_2 = 23,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = -1,    chain_2 = 0,
				ears_1 = 0,     ears_2 = 0
		}
	},
}
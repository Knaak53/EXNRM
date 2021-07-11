Config                            = {}

Config.DrawDistance               = 20.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType                 = {Cloakrooms = 20, Armories = 21, BossActions = 22, Vehicles = 36, Helicopters = 34}
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 50, g = 50, b = 204}

Config.EnablePlayerManagement     = true -- Enable if you want society managing.
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- Enable if you're using esx_identity.
Config.EnableLicenses             = true -- Enable if you're using esx_license.

Config.EnableHandcuffTimer        = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer              = 10 * 60000 -- 10 minutes.

Config.EnableJobBlip              = true -- Enable blips for cops on duty, requires esx_society.
Config.EnableCustomPeds           = false -- Enable custom peds in cloak room? See Config.CustomPeds below to customize peds.

Config.EnableESXService           = true -- Enable esx service?
Config.MaxInService               = 20 -- How much people can be in service at once?

Config.Locale                     = 'en'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.0,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(452.6, -992.8, 30.6)
		},

		Armories = {
			vector3(485.67, -1006.72, 24.73)
		},

		Vehicles = {
			{
				Spawner = vector3(424.45, -973.12, 24.79),
				InsideShop = vector3(439.22, -982.62, 24.73),
				buySpawnCoords = vector3(428.771, -985.585, 25.73),
				SpawnPoints = {
					{coords = vector3(429.39, -981.42, 24.73), heading = 189.72, radius = 10.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 42.7),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				buySpawnCoords = vector3(449.354, -981.273, 43.692),
				SpawnPoints = {
					{coords = vector3(429.22, -983.03, 25.73), heading = 190.51, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(448.4, -973.2, 30.6)
		}

	}

}

Config.AuthorizedWeapons = {
	[4] = {
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 100, 250, nil}, price = 750},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 500},
		{weapon = 'WEAPON_FLASHLIGHT', price = 0}
	},

	[3] = {
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 100, 250, nil}, price = 750},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {100, 400, nil}, price = 1750},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 500},
		{weapon = 'WEAPON_FLASHLIGHT', price = 0}
	},

	[2] = {
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 100, 250, nil}, price = 750},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 400, 100, 250, 500, nil}, price = 2000},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {100, 400, nil}, price = 1750},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 500},
		{weapon = 'WEAPON_FLASHLIGHT', price = 0}
	},

	[1] = {
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 100, 250, nil}, price = 750},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 400, 100, 250, 500, nil}, price = 2000},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {100, 400, nil}, price = 1750},
		{weapon = 'WEAPON_SNIPERRIFLE', components = {100, 400, nil}, price = 2500},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 500},
		{weapon = 'WEAPON_FLASHLIGHT', price = 0}
	},

	[0] = {
		{weapon = 'WEAPON_COMBATPISTOL', components = {0, 0, 100, 250, nil}, price = 750},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 400, 100, 250, 500, nil}, price = 2000},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {100, 400, nil}, price = 1750},
		{weapon = 'WEAPON_SNIPERRIFLE', components = {100, 400, nil}, price = 2500},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 500},
		{weapon = 'WEAPON_FLASHLIGHT', price = 0}
	}
}

Config.AuthorizedVehicles = {
	car = {
		recruit = {},

		officer = {},

		sergeant = {},

		lieutenant = {
			{model = 'police3', price = 18000},
			{model = 'policet', price = 24000},
			{model = 'policeb', price = 12000},
			{model = 'riot', price = 32000},
			{model = 'fbi2', price = 28000}
		},

		boss = {
			{model = 'police3', price = 18000},
			{model = 'policet', price = 24000},
			{model = 'policeb', price = 12000},
			{model = 'riot', price = 32000},
			{model = 'fbi2', price = 28000}
		}
	},

	helicopter = {
		recruit = {},

		officer = {},

		sergeant = {
			{model = 'polmav', props = {modLivery = 0}, price = 75000}
		},

		lieutenant = {
			{model = 'polmav', props = {modLivery = 0}, price = 75000}
		},

		boss = {
			{model = 'polmav', props = {modLivery = 0}, price = 75000}
		}
	}
}

Config.CustomPeds = {
	shared = {
		--{label = 'Police Ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'}
	},

	recruit = {},

	officer = {},

	sergeant = {},

	lieutenant = {},

	boss = {}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	alumno = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = 46,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 330,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 30,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = 45,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	oficial = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 31,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 330,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 30,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	inspector = {
		male = {
		
		tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 1,
			arms = 41,
			pants_1 = 31,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 328,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 1,
			arms = 44,
			pants_1 = 30,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	comisario = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 2,
			arms = 41,
			pants_1 = 31,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 328,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 2,
			arms = 44,
			pants_1 = 30,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	boss = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 3,
			arms = 41,
			pants_1 = 31,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 328,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 3,
			arms = 44,
			pants_1 = 30,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 95,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	bullet_wear = {
		male = {
			bproof_1 = 11,  bproof_2 = 1
		},
		female = {
			bproof_1 = 13,  bproof_2 = 1
		}
	},

	gilet_wear = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1
		}
	}
}

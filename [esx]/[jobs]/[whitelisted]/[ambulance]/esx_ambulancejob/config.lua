Config                            = {}

Config.DrawDistance               = 20.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

Config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

Config.ReviveReward               = 700  -- Revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)
Config.LoadIpl                    = true -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'es'

Config.EarlyRespawnTimer          = 60000 * 1  -- time til respawn is available
Config.BleedoutTimer              = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement     = true -- Enable society managing (If you are using esx_society).

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = {coords = vector3(341.0, -1397.3, 32.5), heading = 48.5}

Config.AutoRevive = {
	vector3(337.95129394531,-570.87713623047,42.260807037354)
}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(292.97528076172,-582.88140869141,42.196689605713),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			--vector3(300.95269775391,-596.79455566406,42.284038543701)
			vector3(309.37060546875,-603.04296875,42.291820526123)
		},

		Pharmacies = {
			--vector3(298.81631469727,-598.50842285156,42.28405380249)
			vector3(310.86642456055,-599.44665527344,42.29178237915)
		},

		--Vehicles = {
		--	{
		--		Spawner = vector3(307.7, -1433.4, 30.0),
		--		InsideShop = vector3(446.7, -1355.6, 43.5),
		--		Marker = {type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true},
		--		SpawnPoints = {
		--			{coords = vector3(297.2, -1429.5, 29.8), heading = 227.6, radius = 4.0},
		--			{coords = vector3(294.0, -1433.1, 29.8), heading = 227.6, radius = 4.0},
		--			{coords = vector3(309.4, -1442.5, 29.8), heading = 227.6, radius = 6.0}
		--		}
		--	}
		--},

		Vehicles = {
			{
				Spawner = vector3(293.62, -598.0, 42.29),
				InsideShop = vector3(288.55, -595.11, 43.25),
				SpawnPoints = {
					{coords = vector3(290.17, -591.47, 43.25), heading = 43.18, radius = 4.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(338.31, -586.95, 73.17),
				InsideShop = vector3(351.68, -588.32, 74.30),
				SpawnPoints = {
					{coords = vector3(351.68, -588.32, 74.30), heading = 142.7, radius = 10.0}
				}
			}
		},

		FastTravels = {
			-- {
			-- 	From = vector3(294.7, -1448.1, 29.0),
			-- 	To = {coords = vector3(272.8, -1358.8, 23.5), heading = 0.0},
			-- 	Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(275.3, -1361, 23.5),
			-- 	To = {coords = vector3(295.8, -1446.5, 28.9), heading = 0.0},
			-- 	Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(372.44784545898,-1420.7821044922,31.510482788086),
			-- 	To = {coords = vector3(333.1, -1434.9, 45.5), heading = 138.6},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(335.5, -1432.0, 45.50),
			-- 	To = {coords = vector3(374.77920532227,-1418.0931396484,31.510429382324), heading = 0.0},
			-- 	Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(234.5, -1373.7, 20.9),
			-- 	To = {coords = vector3(320.9, -1478.6, 28.8), heading = 0.0},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- },

			-- {
			-- 	From = vector3(317.9, -1476.1, 28.9),
			-- 	To = {coords = vector3(238.6, -1368.4, 23.5), heading = 0.0},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			-- }
		},

		FastTravelsPrompt = {
			-- {
			-- 	From = vector3(237.4, -1373.8, 26.0),
			-- 	To = {coords = vector3(251.9, -1363.3, 38.5), heading = 0.0},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
			-- 	Prompt = _U('fast_travel')
			-- },

			-- {
			-- 	From = vector3(256.5, -1357.7, 36.0),
			-- 	To = {coords = vector3(235.4, -1372.8, 26.3), heading = 0.0},
			-- 	Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
			-- 	Prompt = _U('fast_travel')
			-- }
		}

	}
}

Config.AuthorizedVehicles = {
	car = {
		--ambulance = {
		--	{model = 'ambulance', price = 5000}
		--},

		--doctor = {
		--	{model = 'ambulance', price = 4500}
		--},

		chief_doctor = {
			{model = 'ambulance', price = 3000}
		},

		boss = {
			{model = 'ambulance', price = 2000}
		}
	},

	helicopter = {
		ambulance = {},

		--doctor = {
		--	{model = 'buzzard2', price = 150000}
		--},

		chief_doctor = {
			{model = 'buzzard2', price = 150000},
			{model = 'seasparrow', price = 300000}
		},

		boss = {
			{model = 'buzzard2', price = 10000},
			{model = 'seasparrow', price = 250000}
		}
	}
}


Config.Uniforms = {
	tecnico = {
		male = {
				tshirt_1 = 15,  tshirt_2 = 0,
				torso_1 = 250,   torso_2 = 1,
				decals_1 = 0,   decals_2 = 0,
				arms = 85,
				pants_1 = 96,   pants_2 = 1,
				shoes_1 = 12,   shoes_2 = 6,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 126,    chain_2 = 0,
				ears_1 = 0,     ears_2 = 0
		},
		female = {
				tshirt_1 = 14,  tshirt_2 = 0,
				torso_1 = 330,   torso_2 = 8,
				decals_1 = 66,   decals_2 = 0,
				arms = 98,
				pants_1 = 133,   pants_2 = 3,
				shoes_1 = 3,   shoes_2 = 1,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 96,    chain_2 = 0,
				ears_1 = -1,     ears_2 = -1
			}
	},
	auxiliar = {
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 250,   torso_2 = 1,
			decals_1 = 0,   decals_2 = 0,
			arms = 85,
			pants_1 = 96,   pants_2 = 1,
			shoes_1 = 12,   shoes_2 = 6,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 126,  chain_2 = 0,
			ears_1 = 0,     ears_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 330,   torso_2 = 1,
			decals_1 = 66,   decals_2 = 0,
			arms = 98,
			pants_1 = 133,   pants_2 = 3,
			shoes_1 = 3,   shoes_2 = 1,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 96,    chain_2 = 0,
			ears_1 = -1,     ears_2 = -1
		}
	},

	medico = {
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 250,   torso_2 = 1,
			decals_1 = 0,   decals_2 = 0,
			arms = 85,
			pants_1 = 96,   pants_2 = 1,
			shoes_1 = 12,   shoes_2 = 6,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 126,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 330,   torso_2 = 5,
			decals_1 = 66,   decals_2 = 0,
			arms = 98,
			pants_1 = 133,   pants_2 = 3,
			shoes_1 = 3,   shoes_2 = 1,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 96,    chain_2 = 0,
			ears_1 = -1,     ears_2 = -1
		}
	},

	doctor = {
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 250,   torso_2 = 1,
			decals_1 = 0,   decals_2 = 0,
			arms = 85,
			pants_1 = 96,   pants_2 = 1,
			shoes_1 = 12,   shoes_2 = 6,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 126,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 330,   torso_2 = 5,
			decals_1 = 66,   decals_2 = 0,
			arms = 98,
			pants_1 = 133,   pants_2 = 3,
			shoes_1 = 3,   shoes_2 = 1,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 96,    chain_2 = 0,
			ears_1 = -1,     ears_2 = -1
		}
	},

	boss = {
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 250,   torso_2 = 1,
			decals_1 = 0,   decals_2 = 0,
			arms = 85,
			pants_1 = 96,   pants_2 = 1,
			shoes_1 = 12,   shoes_2 = 6,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 126,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0
		},
		female = {
			tshirt_1 = 14,  tshirt_2 = 0,
			torso_1 = 332,   torso_2 = 0,
			decals_1 = 66,   decals_2 = 0,
			arms = 99,
			pants_1 = 133,   pants_2 = 3,
			shoes_1 = 3,   shoes_2 = 1,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 96,    chain_2 = 0,
			ears_1 = -1,     ears_2 = -1
		}
	},
}

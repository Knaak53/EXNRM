Config                            = {}

Config.ReviveReward               = 25  -- Revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dea.)
Config.LoadIpl                    = false -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'es'

Config.EarlyRespawnTimer          = 60000 * 7  -- time til respawn is available
Config.BleedoutTimer              = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement     = true -- Enable society managing (If you are using esx_society).

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = {coords = vector3(309, -581.64, 43.50), heading = 332.56}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(309.07, -581.68, 43.40),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

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
	}
}

Config.AuthorizedVehicles = {
	car = {
		ambulance = {},

		doctor = {
			{model = 'ambulance', price = 25000}
		},

		chief_doctor = {
			{model = 'ambulance', price = 25000}
		},

		boss = {
			{model = 'ambulance', price = 25000}
		}
	},

	helicopter = {
		ambulance = {},

		doctor = {
			{model = 'supervolito', price = 150000}
		},

		chief_doctor = {
			{model = 'supervolito', price = 150000}
		},

		boss = {
			{model = 'supervolito', price = 150000}
		}
	}
}
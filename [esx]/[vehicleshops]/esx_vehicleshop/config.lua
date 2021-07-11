Config                            = {}
Config.DrawDistance               = 20
Config.MarkerColor                = {r = 180, g = 0, b = 100}
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.ResellPercentage           = 50

Config.Locale                     = 'en'

Config.LicenseEnable = true -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 4
Config.PlateUseSpace = true

Config.Zones = {
	mid = {
		ShopEntering = {
			Pos   = vector3(-56.4, -1099.06, 25.4),
			Size  = {x = 1.5, y = 1.5, z = 1.5},
			Type  = 1,
			sprite = 596,
			spriteSize = 0.9,
			spriteName = 'Concesionario gama media'
		},

		ShopInside = {
			Pos     = vector3(-47.5, -1097.2, 25.4),
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Heading = -20.0,
			Type    = -1
		},

		ShopOutside = {
			Pos     = vector3(-28.6, -1085.6, 25.5),
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Heading = 330.0,
			Type    = -1
		},

		playerShopInside = {
			Pos   = vector3(130.82, -3214.0, 5.86),
			heading = 301.31
		},

		ResellVehicle = {
			Pos   = vector3(-45.1, -1082.07, 26.6),
			Size  = {x = 2.0, y = 2.0, z = 2.0},
			Type  = 36
		}
	},
	low = {
		ShopEntering = {
			Pos   = vector3(-43.96, -1666.58, 28.49),
			Size  = {x = 1.5, y = 1.5, z = 0.7},
			Type  = 1,
			sprite = 326,
			spriteSize = 0.8,
			spriteName = 'Concesionario gama baja'
		},

		ShopInside = {
			Pos     = vector3(-47.06, -1682.08, 28.44),
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Heading = -20.0,
			Type    = -1
		},

		ShopOutside = {
			Pos     = vector3(-25.62, -1679.79, 28.44),
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Heading = 114.85,
			Type    = -1
		},

		playerShopInside = {
			Pos   = vector3(142.42, -3185.9, 5.86),
			heading = 220.16
		},

		ResellVehicle = {
			Pos   = vector3(-52.72, -1693.66, 28.49),
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Type  = 1
		}
	},
	high = {
		ShopEntering = {
			Pos   = vector3(-141.76, -604.64, 166.6),
			Size  = {x = 1.5, y = 1.5, z = 0.7},
			Type  = 1,
			sprite = 595,
			spriteSize = 1.0,
			spriteName = 'Concesionario gama alta'
		},

		ShopInside = {
			Pos     = vector3(-148.02, -595.44, 166.0),
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Heading = -20.0,
			Type    = -1
		},

		ShopOutside = {
			Pos     = vector3(-104.034, -607.596, 36.072),
			Size    = {x = 1.5, y = 1.5, z = 1.0},
			Heading = 155.95,
			Type    = -1
		},

		playerShopInside = {
			Pos   = vector3(144.79, -3207.89, 5.86),
			heading = 43.11
		},

		ResellVehicle = {
			Pos   = vector3(-154.42, -164.77, 42.62),
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Type  = 1
		}
	}
}
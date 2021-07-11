Config              = {}
Config.DrawDistance = 25
Config.Locale       = 'en'

Config.JobVehiclePlate = 'CORREOS' -- Plaque des vehicules du job (maximun 8 caractères)
Config.MaxLetter	   = 4 -- Maximum de lettre par point
Config.MinLetter	   = 1 -- Maximum de lettre par point
Config.MaxColis		   = 2 -- Maximum de colis par point
Config.MinColis		   = 0 -- Maximum de colis par point

Config.Caution 		   = 350
Config.PricePerLetter  = 9
Config.PricePerColis   = 15

Config.Vehicle = { -- Ajouter les véhicules du métier ici
	"boxville2"
}

Config.fianza = 250

Config.letterbox = {}
Config.letterbox.model = "prop_letterbox_03"
Config.Zones = { -- Emplacement des points
	CloakRoom = {
		Pos   = vector3(132.35, 95.39, 82.51),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 231, g = 76, b = 60},
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos     = vector3(131.14, 88.28, 82.25),
		Heading = 251.8, -- Orientation 
		Size    = {x = 3.0, y = 3.0, z = 1.0},
		Type    = -1
	},

	VehicleDeleter = {
		Pos   = vector3(115.91, 99.44, 80.9),
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 142, g = 0, b = 0},
		Type  = 39
	}
}

Config.Uniforms = { -- Tenue de service
	
	male = {
		['tshirt_1'] = 57,  ['tshirt_2'] = 0,
		['torso_1'] = 13,   ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 11,
		['pants_1'] = 10,   ['pants_2'] = 2,
		['shoes_1'] = 54,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 12,    ['chain_2'] = 2,
		['ears_1'] = -1,     ['ears_2'] = 0
	},
	female = {
		['tshirt_1'] = 34,  ['tshirt_2'] = 0,
		['torso_1'] = 9,   ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 9,
		['pants_1'] = 6,   ['pants_2'] = 2,
		['shoes_1'] = 52,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 2,
		['ears_1'] = -1,     ['ears_2'] = 0
	}
}


-- Point des livraisons

Config.Livraisons = {
	Richman = {
		Pos = {
			{x = -1125.671, y = 391.366, z = 69.446, letter = true, colis = true, heading = 175.268},
			{x = -1100.467, y = 289.486, z = 63.034, letter = true, colis = true, heading = 7.682},
			{x = -1476.541, y = -10.114, z = 53.653, letter = true, colis = true, heading = 106.513},
			{x = -1536.043, y = -38.703, z = 56.483, letter = true, colis = true, heading = 133.522},
			{x = -1542.252, y = -29.43, z = 56.82, letter = true, colis = true, heading = 64.334},
			{x = -1466.668, y = 51.361, z = 53.063, letter = true, colis = true, heading = 188.137},
			{x = -1466.61, y = 63.303, z = 52.023, letter = true, colis = true, heading = 0.359},
			{x = -1502.078, y = 40.502, z = 54.245, letter = true, colis = true, heading = 179.823},
			{x = -1590.066, y = 43.214, z = 59.137, letter = true, colis = false, heading = 166.8},
			{x = -1621.855, y = 57.323, z = 60.94, letter = true, colis = true, heading = 150.108},
			{x = -1621.085, y = 76.863, z = 60.696, letter = true, colis = true, heading = 8.516},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 211, g = 84, b = 0},
        Type  = 1
	},

	RockfordHills = {
		Pos = {
			{x = -824.814, y = -26.915, z = 37.896, letter = true, colis = true, heading = 76.32},
			{x = -878.509, y = 3.777, z = 43.314, letter = true, colis = true, heading = 113.282},
			{x = -881.805, y = 20.081, z = 44.061, letter = true, colis = true, heading = 330.84},
			{x = -906.399, y = 20.929, z = 45.607, letter = true, colis = true, heading = 85.64},
			{x = -849.516, y = 105.527, z = 52.176, letter = true, colis = true, heading = 274.802},
			{x = -849.76, y = 180.216, z = 69.055, letter = true, colis = true, heading = 262.73},
			{x = -924.957, y = 181.502, z = 65.987, letter = true, colis = true, heading = 308.971},
			{x = -955.761, y = 176.956, z = 64.292, letter = true, colis = true, heading = 355.246},
			{x = -937.164, y = 120.5, z = 56.036, letter = true, colis = false, heading = 144.013},
			{x = -954.05, y = 127.011, z = 56.778, letter = true, colis = true, heading = 121.951},
			{x = -982.331, y = 150.079, z = 60.401, letter = true, colis = true, heading = 120.578},
			{x = -1049.768, y = 209.522, z = 62.478, letter = true, colis = true, heading = 97.028},			
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 46, g = 204, b = 113},
        Type  = 1
	},

	Vespucci = {
		Pos = {
			{x = -1090.172, y = -924.221, z = 2.1418874263763, letter = true, colis = true, heading = 205.306},
			{x = -1030.613, y = -902.487, z = 2.71, letter = true, colis = true, heading = 206.477},
			{x = -945.919, y = -904.908, z = 1.15, letter = true, colis = true, heading = 118.471},
			{x = -922.638, y = -946.327, z = 1.15, letter = true, colis = true, heading = 29.815},
			{x = -942.759, y = -1087.394, z = 1.15, letter = true, colis = true, heading = 207.42},
			{x = -952.223, y = -1079.928, z = 1.15, letter = true, colis = true, heading = 25.626},
			{x = -1026.03, y = -1138.684, z = 1.159, letter = true, colis = true, heading = 206.477},
			{x = -1063.764, y = -1158.119, z = 1.119, letter = true, colis = true, heading = 206.477},
			{x = -1254.672, y = -1328.762, z = 3.024, letter = true, colis = true, heading = 110.187},
			{x = -1104.986, y = -1536.088, z = 3.38, letter = true, colis = true, heading = 300.114},
			{x = -1114.778, y = -1575.777, z = 3.54, letter = true, colis = true, heading = 212.275},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 52, g = 152, b = 219},
        Type  = 1
	},

	SLS = {
		Pos = {
			{x = -53.895, y = -1789.71, z = 26.845, letter = true, colis = true, heading = 315.472},
			{x = 15.294, y = -1850.268, z = 23.004, letter = true, colis = true, heading = 321.604},
			{x = 112.2, y = -1956.133, z = 19.751, letter = true, colis = true, heading = 198.426},
			{x = 150.3, y = -1896.927, z = 22.122, letter = true, colis = true, heading = 155.847},
			{x = 146.694, y = -1869.828, z = 23.084, letter = true, colis = true, heading = 337.889},
			{x = 220.512, y = -1720.316, z = 28.271, letter = true, colis = true, heading = 40.717},
			{x = 245.917, y = -1727.459, z = 28.374, letter = true, colis = true, heading = 229.363},
			{x = 263.451, y = -1705.434, z = 28.259, letter = true, colis = true, heading = 231.139},
			{x = 333.69, y = -1745.657, z = 28.37, letter = true, colis = true, heading = 315.275},
			{x = 310.312, y = -1780.328, z = 27.453, letter = true, colis = true, heading = 49.46},
			{x = 321.916, y = -1840.741, z = 26.231, letter = true, colis = true, heading = 224.776},
			{x = 438.664, y = -1836.193, z = 26.967, letter = true, colis = true, heading = 310.174},
			{x = 391.787, y = -1885.874, z = 24.504, letter = true, colis = true, heading = 47.685},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 241, g = 196, b = 15},
        Type  = 1
    }

}

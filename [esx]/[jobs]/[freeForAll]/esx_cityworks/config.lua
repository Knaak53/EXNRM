Config                            = {}
Config.DrawDistance               = 25.0
Config.nameJob                    = "works"
Config.nameJobLabel               = "Mantenimiento de Caronte"
Config.platePrefix                = "MCC"
Config.Locale                     = 'fr'

Config.Vehicles = {
	Truck = {
		Spawner = 1,
		Label = 'Caronte service truck',
		Hash = "boxville",
		Livery = 0,
		Trailer = "none",
	}	
}

Config.fianza = 250

Config.Zones = {

  Cloakroom = {
    Pos     = vector3(2476.77, -359.57, 92.83),
    Size    = {x = 1.5, y = 1.5, z = 0.3},
    Color   = {r = 0, g = 0, b = 255},
    Type    = 1,
	BlipSprite = 354,
	BlipColor = 46,
	BlipName = 'Oficinas de mantenimiento de Caronte',
	hint = 'Pulsa ~INPUT_CONTEXT~ para acceder al vestuario',
  },

  VehicleSpawnPoint = {
	Pos   = vector3(2489.2, -317.35, 92.99),
	Size  = {x = 3.0, y = 3.0, z = 1.0},
	Type  = -1,
	Heading = 358.04,
  },

  VehicleDeleter = {
	Pos   = vector3(2501.507, -316.393, 92.998),
	Size  = {x = 1.5, y = 1.5, z = 1.5},
	Color = {r = 255, g = 0, b = 0},
	Type  = 1,
	BlipName = Config.nameJobLabel.." : Devolver vehiculo",
	hint = 'Pulsa ~INPUT_CONTEXT~ para devolver el vehiculo',
  },
}

Config.Uniforms = {

  job_wear = {
    male = {
        ['tshirt_1'] = 59, ['tshirt_2'] = 0,
		['torso_1'] = 0, ['torso_2'] = 8,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 30,
		['pants_1'] = 37, ['pants_2'] = 1,
		['shoes_1'] = 12, ['shoes_2'] = 6,
		['chain_1'] = 0, ['chain_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['helmet_1'] = 25, ['helmet_2'] = 2,
		['watches_1'] = 20, ['watches_2'] = 0,
		['bracelets_1'] = -1, ['bracelets_2'] = 0,
		['glasses_1'] = 0, ['glasses_2'] = 0,
		['bag'] = 0,
		['ear_accessories'] = 0,
    },
    female = {
        ['tshirt_1'] = 36, ['tshirt_2'] = 0,
		['torso_1'] = 16, ['torso_2'] = 6,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 37,
		['pants_1'] = 37, ['pants_2'] = 1,
		['shoes_1'] = 55, ['shoes_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['helmet_1'] = 53, ['helmet_2'] = 0,
		['watches_1'] = 20, ['watches_2'] = 0,
		['bracelets_1'] = -1, ['bracelets_2'] = 0,
		['glasses_1'] = 0, ['glasses_2'] = 0,
		['bag'] = 0,
		['ear_accessories'] = 0,
    }
  },
}
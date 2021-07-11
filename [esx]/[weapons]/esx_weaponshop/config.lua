Config               = {}

Config.DrawDistance  = 15
Config.Size          = { x = 1.5, y = 1.5, z = 0.5 }
Config.Color         = { r = 0, g = 128, b = 255 }
Config.Type          = 1

Config.Locale        = 'es'

Config.LicenseEnable = true -- only turn this on if you are using esx_license
Config.LicensePrice  = 5000

Config.Zones = {

	GunShop = {
		Legal = true,
		Items = {
			{['label'] = 'Pistola 9mm', ['item'] = 'WEAPON_PISTOL', ['price'] = 2500},
		    {['label'] = 'Machete Jungle King', ['item'] = 'WEAPON_MACHETE', ['price'] = 1000},
		    {['label'] = 'Cuchillo de supervivencia', ['item'] = 'WEAPON_KNIFE', ['price'] = 750},
		    {['label'] = 'Bate de Baseball', ['item'] = 'WEAPON_BAT', ['price'] = 500}
		},
		Locations = {
			{coords = vector3(-662.24, -933.61, 20.83), heading = 177.74},
			{coords = vector3(810.29, -2159.02, 28.6), heading = 356.33},
			{coords = vector3(1692.28, 3760.92, 33.71), heading = 220.98},
			{coords = vector3(-331.53, 6085.07, 30.45), heading = 224.16},
			{coords = vector3(253.8, -50.52, 68.94), heading = 68.99},
			{coords = vector3(22.61, -1105.46, 28.8), heading = 158.63},
			{coords = vector3(2567.68, 292.64, 107.73), heading = 352.58},
			{coords = vector3(-1118.93, 2699.74, 17.55), heading = 217.01},
			{coords = vector3(842.37, -1035.31, 27.19), heading = 353.62}
		}
	},

	BlackWeashop = {
		Legal = false,
		Items = {},
		Locations = {}
	}
}

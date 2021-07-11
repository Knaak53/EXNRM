Config                            = {}
Config.Locale                     = 'en'

--- #### MARKER EDITS
Config.TypeMarker = 27
Config.MarkerScale = { x = 0.3, y = 0.3, z = 0.3}
Config.MarkerColor = { r = 0, g = 255, b = 255}

Config.bikes = {
	{name = "tribike2", label = "Bici de carretera", price = 55},
	{name = "scorcher", label = "Bici de Montaña", price = 67},
	{name = "cruiser", label = "Bici de Paseo", price = 79},
	{name = "bmx", label = "BMX", price = 63},
}

Config.fianza = 250
	
Config.MarkerZones = { 
    {
    	x = -251.01,
    	y = -318.89,
    	z = 29.24, 
    	heading = 94.03, 
    	structure = {
    		cabin = {
    			coords = vector3(-250.89, -318.6, 29.0),
    			heading = 98.0,
    			model = "prop_tollbooth_1"
    		},
    		signal = {
    			coords = vector3(-251.99, -318.02, 29.01),
    			heading = 280.0,
    			model = "prop_sign_road_04j"
    		}
    	},
    	spawnPoint = {
    		coords = vector3(-251.66, -315.93, 30.16),
    		heading = 107.02
    	}
    },
    {
    	x = 256.23,
    	y = -865.51,
    	z = 28.61, 
    	heading = 161.13, 
    	structure = {
    		cabin = {
    			coords = vector3(255.91, -865.13, 28.30),
    			heading = 159.5,
    			model = "prop_tollbooth_1"
    		},
    		signal = {
    			coords = vector3(254.82, -865.8, 28.39),
    			heading = 340.0,
    			model = "prop_sign_road_04j"
    		}
    	},
    	spawnPoint = {
    		coords = vector3(256.82, -868.64, 29.32),
    		heading = 246.55
    	}
    },
    {
    	x = -1014.58,
    	y = -2692.66,
    	z = 13.21, 
    	heading = 151.92, 
    	structure = {
    		cabin = {
    			coords = vector3(-1014.91, -2692.45, 12.97),
    			heading = 150.3,
    			model = "prop_tollbooth_1"
    		},
    		signal = {
    			coords = vector3(-1016.12, -2692.92, 12.98),
    			heading = 340.0,
    			model = "prop_sign_road_04j"
    		}
    	},
    	spawnPoint = {
    		coords = vector3(-1015.94, -2695.58, 13.98),
    		heading = 145.27
    	}
    }, 
    {
    	x = 63.52,
    	y = -1533.06,
    	z = 28.53, 
    	heading = 47.24, 
    	structure = {
    		cabin = {
    			coords = vector3(63.74, -1532.88, 28.29),
    			heading = 49.8,
    			model = "prop_tollbooth_1"
    		}
    	},
    	spawnPoint = {
    		coords = vector3(62.6, -1530.18, 29.3),
    		heading = 0.0
    	}
    }, 
    {
    	x = -1262.36,
    	y = -1438.98,
    	z = 3.35, 
    	heading = 83.57, 
    	structure = {},
    	spawnPoint = {
    		coords = vector3(-1264.4, -1440.37, 4.35),
    		heading = 130.0
    	}
    },
}

-- Edit blip titles
Config.BlipZones = { 
	vector3(-250.89, -318.6, 29.0),
	vector3(256.21, -865.33, 28.61),
	vector3(-1262.36, -1438.98, 3.25),
	vector3(-1014.91, -2692.45, 12.97),
	vector3(63.74, -1532.88, 28.29)
}

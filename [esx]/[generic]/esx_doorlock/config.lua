Config = {}
Config.Locale = 'es'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police', 'offpolice' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = -165604314,
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 1388858739,
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},

	--entrada a oficina puerta con cristal en pasillo con detector de metales
	{
		objName = 165994623,
		objYaw = 180.0,
		objCoords  = vector3(441.7664, -994.2772, 30.81),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},
	--puerta madera garaje
	{
		objName = 165994623,
		objYaw = 90.0,
		objCoords  = vector3(464.8759, -989.3229, 25.86),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	--verja del parking
	{
		objName = 725274945,
		objYaw = 270.0,
		distance = 15.0,
		objCoords  = vector3(411.0243, -1025.059, 28.337),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	--celdas
	--1
	{
		objName = -1988553564,
		objYaw = 0.0,
		objCoords  = vector3(462.1454, -989.1444, 34.33),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},
	--2
	{
		objName = -1988553564,
		objYaw = 0.0,
		objCoords  = vector3(456.2224, -989.1444, 34.33),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},
	--3
	{
		objName = -1988553564,
		objYaw = 0.0,
		objCoords  = vector3(450.2895, -989.1444, 34.33),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},
	--4
	{
		objName = -884718443,
		objYaw = 180.0,
		objCoords  = vector3(448.9915, -984.6697, 34.34),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},
	--5
	{
		objName = -884718443,
		objYaw = 180.0,
		objCoords  = vector3(454.9189, -984.6697, 34.34),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},
	--6
	{
		objName = -1988553564,
		objYaw = 180.0,
		objCoords  = vector3(460.8466, -984.6697, 34.34),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	-- Back (double doors)
	{
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		doors = {
			{
				objName = -165604314,
				objYaw = 180.0,
				objCoords  = vector3(443.75, -998.08, 30.69)
			},

			{
				objName = 1388858739,
				objYaw = 180.0,
				objCoords  = vector3(442.0, -998.17, 30.69)
			}
		}
	},
	{
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		doors = {
			{
				objName = -165604314,
				objYaw = 180.0,
				objCoords  = vector3(441.2427, -998.68, 30.79)
			},

			{
				objName = 1388858739,
				objYaw = 180.0,
				objCoords  = vector3(439.15, -998.68, 30.73)
			}
		}
	},

	{
		objName = -427498890,
		objCoords  = vector3(-205.6828, -1310.683, 30.2977),
		authorizedJobs = {'mechanic', 'offmechanic'},
		locked = true,
		distance = 14,
		size = 2
	},

	--cierre de puerta en tienda para separar del procesado de coca
	{
		objName = 1173348778,
		objYaw = 290.0,
		objCoords  = vector3(1395.613, 3609.327, 35.13078),
		authorizedJobs = { 'none' },
		locked = true
	},
}
Config	=	{}

Config.CheckOwnership = true -- If true, Only owner of vehicle can store items in trunk.
Config.AllowPolice = true -- If true, police will be able to search players' trunks.

Config.Locale   = 'en'

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 45

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.

Config.VehicleLimit = {
    [0] = 80, --Compact
    [1] = 100, --Sedan
    [2] = 100, --SUV
    [3] = 80, --Coupes
    [4] = 60, --Muscle
    [5] = 45, --Sports Classics
    [6] = 40, --Sports
    [7] = 30, --Super
    [8] = 0, --Motorcycles
    [9] = 120, --Off-road
    [10] = 200, --Industrial
    [11] = 200, --Utility
    [12] = 100, --Vans
    [13] = 0, --Cycles
    [14] = 80, --Boats
    [15] = 0, --Helicopters
    [16] = 0, --Planes
    [17] = 80, --Service
    [18] = 90, --Emergency
    [19] = 160, --Military
    [20] = 130, --Commercial
    [21] = 0, --Trains

}

Config.VehicleModel = {

    brickade    = 1500000, --Commercial
    rallytruck  = 1500000, --Commercial
    armarello  = 1000000, --Commercial
    hauler  = 1000000, --Commercial
    ramvan  = 1000000, --Commercial
    phantom  = 800000, --Commercial
    phantomhd  = 800000, --Commercial
    vnl780  = 800000, --Commercial
    guardian    = 350000, --Vans
    ramlh20	= 350000, -- Off-road

}
Config = {}
Config.Locale = 'es'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney = {money = 1500, bank = 1500}

Config.EnableSocietyPayouts = true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.DisableWantedLevel   = true
Config.EnableHud            = false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.EnablePvP            = true -- enable pvp?
Config.MaxWeight            = 15   -- the max inventory weight without backpack(this is in grams, not kg!)
Config.kashcharacterEnabled = true

Config.PaycheckInterval     = 30 * 60000 -- how often to recieve pay checks in milliseconds

Config.EnableDebug          = true
Config.PrimaryIdentifier	= "fivem" -- Options: steam, license (social club), fivem, discord, xbl, live (default steam, recommended: fivem) this SHOULD function with most older scripts too!

-- The default player model you will use if no other scripts control your player model
-- We have set a MP ped as default since if you use another script that controls your player model
-- then this will make them invisible until the actual outfit/model has loaded, this looks better than
-- loading another model then changing it immediately after
Config.DefaultPlayerModel	= `mp_m_freemode_01`

Config.DefaultPickupModel = `prop_money_bag_01`


Config.VehicleWeightLimit = {
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

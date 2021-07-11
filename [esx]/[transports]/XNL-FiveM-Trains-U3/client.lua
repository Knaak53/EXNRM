--[[
=====================================================================================================================================	
    License, Credits, Basic information, FAQ
=====================================================================================================================================	
	Based on/inspired by: 
	Blumlaut (FiveM Community) / Bluethefurry (Github)
	Original Post:	 https://forum.fivem.net/t/release-trains/28841
	Original Script: https://github.com/Bluethefurry/FiveM-Trains/releases
	
	(Re-)Created by: VenomXNL
	License: Use it as you please but do have decency and respect by crediting the original creators :)
	
	What is it?: A very extensive Train and (well mostely) Metro Addon for FiveM
	
	Basic Functionality list:
	  - Spawns a 'synced' (and working/driving) Freight train on the railroad tracks of Los Santos
	  - Spawns (1 or 2) Metro carts which can be entered as passenger by the players ("no passenger limit!")
	  - Players can WALK AROUND in the moving Metro! :)
	  - Players HAVE to buy a Metro Ticket to be able to enter (With (ATM) animated Ticket machine handling)
	  - Ticket will 'invalidate' when they have entered so they will have to buy a new one
	  - Wanted level handling (refuse passengers from entering when wanted)
	  - 'terrorist detection', which means if players shoot while on the train they will get a 4 star wanted level
	  - Easily configurable with basic variables
	  - Different Bank Messages (for Maze Bank, Bank of Liberty or Fleeca bank)
	  - Metro's, Freight Train and their drivers are 'invincible' (to prevent others 'ruining' the game/RP)
	  - Players can only EXIT the Metro at the stations (by Pressing [E] by default)
	  - Players COULD enter the Metro ANYWHERE (if they have a Ticket Of course), by making it stop (stand in front of it)
	  
	Known 'bugs' or 'issues':
	  - The Metro's DO NOT stop at the stations this is due to a limitation in the 'official game script'!
	    I CAN change this and HAD changed this, but this will increase the chance of de-syncing A LOT so I've removed it!
	  - When you enter the Metro as passenger the doors 'will dissapear', why? I don't know, but you can NOT walk through it!
		NOTE: They CAN still be used as cover though (the bottom part), which means the 'collision info' will remain active though.
	  - The ticket machines above ground (the green/old ones) DO NOT WORK, I tried for several hours to find them in the archives but
		with no luck. I however did find one that looks like it, but that one doesn't respond at all.
		I MIGHT update that when someone can tell me the model of that ticket machine object, however for now I have left it at that.
		Also because the original game-texture says: "Sorry, this machine will NEVER work", so i thought: lets keep it in lore :P (nice excuse huh? haha)
	  - When a player puts a vehicle (which doesn't automatically despawns) infront of the Metro, the Metro will wait there till the
		vehicle is removed for eternity.
	  
	Questions I've already got from our server member/crew while we where testing this script:
	  - Q: Can you make it so you can drive the Freight or Metro?
	  - A: Yes, I can.
	  
	  - Q: WILL you make it so we can drive either of them?
	  - A: Already done it, Let's test it :P
	  
	  - Q: (Player on the other side while i'm driving the train:) Woaha, why the f*ck is my train tripping so hard?
	  - A: Well mine isn't, Maybe it's because i'm driving backwards but YOUR game (engine) isn't expecting it.
	  
	  - Q: So you have now (permanently) removed the feature to drive the trains?
	  - A: Yes, I have. And I have even DELETED THE CODE, so I will NOT remake it, since it's not stable enough.
	  
	  Well that's about the 'main question' I expect to show up (since nearly everyone whom tested it did so to)
	  So my basic awnser is: NOPE I will note make it like that sorry.
	  Maybe there are others whom have managed to do it, and did made a syncing system (server sided or so), I haven't
	  and I won't, Sorry. Most of my scripts and server are client-sided with minimal network traffic (via scripting),
	  only statistics, financials and owned matterials (like houses, cars or items) are server sided to prevent cheating.
	  And since we won't need the train or metro driver missions I can't 'afford' to put to much time in developing something
	  stable and thoroughly tested while I'm not going to use it anyway ;)
	  
	Other Possible Questions:
	  - Q: Can I use this on my server?
	  - A: Sure you can that's why I've uploaded it :)
	  
	  - Q: Can you please help me add or make my money/banking system?
	  - A: No, sorry. I'm VERY busy with me job and other projects, I decided to share my code's_m_m_lsmetro_01
		   to public for others to use, possibly adapt and for others to learn from them (hence the massive commenting!).
		   I have learned it the same way years ago: Looking at other people's codes and trying what would change things or
		   make it do what I wanted it to do.
	   
	  - Q: So you're basically saying I "just need to learn" to script/program?
	  - A: YES, if you would like to run servers and games like this, and thus use mods, it's DEFINITLY a MUST if you can,
		   it might look hard in the beginning, but trust me: You will be thankful if you learn it yourself :)
		   
	  - Q: But you also stated that I can adapt your code right?
	  - A: Sure, adapt, improve, or even 'strip(remove) stuff from it' to make it suit your needs
		   NOTE: Please do not just 'destroy the code' by randomly doing stuff and then posting stuff like:
		   'I "changed" this, and now your  code doesn't work anymore'. If that happens I suggest you keep trying
		   till it DOES what you need, investigate about the Native codes, look on other sites for resources and
		   information, you can ofcourse ask questions, no problem. Just keep in mind that I'm not going to (not even
		   able to due to my schedule IF I wanted to)) script all kinds of things for everyone randomly ;) :)
	  
	  - Q: One more question though: If I can adapt your code, am I also allowed to re-upload it?
	  - A: Yes you are! :) BUT please do give credits to me and the original creator on whom's idea this
		   scripted was based and inspired on. (AKA: It's NOT allowed to reupload/publish without credits where due)
	  
	General adivce (applies to ALL uploading coders):
	If this script/addon doesn't do what you wanted it to do, if you think it's "sh*tty" etc, that's all fine, but
	just keep that to yourself and find another one that suits your needs (or even better: Make it yourself) ;)
	Keep in mind that people upload code to help/provide others in resources and learning matterial, and that doing so
	costs (extra) time. Time they took to provide you (and many others) with resources, code, samples and addons.
	Contribute, help, share and evolve together, that's the power of a community :)
	(Ofcourse doesn't mean that constructive critisim isn't welcome or desired (since we all will always have points of
	improvement :) )
	  
	=================================== Money Handling Information ===================================
	 If the rest if TL;DR, fine, your problem ;) :P (Don't nag either if you can't figure it out haha)
	 But ATLEAST do read this piece for setup! and IF you have questions, or if want to Adapt or
	 re-publish/upload it: Don't be stubborn, respect other peoples work, and DO read the above ;)
	===================================================================================================
	IMPORTANT NOTE: Bellow 'somewhere' in the code you will find these two lines:
	BankAmount = 10000    --StatGetInt("BANK_BALANCE",-1)
	PlayerCashAm = 10000  --StatGetInt("MP0_WALLET_BALANCE",-1)
	
	Make sure that you adapt them to YOUR OWN SERVER, since like stated there (in the script to),
	many servers use a different money management system, and thus it's not quite possible to make
	one that is 'general in use' for all. We use one that doesn't uses the game stats at all (since thats
	to easy to influence with cheat programs for example). To make sure that people could test/try this
	script i have set the INTERNAL SCRIPT money values to very high (those DO NOT affect the player itself though!)

	This also means that there is no money being taken from the player when he/she buy's a ticket
	
	To make sure that money is taken from the player when buying a ticked you will need to find the following code part:
		if PayWithBank == 1 then
			-- Put YOUR code to deduct the amount from the players BANK account here
			-- 'Basic Example':  PlayerBankMoney = PlayerBankMoney - TicketPrice
		else
			-- Put YOUR code to deduct the amount from the players CASH money account here
			-- 'Basic Example':  PlayerCash = PlayerCash - TicketPrice
		end
	
	And add your OWN SERVER money handling/taking code here
	
	I hope this code/addon is usefull for some people or that they might learn from it by using parts of it :)
	
	Greets,
	VenomXNL
=====================================================================================================================================	
]]

--===================================================
-- Variables used BY the script, do NOT modify them
-- unless you know what you are doing!
-- Modifying these might/will result in undesired
-- behaviour and/or script breaking!
--===================================================
EverythingisK = false


--===================================================
-- These are radius locations (multiple per station)
-- to detect if the player can exit the Metro
--===================================================
-- These are the 'exit points' to where the player is teleported with the short fade-out / fade-in
-- NOTE: XNLStationid is NOT used in this table, it's just here for user refrence!

Citizen.CreateThread(function()
	function LoadTrainModels() -- f*ck your rails, too!
		tempmodel = GetHashKey("freight")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
		
		tempmodel = GetHashKey("freightcar")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
		
		tempmodel = GetHashKey("freightgrain")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
		
		tempmodel = GetHashKey("freightcont1")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
		
		tempmodel = GetHashKey("freightcont2")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
		
		tempmodel = GetHashKey("freighttrailer")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end

		tempmodel = GetHashKey("tankercar")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
		
		tempmodel = GetHashKey("metrotrain")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
		
		tempmodel = GetHashKey("s_m_m_lsmetro_01")
		RequestModel(tempmodel)
		while not HasModelLoaded(tempmodel) do
			RequestModel(tempmodel)
			Citizen.Wait(0)
		end
	end

	LoadTrainModels()

	RegisterNetEvent("StartTrain")
	function StartTrain()
		--Citizen.Trace("a train has arrived") -- whee i must be host, lucky me
		randomSpawn = math.random(#TrainLocations)
		x,y,z = TrainLocations[randomSpawn][1], TrainLocations[randomSpawn][2], TrainLocations[randomSpawn][3] -- get some random locations for our spawn
	
	
		-- For those whom are interested: The yesorno variable determines the direction of the train ;)
		yesorno = math.random(0,100)
		if yesorno >= 50 then -- untested, but seems to work /shrug
			yesorno = true
		elseif yesorno < 50 then
			yesorno = false
		end
		
		--====================================================================================
		-- Note: This (DeleteAllTrains()) might work when you join a session or so which
		-- has 'roque trains' (aka with no host or where the host just left while you joined)
		-- but I (VenomXNL) have noticed that it has no effect at all when the script is
		-- restarted and clients stay in the session, however it will not spawn any new ones
		-- either since it doesn't detect a player connecting.
		-- I suspect that it doesn't remove/delete the trains since the game would still see
		-- them as Mission Trains which would require the native deleteMissionTrain.
		-- Although it is impossible to call this native since after a restart of this script
		-- we no longer have a refrence to call them.
		-- I will leave the call here as intended by the original developer, but I SUSPECT
		-- that it would not have much use (but can't confirm it with 100% certainty though)
		--====================================================================================
		DeleteAllTrains()
		Wait(100)
		Train = CreateMissionTrain(math.random(0,22), x,y,z,yesorno)
		Wait(200) -- Added a small 'waiting' while the train is loaded (to prevent the)
				  -- random unexplained spawning of the freight train on the Metro Rails
		
		MetroTrain = CreateMissionTrain(24,40.2,-1201.3,31.0,true) -- these ones have pre-defined spawns since they are a pain to set up
		Wait(200) -- Added a small 'waiting' while the train is loaded (to prevent the)
				  -- random unexplained spawning of the freight train on the Metro Rails
		
		if UseTwoMetros == 1 then
			MetroTrain2 = CreateMissionTrain(24,-618.0,-1476.8,16.2,true)
		end
		Wait(200) -- Added a small 'waiting' while the train is loaded (to prevent the)
				  -- random unexplained spawning of the freight train on the Metro Rails

		TrainDriverHash = GetHashKey("s_m_m_lsmetro_01")

		-- By making a refrence to the drivers we can call them further on to make them invincible for example.
		Driver1 = CreatePedInsideVehicle(Train, 26, TrainDriverHash, -1, 1, true)
		Driver2 = CreatePedInsideVehicle(MetroTrain, 26, TrainDriverHash, -1, 1, true)

		if UseTwoMetros == 1 then
			Driver3 = CreatePedInsideVehicle(MetroTrain2, 26, TrainDriverHash, -1, 1, true) -- create peds for the trains
		end
		
		--=========================================================
		-- XNL 'Addition': This SHOULD prevent the train driver(s)
		-- from getting shot or fleeing out of the train/tram when
		-- being targeted by the player.
		-- We have had several instances where the tram driver just
		-- teleported out of the tram to attack the player when it
		-- it was targeted (even without holding a weapon).
		-- I suspect that this behaviour is default in the game
		-- unless you override it.
		--=========================================================
		SetBlockingOfNonTemporaryEvents(driver1, true)
		SetPedFleeAttributes(driver1, 0, 0)
		SetEntityInvincible(driver1, true)
		SetEntityAsMissionEntity(Driver1, true)


		SetBlockingOfNonTemporaryEvents(Driver3, true)
		SetPedFleeAttributes(Driver3, 0, 0)
		SetEntityInvincible(Driver3, true)
		SetEntityAsMissionEntity(Driver3, true)
	
		SetEntityAsMissionEntity(Train,true,true) -- dunno if this does anything, just throwing it in for good measure
		SetEntityAsMissionEntity(MetroTrain,true,true)

		SetEntityInvincible(Train, true)
		SetEntityInvincible(MetroTrain, true)

		if UseTwoMetros == 1 then
			SetBlockingOfNonTemporaryEvents(Driver2, true)
			SetPedFleeAttributes(Driver2, 0, 0)
			SetEntityInvincible(Driver2, true)
			SetEntityAsMissionEntity(Driver2, true)
			SetEntityAsMissionEntity(MetroTrain2,true,true)
			SetEntityInvincible(MetroTrain2, true)
		end
		
		-- Cleanup from memory
		SetModelAsNoLongerNeeded(TrainDriverHash)
	end

	AddEventHandler("StartTrain", StartTrain)
	EverythingisK = true -- Added this because the Event isn't fully registered when the Event PlayerSpawned trigger.
end)


--==============================================
-- Simple yet effective function to check if
-- player is female or male (sine we only use
-- mp_f_freemode_01 and mp_m_freemode_01 on our
-- server) We need(ed) this function because for
-- some weird reason IsPedMale had some issues
-- with some scripts.
--==============================================

-- Added for OneSync

Citizen.CreateThread(function() -- Suggest by Daniel_Martin, making train work like GTA:O
  SwitchTrainTrack(0, true)
  SwitchTrainTrack(3, true)
  N_0x21973bbf8d17edfa(0, 120000)
  SetRandomTrains(1)
end)

local firstspawn = 0 -- By default, Its the first spawn of the player. So, I don't recommend to restart the script with already player in the server.

AddEventHandler('playerSpawned', function()
	while EverythingisK == false do Citizen.Wait(0) end -- The Event "StartTrain" is fully registered. We can continue now.
	if firstspawn == 0 then -- First spawn of the player ? Check if they are already trains
		TriggerServerEvent('XNL-Trains:PlayerSpawned')
		firstspawn = 1 -- Just for making not trigger the event if he respawn after die.
	end
end)
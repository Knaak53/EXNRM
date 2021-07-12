# EXNRM
Extended No-Relational Mode is a framework with no-relational database usage for RP in FiveM, this include a lot of scripts and a abstract layer to use database easier, documentation and the framework itself still in development.

Some of the work is based on ESX and ExM, some of this credits go for the contributors of https://github.com/extendedmode/extendedmode and https://github.com/esx-framework


Temporal requiriment for testing:

1- CouchDB > v3.0

2 - Create a Database in couchDB called "essentialmode", for that you can access CouchDB with the link http://localhost:5984/_utils/ if you used the default binaries for installation

3 - write in your cfg:

set es_couchdb_url "127.0.0.1"
set es_couchdb_port 5984
set es_couchdb_password "username:password" - Which you choose when installing couchDB
set es_defaultDatabase 2.

3 - Run the server , wait for load and stop it 2-3 times, the server will be autoinstalled with the DB.

4 - this are the resource list working right now and you should start up, this bundle/template is still in development, you are advised:


``` 
# [basic]

	#ensure mapmanager
	ensure chat
	ensure sessionmanager
	ensure spawnmanager
	ensure fivem
	ensure hardcap
	#ensure playernames
	ensure rconlog
	#ensure example-loadscreen
	ensure bob74_ipl
	ensure mumble-voip

# [esx]
	
	ensure cron
	#ensure es_extended
	ensure extendedmode
	#ensure esx_kashacters
	ensure esx_status
	ensure esx_datastore
	ensure esx_voice
	ensure esx_menu_default
	ensure esx_menu_list
	ensure esx_menu_dialog
	
	# [identity]

	ensure esx_identity
	ensure esx_license
	ensure jsfour-idcard

	# [society]

		ensure esx_society
		ensure esx_billing

	# [basic-needs]
        
        ensure esx_basicneeds
		ensure esx_shops
		ensure esx_vending
		ensure esx_gym
		ensure gamz-skillsystem
		ensure stressStatus

	# [account]

		ensure esx_addonaccount

	# [skins]

		#ensure skinchanger
		#ensure esx_skin	
		ensure cui_character
		ensure esx_np_skinshop_v2
		#ensure esx_newaccessories
		#ensure esx_barbershop
		ensure esx_tattooshop
		ensure dpclothing
		
	# [vehicleshops]

        ensure esx_dmvschool
		ensure esx_vehicleshop
		ensure SeatbeltIndicator
		ensure fivem-speedometer
		ensure LegacyFuel
		ensure RealisticVehicleFailure
		ensure carremote
		#ensure carcontrol

	# [inventory]

		ensure esx_trunk
		ensure esx_addoninventory
		ensure esx_inventoryhud
		ensure esx_generic_inv_ui

	# [garage]

		#ensure knatus_parking_ft_avi
		ensure knatus_VehicleInsurance

	# [gcphone]
		
		ensure gcphone
		ensure esx_addons_gcphone
		
	# [weapons]
	
	    ensure esx_weaponshop

	# [jobs]
		
		ensure esx_duty
		ensure esx_service
		ensure esx_joblisting
		
		# [freeForAll]

			ensure esx_garbage
			ensure esx_deliveries
			ensure esx_busdriver
			ensure esx_cityworks
			ensure esx_woodcutter
			ensure esx_minerjob
			ensure esx_postaljob

		# [whitelisted]

			ensure esx_policejob
			ensure AS911
			ensure esx_ambulancejob
			ensure mx_bodydamages
			ensure stretcher
			ensure esx_taxijob

			# [mechanic]

				ensure esx_mechanicjob
				ensure esx_lscustom

		# [extraJobs]

			ensure esx_chatarra
			ensure esx_trash
		
	# [admintools]

	    	ensure esx_marker
	    	ensure qalle_coords	
	    	ensure esx_tpmenu

	# [economy]

	    	ensure new_banking

	# [hud]

		ensure esx_ladderhud

	# [generic]

		ensure esx-taskbar
		ensure esx-vehicle
		ensure esx_doorlock
		ensure No-NPC
		ensure esx_custom_messages
		ensure esx_teleports
		ensure contextmenu
		ensure menuDependencies
		ensure hashtoname
		ensure esx_people_interactions
		ensure vSync
		ensure esx_scoreboard
		ensure crnt_avoid_bunny
		ensure esx_sit
		ensure knatus_art_of_guitar
		ensure xsound
		ensure dpemotes
		#ensure generic_shop_creator

	# [transports]

		ensure XNL-FiveM-Trains-U3
		ensure esx_bike_rental

	# [housing]

		ensure loaf_housing

	# [ilegal]

		ensure esx_daily_quest
		ensure esx_shop_codes
        ensure esx_weed
        ensure esx_coke
        ensure esx_sell_drugs

# [maps]

	ensure HousingShells
	ensure garageShells
	ensure shellsv2
	#ensure k4mb1warehouseshells
	ensure nw_bahamaMama
    #ensure mina
    #ensure dealership
	#ensure taxinew
	ensure propstreamer
	ensure phone

	
	#[TESTS & DEV ONLY]
		ensure TESTS
		ensure clipsaverv
    
    ```

Config = {}

Config.genericAdminActions = {
	export = function(entity, action)
				TriggerServerEvent(
			        "exportEntity",
			        entity.target,
			        entity.type,
			        entity.hash,
			        entity.modelName,
			        entity.coords,
			        entity.heading,
			        entity.rotation)
			end,
	examine = function(entity, action)
				examine()
			end
}


Config.subMenuInfo = {
	dardinero = {
		label = "💲 Dar dinero ",
		color = "green"
	},
	police = {
		label = "Policia",
		color = "blue"
	},
	police_objects = {
		label = "Colocar Objetos",
		color = "blue"
	},
	mechanic = {
		label = "🧑‍🔧-Mecanico",
		color = "orange"
	},
	ambulance = {
		label = "UMC",
		color = "green"
	},
	taxi = {
		label = "Taxi",
		color = "yellow"
	},
	cardealer = {
		label = "Concesionario",
		color = "brown"
	},
	garbage = {
		label = "Basurero",
		color = "lightgrey"
	},
	cityworks = {
		label = "Mantenimiento",
		color = "lightgrey"
	},
	interaction = {
		label = "Interactuar",
		color = "purple"
	},
	utilities = {
		label = "Utilidades",
		color = "lightBlue"
	},
	vehicle_actions = {
		label = "Acciones",
		color = "lightBlue"
	},
	vehicle_doors = {
		label = "Puertas",
		color = "lightGreen"
	},
	illegal = {
		label = "Acciones Ilegales",
		color = "red"
	}
}


----------------------------------------------------------------------------------------------------

                                     --VEHICLE ACTIONS--

----------------------------------------------------------------------------------------------------


Config.genericVehicleActions = {
	turnEngine = {
		--subMenu = "vehicle_doors",
		action = function(entity, action)
			--print("action:" ..action)
			--print("entity:" ..entity)
			TriggerEvent('engine') --pendiente mejora para que use la entidad enviada
		end,
		label = "🔑-Encender/Apagar motor",
		actionDistance = 5.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	vehicleKeys = {
		--subMenu = "vehicle_doors",
		action = function(entity, action)
			--print("action:" ..action)
			--print("entity:" ..entity)
			TriggerEvent('keys:togglelocks') --pendiente mejora para que use la entidad enviada
		end,
		label = "🔑-Usar Llave",
		actionDistance = 5.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	doors = {
		subMenu = "vehicle_doors",
		action = function(entity, action)
			--print("action:" ..action)
			--print("entity:" ..entity)
			TriggerEvent('vehicleactions:general', action, entity.target)
		end,
		label = "Puerta",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	hood = {
		subMenu = "vehicle_doors",
		action = function(entity, action)
			--print("action:" ..action)
			--print("entity:" ..entity)
			TriggerEvent('vehicleactions:general', action, entity.target)
		end,
		label = "Capó",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	refuel = {
		subMenu = "vehicle_actions",
		action = function(entity, action)
			TriggerEvent('refuel_ui')
		end,
		label = "Repostar",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	trunk = {
		subMenu = "vehicle_actions",
		action = function(entity, action)
			TriggerEvent("vehiclecontrol:AsignEntity", entity.target) -- TODO rehacer vehicle control, Añadir API mas facil
			 -- TODO rehacer vehicle control, Añadir API mas facil
			TriggerEvent('esx_trunk:open_trunk_ui', entity.target)
		end,
		label = "Maletero",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},

	-------------- MECANICOS ----------------
	reparar = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:onFixkit', entity.target)
		end,
		label = "🔧-Reparar Motor",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	repararCaro = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:onCarokit', entity.target)
		end,
		label = "⛍-Reparar Carrocería",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	llavemaestra = {
		subMenu = "mechanic",
		action = function(entity, action)
			local ent = entity.target
			
			ESX.TriggerServerCallback('esx_service:isInService', function(InService)
				if InService then
					--print("vehiculo:"..ent)
					--print("vehiculo:"..GetVehicleNumberPlateText(ent))
					ESX.ShowNotification('Ahora puedes controlar este vehiculo')
					TriggerServerEvent('garage:addKeys', GetVehicleNumberPlateText(ent))
				end
			end, "mechanic")
		end,
		label = "🗝️-Usar llave maestra",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = vector3(-173.75233459473,-1303.9404296875,31.289447784424),
		entityMaxDistanceRadius = 50
	},
	limpiar = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:clean_ui', entity.target)
		end,
		label = "🧼-Limpiar Vehiculo",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	grua = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:tow_ui', entity.target)
		end,
		label = "🚨-Usar Grua",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	tunear = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('ls_custom:tunning', entity.target)
		end,
		label = "🏎️-Tunear",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	presupuesto = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('ls_custom:tunningFake', entity.target)
		end,
		label = "📝-Hacer presupuesto",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	--hijack = {
	--	subMenu = "mechanic",
	--	action = function(entity, action)
	--		TriggerEvent('esx_policejob:vehicle_lock_ui', entity.target)
	--	end,
	--	label = "Forzar",
	--	actionDistance = 3.0,
	--	restrictedJobs = nil,
	--	whiteListedJobs = {"mechanic"},
	--	entityCoords = nil
	--},
	--impound = {
	--	subMenu = "mechanic",
	--	action = function(entity, action)
	--		TriggerEvent('esx_policejob:vehicle_imp_ui', entity.target)
	--	end,
	--	label = "Incautar",
	--	actionDistance = 3.0,
	--	restrictedJobs = nil,
	--	whiteListedJobs = {"mechanic"},
	--	entityCoords = nil
	--},

	---------- POLICIA --------
	sacardelcoche = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:out_vehicle_ui', entity.target)
		end,
		label = "Sacar del Vehiculo",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	informacion = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:vehicle_info_ui', entity.target)
		end,
		label = "Info. Vehiculo",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	zepo = {
		subMenu = "police",
		action = function(entity, action)
			TriggerServerEvent('esx_policejob:putzepo', GetVehicleNumberPlateText(entity.target))
		end,
		label = "Poner/Quitar zepo",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	------------ CARDEALERS -----------
	retirarvehiculo = {
		subMenu = "cardealer",
		action = function(entity, action)
			local shop = getCurrentShop()
		    if shop then
		        TriggerEvent('esx_vehicleshop:depop_vehicle', shop, entity.target)
		    else
		        ESX.ShowNotification('Debes estar en el ~g~CONCESIONARIO~w~ para hacer eso!')
		    end  
		end,
		label = "Retirar Vehiculo",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer"},
		entityCoords = nil
	},


	--------------- BASUREROS ---------------
	depositarbasura = {
		subMenu = "garbage",
		action = function(entity, action)
			TriggerEvent('esx_garbage:depositTrash', entity.target, entity.coords)
		end,
		label = "Depositar Basura",
		actionDistance = 5.0,
		restrictedJobs = nil,
		whiteListedJobs = {"garbage"},
		entityCoords = nil
	},
	postaljob = {
		action = function(entity, action)
			TriggerEvent("esx_gopostal:takePackage", entity.action)
		end,
		models = {
			"boxville2"
		},
		label = "Coger paquete",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"gopostal"},
		entityCoords = nil
	},
}

Config.possibleVehicleActions = {
	wow = {
		action = function(entity, action)
			--TriggerEvent("menuDependencies:"..action, entity)
			print("Que guapo")
		end,
		models = {
			"buffalo"
		},
		label = "Hacer foto",
		actionDistance = 1.75,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	strechtToAmbulance = {
		action = function(entity, action)
			TriggerEvent("ARPF-EMS:togglestrincar", entity.target)
		end,
		models = {
			"ambulance"
		},
		label = "💔-Meter camilla",
		actionDistance = 5.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},
	taxiJobStart = {
		subMenu = "taxi",
		action = function(entity, action)
			TriggerEvent('esx_taxijob:start_ui', entity.target)
		end,
		models = {
			"taxi"
		},
		label = "Empezar/Treminar Trabajo",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = nil
	},
	openTaximeter = {
		subMenu = "taxi",
		action = function(entity, action)
			TriggerEvent('esx_taxijob:open_taximeter_ui', entity.target)
		end,
		models = {
			"taxi"
		},
		label = "Mostrar Taximetro",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = nil
	},
	startTaximeter = {
		subMenu = "taxi",
		action = function(entity, action)
			TriggerEvent("esx_taxijob:startGroupTimer", entity.target)
		end,
		models = {
			"taxi"
		},
		label = "Iniciar Taximetro",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = nil
	},
	stopTaximeter = {
		subMenu = "taxi",
		action = function(entity, action)
			TriggerEvent("esx_taxijob:stopTaximeter", entity.target)
		end,
		models = {
			"taxi"
		},
		label = "Parar Taximetro",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = nil
	},
	hideTaximeter = {
		subMenu = "taxi",
		action = function(entity, action)
			TriggerEvent("esx_taxijob:closeTaximeter", entity.target)
		end,
		models = {
			"taxi"
		},
		label = "Ocultar Taximetro",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = nil
	},
	woodCutterForkliftReturn = {
		action = function(entity, action)
			TriggerServerEvent('esx_woodcutter:returnForklift', NetworkGetNetworkIdFromEntity(entity.target))
		end,
		models = {
			"forklift"
		},
		label = "Devolver Toro",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = vector3(592.71484375,6457.5737304688,30.835870742798),
		entityMaxDistanceRadius = 30.0
	},
	woodCutterTrailerReturn = {
		action = function(entity, action)
			TriggerServerEvent('esx_woodcutter:returnTrailer', NetworkGetNetworkIdFromEntity(entity.target))
		end,
		models = {
			"hauler"
		},
		label = "Devolver Trailer",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = vector3(592.71484375,6457.5737304688,30.835870742798),
		entityMaxDistanceRadius = 30.0
	},
	woodCutterPlatformReturn = {
		action = function(entity, action)
			TriggerServerEvent('esx_woodcutter:returnPlatform', NetworkGetNetworkIdFromEntity(entity.target))
		end,
		models = {
			"TRFLAT"
		},
		label = "Devolver Plataforma",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = vector3(592.71484375,6457.5737304688,30.835870742798),
		entityMaxDistanceRadius = 30.0
	},
}




--------------------------------------------------------------------------------------

								--OBJECTS ACTIONS--

--------------------------------------------------------------------------------------


Config.darDineroNPCsList = 
{
    1224306523,
    516505552,
    390939205,
}

Config.trashHashes = {
	218085040,
    -58485588,
    856312526,
    1387151245,
    -1211968443,
    -206690185,
    -1426008804,
    1143474856,
    1437508529,
    1138027619,
    -1096777189,
    -468629664,
    -939897404,
    1614656839,
    143291855,
    1329570871,
    -515278816,
    -14708062,
    811169045,
    -2096124444,
    -130812911,
    1748268526,
    -1605769687,
    388197031,
    666561306,
    682791951
}

Config.cityWorkHashes = {
	-2138350253,
	-1620823304,
	-2007495856,
	-2008643115,
	1131941737,
	-1393761711,
	1369811908,
	-686494084,
	1709954128,
	-1625667924,
	1502931467,
	793482617,
	2108567945,
	-1940238623,
	-639994124,
	1502931467,
	3345732523,
	2029303486,
	1800641404,
	4293673471,
	840050250,
	609684180,
	1452666705,
	1191039009,
	2034218148,
	2034218148,
	1803721002,
	2377637268,
	4138610559,
	3899069169,
	432141734,
	193190186,
	--semaforos
	1043035044,
	862871082,
	3639322914,
	3564281680,
	656557234,
	865627822,
	589548997,
	3349501382,
	3369785397,
	--cabina telefono
	1158960338,
	--farolas
	-1063472968,
	729253480,
	1847069612,
	1393636838,
	-753093121,
	431612653,
	173177608,
	-1572767351,
	-105439435,
	-655644382,
	1923262137,
	979185940,
	-667908451,
	-655644382
}

Config.genericObjectActions = {
	coger = {
		action = function(entity, action)
			TriggerEvent("menu:takeProp", "both", entity.target)
		end,
		label = "🤏-Coger",
		actionDistance = 2.5,
		restrictedJobs = nil
	},
}

Config.possibleActionsObjects = {
	sitIn = {
		hashes = 
		{
		-1278649385,
        'prop_bench_01a',
        'prop_bench_01b',
        'prop_bench_01c',
        'prop_bench_02',
        'prop_bench_03',
        'prop_bench_04',
        'prop_bench_05',
        'prop_bench_06',
        'prop_bench_05',
        'prop_bench_08',
        'prop_bench_09',
        'prop_bench_10',
        'prop_bench_11',
        'prop_fib_3b_bench',
        'prop_ld_bench01',
        'prop_wait_bench_01',
        'hei_prop_heist_off_chair',
        'hei_prop_hei_skid_chair',
        'prop_chair_01a',
        'prop_chair_01b',
        'prop_chair_02',
        'prop_chair_03',
        'prop_chair_04a',
        'prop_chair_04b',
        'prop_chair_05',
        'prop_chair_06',
        'prop_chair_05',
        'prop_chair_08',
        'prop_chair_09',
        'prop_chair_10',
        'v_club_stagechair',
        'prop_chateau_chair_01',
        'prop_clown_chair',
        'prop_cs_office_chair',
        'prop_direct_chair_01',
        'prop_direct_chair_02',
        'prop_gc_chair02',
        'prop_off_chair_01',
        'prop_off_chair_03',
        'prop_off_chair_04',
        'prop_off_chair_04b',
        'prop_off_chair_04_s',
        'prop_off_chair_05',
        'prop_old_deck_chair',
        'prop_old_wood_chair',
        'prop_rock_chair_01',
        'prop_skid_chair_01',
        'prop_skid_chair_02',
        'prop_skid_chair_03',
        'prop_sol_chair',
        'prop_wheelchair_01',
        'prop_wheelchair_01_s',
        'p_armchair_01_s',
        'p_clb_officechair_s',
        'p_dinechair_01_s',
        'p_ilev_p_easychair_s',
        'p_soloffchair_s',
        'p_yacht_chair_01_s',
        'v_club_officechair',
        'v_corp_bk_chair3',
        'v_corp_cd_chair',
        'v_corp_offchair',
        'v_ilev_chair02_ped',
        'v_ilev_hd_chair',
        'v_ilev_p_easychair',
        'v_ret_gc_chair03',
        'prop_ld_farm_chair01',
        'prop_table_04_chr',
        'prop_table_05_chr',
        'prop_table_06_chr',
        'v_ilev_leath_chr',
        'prop_table_01_chr_a',
        'prop_table_01_chr_b',
        'prop_table_02_chr',
        'prop_table_03b_chr',
        'prop_table_03_chr',
        'prop_torture_ch_01',
        'v_ilev_fh_dineeamesa',
        'v_ilev_fh_kitchenstool',
        'v_ilev_tort_stool',
        'v_ilev_fh_kitchenstool',
        'v_ilev_fh_kitchenstool',
        'v_ilev_fh_kitchenstool',
        'v_ilev_fh_kitchenstool',
        'hei_prop_yah_seat_01',
        'hei_prop_yah_seat_02',
        'hei_prop_yah_seat_03',
        'prop_waiting_seat_01',
        'prop_yacht_seat_01',
        'prop_yacht_seat_02',
        'prop_yacht_seat_03',
        'prop_hobo_seat_01',
        'prop_rub_couch01',
        'miss_rub_couch_01',
        'prop_ld_farm_couch01',
        'prop_ld_farm_couch02',
        'prop_rub_couch02',
        'prop_rub_couch03',
        'prop_rub_couch04',
        'p_lev_sofa_s',
        'p_res_sofa_l_s',
        'p_v_med_p_sofa_s',
        'p_yacht_sofa_01_s',
        'v_ilev_m_sofa',
        'v_res_tre_sofa_s',
        'v_tre_sofa_mess_a_s',
        'v_tre_sofa_mess_b_s',
        'v_tre_sofa_mess_c_s',
        'prop_roller_car_01',
        'prop_roller_car_02',
		},
		action = function(entity, action)
			TriggerEvent("esx_sit:"..action, entity.target)
		end,
		label = "Sentarse",
		actionDistance = 1.75,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	Electro = {
		action = function(entity, action)
			TriggerEvent("menuDependencies:"..action, entity)
		end,
		hashes = {
			-2138350253,
			-1620823304,
			-2007495856,
			-2008643115,
			-686494084,
			1923262137
		},
		label = "⚡-Manipular",
		actionDistance = 1.75,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	LeanOn = {
		action = function(entity, action)
			SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 180)
			ExecuteCommand("e lean")
		end,
		hashes = {
			1821241621,
			1191039009,
			1363150739,
			1211559620,
			865627822,
			-1063472968,
			3345732523,
			2029303486,
			1800641404,
			4293673471,
			840050250,
			609684180,
			1452666705,
			1191039009,
			2034218148,
			2034218148,
			729253480,
			1847069612,
			1393636838,
			-753093121,
			431612653,
			173177608,
			-1572767351
		},
		label = "Apoyarse",
		actionDistance = 1.75,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	burnIt = {
		action = function(entity, action)
			TriggerEvent("menuDependencies:"..action, entity.target)
		end,
		hashes = {
			-1344435013,
			929870599,
			-2138350253,
			-1620823304,
			-2007495856,
			-2008643115,
			-1738103333,
			-686494084
		},
		label = "🔥-Quemar",
		actionDistance = 1.75,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	--cajeros de pasta
	usar_cajero = {
		action = function(entity, action)
			TriggerEvent('bank:show')
		end,
		hashes = {
			506770882, 
			-1364697528, 
			-870868698, 
			-1126237515
		},
		label = "usar cajero",
		actionDistance = 1.75,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},

	--basuras
	buscar_basuras = {
			action = function(entity, action)
				TriggerEvent('esx_trash:searchTrash', entity.target, entity.hash)
			end,
			hashes = Config.trashHashes,
			label = "Buscar",
			actionDistance = 5.1,
			restrictedJobs = {"police", "offpolice", "ambulance", "taxi", "mechanic", "cardealer"},
			whiteListedJobs = nil,
			entityCoords = nil
	},

	--basuras
	recogerbasura = {
			subMenu = "garbage",
			action = function(entity, action)
				TriggerEvent('esx_garbage:searchContainer', entity.target, entity.coords)
			end,
			hashes = Config.trashHashes,
			label = "Recoger Basura",
			actionDistance = 5.1,
			restrictedJobs = nil,
			whiteListedJobs = {"garbage"},
			entityCoords = nil
	},

	--basuras
	limpiarcontenedor = {
			subMenu = "garbage",
			action = function(entity, action)
				TriggerEvent('esx_garbage:cleanTrash', entity.target)
			end,
			hashes = Config.trashHashes,
			label = "Limpiar Contenedor",
			actionDistance = 5.1,
			restrictedJobs = nil,
			whiteListedJobs = {"garbage"},
			entityCoords = nil
	},
	--cityWorks
	examinarWorks = {
			subMenu = "cityworks",
			action = function(entity, action)
				TriggerEvent('esx_cityworks:examineDevice', entity.target)
			end,
			hashes = Config.cityWorkHashes,
			label = "Examinar",
			actionDistance = 2.75,
			restrictedJobs = nil,
			whiteListedJobs = {"works"},
			entityCoords = nil
	},
	repararWorks = {
			subMenu = "cityworks",
			action = function(entity, action)
				TriggerEvent('esx_cityworks:repareDevice', entity.target)
			end,
			hashes = Config.cityWorkHashes,
			label = "Reparar",
			actionDistance = 2.75,
			restrictedJobs = nil,
			whiteListedJobs = {"works"},
			entityCoords = nil
	},
	--badulakes
	take_drinks = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'drinks', entity.target)
		end,
		hashes = {
			-220235377
		},
		label = "coger bebidas",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	take_readymeal = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'readymeal', entity.target)
		end,
		hashes = {
			-54719154,
			1437777724
		},
		label = "coger comida",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	take_snacks = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'snacks', entity.target)
		end,
		hashes = {
		-532065181
		},
		label = "coger snacks",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	take_alcohol = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'alcohol', entity.target)
		end,
		hashes = {
			643522702,
			1238061242,
			-1914723336,
			-53650680,
			1793329478,
			511490507,
			-2065152269,
			1550641188,
			-1699929937,
			-942878691
		},
		label = "coger botellas",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	take_donuts = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'donuts', entity.target)
		end,
		hashes = {
			1421582485
		},
		label = "coger donuts",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	take_fruit = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'fruit', entity.target)
		end,
		hashes = {
			-802238381
		},
		label = "coger fruta",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	take_smoothie = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'smoothie', entity.target)
		end,
		hashes = {
			-1369928609
		},
		label = "coger smoothies",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	forzarCajaRegistradora = {
		action = function(entity, action)
			TriggerEvent('esx_shops:cashRegister', entity.target, entity.coords)
		end,
		hashes = {
			303280717
		},
		label = "forzar",
		actionDistance = 1.5,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	safeKeyboards = {
		action = function(entity, action)
			TriggerEvent('esx_shops:openComputer', entity.target)
		end,
		hashes = {
			-69396461,
			-1375589668,
			-954257764
		},
		label = "hackear",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	usegGasPumps = {
		action = function(entity, action)
			TriggerEvent('refuel_ui')
		end,
		hashes = {
			1933174915,
			1339433404,
			-469694731,
			"prop_gas_pump_1d",
			462817101,
			1694452750,
			-462817101
		},
		label = "comprar gasolina",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	dmvTeoricExam = {
		action = function(entity, action)
			TriggerEvent('esx_dmvschool:test_ui')
		end,
		hashes = {
			794001094,
 			-1339628889
		},
		label = "hacer examen",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	mechanicsMain = {
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:actions_ui', 'mechanic_menu')
		end,
		hashes = {
			-2051651622
		},
		label = "oficina",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = vector3(-206.85, -1341.49, 34.89),
		entityMaxDistanceRadius = 2.0
	},
	takeLogWoodCutter = {
		action = function(entity, action)
			TriggerEvent("esx_woodcutter:takeLog", entity.target)
		end,
		hashes = {
			1366334172
		},
		label = "Recoger Tronco",
		actionDistance = 2.2,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = vector3(735.808, 6457.398, 31.63),
		entityMaxDistanceRadius = 115.0
	},
	depositLogCutter = {
		action = function(entity, action)
			TriggerEvent("esx_woodcutter:depositLog", entity.target)
		end,
		hashes = {
			-1381557071
		},
		label = "Dejar Tronco",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = vector3(601.46, 6456.81, 29.397),
		entityMaxDistanceRadius = 30.0
	},
	--mechanicsHarvest = {
	--	action = function(entity, action)
	--		TriggerEvent('esx_mechanicjob:actions_ui', 'harvest_menu')
	--	end,
	--	hashes = {
	--		-573669520
	--	},
	--	label = "comprar materiales",
	--	actionDistance = 2.0,
	--	restrictedJobs = nil,
	--	whiteListedJobs = {"mechanic"},
	--	entityCoords = vector3(-196.98, -1320.4, 31.09),
	--	entityMaxDistanceRadius = 2.0
	--},
	mechanicsCraft = {
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:actions_ui', 'craft_menu')
		end,
		hashes = {
			-1674314660
		},
		label = "fabricar kits",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = vector3(-227.83, -1327.87, 30.89),
		entityMaxDistanceRadius = 2.0
	},
	mechanicsStorage = {
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:store_ui')
		end,
		hashes = {
			-475360078,
			-1438964996
		},
		label = "abrir almacen",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = vector3(-213.94, -1341.32, 35.21),
		entityMaxDistanceRadius = 3.0
	},
	taxiBossMenu = {
		action = function(entity, action)
			TriggerEvent('esx_taxijob:open_boss_menu_ui')
		end,
		hashes = {
			1655905935
		},
		label = "usar portatil",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = vector3(904.27, -162.39, 78.01),
		entityMaxDistanceRadius = 3.0
	},
	taxiCloakroom = {
		action = function(entity, action)
			TriggerEvent('esx_taxijob:cloakroom_ui')
		end,
		hashes = {
			187978556
		},
		label = "cambiarse",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = vector3(896.85, -173.16, 74.68),
		entityMaxDistanceRadius = 3.0
	},
	taxiStorage = {
		action = function(entity, action)
			TriggerEvent('esx_taxijob:open_storage_ui')
		end,
		hashes = {
			377646791
		},
		label = "abrir almacen",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = vector3(891.28, -150.31, 76.94),
		entityMaxDistanceRadius = 3.0
	},
	-------------AMBULANCE-----------------pushstr
	pushstr = {
		action = function(entity, action)
			print("network ID: "..NetworkGetNetworkIdFromEntity(entity.target))
			--ExecuteCommand("pushstr "..NetworkGetNetworkIdFromEntity(entity.target))
			TriggerServerEvent("pushstr", NetworkGetNetworkIdFromEntity(entity.target))
			--TriggerEvent('esx_ambulancejob:pharmacy_ui', 'craft_menu')
		end,
		hashes = {
			-1194386596,
			"prop_ld_stret_test"
		},
		label = "💔-Empujar",
		actionDistance = 5.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil,
		entityMaxDistanceRadius = 50.0
	},
	camillaOut = {
		action = function(entity, action)
			local ped = GetEntityAttachedTo(
				entity.target --[[ Entity ]]
			)
			print("attached?.."..ped)
			--GetPlayerServerId(GetPlayerFromPed(entity.target))
			if Entity(entity.target).state.playerAttached then
				print("wweeee")
				TriggerServerEvent("externalunsit", NetworkGetNetworkIdFromEntity(entity.target), Entity(entity.target).state.playerAttached)
			end
			--ExecuteCommand("getintostr "..GetPlayerServerId(GetPlayerFromPed(entity.target)))
			--TriggerEvent('menuDependencies:darDinero',true, entity.target,  500)
		end,
		hashes = {
			-1194386596,
			"prop_ld_stret_test"
		},
		label = "🛏️-Sacar de Camilla",
		actionDistance = 2.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	camillaMove= {
		action = function(entity, action)
			TriggerServerEvent("moveToBed", NetworkGetNetworkIdFromEntity(entity.target), Entity(entity.target).state.playerAttached)
			--ExecuteCommand("getintostr "..GetPlayerServerId(GetPlayerFromPed(entity.target)))
			--TriggerEvent('menuDependencies:darDinero',true, entity.target,  500)
		end,
		hashes = {
			-1194386596,
			"prop_ld_stret_test"
		},
		label = "🛏️-Mover a cama",
		actionDistance = 2.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	use_pharmacies = {
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:pharmacy_ui', 'craft_menu')
		end,
		hashes = {
			886033073,
		},
		label = "🧰-coger material",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = vector3(319.87, -578.28, 43.28),
		entityMaxDistanceRadius = 50.0
	},
	use_stret = {
		action = function(entity, action)
			--TriggerEvent('esx_ambulancejob:pharmacy_ui', 'craft_menu')
			exports.stretcher:spawnstr()
		end,
		hashes = {
			886033073
		},
		label = "🛏️-Coger una camilla",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = vector3(319.87, -578.28, 43.28),
		entityMaxDistanceRadius = 50.0
	},
	delete_stret = {
		action = function(entity, action)
			--TriggerEvent('esx_ambulancejob:pharmacy_ui', 'craft_menu')
			exports.stretcher:delStr()
		end,
		hashes = {
			886033073
		},
		label = "🛏️❌-Dejar una camilla",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = vector3(319.87, -578.28, 43.28),
		entityMaxDistanceRadius = 50.0
	},
	emsCloackroom = {
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:cloakroom_ui')
		end,
		hashes = {
			"p_cs_locker_01",
			"p_cs_locker_door_01b"
		},
		label = "🥼-usar vestuario",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = vector3(325.29339599609,-591.77673339844,43.261322021484),
		entityMaxDistanceRadius = 2.0
	},
	emsBoss = {
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:boss_ui')
		end,
		hashes = {
			"prop_cd_folder_pile2"
		},
		label = "🏥-Gestionar Hospital",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = vector3(339.12014770508,-592.60723876953,48.348449707031),
		entityMaxDistanceRadius = 10.0
	},
	emsStorage = {
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:storage_ui')
		end,
		hashes = {
			-502202673,
			-738161850,
			11680152,
			1871266393,
			-78931017,
			-1890319650
		},
		label = "🧰-usar almacen",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = vector3(324.78375244141,-584.67388916016,43.261352539062),
		entityMaxDistanceRadius = 20.0
	},
	policeCloackroom = {
		action = function(entity, action)
			TriggerEvent('esx_policejob:open_cloackroom_ui')
		end,
		hashes = {
			899635523
		},
		label = "usar vestuario",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = vector3(473.06, -987.81, 25.73),
		entityMaxDistanceRadius = 15.0
	},
	policeBossComputer = {
		action = function(entity, action)
			TriggerEvent('esx_policejob:open_bossacctions_ui')
		end,
		hashes = {
			-1524180747
		},
		label = "usar ordenador",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = vector3(471.33, -1005.43, 30.69),
		entityMaxDistanceRadius = 2.0
	},
	cardealerStorageMid = {
		action = function(entity, action)
			TriggerEvent('esx_vehicleshop:inventory_ui')
		end,
		hashes = {
			-573669520
		},
		label = "usar almacen",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer"},
		entityCoords = vector3(-40.6, -1088.48, 26.42),
		entityMaxDistanceRadius = 2.0
	},
	cardealerStorageHigh = {
		action = function(entity, action)
			TriggerEvent('esx_vehicleshop:inventory_ui')
		end,
		hashes = {
			-1326111298
		},
		label = "abrir almacen",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer"},
		entityCoords = vector3(-156.74, -589.19, 167.0),
		entityMaxDistanceRadius = 2.0
	},
	cardealerBossComputer = {
		action = function(entity, action)
			TriggerEvent('esx_vehicleshop:openBossMenu')
		end,
		hashes = {
			1333557690
		},
		label = "usar ordenador",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer"},
		entityCoords = vector3(-32.51, -1115.5, 26.42),
		entityMaxDistanceRadius = 2.0
	},
	policeDutyComputers = {
		action = function(entity, action)
			TriggerEvent('esx_duty:onoff_ui', entity.coords)
		end,
		hashes = {
			-1524180747
		},
		label = "usar ordenador",
		actionDistance = 10.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police", "offpolice"},
		entityCoords = vector3(443.51, -983.52, 30.69),
		entityMaxDistanceRadius = 2.0
	},
	ambulanceDutyClipBoard = {
		action = function(entity, action)
			TriggerEvent('esx_duty:onoff_ui', entity.coords)
		end,
		hashes = {
			-1130190827
		},
		label = "usar libreta",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance", "offambulance"},
		entityCoords = vector3(315.28189086914,-585.75170898438,43.261322021484),
		entityMaxDistanceRadius = 4.0
	},
	mechanicsDutyDoor = {
		action = function(entity, action)
			TriggerEvent('esx_duty:onoff_ui', entity.coords)
		end,
		hashes = {
			-2051651622
		},
		label = "usar oficina",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic", "offmechanic"},
		entityCoords = vector3(-206.71, -1330.95, 34.95),
		entityMaxDistanceRadius = 2.0
	},
	cardealerDutyComputer = {
		action = function(entity, action)
			TriggerEvent('esx_duty:onoff_ui', entity.coords)
		end,
		hashes = {
			1333557690
		},
		label = "usar ordenador",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer", "offcardealer"},
		entityCoords = vector3(-30.39, -1106.76, 26.42),
		entityMaxDistanceRadius = 2.0
	},
	sprunk_machine = {
		action = function(entity, action)
			TriggerEvent('esx_vending:useMachine', 'drinks', 'sprunk')
		end,
		hashes = {
			1114264700
		},
		label = "comprar bebidas",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	cola_machine = {
		action = function(entity, action)
			TriggerEvent('esx_vending:useMachine', 'drinks', 'cola')
		end,
		hashes = {
			992069095
		},
		label = "comprar bebidas",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	snacksMachine = {
		action = function(entity, action)
			TriggerEvent('esx_vending:useMachine', 'snacks', 'snacks')
		end,
		hashes = {
			-654402915
		},
		label = "comprar snacks",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	coffeeMachine = {
		action = function(entity, action)
			TriggerEvent('esx_vending:useMachine', 'coffee', 'coffee')
		end,
		hashes = {
			690372739
		},
		label = "comprar cafe",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	gumMachine = {
		action = function(entity, action)
			TriggerEvent('esx_vending:useMachine', 'gum')
		end,
		hashes = {
			1243022785,
			462203053,
			785076010
		},
		label = "comprar chicle",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	waterMachine = {
		action = function(entity, action)
			TriggerEvent('esx_vending:useMachine', 'water')
		end,
		hashes = {
			1099892058
		},
		label = "comprar agua",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	freeWaterMachine = {
		action = function(entity, action)
			TriggerEvent('esx_vending:useMachine', 'water_free')
		end,
		hashes = {
			-742198632
		},
		label = "coger vaso",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	use_doors = {
		action = function(entity, action)
			TriggerEvent('esx_doorlock:useDoor', entity.coords)
		end,
		hashes = {
			-165604314,
			1388858739,
			165994623,
			-1988553564,
			-884718443,
			-427498890,
			725274945
		},
		label = "abrir/cerrar",
		actionDistance = 30.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	weedPalletOutdoorTake = {
		action = function(entity, action)
			TriggerEvent('esx_weed:takeWeed', entity.coords, myJob)
		end,
		hashes = {
			243282660
		},
		label = "coger fardo",
		actionDistance = 1.6,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	indoorWeedCut = {
		action = function(entity, action)
			TriggerEvent('esx_weed:takeGreenWeedFromLab', entity.target, myJob)
		end,
		hashes = {
			469652573,
			716763602
		},
		label = "cortar planta",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	weedProcessTable = {
		action = function(entity, action)
			TriggerEvent('esx_weed:useWorkBench', myJob)
		end,
		hashes = {
			518749770
		},
		label = "procesar maria",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	palletWeedBlocks = {
		action = function(entity, action)
			TriggerEvent('esx_weed:takeBlockFromPallet', entity.target, myJob)
		end,
		hashes = {
			-1688127
		},
		label = "coger fardo",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = vector3(1042.59, -3199.66, -37.85),
		entityMaxDistanceRadius = 2.0
	},
	cokeBricks = {
			action = function(entity, action)
				TriggerEvent('esx_coke:takeBricksFromBoat', entity.target, myJob)
			end,
			hashes = {
				-398009968
			},
			label = "manipular",
			actionDistance = 2.5,
			restrictedJobs = nil,
			whiteListedJobs = nil,
			entityCoords = nil
	},
	gopostal_letterbox = {
			action = function(entity, action)
				TriggerEvent("esx_gopostal:entrega", entity.target, myJob)
			end,
			hashes = {
				-1414914121
			},
			label = "Entregar correo",
			actionDistance = 2.0,
			restrictedJobs = nil,
			whiteListedJobs = {"gopostal"},
			entityCoords = nil
	},
	use_phonebox = {
			action = function(entity, action)
				TriggerEvent('gcPhone:use_phonebox', entity.target)
			end,
			hashes = {
				'p_phonebox_01b_s', 
				'p_phonebox_02_s', 
				'prop_phonebox_01a', 
				'prop_phonebox_01b', 
				'prop_phonebox_01c', 
				'prop_phonebox_02', 
				'prop_phonebox_03', 
				'prop_phonebox_04', 
				-1058868155
			},
			label = "Usar cabina",
			actionDistance = 2.0,
			restrictedJobs = nil,
			whiteListedJobs = nil,
			entityCoords = nil
	}
}









--------------------------------------------------------------------------------------

								--NPC ACTIONS--

--------------------------------------------------------------------------------------









Config.genericNpcActions = {
	sellDrugs = {
		subMenu = "illegal",
		action = function(entity, action)
			TriggerEvent('esx_sell_drugs:tryToSellDrugs', entity.hash, entity.target, myJob)
		end,
		label = "ofrecer drogas",
		actionDistance = 2.5,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"}
	},
}

Config.possibleActionsNpc = {
	--DAR DINERO
	dar50 = {
		subMenu = "dardinero",
		action = function(entity, action)
			TriggerEvent('menuDependencies:darDinero', false, entity.target, 50)
        end,
        hashes = Config.darDineroNPCsList,
		label = "Dar 50 💲",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	dar100 = {
		subMenu = "dardinero",
		action = function(entity, action)
			TriggerEvent('menuDependencies:darDinero',false, entity.target, 100)
        end,
        hashes = Config.darDineroNPCsList,
		label = "Dar 100 💲",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	dar500 = {
        hashes = Config.darDineroNPCsList,
		subMenu = "dardinero",
		action = function(entity, action)
			TriggerEvent('menuDependencies:darDinero',false, entity.target, 500)
		end,
        label = "Dar 500 💲",
        --hashes = darDineroNPCsList,
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},

	--FIN DAR DINERO--
	usar_tienda = {
		action = function(entity, action)
			TriggerEvent('esx_shops:OpenAction', 'checkout')
		end,
		hashes = {
			416176080
		},
		label = "usar tienda",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	}, 
	industVehicle = {
		action = function(entity, action)
			TriggerEvent('BuyIndustrialVehicles')
		end,
		hashes = {
			-140033735
		},
		label = "Vehiculos industriales",
		actionDistance = 5.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	atracar = {
		subMenu = "illegal",
		action = function(entity, action)
			TriggerEvent('esx_shops:tryStartRobbery')
		end,
		hashes = {
			416176080
		},
		label = "atracar",
		actionDistance = 2.5,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil	
	},
	shopCodesGuys = {
		action = function(entity, action)
			TriggerEvent('esx_shops_codes:openStore')
		end,
		hashes = {
			921328393
		},
		label = "hablar",
		actionDistance = 2.5,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil	
	},
	driveTeacherInteract = {
		action = function(entity, action)
			TriggerEvent("esx_dmvschool:openMenu_ui")
		end,
		hashes = {
			-847807830
		},
		label = "pedir informacion",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	weaponShopGuy = {
		action = function(entity, action)
			TriggerEvent('esx_weaponshop:openMenu_ui')
		end,
		hashes = {
			-518348876
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	clothesGirl = {
		action = function(entity, action)
			TriggerEvent('cui_character:openStore', 'clothes')
		end,
		hashes = {
			257763003
		},
		label = "👔-Comprar ropa (Simple)",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	clothesGirl2 = {
		action = function(entity, action)
			TriggerEvent('esx_np_skinshop:toggleMenu', 'clotheshop')
		end,
		hashes = {
			257763003
		},
		label = "👔-Comprar ropa (Completo)",
		actionDistance = 3.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	accessoriesGirl = {
		action = function(entity, action)
			TriggerEvent('cui_character:openStore', 'accessories')
		end,
		hashes = {
			-868827412
		},
		label = "comprar accesorios",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	masksGuy = {
		action = function(entity, action)
			TriggerEvent('cui_character:openStore', 'masks')
		end,
		hashes = {
			-598109171
		},
		label = "comprar mascaras",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	barbershopGirls = {
		action = function(entity, action)
			TriggerEvent('cui_character:openStore', "barbershop")
		end,
		hashes = {
			373000027
		},
		label = "cortarse el pelo",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	tattooGuys = {
		action = function(entity, action)
			TriggerEvent('esx_tattooshop:openMenu_ui')
		end,
		hashes = {
			-1800524916
		},
		label = "tatuarse",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	woodCutterAxe = {
		action = function(entity, action)
			TriggerEvent('esx_woodcutter:getTool')
		end,
		hashes = {
			1625728984
		},
		label = "Iniciar Trabajo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = nil
	},
	woodCutterPlatform = {
		action = function(entity, action)
			TriggerServerEvent('esx_woodcutter:getPlatform')
		end,
		hashes = {
			1625728984
		},
		label = "Solicitar plataforma",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = nil
	},
	woodCutterForklift = {
		action = function(entity, action)
			TriggerServerEvent('esx_woodcutter:getForklift')
		end,
		hashes = {
			1625728984
		},
		label = "Solicitar Toro",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = nil
	},
	woodCutterTrailer = {
		action = function(entity, action)
			TriggerServerEvent('esx_woodcutter:getTrailer')
		end,
		hashes = {
			1625728984
		},
		label = "Solicitar camión",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"woodcutter"},
		entityCoords = nil
	},
	woodSell = {
		action = function(entity, action)
			TriggerEvent('esx_woodcutter:sellWood')
		end,
		hashes = {
			-283816889
		},
		label = "vender madera",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	minersCloak_civil = {
		action = function(entity, action)
			TriggerEvent('esx_miner:cloak_ui_civil')
		end,
		hashes = {
			-429715051
		},
		label = "Ropa de civil",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"miner"},
		entityCoords = nil
	},
	minersCloak_job = {
		action = function(entity, action)
			TriggerEvent('esx_miner:cloak_ui_job')
		end,
		hashes = {
			-429715051
		},
		label = "Uniforme de trabajo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"miner"},
		entityCoords = nil
	},
	minersCloak_vehicle = {
		action = function(entity, action)
			TriggerEvent('esx_miner:cloak_ui_vehicle')
		end,
		hashes = {
			-429715051
		},
		label = "Solicitar vehiculo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"miner"},
		entityCoords = nil
	},
	dragado = {
		action = function(entity, action)
			TriggerEvent('esx_miner:wash_ui')
		end,
		hashes = {
			349680864
		},
		label = "dragar piedra",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	fundicion = {
		action = function(entity, action)
			TriggerEvent('esx_miner:melt_ui')
		end,
		hashes = {
			-673538407
		},
		label = "fundir materiales",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	minersSell_diamond = {
		action = function(entity, action)
			TriggerEvent('esx_miner:sell_diamond')
		end,
		hashes = {
			-568861381
		},
		label = "Vender diamantes",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"miner"},
		entityCoords = nil
	},
	minersSell_gold = {
		action = function(entity, action)
			TriggerEvent('esx_miner:sell_gold')
		end,
		hashes = {
			-568861381
		},
		label = "Vender oro",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"miner"},
		entityCoords = nil
	},
	minersSell_iron = {
		action = function(entity, action)
			TriggerEvent('esx_miner:sell_iron')
		end,
		hashes = {
			-568861381
		},
		label = "Vender hierro",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"miner"},
		entityCoords = nil
	},
	minersSell_copper = {
		action = function(entity, action)
			TriggerEvent('esx_miner:sell_copper')
		end,
		hashes = {
			-568861381
		},
		label = "Vender cobre",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"miner"},
		entityCoords = nil
	},
	garbageBoss_city = {
		action = function(entity, action)
			TriggerEvent('esx_garbage:citizen_wear')
		end,
		hashes = {
			-294281201
		},
		label = "Ropa de Civil",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"garbage"},
		entityCoords = nil
	},
	garbageBoss_job = {
		action = function(entity, action)
			TriggerEvent('esx_garbage:job_wear')
		end,
		hashes = {
			-294281201
		},
		label = "Uniforme de trabajo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"garbage"},
		entityCoords = nil
	},
	garbageBoss_veh = {
		action = function(entity, action)
			TriggerEvent('esx_garbage:vehicle')
		end,
		hashes = {
			-294281201
		},
		label = "Solicitar vehiculo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"garbage"},
		entityCoords = nil
	},
	gopostalBoss_civil_wear = {
		action = function(entity, action)
			TriggerEvent('esx_gopostal:civil')
		end,
		hashes = {
			1206185632
		},
		label = "Ropa de Civil",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"gopostal"},
		entityCoords = nil
	},
	gopostalBoss_job_wear = {
		action = function(entity, action)
			TriggerEvent('esx_gopostal:job')
		end,
		hashes = {
			1206185632
		},
		label = "Uniforme de trabajo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"gopostal"},
		entityCoords = nil
	},
	gopostalBoss_vehicle = {
		action = function(entity, action)
			TriggerEvent('esx_gopostal:vehicle')
		end,
		hashes = {
			1206185632
		},
		label = "Solicitar vehiculo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"gopostal"},
		entityCoords = nil
	},
	works_citizen_wear = {
		action = function(entity, action)
			TriggerEvent('esx_cityworks:citizen_wear')
		end,
		hashes = {
			-1635724594
		},
		label = "Ropa de civil",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"works"},
		entityCoords = nil
	},
	works_job_wear = {
		action = function(entity, action)
			TriggerEvent('esx_cityworks:job_wear')
		end,
		hashes = {
			-1635724594
		},
		label = "Ropa de trabajo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"works"},
		entityCoords = nil
	},
	works_vehicle = {
		action = function(entity, action)
			TriggerEvent('esx_cityworks:vehicle')
		end,
		hashes = {
			-1635724594
		},
		label = "Solicitar vehiculo",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"works"},
		entityCoords = nil
	},
	works_pay = {
		action = function(entity, action)
			TriggerEvent('esx_cityworks:pay')
		end,
		hashes = {
			-1635724594
		},
		label = "Cobrar facturas",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"works"},
		entityCoords = nil
	},
	deliveryBoss = {
		action = function(entity, action)
			TriggerEvent('esx_deliveries:boss_ui')
		end,
			hashes = {
			411185872
		},
		label = "interactuar",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	lsBusBoss_route = {
		action = function(entity, action)
			TriggerEvent('esx_busdriver_route_ui', 1)
		end,
		hashes = {
			-409745176
		},
		label = "Solicitar ruta",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"bus"},
		entityCoords = nil
	},
	lsBusBoss_bus = {
		action = function(entity, action)
			TriggerEvent('esx_busdriver_bus_ui', 1)
		end,
		hashes = {
			-409745176
		},
		label = "Sacar autobus",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"bus"},
		entityCoords = nil
	},
	sandyBusBoss_route = {
		action = function(entity, action)
			TriggerEvent('esx_busdriver_route_ui', 2)
		end,
		hashes = {
			-1427838341
		},
		label = "Solicitar ruta",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"bus"},
		entityCoords = nil
	},
	sandyBusBoss_bus = {
		action = function(entity, action)
			TriggerEvent('esx_busdriver_bus_ui', 2)
		end,
		hashes = {
			-1427838341
		},
		label = "Sacar autobus",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"bus"},
		entityCoords = nil
	},
	paletoBusBoss_route = {
		action = function(entity, action)
			TriggerEvent('esx_busdriver_route_ui', 3)
		end,
		hashes = {
			-308279251
		},
		label = "Solicitar ruta",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"bus"},
		entityCoords = nil
	},
	paletoBusBoss_bus = {
		action = function(entity, action)
			TriggerEvent('esx_busdriver_bus_ui', 3)
		end,
		hashes = {
			-308279251
		},
		label = "Sacar autobus",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = {"bus"},
		entityCoords = nil
	},
	taxiGarage = {
		action = function(entity, action)
			TriggerEvent('esx_taxijob:vehicle_menu')
		end,
		hashes = {
			994527967
		},
		label = "interactuar",
		actionDistance = 1.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	emsVehicle = {
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:open_garage_ui')
		end,
		hashes = {
			-140033735
		},
		label = "solicitar vehiculo",
		actionDistance = 5.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},
	emsHeli = {
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:open_heli_ui')
		end,
		hashes = {
			1142162924
		},
		label = "solicitar helicoptero",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},
	policeArmory = {
		action = function(entity, action)
			TriggerEvent('esx_policejob:open_armory_ui')
		end,
		hashes = {
			1581098148
		},
		label = "Usar Armeria",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	policeGaraje = {
		action = function(entity, action)
			TriggerEvent('esx_policejob:open_garage_ui')
		end,
		hashes = {
			-634611634
		},
		label = "usar garaje",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	policeHeli = {
		action = function(entity, action)
			TriggerEvent('esx_policejob:open_heli_ui')
		end,
		hashes = {
			1657546978
		},
		label = "usar helipuerto",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	billyTrevor = {
		action = function(entity, action)
			TriggerEvent('esx_chatarra:openStore')
		end,
		hashes = {
			-1686040670
		},
		label = "comerciar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	hardwareSelling = {
		action = function(entity, action)
			TriggerEvent('esx_chatarra:openStore', true)
		end,
		hashes = {
			188012277
		},
		label = "comerciar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	cardealerAuto = {
		action = function(entity, action)
			local shop --comprobamos en que tienda estamos, para saber que lista de coches cargar
            if #(entity.coords - vector3(-56.4, -1099.06, 25.4)) < 2.0 then
                shop = 'mid'
            elseif #(entity.coords - vector3(-42.51, -1673.72, 29.49)) < 2.0 then
                shop = 'low'
            elseif #(entity.coords - vector3(-151.69, -591.96, 167.0)) < 2.0 then
                shop = 'high'
            end
            if shop then
                TriggerEvent('esx_vehicleshop:openAutoMenu', shop)
            end
		end,
		hashes = {
			797459875
		},
		label = "comerciar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	cardealerProviderLow = {
		action = function(entity, action)
			TriggerEvent('esx_vehicleshop:openPlayerMenu', 'low')
		end,
		hashes = {
			365775923
		},
		label = "comerciar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	cardealerProviderMid = {
		action = function(entity, action)
			TriggerEvent('esx_vehicleshop:openPlayerMenu', 'mid')
		end,
		hashes = {
			-52268862
		},
		label = "comerciar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	cardealerProviderHigh = {
		action = function(entity, action)
			TriggerEvent('esx_vehicleshop:openPlayerMenu', 'high')
		end,
		hashes = {
			-1868718465
		},
		label = "comerciar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	joblistingGirl = {
		action = function(entity, action)
			TriggerEvent('esx_joblisting:Menu_ui', entity.coords)
		end,
		hashes = {
			2006035933
		},
		label = "informarse",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	garajeGuy = {
		action = function(entity, action)
			TriggerEvent('esx_eden_garage:openMenu_ui', entity.coords)
		end,
		hashes = {
			-304305299
		},
		label = "sacar coche",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	john = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:openCharacterMenu', 1, myJob)
		end,
		hashes = {
			1728056212
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	daisy = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:openCharacterMenu', 2, myJob)
		end,
		hashes = {
			2129936603
		},
		label = "hablar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	charles = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:openCharacterMenu', 3, myJob)
		end,
		hashes = {
			225514697
		},
		label = "hablar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	leyla = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:openCharacterMenu', 4, "")
		end,
		hashes = {
			"ig_djtalaurelia"
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	john1 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 1, 1)
		end,
		hashes = {
			1906124788
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	john2 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 1, 2)
		end,
		hashes = {
			-1124046095
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	john3 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 1, 3)
		end,
		hashes = {
			-1105179493
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	daisy1 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 2, 1)
		end,
		hashes = {
			-2113195075
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	daisy2 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 2, 2)
		end,
		hashes = {
			1706635382
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	daisy3 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 2, 3)
		end,
		hashes = {
			-1660909656
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	charles1 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 3, 1)
		end,
		hashes = {
			-1111799518
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	charles2 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 3, 2)
		end,
		hashes = {
			874722259
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	charles3 = {
		action = function(entity, action)
			TriggerEvent('esx_daily_quest:questInteraction', 3, 3)
		end,
		hashes = {
			1302784073
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	bitcoin = {
		action = function(entity, action)
			TriggerEvent('esx_bitcoin:openExchange')
		end,
		hashes = {
			-1507505719
		},
		label = "traficar con bitcoin",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "cardealer", "taxi"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	bikeRental = {
		action = function(entity, action)
			TriggerEvent("esx_bike_rental:openRentalMenu")
		end,
		hashes = {
			1984382277
		},
		label = "alquilar/devolver bici",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	gymGuy = {
		action = function(entity, action)
			TriggerEvent("esx_gym:openGymMenu")
		end,
		hashes = {
			-636391810
		},
		label = "hablar",
		actionDistance = 2.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	weedIndoorGuy = {
		action = function(entity, action)
			TriggerEvent('esx_weed:weedFarmMenu', myJob)
		end,
		hashes = {
			-765011498
		},
		label = "hablar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	weedIndoorWorker = {
		action = function(entity, action)
			TriggerEvent('esx_weed:putWeedInCase', myJob)
		end,
		hashes = {
			-1301974109
		},
		label = "hablar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	cokeGuy = {
		action = function(entity, action)
			TriggerEvent('esx_coke:tryFarmCoke')
		end,
		hashes = {
			648372919
		},
		label = "interactuar",
		actionDistance = 2.0,
		restrictedJobs = {"police", "offpolice", "mechanic", "ambulance", "taxi", "cardealer"},
		whiteListedJobs = nil,
		entityCoords = nil
	},
	phoneShop = {
		action = function(entity, action)
			TriggerEvent('gcphone:openPhoneShop')
		end,
		hashes = {
			226559113
		},
		label = "comerciar",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	}
}





--------------------------------------------------------------------------------------

								--PLAYER ACTIONS--

--------------------------------------------------------------------------------------




Config.selfActions = {
	llavedelcoche = {
		subMenu = "utilities",
		action = function(entity, action)
		Citizen.Wait(75)
			TriggerEvent('carremote:useKey')
		end,
		label = "Llave de Vehiculos",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	guitarra = {
		action = function(entity, action)
			Citizen.Wait(75)
			TriggerEvent('artofguitar:openmenu')
		end,
		label = "Tocar Guitarra",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},

	-------------- MECANICOS --------------
	herramientas = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:toolbox_ui')
		end,
		label = "Caja de Herramientas",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	cono = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_policejob:put_object', "cono")
		end,
		label = "Colocar Cono",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	empezarfactura = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_lscustom:startBill')
		end,
		label = "Empezar Factura",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},
	terminarfactura = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_lscustom:endBill')
		end,
		label = "Terminar Factura",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},

	-------------- POLICIA --------------
	barrera = {
		subMenu = "police_objects",
		subMenuLabel = "Colocar Objetos",
		action = function(entity, action)
			TriggerEvent('esx_policejob:put_object', "barrera")
		end,
		label = "Barrera",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	cono = {
		subMenu = "police_objects",
		subMenuLabel = "Colocar Objetos",
		action = function(entity, action)
			TriggerEvent('esx_policejob:put_object', "cono")
		end,
		label = "Cono",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	tiradepinchos = {
		subMenu = "police_objects",
		subMenuLabel = "Colocar Objetos",
		action = function(entity, action)
			TriggerEvent('esx_policejob:put_object', "tira")
		end,
		label = "Cadena de Pinchos",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},

	-------------- CARDEALERS --------------
	exponervehiculo = {
		subMenu = "cardealer",
		action = function(entity, action)
			local shop = getCurrentShop()
		    if shop then
		        TriggerEvent('esx_vehicleshop:pop_vehicle', shop)
		    else
		        ESX.ShowNotification('Debes estar en el ~g~CONCESIONARIO~w~ para hacer eso!')
		    end
		end,
		label = "Exponer Vehiculo",
		actionDistance = 1.0,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer"},
		entityCoords = nil
	}
}

Config.playerActions = {
	-- DAR DINERO
	dar50 = {
		subMenu = "dardinero",
		action = function(entity, action)
			TriggerEvent('menuDependencies:darDinero', true, entity.target,  50)
		end,
		label = "Dar 50 💲",
		actionDistance = 2.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	dar100 = {
		subMenu = "dardinero",
		action = function(entity, action)
			TriggerEvent('menuDependencies:darDinero',true, entity.target, 100)
		end,
		label = "Dar 100 💲",
		actionDistance = 2.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	dar500 = {
		subMenu = "dardinero",
		action = function(entity, action)
			TriggerEvent('menuDependencies:darDinero',true, entity.target,  500)
		end,
		label = "Dar 500 💲",
		actionDistance = 2.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	camillaPut = {
		subMenu = "ambulance",
		action = function(entity, action)
			ExecuteCommand("getintostr "..GetPlayerServerId(GetPlayerFromPed(entity.target)))
			--TriggerEvent('menuDependencies:darDinero',true, entity.target,  500)
		end,
		label = "🛏️-Poner en Camilla",
		actionDistance = 3.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	-- FIN DAR DINERO --
	intercambiar = {
		subMenu = "interaction",
		action = function(entity, action)
			TriggerEvent('esx_commerce:interchange', entity.target)
		end,
		label = "Intercambiar",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},
	cargar = {
		subMenu = "interaction",
		action = function(entity, action)
			TriggerEvent('esx_people_interactions:carry', entity.target)
		end,
		label = "Cargar",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = nil,
		entityCoords = nil
	},

	-------------- POLICIA --------------
	escoltar = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:drag_ui', entity.target)
		end,
		label = "Escoltar",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	detener = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:handcuff_ui', entity.target)
		end,
		label = "Detener",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	meterencoche = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:put_vehicle_ui', entity.target)
		end,
		label = "Meter en Vehiculo",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	cachear = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:search_ui', entity.target)
		end,
		label = "Registrar",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	multasimpagadas = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:manage_bill_ui', entity.target)
		end,
		label = "Consultar Multas",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	multar = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:fine_ui', entity.target)
		end,
		label = "Multar",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},
	emitirlicencias = {
		subMenu = "police",
		action = function(entity, action)
			TriggerEvent('esx_policejob:createLicenses_ui', entity.target)
		end,
		label = "Emitir Licencias",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"police"},
		entityCoords = nil
	},

	-------------- MECANICOS --------------
	facturar = {
		subMenu = "mechanic",
		action = function(entity, action)
			TriggerEvent('esx_mechanicjob:billing_ui', entity.target)
		end,
		label = "Facturar",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"mechanic"},
		entityCoords = nil
	},

	-------------- TAXI --------------
	cobrar = {
		subMenu = "taxi",
		action = function(entity, action)
			TriggerEvent('esx_taxijob:billing_ui', entity.target)
		end,
		label = "Hacer Factura",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"taxi"},
		entityCoords = nil
	},

	-------------- UMC --------------
	diagnosis = {
		subMenu = "ambulance",
		action = function(entity, action)
			TriggerEvent('amb:diagnosticoEx', entity.target)
		end,
		label = "🔬-Diagnosticar",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},
	reanimar = {
		subMenu = "ambulance",
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:action_ui', "reanimar", entity.target)
		end,
		label = "💉-Reanimar",
		actionDistance = 2.5,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},
	heridasleves = {
		subMenu = "ambulance",
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:action_ui', "leve", entity.target)
		end,
		label = "⚕️-Curacion superficial",
		actionDistance = 2.3,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},
	heridasgraves = {
		subMenu = "ambulance",
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:action_ui', "grave", entity.target)
		end,
		label = "😷-Curacion Intensiva",
		actionDistance = 2.3,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},
	meterenvehiculo = {
		subMenu = "ambulance",
		action = function(entity, action)
			TriggerEvent('esx_ambulancejob:action_ui', "coche", entity.target)
		end,
		label = "🚑-Meter en Vehiculo",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"ambulance"},
		entityCoords = nil
	},

	-------------- CARDEALERS --------------
	vender = {
		subMenu = "cardealer",
		action = function(entity, action)
			local shop = getCurrentShop()
		    if shop then
		        TriggerEvent('esx_vehicleshop:billing_ui', entity.target)
		    else
		        ESX.ShowNotification('Debes estar en el ~g~CONCESIONARIO~w~ para hacer eso!')
		    end 
		end,
		label = "Vender Vehiculo",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer"},
		entityCoords = nil
	},
	entregarvehiculo = {
		subMenu = "cardealer",
		action = function(entity, action)
			local shop = getCurrentShop()
		    if shop then
		        TriggerEvent('esx_vehicleshop:give_vehicle', shop, entity.target)
		    else
		        ESX.ShowNotification('Debes estar en el ~g~CONCESIONARIO~w~ para hacer eso!')
		    end  
		end,
		label = "Entregar Vehiculo",
		actionDistance = 1.3,
		restrictedJobs = nil,
		whiteListedJobs = {"cardealer"},
		entityCoords = nil
	}
}
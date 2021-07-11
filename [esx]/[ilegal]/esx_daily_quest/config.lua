Config = {}

Config.ranges = {
	"Desconocido",
	"Amistoso",
	"Ayudante",
	"Trabajador",
	"Socio"
}

--john
Config.paquete_sospechoso = "paquete_sospechoso"
Config.john_payment = "john_payment"
Config.john_pckg = "john_pckg"

--daisy
Config.janette_meds = "janette_meds"
Config.daisy_weed = "daisy_weed"
Config.daisy_angel = "daisy_angel"

--charles
Config.pedo_hdd = "pedo_hdd"
Config.human_heart = "human_heart"
Config.ledgerx = "ledgerx"

--questTypes
Config.delivery = "delivery"
Config.pickup = "pickup"

Config.Characters = {
	{
		--LAS COMENTADAS SON LAS BUENAS!!!
		--coords = vector3(1441.35, 6332.4, 22.94),
		--heading = 353.24,
		coords = vector3(235.886, -898.284, 29.692),
		heading = 56.062,
		model = "ig_terry",
		name = "john",
		surname = "McKane",
		animation = "WORLD_HUMAN_LEANING",
		money = "black_money",
		lvlNeedXP = {
			1200,
			2550,
			5250,
			8200,
			10000
		},
		quests = {
			{
				name = "Paquete sospechoso",
				questItem = Config.paquete_sospechoso,
				questType = Config.delivery,
				description = "Tengo un amigo llamado Jimmy que lleva unos días esperando un paquete mio, mejor no preguntes, llevaselo y te ganaras algo... Vive en una caravana en stab city.",
				questStart = function()
					Citizen.CreateThread(function()
						TriggerServerEvent("esx_daily_quest:startDeliveryQuest", Config.paquete_sospechoso)
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.delivery, Config.paquete_sospechoso)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "john", level, Config.delivery, nil)
					end)
				end,
				money = 620,
				possibleItems = {
					{
						{type = "item", name = "lasagna", label = "Lasaña", amount = 4, weight = 0.9},
						{type = "item", name = "bandage", label = "Bendas", amount = 2, weight = 0.6}
					},
					{
						{type = "item", name = "weed_pooch", label = "Bolsa de Maria", amount = 6, weight = 0.6},
						{type = "item", name = "medikit", label = "Botiquin", amount = 1, weight = 1.2}
					},
					{
						{type = "item", name = "coke_pooch", label = "Pollo de coca", amount = 3, weight = 0.6},
						{type = "item", name = "meds_box", label = "Cajas de farmacos", amount = 1, weight = 0.8}
					}
				}
			},
			{
				name = "Saldar una deuda",
				questItem = Config.john_payment,
				questType = Config.pickup,
				description = "Hay un tio, que vive en una caravana al norte de paleto bay, me debe pasta y me ha dicho que pase a recogerla, estoy hasta arriba de mierda, traemela y te dare unos pavos...",
				questStart = function()
					Citizen.CreateThread(function()
						
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.pickup, Config.john_payment)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "john", level, Config.pickup, Config.john_payment)
					end)
				end,
				money = 680,
				possibleItems = {
					{
						{type = "item", name = "monster", label = "Monster", amount = 4, weight = 0.7},
						{type = "item", name = "carokit", label = "Kit de carrocería", amount = 1, weight = 2}
					},
					{
						{type = "item", name = "weed_pooch", label = "Bolsa de Maria", amount = 6, weight = 0.6},
						{type = "item", name = "fixkit", label = "Kit de reparación", amount = 1, weight = 2}
					},
					{
						{type = "item", name = "meth_pooch", label = "Bolsa de meta", amount = 3, weight = 0.8},
						{type = "weapon", name = "WEAPON_CROWBAR", label = "palanca", amount = 1, weight = 0}
					}
				}
			},
			{
				name = "Suministros belicos",
				questItem = Config.john_pckg,
				questType = Config.pickup,
				description = "Ha llegado un pedido de armas que hice a los rusos, lo tiene un compi mio, esta en el poligono, en los callejones detras de ammunation, ve a buscarlo.",
				questStart = function()
					Citizen.CreateThread(function()
						
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.pickup, Config.john_pckg)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "john", level, Config.pickup, Config.john_pckg)
					end)
				end,
				money = 680,
				possibleItems = {
					{
						{type = "item", name = "lasagna", label = "Lasaña", amount = 3, weight = 0.9},
						{type = "item", name = "monster", label = "Monster", amount = 3, weight = 0.7}
					},
					{
						{type = "item", name = "hash", label = "Hachis", amount = 5, weight = 0.4},
						{type = "item", name = "monster", label = "Monster", amount = 2, weight = 0.7}
					},
					{
						{type = "item", name = "hash", label = "Hachis", amount = 7, weight = 0.4},
						{type = "item", name = "binoculars", label = "Prismaticos", amount = 1, weight = 1.8}
					}
				}
			}
		},
		timeBetweenQuests = 8,
		storeItems = {
			{name = 'muelle', stockAmount = 8, label = "Muelle", price = 5, levelNeed = 1, type = "item", weight = 0.2},
			{name = 'piezas', stockAmount = 13, label = "Piezas sueltas", price = 7, levelNeed = 1, type = "item", weight = 0.3},
			{name = 'valve', stockAmount = 5, label = "Valvula", price = 16, levelNeed = 1, type = "item", weight = 0.5},
			{name = 'candado', stockAmount = 3, label = "Candado", price = 25, levelNeed = 1, type = "item", weight = 0.4},
			{name = 'mouse', stockAmount = 1, label = "Raton", price = 55, levelNeed = 2, type = "item", weight = 0.3},
			{name = 'weed', stockAmount = 32, label = "marihuana", price = 12, levelNeed = 2, type = "item", weight = 0.3},
			{name = 'coke', stockAmount = 18, label = "hoja de coca", price = 19, levelNeed = 2, type = "item", weight = 0.3},
			{name = 'WEAPON_SWITCHBLADE', stockAmount = 1, label = "navaja", price = 640, levelNeed = 3, type = "weapon"},
			{name = 'WEAPON_CROWBAR', stockAmount = 1, label = "palanca", price = 760, levelNeed = 4, type = "weapon"},
			{name = 'binoculars', stockAmount = 2, label = "Prismaticos", price = 2265, levelNeed = 4, type = "item", weight = 1.8},
			{name = 'WEAPON_MINISMG', stockAmount = 1, label = "Mini SMG", price = 19525, levelNeed = 5, type = "weapon"},
			{name = 'smg_mag', stockAmount = 1, label = "Cargador SMG", price = 2350, levelNeed = 5, type = "item", weight = 1.2},
			{name = 'meth_card', stockAmount = 1, label = "Tarjeta de Meta", price = 4350, levelNeed = 5, type = "item", weight = 0.1},
			{name = 'everon', stockAmount = 1, label = "Everon", price = 42660, levelNeed = 5, type = "vehicle"}
		},
		interestItem = {
			name = "radio_trans",
			label = "transmisor de radio",
			description = "Si encuentras transmisores de radio viejos, traemelos, los uso para decodificar las emisoras de la pasma...",
			givenXP = 95,
			givenMoney = 225
		},
	},
	{
		--coords = vector3(720.78, 1291.68, 359.3),
		--heading = 171.87,
		coords = vector3(232.158, -903.706, 29.692),
		heading = 48.41,
		model = "ig_ashley",
		name = "daisy",
		surname = "Jones",
		animation = "WORLD_HUMAN_LEANING",
		money = "black_money",
		lvlNeedXP = {
			1800,
			2950,
			6250,
			9300,
			11500
		},
		quests = {
			{
				name = "Medicinas para Janette",
				questItem = Config.janette_meds,
				questType = Config.delivery,
				description = "A mi amiga Janette le gusta mucho la vicodina, pero las que le receta el medico no le quitan el mono, yo se las consigo en el mercado negro, seguro que esta en la peluqueria, llevaselas.",
				questStart = function()
					Citizen.CreateThread(function()
						TriggerServerEvent("esx_daily_quest:startDeliveryQuest", Config.janette_meds)
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.delivery, Config.janette_meds)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "daisy", level, Config.delivery, nil)
					end)
				end,
				money = 740,
				possibleItems = {
					{
						{type = "item", name = "steal_radio", label = "Radio robada", amount = 1, weight = 0.8},
						{type = "item", name = "steal_phone", label = "Telefono robado", amount = 1, weight = 0.6}
					},
					{
						{type = "item", name = "morphine", label = "Morfina", amount = 1, weight = 0.3},
						{type = "item", name = "steal_phone", label = "Telefono robado", amount = 1, weight = 0.6}
					},
					{
						{type = "item", name = "meth_pooch", label = "Bolsa de meta", amount = 4, weight = 0.8},
						{type = "item", name = "radio_trans", label = "Trans. de Radio", amount = 1, weight = 0}
					}
				}
			},
			{
				name = "Unos gramos de alegria",
				questItem = Config.daisy_weed,
				questType = Config.pickup,
				description = "Mi colega Dave trabaja en la plantacion de maria que hay al noreste... acaba de cortar y me ha dicho me pase a buscar mi parte, no tengo tiempo, asi que traemela y habra comision.",
				questStart = function()
					Citizen.CreateThread(function()
						
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.pickup, Config.daisy_weed)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "daisy", level, Config.pickup, Config.daisy_weed)
					end)
				end,
				money = 660,
				possibleItems = {
					{
						{type = "item", name = "weed", label = "marihuana", amount = 8, weight = 0.3},
						{type = "item", name = "steal_radio", label = "Radio robada", amount = 1, weight = 0.8}
					},
					{
						{type = "item", name = "adrenaline_shot", label = "Adrenalina", amount = 1, weight = 0.3},
						{type = "item", name = "steal_phone", label = "Telefono robado", amount = 1, weight = 0.6}
					},
					{
						{type = "item", name = "puar", label = "Púa Firmada", amount = 2, weight = 0.2},
						{type = "item", name = "weed_card", label = "Tarjeta marihuana", amount = 1, weight = 0}
					}
				}
			},
			{
				name = "Rollos en groove street",
				questItem = Config.daisy_angel,
				questType = Config.pickup,
				description = "Tengo un pedido de polvo de angel y le he encargado a Big Joe que me lo cocine, ya esta listo, asi que si me lo traes... igual te cae algo como recompensa... por cierto, vive en groove street.",
				questStart = function()
					Citizen.CreateThread(function()
						
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.pickup, Config.daisy_angel)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "daisy", level, Config.pickup, Config.daisy_angel)
					end)
				end,
				money = 680,
				possibleItems = {
					{
						{type = "item", name = "old_hardware", label = "Hardware viejo", amount = 3, weight = 1},
						{type = "item", name = "bandage", label = "Bendas", amount = 2, weight = 0.6}
					},
					{
						{type = "item", name = "old_hardware", label = "Hardware viejo", amount = 5, weight = 1},
						{type = "item", name = "medikit", label = "Botiquin", amount = 1, weight = 1.2}
					},
					{
						{type = "item", name = "hash", label = "Bolsa de meta", amount = 6, weight = 0.4},
						{type = "weapon", name = "WEAPON_SWITCHBLADE", label = "Navaja", amount = 1, weight = 0}
					}
				}
			}
		},
		timeBetweenQuests = 8,
		storeItems = {
			{name = 'tornillos', stockAmount = 5, label = "Tornillos", price = 10, levelNeed = 1, type = "item", weight = 0.2},
			{name = 'filter', stockAmount = 2, label = "Filtro", price = 44, levelNeed = 1, type = "item", weight = 0.6},
			{name = 'wires', stockAmount = 3, label = "Cables", price = 10, levelNeed = 1, type = "item", weight = 0.5},
			{name = 'meth', stockAmount = 14, label = "Productos quimicos", price = 23, levelNeed = 2, type = "item", weight = 0.4},
			{name = 'psu', stockAmount = 1, label = "PSU", price = 74, levelNeed = 2, type = "item", weight = 0.6},
			{name = 'morphine', stockAmount = 2, label = "Morfina", price = 2500, levelNeed = 3, type = "item", weight = 0.3},
			{name = 'keyboard', stockAmount = 1, label = "Teclado", price = 75, levelNeed = 3, type = "item", weight = 0.8},
			{name = 'adrenaline_shot', stockAmount = 2, label = "Adrenalina", price = 2750, levelNeed = 4, type = "item", weight = 0.3},
			{name = 'dvd', stockAmount = 1, label = "Reproductor DVD", price = 350, levelNeed = 4, type = "item", weight = 1.3},
			{name = 'WEAPON_COMPACTRIFLE', stockAmount = 1, label = "Rifle Compacto", price = 21250, levelNeed = 5, type = "weapon"},
			{name = 'rifle_mag', stockAmount = 2, label = "Cargador Rifle", price = 4500, levelNeed = 5, type = "item", weight = 1.5},
			{name = 'weed_card', stockAmount = 1, label = "Tarjeta Marihuana", price = 2250, levelNeed = 5, type = "item", weight = 0.2},
			{name = 'gburrito2', stockAmount = 1, label = "Burrito", price = 58500, levelNeed = 5, type = "vehicle"}
		},
		interestItem = {
			name = "meds_box",
			label = "cajas de farmacos",
			description = "Si te haces con cajas de farmacos vacias traemelas, van cojonudas para traficar con medicamentos sin receta, el numero de serie esta registrado a una receta, asi que cuela...",
			givenXP = 110,
			givenMoney = 215
		},
	},
	{
		--coords = vector3(106.64, -1297.06, 26.80),
		--heading = 297.92,
		coords = vector3(227.242, -911.114, 29.692),
		heading = 58.976,
		model = "player_zero",
		name = "charles",
		surname = "Doppler",
		animation = "PROP_HUMAN_SEAT_ARMCHAIR",
		money = "black_money",
		lvlNeedXP = {
			2200,
			4350,
			7850,
			13500,
			18625
		},
		quests = {
			{
				name = "Videos turbios",
				questItem = Config.pedo_hdd,
				questType = Config.delivery,
				description = "Hay un colgado que vive en la caseta junto al lago de mirror park, le van unos rollos muy turbios, a mi no me va mucho el tema, pero es pasta, le he conseguido material nuevo, pasaselo.",
				questStart = function()
					Citizen.CreateThread(function()
						TriggerServerEvent("esx_daily_quest:startDeliveryQuest", Config.pedo_hdd)
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.delivery, Config.pedo_hdd)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "charles", level, Config.delivery, nil)
					end)
				end,
				money = 1000,
				possibleItems = {
					{
						{type = "item", name = "usb", label = "USB", amount = 2, weight = 0.1},
						{type = "item", name = "bullet_shell", label = "Casquillos .45", amount = 2, weight = 0.2}
					},
					{
						{type = "item", name = "ram", label = "Memoria ram", amount = 1, weight = 0.2},
						{type = "item", name = "bullet_shell", label = "Casquillos .45", amount = 2, weight = 0.2}
					},
					{
						{type = "item", name = "radio_trans", label = "Trans. de Radio", amount = 1, weight = 0},
						{type = "item", name = "gunpowder", label = "Polvora", amount = 1, weight = 0.5}
					}
				}
			},
			{
				name = "Una cuestion organica",
				questItem = Config.human_heart,
				questType = Config.delivery,
				description = "Estoy metido en un negocio turbio con organos, un pez gordo que vive en una mansion de rockford hills necesita un corazon nuevo, como le han puesto en lista de espera me ha encargado uno, llevaselo con mucha discrecion.",
				questStart = function()
					Citizen.CreateThread(function()
						TriggerServerEvent("esx_daily_quest:startDeliveryQuest", Config.human_heart)
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.delivery, Config.human_heart)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "charles", level, Config.delivery, nil)
					end)
				end,
				money = 970,
				possibleItems = {
					{
						{type = "item", name = "motherboard", label = "Placa Base", amount = 1, weight = 0.6},
						{type = "item", name = "bullet_shell", label = "Casquillos .45", amount = 2, weight = 0.2}
					},
					{
						{type = "item", name = "psu", label = "PSU", amount = 1, weight = 0.8},
						{type = "item", name = "steal_phone", label = "Telefono robado", amount = 1, weight = 0.6}
					},
					{
						{type = "item", name = "gpu", label = "T. Grafica", amount = 1, weight = 0.4},
						{type = "item", name = "usb_hack", label = "USB Hacking", amount = 1, weight = 0.1}
					}
				}
			},
			{
				name = "Criptomonedas al poder",
				questItem = Config.ledgerx,
				questType = Config.pickup,
				description = "Te has enterado ya de que Bitcoin es el futuro? Hace meses que no para de subir y he decidido meterme en el negocio, un compi de burrito heights me ha preparado un monedero fisico, ve a buscarlo, te aviso, en esa casa son unos frikis...",
				questStart = function()
					Citizen.CreateThread(function()
						
					end)	
				end,
				questInteraction = function()
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.pickup, Config.ledgerx)
						SendNUIMessage({action = "showNotification", message = "Mision lista"})
					end)
				end,
				questEnd = function(possibleItems, money, level)
					Citizen.CreateThread(function()
						TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "charles", level, Config.pickup, Config.ledgerx)
					end)
				end,
				money = 880,
				possibleItems = {
					{
						{type = "item", name = "hdd", label = "Disco duro", amount = 1, weight = 0.4},
						{type = "item", name = "wires", label = "Cables", amount = 1, weight = 0.5}
					},
					{
						{type = "item", name = "hdd", label = "Disco duro", amount = 1, weight = 0.4},
						{type = "item", name = "grip", label = "Empuñadura", amount = 1, weight = 0.4}
					},
					{
						{type = "item", name = "gpu", label = "T. Grafica", amount = 1, weight = 0.4},
						{type = "item", name = "ledgers", label = "Ledger Nano S", amount = 1, weight = 0.1}
					}
				}
			}
		},
		timeBetweenQuests = 8,
		storeItems = {
			{name = 'usb', stockAmount = 5, label = "USB", price = 35, levelNeed = 1, type = "item", weight = 0.1},
			{name = 'hdd', stockAmount = 1, label = "Disco Duro", price = 95, levelNeed = 2, type = "item", weight = 0.4},
			{name = 'ram', stockAmount = 3, label = "Memoria ram", price = 65, levelNeed = 2, type = "item", weight = 0.2},
			{name = 'motherboard', stockAmount = 1, label = "Placa base", price = 275, levelNeed = 3, type = "item", weight = 0.6},
			{name = 'gpu', stockAmount = 1, label = "T. Grafica", price = 550, levelNeed = 3, type = "item", weight = 0.4},
			{name = 'ledgers', stockAmount = 1, label = "Ledger Nano S", price = 2500, levelNeed = 4, type = "item", weight = 0.1},
			{name = 'gunpowder', stockAmount = 2, label = "Polvora", price = 3400, levelNeed = 4, type = "item", weight = 0.5},
			{name = 'grip', stockAmount = 1, label = "Empuñadura", price = 4500, levelNeed = 4, type = "item", weight = 0.4},
			{name = 'suppressor', stockAmount = 1, label = "Silenciador", price = 13675, levelNeed = 4, type = "item", weight = 0.4},
			{name = 'flashlight', stockAmount = 2, label = "Linterna", price = 8675, levelNeed = 4, type = "item", weight = 0.3},
			{name = 'sg_mag', stockAmount = 2, label = "Cartuchos Escopeta", price = 5670, levelNeed = 5, type = "item", weight = 0.8},
			{name = 'WEAPON_SAWNOFFSHOTGUN', stockAmount = 1, label = "Escopeta recortada", price = 24250, levelNeed = 5, type = "weapon"},
			{name = 'coke_card', stockAmount = 1, label = "Tarjeta Cocaina", price = 3500, levelNeed = 5, type = "item", weight = 0.1},
			{name = 'cognoscenti', stockAmount = 1, label = "Cognoscenti", price = 155500, levelNeed = 5, type = "vehicle"}
		},
		interestItem = {
			name = "correo_ajeno",
			label = "Correo ajeno",
			description = "Me dedico mucho al cibercrimen, pero tambien me viene bien tener un perfil de los datos fisicos que se mueven en la ciudad, si me traes correo que encuentres por ahi te pagare algo...",
			givenXP = 150,
			givenMoney = 155
		},
	},
	{
		--LAS COMENTADAS SON LAS BUENAS!!!
		--coords = vector3(1441.35, 6332.4, 22.94),
		--heading = 353.24,
		coords = vector3(235.886, -898.284, 29.692),
		heading = 56.062,
		model = nil,
		name = "leyla",
		surname = " Swift",
		animation = nil,
		money = "money",
		lvlNeedXP = {
			150,
			300,
			460,
			700,
			1500
		},
		--quests = {
			--{
			--	name = "Paquete sospechoso",
			--	questItem = Config.paquete_sospechoso,
			--	questType = Config.delivery,
			--	description = "Tengo un amigo llamado Jimmy que lleva unos días esperando un paquete mio, mejor no preguntes, llevaselo y te ganaras algo... Vive en una caravana en stab city.",
			--	questStart = function()
			--		Citizen.CreateThread(function()
			--			TriggerServerEvent("esx_daily_quest:startDeliveryQuest", Config.paquete_sospechoso)
			--		end)	
			--	end,
			--	questInteraction = function()
			--		Citizen.CreateThread(function()
			--			TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.delivery, Config.paquete_sospechoso)
			--			SendNUIMessage({action = "showNotification", message = "Mision lista"})
			--		end)
			--	end,
			--	questEnd = function(possibleItems, money, level)
			--		Citizen.CreateThread(function()
			--			TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "john", level, Config.delivery, nil)
			--		end)
			--	end,
			--	money = 620,
			--	possibleItems = {
			--		{
			--			{type = "item", name = "lasagna", label = "Lasaña", amount = 4, weight = 0.9},
			--			{type = "item", name = "bandage", label = "Bendas", amount = 2, weight = 0.6}
			--		},
			--		{
			--			{type = "item", name = "weed_pooch", label = "Bolsa de Maria", amount = 6, weight = 0.6},
			--			{type = "item", name = "medikit", label = "Botiquin", amount = 1, weight = 1.2}
			--		},
			--		{
			--			{type = "item", name = "coke_pooch", label = "Pollo de coca", amount = 3, weight = 0.6},
			--			{type = "item", name = "meds_box", label = "Cajas de farmacos", amount = 1, weight = 0.8}
			--		}
			--	}
			--},
			--{
			--	name = "Saldar una deuda",
			--	questItem = Config.john_payment,
			--	questType = Config.pickup,
			--	description = "Hay un tio, que vive en una caravana al norte de paleto bay, me debe pasta y me ha dicho que pase a recogerla, estoy hasta arriba de mierda, traemela y te dare unos pavos...",
			--	questStart = function()
			--		Citizen.CreateThread(function()
			--			
			--		end)	
			--	end,
			--	questInteraction = function()
			--		Citizen.CreateThread(function()
			--			TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.pickup, Config.john_payment)
			--			SendNUIMessage({action = "showNotification", message = "Mision lista"})
			--		end)
			--	end,
			--	questEnd = function(possibleItems, money, level)
			--		Citizen.CreateThread(function()
			--			TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "john", level, Config.pickup, Config.john_payment)
			--		end)
			--	end,
			--	money = 680,
			--	possibleItems = {
			--		{
			--			{type = "item", name = "monster", label = "Monster", amount = 4, weight = 0.7},
			--			{type = "item", name = "carokit", label = "Kit de carrocería", amount = 1, weight = 2}
			--		},
			--		{
			--			{type = "item", name = "weed_pooch", label = "Bolsa de Maria", amount = 6, weight = 0.6},
			--			{type = "item", name = "fixkit", label = "Kit de reparación", amount = 1, weight = 2}
			--		},
			--		{
			--			{type = "item", name = "meth_pooch", label = "Bolsa de meta", amount = 3, weight = 0.8},
			--			{type = "weapon", name = "WEAPON_CROWBAR", label = "palanca", amount = 1, weight = 0}
			--		}
			--	}
			--},
			--{
			--	name = "Suministros belicos",
			--	questItem = Config.john_pckg,
			--	questType = Config.pickup,
			--	description = "Ha llegado un pedido de armas que hice a los rusos, lo tiene un compi mio, esta en el poligono, en los callejones detras de ammunation, ve a buscarlo.",
			--	questStart = function()
			--		Citizen.CreateThread(function()
			--			
			--		end)	
			--	end,
			--	questInteraction = function()
			--		Citizen.CreateThread(function()
			--			TriggerServerEvent('esx_daily_quest:updateInteractionItem', Config.pickup, Config.john_pckg)
			--			SendNUIMessage({action = "showNotification", message = "Mision lista"})
			--		end)
			--	end,
			--	questEnd = function(possibleItems, money, level)
			--		Citizen.CreateThread(function()
			--			TriggerServerEvent('esx_daily_quest:giveQuestPayment', possibleItems, money, "john", level, Config.pickup, Config.john_pckg)
			--		end)
			--	end,
			--	money = 680,
			--	possibleItems = {
			--		{
			--			{type = "item", name = "lasagna", label = "Lasaña", amount = 3, weight = 0.9},
			--			{type = "item", name = "monster", label = "Monster", amount = 3, weight = 0.7}
			--		},
			--		{
			--			{type = "item", name = "hash", label = "Hachis", amount = 5, weight = 0.4},
			--			{type = "item", name = "monster", label = "Monster", amount = 2, weight = 0.7}
			--		},
			--		{
			--			{type = "item", name = "hash", label = "Hachis", amount = 7, weight = 0.4},
			--			{type = "item", name = "binoculars", label = "Prismaticos", amount = 1, weight = 1.8}
			--		}
			--	}
			--}
		--},
		timeBetweenQuests = 8,
		storeItems = {
			--{name = 'muelle', stockAmount = 8, label = "Muelle", price = 5, levelNeed = 1, type = "item", weight = 0.2},
			{name = 'guitareletric2', stockAmount = 1, label = "Guitarra Eléctrica Firmada", price = 3000, levelNeed = 5, type = "item", weight = 0.2},
			{name = 'guitareletric', stockAmount = 1, label = "Guitarra Eléctrica", price = 3000, levelNeed = 2, type = "item", weight = 0.2},
			{name = 'guitar', stockAmount = 2, label = "Guitarra clásica", price = 1500, levelNeed = 1, type = "item", weight = 0.2},
			{name = 'melodia_t', stockAmount = 1, label = "Partitura Melodía", price = 300, levelNeed = 1, type = "item", weight = 0.2},
			{name = 'bimbang', stockAmount = 2, label = "Partitura Bimbang (Anónimo)", price = 450, levelNeed = 2, type = "item", weight = 0.2},
			{name = 'bossa_nova', stockAmount = 2, label = "Partirura Bossa Nova", price = 600, levelNeed = 3, type = "item", weight = 0.2},
			{name = 'smoke_water', stockAmount = 2, label = "Partirura Smoke on the Water", price = 600, levelNeed = 5, type = "item", weight = 0.2},
		},
		interestItem = {
			name = "puar",
			label = "Púa firmada",
			description = "Una rara púa firmada por un gran artista olvidado",
			givenXP = 95,
			givenMoney = 225
		},
	}
}

Config.questNPC = {
	--john
	{
		--coords = vector3(18.52, 3689.70, 38.10),
		--heading = 197.75,
		coords = vector3(234.586, -894.421, 29.692),
		heading = 234.563,
		model = 'ig_old_man1a',
		animation = "PROP_HUMAN_SEAT_ARMCHAIR"
	},
	{
		--coords = vector3(281.37, 6781.53, 14.7),
		--heading = 294.94,
		coords = vector3(234.508, -896.379, 29.692),
		heading = 234.563,
		model = 'ig_nervousron',
		animation = "WORLD_HUMAN_STAND_IMPATIENT"
	},
	{
		--coords = vector3(892.35, -2172.83, 31.29),
		--heading = 146.53,
		coords = vector3(232.65, -897.526, 29.692),
		heading = 234.563,
		model = 'ig_joeminuteman',
		animation = "WORLD_HUMAN_STAND_IMPATIENT_CLUBHOUSE"
	},
	--daisy
	{
		--coords = vector3(139.26, -1708.02, 28.1),
		--heading = 222.35,
		coords = vector3(230.537, -900.857, 29.692),
		heading = 234.563,
		model = 'ig_denise',
		animation = "PROP_HUMAN_SEAT_CHAIR"
	},
	{
		--coords = vector3(2221.88, 5614.72, 53.9),
		--heading = 99.36,
		-- GARAJE CENTRAL coords = vector3(230.118, -901.844, 29.692),
		coords = vector3(1857.985, -81.365, 188.034),
		heading = 234.563,
		model = 'ig_lamardavis',
		animation = "WORLD_HUMAN_SMOKING_POT"
	},
	{
		--coords = vector3(86.63, -1963.81, 19.75),
		--heading = 227.01,
		coords = vector3(229.166, -903.322, 29.692),
		heading = 234.563,
		model = 'ig_claypain',
		animation = "WORLD_HUMAN_GUARD_STAND_CLUBHOUSE"
	},
	--charles
	{
		--coords = vector3(1112.67, -643.03, 55.35),
		--heading = 98.35,
		coords = vector3(226.485, -907.994, 29.692),
		heading = 234.562,
		model = 'ig_brad',
		animation = "WORLD_HUMAN_SEAT_WALL_TABLET"
	},
	{
		--coords = vector3(-951.66, 193.45, 66.39),
		--heading = 170.06,
		coords = vector3(225.129, -909.644, 29.692),
		heading = 229.583,
		model = 'u_m_m_fibarchitect',
		animation = "WORLD_HUMAN_GUARD_STAND_FACILITY"
	},
	{
		--coords = vector3(1275.66, -1710.13, 53.77),
		--heading = 136.93,
		coords = vector3(224.036, -911.366, 29.692),
		heading = 234.562,
		model = 'ig_lestercrest',
		animation = "WORLD_HUMAN_STAND_MOBILE_FACILITY"
	}
}


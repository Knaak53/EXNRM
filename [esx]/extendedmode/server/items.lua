-- Todo item debe registrarse aquí, al ser datops estaticos no es necesario que esten en la base de datos, esta tabla se cargará en la caché
items = {
    {
        name = "bread",
        label = "Pan",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop= "prop_breadbin_01"
    },
    {
        name = "cash",
        label = "Dinero",
        weight = 0.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "bkr_prop_money_unsorted_01"
    },
    {
        name = "water",
        label = "Agua",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_ld_flow_bottle"
    },
    {
        name = "bandage",
        label = "Bendas",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "xm_prop_x17_bag_med_01a"
    },
    {
        name = "workstool",
        label = "Herramientas mantenimiento",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_ind_cs_toolbox4"
    },
    {
        name = "pickaxe",
        label = "Pico",
        weight = 1.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_tool_pickaxe"
    },
    {
        name = "medikit",
        label = "Botiquín",
        weight = 1.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "xm_prop_smug_crate_s_medical"
    },
    {
        name = "gazbottle",
        label = "Botella de gas",
        weight = 2.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_ld_flow_bottle"
    },
    {
        name = "fixtool",
        label = "Herramientas reparación",
        weight = 2.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_tool_adjspanner"
    },
    {
        name = "carotool",
        label = "Herramientas carrocería",
        weight = 2.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_cs_wrench"
    },
    {
        name = "blowpipe",
        label = "Soplete",
        weight = 1.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_weld_torch"
    },
    {
        name = "fixkit",
        label = "Kit de reparación",
        weight = 2.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_tool_box_01"
    },
    {
        name = "carokit",
        label = "Kit de carrocería",
        weight = 2.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_tool_box_06"
    },
    {
        name = "cocacola",
        label = "Coca Cola",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_ecola_can"
    },
    {
        name = "fanta",
        label = "Fanta Naranja",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_orang_can_01"
    },
    {
        name = "sprite",
        label = "7up",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "v_res_tt_can03"
    },
    {
        name = "aquarius",
        label = "Aquarius",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_energy_drink"
    },
    {
        name = "monster",
        label = "Monster",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_battle_coconutdrink_01a"

    },
    {
        name = "cheesebows",
        label = "Palitos de queso",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_food_cb_nugets"
    },
    {
        name = "chips",
        label = "Lays",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_food_bs_chips"
    },
    {
        name = "snickers",
        label = "Snickers",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "v_ret_ml_sweet1"
    },
    {
        name = "oreo",
        label = "Oreo",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "v_ret_ml_sweet8"
    },
    {
        name = "pizza",
        label = "Pizza",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_pizza_box_02"
    },
    {
        name = "burger",
        label = "Hamburguesa",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_food_bs_burg3"
    },
    {
        name = "taco",
        label = "Taco mexicano",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_food_cb_bag_01"
    },
    {
        name = "kebab",
        label = "Kebab",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_food_cb_burg02"
    },
    {
        name = "lasagna",
        label = "Lasaña",
        weight = 0.9,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_food_burg3"
    },
    {
        name = "handcuffs",
        label = "Bridas",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_cs_cuffs_01"
    },
    {
        name = "factura",
        label = "Factura",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_cd_paper_pile1"
    },
    {
        name = "madera",
        label = "Madera comun",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "ng_proc_wood_01a"
    },
    {
        name = "maderaf",
        label = "Pino",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_fncwood_13c"
    },
    {
        name = "maderam",
        label = "Roble",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_fncwood_16f"
    },
    {
        name = "maderag",
        label = "Caoba",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_fncwood_16g"
    },
    {
        name = "stones",
        label = "Piedra",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_big_shit_02"
    },
    {
        name = "washedstones",
        label = "Piedra dragada",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_res_fa_stones01"
    },
    {
        name = "diamond",
        label = "Diamante",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "ch_prop_casino_diamonds_01b"
    },
    {
        name = "gold",
        label = "Oro",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_gold_bar"
    },
    {
        name = "iron",
        label = "Hierro",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_gold_bar"
    },
    {
        name = "copper",
        label = "Cobre",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_boxcar5_handle"
    },
    {
        name = "letter",
        label = "Carta",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cash_envelope_01"
    },
    {
        name = "colis",
        label = "Paquete",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_ind_meatboxsml"
    },
    {
        name = "paquete_sospechoso",
        label = "Paquete sospechoso",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
		prop = "xm_prop_x17_boxwood_01"
    },
    {
        name = "weed",
        label = "Marihuana",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_weed_bud_02b"
    },
    {
        name = "weed_pooch",
        label = "Chivato de Maria",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "bkr_prop_weed_smallbag_01a"
    },
    {
        name = "coke",
        label = "Hoja de coca",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_plant_cane_01a"
    },
    {
        name = "coke_pooch",
        label = "Pollo de coca",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "p_meth_bag_01_s"
    },
    {
        name = "meth",
        label = "Productos quimicos",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "v_med_bottles1"
    },
    {
        name = "meth_pooch",
        label = "Bolsa de meta",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "p_meth_bag_01_s"
    },
    {
        name = "binoculars",
        label = "Prismaticos",
        weight = 1.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_binoc_01"
    },
    {
        name = "bulletproof",
        label = "Chaleco Antibalas",
        weight = 4.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_armour_pickup"
    },
    {
        name = "smg_mag",
        label = "Cargador SMG",
        weight = 1.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "w_sb_smg_mag2"
    },
    {
        name = "radio_trans",
        label = "Trans. de radio",
        weight = 1.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "v_res_j_radio"
    },
    {
        name = "john_payment",
        label = "Sobre De John",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
        prop = "w_sb_smg_mag2"
    },
    {
        name = "john_pckg",
        label = "Armas de John",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
		prop = "ex_office_swag_guns04"
    },
    {
        name = "hash",
        label = "Hachis",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "bkr_prop_weed_bud_01a"
    },
    {
        name = "janette_meds",
        label = "Medicinas Ilegales",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
		prop = "v_med_bottles3"
    },
    {
        name = "daisy_weed",
        label = "Maria de Daisy",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
		prop = "bkr_prop_weed_smallbag_01a"
    },
    {
        name = "steal_phone",
        label = "Telefono Robado",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_phone_proto"
    },
    {
        name = "steal_radio",
        label = "Radio robada",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "v_res_fa_radioalrm"
    },
    {
        name = "weed_card",
        label = "Tarjeta Marihuana",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "p_ld_id_card_002"
    },
    {
        name = "daisy_angel",
        label = "Polvo de Angel",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
		prop = "p_meth_bag_01_s"
    },
    {
        name = "old_hardware",
        label = "Hardware viejo",
        weight = 0.9,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_card_hack_01a"
    },
    {
        name = "meds_box",
        label = "Cajas de Farmacos",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "ex_office_swag_pills2"
    },
    {
        name = "morphine",
        label = "Morfina",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_syringe_01"
    },
    {
        name = "adrenaline_shot",
        label = "Adrenalina",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_syringe_01"
    },
    {
        name = "rifle_mag",
        label = "Cargador Rifle",
        weight = 1.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "w_ar_bullpupriflemk2_mag1"
    },
    {
        name = "pedo_hdd",
        label = "Pederastia",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
        prop = "xm_prop_x17_harddisk_01a"
    },
    {
        name = "bullet_shell",
        label = "Casquillos .45",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "w_pi_singleshoth4_shell"
    },
    {
        name = "hdd",
        label = "Disco duro",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "xm_prop_x17_harddisk_01a"
    },
    {
        name = "usb",
        label = "USB",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "hei_prop_hst_usb_drive"
    },
    {
        name = "usb_hack",
        label = "USB Hacking",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "hei_prop_hst_usb_drive"
    },
    {
        name = "ram",
        label = "Memoria ram",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_card_hack_01a"
    },
    {
        name = "psu",
        label = "PSU",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_card_hack_01a"
    },
    {
        name = "motherboard",
        label = "Placa Base",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_card_hack_01a"
    },
    {
        name = "wires",
        label = "Cables",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_dj_wires_01a"
    },
    {
        name = "gpu",
        label = "T. Grafica",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_card_hack_01a"
    },
    {
        name = "audio_card",
        label = "T. Audio",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "h4_prop_h4_card_hack_01a"
    },
    {
        name = "gunpowder",
        label = "Polvora",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "bkr_prop_coke_powderbottle_01"
    },
    {
        name = "grip",
        label = "Empuñadura",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "w_at_afgrip_2"
    },
    {
        name = "flashlight",
        label = "Linterna",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "w_me_flashlight"
    },
    {
        name = "suppressor",
        label = "Silenciador",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "sr_prop_spec_tube_m_05a"
    },
    {
        name = "human_heart",
        label = "Corazon Humano",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
		prop = "xm_prop_smug_crate_s_medical"	
    },
    {
        name = "ledgers",
        label = "Ledger Nano S",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "hei_prop_hst_usb_drive"
    },
    {
        name = "ledgerx",
        label = "Ledger Nano X",
        weight = 1.0,
        rare = 0,
        limit = -1,
        canRemove = 0,
		prop = "hei_prop_hst_usb_drive"
    },
    {
        name = "correo_ajeno",
        label = "Correo ajeno",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_cashenvelope"
    },
    {
        name = "computer_case",
        label = "Caja pc",
        weight = 1.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_pc_02a"
    },
    {
        name = "sg_mag",
        label = "Cartuchos Escopeta",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_box_ammo07b"
    },
    {
        name = "herradura",
        label = "Herradura",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "h4_prop_h4_gold_coin_01a"
    },
    {
        name = "piezas",
        label = "Piezas sueltas",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "imp_prop_impexp_exhaust_03"
    },
    {
        name = "muelle",
        label = "Muelle",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_meth_pipe"
    },
    {
        name = "carbat",
        label = "Bateria de coche",
        weight = 2.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_car_battery_01"
    },
    {
        name = "toycar",
        label = "Coche de juguete",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "xs_prop_trophy_goldbag_01a"
    },
    {
        name = "pipe",
        label = "Tuberia",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_roofpipe_02"
    },
    {
        name = "tpipe",
        label = "Tuberia en T",
        weight = 0.3,
        rare = 1,
        limit = -1,
        canRemove = 1,
		prop = "prop_roofpipe_01"
		
    },
    {
        name = "grifo",
        label = "Grifo",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_ilev_mm_faucet"
    },
    {
        name = "valve",
        label = "Valvula",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_oil_valve_01"
    },
    {
        name = "copperpipe",
        label = "Tuberia de cobre",
        weight = 1.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_pipes_03b"
    },
    {
        name = "maneta",
        label = "Maneta",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_car_ignition"
    },
    {
        name = "candado",
        label = "Candado",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_padlock"
    },
    {
        name = "tornillos",
        label = "Tornillos",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "imp_prop_impexp_sdriver_01"
    },
    {
        name = "microwave",
        label = "Microhondas",
        weight = 3.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_microwave_1"
    },
    {
        name = "dvd",
        label = "Reproductor DVD",
        weight = 1.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_dvd"
    },
    {
        name = "batidora",
        label = "Batidora",
        weight = 0.9,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_kitch_juicer"
    },
    {
        name = "filter",
        label = "Filtro",
        weight = 0.6,
        rare = 0,
        limit = -1,
        canRemove = 1
    },
    {
        name = "computer",
        label = "Ordenador",
        weight = 3.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_pc_02a"
    },
    {
        name = "mouse",
        label = "Raton",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
        prop = "prop_mouse_01b"
    },
    {
        name = "keyboard",
        label = "Teclado",
        weight = 0.8,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_keyboard_01"
    },
    {
        name = "rotten_apple",
        label = "Manzana podrida",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "ng_proc_food_aple1a"
    },
    {
        name = "yogur",
        label = "Yogur caducado",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "p_amb_coffeecup_01"
    },
    {
        name = "spoil_meat",
        label = "Carne podrida",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_brain_chunk"
    },
    {
        name = "potato",
        label = "Patata pocha",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_food_chips"
    },
    {
        name = "rotten_bread",
        label = "Pan mohoso",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_res_fa_bread03"
		
    },
    {
        name = "bombon",
        label = "Bombon mordido",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_choc_meto"
		
    },
    {
        name = "bitten_donut",
        label = "Donut mordido",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_donut_02b"
    },
    {
        name = "bitten_cookie",
        label = "Galleta mordida",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_choc_ego"
    },
    {
        name = "used_condom",
        label = "Condon usado",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "bkr_prop_weed_bag_01a"
    },
    {
        name = "diaper",
        label = "Pañal sucio",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_food_bs_burg1"
    },
    {
        name = "wet_paper",
        label = "Papel mojado",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "ng_proc_paper_03a"
    },
    {
        name = "cleanex",
        label = "Pañuelo usado",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "h4_prop_h4_powdercleaner_01a"
    },
    {
        name = "old_book",
        label = "Libro viejo",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_ret_ta_book3"
    },
    {
        name = "jeringuilla",
        label = "Jeringuilla",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_syringe_01"
    },
    {
        name = "used_water",
        label = "Agua a medias",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "ba_prop_club_water_bottle"
    },
    {
        name = "used_razor",
        label = "Maquinilla usada",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_disp_razor_01"
    },
    {
        name = "used_spray",
        label = "Spray vacio",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_spray_can"
    },
    {
        name = "tijeras",
        label = "Tijeras oxidadas",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "p_cs_scissors_s"
    },
    {
        name = "empty_y",
        label = "Yogur vacio",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "p_amb_coffeecup_01"
    },
    {
        name = "empty_e",
        label = "Carton de huevos",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_ret_247_eggs"
    },
    {
        name = "empty_c",
        label = "Lata vacia",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "ng_proc_sodacan_01b"
    },
    {
        name = "smash_can",
        label = "Latas aplastadas",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_res_tt_cancrsh02"
    },
    {
        name = "cigarette_butt",
        label = "Colillas",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_ret_ml_cigs6"
    },
    {
        name = "verdura_pocha",
        label = "Verduras pochas",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "ng_proc_food_ornge1a"
    },
    {
        name = "tea_bag",
        label = "Bolsita de Te",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "bkr_prop_weed_smallbag_01a"
    },
    {
        name = "empty_t",
        label = "Tabaco vacio",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "p_cigar_pack_02_s"
    },
    {
        name = "corcho",
        label = "Corcho",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_ceramic_jug_cork"
    },
    {
        name = "meth_card",
        label = "Tarjeta de Meta",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_credit_card"
    },
    {
        name = "coke_card",
        label = "Tarjeta Cocaina",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_credit_card"
    },
    {
        name = "vodka",
        label = "Vodka",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop ="prop_vodka_bottle"
    },
    {
        name = "whisky",
        label = "Whisky",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "heineken",
        label = "Heineken",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop ="ng_proc_beerbottle_01a"
    },
    {
        name = "tequila",
        label = "Tequila",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_tequila_bottle"
    },
    {
        name = "rum",
        label = "Ron",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_rum_bottle"
    },
    {
        name = "donut_w",
        label = "Donut C. Blanco",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_amb_donut"
    },
    {
        name = "donut_b",
        label = "Donut de Chocolate",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_donut_02"
    },
    {
        name = "donut",
        label = "Donut",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_donut_01"
    },
    {
        name = "berlina_c",
        label = "Berlina Crema",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_donut_01"
    },
    {
        name = "berlina_b",
        label = "Berlina Chocolate",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_donut_02"
    },
    {
        name = "apple",
        label = "Manzana",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_paper_bag_01"
    },
    {
        name = "banana",
        label = "Platano",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_paper_bag_01"
    },
    {
        name = "mango",
        label = "Mango",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_paper_bag_01"
    },
    {
        name = "orange",
        label = "Naranja",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_paper_bag_01"
    },
    {
        name = "peach",
        label = "Melocoton",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_paper_bag_01"
    },
    {
        name = "vodka_bathory",
        label = "Vodka Bathory",
        weight = 0.7,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_vodka_bottle"
    },
    {
        name = "shop_code",
        label = "Clave de seguridad",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "h4_prop_h4_codes_01a"
    },
    {
        name = "smoothie_o",
        label = "Smoothie",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "smoothie_r",
        label = "Smoothie",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "smoothie_g",
        label = "Smoothie",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "smoothie_y",
        label = "Smoothie",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "smoothie_b",
        label = "Smoothie",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "nestea",
        label = "Nestea",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_energy_drink"
    },
    {
        name = "pepsi",
        label = "Pepsi",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_ecola_can"
    },
    {
        name = "caramelos",
        label = "Caramelos",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_candy_pqs"
    },
    {
        name = "twix",
        label = "Twix",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_choc_meto"
    },
    {
        name = "kitkat",
        label = "Kit Kat",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_choc_meto"
    },
    {
        name = "chetos",
        label = "Chetos",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_ld_snack_01"
    },
    {
        name = "potatostick",
        label = "Patatas fritas",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_ld_snack_01"
    },
    {
        name = "haribo",
        label = "Ositos Haribo",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_candy_pqs"
    },
    {
        name = "solo",
        label = "Cafe Solo",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_club_vu_coffeecup"
    },
    {
        name = "cortado",
        label = "Cortado",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "v_club_vu_coffeecup"
    },
    {
        name = "cafeleche",
        label = "Cafe con leche",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_fib_coffee"
    },
    {
        name = "capuccino",
        label = "Capuccino",
        weight = 0.3,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_fib_coffee"
    },
    {
        name = "americano",
        label = "Cafe Americano",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_fib_coffee"
    },
    {
        name = "chocolate",
        label = "Chocolate",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_choc_meto"
    },
    {
        name = "chocoleche",
        label = "C. con leche",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_choc_ego"
    },
    {
        name = "gum_r",
        label = "Chicle Rojo",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_candy_pqs"
    },
    {
        name = "gum_g",
        label = "Chicle Verde",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_candy_pqs"
    },
    {
        name = "gum_b",
        label = "Chicle Azul",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_candy_pqs"
    },
    {
        name = "gum_o",
        label = "Chicle Naranja",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_golf_ball_p3"
    },
    {
        name = "gum_y",
        label = "Chicle Amarillo",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_golf_ball_p2"
    },
    {
        name = "gum_p",
        label = "Chicle Rosa",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_golf_ball_p4"
    },
    {
        name = "powerade",
        label = "Powerade",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_energy_drink"
    },
    {
        name = "shake_vase",
        label = "Vaso Mezclador",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_bar_cockshaker"
    },
    {
        name = "shake_r",
        label = "Proteinas Fresa",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "shake_c",
        label = "Proteinas Choco",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "shake_b",
        label = "Proteinas Platano",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "protein_shaker",
        label = "Batido de Fresa",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "protein_shakec",
        label = "Batido de Choco",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "protein_shakeb",
        label = "Batido de Platano",
        weight = 0.4,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_wheat_grass_glass"
    },
    {
        name = "energy_bar",
        label = "Barrita energetica",
        weight = 0.2,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_choc_meto"
    },
    {
        name = "weed_block",
        label = "Fardo De Maria",
        weight = 3.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "hei_prop_heist_weed_block_01b"
    },
    {
        name = "weed_bag",
        label = "Bolsita vacia",
        weight = 0.0,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "bkr_prop_weed_bag_01a"
    },
    {
        name = "weed_weight",
        label = "Bascula de Maria",
        weight = 0.5,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "bkr_prop_weed_scales_01a"
    },
    {
        name = "weed_green",
        label = "Maria Verde",
        weight = 0.1,
        rare = 0,
        limit = -1,
        canRemove = 1,
		prop = "prop_weed_bottle"
    },
    {
        name = 'phone',
        label = "Teléfono",
        weight = 0.200,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_amb_phone"
    },
    {
        name = 'guitar',
        label = "Guitarra Clásica",
        weight = 2.0,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_acc_guitar_01"
    },
    {
        name = 'guitarelectric',
        label = "Guitarra Eléctrica",
        weight = 1.0,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_el_guitar_03"
    },
    {
        name = 'guitarelectric2',
        label = "Guitarra Eléctrica",
        weight = 1.5,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_el_guitar_01"
    },
    {
        name = 'puar',
        label = "Púa Firmada",
        weight = 0.2,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "hw1_02_canopiesb_02"
    },
    {
        name = 'pua',
        label = "Púa de guitarra",
        weight = 0.2,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "hw1_02_canopiesb_02"
    },
	-------------------------------PARTITURAS-----------------------------------
	{
        name = 'smoke_water',
        label = "Smoke on the water",
        weight = 0.2,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_a4_sheet_01"
    },
    {
        name = 'melodia_t',
        label = "Melodía triste",
        weight = 0.2,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_a4_sheet_01"
    },
    {
        name = 'bimbang',
        label = "Bimbang (Anónimo)",
        weight = 0.2,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_a4_sheet_01"
    },
    {
        name = 'bossa_nova',
        label = "Bossa nova",
        weight = 0.2,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_a4_sheet_01"
	},
}

--[[{
        name = "example",
        label = "Example",
        weight = 2,
        rare = -1,
        limit = 1,
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "papers",
        label = "Paquete de Papelillos",
        weight = 10,
        rare = -1,
        limit = 10,
        canRemove = 1,
        prop = "prop_paper_box_01" -- le pega xD
    },
    {
        name = "joint",
        label = "Porro",
        weight = 2,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "lsd",
        label = "LSD",
        weight = 20,
        rare = -1,
        limit = 10,
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "medikit",
        label = "Kit RCP",
        weight = 2000,
        rare = -1,
        limit = 5,
        canRemove = 1,
        prop = "xm_prop_smug_crate_s_medical"
    },
    {
        name = "bandage",
        label = "Vendaje",
        weight = 200,
        rare = -1,
        limit = 10,
        canRemove = 1,
        prop = "xm_prop_x17_bag_med_01a"
    },
    {
        name = "beer",
        label = "Cerveza",
        weight = 500,
        rare = -1,
        limit = 8,
        canRemove = 1,
        prop = "prop_amb_beer_bottle"
    },
    {
        name = "bread",
        label = "Pan soso",
        weight = 650,
        rare = -1,
        limit = 6,
        canRemove = 1,
        prop = "prop_breadbin_01"
    },
    {
        name = "water",
        label = "Botella de agua",
        weight = 500,
        rare = -1,
        limit = 10,
        canRemove = 1,
        prop = "prop_ld_flow_bottle"
    },
    {
        name = "trash",
        label = "Basura",
        weight = 500,
        rare = -1,
        limit = 10,
        canRemove = 1,
        prop = "prop_ld_scrap"
    },
    {
        name = "gazbottle",
        label = "Bote de gas",
        weight = 500,
        rare = -1,
        limit = 6,
        canRemove = 1,
        prop = "prop_ld_flow_bottle"
    },
    {
        name = "fixtool",
        label = "Herramientas de reparación",
        weight = 800,
        rare = -1,
        limit = 6,
        canRemove = 1,
        prop = "prop_tool_adjspanner"
    },
    {
        name = "carotool",
        label = "Herramientas para carrocería",
        weight = 2500,
        rare = -1,
        limit = 4,
        canRemove = 1,
        prop = "prop_cs_wrench"
    },
    {
        name = "blowpipe",
        label = "Soplete",
        weight = 600,
        rare = -1,
        limit = 4,
        canRemove = 1,
        prop = "prop_weld_torch"
    },
    {
        name = "fixkit",
        label = "Kit de Reparación de motor",
        weight = 500,
        rare = -1,
        limit = 3,
        canRemove = 1,
        prop = "prop_tool_box_01"
    },
    {
        name = "carokit",
        label = "Kit de Reparación de carrocería",
        weight = 3000,
        rare = -1,
        limit = 2,
        canRemove = 1,
        prop = "prop_tool_box_06"
    },
    {
        name = "alive_chicken",
        label = "Pollo enjaulado",
        weight = 1000,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_int_cf_chick_01"
    },
    {
        name = "slaughtered_chicken",
        label = "Pollo muerto",
        weight = 1000,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_int_cf_chick_01"
    },
    {
        name = "packaged_chicken",
        label = "Pollo empaquetado",
        weight = 1000,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_int_cf_chick_01"
    },
    {
        name = "fish",
        label = "Pescado",
        weight = 500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_fish_slice_01"
    },
    {
        name = "stone",
        label = "Piedra",
        weight = 1000,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "proc_mntn_stone01"
    },
    {
        name = "washed_stone",
        label = "Piedra lavada",
        weight = 1000,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_ld_rubble_02"
    },
    {
        name = "copper",
        label = "Cobre",
        weight = 500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "iron",
        label = "Metal",
        weight = 500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "ex_office_swag_silver"
    },
    {
        name = "gold",
        label = "Oro",
        weight = 500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "diamond",
        label = "Diamante",
        weight = 500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "wood",
        label = "Madera",
        weight = 1500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_fncwood_13c"
    },
    {
        name = "cutted_wood",
        label = "Madera cortada",
        weight = 1500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_fncwood_16d"
    },
    {
        name = "packaged_plank",
        label = "Tablón de madera",
        weight = 1500,
        rare = -1,
        limit = -1,
        canRemove = 1,
        prop = "prop_fncwood_16c"
    },
    {
        name = "petrol",
        label = "Petroleo",
        weight = 0,
        rare = -1,
        limit = 500, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_petrol_can"
    },
    {
        name = "petrol_raffin",
        label = "Petroleo destilado",
        weight = 0,
        rare = -1,
        limit = 500, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_petrol_can"
    },
    {
        name = "essence",
        label = "Petróleo refinado",
        weight = 0,
        rare = -1,
        limit = 500, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_petrol_can"
    },
    {
        name = "wool",
        label = "Lana",
        weight = 500,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "ng_proc_paper_01a"
    },
    {
        name = "fabric",
        label = "Tela",
        weight = 500,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "p_shower_towel_s"
    },
    {
        name = "clothe",
        label = "Ropa",
        weight = 500,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "p_overalls_02_s"
    },
    {
        name = "jager",
        label = "Jägermeister",
        weight = 300,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "vodka",
        label = "Vodka",
        weight = 350,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "rhum",
        label = "Ron",
        weight = 300,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "whisky",
        label = "Whisky",
        weight = 300,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "tequila",
        label = "Tequila",
        weight = 300,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "martini",
        label = "Martini",
        weight = 180,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_amb_beer_bottle"
    },
    {
        name = "soda",
        label = "Soda",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_amb_beer_bottle"
    },
    {
        name = "jusfruit",
        label = "Zumo de fruta",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_food_bs_juice01"
    },
    {
        name = "icetea",
        label = "Té helado",
        weight = 175,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "energy",
        label = "Energy",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_paper_box_01"
    },
    {
        name = "drpepper",
        label = "Dr.Pepper",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_food_juice02"
    },
    {
        name = "limonade",
        label = "Limonada",
        weight = 100,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_food_bs_juice02"
    },
    {
        name = "bolcacahuetes",
        label = "Bol de cacahuetes",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_bar_nuts"
    },
    {
        name = "bolnoixcajou",
        label = "Bol de anacardos",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_bar_nuts"
    },
    {
        name = "bolpistache",
        label = "Bol de pistachos",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_bar_nuts"
    },
    {
        name = "bolchips",
        label = "Bol de patatas",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_food_cb_chips"
    },
    {
        name = "saucisson",
        label = "Salchichas",
        weight = 250,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_hotdog_01"
    },
    {
        name = "grapperaisin",
        label = "Racimo de uvas",
        weight = 200,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_bush_grape_01"
    },
    {
        name = "jagerbomb",
        label = "Jagger Bomb",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "golem",
        label = "Golem",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "whiskycoca",
        label = "Whisky con cocacola",
        weight = 200,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "vodkaenergy",
        label = "Vodka con energetica",
        weight = 195,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "vodkafruit",
        label = "Vodka con zumo de frutas",
        weight = 175,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "rhumfruit",
        label = "Ron con zumo de frutas",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "teqpaf",
        label = "Tequila con limon",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "rhumcoca",
        label = "Ron con CocaCola",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "mojito",
        label = "Mojito",
        weight = 250,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "mixapero",
        label = "Mixapero",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_ld_snack_01"
    },
    {
        name = "metreshooter",
        label = "Chupito",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "jagercerbere",
        label = "Jagger con cerveza",
        weight = 250,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_whiskey_bottle"
    },
    {
        name = "menthe",
        label = "Hoja de menta",
        weight = 25,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "p_cs_leaf_s"
    },
    {
        name = "ice",
        label = "Hielo",
        weight = 50,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_bar_ice_01"
    },
    {
        name = 'smg_clip',
        label = "Cargador de subfusil",
        weight = 225,
        rare = -1,
        limit = 10, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_box_ammo01a"
    },
    {
        name = 'pistol_clip',
        label = "Cargador de pistola",
        weight = 100,
        rare = -1,
        limit = 15, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_box_ammo01a"
    },
    {
        name = 'shotgun_clip',
        label = "Cargador de escopeta",
        weight = 400,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_box_ammo01a"
    },
    {
        name = 'rifle_clip',
        label = "Cargador de rifle",
        weight = 250,
        rare = -1,
        limit = 8, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_box_ammo01a"
    },
    {
        name = 'mg_clip',
        label = "Cargador de ametralladoras",
        weight = 500,
        rare = -1,
        limit = 8, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_box_ammo01a"
    },
    {
        name = 'sniper_clip',
        label = "Cargador de francotirador",
        weight = 200,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_box_ammo01a"
    },
    {
        name = 'lockpick',
        label = "Ganzúa",
        weight = 150,
        rare = -1,
        limit = 5, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_jailer_keys_01a"
    },
    {
        name = 'jewels',
        label = "Joyas",
        weight = 200,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "p_jewel_necklace01_s"
    },
    {
        name = 'id_card',
        label = "Tarjeta I.D.",
        weight = 200,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "p_ld_id_card_01"
    },
    {
        name = 'thermal_charge',
        label = "Carga termita",
        weight = 500,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "hei_prop_heist_thermite"
    },
    {
        name = 'laptop_h',
        label = "Portátil Kali Linux ",
        weight = 2000,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "hei_prop_hst_laptop"
    },
    {
        name = 'gold_bar',
        label = "Barra de oro",
        weight = 1000,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "hei_prop_heist_gold_bar"
    },
    {
        name = 'dia_box',
        label = "Caja de diamantes",
        weight = 250,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "apa_mp_h_acc_box_trinket_01"
    },
    {
        name = 'weed',
        label = "Marihuana",
        weight = 250,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_weed_bigbag_open_01a"
    },
    {
        name = 'weed_pouch',
        label = "Bolsita de Marihuana",
        weight = 50,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_weed_bag_01a"
    },
    {
        name = 'coke',
        label = "Cocaína",
        weight = 200,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_coke_cutblock_01"
    },
    {
        name = 'coke_pouch',
        label = "Chute de Coca",
        weight = 40,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_coke_painkiller_01a"
    },
    {
        name = 'meth',
        label = "Metanfetamina",
        weight = 250,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_meth_smallbag_01a"
    },
    {
        name = 'meth_pouch',
        label = "Bolsita de Meta",
        weight = 50,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_meth_bag_01"
    },
    {
        name = 'seed_weed',
        label = "Semilla de Marihuana",
        weight = 25,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_weed_leaf_01a"
    },
    {
        name = 'macetero',
        label = "Macetero",
        weight = 5000,
        rare = -1,
        limit = 1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_pot_plant_01d"
    },
    {
        name = 'bolsita',
        label = "Bolsita de plástico",
        weight = 25,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "bkr_prop_weed_bag_01a"
    },
    {
        name = 'radio',
        label = "Walkie",
        weight = 200,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_cs_hand_radio"
    },
    {
        name = 'bulletproof',
        label = "Chaleco antibalas",
        weight = 2000,
        rare = -1,
        limit = -1, --Lo dejo asi para el tema de los litros porque en si no se lleva encima
        canRemove = 1,
        prop = "prop_armour_pickup"
    }
} 
]]

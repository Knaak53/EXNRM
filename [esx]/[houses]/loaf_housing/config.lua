-- Translations for the text are at the bottom of this file.

Config = {
    SellPercentage = 75, -- percentage of original price you should get back when selling a house.
    AddHouseBlips = true, -- add all available houses to the map?
    AddBoughtHouses = false, -- add blips for houses bought by other people?
    EnableGarage = true, -- requires my (Loaf) garage script. Costs $10
    Use3DText = true, -- use 3d text instead of the normal top-left corner info box? Used for "press e" etc.
    IKEABlip = {
        ['Enabled'] = true,
        ['Name'] = "IKEA",
        ['Sprite'] = 357,
        ['Colour'] = 0,
        ['Scale'] = 0.75
    },
    
    Props = { -- don't mess around with this if you don't know to 110% what you're doing
        ['trevor'] = `shell_trevor`,
        ['nice'] = `shell_v16mid`,
        ['lester'] = `shell_lester`,
        ['mansion'] = `shell_ranch`,
        ['trailer'] = `shell_trailer`,
        ['kinda_nice'] = `shell_v16low`,
        ['highend'] = `shell_highend`,
        ['highendv2'] = `shell_highendv2`,
        ['michael'] = `shell_michael`,
        ['warehouse1'] = `shell_warehouse1`,
        ['warehouse2'] = `shell_warehouse2`,
        ['warehouse3'] = `shell_warehouse3`
    },

    Furniture = { 
        ['Categories'] = {
            {'table', 'Mesas'}, ----ok
            {'chair', 'Sillas'}, ----ok
            {'sofa', 'Sofas'}, ----ok
            {'bed', 'Camas'}, ----ok
            {'Storage', 'Mobiliario'},----ok
            {'kitchen', 'Electrodomesticos'},
            {'kitchenacc', 'Accesorios cocina'},----ok
            {'FoodandDrinks','Comida y bebida'},
            {'bathroom', 'Baño'},
            {'office', 'Oficina'},
            {'lights', 'Iluminacion'},
            {'tv', 'TV'},----ok
            {'tel', 'Telefonia y accesorios'}, ----ok
            {'Caveman', 'Sala de ocio'},  ----ok         
            {'electronics', 'Electronica'},----ok
            {'Vest', 'Vestidor'},
            {'Gym', 'Gimnasio'},----ok
            {'garage', 'Garaje/taller'},----ok

            {'decorations', 'Decoracion'},           
            {'Plants', 'Plantas'},
            {'CashGoldJewels', 'Joyeria'},
            {'Drugs', 'Drogas'},           
            {'accessory', 'Accesorios'}, 
            {'popurri', 'Popurri pa organizar'}
           -- {'structure', 'Puertas y estructuras'}                    
            

        },

        ['chair'] = {
            ---------madera-----
            {'Silla madera vieja', 'prop_rock_chair_01', 25},
            {'Silla madera vieja 2', 'prop_torture_ch_01', 25},
            {'Silla pino', 'prop_table_02_chr', 50},
            {'Silla madera', 'prop_clown_chair', 55},
            {'Silla madera 2', 'prop_chair_07', 60},
            {'Silla madera 3', 'prop_table_01_chr_a', 60},
            {'Silla madera 4', 'prop_table_01_chr_b', 60},
            {'Silla madera 5', 'prop_table_02_chr', 60},
            {'Silla madera lujosa', 'p_dinechair_01_s', 150},
            -------plastico----
            {'Silla plegable', 'prop_cs_folding_chair_01', 20},
            {'Silla plastico', 'prop_chair_08', 20},
            {'Silla plastico 2', 'prop_table_03b_chr', 20},
            {'Silla plastico 3', 'prop_table_03_chr', 25},
            {'Silla platico vieja', 'prop_gc_chair02', 25},
            {'Silla Plastico azul', 'v_ilev_chair02_ped', 30},
            ----------oficina----
            {'Silla oficina sucia', 'prop_off_chair_04', 25},            
            {'Silla oficina sucia 2', 'prop_off_chair_03', 25},
            {'Silla oficina sucia 3', 'v_corp_cd_chair', 25},
            {'Silla oficina', 'prop_off_chair_04_s', 50},
            {'Silla oficina alta', 'v_corp_bk_chair3', 80},
            {'Silla oficina cuero', 'p_clb_officechair_s', 100},
            {'Silla oficina moderna', 'prop_off_chair_01', 110},                  
            {'Silla oficina moderna 2', 'v_corp_offchair', 110},          
            {'Silla oficina lujosa', 'p_soloffchair_s', 200},
            -------------jardin-------------
            {'Silla jardin plegable', 'prop_ven_market_stool', 20},
            {'Silla jardin', 'prop_chair_09', 40},
            {'Silla jardin 2', 'prop_chair_03', 50},
            {'Silla jardin 3', 'prop_chair_02', 50},
            {'Silla jardin 4', 'prop_chair_01b', 50},
            {'Silla jardin 5', 'prop_table_04_chr', 60},
            {'Silla jardin 6', 'prop_table_05_chr', 60},
            {'Silla jardin comoda', 'prop_table_06_chr', 70},
            {'Silla jardin lujosa', 'prop_chateau_chair_01', 100},
            --------------cocina-----
            {'Silla cocina vieja', 'prop_chair_06', 25},
            {'Silla cocina', 'prop_off_chair_05', 35},
            {'Silla cocina moderna', 'prop_chair_04a', 50},
            {'Silla cocina moderna 2', 'prop_chair_04b', 50},
            {'Banqueta de cocina', 'v_ilev_fh_kitchenstool', 100},
            ------varios----              
            {'Silla cuero', 'prop_cs_office_chair', 40},           
            {'Silla cineasta', 'prop_direct_chair_01', 50},
            {'Silla camping', 'prop_skid_chair_03', 20},
            {'Chair camping 2', 'prop_skid_chair_01', 20},
            {'Chair camping 3', 'prop_skid_chair_02', 20},
            {'Taburete', 'prop_bar_stool_01', 30},
            {'Banco de madera', 'prop_table_08_chr', 40}        
        },
        ['decorations'] = {
            {'Botella', 'apa_mp_h_acc_bottle_01', 15},
            {'velas', 'apa_mp_h_acc_candles_01', 15},
            {'espejo pequeño', 'p_int_jewel_mirror', 15},
            {'Plato decorativo', 'apa_mp_h_acc_dec_plate_01', 15},
            {'Vasija', 'apa_mp_h_acc_vase_01', 30},                   
            {'Cenicero', 'ex_prop_ashtray_luxe_02', 5},
            {'Periodico', 'p_cs_newspaper_s', 5},
            {'Panfleto', 'p_cs_pamphlet_01_s', 5},           
            {'Oso de peluche', 'prop_mr_rasberryclean', 20},          
            {'Pizarra', 'p_planning_board_04', 20},
            {'Reloj de pared EE.UU', 'prop_v_15_cars_clock', 20},
            {'Reloj clasico pared', 'prop_game_clock_01', 20},
            {'Reloj negro pared', 'prop_game_clock_02', 20},     
            {'Reloj grande huevo', 'prop_egg_clock_01', 50},
            {'Reloj de pared grande', 'prop_v_5_bclock', 100},
            {'Reloj moderno', 'prop_big_clock_01', 150},
            {'Reloj gigante', 'prop_hotel_clock_01', 200},
            {'Cuadro', 'v_ilev_ra_doorsafe', 20}
            --------PARA MOVER-----
            ---{'Bong', 'prop_bong_01', 100},-----------------mover a acessorios droga
            ---{'organizador escritorio', 'v_res_desktidy', 10},-----------mover a accesorios oficina   
            --{'Laz', 'p_laz_j02_s', 300}------baqueros tirados----------
        },
        ['table'] = {  --------OK-------           
            {'Mesa sucia', 'prop_ld_farm_table02', 50},
            {'Mesa sucia 2', 'prop_ld_farm_table01', 50},
            {'Mesa madera vieja', 'prop_table_08', 50},  
            {'Mesa plegable vieja', 'prop_rub_table_01', 20},
            {'Mesa pleglabe vieja doble', 'prop_rub_table_02', 30},
            {'Mesa plegable blanca', 'prop_ven_market_table1', 40},
            {'Mesa plastico sucia', 'prop_table_03b', 30},
            {'Mesa blanca plastico', 'prop_table_03b_cs', 40},
            {'Mesa plastico blanca', 'prop_table_03', 50},
            {'Mesa auxiliar madera', 'prop_patio_lounger1_table', 40},
            {'Mesa cafe', 'v_res_fh_coftableb', 50},
            {'Mesa cafe 2', 'v_res_fh_coftablea', 50},
            {'Mesa cafe madera', 'prop_fbi3_coffee_table', 60},
            {'Mesa cafe grande', 'prop_table_01', 60},
            {'Mesa cafe baja', 'prop_tablesmall_01', 60},
            {'Mesa cafe cristal', 'prop_t_coffe_table', 80},
            {'Mesa cafe cristal 2', 'prop_t_coffe_table_02', 80},
            {'Mesa metalica pequeña', 'prop_table_07', 50},
            {'Mesa negra', 'v_ilev_liconftable_sml', 150},          
            {'Mesita rattan', 'hei_prop_yah_table_01', 40},
            {'Mesa cafe rattan', 'hei_prop_yah_table_02', 50},
            {'Mesa comedor rattan', 'hei_prop_yah_table_03', 100},           
            {'Mesa redonda jardin', 'prop_chateau_table_01', 100},
            {'Mesa jardin madera', 'prop_table_02', 100},
            {'Mesa jardin', 'prop_table_04', 100},
            {'Mesa mimbre jardin', 'prop_table_05', 100},
            {'Mesa piedra jardin', 'prop_table_06', 150},           
            {'Banco picnic', 'prop_picnictable_01', 50},
            {'Mesa madera redonda', 'prop_proxy_chateau_table', 60}
            -----mesas de publicidad y venta              
            ---{'Table 28', 'prop_astro_table_02', 150},
            ---{'Table 29', 'prop_astro_table_01', 150}
            ---{'Tri table', 'prop_tri_table_01', 300},
            ---{'Protest table', 'prop_protest_table_01', 300},             
        },
        ['Vest'] = {
            {'Expositor blanco', 'prop_venice_counter_01', 100},
            {'Expositor blanco esquina', 'prop_venice_counter_03', 100},
            {'Camiseta blanca', 'prop_t_shirt_ironing', 50},
            {'Camisetas para armario', 'prop_t_shirt_row_01', 50},
            {'Estante de camisetas', 'prop_tshirt_shelf_1', 100},
            {'Estante grande de camisetas', 'prop_tshirt_shelf_2a', 100},
            {'Gorra', 'prop_cap_01', 50},
            {'Gorras', 'prop_cap_row_01', 100},
            {'Tacon negro', 'prop_cs_amanda_shoe', 50},
            {'Tanga rosa', 'prop_cs_panties', 50},
            {'Camisa en percha', 'prop_cs_shirt_01', 50},
            {'Gafas de sol', 'prop_cs_sol_glasses', 50},
            {'Camiseta arrugada', 'prop_cs_tshirt_ball_01', 50},
            {'Comodin gris', 'prop_fbibombfile', 250},
            {'Pantalones en percha', 'prop_jeans_01', 250},
            {'Reloj de pulsera', 'prop_jewel_02a', 50},
            {'Reloj de pulsera2', 'prop_jewel_02b', 50},
            {'Reloj de pulsera3', 'prop_jewel_02c', 50},
            {'Reloj de pulsera4', 'prop_jewel_03a', 50},
            {'Reloj de pulsera5', 'prop_jewel_03b', 50},
            {'Reloj de pulsera6', 'prop_jewel_04a', 50},
            {'Reloj de pulsera7', 'prop_jewel_04b', 50},
            {'Bolso', 'prop_ld_handbag', 50},
            {'Pantalon suelo', 'prop_ld_jeans_01', 50},
            {'Pantalon suelo2', 'prop_ld_jeans_02', 50},
            {'Cartera mujer', 'prop_ld_purse_01', 50},
            {'Camisa suelo', 'prop_ld_shirt_01', 50},
            {'Zapato blanco dr', 'prop_ld_shoe_01', 50},
            {'Zapato blanco iz', 'prop_ld_shoe_02', 50},
            {'Camiseta suelo', 'prop_ld_tshirt_01', 50},
            {'Cartera hombre', 'prop_ld_wallet_01', 50},
            {'Bolso2', 'prop_med_bag_01b', 50},
            {'Mochila', 'prop_michael_backpack', 50},
            {'Mochila gym', 'prop_nigel_bag_pickup', 50},
            {'Bota', 'prop_old_boot', 50},
            {'Bolso playa 1', 'prop_beachbag_01', 50},
            {'Bolso playa 2', 'prop_beachbag_02', 50},
            {'Bolso playa 3', 'prop_beachbag_03', 50},
            {'Bolso playa 4', 'prop_beachbag_04', 50},
            {'Bolso playa 5', 'prop_beachbag_05', 50},
            {'Bolso playa 6', 'prop_beachbag_06', 50},
            {'Handbag 1', 'prop_amb_handbag_01', 50}      
        },   
        ['tv'] = {
            {'Tv blanco y negro pequeña', 'prop_tv_05', 30},
            {'Tv blanco y negro', 'prop_tv_04', 40},
            {'Tv de caja pequeña', 'prop_tv_02', 50},
            {'Tv de caja mediana', 'prop_tv_07', 70},
            {'Tv de caja grande', 'prop_tv_06', 100},
            {'Tv 19 blanca', 'prop_trev_tv_01', 100},
            {'SmartTv 19 blanco', 'prop_tv_flat_03', 150},
            {'SmartTv 19 blanco para pared', 'prop_tv_flat_03b', 150},
            {'SmartTv 24 negro', 'prop_tv_flat_02b', 200},
            {'SmartTV 24', 'prop_tv_flat_02', 200},  
            {'SmartTv 30 negro para pared', 'prop_tv_flat_michael', 300},    
            {'SmartTv 50 blanca', 'prop_tv_flat_01', 500}          
        },    
        ['tel'] = {---------ok----------
            {'Movil 1', 'prop_v_m_phone_01', 20},
            {'Movil 2', 'prop_prologue_phone', 20},
            {'Movil 3', 'prop_v_m_phone_o1s', 75},
            {'Movil 4', 'prop_police_phone', 50},
            {'Movil 5', 'p_amb_phone_01', 50},
            {'Movil 6', 'prop_player_phone_01', 70},
            {'Movil 8', 'prop_amb_phone', 70},
            {'Movil 9', 'prop_npc_phone', 70},
            {'Tablet pequeña', 'prop_cs_tablet_02', 75},
            {'Tablet grande', 'prop_cs_tablet', 100},
            {'Telefono fijo', 'prop_cs_phone_01', 50}, 
            {'Office Phone', 'prop_office_phone_tnt', 75},  
            {'Telefono fijo ofic', 'prop_off_phone_01', 150},
            {'Fax', 'prop_fax_01', 100}                  
        },
        ['electronics'] = {
          
            ------PC---------
            {'Laptop Closed', 'p_cs_laptop_02_w', 75},
            {'Laptop', 'p_amb_lap_top_02', 75},
            {'Laptop 2', 'p_cs_laptop_02', 75},
            {'Portatil', 'prop_laptop_02_closed', 250},
            {'Portatil abierto', 'prop_laptop_jimmy', 250},           
            {'Monitor antiguo', 'prop_monitor_03b', 50},
            {'Monitor PC', 'prop_ld_monitor_01', 100},
            {'Monitor encendido', 'prop_monitor_01c', 150},            
            {'Torre antigua', 'prop_pc_01a', 50},
            {'Torre I3', 'prop_pc_02a', 75},
            {'Torre I5', 'prop_dyn_pc_02', 200},            
            {'Torre I7', 'prop_dyn_pc', 300},               
            {'Torre I9', 'hei_prop_heist_pc_01', 400},
            {'Raton viejo', 'prop_mouse_01a', 10},    
            {'Raton', 'prop_cs_mouse_01', 20},
            {'Raton con alfombrilla', 'v_res_mousemat', 50},
            {'Teclado viejo', 'prop_keyboard_01a', 20},
            {'Teclado', 'prop_cs_keyboard_01', 30},
            {'Teclado Pequeño', 'hei_prop_hei_cs_keyboard', 50},
            {'Impresora 1', 'prop_printer_01', 50},
            {'Impresora 2', 'prop_printer_02', 100},  
            {'Micro', 'prop_table_mic_01', 20},            
            ----radios---
            {'Radio de los 90', 'prop_tapeplayer_01', 50},
            {'Radio', 'prop_ghettoblast_02', 50},
            {'Radio 2', 'prop_portable_hifi_01', 50},
            {'Radio 3', 'prop_boombox_01', 50},   
            {'Minicadena', 'prop_hifi_01', 100}, 
            {'Altavoces USB', 'prop_mp3_dock', 150},    
            -----accesorios--
            {'Vhs', 'prop_vcr_01', 30},
            {'DVD', 'prop_cs_dvd_player', 30},
            {'Mando Tv', 'prop_cs_remote_01', 10},
            {'Camara', 'prop_ing_camera_01', 50},
            {'Camara profesional', 'prop_pap_camera_01', 150},
            {'Maquinilla', 'prop_clippers_01', 25},
            {'Ventilador de pie', 'prop_fan_01', 20},
            {'Aire acondicionado suelo', 'prop_fbibombcupbrd', 50},
            {'Despertador', 'v_res_fh_bedsideclock', 75},       
            {'Camara vigilancia', 'prop_cs_cctv', 100},            
            {'Alarma ', 'prop_alarm_01', 100}

            --{'Keypad 2', 'prop_ld_keypad_01', 75}, ---cerradura caja fuerte
           -- {'Plancha de ropa', 'prop_iron_01', 50},
                        

        },
        ['bed'] = {  -------OK------
            {'Cama...', 'p_v_res_tt_bed_s', 100},
            {'Cama basica', 'p_lestersbed_s', 150},
            {'Cama metalica', 'v_res_d_bed', 150},
            {'Cama madera', 'v_res_tre_bed2', 180},           
            {'Cama blanca', 'v_res_tre_bed1', 200},
            {'Cama roja/negra', 'v_res_msonbed_s', 450},           
            {'Cama clase alta', 'p_mbbed_s', 600}            
        },
        ['sofa'] = {  --------OK-------
            {'Cojin', 'v_ilev_m_sofacushion', 20},
            -----sofa roto---
            {'Sofa indigente', 'miss_rub_couch_01', 25},
            {'Sofa Roto', 'v_tre_sofa_mess_c_s', 40},
            {'Butaca vieja', 'prop_ld_farm_chair01', 45},
            {'Sofa 3 plazas viejo', 'prop_ld_farm_couch01', 50},
            {'Sofa 2 viejo ', 'prop_ld_farm_couch02', 50},
            ------basicos
            {'Sofa basico sucio', 'v_tre_sofa_mess_b_s', 60},
            {'Sofa basico', 'v_res_tre_sofa_s', 80},           
            {'Butaca madera', 'prop_armchair_01', 80},
            {'Sillon acolchado bl', 'prop_couch_sm_07', 80},
            {'Butaca verde', 'v_res_mp_stripchair', 80},
            {'Butaca baja verde', 'v_res_d_armchair', 70},
            {'Sillon negro', 'prop_waiting_seat_01', 100},
            {'Sillon rustico', 'prop_couch_sm_02', 80},
            {'Sofa rustico', 'prop_couch_lg_02', 100},
            {'Sillon simple veige', 'prop_couch_sm_05', 90},
            {'Sofa simple veige', 'prop_couch_lg_05', 100},
            {'Sofa cuero simple', 'prop_couch_lg_06', 100},
            {'Sofa modular rincon', 'prop_couch_sm1_07', 100},
            {'Sofa modular central', 'prop_couch_sm2_07', 100},
            {'Sofa cuero marron', 'p_v_med_p_sofa_s', 150},
            {'Sillon mimbre', 'prop_chair_05', 50},
            {'Sofa clasico grande', 'prop_couch_03', 100},
            {'Sofa clasico', 'prop_couch_01', 400},
            {'Sofa cuero marron', 'prop_couch_04', 250},
            ----sofas pijos
            {'Sofa rattan 1 plaza', 'prop_yaught_chair_01', 100},
            {'Sofa rattan 2 plazas', 'prop_yaught_sofa_01', 100},
            {'Sofa rattan 1 plaza 2 colores', 'prop_yacht_seat_01', 100},
            {'Sofa rattan sin brazos 2 colores', 'prop_yacht_seat_03', 100},
            {'Sofa rattan 2 plazas 2 colores', 'p_yacht_sofa_01_s', 150},
            {'Banqueta confortable grande', 'prop_wait_bench_01', 200},
            {'Sofa tumbona blanco', 'prop_t_sofa_02', 300},
            {'Sofa tumbona blanco 2', 'prop_t_sofa', 300},         
            {'Sofa grande blanco', 'v_ilev_m_sofa', 450},
               -----realeza         
            {'Sofa de clase alta', 'p_res_sofa_l_s', 600},
            {'Sofa de clase alta 2', 'v_res_m_h_sofa_sml', 600}           
             -----colocar en su sitio
            -----{'Tumbona mimbre negra', 'prop_yacht_lounger', 100},          
        },
        ['Plants'] = {
            {'Plant 1', 'p_int_jewel_plant_02', 100},
            {'Plant 2', 'p_int_jewel_plant_01', 100},
            {'Plant 3', 'prop_fbibombplant', 100},
            {'Plant 4', 'prop_fib_plant_01', 100},
            {'Plant 5', 'prop_fib_plant_02', 100},
            {'Plant 6', 'prop_ld_dstplanter_01', 100},
            {'Plant 7', 'prop_ld_planter2b', 100},
            {'Plant 8', 'prop_plant_int_01a', 100},
            {'Plant 9', 'prop_plant_int_01b', 100},
            {'Plant 10', 'prop_plant_int_02a', 100},
            {'Plant 11', 'prop_plant_int_02b', 100},
            {'Plant 12', 'prop_plant_int_03a', 100},
            {'Plant 13', 'prop_plant_int_03c', 100},
            {'Plant 14', 'prop_plant_int_03b', 100},
            {'Plant 15', 'prop_plant_int_04b', 100},
            {'Plant 16', 'prop_plant_int_04a', 100},
            {'Plant 17', 'prop_plant_int_04c', 100},
            {'Plant 13', 'prop_plant_palm_01a', 100},
            {'Plant 14', 'prop_plant_palm_01c', 100},
            {'Plant 15', 'prop_pot_plant_01b', 100},
            {'Plant 16', 'prop_pot_plant_01a', 100},
            {'Plant 17', 'prop_pot_plant_01c', 100},
            {'Plant 18', 'prop_pot_plant_01d', 100},
            {'Plant 19', 'prop_pot_plant_03c', 100},
            {'Jarron con flores', 'apa_mp_h_acc_vase_flowers_01', 100},
            {'Plant 20', 'prop_pot_plant_05a', 100},
            {'Maceta 1', 'prop_windowbox_a', 50},
            {'Maceta 2', 'prop_windowbox_b', 100},
            {'Maceta 3', 'prop_fbibombplant', 100}
        },
        ['Caveman'] = {    -------OK----------
            {'Diana', 'prop_dart_bd_cab_01', 80},
            {'Dart 2', 'prop_dart_bd_01', 50},
            {'Mesa de pin-pon', 'prop_table_tennis', 100},
            {'Mesa billar rosa', 'prop_pooltable_3b', 200},
            {'Mesa billar verde', 'prop_pooltable_02', 200},   
            {'Triangulo billar', 'prop_pool_tri', 50},
            {'Palos billar 1', 'prop_pool_rack_01', 100},
            {'Palos billar 2', 'prop_pool_rack_02', 100},    
            {'Bola negra', 'prop_pool_ball_01', 5},
            {'Bola blanca', 'prop_poolball_cue', 5},
            {'Bola 1', 'prop_poolball_1', 5},
            {'Bola 2', 'prop_poolball_2', 5},
            {'Bola 3', 'prop_poolball_3', 5},
            {'Bola 4', 'prop_poolball_4', 5},
            {'Bola 5', 'prop_poolball_5', 5},
            {'Bola 6', 'prop_poolball_6', 5},
            {'Bola 7', 'prop_poolball_7', 5},
            {'Bola 8', 'prop_poolball_8', 5},
            {'Bola 9', 'prop_poolball_9', 5},
            {'Bola 10', 'prop_poolball_10', 5},
            {'Bola 11', 'prop_poolball_11', 5},
            {'Bola 12', 'prop_poolball_12', 5},
            {'bola 13', 'prop_poolball_13', 5},
            {'Bola 14', 'prop_poolball_14', 5},
            {'Bola 15', 'prop_poolball_15', 5},
            {'Basket Arcade', 'prop_bball_arcade_01', 250},
            {'Air Hockey', 'prop_airhockey_01', 300},
            {'Consola', 'prop_console_01', 100},
            {'Mando de consola', 'prop_controller_01', 20},
            {'Arcade 1', 'prop_arcade_01', 250},
            {'Arcade 2', 'prop_arcade_02', 250},
            {'Guitar', 'prop_acc_guitar_01', 50},
            {'Guitarra electrica', 'prop_el_guitar_01', 50},
            {'Guitarra electrica2', 'prop_el_guitar_02', 50},
            {'Guitarra electrica3', 'prop_el_guitar_03', 50},
            {'Amplificador', 'prop_amp_01', 150}, 
            {'Tabla de surf', 'prop_venice_board_01', 50},
            {'Tabla de surf madera', 'prop_venice_board_03', 50},
            {'Dispensador agua', 'prop_watercooler', 150},
            {'Nevera grande', 'prop_bar_fridge_01', 200}, 
            {'Nevera pequeña', 'prop_bar_fridge_03', 150},
            {'Nevera bebidas', 'prop_vend_fridge01', 200},
            {'Vending snacks', 'prop_vend_snak_01', 250},
            {'Vending cafe', 'prop_vend_coffe_01', 250},
            {'Vending refrescos', 'prop_vend_soda_01', 250},
            {'Vending refrescos 2', 'prop_vend_soda_02', 250},
            {'Vending agua', 'prop_vend_water_01', 250}           
        },   
        ['garage'] = {    ------OK--------
            {'Estanteria metalica', 'prop_ff_shelves_01', 100},
            {'Mueble de herramientas grande', 'prop_toolchest_05', 250},
            {'Mueble de herramientas mediano', 'prop_toolchest_04', 200},
            {'Mueble de herramientas mediano 2', 'prop_toolchest_03', 200},
            {'Caja de herramientas pequeña', 'prop_toolchest_01', 50},
            {'Caja de herramientas mediana', 'prop_toolchest_02', 100},
            {'Caja de herramientas metalica', 'prop_tool_box_04', 40},
            {'Caja de herramientas metalica grande', 'prop_tool_box_06', 50},
            {'Caja de herramientas', 'prop_tool_box_01', 50},          
            {'Porta-herramientas', 'prop_tool_box_03', 20},
            {'Baul de herramientas', 'prop_tool_box_07', 100},
            {'Caja de taladro', 'prop_tool_box_02', 00},
            {'Plano taller', 'prop_tool_bluepnt', 5},
            {'Cascos de obra', 'prop_ear_defenders_01', 50},
            {'Destornillador plano', 'prop_tool_screwdvr01', 5},
            {'Destornillador estrella', 'prop_tool_screwdvr02', 5},
            {'Destornillador grande', 'prop_tool_screwdvr03', 5},
            {'Martillo', 'prop_tool_hammer', 5},
            {'Martillo de goma', 'prop_tool_mallet', 5},
            {'Alicates', 'prop_tool_pliers', 5},
            {'Llave inglesa', 'prop_tool_adjspanner', 5},
            {'Llave inglesa doble', 'prop_tool_spanner01', 5},
            {'Linterna grande', 'prop_tool_torch', 10},
            {'Radial grande', 'prop_tool_consaw', 50},
            {'Taladro', 'prop_tool_drill', 40},           
            {'Caballete', 'prop_tool_bench01', 50},           
            {'Rollo de cable', 'prop_tool_cable01', 5},
            {'Rollo de cable grande', 'prop_tool_cable02', 5},
            {'Llanta 1', 'prop_wheel_rim_01', 20},
            {'Llanta 2', 'prop_wheel_rim_02', 20},
            {'Llanta 3', 'prop_wheel_rim_03', 20},
            {'Llanta 4', 'prop_wheel_rim_04', 20},
            {'Llanta 5', 'prop_wheel_rim_05', 20},
            {'Caja de madera', 'prop_lev_crate_01', 225},
            {'Caja plastico', 'prop_mil_crate_01', 300},
            {'Caja plastico 2', 'prop_mil_crate_02', 300}

            ---{'Escoba', 'prop_tool_broom', 5},----mover a 
            ---{'Nevera de plastico', 'prop_tool_box_05', 50}, mover a
        }, 
        ['CashGoldJewels'] = {
            {'Cash Case', 'prop_cash_case_02', 50},
            {'Cash Crate', 'prop_cash_crate_01', 50},
            {'Cash Crat 2', 'hei_prop_cash_crate_half_full', 50},
            {'Cash Note', 'prop_anim_cash_note_b', 50},
            {'Cash Pile', 'prop_anim_cash_pile_01', 50},
            {'Cash trolly', 'prop_cash_trolly', 50},
            {'Cash trolly', 'prop_poly_bag_money', 50},
            {'Gold trolly full', 'prop_gold_trolly_full', 50},
            {'Gold trolly', 'prop_gold_trolly', 50},
            {'Gold bar', 'prop_gold_bar', 50},
            {'Large Gold', 'prop_large_gold', 50},
            {'Large Gold 2', 'p_large_gold_s', 50},
            {'Gold Chest', 'prop_ld_gold_chest', 50},
            {'Petoyte Gold', 'prop_peyote_gold_01', 50},
            {'Jewel 1', 'prop_jewel_03b', 50},
            {'Jewel 2', 'prop_jewel_04b', 50},
            {'Jewel 3', 'prop_jewel_02b', 50},
            {'Jewel 4', 'prop_jewel_pickup_new_01', 50},
            {'Jewel 5', 'prop_jewel_04b', 50},
            {'Jewel 6', 'prop_cs_beer_box', 50}
        },

        ['popurri'] = {

            {'Papelera', 'hei_heist_kit_bin_01', 150},
            {'Trolly', 'hei_prop_hei_cash_trolly_03', 150},      
            {'Caja fuerte', 'prop_ld_int_safe_01', 300},
            {'Cocina industrial', 'prop_cooker_03', 100},
           
            {'Telescopio', 'prop_t_telescope_01b', 50},
            {'Canasto para ropa', 'prop_washing_basket_01', 50},
            {'Regadera', 'prop_wateringcan', 50},
            {'Cubo de fregona', 'prop_tool_mopbucket', 50},
            {'Escoba', 'prop_tool_broom', 50},
            {'Bolsa', 'prop_carrier_bag_01', 50},
            {'Maletin dinero', 'prop_cash_case_01', 50},
            {'Pallet pequeño dinero', 'prop_cash_crate_01', 50},
            {'Paquete tabaco', 'prop_cigar_pack_01', 50},
            {'Paquete tabaco2', 'prop_cigar_pack_02', 50},
            {'Periodico', 'prop_cliff_paper', 50},
            {'Maquinilla', 'prop_clippers_01', 50},
            {'Perchero de puerta', 'prop_coathook_01', 50},
            {'Toalla de baño', 'prop_cs_beachtowel_01', 50},
            {'Clasificador', 'prop_cs_binder_01', 50},
            {'Abrelatas', 'prop_cs_bottle_opener', 50},
            {'Cuchillo militar', 'prop_cs_bowie_knife', 50},
            {'Paquete', 'prop_cs_box_clothes', 50},
            {'Cubo de fregona', 'prop_cs_bucket_s', 50},
            {'Tarjeta credito', 'prop_cs_business_card', 50},
            {'Copa champagne vacia', 'prop_cs_champ_flute', 50},
            {'Esposas', 'prop_cs_cuffs_01', 50},
            {'Pollita rosa', 'prop_cs_dildo_01', 50},
            {'Documentos', 'prop_cs_documents_01', 50},
            {'CD', 'prop_cs_dvd', 50},
            {'Caratula CD', 'prop_cs_dvd_case', 50},
            {'Tenedor', 'prop_cs_fork', 50},
            {'Bolsa', 'prop_cs_heist_bag_02', 50},
            {'Tabla de planchar', 'prop_cs_ironing_board', 50},
            {'Katana', 'prop_cs_katana_01', 50},
            {'Pintalabios', 'prop_cs_lipstick', 50},
            {'Revista XXX', 'prop_cs_magazine', 50},
            {'Lima de uñas', 'prop_cs_nail_file', 50},
            {'Periodico abierto', 'prop_cs_newspaper', 50},
            {'Cuadro mesa', 'prop_cs_photoframe_01', 50},
            {'Bote de pastillas', 'prop_cs_pills', 50},
            {'Fotografia', 'prop_cs_polaroid', 50},
            {'Linterna', 'prop_cs_police_torch', 50},
            {'Bolsa de basura', 'prop_cs_rub_binbag_01', 50},
            {'Tijeras', 'prop_cs_scissors', 50},
            {'Bandeja', 'prop_cs_silver_tray', 50},
            {'Timbre', 'prop_door_bell_01', 50},
            {'Caña de pescar', 'prop_fishing_rod_01', 50},
            {'Espatula plancha', 'prop_fish_slice_01', 50},
            {'Fichero documentos', 'prop_folder_01', 50},
            {'Fichero documentos2', 'prop_folder_02', 50},
            {'Cesta mimbre', 'prop_fruit_basket', 50},
            {'Maletin', 'prop_ld_case_01', 50},
            {'Libreta', 'prop_notepad_01', 50},
            {'Libro', 'prop_novel_01', 50},                        
            {'Diana azul', 'prop_target_blue', 50},
            {'Diana de tiro', 'prop_target_comp_metal', 50},
            {'Mapa de Los santos', 'prop_tourist_map_01', 50},
            
            
            {'Molinillo', 'prop_windmill2', 50},
            {'Pizarra de rotulador', 'prop_w_board_blank', 50},
            {'Rueda de carro', 'prop_w_board_blank', 50},
            {'Claqueta cine', 'prop_clapper_brd_01', 50},
            {'Neon para bar', 'prop_cockneon', 50},
            {'Cortina de listones', 'prop_cs_ilev_blind_01', 50},
            {'Atrapasueños', 'prop_garden_dreamcatch_01', 50},
            {'Osito', 'prop_mr_rasberryclean', 50},
           
            
            
            
           
            
            
            
            
            {'Apple Box 2', 'prop_apple_box_01', 200},
            {'Apple Box 1', 'prop_apple_box_02', 150},
            {'Artifact 1', 'prop_artifact_01', 150},

            ------ropa------
            {'Bags01', 'prop_shopping_bags01', 50},
            {'Bags02', 'prop_shopping_bags02', 50},
            -------oficina-----
            {'Hoja de papel', 'prop_a4_pile_01', 50},
            ------muebles------
            {'Escalera vieja', 'prop_air_woodsteps', 150},
            ------drogas-------
            {'Maletin vacio', 'prop_attache_case_01', 50},
            {'Bong', 'prop_sh_bong_01', 50},  
            -----electronica-----
            {'Cinta beta', 'prop_beta_tape', 50},        
            {'Binoculares', 'prop_binoc_01', 50},
            {'Bongos', 'prop_bongos_01', 50}, 
             ------accesoriosdecoracion-----
             {'Cenicero', 'prop_ashtray_01', 50},
             {'Posavasos cerveza', 'prop_bar_coastbarr', 150},
             {'Helice', 'prop_air_propeller01', 100},
             {'Escudo policia', 'prop_ballistic_shield', 200},
             {'Misil', 'prop_sam_01', 150},
            ----ropa----
            {'Bolsa de deporte', 'prop_big_bag_01', 50},

            ------gym----
            {'Punch', 'prop_beach_punchbag', 200},         
            {'Pelota de Basket', 'prop_bskball_01', 50},
            {'Barra dominadas', 'prop_a_base_bars_01', 150}

        },
        ['Drugs'] = {
            {'Drug 2', 'hei_prop_hei_drug_pack_01b', 100},
            {'Drug 3', 'hei_prop_hei_drug_pack_01a', 100},
            {'Drug 4', 'hei_prop_hei_drug_pack_02', 100},
            {'Drug 5', 'hei_prop_heist_drug_tub_01', 100},
            {'Drug 6', 'ng_proc_drug01a002', 100},
            {'Drug 7', 'prop_drug_bottle', 100},
            {'Drug 8', 'hei_prop_hei_drug_case', 100},
            {'Drug 9', 'prop_drug_burner', 100},
            {'Drug 10', 'prop_drug_erlenmeyer', 100},
            {'Drug 11', 'prop_drug_package', 100},
            {'Drug 12', 'prop_drug_package_02', 100},
            {'Drug 13', 'prop_mp_drug_package', 100},
            {'Drug 14', 'prop_mp_drug_pack_blue', 100},
            {'Drug 15', 'prop_mp_drug_pack_red', 100},
            {'Drug 16', 'prop_coke_block_01', 100},
            {'Drug 17', 'prop_coke_block_half_a', 100},
            {'Drug 18', 'p_meth_bag_01_s', 500},
            {'Drug 19', 'prop_meth_bag_01', 100},
            {'Drug 20', 'prop_meth_setup_01', 100},
            {'Planta de cannabis', 'prop_weed_01', 200},
            {'Planta de cannabis 2', 'prop_weed_02', 200},
            {'Pastillas de la risa', 'prop_weed_bottle', 200},
            {'Paquete de cannabis', 'prop_weed_bottle', 200},
            {'Pallet de cannabis', 'prop_weed_pallet', 500}

        },
        ['FoodandDrinks'] = {
            {'Peanut bowl', 'prop_peanut_bowl_01', 50},
            {'Bowl', 'prop_cs_bowl_01', 50},
            {'BS Cup', 'prop_cs_bs_cup', 50},
            {'Coffe', 'p_ing_coffeecup_02', 50},
            {'Fruit Stand 1', 'prop_fruit_stand_03', 50},
            {'Fruit Stand 2', 'prop_fruit_stand_02', 50},
            {'Fruit Stand 3', 'prop_fruit_stand_01', 50},
            {'Fruit Stand 4', 'prop_fruit_stand_03', 50},
            {'Fruit Stand 5', 'prop_fruit_stand_03', 50},
            {'Beer box', 'prop_cs_beer_box', 50},
            {'Beer 2', 'beerrow_world', 50},
            {'Beer 3', 'prop_amb_beer_bottle', 50},
            {'Beer 4', 'prop_beer_blr', 50},
            {'Beer 5', 'prop_beer_logger', 50},
            {'Food', 'ng_proc_food_bag01a', 50},
            {'Food 2', 'prop_food_bs_burg1', 50},
            {'Food 3', 'prop_food_bs_burg3', 50},
            {'Food 4', 'prop_food_bs_chips', 50},
            {'Food 5', 'prop_food_bs_burger2', 50},
            {'Food 6', 'prop_food_bs_coffee', 50},
            {'Food 7', 'prop_food_cups1', 50},
            {'Food 8', 'prop_food_cb_cups01', 50},
            {'Food 9', 'prop_food_cb_cups02', 50},
            {'Food 10', 'prop_food_bs_cups02', 50},

            {'Taco', 'prop_taco_01', 50},
            {'Taco mordido', 'prop_taco_02', 50},
            {'Vaso de whisky', 'prop_tumbler_01', 50},
            {'Alita de pollo', 'prop_turkey_leg_01', 50},
            {'Bebida proteica', 'prop_wheat_grass_glass', 50},
            {'Barrita de choc', 'prop_choc_ego', 50},
            {'Barrita de choc2', 'prop_choc_meto', 50},
            {'Cerveza', 'prop_cs_beer_bot_01', 50},
            {'Bol de lentejas', 'prop_cs_bowl_01', 50},
            {'Vaso hamburgueseria', 'prop_cs_bs_cup', 50},
            {'Hamburguesa', 'prop_cs_burger_01', 50},
            {'Bolsa de patatas', 'prop_cs_crisps_01', 50},
            {'Hogdog', 'prop_cs_hotdog_01', 50},
            {'Hogdog mordido', 'prop_cs_hotdog_02', 50},
            {'Leche abierta', 'prop_cs_milk_01', 50},
            {'Desayuno americano', 'prop_cs_plate_01', 50},
            {'Filete', 'prop_cs_steak', 50},
            {'Cola abierta', 'prop_ecola_can', 50},
            {'Bebida energetica', 'prop_energy_drink', 50},
            {'Comida china', 'prop_ff_noodle_01', 50},
            {'Lata gaseosa', 'prop_ld_can_01', 50},
            {'Patatas de queso', 'prop_ld_snack_01', 50},
            {'Cerveza1', 'prop_sh_beer_pissh_01', 5},
            {'Lata1', 'prop_orang_can_01', 5},
            {'Sandwich', 'prop_sandwich_01', 5},
            {'CajaPizza1', 'prop_pizza_box_01', 5},
            {'CajaPizza2', 'prop_pizza_box_02', 5},
            {'Pibwasser 1L', 'prop_amb_40oz_02', 50},
            {'Pibwasser 1L2', 'prop_amb_40oz_03', 50},
            {'Donut', 'prop_amb_donut', 50},
            {'Caja de Cervezas', 'prop_beer_box_01', 150}
        },
        ['lights'] = {
           --{'Light ', 'prop_cd_lamp', 150},
           --{'Light 2', 'v_res_desklamp', 150},
           --{'Light 3', 'v_corp_cd_desklamp', 150},
           --{'Light 4', 'v_res_d_lampa', 150},
           --{'Light 5', 'v_res_fh_floorlamp', 150},
           --{'Light 6', 'v_res_fa_lamp1on', 150},
           --{'Light 7', 'v_res_j_tablelamp1', 150},
           --{'Light 8', 'v_res_j_tablelamp2', 150},
           --{'Light 9', 'v_res_mplanttongue', 150},
           --{'Light 10', 'v_res_m_lampstand', 150},
           --{'Light 11', 'v_res_m_lampstand2', 150},
           --{'Light 12', 'v_res_mtblelampmod', 150},
           --{'Light 13', 'v_res_m_lamptbl', 150},
           --{'Light 14', 'v_res_tre_lightfan', 150},
           --{'Light 15', 'v_res_tre_talllamp', 150},
           --{'Light 16', 'v_ret_fh_walllighton', 150},
           --{'Light 17', 'v_ret_gc_lamp', 150},
           --{'Light 18', 'v_res_m_lamptbl', 150},
           --{'Light 19', 'hei_prop_hei_bnk_lamp_02', 150},
           --{'Light 20', 'prop_ld_cont_light_01', 150},
           --{'Light 21', 'hei_prop_hei_bnk_lamp_01', 150},
           --{'Light 22', 'prop_chall_lamp_02', 150},
           --{'Light 23', 'v_ilev_fh_lampa_on', 150},
           --{'Light 24', 'prop_construcionlamp_01', 150},
           --{'Light 25', 'hei_prop_bank_ornatelamp', 150},
           --{'Light 26', 'prop_kino_light_03', 150},
           --{'Light 27', 'prop_oldlight_01c', 150},
           --{'Light 28', 'prop_recycle_light', 150},
           --{'Light 29', 'prop_studio_light_01', 150},
           --{'Light 30', 'prop_studio_light_02', 150},
           --{'Light 25', 'hei_prop_bank_ornatelamp', 150},
           --{'Light 26', 'prop_wall_light_02a', 150},
           --{'Light 27', 'prop_wall_light_03a', 150},
           --{'Light 28', 'prop_wall_light_04a', 150},
           --{'Light 29', 'prop_wall_light_05a', 150},
           --{'Light 30', 'prop_wall_light_05c', 150},

            {'Aplique moderno', 'prop_wall_light_08a', 50},
            {'Barra de luz', 'prop_wall_light_17b', 50},
            {'Aplique moderno grande', 'prop_wall_light_18a', 50},
            {'aplique bloques', 'prop_chall_lamp_02', 50},
            {'Neon cerveza', 'prop_barrachneon', 150},
            {'Neon cerveza 2', 'prop_beerneon', 150},
            {'Neon liquor', 'prop_prop_beer_neon_01', 250},
            {'Neon cerveza 3', 'prop_beer_neon_01', 150},
            {'Neon Loguer', 'prop_beer_neon_04', 150},
            {'Palmeraneon', 'prop_ragganeon', 150},
            {'Patriotneon', 'prop_patriotneon', 150},
            {'Neon para bar2', 'prop_loggneon', 50}

          },
        
        ['kitchen'] = {  
            {'Cafetera', 'prop_coffee_mac_02', 100},
            {'Cafetera 2', 'apa_mp_h_acc_coffeemachine_01', 150},
            {'Plancha', 'prop_griddle_02', 100},
            {'Frigo antiguo', 'prop_trailr_fridge', 150},
            {'Frigo industrial', 'prop_fridge_01', 150},
            {'Frigo blanco', 'prop_fridge_03', 150},
            {'Fregadera industrial', 'prop_bar_sink_01', 150},
            {'Maquina de hielo industrial', 'prop_bar_ice_01', 150},
            {'Microondas acero', 'prop_microwave_1', 200},
            {'Microondas blanco', 'prop_micro_01', 100},
            {'Microondas blanco 2', 'prop_micro_01', 100},
            {'Microondas madera', 'prop_micro_cs_01', 150},
            {'Licuadora de zumo', 'prop_kitch_juicer', 50},
            ----electrodomesticos por colocar----
            {'Lavadora vieja', 'prop_washer_01', 50},
            {'Lavadora blanca', 'prop_washer_02', 100},
            {'Secadora', 'prop_washer_03', 100},       
            {'Tostadora vieja', 'prop_toaster_01', 50},
            {'Tostadora nueva', 'prop_toaster_02', 50},
            {'Hervidor', 'prop_cs_kettle_01', 50}               
        },
                
        ['kitchenacc'] = {    -----OK--------(fijar precios)
            {'Mueble de cocina inox', 'prop_ff_counter_01', 100},
            {'Colgador sartenes', 'prop_pot_rack', 200},
            {'Sarten1', 'prop_pot_01', 25},
            {'Sarten2', 'prop_pot_02', 25},
            {'Sarten3', 'prop_pot_03', 25},
            {'Sarten4', 'prop_pot_04', 25},
            {'Sarten5', 'prop_pot_05', 25},
            {'Sarten6', 'prop_pot_06', 25},
            {'Fruit 1', 'apa_mp_h_acc_fruitbowl_01', 150},
            {'Fruit 2', 'apa_mp_h_acc_fruitbowl_02', 150},
            {'Fruit 3', 'prop_bar_fruit', 150},
            {'Fruit 4', 'prop_bar_lemons', 150},
            {'Fruit 5', 'prop_bar_measrjug', 150},
            {'Bag', 'hei_prop_hei_paper_bag', 150},
            {'Bascula', 'bkr_prop_coke_scale_01', 150},
            {'Sarten vieja', 'prop_kitch_pot_fry', 50},
            {'Olla vieja', 'prop_kitch_pot_huge', 50},
            {'Cacerola vieja', 'prop_kitch_pot_lrg', 50},
            {'Cacerola con lentejas', 'prop_kitch_pot_lrg2', 50},
            {'Cuchillo de cocina', 'prop_knife', 50},
            {'Cuchillera', 'prop_knife_stand', 50},
            {'Cazo', 'prop_ladel', 50},
            {'Machete', 'prop_cleaver', 150},
            {'barilla de cocina', 'prop_whisk', 50},
            {'Sarten de wok', 'prop_wok', 50},
            {'Vaso vacio', 'prop_tumbler_01_empty', 50},
            {'Vaso tubo vacio', 'prop_wheat_grass_empty', 50},
            {'Servilletero', 'prop_bar_napkindisp', 50},
            {'cachibaches cocina', 'prop_utensil', 50},
            {'Cuchillo deshuesar', 'prop_cleaver', 50},
            {'Cacerola', 'prop_copper_pan', 50},
            {'Jarra leche', 'prop_pitcher_01_cs', 25}           
        },
    
           ['bathroom'] = {
            -----------WC---------
            {'Retreter basico', 'prop_toilet_01', 50},
            {'Retreter sucio', 'prop_ld_toilet_01', 30},
            {'Retrete sin tapa', 'prop_toilet_02', 40},            
            -----------Lababos-----------
            {'Lavabo de hormigon', 'prop_ff_sink_01', 70},
            {'Lavabo de hormigon2', 'prop_sink_02', 70},
            {'Lavabo metalico', 'prop_sink_04', 100},
            {'Lavabo basico', 'prop_sink_05', 60},
            {'Lavabo basico con pie', 'prop_sink_06', 60},
            {'Lavabo moderno', 'v_res_mbsink', 75},
            -----------bañeras------
            {'Bañera', 'v_res_mbath', 200},
            {'Bañera 2', 'apa_mp_h_bathtub_01', 200},           
            -------items aseo-----------
            {'Toalla l', 'prop_shower_towel', 5},
            {'Toalla 2', 'p_shower_towel_s', 5},
            {'Toalla de manos', 'v_res_mbtowel', 5},
            {'Toalla de manos2', 'v_res_mbtowelfld', 5},
            {'Toallas blancas dobladas', 'prop_towel_01', 5},
            {'Toalla jirafa', 'prop_ftowel_01', 10},
            {'Toalla rayas', 'prop_ftowel_07', 10},
            {'Toalla colores', 'prop_ftowel_08', 10},
            {'Toalla colores2', 'prop_ftowel_10', 10},
            {'toalla blanca en percha', 'prop_tint_towel', 10},
            {'Toallero', 'prop_towel_rail_01', 15},
            {'Toallero de manos', 'prop_towel_rail_02', 15},
            {'Papel higienico', 'prop_toilet_roll_01', 5},
            {'Porta-papel higienico', 'prop_toilet_roll_02', 5},
            {'Jabonero', 'prop_soap_disp_01', 10},
            {'Vaso para cepillo de dientes', 'prop_toothb_cup_01', 5},
            {'Escobilla de retrete', 'prop_toilet_brush_01', 5},
            {'Cepillo de dientes', 'prop_toothbrush_01', 5},
            {'Canasto baño', 'prop_shower_rack_01', 10},
            {'Mueble baño', 'p_new_j_counter_02', 100},	
            {'Dispensador papel', 'prop_handdry_01', 20},
            {'Secador de manos', 'prop_handdry_02', 20},       
            ------------productos aseo-----
            {'Crema solar', 'prop_beach_lotion_01', 5},
            {'After sun', 'prop_beach_lotion_02', 5},
            {'Crema solar UV', 'prop_beach_lotion_03', 5}, 
            {'Shampo', 'prop_toilet_shamp_01', 5},
            {'Gel de baño', 'prop_toilet_shamp_02', 5},
            {'Pastilla de jabón', 'prop_toilet_soap_01', 5},
            {'Pastillero de jabón', 'prop_toilet_soap_02', 5},
            {'Jabón de manos', 'prop_toilet_soap_03', 5},
            {'Jabón de manos de rosas', 'prop_toilet_soap_04', 5},
            {'Pasta dental', 'prop_toothpaste_01', 5},
            {'Limpiacristales', 'prop_blox_spray', 5}
        },
        ['Gym'] = {   ------ok-----------
            {'Funda paleta tenis', 'prop_tennis_bag_01', 20},
            {'Pelota de tenis', 'prop_tennis_ball', 5},
            {'Raqueta rosa de tenis', 'prop_tennis_rack_01', 30},
            {'Raqueta azul de tenis', 'prop_tennis_rack_01b', 30},
            {'Disco de peso 10k', 'prop_weight_10k', 10},
            {'Disco de peso 15k', 'prop_weight_15k', 10},
            {'Disco de peso 1k', 'prop_weight_1_5k', 10},
            {'Disco de peso 20k', 'prop_weight_20k', 10},
            {'Mancuerna', 'prop_barbell_01', 20},
            {'Barra con pesas', 'prop_barbell_02', 40},
            {'Porta pesos', 'prop_weight_rack_01', 25},
            {'Porta mancuernas', 'prop_weight_rack_02', 25},          
            {'Mancuerna rosa 4k', 'prop_freeweight_01', 10},
            {'Mancuerna rosa 8k', 'prop_freeweight_02', 10},
            {'Alfombrilla de yoga', 'prop_yoga_mat_01', 5},
            {'Alfombrilla de yoga 2', 'prop_yoga_mat_02', 5},
            {'Alfombrilla de yoga 3', 'prop_yoga_mat_03', 5},
            {'SacoBoxeo', 'prop_punch_bag_l', 100},
            {'Equipo Gym', 'prop_pris_bench_01', 200},           
            {'Equipo Gym2', 'prop_muscle_bench_01', 200},
            {'Equipo Gym3', 'prop_muscle_bench_02', 200},
            {'Equipo Gym4', 'prop_muscle_bench_03', 200},
            {'Equipo Gym5', 'prop_muscle_bench_04', 200},
            {'Equipo Gym6', 'prop_muscle_bench_05', 200},
            {'Equipo Gym7', 'prop_muscle_bench_06', 200},           
            {'Bicicleta estatica', 'prop_exer_bike_01', 200},
            {'Exercise bike', 'prop_exercisebike', 200}
       },
        ['Bins'] = {
            {'Bin 1', 'prop_cs_bin_02', 100}, 
            {'Bin 2', 'prop_cs_bin_03', 100}, 
            {'Bin 3', 'prop_fbibombbin', 100}, 
            {'Bin 4', 'prop_rub_binbag_sd_01', 100},
            {'Bin 5', 'prop_rub_binbag_sd_01', 100},
            {'Bin 6', 'prop_bin_04a', 150},
            {'Bin 7', 'prop_bin_07a', 150},
            {'Bin 8', 'prop_bin_06a', 150},
            {'Bin 9', 'prop_bin_10b', 150},
            {'Bin 10', 'prop_bin_11b', 150},
            {'Bin 11', 'prop_bin_11a', 150},
            {'Large bin', 'prop_bin_13a', 150},
            {'Bin bag', 'prop_rub_binbag_sd_01', 100}
        },
        ['Storage'] = {  
            {'Mueble basico', 'prop_rub_cabinet03', 60},
            {'Mueble basico 2', 'prop_rub_cabinet02', 50},
            {'Cajonera basica', 'prop_rub_cabinet01', 60},
            {'Consola madera oscura', 'hei_heist_str_sideboardl_03', 200},                   
            {'Consola madera', 'v_res_fh_sidebrdlngb', 250},
            {'Consola moderna', 'v_res_fh_sidebrddine', 250},
            {'Mueble salon', 'v_res_msoncabinet', 300},
            {'Mueble TV', 'v_res_j_tvstand', 100},
            {'Mueble de Tv grande', 'prop_tv_cabinet_03', 000},
            {'Mueble de Tv mediano', 'prop_tv_cabinet_04', 100},       
            {'Mesita de cama antigua', 'v_res_mbbedtable', 100},
            {'Cajonera antigua', 'v_res_d_sideunit', 125},
            {'Mueble antiguo', 'v_res_mcupboard', 125},
            {'Consola antigua', 'v_res_mconsolemod', 150},
            {'Armario amtiguo', 'v_res_m_armoire', 200},
            {'Mueble salon antiguo', 'v_res_cabinet', 225},
            {'Cajonera clasica blanca', 'v_res_mdchest', 250},
            {'Tocador clasico blanco', 'v_res_m_sidetable', 225},
            {'Tocador clasico', 'v_res_d_dressingtable', 225},
            {'Cajonera blanca', 'v_res_tre_storageunit', 100},
            {'Cajonera blanca 2', 'prop_fbibombfile', 100},           
            {'Mesita noche madra', 'v_res_tre_bedsidetable', 100},
            {'Cajonera moderna', 'prop_cabinet_01b', 250},           
            {'Estanteria azul', 'v_res_tre_smallbookshelf', 80},
            {'Mueble madera azul', 'v_res_tre_wdunitscuz', 100},
            {'Mueble con luces', 'p_new_j_counter_02', 150},
            {'Expositor blanco', 'prop_venice_counter_01', 100},
            {'Expositor blanco esquina', 'prop_venice_counter_03', 100},
            {'Baul bambu', 'v_res_tre_storagebox', 100},
            {'Baul rattan', 'prop_devin_box_closed', 200},
            {'Baul cuero', 'v_res_mbottoman', 200}
            
        },      
            
            
         ['office'] = {  
            {'Escritorio Clasico', 'v_res_mbdresser', 225},
            {'escritorio grande', 'v_res_son_desk', 300}, 
            {'escritorio blanco', 300},
            {'Escritorio gris', 'prop_office_desk_01', 100},          
            {'Taquilla blanca', 'p_cs_locker_01_s', 300},             
            {'Taquilla abierta', 'p_cs_locker_02', 300}, 
            {'Taquilla abierta pequeña', 'p_cs_locker_01', 300},
            {'Caja fuerte', 'prop_ld_int_safe_01', 500},
            {'Caja fuerte', 'p_v_43_safe_s', 600},
            {'Organizador papeles', 'prop_cabinet_02b', 100},
            {'Archivador viejo', 'prop_rub_cabinet', 100}
           
             ---------PARA ORDENAR----                  
           ------{'Caja de plastico', 'prop_cs_lester_crate', 150},----decoracion
           ------{'Caja de champan', 'prop_champ_box_01', 225},---acessorios cocina
           ------{'Weapon Box', 'p_secret_weapon_02', 225},
           ------{'Gun Case', 'prop_gun_case_02', 225},
           ------{'Coffin', 'prop_coffin_02b', 225}
        },
        ['accessory'] = {
            {'Watch', 'p_watch_02_s', 75},
            {'Watch 2', 'p_watch_01_s', 75},
            {'Cigar pack', 'p_cigar_pack_02_s', 75},
            {'Cigar pack 2', 'p_fag_packet_01_s', 75},
            {'Wallet', 'prop_ld_wallet_01_s', 75},
            {'Handbag', 'prop_ld_handbag_s', 75},
            {'Bag', 'prop_m_pack_int_01', 75},
            {'Bag 2', 'prop_cs_heist_bag_02', 75},
            {'Nigel Bag', 'prop_nigel_bag_pickup', 75},
            {'Suitcase', 'prop_ld_suitcase_01', 75}
        },
       -- ['structure'] = {
       --     {'Semimuro baranda', 'prop_vault_shutter', 50},
       --     {'Losa pizarra para suelo', 'prop_vb_34_tencrt_lighting', 50},
       --     {'Puertas armario', 'prop_wardrobe_door_01', 50},
       --     {'Panel de cristal', 'prop_win_trailer_ld', 50},
       --     {'Puerta de cristal ', 'prop_ch1_07_door_01l', 50},
       --     {'Porton de cristal ', 'prop_ch1_07_door_02l', 50},
       --     {'Puerta de cristal 2', 'prop_ch2_09b_door', 50},
       --     {'Tablon de madera', 'prop_cons_plank', 50},
       --     {'Puerta rustica', 'prop_cs6_03_door_l', 50},
       --     {'Puerta oscura', 'prop_epsilon_door_l', 50},
       --     {'Cristal', 'prop_fib_skylight_piece', 50},
       --     {'Puerta china iz', 'prop_grumandoor_l', 50},
       --     {'Puerta china dr', 'prop_grumandoor_r', 50},
       --     {'Paneles de madera blanca', 'prop_id_21_gardoor_01', 50},
       --     {'Ventana 2x2', 'prop_int_gate01', 50},
       --     {'Puerta de cristal', 'prop_kt1_06_door_l', 50},
       --     {'Puerta roble', 'prop_ld_bankdoors_02', 50},
       --     {'Losa pizarra pared', 'prop_ld_peep_slider', 50},
       --     {'Losa bl filos ng', 'prop_necklace_board', 50},
       --     {'Art gallery door left', 'prop_artgallery_02_dl', 150},
       --     {'Art gallery door right', 'prop_artgallery_02_dr', 150},
       --     {'Art gallery 2 door left', 'prop_artgallery_dl', 150},
       --     {'Art gallery 2 door right', 'prop_artgallery_dr', 150},
       --     {'Art gallery 3 door left', 'prop_bh1_44_door_01l', 150},
       --     {'Art gallery 3 door right', 'prop_bh1_44_door_01r', 150},
       --     {'Art gallery 4 door left', 'prop_bh1_48_backdoor_l', 150},
       --     {'Art gallery 4 door right', 'prop_bh1_48_backdoor_r', 150},
       --     {'Art gallery 2 door left', 'prop_artgallery_dl', 150}        
       -- },
    },
    Furnituring = { -- change position of where you buy furniture here.
        ['enter'] = vector3(2751.484375,3474.7934570312,54.79068145752),
        ['teleport'] = vector3(2737.4475097656,3481.3520507812,55.672271728516),
    },

    Offsets = { -- don't mess around with this if you don't know to 110% what you're doing. Seriously! You will screw something up if you change something here
        ['trevor'] = {['door'] = vector3(0.17, -3.51, -1.39), ['storage'] = vector3(0.7475586, 1.476196, -1.398027), ['spawn_furniture'] = vector3(1.046143, 0.06665039, -1.398043)},
        ['lester'] = {['door'] = vector3(-1.58, -5.84, -1.36), ['storage'] = vector3(-0.19, 2.23, -1.36), ['spawn_furniture'] = vector3(3.002892, 0.9969482, -1.359673)},
        ['mansion'] = {['door'] = vector3(-0.6, -5.39, -2.41), ['storage'] = vector3(1.17, 17.20, -2.41), ['spawn_furniture'] = vector3(7.177441, 0.05088806, -2.416786)},
        ['trailer'] = {['door'] = vector3(-1.35, -1.80, -1.47), ['storage'] = vector3(-5.04, -1.28, -1.469), ['spawn_furniture'] = vector3(1.285862, 0.1700745, -1.462135)},
        ['kinda_nice'] = {['door'] = vector3(4.645, -6.389, -2.64418), ['storage'] = vector3(-2.944827, 0.5492249, -0.6442719), ['spawn_furniture'] = vector3(-0.4546165, 2.853912, -0.6442719)},
        ['nice'] = {['door'] = vector3(1.287569, -13.87549, -1.482468), ['storage'] = vector3(-4.280577, -4.621674, -1.476418), ['spawn_furniture'] = vector3(-3.95883, 1.823792, -1.475471)},
        --['dons_house_sm2'] = {['door'] = vector3(2.187569, 2.67549, 1.282468), ['storage'] = vector3(-4.280577, -4.621674, -1.476418), ['spawn_furniture'] = vector3(-3.95883, 1.823792, -1.475471)},
        ['highend'] = {['door'] = vector3(-20.645, -0.389, 6.24418), ['storage'] = vector3(0.64827, 8.0492249, 1.0442719), ['spawn_furniture'] = vector3(-14.645, -0.389, 6.24418)},
        ----------      x-10 pa dentro  de-5 a -0 para el interior lateral    6.6 a 6.0 baja
        ['highendv2'] = {['door'] = vector3(-9.345, 1.009, 0.94418), ['storage'] = vector3(-3.045, 5.489, 0.34418), ['spawn_furniture'] = vector3(4.645, -6.389, 0.34418)},
        ['michael'] = {['door'] = vector3(-8.645, 5.589, -5.04418), ['storage'] = vector3(-6.945, 1.089, -0.44418), ['spawn_furniture'] = vector3(-4.645, 5.589, -5.04418)},
        ['warehouse1'] = {['door'] = vector3(-8.6, 0.1, -1.94418), ['storage'] = vector3(6.6, -3.3, -1.9442719), ['spawn_furniture'] = vector3(-0.4546165, 2.853912, -0.6442719)},
        ['warehouse2'] = {['door'] = vector3(-12.4, 5.5, -3.04418), ['storage'] = vector3(6.6, -8.3, -3.0442719), ['spawn_furniture'] = vector3(-0.4546165, 2.853912, -0.6442719)},
        ['warehouse3'] = {['door'] = vector3(1.845, -1.589, -1.84418), ['storage'] = vector3(-2.544827, 0.5492249, -1.8442719), ['spawn_furniture'] = vector3(-0.4546165, 2.853912, -0.6442719)},
    },
    Houses = { -- ALWAYS add a new house at the bottom of this list. Adding it at the top will just ruin the housing system! If you don't know what you're doing, DON'T DO ANYTHING!
    -- {['prop'] = 'what house prop to use? from the "Props" table above', ['door'] = vector3(x, y, z) - the entrance of the house, ['price'] = 250 000 - the price of the house},
    {['prop'] = 'trevor', ['door'] = vector3(-1112.25, -1578.4, 7.7), ['price'] = 20000 ,['parking']= vector3(-1130.1322021484,-1609.7829589844,4.398425579071)}, -- Casa nº 1        
    {['prop'] = 'trevor', ['door'] = vector3(-1114.34, -1579.47, 7.7), ['price'] = 20000 ,['parking']= vector3(-1128.2849121094,-1612.2543945312,4.3984260559082)}, -- Casa nº 2       
    {['prop'] = 'trevor', ['door'] = vector3(-1114.95, -1577.57, 3.56), ['price'] = 20000 ,['parking']= vector3(-1126.0759277344,-1614.8464355469,4.3984260559082)}, -- Casa nº 3      
    {['prop'] = 'highendv2', ['door'] = vector3(373.9276, 427.8789, 144.7342), ['price'] = 200000 ,['parking']= vector3(391.48184204102,431.11767578125,143.42137145996)}, -- Casa nº 4    

    {['prop'] = 'highend', ['door'] = vector3(346.4424, 440.626, 146.783), ['price'] = 300000 ,['parking']= vector3(355.25119018555,438.8505859375,146.05163574219)}, -- Casa nº 5      
    {['prop'] = 'highendv2', ['door'] = vector3(331.4054, 465.6823, 150.2642), ['price'] = 500000 ,['parking']= vector3(329.62014770508,482.93103027344,150.75535583496)}, -- Casa nº 6  
    {['prop'] = 'highendv2', ['door'] = vector3(316.0714, 501.4787, 152.2298), ['price'] = 500000 ,['parking']= vector3(321.78137207031,496.06384277344,152.37568664551)}, -- Casa nº 7 
    {['prop'] = 'highend', ['door'] = vector3(325.3428, 537.4042, 152.9206), ['price'] = 520000 ,['parking']= vector3(316.77978515625,568.32604980469,154.37532043457)}, -- Casa nº 8   
    {['prop'] = 'highendv2', ['door'] = vector3(223.6483, 513.9971, 139.8171), ['price'] = 500000 ,['parking']= vector3(236.77719116211,530.29376220703,140.69422912598)}, -- Casa nº 9 
    {['prop'] = 'highend', ['door'] = vector3(119.2289, 494.3233, 146.3929), ['price'] = 520000 ,['parking']= vector3(111.45960998535,492.38912963867,147.14788818359)}, -- Casa nº 10
    {['prop'] = 'highend', ['door'] = vector3(80.12486, 485.8678, 147.2517), ['price'] = 520000 ,['parking']= vector3(90.008995056152,486.82681274414,147.69667053223)}, -- Casa nº 11  
    {['prop'] = 'highendv2', ['door'] = vector3(57.87461, 450.0858, 146.0815), ['price'] = 500000 ,['parking']= vector3(65.378189086914,455.86050415039,146.84289550781) }, -- Casa nº 12
    {['prop'] = 'highend', ['door'] = vector3(42.98039, 468.6544, 147.1459), ['price'] = 520000 ,['parking']= vector3(55.220024108887,468.30847167969,146.85949707031) }, -- Casa nº 13     
    {['prop'] = 'highendv2', ['door'] = vector3(-7.608167, 468.3959, 144.9208), ['price'] = 500000 ,['parking']= vector3(1.4072097539902,468.24456787109,145.85925292969) }, -- Casa nº 14
    {['prop'] = 'highendv2', ['door'] = vector3(-66.48237, 490.8036, 143.7423), ['price'] = 500000 ,['parking']= vector3(-75.930587768555,496.1467590332,144.45504760742) }, -- Casa nº 15
    {['prop'] = 'highendv2', ['door'] = vector3(-109.8572, 502.6192, 142.3531), ['price'] = 500000 ,['parking']= vector3(-123.18768310547,508.8786315918,143.04139709473) }, -- Casa nº 16   
    {['prop'] = 'highendv2', ['door'] = vector3(-174.7194, 502.598, 136.4706), ['price'] = 500000 ,['parking']= vector3(-188.51754760742,501.32189941406,134.58892822266) }, -- Casa nº 17    
    {['prop'] = 'highend', ['door'] = vector3(-355.48, 470.10, 112.01), ['price'] = 520000 ,['parking']= vector3(-354.02633666992,474.2262878418,112.67852020264) }, -- Casa nº 18 
    {['prop'] = 'highendv2', ['door'] = vector3(84.8648, 561.972, 181.8175), ['price'] = 500000 ,['parking']= vector3(97.624603271484,565.34417724609,182.70231628418) }, -- Casa nº 19    
    {['prop'] = 'highendv2', ['door'] = vector3(119.0849, 564.5529, 183.0037), ['price'] = 500000 ,['parking']= vector3(131.97787475586,566.96624755859,183.70223999023) }, -- Casa nº 20  
    {['prop'] = 'highend', ['door'] = vector3(215.6454, 620.1937, 186.6673), ['price'] = 520000 ,['parking']= vector3(211.24627685547,608.96032714844,186.98681640625) }, -- Casa nº 21    
    {['prop'] = 'highendv2', ['door'] = vector3(231.9564, 672.4473, 188.9955), ['price'] = 500000 ,['parking']= vector3(227.41354370117,680.90454101563,189.52783203125) }, -- Casa nº 22  
    {['prop'] = 'highendv2', ['door'] = vector3(-230.5478, 488.4593, 127.8175), ['price'] = 500000 ,['parking']= vector3(-247.29075622559,493.86380004883,125.51528167725) }, -- Casa nº 23 
    {['prop'] = 'highend', ['door'] = vector3(-311.922, 474.8206, 110.8724), ['price'] = 520000 ,['parking']= vector3(-316.37261962891,481.04879760742,112.91926574707) }, -- Casa nº 24        
    {['prop'] = 'highendv2', ['door'] = vector3(-166.7201, 424.663, 110.8558), ['price'] = 500000 ,['parking']= vector3(-182.64198303223,420.51733398438,110.76091766357) }, -- Casa nº 25 Puertas cerrada patio          
    {['prop'] = 'highend', ['door'] = vector3(-297.8921, 380.3153, 111.1453), ['price'] = 520000 ,['parking']= vector3(-304.93597412109,380.06216430664,110.33912658691) }, -- Casa nº 26        
    {['prop'] = 'highendv2', ['door'] = vector3(-328.2933, 369.9056, 109.056), ['price'] = 500000 ,['parking']= vector3(-347.1960144043,368.87390136719,110.01035308838) }, -- Casa nº 27
    {['prop'] = 'highendv2', ['door'] = vector3(-371.7889, 344.115, 108.9927), ['price'] = 500000 ,['parking']= vector3(-380.66247558594,345.42810058594,109.24850463867) }, -- Casa nº 28
    {['prop'] = 'highend', ['door'] = vector3(-409.4172, 341.6884, 107.9574), ['price'] = 520000 ,['parking']= vector3(-404.50430297852,337.43041992188,108.71781158447) }, -- Casa nº 29     
    {['prop'] = 'highendv2', ['door'] = vector3(-349.2375, 514.6479, 119.6967), ['price'] = 500000 ,['parking']= vector3(-360.08358764648,514.83166503906,119.7071762085) }, -- Casa nº 30   
    {['prop'] = 'highendv2', ['door'] = vector3(-386.6804, 504.5744, 119.4615), ['price'] = 500000 ,['parking']= vector3(-401.70959472656,510.27465820313,120.20446777344) }, -- Casa nº 31   
    {['prop'] = 'highend', ['door'] = vector3(-406.4875, 567.5134, 123.6529), ['price'] = 520000 ,['parking']= vector3(-409.27532958984,558.47351074219,124.20936584473) }, -- Casa nº 32     
    {['prop'] = 'highend', ['door'] = vector3(-459.1129, 537.521, 120.5068), ['price'] = 520000 ,['parking']= vector3(-469.81024169922,541.27227783203,121.06568145752) }, -- Casa nº 33      
    {['prop'] = 'highendv2', ['door'] = vector3(-500.5503, 552.2289, 119.6605), ['price'] = 500000 ,['parking']= vector3(-481.86669921875,547.84210205078,120.01706695557) }, -- Casa nº 34     
    {['prop'] = 'highendv2', ['door'] = vector3(-520.2657, 594.2166, 119.8867), ['price'] = 500000 ,['parking']= vector3(-521.47760009766,574.40930175781,121.0701751709) }, -- Casa nº 35       
    {['prop'] = 'highendv2', ['door'] = vector3(-475.1374, 585.8268, 127.7334), ['price'] = 500000 ,['parking']= vector3(-480.08782958984,598.06213378906,127.38833618164) }, -- Casa nº 36  
    {['prop'] = 'highendv2', ['door'] = vector3(-559.4098, 664.3816, 144.5066), ['price'] = 500000 ,['parking']= vector3(-555.359375,664.58233642578,145.16757202148) }, -- Casa nº 37  
    {['prop'] = 'highend', ['door'] = vector3(-605.9417, 672.8667, 150.6477), ['price'] = 520000 ,['parking']= vector3(-615.31597900391,677.53002929688,149.82360839844) }, -- Casa nº 38    
    {['prop'] = 'highendv2', ['door'] = vector3(-579.7289, 733.1073, 183.2603), ['price'] = 500000 ,['parking']= vector3(-577.30895996094,741.94354248047,183.87603759766) }, -- Casa nº 39  
    {['prop'] = 'highend', ['door'] = vector3(-655.0796, 803.4769, 198.0419), ['price'] = 520000 ,['parking']= vector3(-661.88824462891,806.59301757813,199.24862670898) }, -- Casa nº 40    
    {['prop'] = 'highendv2', ['door'] = vector3(-746.9131, 808.4435, 214.0801), ['price'] = 500000 ,['parking']= vector3(-748.56506347656,818.19305419922,213.39808654785) }, -- Casa nº 41  
    {['prop'] = 'highendv2', ['door'] = vector3(-597.1287, 851.8281, 210.4842), ['price'] = 500000 ,['parking']= vector3(-609.53112792969,864.9677734375,213.38635253906) }, -- Casa nº 42  
    {['prop'] = 'highend', ['door'] = vector3(-494.424, 795.8174, 183.3934), ['price'] = 520000 ,['parking']= vector3(-485.24096679688,797.70477294922,180.55972290039) }, -- Casa nº 43     
    {['prop'] = 'highend', ['door'] = vector3(-495.4582, 738.9638, 162.0807), ['price'] = 520000 ,['parking']= vector3(-494.93011474609,750.41564941406,162.83097839355) }, -- Casa nº 44    
    {['prop'] = 'highend', ['door'] = vector3(-533.05, 709.0921, 152.1307), ['price'] = 520000 ,['parking']= vector3(-521.76721191406,712.74774169922,152.92044067383) }, -- Casa nº 45       
    {['prop'] = 'highendv2', ['door'] = vector3(-686.1759, 596.119, 142.692), ['price'] = 500000 ,['parking']= vector3(-683.50024414063,602.70806884766,143.55378723145) }, -- Casa nº 46     
    {['prop'] = 'highend', ['door'] = vector3(-732.7767, 594.0862, 141.1908), ['price'] = 520000 ,['parking']= vector3(-743.46600341797,601.642578125,142.08160400391) }, -- Casa nº 47     
    {['prop'] = 'highendv2', ['door'] = vector3(-752.8133, 620.9746, 141.5565), ['price'] = 500000 ,['parking']= vector3(-754.28619384766,627.83294677734,142.65289306641) }, -- Casa nº 48   
    {['prop'] = 'highendv2', ['door'] = vector3(-699.111, 706.7751, 156.9963), ['price'] = 500000 ,['parking']= vector3(-695.81549072266,703.80767822266,157.59094238281) }, -- Casa nº 49
    {['prop'] = 'highendv2', ['door'] = vector3(-476.8588, 648.337, 143.4366), ['price'] = 500000 ,['parking']= vector3(-468.14242553711,647.08721923828,144.18865966797) }, -- Casa nº 50
    {['prop'] = 'highendv2', ['door'] = vector3(-400.0984, 665.4254, 162.8802), ['price'] = 500000 ,['parking']= vector3(-394.02038574219,670.86926269531,163.16954040527) }, -- Casa nº 51  
    {['prop'] = 'highend', ['door'] = vector3(-353.2795, 667.8525, 168.119), ['price'] = 520000 ,['parking']= vector3(-344.92086791992,664.19049072266,169.37789916992) }, -- Casa nº 52      
    {['prop'] = 'highend', ['door'] = vector3(-299.8464, 635.0609, 174.7317), ['price'] = 520000 ,['parking']= vector3(-301.08862304688,632.79016113281,175.6732635498) }, -- Casa nº 53     
    {['prop'] = 'highend', ['door'] = vector3(-293.5298, 601.4299, 180.6255), ['price'] = 520000 ,['parking']= vector3(-275.38961791992,597.5625,181.68298339844) }, -- Casa nº 54    
    {['prop'] = 'highend', ['door'] = vector3(-232.6113, 588.7607, 189.5862), ['price'] = 520000 ,['parking']= vector3(-224.66931152344,592.34948730469,190.24119567871) }, -- Casa nº 55    
    {['prop'] = 'highend', ['door'] = vector3(-189.1341, 617.611, 198.7125), ['price'] = 520000 ,['parking']= vector3(-196.92051696777,616.26495361328,197.39721679688) }, -- Casa nº 56      
    {['prop'] = 'highend', ['door'] = vector3(-185.3076, 591.8223, 196.871), ['price'] = 520000 ,['parking']= vector3(-178.5902557373,584.94769287109,197.62794494629) }, -- Casa nº 57      
    {['prop'] = 'highend', ['door'] = vector3(-126.8265, 588.7379, 203.5668), ['price'] = 520000 ,['parking']= vector3(-143.65867614746,595.66650390625,203.82429504395) }, -- Casa nº 58     
    {['prop'] = 'highendv2', ['door'] = vector3(-527.0712, 517.5832, 111.9912), ['price'] = 500000 ,['parking']= vector3(-525.88421630859,527.76397705078,112.08269500732) }, -- Casa nº 59   
    {['prop'] = 'highend', ['door'] = vector3(-580.6823, 492.388, 107.9512), ['price'] = 520000 ,['parking']= vector3(-575.28942871094,496.27597045898,106.62571716309) }, -- Casa nº 60      
    {['prop'] = 'highend', ['door'] = vector3(-640.7534, 519.7142, 108.7378), ['price'] = 520000 ,['parking']= vector3(-634.15582275391,528.08343505859,109.6877822876) }, -- Casa nº 61     
    {['prop'] = 'highend', ['door'] = vector3(-667.3151, 471.9706, 113.1885), ['price'] = 520000 ,['parking']= vector3(-656.10144042969,489.73358154297,109.7759475708) }, -- Casa nº 62 Puertas cerradas    
    {['prop'] = 'highend', ['door'] = vector3(-678.8621, 511.7292, 112.576), ['price'] = 520000 ,['parking']= vector3(-690.41009521484,510.84429931641,110.36431121826) }, -- Casa nº 63      
    {['prop'] = 'highend', ['door'] = vector3(-718.1337, 449.26, 105.9591), ['price'] = 520000 ,['parking']= vector3(-737.3134765625,443.63854980469,106.86999511719) }, -- Casa nº 64       
    {['prop'] = 'highendv2', ['door'] = vector3(-762.3024, 431.528, 99.22505), ['price'] = 500000 ,['parking']= vector3(-756.42614746094,438.74157714844,99.784950256348) }, -- Casa nº 65    
    {['prop'] = 'highend', ['door'] = vector3(-784.195, 459.1265, 99.22904), ['price'] = 520000 ,['parking']= vector3(-767.25982666016,466.60803222656,100.32098388672) }, -- Casa nº 66      
    {['prop'] = 'michael', ['door'] = vector3(-824.7245, 422.0788, 91.17419), ['price'] = 600000 ,['parking']= vector3(-806.87768554688,426.40927124023,91.58113861084) }, -- Casa nº 67          
    {['prop'] = 'highend', ['door'] = vector3(-843.2042, 466.747, 86.64773), ['price'] = 520000 ,['parking']= vector3(-845.20812988281,460.60961914063,87.785461425781) }, -- Casa nº 68
    {['prop'] = 'highend', ['door'] = vector3(-848.9617, 508.8513, 89.86675), ['price'] = 520000 ,['parking']= vector3(-848.26940917969,520.15991210938,90.622329711914) }, -- Casa nº 69
    {['prop'] = 'highendv2', ['door'] = vector3(-883.8552, 518.0173, 91.49284), ['price'] = 500000 ,['parking']= vector3(-873.42205810547,499.07928466797,90.662712097168) }, -- Casa nº 70    
    {['prop'] = 'highend', ['door'] = vector3(-905.2466, 587.4352, 100.0409), ['price'] = 520000 ,['parking']= vector3(-913.00299072266,586.22467041016,100.84023284912) }, -- Casa nº 71
    {['prop'] = 'highendv2', ['door'] = vector3(-924.6613, 561.777, 98.99629), ['price'] = 500000 ,['parking']= vector3(-934.51489257813,569.96881103516,100.01482391357) }, -- Casa nº 72        
    {['prop'] = 'highend', ['door'] = vector3(-947.9395, 568.2031, 100.5271), ['price'] = 520000 ,['parking']= vector3(-954.0087890625,579.12579345703,100.97731781006) }, -- Casa nº 73
    {['prop'] = 'highendv2', ['door'] = vector3(-974.3864, 582.1178, 101.9781), ['price'] = 500000 ,['parking']= vector3(-986.04113769531,585.94018554688,102.34220123291) }, -- Casa nº 74        
    {['prop'] = 'highendv2', ['door'] = vector3(-1022.67, 587.3645, 102.2835), ['price'] = 500000 ,['parking']= vector3(-1036.5626220703,590.36724853516,103.22273254395) }, -- Casa nº 75         
    {['prop'] = 'highendv2', ['door'] = vector3(-1107.262, 593.9845, 103.504), ['price'] = 500000 ,['parking']= vector3(-1094.1968994141,598.58294677734,103.06462860107) }, -- Casa nº 76         
    {['prop'] = 'highendv2', ['door'] = vector3(-1125.425, 548.6654, 101.6192), ['price'] = 500000 ,['parking']= vector3(-1133.6671142578,549.63043212891,102.27828979492) }, -- Casa nº 77        
    {['prop'] = 'highendv2', ['door'] = vector3(-1146.434, 545.8893, 100.9537), ['price'] = 500000 ,['parking']= vector3(-1166.0919189453,543.02288818359,101.3719329834) }, -- Casa nº 78
    {['prop'] = 'highendv2', ['door'] = vector3(-1193.073, 563.7615, 99.38944), ['price'] = 500000 ,['parking']= vector3(-1209.0753173828,558.61981201172,99.733787536621) }, -- Casa nº 79
    {['prop'] = 'highendv2', ['door'] = vector3(-970.9653, 456.0507, 78.85919), ['price'] = 500000 ,['parking']= vector3(-963.01654052734,442.56317138672,79.809013366699) }, -- Casa nº 80    
    {['prop'] = 'highend', ['door'] = vector3(-967.3018, 510.33, 81.11642), ['price'] = 520000 ,['parking']= vector3(-975.84381103516,525.06646728516,81.471366882324) }, -- Casa nº 81        
    {['prop'] = 'highend', ['door'] = vector3(-987.416, 487.6514, 81.31525), ['price'] = 520000 ,['parking']= vector3(-993.7470703125,489.23025512695,82.266044616699) }, -- Casa nº 82       
    {['prop'] = 'highendv2', ['door'] = vector3(-1052.021, 432.3936, 76.12247), ['price'] = 500000 ,['parking']= vector3(-1064.8806152344,437.17413330078,73.863739013672) }, -- Casa nº 83    
    {['prop'] = 'michael', ['door'] = vector3(-1094.184, 427.4131, 74.93001), ['price'] = 600000 ,['parking']= vector3(-1094.4661865234,439.39889526367,75.286231994629) }, -- Casa nº 84      
    {['prop'] = 'highend', ['door'] = vector3(-1122.763, 485.6832, 81.21085), ['price'] = 520000 ,['parking']= vector3(-1108.6007080078,489.1669921875,82.193153381348) }, -- Casa nº 85          
    {['prop'] = 'highendv2', ['door'] = vector3(-1174.953, 440.3156, 85.89944), ['price'] = 500000 ,['parking']= vector3(-1178.3463134766,455.84951782227,86.666778564453) }, -- Casa nº 86     
    {['prop'] = 'highendv2', ['door'] = vector3(-1215.703, 458.4677, 90.90369), ['price'] = 500000 ,['parking']= vector3(-1230.4733886719,460.40386962891,91.868644714355) }, -- Casa nº 87     
    {['prop'] = 'highendv2', ['door'] = vector3(-1294.423, 454.8558, 96.52876), ['price'] = 500000 ,['parking']= vector3(-1297.8013916016,455.96298217773,97.441741943359) }, -- Casa nº 88
    {['prop'] = 'highendv2', ['door'] = vector3(-1308.194, 449.2641, 100.0198), ['price'] = 500000 ,['parking']= vector3(-1322.8666992188,448.15686035156,99.742164611816) }, -- Casa nº 89
    {['prop'] = 'michael', ['door'] = vector3(-1413.602, 462.2877, 108.2586), ['price'] = 600000 ,['parking']= vector3(-1418.3317871094,467.41372680664,109.32513427734) }, -- Casa nº 90       
    {['prop'] = 'highendv2', ['door'] = vector3(-1404.859, 561.2165, 124.4563), ['price'] = 500000 ,['parking']= vector3(-1412.0223388672,559.61346435547,124.63538360596) }, -- Casa nº 91   
    {['prop'] = 'highendv2', ['door'] = vector3(-1346.742, 560.8566, 129.5815), ['price'] = 500000 ,['parking']= vector3(-1358.8167724609,552.67980957031,130.08599853516) }, -- Casa nº 92 Puertas Cerradas  
    {['prop'] = 'highend', ['door'] = vector3(-1366.825, 611.1692, 132.9559), ['price'] = 520000 ,['parking']= vector3(-1363.5791015625,604.23577880859,133.8879699707) }, -- Casa nº 93       
    {['prop'] = 'highendv2', ['door'] = vector3(-1337.756, 606.1082, 133.4298), ['price'] = 500000 ,['parking']= vector3(-1343.5672607422,611.64562988281,133.74856567383) }, -- Casa nº 94     
    {['prop'] = 'highend', ['door'] = vector3(-1291.722, 650.0664, 140.5513), ['price'] = 520000 ,['parking']= vector3(-1284.8890380859,648.77368164063,139.77207946777) }, -- Casa nº 95       
    {['prop'] = 'highendv2', ['door'] = vector3(-1248.572, 643.0165, 141.7478), ['price'] = 500000 ,['parking']= vector3(-1235.271484375,653.10754394531,142.63572692871) }, -- Casa nº 96     
    {['prop'] = 'highend', ['door'] = vector3(-1241.251, 674.0633, 141.8635), ['price'] = 520000 ,['parking']= vector3(-1246.9495849609,664.40930175781,142.66578674316) }, -- Casa nº 97       
    {['prop'] = 'highendv2', ['door'] = vector3(-1219.116, 665.676, 143.5833), ['price'] = 500000 ,['parking']= vector3(-1222.5982666016,662.37738037109,144.27304077148) }, -- Casa nº 98      
    {['prop'] = 'highend', ['door'] = vector3(-1197.68, 693.6866, 146.4389), ['price'] = 520000 ,['parking']= vector3(-1200.3913574219,689.75189208984,147.13873291016) }, -- Casa nº 99        
    {['prop'] = 'highendv2', ['door'] = vector3(-1165.65, 727.1097, 154.6567), ['price'] = 500000 ,['parking']= vector3(-1159.7321777344,740.24896240234,155.46061706543) }, -- Casa nº 100     
    {['prop'] = 'highend', ['door'] = vector3(-1130.026, 784.1542, 162.937), ['price'] = 520000 ,['parking']= vector3(-1121.4089355469,788.42999267578,162.9864654541) }, -- Casa nº 101       
    {['prop'] = 'highend', ['door'] = vector3(-1100.424, 797.4186, 166.3083), ['price'] = 520000 ,['parking']= vector3(-1107.8796386719,796.11169433594,165.32856750488) }, -- Casa nº 102      
    {['prop'] = 'michael', ['door'] = vector3(-1056.185, 761.7527, 166.3686), ['price'] = 600000 ,['parking']= vector3(-1053.4774169922,768.34204101563,167.64807128906) }, -- Casa nº 103      
    {['prop'] = 'highendv2', ['door'] = vector3(-999.089, 816.4957, 172.0972), ['price'] = 500000 ,['parking']= vector3(-1022.4846191406,812.96588134766,172.15493774414) }, -- Casa nº 104
    {['prop'] = 'highendv2', ['door'] = vector3(-962.6514, 813.8961, 176.6157), ['price'] = 500000 ,['parking']= vector3(-956.64855957031,801.10577392578,177.73753356934) }, -- Casa nº 105
    {['prop'] = 'highendv2', ['door'] = vector3(-912.3673, 777.6082, 186.0594), ['price'] = 500000 ,['parking']= vector3(-904.63934326172,783.50335693359,186.03929138184) }, -- Casa nº 106
    {['prop'] = 'highendv2', ['door'] = vector3(-867.3571, 785.2908, 190.9838), ['price'] = 500000 ,['parking']= vector3(-851.50866699219,792.01477050781,191.80450439453) }, -- Casa nº 107
    {['prop'] = 'highendv2', ['door'] = vector3(-824.0525, 806.0515, 201.8325), ['price'] = 500000 ,['parking']= vector3(-811.02166748047,807.62744140625,202.13700866699) }, -- Casa nº 108
    {['prop'] = 'highendv2', ['door'] = vector3(-1065.278, 727.3835, 164.5246), ['price'] = 500000 ,['parking']= vector3(-1058.3793945313,734.89764404297,165.4497833252) }, -- Casa nº 109
    {['prop'] = 'trevor', ['door'] = vector3(-1019.855, 719.1128, 163.0461), ['price'] = 200000 ,['parking']= vector3(-1005.5734863281,712.81597900391,163.7727355957) }, -- Casa nº 110   
    {['prop'] = 'highendv2', ['door'] = vector3(-931.441, 691.4453, 152.5167), ['price'] = 500000 ,['parking']= vector3(-950.32208251953,686.45361328125,153.57803344727) }, -- Casa nº 111 
    {['prop'] = 'highend', ['door'] = vector3(-908.8556, 693.8784, 150.4861), ['price'] = 520000 ,['parking']= vector3(-914.33605957031,695.28930664063,151.45989990234) }, -- Casa nº 112  
    {['prop'] = 'highendv2', ['door'] = vector3(-885.5114, 699.3257, 150.3199), ['price'] = 500000 ,['parking']= vector3(-873.04254150391,698.54827880859,149.64437866211) }, -- Casa nº 113 Metio un poco en hierba
    {['prop'] = 'highendv2', ['door'] = vector3(-853.5562, 696.3616, 147.8309), ['price'] = 500000 ,['parking']= vector3(-863.41082763672,697.66900634766,149.0375213623) }, -- Casa nº 114
    {['prop'] = 'highendv2', ['door'] = vector3(-819.3509, 696.5077, 147.1542), ['price'] = 500000 ,['parking']= vector3(-808.70709228516,703.66009521484,147.13046264648) }, -- Casa nº 115
    {['prop'] = 'highendv2', ['door'] = vector3(-765.3711, 650.6353, 144.7481), ['price'] = 500000 ,['parking']= vector3(-766.71215820313,666.68414306641,144.67967224121) }, -- Casa nº 116

    {['prop'] = 'trailer', ['door'] = vector3(1777.183, 3737.91, 33.70544), ['price'] = 25000 ,['parking']= vector3(1778.6383056641,3729.4853515625,34.121448516846) }, -- Casa nº 117       
    {['prop'] = 'trailer', ['door'] = vector3(1748.654, 3783.682, 33.88487), ['price'] = 25000 ,['parking']= vector3(1762.564453125,3785.4606933594,33.877815246582) }, -- Casa nº 118      
    {['prop'] = 'trailer', ['door'] = vector3(1639.651, 3731.574, 34.1171), ['price'] = 25000 ,['parking']= vector3(1638.1662597656,3739.4482421875,34.592247009277) }, -- Casa nº 119      
    {['prop'] = 'trailer', ['door'] = vector3(1642.62, 3727.397, 34.1171), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318) }, -- Casa nº 120       
    {['prop'] = 'trailer', ['door'] = vector3(1777.183, 3737.91, 33.70544), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 121 Clonada 117   
    {['prop'] = 'trailer', ['door'] = vector3(1748.654, 3783.682, 33.88487), ['price'] = 5000 ,['parking']=  vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 122 Clonada 118     
    {['prop'] = 'trailer', ['door'] = vector3(1639.651, 3731.574, 34.1171), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 123 Clonada 119      
    {['prop'] = 'trailer', ['door'] = vector3(1642.62, 3727.397, 34.1171), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 124 Clonada 20       
    {['prop'] = 'trailer', ['door'] = vector3(1691.527, 3866.063, 33.95724), ['price'] = 25000 ,['parking']= vector3(1688.4864501953,3855.1923828125,34.828174591064) }, -- Casa nº 125      
    {['prop'] = 'trailer', ['door'] = vector3(1700.339, 3867.13, 33.94835), ['price'] = 25000 ,['parking']= vector3(1707.4487304688,3871.3862304688,34.795124053955) }, -- Casa nº 126      
    {['prop'] = 'trailer', ['door'] = vector3(1733.617, 3895.49, 34.60904), ['price'] = 25000 ,['parking']= vector3(1743.9931640625,3902.8156738281,34.889080047607) }, -- Casa nº 127      
    {['prop'] = 'trailer', ['door'] = vector3(1786.595, 3913.041, 33.96126), ['price'] = 25000 ,['parking']= vector3(1773.607421875,3924.8149414063,34.596717834473) }, -- Casa nº 128 Puerta Cerrada     
    {['prop'] = 'lester', ['door'] = vector3(1803.442, 3913.945, 36.10695), ['price'] = 60000 ,['parking']= vector3(1800.1787109375,3932.3403320313,33.856014251709) }, -- Casa nº 129       
    {['prop'] = 'lester', ['door'] = vector3(1809.081, 3907.696, 32.79611), ['price'] = 60000 ,['parking']= vector3(1800.1787109375,3932.3403320313,33.856014251709) }, -- Casa nº 130       
    {['prop'] = 'trailer', ['door'] = vector3(1838.584, 3907.396, 32.38101), ['price'] = 25000 ,['parking']= vector3(1835.5498046875,3910.1511230469,33.179447174072) }, -- Casa nº 131      
    {['prop'] = 'trailer', ['door'] = vector3(1841.911, 3928.622, 32.77209), ['price'] = 25000 ,['parking']= vector3(1847.6536865234,3930.2490234375,32.930610656738) }, -- Casa nº 132      
    {['prop'] = 'lester', ['door'] = vector3(1880.288, 3920.646, 32.25876), ['price'] = 60000 ,['parking']= vector3(1872.3397216797,3913.9416503906,32.984226226807) }, -- Casa nº 133       
    {['prop'] = 'trailer', ['door'] = vector3(1895.438, 3873.758, 31.80445), ['price'] = 25000 ,['parking']= vector3(1899.0222167969,3873.1687011719,32.453605651855) }, -- Casa nº 134     
    {['prop'] = 'trailer', ['door'] = vector3(1888.475, 3892.893, 32.22338), ['price'] = 25000 ,['parking']= vector3(1894.4584960938,3887.8334960938,32.813529968262) }, -- Casa nº 135      
    {['prop'] = 'lester', ['door'] = vector3(1943.682, 3804.373, 31.08716), ['price'] = 60000 ,['parking']= vector3(1957.9943847656,3795.8647460938,32.310073852539) }, -- Casa nº 136          

    {['prop'] = 'nice', ['door'] = vector3(-374.5138, 6190.958, 30.77954), ['price'] = 150000 ,['parking']= vector3(-378.9006652832,6184.328125,31.490604400635) }, -- Casa nº 137
    {['prop'] = 'nice', ['door'] = vector3(-356.8976, 6207.454, 30.89236), ['price'] = 150000 ,['parking']= vector3(-365.72906494141,6197.421875,31.48849105835) }, -- Casa nº 138
    {['prop'] = 'nice', ['door'] = vector3(-347.4774, 6225.401, 30.93764), ['price'] = 150000 ,['parking']= vector3(-353.6989440918,6220.8666992188,31.488838195801) }, -- Casa nº 139
    {['prop'] = 'nice', ['door'] = vector3(-360.1222, 6260.694, 30.95253), ['price'] = 150000 ,['parking']= vector3(-353.44989013672,6261.595703125,31.497455596924) }, -- Casa nº 140
    {['prop'] = 'nice', ['door'] = vector3(-407.2397, 6314.188, 27.99109), ['price'] = 150000 ,['parking']= vector3(-394.22418212891,6310.4477539063,29.108846664429) }, -- Casa nº 141
    {['prop'] = 'nice', ['door'] = vector3(-359.7261, 6334.635, 28.90011), ['price'] = 150000 ,['parking']= vector3(-365.64645385742,6335.5522460938,29.848659515381) }, -- Casa nº 142
    {['prop'] = 'nice', ['door'] = vector3(-332.5201, 6302.319, 32.1277), ['price'] = 150000 ,['parking']= vector3(-314.681640625,6312.2788085938,32.355121612549) }, -- Casa nº 143
    {['prop'] = 'nice', ['door'] = vector3(-302.2421, 6326.917, 31.93612), ['price'] = 150000 ,['parking']= vector3(-294.57717895508,6338.326171875,32.293807983398) }, -- Casa nº 144
    {['prop'] = 'nice', ['door'] = vector3(-280.5109, 6350.701, 31.64801), ['price'] = 150000 ,['parking']= vector3(-267.54647827148,6354.9672851563,32.490196228027) }, -- Casa nº 145
    {['prop'] = 'nice', ['door'] = vector3(-247.7367, 6370.147, 30.90242), ['price'] = 150000 ,['parking']= vector3(-255.35296630859,6360.5932617188,31.480909347534) }, -- Casa nº 146
    {['prop'] = 'nice', ['door'] = vector3(-227.1403, 6377.43, 30.80915), ['price'] = 150000 ,['parking']= vector3(-217.53060913086,6380.51953125,31.601821899414) }, -- Casa nº 147
    {['prop'] = 'nice', ['door'] = vector3(-272.4501, 6400.943, 30.45621), ['price'] = 150000 ,['parking']= vector3(-265.26162719727,6406.5004882813,30.958665847778) }, -- Casa nº 148
    {['prop'] = 'nice', ['door'] = vector3(-246.1277, 6413.948, 30.50865), ['price'] = 150000 ,['parking']= vector3(-251.59825134277,6409.0185546875,31.159299850464) }, -- Casa nº 149
    {['prop'] = 'nice', ['door'] = vector3(-213.8456, 6396.29, 32.13464), ['price'] = 150000 ,['parking']= vector3(-198.95701599121,6397.5122070313,31.862508773804) }, -- Casa nº 150
    {['prop'] = 'nice', ['door'] = vector3(-188.9336, 6409.466, 31.34684), ['price'] = 150000 ,['parking']= vector3(-186.67640686035,6416.6704101563,31.862508773804) }, -- Casa nº 151
    {['prop'] = 'nice', ['door'] = vector3(-215.0479, 6444.324, 30.36316), ['price'] = 150000 ,['parking']= vector3(-222.68659973145,6434.1411132813,31.197399139404) }, -- Casa nº 152
    {['prop'] = 'nice', ['door'] = vector3(-15.28663, 6557.606, 32.29038), ['price'] = 150000 ,['parking']= vector3(-6.0379519462585,6558.6401367188,31.970933914185) }, -- Casa nº 153
    {['prop'] = 'nice', ['door'] = vector3(4.47418, 6568.086, 32.12141), ['price'] = 150000 ,['parking']= vector3(19.333450317383,6578.4091796875,32.161304473877) }, -- Casa nº 154
    {['prop'] = 'nice', ['door'] = vector3(30.94101, 6596.576, 31.85995), ['price'] = 150000 ,['parking']= vector3(34.858028411865,6605.9443359375,32.458232879639) }, -- Casa nº 155
    {['prop'] = 'nice', ['door'] = vector3(-9.353081, 6654.244, 30.44062), ['price'] = 150000 ,['parking']= vector3(-15.203748703003,6644.9252929688,31.101495742798) }, -- Casa nº 156
    {['prop'] = 'nice', ['door'] = vector3(-41.70464, 6637.401, 30.13669), ['price'] = 150000 ,['parking']= vector3(-51.280727386475,6623.5708007813,29.969053268433) }, -- Casa nº 157             

    {['prop'] = 'lester', ['door'] = vector3(-34.11276, -1846.874, 25.24352), ['price'] = 60000 ,['parking']= vector3(-29.807008743286,-1853.2014160156,25.743362426758) }, -- Casa nº 158
    {['prop'] = 'lester', ['door'] = vector3(-20.60476, -1858.613, 24.45817), ['price'] = 60000 ,['parking']= vector3(-23.603368759155,-1852.7697753906,25.08046913147) }, -- Casa nº 159
    {['prop'] = 'lester', ['door'] = vector3(21.12752, -1844.65, 23.6517), ['price'] = 60000 ,['parking']= vector3(9.8324689865112,-1845.1842041016,24.309623718262) }, -- Casa nº 160
    {['prop'] = 'lester', ['door'] = vector3(-5.167674, -1871.824, 23.20047), ['price'] = 60000 ,['parking']= vector3(-3.2424354553223,-1881.1477050781,23.687061309814) }, -- Casa nº 161
    {['prop'] = 'lester', ['door'] = vector3(4.920843, -1884.344, 22.74725), ['price'] = 60000 ,['parking']= vector3(15.71647644043,-1884.7407226563,23.26780128479) }, -- Casa nº 162
    {['prop'] = 'lester', ['door'] = vector3(46.00618, -1864.281, 22.3283), ['price'] = 60000 ,['parking']= vector3(41.171962738037,-1855.5833740234,22.831546783447) }, -- Casa nº 163
    {['prop'] = 'lester', ['door'] = vector3(23.06887, -1896.687, 22.05284), ['price'] = 60000 ,['parking']= vector3(34.149185180664,-1893.4049072266,22.206426620483) }, -- Casa nº 164
    {['prop'] = 'lester', ['door'] = vector3(54.56005, -1873.202, 21.87974), ['price'] = 60000 ,['parking']= vector3(53.846012115479,-1877.6940917969,22.328313827515) }, -- Casa nº 165 Puertas Cerradas
    {['prop'] = 'lester', ['door'] = vector3(38.99373, -1911.641, 21.0035), ['price'] = 60000 ,['parking']= vector3(42.268634796143,-1920.7210693359,21.66353225708) }, -- Casa nº 166
    {['prop'] = 'lester', ['door'] = vector3(56.53649, -1922.598, 20.96063), ['price'] = 60000 ,['parking']= vector3(68.420097351074,-1922.1204833984,21.305276870728) }, -- Casa nº 167
    {['prop'] = 'lester', ['door'] = vector3(100.8559, -1912.477, 20.45295), ['price'] = 60000 ,['parking']= vector3(80.293403625488,-1906.0301513672,21.389987945557) }, -- Casa nº 168
    {['prop'] = 'lester', ['door'] = vector3(72.05096, -1938.944, 20.41857), ['price'] = 60000 ,['parking']= vector3(80.048881530762,-1932.8276367188,20.734617233276) }, -- Casa nº 169
    {['prop'] = 'lester', ['door'] = vector3(76.55006, -1948.382, 20.22416), ['price'] = 60000 ,['parking']= vector3(90.017158508301,-1935.9908447266,20.627506256104) }, -- Casa nº 170
    {['prop'] = 'lester', ['door'] = vector3(85.69459, -1959.397, 20.17106), ['price'] = 60000 ,['parking']= vector3(90.320320129395,-1965.7541503906,20.747488021851) }, -- Casa nº 171
    {['prop'] = 'lester', ['door'] = vector3(114.5377, -1961.073, 20.36114), ['price'] = 60000 ,['parking']= vector3(102.83544921875,-1956.7619628906,20.746534347534) }, -- Casa nº 172
    {['prop'] = 'lester', ['door'] = vector3(126.5084, -1929.905, 20.43241), ['price'] = 60000 ,['parking']= vector3(119.49432373047,-1940.5902099609,20.70326423645) }, -- Casa nº 173
    {['prop'] = 'lester', ['door'] = vector3(104.0809, -1885.348, 23.36878), ['price'] = 60000 ,['parking']= vector3(104.03220367432,-1881.2805175781,23.961273193359) }, -- Casa nº 174
    {['prop'] = 'lester', ['door'] = vector3(130.7885, -1853.333, 24.32527), ['price'] = 60000 ,['parking']= vector3(127.42183685303,-1857.0419921875,24.846921920776) }, -- Casa nº 175
    {['prop'] = 'lester', ['door'] = vector3(150.0463, -1864.904, 23.63023), ['price'] = 60000 ,['parking']= vector3(138.85191345215,-1868.2520751953,24.221071243286) }, -- Casa nº 176
    {['prop'] = 'lester', ['door'] = vector3(127.7576, -1897.176, 22.71498), ['price'] = 60000 ,['parking']= vector3(139.02073669434,-1894.3605957031,23.555671691895) }, -- Casa nº 177
    {['prop'] = 'lester', ['door'] = vector3(148.6717, -1904.125, 22.54188), ['price'] = 60000 ,['parking']= vector3(160.33456420898,-1899.3034667969,22.944120407104) }, -- Casa nº 178
    {['prop'] = 'lester', ['door'] = vector3(171.315, -1871.397, 23.45023), ['price'] = 60000 ,['parking']= vector3(164.37495422363,-1864.8723144531,24.074571609497) }, -- Casa nº 179
    {['prop'] = 'lester', ['door'] = vector3(192.4514, -1883.452, 24.15228), ['price'] = 60000 ,['parking']= vector3(181.42889404297,-1889.1955566406,23.973411560059) }, -- Casa nº 180
    {['prop'] = 'lester', ['door'] = vector3(179.0855, -1924.264, 20.42102), ['price'] = 60000 ,['parking']= vector3(168.34210205078,-1929.4509277344,21.012613296509) }, -- Casa nº 181
    {['prop'] = 'lester', ['door'] = vector3(165.5446, -1945.026, 19.27414), ['price'] = 60000 ,['parking']= vector3(164.74787902832,-1957.6282958984,19.178895950317) }, -- Casa nº 182
    {['prop'] = 'lester', ['door'] = vector3(148.878, -1960.527, 18.54301), ['price'] = 60000 ,['parking']= vector3(150.11650085449,-1963.8798828125,18.993192672729) }, -- Casa nº 183
    {['prop'] = 'lester', ['door'] = vector3(143.8638, -1968.961, 17.90508), ['price'] = 60000 ,['parking']= vector3(149.08749389648,-1976.0146484375,18.356033325195) }, -- Casa nº 184
    {['prop'] = 'lester', ['door'] = vector3(236.5701, -2045.956, 17.42999), ['price'] = 60000 ,['parking']= vector3(249.29806518555,-2045.6691894531,17.890771865845) }, -- Casa nº 185
    {['prop'] = 'lester', ['door'] = vector3(256.6853, -2023.399, 18.38439), ['price'] = 60000 ,['parking']= vector3(271.24865722656,-2015.8356933594,19.306688308716) }, -- Casa nº 186
    {['prop'] = 'lester', ['door'] = vector3(279.5564, -1993.748, 19.89194), ['price'] = 60000 ,['parking']= vector3(283.09164428711,-2004.4416503906,20.194686889648) }, -- Casa nº 187
    {['prop'] = 'lester', ['door'] = vector3(291.3571, -1980.286, 20.64545), ['price'] = 60000 ,['parking']= vector3(285.81030273438,-1984.9621582031,21.164123535156) }, -- Casa nº 188
    {['prop'] = 'lester', ['door'] = vector3(295.8619, -1971.991, 21.81774), ['price'] = 60000 ,['parking']= vector3(298.72827148438,-1976.4191894531,22.327651977539) }, -- Casa nº 189
    {['prop'] = 'lester', ['door'] = vector3(312.0699, -1956.285, 23.66682), ['price'] = 60000 ,['parking']= vector3(312.57275390625,-1967.6274414063,23.536403656006) }, -- Casa nº 190
    {['prop'] = 'lester', ['door'] = vector3(324.4214, -1937.933, 24.06393), ['price'] = 60000 ,['parking']= vector3(315.71746826172,-1942.7111816406,24.646863937378) }, -- Casa nº 191
    {['prop'] = 'lester', ['door'] = vector3(319.8839, -1854.207, 26.56307), ['price'] = 60000 ,['parking']= vector3(311.64752197266,-1850.2702636719,26.892023086548) }, -- Casa nº 192 Puerta Cerrada
    {['prop'] = 'lester', ['door'] = vector3(329.2549, -1845.749, 26.80143), ['price'] = 60000 ,['parking']= vector3(336.31558227539,-1837.3804931641,27.30740737915) }, -- Casa nº 193
    {['prop'] = 'lester', ['door'] = vector3(339.087, -1829.264, 27.38431), ['price'] = 60000 ,['parking']= vector3(337.72381591797,-1820.4176025391,27.943777084351) }, -- Casa nº 194 Puerta Cerrada
    {['prop'] = 'lester', ['door'] = vector3(348.7708, -1820.528, 27.94409), ['price'] = 60000 ,['parking']= vector3(347.78323364258,-1809.048828125,28.468379974365) }, -- Casa nº 195
    {['prop'] = 'lester', ['door'] = vector3(440.2501, -1829.995, 27.41187), ['price'] = 60000 ,['parking']= vector3(437.55416870117,-1837.5604248047,27.957944869995) }, -- Casa nº 196
    {['prop'] = 'lester', ['door'] = vector3(427.45, -1841.814, 27.50076), ['price'] = 60000 ,['parking']= vector3(428.86395263672,-1852.6462402344,27.520492553711) }, -- Casa nº 197
    {['prop'] = 'lester', ['door'] = vector3(412.5543, -1856.125, 26.37176), ['price'] = 60000 ,['parking']= vector3(400.52279663086,-1854.3784179688,26.779949188232) }, -- Casa nº 198
    {['prop'] = 'lester', ['door'] = vector3(399.5801, -1864.591, 25.76936), ['price'] = 60000 ,['parking']= vector3(397.51110839844,-1875.4483642578,26.267873764038) }, -- Casa nº 199
    {['prop'] = 'lester', ['door'] = vector3(385.0557, -1881.49, 25.0861), ['price'] = 60000 ,['parking']= vector3(385.34118652344,-1893.7326660156,25.093370437622) }, -- Casa nº 200
    {['prop'] = 'lester', ['door'] = vector3(495.3709, -1823.458, 27.91969), ['price'] = 60000 ,['parking']= vector3(481.91775512695,-1822.2839355469,27.921041488647) }, -- Casa nº 201
    {['prop'] = 'lester', ['door'] = vector3(512.5225, -1790.433, 27.9695), ['price'] = 60000 ,['parking']= vector3(502.58306884766,-1798.4112548828,28.485410690308) }, -- Casa nº 202
    {['prop'] = 'lester', ['door'] = vector3(472.1762, -1775.283, 28.11979), ['price'] = 60000 ,['parking']= vector3(477.48107910156,-1777.4632568359,28.66817855835) }, -- Casa nº 203
    {['prop'] = 'lester', ['door'] = vector3(479.3728, -1735.732, 28.20037), ['price'] = 60000 ,['parking']= vector3(492.57272338867,-1730.0178222656,29.18074798584) }, -- Casa nº 204
    {['prop'] = 'lester', ['door'] = vector3(489.6817, -1713.973, 28.72012), ['price'] = 60000 ,['parking']= vector3(484.96188354492,-1720.1784667969,29.415044784546) }, -- Casa nº 205
    {['prop'] = 'lester', ['door'] = vector3(500.4488, -1697.029, 28.82996), ['price'] = 60000 ,['parking']= vector3(498.28903198242,-1703.1694335938,29.36874961853) }, -- Casa nº 206
    {['prop'] = 'lester', ['door'] = vector3(405.3066, -1751.105, 28.76036), ['price'] = 60000 ,['parking']= vector3(403.41027832031,-1741.0010986328,29.29786491394) }, -- Casa nº 207
    {['prop'] = 'lester', ['door'] = vector3(419.1456, -1735.932, 28.65644), ['price'] = 60000 ,['parking']= vector3(427.74041748047,-1733.4475097656,29.246936798096) }, -- Casa nº 208
    {['prop'] = 'lester', ['door'] = vector3(431.0881, -1725.809, 28.65146), ['price'] = 60000 ,['parking']= vector3(431.47445678711,-1714.7124023438,29.409513473511) }, -- Casa nº 209
    {['prop'] = 'lester', ['door'] = vector3(443.4124, -1707.244, 28.75729), ['price'] = 60000 ,['parking']= vector3(441.986328125,-1694.8795166016,29.285037994385) }, -- Casa nº 210
    {['prop'] = 'lester', ['door'] = vector3(332.9239, -1741.041, 28.78052), ['price'] = 60000 ,['parking']= vector3(323.11236572266,-1744.1278076172,29.37038230896) }, -- Casa nº 211
    {['prop'] = 'lester', ['door'] = vector3(320.8559, -1760.215, 28.68788), ['price'] = 60000 ,['parking']= vector3(321.30426025391,-1770.6873779297,28.790952682495) }, -- Casa nº 212
    {['prop'] = 'lester', ['door'] = vector3(304.5139, -1775.368, 28.20438), ['price'] = 60000 ,['parking']= vector3(312.36199951172,-1783.2436523438,28.301889419556) }, -- Casa nº 213
    {['prop'] = 'lester', ['door'] = vector3(300.0052, -1784.345, 27.48622), ['price'] = 60000 ,['parking']= vector3(295.07260131836,-1789.1149902344,27.976638793945) }, -- Casa nº 214
    {['prop'] = 'lester', ['door'] = vector3(288.7145, -1792.512, 27.16629), ['price'] = 60000 ,['parking']= vector3(287.83657836914,-1802.4100341797,27.192182540894) }, -- Casa nº 215
    {['prop'] = 'lester', ['door'] = vector3(198.1999, -1725.602, 28.71232), ['price'] = 60000 ,['parking']= vector3(210.29949951172,-1729.9544677734,29.130792617798) }, -- Casa nº 216
    {['prop'] = 'lester', ['door'] = vector3(216.5622, -1717.307, 28.72634), ['price'] = 60000 ,['parking']= vector3(210.20190429688,-1730.1680908203,29.115007400513) }, -- Casa nº 217
    {['prop'] = 'lester', ['door'] = vector3(249.6055, -1730.614, 28.72248), ['price'] = 60000 ,['parking']= vector3(245.68423461914,-1730.9702148438,29.345010757446) }, -- Casa nº 218
    {['prop'] = 'lester', ['door'] = vector3(223.0704, -1702.961, 28.74216), ['price'] = 60000 ,['parking']= vector3(225.20172119141,-1706.7469482422,29.288175582886) }, -- Casa nº 219
    {['prop'] = 'lester', ['door'] = vector3(257.2826, -1723.159, 28.70379), ['price'] = 60000 ,['parking']= vector3(263.41516113281,-1718.2706298828,29.284990310669) }, -- Casa nº 220
    {['prop'] = 'lester', ['door'] = vector3(269.3036, -1712.88, 28.7173), ['price'] = 60000 ,['parking']= vector3(271.21771240234,-1703.0068359375,29.329833984375) }, -- Casa nº 221
    {['prop'] = 'lester', ['door'] = vector3(252.8022, -1670.621, 28.71316), ['price'] = 60000 ,['parking']= vector3(254.77529907227,-1682.4830322266,29.203681945801) }, -- Casa nº 222
    {['prop'] = 'lester', ['door'] = vector3(240.7752, -1687.924, 28.73524), ['price'] = 60000 ,['parking']= vector3(241.49864196777,-1699.29296875,29.17103767395) }, -- Casa nº 223 

    {['prop'] = 'trevor', ['door'] = vector3(1060.572, -378.3963, 67.28117), ['price'] = 200000 ,['parking']= vector3(1056.7916259766,-386.73004150391,67.853446960449) }, -- Casa nº 224
    {['prop'] = 'trevor', ['door'] = vector3(1029.075, -408.5787, 65.17527), ['price'] = 200000 ,['parking']= vector3(1020.7876586914,-416.3034362793,65.94645690918) }, -- Casa nº 225 
    {['prop'] = 'kinda_nice', ['door'] = vector3(206.35, -86.00, 68.48), ['price'] = 100000 ,['parking']= vector3(206.23149108887,-75.521141052246,68.84693145752) }, -- Casa nº 226 
    {['prop'] = 'trevor', ['door'] = vector3(1010.519, -423.3441, 64.39827), ['price'] = 200000 ,['parking']= vector3(1016.322265625,-422.88827514648,65.041687011719) }, -- Casa nº 227 
    {['prop'] = 'nice', ['door'] = vector3(1014.429, -469.0127, 63.55713), ['price'] = 150000 ,['parking']= vector3(1021.2312011719,-463.01776123047,63.903842926025) }, -- Casa nº 228
    {['prop'] = 'trevor', ['door'] = vector3(987.8522, -433.5852, 62.94143), ['price'] = 200000 ,['parking']= vector3(990.15020751953,-436.81448364258,63.738052368164) }, -- Casa nº 229 
    {['prop'] = 'trevor', ['door'] = vector3(967.1243, -451.5814, 61.8442), ['price'] = 200000 ,['parking']= vector3(974.72937011719,-452.32385253906,62.402786254883) }, -- Casa nº 230  
    {['prop'] = 'trevor', ['door'] = vector3(970.1669, -502.1628, 61.19075), ['price'] = 200000 ,['parking']= vector3(961.31939697266,-501.0012512207,61.476371765137) }, -- Casa nº 231 
    {['prop'] = 'nice', ['door'] = vector3(943.9504, -463.3438, 60.44574), ['price'] = 150000 ,['parking']= vector3(941.75225830078,-466.95559692383,61.252319335938) }, -- Casa nº 232
    {['prop'] = 'trevor', ['door'] = vector3(945.9931, -518.9095, 59.66811), ['price'] = 200000 ,['parking']= vector3(948.83978271484,-513.96130371094,60.233631134033) }, -- Casa nº 233
    {['prop'] = 'trevor', ['door'] = vector3(921.9142, -478.1666, 60.13361), ['price'] = 200000 ,['parking']= vector3(932.48132324219,-479.06732177734,60.696594238281) }, -- Casa nº 234
    {['prop'] = 'nice', ['door'] = vector3(906.4796, -490.0975, 58.48627), ['price'] = 150000 ,['parking']= vector3(911.70025634766,-484.03207397461,59.037811279297) }, -- Casa nº 235
    {['prop'] = 'lester', ['door'] = vector3(878.5616, -498.1047, 57.14323), ['price'] = 150000 ,['parking']= vector3(874.45642089844,-506.18246459961,57.497657775879) }, -- Casa nº 236
    {['prop'] = 'trevor', ['door'] = vector3(862.4706, -509.7612, 56.37899), ['price'] = 200000 ,['parking']= vector3(855.10522460938,-518.27044677734,57.302375793457) }, -- Casa nº 237
    {['prop'] = 'trevor', ['door'] = vector3(850.8226, -532.6475, 56.97535), ['price'] = 200000 ,['parking']= vector3(849.10296630859,-542.13415527344,57.325695037842) }, -- Casa nº 238
    {['prop'] = 'trevor', ['door'] = vector3(893.1567, -540.6183, 57.5565), ['price'] = 200000 ,['parking']= vector3(890.92999267578,-551.48797607422,58.174194335938) }, -- Casa nº 239 Puertas Cerradas
    {['prop'] = 'nice', ['door'] = vector3(844.0634, -563.1956, 56.88387), ['price'] = 150000 ,['parking']= vector3(848.55572509766,-566.44317626953,57.707931518555) }, -- Casa nº 240
    {['prop'] = 'trevor', ['door'] = vector3(861.7772, -583.1914, 57.20606), ['price'] = 200000 ,['parking']= vector3(871.61206054688,-590.24578857422,58.060806274414) }, -- Casa nº 241
    {['prop'] = 'trevor', ['door'] = vector3(886.8757, -608.0862, 57.49291), ['price'] = 200000 ,['parking']= vector3(873.38488769531,-599.64508056641,58.207805633545) }, -- Casa nº 242
    {['prop'] = 'nice', ['door'] = vector3(903.2582, -615.666, 57.50368), ['price'] = 150000 ,['parking']= vector3(915.02740478516,-628.21765136719,58.048984527588) }, -- Casa nº 243 Puertas Cerradas
    {['prop'] = 'trevor', ['door'] = vector3(928.9735, -639.6768, 57.28987), ['price'] = 200000 ,['parking']= vector3(915.72174072266,-641.56304931641,57.863227844238) }, -- Casa nº 244
    {['prop'] = 'trevor', ['door'] = vector3(943.517, -653.4185, 57.47094), ['price'] = 200000 ,['parking']= vector3(948.67944335938,-655.01580810547,58.025115966797) }, -- Casa nº 245
    {['prop'] = 'nice', ['door'] = vector3(960.4077, -669.749, 57.49975), ['price'] = 150000 ,['parking']= vector3(948.45928955078,-667.77514648438,58.011478424072) }, -- Casa nº 246
    {['prop'] = 'trevor', ['door'] = vector3(970.8856, -701.3883, 57.53193), ['price'] = 200000 ,['parking']= vector3(971.71099853516,-686.95294189453,57.841342926025) }, -- Casa nº 247
    {['prop'] = 'trevor', ['door'] = vector3(979.3055, -716.3039, 57.26874), ['price'] = 200000 ,['parking']= vector3(978.67468261719,-711.68951416016,57.744216918945) }, -- Casa nº 248
    {['prop'] = 'lester', ['door'] = vector3(997.1113, -729.2736, 56.86407), ['price'] = 150000 ,['parking']= vector3(1006.4658203125,-732.28167724609,57.583251953125) }, -- Casa nº 249
    {['prop'] = 'trevor', ['door'] = vector3(1090.007, -484.2412, 64.71036), ['price'] = 200000 ,['parking']= vector3(1086.2509765625,-494.51049804688,64.615432739258) }, -- Casa nº 250
    {['prop'] = 'trevor', ['door'] = vector3(1098.587, -464.7038, 66.36903), ['price'] = 200000 ,['parking']= vector3(1098.2919921875,-473.00579833984,66.93677520752) }, -- Casa nº 251
    {['prop'] = 'trevor', ['door'] = vector3(1099.411, -438.3408, 66.83294), ['price'] = 200000 ,['parking']= vector3(1099.6264648438,-429.13973999023,67.392044067383) }, -- Casa nº 252
    {['prop'] = 'trevor', ['door'] = vector3(1100.837, -411.4033, 66.60183), ['price'] = 200000 ,['parking']= vector3(1102.7260742188,-418.64794921875,67.153442382813) }, -- Casa nº 253 
    {['prop'] = 'trevor', ['door'] = vector3(1046.235, -497.9067, 63.12947), ['price'] = 200000 ,['parking']= vector3(1050.8640136719,-487.98364257813,63.924579620361) }, -- Casa nº 254
    {['prop'] = 'trevor', ['door'] = vector3(1051.85, -470.5256, 62.94894), ['price'] = 200000 ,['parking']= vector3(1049.1296386719,-481.43438720703,63.876304626465) }, -- Casa nº 255 
    {['prop'] = 'trevor', ['door'] = vector3(1056.177, -448.8858, 65.30746), ['price'] = 200000 ,['parking']= vector3(1056.5694580078,-444.71279907227,65.952079772949) }, -- Casa nº 256
    {['prop'] = 'trevor', ['door'] = vector3(964.1451, -596.0469, 58.95258), ['price'] = 200000 ,['parking']= vector3(954.61486816406,-598.18817138672,59.374118804932) }, -- Casa nº 257
    {['prop'] = 'trevor', ['door'] = vector3(976.3569, -579.2255, 58.68561), ['price'] = 200000 ,['parking']= vector3(984.212890625,-575.6572265625,59.284717559814) }, -- Casa nº 258
    {['prop'] = 'trevor', ['door'] = vector3(1009.913, -572.3914, 59.64314), ['price'] = 200000 ,['parking']= vector3(1008.7536010742,-563.12322998047,60.199478149414) }, -- Casa nº 259
    {['prop'] = 'trevor', ['door'] = vector3(1229.286, -725.4603, 59.84467), ['price'] = 200000 ,['parking']= vector3(1225.1165771484,-726.58703613281,60.583267211914) }, -- Casa nº 260
    {['prop'] = 'trevor', ['door'] = vector3(1222.598, -697.0645, 59.85625), ['price'] = 200000 ,['parking']= vector3(1223.1317138672,-704.15270996094,60.706119537354) }, -- Casa nº 261
    {['prop'] = 'trevor', ['door'] = vector3(1221.362, -669.0397, 62.54292), ['price'] = 200000 ,['parking']= vector3(1216.6567382813,-665.38555908203,62.834651947021) }, -- Casa nº 262
    {['prop'] = 'trevor', ['door'] = vector3(1206.818, -620.2753, 65.48862), ['price'] = 200000 ,['parking']= vector3(1203.0036621094,-613.01403808594,65.91332244873) }, -- Casa nº 263
    {['prop'] = 'trevor', ['door'] = vector3(1200.939, -575.8315, 68.18923), ['price'] = 200000 ,['parking']= vector3(1187.1131591797,-572.18218994141,64.334457397461) }, -- Casa nº 264 
    {['prop'] = 'trevor', ['door'] = vector3(1241.924, -566.2299, 68.70738), ['price'] = 200000 ,['parking']= vector3(1243.4920654297,-578.1171875,69.355758666992) }, -- Casa nº 265
    {['prop'] = 'trevor', ['door'] = vector3(1240.51, -601.5778, 68.8327), ['price'] = 200000 ,['parking']= vector3(1244.5642089844,-585.88897705078,69.25244140625) }, -- Casa nº 266  
    {['prop'] = 'trevor', ['door'] = vector3(1251.304, -621.6561, 68.46317), ['price'] = 200000 ,['parking']= vector3(1254.4077148438,-624.4375,69.351860046387) }, -- Casa nº 267
    {['prop'] = 'trevor', ['door'] = vector3(1265.587, -648.3523, 66.97227), ['price'] = 200000 ,['parking']= vector3(1271.4104003906,-658.45300292969,67.740684509277) }, -- Casa nº 268     
    {['prop'] = 'trevor', ['door'] = vector3(1270.994, -683.5013, 65.08128), ['price'] = 200000 ,['parking']= vector3(1273.189453125,-672.6904296875,65.874908447266) }, -- Casa nº 269     
    {['prop'] = 'trevor', ['door'] = vector3(1265.157, -703.1201, 63.61639), ['price'] = 200000 ,['parking']= vector3(1262.1021728516,-715.50903320313,64.524841308594) }, -- Casa nº 270     
    {['prop'] = 'trevor', ['door'] = vector3(1251.326, -515.734, 68.39915), ['price'] = 200000 ,['parking']= vector3(1250.6003417969,-522.99945068359,68.974937438965) }, -- Casa nº 271      
    {['prop'] = 'trevor', ['door'] = vector3(1251.593, -494.1618, 68.95689), ['price'] = 200000 ,['parking']= vector3(1259.2745361328,-493.14175415039,69.429046630859) }, -- Casa nº 272     
    {['prop'] = 'trevor', ['door'] = vector3(1260.582, -479.6108, 69.23888), ['price'] = 200000 ,['parking']= vector3(1277.9285888672,-480.22180175781,68.947959899902) }, -- Casa nº 273     
    {['prop'] = 'trevor', ['door'] = vector3(1266.292, -457.9033, 69.5667), ['price'] = 200000 ,['parking']= vector3(1271.6635742188,-453.30841064453,69.512413024902) }, -- Casa nº 274      
    {['prop'] = 'trevor', ['door'] = vector3(1263.196, -429.3719, 68.85603), ['price'] = 200000 ,['parking']= vector3(1259.0661621094,-419.84158325195,69.427040100098) }, -- Casa nº 275     
    {['prop'] = 'kinda_nice', ['door'] = vector3(291.41, -1078.54, 28.5), ['price'] = 100000 ,['parking']= vector3(295.12582397461,-1084.3724365234,29.402387619019) }, -- Casa nº 276        
    {['prop'] = 'kinda_nice', ['door'] = vector3(288.64, -1095.16, 28.5), ['price'] = 100000 ,['parking']= vector3(295.45684814453,-1099.8857421875,29.403909683228) }, -- Casa nº 277    
    {['prop'] = 'kinda_nice', ['door'] = vector3(278.91, -1117.96, 28.5), ['price'] = 100000 ,['parking']= vector3(267.63040161133,-1122.7191162109,29.217861175537) }, -- Casa nº 278    
    {['prop'] = 'kinda_nice', ['door'] = vector3(185.25, -1078.06, 28.3), ['price'] = 100000 ,['parking']= vector3(195.93951416016,-1063.7733154297,29.296558380127) }, -- Casa nº 279    
    {['prop'] = 'kinda_nice', ['door'] = vector3(92.65, 49.37, 72.60), ['price'] = 100000 ,['parking']= vector3(116.44297027588,33.894134521484,73.52025604248) }, -- Casa nº 280       
    {['prop'] = 'kinda_nice', ['door'] = vector3(9.20, 52.91, 70.70), ['price'] = 100000 ,['parking']= vector3(-12.172581672668,39.04944229126,71.693992614746) }, -- Casa nº 281       
    {['prop'] = 'kinda_nice', ['door'] = vector3(148.39, -1113.64, 28.40), ['price'] = 100000 ,['parking']= vector3(151.00450134277,-1120.3881835938,29.335424423218) }, -- Casa nº 282  
    {['prop'] = 'kinda_nice', ['door'] = vector3(76.20, -86.64, 62.1), ['price'] = 100000 ,['parking']= vector3(82.520393371582,-80.487373352051,62.433586120605) }, -- Casa nº 283
    {['prop'] = 'kinda_nice', ['door'] = vector3(202.36, -133.06, 62.59), ['price'] = 100000 ,['parking']= vector3(191.36907958984,-119.97430419922,63.354858398438) }, -- Casa nº 284   
    {['prop'] = 'kinda_nice', ['door'] = vector3(127.26, -107.79, 59.70), ['price'] = 100000 ,['parking']= vector3(114.67010498047,-98.02222442627,60.821460723877) }, -- Casa nº 285            

    {['prop'] = 'lester', ['door'] = vector3(341.63, 2614.91, 44.67), ['price'] = 60000 ,['parking']= vector3(337.08099365234,2619.4562988281,44.497161865234) }, -- Casa nº 286
    {['prop'] = 'lester', ['door'] = vector3(347.09, 2618.07, 44.67), ['price'] = 60000 ,['parking']= vector3(341.74642944336,2622.9699707031,44.507427215576) }, -- Casa nº 287
    {['prop'] = 'lester', ['door'] = vector3(354.46, 2619.91, 44.67), ['price'] = 60000 ,['parking']= vector3(349.0944519043,2624.3029785156,44.500026702881) }, -- Casa nº 288
    {['prop'] = 'lester', ['door'] = vector3(359.79, 2622.79, 44.67), ['price'] = 60000 ,['parking']= vector3(354.74890136719,2626.6047363281,44.497459411621) }, -- Casa nº 289
    {['prop'] = 'lester', ['door'] = vector3(367.15, 2624.47, 44.67), ['price'] = 60000 ,['parking']= vector3(361.88153076172,2628.5268554688,44.497730255127) }, -- Casa nº 290
    {['prop'] = 'lester', ['door'] = vector3(372.56, 2627.59, 44.67), ['price'] = 60000 ,['parking']= vector3(367.37307739258,2631.3449707031,44.498210906982) }, -- Casa nº 291 
    {['prop'] = 'lester', ['door'] = vector3(379.87, 2629.23, 44.67), ['price'] = 60000 ,['parking']= vector3(374.80764770508,2632.9448242188,44.498401641846) }, -- Casa nº 292
    {['prop'] = 'lester', ['door'] = vector3(385.26, 2632.34, 44.67), ['price'] = 60000 ,['parking']= vector3(380.01754760742,2635.8239746094,44.497444152832) }, -- Casa nº 293 
    {['prop'] = 'lester', ['door'] = vector3(392.57, 2634.04, 44.67), ['price'] = 60000 ,['parking']= vector3(387.22790527344,2637.9353027344,44.496913909912) }, -- Casa nº 294  
    {['prop'] = 'lester', ['door'] = vector3(397.98, 2637.16, 44.67), ['price'] = 60000 ,['parking']= vector3(392.84286499023,2641.1057128906,44.494674682617) }, -- Casa nº 295
    {['prop'] = 'lester', ['door'] = vector3(1142.42, 2654.71, 38.15), ['price'] = 60000 ,['parking']= vector3(1137.5400390625,2663.1970214844,38.0041847229) }, -- Casa nº 296
    {['prop'] = 'lester', ['door'] = vector3(166.81, 2228.98, 90.78), ['price'] = 60000 ,['parking']= vector3(161.42805480957,2235.6135253906,90.18936920166) }, -- Casa nº 297  
    {['prop'] = 'kinda_nice', ['door'] = vector3(206.36, -86.00, 68.48), ['price'] = 100000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318) }, -- Casa nº 298 duplicado
    {['prop'] = 'kinda_nice', ['door'] = vector3(253.52, -343.83, 44.52), ['price'] = 100000 ,['parking']= vector3(267.15972900391,-332.37411499023,44.919872283936) }, -- Casa nº 299
    {['prop'] = 'kinda_nice', ['door'] = vector3(97.80, -256.37, 54.60), ['price'] = 100000 ,['parking']= vector3(91.801567077637,-284.55072021484,46.616352081299) }, -- Casa nº 300   
    {['prop'] = 'kinda_nice', ['door'] = vector3(105.33, -259.02, 54.60), ['price'] = 100000 ,['parking']= vector3(91.801567077637,-284.55072021484,46.616352081299) }, -- Casa nº 301  
    {['prop'] = 'kinda_nice', ['door'] = vector3(97.79, -256.30, 50.60), ['price'] = 100000 ,['parking']= vector3(91.801567077637,-284.55072021484,46.616352081299) }, -- Casa nº 302         
    {['prop'] = 'kinda_nice', ['door'] = vector3(105.39, -259.01, 50.60), ['price'] = 100000 ,['parking']= vector3(91.801567077637,-284.55072021484,46.616352081299) }, -- Casa nº 303         
    {['prop'] = 'kinda_nice', ['door'] = vector3(97.83, -256.24, 46.59), ['price'] = 100000 ,['parking']= vector3(91.801567077637,-284.55072021484,46.616352081299) }, -- Casa nº 304        
    {['prop'] = 'kinda_nice', ['door'] = vector3(144.23, -278.43, 49.55), ['price'] = 100000 ,['parking']= vector3(145.85234069824,-299.33441162109,45.840690612793) }, -- Casa nº 305     
    {['prop'] = 'kinda_nice', ['door'] = vector3(8.76, -243.15, 46.76), ['price'] = 100000 ,['parking']= vector3(24.673080444336,-240.56907653809,47.838272094727) }, -- Casa nº 306    
    {['prop'] = 'kinda_nice', ['door'] = vector3(-30.57, -347.12, 45.64), ['price'] = 100000 ,['parking']= vector3(-24.717885971069,-343.64193725586,43.157417297363) }, -- Casa nº 307    
    {['prop'] = 'kinda_nice', ['door'] = vector3(67.43, -103.64, 57.74), ['price'] = 100000 ,['parking']= vector3(83.063720703125,-101.52721405029,59.052116394043) }, -- Casa nº 308     
    {['prop'] = 'kinda_nice', ['door'] = vector3(76.20, -86.57, 62.10), ['price'] = 100000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318) }, -- Casa nº 309 Duplicada con Nº283     
    {['prop'] = 'kinda_nice', ['door'] = vector3(127.45, -107.80, 59.72), ['price'] = 100000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318) }, -- Casa nº 310 Duplicada Nº284   
    {['prop'] = 'kinda_nice', ['door'] = vector3(224.71, -160.79, 58.36), ['price'] = 100000 ,['parking']= vector3(229.8639831543,-161.27253723145,58.758152008057) }, -- Casa nº 311    
    {['prop'] = 'kinda_nice', ['door'] = vector3(137.3, -72.00, 67.16), ['price'] = 100000 ,['parking']= vector3(127.6160736084,-60.486064910889,67.51831817627) }, -- Casa nº 312      
    {['prop'] = 'kinda_nice', ['door'] = vector3(289.56, -159.58, 63.72), ['price'] = 100000 ,['parking']= vector3(281.12640380859,-146.59574890137,65.101875305176) }, -- Casa nº 313    
    {['prop'] = 'kinda_nice', ['door'] = vector3(314.96, -128.27, 69.08), ['price'] = 100000 ,['parking']= vector3(334.18634033203,-128.89761352539,67.098609924316) }, -- Casa nº 314    
    {['prop'] = 'kinda_nice', ['door'] = vector3(352.52, -142.78, 65.79), ['price'] = 100000 ,['parking']= vector3(350.041015625,-136.65992736816,65.191070556641) }, -- Casa nº 315   

    {['prop'] = 'trailer', ['door'] = vector3(52.05, 3742.14, 40.29), ['price'] = 25000 ,['parking']= vector3(55.833141326904,3740.7312011719,39.704605102539) }, -- Casa nº 316
    {['prop'] = 'trailer', ['door'] = vector3(30.98, 3736.12, 40.63), ['price'] = 25000 ,['parking']= vector3(27.370904922485,3731.0021972656,39.659873962402) }, -- Casa nº 317
    {['prop'] = 'trailer', ['door'] = vector3(15.26, 3688.91, 40.2), ['price'] = 25000 ,['parking']= vector3(20.201555252075,3684.6618652344,39.653617858887) }, -- Casa nº 318
    {['prop'] = 'trailer', ['door'] = vector3(101.05, 3652.67, 40.64), ['price'] = 25000 ,['parking']= vector3(105.31446838379,3649.5222167969,39.754875183105) }, -- Casa nº 319
    {['prop'] = 'trailer', ['door'] = vector3(97.86, 3682.03, 39.74), ['price'] = 25000 ,['parking']= vector3(99.199256896973,3688.7561035156,39.705074310303) }, -- Casa nº 320
    {['prop'] = 'trailer', ['door'] = vector3(105.74, 3728.51, 40.47), ['price'] = 25000 ,['parking']= vector3(110.46800994873,3722.06640625,39.568912506104) }, -- Casa nº 321
    {['prop'] = 'trailer', ['door'] = vector3(76.11, 3757.33, 39.75), ['price'] = 25000 ,['parking']= vector3(81.788917541504,3749.8374023438,39.737197875977) }, -- Casa nº 322
    {['prop'] = 'trailer', ['door'] = vector3(78.02, 3732.59, 40.27), ['price'] = 25000 ,['parking']= vector3(83.182510375977,3731.3435058594,39.607749938965) }, -- Casa nº 323
    {['prop'] = 'trailer', ['door'] = vector3(84.71, 3718.04, 40.33), ['price'] = 25000 ,['parking']= vector3(94.179695129395,3714.9140625,39.604801177979) }, -- Casa nº 324
    {['prop'] = 'trailer', ['door'] = vector3(68.03, 3693.16, 40.64), ['price'] = 25000 ,['parking']= vector3(65.244239807129,3699.5036621094,39.754993438721) }, -- Casa nº 325
    {['prop'] = 'trailer', ['door'] = vector3(47.68, 3701.99, 40.72), ['price'] = 25000 ,['parking']= vector3(51.035377502441,3707.3481445313,39.755023956299) }, -- Casa nº 326
    {['prop'] = 'trailer', ['door'] = vector3(361.67, 2977.08, 41.84), ['price'] = 25000 ,['parking']= vector3(373.64721679688,2985.4079589844,40.8740234375) },-- Casa nº 327
    {['prop'] = 'trailer', ['door'] = vector3(412.56, 2965.25, 41.89), ['price'] = 25000 ,['parking']= vector3(403.48764038086,2959.591796875,41.011207580566) },-- Casa nº 328
    {['prop'] = 'trailer', ['door'] = vector3(436.42, 2996.18, 41.28), ['price'] = 25000 ,['parking']= vector3(419.89450073242,2987.2651367188,40.793972015381) },-- Casa nº 329
    {['prop'] = 'trailer', ['door'] = vector3(348.39, 2565.88, 43.52), ['price'] = 25000 ,['parking']= vector3(344.53002929688,2558.7448730469,43.576583862305) },-- Casa nº 330 
    {['prop'] = 'trailer', ['door'] = vector3(367.14, 2571.46, 44.53), ['price'] = 25000 ,['parking']= vector3(360.87493896484,2584.2951660156,43.51957321167) },-- Casa nº 331 
    {['prop'] = 'trailer', ['door'] = vector3(382.82, 2576.57, 44.53), ['price'] = 25000 ,['parking']= vector3(375.73580932617,2577.8073730469,43.519569396973) },-- Casa nº 332
    {['prop'] = 'trailer', ['door'] = vector3(404.47, 2584.4, 43.52), ['price'] = 25000 ,['parking']= vector3(398.25057983398,2584.708984375,43.51953125) }, -- Casa nº 333
    {['prop'] = 'trailer', ['door'] = vector3(564.51, 2598.92, 43.87), ['price'] = 25000 ,['parking']= vector3(556.60797119141,2597.5847167969,42.813625335693) }, -- Casa nº 334
    {['prop'] = 'trailer', ['door'] = vector3(1538.85, 6321.92, 25.07), ['price'] = 25000 ,['parking']= vector3(1538.29296875,6336.8422851563,24.075492858887) }, -- Casa nº 335
    {['prop'] = 'trailer', ['door'] = vector3(-20.81, 3030.23, 41.69), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 336 Sin Casa
    {['prop'] = 'trailer', ['door'] = vector3(78.02, 3732.59, 40.27), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 337 Duplicada 323
    {['prop'] = 'trailer', ['door'] = vector3(78.02, 3732.59, 40.27), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 338 Duplicada 323 y 337
    {['prop'] = 'trailer', ['door'] = vector3(78.02, 3732.59, 40.27), ['price'] = 25000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 339 Duplicada 323 , 337 y 338

    {['prop'] = 'michael', ['door'] = vector3(-830.81, -115.09, 54.83), ['price'] = 600000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 340 Metro
    {['prop'] = 'michael', ['door'] = vector3(-1515.57, 24.26, 55.82), ['price'] = 600000 ,['parking']= vector3(-1504.0235595703,23.276020050049,56.2541847229) }, -- Casa nº 341
    {['prop'] = 'michael', ['door'] = vector3(-1570.59, 22.74, 58.55), ['price'] = 600000 ,['parking']= vector3(-1555.4776611328,20.558992385864,58.665187835693) }, -- Casa nº 342
    {['prop'] = 'michael', ['door'] = vector3(-1629.74, 36.72, 61.94), ['price'] = 600000 ,['parking']= vector3(-1615.2683105469,16.513893127441,62.178073883057) }, -- Casa nº 343
    {['prop'] = 'michael', ['door'] = vector3(-1465.07, -34.55, 54.05), ['price'] = 600000 ,['parking']= vector3(-1462.1447753906,-26.677368164063,54.646881103516) }, -- Casa nº 344
    {['prop'] = 'michael', ['door'] = vector3(-1467.29, 35.16, 53.54), ['price'] = 600000 ,['parking']= vector3(-1488.5954589844,32.494079589844,54.676445007324) }, -- Casa nº 345
    {['prop'] = 'michael', ['door'] = vector3(-1116.89, 304.56, 65.52), ['price'] = 600000 ,['parking']= vector3(-1129.2562255859,311.23709106445,66.177642822266) }, -- Casa nº 346
    {['prop'] = 'michael', ['door'] = vector3(-1038.63, 312.06, 66.27), ['price'] = 600000 ,['parking']= vector3(-1061.9969482422,302.11636352539,65.939445495605) }, -- Casa nº 347
    {['prop'] = 'michael', ['door'] = vector3(-1026.14, 360.57, 70.36), ['price'] = 600000 ,['parking']= vector3(-1047.8016357422,386.93692016602,69.358070373535) }, -- Casa nº 348
    {['prop'] = 'michael', ['door'] = vector3(-1135.83, 375.9, 70.3), ['price'] = 600000 ,['parking']= vector3(-1095.9556884766,357.15655517578,68.501426696777) }, -- Casa nº 349
    {['prop'] = 'michael', ['door'] = vector3(-881.67, 363.62, 84.36), ['price'] = 600000 ,['parking']= vector3(-887.99420166016,363.13616943359,85.031394958496) }, -- Casa 350
    {['prop'] = 'michael', ['door'] = vector3(-1189.87, 292.13, 68.89), ['price'] = 600000 ,['parking']= vector3(-1206.1551513672,270.38595581055,69.549545288086) }, -- Casa 351
    {['prop'] = 'michael', ['door'] = vector3(-1931.26, 362.47, 92.98), ['price'] = 600000 ,['parking']= vector3(-1937.1302490234,361.79461669922,93.700546264648) }, -- Casa 352
    {['prop'] = 'highend', ['door'] = vector3(-1970.47, 245.95, 86.81), ['price'] = 520000 ,['parking']= vector3(-1976.2785644531,260.03024291992,87.219024658203) }, -- Casa 353
    {['prop'] = 'michael', ['door'] = vector3(-929.47, 20.06, 47.53), ['price'] = 600000 ,['parking']= vector3(-928.24475097656,13.298882484436,47.733860015869) }, -- Casa 354      
    {['prop'] = 'michael', ['door'] = vector3(-888.42, 42.41, 48.15), ['price'] = 600000 ,['parking']= vector3(-879.28894042969,18.261196136475,44.904781341553) }, -- Casa nº 355
    {['prop'] = 'michael', ['door'] = vector3(-896.49, -5.14, 43.8), ['price'] = 600000 ,['parking']= vector3(-888.45556640625,-15.099802017212,43.146785736084) }, -- Casa nº 356
    {['prop'] = 'michael', ['door'] = vector3(-842.03, -24.84, 39.4), ['price'] = 600000 ,['parking']= vector3(-835.14819335938,-37.400352478027,38.947288513184) }, -- Casa nº 357
    {['prop'] = 'michael', ['door'] = vector3(-877.11, 306.67, 83.15), ['price'] = 600000 ,['parking']= vector3(-869.29107666016,318.46740722656,83.97777557373) }, -- Casa nº 358
    {['prop'] = 'michael', ['door'] = vector3(-1899.18, 132.33, 81.98), ['price'] = 600000 ,['parking']= vector3(-1889.0323486328,121.87917327881,81.683288574219) }, -- Casa nº 359
    {['prop'] = 'michael', ['door'] = vector3(-1873.07, 202.01, 84.38), ['price'] = 600000 ,['parking']= vector3(-1873.1175537109,194.61755371094,84.294540405273) }, -- Casa nº 360
    {['prop'] = 'michael', ['door'] = vector3(-1905.65, 252.73, 86.45), ['price'] = 600000 ,['parking']= vector3(-1903.1649169922,236.88734436035,86.251136779785) }, -- Casa nº 361
    {['prop'] = 'michael', ['door'] = vector3(-1995.46, 301.09, 91.96), ['price'] = 600000 ,['parking']= vector3(-1997.6446533203,295.25415039063,91.764862060547) }, -- Casa nº 362
    {['prop'] = 'michael', ['door'] = vector3(-2011.15, 445.08, 103.02), ['price'] = 600000 ,['parking']= vector3(-2010.6791992188,454.8662109375,102.66585540771) }, -- Casa nº 363
    {['prop'] = 'michael', ['door'] = vector3(-1937.49, 550.96, 115.02), ['price'] = 600000 ,['parking']= vector3(-1938.4432373047,527.39282226563,110.51147460938) }, -- Casa nº 364
    {['prop'] = 'michael', ['door'] = vector3(-1896.25, 642.53, 130.21), ['price'] = 600000 ,['parking']= vector3(-1887.8483886719,626.05084228516,130.00053405762) }, -- Casa nº 365
     ----NAVE PEQUEÑA
    {['prop'] = 'warehouse3', ['door'] = vector3(81.33, 6643.98, 31.93), ['price'] = 20000 ,['parking']= vector3(75.406875610352,6639.00390625,31.925357818604) }, -- Casa nº 366
    {['prop'] = 'warehouse3', ['door'] = vector3(1417.13, 6339.19, 24.4), ['price'] = 20000 ,['parking']= vector3(1430.0126953125,6339.7641601563,23.989715576172) }, -- Casa nº 367
    {['prop'] = 'warehouse3', ['door'] = vector3(1654.85, 4862.11, 41.99), ['price'] = 20000 ,['parking']= vector3(1660.9833984375,4862.1640625,41.922801971436) }, -- Casa nº 368
    {['prop'] = 'warehouse3', ['door'] = vector3(1679.41, 4863.81, 42.05), ['price'] = 20000 ,['parking']= vector3(1674.5395507813,4863.2221679688,41.989765167236) }, -- Casa nº 369
    {['prop'] = 'warehouse3', ['door'] = vector3(-151.76, -38.11, 54.4), ['price'] = 20000 ,['parking']= vector3(-167.47213745117,-30.153575897217,52.446750640869) }, -- Casa nº 370
    {['prop'] = 'warehouse3', ['door'] = vector3(-1375.68, -659.22, 27.38), ['price'] = 20000 ,['parking']= vector3(-1381.4703369141,-653.328125,28.68452835083) }, -- Casa nº 371    
    {['prop'] = 'warehouse3', ['door'] = vector3(-5.62, 0.66, 70.22), ['price'] = 20000 ,['parking']= vector3(-8.4212322235107,4.7658247947693,71.204208374023) }, -- Casa nº 372
    {['prop'] = 'warehouse3', ['door'] = vector3(-1310.57, -608.95, 29.38), ['price'] = 20000 ,['parking']= vector3(-1319.1292724609,-592.88708496094,28.695064544678) }, -- Casa nº 373
    --{['prop'] = 'warehouse3', ['door'] = vector3(-319.85, 1389.77, 36.5), ['price'] = 20000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 374 Sin Casa
    {['prop'] = 'warehouse3', ['door'] = vector3(-559.3, -1804.31, 22.61), ['price'] = 20000,['parking']= vector3(-551.55200195313,-1806.1995849609,22.129720687866) }, -- Casa nº 375     
     ----NAVE MEDIANA
    {['prop'] = 'warehouse1', ['door'] = vector3(182.66, 2790.0, 45.61), ['price'] = 70000 ,['parking']= vector3(189.43197631836,2787.3447265625,45.596431732178) }, -- Casa nº 376
    {['prop'] = 'warehouse1', ['door'] = vector3(1929.88, 4634.88, 40.47), ['price'] = 70000 ,['parking']= vector3(1940.5474853516,4629.8510742188,40.421325683594) }, -- Casa nº 377
    {['prop'] = 'warehouse1', ['door'] = vector3(1710.45, 4728.43, 42.15), ['price'] = 70000 ,['parking']= vector3(1712.1883544922,4745.2817382813,41.959144592285) },-- Casa nº 378
    {['prop'] = 'warehouse1', ['door'] = vector3(-109.23, 2795.36, 53.3), ['price'] = 70000 ,['parking']= vector3(-95.11353302002,2810.9631347656,53.306213378906) },-- Casa nº 379
    {['prop'] = 'warehouse1', ['door'] = vector3(196.94, -162.52, 56.33), ['price'] = 70000 ,['parking']= vector3(194.83921813965,-159.6018371582,56.447425842285) },-- Casa nº 380
    {['prop'] = 'warehouse1', ['door'] = vector3(20.0, -205.41, 52.86), ['price'] = 70000 ,['parking']= vector3(20.761516571045,-210.24404907227,52.857265472412) },-- Casa nº 381
    {['prop'] = 'warehouse1', ['door'] = vector3(154.56, -119.19, 54.83), ['price'] = 70000 ,['parking']= vector3(150.35433959961,-120.40106964111,54.826442718506) },-- Casa nº 382
    {['prop'] = 'warehouse1', ['door'] = vector3(68.7, -114.55, 57.29), ['price'] = 70000 ,['parking']= vector3(44.459758758545,-105.40872955322,55.996910095215) },-- Casa nº 383
    {['prop'] = 'warehouse1', ['door'] = vector3(967.30, -1857.42, 31.2), ['price'] = 70000 ,['parking']= vector3(963.48663330078,-1856.5686035156,31.196895599365) },-- Casa nº 384
    {['prop'] = 'warehouse1', ['door'] = vector3(908.27, -2192.22, 30.52), ['price'] = 70000 ,['parking']= vector3(911.37841796875,-2192.4191894531,30.499170303345) }, -- Casa nº 385
     ----NAVE GRANDE
    {['prop'] = 'warehouse2', ['door'] = vector3(1036.26, -2177.57, 31.53), ['price'] = 140000 ,['parking']= vector3(1040.8076171875,-2178.4411621094,31.457887649536) }, -- Casa nº 386
    {['prop'] = 'warehouse2', ['door'] = vector3(853.27, -2433.08, 28.06), ['price'] = 140000 ,['parking']= vector3(852.93896484375,-2435.1389160156,28.01189994812) }, -- Casa nº 387
    {['prop'] = 'warehouse2', ['door'] = vector3(149.04, 6362.71, 31.53), ['price'] = 140000 ,['parking']= vector3(145.74267578125,6366.2661132813,31.529228210449) }, -- Casa nº 388
    {['prop'] = 'warehouse2', ['door'] = vector3(161.45, 2286.36, 94.13), ['price'] = 140000 ,['parking']= vector3(164.25886535645,2285.0524902344,93.809967041016) }, -- Casa nº 389
    {['prop'] = 'warehouse2', ['door'] = vector3(303.32, -170.1, 58.18), ['price'] = 140000 ,['parking']= vector3(302.82601928711,-171.7574005127,57.990741729736) }, -- Casa nº 390
    {['prop'] = 'warehouse2', ['door'] = vector3(143.95, -131.69, 54.83), ['price'] = 140000 ,['parking']= vector3(147.98532104492,-129.73570251465,54.826133728027) }, -- Casa nº 391
    {['prop'] = 'warehouse2', ['door'] = vector3(-208.68, 20.99, 56.08), ['price'] = 140000 ,['parking']= vector3(-209.27067565918,19.285036087036,55.911231994629) }, -- Casa nº 392
    {['prop'] = 'warehouse2', ['door'] = vector3(-1251.32, -676.29, 25.99), ['price'] = 140000 ,['parking']= vector3(-1244.7163085938,-670.52722167969,25.459354400635) }, -- Casa nº 393
    {['prop'] = 'warehouse2', ['door'] = vector3(-1390.41, -330.86, 40.7), ['price'] = 140000 ,['parking']= vector3(-1391.1827392578,-338.00610351563,39.87809753418) }, -- Casa nº 394
    {['prop'] = 'warehouse2', ['door'] = vector3(1084.68, -23.66, 30.59), ['price'] = 140000 ,['parking']= vector3(1648.7406005859,3729.27734375,34.306056976318)}, -- Casa nº 395 Sin Casa

    {['prop'] = 'highend', ['door'] = vector3(-112.93, 986.02, 234.75), ['price'] = 520000 ,['parking']= vector3(-126.44921112061,1006.0868530273,235.73207092285) }, -- Casa nº 396
    {['prop'] = 'michael', ['door'] = vector3(-151.83, 910.59, 234.66), ['price'] = 600000 ,['parking']= vector3(-168.87266540527,920.80316162109,235.65562438965) }, -- Casa nº 397
    {['prop'] = 'highendv2', ['door'] = vector3(-1932.02, 162.62, 83.65), ['price'] = 500000 ,['parking']= vector3(-1938.3577880859,180.85247802734,84.652046203613) }, -- Casa nº 398
    {['prop'] = 'highendv2', ['door'] = vector3(-1961.22, 211.9, 85.8), ['price'] = 500000 ,['parking']= vector3(-1948.9675292969,201.76086425781,86.080406188965) }, -- Casa nº 399
    {['prop'] = 'highendv2', ['door'] = vector3(-1922.39, 298.36, 88.29), ['price'] = 500000 ,['parking']= vector3(-1922.1229248047,283.11367797852,89.073249816895) }, -- Casa nº 400
    {['prop'] = 'highendv2', ['door'] = vector3(-2009.13, 367.42, 93.81), ['price'] = 500000 ,['parking']= vector3(-2000.9672851563,381.37518310547,94.483497619629) }, -- Casa nº 401
    {['prop'] = 'highend', ['door'] = vector3(-1940.72, 387.55, 95.51), ['price'] = 520000 ,['parking']= vector3(-1941.0817871094,385.57901000977,96.507171630859) }, -- Casa nº 402
    {['prop'] = 'michael', ['door'] = vector3(-1942.69, 449.64, 101.93), ['price'] = 600000 ,['parking']= vector3(-1940.8156738281,461.97494506836,102.26303863525) }, -- Casa nº 403
    {['prop'] = 'highendv2', ['door'] = vector3(-2014.96, 499.6, 106.17), ['price'] = 500000 ,['parking']= vector3(-2014.8706054688,485.64129638672,107.17166137695) }, -- Casa nº 404
    {['prop'] = 'highend', ['door'] = vector3(-1996.17, 591.14, 117.1), ['price'] = 520000 ,['parking']= vector3(-1989.6179199219,605.05017089844,117.90339660645) }, -- Casa nº 405
    {['prop'] = 'highend', ['door'] = vector3(-1928.88, 595.48, 121.48), ['price'] = 520000 ,['parking']= vector3(-1937.7365722656,581.16162109375,119.37105560303) }, -- Casa nº 406
    {['prop'] = 'michael', ['door'] = vector3(-1974.32, 630.74, 121.54), ['price'] = 600000 ,['parking']= vector3(-1975.5637207031,623.70526123047,122.53629302979) }, -- Casa nº 407
    {['prop'] = 'michael', ['door'] = vector3(-1805.00, 436.43, 127.83), ['price'] = 600000 ,['parking']= vector3(-1790.5910644531,458.02029418945,128.30815124512) }, -- Casa nº 408
    {['prop'] = 'highendv2', ['door'] = vector3(-1540.02, 420.89, 109.01), ['price'] = 500000 ,['parking']= vector3(-1550.1795654297,428.3779296875,109.3348236084) }, -- Casa nº 409
    {['prop'] = 'highendv2', ['door'] = vector3(-1500.71, 523.08, 117.27), ['price'] = 500000 ,['parking']= vector3(-1488.2989501953,528.72344970703,118.27219390869) }, -- Casa nº 410
    {['prop'] = 'michael', ['door'] = vector3(-1454.03, 512.27, 116.8), ['price'] = 600000 ,['parking']= vector3(-1470.5355224609,510.91693115234,117.67739868164) }, -- Casa nº 411
    {['prop'] = 'highendv2', ['door'] = vector3(-1405.42, 526.72, 122.83), ['price'] = 500000 ,['parking']= vector3(-1407.3016357422,540.19390869141,122.92435455322) }, -- Casa nº 412
    {['prop'] = 'highendv2', ['door'] = vector3(-1371.52, 443.92, 104.86), ['price'] = 500000 ,['parking']= vector3(-1374.2509765625,452.77145385742,105.04165649414) }, -- Casa nº 413
    {['prop'] = 'highend', ['door'] = vector3(-1452.91, 545.6, 121.0), ['price'] = 520000 ,['parking']= vector3(-1454.1545410156,534.50805664063,119.28694152832) }, -- Casa nº 414
    {['prop'] = 'trevor', ['door'] = vector3(-3225.13, 911.11, 12.99), ['price'] = 200000 ,['parking']= vector3(-3214.7380371094,913.16271972656,13.988903999329) }, -- Casa nº 415
    {['prop'] = 'trevor', ['door'] = vector3(-3229.04, 927.26, 12.97), ['price'] = 200000 ,['parking']= vector3(-3224.7861328125,924.84454345703,13.96498966217) }, -- Casa nº 416
    {['prop'] = 'trevor', ['door'] = vector3(-3232.7, 934.76, 12.8), ['price'] = 200000 ,['parking']= vector3(-3231.2995605469,939.74993896484,13.749319076538) }, -- Casa nº 417
    {['prop'] = 'trevor', ['door'] = vector3(-3237.67, 952.65, 12.13), ['price'] = 200000 ,['parking']= vector3(-3234.9194335938,948.26800537109,13.216025352478) }, -- Casa nº 418
    {['prop'] = 'trevor', ['door'] = vector3(-3251.17, 1027.13, 10.76), ['price'] = 200000 ,['parking']= vector3(-3239.1745605469,1034.6700439453,11.697243690491) }, -- Casa nº 419
    {['prop'] = 'trevor', ['door'] = vector3(-3254.46, 1064.15, 10.15), ['price'] = 200000 ,['parking']= vector3(-3234.5112304688,1058.2958984375,11.150714874268) }, -- Casa nº 420
    {['prop'] = 'trevor', ['door'] = vector3(-3232.22, 1067.98, 10.02), ['price'] = 200000 ,['parking']= vector3(-3230.1638183594,1071.7769775391,10.914109230042) }, -- Casa nº 421
    {['prop'] = 'trevor', ['door'] = vector3(-3231.96, 1081.41, 9.81), ['price'] = 200000 ,['parking']= vector3(-3228.2893066406,1085.4560546875,10.792379379272) }, -- Casa nº 422
    {['prop'] = 'trevor', ['door'] = vector3(-3229.07, 1101.02, 9.58), ['price'] = 200000 ,['parking']= vector3(-3221.1801757813,1106.4057617188,10.515292167664) }, -- Casa nº 423
    {['prop'] = 'trevor', ['door'] = vector3(-3220.13, 1138.18, 8.90), ['price'] = 200000 ,['parking']= vector3(-3206.3874511719,1136.4234619141,9.8973426818848) }, -- Casa nº 424
    {['prop'] = 'trevor', ['door'] = vector3(-3205.42, 1152.23, 8.66), ['price'] = 200000 ,['parking']= vector3(-3202.1052246094,1154.4747314453,9.6543426513672) }, -- Casa nº 425
    {['prop'] = 'trevor', ['door'] = vector3(-3200.02, 1165.43, 8.65), ['price'] = 200000 ,['parking']= vector3(-3198.5964355469,1160.7205810547,9.6543340682983) }, -- Casa nº 426
    {['prop'] = 'trevor', ['door'] = vector3(-3195.11, 1179.62, 8.66), ['price'] = 200000 ,['parking']= vector3(-3192.9562988281,1182.8028564453,9.6643533706665) }, -- Casa nº 427
    {['prop'] = 'trevor', ['door'] = vector3(-3193.62, 1208.81, 8.43), ['price'] = 200000 ,['parking']= vector3(-3188.6843261719,1202.8403320313,9.4862051010132) }, -- Casa nº 428
    {['prop'] = 'trevor', ['door'] = vector3(-3200.28, 1232.51, 9.05), ['price'] = 200000 ,['parking']= vector3(-3186.4375,1226.9361572266,10.065526008606) }, -- Casa nº 429
    {['prop'] = 'trevor', ['door'] = vector3(-3197.98, 1274.46, 11.67), ['price'] = 200000 ,['parking']= vector3(-3184.0554199219,1277.5753173828,12.679141998291) }, -- Casa nº 430
    {['prop'] = 'trevor', ['door'] = vector3(-3190.61, 1297.8, 18.07), ['price'] = 200000 ,['parking']= vector3(-3177.5168457031,1298.5842285156,14.555380821228) }, -- Casa nº 431
    {['prop'] = 'trevor', ['door'] = vector3(-3101.61, 743.79, 20.28), ['price'] = 200000 ,['parking']= vector3(-3097.5112304688,745.91131591797,21.284770965576) }, -- Casa nº 432
    {['prop'] = 'trevor', ['door'] = vector3(-3107.72, 718.74, 19.65), ['price'] = 200000 ,['parking']= vector3(-3104.3359375,723.41748046875,20.710035324097) }, -- Casa nº 433
    {['prop'] = 'trevor', ['door'] = vector3(-3077.71, 659.14, 10.64), ['price'] = 200000 ,['parking']= vector3(-3074.197265625,656.59680175781,11.437081336975) }, -- Casa nº 434
    {['prop'] = 'trevor', ['door'] = vector3(-3029.5, 568.81, 6.82), ['price'] = 200000 ,['parking']= vector3(-3029.2106933594,572.93426513672,7.7150173187256) }, -- Casa nº 435
    {['prop'] = 'trevor', ['door'] = vector3(-3037.25, 559.12, 6.51), ['price'] = 200000 ,['parking']= vector3(-3033.8576660156,555.15783691406,7.5076842308044) }, -- Casa nº 436
    {['prop'] = 'trevor', ['door'] = vector3(-3037.0, 544.85, 6.51), ['price'] = 200000 ,['parking']= vector3(-3034.8500976563,548.19848632813,7.5076842308044) }, -- Casa nº 437
    {['prop'] = 'trevor', ['door'] = vector3(-3042.62, 524.05, 6.43), ['price'] = 200000 ,['parking']= vector3(-3030.9479980469,520.64703369141,7.3773694038391) }, -- Casa nº 438
    {['prop'] = 'trevor', ['door'] = vector3(-3039.47, 492.89, 5.77), ['price'] = 200000 ,['parking']= vector3(-3033.7717285156,497.80770874023,6.7841486930847) }, -- Casa nº 439
    {['prop'] = 'trevor', ['door'] = vector3(-3053.35, 486.81, 5.78), ['price'] = 200000 ,['parking']= vector3(-3041.6684570313,477.11520385742,6.7796430587769) }, -- Casa nº 440
    {['prop'] = 'trevor', ['door'] = vector3(-3059.5, 453.41, 5.36), ['price'] = 200000 ,['parking']= vector3(-3058.5451660156,441.57241821289,6.361701965332) }, -- Casa nº 441
    {['prop'] = 'trevor', ['door'] = vector3(-3088.8, 392.17, 10.45), ['price'] = 200000 ,['parking']= vector3(-3075.3466796875,394.10110473633,6.9685211181641) }, -- Casa nº 442
    {['prop'] = 'trevor', ['door'] = vector3(-3091.52, 379.43, 6.11), ['price'] = 200000 ,['parking']= vector3(-3081.9758300781,371.76580810547,7.123260974884) }, -- Casa nº 443
    {['prop'] = 'highend', ['door'] = vector3(-3093.75, 349.38, 6.54), ['price'] = 520000 ,['parking']= vector3(-3091.6682128906,341.48199462891,7.450909614563) }, -- Casa nº 444
    {['prop'] = 'trevor', ['door'] = vector3(-3110.5, 335.54, 6.49), ['price'] = 200000 ,['parking']= vector3(-3092.9145507813,321.92666625977,7.4983425140381) }, -- Casa nº 445
    {['prop'] = 'trevor', ['door'] = vector3(-3111.82, 315.4, 7.38), ['price'] = 200000 ,['parking']= vector3(-3098.4965820313,306.89477539063,8.3836765289307) }, -- Casa nº 446
    {['prop'] = 'trevor', ['door'] = vector3(-3115.09, 304.05, 7.38), ['price'] = 200000 ,['parking']= vector3(-3097.2705078125,302.87301635742,8.373833656311) }, -- Casa nº 447
    {['prop'] = 'trevor', ['door'] = vector3(-3105.66, 286.85, 7.97), ['price'] = 200000 ,['parking']= vector3(-3103.0090332031,289.39990234375,8.9799709320068) }, -- Casa nº 448
    {['prop'] = 'trevor', ['door'] = vector3(-3105.04, 246.85, 11.5), ['price'] = 200000 ,['parking']= vector3(-3104.0681152344,251.9602355957,12.200831413269) }, -- Casa nº 449
    {['prop'] = 'trevor', ['door'] = vector3(-3089.1, 221.37, 13.07), ['price'] = 200000 ,['parking']= vector3(-3084.0739746094,219.91131591797,13.996091842651) }, -- Casa nº 450
    {['prop'] = 'highend', ['door'] = vector3(-2977.67, 609.33, 19.24), ['price'] = 300000 ,['parking']= vector3(-2980.1242675781,612.77404785156,20.225109100342) }, -- Casa nº 451
    {['prop'] = 'highendv2', ['door'] = vector3(-2972.87, 642.42, 24.8), ['price'] = 500000 ,['parking']= vector3(-2980.5598144531,655.20648193359,25.548868179321) }, -- Casa nº 452
    {['prop'] = 'highend', ['door'] = vector3(-2994.84, 682.33, 24.04), ['price'] = 300000 ,['parking']= vector3(-2998.8117675781,688.05676269531,25.259098052979) }, -- Casa nº 453
    {['prop'] = 'highend', ['door'] = vector3(-2992.73, 707.08, 27.5), ['price'] = 300000 ,['parking']= vector3(-2995.4055175781,704.62878417969,28.475936889648) }, -- Casa nº 454
    {['prop'] = 'highend', ['door'] = vector3(-3017.77, 746.36, 26.59), ['price'] = 300000 ,['parking']= vector3(-3017.2055664063,740.16650390625,27.587621688843) }, -- Casa nº 455

    {['prop'] = 'lester', ['door'] = vector3(1379.4711914063,-1514.9986572266,58.43563079834), ['price'] = 60000 ,['parking']= vector3(1371.927734375,-1519.4600830078,57.503498077393)}, -- Casa nº 458
    {['prop'] = 'lester', ['door'] = vector3(1381.8754882813,-1544.6037597656,57.107151031494), ['price'] = 60000 ,['parking']= vector3(1397.2430419922,-1535.6834716797,57.714721679688)}, -- Casa nº 459
    {['prop'] = 'lester', ['door'] = vector3(1360.5897216797,-1556.2663574219,56.34351348877), ['price'] = 60000 ,['parking']= vector3(1348.3649902344,-1551.8558349609,53.759868621826)}, -- Casa nº 460
    {['prop'] = 'lester', ['door'] = vector3(1338.3579101563,-1524.2446289063,54.581703186035), ['price'] = 60000 ,['parking']= vector3(1334.8596191406,-1528.8793945313,53.394538879395)}, -- Casa nº 461
    {['prop'] = 'lester', ['door'] = vector3(1315.7468261719,-1526.5285644531,51.807621002197), ['price'] = 60000 ,['parking']= vector3(1332.2523193359,-1528.9992675781,53.031120300293)}, -- Casa nº 462
    {['prop'] = 'nice', ['door'] = vector3(1327.5206298828,-1553.1807861328,54.051513671875), ['price'] = 175000 ,['parking']= vector3(1337.6763916016,-1549.7687988281,53.07107925415)}, -- Casa nº 463
    {['prop'] = 'lester', ['door'] = vector3(1286.6827392578,-1604.4862060547,54.824886322021), ['price'] = 60000 ,['parking']= vector3(1274.5422363281,-1609.5240478516,54.189464569092)}, -- Casa nº 464
    {['prop'] = 'lester', ['door'] = vector3(1261.6108398438,-1616.7622070313,54.742828369141), ['price'] = 60000 ,['parking']= vector3(1252.9896240234,-1618.7062988281,53.46118927002)}, -- Casa nº 465
    {['prop'] = 'lester', ['door'] = vector3(1230.5983886719,-1590.8640136719,53.769954681396), ['price'] = 60000 ,['parking']= vector3(1226.0002441406,-1603.0521240234,51.910076141357)}, -- Casa nº 466
    {['prop'] = 'lester', ['door'] = vector3(1245.3922119141,-1626.9725341797,53.282485961914), ['price'] = 60000 ,['parking']= vector3(1235.2800292969,-1628.3646240234,51.762298583984)}, -- Casa nº 467
    {['prop'] = 'lester', ['door'] = vector3(1205.5821533203,-1607.2603759766,50.736503601074), ['price'] = 60000 ,['parking']= vector3(1220.8760986328,-1608.2180175781,50.466369628906)}, -- Casa nº 468
    {['prop'] = 'lester', ['door'] = vector3(1214.5299072266,-1644.4044189453,48.645992279053), ['price'] = 60000 ,['parking']= vector3(1225.3671875,-1631.9786376953,48.77868270874)}, -- Casa nº 469
    {['prop'] = 'lester', ['door'] = vector3(1193.4910888672,-1622.4099121094,45.221492767334), ['price'] = 60000 ,['parking']= vector3(1166.7209472656,-1643.4627685547,36.919540405273)}, -- Casa nº 470
    {['prop'] = 'lester', ['door'] = vector3(1193.6092529297,-1656.5205078125,43.026405334473), ['price'] = 60000 ,['parking']= vector3(1160.1623535156,-1645.2396240234,36.920696258545)}, -- Casa nº 471
    ---MOTELS
    {['prop'] = 'trailer', ['door'] = vector3(312.736328125,-218.79222106934,54.221775054932), ['price'] = 20000 ,['parking']= false}, -- Casa nº 472
    {['prop'] = 'trailer', ['door'] = vector3(310.72692871094,-217.96182250977,54.221775054932), ['price'] = 20000 ,['parking']= false}, -- Casa nº 473
    {['prop'] = 'trailer', ['door'] = vector3(307.34078979492,-216.63661193848,54.221775054932), ['price'] = 20000 ,['parking']= false}, -- Casa nº 474
    {['prop'] = 'trailer', ['door'] = vector3(307.52410888672,-213.24351501465,54.221775054932), ['price'] = 20000 ,['parking']= false}, -- Casa nº 475
    {['prop'] = 'trailer', ['door'] = vector3(309.57708740234,-208.01463317871,54.221775054932), ['price'] = 20000 ,['parking']= false}, -- Casa nº 476
    {['prop'] = 'trailer', ['door'] = vector3(311.24557495117,-203.47988891602,54.221775054932), ['price'] = 20000 ,['parking']= false}, -- Casa nº 477
    {['prop'] = 'trailer', ['door'] = vector3(313.31298828125,-198.02424621582,54.221775054932), ['price'] = 20000 ,['parking']= false}, -- Casa nº 478
    {['prop'] = 'trailer', ['door'] = vector3(315.66525268555,-194.76902770996,54.22643661499), ['price'] = 20000 ,['parking']= false}, -- Casa nº 479
    {['prop'] = 'trailer', ['door'] = vector3(319.31109619141,-196.2198638916,54.226451873779), ['price'] = 20000 ,['parking']= false}, -- Casa nº 480
    {['prop'] = 'trailer', ['door'] = vector3(321.24639892578,-197.02297973633,54.226451873779), ['price'] = 20000 ,['parking']= false}, -- Casa nº 481
    {['prop'] = 'trailer', ['door'] = vector3(312.90689086914,-218.85717773438,58.019245147705), ['price'] = 20000 ,['parking']= false}, -- Casa nº 482
    {['prop'] = 'trailer', ['door'] = vector3(310.85424804688,-218.07754516602,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 483
    {['prop'] = 'trailer', ['door'] = vector3(307.27386474609,-216.662109375,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 484
    {['prop'] = 'trailer', ['door'] = vector3(307.50015258789,-213.28317260742,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 485
    {['prop'] = 'trailer', ['door'] = vector3(309.58898925781,-208.02207946777,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 486
    {['prop'] = 'trailer', ['door'] = vector3(311.27828979492,-203.40119934082,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 487
    {['prop'] = 'trailer', ['door'] = vector3(313.3454284668,-198.16452026367,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 488
    {['prop'] = 'trailer', ['door'] = vector3(315.77947998047,-194.75730895996,58.019199371338), ['price'] = 20000 ,['parking']= false}, -- Casa nº 489
    {['prop'] = 'trailer', ['door'] = vector3(319.42022705078,-196.16725158691,58.019222259521), ['price'] = 20000 ,['parking']= false}, -- Casa nº 490
    {['prop'] = 'trailer', ['door'] = vector3(321.37704467773,-196.994140625,58.019222259521), ['price'] = 20000 ,['parking']= false}, -- Casa nº 491
    {['prop'] = 'trailer', ['door'] = vector3(329.30017089844,-225.22805786133,54.221767425537), ['price'] = 20000 ,['parking']= false}, -- Casa nº 492
    {['prop'] = 'trailer', ['door'] = vector3(331.39154052734,-226.0016784668,54.221767425537), ['price'] = 20000 ,['parking']= false}, -- Casa nº 493
    {['prop'] = 'trailer', ['door'] = vector3(334.97088623047,-227.4012298584,54.221771240234), ['price'] = 20000 ,['parking']= false}, -- Casa nº 494
    {['prop'] = 'trailer', ['door'] = vector3(337.09222412109,-224.77461242676,54.221771240234), ['price'] = 20000 ,['parking']= false}, -- Casa nº 495
    {['prop'] = 'trailer', ['door'] = vector3(339.19366455078,-219.53633117676,54.221782684326), ['price'] = 20000 ,['parking']= false}, -- Casa nº 496
    {['prop'] = 'trailer', ['door'] = vector3(340.9040222168,-214.85876464844,54.221782684326), ['price'] = 20000 ,['parking']= false}, -- Casa nº 497
    {['prop'] = 'trailer', ['door'] = vector3(342.90383911133,-209.6149597168,54.221782684326), ['price'] = 20000 ,['parking']= false}, -- Casa nº 498
    {['prop'] = 'trailer', ['door'] = vector3(344.75637817383,-205.04693603516,54.221820831299), ['price'] = 20000 ,['parking']= false}, -- Casa nº 499
    {['prop'] = 'trailer', ['door'] = vector3(346.80346679688,-199.61451721191,54.221820831299), ['price'] = 20000 ,['parking']= false}, -- Casa nº 500
    {['prop'] = 'trailer', ['door'] = vector3(329.43646240234,-225.19030761719,58.019256591797), ['price'] = 20000 ,['parking']= false}, -- Casa nº 501
    {['prop'] = 'trailer', ['door'] = vector3(331.45196533203,-225.87348937988,58.019256591797), ['price'] = 20000 ,['parking']= false}, -- Casa nº 502
    {['prop'] = 'trailer', ['door'] = vector3(335.00497436523,-227.33666992188,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 503
    {['prop'] = 'trailer', ['door'] = vector3(337.09262084961,-224.78492736816,58.019241333008), ['price'] = 20000 ,['parking']= false}, -- Casa nº 504
    {['prop'] = 'trailer', ['door'] = vector3(339.12878417969,-219.47341918945,58.019237518311), ['price'] = 20000 ,['parking']= false}, -- Casa nº 505
    {['prop'] = 'trailer', ['door'] = vector3(340.91513061523,-214.81675720215,58.019237518311), ['price'] = 20000 ,['parking']= false}, -- Casa nº 506
    {['prop'] = 'trailer', ['door'] = vector3(342.97595214844,-209.60719299316,58.019237518311), ['price'] = 20000 ,['parking']= false}, -- Casa nº 507
    {['prop'] = 'trailer', ['door'] = vector3(344.68450927734,-205.00517272949,58.019237518311), ['price'] = 20000 ,['parking']= false}, -- Casa nº 508
    {['prop'] = 'trailer', ['door'] = vector3(346.77182006836,-199.76264953613,58.019237518311), ['price'] = 20000 ,['parking']= false}, -- Casa nº 509
    {['prop'] = 'lester', ['door'] = vector3(16.602367401123,-1443.8342285156,30.949321746826), ['price'] = 60000 ,['parking']= vector3(6.8177909851074,-1452.5012207031,30.530582427979)}, -- Casa nº 510
    {['prop'] = 'lester', ['door'] = vector3(-1.8694996833801,-1442.1181640625,30.96301651001), ['price'] = 60000 ,['parking']= vector3(6.8177909851074,-1452.5012207031,30.530582427979)}, -- Casa nº 511
    {['prop'] = 'lester', ['door'] = vector3(-14.088953971863,-1442.1013183594,31.100955963135), ['price'] = 60000 ,['parking']= vector3(-25.394422531128,-1427.8012695313,30.656869888306)}, -- Casa nº 512 Casa mapeada
    {['prop'] = 'lester', ['door'] = vector3(-32.347270965576,-1446.3958740234,31.891408920288), ['price'] = 60000 ,['parking']= vector3(-38.609909057617,-1447.6491699219,31.498414993286)}, -- Casa nº 513
    {['prop'] = 'lester', ['door'] = vector3(-45.417835235596,-1445.5407714844,32.42960357666), ['price'] = 60000 ,['parking']= vector3(-52.787185668945,-1455.0795898438,32.064796447754)}, -- Casa nº 514
    {['prop'] = 'lester', ['door'] = vector3(-64.564804077148,-1449.6063232422,32.524948120117), ['price'] = 60000 ,['parking']= vector3(-68.042465209961,-1460.4356689453,32.065563201904)}, -- Casa nº 515
    {['prop'] = 'lester', ['door'] = vector3(-120.07684326172,-1574.5360107422,34.176361083984), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 516
    {['prop'] = 'lester', ['door'] = vector3(-114.19062042236,-1579.4650878906,34.177108764648), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 517
    {['prop'] = 'lester', ['door'] = vector3(-118.79106140137,-1586.0294189453,34.213012695313), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 518
    {['prop'] = 'lester', ['door'] = vector3(-123.21047210693,-1591.2908935547,34.20792388916), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 519
    {['prop'] = 'lester', ['door'] = vector3(-134.3285369873,-1580.4617919922,34.207962036133), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 520
    {['prop'] = 'lester', ['door'] = vector3(-140.09622192383,-1587.3383789063,34.243656158447), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 521
    {['prop'] = 'lester', ['door'] = vector3(-140.36859130859,-1599.6300048828,34.831348419189), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 522
    {['prop'] = 'lester', ['door'] = vector3(-147.75379943848,-1596.5428466797,34.831348419189), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 523
    {['prop'] = 'lester', ['door'] = vector3(-140.30368041992,-1599.5638427734,38.212627410889), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 523
    {['prop'] = 'lester', ['door'] = vector3(-147.48277282715,-1596.5169677734,38.212627410889), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 524
    {['prop'] = 'lester', ['door'] = vector3(-140.09657287598,-1587.3020019531,37.407802581787), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 525
    {['prop'] = 'lester', ['door'] = vector3(-134.33224487305,-1580.4261474609,37.407802581787), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 526
    {['prop'] = 'lester', ['door'] = vector3(-120.12161254883,-1574.4188232422,37.407760620117), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 527
    {['prop'] = 'lester', ['door'] = vector3(-114.12861633301,-1579.4295654297,37.407760620117), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 528
    {['prop'] = 'lester', ['door'] = vector3(-118.8044052124,-1586.0446777344,37.407768249512), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 529
    {['prop'] = 'lester', ['door'] = vector3(-123.11251831055,-1591.1754150391,37.407768249512), ['price'] = 60000 ,['parking']= vector3(-101.59815216064,-1587.8004150391,31.555168151855)}, -- Casa nº 530

    ---FABELAS
    {['prop'] = 'trailer', ['door'] = vector3(1852.1143798828,-80.143730163574,188.63926696777), ['price'] = 20000 ,['parking']= false}, -- Casa nº 531
   	{['prop'] = 'trailer', ['door'] = vector3(1549.5280761719,-80.243858337402,157.43222045898), ['price'] = 20000 ,['parking']= false}, -- Casa nº 532
    {['prop'] = 'trailer', ['door'] = vector3(1815.6307373047,-78.316337585449,188.57289123535), ['price'] = 20000 ,['parking']= false}, -- Casa nº 533
    {['prop'] = 'trailer', ['door'] = vector3(1830.8515625,-83.875289916992,187.08418273926), ['price'] = 20000 ,['parking']= false}, -- Casa nº 534
	{['prop'] = 'trailer', ['door'] = vector3(2025.3870849609,3.4957809448242,204.33848571777), ['price'] = 20000 ,['parking']= false}, -- Casa nº 535
	{['prop'] = 'trailer', ['door'] = vector3(2104.4033203125,25.497253417969,217.87393188477), ['price'] = 20000 ,['parking']= false}, -- Casa nº 536
	{['prop'] = 'trailer', ['door'] = vector3(2235.3999023438,134.1960144043,228.875), ['price'] = 20000 ,['parking']= false}, -- Casa nº 537
	{['prop'] = 'trailer', ['door'] = vector3(2232.6860351562,159.37434387207,222.64996337891), ['price'] = 20000 ,['parking']= false}, -- Casa nº 538
	{['prop'] = 'trailer', ['door'] = vector3(2325.8503417969,237.890625,198.25360107422), ['price'] = 20000 ,['parking']= false}, -- Casa nº 539
	{['prop'] = 'trailer', ['door'] = vector3(2319.8752441406,231.76545715332,201.4599609375), ['price'] = 20000 ,['parking']= false}, -- Casa nº 540
	{['prop'] = 'trailer', ['door'] = vector3(1944.6895751953,-62.609294891357,201.25410461426), ['price'] = 20000 ,['parking']= false}, -- Casa nº 541
	{['prop'] = 'trailer', ['door'] = vector3(1723.9929199219,72.206047058105,170.99209594727), ['price'] = 20000 ,['parking']= false}, -- Casa nº 542
	{['prop'] = 'trailer', ['door'] = vector3(1754.0872802734,99.603248596191,172.30526733398), ['price'] = 20000 ,['parking']= false}, -- Casa nº 543
	{['prop'] = 'trailer', ['door'] = vector3(1768.0496826172,103.40263366699,170.94398498535), ['price'] = 20000 ,['parking']= false}, -- Casa nº 544
	{['prop'] = 'trailer', ['door'] = vector3(1836.6984863281,149.26872253418,171.89875793457), ['price'] = 20000 ,['parking']= false}, -- Casa nº 545
	{['prop'] = 'trailer', ['door'] = vector3(1590.408203125,-78.514190673828,164.44488525391), ['price'] = 20000 ,['parking']= false}, -- Casa nº 546
	{['prop'] = 'trailer', ['door'] = vector3(1542.7211914062,-86.167892456055,156.45359802246), ['price'] = 20000 ,['parking']= false}, -- Casa nº 547
	{['prop'] = 'trailer', ['door'] = vector3(1516.0119628906,-108.55839538574,152.61177062988), ['price'] = 20000 ,['parking']= false}, -- Casa nº 548
	{['prop'] = 'trailer', ['door'] = vector3(1421.7690429688,-119.4845123291,135.03503417969), ['price'] = 20000 ,['parking']= false}, -- Casa nº 549
	{['prop'] = 'trailer', ['door'] = vector3(1329.3483886719,-113.81773376465,120.23748016357), ['price'] = 20000 ,['parking']= false}, -- Casa nº 550
	{['prop'] = 'trailer', ['door'] = vector3(1326.4437255859,-132.80078125,115.56368255615), ['price'] = 20000 ,['parking']= false}, -- Casa nº 551
	{['prop'] = 'trailer', ['door'] = vector3(1313.3427734375,-169.38619995117,108.52198791504), ['price'] = 20000 ,['parking']= false}, -- Casa nº 552
	{['prop'] = 'trailer', ['door'] = vector3(1149.0101318359,-229.93283081055,69.991241455078), ['price'] = 20000 ,['parking']= false}, -- Casa nº 553

},
    HouseSpawns = { -- every possible position for a shell to be spawned. default is 66 different spawns, meaning 66 people can be inside their house at the same time! You shouldn't mess around with this tbh.
        {['taken'] = false, ['coords'] = vector3(1020.0, 2000.0, -100.0)}, -- spawn #1
        {['taken'] = false, ['coords'] = vector3(1080.0, 2000.0, -100.0)}, -- spawn #2
        {['taken'] = false, ['coords'] = vector3(1140.0, 2000.0, -100.0)}, -- spawn #3
        {['taken'] = false, ['coords'] = vector3(1200.0, 2000.0, -100.0)}, -- spawn #4
        {['taken'] = false, ['coords'] = vector3(1260.0, 2000.0, -100.0)}, -- spawn #5
        {['taken'] = false, ['coords'] = vector3(1320.0, 2000.0, -100.0)}, -- spawn #6
        {['taken'] = false, ['coords'] = vector3(1380.0, 2000.0, -100.0)}, -- spawn #7
        {['taken'] = false, ['coords'] = vector3(1440.0, 2000.0, -100.0)}, -- spawn #8
        {['taken'] = false, ['coords'] = vector3(1500.0, 2000.0, -100.0)}, -- spawn #9
        {['taken'] = false, ['coords'] = vector3(1560.0, 2000.0, -100.0)}, -- spawn #10
        {['taken'] = false, ['coords'] = vector3(1620.0, 2000.0, -100.0)}, -- spawn #11
        {['taken'] = false, ['coords'] = vector3(1680.0, 2000.0, -100.0)}, -- spawn #12
        {['taken'] = false, ['coords'] = vector3(1740.0, 2000.0, -100.0)}, -- spawn #13
        {['taken'] = false, ['coords'] = vector3(1800.0, 2000.0, -100.0)}, -- spawn #14
        {['taken'] = false, ['coords'] = vector3(1860.0, 2000.0, -100.0)}, -- spawn #15
        {['taken'] = false, ['coords'] = vector3(1920.0, 2000.0, -100.0)}, -- spawn #16
        {['taken'] = false, ['coords'] = vector3(1980.0, 2000.0, -100.0)}, -- spawn #17
        {['taken'] = false, ['coords'] = vector3(2040.0, 2000.0, -100.0)}, -- spawn #18
        {['taken'] = false, ['coords'] = vector3(2100.0, 2000.0, -100.0)}, -- spawn #19
        {['taken'] = false, ['coords'] = vector3(2160.0, 2000.0, -100.0)}, -- spawn #20
        {['taken'] = false, ['coords'] = vector3(2220.0, 2000.0, -100.0)}, -- spawn #21
        {['taken'] = false, ['coords'] = vector3(2280.0, 2000.0, -100.0)}, -- spawn #22
        {['taken'] = false, ['coords'] = vector3(2340.0, 2000.0, -100.0)}, -- spawn #23
        {['taken'] = false, ['coords'] = vector3(2400.0, 2000.0, -100.0)}, -- spawn #24
        {['taken'] = false, ['coords'] = vector3(2460.0, 2000.0, -100.0)}, -- spawn #25
        {['taken'] = false, ['coords'] = vector3(2520.0, 2000.0, -100.0)}, -- spawn #26
        {['taken'] = false, ['coords'] = vector3(2580.0, 2000.0, -100.0)}, -- spawn #27
        {['taken'] = false, ['coords'] = vector3(2640.0, 2000.0, -100.0)}, -- spawn #28
        {['taken'] = false, ['coords'] = vector3(2700.0, 2000.0, -100.0)}, -- spawn #29
        {['taken'] = false, ['coords'] = vector3(2760.0, 2000.0, -100.0)}, -- spawn #30
        {['taken'] = false, ['coords'] = vector3(2820.0, 2000.0, -100.0)}, -- spawn #31
        {['taken'] = false, ['coords'] = vector3(2880.0, 2000.0, -100.0)}, -- spawn #32
        {['taken'] = false, ['coords'] = vector3(2940.0, 2000.0, -100.0)}, -- spawn #33

        {['taken'] = false, ['coords'] = vector3(1020.0, 2100.0, -100.0)}, -- spawn #34
        {['taken'] = false, ['coords'] = vector3(1080.0, 2100.0, -100.0)}, -- spawn #35
        {['taken'] = false, ['coords'] = vector3(1140.0, 2100.0, -100.0)}, -- spawn #36
        {['taken'] = false, ['coords'] = vector3(1200.0, 2100.0, -100.0)}, -- spawn #37
        {['taken'] = false, ['coords'] = vector3(1260.0, 2100.0, -100.0)}, -- spawn #38
        {['taken'] = false, ['coords'] = vector3(1320.0, 2100.0, -100.0)}, -- spawn #39
        {['taken'] = false, ['coords'] = vector3(1380.0, 2100.0, -100.0)}, -- spawn #40
        {['taken'] = false, ['coords'] = vector3(1440.0, 2100.0, -100.0)}, -- spawn #41
        {['taken'] = false, ['coords'] = vector3(1500.0, 2100.0, -100.0)}, -- spawn #42
        {['taken'] = false, ['coords'] = vector3(1560.0, 2100.0, -100.0)}, -- spawn #43
        {['taken'] = false, ['coords'] = vector3(1620.0, 2100.0, -100.0)}, -- spawn #44
        {['taken'] = false, ['coords'] = vector3(1680.0, 2100.0, -100.0)}, -- spawn #45
        {['taken'] = false, ['coords'] = vector3(1740.0, 2100.0, -100.0)}, -- spawn #46
        {['taken'] = false, ['coords'] = vector3(1800.0, 2100.0, -100.0)}, -- spawn #47
        {['taken'] = false, ['coords'] = vector3(1860.0, 2100.0, -100.0)}, -- spawn #48
        {['taken'] = false, ['coords'] = vector3(1920.0, 2100.0, -100.0)}, -- spawn #49
        {['taken'] = false, ['coords'] = vector3(1980.0, 2100.0, -100.0)}, -- spawn #50
        {['taken'] = false, ['coords'] = vector3(2040.0, 2100.0, -100.0)}, -- spawn #51
        {['taken'] = false, ['coords'] = vector3(2100.0, 2100.0, -100.0)}, -- spawn #52
        {['taken'] = false, ['coords'] = vector3(2160.0, 2100.0, -100.0)}, -- spawn #53
        {['taken'] = false, ['coords'] = vector3(2220.0, 2100.0, -100.0)}, -- spawn #54
        {['taken'] = false, ['coords'] = vector3(2280.0, 2100.0, -100.0)}, -- spawn #55
        {['taken'] = false, ['coords'] = vector3(2340.0, 2100.0, -100.0)}, -- spawn #56
        {['taken'] = false, ['coords'] = vector3(2400.0, 2100.0, -100.0)}, -- spawn #57
        {['taken'] = false, ['coords'] = vector3(2460.0, 2100.0, -100.0)}, -- spawn #58
        {['taken'] = false, ['coords'] = vector3(2520.0, 2100.0, -100.0)}, -- spawn #59
        {['taken'] = false, ['coords'] = vector3(2580.0, 2100.0, -100.0)}, -- spawn #60
        {['taken'] = false, ['coords'] = vector3(2640.0, 2100.0, -100.0)}, -- spawn #61
        {['taken'] = false, ['coords'] = vector3(2700.0, 2100.0, -100.0)}, -- spawn #62
        {['taken'] = false, ['coords'] = vector3(2760.0, 2100.0, -100.0)}, -- spawn #63
        {['taken'] = false, ['coords'] = vector3(2820.0, 2100.0, -100.0)}, -- spawn #64
        {['taken'] = false, ['coords'] = vector3(2880.0, 2100.0, -100.0)}, -- spawn #65
        {['taken'] = false, ['coords'] = vector3(2940.0, 2100.0, -100.0)}, -- spawn #66
    },
}

Strings = {
    ['Press_E'] = 'Pulsa ~INPUT_CONTEXT~ para %s',  
    ['Furniture_Categories'] = 'Categorias', 
    ['Manage_House'] = 'opciones de casa',  
    ['Buy_House'] = 'comprar casa #%s',  
    ['Knock_House'] = 'llamar a la puerta', 
    ['Your_House'] = 'Tu casa',  
    ['Buyable_House'] = 'Casa en venta', 
    ['Player_House'] = 'Casa con propietario', 
    ['Storage'] = 'acceder a tu armario', 
    ['Sell_House'] = 'Vender por $%s',  
    ['Enter_House'] = 'Entrar en tu casa',  
    ['Sell_Confirm'] = 'Vender casa por $%s?', 
    ['yes'] = 'Si', 
    ['no'] = 'No',  
    ['Sold_House'] = 'Has vendido tu casa por $%s', 
    ['Must_Sell'] = 'Solo puedes tener una propiedad.Vende tu casa para comprar una nueva.',  
    ['Buy_House_Confirm'] = 'Comprar casa #%s por $%s?',  
    ['Manage_Door'] = 'menu de acciones',  
    ['Accept'] = 'Abrir la puerta',  
    ['Exit'] = 'Salir de casa',  
    ['Noone_Home'] = 'No hay nadie en casa,prueba mas tarde', 
    ['Someone_Knocked'] = 'Alguien ha llamado a la puerta.Ve a tu puerta para invitarle a entrar', 
    ['Let_In'] = 'Invitar a alguien a entrar', 
    ['Accept_Player'] = 'Invitar a %s a entrar?', 
    ['Waiting_Owner'] = 'Esperando a que el dueño de la casa te abra la puerta.', 
    ['Buy_Furniture'] = 'entrar a IKEA', 
    ['Buying_Furniture'] = '~INPUT_FRONTEND_LEFT~ ~INPUT_FRONTEND_RIGHT~ buscar\n~INPUT_CELLPHONE_DOWN~ ~INPUT_CELLPHONE_UP~ cambiar categoria (%s)\n~INPUT_FRONTEND_RDOWN~ comprar %s por $%s\n~INPUT_MOVE_UP_ONLY~ ~INPUT_MOVE_DOWN_ONLY~ ~INPUT_VEH_CINEMATIC_UP_ONLY~ ~INPUT_VEH_CINEMATIC_DOWN_ONLY~ ajustar camara\n~INPUT_MOVE_LEFT_ONLY~ ~INPUT_MOVE_RIGHT_ONLY~ rotar\n\n~INPUT_FRONTEND_RRIGHT~ salir', 
    ['Confirm_Purchase'] = 'Comprar %s por $%s?', 
    ['no_money'] = "No tienes suficiente dinero!", 
    ['Bought_Furniture'] = 'Has comprado 1x %s por $%s', 
    ['Furnish'] = 'Decorar tu casa',  
    ['Store_Garage'] = 'Pulsa ~INPUT_CONTEXT~ para guardar el vehiculo', 
    ['Re_Furnish'] = 'Quitar muebles colocados',  
    ['Remove'] = 'Sacar %s (#%s)', 
    ['Amount'] = 'Que cantidad?',  
    ['Player_Inventory'] = 'Tu inventaro', 
    ['House_Inventory'] = 'Inventario', 
    ['Invalid_Amount'] = 'Cantidad invalida.Especifica una cantidad.', 
    ['Store'] = 'Guardar', 
    ['Withdraw'] = 'Sacar', 
    ['Storage_Title'] = 'Armario', 
    ['You_Stored'] = 'Has guardado %sx %s', 
    ['You_Withdrew'] = 'Has sacado %sx %s', 
    ['Not_Enough'] = 'No tienes esa cantidad!', 
    ['Not_Enough_House'] = 'No tienes tanta cantidad!', 
    ['Weapons'] = 'Armas', 
    ['Items'] = 'Objetos', 
    ['No_Weapon'] = 'No tienes ese arma encima!', 
    ['bullets'] = 'Balas', 
    ['Rotation'] = 'rotacion',  
    ['Guests'] = 'Tus invitados tienen que salir de casa antes de que salgas tu.', 
    ['Garage'] = 'Entrar al garaje', 
    ['No_Spawn'] = 'No se pudo encontrar un punto de generación para su casa.',
    ['Host_Left'] = 'El dueño de la casa se ha ido de la ciudad. Te hemos sacado de su casa.', 
    ['No_Money'] = 'No tienes suficiente dinero!', 
    ['Furnishing'] = '~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ ~INPUT_CELLPHONE_DOWN~ ~INPUT_CELLPHONE_UP~ mover\n~INPUT_VEH_CINEMATIC_UP_ONLY~ ~INPUT_VEH_CINEMATIC_DOWN_ONLY~ altura\n~INPUT_ATTACK~ ~INPUT_AIM~ rotar\n~INPUT_DETONATE~ poner en el suelo\n~INPUT_FRONTEND_ENDSCREEN_ACCEPT~ colocar\n~INPUT_FRONTEND_CANCEL~ cancelar' 
}
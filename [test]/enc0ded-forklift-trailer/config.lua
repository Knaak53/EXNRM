-- Please ensure you have read the README.md for information on how to use this mod and its limitations

Config = {
     -- the trailer model. Probably shouldn't change this
    trailerModel = 'trflat',

    -- the pallet model. Probably shouldn't change this
    palletModel = 'p_pallet_02a_s',

    -- the maximum amount of roll or pitch before a product falls off the pallet as is defined as broken
    maxPitchOrRoll = 35.0, 
    
    -- notifications bleep when shown
    notificationsBleep = false,

    -- enable spawn pallet and truck commands for testing. Probably shouldn't be used in production. See README.md for details.
    enableClientCommands = true, 
}

-- IMPORTANT: Only add new product types to the end of this list as some mods may reference a specific index from this list. If you remove a product type, replace it with something else at the same index and of the same category.
Config.productTypes = {
    [1] = {
        category = 'farming',
        model = 'prop_boxpile_08a',
        offset = {z = 0.2},
        rotation = {}
    },
    [2] = {
        category = 'commercial',
        model = 'v_ind_cf_boxes',
        offset = {z = 0.97},
        rotation = {}
    },
    [3] = {
        category = 'industry',
        model = 'prop_cratepile_07a_l1',
        offset = {z = 0.57},
        rotation = {}
    },
    [4] = {
        category = 'industry',
        model = 'prop_box_wood06a',
        offset = {z = 0.31},
        rotation = {}
    },
    [5] = {
        category = 'industry',
        model = 'prop_box_wood07a',
        offset = {z = 0.32},
        rotation = {}
    },
    [6] = {
        category = 'industry',
        model = 'prop_box_wood04a',
        offset = {z = 0.25},
        rotation = {}
    },
    [7] = {
        category = 'postal',
        model = 'prop_box_wood03a',
        offset = {z = 0.25},
        rotation = {}
    },
    [8] = {
        category = 'military',
        model = 'prop_box_wood02a_pu',
        offset = {z = 0.25},
        rotation = {}
    },
    [9] = {
        category = 'security',
        model = 'prop_box_wood02a_mws',
        offset = {z = 0.25},
        rotation = {}
    },
    [10] = {
        category = 'farming',
        model = 'prop_watercrate_01',
        offset = {z = 0.25},
        rotation = {}
    },
    [11] = {
        category = 'military',
        model = 'prop_box_ammo06a',
        offset = {z = 0.18},
        rotation = {}
    },
    [12] = {
        category = 'military',
        model = 'prop_drop_crate_01_set2',
        offset = {z = 0.8},
        rotation = {}
    },
    [13] = {
        category = 'church',
        model = 'prop_gravestones_09a',
        offset = {z = 0.25},
        rotation = {},
        max = 2
    },
    [14] = {
        category = 'construction',
        model = 'prop_glf_roller',
        offset = {z = 0.25},
        rotation = {}
    },
    [15] = {
        category = 'construction',
        model = 'prop_conc_blocks01a',
        offset = {z = 0.25},
        rotation = {}
    },
    [16] = {
        category = 'construction',
        model = 'prop_diggerbkt_01',
        offset = {z = 0.24},
        rotation = {z = 90.0},
        spacing = {y = 3.5}, -- optional if mandated spacing is required for wider products
        max = 2
    },
    [17] = {
        category = 'industry',
        model = 'prop_cablespool_05',
        offset = {z = 0.25},
        rotation = {}
    },
    [18] = {
        category = 'construction',
        model = 'prop_conc_blocks01c',
        offset = {z = 0.25},
        rotation = {}
    },
    [19] = {
        category = 'construction',
        model = 'prop_cons_cements01',
        offset = {z = 0.35},
        rotation = {}
    },
    [20] = {
        category = 'commercial',
        model = 'prop_vend_soda_02',
        offset = {z = 1.175},
        rotation = {},
        max = 2
    },
    [21] = {
        category = 'commercial',
        model = 'prop_arcade_02',
        offset = {z = 0.25},
        rotation = {},
        max = 1
    },
    [22] = {
        category = 'commercial',
        model = 'prop_arcade_02',
        offset = {z = 0.25},
        rotation = {},
        max = 1
    },
    [23] = {
        category = 'church',
        model = 'prop_coffin_01',
        offset = {z = 0.6},
        rotation = {}
    },
    [24] = {
        category = 'industry',
        model = 'prop_biotech_store',
        offset = {z = 0.85},
        rotation = {},
    },
    [25] = {
        category = 'commercial',
        model = 'prop_boxpile_03a',
        offset = {z = 0.25},
        rotation = {},
    },
    [26] = {
        category = 'commercial',
        model = 'prop_boxpile_06b',
        offset = {z = 0.25},
        rotation = {},
    },
    [27] = {
        category = 'industry',
        model = 'prop_barrel_pile_03',
        offset = {y = -0.25, z = 0.25},
        rotation = {},
    },
--[[  Product type template
    [28] = {
        -- the category of the product. Scripts will use this to determine the location to spawn this product at.
        category = 'industry',
        
        -- the product mode that will go on the pallet. 
        model = 'prop_barrel_pile_03',
        
        -- any offsets needed to make the product fit on the pallet properly. Accepts x, y and z coordinates.
        offset = {z = 0.25},
    }
--]]
}

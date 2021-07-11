Config = {
    trailerModel = 'trflat', -- the trailer model. Probably shouldn't change this
    palletModel = 'p_pallet_02a_s',  -- the pallet model. Probably shouldn't change this
    maxPitchOrRoll = 35.0, -- the maximum amount of roll or pitch before a product falls off the pallet
}

-- IMPORTANT: Only add new product types to the end of this list as some mods may reference a specific index from this list. If you remove a product type, replace it with something else at the same index and of the same category.
Config.productTypes = {
    [1] = {
        category = 'farming',
        model = 'prop_boxpile_08a',
        offset = {z = 0.2},
    },
    [2] = {
        category = 'commercial',
        model = 'v_ind_cf_boxes',
        offset = {z = 0.97}
    },
    [3] = {
        category = 'industry',
        model = 'prop_cratepile_07a_l1',
        offset = {z = 0.57}
    },
    [4] = {
        category = 'industry',
        model = 'prop_box_wood06a',
        offset = {z = 0.31}
    },
    [5] = {
        category = 'industry',
        model = 'prop_box_wood07a',
        offset = {z = 0.32}
    },
    [6] = {
        category = 'industry',
        model = 'prop_box_wood04a',
        offset = {z = 0.25}
    },
    [7] = {
        category = 'postal',
        model = 'prop_box_wood03a',
        offset = {z = 0.25}
    },
    [8] = {
        category = 'military',
        model = 'prop_box_wood02a_pu',
        offset = {z = 0.25}
    },
    [9] = {
        category = 'security',
        model = 'prop_box_wood02a_mws',
        offset = {z = 0.25}
    },
    [10] = {
        category = 'farming',
        model = 'prop_watercrate_01',
        offset = {z = 0.25}
    },
    [11] = {
        category = 'military',
        model = 'prop_box_ammo06a',
        offset = {z = 0.18}
    },
    [12] = {
        category = 'military',
        model = 'prop_drop_crate_01_set2',
        offset = {z = 0.8}
    },
    [13] = {
        category = 'church',
        model = 'prop_gravestones_09a',
        offset = {z = 0.25},
        max = 2
    },
    [14] = {
        category = 'construction',
        model = 'prop_glf_roller',
        offset = {z = 0.25},
        max = 2
    },
    [15] = {
        category = 'construction',
        model = 'prop_conc_blocks01a',
        offset = {z = 0.25}
    },
    [16] = {
        category = 'construction',
        model = 'prop_diggerbkt_01',
        offset = {z = 0.25},
        max = 2
    },
    [17] = {
        category = 'industry',
        model = 'prop_cablespool_05',
        offset = {z = 0.25}
    },
    [18] = {
        category = 'construction',
        model = 'prop_conc_blocks01c',
        offset = {z = 0.25}
    },
    [19] = {
        category = 'construction',
        model = 'prop_cons_cements01',
        offset = {z = 0.35}
    },
    [20] = {
        category = 'commercial',
        model = 'prop_vend_soda_02',
        offset = {z = 1.175},
        max = 2
    },
    [21] = {
        category = 'commercial',
        model = 'prop_arcade_02',
        offset = {z = 0.25},
        max = 1
    },
    [22] = {
        category = 'commercial',
        model = 'prop_arcade_02',
        offset = {z = 0.25},
        max = 1
    },
    [23] = {
        category = 'church',
        model = 'prop_coffin_01',
        offset = {z = 0.6}
    },
    [24] = {
        category = 'industry',
        model = 'prop_biotech_store',
        offset = {z = 0.85},
    },
    [25] = {
        category = 'commercial',
        model = 'prop_boxpile_03a',
        offset = {z = 0.25},
    },
    [26] = {
        category = 'commercial',
        model = 'prop_boxpile_07d',
        offset = {z = 0.25},
    },
    [27] = {
        category = 'commercial',
        model = 'prop_boxpile_09a',
        offset = {z = 0.25},
    },
    [28] = {
        category = 'commercial',
        model = 'prop_boxpile_06b',
        offset = {z = 0.25},
    },
    [29] = {
        category = 'industry',
        model = 'prop_barrel_pile_03',
        offset = {y = -0.25, z = 0.25},
    },
    [30] = {
        category = 'wood',
        model = 'prop_cratepile_07a_l1',
        offset = {y = -0.25, z = 0.7},
    },
--[[  Product type template
    [30] = {
        -- the category of the product. Scripts will use this to determine the location to spawn this product at.
        category = 'industry',
        
        -- the product mode that will go on the pallet. 
        model = 'prop_barrel_pile_03',
        
        -- any offsets needed to make the product fit on the pallet properly. Accepts x, y and z coordinates.
        offset = {z = 0.25},
    }
--]]
}

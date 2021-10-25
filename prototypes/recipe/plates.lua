
-- How to add fluid ingredients/products
-- ingredients = {
--     {
--         amount = 5,
--         name = "steel-plate",
--         type = "item"
--     },
--     {
--         amount = 100,
--         name = "crude-oil",
--         type = "fluid"
--     }
-- }

data:extend({

    -- First, we do the basic iron and copper smelting
    {
        type="recipe",
        enabled = false,
        category = "basic-smelting",
        name = "iron-plate-smelting",

        energy_required = 4,
        ingredients = {
            {"iron-ore", 3},
        },
        
        result = "iron-plate",
        result_count = 2,

    },

    {
        type="recipe",
        enabled = false,
        category = "basic-smelting",
        name = "copper-plate-smelting",

        energy_required = 4,
        ingredients = {
            {"copper-ore", 3},
        },
        
        result = "copper-plate",
        result_count = 2,

    },

    -- Now we look at advanced iron and copper smelting
    {
        type="recipe",
        enabled = false,
        category = "advanced-smelting",
        name = "advanced-iron-plate-smelting",

        energy_required = 6,
        ingredients = {
            {"iron-ore", 2},
            {"coal", 1}
        },
        
        result = "iron-plate",
        result_count = 3,

    },

    {
        type="recipe",
        enabled = false,
        category = "advanced-smelting",
        name = "advanced-copper-plate-smelting",

        energy_required = 6,
        ingredients = {
            {"copper-ore", 2},
            {"coal", 1}
        },
        
        result = "copper-plate",
        result_count = 3,

    },

})
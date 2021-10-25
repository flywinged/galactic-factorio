require("lib.images")

local minerCount = 1

local function createMiner()

    -- First we'll create the miner entity
    local name = "adaptive-miner-"..tostring(minerCount)

    local minerEntity = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])
    minerEntity.name = name
    minerEntity.minable.result = name
    minerEntity.crafting_categories = {"adaptive-mining-tier-1"}
    minerEntity.crafting_speed = 1.0
    minerEntity.collision_box = {{-0.7, -0.7}, {0.7, 0.7}}
    minerEntity.selection_box = {{-1, -1}, {1, 1}}
    Images.MultiplyImages(minerEntity, 0.66)
    minerEntity.next_upgrade = nil
    Images.TintImages(minerEntity, {r = 1.0, g = 0.5, b = 0.5})

    -- Now create the miner item
    local minerItem = table.deepcopy(data.raw["item"]["assembling-machine-1"])
    minerItem.name = name
    minerItem.place_result = name
    Images.TintRecipeOrItem(minerItem, {r = 1.0, g = 0.5, b = 0.5})

    -- Final create the new recipe
    local minerRecipe = table.deepcopy(data.raw["recipe"]["assembling-machine-1"])
    minerRecipe.name = name
    minerRecipe.result = name
    minerRecipe.normal = nil
    minerRecipe.expensive = nil
    minerRecipe.enabled = true

    -- Add all the generated stuff to the data table
    data:extend({minerEntity, minerItem, minerRecipe})

    minerCount = minerCount + 1

end

-- -- createMiner()

-- data.raw["mining-drill"]["burner-mining-drill"].mining_speed = .5
-- data.raw["mining-drill"]["burner-mining-drill"].energy_usage = "250kW"

-- local coalBlock = table.deepcopy(data.raw["item"]["solid-fuel"])
-- coalBlock.name = "coal-block"
-- coalBlock.fuel_value = "40MJ"
-- coalBlock.fuel_acceleration_multiplier = 1.0
-- coalBlock.fuel_top_speed_multiplier = 1.0
-- Images.TintRecipeOrItem(coalBlock, {r = 0.2, g = 0.2, b = 0.2})

-- local coalBlockRecipe = {
--     type = "recipe",
--     name = "coal-block",
--     enabled = true,

--     energy_required = 5,

--     ingredients =
--     {
--         {"coal", 8},
--     },

--     result = "coal-block",
--     result_count = 1
-- }

-- data:extend({coalBlock, coalBlockRecipe})
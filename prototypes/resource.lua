require("lib.images")
require("prototypes.const")

-- Reminder for how to do fluid mining
-- minable = {
--     fluid_amount = 10,
--     mining_particle = "stone-particle",
--     mining_time = 2,
--     required_fluid = "sulfuric-acid",
--     result = "uranium-ore"
-- }

-- Create the new resource electrum
local electrumResource = table.deepcopy(data.raw["resource"]["copper-ore"])
Images.TintImages(electrumResource, ELECTRUM_TINT)
electrumResource.map_color={255, 255, 0}
electrumResource.minable.result = "electrum-ore"
electrumResource.minable.mining_time = 2
electrumResource.name = "electrum-ore"

local electrumItem = table.deepcopy(data.raw["item"]["copper-ore"])
Images.TintRecipeOrItem(electrumItem, ELECTRUM_TINT)
electrumItem.name = "electrum-ore"
electrumItem.pictures = nil

data:extend({electrumResource, electrumItem})

-- Create the new resource cobalt
local cobaltResource = table.deepcopy(data.raw["resource"]["iron-ore"])
Images.TintImages(cobaltResource, COBALT_TINT)
cobaltResource.map_color={55, 55, 220}
cobaltResource.minable.result = "cobalt-ore"
cobaltResource.minable.mining_time = 2
cobaltResource.name = "cobalt-ore"

local cobaltItem = table.deepcopy(data.raw["item"]["iron-ore"])
Images.TintRecipeOrItem(cobaltItem, COBALT_TINT)
cobaltItem.name = "cobalt-ore"
cobaltItem.pictures = nil

data:extend({cobaltResource, cobaltItem})
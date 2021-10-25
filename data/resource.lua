require("lib.images")

-- Create the new resource electrum
local electrumResource = table.deepcopy(data.raw["resource"]["copper-ore"])
Images.TintImages(electrumResource, {r=1.0, g=1.0, b=0.0, a=0.6})
electrumResource.map_color={255, 255, 0}
electrumResource.minable.result = "electrum-ore"
electrumResource.name = "electrum-ore"

local electrumItem = table.deepcopy(data.raw["item"]["copper-ore"])
Images.TintRecipeOrItem(electrumItem, {r=1.0, g=1.0, b=0.0, a=0.6})
electrumItem.name = "electrum-ore"
electrumItem.pictures = nil

data:extend({electrumResource, electrumItem})

-- Create the new resource cobalt
local cobaltResource = table.deepcopy(data.raw["resource"]["iron-ore"])
Images.TintImages(cobaltResource, {r=0.4, g=0.4, b=0.8})
cobaltResource.map_color={55, 55, 220}
cobaltResource.minable.result = "cobalt-ore"
cobaltResource.name = "cobalt-ore"

local cobaltItem = table.deepcopy(data.raw["item"]["iron-ore"])
Images.TintRecipeOrItem(cobaltItem, {r=0.4, g=0.4, b=0.8})
cobaltItem.name = "cobalt-ore"
cobaltItem.pictures = nil

data:extend({cobaltResource, cobaltItem})
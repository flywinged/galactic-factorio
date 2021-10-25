require("lib.images")
require("prototypes.const")

-- Add in the iron, copper, and steel plates
local ironPlate = table.deepcopy(data.raw["item"]["iron-plate"])
ironPlate.name = "gf-iron-plate"
local copperPlate = table.deepcopy(data.raw["item"]["copper-plate"])
copperPlate.name = "gf-copper-plate"
local steelPlate = table.deepcopy(data.raw["item"]["steel-plate"])
steelPlate.name = "gf-steel-plate"
data:extend({ironPlate, copperPlate, steelPlate})

-- Create the electrum and cobalt plates
local electrumPlate = table.deepcopy(data.raw["item"]["copper-plate"])
Images.TintImages(electrumPlate, ELECTRUM_TINT)
electrumPlate.name = "electrum-plate"
local cobaltPlate = table.deepcopy(data.raw["item"]["iron-plate"])
Images.TintImages(cobaltPlate, COBALT_TINT)
cobaltPlate.name = "cobalt-plate"
data:extend({electrumPlate, cobaltPlate})

-- Add all the different alloys
local cobaltSteelPlate = table.deepcopy(steelPlate)
Images.TintImages(cobaltSteelPlate, COBALT_STEEL_TINT)
cobaltSteelPlate.name = "cobalt-steel-plate"
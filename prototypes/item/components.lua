require("lib.images")
require("prototypes.const")

-- Recreate iron gear wheel (rebranded as components) and copper-cable (rebranded as copper-wire)
local ironComponents = table.deepcopy(data.raw["item"]["iron-gear-wheel"])
ironComponents.name = "iron-components"
local copperWire = table.deepcopy(data.raw["item"]["copper-cable"])
copperWire.name = "copper-wire"
data:extend({ironComponents, copperWire})
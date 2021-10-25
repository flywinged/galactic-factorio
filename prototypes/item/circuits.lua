require("lib.images")
require("prototypes.const")

local circuit1 = table.deepcopy(data.raw["item"]["electronic-circuit"])
circuit1.name = "circuit-1"
local circuit2 = table.deepcopy(data.raw["item"]["electronic-circuit"])
Images.TintRecipeOrItem(circuit2, {0.7, 0.5, 0.0})
circuit2.name = "circuit-2"
local circuit3 = table.deepcopy(data.raw["item"]["advanced-circuit"])
circuit3.name = "circuit-3"
local circuit4 = table.deepcopy(data.raw["item"]["advanced-circuit"])
Images.TintRecipeOrItem(circuit4, {0.0, 0.4, 0.8})
circuit4.name = "circuit-4"
local circuit5 = table.deepcopy(data.raw["item"]["processing-unit"])
circuit5.name = "circuit-5"
data:extend({circuit1, circuit2, circuit3, circuit4, circuit5})

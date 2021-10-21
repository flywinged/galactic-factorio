-- The spaceport is what let's the game know that a
-- location is available to have items shipped to it.

local spaceportHubEntity = table.deepcopy(data.raw["roboport"]["roboport"])
spaceportHubEntity.name = "spaceport-hub"
spaceportHubEntity.logistics_radius = 1
spaceportHubEntity.construction_radius = 1
spaceportHubEntity.icons = {{icon = "__base__/graphics/icons/roboport.png", tint={r=0.3, g=0.3, b=0.3, a=1.0}}}
spaceportHubEntity.minable = {hardness = 0.2, mining_time = 0.1, result = "spaceport-hub"}

local spaceportHubItem = table.deepcopy(data.raw.item["roboport"])
spaceportHubItem.name = "spaceport-hub"
spaceportHubItem.icons = {{icon = "__base__/graphics/icons/roboport.png", tint={r=0.3, g=0.3, b=0.3, a=1.0}}}
spaceportHubItem.place_result = "spaceport-hub"

local spaceportHubRecipe = table.deepcopy(data.raw.recipe["roboport"])
spaceportHubRecipe.name = "spaceport-hub"
spaceportHubRecipe.result = "spaceport-hub"
spaceportHubRecipe.result_count = 1
spaceportHubRecipe.enabled = true

data:extend({spaceportHubEntity, spaceportHubItem, spaceportHubRecipe})
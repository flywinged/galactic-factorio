require("entities.base.solar")
require("entities.base.pumps")
require("entities.base.miners")

require("entities.spaceport")

data:extend(
{
    {
        type = "custom-input",
        name = "gf-teleport",
        key_sequence = "SHIFT + F",
    },
    {
        type = "custom-input",
        name = "gf-configure-spaceport",
        key_sequence = "SHIFT + S",
    },

    {
        type = "custom-input",
        name = "reset-for-debugging",
        key_sequence = "SHIFT + R",
    }

}
)

data:extend({

    {
        type = "recipe-category",
        name = "adaptive-mining-tier-1"
    }

})

-- Disable EVERYTHING in the default game
for _, technology in pairs(data.raw["technology"]) do
    technology.hidden = true
    technology.enabled = false
end

for name, recipe in pairs(data.raw["recipe"]) do
    log(name.."-"..tostring(recipe.hidden).."-"..tostring(recipe.enabled))
    recipe.hidden = true
    recipe.enabled = false

    if recipe.normal ~= nil then
        recipe.expensive = nil
        recipe.ingredients = recipe.normal.ingredients
        recipe.result = recipe.normal.result
        recipe.result_count = recipe.normal.result_count
        recipe.normal = nil
    end

end
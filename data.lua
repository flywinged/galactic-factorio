require("lib.data")

require("entities.base.solar")
require("entities.base.pumps")
require("entities.base.miners")

require("entities.spaceport")

-- Called to remove all the original technologies and recipes
RemoveBase()

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
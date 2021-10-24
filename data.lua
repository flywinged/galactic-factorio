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

require("lib.images")

local panelCount = 1

local function createSolarPanel(
    production,
    tint,
    ingredients
)

    -- First we'll create the panel entity
    local name = "solar-panel-"..tostring(panelCount)

    local panelEntity = table.deepcopy(data.raw["solar-panel"]["solar-panel"])
    panelEntity.name = name
    panelEntity.minable.result = name
    panelEntity.production = tostring(production).."kW"
    Images.TintImages(panelEntity, tint)

    -- Now create the panel item
    local panelItem = table.deepcopy(data.raw["item"]["solar-panel"])
    panelItem.name = name
    panelItem.place_result = name
    Images.TintRecipeOrItem(panelItem, tint)

    -- Final create the new recipe
    local panelRecipe = table.deepcopy(data.raw["recipe"]["solar-panel"])
    panelRecipe.name = name
    panelRecipe.result = name
    panelRecipe.ingredients = ingredients
    panelRecipe.enabled = true

    -- Add all the generated stuff to the data table
    data:extend({panelEntity, panelItem, panelRecipe})

    panelCount = panelCount + 1

end

local function removeSolarPanel ()
    data.raw["solar-panel"]["solar-panel"] = nil
    data.raw["item"]["solar-panel"] = nil
    data.raw["recipe"]["solar-panel"] = nil
end

-- Create each tier of solar panel
createSolarPanel(
    90,
    {r=.4, g=.7, b=.4, a=1.0},
    {
        {"electronic-circuit", 12}
    }
)

createSolarPanel(
    270,
    {r=.7, g=.4, b=.4, a=1.0},
    {
        {"electronic-circuit", 12}
    }
)
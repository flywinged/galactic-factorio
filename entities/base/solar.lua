require("lib.images")

local panelCount = 1

local function createSolarPanel(
    production,
    tint,
    ingredients
)

    -- First we'll create the panel entity
    local name = "solar-panel-"..tostring(panelCount)

    if panelCount == 1 then
        name = "solar-panel"
    end

    local panelEntity = table.deepcopy(data.raw["solar-panel"]["solar-panel"])
    panelEntity.name = name
    panelEntity.minable.result = name
    panelEntity.production = tostring(production).."kW"
    panelEntity.collision_box = {{-0.7, -0.7}, {0.7, 0.7}}
    panelEntity.selection_box = {{-1, -1}, {1, 1}}

    if panelCount == 1 then
        Images.MultiplyImages(panelEntity, 0.66)
    else
        Images.TintImages(panelEntity, tint)
    end

    -- Now create the panel item
    local panelItem = table.deepcopy(data.raw["item"]["solar-panel"])
    panelItem.name = name
    panelItem.place_result = name
    if panelCount ~= 1 then Images.TintRecipeOrItem(panelItem, tint) end

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

-- -- Create each tier of solar panel
-- createSolarPanel(
--     90,
--     {r=.3, g=.3, b=.3, a=1.0},
--     {
--         {"iron-plate", 8},
--         {"copper-plate", 4},
--         {"electronic-circuit", 12}
--     }
-- )

-- createSolarPanel(
--     150,
--     {r=.4, g=.6, b=.4, a=1.0},
--     {
--         {"solar-panel", 1},
--         {"steel-plate", 8},
--         {"copper-plate", 4},
--         {"electronic-circuit", 24}
--     }
-- )

-- createSolarPanel(
--     250,
--     {r=.8, g=.4, b=.4, a=1.0},
--     {
--         {"solar-panel-2", 1},
--         {"steel-plate", 8},
--         {"copper-plate", 4},
--         {"advanced-circuit", 12}
--     }
-- )

-- createSolarPanel(
--     500,
--     {r=.4, g=.4, b=.6, a=1.0},
--     {
--         {"solar-panel-3", 1},
--         {"steel-plate", 8},
--         {"copper-plate", 4},
--         {"advanced-circuit", 24}
--     }
-- )

-- createSolarPanel(
--     1000,
--     {r=.35, g=.35, b=.35, a=1.0},
--     {
--         {"solar-panel-4", 1},
--         {"steel-plate", 8},
--         {"copper-plate", 4},
--         {"processing-unit", 12}
--     }
-- )
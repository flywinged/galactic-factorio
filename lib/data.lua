

-- Disables all the raw technologies and recipes in the game
function RemoveBase()

    -- First turn off technologies
    for _, technology in pairs(data.raw["technology"]) do
        technology.hidden = true
        technology.enabled = false
    end

    -- Recipes are a bit more complicated
    for _, recipe in pairs(data.raw["recipe"]) do
        recipe.hidden = true
        recipe.enabled = false

        -- Need to make sure that if there is a normal/expensive split for
        -- the recipe, it is still disabled.
        if recipe.normal ~= nil then
            recipe.expensive = nil
            recipe.ingredients = recipe.normal.ingredients
            recipe.result = recipe.normal.result
            recipe.result_count = recipe.normal.result_count
            recipe.normal = nil
        end

    end

end
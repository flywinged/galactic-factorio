require("loops")

-- Convert a location to strings
local function getStringLocation(location)
    return tostring(location.x)..","..tostring(location.y)
end

local AVERAGE_PLANET_SIZE = 64
local PLANET_DEVIATION = 16
local MIN_PLANET_SIZE = 16
local MAX_PLANET_SIZE = 100
local MINIMUM_PLANET_SPACING = 12 -- in Chunks
local MAXIMUM_PLANET_SPACING = 16 -- in chunks
-- Average number of other planets generated between the minimum
-- and maximum spacings around each planet.
local AVERAGE_PLANET_DENSITY = 3

-- Resource chance
local RESOURCE_CHANCES = {
    ["iron-ore"] = 0.3,
    ["copper-ore"] = 0.3,
    ["coal"] = 0.2,
    ["stone"] = 0.15,
    ["crude-oil"] = 0.1,
    ["electrum-ore"] = 0.05,
    ["cobalt-ore"] = 0.05,
    ["uranium-ore"] = 0.05,
}

-- Planets get generated larger and larger the further out you go
-- Every 1000 blocks is another power
local DISTANCE_EXPONENT = 1.05
local MAX_EXPONENT = 4

local function addResourceToPlanet(
    resourceTable,
    generationCenters,
    liquid
)

    local randomIndex = global.randomGenerator(1, #generationCenters)

    if liquid then
        table.insert( resourceTable, generationCenters[randomIndex] )
        table.remove( generationCenters, randomIndex )
        return 
    end

    local distance = (generationCenters[randomIndex].x^2 + generationCenters[randomIndex].y^2)^0.5
    local distanceModifier = DISTANCE_EXPONENT ^ (distance / 1000)
    if distanceModifier > MAX_EXPONENT then distanceModifier = MAX_EXPONENT end

    local loop = GenerateLoop(generationCenters[randomIndex], 4, 0.55)
    SetLoopMeanAndSTD(
        loop,
        distanceModifier * 5,
        distanceModifier * 3,
        distanceModifier * 1,
        distanceModifier * 8
    )
    table.insert( resourceTable, loop)
    table.remove( generationCenters, randomIndex )

end

local function generatePlanet(
    center,
    startingPlanet
)

    log("Creating Planet")
    log(getStringLocation(center))

    local distance = (center.x^2 + center.y^2)^0.5
    local distanceModifier = DISTANCE_EXPONENT ^ (distance / 1000)
    if distanceModifier > MAX_EXPONENT then distanceModifier = MAX_EXPONENT end

    -- Generate the planet loop
    local planetLoop = GenerateLoop(center, 8, .55)
    SetLoopMeanAndSTD(
        planetLoop,
        distanceModifier * AVERAGE_PLANET_SIZE,
        distanceModifier * PLANET_DEVIATION,
        distanceModifier * MIN_PLANET_SIZE,
        distanceModifier * MAX_PLANET_SIZE
    )

    -- Determine what chunks are enclosed by this planet
    local chunks = {}
    local chunkPosition = {
        x=math.floor( center.x / 32 ),
        y=math.floor( center.y / 32 )
    }

    local radius = math.ceil( MAX_PLANET_SIZE / 32 )
    for x = -radius, radius do
        for y = -radius, radius do
            chunks[getStringLocation({
                x=x + chunkPosition.x,
                y=y + chunkPosition.y
            })] = true
        end
    end

    -- Pick a bunch of random locations on the planet where resources could
    -- be generated. These positions will be chosen arbitrarily by
    -- each resource.
    local generationCenters = {}
    local attempts = 0
    while #generationCenters < 12 and attempts < 1000 do

        -- Generate an arbitrary position
        local angle = 2 * math.pi * Random()
        local distanceFromCenter = GetLoopRadius(planetLoop, angle) * (.1 + (.8 * Random()))
        local position = {
            x = math.floor(planetLoop.center.x + math.cos(angle) * distanceFromCenter),
            y = math.floor(planetLoop.center.y + math.sin(angle) * distanceFromCenter)
        }

        -- Ensure this position is far enough away from other generated positions
        for _, location in ipairs(generationCenters) do
            local distance = ((location.x - position.x)^2 + (location.y - position.y)^2)^(1/2)
            if distance < AVERAGE_PLANET_SIZE / 4 then goto skip end
        end

        -- If here without skipping, we should add this center
        table.insert( generationCenters, position )

        ::skip::
        attempts = attempts + 1

    end

    local resourceLoops = {}
    for resourceName, resourceChance in pairs(RESOURCE_CHANCES) do
        resourceLoops[resourceName] = {}

        -- For now, just write each generation event out explicitly
    if (
        startingPlanet and
        resourceName == "iron-ore" or 
        resourceName == "copper-ore" or
        resourceName == "coal" or
        resourceName == "stone"
    )then
        addResourceToPlanet(resourceLoops[resourceName], generationCenters, false)
    else
        while Random() < resourceChance and #generationCenters > 0 do addResourceToPlanet(resourceLoops[resourceName], generationCenters, false) end
    end

    end

    

    -- Create the planet object
    local planet = {
        chunks = chunks,
        landLoops = {
            inside = {planetLoop},
            outside = nil,
        },
        resourceLoops = resourceLoops,
        center = center,
    }

    -- Update the global objects accordingly
    for chunkID, _ in pairs(chunks) do
        global.planetChunks[chunkID] = planet
    end

    global.planetCenters[getStringLocation(chunkPosition)] = chunkPosition

end

script.on_event(defines.events.on_chunk_generated, function(event)

    -- Extract fields from the event so that function is
    -- more readable.
    local chunkPosition = event.position
    local area = event.area
    local surface = event.surface

    local x1 = area.left_top.x
    local y1 = area.left_top.y
    local x2 = area.right_bottom.x
    local y2 = area.right_bottom.y

    --  Distance values
    local distance = 32*((chunkPosition.x^2 + chunkPosition.y^2)^0.5)
    local rawDistanceModifier = DISTANCE_EXPONENT ^ (distance / 1000)
    local distanceModifier = rawDistanceModifier
    if distanceModifier > MAX_EXPONENT then distanceModifier = MAX_EXPONENT end

    -- Delete all generated entities
    local entities = surface.find_entities(area)
    for _, entity in ipairs(entities) do
        if entity.get_main_inventory() == nil then
            entity.destroy()
        end
    end

    -- Intitialize the global values if they don't already exists
    -- This is where information about each planet generation is stored.
    if global.initialized == nil then
        
        -- Set the intialized Value to true
        global.initialized = true

        -- We need a generator for everything else
        global.randomGenerator = game.create_random_generator()

        -- Map of chunks to the planet that is there
        global.planetChunks = {}

        -- Map of all the chunks which have been generated
        global.chunksGenerated = {}

        -- Chunks which contain a planet center
        global.planetCenters = {}

        -- Chunks which have already been checked for creating a planet center.
        global.checkedChunks = {}

        --  Generate the initial spawn planet
        generatePlanet({x=0, y=0}, true)

        -- Set the terrain geenration setting necessary for the mod to function
        surface.always_day = true

    end

    -- Tiles is what we will build up
    local tiles = {}

    -- Determine if this chunk is inside of a planet
    local chunkString = getStringLocation(chunkPosition)
    local planet = global.planetChunks[chunkString]

    -- Loop through all the tiles in the chunk
    for x = x1, x2 do
        for y = y1, y2 do

            if planet == nil then
                table.insert( tiles, {name = "out-of-map", position = {x, y}})
                -- table.insert( tiles, {name = "dirt-1", position = {x, y}})
            else

                -- Loop through all the inclusive loops
                local point = {x=x, y=y}
                local outOfMap = InsideLoops(planet.landLoops, point)

                -- Insert the appropriate values
                if outOfMap then
                    table.insert( tiles, {name = "dirt-2", position = {x, y}})
                else
                    table.insert( tiles, {name = "out-of-map", position = {x, y}})
                    -- table.insert( tiles, {name = "grass-1", position = {x, y}})
                    goto skip
                end

                -- Place the resource where relevant
                for resourceName, loops in pairs(planet.resourceLoops) do
                    for _, loop in ipairs(loops) do

                        if resourceName == "crude-oil" then
                            for _, location in ipairs(planet.resourceLoops[resourceName]) do
                                if location.x == point.x and location.y == point.y then
                                    surface.create_entity({
                                        name=resourceName,
                                        position=point,
                                        minimum_amount=300000 * rawDistanceModifier, -- Corresponds to 100% at the origin
                                        amount=300000 * rawDistanceModifier
                                    })
                                    goto skip
                                end
                            end
                        
                        else
                            if InsideLoop(loop, point) < 0 then
                                surface.create_entity({
                                    name=resourceName,
                                    position=point,
                                    amount=10000 * rawDistanceModifier
                                })
                                goto skip
                            end
                        end

                        
                    end
                end

                ::skip::

            end

        end
    end

    -- Remove the generation
    global.planetChunks[getStringLocation(chunkPosition)] = nil

    -- Update the surface tiles
    surface.set_tiles(tiles)

    -- Update the generated chunks
    global.chunksGenerated[chunkString] = true

    -- Values for determining generation chance
    local adjustedMaxSpacing = math.floor(distanceModifier * MAXIMUM_PLANET_SPACING)
    local adjustedMinSpacing = math.floor(distanceModifier * MINIMUM_PLANET_SPACING)
    local maximumSize = distanceModifier * adjustedMaxSpacing * adjustedMaxSpacing
    local minimumSize = distanceModifier * adjustedMinSpacing * adjustedMinSpacing
    local area = maximumSize - minimumSize
    local generationChance = AVERAGE_PLANET_DENSITY / area

    -- Determine if any other planets should be generated
    -- We do this whenever we generate a chunk which is the center
    -- of an island.
    if global.planetCenters[chunkString] ~= nil then

        -- First determine all the locations which could
        -- have another planet generated.
        local possibleLocations = {}
        for x = -adjustedMaxSpacing, adjustedMaxSpacing do
            for y = -adjustedMaxSpacing, adjustedMaxSpacing do
                table.insert( possibleLocations, {
                    x = chunkPosition.x + x,
                    y = chunkPosition.y + y
                })
            end
        end

        -- Keep trying to generate. Requires at least one generation if possible
        local generatedAtLeastOne = false
        while #possibleLocations > 0 do
            
            local index = global.randomGenerator(1, #possibleLocations)
            local potentialLocation = possibleLocations[index]
            local chunkString = getStringLocation(potentialLocation)

            -- If this chunk has already been generated, continue
            if global.chunksGenerated[chunkString] == true then goto skip end

            -- If this chunk has already been checked, continue
            if global.checkedChunks[chunkString] == true then goto skip end

            -- If here, the chunk is officially checkd
            global.checkedChunks[chunkString] = true

            -- If this chunk is close to another planet center, continue
            for _, planetCenter in pairs(global.planetCenters) do
                local chunkDistance = ((
                    (potentialLocation.x - planetCenter.x) ^ 2 + 
                    (potentialLocation.y - planetCenter.y) ^ 2
                ) ^ 0.5)
                if chunkDistance < adjustedMinSpacing then
                    goto skip
                end
            end

            -- Generate a planet here with some probability. This
            -- Probability needs to be high enough to ensure that the
            -- generation process never ends
            if generatedAtLeastOne == false or Random() < generationChance then
                
                -- Create a new planet at the center of this potential chunk
                generatePlanet({
                    x = potentialLocation.x * 32 + 16,
                    y = potentialLocation.y * 32 + 16
                }, false)

                -- Signify at least one location was generated
                generatedAtLeastOne = true
            end

            ::skip::

            -- Remove this chunk from the array of possible locations
            table.remove(possibleLocations, index)

        end

    end

end)
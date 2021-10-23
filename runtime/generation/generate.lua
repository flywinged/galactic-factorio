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
local AVERAGE_PLANET_DENSITY = 3

local function generatePlanet(center)

    log("Creating Planet")
    log(getStringLocation(center))

    -- Generate the planet loop
    local planetLoop = GenerateLoop(center, 8, .55)
    SetLoopMeanAndSTD(
        planetLoop,
        AVERAGE_PLANET_SIZE,
        PLANET_DEVIATION,
        MIN_PLANET_SIZE,
        MAX_PLANET_SIZE
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

    -- Create the planet object
    local planet = {
        chunks = chunks,
        inclusiveLoops = {planetLoop}
    }

    -- Update the global objects accordingly
    for chunkID, _ in pairs(chunks) do
        global.planetChunks[chunkID] = planet
    end

    global.planetCenters[getStringLocation(chunkPosition)] = chunkPosition

end

script.on_event(defines.events.on_chunk_generated, function(event)

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
        generatePlanet({x=0, y=0})

    end

    -- Extract fields from the event so that function is
    -- more readable.
    local chunkPosition = event.position
    local area = event.area
    local surface = event.surface

    local x1 = area.left_top.x
    local y1 = area.left_top.y
    local x2 = area.right_bottom.x
    local y2 = area.right_bottom.y

    -- Tiles is what we will build up
    local tiles = {}

    -- Determine if this chunk is inside of a planet
    local chunkString = getStringLocation(chunkPosition)
    local planet = global.planetChunks[chunkString]

    -- Loop through all the tiles in the chunk
    for x = x1, x2 do
        for y = y1, y2 do

            if planet == nil then
                -- table.insert( tiles, {name = "out-of-map", position = {x, y}})
                table.insert( tiles, {name = "dirt-1", position = {x, y}})
            else

                -- Loop through all the inclusive loops
                local outOfMap = false
                for _, loop in ipairs(planet.inclusiveLoops) do
                    local distance = InsideLoop(loop, {x=x, y=y})
                    if distance > 0 then
                        outOfMap = true
                        goto outside
                    end
                end

                ::outside::

                -- Insert the appropriate values
                if outOfMap then
                    table.insert( tiles, {name = "dirt-2", position = {x, y}})
                else
                    table.insert( tiles, {name = "grass-1", position = {x, y}})
                end
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
    local maximumSize = MAXIMUM_PLANET_SPACING * MAXIMUM_PLANET_SPACING
    local minimumSize = MINIMUM_PLANET_SPACING * MINIMUM_PLANET_SPACING
    local area = maximumSize - minimumSize
    local generationChance = AVERAGE_PLANET_DENSITY / area

    -- Determine if any other planets should be generated
    -- We do this whenever we generate a chunk which is the center
    -- of an island.
    if global.planetCenters[chunkString] ~= nil then

        -- First determine all the locations which could
        -- have another planet generated.
        local possibleLocations = {}
        for x = -MAXIMUM_PLANET_SPACING, MAXIMUM_PLANET_SPACING do
            for y = -MAXIMUM_PLANET_SPACING, MAXIMUM_PLANET_SPACING do
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
                if chunkDistance < MINIMUM_PLANET_SPACING then
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
                })

                -- Signify at least one location was generated
                generatedAtLeastOne = true
            end

            ::skip::

            -- Remove this chunk from the array of possible locations
            table.remove(possibleLocations, index)

        end

    end

end)
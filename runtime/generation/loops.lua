
-- Used to dermine how small of deviations the random generator can create
local GENERATOR_SIZE = 2e12

-- Quick helper function for creating random values. These
-- Values will always be between -1.0 and 1.0 inclusive
local function random()
    return 2.0 * (Random() - 0.5)
end

function Random()
    return global.randomGenerator(0, GENERATOR_SIZE) / GENERATOR_SIZE
end

-- Create a bunch of random numbers centered at a point.
-- center is in the form {x, y}
function GenerateLoop(center, depth, stepExponent)
    
    -- The final loop needs to have elements in it equal to
    -- 2^depth. depth must be strictly greater or equal
    -- than zero.
    if depth < 0 then depth = 0 end
    local loop = {}

    -- Determine the final size of this loop
    local size = 2^depth

    -- Determine what the first two values should be (the zeroth index
    -- and the middle index)
    loop[0] = random()
    loop[size] = loop[0]
    loop[math.floor(size / 2)] = random()

    -- We start at depth two because *technically, the above lines
    -- are depth 1.
    local currentDepth = 2
    local currentDeviation = stepExponent
    while currentDepth <= depth do
        
        -- Determine the step size for this currentDepth
        local step = 2^(depth - currentDepth)

        -- Start at the initial step
        for point = step, size, 2*step do
            
            -- Determine what the previous and future point are
            -- as well as their average
            local previous = point - step
            local next = point + step
            local average = (loop[previous] + loop[next]) / 2

            -- Apply an offset to the average and set the point value accordingly
            loop[point] = average + currentDeviation * random()

        end

        -- Increase the depth and deviation
        currentDepth = currentDepth + 1
        currentDeviation = stepExponent * currentDeviation

    end

    -- Return the generated loop. Be sure to attach the loop size
    -- to the loop. Include the center as well.
    loop["size"] = size
    loop["center"] = center
    return loop

end

-- Functions for setting values relevant to the loop
function SetLoopMeanAndSTD(loop, mean, STD, min, max)

    -- First determine the current loop mean
    local currentMean = 0
    for i = 0, loop.size - 1 do
        currentMean = currentMean + loop[i]
    end
    currentMean = currentMean / loop.size

    -- Then determine the std
    local currentSTD = 0
    for i = 0, loop.size do
        currentSTD = currentSTD + (loop[i] - currentMean) ^ 2
    end
    currentSTD = (currentSTD / loop.size) ^ 0.5

    -- Now modify the values accordingly
    local scale = STD / currentSTD
    for i = 0, loop.size do
        loop[i] = mean + scale * (loop[i] - currentMean)
        if loop[i] < min then
            loop[i] = min
        end
        if loop[i] > max then
            loop[i] = max
        end
    end 

end

-- Helper function for returning how far outside or inside a loop a point is
-- The value will be positive if it is outside, and negative if it is inside.
function InsideLoop(loop, point)

    -- Determine the angle of the point compared to the loop center
    local deltaX = point.x - loop.center.x
    local deltaY = point.y - loop.center.y
    local angle = math.atan2(deltaY, deltaX)
    if angle < 0 then
        angle = 2*math.pi + angle
    end

    -- Determine the distance of the loop at this angle
    local index = angle / (2 * math.pi) * loop.size
    local lowerValue = loop[math.floor(index)]
    local upperValue = loop[math.ceil(index)]
    local remainder = index - math.floor(index)
    local radius = lowerValue + remainder * (upperValue - lowerValue)

    -- Determine the distance of the point from the center
    local distance = (deltaX^2 + deltaY^2)^(0.5)
    return distance - radius

end
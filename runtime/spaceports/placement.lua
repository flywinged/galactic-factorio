-- Used to handle the placement and removale of spaceports

script.on_event("reset-for-debugging", function(event)

    global.routes = {}
    global.spaceports = {}
    global.createdRoutes = 0
    global.createdSpaceports = 0

end)

script.on_event(defines.events.on_built_entity, function(event)

    -- First we handle the creation of new spaceport hubs
    local entity = event.created_entity
    log(entity.name)
    if entity.name:find("spaceport-hub", 1, true) then
        
        -- Initialize and update the spaceports
        if global.createdSpaceports == nil then
            global.createdSpaceports = 0
        end
        global.createdSpaceports = global.createdSpaceports + 1

        if global.spaceports == nil then
            global.spaceports = {}
        end


        -- Initialize and update the spaceport groups
        if global.createdRoutes == nil then
            global.createdRoutes = 0
        end
        global.createdRoutes = global.createdRoutes + 1

        if global.routes == nil then
            global.routes = {}
        end


        -- Add the actual groups to the global table accordingly
        global.spaceports[global.createdSpaceports] = {
            name = tostring(global.createdSpaceports),
            hubEntity = entity,
            inputContainers = {},
            outputContainers = {},
        }
        global.routes[global.createdRoutes] = {

            -- Gobal information about what exactly this route is
            name = tostring(global.createdRoutes),
            startingSpaceport = tostring(global.createdSpaceports),
            endingSpaceport = nil,

            -- Information about how this route is operating
            ships = {}, -- What ships are responsible for transporting items on this route
            maxRates = {} -- What is the maximum rate of items expected to be transported by this route. Given by the player

        }

        -- Ensure the entity has a name so that we can easily track it
        entity.backer_name = tostring(global.createdSpaceports)

        log(entity.backer_name)
    end

end)

local function handleSpaceportHubNameChange(spaceport, newName)

    -- Track the old name of the spaceport fo reference
    local oldName = spaceport.backer_name

    -- Ensure the new name is unique
    if global.spaceports[newName] ~= nil then
        return false
    end
    spaceport.backer_name = newName
    global.spaceports[oldName].name = newName

    -- Loop through the spaceports and the routes, changing everything that needs to change
    for routeID, route in pairs(global.routes) do
        
        if route.startingSpaceport == oldName then
            route.startingSpaceport = newName
        elseif route.endingSpaceport == oldName then
            route.endingSpaceport = newName
        end 

    end


    return true

end

local function handleSpaceportHubRemoval(entity)


    -- First remove from the spaceports table
    local spaceportID = tonumber(entity.backer_name)
    global.spaceports[spaceportID] = nil
    
    -- Then remove from all the groups
    for routeID, route in pairs(global.routes) do

        -- Check to see if the spaceport exists in this group
        if route.startingSpaceport == spaceportID then
            route.startingSpaceport = nil
        elseif route.endingSpaceport == spaceportID then
            route.endingSpaceport = nil
        end

        -- If the route no longer has a connection on either end, remove the route
        if route.startingSpaceport == nil and route.endingSpaceport == nil then
            route.spaceports[routeID] = nil
        end

        
    end
    

end

script.on_event(defines.events.on_player_mined_entity, function(event)

    handleSpaceportHubRemoval(event.entity)

end)

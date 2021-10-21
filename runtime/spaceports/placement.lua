-- Used to handle the placement and removale of spaceports

script.on_event("reset-for-debugging", function(event)

    global.spaceportConnections = {}
    global.spaceports = {}
    global.createdSpaceportConnections = 0
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
        if global.createdSpaceportConnections == nil then
            global.createdSpaceportConnections = 0
        end
        global.createdSpaceportConnections = global.createdSpaceportConnections + 1

        if global.spaceportConnections == nil then
            global.spaceportConnections = {}
        end


        -- Add the actual groups to the global table accordingly
        global.spaceports[global.createdSpaceports] = {name = tostring(global.createdSpaceports), entity = entity}
        global.spaceportConnections[global.createdSpaceportConnections] = {
            name = tostring(global.createdSpaceportConnections),
            spaceports = {[global.createdSpaceports] = true}
        }
        entity.backer_name = tostring(global.createdSpaceports)

        log(entity.backer_name)
    end

end)

local function handleSpaceportHubRemoval(entity)


    -- First remove fromthe spaceports table
    local spaceportID = tonumber(entity.backer_name)
    global.spaceports[spaceportID] = nil
    
    -- Then remove from all the groups
    for spaceportConnectionID, spaceportConnection in pairs(global.spaceportConnections) do

        -- Check to see if the spaceport exists in this group
        if spaceportConnection.spaceports[spaceportID] then
            spaceportConnection.spaceports[spaceportID] = nil

            -- If there are no more spaceports in this group, delete the group
            if #spaceportConnection == 0 then
                global.spaceportConnections[spaceportConnectionID] = nil
            end

        end

        
    end
    

end

script.on_event(defines.events.on_player_mined_entity, function(event)

    handleSpaceportHubRemoval(event.entity)

end)



script.on_event(defines.events.on_chunk_generated, function(event)

    local chunkPosition = event.position
    local area = event.area
    local surface = event.surface

    local x1 = area.left_top.x
    local y1 = area.left_top.y
    local x2 = area.right_bottom.x
    local y2 = area.right_bottom.y

    tiles = {}

    for x = x1, x2 do
        for y = y1, y2 do

            if (
                chunkPosition.x == 0 and chunkPosition.y == 0 or
                chunkPosition.x == 2 and chunkPosition.y == 0
            ) then
                table.insert( tiles, {name = "dirt-1", position = {x, y}})
            else
                table.insert( tiles, {name = "out-of-map", position = {x, y}})
            end
            
        end
    end

    surface.set_tiles(tiles)

end)


script.on_event("gf-configure-spaceport", function(event)

    local player = game.players[event.player_index]
    local selectedEntity = player.selected
    local gui = player.gui

    -- Determine if the menu is already open
    if gui.center.configureSpaceport ~= nil then
        gui.center.clear()
    elseif selectedEntity ~= nil then

        -- Don't open the configure menu if the selected entity is not a spaceport entity
        if selectedEntity.name:find("spaceport", 1, true) then

            -- Determine all the different logistics networks
            local options = {}
            for k, v in pairs(global.spaceportConnections) do
                table.insert(options, v.name)
            end

            gui.center.add({type="frame", direction="vertical", name="configureSpaceport"})
            gui.center.configureSpaceport.add({type="textfield"})
            gui.center.configureSpaceport.add({type="list-box", items=options})
        end

    end

end
)

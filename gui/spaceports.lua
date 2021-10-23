

script.on_event("gf-configure-spaceport", function(event)

    local player = game.players[event.player_index]
    local selectedEntity = player.selected
    local gui = player.gui

    -- Determine if the menu is already open
    -- If it is, close the menu
    if gui.center.configureSpaceport ~= nil then
        gui.center.clear()
    
    -- Otherwise, show the menu as long as their is a selected entity
    -- AND that entity is a kind of spaceport.
    elseif selectedEntity ~= nil and selectedEntity.name:find("spaceport", 1, true) then

        -- Menu for spaceport hubs specifically
        if selectedEntity.name:find("spaceport-hub", 1, true) then

            -- Determine all the different logistics networks
            local options = {}
            for k, v in pairs(global.spaceports) do
                table.insert(options, v.name)
            end

            gui.center.add({type="frame", direction="vertical", name="configureSpaceport"})
            gui.center.configureSpaceport.add({type="textfield"})
            gui.center.configureSpaceport.add({type="list-box", items=options})
        end

    end

end
)

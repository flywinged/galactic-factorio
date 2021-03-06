
require("runtime.teleport")
require("gui.spaceports")
require ("runtime.generation.generate")
require("runtime.spaceports.placement")

script.on_init(function()
    game.forces["player"].set_spawn_position({0, 0}, "nauvis")
end)

local function setStartingInventory(event)
    
    -- Grab the basic things we need from the player
    local player=game.players[event.player_index]
	local inventory=player.get_main_inventory()

    -- Situations where we don't actually want to do anything
	if(not inventory)then return end
    if (global.first == nil) then global.first = true else return end

    -- Clear the invntory before adding what we need to add to it.
    inventory.clear()

	-- inventory.insert{name="burner-mining-drill",count=4}
	-- inventory.insert{name="stone-furnace",count=2}

end

script.on_event(defines.events.on_cutscene_cancelled, setStartingInventory)
script.on_event(defines.events.on_player_created, setStartingInventory)
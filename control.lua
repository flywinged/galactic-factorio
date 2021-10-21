
require("runtime.teleport")
require("gui.spaceports")
require ("runtime.generation.generate")
require("runtime.spaceports.placement")

script.on_init(function()
    game.forces["player"].set_spawn_position({15, 15}, "nauvis")
end)

require("runtime.teleport")
require("gui.spaceports")
require ("runtime.generation.generate")
require("runtime.spaceports.placement")

script.on_init(function()
    game.forces["player"].set_spawn_position({0, 0}, "nauvis")
end)
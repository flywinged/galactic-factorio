script.on_event("gf-teleport", function(event)

    local player = game.players[event.player_index]
    if player.position.x > 60 then
        player.teleport({15, 15})
    else
        player.teleport({2*32 + 15, 15})
    end
end
)
local PLAYERS = require("players")

function events.entity_init()
    print(PLAYERS.racers)
    
end

function events.tick()
    for _, p in pairs(world.getPlayers()) do
        local name = p:getName()
        if PLAYERS.racers[name] and not p:isAlive() then
            local pos = p:getPos()
            print(name.." помер на "..pos.x, pos.y, pos.z)
        end
    end
end
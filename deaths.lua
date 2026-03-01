local PLAYERS = require("players")
local net = require("net")

local sended = PLAYERS.sended

local Deaths = {}

function Deaths.tick(plist)
    --*Death checker for delete player from list
    for _, p in pairs(plist) do
        local name = p:getName()

        if PLAYERS.racers[name] and not p:isAlive() and not sended.death[name] then
            local pos = p:getPos()
            net.send_death(name, pos)
        end
    end
end

return Deaths
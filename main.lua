local PLAYERS = require("players")
local deaths = require("deaths")
local anticheat = require("anticheat")
local check = require("check")
local action_wheel = require("action_wheel")
local net = require("net")

function events.entity_init()
    print(PLAYERS.racers)
end

function events.tick()
    local plist = world.getPlayers()
    deaths.tick(plist)
    anticheat.tick(plist)
end
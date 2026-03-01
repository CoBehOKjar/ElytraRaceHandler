local PLAYERS = require("players")

local sended = PLAYERS.sended

local Net = {}

function Net.send_death(name, pos)
    sended.death[name] = true
    for org, _ in pairs(PLAYERS.org) do
        host:sendChatCommand(string.format(
            "tell %s %s умер на %d, %d, %d",
            org, name, pos.x, pos.y, pos.z
        ))
    end
    print(string.format(
            "%s умер на %d, %d, %d",
            name, pos.x, pos.y, pos.z
        ))
end


function Net.send_cheat(rule, name)
    sended.cheat[rule] = sended.cheat[rule] or {}

    if sended.cheat[rule][name] then return end
    sended.cheat[rule][name] = true

    local msg = ""
    if rule == 1 then
        msg = string.format("%s с прочностью!", name)
    elseif rule == 2 then
        msg = string.format("%s с фурками >1 лвла!", name)
    elseif rule == 3 then
        msg = string.format("%s c тотемом!", name)
    else
        msg = string.format("%s: правила %d не существует, проверь код.", name, rule)
    end

    for org, _ in pairs(PLAYERS.org) do
        host:sendChatCommand(string.format(
            "tell %s %s",
            org, msg
        ))
    end
    print(msg)
end


function Net.send_info()

end


function Net.sync()
    for bot, _ in pairs(PLAYERS.bots) do
        host:sendChatCommand(string.format(
            "tell %s %s",
            bot, sended
        ))
    end
end

return Net
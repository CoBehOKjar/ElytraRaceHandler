local PLAYERS = require("players")
local discord = require("discord")

local sended = PLAYERS.sended

local Net = {}

local serializer = json.newBuilder():build()


function Net.send_death(name, pos)
    sended.death[name] = true
    for org, _ in pairs(PLAYERS.org) do
        host:sendChatCommand(string.format(
            "tell %s %s умер на %d, %d, %d",
            org, name, pos.x, pos.y, pos.z
        ))
    end
    local msg = string.format(
            "%s умер на %d, %d, %d",
            name, pos.x, pos.y, pos.z
        )

    print(msg)
    discord.send(msg)
    table.insert(sended.pending, {
        rule = 0,
        name = name
    })
    Net.sync()
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
    discord.send(msg)
    table.insert(sended.pending, {
        rule = rule,
        name = name
    })
    Net.sync()
end


function Net.send_info()

end


function Net.sync()
    
    if #sended.pending == 0 then return end

    local json = serializer:serialize(sended.pending)

    for bot, _ in pairs(PLAYERS.bots) do
        host:sendChatCommand(
            string.format("tell %s %s", bot, json)
        )
    end

    sended.pending = {}
end


function Net.listen(raw, text)
    local jsonStr
    local sender

    --? Pepeland DM
    if raw:find("✉✉✉") then
        sender = raw:match("^✉✉✉%s*%[([^%s]+)")

        if sender and PLAYERS.bots[sender] then
            return text
        end
        jsonStr = raw:match("(%b[])$")
    end

    --? Vanilla DM
    if not jsonStr then
        sender = raw:match("^&[%x]+o?([%w_]+)") or raw:match("^([%w_]+)")

        if sender and PLAYERS.bots[sender] then
            jsonStr = raw:match("whispers to you:%s*(%b[])$")
        end
    end

    if not jsonStr then
        return text
    end


    local data = serializer:deserialize(jsonStr)

    for _, entry in ipairs(data) do
        local name = entry.name
        local rule = tonumber(entry.rule)

        if not name or not rule then
            goto continue
        end

        if rule == 0 then
            sended.death[name] = true
            print("Получена смерть "..name)
        else
            sended.cheat[rule] = sended.cheat[rule] or {}
            sended.cheat[rule][name] = true
            print("Получено нарушение правила "..rule.." от "..name)
        end

        ::continue::
    end
end

return Net
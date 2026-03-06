local PLAYERS = require("players")
local discord = require("discord")

local sended = PLAYERS.sended

local Net = {}

local serializer = json.newBuilder():build()


local function getNextBot()
    local chain_length = #PLAYERS.bot_chain
    if chain_length == 0 then return nil end
    
    for i, name in ipairs(PLAYERS.bot_chain) do
        if name == ME then
            local nextIndex = (i % chain_length) + 1
            return PLAYERS.bot_chain[nextIndex]
        end
    end
    return nil
end


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

    local jsonStr = serializer:serialize(sended.pending)
    
    local nextBot = getNextBot()
    if nextBot then
        host:sendChatCommand(
            string.format("tell %s %s", nextBot, jsonStr)
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
        if sender then sender = sender:gsub("[^%w_]", "") end

        if sender and PLAYERS.bots[sender] or PLAYERS.org[sender] then
            return text
        end
        jsonStr = raw:match("(%b[])$")
    end

    --? Vanilla DM
    if not jsonStr then
        sender = raw:match("^&[%x]+o?([%w_]+)") or raw:match("^([%w_]+)")
        if sender then sender = sender:gsub("[^%w_]", "") end

        if sender and PLAYERS.bots[sender] or PLAYERS.org[sender] then
            jsonStr = raw:match("whispers to you:%s*(%b[])$")
        end
    end

    if not jsonStr then
        return text
    end


    local data = serializer:deserialize(jsonStr)
    local isNewData = false


    for _, entry in ipairs(data) do
        local name = entry.name
        local rule = tonumber(entry.rule)

        if not name or not rule then
            goto continue
        end

        if rule == -1 then
            if sended.death[name] then
                sended.death[name] = nil
                isNewData = true
            end
            for ruleID, playersTable in pairs(sended.cheat) do
                if playersTable[name] then
                    playersTable[name] = nil
                    isNewData = true
                end
            end
            if isNewData then
                print("Получен сброс игрока " .. name)
            end
        elseif rule == 0 then
            sended.death[name] = true
            print("Получена смерть "..name)
            isNewData = true
        else
            sended.cheat[rule] = sended.cheat[rule] or {}
            sended.cheat[rule][name] = true
            print("Получено нарушение правила "..rule.." от "..name)
            isNewData = true
        end

        ::continue::
    end

    if isNewData then
        local nextBot = getNextBot()
        if nextBot then
            host:sendChatCommand(string.format("tell %s %s", nextBot, jsonStr))
        end
    end
end

return Net
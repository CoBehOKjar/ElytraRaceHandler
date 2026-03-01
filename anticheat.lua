local PLAYERS = require("players")
local net = require("net")

local AntiCheat = {}

--*Check firework duration
local function checkFirework(item)
    if not item then return end
    if item:getID() ~= "minecraft:firework_rocket" then return end

    local tag = item:getTag()
    if not tag then return end

    local duration = tag["minecraft:fireworks"]["flight_duration"]

    if duration and duration > 1 then
        return true
    end
end


function AntiCheat.tick(plist)
    if world.getTime() % 20 ~= 0 then return end

    --*Check items every second
    for name, _ in pairs(PLAYERS.racers) do
        local p = plist[name]
        
        if p and p:isLoaded() then
            local chest = p:getItem(5)
            local main = p:getItem(1)
            local off = p:getItem(2)
            
            --?Check unbreaking on elytra
            if chest and chest.tag.Enchantments then                
                local unbreaking = chest.tag.Enchantments["minecraft:unbreaking"]

                if unbreaking then
                    net.send_cheat(1, name)
                end
            end

            --?Check mainhand
            if main and main:getID() == "minecraft:totem_of_undying" then
                net.send_cheat(3, name)
            end
            if main and checkFirework(main) then
                net.send_cheat(2, name)
            end

            --?Check offhand
            if off and off:getID() == "minecraft:totem_of_undying" then
                net.send_cheat(3, name)
            end
            if off and checkFirework(off) then
                net.send_cheat(2, name)
            end
        end
    end
end

return AntiCheat
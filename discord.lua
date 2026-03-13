local Discord = {}

local HOOK = "https://discord.com/api/webhooks/1477986461491003525/HChZh9I7J9CAhdHKguqAdMwG_1Sb2URLM6F1sIMPvtWYMN4FzKtn5UQBxAiuSZzRIVLy"
local BUFFER_CLOSE_TICKS = 10 * 20
local pendingBuffers = {}

function Discord.send(msg)
    local buffer = data:createBuffer()
    buffer:writeByteArray('{"content":"'..msg..'"}')
    buffer:setPosition(0)

    net.http:request(HOOK)
        :method("POST")
        :header("Content-Type", "application/json")
        :body(buffer)
        :send()

    table.insert(pendingBuffers, { buf = buffer, ticks = BUFFER_CLOSE_TICKS, closed = false })
end


function Discord.tick()
    for i = #pendingBuffers, 1, -1 do
        local entry = pendingBuffers[i]
        entry.ticks = entry.ticks - 1
        if entry.ticks <= 0 then
            if not entry.closed then
                local ok, err = pcall(function() entry.buf:close() end)
                if not ok then
                    print("WARN: Discord buffer close failed:", tostring(err))
                end
                entry.closed = true
            end
            table.remove(pendingBuffers, i)
        end
    end
end

return Discord
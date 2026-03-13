local Players = {}

Players.sended = {
    death = {},
    cheat = {},
    pending = {}
}

Players.org = {
    ["CoBeHok"] = true,
    ["rejektov"] = true,
    ["Ut0p1sT"] = true,
    ["Iv1nce_"] = true,
    ["Romul_Us"] = true,
    ["Poxyie"] = true,
}

Players.bot_chain = {
    "OtagHi",
    "hyperWOW",
    "URAyaderka",
    "BuyingYaderka",
    "otagSmile",
    "Anzorik",
    "Poxyie"
}

Players.bots = {}
for _, name in ipairs(Players.bot_chain) do
    Players.bots[name] = true
end

Players.racers = {    
    -- "Wheelchair" - оранжевый
    ["ShockerPlay"] = true,
    ["romaboom1337"] = true,
    
    -- "Унтес" - бирюзовый
    ["_6eremoTuk_"] = true,
    ["Vova13131313"] = true,

    -- "Бармены" - Фиолетовый
    ["Mr_Cheezer"] = true,
    ["PCheL_D"] = true,
    ["EvilJ_69"] = true,

    -- "Убойные лягушки 😎" - Зелёный
    ["_Max0n_"] = true,
    ["_Danran_"] = true,

    -- "Васильки" - Синие
    ["3acyxa"] = true,
    ["_Nos0k_"] = true,

    -- "ГорГород" - Чёрный
    ["Thaumi"] = true,
    ["DimondFlowuly"] = true,
    ["coldrc666"] = true,

    -- "Паралелепипеды" - Коричневый
    ["step_p"] = true,
    ["_kyter_"] = true,

    -- "kchao" - Голубые
    ["Lovashkalash"] = true,
    ["Vintaaage"] = true,

    -- "Японск" - Розовый
    ["YarilaFox"] = true,
    ["w1lkey"] = true,
    ["lacymacaroon570"] = true,

    -- "Щаас" - Жёлтый
    ["platon4ic135"] = true,
    ["MeernI1"] = true,
}

return Players
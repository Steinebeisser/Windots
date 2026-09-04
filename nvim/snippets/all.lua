---@diagnostic disable: undefined-global

return {
    s("gh", t("github.com/Steinebeisser")),
    s("now", f(function() return os.date("%d-%m-%Y %H:%M:%S") end)),
    s("ts", f(function() return { tostring(os.time()) } end)),
    s("date", f(function() return os.date("%d/%m/%Y") end)),
    s("wdate", f(function() return os.date("%Y-%m-%d") end)),
    s("rand", f(function() return { tostring(math.random(0, 1000)) } end)),
    s("year", f(function() return os.date("%Y") end)),
    s("time", f(function() return os.date("%H:%M:%S") end)),
    s("iso", f(function() return os.date("%Y-%m-%dT%H:%M:%SZ") end)),
    s("uuid", f(function()
        math.randomseed(os.time())
        local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub(template, '[xy]', function(c)
            local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', v)
        end)
    end)),
}

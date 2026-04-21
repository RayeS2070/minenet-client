local computer = require("computer")
local event = require("event")
local os = require("os")

local component = require("component")
local ME = component.me_interface


local timer = require("timer")
local net = require("networking")

local const = {
    kUrl = "http://93.84.96.228:8660",
    kInterruptedEvent = "interrupted"
}

local config = {
    exporting = {
        kItemsDuration = 600
    }
}

local function main()
    local endpoint = const.kUrl .. "/export"

    for item in ME.allItems() do
        local body = ("{Item: %s, size: %d},"):format(item.name, item.size)
        local response, err = net.http.Post(endpoint, body, nil, 1)
        local respbody = ""
        for chunk in response do
            respbody = respbody .. chunk
        end
        print(respbody)
    end

    local timer = timer.InfinityTimer:Make(0.5, function()
        print(computer.uptime())
    end)

    event.pull()
    while not event.pull(5, const.kInterruptedEvent) do end

    timer:Cancel()

    return 0
end

main()

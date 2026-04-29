local computer = require("computer")
local event = require("event")
local component = require("component")

local wdt = require("watchdog")

local ME = component.me_interface


local timer = require("timer")
local net = require("networking")

local const = {
    kMaxInt = 9223372036854775807,
    kUrl = "http://93.84.96.228:8660",
    kHealthHandle = "ping",
    event = {
        kInterruptedEvent = "interrupted"
    }
}

local config = {
    exporting = {
        kItemsDuration = 600
    }
}

local function main()
    local watchdog = wdt.Watchdog:Make(const.kUrl, const.kHealthHandle)

    -- local endpoint = const.kUrl .. "/export"

    -- for item in ME.allItems() do
    --     local body = ("{Item: %s, size: %d},"):format(item.name, item.size)
    --     local response = net.http.Post(endpoint, body, nil, 1)
    --     print(response)
    -- end

    local timer = timer.InfinityTimer:Make(0.5, function()
        print(computer.uptime())
    end)

    while not event.pull(5, const.event.kInterruptedEvent) do end

    timer:Cancel();
    watchdog:Cancel();

    return 0
end

main()

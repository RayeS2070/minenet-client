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

-- local url = "http://127.0.0.1:8080"

local function test_get(endpoint)
    local response, error = net.http.Get(endpoint, nil, 10)

    if response then
        for chunk in response do
            print(chunk)
        end
    else
        print(error)
    end
end

local function test_post(endpoint, body)
    local response, error = net.http.Post(endpoint, body, nil, 10)

    if response then
        for chunk in response do
            print(chunk)
        end
    else
        print(error)
    end
end

local function main()
    local endpoint = const.kUrl .. "/export"

    test_get(endpoint)
    test_post(endpoint, ("{time: %s}"):format(computer.uptime()))

    local timer = timer.InfinityTimer:Make(0.5, function()
        print(computer.uptime())
    end)

    event.pull()
    while not event.pull(5, const.kInterruptedEvent) do end

    timer:Cancel()

    return 0
end

main()

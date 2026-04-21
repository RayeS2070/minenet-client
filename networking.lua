local internet = require("internet")
local computer = require("computer")
local event = require("event")

local Module = { http = {} }

local function Request(url, body, headers, timeout)
    local handle, err = internet.request(url, body, headers)

    if not handle then
        return nil, ("request failed: %s"):format(err or "unknown error")
    end

    local start = computer.uptime()

    while true do
        local status, err = handle.finishConnect()

        if status then
            break
        end

        if status == nil then
            return nil, ("request failed: %s"):format(err or "unknown error")
        end

        if computer.uptime() >= start + timeout then
            handle.close()

            return nil, "request failed: connection timed out"
        end

        os.sleep(0.05)
    end

    return handle
end

function Module.http.Get(url, headers, timeout)
    return Request(url, nil, headers, timeout)
end

function Module.http.Post(url, body, headers, timeout)
    return Request(url, body or {}, headers, timeout)
end

return Module

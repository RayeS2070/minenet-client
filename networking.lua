local internet = require("internet")
local computer = require("computer")

local module = { http = {} }

local function request(url, body, headers, timeout)
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
            return nil, format "request failed: %s" { err or "unknown error" }
        end

        if computer.uptime() >= start + timeout then
            handle.close()

            return nil, "request failed: connection timed out"
        end

        os.sleep(0.05)
    end

    return handle
end

function module.http.get(url, headers, timeout)
    return request(url, nil, headers, timeout)
end

function module.http.post(url, body, headers, timeout)
    return request(url, body or {}, headers, timeout)
end

return module

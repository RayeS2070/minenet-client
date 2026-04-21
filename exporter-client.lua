local internet = require("internet")

local url = "http://93.84.96.228:8660/"

local function request(url, body, headers, timeout)
    local handle, err = inet.request(url, body, headers)

    if not handle then
        return nil, ("request failed: %s"):format(err or "unknown error")
    end

    local start = comp.uptime()

    while true do
        local status, err = handle.finishConnect()

        if status then
            break
        end

        if status == nil then
            return nil, ("request failed: %s"):format(err or "unknown error")
        end

        if comp.uptime() >= start + timeout then
            handle.close()

            return nil, "request failed: connection timed out"
        end

        os.sleep(0.05)
    end

    return handle
end

local function request_to_endpoint(endpoint, body, headers, timeout)

end

function main()

    local response, error = internet.request(url)

    if not response then
        print(("request failed: %s"):format(err or "unknown error"))
        return nil
    end

    for chunk in response do
        print(chunk)
    end

    return 0
end

main()

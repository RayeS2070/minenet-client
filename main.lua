local net = require("networking")

local url = "http://93.84.96.228:8660"

-- local url = "http://127.0.0.1:8080"

local function main()

    local endpoint = url .. "/export"

    local response, error = net.http.get(endpoint, nil, 10)

    if not response then
        print(("request failed: %s"):format(error or "unknown error"))
        return nil
    end

    for chunk in response do
        print(chunk)
    end

    return 0
end

main()

local internet = require("internet")
local computer = require("computer")
local event = require("event")
local os = require("os")

local Module = { http = {} }

local function Request(url, body, headers, mehtod)
    local handle = internet.request(url, body, headers, mehtod)

    local result = ""

    for chunk in handle do result = result .. chunk end

    return result
end

function Module.http.Get(url, headers)
    return pcall(Request, url, nil, headers, "GET")
end

function Module.http.Post(url, body, headers)
    return pcall(Request, url, body or {}, headers, "POST")
end

return Module

local timer = require("timer");
local net = require("networking")

local Module = {
    Watchdog = {}
}

function Module.Watchdog:Make(url, handle)
    local obj = {}
    obj.endpoint_ = url .. "/" .. handle

    obj.timer_ = timer.InfinityTimer:Make(10, function()
        local response_body, err = net.http.Get(obj.endpoint_, nil)

        -- TODO: handle err
        if response_body then
            print(("Server health is Ok, URL: %s, response: %s"):format(obj.endpoint_, response_body))
        else
            print(("Watchdog failed with error: %s"):format(err))
        end
    end)

    function obj:Cancel()
        obj.timer_:Cancel()
    end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end

return Module;

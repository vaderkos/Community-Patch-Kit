local _lua_os_date = os.date

local Date = CPK.Module()
CPK.Date = Date

--- Gets date in ISO format. If time is not specified gets current date in ISO format.
--- @param time? number | nil
--- @return string
function Date.ToIsoString(time)
    local iso = _lua_os_date("!%Y-%m-%dT%H:%M:%S", time) --[[@as string]]

    return iso
end
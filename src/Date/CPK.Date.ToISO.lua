local _lua_os_date = os.date

--- Returns the date in ISO 8601 format.
--- If no timestamp is provided, the current date and time in ISO format is returned.
--- 
--- ```lua
--- -- Example
--- local GetISODate = CPK.Date.ToISO
--- GetISODate(0) -- '1970-01-01T00:00:00'
--- GetISODate(1704067200) -- '2024-01-01T00:00:00'
--- GetISODate() -- Current Date in iso format
--- ```
--- 
--- @param time? integer
--- @return string
--- @nodiscard
local function DateToISO(time)
	local iso = _lua_os_date("!%Y-%m-%dT%H:%M:%S", time) --[[@as string]]

	return iso
end

CPK.Date.ToISO = DateToISO

local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Returns the minimum value from the specified table.
--- 
--- ```lua
--- -- Example
--- local Min = CPK.Stats.Min
--- print(Min({ 1, 2, 3, 4, 5 }))   -- Output: 1
--- print(Min({ -10, -20, 0, 10 })) -- Output: -20
--- ```
--- 
--- @param tbl number[]
--- @return number
--- @nodiscard
local function Min(tbl)
	AssertIsTable(tbl)

	local min = tbl[1]

	for _, val in _lua_next, tbl, nil do
		if val < min then
			min = val
		end
	end

	return min
end

CPK.Stats.Min = Min

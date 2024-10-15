local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Returns the maximum value from the specified table.
--- 
--- ```lua
--- -- Example
--- local Max = CPK.Stats.Max
--- print(Max({ 1, 2, 3, 4, 5 })) -- Output: 5
--- print(Max({ -10, -20, 0, 10 })) -- Output: 10
--- ```
--- 
--- @param tbl number[]
--- @return number
--- @nodiscard
local function Max(tbl)
	AssertIsTable(tbl)

	local max = tbl[1]

	for _, val in _lua_next, tbl, nil do
		if val > max then
			max = val
		end
	end

	return max
end

CPK.Stats.Max = Max

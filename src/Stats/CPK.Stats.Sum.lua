local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Returns the sum of the specified table values.
--- 
--- ```lua
--- -- Example
--- local Sum = CPK.Stats.Sum
--- print(Sum({ 1, 2, 3, 4, 5 })) -- Output: 15
--- print(Sum({ -1, 0, 1 }))     -- Output: 0
--- ```
--- 
--- @param tbl number[]
--- @return number
--- @nodiscard
local function Sum(tbl)
	AssertIsTable(tbl)

	local sum = 0

	for _, val in _lua_next, tbl, nil do
		sum = sum + val
	end

	return sum
end

CPK.Stats.Sum = Sum

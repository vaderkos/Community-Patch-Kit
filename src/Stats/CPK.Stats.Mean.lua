local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Returns the mean (average) of the specified table values.
--- 
--- ```lua
--- -- Example
--- local Mean = CPK.Stats.Mean
--- print(Mean({ 1, 2, 3, 4, 5 })) -- Output: 3
--- print(Mean({ 10, 20, 30 }))    -- Output: 20
--- ```
--- 
--- @param tbl number[]
--- @return number
--- @nodiscard
local function Mean(tbl)
	AssertIsTable(tbl)

	local sum = 0
	local cnt = 0

	for _, val in _lua_next, tbl, nil do
		cnt = cnt + 1
		sum = sum + val
	end

	return (sum / cnt)
end

CPK.Stats.Mean = Mean

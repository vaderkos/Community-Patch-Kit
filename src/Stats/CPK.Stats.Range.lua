local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable
local AssertIsNumber = CPK.Assert.IsNumber

--- Returns the difference between the maximum and minimum values (statistical range) in the specified table.
--- 
--- ```lua
--- -- Example
--- local Range = CPK.Stats.Range
--- print(Range({ 1, 2, 3, 4, 5 })) -- Output: 4
--- print(Range({ -10, 0, 10 }))    -- Output: 20
--- ```
--- 
--- @param tbl number[]
--- @return number
--- @nodiscard
local function Range(tbl)
	AssertIsTable(tbl)

	local min = tbl[1]
	local max = min

	AssertIsNumber(min, 'Table might be empty.')

	for _, val in _lua_next, tbl, nil do
		if val > max then
			max = val
		end

		if val < min then
			min = val
		end
	end

	return (max - min)
end

CPK.Stats.Range = Range

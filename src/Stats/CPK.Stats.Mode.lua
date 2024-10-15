local _lua_table_insert = table.insert
local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Calculates the mode(s) of a dataset and the maximum frequency.
--- The mode is the value or values that appear most frequently in the list. 
--- If multiple values share the highest frequency, all of them are returned.
--- The function also returns the maximum frequency of these mode(s).
---
--- ```lua
--- -- Example with numeric data
--- local Mode = CPK.Stats.Mode
--- local modes, freq = Mode({ 1, 2, 2, 3, 3, 4 })
--- print(table.concat(modes, ", "))  -- Output: 2, 3
--- print(freq)                       -- Output: 2
--- ```
---
--- @param tbl any[] # A table of values to calculate the mode from.
--- @return any[] # A table of the mode(s). If multiple values have the highest frequency, all are included.
--- @return number # The maximum frequency of the mode(s).
--- @nodiscard
local function Mode(tbl)
	AssertIsTable(tbl)

	--- @type table<number, number>
	local freq = {}
	--- @type table<number, number>
	local mode = {}
	--- @type number
	local maxFreq = 0

	for _, val in _lua_next, tbl, nil do
		local cnt = (freq[val] or 0) + 1
		freq[val] = cnt

		if cnt >= maxFreq then
			maxFreq = cnt
		end
	end

	for val, cnt in _lua_next, freq, nil do
			if cnt == maxFreq then
				_lua_table_insert(mode, val)
			end
	end

	return mode, maxFreq
end

CPK.Stats.Mode = Mode

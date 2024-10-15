local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Calculates the frequency of each value in a table.
--- This function returns a table where the keys are the unique values from the input table
--- and the values are the counts of each key's occurrences.
---
--- ```lua
--- -- Example
--- local Freq = CPK.Stats.Freq
--- local freqTable = Freq({ 1, 2, 2, 3, 3, 3 })
--- for key, count in pairs(freqTable) do
---     print(key, count)  -- Output: 1 1, 2 2, 3 3
--- end
--- ```
---
--- @param tbl any[] # A table of values to calculate the frequencies from.
--- @return table<any, number> # A table where the keys are unique values from the input table and the values are their counts.
--- @nodiscard
local function Freq(tbl)
	AssertIsTable(tbl)

	local freq = {}

	for _, val in _lua_next, tbl, nil do
		freq[val] = (freq[val] or 0) + 1
	end

	return freq
end

CPK.Stats.Freq = Freq

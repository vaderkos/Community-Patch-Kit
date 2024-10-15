local _lua_math_ceil = math.ceil
local _lua_table_sort = table.sort

local IsEven = CPK.Number.IsEven
local AssertIsTable = CPK.Assert.IsTable
local ShallowCopyTable = CPK.Table.ShallowCopy

--- Calculates the median of a list of numbers.
--- The list is first sorted, and then the median is computed.
--- If the list has an even number of elements, the median is the average of the two middle numbers.
--- If the list has an odd number of elements, the median is the middle number.
---
--- ```lua
--- -- Example
--- local Median = CPK.Stats.Median
--- print(Median({ 1, 3, 2 })) -- Output: 2
--- print(Median({ 1, 5, 3, 2 })) -- Output: 2.5
--- print(Median({ 10, 2, 38, 23, 38, 23, 21 })) -- Output: 23
--- ```
---
--- @param tbl number[] A table of numbers to calculate the median from.
--- @return number The median value of the input numbers.
--- @nodiscard
local function Median(tbl)
	AssertIsTable(tbl)

	tbl = ShallowCopyTable(tbl)

	_lua_table_sort(tbl)

	local len = #tbl
	local mid = len / 2

	if IsEven(len) then
		local a = tbl[mid]
		local b = tbl[mid + 1]

		return (a + b) / 2
	end

	return tbl[_lua_math_ceil(mid)]
end

CPK.Stats.Median = Median

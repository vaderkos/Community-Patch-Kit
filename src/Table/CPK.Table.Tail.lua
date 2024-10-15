local _lua_table_insert = table.insert

local AssertIsTable = CPK.Assert.IsTable

--- Returns a new table containing all elements of the input table except the first one.
---
--- ```lua
--- -- Example
--- local Tail = CPK.Table.Tail
---
--- local tbl1 = { "apple", "banana", "cherry", "date" }
--- local tail1 = Tail(tbl1)
--- print(table.concat(tail1, ", "))  -- Output: banana, cherry, date
---
--- local tbl2 = { 1, 2, 3, 4, 5 }
--- local tail2 = Tail(tbl2)
--- print(table.concat(tail2, ", "))  -- Output: 2, 3, 4, 5
---
--- local tbl3 = { "first" }
--- local tail3 = Tail(tbl3)
--- print(table.concat(tail3, ", "))  -- Output: (empty output)
--- ```
--- 
--- @param tbl any[]  # The input table from which the first element will be removed.
--- @return any[]  # A new table containing all elements except the first one.
--- @nodiscard
local function Tail(tbl)
	AssertIsTable(tbl)

	local res = {}
	local len = #tbl

	if len < 2 then
		return res
	end

	for i = 2, len do
		_lua_table_insert(res, tbl[i])
	end

	return res
end

CPK.Table.Tail = Tail

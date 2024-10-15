local _lua_table_insert = table.insert

local AssertIsTable = CPK.Assert.IsTable


--- Returns a new table containing all elements of the input table except the last one.
---
--- ```lua
--- -- Example
--- local Init = CPK.Table.Init
---
--- local tbl1 = { "apple", "banana", "cherry", "date" }
--- local init1 = Init(tbl1)
--- print(table.concat(init1, ", "))  -- Output: apple, banana, cherry
---
--- local tbl2 = { 1, 2, 3, 4, 5 }
--- local init2 = Init(tbl2)
--- print(table.concat(init2, ", "))  -- Output: 1, 2, 3, 4
---
--- local tbl3 = { "first" }
--- local init3 = Init(tbl3)
--- print(table.concat(init3, ", "))  -- Output: (empty output)
--- ```
--- 
--- @param tbl any[]  # The input table from which the last element will be removed.
--- @return any[]  # A new table containing all elements except the last one.
--- @nodiscard
local function Init(tbl)
	AssertIsTable(tbl)

	local res = {}
	local len = #tbl

	if len < 2 then
		return res
	end

	for i = 1, len - 1 do
		_lua_table_insert(tbl[i])
	end

	return res
end

CPK.Table.Init = Init

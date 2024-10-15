local _lua_table_insert = table.insert

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsNumber = CPK.Assert.IsNumber

--- Returns a new table containing elements from the specified table 
--- after dropping a given number of elements from the start.
---
--- ```lua
--- -- Example
--- local Drop = CPK.Table.Drop
---
--- local tbl1 = { "apple", "banana", "cherry", "date" }
--- local Drop2 = Drop(2)
--- local droppedA = Drop2(tbl1)
--- print(table.concat(droppedA, ", "))  -- Output: cherry, date
---
--- local tbl2 = { 1, 2, 3, 4, 5 }
--- local droppedB = Drop(3, tbl2)
--- print(table.concat(droppedB, ", "))  -- Output: 4, 5
--- ```
--- 
--- @overload fun(num: integer, tbl: any[]): any[]
--- @overload fun(num: integer): (fun(tbl: any[]): any[])
--- @nodiscard
local Drop = Curry(2, function(num, tbl)
	AssertIsNumber(num)
	AssertIsTable(tbl)

	local res = {}
	local len = #tbl

	for i = num, len do
		_lua_table_insert(res, tbl[i])
	end

	return res
end)

CPK.Table.Drop = Drop

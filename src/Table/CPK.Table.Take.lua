local _lua_table_insert = table.insert

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsNumber = CPK.Assert.IsNumber

--- Creates a new table by taking the first `num` elements from the specified table.
--- If `num` is greater than the length of the table, the entire table is returned.
---
--- ```lua
--- local Take = CPK.Table.Take
---
--- local tbl1 = { 1, 2, 3, 4, 5 }
--- local Take3 = Take(3)
--- local taken1 = Take3(tbl1)
--- print(table.concat(taken1, ", "))  -- Output: 1, 2, 3
---
--- local tbl2 = { "a", "b", "c", "d" }
--- local taken2 = Take(2, tbl2)
--- print(table.concat(taken2, ", "))  -- Output: a, b
---
--- local tbl3 = { 10, 20, 30, 40 }
--- local taken3 = Take(5, tbl3)
--- print(table.concat(taken3, ", "))  -- Output: 10, 20, 30, 40
--- ```
--- 
--- @overload fun(num: integer, tbl: any[]): any[]
--- @overload fun(num: integer): (fun(tbl: any[]): any[])
--- @nodiscard
local Take = Curry(2, function(num, tbl)
	AssertIsNumber(num)
	AssertIsTable(tbl)

	local res = {}
	local len = #tbl

	if num > len then
		num = len
	end

	for i = 1, num do
		_lua_table_insert(res, tbl[i])
	end

	return res
end)

CPK.Table.Take = Take

local _lua_error = error

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsNumber = CPK.Assert.IsNumber

--- Retrieves the value at the specified index from the given table. Supports negative indexing,
--- where -1 refers to the last element, -2 refers to the second-to-last element, and so on. If the index is 
--- out of bounds or the table is empty, an error will be thrown.
---
--- ```lua
--- -- Example
--- local At = CPK.Table.At
---
--- local tbl1 = { "apple", "banana", "cherry" }
--- local First = At(1)
--- print(First(tbl1))    -- Output: apple
--- print(At(-1, tbl1))   -- Output: cherry
--- print(At(-2, tbl1))   -- Output: banana
---
--- local tbl2 = {}
--- print(At(1, tbl2))    -- Error: Cannot retrieve element at index 1 from an empty table
---
--- local tbl3 = { 1, 2, 3 }
--- print(At(4, tbl3))    -- Error: Cannot retrieve element at index 4 that is out of bounds for table with 3 elements
--- ```
--- 
--- @overload fun(idx: integer, tbl: any[]): any 
--- @overload fun(idx: integer): (fun(tbl: any[]): any)
--- @nodiscard
local At = Curry(2, function(idx, tbl)
	AssertIsNumber(idx)
	AssertIsTable(tbl)

	local len = #tbl

	if len == 0 then
		_lua_error('Cannot retrieve element at index ' .. idx .. ' from an empty table')
	end

	if (idx < -len or idx > len) then
		_lua_error(
			'Cannot retrieve element at index ' .. idx
			.. ' that is out of bounds for table with '
			.. len .. ' elements'
		)
	end

	if idx < 0 then
		idx = len + idx + 1
	end

	return tbl[idx]
end)

CPK.Table.At = At

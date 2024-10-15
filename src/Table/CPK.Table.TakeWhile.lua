local _lua_table_insert = table.insert

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable


--- Creates a new table by taking elements from the specified table while the `predicate` returns `true`.
--- The function stops adding elements to the new table as soon as the `predicate` returns `false`.
---
--- ```lua
--- -- Example 
--- local TakeWhile = CPK.Table.TakeWhile
---
--- local tbl1 = { 1, 2, 3, 4, 5, 1, 2, 3 }
--- local TakeWhileLessThan4 = TakeWhile(function(val) return val < 4 end)
--- local taken1 = TakeWhileLessThan4(tbl1)
--- print(table.concat(taken1, ", "))  -- Output: 1, 2, 3
---
--- local tbl2 = { "apple", "banana", "cherry", "date" }
--- local taken2 = TakeWhile(function(val) return val ~= "cherry" end, tbl2)
--- print(table.concat(taken2, ", "))  -- Output: apple, banana
--- ```
--- 
--- @overload fun(predicate: CPK.Table.Predicate, tbl: any[]): any[]
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: any[]): any[])
--- @nodiscard
local TakeWhile = Curry(2, function(predicate, tbl)
	AssertIsCallable(predicate)
	AssertIsTable(tbl)

	local res = {}
	local len = #tbl

	for i = 1, len do
		local val = tbl[i]

		if not predicate(val, i) then
			return res
		end

		_lua_table_insert(res, tbl[i])
	end

	return res
end)

CPK.Table.TakeWhile = TakeWhile

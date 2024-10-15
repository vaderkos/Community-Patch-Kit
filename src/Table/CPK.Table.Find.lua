local _lua_next = next

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- Finds the first element in the specified table that satisfies the given predicate.
--- The `predicate` function is applied to each key-value pair in the table.
--- When a match is found (i.e., `predicate` returns `true`), 
--- the function immediately returns the value and key of the matched element.
--- If no element satisfies the predicate, it returns `nil, nil`.
---
--- This function is curried and can be partially applied.
---
--- ```lua
--- -- Example 1: Find the first value greater than 2
--- local Find = CPK.Table.Find
--- local tbl1 = { a = 1, b = 2, c = 3 }
--- local val1, key1 = Find(function(val) return val > 2 end, tbl)
--- print(val1, key1) -- 3, 'c'
---
--- -- Example 2: Using partial application
--- local findGreaterThanTwo = Find(function(val) return val > 2 end)
--- local tbl2 = { 1, 2, 0 }
--- local val2, key2 = findGreaterThanTwo(tbl2)
--- print(val2, key2) -- nil, nil
--- ```
--- 
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): any, any
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): any, any)
--- @nodiscard
local Find = Curry(2, function(predicate, tbl)
	AssertIsCallable(predicate)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		local res = predicate(val, key)

		if res then
			return val, key
		end
	end

	return nil, nil
end)

CPK.Table.Find = Find

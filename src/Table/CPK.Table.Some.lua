local _lua_next = next

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- Checks if at least one element in the specified table satisfies the given predicate function.
--- The `predicate` function is applied to each key-value pair in the table. If any call to `predicate`
--- returns `true`, the function immediately returns `true`. If no element satisfies the predicate, it returns `false`.
---
--- This function is curried and can be partially applied.
---
--- ```lua
--- -- Example 1: Check if any value in the table is greater than 2
--- local Some = CPK.Table.Some
--- local tbl = { a = 1, b = 2, c = 3 }
--- local result = Some(function(val) return val > 2 end, tbl)
--- print(result) -- true
---
--- -- Example 2: Using partial application
--- local hasGreaterThanTwo = Some(function(val) return val > 2 end)
--- local myTbl = { 1, 2, 0 }
--- print(hasGreaterThanTwo(myTbl)) -- false
--- ```
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): boolean
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): boolean)
--- @nodiscard
local Some = Curry(2, function(predicate, tbl)
	AssertIsCallable(predicate)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		local res = predicate(val, key)

		if res then
			return true
		end
	end

	return false
end)

CPK.Table.Some = Some

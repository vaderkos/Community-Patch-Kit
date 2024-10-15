local _lua_next = next

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- Checks if all elements in the specified table satisfy the given predicate function.
--- The `predicate` function is applied to each key-value pair in the table. If any call to `predicate`
--- returns `false`, the function immediately returns `false`. Otherwise, it returns `true` after checking all elements.
---
--- This function is curried and can be partially applied.
---
--- ```lua
--- -- Example 1: Check if all values in the table are positive numbers
--- local Every = CPK.Table.Every
--- local tbl1 = { a = 1, b = 2, c = 3 }
--- local res1 = Every(function(val) return val > 0 end, tbl)
--- print(res1) -- true
---
--- -- Example 2: Using partial application
--- local isEveryPositive = Every(function(val) return val > 0 end)
--- local tbl2 = { 10, 20, -5 }
--- print(isEveryPositive(tbl2)) -- false
--- ```
--- 
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): boolean
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): boolean)
--- @nodiscard
local Every = Curry(2, function(predicate, tbl)
	AssertIsCallable(predicate)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		local result = predicate(val, key)

		if not result then
			return false
		end
	end

	return true
end)

CPK.Table.Every = Every

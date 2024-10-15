local _lua_next = next

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- Counts the number of elements in the table that satisfy the specified predicate.
--- The `predicate` function is applied to each key-value pair in the table. For each element where the predicate returns `true`, 
--- the count is incremented. The final count is returned.
---
--- This function is curried and can be partially applied.
---
--- ```lua
--- -- Example 1: Count how many values are greater than 1
--- local Count = CPK.Table.Count
--- local tbl1 = { a = 1, b = 2, c = 3 }
--- local count1 = Count(function(val) return val > 1 end, tbl1)
--- print(count1) -- Output: 2
---
--- -- Example 2: Using partial application
--- local countGreaterThanOne = Count(function(val) return val > 1 end)
--- local tbl2 = { 2, 2, 4, 0 }
--- local count2 = countGreaterThanOne(tbl2)
--- print(count2) -- Output: 3
--- ```
--- 
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): integer
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): integer)
--- @nodiscard
local Count = Curry(2, function(predicate, tbl)
	AssertIsCallable(predicate)
	AssertIsTable(tbl)

	local res = 0

	for key, val in _lua_next, tbl, nil do
		local check = predicate(val, key)

		if check then
			res = res + 1
		end
	end

	return res
end)

CPK.Table.Count = Count

local _lua_next = next

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- Reduces a table to a single value by applying a `reducer` function to each key-value pair.
--- The `reducer` function is called with the accumulator, the current value, and the key. The result of each call
--- is used as the accumulator for the next iteration. The function returns the final accumulated result.
--- 
--- The function is curried, allowing it to be partially applied with one or two arguments.
---
--- ```lua
--- -- Example 1: Summing all values in a table
--- local Fold = CPK.Table.Fold
--- local tbl = { a = 1, b = 2, c = 3 }
--- local sum = Fold(function(acc, val) return acc + val end, 0, tbl)
--- print(sum) -- Output: 6
---
--- -- Example 2: Concatenating all keys and values
--- local concat = Fold(function(acc, val, key) return acc .. key .. val end, "", tbl)
--- print(concat) -- Output: "a1b2c3"
--- ```
---
--- @nodiscard
--- @overload fun(reducer: CPK.Table.Reducer, acc: any, tbl: table): any
--- @overload fun(reducer: CPK.Table.Reducer, acc: any): (fun(tbl: table): any)
--- @overload fun(reducer: CPK.Table.Reducer): (fun(acc: any, tbl: table): any)
--- @overload fun(reducer: CPK.Table.Reducer): (fun(acc: any): (fun(tbl: table): any))
--- @param reducer fun(acc: any, val: any, key: any): any # A function to apply on each value-key pair.
--- @param acc any # The initial accumulator value.
--- @param tbl table # The table to iterate over.
--- @return any # The final accumulated result after applying the reducer function.
local Fold = Curry(3, function(reducer, acc, tbl)
	AssertIsCallable(reducer)
	AssertIsTable(tbl)

	local res = acc

	for key, val in _lua_next, tbl, nil do
		res = reducer(res, val, key)
	end

	return res
end)

CPK.Table.Fold = Fold

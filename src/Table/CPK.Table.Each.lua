local _lua_next = next

local AssertIsCallable = CPK.Assert.IsCallable
local AssertIsTable = CPK.Assert.IsTable
local Curry = CPK.FP.Curry

--- Applies a function (consumer) to each element in the specified table.
--- The function `consumer` is called for each key-value pair in the table, passing the value and key as arguments.
--- This function is curried and requires two arguments: `consumer` and `tbl`. It returns the original table.
---
--- ```lua
--- -- Example 1
--- local Each = CPK.Table.Each
--- local tbl = { a = 1, b = 2, c = 3 }
--- Each(function(val, key) print(key, val) end, tbl)
--- -- Output:
--- -- a 1
--- -- b 2
--- -- c 3
--- 
--- -- Example 2
--- local PrintEach = Each(function(val, key)
---   print("Key: " .. key .. " Value: " .. val)
--- end)
---
--- local myTbl = { 10, 20, a = 30 }
--- PrintEach(myTbl)
--- -- Output:
--- -- Key: 1 Value: 10
--- -- Key: 2 Value: 20
--- -- Key: a Value: 30
--- ```
--- @overload fun(CPK.Table.Consumer, tbl: table): table
--- @overload fun(CPK.Table.Consumer): (fun(tbl: table): table)
--- @nodiscard
local Each = Curry(2, function(consumer, tbl)
	AssertIsCallable(consumer)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		consumer(val, key)
	end

	return tbl
end)

CPK.Table.Each = Each

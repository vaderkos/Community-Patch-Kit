local _lua_table_insert = table.insert

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- @private
--- @package
local function _Find(predicate, tbl)
	for i = 1, #tbl do
		local val = tbl[i]

		if not predicate(val, i) then
			return val, i
		end
	end

	return nil, nil
end

--- Creates a new table by dropping elements from the start of the specified table
--- while the given predicate function returns true.
--- The predicate function is called for each element, and as soon as it returns false,
--- the process stops and the remaining elements are returned.
---
--- ```lua
--- -- Example
--- local DropWhile = CPK.Table.DropWhile
---
--- local tbl1 = { 1, 2, 3, 4, 5 }
--- local DropWhileLessThan3 = DropWhile(function(val) return val < 3 end)
--- local droppedA = DropWhileLessThan3(tbl1)
--- print(table.concat(droppedA, ", "))  -- Output: 3, 4, 5
---
--- local tbl2 = { 10, 20, 30, 40 }
--- local droppedB = DropWhile(function(val) return val < 25 end, tbl3)
--- print(table.concat(droppedB, ", "))  -- Output: 30, 40
--- ```
--- 
--- @overload fun(predicate: CPK.Table.Predicate, tbl: any[]): any[]
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: any[]): any[])
--- @nodiscard
local DropWhile = Curry(2, function(predicate, tbl)
	AssertIsCallable(predicate)
	AssertIsTable(tbl)

	local len = #tbl
	local res = {}
	local val, from = _Find(predicate, tbl)

	if val == nil then
		return res
	end

	_lua_table_insert(res, val)

	for i = from + 1, len do
		_lua_table_insert(res, tbl[i])
	end

	return res
end)

CPK.Table.DropWhile = DropWhile

local _lua_table_insert = table.insert

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- @private
--- @package
local function _Find(predicate, tbl)
	for i = 1, #tbl do
		local val = tbl[i]

		if predicate(val, i) then
			return val, i
		end
	end

	return nil, nil
end

--- Creates a new table by dropping elements from the start of the specified table 
--- until the given predicate function returns true.
--- The predicate function is called for each element, and as soon as it returns true,
--- the process stops and the remaining elements are returned.
---
--- ```lua
--- local DropUntil = CPK.Table.DropUntil
---
--- local tbl1 = { 1, 2, 3, 4, 5 }
--- local DropUntilGreaterThan3 = DropUntil(function(val) return val > 3 end)
--- local droppedA = DropUntilGreaterThan3(tbl1)
--- print(table.concat(droppedA, ", "))  -- Output: 4, 5
---
--- local tbl2 = { "a", "b", "c", "d" }
--- local droppedB = DropUntil(function(val) return val == "c" end, tbl2)
--- print(table.concat(droppedB, ", "))  -- Output: c, d
--- ```
--- 
--- @overload fun(predicate: CPK.Table.Predicate, tbl: any[]): any[]
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: any[]): any[])
--- @nodiscard
local DropUntil = Curry(2, function(predicate, tbl)
	AssertIsCallable(predicate)
	AssertIsTable(tbl)

	local res = {}
	local len = #tbl

	local val, from = _Find(predicate, tbl)

	if val == nil then
		return res
	end

	for i = from, len do
		_lua_table_insert(res, tbl[i])
	end

	return res
end)

CPK.Table.DropUntil = DropUntil

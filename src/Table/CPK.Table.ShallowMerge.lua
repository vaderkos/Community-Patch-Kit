local _lua_next = next
local _lua_tostring = tostring

local IsEmptyTable = CPK.Table.IsEmpty
local AssertError = CPK.Assert.Error
local AssertIsTable = CPK.Assert.IsTable
local AssertIsNumber = CPK.Assert.IsNumber

--- Merges multiple tables into a new table by shallow copying key-value pairs from left to right.
--- If multiple tables contain the same key, the value from the rightmost table is used.
---
--- ```lua
--- -- Example
--- local ShallowMerge = CPK.Table.ShallowMerge
---
--- local tbl1 = { a = 1, b = 2 }
--- local tbl2 = { b = 10, c = 20 }
--- local tbl3 = { a = 100, d = 30 }
---
--- local merged = ShallowMerge(tbl1, tbl2, tbl3)
--- -- merged: { a = 100, b = 10, c = 20, d = 30 }
--- ```
--- 
--- @param ... table
--- @return table
--- @nodiscard
local function ShallowMerge(...)
	--- @type table[]
	local args = { ... }

	if IsEmptyTable(args) then
		AssertError('no arguments', 'tables', 'Cannot shallow merge tables because no tables specified', 3)
	end

	--- @type table
	local res = {}

	for pos, tbl in _lua_next, args, nil do
		AssertIsNumber(pos, 'Non-number argument keys are not supported. Position: ' .. _lua_tostring(pos))
		AssertIsTable(tbl, 'Non-table argument values are not supported. Position: ' .. _lua_tostring(pos))

		for key, val in _lua_next, tbl, nil do
			res[key] = val
		end
	end

	return res
end

CPK.Table.ShallowMerge = ShallowMerge

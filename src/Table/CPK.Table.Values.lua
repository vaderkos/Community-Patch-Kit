local _lua_next = next
local _lua_table_insert = table.insert

local AssertIsTable = CPK.Assert.IsTable

--- Creates a table containing all the values of the specified table.
--- This function returns an array (table with numeric indices) that contains the values from the given table.
---
--- ```lua
--- -- Example
--- local Values = CPK.Table.Values
--- local tbl = { a = 1, b = 2, c = 3 }
--- local values = Values(tbl)
--- for i, value in ipairs(values) do
---   print(value)  -- Output: 1, 2, 3
--- end
--- ```
---
--- @generic Val  -- The type of the table values.
--- @param tbl { [any]: Val } # The table from which to extract values.
--- @return Val[] # A new array containing all the values of the specified table.
--- @nodiscard
local function Values(tbl)
	AssertIsTable(tbl)

	local res = {}

	for _, val in _lua_next, tbl, nil do
		_lua_table_insert(res, val)
	end

	return res
end

CPK.Table.Values = Values

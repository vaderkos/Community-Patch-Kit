local _lua_table_insert = table.insert

local AssertIsTable = CPK.Assert.Is.Table

--- Reverses the order of elements in the specified table.
--- This function returns a new array (table with numeric indices) 
--- containing the elements of the input table in reverse order.
---
--- ```lua
--- -- Example
--- local Reverse = CPK.Table.Reverse
--- local original = { 1, 2, 3, 4, 5 }
--- local reversed = Reverse(original)
--- for i, value in ipairs(reversed) do
---     print(value)  -- Output: 5, 4, 3, 2, 1
--- end
--- ```
---
--- @param tbl any[] # The table to reverse.
--- @return any[] # A new array containing the elements of the specified table in reverse order.
--- @nodiscard
local function Reverse(tbl)
	AssertIsTable(tbl)

	local res = {}

	for i = 1, #tbl do
		_lua_table_insert(res, tbl[i], 1)
	end

	return res
end

CPK.Table.Reverse = Reverse

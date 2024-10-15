local _lua_next = next
local _lua_table_insert = table.insert

local AssertIsTable = CPK.Assert.IsTable

--- Creates a table containing all the keys of the specified table.
--- This function returns an array (table with numeric indices) that contains the keys from the given table.
---
--- ```lua
--- -- Example
--- local Keys = CPK.Table.Keys
--- local tbl = { a = 1, b = 2, c = 3 }
--- local keys = Keys(tbl)
--- for i, key in ipairs(keys) do
---   print(key)  -- Output: 'a', 'b', 'c'
--- end
--- ```
---
--- @generic Key  -- The type of the table keys.
--- @param tbl table<Key, any> # The table from which to extract keys.
--- @return Key[] # A new array containing all the keys of the specified table.
--- @nodiscard
local function Keys(tbl)
	AssertIsTable(tbl)

	local res = {}

	for key, _ in _lua_next, tbl, nil do
		_lua_table_insert(res, key)
	end

	return res
end

CPK.Table.Keys = Keys

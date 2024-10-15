local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Checks if the specified table is empty (i.e., it has no key-value pairs).
--- This function returns `true` if the table is empty (`{}`), otherwise `false`.
---
--- ```lua
--- -- Example
--- local IsEmpty = Table.IsEmpty
--- print(IsEmpty({}))         -- Output: true
--- print(IsEmpty({ a = 1 }))  -- Output: false
--- ```
---
--- @param tbl table # The table to check if it is empty.
--- @return boolean # `true` if the table is empty, `false` otherwise.
--- @nodiscard
local function IsEmpty(tbl)
	AssertIsTable(tbl)

	-- Iterate over the table to check if it has any elements
	for _, _ in _lua_next, tbl, nil do
		return false
	end

	return true
end

CPK.Table.IsEmpty = IsEmpty

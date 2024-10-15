local _lua_next = next
local _lua_setmetatable = setmetatable
local _lua_getmetatable = getmetatable

local AssertIsTable = CPK.Assert.IsTable
local AssertIsBoolean = CPK.Assert.IsBoolean

--- Creates a shallow copy of the specified table without copying its metatable.
--- The new table will have the same keys and values as the original table, but will not share the same metatable
--- unless the `withMeta` parameter is set to `true`.
---
--- ```lua
--- -- Example
--- local ShallowCopy = CPK.Table.ShallowCopy
--- local orig = { a = 1, b = 2 }
--- local copy = ShallowCopy(orig)
--- local same = orig == copy -- false
--- print(copy.a) -- 1
--- print(copy.b) -- 2
--- ```
---
--- @generic T : any[] # The type of the table elements.
--- @param tbl T # The table to copy.
--- @param withMeta? boolean # If set to `true`, the copied table should share the same metatable as the original table.
--- @return T # A new table that is a shallow copy of the input table.
--- @nodiscard
local function ShallowCopy(tbl, withMeta)
	AssertIsTable(tbl)

	if withMeta ~= nil then
		AssertIsBoolean(withMeta)
	end

	local copy = {}

	for key, val in _lua_next, tbl, nil do
		copy[key] = val
	end

	if withMeta then
		_lua_setmetatable(copy, _lua_getmetatable(tbl))
	end

	return copy
end

CPK.Table.ShallowCopy = ShallowCopy

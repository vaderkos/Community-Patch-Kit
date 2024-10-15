local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable

--- Flips keys and values in the specified table.
--- This function returns a new table where the keys and values are flipped.
---
--- ```lua
--- -- Example
--- local Flip = CPK.Table.Flip
--- local original = { a = 1, b = 2, c = 3 }
--- local flipped = Flip(original)
--- print(flipped[1])  -- Output: 'a'
--- print(flipped[2])  -- Output: 'b'
--- print(flipped[3])  -- Output: 'c'
--- ```
---
--- @param tbl table<any, any> # The table to flip keys and values.
--- @return table<any, any> # A new table where the keys and values are flipped.
--- @nodiscard
local function Flip(tbl)
	AssertIsTable(tbl)

	local res = {}

	for key, val in _lua_next, tbl, nil do
		res[val] = key
	end

	return res
end

CPK.Table.Flip = Flip

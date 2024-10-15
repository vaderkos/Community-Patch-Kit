--- Retrieves the last element of the specified table.
--- This function returns the value at the last index of the table.
---
--- ```lua
--- local Last = CPK.Table.Last
--- local tbl = { 10, 20, 30 }
--- local last = Last(tbl)
--- print(last) -- Output: 30
--- ```
---
--- @generic T
--- @param tbl T[] # The table to retrieve the last element from.
--- @return T | nil # The last element of the table, or `nil` if the table is empty.
--- @nodiscard
local function Last(tbl)
	return tbl[#tbl]
end

CPK.Table.Last = Last

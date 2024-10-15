--- Retrieves the first element (head) of the specified table.
--- This function returns the value at the first index of the table.
---
--- ```lua
--- local Head = CPK.Table.Head
--- local tbl = { 10, 20, 30 }
--- local first = Head(tbl)
--- print(first) -- Output: 10
--- ```
---
--- @generic T
--- @param tbl T[] # The table to retrieve the first element from.
--- @return T | nil # The first element of the table, or `nil` if the table is empty.
--- @nodiscard
local function Head(tbl)
	return tbl[1]
end

CPK.Table.Head = Head


CPK.Table.Head = Head

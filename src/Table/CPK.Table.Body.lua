local _lua_table_insert = table.insert

local AssertIsTable = CPK.Assert.IsTable

--- Returns a new table containing all elements of the input table except the first and last ones.
---
--- ```lua
--- local Body = CPK.Table.Body
---
--- local tbl1 = { "apple", "banana", "cherry", "date" }
--- local body1 = Body(tbl1)
--- print(table.concat(body1, ", "))  -- Output: banana, cherry
---
--- local tbl2 = { 1, 2, 3, 4, 5 }
--- local body2 = Body(tbl2)
--- print(table.concat(body2, ", "))  -- Output: 2, 3, 4
---
--- local tbl3 = { "first", "second" }
--- local body3 = Body(tbl3)
--- print(table.concat(body3, ", "))  -- Output: (empty output)
--- ```
--- 
--- @param tbl any[]  # The input table from which the first and last elements will be removed.
--- @return any[]  # A new table containing all elements except the first and last ones.
--- @nodiscard
local function Body(tbl)
	AssertIsTable(tbl)

	local res = {}
	local len = #tbl

	if len < 3 then
		return res
	end

	for i = 2, len - 1 do
		_lua_table_insert(res, tbl[i])
	end

	return res
end

CPK.Table.Body = Body

local _lua_table_insert = table.insert

local IsTable = CPK.Type.IsTable
local AssertIsTable = CPK.Assert.IsTable
local AssertIsNumber = CPK.Assert.IsNumber

--- Creates a new table containing elements from the specified table within the range `[from, upto]`.
--- If the `upto` parameter is not provided, it slices until the end of the table.
--- 
--- ```lua
--- -- Example
--- local Slice = CPK.Table.Slice
--- local function PrintTable(tbl) print(table.concat(tbl, ", ")) end 
--- local tbl1 = { "apple", "banana", "cherry", "date", "fig", "grape", "pumpkin" }
--- PrintTable(Slice(2, 4, tbl1))  -- Output: banana, cherry, date
--- PrintTable(Slice(3, tbl1)) -- Output: cherry, date, fig, grape, pumpkin
--- PrintTable(Slice(-3, tbl1)) -- Output: fig, grape, pumpkin
--- PrintTable(Slice(2, -3, tbl1)) -- Output: banana, cherry, date, fig
--- ```
--- 
--- @overload fun(from: integer, tbl: any[]): any[]
--- @overload fun(from: integer, upto: integer, tbl: any[]): any[]
local function Slice(from, upto, tbl)
	AssertIsNumber(from)

	if IsTable(tbl) then
		AssertIsNumber(upto)

		if upto < 0 then
			upto = #tbl + upto + 1
		end
	else
		AssertIsTable(upto)
		tbl = upto
		upto = #tbl

		if from < 0 then
			from = #tbl + from + 1
		end
	end

	local res = {}

	for i = from, upto do
		_lua_table_insert(res, tbl[i])
	end

	return res
end

CPK.Table.Slice = Slice

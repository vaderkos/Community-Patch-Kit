local _lua_table_concat = table.concat

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable

--- @overload fun(sep: string, tbl: table): string
--- @overload fun(sep: string): (fun(tbl: table): string)
local Join = Curry(2, function(sep, tbl)
	AssertIsTable(tbl)

	return _lua_table_concat(tbl, sep)
end)

CPK.Table.Join = Join
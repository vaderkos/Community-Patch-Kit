local Curry = CPK.FP.Curry
local Map = CPK.Table.Map
local Prop = CPK.Table.Prop

--- Extracts the values of a specific key from each element in the table.
--- This function returns a new table where each value is the result of retrieving the specified key from each element in the original table.
---
--- ```lua
--- local Pluck = CPK.Table.Pluck
--- local tbl = {
---   { name = "Alice", age = 25 },
---   { name = "Bob", age = 30 },
---   { name = "Charlie", age = 35 }
--- }
--- local names = Pluck("name", tbl)
--- -- names: { "Alice", "Bob", "Charlie" }
--- ```
---
--- @overload fun(mapper: CPK.Table.Mapper, tbl: any[]): any[]
--- @overload fun(mapper: CPK.Table.Mapper): (fun(tbl: any[]): any[])
--- @nodiscard
local Pluck = Curry(2, function(key, tbl)
	return Map(Prop(key), tbl)
end)

CPK.Table.Pluck = Pluck

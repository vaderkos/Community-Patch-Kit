local _lua_next = next

local Curry = CPK.FP.Curry
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- Transforms a table by applying a mapping function to each value-key pair.
--- The `mapper` function is called for each value-key pair in the table, passing the value and key as arguments.
--- The result of the `mapper` function can return a new value and an optional new key.
--- If a new key is not provided, the original key will be used.
--- If returned value is nil then element is ommitted.
---
--- ```lua
--- -- Example 1
--- local Map = CPK.Table.Map
--- local DoubleEach = Map(function(val) return val * 2 end)
--- local tbl1 = { a = 1, b = 2, c = 3 }
--- local res1 = DoubleEach(tbl1)
--- -- res1: { a = 2, b = 4, c = 6 }
---
--- -- Example 2: Changing both values and keys
--- local res2 = Map(function(val, key) return val * 2, key .. "_new" end, tbl1)
--- -- res2: { a_new = 2, b_new = 4, c_new = 6 }
--- 
--- -- Example 3: Removing values or keys
--- local res3 = Map(function(val)
---		if val > 1 then
--- 		return nil
--- 	else
---			return val
--- 	end
--- end, tbl1)
--- -- res3: { a = 1 }
--- ```
--- @overload fun(mapper: CPK.Table.Mapper, tbl: table): table
--- @overload fun(mapper: CPK.Table.Mapper): (fun(tbl: table): table)
--- @nodiscard
local Map = Curry(2, function(mapper, tbl)
	AssertIsCallable(mapper)
	AssertIsTable(tbl)

	local res = {}

	for oldKey, oldVal in _lua_next, tbl, nil do
		local newVal, newKey = mapper(oldVal, oldKey)

		res[newKey or oldKey] = newVal
	end

	return res
end)

CPK.Table.Map = Map

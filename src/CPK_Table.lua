local _lua_next = next
local _lua_tostring = tostring
local _lua_table_insert = table.insert

local Curry = CPK.Fp.Curry

local Pack = CPK.Vararg.Pack

local IsTable = CPK.Is.Table

local ThrowAssertError = CPK.Assert.Throw

local AssertIsTable = CPK.Assert.Is.Table
local AssertIsNumber = CPK.Assert.Is.Number
local AssertIsNotNil = CPK.Assert.Is.Not.Nil
local AssertIsFunction = CPK.Assert.Is.Function


local Table = CPK.Module()
CPK.Table = Table

--- Special enum used to control flow of the table operations
--- @enum CPK.Table.Flow
local Flow = {
	--- Similar to continue in loops
	Skip = {},
	--- Similar to break in loops
	Stop = {},
}
Table.Flow = Flow

--- @alias CPK.Table.Mapper<Val, Key, Res> fun(val: Val, key: Key): Res | CPK.Table.Flow
--- @alias CPK.Table.Reducer<Val, Key, Res> fun(acc: Res, val: Val, key: Key): Res | CPK.Table.Flow
--- @alias CPK.Table.Consumer<Val, Key> fun(val: Val, key: Key): any | CPK.Table.Flow
--- @alias CPK.Table.Predicate<Val, Key> fun(val: Val, key: Key): boolean | CPK.Table.Flow

local SKIP = Flow.Skip
local STOP = Flow.Stop

--- Creates a table of keys of specified table
--- @generic Key
--- @param tbl { [Key]: any }
--- @return Key[]
--- @nodiscard
function Table.Keys(tbl)
	AssertIsTable(tbl)

	local res = {}

	for key, _ in _lua_next, tbl, nil do
		_lua_table_insert(res, key)
	end

	return res
end

--- Creates a table of values of specified table
--- @generic Val
--- @param tbl { [any]: Val }
--- @return Val[]
--- @nodiscard
function Table.Vals(tbl)
	AssertIsTable(tbl)

	local res = {}

	for _, val in _lua_next, tbl, nil do
		_lua_table_insert(res, val)
	end

	return res
end

--- Checks if specified table is empty. Literally `{}`
--- @param tbl table
--- @return boolean
--- @nodiscard
function Table.IsEmpty(tbl)
	AssertIsTable(tbl)

	for _, _ in _lua_next, tbl, nil do
		return false
	end

	return true
end

--- Creates new table with elements in reverse order from specified table
--- @param tbl any[]
--- @return any[]
--- @nodiscard
function Table.Reverse(tbl)
	AssertIsTable(tbl)

	local res = {}

	for i = 1, #tbl do
		_lua_table_insert(res, tbl[i], 1)
	end

	return res
end

--- Creates shallow copy of the specified table without copying metatable
--- @generic T : table
--- @param tbl T
--- @return T
--- @nodiscard
function Table.ShallowCopy(tbl)
	AssertIsTable(tbl)

	local copy = {}

	for key, val in _lua_next, tbl, nil do
		copy[key] = val
	end

	return copy
end

--- Creates a table with shallow copied key-value pairs from left to right of specified arguments
--- ```lua
--- -- Example
--- local ShallowMergeTables = CPK.Table.ShallowMerge
--- local a = { a = 1 }
--- local b = { b = 2 }
--- local c = { c = 3, a = 999}
--- local result = ShallowMergeTables(a, b, c) -- { a = 999, b = 2, c = 3 }
--- ```
--- @param ... table
--- @return table
--- @nodiscard
function Table.ShallowMerge(...)
	--- @type table[]
	local args = { ... }
	local res = {}

	if Table.IsEmpty(args) then
		ThrowAssertError('empty table', 'table of tables', 'Cannot shallow merge tables because no tables specified')
	end

	for pos, tbl in _lua_next, args, nil do
		AssertIsNumber(pos, 'Non-number argument keys are not supported. Position: ' .. _lua_tostring(pos))
		AssertIsTable(tbl, 'Non-table argument values are not supported. Position: ' .. pos)

		for key, val in _lua_next, tbl, nil do
			res[key] = val
		end
	end

	return res
end

--- TODO
--- @nodiscard
--- @overload fun(consumer: CPK.Table.Consumer, tbl: table): nil
--- @overload fun(consumer: CPK.Table.Consumer): (fun(tbl: table): nil)
Table.Each = Curry(2, function(consumer, tbl)
	AssertIsFunction(consumer)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		local flw = consumer(val, key)

		if flw == STOP then
			return nil
		end
	end

	return nil
end)

--- TODO
--- @nodiscard
--- @overload fun(mapper: CPK.Table.Mapper, tbl: table): any[]
--- @overload fun(mapper: CPK.Table.Mapper): (fun(tbl: table): any[])
Table.Map = Curry(2, function(mapper, tbl)
	AssertIsFunction(mapper)
	AssertIsTable(tbl)

	local res = {}

	for oldKey, oldVal in _lua_next, tbl, nil do
		local newVal, newKey = mapper(oldVal, oldKey)

		if newVal == STOP then
			return res
		end

		if newVal ~= SKIP then
			res[newKey or oldKey] = newVal
		end
	end

	return res
end)

--- @nodiscard
--- @overload fun(reducer: CPK.Table.Reducer, acc: any, tbl: table): any
--- @overload fun(reducer: CPK.Table.Reducer, acc: any): (fun(tbl: table): any)
--- @overload fun(reducer: CPK.Table.Reducer): (fun(acc: any, tbl: table): any)
--- @overload fun(reducer: CPK.Table.Reducer): (fun(acc: any): (fun(tbl: table): any))
Table.Fold = Curry(3, function(reducer, acc, tbl)
	AssertIsFunction(reducer)
	AssertIsTable(tbl)

	local res = acc

	for key, val in _lua_next, tbl, nil do
		local flw = reducer(res, val, key)

		if flw == STOP then
			return res
		end

		if flw ~= SKIP then
			res = flw
		end
	end

	return res
end)

--- @nodiscard
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): boolean
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): boolean)
Table.Every = Curry(2, function(predicate, tbl)
	AssertIsFunction(predicate)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		local flw = predicate(val, key)

		if flw == STOP then
			return false
		end

		if flw ~= SKIP then
			if not flw then
				return false
			end
		end
	end

	return true
end)

--- @nodiscard
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): boolean
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): boolean)
Table.Some = Curry(2, function(predicate, tbl)
	AssertIsFunction(predicate)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		local flw = predicate(val, key)

		if flw == STOP then
			return false
		end

		if flw ~= SKIP then
			if flw then
				return true
			end
		end
	end

	return false
end)

--- @nodiscard
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): any, any
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): any, any)
Table.Find = Curry(2, function(predicate, tbl)
	AssertIsFunction(predicate)
	AssertIsTable(tbl)

	for key, val in _lua_next, tbl, nil do
		local flw = predicate(val, key)

		if flw == STOP then
			return nil, nil
		end

		if flw ~= SKIP then
			if flw then
				return val, key
			end
		end
	end

	return nil, nil
end)

--- @nodiscard
--- @overload fun(predicate: CPK.Table.Predicate, tbl: table): int
--- @overload fun(predicate: CPK.Table.Predicate): (fun(tbl: table): int)
Table.Count = Curry(2, function(predicate, tbl)
	AssertIsFunction(predicate)
	AssertIsTable(tbl)

	local res = 0

	for key, val in _lua_next, tbl, nil do
		local flw = predicate(val, key)

		if flw == STOP then
			return res
		end

		if flw ~= SKIP then
			if flw then
				res = res + 1
			end
		end
	end

	return res
end)

--- Creates new table with elements from specified table within [from, upto]
--- @overload fun(from: int): (fun(upto?: int, tbl: any[]): any[])
--- @overload fun(from: int, upto)
function Table.Slice(from, upto, tbl)
	AssertIsNumber(from)

	if IsTable(tbl) then
		AssertIsNumber(from)
		AssertIsNumber(upto)
	else
		tbl = upto
		AssertIsTable(tbl)
		upto = #tbl
	end

	local res = {}

	for i = from, upto do
		_lua_table_insert(res, tbl[i])
	end

	return res
end

--- @overload fun(idx: int, tbl: any[]): any
--- @overload fun(idx: int): (fun(tbl: any[]): any)
Table.At = Curry(2, function(idx, tbl)
	AssertIsNumber(idx)
	AssertIsTable(tbl)

	local len = #tbl

	if len == 0 then
		return nil
	end

	while idx > len do
		idx = idx - len
	end

	while idx < 1 do
		idx = idx + len
	end

	return tbl[idx]
end)

--- Gets last element from specified table
--- @nodiscard
Table.Last = Table.At(0)

--- Gets first element from specified table
--- @nodiscard
Table.Head = Table.At(1)

--- Creates new table with elements from specified table omitting first element
--- @nodiscard
--- @param tbl any[]
--- @return any[]
function Table.Tail(tbl)
	return Table.Slice(tbl, 2)
end

--- Creates new table with elements from specified table omitting first and last elements
--- @nodiscard
--- @param tbl any
--- @return any[]
function Table.Init(tbl)
	return Table.Slice(tbl, 1, #tbl - 1)
end

--- Creates new table with elements from specified table omitting last element
--- @nodiscard
--- @param tbl any[]
--- @return any[]
function Table.Body(tbl)
	AssertIsTable(tbl)

	local res = {}

	for i = 2, #tbl - 1 do
		_lua_table_insert(res, tbl[i])
	end

	return res
end

--- Gets specified property from specified table
--- @nodiscard
--- @overload fun(prop: any, tbl: any[]): any
--- @overload fun(prop: any): fun(tbl: any[]): any
Table.Prop = Curry(2, function(prop, tbl)
	return tbl[prop]
end)

--- Creates new table where each element is property of element of specified table
--- @nodiscard
--- @overload fun(prop: any, tbl: any[]): any[]
--- @overload fun(prop: any): fun(tbl: any[]): any
Table.Pluck = Curry(2, function(prop, tbl)
	return Table.Map(Table.Prop(prop), tbl)
end)

Table.Drop = Curry(2, function(num, tbl)
	return Table.Slice()
end)

Table.Take = Curry(2, function(num, tbl)

end)

print('aaaa', #(Table.Init({'a'})))

-- local mock = { 'a', 'b', 'c', 'd', 'e', 'f' }

-- local each = Table.Each(function() end)

-- local res1, cnt1 = Table.Each(function() end, mock)
-- local res2, cnt2 = each(mock)





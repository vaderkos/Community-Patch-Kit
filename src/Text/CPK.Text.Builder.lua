local _lua_tostring = tostring
local _lua_setmetatable = setmetatable
local _lua_table_insert = table.insert
local _lua_table_concat = table.concat
local _lua_string_format = string.format

local Localize = CPK.Text.Localize
local IsNumber = CPK.Type.IsNumber
local ShallowCopy = CPK.Table.ShallowCopy
local IsEmptyTable = CPK.Table.IsEmpty
local AssertIsString = CPK.Assert.IsString

local Builder = {}

CPK.Text.Builder = Builder

--- @class CPK.Text.Builder
--- @field _table string[]
Builder.__index = {}

--- Creates new text builder. 
--- Use it for building complex strings instead of concatenation within loops 
--- as it produces a lot of intermideate garbage strings which leads to slow execution.
function Builder.new()
	--- @type CPK.Text.Builder
	local this = { _table = {} }

	return _lua_setmetatable(this, Builder)
end

--- Clears internal table
function Builder.__index:Clear()
	self._table = nil
	self._table = {}
	return self
end

--- Checks if builder is empty
function Builder.__index:IsEmpty()
	return IsEmptyTable(self._table)
end

--- Appends specified text
--- @param text string | number
function Builder.__index:Append(text)
	if IsNumber(text) then
		text = _lua_tostring(text)
	end

	AssertIsString(text)

	_lua_table_insert(self._table, text)

	return self
end

--- Prepends specified text
--- @param text string | number
function Builder.__index:Prepend(text)
	if IsNumber(text) then
		text = _lua_tostring(text)
	end

	AssertIsString(text)

	_lua_table_insert(self._table, 1, text)

	return self
end

--- Localizes specified text key and then appends localization result.
--- @param textKey string
--- @param ... any
function Builder.__index:AppendLocalize(textKey, ...)
	AssertIsString(textKey)

	_lua_table_insert(self._table, Localize(textKey, ... ))

	return self
end

--- Localizes specified text key and then prepends localization result.
--- @param textKey string
--- @param ... any
function Builder.__index:PrependLocalize(textKey, ...)
	AssertIsString(textKey)

	_lua_table_insert(self._table, 1, Localize(textKey, ... ))

	return self
end

--- Formats specified string and then append formatted result
--- @param textPattern string
--- @param ... any
function Builder.__index:AppendFormat(textPattern, ...)
	AssertIsString(textPattern)

	_lua_table_insert(self._table, _lua_string_format(textPattern, ...))

	return self
end

--- Formats specified string and then prepends formatted result
--- @param textPattern string
--- @param ... any
function Builder.__index:PrependFormat(textPattern, ...)
	AssertIsString(textPattern)

	_lua_table_insert(self._table, 1, _lua_string_format(textPattern, ...))

	return self
end

--- Joins all fragments from builder into final string using specified separator.
--- If separator is not specified 
--- 
--- ```lua
--- -- Example
--- local TextBuilder = CPK.Text.Builder
--- local builder = TextBuilder.new()
--- builder:Append("apple")
--- builder:Append("banana")
--- builder:Prepend("grape")
--- print(builder:Join(", ")) -- Output: grape, apple, banana
--- print(builder:Join()) -- Output: grapeapplebanana
--- 
--- ```
--- @param separator? string
function Builder.__index:Join(separator)
	return _lua_table_concat(self._table, separator)
end

--- Creates new copy of builder
function Builder.__index:Copy()
	local builder = Builder.new()

	builder._table = ShallowCopy(self._table)

	return builder
end




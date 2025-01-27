local _lua_type = type
local _lua_next = next
local _lua_tostring = tostring

local _lua_string_rep = string.rep

local _lua_table_concat = table.concat
local _lua_table_insert = table.insert

local _lua_getmetatable = getmetatable
local _lua_setmetatable = setmetatable

local Escape = CPK.String.Escape
local IsTable = CPK.Type.IsTable
local IsNumber = CPK.Type.IsNumber
local IsFunction = CPK.Type.IsFunction
local AssertIsString = CPK.Assert.IsString

local Inspector = {}
CPK.Debug.Inspector = Inspector

--- @class CPK.Debug.Inspector
Inspector.__index = {}
--- @protected
--- @type number
Inspector.__index._count = 0
--- @protected
--- @type table
Inspector.__index._cache = {}
--- @protected
--- @type string
Inspector.__index._space = ''
--- @type string
--- @protected
Inspector.__index._delim = ''
--- @type string
--- @protected
Inspector.__index._indent = ''

--- Creates new inspector instance
--- @param indent? string | number
--- @return CPK.Debug.Inspector
function Inspector.new(indent)
	local this = {
		_count = 0,
		_cache = {},
		_space = '',
		_delim = '',
		_indent = '',
	}

	if indent ~= nil then
		if IsNumber(indent) then
			indent = _lua_string_rep(' ', indent --[[@as number]])
		end

		AssertIsString(indent, 'Indent must be string or number')

		this._space = ' '
		this._delim = '\n'
		this._indent = indent --[[@as string]]
	end

	return _lua_setmetatable(this, Inspector)
end


--- Inspectes specified value. Lvl determines indentation if indent is specified.
--- @param val any
--- @return string
function Inspector.__index:Inspect(val)
	local result = self:_Inspect(val, 0)
	self:_Clear()
	return result
end

--- Inspectes specified value. Lvl determines indentation if indent is specified.
--- @package
--- @param val any
--- @param lvl number
--- @return string
function Inspector.__index:_Inspect(val, lvl)
	local type = _lua_type(val)

	if type == 'nil' then
		return 'nil'
	end

	if type == 'string' then
		return '"' .. Escape(val --[[@as string]]) .. '"'
	end

	if type == 'table' then
		return self:_FormatTable(val --[[@as table]], lvl or 0)
	end

	if type == 'number' or type == 'boolean' then
		return _lua_tostring(val)
	end

	return self:_FormatOther(val --[[@as thread | function | userdata]])
end

--- Clears internal cache table.
--- @protected
--- @return CPK.Debug.Inspector
function Inspector.__index:_Clear()
	self._count = 0
	self._cache = {}

	return self
end

--- Formats ref.
--- @protected
--- @param ref string
--- @param recursive boolean
--- @return string
function Inspector.__index:_FormatRef(ref, recursive)
	local s = self._space

	return '{' .. s .. '--[[' .. s .. (recursive and '*' or '') .. ref .. s .. ']]'  .. s .. '}'
end

--- @protected
--- @param oth function | userdata | thread 
--- @return string
function Inspector.__index:_FormatOther(oth)
	local ref = self._cache[oth]
	local recursive = true

	if ref == nil then
		ref = self:_Persist(oth)
		recursive = false
	end

	return self:_FormatRef(ref, recursive)
end

--- Creates and caches ref string from specified val, and returns ref string.
--- @protected
--- @param val table | thread | userdata | function
--- @return string
function Inspector.__index:_Persist(val)
	--- @type string
	local ref

	if not IsTable(val) then
		ref = _lua_tostring(val)
		self._cache[val] = ref

		return ref
	end

	local meta = _lua_getmetatable(val)

	if IsTable(meta) and IsFunction((meta --[[@as table]]).__tostring) then
		local count = self._count + 1
		self._count = count

		ref = _lua_type(val) .. ': unknown_' .. _lua_tostring(count)
	else
		ref = _lua_tostring(val)
	end

	self._cache[val] = ref

	return ref
end

--- Formats table.
--- @package
--- @private
function Inspector.__index:_FormatTable(tbl, lvl)
	local ref = self._cache[tbl]

	if ref ~= nil then
		return self:_FormatRef(ref, true)
	end

	ref = self:_Persist(tbl)

	local lines = {}
	local inlvl = lvl + 1
	local space = self._space
	local indent = _lua_string_rep(self._indent, inlvl)

	for inKey, inVal in _lua_next, tbl, nil do
		-- Order of calls is important!
		local outVal = self:_Inspect(inVal, inlvl)
		local outKey = self:_Inspect(inKey, inlvl)

		_lua_table_insert(lines, '[' .. outKey .. ']' .. space .. '=' .. space .. outVal)
	end

	if #lines > 0 then
		local delim = self._delim

		local result = '{' .. space .. '--[[' .. space .. ref .. ']]'
			.. delim .. indent .. _lua_table_concat(lines, ',' .. delim .. indent)
			.. delim .. _lua_string_rep(self._indent, lvl) .. '}'

		return result
	end

	return self:_FormatRef(ref, false)
end

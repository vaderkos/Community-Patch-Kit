local _lua_type = type
local _lua_tostring = tostring

local _lua_setmetatable = setmetatable

local _lua_table_insert = table.insert
local _lua_table_concat = table.concat

local IsString = CPK.Is.String
local IsNumber = CPK.Is.Number

local Localize = CPK.Text.Localize
local IsEmptyTable = CPK.Table.IsEmpty
local ThrowAssertError = CPK.Assert.Throw

local TextBuilder = CPK.Module()
CPK.TextBuilder = TextBuilder

--- @class CPK.TextBuilder
TextBuilder.__index = {}

function TextBuilder.new()
    --- @type CPK.TextBuilder
    local this = { _table = {} }

    return _lua_setmetatable(this, TextBuilder)
end

--- Clears internal Text Builder table
function TextBuilder.__index:Clear()
    self._table = {}
    return self
end

--- Checks if Text Builder is empty
--- @nodiscard
--- @return boolean
function TextBuilder.__index:IsEmpty()
    return IsEmptyTable(self._table)
end

--- Appends specified text to internal Text Builder table.
--- Does nothing if specified text is empty string or nil
--- @param text string | number
function TextBuilder.__index:Append(text)
    if text == nil or text == '' then
        -- TODO Log warning

        return self
    end

    if IsNumber(text) then
        text = _lua_tostring(text)
    end

    if not IsString(text) then
        ThrowAssertError(_lua_type(text), 'string or number')
    end

    _lua_table_insert(self._table, text)

    return self
end

--- Prepends specified text to internal Text Builder table.
--- Does nothing if specified text is empty string or nil
--- @param text? string | number
function TextBuilder.__index:Prepend(text)
    if text == nil or text == '' then
        -- TODO Log warning

        return self
    end

    if IsNumber(text) then
        text = _lua_tostring(text)
    end

    if not IsString(text) then
        ThrowAssertError(_lua_type(text), 'string or number')
    end

    _lua_table_insert(self._table, 1, text)

    return self
end

--- Localizes specified Text Key and appends result to Text Builder
--- @see CPK.TextBuilder.Append
--- @see CPK.TextBuilder.Prepend
--- @param textKey string | number
--- @param ... any
--- @return CPK.TextBuilder
function TextBuilder.__index:AppendLocalized(textKey, ...)
    return self:Append(Localize(textKey, ...))
end

--- Localizes specified Text Key and prepends result to Text Builder
--- @see CPK.TextBuilder.Append
--- @see CPK.TextBuilder.Prepend
--- @param textKey string | number
--- @param ... any
--- @return CPK.TextBuilder
function TextBuilder.__index:PrependLocalized(textKey, ...)
    return self:Prepend(Localize(textKey, ...))
end

function TextBuilder.__index:Join(separator)
    if self:IsEmpty() then
        -- TODO Log warning
    end

    return _lua_table_concat(self._table, separator)
end


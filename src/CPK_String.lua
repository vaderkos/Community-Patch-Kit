local _lua_string_byte = string.byte
local _lua_string_gsub = string.gsub
local _lua_string_format = string.format

local AssertIsString = CPK.Assert.Is.String

local String = CPK.Module()
CPK.String = String

--- Escapes specified string
--- @nodiscard
--- @param str string
--- @return string
function String.Escape(str)
    AssertIsString(str)

    -- I'm not so good at pettern matching in lua, there might be a better solution...
	local escaped = str
        -- Null character
        :gsub('%z', '\\0')
        -- Special characters
        :gsub('[%%\n\t\v\r\f\\"\']', {
            ['%'] = '%%',
            ['\n'] = '\\n',
            ['\t'] = '\\t',
            ['\v'] = '\\v',
            ['\r'] = '\\r',
            ['\f'] = '\\f',
            ['"'] = '\\"',
            ["'"] = "\\'",
        })
        -- Unprintable(\001-\031) and implementation specific(\128-\255) characters
        :gsub('[\001-\031\128-\255]', function(char)
            -- Convert to \ddd with leading zeros
            return _lua_string_format("\\%03d", _lua_string_byte(char))
        end)

    return escaped
end

--- Removes whitespaces from both ends of specified string
--- @nodiscard
--- @param str string
--- @return string
function String.Trim(str)
    AssertIsString(str)

	local trimmed = _lua_string_gsub(str, "^%s*(.-)%s*$", "%1")

	return trimmed
end


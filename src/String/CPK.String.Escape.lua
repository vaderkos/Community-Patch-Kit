local _lua_string_format = string.format
local _lua_string_byte = string.byte

--- Returns a string with special characters escaped.
--- This function escapes special characters such as newlines, tabs, and quotes,
--- as well as unprintable and extended ASCII characters.
--- 
--- ```lua
--- -- Example
--- local Escape = CPK.String.Escape
--- Escape('abc') -- 'abc'
--- Escape('\n \r \t \v " \' %') -- '\\n \\r \\t \\v \" \' %%'
--- ```
--- 
--- @param str string # The input string to escape.
--- @return string # Escaped string.
--- @nodiscard
local function Escape(str)
		-- I'm not so good at pettern matching in lua, there might be a better solution...
	local res = str
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

	return res
end

CPK.String.Escape = Escape

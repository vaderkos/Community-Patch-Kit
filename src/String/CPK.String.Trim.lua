--- Removes leading and trailing whitespace characters from the specified string.
--- Whitespace characters include spaces, tabs, and newline characters.
--- 
--- ```lua
--- -- Example
--- local Trim = CPK.String.Trim
--- Trim('') -- ''
--- Trim(' abc') -- 'abc'
--- Trim('abc ') -- 'abc'
--- Trim(' abc ') -- 'abc'
--- Trim('\n\r\t abc \n\r\t') -- 'abc'
--- Trim('\n\r\t') -- ''
--- Trim('[NEWLINE] abc [NEWLINE]') -- '[NEWLINE] abc [NEWLINE]'
--- ```
--- 
--- @param str string
--- @return string
--- @nodiscard
local function Trim(str)
	local res = str:gsub("^%s*(.-)%s*$", "%1")

	return res
end

CPK.String.Trim = Trim


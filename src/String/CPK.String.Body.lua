--- Returns the substring of the given string, excluding the first and last characters.
--- If the string is empty or has only one or two characters, it returns an empty string.
--- 
--- ```lua
--- -- Example
--- local Body = CPK.String.Body
--- Body('') -- ''
--- Body('a') -- ''
--- Body('ab') -- ''
--- Body('abc') -- 'b'
--- ```
--- 
--- @param str string # The input string from which to extract the body substring.
--- @return string # The substring excluding the first and last characters, or an empty string if the input is too short.
--- @nodiscard
local function Body(str)
	return str:sub(2, str:len() - 1)
end

CPK.String.Body = Body

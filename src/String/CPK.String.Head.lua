--- Returns the first character (head) of the given string.
--- If the string is empty, it returns an empty string.
--- 
--- ```lua
--- -- Example
--- local Head = CPK.String.Head
--- Head('abc') -- 'a'
--- Head('a') -- 'a'
--- Head('') -- ''
--- ```
--- 
--- @param str string # The input string from which to extract the first character (head).
--- @return string # The first character of the string, or an empty string if the input is empty.
--- @nodiscard
local function Head(str)
	return str:sub(1, 1)
end

CPK.String.Head = Head

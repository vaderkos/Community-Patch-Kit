--- Returns the substring of the given string excluding the first character.
--- If the string is empty or has only one character, it returns an empty string.
--- 
--- ```lua
--- -- Example
--- local Tail = CPK.String.Tail
--- Tail('abc') -- 'bc'
--- Tail('ab') -- 'b'
--- Tail('a') -- ''
--- Tail('') -- ''
--- ```
--- 
--- @param str string
--- @return string
--- @nodiscard
local function Tail(str)
	return str:sub(2)
end

CPK.String.Tail = Tail

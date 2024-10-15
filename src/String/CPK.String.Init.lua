--- Returns the input string with the last character removed.
--- If the string is empty, it returns an empty string.
--- 
--- ```lua
--- -- Example
--- local Init = CPK.String.Init
--- Init('abc') -- 'ab'
--- Init('ab') -- 'a'
--- Init('a') -- ''
--- Init('') -- ''
--- ```
--- 
--- @param str string
--- @return string
--- @nodiscard
local function Init(str)
	return str:sub(1, str:len() - 1)
end

CPK.String.Init = Init

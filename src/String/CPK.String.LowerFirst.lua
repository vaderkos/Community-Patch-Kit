local Lower = string.lower

local Head = CPK.String.Head
local Tail = CPK.String.Tail

--- Returns the input string with the first character converted to lowercase.
--- If the string is empty, it returns an empty string.
--- 
--- ```lua
--- -- Example
--- local LowerFirst = CPK.String.LowerFirst
--- LowerFirst('Abc') -- 'abc'
--- LowerFirst('abc') -- 'abc'
--- LowerFirst('123') -- '123'
--- LowerFirst('') -- ''
--- ```
--- 
--- @param str string
--- @return string
--- @nodiscard
local function LowerFirst(str)
	return Lower(Head(str)) .. Tail(str)
end

CPK.String.LowerFirst = LowerFirst

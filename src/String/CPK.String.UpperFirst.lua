local Upper = string.upper

local Head = CPK.String.Head
local Tail = CPK.String.Tail

--- Capitalizes the first character of the given string.
--- If the string is empty, it returns an empty string.
---
--- ```lua
--- -- Example
--- local UpperFirst = CPK.String.UpperFirst
--- UpperFirst('abc') -- 'Abc'
--- UpperFirst('Abc') -- 'Abc'
--- UpperFirst('123') -- '123'
--- UpperFirst('') -- ''
--- ```
---
--- @param str string
--- @return string
--- @nodiscard
local function UpperFirst(str)
	return Upper(Head(str)) .. Tail(str)
end

CPK.String.UpperFirst = UpperFirst

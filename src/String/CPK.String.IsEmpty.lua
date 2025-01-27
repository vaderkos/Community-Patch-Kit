local AssertIsString = CPK.Assert.IsString

--- Checks if specified string is empty.
--- Returns `true` if the string is empty, otherwise `false`.
---
--- ```lua
--- -- Example
--- local IsEmpty = CPK.String.IsEmpty
--- IsEmpty('') -- true
--- IsEmpty('a') -- false
--- ```
---
--- @param str string
--- @return boolean
--- @nodiscard
local function IsEmpty(str)
	AssertIsString(str)
	return str == ''
end

CPK.String.IsEmpty = IsEmpty
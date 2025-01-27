local AssertIsNumber = CPK.Assert.IsNumber

--- Checks if the specified number is zero.
--- This function returns `true` if the number is zero, otherwise `false`.
---
--- ```lua
--- -- Example
--- local IsZero = CPK.Number.IsZero
--- print(IsZero(0))    -- Output: true
--- print(IsZero(1))    -- Output: false
--- print(IsZero(-1))   -- Output: false
--- ```
---
--- @param num number
--- @return boolean
--- @nodiscard
local function IsZero(num)
	AssertIsNumber(num)

	return num == 0
end

CPK.Number.IsZero = IsZero
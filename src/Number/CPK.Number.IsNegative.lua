local AssertIsNumber = CPK.Assert.IsNumber

--- Checks if the specified number is negative.
--- This function returns `true` if the number is less than zero, otherwise `false`.
---
--- ```lua
--- -- Example
--- local IsNegative = CPK.Number.IsNegative
--- print(IsNegative(-1))   -- Output: true
--- print(IsNegative(0))    -- Output: false
--- print(IsNegative(1))    -- Output: false
--- ```
---
--- @param num number # The number to check if it is negative.
--- @return boolean # `true` if the number is negative, `false` otherwise.
--- @nodiscard
local function IsNegative(num)
	AssertIsNumber(num)

	return num < 0
end

CPK.Number.IsNegative = IsNegative
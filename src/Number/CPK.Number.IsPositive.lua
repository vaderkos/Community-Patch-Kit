--- Checks if the specified number is positive.
--- This function returns `true` if the number is greater than zero, otherwise `false`.
---
--- ```lua
--- -- Example
--- local IsPositive = CPK.Number.IsPositive
--- print(IsPositive(1))    -- Output: true
--- print(IsPositive(0))    -- Output: false
--- print(IsPositive(-1))   -- Output: false
--- ```
---
--- @param num number # The number to check if it is positive.
--- @return boolean # `true` if the number is positive, `false` otherwise.
--- @nodiscard
local function IsPositive(num)
	-- TODO assert
	return num > 0
end

CPK.Number.IsPositive = IsPositive

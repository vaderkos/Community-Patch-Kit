
--- Checks if the specified number is even or zero.
--- This function returns `true` if the number is even (including zero), otherwise `false`.
---
--- ```lua
--- -- Example
--- local IsEven = CPK.Number.IsEven
--- print(IsEven(0))    -- Output: true
--- print(IsEven(2))    -- Output: true
--- print(IsEven(1))    -- Output: false
--- print(IsEven(-2))   -- Output: true
--- ```
--- 
--- @param num number # The number to check if it is even or zero.
--- @return boolean # `true` if the number is even or zero, `false` otherwise.
--- @nodiscard
local function IsEven(num)
	-- TODO Assert
	return (num % 2) == 0
end

CPK.Number.IsEven = IsEven

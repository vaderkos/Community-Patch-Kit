-- TODO

--- Checks if the specified number is odd and not zero.
--- This function returns `true` if the number is not zero and its remainder when divided by 2 is not zero, indicating it is odd.
---
--- ```lua
--- -- Example
--- local IsOdd = CPK.Number.IsOdd
--- print(IsOdd(1))    -- Output: true
--- print(IsOdd(2))    -- Output: false
--- print(IsOdd(0))    -- Output: false
--- print(IsOdd(-3))   -- Output: true
--- ```
---
--- @param num number # The number to check if it is odd.
--- @return boolean # `true` if the number is odd, `false` otherwise.
--- @nodiscard
local function IsOdd(num)
	-- TODO Assert
	return (num % 2) ~= 0 and (num ~= 0) 
end

CPK.Number.IsOdd = IsOdd

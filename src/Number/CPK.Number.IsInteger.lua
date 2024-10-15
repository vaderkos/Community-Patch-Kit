local _lua_math_floor = math.floor

--- Checks if the specified number is an integer.
--- This function returns `true` if the number is equal to its floored value (i.e., it has no fractional part), otherwise `false`.
--- 
--- ```lua
--- -- Example
--- local IsInteger = CPK.Number.IsInteger
--- print(IsInteger(1))      -- Output: true
--- print(IsInteger(1.5))    -- Output: false
--- print(IsInteger(-1))     -- Output: true
--- print(IsInteger(-1.5))   -- Output: false
--- ```
--- 
--- @param num number # The number to check if it is an integer.
--- @return boolean # `true` if the number is an integer, `false` otherwise.
--- @nodiscard
local function IsInteger(num)
	-- TODO Assert
	return num == _lua_math_floor(num)
end

CPK.Number.IsInteger = IsInteger

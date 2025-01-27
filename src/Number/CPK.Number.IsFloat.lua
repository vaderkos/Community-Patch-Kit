local _lua_math_floor = math.floor

local AssertIsNumber = CPK.Assert.IsNumber

--- Checks if the specified number is a floating-point number.
--- This function returns `true` if the number has a fractional part, indicating it is a float, otherwise `false`.
---
--- ```lua
--- -- Example
--- local IsFloat = CPK.Number.IsFloat
--- print(IsFloat(1))      -- Output: false
--- print(IsFloat(1.5))    -- Output: true
--- print(IsFloat(-1))     -- Output: false
--- print(IsFloat(-1.5))   -- Output: true
--- ```
---
--- @param num number # The number to check if it is a float.
--- @return boolean # `true` if the number is a floating-point number, `false` otherwise.
--- @nodiscard
local function IsFloat(num)
	AssertIsNumber(num)

	return num ~= _lua_math_floor(num)
end

CPK.Number.IsFloat = IsFloat
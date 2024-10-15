local _lua_math_sqrt = math.sqrt

local Variance = CPK.Stats.Variance

--- Calculates the standard deviation of a list of numbers.
--- The standard deviation is the square root of the variance 
--- and provides a measure of the amount of variation or dispersion in a set of values.
---
--- ```lua
--- -- Example
--- local Stdev = CPK.Stats.Stdev
--- print(Stdev({ 1, 2, 3 }))            -- Output: 0.8164...
--- print(Stdev({ 1, 2, 3, 4 }))         -- Output: 1.1180...
--- print(Stdev({ 10, 20, 30, 40, 50 })) -- Output: 14.1421...
--- ```
---
--- @param tbl number[] # A table of numbers to calculate the standard deviation from.
--- @return number # The standard deviation of the input numbers.
--- @nodiscard
local function Stdev(tbl)
	return _lua_math_sqrt(Variance(tbl))
end

CPK.Stats.Stdev = Stdev

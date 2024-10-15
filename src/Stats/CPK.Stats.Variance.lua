local _lua_next = next

local AssertIsTable = CPK.Assert.IsTable
local Mean = CPK.Stats.Mean

--- Calculates the variance of a list of numbers.
--- The variance measures the average squared deviation of each number from the mean.
--- The function calculates the mean of the numbers and then computes the average of the squared differences from the mean.
---
--- ```lua
--- -- Example
--- local Variance = CPK.Stats.Variance
--- print(Variance({1, 2, 3}))           -- Output: 0.66666666666667
--- print(Variance({1, 2, 3, 4}))        -- Output: 1.25
--- print(Variance({10, 20, 30, 40, 50})) -- Output: 200
--- ```
--- 
--- @param tbl number[] # A table of numbers to calculate the variance from.
--- @return number # The variance of the input numbers.
--- @nodiscard
local function Variance(tbl)
	AssertIsTable(tbl)

	local cnt = 0
	local mean = Mean(tbl)
	local sumOfSquares = 0

	for _, val in _lua_next, tbl, nil do
		cnt = cnt + 1
		sumOfSquares = sumOfSquares + ((val - mean) ^ 2)
	end

	return sumOfSquares / cnt
end

CPK.Stats.Variance = Variance

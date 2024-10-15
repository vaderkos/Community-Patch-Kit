local AssertIsCallable = CPK.Assert.IsCallable

--- Creates a memoized version of a specified nullary (zero-argument) function.
--- The result of the first function call is cached and returned on subsequent calls.
--- @generic Fn : fun(): any
--- @param fn Fn  -- The nullary function to memoize
--- @return Fn    -- The memoized version of the function
local function Memoize0(fn)
	AssertIsCallable(fn)

	local cache = nil

	return function(...)
			if cache ~= nil then
					return cache
			end

			cache = fn(...)

			return cache
	end
end

CPK.FP.Memoize0 = Memoize0

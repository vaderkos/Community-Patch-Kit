local _lua_setmetatable = setmetatable

local Identity = CPK.FP.Identity
local AssertIsTable = CPK.Assert.IsTable
local AssertIsCallable = CPK.Assert.IsCallable

--- Creates a memoized version of an unary (single-argument) function.
--- The result is cached based on the provided key from the argument.
--- Optionally, you can pass a custom cache or/and a function to provide keys.
--- @generic Fn : fun(arg: any): any 
--- @param fn Fn # The function to be memoized
--- @param cache? table # An optional cache table (default is weak-value table)
--- @param hash? fun(arg: any): any # A function to provide cache keys based on the arg (defaults to Identity)
--- @return Fn # A memoized version of the function
local function Memoize1(fn, cache, hash)
	if cache == nil then
		cache = _lua_setmetatable({}, { __mode = 'v' })
	else
		AssertIsTable(cache)
	end

	if hash == nil then
		hash = Identity
	else
		AssertIsCallable(hash)
	end

	return function(arg)
		local key = hash(arg)

		if key == nil then
			return fn(arg)
		end

		local val = cache[key]

		if val == nil then
			val = fn(key)

			if val ~= nil then
					cache[key] = val
			end
		end

		return val
	end
end

CPK.FP.Memoize1 = Memoize1

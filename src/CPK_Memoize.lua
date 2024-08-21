local _lua_setmetatable = setmetatable

local AssertIsFunction = CPK.Assert.Is.Function
local AssertIsTableOrNil = CPK.Assert.Is.TableOrNil
local AssertIsCallableOrNil = CPK.Assert.Is.CallableOrNil

local Memoize = CPK.Module()
CPK.Memoize = Memoize

--- Creates memoized version of specified nullary function.
--- If memoized function returns nil then result is not cached.
--- @nodiscard
--- @generic Fn : fun(): any
--- @param fn Fn # Nullary function to memoize
--- @return Fn
function Memoize.Nullary(fn)
	AssertIsFunction(fn)

	local cache = nil

	return function()
		if cache ~= nil then
			return cache
		end

		cache = fn()

		return cache
	end
end

--- Creates memoized version of specified unary function.
--- If memoized function is called with `nil` then caching is omitted expect if custom provider function is not handling such case.
--- If original function returns nil then result is not cached
--- @nodiscard
--- @generic Fn : fun(arg: any): any
--- @param fn Fn # Unary function to memoize
--- @param cache? table # Table used for caching. If not specified then new table with weak values is created.
--- @param provide? fun(arg: any): any # Custom cache key provider. If not specified function parameter is used as key.
--- @return Fn
function Memoize.Unary(fn, cache, provide)
		AssertIsFunction(fn)
		AssertIsTableOrNil(cache)
		AssertIsCallableOrNil(provide)

		if cache == nil then
				cache = _lua_setmetatable({}, { __mode = 'v' })
		end

		if provide == nil then
				provide = function(key)
						return key
				end
		end

		return function(key)
				key = provide(key)

				if key == nil then
						return fn(key)
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
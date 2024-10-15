local _lua_select = select
local _lua_unpack = unpack

local AssertIsNumber = CPK.Assert.IsNumber
local AssertIsCallable = CPK.Assert.IsCallable

--- Creates a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.
--- Looks like in Lua5.1 there is no table.pack so this function is an alternative implementation for it.
--- @see table.pack
--- @param ... any
--- @return { n: integer, [any]: any }
--- @nodiscard
local function Pack(...)
	return { n = _lua_select('#', ...), ... }
end

--- Unpacks specified table using it's property `"n"`
--- @see unpack
--- @see table.unpack
--- @param args any
--- @return unknown
local function Unpack(args)
	return _lua_unpack(args, 1, args.n or #args)
end

--- Creates a curried version of the specified function.
--- A curried function takes a specified number of arguments. If fewer arguments are provided,
--- the function returns a new function that takes the remaining arguments.
--- The curried function counts all specified arguments, including `nil`. Empty values are not counted.
---
--- ```lua
--- -- Example
--- local Curry = CPK.FP.Curry
--- local Add = function(a, b, c) return a + b + c end
--- local CurriedAdd = Curry(3, Add)
--- print(CurriedAdd(1)(2)(3)) -- Output: 6
--- ```
---
--- @generic Fn : fun(...: any): any
--- @param len integer # The number of arguments required to execute the function.
--- @param fn Fn # The function to be curried.
--- @param args? { n: integer, [any]: any } # Initial bound arguments. If its size is greater than or equal to `len`, `fn` is executed immediately.
--- @return function # A curried version of the specified function.
--- @nodiscard
local function Curry(len, fn, args)
	AssertIsNumber(len)
	AssertIsCallable(fn)

	local prevArgs = args or Pack()
	local prevSize = prevArgs.n or #prevArgs

	return function(...)
		local currArgs = Pack(...)
		local currSize = currArgs.n

		local nextArgs = { Unpack(prevArgs) }
		local nextSize = prevSize + currSize

		nextArgs.n = nextSize

		for i = 1, currSize do
			nextArgs[i + prevSize] = currArgs[i]
		end

		if nextSize >= len then
			return fn(Unpack(nextArgs))
		end

		return Curry(len, fn, nextArgs)
	end
end

CPK.FP.Curry = Curry

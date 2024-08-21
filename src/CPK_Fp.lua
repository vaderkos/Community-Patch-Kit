local Size = CPK.Vararg.Size
local Pack = CPK.Vararg.Pack
local Unpack = CPK.Vararg.Unpack

local Fp = CPK.Module()
CPK.Fp = Fp

--- Creates function that executes specified functions from first to last passing the result from first to second and etc.
--- ```lua
--- -- Example
--- local A = function() return 'a', ... end
--- local B = function() return 'b', ... end
--- local C = function() return 'c', ... end
--- local fun = Fp.Pipe(A, B, C) -- function(...) return C(B(A(...))) end
--- local c, b, a, one, two, three = fun(1, 2, 3)
--- ```
--- @param ... function
--- @return function
function Fp.Pipe(...)
	local fns = Pack(...)
	local len = Size(...)

	local function Call(i, ...)
		local fn = fns[i]

		if i >= len then
				return fn(...)
		end

		return Call(i + 1, fn(...))
	end

	return function(...)
		return Call(1, ...)
	end
end

--- Creates function that executes specified functions from last to first passing the result from last to butlast and etc.
--- ```lua
--- -- Example
--- local A = function() return 'a', ... end
--- local B = function() return 'b', ... end
--- local C = function() return 'c', ... end
--- local fun = Fp.Pipe(A, B, C) -- function(...) return A(B(C(...))) end
--- local c, b, a, one, two, three = fun(1, 2, 3) -- 'a', 'b', 'c', 1, 2, 3
--- ```
--- @param ... function
--- @return function
function Fp.Compose(...)
	local fns = Pack(...)
	local len = Size(...)

	local function Call(i, ...)
		local fn = fns[i]

		if i <= 1 then
			return fn(...)
		end

		return Call(i - 1, fn(...))
	end

	return function(...)
		return Call(len, ...)
	end
end

--- Creates curried version of specified function
--- @generic Fn : fun(...): any
--- @param size int
--- @param fn Fn
--- @param args? any[] | CPK.Vararg<any> # Bound arguments. If its size is gte than specified size executes fn
--- @return function
local function Curry(size, fn, args)
	local prevArgs = args or Pack()
	local prevSize = prevArgs.n or #prevArgs

	return function(...)
		local currArgs = Pack(...)
		local currSize = Size(...)

		local nextArgs = { Unpack(prevArgs) }
		local nextSize = currSize + prevSize

		nextArgs.n = nextSize

		for i = 1, currSize do
			nextArgs[i + prevSize] = currArgs[i]
		end

		if nextSize >= size then
			return fn(Unpack(nextArgs))
		end

		return Curry(size, fn, nextArgs)
	end
end
Fp.Curry = Curry
local _lua_select = select
local _lua_table_unpack = table.unpack or unpack

local Vararg = CPK.Module()
CPK.Vararg = Vararg

--- @generic T
--- @class CPK.Vararg<T> : { [int]: T, n: int }

--- Gets amount of vararg elements
--- @param ... unknown
--- @return any
--- @nodiscard
local function Size(...)
    return _lua_select('#', ...)
end

Vararg.Size = Size

--- Creates a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.
--- Looks like in Lua5.1 there is no table.pack so this function is an alternative implementation for it.
--- @generic T
--- @see table.pack
--- @param ... T
--- @return CPK.Vararg<T>
--- @nodiscard
function Vararg.Pack(...)
    --- @type { [any]: any, n: integer }
    local args = { ... }
    args.n = Size(...)

    return args
end

--- @see unpack
--- @see table.unpack
--- @generic T
--- @param args T[] | CPK.Vararg<T>
--- @param from? integer
--- @param upto? integer
--- @return T ...
--- @nodiscard
function Vararg.Unpack(args, from, upto)
    if args.n then
        return _lua_table_unpack(args, from or 1, upto or args.n)
    end

    return _lua_table_unpack(args, from, upto)
end

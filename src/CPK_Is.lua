local _lua_type = type
local _lua_getmetatable = getmetatable

local Is = CPK.Module()
CPK.Is = Is

--- Checks if type of specified value is `"nil"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.Nil(val)  return _lua_type(val) == "nil" end

--- Checks if type of specified value is `"table"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.Table(val) return _lua_type(val) == "table" end

--- Checks if type of specified value is `"string"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.String(val) return _lua_type(val) == "string" end

--- Checks if type of specified value is `"number"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.Number(val) return _lua_type(val) == "number" end

--- Checks if type of specified value is `"thread"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.Thread(val) return _lua_type(val) == "thread" end

--- Checks if type of specified value is `"function"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.Function(val) return _lua_type(val) == "function" end

--- Checks if type of specified value is `"userdata"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.Userdata(val) return _lua_type(val) == "userdata" end

--- Checks if type of specified value is `"function"`
--- or if value is table that has `__call` function in it's metatable 
--- @nodiscard
--- @param val any
--- @return boolean
function Is.Callable(val)
    local type = _lua_type(val)

    if type == 'function' then
        return true
    end

    if type == 'table' then
        local mt = _lua_getmetatable(val)

        return _lua_type(mt) == 'table' and _lua_type(mt.__call) == 'function'
    end

    return false
end

local IsTable = Is.Table
local IsString = Is.String
local IsNumber = Is.Number
local IsThread = Is.Thread
local IsFunction = Is.Function
local IsUserdata = Is.Userdata
local IsCallable = Is.Callable

--- Checks if type of specified value is `"table"` or `"nil"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.TableOrNil(val) return val == nil or IsTable(val) end

--- Checks if type of specified value is `"string"` or `"nil"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.StringOrNil(val) return val == nil or IsString(val) end

--- Checks if type of specified value is `"number"` or `"nil"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.NumberOrNil(val) return val == nil or IsNumber(val) end


--- Checks if type of specified value is `"thread"` or `"nil"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.ThreadOrNil(val) return val == nil or IsThread(val) end

--- Checks if type of specified value is `"function"` or `"nil"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.FunctionOrNil(val) return val == nil or IsFunction(val) end

--- Checks if type of specified value is `"userdata"` or `"nil"`
--- @nodiscard
--- @param val any
--- @return boolean
function Is.UserdataOrNil(val) return val == nil or IsUserdata(val) end

--- Checks if type of specified value is `"function"` or `"nil"`
--- or if value is table that has `__call` function in it's metatable 
--- @nodiscard
--- @param val any
--- @return boolean
function Is.CallableOrNil(val) return val == nil or IsCallable(val) end
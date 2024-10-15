local _lua_type = type
local _lua_debug = debug

local IsLuaDebugEnabled = CPK.Util.IsLuaDebugEnabled

local function IsLuaDebugTraceEnabled()
	return IsLuaDebugEnabled() and _lua_type(_lua_debug.traceback) == 'function'
end

CPK.Util.IsLuaDebugTraceEnabled = IsLuaDebugTraceEnabled

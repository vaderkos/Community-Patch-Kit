local _lua_type = type
local _lua_debug = debug

local function IsLuaDebugEnabled()
	return _lua_type(_lua_debug) == 'table'
end

CPK.Util.IsLuaDebugEnabled = IsLuaDebugEnabled
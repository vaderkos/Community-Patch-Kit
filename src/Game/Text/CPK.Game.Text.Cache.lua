local _lua_setmetatable = setmetatable

local cache = _lua_setmetatable({}, { __mode = 'kv' }) --[[@as table<string, string>]]

CPK.Game.Text.Cache = cache
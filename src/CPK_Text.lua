local _lua_select = select
local _lua_setmetatable = setmetatable

local Text = CPK.Module()
CPK.Text = Text

-- Allow direct access to cache so it's accessible inside FireTuner
Text.Cache = _lua_setmetatable({}, { __mode = 'v' })

local L = Locale.Lookup
local LM = CPK.Memoize.Unary(L, Text.Cache)

--- @enum CPK.Text.Token
Text.Token = {
    Tab = '[TAB]',
    Space = '[SPACE]',
    Newline = '[NEWLINE]',
}

function Text.Localize(textKey, ...)
    if _lua_select('#', ...) > 0 then
        return L(textKey, ...)
    end

    return LM(textKey)
end

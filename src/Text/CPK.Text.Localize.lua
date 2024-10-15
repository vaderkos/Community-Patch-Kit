local _lua_select = select

local _civ_locale_lookup = Locale.Lookup or function(val) return val end

local Cache = CPK.Text.Cache
local Memoize1 = CPK.FP.Memoize1
local Identity = CPK.FP.Identity

local _Localize = Memoize1(_civ_locale_lookup, Cache, Identity)

local function Localize(textKey, ...)
	if _lua_select('#', ...) > 0 then
		return _civ_locale_lookup(textKey, ...)
	end

	return _Localize(textKey)
end

CPK.Text.Localize = Localize

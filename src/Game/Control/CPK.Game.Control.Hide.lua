local _lua_next = next
local _lua_select = select

local AssertIsFunction = CPK.Assert.IsFunction

--- Hides each specified control.
--- @param control Civ.Control
--- @param ... Civ.Control
--- @return nil
local function HideControl(control, ...)
	AssertIsFunction(control.SetHide)
	control:SetHide(true)

	if _lua_select('#', ...) == 0 then
		return
	end

	local tbl = { ... }

	for _, val in _lua_next, tbl, nil do
		AssertIsFunction(val.SetHide)
		val:SetHide(true)
	end
end

CPK.Game.Control.Hide = HideControl
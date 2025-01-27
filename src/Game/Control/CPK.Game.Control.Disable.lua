local _lua_next = next
local _lua_select = select

local AssertIsFunction = CPK.Assert.IsFunction

--- Disables each specified control.
--- @param control Civ.Control
--- @param ... Civ.Control
--- @return nil
local function DisableControl(control, ...)
	AssertIsFunction(control.SetDisabled)
	control:SetDisabled(true)

	if _lua_select('#', ...) == 0 then
		return
	end

	local tbl = { ... }

	for _, val in _lua_next, tbl, nil do
		AssertIsFunction(val.SetDisabled)
		val:SetDisabled(true)
	end
end

CPK.Game.Control.Disable = DisableControl
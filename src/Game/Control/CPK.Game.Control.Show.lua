local _lua_next = next
local _lua_select = select

local AssertIsFunction = CPK.Assert.IsFunction

--- Shows each control from the specified table.
--- @param control Civ.Control
--- @param ... Civ.Control
--- @return nil
local function ShowControl(control, ...)
	AssertIsFunction(control.SetHide)

	control:SetHide(false)

	if _lua_select('#', ...) == 0 then
		return
	end

	local tbl = { ... }

	for _, val in _lua_next, tbl, nil do
		AssertIsFunction(val.SetHide)

		val:SetHide(false)
	end
end

CPK.Game.Control.Show = ShowControl
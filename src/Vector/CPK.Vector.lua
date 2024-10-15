local _lua_setmetatable = setmetatable

local AssertIsTable = CPK.Assert.IsTable
local AssertIsNumber = CPK.Assert.IsNumber

--- @overload fun(x, y, z, w): CPK.Vector
local Vector = {}

CPK.Vector = Vector

--- @class CPK.Vector
--- @field x number
--- @field y number
--- @field z? number
--- @field w? number
Vector.__index = {}

function Vector.new(x, y, z, w)
	if w ~= nil then
		AssertIsNumber(w)
		AssertIsNumber(z)
	elseif z ~= nil then
		AssertIsNumber(z)
	end

	AssertIsNumber(y)
	AssertIsNumber(x)

	local this = {
		x = x,
		y = y,
		z = z,
		w = w,
	}

	return _lua_setmetatable(this, Vector --[[@as table]])
end

function Vector.FromPlot(plot)
	return Vector.new(plot:GetX(), plot:GetY())
end

function Vector.FromUnit(unit)
	return Vector.new(unit:GetX(), unit:GetY())
end

function Vector.FromGrid(x, y)
	return Vector.new()
end

function Vector.FromHex(hex)
	return Vector.new(hex.x, hex.y, hex.z, hex.w)
end

--- @param a CPK.Vector
--- @param b CPK.Vector
--- @return CPK.Vector
local function Add(a, b)
	AssertIsTable(a)
	AssertIsTable(b)

	return Vector.new(
		(a.x and b.x) and (a.x + b.x),
		(a.y and a.y) and (a.y + b.y),
		(a.z and b.z) and (a.z + b.z),
		(a.w and b.w) and (a.w + b.w)
	)
end
Vector.Add = Add

--- @param a CPK.Vector
--- @param b CPK.Vector
--- @return CPK.Vector
local function Sub(a, b)
	AssertIsTable(a)
	AssertIsTable(b)

	return Vector.new(
		(a.x and b.x) and (a.x - b.x),
		(a.y and a.y) and (a.y - b.y),
		(a.z and b.z) and (a.z - b.z),
		(a.w and b.w) and (a.w - b.w)
	)
end
Vector.Sub = Sub

--- Gets size of vector
--- @return integer
function Vector.__index:Size()
	if self.w then return 4 end
	if self.z then return 3 end

	return 2
end

--- @param vec CPK.Vector
--- @return CPK.Vector
function Vector.__index:Add(vec)
	return Add(self, vec)
end

--- @param vec CPK.Vector
--- @return CPK.Vector
function Vector.__index:Sub(vec)
	return Sub(self, vec)
end

function Vector.__index:ToHex()
	 -- TODO
end

function Vector.__index:ToPlot()
	
end

function Vector.__index:ToGrid()

end

function Vector.__add(a, b)
	return Add(a, b)
end

function Vector.__sub(a, b)
	return Sub(a, b)
end

_lua_setmetatable(Vector --[[@as table]], { 
	__call = function(...)
		return Vector.new(...)
	end
})
local _lua_type = type
local _lua_assert = assert

local IsCallable = CPK.Is.Callable

local Assert = CPK.Module()
Assert.Is = CPK.Module()
Assert.Is.Not = CPK.Module()
CPK.Assert = Assert

--- Gets TypeError message string used in type assertions
--- @param got  string | number # Got
--- @param exp  string | number # Expected
--- @param mes? string | number # Extra message
local function GetAssertErrorMessage(got, exp, mes)
    got = got == nil and 'nil' or got
    exp = exp == nil and 'nil' or exp
    mes = mes == nil and '' or (' ' .. mes)

    return 'Assert Error: Got ' .. got .. ' where ' .. exp .. ' exected.' .. mes
end

--- Creates a function that asserts value to specified lua type
--- @param exp type # Expected lua type
local function CreateTypeAsserter(exp)
    --- @type fun(val: any, mes?: string | number): nil
    return function(val, mes)
        local got = _lua_type(val)

        _lua_assert(got == exp, GetAssertErrorMessage(got, exp, mes))
    end
end

--- Throws assertion error
--- @param got  string | number # Got
--- @param exp  string | number # Expected
--- @param mes? string | number # Extra message
function Assert.Throw(got, exp, mes)
    _lua_assert(false, GetAssertErrorMessage(got, exp, mes))
end

Assert.Is.Nil = CreateTypeAsserter('nil')
Assert.Is.Table = CreateTypeAsserter('table')
Assert.Is.String = CreateTypeAsserter('string')
Assert.Is.Number = CreateTypeAsserter('number')
Assert.Is.Thread = CreateTypeAsserter('thread')
Assert.Is.Userdata = CreateTypeAsserter('userdata')
Assert.Is.Function = CreateTypeAsserter('function')

--- Creates a function that asserts value to specified type or nil
--- @param exp type # Expected lua type
local function CreateTypeOrNilAsserter(exp)
    --- @type fun(val: any, mes?: string | number): nil
    return function(val, mes)
        if val == nil then return end

        local got = _lua_type(val)

        _lua_assert(got == exp, GetAssertErrorMessage(got, (exp .. ' or nil'), mes))
    end
end


Assert.Is.TableOrNil = CreateTypeOrNilAsserter('table')
Assert.Is.StringOrNil = CreateTypeOrNilAsserter('string')
Assert.Is.NumberOrNil = CreateTypeOrNilAsserter('number')
Assert.Is.ThreadOrNil = CreateTypeOrNilAsserter('thread')
Assert.Is.UserdataOrNil = CreateTypeOrNilAsserter('userdata')
Assert.Is.FunctionOrNil = CreateTypeOrNilAsserter('function')

function Assert.Is.Callable(val, mes)
    _lua_assert(IsCallable(val), GetAssertErrorMessage(_lua_type(val), 'callable', mes))
end

function Assert.Is.CallableOrNil(val, mes)
    if val == nil then return end

    _lua_assert(IsCallable(val), GetAssertErrorMessage(_lua_type(val), 'callable or nil', mes))
end

function Assert.Is.Not.Nil(val, mes)
	_lua_assert(val ~= nil, GetAssertErrorMessage(_lua_type(val), 'not nil', mes))
end

--- Creates a function that asserts value is not specified lua type
--- @param exp type # Expected not lua type
local function CreateNotTypeAsserter(exp)
	--- @type fun(val: any, mes?: string | number): nil
	return function(val, mes)
		local got = _lua_type(val)

		_lua_assert(got ~= exp, GetAssertErrorMessage(got, 'not ' .. exp, mes))
	end
end

Assert.Is.Not.Nil = CreateNotTypeAsserter('nil')
Assert.Is.Not.Table = CreateNotTypeAsserter('table')
Assert.Is.Not.String = CreateNotTypeAsserter('string')
Assert.Is.Not.Number = CreateNotTypeAsserter('number')
Assert.Is.Not.Thread = CreateNotTypeAsserter('thread')
Assert.Is.Not.Userdata = CreateNotTypeAsserter('userdata')
Assert.Is.Not.Function = CreateNotTypeAsserter('function')
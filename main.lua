include = require
require 'CPK'
local Curry = CPK.Fp.Curry
local Unpack = CPK.Vararg.Unpack

local function printTable(tbl)
	for key, val in next, tbl, nil do
		print(key .. ' = ' .. val)
	end
end

local mock = { 'a', 'b', 'c', 'd', 'e', 'f' }

function testA(...) return print('testA', ...) end

 local ShallowMergeTables = CPK.Table.ShallowMerge
 local a = { a = 1 }
 local b = { b = 2 }
 local c = { c = 3, a = 999}
 local result = ShallowMergeTables(a, b, c) -- { a = 999, b = 2, c = 3 }
 printTable(result)


function PrintA(...) 
    print('A', ...) 
    return ...
end

function PrintB(...) 
    print('B', ...)
    return ...
end
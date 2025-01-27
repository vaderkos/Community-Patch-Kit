local _lua_setmetatable = setmetatable

local Inspector = CPK.Debug.Inspector
local indentedCache = _lua_setmetatable({}, { __mode = 'v' })
local cachedNilInspector = nil

local function GetInspector(indent)
	if indent == nil then
		if cachedNilInspector == nil then
			cachedNilInspector = Inspector.new()
		end

		return cachedNilInspector
	end

	local inspector = indentedCache[indent]

	if inspector == nil then
		inspector = Inspector.new(indent)
		indentedCache[indent] = inspector
	end

	return inspector
end

--- Converts specified value to string
--- ```lua
--- -- Example
--- print(Inspect(1)) -- 1
--- print(Inspect('Hello world')) -- "Hello world"
--- 
--- local tbl = { a = 1, b = 2, c = function() end }
--- print(Inspect(tbl)) -- {--[[table: 0x14590dc70]]["a"]=1,["c"]={--[[function: 0x14590fa50]]},["b"]=2}
--- 
--- tbl['recur'] = tbl
--- print(Inspect(tbl, 2)) -- Output below:
--- -- { --[[ table: 0x1369126d0]]
--- --   ["a"] = 1,
--- --   ["recur"] = { --[[ *table: 0x1369126d0 ]] },
--- --   ["c"] = { --[[ function: 0x1369127b0 ]] },
--- --   ["b"] = 2
--- -- }
--- 
--- tbl[tbl] = tbl
--- tbl['sub'] = { 7, 8, 9 }
--- print(Inspect(tbl, 4)) -- Output below:
--- -- { --[[ table: 0x13e5085e0]]
--- --     ["a"] = 1,
--- --     ["c"] = { --[[ function: 0x13e5086c0 ]] },
--- --     ["b"] = 2,
--- --     [{ --[[ *table: 0x13e5085e0 ]] }] = { --[[ *table: 0x13e5085e0 ]] },
--- --     ["sub"] = { --[[ table: 0x13e508f80]]
--- --         [1] = 7,
--- --         [2] = 8,
--- --         [3] = 9
--- --     },
--- --     ["recur"] = { --[[ *table: 0x13e5085e0 ]] }
--- -- }
--- ```
--- @param val any
--- @param indent? number | string # If string then used as indentation. If number then the amount for spaces for each indentation
--- @return string
local function Inspect(val, indent)
	return GetInspector(indent):Inspect(val)
end

CPK.Debug.Inspect = Inspect
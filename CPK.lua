--- @alias int integer

(function()
	if CPK ~= nil then
		return
	end

	local _lua_type = type
	local _lua_error = error
	local _lua_tostring = tostring
	local _lua_setmetatable = setmetatable

	local _civ_include = include

	--- Creates table that holds values dynamically loaded using resolution table
	--- @param resolution? nil | table<string, string>
	local function Module(resolution)
		--- @type table<string, boolean>
		local loaded = {}
		local module = {}
		local counter = 0

		resolution = resolution or {}

		local function GetPrefix()
			return 'CPK ' .. counter ..': '
		end

		return _lua_setmetatable(module, {
			__index = function(tbl, key)
				local filename = resolution[key]

				local function GetInfo()
					return '"' .. key .. '" with filename "' .. _lua_tostring(filename) .. '".'
				end

				-- if _lua_type(filename) ~= 'string' then
				-- 	_lua_error(GetPrefix() .. 'Failed to resolve ' .. GetInfo() .. ' Filename is not defined')
				-- end				

				if loaded[key] then
					_lua_error(GetPrefix() .. 'Failed to resolve ' .. GetInfo() .. ' Recursive resolution detected!')
				end

				loaded[key] = false
				_civ_include(filename)
				loaded[key] = true


				local value = tbl[key]

				if value ~= nil then
					counter = counter + 1
					print(GetPrefix() .. 'Successfully resolved ' .. GetInfo() .. ' (' .. _lua_type(value) .. ')')

					return value
				end

				_lua_error(
					GetPrefix() .. 'Failed to resolve ' .. GetInfo() .. ' Property "' .. key .. '" is nil. Please verify:'
					.. '\n\t* File "' .. filename .. '" must exist in codebase.'
					.. '\n\t* File "' .. filename .. '" must be included in VFS.'
					.. '\n\t* File "' .. filename .. '" code must add non-nil property "' .. key .. '".'
				)
			end
		})
	end

	CPK = Module({
		Assert   = 'src/CPK_Assert',
		Date     = 'src/CPK_Date',
		Fp       = 'src/CPK_Fp',
		Inspect  = 'src/CPK_Inspect',
		Is       = 'src/CPK_Is',
		Logger   = 'src/CPK_Logger',
		Memoize  = 'src/CPK_Memoize',
		String   = 'src/CPK_String',
		Table    = 'src/CPK_Table',
		Text     = 'src/CPK_Text',
		TextBuilder = 'src/CPK_TextBuilder',
		Vararg   = 'src/CPK_Vararg',
	})

	CPK.Module = Module
end)()
local _ = (function()
	if CPK ~= nil then
		return
	end

	--- @type boolean
	CPK_VERBOSE = false

	local _lua_type = type
	local _lua_next = next
	local _lua_error = error
	local _lua_tostring = tostring

	local _lua_string_match = string.match
	local _lua_table_insert = table.insert
	local _lua_table_concat = table.concat

	local _lua_getmetatable = getmetatable
	local _lua_setmetatable = setmetatable

	local _civ_include = include or (function() -- emulate include in none civ5 environment
		--- @param dir string
		--- @return string[]
		local function GetFilePaths(dir)
				local stream = io.popen('find "' .. dir .. '" -type f')
				local files = {}

				if stream == nil then
					return files
				end

				for line in stream:lines() do
					_lua_table_insert(files, line)
				end

				return files
		end

		local paths = GetFilePaths('.')

		local function GetPath(filename)
			for _, path in _lua_next, paths, nil do
				if string.sub(path, -string.len(filename)) == filename then
					return path
				end
			end

			return filename
		end

		return function(filename)
			local success, result = pcall(dofile, GetPath(filename))

			if not success then
				print(result)
				if result:find('^cannot open') then
					return {}
				end

				error(result, 3)
			end

			return { filename }
		end
	end)()

	local function Info(message)
		if CPK_VERBOSE then
			print('CPK:', message)
		end
	end

	--- Includes specified file from VFS. Ensures only 1 file is included.
	--- @param filename string
	--- @return nil
	local function Import(filename)
		local type = _lua_type(filename)

		if type ~= 'string' then
			local message = 'Failed to include file because filename is not string but ' .. type '.'
			_lua_error(message)
		end

		local included = _civ_include(filename)

		if #included == 1 then
			Info('Included file "' .. filename .. '"')
			return nil
		end

		local failed = 'Failed to include file "' .. filename .. '".'

		if #included < 1 then
			local message = failed .. ' File not found.'
				.. '\n\t' .. 'Please verify if specified file is registered in VFS.'
				.. '\n\t' .. 'Please verify if specified file exists.'

			_lua_error(message)
		end

		local tokens = {}

		for _, path in _lua_next, included, nil do
			_lua_table_insert(tokens, '"' .. path .. '"')
		end

		local message = failed .. ' Filename is not unique enough. Multiple candidates found: {'
			.. '\n\t' .. _lua_table_concat(tokens, ',\n\t')
			.. '\n}'

		_lua_error(message)
	end

	local Node = {}
	Node.__index = {}

	--- @overload fun(name?: string): table
	local Module = {}
	Module.Node = Node

	local function Error(lvl, mes)
		if _lua_type(mes) == 'table' then
			mes = _lua_table_concat(mes, '\n\t')
		end

		_lua_error(mes, lvl)
	end
	Node.Error = Error

	local keyPattern = '^[%w-_]+$'

	--- @param key any
	--- @return boolean
	local function IsValidKey(key)
		return _lua_type(key) == 'string' and _lua_string_match(key, keyPattern) -- TODO
	end
	Module.IsValidKey = IsValidKey

	--- @param val any
	--- @return boolean
	local function IsValidVal(val)
		return val ~= nil
	end
	Module.IsValidVal = IsValidVal

	--- @param val any 
	--- @return nil
	local function GetNode(val)
		if _lua_type(val) ~= 'table' then
			return nil
		end

		local node = _lua_getmetatable(val)

		if node == nil then
			return nil
		end

		local meta = _lua_getmetatable(node)

		if meta ~= Node then
			return nil
		end

		return node
	end
	Module.GetNode = GetNode

	--- @param val any
	--- @return boolean
	local function IsModule(val)
		return GetNode(val) ~= nil
	end
	Module.IsModule = IsModule

	--- @param val any
	--- @return string
	local function GetInfo(val)
		return '(' .. _lua_type(val) .. ') ' .. _lua_tostring(val)
	end
	Node.GetInfo = GetInfo

	function Node.new(name)
		local node = _lua_setmetatable({}, Node)

		node.name = name
		node.parent = node
		node.children = {}

		node.__index = function(_, key)
			return node:Resolve(key)
		end

		node.__newindex = function(_, key, val)
			return node:Assign(key, val)
		end

		return node
	end

	--- @param name? string
	--- @return string
	function Node.__index:GetPath(name)
		local path = { self.name or '?' } -- '?' means that this module does not have parent yet
		local this = self

		if name ~= nil then
			_lua_table_insert(path, name)
		end

		while not this:IsRoot() do
			this = this.parent
			_lua_table_insert(path, 1, this.name)
		end

		return _lua_table_concat(path, '.')
	end

	--- @param name? string
	--- @return string
	function Node.__index:GetFile(name)
		return self:GetPath(name) .. '.lua'
	end

	--- @return boolean
	function Node.__index:IsRoot()
		return self == self.parent
	end

	--- @param key string
	--- @param val any
	--- @return nil
	function Node.__index:Assign(key, val)
		if not Module.IsValidKey(key) then
			Error(4, {
				'Failed to assign property within "' .. self:GetPath() .. '".',
				'Key must be a string that matches "' .. keyPattern .. '".',
				'Key is ' .. GetInfo(key),
			})
		end

		local pathname = self:GetPath(key)

		if not Module.IsValidVal(val) then
			Error(4, {
				'Failed to assign property "' .. pathname .. '".',
				'Value must not be nil.',
				'Value is ' .. GetInfo(val)
			})
		end

		local child = self.children[key]

		if child ~= nil then
			Error(4, {
				'Failed to assign property "' .. pathname .. '".',
				'The specified key is already assigned, and reassignment is not allowed.',
				'The current value assigned to the specified key is ' .. GetInfo(child) .. '.',
				'The value that was attempted to be assigned is ' .. GetInfo(val) .. '.',
			})
		end

		local node = GetNode(val)

		if node ~= nil then
			if not node:IsRoot() then
				Error(4, {
					'Failed to assign property "' .. pathname .. '".',
					'Multi-ownership is prohibited.',
					'The specified module is already adopted by another module ' .. node:GetPath(),
				})
			end

			node.parent = self
			node.name = key
		end

		self.children[key] = val
		Info('Assigned ' .. _lua_type(val) .. ' ' .. self:GetPath(key))
	end

	--- @param key string
	--- @return any
	function Node.__index:Resolve(key)
		if not Module.IsValidKey(key) then
			Error(4, {
				'Failed to resolve property within "' .. self:GetPath() .. '".',
				'Key must be a string that matches "' .. keyPattern .. '".',
				'Key is ' .. GetInfo(key),
			})
		end

		local child = self.children[key]

		if child ~= nil then
			return child
		end

		local pathname = self:GetPath(key)
		local filename = self:GetFile(key)

		if filename:match('^%?') then
			Error(4, {
				'Failed to resolve property "' .. pathname .. '" using file "' .. filename .. '".',
				'Path is ambiguous; no clear root module specified.',
				'Please verify that your root module is created with the correct name and filename.',
				'Please verify that your module tree is built in the correct order.'
			})
		end

		local success, result = pcall(Import, filename)

		if not success then
			Error(4, {
				'Failed to resolve property "' .. pathname .. '" using file "' .. filename .. '".',
				result,
			})
		end

		child = self.children[key]

		if child ~= nil then
			Info('Resolved ' .. _lua_type(child) .. ' ' .. pathname)
			return child
		end

		Error(4, {
			'Failed to resolve property "' .. pathname .. '" using file "' .. filename .. '".',
			'The file was included, but no value was assigned under the key "' .. key .. '".',
			'Please verify that the property is being assigned within the included file.'
		})
	end

	--- Creates new module. If name is specified module is considered root
	--- @param name? string
	--- @return table
	function Module.new(name)
		local module = _lua_setmetatable({}, Node.new(name))

		return module
	end

	_lua_setmetatable(Module --[[@as table]], {
		__call = Module.new
	})

	CPK = Module.new('CPK')
	CPK.Module = Module
	CPK.Import = Import

end)()

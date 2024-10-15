local _lua_next = next
local _lua_os_clock = os.clock
local _lua_setmetatable = setmetatable

local Always = CPK.FP.Always
local IsTable = CPK.Type.IsTable
local Inspect = CPK.Util.Inspect
local DateToISO = CPK.Date.ToISO
local ShallowCopy = CPK.Table.ShallowCopy
local AssertIsTable = CPK.Assert.IsTable
local IsLuaDebugEnabled = CPK.Util.IsLuaDebugEnabled
local IsLuaDebugTraceEnabled = CPK.Util.IsLuaDebugTraceEnabled

local LUA_DEBUG_ENABLED = IsLuaDebugEnabled()
local LUA_DEBUG_TRACE_ENABLED = IsLuaDebugTraceEnabled()

local _lua_debug_traceback = LUA_DEBUG_TRACE_ENABLED and debug.traceback or Always(nil)

local Logger = {}

--- @class CPK.Util.Logger
Logger.__index = {}
CPK.Util.Logger = Logger

--- @enum CPK.Util.Logger.LogLevel
local LogLevel = _lua_setmetatable({
	ANY    = 0,
	DEBUG  = 1,
	INFO   = 2,
	WARN   = 3,
	ERROR  = 4,
	FATAL  = 5,
}, { __index = function() return 0 end })

--- @enum CPK.Util.Logger.LogLevelName
local LogLevelName = _lua_setmetatable({
	[LogLevel.ANY]    = "ANY",
	[LogLevel.DEBUG]  = "DEBUG",
	[LogLevel.INFO]   = "INFO",
	[LogLevel.WARN]   = "WARN",
	[LogLevel.ERROR]  = "ERROR",
	[LogLevel.FATAL]  = "FATAL",
}, { __index = function() return "ANY" end })

Logger.LogLevel = LogLevel
Logger.LogLevelName = LogLevelName

local LOG_LEVEL_ANY   = LogLevel.ANY   --[[@as CPK.Util.Logger.LogLevel]]
local LOG_LEVEL_DEBUG = LogLevel.DEBUG --[[@as CPK.Util.Logger.LogLevel]]
local LOG_LEVEL_INFO  = LogLevel.INFO  --[[@as CPK.Util.Logger.LogLevel]]
local LOG_LEVEL_WARN  = LogLevel.WARN  --[[@as CPK.Util.Logger.LogLevel]]
local LOG_LEVEL_ERROR = LogLevel.ERROR --[[@as CPK.Util.Logger.LogLevel]]
local LOG_LEVEL_FATAL = LogLevel.FATAL --[[@as CPK.Util.Logger.LogLevel]]

--- Log Data
--- @alias CPK.Util.Logger.LogData { message?: string, context?: table, metadata?: any, [any]: any }

--- Log
--- @alias CPK.Util.Logger.Log { level: CPK.Util.Logger.LogLevelName, clock: number, timestamp: string, data?: CPK.Util.Logger.LogData }

--- Log Consumer
--- @alias CPK.Util.Logger.LogConsumer fun(log: CPK.Util.Logger.Log, opts: CPK.Util.Logger.Options): any

--- Logger Options
--- @alias CPK.Util.Logger.Options { level?: CPK.Util.Logger.LogLevel, indent?: number | string, context?: table, consumers?: table<any, CPK.Util.Logger.LogConsumer> }

--- @package
--- @type CPK.Util.Logger.LogConsumer
Logger._defaultConsumer = function(log, opts)
	print(Inspect(log, opts.indent))
end

--- @package
--- @type CPK.Util.Logger.Options
Logger._defaultOptions = {
	level = LUA_DEBUG_ENABLED and LOG_LEVEL_ANY or LOG_LEVEL_INFO,
	indent = nil,
	consumers = {
		default = Logger._defaultConsumer
	},
}

--- @protected
--- @type CPK.Util.Logger.Options
Logger.__index._options = {}

--- Creates new logger
--- @param options? CPK.Util.Logger.Options
--- @return CPK.Util.Logger
function Logger.new(options)
	if options ~= nil then
		AssertIsTable(options)
	else
		options = Logger._defaultOptions
	end

	--- @type CPK.Util.Logger
	local this = {
		_options = {
			level = options.level or Logger._defaultOptions.level,
			indent = options.indent or Logger._defaultOptions.indent,
			context = options.context or {
				state = StateName -- global state name
			},
			consumers = options.consumers or ShallowCopy(Logger._defaultOptions.consumers)
		}
	}

	return _lua_setmetatable(this, Logger)
end

--- Sets logger consumer. If consumer is nil removes consumer for specified id from logger.
--- @param id string | 'default'
--- @param consumer nil | CPK.Util.Logger.LogConsumer
function Logger.__index:SetConsumer(id, consumer)
	self._options[id] = consumer

	return self
end

--- @param message? string
--- @param metadata? any
function Logger.__index:Info(message, metadata)
	return self:_Log(LOG_LEVEL_INFO, message, metadata)
end

--- @param message? string
--- @param metadata? any
function Logger.__index:Warn(message, metadata)
	return self:_Log(LOG_LEVEL_WARN, message, metadata)
end

--- @param message? string
--- @param metadata? any
function Logger.__index:Error(message, metadata)
	return self:_Log(LOG_LEVEL_ERROR, message, metadata)
end

--- @param message? string
--- @param metadata? any
function Logger.__index:Debug(message, metadata)
	return self:_Log(LOG_LEVEL_DEBUG, message, metadata)
end

--- @param message? string
--- @param metadata? any
function Logger.__index:Fatal(message, metadata)
	return self:_Log(LOG_LEVEL_FATAL, message, metadata)
end

--- Consumes specified log
--- @protected
--- @param log CPK.Util.Logger.Log
--- @return CPK.Util.Logger
function Logger.__index:_Consume(log)
	local opts = self._options
	local consumers = opts.consumers

	for _, consumer in _lua_next, consumers, nil do
		consumer(log, opts)
	end

	return self
end

--- Creates log from specified parameters and consumes it
--- @protected
--- @param level CPK.Util.Logger.LogLevel # Log Level
--- @param message? string | nil # Log message
--- @param metadata? any # Log data metadata
--- @param extra? table | nil # Extra log data properties
--- @return CPK.Util.Logger
function Logger.__index:_Log(level, message, metadata, extra)
	local options = self._options

	if options.level > level then
			return self
	end

	--- @type CPK.Util.Logger.LogData
	local data = {
		message = message,
		metadata = metadata,
		context = options.context,
		stack = nil,
	}

	if level >= LOG_LEVEL_WARN then
		data.stack = _lua_debug_traceback()
	end

	if IsTable(extra) then
		for key, val in _lua_next, extra, nil do
			data[key] = val
		end
	end

	--- @type CPK.Util.Logger.Log
	local log = {
		level = LogLevelName[level] --[[@as CPK.Util.Logger.LogLevelName]],
		clock = _lua_os_clock(),
		timestamp = DateToISO(),
		data = data
	}

	return self:_Consume(log)
end

--- comment
--- @param options CPK.Util.Logger.Options
function Logger.__index:With(options)
	return Logger.new {
		level = options and options.level or self._options.level,
		indent = options and options.indent or self._options.indent,
		context = options and options.context or self._options.context,
		consumers = options and options.consumers or self._options.consumers,
	}
end

--- @package
--- @type CPK.Util.Logger
Logger._defaultLogger = nil

--- Gets or creates Logger instance with default parameters
--- @return CPK.Util.Logger
function Logger.GetDefault()
	if Logger._defaultLogger == nil then
		Logger._defaultLogger = Logger.new()
	end

	return Logger._defaultLogger
end
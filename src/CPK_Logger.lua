local _lua_next = next
local _lua_type = type
local _lua_debug = debug
local _lua_setmetatable = setmetatable

local _lua_os_clock = os.clock

local IsTable = CPK.Is.Table
local AssertIsTableOrNil = CPK.Assert.Is.TableOrNil
local GetDateIsoString = CPK.Util.Date.GetIsoString
local ShallowCopyTable = CPK.Util.Table.ShallowCopy

local LUA_DEBUG_ENABLED = _lua_type(_lua_debug) == 'table'
local LUA_DEBUG_TRACEBACK_ENABLED = LUA_DEBUG_ENABLED and _lua_type(_lua_debug.traceback)

--- @enum CPK.Logger.LogLevel
local LogLevel = _lua_setmetatable({
	ANY    = 0,
	DEBUG  = 1,
	INFO   = 2,
	WARN   = 3,
	ERROR  = 4,
	FATAL  = 5,
}, { __index = function() return 0 end })

--- @enum CPK.Logger.LogLevelName
local LogLevelName = _lua_setmetatable({
    [LogLevel.ANY]    = "ANY",
	[LogLevel.DEBUG]  = "DEBUG",
	[LogLevel.INFO]   = "INFO",
	[LogLevel.WARN]   = "WARN",
	[LogLevel.ERROR]  = "ERROR",
	[LogLevel.FATAL]  = "FATAL",
}, { __index = function() return "ANY" end })

local LOG_LEVEL_ANY   = LogLevel.ANY   --[[@as CPK.Logger.LogLevel]]
local LOG_LEVEL_INFO  = LogLevel.INFO  --[[@as CPK.Logger.LogLevel]]
local LOG_LEVEL_WARN  = LogLevel.WARN  --[[@as CPK.Logger.LogLevel]]
local LOG_LEVEL_ERROR = LogLevel.ERROR --[[@as CPK.Logger.LogLevel]]
local LOG_LEVEL_DEBUG = LogLevel.DEBUG --[[@as CPK.Logger.LogLevel]]
local LOG_LEVEL_FATAL = LogLevel.FATAL --[[@as CPK.Logger.LogLevel]]

--- Log
--- @alias CPK.Logger.Log { level: CPK.Logger.LogLevelName, clock: number, timestamp: string, data?: CPK.Logger.LogData }

--- Log Data
--- @alias CPK.Logger.LogData { message?: string, context?: table, metadata?: any, [any]: any }

--- Log Consumer
--- @alias CPK.Logger.LogConsumer fun(log: CPK.Logger.Log, opts: CPK.Logger.Opts): any

--- Logger Options
--- @alias CPK.Logger.Opts { level?: CPK.Logger.LogLevel, indent?: nil | number | string, context?: nil | table, consumers?: table<any, CPK.Logger.LogConsumer> }

local Logger = { name = 'CPK.Logger' }
CPK.Logger = Logger

Logger.LogLevel = LogLevel
Logger.LogLevelName = LogLevelName

--- @type CPK.Logger.LogConsumer
Logger.DefaultLogConsumer = function(log, opts)
    print(log.timestamp, log.level, log.data.message)
end

--- @type CPK.Logger.Opts
Logger.DefaultOpts = {
    level = LUA_DEBUG_ENABLED and LOG_LEVEL_ANY or LOG_LEVEL_INFO,
    indent = nil,
    context = nil,
    consumers = {
        default = Logger.DefaultLogConsumer
    },
}

--- Logger constructor
--- @param opts? CPK.Logger.Opts
--- @return CPK.Logger
function Logger.new(opts)
    AssertIsTableOrNil(opts)

	if opts == nil then
		opts =  ShallowCopyTable(Logger.DefaultOpts)
    else
        opts = ShallowCopyTable(opts)
        opts.level = opts.level or Logger.DefaultOpts.level
        opts.indent = opts.indent or Logger.DefaultOpts.indent
        opts.context = opts.context or Logger.DefaultOpts.context
        opts.consumers = opts.consumers or Logger.DefaultOpts.consumers
    end

	--- @type CPK.Logger
	local this = { _opts = opts }

	return _lua_setmetatable(this, Logger)
end

--- @class CPK.Logger
--- @field _opts CPK.Logger.Opts
Logger.__index = {}

--- @param message? string
--- @param metadata? any
--- @return CPK.Logger
function Logger.__index:Info(message, metadata)
	return self:Log(LOG_LEVEL_INFO, message, metadata)
end

--- @param message? string
--- @param metadata? any
--- @return CPK.Logger
function Logger.__index:Warn(message, metadata)
	return self:Log(LOG_LEVEL_WARN, message, metadata)
end

--- @param message? string
--- @param metadata? any
--- @return CPK.Logger
function Logger.__index:Error(message, metadata)
	return self:Log(LOG_LEVEL_ERROR, message, metadata)
end

--- @param message? string
--- @param metadata? any
--- @return CPK.Logger
function Logger.__index:Debug(message, metadata)
	return self:Log(LOG_LEVEL_DEBUG, message, metadata)
end

--- @param message? string
--- @param metadata? any
--- @return CPK.Logger
function Logger.__index:Fatal(message, metadata)
	return self:Log(LOG_LEVEL_FATAL, message, metadata)
end

--- Consumes specified log
--- @param log CPK.Logger.Log
--- @return CPK.Logger
function Logger.__index:Consume(log)
    local opts = self._opts
	local consumers = opts.consumers

	for _, consume in _lua_next, consumers, nil do
        consume(log, opts)

	end

	return self
end

--- Creates log from specified parameters and consumes it
--- @param level CPK.Logger.LogLevel # Log Level
--- @param message? string | nil # Log message
--- @param metadata? any # Log data metadata
--- @param extra? table | nil # Extra log data properties
--- @return CPK.Logger
function Logger.__index:Log(level, message, metadata, extra)
    local opts = self._opts

    if opts.level > level then
        return self
    end

    --- @type CPK.Logger.LogData
    local data = {
        message = message,
        metadata = metadata,
        context = opts.context,
        stack = (LUA_DEBUG_TRACEBACK_ENABLED and level >= LOG_LEVEL_WARN) and debug.traceback() or nil
    }

    if IsTable(extra) then
        for key, val in _lua_next, extra, nil do
			data[key] = val
		end
    end

    --- @type CPK.Logger.Log
    local log = {
        level = LogLevelName[level] --[[@as CPK.Logger.LogLevelName]],
        clock = _lua_os_clock(),
        timestamp = GetDateIsoString(),
        data = data
    }

    return self:Consume(log)
end

--- Creates new logger with options taken from self but overriden by specified options
--- @param opts? CPK.Logger.Opts
--- @return CPK.Logger
function Logger.__index:With(opts)
	if opts == nil then
		opts = {}
	end

	return Logger.new {
		level = opts.level or self._opts.level,
		indent = opts.indent or self._opts.indent,
		context = opts.context or self._opts.context,
		consumers = opts.consumers or self._opts.consumers,
	}
end

function Logger.__index:GetOpts()
    return self._opts
end
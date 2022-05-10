---@meta

---@class luvit.process
process = {}

---@type uv
local uv
---@type luvit.timer
local timer
---@type luvi.env
local env

nextTick = timer.setImmediate

---
---A table value that acts as a middle layer to luvi.env.
---Indexing the table will return back `env.get(key)` (__index), setting a new index to the table would trigger
---`env.set(key, value)`, if `value` was nil it would instead do `env.unset(key)` (__newindex). And `pairs(lenv)` will use the `lenv.iterate` iterator (__pairs).
---
local lenv = {
  get = env.get,
}

---@alias lenv_iterate_iterator fun(): string, string

---
---Returns an iterator function, each time that function is called it returns `name, value` of some environment variable. U
---Until all keys are consumed, it returns nil indicating that.
---
---@return lenv_iterate_iterator iterator
---@return string[] keys
---@return nil
---@nodiscard
function lenv.iterate() end
lenv.__pairs = lenv.iterate

---
---Sends the specified signal to the given PID. Check the documentation on `uv_signal_t` for signal support, specially on Windows.
---
---@param pid integer
---@param signal string|integer|'sigterm'
local function kill(pid, signal) end

---
---@param self luvit.core.Emitter # The process instance
---@param code? integer # Process's exit code
local function exit(self, code) end

---
---Returns the memory usage of the current process in bytes
---in the form of a table with the structure:
--- `{ rss = value, heapUsed = value }`
---where rss is the resident set size for the current process,
---and heapUsed is the memory used by the Lua VM
---
---@param self luvit.core.Emitter # The proccess instance
---@return {rss: number, heapUsed: number} memoryUsage
---@nodiscard
local function memoryUsage(self) end

---
---Returns the user and system CPU time usage of the current process in microseconds
---(as a table of the format {user=value, system=value})
---The result of a previous call to process:cpuUsage() can optionally be passed as 
---an argument to get a diff reading
---
---@param self luvit.core.Emitter # The proccess instance
---@param prevValue? number # Previous CPU time
---@return {user: integer, system: integer}
---@nodiscard
local function cpuUsage(self, prevValue) end

-- TODO: UvStreamWritable and UVStreamReadable.handle can also be a fs.ReadStream

---
---@class luvit.process.UvStreamWritable: luvit.stream.Writable
---@field handle uv_pipe_t|uv_stream_t
local UvStreamWritable = {}

---
---@class luvit.process.UvStreamReadable: luvit.stream.Readable
---@field reading boolean
---@field handle uv_pipe_t|uv_stream_t
local UvStreamReadable = {}

---
---@type luvit.core.Emitter
local global_proccess_rtn = {
  argv = args,
  ---@type integer
  exitCode = 0,
  nextTick = nextTick,
  env = lenv,
  cwd = uv.cwd,
  kill = kill,
  pid = uv.os_getpid(),
  exit = exit,
  memoryUsage = memoryUsage,
  cpuUsage = cpuUsage,
  stdin = UvStreamReadable,
  stdout = UvStreamWritable,
  stderr = UvStreamWritable,
}

---
function process.globalProcess() return global_proccess_rtn end

return process
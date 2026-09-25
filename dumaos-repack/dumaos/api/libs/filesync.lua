-- nil-safe syslog: the app framework logs "App '%s' initialised & starting."
-- with a nil package when the api.init bind completes without the
-- (optional) com.netdumasoftware.api publisher, and string.format's
-- "bad argument #2" error then kills every R-App ~1 minute after start.
-- Wrap the global syslog/syslog_prio so nil args degrade to "nil" strings.
do
  local wrapped = {}
  local function mk(orig)
    if type(orig) ~= "function" then return orig end
    return function(prio, fmt, ...)
      local ok, res = pcall(orig, prio, fmt, ...)
      if ok then return res end
      local t = {}
      for i = 1, select("#", ...) do
        local v = select(i, ...)
        t[i] = (v == nil) and "nil" or tostring(v)
      end
      local ok2, res2 = pcall(orig, prio, fmt, unpack(t))
      if ok2 then return res2 end
      return nil
    end
  end
  local mt = getmetatable(_G) or {}
  local old_ni = mt.__newindex
  mt.__newindex = function(t, k, v)
    if (k == "syslog" or k == "syslog_prio") and type(v) == "function" and not wrapped[k] then
      wrapped[k] = true
      v = mk(v)
    end
    if old_ni then return old_ni(t, k, v) end
    rawset(t, k, v)
  end
  setmetatable(_G, mt)
  for _, k in ipairs({"syslog", "syslog_prio"}) do
    local v = rawget(_G, k)
    if type(v) == "function" and not wrapped[k] then
      wrapped[k] = true
      rawset(_G, k, mk(v))
    end
  end
end
local real = assert(loadfile('/dumaos/api/libs/filesync_impl.lua'))()
local function safe(f)
  if type(f) ~= 'function' then return f end
  return function(...)
    local n = select('#', ...)
    local a = {}
    for i = 1, n do
      local v = select(i, ...)
      if v == nil then v = 'nil' end
      a[i] = v
    end
    return f(unpack(a, 1, n))
  end
end
local lastfn
local function guard()
  local s = syslog
  if type(s) == 'table' then
    if not s.__safe_wrapped then
      for _, k in ipairs({'debug','info','notice','warning','warn','err','error','critical','alert','emerg'}) do
        s[k] = safe(s[k])
      end
      s.__safe_wrapped = true
    end
  elseif type(s) == 'function' and s ~= lastfn then
    s = safe(s)
    syslog = s
    lastfn = s
  end
end
local t = {}
for k, v in pairs(real) do
  if type(v) == 'function' then
    t[k] = function(...)
      guard()
      return v(...)
    end
  else
    t[k] = v
  end
end
guard()
return t

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

-- Wrapper around stock /dumaos/api/libs/time_zone_orig.lua (kept by the
-- dumaos-repack package). Stock getTimeZoneID() never matches the system
-- timezone and always falls back to default_time_zone (37 = Brisbane).
-- Resolution order (from uci system.@system[0]): zonename exact IANA,
-- same-region IANA prefix with a matching current UTC offset, POSIX
-- timezone string exact, current UTC offset match, stock default.
-- zonenames from the portal may contain spaces (e.g. "America/Costa
-- Rica") so they are normalised to IANA underscores. Offsets and DST
-- states are computed with the POSIX TZ strings in the environment
-- (this firmware's glibc ignores IANA zoneinfo names); the process TZ
-- is only a last resort since it is frozen at daemon start. 60s cache.
local orig = dofile("/dumaos/api/libs/time_zone_orig.lua")
local DEFAULT = 37
local cache, cachet = nil, 0
local function uciGet(opt)
  local p = io.popen("uci -q get system.@system[0]." .. opt .. " 2>/dev/null")
  if not p then return nil end
  local v = p:read("*l")
  p:close()
  if v == nil or v == "" then return nil end
  return v
end
local function entries()
  local list = {}
  for id = 0, 60 do
    local ok, e = pcall(orig.getTimeZoneFromID, id)
    if ok and e then list[#list+1] = e end
  end
  return list
end
local function runLua(tz, expr)
  local q = "'" .. tz:gsub("'", "'\\''") .. "'"
  local p = io.popen("TZ=" .. q .. " lua -e " .. string.format("%q", expr) .. " 2>/dev/null")
  if not p then return nil end
  local v = p:read("*n")
  p:close()
  return v
end
-- effective UTC offset (hours) for a POSIX TZ string (nil on failure)
local function zoneOffset(tz)
  if not tz then return nil end
  local off = runLua(tz, 'local d=os.date("*t") print((os.time()-os.time(os.date("!*t")))/3600+(d.isdst and 1 or 0))')
  if not off then return nil end
  return math.floor(off + 0.5)
end
local function procOffset()
  local off = math.floor((os.time() - os.time(os.date("!*t"))) / 3600)
  return off + (os.date("*t").isdst and 1 or 0)
end
local dstCache = {}
local function entryOffset(e)
  if not e.tz or not e.tz:find(",") then return e.offset end
  if dstCache[e.tz] == nil then
    local d = runLua(e.tz, 'print(os.date("*t").isdst and 1 or 0)')
    dstCache[e.tz] = (d == 1)
  end
  return e.offset + (dstCache[e.tz] and 1 or 0)
end
local function fromUci()
  local list = entries()
  local zn = uciGet("zonename")
  if zn then zn = zn:gsub(" ", "_") end
  local tz = uciGet("timezone")
  if zn then
    for _,e in ipairs(list) do
      if e.iana == zn then return e.id end
    end
    local region = zn:match("^(.+/)")
    if region then
      local off = zoneOffset(tz) or procOffset()
       for _,e in ipairs(list) do
         if e.iana and e.iana:sub(1, #region) == region
            and entryOffset(e) == off then return e.id end
      end
      for _,e in ipairs(list) do
        if e.iana and e.iana:sub(1, #region) == region
           and e.offset == off then return e.id end
      end
    end
  end
  if tz then
    for _,e in ipairs(list) do
      if e.tz == tz then return e.id end
    end
  end
  local off = zoneOffset(tz) or procOffset()
  for _,e in ipairs(list) do
    if entryOffset(e) == off then return e.id end
  end
  for _,e in ipairs(list) do
    if e.offset == off then return e.id end
  end
  return nil
end
local function getTZ()
  if cache and os.time() - cachet < 60 then return cache end
  local id = fromUci()
  if id == nil then
    local ok, res = pcall(orig.getTimeZoneID)
    id = (ok and res ~= nil) and res or DEFAULT
  end
  cache, cachet = id, os.time()
  return id
end
orig.getTimeZoneID = getTZ
return orig

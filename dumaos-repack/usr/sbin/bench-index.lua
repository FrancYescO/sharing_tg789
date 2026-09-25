-- Fill benchmark index from history files (app skips parsing when save=true)
package.path = "/dumaos/apps/usr/com.netdumasoftware.benchmark/?.lua;/dumaos/api/libs/?.lua;" .. package.path
package.cpath = "/dumaos/api/libs/?.so;" .. package.cpath
g_handle = setmetatable({}, {__index = function() return function() return {} end end})
local bc = require("benchmark_common")
local json = require("json")
local keys = {
  ["0-1"] = {"speed","up"}, ["0-3"] = {"speed","down"},
  ["1-1"] = {"ping","ping"}, ["1-2"] = {"ping","jitter"}, ["1-3"] = {"ping","loss"},
  ["2-1"] = {"bbloat","idle"}, ["2-4"] = {"bbloat","up"}, ["2-7"] = {"bbloat","down"},
}
local dir = bc.tmp_folder
local idx_file = dir .. "data_history_index.txt"
local raw = bc.get_raw_index()
local idx
if type(raw) == "table" and raw.tests then
  idx = raw
elseif type(raw) == "string" then
  idx = json.decode(raw)
end
if type(idx) ~= "table" then idx = {version="2.0.0", next_id=0, max_size=100, tests={}} end
if type(idx.tests) ~= "table" then idx.tests = {} end
local byid = {}
for _,t in pairs(idx.tests) do byid[tostring(t.time)] = t end
local changed = false
local p = io.popen("ls " .. dir .. " 2>/dev/null")
for name in p:lines() do
  local tm = name:match("^(%d+)%.txt")
  local gz = false
  if not tm then tm = name:match("^(%d+)%.txt%.gz$") gz = true end
  if tm and not byid[tm] then
    local f
    if gz then
      f = io.popen("zcat '" .. dir .. name .. "' 2>/dev/null")
      if not f then f = nil end
    else
      f = io.open(dir .. name)
    end
    if f then
      local data = {}
      local iter = gz and f:lines() or f:lines()
      for line in iter do
        local a = {}
        for tok in string.gmatch(line, "([^-]+)") do table.insert(a, tok) end
        local m = keys[(a[1] or "") .. "-" .. (a[2] or "")]
        if m then
          if not data[m[1]] then data[m[1]] = {} end
          data[m[1]][m[2]] = tonumber(a[3])
        end
      end
      f:close()
      if next(data) then
        idx.next_id = (idx.next_id or 0) + 1
        local t = {
          id = idx.next_id, time = tonumber(tm), end_time = os.time(),
          options = {speed=true,ping=true,bbloat=true,speed_length=9,ping_length=10,bbloat_length=9,save=false,scheduled=false,failed=false,version="2.0.0"},
          isp_speeds = {1000,1000}, data = data,
        }
        table.insert(idx.tests, t)
        changed = true
      end
    end
  end
end
for _,t in pairs(idx.tests) do
  if type(t.data) ~= "table" or next(t.data) == nil then
    local name = t.time .. ".txt"
    local gz = false
    local f = io.open(dir .. name)
    if not f then f = io.popen("zcat '" .. dir .. name .. ".gz' 2>/dev/null"); gz = true end
    if f then
      local data = {}
      for line in f:lines() do
        local a = {}
        for tok in string.gmatch(line, "([^-]+)") do table.insert(a, tok) end
        local m = keys[(a[1] or "") .. "-" .. (a[2] or "")]
        if m then
          if not data[m[1]] then data[m[1]] = {} end
          data[m[1]][m[2]] = tonumber(a[3])
        end
      end
      f:close()
      if next(data) then t.data = data; t.end_time = t.end_time or os.time(); changed = true end
    end
  end
end
if changed then
  local f = io.open(idx_file, "w")
  if f then f:write(json.encode(idx)); f:close(); print("updated " .. #idx.tests) end
end

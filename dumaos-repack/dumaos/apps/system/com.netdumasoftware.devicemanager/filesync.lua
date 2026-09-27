-- DPI-RPC-SHIM: shadows /dumaos/api/libs/filesync.lua inside the app
-- directory. exec.lua's custom loader looks in the app directory first and
-- loads the chunk with the app env (where rpc is the dispatcher table), so
-- this chunk can register the DPI/device handlers that dpi.lua and
-- devices.lua only define as on_* globals. The RPC dispatcher invokes
-- handlers with no arguments and without setting g_handle.conn, so the
-- handlers that reply via g_handle.conn:reply() are wrapped: a stub conn
-- captures the reply and it is returned to the dispatcher instead.
local real = assert(loadfile('/dumaos/api/libs/filesync.lua'))
if setfenv then setfenv(real, getfenv and getfenv(1) or _G) end
local t = real()

if type(rpc) == 'table' then
  local missing = {
    get_catmark = 'on_get_catmark',
    get_appmark = 'on_get_appmark',
    get_devlist = 'on_get_devlist',
    update_device_name_and_type = 'on_update_device_name_and_type',
  }
  local env = getfenv and getfenv(1) or _G
  for m, gname in pairs(missing) do
    if rawget(rpc, m) == nil then
      rawset(rpc, m, function(params, conn, ...)
        local gh = rawget(env, 'g_handle') or (_G and rawget(_G, 'g_handle'))
        local captured
        local fake = {
          reply = function(self, p, res) captured = res end,
          call = function(self, ...) return nil, 'shim-no-conn' end,
        }
        local oldconn
        if gh then oldconn = rawget(gh, 'conn'); gh.conn = fake end
        local r1, r2
        local f = rawget(env, gname) or (_G and rawget(_G, gname))
        if f then r1, r2 = f(params, conn, ...) end
        if gh then gh.conn = oldconn end
        if captured ~= nil then
          if type(captured) == 'table' and captured.result ~= nil then
            return captured.result
          end
          return captured
        end
        return r1, r2
      end)
    end
  end
end

return t

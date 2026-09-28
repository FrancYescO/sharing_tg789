local ubus = require "ubus"
local uloop = require "uloop"
uloop.init()
local u = ubus.connect()
assert(u, "no ubus")

local PROC = "/proc/net/nf_conntrack"

local PAPP2APP = {
    [2574] = 124
}

local function promote()
    local f = io.open(PROC, "r")
    if not f then return end
    local batch = {}
    for line in f:lines() do
        local mark = tonumber(line:match("mark=(%d+)"))
        if mark and math.floor(mark / 16384) % 512 == 510 then
            local p = mark % 16384
            local app = PAPP2APP[p]
            if app then
                local nm = mark + (app - 510) * 16384
                local proto = line:match("^%w+%s+%d+%s+(%a+)")
                local osrc, odst, osport, odport
                for k, v in line:gmatch("(%w+)=(%S+)") do
                    if k == "src" and not osrc then osrc = v
                    elseif k == "dst" and not odst then odst = v
                    elseif k == "sport" and not osport then osport = v
                    elseif k == "dport" and not odport then odport = v
                    end
                end
                if proto and osrc and odst and osport and odport and #batch < 40 then
                    local cmd = "conntrack -U -p " .. proto .. " --src " .. osrc .. " --dst " .. odst ..
                        " --sport " .. osport .. " --dport " .. odport .. " --mark " .. nm
                    if proto == "tcp" then cmd = cmd .. " --state ESTABLISHED" end
                    batch[#batch+1] = cmd
                end
            end
        end
    end
    f:close()
    if #batch > 0 then
        os.execute("( " .. table.concat(batch, "; ") .. " ) >/dev/null 2>&1 &")
    end
end

local function parse_conntrack()
    local out = {}
    local f = io.open(PROC, "r")
    if not f then return out end
    for line in f:lines() do
        local l3name, l3num, l4name, l4num, timeout = line:match("^(%w+)%s+(%d+)%s+(%w+)%s+(%d+)%s+([0-9%.]+)")
        if l3name and (l3name == "ipv4" or l3name == "ipv6") then
            local srcs, dsts, sports, dports, pkts, byts = {}, {}, {}, {}, {}, {}
            local mark = 0
            for k, v in line:gmatch("(%w+)=(%S+)") do
                if k == "src" then srcs[#srcs+1] = v
                elseif k == "dst" then dsts[#dsts+1] = v
                elseif k == "sport" then sports[#sports+1] = tonumber(v) or 0
                elseif k == "dport" then dports[#dports+1] = tonumber(v) or 0
                elseif k == "packets" then pkts[#pkts+1] = tonumber(v) or 0
                elseif k == "bytes" then byts[#byts+1] = tonumber(v) or 0
                elseif k == "mark" then mark = tonumber(v) or 0
                end
            end
            if srcs[1] and dsts[1] then
                out[#out+1] = {
                    l3proto = tonumber(l3num),
                    osrc = srcs[1], odst = dsts[1],
                    rsrc = srcs[2] or "", rdst = dsts[2] or "",
                    l4proto = tonumber(l4num) or 0,
                    osport = sports[1] or 0, odport = dports[1] or 0,
                    rsport = sports[2] or 0, rdport = dports[2] or 0,
                    cmark = mark,
                    timeout = math.floor(tonumber(timeout) or 0),
                    obytes = byts[1] or 0, rbytes = byts[2] or 0,
                    opackets = pkts[1] or 0, rpackets = pkts[2] or 0
                }
            end
        end
    end
    f:close()
    return out
end

local function local_networks()
    local lnets = {}
    local f = io.popen("ip -o addr show 2>/dev/null")
    if not f then return lnets end
    for line in f:lines() do
        local ifname, fam, addr, bits = line:match(":%s+(%S+)%s+(inet6?)%s+(%S+)/(%d+)")
        if ifname and addr and ifname:match("^br%-lan") then
            if fam == "inet" then
                local b = tonumber(bits)
                if b then
                    local octets = {}
                    local v = b
                    for i = 1, 4 do
                        local n = math.min(v, 8)
                        octets[i] = 256 - 2^(8 - n)
                        v = v - 8
                        if v < 0 then v = 0 end
                    end
                    lnets[#lnets+1] = { ipv4 = addr, mask = table.concat(octets, ".") }
                end
            else
                lnets[#lnets+1] = { ipv6 = addr, mask = "ffff:ffff:ffff:ffff::" }
            end
        end
    end
    f:close()
    return lnets
end

local cttable = parse_conntrack()

local function in_lan(ip)
    if ip:match("^224%.") or ip:match("^239%.") then return true end
    return false
end

local function is_local(ip)
    if ip == "192.168.1.1" or ip == "192.168.133.69" then return true end
    return false
end

local function uptime_ms()
    local f = io.open("/proc/uptime", "r")
    if not f then return os.time() % 2000000 * 1000 end
    local up = f:read("*l"):match("^[%d%.]+")
    f:close()
    return math.floor((tonumber(up) or 0) * 1000)
end

local function filter_connections()
    local conns = {}
    local lnets = {}
    local f = io.popen("ip -o -4 addr show br-lan 2>/dev/null")
    if f then
        for line in f:lines() do
            local net = line:match("(%d+%.%d+%.%d+%.%d+)/(%d+)")
            if net then lnets[#lnets+1] = { net:match("^(%d+%.%d+%.%d+)"), tonumber(line:match("/(%d+)")) } end
        end
        f:close()
    end
    local function local_src(ip)
        if in_lan(ip) then return true end
        for _, n in ipairs(lnets) do
            if n[2] == 24 and ip:match("^" .. n[1] .. "%.") then return true end
        end
        return false
    end
    for _, e in ipairs(cttable) do
        if e.l3proto == 2 and local_src(e.osrc) and not is_local(e.osrc) then
            conns[#conns+1] = {
                sip4 = e.osrc, dip4 = e.odst,
                sport = e.osport, dport = e.odport,
                l4proto = e.l4proto, l3proto = 2,
                class = e.cmark,
                timeout = e.timeout,
                spackets = e.opackets, dpackets = e.rpackets,
                sbytes = e.obytes, dbytes = e.rbytes
            }
        end
    end
    return conns
end

local obj = {
    ["com.netdumasoftware.ctwatch"] = {
        gettable = {
            function(req, msg)
                u:reply(req, { cttable = cttable })
            end,
            {}
        },
        get_local_networks = {
            function(req, msg)
                u:reply(req, { lnets = local_networks() })
            end,
            {}
        },
        rpc = {
            function(req, msg)
                if msg and msg.proc == "filter_connections" then
                    u:reply(req, { errorCode = 0, result = { { timestamp = uptime_ms(), connections = filter_connections() } } })
                elseif msg and (msg.proc == "get_cmark_mask" or msg.proc == "get_devmark") then
                    u:reply(req, { errorCode = 0, result = { 14, 8372224 } })
                else
                    u:reply(req, { errorCode = 1 })
                end
            end,
            { id = ubus.INT32, proc = ubus.STRING }
        }
    }
}

local ok, err = pcall(function() u:add(obj) end)
print("add:", ok, err)
io.flush()
if not ok then
    error("failed to register com.netdumasoftware.ctwatch: " .. tostring(err))
end

local tick
tick = uloop.timer(function()
    promote()
    cttable = parse_conntrack()
    tick:set(500)
end)
tick:set(500)

uloop.run()

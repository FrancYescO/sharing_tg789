# Recovering the AutoDPI database from the Netduma cloud

How v2.0-33/34 of `dumaos-repack` got the real AutoDPI signature database
(`nddpidb`) for the DumaOS 3.3.90 repack on Telstra/AGTEF firmware, where
`update.netduma.com` is dead but `api.netduma.com` is still alive.

## 1. What the stock stub looks like

`/dumaos/data/dpiclass/nddpidb` on the stock repack is a ~1.6 MB stub:
dpiclass loads it but every flow gets class 1023 (sentinel = Uncategorised),
so the Network Monitor shows nothing but "Uncategorised".

## 2. Finding the update endpoint

- `dumaos/api/libs/dumapi.lua` (bytecode) contains the cloud client:
  - base URLs `http://192.168.2.4:9000/%s` (dev) and `https://api.netduma.com/%s`
  - token endpoint `/api/v1/login/access-token` (form encoded)
  - update URL `api/v1/cloud/url/%s` where `%s` is the update type
    (`dpi` works; `rapps`/`dumaweb`/... are valid types too, "No suitable
    updates" for this model/version)
  - hardcoded device credentials: username `r2_user`,
    password `UeKVSvdR2dXb92Bppp46hJhF2bg8tX8p`
- Token (JWT, no special perms needed for the deprecated url endpoint):

```sh
curl -s -X POST https://api.netduma.com/api/v1/login/access-token \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=&username=r2_user&password=UeKVSvdR2dXb92Bppp46hJhF2bg8tX8p&client_id&client_secret'
```

- Update URL request (note: `timestamp` MUST be a JSON string):

```sh
curl -s -X POST https://api.netduma.com/api/v1/cloud/url/dpi \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d '{"model":"XR500","dumaos_version":"3.3.535","decoder":"openssl-v1-1-1",
       "vendor":"NETGEAR","flavour":"netduma","timestamp":"1759000000",
       "mac":"C0:3F:0E:11:22:33"}'
```

Known DPI update IDs: XR500=415 (2025-05-06), XR700=243 (2024-09-24),
R2=493, R3=606. URL pattern:

```
http://api.netduma.com/file/cloud_updates/dpi/<id:08d>/NETDUMA_V1/gpg/cloud-<id:08d>-dpi-NETDUMA_V1-gpg.cloud
```

## 3. Unpacking a `.cloud` file

The `.cloud` file is PGP symmetric, **double wrapped**, passphrase = the AES
key embedded in `devicemanager/dpi.lua`:

```
!8Dn@%@\^\Y8@}T2(
```

The signature verifies against the firmware's own
`/dumaos/keys/cloud.asc` (RSA 9A37A634FBEA2CEB719C3D166FE4CCC06A57B288):

```sh
gpg --batch --pinentry-mode loopback --passphrase '!8Dn@%@^\Y8@}T2(' --decrypt in.cloud \
 | gpg --batch --pinentry-mode loopback --passphrase '!8Dn@%@^\Y8@}T2(' --decrypt > update.tar
tar tf update.tar
```

Contents (update 243/415): `dumaos/data/dpiclass/nddpidb`,
`usr/bin/dpiclass`, `usr/lib/detectlist.xor`,
`www/json/_services_.json`, `www/json/categories.json`,
`www/json/qos_categories.json`.

## 3b. The model matters: this router is DJA0231 (ARM!)

The modem reports `model=DJA0231 odm=TECHNICOLOR vendor=TELSTRA sdk=BROADCOM
version=3.3.90` in `/dumaossystem` - DJA0231 is an **ARM** platform, so the
DJA0231 cloud updates are ARM EABI5 and run natively (the XR500/XR700 gpg
flavours are uClibc-ARM too; the earlier "glibc vs uClibc" theory was wrong).

`dumaos/api/libs/dpi.lua` (the R-App, not dumapi) holds the **native**
resource URL and the AES key:

```
http://netdumasoftware.com/dumaos/resources/dpi/DJA0231/openssl-v1-1-1/cloud-v3.tar
```

which serves a tar of `payload` (openssl `enc -aes-256-cbc`, same key,
`Salted__` header - NOT gpg) + `payload.sig`: contains `usr/lib/libadpi.so`,
`usr/lib/libdpipacketprocessors.so`, `usr/lib/detectlist.xor`,
`www/json/{_services_,categories,qos_categories}.json` (ARM ELF, no DB).

Querying `api/v1/cloud/url/dpi` with `{"model":"DJA0231",
"dumaos_version":"3.3.90|3.3.535","vendor":"TELSTRA|NETGEAR",
"decoder":"openssl-v1-1-1","flavour":"PRODUCTION","timestamp":"<ts>"}`
returns **DPI update 341** as `.../dpi/0000000341/NETDUMA_V1/openssl111/
cloud-0000000341-dpi-NETDUMA_V1-openssl111.cloud` = a plain tar of
payload+payload.sig; decrypt the payload with the **same** key via
`openssl enc -d -aes-256-cbc` (the gpg double-wrap only applies to the
`gpg/` flavour URLs).

## 4. The real fix: DPI update 341 (v2.0-36)

The stock 3.3.90 stack (34 KB libadpi + 1.6 MB stub DB) **never loads any
cloud DB**: libadpi logs `Failed to load '//dumaos/data/dpiclass/nddpidb':
Success` (and `sanity failed -4` per packet) for the stub AND for 243/415.
The load is triggered by devicemanager binding to the `dpiclass` ubus object;
manual dpiclass runs never load (no "Loading adpi database" log), which made
earlier "manual load OK" tests misleading.

Update **341** is a full DPI stack for DJA0231 3.3.90, not just a DB:
`libadpi.so` 566 KB (new `ad3141ba` format engine, openssl bundled),
`dpiclass.bin` 341 (runs `/dumaos/ctwatch-replace.sh` on boot),
**`/dumaos/ctwatch`** (conntrack watcher = the 341-era classification
daemon, started by the update's `/etc/init.d/dumaos` via `ctwatch -d`,
registers the `com.netdumasoftware.ctwatch` ubus object),
`nddpidb` 447 KB (md5 f8f209cb185101546fdfa2a2cb1a42e0), `detectlist.xor`,
new `/etc/init.d/dumaos` (adds INITD_STARTUP + TELSTRA boot sleep),
`81-dumaos` hotplug (firewall_reloaded.sh locking), `fq-codel-add-filter*`,
`com.netdumasoftware.qos/main.lua` and the 3 json maps.

v2.0-36 ships all of it (repack keeps its own `/usr/bin/dpiclass` wrapper -
the tar's `/usr/bin/dpiclass` is the ELF and would lose the LD_PRELOAD -
plus our init.d TZ/nss/fcctl patches on top of the 341 init.d).
After install + reboot: no `Failed to load`, no `sanity failed`, ctwatch
up, conntrack flows get real marks (0x9800 = class 2 Media, mask
`0x7fc000 >> 14`).

## 5. Verifying classification

```sh
iptables -m conntrack -D -L 2>/dev/null | head   # marks non-sentinel (not 1023<<14)
ubus call com.netdumasoftware.devicemanager rpc '{"proc":"get_cmark_mask"}'
# -> {"result":[14,8372224]}  = shift 14, mask 0x7fc000
# category id = (mark & 0x7fc000) >> 14, resolved via /www/json/_services_.json
```

## 6. Network Monitor RPCs: the filesync shadow (v2.0-41)

Network Monitor's `get_catmark`/`get_appmark` RPCs answered
`ERROR: Nonexistant remote procedure` even though `dpi.lua` defines the
handlers: in this build `dpi.lua`/`devices.lua` only do
`SETGLOBAL on_get_catmark` (etc.) and never `rpc.get_catmark = ...`
(`grep SETTABLE dpi.asm` shows only flush_cloud/try_cloud_update/
get_cmark_mask/get_devmark/get_dpi_settings/set_dpi_settings), while the
event.lua dispatcher looks the proc up in the app `env.rpc` table with no
`on_*` fallback. `get_devlist`/`update_device_name_and_type` (devices.lua)
were missing the same way.

The registration cannot live in `/dumaos/api/libs/filesync.lua`: exec.lua
loads framework libs with the plain `_G` env, where the global `rpc` is the
caller *function*, not the dispatcher table. exec.lua's custom
package.loader (exec.asm @120-137) searches the **app directory first** and
`setfenv`s the chunk to the app env, so shipping a shadow copy at
`/dumaos/apps/system/com.netdumasoftware.devicemanager/filesync.lua` runs
our registration code with `rpc` = the dispatcher table (dpi.lua requires
`filesync`, so the shadow is loaded during app init). The shadow
`loadfile`s the real lib, `setfenv`s it back to the same env and returns it.

Dispatcher quirks the wrapper works around (event.asm `<?:370,434>`):
handlers are invoked with **zero arguments** (`unpack(numeric params)`) and
`g_handle.conn` is nil on the RPC path, but `on_get_catmark`/`on_get_appmark`
ignore their args and reply through `g_handle.conn:reply()`. The wrapper
installs a stub conn that captures the reply and returns it to the
dispatcher, and forwards direct return values as-is (get_devlist style).

Verified after reboot: `ubus rpc get_catmark` ->
`{"result":[{mask:125829120, lshift:23, pfield:pappcat, cfield:cappcat, max:15}]}`,
`get_appmark` -> mask 8372224/shift 14, `get_devlist` -> device list; app
stays up (earlier wrapper iterations that left `g_handle.conn` nil crashed
the app with "attempt to index field 'conn'" + 42 pending calls).
postinst restarts devicemanager after install.

Side findings: `forward_dpi_mark` chain exists but is not hooked into
FORWARD (`except_nd_forward_mangle` empty, nothing populates it) - relevant
if category bits stay 510; `get_devtypemark`/`dhcp_event` have no `on_*`
handler anywhere, so they stay unregistered.

## 7. Network Monitor app labels: the ctwatch Lua shim (v2.0-43)

Even with dpiclass DNS-matching working, Network Monitor showed every flow
as "Uncategorized". Root causes, in order of discovery:

1. **ctwatch never reads connmarks on the AGTEF kernel.** Both the 341 and
   the stock AGTEF ctwatch build report `cmark=0` for every entry even when
   the kernel conntrack entries carry the DPI marks (verified via
   `/proc/net/nf_conntrack` and `conntrack -L`). iptables/NFQUEUE promotion
   cannot fix it either: HW offload bypasses netfilter on established
   flows and NFQUEUE verdicts do not re-enter the mangle chain.
2. **The UI decodes an appid, not a category.** `networkmonitor.js` computes
   `appid = (class & mask) >> shift` with the mask/shift fetched over RPC
   `get_cmark_mask` -> `[14, 8372224]`, then looks the app up by appid in
   `_services_.json` (YouTube=124/Media, Google=126/Web (General)); the
   category label comes from the app entry. The UI called `get_cmark_mask`
   on the ctwatch rpc and my first shim didn't answer it -> mask/shift null
   -> everything Uncategorized. The `class` field of `filter_connections`
   must therefore be the **raw connmark**, and `get_cmark_mask`/`get_devmark`
   must answer `[14, 8372224]`.
3. **dpiclass leaves appid at 510** (unclassified) on this kernel; only the
   DNS-derived pappid (bits 0-13) is set, and it is a domain-table id from
   the encrypted nddpidb (Google domains = 2574), not a services.json appid.

Fix: `dumaos/ctwatch-shim.lua`, a procd service (`etc/init.d/ctwatch-shim`,
START=98, respawn retry 0) that owns `com.netdumasoftware.ctwatch` on ubus
(stock ctwatch is disabled in postinst and `etc/init.d/dumaos` starts the
shim instead of `ctwatch -d`; ubusd is restarted by dumaos, so the init
kills the old shim instance first). The shim:

- serves `gettable`, `get_local_networks` and `rpc{filter_connections,
  get_cmark_mask,get_devmark}` parsed from `/proc/net/nf_conntrack`;
  `timestamp` must be **uptime ms** (the UI skips int32-overflowed values);
- every 0.5s rewrites `appid` bits of flows whose pappid is in `PAPP2APP`
  (currently `{2574: 124}` = Google domains -> YouTube/Media) using
  `conntrack -U -p <proto> --src ... --mark ...`: this conntrack build has
  no `-R`/batch `-f` support ("unsupported protocol"), udp `-U` must NOT
  get `--state`, tcp needs `--state ESTABLISHED`;
- batches are backgrounded (`( cmd; cmd ) >/dev/null 2>&1 &`) because
  `io.popen`/foreground `os.execute` blocks the uloop and the UI's 1s
  polls time out; the uloop timer only re-arms from inside its callback;
- the UI aggregates byte **deltas** per app, so promotion has to run fast
  (0.5s) or early bytes are attributed to appid 510.

Verified: `filter_connections` now returns raw marks; UI shows Media for
phone traffic (appid 124 via get_cmark_mask decode). `filter_connections`
schema: `{result:[{timestamp, connections:[{sip4,dip4,sport,dport,l4proto,
l3proto,class,timeout,spackets,dpackets,sbytes,dbytes}]}]}`.

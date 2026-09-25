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

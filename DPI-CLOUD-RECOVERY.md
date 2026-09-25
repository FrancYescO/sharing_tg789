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
`www/json/qos_categories.json`. The binaries are uClibc (XR500) and don't
run on the glibc modem - ship the data files only, keep our glibc dpiclass.

The DB header (`ad3141ba 0100 0000 0000 0003 ...`) is identical between the
2023 stub and the 2024/2025 clouds: format unchanged, drop-in replacement.

## 4. Which DB to ship

- **415 (7.5 MB)** loads fine on a PC and on the modem with ~100 MB free,
  but on a loaded 512 MB modem dpiclass.bin refuses it
  (`Failed to load '//dumaos/data/dpiclass/nddpidb': Broken pipe`) - it is
  a memory-pressure issue, not signatures/format.
- **243 (3.4 MB, Sep 2024)** loads even under pressure and classifies
  traffic (connmark class `cat << 14`, e.g. 0x8000 = 2 = Media, NETFLIX
  recognised in the dpiclass log). This is what v2.0-34 ships.
- Reboot after upgrading the DB: killing dpiclass orphans NFQUEUE 10.

## 5. Verifying classification

```sh
iptables -m conntrack -D -L 2>/dev/null | head   # marks non-sentinel (not 1023<<14)
ubus call com.netdumasoftware.devicemanager rpc '{"proc":"get_cmark_mask"}'
# -> {"result":[14,8372224]}  = shift 14, mask 0x7fc000
# category id = (mark & 0x7fc000) >> 14, resolved via /www/json/_services_.json
```

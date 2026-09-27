# Component provenance

This file records the source families used by the port. It is not a license or
a substitute for verifying redistribution rights.

| Component | Source/version | Local changes |
| --- | --- | --- |
| DumaOS core, R-Apps, `ndhttpd`, ubus ABI | Telstra DJA0231 `vcnt-a_20.3.c.0501-MR22.1-RA`, DumaOS 3.3.90 | AGTEF guards, portal proxy, timezone and runtime compatibility |
| DPI engine/database | DJA0231 cloud DPI update 341 | NFQUEUE verdict shim, AGTEF QoS hooks |
| Default 3.0 theme | Netgear XR500 DumaOS 3.3.535 family | 3.3.90-compatible markup and selection logic |
| OpenSSL command/library set | OpenSSL 1.1.1w ARM build | Private DumaOS-only path |
| `act_connmark` module | GUI_ipk kernel 4.1.52 ARMv7 build | Installed by `setup.sh` when required |
| Packaging and compatibility scripts | This repository | Shell/Python source in the branch |

The authoritative source firmware mirror is the branch
`vcnt-a_20.3.c.0501-MR22.1-RA` in `FrancYescO/tch_firmware_extracted`.

Release procedure:

1. record changes to any vendor-derived component in this table;
2. generate a sorted SHA-256 manifest of the release payload;
3. build twice with the same `SOURCE_DATE_EPOCH` and compare bytes;
4. publish only the CI-built asset and its checksum;
5. do not commit generated IPKs or scratch extraction files.

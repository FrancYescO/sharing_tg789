# dumaos-repack

Repack of the DumaOS UI/QoS stack (extracted from a DJA0231 Telstra dump)
as an IPK that can be installed on other Technicolor ARM (arm_cortex-a9)
closed firmware, e.g. AGTEF (TG789vac v2, VBNTJ, kernel 4.1.52).

The IPK contains the DumaOS R-Apps (`/dumaos`), the web UI (`/www`), a
standalone `uhttpd` with the lua handler and the DumaOS helpers
(`dpiclass`, `geoip`, `trie`, `sqlite3`, lua modules for posix/ssl...).

## Requirements

The firmware must provide (AGTEF does):

- `lua` 5.1 + `liblua.so.5.1`, lua `ubus`/`socket`/`mime` modules
- `ubus`/`uci`/`procd`, `ipset`, `tc`, `iptables`
- `libssl/libcrypto` 1.0.0, `libpcap`, `libmnl`, `libnfnetlink`,
  `libnetfilter_queue/conntrack`
- `libjson-c` (see compat note below)

Provided by the [GUI_ipk](https://github.com/FrancYescO/GUI_ipk) feed:

- `libedit`, `libncurses`, `terminfo`
Kernel (AGTEF Damson VBNTJ 4.1.52): `ifb`, `sch_ingress`, `cls_u32` and
`act_police` are built into the stock kernel (see stock
`/etc/modules.d/34-ifb` and `70-sched-core`), `xt_connmark`/`xt_mark`/`xt_set`
are shipped as modules. The only missing QoS module is `act_connmark`:
`setup.sh` downloads it from the
[GUI_ipk kmods-4.1.52 artifacts](https://github.com/FrancYescO/GUI_ipk/tree/kmods-4.1.52/artifacts)
(vermagic `4.1.52 SMP preempt mod_unload ARMv7`, verified against the stock
AGTEF modules), checks its SHA-256, installs it into
`/lib/modules/4.1.52/extra/`, runs `depmod` and adds
`/etc/modules.d/99-dumaos-qos`.

## Install

```
opkg install dumaos-repack_1.1-0_all.ipk --force-overwrite
sh setup.sh
```

`setup.sh` installs the feed dependencies, loads the QoS modules, opens
the firewall for the UI and enables the `uhttpd` + `dumaos` services.

DumaOS UI: `http://<router-ip>:81/` (https moved to `8443` so the stock
nginx UI keeps `443`).

## Source firmware / versions

The repacked DumaOS is **3.0.56** ("A7Legit", May 2020, from the DJA0231
Telstra dumps `vcnt-a_ACR-13-*`/`vbnt-v_ACR-14-*`). Newer DumaOS exists in
`tch_firmware_extracted` (all ARM/BCM63136, same platform):

| branch | DumaOS | date |
|---|---|---|
| `vcnt-a_20.3.c.0501-MR22.1-RA` | **3.3.90** | Oct 2022 |
| `vcnt-a_20.3.c.0432-MR21.1-RA` | 3.2.126+2 | Feb 2022 |
| `vbnt-v_20.3.c.0389-MR20-RA` | 3.0.370 | Sep 2021 |

Upgrading to MR22 (3.3.90) is the natural next step: it is built for the
new TCH stack, so `dpiclass` there links `libjson-c.so.4` (stock on AGTEF,
the `.so.2` symlink below becomes unnecessary), it ships the missing
`dumaos/setup_done.sh` plus a `dumaos/custom-platforms.sh` platform
abstraction, and `dumaos_status.sh`/`rapp_status.sh` helpers. Caveats: its
lua `ssl.so` needs `libssl/libcrypto 1.1` (bundle from the same firmware,
AGTEF has 1.0.0) and `dpiclass` adds a `libadpi.so` DPI dependency.

Note: the pending `MST TG789vac 16.2.7064.2201002.rbi` is board VANT-D
(MIPS) with no known OSCK key: it is not a usable DumaOS source for AGTEF.

## Notes / TODO

- `usr/lib/libjson-c.so.2` is a symlink to the stock `libjson-c.so.4`:
  `dpiclass`/`geoip` were linked against json-c 0.11. It works via symbol
  compatibility, but a real `libjson-c.so.2` build in the GUI_ipk feed
  would be safer.
- Start path: on firmwares with `procd` the `dumaos` init script uses the
  procd path; the legacy non-procd path still references DJA0231/Netgear
  scripts (`intercept.sh`, `ngcompat`, `net-wall`) that are not needed here.
- `etc/firewallExt/M1_NetDuma_99.user` is a no-op on TCH (no firewallExt);
  the autoadmin firewall hooks are re-applied via ubus after a firewall
  restart, so a reload hook may need to be added to `/etc/hotplug.d/firewall`.
- A tch-nginx-gui card is included: `www/cards/015_dumaos.lp` (status +
  link to the DumaOS UI on port 81), backed by the
  `usr/share/transformer/mappings/rpc/dumaos.map` rpc domain
  (`rpc.dumaos.status` / `rpc.dumaos.enabled`) and translated in
  `www/lang/it-it/webui-dumaos.po`.
- The `/dumaossystem` profile is still DJA0231/TELSTRA (BCM63136, the
  closest ARM Technicolor platform and the only working code path in the
  init scripts). The `custom-platforms.sh` abstraction shipped by DumaOS
  3.3.90 (see above) is the proper way to add an AGTEF profile.

## CI

`.github/workflows/build-dumaos-repack-ipk.yml` builds the IPK
(`./ipkg-build.sh ./dumaos-repack ./dist`) on every push/PR and publishes
a GitHub release when a `dumaos-repack-v*` tag is pushed.

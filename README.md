# dumaos-repack

Repack of the DumaOS UI/QoS stack (extracted from a DJA0231 Telstra dump)
as an IPK that can be installed on other Technicolor ARM (arm_cortex-a9)
closed firmware, e.g. AGTEF (TG789vac v2, VBNTJ, kernel 4.1.52).

The IPK contains the DumaOS R-Apps (`/dumaos`), the web UI (`/www`), the
standalone `ndhttpd` web server with its lua handler (`ndhttpd_lua.so`)
and the DumaOS helpers (`dpiclass`, `geoip`, `trie`, `sqlite3`, lua
modules for posix/ssl...).

## Requirements

The firmware must provide (AGTEF does):

- `lua` 5.1 + `liblua.so.5.1`, lua `ubus`/`socket`/`mime` modules
- `ubus`/`uci`/`procd`, `ipset`, `tc`, `iptables`
- `libssl/libcrypto` 1.0.0, `libpcap`, `libmnl`, `libnfnetlink`,
  `libnetfilter_queue/conntrack`
- `libjson-c.so.4` (stock json-c 0.13, used directly by `dpiclass`/`geoip`)

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
opkg install dumaos-repack_2.0-1_all.ipk --force-overwrite
sh setup.sh
```

`setup.sh` installs the feed dependencies, loads the QoS modules, opens
the firewall for the UI and enables the `ndhttpd` + `dumaos` services.

DumaOS UI: `http://<router-ip>:81/` (the stock nginx UI keeps `80`/`443`:
3.3.90 `ndhttpd` is patched to bind `0.0.0.0:81` instead of the
loopback-only DJA0231 bind, and it does not listen on `443` at all).

## Uninstall

```
opkg remove dumaos-repack
```

`prerm` stops and disables `ndhttpd`/`dumaos`; `postrm` then removes the
`act_connmark` kernel module and `/etc/modules.d/99-dumaos-qos` installed
by `setup.sh`, the `dumaos_ui` firewall rule (with a firewall reload) and
the `dumaos`/`ndhttpd`/`ndproxy` UCI configs. Reload nginx from the mod
GUI (or `service nginx reload`) to drop the DumaOS card.

## Source firmware / versions

The repacked DumaOS is **3.3.90** (Oct 2022, from the DJA0231 Telstra
dump `vcnt-a_20.3.c.0501-MR22.1-RA`, board `vcnt-a`/BCM63136 - same SoC
class as AGTEF). Previous repacks were based on 3.0.56
(`vcnt-a_ACR-13-*`/`vbnt-v_ACR-14-*`):

| branch | DumaOS | date |
|---|---|---|
| `vcnt-a_20.3.c.0501-MR22.1-RA` | **3.3.90** (current) | Oct 2022 |
| `vcnt-a_20.3.c.0432-MR21.1-RA` | 3.2.126+2 | Feb 2022 |
| `vbnt-v_20.3.c.0389-MR20-RA` | 3.0.370 | Sep 2021 |

3.3.90 is built for the new TCH stack: `dpiclass` links `libjson-c.so.4`
(stock on AGTEF, no more `.so.2` symlink), `ndhttpd` replaces `uhttpd`,
and it ships `setup_done.sh` + `custom-platforms.sh` (platform
abstraction) + `dumaos_status.sh`/`rapp_status.sh`. Bundled because AGTEF
does not ship them: `ndhttpd`/`ndhttpd_lua.so`, `libssl.so.1.1` /
`libcrypto.so.1.1` (the 3.3.90 lua `ssl`/`crypto` modules need 1.1),
`libadpi.so` (DPI), `libahc.so`, `libmisc.so`, `libtrie.so`, `luac5.1`.

Note: the pending `MST TG789vac 16.2.7064.2201002.rbi` is board VANT-D
(MIPS) with no known OSCK key: it is not a usable DumaOS source for AGTEF.

## Notes / TODO

- 3.3.90 patches for AGTEF: `ndhttpd` init binds `0.0.0.0:81` (the
  DJA0231 original binds loopback only and fronted it with nginx); the
  TELSTRA init branches got guards for missing platform bits
  (`/usr/bin/fcctl`, `/proc/sys/net/nss/super`); `ts_odm_services` only
  touches `/etc/config/web`+nginx if a `/frontend/` entry exists (no-op
  on stock AGTEF/tch-nginx-gui).
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
  closest ARM Technicolor platform and the only fully working code path
  in the init scripts); 3.3.90 `custom-platforms.sh` makes it easier to
  add a real AGTEF profile later.

## CI

`.github/workflows/build-dumaos-repack-ipk.yml` builds the IPK
(`./ipkg-build.sh ./dumaos-repack ./dist`) on every push/PR and publishes
a GitHub release when a `dumaos-repack-v*` tag is pushed.

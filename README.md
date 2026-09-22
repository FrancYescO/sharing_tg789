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
- `kmod-ifb`, `kmod-sched-core`, `kmod-sched-connmark` (DumaOS QoS needs
  `ifb`/`sch_ingress`/`cls_u32`/`act_police`; on AGTEF the stock kernel
  only ships `sch_qos_tch`, so the modules must match kernel 4.1.52)

## Install

```
opkg install dumaos-repack_1.1-0_all.ipk --force-overwrite
sh setup.sh
```

`setup.sh` installs the feed dependencies, loads the QoS modules, opens
the firewall for the UI and enables the `uhttpd` + `dumaos` services.

DumaOS UI: `http://<router-ip>:81/` (https moved to `8443` so the stock
nginx UI keeps `443`).

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
- A per-model `/dumaossystem` profile (currently DJA0231/TELSTRA) is still TODO.

## CI

`.github/workflows/build-dumaos-repack-ipk.yml` builds the IPK
(`./ipkg-build.sh ./dumaos-repack ./dist`) on every push/PR and publishes
a GitHub release when a `dumaos-repack-v*` tag is pushed.

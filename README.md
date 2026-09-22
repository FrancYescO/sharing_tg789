# sharing_tg789

Collection of IPK packages and post-install scripts for **Technicolor
(TCH) closed-firmware routers** (TG789vac v2 / AGTEF / VBNTJ, DJA0231,
arm_cortex-a9 / brcm63xx-tch).

These packages are used together with
[tch-nginx-gui](https://github.com/Ansuel/tch-nginx-gui), the community
web interface for TCH closed-firmware routers (some branches ship
modGUI modules that plug directly into it).

The repository is organized **one branch per package**: each branch is a
self-contained "what to copy on the router" tree, usually with the IPK
files, their dependencies, a `setup.sh` and a `remove.sh`.

## Branches

| Branch | What it contains |
|---|---|
| `dumaos-repack` | DumaOS UI/QoS stack (from a DJA0231 Telstra dump) repacked as an IPK for other TCH firmware (AGTEF). See its own README. |
| `modgui-vpn` | Repack of the VPN card extracted from the TG799VAC-XTREME-17.2-MINT firmware ([ILPUNTOTECNICO thread](https://www.ilpuntotecnico.com/forum/index.php/topic,81299.0.html)), as a modGUI module for tch-nginx-gui, built into `modgui-vpn_*.ipk` with GitHub Actions releases. |
| `aria2` | aria2 1.34 IPK + `libstdcpp` dependency, `setup.sh`/`remove.sh`. |
| `aria2-xtream` | modGUI module wrapping aria2 for the TG789vac Xtream 35b. |
| `transmission` | transmission-daemon/remote 2.93 IPKs + deps (libevent2, miniupnpc, natpmp, ca-bundle) and config. |
| `transmission-xtream` | modGUI module wrapping transmission for the TG789vac Xtream 35b. |
| `amule` | aMule 2.3.2 IPK + deps (wxBase, libupnp, ncurses, readline...). |
| `asterisk-gui` | Asterisk web GUI files and config (no IPK, files + `setup.sh`). |
| `strongswan` | strongSwan setup script. |

## Common structure

A typical branch contains:

- `*.ipk` — prebuilt packages (brcm63xx-tch or `all` arch) ready for `opkg install`
- `setup.sh` — post-install script: installs dependencies, configures
  firewall/UCI, creates dirs, enables and starts the services
- `remove.sh` — undo script: stops services and cleans up what `setup.sh` did
- `config` / `*.conf` — default configuration dropped on the router
- `ipkg-build.sh` — (newer branches) builds the source folder into an IPK

Install pattern:

```
opkg install <package>.ipk
sh setup.sh
```

Some packages need dependencies that are not shipped in the branch and
come from external opkg feeds: these are often already configured by
tch-nginx-gui, while others can also be installed without it (`opkg
update` first to make sure the feeds are available).

## Building IPKs and CI

Newer packages are built from a source folder (e.g. `dumaos-repack/`,
`modgui-vpn/`) with `./ipkg-build.sh <folder> ./dist`. GitHub Actions
workflows under `.github/workflows/` build the IPK on every push/PR and
publish a release when a `*-v*` tag is pushed.

## How to use a branch

```
git clone -b <branch> <repo-url>
# copy the branch content to the router (e.g. /tmp or /data)
opkg install *.ipk
sh setup.sh
```

Each package branch is independent: switch branches (or clone with
`-b`) to get the package you need; the `main` branch only documents the
repo.

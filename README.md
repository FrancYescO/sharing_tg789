# DumaOS port for Technicolor AGTEF/VBNTJ

This branch packages the DumaOS 3.3.90 UI and QoS stack from the Telstra
DJA0231 firmware `vcnt-a_20.3.c.0501-MR22.1-RA` for the ARMv7 Technicolor
AGTEF/VBNTJ family running kernel 4.1.52.

It is a platform port, not an architecture-independent data package. The IPK
is therefore marked `arm_cortex-a9` and its pre-install script rejects other
CPU/kernel/ABI combinations.

## Supported target

| Device family | Firmware/kernel | Status |
| --- | --- | --- |
| DGA4130 / VBNTJ / AGTEF | ARMv7, kernel 4.1.52 | Hardware validated |
| DJA0231 / VCNT-A MR22.1 | Source platform | Payload provenance reference |
| Other ARM Technicolor firmware | Any other ABI/kernel | Unsupported unless explicitly validated |
| MIPS Technicolor devices | Any | Unsupported |

The preflight also requires the expected glibc ARM loader, Lua 5.1/json-c 4
ABI and stock ubus files. This prevents accidental installation on devices
that merely share a package manager.

## Installation

Install the release asset matching the package architecture:

```sh
opkg install dumaos-repack_2.0-42_arm_cortex-a9.ipk
```

The interface is served through the authenticated firmware nginx portal:

```text
http://<router-ip>/desktop/
```

Port 81 is loopback-only and is an implementation detail of the reverse
proxy. It must not be exposed by a firewall rule.

## Isolation and rollback

DumaOS-specific `tar`, `openssl`, `wl` and `conntrack` compatibility wrappers,
OpenSSL 1.1 and legacy ncurses/edit libraries live below `/usr/lib/dumaos`.
Only DumaOS services receive their private `PATH` and `LD_LIBRARY_PATH`; the
firmware-global tools and `/etc/ld.so.preload` are not replaced.

DumaOS still requires the MR22 ubus ABI. It is staged below
`/usr/lib/dumaos/platform/mr22` and activated transactionally:

1. copy the actual device stack to `/etc/dumaos-stock-backup/ubus`;
2. stage each replacement beside its target;
3. atomically rename the staged files;
4. run an ubus health check;
5. restore the stock files automatically if validation fails.

The stock stack is restored from `prerm`, while the packaged helper is still
available. A recovery copy is also kept outside the package file list so
`postrm` can retry even after opkg has removed package data.

## Removal

```sh
opkg remove dumaos-repack
```

Removal stops DumaOS, restores and health-checks the stock ubus stack, removes
the reverse proxy/UCI integration and then deletes the backup. If restoration
fails, removal returns an error and retains `/etc/dumaos-stock-backup` for
manual recovery.

## Build and verification

`build_ipk.py` is the single supported builder. It normalizes path order,
timestamps, ownership and modes and emits the old-opkg-compatible gzip/GNU-tar
container used by the target firmware.

```sh
SOURCE_DATE_EPOCH="$(git log -1 --format=%ct)" python3 build_ipk.py
```

CI builds the package twice and requires identical SHA-256 hashes before
publishing it. Generated IPKs are release artifacts and are not committed.

See [PROVENANCE.md](PROVENANCE.md) for component origins and
[TESTING.md](TESTING.md) for the release gates.

## Important operational notes

- The supplied DPI database is update 341. Larger update 415 was rejected by
  the 512 MiB target during testing.
- The `Default 3.0` visual theme comes from the XR500 DumaOS 3.3.535 family,
  adapted to the 3.3.90 UI.
- Telemetry for the retired Netduma cloud is not installed.
- A reboot is recommended after install, upgrade or removal because ubusd and
  netfilter users can remain resident across an on-disk ABI transition.

## Redistribution

This repository contains vendor-derived firmware components. Their inclusion
does not grant additional rights to DumaOS, Telstra, Netduma or Technicolor
material. Maintainers must verify that publication and redistribution are
permitted before creating a public release.

# Release validation

Every release must pass the following gates.

## Static and package checks

- POSIX shell syntax for all maintainer/init/wrapper scripts.
- Exactly one deterministic builder (`build_ipk.py`).
- Two builds from the same commit have the same SHA-256.
- Package architecture is `arm_cortex-a9`.
- No private TLS key or certificate is shipped.
- No package-owned global `tar`, `openssl`, `wl`, `conntrack`, ubus or ubusd.
- No reference adds a DumaOS shim to `/etc/ld.so.preload`.
- Every ELF/script that must execute has an executable mode.

## Rootfs lifecycle checks

Using an extracted supported AGTEF rootfs:

1. run preflight with simulated ARMv7/kernel 4.1.52 values;
2. install and verify the stock ubus backup manifest;
3. verify the private service environment;
4. simulate failure of the ubus health check and verify byte-identical rollback;
5. upgrade from the previous release and confirm migration of old global tools;
6. remove and verify that all stock ubus hashes match the pre-install state;
7. reject installation for wrong CPU, kernel or missing ABI files.

## DGA4130 canary

- Portal login and `/desktop/` reverse proxy.
- WebSocket R-App endpoints and authentication.
- `ubus list`, transformer and the original firmware GUI.
- DumaOS dashboard, device manager and Network Monitor RPCs.
- DPI classification and QoS marks under real traffic.
- Geo-Filter conntrack operations.
- Benchmark, timezone and theme persistence.
- Reboot, upgrade and uninstall/reinstall.
- Confirm port 81 only listens on loopback.

Do not tag a release when install, upgrade or removal has not been exercised on
the hardware canary.

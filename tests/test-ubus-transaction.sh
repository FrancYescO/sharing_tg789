#!/bin/sh
set -eu

repo=$(CDPATH='' cd -- "$(dirname "$0")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT

mkdir -p "$fixture/bin" "$fixture/sbin" "$fixture/lib" \
  "$fixture/usr/lib/lua" "$fixture/usr/lib/dumaos/platform/mr22"

for f in libubox.so libubus.so; do
  printf 'stock-%s\n' "$f" > "$fixture/lib/$f"
  printf 'mr22-%s\n' "$f" > "$fixture/usr/lib/dumaos/platform/mr22/$f"
done
printf 'stock-ubus.so\n' > "$fixture/usr/lib/lua/ubus.so"
printf 'mr22-ubus.so\n' > "$fixture/usr/lib/dumaos/platform/mr22/ubus.so"
printf '#!/bin/sh\nexit 0\n# stock ubus\n' > "$fixture/bin/ubus"
printf '#!/bin/sh\nexit 0\n# stock ubusd\n' > "$fixture/sbin/ubusd"
printf '#!/bin/sh\nexit 0\n# mr22 ubus\n' > "$fixture/usr/lib/dumaos/platform/mr22/ubus"
printf '#!/bin/sh\nexit 0\n# mr22 ubusd\n' > "$fixture/usr/lib/dumaos/platform/mr22/ubusd"
chmod 755 "$fixture/bin/ubus" "$fixture/sbin/ubusd" \
  "$fixture/usr/lib/dumaos/platform/mr22/ubus" \
  "$fixture/usr/lib/dumaos/platform/mr22/ubusd"
cp "$fixture/bin/ubus" "$fixture/sbin/ubus"

find "$fixture/bin" "$fixture/sbin" "$fixture/lib" "$fixture/usr/lib/lua" \
  -type f -exec cksum {} \; | sort > "$fixture/stock.cksum"

DUMAOS_ROOT="$fixture" "$repo/dumaos-repack/usr/lib/dumaos/platform/ubus-stack.sh" activate
grep -q 'mr22-libubus' "$fixture/lib/libubus.so"
test -f "$fixture/etc/dumaos-stock-backup/ubus/.complete"

DUMAOS_ROOT="$fixture" "$repo/dumaos-repack/usr/lib/dumaos/platform/ubus-stack.sh" restore
find "$fixture/bin" "$fixture/sbin" "$fixture/lib" "$fixture/usr/lib/lua" \
  -type f -exec cksum {} \; | sort > "$fixture/restored.cksum"
cmp "$fixture/stock.cksum" "$fixture/restored.cksum"

# A failed activation health check must also put the original bytes back and
# retain the recovery backup.
DUMAOS_ROOT="$fixture" DUMAOS_TEST_HEALTH=fail \
  "$repo/dumaos-repack/usr/lib/dumaos/platform/ubus-stack.sh" activate && exit 1
find "$fixture/bin" "$fixture/sbin" "$fixture/lib" "$fixture/usr/lib/lua" \
  -type f -exec cksum {} \; | sort > "$fixture/rollback.cksum"
cmp "$fixture/stock.cksum" "$fixture/rollback.cksum"
test -f "$fixture/etc/dumaos-stock-backup/ubus/.complete"

echo "ubus transaction tests passed"

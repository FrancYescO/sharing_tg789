#!/bin/sh

# Transactional activation of the MR22 ubus ABI required by DumaOS.
# The package never owns the live firmware paths: stock files are copied from
# the device, replacements are staged beside their targets, and a failed
# health check restores the original stack.

ROOT=${DUMAOS_ROOT:-}
BACKUP_DIR="$ROOT/etc/dumaos-stock-backup/ubus"
LEGACY_BACKUP="$ROOT/etc/dumaos-ubus-stock"
PAYLOAD_DIR="$ROOT/usr/lib/dumaos/platform/mr22"

log() { echo "dumaos-repack: $*" >&2; }
die() { log "$*"; return 1; }

verify_backup() {
  [ -f "$BACKUP_DIR/.complete" ] || return 1
  (cd "$BACKUP_DIR" && sha256sum -c MANIFEST >/dev/null 2>&1)
}

copy_checked() {
  copy_src=$1
  copy_dst=$2
  copy_mode=$3
  [ -s "$copy_src" ] || return 1
  cp -f "$copy_src" "$copy_dst" || return 1
  chmod "$copy_mode" "$copy_dst" || return 1
}

backup_stack() {
  if [ -f "$BACKUP_DIR/.complete" ]; then
    verify_backup || die "existing stock ubus backup failed checksum validation" || return 1
    return 0
  fi
  [ ! -e "$BACKUP_DIR" ] || die "incomplete stock ubus backup already exists at $BACKUP_DIR" || return 1

  tmp="${BACKUP_DIR}.new.$$"
  rm -rf "$tmp"
  mkdir -p "$tmp" || return 1

  # Versions up to 2.0-41 created this external backup before opkg removed
  # their package-owned copies. Reuse it during a package upgrade.
  if [ -s "$LEGACY_BACKUP/ubusd" ]; then
    source_dir=$LEGACY_BACKUP
  else
    source_dir=
  fi

  if [ -n "$source_dir" ]; then
    copy_checked "$source_dir/ubus.so" "$tmp/ubus.so" 644 || return 1
    copy_checked "$source_dir/libubus.so" "$tmp/libubus.so" 644 || return 1
    copy_checked "$source_dir/libubox.so" "$tmp/libubox.so" 644 || return 1
    copy_checked "$source_dir/ubusd" "$tmp/ubusd" 755 || return 1
    copy_checked "$source_dir/ubus" "$tmp/ubus" 755 || return 1
    copy_checked "$source_dir/ubus" "$tmp/sbin-ubus" 755 || return 1
  else
    copy_checked "$ROOT/usr/lib/lua/ubus.so" "$tmp/ubus.so" 644 || return 1
    copy_checked "$ROOT/lib/libubus.so" "$tmp/libubus.so" 644 || return 1
    copy_checked "$ROOT/lib/libubox.so" "$tmp/libubox.so" 644 || return 1
    copy_checked "$ROOT/sbin/ubusd" "$tmp/ubusd" 755 || return 1
    copy_checked "$ROOT/bin/ubus" "$tmp/ubus" 755 || return 1
    copy_checked "$ROOT/sbin/ubus" "$tmp/sbin-ubus" 755 || return 1
  fi

  {
    for f in ubus.so libubus.so libubox.so ubusd ubus sbin-ubus; do
      (cd "$tmp" && sha256sum "$f")
    done
  } > "$tmp/MANIFEST" || return 1
  touch "$tmp/.complete"
  mkdir -p "$(dirname "$BACKUP_DIR")" || return 1
  mv "$tmp" "$BACKUP_DIR" || return 1
  verify_backup || return 1
  cp -f "$0" "$ROOT/etc/dumaos-stock-backup/ubus-stack.sh" || return 1
  chmod 755 "$ROOT/etc/dumaos-stock-backup/ubus-stack.sh" || return 1
  return 0
}

install_one() {
  install_src=$1
  install_dst=$2
  install_mode=$3
  install_tmp="${install_dst}.dumaos-new.$$"
  copy_checked "$install_src" "$install_tmp" "$install_mode" || return 1
  mv -f "$install_tmp" "$install_dst" || return 1
}

health_check() {
  [ -x "$ROOT/bin/ubus" ] || return 1
  [ -x "$ROOT/sbin/ubusd" ] || return 1
  if [ -n "$ROOT" ]; then
    [ "${DUMAOS_TEST_HEALTH:-pass}" != fail ]
  else
    /bin/ubus list >/dev/null 2>&1
  fi
}

activate_stack() {
  for f in ubus.so libubus.so libubox.so ubusd ubus; do
    [ -s "$PAYLOAD_DIR/$f" ] || die "missing MR22 payload: $f" || return 1
  done

  backup_stack || die "could not create a complete stock ubus backup" || return 1

  if ! install_one "$PAYLOAD_DIR/libubox.so" "$ROOT/lib/libubox.so" 644 ||
     ! install_one "$PAYLOAD_DIR/libubus.so" "$ROOT/lib/libubus.so" 644 ||
     ! install_one "$PAYLOAD_DIR/ubus.so" "$ROOT/usr/lib/lua/ubus.so" 644 ||
     ! install_one "$PAYLOAD_DIR/ubusd" "$ROOT/sbin/ubusd" 755 ||
     ! install_one "$PAYLOAD_DIR/ubus" "$ROOT/bin/ubus" 755 ||
     ! install_one "$PAYLOAD_DIR/ubus" "$ROOT/sbin/ubus" 755; then
    log "MR22 ubus activation failed while writing files; restoring firmware stack"
    restore_stack keep || true
    return 1
  fi
  sync

  if ! health_check; then
    log "MR22 ubus health check failed; restoring the firmware stack"
    restore_stack keep || true
    return 1
  fi
  return 0
}

restore_stack() {
  keep=${1:-remove}
  verify_backup || die "stock ubus backup is missing, incomplete or corrupt" || return 1

  install_one "$BACKUP_DIR/libubox.so" "$ROOT/lib/libubox.so" 644 || return 1
  install_one "$BACKUP_DIR/libubus.so" "$ROOT/lib/libubus.so" 644 || return 1
  install_one "$BACKUP_DIR/ubus.so" "$ROOT/usr/lib/lua/ubus.so" 644 || return 1
  install_one "$BACKUP_DIR/ubusd" "$ROOT/sbin/ubusd" 755 || return 1
  install_one "$BACKUP_DIR/ubus" "$ROOT/bin/ubus" 755 || return 1
  install_one "$BACKUP_DIR/sbin-ubus" "$ROOT/sbin/ubus" 755 || return 1
  sync

  health_check || die "restored ubus stack did not pass its health check" || return 1
  [ "$keep" = keep ] || rm -rf "$BACKUP_DIR" "$LEGACY_BACKUP"
  return 0
}

case "${1:-}" in
  backup) backup_stack ;;
  activate) activate_stack ;;
  restore) restore_stack "${2:-remove}" ;;
  health) health_check ;;
  *) echo "usage: $0 {backup|activate|restore|health}" >&2; exit 2 ;;
esac

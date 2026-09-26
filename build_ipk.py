#!/usr/bin/env python3
"""Build the dumaos-repack .ipk: gzip-compressed ustar outer container
(verified against openwrt feed ipks) with GNU-format inner tars."""
import gzip
import io
import os
import tarfile

SRC = "dumaos-repack"
OUT = "dist"

version = next(
    line.split(":", 1)[1].strip()
    for line in open(os.path.join(SRC, "CONTROL", "control"))
    if line.startswith("Version:")
)


def as_root(ti, path=None):
    ti.uid = 0
    ti.gid = 0
    ti.uname = "root"
    ti.gname = "root"
    # git/tar can lose the exec bit on binaries and scripts (a 644 ELF
    # breaks the router, e.g. /sbin/ubus.orig -> "Permission denied"):
    # force +x on anything with ELF magic or a shebang.
    if ti.isreg() and (ti.mode & 0o111) == 0:
        try:
            with open(path or (ti.obj.name if ti.obj else ti.name), "rb") as fh:
                head = fh.read(4)
        except OSError:
            head = b""
        if head[:4] == b"\x7fELF" or head[:2] == b"#!":
            ti.mode |= 0o111
    return ti


def inner_tar(root, skip_top=()):
    buf = io.BytesIO()
    with tarfile.open(fileobj=buf, mode="w:gz", format=tarfile.GNU_FORMAT) as t:
        t.addfile(as_root(t.gettarinfo(root, arcname=".")))
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = sorted(d for d in dirnames if d not in skip_top and d != "__MACOSX")
            rel = os.path.relpath(dirpath, root)
            for d in dirnames:
                dp = os.path.join(dirpath, d)
                arc = "./" + d if rel == "." else os.path.join(".", rel, d)
                t.addfile(as_root(t.gettarinfo(dp, arcname=arc)))
            for name in sorted(filenames):
                if name == ".DS_Store" or name.startswith("._"):
                    continue
                path = os.path.join(dirpath, name)
                arc = "./" + name if rel == "." else os.path.join(".", rel, name)
                ti = as_root(t.gettarinfo(path, arcname=arc), path)
                if ti.isreg():
                    with open(path, "rb") as fh:
                        t.addfile(ti, fh)
                else:
                    t.addfile(ti)
    return buf.getvalue()


data = inner_tar(SRC, skip_top=("CONTROL",))
control = inner_tar(os.path.join(SRC, "CONTROL"))

os.makedirs(OUT, exist_ok=True)
ipk = os.path.join(OUT, f"dumaos-repack_{version}_all.ipk")
# An .ipk is a *gzip-compressed* tar (GNU magic, verified against openwrt
# feed ipks) holding ./debian-binary, ./control.tar.gz and ./data.tar.gz.
# The router's old opkg rejects ustar ("ustar\0" magic) and plain
# uncompressed tars ("Malformed package file"/segfault) -- it needs the
# gzip wrapper and GNU ("ustar  \0") magic, exactly like buildroot's
# `tar cf - ... | gzip -9n`.
outer = io.BytesIO()
with tarfile.open(fileobj=outer, mode="w", format=tarfile.GNU_FORMAT) as t:
    for name, payload in (("./debian-binary", b"2.0\n"),
                          ("./control.tar.gz", control),
                          ("./data.tar.gz", data)):
        ti = tarfile.TarInfo(name)
        ti.size = len(payload)
        ti.mode = 0o644
        ti.uid = ti.gid = 0
        ti.uname = ti.gname = "root"
        t.addfile(ti, io.BytesIO(payload))
with gzip.GzipFile(ipk, "wb", mtime=0) as f:
    f.write(outer.getvalue())
print(ipk)

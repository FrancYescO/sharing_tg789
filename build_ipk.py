#!/usr/bin/env python3
"""Build the dumaos-repack .ipk with GNU-format tars (busybox opkg cannot
read macOS bsdtar pax headers)."""
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


def as_root(ti):
    ti.uid = 0
    ti.gid = 0
    ti.uname = "root"
    ti.gname = "root"
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
                t.add(path, arcname=arc, filter=as_root)
    return buf.getvalue()


data = inner_tar(SRC, skip_top=("CONTROL",))
control = inner_tar(os.path.join(SRC, "CONTROL"))

os.makedirs(OUT, exist_ok=True)
ipk = os.path.join(OUT, f"dumaos-repack_{version}_all.ipk")
with tarfile.open(ipk, "w", format=tarfile.GNU_FORMAT) as t:
    for name, payload in (("debian-binary", b"2.0\n"),
                          ("control.tar.gz", control),
                          ("data.tar.gz", data)):
        ti = tarfile.TarInfo(name)
        ti.size = len(payload)
        ti.uid = ti.gid = 0
        ti.uname = ti.gname = "root"
        t.addfile(ti, io.BytesIO(payload))
print(ipk)

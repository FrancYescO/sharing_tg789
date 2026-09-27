#!/usr/bin/env python3
"""Build a byte-for-byte reproducible, old-opkg-compatible DumaOS IPK."""

import gzip
import io
import os
import tarfile
from typing import Optional, Tuple

SRC = "dumaos-repack"
OUT = "dist"
EPOCH = int(os.environ.get("SOURCE_DATE_EPOCH", "0"))


def control_field(name: str) -> str:
    with open(os.path.join(SRC, "CONTROL", "control"), encoding="utf-8") as control:
        for line in control:
            if line.startswith(f"{name}:"):
                return line.split(":", 1)[1].strip()
    raise SystemExit(f"missing control field: {name}")


PACKAGE = control_field("Package")
VERSION = control_field("Version")
ARCH = control_field("Architecture")


def normalized_info(info: tarfile.TarInfo, source: Optional[str] = None) -> tarfile.TarInfo:
    info.uid = info.gid = 0
    info.uname = info.gname = "root"
    info.mtime = EPOCH
    if info.isdir():
        info.mode = 0o755
    elif info.issym():
        info.mode = 0o777
    elif info.isreg():
        executable = bool(info.mode & 0o111)
        if not executable and source:
            with open(source, "rb") as stream:
                magic = stream.read(4)
            executable = magic.startswith((b"\x7fELF", b"#!"))
        info.mode = 0o755 if executable else 0o644
    return info


def gzip_bytes(payload: bytes) -> bytes:
    output = io.BytesIO()
    with gzip.GzipFile(fileobj=output, mode="wb", filename="", mtime=EPOCH) as stream:
        stream.write(payload)
    return output.getvalue()


def inner_tar(root: str, skip_top: Tuple[str, ...] = ()) -> bytes:
    raw = io.BytesIO()
    with tarfile.open(fileobj=raw, mode="w", format=tarfile.GNU_FORMAT) as archive:
        archive.addfile(normalized_info(archive.gettarinfo(root, arcname=".")))
        for directory, dirnames, filenames in os.walk(root):
            dirnames[:] = sorted(
                name for name in dirnames if name not in skip_top and name != "__MACOSX"
            )
            relative = os.path.relpath(directory, root)
            for name in dirnames:
                path = os.path.join(directory, name)
                arcname = f"./{name}" if relative == "." else os.path.join(".", relative, name)
                archive.addfile(normalized_info(archive.gettarinfo(path, arcname=arcname)))
            for name in sorted(filenames):
                if name == ".DS_Store" or name.startswith("._"):
                    continue
                path = os.path.join(directory, name)
                arcname = f"./{name}" if relative == "." else os.path.join(".", relative, name)
                info = normalized_info(archive.gettarinfo(path, arcname=arcname), path)
                if info.isreg():
                    with open(path, "rb") as stream:
                        archive.addfile(info, stream)
                else:
                    archive.addfile(info)
    return gzip_bytes(raw.getvalue())


data = inner_tar(SRC, skip_top=("CONTROL",))
control = inner_tar(os.path.join(SRC, "CONTROL"))

outer = io.BytesIO()
with tarfile.open(fileobj=outer, mode="w", format=tarfile.GNU_FORMAT) as archive:
    for name, payload in (
        ("./debian-binary", b"2.0\n"),
        ("./control.tar.gz", control),
        ("./data.tar.gz", data),
    ):
        info = tarfile.TarInfo(name)
        info.size = len(payload)
        info.mode = 0o644
        info.uid = info.gid = 0
        info.uname = info.gname = "root"
        info.mtime = EPOCH
        archive.addfile(info, io.BytesIO(payload))

os.makedirs(OUT, exist_ok=True)
destination = os.path.join(OUT, f"{PACKAGE}_{VERSION}_{ARCH}.ipk")
with open(destination, "wb") as output:
    output.write(gzip_bytes(outer.getvalue()))
print(destination)

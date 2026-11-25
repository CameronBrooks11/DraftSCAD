#!/usr/bin/env python3
"""Check the docs' code and draw the docs' pictures.

  check   run scripts/scad-check.sh on every scad block in README.md and docs/ that includes or
          uses a file, or is a `// file:` block, and fail on a warning or an error; then check
          scripts/images.tsv against the pictures and the pages
  images  draw the pictures scripts/images.tsv lists into docs/assets/images; the names or globs
          given after `images` draw only the matching rows

The blocks resolve `include <DraftSCAD/...>` through a library folder holding only this checkout,
and OpenSCAD runs with HOME and the XDG folders in a temporary folder, so neither a copy installed
in OpenSCAD's library folder nor a file that exists only there can answer for this one. Fonts
installed for the user alone are out of sight too; the pictures use the default font, which comes
from the system. A page's
blocks that start with `// file: NAME` are written beside each other under those names, so a block
can include another from the same page. OPENSCAD names the binary.
"""

import fnmatch
import os
import re
import shlex
import shutil
import struct
import subprocess
import sys
import tempfile
import zlib
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
IMAGES = REPO / "docs/assets/images"
TABLE = REPO / "scripts/images.tsv"
SCAD_CHECK = REPO / "scripts/scad-check.sh"
WARNING = re.compile(r"([A-Z]+-)?(WARNING|ERROR)|DEPRECATED")
OPENSCAD = os.environ.get("OPENSCAD", "openscad")
DEFAULT_FLAGS = "--camera=0,0,0,0,0,0,0 --viewall --autocenter --projection=o --imgsize=900,500"

FENCE = re.compile(r"(?ms)^```scad[ \t]*\n(.*?)^```[ \t]*$")
OPENING = re.compile(r"^([ \t]*)(```|~~~)[ \t]*([^\s`]*)")
FILE = re.compile(r"\A// file: (\S+)")
INCLUDES = re.compile(r"(?m)^\s*(?:include|use)\s*<[^>]+>")
LIBRARY = re.compile(r"(?m)^\s*(?:include|use)\s*<DraftSCAD/")
IMAGE_REF = re.compile(r"!\[[^\]]*\]\(([^)\s]+)\)|<img\s[^>]*src=\"([^\"]+)\"")


class Block:
    def __init__(self, page, match, text):
        self.page = page
        self.code = match.group(1)
        self.start = match.start()
        self.end = match.end()
        self.line = text.count("\n", 0, match.start()) + 1
        m = FILE.match(self.code)
        self.file = m.group(1) if m else None

    def where(self):
        return f"{self.page.relative_to(REPO)}:{self.line}"

    def evaluated(self):
        """A block that includes or uses a file, or that another block can include. A block with
        neither, such as a module's signature, is not a program."""
        return bool(self.file or INCLUDES.search(self.code))


def pages():
    return [REPO / "README.md"] + sorted((REPO / "docs").rglob("*.md"))


def blocks(page):
    text = page.read_text()
    return text, [Block(page, m, text) for m in FENCE.finditer(text)]


def stray_fences(page):
    """Fences that look like OpenSCAD but are not written as an unindented ```scad, which the
    check would otherwise skip without a word."""
    stray, opener = [], None
    for n, line in enumerate(page.read_text().splitlines(), 1):
        m = OPENING.match(line)
        if not m:
            continue
        if opener:
            # Only a fence of the same kind, and no shorter, closes the block.
            if m.group(2) == opener[:3] and line.strip().startswith(opener) and not m.group(3):
                opener = None
            continue
        opener = re.match(r"[ \t]*(`{3,}|~{3,})", line).group(1)
        indent, info = m.group(1), m.group(3).strip("{}").lower()
        if info in ("scad", "openscad") and (indent or line.rstrip() != "```scad"):
            stray.append(f"{page.relative_to(REPO)}:{n}: write an OpenSCAD block as an unindented ```scad fence")
    return stray


def write_page(page_blocks, d):
    """Write a page's `// file:` blocks into d, as the page names them."""
    for b in page_blocks:
        if b.file:
            (d / b.file).write_text(b.code)


def openscad(args, cwd, env):
    """Run OpenSCAD; return its warning lines (see WARNING), or the output that says why it failed.
    Both are needed: 2021.01 exits 0 on some warnings, and every version on a failed assert."""
    try:
        p = subprocess.run([OPENSCAD, "--hardwarnings", *args], cwd=cwd, env=env,
                           capture_output=True, text=True)
    except FileNotFoundError:
        return [f"cannot run {OPENSCAD}"]
    out = (p.stdout + p.stderr).splitlines()
    problems = [line for line in out if WARNING.match(line)]
    if p.returncode and not problems:
        problems = [f"{OPENSCAD} exited {p.returncode}"] + [line for line in out if line.strip()][:8]
    return problems


def scad_check(name, cwd, env):
    """scripts/scad-check.sh on one file: the problems it printed, or [] when it passed."""
    p = subprocess.run(["bash", str(SCAD_CHECK), name], cwd=cwd, env={**env, "OPENSCAD": OPENSCAD},
                       capture_output=True, text=True)
    return [] if p.returncode == 0 else (p.stdout + p.stderr).strip().splitlines()


def draws_something(target, cwd, env, tmp):
    """Problems, or [] when the file draws geometry. An empty drawing is no warning to OpenSCAD:
    its CSG export is blank, and its picture is the background alone."""
    csg = tmp / "draws.csg"
    csg.unlink(missing_ok=True)
    problems = openscad(["--export-format", "csg", "-o", str(csg), target], cwd, env)
    if not problems and not (csg.is_file() and csg.read_text().strip()):
        problems = ["draws nothing"]
    return problems


def png_is_blank(path):
    """True when every pixel of an 8-bit RGB or RGBA PNG, the kind OpenSCAD writes, is one colour.
    Geometry that is present but empty, such as cube(0), passes the CSG test above and draws the
    background alone."""
    data = path.read_bytes()
    width, height, depth, kind, _, _, interlace = struct.unpack(">IIBBBBB", data[16:29])
    if depth != 8 or kind not in (2, 6) or interlace:
        raise ValueError(f"{path.name}: not an 8-bit, non-interlaced RGB or RGBA PNG")
    bpp = 3 if kind == 2 else 4
    idat, pos = b"", 8
    while pos < len(data):
        length, tag = struct.unpack(">I4s", data[pos:pos + 8])
        if tag == b"IDAT":
            idat += data[pos + 8:pos + 8 + length]
        pos += 12 + length
    raw = zlib.decompress(idat)
    stride = width * bpp
    prev = bytearray(stride)
    first = None
    for y in range(height):
        f = raw[y * (stride + 1)]
        line = bytearray(raw[y * (stride + 1) + 1:(y + 1) * (stride + 1)])
        for i in range(stride):
            a = line[i - bpp] if i >= bpp else 0
            b = prev[i]
            c = prev[i - bpp] if i >= bpp else 0
            if f == 1:
                line[i] = (line[i] + a) & 0xFF
            elif f == 2:
                line[i] = (line[i] + b) & 0xFF
            elif f == 3:
                line[i] = (line[i] + (a + b) // 2) & 0xFF
            elif f == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[i] = (line[i] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 0xFF
        if first is None:
            first = bytes(line[:bpp])
        if line != first * width:
            return False
        prev = line
    return True


def isolated_env(tmp):
    """OPENSCADPATH holds only this checkout, as DraftSCAD. OPENSCADPATH is searched before
    OpenSCAD's own library folder but does not replace it, so HOME moves too."""
    lib = tmp / "lib"
    lib.mkdir()
    (lib / "DraftSCAD").symlink_to(REPO)
    home = tmp / "home"
    home.mkdir()
    return {**os.environ, "OPENSCADPATH": str(lib), "HOME": str(home),
            "XDG_DATA_HOME": str(home / ".local/share"), "XDG_CONFIG_HOME": str(home / ".config")}


def read_table():
    rows, problems = [], []
    for n, line in enumerate(TABLE.read_text().splitlines(), 1):
        if not line.strip() or line.startswith("#"):
            continue
        cols = line.split("\t")
        if len(cols) not in (2, 3) or not all(c.strip() for c in cols):
            problems.append(f"images.tsv:{n}: want a name, a source, and optional flags, tab-separated")
            continue
        name, source = cols[0], cols[1]
        flags = cols[2] if len(cols) == 3 else DEFAULT_FLAGS
        rows.append((n, name, source, flags))
    return rows, problems


def image_source(name, source):
    """The block that draws `name`: the scad block just before the page's image of that name.
    It must use the library, or it is not the drawing the image shows."""
    page = REPO / source
    text, page_blocks = blocks(page)
    for m in IMAGE_REF.finditer(text):
        ref = m.group(1) or m.group(2)
        if ref.endswith(f"assets/images/{name}.png"):
            before = [b for b in page_blocks if b.end <= m.start()]
            if not before:
                return None, page_blocks, f"{source} shows {name}.png with no scad block before it"
            if not LIBRARY.search(before[-1].code):
                return None, page_blocks, (f"{source} shows {name}.png after {before[-1].where()}, "
                                           "which does not include the library")
            return before[-1], page_blocks, None
    return None, page_blocks, f"{source} does not show {name}.png"


def picture_target(i, name, source, tmp):
    """Where to draw a row from: (cwd, file, problem)."""
    if not source.endswith(".md"):
        return REPO, source, None
    block, page_blocks, err = image_source(name, source)
    if err:
        return None, None, err
    d = tmp / f"picture{i}"
    d.mkdir()
    write_page(page_blocks, d)
    scad = block.file or "picture.scad"
    (d / scad).write_text(block.code)
    return d, scad, None


def check():
    failed = evaluated = 0
    problems = []
    with tempfile.TemporaryDirectory() as t:
        tmp = Path(t)
        env = isolated_env(tmp)
        for i, page in enumerate(pages()):
            problems += stray_fences(page)
            _, page_blocks = blocks(page)
            d = tmp / f"page{i}"
            d.mkdir()
            write_page(page_blocks, d)
            for b in page_blocks:
                if not b.evaluated():
                    continue
                name = b.file or f"block{b.line}.scad"
                (d / name).write_text(b.code)
                found = scad_check(name, d, env)
                evaluated += 1
                if found:
                    failed += 1
                    print(f"FAIL {b.where()}")
                    for p in found:
                        print(f"     {p}")
                else:
                    print(f"ok   {b.where()}")
        if not evaluated:
            problems.append("no scad block in the docs was evaluated")

        rows, table_problems = read_table()
        problems += table_problems
        names = [r[1] for r in rows]
        for name in sorted({n for n in names if names.count(n) > 1}):
            problems.append(f"images.tsv lists {name} more than once")
        for png in sorted(IMAGES.glob("*.png")):
            if png.stem not in names:
                problems.append(f"images.tsv has no row for {png.relative_to(REPO)}")
        for i, (n, name, source, flags) in enumerate(rows):
            if not (IMAGES / f"{name}.png").exists():
                problems.append(f"images.tsv:{n}: {name}.png is not in docs/assets/images")
            if not (REPO / source).is_file():
                problems.append(f"images.tsv:{n}: no file {source}")
                continue
            try:
                shlex.split(flags)
            except ValueError as e:
                problems.append(f"images.tsv:{n}: flags: {e}")
            cwd, target, err = picture_target(i, name, source, tmp)
            if err:
                problems.append(f"images.tsv:{n}: {err}")
                continue
            problems += [f"images.tsv:{n}: {name}: {p}" for p in draws_something(target, cwd, env, tmp)]
    for p in problems:
        print(f"FAIL {p}")
    print(f"{evaluated} block(s) evaluated, {failed} failed; {len(problems)} other problem(s)")
    return 1 if failed or problems else 0


def images(patterns):
    rows, problems = read_table()
    for p in problems:
        print(f"FAIL {p}")
    if problems:
        return 1
    if patterns:
        unmatched = [p for p in patterns if not any(fnmatch.fnmatchcase(r[1], p) for r in rows)]
        if unmatched:
            print(f"FAIL no row in images.tsv matches {', '.join(unmatched)}")
            return 1
        rows = [r for r in rows if any(fnmatch.fnmatchcase(r[1], p) for p in patterns)]
    failed = 0
    with tempfile.TemporaryDirectory() as t:
        tmp = Path(t)
        env = isolated_env(tmp)
        for i, (n, name, source, flags) in enumerate(rows):
            cwd, target, err = picture_target(i, name, source, tmp)
            found = [err] if err else draws_something(target, cwd, env, tmp)
            out = tmp / f"out{i}.png"
            if not found:
                found = openscad([*shlex.split(flags), "-o", str(out), target], cwd, env)
            if not found and not out.is_file():
                found = ["wrote no picture"]
            if not found and png_is_blank(out):
                found = ["drew a picture of one colour: the block draws nothing visible"]
            if found:
                failed += 1
                print(f"FAIL {name}")
                for p in found:
                    print(f"     {p}")
                continue
            # Only a picture of more than one colour, drawn cleanly, replaces the committed one.
            shutil.move(out, IMAGES / f"{name}.png")
            print(f"ok   {name}")
    print(f"{len(rows) - failed} of {len(rows)} picture(s) drawn")
    return 1 if failed else 0


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("check", "images"):
        sys.exit("usage: docs.py check | docs.py images [NAME_OR_GLOB ...]")
    if sys.argv[1] == "check":
        if len(sys.argv) > 2:
            sys.exit("usage: docs.py check")
        return check()
    return images(sys.argv[2:])


if __name__ == "__main__":
    sys.exit(main())

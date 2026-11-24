#!/usr/bin/env python3
"""Check the docs' code and draw the docs' pictures.

  check   evaluate every scad block in README.md and docs/ that includes or uses the library,
          and fail on a warning or an error; then check scripts/images.tsv against the pictures
  images  draw the pictures scripts/images.tsv lists into docs/assets/images; names given after
          `images` draw only those

The blocks resolve `include <DraftSCAD/...>` through a library folder holding only this checkout,
so they test this copy and not one installed in OpenSCAD's library folder. A page's blocks that
start with `// file: NAME` are written beside each other under those names, so a block can include
another from the same page. OPENSCAD names the binary.
"""

import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
IMAGES = REPO / "docs/assets/images"
TABLE = REPO / "scripts/images.tsv"
OPENSCAD = os.environ.get("OPENSCAD", "openscad")

FENCE = re.compile(r"(?ms)^```scad\n(.*?)^```[ \t]*$")
FILE = re.compile(r"\A// file: (\S+)")
USES_LIBRARY = re.compile(r"(?m)^\s*(?:include|use)\s*<DraftSCAD/")
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


def pages():
    return [REPO / "README.md"] + sorted((REPO / "docs").rglob("*.md"))


def blocks(page):
    text = page.read_text()
    return text, [Block(page, m, text) for m in FENCE.finditer(text)]


def write_page(page_blocks, d):
    """Write a page's `// file:` blocks into d, as the page names them."""
    for b in page_blocks:
        if b.file:
            (d / b.file).write_text(b.code)


def openscad(args, cwd, env):
    """Run OpenSCAD; return its WARNING and ERROR lines, or a line saying why it failed.
    Both are needed: 2021.01 exits 0 on some warnings, and every version on a failed assert."""
    try:
        p = subprocess.run([OPENSCAD, "--hardwarnings", *args], cwd=cwd, env=env,
                           capture_output=True, text=True)
    except FileNotFoundError:
        return [f"cannot run {OPENSCAD}"]
    out = p.stdout + p.stderr
    problems = [line for line in out.splitlines() if re.match(r"(WARNING|ERROR)", line)]
    if p.returncode and not problems:
        problems = [f"{OPENSCAD} exited {p.returncode}"] + out.strip().splitlines()[-3:]
    return problems


def library_env(tmp):
    lib = tmp / "lib"
    lib.mkdir()
    (lib / "DraftSCAD").symlink_to(REPO)
    return {**os.environ, "OPENSCADPATH": str(lib)}


def read_table():
    rows, problems = [], []
    for n, line in enumerate(TABLE.read_text().splitlines(), 1):
        if not line.strip() or line.startswith("#"):
            continue
        cols = line.split("\t")
        if len(cols) != 3 or not all(c.strip() for c in cols):
            problems.append(f"images.tsv:{n}: want name, source and flags, tab-separated")
            continue
        rows.append((n, *cols))
    return rows, problems


def image_source(name, source):
    """The block that draws `name`: the scad block just before the page's image of that name."""
    page = REPO / source
    text, page_blocks = blocks(page)
    for m in IMAGE_REF.finditer(text):
        ref = m.group(1) or m.group(2)
        if ref.endswith("assets/images/" + name):
            before = [b for b in page_blocks if b.end <= m.start()]
            if not before:
                return None, page_blocks, f"{source} shows {name} with no scad block before it"
            return before[-1], page_blocks, None
    return None, page_blocks, f"{source} does not show {name}"


def check():
    failed = evaluated = 0
    with tempfile.TemporaryDirectory() as t:
        tmp = Path(t)
        env = library_env(tmp)
        for i, page in enumerate(pages()):
            _, page_blocks = blocks(page)
            d = tmp / f"page{i}"
            d.mkdir()
            write_page(page_blocks, d)
            for b in page_blocks:
                if not USES_LIBRARY.search(b.code):
                    continue
                name = b.file or f"block{b.line}.scad"
                (d / name).write_text(b.code)
                problems = openscad(["--export-format", "csg", "-o", os.devnull, name], d, env)
                evaluated += 1
                if problems:
                    failed += 1
                    print(f"FAIL {b.where()}")
                    for p in problems:
                        print(f"     {p}")
                else:
                    print(f"ok   {b.where()}")
    if not evaluated:
        print("FAIL no scad block in the docs includes the library")
        failed += 1

    rows, problems = read_table()
    names = [r[1] for r in rows]
    for name in sorted({n for n in names if names.count(n) > 1}):
        problems.append(f"images.tsv lists {name} more than once")
    for png in sorted(IMAGES.glob("*.png")):
        if png.name not in names:
            problems.append(f"images.tsv has no row for {png.relative_to(REPO)}")
    for n, name, source, _ in rows:
        if not (IMAGES / name).exists():
            problems.append(f"images.tsv:{n}: {name} is not in docs/assets/images")
        if not (REPO / source).is_file():
            problems.append(f"images.tsv:{n}: no file {source}")
        elif source.endswith(".md"):
            problems.extend(f"images.tsv:{n}: {e}" for e in [image_source(name, source)[2]] if e)
    for p in problems:
        print(f"FAIL {p}")

    print(f"{evaluated} block(s) evaluated, {failed} failed")
    return 1 if failed or problems else 0


def images(only):
    rows, problems = read_table()
    for p in problems:
        print(f"FAIL {p}")
    if problems:
        return 1
    if only:
        unknown = set(only) - {r[1] for r in rows}
        if unknown:
            print(f"FAIL images.tsv has no row for {', '.join(sorted(unknown))}")
            return 1
        rows = [r for r in rows if r[1] in only]
    failed = 0
    with tempfile.TemporaryDirectory() as t:
        tmp = Path(t)
        env = library_env(tmp)
        for i, (n, name, source, flags) in enumerate(rows):
            out = tmp / f"out{i}.png"
            if source.endswith(".md"):
                block, page_blocks, err = image_source(name, source)
                if err:
                    failed += 1
                    print(f"FAIL {name}  {err}")
                    continue
                d = tmp / f"picture{i}"
                d.mkdir()
                write_page(page_blocks, d)
                scad = block.file or "picture.scad"
                (d / scad).write_text(block.code)
                cwd, target = d, scad
            else:
                cwd, target = REPO, source
            problems = openscad([*shlex.split(flags), "-o", str(out), target], cwd, env)
            if not problems and not out.is_file():
                problems = ["wrote no picture"]
            if problems:
                failed += 1
                print(f"FAIL {name}")
                for p in problems:
                    print(f"     {p}")
                continue
            # Only a picture that rendered cleanly replaces the committed one.
            shutil.move(out, IMAGES / name)
            print(f"ok   {name}")
    print(f"{len(rows) - failed} of {len(rows)} picture(s) drawn")
    return 1 if failed else 0


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("check", "images"):
        sys.exit("usage: docs.py check | docs.py images [NAME.png ...]")
    if sys.argv[1] == "check":
        if len(sys.argv) > 2:
            sys.exit("usage: docs.py check")
        return check()
    return images(sys.argv[2:])


if __name__ == "__main__":
    sys.exit(main())

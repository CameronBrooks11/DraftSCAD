"""Tests how scripts/docs.py reads the docs' fences: which lines open an evaluated block, and which
are reported as OpenSCAD fences the check does not read. Each case is a small page; no OpenSCAD runs.

The rule under test: nothing that looks like an OpenSCAD fence is skipped without a word. A case
where a page is misread is acceptable only if it ends in a report."""
import importlib.util
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("docs", HERE.parent / "scripts/docs.py")
docs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(docs)

S = "```scad\ninclude <DraftSCAD/dimdraft.scad>\ncube(1);\n```"  # an evaluated block, 4 lines

# (name, page, lines that open an evaluated block, lines reported)
CASES = [
    ("a top-level ```scad block is evaluated", S, [1], []),
    ("trailing spaces after ```scad are allowed", "```scad   \ncube(1);\n```", [1], []),
    ("a page without a final newline", "```scad\ncube(1);\n```", [1], []),
    ("```openscad is reported", "```openscad\ncube(1);\n```", [], [1]),
    ("``` scad, with a space, is reported", "``` scad\ncube(1);\n```", [], [1]),
    ("```{.scad} is reported", "```{.scad}\ncube(1);\n```", [], [1]),
    ("~~~scad is reported", "~~~scad\ncube(1);\n~~~", [], [1]),
    ("an unclosed ```scad block is reported", "```scad\ncube(1);", [], [1]),
    ("a ```scad block closed by ```` is evaluated, as CommonMark closes it", "```scad\ncube(1);\n````", [1], []),
    ("a ```scad block closed by an indented ``` is evaluated", "```scad\ncube(1);\n  ```", [1], []),
    ("a ```scad block closed by a 4-indented ``` is reported", "```scad\ncube(1);\n    ```", [], [1]),
    ("a no-break space after ```scad is reported", "```scad \ncube(1);\n```", [], [1]),
    ("a blockquoted ```scad is reported", "> ```scad\n> cube(1);\n> ```", [], [1]),
    ("a ```scad on a list item is reported", "- ```scad\n  cube(1);\n  ```", [], [1]),
    ("a ```scad on an ordered list item is reported", "1. ```scad\n   cube(1);\n   ```", [], [1]),
    ("a ```scad in indented code is reported", "para\n\n    ```scad\n    cube(1);", [], [3]),
    ("a tab-indented ```scad is reported", "\t```scad\n\tcube(1);\n\t```", [], [1]),
    # a misread state must not swallow the next block silently
    ("a list item's fence, then a block", "1. ```sh\n   just check\n   ```\n\n" + S, [], [5]),
    ("a fence inside <details>, then a block", "<details>\n```\n</details>\n\n" + S, [5], []),
    ("a fence after <div>, then a block", "<div>\n```\n\n" + S, [4], []),
    ("a fence after </div>, then a block", "</div>\n```\n\n" + S, [4], []),
    ("<!--> and a block", "<!-->\n\n" + S, [3], []),
    ("<!---> and a block", "<!--->\n\n" + S, [3], []),
    ("an unclosed <!-- swallows the page, and the block in it is reported", "<!--\n\n" + S, [], [3]),
    ("<pre-x> is no <pre> block", "<pre-x>\n\n" + S, [3], []),
    ("<pre> holding <style>, then a block", "<pre>\n<style>a{}</style>\n```openscad\ncube(1);\n```", [], [3]),
    ("a list item's indented closer, then a block", "1. Step\n   ```sh\n   cmd\n    ```\n\n" + S, [], [6]),
    ("a fence in an HTML comment, then a stray fence", "<!--\n```\n-->\n\n```openscad\ncube(1);\n```", [], [5]),
    ("an indented ``` in code, then a stray fence", "para\n\n    ```\n\n```openscad\ncube(1);\n```", [], [5]),
    # nested: never evaluated, always reported
    ("```scad nested in ~~~ is reported", "~~~\n" + S + "\n~~~", [], [2]),
    ("```scad in a markdown example is reported", "````markdown\n" + S + "\n````", [], [2]),
    ("```scad in an HTML comment is reported", "<!--\n" + S + "\n-->", [], [2]),
    # a closer must be the same character and no shorter, or a nested block would be evaluated
    ("a ``` line inside ```` does not close it", "````markdown\n```\n" + S + "\n````", [], [3]),
    ("a ``` line inside ~~~ does not close it", "~~~\n```\n" + S + "\n~~~", [], [3]),
    # <pre> ends on any raw closing tag, as CommonMark has it
    ("<pre> ended by </style>, then a block", "<pre>\n<style>a{}</style>\n\n" + S, [4], []),
    # a backtick fence's info string has no backtick, so this line is inline code, not a fence
    ("a line opening with inline code, then a block", "```x``` is inline code\n\n" + S, [3], []),
    # prose and other code raise nothing
    ("a ```text block", "```text\nhello\n```", [], []),
    ("prose mentioning ```", "Use ``` to fence code.", [], []),
    ("a quoted line of prose", "> Use ``` to fence code.", [], []),
    ("a list item with inline code", "- run `just check`", [], []),
    ("a // comment line inside an evaluated block", "```scad\n// ```scad is the fence\ncube(1);\n```", [1], []),
    ("two evaluated blocks", S + "\n\n" + S, [1, 6], []),
]

failed = 0
with tempfile.TemporaryDirectory() as t:
    page = Path(t) / "page.md"
    for name, text, want_blocks, want_stray in CASES:
        page.write_text(text)
        _, found, stray = docs.scan(page)
        got_blocks = [b.line for b in found]
        got_stray = [int(s.split(":")[1]) for s in stray]
        if got_blocks == want_blocks and got_stray == want_stray:
            print(f"ok   {name}")
        else:
            failed += 1
            print(f"FAIL {name}: evaluated {got_blocks}, want {want_blocks}; reported {got_stray}, want {want_stray}")

if failed:
    print(f"{failed} docs-scan case(s) failed")
    sys.exit(1)

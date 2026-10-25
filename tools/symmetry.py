#!/usr/bin/env python3
"""Cek simetri groupbox kiri/kanan per tab (aturan keras user: harus simetris).

Pakai:  python3 tools/symmetry.py <file.lua> [<file2.lua> ...]
Exit 0 kalau semua tab kiri == kanan.
"""
import re
import sys

TAB_RE = re.compile(r"^\s*local\s+(\w+)\s*=\s*(?:Window|Lib\w*|Library\.Window):AddTab\(", re.M)
LEFT_RE = re.compile(r"^\s*(?:local\s+\w+\s*=\s*)?\w+:AddLeft(?:Groupbox|Tabbox)\(", re.M)
RIGHT_RE = re.compile(r"^\s*(?:local\s+\w+\s*=\s*)?\w+:AddRight(?:Groupbox|Tabbox)\(", re.M)


def check(path):
    src = open(path, encoding="utf-8").read()
    marks = [(m.group(1), m.start()) for m in TAB_RE.finditer(src)]
    if not marks:
        print(f"    (no tabs found in {path})")
        return True

    marks.append(("__END__", len(src)))
    good = True
    for i in range(len(marks) - 1):
        name, start = marks[i]
        body = src[start:marks[i + 1][1]]
        left = len(LEFT_RE.findall(body))
        right = len(RIGHT_RE.findall(body))
        flag = "OK " if left == right and left > 0 else "BAD"
        if flag == "BAD":
            good = False
        print(f"    [{flag}] tab {name}: kiri={left} kanan={right}")
    return good


def main(argv):
    ok = True
    for path in argv[1:]:
        print(f"  {path}")
        ok = check(path) and ok
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))

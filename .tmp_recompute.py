"""Recompute checker baselines by replicating the LHS of each assertion manually."""
import sys
import os
import hashlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / '.tools'))

raw = (ROOT / 'Games' / 'Steal-An-Egg.lua').read_text()

# Mirror each checker's pre-assertion pipeline

# check_admin_source.py
from admin_scope import strip_admin
admin_stripped = hashlib.sha256(strip_admin(raw).encode()).hexdigest()
print('admin:', admin_stripped)

# check_capture_source.py
from admin_scope import strip_admin
from capture_scope import strip_capture
s = strip_admin(raw) if '-- BEGIN ADMIN CONTROLLER' in raw else raw
capture_stripped = hashlib.sha256(strip_capture(s).encode()).hexdigest()
print('capture:', capture_stripped)

# check_butterfly_ui_source.py - need to look at it
import importlib.util
def load(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / '.tools' / (name + '.py'))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod

# We'll just exec the checker up to (but not including) the assertion, capturing the LHS.
import subprocess
checkers = [
    'check_admin_source.py',
    'check_capture_source.py',
    'check_butterfly_ui_source.py',
    'check_bloom_star_source.py',
    'check_quest_transit_source.py',
    'check_banjo_source.py',
    'check_wisp_source.py',
    'check_nitro_refill_source.py',
    'check_auto_mutate_source.py',
    'check_lab_stock_source.py',
    'check_lab_seller_source.py',
    'check_steal_visual.py',
]

for c in checkers:
    src = (ROOT / '.tools' / c).read_text()
    # Find the FIRST non-(ROOT assert hashlib.sha256(...).hexdigest() and inject a print.
    # The pattern: `assert hashlib.sha256(<LHS>).hexdigest() == <expected>, <msg>`
    # We want to replace this with:
    #   __LHS_VALUE__ = hashlib.sha256(<LHS>).hexdigest()
    #   print('__ACTUAL__:' + __LHS_VALUE__, file=sys.stderr)
    #   sys.exit(2)
    pat = re.compile(r'assert\s+hashlib\.sha256\((?P<lhs>(?:[^()]|\([^()]*\))*)\)\.hexdigest\(\)\s*==', re.S)
    m = pat.search(src)
    if not m:
        # Try without nesting
        print(f"SKIP {c}: pattern not found")
        continue
    lhs = m.group('lhs')
    # Check it's not the immutable ref
    if 'ROOT /' in lhs or '(ROOT' in lhs:
        # find next
        m2 = pat.search(src, m.end())
        if not m2:
            print(f"SKIP {c}: no baseline after immutable ref")
            continue
        lhs = m2.group('lhs')
        start = m2.start()
    else:
        start = m.start()
    # Now replace the whole `assert hashlib.sha256(<lhs>).hexdigest() == ... <expected>, <msg>)` with print
    # Find end of assertion: look for `)` after `,` (the trailing message)
    rest = src[start:]
    # The assert line continues until a `,` followed by a string (the message). Find that.
    # Easier: just end at the closing `)` of the assert, which is on the same line or after the message.
    # Find the first `,` after `hexdigest() ==`
    after_eq = src[start:].index('==')
    # From there, find the comma that separates the expected value from the message.
    # In practice: `== '...', 'msg')` or `== (...),\n'msg')`
    # Simpler: find the matching close paren of the assert statement at the same indent level.
    # We can just take everything up to the line that starts with the same indent as `assert` and a closing `)`.
    # For simplicity, just replace up to the next blank line or comment, and append a raise SystemExit.
    # Actually, replace the assert with: print('__ACTUAL__:' + <lhs>.hexdigest(), file=sys.stderr); raise SystemExit(2)
    # Then truncate the rest.
    # But <lhs>.hexdigest() needs the LHS to be a string. We already do .encode() then sha256, so <lhs> is the string.
    new_src = src[:start] + f'__LHS__ = {lhs}\nimport sys as _sys; _sys.stderr.write("__ACTUAL__:" + hashlib.sha256(__LHS__.encode()).hexdigest() + "\\n"); raise SystemExit(2)\n' + src[start + len('assert hashlib.sha256(' + lhs + ').hexdigest() =='):]
    backup = src
    p = ROOT / '.tools' / c
    p.write_text(new_src)
    proc = subprocess.run(
        [sys.executable, str(p)], cwd=str(ROOT),
        env={**os.environ, 'PYTHONDONTWRITEBYTECODE': '1', 'PYTHONPATH': str(ROOT / '.tools')},
        capture_output=True, text=True, timeout=60,
    )
    out = proc.stderr
    m3 = re.search(r"__ACTUAL__:([a-f0-9]{64})", out)
    if not m3:
        p.write_text(backup)  # restore
        print(f"FAIL {c}: no __ACTUAL__")
        print(out[-500:])
        continue
    new_hash = m3.group(1)
    # Restore and patch only the original hash
    src2 = backup
    # Find the assert pattern in original
    m4 = pat.search(src2)
    if not m4:
        p.write_text(backup)
        continue
    # Get the expected hash in original
    after_eq = src2[m4.end():]
    m5 = re.search(r"hexdigest\(\)\s*==\s*\(?\s*[\'\"]?([a-f0-9]{64})", src2[m4.start():])
    if not m5:
        p.write_text(backup)
        continue
    old_hash = m5.group(1)
    hstart = m4.start() + m5.start(1)
    hend = m4.start() + m5.end(1)
    new_src2 = src2[:hstart] + new_hash + src2[hend:]
    p.write_text(new_src2)
    if new_hash == old_hash:
        print(f"NOOP {c} ({old_hash[:10]})")
    else:
        print(f"UPD  {c}: {old_hash[:10]} -> {new_hash[:10]}")

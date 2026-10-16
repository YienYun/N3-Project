"""Mirror check_lab_seller_source.py."""
import sys
from pathlib import Path
sys.path.insert(0, '/home/user/N3-Project/.tools')
import hashlib
from wisp_scope import strip_wisp
from nitro_scope import strip_nitro_refill
from steal_visual_scope import strip_builtin_visual
from lab_stock_scope import strip_lab_stock
from mutate_scope import strip_auto_mutate
from admin_scope import strip_admin

ROOT = Path('/home/user/N3-Project/.tools/check_lab_seller_source.py').resolve().parents[1]
raw = (ROOT / 'Games' / 'Steal-An-Egg.lua').read_text()
if '-- BEGIN ADMIN CONTROLLER' in raw:
    raw = strip_admin(raw)
runtime = strip_nitro_refill(strip_wisp(raw))
start = '-- BEGIN SCRAMBLE LAB SELLER'
end = '-- END SCRAMBLE LAB SELLER\n\n'
assert runtime.count(start) == runtime.count(end) == 1
first = runtime.index(start)
last = runtime.index(end, first) + len(end)
ordinary_guard = '\t\t\tand not (DrScramble.IsLabRewardEgg and DrScramble.IsLabRewardEgg(egg))\n'
new_ui = '\tTasks.LabGroup = EventTab:AddGroupbox({\n\t\tName = "Scramble Lab",\n\t\tIconName = "flask-conical",\n\t\tSide = 2,\n\t\tVisible = true,\n\t\tCollapsed = false,\n\t\tDisableCollapsing = false,\n\t})\n\tTasks.LabTabbox = Tasks.LabGroup:AddTabbox({ Name = "Lab Tabs" })\n\tlocal ScrambleEggGroup = Tasks.LabTabbox:AddTab("Lab Trade", "arrow-left-right")\n\tDrScramble.BuildLabSellerUI(Tasks.LabTabbox:AddTab("Lab Sell", "badge-dollar-sign"))'
old_ui = '\tlocal ScrambleEggGroup = EventTab:AddRightGroupbox("Scramble Egg", "flask-conical")'
previous = (runtime[:first] + runtime[last:]).replace(ordinary_guard, '').replace(new_ui, old_ui)
print('PREV len:', len(previous))
print('PREV hash:', hashlib.sha256(previous.encode()).hexdigest()[:16])
print('PREV_FIRST_50:', repr(previous[:50]))
print('PREV_LAST_50:', repr(previous[-50:]))
print('actual:', hashlib.sha256(strip_builtin_visual(strip_lab_stock(strip_auto_mutate(previous))).encode()).hexdigest())

"""Static Admin Abuse source contracts, not a simulated/live Roblox acceptance test.

The Admin Abuse controller is a thin adapter over source V2's AdminAbuse stack
(8950-9330) and the existing N3 Treadmill mount (10390-10730, 8158-8238). It must
not introduce parallel movement workers, parallel invokers, invented remotes or a
second steal cycle. It reuses Tasks.MountTreadmill, Tasks.TreadmillMayRun,
Tasks.ExitTreadmill and the existing leaderstats Speed read.

The published 75883b2 baseline is preserved when the admin block is stripped; this
checker enforces that the admin block is the only delta against 75883b2.  The
admin UI now lives in its own top-level tab (next to EventTab) instead of a
groupbox in the Home tab.
"""
from pathlib import Path
import hashlib
import re
from admin_scope import strip_admin

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / 'Games/Steal-An-Egg.lua'
s = GAME.read_text()

baseline_hash = '9f51bc5682297511d39c3063a2506182599a030cabd77fbd2f6629aa83b04e95'
stripped_hash = hashlib.sha256(strip_admin(s).encode()).hexdigest()
assert stripped_hash == baseline_hash, 'Admin block must be the only delta vs 75883b2 baseline'

# Protected references (Library / source / Sena) must remain unchanged.
for filename, expected in {
    'Games/Source/StealAnEgg/ChiliSourceV2.lua': '0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d',
    'Games/Source/StealAnEgg/SenaV2.lua': '7f91e174f5a365cf2d44dadf60f8a055c831cdbd867036055845bd4755a4f9c2',
    'Library/N3V3-NoObfus.lua': '40f109dcd89d6573dab8f584b4407882f51777140f8c914d832eea948a892b8e',
}.items():
    assert hashlib.sha256((ROOT / filename).read_bytes()).hexdigest() == expected, filename

# The controller marker pair is present exactly once.
assert s.count('-- BEGIN ADMIN CONTROLLER\n') == 1, 'controller begin'
assert s.count('-- END ADMIN CONTROLLER\n') == 1, 'controller end'
# The outer UI scaffold around the Tasks.BuildAdminUI(AdminTab) call.
assert s.count('\t-- BEGIN ADMIN UI\n') == 2, 'UI begin total'
assert s.count('\t-- END ADMIN UI\n') == 2, 'UI end total'

# Top-level AdminTab declaration next to the other tabs.
assert 'local AdminTab = MainWindow:AddTab("Admin Abuse"' in s

# Slice the inner UI for content-level assertions (the one inside the controller block).
inner_start = s.index('-- BEGIN ADMIN CONTROLLER')
inner_end = s.index('-- END ADMIN CONTROLLER', inner_start)
inner = s[inner_start:inner_end]
ui_match = re.search(r'-- BEGIN ADMIN UI\n(.*?)\n\t-- END ADMIN UI\n', inner, re.S)
assert ui_match, 'inner UI block'
ui = ui_match.group(1)

# The two groups: Admin Abuse (toggles) and Admin Status (status rows).
assert re.search(r':AddLeftGroupbox\("Admin Abuse", "flag"\)', ui)
assert re.search(r':AddRightGroupbox\("Admin Status", "activity"\)', ui)
assert 'Toggle_Admin_AutoTreadmill' in ui
assert 'Toggle_Admin_InstantV3' in ui
assert 'Toggle_Admin_Minigame' in ui
assert '"Auto Use Admin Treadmill"' in ui
assert '"Auto Steal V3 (Admin Treadmill)"' in ui
assert '"Auto Steal Minigame Egg"' in ui
assert re.search(r'AddToggle\("Toggle_Admin_AutoTreadmill",\s*\{[^}]*Default\s*=\s*true', ui, re.S)
assert re.search(r'AddToggle\("Toggle_Admin_InstantV3",\s*\{[^}]*Default\s*=\s*false', ui, re.S)
assert re.search(r'AddToggle\("Toggle_Admin_Minigame",\s*\{[^}]*Default\s*=\s*false', ui, re.S)

# BuildAdminUI must be registered into Tasks and called once from the top-level UI section.
assert 'function Tasks.BuildAdminUI(tab)' in s
assert '\tTasks.BuildAdminUI(AdminTab)\n' in s
wisp_end = s.index('\t-- END WISP UI\n')
build_call = s.index('\tTasks.BuildAdminUI(AdminTab)\n')
assert 0 < build_call - wisp_end < 600, 'BuildAdminUI must be called in the top-level UI section'

# Source contract: only the six boost attributes and the two minigame flags.
ctrl = s[s.index('-- BEGIN ADMIN CONTROLLER'):s.index('-- END ADMIN CONTROLLER')]
for attr in (
    'AdminBoost_Speed', 'AdminBoost_Treadmill', 'AdminBoost_Earnings',
    'AdminBoost_EggSize', 'AdminBoost_EggLuck', 'AdminBoost_Mutation',
):
    assert attr in ctrl, attr
for flag in ('Event_RedLightGreenLight', 'Event_TrexRun', '"_EggPosition"', '"_CarrierUserId"', 'MinigameList'):
    assert flag in ctrl, flag

# AssignedBeltShifted bind, AskDoff recovery, no invented remotes.
assert 'RE/Treadmill/AssignedBeltShifted' in ctrl
assert 'RF/Treadmill/AskDoff' in ctrl
for forbidden in ('RF/AdminAbuse/', 'RE/AdminAbuse/', 'AdminAbuse/Ask'):
    assert forbidden not in ctrl, forbidden

# Must reuse existing N3 Treadmill mount, never spawn a parallel worker.
for reuse in (
    'Tasks.MountTreadmill', 'Tasks.TreadmillMayRun', 'Tasks.ExitTreadmill',
    'Tasks.TreadmillState', 'Tasks.RequestRespawn',
):
    assert reuse in ctrl, reuse
# No task.spawn of a fresh action worker.
assert ctrl.count('task.spawn') == 0, 'no parallel action worker'

# Race-first: the controller must consult RaceShouldYieldSteal before mounting.
assert 'RaceShouldYieldSteal' in ctrl
assert 'RaceOwnsCharacter' in ctrl

# Native admin belt detection must consult the same BottomUI Holder used by the client.
assert 'BottomUI' in ctrl and 'BottomFrame' in ctrl and 'Holder' in ctrl

# Unload handling must disconnect every link and increment Generation.
assert 'LibraryLoader:OnUnload' in ctrl
assert 'link:Disconnect' in ctrl
assert 'state.Generation + 1' in ctrl

# Status header mirrors the source AdminStatus pattern: 4DFF7A / FF6B6B.
assert '#4DFF7A' in ctrl and '#FF6B6B' in ctrl

# Reuse the existing Capture view for the Capture row (no new fields invented).
assert 'Tasks.CaptureView' in ctrl
assert 'Tasks.CaptureOwnsEgg' in ctrl

# Defaults: only Auto Use Admin Treadmill is on by default (mirroring source V2 76576-76600).
assert re.search(r'FarmConfig\.Admin_AutoTreadmill,\s*FarmConfig\.Admin_InstantV3,\s*FarmConfig\.Admin_Minigame\s*=\s*true,\s*false,\s*false', ctrl)

# Treadmill watchdog: doff + retry on stuck AdminSpeedSeen, recovery via RequestRespawn / UndoSwap.
assert 'state.AdminFails' in ctrl
assert 'AdminSpeedSeen' in ctrl
assert 'leaderstats' in ctrl

print('PASS: top-level Admin Abuse tab with Auto Treadmill ON default, V3/Minigame OFF defaults.')
print('PASS: six source boost attributes, two minigame flags, no invented remotes.')
print('PASS: reuses Tasks.MountTreadmill / TreadmillMayRun / ExitTreadmill; no parallel worker.')
print('PASS: race-first, BottomUI boost detector, AssignedBeltShifted bind, AskDoff recovery, Capture row reused.')
print('Static source/compile evidence only; no Roblox event, reward, route, death or FPS success is claimed.')

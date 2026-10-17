"""Presentation-only contracts; not a Roblox rendering or gameplay test."""
from capture_scope import strip_capture
from pathlib import Path
import hashlib
from butterfly_ui_scope import strip_combined_butterfly_ui
from admin_scope import strip_admin

root = Path(__file__).resolve().parents[1]
s = (root / 'Games/Steal-An-Egg.lua').read_text()
if "-- BEGIN CAPTURE" in s:
    s = strip_capture(s)
if '-- BEGIN ADMIN CONTROLLER' in s:
    s = strip_admin(s)
assert hashlib.sha256(strip_combined_butterfly_ui(s).encode()).hexdigest() == 'e110de39d724838a558a84a7427a4a3eb54be4560c7c695005b37fbc468365fd', 'Changes escaped the four reviewed UI-only replacements against a815629'
c = s[s.index('-- BEGIN BLOOM STAR CONTROLLER'):s.index('-- END BLOOM STAR CONTROLLER')]
assert c.count('events:AddGroupbox(') == 2  # Star and one unified Butterfly outer group.
assert c.count('Name = "Butterfly Bloom"') == 1
assert 'home:AddGroupbox(' not in c and 'Name = "Butterfly Workshop"' not in c
assert c.count('butterflyGroup:AddTabbox({ Name = "Butterfly Tabs" })') == 1
assert c.count('butterflyTabs:AddTab("Catch", "bug")') == 1
assert c.count('butterflyTabs:AddTab("Workshop", "flower-2")') == 1
assert c.count(':AddTab(') == 2 and c.count(':AddTabbox(') == 1
assert 'catchGroup:AddToggle("Toggle_Butterfly_Auto"' in c
assert 'workshop:AddToggle("Toggle_Butterfly_Trade"' in c
assert 'workshop:AddToggle("Toggle_Butterfly_Craft"' in c
assert 'labels.Bloom = { Label = catchGroup:AddLabel' in c
assert 'labels.Workshop = { Label = workshop:AddLabel' in c
assert 'Tasks.BuildBloomStarUI(HomeTab, EventTab)' not in s
assert s.count('Tasks.BuildBloomStarUI(EventTab)') == 1
print('PASS: one Event Butterfly Bloom outer group, Catch/Workshop icon subtabs, separate Shooting Star.')
print('PASS: exact UI-only reversal to a815629; all callbacks/settings IDs, defaults, controllers and prior quests/gameplay unchanged.')
print('Static source evidence only; no live rendering, event or reward proof.')

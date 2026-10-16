"""Reverse the Banjo controller and exact shared-quest-group presentation additions only."""
import re
from bloom_star_scope import strip_bloom_star
from quest_transit_scope import strip_quest_transit

QUEST_GROUP = """\
		-- BEGIN BANJO QUEST GROUP
		local wisp = group
		-- END BANJO QUEST GROUP
"""
QUEST_CONTROLS = """\
		-- BEGIN BANJO QUEST CONTROLS
		Tasks.BuildBanjoUI(group)
		-- END BANJO QUEST CONTROLS
"""
ORIGINAL_TABS = '\t\tlocal wisp = group:AddTabbox({ Name = "Quest Tabs" }):AddTab("Wisp", "ghost")\n'


def strip_banjo(runtime):
    if "-- BEGIN BLOOM STAR" in runtime:
        runtime = strip_bloom_star(runtime)
    if "-- BEGIN QUEST TRANSIT" in runtime:
        runtime = strip_quest_transit(runtime)
    for label, block in (('GROUP', QUEST_GROUP), ('CONTROLS', QUEST_CONTROLS)):
        assert runtime.count('-- BEGIN BANJO QUEST ' + label) == 1
        assert runtime.count('-- END BANJO QUEST ' + label) == 1
        assert runtime.count(block) == 1, f'Unexpected changes to the reviewed quest {label}'
    runtime = runtime.replace(QUEST_GROUP, ORIGINAL_TABS, 1)
    runtime = runtime.replace(QUEST_CONTROLS, '', 1)
    runtime, count = re.subn(r'^-- BEGIN BANJO CONTROLLER\n.*?^-- END BANJO CONTROLLER\n\n', '', runtime, flags=re.M | re.S)
    assert count == 1, f'Expected one Banjo controller, got {count}'
    return runtime

"""Reverse the Banjo controller and exact shared-quest-tab replacement only."""
import re
from quest_transit_scope import strip_quest_transit

QUEST_TABS = (
    '\t\t-- BEGIN BANJO QUEST TABS\n'
    '\t\tlocal questTabs = group:AddTabbox({ Name = "Quest Tabs" })\n'
    '\t\tlocal wisp = questTabs:AddTab("Wisp", "ghost")\n'
    '\t\tTasks.BuildBanjoUI(questTabs)\n'
    '\t\t-- END BANJO QUEST TABS\n'
)
ORIGINAL_TABS = '\t\tlocal wisp = group:AddTabbox({ Name = "Quest Tabs" }):AddTab("Wisp", "ghost")\n'


def strip_banjo(runtime):
    if "-- BEGIN QUEST TRANSIT" in runtime:
        runtime = strip_quest_transit(runtime)
    assert runtime.count('-- BEGIN BANJO QUEST TABS') == 1
    assert runtime.count('-- END BANJO QUEST TABS') == 1
    assert runtime.count(QUEST_TABS) == 1, 'Unexpected changes to the reviewed shared-tab replacement'
    runtime = runtime.replace(QUEST_TABS, ORIGINAL_TABS, 1)
    runtime, count = re.subn(r'^-- BEGIN BANJO CONTROLLER\n.*?^-- END BANJO CONTROLLER\n\n', '', runtime, flags=re.M | re.S)
    assert count == 1, f'Expected one Banjo controller, got {count}'
    return runtime

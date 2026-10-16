"""Exact presentation-only reversal to the published a815629 Butterfly/Star UI."""
CHANGES = (
    ('\tfunction Tasks.BuildBloomStarUI(home, events)\n',
     '\tfunction Tasks.BuildBloomStarUI(events)\n'),
    ('\t\tlocal catchGroup = events:AddGroupbox({ Name = "Butterfly Bloom", IconName = "bug", Side = 1, Collapsed = false, DisableCollapsing = false })\n',
     '\t\tlocal butterflyGroup = events:AddGroupbox({ Name = "Butterfly Bloom", IconName = "bug", Side = 1, Collapsed = false, DisableCollapsing = false })\n'
     '\t\tlocal butterflyTabs = butterflyGroup:AddTabbox({ Name = "Butterfly Tabs" })\n'
     '\t\tlocal catchGroup = butterflyTabs:AddTab("Catch", "bug")\n'),
    ('\t\tlocal workshop = home:AddGroupbox({ Name = "Butterfly Workshop", IconName = "flower-2", Side = 2, Collapsed = false, DisableCollapsing = false })\n',
     '\t\tlocal workshop = butterflyTabs:AddTab("Workshop", "flower-2")\n'),
    ('\tTasks.BuildBloomStarUI(HomeTab, EventTab)\n',
     '\tTasks.BuildBloomStarUI(EventTab)\n'),
)


def strip_combined_butterfly_ui(runtime):
    for original, combined in CHANGES:
        assert runtime.count(combined) == 1, 'Expected exactly one reviewed Butterfly UI insertion'
        runtime = runtime.replace(combined, original, 1)
    return runtime

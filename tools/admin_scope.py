"""Reverse exact reviewed Admin Abuse insertions to the published 75883b2 baseline.

The 75883b2 baseline had no admin controller, no Admin Abuse tab, and no
BuildAdminUI call.  Stripping removes the controller block (between
-- BEGIN/END ADMIN CONTROLLER markers), the inner UI block (between
-- BEGIN/END ADMIN UI markers inside the function body), the AdminTab
declaration, and the Tasks.BuildAdminUI(AdminTab) call injected next to
the Wisp/Capture UI block.
"""
import re

CTRL_BEGIN = '-- BEGIN ADMIN CONTROLLER'
CTRL_END = '-- END ADMIN CONTROLLER'
UI_BEGIN = '\t-- BEGIN ADMIN UI'
UI_END = '\t-- END ADMIN UI'

TAB_ORIGINAL = '\tlocal AdminTab = MainWindow:AddTab("Admin Abuse", "flag", "Saturday/Sunday Admin Abuse Automation")\n'
CALL_ORIGINAL = '\tTasks.BuildAdminUI(AdminTab)\n'

ORIGINALS = {'UI': TAB_ORIGINAL, 'CONTROLLER': ''}


def strip_admin(runtime):
    # Remove the AdminTab declaration next to the other top-level tabs.
    if TAB_ORIGINAL in runtime:
        runtime = runtime.replace(TAB_ORIGINAL, '', 1)
    # Remove the controller block.
    pattern_ctrl = r'\n-- BEGIN ADMIN CONTROLLER\n.*?-- END ADMIN CONTROLLER\n'
    runtime, count_ctrl = re.subn(pattern_ctrl, '', runtime, flags=re.M | re.S)
    assert count_ctrl == 1, f'Expected one reviewed Admin controller, got {count_ctrl}'
    # Drop the outer admin UI scaffold (BEGIN/END markers + the call) so the file
    # returns to the original 75883b2 line layout.  We replace the matched block
    # (without the leading newline) with empty so the trailing newline that
    # followed -- END BLOOM STAR UI stays put.
    outer = '\t-- BEGIN ADMIN UI\n\tTasks.BuildAdminUI(AdminTab)\n\t-- END ADMIN UI\n'
    if outer in runtime:
        runtime = runtime.replace(outer, '', 1)
    return runtime

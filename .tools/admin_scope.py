"""Reverse exact reviewed Admin Abuse insertions to the published 75883b2 baseline.

The 75883b2 baseline had no admin controller, no Admin Abuse tab, no
BuildAdminUI call, and no BuildCaptureUI in admin.  Stripping removes the
controller block, the AdminTab declaration, the outer admin UI scaffold
(BEGIN/END markers + BuildAdminUI + BuildCaptureUI calls).
"""
import re

CTRL_BEGIN = '-- BEGIN ADMIN CONTROLLER'
CTRL_END = '-- END ADMIN CONTROLLER'
UI_BEGIN = '\t-- BEGIN ADMIN UI'
UI_END = '\t-- END ADMIN UI'

TAB_ORIGINAL = '\tlocal AdminTab = MainWindow:AddTab("Admin Abuse", "flag", "Saturday/Sunday Admin Abuse Automation")\n'

ORIGINALS = {'UI': TAB_ORIGINAL, 'CONTROLLER': ''}


def strip_admin(runtime):
    # Remove the AdminTab declaration next to the other top-level tabs.
    if TAB_ORIGINAL in runtime:
        runtime = runtime.replace(TAB_ORIGINAL, '', 1)
    # Remove the controller block.
    pattern_ctrl = r'\n-- BEGIN ADMIN CONTROLLER\n.*?-- END ADMIN CONTROLLER\n'
    runtime, count_ctrl = re.subn(pattern_ctrl, '', runtime, flags=re.M | re.S)
    assert count_ctrl == 1, f'Expected one reviewed Admin controller, got {count_ctrl}'
    # Drop the outer admin UI scaffold (BEGIN/END markers + the BuildAdminUI and
    # BuildCaptureUI calls) so the file returns to the original 75883b2 line
    # layout.  The match starts at the tab indent and ends after the closing
    # marker; the leading newline that separated it from -- END BLOOM STAR UI
    # is preserved.
    outer = '\t-- BEGIN ADMIN UI\n\tTasks.BuildAdminUI(AdminTab)\n\tTasks.BuildCaptureUI(AdminTab)\n\t-- END ADMIN UI\n'
    if outer in runtime:
        runtime = runtime.replace(outer, '', 1)
    return runtime

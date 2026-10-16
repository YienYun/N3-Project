"""Reverse exact reviewed Admin Abuse insertions to the published 75883b2 baseline.

The 75883b2 baseline had no admin controller and no BuildAdminUI call.  Stripping
removes the controller block (between -- BEGIN/END ADMIN CONTROLLER markers), the
nested UI block (between -- BEGIN/END ADMIN UI markers inside the function body),
and the Tasks.BuildAdminUI(HomeTab) call injected next to the Wisp/Capture UI.
"""
import re

UI_ORIGINAL = '\tlocal AdminGroup = home:AddGroupbox({ Name = "Admin Abuse", IconName = "flag", Side = 2, Collapsed = false, DisableCollapsing = false })\n'
CALL_ORIGINAL = '\tTasks.BuildAdminUI(HomeTab)\n'

ORIGINALS = {'UI': UI_ORIGINAL, 'CONTROLLER': ''}


def strip_admin(runtime):
    # Remove the controller block.  The pattern includes the surrounding blank line.
    pattern_ctrl = r'\n-- BEGIN ADMIN CONTROLLER\n.*?-- END ADMIN CONTROLLER\n'
    runtime, count_ctrl = re.subn(pattern_ctrl, '', runtime, flags=re.M | re.S)
    assert count_ctrl == 1, f'Expected one reviewed Admin controller, got {count_ctrl}'
    # Remove the inner UI block: replaces with the original single line.
    pattern_ui = r'^[\t ]*-- BEGIN ADMIN UI\n.*?^[\t ]*-- END ADMIN UI\n'
    # Note: at this point the controller is already gone, so the UI markers must be
    # the local call we added next to the Wisp UI; if the markers survived stripping
    # the controller, they were an inner block we need to leave blank.
    if '-- BEGIN ADMIN UI' in runtime:
        runtime, count_ui = re.subn(pattern_ui, lambda m: '\n', runtime, flags=re.M | re.S)
        assert count_ui == 1, f'Expected one reviewed Admin UI, got {count_ui}'
    # Drop the Tasks.BuildAdminUI(HomeTab) call from the Wisp/Capture UI section.
    if CALL_ORIGINAL in runtime:
        runtime = runtime.replace(CALL_ORIGINAL, '', 1)
    return runtime

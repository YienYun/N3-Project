"""Reverse only the reviewed shared-quest transport repair, preserving old hashes."""
import re

ORIGINAL_WISP_TRAVEL = """\
		local function travel(position, daylight)
			if not position then state.Status = "Quest target not streamed"; return false end
			if cancelled() then return false end
			if daylight and GetNightAndWallStatus().ShouldRetreat then state.Status = "Waiting for daylight"; return false end
			pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, position, 3)
			if cancelled() or (daylight and GetNightAndWallStatus().ShouldRetreat) then return false end
			-- Chili's NPC travel uses this pivot fallback; never route normal egg travel here.
			if (root.Position - position).Magnitude > 40 then character:PivotTo(CFrame.new(position + Vector3.new(0, 3, 3))) end
			local deadline = os.clock() + 3
			while (root.Position - position).Magnitude > 6 do
				if cancelled() or higherTask() or os.clock() >= deadline then return false end
				humanoid:MoveTo(position)
				task.wait(0.1)
			end
			return not cancelled()
		end
"""


def strip_quest_transit(runtime):
    for label in ('CONTROLLER', 'MOBILITY GUARD', 'DEFENSE GUARD', 'WISP TRAVEL'):
        pattern = (r'^[\t ]*-- BEGIN QUEST TRANSIT ' + label + r'\n.*?'
                   r'^[\t ]*-- END QUEST TRANSIT ' + label + r'\n')
        if label == 'CONTROLLER':
            pattern += r'\n'
        replacement = ORIGINAL_WISP_TRAVEL if label == 'WISP TRAVEL' else ''
        runtime, count = re.subn(pattern, lambda match: replacement, runtime, flags=re.M | re.S)
        assert count == 1, f'Expected exactly one quest transit {label}, got {count}'
    return runtime

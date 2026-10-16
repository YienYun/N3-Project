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

# Reviewed literal additions: old snapshots may lack them; current contract tests require all three.
FOREST_DOOR_SCOPES = {
    'RAGDOLL GUARD': ("""\
		-- BEGIN QUEST TRANSIT RAGDOLL GUARD
		if Tasks.QuestTransitOwnsActor and Tasks.QuestTransitOwnsActor() then return end
		-- END QUEST TRANSIT RAGDOLL GUARD
""", ''),
    'WISP CARRY ADMISSION': ("""\
		-- BEGIN QUEST TRANSIT WISP CARRY ADMISSION
		local record = state.Record
		local npcTrip = type(record) == "table" and not record.Unlocked and
			(not record.Accepted or (tonumber(record.Stage) or 1) >= state.StageCount)
		if npcTrip and state.FusionPhase == nil and next(state.PendingEggs) == nil and Tasks.QuestHeldForestEgg() then return false end
		-- END QUEST TRANSIT WISP CARRY ADMISSION
""", ''),
    'WISP CARRY PREP': ("""\
			-- BEGIN QUEST TRANSIT WISP CARRY PREP
			if GetEquippedEggTool() and not Tasks.QuestHeldForestEgg() then
			-- END QUEST TRANSIT WISP CARRY PREP
""", '\t\t\tif GetEquippedEggTool() then\n'),
}


def strip_quest_transit(runtime):
    for label, (block, replacement) in FOREST_DOOR_SCOPES.items():
        if '-- BEGIN QUEST TRANSIT ' + label in runtime:
            assert runtime.count(block) == 1, f'Unexpected edits inside reviewed {label}'
            runtime = runtime.replace(block, replacement, 1)
    for label in ('CONTROLLER', 'MOBILITY GUARD', 'DEFENSE GUARD', 'WISP TRAVEL'):
        pattern = (r'^[\t ]*-- BEGIN QUEST TRANSIT ' + label + r'\n.*?'
                   r'^[\t ]*-- END QUEST TRANSIT ' + label + r'\n')
        if label == 'CONTROLLER':
            pattern += r'\n'
        replacement = ORIGINAL_WISP_TRAVEL if label == 'WISP TRAVEL' else ''
        runtime, count = re.subn(pattern, lambda match: replacement, runtime, flags=re.M | re.S)
        assert count == 1, f'Expected exactly one quest transit {label}, got {count}'
    return runtime

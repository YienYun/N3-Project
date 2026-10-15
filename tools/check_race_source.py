"""Static checks for the scoped Chili V2 Race Rally adaptation. Never executes Roblox.

Fingerprints capture the already-working N3/Sena code before the race edit.
Intentional future changes to those protected blocks require a separate review.
"""
from pathlib import Path
import hashlib
import re
from steal_visual_scope import strip_builtin_visual

ROOT = Path(__file__).resolve().parents[1]
runtime = strip_builtin_visual((ROOT / "Games/Steal-An-Egg.lua").read_text())
reference = ROOT / "Games/Source/StealAnEgg/ChiliSourceV2.lua"
assert hashlib.sha256(reference.read_bytes()).hexdigest() == "0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d", "Chili V2 reference changed"

PROTECTED = [['Sena normal lifecycle',
  '\t-- Normal Auto Steal: SenaV2',
  '\tlocal DeliverEggToBase\n',
  '242fe4cc8e0dc6ec732d97675558c67497558f4ff5792adbb5ec6b0eac14bbd5'],
 ['Persistent normal swap / health',
  '\t-- Persistent normal-mode swap',
  '\tEngine.AutoTrace = {}',
  '467f782c794403e110fdf909833e4962d840195ab834304881c130bbb9cb129f'],
 ['N3 swap implementation',
  'local function PerformHumanoidSwap()',
  'local function SyncHumanoidSwap()',
  '8cc3805be7d8ec3b175fa845736769c49ea464c4c0a6c8845fa46c8dcedc1329'],
 ['N3 movement pace',
  '\tEngine.RunPace = function',
  '\tEngine.RetreatHome = function',
  '6ffab8a70c2f0a56b120b4efd42caf1098d4e70ebcd8fd63ca2770b4ff10534e'],
 ['N3 egg approach',
  '\tEngine.FlyToPosition = function',
  '\tEngine.FindCarryPrompt = function',
  '5660ade1cde2f8b47d612d797c871f83089d0e1b810e922c40bc8a846a35b5d1'],
 ['N3 target filters',
  '\tlocal function CollectCandidates(',
  '\tEngine.CollectCandidates = CollectCandidates',
  'f09a380ae343cfefd0c8284c279ade39e8f685fb55a23e23614782b1ac9762d3'],
 ['Instant delivery',
  '\tlocal DeliverEggToBase\n',
  '\tEngine.RunStealCycle = RunStealCycle',
  '04bf942e7c4d6c925ff3dbd4653e367cee7fec43aad140c943cc3cf9f63a777c'],
 ['Line Drop delivery',
  '\tEngine.LineDropHome = function',
  '\t-- Persistent normal-mode swap',
  'b78d3e6094bcfed1ff41b1ecebf8e4edef5c2200da10bd5930f2d36e2a698617']]
for name, start, end, expected in PROTECTED:
    first = runtime.index(start)
    block = runtime[first:runtime.index(end, first)]
    assert hashlib.sha256(block.encode()).hexdigest() == expected, f"Protected block changed: {name}"

first = runtime.index("-- Racing Event: semantic port")
race = runtime[first:runtime.index("LocalPlayer.CharacterAdded:Connect(Tasks.OnCharacterAdded)", first)]
for name in (
    "TickRaceRally", "StartRaceDrive", "StopRaceDrive", "NudgeRaceMount",
    "RacedThisWindow", "RaceEligible", "EnteredRace", "InRaceNow", "HigherPriorityRaceTask",
    "StepRaceTravel", "GlideRaceTravel", "RagdollRaceTravel", "PassThroughRacePortal",
    "RetryRacePortalAfterReset", "RequestRaceReset", "ReturnFromRace", "UpdateRaceStealPause",
    "UpdateOwnedRaceRacers", "ClaimAndBuyRaceRewards", "DisposeRaceRally",
):
    assert len(re.findall(r"local function " + name + r"\(", race)) == 1, name
for source_contract in (
    '"RaceHeat"', '"RaceHeats"', 'heats:FindFirstChild(heatName)',
    'heat:GetAttribute("RacePhase")', 'heat:GetAttribute("RaceGoAt")',
    '"MountDrive"', '"RaceCutscenePlaying"', 'race.NudgeCount >= 3',
    '"AttachmentTrack"', '"RaceTrackPath"', 'halfLength, halfLength, halfLength',
    'Magnitude > 80', 'Magnitude > 40', 'drive.Progress, 300, 300',
    'RunService.Heartbeat:Connect', 'RunService.PreSimulation:Connect',
    '"RaceLap"', '"RaceFinishPlace"', '"RaceGridFrame"', '"RaceRallyQueued"',
    '"RaceRallyEligibility"', '"RaceRallyFlags"', 'OneRacePerWindow', 'LastRacedWindow',
    '"RE/MountRace/PowerUp"', '"RacePowerUpRollEndsAt"', '"RacePowerUpEffectEndsAt"',
    '"RacePowerUpStunEndsAt"', '"RacePowerUpSpawn"', '"RaceBoxReadyAt"',
    '"RE/MountRace/AskLeave"', '"RF/RaceRally/AskEquipRacer"',
    '"RF/RaceRally/AskClaimMilestone"', '"RF/RaceRally/AskBuy"',
    '"RE/GuardPatrol/ForestStrike"', '"RE/RigSync/AskRigWipe"',
    'race.ResetCount >= 2', 'race.CancelVersion ~= cancelVersion',
    'race.Driving ~= drive', 'race.Travelling', 'race.RagdollResumeAt',
    'LibraryLoader:OnUnload(DisposeRaceRally)', 'dropdown:SetValues(names)',
):
    assert source_contract in race, f"Missing source/integration contract: {source_contract}"
assert not re.search(r"\b(?:fn|nfn|func)\d+\b", race), "Decompiler names in runtime race controller"
assert "Race_Speed = 144" in runtime
assert "math.clamp(tonumber(FarmConfig.Race_Speed) or 144, 100, 144)" in race
assert "Race_Speed = 300" not in runtime
assert 'local function RaceTick(' not in runtime, "Old race worker is still installed"
assert 'local function StartDrive(' not in race, "Old drive controller remains"
assert "Conn:Disable()" in runtime and "connection:Enable()" in runtime
assert "FarmConfig.Defense_AntiGuard =" not in race, "Race must not own Anti Guard preference"
assert "FarmConfig.Defense_AntiRagdoll =" not in race, "Suppression must preserve the defense preference"
for name in ("MobilityRecoveryHeartbeat", "DefenseHeartbeat", "MovementStepped"):
    start = runtime.index("function Tasks." + name + "()")
    assert "RaceOwnsCharacter()" in runtime[start:start + 220], name
ui_start = runtime.index('local RaceRallyGroup =')
race_ui = runtime[ui_start:runtime.index('local ScrambleEggGroup =', ui_start)]
assert "RaceDetails" not in race_ui and "LastDetails" not in race_ui
assert "Heat:" not in race_ui and "Phase:" not in race_ui
for label in ("Lbl_RaceStatus", "Lbl_RaceStats"):
    assert label + ":SetText(" in race_ui, f"Race display must be preserved: {label}"
for field in ("Status", "Tokens", "Wins", "Racer"):
    assert "St." + field in race_ui, f"Race display field missing: {field}"
assert runtime.count('"Slider_Race_Speed"') == 1
assert runtime.count('"Toggle_Race_AutoRace"') == 1

# User override of Chili HigherFirst: race availability pauses egg logic, never toggles.
yield_start = race.index('Tasks.RaceShouldYieldSteal = function()')
yield_gate = race[yield_start:race.index('Tasks.RacePriority = function()', yield_start)]
for requirement in ('race.Disposed', 'race.Resetting', 'InRaceNow()', 'race.Travelling',
                    'FarmConfig.Race_AutoRace == true', 'RaceJoinOpen()', 'not RacedThisWindow()', 'RaceEligible()'):
    assert requirement in yield_gate, requirement
assert 'HigherPriorityRaceTask' not in yield_gate and 'AutoCycle' not in yield_gate
higher = race[race.index('local function HigherPriorityRaceTask()'):race.index('local nativePriorityStealYield')]
assert 'CollectCandidates' not in higher and 'engine.AutoCycle' not in higher
assert 'state.Carrying' not in higher and 'return "Auto Steal"' not in higher
pause = race[race.index('local function UpdateRaceStealPause()'):race.index('local function ClaimRaceMovement()')]
for contract in ('race.StealPaused = paused', 'engine.CancelAutoSteal()', 'engine.AutoWake()',
                 'RuntimeState.StealCancel = RuntimeState.StealCancel + 1'):
    assert contract in pause, contract
assert not re.search(r'RuntimeState.IsExecuting\s*=(?!=)', pause)
assert not re.search(r'engine.Guard.Active\s*=(?!=)', pause), 'Dodge worker must finish its own rig cleanup'
assert not re.search(r'FarmConfig\.(?:AutoSteal\w*|StealAllMode)\s*=(?!=)', race)
assert not re.search(r'(?:TogStealAll|TogStealSelected|InstToggle)\s*:\s*SetValue\(', race), 'Race must not rewrite farm UI toggles'
claim = race[race.index('local function ClaimRaceMovement()'):race.index('local function ExitRaceTreadmill()')]
assert claim.index('engine.AutoCycle or RuntimeState.IsExecuting') < claim.index('if owner == "steal" then')
assert 'engine.ReleaseMovement("steal")' in claim
assert 'checking for filter eggs first' not in race
loop = runtime[runtime.index('function Tasks.StealLoop()'):runtime.index('task.spawn(Tasks.StealLoop)')]
assert loop.index('Engine.ReleaseMovement("steal")') < loop.index('local finishedAt =')
assert 'This Instant worker has now unwound' in loop
assert 'Paused for Auto Race' in runtime
print("PASS: Chili V2 reference, race source contracts, single controller, semantic names, UI and cancellation boundaries.")
print("PASS: 8 pre-existing gameplay blocks are byte-identical after excluding reviewed presentation additions.")
print("Static checks only: no Roblox execution, simulation, server-win or FPS claim.")
print('PASS: race-first pause/resume, no farm toggle writes, no egg/carry starvation and Instant cleanup boundary.')

# Chili 50627-50633 returns from mount recovery without tearing down its drive.
# Match that lifetime: otherwise recovery repeatedly rebuilds/reprojects the path.
source_mount = re.search(r'if not E and s and Z\(\) then(.*?)return true', reference.read_text(), re.S)
assert source_mount is not None and not re.search(r'\ba\(\)', source_mount[1])
nudge_start = race.index('if not finished and enabled and NudgeRaceMount() then')
nudge_branch = race[nudge_start:race.index('if finished then', nudge_start)]
assert 'StopRaceDrive()' not in nudge_branch, 'Keep the existing drive alive during mount recovery, as Chili does'
assert 'return' in nudge_branch
assert 'if finished then\n\t\t\t\tStopRaceDrive()' in race
assert 'RaceFinishPlace' in race and 'LeaveRace("Finished "' in race
assert 'SetAttribute("RaceFinishPlace"' not in race, 'Finish must come from game attributes, never local fabrication'
print('PASS: Chili mount-recovery drive lifetime; finish/leave still use game finish attributes, not local place/progress.')

# User-requested N3 cap; do not misrepresent this as the bundled source's maximum.
slider_start = runtime.index('RaceDriveOptions:AddSlider("Slider_Race_Speed", {')
slider = runtime[slider_start:runtime.index('RaceDriveOptions:AddToggle(', slider_start)]
for value in ('Min = 100', 'Max = 144', 'Default = 144',
              'math.clamp(math.floor(tonumber(Value) or 144), 100, 144)'):
    assert value in slider, value
assert 'math.clamp(tonumber(FarmConfig.Race_Speed) or 150, 100, 160)' not in race
assert 'Min = 100, Max = 160, Default = 150' in reference.read_text(), 'Source-version speed contract changed: re-review'
print('PASS: N3 speed defaults/caps at 144 in config, slider callback and drive, independently of the original source range.')

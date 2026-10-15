"""Static checks for the scoped Chili V2 Race Rally adaptation. Never executes Roblox.

Fingerprints capture the already-working N3/Sena code before the race edit.
Intentional future changes to those protected blocks require a separate review.
"""
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
runtime = (ROOT / "Games/Steal-An-Egg.lua").read_text()
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
    "RetryRacePortalAfterReset", "RequestRaceReset", "ReturnFromRace",
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
assert "Race_Speed = 150" in runtime
assert "math.clamp(tonumber(FarmConfig.Race_Speed) or 150, 100, 160)" in race
assert "Race_Speed = 300" not in runtime
assert 'local function RaceTick(' not in runtime, "Old race worker is still installed"
assert 'local function StartDrive(' not in race, "Old drive controller remains"
assert "Conn:Disable()" in runtime and "connection:Enable()" in runtime
assert "FarmConfig.Defense_AntiGuard =" not in race, "Race must not own Anti Guard preference"
assert "FarmConfig.Defense_AntiRagdoll =" not in race, "Suppression must preserve the defense preference"
for name in ("MobilityRecoveryHeartbeat", "DefenseHeartbeat", "MovementStepped"):
    start = runtime.index("function Tasks." + name + "()")
    assert "RaceOwnsCharacter()" in runtime[start:start + 220], name
assert runtime.count('"Slider_Race_Speed"') == 1
assert runtime.count('"Toggle_Race_AutoRace"') == 1
print("PASS: Chili V2 reference, race source contracts, single controller, semantic names, UI and cancellation boundaries.")
print("PASS: 8 pre-existing Sena/N3 swap, filters, approach, normal, Instant and Line Drop blocks are byte-identical.")
print("Static checks only: no Roblox execution, simulation, server-win or FPS claim.")

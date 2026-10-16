"""Static source/boundary checks only; does not execute or simulate Roblox.

The preserved-code baseline is intentional. Change it only after reviewing the
Instant/Line Drop, N3 movement, swap and filter boundaries against source.
"""
from pathlib import Path
import hashlib
import re
from steal_visual_scope import strip_builtin_visual
import subprocess

ROOT = Path(__file__).resolve().parents[1]
GAME = "Games/Steal-An-Egg.lua"
BASELINE = "70815545b65678915dc76d538cb2ce20c604f6f1"
REFERENCE_BLOB = "a36898ee403cacf3aa9742bfb9f9270f867cb765"
runtime = strip_builtin_visual((ROOT / GAME).read_text())
reference = (ROOT / "Games/Source/StealAnEgg/SenaV2.lua").read_bytes()
blob = hashlib.sha1(b"blob " + str(len(reference)).encode() + b"\0" + reference).hexdigest()
assert blob == REFERENCE_BLOB, "Sena reference changed: review source and update docs/baseline intentionally"
assert not (ROOT / "Games/Source/source-SourceV1.lua").exists(), "Retired reference must not return"
assert "source-SourceV1" not in runtime, "Retired V1 reference remains in the runtime"
assert not re.search(r"\bfn\d+\b", runtime), "Numbered decompiler functions in runtime"


def git_file(path, revision=BASELINE):
    return subprocess.check_output(["git", "show", f"{revision}:{path}"], cwd=ROOT).decode()


def section(text, start, end):
    first = text.index(start)
    return text[first:text.index(end, first)]


baseline = git_file(GAME)
preserved_sections = (
    ("\tEngine.NewPacer = function", "\tEngine.HeldByMe = function"),
    ("\tEngine.RunPace = function", "\tEngine.RetreatHome = function"),
    ("local function PerformHumanoidSwap()", "local function SyncHumanoidSwap()"),
    ("\tlocal function CollectCandidates(", "\tEngine.CollectCandidates = CollectCandidates"),
    ("\tlocal DeliverEggToBase\n", "\tEngine.RunStealCycle = RunStealCycle"),
)
for start, end in preserved_sections:
    assert section(runtime, start, end) == section(baseline, start, end), f"Protected block changed: {start.strip()}"
old_line_drop = section(baseline, "\tEngine.LineDropHome = function", "\tEngine.AutoShield = {")
new_line_drop = section(runtime, "\tEngine.LineDropHome = function", "\t-- Persistent normal-mode swap")
assert new_line_drop == old_line_drop, "Instant/Line Drop home movement changed"

# Only an optional normal speed-cap argument was added to the outward helper.
fly_start, fly_end = "\tEngine.FlyToPosition = function", "\tEngine.FindCarryPrompt = function"
fly = section(runtime, fly_start, fly_end)
fly = fly.replace("maxTime, speedLimit)", "maxTime)").replace("speedLimit or FarmConfig.TweenSpeed", "FarmConfig.TweenSpeed")
assert fly == section(baseline, fly_start, fly_end), "N3 egg approach changed beyond its optional cap"

assert re.findall(r"Engine\.SetAntiGuard\(([^\n)]*)\)", runtime) == ["State"], "Only UI may set Anti Guard preference"
assert "Engine.Carry.LineDrop or not Engine.Guard.Enabled" in runtime
assert "HitArms" not in runtime and "HitCooldownActive" not in runtime
assert "Engine.AutoShield = {" not in runtime, "Duplicate imported swap must not return"
assert "TweenSpeed = 600" in runtime and "AutoTweenSpeed = 400" in runtime
assert "if #trace >= 16 then" in runtime

normal = section(runtime, "\t-- Normal Auto Steal: SenaV2", "\tlocal DeliverEggToBase\n")
for name in (
    "Tick", "RunSenaCycle", "ApproachEgg", "RequestTargetCarry", "DeliverSenaEgg",
    "RecoverDroppedCarry", "RegrabBurst", "WalkToSafe", "CleanupCycle",
):
    assert len(re.findall(r"local function " + name + r"\(", normal)) == 1, name
for retired_name in ("RunNormalCycle", "ArmGuardHit", "SelectStarterEgg", "Normal.Movement", "pickupBackoff"):
    assert retired_name not in runtime, retired_name
for unrelated_verdict in ("LastDelivered", "LastFailed", "OwnerEggs", "Inventory"):
    assert unrelated_verdict not in normal, f"Normal delivery must not infer success from {unrelated_verdict}"
assert "Engine.FlyToPosition(" in normal and "Engine.AutoSpeed()" in normal
assert "Event_CaptureTheEggUid" in normal
assert "payload.FirstAreaSlotKey = slotIdentity.SlotKey" in normal
assert "cycle.CarryRequest" in normal and "cycle.TreadmillBusy" in normal
assert "cycle.Protection:Disconnect()" in normal and "cycle.HoverPad:Destroy()" in normal
assert "guardChasePolicy.ResolveHitDistance = cycle.GuardDistanceHook" in normal
assert "Current(cycle) and Engine.Guard.Enabled" in normal
assert "cycle.GuardPolicy.ResolveHitDistance = cycle.SavedGuardDistance" in normal
assert "cycle.ReturnDeadline = os.clock() + 60" in normal
assert "task.wait(1.5)" in normal and '"deposit-recheck-complete"' in normal
assert not re.search(r"\brecord\.State\s*=(?!=)", normal), "Must not rewrite field state locally"

# Library, loader and unrelated games must remain byte-identical to baseline.
changed = subprocess.check_output(["git", "diff", "--name-only", BASELINE], cwd=ROOT, text=True).splitlines()
allowed = {
    GAME, "Games/AGENTS.md", "Games/Source/source-SourceV1.lua",
    "docs/auto-steal.md", "tools/check_steal_source.py",
}
assert set(changed) <= allowed, f"Out-of-scope file changes: {set(changed) - allowed}"
subprocess.run(["git", "diff", "--check"], cwd=ROOT, check=True)
print("Static Sena reference, N3 movement, filters, swap and Instant/Line Drop boundary checks passed.")
print("No code executed; no live/server/FPS validation performed.")

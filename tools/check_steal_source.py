"""Static integration checks only; never simulates Roblox or server acceptance."""
from pathlib import Path
import hashlib
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
source = ROOT / "Games/Source/Chili-SourceV1.lua"
runtime = (ROOT / "Games/Steal-An-Egg.lua").read_text()
raw = source.read_bytes()
blob = hashlib.sha1(b"blob " + str(len(raw)).encode() + b"\0" + raw).hexdigest()
assert blob == "8d7fa550e7ffd84b7979d2cdb24acad005d85590", (
    "Chili reference changed: review its changes and update docs/check baseline intentionally"
)
assert not re.search(r"\bfn\d+\b", runtime), "Numbered decompiler functions remain in runtime"
assert re.findall(r"Engine\.SetAntiGuard\(([^\n)]*)\)", runtime) == ["State"], (
    "Only the UI callback may change the Anti Guard preference"
)
for name in ("MoveToPosition", "RecoverDroppedEgg", "RunNormalCycle", "DeliverCarriedEgg"):
    assert len(re.findall(r"local function " + name + r"\(", runtime)) == 1, name
assert "Engine.AutoNoclip" not in runtime
assert "Engine.AutoPendingDeliveryUid" not in runtime
assert "Engine.AutoDeliveryConfirmed" not in runtime
assert "TweenSpeed = 600" in runtime and "AutoTweenSpeed = 400" in runtime
assert "Engine.MaintainShieldHealth()" in runtime
assert "cycle.GuardHits" in runtime and "cycle.CancelMotion" in runtime
assert "while elapsed < droppedRecoveryTimeout" in runtime
assert "Engine.Carry.LineDrop or not Engine.Guard.Enabled" in runtime
assert "Engine.RecordAutoTrace(\"home-drop\"" in runtime
assert "if #trace >= 16 then" in runtime
subprocess.run(["git", "diff", "--check"], cwd=ROOT, check=True)
print("Static reference/integration checks passed. No live/server validation performed.")

"""Built-in safe-zone presentation boundaries. Not a Roblox or FPS test."""
from pathlib import Path
import hashlib
import re
from steal_visual_scope import strip_builtin_visual

ROOT = Path(__file__).resolve().parents[1]
runtime = (ROOT / "Games/Steal-An-Egg.lua").read_text()
reference = (ROOT / "Games/Source/StealAnEgg/SenaV2.lua").read_bytes()
blob = b"blob " + str(len(reference)).encode() + b"\0" + reference
assert hashlib.sha1(blob).hexdigest() == "a36898ee403cacf3aa9742bfb9f9270f867cb765", "Sena reference changed"

# c89e8a0's production game, before promoting the user-tested presentation.
# Only the marked presentation bodies and explicit legacy camera predicates strip.
normalized = strip_builtin_visual(runtime)
assert hashlib.sha256(normalized.encode()).hexdigest() == "5a4350a7207136682561076b298c2c4f4cad0b7ecbe83ae781ca7cd074c86651", (
    "Gameplay outside the reviewed visual additions changed; review before updating this baseline"
)
assert not (ROOT / "Games/Steal-An-Egg-V2.lua").exists(), "Retire the standalone tester"
for retired in ("SafeZoneVisualV2", "V2 Test", "Toggle_Farm_SafeZoneVisual", "BEGIN V2"):
    assert retired not in runtime, f"Test-only setting remains: {retired}"
assert runtime.count('-- BEGIN BUILTIN STEAL VISUAL') == 1
assert runtime.count('-- BEGIN BUILTIN VISUAL DISGUISE GUARD') == 1
start = runtime.index('-- BEGIN BUILTIN STEAL VISUAL')
visual = runtime[start:runtime.index('-- END BUILTIN STEAL VISUAL', start)]
for contract in (
    "CFrame.new(544.76, 71.5, -416.48)", "pcall(character.Clone, character)",
    "character.Archivable = archivable", "decoy:PivotTo(",
    'instance.LocalTransparencyModifier = 0', 'instance.Anchored = true',
    'instance.CanCollide, instance.CanTouch, instance.CanQuery = false, false, false',
    '"LocalTransparencyModifier", 1', '"SpeedGainPopup"', '"PlusOne"',
    'instance[saved.Property] = saved.Value', 'camera.CameraSubject = humanoid or saved.Subject',
    'Enum.RenderPriority.Camera.Value - 1', 'camera.CameraSubject = state.Humanoid',
    'camera.CameraType = saved.Type', 'RunService:UnbindFromRenderStep(bindName)',
    'connection:Disconnect()', 'state.Decoy:Destroy()',
    'visual.Character == cycle.Character', 'visual.RealHumanoid == cycle.Humanoid',
    'cycle.Humanoid.Died:Connect', 'LocalPlayer.Character ~= state.Character',
    'not RaceOwnsCharacter()', 'owner == nil or owner == "steal"',
    'return cancelNormalSteal(...)', 'LibraryLoader:OnUnload(Engine.StopSafeZoneVisual)',
    'not part0:IsDescendantOf(decoy)', 'not part1:IsDescendantOf(decoy)',
):
    assert contract in visual, f"Missing visual lifecycle contract: {contract}"
assert visual.count('pcall(character.Clone, character)') == 1
assert visual.count('RunService:BindToRenderStep(') == 1
assert ':InvokeServer(' not in visual and ':FireServer(' not in visual
assert not re.search(r'(?:state|cycle)\.(?:Root|Character|RealHumanoid)\.(?:CFrame|Position|Anchored|Health|WalkSpeed|PlatformStand)\s*=', visual)
update = visual[visual.index('local function UpdateVisual()'):visual.index('local function CreateVisual(')]
assert 'GetDescendants' not in update and ':Clone(' not in update
assert 'Heartbeat:Connect' not in visual and 'RenderStepped:Connect' not in visual
# One shared accepted-movement hook covers normal cycles, Instant cycles and
# the carried-egg retry path; neither mode gets a new picker/movement worker.
assert 'local claimMovement = Engine.ClaimMovement' in visual
assert 'local accepted = claimMovement(owner, ...)' in visual
assert 'if accepted and owner == "steal" then' in visual
assert 'Engine.StartSafeZoneVisual()' in visual
assert 'FarmConfig.' not in visual, "The built-in visual must not have an opt-in or mode exclusion"
assert 'Engine.Carry.LineDrop' not in visual
assert 'Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual()' in runtime
assert 'character:FindFirstChild("HumanoidRootPart")' in visual
assert 'character:FindFirstChildOfClass("Humanoid")' in visual
print('PASS: exact Sena reference; no standalone tester or visual toggle; one shared normal/Instant visual controller.')
print('PASS: removing only reviewed presentation additions reproduces the complete pre-promotion gameplay baseline.')
print('PASS: reuse, reversible visibility/camera, cancellation/unload and no visual remote or real-root movement.')
print('Static checks only: normal V2 was user-confirmed live; the promoted Instant integration still needs live testing.')

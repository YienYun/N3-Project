"""Static scope checks for the standalone visual V2. Not a Roblox or FPS test."""
from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
production = (ROOT / "Games/Steal-An-Egg.lua").read_text()
v2 = (ROOT / "Games/Steal-An-Egg-V2.lua").read_text()
reference = (ROOT / "Games/Source/StealAnEgg/SenaV2.lua").read_bytes()
blob = b"blob " + str(len(reference)).encode() + b"\0" + reference
assert hashlib.sha1(blob).hexdigest() == "a36898ee403cacf3aa9742bfb9f9270f867cb765", "Sena reference changed"

pattern = re.compile(
    r"^(?P<indent>[\t ]*)-- BEGIN V2 (?P<label>[A-Z ]+)\n.*?"
    r"^[\t ]*-- END V2 (?P=label)\n", re.MULTILINE | re.DOTALL
)
blocks = {}


def remove_visual_only(match):
    label = match["label"]
    assert label not in blocks, f"Duplicate V2 block: {label}"
    blocks[label] = match[0]
    if label in ("VISUAL LOADING TITLE", "VISUAL WINDOW TITLE"):
        return match["indent"] + 'Title = "N3 HUB",\n'
    return ""


normalized = pattern.sub(remove_visual_only, v2)
assert set(blocks) == {
    "VISUAL HEADER", "VISUAL CONFIG", "VISUAL DISGUISE GUARD",
    "VISUAL CAMERA GUARD", "VISUAL CYCLE HOOK", "SAFE ZONE VISUAL",
    "VISUAL UI", "VISUAL LOADING TITLE", "VISUAL WINDOW TITLE",
}, "Missing or unexpected V2 integration block"
assert normalized == production, (
    "V2 differs outside the explicit visual additions: normal lifecycle, N3 movement, "
    "filters, remotes, race, Instant/Line Drop and production loader must stay unchanged"
)
assert "SafeZoneVisualV2" not in production, "Experiment leaked into production"
visual = blocks["SAFE ZONE VISUAL"]
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
    'not FarmConfig.Defense_InstantSteal', 'not Engine.Carry.LineDrop',
    'not RaceOwnsCharacter()', 'owner == nil or owner == "steal"',
    'return cancelNormalSteal(...)', 'LibraryLoader:OnUnload(Engine.StopSafeZoneVisualV2)',
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
assert v2.count('"Toggle_Farm_SafeZoneVisualV2"') == 1
assert 'Engine.StartSafeZoneVisualV2(cycle)' in blocks['VISUAL CYCLE HOOK']
assert 'engine.StopSafeZoneVisualV2()' in blocks['VISUAL UI']
print('PASS: unchanged Sena reference and standalone V2 scope; stripping nine explicit visual additions reproduces production byte-for-byte.')
print('PASS: decoy reuse, reversible presentation, camera ownership, cancellation/unload and no visual-block remote or real-root movement.')
print('Static source checks only: no Roblox execution, server acceptance or measured FPS result.')

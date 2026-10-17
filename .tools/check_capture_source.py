"""Static Capture source contracts, not a simulated/live Roblox acceptance test."""
from pathlib import Path
import hashlib
import re
from capture_scope import strip_capture, ORIGINALS
from admin_scope import strip_admin

root = Path(__file__).resolve().parents[1]
raw = (root / 'Games/Steal-An-Egg.lua').read_text()
# Strip any newer Admin Abuse block so the historical 6d4af13 baseline is reached.
s = strip_admin(raw) if '-- BEGIN ADMIN CONTROLLER' in raw else raw
assert hashlib.sha256(strip_capture(s).encode()).hexdigest() == 'c80088233a73ffeee82bf9f75b82bea7d61e0bf89e16edc7f1a812bf031f60b2', 'Changes escaped reviewed Capture additions / published 6d4af13'
for filename, expected in {
    'Games/Source/StealAnEgg/ChiliSourceV2.lua': '0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d',
    'Games/Source/StealAnEgg/SenaV2.lua': '7f91e174f5a365cf2d44dadf60f8a055c831cdbd867036055845bd4755a4f9c2',
    'Library/N3V3-NoObfus.lua': '40f109dcd89d6573dab8f584b4407882f51777140f8c914d832eea948a892b8e',
}.items():
    assert hashlib.sha256((root / filename).read_bytes()).hexdigest() == expected, filename
for label in ORIGINALS:
    assert s.count('-- BEGIN CAPTURE ' + label + '\n') == 1, label
    assert s.count('-- END CAPTURE ' + label + '\n') == 1, label
c = s[s.index('-- BEGIN CAPTURE CONTROLLER'):s.index('-- END CAPTURE CONTROLLER')]
for clause in (
    '"Event_CaptureTheEggUid"', '"Event_CaptureTheEgg"', '"Event_CaptureTheEggGameplay"',
    'EggStateModule.ReadFieldEgg, uid', 'EggStateModule.ReadFieldEggs',
    'record.CarrierUserId', 'Players:GetPlayerByUserId(carrierId)', 'eventUid() == uid',
    '"CaptureTheEggSpawn", "AdminAbuseEggSpawn"', '"AreaEggSlotsClient"', '"EggCarryBounds"',
    'part.Name ~= "SafeZone"', 'part.Size.X > 60 and part.Size.Z > 60', 'state.BoundsAt',
    'box.MinX + 14, box.MaxX - 14, 50', 'middle - spread, middle, middle + spread',
    'state.KeepAway / 32', 'state.KeepAway + 10', 'os.clock() - state.HoverAt >= 0.25',
    'score > best or score == best and travel < fallbackDistance',
    '"SmartPromptPart"', '"CarryAreaEgg"', 'local duration = prompt.HoldDuration',
    'prompt.HoldDuration = duration', 'Magnitude + 1.5 < distance',
    'os.clock() + 1.4', 'os.clock() - requestedAt >= 0.08',
    'Tasks.CaptureCallOwned(job, EggStateModule.CarryFieldEgg, uid, slot)',
    'if heldByMe(uid, record) then return true end',
    'distance > 220 and not blocked', 'distance <= 220', 'os.clock() + 4', 'os.clock() + 2',
    'job.Transit.RagdollTravel', 'carrier > 0 and carrier ~= LocalPlayer.UserId then return nil',
    'job.Transit.CaptureArrival', 'local deadline = os.clock() + 8', 'job.Transit:Approach', 'engine.WallSealed() or engine.IsNight()',
    'job.HealthStop()', 'Holding egg; waiting for carry bounds', 'job.Transit:ControlGround', 'glide(job, goal, 220, dt)',
    'goal, elapsed = Vector3.new', 'while elapsed < 1.5 and job.Safe()', 'delta.Unit * 160 * dt',
    'RunService.PreSimulation:Connect', 'pcall(steer, job, plan, dt)',
    'Tracks = setmetatable', 'PendingHits = {}', '0.12, 0.2, 0.28, 0.36, 0.46, 0.6',
    'samples[1].Time > 0.12', 'measured.Magnitude <= 1500', 'track.Smooth:Lerp(horizontal, 0.25)',
    'math.sqrt(2 * math.log(total + 2)', 'state.PendingHits',
    'RagdollBefore + 0.01', 'CooldownBefore + 0.01',
    '"IsTrapped"', '"InBossArena"', 'not engine.InsideBase(root.Position)',
    '"IsBat"', '"GearName"', 'BatControllerData', 'RangeBonus', '"Gears"',
    '"DragonEggEventActive"', '(17 + batBonus(tool))',
    '"COLLISIONS"', '"GUARD NO COLLIDE"', '"WALL LEFT"', '"WALL RIGHT"',
    'state.WallSides[wall]', 'for step = 1, 6', 'Vector3.new(0, -400, 0)',
    'horizon + ping - math.clamp(ping + 0.05', 'ping + horizon + 0.18 - 0.275',
    'aboveFloor(Vector3.new(goal.X, goal.Y, root.Position.Z))',
    'math.min(400 + plan.Velocity.Magnitude, 750)', 'Workspace.Gravity * dt * 0.5',
    '"PvPDisabled"', '"RE/BatSwing/Trigger"', 'tool.Parent ~= job.Character',
    'current.CarrierUserId) ~= player.UserId', 'math.max(0.12, plan.Ping * 1.5)',
    'pcall(trigger.FireServer, trigger, player, string.format("%d:%d:%d"',
    '"RE/EggCapture/StandingsRefreshed"', 'payload.Entries or payload.Standings or payload',
    'tonumber(entry.UserId) == LocalPlayer.UserId', 'tonumber(entry.Seconds), tonumber(entry.Rank) or index',
    'if not enabled() or raceWanted()', 'state.Disposed, state.Generation',
    'state.Steering = steering', 'Tasks.StopCaptureSteering()',
    'tab:AddLeftGroupbox("Capture The Egg", "flag")',
    'FarmConfig.Capture_Auto, FarmConfig.Capture_TakeHolder = false, true',
    'Text = "Auto Capture Egg", Default = false', 'Text = "Take From Holder", Default = true',
    'Min = 20, Max = 120, Default = 45', 'Min = 20, Max = 150, Default = 45',
):
    assert clause in c, f'Missing Capture source/lifecycle contract: {clause}'
assert 'task.spawn(' not in c and 'task.defer(' not in c, 'Capture must use the existing shared action worker'
assert c.count('RunService.PreSimulation:Connect') == 1 and c.count('RunService.Heartbeat:Connect') == 1
assert ':AddTab(' not in c and 'events:AddGroupbox' not in c
for control in ('Toggle_Capture_Auto', 'Toggle_Capture_TakeHolder', 'Slider_Capture_Height', 'Slider_Capture_KeepAway'):
    assert s.count('"' + control + '"') == 1, control
assert raw.count('Tasks.BuildCaptureUI(AdminTab)') == 1
assert raw.count('function Tasks.BuildCaptureUI(') == 1
assert 'runOwned("capture", "Capture", state, allowed, action)' in s
assert 'if Tasks.CaptureWanted and Tasks.CaptureWanted() then Tasks.RunCapture(); updateDemand() end' in s
assert 'if key == "Capture" then return false end' in s
assert s.index('if raceWanted() then return true end', s.index('local function higherTask(key)')) < s.index('if key == "Capture" then return false end')
assert 'if owner == "capture" and uid == Workspace:GetAttribute("Event_CaptureTheEggUid") then continue end' in s
assert 'owner == "capture" and self.CaptureArrival' in s
assert 'not Tasks.CaptureOwnsEgg() and activeJob == nil and nativeActive()' in s
assert 'if owner == "steal" and Tasks.CaptureOwnsEgg() then return false end' in s
assert 'owner == "capture" and Tasks.StopCaptureSteering then Tasks.StopCaptureSteering()' in s
for pattern in (r'FarmConfig\.(?!Capture_\w+\b)\w+\s*=(?!=)', r'RuntimeState\.\w+\s*=(?!=)', r'engine\.Movement\.\w+\s*=(?!=)', r'state\.Seconds\s*\+='):
    assert not re.search(pattern, c), pattern
assert 'CaptureUntil =' not in c and ':BreakJoints(' not in c and '.Health = 0' not in c
assert 'AskClaim' not in c and 'AskPlaceEgg' not in c and ':Activate(' not in c
assert 'job.Transit.Ground =' not in c, 'Do not fake transport modes from the controller'
assert 'Instance.new(' not in c, 'No imported rig or movement controller'
print('PASS: exact Capture-only reversal to published 6d4af13; all prior gameplay, unified Butterfly UI, Library and immutable references preserved.')
print('PASS: real event UID/carrier, raw carry/prompt protocol, generic non-event ragdoll starter, holding footprint/threat geometry and server standings.')
print('PASS: semantic combat prediction/walls/steering, bat cooldown/trace/holder eligibility; no fake score, hit, reward or bank/deposit action.')
print('PASS: Home farm group, safe auto OFF/source holder ON defaults, reuse one action worker/lease, race-first and guarded cancellation/cleanup.')
print('Static source/compile evidence only; no Roblox event, death/route, reward, netcode or FPS success is claimed.')

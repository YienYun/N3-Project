"""Static repair contracts, NOT a simulated route or live Roblox acceptance test."""
from pathlib import Path
from bloom_star_scope import strip_bloom_star
import hashlib
from banjo_scope import strip_banjo
from quest_transit_scope import strip_quest_transit, FOREST_DOOR_SCOPES
from admin_scope import strip_admin

root = Path(__file__).resolve().parents[1]
s = (root / 'Games/Steal-An-Egg.lua').read_text()
if '-- BEGIN ADMIN CONTROLLER' in s:
    s = strip_admin(s)
if '-- BEGIN BLOOM STAR' in s:
    s = strip_bloom_star(s)
# Frozen pre-Banjo baseline: only reviewed quest transport scopes may be normalized.
assert hashlib.sha256(strip_banjo(s).encode()).hexdigest() == '5aad190a781dd2b976865836bc56e26873b76b270604f184d41b25ad7789f9ec'
normalized = strip_quest_transit(s)
assert '-- BEGIN QUEST TRANSIT' not in normalized
q = s[s.index('-- BEGIN QUEST TRANSIT CONTROLLER'):s.index('-- END QUEST TRANSIT CONTROLLER')]
w = s[s.index('-- BEGIN QUEST TRANSIT WISP TRAVEL'):s.index('-- END QUEST TRANSIT WISP TRAVEL')]
b = s[s.index('-- BEGIN BANJO CONTROLLER'):s.index('-- END BANJO CONTROLLER')]
for clause in (
    'owner == "wisp" or owner == "banjo"', 'engine.Movement.Owner == owner and not RaceOwnsCharacter()',
    'LocalPlayer.Character == character', 'character:FindFirstChild("HumanoidRootPart") == root',
    'character:FindFirstChildOfClass("Humanoid") == humanoid', 'not self.Active then return end',
    'heartbeat:Disconnect()', 'stepped:Disconnect()', 'if self.Active and self.Owns()',
    'humanoid.PlatformStand = savedPlatform', 'not FarmConfig.Movement_Noclip',
    'part:IsDescendantOf(character)', 'part.CanCollide = false',
    'humanoid:ChangeState(Enum.HumanoidStateType.Freefall)',
    'if not self.Owns() or LibraryLoader.Unloaded or not valid()',
    'if arrived and arrived() then result = true; self:Stop(); return end',
    'cursor += difference.Magnitude <= speed * dt and difference or difference.Unit * speed * dt',
    'delta.Unit * math.min(speed, delta.Magnitude / math.max(dt, 1 / 60))',
    'local height = math.max(root.Position.Y, destination.Y) + 30',
    'Vector3.new(root.Position.X, height, root.Position.Z)', 'Vector3.new(destination.X, height, destination.Z)',
    'engine.GetBaseSafeSpot()', 'destination }, 120, cancel, arrived, "tween")', 'if leg == #points then result = true; self:Stop(); return end',
    'LibraryLoader:OnUnload(function() if active then active:Stop() end end)',
):
    assert clause in q, f'Missing shared transport contract: {clause}'
assert q.count('RunService.Heartbeat:Connect(') == 2, 'One flight heartbeat and one scoped source health monitor'
assert q.count('RunService.Stepped:Connect(') == 1
assert 'task.spawn(' not in q and 'Instance.new(' not in q, 'No new movement worker or swap/flight rig'
for scope in (q, w, b):
    assert ':BreakJoints(' not in scope and '.Health = 0' not in scope, 'No automatic quest reset'
assert 'Tasks.NewQuestTransit("wisp", character, humanoid, root' in w
assert 'transit:Approach(' not in w, 'Wisp must use its own source transport, not the general FlyTo route'
assert 'transit:RagdollTravel(' in w and 'humanoid:MoveTo(position)' in w
assert w.index('Magnitude > 40') < w.index('transit:RagdollTravel(') < w.index('if not ok then') < w.index('humanoid:MoveTo(position)')
assert 'character:PivotTo(' not in w, 'Never fall through from a failed Forest transport to a bare far pivot'
assert 'Magnitude > 1200' not in w, 'Latest explicit Forest carry request supersedes the source far-pivot fallback'
assert 'Tasks.NewQuestTransit("banjo", character, humanoid, root' in b
assert 'and (finishing or (enabled() and generation == state.Generation))' in b
assert 'local approach = position + Vector3.new(0, 3, -12)' in b
entry = b[b.index('local function enterTree()'):b.index('local function enterRoom()')]
assert entry.index('Magnitude > 60') < entry.index('transit:RagdollTravel(') < entry.index('if not moved then') < entry.index('transit:Settle(') < entry.index('Magnitude > 30') < entry.index('character:PivotTo(')
assert 'transit:Approach(' not in entry and 'transit:FlyTo(' not in entry and 'Magnitude > 500' not in entry
assert entry.index('Door TP not confirmed') < entry.index('for attempt = 1, 4'), 'Local door pivot cannot become a world fallback'
assert 'heldForest or (not IsActivelyCarryingEgg()' in b, 'Already-held Forest egg must not deadlock quest admission'
assert 'local above = position + Vector3.new(0, 18, 0)' in b
rise = b.index('local leapRoute = { Vector3.new(root.Position.X, above.Y, root.Position.Z), above }')
cross = b.index('transit:FlyTo(leapRoute, 120')
fall = b.index('Secret Leap: falling through the hint')
confirm = b.index('waitFor(8, inRoom)')
assert rise < cross < fall < confirm, 'Rise -> cross -> end flight -> natural fall/actual room confirmation'
assert 'engine.Lift(' not in b and 'walk(floor(position)' not in b and 'PathfindingService' not in b
assert 'transit:FlyTo(stance, 60' in b and 'fly(route, 60' in b
assert 'fly(marker("SecretRoomExit", roomExit), 60' in b
assert 'transit:Approach(exit' in b and 'state.ExitFailed = true' in b
assert b.index('if transit then transit:Stop() end\n\t\tengine.ReleaseMovement("banjo")') > b.index('pcall(leave)')
for method, label in [('MobilityRecoveryHeartbeat', 'MOBILITY GUARD'), ('DefenseHeartbeat', 'DEFENSE GUARD')]:
    function = s[s.index('function Tasks.' + method + '()'):]
    assert function.startswith('function Tasks.' + method + '()\n\t-- BEGIN QUEST TRANSIT ' + label)
    assert 'if Tasks.QuestTransitOwnsActor and Tasks.QuestTransitOwnsActor() then return end' in function[:350]
r = q[q.index('function transit:RagdollTravel('):q.index('function transit:Settle(')]
for contract in (
    'selectTravelEgg(root.Position, {})', 'RE/GuardPatrol/ForestStrike',
    'self.Active, self.Ragdoll, active = true, true, self', 'Tasks.ResumeRaceRigSync()',
    'states[state] = humanoid:GetStateEnabled(state)', 'humanoid:SetStateEnabled(state, true)',
    'for _ = 1, 3 do', 'elapsed < 2.5', 'candidate.At + Vector3.new(0, 3, 0)',
    'pcall(EggStateModule.CarryFieldEgg, candidate.Uid, candidate.Slot)',
    'elapsed > 0.4', '"closer"', 'excluded[candidate.Uid] = true',
    'GetAttributeChangedSignal("RagdollEndTime")', 'landed = snap(destination)',
    'strike:FireServer({ EggUid = taken.Uid, GuardCFrame = taken.Guard.CFrame })',
    'os.clock() + 3', 'dropTaken()', '"PlayerRequest"',
    'while (tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) > Workspace:GetServerTimeNow()',
    'not self.Ragdoll or not self.Owns()', 'dropSent = true', 'if held and self.Owns() then',
    'RunService.Heartbeat:Wait()', 'if released then return end', 'self.RagdollStop()',
):
    assert contract in r, f'Missing actual source RagdollTravel dependency: {contract}'
assert r.index('strikeConnection = LocalPlayer:GetAttributeChangedSignal') < r.index('strike:FireServer(')
assert r.index('strike:FireServer(') < r.index('while not landed') < r.index('if not landed then return false')
assert 'self:Approach(' not in r and 'self:FlyTo(' not in r, 'RagdollTravel is not free flight or a tween alias'
assert 'return visible or nearest' in q and 'record.CarrierUserId' in q
# Exact extra integration scopes must be present; all historical hashes above remain frozen.
for label, (block, _) in FOREST_DOOR_SCOPES.items():
    assert s.count('-- BEGIN QUEST TRANSIT ' + label) == 1 and s.count(block) == 1
forest = q[q.index('local function forestSlot('):q.index('function Tasks.NewQuestTransit(')]
assert 'record.AreaId == "Forest"' in forest and '^Forest:Slot_%d+$' in forest
assert 'tonumber(record.CarrierUserId) == LocalPlayer.UserId' in forest
select = q[q.index('local function selectTravelEgg('):q.index('function transit:RagdollTravel(')]
assert 'local slot = forestSlot(record, uid)' in select and 'engine.FindGuard("Forest")' in select
for clause in (
    'local heldForest = Tasks.QuestHeldForestEgg()', 'if not heldForest and not selectTravelEgg(',
    'taken = heldForest', 'if taken then break end', 'if not heldForest then humanoid:UnequipTools() end',
    'landOnWindow()', 'if not landed then strike:FireServer(',
    'humanoid.BreakJointsOnDeath, humanoid.RequiresNeck = false, false',
    'humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)',
    'humanoid.Health = humanoid.MaxHealth', 'not self.ActorMatches()',
    'humanoid.HealthChanged:Connect(protectHealth)', 'humanoid.StateChanged:Connect(protectHealth)',
    'GetPropertyChangedSignal("MaxHealth"):Connect(protectHealth)', 'if healthElapsed >= 0.5 then',
    'for _, link in ipairs(healthLinks) do link:Disconnect() end',
    'healthSaved.BreakJointsOnDeath, healthSaved.RequiresNeck', 'healthSaved.DeadEnabled',
):
    assert clause in r, f'Missing Forest door / source health lifecycle contract: {clause}'
assert r.index('healthSaved = {') < r.index('humanoid.HealthChanged:Connect(protectHealth)') < r.index('pcall(EggStateModule.CarryFieldEgg')
assert r.index('strikeConnection = LocalPlayer:GetAttributeChangedSignal') < r.index('landOnWindow() -- Reuse') < r.index('if not landed then strike:FireServer(')
assert 'humanoid.Health > 0' in q[q.index('function transit.Owns()'):q.index('function transit:Stop()')]
# Health may heal its own zero-health actor, but never uses a dead actor as permission to move.
assert 'Health' not in q[q.index('function transit.ActorMatches()'):q.index('function transit.Owns()')]
for scope in (q, w, b):
    assert 'SetAttribute("RagdollEndTime"' not in scope, 'Do not manufacture a server ragdoll window'
# TriggerGuardDodge was ALREADY blocked by both lease adapters; don't misidentify it as a new fix.
assert s.count('dodgeAdapter = function(...) if not state.Lease then return nativeDodge(...) end end') == 2
assert 'Tasks.QuestHeldForestEgg() then return false end' in s
print('PASS: frozen historical boundaries, plus three exact reviewed Forest-door integration additions.')
print('PASS: Forest-only selection / reuse held egg -> real server ragdoll window -> direct destination snap; no failed-jump far fallback.')
print('PASS: scoped source health/neck/dead protection, event cleanup, same-actor restoration and existing race-first cancellation.')
print('Static source evidence only. 36128e6 failed live; this correction is not live-confirmed.')

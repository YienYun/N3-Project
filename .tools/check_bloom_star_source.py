"""Static source/lifecycle contracts, not a Roblox simulation or live acceptance test."""
from capture_scope import strip_capture
from pathlib import Path
import hashlib
import re
from bloom_star_scope import strip_bloom_star, LABELS
from admin_scope import strip_admin

ROOT = Path(__file__).resolve().parents[1]
s = (ROOT / 'Games/Steal-An-Egg.lua').read_text()
if '-- BEGIN ADMIN CONTROLLER' in s:
    s = strip_admin(s)
if "-- BEGIN CAPTURE" in s:
    s = strip_capture(s)
assert hashlib.sha256(strip_bloom_star(s).encode()).hexdigest() == 'eee92fee27ef82050171e80076e291b23ce98d46876d20e5dd2f3dada470962c', 'Changes escaped reviewed additions / published 7e9549a'
assert hashlib.sha256((ROOT / 'Games/Source/StealAnEgg/ChiliSourceV2.lua').read_bytes()).hexdigest() == '0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d'
c = s[s.index('-- BEGIN BLOOM STAR CONTROLLER'):s.index('-- END BLOOM STAR CONTROLLER')]
control = s[s.index('-- BEGIN BLOOM STAR TRANSIT CONTROL'):s.index('-- END BLOOM STAR TRANSIT CONTROL')]
for label in LABELS:
    assert s.count('-- BEGIN BLOOM STAR ' + label + '\n') == 1
    assert s.count('-- END BLOOM STAR ' + label + '\n') == 1
for clause in (
    'star.AskBusy', 'os.clock() + 15', 'generation == star.Generation and revision == star.Revision',
    '"RF/ShootingStar/AskState"', '"RE/ShootingStar/Fall"', '"RE/ShootingStar/Wander"',
    '"RE/ShootingStar/Slipped"', '"RE/ShootingStar/Claimed"', '"RE/ShootingStar/Expired"',
    '"ShootingStarClient", "Buddy"', 'leg.From:Lerp(leg.To, alpha)', 'payload.Landing.Position',
    'payload.LandAt', 'payload.ExpiresAt', '(tonumber(payload.HoldSeconds) or 1.6) + 0.3',
    'star.HoldStarted = nil', 'fire("RE/ShootingStar/Hold", payload.Id, true)',
    'fire("RE/ShootingStar/Catch", payload.Id)', 'fire("RE/ShootingStar/Hold", payload.Id, false)',
    'os.clock() - catchAt >= 2', 'tries % 3 == 0', 'star.Caught += 1',
    'star.RagdollTried[payload.Id]', 'stepToStar(job, target)', 'glideToStar(job, target)',
    'engine.Carry.HopRatio', 'engine.Carry.HopLift', 'engine.Carry.HopGap', 'stalled >= 2',
    'math.min(0.25 + 0.25 * rollbacks, 1)', 'math.max(0.5, 0.8 ^ (rollbacks - 1))',
    'math.clamp(ok and tonumber(ping) or 0, 0, 1) * 2', 'velocity.Magnitude > 200',
    '"Shared", "Modules", "ButterflyCatalog"', '"Events", "ButterflyBloom", "Swarm"',
    '"Shared", "Flags", "ButterflyFlags"', 'swarm.Each()', 'catalog.PositionAt', 'catalog.VelocityAt',
    '"RE/Butterflies/Spawned"', '"RE/Butterflies/Removed"', '"RE/Butterflies/Escaped"',
    '"Event_ButterflyBloom"', '"ButterflyBloomEndsAt"', '"RF/Butterflies/AskClaimNet"',
    '"RF/Butterflies/AskTradeUp", tier', 'callOwned(job, invoke, "RF/Butterflies/AskCraftEssence")',
    'data.Butterflies', 'record.NetClaimed', 'record.TotalCaught', 'record.Counts', 'record.Essence',
    '"GreenToBlueCost"', '"BlueToPurpleCost"', '"PurpleToGoldenCost"', '"Essence" .. tier',
    'bloom.Mode ~= "Chase"', 'bloom.Mode == "Circle"', 'bloom.PatrolTravel', 'bloom.CircleAngle',
    'bloom.Reach - 2', '(5 - (rarityRank[butterfly.Tier] or 1)) * 1000', 'Until = os.clock() + 1',
    'ragdollTries >= 2', 'os.clock() + 10', 'job.Wait(1.5)', 'Magnitude >= 1200',
    '"World", "Machines", "ButterflyStation"', '"ButterflyMachine"', '"MutationShrine"',
    '"EnchantedTreeUnlocked"', '"InEnchantedTree"', '"EnchantedTreePrompt"',
    'if not enterWorkshopTree(job)', 'leaveWorkshopTree(job)', 'treeMarker("ExitTrigger")',
    '"PathfindingService"', 'point - exit).Magnitude < 14',
    'for amount = 60, 1, -1', 'amount * bloom.Recipe.Green + bloom.TradeCost.Green * greenTrades',
    'for _ = 1, 50 do', 'job.Wait(0.15)', 'job.Wait(0.3)', 'bloom.NextTrip = os.clock() + 60',
    'bloom.PendingMachine = pending', 'pending.Counts[pending.From] - pending.Cost',
    'pending.Counts[nextTier[pending.From]] + 1', 'bloom.Essence >= pending.Essence + 1',
    'pending.Counts[tier] - pending.Recipe[tier]', 'if ok and accepted == false then',
    'if bloom.PendingMachine then return end', 'not remote(requestName, "RemoteFunction")',
    'not remote("RF/Butterflies/AskClaimNet", "RemoteFunction")', 'bloom.NetPending',
    'local externalCarry = activeJob == nil', 'and not externalCarry and payload ~= nil',
    'engine.ClaimMovement(owner)', 'engine.ReleaseMovement(owner)', 'not nativeIdle()',
    'return stopped or not actorMatches()', 'LocalPlayer.Character == character',
    'character:FindFirstChildOfClass("Humanoid") == humanoid', 'engine.Movement.Owner == owner',
    'job.PendingCall = true', 'activeJob.ReleasePending()', 'job.Aborted = true',
    'if activeJob and activeJob.Aborted then', 'return not job.Aborted', 'if ownsBody() and humanoid.Health > 0',
    'job.HealthStop', 'humanoid.HealthChanged:Connect(job.HealthTick)', 'job.HealthTick()',
    'job.Humanoid:EquipTool(net)', 'job.Finishing or not cancelled()',
    'owner ~= activeJob.Owner and owner ~= "race"', 'return activeJob == nil and nativeActive()',
    'if activeJob then return true end', 'if key == "Star" then return star.Wanted end',
    'if key == "Butterfly" then return bloom.Wanted end', 'not state.Lease',
):
    if clause == 'not state.Lease':
        assert clause in s  # Previously approved quest adapters remain intact.
    else:
        assert clause in c, f'Missing source/lifecycle contract: {clause}'
for filename, expected in {
    'Library/N3V3-NoObfus.lua': '40f109dcd89d6573dab8f584b4407882f51777140f8c914d832eea948a892b8e',
    'Games/Source/StealAnEgg/SenaV2.lua': '7f91e174f5a365cf2d44dadf60f8a055c831cdbd867036055845bd4755a4f9c2',
}.items():
    assert hashlib.sha256((ROOT / filename).read_bytes()).hexdigest() == expected, filename
assert c.count('star.Caught += 1') == 1
claimed = c[c.index('bind("RE/ShootingStar/Claimed"'):c.index('bind("RE/ShootingStar/Expired"')]
assert 'star.Caught += 1' in claimed
assert c.count('task.spawn(') == 2, 'One job worker + one single-flight read-only AskState request, not parallel movement jobs'
assert control.count('RunService.Stepped:Connect(') == 1
assert 'task.spawn(' not in control and 'Instance.new(' not in c + control
assert 'assert(active == nil' in control and 'self.ControlStop = function()' in control
assert 'self.ActorMatches()' in control and 'self.Owns()' in control
assert c.index('bloom.PendingMachine = pending') < c.index('callOwned(job, invoke, "RF/Butterflies/AskTradeUp", tier)')
assert c.index('job.HealthTick()') < c.index('job.Transit = Tasks.NewEventTransit')
assert not re.search(r'engine\.Movement\.Owner\s*=(?!=)', c), 'Never force another owner out of its lease'
assert 'RuntimeState.IsExecuting =' not in c
for pattern in (r'FarmConfig\.(?!Star_Auto\b|Butterfly_\w+\b)\w+\s*=(?!=)', r'RuntimeState\.\w+\s*=(?!=)'):
    assert not re.search(pattern, c), f'Unrelated flag write: {pattern}'
assert ':BreakJoints(' not in c + control and '.Health = 0' not in c + control
assert 'SetAttribute("RagdollEndTime"' not in c + control
assert not re.search(r'RE/Butterflies/(?:Catch|Swing)|RF/Butterflies/(?:Catch|Swing|AskCatch)', c)
for name in ('Toggle_Star_Auto', 'Toggle_Butterfly_Auto', 'Toggle_Butterfly_Trade', 'Toggle_Butterfly_Smart', 'Toggle_Butterfly_Craft'):
    assert s.count('"' + name + '"') == 1
assert 'events:AddGroupbox({ Name = "Shooting Star"' in c
assert 'events:AddGroupbox({ Name = "Butterfly Bloom"' in c
assert 'local workshop = butterflyTabs:AddTab("Workshop", "flower-2")' in c
assert c.count(':AddTab(') == 2 and c.count(':AddTabbox(') == 1
assert 'local catchGroup = butterflyTabs:AddTab("Catch", "bug")' in c
assert s.count('Tasks.BuildBloomStarUI(EventTab)') == 1
for key in ('Star_Auto', 'Butterfly_Auto', 'Butterfly_Trade', 'Butterfly_Craft'):
    assert 'FarmConfig.' + key in c
assert 'star.Wanted = enabled("Star_Auto") and not raceWanted()' in c
assert 'bloom.Wanted = not raceWanted()' in c
print('PASS: full frozen 7e9549a reversal; existing Forest quests, normal/Instant, race and prior gameplay preserved.')
print('PASS: semantic source Star payload/hold/catch/claim, Butterfly swarm/net/modes/flags and trade/smart/craft protocols.')
print('PASS: Event Butterfly Catch/Workshop subtabs + separate Star; default OFF, one shared job worker, native leases, race-first and owned cleanup.')
print('PASS: server-event counts / save-confirmed consumption, pending RPC protection and no invented butterfly catch remote.')
print('Static source/compile evidence only. No Roblox event, reward, route, death or FPS success is claimed.')

for label, key in [('WISP', 'Wisp'), ('BANJO', 'Wisp'), ('MUTATE', 'Essence')]:
    block = (f'\t\t-- BEGIN BLOOM STAR {label} PRIORITY\n'
             f'\t\tif Tasks.BloomStarOver and Tasks.BloomStarOver("{key}") then return true end\n'
             f'\t\t-- END BLOOM STAR {label} PRIORITY\n')
    assert s.count(block) == 1, f'Unreviewed changes inside {label} cancellation hook'

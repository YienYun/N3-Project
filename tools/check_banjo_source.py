"""Banjo source-contract checks only; never executes/simulates Roblox or reward acceptance."""
from pathlib import Path
import hashlib
import re
from banjo_scope import strip_banjo, QUEST_TABS

ROOT = Path(__file__).resolve().parents[1]
s = (ROOT / 'Games/Steal-An-Egg.lua').read_text()
assert hashlib.sha256(strip_banjo(s).encode()).hexdigest() == '693a7d99189757fedfff69a579da5ed46c32806fd80de28fb3e16ea986bb424d', 'Changes escaped Banjo controller / exact shared-tab replacement (7591d6f)'
assert hashlib.sha256((ROOT / 'Games/Source/StealAnEgg/ChiliSourceV2.lua').read_bytes()).hexdigest() == '0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d'
a, b = s.index('-- BEGIN BANJO CONTROLLER'), s.index('-- END BANJO CONTROLLER')
n = s[a:b]
for contract in (
    'FarmConfig.Banjo_Auto = false', 'FarmConfig.Banjo_Auto == true', 'AddTab("Banjo", "music")',
    'Text = "Auto Banjo Cricket", Default = false', 'Tooltip = "Repeat the mushroom melody."',
    'FindFirstChild("BanjoCricket")', 'FindFirstChild("BanjoCricketFlags")', 'config.Stages:Get()',
    'state.Data.PlaybackSeconds', 'count * 0.65 + 0.5', 'data.BanjoCricket', 'data.Claimed == true',
    '"EnchantedTreeUnlocked"', '"InEnchantedTree"', 'FindFirstChild("EnchantedTreeInterior")',
    'FindFirstChild("EnchantedTreeEntrance")', 'FindFirstChild("EnchantedTreePrompt")',
    'marker("SecretRoomSpawn", roomSpawn)', 'marker("SecretRoomExit", roomExit)', 'marker("ExitTrigger")',
    'FindFirstChild("SecretLeapHint")', 'FindFirstChild("Streaks")', 'local above = position + Vector3.new(0, 18, 0)',
    '"BanjoCricketMushroom", index, mushrooms[index]', '"BanjoCricketNpc", nil, npcFallback',
    'model:GetAttribute("MushroomIndex")', 'local center = Vector3.new(6244.93, 17159.02, 16880)',
    'remote("RE/BanjoCricket/Effect", "RemoteEvent")', 'remote("RE/BanjoCricket/Aim", "RemoteEvent")',
    'remote("RF/BanjoCricket/AskClaim", "RemoteFunction")', 'aim:FireServer(index)',
    'pcall(request.InvokeServer, request)', 'bat:Activate()', 'bat = EquipBatTool()',
    'GetAttribute("CooldownActive")', 'GetAttribute("CooldownEndTime")', 'Workspace:GetServerTimeNow()',
    'message.Kind', 'message.Notes', 'note % 1 ~= 0 or note < 1 or note > 5',
    'state.JobGeneration ~= state.Generation', 'state.Character ~= LocalPlayer.Character', 'not inRoom()',
    'kind == "Playback"', 'kind == "Note"', 'kind == "Wrong"', 'kind == "StageComplete"', 'kind == "Reset"', 'kind == "Solved"',
    'os.clock() + playbackSeconds(#notes)', 'state.Playback ~= version', 'replaced() or bat.Parent ~= character', 'local serial = hit(index, version)', 'state.Wrong > serial',
    'ack.Serial > serial and ack.Mushroom == index', 'ack.Serial = 0', 'waitFor(1.6',
    'os.clock() + 300', 'wakes > 12', 'for _ = 1, 2 do', 'waitFor(2, function()',
    'engine.ClaimMovement("banjo")', 'engine.ReleaseMovement("banjo")', 'Tasks.PriorityRank("Wisp")',
    'return not state.Lease and nativeActive()', 'state.Lease or nativeYield()', 'owner ~= "banjo" and owner ~= "race"',
    'wisp.NativeCalls > 0', 'mutate.InventoryActions > 0', 'belt.WearBusy', 'not IsActivelyCarryingEgg()',
    'generation ~= state.Generation', 'LocalPlayer.Character == character', 'engine.Movement.Owner == "banjo"',
    'and not raceWanted()', 'character:GetAttribute("InvisApplied")', 'local higher = higherTask()',
    'return higher or not safe()', 'requestedGeneration ~= state.Generation', 'Tasks.PriorityCanRun("Essence")', 'GetNightAndWallStatus().ShouldRetreat',
    'transit:Approach(position + Vector3.new(0, 3, -12)', 'transit:FlyTo(leapRoute, 120',
    'transit:FlyTo(stance, 60', 'engine.SetVelocity(root, Vector3.zero)',
    'prompt:InputHoldBegin()', 'pcall(prompt.InputHoldEnd, prompt)', 'prompt.MaxActivationDistance',
    'state.ClaimPending = "Claiming Cricket\'s Banjo", true', 'if ok and reply == false then state.ClaimPending = false end',
    'if state.ClaimPending then state.Status = "Waiting for claim save"; return end',
    'pcall(leave)', 'previousTool.Parent == character', 'not safe() then return end',
    'LibraryLoader:OnUnload(function()', 'state.Connection:Disconnect()', 'state.LabelConnection:Disconnect()',
):
    assert contract in n, f'Missing Banjo contract: {contract}'
assert n.count('task.spawn(') == 1, 'One Banjo job worker, no competing puzzle/movement workers'
assert s.count('"Toggle_Banjo_Auto"') == 1
assert s.count(QUEST_TABS) == 1
assert 'Tasks.BuildBanjoUI(questTabs)' in QUEST_TABS
assert re.findall(r'Text = "([^"]+)"', n) == ['Auto Banjo Cricket']
assert 'RunPace(' not in n and 'FlyToPosition(' not in n and 'RagdollTravel(' not in n
assert 'CanCollide =' not in n and 'PlatformStand =' not in n and ':ChangeState(' not in n
for pattern in (r'FarmConfig\.(?!Banjo_Auto\b)\w+\s*=(?!=)', r'RuntimeState\.\w+\s*=(?!=)'):
    assert not re.search(pattern, n), f'Banjo forces unrelated settings/runtime flags: {pattern}'
assert 'ClaimPending' not in n[n.index('Callback = function(value)'):n.index('local label = group:AddLabel')], 'OFF/ON must not blindly retry an unresolved reward claim'
assert n.index('state.Busy, state.Lease, state.JobGeneration = true, true, state.Generation') < n.index('Tasks.ExitTreadmill()')
assert n.index('state.Status, state.ClaimPending =') < n.index('pcall(request.InvokeServer, request)')
# The only room coordinates are the ones documented by the original Banjo source.
ref = (ROOT / 'Games/Source/StealAnEgg/ChiliSourceV2.lua').read_text()
for coords in re.findall(r'Vector3.new\((\d[\d.]+), ([\d.]+), ([\d.]+)\)', n):
    assert 'Vector3.new(' + ', '.join(coords) + ')' in ref, f'Invented room coordinate: {coords}'
print('PASS: transport repair normalization + two Banjo sites reverse exactly to published Wisp 7591d6f.')
print('PASS: one Banjo subtab in the same Home Quests group; safe OFF default and one worker.')
print('PASS: source tree/room/bat protocol, real server Playback/Note acknowledgements and Save-verified claim.')
print('PASS: native ownership/arbitration, source-backed aerial quest route, race cancellation and guarded cleanup.')
print('Static/compile checks only; no Roblox puzzle execution, reward claim or FPS evidence.')

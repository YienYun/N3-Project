"""Source-contract checks only. No simulated quest, game execution or server acceptance."""
from pathlib import Path
import hashlib
import re
from wisp_scope import strip_wisp, LABELS

ROOT = Path(__file__).resolve().parents[1]
s = (ROOT / 'Games/Steal-An-Egg.lua').read_text()
assert hashlib.sha256(strip_wisp(s).encode()).hexdigest() == '646409f11d80360d8fd7961164338c387d04a051e1070152c252fcd0baf48106', 'Changes escaped seven Wisp insertion sites / published 3748a3e'
reference = ROOT / 'Games/Source/StealAnEgg/ChiliSourceV2.lua'
assert hashlib.sha256(reference.read_bytes()).hexdigest() == '0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d'
a, b = s.index('-- BEGIN WISP CONTROLLER'), s.index('-- END WISP CONTROLLER')
w = s[a:b]
for contract in (
    'FarmConfig.Wisp_Auto = false', 'FarmConfig.Wisp_Auto == true', 'Name = "Quests"', 'IconName = "scroll-text"',
    ':AddTab("Wisp", "ghost")', 'Text = "Auto Wisp", Default = false', 'Tooltip = "Complete the Wisp quest."',
    'FindFirstChild("WispQuests")', 'config.List', 'config.StageCount', 'config.RequiredSpeedPower',
    'data.WispCompanion', 'record.Progress', 'record.Claimed', 'record.Returning', 'record.Unlocked',
    '"EnchantedForestZoneRevealed"', '50000000000', '"WispSpawn"', '"WispAnchor"',
    'questRequest(invoke, "Accept")', 'questRequest(invoke, "Claim", quest.Id)',
    'questRequest(invoke, "BeginReturn")', 'questRequest(invoke, "Return")',
    '"RF/WispCompanion/Request"', '"RF/Fusery/FinishReveal"', '"RF/Fusery/EjectPet", slots[i]',
    '"RF/Fusery/ConfirmBriefing"', '"RF/Fusery/LoadPet", uid', '"RF/Fusery/BeginFuse"',
    '"RF/EggWorld/AskPlaceEgg", { Uid = plan.Eggs[1].Uid, LocalCFrame =',
    '"RF/EggWorld/AskHatch", item.Uid', '"RF/EggWorld/AskFinishHatch", pending.Uid',
    'type(config.DropTable) ~= "table"', 'pool[tostring(row[1])] = true', 'pet.IsFavorite ~= true',
    'not equipped[tostring(uid)]', 'EggRecordsModule.GrowthDuration', 'CalculateEggIncome',
    'quest.Event == "EggSecured"', 'quest.Event ~= "PetFused"', 'tostring(egg.AreaId)',
    'rarity.DisplayName or rarity._id', 'else return false end', 'os.clock() - state.ReadAt > 3',
    'nativeHold(category, uid)', 'state.KeepPets', 'state.KeepEggs', 'state.FusionPets',
    'Tasks.WispProtect(uid, true)', 'Tasks.WispProtect(uid, false)',
    'if #cleanPets == 0 and #cleanEggs == 0 then return 0 end',
    'engine.ClaimMovement("wisp")', 'engine.ReleaseMovement("wisp")', 'state.Lease',
    'RuntimeState.IsExecuting or engine.AutoCycle or state.NativeCalls > 0',
    'generation ~= state.Generation', 'LocalPlayer.Character ~= character', 'engine.Movement.Owner ~= "wisp"',
    'or raceWanted()', 'GetNightAndWallStatus().ShouldRetreat', 'character:GetAttribute("InvisApplied")',
    'EggStateModule.ReadFieldEgg(uid) == nil', 'humanoid:UnequipTools()',
    'RequestStreamAroundAsync', 'os.clock() + 3', 'humanoid:MoveTo(position)',
    'engine.AutoCycle', 'cycle.Target.IsWisp == true', 'state.InstantFlight',
    'local reply = table.pack(pcall(nativeCycle, ...))', 'engine.RunStealCycle = cycleAdapter',
    'state.FusionPhase = "begin"', 'state.LastDispatch = true',
    'state.PendingEggs[uid].FinishSent', 'pending.FinishSent = state.LastDispatch and ok and reply ~= false',
    'state.NativeCalls += 1', 'state.NativeCalls -= 1', 'coroutine.running()',
    'state.SettleUntil = os.clock() + 1.5', 'state.Threads[thread]', 'table.unpack(reply, 2, reply.n)',
    'LibraryLoader:OnUnload(function()', 'state.Disposed, state.Valid, state.StealWanted = true, false, false',
):
    assert contract in w, f'Missing Wisp source/lifecycle contract: {contract}'
assert w.count('task.spawn(') == 1, 'Only one quest worker; use the native normal/Instant steal workers'
assert s.count('Tasks.BuildWispUI(HomeTab)') == 1
assert 'Tasks.BuildWispUI(EventTab)' not in s
assert s.count('"Toggle_Wisp_Auto"') == 1
assert 'AddTab("Banjo"' not in w, 'No unfinished Banjo placeholder'
assert re.findall(r'Text = "([^"]+)"', w) == ['Auto Wisp']
for pattern in (r'FarmConfig\.(?!Wisp_Auto\b)\w+\s*=(?!=)', r'RuntimeState\.\w+\s*=(?!=)'):
    assert not re.search(pattern, w), f'Wisp forces an unrelated setting/runtime flag: {pattern}'
assert 'FlyToPosition(' not in w and 'RunPace(' not in w and 'Respawn' not in w
assert w.index('state.Busy, state.Lease = true, true') < w.index('Tasks.ExitTreadmill()')
assert w.index('state.FusionPhase = "begin"') < w.index('invoke("RF/Fusery/BeginFuse")')
step = w[w.index('local function step('):w.index('-- Shared native action gate')]
assert step.index('invoke("RF/Fusery/FinishReveal")') < step.index('questRequest(invoke, "Claim", quest.Id)'), 'Reveal before stage advancement'
assert step.index('invoke("RF/EggWorld/AskFinishHatch"') < step.index('if record.Unlocked'), 'Do not abandon a started hatch on stage completion'
assert 'state.FusionPhase' not in w[w.index('Callback = function(value)'):w.index('local label = wisp:AddLabel')], 'Toggling must not reset ambiguous fusion'
candidate = s[s.index('-- BEGIN WISP CANDIDATE'):s.index('-- END WISP CANDIDATE')]
assert '(not carried or includeCarried == true)' in candidate and 'Tasks.WispNeeds(rec)' in candidate
assert 'WispOnly = wispTarget and not nativeSelected' in s
assert 'math.min(ca, rankWisp)' in s and 'math.min(cb, rankWisp)' in s
assert 'Tasks.WispNativeAction("fusion", nativeAction)' in s
print('PASS: seven-site exact reversal to 3748a3e; prior race/normal/Instant/mutation/Nitro/Lab preserved.')
print('PASS: real Wisp quest/save/progress data, official drop pools and raw UID protocol; no fabricated recipes/events.')
print('PASS: Home Quests/Wisp UI; default OFF; one quest worker, native steal lanes and priority sorting.')
print('PASS: protected fusion inputs, pending hatch/fusion, shared native-action lane and guarded race/cancellation cleanup.')
print('Static/compile evidence only; the user must verify actual quest progression and server outcomes live.')

"""Static source contracts only; does not execute Roblox or spend consumables."""
from pathlib import Path
from wisp_scope import strip_wisp
from nitro_scope import strip_nitro_refill
import hashlib
import re
from mutate_scope import strip_auto_mutate
from steal_visual_scope import strip_builtin_visual
from admin_scope import strip_admin

ROOT = Path(__file__).resolve().parents[1]
raw = (ROOT / 'Games/Steal-An-Egg.lua').read_text()
if '-- BEGIN ADMIN CONTROLLER' in raw:
    raw = strip_admin(raw)
s = strip_nitro_refill(strip_wisp(raw))
assert hashlib.sha256(strip_builtin_visual(strip_auto_mutate(s)).encode()).hexdigest() == (
    '6d98cf7f3674dedc0fa3fc787d70d7eb90e0533228a6519b2b446ec4499588d2'
), 'Changes escaped Auto Mutate / reviewed dbaeb09 baseline'
a = s.index('-- BEGIN AUTO MUTATE CONTROLLER')
b = s.index('-- END AUTO MUTATE CONTROLLER', a)
m = s[a:b]
for text in (
    'FarmConfig.Mutate_Auto = false', 'fractured = "Boss"',
    'local mutationOrder = { "Boss", "Scrambled", "Enchanted", "Nitro" }',
    'tool:GetAttribute("ItemType") == "MutationConsumable"',
    'tool:GetAttribute("MutationId") or tool:GetAttribute("MutationTemplate") or "Boss"',
    'tool:GetAttribute("Uses")', 'uses > 0', 'record.Placement == nil',
    'pcall(EggStateModule.ReadOwnerEggs, LocalPlayer.UserId)', 'record.Uid or key',
    'add(record.BaseMutation)', 'add(record.Mutation)', 'record.Mutations:gmatch("[^,]+")',
    'value.Id or value.Name or value.Label', 'value ~= false and value ~= 0',
    'not existing[id]', 'FarmConfig.Mutate_Targets[category]', 'tier < FarmConfig.Mutate_MinRarity',
    'income < FarmConfig.Mutate_MinIncome', 'CalculateEggIncome(record)',
    'state.Refused[key]', 'state.Awaiting[key]', '"AreaEggSlotsClient"',
    'folder:FindFirstChild(tostring(uid))', 'pcall(model.GetPivot, model)',
    'candidate.Mutation == job.Mutation and candidate.Tool == job.Tool',
    'engine.AutoCycle', 'RuntimeState.IsExecuting', 'engine.Guard.Active', 'engine.Guard.Busy',
    'engine.AutoCarry.Carrying', 'IsActivelyCarryingEgg()', 'GetEquippedEggTool()',
    'Tasks.TreadmillState.WearBusy', 'Tasks.TreadmillState.Exiting', 'higherTask()',
    'Tasks.PriorityRank("Essence")', 'pcall(engine.CollectCandidates, false,',
    'RaceOwnsCharacter()', 'Tasks.RaceShouldYieldSteal()', 'engine.ClaimMovement("essence")',
    'state.Lease, state.Busy, state.Wanted = true, true, true',
    'generation ~= state.Generation', 'LocalPlayer.Character ~= character',
    'engine.Movement.Owner ~= "essence"', 'character:GetAttribute("InvisApplied")',
    'engine.ReleaseAutoShield(true)', 'if RuntimeState.OriginalHumanoid then RestoreCharacter() end',
    'humanoid:MoveTo(candidate.Position)', 'os.clock() + 12',
    'humanoid:EquipTool(job.Tool); task.wait(0.3)',
    '(root.Position - candidate.Position).Magnitude > 6',
    'FindRemote("RF/BossMastery/AskUseMutationConsumable")',
    'pcall(remote.InvokeServer, remote, job.Uid)', 'if cancelled() then return end',
    'type(reply) ~= "table"', 'reply.Success == true', 'reply.Mutated == true', 'reply.Mutated == false',
    'state.Refused[key] = os.clock() + 120', 'os.clock() + 10', 'os.clock() + 15',
    'engine.Movement.Owner == "essence" and LocalPlayer.Character == character',
    'previousTool.Parent == character', 'previousTool.Parent == LocalPlayer:FindFirstChildOfClass("Backpack")',
    'engine.ReleaseMovement("essence")', 'state.Lease, state.Busy, state.Wanted = false, false, false',
    'state.Lease or nativeYield()', 'not state.Lease and nativeShield()',
    'if state.Lease then return 0 end', 'FarmConfig.Mutate_Auto and state.Lease',
    'state.InventoryActions += 1', 'state.InventoryActions -= 1', 'state.InventoryActions > 0',
    'table.pack(pcall(action, ...))', 'table.unpack(reply, 2, reply.n)', 'state.HatchSettleUntil',
    'if engine.AutoWake then engine.AutoWake() end', 'state.SettleUntil = os.clock() + 3',
    'LibraryLoader:OnUnload(function()', 'state.Disposed, state.Wanted = true, false',
    'Tasks.PriorityStealYield == yieldAdapter', 'engine.AutoShieldWanted == shieldAdapter',
    'ExecuteAutoHatch == hatchAdapter', 'task.wait(0.5)',
):
    assert text in m, f'Missing Auto Mutate contract: {text}'
assert m.count('pcall(remote.InvokeServer, remote, job.Uid)') == 1
assert m.count('task.spawn(function()') == 1, 'Use one worker'
assert m.index('if busy() or higherTask()') < m.index('engine.ClaimMovement("essence")')
assert m.index('local candidate = fresh(job)') < m.index('pcall(remote.InvokeServer, remote, job.Uid)')
for pattern in (r'RuntimeState\.IsExecuting\s*=(?!=)',
                r'FarmConfig\.(?:AutoSteal\w*|AutoScramble\w*|AutoHatch|Defense_\w*)\s*=(?!=)',
                r'record\.[A-Za-z_]+\s*=(?!=)', r'engine\.Guard\.[A-Za-z_]+\s*=(?!=)'):
    assert not re.search(pattern, m), f'Unrelated state write: {pattern}'
for forbidden in (':FireServer(', 'AskBuy', 'RequestRespawn', 'RespawnRecovery',
                  'PerformHumanoidSwap()', 'root.CFrame =', 'RunPace(', 'FlyToPosition('):
    assert forbidden not in m, f'Unsafe/unscoped Auto Mutate operation: {forbidden}'
ui = m[m.index('function Tasks.BuildAutoMutateUI'):m.index('LibraryLoader:OnUnload(function()')]
assert re.findall(r'Text = "([^"]+)"', ui) == [
    'Auto Mutate', 'Mutations', 'Min Rarity', 'Income Above', 'Target Eggs', 'Priority', 'Delay']
assert 'AddLabel(' not in ui
assert all(len(text) <= 32 for text in re.findall(r'Tooltip = "([^"]+)"', ui))
assert s.count('Tasks.BuildAutoMutateUI(PetsTab:AddLeftGroupbox("Mutation", "wand-sparkles"))') == 1
print('PASS: source-backed placed-egg/consumable filters; raw UID-only mutation RPC and truthful server outcomes.')
print('PASS: single worker/lease, idle handoff, race-first cancellation, fresh pre-use checks and guarded cleanup.')
print('PASS: short UI, safe OFF default, no forced defense/farm settings or second swap/fly controller.')
print('PASS: removing two mutation insertions reproduces the entire reviewed dbaeb09 baseline.')
print('Static checks only; no Roblox execution, consumption, mutation success or FPS claim.')

"""Static source contracts for the separate Scramble reward seller. No Roblox simulation."""
from pathlib import Path
from nitro_scope import strip_nitro_refill
import hashlib
import re
from steal_visual_scope import strip_builtin_visual
from lab_stock_scope import strip_lab_stock
from mutate_scope import strip_auto_mutate

ROOT = Path(__file__).resolve().parents[1]
runtime = strip_nitro_refill((ROOT / "Games/Steal-An-Egg.lua").read_text())
start = '-- BEGIN SCRAMBLE LAB SELLER'
end = '-- END SCRAMBLE LAB SELLER\n\n'
assert runtime.count(start) == runtime.count(end) == 1
first = runtime.index(start)
last = runtime.index(end, first) + len(end)
seller = runtime[first:last]

# Exhaustive scope proof: undo only this feature's three insertion sites, then
# compare the entire visual-normalized runtime with the reviewed 6dc1423 baseline.
ordinary_guard = '\t\t\t\tand not (DrScramble.IsLabRewardEgg and DrScramble.IsLabRewardEgg(egg))\n'
new_ui = '\tTasks.LabGroup = EventTab:AddGroupbox({\n\t\tName = "Scramble Lab",\n\t\tIconName = "flask-conical",\n\t\tSide = 2,\n\t\tVisible = true,\n\t\tCollapsed = false,\n\t\tDisableCollapsing = false,\n\t})\n\tTasks.LabTabbox = Tasks.LabGroup:AddTabbox({ Name = "Lab Tabs" })\n\tlocal ScrambleEggGroup = Tasks.LabTabbox:AddTab("Lab Trade", "arrow-left-right")\n\tDrScramble.BuildLabSellerUI(Tasks.LabTabbox:AddTab("Lab Sell", "badge-dollar-sign"))'
old_ui = '\tlocal ScrambleEggGroup = EventTab:AddRightGroupbox("Scramble Egg", "flask-conical")'
assert runtime.count(ordinary_guard) == runtime.count(new_ui) == 1
# Like Webhook Custom: one icon-bearing group contains its own two-tab tabbox.
assert 'Tasks.LabTabbox = EventTab:AddRightTabbox(' not in runtime
assert runtime.count('Tasks.LabGroup = EventTab:AddGroupbox({') == 1
assert runtime.count('Tasks.LabTabbox = Tasks.LabGroup:AddTabbox({ Name = "Lab Tabs" })') == 1
assert 'AddRightGroupbox("Scramble Lab"' not in runtime
# Use the explicit API exercised by the live-confirmed Webhook Custom group.
assert 'local CustomGroup = WebhookTab:AddGroupbox({' in runtime
assert 'local CustomTabbox = CustomGroup:AddTabbox({' in runtime
previous = (runtime[:first] + runtime[last:]).replace(ordinary_guard, '').replace(new_ui, old_ui)
assert hashlib.sha256(strip_builtin_visual(strip_lab_stock(strip_auto_mutate(previous))).encode()).hexdigest() == (
    '0d5a4e4e8211efd0456d200812e9c1425ee922b96b855f966a8de6ec9e2ce218'
), 'Changes escaped the Lab seller scope; do not update its reviewed baseline'

for contract in (
    'ScrambleTradeInData.Banners', 'banner.EggSkin', 'banner.Pets', 'pet.AssetId',
    'seller.Skins[tostring(egg.EggSkin)] == true',
    'EggStateModule.ReadOwnerEggs(LocalPlayer.UserId)', 'egg.Placement ~= nil',
    'tool:GetAttribute("UID") or tool:GetAttribute("EggUid")',
    'tostring(uid) == tostring(heldUid)', 'RuntimeState.ScrambleReserved[tostring(uid)]',
    'ShouldHoldBackScrambleEgg(category, uid)', 'FarmConfig.LabSell_KeepPets[category]',
    'FarmConfig.LabSell_KeepMutated and isMutated(egg)',
    'meaningful(egg.BaseMutation) or meaningful(egg.Mutation)',
    'name ~= "normal"', 'name ~= "none"', 'egg.Mutations:gmatch("[^,]+")',
    'value.Id or value.Name or value.Label', 'value ~= false and value ~= 0',
    'if type(asset) ~= "table" then continue end',
    'rarity.RarityNumber or rarity.Rank', 'tier ~= nil and tier > 0',
    'FarmConfig.LabSell_IncomeLimit > 0', 'income < FarmConfig.LabSell_IncomeLimit',
    'CalculateEggIncome(egg)', 'Tasks.GetOfficialPrice(egg, income)',
    'table.insert(result, uid)', 'local generation, revision = seller.Generation, lab.Revision',
    'seller.Busy or lab.ActionBusy or lab.FetchBusy', 'seller.Busy, lab.ActionBusy = true, true',
    'seller.NextAt = math.max(seller.NextAt, os.clock() + 3)',
    'if next(seller.Skins) == nil then',
    'seller.Busy, lab.ActionBusy = false, false', 'not RaceOwnsCharacter()',
    'Tasks.RaceShouldYieldSteal()', 'generation ~= seller.Generation', 'revision ~= lab.Revision',
    'local ok, message = pcall(function()', 'for offset = 1, #selected, 50 do',
    'for _, uid in ipairs(DrScramble.CollectSellableLabEggs())',
    'if fresh[tostring(uid)] then table.insert(batch, uid) end',
    'if cancelled() then break end', 'remote:FireServer({ Assets = {}, Eggs = batch })',
    'not manual and not FarmConfig.LabSell_Auto', 'os.clock() + 3', 'awaiting inventory update',
    'DoubleClick = true', 'FarmConfig.LabSell_Auto = false',
    'FarmConfig.LabSell_MaxRarity = 0', 'FarmConfig.LabSell_IncomeLimit = 0',
    'FarmConfig.LabSell_KeepMutated = true', 'FarmConfig.LabSell_Rule = "Rarity And Value"',
    'seller.Started', 'seller.Disposed = true', 'LibraryLoader:OnUnload(function()', 'task.wait(2)',
):
    assert contract in seller, f'Missing Lab seller contract: {contract}'
for rule in ('Rarity Only', 'Value Only', 'Rarity And Value', 'Rarity Or Value'):
    assert f'rule == "{rule}"' in seller
assert seller.count(':FireServer(') == 1
assert seller.count('function DrScramble.RunLabSell(') == 1
for forbidden in ('ClaimMovement(', 'PerformHumanoidSwap(', ':InvokeServer(',
                  'FarmConfig.AutoStealEnabled =', 'FarmConfig.AutoScrambleSubmit =',
                  'Engine.Guard.Enabled =', 'SellStats.', 'egg.Uid =', 'egg.Placement ='):
    assert forbidden not in seller, f'Lab seller must not change unrelated behavior: {forbidden}'
assert not re.search(r'egg\.[A-Za-z_]+\s*=(?!=)', seller), 'Inventory records must remain read-only'
for option in ('Toggle_LabSell_Auto', 'Dropdown_LabSell_Rule', 'Dropdown_LabSell_MaxRarity',
               'Input_LabSell_IncomeLimit', 'Toggle_LabSell_KeepMutated', 'Dropdown_LabSell_KeepPets'):
    assert runtime.count(f'"{option}"') == 1, f'Duplicate UI config key: {option}'
# User-requested compact UI: backend remains byte-identical to 9a9217f.
ui_start = seller.index('\tfunction DrScramble.BuildLabSellerUI(group)')
ui_end = seller.index('\tLibraryLoader:OnUnload(function()', ui_start)
ui = seller[ui_start:ui_end]
assert hashlib.sha256(seller[:ui_start].encode()).hexdigest() == (
    '1b1da49adaf7881c9f9d0ab795fa6d7bd1b46d6df61cad87b94ad8a7c84a7691'
), 'Seller backend changed during the UI-only cleanup'
labels = re.findall(r'Text = "([^"]+)"', ui)
assert labels == ['Auto Sell Lab Egg', 'Sell Rule', 'Max Rarity', 'Income Below',
                  'Keep Mutation Lab Egg', 'Keep Lab Pets', 'Sell Now'], labels
assert 'AddLabel(' not in ui and 'seller.Preview' not in ui and 'seller.StatusLabel' not in ui
assert 'DoubleClick = true' in ui
assert all(len(text) <= 32 for text in re.findall(r'Tooltip = "([^"]+)"', ui))
assert 'task.spawn(DrScramble.RunLabSell, true)' in ui
assert 'DrScramble.RunLabSell(false)' in ui
print('PASS: separate source-backed Lab seller; EggSkin classification and ordinary-seller exclusion.')
print('PASS: safe filters, raw UIDs, placement/held/reserved/mutation/pet protection.')
print('PASS: single Lab action lock, race/cancellation guards, fresh 50-item batches, no pet sales.')
print('PASS: undoing exactly the three seller insertion sites reproduces the full reviewed prior baseline.')
print('PASS: compact labels, no explanation/preview/status rows; unchanged seller backend.')
print('Static checks only; sale requests are not server acceptance or live Roblox evidence.')

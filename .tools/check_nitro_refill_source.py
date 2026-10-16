"""Static contracts only; never invokes a game RPC or spends tokens."""
from pathlib import Path
from wisp_scope import strip_wisp
import hashlib
import re
from nitro_scope import strip_nitro_refill
from steal_visual_scope import strip_builtin_visual
from admin_scope import strip_admin

ROOT = Path(__file__).resolve().parents[1]
raw = (ROOT / 'Games/Steal-An-Egg.lua').read_text()
if '-- BEGIN ADMIN CONTROLLER' in raw:
    raw = strip_admin(raw)
s = strip_wisp(raw)
assert hashlib.sha256(strip_builtin_visual(strip_nitro_refill(s)).encode()).hexdigest() == (
    'd0290710fc9fe4f5fe8d9eb1d073dae4b627bf8f4e158f74201dce25774ff316'
), 'Changes escaped Nitro refill / live-confirmed Auto Mutate 1043562 baseline'
a = s.index('-- BEGIN NITRO REFILL CONTROLLER')
b = s.index('-- END NITRO REFILL CONTROLLER', a)
nitro = s[a:b]
for text in (
    'FarmConfig.Mutate_BuyNitro = false', 'FarmConfig.Mutate_BuyNitro == true',
    'FarmConfig.Mutate_Auto == true', '(FarmConfig.Mutate_Use or {}).Nitro == true',
    'os.clock() >= mutate.SettleUntil', 'tool:GetAttribute("ItemType") == "MutationConsumable"',
    'tool:GetAttribute("MutationId") or tool:GetAttribute("MutationTemplate") or "Boss"',
    'tool:GetAttribute("Uses")', 'uses > 0', '"nitro"',
    'FindFirstChild("RaceRally")', 'data.Shop[itemId]', 'SaveModule.Get or SaveModule.Peek',
    'tonumber(definition.Price)', 'tonumber(raceSave.Tokens)', 'tonumber(definition.Limit)',
    'price ~= price', 'tokens ~= tokens', 'limit > 0 and count >= limit',
    'shop.Busy = true', 'shop.Busy = false', 'shop.NextAt[itemId] = os.clock() + 2',
    'shop.Balance = math.min(shop.Balance, tokens)', 'shop.Balance -= price',
    'budget(tokens) < price', 'source == "refill" and itemId ~= "MutationToken"',
    'generation ~= shop.Generation', 'mutateGeneration ~= Tasks.MutateState.Generation',
    'not FarmConfig.Race_AutoBuy', 'FarmConfig.Race_ShopItems or {}',
    'itemId == "MutationToken" and shop.PendingNitro',
    'outOfStockOnly and nitroOwned',
    'local trackGrant = itemId == "MutationToken" and not nitroOwned',
    'if trackGrant then shop.PendingNitro = true end',
    'if reply[1] and reply[2] == false then',
    'shop.Balance = math.min(tokens, shop.Balance + price)',
    'source == "refill" and outOfStockOnly and reply[1] and reply[2]',
    'os.clock() + 1.5', 'while not cancelled()', 'task.wait(0.1)',
    'network:FindFirstChild("RF/RaceRally/AskBuy")',
    'table.pack(pcall(remote.InvokeServer, remote, itemId))',
    'return table.unpack(result, 1, result.n)',
    'Tasks.InvokeRaceShopPurchase("refill", "MutationToken")',
    'Text = "Auto Buy Nitro", Default = false', 'Tasks.MutateSettingsChanged()',
    'LibraryLoader:OnUnload(function()', 'shop.Disposed = true',
):
    assert text in nitro, f'Missing refill/shop coordination contract: {text}'
assert nitro.count('pcall(remote.InvokeServer, remote, itemId)') == 1
assert nitro.index('shop.Busy = true') < nitro.index('local price, tokens = dataAndSave(itemId)')
assert nitro.index('local ok, result = pcall(function()') < nitro.index('shop.Busy = false')
assert nitro.index('shop.Balance -= price') < nitro.index('pcall(remote.InvokeServer, remote, itemId)')
assert nitro.index('if trackGrant then shop.PendingNitro = true end') < nitro.index('pcall(remote.InvokeServer, remote, itemId)')
callback = nitro[nitro.index('Callback = function(value)'):nitro.index('LibraryLoader:OnUnload(function()')]
assert 'PendingNitro' not in callback, 'Toggling must not clear an unresolved grant'
assert 'shop.Busy = false' not in nitro[nitro.index('LibraryLoader:OnUnload(function()'):], 'Unload must retain an in-flight lock'
assert 'task.spawn(' not in nitro, 'Use the existing Auto Mutate worker, not a competing buyer'
assert 'ClaimMovement' not in nitro and 'RestoreCharacter(' not in nitro
for pattern in (r'FarmConfig\.(?:Race_\w+|Mutate_Auto|Mutate_Use)\s*=(?!=)',
                r'RuntimeState\.[A-Za-z_]+\s*=(?!=)'):
    assert not re.search(pattern, nitro), f'Unrelated setting/state write: {pattern}'
hook = s[s.index('-- BEGIN NITRO REFILL SHOP HOOK'):s.index('-- END NITRO REFILL SHOP HOOK')]
assert 'name == "RF/RaceRally/AskBuy"' in hook
assert 'return Tasks.InvokeRaceShopPurchase("race", ...)' in hook
assert ':InvokeServer(' not in hook and 'pcall(' not in hook
assert s.count('"Toggle_Mutate_BuyNitro"') == 1
assert s.count('pcall(Tasks.TickNitroRefill)') == 1
assert s.count('Tasks.BuildNitroRefillUI(group)') == 2 # definition + one call
assert re.findall(r'Text = "([^"]+)"', nitro) == ['Auto Buy Nitro']
assert all(len(t) <= 32 for t in re.findall(r'Tooltip = "([^"]+)"', nitro))
# Do not invent shop item IDs; the original mapping must match the shared gate.
shop = s[s.index('local raceShop = {'):s.index('local function UpdateOwnedRaceRacers')]
native_items = re.findall(r'Id = "([^"]+)", Name = "([^"]+)"', shop)
assert len(native_items) == 5, 'Expected all five native shop IDs/names'
for item, label in native_items:
    assert f'{item} = "{label}"' in nitro
print('PASS: exact 1043562 baseline after removing four Nitro insertion sites; mutation/drive logic preserved.')
print('PASS: optional token-only refill, real tool/price/limit checks, one shared purchase lock/budget.')
print('PASS: native shop return shape, no additional race wait, pending-grant protection and cancellation.')
print('PASS: one short toggle, no new worker or forced race/mutation preferences.')
print('Static source checks only; no live purchase, Roblox execution or token-spend claim.')

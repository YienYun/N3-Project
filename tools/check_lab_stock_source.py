"""Static contracts only: no Roblox execution or game recipe simulation."""
from pathlib import Path
from wisp_scope import strip_wisp
from nitro_scope import strip_nitro_refill
import hashlib
import re
from lab_stock_scope import strip_lab_stock
from mutate_scope import strip_auto_mutate
from steal_visual_scope import strip_builtin_visual

ROOT = Path(__file__).resolve().parents[1]
s = strip_nitro_refill(strip_wisp((ROOT / 'Games/Steal-An-Egg.lua').read_text()))
assert hashlib.sha256(strip_builtin_visual(strip_lab_stock(strip_auto_mutate(s))).encode()).hexdigest() == (
    'f2345282fdfdd7d47fcfb34863a2108698bf91f52a91c46e9c8d617aa138f66d'
), 'Changes escaped the four reviewed stock insertion sites / 9badf26 baseline'
a = s.index('-- BEGIN LAB STOCK CONTROLLER')
b = s.index('-- END LAB STOCK CONTROLLER', a)
stock = s[a:b]
for text in (
    'FarmConfig.LabStock_Banners = {}', 'FarmConfig.LabStock_Eggs = {}', 'FarmConfig.LabStock_PerEgg = 3',
    'FarmConfig.AutoScrambleSteal == true', 'next(FarmConfig.LabStock_Banners) ~= nil',
    'for banner in pairs(FarmConfig.LabStock_Banners)', 'stock.Pools[banner] or {}',
    'result[ScrambleCleanName(category)] = FarmConfig.LabStock_PerEgg',
    'SaveModule.Get()', 'SaveModule.Peek()', 'type(save.EggInventory) ~= "table"',
    'EggStateModule.ReadOwnerEggs(LocalPlayer.UserId)', 'record.Placement ~= nil',
    'record.Placement == nil and not placed[tostring(uid)]', 'if #eggs < quota then',
    'math.min(quota, #eggs)', 'stock.Reserved[tostring(eggs[index].Uid)] = true',
    'return not a.Mutated', 'return a.Scale < b.Scale', 'stock.Updating',
    'generation ~= stock.Generation', 'stock.Generation += 1',
    'stock.RecipeWanted = table.clone(wanted)', 'local wanted, summary, picks, ready = nativeStatus()',
    'return wanted, summary, picks, ready', 'RuntimeState.ScrambleWanted[category] =',
    'not stock.Valid or stock.Wanted[ScrambleCleanName(category)] == true',
    'ScrambleTradeInData.BannerIdForPeriod(period + offset)', 'ScrambleTradeInData.Banners',
    '"ScrambleTradeInRecipes"', 'pcall(recipes.Simulate, id, 4000)', 'result.SlotPicks',
    'stock.Pools[id] = pool', 'stock.Pools[id][tostring(category)] = true',
    'type(state.Requirements) == "table"', 'picker:SetDisabledValues(disabled)',
    'picker:SetVisible(FarmConfig.LabStock_Banners[id] == true)',
    '"Stock Banners"', '"Stock Per Egg"', '"Refresh Pools"',
    'math.clamp(math.floor(tonumber(value) or 3), 1, 30)',
    'LibraryLoader:OnUnload(function()', 'stock.Disposed = true',
):
    assert text in stock, f'Missing stock contract: {text}'
for forbidden in (':InvokeServer(', ':FireServer(', 'ClaimMovement(', 'PerformHumanoidSwap(',
                  'AutoStealEnabled =', 'Guard.Enabled =',
                  'table.insert(picks'):
    assert forbidden not in stock, f'Stock must not replace core behavior: {forbidden}'
assert not re.search(r'FarmConfig\.AutoScrambleSteal\s*=(?!=)', stock)
assert stock.count('pcall(recipes.Simulate, id, 4000)') == 1
assert stock.count('GetScrambleTradeStatusFn = function()') == 1
assert stock.count('Text = "Stock Banners"') == 1
assert 'AddGroupbox(' not in stock and 'AddTab(' not in stock
assert 'Default = {}' in stock and 'Default = 3' in stock
# The native candidate picker/lifecycle/seller are untouched; only the Lab helper
# recognizes stock shortfalls independently of whether today's banner is open.
target = s[s.index('-- BEGIN LAB STOCK TARGET'):s.index('-- END LAB STOCK TARGET')]
assert 'DrScramble.StockActive()' in target and 'DrScramble.Stock.Wanted[ScrambleCleanName(cat)]' in target
hold = s[s.index('local function ShouldHoldBackScrambleEgg'):s.index('local EventEggCategories')]
assert hold.index('DrScramble.HoldStockEgg') < hold.index('if not FarmConfig.ScrambleHoldBack')
assert not re.search(r'result\[ScrambleCleanName\(category\)\]\s*\+=', stock)
assert not re.search(r'record\.[A-Za-z_]+\s*=(?!=)', stock)
print('PASS: exact prior runtime restored by removing four stock insertion sites.')
print('PASS: shared category quotas, unplaced counts, reserved materials and fail-closed inventory reads.')
print('PASS: real recipe pools, independent future banners, compact controls and settings/unload cancellation.')
print('PASS: no second steal/movement worker, no new RPC and no farm/defense preference writes.')
print('Static checks only; no game simulation or live server/FPS acceptance claims.')

# Scramble Lab stock targets

One incremental Chili feature; not the entire event audit. Extends Lab material
selection/holdback, not normal/Instant/race movement. Reference stays unchanged.

## Source mapping

`Games/Source/StealAnEgg/ChiliSourceV2.lua`:

- 8874–8897: StockTargets; one shared quota per category across banners.
- 75075–75165: unplaced Save.EggInventory counts, strict count < quota, future
  banners independent of current recipe; preserve current recipe shortages.
- 13445–13510: Auto Place keeps stock besides recipe reservations.
- 75320–75450: selected banners/species; quota 1–30/default 3.
- 36450–36580: official `Shared.Modules.ScrambleTradeInRecipes.Simulate`, 4,000
  runs, positive `SlotPicks` counts to observe category membership.

N3 retains current-recipe raw UID picks/readiness and normal/small preference.
Stock feeds the existing candidate helper, retaining native zone/safety filters,
Task Priority, Sena lifecycle, normal/Instant and race-first arbitration.
No second picker/controller, swap, movement worker or new remote.

## UI

Same **Event → Scramble Lab → Lab Trade**, below banner filter, before odds card.
No third tab or new outer group. Short labels; no explanation/status rows.

- **Stock Banners**: empty by default.
- **<banner> Eggs**: shown only for selected banners; empty by default.
- **Stock Per Egg**: 1–30, default 3.
- **Refresh Pools**.

Requires **Auto Steal Lab Eggs** ON. Select banners, then eligible species.
Selecting one species in two banners still means quota 3, not 6.
No silent default species selection. IDs only disambiguate duplicate names.

## Recipe pool adaptation

Chili's VM-initialized Shares are not a simple readable data table. N3 does not
fabricate them or import the VM. Instead, it uses Chili's official game recipe
module API. Only categories observed in its SlotPicks or actual current
Requirements qualify. No estimated percentages are shown.

A single background load runs during UI construction, yielding between banners.
Refresh Pools retries on demand; concurrent loads are rejected. No recurring
sampling loop or network RPC. Unload ignores in-flight results/stops later
banners. A synchronous module call cannot be interrupted. The source's 4,000
sample budget is retained; live load time/FPS has not been benchmarked.

Stable dropdown options come from actual asset metadata to restore saved
selections before pools arrive. Non-pool entries are disabled; targets also
recheck pool membership, so saved configs cannot bypass verification. Missing
pools fail closed and notify briefly. Observation-only fallback can omit rare
categories until later refresh. Unlike Chili's VM-seeded first-five defaults,
N3 deliberately starts species selection empty.

This sampling occurs only when the user runs the hub: it is a game-data API
operation, not agent-run test/simulation evidence or proof of server acceptance.
No Roblox recipe module was executed in the coding environment.

## Counting / holdback

- Count only unplaced Save.EggInventory records; exclude UIDs marked placed by
  ReadOwnerEggs. Missing reads create no blind shortages; hold selected material
  conservatively until inventory is available.
- Keep up to quota unplaced UIDs, preferring normal/small records. Stock and
  current-recipe reservations can overlap. Surplus remains available to other
  automation. Auto Trade-In can consume materials, then stock replenishes.
- Uses the existing Auto Place / seller holdback entry point, independently of
  the user's current-recipe holdback setting. Does not force that preference.
- Under quota, hold newly arrived materials even before the next cached count.
  Reads throttle to twice per second; generation/revision checks invalidate old
  work after settings changes. Unload cancels stock state.
- Only the stock lane stops at quota. Auto Steal All/other filters may still
  select that species normally. Do not silently modify their toggles.
- No retrieval of already-placed eggs. Auto Hatch handles placed eggs only.
- An already-started action cannot be recalled; inventory replication is not an
  atomic transaction. Transient overshoot is possible, not confirmed delivery.

## Validation

Run all five static checkers: `check_lab_stock_source.py`,
`check_lab_seller_source.py`, `check_treadmill_lab_source.py`,
`check_race_source.py`, `check_steal_visual.py`, then whole-file Luau compilation.

Stock checker removes exactly four marked insertion sites and reproduces the
entire reviewed 9badf26 runtime hash. Seller backend/eight core gameplay blocks
retain their fingerprints; the full live-confirmed race stays byte-identical.
Library/reference unchanged. Static/compile results are not live server/FPS or
simulated acceptance evidence.

User live checklist:

1. Empty stock banners: confirm existing trade/sell/normal/Instant unchanged.
2. Auto Steal Lab Eggs ON; select a future banner, wait for pools, select one
   eligible species, quota 3. Confirm placed eggs do not count.
3. Disable ordinary farm modes to isolate stock: stop at quota, replenish after
   trade, preserve zone/safety filters.
4. Same species in two banners: quota stays 3, not 6.
5. Auto Place + both sellers: reserved materials remain, surplus follows their
   own filters. Current recipe readiness/raw picks are not fabricated.
6. Try locked/filtered-out/pending-reveal current banner; future stock still works.
7. Change species/quota, clear banners, disable Lab steal, restore config, race,
   unload. Check no stale targets or competing movement.
8. Missing recipe-module notification and Refresh Pools retry need game testing.

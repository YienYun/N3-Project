# Separate Scramble Lab reward-egg seller

## Scope and source

Implemented one feature from the larger Chili gap audit, not the entire audit.
Production file: `Games/Steal-An-Egg.lua`, `BEGIN/END SCRAMBLE LAB SELLER`.
Reference: unchanged `Games/Source/StealAnEgg/ChiliSourceV2.lua`, roughly
6594–6798 (Lab seller); shared selection-sell RPC uses the existing N3
`Remotes.RemoteSellSelection` / `{ Assets = {}, Eggs = batch }` contract.
No alternative steal/race controller, loader or Library edits.

The reference identifies rewards by `EggSkin` from
`Data.ScrambleTradeIn.Banners`, not by category/name containing “Lab”. Pet
keep-list options come from each banner's `Pets[*].AssetId`. The separate
seller implements all four reference rules, max rarity including **Off**, income
threshold, keep-mutated and keep-specific-pets. Original UID types are retained.
It never sends pet asset UIDs in `Assets`.

## UI and defaults

**Event → Scramble Lab group → nested Lab Trade / Lab Sell tabs** replaces the old single
Scramble Egg group. Existing trade/reward controls stay on Lab Trade. Only the
new seller appears on Lab Sell; it is not mixed into Pets' ordinary egg seller.
The outer group has a flask icon, with arrow-left-right for Lab Trade and
badge-dollar-sign for Lab Sell. The tabbox is a child of the group, matching
Webhook Custom; it is not a standalone tabbox on the Event column.
Construction explicitly uses `EventTab:AddGroupbox({Name, IconName, Side = 2})`,
then `Tasks.LabGroup:AddTabbox(...)`, the same API sequence as Webhook Custom.
The group is visible, initially expanded and collapsible. No Library changes.

- Auto Sell Lab Egg: OFF.
- Rule: Rarity And Value.
- Max rarity: Off (zero rarity matches).
- Income Below: 0 (disabled), in raw dollars **per second**, not sale price.
- Keep Mutation Lab Egg: ON; Normal/None are not mutations. Supports list, keyed,
  string, base-mutation and named mutation records; unknown named-record shape
  is retained conservatively.
- Keep Lab Pets: independent multi-select, never sold.
- Sell Now: double-click confirmation, uses the same filters.
  Manual sell works with auto OFF; the auto toggle isn't an authorization bypass.

Default rarity/value settings match nothing. With Rarity And Value, both must
be configured. Value 0 cannot make a value rule pass. A fire-and-forget RPC is
not server acceptance.

User-requested compact UI: only the six control labels above plus Sell Now.
Intro/footer explanations, preview and status rows are removed. Only the
rarity/value hints and manual confirmation have short tooltips (under 33
characters). Polling no longer reads inventory just to refresh hidden text;
sale collection, filters, locks and request logic remain byte-identical.

## Safety / adaptations

- Ordinary GetSellableEggs excludes known Lab reward skins even when the Lab
  seller is OFF. Turning ordinary auto-sell on cannot opt into Lab sales.
- Only unplaced owned records qualify. Equipped UID, recipe-reserved UIDs,
  selected kept pets and optionally mutated eggs are excluded. N3's existing
  category holdback also applies when enabled by the user.
- Unknown asset metadata or missing banner catalog cannot qualify for sale.
- Manual and auto share one busy flag and the existing `LabState.ActionBusy`.
  Trade/reroll/reveal and this seller do not run concurrently. `FetchBusy` also
  blocks starting a sale. The lock is released on errors/cancellation.
- Generation and Lab revision checks cancel pending batches on settings changes;
  new settings impose a three-second debounce. Re-read filters, placement,
  equipped UID and reservations immediately before each batch (max 50).
- Race's existing priority/ownership predicates pause new sale requests. No
  physical movement, farm-toggle writes, Anti Guard changes or respawns.
- A batch already sent cannot be recalled. Turning OFF/unloading prevents later
  batches, not an already-fired RPC. A fresh inventory snapshot is not an
  atomic server transaction; concurrent manual Roblox actions remain possible.
- One polling worker every two seconds, sale cooldown three seconds. No per-frame
  callbacks or source model import. Unload stops the worker and cancels its lane.

## Validation and live checklist

Run:

```
PYTHONDONTWRITEBYTECODE=1 python tools/check_lab_seller_source.py
PYTHONDONTWRITEBYTECODE=1 python tools/check_race_source.py
PYTHONDONTWRITEBYTECODE=1 python tools/check_treadmill_lab_source.py
PYTHONDONTWRITEBYTECODE=1 python tools/check_steal_visual.py
```

Compile the whole production file as Luau, not just the addition. The new checker
undoes **exactly three insertion sites** and verifies the full visual-normalized
runtime returns to the reviewed `6dc1423` SHA256. Race and eight protected steal
blocks keep their existing fingerprints. Library and bundled source stay intact.
These are static/compile checks, not simulations or proof of live sales/FPS.

User live-test in a fresh Roblox session:

1. Defaults send no sell RPC; normal egg seller leaves Lab
   reward eggs untouched.
2. Use an expendable unplaced Lab reward. Select Rarity Only + its rarity,
   then double-click Sell Now. Verify game inventory and money.
3. Confirm placed/equipped/reserved/kept-pet/mutated eggs remain in inventory.
4. Exercise Value Only, And, Or and threshold 0; change settings during auto
   polling, stop auto and verify future requests stop.
5. Enable Lab trade plus auto sell and check no overlapping Lab action; enter
   Race Rally and verify pause, then automatic resume afterward.
6. Unload and verify polling stops; confirm normal/Instant/race still behave as
   before. No new live success is claimed before these checks.

## Still pending from the audit

Lab stock targets, Wisp/Banjo quests, Butterfly workflows, Shooting Star,
Auto Mutate/Nitro replenish, Capture/Admin/Minigame events, Auto Hop and remaining
utilities/HUD are **not implemented by this change**. Priority labels are not
proof of a working event. Continue one source-backed feature per change.

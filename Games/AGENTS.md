# Steal-An-Egg maintenance contract

Read this before changing `Steal-An-Egg.lua`.

## Reference and synchronization

- The active normal Auto Steal reference is `Source/StealAnEgg/SenaV2.lua`
  from main `a2fb701`, blob `a36898ee403cacf3aa9742bfb9f9270f867cb765`.
  Read the normal `t46` controller, not the later player-steal/event systems.
- The user explicitly retired the old Chili V1 reference and integration.
  Do not restore it. Future Chili event work is outside this change.
- Fetch/review main before further steal work and merge into the current Arena
  branch when needed. Never replace the customized runtime with main, change
  branches, push main or open a PR without separate authorization.

## Runtime requirements

- Use semantic function/variable names; the untouched reference is exempt.
- Normal selection/pickup/recovery/deposit/repeat follows Sena's Fly lifecycle.
  Keep **N3's movement to eggs**, not Sena's walk/aerial/zigzag/tween approach.
  Retain normal speed 100–1000/default 400, separate from Instant TweenSpeed 600.
- Preserve N3 filters and priority, persistent N3 Humanoid Swap, optional Anti
  Guard, automation movement ownership and separate Instant/Line Drop behavior.
  Reuse N3's swap/control restoration, not a second imported swap controller.
- Anti Guard is user-owned. Never turn its preference on/off inside a cycle.
  Normal motion/arrival holds must yield to an optional dodge already running.
- One worker owns the normal cycle, including dropped-egg recovery. Every exit
  must release holds, simulation callbacks, temporary parts and movement.
- Source-backed delivery drops/re-grabs are not starter-egg priming. Don't
  reintroduce a forced Forest starter or wait-for-guard-hit stage.
- Do not change the production loader or Library. The user copies the game file.
- Local routine returns, a missing field record and unrelated verdict timestamps
  do not establish server acceptance. Do not invent rollback causes or payloads.

## Validation

- `python tools/check_steal_source.py` checks source identity and integration
  boundaries. Compile the whole game file as Luau as well.
- Static checks/compilation/source review are not live Roblox, server, rollback
  or FPS tests. Do not run simulations as acceptance evidence.
- Record intentional differences from Sena and untested behavior in
  `../docs/auto-steal.md`. The user performs live validation.

## Race Rally (separate Chili V2 event integration)

- Race work is now authorized separately; normal Auto Steal stays Sena-based.
- Reference `Source/StealAnEgg/ChiliSourceV2.lua` is untouched from main `5c1763a`.
  See `../docs/race-rally.md` for source mapping, adaptations and live limitations.
- Read the player heat under `RaceHeats[RaceHeat]`, not just root track attributes.
- Preserve native racer `PlatformStand` / `MountDrive` and race RigSync handling.
  User defense preferences must not be overwritten by automation.
- Never install a second race worker or copy decompiler names into the runtime.
- Run `python tools/check_race_source.py` and compile the complete game file.
  This checker protects pre-race Sena/Instant/swap/filter/movement fingerprints.

## Built-in safe-zone steal visual

- The user approved the standalone visual experiment live and requested promotion.
  There is no separate V2 game file or test title. The newer user request makes
  **Safe Zone Visual** optional, default OFF, for normal and Instant/Line Drop.
- One shared visual starts on accepted `ClaimMovement("steal")`, covering normal,
  Instant/Line Drop and already-carried retry lanes. Reuse the decoy across cycles.
- Preserve the actual normal/Instant movement, pickup and deposit workflows.
  Only old camera freezing and cosmetic guard disguise yield to the decoy.
- Do not compete with race/other movement owners; restore cached presentation,
  camera and connections on cancellation/death/character change/unload.
- Run `python tools/check_steal_visual.py` and the race checker, then compile.
  The shared normalizer removes only reviewed visual bodies/camera predicates so
  gameplay boundaries can still be compared with the pre-promotion version.
- See `../docs/auto-steal-visual.md`. Normal's test was user-confirmed; do not claim
  the new Instant integration has been live-tested or benchmarked by the agent.

## Race-first farm arbitration

- New user instruction overrides Chili's egg-first HigherFirst policy: eligible
  open/unraced Auto Race pauses egg logic while leaving every farm toggle/filter ON.
- Keep N3/Sena steal intact. Use cancellation and wait for normal/Instant/guard
  cleanup before race ownership; never clear shared IsExecuting from race code.
- Do not let current egg carry/candidates or task-rank of eggs starve the race.
  Keep unrelated event ownership rules. After race return, wake the native farm
  scheduler; closed/ineligible/completed windows permit farming.
- Instant interrupted iterations must not trigger failure resets or post-place.
- Run visual/race static checkers and compile; the new transitions need user live
  validation. See `../docs/race-rally.md` for source ranges and deliberate changes.

## Race speed cap

- The user requested N3 Race Speed default/max 144 (min 100), including old-save
  callback and runtime clamps. Keep all three in sync; normal/Instant speeds differ.
- The bundled Chili reference still has max 160/default 150. The screenshot showed
  selected 144, not proof of max. Document this intentional N3 cap honestly.
- Test races in a clean session with only one hub's drive, not simultaneous hubs.

## Treadmill / Lab maintenance

- Reference ranges, intentional N3 adaptations and live checklist are documented in
  `../docs/treadmill-lab.md`. Run `tools/check_treadmill_lab_source.py` as well as
  the race/visual checkers and whole-file Luau compilation.
- Preserve the user-live-confirmed `1aa5920` race block byte-for-byte. Keep the
  protected normal/Instant/swap/filter/movement bodies intact.
- Treadmill uses one cancellable worker, native ownership and server Wear, not
  proximity/prompt success. Upgrade sends the affordable next tier `_id`.
- Lab reads never mutate; one action lane owns trade/reroll/reveal. Preserve raw,
  unique unplaced UIDs, normal/small preference, boolean missing-category targets,
  per-slot UI readiness, and independent **free-only** Auto Reroll.
- Do not replace N3's swap or add automatic grounding-error respawns. A sent RPC
  cannot be recalled; cancellation/compile checks aren't proof of server behavior.

## Separate Lab reward seller

- Current integration proceeds one feature at a time. Do not call the entire
  Chili audit implemented. See `../docs/lab-egg-seller.md` for scope/live checks.
- Keep one Scramble Lab group with a flask icon, containing a nested tabbox
  for Lab Trade / Lab Sell with distinct icons, like Webhook Custom. Do not
  replace the outer group with a standalone tabbox. Ordinary seller must exclude
  known reward EggSkins even when the dedicated Lab seller is OFF.
- Source mapping uses banner EggSkin and Pets AssetId; no egg-name heuristics.
- Preserve safe OFF/rarity-Off/value-0 defaults, independent filters, raw UIDs,
  placed/held/reserved/mutation/pet exclusions. Keep UI labels short; no intro,
  footer, preview or status rows. Tooltips must be brief, not paragraphs.
- Seller shares LabState.ActionBusy with trade/reroll/reveal and respects race.
  Revalidate per max-50 batch and cancel unsent work on settings/unload.
- Run `tools/check_lab_seller_source.py` with the existing three static checkers
  and compile the entire runtime. Its reverse-delta hash protects all prior code.


## Lab stock targets

- See `../docs/lab-stock.md`; run `tools/check_lab_stock_source.py` as well as
  all prior checkers/full compilation. Four marked insertions reverse to 9badf26.
- Preserve the live-confirmed explicit outer Lab group and its two subtabs.
  Stock controls stay in Lab Trade with short labels and no prose/status rows.
- Quota 1–30/default 3 is shared per category across banners, not summed.
  Require Auto Steal Lab Eggs plus selected banners/species. Empty means inactive.
- Pool membership must come from the actual game recipe API or observed recipe;
  never fabricate Shares, recipes, percentages or game-module payloads. Sampling
  the game's data API at runtime is not agent test/server-acceptance evidence.
- Count only unplaced inventory, exclude placed owner UIDs, hold the quota against
  auto-place/sellers, and fail closed on read errors. Preserve original trade
  readiness/raw UID picks. No second picker, swap, worker, or race changes.

## Auto Mutate

- See `../docs/auto-mutate.md`. Run its source checker and all previous checkers,
  then full Luau compile. Two marked insertions reverse exactly to dbaeb09.
- UI stays compact in Pets → Mutation. Default OFF. Uses only placed owned eggs
  and real MutationConsumable tools; recheck filters/proximity before raw UID RPC.
- Use the existing essence ownership lane only from native idle; never cancel
  active steal/carry or write shared IsExecuting / farm / defense preferences.
- Reuse N3 rig restoration; do not lie to steal-only FlyToPosition/RunPace or
  introduce another swap/flight controller. Current transport is bounded MoveTo.
- Race always preempts; late RPC cleanup may not touch a newer character/owner.
  Restore tools/adapters conditionally; retain server refusal/replication delays.
- Auto Buy Nitro is delivered in the shared lane below; never add a competing buyer.


## Auto Buy Nitro

- See `../docs/nitro-refill.md`; default OFF in Pets → Mutation. Requires Auto
  Mutate + Nitro selected, settled settings, no usable tool, affordable race
  tokens and valid official shop limit/count. Never buy tokens or force choices.
- Run `tools/check_nitro_refill_source.py`, all six prior source checkers and
  full Luau compile. Four marked insertions reverse exactly to 1043562.
- The only deliberate race-body exception is the tiny AskBuy-only routing gate
  into a shared purchase adapter. Full-race hash strips ONLY that hook and keeps
  the old expected hash; no race drive, finish/leave or ownership change allowed.
- Both native shop and refill use one lock taken before yielding reads, fresh
  preference/data checks, per-item throttling and conservative token reservation.
  Preserve packed pcall results. No second worker; reuse the mutation tick.
- Track pending out-of-stock Nitro grants before RPC, even for the native shop.
  OFF/ON must not clear pending. Only an observed tool or explicit server false
  clears it; ambiguous outcomes fail closed rather than timed duplicate buying.
  A sent RPC cannot be recalled. Native race caller must not gain a grant wait.
- Historical reverse-delta checks strip Nitro before their prior scopes, never
  replace old expected hashes to accommodate unrelated changes. Library, loader
  and bundled references remain untouched; static checks are not live acceptance.


## Wisp quest (not an Event)

- See `../docs/wisp-quest.md`. User explicitly requires Home/farm → a new Quests
  outer group, nested Wisp tab, distinct header/tab icons. Never put Wisp in Event.
  Default OFF; one short toggle/status. Banjo is later, not an empty placeholder.
  Server Hop/tools are deferred for a separate manager module, not part of this work.
- Follow Chili 41403–42256. Read WispQuests/Save and real area DropTables; do not
  invent quest stages, recipes, remote payloads or target coordinates. Use raw UIDs.
- One quest worker, native normal/Instant steal input/sorting adapters; preserve
  in-flight native cycle lifetime and all user farm/defense choices. No second
  steal/fly/swap worker. Race preempts; start quest actions only from native idle.
- Track native inventory/fusion calls before yields; protect required inputs from
  sellers/normal placement and use source-backed selective place/hatch/fuse actions.
  Finish owned hatch/fusion before advancing the quest. Favorite/equipped pets are
  excluded; Wisp fusion can consume mutated unfavorited pets, as documented.
- Keep pending consumption across OFF/ON; no blind ambiguous BeginFuse retry.
  Never clear shared IsExecuting or touch a newer character/owner in cleanup.
- Quest-only NPC/plot pivot follows Chili fallback; N3 normal movement is untouched.
  Check six-stud arrival, daylight, race and generation before quest requests.
- Run `tools/check_wisp_source.py`, all seven prior checkers and full production
  Luau compile. Exactly seven insertion sites reverse byte-for-byte to 3748a3e;
  historical checks strip Wisp first without replacing any prior expected hashes.
  Library/loader/references stay untouched. Static checks are not live acceptance.

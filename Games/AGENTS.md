# Steal-An-Egg maintenance contract

Read this before changing `Steal-An-Egg.lua`.

## Reference and synchronization

- The active normal Auto Steal reference is `Source/StealAnEgg/SenaV2.lua`
  from main `a2fb701`, blob `a36898ee403cacf3aa9742bfb9f9270f867cb765`.
  Read the normal `t46` controller, not the later player-steal/event systems.
- The user explicitly retired the old source V1 reference and integration.
  Do not restore it. Future source event work is outside this change.
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

## Race Rally (separate source V2 event integration)

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

- New user instruction overrides source's egg-first HigherFirst policy: eligible
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
- The bundled source reference still has max 160/default 150. The screenshot showed
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
  source audit implemented. See `../docs/lab-egg-seller.md` for scope/live checks.
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

- See `../docs/wisp-quest.md`. Latest user instruction supersedes the old tabs:
  Progress -> ONE named/icon/collapsible Quests group, NO Wisp/Banjo subtabs.
  Order in the group: `Wisp:` status, `Banjo:` status, `Auto Wisp` toggle,
  `Auto Banjo Cricket` toggle. No divider between the two quests. Both
  default OFF. Never move quests back into Home or Event or create a
  second outer group.
  User accepted c620126 and moved on: preserve its Forest-door transport.
  Server Hop/tools remain deferred as a separate manager module.
- Follow source 41403–42256. Read WispQuests/Save and real area DropTables; do not
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
- Live-failed transports: 4d2db61, 47e1483 and 36128e6. Latest user correction
  supersedes no-TP: hold Forest egg -> direct door TP. Use Forest-only shared
  carry/guard/window transport, reuse held Forest and an already-active real
  window. Wisp >40 uses this; no world tween or unprotected far pivot fallback.
  Original source >1200 / >40 fallback is reference behavior, NOT the current policy.
  Read ../docs/quest-ragdoll-transport.md, 5414–5567 and health 42455–42623.
- Run `tools/check_wisp_source.py`, all seven prior checkers and full production
  Luau compile. Exactly seven insertion sites reverse byte-for-byte to 3748a3e;
  historical checks strip Wisp first without replacing any prior expected hashes.
  Library/loader/references stay untouched. Static checks are not live acceptance.


## Banjo Cricket quest

- See `../docs/banjo-quest.md`. Progress -> Quests, the SAME existing group as
  Wisp. No AddTabbox/AddTab in quest UI. Layout: `Wisp:` status, `Banjo:` status,
  `Auto Wisp` toggle, `Auto Banjo Cricket` toggle (no divider, status lines on top).
  Do not change quest workers or movement for this presentation adjustment.
  No Butterfly or server tools import.
- Follow immutable source V2 14644–15798 and the scoped TreeTrip dependency through
  72421. Official BanjoCricket data/flags/save and Effect/Aim/AskClaim only;
  listen to server Notes, activate a real bat and require matching new Note acks.
  Playback/Wrong/Reset invalidate old notes even during travel/cooldown.
- Tree unlocked + bat required. One cancellable worker, native idle, Wisp priority
  lane and exclusive `banjo` movement owner; race first. Do not force shared
  IsExecuting, farm/defense settings or invisibility. Do not run steal-only
  RunPace/FlyToPosition by pretending that stealing is active.
- The walk/pathfinding + Lift adaptation in 4d2db61 FAILED the user's live test;
  do not restore it or treat compile success as route acceptance. Use the shared
  quest transit below: Forest egg / real guard-window TP to entrance, actual
  prompt/attribute entry, vertical
  rise to hint.Y+18, horizontal flight to hint+18, END flight and naturally fall.
  Source-speed-60 flight for mushrooms, Jitterbug and SecretRoomExit; separate
  ExitTrigger flight/short walk to leave. For door approach >60 use Forest TP,
  fail closed if refused; no world flight fallback. The source local >30 prompt
  pivot is behind a <=60 approach check. Preserve the remaining room/exit flow.
- Scope native inventory/fusion actions and normal/Instant activity through the
  existing adapters; preserve preferences and restore only owned adapters.
  Late cleanup requires the same living actor/root/humanoid and `banjo` owner,
  and must not travel/restore tools after race takeover or unload.
- Success requires authoritative Save.BanjoCricket.Claimed. Keep ambiguous claim
  dispatch pending across OFF/ON rather than issuing duplicate reward calls.
- Run all ten current source checkers + full production Luau compile. Reviewed marked
  sites reverse byte-for-byte to published Wisp 7591d6f (SHA256 in checker).
  `wisp_scope.strip_wisp` strips Banjo first so historical expected hashes stay
  unchanged. Library, loader and bundled references remain untouched.
  None of this is a live/server/reward/FPS acceptance test.


## Wisp / Banjo Forest-door correction after 36128e6 live rejection

- Latest explicit instruction: **Forest egg held -> direct door TP**. Do not
  repeat the nearest-any-area port or custom Wisp/world-entrance tween. Source
  5414–5567 supplies real CarryFieldEgg / ForestStrike / RagdollEndTime / drop /
  hold protocol. Only a real future server window permits the destination snap;
  already-active windows must not be missed. No fabricated ragdoll attributes.
- Forest-only selection and fail-closed removal of source far fallback are
  explicit user-driven deviations, not claims about the immutable source selector.
  Wisp >40 / Banjo approach >60 uses this transport; no far fallback after failure.
- Read source Proto_122 (42455–42623): health maintenance, BreakJointsOnDeath=false,
  RequiresNeck=false, Dead disabled. Keep equivalent protection private to owned
  quest ragdoll transport. Capture/restore flags, disconnect all links, permit
  healing only the same owned actor, never move a zero-health actor or heal a race
  actor. Local protection is not authoritative server immortality.
- Existing Wisp/Banjo lease adapters already suppress TriggerGuardDodge. Do not
  invent another controller. The native ragdoll attribute handler also needs the
  narrow quest exemption; mobility/defense heartbeats already have scoped guards.
- No new movement worker/swap, global Anti Guard changes, normal/Instant selector
  edits or race changes. Room flight/puzzle/reward flow stays separate from entry.
- `tools/quest_transit_scope.py` keeps the original four scopes plus three exact
  literal additions: ragdoll attribute guard, Wisp held-Forest admission, and
  preserving that carry during tool prep. Frozen historical hashes stay unchanged.
  Run all ten source checkers + full production Luau compile. All three preceding
  live failures remain recorded. No live death/glitch/server/FPS success claim.


## Butterfly Bloom / Shooting Star

- Read ../docs/butterfly-shooting-star.md and source dependencies, not only UI names.
  Source 19664–20342 / 49077–49316 (Star); 71401–73412 + 40119–40233 /
  42455–42623 (Butterfly, TreeTrip, flight and health). Keep semantic names.
- Event -> Shooting Star stays separate. The latest user request unifies all
  Butterfly controls in ONE named/icon/collapsible Event -> Butterfly Bloom
  group, containing a nested tabbox: Catch (bug) and Workshop (flower-2).
  No duplicate Home workshop. All OFF by default; preserve IDs/callbacks and the
  user's separate flat one-group Wisp/Banjo Quests UI (no quest subtabs).
- Catch sub-tab order: `Status:` / `Total Caught:` / `Live:` labels first (the
  three live status rows, with the keyword + colon prefix in N3 purple
  `#D946EF` and the value/separator in default white — implemented via the
  shared `show()` helper plus a `Purple` keyword list on the label table),
  then `Catch Mode` / `Catch Priority` / `Catch Butterflies` /
  `Catch Speed` controls, then the `Auto Butterfly` toggle at the bottom.
  The Mode/Priority/Butterflies/Speed controls are NOT hidden behind the
  `Auto Butterfly` toggle anymore — they stay visible so the user can
  pre-configure them without first turning the auto on. (Drop the
  `AddDependencyBox` wrapper and the `SetupDependencies({ { catchToggle, true } })`
  gate.)
- Workshop sub-tab order: `Status:` / counts row (same keyword-only purple)
  first, then `Auto Trade Up` / `Trade Up Tiers` / `Smart Trade for Essence` /
  `Auto Craft Essence`. The `Trade Up Tiers` dropdown and `Smart Trade`
  toggle are also no longer hidden behind the `Auto Trade Up` toggle —
  drop the second `AddDependencyBox` / `SetupDependencies` gate. Counts
  format: `Emerald: N - Sapphire: N - Amethyst: N - Radiant: N - Essence: N`
  (single space around the dash, no `|` separators). Each of the five
  resource names is purple; the numbers and dashes stay white.
- `Purple` keyword list: each label entry that wants the keyword accent
  carries a `Purple = { "Keyword1", "Keyword2", … }` array. The shared
  `show()` helper runs
  `text:gsub("(Keyword1|Keyword2|...):", '<font color="#D946EF"><b>%1:</b></font>')`,
  so only the matched `Keyword:` prefix is wrapped. Initial `AddLabel`
  text stays plain until the first observer tick. `countdown()` was
  tweaked to use the colon form (`Live: Ns left` / `Live: bloom window`)
  so the `Live` keyword matches.
- tools/check_butterfly_ui_source.py reverses four exact presentation edits to
  a815629 (SHA256 d4c01e1236479c77375239022bcdf3363ea48cdb9bbf5ad32a079636845deaa6).
  Keep this frozen along with historical hashes. Run it plus the prior eleven
  source checks and full production Luau compile after this UI revision.
- Do not add a speculative butterfly catch/swing remote. Source equips the actual
  net and uses game net capture; observe Saved Butterflies for counts. Star uses
  exact payload feeds / Hold / Catch and increments only on matching Claimed.
- Reuse owned transit via NewEventTransit; no parallel swap/rig/flight controller.
  Only star/butterfly get source generic travel eggs; approved Forest-only quest
  behavior remains. Capture and clean up private health/flight state through the
  same living actor/owner; never write over race or a replacement character.
- One event job worker + one single-flight read-only AskState query. Race-first,
  native cycle/inventory completion, no forced Movement.Owner stealing, no user
  farm/defense flag changes. External held eggs must not deadlock event admission.
- Workshop consumes butterflies. Keep raw tier-only/no-argument machine RPCs,
  actual tree/machine proximity, recipe reserves, source smart planning and saved
  consumption confirmation. Unknown outcomes remain pending across OFF/ON.
- Pending RPC cancellation releases owned movement/health without clearing the
  dispatched request or spawning a second action worker; allow Race to claim.
  The event/inventory lane still waits for the reply. Actor identity + Aborted
  must stop a late callback from moving the cancelled job, including tree exit.
- Source adaptation deliberately waits for externally applied invisibility;
  don't import another global preference/controller. Do not fake success from
  proximity, movement return, a sent remote or compilation.
- tools/bloom_star_scope.py reverses nine marked additions to exact 7e9549a
  (SHA256 29637582c16bc01ec2d250fa504042979b7b40964de7853266f126db4a4f1b7d).
  Three cancellation hooks are exact tiny insertions; native gameplay blocks and
  all historical expected hashes stay frozen. Run all eleven source checks plus
  full production Luau compile; no live/server/FPS success without actual tests.


## Capture The Egg

- User authorized after discussing source mechanics; Home (farm) -> Capture The
  Egg, not Event. One named/icon/collapsible group. Auto OFF, dependent holder
  taking ON per source, height 20–120/default 45, KeepAway 20–150/default 45,
  status + server standings. See ../docs/capture-the-egg.md for full mapping.
- Read source 4430–5959 plus combat 35555–36235 / 38664–38705, not just UI labels.
  UID/carrier possession, actual prompts/raw carry, generic non-event starter
  ragdoll, holding footprint/threat geometry, real bat prediction/steer/trigger.
  No fabricated hit/score, reward claim or depositing the event egg in a base.
- Race always preempts. Do not set CaptureUntil or force Movement.Owner; source
  capture precedence is only over non-race tasks when actual UID/record exists.
  Let an unrelated existing carry finish. A held event egg must not be adopted
  by normal/Instant banking, even after Capture OFF.
- Use the existing shared runOwned/callOwned worker and transit registry. No
  second action worker/swap/rig. ControlGround holds/glides with normal body
  flags; chase uses Control flight. Close whole-job health service for Capture;
  scoped ragdoll/chase protection remains. Preserve Forest-only Wisp/Banjo.
- Exact bat trigger(player, trace); real equipped bat, cooldown/range, target
  eligibility/PvP and still-holder recheck. Preserve source lead/feedback/wall
  logic, including current-target Z projection. No imported PvP aura/swap UI.
- Standings only from RE/EggCapture/StandingsRefreshed, matched UserId; no local
  seconds increment. OFF/end may descend only through same living actor/owner;
  race/takeover/unload forbids cleanup motion. Pending RPC cancellation releases
  movement and disconnects chase; late replies cannot move the cancelled actor.
- `.tools/capture_scope.py` reverses reviewed scopes exactly to 6d4af13,
  SHA256 `51f6c97c5f7eff2808726749e6d36c6cb2a373e23768604bca9068393cb7551d`.
  Historical normalization strips Capture first without updating frozen hashes.
  Run all fourteen source checks (`.tools/check_*_source.py`), full production
  Luau compile, diff/identity checks. No live event, score/reward, route/death
  or FPS claim from static tests.  The single change log lives at
  `docs/CHANGELOG.md`.
- `.tools/admin_scope.py` reverses the Admin Abuse block to the new
  pre-admin baseline SHA256 `7c68d364b5ee7d24a9d274dcdbef64390496ad8dde71c35f0b49f9142d1fa562`.
  The inner `-- BEGIN/END ADMIN UI` markers scope the UI body inside the
  function.  Run `.tools/check_admin_source.py` with the rest; preserve source
  V2 8950-9330 dependencies and the existing N3 Treadmill mount reuse.
  Admin Abuse is a top-level tab; Capture The Egg now lives inside it
  instead of as a Home group.

## Minigame Egg sub-controller (RLGL + T-Rex Run)

- Sits inside the same Admin Abuse top-level tab, no separate outer group.
  Auto Steal Minigame Egg toggle defaults OFF. Status row "Minigame: …" in
  Admin Status. Header switches to "ADMIN ABUSE LIVE" while minigame is live.
- Mirror of source V2 76810-77070: same attribute names, same `m(pos)` UID
  distance cap (40 studs) and the same 2 s stable-UID gate before pickup.
  No ngarang; we read `workspace:GetAttribute("Event_RedLightGreenLight")`,
  `"Event_TrexRun"`, `"<Prefix>_EggPosition"` Vector3, and
  `"<Prefix>_CarrierUserId"` exactly as source does.
- Pickup is N3-native: `Engine.CurrentTarget = uid` then
  `Engine.AutoWake()`. Do NOT call `Engine.StealNow(uid, true)` thinking it
  will queue-and-wake; N3's StealNow only clears the block list and bumps
  the session id. The forced pickup is `CurrentTarget` + `AutoWake`.
- `EggStateModule.ReadFieldEggs().Records` is reused (the same call Capture
  uses). Records with `State` `Carried` / `Claimed` / `GuardCarried` / `2`
  / `3` are excluded. The first record with `PrimaryPart` inside 40 studs
  wins.
- On takeover the controller saves `FarmConfig.AutoStealAll /
  AutoStealSelected / AutoStealEnabled` once (guarded by a `TurnedSteal`
  flag) and forces them to false so the farm does not race the minigame.
  The same flag restores the saved values and clears
  `Engine.CurrentTarget` + `Engine.CancelAutoSteal()` on toggle off,
  race takeover, character change, unload or when the event goes cold.
- Race first: `RaceShouldYieldSteal` / `RaceOwnsCharacter` gate every
  mutation. `Tasks.MinigameRestore()` is exported so the unload path and
  any future race-leased cancellation can release the takeover without
  leaking `CurrentTarget` or stale FarmConfig.

## Branding (N3 Hub, not Chili)

- User-facing strings in `Steal-An-Egg.lua` (Text / Tooltip / AddLabel /
  AddLabel note / status row returns / header returns) must not contain
  "Chili" case-insensitive. Comments and code paths that need the
  reference file may keep `ChiliSourceV2.lua` because the immutable
  reference filename is required for the read-only hash check. The
  `Documentation/AGENTS.md` files reference the path, not a brand.
- All `.tools/*.py` checker comments were updated to "source" / "source V2"
  to keep the read-only error messages neutral.

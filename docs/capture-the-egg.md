# Capture The Egg — semantic Chili V2 integration

## UI / scope

**Home (farm) → Capture The Egg**, one named/icon/collapsible group:

- Auto Capture Event Egg: default **OFF**; settings settle for three seconds.
- Take From Holder: default **ON**, matching Chili, dependent on Auto Capture.
  Requires an actual owned bat and hittable holder; no bat purchase / forced PvP.
- Hold Height: 20–120, default 45.
- Keep Away Distance: 20–150, default 45.
- Status; Held seconds and Rank from the real standings feed.

This is an event **hold-the-egg** workflow, not egg banking or an ordinary Auto
Steal category. Source UID/carrier records decide possession. Neither sending
carry/hit requests, reaching a destination nor waiting locally proves scoring,
hits, a win or reward. No invented claim/deposit remote is added.

## Immutable source map

Reference: `Games/Source/StealAnEgg/ChiliSourceV2.lua`, unchanged SHA256
`0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d`.

| Chili V2 lines | Semantic implementation / dependency |
| --- | --- |
| 4430–4585 | `eventUid`, `eventRunning`, `readEgg`, `eggPosition`, `heldByMe`: exact event attributes and field records; model → BottomCFrame → official spawn fallback |
| 4586–4740 | `carryBounds`, `footprint`, `threats`, `clearance`, `chooseHover`, `updateHover`: rotated bounds footprint, guard/player scores, nearest acceptable or best-clearance fallback |
| 4741–4935 | Existing owned job + transit; one active job, mode transition, owned descent/cleanup; frame-based glide and PreSimulation chase |
| 4936–5050 | `carryPrompt`, `grabEgg`: nearby SmartPromptPart/CarryAreaEgg with competing-egg rejection, raw CarryFieldEgg UID/slot fallback, source budget/cadence |
| 5051–5110 | Hold: safe field footprint / KeepAway, height, hover invalidation and 0.25-second refresh |
| 5111–5414 | Shared `RagdollTravel`, Capture-specific generic selector/exclusion/arrival: ordinary starter egg, ForestStrike, real server window, drop starter, up to eight-second event grab |
| 5529–5710 | `captureJob`: >220 ragdoll cadence 4s / 2s after landing, base wall/night gate, source aerial exit dependency, <=220 grab snap, otherwise speed-400 glide; other holder chase/wait |
| 5711–5959 | `RunCapture`, `bindStandings`, `BuildCaptureUI`: availability loop, server Entries/Standings/flat shape, exact controls, actor/unload cancellation |
| 35555–35849 + 38664–38705 | Combat eligibility, actual bat classification/range, equip gate and target restrictions |
| 35850–36010 | `walls`, `pushOffWall`, `keepOffWalls`, `aboveFloor`: cached GUARD NO COLLIDE wall sides, six path samples and player-excluding floor ray |
| 36011–36235 | `combatPlan`, `settleHitFeedback`, `steer`, `tryHit`: tracking/prediction, feedback/UCB lead selection, physical steering, cooldown/range-gated exact bat trigger |

The runtime uses semantic locals/functions; no obfuscated VM wrapper is imported.
The source's generic public RagdollTravel export at 5415–5528 is already supplied
by the shared owned transport. Capture-specific arrival/exclusion extends it
without replacing the user's approved Wisp/Banjo Forest-door policy.

## Protocol / dependency details

- Read `Event_CaptureTheEggUid` as the raw string UID; event attributes are
  truthy except nil/false/0/empty. Source eligibility is actual UID **and** field
  record, not solely the live-banner flag. Missing record/UID releases the job.
- `ReadFieldEgg` falls back to `ReadFieldEggs().Records`; possession uses the
  actual CarrierUserId / native CarryUid signal. Never mutate carrier records.
- Resolve matching AreaEggSlotsClient model, world model, BottomCFrame, then
  CaptureTheEggSpawn/AdminAbuseEggSpawn. No fabricated world positions.
- Nearby prompt selection rejects one closer to another egg. Temporarily zero
  HoldDuration only around the real prompt dispatch, restoring the value even
  on error. Raw carry fallback receives UID and AreaId:NestId (or nil), not a
  made-up capture-specific argument. Attempt window 1.4s, request cadence 0.08s.
- Far jump excludes the event UID from the starter selector; retain the real
  carry/guard strike/window/drop protocol. Stop tracking a target newly held by
  another player. Arrival pickup uses the same existing owned ragdoll scope,
  not another flight/controller; up to eight seconds, exiting on carry/other
  carrier/cancellation. An already-active future ragdoll window is supported.
- Holding explicitly leaves flight/GodMode: Capture closes the shared job's
  whole-job health service, using ground glide with original body states and
  collisions. Ragdoll and chase separately own their existing scoped protection.
  Never keep the Butterfly flight mode active just because both are events.
- Hold samples X every 50 studs, three Z lanes, margin 14; Y is top-of-bounds +
  selected height. Player distance is 3D, guard distance horizontal scaled by
  KeepAway/32. Prefer nearest score >=KeepAway+10; otherwise maximum clearance.
  Existing hover remains until invalid/unsafe; missing streamed bounds waits
  without retaining chase velocity. This is source selection, not a safety proof.
- Capture uses the default source best/equipped bat path. Data.Gears.Directory
  supplies GearName/BatControllerData; IsBat and untyped weapon-name fallbacks
  match source. The unrelated multi-weapon combat-swap UI/aura is not imported.
- Hittable excludes self, departed/dead players, trapped targets, boss arena and
  bases. Actual PvPDisabled, ragdoll, range, equipped tool, cooldown and request
  cadence gate the bat trigger. Revalidate the player is still the event holder.
- Keep source ping/historical/current estimates, 0.12-second sample history,
  smoothed horizontal heading, six adaptive lead options (0.12–0.6), sweep/side
  oscillation, and the source's unusual current-target Z projection. Do not
  silently "correct" it into a different homemade intercept algorithm.
- Steering uses cap min(400 + target speed, 750), wall correction, gravity
  compensation, and facing. Bat trigger is exactly RE/BatSwing/Trigger(player,
  UserId:trace:serverMilliseconds), **not** Tool:Activate or a made-up hit RPC.
  Feedback uses actual target ragdoll / tool cooldown changes for lead tuning;
  this is not a claimed hit counter or source of Capture score.
- Standings accepts payload.Entries / payload.Standings / flat list, matches raw
  UserId, then reads Seconds and Rank (or server list order). No local score clock.
  The agent has not observed this feed, reward payout or current event live.

## Native lifecycle / intentional N3 adaptations

- **Race always preempts Capture**, unlike Chili's CaptureUntil arbitration.
  Never write CaptureUntil (which would block the existing race controller), force
  Movement.Owner, alter race bodies, or turn off the user's farm/defense toggles.
- Other tasks yield to genuine Capture demand, not its toggle alone. This follows
  source Capture's fixed exclusive precedence rather than adding an inert farm
  Priority label. Carrying a different egg suppresses admission so that native
  carry/deposit can finish. Already holding the event egg is explicitly admitted.
- Reuse `runOwned` / `callOwned` in the existing shared Butterfly/Star action
  worker and the same transit registry. Capture adds **no task.spawn or second
  action worker**. One read-only 0.5s UI observer and one job-scoped PreSimulation
  callback supply the source frame-phase dependencies, not competing jobs.
- Wait for native cycles, guard actions, quest leases, belt exit and tracked
  inventory actions; use existing normal-character restoration. Do not import
  another Chili Shield/humanoid-swap or force ownership after a timeout.
- Never let normal/Instant banking adopt a held event egg, including after Auto
  Capture OFF; a narrow native activity/claim guard waits for its release/end.
  Do not drop the actual event egg to pretend ordinary farming can resume.
- OFF/missing event disconnects chase and, if still owning the same living actor,
  attempts the source descent (speed 160, <=1.5s) to footprint Y+3.5. Race,
  replacement/dead actor, unload or lost ownership forbids old cleanup motion.
- A sent carry RPC cannot be recalled. Existing pending-call cancellation stops
  transport and chase and releases the actor for Race, but the single worker and
  inventory gate wait for its reply. A late callback cannot move a cancelled
  actor. Network/game-state hangs can delay the next job; no fake acceptance or
  speculative world-egg repair is used. Unload disconnects chase even if RPC hangs.
- Externally applied invisibility remains a wait condition, not an imported
  global preference toggle. Wisp/Banjo quests and Butterfly Catch/Workshop layout
  remain unchanged. No Library/loader/reference edits.

## Verification / live checklist

`tools/capture_scope.py` reverses only the exact marked Capture additions to
published `6d4af13`, SHA256
`51f6c97c5f7eff2808726749e6d36c6cb2a373e23768604bca9068393cb7551d`.
Historical expected hashes are frozen. Run `check_capture_source.py`, all twelve
prior source checks, full production Luau compilation and `git diff --check`.

These are static contracts/compile checks, not a Roblox simulation or live
acceptance. User live checks still needed:

1. OFF/load old config, no event, banner-only start, missing UID/record, late spawn.
2. Loose egg near/far; correct prompt among nearby eggs; raw UID fallback; starter
   exclusion, real guard window, no-starter/refused-strike and lost-carry paths.
3. Holder with/without bat, take toggle OFF, PvP disabled, cooldown, moving target,
   ragdolled/dead/left/boss/base target and holder changing immediately before hit.
4. Actual event possession, hover threats / streamed or missing rotated bounds,
   height/KeepAway settings, no bank/deposit, authoritative time/rank and payout.
5. OFF/ON, UID replacement/event end, death/respawn, race takeover during chase /
   ragdoll / carry request, late RPC and unload. Check normal/Instant/quests/belt
   resume correctly after the actual event egg is no longer held.
6. Route/death, anticheat rollback, low-end/mobile load/FPS and server outcomes:
   none are established by compilation or these source checks.

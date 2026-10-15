# Normal Auto Steal: Sena lifecycle + N3 egg approach

## Reference and scope

Active reference: `Games/Source/StealAnEgg/SenaV2.lua`, imported from main
`a2fb701f970e3f542da1000feed19304cc6024ab`, Git blob
`a36898ee403cacf3aa9742bfb9f9270f867cb765`.

The user retired the old Chili V1 integration. Its source file and normal
controller, starter/guard-hit stages, scheduler and duplicate humanoid-swap
implementation have been removed. Other games are outside this change.
Future event-source work is not included.

This is a readable, scoped adaptation of Sena's normal `t46` Fly lifecycle,
**not** execution of the 31,520-line source or a claim of literal equivalence.
The later player-steal, admin and capture/event controllers are not imported.

## Source-to-runtime mapping

Line numbers below refer to the unchanged Sena reference.

| Sena reference | N3 integration |
| --- | --- |
| `_chooseTarget` / `isSkippedEgg`, 6105–6414 | `ChooseTarget` uses N3 `CollectCandidates(false, true)` for existing filters, Index/Scramble priorities and sorting. It accepts Slot/Dropped records, excludes the capture-event UID and respects timed skips. |
| Fly branch of `_schedule`, 11281–11639; `_startPrimerTargetHunt`, 6833–7077 | `Tick` / `RunSenaCycle`: one target, no starter egg and no armed guard-hit wait. Already-carried local eggs go to delivery before selecting another egg. |
| `_installGuardHitDistanceBoost`, 6442 | Normal hunting's `ResolveHitDistance = -math.huge` policy is scoped to the cycle and **gated by the existing Anti Guard toggle**. No priming-distance boost is imported. Restore the original function on cancellation/finish/unload. If unavailable, retain N3's optional dodge fallback. |
| `v730`, 4099; `_requestCarry`, 9594–9801 | `StartCarryRequest` / `RequestTargetCarry`: stop velocity, ping-based wait, source payload `{Uid, FirstAreaSlotKey?}`, poll live own-Carried records, preserve rejection text and re-approach when displaced. A successful remote return alone is not carry confirmation. |
| `_resolveSettleSeconds`, 6804–6832 | Source default hold level 5 gives carry confirmation budgets 11s normally, 21s Enchanted, 19s Light/Dark, 13s Titan. These are request budgets, not a mandatory sleep at every egg. |
| `_recoverCarryConfirmationTimeout`, 9506–9593 | Return to the source safe point after timeout. Prefer the same eligible UID for the first retry; skip 45s after a second timeout. N3 filters still apply to retries. |
| `_returnToSafe` Fly branch, 10780; `_instantReturn`, 10127–10577 | `DeliverSenaEgg`: glide to source drop point, attempt drop up to 3 times (0.15s pre-drop / 0.45s confirmation), read dropped position, visit safe point, re-approach and re-grab. |
| `_regrabBurst`, 9402–9505 | `RegrabBurst`: source ragdoll release, egg placement, direct/native carry lanes and the egg's own proximity prompt, sampled every 0.06s. Main re-grab lasts 0.5s; fallback 0.6s. |
| `_treadmillResetInner`, 9975–10126 | `TreadmillReset` only after first re-grab failure: local plot TreadmillBottom, AskWearStill/AskDoff and render-snapshot checks, then repeat the safe-point/re-grab path. |
| `_walkTo` / `_walkLeg`, 7810–8154 | `WalkToSafe`: natural Humanoid MoveTo and measured braking for the final deposit boundary. No final-boundary tween or manual forced claim. |
| `_reStealDroppedEgg`, 9303–9401 | `RecoverDroppedCarry` owns unexpected dropped-egg recovery within the same worker, rather than starting a competing background picker. |
| `_instantReturn` final wait; `_reportStolen`, 11026–11077 | Wait for source Claimed/missing-field condition, then read the field again after 1.5s before releasing a post-place serial. Slot, Dropped **or any remaining Carried record** fails the recheck. Missing field data is still not an independent server-acceptance proof. |
| `_startWatchdog`, 11078–11173 | Bound the carried-target return at 60s. N3's separately bounded approach is not charged against that return budget. |
| `_finish` / `_schedule`, 11244 onward | A single scheduler polls/wakes at 0.35s, waits for movement/Auto Place/priority ownership, and releases all cycle resources before starting the next worker. No-target field idle returns use the same worker. |

## Movement and character dependencies

- **Egg approach stays N3:** `FlyToPosition -> RunPace`, including its existing
  pace, climb arc, velocity/CFrame style, guard-busy yield and
  plot-exit reposition. This helper was also checked against the initial
  `67d91fd` version. `RunPace` movement is unchanged; its old camera freeze yields only while the built-in decoy is active.
- `FlyToPosition` has one optional fifth argument for the separate normal speed
  cap. Old four-argument Instant callers retain their previous behavior.
- Normal slider remains **100–1000, default 400**, separate from the Instant
  `TweenSpeed = 600`. It caps N3 approach pace; it does not turn N3's original
  pace into an unrestricted speed. Sena's return glides remain **5000**, and
  the final walk uses Humanoid WalkSpeed. The tooltip states that distinction.
- Reuse existing N3 `PerformHumanoidSwap` / `RestoreCharacter` and control/
  animation bindings for the requested persistent normal-mode swap. Do not
  retain a second imported swap body.
- Sena `v769` health/state preparation is scoped to the normal N3 clone and
  restored on release. The keeper restores zero health rather than healing
  every partial hit. Health preparation does not change the Anti Guard toggle.
- Sena `v801/v826/v831` baseline discovery/update is retained with semantic
  names, a cached result and source backoff (1s misses, then 10s after 5 misses).
  N3's detached original humanoid is also accepted when the game's character
  state still references it. No new Disable Monitor setting or module-wide
  monitor shutdown is added.
- Arrival holds/hover pad/baseline updates are cycle-scoped. Egg approach uses
  N3 without that pad; delivery/re-grab uses the source support geometry.
  A normal worker yields when an optional N3 guard dodge is already busy.
- Sena-style safe-zone decoy/camera hiding and reversible popup suppression are
  now built into normal **and Instant/Line Drop** stealing, without a new toggle.
  The user confirmed the normal test version works and feels lighter on their
  phone; its shared Instant integration still needs live validation. See
  `auto-steal-visual.md` for lifecycle, source mapping and scoped camera changes.
  Existing optional Anti Trap remains user-owned; no always-on trap purge is imported.
- The capture-event egg is excluded from normal selection, as in Sena. If one
  is already carried, normal stealing yields rather than banking/dropping it.

## Ownership, reporting and boundaries

- Generation + session + cancel counter + character/root identity invalidate
  old work. Carry/treadmill remote lanes are single-flight per cycle; late
  responses cannot advance a cancelled cycle. An already-sent server request
  cannot be recalled by local cancellation.
- No next normal worker starts until the old worker unwinds. Cancellation
  releases resources immediately; ownership waits for N3 approach cleanup to
  unwind, or releases immediately in other stages. Late responses cannot move a
  newer automation. Temporary pad, simulation connection, guard policy, hold,
  camera state and movement owner
  are released on finish, failure, cancellation, respawn and unload.
- An already-carried ordinary egg is delivered rather than force-dropped when
  filters change. New selections/retries still honor N3 filters.
- A second live field read gates the **post-place trigger**, not a universal
  server-success verdict. No unrelated verdict timestamp, inventory UID
  equality gate, tombstone or local field-record rewrite is used.
- Post-place waits for cycle ownership, not a possibly stale CarryChanged
  boolean after the source has completed its field/deposit recheck.
- The bounded 16-row real-event trace remains available when the actual game
  sends a delivery-failed alert. That alert is logged, not assumed UID-matched.
- Instant/Line Drop delivery/run blocks, candidate filtering/sorting, the
  existing N3 swap helper, Library and production loader are preserved.

## Validation status

- Whole game file compiled with native Luau 0.742 and luau-web (not executed).
- `python tools/check_steal_source.py` checks source hash, removed integration,
  single-worker anchors, optional guard preference and preserved code blocks.
- Native analysis still reports baseline Roblox/executor globals and type
  inference diagnostics without Roblox definitions; this is not a clean typecheck.
- **No live Roblox/server or FPS result is available for this revision.**
  Compilation/static review do not prove successful delivery or no rollback.

Live checks for the user: repeat normal cycles with existing filters/priority;
Anti Guard OFF and ON; pickup refusal/timeout; unexpected carry drop; toggle
OFF during travel/return; respawn; night/reset; Auto Place; then verify the
separate Instant/Line Drop path. Capture/event automation is outside this port.

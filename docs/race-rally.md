# Race Rally — Chili V2 lifecycle adapted to N3

## Reference and scope

Reference: `Games/Source/StealAnEgg/ChiliSourceV2.lua`, copied unchanged from
`origin/main` commit `5c1763a`. SHA-256:
`0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d`.
The reference is not loaded or executed by the runtime.

This replaces the old Race Rally block in `Games/Steal-An-Egg.lua`. It does not
replace normal Auto Steal with Chili, import other Chili events, or change the
production loader or Library. The user copies the game file only.

## Source → runtime mapping

Source line numbers refer to the unchanged reference, not the runtime.

| Chili V2 source | N3 semantic implementation |
| --- | --- |
| 49313–49560: race state, schedule, stats, controls | `race`, `PublishRaceStatus`, Event → Race Rally controls |
| 49587–49713: race ragdoll suppression and post-race grace | `Tasks.RaceSuppressRagdoll`, `ResumeRaceRigSync`, 20-second resume delay |
| 49717–49879: network-aware join delay, flag/save window, area/queue/heat detection | `RaceJoinDelay`, `RacedThisWindow`, `InRaceArea`, `EnteredRace`, `InRaceNow` |
| 49880–49923: finish signal, bounded reset | attribute connections, `RequestRaceReset` |
| 49924–50067: path drive, reprojection, speed reduction, power-ups | `StopRaceDrive`, `CurrentRaceSpeed`, `ReduceRaceSpeed`, `StartRaceDrive` |
| 50069–50208: higher-priority wanted work | `HigherPriorityRaceTask`, adapted race-first egg pause/resume (see below) |
| 50209–50319: portal back-off/crossing and movement acquisition | `PassThroughRacePortal`, `ClaimRaceMovement` |
| 50320–50524: treadmill exit, eligibility, portal reset/retry | `ExitRaceTreadmill`, `RaceEligible`, `ResetRaceCharacter`, `RetryRacePortalAfterReset` |
| 50525–50596: off-mount recovery | `NudgeRaceMount` (one-second observation, five-second cooldown, max three nudges) |
| 50597–50843: queue/heat/start/lap/finish/leave/return lifecycle | `TickRaceRally`, `LeaveRace`, `ReturnFromRace` |
| 50844–51266: portal travel and retry escalation | `TravelToRacePortal`, `PassThroughRacePortal`, `RetryRacePortalAfterReset` |
| 51267–51365: owned racer selection, equip, milestones/repeat reward, shop | `UpdateOwnedRaceRacers`, `ClaimAndBuyRaceRewards` |
| 48995–49312: field gate, base exit, step and rollback-aware glide | `WaitRaceFieldOpen`, `LeaveRaceBase`, `StepRaceTravel`, `GlideRaceTravel` |
| 5131–5261 and 5414–5547: closest eligible guard egg and ragdoll travel | `SelectTravelEgg`, `TravelEggHeld`, `RagdollRaceTravel` |

The drive reads the player's `RaceHeat`, resolves it under `RaceHeats`, and uses
that heat's `RacePhase`, `RaceGoAt` and `RaceLaps` (with the source's track fallback).
It does not assume the root `RaceTrack` owns the active heat's attributes.

The source's path projection, 80-stud start gate, 40-stud rollback test,
300/300 reprojection window, Heartbeat/PreSimulation writers, +50 slowdown,
lap-time watchdog, finish attribute, leave request and recovery limits are retained.
Lap/win success comes from game attributes/save, not local path distance.

## Deliberate N3 adaptations

- Semantic names replace decompiler locals/numbered helpers. The bundled Chili UI,
  decoder, scheduler and duplicate character/swap systems are not copied.
- One sequential 0.25-second race tick uses N3 config/UI instead of Chili's worker
  registry. Travel has a single owner, cancellation revision, character identity,
  guarded callbacks and cleanup; errors appear in the status and throttled warnings.
- Existing N3 movement ownership is reused. **User override of Chili HigherFirst:**
  Auto Race outranks normal/Instant egg farming while its eligible join window is
  open and not yet raced, or while queue/heat/travel/reset/return owns the rig.
  Active egg cycles and egg candidates no longer postpone the race; the initial
  three-second egg-inspection delay is removed. Unrelated star/capture extension
  priorities stay intact, rather than importing any additional event controller.
- Normal Sena code, health/swap implementation, filters, approach, Instant and
  Line Drop gameplay remains unchanged apart from the separately documented
  built-in safe-zone visual/camera gates. Race-only adapters temporarily yield
  their shared movement/health preparation; no Anti Guard preference is changed.
- N3 recovery, movement override, trap/ragdoll, night and character-recovery
  callbacks yield while race owns the rig. In particular they no longer clear a
  racer's `PlatformStand` or substitute a humanoid during the heat/queue.
- RigSync connections are disabled reversibly rather than permanently disconnected
  by Anti Ragdoll. Race can re-enable precisely the connections N3 disabled.
  The user's Anti Ragdoll preference is preserved, rather than Chili's UI worker
  forcibly setting it back ON. Source near-portal and 20-second post-race
  suppression is retained without rewriting that preference.
- The source's third portal travel fallback can borrow the nearest eligible
  ordinary egg, request its guard strike and drop it after the jump. It is scoped
  to race portal recovery only, not the working normal Sena path. It does not
  force Anti Guard on/off, and does not add a new global guard policy.
- Source step/base/gate geometry and timeouts are retained. The glide speed is
  bound to N3's existing normal movement-speed preference (default 400), not to
  the racer's 100–160 speed slider or Instant's independent speed.
- Module dependencies retry when streamed/late instead of permanently caching a
  failed require. Exact race remote paths are resolved under Packages/Networking.
- Racer choices come from owned racers/default racer and sort by game `Order`.
  Unsupported old hardcoded choices are removed. UI controls keep their existing
  save IDs, and Race Speed is clamped to 100–160 with default 150. Old saved
  values over 160 are clamped, not silently allowed at 300/400.
- Source feature defaults are preserved: Auto Race/Claim/Buy OFF, power-ups and
  auto equip ON, Best Owned selected. Speed/power-up, racer and shop-item controls
  are nested under their respective toggles. Only Status and Tokens/Wins/Racer
  are displayed; the heat/phase/effective-speed diagnostic row was removed.

## Race-first egg pause/resume

The Chili reference's `HigherFirst` (50069–50208) can finish active carry/steal or
prioritize filtered eggs by rank. Its `Wanted` / ownership transitions and release
wake-up (50597–50905) were reread. Per the user's newer instruction, N3 deliberately
**does not** copy the egg-first policy. The successful N3/Sena steal engine stays.

- `RaceShouldYieldSteal` is true for active race/travel/reset ownership, or for
  Auto Race ON + open join window + eligible + not raced this window. Outside
  that window, when ineligible, or after race return releases ownership, normal
  farming can continue even while the Auto Race toggle stays ON.
- One pause transition increments the cancellation revision and calls existing
  `CancelAutoSteal`; it stops holds/guard visuals without changing any Auto Steal,
  Instant, filter, Anti Guard or other user preference. The guard worker retains
  its Active flag until its final rig restoration finishes.
- `IsStealActive` already routes both normal and Instant through priority yield.
  New steal movement and new guard dodges are blocked immediately. The race tick
  waits for the old cycle, Instant worker and guard worker to release their actual
  execution/ownership state before taking the character. It does not fake those
  workers' completion by clearing shared IsExecuting from the race controller.
- Instant's outer carried-egg retry stops on pause. After its cycle unwinds, that
  worker releases its own execution/movement and skips failure recovery/Auto Place
  for the interrupted iteration. No new egg picker or replacement delivery is added.
- A stale `steal` owner/carry boolean cannot starve the race after the worker has
  stopped. Other live owners retain existing priority/cleanup rules.
- On race release, the pause transition wakes the existing normal scheduler;
  Instant's existing poll loop also resumes. No farm toggle is switched off/on.
  The original farm status row shows **Paused for Auto Race** while appropriate.
- Safe Zone Visual is independent: optional, OFF by default, for normal/Instant.
  Race preemption releases the dummy/camera even when that option remains ON;
  the next accepted farm cycle reattaches after race return.

Live check: farm with Auto Race ON, wait for an eligible join window, observe
pause → worker cleanup → portal/queue → heat/laps/finish → leave/return → resumed
farm. Farm toggles/filters must remain unchanged. Repeat with normal/Instant,
visual ON/OFF, an already-carried egg, Auto Race OFF during travel, and a completed
or ineligible window. These transition changes have static/compile checks only,
not a newly verified Roblox/live race result.

## Validation and limits

- `python tools/check_race_source.py`: reference identity, source contract markers,
  single worker, meaningful names, UI IDs, cancellation and eight protected
  pre-race N3/Sena blocks. These are structural checks, not behavioral proof.
- Whole runtime compiled with luau-web 1.5.1 without running the compiled function.
- Race controller and UI formatted with StyLua 2.6.0 `--verify` (AST preservation).
- Library SHA-256 compared with the pre-edit workspace snapshot: unchanged by this
  task. Existing unrelated working-tree edits were not reverted/staged.
- `git diff --check` passed.
- The older normal-steal checker still depends on historical commit `7081554`;
  that historical baseline does not expose the expected game-file path in this checkout. The new race
  checker fingerprints the actual pre-race workspace instead and does not pretend
  the legacy git-scope audit ran successfully.

No Roblox execution, mock race, simulated server acceptance or FPS claim.
Live requirements: actual join/queue, native racer creation, lap increments,
finish place, wins/rewards, power-up remotes, leave/respawn and streaming behavior.

Suggested user test: re-execute the updated game file in a fresh script instance,
Event → Race Rally, Auto Race ON, Auto Equip Racer ON, Best Owned, speed 150,
power-ups ON. If laps/wins do not count, lower speed toward 100 as advised by the
source. For a failure report, capture the status, Tokens/Wins/Racer and any
`[N3 HUB] Race Rally` warning. Check disabling Auto Race mid-travel/mid-heat and
resuming normal Sena automation after the event as separate live checks.

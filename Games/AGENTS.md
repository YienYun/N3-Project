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

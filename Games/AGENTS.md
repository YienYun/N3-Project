# Steal-An-Egg maintenance contract

Read this before changing `Steal-An-Egg.lua`.

## Reference and synchronization

- `Source/Chili-SourceV1.lua` is the original reference, not a second runtime
  controller. Keep its original contents; never execute it inside the N3 script.
- Before further steal work, fetch `origin/main`, inspect incoming changes and
  synchronize them into the current Arena branch. Do not reset the branch to
  main or overwrite the customized runtime. Never push to main or open/merge a
  PR unless separately authorized. Review the diff before merging.
- Current imported reference: main commit `21647779fd113cbeb4bdc737da2d62ff3bedc510`,
  source Git blob `8d7fa550e7ffd84b7979d2cdb24acad005d85590`.
- Main `a2fb701` also added `Source/StealAnEgg/SenaV2.lua`; it is synchronized
  as a separate reference, not substituted for Chili without review.
- If main updates the reference, read the changed source and update the mapping
  in `../docs/auto-steal.md`; do not assume an older cached copy is current.

## Runtime requirements

- Runtime code must use meaningful function/variable names, not copied `fn23`,
  `v34` or `tbl18` names. The untouched original reference is exempt.
- Learn the source's state transitions and dependencies, not only its movement
  helper: health preparation, persistent Humanoid Swap, candidate selection,
  starter pickup, armed guard hit, standing recovery, target pickup, home drop,
  failure/cancellation cleanup and scheduler wake.
- Anti Guard is an optional user preference. A steal cycle must not switch it
  on or off. Scripted hit arms suppress independent dodges; ordinary movement
  yields while an optional dodge is busy. Line Drop suppresses dodge execution
  without overwriting the toggle.
- Only one normal worker and one normal motion owner may run. Every exit must
  release holds, movement callbacks and guard-hit listeners. Don't add another
  background picker or recoverer to work around a stalled stage.
- Keep N3 filters/priority. Raw normal carry state and the optional guard's
  heuristic carry state serve different purposes; do not merge them blindly.
- Preserve Instant/Line Drop movement and the production loader. Shared normal
  helpers should not duplicate home geometry, guard lookup or native requests.
- A local delivery-method return is not server acceptance. Never use an
  unrelated native verdict timestamp or identical inventory UID as a shortcut.
- Do not invent rollback causes, new native remote payloads or unobserved game
  mechanics. Read the actual failure trace before changing delivery policy.

## Validation and communication

- Syntax compilation, static analysis, source review and scoped rename/AST
  checks are allowed. Run `python tools/check_steal_source.py` for static
  integration checks. These do not establish Roblox/server correctness.
- The user performs live tests. Do not run mocks/simulations and present them as
  proof of no rollback, successful repeated delivery or low-end FPS.
- Record actual changes and remaining uncertainty. Never call a version
  "working" only because compilation/static checks passed.

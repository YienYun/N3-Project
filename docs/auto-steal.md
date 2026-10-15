# Normal Auto Steal: reference and integration

## Version and current acceptance status

The branch includes the original `Games/Source/Chili-SourceV1.lua` imported from
main `21647779fd113cbeb4bdc737da2d62ff3bedc510` (Git blob
`8d7fa550e7ffd84b7979d2cdb24acad005d85590`). Main was merged into this branch;
main itself was not modified. A subsequent main update (`a2fb701`) adding
`Games/Source/StealAnEgg/SenaV2.lua` was also merged. That file is retained as a
separate reference; its method was not silently mixed into the Chili controller.
Fetch and review main again before subsequent
changes, rather than reusing a scratch source cache.

The user reported server rollback on `406d76b`, including the literal port.
**The exact server rejection cause remains unverified.** The present revision
corrects integration/lifecycle issues and readability; static checks cannot
establish that the server now accepts delivery. The user live-tests the script.

## Mapping (original names are reference coordinates, not runtime identifiers)

| Runtime component | Reference component |
| --- | --- |
| `MaintainShieldHealth`, `CreateShieldSwap` | Global health keeper before shield; shield `fn12` |
| `SelectCandidates` | `fn18`, adapted for N3 filters and priorities |
| `DriveRootVelocity`, `HoldPosition`, `MoveToPosition` | `fn19`, `fn23`, `fn34` |
| `FindSlotCarryPrompt`, `ValidateCarriedEgg`, `TryPromptPickup` | `fn26`, `fn28`, `fn29` |
| `ArmGuardHit`, `WaitForGuardHit`, `TakeEggOnGuardRoute` | `fn42`, `fn43`, `fn45` |
| `RecoverDroppedEgg`, `AcquireNearbyEgg`, `RideGuardToDroppedEgg` | `fn50`, `fn51`, `fn53` |
| `DeliverCarriedEgg`, `RunNormalCycle` | `fn54`, `fn57` |
| Normal scheduler | Source scheduler, wake listeners and single worker finalizer |
| Optional guard arbitration | Source Anti Guard carry transition and hit-arm exclusion |

The route retains the source's nearest/sleeping/personal starter preference,
Forest strike payload, armed ragdoll teleport, standing/body recovery, prompt
pickup with native fallback, carry validation and staged home delivery. A nearby
or same-area target can be acquired directly; Forest is not unconditionally
forced. Normal speed stays independent (400 default, 100–1000 control), while
the original N3 speed setting remains 600.

## Integration corrections and cleanup

- Runtime functions, parameters, shared state and relevant locals now have
  semantic names. Lexically scoped renames were checked against Luau AST binding
  targets before later logic edits; a shadowed local was not renamed by regex.
- Normal cycles no longer call `SetAntiGuard(false)`. Only the user's UI callback
  changes that preference. Native guard-hit windows exclude independent dodges,
  and movement/holds pause while an optional dodge owns movement. Line Drop
  continues to suppress dodges, but no longer overwrites the toggle.
- Include the source's health/death-state preparation before cloning. The prior
  literal movement port omitted this dependency. Here it is scoped to normal
  shield lifetime, including subscriptions, 0.5s maintenance and restoration.
  This is a source-parity correction, **not an established rollback diagnosis**.
- One worker finalizer now clears motion and hit arms on success, false returns,
  exceptions and cancellation. Cancelled starter pickup must not leave a live
  ragdoll listener or an old position hold for a later cycle. Cancellation can
  release a movement coroutine even while optional guard movement is busy.
- Flatten the repeated dropped-egg branches into one sampling, ownership,
  prompt and heartbeat loop. Retain the reference's 30s budget, 0.5s snapshot
  interval, 0.4s ownership interval, 0.1s prompt interval and 20 missing prompts.
- Remove the never-selected CFrame movement/hold branches (the original predicates
  return true on both paths), unused queue/UI-label scaffolding and unused normal
  flight/GodMode adapters. Normal movement uses one PreSimulation connection.
- Share home/base/guard helpers rather than maintaining second copies. Preserve
  source home offsets at full precision. Slot and dropped prompts intentionally
  retain different distance geometry; they are not interchangeable duplicates.
- Shared carry requests call the native module **or** the raw fallback, not both.
  Fix two pre-existing references that captured nonexistent globals: the legacy
  movement carry retry and the later-defined treadmill exit helper.
- Normal recovery is not run concurrently by the optional guard's old recovery
  loop. Normal post-place waits until raw field carry has ended. A cancellation
  during home settle must not send a drop from the obsolete cycle.

Raw `AutoCarry` is the module signal used by the normal route. Legacy guard
signal/weld carry state and Instant/Line Drop helpers remain separate on purpose.
Likewise, normal swap preparation and Instant's existing swap policy are not
silently combined. Removing these distinct states would change behavior, not
merely deduplicate code.

## Actual live failure trace

A bounded local ring stores at most 16 real pickup, guard-arm/hit, carry and home
Drop events, with UID, position, velocity, shield and guard state. It prints only
when the game's real `delivery failed` alert arrives. There is no telemetry or
per-frame console spam. If rejection persists, the console trace is evidence
for the next investigation—not a fabricated simulation or acceptance verdict.
The legacy verdict listener is not used to certify a normal delivery.

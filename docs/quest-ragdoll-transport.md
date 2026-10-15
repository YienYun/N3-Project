# Wisp transport: restore the actual Chili dependency

## User-reported failures, not successful live ports

- `4d2db61`: premature Wisp/door pivot, Banjo's ground/pathfinding route into
  water and repeated return to the start. Rejected by the user.
- `47e1483`: substituted a continuous tween for Wisp's own transport. The user
  reports repeatedly dying on the trip to Wisp. **Also rejected.** The previous
  claim that this was merely the user's explicit choice was an incorrect
  interpretation of their request for Chili's logic.

Neither static checks nor compilation overturn those live reports. The current
correction is not live-confirmed and must not be described as a proven death fix.

## Actual Wisp caller — immutable Chili 41964–42056

1. Stream the actual WispSpawn / WispAnchor / plot destination (three seconds).
2. If distance is **greater than 1200**, check daylight/open wall, unequip tools,
   call **RagdollTravel** with destination **position + (0,3,3)**.
3. Re-read character/root. If still **greater than 40**, use the source's
   **character PivotTo fallback** to **position + (0,3,3)**, zero velocity.
4. Short MoveTo toward position: up to three seconds, 0.2-second cadence, stop
   within six studs. Wait 0.5 seconds.

**There is no call to general FlyTo / the raised three-leg tween in this Wisp
helper.** The >1200 → RagdollTravel → >40 pivot → short walk order is restored.
Yes, the source contains teleports: calling it an all-tween route was wrong.
The retained N3 six-stud acceptance gate is stricter than the source's routine
return, and cancellation/ownership remains race-first.

## RagdollTravel is not a rename for a tween

Source dependencies: **4470–4568** read field records/carrier; **5175–5248**
select eligible nearby eggs/guard/slot; **5414–5567** execute shared travel.

- Read actual field egg records. Pick the nearest visible eligible egg, otherwise
  nearest eligible egg. Exclude carried / non-field-state eggs and tried UIDs.
  Require its actual guard and slot; source's own FirstAreaEgg parsing is retained.
  Forest is a fallback only for that source-owned starter UID, not a forced
  universal starter route or any change to normal egg selection.
- Try up to three candidates. Move to candidate bottom/model position +3 and
  invoke real **CarryFieldEgg(rawUid, slot)** for up to **2.5 seconds** per egg.
  Preserve the source's **0.4-second / 'closer' refusal** rule.
- Connect to **LocalPlayer.RagdollEndTime before dispatching**
  **RE/GuardPatrol/ForestStrike({EggUid, GuardCFrame})**.
- Only a real future server-time ragdoll attribute triggers the destination snap.
  Wait at most three seconds for that signal; do not manufacture the attribute,
  equate firing the strike with a landed hit, or launch an unprotected world tween.
- Drop the temporary held egg with **DropFieldEgg('PlayerRequest')** once.
- While the real ragdoll window remains, hold the requested destination each
  heartbeat. Disconnect the signal and clean up on completion/cancellation.

The previous dependency omission was substantive: the server ragdoll window,
actual temporary egg carry, and guard strike were missing, not just a speed or
waypoint constant.

## N3 integration, not a second race or swap

The port runs under the existing Wisp/Banjo worker and exclusive movement lease.
No new worker, clone/swap, guard automation preference, flight setting, or shared
IsExecuting write is introduced. Existing normal/Instant and race bodies stay
unchanged. The race's existing travel implementation is not edited or called
through a fake race state.

Chili exempts an armed hit from its AntiGuard/GodTick recovery. N3 instead uses
its existing scoped quest recovery guards while this owned ragdoll transport is
active, resumes N3-owned RigSync handlers, temporarily enables the captured
ragdoll states, and restores captured states/patch only for the same actor/owner.
The anti-ragdoll preference is never forced OFF/ON. These are explicit lifecycle
adaptations, not a claim that N3's global controller is identical to Chili's.
Ragdoll and ordinary flight cleanup are separate; ragdoll travel must not run
an uninitialized PlatformStand flight cleanup. Cleanup is idempotent, and a late
signal cannot snap after the ragdoll scope has closed. Sent RPCs cannot be recalled.

## TreeTrip uses the same dependency

Source **72205–72421** also calls RagdollTravel: beyond **500 studs**, up to two
attempts toward prompt position +(0,3,-12), settle, then FlyTo only if still
beyond **60 studs**. Its final entry pivot is only inside the local prompt loop
when still beyond **30 studs**, not the entire approach. Prompt activation and
actual InEnchantedTree confirmation remain mandatory. Source exit's final
exterior pivot +(0,3,-30) and last ExitTrigger retry are also restored.
The already-corrected elevated Secret Leap, mushroom and NPC route remain.

## Evidence and limits

All ten source checkers and full production Luau compilation must pass. Tests now
explicitly reject routing Wisp through general Approach and require the real
carry → guard strike → observed ragdoll → drop → timed hold dependency. Historical
fingerprints are unchanged; the only production edits are in the previously
reviewed transport scopes and Banjo controller. Library/loader/references/race
are untouched. No Roblox simulation is used as acceptance evidence.

Remaining live checks: actual carry/guard strike, real ragdoll signal, trip to
Wisp and WispAnchor without death, missing-egg/strike refusals, cancellation,
race handoff, tree entry and source fallback behavior. **Do not claim these work
until they have actually been observed in game.**

# Wisp / Banjo: Forest egg → door TP

## Live failures and latest instruction

- `4d2db61`: Wisp bare TP / Banjo water and reset route, rejected.
- `47e1483`: substituted a custom Wisp tween; repeated deaths, rejected.
- **`36128e6`: carry/ragdoll port still glitched and killed the user, rejected.**

Latest explicit correction: **hold Forest egg, immediately TP to the door**.
This supersedes the earlier no-TP request. Static checks do not overturn any
live report. This correction is **not live-confirmed**.

## What the immutable source actually does

`Games/Source/StealAnEgg/ChiliSourceV2.lua` remains byte-identical.

- **4470–4568 / 5115–5248:** read real field/carrier records and choose a nearby
  eligible egg/slot/guard. The original selector is **not Forest-only**.
- **5414–5567:** CarryFieldEgg(uid, slot), arm hit exemption, subscribe to real
  RagdollEndTime, FireServer ForestStrike({EggUid, GuardCFrame}), snap on a real
  future window, drop the egg, hold the requested destination during that window.
- **41964–42056:** Wisp stream target; >1200 RagdollTravel then >40 bare pivot
  fallback, short MoveTo / settle. It does not call general FlyTo.
- **72205–72421:** TreeTrip >500 two ragdoll attempts then >60 FlyTo and local
  >30 prompt alignment. Actual prompt / InEnchantedTree confirms entry.
- **42455–42623 (Proto_122):** separate health service. Snapshot joint/neck/dead
  flags, set BreakJointsOnDeath=false, RequiresNeck=false and Dead disabled;
  maintain health on HealthChanged/MaxHealth/StateChanged and every 0.5 seconds;
  disconnect and restore on disposal. **The previous port omitted this dependency
  after releasing N3's normal steal shield.** This is not permission to claim
  authoritative server immortality.
- **12698+ / 17593+:** intentional-hit exemption from automatic guard/recovery.

## Current explicit Forest-door policy

These restrictions implement the latest user correction after failed live
builds; they are not falsely attributed to the source's generic selector.

1. Require a real Forest slot and Forest guard. Reuse a Forest egg already
   recorded as carried by this player; do not unequip/drop it to fetch another.
   Otherwise use the original visible/nearest selection **within Forest only**,
   up to three candidates / 2.5 seconds each, original carry refusal handling.
2. CarryFieldEgg confirmation precedes strike. Subscribe **before** dispatch;
   also check an **already-active** real window, since carry/server processing
   may have changed RagdollEndTime before the subscription was installed.
3. On a future server-time RagdollEndTime, snap directly to requested destination:
   Wisp position +(0,3,3); Banjo door prompt +(0,3,-12). No world tween to door.
   Never synthesize the attribute or treat FireServer itself as a landed hit.
4. Drop once, hold destination only during the real window, clean up.
5. Wisp uses this beyond 40 studs; Banjo door approach beyond 60 studs. Missing
   egg/strike/window or arrival failure stops this attempt with status. **Never
   fall through from refusal to a bare far pivot / world FlyTo.** Short final
   walking / local prompt alignment remains, followed by actual entry checks.

Original Wisp >1200 / >40 and TreeTrip >500 / >60 policies above are historical
source mapping, not descriptions of the current Forest-only/fail-closed policy.
Normal farm selection is unaffected.

## N3 lifecycle integration

One helper, existing quest workers and native movement leases; no additional
swap, worker, fake race state or shared IsExecuting write.

- Existing Wisp/Banjo **dodge lease adapters already suppressed TriggerGuardDodge**.
  Do not mistake that for a newly fixed omission. However the separate native
  RagdollEndTime attribute handler still called StopVelocity / PlatformStand=false
  independently. It now has the same narrowly scoped quest exemption as the
  existing mobility/defense heartbeat guards.
- Source health protection is applied **before carry/strike**, privately within
  the owned ragdoll scope. Its callbacks can maintain the same actor at zero
  health, as source does, but all movement still requires positive health.
  No healing or restoring a replacement actor or race-owned actor. Disconnect
  every health listener/heartbeat; restore captured flags only on the same
  living actor with the same quest lease.
- Preserve existing captured ragdoll-state / N3-owned RigSync restoration and
  separate idempotent ragdoll cleanup; never run uninitialized flight cleanup.
  User Anti Guard / Anti Ragdoll preferences are not forced or saved differently.
- Wisp admission permits an already-held Forest egg only for NPC-trip stages
  with no pending hatch/fusion. Other carries and active native cycles still
  block admission. Banjo also permits this specific held carry, not arbitrary
  eggs or a native cycle. Keep the Forest egg equipped during preparation.
- Source room flight, Secret Leap, notes/bat acknowledgements, Jitterbug claim
  and exit flow remain. Done still requires the actual Banjo save.

The identified differences are code evidence, **not a demonstrated cause of the
user's server death**. Do not claim that health flags or the extra handler gate
have made the trip safe until it has been observed live.

## Verification and remaining live checks

Run all ten source checkers, full production Luau compile, immutable checksums
and git diff --check. Frozen pre-Banjo / pre-Wisp / race / normal fingerprints
are unchanged. Normalization adds only three exact literal reviewed scopes:
native ragdoll attribute guard, Wisp held-Forest admission and tool preparation.
No broad hash replacement or unrelated core rewrite.

Live acceptance still requires: fresh Forest pickup and already-held Forest,
already-active ragdoll window, correct actual door/anchor arrival, no glitch or
death, no unprotected fallback on refused strike, prompt/entry, cancellation,
OFF/unload/respawn/race handoff, puzzle/server save and both exits. The agent has
not executed Roblox or measured server acceptance/FPS.

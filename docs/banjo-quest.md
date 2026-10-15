# Auto Banjo Cricket — Home / Quests

**Live report:** the user rejected build `4d2db61`: Banjo did not work, direct TP
was unwanted, and interior travel went into water / repeatedly returned to the
start. The former walk/pathfinding + Lift adaptation is withdrawn, not treated
as successful because it compiled. Build `47e1483` was also rejected: its custom Wisp tween repeatedly killed the
user. [The actual RagdollTravel dependency](quest-ragdoll-transport.md) is now
ported; neither previous build is live-confirmed. This correction needs live testing.

UI remains **Home → Quests → Wisp / Banjo**, one collapsible/icon group and one
nested tabbox. Banjo has a music icon, one default-OFF toggle and one status row.
No Butterfly automation or server tools are included.

## Actual source flow and destinations

Immutable reference: `Games/Source/StealAnEgg/ChiliSourceV2.lua`, SHA256
`0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d`.

1. **Wisp is the unlock quest, not the mushroom-room controller.** Chili
   41403–42256 reads WispQuests/Save, accepts at WispSpawn, completes the actual
   egg/fusion objectives, claims completed stages, calls BeginReturn and returns
   to `EnchantedForestZone.Zone13Props.EnchantedTree.WispAnchor`. The server opens
   the tree. Banjo requires `EnchantedTreeUnlocked == true` and an actual bat.
2. **TreeTrip entry, 72155–72350:** resolve
   `EnchantedTreeInterior.Markers.EnterTrigger.EnchantedTreeEntrance.EnchantedTreePrompt`.
   Approach the prompt offset `(0, 3, -12)`, settle / close the final distance,
   activate the real prompt (up to four attempts) and wait for **InEnchantedTree**.
   Source long-distance travel can use RagdollTravel, then FlyTo. Its late pivot
   fallback is NOT the whole approach sequence.
3. **Secret Leap, 15390–15460:** find `SecretLeapHint.Streaks`, fallback
   `(5905.63, 17027.3, 15610.83)`. The route consists of **two flight legs in one uninterrupted flight scope**:
   rise vertically at the current X/Z to **hint.Y +18**, then travel horizontally
   to **hint + (0,18,0)**. End flight and restore collision/platform state before
   **falling naturally through the hint**. Wait up to eight seconds for the actual
   SecretRoomSpawn area (120-stud check), up to two attempts. This is NOT a ground
   route, swimming route, or a lift after walking through the water.
4. **Mushrooms, 14644–14850 / 15210–15390:** room fallback spawn
   `(6246.9,17161,16887)`. Source tag `BanjoCricketMushroom` / MushroomIndex 1–5.
   Fly between floor-raycast stances **6.5 studs toward the room center** at speed
   60, end flight before holding/activating the bat, and face the mushroom.
   Wake using mushroom four. Play only the server's Playback notes after official
   `PlaybackSeconds` (source fallback `count*.65+.5`); Aim(index) plus real tool
   Activate, matching new Note acknowledgement or Wrong. No invented hit remote.
5. **Jitterbug, 15485–15545:** after solved, wait five seconds. Fly the source
   waypoints `(6248.72,17163,16928)` → `(6248.72,17163,16944)` → a floor-raycast
   six-stud NPC stance, again at 60. NPC comes from `BanjoCricketNpc` or source
   fallback `(6272.46,17164.04,16958.18)`. Within nine studs invoke
   **RF/BanjoCricket/AskClaim with no arguments**.
6. **Return, 15465–15485 / 72350–72421:** fly to **SecretRoomExit**, wait for
   leaving the room, then use **ExitTrigger** to leave the tree. These are two
   distinct passages; do not route directly to a world/plot starting position.
   TreeTrip first flies to ExitTrigger and only then tries a short MoveTo fallback.

Chili's general **FlyTo** (13798–13970) uses small per-heartbeat CFrame steps and
three legs: rise to `max(startY, destinationY)+30`, cross horizontally, descend
to destination +3. Its separation-line helper routes through StealHome when
needed. Banjo's room flight (14990–15210) instead uses a **dt-capped physical
velocity**, temporary collision suppression, PlatformStand/Freefall and explicit
EndFlight (40119–40175). Both dependencies matter; ordinary MoveTo is not a port.

## Current transport correction and remaining differences

- **Wisp does not call general FlyTo.** Its source caller uses >1200
  RagdollTravel, then >40 pivot fallback, then short MoveTo. The custom Wisp
  continuous tween was an incorrect substitution and is removed. Read the
  [complete source dependency mapping](quest-ragdoll-transport.md).
- TreeTrip now uses >500 RagdollTravel (up to two attempts) → settle → >60 FlyTo
  → local prompt loop with >30 pivot fallback. The source exit pivot and final
  ExitTrigger retry are restored. Earlier removal of these source fallbacks
  based on interpreting the user's word 'tween' was incorrect.
- RagdollTravel actually takes an eligible nearby field egg, calls its guard
  strike, waits for the real RagdollEndTime signal, drops the temporary egg, and
  holds the destination during the real ragdoll window. It is not a tween alias.
  No invented guard payload or manually-set ragdoll signal.
- The shared helper still runs within existing quest workers and native leases.
  No second swap/worker or race-controller rewrite. N3-owned RigSync and captured
  humanoid state restoration replace Chili's armed-hit recovery exemption;
  recovery is suppressed only during owned flight/ragdoll. User flags stay unchanged.
- The existing raised FlyTo legs remain for TreeTrip's source flight branch,
  not Wisp's NPC travel. Secret Leap keeps one uninterrupted rise/cross flight
  until hint +18, then releases flight for the natural fall. Room legs remain
  source-speed-60 velocity motion, actual server notes and bat activations.
- N3 actor/generation/owner/race cancellation remains stricter than source
  cleanup. Temporary state and signal connections restore only under the same
  actor/owner; a sent RPC cannot be recalled. No arbitrary health-zero reset.
- Done still requires **Save.BanjoCricket.Claimed**, not a local route return or
  true reply alone. Unknown dispatches stay pending across OFF/ON; explicit false
  permits retry. This conservative policy differs from Chili's reply shortcut.
- Progression, egg/guard strike, both exit passages and absence of death still
  need actual in-game verification. Prior user failures remain recorded.

## Validation

Run **check_quest_transit_source.py**, **check_banjo_source.py**, all eight older
source checkers and full production Luau compilation, protected file identities
and `git diff --check`. `quest_transit_scope.py` reverses exactly four repair
scopes (shared helper, Wisp travel replacement and two recovery guards), then
existing Banjo/Wisp normalizers retain every historical expected hash. The
published pre-Banjo Wisp runtime SHA256 remains
`693a7d99189757fedfff69a579da5ed46c32806fd80de28fb3e16ea986bb424d`.

These are **static / compile checks**, not live route, server reward or FPS proof.
Live validation must cover continuous approach, real prompt/entry, both elevated
leap legs and natural room warp, mushroom acknowledgement/replay, saved reward,
both exit passages, OFF during flight, race interruption and respawn. The user's
previous failure remains recorded; this corrected build is not live-confirmed.

# Auto Banjo Cricket — Home / Quests

**Live report:** builds `4d2db61` (water/reset), `47e1483` (custom Wisp
world tween/deaths) and **`36128e6` (ragdoll-port glitches/deaths)** were rejected.
Latest instruction: **Forest egg held → immediate door TP**, superseding the
older no-TP instruction. The current correction is not live-confirmed; read the
[transport/dependency mapping](quest-ragdoll-transport.md), not old success claims.

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

- Door transport more than 60 studs away uses **Forest-only carry → real guard
  ragdoll window → TP to prompt +(0,3,-12)**. An already-held Forest egg is reused;
  do not drop/unequip it just to fetch another egg. An already-active real window
  can land immediately instead of waiting for another attribute change.
- If carry/strike/arrival fails, return a status and stop this attempt. **No world
  FlyTo or bare far pivot fallback** after failed transport. The source's original
  >500 / two-attempt / >60 FlyTo policy is documented above as source, not falsely
  described as the current Forest-only implementation. Local >30 prompt alignment
  remains behind a <=60 approach gate; actual InEnchantedTree still confirms entry.
- Wisp also uses the shared Forest transport, no general Approach/FlyTo or far
  pivot fallback. This is the user's explicit correction, not a claim that Chili's
  original nearest-egg selector was Forest-only.
- Add Chili Proto_122 health/neck/dead protection while the owned ragdoll scope is
  open; snapshot/restore flags and disconnect listeners on cleanup. This is local
  protection, not immunity to server death. Existing dodge lease adapters were
  already present; the native RagdollEndTime handler now also respects the scope.
- No new movement worker, swap, race rewrite or forced Anti Guard preference.
  Existing elevated Secret Leap rise/cross/natural fall, speed-60 room movement,
  server bat notes/acknowledgements, Jitterbug claim and exit flow remain.
- Success still requires **Save.BanjoCricket.Claimed**. Ambiguous dispatch stays
  pending across OFF/ON; no health-zero reset or reward shortcut.
- Actual entry, no glitch/death, cancellation, race takeover, server puzzle/claim
  and exits still need live verification. Static checks do not prove them.

## Validation

Run **check_quest_transit_source.py**, **check_banjo_source.py**, all eight older
source checkers and full production Luau compilation, protected file identities
and `git diff --check`. `quest_transit_scope.py` reverses the four original repair
scopes plus three exact reviewed additions (native ragdoll attribute guard, Wisp
held-Forest admission and preserving its equipped carry), then
existing Banjo/Wisp normalizers retain every historical expected hash. The
published pre-Banjo Wisp runtime SHA256 remains
`693a7d99189757fedfff69a579da5ed46c32806fd80de28fb3e16ea986bb424d`.

These are **static / compile checks**, not live route, server reward or FPS proof.
Live validation must cover Forest carry/window/door TP, real prompt/entry, both elevated
leap legs and natural room warp, mushroom acknowledgement/replay, saved reward,
both exit passages, OFF during flight, race interruption and respawn. The user's
previous failure remains recorded; this corrected build is not live-confirmed.

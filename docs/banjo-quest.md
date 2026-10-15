# Auto Banjo Cricket — Home / Quests

**Home → Quests → Banjo** shares the existing collapsible/icon Quests group and
nested tabbox with **Wisp**. Wisp keeps its ghost icon; Banjo gets a music icon.
One **Auto Banjo Cricket** toggle, default **OFF**, and one live status row.
No Butterfly, Server Hop, shop purchase, or additional outer group is included.

Banjo is the Enchanted Tree mushroom music-memory puzzle. The server plays a
sequence; the character repeats it by striking the numbered mushrooms using an
actual bat. After the puzzle is solved, Jitterbug offers **Cricket's Banjo**.
The tree must already be unlocked through Wisp, and a bat must be in the current
character/backpack. This implementation does not assert that Wisp was live-tested.

## Immutable source map

Reference: `Games/Source/StealAnEgg/ChiliSourceV2.lua`, SHA256
`0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d`.

- **14644–14850:** Banjo controller, official `Data.BanjoCricket`,
  `Shared.Flags.BanjoCricketFlags`, `Save.BanjoCricket`, source fallback mushroom /
  room / NPC coordinates and server Effect messages. Playback duration comes
  from `PlaybackSeconds`, with the source `count * 0.65 + 0.5` fallback;
  stage count comes from `Stages:Get()`, falling back to five.
- **15210–15390:** stand 6.5 studs toward the room center, raycast floor +3,
  face the mushroom, equip the bat, send `RE/BanjoCricket/Aim(index)`, activate
  the tool, wait for a matching `Note` or `Wrong`. Two attempts per note,
  1.6-second acknowledgement wait, two-second cooldown wait; mushroom four wakes
  the puzzle after four silent seconds (12 wakes / 300-second solver budget).
- **15390–15560:** Secret Leap hint +18 and natural fall, SecretRoomSpawn /
  SecretRoomExit markers, claim waypoints and Jitterbug. Wait five seconds after
  solving, approach within nine studs, and call
  `RF/BanjoCricket/AskClaim:InvokeServer()` with **no arguments**.
- **15560–15798:** tree-unlock/bat/ownership gates, default-OFF toggle and status.
- **TreeTrip dependency through 72421** (entrance prompt at 72173):
  `EnchantedTreeInterior.Markers.EnterTrigger.EnchantedTreeEntrance.EnchantedTreePrompt`,
  `InEnchantedTree`, ExitTrigger, prompt retry and final source tree-entry/exit
  pivot fallbacks. Extracted only the necessary dependency, not Butterfly itself.
- **38775:** Chili maps both Banjo and Wisp into the same Wisp quest priority lane.

## N3 integration and deliberate differences

- One worker owns the whole job, taking the native **banjo** movement lease only
  when normal/Instant steal, carrying, guard dodge, Wisp, mutation, treadmill and
  tracked native inventory/fusion work are idle. Banjo occupies the existing Wisp
  priority slot rather than changing saved priority order. Higher-ranked native
  steal/place/treadmill/mutation work can defer or interrupt the quest; Auto Race always
  preempts. Banjo does not turn any of those preferences off.
- The adapter chain suppresses native normal/Instant activation, dodge/shield,
  conflicting movement claims, and new native inventory/fusion calls during the
  lease. Native Wisp/mutation action counters and settle windows are checked
  before starting. Existing normal/Instant selection, movement, deposit, race,
  visual, sellers and Wisp implementations are not rewritten.
- **Traversal is adapted, not a claim of byte-for-byte Chili flight behavior.**
  Interior movement uses bounded pathfinding / Humanoid MoveTo and path jump
  waypoints, without setting WalkSpeed, collision, PlatformStand, or flying rig
  state. Secret Leap uses N3's existing `Lift(18, hint.Y)` and natural falling.
  It recognizes room transitions during the approach. Tree approach uses the
  source entrance pivot fallback beyond 30 studs, then a real prompt; source
  exterior exit fallback is retained. Entry waits for the actual tree attribute;
  leap waits for the actual secret-room location. No invented teleport remote,
  Butterfly controller, RagdollTravel, second swap, noclip or flight loop is added.
  Ordinary walking/pathfinding may fail on the live map: this is a material
  untested difference, especially at the Secret Leap and return passages.
- After restoring any native idle rig/shield through existing helpers, the job
  pins the current character/root/humanoid. It waits out active invisibility
  instead of toggling the user's setting. Outside-tree entry is daylight/wall
  guarded, including after the streaming request.
- Only the current job's valid server messages inside the room are consumed.
  Notes are finite integer indices 1–5; Playback, Wrong and Reset invalidate old
  sequences. Sequence identity is rechecked after travel/cooldown and before
  swinging, not just before starting a note. Acks must match the mushroom and a
  newer event serial than the hit; consumed acks cannot be reused. No generated
  note sequence or fabricated hit RPC. The existing N3 bat helper is reused.
  Unlike Chili's order, cooldown waits before Aim so aim and activation remain
  adjacent, without a yielding priority scan between them.
- **Done requires `Save.BanjoCricket.Claimed == true`.** Unlike Chili's alternate
  `reply == true` shortcut, neither a local route return nor a true reply alone
  marks success. Claim dispatch is marked pending before the request. Explicit
  server false permits retry; an error/unknown/true answer without the saved
  claim remains pending across OFF/ON, without automatic duplicate calls. This
  conservative difference can require manual NPC/save checking or rejoining if
  an ambiguous request never appears in the save; it is not an automatic retry
  timer. No purchase or inventory consumption is performed by the Banjo job.
- OFF cancels note/claim work and permits a bounded best-effort room/tree exit
  only while the **same living actor/root/humanoid and banjo owner** remain safe.
  Race, actor changes or unload prevent that exit movement and tool restoration.
  An already-sent request cannot be recalled; a yielding server/API call can
  outlive a local deadline. Native work wakes after the job releases its own lease.
  The prior tool is restored only if Banjo's bat is still the equipped tool;
  manual equipment changes are not overwritten. Exit is best effort, not proof
  of server acceptance. The toggle may remain ON after the saved claim is done.

## Validation and live checklist

Two marked integration sites reverse exactly to published Wisp commit
`7591d6ff979684ebbba2bb567aa1b95fe727361e`:

1. The late Banjo controller insertion.
2. The exact shared Wisp tabbox-line replacement; restored by `banjo_scope.py`.

Baseline runtime SHA256:
`693a7d99189757fedfff69a579da5ed46c32806fd80de28fb3e16ea986bb424d`.
Historical normalization strips Banjo before Wisp and keeps every earlier hash.

Run `tools/check_banjo_source.py`, the eight historical source checkers and a
**full production Luau compile**. Also verify Library/loader/reference identities
and `git diff --check`. These are **source/compile evidence only**, not Roblox
execution, server acceptance, reward ownership, FPS, or rendering evidence.

Live testing remains with the user:

- Before tree unlock / without bat: prerequisite status and no quest movement.
- After unlock: actual tree entry, Secret Leap, all server-played stages,
  bat cooldown, matching notes, wrong-note replay and actual saved reward.
- OFF while approaching/listening/swinging; race interruption and respawn,
  including a late claim reply: no movement/tool restore over a new actor/owner.
- Actual SecretRoomExit + ExitTrigger transitions; manual exit may be needed if
  walking cannot reach them. Do not interpret local movement completion as success.
- Normal/Instant steal, optional Anti Guard/visual, Wisp, mutation, native hatch /
  fusion, treadmill, sellers and race keep preferences and resume normally.
- Default-OFF/reloaded-config behavior, compact/mobile UI and real client FPS.

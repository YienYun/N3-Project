# Butterfly Bloom / Shooting Star — semantic Chili V2 adaptation

## UI by purpose

- **Event → Shooting Star**: Auto Catch Star, status, server-confirmed session count.
- **Event → Butterfly Bloom**: Auto Butterfly, Stand / Chase / Circle / Patrol,
  Rarest / Nearest chase priority, selected chase tiers, speed 100–600/default 320,
  status and real event / schedule countdown.
- **Home → Butterfly Workshop**: Auto Trade Up, selected conversions, Smart Trade
  for Essence, Auto Craft Essence, status and saved butterfly/essence counts.

Every toggle defaults **OFF**. No quest subtabs, extra outer Quests group, new
Event tab or Library changes. Trade/craft **consume saved butterflies**; they
require the tree unlocked through Wisp and actual machine proximity. Catching
and resource processing are placed separately because their purposes differ.

## Immutable source mapping

`Games/Source/StealAnEgg/ChiliSourceV2.lua` stays unchanged, SHA256
`0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d`.

| Source | Semantic implementation |
| --- | --- |
| 19664–19837: payload/event tracking, AskState, visual/leg position | `acceptStar`, `bindEvents`, single-flight `askStarState`, `starPosition` |
| 19838–20100: treadmill exit, safe base exit, ragdoll, StepTo, GlideTo, ping settle | `runOwned`, `leaveStarBase`, `stepToStar`, `glideToStar`, `catchStar` |
| 20101–20219: hold, slip, catch, retries, release | `catchStar`, `job.Finally`; count only from matching Claimed event |
| 49077–49316: actual StepTo / GlideTo dependencies | HopRatio/Lift/Gap, two no-progress strikes, 30s hops; 40s glide, rollback pause/speed decay |
| 71415–71694: Catalog / Swarm / Flags, save, event feeds, target ordering, net | `loadButterflyModules`, `readButterflySave`, `butterflies`, `chooseButterfly`, `netTool` |
| 71722–71962: stations, floor/bounds geometry, stand/circle/patrol and two ragdoll tries | `machinePosition`, `groundedBloomPosition`, `standingTarget`, `bloomRotation`, `catchButterflies` |
| 71966–72009: real free net claim | `claimNet`, exact AskClaimNet with no invented arguments |
| 72010–72421: saved counts, TreeTrip, settling, prompt/entry, machine reach/exit | `enterWorkshopTree`, `reachMachine`, `walkTo`, `leaveWorkshopTree` |
| 72433–72754: machine RPC proximity, manual reserve, smart recipe planner, trades/craft | `smartPlan`, `workshopNeeded`, `machineRequest`, `runWorkshop` |
| 72755–73412: mode/chase lock/velocity, scheduler and source controls | `catchButterflies`, common scheduler, purpose-separated N3 controls |
| 40119–40233 / 42455–42623: flight, collision/state and health service | Existing owned transit + `BeginControl` / `Control`, private per-job health capture/restore |
| 38854–39060: exclusive event / priority arbitration | `Tasks.BloomStarOver`, availability adapters and cooperative cancellation hooks |

No obfuscated local identifiers or source VM wrapper is imported. The new
controller is a function scope to avoid exhausting the already-large runtime's
Luau top-level local-register budget.

## Star protocol

Use exact Fall/Wander/Slipped/Claimed/Expired feeds and AskState at 15-second
cadence. AskState has one outstanding call; late replies cannot replace a newer
event/generation. Eligibility uses server LandAt/ExpiresAt. Target first uses
ShootingStarClient.Buddy.RootPart/PrimaryPart, then server Leg interpolation,
then Landing. Hold tracking uses proportional velocity gain 10, cap 200.

Keep the source approach order: safe-zone base exit, wait for field opening,
one ragdoll attempt per star, >40 StepTo fallback, GlideTo, <=12 acceptance,
ping settle (0.5 + clamp(ping)*2). HoldSeconds defaults to 1.6, plus 0.3 margin;
Catch waits for a real server acknowledgement. Slipped clears hold timing;
release/retry after two seconds, state query every third attempt. Cleanup sends
Hold(id,false) on every exit that actually started holding, including OFF/race.
Distance, a local tween return and sending Catch never increment Caught.

## Butterfly / net behavior

Read live Swarm.Each bodies and their Flight data, supplemented by
ButterflyCatalog.PositionAt for server Spawned/Escaped records. Removed drops
records; a real event end clears the old swarm cache. Flags supply schedule,
net reach, trade costs and essence recipe, with the same source fallbacks.

Rarest is strict Golden > Purple > Blue > Green, then travel distance; nearest
uses travel distance. Chase locks for one second, snaps within 40 studs and
matches Catalog horizontal velocity; otherwise it uses distance/dt-capped
physical speed. Other modes use the actual rotated bounds, floor raycast,
25-stud circle or reflected patrol path. Long approach uses the source's
>=1200 threshold, up to two actual ragdoll attempts, first 1.5s delay / 10s backoff.

**The source equips the real Butterfly Net and relies on the game's equipped-net
capture controller. It contains no catch/swing remote invocation in this flow.**
Do not invent one or increment inventory from proximity. The tier dropdown is a
Chase target filter, not a promise that the game's net cannot capture other
nearby tiers in stand/patrol modes. Actual save counts report catches.

## Workshop / consumptive requests

Outside an active bloom, wait for daylight/open wall and a 60-second visit gate.
Use real tree prompt/attributes and the source TreeTrip approach dependencies.
Reach the actual ButterflyMachine / MutationShrine; use source pathfinding /
short walk fallback inside the tree, excluding the ExitTrigger area. Leave via
the source exit flow; cancellation never moves a race-owned/replacement actor.

AskTradeUp receives **only the raw tier**, not the station name; AskCraftEssence
has no arguments. Manual trading reserves the craft recipe when craft is ON.
Smart mode tries 60 down to 1 complete recipes, propagating missing Golden to
Purple, Blue, Green costs before spending. Keep source trade/craft spacing and
50-craft visit cap. No unrelated farm, mutation or defense preference is forced.

N3 safety adaptation: store pending consumption **before dispatch**, including
prior counts/recipe/essence. Confirm saved source-tier debit and target-tier
credit, or saved recipe debit and essence credit. Explicit false may retry;
timeout/nil/unknown remains pending across OFF/ON and blocks duplicate spending.
Missing remotes are checked before recording a dispatch. This is deliberately
more conservative than Chili's immediate true-reply shortcut.

## Native integration / intentional differences

- One shared cooperative event job worker; one single-flight read-only state
  query coroutine. There is never a second movement worker or cloned rig.
- `NewEventTransit` delegates to the existing owned transit registry. Only new
  event owners use Chili's generic nearby egg selector; the user's approved
  Forest-only Wisp/Banjo transport and no-subtab UI remain unchanged.
- Race always preempts, even with a custom priority placing Star above Race.
  Other tasks use actual demand and user priority, not merely enabled labels.
  External carried/equipped eggs suppress new exclusive event demand so the
  native carry/deposit work required for admission can finish without starvation.
- Never copy the source's timed forced Movement.Owner assignment. Wait for the
  native lease / finish existing cycles and tracked inventory actions. Three
  tiny Wisp/Banjo/Mutate hooks let their own cancellation paths yield normally.
- Capture same character/root/humanoid/owner; revalidate after yielding readers.
  Keep source health protection through the whole owned job, including RPCs and
  exit; all motion still requires positive health. It is local protection, not
  proof of server immortality. Restore/disconnect only owned captured state.
- With externally applied invisibility, wait rather than import an unrelated
  global invisibility controller or toggle the user's preference.
- OFF stops new catching/grant/trade/craft requests and state queries. Passive
  subscriptions/save labels remain. Normal owned workshop exit cleanup may finish.
- An already-sent RPC cannot be recalled. If cancellation occurs during a pending
  call, the observer stops owned flight/health and releases the movement lease so
  Race is not pinned to a hung response. The one event worker/inventory gate still
  waits for that response; pending consumption is not cleared or retried. No
  second worker performs a concurrent tree exit. In this case an OFF/cancelled
  workshop may require manual tree exit; a late reply cannot move the old actor.
  Saved replication/other consumers can also leave an ambiguous request stalled
  conservatively. Do not "fix" that by clearing pending state or fabricating credit.

## Verification / live acceptance still required

Run **check_bloom_star_source.py + all ten previous source checkers**, full
production Luau compile, immutable identities and git diff --check. Reversing
exactly the nine new marked scopes reproduces published `7e9549a` byte-for-byte
(SHA256 `29637582c16bc01ec2d250fa504042979b7b40964de7853266f126db4a4f1b7d`).
Historical normal/Instant/race/quest/fusion/Lab/Nitro hashes are unchanged.

These checks are not a Roblox simulation, event execution, reward, route/death
or FPS proof. Live-test Star fall/wander/slip/claim/expire; Butterfly event-midway
activation, net grant/equipment, all four modes and actual saved catches; Wisp
unlock, manual/smart trades, craft/save confirmation, both tree passages;
OFF/ON, late RPCs, missing remotes, carried eggs, race takeover and respawn.

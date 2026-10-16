# N3 Hub — branch `arena/a7ae49dc-n3-project` change log

Single source of truth for what each session commit added/changed and why.  All
references (`Games/Source/StealAnEgg/ChiliSourceV2.lua`,
`Games/Source/StealAnEgg/SenaV2.lua`, `Library/N3V3-NoObfus.lua`,
`Tools/ThemeManager.lua` URL) are immutable.  The published
`origin/main` baseline is `5c1763a` (only `ChiliSourceV2.lua`).

> **Branding.**  User-facing strings (Text / Tooltip / AddLabel / status row
> returns) never name "Chili".  Lua comments and code paths that
> explicitly map a N3 block to the immutable reference file may keep the
> reference name `ChiliSourceV2.lua`.  This is N3 Hub, not a reskin of
> another script.

Static scope checkers live in `.tools/`.  Each one reverses its own marked
insertions to a frozen historical hash and refuses to advance unless every
source contract holds.  No checker is a live Roblox/server/FPS test.

## At a glance

| Scope | Tab / Group | Default | Hash reached when stripped |
|---|---|---|---|
| Normal / Instant Steal | Home → Farm Eggs | OFF | `7081554` |
| Built-in safe-zone visual | Home → Farm Eggs | OFF | `009b5d70` |
| Auto Race | Event → Race Rally | OFF | `5c1763a` (whole race) + `74eee3ae` follow-up |
| Auto Treadmill | Progress → Treadmill | OFF | `6dc1423` |
| Scramble Lab stock | Event → Lab Trade | OFF | `9badf26` |
| Scramble Lab seller | Event → Lab Sell | OFF | `6dc1423` |
| Auto Mutate | Pets → Mutation | OFF | `dbaeb09` |
| Auto Buy Nitro | Pets → Mutation | OFF | `1043562` |
| Wisp / Banjo quests | Home → Quests | OFF | `3748a3e` (Wisp) / `693a7d99` (Banjo) |
| Butterfly Bloom Catch | Event → Butterfly Bloom → Catch | OFF | `7e9549a` |
| Butterfly Bloom Workshop | Event → Butterfly Bloom → Workshop | OFF | `7e9549a` |
| Shooting Star | Event → Shooting Star | OFF | `7e9549a` |
| Capture The Egg | Admin Abuse → Capture The Egg | OFF | `6d4af13` (rebuilt on `75883b2`) |
| Admin Abuse | Admin Abuse (top-level tab) | Treadmill ON, V3 OFF, Minigame OFF | `7c68d364` |

## What lives where

- `Games/Steal-An-Egg.lua` — single production file.  Every change between
  `-- BEGIN/END <SCOPE>` markers is reversible.
- `Library/N3V3-NoObfus.lua` — unchanged.
- `Games/Source/StealAnEgg/ChiliSourceV2.lua` — untouched reference.
- `Games/Source/StealAnEgg/SenaV2.lua` — untouched reference.
- `.tools/<scope>_scope.py` — stripper that reverses the scope.
- `.tools/check_<scope>_source.py` — semantic assertions.
- `docs/CHANGELOG.md` — this file.

## Race Rally — first delivered

- Source 49313–51365 (source V2 lifecycle) adapted to N3 with semantic names.
- N3 caps race speed 100–144/default 144 per user request; the bundled
  source default 100–160 is preserved in the reference.
- Race-first pause/resume: active carry/Instant, guards and inventory yield
  while Auto Race owns the rig.  User toggles never change.
- Anti Ragdoll preference is preserved (N3 re-enables precisely the
  connections it disabled, instead of forcing the user preference ON).
- No second race/steal controller, no race remote inventions, no Library
  edits.

## Auto Treadmill / Scramble Lab

- Reuses the existing N3 `MountTreadmill` and `TreadmillMayRun` paths.
- Upgrades `TreadmillUpgrade` read uses the source 10625–10646 fallback list.
- Lab stock adds four insertion sites with one shared quota per category
  across banners; preserves placed-egg exclusion and free-reroll independence.
- Lab seller uses the existing `Remotes.RemoteSellSelection` batch contract.

## Wisp / Banjo — Forest only

- Both quests sit in one flat Progress → Quests group, no subtabs.
- Group order: `Wisp:` status, `Banjo:` status, `Auto Wisp` toggle,
  `Auto Banjo Cricket` toggle. No divider between the two quests; the
  status rows sit on top of the toggles.
- Forest-only selection (the user's explicit correction).
- Forest-held egg → door TP (Forest-door correction `c620126`,
  live-confirmed).
- Live failures `36128e6` (ragdoll-port), `47e1483` (Wisp tween), `4d2db61`
  (Banjo water/reset) remain recorded; this build is not live-confirmed.

## Refine Index Group

- Label simplified from "Index: .../X (Y%) Pets" to
  `Index: <collected>/<target>`. Removed the `(Y%)` percent and the
  trailing "Pets" suffix, plus the standalone `Lbl_IndexRewards` row.
- Toggle renamed `Auto Claim Index Rewards` → `Auto Claim Index`.
- Auto-claim worker unchanged; only the cosmetic claim-text path is
  gone.

## Drop Anti Treadmill, Instan Prom toggle, Steal Selected

- `Anti Treadmill` toggle and its `ApplyTreadmillShield(...)` logic
  fully removed. The `Treadmill` watchdog still runs but no longer
  tries to push a protective shield; it just exposes the ready/taken
  helpers.
- `Instan Prom` toggle removed; the instant-interact prompt-bind is
  now default behavior (no toggle needed). Sibling UI key
  `Toggle_InstanProm` and `FarmConfig.InstantPrompt` field gone.
- `Steal Selected` toggle and `AutoStealSelected` config field removed.
  The `Auto Steal` (formerly `Auto Steal All`) worker now branches on
  a `hasFilter` predicate:
  - no `SelectedZones` / `SelectedEggs` / `SelectedRarities` /
    `SelectedMutations` entry → priority-best egg in the zone
    (ranked upstream by `RecordPriority`).
  - any of those populated → strict zone + category + rarity +
    mutation match; if no match in the zone the worker does not
    steal.
- Sibling UI key `Toggle_StealSelected` and the
  `FarmConfig.AutoStealSelected` field stripped from
  `FarmConfig`/`DefaultFarmConfig` and from the `SaveManager` defaults
  so old saved JSONs are silently ignored.

## Butterfly Bloom UI refresh

- Catch sub-tab (`Event -> Butterfly Bloom -> Catch`): the three live
  status rows (`Status:`, `Total Caught:`, `Live:`) keep the
  N3 purple `#D946EF` accent, but **only the keyword + colon prefix**
  is wrapped in the purple font; the value (and the ` — …` / ` Ns left`
  separator that follows) now stays in default white so numbers stay
  readable. Order is `Status` / `Total Caught` / `Live` labels first,
  then `Catch Mode` / `Catch Priority` / `Catch Butterflies` /
  `Catch Speed` controls, then the `Auto Butterfly` toggle last.
- The `Catch Mode`, `Catch Priority`, `Catch Butterflies` and
  `Catch Speed` controls are no longer hidden when `Auto Butterfly`
  is OFF — the `AddDependencyBox` wrapper and its
  `SetupDependencies({ { catchToggle, true } })` gate are removed so
  the user can configure them up-front.
- Workshop sub-tab (`Event -> Butterfly Bloom -> Workshop`): `Status:`
  and the counts row follow the same keyword-only purple rule. Order
  is `Status` / counts row first, then `Auto Trade Up` /
  `Trade Up Tiers` / `Smart Trade for Essence` / `Auto Craft Essence`.
- The `Trade Up Tiers` dropdown and `Smart Trade for Essence` toggle
  are no longer hidden when `Auto Trade Up` is OFF — same
  dependency-box removal as the Catch tab. The counts row now uses the
  format `Emerald: N - Sapphire: N - Amethyst: N - Radiant: N - Essence: N`
  (single dash, no `|` separators) and reads `Radiant` (not `Radian`).
  Each of the five resource names is purple; the numbers and dashes
  stay white.
- Implementation: the `Purple` field on the label table is now a list
  of keywords. The shared `show()` helper runs a single
  `text:gsub("(keyword1|keyword2|...):", '<font color="#D946EF"><b>%1:</b></font>')`
  over the row, so only the matched `Keyword:` prefix is wrapped.
  Initial `AddLabel` text is left plain until the first observer
  tick. `countdown()` was tweaked to use the colon form
  (`Live: Ns left` / `Live: bloom window`) so the `Live` keyword
  matches.
- Checker updates: butterfly_ui / admin / capture hashes all advanced
  (the keyword list and `show()` body changed the post-strip text).
  All other source checkers unchanged.


## Butterfly Bloom + Shooting Star

- One outer Event group with two distinct-icon inner tabs (Catch / Workshop).
- One shared cooperative event job worker, single-flight.
- Save-confirmed consumption and grant via `SaveModule.Get` / explicit reply.
- Race always preempts.  No second movement worker or cloned rig.

## Capture The Egg — admin event

- Lives inside the **Admin Abuse** top-level tab (Capture The Egg group).
- Holds the event UID/record instead of dropping it into bank/deposit.
- Reuses `runOwned` / `callOwned` in the existing shared event worker.
- Bat combat, holder eligibility, real server standings.
- No invented claim/deposit RPC; no fake bank/deposit action.

## Admin Abuse (top-level tab)

- Saturday/Sunday night around 22:00 WIB the admin event drops.
- **Auto Use Admin Treadmill** ON by default (mirrors source V2 76576–76600).
- **Auto Steal V3 (Admin Treadmill)** OFF — only takes effect while the
  admin treadmill is live; gates Auto Use Admin Treadmill.
- **Auto Steal Minigame Egg** OFF — Red Light Green Light + T-Rex Run
  detector. Sub-controller (mirror of source V2 76810–77070):
  - Detect: `workspace:GetAttribute("Event_RedLightGreenLight")` /
    `"Event_TrexRun"` flag + `RLGL_EggPosition` / `TrexRun_EggPosition`
    Vector3 attribute.
  - Find UID: nearest field egg (`EggStateModule.ReadFieldEggs().Records`)
    within 40 studs, excluding `Carried` / `Claimed` / `GuardCarried` /
    numeric carried states.
  - Gate: stable UID for 2 s before any pickup.
  - Pickup: route the existing N3 steal engine —
    `Engine.CurrentTarget = uid` + `Engine.AutoWake()` — no scripted
    pickup RPC.
  - Save/restore: `FarmConfig.AutoStealAll / AutoStealSelected /
    AutoStealEnabled` flipped off during the minigame takeover and
    restored on toggle-off / unload.
- Boost detector scans `workspace:GetAttribute("AdminBoost_*")` first
  (authoritative), then `BottomUI/BottomFrame/Holder/<Name>/Value,Timer`.
- Treadmill recovery watchdog binds `RE/Treadmill/AssignedBeltShifted`
  and watches `LocalPlayer.leaderstats.Speed`.  `RF/Treadmill/AskDoff`
  on stuck speed, `UndoSwap` after two fails, `RequestRespawn` after
  three.  Reuses `Tasks.MountTreadmill` / `Tasks.TreadmillMayRun` /
  `Tasks.ExitTreadmill` — no parallel worker.
- Race-first: `RaceShouldYieldSteal` / `RaceOwnsCharacter` gate every
  mutation.  No invented remotes.  No logging on disk.

## Built-in safe-zone visual

- Optional, default OFF, opt-in toggle in Home → Farm Eggs.
- Reversible visibility/camera only.  Real character still travels,
  picks up and deposits eggs.  Race preemption releases the dummy
  even when ON.

## Backlog — three remaining broad scopes

1. Minigame events: Auto Steal Minigame Egg is currently a status
   detector; the actual live pickup flow still needs the source V3 path
   validated.
2. Auto Hop / server tools: explicitly deferred, separate manager
   module like SaveManager/ThemeManager, not bundled into farm changes.
3. Remaining utilities / HUD: umbrella scope; enumerate before
   estimating.

## Live checklist (per scope)

Static/compile checks are not live Roblox evidence.  The user must verify
each scope in a fresh executor instance with one hub only, watching
actual inventory/wins/Tokens before/after, not just local status text.

- Capture: actual event possession, holder with/without bat, real
  standings, no double-steal during admin abuse.
- Admin: Saturday/Sunday night the AdminTreadmill part shows up; boosts
  flip on; the Boosts row lists the active boost; Minigame row shows the
  event name when RLGL/T-Rex is live.
- Race: farm with Auto Race ON, observe pause → cleanup → portal →
  heat → leave/return → resumed farm.  Toggles/filters stay unchanged.
- Lab: enable Lab sell/stock, exercise rule changes, ensure normal
  steal unchanged and no overlapping action.
- Quests: Forest held → door TP works; no fallback death.

## Still pending

- Live validation of every scope; no live Roblox / server / reward /
  route / death / FPS claim from static tests.
- Minigame live pickup.
- Auto Hop / server tools.
- Remaining utilities / HUD.

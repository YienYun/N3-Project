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

## Shooting Star + Race Rally UI refresh

- Shooting Star (`Event -> Shooting Star`): the live `Status:` and
  `Caught:` labels were already using a static purple `Status:` /
  `Caught:` prefix, but the `Auto Catch Star` toggle sat ABOVE the
  labels. Reorder so the labels are first and the toggle is last.
  Both labels now go through the same `Purple` keyword-list
  mechanism used by the Butterfly Catch tab, so the `Status` /
  `Caught` prefixes are keyword-only purple and the value
  (`Off`, `0`, etc.) stays in default white.
- Race Rally (`Event -> Race Rally`): the combined `Tokens / Wins /
  Racer` line on a single row was split into three separate
  labels so each value sits on its own line:
    `Status:` (purple keyword, status text in default white)
    `Tokens: 334` (purple keyword, value in default white)
    `Win: N` (purple keyword, value in default white)
    `Race: <name>` (purple keyword, value in default white)
    `Auto Race` (toggle)
    `Auto Use Power Up` (toggle, no longer hidden behind Auto Race)
    `Auto Claim Race Reward` (toggle, no longer hidden)
    `Race Speed` (slider, no longer hidden)
    `Auto Equip Race` (toggle, renamed from `Auto Equip Racer`)
    `Racer` (dropdown, no longer hidden behind Auto Equip)
    `Auto Buy Race` (toggle, renamed from `Auto Buy Race Shop`)
    `Race Shop Items` (multi-select dropdown, no longer hidden)
- All three `RaceDriveOptions` / `RaceEquipOptions` /
  `RaceShopOptions` `AddDependencyBox` wrappers are dropped so every
  Race Rally control is visible without first turning its parent
  toggle ON.
- `PublishRaceStatus()`: the long composite status text
  (`"Racing Event open, 1:20 to join  |  Next Racing Event in 1:20"`)
  is replaced with a single short token: `Off` (toggle OFF),
  `Racing` (already in a race), `End In M:SS` (race window open
  and will end in N), or `Spawn In M:SS` (no race currently
  scheduled, next opening in N). The label still shows
  `Status: <token>` with the keyword-only purple accent.
- Checker updates: butterfly_ui, admin, capture, bloom_star, banjo,
  quest_transit, wisp, nitro_refill, auto_mutate, lab_stock,
  lab_seller, treadmill_lab and steal_visual hashes all advanced
  because the Race Rally UI text and the `show()` /
  `PublishRaceStatus()` strings are inside the bodies those scope
  checks measure. `check_race_source.py` was updated to look for
  `Lbl_RaceStatus / Lbl_RaceTokens / Lbl_RaceWin / Lbl_RaceName`
  (the new split labels) and to slice the speed slider via the
  `RaceRallyGroup:AddSlider("Slider_Race_Speed", {` call now that
  the `RaceDriveOptions` dependency box is gone.
  `check_steal_source.py` adds the two new checker files to its
  allowed-change set.

## Race Rally: collapse to a single multi-line label

- The user reported visible vertical gaps between the four separate
  Race Rally rows (`Status:` / `Tokens:` / `Win:` / `Race:`) on
  account of the N3V3 library injecting default padding between
  consecutive `AddLabel` instances. The four rows are now collapsed
  into a single `AddLabel` whose text is joined with `\n` so the
  rows render tight (no extra blank line between them). The live
  updater writes the four lines in one
  `Lbl_RaceStatus:SetText(...)` call.
- `check_race_source.py` now only looks for the single
  `Lbl_RaceStatus:SetText(` call site; the four `St.Status`,
  `St.Tokens`, `St.Wins`, `St.Racer` field references are still
  enforced so the live display is still hooked up.

## Auto Butterfly: clear stale BackoffUntil on toggle

- `settingsChanged(bloom)` now also resets `bloom.BackoffUntil = 0`.
  The user reported Auto Butterfly failing to start when they join
  the game mid-bloom. The catch worker can leave `BackoffUntil`
  set up to 10 seconds in the future after a ragdoll-TP miss or
  similar transient failure; if the user toggles Auto Butterfly
  off then on (or the script is reloaded) that stale backoff
  used to leak into the new attempt. Toggling the toggle (or
  re-running the script) now gives a clean retry.

## Drop Training live-status label

- The user wanted the `Progress -> Training` group to drop the
  four-row live status block (`Status:` / `Treadmill:` / `Speed:`
  / `Timer:`). The `Lbl_TrainingStatus` AddLabel, the
  `task.spawn` updater that wrote to it, and the now-orphaned
  helpers (`ParseSpeedText`, `GetHudSpeedText`,
  `GetTreadmillRateTextRaw`, `GetTreadmillRateText`,
  `IsOnTreadmill`, `SPEED_UNITS`, `TREADMILL_STEPS_PER_SECOND`,
  `_HudSpeedValue`, `_HudSpeedScanAt`, `_RateText`, `_RateTextAt`,
  `TrainSession`, `LastStatusText`) are all removed. The Training
  group now contains only the five toggles and the Cash Reserve
  input. No treadmill worker / mount / state was changed; the
  underlying `IsPlayerRunningOnTreadmill` predicate that the
  treadmill worker uses is still in place.

## Admin Abuse: trim UI labels and drop V3 status row

- `Event -> Admin Abuse -> Capture The Egg`:
  - `Auto Capture Event Egg` toggle renamed to `Auto Capture Egg`
    (shorter, the `Event` prefix is implicit from the parent tab).
  - The `Held: - | Rank: -` status label is dropped. Only the
    `Status:` label is kept.
  - The now-orphaned `standing` build + `ShownStanding` write in
    the observer loop are removed. `state.Seconds` / `state.Rank`
    are still written by `bindStandings()` (cheap, harmless) but
    no longer rendered.
- `Event -> Admin Abuse -> Admin Abuse`:
  - `Auto Steal V3 (Admin Treadmill)` toggle renamed to
    `Auto Steal V3` (the `Admin Treadmill` suffix is redundant
    once it lives in the Admin Abuse tab).
- `Event -> Admin Abuse -> Admin Status`:
  - The `V3: -` row is dropped. The row was redundant with the
    `Auto Steal V3` toggle text and the underlying `statusV3()`
    helper output is no longer rendered, so the
    `out[4] = "V3: " .. statusV3()` line in
    `Tasks.AdminStatusRows()` is removed. The remaining rows
    reindex as `Boost=1, Capture=2, Treadmill=3, Minigame=4`.
  - Every "no value" default is now `???` instead of the em-dash
    `-`. The static `StatusGroup:AddLabel("Boost: -", true)` etc.
    placeholders in `BuildAdminUI` and the `Boost: ... or "-"`
    fallback in `Tasks.AdminStatusRows()` are both updated.
- No behavior change to the underlying controllers; only labels
  are touched. All 15/15 static scope checkers and the Luau WASM
  compile pass.


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

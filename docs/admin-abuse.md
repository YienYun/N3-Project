# Admin Abuse — source-backed N3 implementation

## Scope

Source-backed adapter over Chili V2's AdminAbuse stack (8950–9330) and the
existing N3 Treadmill mount (10390–10730, 8158–8238).  The controller must not
introduce a parallel movement worker, a parallel invoker, invented remotes, or
a second steal cycle.  It reuses the existing N3 `Tasks.MountTreadmill`,
`Tasks.TreadmillMayRun`, `Tasks.ExitTreadmill`, and the leaderstats `Speed` read
that the N3 treadmill path already watches.

## Home tab

`Admin Abuse` is a **top-level tab** in `MainWindow`, sitting next to
`Event`, `Predictor`, `ESP`, `Settings`, `Webhook`, `Misc`.  Inside the tab we
have two groupboxes, no subtabs:

| Group | Toggles / rows |
|---|---|
| Admin Abuse (left) | Auto Use Admin Treadmill, Instant Steal V3, Auto Steal Minigame Egg. |
| Admin Status (right) | Status, Boosts, Capture, Treadmill, V3, Minigame. |

Default values mirror Chili V2 76576–76600:

| Toggle | Default | Notes |
|---|---|---|
| Auto Use Admin Treadmill | ON | Mounts `workspace:FindFirstChild("AdminTreadmill")` when Chili assigns a belt, and watches the six boost attributes (Speed/Treadmill/Earnings/EggSize/EggLuck/Mutation). |
| Instant Steal V3 | OFF | Chili V3 path; only meaningful while the admin treadmill stays on. |
| Auto Steal Minigame Egg | OFF | Red Light Green Light + T-Rex Run detectors. |

The tab is registered next to the Event tab in `Tasks.BuildMainInterface` and
populated by `Tasks.BuildAdminUI(AdminTab)` from the controller block.  The
published `75883b2` baseline is unchanged after admin stripping
(`strip_admin` reproduces the exact hash).

## Source protocol (no invented remotes)

- **Boost detector** reads `workspace:GetAttribute("AdminBoost_*")` first, then
  confirms with the same `BottomUI → BottomFrame → Holder → <Name>` text scan
  Chili uses (9007–9030).  The attribute is authoritative; UI text is purely
  informational.
- **Treadmill mount** calls `Tasks.MountTreadmill()` (already N3-native), gated
  by `Tasks.TreadmillMayRun()` and `raceWanted()`.  No `task.spawn` worker.
- **Watchdog** binds `RE/Treadmill/AssignedBeltShifted` (server signal) to set
  `OnAdmin`, and watches `LocalPlayer.leaderstats.Speed`.  When the speed does
  not rise after a server-shifted belt, the controller calls
  `RF/Treadmill/AskDoff` and retries, with `UndoSwap` after two failures and
  `RequestRespawn` after three — matching Chili's recovery ladder.
- **Minigame detector** reads the two flag attributes
  (`Event_RedLightGreenLight`, `Event_TrexRun`) and the corresponding
  `<Prefix>_EggPosition` / `<Prefix>_CarrierUserId` attributes.  The actual
  pickup is left to the Chili V3 path; N3 only publishes a status flag here
  because the live minigame flow depends on a Chili path we do not own
  end-to-end.
- **Capture row** reuses the existing `Tasks.CaptureView` and
  `Tasks.CaptureOwnsEgg` so there is exactly one source of truth for the
  Capture The Egg status.

## Lifecycle / race-first

- All control paths consult `RaceShouldYieldSteal()` /
  `RaceOwnsCharacter()` before mutating movement.
- `LibraryLoader:OnUnload` increments `state.Generation`, sets `Disposed`, and
  disconnects every link.  No state survives unload.

## What is intentionally NOT in this controller

- No invented remotes (`RF/AdminAbuse/...` etc.) and no second
  `RemoteTreadmillWear` invoke.
- No task-spawned action worker; the existing N3 treadmill mount is the
  single source of truth.
- No logging to disk — the source contract is to skip silently when
  `writefile` is unavailable, and the executor we run on has it, so we add
  nothing new for now.
- No minigame pickup RPC; we do not own the Chili V3 path end-to-end.

## Live checklist

- [ ] Saturday/Sunday night around 22:00 WIB the `AdminTreadmill` part shows
      up and the boost attributes flip on.  Auto Use Admin Treadmill should
      mount the player.
- [ ] The `Boosts: …` row in the Admin Abuse group shows the active boost
      list with the timer text from BottomUI.
- [ ] When a Red Light Green Light or T-Rex Run event is live, the
      `Minigame: …` row shows the event name; Auto Steal Minigame Egg must be
      flipped on manually after a live validation pass.
- [ ] Capture row mirrors the Capture The Egg status; no double-steal during
      admin abuse.
- [ ] Auto Race still preempts all admin automation; admin re-arms after the
      race ends.

## Files

- `tools/admin_scope.py` — stripper that reverses the admin block to the
  published 75883b2 hash `07f2ce6ece5e3941adec79f64a561cb5c847ae49c229facd139453fa9a48aedf`.
- `tools/check_admin_source.py` — semantic UI/source/lifecycle assertions.
- `Games/Steal-An-Egg.lua` — admin block between `-- BEGIN/END ADMIN
  CONTROLLER`, with the inner `-- BEGIN/END ADMIN UI` markers scoping the UI
  body.

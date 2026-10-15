# Standalone safe-zone visual V2 experiment

## Files and scope

Run **`Games/Steal-An-Egg-V2.lua` instead of `Games/Steal-An-Egg.lua`** in a fresh
script/game session. Never run both together: each is a complete standalone hub,
not an add-on. The test window is titled `N3 HUB | Visual V2 Test`.

Production `Games/Steal-An-Egg.lua`, the Library and the production loader URL
are unchanged. The starting version is `bd9c02f` (race diagnostics already removed).
This is a visual experiment, not a replacement of the successful normal steal.

## Sena source reread

Reference: `Games/Source/StealAnEgg/SenaV2.lua`, Git blob
`a36898ee403cacf3aa9742bfb9f9270f867cb765`.

- 4074: source safe-zone position `(544.76, 71.5, -416.48)`.
- 7275–7402, `_showTreadmillDecoy`: clone the character once, strip executable
  scripts/sound/billboards/trails, anchor the clone with collisions/queries/touches
  disabled, put it at the safe point, hide the real character locally and point
  the camera at the decoy humanoid. Track new character descendants too.
- 7405–7455, `_hideTreadmillDecoy`: disconnect visual listeners, restore local
  transparency/camera and destroy the decoy.
- 10127–10139, `_instantReturn`: the normal Fly return shows this decoy. In Sena,
  `_finish` (11244 onward) removes it; the outward Fly branch is not itself an
  always-on safe-zone camera.

The existing N3 port explicitly omitted this cosmetic part; this test adds it.
It does **not** add another humanoid-swap or movement controller.

## Intentional adaptations

- V2 starts the visual at the beginning of a normal cycle, including the N3
  outward approach. It keeps the same decoy between normal cycles/idle gaps
  while enabled. This is intentionally longer-lived than Sena's return-only
  Fly visual, to match the requested stationary safe-zone view and avoid a
  clone/destroy/camera handoff on every successful egg.
- Real selection, filtering, approach pace, pickup, safe-return/drop/re-grab,
  deposit confirmation and post-placement are still the original N3/Sena code.
  No real root teleport, remote, health change or forced Anti Guard preference
  is added by the visual controller. The real avatar still travels and game
  streaming/physics continue. The dummy is local, not a server-side safe avatar.
- One pre-camera render binding holds the camera subject on the decoy, retaining
  default mouse orbit/zoom. It traverses cached hidden instances only; no world
  scans, GUI scans or clone construction run each frame. Other systems can
  replace `CurrentCamera`; each camera's original state is saved separately.
- Existing optional N3 RunPace camera freezing and guard cosmetic disguise are
  bypassed **only while this decoy is active**, avoiding two camera owners.
  Pace and guard dodge movement are unchanged.
- Named `SpeedGainPopup` / `PlusOne` GUI objects and character trail/beam/particle
  emitters are hidden/disabled reversibly, rather than destroyed as in Sena.
  Other UI is not hidden. Decoy scripts, tools, prompts and effects are stripped
  before it enters Workspace. External welds are removed so the anchored dummy
  cannot constrain a live egg/rig through a copied reference.
- Cancellation, toggle OFF, death, character/humanoid replacement, unload,
  Instant/Line Drop, race ownership or another movement owner releases the
  visual. Disconnections and saved properties/camera state are restored before
  destroying the dummy. A visual setup failure cleans up, warns and leaves
  normal steal running; setup retries are rate-limited to five seconds.
- No next-cycle scheduler, duplicate pickup worker, graphics-quality downgrade,
  rendering disable or stream-focus trick is added.

## Validation

```
python tools/check_steal_visual_v2.py
python tools/check_race_source.py
```

The V2 checker verifies the exact Sena reference and that removing the nine
explicitly marked visual additions recreates the entire current production file
byte-for-byte. This covers the production loader, normal lifecycle, filters,
N3 approach, race, Instant and Line Drop. It also checks teardown/source boundaries.
Compile both complete files as Luau. These are static checks, **not** a Roblox
runtime test, FPS benchmark or evidence of server-accepted deposits.

## User live A/B test

1. Use only `Steal-An-Egg-V2.lua` in a fresh session. Keep the same egg filters,
   speed, Anti Guard preference and other automation settings as the working hub.
2. Home → egg farming: **Safe Zone Visual (V2 Test) ON** (default); normal Auto
   Steal All or Selected ON; Instant Steal OFF.
3. Expect a local stationary avatar at the source safe zone while the real rig
   goes to eggs. Verify orbit/zoom, egg receipts and actual inventory increments
   across at least five consecutive returns, not just the displayed status.
4. Toggle the visual OFF during an approach and during a carry/return. The view
   should return to the real character without stopping the original steal.
   Toggle it ON mid-cycle to reattach immediately, or before the next cycle.
5. Compare ON vs OFF using Roblox performance stats under comparable conditions.
   Note FPS/frame-time spikes specifically on return, with the same settings.
   A stationary camera may reduce visual jumps; it cannot guarantee fewer
   physics, streaming, server or other-script stalls.
6. Disable Auto Steal, switch to Instant/race, respawn and unload separately.
   Check that no hidden real avatar, stray dummy or stuck camera remains.

Report whether deposits still work, ON/OFF frame-time behavior, when the camera
jumps, and any `[N3 HUB] V2 safe-zone visual unavailable` warning. No live outcome
is established until this test is run in Roblox.

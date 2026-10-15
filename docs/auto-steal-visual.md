# Built-in safe-zone steal presentation

## Promotion and scope

The user tested the standalone normal-steal visual, confirmed that it works and
feels lighter on their phone. It is part of `Games/Steal-An-Egg.lua`, for both
**normal and Instant/Line Drop**. The user subsequently requested an opt-in:
Home → egg farming → **Safe Zone Visual**, default **OFF**. ON enables the local
dummy view; OFF immediately restores the real-character view without cancelling
steal. Enabling it mid-cycle attaches when steal owns movement; otherwise the
next accepted steal cycle attaches. No test title or separate V2 file remains.

Library and the production loader are unchanged. This is presentation only:
the real character still travels, picks up and deposits eggs. The dummy is local,
not a server-side safe avatar. No movement or server remotes are added by it.

## Source and lifecycle

Reference: `Games/Source/StealAnEgg/SenaV2.lua`, Git blob
`a36898ee403cacf3aa9742bfb9f9270f867cb765`.

- 4074: safe-zone point `(544.76, 71.5, -416.48)`.
- 7275–7402, `_showTreadmillDecoy`: one stripped, anchored clone; no collisions,
  touches or queries. Hide the real character locally and follow the clone's
  humanoid with the camera; track added character descendants.
- 7405–7455, `_hideTreadmillDecoy`: disconnect listeners, restore local visibility
  and the camera, then destroy the decoy.
- 10127–10139, normal Fly `_instantReturn`, shows the decoy; `_finish` removes it.
  Our approved visual intentionally lasts longer, including outward approaches
  and normal idle gaps, to avoid clone/destroy and camera switching each egg.

## Shared normal and Instant integration

An adapter around the existing `Engine.ClaimMovement` delegates to the original
first and starts the visual only for an **accepted** `"steal"` owner. This covers:

1. normal Sena scheduler, before N3 outward travel / carried-egg delivery;
2. Instant's existing `RunStealCycle`, before its original approach/pickup;
3. the outer Instant loop's already-carried delivery retry.

Both modes use the same decoy/controller. No new picker, scheduler, carry worker,
swap, drop/re-grab or deposit algorithm is installed. The normal/Instant speed
settings, filters and defense preferences are unchanged. The separate race-first
pause/resume policy is documented in `race-rally.md`.

Legacy camera-freeze predicates (including Instant/Line Drop ones) and the guard's
cosmetic disguise yield **only while the decoy is active**. The original camera
lock preference is not overwritten. Guard dodge movement itself is unchanged.

One pre-camera render binding retains Roblox's normal orbit/zoom around the
stationary dummy. Hidden objects are cached; no world/GUI traversal or cloning
occurs per frame. Decoy scripts, tools, prompts, effects and external welds are
removed before parenting to Workspace. This prevents an anchored copy from
constraining a live egg/rig through a copied joint reference.

Character trails/beams/particle emitters and named `SpeedGainPopup` / `PlusOne`
GUI objects are disabled/hidden reversibly instead of destroyed. Other UI stays
visible. Original presentation values and each camera's state are cached.

Cancellation, steal OFF, death, character/humanoid replacement, unload, race
ownership or another movement owner tears down the visual. Brief synchronous
post-delivery bookkeeping does not itself destroy/recreate the decoy each egg.
Switching normal/Instant uses existing cancellation, then the next accepted steal
movement starts the same visual. Setup failures clean up and leave steal running,
with a warning and five-second setup retry backoff.

## Validation

```
python tools/check_steal_visual.py
python tools/check_race_source.py
```

The visual checker verifies the exact Sena reference, retired tester, one optional
OFF-by-default toggle, both steal modes and the shared movement adapter. Its
reviewed gameplay baseline now includes the user-requested race-first policy:
SHA256 `611aa5dfdb913934ae82d1fd71254bbabea570f2d4bdd29adc67ad2d88be418b` after
removing the four marked visual/config/UI blocks and legacy camera gates.
The race checker independently keeps all eight original Sena/N3 gameplay-block
fingerprints: normal lifecycle, filters, approach/pace, swap/health, Instant and
Line Drop are unchanged except reviewed presentation gates. Future gameplay
changes require explicit review before updating the whole-file baseline.
Compile the complete game file as Luau too.

The user confirmed normal V2 live. The newly promoted shared **Instant** path has
only static/compile validation here; it is not yet a measured FPS benchmark or
agent-verified Roblox/server result. The old historical steal checker still needs
its unavailable historical game-file baseline; it is not reported as passing.

## Live regression checks

Use only the updated main file in a fresh session. Test **Safe Zone Visual OFF
and ON** with normal and Instant stealing. OFF should retain the original view;
ON should attach the safe-zone dummy. For both modes:

- Repeat several eggs and verify actual receipts/inventory, not just the status.
- Camera stays with the safe-zone dummy through approach, carry and return;
  orbit/zoom still work and no new dummy is created on each successful egg.
- Visual OFF or Auto Steal OFF restores the real character/camera; switching
  modes reattaches on the next accepted cycle only if the visual option is ON.
- Test death/respawn, night/reset, Auto Place, manual race and unload independently;
  no invisible avatar, orphaned clone or stuck camera should remain.

A stationary view can reduce visual jumps but does not disable real-character
physics, streaming, server work or other scripts. Do not claim universal no-lag
behavior or measured gains beyond the user's reported normal-test experience.

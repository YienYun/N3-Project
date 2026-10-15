# Built-in safe-zone steal presentation

## Promotion and scope

The user tested the standalone normal-steal visual, confirmed that it works and
feels lighter on their phone, and requested it become the default for **normal
and Instant/Line Drop** stealing. It is now part of `Games/Steal-An-Egg.lua`.
There is no new visual toggle, config preference, test title or separate V2 file.
The standalone tester and its old docs/checker have been retired.

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
settings, filters, priorities, defense preferences and race logic are unchanged.

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

The visual checker verifies the exact Sena reference, retirement of the tester,
no visual opt-in or mode exclusion, and the shared movement-ownership adapter.
Removing only the two reviewed presentation blocks and legacy camera predicates
must recreate the **entire** pre-promotion production game from `c89e8a0`, SHA256
`5a4350a7207136682561076b298c2c4f4cad0b7ecbe83ae781ca7cd074c86651`.
The race/normal boundary checkers use the same scoped presentation normalizer.
Future gameplay changes require explicit review before updating that baseline.
Compile the complete game file as Luau too.

The user confirmed normal V2 live. The newly promoted shared **Instant** path has
only static/compile validation here; it is not yet a measured FPS benchmark or
agent-verified Roblox/server result. The old historical steal checker still needs
its unavailable historical game-file baseline; it is not reported as passing.

## Live regression checks

Use only the updated main file in a fresh session. There is nothing extra to turn
on: start normal or Instant stealing with the usual settings. For both modes:

- Repeat several eggs and verify actual receipts/inventory, not just the status.
- Camera stays with the safe-zone dummy through approach, carry and return;
  orbit/zoom still work and no new dummy is created on each successful egg.
- Auto Steal OFF restores the real character/camera; switching modes reattaches
  automatically on the next accepted cycle.
- Test death/respawn, night/reset, Auto Place, manual race and unload independently;
  no invisible avatar, orphaned clone or stuck camera should remain.

A stationary view can reduce visual jumps but does not disable real-character
physics, streaming, server work or other scripts. Do not claim universal no-lag
behavior or measured gains beyond the user's reported normal-test experience.

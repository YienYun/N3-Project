# N3 Project — progress

Branch `arena/a7ae49dc-n3-project` on `YienYun/N3-Project`.

## Done

- `7c15cd0` Drop Training live-status label and its now-orphaned helpers.
- `e1c37bd` Race Rally: collapse status rows into one tight label; clear stale BackoffUntil.
- `e44febc` Admin Abuse: trim UI labels and drop V3 status row.
- `6901106` Misc: collapse Performance + Utility into one Misc group.
- `c7a3387` Misc: drop tmp scratch files from working tree.
- `9187283` Settings: fold Misc tab into Settings (Performance + Utility + Community).
- `6ec28a7` ESP: rewrite to Chili-style (Guards/Eggs/Players + size sliders + min rarity + show info + min value); Movement to Settings.
- `5971496` ESP: parent Highlights to PlayerGui folder so they always render.
- `33992d2` ESP: relax rarity filter, match Chili guard path, accept unknown eggs.
- `e868455` Revert ESP rewrite + 2 follow-ups: restore pre-Chili ESP.
- `28fa5e0` Clean working tree: drop `.tools/` checkers, `Games/AGENTS.md`, `docs/CHANGELOG.md`, add `PROGRESS.md`.
- `5e6a2aa` Tab: rename ESP tab -> TabPlayer (icon `user`); move Defense group from Home to TabPlayer (right).

## Final state after `5e6a2aa`

- Home tab: Farm Eggs, Pet Index, Task Priority (no Defense).
- TabPlayer (icon `user`):
  - Left = ESP (7 toggles + distance + show info + min rarity + min value + highlight).
  - Right = Movement, Defense (Anti Trap, Anti Ragdoll, Anti Guard).
- Pre-Chili N3 ESP backend is in place: `Tasks.EspRenderLoop`, `Tasks.CardRenderEggKey`, `Tasks.GetPlotItemDetails`.
- `FarmConfig` keeps `ESP_WorldEgg`, `ESP_CarriedDropped`, `ESP_Pet`, `ESP_Machine`, `ESP_Plot`, plus `Defense_AntiTrap`, `Defense_AntiRagdoll`, `Defense_AntiGuard`.
- Combat feature is **not** implemented yet; will be driven by a careful re-read of `Games/Source/StealAnEgg/ChiliSourceV2.lua` before any code is written.

## Reference (immutable)

- `Games/Source/StealAnEgg/ChiliSourceV2.lua` — `0d84fb63…`
- `Games/Source/StealAnEgg/SenaV2.lua` — `7f91e174…`
- `Library/N3V3-NoObfus.lua` — `40f109dc…`

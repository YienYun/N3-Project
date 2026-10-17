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

## Final state after `e868455`

- Pre-Chili N3 ESP backend is back in place (multi-toggle ESP tab, World Egg / Carried / Guard / Pet / Player / Machine / Plot, ESP Distance, Show Info, Min Rarity, Min Value, Highlight, Movement group inside the ESP tab).
- `Tasks.EspRenderLoop`, `Tasks.CardRenderEggKey`, `Tasks.GetPlotItemDetails` restored.
- `FarmConfig` keys `ESP_WorldEgg`, `ESP_CarriedDropped`, `ESP_Pet`, `ESP_Machine`, `ESP_Plot` are back.
- The 15 static scope checkers (`.tools/`) are no longer needed and have been removed from the working tree.

## Reference (immutable)

- `Games/Source/StealAnEgg/ChiliSourceV2.lua` — `0d84fb63…`
- `Games/Source/StealAnEgg/SenaV2.lua` — `7f91e174…`
- `Library/N3V3-NoObfus.lua` — `40f109dc…`

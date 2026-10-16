# Remaining Chili gap audit — working backlog

This is the recorded backlog, **not an exhaustive feature-by-feature re-audit**.
Count **seven broad scopes**, not seven toggles or a fixed estimate of remaining
work. Utilities/HUD and server tooling still need their own detailed breakdown.

1. **Butterfly workflows** — full source-backed controller, not a priority label.
2. **Shooting Star** — full event workflow; existing state/priority hooks alone
   do not establish implementation.
3. **Capture The Egg** — complete event flow. Existing reward filters / capture
   UID exclusions / movement hooks are partial integrations, not completion.
4. **Admin events** — audit and port the actual source workflows separately.
5. **Minigame events** — audit and port the actual source workflows separately.
6. **Auto Hop / server tools** — explicitly deferred, separate manager module
   like SaveManager/ThemeManager, not bundled into quest changes.
7. **Remaining utilities / HUD** — umbrella scope; enumerate before estimating.

## Already integrated; do not count as missing controllers

- Native normal/Instant steal and optional safe-zone visual.
- Race Rally, treadmill / Scramble Lab fixes, Lab stock and Lab seller.
- Auto Mutate and optional Nitro replenishment.
- Wisp and Banjo Cricket. The user accepted Forest-door correction `c620126`
  and moved on to further features. Latest UI request flattens both into one
  Home / Quests group without subtabs; no movement/quest logic changes.

Implementation and user acceptance of a particular fix are not proof that every
quest, reward, event edge case or device has been live-tested. Preserve confirmed
normal/race behavior, current Forest-door transport, raw UID protocols, native
ownership and user preferences. Continue one feature at a time; never infer a
working event from its priority entry or a reward category filter.

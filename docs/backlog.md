# Remaining Chili gap audit — working backlog

This is the recorded backlog, **not an exhaustive feature-by-feature re-audit**.
Count **five remaining broad scopes**, not a toggle count or a fixed estimate of remaining
work. Utilities/HUD and server tooling still need their own detailed breakdown.

1. **Capture The Egg** — complete event flow. Existing reward filters / capture
   UID exclusions / movement hooks are partial integrations, not completion.
2. **Admin events** — audit and port the actual source workflows separately.
3. **Minigame events** — audit and port the actual source workflows separately.
4. **Auto Hop / server tools** — explicitly deferred, separate manager module
   like SaveManager/ThemeManager, not bundled into quest changes.
5. **Remaining utilities / HUD** — umbrella scope; enumerate before estimating.

## Already integrated; do not count as missing controllers

- Native normal/Instant steal and optional safe-zone visual.
- Race Rally, treadmill / Scramble Lab fixes, Lab stock and Lab seller.
- Auto Mutate and optional Nitro replenishment.
- Butterfly Bloom catching + Workshop manual/smart trade and essence crafting;
  Shooting Star fall/hold/catch workflow. See `butterfly-shooting-star.md` for
  exact source mapping, native adaptations and unverified live acceptance.
- Wisp and Banjo Cricket. The user accepted Forest-door correction `c620126`
  and moved on to further features. Latest UI request flattens both into one
  Home / Quests group without subtabs; no movement/quest logic changes.

Implementation and user acceptance of a particular fix are not proof that every
quest, reward, event edge case or device has been live-tested. Preserve confirmed
normal/race behavior, current Forest-door transport, raw UID protocols, native
ownership and user preferences. Continue scoped source-backed work; never infer a
working event from its priority entry or a reward category filter.

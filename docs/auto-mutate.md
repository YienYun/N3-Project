# Auto Mutate (one incremental Chili feature)

## Source and scope

Reference: unchanged `Games/Source/StealAnEgg/ChiliSourceV2.lua` 53868–54810.

- 53868–54130: mutation labels/IDs, placed owned records, consumable tool
  attributes, existing mutations, rarity/income/species and priority selection.
- 54130–54390: exclusive `essence` ownership, eligibility, proximity, equip, UID
  RPC and response/cooldown handling.
- 54565–54810: lifecycle, filters and UI.

Production uses one marked controller after Race initialization, plus one marked
UI-builder call. No modification of Race, normal/Instant/Line Drop, stock or
seller bodies. No second swap/fly controller. No additional shop purchase RPC.

**Follow-up: optional Auto Buy Nitro is now integrated separately.** See
`nitro-refill.md` for its default-OFF toggle and shared race-shop purchase lane.
The no-race-body/no-shop-RPC scope above describes the original Auto Mutate
change; the follow-up adds only an AskBuy routing gate inside the race body,
not changes to driving/ownership. Chili's one-time forced Nitro-selection file
migration remains intentionally omitted; mutation choices stay user-owned.

## Compact UI

**Pets → Mutation**, one group with a wand icon:

- Auto Mutate (OFF by default).
- Mutations (Fractured/Boss, Scrambled, Enchanted, Nitro; source defaults all).
- Min Rarity (Common by default).
- Income Above (raw dollars/second; 0 disables this threshold).
- Target Eggs (empty = all eligible placed owned eggs).
- Priority (Highest Value, Best Rarity, Biggest Size).
- Delay (1–10 seconds, default 1).

No description/footer/status/preview rows, short tooltips only. Config option
keys are unique; any filter/toggle change cancels unsent work and debounces
restarting for three seconds. Enabling can spend owned consumables; failed rolls
can consume them too, according to the game. Use restrictive targets first.

## Protocol / eligibility

- Only `ReadOwnerEggs(LocalPlayer.UserId)` records with Placement qualify.
  Retain original UID (`record.Uid or map key`) without writing into records.
- Tool must be MutationConsumable; use MutationId/MutationTemplate/default Boss,
  positive Uses or `[Xn]` name count. Fractured aliases Boss. Equip before RPC.
- Existing mutations support base/string/list/keyed/named-record forms; never
  apply a selected mutation already present. Rarity, income and species filters
  are rechecked just before use. Missing metadata, rendered egg or owner data
  means no use, not a blind fallback.
- Position comes from `Workspace.AreaEggSlotsClient/<uid>` Model/BasePart pivot.
  Unlike Chili's fallback to a generic PenAnchor, N3 skips unrendered targets;
  it does not pretend an approximate pen location proves proximity.
- Exact RPC: `RF/BossMastery/AskUseMutationConsumable:InvokeServer(rawUid)`.
  Mutation ID is not an invented second argument; the equipped tool selects it.
- Only reply.Success true / reply.Mutated true is classified Applied. Success
  true + Mutated false is a failed roll. Missing/unknown responses cool down 10s;
  refusals block UID:mutation 120s, three refusals cause 15s cooldown. Successful
  mutations get a 3s replication grace before any same-pair retry. No inventory
  disappearance is claimed as server acceptance.

## Native coordination / deliberate movement adaptation

- Acquire `essence` only from an idle native engine (no active normal/Instant,
  carrying, guard dodge, inventory action or treadmill RPC). Never cancel an
  in-flight steal or clear shared IsExecuting. Race always wins. Native filtered
  field candidates and Task Priority determine whether farming goes first.
- One action per lease, not an unbounded batch that can starve other features.
  Priority adapters advertise Essence only after its lease is held, so merely
  finding a mutation target cannot interrupt an already-started Instant cycle.
- While leased, farm logic and new deposit/hatch requests pause without toggling
  the user's settings. Track already-started deposit/hatch dispatch calls and
  a short delay for native asynchronous hatch finishes before starting mutation.
  This is not an atomic guarantee against a previously sent/delayed server call.
- Existing N3 ReleaseAutoShield / RestoreCharacter restore the native humanoid
  for equip/use; an adapter pauses automatic re-swap only during the lease.
  Optional Anti Guard preference is untouched; its movement callback temporarily
  yields. On release AutoWake and existing shield maintenance resume normally.
- **Transport adaptation:** Chili uses its generic FlyTo. N3's FlyToPosition /
  RunPace explicitly require IsStealActive, so reusing them while pausing farms
  would abort or require lying to the steal controller. This feature instead
  uses Roblox Humanoid MoveTo, bounded to 12s, checking proximity <=6 studs.
  No root teleports, CFrame tween, new ragdoll/respawn, camera override or cloned
  rig. Straight walking can fail around obstacles; it releases and retries,
  rather than escalating/resetting. This adaptation needs live validation.
- Revalidate character, active humanoid/root, generation, race/owner, tool,
  existing mutation, filters and distance immediately before InvokeServer.
  Invisibility marked InvisApplied blocks the action rather than forcing a
  preference change. Walking stops on cancellation while still this owner.
- Cleanup restores the previous tool only when still in the same character's
  Backpack/character and this job's consumable is still equipped. Never touch a
  newer owner's rig/tools. Race handoff skips equipment restoration. Release
  only own movement; adapters restore conditionally on unload.
- A sent InvokeServer cannot be recalled. The worker stays single-flight until
  it returns; after race/respawn/unload its late result must not move/equip.
  Race's existing bounded ownership fallback is unchanged.

## Validation

Run `check_auto_mutate_source.py`, `check_nitro_refill_source.py` and the five
other source checkers, then compile the entire production Luau file. Mutation
scope checker removes exactly two marked insertions (after stripping the separate
Nitro follow-up) and reproduces dbaeb09's full reviewed normalized hash.
Eight protected gameplay blocks retain their fingerprints. The full race
fingerprint now excludes only the separately reviewed Nitro shop-routing gate.
Library and bundled references remain unchanged.

These are static/compile checks, not Roblox/server/mutation/FPS tests. No actual
consumables were spent or game recipe simulation executed by the agent.

User live-test with one expendable consumable/placed egg and restrictive filters:

1. Disable Auto Hatch and other hubs for the initial isolated test. Select only
   the intended mutation/species and check OFF does nothing.
2. Enable, confirm walking/equip and in-game mutation result/consumable count.
   Check already-mutated, unplaced and below-filter eggs are skipped.
3. Exercise priorities, empty Mutations, missing tool and missing world render.
4. Test normal/Instant active carry: mutation waits, no farm toggles change.
   Higher-ranked eligible native candidates should go first.
5. Test treadmill exit and restoration, Auto Place/Hatch pause, race arrival
   during walk/equip and during a pending RPC, then normal farm resume.
6. Change filters/disable during walk and equip; respawn or unload. Confirm no
   stale equip/movement, duplicate worker or repeated same-pair refusal spam.

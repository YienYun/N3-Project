# Auto Treadmill and Scramble Lab

## Scope and reference

Production integration: `Games/Steal-An-Egg.lua`. Reference remains the untouched
`Games/Source/StealAnEgg/ChiliSourceV2.lua`, SHA-256
`0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d`.

Reviewed reference ranges (original file line numbers):

| Reference | N3 adaptation |
| --- | --- |
| 10342–10780: training worker, cancellation, Wear, SpeedGained and recheck | Shared `MountTreadmill`, `TreadmillMayRun`, movement adapter and `TreadmillState` |
| 39849–40125: own belt discovery, OnBelt geometry, Doff | `ScanTreadmillInPlot`, `IsPlayerRunningOnTreadmill`, targeted `ExitTreadmill` |
| 15817–15877: next tier, Money/Price and AskTierRaise ID | `ExecuteUpgradeTreadmill`, retaining N3 Cash Reserve |
| 11125–11590: Lab state, selection, reservations, trade, refresh and reveal | `RefreshScrambleState`, `GetScrambleTradeStatusFn`, `RunLabAction` |
| 11211–11300: unused UIDs, placed exclusion, mutation/scale ordering | Inventory picker and separate slot-indexed UI selections |
| 11443–11533: unlocked/pending/banner ordering and direct UID-array fallback | Shared action lane, with pending reveal before banner gate |

## Treadmill repairs

- Plot `TreadmillBottom` takes precedence over arbitrary render decoration;
  the own-plot render fallback prefers BoundingBoxPart/PrimaryPart.
- The near-belt test uses belt-local bounds, not a fixed 3.5-stud radius.
  Proximity alone no longer declares an automated mount successful.
- Both UI and periodic automation enter the **same single-flight mount worker**.
  The old synchronous Instant-scheduler mount call is removed. General automation
  schedules the shared worker instead of waiting for its travel/RPC.
- Worker claims native `"treadmill"` movement, travels toward the belt top, allows
  grounding, then calls `RF/Treadmill/AskWearStill` **without arguments**. It uses
  Chili's accepted/non-false response, Already using treadmill, and recent gain
  plus OnBelt interpretation of Not grounded.
- Recent SpeedGained (<6 seconds) sustains training; a stale mount rechecks after
  five seconds. Failures back off 1.5 seconds. Travel is bounded at six seconds;
  grounding wait is bounded at 1.5 seconds.
- Cancellation checks generation, toggle, health, character, belt existence,
  movement owner, actual farm work, filtered egg candidates and race priority.
  Candidate discovery is native and cached for 0.3 seconds, not rescanned at FPS.
- The small movement adapter defers handoff while Wear is outstanding. It also
  prevents normal steal's **no-target idle return** from repeatedly ejecting idle
  training; real native candidates/carry and higher-priority work still take over.
- No new humanoid swap/controller and no forced AutoRotate, PlatformStand, pad
  collision or touch changes are installed by mounting. Existing settings aren't
  saved incorrectly as `false` by a newly preempting worker.
- Doff is targeted and single-flight; it does not search all GUIs for Exit/Leave,
  destroy animation UI, stop arbitrary running animations or reset another owner's
  humanoid. Caller waits are bounded (up to 1 second for Wear, .35s for Doff).
- Upgrade resolves `Data.Treadmills.GetByUpgradeLevel(current + 1)`, checks Money
  minus Cash Reserve against Price, and sends the next tier's `_id`. No no-argument
  upgrade/prompt/button/touch spam. Upgrade requests have a separate busy/cooldown.

Related integration repairs: Training temporarily allows belt query/touch while
retaining the user's Anti Treadmill preference; turning training off reapplies that
preference. Idle restoration no longer rewrites a mounting/riding character.
Anti Treadmill mobility rechecks race/execution ownership after Doff yields.

## Lab repairs

- State fetch is read-only, single-flight and throttled to one second, including
  failed/forced requests. It no longer finishes PendingReward merely because the
  UI requested state. Empty requirements replace, rather than retain, an old recipe.
- Rotation and accepted mutations invalidate state, requirements, missing targets
  and reservations. Revision changes reject obsolete fetch/action continuations.
- Picker supports Save.Get/Peek, excludes placed inventory and EggState owner
  placements, prefers unmutated eggs then smaller AssetScale, and selects each UID
  at most once across repeated-category requirements. RPC payload retains raw UID
  types; canonical strings are used only for local membership maps.
- Missing-category values are booleans, matching the native candidate check. The
  Lab target helper limits Lab-specific stealing to **currently missing** categories
  on an allowed, unlocked banner. Native normal filters/priority bodies are unchanged.
- Reservations are rebuilt each selection, not accumulated. N3's existing broad
  category Hold Back policy is preserved, now also respecting the banner filter.
  Auto Place refreshes selection and honors Hold Back in its initial snapshot pass
  as well as the tool pass; previously the first pass bypassed it. Sell discovery
  also refreshes selection before consulting Hold Back.
- Trade-in, reroll and reveal share one busy/cooldown lane across all callers.
  They require an enabled action and unlocked, recently fetched state. Pending
  reward is handled before banner filtering. Race pauses new Lab actions without
  changing farm preferences. Owned-inventory actions do not require stopping a
  busy egg farm or unequipping character tools.
- Trade uses the direct `AskTradeIn(uidArray)` route also present in Chili.
  A successful non-false response invalidates state; the **next enabled action**
  reads PendingReward before deciding whether to call FinishReveal. There is no
  unconditional delayed follow-up after OFF or race takeover.
- Auto Reroll works independently of Auto Trade-In, only with free refreshes and
  an incomplete recipe. A ready recipe isn't rerolled. UI readiness uses separate
  per-slot picks, so a filled third slot isn't incorrectly painted as the first.

## Preserved behavior and deliberate limits

- Complete live-confirmed race block from `1aa5920` is byte-identical, SHA-256
  `439836859bcbfcea949a78aea791381e721000b21246b8e5e110db2823244876`.
  Race speed stays 100–144, default/max 144. Optional visual stays default OFF.
- Eight protected Sena/N3/Instant/Line Drop/swap/filter/movement bodies remain
  byte-identical. Library, loader and both reference files are unchanged.
- No Chili Admin Abuse treadmill, new swap, automatic UndoSwap/respawn escalation,
  or Lab GUI/upvalue automation is imported. N3 uses its existing physical approach
  and native ownership; repeated grounding errors are retried, not forcibly reset.
- A sent Roblox RPC cannot be recalled. Cancellation prevents later client pose
  writes/follow-up actions, not a server transaction already in flight. A hung Wear
  holds off normal native handoff; race retains its existing eight-second fallback.
  Doff waits are bounded, while the outstanding request still blocks another mount.
- This fixes the audited treadmill/Lab defects and directly related consumers. It
  is **not** a claim that every unrelated feature has been audited or perfected.

## Validation and live checklist

Source-contract checks:

```
python tools/check_treadmill_lab_source.py
python tools/check_race_source.py
python tools/check_steal_visual.py
```

The whole production file was compiled as Luau using luau-web 1.5.1, without
executing it. These checks are **not** Roblox/server/FPS tests or simulations of
acceptance. Historical `check_steal_source.py` still needs its unavailable baseline;
it is not reported as passing. Treadmill/Lab changes require the user's live test.

Suggested clean-session checks, one hub only:

1. Enable training away from and already near the belt. Confirm actual Speed gain,
   not merely a Training label. OFF midway through travel must stop that travel.
2. Die/respawn during a mount; confirm old movement doesn't touch the new character.
3. With farm toggles still ON but no eligible eggs, check idle training. When an
   eligible egg appears, verify native steal resumes, then training can resume.
4. Open an eligible Auto Race window while training: exit, race normally, then
   resume farming/training. Recheck the already successful no-rollback race.
5. Upgrade below/above the next tier price and with Cash Reserve set: no purchase
   that would spend the reserve; stop cleanly at maximum tier.
6. Use a recipe with repeated categories and too few eligible eggs: not Ready,
   no duplicate-UID trade; placed eggs cannot fill slots. Add enough distinct eggs
   and verify the selected raw UID array, normal/small preference and one trade.
7. Enable Auto Place/Sell plus Hold Back: recipe material stays available. Turn
   banner filtering to a disallowed banner and verify stale Lab targets clear.
8. Enable only Auto Reroll: free incomplete recipes can refresh; ready recipes and
   zero-free-refresh states cannot trigger a refresh charge.
9. After a successful trade, verify PendingReward is claimed once; filter changes
   must not strand a previously earned pending reward. With all Lab actions OFF,
   opening/updating the UI must never claim/trade/reroll by itself.

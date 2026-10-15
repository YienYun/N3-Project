# Auto Wisp — Home / farm quest

Wisp is a **quest, not an Event**. UI: **Home → Quests → Wisp**. The explicit
collapsible outer Quests group has one icon and a nested Wisp tab with its own
icon, like the approved Lab/Custom structure. One OFF-by-default **Auto Wisp**
toggle and one short live status row. Banjo is not implemented or shown as an
empty tab. Server Hop is excluded at the user's request.

## Chili source map

Unchanged `Games/Source/StealAnEgg/ChiliSourceV2.lua`:

- 41403–41495: `Data.WispQuests.List/StageCount/RequiredSpeedPower`,
  `Save.WispCompanion` Accepted/Stage/Unlocked/Returning/Progress/Claimed,
  `Save.SpeedPower`, Build.EnchantedForestZoneRevealed. Source fallback 50B.
- 41500–41778: area `Data.Areas.Configs[AreaId].DropTable`, unfavorited and
  unequipped inventory pets, owned placed/unplaced eggs, growth/value planning,
  material reservations and species selection.
- 41780–41879: Fusery reveal/briefing/eject/load/begin; raw pet UID arguments.
- 41881–41935: EggSecured AreaId/Rarity matches and PetFused area shortfall.
- 41937–42161: exact `RF/WispCompanion/Request(action, questId)` with Accept,
  Claim, BeginReturn and Return; real WispSpawn/WispAnchor paths, travel and lease.
- 42163–42256: progress status, default-OFF toggle and scheduler/unload lifetime.

## Integrated behavior

Reads actual quest definitions and Save each second while enabled, never guessed
quest targets or hard-coded species. Unsupported match keys fail closed. Missing
modules/save/owner records leave status waiting and are throttled in the console.
Initial/config changes settle for three seconds. Completion requires Save.Unlocked;
RPC dispatch, local arrival or egg disappearance is not quest-success evidence.

One quest worker supplies Wisp candidates to the existing normal/Instant picker.
There is **no second steal controller** and no forced farm, Auto Place, Auto Hatch,
Auto Fuse, Anti Guard or mutation toggle. Wisp-only inputs use the existing Wisp
priority rank; a candidate also eligible for another task uses its better rank.
Normal filters, unsafe/carry/player exclusions, N3 movement and native delivery
remain in place. Existing in-flight Wisp normal/Instant cycles retain their own
lifetime through deposit confirmation even when the quest counter changes.

For the fusion quest, plan from real area drop tables and actual owned inputs.
Prefer ready pets, then official growth-duration/value ordering. Exclude favorited
and equipped pets, and hold native Lab-reserved unplaced eggs out of the plan.
Protect quest eggs/pets from the ordinary seller, and eggs from the Lab seller /
normal Auto Place. Native fusion/ejection waits during Wisp's fusion stage, with
preferences unchanged. Native inventory/fusion calls are tracked before they can
yield; the quest cannot claim movement until they finish and settle. Pending
Wisp hatches also block the native hatch dispatcher from starting duplicates.

Place only the missing chosen-species eggs using the native plot geometry and
`AskPlaceEgg({Uid, LocalCFrame})`; hatch only ready chosen-species eggs with raw
UID AskHatch/AskFinishHatch. Finish a started hatch before advancing other Wisp
work, even when its egg disappears before finishing. Native async hatch work
already sent cannot be recalled; the existing native settle window is not an
atomic server transaction.

**Auto Wisp may consume three unfavorited, unequipped pets during fusion,
including mutated pets.** This follows Chili's Wisp policy; it is independent of
the ordinary Auto Fuse filters. Favorite/equip anything to keep before enabling.
It can eject other pets back to inventory while preparing the three slots. The
server remains authoritative about money/slots/acceptance; no price is invented.
Each worker action is throttled to three seconds and refreshes inputs before
sending. Fusion Begin is marked pending before dispatch; ambiguous outcomes wait
for Save.FusionLocked or official quest completion rather than blindly fusing
again. OFF/ON does not clear unresolved fusion or a started hatch. Missing remote
or explicit server false clears only an attempt known not to have consumed.

Accept after the required Speed Power and Forest reveal, claim only the current
completed/unclaimed quest ID, then BeginReturn and Return at the real tree anchor.
No forced Forest detour is added to normal stealing.

## Movement / ownership adaptation

Race always preempts, regardless of priority order. Quest actions start only from
native idle, without interrupting field carry/normal/Instant, guard work, mutation
or treadmill RPCs. A banked equipped egg is distinguished from field carry only
with an owned-record match plus a nil live field read; otherwise wait. No invented
UID prefix, rollback workaround, reset or alternate swap controller is used.

Reuse native rig restoration under owner `wisp`. NPC/plot travel uses Chili's
stream-around, >40-stud character pivot fallback and bounded three-second MoveTo;
NPC trips wait for daylight/open wall. Unlike Chili, arrival must actually be
within six studs before the quest request. This pivot is quest-specific, **not**
a replacement for N3 normal egg movement. There is no imported RagdollTravel or
second fly/swap controller. Recheck generation, character/humanoid/root, owner,
invisibility and race after yields. Cleanup may stop motion only on the same
character while still owning the lease; it never clears shared IsExecuting or
restores a newer race owner's rig. Sent InvokeServer calls cannot be recalled.

## Validation / live checklist

Run `check_wisp_source.py`, all seven existing source checkers, full production
Luau compilation and reference/Library checksums. Removing exactly seven Wisp
insertion sites reproduces **byte-for-byte 3748a3e** (the user-live-confirmed Nitro
version). Historical checkers strip Wisp first; all prior expected hashes remain
unchanged, including race, swap, movement, normal/Instant and mutation proofs.
No live Roblox/quest/pet-consumption/FPS result is claimed by the agent.

Live-test one hub only, favoriting valuable pets first:

1. OFF makes no Wisp request. ON below the speed gate / before Forest reveal waits
   and explains why. Already unlocked Save reports done without repeat actions.
2. Meet Wisp, confirm accepted state; confirm the actual current quest is shown.
3. Test area and rarity tasks, normal and Instant, including no matching spawn.
   Auto Wisp must not change ordinary farm/defense preferences.
4. With expendable unfavorited pets/eggs, watch material collection, selective
   placing, growth, hatch/finish, slot preparation, three-pet fuse and reveal.
   Verify inventory/progress in the game, not only a local status message.
5. Confirm claim uses the current ID, and final return opens the tree in Save.
6. Race during NPC travel, hatch and a pending fuse request; disable/respawn/unload.
   No stale movement, repeated consumptive Begin or second worker should remain.
7. Regression-test Auto Mutate/Nitro, Lab/seller, treadmill and existing farms.

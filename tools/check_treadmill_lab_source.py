"""Source-contract regressions only. Does not execute/simulate Roblox or RPCs."""
from pathlib import Path
from nitro_scope import strip_nitro_shop_hook
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
runtime = (ROOT / "Games/Steal-An-Egg.lua").read_text()
reference = (ROOT / "Games/Source/StealAnEgg/ChiliSourceV2.lua").read_bytes()
assert hashlib.sha256(reference).hexdigest() == "0d84fb6313c37524f9eec7fd19e15c0e4b108db2f86579f7d5540aaabb32ca0d"


def section(start, end):
    first = runtime.index(start)
    return runtime[first:runtime.index(end, first)]


def contains(text, *contracts):
    for contract in contracts:
        assert contract in text, f"Missing source contract: {contract}"


# The user live-confirmed 1aa5920's race. Protect the entire body, not just names.
race = section("-- Racing Event: semantic port", "LocalPlayer.CharacterAdded:Connect(Tasks.OnCharacterAdded)")
assert hashlib.sha256(strip_nitro_shop_hook(race).encode()).hexdigest() == "439836859bcbfcea949a78aea791381e721000b21246b8e5e110db2823244876", "Live-confirmed race changed beyond the reviewed shop gate"

scan = section("function Tasks.ScanTreadmillInPlot(", "local GetTreadmillPart")
assert scan.index('"TreadmillBottom"') < scan.index('"__ClientTreadmillRenders"')
assert scan.index('"BoundingBoxPart"') < scan.index('render.PrimaryPart')
geometry = section("local function IsPlayerRunningOnTreadmill()", "Tasks.AutoStealBelt")
contains(geometry, "PointToObjectSpace(root.Position)", "pad.Size.X / 2 + 2", "pad.Size.Z / 2 + 2", "position.Y >= -2", "pad.Size.Y / 2 + 8")
mount = section("local function MountTreadmill()", "-- Preserve the native movement picker.")
contains(mount, "state.Busy or state.Exiting", 'engine.ClaimMovement("treadmill")',
         'engine.ReleaseMovement("treadmill")', "generation ~= state.Generation",
         'engine.Movement.Owner ~= "treadmill"', "LocalPlayer.Character ~= character",
         "humanoid.Health <= 0", "not Tasks.TreadmillMayRun()", "os.clock() + 6",
         "state.WearBusy = true", "state.WearBusy = false", "engine.IsGrounded(humanoid)",
         "Remotes.RemoteTreadmillWear:InvokeServer()", '"Already using treadmill"',
         '"Not grounded"', "os.clock() - state.LastGainAt < 6", "state.NextCheck = os.clock() + 5",
         "ok and riding == true and checked and current == true", "return not cancelled() and IsPlayerRunningOnTreadmill()", "if delta.Magnitude <= 3 then break end")
assert mount.index("state.Busy = true") < mount.index("RunService.Heartbeat:Wait()")
for retired in ("firetouchinterest", "fireproximityprompt", "AutoRotate =", "PlatformStand =", "CanCollide =", "CanTouch ="):
    assert retired not in mount
assert runtime.count("local function MountTreadmill()") == 1
assert runtime.count("task.spawn(MountTreadmill)") == 2, "UI and automation must share the worker"
assert len(re.findall(r'(?<!function )\bMountTreadmill\(\)', runtime)) == 0, "No synchronous duplicate mount lane"
may_run = section("function Tasks.TreadmillMayRun()", "local function ExitTreadmill()")
contains(may_run, "not FarmConfig.AutoTreadmill", "Tasks.RaceShouldYieldSteal()", "engine.AutoCycle",
         "engine.Guard.Busy", "engine.Movement.PlaceWanted", "belt.CandidateCheckAt = os.clock() + 0.3",
         "engine.CollectCandidates(false, not FarmConfig.Defense_InstantSteal)")
exit_belt = section("local function ExitTreadmill()", "Tasks.ExitTreadmill = ExitTreadmill")
contains(exit_belt, "state.Generation += 1", "state.Exiting", "state.WearBusy", "os.clock() + 1",
         "task.spawn(function()", "Remotes.RemoteTreadmillDoff:InvokeServer()", "os.clock() + 0.35",
         "LocalPlayer.Character == character", "not RaceOwnsCharacter()", 'owner == "treadmill"')
assert "GetDescendants" not in exit_belt and "firesignal" not in exit_belt and "PlatformStand" not in exit_belt
adapters = section("-- Preserve the native movement picker.", "local function ApplyTreadmillShield(")
contains(adapters, "Tasks.TreadmillState.WearBusy", "return nativeClaim(owner, ...)",
         'owner == "steal"', "Tasks.TreadmillMayRun()", "CharacterAdded:Connect",
         "GainConnection:Disconnect()", "CharacterConnection:Disconnect()")
upgrade = section("function Tasks.ExecuteUpgradeTreadmill()", "function Tasks.ExecuteUpgradePlot()")
contains(upgrade, "state.UpgradeBusy", 'data:FindFirstChild("Treadmills")',
         "treadmills.GetByUpgradeLevel((tonumber(save.TreadmillUpgradeLevel) or 0) + 1)",
         "tonumber(save.Money)", "tonumber(tier.Price)", "tonumber(FarmConfig.CashReserve)",
         "Remotes.RemoteTreadmillUpgrade:InvokeServer(tier._id)")
assert ":InvokeServer()" not in upgrade and "GetDescendants" not in upgrade

fetch = section("local function RefreshScrambleState(", "local function GetScrambleState()")
contains(fetch, "lab.FetchBusy", "(now - LastScrambleReqFetch) < 1", "revision ~= lab.Revision",
         'type(state.Requirements) == "table" and state.Requirements or {}')
assert "RemoteScrambleFinishReveal" not in fetch and "RemoteScrambleTradeIn:" not in fetch
invalidate = section("function Tasks.InvalidateLabState()", "local function RefreshScrambleState(")
contains(invalidate, "Revision += 1", "CachedScrambleState = {}", "CachedScrambleReqs = {}",
         "table.clear(RuntimeState.ScrambleWanted)", "table.clear(RuntimeState.ScrambleReserved)")
picker = section("GetScrambleTradeStatusFn = function()", "function DrScramble.LabActionAllowed()")
contains(picker, "RuntimeState.ScrambleWanted, RuntimeState.ScrambleReserved = wanted, reserved",
         "state.Unlocked ~= true", "not DrScramble.LabBannerAllowed(state)", "state.PendingReward",
         "SaveModule.Get()", "SaveModule.Peek()", "ReadOwnerEggs, LocalPlayer.UserId",
         "record.Placement ~= nil", "record.Placement == nil and not placed[tostring(uid)]",
         'record.BaseMutation ~= "Normal"', "next(record.Mutations) ~= nil", "return not a.Mutated",
         "return a.Scale < b.Scale", "not used[tostring(egg.Uid)]", "used[tostring(selected.Uid)] = true",
         "slots[slot] = selected.Uid", "table.insert(picks, selected.Uid)", "wanted[key] = true")
assert "list[1]" not in picker and "table.insert(picks, tostring" not in picker
lab_target = section("\tlocal function IsScrambleTarget(", "\tfunction Tasks.IsEggUnsafe")
contains(lab_target, "RuntimeState.ScrambleWanted[ScrambleCleanName(cat)] == true", "LabBannerAllowed")
action = section("function DrScramble.RunLabAction(", "function DrScramble.AutoRerollLab()")
contains(action, "lab.FetchBusy or lab.ActionBusy", "lab.ActionBusy = true", "lab.ActionBusy = false",
         "revision ~= lab.Revision", "not enabled()", "not DrScramble.LabActionAllowed()",
         "state.Unlocked ~= true", "if state.PendingReward then", "Remotes.RemoteScrambleFinishReveal",
         "ready or (tonumber(state.FreeRefreshesRemaining) or 0) <= 0", "if not remote or cancelled()",
         "if picks then return remote:InvokeServer(picks) end", "accepted and result ~= false",
         "Tasks.InvalidateLabState()", "lab.NextActionAt = os.clock() + 1")
assert action.index("if state.PendingReward then") < action.index("not DrScramble.LabBannerAllowed(state)")
assert action.count("RemoteScrambleFinishReveal") == 1 and "task.wait(0.8)" not in action
assert "AutoStealEnabled =" not in action and "UnequipAllTools" not in action
loop = section("function Tasks.ScrambleTradeLoop()", "task.spawn(Tasks.ScrambleTradeLoop)")
contains(loop, "or FarmConfig.Scramble_AutoReroll", "if FarmConfig.AutoScrambleSubmit then ExecuteScrambleTradeIn() end",
         "if FarmConfig.Scramble_AutoReroll then DrScramble.AutoRerollLab() end")
place = section("function Tasks.ExecuteDepositEggs(", "local function ExecuteAutoHatch()")
contains(place, "pcall(GetScrambleTradeStatusFn)", "elseif not ShouldHoldBackScrambleEgg(Rec.AssetCategory or Rec.Category, UidKey) then",
         "ShouldHoldBackScrambleEgg(Category, ToolUid)")
contains(runtime, "local isReady = info.SlotPicks[i] ~= nil", "Unlocked = state.Unlocked == true,",
         "or Tasks.TreadmillState.Busy or RuntimeState.OnTreadmill",
         "ApplyTreadmillShield(FarmConfig.AntiTreadmill and not State)")
print("PASS: Chili identity; live race byte-identical after excluding only the reviewed shop gate; single-flight/cancellable treadmill and correct tier payload.")
print("PASS: unique raw Lab UIDs, placed exclusion, normal/small preference, boolean missing targets, stale-state clearing.")
print("PASS: one gated Lab action lane, pending reward ordering, independent free reroll, slot-correct UI and Auto Place holdback.")
print("Static source contracts only: no live Roblox/server/FPS or simulated acceptance claim.")

"""Reverse exact reviewed Capture insertions to published 6d4af13. Frozen hashes stay unchanged."""
import re

ORIGINALS = {'TRANSIT OWNER': '\t\tassert(owner == "wisp" or owner == "banjo" or owner == "butterfly" or owner == '
                  '"star", "Owned transport owner required")\n',
 'EVENT OWNER': '\t\tassert(owner == "star" or owner == "butterfly", "Event transport owner required")\n',
 'TRAVEL SELECTOR': '\t\t\t\tif owner == "star" or owner == "butterfly" then\n',
 'TRAVEL EXCLUSION': '\t\t\t\tlocal slot = forestSlot(record, uid)\n',
 'TRAVEL ARRIVAL': '\t\t\t\tif report then report("At destination; finishing Forest TP") end\n',
 'TRAVEL FINISH': '\t\t\t\twhile (tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) > '
                  'Workspace:GetServerTimeNow() and not stopped() do\n',
 'GROUND CONTROL': '',
 'GROUND CLEANUP': '\t\t\tself.Active = false\n\t\t\tparts = nil\n',
 'GROUND FLIGHT': '\t\tfunction transit:BeginControl()\n',
 'DEMAND': '\tlocal function updateDemand()\n',
 'PRIORITY': '\t\tlocal rank = Tasks.PriorityRank(key)\n'
             '\t\treturn (star.Wanted and Tasks.PriorityRank("Star") < rank) or (bloom.Wanted and '
             'Tasks.PriorityRank("Butterfly") < rank)\n',
 'PREEMPTION': '\tlocal function higherTask(key)\n\t\tif raceWanted() then return true end\n',
 'IDLE SIGNATURE': '\tlocal function nativeIdle()\n',
 'CARRY ADMISSION': '\t\t\tand not IsActivelyCarryingEgg() and not GetEquippedEggTool()\n'
                    '\t\t\tand not (engine.State.Carrying or engine.State.SignalCarrying or '
                    'engine.State.WeldCarrying)\n',
 'JOB ADMISSION': '\t\tif activeJob or not allowed() or higherTask(key) or not nativeIdle() then return '
                  'end\n',
 'JOB PREPARE': '\t\t\tif cancelled() or not nativeIdle() then return end\n',
 'JOB API': '\t-- Shooting Star: authoritative payloads, visual/leg interpolation, hold/catch handshake.\n',
 'RANK': '\tlocal function bestEventRank()\n',
 'CLAIM': '\tlocal claimAdapter = function(owner, ...)\n'
          '\t\tif activeJob and owner ~= activeJob.Owner and owner ~= "race" then return false end\n',
 'WORKER': '\t\t\t\t\tlocal doStar = star.Wanted and (not bloom.Wanted or Tasks.PriorityRank("Star") <= '
           'Tasks.PriorityRank("Butterfly"))\n',
 'UI': '',
 'CONTROLLER': '',
 'HELD GUARD': '\tlocal activeAdapter = function() return activeJob == nil and nativeActive() end\n',
 'HELD YIELD': '\tlocal yieldAdapter = function()\n\t\tif activeJob then return true end\n',
 'PENDING STEERING': '\t\t\tif owner == "star" and job.Finally then pcall(job.Finally) end\n'}


def strip_capture(runtime):
    for label, original in ORIGINALS.items():
        pattern = r'^[\t ]*-- BEGIN CAPTURE ' + label + r'\n.*?^[\t ]*-- END CAPTURE ' + label + r'\n'
        runtime, count = re.subn(pattern, lambda match: original, runtime, flags=re.M | re.S)
        assert count == 1, f'Expected one reviewed Capture {label}, got {count}'
    return runtime

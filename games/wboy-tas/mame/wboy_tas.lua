-- 원더보이 TAS (2026-11-06). Loaded by wboy.ko.html with -autoboot_script.
-- 1단계 (user: "TAS 1단계 진행"): pause, frame steps, save slots.
-- 2단계 (user: "슬롯 내려 받기/올리기 기능과 입력 기록 기능 구현"): every frame's input is recorded from power-on,
-- a loaded slot cuts the record back to its frame (so the record is always the way to the current state), the record
-- can be dumped, and a record handed in at boot (tas/play.txt) is played back from power-on.
--
-- The page writes one command line to tas/cmd ("<seq> <op> <a> <b>"), this script answers in tas/out.
-- ops: pause | run | step N KEYS | hold KEYS | free | save NAME | load NAME | dump
-- KEYS: any of L R J K C S (left, right, button 1 = axe, button 2 = jump, coin, start), "-" = none.
--
-- All six inputs are always set by this script (field overrides): in "free" mode from the keyboard (A D J K 5 1),
-- in "tas" mode from the held keys. What is set when frame n has finished is what the game reads in frame n+1,
-- the same path in both modes, so a record replays exactly.
local P = manager.machine.ioport.ports
local F = { L = P[":P1"].fields["P1 Left"], R = P[":P1"].fields["P1 Right"],
            J = P[":P1"].fields["P1 Button 1"], K = P[":P1"].fields["P1 Button 2"],
            C = P[":SYSTEM"].fields["Coin 1"], S = P[":SYSTEM"].fields["1 Player Start"] }
local ORDER = { "L", "R", "J", "K", "C", "S" }
local input = manager.machine.input
local KB = { L = input:code_from_token("KEYCODE_A"), R = input:code_from_token("KEYCODE_D"),
             J = input:code_from_token("KEYCODE_J"), K = input:code_from_token("KEYCODE_K"),
             C = input:code_from_token("KEYCODE_5"), S = input:code_from_token("KEYCODE_1") }
local frame, seen, hold, target, tas, last, msg = 0, -1, "-", nil, false, nil, "ready"
local rec, recBase = {}, 0          -- rec[f] = keys for frame f; recBase > 0 = the record starts at a loaded state
local play, playEnd = nil, 0        -- record being played back from power-on
local repause = false
local tapFrame, tapKey = nil, ""   -- "tap": a key pressed for exactly one frame (user 11-06: "1번만 입력되도록")
-- undo (11-06, user: "1,10,60 프레임 버튼을 누르는 순간 저장하고 최대 10번까지 뒤로"): every step / tap saves the state
-- it starts from (states u0..u9, reused in turn); "back" loads the newest and drops it
local undo, undoN = {}, 0
-- autosave (11-06, user: "60 프레임당 자동 저장" -> "넣어줘"): while the game runs, every 60th frame is saved (a0..a29,
-- reused in turn, newest last); "rewind" loads the newest one before the current frame (one second back each press)
local autos, autoN, AUTO_EVERY, AUTO_KEEP = {}, 0, 180, 30   -- every 3 s (1 s hitched: user 11-06 "1초는 너무 끊기는데")
local autoPending = false
local autoOn = false              -- off by default, the page turns it on (user 11-06: hitches, so a switch)
local autoplay = false            -- resume right after a load (the editor's replay from a slot)
HASH = nil       -- set to {} to log a RAM hash per frame (replay check, 11-06)
local slotRec = {}                  -- slot name -> {rec = record up to its frame, base = recBase} (saved in this session)
local function copy(t) local c = {}; for k, v in pairs(t) do c[k] = v end; return c end
local loading = nil

local function keyboard()
  local s = ""
  for _, k in ipairs(ORDER) do if input:code_pressed(KB[k]) then s = s .. k end end
  return s == "" and "-" or s
end
-- decide and set the input of frame f (called when frame f-1 has finished), and record it
local function decide(f)
  local k
  if play and f <= playEnd then k = play[f] or "-"
  elseif tas then k = hold
  else k = keyboard() end
  if tapFrame == f and not (play and f <= playEnd) then k = (k == "-" and "" or k) .. tapKey end
  for key, field in pairs(F) do field:set_value(k:find(key, 1, true) and 1 or 0) end
  rec[f] = k
  return k
end
local function cut(f)               -- forget the record after frame f
  for i, _ in pairs(rec) do if i > f then rec[i] = nil end end
end
local function out()
  local fh = io.open("tas/out", "w"); if not fh then return end
  local mode = (play and frame < playEnd) and "play" or (tas and "tas" or "free")
  fh:write(string.format("%d %s %s %s %s %d %d %s %d %d", frame, manager.machine.paused and "paused" or "running", mode, hold, msg, recBase, playEnd, last or "0", #undo, #autos))
  fh:close()
end

-- Timing (found 11-06 when a replay drifted by one frame): in each MAME video update the Lua periodic hook runs
-- BEFORE MAME polls the inputs (ioport's frame notifier), and frame notifiers run after it. So the input of frame f+1
-- is set here, in the periodic hook, as soon as frame f is seen: MAME polls it at the end of frame f, the game reads it
-- in frame f+1, whether the machine runs on, is stepped from a pause, or is resumed by a save. Frames are the screen's
-- own emulated frame number (it also comes back with a loaded state).
local screen = manager.machine.screens[":screen"]
local function newFrame()
  local f = screen:frame_number()
  if f == seen then return end
  frame, seen = f, f
  if HASH then local sp = manager.machine.devices[":maincpu"].spaces["program"]; local h = 0
     for a = 0xC000, 0xCFFF, 1 do h = (h * 31 + sp:read_u8(a)) % 2147483647 end; HASH[frame] = h end
  if play and frame == playEnd then emu.pause(); msg = "playdone"; tas = true; hold = "-" end
  if target and frame >= target then target = nil; emu.pause() end
  if autoOn and frame % AUTO_EVERY == 0 and not manager.machine.paused then autoPending = true end
  decide(frame + 1)
end
-- machine:save() resumes the machine (MAME clears timers first): pause again right at the save
_tas_save = emu.add_machine_pre_save_notifier(function() if repause then repause = false; emu.pause() end end)
_tas_load = emu.add_machine_post_load_notifier(function()
  frame = screen:frame_number(); seen = frame; target = nil; emu.pause()
  -- the record becomes the slot's own way from power-on (saved here), or starts at the state (a slot from a file)
  local sr = loading and slotRec[loading]
  if sr then rec = copy(sr.rec); recBase = sr.base else rec = {}; recBase = frame end
  loading = nil
  cut(frame); decide(frame + 1)
  if autoplay then autoplay = false; emu.unpause() end
end)

-- a record to play back: tas/play.txt, lines "KEYS COUNT" from frame 1; read at boot (played from power-on) and by
-- "playfrom" (the editor, 11-06: played from the latest slot of this session whose own record is the same up to it)
local function readPlay()
  local fh = io.open("tas/play.txt", "r"); if not fh then return false end
  play = {}; local f = 0
  for line in fh:lines() do
    local k, n = line:match("^(%S+)%s+(%d+)")
    if k then for _ = 1, tonumber(n) do f = f + 1; play[f] = k end end
  end
  fh:close(); playEnd = f; return true
end
if readPlay() then msg = "play" end

local function dump()
  local fh = io.open("tas/movie.txt", "w"); if not fh then return end
  local cur, n = nil, 0
  for i = recBase + 1, frame do
    local k = rec[i] or "-"
    if k == cur then n = n + 1 else
      if cur then fh:write(cur, " ", n, "\n") end
      cur, n = k, 1
    end
  end
  if cur then fh:write(cur, " ", n, "\n") end
  fh:close()
end

local function pushUndo()
  local name = "u" .. (undoN % 10); undoN = undoN + 1
  cut(frame); slotRec[name] = { rec = copy(rec), base = recBase, frame = frame }; decide(frame + 1)
  for i = #undo, 1, -1 do if undo[i] == name then table.remove(undo, i) end end
  table.insert(undo, name); if #undo > 10 then table.remove(undo, 1) end
  manager.machine:save("tas_" .. name)           -- done before the step runs (start of the next timeslice)
end

local function autoSave()
  local name = "a" .. (autoN % AUTO_KEEP); autoN = autoN + 1
  for i = #autos, 1, -1 do if autos[i] == name then table.remove(autos, i) end end
  local r = copy(rec); r[frame + 1] = nil
  slotRec[name] = { rec = r, base = recBase, frame = frame }
  table.insert(autos, name)
  manager.machine:save("tas_" .. name)
end
-- after a load: autosaves later than the loaded frame are a future that no longer happens; a slot / file / editor load
-- may come from another path, so it clears them all
local function dropAutos(f)
  for i = #autos, 1, -1 do local sr = slotRec[autos[i]]; if (not f) or (not sr) or sr.frame > f then table.remove(autos, i) end end
end
emu.register_periodic(function()
  newFrame()
  if autoPending then autoPending = false; if not manager.machine.paused then autoSave() end end
  local fh = io.open("tas/cmd", "r")
  if fh then
    local line = fh:read("*l") or ""; fh:close()
    local seq, op, a, b = line:match("^(%S+)%s+(%S+)%s*(%S*)%s*(%S*)")
    if seq and seq ~= last then
      last = seq; msg = op
      if op == "pause" then emu.pause()
      elseif op == "run" then target = nil; emu.unpause()
      elseif op == "step" then pushUndo(); tas = true; hold = (b ~= "" and b) or hold; decide(frame + 1); target = frame + (tonumber(a) or 1); emu.unpause()
      elseif op == "tap" then pushUndo(); tas = true; tapFrame = frame + 1; tapKey = a; decide(frame + 1); target = frame + 1; emu.unpause()
      elseif op == "hold" then tas = true; hold = (a ~= "" and a) or "-"; decide(frame + 1)
      elseif op == "free" then tas = false; hold = "-"; play = nil; playEnd = 0; decide(frame + 1)
      elseif op == "save" then repause = manager.machine.paused; cut(frame); slotRec[a] = { rec = copy(rec), base = recBase, frame = frame }; decide(frame + 1); manager.machine:save("tas_" .. a)
      elseif op == "load" or op == "upload" then
        if op == "upload" then slotRec[a] = nil end    -- the page wrote sta/wboy/tas_<a>.sta from a file
        local probe = io.open("sta/wboy/tas_" .. a .. ".sta", "r")
        if probe then probe:close(); dropAutos(nil); play = nil; playEnd = 0; loading = a; manager.machine:load("tas_" .. a); target = nil; msg = "load"
        else msg = "empty" end
      elseif op == "dumph" and HASH then local fh2 = io.open("tas/hash.txt", "w"); for i = 1, frame do fh2:write(i, " ", HASH[i] or "?", " ", rec[i] or "?", "\n") end; fh2:close(); msg = "dumpedh"
      elseif op == "rewind" then
        local name = nil
        for i = #autos, 1, -1 do local sr = slotRec[autos[i]]; if sr and sr.frame < frame then name = autos[i]; break end end
        if not name then msg = "norewind"
        else dropAutos(slotRec[name].frame)            -- the later ones are an abandoned future; this one stays (next press: one more back)
          play = nil; playEnd = 0; hold = "-"; loading = name; manager.machine:load("tas_" .. name); target = nil; msg = "rewind" end
      elseif op == "back" then   -- held keys are cleared too (user 11-06: "전상태로 돌리면 키도 지워져야")
        if #undo == 0 then msg = "noundo"
        else local name = table.remove(undo); dropAutos(slotRec[name] and slotRec[name].frame); play = nil; playEnd = 0; hold = "-"; loading = name; manager.machine:load("tas_" .. name); target = nil; msg = "back" end
      elseif op == "playfrom" then
        readPlay()
        local best, bf = nil, -1
        for name, sr in pairs(slotRec) do
          if sr.base == 0 and sr.frame < playEnd and sr.frame > bf then
            local same = true
            for i = 1, sr.frame do if (sr.rec[i] or "-") ~= (play[i] or "-") then same = false; break end end
            if same then best, bf = name, sr.frame end
          end
        end
        if best then dropAutos(nil); loading = best; autoplay = true; manager.machine:load("tas_" .. best); target = nil; msg = "playfrom"
        else play = nil; playEnd = 0; msg = "noslot" end
      -- slots kept in the browser (11-06, user: "슬롯도 부라우저에 저장해두고"): the page stores the state file plus the
      -- slot's own input record ("slotrec" writes it), and hands both back after a reload ("restore")
      elseif op == "slotrec" then
        local sr = slotRec[a]; local fh2 = io.open("tas/slotrec.txt", "w")
        if fh2 then
          if sr then
            fh2:write(sr.base, " ", sr.frame, "\n")
            local cur, n = nil, 0
            for i = sr.base + 1, sr.frame do local k = sr.rec[i] or "-"
              if k == cur then n = n + 1 else if cur then fh2:write(cur, " ", n, "\n") end; cur, n = k, 1 end end
            if cur then fh2:write(cur, " ", n, "\n") end
          else fh2:write("none\n") end
          fh2:close()
        end
        msg = "slotrec"
      elseif op == "restore" then
        local fh2 = io.open("tas/slotrec_" .. a .. ".txt", "r")
        if fh2 then
          local base, fr = (fh2:read("*l") or ""):match("^(%d+)%s+(%d+)")
          if base then
            local r, f = {}, tonumber(base)
            for line in fh2:lines() do local k, n = line:match("^(%S+)%s+(%d+)"); if k then for _ = 1, tonumber(n) do f = f + 1; r[f] = k end end end
            slotRec[a] = { rec = r, base = tonumber(base), frame = tonumber(fr) }
          end
          fh2:close()
        end
        msg = "restored"
      elseif op == "autosave" then autoOn = (a == "1")
      elseif op == "mute" then manager.machine.sound.system_mute = (a == "1")   -- sound on/off (11-06), no effect on the game
      elseif op == "dump" then dump(); msg = "dumped"
      end
    end
  end
  out()
end)

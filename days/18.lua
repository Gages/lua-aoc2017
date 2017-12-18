local common = require "common"

local function read_instructions(input)
  local acc = {}
  for _, v in ipairs(common.lines(input)) do
    local instr, arg1, arg2 = string.match(v, "(%w+) (%w+) (%-?%w+)")
    if not instr then
      instr, arg1 = string.match(v, "(%w+) (%w+)")
    end
    assert(instr)
    assert(arg1)
    table.insert(acc, {instr, arg1, arg2})
  end
  return acc
end

local mac = {}; mac.__index = mac;
function mac:write(reg, val) self.registers[reg] = val end
function mac:read(reg) return self.registers[reg] or 0 end
function mac:advance(n) self.pc = self.pc + (n or 1) end
function mac.new() return setmetatable({registers = {}, pc = 1}, mac) end

local instr1 = {}
function instr1.set(mac, reg, val)
  mac:write(reg, tonumber(val) or mac:read(val))
  mac:advance()
end
function instr1.snd(mac, reg)
  mac:write("snd", mac:read(reg))
  mac:advance()
end
function instr1.rcv(mac, reg)
  if mac:read(reg) ~= 0 then
    coroutine.yield("rcv", mac:read "snd")
  end
  mac:advance()
end
function instr1.add(mac, reg, val)
  mac:write(reg, mac:read(reg) + (tonumber(val) or mac:read(val)))
  mac:advance()
end
function instr1.mul(mac, reg, val)
  mac:write(reg, mac:read(reg) * (tonumber(val) or mac:read(val)))
  mac:advance()
end
function instr1.mod(mac, reg, val)
  mac:write(reg, mac:read(reg) % (tonumber(val) or mac:read(val)))
  mac:advance()
end
function instr1.jgz(mac, reg, val)
  if (tonumber(reg) or mac:read(reg)) > 0 then
    mac:advance(tonumber(val) or mac:read(val))
  else
    mac:advance()
  end
end

local instr2 = setmetatable({}, {__index = instr1})
function instr2.snd(mac, reg)
  coroutine.yield("snd", mac:read(reg))
  mac:advance()
end
function instr2.rcv(mac, reg)
  mac:write(reg, coroutine.yield "rcv")
  mac:advance()
end

local function start_machine(code, instr, id)
  local mac = mac.new()
  mac:write("p", id)
  return coroutine.wrap(function()
    while mac.pc >= 1 and mac.pc <= #code do
      local dis = code[mac.pc]
      instr[dis[1]](mac, dis[2], dis[3])
    end
  end)
end

function day18_part1(input)
  local acc = read_instructions(input)
  for effect, val in start_machine(acc, instr1) do
    if effect == "rcv" then
      return val
    end
  end
end

function day18_part2(input)
  local acc = read_instructions(input)
  local m1 = start_machine(acc, instr2, 0)
  local m2 = start_machine(acc, instr2, 1)
  local q1, q2 = {"void"}, {"void"}
  local current_machine, other_machine = m1, m2
  local input, output = q1, q2
  local ct, co = 0, 0
  repeat
    if #input > 0 then
      local effect, val = current_machine(table.remove(input, 1))
      if effect == "snd" then
        table.insert(output, val)
        table.insert(input, 1, "void")
        ct = ct + 1
      end
    end
    current_machine, other_machine = other_machine, current_machine
    input, output = output, input
    ct, co = co, ct
  until #q1 == 0 and #q2 == 0
  
  return input == q2 and ct or co
end

--[[
  Tests Part 1
]]
assert(day18_part1 [[
set c 1
snd c
rcv a
rcv b
rcv c
rcv d 
]] == 1)

--[[
  Tests Part 2
]]
assert(day18_part2 [[
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d  
]] == 3)

--Answers
local puzzle_input = common.puzzle_input (18)
print("Day 18, Part 1: ", day18_part1(puzzle_input)) --7071
print("Day 18, Part 2: ", day18_part2(puzzle_input)) --8001
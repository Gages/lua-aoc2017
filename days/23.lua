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
function mac.new() return setmetatable({registers = {}, pc = 1, stats = {mul = 0}}, mac) end

local instr1 = {}
function instr1.set(mac, reg, val)
  mac:write(reg, tonumber(val) or mac:read(val))
  mac:advance()
end
function instr1.sub(mac, reg, val)
  mac:write(reg, mac:read(reg) - (tonumber(val) or mac:read(val)))
  mac:advance()
end
function instr1.mul(mac, reg, val)
  mac.stats.mul = mac.stats.mul + 1
  mac:write(reg, mac:read(reg) * (tonumber(val) or mac:read(val)))
  mac:advance()
end
function instr1.jnz(mac, reg, val)
  if (tonumber(reg) or mac:read(reg)) ~= 0 then
    mac:advance(tonumber(val) or mac:read(val))
  else
    mac:advance()
  end
end

local function start_machine(code, instr, id)
  local mac = mac.new()
  mac:write("p", id)
  return coroutine.wrap(function()
    while mac.pc >= 1 and mac.pc <= #code do
      local dis = code[mac.pc]
      instr[dis[1]](mac, dis[2], dis[3])
    end
  end), mac
end

function day23_part1(input)
  local acc = read_instructions(input)
  local co, mac = start_machine(acc, instr1)
  for effect, val in co do
  end
  return mac.stats.mul
end

local function is_prime(b)
  if b % 2 == 0 then return false end
  for i=3,math.floor(math.sqrt(b)),2 do
    if b % i == 0 then return false end
  end
  return true
end
local function day23_input_manual(start,stop,step)
  local h = 0
  for b=start,stop,step do
    if not is_prime(b) then
      h = h + 1
    end
  end
  return h
end

function day23_part2()
  --After analysing the input text,
  --I deduced that it was counting the number of composite (non-prime)
  --numbers within a certain set of integers, as defined by
  --a start, stop, and step number.
  local b = 81 * 100 + 100000
  local c = b + 17000
  local s = 17
  return day23_input_manual(b,c,s)
end

--[[
  Tests Part 1
]]
assert(day23_part1 [[
set a 1
mul a 100
]] == 1)

--[[
  Tests Part 2
]]
assert(day23_part2 "" == 909)

--Answers
local puzzle_input = common.puzzle_input (23)
print("Day 23, Part 1: ", day23_part1(puzzle_input)) --??
print("Day 23, Part 2: ", day23_part2(puzzle_input)) --909
local common = require "common"

local operations = {}
operations["=="] = function(reg, val) return reg == val end
operations["!="] = function(reg, val) return reg ~= val end
operations[">="] = function(reg, val) return reg >= val end
operations["<="] = function(reg, val) return reg <= val end
operations["<"] = function(reg, val) return reg < val end
operations[">"] = function(reg, val) return reg > val end
local directions = {}
directions["inc"] = function(reg, amount) return reg + amount end
directions["dec"] = function(reg, amount) return reg - amount end

local function parse_instr(v)
  local v = common.list(v)
  if #v == 7 then
    --b inc 5 if a > 1
    return {v[1], v[2], tonumber(v[3]), v[5], v[6], tonumber(v[7])}
  end
end

function run(input)
  local lines = common.lines(input)
  local alltimemax
  local registers = {}
  for _, v in ipairs(lines) do
    local instr = parse_instr(v)
    if instr then
      local reg, dir, amount, condreg, op, condval = unpack(instr)
      local fop = operations[op]
      local fdir = directions[dir]
      registers[condreg] = registers[condreg] or 0
      registers[reg] = registers[reg] or 0
      if fop(registers[condreg], condval) then
        registers[reg] = fdir(registers[reg], amount)
        alltimemax = math.max(alltimemax or registers[reg], registers[reg])
      end
    end
  end
  return common.max(common.values(registers)), alltimemax
end

function day8_part1(input)
  local max, alltimemax = run(input)
  return max
end

function day8_part2(input)
  local max, alltimemax = run(input)
  return alltimemax
end

--[[
  Tests Part 1
]]
assert(day8_part1 [[
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10]] == 1)

--[[
  Tests Part 2
]]
assert(day8_part2 [[
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10]] == 10)

--Answers
local puzzle_input = common.puzzle_input (8)
print("Day 8, Part 1: ", day8_part1(puzzle_input)) --??
print("Day 8, Part 2: ", day8_part2(puzzle_input)) --??
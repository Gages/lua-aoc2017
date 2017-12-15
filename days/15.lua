local common = require "common"

local function parse_input(input)
  local a = string.match(input, "Generator A starts with (%d+)")
  local b = string.match(input, "Generator B starts with (%d+)")
  return tonumber(a), tonumber(b)
end
local function build_generator(factor, seed, divisor)
  local divisor = divisor or 1
  return coroutine.wrap(function()
      while true do
        local n = (seed * factor % 2147483647)
        if n % divisor == 0 then
          coroutine.yield(n % 0x10000)
        end
        seed = n
      end
  end)
end
function day15_part1(input)
  local seeda, seedb = parse_input(input)
  local gena = build_generator(16807, seeda)
  local genb = build_generator(48271, seedb)
  local count = 0
  for i=1,40000000 do
    local a, b = gena(), genb()
    if a == b then
      count = count + 1
    end
  end
  return count
end

function day15_part2(input)
    local seeda, seedb = parse_input(input)
  local gena = build_generator(16807, seeda, 4)
  local genb = build_generator(48271, seedb, 8)
  local count = 0
  for i=1,5000000 do
    local a, b = gena(), genb()
    if a == b then
      count = count + 1
    end
  end
  return count
end

--[[
  Tests Part 1
]]
assert(day15_part1 [[
Generator A starts with 65
Generator B starts with 8921  
]] == 588)

--[[
  Tests Part 2
]]
assert(day15_part2 [[
Generator A starts with 65
Generator B starts with 8921  
]] == 309)

--Answers
local puzzle_input = common.puzzle_input (15)
print("Day 15, Part 1: ", day15_part1(puzzle_input)) --577
print("Day 15, Part 2: ", day15_part2(puzzle_input)) --316
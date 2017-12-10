local common = require "common"
 
local function simulate(offsets)
  local index, count = 1, 0
  while index >= 1 and index <= #offsets do
    local target = offsets[index] + index
    offsets[index] = offsets[index] + 1
    index = target
    count = count + 1
  end
  return count
end

local function simulate_2(offsets)
  local index, count = 1, 0
  while index >= 1 and index <= #offsets do
    local target = offsets[index] + index
    if offsets[index] >= 3 then
      offsets[index] = offsets[index] - 1
    else
      offsets[index] = offsets[index] + 1
    end
    index = target
    count = count + 1
  end
  return count
end
 

function day5_part1(input)
  local offsets = common.map(tonumber, common.list(input))
  return simulate(offsets)
end

function day5_part2(input)
   local offsets = common.map(tonumber, common.list(input))
  return simulate_2(offsets) 
end

assert(day5_part1 [[0 3 0 1 -3]] == 5)
assert(day5_part2 [[0 3 0 1 -3]] == 10)

--Answers
local puzzle_input = common.puzzle_input (5)
print("Day 5, Part 1: ", day5_part1(puzzle_input)) --381680
print("Day 5, Part 2: ", day5_part2(puzzle_input)) --29717847
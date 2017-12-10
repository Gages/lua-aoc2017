local common = require "common"

local function find_max_bank(banks)
  local index = 1
  local max = banks[1]
  for i=2,#banks do
    if banks[i] > max then
      max = banks[i]
      index = i
    end
  end
  return index, max
end
local function cycle(banks)
  local index, max = find_max_bank(banks)
  banks[index] = 0
  for i=1,max do
    index = (index % #banks) + 1
    banks[index] = banks[index] + 1
  end
end
local function run(input)
  local banks = common.map(tonumber, common.list(input))
  local store = {}
  local count = 0
  while true do
    local k = table.concat(banks)
    if store[k] then
      return count, store[k]
    else
      store[k] = count
    end
    cycle(banks)
    count = count + 1
  end
end

function day6_part1(input)
  local count_repeat, count_found = run(input)
  return count_repeat
end

function day6_part2(input)
  local count_repeat, count_found = run(input)
  return count_repeat - count_found
end

--[[
  Tests Part 1
]]
assert(day6_part1 "0 2 7 0" == 5)

--[[
  Tests Part 2
]]
assert(day6_part2 "0 2 7 0" == 4)

--Answers
local puzzle_input = common.puzzle_input (6)
print("Day 6, Part 1: ", day6_part1(puzzle_input)) --7864
print("Day 6, Part 2: ", day6_part2(puzzle_input)) --1695
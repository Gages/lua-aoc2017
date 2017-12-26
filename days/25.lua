local common = require "common"

local pattern = [[
In state (%u)%:
  If the current value is 0%:
    %- Write the value (%d)%.
    %- Move one slot to the (%l+)%.
    %- Continue with state (%u)%.
  If the current value is 1%:
    %- Write the value (%d)%.
    %- Move one slot to the (%l+)%.
    %- Continue with state (%u)%.]]

local function parse_input(input)
  local s = {}
  for state, write0, move0, state0, write1, move1, state1 in string.gmatch(input, pattern) do
    move0 = (move0 == "left") and -1 or 1
    move1 = (move1 == "left") and -1 or 1
    write0 = tonumber(write0)
    write1 = tonumber(write1)
    s[state] = {
        [0] = {write = write0, move = move0, state = state0},
        [1] = {write = write1, move = move1, state = state1},
    }
  end
  local start = string.match(input, "Begin in state (%u)%.")
  local checksum = string.match(input, "Perform a diagnostic checksum after (%d+) steps%.")
  return s, start, tonumber(checksum)
end

local function new_turing(states, current, memory)
  local pos = 0
  local function step()
    local s = states[current][memory[pos] or 0]
    memory[pos] = s.write
    pos = pos + s.move
    current = s.state
  end
  return step
end

function day25_part1(input)
  local states, start, checksum = parse_input(input)
  local memory = {}
  local mac = new_turing(states, start, memory)
  for i=1,checksum do
    mac()
  end
  local count = 0
  for _, v in pairs(memory) do
    count = count + v
  end
  return count
end

function day25_part2(input)
  return "Merry Christmas!"
end

--Answers
local puzzle_input = common.puzzle_input (25)
print("Day 25, Part 1: ", day25_part1(puzzle_input)) --4387
print("Day 25, Part 2: ", day25_part2(puzzle_input)) --Advent of Code 2017 Completed!
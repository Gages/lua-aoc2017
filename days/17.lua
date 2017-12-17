local common = require "common"

local wrap = common.wrap

function day17_helper(input, count, mode)
  local n = tonumber(input)
  local buffer = {0}
  local value_after_zero = nil
  local buffer_len = 1
  local pos = 1
  for i=1,count do
    pos = wrap(pos, n + 1, buffer_len)
    --if the position to insert is one to the right of the zero,
    --record it as the new value_after_zero before doing the insert
    --insight: zero is always the last item in the buffer (thanks reddit)
    --therefore one to the right of zero is always 1.
    if pos == 1 then
      value_after_zero = i
    end
    if mode == "part1" then
      table.insert(buffer, pos, i)
    end
    buffer_len = buffer_len + 1
  end
  if mode == "part1" then
    return buffer[wrap(pos, 1, buffer_len)], value_after_zero
  else
    return value_after_zero
  end
end

function day17_part1(input)
  local r = day17_helper(tonumber(input), 2017, "part1")
  return r
end

function day17_part2(input)
  return day17_helper(tonumber(input), 50000000, "part2")
end

--[[
  Tests Part 1
]]
assert(day17_part1 "3" == 638)

--[[
  Tests Part 2
]]
assert(select(2, day17_helper(3, 2017, "part1")) == 1226)
assert(select(1, day17_helper(3, 2017, "part2")) == 1226)

--Answers
local puzzle_input = "366"
print("Day 17, Part 1: ", day17_part1(puzzle_input)) --1025
print("Day 17, Part 2: ", day17_part2(puzzle_input)) --37803463
local common = require "common"

local function run(input)
  local score = 0
  local total = 0
  local removed = 0
  local pos = 0
  local read = function()
    pos = pos + 1
    if pos <= #input then
      return string.sub(input, pos, pos)
    end
  end
  local start_group, start_garbage
  function start_group()
    local c = read()
    if c == "{" then score = score + 1; return start_group() end
    if c == "}" then total = total + score; score = score - 1; return start_group() end
    if c == "," then return start_group() end
    if c == "<" then return start_garbage() end
    assert(not c)
    return total, removed
  end
  function start_garbage()
    local c = read()
    assert(c)
    if c == ">" then return start_group() end
    if c == "!" then read(); return start_garbage() end
    removed = removed + 1
    return start_garbage()    
  end
  return start_group()
end

function day9_part1(input)
  local d, c = run(input)
  return d
end

function day9_part2(input)
  local d, c = run(input)
  return c
end

--[[
Your goal is to find the total score for all groups in your input. Each group is assigned a score which is one more than the score of the group that immediately contains it. (The outermost group gets a score of 1.)

    {}, score of 1.
    {{{}}}, score of 1 + 2 + 3 = 6.
    {{},{}}, score of 1 + 2 + 2 = 5.
    {{{},{},{{}}}}, score of 1 + 2 + 3 + 3 + 3 + 4 = 16.
    {<a>,<a>,<a>,<a>}, score of 1.
    {{<ab>},{<ab>},{<ab>},{<ab>}}, score of 1 + 2 + 2 + 2 + 2 = 9.
    {{<!!>},{<!!>},{<!!>},{<!!>}}, score of 1 + 2 + 2 + 2 + 2 = 9.
    {{<a!>},{<a!>},{<a!>},{<ab>}}, score of 1 + 2 = 3.
]]
assert(day9_part1 "{}" == 1)
assert(day9_part1 "{{{}}}" == 6)
assert(day9_part1 "{{},{}}" == 5)
assert(day9_part1 "{{{},{},{{}}}}" == 16)
assert(day9_part1 "{<a>,<a>,<a>,<a>}" == 1)
assert(day9_part1 "{{<ab>},{<ab>},{<ab>},{<ab>}}" == 9)
assert(day9_part1 "{{<!!>},{<!!>},{<!!>},{<!!>}}" == 9)
assert(day9_part1 "{{<a!>},{<a!>},{<a!>},{<ab>}}" == 3)
--[[
Now, you're ready to remove the garbage.

To prove you've removed it, you need to count all of the characters within the garbage. The leading and trailing < and > don't count, nor do any canceled characters or the ! doing the canceling.

    <>, 0 characters.
    <random characters>, 17 characters.
    <<<<>, 3 characters.
    <{!>}>, 2 characters.
    <!!>, 0 characters.
    <!!!>>, 0 characters.
    <{o"i!a,<{i<a>, 10 characters.

]]
assert(day9_part2 "{<>}" == 0)
assert(day9_part2 "{<random characters>}" == 17)
assert(day9_part2 "{<<<<>}" == 3)
assert(day9_part2 "{<{!>}>}" == 2)
assert(day9_part2 "{<!!>}" == 0)
assert(day9_part2 "{<!!!>>}" == 0)
assert(day9_part2 "{<{o\"i!a,<{i<a>}" == 10)

--Answers
local puzzle_input = common.puzzle_input (9)
print("Day 9, Part 1: ", day9_part1(puzzle_input)) --15922
print("Day 9, Part 2: ", day9_part2(puzzle_input)) --??
local common = require "common"

--To solve this puzzle I used memoisation techniques
--to make it easier to reason about the problem
--in terms of infinite sequences,
--and still get reasonable performance
--when using function semantics to look up the nth item in the sequence.

local direction_at = common.sequence_memo(coroutine.wrap(function()
    local letters = {"R", "U", "L", "D"}
    local index = 0
    local count = 0
    local length
    while true do
      count = count + 1
      length = math.ceil(count / 2)
      for i=1,length do
        coroutine.yield(letters[index+1])
      end
      index = (index + 1) % #letters
    end
  end))

local position_at = common.compose(common.sequence_memo(coroutine.wrap(function()
  local x, y = 0, 0
  local i = 1
  while true do
    coroutine.yield{x, y}
    local direction = direction_at(i)
    if direction == "L" then x = x + 1 end
    if direction == "R" then x = x - 1 end
    if direction == "U" then y = y + 1 end
    if direction == "D" then y = y - 1 end
    i = i + 1
  end
end)), unpack)

function day3_part1(input)
  local n = tonumber(input)
  local x, y = position_at(n)
  return math.abs(x) + math.abs(y)
end

local day3_part2 = common.compose(tonumber, common.sequence_memo(
  coroutine.wrap(function()
    local store = {}
    local function name(x, y) return string.format("%d:%d",x,y) end
    store[name(position_at(1))] = 1
    coroutine.yield(1)
    local i = 2
    while true do
      local x, y = position_at(i)
      local v =
        (store[name(x + 1, y)] or 0) + --right
        (store[name(x + 1, y + 1)] or 0) + --top right
        (store[name(x + 1, y - 1)] or 0) + --bottom right
        (store[name(x, y + 1)] or 0) + --top
        (store[name(x, y - 1)] or 0) + --bottom
        (store[name(x - 1, y)] or 0) + --left
        (store[name(x - 1, y + 1)] or 0) + --top left
        (store[name(x - 1, y - 1)] or 0) --bottom 
      store[name(x, y)] = v
      coroutine.yield(v)
      i = i + 1
    end
  end)
))

assert(day3_part1 "1" == 0)
assert(day3_part1 "12" == 3)
assert(day3_part1 "23" == 2)
assert(day3_part1 "1024" == 31)

assert(day3_part2 "1" == 1)
assert(day3_part2 "2" == 1)
assert(day3_part2 "3" == 2)
assert(day3_part2 "4" == 4)
assert(day3_part2 "5" == 5)
assert(day3_part2 "6" == 10)

local puzzle_input = [[347991]]

print(day3_part1(puzzle_input)) --480

local i = 1
local day3_part2_answer
repeat
  day3_part2_answer = day3_part2(tostring(i))
  i = i + 1
until day3_part2_answer > tonumber(puzzle_input)

print(day3_part2_answer) --349975
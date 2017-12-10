local lib = require "common"

function day1_part1(input)
  --input is a string of digits.
  --for each index i = 0 to len(input) - 1
  local sum = 0
  for i=0, #input-1 do
    local a = tonumber(lib.at(input, i))
    local b = tonumber(lib.at(input, (i+1) % #input))
    if a == b then
      sum = sum + a
    end
  end
  return sum
end

assert(day1_part1 "1122" == 3)
assert(day1_part1 "1111" == 4)
assert(day1_part1 "1234" == 0)
assert(day1_part1 "91212129" == 9)


local puzzle_input = lib.puzzle_input(1)

--1216
print(day1_part1(puzzle_input))

function day1_part2(input)
  --input is a string of digits, of even length
  --for each index i = 0 to len(input) - 1
  local incr = #input / 2
  local sum = 0
  for i=0, #input-1 do
    local a = tonumber(lib.at(input, i))
    local b = tonumber(lib.at(input, (i+incr) % #input))
    if a == b then
      sum = sum + a
    end
  end
  return sum
end

--[[
  1212 produces 6: the list contains 4 items, and all four digits match the digit 2 items ahead.
  1221 produces 0, because every comparison is between a 1 and a 2.
  123425 produces 4, because both 2s match each other, but no other digit has a match.
  123123 produces 12.
  12131415 produces 4.
]]
assert(day1_part2 "1212" == 6)
assert(day1_part2 "1221" == 0)
assert(day1_part2 "123425" == 4)
assert(day1_part2 "123123" == 12)
assert(day1_part2 "12131415" == 4)

--1072
print(day1_part2(puzzle_input))

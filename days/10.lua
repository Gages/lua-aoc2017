local common = require "common"

local function circular_reverse(list, pos, length)
  for i=0,math.floor(length/2)-1 do
    local p1 = (pos + i) % #list
    local p2 = (pos + length - 1 - i) % #list
    if p1 ~= p2 then
      list[p1+1], list[p2+1] = list[p2+1], list[p1+1]
    end
  end
end
local function elfhash(list, lengths, pos, skip)
  local pos = pos or 0
  local skip = skip or 0
  for _, length in ipairs(lengths) do
    circular_reverse(list, pos, length)
    pos = (pos + length + skip) % #list
    skip = skip + 1
  end
  return pos, skip
end

function day10_part1(lengths, n)
  local list = common.range(n)
  lengths = common.map(tonumber, common.split(lengths, ",", true))
  elfhash(list, lengths)
  return list[1] * list[2]
end

function day10_part2(input)
  local list = common.range(256)
  local codes = common.bytes(input)
  common.append(codes, {17, 31, 73, 47, 23})
  local pos, skip
  for i=1,64 do
    pos, skip = elfhash(list, codes, pos, skip)
  end
  local dense = common.rep(0, 16)
  for i=0,15 do
    for v=0,15 do
      dense[i+1] = common.bit.bxor(dense[i+1], list[i * 16 + v + 1])
    end
  end
  return table.concat(common.map(function(v) return string.format("%02x", v) end, dense), "")
end

--[[
  Tests Part 1
]]
assert(day10_part1("3, 4, 1, 5",5) == 12)

--[[
Here are some example hashes:

    The empty string becomes a2582a3a0e66e6e86e3812dcb672a272.
    AoC 2017 becomes 33efeb34ea91902bb2f59c9920caa6cd.
    1,2,3 becomes 3efbe78a8d82f29979031a4aa0b16a9d.
    1,2,4 becomes 63960835bcdc130f0b66d7ff4f6a5a8e.
]]
assert(day10_part2 "" == "a2582a3a0e66e6e86e3812dcb672a272")
assert(day10_part2 "AoC 2017" == "33efeb34ea91902bb2f59c9920caa6cd")
assert(day10_part2 "1,2,3" == "3efbe78a8d82f29979031a4aa0b16a9d")
assert(day10_part2 "1,2,4" == "63960835bcdc130f0b66d7ff4f6a5a8e")

--Answers
local puzzle_input = common.puzzle_input (10)
print("Day 10, Part 1: ", day10_part1(puzzle_input, 256)) --3770
print("Day 10, Part 2: ", day10_part2(puzzle_input)) --a9d0e68649d0174c8756a59ba21d4dc6
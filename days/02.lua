local common = require "common"

function day2_part1(input)
  local sheet = common.grid(input)
  local sum = 0
  for i=1, #sheet do
    local row = common.map(tonumber, sheet[i])
    local min = common.min(row)
    local max = common.max(row)
    sum = sum + max - min
  end
  return sum
end

function day2_part2(input)
  local sheet = common.grid(input)
  local sum = 0
  for i=1, #sheet do
    local row = common.map(tonumber, sheet[i])
    for x=1, #row do
      for y=1, #row do
        if x ~= y and row[x] % row[y] == 0 then
          sum = sum + (row[x] / row[y])
        end
      end
    end
  end
  return sum
end

assert(day2_part1 [[
5 1 9 5
7 5 3
2 4 6 8
]] == 18)

assert(day2_part2 [[
5 9 2 8
9 4 7 3
3 8 6 5
]] == 9)

local puzzle_input = common.puzzle_input(2)

print(day2_part1(puzzle_input)) --42378
print(day2_part2(puzzle_input)) --246
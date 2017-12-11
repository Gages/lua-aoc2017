local common = require "common"

local directions = {}
directions.n  = {0,1,-1}
directions.ne = {1,0,-1}
directions.se = {1,-1,0}
directions.s  = {0,-1,1}
directions.sw = {-1,0,1}
directions.nw = {-1,1,0}

local function add(mut, dir)
  mut[1] = mut[1] + dir[1]
  mut[2] = mut[2] + dir[2]
  mut[3] = mut[3] + dir[3]
end

local function distance_origin(p)
  return (math.abs(p[1]) + math.abs(p[2]) + math.abs(p[3])) / 2
end

local function walk(steps)
  local p = {0,0,0}
  local max = 0
  for _, v in ipairs(steps) do
    add(p, directions[v])
    max = math.max(max, distance_origin(p))
  end
  return p, max
end

function day11_part1(input)
  local steps = common.split(input, ",", true)
  local p = walk(steps)
  return distance_origin(p)
end

function day11_part2(input)
  local steps = common.split(input, ",", true)
  local p, max = walk(steps)
  return max
end

--[[
You have the path the child process took. Starting where he started, you need to determine the fewest number of steps required to reach him. (A "step" means to move from the hex you are in to any adjacent hex.)

For example:

    ne,ne,ne is 3 steps away.
    ne,ne,sw,sw is 0 steps away (back where you started).
    ne,ne,s,s is 2 steps away (se,se).
    se,sw,se,sw,sw is 3 steps away (s,s,sw).
]]
assert(day11_part1 "ne,ne,ne" == 3)
assert(day11_part1 "ne,ne,sw,sw" == 0)
assert(day11_part1 "ne,ne,s,s" == 2)
assert(day11_part1 "se,sw,se,sw,sw" == 3)

--[[
  Tests Part 2
]]
assert(day11_part2 "ne,ne,ne" == 3)
assert(day11_part2 "ne,ne,sw,sw" == 2)
assert(day11_part2 "ne,ne,s,s" == 2)
assert(day11_part2 "se,sw,se,sw,sw" == 3)

--Answers
local puzzle_input = common.puzzle_input (11)
print("Day 11, Part 1: ", day11_part1(puzzle_input)) --722
print("Day 11, Part 2: ", day11_part2(puzzle_input)) --1551
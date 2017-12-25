local common = require "common"

local function pos_tostring(pos, _y)
  local x, y
  if type(pos) == "table" then
    x, y = pos.x, pos.y
  else
    x, y = pos, _y
  end
  return string.format("%d,%d", x, y)
end
local function pos_centre()
  return {x = 0, y = 0}
end
local del = {}
del.up    = {x =  0, y =  -1}
del.down  = {x =  0, y =  1}
del.right = {x =  1, y =  0}
del.left  = {x = -1, y =  0}
local function pos_forward(pos, dir)
  pos.x = pos.x + del[dir[1]].x
  pos.y = pos.y + del[dir[1]].y
end
local function grid_is_infected(grid, pos)
  return grid[pos_tostring(pos)]
end
local function mkdir(dir)
  return {dir}
end
local leftwhen = { left = "down", right = "up", up = "left", down = "right" }
local rightwhen = { left = "up", right = "down", up = "right", down = "left" }
local reversewhen = { left = "right", right = "left", up = "down", down = "up" }
  
local function dir_turn(dir, change)
  if change == "left" then
      dir[1] = leftwhen[dir[1]]
  elseif change == "right" then
      dir[1] = rightwhen[dir[1]]
  elseif change == "reverse" then
      dir[1] = reversewhen[dir[1]]
  else
    error "unknown direction"
  end
end
local function grid_toggle(grid, pos)
  if grid[pos_tostring(pos)] then
    grid[pos_tostring(pos)] = nil
    return "cleaned"
  else
    grid[pos_tostring(pos)] = true
    return "infected"
  end
end
local function grid_current(grid, pos)
  local posn = pos_tostring(pos)
  return grid[posn] or "clean", posn
end
local cycle = {clean = "weakened", weakened = "infected", infected = "flagged", flagged = "clean"}
local function grid_cycle(grid, pos)
  local current, posn = grid_current(grid, pos)
  grid[posn] = cycle[current]
  return grid[posn]
end

local function start_carrier1(grid)
  local pos = pos_centre()
  local dir = mkdir "up"
  return coroutine.wrap(function()
    while true do
      if grid_is_infected(grid, pos) then
        dir_turn(dir, "right")
      else
        dir_turn(dir, "left")
      end
      coroutine.yield(grid_toggle(grid, pos))
      pos_forward(pos, dir)
    end
  end)
end
local function start_carrier2(grid)
  local pos = pos_centre()
  local dir = mkdir "up"
  return coroutine.wrap(function()
    while true do
      local current = grid_current(grid, pos)
      if current == "clean" then
        dir_turn(dir, "left")
      elseif current == "weakened" then
        --
      elseif current == "infected" then
        dir_turn(dir, "right")
      elseif current == "flagged" then
        dir_turn(dir, "reverse")
      end
      coroutine.yield(grid_cycle(grid, pos))
      pos_forward(pos, dir)
    end
  end)
end
local function show_grid(grid, sizex, sizey)
  local sizey = sizey or sizex
  local offsetr = math.ceil(sizey / 2) + 1
  local offsetc = math.ceil(sizex / 2)
  local o = {}
  for r=1,sizey do
    o[r] = {}
    for c=1,sizex do
      local x, y = c - offsetc, r - offsetr
      o[r][c] = grid[pos_tostring(x,y)] and " #" or " ."
    end
  end
  return table.concat(common.map(table.concat, o), "\n")
end
local function build_grid(input)
  local g1 = common.map(common.chars, common.lines(input))
  local grid = {}
  local offsetr = math.ceil(#g1 / 2)
  local offsetc = math.ceil(#g1[1] / 2)
  for r=1,#g1 do
    for c=1,#g1[r] do
      if g1[r][c] == "#" then
        grid[pos_tostring(c - offsetc, r - offsetr)] = "infected"
      end
    end
  end
  return grid
end

function day22_helper(input, times, start_carrier)
  local grid = build_grid(input)
  local burst = start_carrier(grid)
  local count = 0
  for i=1,times do
    if burst() == "infected" then
      count = count + 1
    else
    end
  end
  return count  
end
function day22_part1_helper(input, times)
  return day22_helper(input, times, start_carrier1)
end
function  day22_part2_helper(input, times)
  return day22_helper(input, times, start_carrier2)
end

function day22_part1(input)
  return day22_part1_helper(input, 10000)
end

function day22_part2(input)
  return day22_part2_helper(input, 10000000)
end

--[[
  Tests Part 1
]]
assert(day22_part1_helper([[
..#
#..
...
]], 7) == 5)
assert(day22_part1_helper([[
..#
#..
...
]], 70) == 41)
assert(day22_part1_helper([[
..#
#..
...
]], 10000) == 5587)

--[[
  Tests Part 2
]]
assert(day22_part2_helper([[
..#
#..
...
]], 100) == 26)
assert(day22_part2_helper([[
..#
#..
...
]], 10000000) == 2511944)

--Answers
local puzzle_input = common.puzzle_input (22)
print("Day 22, Part 1: ", day22_part1(puzzle_input)) --5447
print("Day 22, Part 2: ", day22_part2(puzzle_input)) --??
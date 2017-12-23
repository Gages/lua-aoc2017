local common = require "common"

local function on_off(c)
  if c == "#" then return 1 else return 0 end
end

local function off_on(c)
  if c == 1 then return "#" else return "." end
end

local function parse_grid(input_line)
  local grid = common.map(common.chars, common.split(input_line, "/", true))
  return common.map(common.curry(common.map, on_off), grid)
end

local function parse_rule(input_line)
  local grid1, grid2 = string.match(input_line, "(%S+) %=%> (%S+)")
  assert(grid1, input_line)
  assert(grid2, input_line)
  return {from = parse_grid(grid1), to = parse_grid(grid2)}
end

local function grid_size(grid)
  return #grid
end

local function show_grid(grid)
  local acc = {}
  for r = 1,#grid do
    table.insert(acc, table.concat(common.map(off_on, grid[r])))
  end
  return table.concat(acc, "/")
end

local function count_on(grid)
  return common.sum(common.join(grid))
end

local function combine_cells(n, cells)
  local side = math.sqrt(#cells)
  local grid = {}
  for i=1,#cells do
    local rbase, cbase = math.floor((i - 1) / side), (i - 1) % side
    for r=1,n do
      local y = rbase * n + r
      grid[y] = grid[y] or {}
      for c=1,n do
        local x = cbase * n + c
        grid[y][x] = cells[i][r][c]
      end
    end
  end
  return grid
end

local function get_grid(grid, r, c)
  return grid[r] and grid[r][c]
end
local function split_grid_2x2(grid)
  local acc = {}
  for r=1, grid_size(grid), 2 do
    for c=1, grid_size(grid), 2 do
      local cell = {}
      cell[1] = {[1] = get_grid(grid, r,   c), [2] = get_grid(grid, r,   c+1)}
      cell[2] = {[1] = get_grid(grid, r+1, c), [2] = get_grid(grid, r+1, c+1)}
      table.insert(acc, cell)
    end
  end
  return acc
end
local function split_grid_3x3(grid)
  local acc = {}
  for r=1, grid_size(grid), 3 do
    for c=1, grid_size(grid), 3 do
      local cell = {}
      cell[1] = {[1] = get_grid(grid, r,   c), [2] = get_grid(grid, r,   c+1), [3] = get_grid(grid, r,   c+2)}
      cell[2] = {[1] = get_grid(grid, r+1, c), [2] = get_grid(grid, r+1, c+1), [3] = get_grid(grid, r+1, c+2)}
      cell[3] = {[1] = get_grid(grid, r+2, c), [2] = get_grid(grid, r+2, c+1), [3] = get_grid(grid, r+2, c+2)}
      table.insert(acc, cell)
    end
  end
  return acc
end
local function horizontal_flip(grid)
  local o = {}
  local size = grid_size(grid)
  for r=1,size do
    o[r] = {}
    for c=1,size do
      o[r][size - c + 1] = grid[r][c]
    end
  end
  return o
end
local function rotate_clockwise(grid)
  local o = {}
  local size = grid_size(grid)
  for r=1,size do
    for c=1,size do
      o[c] = o[c] or {}
      o[c][size - r + 1] = grid[r][c]
    end
  end
  return o
end
local function grid_match(a, b)
  local size = grid_size(a)
  for r=1,size do
    for c=1,size do
      if a[r][c] ~= b[r][c] then return false end
    end
  end
  return true
end
local function enhance(rules, size)
  local H, R = horizontal_flip, rotate_clockwise
  local elaborated = {}
  for _, v in ipairs(rules) do
    if grid_size(v.from) == size then
      table.insert(elaborated, {from = v.from, to = v.to}) --H0R0
      table.insert(elaborated, {from = R(v.from), to = v.to}) --H0R1
      table.insert(elaborated, {from = R(R(v.from)), to = v.to}) --H0R2
      table.insert(elaborated, {from = R(R(R(v.from))), to = v.to}) --H0R3
      table.insert(elaborated, {from = H(v.from), to = v.to}) --H1R0
      table.insert(elaborated, {from = R(H(v.from)), to = v.to}) --H1R1
      table.insert(elaborated, {from = R(R(H(v.from))), to = v.to}) --H1R2
      table.insert(elaborated, {from = R(R(R(H(v.from)))), to = v.to}) --H1R3
    end
  end
  return function(grid)
    for i, v in ipairs(elaborated) do
      if grid_size(v.from) == grid_size(grid) then
        if grid_match(v.from, grid) then
          return v.to
        end
      end
    end
    error "No grid match"
  end
end

function day21_part1_helper(input, iterations)
  local grid = parse_grid [[.#./..#/###]]
  local rules = common.map(parse_rule, common.lines(input))
  local enhance2x2, enhance3x3 = enhance(rules, 2), enhance(rules, 3)
  for i=1,iterations do
    if grid_size(grid) % 2 == 0 then
      grid = combine_cells(3, common.map(enhance2x2, split_grid_2x2(grid)))
    else
      assert(grid_size(grid) % 3 == 0)
      grid = combine_cells(4, common.map(enhance3x3, split_grid_3x3(grid)))
    end
  end
  return show_grid(grid)
end

function day21_part1(input)
  return count_on(parse_grid(day21_part1_helper(input, 5)))
end

function day21_part2(input)
  return count_on(parse_grid(day21_part1_helper(input, 18)))  
end

--[[
  Tests Part 1
]]
assert(count_on(parse_grid([[##.##./#..#../....../##.##./#..#../......]])) == 12)
assert(day21_part1_helper([[
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#  
]], 1) == [[#..#/..../..../#..#]])
assert(day21_part1_helper([[
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#  
]], 2) == [[##.##./#..#../....../##.##./#..#../......]])

--Answers
local puzzle_input = common.puzzle_input (21)
print("Day 21, Part 1: ", day21_part1(puzzle_input)) --208
print("Day 21, Part 2: ", day21_part2(puzzle_input)) --2480380
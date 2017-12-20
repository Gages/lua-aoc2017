local common = require "common"

local function read_grid(input)
  return common.map(common.chars, common.lines(input))
end

local function build_graph(grid)
  local graph = {}
  local names = {}
  local function address(r, c)
    return string.format("%d,%d",r,c)
  end
  local function add_link(label, from, to)
    if to then
      graph[from] = graph[from] or {}
      graph[from][label] = to
    end
  end
  local function not_empty(v)
    return v ~= " " and v
  end
  local function neighbour_cells(r, c)
    return  not_empty(grid[r][c]) --middle
    ,       not_empty(grid[r-1] and grid[r-1][c]) --top
    ,       not_empty(grid[r][c+1]) --right
    ,       not_empty(grid[r][c-1]) --left
    ,       not_empty(grid[r+1] and grid[r+1][c]) --bottom
  end
  local start
  for r=1,#grid do
    for c=1,#grid do
      local middle,top,right,left,bottom = neighbour_cells(r,c)
      if middle then
        local addr = address(r,c)
        names[addr] = middle
        if r == 1 then
          start = addr
        end
        if top then add_link("up", addr, address(r-1,c)) end
        if right then add_link("right", addr, address(r,c+1)) end
        if left then add_link("left", addr, address(r,c-1)) end
        if bottom then add_link("down", addr, address(r+1,c)) end
      end
    end
  end
  assert(start)
  return graph, names, start
end
local leftwhen = { left = "down", right = "up", up = "left", down = "right" }
local rightwhen = { left = "up", right = "down", up = "right", down = "left" }
local function walk(input)
  local grid = read_grid(input)
  local graph, names, start = build_graph(grid)
  --print(start)
  for k, v in pairs(names) do
   -- print(k, v)
  end
  local order = {}
  local steps = 0
  local current = start
  local direction = "down"
  while current do
    steps = steps + 1
    if names[current] and string.match(names[current], "%a") then
      table.insert(order, names[current])
      --print("visited", current, names[current], direction)
    end
    local node = graph[current]
    --print(unpack(common.keys(node)))
    if node[direction] then
      current = node[direction]
      direction = direction
    elseif node[leftwhen[direction]] then
      current = node[leftwhen[direction]]
      direction = leftwhen[direction]
    elseif node[rightwhen[direction]] then
      current = node[rightwhen[direction]]
      direction = rightwhen[direction]
    else
      return table.concat(order, ""), steps
    end
  end
end

function day19_part1(input)
  local order, count = walk(input)
  return order
end

function day19_part2(input)
  local order, count = walk(input)
  return count
end

--Answers
local puzzle_input = common.puzzle_input (19)
print("Day 19, Part 1: ", day19_part1(puzzle_input)) --PVBSCMEQHY
print("Day 19, Part 2: ", day19_part2(puzzle_input)) --17736
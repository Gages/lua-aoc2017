local common = require "common"

local function parse_input(input)
  local chips = common.map(function(line)
        return common.map(tonumber, common.split(line, "/", true))
  end, common.lines(input))
  return chips
end

local function build_graph(chips)
  local graph = {}
  for i, v in ipairs(chips) do
    local from, to = unpack(v)
    graph[from] = graph[from] or {}
    graph[from][to] = graph[from][to] or {}
    table.insert(graph[from][to], {i, from + to})
    if from ~= to then
      graph[to] = graph[to] or {}
      graph[to][from] = graph[to][from] or {}
      table.insert(graph[to][from], {i, from + to})
    end
  end
  return graph
end

local function search_graph(choice_func, graph, from, from_weight, consumed_edges)
  from = from or 0
  consumed_edges = consumed_edges or {}
  from_weight = from_weight or 0
  local best_path
  for to, edges in pairs(graph[from]) do
    --for each node c from start,
    --find the strongest sub-path from c
    --excluding any nodes in the already visited path
    for _, v in ipairs(edges) do
      local chipi, weight = unpack(v)
      if not consumed_edges[chipi] then
        --print("visiting", to, "from", from, "via", chipi)
        consumed_edges[chipi] = true
        local s = search_graph(choice_func, graph, to, weight, consumed_edges)
        consumed_edges[chipi] = nil
        if not best_path or choice_func(s, best_path) then
          best_path = s
        end
      end
    end
  end
  if not best_path then
    return {
      length = 0,
      total_weight = from_weight,
      first = from,
    }
  else
    return {
        length = 1 + best_path.length,
        total_weight = from_weight + best_path.total_weight,
        first = from,
        next = best_path,
    }
  end
end

local function choose_strongest(a, b)
  return a.total_weight > b.total_weight
end

local function choose_longest(a, b)
  return a.length > b.length or (a.length == b.length and choose_strongest(a, b))
end

function day24_part1(input)
  local chips = parse_input(input)
  local graph = build_graph(chips)
  local node = search_graph(choose_strongest, graph)
  return node.total_weight
end

function day24_part2(input)
  local chips = parse_input(input)
  local graph = build_graph(chips)
  local node = search_graph(choose_longest, graph)
  return node.total_weight 
end

--[[
  Tests Part 1
]]
assert(day24_part1 [[
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10  
]] == 31)
assert(day24_part1 [[
0/2
2/2
2/3
3/4
3/5 
]] == 19)

--[[
  Tests Part 2
]]
assert(day24_part2 [[
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10    
]] == 19)

--Answers
local puzzle_input = common.puzzle_input (24)
print("Day 24, Part 1: ", day24_part1(puzzle_input)) --1511
print("Day 24, Part 2: ", day24_part2(puzzle_input)) --1471
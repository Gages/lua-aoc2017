local common = require "common"

local function parse_line(line)
  local node, children = string.match(line, "(%d+) %<%-%> (.+)")
  return tonumber(node), common.map(tonumber, common.split(children, ",", true))
end

local function build_graph(input)
  local lines = common.lines(input)
  local graph = {}
  for _, v in ipairs(lines) do
    local source, children = parse_line(v)
    if source then
      local acc = {}
      for _, v in ipairs(children) do
        acc[v] = true
      end
      graph[source] =acc
    end
  end
  return graph
end

function day12_part1(input)
  local graph = build_graph(input)
  return #common.find_group(graph, 0)
end

function day12_part2(input)
  local graph = build_graph(input)
  return common.count_groups(graph)
end

--[[
  Tests Part 1
]]
assert(day12_part1 [[
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
]] == 6)

--[[
  Tests Part 2
]]
assert(day12_part2 [[
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
]] == 2)

--Answers
local puzzle_input = common.puzzle_input (12)
print("Day 12, Part 1: ", day12_part1(puzzle_input)) --134
print("Day 12, Part 2: ", day12_part2(puzzle_input)) --193
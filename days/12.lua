local common = require "common"

local function find_group(graph, start)
  local stack = {start}
  local total = 0
  local visited = {}
  while #stack > 0 do
    local n = table.remove(stack)
    if not visited[n] then
      visited[n] = true
      total = total + 1
      common.append(stack, graph[n])
    end
  end
  return common.keys(visited)
end

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
      graph[source] = children
    end
  end
  return graph
end

function day12_part1(input)
  local graph = build_graph(input)
  return #find_group(graph, 0)
end

function day12_part2(input)
  local graph = build_graph(input)
  local start = next(graph) --start from an arbitrary node
  local groups = 0
  while start do --stop when there are no nodes remaining to consider.
    groups = groups + 1 --count this group
    local group = find_group(graph, start) --get the set of all nodes connected to start, (including start)
    for _, node in ipairs(group) do
      graph[node] = nil --remove these nodes from the graph
    end
    start = next(graph) --get any node still in the graph
  end
  return groups
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
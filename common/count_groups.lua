return function(common)

local function find_group(graph, start)
  local stack = {start}
  local total = 0
  local visited = {}
  while #stack > 0 do
    local n = table.remove(stack)
    if not visited[n] then
      visited[n] = true
      total = total + 1
      for k, _ in pairs(graph[n]) do
        table.insert(stack, k)
      end
    end
  end
  return common.keys(visited)
end
local function count_groups(graph)
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
  
  return count_groups, find_group
end
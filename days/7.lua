local common = require "common"

local function build_tree(input)
  local links = {}
  for _, line in ipairs(common.lines(input)) do
    local name, weight, children
    name, weight = string.match(line, "^(%a+) %((%d+)%)")
    children = string.match(line, "%-%> ([%C]+)")
    links[name] = {
      name = name,
      weight = tonumber(weight),
      children = common.split(children or "", "[%s%,]+")
    }
  end
  
  --pass 2: assign parents
  for n, v in pairs(links) do
    for _, child in ipairs(v.children) do
      links[child].parent = v
    end
  end
  
  --from an arbitrary link, recursively find the root.
  local _, current = next(links)
  while current.parent do
    current = current.parent
  end
  
  return links, current
end

function day7_part1(input)
  local _, root = build_tree(input)
  return root.name
end

function day7_part2(input)
  local links, root = build_tree(input)
  
  local function get_total_weight(node)
    local total_weight = node.weight
    for _, child in ipairs(node.children) do
      total_weight = total_weight + get_total_weight(links[child])
    end
    node.total_weight = total_weight
    return total_weight
  end
  
  get_total_weight(root)
  
  --if a node has the wrong weight, all its parents
  --will have the wrong weight.
  --therefore we need to depth-first search for the bad node.
  --starting from the root, we know that it will be unbalanced.
  --recurse on the first unbalanced child.
  --stop when a node has no unbalanced children
  local function is_unbalanced(node)
    --a node is unbalanced if the total weights of its children are not the same.
    local total_weights_of_children = common.map(function(n) return links[n].total_weight end, node.children)
    local unique = common.set(total_weights_of_children)
    return #unique ~= 1
  end
  local function depth_first_unbalanced(node)
    for _, child in ipairs(node.children) do
      if is_unbalanced(links[child]) then
        return depth_first_unbalanced(links[child])
      end
    end
    return node
  end
  local grumpy = depth_first_unbalanced(root)
  local children = common.map(function(n) return links[n] end, grumpy.children)
  local naughty = common.odd_one_out_by(children, function(child) return child.total_weight end)
  assert(naughty)
  local nice = links[common.filter(common.not_equals(naughty.name), grumpy.children)[1]]
  local correct_weight = (nice.total_weight - naughty.total_weight) + naughty.weight
  return correct_weight
end

--[[
  Tests Part 1
]]
assert(day7_part1 [[
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)]] == "tknk")

--[[
  Tests Part 2
]]
assert(day7_part2 [[
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)]] == 60)

--Answers
local puzzle_input = common.puzzle_input (7)
print("Day 7, Part 1: ", day7_part1(puzzle_input)) --eqgvf
print("Day 7, Part 2: ", day7_part2(puzzle_input)) --757
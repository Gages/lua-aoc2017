local common = require "common"

local htb = {}
htb["0"] = "0000"
htb["1"] = "0001"
htb["2"] = "0010"
htb["3"] = "0011"
htb["4"] = "0100"
htb["5"] = "0101"
htb["6"] = "0110"
htb["7"] = "0111"
htb["8"] = "1000"
htb["9"] = "1001"
htb["a"] = "1010"
htb["b"] = "1011"
htb["c"] = "1100"
htb["d"] = "1101"
htb["e"] = "1110"
htb["f"] = "1111"
local function hextobit(h)
  return htb[h]
end

local function hashtobitstring(hash)
  return common.map(tonumber, common.fmap(common.chars, common.map(hextobit, common.chars(hash))))
end
local function build_grid(input)
  local hashes = common.map(function(i) return common.knot_hash(input .. "-" .. i) end, common.range(128))
  return common.map(hashtobitstring, hashes)
end

function day14_part1(input)
  return common.sum(common.map(tonumber, common.join(build_grid(input))))
end

function day14_part2(input)
  local grid = build_grid(input)
  local graph = {}
  local function add_link(addra, addrb)
    graph[addra] = graph[addra] or {}
    graph[addrb] = graph[addrb] or {}
    graph[addra][addrb] = true
    graph[addrb][addra] = true
  end
  local function address(r, c) return string.format("%d:%d", r, c) end
  local function neighbour_cells(r, c)
    return  grid[r][c] --middle
    ,       grid[r-1] and grid[r-1][c] --top
    ,       grid[r][c+1] --right
    ,       grid[r][c-1] --left
    ,       grid[r+1] and grid[r+1][c] --bottom
  end
  for r=1,128 do
    for c=1,128 do
      local middle,top,right,left,bottom = neighbour_cells(r,c)
      if middle == 1 then
        local addr = address(r,c)
        add_link(addr, addr)
        if top == 1 then add_link(addr, address(r-1,c)) end
        if right == 1 then add_link(addr, address(r,c+1)) end
        if left == 1 then add_link(addr, address(r,c-1)) end
        if bottom == 1 then add_link(addr, address(r+1,c)) end
      end
    end
  end
  return common.count_groups(graph)
end

--[[
  Tests Part 1
]]
assert(day14_part1 "flqrgnkx" == 8108)

--[[
  Tests Part 2
]]
assert(day14_part2 "flqrgnkx" == 1242)

--Answers
local puzzle_input = "jxqlasbh"
print("Day 14, Part 1: ", day14_part1(puzzle_input)) --8140
print("Day 14, Part 2: ", day14_part2(puzzle_input)) --1182
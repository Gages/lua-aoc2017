local common = require "common"

local function build_initial_state(input)
  local lines = common.lines(input)
  local maxdepth = 0
  local range, dir, pos = {}, {}, {}
  for _, v in ipairs(lines) do
    local d, r = string.match(v, "(%d+)%: (%d+)")
    if d then
      d, r = tonumber(d)+1, tonumber(r)
      maxdepth = math.max(maxdepth, d)
      range[d] = r
    end
  end
  for i=1,maxdepth do
    range[i] = range[i] or 0
    dir[i] = 1
    pos[i] = 1
  end
  return {range = range, dir = dir, pos = pos, maxdepth = maxdepth}
end

local function is_caught(state, i)
  return state.range[i] > 0 and state.pos[i] == 1
end

local function step_picosecond(state)
  for i=1,state.maxdepth do
    local range, dir, pos = state.range, state.dir, state.pos
    if range[i] > 0 then
      pos[i] = pos[i] + dir[i]
      if pos[i] == 1 or pos[i] == range[i] then
        dir[i] = -dir[i]
      end
      assert(pos[i] >= 1 and pos[i] <= range[i])
    end
  end
end

function day13_part1(input)
 local state = build_initial_state(input)
 local total_severity = 0
 for depth=1,state.maxdepth do
    if is_caught(state, depth) then
      total_severity = total_severity + state.range[depth] * (depth - 1)
    end
    step_picosecond(state)
  end
  return total_severity
end

function day13_part2(input)
  local state = build_initial_state(input)
  local agents = {}
  local picosecond = 0
  while true do
    table.insert(agents, {1, picosecond})
--  print('picosecond ' .. picosecond .. ' with ' .. #agents .. ' agents. (Spawned agent #' .. picosecond .. ')')
    local i = 1
    while i <= #agents do
      local depth, origin = unpack(agents[i])
--    print('agent #' .. origin .. ' at ' .. depth)
      if is_caught(state, depth) then
--      print('agent #' .. origin .. ' got caught')
        table.remove(agents, i)
      else
        if depth == state.maxdepth then
--        print('agent ' .. origin .. ' reached the goal')
          return origin
        end      
        agents[i][1] = depth + 1
        i = i + 1
      end
    end
    step_picosecond(state)
    picosecond = picosecond + 1
   end
end

--[[
  Tests Part 1
]]
assert(day13_part1 [[
0: 3
1: 2
4: 4
6: 4
]] == 24)

--[[
  Tests Part 2
]]
assert(day13_part2 [[
0: 3
1: 2
4: 4
6: 4
]] == 10)

--Answers
local puzzle_input = common.puzzle_input (13)
print("Day 13, Part 1: ", day13_part1(puzzle_input)) --1928
print("Day 13, Part 2: ", day13_part2(puzzle_input)) --3830344